
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 40 8a 11 80       	mov    $0x80118a40,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 20 32 10 80       	mov    $0x80103220,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 7d 10 80       	push   $0x80107d40
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 e5 47 00 00       	call   80104840 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 7d 10 80       	push   $0x80107d47
80100097:	50                   	push   %eax
80100098:	e8 73 46 00 00       	call   80104710 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 47 49 00 00       	call   80104a30 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 69 48 00 00       	call   801049d0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 45 00 00       	call   80104750 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 2f 22 00 00       	call   801023c0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 4e 7d 10 80       	push   $0x80107d4e
801001a6:	e8 c5 02 00 00       	call   80100470 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 2d 46 00 00       	call   801047f0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 e7 21 00 00       	jmp    801023c0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 7d 10 80       	push   $0x80107d5f
801001e1:	e8 8a 02 00 00       	call   80100470 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ec 45 00 00       	call   801047f0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 9c 45 00 00       	call   801047b0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 10 48 00 00       	call   80104a30 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 62 47 00 00       	jmp    801049d0 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 66 7d 10 80       	push   $0x80107d66
80100276:	e8 f5 01 00 00       	call   80100470 <panic>
8010027b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010027f:	90                   	nop

80100280 <write_page_to_swap>:
//PAGEBREAK!
// Blank page.

void write_page_to_swap(uint blockno, char * va){
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 1c             	sub    $0x1c,%esp
80100289:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010028f:	8d 43 08             	lea    0x8(%ebx),%eax
80100292:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100295:	8d 76 00             	lea    0x0(%esi),%esi
  struct buf * b;
  for(int i = 0 ; i  < PGSIZE/BSIZE; i++){
    b = bread(ROOTDEV, blockno + i);
80100298:	83 ec 08             	sub    $0x8,%esp
8010029b:	53                   	push   %ebx
8010029c:	6a 01                	push   $0x1
8010029e:	e8 2d fe ff ff       	call   801000d0 <bread>
    memmove(b->data, va + i * BSIZE, BSIZE);
801002a3:	83 c4 0c             	add    $0xc,%esp
    b = bread(ROOTDEV, blockno + i);
801002a6:	89 c7                	mov    %eax,%edi
    memmove(b->data, va + i * BSIZE, BSIZE);
801002a8:	8d 40 5c             	lea    0x5c(%eax),%eax
801002ab:	68 00 02 00 00       	push   $0x200
801002b0:	56                   	push   %esi
801002b1:	50                   	push   %eax
801002b2:	e8 09 49 00 00       	call   80104bc0 <memmove>
  if(!holdingsleep(&b->lock))
801002b7:	8d 47 0c             	lea    0xc(%edi),%eax
801002ba:	89 04 24             	mov    %eax,(%esp)
801002bd:	e8 2e 45 00 00       	call   801047f0 <holdingsleep>
801002c2:	83 c4 10             	add    $0x10,%esp
801002c5:	85 c0                	test   %eax,%eax
801002c7:	74 2f                	je     801002f8 <write_page_to_swap+0x78>
  iderw(b);
801002c9:	83 ec 0c             	sub    $0xc,%esp
  b->flags |= B_DIRTY;
801002cc:	83 0f 04             	orl    $0x4,(%edi)
  for(int i = 0 ; i  < PGSIZE/BSIZE; i++){
801002cf:	83 c3 01             	add    $0x1,%ebx
801002d2:	81 c6 00 02 00 00    	add    $0x200,%esi
  iderw(b);
801002d8:	57                   	push   %edi
801002d9:	e8 e2 20 00 00       	call   801023c0 <iderw>
    bwrite(b);
    brelse(b);
801002de:	89 3c 24             	mov    %edi,(%esp)
801002e1:	e8 0a ff ff ff       	call   801001f0 <brelse>
  for(int i = 0 ; i  < PGSIZE/BSIZE; i++){
801002e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801002e9:	83 c4 10             	add    $0x10,%esp
801002ec:	39 c3                	cmp    %eax,%ebx
801002ee:	75 a8                	jne    80100298 <write_page_to_swap+0x18>
  }
}
801002f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002f3:	5b                   	pop    %ebx
801002f4:	5e                   	pop    %esi
801002f5:	5f                   	pop    %edi
801002f6:	5d                   	pop    %ebp
801002f7:	c3                   	ret
    panic("bwrite");
801002f8:	83 ec 0c             	sub    $0xc,%esp
801002fb:	68 5f 7d 10 80       	push   $0x80107d5f
80100300:	e8 6b 01 00 00       	call   80100470 <panic>
80100305:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100310 <read_page_from_swap>:
void read_page_from_swap(uint blockno , char * va){
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
80100313:	57                   	push   %edi
80100314:	56                   	push   %esi
80100315:	53                   	push   %ebx
80100316:	83 ec 1c             	sub    $0x1c,%esp
80100319:	8b 7d 08             	mov    0x8(%ebp),%edi
8010031c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010031f:	8d 47 08             	lea    0x8(%edi),%eax
80100322:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100325:	8d 76 00             	lea    0x0(%esi),%esi
  struct buf * b;
  for(int i = 0 ; i < PGSIZE/BSIZE; i++){
    b = bread(ROOTDEV, blockno + i);
80100328:	83 ec 08             	sub    $0x8,%esp
8010032b:	57                   	push   %edi
  for(int i = 0 ; i < PGSIZE/BSIZE; i++){
8010032c:	83 c7 01             	add    $0x1,%edi
    b = bread(ROOTDEV, blockno + i);
8010032f:	6a 01                	push   $0x1
80100331:	e8 9a fd ff ff       	call   801000d0 <bread>
    memmove(va + i * BSIZE, b->data, BSIZE);
80100336:	83 c4 0c             	add    $0xc,%esp
    b = bread(ROOTDEV, blockno + i);
80100339:	89 c3                	mov    %eax,%ebx
    memmove(va + i * BSIZE, b->data, BSIZE);
8010033b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010033e:	68 00 02 00 00       	push   $0x200
80100343:	50                   	push   %eax
80100344:	56                   	push   %esi
  for(int i = 0 ; i < PGSIZE/BSIZE; i++){
80100345:	81 c6 00 02 00 00    	add    $0x200,%esi
    memmove(va + i * BSIZE, b->data, BSIZE);
8010034b:	e8 70 48 00 00       	call   80104bc0 <memmove>
    brelse(b);
80100350:	89 1c 24             	mov    %ebx,(%esp)
80100353:	e8 98 fe ff ff       	call   801001f0 <brelse>
  for(int i = 0 ; i < PGSIZE/BSIZE; i++){
80100358:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035b:	83 c4 10             	add    $0x10,%esp
8010035e:	39 c7                	cmp    %eax,%edi
80100360:	75 c6                	jne    80100328 <read_page_from_swap+0x18>
  }
}
80100362:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100365:	5b                   	pop    %ebx
80100366:	5e                   	pop    %esi
80100367:	5f                   	pop    %edi
80100368:	5d                   	pop    %ebp
80100369:	c3                   	ret
8010036a:	66 90                	xchg   %ax,%ax
8010036c:	66 90                	xchg   %ax,%ax
8010036e:	66 90                	xchg   %ax,%ax

80100370 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	57                   	push   %edi
80100374:	56                   	push   %esi
80100375:	53                   	push   %ebx
80100376:	83 ec 18             	sub    $0x18,%esp
80100379:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010037c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010037f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100382:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100384:	e8 e7 15 00 00       	call   80101970 <iunlock>
  acquire(&cons.lock);
80100389:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80100390:	e8 9b 46 00 00       	call   80104a30 <acquire>
  while(n > 0){
80100395:	83 c4 10             	add    $0x10,%esp
80100398:	85 db                	test   %ebx,%ebx
8010039a:	0f 8e 94 00 00 00    	jle    80100434 <consoleread+0xc4>
    while(input.r == input.w){
801003a0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801003a5:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
801003ab:	74 25                	je     801003d2 <consoleread+0x62>
801003ad:	eb 59                	jmp    80100408 <consoleread+0x98>
801003af:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801003b0:	83 ec 08             	sub    $0x8,%esp
801003b3:	68 20 ff 10 80       	push   $0x8010ff20
801003b8:	68 00 ff 10 80       	push   $0x8010ff00
801003bd:	e8 ce 3e 00 00       	call   80104290 <sleep>
    while(input.r == input.w){
801003c2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801003c7:	83 c4 10             	add    $0x10,%esp
801003ca:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801003d0:	75 36                	jne    80100408 <consoleread+0x98>
      if(myproc()->killed){
801003d2:	e8 69 37 00 00       	call   80103b40 <myproc>
801003d7:	8b 48 28             	mov    0x28(%eax),%ecx
801003da:	85 c9                	test   %ecx,%ecx
801003dc:	74 d2                	je     801003b0 <consoleread+0x40>
        release(&cons.lock);
801003de:	83 ec 0c             	sub    $0xc,%esp
801003e1:	68 20 ff 10 80       	push   $0x8010ff20
801003e6:	e8 e5 45 00 00       	call   801049d0 <release>
        ilock(ip);
801003eb:	5a                   	pop    %edx
801003ec:	ff 75 08             	push   0x8(%ebp)
801003ef:	e8 9c 14 00 00       	call   80101890 <ilock>
        return -1;
801003f4:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801003f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
801003fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801003ff:	5b                   	pop    %ebx
80100400:	5e                   	pop    %esi
80100401:	5f                   	pop    %edi
80100402:	5d                   	pop    %ebp
80100403:	c3                   	ret
80100404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100408:	8d 50 01             	lea    0x1(%eax),%edx
8010040b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100411:	89 c2                	mov    %eax,%edx
80100413:	83 e2 7f             	and    $0x7f,%edx
80100416:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010041d:	80 f9 04             	cmp    $0x4,%cl
80100420:	74 37                	je     80100459 <consoleread+0xe9>
    *dst++ = c;
80100422:	83 c6 01             	add    $0x1,%esi
    --n;
80100425:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100428:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010042b:	83 f9 0a             	cmp    $0xa,%ecx
8010042e:	0f 85 64 ff ff ff    	jne    80100398 <consoleread+0x28>
  release(&cons.lock);
80100434:	83 ec 0c             	sub    $0xc,%esp
80100437:	68 20 ff 10 80       	push   $0x8010ff20
8010043c:	e8 8f 45 00 00       	call   801049d0 <release>
  ilock(ip);
80100441:	58                   	pop    %eax
80100442:	ff 75 08             	push   0x8(%ebp)
80100445:	e8 46 14 00 00       	call   80101890 <ilock>
  return target - n;
8010044a:	89 f8                	mov    %edi,%eax
8010044c:	83 c4 10             	add    $0x10,%esp
}
8010044f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100452:	29 d8                	sub    %ebx,%eax
}
80100454:	5b                   	pop    %ebx
80100455:	5e                   	pop    %esi
80100456:	5f                   	pop    %edi
80100457:	5d                   	pop    %ebp
80100458:	c3                   	ret
      if(n < target){
80100459:	39 fb                	cmp    %edi,%ebx
8010045b:	73 d7                	jae    80100434 <consoleread+0xc4>
        input.r--;
8010045d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100462:	eb d0                	jmp    80100434 <consoleread+0xc4>
80100464:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010046b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010046f:	90                   	nop

80100470 <panic>:
{
80100470:	55                   	push   %ebp
80100471:	89 e5                	mov    %esp,%ebp
80100473:	56                   	push   %esi
80100474:	53                   	push   %ebx
80100475:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100478:	fa                   	cli
  cons.locking = 0;
80100479:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100480:	00 00 00 
  getcallerpcs(&s, pcs);
80100483:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100486:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100489:	e8 32 26 00 00       	call   80102ac0 <lapicid>
8010048e:	83 ec 08             	sub    $0x8,%esp
80100491:	50                   	push   %eax
80100492:	68 6d 7d 10 80       	push   $0x80107d6d
80100497:	e8 04 03 00 00       	call   801007a0 <cprintf>
  cprintf(s);
8010049c:	58                   	pop    %eax
8010049d:	ff 75 08             	push   0x8(%ebp)
801004a0:	e8 fb 02 00 00       	call   801007a0 <cprintf>
  cprintf("\n");
801004a5:	c7 04 24 0b 82 10 80 	movl   $0x8010820b,(%esp)
801004ac:	e8 ef 02 00 00       	call   801007a0 <cprintf>
  getcallerpcs(&s, pcs);
801004b1:	8d 45 08             	lea    0x8(%ebp),%eax
801004b4:	5a                   	pop    %edx
801004b5:	59                   	pop    %ecx
801004b6:	53                   	push   %ebx
801004b7:	50                   	push   %eax
801004b8:	e8 a3 43 00 00       	call   80104860 <getcallerpcs>
  for(i=0; i<10; i++)
801004bd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801004c0:	83 ec 08             	sub    $0x8,%esp
801004c3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801004c5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801004c8:	68 81 7d 10 80       	push   $0x80107d81
801004cd:	e8 ce 02 00 00       	call   801007a0 <cprintf>
  for(i=0; i<10; i++)
801004d2:	83 c4 10             	add    $0x10,%esp
801004d5:	39 f3                	cmp    %esi,%ebx
801004d7:	75 e7                	jne    801004c0 <panic+0x50>
  panicked = 1; // freeze other CPU
801004d9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801004e0:	00 00 00 
  for(;;)
801004e3:	eb fe                	jmp    801004e3 <panic+0x73>
801004e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801004ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801004f0 <consputc.part.0>:
consputc(int c)
801004f0:	55                   	push   %ebp
801004f1:	89 e5                	mov    %esp,%ebp
801004f3:	57                   	push   %edi
801004f4:	56                   	push   %esi
801004f5:	53                   	push   %ebx
801004f6:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
801004f9:	3d 00 01 00 00       	cmp    $0x100,%eax
801004fe:	0f 84 cc 00 00 00    	je     801005d0 <consputc.part.0+0xe0>
    uartputc(c);
80100504:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100507:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010050c:	89 c3                	mov    %eax,%ebx
8010050e:	50                   	push   %eax
8010050f:	e8 7c 5c 00 00       	call   80106190 <uartputc>
80100514:	b8 0e 00 00 00       	mov    $0xe,%eax
80100519:	89 fa                	mov    %edi,%edx
8010051b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010051c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100521:	89 f2                	mov    %esi,%edx
80100523:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100524:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100527:	89 fa                	mov    %edi,%edx
80100529:	b8 0f 00 00 00       	mov    $0xf,%eax
8010052e:	c1 e1 08             	shl    $0x8,%ecx
80100531:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100532:	89 f2                	mov    %esi,%edx
80100534:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100535:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100538:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010053b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010053d:	83 fb 0a             	cmp    $0xa,%ebx
80100540:	75 76                	jne    801005b8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100542:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100547:	f7 e2                	mul    %edx
80100549:	c1 ea 06             	shr    $0x6,%edx
8010054c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010054f:	c1 e0 04             	shl    $0x4,%eax
80100552:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100555:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010055b:	0f 8f 2f 01 00 00    	jg     80100690 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100561:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100567:	0f 8f c3 00 00 00    	jg     80100630 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010056d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010056f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100576:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100579:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010057c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100581:	b8 0e 00 00 00       	mov    $0xe,%eax
80100586:	89 da                	mov    %ebx,%edx
80100588:	ee                   	out    %al,(%dx)
80100589:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010058e:	89 f8                	mov    %edi,%eax
80100590:	89 ca                	mov    %ecx,%edx
80100592:	ee                   	out    %al,(%dx)
80100593:	b8 0f 00 00 00       	mov    $0xf,%eax
80100598:	89 da                	mov    %ebx,%edx
8010059a:	ee                   	out    %al,(%dx)
8010059b:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010059f:	89 ca                	mov    %ecx,%edx
801005a1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801005a2:	b8 20 07 00 00       	mov    $0x720,%eax
801005a7:	66 89 06             	mov    %ax,(%esi)
}
801005aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005ad:	5b                   	pop    %ebx
801005ae:	5e                   	pop    %esi
801005af:	5f                   	pop    %edi
801005b0:	5d                   	pop    %ebp
801005b1:	c3                   	ret
801005b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801005b8:	0f b6 db             	movzbl %bl,%ebx
801005bb:	8d 70 01             	lea    0x1(%eax),%esi
801005be:	80 cf 07             	or     $0x7,%bh
801005c1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801005c8:	80 
801005c9:	eb 8a                	jmp    80100555 <consputc.part.0+0x65>
801005cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801005cf:	90                   	nop
    uartputc('\b'); uartputc(' '); uartputc('\b');
801005d0:	83 ec 0c             	sub    $0xc,%esp
801005d3:	be d4 03 00 00       	mov    $0x3d4,%esi
801005d8:	6a 08                	push   $0x8
801005da:	e8 b1 5b 00 00       	call   80106190 <uartputc>
801005df:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801005e6:	e8 a5 5b 00 00       	call   80106190 <uartputc>
801005eb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801005f2:	e8 99 5b 00 00       	call   80106190 <uartputc>
801005f7:	b8 0e 00 00 00       	mov    $0xe,%eax
801005fc:	89 f2                	mov    %esi,%edx
801005fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801005ff:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100604:	89 da                	mov    %ebx,%edx
80100606:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100607:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010060a:	89 f2                	mov    %esi,%edx
8010060c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100611:	c1 e1 08             	shl    $0x8,%ecx
80100614:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100615:	89 da                	mov    %ebx,%edx
80100617:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100618:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010061b:	83 c4 10             	add    $0x10,%esp
8010061e:	09 ce                	or     %ecx,%esi
80100620:	74 5e                	je     80100680 <consputc.part.0+0x190>
80100622:	83 ee 01             	sub    $0x1,%esi
80100625:	e9 2b ff ff ff       	jmp    80100555 <consputc.part.0+0x65>
8010062a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100630:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100633:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100636:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010063d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100642:	68 60 0e 00 00       	push   $0xe60
80100647:	68 a0 80 0b 80       	push   $0x800b80a0
8010064c:	68 00 80 0b 80       	push   $0x800b8000
80100651:	e8 6a 45 00 00       	call   80104bc0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100656:	b8 80 07 00 00       	mov    $0x780,%eax
8010065b:	83 c4 0c             	add    $0xc,%esp
8010065e:	29 d8                	sub    %ebx,%eax
80100660:	01 c0                	add    %eax,%eax
80100662:	50                   	push   %eax
80100663:	6a 00                	push   $0x0
80100665:	56                   	push   %esi
80100666:	e8 c5 44 00 00       	call   80104b30 <memset>
  outb(CRTPORT+1, pos);
8010066b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010066e:	83 c4 10             	add    $0x10,%esp
80100671:	e9 06 ff ff ff       	jmp    8010057c <consputc.part.0+0x8c>
80100676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010067d:	8d 76 00             	lea    0x0(%esi),%esi
80100680:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100684:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100689:	31 ff                	xor    %edi,%edi
8010068b:	e9 ec fe ff ff       	jmp    8010057c <consputc.part.0+0x8c>
    panic("pos under/overflow");
80100690:	83 ec 0c             	sub    $0xc,%esp
80100693:	68 85 7d 10 80       	push   $0x80107d85
80100698:	e8 d3 fd ff ff       	call   80100470 <panic>
8010069d:	8d 76 00             	lea    0x0(%esi),%esi

801006a0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 18             	sub    $0x18,%esp
801006a9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801006ac:	ff 75 08             	push   0x8(%ebp)
801006af:	e8 bc 12 00 00       	call   80101970 <iunlock>
  acquire(&cons.lock);
801006b4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801006bb:	e8 70 43 00 00       	call   80104a30 <acquire>
  for(i = 0; i < n; i++)
801006c0:	83 c4 10             	add    $0x10,%esp
801006c3:	85 f6                	test   %esi,%esi
801006c5:	7e 25                	jle    801006ec <consolewrite+0x4c>
801006c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801006ca:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801006cd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801006d3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801006d6:	85 d2                	test   %edx,%edx
801006d8:	74 06                	je     801006e0 <consolewrite+0x40>
  asm volatile("cli");
801006da:	fa                   	cli
    for(;;)
801006db:	eb fe                	jmp    801006db <consolewrite+0x3b>
801006dd:	8d 76 00             	lea    0x0(%esi),%esi
801006e0:	e8 0b fe ff ff       	call   801004f0 <consputc.part.0>
  for(i = 0; i < n; i++)
801006e5:	83 c3 01             	add    $0x1,%ebx
801006e8:	39 fb                	cmp    %edi,%ebx
801006ea:	75 e1                	jne    801006cd <consolewrite+0x2d>
  release(&cons.lock);
801006ec:	83 ec 0c             	sub    $0xc,%esp
801006ef:	68 20 ff 10 80       	push   $0x8010ff20
801006f4:	e8 d7 42 00 00       	call   801049d0 <release>
  ilock(ip);
801006f9:	58                   	pop    %eax
801006fa:	ff 75 08             	push   0x8(%ebp)
801006fd:	e8 8e 11 00 00       	call   80101890 <ilock>

  return n;
}
80100702:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100705:	89 f0                	mov    %esi,%eax
80100707:	5b                   	pop    %ebx
80100708:	5e                   	pop    %esi
80100709:	5f                   	pop    %edi
8010070a:	5d                   	pop    %ebp
8010070b:	c3                   	ret
8010070c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100710 <printint>:
{
80100710:	55                   	push   %ebp
80100711:	89 e5                	mov    %esp,%ebp
80100713:	57                   	push   %edi
80100714:	56                   	push   %esi
80100715:	53                   	push   %ebx
80100716:	89 d3                	mov    %edx,%ebx
80100718:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010071b:	85 c0                	test   %eax,%eax
8010071d:	79 05                	jns    80100724 <printint+0x14>
8010071f:	83 e1 01             	and    $0x1,%ecx
80100722:	75 64                	jne    80100788 <printint+0x78>
    x = xx;
80100724:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010072b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010072d:	31 f6                	xor    %esi,%esi
8010072f:	90                   	nop
    buf[i++] = digits[x % base];
80100730:	89 c8                	mov    %ecx,%eax
80100732:	31 d2                	xor    %edx,%edx
80100734:	89 f7                	mov    %esi,%edi
80100736:	f7 f3                	div    %ebx
80100738:	8d 76 01             	lea    0x1(%esi),%esi
8010073b:	0f b6 92 18 83 10 80 	movzbl -0x7fef7ce8(%edx),%edx
80100742:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100746:	89 ca                	mov    %ecx,%edx
80100748:	89 c1                	mov    %eax,%ecx
8010074a:	39 da                	cmp    %ebx,%edx
8010074c:	73 e2                	jae    80100730 <printint+0x20>
  if(sign)
8010074e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100751:	85 c9                	test   %ecx,%ecx
80100753:	74 07                	je     8010075c <printint+0x4c>
    buf[i++] = '-';
80100755:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010075a:	89 f7                	mov    %esi,%edi
8010075c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010075f:	01 df                	add    %ebx,%edi
  if(panicked){
80100761:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i]);
80100767:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010076a:	85 d2                	test   %edx,%edx
8010076c:	74 0a                	je     80100778 <printint+0x68>
8010076e:	fa                   	cli
    for(;;)
8010076f:	eb fe                	jmp    8010076f <printint+0x5f>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	e8 73 fd ff ff       	call   801004f0 <consputc.part.0>
  while(--i >= 0)
8010077d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100780:	39 df                	cmp    %ebx,%edi
80100782:	74 11                	je     80100795 <printint+0x85>
80100784:	89 c7                	mov    %eax,%edi
80100786:	eb d9                	jmp    80100761 <printint+0x51>
    x = -xx;
80100788:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010078a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
80100791:	89 c1                	mov    %eax,%ecx
80100793:	eb 98                	jmp    8010072d <printint+0x1d>
}
80100795:	83 c4 2c             	add    $0x2c,%esp
80100798:	5b                   	pop    %ebx
80100799:	5e                   	pop    %esi
8010079a:	5f                   	pop    %edi
8010079b:	5d                   	pop    %ebp
8010079c:	c3                   	ret
8010079d:	8d 76 00             	lea    0x0(%esi),%esi

801007a0 <cprintf>:
{
801007a0:	55                   	push   %ebp
801007a1:	89 e5                	mov    %esp,%ebp
801007a3:	57                   	push   %edi
801007a4:	56                   	push   %esi
801007a5:	53                   	push   %ebx
801007a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801007a9:	8b 3d 54 ff 10 80    	mov    0x8010ff54,%edi
  if (fmt == 0)
801007af:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801007b2:	85 ff                	test   %edi,%edi
801007b4:	0f 85 06 01 00 00    	jne    801008c0 <cprintf+0x120>
  if (fmt == 0)
801007ba:	85 f6                	test   %esi,%esi
801007bc:	0f 84 b7 01 00 00    	je     80100979 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007c2:	0f b6 06             	movzbl (%esi),%eax
801007c5:	85 c0                	test   %eax,%eax
801007c7:	74 5f                	je     80100828 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801007c9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801007cf:	31 db                	xor    %ebx,%ebx
801007d1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801007d3:	83 f8 25             	cmp    $0x25,%eax
801007d6:	75 58                	jne    80100830 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801007d8:	83 c3 01             	add    $0x1,%ebx
801007db:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801007df:	85 c9                	test   %ecx,%ecx
801007e1:	74 3a                	je     8010081d <cprintf+0x7d>
    switch(c){
801007e3:	83 f9 70             	cmp    $0x70,%ecx
801007e6:	0f 84 b4 00 00 00    	je     801008a0 <cprintf+0x100>
801007ec:	7f 72                	jg     80100860 <cprintf+0xc0>
801007ee:	83 f9 25             	cmp    $0x25,%ecx
801007f1:	74 4d                	je     80100840 <cprintf+0xa0>
801007f3:	83 f9 64             	cmp    $0x64,%ecx
801007f6:	75 76                	jne    8010086e <cprintf+0xce>
      printint(*argp++, 10, 1);
801007f8:	8d 47 04             	lea    0x4(%edi),%eax
801007fb:	b9 01 00 00 00       	mov    $0x1,%ecx
80100800:	ba 0a 00 00 00       	mov    $0xa,%edx
80100805:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100808:	8b 07                	mov    (%edi),%eax
8010080a:	e8 01 ff ff ff       	call   80100710 <printint>
8010080f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100812:	83 c3 01             	add    $0x1,%ebx
80100815:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100819:	85 c0                	test   %eax,%eax
8010081b:	75 b6                	jne    801007d3 <cprintf+0x33>
8010081d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100820:	85 ff                	test   %edi,%edi
80100822:	0f 85 bb 00 00 00    	jne    801008e3 <cprintf+0x143>
}
80100828:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010082b:	5b                   	pop    %ebx
8010082c:	5e                   	pop    %esi
8010082d:	5f                   	pop    %edi
8010082e:	5d                   	pop    %ebp
8010082f:	c3                   	ret
  if(panicked){
80100830:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100836:	85 c9                	test   %ecx,%ecx
80100838:	74 19                	je     80100853 <cprintf+0xb3>
8010083a:	fa                   	cli
    for(;;)
8010083b:	eb fe                	jmp    8010083b <cprintf+0x9b>
8010083d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100840:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100846:	85 c9                	test   %ecx,%ecx
80100848:	0f 85 f2 00 00 00    	jne    80100940 <cprintf+0x1a0>
8010084e:	b8 25 00 00 00       	mov    $0x25,%eax
80100853:	e8 98 fc ff ff       	call   801004f0 <consputc.part.0>
      break;
80100858:	eb b8                	jmp    80100812 <cprintf+0x72>
8010085a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100860:	83 f9 73             	cmp    $0x73,%ecx
80100863:	0f 84 8f 00 00 00    	je     801008f8 <cprintf+0x158>
80100869:	83 f9 78             	cmp    $0x78,%ecx
8010086c:	74 32                	je     801008a0 <cprintf+0x100>
  if(panicked){
8010086e:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100874:	85 d2                	test   %edx,%edx
80100876:	0f 85 b8 00 00 00    	jne    80100934 <cprintf+0x194>
8010087c:	b8 25 00 00 00       	mov    $0x25,%eax
80100881:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100884:	e8 67 fc ff ff       	call   801004f0 <consputc.part.0>
80100889:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010088e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100891:	85 c0                	test   %eax,%eax
80100893:	0f 84 cd 00 00 00    	je     80100966 <cprintf+0x1c6>
80100899:	fa                   	cli
    for(;;)
8010089a:	eb fe                	jmp    8010089a <cprintf+0xfa>
8010089c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801008a0:	8d 47 04             	lea    0x4(%edi),%eax
801008a3:	31 c9                	xor    %ecx,%ecx
801008a5:	ba 10 00 00 00       	mov    $0x10,%edx
801008aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
801008ad:	8b 07                	mov    (%edi),%eax
801008af:	e8 5c fe ff ff       	call   80100710 <printint>
801008b4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801008b7:	e9 56 ff ff ff       	jmp    80100812 <cprintf+0x72>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801008c0:	83 ec 0c             	sub    $0xc,%esp
801008c3:	68 20 ff 10 80       	push   $0x8010ff20
801008c8:	e8 63 41 00 00       	call   80104a30 <acquire>
  if (fmt == 0)
801008cd:	83 c4 10             	add    $0x10,%esp
801008d0:	85 f6                	test   %esi,%esi
801008d2:	0f 84 a1 00 00 00    	je     80100979 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008d8:	0f b6 06             	movzbl (%esi),%eax
801008db:	85 c0                	test   %eax,%eax
801008dd:	0f 85 e6 fe ff ff    	jne    801007c9 <cprintf+0x29>
    release(&cons.lock);
801008e3:	83 ec 0c             	sub    $0xc,%esp
801008e6:	68 20 ff 10 80       	push   $0x8010ff20
801008eb:	e8 e0 40 00 00       	call   801049d0 <release>
801008f0:	83 c4 10             	add    $0x10,%esp
801008f3:	e9 30 ff ff ff       	jmp    80100828 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
801008f8:	8b 17                	mov    (%edi),%edx
801008fa:	8d 47 04             	lea    0x4(%edi),%eax
801008fd:	85 d2                	test   %edx,%edx
801008ff:	74 27                	je     80100928 <cprintf+0x188>
      for(; *s; s++)
80100901:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100904:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100906:	84 c9                	test   %cl,%cl
80100908:	74 68                	je     80100972 <cprintf+0x1d2>
8010090a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010090d:	89 fb                	mov    %edi,%ebx
8010090f:	89 f7                	mov    %esi,%edi
80100911:	89 c6                	mov    %eax,%esi
80100913:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100916:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010091c:	85 d2                	test   %edx,%edx
8010091e:	74 28                	je     80100948 <cprintf+0x1a8>
80100920:	fa                   	cli
    for(;;)
80100921:	eb fe                	jmp    80100921 <cprintf+0x181>
80100923:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100927:	90                   	nop
80100928:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010092d:	bf 98 7d 10 80       	mov    $0x80107d98,%edi
80100932:	eb d6                	jmp    8010090a <cprintf+0x16a>
80100934:	fa                   	cli
    for(;;)
80100935:	eb fe                	jmp    80100935 <cprintf+0x195>
80100937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010093e:	66 90                	xchg   %ax,%ax
80100940:	fa                   	cli
80100941:	eb fe                	jmp    80100941 <cprintf+0x1a1>
80100943:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100947:	90                   	nop
80100948:	e8 a3 fb ff ff       	call   801004f0 <consputc.part.0>
      for(; *s; s++)
8010094d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100951:	83 c3 01             	add    $0x1,%ebx
80100954:	84 c0                	test   %al,%al
80100956:	75 be                	jne    80100916 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100958:	89 f0                	mov    %esi,%eax
8010095a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010095d:	89 fe                	mov    %edi,%esi
8010095f:	89 c7                	mov    %eax,%edi
80100961:	e9 ac fe ff ff       	jmp    80100812 <cprintf+0x72>
80100966:	89 c8                	mov    %ecx,%eax
80100968:	e8 83 fb ff ff       	call   801004f0 <consputc.part.0>
      break;
8010096d:	e9 a0 fe ff ff       	jmp    80100812 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
80100972:	89 c7                	mov    %eax,%edi
80100974:	e9 99 fe ff ff       	jmp    80100812 <cprintf+0x72>
    panic("null fmt");
80100979:	83 ec 0c             	sub    $0xc,%esp
8010097c:	68 9f 7d 10 80       	push   $0x80107d9f
80100981:	e8 ea fa ff ff       	call   80100470 <panic>
80100986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010098d:	8d 76 00             	lea    0x0(%esi),%esi

80100990 <consoleintr>:
{
80100990:	55                   	push   %ebp
80100991:	89 e5                	mov    %esp,%ebp
80100993:	57                   	push   %edi
  int c, doprocdump = 0;
80100994:	31 ff                	xor    %edi,%edi
{
80100996:	56                   	push   %esi
80100997:	53                   	push   %ebx
80100998:	83 ec 18             	sub    $0x18,%esp
8010099b:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
8010099e:	68 20 ff 10 80       	push   $0x8010ff20
801009a3:	e8 88 40 00 00       	call   80104a30 <acquire>
  while((c = getc()) >= 0){
801009a8:	83 c4 10             	add    $0x10,%esp
801009ab:	ff d6                	call   *%esi
801009ad:	89 c3                	mov    %eax,%ebx
801009af:	85 c0                	test   %eax,%eax
801009b1:	78 22                	js     801009d5 <consoleintr+0x45>
    switch(c){
801009b3:	83 fb 15             	cmp    $0x15,%ebx
801009b6:	74 47                	je     801009ff <consoleintr+0x6f>
801009b8:	7f 76                	jg     80100a30 <consoleintr+0xa0>
801009ba:	83 fb 08             	cmp    $0x8,%ebx
801009bd:	74 76                	je     80100a35 <consoleintr+0xa5>
801009bf:	83 fb 10             	cmp    $0x10,%ebx
801009c2:	0f 85 f8 00 00 00    	jne    80100ac0 <consoleintr+0x130>
  while((c = getc()) >= 0){
801009c8:	ff d6                	call   *%esi
    switch(c){
801009ca:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
801009cf:	89 c3                	mov    %eax,%ebx
801009d1:	85 c0                	test   %eax,%eax
801009d3:	79 de                	jns    801009b3 <consoleintr+0x23>
  release(&cons.lock);
801009d5:	83 ec 0c             	sub    $0xc,%esp
801009d8:	68 20 ff 10 80       	push   $0x8010ff20
801009dd:	e8 ee 3f 00 00       	call   801049d0 <release>
  if(doprocdump) {
801009e2:	83 c4 10             	add    $0x10,%esp
801009e5:	85 ff                	test   %edi,%edi
801009e7:	0f 85 4b 01 00 00    	jne    80100b38 <consoleintr+0x1a8>
}
801009ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009f0:	5b                   	pop    %ebx
801009f1:	5e                   	pop    %esi
801009f2:	5f                   	pop    %edi
801009f3:	5d                   	pop    %ebp
801009f4:	c3                   	ret
801009f5:	b8 00 01 00 00       	mov    $0x100,%eax
801009fa:	e8 f1 fa ff ff       	call   801004f0 <consputc.part.0>
      while(input.e != input.w &&
801009ff:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100a04:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100a0a:	74 9f                	je     801009ab <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a0c:	83 e8 01             	sub    $0x1,%eax
80100a0f:	89 c2                	mov    %eax,%edx
80100a11:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100a14:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100a1b:	74 8e                	je     801009ab <consoleintr+0x1b>
  if(panicked){
80100a1d:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
80100a23:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100a28:	85 d2                	test   %edx,%edx
80100a2a:	74 c9                	je     801009f5 <consoleintr+0x65>
80100a2c:	fa                   	cli
    for(;;)
80100a2d:	eb fe                	jmp    80100a2d <consoleintr+0x9d>
80100a2f:	90                   	nop
    switch(c){
80100a30:	83 fb 7f             	cmp    $0x7f,%ebx
80100a33:	75 2b                	jne    80100a60 <consoleintr+0xd0>
      if(input.e != input.w){
80100a35:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100a3a:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100a40:	0f 84 65 ff ff ff    	je     801009ab <consoleintr+0x1b>
        input.e--;
80100a46:	83 e8 01             	sub    $0x1,%eax
80100a49:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100a4e:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100a53:	85 c0                	test   %eax,%eax
80100a55:	0f 84 ce 00 00 00    	je     80100b29 <consoleintr+0x199>
80100a5b:	fa                   	cli
    for(;;)
80100a5c:	eb fe                	jmp    80100a5c <consoleintr+0xcc>
80100a5e:	66 90                	xchg   %ax,%ax
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a60:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100a65:	89 c2                	mov    %eax,%edx
80100a67:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
80100a6d:	83 fa 7f             	cmp    $0x7f,%edx
80100a70:	0f 87 35 ff ff ff    	ja     801009ab <consoleintr+0x1b>
  if(panicked){
80100a76:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
80100a7c:	8d 50 01             	lea    0x1(%eax),%edx
80100a7f:	83 e0 7f             	and    $0x7f,%eax
80100a82:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100a88:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100a8e:	85 c9                	test   %ecx,%ecx
80100a90:	0f 85 ae 00 00 00    	jne    80100b44 <consoleintr+0x1b4>
80100a96:	89 d8                	mov    %ebx,%eax
80100a98:	e8 53 fa ff ff       	call   801004f0 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a9d:	83 fb 0a             	cmp    $0xa,%ebx
80100aa0:	74 68                	je     80100b0a <consoleintr+0x17a>
80100aa2:	83 fb 04             	cmp    $0x4,%ebx
80100aa5:	74 63                	je     80100b0a <consoleintr+0x17a>
80100aa7:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80100aac:	83 e8 80             	sub    $0xffffff80,%eax
80100aaf:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100ab5:	0f 85 f0 fe ff ff    	jne    801009ab <consoleintr+0x1b>
80100abb:	eb 52                	jmp    80100b0f <consoleintr+0x17f>
80100abd:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100ac0:	85 db                	test   %ebx,%ebx
80100ac2:	0f 84 e3 fe ff ff    	je     801009ab <consoleintr+0x1b>
80100ac8:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100acd:	89 c2                	mov    %eax,%edx
80100acf:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
80100ad5:	83 fa 7f             	cmp    $0x7f,%edx
80100ad8:	0f 87 cd fe ff ff    	ja     801009ab <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100ade:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
80100ae1:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
80100ae7:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100aea:	83 fb 0d             	cmp    $0xd,%ebx
80100aed:	75 93                	jne    80100a82 <consoleintr+0xf2>
        input.buf[input.e++ % INPUT_BUF] = c;
80100aef:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100af5:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100afc:	85 c9                	test   %ecx,%ecx
80100afe:	75 44                	jne    80100b44 <consoleintr+0x1b4>
80100b00:	b8 0a 00 00 00       	mov    $0xa,%eax
80100b05:	e8 e6 f9 ff ff       	call   801004f0 <consputc.part.0>
          input.w = input.e;
80100b0a:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100b0f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100b12:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100b17:	68 00 ff 10 80       	push   $0x8010ff00
80100b1c:	e8 2f 38 00 00       	call   80104350 <wakeup>
80100b21:	83 c4 10             	add    $0x10,%esp
80100b24:	e9 82 fe ff ff       	jmp    801009ab <consoleintr+0x1b>
80100b29:	b8 00 01 00 00       	mov    $0x100,%eax
80100b2e:	e8 bd f9 ff ff       	call   801004f0 <consputc.part.0>
80100b33:	e9 73 fe ff ff       	jmp    801009ab <consoleintr+0x1b>
}
80100b38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b3b:	5b                   	pop    %ebx
80100b3c:	5e                   	pop    %esi
80100b3d:	5f                   	pop    %edi
80100b3e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100b3f:	e9 ec 38 00 00       	jmp    80104430 <procdump>
80100b44:	fa                   	cli
    for(;;)
80100b45:	eb fe                	jmp    80100b45 <consoleintr+0x1b5>
80100b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b4e:	66 90                	xchg   %ax,%ax

80100b50 <consoleinit>:

void
consoleinit(void)
{
80100b50:	55                   	push   %ebp
80100b51:	89 e5                	mov    %esp,%ebp
80100b53:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100b56:	68 a8 7d 10 80       	push   $0x80107da8
80100b5b:	68 20 ff 10 80       	push   $0x8010ff20
80100b60:	e8 db 3c 00 00       	call   80104840 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100b65:	58                   	pop    %eax
80100b66:	5a                   	pop    %edx
80100b67:	6a 00                	push   $0x0
80100b69:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100b6b:	c7 05 0c 09 11 80 a0 	movl   $0x801006a0,0x8011090c
80100b72:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100b75:	c7 05 08 09 11 80 70 	movl   $0x80100370,0x80110908
80100b7c:	03 10 80 
  cons.locking = 1;
80100b7f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100b86:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100b89:	e8 c2 19 00 00       	call   80102550 <ioapicenable>
}
80100b8e:	83 c4 10             	add    $0x10,%esp
80100b91:	c9                   	leave
80100b92:	c3                   	ret
80100b93:	66 90                	xchg   %ax,%ax
80100b95:	66 90                	xchg   %ax,%ax
80100b97:	66 90                	xchg   %ax,%ax
80100b99:	66 90                	xchg   %ax,%ax
80100b9b:	66 90                	xchg   %ax,%ax
80100b9d:	66 90                	xchg   %ax,%ax
80100b9f:	90                   	nop

80100ba0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ba0:	55                   	push   %ebp
80100ba1:	89 e5                	mov    %esp,%ebp
80100ba3:	57                   	push   %edi
80100ba4:	56                   	push   %esi
80100ba5:	53                   	push   %ebx
80100ba6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100bac:	e8 8f 2f 00 00       	call   80103b40 <myproc>
80100bb1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100bb7:	e8 74 23 00 00       	call   80102f30 <begin_op>

  if((ip = namei(path)) == 0){
80100bbc:	83 ec 0c             	sub    $0xc,%esp
80100bbf:	ff 75 08             	push   0x8(%ebp)
80100bc2:	e8 a9 15 00 00       	call   80102170 <namei>
80100bc7:	83 c4 10             	add    $0x10,%esp
80100bca:	85 c0                	test   %eax,%eax
80100bcc:	0f 84 30 03 00 00    	je     80100f02 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100bd2:	83 ec 0c             	sub    $0xc,%esp
80100bd5:	89 c7                	mov    %eax,%edi
80100bd7:	50                   	push   %eax
80100bd8:	e8 b3 0c 00 00       	call   80101890 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100bdd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100be3:	6a 34                	push   $0x34
80100be5:	6a 00                	push   $0x0
80100be7:	50                   	push   %eax
80100be8:	57                   	push   %edi
80100be9:	e8 b2 0f 00 00       	call   80101ba0 <readi>
80100bee:	83 c4 20             	add    $0x20,%esp
80100bf1:	83 f8 34             	cmp    $0x34,%eax
80100bf4:	0f 85 01 01 00 00    	jne    80100cfb <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100bfa:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100c01:	45 4c 46 
80100c04:	0f 85 f1 00 00 00    	jne    80100cfb <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c0a:	e8 41 68 00 00       	call   80107450 <setupkvm>
80100c0f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100c15:	85 c0                	test   %eax,%eax
80100c17:	0f 84 de 00 00 00    	je     80100cfb <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c1d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100c24:	00 
80100c25:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100c2b:	0f 84 a1 02 00 00    	je     80100ed2 <exec+0x332>
  sz = 0;
80100c31:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100c38:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c3b:	31 db                	xor    %ebx,%ebx
80100c3d:	e9 8c 00 00 00       	jmp    80100cce <exec+0x12e>
80100c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c48:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100c4f:	75 6c                	jne    80100cbd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100c51:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100c57:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100c5d:	0f 82 87 00 00 00    	jb     80100cea <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c63:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100c69:	72 7f                	jb     80100cea <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c6b:	83 ec 04             	sub    $0x4,%esp
80100c6e:	50                   	push   %eax
80100c6f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100c75:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c7b:	e8 d0 65 00 00       	call   80107250 <allocuvm>
80100c80:	83 c4 10             	add    $0x10,%esp
80100c83:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c89:	85 c0                	test   %eax,%eax
80100c8b:	74 5d                	je     80100cea <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100c8d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c93:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c98:	75 50                	jne    80100cea <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c9a:	83 ec 0c             	sub    $0xc,%esp
80100c9d:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100ca3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100ca9:	57                   	push   %edi
80100caa:	50                   	push   %eax
80100cab:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100cb1:	e8 ca 64 00 00       	call   80107180 <loaduvm>
80100cb6:	83 c4 20             	add    $0x20,%esp
80100cb9:	85 c0                	test   %eax,%eax
80100cbb:	78 2d                	js     80100cea <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cbd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100cc4:	83 c3 01             	add    $0x1,%ebx
80100cc7:	83 c6 20             	add    $0x20,%esi
80100cca:	39 d8                	cmp    %ebx,%eax
80100ccc:	7e 52                	jle    80100d20 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100cce:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100cd4:	6a 20                	push   $0x20
80100cd6:	56                   	push   %esi
80100cd7:	50                   	push   %eax
80100cd8:	57                   	push   %edi
80100cd9:	e8 c2 0e 00 00       	call   80101ba0 <readi>
80100cde:	83 c4 10             	add    $0x10,%esp
80100ce1:	83 f8 20             	cmp    $0x20,%eax
80100ce4:	0f 84 5e ff ff ff    	je     80100c48 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100cea:	83 ec 0c             	sub    $0xc,%esp
80100ced:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100cf3:	e8 d8 66 00 00       	call   801073d0 <freevm>
  if(ip){
80100cf8:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100cfb:	83 ec 0c             	sub    $0xc,%esp
80100cfe:	57                   	push   %edi
80100cff:	e8 1c 0e 00 00       	call   80101b20 <iunlockput>
    end_op();
80100d04:	e8 97 22 00 00       	call   80102fa0 <end_op>
80100d09:	83 c4 10             	add    $0x10,%esp
    return -1;
80100d0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100d11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d14:	5b                   	pop    %ebx
80100d15:	5e                   	pop    %esi
80100d16:	5f                   	pop    %edi
80100d17:	5d                   	pop    %ebp
80100d18:	c3                   	ret
80100d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100d20:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100d26:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100d2c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d32:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100d38:	83 ec 0c             	sub    $0xc,%esp
80100d3b:	57                   	push   %edi
80100d3c:	e8 df 0d 00 00       	call   80101b20 <iunlockput>
  end_op();
80100d41:	e8 5a 22 00 00       	call   80102fa0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d46:	83 c4 0c             	add    $0xc,%esp
80100d49:	53                   	push   %ebx
80100d4a:	56                   	push   %esi
80100d4b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100d51:	56                   	push   %esi
80100d52:	e8 f9 64 00 00       	call   80107250 <allocuvm>
80100d57:	83 c4 10             	add    $0x10,%esp
80100d5a:	89 c7                	mov    %eax,%edi
80100d5c:	85 c0                	test   %eax,%eax
80100d5e:	0f 84 86 00 00 00    	je     80100dea <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d64:	83 ec 08             	sub    $0x8,%esp
80100d67:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100d6d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d6f:	50                   	push   %eax
80100d70:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100d71:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d73:	e8 78 67 00 00       	call   801074f0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100d78:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d7b:	83 c4 10             	add    $0x10,%esp
80100d7e:	8b 10                	mov    (%eax),%edx
80100d80:	85 d2                	test   %edx,%edx
80100d82:	0f 84 56 01 00 00    	je     80100ede <exec+0x33e>
80100d88:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100d8e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100d91:	eb 23                	jmp    80100db6 <exec+0x216>
80100d93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100d97:	90                   	nop
80100d98:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100d9b:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100da2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100da8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100dab:	85 d2                	test   %edx,%edx
80100dad:	74 51                	je     80100e00 <exec+0x260>
    if(argc >= MAXARG)
80100daf:	83 f8 20             	cmp    $0x20,%eax
80100db2:	74 36                	je     80100dea <exec+0x24a>
80100db4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100db6:	83 ec 0c             	sub    $0xc,%esp
80100db9:	52                   	push   %edx
80100dba:	e8 61 3f 00 00       	call   80104d20 <strlen>
80100dbf:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dc1:	58                   	pop    %eax
80100dc2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dc5:	83 eb 01             	sub    $0x1,%ebx
80100dc8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dcb:	e8 50 3f 00 00       	call   80104d20 <strlen>
80100dd0:	83 c0 01             	add    $0x1,%eax
80100dd3:	50                   	push   %eax
80100dd4:	ff 34 b7             	push   (%edi,%esi,4)
80100dd7:	53                   	push   %ebx
80100dd8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100dde:	e8 0d 6b 00 00       	call   801078f0 <copyout>
80100de3:	83 c4 20             	add    $0x20,%esp
80100de6:	85 c0                	test   %eax,%eax
80100de8:	79 ae                	jns    80100d98 <exec+0x1f8>
    freevm(pgdir);
80100dea:	83 ec 0c             	sub    $0xc,%esp
80100ded:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100df3:	e8 d8 65 00 00       	call   801073d0 <freevm>
80100df8:	83 c4 10             	add    $0x10,%esp
80100dfb:	e9 0c ff ff ff       	jmp    80100d0c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e00:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100e07:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100e0d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100e13:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100e16:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100e19:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100e20:	00 00 00 00 
  ustack[1] = argc;
80100e24:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100e2a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100e31:	ff ff ff 
  ustack[1] = argc;
80100e34:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e3a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100e3c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e3e:	29 d0                	sub    %edx,%eax
80100e40:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e46:	56                   	push   %esi
80100e47:	51                   	push   %ecx
80100e48:	53                   	push   %ebx
80100e49:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100e4f:	e8 9c 6a 00 00       	call   801078f0 <copyout>
80100e54:	83 c4 10             	add    $0x10,%esp
80100e57:	85 c0                	test   %eax,%eax
80100e59:	78 8f                	js     80100dea <exec+0x24a>
  for(last=s=path; *s; s++)
80100e5b:	8b 45 08             	mov    0x8(%ebp),%eax
80100e5e:	8b 55 08             	mov    0x8(%ebp),%edx
80100e61:	0f b6 00             	movzbl (%eax),%eax
80100e64:	84 c0                	test   %al,%al
80100e66:	74 17                	je     80100e7f <exec+0x2df>
80100e68:	89 d1                	mov    %edx,%ecx
80100e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100e70:	83 c1 01             	add    $0x1,%ecx
80100e73:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100e75:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100e78:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100e7b:	84 c0                	test   %al,%al
80100e7d:	75 f1                	jne    80100e70 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100e7f:	83 ec 04             	sub    $0x4,%esp
80100e82:	6a 10                	push   $0x10
80100e84:	52                   	push   %edx
80100e85:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100e8b:	8d 46 70             	lea    0x70(%esi),%eax
80100e8e:	50                   	push   %eax
80100e8f:	e8 4c 3e 00 00       	call   80104ce0 <safestrcpy>
  curproc->pgdir = pgdir;
80100e94:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100e9a:	89 f0                	mov    %esi,%eax
80100e9c:	8b 76 08             	mov    0x8(%esi),%esi
  curproc->sz = sz;
80100e9f:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100ea1:	89 48 08             	mov    %ecx,0x8(%eax)
  curproc->tf->eip = elf.entry;  // main
80100ea4:	89 c1                	mov    %eax,%ecx
80100ea6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100eac:	8b 40 1c             	mov    0x1c(%eax),%eax
80100eaf:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100eb2:	8b 41 1c             	mov    0x1c(%ecx),%eax
80100eb5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100eb8:	89 0c 24             	mov    %ecx,(%esp)
80100ebb:	e8 30 61 00 00       	call   80106ff0 <switchuvm>
  freevm(oldpgdir);
80100ec0:	89 34 24             	mov    %esi,(%esp)
80100ec3:	e8 08 65 00 00       	call   801073d0 <freevm>
  return 0;
80100ec8:	83 c4 10             	add    $0x10,%esp
80100ecb:	31 c0                	xor    %eax,%eax
80100ecd:	e9 3f fe ff ff       	jmp    80100d11 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ed2:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100ed7:	31 f6                	xor    %esi,%esi
80100ed9:	e9 5a fe ff ff       	jmp    80100d38 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100ede:	be 10 00 00 00       	mov    $0x10,%esi
80100ee3:	ba 04 00 00 00       	mov    $0x4,%edx
80100ee8:	b8 03 00 00 00       	mov    $0x3,%eax
80100eed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100ef4:	00 00 00 
80100ef7:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100efd:	e9 17 ff ff ff       	jmp    80100e19 <exec+0x279>
    end_op();
80100f02:	e8 99 20 00 00       	call   80102fa0 <end_op>
    cprintf("exec: fail\n");
80100f07:	83 ec 0c             	sub    $0xc,%esp
80100f0a:	68 b0 7d 10 80       	push   $0x80107db0
80100f0f:	e8 8c f8 ff ff       	call   801007a0 <cprintf>
    return -1;
80100f14:	83 c4 10             	add    $0x10,%esp
80100f17:	e9 f0 fd ff ff       	jmp    80100d0c <exec+0x16c>
80100f1c:	66 90                	xchg   %ax,%ax
80100f1e:	66 90                	xchg   %ax,%ax

80100f20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100f26:	68 bc 7d 10 80       	push   $0x80107dbc
80100f2b:	68 60 ff 10 80       	push   $0x8010ff60
80100f30:	e8 0b 39 00 00       	call   80104840 <initlock>
}
80100f35:	83 c4 10             	add    $0x10,%esp
80100f38:	c9                   	leave
80100f39:	c3                   	ret
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f40 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f44:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100f49:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100f4c:	68 60 ff 10 80       	push   $0x8010ff60
80100f51:	e8 da 3a 00 00       	call   80104a30 <acquire>
80100f56:	83 c4 10             	add    $0x10,%esp
80100f59:	eb 10                	jmp    80100f6b <filealloc+0x2b>
80100f5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f5f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f60:	83 c3 18             	add    $0x18,%ebx
80100f63:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100f69:	74 25                	je     80100f90 <filealloc+0x50>
    if(f->ref == 0){
80100f6b:	8b 43 04             	mov    0x4(%ebx),%eax
80100f6e:	85 c0                	test   %eax,%eax
80100f70:	75 ee                	jne    80100f60 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100f72:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100f75:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100f7c:	68 60 ff 10 80       	push   $0x8010ff60
80100f81:	e8 4a 3a 00 00       	call   801049d0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f86:	89 d8                	mov    %ebx,%eax
      return f;
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f8e:	c9                   	leave
80100f8f:	c3                   	ret
  release(&ftable.lock);
80100f90:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100f93:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100f95:	68 60 ff 10 80       	push   $0x8010ff60
80100f9a:	e8 31 3a 00 00       	call   801049d0 <release>
}
80100f9f:	89 d8                	mov    %ebx,%eax
  return 0;
80100fa1:	83 c4 10             	add    $0x10,%esp
}
80100fa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fa7:	c9                   	leave
80100fa8:	c3                   	ret
80100fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100fb0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fb0:	55                   	push   %ebp
80100fb1:	89 e5                	mov    %esp,%ebp
80100fb3:	53                   	push   %ebx
80100fb4:	83 ec 10             	sub    $0x10,%esp
80100fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100fba:	68 60 ff 10 80       	push   $0x8010ff60
80100fbf:	e8 6c 3a 00 00       	call   80104a30 <acquire>
  if(f->ref < 1)
80100fc4:	8b 43 04             	mov    0x4(%ebx),%eax
80100fc7:	83 c4 10             	add    $0x10,%esp
80100fca:	85 c0                	test   %eax,%eax
80100fcc:	7e 1a                	jle    80100fe8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100fce:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100fd1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100fd4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100fd7:	68 60 ff 10 80       	push   $0x8010ff60
80100fdc:	e8 ef 39 00 00       	call   801049d0 <release>
  return f;
}
80100fe1:	89 d8                	mov    %ebx,%eax
80100fe3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fe6:	c9                   	leave
80100fe7:	c3                   	ret
    panic("filedup");
80100fe8:	83 ec 0c             	sub    $0xc,%esp
80100feb:	68 c3 7d 10 80       	push   $0x80107dc3
80100ff0:	e8 7b f4 ff ff       	call   80100470 <panic>
80100ff5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101000 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	57                   	push   %edi
80101004:	56                   	push   %esi
80101005:	53                   	push   %ebx
80101006:	83 ec 28             	sub    $0x28,%esp
80101009:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010100c:	68 60 ff 10 80       	push   $0x8010ff60
80101011:	e8 1a 3a 00 00       	call   80104a30 <acquire>
  if(f->ref < 1)
80101016:	8b 53 04             	mov    0x4(%ebx),%edx
80101019:	83 c4 10             	add    $0x10,%esp
8010101c:	85 d2                	test   %edx,%edx
8010101e:	0f 8e a5 00 00 00    	jle    801010c9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101024:	83 ea 01             	sub    $0x1,%edx
80101027:	89 53 04             	mov    %edx,0x4(%ebx)
8010102a:	75 44                	jne    80101070 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010102c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101030:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101033:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101035:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010103b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010103e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101041:	8b 43 10             	mov    0x10(%ebx),%eax
80101044:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101047:	68 60 ff 10 80       	push   $0x8010ff60
8010104c:	e8 7f 39 00 00       	call   801049d0 <release>

  if(ff.type == FD_PIPE)
80101051:	83 c4 10             	add    $0x10,%esp
80101054:	83 ff 01             	cmp    $0x1,%edi
80101057:	74 57                	je     801010b0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101059:	83 ff 02             	cmp    $0x2,%edi
8010105c:	74 2a                	je     80101088 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
80101065:	c3                   	ret
80101066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010106d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101070:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80101077:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010107a:	5b                   	pop    %ebx
8010107b:	5e                   	pop    %esi
8010107c:	5f                   	pop    %edi
8010107d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010107e:	e9 4d 39 00 00       	jmp    801049d0 <release>
80101083:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101087:	90                   	nop
    begin_op();
80101088:	e8 a3 1e 00 00       	call   80102f30 <begin_op>
    iput(ff.ip);
8010108d:	83 ec 0c             	sub    $0xc,%esp
80101090:	ff 75 e0             	push   -0x20(%ebp)
80101093:	e8 28 09 00 00       	call   801019c0 <iput>
    end_op();
80101098:	83 c4 10             	add    $0x10,%esp
}
8010109b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010109e:	5b                   	pop    %ebx
8010109f:	5e                   	pop    %esi
801010a0:	5f                   	pop    %edi
801010a1:	5d                   	pop    %ebp
    end_op();
801010a2:	e9 f9 1e 00 00       	jmp    80102fa0 <end_op>
801010a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ae:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801010b0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801010b4:	83 ec 08             	sub    $0x8,%esp
801010b7:	53                   	push   %ebx
801010b8:	56                   	push   %esi
801010b9:	e8 32 26 00 00       	call   801036f0 <pipeclose>
801010be:	83 c4 10             	add    $0x10,%esp
}
801010c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c4:	5b                   	pop    %ebx
801010c5:	5e                   	pop    %esi
801010c6:	5f                   	pop    %edi
801010c7:	5d                   	pop    %ebp
801010c8:	c3                   	ret
    panic("fileclose");
801010c9:	83 ec 0c             	sub    $0xc,%esp
801010cc:	68 cb 7d 10 80       	push   $0x80107dcb
801010d1:	e8 9a f3 ff ff       	call   80100470 <panic>
801010d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010dd:	8d 76 00             	lea    0x0(%esi),%esi

801010e0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	53                   	push   %ebx
801010e4:	83 ec 04             	sub    $0x4,%esp
801010e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801010ea:	83 3b 02             	cmpl   $0x2,(%ebx)
801010ed:	75 31                	jne    80101120 <filestat+0x40>
    ilock(f->ip);
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	ff 73 10             	push   0x10(%ebx)
801010f5:	e8 96 07 00 00       	call   80101890 <ilock>
    stati(f->ip, st);
801010fa:	58                   	pop    %eax
801010fb:	5a                   	pop    %edx
801010fc:	ff 75 0c             	push   0xc(%ebp)
801010ff:	ff 73 10             	push   0x10(%ebx)
80101102:	e8 69 0a 00 00       	call   80101b70 <stati>
    iunlock(f->ip);
80101107:	59                   	pop    %ecx
80101108:	ff 73 10             	push   0x10(%ebx)
8010110b:	e8 60 08 00 00       	call   80101970 <iunlock>
    return 0;
  }
  return -1;
}
80101110:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101113:	83 c4 10             	add    $0x10,%esp
80101116:	31 c0                	xor    %eax,%eax
}
80101118:	c9                   	leave
80101119:	c3                   	ret
8010111a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101120:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101123:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101128:	c9                   	leave
80101129:	c3                   	ret
8010112a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101130 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	57                   	push   %edi
80101134:	56                   	push   %esi
80101135:	53                   	push   %ebx
80101136:	83 ec 0c             	sub    $0xc,%esp
80101139:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010113c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010113f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101142:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101146:	74 60                	je     801011a8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101148:	8b 03                	mov    (%ebx),%eax
8010114a:	83 f8 01             	cmp    $0x1,%eax
8010114d:	74 41                	je     80101190 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010114f:	83 f8 02             	cmp    $0x2,%eax
80101152:	75 5b                	jne    801011af <fileread+0x7f>
    ilock(f->ip);
80101154:	83 ec 0c             	sub    $0xc,%esp
80101157:	ff 73 10             	push   0x10(%ebx)
8010115a:	e8 31 07 00 00       	call   80101890 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010115f:	57                   	push   %edi
80101160:	ff 73 14             	push   0x14(%ebx)
80101163:	56                   	push   %esi
80101164:	ff 73 10             	push   0x10(%ebx)
80101167:	e8 34 0a 00 00       	call   80101ba0 <readi>
8010116c:	83 c4 20             	add    $0x20,%esp
8010116f:	89 c6                	mov    %eax,%esi
80101171:	85 c0                	test   %eax,%eax
80101173:	7e 03                	jle    80101178 <fileread+0x48>
      f->off += r;
80101175:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101178:	83 ec 0c             	sub    $0xc,%esp
8010117b:	ff 73 10             	push   0x10(%ebx)
8010117e:	e8 ed 07 00 00       	call   80101970 <iunlock>
    return r;
80101183:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101189:	89 f0                	mov    %esi,%eax
8010118b:	5b                   	pop    %ebx
8010118c:	5e                   	pop    %esi
8010118d:	5f                   	pop    %edi
8010118e:	5d                   	pop    %ebp
8010118f:	c3                   	ret
    return piperead(f->pipe, addr, n);
80101190:	8b 43 0c             	mov    0xc(%ebx),%eax
80101193:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101196:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101199:	5b                   	pop    %ebx
8010119a:	5e                   	pop    %esi
8010119b:	5f                   	pop    %edi
8010119c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010119d:	e9 0e 27 00 00       	jmp    801038b0 <piperead>
801011a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801011a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801011ad:	eb d7                	jmp    80101186 <fileread+0x56>
  panic("fileread");
801011af:	83 ec 0c             	sub    $0xc,%esp
801011b2:	68 d5 7d 10 80       	push   $0x80107dd5
801011b7:	e8 b4 f2 ff ff       	call   80100470 <panic>
801011bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801011c0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	57                   	push   %edi
801011c4:	56                   	push   %esi
801011c5:	53                   	push   %ebx
801011c6:	83 ec 1c             	sub    $0x1c,%esp
801011c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801011cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801011cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801011d2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801011d5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801011d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801011dc:	0f 84 bb 00 00 00    	je     8010129d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801011e2:	8b 03                	mov    (%ebx),%eax
801011e4:	83 f8 01             	cmp    $0x1,%eax
801011e7:	0f 84 bf 00 00 00    	je     801012ac <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801011ed:	83 f8 02             	cmp    $0x2,%eax
801011f0:	0f 85 c8 00 00 00    	jne    801012be <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801011f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801011f9:	31 f6                	xor    %esi,%esi
    while(i < n){
801011fb:	85 c0                	test   %eax,%eax
801011fd:	7f 30                	jg     8010122f <filewrite+0x6f>
801011ff:	e9 94 00 00 00       	jmp    80101298 <filewrite+0xd8>
80101204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101208:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010120b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010120e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101211:	ff 73 10             	push   0x10(%ebx)
80101214:	e8 57 07 00 00       	call   80101970 <iunlock>
      end_op();
80101219:	e8 82 1d 00 00       	call   80102fa0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010121e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101221:	83 c4 10             	add    $0x10,%esp
80101224:	39 c7                	cmp    %eax,%edi
80101226:	75 5c                	jne    80101284 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101228:	01 fe                	add    %edi,%esi
    while(i < n){
8010122a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010122d:	7e 69                	jle    80101298 <filewrite+0xd8>
      int n1 = n - i;
8010122f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101232:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101237:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101239:	39 c7                	cmp    %eax,%edi
8010123b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010123e:	e8 ed 1c 00 00       	call   80102f30 <begin_op>
      ilock(f->ip);
80101243:	83 ec 0c             	sub    $0xc,%esp
80101246:	ff 73 10             	push   0x10(%ebx)
80101249:	e8 42 06 00 00       	call   80101890 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010124e:	57                   	push   %edi
8010124f:	ff 73 14             	push   0x14(%ebx)
80101252:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101255:	01 f0                	add    %esi,%eax
80101257:	50                   	push   %eax
80101258:	ff 73 10             	push   0x10(%ebx)
8010125b:	e8 40 0a 00 00       	call   80101ca0 <writei>
80101260:	83 c4 20             	add    $0x20,%esp
80101263:	85 c0                	test   %eax,%eax
80101265:	7f a1                	jg     80101208 <filewrite+0x48>
80101267:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010126a:	83 ec 0c             	sub    $0xc,%esp
8010126d:	ff 73 10             	push   0x10(%ebx)
80101270:	e8 fb 06 00 00       	call   80101970 <iunlock>
      end_op();
80101275:	e8 26 1d 00 00       	call   80102fa0 <end_op>
      if(r < 0)
8010127a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010127d:	83 c4 10             	add    $0x10,%esp
80101280:	85 c0                	test   %eax,%eax
80101282:	75 14                	jne    80101298 <filewrite+0xd8>
        panic("short filewrite");
80101284:	83 ec 0c             	sub    $0xc,%esp
80101287:	68 de 7d 10 80       	push   $0x80107dde
8010128c:	e8 df f1 ff ff       	call   80100470 <panic>
80101291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101298:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010129b:	74 05                	je     801012a2 <filewrite+0xe2>
8010129d:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801012a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012a5:	89 f0                	mov    %esi,%eax
801012a7:	5b                   	pop    %ebx
801012a8:	5e                   	pop    %esi
801012a9:	5f                   	pop    %edi
801012aa:	5d                   	pop    %ebp
801012ab:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801012ac:	8b 43 0c             	mov    0xc(%ebx),%eax
801012af:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012b5:	5b                   	pop    %ebx
801012b6:	5e                   	pop    %esi
801012b7:	5f                   	pop    %edi
801012b8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801012b9:	e9 d2 24 00 00       	jmp    80103790 <pipewrite>
  panic("filewrite");
801012be:	83 ec 0c             	sub    $0xc,%esp
801012c1:	68 e4 7d 10 80       	push   $0x80107de4
801012c6:	e8 a5 f1 ff ff       	call   80100470 <panic>
801012cb:	66 90                	xchg   %ax,%ax
801012cd:	66 90                	xchg   %ax,%ax
801012cf:	90                   	nop

801012d0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	57                   	push   %edi
801012d4:	56                   	push   %esi
801012d5:	53                   	push   %ebx
801012d6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801012d9:	8b 0d c0 25 11 80    	mov    0x801125c0,%ecx
{
801012df:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012e2:	85 c9                	test   %ecx,%ecx
801012e4:	0f 84 8c 00 00 00    	je     80101376 <balloc+0xa6>
801012ea:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801012ec:	89 f8                	mov    %edi,%eax
801012ee:	83 ec 08             	sub    $0x8,%esp
801012f1:	89 fe                	mov    %edi,%esi
801012f3:	c1 f8 0c             	sar    $0xc,%eax
801012f6:	03 05 e0 25 11 80    	add    0x801125e0,%eax
801012fc:	50                   	push   %eax
801012fd:	ff 75 dc             	push   -0x24(%ebp)
80101300:	e8 cb ed ff ff       	call   801000d0 <bread>
80101305:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101308:	83 c4 10             	add    $0x10,%esp
8010130b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010130e:	a1 c0 25 11 80       	mov    0x801125c0,%eax
80101313:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101316:	31 c0                	xor    %eax,%eax
80101318:	eb 32                	jmp    8010134c <balloc+0x7c>
8010131a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101320:	89 c1                	mov    %eax,%ecx
80101322:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101327:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010132a:	83 e1 07             	and    $0x7,%ecx
8010132d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010132f:	89 c1                	mov    %eax,%ecx
80101331:	c1 f9 03             	sar    $0x3,%ecx
80101334:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101339:	89 fa                	mov    %edi,%edx
8010133b:	85 df                	test   %ebx,%edi
8010133d:	74 49                	je     80101388 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010133f:	83 c0 01             	add    $0x1,%eax
80101342:	83 c6 01             	add    $0x1,%esi
80101345:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010134a:	74 07                	je     80101353 <balloc+0x83>
8010134c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010134f:	39 d6                	cmp    %edx,%esi
80101351:	72 cd                	jb     80101320 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101353:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101356:	83 ec 0c             	sub    $0xc,%esp
80101359:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010135c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101362:	e8 89 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101367:	83 c4 10             	add    $0x10,%esp
8010136a:	3b 3d c0 25 11 80    	cmp    0x801125c0,%edi
80101370:	0f 82 76 ff ff ff    	jb     801012ec <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101376:	83 ec 0c             	sub    $0xc,%esp
80101379:	68 ee 7d 10 80       	push   $0x80107dee
8010137e:	e8 ed f0 ff ff       	call   80100470 <panic>
80101383:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101387:	90                   	nop
        bp->data[bi/8] |= m;  // Mark block in use.
80101388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010138b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010138e:	09 da                	or     %ebx,%edx
80101390:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101394:	57                   	push   %edi
80101395:	e8 76 1d 00 00       	call   80103110 <log_write>
        brelse(bp);
8010139a:	89 3c 24             	mov    %edi,(%esp)
8010139d:	e8 4e ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801013a2:	58                   	pop    %eax
801013a3:	5a                   	pop    %edx
801013a4:	56                   	push   %esi
801013a5:	ff 75 dc             	push   -0x24(%ebp)
801013a8:	e8 23 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801013ad:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801013b0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801013b2:	8d 40 5c             	lea    0x5c(%eax),%eax
801013b5:	68 00 02 00 00       	push   $0x200
801013ba:	6a 00                	push   $0x0
801013bc:	50                   	push   %eax
801013bd:	e8 6e 37 00 00       	call   80104b30 <memset>
  log_write(bp);
801013c2:	89 1c 24             	mov    %ebx,(%esp)
801013c5:	e8 46 1d 00 00       	call   80103110 <log_write>
  brelse(bp);
801013ca:	89 1c 24             	mov    %ebx,(%esp)
801013cd:	e8 1e ee ff ff       	call   801001f0 <brelse>
}
801013d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d5:	89 f0                	mov    %esi,%eax
801013d7:	5b                   	pop    %ebx
801013d8:	5e                   	pop    %esi
801013d9:	5f                   	pop    %edi
801013da:	5d                   	pop    %ebp
801013db:	c3                   	ret
801013dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013e0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013e0:	55                   	push   %ebp
801013e1:	89 e5                	mov    %esp,%ebp
801013e3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013e4:	31 ff                	xor    %edi,%edi
{
801013e6:	56                   	push   %esi
801013e7:	89 c6                	mov    %eax,%esi
801013e9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ea:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
801013ef:	83 ec 28             	sub    $0x28,%esp
801013f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801013f5:	68 60 09 11 80       	push   $0x80110960
801013fa:	e8 31 36 00 00       	call   80104a30 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101402:	83 c4 10             	add    $0x10,%esp
80101405:	eb 1b                	jmp    80101422 <iget+0x42>
80101407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010140e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101410:	39 33                	cmp    %esi,(%ebx)
80101412:	74 6c                	je     80101480 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101414:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101420:	74 26                	je     80101448 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101422:	8b 43 08             	mov    0x8(%ebx),%eax
80101425:	85 c0                	test   %eax,%eax
80101427:	7f e7                	jg     80101410 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101429:	85 ff                	test   %edi,%edi
8010142b:	75 e7                	jne    80101414 <iget+0x34>
8010142d:	85 c0                	test   %eax,%eax
8010142f:	75 76                	jne    801014a7 <iget+0xc7>
      empty = ip;
80101431:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101433:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101439:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010143f:	75 e1                	jne    80101422 <iget+0x42>
80101441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101448:	85 ff                	test   %edi,%edi
8010144a:	74 79                	je     801014c5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010144c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010144f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101451:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101454:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010145b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101462:	68 60 09 11 80       	push   $0x80110960
80101467:	e8 64 35 00 00       	call   801049d0 <release>

  return ip;
8010146c:	83 c4 10             	add    $0x10,%esp
}
8010146f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101472:	89 f8                	mov    %edi,%eax
80101474:	5b                   	pop    %ebx
80101475:	5e                   	pop    %esi
80101476:	5f                   	pop    %edi
80101477:	5d                   	pop    %ebp
80101478:	c3                   	ret
80101479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101480:	39 53 04             	cmp    %edx,0x4(%ebx)
80101483:	75 8f                	jne    80101414 <iget+0x34>
      ip->ref++;
80101485:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101488:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010148b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010148d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101490:	68 60 09 11 80       	push   $0x80110960
80101495:	e8 36 35 00 00       	call   801049d0 <release>
      return ip;
8010149a:	83 c4 10             	add    $0x10,%esp
}
8010149d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a0:	89 f8                	mov    %edi,%eax
801014a2:	5b                   	pop    %ebx
801014a3:	5e                   	pop    %esi
801014a4:	5f                   	pop    %edi
801014a5:	5d                   	pop    %ebp
801014a6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014a7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014ad:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801014b3:	74 10                	je     801014c5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014b5:	8b 43 08             	mov    0x8(%ebx),%eax
801014b8:	85 c0                	test   %eax,%eax
801014ba:	0f 8f 50 ff ff ff    	jg     80101410 <iget+0x30>
801014c0:	e9 68 ff ff ff       	jmp    8010142d <iget+0x4d>
    panic("iget: no inodes");
801014c5:	83 ec 0c             	sub    $0xc,%esp
801014c8:	68 04 7e 10 80       	push   $0x80107e04
801014cd:	e8 9e ef ff ff       	call   80100470 <panic>
801014d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014e0 <bfree>:
{
801014e0:	55                   	push   %ebp
801014e1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
801014e3:	89 d0                	mov    %edx,%eax
801014e5:	c1 e8 0c             	shr    $0xc,%eax
{
801014e8:	89 e5                	mov    %esp,%ebp
801014ea:	56                   	push   %esi
801014eb:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
801014ec:	03 05 e0 25 11 80    	add    0x801125e0,%eax
{
801014f2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801014f4:	83 ec 08             	sub    $0x8,%esp
801014f7:	50                   	push   %eax
801014f8:	51                   	push   %ecx
801014f9:	e8 d2 eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014fe:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101500:	c1 fb 03             	sar    $0x3,%ebx
80101503:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101506:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101508:	83 e1 07             	and    $0x7,%ecx
8010150b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101510:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101516:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101518:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010151d:	85 c1                	test   %eax,%ecx
8010151f:	74 23                	je     80101544 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101521:	f7 d0                	not    %eax
  log_write(bp);
80101523:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101526:	21 c8                	and    %ecx,%eax
80101528:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010152c:	56                   	push   %esi
8010152d:	e8 de 1b 00 00       	call   80103110 <log_write>
  brelse(bp);
80101532:	89 34 24             	mov    %esi,(%esp)
80101535:	e8 b6 ec ff ff       	call   801001f0 <brelse>
}
8010153a:	83 c4 10             	add    $0x10,%esp
8010153d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101540:	5b                   	pop    %ebx
80101541:	5e                   	pop    %esi
80101542:	5d                   	pop    %ebp
80101543:	c3                   	ret
    panic("freeing free block");
80101544:	83 ec 0c             	sub    $0xc,%esp
80101547:	68 14 7e 10 80       	push   $0x80107e14
8010154c:	e8 1f ef ff ff       	call   80100470 <panic>
80101551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155f:	90                   	nop

80101560 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	57                   	push   %edi
80101564:	56                   	push   %esi
80101565:	89 c6                	mov    %eax,%esi
80101567:	53                   	push   %ebx
80101568:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010156b:	83 fa 0b             	cmp    $0xb,%edx
8010156e:	0f 86 8c 00 00 00    	jbe    80101600 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101574:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101577:	83 fb 7f             	cmp    $0x7f,%ebx
8010157a:	0f 87 a2 00 00 00    	ja     80101622 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101580:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101586:	85 c0                	test   %eax,%eax
80101588:	74 5e                	je     801015e8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010158a:	83 ec 08             	sub    $0x8,%esp
8010158d:	50                   	push   %eax
8010158e:	ff 36                	push   (%esi)
80101590:	e8 3b eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101595:	83 c4 10             	add    $0x10,%esp
80101598:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010159c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010159e:	8b 3b                	mov    (%ebx),%edi
801015a0:	85 ff                	test   %edi,%edi
801015a2:	74 1c                	je     801015c0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801015a4:	83 ec 0c             	sub    $0xc,%esp
801015a7:	52                   	push   %edx
801015a8:	e8 43 ec ff ff       	call   801001f0 <brelse>
801015ad:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015b3:	89 f8                	mov    %edi,%eax
801015b5:	5b                   	pop    %ebx
801015b6:	5e                   	pop    %esi
801015b7:	5f                   	pop    %edi
801015b8:	5d                   	pop    %ebp
801015b9:	c3                   	ret
801015ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801015c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801015c3:	8b 06                	mov    (%esi),%eax
801015c5:	e8 06 fd ff ff       	call   801012d0 <balloc>
      log_write(bp);
801015ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015cd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801015d0:	89 03                	mov    %eax,(%ebx)
801015d2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801015d4:	52                   	push   %edx
801015d5:	e8 36 1b 00 00       	call   80103110 <log_write>
801015da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015dd:	83 c4 10             	add    $0x10,%esp
801015e0:	eb c2                	jmp    801015a4 <bmap+0x44>
801015e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801015e8:	8b 06                	mov    (%esi),%eax
801015ea:	e8 e1 fc ff ff       	call   801012d0 <balloc>
801015ef:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801015f5:	eb 93                	jmp    8010158a <bmap+0x2a>
801015f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015fe:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101600:	8d 5a 14             	lea    0x14(%edx),%ebx
80101603:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101607:	85 ff                	test   %edi,%edi
80101609:	75 a5                	jne    801015b0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010160b:	8b 00                	mov    (%eax),%eax
8010160d:	e8 be fc ff ff       	call   801012d0 <balloc>
80101612:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101616:	89 c7                	mov    %eax,%edi
}
80101618:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010161b:	5b                   	pop    %ebx
8010161c:	89 f8                	mov    %edi,%eax
8010161e:	5e                   	pop    %esi
8010161f:	5f                   	pop    %edi
80101620:	5d                   	pop    %ebp
80101621:	c3                   	ret
  panic("bmap: out of range");
80101622:	83 ec 0c             	sub    $0xc,%esp
80101625:	68 27 7e 10 80       	push   $0x80107e27
8010162a:	e8 41 ee ff ff       	call   80100470 <panic>
8010162f:	90                   	nop

80101630 <readsb>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	56                   	push   %esi
80101634:	53                   	push   %ebx
80101635:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101638:	83 ec 08             	sub    $0x8,%esp
8010163b:	6a 01                	push   $0x1
8010163d:	ff 75 08             	push   0x8(%ebp)
80101640:	e8 8b ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101645:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101648:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010164a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010164d:	6a 24                	push   $0x24
8010164f:	50                   	push   %eax
80101650:	56                   	push   %esi
80101651:	e8 6a 35 00 00       	call   80104bc0 <memmove>
  brelse(bp);
80101656:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101659:	83 c4 10             	add    $0x10,%esp
}
8010165c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010165f:	5b                   	pop    %ebx
80101660:	5e                   	pop    %esi
80101661:	5d                   	pop    %ebp
  brelse(bp);
80101662:	e9 89 eb ff ff       	jmp    801001f0 <brelse>
80101667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010166e:	66 90                	xchg   %ax,%ax

80101670 <iinit>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	53                   	push   %ebx
80101674:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101679:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010167c:	68 3a 7e 10 80       	push   $0x80107e3a
80101681:	68 60 09 11 80       	push   $0x80110960
80101686:	e8 b5 31 00 00       	call   80104840 <initlock>
  for(i = 0; i < NINODE; i++) {
8010168b:	83 c4 10             	add    $0x10,%esp
8010168e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101690:	83 ec 08             	sub    $0x8,%esp
80101693:	68 41 7e 10 80       	push   $0x80107e41
80101698:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101699:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010169f:	e8 6c 30 00 00       	call   80104710 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801016a4:	83 c4 10             	add    $0x10,%esp
801016a7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801016ad:	75 e1                	jne    80101690 <iinit+0x20>
  bp = bread(dev, 1);
801016af:	83 ec 08             	sub    $0x8,%esp
801016b2:	6a 01                	push   $0x1
801016b4:	ff 75 08             	push   0x8(%ebp)
801016b7:	e8 14 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801016bc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801016bf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801016c1:	8d 40 5c             	lea    0x5c(%eax),%eax
801016c4:	6a 24                	push   $0x24
801016c6:	50                   	push   %eax
801016c7:	68 c0 25 11 80       	push   $0x801125c0
801016cc:	e8 ef 34 00 00       	call   80104bc0 <memmove>
  brelse(bp);
801016d1:	89 1c 24             	mov    %ebx,(%esp)
801016d4:	e8 17 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016d9:	ff 35 e0 25 11 80    	push   0x801125e0
801016df:	ff 35 dc 25 11 80    	push   0x801125dc
801016e5:	ff 35 d8 25 11 80    	push   0x801125d8
801016eb:	ff 35 cc 25 11 80    	push   0x801125cc
801016f1:	ff 35 c8 25 11 80    	push   0x801125c8
801016f7:	ff 35 c4 25 11 80    	push   0x801125c4
801016fd:	ff 35 c0 25 11 80    	push   0x801125c0
80101703:	68 2c 83 10 80       	push   $0x8010832c
80101708:	e8 93 f0 ff ff       	call   801007a0 <cprintf>
}
8010170d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101710:	83 c4 30             	add    $0x30,%esp
80101713:	c9                   	leave
80101714:	c3                   	ret
80101715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010171c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101720 <ialloc>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	57                   	push   %edi
80101724:	56                   	push   %esi
80101725:	53                   	push   %ebx
80101726:	83 ec 1c             	sub    $0x1c,%esp
80101729:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010172c:	83 3d c8 25 11 80 01 	cmpl   $0x1,0x801125c8
{
80101733:	8b 75 08             	mov    0x8(%ebp),%esi
80101736:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101739:	0f 86 91 00 00 00    	jbe    801017d0 <ialloc+0xb0>
8010173f:	bf 01 00 00 00       	mov    $0x1,%edi
80101744:	eb 21                	jmp    80101767 <ialloc+0x47>
80101746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010174d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101750:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101753:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101756:	53                   	push   %ebx
80101757:	e8 94 ea ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010175c:	83 c4 10             	add    $0x10,%esp
8010175f:	3b 3d c8 25 11 80    	cmp    0x801125c8,%edi
80101765:	73 69                	jae    801017d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101767:	89 f8                	mov    %edi,%eax
80101769:	83 ec 08             	sub    $0x8,%esp
8010176c:	c1 e8 03             	shr    $0x3,%eax
8010176f:	03 05 dc 25 11 80    	add    0x801125dc,%eax
80101775:	50                   	push   %eax
80101776:	56                   	push   %esi
80101777:	e8 54 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010177c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010177f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101781:	89 f8                	mov    %edi,%eax
80101783:	83 e0 07             	and    $0x7,%eax
80101786:	c1 e0 06             	shl    $0x6,%eax
80101789:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010178d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101791:	75 bd                	jne    80101750 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101793:	83 ec 04             	sub    $0x4,%esp
80101796:	6a 40                	push   $0x40
80101798:	6a 00                	push   $0x0
8010179a:	51                   	push   %ecx
8010179b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010179e:	e8 8d 33 00 00       	call   80104b30 <memset>
      dip->type = type;
801017a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017ad:	89 1c 24             	mov    %ebx,(%esp)
801017b0:	e8 5b 19 00 00       	call   80103110 <log_write>
      brelse(bp);
801017b5:	89 1c 24             	mov    %ebx,(%esp)
801017b8:	e8 33 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801017bd:	83 c4 10             	add    $0x10,%esp
}
801017c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801017c3:	89 fa                	mov    %edi,%edx
}
801017c5:	5b                   	pop    %ebx
      return iget(dev, inum);
801017c6:	89 f0                	mov    %esi,%eax
}
801017c8:	5e                   	pop    %esi
801017c9:	5f                   	pop    %edi
801017ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801017cb:	e9 10 fc ff ff       	jmp    801013e0 <iget>
  panic("ialloc: no inodes");
801017d0:	83 ec 0c             	sub    $0xc,%esp
801017d3:	68 47 7e 10 80       	push   $0x80107e47
801017d8:	e8 93 ec ff ff       	call   80100470 <panic>
801017dd:	8d 76 00             	lea    0x0(%esi),%esi

801017e0 <iupdate>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	56                   	push   %esi
801017e4:	53                   	push   %ebx
801017e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017eb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ee:	83 ec 08             	sub    $0x8,%esp
801017f1:	c1 e8 03             	shr    $0x3,%eax
801017f4:	03 05 dc 25 11 80    	add    0x801125dc,%eax
801017fa:	50                   	push   %eax
801017fb:	ff 73 a4             	push   -0x5c(%ebx)
801017fe:	e8 cd e8 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101803:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101807:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010180a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010180c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010180f:	83 e0 07             	and    $0x7,%eax
80101812:	c1 e0 06             	shl    $0x6,%eax
80101815:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101819:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010181c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101820:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101823:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101827:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010182b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010182f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101833:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101837:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010183a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010183d:	6a 34                	push   $0x34
8010183f:	53                   	push   %ebx
80101840:	50                   	push   %eax
80101841:	e8 7a 33 00 00       	call   80104bc0 <memmove>
  log_write(bp);
80101846:	89 34 24             	mov    %esi,(%esp)
80101849:	e8 c2 18 00 00       	call   80103110 <log_write>
  brelse(bp);
8010184e:	89 75 08             	mov    %esi,0x8(%ebp)
80101851:	83 c4 10             	add    $0x10,%esp
}
80101854:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101857:	5b                   	pop    %ebx
80101858:	5e                   	pop    %esi
80101859:	5d                   	pop    %ebp
  brelse(bp);
8010185a:	e9 91 e9 ff ff       	jmp    801001f0 <brelse>
8010185f:	90                   	nop

80101860 <idup>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	53                   	push   %ebx
80101864:	83 ec 10             	sub    $0x10,%esp
80101867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010186a:	68 60 09 11 80       	push   $0x80110960
8010186f:	e8 bc 31 00 00       	call   80104a30 <acquire>
  ip->ref++;
80101874:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101878:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010187f:	e8 4c 31 00 00       	call   801049d0 <release>
}
80101884:	89 d8                	mov    %ebx,%eax
80101886:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101889:	c9                   	leave
8010188a:	c3                   	ret
8010188b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010188f:	90                   	nop

80101890 <ilock>:
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	56                   	push   %esi
80101894:	53                   	push   %ebx
80101895:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101898:	85 db                	test   %ebx,%ebx
8010189a:	0f 84 b7 00 00 00    	je     80101957 <ilock+0xc7>
801018a0:	8b 53 08             	mov    0x8(%ebx),%edx
801018a3:	85 d2                	test   %edx,%edx
801018a5:	0f 8e ac 00 00 00    	jle    80101957 <ilock+0xc7>
  acquiresleep(&ip->lock);
801018ab:	83 ec 0c             	sub    $0xc,%esp
801018ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801018b1:	50                   	push   %eax
801018b2:	e8 99 2e 00 00       	call   80104750 <acquiresleep>
  if(ip->valid == 0){
801018b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	85 c0                	test   %eax,%eax
801018bf:	74 0f                	je     801018d0 <ilock+0x40>
}
801018c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018c4:	5b                   	pop    %ebx
801018c5:	5e                   	pop    %esi
801018c6:	5d                   	pop    %ebp
801018c7:	c3                   	ret
801018c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018d0:	8b 43 04             	mov    0x4(%ebx),%eax
801018d3:	83 ec 08             	sub    $0x8,%esp
801018d6:	c1 e8 03             	shr    $0x3,%eax
801018d9:	03 05 dc 25 11 80    	add    0x801125dc,%eax
801018df:	50                   	push   %eax
801018e0:	ff 33                	push   (%ebx)
801018e2:	e8 e9 e7 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018e7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018ea:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018ec:	8b 43 04             	mov    0x4(%ebx),%eax
801018ef:	83 e0 07             	and    $0x7,%eax
801018f2:	c1 e0 06             	shl    $0x6,%eax
801018f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801018f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801018ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101903:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101907:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010190b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010190f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101913:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101917:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010191b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010191e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101921:	6a 34                	push   $0x34
80101923:	50                   	push   %eax
80101924:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101927:	50                   	push   %eax
80101928:	e8 93 32 00 00       	call   80104bc0 <memmove>
    brelse(bp);
8010192d:	89 34 24             	mov    %esi,(%esp)
80101930:	e8 bb e8 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101935:	83 c4 10             	add    $0x10,%esp
80101938:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010193d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101944:	0f 85 77 ff ff ff    	jne    801018c1 <ilock+0x31>
      panic("ilock: no type");
8010194a:	83 ec 0c             	sub    $0xc,%esp
8010194d:	68 5f 7e 10 80       	push   $0x80107e5f
80101952:	e8 19 eb ff ff       	call   80100470 <panic>
    panic("ilock");
80101957:	83 ec 0c             	sub    $0xc,%esp
8010195a:	68 59 7e 10 80       	push   $0x80107e59
8010195f:	e8 0c eb ff ff       	call   80100470 <panic>
80101964:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010196b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010196f:	90                   	nop

80101970 <iunlock>:
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	56                   	push   %esi
80101974:	53                   	push   %ebx
80101975:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101978:	85 db                	test   %ebx,%ebx
8010197a:	74 28                	je     801019a4 <iunlock+0x34>
8010197c:	83 ec 0c             	sub    $0xc,%esp
8010197f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101982:	56                   	push   %esi
80101983:	e8 68 2e 00 00       	call   801047f0 <holdingsleep>
80101988:	83 c4 10             	add    $0x10,%esp
8010198b:	85 c0                	test   %eax,%eax
8010198d:	74 15                	je     801019a4 <iunlock+0x34>
8010198f:	8b 43 08             	mov    0x8(%ebx),%eax
80101992:	85 c0                	test   %eax,%eax
80101994:	7e 0e                	jle    801019a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101996:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101999:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010199c:	5b                   	pop    %ebx
8010199d:	5e                   	pop    %esi
8010199e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010199f:	e9 0c 2e 00 00       	jmp    801047b0 <releasesleep>
    panic("iunlock");
801019a4:	83 ec 0c             	sub    $0xc,%esp
801019a7:	68 6e 7e 10 80       	push   $0x80107e6e
801019ac:	e8 bf ea ff ff       	call   80100470 <panic>
801019b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop

801019c0 <iput>:
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	57                   	push   %edi
801019c4:	56                   	push   %esi
801019c5:	53                   	push   %ebx
801019c6:	83 ec 28             	sub    $0x28,%esp
801019c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801019cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801019cf:	57                   	push   %edi
801019d0:	e8 7b 2d 00 00       	call   80104750 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801019d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801019d8:	83 c4 10             	add    $0x10,%esp
801019db:	85 d2                	test   %edx,%edx
801019dd:	74 07                	je     801019e6 <iput+0x26>
801019df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801019e4:	74 32                	je     80101a18 <iput+0x58>
  releasesleep(&ip->lock);
801019e6:	83 ec 0c             	sub    $0xc,%esp
801019e9:	57                   	push   %edi
801019ea:	e8 c1 2d 00 00       	call   801047b0 <releasesleep>
  acquire(&icache.lock);
801019ef:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801019f6:	e8 35 30 00 00       	call   80104a30 <acquire>
  ip->ref--;
801019fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801019ff:	83 c4 10             	add    $0x10,%esp
80101a02:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101a09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a0c:	5b                   	pop    %ebx
80101a0d:	5e                   	pop    %esi
80101a0e:	5f                   	pop    %edi
80101a0f:	5d                   	pop    %ebp
  release(&icache.lock);
80101a10:	e9 bb 2f 00 00       	jmp    801049d0 <release>
80101a15:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101a18:	83 ec 0c             	sub    $0xc,%esp
80101a1b:	68 60 09 11 80       	push   $0x80110960
80101a20:	e8 0b 30 00 00       	call   80104a30 <acquire>
    int r = ip->ref;
80101a25:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a28:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101a2f:	e8 9c 2f 00 00       	call   801049d0 <release>
    if(r == 1){
80101a34:	83 c4 10             	add    $0x10,%esp
80101a37:	83 fe 01             	cmp    $0x1,%esi
80101a3a:	75 aa                	jne    801019e6 <iput+0x26>
80101a3c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a42:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a45:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101a48:	89 df                	mov    %ebx,%edi
80101a4a:	89 cb                	mov    %ecx,%ebx
80101a4c:	eb 09                	jmp    80101a57 <iput+0x97>
80101a4e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a50:	83 c6 04             	add    $0x4,%esi
80101a53:	39 de                	cmp    %ebx,%esi
80101a55:	74 19                	je     80101a70 <iput+0xb0>
    if(ip->addrs[i]){
80101a57:	8b 16                	mov    (%esi),%edx
80101a59:	85 d2                	test   %edx,%edx
80101a5b:	74 f3                	je     80101a50 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a5d:	8b 07                	mov    (%edi),%eax
80101a5f:	e8 7c fa ff ff       	call   801014e0 <bfree>
      ip->addrs[i] = 0;
80101a64:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a6a:	eb e4                	jmp    80101a50 <iput+0x90>
80101a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a70:	89 fb                	mov    %edi,%ebx
80101a72:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a75:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a7b:	85 c0                	test   %eax,%eax
80101a7d:	75 2d                	jne    80101aac <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a7f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a82:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a89:	53                   	push   %ebx
80101a8a:	e8 51 fd ff ff       	call   801017e0 <iupdate>
      ip->type = 0;
80101a8f:	31 c0                	xor    %eax,%eax
80101a91:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a95:	89 1c 24             	mov    %ebx,(%esp)
80101a98:	e8 43 fd ff ff       	call   801017e0 <iupdate>
      ip->valid = 0;
80101a9d:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101aa4:	83 c4 10             	add    $0x10,%esp
80101aa7:	e9 3a ff ff ff       	jmp    801019e6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101aac:	83 ec 08             	sub    $0x8,%esp
80101aaf:	50                   	push   %eax
80101ab0:	ff 33                	push   (%ebx)
80101ab2:	e8 19 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101ab7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101aba:	83 c4 10             	add    $0x10,%esp
80101abd:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101ac3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101ac6:	8d 70 5c             	lea    0x5c(%eax),%esi
80101ac9:	89 cf                	mov    %ecx,%edi
80101acb:	eb 0a                	jmp    80101ad7 <iput+0x117>
80101acd:	8d 76 00             	lea    0x0(%esi),%esi
80101ad0:	83 c6 04             	add    $0x4,%esi
80101ad3:	39 fe                	cmp    %edi,%esi
80101ad5:	74 0f                	je     80101ae6 <iput+0x126>
      if(a[j])
80101ad7:	8b 16                	mov    (%esi),%edx
80101ad9:	85 d2                	test   %edx,%edx
80101adb:	74 f3                	je     80101ad0 <iput+0x110>
        bfree(ip->dev, a[j]);
80101add:	8b 03                	mov    (%ebx),%eax
80101adf:	e8 fc f9 ff ff       	call   801014e0 <bfree>
80101ae4:	eb ea                	jmp    80101ad0 <iput+0x110>
    brelse(bp);
80101ae6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ae9:	83 ec 0c             	sub    $0xc,%esp
80101aec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101aef:	50                   	push   %eax
80101af0:	e8 fb e6 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101af5:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101afb:	8b 03                	mov    (%ebx),%eax
80101afd:	e8 de f9 ff ff       	call   801014e0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b02:	83 c4 10             	add    $0x10,%esp
80101b05:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b0c:	00 00 00 
80101b0f:	e9 6b ff ff ff       	jmp    80101a7f <iput+0xbf>
80101b14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b1f:	90                   	nop

80101b20 <iunlockput>:
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	56                   	push   %esi
80101b24:	53                   	push   %ebx
80101b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b28:	85 db                	test   %ebx,%ebx
80101b2a:	74 34                	je     80101b60 <iunlockput+0x40>
80101b2c:	83 ec 0c             	sub    $0xc,%esp
80101b2f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b32:	56                   	push   %esi
80101b33:	e8 b8 2c 00 00       	call   801047f0 <holdingsleep>
80101b38:	83 c4 10             	add    $0x10,%esp
80101b3b:	85 c0                	test   %eax,%eax
80101b3d:	74 21                	je     80101b60 <iunlockput+0x40>
80101b3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b42:	85 c0                	test   %eax,%eax
80101b44:	7e 1a                	jle    80101b60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101b46:	83 ec 0c             	sub    $0xc,%esp
80101b49:	56                   	push   %esi
80101b4a:	e8 61 2c 00 00       	call   801047b0 <releasesleep>
  iput(ip);
80101b4f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b52:	83 c4 10             	add    $0x10,%esp
}
80101b55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5d                   	pop    %ebp
  iput(ip);
80101b5b:	e9 60 fe ff ff       	jmp    801019c0 <iput>
    panic("iunlock");
80101b60:	83 ec 0c             	sub    $0xc,%esp
80101b63:	68 6e 7e 10 80       	push   $0x80107e6e
80101b68:	e8 03 e9 ff ff       	call   80100470 <panic>
80101b6d:	8d 76 00             	lea    0x0(%esi),%esi

80101b70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	8b 55 08             	mov    0x8(%ebp),%edx
80101b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b79:	8b 0a                	mov    (%edx),%ecx
80101b7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b93:	8b 52 58             	mov    0x58(%edx),%edx
80101b96:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b99:	5d                   	pop    %ebp
80101b9a:	c3                   	ret
80101b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b9f:	90                   	nop

80101ba0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 75 08             	mov    0x8(%ebp),%esi
80101bac:	8b 45 0c             	mov    0xc(%ebp),%eax
80101baf:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bb2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101bb7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101bba:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101bbd:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101bc0:	0f 84 aa 00 00 00    	je     80101c70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101bc6:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101bc9:	8b 56 58             	mov    0x58(%esi),%edx
80101bcc:	39 fa                	cmp    %edi,%edx
80101bce:	0f 82 bd 00 00 00    	jb     80101c91 <readi+0xf1>
80101bd4:	89 f9                	mov    %edi,%ecx
80101bd6:	31 db                	xor    %ebx,%ebx
80101bd8:	01 c1                	add    %eax,%ecx
80101bda:	0f 92 c3             	setb   %bl
80101bdd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101be0:	0f 82 ab 00 00 00    	jb     80101c91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101be6:	89 d3                	mov    %edx,%ebx
80101be8:	29 fb                	sub    %edi,%ebx
80101bea:	39 ca                	cmp    %ecx,%edx
80101bec:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bef:	85 c0                	test   %eax,%eax
80101bf1:	74 73                	je     80101c66 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101bf6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c03:	89 fa                	mov    %edi,%edx
80101c05:	c1 ea 09             	shr    $0x9,%edx
80101c08:	89 d8                	mov    %ebx,%eax
80101c0a:	e8 51 f9 ff ff       	call   80101560 <bmap>
80101c0f:	83 ec 08             	sub    $0x8,%esp
80101c12:	50                   	push   %eax
80101c13:	ff 33                	push   (%ebx)
80101c15:	e8 b6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c1d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c22:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	89 f8                	mov    %edi,%eax
80101c26:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c2b:	29 f3                	sub    %esi,%ebx
80101c2d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c2f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c33:	39 d9                	cmp    %ebx,%ecx
80101c35:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c38:	83 c4 0c             	add    $0xc,%esp
80101c3b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c3c:	01 de                	add    %ebx,%esi
80101c3e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101c40:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101c43:	50                   	push   %eax
80101c44:	ff 75 e0             	push   -0x20(%ebp)
80101c47:	e8 74 2f 00 00       	call   80104bc0 <memmove>
    brelse(bp);
80101c4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c4f:	89 14 24             	mov    %edx,(%esp)
80101c52:	e8 99 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c5a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c5d:	83 c4 10             	add    $0x10,%esp
80101c60:	39 de                	cmp    %ebx,%esi
80101c62:	72 9c                	jb     80101c00 <readi+0x60>
80101c64:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101c66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c69:	5b                   	pop    %ebx
80101c6a:	5e                   	pop    %esi
80101c6b:	5f                   	pop    %edi
80101c6c:	5d                   	pop    %ebp
80101c6d:	c3                   	ret
80101c6e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c70:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101c74:	66 83 fa 09          	cmp    $0x9,%dx
80101c78:	77 17                	ja     80101c91 <readi+0xf1>
80101c7a:	8b 14 d5 00 09 11 80 	mov    -0x7feef700(,%edx,8),%edx
80101c81:	85 d2                	test   %edx,%edx
80101c83:	74 0c                	je     80101c91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c85:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c8f:	ff e2                	jmp    *%edx
      return -1;
80101c91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c96:	eb ce                	jmp    80101c66 <readi+0xc6>
80101c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c9f:	90                   	nop

80101ca0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	57                   	push   %edi
80101ca4:	56                   	push   %esi
80101ca5:	53                   	push   %ebx
80101ca6:	83 ec 1c             	sub    $0x1c,%esp
80101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cac:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101caf:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101cb7:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101cba:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101cbd:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101cc0:	0f 84 ba 00 00 00    	je     80101d80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101cc6:	39 78 58             	cmp    %edi,0x58(%eax)
80101cc9:	0f 82 ea 00 00 00    	jb     80101db9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ccf:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101cd2:	89 f2                	mov    %esi,%edx
80101cd4:	01 fa                	add    %edi,%edx
80101cd6:	0f 82 dd 00 00 00    	jb     80101db9 <writei+0x119>
80101cdc:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101ce2:	0f 87 d1 00 00 00    	ja     80101db9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ce8:	85 f6                	test   %esi,%esi
80101cea:	0f 84 85 00 00 00    	je     80101d75 <writei+0xd5>
80101cf0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101cf7:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d00:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101d03:	89 fa                	mov    %edi,%edx
80101d05:	c1 ea 09             	shr    $0x9,%edx
80101d08:	89 f0                	mov    %esi,%eax
80101d0a:	e8 51 f8 ff ff       	call   80101560 <bmap>
80101d0f:	83 ec 08             	sub    $0x8,%esp
80101d12:	50                   	push   %eax
80101d13:	ff 36                	push   (%esi)
80101d15:	e8 b6 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d1d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d20:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d25:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d27:	89 f8                	mov    %edi,%eax
80101d29:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d2e:	29 d3                	sub    %edx,%ebx
80101d30:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d32:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d36:	39 d9                	cmp    %ebx,%ecx
80101d38:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d3b:	83 c4 0c             	add    $0xc,%esp
80101d3e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d3f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101d41:	ff 75 dc             	push   -0x24(%ebp)
80101d44:	50                   	push   %eax
80101d45:	e8 76 2e 00 00       	call   80104bc0 <memmove>
    log_write(bp);
80101d4a:	89 34 24             	mov    %esi,(%esp)
80101d4d:	e8 be 13 00 00       	call   80103110 <log_write>
    brelse(bp);
80101d52:	89 34 24             	mov    %esi,(%esp)
80101d55:	e8 96 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d5a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d60:	83 c4 10             	add    $0x10,%esp
80101d63:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d66:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d69:	39 d8                	cmp    %ebx,%eax
80101d6b:	72 93                	jb     80101d00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101d6d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d70:	39 78 58             	cmp    %edi,0x58(%eax)
80101d73:	72 33                	jb     80101da8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d75:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7b:	5b                   	pop    %ebx
80101d7c:	5e                   	pop    %esi
80101d7d:	5f                   	pop    %edi
80101d7e:	5d                   	pop    %ebp
80101d7f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d84:	66 83 f8 09          	cmp    $0x9,%ax
80101d88:	77 2f                	ja     80101db9 <writei+0x119>
80101d8a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101d91:	85 c0                	test   %eax,%eax
80101d93:	74 24                	je     80101db9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101d95:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d9b:	5b                   	pop    %ebx
80101d9c:	5e                   	pop    %esi
80101d9d:	5f                   	pop    %edi
80101d9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d9f:	ff e0                	jmp    *%eax
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101da8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101dab:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101dae:	50                   	push   %eax
80101daf:	e8 2c fa ff ff       	call   801017e0 <iupdate>
80101db4:	83 c4 10             	add    $0x10,%esp
80101db7:	eb bc                	jmp    80101d75 <writei+0xd5>
      return -1;
80101db9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dbe:	eb b8                	jmp    80101d78 <writei+0xd8>

80101dc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101dc0:	55                   	push   %ebp
80101dc1:	89 e5                	mov    %esp,%ebp
80101dc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101dc6:	6a 0e                	push   $0xe
80101dc8:	ff 75 0c             	push   0xc(%ebp)
80101dcb:	ff 75 08             	push   0x8(%ebp)
80101dce:	e8 5d 2e 00 00       	call   80104c30 <strncmp>
}
80101dd3:	c9                   	leave
80101dd4:	c3                   	ret
80101dd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101de0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101de0:	55                   	push   %ebp
80101de1:	89 e5                	mov    %esp,%ebp
80101de3:	57                   	push   %edi
80101de4:	56                   	push   %esi
80101de5:	53                   	push   %ebx
80101de6:	83 ec 1c             	sub    $0x1c,%esp
80101de9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101dec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101df1:	0f 85 85 00 00 00    	jne    80101e7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101df7:	8b 53 58             	mov    0x58(%ebx),%edx
80101dfa:	31 ff                	xor    %edi,%edi
80101dfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101dff:	85 d2                	test   %edx,%edx
80101e01:	74 3e                	je     80101e41 <dirlookup+0x61>
80101e03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e08:	6a 10                	push   $0x10
80101e0a:	57                   	push   %edi
80101e0b:	56                   	push   %esi
80101e0c:	53                   	push   %ebx
80101e0d:	e8 8e fd ff ff       	call   80101ba0 <readi>
80101e12:	83 c4 10             	add    $0x10,%esp
80101e15:	83 f8 10             	cmp    $0x10,%eax
80101e18:	75 55                	jne    80101e6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101e1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e1f:	74 18                	je     80101e39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101e21:	83 ec 04             	sub    $0x4,%esp
80101e24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e27:	6a 0e                	push   $0xe
80101e29:	50                   	push   %eax
80101e2a:	ff 75 0c             	push   0xc(%ebp)
80101e2d:	e8 fe 2d 00 00       	call   80104c30 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e32:	83 c4 10             	add    $0x10,%esp
80101e35:	85 c0                	test   %eax,%eax
80101e37:	74 17                	je     80101e50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e39:	83 c7 10             	add    $0x10,%edi
80101e3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e3f:	72 c7                	jb     80101e08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e44:	31 c0                	xor    %eax,%eax
}
80101e46:	5b                   	pop    %ebx
80101e47:	5e                   	pop    %esi
80101e48:	5f                   	pop    %edi
80101e49:	5d                   	pop    %ebp
80101e4a:	c3                   	ret
80101e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e4f:	90                   	nop
      if(poff)
80101e50:	8b 45 10             	mov    0x10(%ebp),%eax
80101e53:	85 c0                	test   %eax,%eax
80101e55:	74 05                	je     80101e5c <dirlookup+0x7c>
        *poff = off;
80101e57:	8b 45 10             	mov    0x10(%ebp),%eax
80101e5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e60:	8b 03                	mov    (%ebx),%eax
80101e62:	e8 79 f5 ff ff       	call   801013e0 <iget>
}
80101e67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e6a:	5b                   	pop    %ebx
80101e6b:	5e                   	pop    %esi
80101e6c:	5f                   	pop    %edi
80101e6d:	5d                   	pop    %ebp
80101e6e:	c3                   	ret
      panic("dirlookup read");
80101e6f:	83 ec 0c             	sub    $0xc,%esp
80101e72:	68 88 7e 10 80       	push   $0x80107e88
80101e77:	e8 f4 e5 ff ff       	call   80100470 <panic>
    panic("dirlookup not DIR");
80101e7c:	83 ec 0c             	sub    $0xc,%esp
80101e7f:	68 76 7e 10 80       	push   $0x80107e76
80101e84:	e8 e7 e5 ff ff       	call   80100470 <panic>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e90:	55                   	push   %ebp
80101e91:	89 e5                	mov    %esp,%ebp
80101e93:	57                   	push   %edi
80101e94:	56                   	push   %esi
80101e95:	53                   	push   %ebx
80101e96:	89 c3                	mov    %eax,%ebx
80101e98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101ea1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101ea4:	0f 84 9e 01 00 00    	je     80102048 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101eaa:	e8 91 1c 00 00       	call   80103b40 <myproc>
  acquire(&icache.lock);
80101eaf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101eb2:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101eb5:	68 60 09 11 80       	push   $0x80110960
80101eba:	e8 71 2b 00 00       	call   80104a30 <acquire>
  ip->ref++;
80101ebf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ec3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101eca:	e8 01 2b 00 00       	call   801049d0 <release>
80101ecf:	83 c4 10             	add    $0x10,%esp
80101ed2:	eb 07                	jmp    80101edb <namex+0x4b>
80101ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ed8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101edb:	0f b6 03             	movzbl (%ebx),%eax
80101ede:	3c 2f                	cmp    $0x2f,%al
80101ee0:	74 f6                	je     80101ed8 <namex+0x48>
  if(*path == 0)
80101ee2:	84 c0                	test   %al,%al
80101ee4:	0f 84 06 01 00 00    	je     80101ff0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101eea:	0f b6 03             	movzbl (%ebx),%eax
80101eed:	84 c0                	test   %al,%al
80101eef:	0f 84 10 01 00 00    	je     80102005 <namex+0x175>
80101ef5:	89 df                	mov    %ebx,%edi
80101ef7:	3c 2f                	cmp    $0x2f,%al
80101ef9:	0f 84 06 01 00 00    	je     80102005 <namex+0x175>
80101eff:	90                   	nop
80101f00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101f04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101f07:	3c 2f                	cmp    $0x2f,%al
80101f09:	74 04                	je     80101f0f <namex+0x7f>
80101f0b:	84 c0                	test   %al,%al
80101f0d:	75 f1                	jne    80101f00 <namex+0x70>
  len = path - s;
80101f0f:	89 f8                	mov    %edi,%eax
80101f11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101f13:	83 f8 0d             	cmp    $0xd,%eax
80101f16:	0f 8e ac 00 00 00    	jle    80101fc8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101f1c:	83 ec 04             	sub    $0x4,%esp
80101f1f:	6a 0e                	push   $0xe
80101f21:	53                   	push   %ebx
80101f22:	89 fb                	mov    %edi,%ebx
80101f24:	ff 75 e4             	push   -0x1c(%ebp)
80101f27:	e8 94 2c 00 00       	call   80104bc0 <memmove>
80101f2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101f32:	75 0c                	jne    80101f40 <namex+0xb0>
80101f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f3e:	74 f8                	je     80101f38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f40:	83 ec 0c             	sub    $0xc,%esp
80101f43:	56                   	push   %esi
80101f44:	e8 47 f9 ff ff       	call   80101890 <ilock>
    if(ip->type != T_DIR){
80101f49:	83 c4 10             	add    $0x10,%esp
80101f4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f51:	0f 85 b7 00 00 00    	jne    8010200e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f5a:	85 c0                	test   %eax,%eax
80101f5c:	74 09                	je     80101f67 <namex+0xd7>
80101f5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f61:	0f 84 f7 00 00 00    	je     8010205e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f67:	83 ec 04             	sub    $0x4,%esp
80101f6a:	6a 00                	push   $0x0
80101f6c:	ff 75 e4             	push   -0x1c(%ebp)
80101f6f:	56                   	push   %esi
80101f70:	e8 6b fe ff ff       	call   80101de0 <dirlookup>
80101f75:	83 c4 10             	add    $0x10,%esp
80101f78:	89 c7                	mov    %eax,%edi
80101f7a:	85 c0                	test   %eax,%eax
80101f7c:	0f 84 8c 00 00 00    	je     8010200e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f82:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101f85:	83 ec 0c             	sub    $0xc,%esp
80101f88:	51                   	push   %ecx
80101f89:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f8c:	e8 5f 28 00 00       	call   801047f0 <holdingsleep>
80101f91:	83 c4 10             	add    $0x10,%esp
80101f94:	85 c0                	test   %eax,%eax
80101f96:	0f 84 02 01 00 00    	je     8010209e <namex+0x20e>
80101f9c:	8b 56 08             	mov    0x8(%esi),%edx
80101f9f:	85 d2                	test   %edx,%edx
80101fa1:	0f 8e f7 00 00 00    	jle    8010209e <namex+0x20e>
  releasesleep(&ip->lock);
80101fa7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101faa:	83 ec 0c             	sub    $0xc,%esp
80101fad:	51                   	push   %ecx
80101fae:	e8 fd 27 00 00       	call   801047b0 <releasesleep>
  iput(ip);
80101fb3:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101fb6:	89 fe                	mov    %edi,%esi
  iput(ip);
80101fb8:	e8 03 fa ff ff       	call   801019c0 <iput>
80101fbd:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101fc0:	e9 16 ff ff ff       	jmp    80101edb <namex+0x4b>
80101fc5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101fc8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fcb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101fce:	83 ec 04             	sub    $0x4,%esp
80101fd1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101fd4:	50                   	push   %eax
80101fd5:	53                   	push   %ebx
    name[len] = 0;
80101fd6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101fd8:	ff 75 e4             	push   -0x1c(%ebp)
80101fdb:	e8 e0 2b 00 00       	call   80104bc0 <memmove>
    name[len] = 0;
80101fe0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101fe3:	83 c4 10             	add    $0x10,%esp
80101fe6:	c6 01 00             	movb   $0x0,(%ecx)
80101fe9:	e9 41 ff ff ff       	jmp    80101f2f <namex+0x9f>
80101fee:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101ff0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ff3:	85 c0                	test   %eax,%eax
80101ff5:	0f 85 93 00 00 00    	jne    8010208e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ffb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ffe:	89 f0                	mov    %esi,%eax
80102000:	5b                   	pop    %ebx
80102001:	5e                   	pop    %esi
80102002:	5f                   	pop    %edi
80102003:	5d                   	pop    %ebp
80102004:	c3                   	ret
  while(*path != '/' && *path != 0)
80102005:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102008:	89 df                	mov    %ebx,%edi
8010200a:	31 c0                	xor    %eax,%eax
8010200c:	eb c0                	jmp    80101fce <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010200e:	83 ec 0c             	sub    $0xc,%esp
80102011:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102014:	53                   	push   %ebx
80102015:	e8 d6 27 00 00       	call   801047f0 <holdingsleep>
8010201a:	83 c4 10             	add    $0x10,%esp
8010201d:	85 c0                	test   %eax,%eax
8010201f:	74 7d                	je     8010209e <namex+0x20e>
80102021:	8b 4e 08             	mov    0x8(%esi),%ecx
80102024:	85 c9                	test   %ecx,%ecx
80102026:	7e 76                	jle    8010209e <namex+0x20e>
  releasesleep(&ip->lock);
80102028:	83 ec 0c             	sub    $0xc,%esp
8010202b:	53                   	push   %ebx
8010202c:	e8 7f 27 00 00       	call   801047b0 <releasesleep>
  iput(ip);
80102031:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102034:	31 f6                	xor    %esi,%esi
  iput(ip);
80102036:	e8 85 f9 ff ff       	call   801019c0 <iput>
      return 0;
8010203b:	83 c4 10             	add    $0x10,%esp
}
8010203e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102041:	89 f0                	mov    %esi,%eax
80102043:	5b                   	pop    %ebx
80102044:	5e                   	pop    %esi
80102045:	5f                   	pop    %edi
80102046:	5d                   	pop    %ebp
80102047:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80102048:	ba 01 00 00 00       	mov    $0x1,%edx
8010204d:	b8 01 00 00 00       	mov    $0x1,%eax
80102052:	e8 89 f3 ff ff       	call   801013e0 <iget>
80102057:	89 c6                	mov    %eax,%esi
80102059:	e9 7d fe ff ff       	jmp    80101edb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010205e:	83 ec 0c             	sub    $0xc,%esp
80102061:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102064:	53                   	push   %ebx
80102065:	e8 86 27 00 00       	call   801047f0 <holdingsleep>
8010206a:	83 c4 10             	add    $0x10,%esp
8010206d:	85 c0                	test   %eax,%eax
8010206f:	74 2d                	je     8010209e <namex+0x20e>
80102071:	8b 7e 08             	mov    0x8(%esi),%edi
80102074:	85 ff                	test   %edi,%edi
80102076:	7e 26                	jle    8010209e <namex+0x20e>
  releasesleep(&ip->lock);
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	53                   	push   %ebx
8010207c:	e8 2f 27 00 00       	call   801047b0 <releasesleep>
}
80102081:	83 c4 10             	add    $0x10,%esp
}
80102084:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102087:	89 f0                	mov    %esi,%eax
80102089:	5b                   	pop    %ebx
8010208a:	5e                   	pop    %esi
8010208b:	5f                   	pop    %edi
8010208c:	5d                   	pop    %ebp
8010208d:	c3                   	ret
    iput(ip);
8010208e:	83 ec 0c             	sub    $0xc,%esp
80102091:	56                   	push   %esi
      return 0;
80102092:	31 f6                	xor    %esi,%esi
    iput(ip);
80102094:	e8 27 f9 ff ff       	call   801019c0 <iput>
    return 0;
80102099:	83 c4 10             	add    $0x10,%esp
8010209c:	eb a0                	jmp    8010203e <namex+0x1ae>
    panic("iunlock");
8010209e:	83 ec 0c             	sub    $0xc,%esp
801020a1:	68 6e 7e 10 80       	push   $0x80107e6e
801020a6:	e8 c5 e3 ff ff       	call   80100470 <panic>
801020ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020af:	90                   	nop

801020b0 <dirlink>:
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	57                   	push   %edi
801020b4:	56                   	push   %esi
801020b5:	53                   	push   %ebx
801020b6:	83 ec 20             	sub    $0x20,%esp
801020b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801020bc:	6a 00                	push   $0x0
801020be:	ff 75 0c             	push   0xc(%ebp)
801020c1:	53                   	push   %ebx
801020c2:	e8 19 fd ff ff       	call   80101de0 <dirlookup>
801020c7:	83 c4 10             	add    $0x10,%esp
801020ca:	85 c0                	test   %eax,%eax
801020cc:	75 67                	jne    80102135 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020ce:	8b 7b 58             	mov    0x58(%ebx),%edi
801020d1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020d4:	85 ff                	test   %edi,%edi
801020d6:	74 29                	je     80102101 <dirlink+0x51>
801020d8:	31 ff                	xor    %edi,%edi
801020da:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020dd:	eb 09                	jmp    801020e8 <dirlink+0x38>
801020df:	90                   	nop
801020e0:	83 c7 10             	add    $0x10,%edi
801020e3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801020e6:	73 19                	jae    80102101 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020e8:	6a 10                	push   $0x10
801020ea:	57                   	push   %edi
801020eb:	56                   	push   %esi
801020ec:	53                   	push   %ebx
801020ed:	e8 ae fa ff ff       	call   80101ba0 <readi>
801020f2:	83 c4 10             	add    $0x10,%esp
801020f5:	83 f8 10             	cmp    $0x10,%eax
801020f8:	75 4e                	jne    80102148 <dirlink+0x98>
    if(de.inum == 0)
801020fa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020ff:	75 df                	jne    801020e0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102101:	83 ec 04             	sub    $0x4,%esp
80102104:	8d 45 da             	lea    -0x26(%ebp),%eax
80102107:	6a 0e                	push   $0xe
80102109:	ff 75 0c             	push   0xc(%ebp)
8010210c:	50                   	push   %eax
8010210d:	e8 6e 2b 00 00       	call   80104c80 <strncpy>
  de.inum = inum;
80102112:	8b 45 10             	mov    0x10(%ebp),%eax
80102115:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102119:	6a 10                	push   $0x10
8010211b:	57                   	push   %edi
8010211c:	56                   	push   %esi
8010211d:	53                   	push   %ebx
8010211e:	e8 7d fb ff ff       	call   80101ca0 <writei>
80102123:	83 c4 20             	add    $0x20,%esp
80102126:	83 f8 10             	cmp    $0x10,%eax
80102129:	75 2a                	jne    80102155 <dirlink+0xa5>
  return 0;
8010212b:	31 c0                	xor    %eax,%eax
}
8010212d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102130:	5b                   	pop    %ebx
80102131:	5e                   	pop    %esi
80102132:	5f                   	pop    %edi
80102133:	5d                   	pop    %ebp
80102134:	c3                   	ret
    iput(ip);
80102135:	83 ec 0c             	sub    $0xc,%esp
80102138:	50                   	push   %eax
80102139:	e8 82 f8 ff ff       	call   801019c0 <iput>
    return -1;
8010213e:	83 c4 10             	add    $0x10,%esp
80102141:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102146:	eb e5                	jmp    8010212d <dirlink+0x7d>
      panic("dirlink read");
80102148:	83 ec 0c             	sub    $0xc,%esp
8010214b:	68 97 7e 10 80       	push   $0x80107e97
80102150:	e8 1b e3 ff ff       	call   80100470 <panic>
    panic("dirlink");
80102155:	83 ec 0c             	sub    $0xc,%esp
80102158:	68 0f 81 10 80       	push   $0x8010810f
8010215d:	e8 0e e3 ff ff       	call   80100470 <panic>
80102162:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102170 <namei>:

struct inode*
namei(char *path)
{
80102170:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102171:	31 d2                	xor    %edx,%edx
{
80102173:	89 e5                	mov    %esp,%ebp
80102175:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102178:	8b 45 08             	mov    0x8(%ebp),%eax
8010217b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010217e:	e8 0d fd ff ff       	call   80101e90 <namex>
}
80102183:	c9                   	leave
80102184:	c3                   	ret
80102185:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010218c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102190 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102190:	55                   	push   %ebp
  return namex(path, 1, name);
80102191:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102196:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102198:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010219b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010219e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010219f:	e9 ec fc ff ff       	jmp    80101e90 <namex>
801021a4:	66 90                	xchg   %ax,%ax
801021a6:	66 90                	xchg   %ax,%ax
801021a8:	66 90                	xchg   %ax,%ax
801021aa:	66 90                	xchg   %ax,%ax
801021ac:	66 90                	xchg   %ax,%ax
801021ae:	66 90                	xchg   %ax,%ax

801021b0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801021b0:	55                   	push   %ebp
801021b1:	89 e5                	mov    %esp,%ebp
801021b3:	57                   	push   %edi
801021b4:	56                   	push   %esi
801021b5:	53                   	push   %ebx
801021b6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801021b9:	85 c0                	test   %eax,%eax
801021bb:	0f 84 b4 00 00 00    	je     80102275 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801021c1:	8b 70 08             	mov    0x8(%eax),%esi
801021c4:	89 c3                	mov    %eax,%ebx
801021c6:	81 fe 0f 27 00 00    	cmp    $0x270f,%esi
801021cc:	0f 87 96 00 00 00    	ja     80102268 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021d2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021de:	66 90                	xchg   %ax,%ax
801021e0:	89 ca                	mov    %ecx,%edx
801021e2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e3:	83 e0 c0             	and    $0xffffffc0,%eax
801021e6:	3c 40                	cmp    $0x40,%al
801021e8:	75 f6                	jne    801021e0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021ea:	31 ff                	xor    %edi,%edi
801021ec:	ba f6 03 00 00       	mov    $0x3f6,%edx
801021f1:	89 f8                	mov    %edi,%eax
801021f3:	ee                   	out    %al,(%dx)
801021f4:	b8 01 00 00 00       	mov    $0x1,%eax
801021f9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801021fe:	ee                   	out    %al,(%dx)
801021ff:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102204:	89 f0                	mov    %esi,%eax
80102206:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102207:	89 f0                	mov    %esi,%eax
80102209:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010220e:	c1 f8 08             	sar    $0x8,%eax
80102211:	ee                   	out    %al,(%dx)
80102212:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102217:	89 f8                	mov    %edi,%eax
80102219:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010221a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010221e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102223:	c1 e0 04             	shl    $0x4,%eax
80102226:	83 e0 10             	and    $0x10,%eax
80102229:	83 c8 e0             	or     $0xffffffe0,%eax
8010222c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010222d:	f6 03 04             	testb  $0x4,(%ebx)
80102230:	75 16                	jne    80102248 <idestart+0x98>
80102232:	b8 20 00 00 00       	mov    $0x20,%eax
80102237:	89 ca                	mov    %ecx,%edx
80102239:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010223a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010223d:	5b                   	pop    %ebx
8010223e:	5e                   	pop    %esi
8010223f:	5f                   	pop    %edi
80102240:	5d                   	pop    %ebp
80102241:	c3                   	ret
80102242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102248:	b8 30 00 00 00       	mov    $0x30,%eax
8010224d:	89 ca                	mov    %ecx,%edx
8010224f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102250:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102255:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102258:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010225d:	fc                   	cld
8010225e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102260:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102263:	5b                   	pop    %ebx
80102264:	5e                   	pop    %esi
80102265:	5f                   	pop    %edi
80102266:	5d                   	pop    %ebp
80102267:	c3                   	ret
    panic("incorrect blockno");
80102268:	83 ec 0c             	sub    $0xc,%esp
8010226b:	68 ad 7e 10 80       	push   $0x80107ead
80102270:	e8 fb e1 ff ff       	call   80100470 <panic>
    panic("idestart");
80102275:	83 ec 0c             	sub    $0xc,%esp
80102278:	68 a4 7e 10 80       	push   $0x80107ea4
8010227d:	e8 ee e1 ff ff       	call   80100470 <panic>
80102282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102290 <ideinit>:
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102296:	68 bf 7e 10 80       	push   $0x80107ebf
8010229b:	68 20 26 11 80       	push   $0x80112620
801022a0:	e8 9b 25 00 00       	call   80104840 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801022a5:	58                   	pop    %eax
801022a6:	a1 a4 37 11 80       	mov    0x801137a4,%eax
801022ab:	5a                   	pop    %edx
801022ac:	83 e8 01             	sub    $0x1,%eax
801022af:	50                   	push   %eax
801022b0:	6a 0e                	push   $0xe
801022b2:	e8 99 02 00 00       	call   80102550 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022b7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022ba:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801022bf:	90                   	nop
801022c0:	89 ca                	mov    %ecx,%edx
801022c2:	ec                   	in     (%dx),%al
801022c3:	83 e0 c0             	and    $0xffffffc0,%eax
801022c6:	3c 40                	cmp    $0x40,%al
801022c8:	75 f6                	jne    801022c0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022ca:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801022cf:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022d4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022d5:	89 ca                	mov    %ecx,%edx
801022d7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022d8:	84 c0                	test   %al,%al
801022da:	75 1e                	jne    801022fa <ideinit+0x6a>
801022dc:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
801022e1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ed:	8d 76 00             	lea    0x0(%esi),%esi
  for(i=0; i<1000; i++){
801022f0:	83 e9 01             	sub    $0x1,%ecx
801022f3:	74 0f                	je     80102304 <ideinit+0x74>
801022f5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022f6:	84 c0                	test   %al,%al
801022f8:	74 f6                	je     801022f0 <ideinit+0x60>
      havedisk1 = 1;
801022fa:	c7 05 00 26 11 80 01 	movl   $0x1,0x80112600
80102301:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102304:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102309:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010230e:	ee                   	out    %al,(%dx)
}
8010230f:	c9                   	leave
80102310:	c3                   	ret
80102311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010231f:	90                   	nop

80102320 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	57                   	push   %edi
80102324:	56                   	push   %esi
80102325:	53                   	push   %ebx
80102326:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102329:	68 20 26 11 80       	push   $0x80112620
8010232e:	e8 fd 26 00 00       	call   80104a30 <acquire>

  if((b = idequeue) == 0){
80102333:	8b 1d 04 26 11 80    	mov    0x80112604,%ebx
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 db                	test   %ebx,%ebx
8010233e:	74 63                	je     801023a3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102340:	8b 43 58             	mov    0x58(%ebx),%eax
80102343:	a3 04 26 11 80       	mov    %eax,0x80112604

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102348:	8b 33                	mov    (%ebx),%esi
8010234a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102350:	75 2f                	jne    80102381 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102352:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010235e:	66 90                	xchg   %ax,%ax
80102360:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102361:	89 c1                	mov    %eax,%ecx
80102363:	83 e1 c0             	and    $0xffffffc0,%ecx
80102366:	80 f9 40             	cmp    $0x40,%cl
80102369:	75 f5                	jne    80102360 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010236b:	a8 21                	test   $0x21,%al
8010236d:	75 12                	jne    80102381 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010236f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102372:	b9 80 00 00 00       	mov    $0x80,%ecx
80102377:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010237c:	fc                   	cld
8010237d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010237f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102381:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102384:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102387:	83 ce 02             	or     $0x2,%esi
8010238a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010238c:	53                   	push   %ebx
8010238d:	e8 be 1f 00 00       	call   80104350 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102392:	a1 04 26 11 80       	mov    0x80112604,%eax
80102397:	83 c4 10             	add    $0x10,%esp
8010239a:	85 c0                	test   %eax,%eax
8010239c:	74 05                	je     801023a3 <ideintr+0x83>
    idestart(idequeue);
8010239e:	e8 0d fe ff ff       	call   801021b0 <idestart>
    release(&idelock);
801023a3:	83 ec 0c             	sub    $0xc,%esp
801023a6:	68 20 26 11 80       	push   $0x80112620
801023ab:	e8 20 26 00 00       	call   801049d0 <release>

  release(&idelock);
}
801023b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023b3:	5b                   	pop    %ebx
801023b4:	5e                   	pop    %esi
801023b5:	5f                   	pop    %edi
801023b6:	5d                   	pop    %ebp
801023b7:	c3                   	ret
801023b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023bf:	90                   	nop

801023c0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	53                   	push   %ebx
801023c4:	83 ec 10             	sub    $0x10,%esp
801023c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801023ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801023cd:	50                   	push   %eax
801023ce:	e8 1d 24 00 00       	call   801047f0 <holdingsleep>
801023d3:	83 c4 10             	add    $0x10,%esp
801023d6:	85 c0                	test   %eax,%eax
801023d8:	0f 84 c3 00 00 00    	je     801024a1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801023de:	8b 03                	mov    (%ebx),%eax
801023e0:	83 e0 06             	and    $0x6,%eax
801023e3:	83 f8 02             	cmp    $0x2,%eax
801023e6:	0f 84 a8 00 00 00    	je     80102494 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801023ec:	8b 53 04             	mov    0x4(%ebx),%edx
801023ef:	85 d2                	test   %edx,%edx
801023f1:	74 0d                	je     80102400 <iderw+0x40>
801023f3:	a1 00 26 11 80       	mov    0x80112600,%eax
801023f8:	85 c0                	test   %eax,%eax
801023fa:	0f 84 87 00 00 00    	je     80102487 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102400:	83 ec 0c             	sub    $0xc,%esp
80102403:	68 20 26 11 80       	push   $0x80112620
80102408:	e8 23 26 00 00       	call   80104a30 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010240d:	a1 04 26 11 80       	mov    0x80112604,%eax
  b->qnext = 0;
80102412:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102419:	83 c4 10             	add    $0x10,%esp
8010241c:	85 c0                	test   %eax,%eax
8010241e:	74 60                	je     80102480 <iderw+0xc0>
80102420:	89 c2                	mov    %eax,%edx
80102422:	8b 40 58             	mov    0x58(%eax),%eax
80102425:	85 c0                	test   %eax,%eax
80102427:	75 f7                	jne    80102420 <iderw+0x60>
80102429:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010242c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010242e:	39 1d 04 26 11 80    	cmp    %ebx,0x80112604
80102434:	74 3a                	je     80102470 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102436:	8b 03                	mov    (%ebx),%eax
80102438:	83 e0 06             	and    $0x6,%eax
8010243b:	83 f8 02             	cmp    $0x2,%eax
8010243e:	74 1b                	je     8010245b <iderw+0x9b>
    sleep(b, &idelock);
80102440:	83 ec 08             	sub    $0x8,%esp
80102443:	68 20 26 11 80       	push   $0x80112620
80102448:	53                   	push   %ebx
80102449:	e8 42 1e 00 00       	call   80104290 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010244e:	8b 03                	mov    (%ebx),%eax
80102450:	83 c4 10             	add    $0x10,%esp
80102453:	83 e0 06             	and    $0x6,%eax
80102456:	83 f8 02             	cmp    $0x2,%eax
80102459:	75 e5                	jne    80102440 <iderw+0x80>
  }


  release(&idelock);
8010245b:	c7 45 08 20 26 11 80 	movl   $0x80112620,0x8(%ebp)
}
80102462:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102465:	c9                   	leave
  release(&idelock);
80102466:	e9 65 25 00 00       	jmp    801049d0 <release>
8010246b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010246f:	90                   	nop
    idestart(b);
80102470:	89 d8                	mov    %ebx,%eax
80102472:	e8 39 fd ff ff       	call   801021b0 <idestart>
80102477:	eb bd                	jmp    80102436 <iderw+0x76>
80102479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102480:	ba 04 26 11 80       	mov    $0x80112604,%edx
80102485:	eb a5                	jmp    8010242c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102487:	83 ec 0c             	sub    $0xc,%esp
8010248a:	68 ee 7e 10 80       	push   $0x80107eee
8010248f:	e8 dc df ff ff       	call   80100470 <panic>
    panic("iderw: nothing to do");
80102494:	83 ec 0c             	sub    $0xc,%esp
80102497:	68 d9 7e 10 80       	push   $0x80107ed9
8010249c:	e8 cf df ff ff       	call   80100470 <panic>
    panic("iderw: buf not locked");
801024a1:	83 ec 0c             	sub    $0xc,%esp
801024a4:	68 c3 7e 10 80       	push   $0x80107ec3
801024a9:	e8 c2 df ff ff       	call   80100470 <panic>
801024ae:	66 90                	xchg   %ax,%ax

801024b0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	56                   	push   %esi
801024b4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801024b5:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
801024bc:	00 c0 fe 
  ioapic->reg = reg;
801024bf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024c6:	00 00 00 
  return ioapic->data;
801024c9:	8b 15 54 26 11 80    	mov    0x80112654,%edx
801024cf:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801024d2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801024d8:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024de:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801024e5:	c1 ee 10             	shr    $0x10,%esi
801024e8:	89 f0                	mov    %esi,%eax
801024ea:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801024ed:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
801024f0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801024f3:	39 c2                	cmp    %eax,%edx
801024f5:	74 16                	je     8010250d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801024f7:	83 ec 0c             	sub    $0xc,%esp
801024fa:	68 80 83 10 80       	push   $0x80108380
801024ff:	e8 9c e2 ff ff       	call   801007a0 <cprintf>
  ioapic->reg = reg;
80102504:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
8010250a:	83 c4 10             	add    $0x10,%esp
{
8010250d:	ba 10 00 00 00       	mov    $0x10,%edx
80102512:	31 c0                	xor    %eax,%eax
80102514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102518:	89 13                	mov    %edx,(%ebx)
8010251a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010251d:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102523:	83 c0 01             	add    $0x1,%eax
80102526:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010252c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010252f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102532:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102535:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102537:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
8010253d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102544:	39 c6                	cmp    %eax,%esi
80102546:	7d d0                	jge    80102518 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102548:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010254b:	5b                   	pop    %ebx
8010254c:	5e                   	pop    %esi
8010254d:	5d                   	pop    %ebp
8010254e:	c3                   	ret
8010254f:	90                   	nop

80102550 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102550:	55                   	push   %ebp
  ioapic->reg = reg;
80102551:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
{
80102557:	89 e5                	mov    %esp,%ebp
80102559:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010255c:	8d 50 20             	lea    0x20(%eax),%edx
8010255f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102563:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102565:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010256b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010256e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102571:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102574:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102576:	a1 54 26 11 80       	mov    0x80112654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010257b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010257e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102581:	5d                   	pop    %ebp
80102582:	c3                   	ret
80102583:	66 90                	xchg   %ax,%ax
80102585:	66 90                	xchg   %ax,%ax
80102587:	66 90                	xchg   %ax,%ax
80102589:	66 90                	xchg   %ax,%ax
8010258b:	66 90                	xchg   %ax,%ax
8010258d:	66 90                	xchg   %ax,%ax
8010258f:	90                   	nop

80102590 <get_refcnt_table>:


int page_to_refcnt[PHYSTOP >> PTXSHIFT];
int * get_refcnt_table(void){
  return page_to_refcnt;
}
80102590:	b8 a0 26 11 80       	mov    $0x801126a0,%eax
80102595:	c3                   	ret
80102596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010259d:	8d 76 00             	lea    0x0(%esi),%esi

801025a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	53                   	push   %ebx
801025a4:	83 ec 04             	sub    $0x4,%esp
801025a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  // v2p(v)->pa
  // rmap[pa] -> list of pte_t * s, pointing to this page
  // we have to figure out , the indices in the swapslot hdr for this pa;
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801025aa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801025b0:	0f 85 a4 00 00 00    	jne    8010265a <kfree+0xba>
801025b6:	81 fb 40 8a 11 80    	cmp    $0x80118a40,%ebx
801025bc:	0f 82 98 00 00 00    	jb     8010265a <kfree+0xba>
801025c2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801025c8:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
801025cd:	0f 87 87 00 00 00    	ja     8010265a <kfree+0xba>
    panic("kfree");
  if(page_to_refcnt[V2P(v) >> PTXSHIFT] > 1)
801025d3:	c1 e8 0c             	shr    $0xc,%eax
801025d6:	8b 14 85 a0 26 11 80 	mov    -0x7feed960(,%eax,4),%edx
801025dd:	83 fa 01             	cmp    $0x1,%edx
801025e0:	7e 16                	jle    801025f8 <kfree+0x58>
  {
    // cprintf("page %d freed in cow", V2P(v) >> PTXSHIFT);
    page_to_refcnt[V2P(v) >> PTXSHIFT] -= 1;
801025e2:	83 ea 01             	sub    $0x1,%edx
801025e5:	89 14 85 a0 26 11 80 	mov    %edx,-0x7feed960(,%eax,4)
  r->next = kmem.freelist;
  kmem.num_free_pages+=1;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}
801025ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025ef:	c9                   	leave
801025f0:	c3                   	ret
801025f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  memset(v, 1, PGSIZE);
801025f8:	83 ec 04             	sub    $0x4,%esp
801025fb:	68 00 10 00 00       	push   $0x1000
80102600:	6a 01                	push   $0x1
80102602:	53                   	push   %ebx
80102603:	e8 28 25 00 00       	call   80104b30 <memset>
  if(kmem.use_lock)
80102608:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010260e:	83 c4 10             	add    $0x10,%esp
80102611:	85 d2                	test   %edx,%edx
80102613:	75 33                	jne    80102648 <kfree+0xa8>
  r->next = kmem.freelist;
80102615:	a1 9c 26 11 80       	mov    0x8011269c,%eax
8010261a:	89 03                	mov    %eax,(%ebx)
  if(kmem.use_lock)
8010261c:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.num_free_pages+=1;
80102621:	83 05 98 26 11 80 01 	addl   $0x1,0x80112698
  kmem.freelist = r;
80102628:	89 1d 9c 26 11 80    	mov    %ebx,0x8011269c
  if(kmem.use_lock)
8010262e:	85 c0                	test   %eax,%eax
80102630:	74 ba                	je     801025ec <kfree+0x4c>
    release(&kmem.lock);
80102632:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102639:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010263c:	c9                   	leave
    release(&kmem.lock);
8010263d:	e9 8e 23 00 00       	jmp    801049d0 <release>
80102642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102648:	83 ec 0c             	sub    $0xc,%esp
8010264b:	68 60 26 11 80       	push   $0x80112660
80102650:	e8 db 23 00 00       	call   80104a30 <acquire>
80102655:	83 c4 10             	add    $0x10,%esp
80102658:	eb bb                	jmp    80102615 <kfree+0x75>
    panic("kfree");
8010265a:	83 ec 0c             	sub    $0xc,%esp
8010265d:	68 0c 7f 10 80       	push   $0x80107f0c
80102662:	e8 09 de ff ff       	call   80100470 <panic>
80102667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010266e:	66 90                	xchg   %ax,%ax

80102670 <freerange>:
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	56                   	push   %esi
80102674:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102675:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102678:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010267b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102681:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102687:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010268d:	39 de                	cmp    %ebx,%esi
8010268f:	72 37                	jb     801026c8 <freerange+0x58>
80102691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102698:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010269e:	83 ec 0c             	sub    $0xc,%esp
801026a1:	50                   	push   %eax
801026a2:	e8 f9 fe ff ff       	call   801025a0 <kfree>
    page_to_refcnt[V2P(p) >> PTXSHIFT] = 0;
801026a7:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026ad:	83 c4 10             	add    $0x10,%esp
801026b0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    page_to_refcnt[V2P(p) >> PTXSHIFT] = 0;
801026b6:	c1 e8 0c             	shr    $0xc,%eax
801026b9:	c7 04 85 a0 26 11 80 	movl   $0x0,-0x7feed960(,%eax,4)
801026c0:	00 00 00 00 
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c4:	39 de                	cmp    %ebx,%esi
801026c6:	73 d0                	jae    80102698 <freerange+0x28>
}
801026c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026cb:	5b                   	pop    %ebx
801026cc:	5e                   	pop    %esi
801026cd:	5d                   	pop    %ebp
801026ce:	c3                   	ret
801026cf:	90                   	nop

801026d0 <kinit2>:
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	56                   	push   %esi
801026d4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026d5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801026db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026ed:	39 de                	cmp    %ebx,%esi
801026ef:	72 37                	jb     80102728 <kinit2+0x58>
801026f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026f8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801026fe:	83 ec 0c             	sub    $0xc,%esp
80102701:	50                   	push   %eax
80102702:	e8 99 fe ff ff       	call   801025a0 <kfree>
    page_to_refcnt[V2P(p) >> PTXSHIFT] = 0;
80102707:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010270d:	83 c4 10             	add    $0x10,%esp
80102710:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    page_to_refcnt[V2P(p) >> PTXSHIFT] = 0;
80102716:	c1 e8 0c             	shr    $0xc,%eax
80102719:	c7 04 85 a0 26 11 80 	movl   $0x0,-0x7feed960(,%eax,4)
80102720:	00 00 00 00 
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102724:	39 de                	cmp    %ebx,%esi
80102726:	73 d0                	jae    801026f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102728:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
8010272f:	00 00 00 
}
80102732:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102735:	5b                   	pop    %ebx
80102736:	5e                   	pop    %esi
80102737:	5d                   	pop    %ebp
80102738:	c3                   	ret
80102739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102740 <kinit1>:
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	56                   	push   %esi
80102744:	53                   	push   %ebx
80102745:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102748:	83 ec 08             	sub    $0x8,%esp
8010274b:	68 12 7f 10 80       	push   $0x80107f12
80102750:	68 60 26 11 80       	push   $0x80112660
80102755:	e8 e6 20 00 00       	call   80104840 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010275a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010275d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102760:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102767:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010276a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102770:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102776:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010277c:	39 de                	cmp    %ebx,%esi
8010277e:	72 30                	jb     801027b0 <kinit1+0x70>
    kfree(p);
80102780:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102786:	83 ec 0c             	sub    $0xc,%esp
80102789:	50                   	push   %eax
8010278a:	e8 11 fe ff ff       	call   801025a0 <kfree>
    page_to_refcnt[V2P(p) >> PTXSHIFT] = 0;
8010278f:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102795:	83 c4 10             	add    $0x10,%esp
80102798:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    page_to_refcnt[V2P(p) >> PTXSHIFT] = 0;
8010279e:	c1 e8 0c             	shr    $0xc,%eax
801027a1:	c7 04 85 a0 26 11 80 	movl   $0x0,-0x7feed960(,%eax,4)
801027a8:	00 00 00 00 
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027ac:	39 de                	cmp    %ebx,%esi
801027ae:	73 d0                	jae    80102780 <kinit1+0x40>
}
801027b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027b3:	5b                   	pop    %ebx
801027b4:	5e                   	pop    %esi
801027b5:	5d                   	pop    %ebp
801027b6:	c3                   	ret
801027b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027be:	66 90                	xchg   %ax,%ax

801027c0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	53                   	push   %ebx
801027c4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801027c7:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
801027cd:	85 c9                	test   %ecx,%ecx
801027cf:	75 68                	jne    80102839 <kalloc+0x79>
801027d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
  r = kmem.freelist;
801027d8:	8b 1d 9c 26 11 80    	mov    0x8011269c,%ebx
  if(r)
801027de:	85 db                	test   %ebx,%ebx
801027e0:	74 48                	je     8010282a <kalloc+0x6a>
  {
    kmem.freelist = r->next;
801027e2:	8b 03                	mov    (%ebx),%eax
    kmem.num_free_pages-=1;
801027e4:	83 2d 98 26 11 80 01 	subl   $0x1,0x80112698
    kmem.freelist = r->next;
801027eb:	a3 9c 26 11 80       	mov    %eax,0x8011269c
    page_to_refcnt[V2P(r) >> PTXSHIFT] = 1;
801027f0:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801027f6:	c1 e8 0c             	shr    $0xc,%eax
801027f9:	c7 04 85 a0 26 11 80 	movl   $0x1,-0x7feed960(,%eax,4)
80102800:	01 00 00 00 

  if(r) return (char*)r;

  swap_out();
  return kalloc();
}
80102804:	89 d8                	mov    %ebx,%eax
80102806:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102809:	c9                   	leave
8010280a:	c3                   	ret
8010280b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010280f:	90                   	nop
  if(kmem.use_lock)
80102810:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102816:	85 d2                	test   %edx,%edx
80102818:	74 10                	je     8010282a <kalloc+0x6a>
    release(&kmem.lock);
8010281a:	83 ec 0c             	sub    $0xc,%esp
8010281d:	68 60 26 11 80       	push   $0x80112660
80102822:	e8 a9 21 00 00       	call   801049d0 <release>
80102827:	83 c4 10             	add    $0x10,%esp
  swap_out();
8010282a:	e8 f1 51 00 00       	call   80107a20 <swap_out>
  if(kmem.use_lock)
8010282f:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
80102835:	85 c9                	test   %ecx,%ecx
80102837:	74 9f                	je     801027d8 <kalloc+0x18>
    acquire(&kmem.lock);
80102839:	83 ec 0c             	sub    $0xc,%esp
8010283c:	68 60 26 11 80       	push   $0x80112660
80102841:	e8 ea 21 00 00       	call   80104a30 <acquire>
  r = kmem.freelist;
80102846:	8b 1d 9c 26 11 80    	mov    0x8011269c,%ebx
  if(r)
8010284c:	83 c4 10             	add    $0x10,%esp
8010284f:	85 db                	test   %ebx,%ebx
80102851:	74 bd                	je     80102810 <kalloc+0x50>
    kmem.freelist = r->next;
80102853:	8b 03                	mov    (%ebx),%eax
    kmem.num_free_pages-=1;
80102855:	83 2d 98 26 11 80 01 	subl   $0x1,0x80112698
    kmem.freelist = r->next;
8010285c:	a3 9c 26 11 80       	mov    %eax,0x8011269c
    page_to_refcnt[V2P(r) >> PTXSHIFT] = 1;
80102861:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102867:	c1 e8 0c             	shr    $0xc,%eax
8010286a:	c7 04 85 a0 26 11 80 	movl   $0x1,-0x7feed960(,%eax,4)
80102871:	01 00 00 00 
  if(kmem.use_lock)
80102875:	a1 94 26 11 80       	mov    0x80112694,%eax
8010287a:	85 c0                	test   %eax,%eax
8010287c:	74 86                	je     80102804 <kalloc+0x44>
    release(&kmem.lock);
8010287e:	83 ec 0c             	sub    $0xc,%esp
80102881:	68 60 26 11 80       	push   $0x80112660
80102886:	e8 45 21 00 00       	call   801049d0 <release>
}
8010288b:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010288d:	83 c4 10             	add    $0x10,%esp
}
80102890:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102893:	c9                   	leave
80102894:	c3                   	ret
80102895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010289c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028a0 <num_of_FreePages>:
uint 
num_of_FreePages(void)
{
801028a0:	55                   	push   %ebp
801028a1:	89 e5                	mov    %esp,%ebp
801028a3:	53                   	push   %ebx
801028a4:	83 ec 10             	sub    $0x10,%esp
  acquire(&kmem.lock);
801028a7:	68 60 26 11 80       	push   $0x80112660
801028ac:	e8 7f 21 00 00       	call   80104a30 <acquire>

  uint num_free_pages = kmem.num_free_pages;
801028b1:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  
  release(&kmem.lock);
801028b7:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801028be:	e8 0d 21 00 00       	call   801049d0 <release>
  
  return num_free_pages;
}
801028c3:	89 d8                	mov    %ebx,%eax
801028c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028c8:	c9                   	leave
801028c9:	c3                   	ret
801028ca:	66 90                	xchg   %ax,%ax
801028cc:	66 90                	xchg   %ax,%ax
801028ce:	66 90                	xchg   %ax,%ax

801028d0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d0:	ba 64 00 00 00       	mov    $0x64,%edx
801028d5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028d6:	a8 01                	test   $0x1,%al
801028d8:	0f 84 c2 00 00 00    	je     801029a0 <kbdgetc+0xd0>
{
801028de:	55                   	push   %ebp
801028df:	ba 60 00 00 00       	mov    $0x60,%edx
801028e4:	89 e5                	mov    %esp,%ebp
801028e6:	53                   	push   %ebx
801028e7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801028e8:	8b 1d a0 36 11 80    	mov    0x801136a0,%ebx
  data = inb(KBDATAP);
801028ee:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801028f1:	3c e0                	cmp    $0xe0,%al
801028f3:	74 5b                	je     80102950 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028f5:	89 da                	mov    %ebx,%edx
801028f7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801028fa:	84 c0                	test   %al,%al
801028fc:	78 62                	js     80102960 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801028fe:	85 d2                	test   %edx,%edx
80102900:	74 09                	je     8010290b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102902:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102905:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102908:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010290b:	0f b6 91 60 86 10 80 	movzbl -0x7fef79a0(%ecx),%edx
  shift ^= togglecode[data];
80102912:	0f b6 81 60 85 10 80 	movzbl -0x7fef7aa0(%ecx),%eax
  shift |= shiftcode[data];
80102919:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010291b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010291d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010291f:	89 15 a0 36 11 80    	mov    %edx,0x801136a0
  c = charcode[shift & (CTL | SHIFT)][data];
80102925:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102928:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010292b:	8b 04 85 40 85 10 80 	mov    -0x7fef7ac0(,%eax,4),%eax
80102932:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102936:	74 0b                	je     80102943 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102938:	8d 50 9f             	lea    -0x61(%eax),%edx
8010293b:	83 fa 19             	cmp    $0x19,%edx
8010293e:	77 48                	ja     80102988 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102940:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102943:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102946:	c9                   	leave
80102947:	c3                   	ret
80102948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294f:	90                   	nop
    shift |= E0ESC;
80102950:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102953:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102955:	89 1d a0 36 11 80    	mov    %ebx,0x801136a0
}
8010295b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010295e:	c9                   	leave
8010295f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102960:	83 e0 7f             	and    $0x7f,%eax
80102963:	85 d2                	test   %edx,%edx
80102965:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102968:	0f b6 81 60 86 10 80 	movzbl -0x7fef79a0(%ecx),%eax
8010296f:	83 c8 40             	or     $0x40,%eax
80102972:	0f b6 c0             	movzbl %al,%eax
80102975:	f7 d0                	not    %eax
80102977:	21 d8                	and    %ebx,%eax
80102979:	a3 a0 36 11 80       	mov    %eax,0x801136a0
    return 0;
8010297e:	31 c0                	xor    %eax,%eax
80102980:	eb d9                	jmp    8010295b <kbdgetc+0x8b>
80102982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102988:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010298b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010298e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102991:	c9                   	leave
      c += 'a' - 'A';
80102992:	83 f9 1a             	cmp    $0x1a,%ecx
80102995:	0f 42 c2             	cmovb  %edx,%eax
}
80102998:	c3                   	ret
80102999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801029a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801029a5:	c3                   	ret
801029a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ad:	8d 76 00             	lea    0x0(%esi),%esi

801029b0 <kbdintr>:

void
kbdintr(void)
{
801029b0:	55                   	push   %ebp
801029b1:	89 e5                	mov    %esp,%ebp
801029b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029b6:	68 d0 28 10 80       	push   $0x801028d0
801029bb:	e8 d0 df ff ff       	call   80100990 <consoleintr>
}
801029c0:	83 c4 10             	add    $0x10,%esp
801029c3:	c9                   	leave
801029c4:	c3                   	ret
801029c5:	66 90                	xchg   %ax,%ax
801029c7:	66 90                	xchg   %ax,%ax
801029c9:	66 90                	xchg   %ax,%ax
801029cb:	66 90                	xchg   %ax,%ax
801029cd:	66 90                	xchg   %ax,%ax
801029cf:	90                   	nop

801029d0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029d0:	a1 a4 36 11 80       	mov    0x801136a4,%eax
801029d5:	85 c0                	test   %eax,%eax
801029d7:	0f 84 c3 00 00 00    	je     80102aa0 <lapicinit+0xd0>
  lapic[index] = value;
801029dd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029e4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ea:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029f1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029f7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029fe:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a01:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a04:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a0b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a0e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a11:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a18:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a1b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a1e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a25:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a28:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a2b:	8b 50 30             	mov    0x30(%eax),%edx
80102a2e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102a34:	75 72                	jne    80102aa8 <lapicinit+0xd8>
  lapic[index] = value;
80102a36:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a3d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a40:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a43:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a4a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a4d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a50:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a57:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a5a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a5d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a64:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a67:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a6a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a71:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a74:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a77:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a7e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a81:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a88:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a8e:	80 e6 10             	and    $0x10,%dh
80102a91:	75 f5                	jne    80102a88 <lapicinit+0xb8>
  lapic[index] = value;
80102a93:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a9a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a9d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102aa0:	c3                   	ret
80102aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102aa8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102aaf:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab2:	8b 50 20             	mov    0x20(%eax),%edx
}
80102ab5:	e9 7c ff ff ff       	jmp    80102a36 <lapicinit+0x66>
80102aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ac0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102ac0:	a1 a4 36 11 80       	mov    0x801136a4,%eax
80102ac5:	85 c0                	test   %eax,%eax
80102ac7:	74 07                	je     80102ad0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102ac9:	8b 40 20             	mov    0x20(%eax),%eax
80102acc:	c1 e8 18             	shr    $0x18,%eax
80102acf:	c3                   	ret
    return 0;
80102ad0:	31 c0                	xor    %eax,%eax
}
80102ad2:	c3                   	ret
80102ad3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ae0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ae0:	a1 a4 36 11 80       	mov    0x801136a4,%eax
80102ae5:	85 c0                	test   %eax,%eax
80102ae7:	74 0d                	je     80102af6 <lapiceoi+0x16>
  lapic[index] = value;
80102ae9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102af0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102af3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102af6:	c3                   	ret
80102af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102afe:	66 90                	xchg   %ax,%ax

80102b00 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102b00:	c3                   	ret
80102b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b0f:	90                   	nop

80102b10 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b10:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b11:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b16:	ba 70 00 00 00       	mov    $0x70,%edx
80102b1b:	89 e5                	mov    %esp,%ebp
80102b1d:	53                   	push   %ebx
80102b1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b21:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b24:	ee                   	out    %al,(%dx)
80102b25:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b2a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b2f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b30:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102b32:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b35:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b3b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b3d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102b40:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102b42:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b45:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b48:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b4e:	a1 a4 36 11 80       	mov    0x801136a4,%eax
80102b53:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b59:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b5c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b63:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b66:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b69:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b70:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b73:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b76:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b7c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b7f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b85:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b88:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b8e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b91:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b97:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102b9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b9d:	c9                   	leave
80102b9e:	c3                   	ret
80102b9f:	90                   	nop

80102ba0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102ba0:	55                   	push   %ebp
80102ba1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102ba6:	ba 70 00 00 00       	mov    $0x70,%edx
80102bab:	89 e5                	mov    %esp,%ebp
80102bad:	57                   	push   %edi
80102bae:	56                   	push   %esi
80102baf:	53                   	push   %ebx
80102bb0:	83 ec 4c             	sub    $0x4c,%esp
80102bb3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bb4:	ba 71 00 00 00       	mov    $0x71,%edx
80102bb9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102bba:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bbd:	bf 70 00 00 00       	mov    $0x70,%edi
80102bc2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102bc5:	8d 76 00             	lea    0x0(%esi),%esi
80102bc8:	31 c0                	xor    %eax,%eax
80102bca:	89 fa                	mov    %edi,%edx
80102bcc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bcd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102bd2:	89 ca                	mov    %ecx,%edx
80102bd4:	ec                   	in     (%dx),%al
80102bd5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd8:	89 fa                	mov    %edi,%edx
80102bda:	b8 02 00 00 00       	mov    $0x2,%eax
80102bdf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102be0:	89 ca                	mov    %ecx,%edx
80102be2:	ec                   	in     (%dx),%al
80102be3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be6:	89 fa                	mov    %edi,%edx
80102be8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bee:	89 ca                	mov    %ecx,%edx
80102bf0:	ec                   	in     (%dx),%al
80102bf1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf4:	89 fa                	mov    %edi,%edx
80102bf6:	b8 07 00 00 00       	mov    $0x7,%eax
80102bfb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfc:	89 ca                	mov    %ecx,%edx
80102bfe:	ec                   	in     (%dx),%al
80102bff:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c02:	89 fa                	mov    %edi,%edx
80102c04:	b8 08 00 00 00       	mov    $0x8,%eax
80102c09:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0a:	89 ca                	mov    %ecx,%edx
80102c0c:	ec                   	in     (%dx),%al
80102c0d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c0f:	89 fa                	mov    %edi,%edx
80102c11:	b8 09 00 00 00       	mov    $0x9,%eax
80102c16:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c17:	89 ca                	mov    %ecx,%edx
80102c19:	ec                   	in     (%dx),%al
80102c1a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c1d:	89 fa                	mov    %edi,%edx
80102c1f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c24:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c25:	89 ca                	mov    %ecx,%edx
80102c27:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c28:	84 c0                	test   %al,%al
80102c2a:	78 9c                	js     80102bc8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c2c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c30:	89 f2                	mov    %esi,%edx
80102c32:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102c35:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c38:	89 fa                	mov    %edi,%edx
80102c3a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c3d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c41:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102c44:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c47:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c4b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c4e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c52:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c55:	31 c0                	xor    %eax,%eax
80102c57:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c58:	89 ca                	mov    %ecx,%edx
80102c5a:	ec                   	in     (%dx),%al
80102c5b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c5e:	89 fa                	mov    %edi,%edx
80102c60:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c63:	b8 02 00 00 00       	mov    $0x2,%eax
80102c68:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c69:	89 ca                	mov    %ecx,%edx
80102c6b:	ec                   	in     (%dx),%al
80102c6c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c6f:	89 fa                	mov    %edi,%edx
80102c71:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c74:	b8 04 00 00 00       	mov    $0x4,%eax
80102c79:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7a:	89 ca                	mov    %ecx,%edx
80102c7c:	ec                   	in     (%dx),%al
80102c7d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c80:	89 fa                	mov    %edi,%edx
80102c82:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c85:	b8 07 00 00 00       	mov    $0x7,%eax
80102c8a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c8b:	89 ca                	mov    %ecx,%edx
80102c8d:	ec                   	in     (%dx),%al
80102c8e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c91:	89 fa                	mov    %edi,%edx
80102c93:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c96:	b8 08 00 00 00       	mov    $0x8,%eax
80102c9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9c:	89 ca                	mov    %ecx,%edx
80102c9e:	ec                   	in     (%dx),%al
80102c9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca2:	89 fa                	mov    %edi,%edx
80102ca4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ca7:	b8 09 00 00 00       	mov    $0x9,%eax
80102cac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cad:	89 ca                	mov    %ecx,%edx
80102caf:	ec                   	in     (%dx),%al
80102cb0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cb3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102cb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cb9:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102cbc:	6a 18                	push   $0x18
80102cbe:	50                   	push   %eax
80102cbf:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102cc2:	50                   	push   %eax
80102cc3:	e8 a8 1e 00 00       	call   80104b70 <memcmp>
80102cc8:	83 c4 10             	add    $0x10,%esp
80102ccb:	85 c0                	test   %eax,%eax
80102ccd:	0f 85 f5 fe ff ff    	jne    80102bc8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102cd3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102cda:	89 f0                	mov    %esi,%eax
80102cdc:	84 c0                	test   %al,%al
80102cde:	75 78                	jne    80102d58 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ce0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ce3:	89 c2                	mov    %eax,%edx
80102ce5:	83 e0 0f             	and    $0xf,%eax
80102ce8:	c1 ea 04             	shr    $0x4,%edx
80102ceb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cee:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cf1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102cf4:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cf7:	89 c2                	mov    %eax,%edx
80102cf9:	83 e0 0f             	and    $0xf,%eax
80102cfc:	c1 ea 04             	shr    $0x4,%edx
80102cff:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d02:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d05:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d08:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d0b:	89 c2                	mov    %eax,%edx
80102d0d:	83 e0 0f             	and    $0xf,%eax
80102d10:	c1 ea 04             	shr    $0x4,%edx
80102d13:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d16:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d19:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d1c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d1f:	89 c2                	mov    %eax,%edx
80102d21:	83 e0 0f             	and    $0xf,%eax
80102d24:	c1 ea 04             	shr    $0x4,%edx
80102d27:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d2a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d2d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d30:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d33:	89 c2                	mov    %eax,%edx
80102d35:	83 e0 0f             	and    $0xf,%eax
80102d38:	c1 ea 04             	shr    $0x4,%edx
80102d3b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d3e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d41:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d44:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d47:	89 c2                	mov    %eax,%edx
80102d49:	83 e0 0f             	and    $0xf,%eax
80102d4c:	c1 ea 04             	shr    $0x4,%edx
80102d4f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d52:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d55:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d58:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d5b:	89 03                	mov    %eax,(%ebx)
80102d5d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d60:	89 43 04             	mov    %eax,0x4(%ebx)
80102d63:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d66:	89 43 08             	mov    %eax,0x8(%ebx)
80102d69:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d6c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102d6f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d72:	89 43 10             	mov    %eax,0x10(%ebx)
80102d75:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d78:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102d7b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102d82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d85:	5b                   	pop    %ebx
80102d86:	5e                   	pop    %esi
80102d87:	5f                   	pop    %edi
80102d88:	5d                   	pop    %ebp
80102d89:	c3                   	ret
80102d8a:	66 90                	xchg   %ax,%ax
80102d8c:	66 90                	xchg   %ax,%ax
80102d8e:	66 90                	xchg   %ax,%ax

80102d90 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d90:	8b 0d 08 37 11 80    	mov    0x80113708,%ecx
80102d96:	85 c9                	test   %ecx,%ecx
80102d98:	0f 8e 8a 00 00 00    	jle    80102e28 <install_trans+0x98>
{
80102d9e:	55                   	push   %ebp
80102d9f:	89 e5                	mov    %esp,%ebp
80102da1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102da2:	31 ff                	xor    %edi,%edi
{
80102da4:	56                   	push   %esi
80102da5:	53                   	push   %ebx
80102da6:	83 ec 0c             	sub    $0xc,%esp
80102da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102db0:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102db5:	83 ec 08             	sub    $0x8,%esp
80102db8:	01 f8                	add    %edi,%eax
80102dba:	83 c0 01             	add    $0x1,%eax
80102dbd:	50                   	push   %eax
80102dbe:	ff 35 04 37 11 80    	push   0x80113704
80102dc4:	e8 07 d3 ff ff       	call   801000d0 <bread>
80102dc9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dcb:	58                   	pop    %eax
80102dcc:	5a                   	pop    %edx
80102dcd:	ff 34 bd 0c 37 11 80 	push   -0x7feec8f4(,%edi,4)
80102dd4:	ff 35 04 37 11 80    	push   0x80113704
  for (tail = 0; tail < log.lh.n; tail++) {
80102dda:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ddd:	e8 ee d2 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102de2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102de5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102de7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dea:	68 00 02 00 00       	push   $0x200
80102def:	50                   	push   %eax
80102df0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102df3:	50                   	push   %eax
80102df4:	e8 c7 1d 00 00       	call   80104bc0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102df9:	89 1c 24             	mov    %ebx,(%esp)
80102dfc:	e8 af d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102e01:	89 34 24             	mov    %esi,(%esp)
80102e04:	e8 e7 d3 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102e09:	89 1c 24             	mov    %ebx,(%esp)
80102e0c:	e8 df d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e11:	83 c4 10             	add    $0x10,%esp
80102e14:	39 3d 08 37 11 80    	cmp    %edi,0x80113708
80102e1a:	7f 94                	jg     80102db0 <install_trans+0x20>
  }
}
80102e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e1f:	5b                   	pop    %ebx
80102e20:	5e                   	pop    %esi
80102e21:	5f                   	pop    %edi
80102e22:	5d                   	pop    %ebp
80102e23:	c3                   	ret
80102e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e28:	c3                   	ret
80102e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e30 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	53                   	push   %ebx
80102e34:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e37:	ff 35 f4 36 11 80    	push   0x801136f4
80102e3d:	ff 35 04 37 11 80    	push   0x80113704
80102e43:	e8 88 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e48:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e4b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e4d:	a1 08 37 11 80       	mov    0x80113708,%eax
80102e52:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102e55:	85 c0                	test   %eax,%eax
80102e57:	7e 19                	jle    80102e72 <write_head+0x42>
80102e59:	31 d2                	xor    %edx,%edx
80102e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e5f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102e60:	8b 0c 95 0c 37 11 80 	mov    -0x7feec8f4(,%edx,4),%ecx
80102e67:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e6b:	83 c2 01             	add    $0x1,%edx
80102e6e:	39 d0                	cmp    %edx,%eax
80102e70:	75 ee                	jne    80102e60 <write_head+0x30>
  }
  bwrite(buf);
80102e72:	83 ec 0c             	sub    $0xc,%esp
80102e75:	53                   	push   %ebx
80102e76:	e8 35 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102e7b:	89 1c 24             	mov    %ebx,(%esp)
80102e7e:	e8 6d d3 ff ff       	call   801001f0 <brelse>
}
80102e83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e86:	83 c4 10             	add    $0x10,%esp
80102e89:	c9                   	leave
80102e8a:	c3                   	ret
80102e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e8f:	90                   	nop

80102e90 <initlog>:
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	53                   	push   %ebx
80102e94:	83 ec 3c             	sub    $0x3c,%esp
80102e97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e9a:	68 17 7f 10 80       	push   $0x80107f17
80102e9f:	68 c0 36 11 80       	push   $0x801136c0
80102ea4:	e8 97 19 00 00       	call   80104840 <initlock>
  readsb(dev, &sb);
80102ea9:	58                   	pop    %eax
80102eaa:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80102ead:	5a                   	pop    %edx
80102eae:	50                   	push   %eax
80102eaf:	53                   	push   %ebx
80102eb0:	e8 7b e7 ff ff       	call   80101630 <readsb>
  log.start = sb.logstart;
80102eb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102eb8:	59                   	pop    %ecx
  log.dev = dev;
80102eb9:	89 1d 04 37 11 80    	mov    %ebx,0x80113704
  log.size = sb.nlog;
80102ebf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  log.start = sb.logstart;
80102ec2:	a3 f4 36 11 80       	mov    %eax,0x801136f4
  log.size = sb.nlog;
80102ec7:	89 15 f8 36 11 80    	mov    %edx,0x801136f8
  struct buf *buf = bread(log.dev, log.start);
80102ecd:	5a                   	pop    %edx
80102ece:	50                   	push   %eax
80102ecf:	53                   	push   %ebx
80102ed0:	e8 fb d1 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ed5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102ed8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102edb:	89 1d 08 37 11 80    	mov    %ebx,0x80113708
  for (i = 0; i < log.lh.n; i++) {
80102ee1:	85 db                	test   %ebx,%ebx
80102ee3:	7e 1d                	jle    80102f02 <initlog+0x72>
80102ee5:	31 d2                	xor    %edx,%edx
80102ee7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eee:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102ef0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102ef4:	89 0c 95 0c 37 11 80 	mov    %ecx,-0x7feec8f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102efb:	83 c2 01             	add    $0x1,%edx
80102efe:	39 d3                	cmp    %edx,%ebx
80102f00:	75 ee                	jne    80102ef0 <initlog+0x60>
  brelse(buf);
80102f02:	83 ec 0c             	sub    $0xc,%esp
80102f05:	50                   	push   %eax
80102f06:	e8 e5 d2 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f0b:	e8 80 fe ff ff       	call   80102d90 <install_trans>
  log.lh.n = 0;
80102f10:	c7 05 08 37 11 80 00 	movl   $0x0,0x80113708
80102f17:	00 00 00 
  write_head(); // clear the log
80102f1a:	e8 11 ff ff ff       	call   80102e30 <write_head>
}
80102f1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f22:	83 c4 10             	add    $0x10,%esp
80102f25:	c9                   	leave
80102f26:	c3                   	ret
80102f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f2e:	66 90                	xchg   %ax,%ax

80102f30 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f30:	55                   	push   %ebp
80102f31:	89 e5                	mov    %esp,%ebp
80102f33:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f36:	68 c0 36 11 80       	push   $0x801136c0
80102f3b:	e8 f0 1a 00 00       	call   80104a30 <acquire>
80102f40:	83 c4 10             	add    $0x10,%esp
80102f43:	eb 18                	jmp    80102f5d <begin_op+0x2d>
80102f45:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f48:	83 ec 08             	sub    $0x8,%esp
80102f4b:	68 c0 36 11 80       	push   $0x801136c0
80102f50:	68 c0 36 11 80       	push   $0x801136c0
80102f55:	e8 36 13 00 00       	call   80104290 <sleep>
80102f5a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f5d:	a1 00 37 11 80       	mov    0x80113700,%eax
80102f62:	85 c0                	test   %eax,%eax
80102f64:	75 e2                	jne    80102f48 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f66:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102f6b:	8b 15 08 37 11 80    	mov    0x80113708,%edx
80102f71:	83 c0 01             	add    $0x1,%eax
80102f74:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f77:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f7a:	83 fa 1e             	cmp    $0x1e,%edx
80102f7d:	7f c9                	jg     80102f48 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f7f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f82:	a3 fc 36 11 80       	mov    %eax,0x801136fc
      release(&log.lock);
80102f87:	68 c0 36 11 80       	push   $0x801136c0
80102f8c:	e8 3f 1a 00 00       	call   801049d0 <release>
      break;
    }
  }
}
80102f91:	83 c4 10             	add    $0x10,%esp
80102f94:	c9                   	leave
80102f95:	c3                   	ret
80102f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f9d:	8d 76 00             	lea    0x0(%esi),%esi

80102fa0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	57                   	push   %edi
80102fa4:	56                   	push   %esi
80102fa5:	53                   	push   %ebx
80102fa6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102fa9:	68 c0 36 11 80       	push   $0x801136c0
80102fae:	e8 7d 1a 00 00       	call   80104a30 <acquire>
  log.outstanding -= 1;
80102fb3:	a1 fc 36 11 80       	mov    0x801136fc,%eax
  if(log.committing)
80102fb8:	8b 35 00 37 11 80    	mov    0x80113700,%esi
80102fbe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102fc1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102fc4:	89 1d fc 36 11 80    	mov    %ebx,0x801136fc
  if(log.committing)
80102fca:	85 f6                	test   %esi,%esi
80102fcc:	0f 85 22 01 00 00    	jne    801030f4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102fd2:	85 db                	test   %ebx,%ebx
80102fd4:	0f 85 f6 00 00 00    	jne    801030d0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102fda:	c7 05 00 37 11 80 01 	movl   $0x1,0x80113700
80102fe1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fe4:	83 ec 0c             	sub    $0xc,%esp
80102fe7:	68 c0 36 11 80       	push   $0x801136c0
80102fec:	e8 df 19 00 00       	call   801049d0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ff1:	8b 0d 08 37 11 80    	mov    0x80113708,%ecx
80102ff7:	83 c4 10             	add    $0x10,%esp
80102ffa:	85 c9                	test   %ecx,%ecx
80102ffc:	7f 42                	jg     80103040 <end_op+0xa0>
    acquire(&log.lock);
80102ffe:	83 ec 0c             	sub    $0xc,%esp
80103001:	68 c0 36 11 80       	push   $0x801136c0
80103006:	e8 25 1a 00 00       	call   80104a30 <acquire>
    log.committing = 0;
8010300b:	c7 05 00 37 11 80 00 	movl   $0x0,0x80113700
80103012:	00 00 00 
    wakeup(&log);
80103015:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
8010301c:	e8 2f 13 00 00       	call   80104350 <wakeup>
    release(&log.lock);
80103021:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80103028:	e8 a3 19 00 00       	call   801049d0 <release>
8010302d:	83 c4 10             	add    $0x10,%esp
}
80103030:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103033:	5b                   	pop    %ebx
80103034:	5e                   	pop    %esi
80103035:	5f                   	pop    %edi
80103036:	5d                   	pop    %ebp
80103037:	c3                   	ret
80103038:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010303f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103040:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80103045:	83 ec 08             	sub    $0x8,%esp
80103048:	01 d8                	add    %ebx,%eax
8010304a:	83 c0 01             	add    $0x1,%eax
8010304d:	50                   	push   %eax
8010304e:	ff 35 04 37 11 80    	push   0x80113704
80103054:	e8 77 d0 ff ff       	call   801000d0 <bread>
80103059:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010305b:	58                   	pop    %eax
8010305c:	5a                   	pop    %edx
8010305d:	ff 34 9d 0c 37 11 80 	push   -0x7feec8f4(,%ebx,4)
80103064:	ff 35 04 37 11 80    	push   0x80113704
  for (tail = 0; tail < log.lh.n; tail++) {
8010306a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010306d:	e8 5e d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103072:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103075:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103077:	8d 40 5c             	lea    0x5c(%eax),%eax
8010307a:	68 00 02 00 00       	push   $0x200
8010307f:	50                   	push   %eax
80103080:	8d 46 5c             	lea    0x5c(%esi),%eax
80103083:	50                   	push   %eax
80103084:	e8 37 1b 00 00       	call   80104bc0 <memmove>
    bwrite(to);  // write the log
80103089:	89 34 24             	mov    %esi,(%esp)
8010308c:	e8 1f d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103091:	89 3c 24             	mov    %edi,(%esp)
80103094:	e8 57 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103099:	89 34 24             	mov    %esi,(%esp)
8010309c:	e8 4f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030a1:	83 c4 10             	add    $0x10,%esp
801030a4:	3b 1d 08 37 11 80    	cmp    0x80113708,%ebx
801030aa:	7c 94                	jl     80103040 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801030ac:	e8 7f fd ff ff       	call   80102e30 <write_head>
    install_trans(); // Now install writes to home locations
801030b1:	e8 da fc ff ff       	call   80102d90 <install_trans>
    log.lh.n = 0;
801030b6:	c7 05 08 37 11 80 00 	movl   $0x0,0x80113708
801030bd:	00 00 00 
    write_head();    // Erase the transaction from the log
801030c0:	e8 6b fd ff ff       	call   80102e30 <write_head>
801030c5:	e9 34 ff ff ff       	jmp    80102ffe <end_op+0x5e>
801030ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801030d0:	83 ec 0c             	sub    $0xc,%esp
801030d3:	68 c0 36 11 80       	push   $0x801136c0
801030d8:	e8 73 12 00 00       	call   80104350 <wakeup>
  release(&log.lock);
801030dd:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
801030e4:	e8 e7 18 00 00       	call   801049d0 <release>
801030e9:	83 c4 10             	add    $0x10,%esp
}
801030ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030ef:	5b                   	pop    %ebx
801030f0:	5e                   	pop    %esi
801030f1:	5f                   	pop    %edi
801030f2:	5d                   	pop    %ebp
801030f3:	c3                   	ret
    panic("log.committing");
801030f4:	83 ec 0c             	sub    $0xc,%esp
801030f7:	68 1b 7f 10 80       	push   $0x80107f1b
801030fc:	e8 6f d3 ff ff       	call   80100470 <panic>
80103101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103108:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010310f:	90                   	nop

80103110 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
80103113:	53                   	push   %ebx
80103114:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103117:	8b 15 08 37 11 80    	mov    0x80113708,%edx
{
8010311d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103120:	83 fa 1d             	cmp    $0x1d,%edx
80103123:	7f 7d                	jg     801031a2 <log_write+0x92>
80103125:	a1 f8 36 11 80       	mov    0x801136f8,%eax
8010312a:	83 e8 01             	sub    $0x1,%eax
8010312d:	39 c2                	cmp    %eax,%edx
8010312f:	7d 71                	jge    801031a2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103131:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80103136:	85 c0                	test   %eax,%eax
80103138:	7e 75                	jle    801031af <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010313a:	83 ec 0c             	sub    $0xc,%esp
8010313d:	68 c0 36 11 80       	push   $0x801136c0
80103142:	e8 e9 18 00 00       	call   80104a30 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103147:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010314a:	83 c4 10             	add    $0x10,%esp
8010314d:	31 c0                	xor    %eax,%eax
8010314f:	8b 15 08 37 11 80    	mov    0x80113708,%edx
80103155:	85 d2                	test   %edx,%edx
80103157:	7f 0e                	jg     80103167 <log_write+0x57>
80103159:	eb 15                	jmp    80103170 <log_write+0x60>
8010315b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010315f:	90                   	nop
80103160:	83 c0 01             	add    $0x1,%eax
80103163:	39 c2                	cmp    %eax,%edx
80103165:	74 29                	je     80103190 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103167:	39 0c 85 0c 37 11 80 	cmp    %ecx,-0x7feec8f4(,%eax,4)
8010316e:	75 f0                	jne    80103160 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103170:	89 0c 85 0c 37 11 80 	mov    %ecx,-0x7feec8f4(,%eax,4)
  if (i == log.lh.n)
80103177:	39 c2                	cmp    %eax,%edx
80103179:	74 1c                	je     80103197 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010317b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010317e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103181:	c7 45 08 c0 36 11 80 	movl   $0x801136c0,0x8(%ebp)
}
80103188:	c9                   	leave
  release(&log.lock);
80103189:	e9 42 18 00 00       	jmp    801049d0 <release>
8010318e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103190:	89 0c 95 0c 37 11 80 	mov    %ecx,-0x7feec8f4(,%edx,4)
    log.lh.n++;
80103197:	83 c2 01             	add    $0x1,%edx
8010319a:	89 15 08 37 11 80    	mov    %edx,0x80113708
801031a0:	eb d9                	jmp    8010317b <log_write+0x6b>
    panic("too big a transaction");
801031a2:	83 ec 0c             	sub    $0xc,%esp
801031a5:	68 2a 7f 10 80       	push   $0x80107f2a
801031aa:	e8 c1 d2 ff ff       	call   80100470 <panic>
    panic("log_write outside of trans");
801031af:	83 ec 0c             	sub    $0xc,%esp
801031b2:	68 40 7f 10 80       	push   $0x80107f40
801031b7:	e8 b4 d2 ff ff       	call   80100470 <panic>
801031bc:	66 90                	xchg   %ax,%ax
801031be:	66 90                	xchg   %ax,%ax

801031c0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	53                   	push   %ebx
801031c4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031c7:	e8 54 09 00 00       	call   80103b20 <cpuid>
801031cc:	89 c3                	mov    %eax,%ebx
801031ce:	e8 4d 09 00 00       	call   80103b20 <cpuid>
801031d3:	83 ec 04             	sub    $0x4,%esp
801031d6:	53                   	push   %ebx
801031d7:	50                   	push   %eax
801031d8:	68 5b 7f 10 80       	push   $0x80107f5b
801031dd:	e8 be d5 ff ff       	call   801007a0 <cprintf>
  idtinit();       // load idt register
801031e2:	e8 a9 2b 00 00       	call   80105d90 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031e7:	e8 e4 08 00 00       	call   80103ad0 <mycpu>
801031ec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031ee:	b8 01 00 00 00       	mov    $0x1,%eax
801031f3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801031fa:	e8 71 0c 00 00       	call   80103e70 <scheduler>
801031ff:	90                   	nop

80103200 <mpenter>:
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103206:	e8 d5 3d 00 00       	call   80106fe0 <switchkvm>
  seginit();
8010320b:	e8 40 3d 00 00       	call   80106f50 <seginit>
  lapicinit();
80103210:	e8 bb f7 ff ff       	call   801029d0 <lapicinit>
  mpmain();
80103215:	e8 a6 ff ff ff       	call   801031c0 <mpmain>
8010321a:	66 90                	xchg   %ax,%ax
8010321c:	66 90                	xchg   %ax,%ax
8010321e:	66 90                	xchg   %ax,%ax

80103220 <main>:
{
80103220:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103224:	83 e4 f0             	and    $0xfffffff0,%esp
80103227:	ff 71 fc             	push   -0x4(%ecx)
8010322a:	55                   	push   %ebp
8010322b:	89 e5                	mov    %esp,%ebp
8010322d:	53                   	push   %ebx
8010322e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010322f:	83 ec 08             	sub    $0x8,%esp
80103232:	68 00 00 40 80       	push   $0x80400000
80103237:	68 40 8a 11 80       	push   $0x80118a40
8010323c:	e8 ff f4 ff ff       	call   80102740 <kinit1>
  kvmalloc();      // kernel page table
80103241:	e8 8a 42 00 00       	call   801074d0 <kvmalloc>
  mpinit();        // detect other processors
80103246:	e8 85 01 00 00       	call   801033d0 <mpinit>
  lapicinit();     // interrupt controller
8010324b:	e8 80 f7 ff ff       	call   801029d0 <lapicinit>
  seginit();       // segment descriptors
80103250:	e8 fb 3c 00 00       	call   80106f50 <seginit>
  picinit();       // disable pic
80103255:	e8 86 03 00 00       	call   801035e0 <picinit>
  ioapicinit();    // another interrupt controller
8010325a:	e8 51 f2 ff ff       	call   801024b0 <ioapicinit>
  consoleinit();   // console hardware
8010325f:	e8 ec d8 ff ff       	call   80100b50 <consoleinit>
  uartinit();      // serial port
80103264:	e8 37 2e 00 00       	call   801060a0 <uartinit>
  pinit();         // process table
80103269:	e8 42 08 00 00       	call   80103ab0 <pinit>
  tvinit();        // trap vectors
8010326e:	e8 9d 2a 00 00       	call   80105d10 <tvinit>
  binit();         // buffer cache
80103273:	e8 c8 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103278:	e8 a3 dc ff ff       	call   80100f20 <fileinit>
  ideinit();       // disk 
8010327d:	e8 0e f0 ff ff       	call   80102290 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103282:	83 c4 0c             	add    $0xc,%esp
80103285:	68 8a 00 00 00       	push   $0x8a
8010328a:	68 8c b4 10 80       	push   $0x8010b48c
8010328f:	68 00 70 00 80       	push   $0x80007000
80103294:	e8 27 19 00 00       	call   80104bc0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103299:	83 c4 10             	add    $0x10,%esp
8010329c:	69 05 a4 37 11 80 b0 	imul   $0xb0,0x801137a4,%eax
801032a3:	00 00 00 
801032a6:	05 c0 37 11 80       	add    $0x801137c0,%eax
801032ab:	3d c0 37 11 80       	cmp    $0x801137c0,%eax
801032b0:	76 7e                	jbe    80103330 <main+0x110>
801032b2:	bb c0 37 11 80       	mov    $0x801137c0,%ebx
801032b7:	eb 20                	jmp    801032d9 <main+0xb9>
801032b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032c0:	69 05 a4 37 11 80 b0 	imul   $0xb0,0x801137a4,%eax
801032c7:	00 00 00 
801032ca:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032d0:	05 c0 37 11 80       	add    $0x801137c0,%eax
801032d5:	39 c3                	cmp    %eax,%ebx
801032d7:	73 57                	jae    80103330 <main+0x110>
    if(c == mycpu())  // We've started already.
801032d9:	e8 f2 07 00 00       	call   80103ad0 <mycpu>
801032de:	39 c3                	cmp    %eax,%ebx
801032e0:	74 de                	je     801032c0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032e2:	e8 d9 f4 ff ff       	call   801027c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801032e7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801032ea:	c7 05 f8 6f 00 80 00 	movl   $0x80103200,0x80006ff8
801032f1:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032f4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801032fb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801032fe:	05 00 10 00 00       	add    $0x1000,%eax
80103303:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103308:	0f b6 03             	movzbl (%ebx),%eax
8010330b:	68 00 70 00 00       	push   $0x7000
80103310:	50                   	push   %eax
80103311:	e8 fa f7 ff ff       	call   80102b10 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103316:	83 c4 10             	add    $0x10,%esp
80103319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103320:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103326:	85 c0                	test   %eax,%eax
80103328:	74 f6                	je     80103320 <main+0x100>
8010332a:	eb 94                	jmp    801032c0 <main+0xa0>
8010332c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103330:	83 ec 08             	sub    $0x8,%esp
80103333:	68 00 00 40 80       	push   $0x80400000
80103338:	68 00 00 40 80       	push   $0x80400000
8010333d:	e8 8e f3 ff ff       	call   801026d0 <kinit2>
  userinit();      // first user process
80103342:	e8 29 08 00 00       	call   80103b70 <userinit>
  mpmain();        // finish this processor's setup
80103347:	e8 74 fe ff ff       	call   801031c0 <mpmain>
8010334c:	66 90                	xchg   %ax,%ax
8010334e:	66 90                	xchg   %ax,%ax

80103350 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	57                   	push   %edi
80103354:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103355:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010335b:	53                   	push   %ebx
  e = addr+len;
8010335c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010335f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103362:	39 de                	cmp    %ebx,%esi
80103364:	72 10                	jb     80103376 <mpsearch1+0x26>
80103366:	eb 50                	jmp    801033b8 <mpsearch1+0x68>
80103368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010336f:	90                   	nop
80103370:	89 fe                	mov    %edi,%esi
80103372:	39 df                	cmp    %ebx,%edi
80103374:	73 42                	jae    801033b8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103376:	83 ec 04             	sub    $0x4,%esp
80103379:	8d 7e 10             	lea    0x10(%esi),%edi
8010337c:	6a 04                	push   $0x4
8010337e:	68 6f 7f 10 80       	push   $0x80107f6f
80103383:	56                   	push   %esi
80103384:	e8 e7 17 00 00       	call   80104b70 <memcmp>
80103389:	83 c4 10             	add    $0x10,%esp
8010338c:	85 c0                	test   %eax,%eax
8010338e:	75 e0                	jne    80103370 <mpsearch1+0x20>
80103390:	89 f2                	mov    %esi,%edx
80103392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103398:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010339b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010339e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033a0:	39 fa                	cmp    %edi,%edx
801033a2:	75 f4                	jne    80103398 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033a4:	84 c0                	test   %al,%al
801033a6:	75 c8                	jne    80103370 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033ab:	89 f0                	mov    %esi,%eax
801033ad:	5b                   	pop    %ebx
801033ae:	5e                   	pop    %esi
801033af:	5f                   	pop    %edi
801033b0:	5d                   	pop    %ebp
801033b1:	c3                   	ret
801033b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033bb:	31 f6                	xor    %esi,%esi
}
801033bd:	5b                   	pop    %ebx
801033be:	89 f0                	mov    %esi,%eax
801033c0:	5e                   	pop    %esi
801033c1:	5f                   	pop    %edi
801033c2:	5d                   	pop    %ebp
801033c3:	c3                   	ret
801033c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033cf:	90                   	nop

801033d0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033d0:	55                   	push   %ebp
801033d1:	89 e5                	mov    %esp,%ebp
801033d3:	57                   	push   %edi
801033d4:	56                   	push   %esi
801033d5:	53                   	push   %ebx
801033d6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033d9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033e0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033e7:	c1 e0 08             	shl    $0x8,%eax
801033ea:	09 d0                	or     %edx,%eax
801033ec:	c1 e0 04             	shl    $0x4,%eax
801033ef:	75 1b                	jne    8010340c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801033f1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033f8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801033ff:	c1 e0 08             	shl    $0x8,%eax
80103402:	09 d0                	or     %edx,%eax
80103404:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103407:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010340c:	ba 00 04 00 00       	mov    $0x400,%edx
80103411:	e8 3a ff ff ff       	call   80103350 <mpsearch1>
80103416:	89 c3                	mov    %eax,%ebx
80103418:	85 c0                	test   %eax,%eax
8010341a:	0f 84 58 01 00 00    	je     80103578 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103420:	8b 73 04             	mov    0x4(%ebx),%esi
80103423:	85 f6                	test   %esi,%esi
80103425:	0f 84 3d 01 00 00    	je     80103568 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
8010342b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010342e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103434:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103437:	6a 04                	push   $0x4
80103439:	68 74 7f 10 80       	push   $0x80107f74
8010343e:	50                   	push   %eax
8010343f:	e8 2c 17 00 00       	call   80104b70 <memcmp>
80103444:	83 c4 10             	add    $0x10,%esp
80103447:	85 c0                	test   %eax,%eax
80103449:	0f 85 19 01 00 00    	jne    80103568 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010344f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103456:	3c 01                	cmp    $0x1,%al
80103458:	74 08                	je     80103462 <mpinit+0x92>
8010345a:	3c 04                	cmp    $0x4,%al
8010345c:	0f 85 06 01 00 00    	jne    80103568 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103462:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103469:	66 85 d2             	test   %dx,%dx
8010346c:	74 22                	je     80103490 <mpinit+0xc0>
8010346e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103471:	89 f0                	mov    %esi,%eax
  sum = 0;
80103473:	31 d2                	xor    %edx,%edx
80103475:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103478:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010347f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103482:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103484:	39 f8                	cmp    %edi,%eax
80103486:	75 f0                	jne    80103478 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103488:	84 d2                	test   %dl,%dl
8010348a:	0f 85 d8 00 00 00    	jne    80103568 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103490:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103496:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103499:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010349c:	a3 a4 36 11 80       	mov    %eax,0x801136a4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034a1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801034a8:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801034ae:	01 d7                	add    %edx,%edi
801034b0:	89 fa                	mov    %edi,%edx
  ismp = 1;
801034b2:	bf 01 00 00 00       	mov    $0x1,%edi
801034b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034be:	66 90                	xchg   %ax,%ax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034c0:	39 d0                	cmp    %edx,%eax
801034c2:	73 19                	jae    801034dd <mpinit+0x10d>
    switch(*p){
801034c4:	0f b6 08             	movzbl (%eax),%ecx
801034c7:	80 f9 02             	cmp    $0x2,%cl
801034ca:	0f 84 80 00 00 00    	je     80103550 <mpinit+0x180>
801034d0:	77 6e                	ja     80103540 <mpinit+0x170>
801034d2:	84 c9                	test   %cl,%cl
801034d4:	74 3a                	je     80103510 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034d6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034d9:	39 d0                	cmp    %edx,%eax
801034db:	72 e7                	jb     801034c4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034dd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801034e0:	85 ff                	test   %edi,%edi
801034e2:	0f 84 dd 00 00 00    	je     801035c5 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034e8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801034ec:	74 15                	je     80103503 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034ee:	b8 70 00 00 00       	mov    $0x70,%eax
801034f3:	ba 22 00 00 00       	mov    $0x22,%edx
801034f8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034f9:	ba 23 00 00 00       	mov    $0x23,%edx
801034fe:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801034ff:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103502:	ee                   	out    %al,(%dx)
  }
}
80103503:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103506:	5b                   	pop    %ebx
80103507:	5e                   	pop    %esi
80103508:	5f                   	pop    %edi
80103509:	5d                   	pop    %ebp
8010350a:	c3                   	ret
8010350b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010350f:	90                   	nop
      if(ncpu < NCPU) {
80103510:	8b 0d a4 37 11 80    	mov    0x801137a4,%ecx
80103516:	85 c9                	test   %ecx,%ecx
80103518:	7f 19                	jg     80103533 <mpinit+0x163>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010351a:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80103520:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103524:	83 c1 01             	add    $0x1,%ecx
80103527:	89 0d a4 37 11 80    	mov    %ecx,0x801137a4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010352d:	88 9e c0 37 11 80    	mov    %bl,-0x7feec840(%esi)
      p += sizeof(struct mpproc);
80103533:	83 c0 14             	add    $0x14,%eax
      continue;
80103536:	eb 88                	jmp    801034c0 <mpinit+0xf0>
80103538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010353f:	90                   	nop
    switch(*p){
80103540:	83 e9 03             	sub    $0x3,%ecx
80103543:	80 f9 01             	cmp    $0x1,%cl
80103546:	76 8e                	jbe    801034d6 <mpinit+0x106>
80103548:	31 ff                	xor    %edi,%edi
8010354a:	e9 71 ff ff ff       	jmp    801034c0 <mpinit+0xf0>
8010354f:	90                   	nop
      ioapicid = ioapic->apicno;
80103550:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103554:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103557:	88 0d a0 37 11 80    	mov    %cl,0x801137a0
      continue;
8010355d:	e9 5e ff ff ff       	jmp    801034c0 <mpinit+0xf0>
80103562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103568:	83 ec 0c             	sub    $0xc,%esp
8010356b:	68 79 7f 10 80       	push   $0x80107f79
80103570:	e8 fb ce ff ff       	call   80100470 <panic>
80103575:	8d 76 00             	lea    0x0(%esi),%esi
{
80103578:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010357d:	eb 0b                	jmp    8010358a <mpinit+0x1ba>
8010357f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103580:	89 f3                	mov    %esi,%ebx
80103582:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103588:	74 de                	je     80103568 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010358a:	83 ec 04             	sub    $0x4,%esp
8010358d:	8d 73 10             	lea    0x10(%ebx),%esi
80103590:	6a 04                	push   $0x4
80103592:	68 6f 7f 10 80       	push   $0x80107f6f
80103597:	53                   	push   %ebx
80103598:	e8 d3 15 00 00       	call   80104b70 <memcmp>
8010359d:	83 c4 10             	add    $0x10,%esp
801035a0:	85 c0                	test   %eax,%eax
801035a2:	75 dc                	jne    80103580 <mpinit+0x1b0>
801035a4:	89 da                	mov    %ebx,%edx
801035a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ad:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035b0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801035b3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801035b6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801035b8:	39 d6                	cmp    %edx,%esi
801035ba:	75 f4                	jne    801035b0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035bc:	84 c0                	test   %al,%al
801035be:	75 c0                	jne    80103580 <mpinit+0x1b0>
801035c0:	e9 5b fe ff ff       	jmp    80103420 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801035c5:	83 ec 0c             	sub    $0xc,%esp
801035c8:	68 b4 83 10 80       	push   $0x801083b4
801035cd:	e8 9e ce ff ff       	call   80100470 <panic>
801035d2:	66 90                	xchg   %ax,%ax
801035d4:	66 90                	xchg   %ax,%ax
801035d6:	66 90                	xchg   %ax,%ax
801035d8:	66 90                	xchg   %ax,%ax
801035da:	66 90                	xchg   %ax,%ax
801035dc:	66 90                	xchg   %ax,%ax
801035de:	66 90                	xchg   %ax,%ax

801035e0 <picinit>:
801035e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035e5:	ba 21 00 00 00       	mov    $0x21,%edx
801035ea:	ee                   	out    %al,(%dx)
801035eb:	ba a1 00 00 00       	mov    $0xa1,%edx
801035f0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801035f1:	c3                   	ret
801035f2:	66 90                	xchg   %ax,%ax
801035f4:	66 90                	xchg   %ax,%ax
801035f6:	66 90                	xchg   %ax,%ax
801035f8:	66 90                	xchg   %ax,%ax
801035fa:	66 90                	xchg   %ax,%ax
801035fc:	66 90                	xchg   %ax,%ax
801035fe:	66 90                	xchg   %ax,%ax

80103600 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	57                   	push   %edi
80103604:	56                   	push   %esi
80103605:	53                   	push   %ebx
80103606:	83 ec 0c             	sub    $0xc,%esp
80103609:	8b 75 08             	mov    0x8(%ebp),%esi
8010360c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010360f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103615:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010361b:	e8 20 d9 ff ff       	call   80100f40 <filealloc>
80103620:	89 06                	mov    %eax,(%esi)
80103622:	85 c0                	test   %eax,%eax
80103624:	0f 84 a5 00 00 00    	je     801036cf <pipealloc+0xcf>
8010362a:	e8 11 d9 ff ff       	call   80100f40 <filealloc>
8010362f:	89 07                	mov    %eax,(%edi)
80103631:	85 c0                	test   %eax,%eax
80103633:	0f 84 84 00 00 00    	je     801036bd <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103639:	e8 82 f1 ff ff       	call   801027c0 <kalloc>
8010363e:	89 c3                	mov    %eax,%ebx
80103640:	85 c0                	test   %eax,%eax
80103642:	0f 84 a0 00 00 00    	je     801036e8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103648:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010364f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103652:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103655:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010365c:	00 00 00 
  p->nwrite = 0;
8010365f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103666:	00 00 00 
  p->nread = 0;
80103669:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103670:	00 00 00 
  initlock(&p->lock, "pipe");
80103673:	68 91 7f 10 80       	push   $0x80107f91
80103678:	50                   	push   %eax
80103679:	e8 c2 11 00 00       	call   80104840 <initlock>
  (*f0)->type = FD_PIPE;
8010367e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103680:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103683:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103689:	8b 06                	mov    (%esi),%eax
8010368b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010368f:	8b 06                	mov    (%esi),%eax
80103691:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103695:	8b 06                	mov    (%esi),%eax
80103697:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010369a:	8b 07                	mov    (%edi),%eax
8010369c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036a2:	8b 07                	mov    (%edi),%eax
801036a4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036a8:	8b 07                	mov    (%edi),%eax
801036aa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036ae:	8b 07                	mov    (%edi),%eax
801036b0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801036b3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036b8:	5b                   	pop    %ebx
801036b9:	5e                   	pop    %esi
801036ba:	5f                   	pop    %edi
801036bb:	5d                   	pop    %ebp
801036bc:	c3                   	ret
  if(*f0)
801036bd:	8b 06                	mov    (%esi),%eax
801036bf:	85 c0                	test   %eax,%eax
801036c1:	74 1e                	je     801036e1 <pipealloc+0xe1>
    fileclose(*f0);
801036c3:	83 ec 0c             	sub    $0xc,%esp
801036c6:	50                   	push   %eax
801036c7:	e8 34 d9 ff ff       	call   80101000 <fileclose>
801036cc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801036cf:	8b 07                	mov    (%edi),%eax
801036d1:	85 c0                	test   %eax,%eax
801036d3:	74 0c                	je     801036e1 <pipealloc+0xe1>
    fileclose(*f1);
801036d5:	83 ec 0c             	sub    $0xc,%esp
801036d8:	50                   	push   %eax
801036d9:	e8 22 d9 ff ff       	call   80101000 <fileclose>
801036de:	83 c4 10             	add    $0x10,%esp
  return -1;
801036e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801036e6:	eb cd                	jmp    801036b5 <pipealloc+0xb5>
  if(*f0)
801036e8:	8b 06                	mov    (%esi),%eax
801036ea:	85 c0                	test   %eax,%eax
801036ec:	75 d5                	jne    801036c3 <pipealloc+0xc3>
801036ee:	eb df                	jmp    801036cf <pipealloc+0xcf>

801036f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	56                   	push   %esi
801036f4:	53                   	push   %ebx
801036f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801036fb:	83 ec 0c             	sub    $0xc,%esp
801036fe:	53                   	push   %ebx
801036ff:	e8 2c 13 00 00       	call   80104a30 <acquire>
  if(writable){
80103704:	83 c4 10             	add    $0x10,%esp
80103707:	85 f6                	test   %esi,%esi
80103709:	74 65                	je     80103770 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010370b:	83 ec 0c             	sub    $0xc,%esp
8010370e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103714:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010371b:	00 00 00 
    wakeup(&p->nread);
8010371e:	50                   	push   %eax
8010371f:	e8 2c 0c 00 00       	call   80104350 <wakeup>
80103724:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103727:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010372d:	85 d2                	test   %edx,%edx
8010372f:	75 0a                	jne    8010373b <pipeclose+0x4b>
80103731:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103737:	85 c0                	test   %eax,%eax
80103739:	74 15                	je     80103750 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010373b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010373e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103741:	5b                   	pop    %ebx
80103742:	5e                   	pop    %esi
80103743:	5d                   	pop    %ebp
    release(&p->lock);
80103744:	e9 87 12 00 00       	jmp    801049d0 <release>
80103749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103750:	83 ec 0c             	sub    $0xc,%esp
80103753:	53                   	push   %ebx
80103754:	e8 77 12 00 00       	call   801049d0 <release>
    kfree((char*)p);
80103759:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010375c:	83 c4 10             	add    $0x10,%esp
}
8010375f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103762:	5b                   	pop    %ebx
80103763:	5e                   	pop    %esi
80103764:	5d                   	pop    %ebp
    kfree((char*)p);
80103765:	e9 36 ee ff ff       	jmp    801025a0 <kfree>
8010376a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103770:	83 ec 0c             	sub    $0xc,%esp
80103773:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103779:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103780:	00 00 00 
    wakeup(&p->nwrite);
80103783:	50                   	push   %eax
80103784:	e8 c7 0b 00 00       	call   80104350 <wakeup>
80103789:	83 c4 10             	add    $0x10,%esp
8010378c:	eb 99                	jmp    80103727 <pipeclose+0x37>
8010378e:	66 90                	xchg   %ax,%ax

80103790 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	57                   	push   %edi
80103794:	56                   	push   %esi
80103795:	53                   	push   %ebx
80103796:	83 ec 28             	sub    $0x28,%esp
80103799:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010379c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010379f:	53                   	push   %ebx
801037a0:	e8 8b 12 00 00       	call   80104a30 <acquire>
  for(i = 0; i < n; i++){
801037a5:	83 c4 10             	add    $0x10,%esp
801037a8:	85 ff                	test   %edi,%edi
801037aa:	0f 8e ce 00 00 00    	jle    8010387e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037b0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801037b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801037b9:	89 7d 10             	mov    %edi,0x10(%ebp)
801037bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801037bf:	8d 34 39             	lea    (%ecx,%edi,1),%esi
801037c2:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037c5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037cb:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037d1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037d7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801037dd:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801037e0:	0f 85 b6 00 00 00    	jne    8010389c <pipewrite+0x10c>
801037e6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801037e9:	eb 3b                	jmp    80103826 <pipewrite+0x96>
801037eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037ef:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
801037f0:	e8 4b 03 00 00       	call   80103b40 <myproc>
801037f5:	8b 48 28             	mov    0x28(%eax),%ecx
801037f8:	85 c9                	test   %ecx,%ecx
801037fa:	75 34                	jne    80103830 <pipewrite+0xa0>
      wakeup(&p->nread);
801037fc:	83 ec 0c             	sub    $0xc,%esp
801037ff:	56                   	push   %esi
80103800:	e8 4b 0b 00 00       	call   80104350 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103805:	58                   	pop    %eax
80103806:	5a                   	pop    %edx
80103807:	53                   	push   %ebx
80103808:	57                   	push   %edi
80103809:	e8 82 0a 00 00       	call   80104290 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010380e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103814:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010381a:	83 c4 10             	add    $0x10,%esp
8010381d:	05 00 02 00 00       	add    $0x200,%eax
80103822:	39 c2                	cmp    %eax,%edx
80103824:	75 2a                	jne    80103850 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103826:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010382c:	85 c0                	test   %eax,%eax
8010382e:	75 c0                	jne    801037f0 <pipewrite+0x60>
        release(&p->lock);
80103830:	83 ec 0c             	sub    $0xc,%esp
80103833:	53                   	push   %ebx
80103834:	e8 97 11 00 00       	call   801049d0 <release>
        return -1;
80103839:	83 c4 10             	add    $0x10,%esp
8010383c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103841:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103844:	5b                   	pop    %ebx
80103845:	5e                   	pop    %esi
80103846:	5f                   	pop    %edi
80103847:	5d                   	pop    %ebp
80103848:	c3                   	ret
80103849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103850:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103853:	8d 42 01             	lea    0x1(%edx),%eax
80103856:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010385c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010385f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103865:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103868:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010386c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103870:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103873:	39 c1                	cmp    %eax,%ecx
80103875:	0f 85 50 ff ff ff    	jne    801037cb <pipewrite+0x3b>
8010387b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010387e:	83 ec 0c             	sub    $0xc,%esp
80103881:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103887:	50                   	push   %eax
80103888:	e8 c3 0a 00 00       	call   80104350 <wakeup>
  release(&p->lock);
8010388d:	89 1c 24             	mov    %ebx,(%esp)
80103890:	e8 3b 11 00 00       	call   801049d0 <release>
  return n;
80103895:	83 c4 10             	add    $0x10,%esp
80103898:	89 f8                	mov    %edi,%eax
8010389a:	eb a5                	jmp    80103841 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010389c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010389f:	eb b2                	jmp    80103853 <pipewrite+0xc3>
801038a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038af:	90                   	nop

801038b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	57                   	push   %edi
801038b4:	56                   	push   %esi
801038b5:	53                   	push   %ebx
801038b6:	83 ec 18             	sub    $0x18,%esp
801038b9:	8b 75 08             	mov    0x8(%ebp),%esi
801038bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038bf:	56                   	push   %esi
801038c0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801038c6:	e8 65 11 00 00       	call   80104a30 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038cb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038d1:	83 c4 10             	add    $0x10,%esp
801038d4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801038da:	74 2f                	je     8010390b <piperead+0x5b>
801038dc:	eb 37                	jmp    80103915 <piperead+0x65>
801038de:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801038e0:	e8 5b 02 00 00       	call   80103b40 <myproc>
801038e5:	8b 40 28             	mov    0x28(%eax),%eax
801038e8:	85 c0                	test   %eax,%eax
801038ea:	0f 85 80 00 00 00    	jne    80103970 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038f0:	83 ec 08             	sub    $0x8,%esp
801038f3:	56                   	push   %esi
801038f4:	53                   	push   %ebx
801038f5:	e8 96 09 00 00       	call   80104290 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038fa:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103900:	83 c4 10             	add    $0x10,%esp
80103903:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103909:	75 0a                	jne    80103915 <piperead+0x65>
8010390b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103911:	85 d2                	test   %edx,%edx
80103913:	75 cb                	jne    801038e0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103915:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103918:	31 db                	xor    %ebx,%ebx
8010391a:	85 c9                	test   %ecx,%ecx
8010391c:	7f 26                	jg     80103944 <piperead+0x94>
8010391e:	eb 2c                	jmp    8010394c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103920:	8d 48 01             	lea    0x1(%eax),%ecx
80103923:	25 ff 01 00 00       	and    $0x1ff,%eax
80103928:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010392e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103933:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103936:	83 c3 01             	add    $0x1,%ebx
80103939:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010393c:	74 0e                	je     8010394c <piperead+0x9c>
8010393e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103944:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010394a:	75 d4                	jne    80103920 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010394c:	83 ec 0c             	sub    $0xc,%esp
8010394f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103955:	50                   	push   %eax
80103956:	e8 f5 09 00 00       	call   80104350 <wakeup>
  release(&p->lock);
8010395b:	89 34 24             	mov    %esi,(%esp)
8010395e:	e8 6d 10 00 00       	call   801049d0 <release>
  return i;
80103963:	83 c4 10             	add    $0x10,%esp
}
80103966:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103969:	89 d8                	mov    %ebx,%eax
8010396b:	5b                   	pop    %ebx
8010396c:	5e                   	pop    %esi
8010396d:	5f                   	pop    %edi
8010396e:	5d                   	pop    %ebp
8010396f:	c3                   	ret
      release(&p->lock);
80103970:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103973:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103978:	56                   	push   %esi
80103979:	e8 52 10 00 00       	call   801049d0 <release>
      return -1;
8010397e:	83 c4 10             	add    $0x10,%esp
}
80103981:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103984:	89 d8                	mov    %ebx,%eax
80103986:	5b                   	pop    %ebx
80103987:	5e                   	pop    %esi
80103988:	5f                   	pop    %edi
80103989:	5d                   	pop    %ebp
8010398a:	c3                   	ret
8010398b:	66 90                	xchg   %ax,%ax
8010398d:	66 90                	xchg   %ax,%ax
8010398f:	90                   	nop

80103990 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103994:	bb b4 38 11 80       	mov    $0x801138b4,%ebx
{
80103999:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010399c:	68 80 38 11 80       	push   $0x80113880
801039a1:	e8 8a 10 00 00       	call   80104a30 <acquire>
801039a6:	83 c4 10             	add    $0x10,%esp
801039a9:	eb 10                	jmp    801039bb <allocproc+0x2b>
801039ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039af:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039b0:	83 eb 80             	sub    $0xffffff80,%ebx
801039b3:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
801039b9:	74 75                	je     80103a30 <allocproc+0xa0>
    if(p->state == UNUSED)
801039bb:	8b 43 10             	mov    0x10(%ebx),%eax
801039be:	85 c0                	test   %eax,%eax
801039c0:	75 ee                	jne    801039b0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039c2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801039c7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039ca:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
801039d1:	89 43 14             	mov    %eax,0x14(%ebx)
801039d4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801039d7:	68 80 38 11 80       	push   $0x80113880
  p->pid = nextpid++;
801039dc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801039e2:	e8 e9 0f 00 00       	call   801049d0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039e7:	e8 d4 ed ff ff       	call   801027c0 <kalloc>
801039ec:	83 c4 10             	add    $0x10,%esp
801039ef:	89 43 0c             	mov    %eax,0xc(%ebx)
801039f2:	85 c0                	test   %eax,%eax
801039f4:	74 53                	je     80103a49 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039f6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039fc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801039ff:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a04:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
80103a07:	c7 40 14 02 5d 10 80 	movl   $0x80105d02,0x14(%eax)
  p->context = (struct context*)sp;
80103a0e:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a11:	6a 14                	push   $0x14
80103a13:	6a 00                	push   $0x0
80103a15:	50                   	push   %eax
80103a16:	e8 15 11 00 00       	call   80104b30 <memset>
  p->context->eip = (uint)forkret;
80103a1b:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
80103a1e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a21:	c7 40 10 60 3a 10 80 	movl   $0x80103a60,0x10(%eax)
}
80103a28:	89 d8                	mov    %ebx,%eax
80103a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a2d:	c9                   	leave
80103a2e:	c3                   	ret
80103a2f:	90                   	nop
  release(&ptable.lock);
80103a30:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a33:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a35:	68 80 38 11 80       	push   $0x80113880
80103a3a:	e8 91 0f 00 00       	call   801049d0 <release>
  return 0;
80103a3f:	83 c4 10             	add    $0x10,%esp
}
80103a42:	89 d8                	mov    %ebx,%eax
80103a44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a47:	c9                   	leave
80103a48:	c3                   	ret
    p->state = UNUSED;
80103a49:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  return 0;
80103a50:	31 db                	xor    %ebx,%ebx
80103a52:	eb ee                	jmp    80103a42 <allocproc+0xb2>
80103a54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a5f:	90                   	nop

80103a60 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a66:	68 80 38 11 80       	push   $0x80113880
80103a6b:	e8 60 0f 00 00       	call   801049d0 <release>

  if (first) {
80103a70:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a75:	83 c4 10             	add    $0x10,%esp
80103a78:	85 c0                	test   %eax,%eax
80103a7a:	75 04                	jne    80103a80 <forkret+0x20>
    initlog(ROOTDEV);
    swapinit();
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a7c:	c9                   	leave
80103a7d:	c3                   	ret
80103a7e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a80:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a87:	00 00 00 
    iinit(ROOTDEV);
80103a8a:	83 ec 0c             	sub    $0xc,%esp
80103a8d:	6a 01                	push   $0x1
80103a8f:	e8 dc db ff ff       	call   80101670 <iinit>
    initlog(ROOTDEV);
80103a94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a9b:	e8 f0 f3 ff ff       	call   80102e90 <initlog>
    swapinit();
80103aa0:	83 c4 10             	add    $0x10,%esp
}
80103aa3:	c9                   	leave
    swapinit();
80103aa4:	e9 27 3f 00 00       	jmp    801079d0 <swapinit>
80103aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ab0 <pinit>:
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ab6:	68 96 7f 10 80       	push   $0x80107f96
80103abb:	68 80 38 11 80       	push   $0x80113880
80103ac0:	e8 7b 0d 00 00       	call   80104840 <initlock>
}
80103ac5:	83 c4 10             	add    $0x10,%esp
80103ac8:	c9                   	leave
80103ac9:	c3                   	ret
80103aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ad0 <mycpu>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ad6:	9c                   	pushf
80103ad7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ad8:	f6 c4 02             	test   $0x2,%ah
80103adb:	75 32                	jne    80103b0f <mycpu+0x3f>
  apicid = lapicid();
80103add:	e8 de ef ff ff       	call   80102ac0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ae2:	8b 15 a4 37 11 80    	mov    0x801137a4,%edx
80103ae8:	85 d2                	test   %edx,%edx
80103aea:	7e 0b                	jle    80103af7 <mycpu+0x27>
    if (cpus[i].apicid == apicid)
80103aec:	0f b6 15 c0 37 11 80 	movzbl 0x801137c0,%edx
80103af3:	39 d0                	cmp    %edx,%eax
80103af5:	74 11                	je     80103b08 <mycpu+0x38>
  panic("unknown apicid\n");
80103af7:	83 ec 0c             	sub    $0xc,%esp
80103afa:	68 9d 7f 10 80       	push   $0x80107f9d
80103aff:	e8 6c c9 ff ff       	call   80100470 <panic>
80103b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80103b08:	c9                   	leave
80103b09:	b8 c0 37 11 80       	mov    $0x801137c0,%eax
80103b0e:	c3                   	ret
    panic("mycpu called with interrupts enabled\n");
80103b0f:	83 ec 0c             	sub    $0xc,%esp
80103b12:	68 d4 83 10 80       	push   $0x801083d4
80103b17:	e8 54 c9 ff ff       	call   80100470 <panic>
80103b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b20 <cpuid>:
cpuid() {
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b26:	e8 a5 ff ff ff       	call   80103ad0 <mycpu>
}
80103b2b:	c9                   	leave
  return mycpu()-cpus;
80103b2c:	2d c0 37 11 80       	sub    $0x801137c0,%eax
80103b31:	c1 f8 04             	sar    $0x4,%eax
80103b34:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b3a:	c3                   	ret
80103b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b3f:	90                   	nop

80103b40 <myproc>:
myproc(void) {
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	53                   	push   %ebx
80103b44:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b47:	e8 94 0d 00 00       	call   801048e0 <pushcli>
  c = mycpu();
80103b4c:	e8 7f ff ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
80103b51:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b57:	e8 d4 0d 00 00       	call   80104930 <popcli>
}
80103b5c:	89 d8                	mov    %ebx,%eax
80103b5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b61:	c9                   	leave
80103b62:	c3                   	ret
80103b63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b70 <userinit>:
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	53                   	push   %ebx
80103b74:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b77:	e8 14 fe ff ff       	call   80103990 <allocproc>
80103b7c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b7e:	a3 b4 58 11 80       	mov    %eax,0x801158b4
  if((p->pgdir = setupkvm()) == 0)
80103b83:	e8 c8 38 00 00       	call   80107450 <setupkvm>
80103b88:	89 43 08             	mov    %eax,0x8(%ebx)
80103b8b:	85 c0                	test   %eax,%eax
80103b8d:	0f 84 bd 00 00 00    	je     80103c50 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b93:	83 ec 04             	sub    $0x4,%esp
80103b96:	68 2c 00 00 00       	push   $0x2c
80103b9b:	68 60 b4 10 80       	push   $0x8010b460
80103ba0:	50                   	push   %eax
80103ba1:	e8 5a 35 00 00       	call   80107100 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103ba6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103ba9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103baf:	6a 4c                	push   $0x4c
80103bb1:	6a 00                	push   $0x0
80103bb3:	ff 73 1c             	push   0x1c(%ebx)
80103bb6:	e8 75 0f 00 00       	call   80104b30 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bbb:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bbe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bc3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bc6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bcb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bcf:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bd2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bd6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bd9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bdd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103be1:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103be4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103be8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bec:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bef:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103bf6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bf9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c00:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c03:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c0a:	8d 43 70             	lea    0x70(%ebx),%eax
80103c0d:	6a 10                	push   $0x10
80103c0f:	68 c6 7f 10 80       	push   $0x80107fc6
80103c14:	50                   	push   %eax
80103c15:	e8 c6 10 00 00       	call   80104ce0 <safestrcpy>
  p->cwd = namei("/");
80103c1a:	c7 04 24 cf 7f 10 80 	movl   $0x80107fcf,(%esp)
80103c21:	e8 4a e5 ff ff       	call   80102170 <namei>
80103c26:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
80103c29:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103c30:	e8 fb 0d 00 00       	call   80104a30 <acquire>
  p->state = RUNNABLE;
80103c35:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
80103c3c:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103c43:	e8 88 0d 00 00       	call   801049d0 <release>
}
80103c48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c4b:	83 c4 10             	add    $0x10,%esp
80103c4e:	c9                   	leave
80103c4f:	c3                   	ret
    panic("userinit: out of memory?");
80103c50:	83 ec 0c             	sub    $0xc,%esp
80103c53:	68 ad 7f 10 80       	push   $0x80107fad
80103c58:	e8 13 c8 ff ff       	call   80100470 <panic>
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi

80103c60 <growproc>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	56                   	push   %esi
80103c64:	53                   	push   %ebx
80103c65:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c68:	e8 73 0c 00 00       	call   801048e0 <pushcli>
  c = mycpu();
80103c6d:	e8 5e fe ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
80103c72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c78:	e8 b3 0c 00 00       	call   80104930 <popcli>
  sz = curproc->sz;
80103c7d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c7f:	85 f6                	test   %esi,%esi
80103c81:	7f 1d                	jg     80103ca0 <growproc+0x40>
  } else if(n < 0){
80103c83:	75 3b                	jne    80103cc0 <growproc+0x60>
  switchuvm(curproc);
80103c85:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c88:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c8a:	53                   	push   %ebx
80103c8b:	e8 60 33 00 00       	call   80106ff0 <switchuvm>
  return 0;
80103c90:	83 c4 10             	add    $0x10,%esp
80103c93:	31 c0                	xor    %eax,%eax
}
80103c95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c98:	5b                   	pop    %ebx
80103c99:	5e                   	pop    %esi
80103c9a:	5d                   	pop    %ebp
80103c9b:	c3                   	ret
80103c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ca0:	83 ec 04             	sub    $0x4,%esp
80103ca3:	01 c6                	add    %eax,%esi
80103ca5:	56                   	push   %esi
80103ca6:	50                   	push   %eax
80103ca7:	ff 73 08             	push   0x8(%ebx)
80103caa:	e8 a1 35 00 00       	call   80107250 <allocuvm>
80103caf:	83 c4 10             	add    $0x10,%esp
80103cb2:	85 c0                	test   %eax,%eax
80103cb4:	75 cf                	jne    80103c85 <growproc+0x25>
      return -1;
80103cb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cbb:	eb d8                	jmp    80103c95 <growproc+0x35>
80103cbd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cc0:	83 ec 04             	sub    $0x4,%esp
80103cc3:	01 c6                	add    %eax,%esi
80103cc5:	56                   	push   %esi
80103cc6:	50                   	push   %eax
80103cc7:	ff 73 08             	push   0x8(%ebx)
80103cca:	e8 a1 36 00 00       	call   80107370 <deallocuvm>
80103ccf:	83 c4 10             	add    $0x10,%esp
80103cd2:	85 c0                	test   %eax,%eax
80103cd4:	75 af                	jne    80103c85 <growproc+0x25>
80103cd6:	eb de                	jmp    80103cb6 <growproc+0x56>
80103cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cdf:	90                   	nop

80103ce0 <fork>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	57                   	push   %edi
80103ce4:	56                   	push   %esi
80103ce5:	53                   	push   %ebx
80103ce6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103ce9:	e8 f2 0b 00 00       	call   801048e0 <pushcli>
  c = mycpu();
80103cee:	e8 dd fd ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
80103cf3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cf9:	e8 32 0c 00 00       	call   80104930 <popcli>
  if((np = allocproc()) == 0){
80103cfe:	e8 8d fc ff ff       	call   80103990 <allocproc>
80103d03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d06:	85 c0                	test   %eax,%eax
80103d08:	0f 84 de 00 00 00    	je     80103dec <fork+0x10c>
  if((np->pgdir = copyuvm_cow(curproc->pgdir, curproc->sz,np)) == 0){
80103d0e:	83 ec 04             	sub    $0x4,%esp
80103d11:	89 c7                	mov    %eax,%edi
80103d13:	50                   	push   %eax
80103d14:	ff 33                	push   (%ebx)
80103d16:	ff 73 08             	push   0x8(%ebx)
80103d19:	e8 52 39 00 00       	call   80107670 <copyuvm_cow>
80103d1e:	83 c4 10             	add    $0x10,%esp
80103d21:	89 47 08             	mov    %eax,0x8(%edi)
80103d24:	85 c0                	test   %eax,%eax
80103d26:	0f 84 a1 00 00 00    	je     80103dcd <fork+0xed>
  np->sz = curproc->sz;
80103d2c:	8b 03                	mov    (%ebx),%eax
80103d2e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d31:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d33:	8b 79 1c             	mov    0x1c(%ecx),%edi
  np->parent = curproc;
80103d36:	89 c8                	mov    %ecx,%eax
80103d38:	89 59 18             	mov    %ebx,0x18(%ecx)
  *np->tf = *curproc->tf;
80103d3b:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d40:	8b 73 1c             	mov    0x1c(%ebx),%esi
80103d43:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d45:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d47:	8b 40 1c             	mov    0x1c(%eax),%eax
80103d4a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103d58:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103d5c:	85 c0                	test   %eax,%eax
80103d5e:	74 13                	je     80103d73 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d60:	83 ec 0c             	sub    $0xc,%esp
80103d63:	50                   	push   %eax
80103d64:	e8 47 d2 ff ff       	call   80100fb0 <filedup>
80103d69:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d6c:	83 c4 10             	add    $0x10,%esp
80103d6f:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d73:	83 c6 01             	add    $0x1,%esi
80103d76:	83 fe 10             	cmp    $0x10,%esi
80103d79:	75 dd                	jne    80103d58 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103d7b:	83 ec 0c             	sub    $0xc,%esp
80103d7e:	ff 73 6c             	push   0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d81:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103d84:	e8 d7 da ff ff       	call   80101860 <idup>
80103d89:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d8c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d8f:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d92:	8d 47 70             	lea    0x70(%edi),%eax
80103d95:	6a 10                	push   $0x10
80103d97:	53                   	push   %ebx
80103d98:	50                   	push   %eax
80103d99:	e8 42 0f 00 00       	call   80104ce0 <safestrcpy>
  pid = np->pid;
80103d9e:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
80103da1:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103da8:	e8 83 0c 00 00       	call   80104a30 <acquire>
  np->state = RUNNABLE;
80103dad:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
80103db4:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103dbb:	e8 10 0c 00 00       	call   801049d0 <release>
  return pid;
80103dc0:	83 c4 10             	add    $0x10,%esp
}
80103dc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dc6:	89 d8                	mov    %ebx,%eax
80103dc8:	5b                   	pop    %ebx
80103dc9:	5e                   	pop    %esi
80103dca:	5f                   	pop    %edi
80103dcb:	5d                   	pop    %ebp
80103dcc:	c3                   	ret
    kfree(np->kstack);
80103dcd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103dd0:	83 ec 0c             	sub    $0xc,%esp
80103dd3:	ff 73 0c             	push   0xc(%ebx)
80103dd6:	e8 c5 e7 ff ff       	call   801025a0 <kfree>
    np->kstack = 0;
80103ddb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103de2:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103de5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
80103dec:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103df1:	eb d0                	jmp    80103dc3 <fork+0xe3>
80103df3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e00 <print_rss>:
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e04:	bb b4 38 11 80       	mov    $0x801138b4,%ebx
{
80103e09:	83 ec 10             	sub    $0x10,%esp
  cprintf("PrintingRSS\n");
80103e0c:	68 d1 7f 10 80       	push   $0x80107fd1
80103e11:	e8 8a c9 ff ff       	call   801007a0 <cprintf>
  acquire(&ptable.lock);
80103e16:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103e1d:	e8 0e 0c 00 00       	call   80104a30 <acquire>
80103e22:	83 c4 10             	add    $0x10,%esp
80103e25:	8d 76 00             	lea    0x0(%esi),%esi
    if((p->state == UNUSED))
80103e28:	8b 43 10             	mov    0x10(%ebx),%eax
80103e2b:	85 c0                	test   %eax,%eax
80103e2d:	74 14                	je     80103e43 <print_rss+0x43>
    cprintf("((P)) id: %d, state: %d, rss: %d\n",p->pid,p->state,p->rss);
80103e2f:	ff 73 04             	push   0x4(%ebx)
80103e32:	50                   	push   %eax
80103e33:	ff 73 14             	push   0x14(%ebx)
80103e36:	68 fc 83 10 80       	push   $0x801083fc
80103e3b:	e8 60 c9 ff ff       	call   801007a0 <cprintf>
80103e40:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e43:	83 eb 80             	sub    $0xffffff80,%ebx
80103e46:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
80103e4c:	75 da                	jne    80103e28 <print_rss+0x28>
  release(&ptable.lock);
80103e4e:	83 ec 0c             	sub    $0xc,%esp
80103e51:	68 80 38 11 80       	push   $0x80113880
80103e56:	e8 75 0b 00 00       	call   801049d0 <release>
}
80103e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e5e:	83 c4 10             	add    $0x10,%esp
80103e61:	c9                   	leave
80103e62:	c3                   	ret
80103e63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e70 <scheduler>:
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	57                   	push   %edi
80103e74:	56                   	push   %esi
80103e75:	53                   	push   %ebx
80103e76:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e79:	e8 52 fc ff ff       	call   80103ad0 <mycpu>
  c->proc = 0;
80103e7e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e85:	00 00 00 
  struct cpu *c = mycpu();
80103e88:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e8a:	8d 78 04             	lea    0x4(%eax),%edi
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e90:	fb                   	sti
    acquire(&ptable.lock);
80103e91:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e94:	bb b4 38 11 80       	mov    $0x801138b4,%ebx
    acquire(&ptable.lock);
80103e99:	68 80 38 11 80       	push   $0x80113880
80103e9e:	e8 8d 0b 00 00       	call   80104a30 <acquire>
80103ea3:	83 c4 10             	add    $0x10,%esp
80103ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ead:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103eb0:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80103eb4:	75 33                	jne    80103ee9 <scheduler+0x79>
      switchuvm(p);
80103eb6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103eb9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103ebf:	53                   	push   %ebx
80103ec0:	e8 2b 31 00 00       	call   80106ff0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ec5:	58                   	pop    %eax
80103ec6:	5a                   	pop    %edx
80103ec7:	ff 73 20             	push   0x20(%ebx)
80103eca:	57                   	push   %edi
      p->state = RUNNING;
80103ecb:	c7 43 10 04 00 00 00 	movl   $0x4,0x10(%ebx)
      swtch(&(c->scheduler), p->context);
80103ed2:	e8 64 0e 00 00       	call   80104d3b <swtch>
      switchkvm();
80103ed7:	e8 04 31 00 00       	call   80106fe0 <switchkvm>
      c->proc = 0;
80103edc:	83 c4 10             	add    $0x10,%esp
80103edf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ee6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee9:	83 eb 80             	sub    $0xffffff80,%ebx
80103eec:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
80103ef2:	75 bc                	jne    80103eb0 <scheduler+0x40>
    release(&ptable.lock);
80103ef4:	83 ec 0c             	sub    $0xc,%esp
80103ef7:	68 80 38 11 80       	push   $0x80113880
80103efc:	e8 cf 0a 00 00       	call   801049d0 <release>
    sti();
80103f01:	83 c4 10             	add    $0x10,%esp
80103f04:	eb 8a                	jmp    80103e90 <scheduler+0x20>
80103f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f0d:	8d 76 00             	lea    0x0(%esi),%esi

80103f10 <sched>:
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	56                   	push   %esi
80103f14:	53                   	push   %ebx
  pushcli();
80103f15:	e8 c6 09 00 00       	call   801048e0 <pushcli>
  c = mycpu();
80103f1a:	e8 b1 fb ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
80103f1f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f25:	e8 06 0a 00 00       	call   80104930 <popcli>
  if(!holding(&ptable.lock))
80103f2a:	83 ec 0c             	sub    $0xc,%esp
80103f2d:	68 80 38 11 80       	push   $0x80113880
80103f32:	e8 59 0a 00 00       	call   80104990 <holding>
80103f37:	83 c4 10             	add    $0x10,%esp
80103f3a:	85 c0                	test   %eax,%eax
80103f3c:	74 4f                	je     80103f8d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f3e:	e8 8d fb ff ff       	call   80103ad0 <mycpu>
80103f43:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f4a:	75 68                	jne    80103fb4 <sched+0xa4>
  if(p->state == RUNNING)
80103f4c:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80103f50:	74 55                	je     80103fa7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f52:	9c                   	pushf
80103f53:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f54:	f6 c4 02             	test   $0x2,%ah
80103f57:	75 41                	jne    80103f9a <sched+0x8a>
  intena = mycpu()->intena;
80103f59:	e8 72 fb ff ff       	call   80103ad0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f5e:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
80103f61:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f67:	e8 64 fb ff ff       	call   80103ad0 <mycpu>
80103f6c:	83 ec 08             	sub    $0x8,%esp
80103f6f:	ff 70 04             	push   0x4(%eax)
80103f72:	53                   	push   %ebx
80103f73:	e8 c3 0d 00 00       	call   80104d3b <swtch>
  mycpu()->intena = intena;
80103f78:	e8 53 fb ff ff       	call   80103ad0 <mycpu>
}
80103f7d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f80:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f89:	5b                   	pop    %ebx
80103f8a:	5e                   	pop    %esi
80103f8b:	5d                   	pop    %ebp
80103f8c:	c3                   	ret
    panic("sched ptable.lock");
80103f8d:	83 ec 0c             	sub    $0xc,%esp
80103f90:	68 de 7f 10 80       	push   $0x80107fde
80103f95:	e8 d6 c4 ff ff       	call   80100470 <panic>
    panic("sched interruptible");
80103f9a:	83 ec 0c             	sub    $0xc,%esp
80103f9d:	68 0a 80 10 80       	push   $0x8010800a
80103fa2:	e8 c9 c4 ff ff       	call   80100470 <panic>
    panic("sched running");
80103fa7:	83 ec 0c             	sub    $0xc,%esp
80103faa:	68 fc 7f 10 80       	push   $0x80107ffc
80103faf:	e8 bc c4 ff ff       	call   80100470 <panic>
    panic("sched locks");
80103fb4:	83 ec 0c             	sub    $0xc,%esp
80103fb7:	68 f0 7f 10 80       	push   $0x80107ff0
80103fbc:	e8 af c4 ff ff       	call   80100470 <panic>
80103fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fcf:	90                   	nop

80103fd0 <exit>:
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	57                   	push   %edi
80103fd4:	56                   	push   %esi
80103fd5:	53                   	push   %ebx
80103fd6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103fd9:	e8 62 fb ff ff       	call   80103b40 <myproc>
  if(curproc == initproc)
80103fde:	39 05 b4 58 11 80    	cmp    %eax,0x801158b4
80103fe4:	0f 84 fd 00 00 00    	je     801040e7 <exit+0x117>
80103fea:	89 c3                	mov    %eax,%ebx
80103fec:	8d 70 2c             	lea    0x2c(%eax),%esi
80103fef:	8d 78 6c             	lea    0x6c(%eax),%edi
80103ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103ff8:	8b 06                	mov    (%esi),%eax
80103ffa:	85 c0                	test   %eax,%eax
80103ffc:	74 12                	je     80104010 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103ffe:	83 ec 0c             	sub    $0xc,%esp
80104001:	50                   	push   %eax
80104002:	e8 f9 cf ff ff       	call   80101000 <fileclose>
      curproc->ofile[fd] = 0;
80104007:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010400d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104010:	83 c6 04             	add    $0x4,%esi
80104013:	39 f7                	cmp    %esi,%edi
80104015:	75 e1                	jne    80103ff8 <exit+0x28>
  begin_op();
80104017:	e8 14 ef ff ff       	call   80102f30 <begin_op>
  iput(curproc->cwd);
8010401c:	83 ec 0c             	sub    $0xc,%esp
8010401f:	ff 73 6c             	push   0x6c(%ebx)
80104022:	e8 99 d9 ff ff       	call   801019c0 <iput>
  end_op();
80104027:	e8 74 ef ff ff       	call   80102fa0 <end_op>
  curproc->cwd = 0;
8010402c:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
80104033:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
8010403a:	e8 f1 09 00 00       	call   80104a30 <acquire>
  wakeup1(curproc->parent);
8010403f:	8b 53 18             	mov    0x18(%ebx),%edx
80104042:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104045:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
8010404a:	eb 0e                	jmp    8010405a <exit+0x8a>
8010404c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104050:	83 e8 80             	sub    $0xffffff80,%eax
80104053:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104058:	74 1c                	je     80104076 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010405a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010405e:	75 f0                	jne    80104050 <exit+0x80>
80104060:	3b 50 24             	cmp    0x24(%eax),%edx
80104063:	75 eb                	jne    80104050 <exit+0x80>
      p->state = RUNNABLE;
80104065:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010406c:	83 e8 80             	sub    $0xffffff80,%eax
8010406f:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104074:	75 e4                	jne    8010405a <exit+0x8a>
      p->parent = initproc;
80104076:	8b 0d b4 58 11 80    	mov    0x801158b4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010407c:	ba b4 38 11 80       	mov    $0x801138b4,%edx
80104081:	eb 10                	jmp    80104093 <exit+0xc3>
80104083:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104087:	90                   	nop
80104088:	83 ea 80             	sub    $0xffffff80,%edx
8010408b:	81 fa b4 58 11 80    	cmp    $0x801158b4,%edx
80104091:	74 3b                	je     801040ce <exit+0xfe>
    if(p->parent == curproc){
80104093:	39 5a 18             	cmp    %ebx,0x18(%edx)
80104096:	75 f0                	jne    80104088 <exit+0xb8>
      if(p->state == ZOMBIE)
80104098:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
      p->parent = initproc;
8010409c:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
8010409f:	75 e7                	jne    80104088 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040a1:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
801040a6:	eb 12                	jmp    801040ba <exit+0xea>
801040a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040af:	90                   	nop
801040b0:	83 e8 80             	sub    $0xffffff80,%eax
801040b3:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
801040b8:	74 ce                	je     80104088 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
801040ba:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801040be:	75 f0                	jne    801040b0 <exit+0xe0>
801040c0:	3b 48 24             	cmp    0x24(%eax),%ecx
801040c3:	75 eb                	jne    801040b0 <exit+0xe0>
      p->state = RUNNABLE;
801040c5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
801040cc:	eb e2                	jmp    801040b0 <exit+0xe0>
  curproc->state = ZOMBIE;
801040ce:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
801040d5:	e8 36 fe ff ff       	call   80103f10 <sched>
  panic("zombie exit");
801040da:	83 ec 0c             	sub    $0xc,%esp
801040dd:	68 2b 80 10 80       	push   $0x8010802b
801040e2:	e8 89 c3 ff ff       	call   80100470 <panic>
    panic("init exiting");
801040e7:	83 ec 0c             	sub    $0xc,%esp
801040ea:	68 1e 80 10 80       	push   $0x8010801e
801040ef:	e8 7c c3 ff ff       	call   80100470 <panic>
801040f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040ff:	90                   	nop

80104100 <wait>:
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	56                   	push   %esi
80104104:	53                   	push   %ebx
  pushcli();
80104105:	e8 d6 07 00 00       	call   801048e0 <pushcli>
  c = mycpu();
8010410a:	e8 c1 f9 ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
8010410f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104115:	e8 16 08 00 00       	call   80104930 <popcli>
  acquire(&ptable.lock);
8010411a:	83 ec 0c             	sub    $0xc,%esp
8010411d:	68 80 38 11 80       	push   $0x80113880
80104122:	e8 09 09 00 00       	call   80104a30 <acquire>
80104127:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010412a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010412c:	bb b4 38 11 80       	mov    $0x801138b4,%ebx
80104131:	eb 10                	jmp    80104143 <wait+0x43>
80104133:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104137:	90                   	nop
80104138:	83 eb 80             	sub    $0xffffff80,%ebx
8010413b:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
80104141:	74 1b                	je     8010415e <wait+0x5e>
      if(p->parent != curproc)
80104143:	39 73 18             	cmp    %esi,0x18(%ebx)
80104146:	75 f0                	jne    80104138 <wait+0x38>
      if(p->state == ZOMBIE){
80104148:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
8010414c:	74 62                	je     801041b0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010414e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104151:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104156:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
8010415c:	75 e5                	jne    80104143 <wait+0x43>
    if(!havekids || curproc->killed){
8010415e:	85 c0                	test   %eax,%eax
80104160:	0f 84 b0 00 00 00    	je     80104216 <wait+0x116>
80104166:	8b 46 28             	mov    0x28(%esi),%eax
80104169:	85 c0                	test   %eax,%eax
8010416b:	0f 85 a5 00 00 00    	jne    80104216 <wait+0x116>
  pushcli();
80104171:	e8 6a 07 00 00       	call   801048e0 <pushcli>
  c = mycpu();
80104176:	e8 55 f9 ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
8010417b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104181:	e8 aa 07 00 00       	call   80104930 <popcli>
  if(p == 0)
80104186:	85 db                	test   %ebx,%ebx
80104188:	0f 84 9f 00 00 00    	je     8010422d <wait+0x12d>
  p->chan = chan;
8010418e:	89 73 24             	mov    %esi,0x24(%ebx)
  p->state = SLEEPING;
80104191:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104198:	e8 73 fd ff ff       	call   80103f10 <sched>
  p->chan = 0;
8010419d:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
801041a4:	eb 84                	jmp    8010412a <wait+0x2a>
801041a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ad:	8d 76 00             	lea    0x0(%esi),%esi
        clear_zombie(p);
801041b0:	83 ec 0c             	sub    $0xc,%esp
801041b3:	53                   	push   %ebx
801041b4:	e8 67 36 00 00       	call   80107820 <clear_zombie>
        kfree(p->kstack);
801041b9:	5a                   	pop    %edx
        pid = p->pid;
801041ba:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
801041bd:	ff 73 0c             	push   0xc(%ebx)
801041c0:	e8 db e3 ff ff       	call   801025a0 <kfree>
        p->rss -= PGSIZE; // for k-stack
801041c5:	81 6b 04 00 10 00 00 	subl   $0x1000,0x4(%ebx)
        p->kstack = 0;
801041cc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm_proc(p,p->pgdir);
801041d3:	59                   	pop    %ecx
801041d4:	58                   	pop    %eax
801041d5:	ff 73 08             	push   0x8(%ebx)
801041d8:	53                   	push   %ebx
801041d9:	e8 c2 35 00 00       	call   801077a0 <freevm_proc>
        p->pid = 0;
801041de:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
801041e5:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
801041ec:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
801041f0:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
801041f7:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
801041fe:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80104205:	e8 c6 07 00 00       	call   801049d0 <release>
        return pid;
8010420a:	83 c4 10             	add    $0x10,%esp
}
8010420d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104210:	89 f0                	mov    %esi,%eax
80104212:	5b                   	pop    %ebx
80104213:	5e                   	pop    %esi
80104214:	5d                   	pop    %ebp
80104215:	c3                   	ret
      release(&ptable.lock);
80104216:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104219:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010421e:	68 80 38 11 80       	push   $0x80113880
80104223:	e8 a8 07 00 00       	call   801049d0 <release>
      return -1;
80104228:	83 c4 10             	add    $0x10,%esp
8010422b:	eb e0                	jmp    8010420d <wait+0x10d>
    panic("sleep");
8010422d:	83 ec 0c             	sub    $0xc,%esp
80104230:	68 37 80 10 80       	push   $0x80108037
80104235:	e8 36 c2 ff ff       	call   80100470 <panic>
8010423a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104240 <yield>:
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	53                   	push   %ebx
80104244:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104247:	68 80 38 11 80       	push   $0x80113880
8010424c:	e8 df 07 00 00       	call   80104a30 <acquire>
  pushcli();
80104251:	e8 8a 06 00 00       	call   801048e0 <pushcli>
  c = mycpu();
80104256:	e8 75 f8 ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
8010425b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104261:	e8 ca 06 00 00       	call   80104930 <popcli>
  myproc()->state = RUNNABLE;
80104266:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
8010426d:	e8 9e fc ff ff       	call   80103f10 <sched>
  release(&ptable.lock);
80104272:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80104279:	e8 52 07 00 00       	call   801049d0 <release>
}
8010427e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104281:	83 c4 10             	add    $0x10,%esp
80104284:	c9                   	leave
80104285:	c3                   	ret
80104286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010428d:	8d 76 00             	lea    0x0(%esi),%esi

80104290 <sleep>:
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	57                   	push   %edi
80104294:	56                   	push   %esi
80104295:	53                   	push   %ebx
80104296:	83 ec 0c             	sub    $0xc,%esp
80104299:	8b 7d 08             	mov    0x8(%ebp),%edi
8010429c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010429f:	e8 3c 06 00 00       	call   801048e0 <pushcli>
  c = mycpu();
801042a4:	e8 27 f8 ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
801042a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042af:	e8 7c 06 00 00       	call   80104930 <popcli>
  if(p == 0)
801042b4:	85 db                	test   %ebx,%ebx
801042b6:	0f 84 87 00 00 00    	je     80104343 <sleep+0xb3>
  if(lk == 0)
801042bc:	85 f6                	test   %esi,%esi
801042be:	74 76                	je     80104336 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042c0:	81 fe 80 38 11 80    	cmp    $0x80113880,%esi
801042c6:	74 50                	je     80104318 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042c8:	83 ec 0c             	sub    $0xc,%esp
801042cb:	68 80 38 11 80       	push   $0x80113880
801042d0:	e8 5b 07 00 00       	call   80104a30 <acquire>
    release(lk);
801042d5:	89 34 24             	mov    %esi,(%esp)
801042d8:	e8 f3 06 00 00       	call   801049d0 <release>
  p->chan = chan;
801042dd:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
801042e0:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801042e7:	e8 24 fc ff ff       	call   80103f10 <sched>
  p->chan = 0;
801042ec:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
801042f3:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
801042fa:	e8 d1 06 00 00       	call   801049d0 <release>
    acquire(lk);
801042ff:	89 75 08             	mov    %esi,0x8(%ebp)
80104302:	83 c4 10             	add    $0x10,%esp
}
80104305:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104308:	5b                   	pop    %ebx
80104309:	5e                   	pop    %esi
8010430a:	5f                   	pop    %edi
8010430b:	5d                   	pop    %ebp
    acquire(lk);
8010430c:	e9 1f 07 00 00       	jmp    80104a30 <acquire>
80104311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104318:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
8010431b:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104322:	e8 e9 fb ff ff       	call   80103f10 <sched>
  p->chan = 0;
80104327:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
8010432e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104331:	5b                   	pop    %ebx
80104332:	5e                   	pop    %esi
80104333:	5f                   	pop    %edi
80104334:	5d                   	pop    %ebp
80104335:	c3                   	ret
    panic("sleep without lk");
80104336:	83 ec 0c             	sub    $0xc,%esp
80104339:	68 3d 80 10 80       	push   $0x8010803d
8010433e:	e8 2d c1 ff ff       	call   80100470 <panic>
    panic("sleep");
80104343:	83 ec 0c             	sub    $0xc,%esp
80104346:	68 37 80 10 80       	push   $0x80108037
8010434b:	e8 20 c1 ff ff       	call   80100470 <panic>

80104350 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 10             	sub    $0x10,%esp
80104357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010435a:	68 80 38 11 80       	push   $0x80113880
8010435f:	e8 cc 06 00 00       	call   80104a30 <acquire>
80104364:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104367:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
8010436c:	eb 0c                	jmp    8010437a <wakeup+0x2a>
8010436e:	66 90                	xchg   %ax,%ax
80104370:	83 e8 80             	sub    $0xffffff80,%eax
80104373:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104378:	74 1c                	je     80104396 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010437a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010437e:	75 f0                	jne    80104370 <wakeup+0x20>
80104380:	3b 58 24             	cmp    0x24(%eax),%ebx
80104383:	75 eb                	jne    80104370 <wakeup+0x20>
      p->state = RUNNABLE;
80104385:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010438c:	83 e8 80             	sub    $0xffffff80,%eax
8010438f:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104394:	75 e4                	jne    8010437a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104396:	c7 45 08 80 38 11 80 	movl   $0x80113880,0x8(%ebp)
}
8010439d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043a0:	c9                   	leave
  release(&ptable.lock);
801043a1:	e9 2a 06 00 00       	jmp    801049d0 <release>
801043a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ad:	8d 76 00             	lea    0x0(%esi),%esi

801043b0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	53                   	push   %ebx
801043b4:	83 ec 10             	sub    $0x10,%esp
801043b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801043ba:	68 80 38 11 80       	push   $0x80113880
801043bf:	e8 6c 06 00 00       	call   80104a30 <acquire>
801043c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043c7:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
801043cc:	eb 0c                	jmp    801043da <kill+0x2a>
801043ce:	66 90                	xchg   %ax,%ax
801043d0:	83 e8 80             	sub    $0xffffff80,%eax
801043d3:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
801043d8:	74 36                	je     80104410 <kill+0x60>
    if(p->pid == pid){
801043da:	39 58 14             	cmp    %ebx,0x14(%eax)
801043dd:	75 f1                	jne    801043d0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043df:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
801043e3:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
801043ea:	75 07                	jne    801043f3 <kill+0x43>
        p->state = RUNNABLE;
801043ec:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
801043f3:	83 ec 0c             	sub    $0xc,%esp
801043f6:	68 80 38 11 80       	push   $0x80113880
801043fb:	e8 d0 05 00 00       	call   801049d0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104400:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104403:	83 c4 10             	add    $0x10,%esp
80104406:	31 c0                	xor    %eax,%eax
}
80104408:	c9                   	leave
80104409:	c3                   	ret
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104410:	83 ec 0c             	sub    $0xc,%esp
80104413:	68 80 38 11 80       	push   $0x80113880
80104418:	e8 b3 05 00 00       	call   801049d0 <release>
}
8010441d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104420:	83 c4 10             	add    $0x10,%esp
80104423:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104428:	c9                   	leave
80104429:	c3                   	ret
8010442a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104430 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	57                   	push   %edi
80104434:	56                   	push   %esi
80104435:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104438:	53                   	push   %ebx
80104439:	bb 24 39 11 80       	mov    $0x80113924,%ebx
8010443e:	83 ec 3c             	sub    $0x3c,%esp
80104441:	eb 24                	jmp    80104467 <procdump+0x37>
80104443:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104447:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104448:	83 ec 0c             	sub    $0xc,%esp
8010444b:	68 0b 82 10 80       	push   $0x8010820b
80104450:	e8 4b c3 ff ff       	call   801007a0 <cprintf>
80104455:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104458:	83 eb 80             	sub    $0xffffff80,%ebx
8010445b:	81 fb 24 59 11 80    	cmp    $0x80115924,%ebx
80104461:	0f 84 81 00 00 00    	je     801044e8 <procdump+0xb8>
    if(p->state == UNUSED)
80104467:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010446a:	85 c0                	test   %eax,%eax
8010446c:	74 ea                	je     80104458 <procdump+0x28>
      state = "???";
8010446e:	ba 4e 80 10 80       	mov    $0x8010804e,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104473:	83 f8 05             	cmp    $0x5,%eax
80104476:	77 11                	ja     80104489 <procdump+0x59>
80104478:	8b 14 85 60 87 10 80 	mov    -0x7fef78a0(,%eax,4),%edx
      state = "???";
8010447f:	b8 4e 80 10 80       	mov    $0x8010804e,%eax
80104484:	85 d2                	test   %edx,%edx
80104486:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104489:	53                   	push   %ebx
8010448a:	52                   	push   %edx
8010448b:	ff 73 a4             	push   -0x5c(%ebx)
8010448e:	68 52 80 10 80       	push   $0x80108052
80104493:	e8 08 c3 ff ff       	call   801007a0 <cprintf>
    if(p->state == SLEEPING){
80104498:	83 c4 10             	add    $0x10,%esp
8010449b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010449f:	75 a7                	jne    80104448 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044a1:	83 ec 08             	sub    $0x8,%esp
801044a4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801044a7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801044aa:	50                   	push   %eax
801044ab:	8b 43 b0             	mov    -0x50(%ebx),%eax
801044ae:	8b 40 0c             	mov    0xc(%eax),%eax
801044b1:	83 c0 08             	add    $0x8,%eax
801044b4:	50                   	push   %eax
801044b5:	e8 a6 03 00 00       	call   80104860 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801044ba:	83 c4 10             	add    $0x10,%esp
801044bd:	8d 76 00             	lea    0x0(%esi),%esi
801044c0:	8b 17                	mov    (%edi),%edx
801044c2:	85 d2                	test   %edx,%edx
801044c4:	74 82                	je     80104448 <procdump+0x18>
        cprintf(" %p", pc[i]);
801044c6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801044c9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801044cc:	52                   	push   %edx
801044cd:	68 81 7d 10 80       	push   $0x80107d81
801044d2:	e8 c9 c2 ff ff       	call   801007a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044d7:	83 c4 10             	add    $0x10,%esp
801044da:	39 f7                	cmp    %esi,%edi
801044dc:	75 e2                	jne    801044c0 <procdump+0x90>
801044de:	e9 65 ff ff ff       	jmp    80104448 <procdump+0x18>
801044e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e7:	90                   	nop
  }
}
801044e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044eb:	5b                   	pop    %ebx
801044ec:	5e                   	pop    %esi
801044ed:	5f                   	pop    %edi
801044ee:	5d                   	pop    %ebp
801044ef:	c3                   	ret

801044f0 <get_victim_process>:
struct proc * get_victim_process(void){
801044f0:	55                   	push   %ebp
  struct proc * p;
  uint max_rss = 0;
801044f1:	31 c9                	xor    %ecx,%ecx
  struct proc * v = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044f3:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
struct proc * get_victim_process(void){
801044f8:	89 e5                	mov    %esp,%ebp
801044fa:	53                   	push   %ebx
  struct proc * v = 0;
801044fb:	31 db                	xor    %ebx,%ebx
801044fd:	eb 0f                	jmp    8010450e <get_victim_process+0x1e>
801044ff:	90                   	nop
    // if(p->state == UNUSED)
    //   continue;
    if(p->rss > max_rss){
      max_rss = p->rss;
      v = p;
    } else if (p->rss == max_rss){
80104500:	39 ca                	cmp    %ecx,%edx
80104502:	74 2c                	je     80104530 <get_victim_process+0x40>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104504:	83 e8 80             	sub    $0xffffff80,%eax
80104507:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
8010450c:	74 15                	je     80104523 <get_victim_process+0x33>
    if(p->rss > max_rss){
8010450e:	8b 50 04             	mov    0x4(%eax),%edx
80104511:	39 d1                	cmp    %edx,%ecx
80104513:	73 eb                	jae    80104500 <get_victim_process+0x10>
      v = p;
80104515:	89 c3                	mov    %eax,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104517:	83 e8 80             	sub    $0xffffff80,%eax
      max_rss = p->rss;
8010451a:	89 d1                	mov    %edx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010451c:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104521:	75 eb                	jne    8010450e <get_victim_process+0x1e>
          v = p;
        }
      }
    }
    return v;
}
80104523:	89 d8                	mov    %ebx,%eax
80104525:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104528:	c9                   	leave
80104529:	c3                   	ret
8010452a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(v == 0){
80104530:	85 db                	test   %ebx,%ebx
80104532:	74 0c                	je     80104540 <get_victim_process+0x50>
          v = p;
80104534:	8b 53 14             	mov    0x14(%ebx),%edx
80104537:	39 50 14             	cmp    %edx,0x14(%eax)
8010453a:	0f 4c d8             	cmovl  %eax,%ebx
8010453d:	eb c5                	jmp    80104504 <get_victim_process+0x14>
8010453f:	90                   	nop
          v = p;
80104540:	89 c3                	mov    %eax,%ebx
80104542:	eb c0                	jmp    80104504 <get_victim_process+0x14>
80104544:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010454b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010454f:	90                   	nop

80104550 <get_victim_page>:
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
pte_t* get_victim_page(struct proc * v){
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	56                   	push   %esi
80104554:	8b 45 08             	mov    0x8(%ebp),%eax
80104557:	53                   	push   %ebx
  //      pte = &pgtable[j];
  //      return pte;
  //    }
  //  }
  //}
        for(int i = 0 ; i < v->sz; i+= PGSIZE){
80104558:	8b 08                	mov    (%eax),%ecx
  pde_t* pgdir = v->pgdir;
8010455a:	8b 58 08             	mov    0x8(%eax),%ebx
        for(int i = 0 ; i < v->sz; i+= PGSIZE){
8010455d:	85 c9                	test   %ecx,%ecx
8010455f:	74 43                	je     801045a4 <get_victim_page+0x54>
80104561:	31 c0                	xor    %eax,%eax
80104563:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104567:	90                   	nop
  pde = &pgdir[PDX(va)];
80104568:	89 c2                	mov    %eax,%edx
8010456a:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
8010456d:	8b 14 93             	mov    (%ebx,%edx,4),%edx
80104570:	f6 c2 01             	test   $0x1,%dl
80104573:	0f 84 7b 01 00 00    	je     801046f4 <get_victim_page.cold>
  return &pgtab[PTX(va)];
80104579:	89 c6                	mov    %eax,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010457b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80104581:	c1 ee 0a             	shr    $0xa,%esi
80104584:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010458a:	8d b4 32 00 00 00 80 	lea    -0x80000000(%edx,%esi,1),%esi
                pte = walkpgdir(pgdir, (void * ) i , 0);
                if((*pte & PTE_P) && (*pte & PTE_U) && !(*pte & PTE_A)){
80104591:	8b 16                	mov    (%esi),%edx
80104593:	83 e2 25             	and    $0x25,%edx
80104596:	83 fa 05             	cmp    $0x5,%edx
80104599:	74 0b                	je     801045a6 <get_victim_page+0x56>
        for(int i = 0 ; i < v->sz; i+= PGSIZE){
8010459b:	05 00 10 00 00       	add    $0x1000,%eax
801045a0:	39 c8                	cmp    %ecx,%eax
801045a2:	72 c4                	jb     80104568 <get_victim_page+0x18>
                        return pte;
                }
        }
  return 0;
801045a4:	31 f6                	xor    %esi,%esi
}
801045a6:	89 f0                	mov    %esi,%eax
801045a8:	5b                   	pop    %ebx
801045a9:	5e                   	pop    %esi
801045aa:	5d                   	pop    %ebp
801045ab:	c3                   	ret
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045b0 <flush_table>:

void flush_table(struct proc * p){
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	57                   	push   %edi
801045b4:	56                   	push   %esi
801045b5:	8b 75 08             	mov    0x8(%ebp),%esi
801045b8:	53                   	push   %ebx
  //      ctr = (ctr + 1) % 10;
  //    }
  //  }
  //}
        pte_t * pte;
        for(int i = 0 ; i < p->sz; i+= PGSIZE){
801045b9:	8b 06                	mov    (%esi),%eax
  pde_t * pgdir = p->pgdir;
801045bb:	8b 7e 08             	mov    0x8(%esi),%edi
        for(int i = 0 ; i < p->sz; i+= PGSIZE){
801045be:	85 c0                	test   %eax,%eax
801045c0:	0f 84 7c 00 00 00    	je     80104642 <flush_table+0x92>
801045c6:	31 c9                	xor    %ecx,%ecx
  int ctr = 0;
801045c8:	31 d2                	xor    %edx,%edx
801045ca:	eb 11                	jmp    801045dd <flush_table+0x2d>
801045cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        for(int i = 0 ; i < p->sz; i+= PGSIZE){
801045d0:	8b 45 08             	mov    0x8(%ebp),%eax
801045d3:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801045d9:	3b 08                	cmp    (%eax),%ecx
801045db:	73 65                	jae    80104642 <flush_table+0x92>
  pde = &pgdir[PDX(va)];
801045dd:	89 c8                	mov    %ecx,%eax
801045df:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801045e2:	8b 04 87             	mov    (%edi,%eax,4),%eax
801045e5:	a8 01                	test   $0x1,%al
801045e7:	0f 84 0e 01 00 00    	je     801046fb <flush_table.cold>
  return &pgtab[PTX(va)];
801045ed:	89 cb                	mov    %ecx,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801045ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801045f4:	c1 eb 0a             	shr    $0xa,%ebx
801045f7:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
801045fd:	8d 9c 18 00 00 00 80 	lea    -0x80000000(%eax,%ebx,1),%ebx
                        pte = walkpgdir(pgdir , (void *) i , 0);
                        if((*pte & PTE_P) && (*pte & PTE_U) && (*pte & PTE_A)){
80104604:	8b 03                	mov    (%ebx),%eax
80104606:	89 c6                	mov    %eax,%esi
80104608:	f7 d6                	not    %esi
8010460a:	83 e6 25             	and    $0x25,%esi
8010460d:	75 c1                	jne    801045d0 <flush_table+0x20>
                                if(ctr == 0){
8010460f:	85 d2                	test   %edx,%edx
80104611:	75 05                	jne    80104618 <flush_table+0x68>
                                        *pte &= ~PTE_A;
80104613:	83 e0 df             	and    $0xffffffdf,%eax
80104616:	89 03                	mov    %eax,(%ebx)
                                }
                                ctr = (ctr + 1) % 10;
80104618:	8d 5a 01             	lea    0x1(%edx),%ebx
8010461b:	b8 67 66 66 66       	mov    $0x66666667,%eax
        for(int i = 0 ; i < p->sz; i+= PGSIZE){
80104620:	81 c1 00 10 00 00    	add    $0x1000,%ecx
                                ctr = (ctr + 1) % 10;
80104626:	f7 eb                	imul   %ebx
80104628:	89 d8                	mov    %ebx,%eax
8010462a:	c1 f8 1f             	sar    $0x1f,%eax
8010462d:	c1 fa 02             	sar    $0x2,%edx
80104630:	29 c2                	sub    %eax,%edx
80104632:	8d 04 92             	lea    (%edx,%edx,4),%eax
80104635:	89 da                	mov    %ebx,%edx
80104637:	01 c0                	add    %eax,%eax
80104639:	29 c2                	sub    %eax,%edx
        for(int i = 0 ; i < p->sz; i+= PGSIZE){
8010463b:	8b 45 08             	mov    0x8(%ebp),%eax
8010463e:	3b 08                	cmp    (%eax),%ecx
80104640:	72 9b                	jb     801045dd <flush_table+0x2d>
                        }
                }

}
80104642:	5b                   	pop    %ebx
80104643:	5e                   	pop    %esi
80104644:	5f                   	pop    %edi
80104645:	5d                   	pop    %ebp
80104646:	c3                   	ret
80104647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010464e:	66 90                	xchg   %ax,%ax

80104650 <final_page>:

pte_t* final_page(){
80104650:	55                   	push   %ebp
  uint max_rss = 0;
80104651:	31 c9                	xor    %ecx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104653:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
pte_t* final_page(){
80104658:	89 e5                	mov    %esp,%ebp
8010465a:	53                   	push   %ebx
  struct proc * v = 0;
8010465b:	31 db                	xor    %ebx,%ebx
pte_t* final_page(){
8010465d:	83 ec 14             	sub    $0x14,%esp
80104660:	eb 12                	jmp    80104674 <final_page+0x24>
80104662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if (p->rss == max_rss){
80104668:	74 3e                	je     801046a8 <final_page+0x58>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010466a:	83 e8 80             	sub    $0xffffff80,%eax
8010466d:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104672:	74 15                	je     80104689 <final_page+0x39>
    if(p->rss > max_rss){
80104674:	8b 50 04             	mov    0x4(%eax),%edx
80104677:	39 d1                	cmp    %edx,%ecx
80104679:	73 ed                	jae    80104668 <final_page+0x18>
      v = p;
8010467b:	89 c3                	mov    %eax,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010467d:	83 e8 80             	sub    $0xffffff80,%eax
      max_rss = p->rss;
80104680:	89 d1                	mov    %edx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104682:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104687:	75 eb                	jne    80104674 <final_page+0x24>
  struct proc * v = get_victim_process();
  // cprintf("victim process is %d\n", (int) v->pid);
  v->rss -= PGSIZE;
  pte_t* pte = get_victim_page(v);
80104689:	83 ec 0c             	sub    $0xc,%esp
  v->rss -= PGSIZE;
8010468c:	81 6b 04 00 10 00 00 	subl   $0x1000,0x4(%ebx)
  pte_t* pte = get_victim_page(v);
80104693:	53                   	push   %ebx
80104694:	e8 b7 fe ff ff       	call   80104550 <get_victim_page>
80104699:	83 c4 10             	add    $0x10,%esp
  if(pte == 0){
8010469c:	85 c0                	test   %eax,%eax
8010469e:	74 24                	je     801046c4 <final_page+0x74>
    if(pte == 0){
      cprintf("Flusing again\n");
    }
  }
  return pte;
}
801046a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046a3:	c9                   	leave
801046a4:	c3                   	ret
801046a5:	8d 76 00             	lea    0x0(%esi),%esi
        if(v == 0){
801046a8:	85 db                	test   %ebx,%ebx
801046aa:	74 14                	je     801046c0 <final_page+0x70>
      v = p;
801046ac:	8b 53 14             	mov    0x14(%ebx),%edx
801046af:	39 50 14             	cmp    %edx,0x14(%eax)
801046b2:	0f 4c d8             	cmovl  %eax,%ebx
801046b5:	eb b3                	jmp    8010466a <final_page+0x1a>
801046b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046be:	66 90                	xchg   %ax,%ax
801046c0:	89 c3                	mov    %eax,%ebx
801046c2:	eb a6                	jmp    8010466a <final_page+0x1a>
    flush_table(v);
801046c4:	83 ec 0c             	sub    $0xc,%esp
801046c7:	53                   	push   %ebx
801046c8:	e8 e3 fe ff ff       	call   801045b0 <flush_table>
    pte = get_victim_page(v);
801046cd:	89 1c 24             	mov    %ebx,(%esp)
801046d0:	e8 7b fe ff ff       	call   80104550 <get_victim_page>
801046d5:	83 c4 10             	add    $0x10,%esp
    if(pte == 0){
801046d8:	85 c0                	test   %eax,%eax
801046da:	75 c4                	jne    801046a0 <final_page+0x50>
      cprintf("Flusing again\n");
801046dc:	83 ec 0c             	sub    $0xc,%esp
801046df:	89 45 f4             	mov    %eax,-0xc(%ebp)
801046e2:	68 5b 80 10 80       	push   $0x8010805b
801046e7:	e8 b4 c0 ff ff       	call   801007a0 <cprintf>
801046ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ef:	83 c4 10             	add    $0x10,%esp
801046f2:	eb ac                	jmp    801046a0 <final_page+0x50>

801046f4 <get_victim_page.cold>:
                if((*pte & PTE_P) && (*pte & PTE_U) && !(*pte & PTE_A)){
801046f4:	a1 00 00 00 00       	mov    0x0,%eax
801046f9:	0f 0b                	ud2

801046fb <flush_table.cold>:
                        if((*pte & PTE_P) && (*pte & PTE_U) && (*pte & PTE_A)){
801046fb:	a1 00 00 00 00       	mov    0x0,%eax
80104700:	0f 0b                	ud2
80104702:	66 90                	xchg   %ax,%ax
80104704:	66 90                	xchg   %ax,%ax
80104706:	66 90                	xchg   %ax,%ax
80104708:	66 90                	xchg   %ax,%ax
8010470a:	66 90                	xchg   %ax,%ax
8010470c:	66 90                	xchg   %ax,%ax
8010470e:	66 90                	xchg   %ax,%ax

80104710 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 0c             	sub    $0xc,%esp
80104717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010471a:	68 94 80 10 80       	push   $0x80108094
8010471f:	8d 43 04             	lea    0x4(%ebx),%eax
80104722:	50                   	push   %eax
80104723:	e8 18 01 00 00       	call   80104840 <initlock>
  lk->name = name;
80104728:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010472b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104731:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104734:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010473b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010473e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104741:	c9                   	leave
80104742:	c3                   	ret
80104743:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104750 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	56                   	push   %esi
80104754:	53                   	push   %ebx
80104755:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104758:	8d 73 04             	lea    0x4(%ebx),%esi
8010475b:	83 ec 0c             	sub    $0xc,%esp
8010475e:	56                   	push   %esi
8010475f:	e8 cc 02 00 00       	call   80104a30 <acquire>
  while (lk->locked) {
80104764:	8b 13                	mov    (%ebx),%edx
80104766:	83 c4 10             	add    $0x10,%esp
80104769:	85 d2                	test   %edx,%edx
8010476b:	74 16                	je     80104783 <acquiresleep+0x33>
8010476d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104770:	83 ec 08             	sub    $0x8,%esp
80104773:	56                   	push   %esi
80104774:	53                   	push   %ebx
80104775:	e8 16 fb ff ff       	call   80104290 <sleep>
  while (lk->locked) {
8010477a:	8b 03                	mov    (%ebx),%eax
8010477c:	83 c4 10             	add    $0x10,%esp
8010477f:	85 c0                	test   %eax,%eax
80104781:	75 ed                	jne    80104770 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104783:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104789:	e8 b2 f3 ff ff       	call   80103b40 <myproc>
8010478e:	8b 40 14             	mov    0x14(%eax),%eax
80104791:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104794:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104797:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010479a:	5b                   	pop    %ebx
8010479b:	5e                   	pop    %esi
8010479c:	5d                   	pop    %ebp
  release(&lk->lk);
8010479d:	e9 2e 02 00 00       	jmp    801049d0 <release>
801047a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	53                   	push   %ebx
801047b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047b8:	8d 73 04             	lea    0x4(%ebx),%esi
801047bb:	83 ec 0c             	sub    $0xc,%esp
801047be:	56                   	push   %esi
801047bf:	e8 6c 02 00 00       	call   80104a30 <acquire>
  lk->locked = 0;
801047c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801047ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801047d1:	89 1c 24             	mov    %ebx,(%esp)
801047d4:	e8 77 fb ff ff       	call   80104350 <wakeup>
  release(&lk->lk);
801047d9:	89 75 08             	mov    %esi,0x8(%ebp)
801047dc:	83 c4 10             	add    $0x10,%esp
}
801047df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047e2:	5b                   	pop    %ebx
801047e3:	5e                   	pop    %esi
801047e4:	5d                   	pop    %ebp
  release(&lk->lk);
801047e5:	e9 e6 01 00 00       	jmp    801049d0 <release>
801047ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	57                   	push   %edi
801047f4:	31 ff                	xor    %edi,%edi
801047f6:	56                   	push   %esi
801047f7:	53                   	push   %ebx
801047f8:	83 ec 18             	sub    $0x18,%esp
801047fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801047fe:	8d 73 04             	lea    0x4(%ebx),%esi
80104801:	56                   	push   %esi
80104802:	e8 29 02 00 00       	call   80104a30 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104807:	8b 03                	mov    (%ebx),%eax
80104809:	83 c4 10             	add    $0x10,%esp
8010480c:	85 c0                	test   %eax,%eax
8010480e:	75 18                	jne    80104828 <holdingsleep+0x38>
  release(&lk->lk);
80104810:	83 ec 0c             	sub    $0xc,%esp
80104813:	56                   	push   %esi
80104814:	e8 b7 01 00 00       	call   801049d0 <release>
  return r;
}
80104819:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010481c:	89 f8                	mov    %edi,%eax
8010481e:	5b                   	pop    %ebx
8010481f:	5e                   	pop    %esi
80104820:	5f                   	pop    %edi
80104821:	5d                   	pop    %ebp
80104822:	c3                   	ret
80104823:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104827:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104828:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010482b:	e8 10 f3 ff ff       	call   80103b40 <myproc>
80104830:	39 58 14             	cmp    %ebx,0x14(%eax)
80104833:	0f 94 c0             	sete   %al
80104836:	0f b6 c0             	movzbl %al,%eax
80104839:	89 c7                	mov    %eax,%edi
8010483b:	eb d3                	jmp    80104810 <holdingsleep+0x20>
8010483d:	66 90                	xchg   %ax,%ax
8010483f:	90                   	nop

80104840 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104846:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104849:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010484f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104852:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104859:	5d                   	pop    %ebp
8010485a:	c3                   	ret
8010485b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010485f:	90                   	nop

80104860 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	53                   	push   %ebx
80104864:	8b 45 08             	mov    0x8(%ebp),%eax
80104867:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010486a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010486d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104872:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104877:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010487c:	76 10                	jbe    8010488e <getcallerpcs+0x2e>
8010487e:	eb 28                	jmp    801048a8 <getcallerpcs+0x48>
80104880:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104886:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010488c:	77 1a                	ja     801048a8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010488e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104891:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104894:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104897:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104899:	83 f8 0a             	cmp    $0xa,%eax
8010489c:	75 e2                	jne    80104880 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010489e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048a1:	c9                   	leave
801048a2:	c3                   	ret
801048a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048a7:	90                   	nop
801048a8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801048ab:	83 c1 28             	add    $0x28,%ecx
801048ae:	89 ca                	mov    %ecx,%edx
801048b0:	29 c2                	sub    %eax,%edx
801048b2:	83 e2 04             	and    $0x4,%edx
801048b5:	74 11                	je     801048c8 <getcallerpcs+0x68>
    pcs[i] = 0;
801048b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801048bd:	83 c0 04             	add    $0x4,%eax
801048c0:	39 c1                	cmp    %eax,%ecx
801048c2:	74 da                	je     8010489e <getcallerpcs+0x3e>
801048c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801048c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801048ce:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801048d1:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801048d8:	39 c1                	cmp    %eax,%ecx
801048da:	75 ec                	jne    801048c8 <getcallerpcs+0x68>
801048dc:	eb c0                	jmp    8010489e <getcallerpcs+0x3e>
801048de:	66 90                	xchg   %ax,%ax

801048e0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	53                   	push   %ebx
801048e4:	83 ec 04             	sub    $0x4,%esp
801048e7:	9c                   	pushf
801048e8:	5b                   	pop    %ebx
  asm volatile("cli");
801048e9:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801048ea:	e8 e1 f1 ff ff       	call   80103ad0 <mycpu>
801048ef:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801048f5:	85 c0                	test   %eax,%eax
801048f7:	74 17                	je     80104910 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801048f9:	e8 d2 f1 ff ff       	call   80103ad0 <mycpu>
801048fe:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104905:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104908:	c9                   	leave
80104909:	c3                   	ret
8010490a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104910:	e8 bb f1 ff ff       	call   80103ad0 <mycpu>
80104915:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010491b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104921:	eb d6                	jmp    801048f9 <pushcli+0x19>
80104923:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104930 <popcli>:

void
popcli(void)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104936:	9c                   	pushf
80104937:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104938:	f6 c4 02             	test   $0x2,%ah
8010493b:	75 35                	jne    80104972 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010493d:	e8 8e f1 ff ff       	call   80103ad0 <mycpu>
80104942:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104949:	78 34                	js     8010497f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010494b:	e8 80 f1 ff ff       	call   80103ad0 <mycpu>
80104950:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104956:	85 d2                	test   %edx,%edx
80104958:	74 06                	je     80104960 <popcli+0x30>
    sti();
}
8010495a:	c9                   	leave
8010495b:	c3                   	ret
8010495c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104960:	e8 6b f1 ff ff       	call   80103ad0 <mycpu>
80104965:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010496b:	85 c0                	test   %eax,%eax
8010496d:	74 eb                	je     8010495a <popcli+0x2a>
  asm volatile("sti");
8010496f:	fb                   	sti
}
80104970:	c9                   	leave
80104971:	c3                   	ret
    panic("popcli - interruptible");
80104972:	83 ec 0c             	sub    $0xc,%esp
80104975:	68 9f 80 10 80       	push   $0x8010809f
8010497a:	e8 f1 ba ff ff       	call   80100470 <panic>
    panic("popcli");
8010497f:	83 ec 0c             	sub    $0xc,%esp
80104982:	68 b6 80 10 80       	push   $0x801080b6
80104987:	e8 e4 ba ff ff       	call   80100470 <panic>
8010498c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104990 <holding>:
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	56                   	push   %esi
80104994:	53                   	push   %ebx
80104995:	8b 75 08             	mov    0x8(%ebp),%esi
80104998:	31 db                	xor    %ebx,%ebx
  pushcli();
8010499a:	e8 41 ff ff ff       	call   801048e0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010499f:	8b 06                	mov    (%esi),%eax
801049a1:	85 c0                	test   %eax,%eax
801049a3:	75 0b                	jne    801049b0 <holding+0x20>
  popcli();
801049a5:	e8 86 ff ff ff       	call   80104930 <popcli>
}
801049aa:	89 d8                	mov    %ebx,%eax
801049ac:	5b                   	pop    %ebx
801049ad:	5e                   	pop    %esi
801049ae:	5d                   	pop    %ebp
801049af:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
801049b0:	8b 5e 08             	mov    0x8(%esi),%ebx
801049b3:	e8 18 f1 ff ff       	call   80103ad0 <mycpu>
801049b8:	39 c3                	cmp    %eax,%ebx
801049ba:	0f 94 c3             	sete   %bl
  popcli();
801049bd:	e8 6e ff ff ff       	call   80104930 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801049c2:	0f b6 db             	movzbl %bl,%ebx
}
801049c5:	89 d8                	mov    %ebx,%eax
801049c7:	5b                   	pop    %ebx
801049c8:	5e                   	pop    %esi
801049c9:	5d                   	pop    %ebp
801049ca:	c3                   	ret
801049cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049cf:	90                   	nop

801049d0 <release>:
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	53                   	push   %ebx
801049d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801049d8:	e8 03 ff ff ff       	call   801048e0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801049dd:	8b 03                	mov    (%ebx),%eax
801049df:	85 c0                	test   %eax,%eax
801049e1:	75 15                	jne    801049f8 <release+0x28>
  popcli();
801049e3:	e8 48 ff ff ff       	call   80104930 <popcli>
    panic("release");
801049e8:	83 ec 0c             	sub    $0xc,%esp
801049eb:	68 bd 80 10 80       	push   $0x801080bd
801049f0:	e8 7b ba ff ff       	call   80100470 <panic>
801049f5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801049f8:	8b 73 08             	mov    0x8(%ebx),%esi
801049fb:	e8 d0 f0 ff ff       	call   80103ad0 <mycpu>
80104a00:	39 c6                	cmp    %eax,%esi
80104a02:	75 df                	jne    801049e3 <release+0x13>
  popcli();
80104a04:	e8 27 ff ff ff       	call   80104930 <popcli>
  lk->pcs[0] = 0;
80104a09:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a10:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104a17:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a1c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a25:	5b                   	pop    %ebx
80104a26:	5e                   	pop    %esi
80104a27:	5d                   	pop    %ebp
  popcli();
80104a28:	e9 03 ff ff ff       	jmp    80104930 <popcli>
80104a2d:	8d 76 00             	lea    0x0(%esi),%esi

80104a30 <acquire>:
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	53                   	push   %ebx
80104a34:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104a37:	e8 a4 fe ff ff       	call   801048e0 <pushcli>
  if(holding(lk))
80104a3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104a3f:	e8 9c fe ff ff       	call   801048e0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a44:	8b 03                	mov    (%ebx),%eax
80104a46:	85 c0                	test   %eax,%eax
80104a48:	0f 85 b2 00 00 00    	jne    80104b00 <acquire+0xd0>
  popcli();
80104a4e:	e8 dd fe ff ff       	call   80104930 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104a53:	b9 01 00 00 00       	mov    $0x1,%ecx
80104a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a5f:	90                   	nop
  while(xchg(&lk->locked, 1) != 0)
80104a60:	8b 55 08             	mov    0x8(%ebp),%edx
80104a63:	89 c8                	mov    %ecx,%eax
80104a65:	f0 87 02             	lock xchg %eax,(%edx)
80104a68:	85 c0                	test   %eax,%eax
80104a6a:	75 f4                	jne    80104a60 <acquire+0x30>
  __sync_synchronize();
80104a6c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104a71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a74:	e8 57 f0 ff ff       	call   80103ad0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104a79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
80104a7c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
80104a7e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a81:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104a87:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80104a8c:	77 32                	ja     80104ac0 <acquire+0x90>
  ebp = (uint*)v - 2;
80104a8e:	89 e8                	mov    %ebp,%eax
80104a90:	eb 14                	jmp    80104aa6 <acquire+0x76>
80104a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a98:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a9e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104aa4:	77 1a                	ja     80104ac0 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104aa6:	8b 58 04             	mov    0x4(%eax),%ebx
80104aa9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104aad:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104ab0:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ab2:	83 fa 0a             	cmp    $0xa,%edx
80104ab5:	75 e1                	jne    80104a98 <acquire+0x68>
}
80104ab7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104aba:	c9                   	leave
80104abb:	c3                   	ret
80104abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ac0:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104ac4:	83 c1 34             	add    $0x34,%ecx
80104ac7:	89 ca                	mov    %ecx,%edx
80104ac9:	29 c2                	sub    %eax,%edx
80104acb:	83 e2 04             	and    $0x4,%edx
80104ace:	74 10                	je     80104ae0 <acquire+0xb0>
    pcs[i] = 0;
80104ad0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ad6:	83 c0 04             	add    $0x4,%eax
80104ad9:	39 c1                	cmp    %eax,%ecx
80104adb:	74 da                	je     80104ab7 <acquire+0x87>
80104add:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104ae0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ae6:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104ae9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104af0:	39 c1                	cmp    %eax,%ecx
80104af2:	75 ec                	jne    80104ae0 <acquire+0xb0>
80104af4:	eb c1                	jmp    80104ab7 <acquire+0x87>
80104af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104afd:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104b00:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104b03:	e8 c8 ef ff ff       	call   80103ad0 <mycpu>
80104b08:	39 c3                	cmp    %eax,%ebx
80104b0a:	0f 85 3e ff ff ff    	jne    80104a4e <acquire+0x1e>
  popcli();
80104b10:	e8 1b fe ff ff       	call   80104930 <popcli>
    panic("acquire");
80104b15:	83 ec 0c             	sub    $0xc,%esp
80104b18:	68 c5 80 10 80       	push   $0x801080c5
80104b1d:	e8 4e b9 ff ff       	call   80100470 <panic>
80104b22:	66 90                	xchg   %ax,%ax
80104b24:	66 90                	xchg   %ax,%ax
80104b26:	66 90                	xchg   %ax,%ax
80104b28:	66 90                	xchg   %ax,%ax
80104b2a:	66 90                	xchg   %ax,%ax
80104b2c:	66 90                	xchg   %ax,%ax
80104b2e:	66 90                	xchg   %ax,%ax

80104b30 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	57                   	push   %edi
80104b34:	8b 55 08             	mov    0x8(%ebp),%edx
80104b37:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104b3a:	89 d0                	mov    %edx,%eax
80104b3c:	09 c8                	or     %ecx,%eax
80104b3e:	a8 03                	test   $0x3,%al
80104b40:	75 1e                	jne    80104b60 <memset+0x30>
    c &= 0xFF;
80104b42:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104b46:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104b49:	89 d7                	mov    %edx,%edi
80104b4b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104b51:	fc                   	cld
80104b52:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104b54:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104b57:	89 d0                	mov    %edx,%eax
80104b59:	c9                   	leave
80104b5a:	c3                   	ret
80104b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b5f:	90                   	nop
  asm volatile("cld; rep stosb" :
80104b60:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b63:	89 d7                	mov    %edx,%edi
80104b65:	fc                   	cld
80104b66:	f3 aa                	rep stos %al,%es:(%edi)
80104b68:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104b6b:	89 d0                	mov    %edx,%eax
80104b6d:	c9                   	leave
80104b6e:	c3                   	ret
80104b6f:	90                   	nop

80104b70 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	56                   	push   %esi
80104b74:	8b 75 10             	mov    0x10(%ebp),%esi
80104b77:	8b 45 08             	mov    0x8(%ebp),%eax
80104b7a:	53                   	push   %ebx
80104b7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104b7e:	85 f6                	test   %esi,%esi
80104b80:	74 2e                	je     80104bb0 <memcmp+0x40>
80104b82:	01 c6                	add    %eax,%esi
80104b84:	eb 14                	jmp    80104b9a <memcmp+0x2a>
80104b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104b90:	83 c0 01             	add    $0x1,%eax
80104b93:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104b96:	39 f0                	cmp    %esi,%eax
80104b98:	74 16                	je     80104bb0 <memcmp+0x40>
    if(*s1 != *s2)
80104b9a:	0f b6 08             	movzbl (%eax),%ecx
80104b9d:	0f b6 1a             	movzbl (%edx),%ebx
80104ba0:	38 d9                	cmp    %bl,%cl
80104ba2:	74 ec                	je     80104b90 <memcmp+0x20>
      return *s1 - *s2;
80104ba4:	0f b6 c1             	movzbl %cl,%eax
80104ba7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104ba9:	5b                   	pop    %ebx
80104baa:	5e                   	pop    %esi
80104bab:	5d                   	pop    %ebp
80104bac:	c3                   	ret
80104bad:	8d 76 00             	lea    0x0(%esi),%esi
80104bb0:	5b                   	pop    %ebx
  return 0;
80104bb1:	31 c0                	xor    %eax,%eax
}
80104bb3:	5e                   	pop    %esi
80104bb4:	5d                   	pop    %ebp
80104bb5:	c3                   	ret
80104bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bbd:	8d 76 00             	lea    0x0(%esi),%esi

80104bc0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	57                   	push   %edi
80104bc4:	8b 55 08             	mov    0x8(%ebp),%edx
80104bc7:	8b 45 10             	mov    0x10(%ebp),%eax
80104bca:	56                   	push   %esi
80104bcb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104bce:	39 d6                	cmp    %edx,%esi
80104bd0:	73 26                	jae    80104bf8 <memmove+0x38>
80104bd2:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104bd5:	39 ca                	cmp    %ecx,%edx
80104bd7:	73 1f                	jae    80104bf8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104bd9:	85 c0                	test   %eax,%eax
80104bdb:	74 0f                	je     80104bec <memmove+0x2c>
80104bdd:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104be0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104be4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104be7:	83 e8 01             	sub    $0x1,%eax
80104bea:	73 f4                	jae    80104be0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104bec:	5e                   	pop    %esi
80104bed:	89 d0                	mov    %edx,%eax
80104bef:	5f                   	pop    %edi
80104bf0:	5d                   	pop    %ebp
80104bf1:	c3                   	ret
80104bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104bf8:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104bfb:	89 d7                	mov    %edx,%edi
80104bfd:	85 c0                	test   %eax,%eax
80104bff:	74 eb                	je     80104bec <memmove+0x2c>
80104c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104c08:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104c09:	39 ce                	cmp    %ecx,%esi
80104c0b:	75 fb                	jne    80104c08 <memmove+0x48>
}
80104c0d:	5e                   	pop    %esi
80104c0e:	89 d0                	mov    %edx,%eax
80104c10:	5f                   	pop    %edi
80104c11:	5d                   	pop    %ebp
80104c12:	c3                   	ret
80104c13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c20 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104c20:	eb 9e                	jmp    80104bc0 <memmove>
80104c22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c30 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	53                   	push   %ebx
80104c34:	8b 55 10             	mov    0x10(%ebp),%edx
80104c37:	8b 45 08             	mov    0x8(%ebp),%eax
80104c3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
80104c3d:	85 d2                	test   %edx,%edx
80104c3f:	75 16                	jne    80104c57 <strncmp+0x27>
80104c41:	eb 2d                	jmp    80104c70 <strncmp+0x40>
80104c43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c47:	90                   	nop
80104c48:	3a 19                	cmp    (%ecx),%bl
80104c4a:	75 12                	jne    80104c5e <strncmp+0x2e>
    n--, p++, q++;
80104c4c:	83 c0 01             	add    $0x1,%eax
80104c4f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104c52:	83 ea 01             	sub    $0x1,%edx
80104c55:	74 19                	je     80104c70 <strncmp+0x40>
80104c57:	0f b6 18             	movzbl (%eax),%ebx
80104c5a:	84 db                	test   %bl,%bl
80104c5c:	75 ea                	jne    80104c48 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104c5e:	0f b6 00             	movzbl (%eax),%eax
80104c61:	0f b6 11             	movzbl (%ecx),%edx
}
80104c64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c67:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104c68:	29 d0                	sub    %edx,%eax
}
80104c6a:	c3                   	ret
80104c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c6f:	90                   	nop
80104c70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104c73:	31 c0                	xor    %eax,%eax
}
80104c75:	c9                   	leave
80104c76:	c3                   	ret
80104c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7e:	66 90                	xchg   %ax,%ax

80104c80 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	57                   	push   %edi
80104c84:	56                   	push   %esi
80104c85:	8b 75 08             	mov    0x8(%ebp),%esi
80104c88:	53                   	push   %ebx
80104c89:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104c8c:	89 f0                	mov    %esi,%eax
80104c8e:	eb 15                	jmp    80104ca5 <strncpy+0x25>
80104c90:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104c94:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104c97:	83 c0 01             	add    $0x1,%eax
80104c9a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80104c9e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104ca1:	84 c9                	test   %cl,%cl
80104ca3:	74 13                	je     80104cb8 <strncpy+0x38>
80104ca5:	89 d3                	mov    %edx,%ebx
80104ca7:	83 ea 01             	sub    $0x1,%edx
80104caa:	85 db                	test   %ebx,%ebx
80104cac:	7f e2                	jg     80104c90 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104cae:	5b                   	pop    %ebx
80104caf:	89 f0                	mov    %esi,%eax
80104cb1:	5e                   	pop    %esi
80104cb2:	5f                   	pop    %edi
80104cb3:	5d                   	pop    %ebp
80104cb4:	c3                   	ret
80104cb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104cb8:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104cbb:	83 e9 01             	sub    $0x1,%ecx
80104cbe:	85 d2                	test   %edx,%edx
80104cc0:	74 ec                	je     80104cae <strncpy+0x2e>
80104cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104cc8:	83 c0 01             	add    $0x1,%eax
80104ccb:	89 ca                	mov    %ecx,%edx
80104ccd:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104cd1:	29 c2                	sub    %eax,%edx
80104cd3:	85 d2                	test   %edx,%edx
80104cd5:	7f f1                	jg     80104cc8 <strncpy+0x48>
}
80104cd7:	5b                   	pop    %ebx
80104cd8:	89 f0                	mov    %esi,%eax
80104cda:	5e                   	pop    %esi
80104cdb:	5f                   	pop    %edi
80104cdc:	5d                   	pop    %ebp
80104cdd:	c3                   	ret
80104cde:	66 90                	xchg   %ax,%ax

80104ce0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	8b 55 10             	mov    0x10(%ebp),%edx
80104ce7:	8b 75 08             	mov    0x8(%ebp),%esi
80104cea:	53                   	push   %ebx
80104ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104cee:	85 d2                	test   %edx,%edx
80104cf0:	7e 25                	jle    80104d17 <safestrcpy+0x37>
80104cf2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104cf6:	89 f2                	mov    %esi,%edx
80104cf8:	eb 16                	jmp    80104d10 <safestrcpy+0x30>
80104cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104d00:	0f b6 08             	movzbl (%eax),%ecx
80104d03:	83 c0 01             	add    $0x1,%eax
80104d06:	83 c2 01             	add    $0x1,%edx
80104d09:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d0c:	84 c9                	test   %cl,%cl
80104d0e:	74 04                	je     80104d14 <safestrcpy+0x34>
80104d10:	39 d8                	cmp    %ebx,%eax
80104d12:	75 ec                	jne    80104d00 <safestrcpy+0x20>
    ;
  *s = 0;
80104d14:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104d17:	89 f0                	mov    %esi,%eax
80104d19:	5b                   	pop    %ebx
80104d1a:	5e                   	pop    %esi
80104d1b:	5d                   	pop    %ebp
80104d1c:	c3                   	ret
80104d1d:	8d 76 00             	lea    0x0(%esi),%esi

80104d20 <strlen>:

int
strlen(const char *s)
{
80104d20:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104d21:	31 c0                	xor    %eax,%eax
{
80104d23:	89 e5                	mov    %esp,%ebp
80104d25:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104d28:	80 3a 00             	cmpb   $0x0,(%edx)
80104d2b:	74 0c                	je     80104d39 <strlen+0x19>
80104d2d:	8d 76 00             	lea    0x0(%esi),%esi
80104d30:	83 c0 01             	add    $0x1,%eax
80104d33:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104d37:	75 f7                	jne    80104d30 <strlen+0x10>
    ;
  return n;
}
80104d39:	5d                   	pop    %ebp
80104d3a:	c3                   	ret

80104d3b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104d3b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104d3f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104d43:	55                   	push   %ebp
  pushl %ebx
80104d44:	53                   	push   %ebx
  pushl %esi
80104d45:	56                   	push   %esi
  pushl %edi
80104d46:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104d47:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104d49:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104d4b:	5f                   	pop    %edi
  popl %esi
80104d4c:	5e                   	pop    %esi
  popl %ebx
80104d4d:	5b                   	pop    %ebx
  popl %ebp
80104d4e:	5d                   	pop    %ebp
  ret
80104d4f:	c3                   	ret

80104d50 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	53                   	push   %ebx
80104d54:	83 ec 04             	sub    $0x4,%esp
80104d57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104d5a:	e8 e1 ed ff ff       	call   80103b40 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d5f:	8b 00                	mov    (%eax),%eax
80104d61:	39 c3                	cmp    %eax,%ebx
80104d63:	73 1b                	jae    80104d80 <fetchint+0x30>
80104d65:	8d 53 04             	lea    0x4(%ebx),%edx
80104d68:	39 d0                	cmp    %edx,%eax
80104d6a:	72 14                	jb     80104d80 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d6f:	8b 13                	mov    (%ebx),%edx
80104d71:	89 10                	mov    %edx,(%eax)
  return 0;
80104d73:	31 c0                	xor    %eax,%eax
}
80104d75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d78:	c9                   	leave
80104d79:	c3                   	ret
80104d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104d80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d85:	eb ee                	jmp    80104d75 <fetchint+0x25>
80104d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8e:	66 90                	xchg   %ax,%ax

80104d90 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	53                   	push   %ebx
80104d94:	83 ec 04             	sub    $0x4,%esp
80104d97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104d9a:	e8 a1 ed ff ff       	call   80103b40 <myproc>

  if(addr >= curproc->sz)
80104d9f:	3b 18                	cmp    (%eax),%ebx
80104da1:	73 2d                	jae    80104dd0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104da3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104da6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104da8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104daa:	39 d3                	cmp    %edx,%ebx
80104dac:	73 22                	jae    80104dd0 <fetchstr+0x40>
80104dae:	89 d8                	mov    %ebx,%eax
80104db0:	eb 0d                	jmp    80104dbf <fetchstr+0x2f>
80104db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104db8:	83 c0 01             	add    $0x1,%eax
80104dbb:	39 d0                	cmp    %edx,%eax
80104dbd:	73 11                	jae    80104dd0 <fetchstr+0x40>
    if(*s == 0)
80104dbf:	80 38 00             	cmpb   $0x0,(%eax)
80104dc2:	75 f4                	jne    80104db8 <fetchstr+0x28>
      return s - *pp;
80104dc4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104dc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc9:	c9                   	leave
80104dca:	c3                   	ret
80104dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dcf:	90                   	nop
80104dd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104dd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dd8:	c9                   	leave
80104dd9:	c3                   	ret
80104dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104de0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	56                   	push   %esi
80104de4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104de5:	e8 56 ed ff ff       	call   80103b40 <myproc>
80104dea:	8b 55 08             	mov    0x8(%ebp),%edx
80104ded:	8b 40 1c             	mov    0x1c(%eax),%eax
80104df0:	8b 40 44             	mov    0x44(%eax),%eax
80104df3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104df6:	e8 45 ed ff ff       	call   80103b40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104dfb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dfe:	8b 00                	mov    (%eax),%eax
80104e00:	39 c6                	cmp    %eax,%esi
80104e02:	73 1c                	jae    80104e20 <argint+0x40>
80104e04:	8d 53 08             	lea    0x8(%ebx),%edx
80104e07:	39 d0                	cmp    %edx,%eax
80104e09:	72 15                	jb     80104e20 <argint+0x40>
  *ip = *(int*)(addr);
80104e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e0e:	8b 53 04             	mov    0x4(%ebx),%edx
80104e11:	89 10                	mov    %edx,(%eax)
  return 0;
80104e13:	31 c0                	xor    %eax,%eax
}
80104e15:	5b                   	pop    %ebx
80104e16:	5e                   	pop    %esi
80104e17:	5d                   	pop    %ebp
80104e18:	c3                   	ret
80104e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e25:	eb ee                	jmp    80104e15 <argint+0x35>
80104e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e2e:	66 90                	xchg   %ax,%ax

80104e30 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	57                   	push   %edi
80104e34:	56                   	push   %esi
80104e35:	53                   	push   %ebx
80104e36:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104e39:	e8 02 ed ff ff       	call   80103b40 <myproc>
80104e3e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e40:	e8 fb ec ff ff       	call   80103b40 <myproc>
80104e45:	8b 55 08             	mov    0x8(%ebp),%edx
80104e48:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e4b:	8b 40 44             	mov    0x44(%eax),%eax
80104e4e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104e51:	e8 ea ec ff ff       	call   80103b40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e56:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e59:	8b 00                	mov    (%eax),%eax
80104e5b:	39 c7                	cmp    %eax,%edi
80104e5d:	73 31                	jae    80104e90 <argptr+0x60>
80104e5f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104e62:	39 c8                	cmp    %ecx,%eax
80104e64:	72 2a                	jb     80104e90 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104e66:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104e69:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104e6c:	85 d2                	test   %edx,%edx
80104e6e:	78 20                	js     80104e90 <argptr+0x60>
80104e70:	8b 16                	mov    (%esi),%edx
80104e72:	39 d0                	cmp    %edx,%eax
80104e74:	73 1a                	jae    80104e90 <argptr+0x60>
80104e76:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104e79:	01 c3                	add    %eax,%ebx
80104e7b:	39 da                	cmp    %ebx,%edx
80104e7d:	72 11                	jb     80104e90 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e82:	89 02                	mov    %eax,(%edx)
  return 0;
80104e84:	31 c0                	xor    %eax,%eax
}
80104e86:	83 c4 0c             	add    $0xc,%esp
80104e89:	5b                   	pop    %ebx
80104e8a:	5e                   	pop    %esi
80104e8b:	5f                   	pop    %edi
80104e8c:	5d                   	pop    %ebp
80104e8d:	c3                   	ret
80104e8e:	66 90                	xchg   %ax,%ax
    return -1;
80104e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e95:	eb ef                	jmp    80104e86 <argptr+0x56>
80104e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9e:	66 90                	xchg   %ax,%ax

80104ea0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ea5:	e8 96 ec ff ff       	call   80103b40 <myproc>
80104eaa:	8b 55 08             	mov    0x8(%ebp),%edx
80104ead:	8b 40 1c             	mov    0x1c(%eax),%eax
80104eb0:	8b 40 44             	mov    0x44(%eax),%eax
80104eb3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104eb6:	e8 85 ec ff ff       	call   80103b40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ebb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ebe:	8b 00                	mov    (%eax),%eax
80104ec0:	39 c6                	cmp    %eax,%esi
80104ec2:	73 44                	jae    80104f08 <argstr+0x68>
80104ec4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ec7:	39 d0                	cmp    %edx,%eax
80104ec9:	72 3d                	jb     80104f08 <argstr+0x68>
  *ip = *(int*)(addr);
80104ecb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104ece:	e8 6d ec ff ff       	call   80103b40 <myproc>
  if(addr >= curproc->sz)
80104ed3:	3b 18                	cmp    (%eax),%ebx
80104ed5:	73 31                	jae    80104f08 <argstr+0x68>
  *pp = (char*)addr;
80104ed7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104eda:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104edc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104ede:	39 d3                	cmp    %edx,%ebx
80104ee0:	73 26                	jae    80104f08 <argstr+0x68>
80104ee2:	89 d8                	mov    %ebx,%eax
80104ee4:	eb 11                	jmp    80104ef7 <argstr+0x57>
80104ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eed:	8d 76 00             	lea    0x0(%esi),%esi
80104ef0:	83 c0 01             	add    $0x1,%eax
80104ef3:	39 d0                	cmp    %edx,%eax
80104ef5:	73 11                	jae    80104f08 <argstr+0x68>
    if(*s == 0)
80104ef7:	80 38 00             	cmpb   $0x0,(%eax)
80104efa:	75 f4                	jne    80104ef0 <argstr+0x50>
      return s - *pp;
80104efc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104efe:	5b                   	pop    %ebx
80104eff:	5e                   	pop    %esi
80104f00:	5d                   	pop    %ebp
80104f01:	c3                   	ret
80104f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f08:	5b                   	pop    %ebx
    return -1;
80104f09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f0e:	5e                   	pop    %esi
80104f0f:	5d                   	pop    %ebp
80104f10:	c3                   	ret
80104f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f1f:	90                   	nop

80104f20 <syscall>:
[SYS_getNumFreePages]   sys_getNumFreePages,
};

void
syscall(void)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	53                   	push   %ebx
80104f24:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104f27:	e8 14 ec ff ff       	call   80103b40 <myproc>
80104f2c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f2e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104f31:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f34:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f37:	83 fa 16             	cmp    $0x16,%edx
80104f3a:	77 24                	ja     80104f60 <syscall+0x40>
80104f3c:	8b 14 85 80 87 10 80 	mov    -0x7fef7880(,%eax,4),%edx
80104f43:	85 d2                	test   %edx,%edx
80104f45:	74 19                	je     80104f60 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104f47:	ff d2                	call   *%edx
80104f49:	89 c2                	mov    %eax,%edx
80104f4b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104f4e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104f51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f54:	c9                   	leave
80104f55:	c3                   	ret
80104f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104f60:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104f61:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104f64:	50                   	push   %eax
80104f65:	ff 73 14             	push   0x14(%ebx)
80104f68:	68 cd 80 10 80       	push   $0x801080cd
80104f6d:	e8 2e b8 ff ff       	call   801007a0 <cprintf>
    curproc->tf->eax = -1;
80104f72:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104f75:	83 c4 10             	add    $0x10,%esp
80104f78:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104f7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f82:	c9                   	leave
80104f83:	c3                   	ret
80104f84:	66 90                	xchg   %ax,%ax
80104f86:	66 90                	xchg   %ax,%ax
80104f88:	66 90                	xchg   %ax,%ax
80104f8a:	66 90                	xchg   %ax,%ax
80104f8c:	66 90                	xchg   %ax,%ax
80104f8e:	66 90                	xchg   %ax,%ax

80104f90 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	57                   	push   %edi
80104f94:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104f95:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104f98:	53                   	push   %ebx
80104f99:	83 ec 34             	sub    $0x34,%esp
80104f9c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104f9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104fa2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104fa5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104fa8:	57                   	push   %edi
80104fa9:	50                   	push   %eax
80104faa:	e8 e1 d1 ff ff       	call   80102190 <nameiparent>
80104faf:	83 c4 10             	add    $0x10,%esp
80104fb2:	85 c0                	test   %eax,%eax
80104fb4:	74 5e                	je     80105014 <create+0x84>
    return 0;
  ilock(dp);
80104fb6:	83 ec 0c             	sub    $0xc,%esp
80104fb9:	89 c3                	mov    %eax,%ebx
80104fbb:	50                   	push   %eax
80104fbc:	e8 cf c8 ff ff       	call   80101890 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104fc1:	83 c4 0c             	add    $0xc,%esp
80104fc4:	6a 00                	push   $0x0
80104fc6:	57                   	push   %edi
80104fc7:	53                   	push   %ebx
80104fc8:	e8 13 ce ff ff       	call   80101de0 <dirlookup>
80104fcd:	83 c4 10             	add    $0x10,%esp
80104fd0:	89 c6                	mov    %eax,%esi
80104fd2:	85 c0                	test   %eax,%eax
80104fd4:	74 4a                	je     80105020 <create+0x90>
    iunlockput(dp);
80104fd6:	83 ec 0c             	sub    $0xc,%esp
80104fd9:	53                   	push   %ebx
80104fda:	e8 41 cb ff ff       	call   80101b20 <iunlockput>
    ilock(ip);
80104fdf:	89 34 24             	mov    %esi,(%esp)
80104fe2:	e8 a9 c8 ff ff       	call   80101890 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104fe7:	83 c4 10             	add    $0x10,%esp
80104fea:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104fef:	75 17                	jne    80105008 <create+0x78>
80104ff1:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104ff6:	75 10                	jne    80105008 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ff8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ffb:	89 f0                	mov    %esi,%eax
80104ffd:	5b                   	pop    %ebx
80104ffe:	5e                   	pop    %esi
80104fff:	5f                   	pop    %edi
80105000:	5d                   	pop    %ebp
80105001:	c3                   	ret
80105002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105008:	83 ec 0c             	sub    $0xc,%esp
8010500b:	56                   	push   %esi
8010500c:	e8 0f cb ff ff       	call   80101b20 <iunlockput>
    return 0;
80105011:	83 c4 10             	add    $0x10,%esp
}
80105014:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105017:	31 f6                	xor    %esi,%esi
}
80105019:	5b                   	pop    %ebx
8010501a:	89 f0                	mov    %esi,%eax
8010501c:	5e                   	pop    %esi
8010501d:	5f                   	pop    %edi
8010501e:	5d                   	pop    %ebp
8010501f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80105020:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105024:	83 ec 08             	sub    $0x8,%esp
80105027:	50                   	push   %eax
80105028:	ff 33                	push   (%ebx)
8010502a:	e8 f1 c6 ff ff       	call   80101720 <ialloc>
8010502f:	83 c4 10             	add    $0x10,%esp
80105032:	89 c6                	mov    %eax,%esi
80105034:	85 c0                	test   %eax,%eax
80105036:	0f 84 bc 00 00 00    	je     801050f8 <create+0x168>
  ilock(ip);
8010503c:	83 ec 0c             	sub    $0xc,%esp
8010503f:	50                   	push   %eax
80105040:	e8 4b c8 ff ff       	call   80101890 <ilock>
  ip->major = major;
80105045:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105049:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010504d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105051:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105055:	b8 01 00 00 00       	mov    $0x1,%eax
8010505a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010505e:	89 34 24             	mov    %esi,(%esp)
80105061:	e8 7a c7 ff ff       	call   801017e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105066:	83 c4 10             	add    $0x10,%esp
80105069:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010506e:	74 30                	je     801050a0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80105070:	83 ec 04             	sub    $0x4,%esp
80105073:	ff 76 04             	push   0x4(%esi)
80105076:	57                   	push   %edi
80105077:	53                   	push   %ebx
80105078:	e8 33 d0 ff ff       	call   801020b0 <dirlink>
8010507d:	83 c4 10             	add    $0x10,%esp
80105080:	85 c0                	test   %eax,%eax
80105082:	78 67                	js     801050eb <create+0x15b>
  iunlockput(dp);
80105084:	83 ec 0c             	sub    $0xc,%esp
80105087:	53                   	push   %ebx
80105088:	e8 93 ca ff ff       	call   80101b20 <iunlockput>
  return ip;
8010508d:	83 c4 10             	add    $0x10,%esp
}
80105090:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105093:	89 f0                	mov    %esi,%eax
80105095:	5b                   	pop    %ebx
80105096:	5e                   	pop    %esi
80105097:	5f                   	pop    %edi
80105098:	5d                   	pop    %ebp
80105099:	c3                   	ret
8010509a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801050a0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801050a3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801050a8:	53                   	push   %ebx
801050a9:	e8 32 c7 ff ff       	call   801017e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801050ae:	83 c4 0c             	add    $0xc,%esp
801050b1:	ff 76 04             	push   0x4(%esi)
801050b4:	68 05 81 10 80       	push   $0x80108105
801050b9:	56                   	push   %esi
801050ba:	e8 f1 cf ff ff       	call   801020b0 <dirlink>
801050bf:	83 c4 10             	add    $0x10,%esp
801050c2:	85 c0                	test   %eax,%eax
801050c4:	78 18                	js     801050de <create+0x14e>
801050c6:	83 ec 04             	sub    $0x4,%esp
801050c9:	ff 73 04             	push   0x4(%ebx)
801050cc:	68 04 81 10 80       	push   $0x80108104
801050d1:	56                   	push   %esi
801050d2:	e8 d9 cf ff ff       	call   801020b0 <dirlink>
801050d7:	83 c4 10             	add    $0x10,%esp
801050da:	85 c0                	test   %eax,%eax
801050dc:	79 92                	jns    80105070 <create+0xe0>
      panic("create dots");
801050de:	83 ec 0c             	sub    $0xc,%esp
801050e1:	68 f8 80 10 80       	push   $0x801080f8
801050e6:	e8 85 b3 ff ff       	call   80100470 <panic>
    panic("create: dirlink");
801050eb:	83 ec 0c             	sub    $0xc,%esp
801050ee:	68 07 81 10 80       	push   $0x80108107
801050f3:	e8 78 b3 ff ff       	call   80100470 <panic>
    panic("create: ialloc");
801050f8:	83 ec 0c             	sub    $0xc,%esp
801050fb:	68 e9 80 10 80       	push   $0x801080e9
80105100:	e8 6b b3 ff ff       	call   80100470 <panic>
80105105:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010510c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105110 <sys_dup>:
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	56                   	push   %esi
80105114:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105115:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105118:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010511b:	50                   	push   %eax
8010511c:	6a 00                	push   $0x0
8010511e:	e8 bd fc ff ff       	call   80104de0 <argint>
80105123:	83 c4 10             	add    $0x10,%esp
80105126:	85 c0                	test   %eax,%eax
80105128:	78 36                	js     80105160 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010512a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010512e:	77 30                	ja     80105160 <sys_dup+0x50>
80105130:	e8 0b ea ff ff       	call   80103b40 <myproc>
80105135:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105138:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010513c:	85 f6                	test   %esi,%esi
8010513e:	74 20                	je     80105160 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105140:	e8 fb e9 ff ff       	call   80103b40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105145:	31 db                	xor    %ebx,%ebx
80105147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010514e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105150:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105154:	85 d2                	test   %edx,%edx
80105156:	74 18                	je     80105170 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105158:	83 c3 01             	add    $0x1,%ebx
8010515b:	83 fb 10             	cmp    $0x10,%ebx
8010515e:	75 f0                	jne    80105150 <sys_dup+0x40>
}
80105160:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105163:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105168:	89 d8                	mov    %ebx,%eax
8010516a:	5b                   	pop    %ebx
8010516b:	5e                   	pop    %esi
8010516c:	5d                   	pop    %ebp
8010516d:	c3                   	ret
8010516e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105170:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105173:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
80105177:	56                   	push   %esi
80105178:	e8 33 be ff ff       	call   80100fb0 <filedup>
  return fd;
8010517d:	83 c4 10             	add    $0x10,%esp
}
80105180:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105183:	89 d8                	mov    %ebx,%eax
80105185:	5b                   	pop    %ebx
80105186:	5e                   	pop    %esi
80105187:	5d                   	pop    %ebp
80105188:	c3                   	ret
80105189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105190 <sys_read>:
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	56                   	push   %esi
80105194:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105195:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105198:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010519b:	53                   	push   %ebx
8010519c:	6a 00                	push   $0x0
8010519e:	e8 3d fc ff ff       	call   80104de0 <argint>
801051a3:	83 c4 10             	add    $0x10,%esp
801051a6:	85 c0                	test   %eax,%eax
801051a8:	78 5e                	js     80105208 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051ae:	77 58                	ja     80105208 <sys_read+0x78>
801051b0:	e8 8b e9 ff ff       	call   80103b40 <myproc>
801051b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051b8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
801051bc:	85 f6                	test   %esi,%esi
801051be:	74 48                	je     80105208 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051c0:	83 ec 08             	sub    $0x8,%esp
801051c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051c6:	50                   	push   %eax
801051c7:	6a 02                	push   $0x2
801051c9:	e8 12 fc ff ff       	call   80104de0 <argint>
801051ce:	83 c4 10             	add    $0x10,%esp
801051d1:	85 c0                	test   %eax,%eax
801051d3:	78 33                	js     80105208 <sys_read+0x78>
801051d5:	83 ec 04             	sub    $0x4,%esp
801051d8:	ff 75 f0             	push   -0x10(%ebp)
801051db:	53                   	push   %ebx
801051dc:	6a 01                	push   $0x1
801051de:	e8 4d fc ff ff       	call   80104e30 <argptr>
801051e3:	83 c4 10             	add    $0x10,%esp
801051e6:	85 c0                	test   %eax,%eax
801051e8:	78 1e                	js     80105208 <sys_read+0x78>
  return fileread(f, p, n);
801051ea:	83 ec 04             	sub    $0x4,%esp
801051ed:	ff 75 f0             	push   -0x10(%ebp)
801051f0:	ff 75 f4             	push   -0xc(%ebp)
801051f3:	56                   	push   %esi
801051f4:	e8 37 bf ff ff       	call   80101130 <fileread>
801051f9:	83 c4 10             	add    $0x10,%esp
}
801051fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051ff:	5b                   	pop    %ebx
80105200:	5e                   	pop    %esi
80105201:	5d                   	pop    %ebp
80105202:	c3                   	ret
80105203:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105207:	90                   	nop
    return -1;
80105208:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010520d:	eb ed                	jmp    801051fc <sys_read+0x6c>
8010520f:	90                   	nop

80105210 <sys_write>:
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	56                   	push   %esi
80105214:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105215:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105218:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010521b:	53                   	push   %ebx
8010521c:	6a 00                	push   $0x0
8010521e:	e8 bd fb ff ff       	call   80104de0 <argint>
80105223:	83 c4 10             	add    $0x10,%esp
80105226:	85 c0                	test   %eax,%eax
80105228:	78 5e                	js     80105288 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010522a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010522e:	77 58                	ja     80105288 <sys_write+0x78>
80105230:	e8 0b e9 ff ff       	call   80103b40 <myproc>
80105235:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105238:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010523c:	85 f6                	test   %esi,%esi
8010523e:	74 48                	je     80105288 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105240:	83 ec 08             	sub    $0x8,%esp
80105243:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105246:	50                   	push   %eax
80105247:	6a 02                	push   $0x2
80105249:	e8 92 fb ff ff       	call   80104de0 <argint>
8010524e:	83 c4 10             	add    $0x10,%esp
80105251:	85 c0                	test   %eax,%eax
80105253:	78 33                	js     80105288 <sys_write+0x78>
80105255:	83 ec 04             	sub    $0x4,%esp
80105258:	ff 75 f0             	push   -0x10(%ebp)
8010525b:	53                   	push   %ebx
8010525c:	6a 01                	push   $0x1
8010525e:	e8 cd fb ff ff       	call   80104e30 <argptr>
80105263:	83 c4 10             	add    $0x10,%esp
80105266:	85 c0                	test   %eax,%eax
80105268:	78 1e                	js     80105288 <sys_write+0x78>
  return filewrite(f, p, n);
8010526a:	83 ec 04             	sub    $0x4,%esp
8010526d:	ff 75 f0             	push   -0x10(%ebp)
80105270:	ff 75 f4             	push   -0xc(%ebp)
80105273:	56                   	push   %esi
80105274:	e8 47 bf ff ff       	call   801011c0 <filewrite>
80105279:	83 c4 10             	add    $0x10,%esp
}
8010527c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010527f:	5b                   	pop    %ebx
80105280:	5e                   	pop    %esi
80105281:	5d                   	pop    %ebp
80105282:	c3                   	ret
80105283:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105287:	90                   	nop
    return -1;
80105288:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010528d:	eb ed                	jmp    8010527c <sys_write+0x6c>
8010528f:	90                   	nop

80105290 <sys_close>:
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	56                   	push   %esi
80105294:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105295:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105298:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010529b:	50                   	push   %eax
8010529c:	6a 00                	push   $0x0
8010529e:	e8 3d fb ff ff       	call   80104de0 <argint>
801052a3:	83 c4 10             	add    $0x10,%esp
801052a6:	85 c0                	test   %eax,%eax
801052a8:	78 3e                	js     801052e8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801052aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052ae:	77 38                	ja     801052e8 <sys_close+0x58>
801052b0:	e8 8b e8 ff ff       	call   80103b40 <myproc>
801052b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052b8:	8d 5a 08             	lea    0x8(%edx),%ebx
801052bb:	8b 74 98 0c          	mov    0xc(%eax,%ebx,4),%esi
801052bf:	85 f6                	test   %esi,%esi
801052c1:	74 25                	je     801052e8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801052c3:	e8 78 e8 ff ff       	call   80103b40 <myproc>
  fileclose(f);
801052c8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801052cb:	c7 44 98 0c 00 00 00 	movl   $0x0,0xc(%eax,%ebx,4)
801052d2:	00 
  fileclose(f);
801052d3:	56                   	push   %esi
801052d4:	e8 27 bd ff ff       	call   80101000 <fileclose>
  return 0;
801052d9:	83 c4 10             	add    $0x10,%esp
801052dc:	31 c0                	xor    %eax,%eax
}
801052de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052e1:	5b                   	pop    %ebx
801052e2:	5e                   	pop    %esi
801052e3:	5d                   	pop    %ebp
801052e4:	c3                   	ret
801052e5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ed:	eb ef                	jmp    801052de <sys_close+0x4e>
801052ef:	90                   	nop

801052f0 <sys_fstat>:
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	56                   	push   %esi
801052f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801052f5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801052f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801052fb:	53                   	push   %ebx
801052fc:	6a 00                	push   $0x0
801052fe:	e8 dd fa ff ff       	call   80104de0 <argint>
80105303:	83 c4 10             	add    $0x10,%esp
80105306:	85 c0                	test   %eax,%eax
80105308:	78 46                	js     80105350 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010530a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010530e:	77 40                	ja     80105350 <sys_fstat+0x60>
80105310:	e8 2b e8 ff ff       	call   80103b40 <myproc>
80105315:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105318:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010531c:	85 f6                	test   %esi,%esi
8010531e:	74 30                	je     80105350 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105320:	83 ec 04             	sub    $0x4,%esp
80105323:	6a 14                	push   $0x14
80105325:	53                   	push   %ebx
80105326:	6a 01                	push   $0x1
80105328:	e8 03 fb ff ff       	call   80104e30 <argptr>
8010532d:	83 c4 10             	add    $0x10,%esp
80105330:	85 c0                	test   %eax,%eax
80105332:	78 1c                	js     80105350 <sys_fstat+0x60>
  return filestat(f, st);
80105334:	83 ec 08             	sub    $0x8,%esp
80105337:	ff 75 f4             	push   -0xc(%ebp)
8010533a:	56                   	push   %esi
8010533b:	e8 a0 bd ff ff       	call   801010e0 <filestat>
80105340:	83 c4 10             	add    $0x10,%esp
}
80105343:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105346:	5b                   	pop    %ebx
80105347:	5e                   	pop    %esi
80105348:	5d                   	pop    %ebp
80105349:	c3                   	ret
8010534a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105350:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105355:	eb ec                	jmp    80105343 <sys_fstat+0x53>
80105357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010535e:	66 90                	xchg   %ax,%ax

80105360 <sys_link>:
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105365:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105368:	53                   	push   %ebx
80105369:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010536c:	50                   	push   %eax
8010536d:	6a 00                	push   $0x0
8010536f:	e8 2c fb ff ff       	call   80104ea0 <argstr>
80105374:	83 c4 10             	add    $0x10,%esp
80105377:	85 c0                	test   %eax,%eax
80105379:	0f 88 fb 00 00 00    	js     8010547a <sys_link+0x11a>
8010537f:	83 ec 08             	sub    $0x8,%esp
80105382:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105385:	50                   	push   %eax
80105386:	6a 01                	push   $0x1
80105388:	e8 13 fb ff ff       	call   80104ea0 <argstr>
8010538d:	83 c4 10             	add    $0x10,%esp
80105390:	85 c0                	test   %eax,%eax
80105392:	0f 88 e2 00 00 00    	js     8010547a <sys_link+0x11a>
  begin_op();
80105398:	e8 93 db ff ff       	call   80102f30 <begin_op>
  if((ip = namei(old)) == 0){
8010539d:	83 ec 0c             	sub    $0xc,%esp
801053a0:	ff 75 d4             	push   -0x2c(%ebp)
801053a3:	e8 c8 cd ff ff       	call   80102170 <namei>
801053a8:	83 c4 10             	add    $0x10,%esp
801053ab:	89 c3                	mov    %eax,%ebx
801053ad:	85 c0                	test   %eax,%eax
801053af:	0f 84 df 00 00 00    	je     80105494 <sys_link+0x134>
  ilock(ip);
801053b5:	83 ec 0c             	sub    $0xc,%esp
801053b8:	50                   	push   %eax
801053b9:	e8 d2 c4 ff ff       	call   80101890 <ilock>
  if(ip->type == T_DIR){
801053be:	83 c4 10             	add    $0x10,%esp
801053c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053c6:	0f 84 b5 00 00 00    	je     80105481 <sys_link+0x121>
  iupdate(ip);
801053cc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801053cf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801053d4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801053d7:	53                   	push   %ebx
801053d8:	e8 03 c4 ff ff       	call   801017e0 <iupdate>
  iunlock(ip);
801053dd:	89 1c 24             	mov    %ebx,(%esp)
801053e0:	e8 8b c5 ff ff       	call   80101970 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801053e5:	58                   	pop    %eax
801053e6:	5a                   	pop    %edx
801053e7:	57                   	push   %edi
801053e8:	ff 75 d0             	push   -0x30(%ebp)
801053eb:	e8 a0 cd ff ff       	call   80102190 <nameiparent>
801053f0:	83 c4 10             	add    $0x10,%esp
801053f3:	89 c6                	mov    %eax,%esi
801053f5:	85 c0                	test   %eax,%eax
801053f7:	74 5b                	je     80105454 <sys_link+0xf4>
  ilock(dp);
801053f9:	83 ec 0c             	sub    $0xc,%esp
801053fc:	50                   	push   %eax
801053fd:	e8 8e c4 ff ff       	call   80101890 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105402:	8b 03                	mov    (%ebx),%eax
80105404:	83 c4 10             	add    $0x10,%esp
80105407:	39 06                	cmp    %eax,(%esi)
80105409:	75 3d                	jne    80105448 <sys_link+0xe8>
8010540b:	83 ec 04             	sub    $0x4,%esp
8010540e:	ff 73 04             	push   0x4(%ebx)
80105411:	57                   	push   %edi
80105412:	56                   	push   %esi
80105413:	e8 98 cc ff ff       	call   801020b0 <dirlink>
80105418:	83 c4 10             	add    $0x10,%esp
8010541b:	85 c0                	test   %eax,%eax
8010541d:	78 29                	js     80105448 <sys_link+0xe8>
  iunlockput(dp);
8010541f:	83 ec 0c             	sub    $0xc,%esp
80105422:	56                   	push   %esi
80105423:	e8 f8 c6 ff ff       	call   80101b20 <iunlockput>
  iput(ip);
80105428:	89 1c 24             	mov    %ebx,(%esp)
8010542b:	e8 90 c5 ff ff       	call   801019c0 <iput>
  end_op();
80105430:	e8 6b db ff ff       	call   80102fa0 <end_op>
  return 0;
80105435:	83 c4 10             	add    $0x10,%esp
80105438:	31 c0                	xor    %eax,%eax
}
8010543a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010543d:	5b                   	pop    %ebx
8010543e:	5e                   	pop    %esi
8010543f:	5f                   	pop    %edi
80105440:	5d                   	pop    %ebp
80105441:	c3                   	ret
80105442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105448:	83 ec 0c             	sub    $0xc,%esp
8010544b:	56                   	push   %esi
8010544c:	e8 cf c6 ff ff       	call   80101b20 <iunlockput>
    goto bad;
80105451:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105454:	83 ec 0c             	sub    $0xc,%esp
80105457:	53                   	push   %ebx
80105458:	e8 33 c4 ff ff       	call   80101890 <ilock>
  ip->nlink--;
8010545d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105462:	89 1c 24             	mov    %ebx,(%esp)
80105465:	e8 76 c3 ff ff       	call   801017e0 <iupdate>
  iunlockput(ip);
8010546a:	89 1c 24             	mov    %ebx,(%esp)
8010546d:	e8 ae c6 ff ff       	call   80101b20 <iunlockput>
  end_op();
80105472:	e8 29 db ff ff       	call   80102fa0 <end_op>
  return -1;
80105477:	83 c4 10             	add    $0x10,%esp
    return -1;
8010547a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010547f:	eb b9                	jmp    8010543a <sys_link+0xda>
    iunlockput(ip);
80105481:	83 ec 0c             	sub    $0xc,%esp
80105484:	53                   	push   %ebx
80105485:	e8 96 c6 ff ff       	call   80101b20 <iunlockput>
    end_op();
8010548a:	e8 11 db ff ff       	call   80102fa0 <end_op>
    return -1;
8010548f:	83 c4 10             	add    $0x10,%esp
80105492:	eb e6                	jmp    8010547a <sys_link+0x11a>
    end_op();
80105494:	e8 07 db ff ff       	call   80102fa0 <end_op>
    return -1;
80105499:	eb df                	jmp    8010547a <sys_link+0x11a>
8010549b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010549f:	90                   	nop

801054a0 <sys_unlink>:
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	57                   	push   %edi
801054a4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801054a5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801054a8:	53                   	push   %ebx
801054a9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801054ac:	50                   	push   %eax
801054ad:	6a 00                	push   $0x0
801054af:	e8 ec f9 ff ff       	call   80104ea0 <argstr>
801054b4:	83 c4 10             	add    $0x10,%esp
801054b7:	85 c0                	test   %eax,%eax
801054b9:	0f 88 54 01 00 00    	js     80105613 <sys_unlink+0x173>
  begin_op();
801054bf:	e8 6c da ff ff       	call   80102f30 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801054c4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801054c7:	83 ec 08             	sub    $0x8,%esp
801054ca:	53                   	push   %ebx
801054cb:	ff 75 c0             	push   -0x40(%ebp)
801054ce:	e8 bd cc ff ff       	call   80102190 <nameiparent>
801054d3:	83 c4 10             	add    $0x10,%esp
801054d6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801054d9:	85 c0                	test   %eax,%eax
801054db:	0f 84 58 01 00 00    	je     80105639 <sys_unlink+0x199>
  ilock(dp);
801054e1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801054e4:	83 ec 0c             	sub    $0xc,%esp
801054e7:	57                   	push   %edi
801054e8:	e8 a3 c3 ff ff       	call   80101890 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801054ed:	58                   	pop    %eax
801054ee:	5a                   	pop    %edx
801054ef:	68 05 81 10 80       	push   $0x80108105
801054f4:	53                   	push   %ebx
801054f5:	e8 c6 c8 ff ff       	call   80101dc0 <namecmp>
801054fa:	83 c4 10             	add    $0x10,%esp
801054fd:	85 c0                	test   %eax,%eax
801054ff:	0f 84 fb 00 00 00    	je     80105600 <sys_unlink+0x160>
80105505:	83 ec 08             	sub    $0x8,%esp
80105508:	68 04 81 10 80       	push   $0x80108104
8010550d:	53                   	push   %ebx
8010550e:	e8 ad c8 ff ff       	call   80101dc0 <namecmp>
80105513:	83 c4 10             	add    $0x10,%esp
80105516:	85 c0                	test   %eax,%eax
80105518:	0f 84 e2 00 00 00    	je     80105600 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010551e:	83 ec 04             	sub    $0x4,%esp
80105521:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105524:	50                   	push   %eax
80105525:	53                   	push   %ebx
80105526:	57                   	push   %edi
80105527:	e8 b4 c8 ff ff       	call   80101de0 <dirlookup>
8010552c:	83 c4 10             	add    $0x10,%esp
8010552f:	89 c3                	mov    %eax,%ebx
80105531:	85 c0                	test   %eax,%eax
80105533:	0f 84 c7 00 00 00    	je     80105600 <sys_unlink+0x160>
  ilock(ip);
80105539:	83 ec 0c             	sub    $0xc,%esp
8010553c:	50                   	push   %eax
8010553d:	e8 4e c3 ff ff       	call   80101890 <ilock>
  if(ip->nlink < 1)
80105542:	83 c4 10             	add    $0x10,%esp
80105545:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010554a:	0f 8e 0a 01 00 00    	jle    8010565a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105550:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105555:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105558:	74 66                	je     801055c0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010555a:	83 ec 04             	sub    $0x4,%esp
8010555d:	6a 10                	push   $0x10
8010555f:	6a 00                	push   $0x0
80105561:	57                   	push   %edi
80105562:	e8 c9 f5 ff ff       	call   80104b30 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105567:	6a 10                	push   $0x10
80105569:	ff 75 c4             	push   -0x3c(%ebp)
8010556c:	57                   	push   %edi
8010556d:	ff 75 b4             	push   -0x4c(%ebp)
80105570:	e8 2b c7 ff ff       	call   80101ca0 <writei>
80105575:	83 c4 20             	add    $0x20,%esp
80105578:	83 f8 10             	cmp    $0x10,%eax
8010557b:	0f 85 cc 00 00 00    	jne    8010564d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105581:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105586:	0f 84 94 00 00 00    	je     80105620 <sys_unlink+0x180>
  iunlockput(dp);
8010558c:	83 ec 0c             	sub    $0xc,%esp
8010558f:	ff 75 b4             	push   -0x4c(%ebp)
80105592:	e8 89 c5 ff ff       	call   80101b20 <iunlockput>
  ip->nlink--;
80105597:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010559c:	89 1c 24             	mov    %ebx,(%esp)
8010559f:	e8 3c c2 ff ff       	call   801017e0 <iupdate>
  iunlockput(ip);
801055a4:	89 1c 24             	mov    %ebx,(%esp)
801055a7:	e8 74 c5 ff ff       	call   80101b20 <iunlockput>
  end_op();
801055ac:	e8 ef d9 ff ff       	call   80102fa0 <end_op>
  return 0;
801055b1:	83 c4 10             	add    $0x10,%esp
801055b4:	31 c0                	xor    %eax,%eax
}
801055b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055b9:	5b                   	pop    %ebx
801055ba:	5e                   	pop    %esi
801055bb:	5f                   	pop    %edi
801055bc:	5d                   	pop    %ebp
801055bd:	c3                   	ret
801055be:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801055c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801055c4:	76 94                	jbe    8010555a <sys_unlink+0xba>
801055c6:	be 20 00 00 00       	mov    $0x20,%esi
801055cb:	eb 0b                	jmp    801055d8 <sys_unlink+0x138>
801055cd:	8d 76 00             	lea    0x0(%esi),%esi
801055d0:	83 c6 10             	add    $0x10,%esi
801055d3:	3b 73 58             	cmp    0x58(%ebx),%esi
801055d6:	73 82                	jae    8010555a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055d8:	6a 10                	push   $0x10
801055da:	56                   	push   %esi
801055db:	57                   	push   %edi
801055dc:	53                   	push   %ebx
801055dd:	e8 be c5 ff ff       	call   80101ba0 <readi>
801055e2:	83 c4 10             	add    $0x10,%esp
801055e5:	83 f8 10             	cmp    $0x10,%eax
801055e8:	75 56                	jne    80105640 <sys_unlink+0x1a0>
    if(de.inum != 0)
801055ea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801055ef:	74 df                	je     801055d0 <sys_unlink+0x130>
    iunlockput(ip);
801055f1:	83 ec 0c             	sub    $0xc,%esp
801055f4:	53                   	push   %ebx
801055f5:	e8 26 c5 ff ff       	call   80101b20 <iunlockput>
    goto bad;
801055fa:	83 c4 10             	add    $0x10,%esp
801055fd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105600:	83 ec 0c             	sub    $0xc,%esp
80105603:	ff 75 b4             	push   -0x4c(%ebp)
80105606:	e8 15 c5 ff ff       	call   80101b20 <iunlockput>
  end_op();
8010560b:	e8 90 d9 ff ff       	call   80102fa0 <end_op>
  return -1;
80105610:	83 c4 10             	add    $0x10,%esp
    return -1;
80105613:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105618:	eb 9c                	jmp    801055b6 <sys_unlink+0x116>
8010561a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105620:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105623:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105626:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010562b:	50                   	push   %eax
8010562c:	e8 af c1 ff ff       	call   801017e0 <iupdate>
80105631:	83 c4 10             	add    $0x10,%esp
80105634:	e9 53 ff ff ff       	jmp    8010558c <sys_unlink+0xec>
    end_op();
80105639:	e8 62 d9 ff ff       	call   80102fa0 <end_op>
    return -1;
8010563e:	eb d3                	jmp    80105613 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	68 29 81 10 80       	push   $0x80108129
80105648:	e8 23 ae ff ff       	call   80100470 <panic>
    panic("unlink: writei");
8010564d:	83 ec 0c             	sub    $0xc,%esp
80105650:	68 3b 81 10 80       	push   $0x8010813b
80105655:	e8 16 ae ff ff       	call   80100470 <panic>
    panic("unlink: nlink < 1");
8010565a:	83 ec 0c             	sub    $0xc,%esp
8010565d:	68 17 81 10 80       	push   $0x80108117
80105662:	e8 09 ae ff ff       	call   80100470 <panic>
80105667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010566e:	66 90                	xchg   %ax,%ax

80105670 <sys_open>:

int
sys_open(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	57                   	push   %edi
80105674:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105675:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105678:	53                   	push   %ebx
80105679:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010567c:	50                   	push   %eax
8010567d:	6a 00                	push   $0x0
8010567f:	e8 1c f8 ff ff       	call   80104ea0 <argstr>
80105684:	83 c4 10             	add    $0x10,%esp
80105687:	85 c0                	test   %eax,%eax
80105689:	0f 88 8e 00 00 00    	js     8010571d <sys_open+0xad>
8010568f:	83 ec 08             	sub    $0x8,%esp
80105692:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105695:	50                   	push   %eax
80105696:	6a 01                	push   $0x1
80105698:	e8 43 f7 ff ff       	call   80104de0 <argint>
8010569d:	83 c4 10             	add    $0x10,%esp
801056a0:	85 c0                	test   %eax,%eax
801056a2:	78 79                	js     8010571d <sys_open+0xad>
    return -1;

  begin_op();
801056a4:	e8 87 d8 ff ff       	call   80102f30 <begin_op>

  if(omode & O_CREATE){
801056a9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801056ad:	75 79                	jne    80105728 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801056af:	83 ec 0c             	sub    $0xc,%esp
801056b2:	ff 75 e0             	push   -0x20(%ebp)
801056b5:	e8 b6 ca ff ff       	call   80102170 <namei>
801056ba:	83 c4 10             	add    $0x10,%esp
801056bd:	89 c6                	mov    %eax,%esi
801056bf:	85 c0                	test   %eax,%eax
801056c1:	0f 84 7e 00 00 00    	je     80105745 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801056c7:	83 ec 0c             	sub    $0xc,%esp
801056ca:	50                   	push   %eax
801056cb:	e8 c0 c1 ff ff       	call   80101890 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801056d0:	83 c4 10             	add    $0x10,%esp
801056d3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801056d8:	0f 84 ba 00 00 00    	je     80105798 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801056de:	e8 5d b8 ff ff       	call   80100f40 <filealloc>
801056e3:	89 c7                	mov    %eax,%edi
801056e5:	85 c0                	test   %eax,%eax
801056e7:	74 23                	je     8010570c <sys_open+0x9c>
  struct proc *curproc = myproc();
801056e9:	e8 52 e4 ff ff       	call   80103b40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056ee:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801056f0:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
801056f4:	85 d2                	test   %edx,%edx
801056f6:	74 58                	je     80105750 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
801056f8:	83 c3 01             	add    $0x1,%ebx
801056fb:	83 fb 10             	cmp    $0x10,%ebx
801056fe:	75 f0                	jne    801056f0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105700:	83 ec 0c             	sub    $0xc,%esp
80105703:	57                   	push   %edi
80105704:	e8 f7 b8 ff ff       	call   80101000 <fileclose>
80105709:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010570c:	83 ec 0c             	sub    $0xc,%esp
8010570f:	56                   	push   %esi
80105710:	e8 0b c4 ff ff       	call   80101b20 <iunlockput>
    end_op();
80105715:	e8 86 d8 ff ff       	call   80102fa0 <end_op>
    return -1;
8010571a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010571d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105722:	eb 65                	jmp    80105789 <sys_open+0x119>
80105724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105728:	83 ec 0c             	sub    $0xc,%esp
8010572b:	31 c9                	xor    %ecx,%ecx
8010572d:	ba 02 00 00 00       	mov    $0x2,%edx
80105732:	6a 00                	push   $0x0
80105734:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105737:	e8 54 f8 ff ff       	call   80104f90 <create>
    if(ip == 0){
8010573c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010573f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105741:	85 c0                	test   %eax,%eax
80105743:	75 99                	jne    801056de <sys_open+0x6e>
      end_op();
80105745:	e8 56 d8 ff ff       	call   80102fa0 <end_op>
      return -1;
8010574a:	eb d1                	jmp    8010571d <sys_open+0xad>
8010574c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105750:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105753:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
80105757:	56                   	push   %esi
80105758:	e8 13 c2 ff ff       	call   80101970 <iunlock>
  end_op();
8010575d:	e8 3e d8 ff ff       	call   80102fa0 <end_op>

  f->type = FD_INODE;
80105762:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105768:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010576b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010576e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105771:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105773:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010577a:	f7 d0                	not    %eax
8010577c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010577f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105782:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105785:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105789:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010578c:	89 d8                	mov    %ebx,%eax
8010578e:	5b                   	pop    %ebx
8010578f:	5e                   	pop    %esi
80105790:	5f                   	pop    %edi
80105791:	5d                   	pop    %ebp
80105792:	c3                   	ret
80105793:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105797:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105798:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010579b:	85 c9                	test   %ecx,%ecx
8010579d:	0f 84 3b ff ff ff    	je     801056de <sys_open+0x6e>
801057a3:	e9 64 ff ff ff       	jmp    8010570c <sys_open+0x9c>
801057a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057af:	90                   	nop

801057b0 <sys_mkdir>:

int
sys_mkdir(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801057b6:	e8 75 d7 ff ff       	call   80102f30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801057bb:	83 ec 08             	sub    $0x8,%esp
801057be:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057c1:	50                   	push   %eax
801057c2:	6a 00                	push   $0x0
801057c4:	e8 d7 f6 ff ff       	call   80104ea0 <argstr>
801057c9:	83 c4 10             	add    $0x10,%esp
801057cc:	85 c0                	test   %eax,%eax
801057ce:	78 30                	js     80105800 <sys_mkdir+0x50>
801057d0:	83 ec 0c             	sub    $0xc,%esp
801057d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057d6:	31 c9                	xor    %ecx,%ecx
801057d8:	ba 01 00 00 00       	mov    $0x1,%edx
801057dd:	6a 00                	push   $0x0
801057df:	e8 ac f7 ff ff       	call   80104f90 <create>
801057e4:	83 c4 10             	add    $0x10,%esp
801057e7:	85 c0                	test   %eax,%eax
801057e9:	74 15                	je     80105800 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057eb:	83 ec 0c             	sub    $0xc,%esp
801057ee:	50                   	push   %eax
801057ef:	e8 2c c3 ff ff       	call   80101b20 <iunlockput>
  end_op();
801057f4:	e8 a7 d7 ff ff       	call   80102fa0 <end_op>
  return 0;
801057f9:	83 c4 10             	add    $0x10,%esp
801057fc:	31 c0                	xor    %eax,%eax
}
801057fe:	c9                   	leave
801057ff:	c3                   	ret
    end_op();
80105800:	e8 9b d7 ff ff       	call   80102fa0 <end_op>
    return -1;
80105805:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010580a:	c9                   	leave
8010580b:	c3                   	ret
8010580c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105810 <sys_mknod>:

int
sys_mknod(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105816:	e8 15 d7 ff ff       	call   80102f30 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010581b:	83 ec 08             	sub    $0x8,%esp
8010581e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105821:	50                   	push   %eax
80105822:	6a 00                	push   $0x0
80105824:	e8 77 f6 ff ff       	call   80104ea0 <argstr>
80105829:	83 c4 10             	add    $0x10,%esp
8010582c:	85 c0                	test   %eax,%eax
8010582e:	78 60                	js     80105890 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105830:	83 ec 08             	sub    $0x8,%esp
80105833:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105836:	50                   	push   %eax
80105837:	6a 01                	push   $0x1
80105839:	e8 a2 f5 ff ff       	call   80104de0 <argint>
  if((argstr(0, &path)) < 0 ||
8010583e:	83 c4 10             	add    $0x10,%esp
80105841:	85 c0                	test   %eax,%eax
80105843:	78 4b                	js     80105890 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105845:	83 ec 08             	sub    $0x8,%esp
80105848:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010584b:	50                   	push   %eax
8010584c:	6a 02                	push   $0x2
8010584e:	e8 8d f5 ff ff       	call   80104de0 <argint>
     argint(1, &major) < 0 ||
80105853:	83 c4 10             	add    $0x10,%esp
80105856:	85 c0                	test   %eax,%eax
80105858:	78 36                	js     80105890 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010585a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010585e:	83 ec 0c             	sub    $0xc,%esp
80105861:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105865:	ba 03 00 00 00       	mov    $0x3,%edx
8010586a:	50                   	push   %eax
8010586b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010586e:	e8 1d f7 ff ff       	call   80104f90 <create>
     argint(2, &minor) < 0 ||
80105873:	83 c4 10             	add    $0x10,%esp
80105876:	85 c0                	test   %eax,%eax
80105878:	74 16                	je     80105890 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010587a:	83 ec 0c             	sub    $0xc,%esp
8010587d:	50                   	push   %eax
8010587e:	e8 9d c2 ff ff       	call   80101b20 <iunlockput>
  end_op();
80105883:	e8 18 d7 ff ff       	call   80102fa0 <end_op>
  return 0;
80105888:	83 c4 10             	add    $0x10,%esp
8010588b:	31 c0                	xor    %eax,%eax
}
8010588d:	c9                   	leave
8010588e:	c3                   	ret
8010588f:	90                   	nop
    end_op();
80105890:	e8 0b d7 ff ff       	call   80102fa0 <end_op>
    return -1;
80105895:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010589a:	c9                   	leave
8010589b:	c3                   	ret
8010589c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058a0 <sys_chdir>:

int
sys_chdir(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	56                   	push   %esi
801058a4:	53                   	push   %ebx
801058a5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801058a8:	e8 93 e2 ff ff       	call   80103b40 <myproc>
801058ad:	89 c6                	mov    %eax,%esi
  
  begin_op();
801058af:	e8 7c d6 ff ff       	call   80102f30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801058b4:	83 ec 08             	sub    $0x8,%esp
801058b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058ba:	50                   	push   %eax
801058bb:	6a 00                	push   $0x0
801058bd:	e8 de f5 ff ff       	call   80104ea0 <argstr>
801058c2:	83 c4 10             	add    $0x10,%esp
801058c5:	85 c0                	test   %eax,%eax
801058c7:	78 77                	js     80105940 <sys_chdir+0xa0>
801058c9:	83 ec 0c             	sub    $0xc,%esp
801058cc:	ff 75 f4             	push   -0xc(%ebp)
801058cf:	e8 9c c8 ff ff       	call   80102170 <namei>
801058d4:	83 c4 10             	add    $0x10,%esp
801058d7:	89 c3                	mov    %eax,%ebx
801058d9:	85 c0                	test   %eax,%eax
801058db:	74 63                	je     80105940 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801058dd:	83 ec 0c             	sub    $0xc,%esp
801058e0:	50                   	push   %eax
801058e1:	e8 aa bf ff ff       	call   80101890 <ilock>
  if(ip->type != T_DIR){
801058e6:	83 c4 10             	add    $0x10,%esp
801058e9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058ee:	75 30                	jne    80105920 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801058f0:	83 ec 0c             	sub    $0xc,%esp
801058f3:	53                   	push   %ebx
801058f4:	e8 77 c0 ff ff       	call   80101970 <iunlock>
  iput(curproc->cwd);
801058f9:	58                   	pop    %eax
801058fa:	ff 76 6c             	push   0x6c(%esi)
801058fd:	e8 be c0 ff ff       	call   801019c0 <iput>
  end_op();
80105902:	e8 99 d6 ff ff       	call   80102fa0 <end_op>
  curproc->cwd = ip;
80105907:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
8010590a:	83 c4 10             	add    $0x10,%esp
8010590d:	31 c0                	xor    %eax,%eax
}
8010590f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105912:	5b                   	pop    %ebx
80105913:	5e                   	pop    %esi
80105914:	5d                   	pop    %ebp
80105915:	c3                   	ret
80105916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105920:	83 ec 0c             	sub    $0xc,%esp
80105923:	53                   	push   %ebx
80105924:	e8 f7 c1 ff ff       	call   80101b20 <iunlockput>
    end_op();
80105929:	e8 72 d6 ff ff       	call   80102fa0 <end_op>
    return -1;
8010592e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105931:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105936:	eb d7                	jmp    8010590f <sys_chdir+0x6f>
80105938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593f:	90                   	nop
    end_op();
80105940:	e8 5b d6 ff ff       	call   80102fa0 <end_op>
    return -1;
80105945:	eb ea                	jmp    80105931 <sys_chdir+0x91>
80105947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594e:	66 90                	xchg   %ax,%ax

80105950 <sys_exec>:

int
sys_exec(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	57                   	push   %edi
80105954:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105955:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010595b:	53                   	push   %ebx
8010595c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105962:	50                   	push   %eax
80105963:	6a 00                	push   $0x0
80105965:	e8 36 f5 ff ff       	call   80104ea0 <argstr>
8010596a:	83 c4 10             	add    $0x10,%esp
8010596d:	85 c0                	test   %eax,%eax
8010596f:	0f 88 87 00 00 00    	js     801059fc <sys_exec+0xac>
80105975:	83 ec 08             	sub    $0x8,%esp
80105978:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010597e:	50                   	push   %eax
8010597f:	6a 01                	push   $0x1
80105981:	e8 5a f4 ff ff       	call   80104de0 <argint>
80105986:	83 c4 10             	add    $0x10,%esp
80105989:	85 c0                	test   %eax,%eax
8010598b:	78 6f                	js     801059fc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010598d:	83 ec 04             	sub    $0x4,%esp
80105990:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105996:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105998:	68 80 00 00 00       	push   $0x80
8010599d:	6a 00                	push   $0x0
8010599f:	56                   	push   %esi
801059a0:	e8 8b f1 ff ff       	call   80104b30 <memset>
801059a5:	83 c4 10             	add    $0x10,%esp
801059a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059af:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801059b0:	83 ec 08             	sub    $0x8,%esp
801059b3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801059b9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801059c0:	50                   	push   %eax
801059c1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801059c7:	01 f8                	add    %edi,%eax
801059c9:	50                   	push   %eax
801059ca:	e8 81 f3 ff ff       	call   80104d50 <fetchint>
801059cf:	83 c4 10             	add    $0x10,%esp
801059d2:	85 c0                	test   %eax,%eax
801059d4:	78 26                	js     801059fc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801059d6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801059dc:	85 c0                	test   %eax,%eax
801059de:	74 30                	je     80105a10 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801059e0:	83 ec 08             	sub    $0x8,%esp
801059e3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801059e6:	52                   	push   %edx
801059e7:	50                   	push   %eax
801059e8:	e8 a3 f3 ff ff       	call   80104d90 <fetchstr>
801059ed:	83 c4 10             	add    $0x10,%esp
801059f0:	85 c0                	test   %eax,%eax
801059f2:	78 08                	js     801059fc <sys_exec+0xac>
  for(i=0;; i++){
801059f4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801059f7:	83 fb 20             	cmp    $0x20,%ebx
801059fa:	75 b4                	jne    801059b0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801059fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801059ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a04:	5b                   	pop    %ebx
80105a05:	5e                   	pop    %esi
80105a06:	5f                   	pop    %edi
80105a07:	5d                   	pop    %ebp
80105a08:	c3                   	ret
80105a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105a10:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105a17:	00 00 00 00 
  return exec(path, argv);
80105a1b:	83 ec 08             	sub    $0x8,%esp
80105a1e:	56                   	push   %esi
80105a1f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105a25:	e8 76 b1 ff ff       	call   80100ba0 <exec>
80105a2a:	83 c4 10             	add    $0x10,%esp
}
80105a2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a30:	5b                   	pop    %ebx
80105a31:	5e                   	pop    %esi
80105a32:	5f                   	pop    %edi
80105a33:	5d                   	pop    %ebp
80105a34:	c3                   	ret
80105a35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a40 <sys_pipe>:

int
sys_pipe(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	57                   	push   %edi
80105a44:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a45:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105a48:	53                   	push   %ebx
80105a49:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a4c:	6a 08                	push   $0x8
80105a4e:	50                   	push   %eax
80105a4f:	6a 00                	push   $0x0
80105a51:	e8 da f3 ff ff       	call   80104e30 <argptr>
80105a56:	83 c4 10             	add    $0x10,%esp
80105a59:	85 c0                	test   %eax,%eax
80105a5b:	0f 88 8b 00 00 00    	js     80105aec <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105a61:	83 ec 08             	sub    $0x8,%esp
80105a64:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a67:	50                   	push   %eax
80105a68:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105a6b:	50                   	push   %eax
80105a6c:	e8 8f db ff ff       	call   80103600 <pipealloc>
80105a71:	83 c4 10             	add    $0x10,%esp
80105a74:	85 c0                	test   %eax,%eax
80105a76:	78 74                	js     80105aec <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a78:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105a7b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105a7d:	e8 be e0 ff ff       	call   80103b40 <myproc>
    if(curproc->ofile[fd] == 0){
80105a82:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105a86:	85 f6                	test   %esi,%esi
80105a88:	74 16                	je     80105aa0 <sys_pipe+0x60>
80105a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105a90:	83 c3 01             	add    $0x1,%ebx
80105a93:	83 fb 10             	cmp    $0x10,%ebx
80105a96:	74 3d                	je     80105ad5 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105a98:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105a9c:	85 f6                	test   %esi,%esi
80105a9e:	75 f0                	jne    80105a90 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105aa0:	8d 73 08             	lea    0x8(%ebx),%esi
80105aa3:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105aa7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105aaa:	e8 91 e0 ff ff       	call   80103b40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105aaf:	31 d2                	xor    %edx,%edx
80105ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105ab8:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
80105abc:	85 c9                	test   %ecx,%ecx
80105abe:	74 38                	je     80105af8 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105ac0:	83 c2 01             	add    $0x1,%edx
80105ac3:	83 fa 10             	cmp    $0x10,%edx
80105ac6:	75 f0                	jne    80105ab8 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105ac8:	e8 73 e0 ff ff       	call   80103b40 <myproc>
80105acd:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105ad4:	00 
    fileclose(rf);
80105ad5:	83 ec 0c             	sub    $0xc,%esp
80105ad8:	ff 75 e0             	push   -0x20(%ebp)
80105adb:	e8 20 b5 ff ff       	call   80101000 <fileclose>
    fileclose(wf);
80105ae0:	58                   	pop    %eax
80105ae1:	ff 75 e4             	push   -0x1c(%ebp)
80105ae4:	e8 17 b5 ff ff       	call   80101000 <fileclose>
    return -1;
80105ae9:	83 c4 10             	add    $0x10,%esp
    return -1;
80105aec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105af1:	eb 16                	jmp    80105b09 <sys_pipe+0xc9>
80105af3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105af7:	90                   	nop
      curproc->ofile[fd] = f;
80105af8:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  }
  fd[0] = fd0;
80105afc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105aff:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105b01:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b04:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105b07:	31 c0                	xor    %eax,%eax
}
80105b09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b0c:	5b                   	pop    %ebx
80105b0d:	5e                   	pop    %esi
80105b0e:	5f                   	pop    %edi
80105b0f:	5d                   	pop    %ebp
80105b10:	c3                   	ret
80105b11:	66 90                	xchg   %ax,%ax
80105b13:	66 90                	xchg   %ax,%ax
80105b15:	66 90                	xchg   %ax,%ax
80105b17:	66 90                	xchg   %ax,%ax
80105b19:	66 90                	xchg   %ax,%ax
80105b1b:	66 90                	xchg   %ax,%ax
80105b1d:	66 90                	xchg   %ax,%ax
80105b1f:	90                   	nop

80105b20 <sys_getNumFreePages>:


int
sys_getNumFreePages(void)
{
  return num_of_FreePages();  
80105b20:	e9 7b cd ff ff       	jmp    801028a0 <num_of_FreePages>
80105b25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b30 <sys_getrss>:
}

int 
sys_getrss()
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	83 ec 08             	sub    $0x8,%esp
  print_rss();
80105b36:	e8 c5 e2 ff ff       	call   80103e00 <print_rss>
  return 0;
}
80105b3b:	31 c0                	xor    %eax,%eax
80105b3d:	c9                   	leave
80105b3e:	c3                   	ret
80105b3f:	90                   	nop

80105b40 <sys_fork>:

int
sys_fork(void)
{
  return fork();
80105b40:	e9 9b e1 ff ff       	jmp    80103ce0 <fork>
80105b45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b50 <sys_exit>:
}

int
sys_exit(void)
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b56:	e8 75 e4 ff ff       	call   80103fd0 <exit>
  return 0;  // not reached
}
80105b5b:	31 c0                	xor    %eax,%eax
80105b5d:	c9                   	leave
80105b5e:	c3                   	ret
80105b5f:	90                   	nop

80105b60 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105b60:	e9 9b e5 ff ff       	jmp    80104100 <wait>
80105b65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b70 <sys_kill>:
}

int
sys_kill(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105b76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b79:	50                   	push   %eax
80105b7a:	6a 00                	push   $0x0
80105b7c:	e8 5f f2 ff ff       	call   80104de0 <argint>
80105b81:	83 c4 10             	add    $0x10,%esp
80105b84:	85 c0                	test   %eax,%eax
80105b86:	78 18                	js     80105ba0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105b88:	83 ec 0c             	sub    $0xc,%esp
80105b8b:	ff 75 f4             	push   -0xc(%ebp)
80105b8e:	e8 1d e8 ff ff       	call   801043b0 <kill>
80105b93:	83 c4 10             	add    $0x10,%esp
}
80105b96:	c9                   	leave
80105b97:	c3                   	ret
80105b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b9f:	90                   	nop
80105ba0:	c9                   	leave
    return -1;
80105ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ba6:	c3                   	ret
80105ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bae:	66 90                	xchg   %ax,%ax

80105bb0 <sys_getpid>:

int
sys_getpid(void)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105bb6:	e8 85 df ff ff       	call   80103b40 <myproc>
80105bbb:	8b 40 14             	mov    0x14(%eax),%eax
}
80105bbe:	c9                   	leave
80105bbf:	c3                   	ret

80105bc0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105bc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105bc7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105bca:	50                   	push   %eax
80105bcb:	6a 00                	push   $0x0
80105bcd:	e8 0e f2 ff ff       	call   80104de0 <argint>
80105bd2:	83 c4 10             	add    $0x10,%esp
80105bd5:	85 c0                	test   %eax,%eax
80105bd7:	78 27                	js     80105c00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105bd9:	e8 62 df ff ff       	call   80103b40 <myproc>
  if(growproc(n) < 0)
80105bde:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105be1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105be3:	ff 75 f4             	push   -0xc(%ebp)
80105be6:	e8 75 e0 ff ff       	call   80103c60 <growproc>
80105beb:	83 c4 10             	add    $0x10,%esp
80105bee:	85 c0                	test   %eax,%eax
80105bf0:	78 0e                	js     80105c00 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105bf2:	89 d8                	mov    %ebx,%eax
80105bf4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bf7:	c9                   	leave
80105bf8:	c3                   	ret
80105bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c05:	eb eb                	jmp    80105bf2 <sys_sbrk+0x32>
80105c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c0e:	66 90                	xchg   %ax,%ax

80105c10 <sys_sleep>:

int
sys_sleep(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c1a:	50                   	push   %eax
80105c1b:	6a 00                	push   $0x0
80105c1d:	e8 be f1 ff ff       	call   80104de0 <argint>
80105c22:	83 c4 10             	add    $0x10,%esp
80105c25:	85 c0                	test   %eax,%eax
80105c27:	78 64                	js     80105c8d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105c29:	83 ec 0c             	sub    $0xc,%esp
80105c2c:	68 e0 58 11 80       	push   $0x801158e0
80105c31:	e8 fa ed ff ff       	call   80104a30 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105c39:	8b 1d c0 58 11 80    	mov    0x801158c0,%ebx
  while(ticks - ticks0 < n){
80105c3f:	83 c4 10             	add    $0x10,%esp
80105c42:	85 d2                	test   %edx,%edx
80105c44:	75 2b                	jne    80105c71 <sys_sleep+0x61>
80105c46:	eb 58                	jmp    80105ca0 <sys_sleep+0x90>
80105c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4f:	90                   	nop
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105c50:	83 ec 08             	sub    $0x8,%esp
80105c53:	68 e0 58 11 80       	push   $0x801158e0
80105c58:	68 c0 58 11 80       	push   $0x801158c0
80105c5d:	e8 2e e6 ff ff       	call   80104290 <sleep>
  while(ticks - ticks0 < n){
80105c62:	a1 c0 58 11 80       	mov    0x801158c0,%eax
80105c67:	83 c4 10             	add    $0x10,%esp
80105c6a:	29 d8                	sub    %ebx,%eax
80105c6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105c6f:	73 2f                	jae    80105ca0 <sys_sleep+0x90>
    if(myproc()->killed){
80105c71:	e8 ca de ff ff       	call   80103b40 <myproc>
80105c76:	8b 40 28             	mov    0x28(%eax),%eax
80105c79:	85 c0                	test   %eax,%eax
80105c7b:	74 d3                	je     80105c50 <sys_sleep+0x40>
      release(&tickslock);
80105c7d:	83 ec 0c             	sub    $0xc,%esp
80105c80:	68 e0 58 11 80       	push   $0x801158e0
80105c85:	e8 46 ed ff ff       	call   801049d0 <release>
      return -1;
80105c8a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80105c8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c95:	c9                   	leave
80105c96:	c3                   	ret
80105c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105ca0:	83 ec 0c             	sub    $0xc,%esp
80105ca3:	68 e0 58 11 80       	push   $0x801158e0
80105ca8:	e8 23 ed ff ff       	call   801049d0 <release>
}
80105cad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105cb0:	83 c4 10             	add    $0x10,%esp
80105cb3:	31 c0                	xor    %eax,%eax
}
80105cb5:	c9                   	leave
80105cb6:	c3                   	ret
80105cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbe:	66 90                	xchg   %ax,%ax

80105cc0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	53                   	push   %ebx
80105cc4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105cc7:	68 e0 58 11 80       	push   $0x801158e0
80105ccc:	e8 5f ed ff ff       	call   80104a30 <acquire>
  xticks = ticks;
80105cd1:	8b 1d c0 58 11 80    	mov    0x801158c0,%ebx
  release(&tickslock);
80105cd7:	c7 04 24 e0 58 11 80 	movl   $0x801158e0,(%esp)
80105cde:	e8 ed ec ff ff       	call   801049d0 <release>
  return xticks;
}
80105ce3:	89 d8                	mov    %ebx,%eax
80105ce5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ce8:	c9                   	leave
80105ce9:	c3                   	ret

80105cea <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105cea:	1e                   	push   %ds
  pushl %es
80105ceb:	06                   	push   %es
  pushl %fs
80105cec:	0f a0                	push   %fs
  pushl %gs
80105cee:	0f a8                	push   %gs
  pushal
80105cf0:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105cf1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105cf5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105cf7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105cf9:	54                   	push   %esp
  call trap
80105cfa:	e8 c1 00 00 00       	call   80105dc0 <trap>
  addl $4, %esp
80105cff:	83 c4 04             	add    $0x4,%esp

80105d02 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d02:	61                   	popa
  popl %gs
80105d03:	0f a9                	pop    %gs
  popl %fs
80105d05:	0f a1                	pop    %fs
  popl %es
80105d07:	07                   	pop    %es
  popl %ds
80105d08:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d09:	83 c4 08             	add    $0x8,%esp
  iret
80105d0c:	cf                   	iret
80105d0d:	66 90                	xchg   %ax,%ax
80105d0f:	90                   	nop

80105d10 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d10:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105d11:	31 c0                	xor    %eax,%eax
{
80105d13:	89 e5                	mov    %esp,%ebp
80105d15:	83 ec 08             	sub    $0x8,%esp
80105d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d1f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d20:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105d27:	c7 04 c5 22 59 11 80 	movl   $0x8e000008,-0x7feea6de(,%eax,8)
80105d2e:	08 00 00 8e 
80105d32:	66 89 14 c5 20 59 11 	mov    %dx,-0x7feea6e0(,%eax,8)
80105d39:	80 
80105d3a:	c1 ea 10             	shr    $0x10,%edx
80105d3d:	66 89 14 c5 26 59 11 	mov    %dx,-0x7feea6da(,%eax,8)
80105d44:	80 
  for(i = 0; i < 256; i++)
80105d45:	83 c0 01             	add    $0x1,%eax
80105d48:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d4d:	75 d1                	jne    80105d20 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105d4f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d52:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105d57:	c7 05 22 5b 11 80 08 	movl   $0xef000008,0x80115b22
80105d5e:	00 00 ef 
  initlock(&tickslock, "time");
80105d61:	68 4a 81 10 80       	push   $0x8010814a
80105d66:	68 e0 58 11 80       	push   $0x801158e0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d6b:	66 a3 20 5b 11 80    	mov    %ax,0x80115b20
80105d71:	c1 e8 10             	shr    $0x10,%eax
80105d74:	66 a3 26 5b 11 80    	mov    %ax,0x80115b26
  initlock(&tickslock, "time");
80105d7a:	e8 c1 ea ff ff       	call   80104840 <initlock>
}
80105d7f:	83 c4 10             	add    $0x10,%esp
80105d82:	c9                   	leave
80105d83:	c3                   	ret
80105d84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d8f:	90                   	nop

80105d90 <idtinit>:

void
idtinit(void)
{
80105d90:	55                   	push   %ebp
  pd[0] = size-1;
80105d91:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105d96:	89 e5                	mov    %esp,%ebp
80105d98:	83 ec 10             	sub    $0x10,%esp
80105d9b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105d9f:	b8 20 59 11 80       	mov    $0x80115920,%eax
80105da4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105da8:	c1 e8 10             	shr    $0x10,%eax
80105dab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105daf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105db2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105db5:	c9                   	leave
80105db6:	c3                   	ret
80105db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dbe:	66 90                	xchg   %ax,%ax

80105dc0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	57                   	push   %edi
80105dc4:	56                   	push   %esi
80105dc5:	53                   	push   %ebx
80105dc6:	83 ec 1c             	sub    $0x1c,%esp
80105dc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105dcc:	8b 43 30             	mov    0x30(%ebx),%eax
80105dcf:	83 f8 40             	cmp    $0x40,%eax
80105dd2:	0f 84 30 01 00 00    	je     80105f08 <trap+0x148>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105dd8:	83 e8 0e             	sub    $0xe,%eax
80105ddb:	83 f8 31             	cmp    $0x31,%eax
80105dde:	0f 87 8c 00 00 00    	ja     80105e70 <trap+0xb0>
80105de4:	ff 24 85 e0 87 10 80 	jmp    *-0x7fef7820(,%eax,4)
80105deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105def:	90                   	nop
    // panic("wohooo\n");
    handle_page_fault();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105df0:	e8 2b dd ff ff       	call   80103b20 <cpuid>
80105df5:	85 c0                	test   %eax,%eax
80105df7:	0f 84 13 02 00 00    	je     80106010 <trap+0x250>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105dfd:	e8 de cc ff ff       	call   80102ae0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e02:	e8 39 dd ff ff       	call   80103b40 <myproc>
80105e07:	85 c0                	test   %eax,%eax
80105e09:	74 1a                	je     80105e25 <trap+0x65>
80105e0b:	e8 30 dd ff ff       	call   80103b40 <myproc>
80105e10:	8b 50 28             	mov    0x28(%eax),%edx
80105e13:	85 d2                	test   %edx,%edx
80105e15:	74 0e                	je     80105e25 <trap+0x65>
80105e17:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e1b:	f7 d0                	not    %eax
80105e1d:	a8 03                	test   $0x3,%al
80105e1f:	0f 84 cb 01 00 00    	je     80105ff0 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105e25:	e8 16 dd ff ff       	call   80103b40 <myproc>
80105e2a:	85 c0                	test   %eax,%eax
80105e2c:	74 0f                	je     80105e3d <trap+0x7d>
80105e2e:	e8 0d dd ff ff       	call   80103b40 <myproc>
80105e33:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80105e37:	0f 84 b3 00 00 00    	je     80105ef0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e3d:	e8 fe dc ff ff       	call   80103b40 <myproc>
80105e42:	85 c0                	test   %eax,%eax
80105e44:	74 1a                	je     80105e60 <trap+0xa0>
80105e46:	e8 f5 dc ff ff       	call   80103b40 <myproc>
80105e4b:	8b 40 28             	mov    0x28(%eax),%eax
80105e4e:	85 c0                	test   %eax,%eax
80105e50:	74 0e                	je     80105e60 <trap+0xa0>
80105e52:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e56:	f7 d0                	not    %eax
80105e58:	a8 03                	test   $0x3,%al
80105e5a:	0f 84 d5 00 00 00    	je     80105f35 <trap+0x175>
    exit();
}
80105e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e63:	5b                   	pop    %ebx
80105e64:	5e                   	pop    %esi
80105e65:	5f                   	pop    %edi
80105e66:	5d                   	pop    %ebp
80105e67:	c3                   	ret
80105e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e6f:	90                   	nop
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e70:	e8 cb dc ff ff       	call   80103b40 <myproc>
80105e75:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e78:	85 c0                	test   %eax,%eax
80105e7a:	0f 84 c4 01 00 00    	je     80106044 <trap+0x284>
80105e80:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105e84:	0f 84 ba 01 00 00    	je     80106044 <trap+0x284>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e8a:	0f 20 d1             	mov    %cr2,%ecx
80105e8d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e90:	e8 8b dc ff ff       	call   80103b20 <cpuid>
80105e95:	8b 73 30             	mov    0x30(%ebx),%esi
80105e98:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105e9b:	8b 43 34             	mov    0x34(%ebx),%eax
80105e9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105ea1:	e8 9a dc ff ff       	call   80103b40 <myproc>
80105ea6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ea9:	e8 92 dc ff ff       	call   80103b40 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105eae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105eb1:	51                   	push   %ecx
80105eb2:	57                   	push   %edi
80105eb3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105eb6:	52                   	push   %edx
80105eb7:	ff 75 e4             	push   -0x1c(%ebp)
80105eba:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105ebb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105ebe:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ec1:	56                   	push   %esi
80105ec2:	ff 70 14             	push   0x14(%eax)
80105ec5:	68 78 84 10 80       	push   $0x80108478
80105eca:	e8 d1 a8 ff ff       	call   801007a0 <cprintf>
    myproc()->killed = 1;
80105ecf:	83 c4 20             	add    $0x20,%esp
80105ed2:	e8 69 dc ff ff       	call   80103b40 <myproc>
80105ed7:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ede:	e8 5d dc ff ff       	call   80103b40 <myproc>
80105ee3:	85 c0                	test   %eax,%eax
80105ee5:	0f 85 20 ff ff ff    	jne    80105e0b <trap+0x4b>
80105eeb:	e9 35 ff ff ff       	jmp    80105e25 <trap+0x65>
  if(myproc() && myproc()->state == RUNNING &&
80105ef0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105ef4:	0f 85 43 ff ff ff    	jne    80105e3d <trap+0x7d>
    yield();
80105efa:	e8 41 e3 ff ff       	call   80104240 <yield>
80105eff:	e9 39 ff ff ff       	jmp    80105e3d <trap+0x7d>
80105f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105f08:	e8 33 dc ff ff       	call   80103b40 <myproc>
80105f0d:	8b 70 28             	mov    0x28(%eax),%esi
80105f10:	85 f6                	test   %esi,%esi
80105f12:	0f 85 e8 00 00 00    	jne    80106000 <trap+0x240>
    myproc()->tf = tf;
80105f18:	e8 23 dc ff ff       	call   80103b40 <myproc>
80105f1d:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80105f20:	e8 fb ef ff ff       	call   80104f20 <syscall>
    if(myproc()->killed)
80105f25:	e8 16 dc ff ff       	call   80103b40 <myproc>
80105f2a:	8b 48 28             	mov    0x28(%eax),%ecx
80105f2d:	85 c9                	test   %ecx,%ecx
80105f2f:	0f 84 2b ff ff ff    	je     80105e60 <trap+0xa0>
}
80105f35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f38:	5b                   	pop    %ebx
80105f39:	5e                   	pop    %esi
80105f3a:	5f                   	pop    %edi
80105f3b:	5d                   	pop    %ebp
      exit();
80105f3c:	e9 8f e0 ff ff       	jmp    80103fd0 <exit>
80105f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f48:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f4b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105f4f:	e8 cc db ff ff       	call   80103b20 <cpuid>
80105f54:	57                   	push   %edi
80105f55:	56                   	push   %esi
80105f56:	50                   	push   %eax
80105f57:	68 20 84 10 80       	push   $0x80108420
80105f5c:	e8 3f a8 ff ff       	call   801007a0 <cprintf>
    lapiceoi();
80105f61:	e8 7a cb ff ff       	call   80102ae0 <lapiceoi>
    break;
80105f66:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f69:	e8 d2 db ff ff       	call   80103b40 <myproc>
80105f6e:	85 c0                	test   %eax,%eax
80105f70:	0f 85 95 fe ff ff    	jne    80105e0b <trap+0x4b>
80105f76:	e9 aa fe ff ff       	jmp    80105e25 <trap+0x65>
80105f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f7f:	90                   	nop
    kbdintr();
80105f80:	e8 2b ca ff ff       	call   801029b0 <kbdintr>
    lapiceoi();
80105f85:	e8 56 cb ff ff       	call   80102ae0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f8a:	e8 b1 db ff ff       	call   80103b40 <myproc>
80105f8f:	85 c0                	test   %eax,%eax
80105f91:	0f 85 74 fe ff ff    	jne    80105e0b <trap+0x4b>
80105f97:	e9 89 fe ff ff       	jmp    80105e25 <trap+0x65>
80105f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105fa0:	e8 4b 02 00 00       	call   801061f0 <uartintr>
    lapiceoi();
80105fa5:	e8 36 cb ff ff       	call   80102ae0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105faa:	e8 91 db ff ff       	call   80103b40 <myproc>
80105faf:	85 c0                	test   %eax,%eax
80105fb1:	0f 85 54 fe ff ff    	jne    80105e0b <trap+0x4b>
80105fb7:	e9 69 fe ff ff       	jmp    80105e25 <trap+0x65>
80105fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105fc0:	e8 5b c3 ff ff       	call   80102320 <ideintr>
80105fc5:	e9 33 fe ff ff       	jmp    80105dfd <trap+0x3d>
80105fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    handle_page_fault();
80105fd0:	e8 0b 1c 00 00       	call   80107be0 <handle_page_fault>
    lapiceoi();
80105fd5:	e8 06 cb ff ff       	call   80102ae0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fda:	e8 61 db ff ff       	call   80103b40 <myproc>
80105fdf:	85 c0                	test   %eax,%eax
80105fe1:	0f 85 24 fe ff ff    	jne    80105e0b <trap+0x4b>
80105fe7:	e9 39 fe ff ff       	jmp    80105e25 <trap+0x65>
80105fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105ff0:	e8 db df ff ff       	call   80103fd0 <exit>
80105ff5:	e9 2b fe ff ff       	jmp    80105e25 <trap+0x65>
80105ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106000:	e8 cb df ff ff       	call   80103fd0 <exit>
80106005:	e9 0e ff ff ff       	jmp    80105f18 <trap+0x158>
8010600a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106010:	83 ec 0c             	sub    $0xc,%esp
80106013:	68 e0 58 11 80       	push   $0x801158e0
80106018:	e8 13 ea ff ff       	call   80104a30 <acquire>
      ticks++;
8010601d:	83 05 c0 58 11 80 01 	addl   $0x1,0x801158c0
      wakeup(&ticks);
80106024:	c7 04 24 c0 58 11 80 	movl   $0x801158c0,(%esp)
8010602b:	e8 20 e3 ff ff       	call   80104350 <wakeup>
      release(&tickslock);
80106030:	c7 04 24 e0 58 11 80 	movl   $0x801158e0,(%esp)
80106037:	e8 94 e9 ff ff       	call   801049d0 <release>
8010603c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010603f:	e9 b9 fd ff ff       	jmp    80105dfd <trap+0x3d>
80106044:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106047:	e8 d4 da ff ff       	call   80103b20 <cpuid>
8010604c:	83 ec 0c             	sub    $0xc,%esp
8010604f:	56                   	push   %esi
80106050:	57                   	push   %edi
80106051:	50                   	push   %eax
80106052:	ff 73 30             	push   0x30(%ebx)
80106055:	68 44 84 10 80       	push   $0x80108444
8010605a:	e8 41 a7 ff ff       	call   801007a0 <cprintf>
      panic("trap");
8010605f:	83 c4 14             	add    $0x14,%esp
80106062:	68 4f 81 10 80       	push   $0x8010814f
80106067:	e8 04 a4 ff ff       	call   80100470 <panic>
8010606c:	66 90                	xchg   %ax,%ax
8010606e:	66 90                	xchg   %ax,%ax

80106070 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106070:	a1 20 61 11 80       	mov    0x80116120,%eax
80106075:	85 c0                	test   %eax,%eax
80106077:	74 17                	je     80106090 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106079:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010607e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010607f:	a8 01                	test   $0x1,%al
80106081:	74 0d                	je     80106090 <uartgetc+0x20>
80106083:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106088:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106089:	0f b6 c0             	movzbl %al,%eax
8010608c:	c3                   	ret
8010608d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106095:	c3                   	ret
80106096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010609d:	8d 76 00             	lea    0x0(%esi),%esi

801060a0 <uartinit>:
{
801060a0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060a1:	31 c9                	xor    %ecx,%ecx
801060a3:	89 c8                	mov    %ecx,%eax
801060a5:	89 e5                	mov    %esp,%ebp
801060a7:	57                   	push   %edi
801060a8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801060ad:	56                   	push   %esi
801060ae:	89 fa                	mov    %edi,%edx
801060b0:	53                   	push   %ebx
801060b1:	83 ec 1c             	sub    $0x1c,%esp
801060b4:	ee                   	out    %al,(%dx)
801060b5:	be fb 03 00 00       	mov    $0x3fb,%esi
801060ba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801060bf:	89 f2                	mov    %esi,%edx
801060c1:	ee                   	out    %al,(%dx)
801060c2:	b8 0c 00 00 00       	mov    $0xc,%eax
801060c7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060cc:	ee                   	out    %al,(%dx)
801060cd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801060d2:	89 c8                	mov    %ecx,%eax
801060d4:	89 da                	mov    %ebx,%edx
801060d6:	ee                   	out    %al,(%dx)
801060d7:	b8 03 00 00 00       	mov    $0x3,%eax
801060dc:	89 f2                	mov    %esi,%edx
801060de:	ee                   	out    %al,(%dx)
801060df:	ba fc 03 00 00       	mov    $0x3fc,%edx
801060e4:	89 c8                	mov    %ecx,%eax
801060e6:	ee                   	out    %al,(%dx)
801060e7:	b8 01 00 00 00       	mov    $0x1,%eax
801060ec:	89 da                	mov    %ebx,%edx
801060ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060ef:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060f4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801060f5:	3c ff                	cmp    $0xff,%al
801060f7:	0f 84 7c 00 00 00    	je     80106179 <uartinit+0xd9>
  uart = 1;
801060fd:	c7 05 20 61 11 80 01 	movl   $0x1,0x80116120
80106104:	00 00 00 
80106107:	89 fa                	mov    %edi,%edx
80106109:	ec                   	in     (%dx),%al
8010610a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010610f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106110:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106113:	bf 54 81 10 80       	mov    $0x80108154,%edi
80106118:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
8010611d:	6a 00                	push   $0x0
8010611f:	6a 04                	push   $0x4
80106121:	e8 2a c4 ff ff       	call   80102550 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106126:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
8010612a:	83 c4 10             	add    $0x10,%esp
8010612d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80106130:	a1 20 61 11 80       	mov    0x80116120,%eax
80106135:	85 c0                	test   %eax,%eax
80106137:	74 32                	je     8010616b <uartinit+0xcb>
80106139:	89 f2                	mov    %esi,%edx
8010613b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010613c:	a8 20                	test   $0x20,%al
8010613e:	75 21                	jne    80106161 <uartinit+0xc1>
80106140:	bb 80 00 00 00       	mov    $0x80,%ebx
80106145:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80106148:	83 ec 0c             	sub    $0xc,%esp
8010614b:	6a 0a                	push   $0xa
8010614d:	e8 ae c9 ff ff       	call   80102b00 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106152:	83 c4 10             	add    $0x10,%esp
80106155:	83 eb 01             	sub    $0x1,%ebx
80106158:	74 07                	je     80106161 <uartinit+0xc1>
8010615a:	89 f2                	mov    %esi,%edx
8010615c:	ec                   	in     (%dx),%al
8010615d:	a8 20                	test   $0x20,%al
8010615f:	74 e7                	je     80106148 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106161:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106166:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010616a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010616b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
8010616f:	83 c7 01             	add    $0x1,%edi
80106172:	88 45 e7             	mov    %al,-0x19(%ebp)
80106175:	84 c0                	test   %al,%al
80106177:	75 b7                	jne    80106130 <uartinit+0x90>
}
80106179:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010617c:	5b                   	pop    %ebx
8010617d:	5e                   	pop    %esi
8010617e:	5f                   	pop    %edi
8010617f:	5d                   	pop    %ebp
80106180:	c3                   	ret
80106181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010618f:	90                   	nop

80106190 <uartputc>:
  if(!uart)
80106190:	a1 20 61 11 80       	mov    0x80116120,%eax
80106195:	85 c0                	test   %eax,%eax
80106197:	74 4f                	je     801061e8 <uartputc+0x58>
{
80106199:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010619a:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010619f:	89 e5                	mov    %esp,%ebp
801061a1:	56                   	push   %esi
801061a2:	53                   	push   %ebx
801061a3:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061a4:	a8 20                	test   $0x20,%al
801061a6:	75 29                	jne    801061d1 <uartputc+0x41>
801061a8:	bb 80 00 00 00       	mov    $0x80,%ebx
801061ad:	be fd 03 00 00       	mov    $0x3fd,%esi
801061b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801061b8:	83 ec 0c             	sub    $0xc,%esp
801061bb:	6a 0a                	push   $0xa
801061bd:	e8 3e c9 ff ff       	call   80102b00 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061c2:	83 c4 10             	add    $0x10,%esp
801061c5:	83 eb 01             	sub    $0x1,%ebx
801061c8:	74 07                	je     801061d1 <uartputc+0x41>
801061ca:	89 f2                	mov    %esi,%edx
801061cc:	ec                   	in     (%dx),%al
801061cd:	a8 20                	test   $0x20,%al
801061cf:	74 e7                	je     801061b8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061d1:	8b 45 08             	mov    0x8(%ebp),%eax
801061d4:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061d9:	ee                   	out    %al,(%dx)
}
801061da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061dd:	5b                   	pop    %ebx
801061de:	5e                   	pop    %esi
801061df:	5d                   	pop    %ebp
801061e0:	c3                   	ret
801061e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061e8:	c3                   	ret
801061e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061f0 <uartintr>:

void
uartintr(void)
{
801061f0:	55                   	push   %ebp
801061f1:	89 e5                	mov    %esp,%ebp
801061f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801061f6:	68 70 60 10 80       	push   $0x80106070
801061fb:	e8 90 a7 ff ff       	call   80100990 <consoleintr>
}
80106200:	83 c4 10             	add    $0x10,%esp
80106203:	c9                   	leave
80106204:	c3                   	ret

80106205 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $0
80106207:	6a 00                	push   $0x0
  jmp alltraps
80106209:	e9 dc fa ff ff       	jmp    80105cea <alltraps>

8010620e <vector1>:
.globl vector1
vector1:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $1
80106210:	6a 01                	push   $0x1
  jmp alltraps
80106212:	e9 d3 fa ff ff       	jmp    80105cea <alltraps>

80106217 <vector2>:
.globl vector2
vector2:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $2
80106219:	6a 02                	push   $0x2
  jmp alltraps
8010621b:	e9 ca fa ff ff       	jmp    80105cea <alltraps>

80106220 <vector3>:
.globl vector3
vector3:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $3
80106222:	6a 03                	push   $0x3
  jmp alltraps
80106224:	e9 c1 fa ff ff       	jmp    80105cea <alltraps>

80106229 <vector4>:
.globl vector4
vector4:
  pushl $0
80106229:	6a 00                	push   $0x0
  pushl $4
8010622b:	6a 04                	push   $0x4
  jmp alltraps
8010622d:	e9 b8 fa ff ff       	jmp    80105cea <alltraps>

80106232 <vector5>:
.globl vector5
vector5:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $5
80106234:	6a 05                	push   $0x5
  jmp alltraps
80106236:	e9 af fa ff ff       	jmp    80105cea <alltraps>

8010623b <vector6>:
.globl vector6
vector6:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $6
8010623d:	6a 06                	push   $0x6
  jmp alltraps
8010623f:	e9 a6 fa ff ff       	jmp    80105cea <alltraps>

80106244 <vector7>:
.globl vector7
vector7:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $7
80106246:	6a 07                	push   $0x7
  jmp alltraps
80106248:	e9 9d fa ff ff       	jmp    80105cea <alltraps>

8010624d <vector8>:
.globl vector8
vector8:
  pushl $8
8010624d:	6a 08                	push   $0x8
  jmp alltraps
8010624f:	e9 96 fa ff ff       	jmp    80105cea <alltraps>

80106254 <vector9>:
.globl vector9
vector9:
  pushl $0
80106254:	6a 00                	push   $0x0
  pushl $9
80106256:	6a 09                	push   $0x9
  jmp alltraps
80106258:	e9 8d fa ff ff       	jmp    80105cea <alltraps>

8010625d <vector10>:
.globl vector10
vector10:
  pushl $10
8010625d:	6a 0a                	push   $0xa
  jmp alltraps
8010625f:	e9 86 fa ff ff       	jmp    80105cea <alltraps>

80106264 <vector11>:
.globl vector11
vector11:
  pushl $11
80106264:	6a 0b                	push   $0xb
  jmp alltraps
80106266:	e9 7f fa ff ff       	jmp    80105cea <alltraps>

8010626b <vector12>:
.globl vector12
vector12:
  pushl $12
8010626b:	6a 0c                	push   $0xc
  jmp alltraps
8010626d:	e9 78 fa ff ff       	jmp    80105cea <alltraps>

80106272 <vector13>:
.globl vector13
vector13:
  pushl $13
80106272:	6a 0d                	push   $0xd
  jmp alltraps
80106274:	e9 71 fa ff ff       	jmp    80105cea <alltraps>

80106279 <vector14>:
.globl vector14
vector14:
  pushl $14
80106279:	6a 0e                	push   $0xe
  jmp alltraps
8010627b:	e9 6a fa ff ff       	jmp    80105cea <alltraps>

80106280 <vector15>:
.globl vector15
vector15:
  pushl $0
80106280:	6a 00                	push   $0x0
  pushl $15
80106282:	6a 0f                	push   $0xf
  jmp alltraps
80106284:	e9 61 fa ff ff       	jmp    80105cea <alltraps>

80106289 <vector16>:
.globl vector16
vector16:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $16
8010628b:	6a 10                	push   $0x10
  jmp alltraps
8010628d:	e9 58 fa ff ff       	jmp    80105cea <alltraps>

80106292 <vector17>:
.globl vector17
vector17:
  pushl $17
80106292:	6a 11                	push   $0x11
  jmp alltraps
80106294:	e9 51 fa ff ff       	jmp    80105cea <alltraps>

80106299 <vector18>:
.globl vector18
vector18:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $18
8010629b:	6a 12                	push   $0x12
  jmp alltraps
8010629d:	e9 48 fa ff ff       	jmp    80105cea <alltraps>

801062a2 <vector19>:
.globl vector19
vector19:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $19
801062a4:	6a 13                	push   $0x13
  jmp alltraps
801062a6:	e9 3f fa ff ff       	jmp    80105cea <alltraps>

801062ab <vector20>:
.globl vector20
vector20:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $20
801062ad:	6a 14                	push   $0x14
  jmp alltraps
801062af:	e9 36 fa ff ff       	jmp    80105cea <alltraps>

801062b4 <vector21>:
.globl vector21
vector21:
  pushl $0
801062b4:	6a 00                	push   $0x0
  pushl $21
801062b6:	6a 15                	push   $0x15
  jmp alltraps
801062b8:	e9 2d fa ff ff       	jmp    80105cea <alltraps>

801062bd <vector22>:
.globl vector22
vector22:
  pushl $0
801062bd:	6a 00                	push   $0x0
  pushl $22
801062bf:	6a 16                	push   $0x16
  jmp alltraps
801062c1:	e9 24 fa ff ff       	jmp    80105cea <alltraps>

801062c6 <vector23>:
.globl vector23
vector23:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $23
801062c8:	6a 17                	push   $0x17
  jmp alltraps
801062ca:	e9 1b fa ff ff       	jmp    80105cea <alltraps>

801062cf <vector24>:
.globl vector24
vector24:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $24
801062d1:	6a 18                	push   $0x18
  jmp alltraps
801062d3:	e9 12 fa ff ff       	jmp    80105cea <alltraps>

801062d8 <vector25>:
.globl vector25
vector25:
  pushl $0
801062d8:	6a 00                	push   $0x0
  pushl $25
801062da:	6a 19                	push   $0x19
  jmp alltraps
801062dc:	e9 09 fa ff ff       	jmp    80105cea <alltraps>

801062e1 <vector26>:
.globl vector26
vector26:
  pushl $0
801062e1:	6a 00                	push   $0x0
  pushl $26
801062e3:	6a 1a                	push   $0x1a
  jmp alltraps
801062e5:	e9 00 fa ff ff       	jmp    80105cea <alltraps>

801062ea <vector27>:
.globl vector27
vector27:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $27
801062ec:	6a 1b                	push   $0x1b
  jmp alltraps
801062ee:	e9 f7 f9 ff ff       	jmp    80105cea <alltraps>

801062f3 <vector28>:
.globl vector28
vector28:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $28
801062f5:	6a 1c                	push   $0x1c
  jmp alltraps
801062f7:	e9 ee f9 ff ff       	jmp    80105cea <alltraps>

801062fc <vector29>:
.globl vector29
vector29:
  pushl $0
801062fc:	6a 00                	push   $0x0
  pushl $29
801062fe:	6a 1d                	push   $0x1d
  jmp alltraps
80106300:	e9 e5 f9 ff ff       	jmp    80105cea <alltraps>

80106305 <vector30>:
.globl vector30
vector30:
  pushl $0
80106305:	6a 00                	push   $0x0
  pushl $30
80106307:	6a 1e                	push   $0x1e
  jmp alltraps
80106309:	e9 dc f9 ff ff       	jmp    80105cea <alltraps>

8010630e <vector31>:
.globl vector31
vector31:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $31
80106310:	6a 1f                	push   $0x1f
  jmp alltraps
80106312:	e9 d3 f9 ff ff       	jmp    80105cea <alltraps>

80106317 <vector32>:
.globl vector32
vector32:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $32
80106319:	6a 20                	push   $0x20
  jmp alltraps
8010631b:	e9 ca f9 ff ff       	jmp    80105cea <alltraps>

80106320 <vector33>:
.globl vector33
vector33:
  pushl $0
80106320:	6a 00                	push   $0x0
  pushl $33
80106322:	6a 21                	push   $0x21
  jmp alltraps
80106324:	e9 c1 f9 ff ff       	jmp    80105cea <alltraps>

80106329 <vector34>:
.globl vector34
vector34:
  pushl $0
80106329:	6a 00                	push   $0x0
  pushl $34
8010632b:	6a 22                	push   $0x22
  jmp alltraps
8010632d:	e9 b8 f9 ff ff       	jmp    80105cea <alltraps>

80106332 <vector35>:
.globl vector35
vector35:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $35
80106334:	6a 23                	push   $0x23
  jmp alltraps
80106336:	e9 af f9 ff ff       	jmp    80105cea <alltraps>

8010633b <vector36>:
.globl vector36
vector36:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $36
8010633d:	6a 24                	push   $0x24
  jmp alltraps
8010633f:	e9 a6 f9 ff ff       	jmp    80105cea <alltraps>

80106344 <vector37>:
.globl vector37
vector37:
  pushl $0
80106344:	6a 00                	push   $0x0
  pushl $37
80106346:	6a 25                	push   $0x25
  jmp alltraps
80106348:	e9 9d f9 ff ff       	jmp    80105cea <alltraps>

8010634d <vector38>:
.globl vector38
vector38:
  pushl $0
8010634d:	6a 00                	push   $0x0
  pushl $38
8010634f:	6a 26                	push   $0x26
  jmp alltraps
80106351:	e9 94 f9 ff ff       	jmp    80105cea <alltraps>

80106356 <vector39>:
.globl vector39
vector39:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $39
80106358:	6a 27                	push   $0x27
  jmp alltraps
8010635a:	e9 8b f9 ff ff       	jmp    80105cea <alltraps>

8010635f <vector40>:
.globl vector40
vector40:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $40
80106361:	6a 28                	push   $0x28
  jmp alltraps
80106363:	e9 82 f9 ff ff       	jmp    80105cea <alltraps>

80106368 <vector41>:
.globl vector41
vector41:
  pushl $0
80106368:	6a 00                	push   $0x0
  pushl $41
8010636a:	6a 29                	push   $0x29
  jmp alltraps
8010636c:	e9 79 f9 ff ff       	jmp    80105cea <alltraps>

80106371 <vector42>:
.globl vector42
vector42:
  pushl $0
80106371:	6a 00                	push   $0x0
  pushl $42
80106373:	6a 2a                	push   $0x2a
  jmp alltraps
80106375:	e9 70 f9 ff ff       	jmp    80105cea <alltraps>

8010637a <vector43>:
.globl vector43
vector43:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $43
8010637c:	6a 2b                	push   $0x2b
  jmp alltraps
8010637e:	e9 67 f9 ff ff       	jmp    80105cea <alltraps>

80106383 <vector44>:
.globl vector44
vector44:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $44
80106385:	6a 2c                	push   $0x2c
  jmp alltraps
80106387:	e9 5e f9 ff ff       	jmp    80105cea <alltraps>

8010638c <vector45>:
.globl vector45
vector45:
  pushl $0
8010638c:	6a 00                	push   $0x0
  pushl $45
8010638e:	6a 2d                	push   $0x2d
  jmp alltraps
80106390:	e9 55 f9 ff ff       	jmp    80105cea <alltraps>

80106395 <vector46>:
.globl vector46
vector46:
  pushl $0
80106395:	6a 00                	push   $0x0
  pushl $46
80106397:	6a 2e                	push   $0x2e
  jmp alltraps
80106399:	e9 4c f9 ff ff       	jmp    80105cea <alltraps>

8010639e <vector47>:
.globl vector47
vector47:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $47
801063a0:	6a 2f                	push   $0x2f
  jmp alltraps
801063a2:	e9 43 f9 ff ff       	jmp    80105cea <alltraps>

801063a7 <vector48>:
.globl vector48
vector48:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $48
801063a9:	6a 30                	push   $0x30
  jmp alltraps
801063ab:	e9 3a f9 ff ff       	jmp    80105cea <alltraps>

801063b0 <vector49>:
.globl vector49
vector49:
  pushl $0
801063b0:	6a 00                	push   $0x0
  pushl $49
801063b2:	6a 31                	push   $0x31
  jmp alltraps
801063b4:	e9 31 f9 ff ff       	jmp    80105cea <alltraps>

801063b9 <vector50>:
.globl vector50
vector50:
  pushl $0
801063b9:	6a 00                	push   $0x0
  pushl $50
801063bb:	6a 32                	push   $0x32
  jmp alltraps
801063bd:	e9 28 f9 ff ff       	jmp    80105cea <alltraps>

801063c2 <vector51>:
.globl vector51
vector51:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $51
801063c4:	6a 33                	push   $0x33
  jmp alltraps
801063c6:	e9 1f f9 ff ff       	jmp    80105cea <alltraps>

801063cb <vector52>:
.globl vector52
vector52:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $52
801063cd:	6a 34                	push   $0x34
  jmp alltraps
801063cf:	e9 16 f9 ff ff       	jmp    80105cea <alltraps>

801063d4 <vector53>:
.globl vector53
vector53:
  pushl $0
801063d4:	6a 00                	push   $0x0
  pushl $53
801063d6:	6a 35                	push   $0x35
  jmp alltraps
801063d8:	e9 0d f9 ff ff       	jmp    80105cea <alltraps>

801063dd <vector54>:
.globl vector54
vector54:
  pushl $0
801063dd:	6a 00                	push   $0x0
  pushl $54
801063df:	6a 36                	push   $0x36
  jmp alltraps
801063e1:	e9 04 f9 ff ff       	jmp    80105cea <alltraps>

801063e6 <vector55>:
.globl vector55
vector55:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $55
801063e8:	6a 37                	push   $0x37
  jmp alltraps
801063ea:	e9 fb f8 ff ff       	jmp    80105cea <alltraps>

801063ef <vector56>:
.globl vector56
vector56:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $56
801063f1:	6a 38                	push   $0x38
  jmp alltraps
801063f3:	e9 f2 f8 ff ff       	jmp    80105cea <alltraps>

801063f8 <vector57>:
.globl vector57
vector57:
  pushl $0
801063f8:	6a 00                	push   $0x0
  pushl $57
801063fa:	6a 39                	push   $0x39
  jmp alltraps
801063fc:	e9 e9 f8 ff ff       	jmp    80105cea <alltraps>

80106401 <vector58>:
.globl vector58
vector58:
  pushl $0
80106401:	6a 00                	push   $0x0
  pushl $58
80106403:	6a 3a                	push   $0x3a
  jmp alltraps
80106405:	e9 e0 f8 ff ff       	jmp    80105cea <alltraps>

8010640a <vector59>:
.globl vector59
vector59:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $59
8010640c:	6a 3b                	push   $0x3b
  jmp alltraps
8010640e:	e9 d7 f8 ff ff       	jmp    80105cea <alltraps>

80106413 <vector60>:
.globl vector60
vector60:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $60
80106415:	6a 3c                	push   $0x3c
  jmp alltraps
80106417:	e9 ce f8 ff ff       	jmp    80105cea <alltraps>

8010641c <vector61>:
.globl vector61
vector61:
  pushl $0
8010641c:	6a 00                	push   $0x0
  pushl $61
8010641e:	6a 3d                	push   $0x3d
  jmp alltraps
80106420:	e9 c5 f8 ff ff       	jmp    80105cea <alltraps>

80106425 <vector62>:
.globl vector62
vector62:
  pushl $0
80106425:	6a 00                	push   $0x0
  pushl $62
80106427:	6a 3e                	push   $0x3e
  jmp alltraps
80106429:	e9 bc f8 ff ff       	jmp    80105cea <alltraps>

8010642e <vector63>:
.globl vector63
vector63:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $63
80106430:	6a 3f                	push   $0x3f
  jmp alltraps
80106432:	e9 b3 f8 ff ff       	jmp    80105cea <alltraps>

80106437 <vector64>:
.globl vector64
vector64:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $64
80106439:	6a 40                	push   $0x40
  jmp alltraps
8010643b:	e9 aa f8 ff ff       	jmp    80105cea <alltraps>

80106440 <vector65>:
.globl vector65
vector65:
  pushl $0
80106440:	6a 00                	push   $0x0
  pushl $65
80106442:	6a 41                	push   $0x41
  jmp alltraps
80106444:	e9 a1 f8 ff ff       	jmp    80105cea <alltraps>

80106449 <vector66>:
.globl vector66
vector66:
  pushl $0
80106449:	6a 00                	push   $0x0
  pushl $66
8010644b:	6a 42                	push   $0x42
  jmp alltraps
8010644d:	e9 98 f8 ff ff       	jmp    80105cea <alltraps>

80106452 <vector67>:
.globl vector67
vector67:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $67
80106454:	6a 43                	push   $0x43
  jmp alltraps
80106456:	e9 8f f8 ff ff       	jmp    80105cea <alltraps>

8010645b <vector68>:
.globl vector68
vector68:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $68
8010645d:	6a 44                	push   $0x44
  jmp alltraps
8010645f:	e9 86 f8 ff ff       	jmp    80105cea <alltraps>

80106464 <vector69>:
.globl vector69
vector69:
  pushl $0
80106464:	6a 00                	push   $0x0
  pushl $69
80106466:	6a 45                	push   $0x45
  jmp alltraps
80106468:	e9 7d f8 ff ff       	jmp    80105cea <alltraps>

8010646d <vector70>:
.globl vector70
vector70:
  pushl $0
8010646d:	6a 00                	push   $0x0
  pushl $70
8010646f:	6a 46                	push   $0x46
  jmp alltraps
80106471:	e9 74 f8 ff ff       	jmp    80105cea <alltraps>

80106476 <vector71>:
.globl vector71
vector71:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $71
80106478:	6a 47                	push   $0x47
  jmp alltraps
8010647a:	e9 6b f8 ff ff       	jmp    80105cea <alltraps>

8010647f <vector72>:
.globl vector72
vector72:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $72
80106481:	6a 48                	push   $0x48
  jmp alltraps
80106483:	e9 62 f8 ff ff       	jmp    80105cea <alltraps>

80106488 <vector73>:
.globl vector73
vector73:
  pushl $0
80106488:	6a 00                	push   $0x0
  pushl $73
8010648a:	6a 49                	push   $0x49
  jmp alltraps
8010648c:	e9 59 f8 ff ff       	jmp    80105cea <alltraps>

80106491 <vector74>:
.globl vector74
vector74:
  pushl $0
80106491:	6a 00                	push   $0x0
  pushl $74
80106493:	6a 4a                	push   $0x4a
  jmp alltraps
80106495:	e9 50 f8 ff ff       	jmp    80105cea <alltraps>

8010649a <vector75>:
.globl vector75
vector75:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $75
8010649c:	6a 4b                	push   $0x4b
  jmp alltraps
8010649e:	e9 47 f8 ff ff       	jmp    80105cea <alltraps>

801064a3 <vector76>:
.globl vector76
vector76:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $76
801064a5:	6a 4c                	push   $0x4c
  jmp alltraps
801064a7:	e9 3e f8 ff ff       	jmp    80105cea <alltraps>

801064ac <vector77>:
.globl vector77
vector77:
  pushl $0
801064ac:	6a 00                	push   $0x0
  pushl $77
801064ae:	6a 4d                	push   $0x4d
  jmp alltraps
801064b0:	e9 35 f8 ff ff       	jmp    80105cea <alltraps>

801064b5 <vector78>:
.globl vector78
vector78:
  pushl $0
801064b5:	6a 00                	push   $0x0
  pushl $78
801064b7:	6a 4e                	push   $0x4e
  jmp alltraps
801064b9:	e9 2c f8 ff ff       	jmp    80105cea <alltraps>

801064be <vector79>:
.globl vector79
vector79:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $79
801064c0:	6a 4f                	push   $0x4f
  jmp alltraps
801064c2:	e9 23 f8 ff ff       	jmp    80105cea <alltraps>

801064c7 <vector80>:
.globl vector80
vector80:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $80
801064c9:	6a 50                	push   $0x50
  jmp alltraps
801064cb:	e9 1a f8 ff ff       	jmp    80105cea <alltraps>

801064d0 <vector81>:
.globl vector81
vector81:
  pushl $0
801064d0:	6a 00                	push   $0x0
  pushl $81
801064d2:	6a 51                	push   $0x51
  jmp alltraps
801064d4:	e9 11 f8 ff ff       	jmp    80105cea <alltraps>

801064d9 <vector82>:
.globl vector82
vector82:
  pushl $0
801064d9:	6a 00                	push   $0x0
  pushl $82
801064db:	6a 52                	push   $0x52
  jmp alltraps
801064dd:	e9 08 f8 ff ff       	jmp    80105cea <alltraps>

801064e2 <vector83>:
.globl vector83
vector83:
  pushl $0
801064e2:	6a 00                	push   $0x0
  pushl $83
801064e4:	6a 53                	push   $0x53
  jmp alltraps
801064e6:	e9 ff f7 ff ff       	jmp    80105cea <alltraps>

801064eb <vector84>:
.globl vector84
vector84:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $84
801064ed:	6a 54                	push   $0x54
  jmp alltraps
801064ef:	e9 f6 f7 ff ff       	jmp    80105cea <alltraps>

801064f4 <vector85>:
.globl vector85
vector85:
  pushl $0
801064f4:	6a 00                	push   $0x0
  pushl $85
801064f6:	6a 55                	push   $0x55
  jmp alltraps
801064f8:	e9 ed f7 ff ff       	jmp    80105cea <alltraps>

801064fd <vector86>:
.globl vector86
vector86:
  pushl $0
801064fd:	6a 00                	push   $0x0
  pushl $86
801064ff:	6a 56                	push   $0x56
  jmp alltraps
80106501:	e9 e4 f7 ff ff       	jmp    80105cea <alltraps>

80106506 <vector87>:
.globl vector87
vector87:
  pushl $0
80106506:	6a 00                	push   $0x0
  pushl $87
80106508:	6a 57                	push   $0x57
  jmp alltraps
8010650a:	e9 db f7 ff ff       	jmp    80105cea <alltraps>

8010650f <vector88>:
.globl vector88
vector88:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $88
80106511:	6a 58                	push   $0x58
  jmp alltraps
80106513:	e9 d2 f7 ff ff       	jmp    80105cea <alltraps>

80106518 <vector89>:
.globl vector89
vector89:
  pushl $0
80106518:	6a 00                	push   $0x0
  pushl $89
8010651a:	6a 59                	push   $0x59
  jmp alltraps
8010651c:	e9 c9 f7 ff ff       	jmp    80105cea <alltraps>

80106521 <vector90>:
.globl vector90
vector90:
  pushl $0
80106521:	6a 00                	push   $0x0
  pushl $90
80106523:	6a 5a                	push   $0x5a
  jmp alltraps
80106525:	e9 c0 f7 ff ff       	jmp    80105cea <alltraps>

8010652a <vector91>:
.globl vector91
vector91:
  pushl $0
8010652a:	6a 00                	push   $0x0
  pushl $91
8010652c:	6a 5b                	push   $0x5b
  jmp alltraps
8010652e:	e9 b7 f7 ff ff       	jmp    80105cea <alltraps>

80106533 <vector92>:
.globl vector92
vector92:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $92
80106535:	6a 5c                	push   $0x5c
  jmp alltraps
80106537:	e9 ae f7 ff ff       	jmp    80105cea <alltraps>

8010653c <vector93>:
.globl vector93
vector93:
  pushl $0
8010653c:	6a 00                	push   $0x0
  pushl $93
8010653e:	6a 5d                	push   $0x5d
  jmp alltraps
80106540:	e9 a5 f7 ff ff       	jmp    80105cea <alltraps>

80106545 <vector94>:
.globl vector94
vector94:
  pushl $0
80106545:	6a 00                	push   $0x0
  pushl $94
80106547:	6a 5e                	push   $0x5e
  jmp alltraps
80106549:	e9 9c f7 ff ff       	jmp    80105cea <alltraps>

8010654e <vector95>:
.globl vector95
vector95:
  pushl $0
8010654e:	6a 00                	push   $0x0
  pushl $95
80106550:	6a 5f                	push   $0x5f
  jmp alltraps
80106552:	e9 93 f7 ff ff       	jmp    80105cea <alltraps>

80106557 <vector96>:
.globl vector96
vector96:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $96
80106559:	6a 60                	push   $0x60
  jmp alltraps
8010655b:	e9 8a f7 ff ff       	jmp    80105cea <alltraps>

80106560 <vector97>:
.globl vector97
vector97:
  pushl $0
80106560:	6a 00                	push   $0x0
  pushl $97
80106562:	6a 61                	push   $0x61
  jmp alltraps
80106564:	e9 81 f7 ff ff       	jmp    80105cea <alltraps>

80106569 <vector98>:
.globl vector98
vector98:
  pushl $0
80106569:	6a 00                	push   $0x0
  pushl $98
8010656b:	6a 62                	push   $0x62
  jmp alltraps
8010656d:	e9 78 f7 ff ff       	jmp    80105cea <alltraps>

80106572 <vector99>:
.globl vector99
vector99:
  pushl $0
80106572:	6a 00                	push   $0x0
  pushl $99
80106574:	6a 63                	push   $0x63
  jmp alltraps
80106576:	e9 6f f7 ff ff       	jmp    80105cea <alltraps>

8010657b <vector100>:
.globl vector100
vector100:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $100
8010657d:	6a 64                	push   $0x64
  jmp alltraps
8010657f:	e9 66 f7 ff ff       	jmp    80105cea <alltraps>

80106584 <vector101>:
.globl vector101
vector101:
  pushl $0
80106584:	6a 00                	push   $0x0
  pushl $101
80106586:	6a 65                	push   $0x65
  jmp alltraps
80106588:	e9 5d f7 ff ff       	jmp    80105cea <alltraps>

8010658d <vector102>:
.globl vector102
vector102:
  pushl $0
8010658d:	6a 00                	push   $0x0
  pushl $102
8010658f:	6a 66                	push   $0x66
  jmp alltraps
80106591:	e9 54 f7 ff ff       	jmp    80105cea <alltraps>

80106596 <vector103>:
.globl vector103
vector103:
  pushl $0
80106596:	6a 00                	push   $0x0
  pushl $103
80106598:	6a 67                	push   $0x67
  jmp alltraps
8010659a:	e9 4b f7 ff ff       	jmp    80105cea <alltraps>

8010659f <vector104>:
.globl vector104
vector104:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $104
801065a1:	6a 68                	push   $0x68
  jmp alltraps
801065a3:	e9 42 f7 ff ff       	jmp    80105cea <alltraps>

801065a8 <vector105>:
.globl vector105
vector105:
  pushl $0
801065a8:	6a 00                	push   $0x0
  pushl $105
801065aa:	6a 69                	push   $0x69
  jmp alltraps
801065ac:	e9 39 f7 ff ff       	jmp    80105cea <alltraps>

801065b1 <vector106>:
.globl vector106
vector106:
  pushl $0
801065b1:	6a 00                	push   $0x0
  pushl $106
801065b3:	6a 6a                	push   $0x6a
  jmp alltraps
801065b5:	e9 30 f7 ff ff       	jmp    80105cea <alltraps>

801065ba <vector107>:
.globl vector107
vector107:
  pushl $0
801065ba:	6a 00                	push   $0x0
  pushl $107
801065bc:	6a 6b                	push   $0x6b
  jmp alltraps
801065be:	e9 27 f7 ff ff       	jmp    80105cea <alltraps>

801065c3 <vector108>:
.globl vector108
vector108:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $108
801065c5:	6a 6c                	push   $0x6c
  jmp alltraps
801065c7:	e9 1e f7 ff ff       	jmp    80105cea <alltraps>

801065cc <vector109>:
.globl vector109
vector109:
  pushl $0
801065cc:	6a 00                	push   $0x0
  pushl $109
801065ce:	6a 6d                	push   $0x6d
  jmp alltraps
801065d0:	e9 15 f7 ff ff       	jmp    80105cea <alltraps>

801065d5 <vector110>:
.globl vector110
vector110:
  pushl $0
801065d5:	6a 00                	push   $0x0
  pushl $110
801065d7:	6a 6e                	push   $0x6e
  jmp alltraps
801065d9:	e9 0c f7 ff ff       	jmp    80105cea <alltraps>

801065de <vector111>:
.globl vector111
vector111:
  pushl $0
801065de:	6a 00                	push   $0x0
  pushl $111
801065e0:	6a 6f                	push   $0x6f
  jmp alltraps
801065e2:	e9 03 f7 ff ff       	jmp    80105cea <alltraps>

801065e7 <vector112>:
.globl vector112
vector112:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $112
801065e9:	6a 70                	push   $0x70
  jmp alltraps
801065eb:	e9 fa f6 ff ff       	jmp    80105cea <alltraps>

801065f0 <vector113>:
.globl vector113
vector113:
  pushl $0
801065f0:	6a 00                	push   $0x0
  pushl $113
801065f2:	6a 71                	push   $0x71
  jmp alltraps
801065f4:	e9 f1 f6 ff ff       	jmp    80105cea <alltraps>

801065f9 <vector114>:
.globl vector114
vector114:
  pushl $0
801065f9:	6a 00                	push   $0x0
  pushl $114
801065fb:	6a 72                	push   $0x72
  jmp alltraps
801065fd:	e9 e8 f6 ff ff       	jmp    80105cea <alltraps>

80106602 <vector115>:
.globl vector115
vector115:
  pushl $0
80106602:	6a 00                	push   $0x0
  pushl $115
80106604:	6a 73                	push   $0x73
  jmp alltraps
80106606:	e9 df f6 ff ff       	jmp    80105cea <alltraps>

8010660b <vector116>:
.globl vector116
vector116:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $116
8010660d:	6a 74                	push   $0x74
  jmp alltraps
8010660f:	e9 d6 f6 ff ff       	jmp    80105cea <alltraps>

80106614 <vector117>:
.globl vector117
vector117:
  pushl $0
80106614:	6a 00                	push   $0x0
  pushl $117
80106616:	6a 75                	push   $0x75
  jmp alltraps
80106618:	e9 cd f6 ff ff       	jmp    80105cea <alltraps>

8010661d <vector118>:
.globl vector118
vector118:
  pushl $0
8010661d:	6a 00                	push   $0x0
  pushl $118
8010661f:	6a 76                	push   $0x76
  jmp alltraps
80106621:	e9 c4 f6 ff ff       	jmp    80105cea <alltraps>

80106626 <vector119>:
.globl vector119
vector119:
  pushl $0
80106626:	6a 00                	push   $0x0
  pushl $119
80106628:	6a 77                	push   $0x77
  jmp alltraps
8010662a:	e9 bb f6 ff ff       	jmp    80105cea <alltraps>

8010662f <vector120>:
.globl vector120
vector120:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $120
80106631:	6a 78                	push   $0x78
  jmp alltraps
80106633:	e9 b2 f6 ff ff       	jmp    80105cea <alltraps>

80106638 <vector121>:
.globl vector121
vector121:
  pushl $0
80106638:	6a 00                	push   $0x0
  pushl $121
8010663a:	6a 79                	push   $0x79
  jmp alltraps
8010663c:	e9 a9 f6 ff ff       	jmp    80105cea <alltraps>

80106641 <vector122>:
.globl vector122
vector122:
  pushl $0
80106641:	6a 00                	push   $0x0
  pushl $122
80106643:	6a 7a                	push   $0x7a
  jmp alltraps
80106645:	e9 a0 f6 ff ff       	jmp    80105cea <alltraps>

8010664a <vector123>:
.globl vector123
vector123:
  pushl $0
8010664a:	6a 00                	push   $0x0
  pushl $123
8010664c:	6a 7b                	push   $0x7b
  jmp alltraps
8010664e:	e9 97 f6 ff ff       	jmp    80105cea <alltraps>

80106653 <vector124>:
.globl vector124
vector124:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $124
80106655:	6a 7c                	push   $0x7c
  jmp alltraps
80106657:	e9 8e f6 ff ff       	jmp    80105cea <alltraps>

8010665c <vector125>:
.globl vector125
vector125:
  pushl $0
8010665c:	6a 00                	push   $0x0
  pushl $125
8010665e:	6a 7d                	push   $0x7d
  jmp alltraps
80106660:	e9 85 f6 ff ff       	jmp    80105cea <alltraps>

80106665 <vector126>:
.globl vector126
vector126:
  pushl $0
80106665:	6a 00                	push   $0x0
  pushl $126
80106667:	6a 7e                	push   $0x7e
  jmp alltraps
80106669:	e9 7c f6 ff ff       	jmp    80105cea <alltraps>

8010666e <vector127>:
.globl vector127
vector127:
  pushl $0
8010666e:	6a 00                	push   $0x0
  pushl $127
80106670:	6a 7f                	push   $0x7f
  jmp alltraps
80106672:	e9 73 f6 ff ff       	jmp    80105cea <alltraps>

80106677 <vector128>:
.globl vector128
vector128:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $128
80106679:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010667e:	e9 67 f6 ff ff       	jmp    80105cea <alltraps>

80106683 <vector129>:
.globl vector129
vector129:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $129
80106685:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010668a:	e9 5b f6 ff ff       	jmp    80105cea <alltraps>

8010668f <vector130>:
.globl vector130
vector130:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $130
80106691:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106696:	e9 4f f6 ff ff       	jmp    80105cea <alltraps>

8010669b <vector131>:
.globl vector131
vector131:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $131
8010669d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801066a2:	e9 43 f6 ff ff       	jmp    80105cea <alltraps>

801066a7 <vector132>:
.globl vector132
vector132:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $132
801066a9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801066ae:	e9 37 f6 ff ff       	jmp    80105cea <alltraps>

801066b3 <vector133>:
.globl vector133
vector133:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $133
801066b5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801066ba:	e9 2b f6 ff ff       	jmp    80105cea <alltraps>

801066bf <vector134>:
.globl vector134
vector134:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $134
801066c1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801066c6:	e9 1f f6 ff ff       	jmp    80105cea <alltraps>

801066cb <vector135>:
.globl vector135
vector135:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $135
801066cd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801066d2:	e9 13 f6 ff ff       	jmp    80105cea <alltraps>

801066d7 <vector136>:
.globl vector136
vector136:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $136
801066d9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801066de:	e9 07 f6 ff ff       	jmp    80105cea <alltraps>

801066e3 <vector137>:
.globl vector137
vector137:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $137
801066e5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801066ea:	e9 fb f5 ff ff       	jmp    80105cea <alltraps>

801066ef <vector138>:
.globl vector138
vector138:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $138
801066f1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801066f6:	e9 ef f5 ff ff       	jmp    80105cea <alltraps>

801066fb <vector139>:
.globl vector139
vector139:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $139
801066fd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106702:	e9 e3 f5 ff ff       	jmp    80105cea <alltraps>

80106707 <vector140>:
.globl vector140
vector140:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $140
80106709:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010670e:	e9 d7 f5 ff ff       	jmp    80105cea <alltraps>

80106713 <vector141>:
.globl vector141
vector141:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $141
80106715:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010671a:	e9 cb f5 ff ff       	jmp    80105cea <alltraps>

8010671f <vector142>:
.globl vector142
vector142:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $142
80106721:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106726:	e9 bf f5 ff ff       	jmp    80105cea <alltraps>

8010672b <vector143>:
.globl vector143
vector143:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $143
8010672d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106732:	e9 b3 f5 ff ff       	jmp    80105cea <alltraps>

80106737 <vector144>:
.globl vector144
vector144:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $144
80106739:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010673e:	e9 a7 f5 ff ff       	jmp    80105cea <alltraps>

80106743 <vector145>:
.globl vector145
vector145:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $145
80106745:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010674a:	e9 9b f5 ff ff       	jmp    80105cea <alltraps>

8010674f <vector146>:
.globl vector146
vector146:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $146
80106751:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106756:	e9 8f f5 ff ff       	jmp    80105cea <alltraps>

8010675b <vector147>:
.globl vector147
vector147:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $147
8010675d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106762:	e9 83 f5 ff ff       	jmp    80105cea <alltraps>

80106767 <vector148>:
.globl vector148
vector148:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $148
80106769:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010676e:	e9 77 f5 ff ff       	jmp    80105cea <alltraps>

80106773 <vector149>:
.globl vector149
vector149:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $149
80106775:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010677a:	e9 6b f5 ff ff       	jmp    80105cea <alltraps>

8010677f <vector150>:
.globl vector150
vector150:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $150
80106781:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106786:	e9 5f f5 ff ff       	jmp    80105cea <alltraps>

8010678b <vector151>:
.globl vector151
vector151:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $151
8010678d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106792:	e9 53 f5 ff ff       	jmp    80105cea <alltraps>

80106797 <vector152>:
.globl vector152
vector152:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $152
80106799:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010679e:	e9 47 f5 ff ff       	jmp    80105cea <alltraps>

801067a3 <vector153>:
.globl vector153
vector153:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $153
801067a5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801067aa:	e9 3b f5 ff ff       	jmp    80105cea <alltraps>

801067af <vector154>:
.globl vector154
vector154:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $154
801067b1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801067b6:	e9 2f f5 ff ff       	jmp    80105cea <alltraps>

801067bb <vector155>:
.globl vector155
vector155:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $155
801067bd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801067c2:	e9 23 f5 ff ff       	jmp    80105cea <alltraps>

801067c7 <vector156>:
.globl vector156
vector156:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $156
801067c9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801067ce:	e9 17 f5 ff ff       	jmp    80105cea <alltraps>

801067d3 <vector157>:
.globl vector157
vector157:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $157
801067d5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801067da:	e9 0b f5 ff ff       	jmp    80105cea <alltraps>

801067df <vector158>:
.globl vector158
vector158:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $158
801067e1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801067e6:	e9 ff f4 ff ff       	jmp    80105cea <alltraps>

801067eb <vector159>:
.globl vector159
vector159:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $159
801067ed:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801067f2:	e9 f3 f4 ff ff       	jmp    80105cea <alltraps>

801067f7 <vector160>:
.globl vector160
vector160:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $160
801067f9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801067fe:	e9 e7 f4 ff ff       	jmp    80105cea <alltraps>

80106803 <vector161>:
.globl vector161
vector161:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $161
80106805:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010680a:	e9 db f4 ff ff       	jmp    80105cea <alltraps>

8010680f <vector162>:
.globl vector162
vector162:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $162
80106811:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106816:	e9 cf f4 ff ff       	jmp    80105cea <alltraps>

8010681b <vector163>:
.globl vector163
vector163:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $163
8010681d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106822:	e9 c3 f4 ff ff       	jmp    80105cea <alltraps>

80106827 <vector164>:
.globl vector164
vector164:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $164
80106829:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010682e:	e9 b7 f4 ff ff       	jmp    80105cea <alltraps>

80106833 <vector165>:
.globl vector165
vector165:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $165
80106835:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010683a:	e9 ab f4 ff ff       	jmp    80105cea <alltraps>

8010683f <vector166>:
.globl vector166
vector166:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $166
80106841:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106846:	e9 9f f4 ff ff       	jmp    80105cea <alltraps>

8010684b <vector167>:
.globl vector167
vector167:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $167
8010684d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106852:	e9 93 f4 ff ff       	jmp    80105cea <alltraps>

80106857 <vector168>:
.globl vector168
vector168:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $168
80106859:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010685e:	e9 87 f4 ff ff       	jmp    80105cea <alltraps>

80106863 <vector169>:
.globl vector169
vector169:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $169
80106865:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010686a:	e9 7b f4 ff ff       	jmp    80105cea <alltraps>

8010686f <vector170>:
.globl vector170
vector170:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $170
80106871:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106876:	e9 6f f4 ff ff       	jmp    80105cea <alltraps>

8010687b <vector171>:
.globl vector171
vector171:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $171
8010687d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106882:	e9 63 f4 ff ff       	jmp    80105cea <alltraps>

80106887 <vector172>:
.globl vector172
vector172:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $172
80106889:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010688e:	e9 57 f4 ff ff       	jmp    80105cea <alltraps>

80106893 <vector173>:
.globl vector173
vector173:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $173
80106895:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010689a:	e9 4b f4 ff ff       	jmp    80105cea <alltraps>

8010689f <vector174>:
.globl vector174
vector174:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $174
801068a1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801068a6:	e9 3f f4 ff ff       	jmp    80105cea <alltraps>

801068ab <vector175>:
.globl vector175
vector175:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $175
801068ad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801068b2:	e9 33 f4 ff ff       	jmp    80105cea <alltraps>

801068b7 <vector176>:
.globl vector176
vector176:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $176
801068b9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801068be:	e9 27 f4 ff ff       	jmp    80105cea <alltraps>

801068c3 <vector177>:
.globl vector177
vector177:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $177
801068c5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801068ca:	e9 1b f4 ff ff       	jmp    80105cea <alltraps>

801068cf <vector178>:
.globl vector178
vector178:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $178
801068d1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801068d6:	e9 0f f4 ff ff       	jmp    80105cea <alltraps>

801068db <vector179>:
.globl vector179
vector179:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $179
801068dd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801068e2:	e9 03 f4 ff ff       	jmp    80105cea <alltraps>

801068e7 <vector180>:
.globl vector180
vector180:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $180
801068e9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801068ee:	e9 f7 f3 ff ff       	jmp    80105cea <alltraps>

801068f3 <vector181>:
.globl vector181
vector181:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $181
801068f5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801068fa:	e9 eb f3 ff ff       	jmp    80105cea <alltraps>

801068ff <vector182>:
.globl vector182
vector182:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $182
80106901:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106906:	e9 df f3 ff ff       	jmp    80105cea <alltraps>

8010690b <vector183>:
.globl vector183
vector183:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $183
8010690d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106912:	e9 d3 f3 ff ff       	jmp    80105cea <alltraps>

80106917 <vector184>:
.globl vector184
vector184:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $184
80106919:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010691e:	e9 c7 f3 ff ff       	jmp    80105cea <alltraps>

80106923 <vector185>:
.globl vector185
vector185:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $185
80106925:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010692a:	e9 bb f3 ff ff       	jmp    80105cea <alltraps>

8010692f <vector186>:
.globl vector186
vector186:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $186
80106931:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106936:	e9 af f3 ff ff       	jmp    80105cea <alltraps>

8010693b <vector187>:
.globl vector187
vector187:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $187
8010693d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106942:	e9 a3 f3 ff ff       	jmp    80105cea <alltraps>

80106947 <vector188>:
.globl vector188
vector188:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $188
80106949:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010694e:	e9 97 f3 ff ff       	jmp    80105cea <alltraps>

80106953 <vector189>:
.globl vector189
vector189:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $189
80106955:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010695a:	e9 8b f3 ff ff       	jmp    80105cea <alltraps>

8010695f <vector190>:
.globl vector190
vector190:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $190
80106961:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106966:	e9 7f f3 ff ff       	jmp    80105cea <alltraps>

8010696b <vector191>:
.globl vector191
vector191:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $191
8010696d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106972:	e9 73 f3 ff ff       	jmp    80105cea <alltraps>

80106977 <vector192>:
.globl vector192
vector192:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $192
80106979:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010697e:	e9 67 f3 ff ff       	jmp    80105cea <alltraps>

80106983 <vector193>:
.globl vector193
vector193:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $193
80106985:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010698a:	e9 5b f3 ff ff       	jmp    80105cea <alltraps>

8010698f <vector194>:
.globl vector194
vector194:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $194
80106991:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106996:	e9 4f f3 ff ff       	jmp    80105cea <alltraps>

8010699b <vector195>:
.globl vector195
vector195:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $195
8010699d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801069a2:	e9 43 f3 ff ff       	jmp    80105cea <alltraps>

801069a7 <vector196>:
.globl vector196
vector196:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $196
801069a9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801069ae:	e9 37 f3 ff ff       	jmp    80105cea <alltraps>

801069b3 <vector197>:
.globl vector197
vector197:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $197
801069b5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801069ba:	e9 2b f3 ff ff       	jmp    80105cea <alltraps>

801069bf <vector198>:
.globl vector198
vector198:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $198
801069c1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801069c6:	e9 1f f3 ff ff       	jmp    80105cea <alltraps>

801069cb <vector199>:
.globl vector199
vector199:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $199
801069cd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801069d2:	e9 13 f3 ff ff       	jmp    80105cea <alltraps>

801069d7 <vector200>:
.globl vector200
vector200:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $200
801069d9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801069de:	e9 07 f3 ff ff       	jmp    80105cea <alltraps>

801069e3 <vector201>:
.globl vector201
vector201:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $201
801069e5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801069ea:	e9 fb f2 ff ff       	jmp    80105cea <alltraps>

801069ef <vector202>:
.globl vector202
vector202:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $202
801069f1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801069f6:	e9 ef f2 ff ff       	jmp    80105cea <alltraps>

801069fb <vector203>:
.globl vector203
vector203:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $203
801069fd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a02:	e9 e3 f2 ff ff       	jmp    80105cea <alltraps>

80106a07 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $204
80106a09:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a0e:	e9 d7 f2 ff ff       	jmp    80105cea <alltraps>

80106a13 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $205
80106a15:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a1a:	e9 cb f2 ff ff       	jmp    80105cea <alltraps>

80106a1f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $206
80106a21:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a26:	e9 bf f2 ff ff       	jmp    80105cea <alltraps>

80106a2b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $207
80106a2d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a32:	e9 b3 f2 ff ff       	jmp    80105cea <alltraps>

80106a37 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $208
80106a39:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a3e:	e9 a7 f2 ff ff       	jmp    80105cea <alltraps>

80106a43 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $209
80106a45:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a4a:	e9 9b f2 ff ff       	jmp    80105cea <alltraps>

80106a4f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $210
80106a51:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a56:	e9 8f f2 ff ff       	jmp    80105cea <alltraps>

80106a5b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $211
80106a5d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a62:	e9 83 f2 ff ff       	jmp    80105cea <alltraps>

80106a67 <vector212>:
.globl vector212
vector212:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $212
80106a69:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a6e:	e9 77 f2 ff ff       	jmp    80105cea <alltraps>

80106a73 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $213
80106a75:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a7a:	e9 6b f2 ff ff       	jmp    80105cea <alltraps>

80106a7f <vector214>:
.globl vector214
vector214:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $214
80106a81:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a86:	e9 5f f2 ff ff       	jmp    80105cea <alltraps>

80106a8b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $215
80106a8d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a92:	e9 53 f2 ff ff       	jmp    80105cea <alltraps>

80106a97 <vector216>:
.globl vector216
vector216:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $216
80106a99:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a9e:	e9 47 f2 ff ff       	jmp    80105cea <alltraps>

80106aa3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $217
80106aa5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106aaa:	e9 3b f2 ff ff       	jmp    80105cea <alltraps>

80106aaf <vector218>:
.globl vector218
vector218:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $218
80106ab1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ab6:	e9 2f f2 ff ff       	jmp    80105cea <alltraps>

80106abb <vector219>:
.globl vector219
vector219:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $219
80106abd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ac2:	e9 23 f2 ff ff       	jmp    80105cea <alltraps>

80106ac7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $220
80106ac9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ace:	e9 17 f2 ff ff       	jmp    80105cea <alltraps>

80106ad3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $221
80106ad5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106ada:	e9 0b f2 ff ff       	jmp    80105cea <alltraps>

80106adf <vector222>:
.globl vector222
vector222:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $222
80106ae1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ae6:	e9 ff f1 ff ff       	jmp    80105cea <alltraps>

80106aeb <vector223>:
.globl vector223
vector223:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $223
80106aed:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106af2:	e9 f3 f1 ff ff       	jmp    80105cea <alltraps>

80106af7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $224
80106af9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106afe:	e9 e7 f1 ff ff       	jmp    80105cea <alltraps>

80106b03 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $225
80106b05:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b0a:	e9 db f1 ff ff       	jmp    80105cea <alltraps>

80106b0f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $226
80106b11:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b16:	e9 cf f1 ff ff       	jmp    80105cea <alltraps>

80106b1b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $227
80106b1d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b22:	e9 c3 f1 ff ff       	jmp    80105cea <alltraps>

80106b27 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $228
80106b29:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b2e:	e9 b7 f1 ff ff       	jmp    80105cea <alltraps>

80106b33 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $229
80106b35:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b3a:	e9 ab f1 ff ff       	jmp    80105cea <alltraps>

80106b3f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $230
80106b41:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b46:	e9 9f f1 ff ff       	jmp    80105cea <alltraps>

80106b4b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $231
80106b4d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b52:	e9 93 f1 ff ff       	jmp    80105cea <alltraps>

80106b57 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $232
80106b59:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b5e:	e9 87 f1 ff ff       	jmp    80105cea <alltraps>

80106b63 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $233
80106b65:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b6a:	e9 7b f1 ff ff       	jmp    80105cea <alltraps>

80106b6f <vector234>:
.globl vector234
vector234:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $234
80106b71:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b76:	e9 6f f1 ff ff       	jmp    80105cea <alltraps>

80106b7b <vector235>:
.globl vector235
vector235:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $235
80106b7d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b82:	e9 63 f1 ff ff       	jmp    80105cea <alltraps>

80106b87 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $236
80106b89:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b8e:	e9 57 f1 ff ff       	jmp    80105cea <alltraps>

80106b93 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $237
80106b95:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b9a:	e9 4b f1 ff ff       	jmp    80105cea <alltraps>

80106b9f <vector238>:
.globl vector238
vector238:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $238
80106ba1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106ba6:	e9 3f f1 ff ff       	jmp    80105cea <alltraps>

80106bab <vector239>:
.globl vector239
vector239:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $239
80106bad:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106bb2:	e9 33 f1 ff ff       	jmp    80105cea <alltraps>

80106bb7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $240
80106bb9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106bbe:	e9 27 f1 ff ff       	jmp    80105cea <alltraps>

80106bc3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $241
80106bc5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106bca:	e9 1b f1 ff ff       	jmp    80105cea <alltraps>

80106bcf <vector242>:
.globl vector242
vector242:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $242
80106bd1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106bd6:	e9 0f f1 ff ff       	jmp    80105cea <alltraps>

80106bdb <vector243>:
.globl vector243
vector243:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $243
80106bdd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106be2:	e9 03 f1 ff ff       	jmp    80105cea <alltraps>

80106be7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $244
80106be9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106bee:	e9 f7 f0 ff ff       	jmp    80105cea <alltraps>

80106bf3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $245
80106bf5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106bfa:	e9 eb f0 ff ff       	jmp    80105cea <alltraps>

80106bff <vector246>:
.globl vector246
vector246:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $246
80106c01:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c06:	e9 df f0 ff ff       	jmp    80105cea <alltraps>

80106c0b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $247
80106c0d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c12:	e9 d3 f0 ff ff       	jmp    80105cea <alltraps>

80106c17 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $248
80106c19:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c1e:	e9 c7 f0 ff ff       	jmp    80105cea <alltraps>

80106c23 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $249
80106c25:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c2a:	e9 bb f0 ff ff       	jmp    80105cea <alltraps>

80106c2f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $250
80106c31:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c36:	e9 af f0 ff ff       	jmp    80105cea <alltraps>

80106c3b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $251
80106c3d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c42:	e9 a3 f0 ff ff       	jmp    80105cea <alltraps>

80106c47 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $252
80106c49:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c4e:	e9 97 f0 ff ff       	jmp    80105cea <alltraps>

80106c53 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $253
80106c55:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c5a:	e9 8b f0 ff ff       	jmp    80105cea <alltraps>

80106c5f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $254
80106c61:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c66:	e9 7f f0 ff ff       	jmp    80105cea <alltraps>

80106c6b <vector255>:
.globl vector255
vector255:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $255
80106c6d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c72:	e9 73 f0 ff ff       	jmp    80105cea <alltraps>
80106c77:	66 90                	xchg   %ax,%ax
80106c79:	66 90                	xchg   %ax,%ax
80106c7b:	66 90                	xchg   %ax,%ax
80106c7d:	66 90                	xchg   %ax,%ax
80106c7f:	90                   	nop

80106c80 <deallocuvm_proc.part.0>:
    }
  }
  return newsz;
}
int
deallocuvm_proc(struct proc * p, pde_t *pgdir, uint oldsz, uint newsz)
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
80106c86:	83 ec 1c             	sub    $0x1c,%esp
80106c89:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c8c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c8f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106c95:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106c9b:	39 cb                	cmp    %ecx,%ebx
80106c9d:	73 7d                	jae    80106d1c <deallocuvm_proc.part.0+0x9c>
80106c9f:	89 d6                	mov    %edx,%esi
80106ca1:	89 cf                	mov    %ecx,%edi
80106ca3:	eb 0f                	jmp    80106cb4 <deallocuvm_proc.part.0+0x34>
80106ca5:	8d 76 00             	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106ca8:	83 c2 01             	add    $0x1,%edx
80106cab:	89 d3                	mov    %edx,%ebx
80106cad:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106cb0:	39 fb                	cmp    %edi,%ebx
80106cb2:	73 68                	jae    80106d1c <deallocuvm_proc.part.0+0x9c>
  pde = &pgdir[PDX(va)];
80106cb4:	89 da                	mov    %ebx,%edx
80106cb6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106cb9:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106cbc:	a8 01                	test   $0x1,%al
80106cbe:	74 e8                	je     80106ca8 <deallocuvm_proc.part.0+0x28>
  return &pgtab[PTX(va)];
80106cc0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cc2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106cc7:	c1 e9 0a             	shr    $0xa,%ecx
80106cca:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106cd0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106cd7:	85 c0                	test   %eax,%eax
80106cd9:	74 cd                	je     80106ca8 <deallocuvm_proc.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106cdb:	8b 10                	mov    (%eax),%edx
80106cdd:	f6 c2 01             	test   $0x1,%dl
80106ce0:	74 4e                	je     80106d30 <deallocuvm_proc.part.0+0xb0>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106ce2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106ce8:	74 64                	je     80106d4e <deallocuvm_proc.part.0+0xce>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106cea:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106ced:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106cf3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106cf6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106cfc:	52                   	push   %edx
80106cfd:	e8 9e b8 ff ff       	call   801025a0 <kfree>
      p->rss -= PGSIZE;
80106d02:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d05:	83 c4 10             	add    $0x10,%esp
80106d08:	81 68 04 00 10 00 00 	subl   $0x1000,0x4(%eax)
      *pte = 0;
80106d0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106d18:	39 fb                	cmp    %edi,%ebx
80106d1a:	72 98                	jb     80106cb4 <deallocuvm_proc.part.0+0x34>
        clear_slot(pte);
      }
    }
  }
  return newsz;
}
80106d1c:	8b 45 08             	mov    0x8(%ebp),%eax
80106d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d22:	5b                   	pop    %ebx
80106d23:	5e                   	pop    %esi
80106d24:	5f                   	pop    %edi
80106d25:	5d                   	pop    %ebp
80106d26:	c3                   	ret
80106d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d2e:	66 90                	xchg   %ax,%ax
      if(*pte & PTE_SW){
80106d30:	83 e2 08             	and    $0x8,%edx
80106d33:	75 0b                	jne    80106d40 <deallocuvm_proc.part.0+0xc0>
  for(; a  < oldsz; a += PGSIZE){
80106d35:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d3b:	e9 70 ff ff ff       	jmp    80106cb0 <deallocuvm_proc.part.0+0x30>
        clear_slot(pte);
80106d40:	83 ec 0c             	sub    $0xc,%esp
80106d43:	50                   	push   %eax
80106d44:	e8 27 0e 00 00       	call   80107b70 <clear_slot>
80106d49:	83 c4 10             	add    $0x10,%esp
80106d4c:	eb e7                	jmp    80106d35 <deallocuvm_proc.part.0+0xb5>
        panic("kfree");
80106d4e:	83 ec 0c             	sub    $0xc,%esp
80106d51:	68 0c 7f 10 80       	push   $0x80107f0c
80106d56:	e8 15 97 ff ff       	call   80100470 <panic>
80106d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d5f:	90                   	nop

80106d60 <deallocuvm.part.0>:
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	57                   	push   %edi
80106d64:	56                   	push   %esi
80106d65:	89 c6                	mov    %eax,%esi
80106d67:	89 c8                	mov    %ecx,%eax
80106d69:	53                   	push   %ebx
  a = PGROUNDUP(newsz);
80106d6a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106d70:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d76:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106d79:	39 d3                	cmp    %edx,%ebx
80106d7b:	0f 83 85 00 00 00    	jae    80106e06 <deallocuvm.part.0+0xa6>
80106d81:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106d84:	89 d7                	mov    %edx,%edi
80106d86:	eb 14                	jmp    80106d9c <deallocuvm.part.0+0x3c>
80106d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d8f:	90                   	nop
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d90:	83 c2 01             	add    $0x1,%edx
80106d93:	89 d3                	mov    %edx,%ebx
80106d95:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d98:	39 fb                	cmp    %edi,%ebx
80106d9a:	73 67                	jae    80106e03 <deallocuvm.part.0+0xa3>
  pde = &pgdir[PDX(va)];
80106d9c:	89 da                	mov    %ebx,%edx
80106d9e:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106da1:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106da4:	a8 01                	test   $0x1,%al
80106da6:	74 e8                	je     80106d90 <deallocuvm.part.0+0x30>
  return &pgtab[PTX(va)];
80106da8:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106daa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106daf:	c1 e9 0a             	shr    $0xa,%ecx
80106db2:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106db8:	8d 8c 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%ecx
    if(!pte)
80106dbf:	85 c9                	test   %ecx,%ecx
80106dc1:	74 cd                	je     80106d90 <deallocuvm.part.0+0x30>
    else if((*pte & PTE_P) != 0){
80106dc3:	8b 01                	mov    (%ecx),%eax
80106dc5:	a8 01                	test   $0x1,%al
80106dc7:	74 47                	je     80106e10 <deallocuvm.part.0+0xb0>
      if(pa == 0)
80106dc9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106dce:	74 74                	je     80106e44 <deallocuvm.part.0+0xe4>
      kfree(v);
80106dd0:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106dd3:	05 00 00 00 80       	add    $0x80000000,%eax
80106dd8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106ddb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106de1:	50                   	push   %eax
80106de2:	e8 b9 b7 ff ff       	call   801025a0 <kfree>
      myproc()->rss -= PGSIZE;
80106de7:	e8 54 cd ff ff       	call   80103b40 <myproc>
      *pte = 0;
80106dec:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106def:	83 c4 10             	add    $0x10,%esp
      myproc()->rss -= PGSIZE;
80106df2:	81 68 04 00 10 00 00 	subl   $0x1000,0x4(%eax)
      *pte = 0;
80106df9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
  for(; a  < oldsz; a += PGSIZE){
80106dff:	39 fb                	cmp    %edi,%ebx
80106e01:	72 99                	jb     80106d9c <deallocuvm.part.0+0x3c>
80106e03:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80106e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e09:	5b                   	pop    %ebx
80106e0a:	5e                   	pop    %esi
80106e0b:	5f                   	pop    %edi
80106e0c:	5d                   	pop    %ebp
80106e0d:	c3                   	ret
80106e0e:	66 90                	xchg   %ax,%ax
      if((*pte & PTE_SW)){
80106e10:	a8 08                	test   $0x8,%al
80106e12:	75 0c                	jne    80106e20 <deallocuvm.part.0+0xc0>
  for(; a  < oldsz; a += PGSIZE){
80106e14:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e1a:	e9 79 ff ff ff       	jmp    80106d98 <deallocuvm.part.0+0x38>
80106e1f:	90                   	nop
        int refcnt = dec_swap_slot_refcnt(pte);
80106e20:	83 ec 0c             	sub    $0xc,%esp
80106e23:	51                   	push   %ecx
80106e24:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106e27:	e8 74 0d 00 00       	call   80107ba0 <dec_swap_slot_refcnt>
        if(refcnt == 0){
80106e2c:	83 c4 10             	add    $0x10,%esp
80106e2f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e32:	85 c0                	test   %eax,%eax
80106e34:	75 de                	jne    80106e14 <deallocuvm.part.0+0xb4>
          clear_slot(pte);
80106e36:	83 ec 0c             	sub    $0xc,%esp
80106e39:	51                   	push   %ecx
80106e3a:	e8 31 0d 00 00       	call   80107b70 <clear_slot>
80106e3f:	83 c4 10             	add    $0x10,%esp
80106e42:	eb d0                	jmp    80106e14 <deallocuvm.part.0+0xb4>
        panic("kfree");
80106e44:	83 ec 0c             	sub    $0xc,%esp
80106e47:	68 0c 7f 10 80       	push   $0x80107f0c
80106e4c:	e8 1f 96 ff ff       	call   80100470 <panic>
80106e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e5f:	90                   	nop

80106e60 <mappages>:
{
80106e60:	55                   	push   %ebp
80106e61:	89 e5                	mov    %esp,%ebp
80106e63:	57                   	push   %edi
80106e64:	56                   	push   %esi
80106e65:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106e66:	89 d3                	mov    %edx,%ebx
80106e68:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106e6e:	83 ec 1c             	sub    $0x1c,%esp
80106e71:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e74:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106e78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e7d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106e80:	8b 45 08             	mov    0x8(%ebp),%eax
80106e83:	29 d8                	sub    %ebx,%eax
80106e85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e88:	eb 3f                	jmp    80106ec9 <mappages+0x69>
80106e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106e90:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106e97:	c1 ea 0a             	shr    $0xa,%edx
80106e9a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106ea0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ea7:	85 c0                	test   %eax,%eax
80106ea9:	74 75                	je     80106f20 <mappages+0xc0>
    if(*pte & PTE_P)
80106eab:	f6 00 01             	testb  $0x1,(%eax)
80106eae:	0f 85 86 00 00 00    	jne    80106f3a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106eb4:	0b 75 0c             	or     0xc(%ebp),%esi
80106eb7:	83 ce 01             	or     $0x1,%esi
80106eba:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106ebc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106ebf:	39 c3                	cmp    %eax,%ebx
80106ec1:	74 6d                	je     80106f30 <mappages+0xd0>
    a += PGSIZE;
80106ec3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106ec9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106ecc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106ecf:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106ed2:	89 d8                	mov    %ebx,%eax
80106ed4:	c1 e8 16             	shr    $0x16,%eax
80106ed7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106eda:	8b 07                	mov    (%edi),%eax
80106edc:	a8 01                	test   $0x1,%al
80106ede:	75 b0                	jne    80106e90 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ee0:	e8 db b8 ff ff       	call   801027c0 <kalloc>
80106ee5:	85 c0                	test   %eax,%eax
80106ee7:	74 37                	je     80106f20 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106ee9:	83 ec 04             	sub    $0x4,%esp
80106eec:	68 00 10 00 00       	push   $0x1000
80106ef1:	6a 00                	push   $0x0
80106ef3:	50                   	push   %eax
80106ef4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106ef7:	e8 34 dc ff ff       	call   80104b30 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106efc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106eff:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106f02:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106f08:	83 c8 07             	or     $0x7,%eax
80106f0b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106f0d:	89 d8                	mov    %ebx,%eax
80106f0f:	c1 e8 0a             	shr    $0xa,%eax
80106f12:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f17:	01 d0                	add    %edx,%eax
80106f19:	eb 90                	jmp    80106eab <mappages+0x4b>
80106f1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f1f:	90                   	nop
}
80106f20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f28:	5b                   	pop    %ebx
80106f29:	5e                   	pop    %esi
80106f2a:	5f                   	pop    %edi
80106f2b:	5d                   	pop    %ebp
80106f2c:	c3                   	ret
80106f2d:	8d 76 00             	lea    0x0(%esi),%esi
80106f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f33:	31 c0                	xor    %eax,%eax
}
80106f35:	5b                   	pop    %ebx
80106f36:	5e                   	pop    %esi
80106f37:	5f                   	pop    %edi
80106f38:	5d                   	pop    %ebp
80106f39:	c3                   	ret
      panic("remap");
80106f3a:	83 ec 0c             	sub    $0xc,%esp
80106f3d:	68 5c 81 10 80       	push   $0x8010815c
80106f42:	e8 29 95 ff ff       	call   80100470 <panic>
80106f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f4e:	66 90                	xchg   %ax,%ax

80106f50 <seginit>:
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106f56:	e8 c5 cb ff ff       	call   80103b20 <cpuid>
  pd[0] = size-1;
80106f5b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106f60:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106f66:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106f6a:	c7 80 38 38 11 80 ff 	movl   $0xffff,-0x7feec7c8(%eax)
80106f71:	ff 00 00 
80106f74:	c7 80 3c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7c4(%eax)
80106f7b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f7e:	c7 80 40 38 11 80 ff 	movl   $0xffff,-0x7feec7c0(%eax)
80106f85:	ff 00 00 
80106f88:	c7 80 44 38 11 80 00 	movl   $0xcf9200,-0x7feec7bc(%eax)
80106f8f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f92:	c7 80 48 38 11 80 ff 	movl   $0xffff,-0x7feec7b8(%eax)
80106f99:	ff 00 00 
80106f9c:	c7 80 4c 38 11 80 00 	movl   $0xcffa00,-0x7feec7b4(%eax)
80106fa3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106fa6:	c7 80 50 38 11 80 ff 	movl   $0xffff,-0x7feec7b0(%eax)
80106fad:	ff 00 00 
80106fb0:	c7 80 54 38 11 80 00 	movl   $0xcff200,-0x7feec7ac(%eax)
80106fb7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106fba:	05 30 38 11 80       	add    $0x80113830,%eax
  pd[1] = (uint)p;
80106fbf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106fc3:	c1 e8 10             	shr    $0x10,%eax
80106fc6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106fca:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106fcd:	0f 01 10             	lgdtl  (%eax)
}
80106fd0:	c9                   	leave
80106fd1:	c3                   	ret
80106fd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106fe0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106fe0:	a1 24 61 11 80       	mov    0x80116124,%eax
80106fe5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fea:	0f 22 d8             	mov    %eax,%cr3
}
80106fed:	c3                   	ret
80106fee:	66 90                	xchg   %ax,%ax

80106ff0 <switchuvm>:
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	57                   	push   %edi
80106ff4:	56                   	push   %esi
80106ff5:	53                   	push   %ebx
80106ff6:	83 ec 1c             	sub    $0x1c,%esp
80106ff9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106ffc:	85 f6                	test   %esi,%esi
80106ffe:	0f 84 cb 00 00 00    	je     801070cf <switchuvm+0xdf>
  if(p->kstack == 0)
80107004:	8b 46 0c             	mov    0xc(%esi),%eax
80107007:	85 c0                	test   %eax,%eax
80107009:	0f 84 da 00 00 00    	je     801070e9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010700f:	8b 46 08             	mov    0x8(%esi),%eax
80107012:	85 c0                	test   %eax,%eax
80107014:	0f 84 c2 00 00 00    	je     801070dc <switchuvm+0xec>
  pushcli();
8010701a:	e8 c1 d8 ff ff       	call   801048e0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010701f:	e8 ac ca ff ff       	call   80103ad0 <mycpu>
80107024:	89 c3                	mov    %eax,%ebx
80107026:	e8 a5 ca ff ff       	call   80103ad0 <mycpu>
8010702b:	89 c7                	mov    %eax,%edi
8010702d:	e8 9e ca ff ff       	call   80103ad0 <mycpu>
80107032:	83 c7 08             	add    $0x8,%edi
80107035:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107038:	e8 93 ca ff ff       	call   80103ad0 <mycpu>
8010703d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107040:	ba 67 00 00 00       	mov    $0x67,%edx
80107045:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010704c:	83 c0 08             	add    $0x8,%eax
8010704f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107056:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010705b:	83 c1 08             	add    $0x8,%ecx
8010705e:	c1 e8 18             	shr    $0x18,%eax
80107061:	c1 e9 10             	shr    $0x10,%ecx
80107064:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010706a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107070:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107075:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010707c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107081:	e8 4a ca ff ff       	call   80103ad0 <mycpu>
80107086:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010708d:	e8 3e ca ff ff       	call   80103ad0 <mycpu>
80107092:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107096:	8b 5e 0c             	mov    0xc(%esi),%ebx
80107099:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010709f:	e8 2c ca ff ff       	call   80103ad0 <mycpu>
801070a4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801070a7:	e8 24 ca ff ff       	call   80103ad0 <mycpu>
801070ac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801070b0:	b8 28 00 00 00       	mov    $0x28,%eax
801070b5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801070b8:	8b 46 08             	mov    0x8(%esi),%eax
801070bb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070c0:	0f 22 d8             	mov    %eax,%cr3
}
801070c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070c6:	5b                   	pop    %ebx
801070c7:	5e                   	pop    %esi
801070c8:	5f                   	pop    %edi
801070c9:	5d                   	pop    %ebp
  popcli();
801070ca:	e9 61 d8 ff ff       	jmp    80104930 <popcli>
    panic("switchuvm: no process");
801070cf:	83 ec 0c             	sub    $0xc,%esp
801070d2:	68 62 81 10 80       	push   $0x80108162
801070d7:	e8 94 93 ff ff       	call   80100470 <panic>
    panic("switchuvm: no pgdir");
801070dc:	83 ec 0c             	sub    $0xc,%esp
801070df:	68 8d 81 10 80       	push   $0x8010818d
801070e4:	e8 87 93 ff ff       	call   80100470 <panic>
    panic("switchuvm: no kstack");
801070e9:	83 ec 0c             	sub    $0xc,%esp
801070ec:	68 78 81 10 80       	push   $0x80108178
801070f1:	e8 7a 93 ff ff       	call   80100470 <panic>
801070f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070fd:	8d 76 00             	lea    0x0(%esi),%esi

80107100 <inituvm>:
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	57                   	push   %edi
80107104:	56                   	push   %esi
80107105:	53                   	push   %ebx
80107106:	83 ec 1c             	sub    $0x1c,%esp
80107109:	8b 45 08             	mov    0x8(%ebp),%eax
8010710c:	8b 75 10             	mov    0x10(%ebp),%esi
8010710f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80107112:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107115:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010711b:	77 49                	ja     80107166 <inituvm+0x66>
  mem = kalloc();
8010711d:	e8 9e b6 ff ff       	call   801027c0 <kalloc>
  memset(mem, 0, PGSIZE);
80107122:	83 ec 04             	sub    $0x4,%esp
80107125:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010712a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010712c:	6a 00                	push   $0x0
8010712e:	50                   	push   %eax
8010712f:	e8 fc d9 ff ff       	call   80104b30 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107134:	58                   	pop    %eax
80107135:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010713b:	5a                   	pop    %edx
8010713c:	6a 06                	push   $0x6
8010713e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107143:	31 d2                	xor    %edx,%edx
80107145:	50                   	push   %eax
80107146:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107149:	e8 12 fd ff ff       	call   80106e60 <mappages>
  memmove(mem, init, sz);
8010714e:	89 75 10             	mov    %esi,0x10(%ebp)
80107151:	83 c4 10             	add    $0x10,%esp
80107154:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107157:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010715a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010715d:	5b                   	pop    %ebx
8010715e:	5e                   	pop    %esi
8010715f:	5f                   	pop    %edi
80107160:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107161:	e9 5a da ff ff       	jmp    80104bc0 <memmove>
    panic("inituvm: more than a page");
80107166:	83 ec 0c             	sub    $0xc,%esp
80107169:	68 a1 81 10 80       	push   $0x801081a1
8010716e:	e8 fd 92 ff ff       	call   80100470 <panic>
80107173:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010717a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107180 <loaduvm>:
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	57                   	push   %edi
80107184:	56                   	push   %esi
80107185:	53                   	push   %ebx
80107186:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107189:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010718c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010718f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107195:	0f 85 a2 00 00 00    	jne    8010723d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
8010719b:	85 ff                	test   %edi,%edi
8010719d:	74 7d                	je     8010721c <loaduvm+0x9c>
8010719f:	90                   	nop
  pde = &pgdir[PDX(va)];
801071a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801071a3:	8b 55 08             	mov    0x8(%ebp),%edx
801071a6:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
801071a8:	89 c1                	mov    %eax,%ecx
801071aa:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801071ad:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
801071b0:	f6 c1 01             	test   $0x1,%cl
801071b3:	75 13                	jne    801071c8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
801071b5:	83 ec 0c             	sub    $0xc,%esp
801071b8:	68 bb 81 10 80       	push   $0x801081bb
801071bd:	e8 ae 92 ff ff       	call   80100470 <panic>
801071c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801071c8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071cb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801071d1:	25 fc 0f 00 00       	and    $0xffc,%eax
801071d6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801071dd:	85 c9                	test   %ecx,%ecx
801071df:	74 d4                	je     801071b5 <loaduvm+0x35>
    if(sz - i < PGSIZE)
801071e1:	89 fb                	mov    %edi,%ebx
801071e3:	b8 00 10 00 00       	mov    $0x1000,%eax
801071e8:	29 f3                	sub    %esi,%ebx
801071ea:	39 c3                	cmp    %eax,%ebx
801071ec:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071ef:	53                   	push   %ebx
801071f0:	8b 45 14             	mov    0x14(%ebp),%eax
801071f3:	01 f0                	add    %esi,%eax
801071f5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
801071f6:	8b 01                	mov    (%ecx),%eax
801071f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071fd:	05 00 00 00 80       	add    $0x80000000,%eax
80107202:	50                   	push   %eax
80107203:	ff 75 10             	push   0x10(%ebp)
80107206:	e8 95 a9 ff ff       	call   80101ba0 <readi>
8010720b:	83 c4 10             	add    $0x10,%esp
8010720e:	39 d8                	cmp    %ebx,%eax
80107210:	75 1e                	jne    80107230 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80107212:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107218:	39 fe                	cmp    %edi,%esi
8010721a:	72 84                	jb     801071a0 <loaduvm+0x20>
}
8010721c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010721f:	31 c0                	xor    %eax,%eax
}
80107221:	5b                   	pop    %ebx
80107222:	5e                   	pop    %esi
80107223:	5f                   	pop    %edi
80107224:	5d                   	pop    %ebp
80107225:	c3                   	ret
80107226:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010722d:	8d 76 00             	lea    0x0(%esi),%esi
80107230:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107233:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107238:	5b                   	pop    %ebx
80107239:	5e                   	pop    %esi
8010723a:	5f                   	pop    %edi
8010723b:	5d                   	pop    %ebp
8010723c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
8010723d:	83 ec 0c             	sub    $0xc,%esp
80107240:	68 bc 84 10 80       	push   $0x801084bc
80107245:	e8 26 92 ff ff       	call   80100470 <panic>
8010724a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107250 <allocuvm>:
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	57                   	push   %edi
80107254:	56                   	push   %esi
80107255:	53                   	push   %ebx
80107256:	83 ec 1c             	sub    $0x1c,%esp
80107259:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010725c:	85 f6                	test   %esi,%esi
8010725e:	0f 88 a4 00 00 00    	js     80107308 <allocuvm+0xb8>
80107264:	89 f1                	mov    %esi,%ecx
  if(newsz < oldsz)
80107266:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107269:	0f 82 a9 00 00 00    	jb     80107318 <allocuvm+0xc8>
  a = PGROUNDUP(oldsz);
8010726f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107272:	05 ff 0f 00 00       	add    $0xfff,%eax
80107277:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010727c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010727e:	39 f0                	cmp    %esi,%eax
80107280:	0f 83 95 00 00 00    	jae    8010731b <allocuvm+0xcb>
80107286:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107289:	eb 50                	jmp    801072db <allocuvm+0x8b>
8010728b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010728f:	90                   	nop
    memset(mem, 0, PGSIZE);
80107290:	83 ec 04             	sub    $0x4,%esp
80107293:	68 00 10 00 00       	push   $0x1000
80107298:	6a 00                	push   $0x0
8010729a:	50                   	push   %eax
8010729b:	e8 90 d8 ff ff       	call   80104b30 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801072a0:	58                   	pop    %eax
801072a1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072a7:	5a                   	pop    %edx
801072a8:	6a 06                	push   $0x6
801072aa:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072af:	89 fa                	mov    %edi,%edx
801072b1:	50                   	push   %eax
801072b2:	8b 45 08             	mov    0x8(%ebp),%eax
801072b5:	e8 a6 fb ff ff       	call   80106e60 <mappages>
801072ba:	83 c4 10             	add    $0x10,%esp
801072bd:	85 c0                	test   %eax,%eax
801072bf:	78 67                	js     80107328 <allocuvm+0xd8>
    myproc()->rss += PGSIZE;
801072c1:	e8 7a c8 ff ff       	call   80103b40 <myproc>
  for(; a < newsz; a += PGSIZE){
801072c6:	81 c7 00 10 00 00    	add    $0x1000,%edi
    myproc()->rss += PGSIZE;
801072cc:	81 40 04 00 10 00 00 	addl   $0x1000,0x4(%eax)
  for(; a < newsz; a += PGSIZE){
801072d3:	39 f7                	cmp    %esi,%edi
801072d5:	0f 83 85 00 00 00    	jae    80107360 <allocuvm+0x110>
    mem = kalloc();
801072db:	e8 e0 b4 ff ff       	call   801027c0 <kalloc>
801072e0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801072e2:	85 c0                	test   %eax,%eax
801072e4:	75 aa                	jne    80107290 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801072e6:	83 ec 0c             	sub    $0xc,%esp
801072e9:	68 d9 81 10 80       	push   $0x801081d9
801072ee:	e8 ad 94 ff ff       	call   801007a0 <cprintf>
  if(newsz >= oldsz)
801072f3:	83 c4 10             	add    $0x10,%esp
801072f6:	3b 75 0c             	cmp    0xc(%ebp),%esi
801072f9:	74 0d                	je     80107308 <allocuvm+0xb8>
801072fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801072fe:	8b 45 08             	mov    0x8(%ebp),%eax
80107301:	89 f2                	mov    %esi,%edx
80107303:	e8 58 fa ff ff       	call   80106d60 <deallocuvm.part.0>
    return 0;
80107308:	31 c9                	xor    %ecx,%ecx
}
8010730a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010730d:	89 c8                	mov    %ecx,%eax
8010730f:	5b                   	pop    %ebx
80107310:	5e                   	pop    %esi
80107311:	5f                   	pop    %edi
80107312:	5d                   	pop    %ebp
80107313:	c3                   	ret
80107314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107318:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}
8010731b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010731e:	89 c8                	mov    %ecx,%eax
80107320:	5b                   	pop    %ebx
80107321:	5e                   	pop    %esi
80107322:	5f                   	pop    %edi
80107323:	5d                   	pop    %ebp
80107324:	c3                   	ret
80107325:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107328:	83 ec 0c             	sub    $0xc,%esp
8010732b:	68 f1 81 10 80       	push   $0x801081f1
80107330:	e8 6b 94 ff ff       	call   801007a0 <cprintf>
  if(newsz >= oldsz)
80107335:	83 c4 10             	add    $0x10,%esp
80107338:	3b 75 0c             	cmp    0xc(%ebp),%esi
8010733b:	74 0d                	je     8010734a <allocuvm+0xfa>
8010733d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107340:	8b 45 08             	mov    0x8(%ebp),%eax
80107343:	89 f2                	mov    %esi,%edx
80107345:	e8 16 fa ff ff       	call   80106d60 <deallocuvm.part.0>
      kfree(mem);
8010734a:	83 ec 0c             	sub    $0xc,%esp
8010734d:	53                   	push   %ebx
8010734e:	e8 4d b2 ff ff       	call   801025a0 <kfree>
      return 0;
80107353:	83 c4 10             	add    $0x10,%esp
    return 0;
80107356:	31 c9                	xor    %ecx,%ecx
80107358:	eb b0                	jmp    8010730a <allocuvm+0xba>
8010735a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107360:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
}
80107363:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107366:	5b                   	pop    %ebx
80107367:	5e                   	pop    %esi
80107368:	89 c8                	mov    %ecx,%eax
8010736a:	5f                   	pop    %edi
8010736b:	5d                   	pop    %ebp
8010736c:	c3                   	ret
8010736d:	8d 76 00             	lea    0x0(%esi),%esi

80107370 <deallocuvm>:
{
80107370:	55                   	push   %ebp
80107371:	89 e5                	mov    %esp,%ebp
80107373:	8b 55 0c             	mov    0xc(%ebp),%edx
80107376:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107379:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010737c:	39 d1                	cmp    %edx,%ecx
8010737e:	73 10                	jae    80107390 <deallocuvm+0x20>
}
80107380:	5d                   	pop    %ebp
80107381:	e9 da f9 ff ff       	jmp    80106d60 <deallocuvm.part.0>
80107386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010738d:	8d 76 00             	lea    0x0(%esi),%esi
80107390:	89 d0                	mov    %edx,%eax
80107392:	5d                   	pop    %ebp
80107393:	c3                   	ret
80107394:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010739b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010739f:	90                   	nop

801073a0 <deallocuvm_proc>:
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	53                   	push   %ebx
801073a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
801073a7:	8b 45 14             	mov    0x14(%ebp),%eax
801073aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
801073ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  if(newsz >= oldsz)
801073b0:	39 c8                	cmp    %ecx,%eax
801073b2:	73 14                	jae    801073c8 <deallocuvm_proc+0x28>
801073b4:	89 45 08             	mov    %eax,0x8(%ebp)
801073b7:	89 d8                	mov    %ebx,%eax
}
801073b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801073bc:	c9                   	leave
801073bd:	e9 be f8 ff ff       	jmp    80106c80 <deallocuvm_proc.part.0>
801073c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801073cb:	89 c8                	mov    %ecx,%eax
801073cd:	c9                   	leave
801073ce:	c3                   	ret
801073cf:	90                   	nop

801073d0 <freevm>:
// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801073d0:	55                   	push   %ebp
801073d1:	89 e5                	mov    %esp,%ebp
801073d3:	57                   	push   %edi
801073d4:	56                   	push   %esi
801073d5:	53                   	push   %ebx
801073d6:	83 ec 0c             	sub    $0xc,%esp
801073d9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801073dc:	85 f6                	test   %esi,%esi
801073de:	74 59                	je     80107439 <freevm+0x69>
  if(newsz >= oldsz)
801073e0:	31 c9                	xor    %ecx,%ecx
801073e2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801073e7:	89 f0                	mov    %esi,%eax
801073e9:	89 f3                	mov    %esi,%ebx
801073eb:	e8 70 f9 ff ff       	call   80106d60 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801073f0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801073f6:	eb 0f                	jmp    80107407 <freevm+0x37>
801073f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ff:	90                   	nop
80107400:	83 c3 04             	add    $0x4,%ebx
80107403:	39 fb                	cmp    %edi,%ebx
80107405:	74 23                	je     8010742a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107407:	8b 03                	mov    (%ebx),%eax
80107409:	a8 01                	test   $0x1,%al
8010740b:	74 f3                	je     80107400 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010740d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107412:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107415:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107418:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010741d:	50                   	push   %eax
8010741e:	e8 7d b1 ff ff       	call   801025a0 <kfree>
80107423:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107426:	39 fb                	cmp    %edi,%ebx
80107428:	75 dd                	jne    80107407 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010742a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010742d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107430:	5b                   	pop    %ebx
80107431:	5e                   	pop    %esi
80107432:	5f                   	pop    %edi
80107433:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107434:	e9 67 b1 ff ff       	jmp    801025a0 <kfree>
    panic("freevm: no pgdir");
80107439:	83 ec 0c             	sub    $0xc,%esp
8010743c:	68 0d 82 10 80       	push   $0x8010820d
80107441:	e8 2a 90 ff ff       	call   80100470 <panic>
80107446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010744d:	8d 76 00             	lea    0x0(%esi),%esi

80107450 <setupkvm>:
{
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	56                   	push   %esi
80107454:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107455:	e8 66 b3 ff ff       	call   801027c0 <kalloc>
8010745a:	85 c0                	test   %eax,%eax
8010745c:	74 5e                	je     801074bc <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
8010745e:	83 ec 04             	sub    $0x4,%esp
80107461:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107463:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107468:	68 00 10 00 00       	push   $0x1000
8010746d:	6a 00                	push   $0x0
8010746f:	50                   	push   %eax
80107470:	e8 bb d6 ff ff       	call   80104b30 <memset>
80107475:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107478:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010747b:	83 ec 08             	sub    $0x8,%esp
8010747e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107481:	8b 13                	mov    (%ebx),%edx
80107483:	ff 73 0c             	push   0xc(%ebx)
80107486:	50                   	push   %eax
80107487:	29 c1                	sub    %eax,%ecx
80107489:	89 f0                	mov    %esi,%eax
8010748b:	e8 d0 f9 ff ff       	call   80106e60 <mappages>
80107490:	83 c4 10             	add    $0x10,%esp
80107493:	85 c0                	test   %eax,%eax
80107495:	78 19                	js     801074b0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107497:	83 c3 10             	add    $0x10,%ebx
8010749a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801074a0:	75 d6                	jne    80107478 <setupkvm+0x28>
}
801074a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801074a5:	89 f0                	mov    %esi,%eax
801074a7:	5b                   	pop    %ebx
801074a8:	5e                   	pop    %esi
801074a9:	5d                   	pop    %ebp
801074aa:	c3                   	ret
801074ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074af:	90                   	nop
      freevm(pgdir);
801074b0:	83 ec 0c             	sub    $0xc,%esp
801074b3:	56                   	push   %esi
801074b4:	e8 17 ff ff ff       	call   801073d0 <freevm>
      return 0;
801074b9:	83 c4 10             	add    $0x10,%esp
}
801074bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
801074bf:	31 f6                	xor    %esi,%esi
}
801074c1:	89 f0                	mov    %esi,%eax
801074c3:	5b                   	pop    %ebx
801074c4:	5e                   	pop    %esi
801074c5:	5d                   	pop    %ebp
801074c6:	c3                   	ret
801074c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ce:	66 90                	xchg   %ax,%ax

801074d0 <kvmalloc>:
{
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801074d6:	e8 75 ff ff ff       	call   80107450 <setupkvm>
801074db:	a3 24 61 11 80       	mov    %eax,0x80116124
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801074e0:	05 00 00 00 80       	add    $0x80000000,%eax
801074e5:	0f 22 d8             	mov    %eax,%cr3
}
801074e8:	c9                   	leave
801074e9:	c3                   	ret
801074ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801074f0:	55                   	push   %ebp
801074f1:	89 e5                	mov    %esp,%ebp
801074f3:	83 ec 08             	sub    $0x8,%esp
801074f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801074f9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801074fc:	89 c1                	mov    %eax,%ecx
801074fe:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107501:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107504:	f6 c2 01             	test   $0x1,%dl
80107507:	75 17                	jne    80107520 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107509:	83 ec 0c             	sub    $0xc,%esp
8010750c:	68 1e 82 10 80       	push   $0x8010821e
80107511:	e8 5a 8f ff ff       	call   80100470 <panic>
80107516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010751d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107520:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107523:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107529:	25 fc 0f 00 00       	and    $0xffc,%eax
8010752e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107535:	85 c0                	test   %eax,%eax
80107537:	74 d0                	je     80107509 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107539:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010753c:	c9                   	leave
8010753d:	c3                   	ret
8010753e:	66 90                	xchg   %ax,%ax

80107540 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107540:	55                   	push   %ebp
80107541:	89 e5                	mov    %esp,%ebp
80107543:	57                   	push   %edi
80107544:	56                   	push   %esi
80107545:	53                   	push   %ebx
80107546:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107549:	e8 02 ff ff ff       	call   80107450 <setupkvm>
8010754e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107551:	85 c0                	test   %eax,%eax
80107553:	0f 84 e9 00 00 00    	je     80107642 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107559:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010755c:	85 c9                	test   %ecx,%ecx
8010755e:	0f 84 b2 00 00 00    	je     80107616 <copyuvm+0xd6>
80107564:	31 f6                	xor    %esi,%esi
80107566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010756d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107570:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107573:	89 f0                	mov    %esi,%eax
80107575:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107578:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010757b:	a8 01                	test   $0x1,%al
8010757d:	75 11                	jne    80107590 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010757f:	83 ec 0c             	sub    $0xc,%esp
80107582:	68 28 82 10 80       	push   $0x80108228
80107587:	e8 e4 8e ff ff       	call   80100470 <panic>
8010758c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107590:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107592:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107597:	c1 ea 0a             	shr    $0xa,%edx
8010759a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801075a0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801075a7:	85 c0                	test   %eax,%eax
801075a9:	74 d4                	je     8010757f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801075ab:	8b 00                	mov    (%eax),%eax
801075ad:	a8 01                	test   $0x1,%al
801075af:	0f 84 9f 00 00 00    	je     80107654 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801075b5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801075b7:	25 ff 0f 00 00       	and    $0xfff,%eax
801075bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801075bf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801075c5:	e8 f6 b1 ff ff       	call   801027c0 <kalloc>
801075ca:	89 c3                	mov    %eax,%ebx
801075cc:	85 c0                	test   %eax,%eax
801075ce:	74 64                	je     80107634 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801075d0:	83 ec 04             	sub    $0x4,%esp
801075d3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801075d9:	68 00 10 00 00       	push   $0x1000
801075de:	57                   	push   %edi
801075df:	50                   	push   %eax
801075e0:	e8 db d5 ff ff       	call   80104bc0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801075e5:	58                   	pop    %eax
801075e6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075ec:	5a                   	pop    %edx
801075ed:	ff 75 e4             	push   -0x1c(%ebp)
801075f0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075f5:	89 f2                	mov    %esi,%edx
801075f7:	50                   	push   %eax
801075f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075fb:	e8 60 f8 ff ff       	call   80106e60 <mappages>
80107600:	83 c4 10             	add    $0x10,%esp
80107603:	85 c0                	test   %eax,%eax
80107605:	78 21                	js     80107628 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107607:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010760d:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107610:	0f 82 5a ff ff ff    	jb     80107570 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107616:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107619:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010761c:	5b                   	pop    %ebx
8010761d:	5e                   	pop    %esi
8010761e:	5f                   	pop    %edi
8010761f:	5d                   	pop    %ebp
80107620:	c3                   	ret
80107621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107628:	83 ec 0c             	sub    $0xc,%esp
8010762b:	53                   	push   %ebx
8010762c:	e8 6f af ff ff       	call   801025a0 <kfree>
      goto bad;
80107631:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107634:	83 ec 0c             	sub    $0xc,%esp
80107637:	ff 75 e0             	push   -0x20(%ebp)
8010763a:	e8 91 fd ff ff       	call   801073d0 <freevm>
  return 0;
8010763f:	83 c4 10             	add    $0x10,%esp
    return 0;
80107642:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107649:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010764c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010764f:	5b                   	pop    %ebx
80107650:	5e                   	pop    %esi
80107651:	5f                   	pop    %edi
80107652:	5d                   	pop    %ebp
80107653:	c3                   	ret
      panic("copyuvm: page not present");
80107654:	83 ec 0c             	sub    $0xc,%esp
80107657:	68 42 82 10 80       	push   $0x80108242
8010765c:	e8 0f 8e ff ff       	call   80100470 <panic>
80107661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107668:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010766f:	90                   	nop

80107670 <copyuvm_cow>:
pde_t*
copyuvm_cow(pde_t *pgdir, uint sz, struct proc * p)
{
80107670:	55                   	push   %ebp
80107671:	89 e5                	mov    %esp,%ebp
80107673:	57                   	push   %edi
80107674:	56                   	push   %esi
80107675:	53                   	push   %ebx
80107676:	83 ec 1c             	sub    $0x1c,%esp
80107679:	8b 75 10             	mov    0x10(%ebp),%esi
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  // char *mem;
  int * page_to_refcnt = get_refcnt_table();
8010767c:	e8 0f af ff ff       	call   80102590 <get_refcnt_table>
80107681:	89 45 e0             	mov    %eax,-0x20(%ebp)

  if((d = setupkvm()) == 0)
80107684:	e8 c7 fd ff ff       	call   80107450 <setupkvm>
80107689:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010768c:	85 c0                	test   %eax,%eax
8010768e:	0f 84 ea 00 00 00    	je     8010777e <copyuvm_cow+0x10e>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107694:	8b 45 0c             	mov    0xc(%ebp),%eax
80107697:	85 c0                	test   %eax,%eax
80107699:	0f 84 ba 00 00 00    	je     80107759 <copyuvm_cow+0xe9>
8010769f:	31 ff                	xor    %edi,%edi
801076a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*pde & PTE_P){
801076a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801076ab:	89 f8                	mov    %edi,%eax
    p->rss += PGSIZE;
801076ad:	81 46 04 00 10 00 00 	addl   $0x1000,0x4(%esi)
  pde = &pgdir[PDX(va)];
801076b4:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801076b7:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801076ba:	a8 01                	test   $0x1,%al
801076bc:	75 12                	jne    801076d0 <copyuvm_cow+0x60>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801076be:	83 ec 0c             	sub    $0xc,%esp
801076c1:	68 28 82 10 80       	push   $0x80108228
801076c6:	e8 a5 8d ff ff       	call   80100470 <panic>
801076cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076cf:	90                   	nop
  return &pgtab[PTX(va)];
801076d0:	89 fa                	mov    %edi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801076d7:	c1 ea 0a             	shr    $0xa,%edx
801076da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801076e0:	8d 94 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%edx
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801076e7:	85 d2                	test   %edx,%edx
801076e9:	74 d3                	je     801076be <copyuvm_cow+0x4e>
    // change here
    if(!(*pte & PTE_P))
801076eb:	8b 02                	mov    (%edx),%eax
801076ed:	a8 01                	test   $0x1,%al
801076ef:	0f 84 9b 00 00 00    	je     80107790 <copyuvm_cow+0x120>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801076f5:	89 c3                	mov    %eax,%ebx
    // if((mem = kalloc()) == 0)
    //   goto bad;
    // memmove(mem, (char*)P2V(pa), PGSIZE);

    int new_flags = flags & ~PTE_W;
    *pte &= ~PTE_W;
801076f7:	89 c1                	mov    %eax,%ecx
    if(mappages(d, (void*)i, PGSIZE, pa, new_flags) < 0) {
801076f9:	83 ec 08             	sub    $0x8,%esp
    int new_flags = flags & ~PTE_W;
801076fc:	25 fd 0f 00 00       	and    $0xffd,%eax
    *pte &= ~PTE_W;
80107701:	83 e1 fd             	and    $0xfffffffd,%ecx
    pa = PTE_ADDR(*pte);
80107704:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    *pte &= ~PTE_W;
8010770a:	89 0a                	mov    %ecx,(%edx)
    if(mappages(d, (void*)i, PGSIZE, pa, new_flags) < 0) {
8010770c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107711:	89 fa                	mov    %edi,%edx
80107713:	50                   	push   %eax
80107714:	53                   	push   %ebx
80107715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107718:	e8 43 f7 ff ff       	call   80106e60 <mappages>
8010771d:	83 c4 10             	add    $0x10,%esp
80107720:	85 c0                	test   %eax,%eax
80107722:	78 4c                	js     80107770 <copyuvm_cow+0x100>
      // kfree(mem);
      goto bad;
    }

    page_to_refcnt[pa >> PTXSHIFT]++;
80107724:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80107727:	89 d8                	mov    %ebx,%eax
80107729:	c1 eb 0a             	shr    $0xa,%ebx
    cprintf("copyuvm_cow: refcnt = %d of pageno %d\n", page_to_refcnt[pa >> PTXSHIFT], pa >> PTXSHIFT);
8010772c:	83 ec 04             	sub    $0x4,%esp
    page_to_refcnt[pa >> PTXSHIFT]++;
8010772f:	c1 e8 0c             	shr    $0xc,%eax
  for(i = 0; i < sz; i += PGSIZE){
80107732:	81 c7 00 10 00 00    	add    $0x1000,%edi
    page_to_refcnt[pa >> PTXSHIFT]++;
80107738:	01 cb                	add    %ecx,%ebx
8010773a:	8b 13                	mov    (%ebx),%edx
8010773c:	83 c2 01             	add    $0x1,%edx
8010773f:	89 13                	mov    %edx,(%ebx)
    cprintf("copyuvm_cow: refcnt = %d of pageno %d\n", page_to_refcnt[pa >> PTXSHIFT], pa >> PTXSHIFT);
80107741:	50                   	push   %eax
80107742:	52                   	push   %edx
80107743:	68 e0 84 10 80       	push   $0x801084e0
80107748:	e8 53 90 ff ff       	call   801007a0 <cprintf>
  for(i = 0; i < sz; i += PGSIZE){
8010774d:	83 c4 10             	add    $0x10,%esp
80107750:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107753:	0f 82 4f ff ff ff    	jb     801076a8 <copyuvm_cow+0x38>

  }

  lcr3(V2P(pgdir));
80107759:	8b 45 08             	mov    0x8(%ebp),%eax
8010775c:	05 00 00 00 80       	add    $0x80000000,%eax
80107761:	0f 22 d8             	mov    %eax,%cr3
  return d;

bad:
  freevm(d);
  return 0;
}
80107764:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107767:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010776a:	5b                   	pop    %ebx
8010776b:	5e                   	pop    %esi
8010776c:	5f                   	pop    %edi
8010776d:	5d                   	pop    %ebp
8010776e:	c3                   	ret
8010776f:	90                   	nop
  freevm(d);
80107770:	83 ec 0c             	sub    $0xc,%esp
80107773:	ff 75 e4             	push   -0x1c(%ebp)
80107776:	e8 55 fc ff ff       	call   801073d0 <freevm>
  return 0;
8010777b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010777e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107785:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107788:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010778b:	5b                   	pop    %ebx
8010778c:	5e                   	pop    %esi
8010778d:	5f                   	pop    %edi
8010778e:	5d                   	pop    %ebp
8010778f:	c3                   	ret
      panic("copyuvm: page not present");
80107790:	83 ec 0c             	sub    $0xc,%esp
80107793:	68 42 82 10 80       	push   $0x80108242
80107798:	e8 d3 8c ff ff       	call   80100470 <panic>
8010779d:	8d 76 00             	lea    0x0(%esi),%esi

801077a0 <freevm_proc>:
void
freevm_proc(struct proc * p, pde_t *pgdir)
{
801077a0:	55                   	push   %ebp
801077a1:	89 e5                	mov    %esp,%ebp
801077a3:	57                   	push   %edi
801077a4:	56                   	push   %esi
801077a5:	53                   	push   %ebx
801077a6:	83 ec 0c             	sub    $0xc,%esp
801077a9:	8b 75 0c             	mov    0xc(%ebp),%esi
801077ac:	8b 45 08             	mov    0x8(%ebp),%eax
  uint i;

  if(pgdir == 0)
801077af:	85 f6                	test   %esi,%esi
801077b1:	74 5e                	je     80107811 <freevm_proc+0x71>
  if(newsz >= oldsz)
801077b3:	83 ec 0c             	sub    $0xc,%esp
801077b6:	b9 00 00 00 80       	mov    $0x80000000,%ecx
801077bb:	89 f2                	mov    %esi,%edx
801077bd:	89 f3                	mov    %esi,%ebx
801077bf:	6a 00                	push   $0x0
801077c1:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801077c7:	e8 b4 f4 ff ff       	call   80106c80 <deallocuvm_proc.part.0>
    panic("freevm: no pgdir");
  deallocuvm_proc(p, pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801077cc:	83 c4 10             	add    $0x10,%esp
801077cf:	eb 0e                	jmp    801077df <freevm_proc+0x3f>
801077d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077d8:	83 c3 04             	add    $0x4,%ebx
801077db:	39 fb                	cmp    %edi,%ebx
801077dd:	74 23                	je     80107802 <freevm_proc+0x62>
    if(pgdir[i] & PTE_P){
801077df:	8b 03                	mov    (%ebx),%eax
801077e1:	a8 01                	test   $0x1,%al
801077e3:	74 f3                	je     801077d8 <freevm_proc+0x38>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801077e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801077ea:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801077ed:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801077f0:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801077f5:	50                   	push   %eax
801077f6:	e8 a5 ad ff ff       	call   801025a0 <kfree>
801077fb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801077fe:	39 fb                	cmp    %edi,%ebx
80107800:	75 dd                	jne    801077df <freevm_proc+0x3f>
    }
  }
  kfree((char*)pgdir);
80107802:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107805:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107808:	5b                   	pop    %ebx
80107809:	5e                   	pop    %esi
8010780a:	5f                   	pop    %edi
8010780b:	5d                   	pop    %ebp
  kfree((char*)pgdir);
8010780c:	e9 8f ad ff ff       	jmp    801025a0 <kfree>
    panic("freevm: no pgdir");
80107811:	83 ec 0c             	sub    $0xc,%esp
80107814:	68 0d 82 10 80       	push   $0x8010820d
80107819:	e8 52 8c ff ff       	call   80100470 <panic>
8010781e:	66 90                	xchg   %ax,%ax

80107820 <clear_zombie>:
void clear_zombie(struct proc * p){
80107820:	55                   	push   %ebp
80107821:	89 e5                	mov    %esp,%ebp
80107823:	57                   	push   %edi
80107824:	56                   	push   %esi
80107825:	53                   	push   %ebx
80107826:	83 ec 1c             	sub    $0x1c,%esp
80107829:	8b 45 08             	mov    0x8(%ebp),%eax
8010782c:	8b 70 08             	mov    0x8(%eax),%esi
8010782f:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
80107835:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107838:	eb 10                	jmp    8010784a <clear_zombie+0x2a>
8010783a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  pde_t * pgdir = p->pgdir;
  for(int i = 0 ; i < NPDENTRIES; i++){
80107840:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107843:	83 c6 04             	add    $0x4,%esi
80107846:	39 c6                	cmp    %eax,%esi
80107848:	74 43                	je     8010788d <clear_zombie+0x6d>
    if(pgdir[i] & PTE_P){
8010784a:	8b 16                	mov    (%esi),%edx
8010784c:	f6 c2 01             	test   $0x1,%dl
8010784f:	74 ef                	je     80107840 <clear_zombie+0x20>
      pte_t* pte = (pte_t*) P2V(PTE_ADDR(pgdir[i]));
80107851:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107857:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
      for(int j= 0 ; j < NPTENTRIES; j++){
8010785d:	8d ba 00 10 00 80    	lea    -0x7ffff000(%edx),%edi
80107863:	eb 0a                	jmp    8010786f <clear_zombie+0x4f>
80107865:	8d 76 00             	lea    0x0(%esi),%esi
80107868:	83 c3 04             	add    $0x4,%ebx
8010786b:	39 df                	cmp    %ebx,%edi
8010786d:	74 d1                	je     80107840 <clear_zombie+0x20>
        if(!(pte[j] & PTE_P) && (pte[j] & PTE_SW)){
8010786f:	8b 03                	mov    (%ebx),%eax
80107871:	83 e0 09             	and    $0x9,%eax
80107874:	83 f8 08             	cmp    $0x8,%eax
80107877:	75 ef                	jne    80107868 <clear_zombie+0x48>
          clear_slot(&pte[j]);
80107879:	83 ec 0c             	sub    $0xc,%esp
8010787c:	53                   	push   %ebx
8010787d:	e8 ee 02 00 00       	call   80107b70 <clear_slot>
          pte[j] = 0;
80107882:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107888:	83 c4 10             	add    $0x10,%esp
8010788b:	eb db                	jmp    80107868 <clear_zombie+0x48>
        }
      }
    }
  }
}
8010788d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107890:	5b                   	pop    %ebx
80107891:	5e                   	pop    %esi
80107892:	5f                   	pop    %edi
80107893:	5d                   	pop    %ebp
80107894:	c3                   	ret
80107895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010789c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801078a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801078a0:	55                   	push   %ebp
801078a1:	89 e5                	mov    %esp,%ebp
801078a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801078a6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801078a9:	89 c1                	mov    %eax,%ecx
801078ab:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801078ae:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801078b1:	f6 c2 01             	test   $0x1,%dl
801078b4:	0f 84 f8 00 00 00    	je     801079b2 <uva2ka.cold>
  return &pgtab[PTX(va)];
801078ba:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078bd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801078c3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801078c4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801078c9:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
801078d0:	89 d0                	mov    %edx,%eax
801078d2:	f7 d2                	not    %edx
801078d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801078d9:	05 00 00 00 80       	add    $0x80000000,%eax
801078de:	83 e2 05             	and    $0x5,%edx
801078e1:	ba 00 00 00 00       	mov    $0x0,%edx
801078e6:	0f 45 c2             	cmovne %edx,%eax
}
801078e9:	c3                   	ret
801078ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801078f0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801078f0:	55                   	push   %ebp
801078f1:	89 e5                	mov    %esp,%ebp
801078f3:	57                   	push   %edi
801078f4:	56                   	push   %esi
801078f5:	53                   	push   %ebx
801078f6:	83 ec 0c             	sub    $0xc,%esp
801078f9:	8b 75 14             	mov    0x14(%ebp),%esi
801078fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801078ff:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107902:	85 f6                	test   %esi,%esi
80107904:	75 51                	jne    80107957 <copyout+0x67>
80107906:	e9 9d 00 00 00       	jmp    801079a8 <copyout+0xb8>
8010790b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010790f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107910:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107916:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010791c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107922:	74 74                	je     80107998 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80107924:	89 fb                	mov    %edi,%ebx
80107926:	29 c3                	sub    %eax,%ebx
80107928:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010792e:	39 f3                	cmp    %esi,%ebx
80107930:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107933:	29 f8                	sub    %edi,%eax
80107935:	83 ec 04             	sub    $0x4,%esp
80107938:	01 c1                	add    %eax,%ecx
8010793a:	53                   	push   %ebx
8010793b:	52                   	push   %edx
8010793c:	89 55 10             	mov    %edx,0x10(%ebp)
8010793f:	51                   	push   %ecx
80107940:	e8 7b d2 ff ff       	call   80104bc0 <memmove>
    len -= n;
    buf += n;
80107945:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107948:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010794e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107951:	01 da                	add    %ebx,%edx
  while(len > 0){
80107953:	29 de                	sub    %ebx,%esi
80107955:	74 51                	je     801079a8 <copyout+0xb8>
  if(*pde & PTE_P){
80107957:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010795a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010795c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010795e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107961:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107967:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010796a:	f6 c1 01             	test   $0x1,%cl
8010796d:	0f 84 46 00 00 00    	je     801079b9 <copyout.cold>
  return &pgtab[PTX(va)];
80107973:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107975:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010797b:	c1 eb 0c             	shr    $0xc,%ebx
8010797e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107984:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010798b:	89 d9                	mov    %ebx,%ecx
8010798d:	f7 d1                	not    %ecx
8010798f:	83 e1 05             	and    $0x5,%ecx
80107992:	0f 84 78 ff ff ff    	je     80107910 <copyout+0x20>
  }
  return 0;
}
80107998:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010799b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079a0:	5b                   	pop    %ebx
801079a1:	5e                   	pop    %esi
801079a2:	5f                   	pop    %edi
801079a3:	5d                   	pop    %ebp
801079a4:	c3                   	ret
801079a5:	8d 76 00             	lea    0x0(%esi),%esi
801079a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079ab:	31 c0                	xor    %eax,%eax
}
801079ad:	5b                   	pop    %ebx
801079ae:	5e                   	pop    %esi
801079af:	5f                   	pop    %edi
801079b0:	5d                   	pop    %ebp
801079b1:	c3                   	ret

801079b2 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801079b2:	a1 00 00 00 00       	mov    0x0,%eax
801079b7:	0f 0b                	ud2

801079b9 <copyout.cold>:
801079b9:	a1 00 00 00 00       	mov    0x0,%eax
801079be:	0f 0b                	ud2

801079c0 <cow_fault>:
#include "spinlock.h"


void cow_fault(){
	// create new page entry when page fault occurs due to cow
801079c0:	c3                   	ret
801079c1:	66 90                	xchg   %ax,%ax
801079c3:	66 90                	xchg   %ax,%ax
801079c5:	66 90                	xchg   %ax,%ax
801079c7:	66 90                	xchg   %ax,%ax
801079c9:	66 90                	xchg   %ax,%ax
801079cb:	66 90                	xchg   %ax,%ax
801079cd:	66 90                	xchg   %ax,%ax
801079cf:	90                   	nop

801079d0 <swapinit>:

#define SWAPBASE 2
#define NPAGE (SWAPBLOCKS / BPPAGE)

struct swapslothdr swap_slots[NPAGE];
void swapinit(void){
801079d0:	55                   	push   %ebp
801079d1:	b8 02 00 00 00       	mov    $0x2,%eax
801079d6:	89 e5                	mov    %esp,%ebp
801079d8:	83 ec 08             	sub    $0x8,%esp
801079db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079df:	90                   	nop
	for(int i = 0 ; i < NPAGE ; i++){
		swap_slots[i].is_free = FREE;
801079e0:	c7 84 00 3c 61 11 80 	movl   $0x1,-0x7fee9ec4(%eax,%eax,1)
801079e7:	01 00 00 00 
		swap_slots[i].page_perm = 0;
801079eb:	c7 84 00 40 61 11 80 	movl   $0x0,-0x7fee9ec0(%eax,%eax,1)
801079f2:	00 00 00 00 
		swap_slots[i].blockno = SWAPBASE + i * BPPAGE;
801079f6:	89 84 00 44 61 11 80 	mov    %eax,-0x7fee9ebc(%eax,%eax,1)
	for(int i = 0 ; i < NPAGE ; i++){
801079fd:	83 c0 08             	add    $0x8,%eax
80107a00:	3d 82 0c 00 00       	cmp    $0xc82,%eax
80107a05:	75 d9                	jne    801079e0 <swapinit+0x10>
	}
	cprintf("Swap slots initialized\n");
80107a07:	83 ec 0c             	sub    $0xc,%esp
80107a0a:	68 5c 82 10 80       	push   $0x8010825c
80107a0f:	e8 8c 8d ff ff       	call   801007a0 <cprintf>
}
80107a14:	83 c4 10             	add    $0x10,%esp
80107a17:	c9                   	leave
80107a18:	c3                   	ret
80107a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a20 <swap_out>:
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

void swap_out(){
80107a20:	55                   	push   %ebp
80107a21:	89 e5                	mov    %esp,%ebp
80107a23:	57                   	push   %edi
80107a24:	56                   	push   %esi
80107a25:	53                   	push   %ebx
80107a26:	83 ec 0c             	sub    $0xc,%esp
	// int * page_to_refcnt = get_refcnt_table();
	pte_t* pte = final_page();
80107a29:	e8 22 cc ff ff       	call   80104650 <final_page>
80107a2e:	89 c6                	mov    %eax,%esi
	for(int i = 0 ; i < NPAGE; i++){
80107a30:	31 c0                	xor    %eax,%eax
80107a32:	eb 0e                	jmp    80107a42 <swap_out+0x22>
80107a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a38:	83 c0 01             	add    $0x1,%eax
80107a3b:	3d 90 01 00 00       	cmp    $0x190,%eax
80107a40:	74 63                	je     80107aa5 <swap_out+0x85>
		if(swap_slots[i].is_free == FREE){
80107a42:	89 c2                	mov    %eax,%edx
80107a44:	c1 e2 04             	shl    $0x4,%edx
80107a47:	83 ba 40 61 11 80 01 	cmpl   $0x1,-0x7fee9ec0(%edx)
80107a4e:	75 e8                	jne    80107a38 <swap_out+0x18>
			swap_slots[i].is_free = NOT_FREE;
80107a50:	c7 82 40 61 11 80 00 	movl   $0x0,-0x7fee9ec0(%edx)
80107a57:	00 00 00 
			swap_slots[i].page_perm = PTE_FLAGS(*pte);
80107a5a:	8b 06                	mov    (%esi),%eax
			uint pa = PTE_ADDR(*pte);
			write_page_to_swap(swap_slots[i].blockno, (char*)P2V(pa));
80107a5c:	83 ec 08             	sub    $0x8,%esp
			swap_slots[i].is_free = NOT_FREE;
80107a5f:	8d ba 40 61 11 80    	lea    -0x7fee9ec0(%edx),%edi
			swap_slots[i].page_perm = PTE_FLAGS(*pte);
80107a65:	25 ff 0f 00 00       	and    $0xfff,%eax
80107a6a:	89 82 44 61 11 80    	mov    %eax,-0x7fee9ebc(%edx)
			uint pa = PTE_ADDR(*pte);
80107a70:	8b 1e                	mov    (%esi),%ebx
80107a72:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
			write_page_to_swap(swap_slots[i].blockno, (char*)P2V(pa));
80107a78:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107a7e:	53                   	push   %ebx
80107a7f:	ff b2 48 61 11 80    	push   -0x7fee9eb8(%edx)
80107a85:	e8 f6 87 ff ff       	call   80100280 <write_page_to_swap>
			// int refcnt = page_to_refcnt[pa >> PTXSHIFT];
			// this is needed because when we are swapping out a page that is referred to by 
			// multiple page table entries, we need to free the page only when all the references are gone
			// swap_slots[i].refcnt_to_disk = refcnt;
			// for(int i = 0 ; i < refcnt; i++){
				kfree((char*)P2V(pa));
80107a8a:	89 1c 24             	mov    %ebx,(%esp)
80107a8d:	e8 0e ab ff ff       	call   801025a0 <kfree>
			// }

			*pte = swap_slots[i].blockno << PTXSHIFT;
80107a92:	8b 47 08             	mov    0x8(%edi),%eax
80107a95:	c1 e0 0c             	shl    $0xc,%eax
			*pte |= PTE_FLAGS(*pte);
			*pte |= PTE_SW;
80107a98:	83 c8 08             	or     $0x8,%eax
80107a9b:	89 06                	mov    %eax,(%esi)
			*pte &= ~PTE_P;
			return;
		}
	}
	panic("Swap full\n");
}
80107a9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107aa0:	5b                   	pop    %ebx
80107aa1:	5e                   	pop    %esi
80107aa2:	5f                   	pop    %edi
80107aa3:	5d                   	pop    %ebp
80107aa4:	c3                   	ret
	panic("Swap full\n");
80107aa5:	83 ec 0c             	sub    $0xc,%esp
80107aa8:	68 74 82 10 80       	push   $0x80108274
80107aad:	e8 be 89 ff ff       	call   80100470 <panic>
80107ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107ac0 <cow_page>:
// the following function is called when a copy is needed to be created for the page pointed to by pte
// constratin : pte is present in the pagetable
void cow_page(pte_t * pte){
80107ac0:	55                   	push   %ebp
80107ac1:	89 e5                	mov    %esp,%ebp
80107ac3:	57                   	push   %edi
80107ac4:	56                   	push   %esi
80107ac5:	53                   	push   %ebx
80107ac6:	83 ec 0c             	sub    $0xc,%esp
80107ac9:	8b 75 08             	mov    0x8(%ebp),%esi
	char * copy_mem = kalloc();
80107acc:	e8 ef ac ff ff       	call   801027c0 <kalloc>
80107ad1:	89 c3                	mov    %eax,%ebx
	int * page_to_refcnt = get_refcnt_table();
80107ad3:	e8 b8 aa ff ff       	call   80102590 <get_refcnt_table>
	// allocating new page using kalloc
	if(copy_mem == 0){
80107ad8:	85 db                	test   %ebx,%ebx
80107ada:	74 7e                	je     80107b5a <cow_page+0x9a>
80107adc:	89 c7                	mov    %eax,%edi
		panic("kalloc failing in cow_page\n");
	}
	// whe arent we setting the refcnt of the new page to 1
	cprintf("before refcnt = %d", page_to_refcnt[(*pte) >> PTXSHIFT]);
80107ade:	8b 06                	mov    (%esi),%eax
80107ae0:	83 ec 08             	sub    $0x8,%esp
80107ae3:	c1 e8 0c             	shr    $0xc,%eax
80107ae6:	ff 34 87             	push   (%edi,%eax,4)
80107ae9:	68 9b 82 10 80       	push   $0x8010829b
80107aee:	e8 ad 8c ff ff       	call   801007a0 <cprintf>
	page_to_refcnt[(*pte) >> PTXSHIFT]--;
80107af3:	8b 06                	mov    (%esi),%eax
80107af5:	c1 e8 0c             	shr    $0xc,%eax
80107af8:	83 2c 87 01          	subl   $0x1,(%edi,%eax,4)
	cprintf("after refcnt = %d", page_to_refcnt[(*pte) >> PTXSHIFT]);
80107afc:	58                   	pop    %eax
80107afd:	8b 06                	mov    (%esi),%eax
80107aff:	5a                   	pop    %edx
80107b00:	c1 e8 0c             	shr    $0xc,%eax
80107b03:	ff 34 87             	push   (%edi,%eax,4)
80107b06:	68 ae 82 10 80       	push   $0x801082ae
80107b0b:	e8 90 8c ff ff       	call   801007a0 <cprintf>

	memmove(copy_mem, (char*)P2V(PTE_ADDR(*pte)), PGSIZE);
80107b10:	83 c4 0c             	add    $0xc,%esp
80107b13:	68 00 10 00 00       	push   $0x1000
80107b18:	8b 06                	mov    (%esi),%eax
80107b1a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b1f:	05 00 00 00 80       	add    $0x80000000,%eax
80107b24:	50                   	push   %eax
80107b25:	53                   	push   %ebx
	// now modify the pgdir
	*pte = V2P(copy_mem) | PTE_FLAGS(*pte) | PTE_W;
80107b26:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
	memmove(copy_mem, (char*)P2V(PTE_ADDR(*pte)), PGSIZE);
80107b2c:	e8 8f d0 ff ff       	call   80104bc0 <memmove>
	*pte = V2P(copy_mem) | PTE_FLAGS(*pte) | PTE_W;
80107b31:	8b 06                	mov    (%esi),%eax
80107b33:	25 ff 0f 00 00       	and    $0xfff,%eax
80107b38:	09 c3                	or     %eax,%ebx
80107b3a:	83 cb 02             	or     $0x2,%ebx
80107b3d:	89 1e                	mov    %ebx,(%esi)
	lcr3(V2P(myproc()->pgdir));
80107b3f:	e8 fc bf ff ff       	call   80103b40 <myproc>
80107b44:	8b 40 08             	mov    0x8(%eax),%eax
80107b47:	05 00 00 00 80       	add    $0x80000000,%eax
80107b4c:	0f 22 d8             	mov    %eax,%cr3

}
80107b4f:	83 c4 10             	add    $0x10,%esp
80107b52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b55:	5b                   	pop    %ebx
80107b56:	5e                   	pop    %esi
80107b57:	5f                   	pop    %edi
80107b58:	5d                   	pop    %ebp
80107b59:	c3                   	ret
		panic("kalloc failing in cow_page\n");
80107b5a:	83 ec 0c             	sub    $0xc,%esp
80107b5d:	68 7f 82 10 80       	push   $0x8010827f
80107b62:	e8 09 89 ff ff       	call   80100470 <panic>
80107b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b6e:	66 90                	xchg   %ax,%ax

80107b70 <clear_slot>:

void clear_slot(pte_t* page){
80107b70:	55                   	push   %ebp
80107b71:	89 e5                	mov    %esp,%ebp
	int blockno = PTE_ADDR(*page) >> PTXSHIFT;
80107b73:	8b 45 08             	mov    0x8(%ebp),%eax
	swap_slots[(blockno - SWAPBASE) / BPPAGE].is_free = FREE;
}
80107b76:	5d                   	pop    %ebp
	int blockno = PTE_ADDR(*page) >> PTXSHIFT;
80107b77:	8b 10                	mov    (%eax),%edx
80107b79:	c1 ea 0c             	shr    $0xc,%edx
	swap_slots[(blockno - SWAPBASE) / BPPAGE].is_free = FREE;
80107b7c:	8d 42 05             	lea    0x5(%edx),%eax
80107b7f:	83 ea 02             	sub    $0x2,%edx
80107b82:	0f 49 c2             	cmovns %edx,%eax
80107b85:	c1 f8 03             	sar    $0x3,%eax
80107b88:	c1 e0 04             	shl    $0x4,%eax
80107b8b:	c7 80 40 61 11 80 01 	movl   $0x1,-0x7fee9ec0(%eax)
80107b92:	00 00 00 
}
80107b95:	c3                   	ret
80107b96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b9d:	8d 76 00             	lea    0x0(%esi),%esi

80107ba0 <dec_swap_slot_refcnt>:
int dec_swap_slot_refcnt(pte_t * pte){
80107ba0:	55                   	push   %ebp
80107ba1:	89 e5                	mov    %esp,%ebp
80107ba3:	83 ec 08             	sub    $0x8,%esp
	int blockno = PTE_ADDR(*pte) >> PTXSHIFT;
80107ba6:	8b 45 08             	mov    0x8(%ebp),%eax
80107ba9:	8b 00                	mov    (%eax),%eax
80107bab:	c1 e8 0c             	shr    $0xc,%eax
	int x = swap_slots[(blockno - SWAPBASE) / BPPAGE].refcnt_to_disk;
80107bae:	8d 50 05             	lea    0x5(%eax),%edx
80107bb1:	83 e8 02             	sub    $0x2,%eax
80107bb4:	0f 49 d0             	cmovns %eax,%edx
80107bb7:	c1 fa 03             	sar    $0x3,%edx
80107bba:	c1 e2 04             	shl    $0x4,%edx
80107bbd:	81 c2 40 61 11 80    	add    $0x80116140,%edx
80107bc3:	8b 42 0c             	mov    0xc(%edx),%eax
	if(x == 0){
80107bc6:	85 c0                	test   %eax,%eax
80107bc8:	74 08                	je     80107bd2 <dec_swap_slot_refcnt+0x32>
		panic("refcnt already 0\n");
	}
	return --(swap_slots[(blockno - SWAPBASE) / BPPAGE].refcnt_to_disk);
80107bca:	83 e8 01             	sub    $0x1,%eax
80107bcd:	89 42 0c             	mov    %eax,0xc(%edx)
};
80107bd0:	c9                   	leave
80107bd1:	c3                   	ret
		panic("refcnt already 0\n");
80107bd2:	83 ec 0c             	sub    $0xc,%esp
80107bd5:	68 c0 82 10 80       	push   $0x801082c0
80107bda:	e8 91 88 ff ff       	call   80100470 <panic>
80107bdf:	90                   	nop

80107be0 <handle_page_fault>:
void handle_page_fault(){
80107be0:	55                   	push   %ebp
80107be1:	89 e5                	mov    %esp,%ebp
80107be3:	57                   	push   %edi
80107be4:	56                   	push   %esi
80107be5:	53                   	push   %ebx
80107be6:	83 ec 1c             	sub    $0x1c,%esp
	// cprintf("Page fault\n");
	int * page_to_refcnt = get_refcnt_table();
80107be9:	e8 a2 a9 ff ff       	call   80102590 <get_refcnt_table>
80107bee:	89 c3                	mov    %eax,%ebx
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107bf0:	0f 20 d6             	mov    %cr2,%esi
	uint va = rcr2();
	struct proc* p = myproc();
80107bf3:	e8 48 bf ff ff       	call   80103b40 <myproc>
  pde = &pgdir[PDX(va)];
80107bf8:	89 f2                	mov    %esi,%edx
	struct proc* p = myproc();
80107bfa:	89 c7                	mov    %eax,%edi
  if(*pde & PTE_P){
80107bfc:	8b 40 08             	mov    0x8(%eax),%eax
  pde = &pgdir[PDX(va)];
80107bff:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107c02:	8b 04 90             	mov    (%eax,%edx,4),%eax
80107c05:	a8 01                	test   $0x1,%al
80107c07:	0f 84 17 01 00 00    	je     80107d24 <handle_page_fault.cold>
  return &pgtab[PTX(va)];
80107c0d:	c1 ee 0a             	shr    $0xa,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107c10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107c15:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80107c1b:	8d b4 30 00 00 00 80 	lea    -0x80000000(%eax,%esi,1),%esi
	pte_t * pte = walkpgdir(p->pgdir, (void*) va, 0);
	if(*pte & PTE_P){
80107c22:	f6 06 01             	testb  $0x1,(%esi)
80107c25:	74 39                	je     80107c60 <handle_page_fault+0x80>
		// 
		cprintf("page fault due to cow\n");
80107c27:	83 ec 0c             	sub    $0xc,%esp
80107c2a:	68 d2 82 10 80       	push   $0x801082d2
80107c2f:	e8 6c 8b ff ff       	call   801007a0 <cprintf>
		if(page_to_refcnt[*pte >> PTXSHIFT] > 1){
80107c34:	8b 06                	mov    (%esi),%eax
80107c36:	83 c4 10             	add    $0x10,%esp
80107c39:	c1 e8 0c             	shr    $0xc,%eax
80107c3c:	83 3c 83 01          	cmpl   $0x1,(%ebx,%eax,4)
80107c40:	0f 8e aa 00 00 00    	jle    80107cf0 <handle_page_fault+0x110>
			// copy on write
			cow_page(pte);
80107c46:	83 ec 0c             	sub    $0xc,%esp
80107c49:	56                   	push   %esi
80107c4a:	e8 71 fe ff ff       	call   80107ac0 <cow_page>
80107c4f:	83 c4 10             	add    $0x10,%esp
		page_to_refcnt[(*pte) >> PTXSHIFT] = swap_slots[swap_slot_i].refcnt_to_disk;
		*pte = (V2P(pg) & ~0xFFF)  | swap_slots[swap_slot_i].page_perm;
		*pte |= PTE_P;
		swap_slots[swap_slot_i].is_free = FREE;
	}
80107c52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c55:	5b                   	pop    %ebx
80107c56:	5e                   	pop    %esi
80107c57:	5f                   	pop    %edi
80107c58:	5d                   	pop    %ebp
80107c59:	c3                   	ret
80107c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		cprintf("normal pagefault\n");
80107c60:	83 ec 0c             	sub    $0xc,%esp
80107c63:	68 e9 82 10 80       	push   $0x801082e9
80107c68:	e8 33 8b ff ff       	call   801007a0 <cprintf>
		char * pg = kalloc();
80107c6d:	e8 4e ab ff ff       	call   801027c0 <kalloc>
		if(pg == 0){
80107c72:	83 c4 10             	add    $0x10,%esp
		char * pg = kalloc();
80107c75:	89 c3                	mov    %eax,%ebx
		if(pg == 0){
80107c77:	85 c0                	test   %eax,%eax
80107c79:	0f 84 98 00 00 00    	je     80107d17 <handle_page_fault+0x137>
		p->rss += PGSIZE;
80107c7f:	81 47 04 00 10 00 00 	addl   $0x1000,0x4(%edi)
		uint blockno = *pte >> PTXSHIFT;
80107c86:	8b 3e                	mov    (%esi),%edi
		read_page_from_swap(blockno, pg);
80107c88:	83 ec 08             	sub    $0x8,%esp
		*pte = (V2P(pg) & ~0xFFF)  | swap_slots[swap_slot_i].page_perm;
80107c8b:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
		read_page_from_swap(blockno, pg);
80107c91:	50                   	push   %eax
		*pte = (V2P(pg) & ~0xFFF)  | swap_slots[swap_slot_i].page_perm;
80107c92:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
		uint blockno = *pte >> PTXSHIFT;
80107c98:	c1 ef 0c             	shr    $0xc,%edi
		read_page_from_swap(blockno, pg);
80107c9b:	57                   	push   %edi
80107c9c:	e8 6f 86 ff ff       	call   80100310 <read_page_from_swap>
		int swap_slot_i = (blockno - SWAPBASE) / BPPAGE;
80107ca1:	8d 47 fe             	lea    -0x2(%edi),%eax
80107ca4:	c1 e8 03             	shr    $0x3,%eax
80107ca7:	89 c7                	mov    %eax,%edi
		int * page_to_refcnt = get_refcnt_table();
80107ca9:	e8 e2 a8 ff ff       	call   80102590 <get_refcnt_table>
		page_to_refcnt[(*pte) >> PTXSHIFT] = swap_slots[swap_slot_i].refcnt_to_disk;
80107cae:	8b 16                	mov    (%esi),%edx
		swap_slots[swap_slot_i].is_free = FREE;
80107cb0:	83 c4 10             	add    $0x10,%esp
		int * page_to_refcnt = get_refcnt_table();
80107cb3:	89 c1                	mov    %eax,%ecx
		page_to_refcnt[(*pte) >> PTXSHIFT] = swap_slots[swap_slot_i].refcnt_to_disk;
80107cb5:	89 f8                	mov    %edi,%eax
80107cb7:	c1 e0 04             	shl    $0x4,%eax
80107cba:	c1 ea 0c             	shr    $0xc,%edx
80107cbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107cc0:	8d b8 40 61 11 80    	lea    -0x7fee9ec0(%eax),%edi
80107cc6:	8b 80 4c 61 11 80    	mov    -0x7fee9eb4(%eax),%eax
80107ccc:	89 04 91             	mov    %eax,(%ecx,%edx,4)
		swap_slots[swap_slot_i].is_free = FREE;
80107ccf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		*pte = (V2P(pg) & ~0xFFF)  | swap_slots[swap_slot_i].page_perm;
80107cd2:	0b 5f 04             	or     0x4(%edi),%ebx
		*pte |= PTE_P;
80107cd5:	83 cb 01             	or     $0x1,%ebx
80107cd8:	89 1e                	mov    %ebx,(%esi)
		swap_slots[swap_slot_i].is_free = FREE;
80107cda:	c7 80 40 61 11 80 01 	movl   $0x1,-0x7fee9ec0(%eax)
80107ce1:	00 00 00 
80107ce4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ce7:	5b                   	pop    %ebx
80107ce8:	5e                   	pop    %esi
80107ce9:	5f                   	pop    %edi
80107cea:	5d                   	pop    %ebp
80107ceb:	c3                   	ret
80107cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			cprintf("no duplicatin is needed for pg = %d", *pte >> PTXSHIFT);
80107cf0:	83 ec 08             	sub    $0x8,%esp
80107cf3:	50                   	push   %eax
80107cf4:	68 08 85 10 80       	push   $0x80108508
80107cf9:	e8 a2 8a ff ff       	call   801007a0 <cprintf>
			*pte = *pte | PTE_W;
80107cfe:	83 0e 02             	orl    $0x2,(%esi)
			lcr3(V2P(p->pgdir));
80107d01:	8b 47 08             	mov    0x8(%edi),%eax
80107d04:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107d09:	0f 22 d8             	mov    %eax,%cr3
}
80107d0c:	83 c4 10             	add    $0x10,%esp
80107d0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d12:	5b                   	pop    %ebx
80107d13:	5e                   	pop    %esi
80107d14:	5f                   	pop    %edi
80107d15:	5d                   	pop    %ebp
80107d16:	c3                   	ret
			panic("kalloc failing in pagefault\n");
80107d17:	83 ec 0c             	sub    $0xc,%esp
80107d1a:	68 fb 82 10 80       	push   $0x801082fb
80107d1f:	e8 4c 87 ff ff       	call   80100470 <panic>

80107d24 <handle_page_fault.cold>:
	if(*pte & PTE_P){
80107d24:	a1 00 00 00 00       	mov    0x0,%eax
80107d29:	0f 0b                	ud2
