#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"
#include "fs.h"
struct swapslothdr {
	uint is_free;
	uint page_perm;
	uint blockno;
	// list of all pte_t * pointing to this page
	int refcnt_to_disk;

};

#define BPPAGE (PGSIZE/BSIZE)
#define FREE 1
#define NOT_FREE 0

#define SWAPBASE 2
#define NPAGE (SWAPBLOCKS / BPPAGE)

struct swapslothdr swap_slots[NPAGE];
void swapinit(void){
	for(int i = 0 ; i < NPAGE ; i++){
		swap_slots[i].is_free = FREE;
		swap_slots[i].page_perm = 0;
		swap_slots[i].blockno = SWAPBASE + i * BPPAGE;
	}
	cprintf("Swap slots initialized\n");
}
static pte_t *
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
	// int * page_to_refcnt = get_refcnt_table();
	pte_t* pte = final_page();
	for(int i = 0 ; i < NPAGE; i++){
		if(swap_slots[i].is_free == FREE){
			swap_slots[i].is_free = NOT_FREE;
			swap_slots[i].page_perm = PTE_FLAGS(*pte);
			uint pa = PTE_ADDR(*pte);
			write_page_to_swap(swap_slots[i].blockno, (char*)P2V(pa));

			// int refcnt = page_to_refcnt[pa >> PTXSHIFT];
			// this is needed because when we are swapping out a page that is referred to by 
			// multiple page table entries, we need to free the page only when all the references are gone
			// swap_slots[i].refcnt_to_disk = refcnt;
			// for(int i = 0 ; i < refcnt; i++){
				kfree((char*)P2V(pa));
			// }

			*pte = swap_slots[i].blockno << PTXSHIFT;
			*pte |= PTE_FLAGS(*pte);
			*pte |= PTE_SW;
			*pte &= ~PTE_P;
			return;
		}
	}
	panic("Swap full\n");
}
// the following function is called when a copy is needed to be created for the page pointed to by pte
// constratin : pte is present in the pagetable
void cow_page(pte_t * pte){
	char * copy_mem = kalloc();
	int * page_to_refcnt = get_refcnt_table();
	// allocating new page using kalloc
	if(copy_mem == 0){
		panic("kalloc failing in cow_page\n");
	}
	// whe arent we setting the refcnt of the new page to 1
	cprintf("before refcnt = %d", page_to_refcnt[(*pte) >> PTXSHIFT]);
	page_to_refcnt[(*pte) >> PTXSHIFT]--;
	cprintf("after refcnt = %d", page_to_refcnt[(*pte) >> PTXSHIFT]);

	memmove(copy_mem, (char*)P2V(PTE_ADDR(*pte)), PGSIZE);
	// now modify the pgdir
	*pte = V2P(copy_mem) | PTE_FLAGS(*pte) | PTE_W;
	lcr3(V2P(myproc()->pgdir));

}

void clear_slot(pte_t* page){
	int blockno = PTE_ADDR(*page) >> PTXSHIFT;
	swap_slots[(blockno - SWAPBASE) / BPPAGE].is_free = FREE;
}
int dec_swap_slot_refcnt(pte_t * pte){
	int blockno = PTE_ADDR(*pte) >> PTXSHIFT;
	int x = swap_slots[(blockno - SWAPBASE) / BPPAGE].refcnt_to_disk;
	if(x == 0){
		panic("refcnt already 0\n");
	}
	return --(swap_slots[(blockno - SWAPBASE) / BPPAGE].refcnt_to_disk);
};
void handle_page_fault(){
	// cprintf("Page fault\n");
	int * page_to_refcnt = get_refcnt_table();
	uint va = rcr2();
	struct proc* p = myproc();
	pte_t * pte = walkpgdir(p->pgdir, (void*) va, 0);
	if(*pte & PTE_P){
		// 
		cprintf("page fault due to cow\n");
		if(page_to_refcnt[*pte >> PTXSHIFT] > 1){
			// copy on write
			cow_page(pte);
		}
		else {
			// normal pagefault
			// give the write flag when single reference
			cprintf("no duplicatin is needed for pg = %d", *pte >> PTXSHIFT);
			*pte = *pte | PTE_W;
			lcr3(V2P(p->pgdir));
		}
	}
	else {
		cprintf("normal pagefault\n");
		char * pg = kalloc();
		if(pg == 0){
			panic("kalloc failing in pagefault\n");
		}
		p->rss += PGSIZE;
		// pte_t * pte = walkpgdir(p->pgdir, (void*) va, 0);
		uint blockno = *pte >> PTXSHIFT;
		read_page_from_swap(blockno, pg);
		int swap_slot_i = (blockno - SWAPBASE) / BPPAGE;
		int * page_to_refcnt = get_refcnt_table();
		page_to_refcnt[(*pte) >> PTXSHIFT] = swap_slots[swap_slot_i].refcnt_to_disk;
		*pte = (V2P(pg) & ~0xFFF)  | swap_slots[swap_slot_i].page_perm;
		*pte |= PTE_P;
		swap_slots[swap_slot_i].is_free = FREE;
	}
}