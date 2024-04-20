#include "types.h"
#include "param.h"
#include "defs.h"
#include "mmu.h"
#include "memlayout.h"
#include "x86.h"
#include "proc.h"
#include "fs.h"

struct swapslothdr {
	uint is_free;
	uint page_perm;
	uint blockno;
};
#define BPPAGE (PGSIZE/BSIZE)
#define FREE 1
#define NOT_FREE 0

#define SWAPBASE 2
#define NPAGE (NSWAP / BPPAGE)

struct swapslothdr swap_slots[NPAGE];

void swapinit(void){
	for(int i = 0 ; i < NPAGE ; i++){
		swap_slots[i].is_free = FREE;
		swap_slots[i].page_perm = 0;
		swap_slots[i].blockno = SWAPBASE + i * BPPAGE;
	}
	cprintf("Swap slots initialized\n");
}
static pte_t*
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

void swap_out(){
	pte_t* pte = final_page();
	for(int i = 0 ; i < NPAGE; i++){
		if(swap_slots[i].is_free == FREE){
			swap_slots[i].is_free = NOT_FREE;
			swap_slots[i].page_perm = PTE_FLAGS(*pte);
			uint pa = PTE_ADDR(*pte);
			write_page_to_swap(swap_slots[i].blockno, (char*)P2V(pa));
			kfree((char*)P2V(pa));
			*pte = swap_slots[i].blockno << PTXSHIFT;
			*pte |= PTE_FLAGS(*pte);
			*pte |= PTE_SW;
			*pte &= ~PTE_P;
			return;
		}
	}
	// panic("Swap full\n");
}
void clear_slot(pte_t* page){
	int blockno = PTE_ADDR(*page) >> PTXSHIFT;
	swap_slots[(blockno - SWAPBASE) / BPPAGE].is_free = FREE;
}
void handle_page_fault(){
	uint va = rcr2();
	char * pg = kalloc();
	struct proc* p = myproc();
	p->rss += PGSIZE;
	pte_t * pte = walkpgdir(p->pgdir, (void*) va, 0);
	uint blockno = *pte >> PTXSHIFT;
	read_page_from_swap(blockno, pg);
	int swap_slot_i = (blockno - SWAPBASE) / BPPAGE;
	*pte = (V2P(pg) & ~0xFFF)  | swap_slots[swap_slot_i].page_perm;
	*pte |= PTE_P;
	swap_slots[swap_slot_i].is_free = FREE;
}
