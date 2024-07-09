# Copy on Write and Swapping in xv6
### We introduce the features of swapping and Copy on Write in the xv6 Operating System
- Whenever a new page is copied, until and unless we make a write to the new page, the allocated virtual memory can be allocated to the same page physically. Only when we make a write, we need to allocate a new physical page. This optimization is known as Copy-on-Write.
- Swapping refers to the technique in which after we utilise the disk space as RAM when it starts getting full.


<img width="718" alt="Screenshot 2024-07-09 at 9 46 44 PM" src="https://github.com/andTEJAsan/Copy-on-Write-with-Swapping-in-xv6/assets/122673067/118d0324-aa63-4ab2-a3e3-8dec11bb9f26">
