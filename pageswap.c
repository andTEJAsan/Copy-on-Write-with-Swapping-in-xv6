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
	pte_t* proc_pte_refs[NPROC];
	int proc_pid_refs[NPROC];


};
uint page_to_ref_cnt[PHYSTOP >> PTXSHIFT];
pte_t* page_to_ptes_map[PHYSTOP >> PTXSHIFT][NPROC];
int page_to_proc_pid_map[PHYSTOP >> PTXSHIFT][NPROC];

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

void swap_info_on_hdr(uint pa, uint slot_num){
    swap_slots[slot_num].refcnt_to_disk = page_to_ref_cnt[pa>>PTXSHIFT];

    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
        pte_t *pte = page_to_ptes_map[pa >> PTXSHIFT][i];
        swap_slots[slot_num].proc_pte_refs[i] = pte;
        swap_slots[slot_num].proc_pid_refs[i] = page_to_proc_pid_map[pa >> PTXSHIFT][i];
        *pte = (slot_num << PTXSHIFT) | PTE_FLAGS(*pte) | PTE_SW;
        *pte &= (~PTE_P);
	update_rss(swap_slots[slot_num].proc_pid_refs[i], -PGSIZE);
    }
	page_to_ref_cnt[pa >> PTXSHIFT] = 0; // no longer on the memory
}

void get_hdrs_from_disk(uint pa, uint slot_num)
{
    page_to_ref_cnt[pa >> PTXSHIFT]  = swap_slots[slot_num].refcnt_to_disk;
    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
        pte_t *pte = swap_slots[slot_num].proc_pte_refs[i];
        *pte = pa | (PTE_FLAGS(*pte)) | PTE_P;
        *pte &= ~PTE_SW;
        page_to_ptes_map[pa >> PTXSHIFT][i] = pte;
        page_to_proc_pid_map[pa >> PTXSHIFT][i] = swap_slots[slot_num].proc_pid_refs[i];
	update_rss(swap_slots[slot_num].proc_pid_refs[i], PGSIZE);
    }
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


void inc_refcnt_in_memory(uint pa, pte_t* pte, int pid){
    page_to_ptes_map[pa >> PTXSHIFT][page_to_ref_cnt[pa >> PTXSHIFT]] = pte;
    page_to_proc_pid_map[pa >> PTXSHIFT][page_to_ref_cnt[pa >> PTXSHIFT]] = pid;
    page_to_ref_cnt[pa >> PTXSHIFT] += 1;
    update_rss(pid, PGSIZE);
}


void inc_refcnt_in_hdr(int slot_no_i, pte_t *pte, int pid)
{
    swap_slots[slot_no_i].proc_pte_refs[swap_slots[slot_no_i].refcnt_to_disk] = pte;
    swap_slots[slot_no_i].proc_pid_refs[swap_slots[slot_no_i].refcnt_to_disk] = pid;
    swap_slots[slot_no_i].refcnt_to_disk += 1;
}
void dec_refcnt_in_memory(uint pa, pte_t* pte)
{
    for (int i = 0; i < page_to_ref_cnt[pa>>PTXSHIFT]; i++){
        if (page_to_ptes_map[pa>>PTXSHIFT][i] == pte){
		update_rss(page_to_proc_pid_map[pa >> PTXSHIFT][i], -PGSIZE);
		for (int j = i; j < page_to_ref_cnt[pa >> PTXSHIFT] - 1; j++)
		{
			// shift to left
			page_to_ptes_map[pa >> PTXSHIFT][j] = page_to_ptes_map[pa >> PTXSHIFT][j + 1];
			page_to_proc_pid_map[pa >> PTXSHIFT][j] = page_to_proc_pid_map[pa >> PTXSHIFT][j + 1];
		}
		page_to_ref_cnt[pa >> PTXSHIFT] -= 1;
        }
	return;
    }
	panic("pte not found in decrementing");
}

void dec_refcnt_in_hdr(int slot_no_i, pte_t *pte)
{

    for (int i = 0; i < swap_slots[slot_no_i].refcnt_to_disk; i++)
    {
        if (swap_slots[slot_no_i].proc_pte_refs[i] == pte)
        {
		      
		for (int j = i; j < swap_slots[slot_no_i].refcnt_to_disk - 1; j++)
		{
			// shift to left
			swap_slots[slot_no_i].proc_pid_refs[j] = swap_slots[slot_no_i].proc_pid_refs[j + 1];
			swap_slots[slot_no_i].proc_pte_refs[j] = swap_slots[slot_no_i].proc_pte_refs[j + 1];
		}
		swap_slots[slot_no_i].refcnt_to_disk -= 1;
		if (swap_slots[slot_no_i].refcnt_to_disk == 0)
		{
			swap_slots[slot_no_i].is_free = FREE;
		}
        }
	return;
    }
	// cprintf("%x %x\n", pte, *pte);
	panic("pte not found in decrementing");
}

uint get_refcnt(uint pa)
{
    return page_to_ref_cnt[pa >> PTXSHIFT];
}

void init_refcnt(uint pa)
{
    page_to_ref_cnt[pa >> PTXSHIFT] = 0;
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
			swap_info_on_hdr(pa, i);
			// int refcnt = page_to_refcnt[pa >> PTXSHIFT];
			// this is needed because when we are swapping out a page that is referred to by 
			// multiple page table entries, we need to free the page only when all the references are gone
			// swap_slots[i].refcnt_to_disk = refcnt;
			// for(int i = 0 ; i < refcnt; i++){
			kfree((char*)P2V(pa));
			// }
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

void handle_page_fault(void)
{
    uint va = rcr2();
    pte_t *pte = walkpgdir(myproc()->pgdir, (void *)va, 0);
    if ((*pte & PTE_P))
    {
	// cow fault has occured
        if (!(*pte & PTE_W)){
		char *mem;
		uint flags = PTE_FLAGS(*pte);
		uint pa = PTE_ADDR(*pte);
		if (get_refcnt(pa) > 1){
			if ((mem = kalloc()) == 0){
				panic("kalloc failed in handle page fault");
			}
			inc_refcnt_in_memory(V2P(mem), pte, myproc()->pid);
			if (*pte & PTE_P){
				// if in memory
				dec_refcnt_in_memory(pa, pte);
			}
			else if (*pte & PTE_SW)
			{
				// if swapped
				int slot_no_i = pa >> PTXSHIFT;
				dec_refcnt_in_hdr(slot_no_i, pte);
			}
			
			memmove(mem, (char *)P2V(pa), PGSIZE);
			*pte = V2P(mem) | PTE_W | flags;
			lcr3(V2P(myproc()->pgdir));
			
			return;
			// remove returns later
		}
		else {
			// if refcnt is 1, we can make the page writeable, we dont need to copy
			*pte |= PTE_W;
			return;
		}
        }
    } else { 
        if (!(*pte & PTE_SW)){
            panic("page not present nor swapped");
        }
	else
	{
            int slot_no_i = (*pte) >> PTXSHIFT;
            swap_slots[slot_no_i].is_free = FREE;
            char *pg = kalloc();
            write_page_to_swap(swap_slots[slot_no_i].blockno, pg);
	    get_hdrs_from_disk(V2P(pg), slot_no_i);
        }

    }
}