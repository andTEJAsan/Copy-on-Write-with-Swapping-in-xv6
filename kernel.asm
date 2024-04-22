
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
80100028:	bc 40 ba 1c 80       	mov    $0x801cba40,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 31 10 80       	mov    $0x801031f0,%eax
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
8010004c:	68 00 83 10 80       	push   $0x80108300
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 c5 47 00 00       	call   80104820 <initlock>
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
80100092:	68 07 83 10 80       	push   $0x80108307
80100097:	50                   	push   %eax
80100098:	e8 53 46 00 00       	call   801046f0 <initsleeplock>
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
801000e4:	e8 27 49 00 00       	call   80104a10 <acquire>
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
80100162:	e8 49 48 00 00       	call   801049b0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 45 00 00       	call   80104730 <acquiresleep>
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
801001a1:	68 0e 83 10 80       	push   $0x8010830e
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
801001be:	e8 0d 46 00 00       	call   801047d0 <holdingsleep>
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
801001dc:	68 1f 83 10 80       	push   $0x8010831f
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
801001ff:	e8 cc 45 00 00       	call   801047d0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 7c 45 00 00       	call   80104790 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 f0 47 00 00       	call   80104a10 <acquire>
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
80100269:	e9 42 47 00 00       	jmp    801049b0 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 26 83 10 80       	push   $0x80108326
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
801002b2:	e8 e9 48 00 00       	call   80104ba0 <memmove>
  if(!holdingsleep(&b->lock))
801002b7:	8d 47 0c             	lea    0xc(%edi),%eax
801002ba:	89 04 24             	mov    %eax,(%esp)
801002bd:	e8 0e 45 00 00       	call   801047d0 <holdingsleep>
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
801002fb:	68 1f 83 10 80       	push   $0x8010831f
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
8010034b:	e8 50 48 00 00       	call   80104ba0 <memmove>
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
80100390:	e8 7b 46 00 00       	call   80104a10 <acquire>
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
801003bd:	e8 8e 3e 00 00       	call   80104250 <sleep>
    while(input.r == input.w){
801003c2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801003c7:	83 c4 10             	add    $0x10,%esp
801003ca:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801003d0:	75 36                	jne    80100408 <consoleread+0x98>
      if(myproc()->killed){
801003d2:	e8 39 37 00 00       	call   80103b10 <myproc>
801003d7:	8b 48 28             	mov    0x28(%eax),%ecx
801003da:	85 c9                	test   %ecx,%ecx
801003dc:	74 d2                	je     801003b0 <consoleread+0x40>
        release(&cons.lock);
801003de:	83 ec 0c             	sub    $0xc,%esp
801003e1:	68 20 ff 10 80       	push   $0x8010ff20
801003e6:	e8 c5 45 00 00       	call   801049b0 <release>
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
8010043c:	e8 6f 45 00 00       	call   801049b0 <release>
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
80100489:	e8 02 26 00 00       	call   80102a90 <lapicid>
8010048e:	83 ec 08             	sub    $0x8,%esp
80100491:	50                   	push   %eax
80100492:	68 2d 83 10 80       	push   $0x8010832d
80100497:	e8 04 03 00 00       	call   801007a0 <cprintf>
  cprintf(s);
8010049c:	58                   	pop    %eax
8010049d:	ff 75 08             	push   0x8(%ebp)
801004a0:	e8 fb 02 00 00       	call   801007a0 <cprintf>
  cprintf("\n");
801004a5:	c7 04 24 bc 87 10 80 	movl   $0x801087bc,(%esp)
801004ac:	e8 ef 02 00 00       	call   801007a0 <cprintf>
  getcallerpcs(&s, pcs);
801004b1:	8d 45 08             	lea    0x8(%ebp),%eax
801004b4:	5a                   	pop    %edx
801004b5:	59                   	pop    %ecx
801004b6:	53                   	push   %ebx
801004b7:	50                   	push   %eax
801004b8:	e8 83 43 00 00       	call   80104840 <getcallerpcs>
  for(i=0; i<10; i++)
801004bd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801004c0:	83 ec 08             	sub    $0x8,%esp
801004c3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801004c5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801004c8:	68 41 83 10 80       	push   $0x80108341
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
8010050f:	e8 5c 5c 00 00       	call   80106170 <uartputc>
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
801005da:	e8 91 5b 00 00       	call   80106170 <uartputc>
801005df:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801005e6:	e8 85 5b 00 00       	call   80106170 <uartputc>
801005eb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801005f2:	e8 79 5b 00 00       	call   80106170 <uartputc>
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
80100651:	e8 4a 45 00 00       	call   80104ba0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100656:	b8 80 07 00 00       	mov    $0x780,%eax
8010065b:	83 c4 0c             	add    $0xc,%esp
8010065e:	29 d8                	sub    %ebx,%eax
80100660:	01 c0                	add    %eax,%eax
80100662:	50                   	push   %eax
80100663:	6a 00                	push   $0x0
80100665:	56                   	push   %esi
80100666:	e8 a5 44 00 00       	call   80104b10 <memset>
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
80100693:	68 45 83 10 80       	push   $0x80108345
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
801006bb:	e8 50 43 00 00       	call   80104a10 <acquire>
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
801006f4:	e8 b7 42 00 00       	call   801049b0 <release>
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
8010073b:	0f b6 92 b8 88 10 80 	movzbl -0x7fef7748(%edx),%edx
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
801008c8:	e8 43 41 00 00       	call   80104a10 <acquire>
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
801008eb:	e8 c0 40 00 00       	call   801049b0 <release>
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
8010092d:	bf 58 83 10 80       	mov    $0x80108358,%edi
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
8010097c:	68 5f 83 10 80       	push   $0x8010835f
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
801009a3:	e8 68 40 00 00       	call   80104a10 <acquire>
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
801009dd:	e8 ce 3f 00 00       	call   801049b0 <release>
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
80100b1c:	e8 ef 37 00 00       	call   80104310 <wakeup>
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
80100b3f:	e9 ac 38 00 00       	jmp    801043f0 <procdump>
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
80100b56:	68 68 83 10 80       	push   $0x80108368
80100b5b:	68 20 ff 10 80       	push   $0x8010ff20
80100b60:	e8 bb 3c 00 00       	call   80104820 <initlock>

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
80100bac:	e8 5f 2f 00 00       	call   80103b10 <myproc>
80100bb1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100bb7:	e8 44 23 00 00       	call   80102f00 <begin_op>

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
80100c0a:	e8 61 69 00 00       	call   80107570 <setupkvm>
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
80100c7b:	e8 f0 66 00 00       	call   80107370 <allocuvm>
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
80100cb1:	e8 ea 65 00 00       	call   801072a0 <loaduvm>
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
80100cf3:	e8 f8 67 00 00       	call   801074f0 <freevm>
  if(ip){
80100cf8:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100cfb:	83 ec 0c             	sub    $0xc,%esp
80100cfe:	57                   	push   %edi
80100cff:	e8 1c 0e 00 00       	call   80101b20 <iunlockput>
    end_op();
80100d04:	e8 67 22 00 00       	call   80102f70 <end_op>
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
80100d41:	e8 2a 22 00 00       	call   80102f70 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d46:	83 c4 0c             	add    $0xc,%esp
80100d49:	53                   	push   %ebx
80100d4a:	56                   	push   %esi
80100d4b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100d51:	56                   	push   %esi
80100d52:	e8 19 66 00 00       	call   80107370 <allocuvm>
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
80100d73:	e8 98 68 00 00       	call   80107610 <clearpteu>
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
80100dba:	e8 41 3f 00 00       	call   80104d00 <strlen>
80100dbf:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dc1:	58                   	pop    %eax
80100dc2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dc5:	83 eb 01             	sub    $0x1,%ebx
80100dc8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dcb:	e8 30 3f 00 00       	call   80104d00 <strlen>
80100dd0:	83 c0 01             	add    $0x1,%eax
80100dd3:	50                   	push   %eax
80100dd4:	ff 34 b7             	push   (%edi,%esi,4)
80100dd7:	53                   	push   %ebx
80100dd8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100dde:	e8 bd 6c 00 00       	call   80107aa0 <copyout>
80100de3:	83 c4 20             	add    $0x20,%esp
80100de6:	85 c0                	test   %eax,%eax
80100de8:	79 ae                	jns    80100d98 <exec+0x1f8>
    freevm(pgdir);
80100dea:	83 ec 0c             	sub    $0xc,%esp
80100ded:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100df3:	e8 f8 66 00 00       	call   801074f0 <freevm>
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
80100e4f:	e8 4c 6c 00 00       	call   80107aa0 <copyout>
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
80100e8f:	e8 2c 3e 00 00       	call   80104cc0 <safestrcpy>
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
80100ebb:	e8 50 62 00 00       	call   80107110 <switchuvm>
  freevm(oldpgdir);
80100ec0:	89 34 24             	mov    %esi,(%esp)
80100ec3:	e8 28 66 00 00       	call   801074f0 <freevm>
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
80100f02:	e8 69 20 00 00       	call   80102f70 <end_op>
    cprintf("exec: fail\n");
80100f07:	83 ec 0c             	sub    $0xc,%esp
80100f0a:	68 70 83 10 80       	push   $0x80108370
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
80100f26:	68 7c 83 10 80       	push   $0x8010837c
80100f2b:	68 60 ff 10 80       	push   $0x8010ff60
80100f30:	e8 eb 38 00 00       	call   80104820 <initlock>
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
80100f51:	e8 ba 3a 00 00       	call   80104a10 <acquire>
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
80100f81:	e8 2a 3a 00 00       	call   801049b0 <release>
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
80100f9a:	e8 11 3a 00 00       	call   801049b0 <release>
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
80100fbf:	e8 4c 3a 00 00       	call   80104a10 <acquire>
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
80100fdc:	e8 cf 39 00 00       	call   801049b0 <release>
  return f;
}
80100fe1:	89 d8                	mov    %ebx,%eax
80100fe3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fe6:	c9                   	leave
80100fe7:	c3                   	ret
    panic("filedup");
80100fe8:	83 ec 0c             	sub    $0xc,%esp
80100feb:	68 83 83 10 80       	push   $0x80108383
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
80101011:	e8 fa 39 00 00       	call   80104a10 <acquire>
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
8010104c:	e8 5f 39 00 00       	call   801049b0 <release>

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
8010107e:	e9 2d 39 00 00       	jmp    801049b0 <release>
80101083:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101087:	90                   	nop
    begin_op();
80101088:	e8 73 1e 00 00       	call   80102f00 <begin_op>
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
801010a2:	e9 c9 1e 00 00       	jmp    80102f70 <end_op>
801010a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ae:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801010b0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801010b4:	83 ec 08             	sub    $0x8,%esp
801010b7:	53                   	push   %ebx
801010b8:	56                   	push   %esi
801010b9:	e8 02 26 00 00       	call   801036c0 <pipeclose>
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
801010cc:	68 8b 83 10 80       	push   $0x8010838b
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
8010119d:	e9 de 26 00 00       	jmp    80103880 <piperead>
801011a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801011a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801011ad:	eb d7                	jmp    80101186 <fileread+0x56>
  panic("fileread");
801011af:	83 ec 0c             	sub    $0xc,%esp
801011b2:	68 95 83 10 80       	push   $0x80108395
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
80101219:	e8 52 1d 00 00       	call   80102f70 <end_op>

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
8010123e:	e8 bd 1c 00 00       	call   80102f00 <begin_op>
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
80101275:	e8 f6 1c 00 00       	call   80102f70 <end_op>
      if(r < 0)
8010127a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010127d:	83 c4 10             	add    $0x10,%esp
80101280:	85 c0                	test   %eax,%eax
80101282:	75 14                	jne    80101298 <filewrite+0xd8>
        panic("short filewrite");
80101284:	83 ec 0c             	sub    $0xc,%esp
80101287:	68 9e 83 10 80       	push   $0x8010839e
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
801012b9:	e9 a2 24 00 00       	jmp    80103760 <pipewrite>
  panic("filewrite");
801012be:	83 ec 0c             	sub    $0xc,%esp
801012c1:	68 a4 83 10 80       	push   $0x801083a4
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
80101379:	68 ae 83 10 80       	push   $0x801083ae
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
80101395:	e8 46 1d 00 00       	call   801030e0 <log_write>
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
801013bd:	e8 4e 37 00 00       	call   80104b10 <memset>
  log_write(bp);
801013c2:	89 1c 24             	mov    %ebx,(%esp)
801013c5:	e8 16 1d 00 00       	call   801030e0 <log_write>
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
801013fa:	e8 11 36 00 00       	call   80104a10 <acquire>
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
80101467:	e8 44 35 00 00       	call   801049b0 <release>

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
80101495:	e8 16 35 00 00       	call   801049b0 <release>
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
801014c8:	68 c4 83 10 80       	push   $0x801083c4
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
8010152d:	e8 ae 1b 00 00       	call   801030e0 <log_write>
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
80101547:	68 d4 83 10 80       	push   $0x801083d4
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
801015d5:	e8 06 1b 00 00       	call   801030e0 <log_write>
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
80101625:	68 e7 83 10 80       	push   $0x801083e7
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
80101651:	e8 4a 35 00 00       	call   80104ba0 <memmove>
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
8010167c:	68 fa 83 10 80       	push   $0x801083fa
80101681:	68 60 09 11 80       	push   $0x80110960
80101686:	e8 95 31 00 00       	call   80104820 <initlock>
  for(i = 0; i < NINODE; i++) {
8010168b:	83 c4 10             	add    $0x10,%esp
8010168e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101690:	83 ec 08             	sub    $0x8,%esp
80101693:	68 01 84 10 80       	push   $0x80108401
80101698:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101699:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010169f:	e8 4c 30 00 00       	call   801046f0 <initsleeplock>
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
801016cc:	e8 cf 34 00 00       	call   80104ba0 <memmove>
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
80101703:	68 cc 88 10 80       	push   $0x801088cc
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
8010179e:	e8 6d 33 00 00       	call   80104b10 <memset>
      dip->type = type;
801017a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017ad:	89 1c 24             	mov    %ebx,(%esp)
801017b0:	e8 2b 19 00 00       	call   801030e0 <log_write>
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
801017d3:	68 07 84 10 80       	push   $0x80108407
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
80101841:	e8 5a 33 00 00       	call   80104ba0 <memmove>
  log_write(bp);
80101846:	89 34 24             	mov    %esi,(%esp)
80101849:	e8 92 18 00 00       	call   801030e0 <log_write>
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
8010186f:	e8 9c 31 00 00       	call   80104a10 <acquire>
  ip->ref++;
80101874:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101878:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010187f:	e8 2c 31 00 00       	call   801049b0 <release>
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
801018b2:	e8 79 2e 00 00       	call   80104730 <acquiresleep>
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
80101928:	e8 73 32 00 00       	call   80104ba0 <memmove>
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
8010194d:	68 1f 84 10 80       	push   $0x8010841f
80101952:	e8 19 eb ff ff       	call   80100470 <panic>
    panic("ilock");
80101957:	83 ec 0c             	sub    $0xc,%esp
8010195a:	68 19 84 10 80       	push   $0x80108419
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
80101983:	e8 48 2e 00 00       	call   801047d0 <holdingsleep>
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
8010199f:	e9 ec 2d 00 00       	jmp    80104790 <releasesleep>
    panic("iunlock");
801019a4:	83 ec 0c             	sub    $0xc,%esp
801019a7:	68 2e 84 10 80       	push   $0x8010842e
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
801019d0:	e8 5b 2d 00 00       	call   80104730 <acquiresleep>
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
801019ea:	e8 a1 2d 00 00       	call   80104790 <releasesleep>
  acquire(&icache.lock);
801019ef:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801019f6:	e8 15 30 00 00       	call   80104a10 <acquire>
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
80101a10:	e9 9b 2f 00 00       	jmp    801049b0 <release>
80101a15:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101a18:	83 ec 0c             	sub    $0xc,%esp
80101a1b:	68 60 09 11 80       	push   $0x80110960
80101a20:	e8 eb 2f 00 00       	call   80104a10 <acquire>
    int r = ip->ref;
80101a25:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a28:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101a2f:	e8 7c 2f 00 00       	call   801049b0 <release>
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
80101b33:	e8 98 2c 00 00       	call   801047d0 <holdingsleep>
80101b38:	83 c4 10             	add    $0x10,%esp
80101b3b:	85 c0                	test   %eax,%eax
80101b3d:	74 21                	je     80101b60 <iunlockput+0x40>
80101b3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b42:	85 c0                	test   %eax,%eax
80101b44:	7e 1a                	jle    80101b60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101b46:	83 ec 0c             	sub    $0xc,%esp
80101b49:	56                   	push   %esi
80101b4a:	e8 41 2c 00 00       	call   80104790 <releasesleep>
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
80101b63:	68 2e 84 10 80       	push   $0x8010842e
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
80101c47:	e8 54 2f 00 00       	call   80104ba0 <memmove>
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
80101d45:	e8 56 2e 00 00       	call   80104ba0 <memmove>
    log_write(bp);
80101d4a:	89 34 24             	mov    %esi,(%esp)
80101d4d:	e8 8e 13 00 00       	call   801030e0 <log_write>
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
80101dce:	e8 3d 2e 00 00       	call   80104c10 <strncmp>
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
80101e2d:	e8 de 2d 00 00       	call   80104c10 <strncmp>
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
80101e72:	68 48 84 10 80       	push   $0x80108448
80101e77:	e8 f4 e5 ff ff       	call   80100470 <panic>
    panic("dirlookup not DIR");
80101e7c:	83 ec 0c             	sub    $0xc,%esp
80101e7f:	68 36 84 10 80       	push   $0x80108436
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
80101eaa:	e8 61 1c 00 00       	call   80103b10 <myproc>
  acquire(&icache.lock);
80101eaf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101eb2:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101eb5:	68 60 09 11 80       	push   $0x80110960
80101eba:	e8 51 2b 00 00       	call   80104a10 <acquire>
  ip->ref++;
80101ebf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ec3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101eca:	e8 e1 2a 00 00       	call   801049b0 <release>
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
80101f27:	e8 74 2c 00 00       	call   80104ba0 <memmove>
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
80101f8c:	e8 3f 28 00 00       	call   801047d0 <holdingsleep>
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
80101fae:	e8 dd 27 00 00       	call   80104790 <releasesleep>
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
80101fdb:	e8 c0 2b 00 00       	call   80104ba0 <memmove>
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
80102015:	e8 b6 27 00 00       	call   801047d0 <holdingsleep>
8010201a:	83 c4 10             	add    $0x10,%esp
8010201d:	85 c0                	test   %eax,%eax
8010201f:	74 7d                	je     8010209e <namex+0x20e>
80102021:	8b 4e 08             	mov    0x8(%esi),%ecx
80102024:	85 c9                	test   %ecx,%ecx
80102026:	7e 76                	jle    8010209e <namex+0x20e>
  releasesleep(&ip->lock);
80102028:	83 ec 0c             	sub    $0xc,%esp
8010202b:	53                   	push   %ebx
8010202c:	e8 5f 27 00 00       	call   80104790 <releasesleep>
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
80102065:	e8 66 27 00 00       	call   801047d0 <holdingsleep>
8010206a:	83 c4 10             	add    $0x10,%esp
8010206d:	85 c0                	test   %eax,%eax
8010206f:	74 2d                	je     8010209e <namex+0x20e>
80102071:	8b 7e 08             	mov    0x8(%esi),%edi
80102074:	85 ff                	test   %edi,%edi
80102076:	7e 26                	jle    8010209e <namex+0x20e>
  releasesleep(&ip->lock);
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	53                   	push   %ebx
8010207c:	e8 0f 27 00 00       	call   80104790 <releasesleep>
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
801020a1:	68 2e 84 10 80       	push   $0x8010842e
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
8010210d:	e8 4e 2b 00 00       	call   80104c60 <strncpy>
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
8010214b:	68 57 84 10 80       	push   $0x80108457
80102150:	e8 1b e3 ff ff       	call   80100470 <panic>
    panic("dirlink");
80102155:	83 ec 0c             	sub    $0xc,%esp
80102158:	68 c0 86 10 80       	push   $0x801086c0
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
8010226b:	68 6d 84 10 80       	push   $0x8010846d
80102270:	e8 fb e1 ff ff       	call   80100470 <panic>
    panic("idestart");
80102275:	83 ec 0c             	sub    $0xc,%esp
80102278:	68 64 84 10 80       	push   $0x80108464
8010227d:	e8 ee e1 ff ff       	call   80100470 <panic>
80102282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102290 <ideinit>:
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102296:	68 7f 84 10 80       	push   $0x8010847f
8010229b:	68 20 26 11 80       	push   $0x80112620
801022a0:	e8 7b 25 00 00       	call   80104820 <initlock>
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
8010232e:	e8 dd 26 00 00       	call   80104a10 <acquire>

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
8010238d:	e8 7e 1f 00 00       	call   80104310 <wakeup>

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
801023ab:	e8 00 26 00 00       	call   801049b0 <release>

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
801023ce:	e8 fd 23 00 00       	call   801047d0 <holdingsleep>
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
80102408:	e8 03 26 00 00       	call   80104a10 <acquire>

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
80102449:	e8 02 1e 00 00       	call   80104250 <sleep>
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
80102466:	e9 45 25 00 00       	jmp    801049b0 <release>
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
8010248a:	68 ae 84 10 80       	push   $0x801084ae
8010248f:	e8 dc df ff ff       	call   80100470 <panic>
    panic("iderw: nothing to do");
80102494:	83 ec 0c             	sub    $0xc,%esp
80102497:	68 99 84 10 80       	push   $0x80108499
8010249c:	e8 cf df ff ff       	call   80100470 <panic>
    panic("iderw: buf not locked");
801024a1:	83 ec 0c             	sub    $0xc,%esp
801024a4:	68 83 84 10 80       	push   $0x80108483
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
801024fa:	68 20 89 10 80       	push   $0x80108920
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
801025b0:	0f 85 94 00 00 00    	jne    8010264a <kfree+0xaa>
801025b6:	81 fb 40 ba 1c 80    	cmp    $0x801cba40,%ebx
801025bc:	0f 82 88 00 00 00    	jb     8010264a <kfree+0xaa>
801025c2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801025c8:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
801025cd:	77 7b                	ja     8010264a <kfree+0xaa>
    panic("kfree");
  // Fill with junk to catch dangling refs.
  if(get_refcnt(V2P(v)) == 0){
801025cf:	83 ec 0c             	sub    $0xc,%esp
801025d2:	50                   	push   %eax
801025d3:	e8 38 59 00 00       	call   80107f10 <get_refcnt>
801025d8:	83 c4 10             	add    $0x10,%esp
801025db:	85 c0                	test   %eax,%eax
801025dd:	74 09                	je     801025e8 <kfree+0x48>
  }
  else{
    // cprintf("page %d is not free\n", V2P(v) >> PTXSHIFT);
    // cprintf("Wait till refcnt is 0\n");
  }
}
801025df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025e2:	c9                   	leave
801025e3:	c3                   	ret
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(v, 1, PGSIZE);
801025e8:	83 ec 04             	sub    $0x4,%esp
801025eb:	68 00 10 00 00       	push   $0x1000
801025f0:	6a 01                	push   $0x1
801025f2:	53                   	push   %ebx
801025f3:	e8 18 25 00 00       	call   80104b10 <memset>
    if(kmem.use_lock)
801025f8:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801025fe:	83 c4 10             	add    $0x10,%esp
80102601:	85 d2                	test   %edx,%edx
80102603:	75 33                	jne    80102638 <kfree+0x98>
    r->next = kmem.freelist;
80102605:	a1 9c 26 11 80       	mov    0x8011269c,%eax
8010260a:	89 03                	mov    %eax,(%ebx)
    if(kmem.use_lock)
8010260c:	a1 94 26 11 80       	mov    0x80112694,%eax
    kmem.num_free_pages+=1;
80102611:	83 05 98 26 11 80 01 	addl   $0x1,0x80112698
    kmem.freelist = r;
80102618:	89 1d 9c 26 11 80    	mov    %ebx,0x8011269c
    if(kmem.use_lock)
8010261e:	85 c0                	test   %eax,%eax
80102620:	74 bd                	je     801025df <kfree+0x3f>
      release(&kmem.lock);
80102622:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102629:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010262c:	c9                   	leave
      release(&kmem.lock);
8010262d:	e9 7e 23 00 00       	jmp    801049b0 <release>
80102632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&kmem.lock);
80102638:	83 ec 0c             	sub    $0xc,%esp
8010263b:	68 60 26 11 80       	push   $0x80112660
80102640:	e8 cb 23 00 00       	call   80104a10 <acquire>
80102645:	83 c4 10             	add    $0x10,%esp
80102648:	eb bb                	jmp    80102605 <kfree+0x65>
    panic("kfree");
8010264a:	83 ec 0c             	sub    $0xc,%esp
8010264d:	68 cc 84 10 80       	push   $0x801084cc
80102652:	e8 19 de ff ff       	call   80100470 <panic>
80102657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010265e:	66 90                	xchg   %ax,%ax

80102660 <freerange>:
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	56                   	push   %esi
80102664:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102665:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102668:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010266b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102671:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102677:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010267d:	39 de                	cmp    %ebx,%esi
8010267f:	72 31                	jb     801026b2 <freerange+0x52>
80102681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    init_refcnt(V2P(p));
80102688:	83 ec 0c             	sub    $0xc,%esp
8010268b:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
80102691:	50                   	push   %eax
80102692:	e8 99 58 00 00       	call   80107f30 <init_refcnt>
    kfree(p);
80102697:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010269d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026a3:	89 04 24             	mov    %eax,(%esp)
801026a6:	e8 f5 fe ff ff       	call   801025a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026ab:	83 c4 10             	add    $0x10,%esp
801026ae:	39 de                	cmp    %ebx,%esi
801026b0:	73 d6                	jae    80102688 <freerange+0x28>
}
801026b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026b5:	5b                   	pop    %ebx
801026b6:	5e                   	pop    %esi
801026b7:	5d                   	pop    %ebp
801026b8:	c3                   	ret
801026b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801026c0 <kinit2>:
{
801026c0:	55                   	push   %ebp
801026c1:	89 e5                	mov    %esp,%ebp
801026c3:	56                   	push   %esi
801026c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801026cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026dd:	39 de                	cmp    %ebx,%esi
801026df:	72 31                	jb     80102712 <kinit2+0x52>
801026e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    init_refcnt(V2P(p));
801026e8:	83 ec 0c             	sub    $0xc,%esp
801026eb:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
801026f1:	50                   	push   %eax
801026f2:	e8 39 58 00 00       	call   80107f30 <init_refcnt>
    kfree(p);
801026f7:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026fd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102703:	89 04 24             	mov    %eax,(%esp)
80102706:	e8 95 fe ff ff       	call   801025a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010270b:	83 c4 10             	add    $0x10,%esp
8010270e:	39 de                	cmp    %ebx,%esi
80102710:	73 d6                	jae    801026e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102712:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
80102719:	00 00 00 
}
8010271c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010271f:	5b                   	pop    %ebx
80102720:	5e                   	pop    %esi
80102721:	5d                   	pop    %ebp
80102722:	c3                   	ret
80102723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102730 <kinit1>:
{
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
80102733:	56                   	push   %esi
80102734:	53                   	push   %ebx
80102735:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102738:	83 ec 08             	sub    $0x8,%esp
8010273b:	68 d2 84 10 80       	push   $0x801084d2
80102740:	68 60 26 11 80       	push   $0x80112660
80102745:	e8 d6 20 00 00       	call   80104820 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010274a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010274d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102750:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102757:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010275a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102760:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102766:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010276c:	39 de                	cmp    %ebx,%esi
8010276e:	72 2a                	jb     8010279a <kinit1+0x6a>
    init_refcnt(V2P(p));
80102770:	83 ec 0c             	sub    $0xc,%esp
80102773:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
80102779:	50                   	push   %eax
8010277a:	e8 b1 57 00 00       	call   80107f30 <init_refcnt>
    kfree(p);
8010277f:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102785:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010278b:	89 04 24             	mov    %eax,(%esp)
8010278e:	e8 0d fe ff ff       	call   801025a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102793:	83 c4 10             	add    $0x10,%esp
80102796:	39 de                	cmp    %ebx,%esi
80102798:	73 d6                	jae    80102770 <kinit1+0x40>
}
8010279a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010279d:	5b                   	pop    %ebx
8010279e:	5e                   	pop    %esi
8010279f:	5d                   	pop    %ebp
801027a0:	c3                   	ret
801027a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027af:	90                   	nop

801027b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
801027b3:	53                   	push   %ebx
801027b4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801027b7:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
801027bd:	85 c9                	test   %ecx,%ecx
801027bf:	75 58                	jne    80102819 <kalloc+0x69>
801027c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
  r = kmem.freelist;
801027c8:	8b 1d 9c 26 11 80    	mov    0x8011269c,%ebx
  if(r)
801027ce:	85 db                	test   %ebx,%ebx
801027d0:	74 38                	je     8010280a <kalloc+0x5a>
  {
    kmem.freelist = r->next;
801027d2:	8b 03                	mov    (%ebx),%eax
    kmem.num_free_pages-=1;
801027d4:	83 2d 98 26 11 80 01 	subl   $0x1,0x80112698
    kmem.freelist = r->next;
801027db:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  if(r) {
    return (char*)r;
  }
  swap_out();
  return kalloc();
}
801027e0:	89 d8                	mov    %ebx,%eax
801027e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027e5:	c9                   	leave
801027e6:	c3                   	ret
801027e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ee:	66 90                	xchg   %ax,%ax
  if(kmem.use_lock)
801027f0:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801027f6:	85 d2                	test   %edx,%edx
801027f8:	74 10                	je     8010280a <kalloc+0x5a>
    release(&kmem.lock);
801027fa:	83 ec 0c             	sub    $0xc,%esp
801027fd:	68 60 26 11 80       	push   $0x80112660
80102802:	e8 a9 21 00 00       	call   801049b0 <release>
80102807:	83 c4 10             	add    $0x10,%esp
  swap_out();
8010280a:	e8 41 57 00 00       	call   80107f50 <swap_out>
  if(kmem.use_lock)
8010280f:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
80102815:	85 c9                	test   %ecx,%ecx
80102817:	74 af                	je     801027c8 <kalloc+0x18>
    acquire(&kmem.lock);
80102819:	83 ec 0c             	sub    $0xc,%esp
8010281c:	68 60 26 11 80       	push   $0x80112660
80102821:	e8 ea 21 00 00       	call   80104a10 <acquire>
  r = kmem.freelist;
80102826:	8b 1d 9c 26 11 80    	mov    0x8011269c,%ebx
  if(r)
8010282c:	83 c4 10             	add    $0x10,%esp
8010282f:	85 db                	test   %ebx,%ebx
80102831:	74 bd                	je     801027f0 <kalloc+0x40>
    kmem.freelist = r->next;
80102833:	8b 03                	mov    (%ebx),%eax
    kmem.num_free_pages-=1;
80102835:	83 2d 98 26 11 80 01 	subl   $0x1,0x80112698
    kmem.freelist = r->next;
8010283c:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  if(kmem.use_lock)
80102841:	a1 94 26 11 80       	mov    0x80112694,%eax
80102846:	85 c0                	test   %eax,%eax
80102848:	74 96                	je     801027e0 <kalloc+0x30>
    release(&kmem.lock);
8010284a:	83 ec 0c             	sub    $0xc,%esp
8010284d:	68 60 26 11 80       	push   $0x80112660
80102852:	e8 59 21 00 00       	call   801049b0 <release>
}
80102857:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
80102859:	83 c4 10             	add    $0x10,%esp
}
8010285c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010285f:	c9                   	leave
80102860:	c3                   	ret
80102861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102868:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010286f:	90                   	nop

80102870 <num_of_FreePages>:
uint 
num_of_FreePages(void)
{
80102870:	55                   	push   %ebp
80102871:	89 e5                	mov    %esp,%ebp
80102873:	53                   	push   %ebx
80102874:	83 ec 10             	sub    $0x10,%esp
  acquire(&kmem.lock);
80102877:	68 60 26 11 80       	push   $0x80112660
8010287c:	e8 8f 21 00 00       	call   80104a10 <acquire>

  uint num_free_pages = kmem.num_free_pages;
80102881:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  
  release(&kmem.lock);
80102887:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
8010288e:	e8 1d 21 00 00       	call   801049b0 <release>
  
  return num_free_pages;
}
80102893:	89 d8                	mov    %ebx,%eax
80102895:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102898:	c9                   	leave
80102899:	c3                   	ret
8010289a:	66 90                	xchg   %ax,%ax
8010289c:	66 90                	xchg   %ax,%ax
8010289e:	66 90                	xchg   %ax,%ax

801028a0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a0:	ba 64 00 00 00       	mov    $0x64,%edx
801028a5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028a6:	a8 01                	test   $0x1,%al
801028a8:	0f 84 c2 00 00 00    	je     80102970 <kbdgetc+0xd0>
{
801028ae:	55                   	push   %ebp
801028af:	ba 60 00 00 00       	mov    $0x60,%edx
801028b4:	89 e5                	mov    %esp,%ebp
801028b6:	53                   	push   %ebx
801028b7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801028b8:	8b 1d a0 36 11 80    	mov    0x801136a0,%ebx
  data = inb(KBDATAP);
801028be:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801028c1:	3c e0                	cmp    $0xe0,%al
801028c3:	74 5b                	je     80102920 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028c5:	89 da                	mov    %ebx,%edx
801028c7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801028ca:	84 c0                	test   %al,%al
801028cc:	78 62                	js     80102930 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801028ce:	85 d2                	test   %edx,%edx
801028d0:	74 09                	je     801028db <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028d2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801028d5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801028d8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801028db:	0f b6 91 e0 8b 10 80 	movzbl -0x7fef7420(%ecx),%edx
  shift ^= togglecode[data];
801028e2:	0f b6 81 e0 8a 10 80 	movzbl -0x7fef7520(%ecx),%eax
  shift |= shiftcode[data];
801028e9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801028eb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028ed:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801028ef:	89 15 a0 36 11 80    	mov    %edx,0x801136a0
  c = charcode[shift & (CTL | SHIFT)][data];
801028f5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801028f8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028fb:	8b 04 85 c0 8a 10 80 	mov    -0x7fef7540(,%eax,4),%eax
80102902:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102906:	74 0b                	je     80102913 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102908:	8d 50 9f             	lea    -0x61(%eax),%edx
8010290b:	83 fa 19             	cmp    $0x19,%edx
8010290e:	77 48                	ja     80102958 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102910:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102913:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102916:	c9                   	leave
80102917:	c3                   	ret
80102918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291f:	90                   	nop
    shift |= E0ESC;
80102920:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102923:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102925:	89 1d a0 36 11 80    	mov    %ebx,0x801136a0
}
8010292b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010292e:	c9                   	leave
8010292f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102930:	83 e0 7f             	and    $0x7f,%eax
80102933:	85 d2                	test   %edx,%edx
80102935:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102938:	0f b6 81 e0 8b 10 80 	movzbl -0x7fef7420(%ecx),%eax
8010293f:	83 c8 40             	or     $0x40,%eax
80102942:	0f b6 c0             	movzbl %al,%eax
80102945:	f7 d0                	not    %eax
80102947:	21 d8                	and    %ebx,%eax
80102949:	a3 a0 36 11 80       	mov    %eax,0x801136a0
    return 0;
8010294e:	31 c0                	xor    %eax,%eax
80102950:	eb d9                	jmp    8010292b <kbdgetc+0x8b>
80102952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102958:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010295b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010295e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102961:	c9                   	leave
      c += 'a' - 'A';
80102962:	83 f9 1a             	cmp    $0x1a,%ecx
80102965:	0f 42 c2             	cmovb  %edx,%eax
}
80102968:	c3                   	ret
80102969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102975:	c3                   	ret
80102976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010297d:	8d 76 00             	lea    0x0(%esi),%esi

80102980 <kbdintr>:

void
kbdintr(void)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
80102983:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102986:	68 a0 28 10 80       	push   $0x801028a0
8010298b:	e8 00 e0 ff ff       	call   80100990 <consoleintr>
}
80102990:	83 c4 10             	add    $0x10,%esp
80102993:	c9                   	leave
80102994:	c3                   	ret
80102995:	66 90                	xchg   %ax,%ax
80102997:	66 90                	xchg   %ax,%ax
80102999:	66 90                	xchg   %ax,%ax
8010299b:	66 90                	xchg   %ax,%ax
8010299d:	66 90                	xchg   %ax,%ax
8010299f:	90                   	nop

801029a0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029a0:	a1 a4 36 11 80       	mov    0x801136a4,%eax
801029a5:	85 c0                	test   %eax,%eax
801029a7:	0f 84 c3 00 00 00    	je     80102a70 <lapicinit+0xd0>
  lapic[index] = value;
801029ad:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029b4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ba:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029c1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029ce:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029d1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029db:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801029de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029e1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801029e8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ee:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801029f5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029f8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801029fb:	8b 50 30             	mov    0x30(%eax),%edx
801029fe:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102a04:	75 72                	jne    80102a78 <lapicinit+0xd8>
  lapic[index] = value;
80102a06:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a0d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a10:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a13:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a1a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a1d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a20:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a27:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a2d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a34:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a37:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a3a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a41:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a44:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a47:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a4e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a51:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a58:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a5e:	80 e6 10             	and    $0x10,%dh
80102a61:	75 f5                	jne    80102a58 <lapicinit+0xb8>
  lapic[index] = value;
80102a63:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a6a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a6d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a70:	c3                   	ret
80102a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102a78:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a7f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a82:	8b 50 20             	mov    0x20(%eax),%edx
}
80102a85:	e9 7c ff ff ff       	jmp    80102a06 <lapicinit+0x66>
80102a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a90 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a90:	a1 a4 36 11 80       	mov    0x801136a4,%eax
80102a95:	85 c0                	test   %eax,%eax
80102a97:	74 07                	je     80102aa0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102a99:	8b 40 20             	mov    0x20(%eax),%eax
80102a9c:	c1 e8 18             	shr    $0x18,%eax
80102a9f:	c3                   	ret
    return 0;
80102aa0:	31 c0                	xor    %eax,%eax
}
80102aa2:	c3                   	ret
80102aa3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ab0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ab0:	a1 a4 36 11 80       	mov    0x801136a4,%eax
80102ab5:	85 c0                	test   %eax,%eax
80102ab7:	74 0d                	je     80102ac6 <lapiceoi+0x16>
  lapic[index] = value;
80102ab9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ac0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102ac6:	c3                   	ret
80102ac7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ace:	66 90                	xchg   %ax,%ax

80102ad0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102ad0:	c3                   	ret
80102ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ad8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102adf:	90                   	nop

80102ae0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ae0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102ae6:	ba 70 00 00 00       	mov    $0x70,%edx
80102aeb:	89 e5                	mov    %esp,%ebp
80102aed:	53                   	push   %ebx
80102aee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102af1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102af4:	ee                   	out    %al,(%dx)
80102af5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102afa:	ba 71 00 00 00       	mov    $0x71,%edx
80102aff:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b00:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102b02:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b05:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b0b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b0d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102b10:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102b12:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b15:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b18:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b1e:	a1 a4 36 11 80       	mov    0x801136a4,%eax
80102b23:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b29:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b2c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b33:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b36:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b39:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b40:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b43:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b46:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b4c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b4f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b55:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b58:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b5e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b61:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b67:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102b6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b6d:	c9                   	leave
80102b6e:	c3                   	ret
80102b6f:	90                   	nop

80102b70 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b70:	55                   	push   %ebp
80102b71:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b76:	ba 70 00 00 00       	mov    $0x70,%edx
80102b7b:	89 e5                	mov    %esp,%ebp
80102b7d:	57                   	push   %edi
80102b7e:	56                   	push   %esi
80102b7f:	53                   	push   %ebx
80102b80:	83 ec 4c             	sub    $0x4c,%esp
80102b83:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b84:	ba 71 00 00 00       	mov    $0x71,%edx
80102b89:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102b8a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b8d:	bf 70 00 00 00       	mov    $0x70,%edi
80102b92:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b95:	8d 76 00             	lea    0x0(%esi),%esi
80102b98:	31 c0                	xor    %eax,%eax
80102b9a:	89 fa                	mov    %edi,%edx
80102b9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b9d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102ba2:	89 ca                	mov    %ecx,%edx
80102ba4:	ec                   	in     (%dx),%al
80102ba5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba8:	89 fa                	mov    %edi,%edx
80102baa:	b8 02 00 00 00       	mov    $0x2,%eax
80102baf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bb0:	89 ca                	mov    %ecx,%edx
80102bb2:	ec                   	in     (%dx),%al
80102bb3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb6:	89 fa                	mov    %edi,%edx
80102bb8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bbd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bbe:	89 ca                	mov    %ecx,%edx
80102bc0:	ec                   	in     (%dx),%al
80102bc1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc4:	89 fa                	mov    %edi,%edx
80102bc6:	b8 07 00 00 00       	mov    $0x7,%eax
80102bcb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bcc:	89 ca                	mov    %ecx,%edx
80102bce:	ec                   	in     (%dx),%al
80102bcf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd2:	89 fa                	mov    %edi,%edx
80102bd4:	b8 08 00 00 00       	mov    $0x8,%eax
80102bd9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bda:	89 ca                	mov    %ecx,%edx
80102bdc:	ec                   	in     (%dx),%al
80102bdd:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bdf:	89 fa                	mov    %edi,%edx
80102be1:	b8 09 00 00 00       	mov    $0x9,%eax
80102be6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102be7:	89 ca                	mov    %ecx,%edx
80102be9:	ec                   	in     (%dx),%al
80102bea:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bed:	89 fa                	mov    %edi,%edx
80102bef:	b8 0a 00 00 00       	mov    $0xa,%eax
80102bf4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf5:	89 ca                	mov    %ecx,%edx
80102bf7:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102bf8:	84 c0                	test   %al,%al
80102bfa:	78 9c                	js     80102b98 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102bfc:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c00:	89 f2                	mov    %esi,%edx
80102c02:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102c05:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c08:	89 fa                	mov    %edi,%edx
80102c0a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c0d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c11:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102c14:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c17:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c1b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c1e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c22:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c25:	31 c0                	xor    %eax,%eax
80102c27:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c28:	89 ca                	mov    %ecx,%edx
80102c2a:	ec                   	in     (%dx),%al
80102c2b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c2e:	89 fa                	mov    %edi,%edx
80102c30:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c33:	b8 02 00 00 00       	mov    $0x2,%eax
80102c38:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c39:	89 ca                	mov    %ecx,%edx
80102c3b:	ec                   	in     (%dx),%al
80102c3c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c3f:	89 fa                	mov    %edi,%edx
80102c41:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c44:	b8 04 00 00 00       	mov    $0x4,%eax
80102c49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4a:	89 ca                	mov    %ecx,%edx
80102c4c:	ec                   	in     (%dx),%al
80102c4d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c50:	89 fa                	mov    %edi,%edx
80102c52:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c55:	b8 07 00 00 00       	mov    $0x7,%eax
80102c5a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c5b:	89 ca                	mov    %ecx,%edx
80102c5d:	ec                   	in     (%dx),%al
80102c5e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c61:	89 fa                	mov    %edi,%edx
80102c63:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c66:	b8 08 00 00 00       	mov    $0x8,%eax
80102c6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6c:	89 ca                	mov    %ecx,%edx
80102c6e:	ec                   	in     (%dx),%al
80102c6f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c72:	89 fa                	mov    %edi,%edx
80102c74:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c77:	b8 09 00 00 00       	mov    $0x9,%eax
80102c7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7d:	89 ca                	mov    %ecx,%edx
80102c7f:	ec                   	in     (%dx),%al
80102c80:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c83:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c89:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c8c:	6a 18                	push   $0x18
80102c8e:	50                   	push   %eax
80102c8f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c92:	50                   	push   %eax
80102c93:	e8 b8 1e 00 00       	call   80104b50 <memcmp>
80102c98:	83 c4 10             	add    $0x10,%esp
80102c9b:	85 c0                	test   %eax,%eax
80102c9d:	0f 85 f5 fe ff ff    	jne    80102b98 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ca3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102caa:	89 f0                	mov    %esi,%eax
80102cac:	84 c0                	test   %al,%al
80102cae:	75 78                	jne    80102d28 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102cb0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cb3:	89 c2                	mov    %eax,%edx
80102cb5:	83 e0 0f             	and    $0xf,%eax
80102cb8:	c1 ea 04             	shr    $0x4,%edx
80102cbb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cbe:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cc1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102cc4:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cc7:	89 c2                	mov    %eax,%edx
80102cc9:	83 e0 0f             	and    $0xf,%eax
80102ccc:	c1 ea 04             	shr    $0x4,%edx
80102ccf:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cd2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cd5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102cd8:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102cdb:	89 c2                	mov    %eax,%edx
80102cdd:	83 e0 0f             	and    $0xf,%eax
80102ce0:	c1 ea 04             	shr    $0x4,%edx
80102ce3:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ce6:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ce9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102cec:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cef:	89 c2                	mov    %eax,%edx
80102cf1:	83 e0 0f             	and    $0xf,%eax
80102cf4:	c1 ea 04             	shr    $0x4,%edx
80102cf7:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cfa:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cfd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d00:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d03:	89 c2                	mov    %eax,%edx
80102d05:	83 e0 0f             	and    $0xf,%eax
80102d08:	c1 ea 04             	shr    $0x4,%edx
80102d0b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d0e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d11:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d14:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d17:	89 c2                	mov    %eax,%edx
80102d19:	83 e0 0f             	and    $0xf,%eax
80102d1c:	c1 ea 04             	shr    $0x4,%edx
80102d1f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d22:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d25:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d28:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d2b:	89 03                	mov    %eax,(%ebx)
80102d2d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d30:	89 43 04             	mov    %eax,0x4(%ebx)
80102d33:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d36:	89 43 08             	mov    %eax,0x8(%ebx)
80102d39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d3c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102d3f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d42:	89 43 10             	mov    %eax,0x10(%ebx)
80102d45:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d48:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102d4b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102d52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d55:	5b                   	pop    %ebx
80102d56:	5e                   	pop    %esi
80102d57:	5f                   	pop    %edi
80102d58:	5d                   	pop    %ebp
80102d59:	c3                   	ret
80102d5a:	66 90                	xchg   %ax,%ax
80102d5c:	66 90                	xchg   %ax,%ax
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d60:	8b 0d 08 37 11 80    	mov    0x80113708,%ecx
80102d66:	85 c9                	test   %ecx,%ecx
80102d68:	0f 8e 8a 00 00 00    	jle    80102df8 <install_trans+0x98>
{
80102d6e:	55                   	push   %ebp
80102d6f:	89 e5                	mov    %esp,%ebp
80102d71:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102d72:	31 ff                	xor    %edi,%edi
{
80102d74:	56                   	push   %esi
80102d75:	53                   	push   %ebx
80102d76:	83 ec 0c             	sub    $0xc,%esp
80102d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d80:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102d85:	83 ec 08             	sub    $0x8,%esp
80102d88:	01 f8                	add    %edi,%eax
80102d8a:	83 c0 01             	add    $0x1,%eax
80102d8d:	50                   	push   %eax
80102d8e:	ff 35 04 37 11 80    	push   0x80113704
80102d94:	e8 37 d3 ff ff       	call   801000d0 <bread>
80102d99:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d9b:	58                   	pop    %eax
80102d9c:	5a                   	pop    %edx
80102d9d:	ff 34 bd 0c 37 11 80 	push   -0x7feec8f4(,%edi,4)
80102da4:	ff 35 04 37 11 80    	push   0x80113704
  for (tail = 0; tail < log.lh.n; tail++) {
80102daa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dad:	e8 1e d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102db2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102db5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102db7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dba:	68 00 02 00 00       	push   $0x200
80102dbf:	50                   	push   %eax
80102dc0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102dc3:	50                   	push   %eax
80102dc4:	e8 d7 1d 00 00       	call   80104ba0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102dc9:	89 1c 24             	mov    %ebx,(%esp)
80102dcc:	e8 df d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102dd1:	89 34 24             	mov    %esi,(%esp)
80102dd4:	e8 17 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102dd9:	89 1c 24             	mov    %ebx,(%esp)
80102ddc:	e8 0f d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102de1:	83 c4 10             	add    $0x10,%esp
80102de4:	39 3d 08 37 11 80    	cmp    %edi,0x80113708
80102dea:	7f 94                	jg     80102d80 <install_trans+0x20>
  }
}
80102dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102def:	5b                   	pop    %ebx
80102df0:	5e                   	pop    %esi
80102df1:	5f                   	pop    %edi
80102df2:	5d                   	pop    %ebp
80102df3:	c3                   	ret
80102df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102df8:	c3                   	ret
80102df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e00 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	53                   	push   %ebx
80102e04:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e07:	ff 35 f4 36 11 80    	push   0x801136f4
80102e0d:	ff 35 04 37 11 80    	push   0x80113704
80102e13:	e8 b8 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e18:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e1b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e1d:	a1 08 37 11 80       	mov    0x80113708,%eax
80102e22:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102e25:	85 c0                	test   %eax,%eax
80102e27:	7e 19                	jle    80102e42 <write_head+0x42>
80102e29:	31 d2                	xor    %edx,%edx
80102e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e2f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102e30:	8b 0c 95 0c 37 11 80 	mov    -0x7feec8f4(,%edx,4),%ecx
80102e37:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e3b:	83 c2 01             	add    $0x1,%edx
80102e3e:	39 d0                	cmp    %edx,%eax
80102e40:	75 ee                	jne    80102e30 <write_head+0x30>
  }
  bwrite(buf);
80102e42:	83 ec 0c             	sub    $0xc,%esp
80102e45:	53                   	push   %ebx
80102e46:	e8 65 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102e4b:	89 1c 24             	mov    %ebx,(%esp)
80102e4e:	e8 9d d3 ff ff       	call   801001f0 <brelse>
}
80102e53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e56:	83 c4 10             	add    $0x10,%esp
80102e59:	c9                   	leave
80102e5a:	c3                   	ret
80102e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e5f:	90                   	nop

80102e60 <initlog>:
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	53                   	push   %ebx
80102e64:	83 ec 3c             	sub    $0x3c,%esp
80102e67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e6a:	68 d7 84 10 80       	push   $0x801084d7
80102e6f:	68 c0 36 11 80       	push   $0x801136c0
80102e74:	e8 a7 19 00 00       	call   80104820 <initlock>
  readsb(dev, &sb);
80102e79:	58                   	pop    %eax
80102e7a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80102e7d:	5a                   	pop    %edx
80102e7e:	50                   	push   %eax
80102e7f:	53                   	push   %ebx
80102e80:	e8 ab e7 ff ff       	call   80101630 <readsb>
  log.start = sb.logstart;
80102e85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e88:	59                   	pop    %ecx
  log.dev = dev;
80102e89:	89 1d 04 37 11 80    	mov    %ebx,0x80113704
  log.size = sb.nlog;
80102e8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  log.start = sb.logstart;
80102e92:	a3 f4 36 11 80       	mov    %eax,0x801136f4
  log.size = sb.nlog;
80102e97:	89 15 f8 36 11 80    	mov    %edx,0x801136f8
  struct buf *buf = bread(log.dev, log.start);
80102e9d:	5a                   	pop    %edx
80102e9e:	50                   	push   %eax
80102e9f:	53                   	push   %ebx
80102ea0:	e8 2b d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ea5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102ea8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102eab:	89 1d 08 37 11 80    	mov    %ebx,0x80113708
  for (i = 0; i < log.lh.n; i++) {
80102eb1:	85 db                	test   %ebx,%ebx
80102eb3:	7e 1d                	jle    80102ed2 <initlog+0x72>
80102eb5:	31 d2                	xor    %edx,%edx
80102eb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ebe:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102ec0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102ec4:	89 0c 95 0c 37 11 80 	mov    %ecx,-0x7feec8f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ecb:	83 c2 01             	add    $0x1,%edx
80102ece:	39 d3                	cmp    %edx,%ebx
80102ed0:	75 ee                	jne    80102ec0 <initlog+0x60>
  brelse(buf);
80102ed2:	83 ec 0c             	sub    $0xc,%esp
80102ed5:	50                   	push   %eax
80102ed6:	e8 15 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102edb:	e8 80 fe ff ff       	call   80102d60 <install_trans>
  log.lh.n = 0;
80102ee0:	c7 05 08 37 11 80 00 	movl   $0x0,0x80113708
80102ee7:	00 00 00 
  write_head(); // clear the log
80102eea:	e8 11 ff ff ff       	call   80102e00 <write_head>
}
80102eef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ef2:	83 c4 10             	add    $0x10,%esp
80102ef5:	c9                   	leave
80102ef6:	c3                   	ret
80102ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102efe:	66 90                	xchg   %ax,%ax

80102f00 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f00:	55                   	push   %ebp
80102f01:	89 e5                	mov    %esp,%ebp
80102f03:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f06:	68 c0 36 11 80       	push   $0x801136c0
80102f0b:	e8 00 1b 00 00       	call   80104a10 <acquire>
80102f10:	83 c4 10             	add    $0x10,%esp
80102f13:	eb 18                	jmp    80102f2d <begin_op+0x2d>
80102f15:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f18:	83 ec 08             	sub    $0x8,%esp
80102f1b:	68 c0 36 11 80       	push   $0x801136c0
80102f20:	68 c0 36 11 80       	push   $0x801136c0
80102f25:	e8 26 13 00 00       	call   80104250 <sleep>
80102f2a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f2d:	a1 00 37 11 80       	mov    0x80113700,%eax
80102f32:	85 c0                	test   %eax,%eax
80102f34:	75 e2                	jne    80102f18 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f36:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102f3b:	8b 15 08 37 11 80    	mov    0x80113708,%edx
80102f41:	83 c0 01             	add    $0x1,%eax
80102f44:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f47:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f4a:	83 fa 1e             	cmp    $0x1e,%edx
80102f4d:	7f c9                	jg     80102f18 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f4f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f52:	a3 fc 36 11 80       	mov    %eax,0x801136fc
      release(&log.lock);
80102f57:	68 c0 36 11 80       	push   $0x801136c0
80102f5c:	e8 4f 1a 00 00       	call   801049b0 <release>
      break;
    }
  }
}
80102f61:	83 c4 10             	add    $0x10,%esp
80102f64:	c9                   	leave
80102f65:	c3                   	ret
80102f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f6d:	8d 76 00             	lea    0x0(%esi),%esi

80102f70 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	57                   	push   %edi
80102f74:	56                   	push   %esi
80102f75:	53                   	push   %ebx
80102f76:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f79:	68 c0 36 11 80       	push   $0x801136c0
80102f7e:	e8 8d 1a 00 00       	call   80104a10 <acquire>
  log.outstanding -= 1;
80102f83:	a1 fc 36 11 80       	mov    0x801136fc,%eax
  if(log.committing)
80102f88:	8b 35 00 37 11 80    	mov    0x80113700,%esi
80102f8e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f91:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102f94:	89 1d fc 36 11 80    	mov    %ebx,0x801136fc
  if(log.committing)
80102f9a:	85 f6                	test   %esi,%esi
80102f9c:	0f 85 22 01 00 00    	jne    801030c4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102fa2:	85 db                	test   %ebx,%ebx
80102fa4:	0f 85 f6 00 00 00    	jne    801030a0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102faa:	c7 05 00 37 11 80 01 	movl   $0x1,0x80113700
80102fb1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fb4:	83 ec 0c             	sub    $0xc,%esp
80102fb7:	68 c0 36 11 80       	push   $0x801136c0
80102fbc:	e8 ef 19 00 00       	call   801049b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fc1:	8b 0d 08 37 11 80    	mov    0x80113708,%ecx
80102fc7:	83 c4 10             	add    $0x10,%esp
80102fca:	85 c9                	test   %ecx,%ecx
80102fcc:	7f 42                	jg     80103010 <end_op+0xa0>
    acquire(&log.lock);
80102fce:	83 ec 0c             	sub    $0xc,%esp
80102fd1:	68 c0 36 11 80       	push   $0x801136c0
80102fd6:	e8 35 1a 00 00       	call   80104a10 <acquire>
    log.committing = 0;
80102fdb:	c7 05 00 37 11 80 00 	movl   $0x0,0x80113700
80102fe2:	00 00 00 
    wakeup(&log);
80102fe5:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102fec:	e8 1f 13 00 00       	call   80104310 <wakeup>
    release(&log.lock);
80102ff1:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102ff8:	e8 b3 19 00 00       	call   801049b0 <release>
80102ffd:	83 c4 10             	add    $0x10,%esp
}
80103000:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103003:	5b                   	pop    %ebx
80103004:	5e                   	pop    %esi
80103005:	5f                   	pop    %edi
80103006:	5d                   	pop    %ebp
80103007:	c3                   	ret
80103008:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010300f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103010:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80103015:	83 ec 08             	sub    $0x8,%esp
80103018:	01 d8                	add    %ebx,%eax
8010301a:	83 c0 01             	add    $0x1,%eax
8010301d:	50                   	push   %eax
8010301e:	ff 35 04 37 11 80    	push   0x80113704
80103024:	e8 a7 d0 ff ff       	call   801000d0 <bread>
80103029:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010302b:	58                   	pop    %eax
8010302c:	5a                   	pop    %edx
8010302d:	ff 34 9d 0c 37 11 80 	push   -0x7feec8f4(,%ebx,4)
80103034:	ff 35 04 37 11 80    	push   0x80113704
  for (tail = 0; tail < log.lh.n; tail++) {
8010303a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010303d:	e8 8e d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103042:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103045:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103047:	8d 40 5c             	lea    0x5c(%eax),%eax
8010304a:	68 00 02 00 00       	push   $0x200
8010304f:	50                   	push   %eax
80103050:	8d 46 5c             	lea    0x5c(%esi),%eax
80103053:	50                   	push   %eax
80103054:	e8 47 1b 00 00       	call   80104ba0 <memmove>
    bwrite(to);  // write the log
80103059:	89 34 24             	mov    %esi,(%esp)
8010305c:	e8 4f d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103061:	89 3c 24             	mov    %edi,(%esp)
80103064:	e8 87 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103069:	89 34 24             	mov    %esi,(%esp)
8010306c:	e8 7f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103071:	83 c4 10             	add    $0x10,%esp
80103074:	3b 1d 08 37 11 80    	cmp    0x80113708,%ebx
8010307a:	7c 94                	jl     80103010 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010307c:	e8 7f fd ff ff       	call   80102e00 <write_head>
    install_trans(); // Now install writes to home locations
80103081:	e8 da fc ff ff       	call   80102d60 <install_trans>
    log.lh.n = 0;
80103086:	c7 05 08 37 11 80 00 	movl   $0x0,0x80113708
8010308d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103090:	e8 6b fd ff ff       	call   80102e00 <write_head>
80103095:	e9 34 ff ff ff       	jmp    80102fce <end_op+0x5e>
8010309a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801030a0:	83 ec 0c             	sub    $0xc,%esp
801030a3:	68 c0 36 11 80       	push   $0x801136c0
801030a8:	e8 63 12 00 00       	call   80104310 <wakeup>
  release(&log.lock);
801030ad:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
801030b4:	e8 f7 18 00 00       	call   801049b0 <release>
801030b9:	83 c4 10             	add    $0x10,%esp
}
801030bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030bf:	5b                   	pop    %ebx
801030c0:	5e                   	pop    %esi
801030c1:	5f                   	pop    %edi
801030c2:	5d                   	pop    %ebp
801030c3:	c3                   	ret
    panic("log.committing");
801030c4:	83 ec 0c             	sub    $0xc,%esp
801030c7:	68 db 84 10 80       	push   $0x801084db
801030cc:	e8 9f d3 ff ff       	call   80100470 <panic>
801030d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030df:	90                   	nop

801030e0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030e0:	55                   	push   %ebp
801030e1:	89 e5                	mov    %esp,%ebp
801030e3:	53                   	push   %ebx
801030e4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030e7:	8b 15 08 37 11 80    	mov    0x80113708,%edx
{
801030ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030f0:	83 fa 1d             	cmp    $0x1d,%edx
801030f3:	7f 7d                	jg     80103172 <log_write+0x92>
801030f5:	a1 f8 36 11 80       	mov    0x801136f8,%eax
801030fa:	83 e8 01             	sub    $0x1,%eax
801030fd:	39 c2                	cmp    %eax,%edx
801030ff:	7d 71                	jge    80103172 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103101:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80103106:	85 c0                	test   %eax,%eax
80103108:	7e 75                	jle    8010317f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010310a:	83 ec 0c             	sub    $0xc,%esp
8010310d:	68 c0 36 11 80       	push   $0x801136c0
80103112:	e8 f9 18 00 00       	call   80104a10 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103117:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010311a:	83 c4 10             	add    $0x10,%esp
8010311d:	31 c0                	xor    %eax,%eax
8010311f:	8b 15 08 37 11 80    	mov    0x80113708,%edx
80103125:	85 d2                	test   %edx,%edx
80103127:	7f 0e                	jg     80103137 <log_write+0x57>
80103129:	eb 15                	jmp    80103140 <log_write+0x60>
8010312b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010312f:	90                   	nop
80103130:	83 c0 01             	add    $0x1,%eax
80103133:	39 c2                	cmp    %eax,%edx
80103135:	74 29                	je     80103160 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103137:	39 0c 85 0c 37 11 80 	cmp    %ecx,-0x7feec8f4(,%eax,4)
8010313e:	75 f0                	jne    80103130 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103140:	89 0c 85 0c 37 11 80 	mov    %ecx,-0x7feec8f4(,%eax,4)
  if (i == log.lh.n)
80103147:	39 c2                	cmp    %eax,%edx
80103149:	74 1c                	je     80103167 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010314b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010314e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103151:	c7 45 08 c0 36 11 80 	movl   $0x801136c0,0x8(%ebp)
}
80103158:	c9                   	leave
  release(&log.lock);
80103159:	e9 52 18 00 00       	jmp    801049b0 <release>
8010315e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103160:	89 0c 95 0c 37 11 80 	mov    %ecx,-0x7feec8f4(,%edx,4)
    log.lh.n++;
80103167:	83 c2 01             	add    $0x1,%edx
8010316a:	89 15 08 37 11 80    	mov    %edx,0x80113708
80103170:	eb d9                	jmp    8010314b <log_write+0x6b>
    panic("too big a transaction");
80103172:	83 ec 0c             	sub    $0xc,%esp
80103175:	68 ea 84 10 80       	push   $0x801084ea
8010317a:	e8 f1 d2 ff ff       	call   80100470 <panic>
    panic("log_write outside of trans");
8010317f:	83 ec 0c             	sub    $0xc,%esp
80103182:	68 00 85 10 80       	push   $0x80108500
80103187:	e8 e4 d2 ff ff       	call   80100470 <panic>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	53                   	push   %ebx
80103194:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103197:	e8 54 09 00 00       	call   80103af0 <cpuid>
8010319c:	89 c3                	mov    %eax,%ebx
8010319e:	e8 4d 09 00 00       	call   80103af0 <cpuid>
801031a3:	83 ec 04             	sub    $0x4,%esp
801031a6:	53                   	push   %ebx
801031a7:	50                   	push   %eax
801031a8:	68 1b 85 10 80       	push   $0x8010851b
801031ad:	e8 ee d5 ff ff       	call   801007a0 <cprintf>
  idtinit();       // load idt register
801031b2:	e8 b9 2b 00 00       	call   80105d70 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031b7:	e8 e4 08 00 00       	call   80103aa0 <mycpu>
801031bc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031be:	b8 01 00 00 00       	mov    $0x1,%eax
801031c3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801031ca:	e8 71 0c 00 00       	call   80103e40 <scheduler>
801031cf:	90                   	nop

801031d0 <mpenter>:
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801031d6:	e8 25 3f 00 00       	call   80107100 <switchkvm>
  seginit();
801031db:	e8 90 3e 00 00       	call   80107070 <seginit>
  lapicinit();
801031e0:	e8 bb f7 ff ff       	call   801029a0 <lapicinit>
  mpmain();
801031e5:	e8 a6 ff ff ff       	call   80103190 <mpmain>
801031ea:	66 90                	xchg   %ax,%ax
801031ec:	66 90                	xchg   %ax,%ax
801031ee:	66 90                	xchg   %ax,%ax

801031f0 <main>:
{
801031f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801031f4:	83 e4 f0             	and    $0xfffffff0,%esp
801031f7:	ff 71 fc             	push   -0x4(%ecx)
801031fa:	55                   	push   %ebp
801031fb:	89 e5                	mov    %esp,%ebp
801031fd:	53                   	push   %ebx
801031fe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801031ff:	83 ec 08             	sub    $0x8,%esp
80103202:	68 00 00 40 80       	push   $0x80400000
80103207:	68 40 ba 1c 80       	push   $0x801cba40
8010320c:	e8 1f f5 ff ff       	call   80102730 <kinit1>
  kvmalloc();      // kernel page table
80103211:	e8 da 43 00 00       	call   801075f0 <kvmalloc>
  mpinit();        // detect other processors
80103216:	e8 85 01 00 00       	call   801033a0 <mpinit>
  lapicinit();     // interrupt controller
8010321b:	e8 80 f7 ff ff       	call   801029a0 <lapicinit>
  seginit();       // segment descriptors
80103220:	e8 4b 3e 00 00       	call   80107070 <seginit>
  picinit();       // disable pic
80103225:	e8 86 03 00 00       	call   801035b0 <picinit>
  ioapicinit();    // another interrupt controller
8010322a:	e8 81 f2 ff ff       	call   801024b0 <ioapicinit>
  consoleinit();   // console hardware
8010322f:	e8 1c d9 ff ff       	call   80100b50 <consoleinit>
  uartinit();      // serial port
80103234:	e8 47 2e 00 00       	call   80106080 <uartinit>
  pinit();         // process table
80103239:	e8 42 08 00 00       	call   80103a80 <pinit>
  tvinit();        // trap vectors
8010323e:	e8 ad 2a 00 00       	call   80105cf0 <tvinit>
  binit();         // buffer cache
80103243:	e8 f8 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103248:	e8 d3 dc ff ff       	call   80100f20 <fileinit>
  ideinit();       // disk 
8010324d:	e8 3e f0 ff ff       	call   80102290 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103252:	83 c4 0c             	add    $0xc,%esp
80103255:	68 8a 00 00 00       	push   $0x8a
8010325a:	68 8c b4 10 80       	push   $0x8010b48c
8010325f:	68 00 70 00 80       	push   $0x80007000
80103264:	e8 37 19 00 00       	call   80104ba0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103269:	83 c4 10             	add    $0x10,%esp
8010326c:	69 05 a4 37 11 80 b0 	imul   $0xb0,0x801137a4,%eax
80103273:	00 00 00 
80103276:	05 c0 37 11 80       	add    $0x801137c0,%eax
8010327b:	3d c0 37 11 80       	cmp    $0x801137c0,%eax
80103280:	76 7e                	jbe    80103300 <main+0x110>
80103282:	bb c0 37 11 80       	mov    $0x801137c0,%ebx
80103287:	eb 20                	jmp    801032a9 <main+0xb9>
80103289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103290:	69 05 a4 37 11 80 b0 	imul   $0xb0,0x801137a4,%eax
80103297:	00 00 00 
8010329a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032a0:	05 c0 37 11 80       	add    $0x801137c0,%eax
801032a5:	39 c3                	cmp    %eax,%ebx
801032a7:	73 57                	jae    80103300 <main+0x110>
    if(c == mycpu())  // We've started already.
801032a9:	e8 f2 07 00 00       	call   80103aa0 <mycpu>
801032ae:	39 c3                	cmp    %eax,%ebx
801032b0:	74 de                	je     80103290 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032b2:	e8 f9 f4 ff ff       	call   801027b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801032b7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801032ba:	c7 05 f8 6f 00 80 d0 	movl   $0x801031d0,0x80006ff8
801032c1:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032c4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801032cb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801032ce:	05 00 10 00 00       	add    $0x1000,%eax
801032d3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801032d8:	0f b6 03             	movzbl (%ebx),%eax
801032db:	68 00 70 00 00       	push   $0x7000
801032e0:	50                   	push   %eax
801032e1:	e8 fa f7 ff ff       	call   80102ae0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801032e6:	83 c4 10             	add    $0x10,%esp
801032e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032f0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801032f6:	85 c0                	test   %eax,%eax
801032f8:	74 f6                	je     801032f0 <main+0x100>
801032fa:	eb 94                	jmp    80103290 <main+0xa0>
801032fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103300:	83 ec 08             	sub    $0x8,%esp
80103303:	68 00 00 40 80       	push   $0x80400000
80103308:	68 00 00 40 80       	push   $0x80400000
8010330d:	e8 ae f3 ff ff       	call   801026c0 <kinit2>
  userinit();      // first user process
80103312:	e8 29 08 00 00       	call   80103b40 <userinit>
  mpmain();        // finish this processor's setup
80103317:	e8 74 fe ff ff       	call   80103190 <mpmain>
8010331c:	66 90                	xchg   %ax,%ax
8010331e:	66 90                	xchg   %ax,%ax

80103320 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	57                   	push   %edi
80103324:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103325:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010332b:	53                   	push   %ebx
  e = addr+len;
8010332c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010332f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103332:	39 de                	cmp    %ebx,%esi
80103334:	72 10                	jb     80103346 <mpsearch1+0x26>
80103336:	eb 50                	jmp    80103388 <mpsearch1+0x68>
80103338:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010333f:	90                   	nop
80103340:	89 fe                	mov    %edi,%esi
80103342:	39 df                	cmp    %ebx,%edi
80103344:	73 42                	jae    80103388 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103346:	83 ec 04             	sub    $0x4,%esp
80103349:	8d 7e 10             	lea    0x10(%esi),%edi
8010334c:	6a 04                	push   $0x4
8010334e:	68 2f 85 10 80       	push   $0x8010852f
80103353:	56                   	push   %esi
80103354:	e8 f7 17 00 00       	call   80104b50 <memcmp>
80103359:	83 c4 10             	add    $0x10,%esp
8010335c:	85 c0                	test   %eax,%eax
8010335e:	75 e0                	jne    80103340 <mpsearch1+0x20>
80103360:	89 f2                	mov    %esi,%edx
80103362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103368:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010336b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010336e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103370:	39 fa                	cmp    %edi,%edx
80103372:	75 f4                	jne    80103368 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103374:	84 c0                	test   %al,%al
80103376:	75 c8                	jne    80103340 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103378:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010337b:	89 f0                	mov    %esi,%eax
8010337d:	5b                   	pop    %ebx
8010337e:	5e                   	pop    %esi
8010337f:	5f                   	pop    %edi
80103380:	5d                   	pop    %ebp
80103381:	c3                   	ret
80103382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103388:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010338b:	31 f6                	xor    %esi,%esi
}
8010338d:	5b                   	pop    %ebx
8010338e:	89 f0                	mov    %esi,%eax
80103390:	5e                   	pop    %esi
80103391:	5f                   	pop    %edi
80103392:	5d                   	pop    %ebp
80103393:	c3                   	ret
80103394:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010339b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010339f:	90                   	nop

801033a0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	57                   	push   %edi
801033a4:	56                   	push   %esi
801033a5:	53                   	push   %ebx
801033a6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033a9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033b0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033b7:	c1 e0 08             	shl    $0x8,%eax
801033ba:	09 d0                	or     %edx,%eax
801033bc:	c1 e0 04             	shl    $0x4,%eax
801033bf:	75 1b                	jne    801033dc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801033c1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033c8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801033cf:	c1 e0 08             	shl    $0x8,%eax
801033d2:	09 d0                	or     %edx,%eax
801033d4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801033d7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801033dc:	ba 00 04 00 00       	mov    $0x400,%edx
801033e1:	e8 3a ff ff ff       	call   80103320 <mpsearch1>
801033e6:	89 c3                	mov    %eax,%ebx
801033e8:	85 c0                	test   %eax,%eax
801033ea:	0f 84 58 01 00 00    	je     80103548 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033f0:	8b 73 04             	mov    0x4(%ebx),%esi
801033f3:	85 f6                	test   %esi,%esi
801033f5:	0f 84 3d 01 00 00    	je     80103538 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
801033fb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801033fe:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103404:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103407:	6a 04                	push   $0x4
80103409:	68 34 85 10 80       	push   $0x80108534
8010340e:	50                   	push   %eax
8010340f:	e8 3c 17 00 00       	call   80104b50 <memcmp>
80103414:	83 c4 10             	add    $0x10,%esp
80103417:	85 c0                	test   %eax,%eax
80103419:	0f 85 19 01 00 00    	jne    80103538 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010341f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103426:	3c 01                	cmp    $0x1,%al
80103428:	74 08                	je     80103432 <mpinit+0x92>
8010342a:	3c 04                	cmp    $0x4,%al
8010342c:	0f 85 06 01 00 00    	jne    80103538 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103432:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103439:	66 85 d2             	test   %dx,%dx
8010343c:	74 22                	je     80103460 <mpinit+0xc0>
8010343e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103441:	89 f0                	mov    %esi,%eax
  sum = 0;
80103443:	31 d2                	xor    %edx,%edx
80103445:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103448:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010344f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103452:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103454:	39 f8                	cmp    %edi,%eax
80103456:	75 f0                	jne    80103448 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103458:	84 d2                	test   %dl,%dl
8010345a:	0f 85 d8 00 00 00    	jne    80103538 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103460:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103466:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103469:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010346c:	a3 a4 36 11 80       	mov    %eax,0x801136a4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103471:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103478:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
8010347e:	01 d7                	add    %edx,%edi
80103480:	89 fa                	mov    %edi,%edx
  ismp = 1;
80103482:	bf 01 00 00 00       	mov    $0x1,%edi
80103487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010348e:	66 90                	xchg   %ax,%ax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103490:	39 d0                	cmp    %edx,%eax
80103492:	73 19                	jae    801034ad <mpinit+0x10d>
    switch(*p){
80103494:	0f b6 08             	movzbl (%eax),%ecx
80103497:	80 f9 02             	cmp    $0x2,%cl
8010349a:	0f 84 80 00 00 00    	je     80103520 <mpinit+0x180>
801034a0:	77 6e                	ja     80103510 <mpinit+0x170>
801034a2:	84 c9                	test   %cl,%cl
801034a4:	74 3a                	je     801034e0 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034a6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034a9:	39 d0                	cmp    %edx,%eax
801034ab:	72 e7                	jb     80103494 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034ad:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801034b0:	85 ff                	test   %edi,%edi
801034b2:	0f 84 dd 00 00 00    	je     80103595 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034b8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801034bc:	74 15                	je     801034d3 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034be:	b8 70 00 00 00       	mov    $0x70,%eax
801034c3:	ba 22 00 00 00       	mov    $0x22,%edx
801034c8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034c9:	ba 23 00 00 00       	mov    $0x23,%edx
801034ce:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801034cf:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034d2:	ee                   	out    %al,(%dx)
  }
}
801034d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034d6:	5b                   	pop    %ebx
801034d7:	5e                   	pop    %esi
801034d8:	5f                   	pop    %edi
801034d9:	5d                   	pop    %ebp
801034da:	c3                   	ret
801034db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034df:	90                   	nop
      if(ncpu < NCPU) {
801034e0:	8b 0d a4 37 11 80    	mov    0x801137a4,%ecx
801034e6:	85 c9                	test   %ecx,%ecx
801034e8:	7f 19                	jg     80103503 <mpinit+0x163>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034ea:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
801034f0:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801034f4:	83 c1 01             	add    $0x1,%ecx
801034f7:	89 0d a4 37 11 80    	mov    %ecx,0x801137a4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034fd:	88 9e c0 37 11 80    	mov    %bl,-0x7feec840(%esi)
      p += sizeof(struct mpproc);
80103503:	83 c0 14             	add    $0x14,%eax
      continue;
80103506:	eb 88                	jmp    80103490 <mpinit+0xf0>
80103508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350f:	90                   	nop
    switch(*p){
80103510:	83 e9 03             	sub    $0x3,%ecx
80103513:	80 f9 01             	cmp    $0x1,%cl
80103516:	76 8e                	jbe    801034a6 <mpinit+0x106>
80103518:	31 ff                	xor    %edi,%edi
8010351a:	e9 71 ff ff ff       	jmp    80103490 <mpinit+0xf0>
8010351f:	90                   	nop
      ioapicid = ioapic->apicno;
80103520:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103524:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103527:	88 0d a0 37 11 80    	mov    %cl,0x801137a0
      continue;
8010352d:	e9 5e ff ff ff       	jmp    80103490 <mpinit+0xf0>
80103532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103538:	83 ec 0c             	sub    $0xc,%esp
8010353b:	68 39 85 10 80       	push   $0x80108539
80103540:	e8 2b cf ff ff       	call   80100470 <panic>
80103545:	8d 76 00             	lea    0x0(%esi),%esi
{
80103548:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010354d:	eb 0b                	jmp    8010355a <mpinit+0x1ba>
8010354f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103550:	89 f3                	mov    %esi,%ebx
80103552:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103558:	74 de                	je     80103538 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010355a:	83 ec 04             	sub    $0x4,%esp
8010355d:	8d 73 10             	lea    0x10(%ebx),%esi
80103560:	6a 04                	push   $0x4
80103562:	68 2f 85 10 80       	push   $0x8010852f
80103567:	53                   	push   %ebx
80103568:	e8 e3 15 00 00       	call   80104b50 <memcmp>
8010356d:	83 c4 10             	add    $0x10,%esp
80103570:	85 c0                	test   %eax,%eax
80103572:	75 dc                	jne    80103550 <mpinit+0x1b0>
80103574:	89 da                	mov    %ebx,%edx
80103576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010357d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103580:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103583:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103586:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103588:	39 d6                	cmp    %edx,%esi
8010358a:	75 f4                	jne    80103580 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010358c:	84 c0                	test   %al,%al
8010358e:	75 c0                	jne    80103550 <mpinit+0x1b0>
80103590:	e9 5b fe ff ff       	jmp    801033f0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103595:	83 ec 0c             	sub    $0xc,%esp
80103598:	68 54 89 10 80       	push   $0x80108954
8010359d:	e8 ce ce ff ff       	call   80100470 <panic>
801035a2:	66 90                	xchg   %ax,%ax
801035a4:	66 90                	xchg   %ax,%ax
801035a6:	66 90                	xchg   %ax,%ax
801035a8:	66 90                	xchg   %ax,%ax
801035aa:	66 90                	xchg   %ax,%ax
801035ac:	66 90                	xchg   %ax,%ax
801035ae:	66 90                	xchg   %ax,%ax

801035b0 <picinit>:
801035b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035b5:	ba 21 00 00 00       	mov    $0x21,%edx
801035ba:	ee                   	out    %al,(%dx)
801035bb:	ba a1 00 00 00       	mov    $0xa1,%edx
801035c0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801035c1:	c3                   	ret
801035c2:	66 90                	xchg   %ax,%ax
801035c4:	66 90                	xchg   %ax,%ax
801035c6:	66 90                	xchg   %ax,%ax
801035c8:	66 90                	xchg   %ax,%ax
801035ca:	66 90                	xchg   %ax,%ax
801035cc:	66 90                	xchg   %ax,%ax
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 0c             	sub    $0xc,%esp
801035d9:	8b 75 08             	mov    0x8(%ebp),%esi
801035dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801035df:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801035e5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035eb:	e8 50 d9 ff ff       	call   80100f40 <filealloc>
801035f0:	89 06                	mov    %eax,(%esi)
801035f2:	85 c0                	test   %eax,%eax
801035f4:	0f 84 a5 00 00 00    	je     8010369f <pipealloc+0xcf>
801035fa:	e8 41 d9 ff ff       	call   80100f40 <filealloc>
801035ff:	89 07                	mov    %eax,(%edi)
80103601:	85 c0                	test   %eax,%eax
80103603:	0f 84 84 00 00 00    	je     8010368d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103609:	e8 a2 f1 ff ff       	call   801027b0 <kalloc>
8010360e:	89 c3                	mov    %eax,%ebx
80103610:	85 c0                	test   %eax,%eax
80103612:	0f 84 a0 00 00 00    	je     801036b8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103618:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010361f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103622:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103625:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010362c:	00 00 00 
  p->nwrite = 0;
8010362f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103636:	00 00 00 
  p->nread = 0;
80103639:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103640:	00 00 00 
  initlock(&p->lock, "pipe");
80103643:	68 51 85 10 80       	push   $0x80108551
80103648:	50                   	push   %eax
80103649:	e8 d2 11 00 00       	call   80104820 <initlock>
  (*f0)->type = FD_PIPE;
8010364e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103650:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103653:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103659:	8b 06                	mov    (%esi),%eax
8010365b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010365f:	8b 06                	mov    (%esi),%eax
80103661:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103665:	8b 06                	mov    (%esi),%eax
80103667:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010366a:	8b 07                	mov    (%edi),%eax
8010366c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103672:	8b 07                	mov    (%edi),%eax
80103674:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103678:	8b 07                	mov    (%edi),%eax
8010367a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010367e:	8b 07                	mov    (%edi),%eax
80103680:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103683:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103685:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103688:	5b                   	pop    %ebx
80103689:	5e                   	pop    %esi
8010368a:	5f                   	pop    %edi
8010368b:	5d                   	pop    %ebp
8010368c:	c3                   	ret
  if(*f0)
8010368d:	8b 06                	mov    (%esi),%eax
8010368f:	85 c0                	test   %eax,%eax
80103691:	74 1e                	je     801036b1 <pipealloc+0xe1>
    fileclose(*f0);
80103693:	83 ec 0c             	sub    $0xc,%esp
80103696:	50                   	push   %eax
80103697:	e8 64 d9 ff ff       	call   80101000 <fileclose>
8010369c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010369f:	8b 07                	mov    (%edi),%eax
801036a1:	85 c0                	test   %eax,%eax
801036a3:	74 0c                	je     801036b1 <pipealloc+0xe1>
    fileclose(*f1);
801036a5:	83 ec 0c             	sub    $0xc,%esp
801036a8:	50                   	push   %eax
801036a9:	e8 52 d9 ff ff       	call   80101000 <fileclose>
801036ae:	83 c4 10             	add    $0x10,%esp
  return -1;
801036b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801036b6:	eb cd                	jmp    80103685 <pipealloc+0xb5>
  if(*f0)
801036b8:	8b 06                	mov    (%esi),%eax
801036ba:	85 c0                	test   %eax,%eax
801036bc:	75 d5                	jne    80103693 <pipealloc+0xc3>
801036be:	eb df                	jmp    8010369f <pipealloc+0xcf>

801036c0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	56                   	push   %esi
801036c4:	53                   	push   %ebx
801036c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801036cb:	83 ec 0c             	sub    $0xc,%esp
801036ce:	53                   	push   %ebx
801036cf:	e8 3c 13 00 00       	call   80104a10 <acquire>
  if(writable){
801036d4:	83 c4 10             	add    $0x10,%esp
801036d7:	85 f6                	test   %esi,%esi
801036d9:	74 65                	je     80103740 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801036db:	83 ec 0c             	sub    $0xc,%esp
801036de:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801036e4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801036eb:	00 00 00 
    wakeup(&p->nread);
801036ee:	50                   	push   %eax
801036ef:	e8 1c 0c 00 00       	call   80104310 <wakeup>
801036f4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801036f7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801036fd:	85 d2                	test   %edx,%edx
801036ff:	75 0a                	jne    8010370b <pipeclose+0x4b>
80103701:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103707:	85 c0                	test   %eax,%eax
80103709:	74 15                	je     80103720 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010370b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010370e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103711:	5b                   	pop    %ebx
80103712:	5e                   	pop    %esi
80103713:	5d                   	pop    %ebp
    release(&p->lock);
80103714:	e9 97 12 00 00       	jmp    801049b0 <release>
80103719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103720:	83 ec 0c             	sub    $0xc,%esp
80103723:	53                   	push   %ebx
80103724:	e8 87 12 00 00       	call   801049b0 <release>
    kfree((char*)p);
80103729:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010372c:	83 c4 10             	add    $0x10,%esp
}
8010372f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103732:	5b                   	pop    %ebx
80103733:	5e                   	pop    %esi
80103734:	5d                   	pop    %ebp
    kfree((char*)p);
80103735:	e9 66 ee ff ff       	jmp    801025a0 <kfree>
8010373a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103740:	83 ec 0c             	sub    $0xc,%esp
80103743:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103749:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103750:	00 00 00 
    wakeup(&p->nwrite);
80103753:	50                   	push   %eax
80103754:	e8 b7 0b 00 00       	call   80104310 <wakeup>
80103759:	83 c4 10             	add    $0x10,%esp
8010375c:	eb 99                	jmp    801036f7 <pipeclose+0x37>
8010375e:	66 90                	xchg   %ax,%ax

80103760 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	57                   	push   %edi
80103764:	56                   	push   %esi
80103765:	53                   	push   %ebx
80103766:	83 ec 28             	sub    $0x28,%esp
80103769:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010376c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010376f:	53                   	push   %ebx
80103770:	e8 9b 12 00 00       	call   80104a10 <acquire>
  for(i = 0; i < n; i++){
80103775:	83 c4 10             	add    $0x10,%esp
80103778:	85 ff                	test   %edi,%edi
8010377a:	0f 8e ce 00 00 00    	jle    8010384e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103780:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103786:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103789:	89 7d 10             	mov    %edi,0x10(%ebp)
8010378c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010378f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103792:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103795:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010379b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037a1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037a7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801037ad:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801037b0:	0f 85 b6 00 00 00    	jne    8010386c <pipewrite+0x10c>
801037b6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801037b9:	eb 3b                	jmp    801037f6 <pipewrite+0x96>
801037bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037bf:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
801037c0:	e8 4b 03 00 00       	call   80103b10 <myproc>
801037c5:	8b 48 28             	mov    0x28(%eax),%ecx
801037c8:	85 c9                	test   %ecx,%ecx
801037ca:	75 34                	jne    80103800 <pipewrite+0xa0>
      wakeup(&p->nread);
801037cc:	83 ec 0c             	sub    $0xc,%esp
801037cf:	56                   	push   %esi
801037d0:	e8 3b 0b 00 00       	call   80104310 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037d5:	58                   	pop    %eax
801037d6:	5a                   	pop    %edx
801037d7:	53                   	push   %ebx
801037d8:	57                   	push   %edi
801037d9:	e8 72 0a 00 00       	call   80104250 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037de:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037e4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801037ea:	83 c4 10             	add    $0x10,%esp
801037ed:	05 00 02 00 00       	add    $0x200,%eax
801037f2:	39 c2                	cmp    %eax,%edx
801037f4:	75 2a                	jne    80103820 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801037f6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037fc:	85 c0                	test   %eax,%eax
801037fe:	75 c0                	jne    801037c0 <pipewrite+0x60>
        release(&p->lock);
80103800:	83 ec 0c             	sub    $0xc,%esp
80103803:	53                   	push   %ebx
80103804:	e8 a7 11 00 00       	call   801049b0 <release>
        return -1;
80103809:	83 c4 10             	add    $0x10,%esp
8010380c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103811:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103814:	5b                   	pop    %ebx
80103815:	5e                   	pop    %esi
80103816:	5f                   	pop    %edi
80103817:	5d                   	pop    %ebp
80103818:	c3                   	ret
80103819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103820:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103823:	8d 42 01             	lea    0x1(%edx),%eax
80103826:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010382c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010382f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103835:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103838:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010383c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103840:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103843:	39 c1                	cmp    %eax,%ecx
80103845:	0f 85 50 ff ff ff    	jne    8010379b <pipewrite+0x3b>
8010384b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010384e:	83 ec 0c             	sub    $0xc,%esp
80103851:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103857:	50                   	push   %eax
80103858:	e8 b3 0a 00 00       	call   80104310 <wakeup>
  release(&p->lock);
8010385d:	89 1c 24             	mov    %ebx,(%esp)
80103860:	e8 4b 11 00 00       	call   801049b0 <release>
  return n;
80103865:	83 c4 10             	add    $0x10,%esp
80103868:	89 f8                	mov    %edi,%eax
8010386a:	eb a5                	jmp    80103811 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010386c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010386f:	eb b2                	jmp    80103823 <pipewrite+0xc3>
80103871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010387f:	90                   	nop

80103880 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	57                   	push   %edi
80103884:	56                   	push   %esi
80103885:	53                   	push   %ebx
80103886:	83 ec 18             	sub    $0x18,%esp
80103889:	8b 75 08             	mov    0x8(%ebp),%esi
8010388c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010388f:	56                   	push   %esi
80103890:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103896:	e8 75 11 00 00       	call   80104a10 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010389b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038a1:	83 c4 10             	add    $0x10,%esp
801038a4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801038aa:	74 2f                	je     801038db <piperead+0x5b>
801038ac:	eb 37                	jmp    801038e5 <piperead+0x65>
801038ae:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801038b0:	e8 5b 02 00 00       	call   80103b10 <myproc>
801038b5:	8b 40 28             	mov    0x28(%eax),%eax
801038b8:	85 c0                	test   %eax,%eax
801038ba:	0f 85 80 00 00 00    	jne    80103940 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038c0:	83 ec 08             	sub    $0x8,%esp
801038c3:	56                   	push   %esi
801038c4:	53                   	push   %ebx
801038c5:	e8 86 09 00 00       	call   80104250 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038ca:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038d0:	83 c4 10             	add    $0x10,%esp
801038d3:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801038d9:	75 0a                	jne    801038e5 <piperead+0x65>
801038db:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801038e1:	85 d2                	test   %edx,%edx
801038e3:	75 cb                	jne    801038b0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801038e8:	31 db                	xor    %ebx,%ebx
801038ea:	85 c9                	test   %ecx,%ecx
801038ec:	7f 26                	jg     80103914 <piperead+0x94>
801038ee:	eb 2c                	jmp    8010391c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801038f0:	8d 48 01             	lea    0x1(%eax),%ecx
801038f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801038f8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801038fe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103903:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103906:	83 c3 01             	add    $0x1,%ebx
80103909:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010390c:	74 0e                	je     8010391c <piperead+0x9c>
8010390e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103914:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010391a:	75 d4                	jne    801038f0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010391c:	83 ec 0c             	sub    $0xc,%esp
8010391f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103925:	50                   	push   %eax
80103926:	e8 e5 09 00 00       	call   80104310 <wakeup>
  release(&p->lock);
8010392b:	89 34 24             	mov    %esi,(%esp)
8010392e:	e8 7d 10 00 00       	call   801049b0 <release>
  return i;
80103933:	83 c4 10             	add    $0x10,%esp
}
80103936:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103939:	89 d8                	mov    %ebx,%eax
8010393b:	5b                   	pop    %ebx
8010393c:	5e                   	pop    %esi
8010393d:	5f                   	pop    %edi
8010393e:	5d                   	pop    %ebp
8010393f:	c3                   	ret
      release(&p->lock);
80103940:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103943:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103948:	56                   	push   %esi
80103949:	e8 62 10 00 00       	call   801049b0 <release>
      return -1;
8010394e:	83 c4 10             	add    $0x10,%esp
}
80103951:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103954:	89 d8                	mov    %ebx,%eax
80103956:	5b                   	pop    %ebx
80103957:	5e                   	pop    %esi
80103958:	5f                   	pop    %edi
80103959:	5d                   	pop    %ebp
8010395a:	c3                   	ret
8010395b:	66 90                	xchg   %ax,%ax
8010395d:	66 90                	xchg   %ax,%ax
8010395f:	90                   	nop

80103960 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103964:	bb b4 38 11 80       	mov    $0x801138b4,%ebx
{
80103969:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010396c:	68 80 38 11 80       	push   $0x80113880
80103971:	e8 9a 10 00 00       	call   80104a10 <acquire>
80103976:	83 c4 10             	add    $0x10,%esp
80103979:	eb 10                	jmp    8010398b <allocproc+0x2b>
8010397b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010397f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103980:	83 eb 80             	sub    $0xffffff80,%ebx
80103983:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
80103989:	74 75                	je     80103a00 <allocproc+0xa0>
    if(p->state == UNUSED)
8010398b:	8b 43 10             	mov    0x10(%ebx),%eax
8010398e:	85 c0                	test   %eax,%eax
80103990:	75 ee                	jne    80103980 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103992:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103997:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010399a:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
801039a1:	89 43 14             	mov    %eax,0x14(%ebx)
801039a4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801039a7:	68 80 38 11 80       	push   $0x80113880
  p->pid = nextpid++;
801039ac:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801039b2:	e8 f9 0f 00 00       	call   801049b0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039b7:	e8 f4 ed ff ff       	call   801027b0 <kalloc>
801039bc:	83 c4 10             	add    $0x10,%esp
801039bf:	89 43 0c             	mov    %eax,0xc(%ebx)
801039c2:	85 c0                	test   %eax,%eax
801039c4:	74 53                	je     80103a19 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039c6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039cc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801039cf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801039d4:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
801039d7:	c7 40 14 e2 5c 10 80 	movl   $0x80105ce2,0x14(%eax)
  p->context = (struct context*)sp;
801039de:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
801039e1:	6a 14                	push   $0x14
801039e3:	6a 00                	push   $0x0
801039e5:	50                   	push   %eax
801039e6:	e8 25 11 00 00       	call   80104b10 <memset>
  p->context->eip = (uint)forkret;
801039eb:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
801039ee:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801039f1:	c7 40 10 30 3a 10 80 	movl   $0x80103a30,0x10(%eax)
}
801039f8:	89 d8                	mov    %ebx,%eax
801039fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039fd:	c9                   	leave
801039fe:	c3                   	ret
801039ff:	90                   	nop
  release(&ptable.lock);
80103a00:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a03:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a05:	68 80 38 11 80       	push   $0x80113880
80103a0a:	e8 a1 0f 00 00       	call   801049b0 <release>
  return 0;
80103a0f:	83 c4 10             	add    $0x10,%esp
}
80103a12:	89 d8                	mov    %ebx,%eax
80103a14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a17:	c9                   	leave
80103a18:	c3                   	ret
    p->state = UNUSED;
80103a19:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  return 0;
80103a20:	31 db                	xor    %ebx,%ebx
80103a22:	eb ee                	jmp    80103a12 <allocproc+0xb2>
80103a24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a2f:	90                   	nop

80103a30 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a36:	68 80 38 11 80       	push   $0x80113880
80103a3b:	e8 70 0f 00 00       	call   801049b0 <release>

  if (first) {
80103a40:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a45:	83 c4 10             	add    $0x10,%esp
80103a48:	85 c0                	test   %eax,%eax
80103a4a:	75 04                	jne    80103a50 <forkret+0x20>
    initlog(ROOTDEV);
    swapinit();
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a4c:	c9                   	leave
80103a4d:	c3                   	ret
80103a4e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a50:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a57:	00 00 00 
    iinit(ROOTDEV);
80103a5a:	83 ec 0c             	sub    $0xc,%esp
80103a5d:	6a 01                	push   $0x1
80103a5f:	e8 0c dc ff ff       	call   80101670 <iinit>
    initlog(ROOTDEV);
80103a64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a6b:	e8 f0 f3 ff ff       	call   80102e60 <initlog>
    swapinit();
80103a70:	83 c4 10             	add    $0x10,%esp
}
80103a73:	c9                   	leave
    swapinit();
80103a74:	e9 07 41 00 00       	jmp    80107b80 <swapinit>
80103a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a80 <pinit>:
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a86:	68 56 85 10 80       	push   $0x80108556
80103a8b:	68 80 38 11 80       	push   $0x80113880
80103a90:	e8 8b 0d 00 00       	call   80104820 <initlock>
}
80103a95:	83 c4 10             	add    $0x10,%esp
80103a98:	c9                   	leave
80103a99:	c3                   	ret
80103a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103aa0 <mycpu>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103aa6:	9c                   	pushf
80103aa7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103aa8:	f6 c4 02             	test   $0x2,%ah
80103aab:	75 32                	jne    80103adf <mycpu+0x3f>
  apicid = lapicid();
80103aad:	e8 de ef ff ff       	call   80102a90 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ab2:	8b 15 a4 37 11 80    	mov    0x801137a4,%edx
80103ab8:	85 d2                	test   %edx,%edx
80103aba:	7e 0b                	jle    80103ac7 <mycpu+0x27>
    if (cpus[i].apicid == apicid)
80103abc:	0f b6 15 c0 37 11 80 	movzbl 0x801137c0,%edx
80103ac3:	39 d0                	cmp    %edx,%eax
80103ac5:	74 11                	je     80103ad8 <mycpu+0x38>
  panic("unknown apicid\n");
80103ac7:	83 ec 0c             	sub    $0xc,%esp
80103aca:	68 5d 85 10 80       	push   $0x8010855d
80103acf:	e8 9c c9 ff ff       	call   80100470 <panic>
80103ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80103ad8:	c9                   	leave
80103ad9:	b8 c0 37 11 80       	mov    $0x801137c0,%eax
80103ade:	c3                   	ret
    panic("mycpu called with interrupts enabled\n");
80103adf:	83 ec 0c             	sub    $0xc,%esp
80103ae2:	68 74 89 10 80       	push   $0x80108974
80103ae7:	e8 84 c9 ff ff       	call   80100470 <panic>
80103aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103af0 <cpuid>:
cpuid() {
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103af6:	e8 a5 ff ff ff       	call   80103aa0 <mycpu>
}
80103afb:	c9                   	leave
  return mycpu()-cpus;
80103afc:	2d c0 37 11 80       	sub    $0x801137c0,%eax
80103b01:	c1 f8 04             	sar    $0x4,%eax
80103b04:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b0a:	c3                   	ret
80103b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b0f:	90                   	nop

80103b10 <myproc>:
myproc(void) {
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	53                   	push   %ebx
80103b14:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b17:	e8 a4 0d 00 00       	call   801048c0 <pushcli>
  c = mycpu();
80103b1c:	e8 7f ff ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103b21:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b27:	e8 e4 0d 00 00       	call   80104910 <popcli>
}
80103b2c:	89 d8                	mov    %ebx,%eax
80103b2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b31:	c9                   	leave
80103b32:	c3                   	ret
80103b33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b40 <userinit>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	53                   	push   %ebx
80103b44:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b47:	e8 14 fe ff ff       	call   80103960 <allocproc>
80103b4c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b4e:	a3 b4 58 11 80       	mov    %eax,0x801158b4
  if((p->pgdir = setupkvm()) == 0)
80103b53:	e8 18 3a 00 00       	call   80107570 <setupkvm>
80103b58:	89 43 08             	mov    %eax,0x8(%ebx)
80103b5b:	85 c0                	test   %eax,%eax
80103b5d:	0f 84 bd 00 00 00    	je     80103c20 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size,p->pid);
80103b63:	ff 73 14             	push   0x14(%ebx)
80103b66:	68 2c 00 00 00       	push   $0x2c
80103b6b:	68 60 b4 10 80       	push   $0x8010b460
80103b70:	50                   	push   %eax
80103b71:	e8 aa 36 00 00       	call   80107220 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b76:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b79:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b7f:	6a 4c                	push   $0x4c
80103b81:	6a 00                	push   $0x0
80103b83:	ff 73 1c             	push   0x1c(%ebx)
80103b86:	e8 85 0f 00 00       	call   80104b10 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b8b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103b8e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b93:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b96:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b9b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b9f:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103ba2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ba6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103ba9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bad:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bb1:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bb4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bb8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bbc:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bbf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103bc6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bc9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103bd0:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bd3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bda:	8d 43 70             	lea    0x70(%ebx),%eax
80103bdd:	6a 10                	push   $0x10
80103bdf:	68 86 85 10 80       	push   $0x80108586
80103be4:	50                   	push   %eax
80103be5:	e8 d6 10 00 00       	call   80104cc0 <safestrcpy>
  p->cwd = namei("/");
80103bea:	c7 04 24 8f 85 10 80 	movl   $0x8010858f,(%esp)
80103bf1:	e8 7a e5 ff ff       	call   80102170 <namei>
80103bf6:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
80103bf9:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103c00:	e8 0b 0e 00 00       	call   80104a10 <acquire>
  p->state = RUNNABLE;
80103c05:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
80103c0c:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103c13:	e8 98 0d 00 00       	call   801049b0 <release>
}
80103c18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c1b:	83 c4 10             	add    $0x10,%esp
80103c1e:	c9                   	leave
80103c1f:	c3                   	ret
    panic("userinit: out of memory?");
80103c20:	83 ec 0c             	sub    $0xc,%esp
80103c23:	68 6d 85 10 80       	push   $0x8010856d
80103c28:	e8 43 c8 ff ff       	call   80100470 <panic>
80103c2d:	8d 76 00             	lea    0x0(%esi),%esi

80103c30 <growproc>:
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	56                   	push   %esi
80103c34:	53                   	push   %ebx
80103c35:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c38:	e8 83 0c 00 00       	call   801048c0 <pushcli>
  c = mycpu();
80103c3d:	e8 5e fe ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103c42:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c48:	e8 c3 0c 00 00       	call   80104910 <popcli>
  sz = curproc->sz;
80103c4d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c4f:	85 f6                	test   %esi,%esi
80103c51:	7f 1d                	jg     80103c70 <growproc+0x40>
  } else if(n < 0){
80103c53:	75 3b                	jne    80103c90 <growproc+0x60>
  switchuvm(curproc);
80103c55:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c58:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c5a:	53                   	push   %ebx
80103c5b:	e8 b0 34 00 00       	call   80107110 <switchuvm>
  return 0;
80103c60:	83 c4 10             	add    $0x10,%esp
80103c63:	31 c0                	xor    %eax,%eax
}
80103c65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c68:	5b                   	pop    %ebx
80103c69:	5e                   	pop    %esi
80103c6a:	5d                   	pop    %ebp
80103c6b:	c3                   	ret
80103c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c70:	83 ec 04             	sub    $0x4,%esp
80103c73:	01 c6                	add    %eax,%esi
80103c75:	56                   	push   %esi
80103c76:	50                   	push   %eax
80103c77:	ff 73 08             	push   0x8(%ebx)
80103c7a:	e8 f1 36 00 00       	call   80107370 <allocuvm>
80103c7f:	83 c4 10             	add    $0x10,%esp
80103c82:	85 c0                	test   %eax,%eax
80103c84:	75 cf                	jne    80103c55 <growproc+0x25>
      return -1;
80103c86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c8b:	eb d8                	jmp    80103c65 <growproc+0x35>
80103c8d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c90:	83 ec 04             	sub    $0x4,%esp
80103c93:	01 c6                	add    %eax,%esi
80103c95:	56                   	push   %esi
80103c96:	50                   	push   %eax
80103c97:	ff 73 08             	push   0x8(%ebx)
80103c9a:	e8 f1 37 00 00       	call   80107490 <deallocuvm>
80103c9f:	83 c4 10             	add    $0x10,%esp
80103ca2:	85 c0                	test   %eax,%eax
80103ca4:	75 af                	jne    80103c55 <growproc+0x25>
80103ca6:	eb de                	jmp    80103c86 <growproc+0x56>
80103ca8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103caf:	90                   	nop

80103cb0 <fork>:
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	57                   	push   %edi
80103cb4:	56                   	push   %esi
80103cb5:	53                   	push   %ebx
80103cb6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103cb9:	e8 02 0c 00 00       	call   801048c0 <pushcli>
  c = mycpu();
80103cbe:	e8 dd fd ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103cc3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cc9:	e8 42 0c 00 00       	call   80104910 <popcli>
  if((np = allocproc()) == 0){
80103cce:	e8 8d fc ff ff       	call   80103960 <allocproc>
80103cd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103cd6:	85 c0                	test   %eax,%eax
80103cd8:	0f 84 de 00 00 00    	je     80103dbc <fork+0x10c>
  if((np->pgdir = copyuvm_cow(curproc->pgdir, curproc->sz,np)) == 0){
80103cde:	83 ec 04             	sub    $0x4,%esp
80103ce1:	89 c7                	mov    %eax,%edi
80103ce3:	50                   	push   %eax
80103ce4:	ff 33                	push   (%ebx)
80103ce6:	ff 73 08             	push   0x8(%ebx)
80103ce9:	e8 a2 3a 00 00       	call   80107790 <copyuvm_cow>
80103cee:	83 c4 10             	add    $0x10,%esp
80103cf1:	89 47 08             	mov    %eax,0x8(%edi)
80103cf4:	85 c0                	test   %eax,%eax
80103cf6:	0f 84 a1 00 00 00    	je     80103d9d <fork+0xed>
  np->sz = curproc->sz;
80103cfc:	8b 03                	mov    (%ebx),%eax
80103cfe:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d01:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d03:	8b 79 1c             	mov    0x1c(%ecx),%edi
  np->parent = curproc;
80103d06:	89 c8                	mov    %ecx,%eax
80103d08:	89 59 18             	mov    %ebx,0x18(%ecx)
  *np->tf = *curproc->tf;
80103d0b:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d10:	8b 73 1c             	mov    0x1c(%ebx),%esi
80103d13:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d15:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d17:	8b 40 1c             	mov    0x1c(%eax),%eax
80103d1a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103d28:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103d2c:	85 c0                	test   %eax,%eax
80103d2e:	74 13                	je     80103d43 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d30:	83 ec 0c             	sub    $0xc,%esp
80103d33:	50                   	push   %eax
80103d34:	e8 77 d2 ff ff       	call   80100fb0 <filedup>
80103d39:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d3c:	83 c4 10             	add    $0x10,%esp
80103d3f:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d43:	83 c6 01             	add    $0x1,%esi
80103d46:	83 fe 10             	cmp    $0x10,%esi
80103d49:	75 dd                	jne    80103d28 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103d4b:	83 ec 0c             	sub    $0xc,%esp
80103d4e:	ff 73 6c             	push   0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d51:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103d54:	e8 07 db ff ff       	call   80101860 <idup>
80103d59:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d5c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d5f:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d62:	8d 47 70             	lea    0x70(%edi),%eax
80103d65:	6a 10                	push   $0x10
80103d67:	53                   	push   %ebx
80103d68:	50                   	push   %eax
80103d69:	e8 52 0f 00 00       	call   80104cc0 <safestrcpy>
  pid = np->pid;
80103d6e:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
80103d71:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103d78:	e8 93 0c 00 00       	call   80104a10 <acquire>
  np->state = RUNNABLE;
80103d7d:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
80103d84:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103d8b:	e8 20 0c 00 00       	call   801049b0 <release>
  return pid;
80103d90:	83 c4 10             	add    $0x10,%esp
}
80103d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d96:	89 d8                	mov    %ebx,%eax
80103d98:	5b                   	pop    %ebx
80103d99:	5e                   	pop    %esi
80103d9a:	5f                   	pop    %edi
80103d9b:	5d                   	pop    %ebp
80103d9c:	c3                   	ret
    kfree(np->kstack);
80103d9d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103da0:	83 ec 0c             	sub    $0xc,%esp
80103da3:	ff 73 0c             	push   0xc(%ebx)
80103da6:	e8 f5 e7 ff ff       	call   801025a0 <kfree>
    np->kstack = 0;
80103dab:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103db2:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103db5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
80103dbc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103dc1:	eb d0                	jmp    80103d93 <fork+0xe3>
80103dc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103dd0 <print_rss>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dd4:	bb b4 38 11 80       	mov    $0x801138b4,%ebx
{
80103dd9:	83 ec 10             	sub    $0x10,%esp
  cprintf("PrintingRSS\n");
80103ddc:	68 91 85 10 80       	push   $0x80108591
80103de1:	e8 ba c9 ff ff       	call   801007a0 <cprintf>
  acquire(&ptable.lock);
80103de6:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103ded:	e8 1e 0c 00 00       	call   80104a10 <acquire>
80103df2:	83 c4 10             	add    $0x10,%esp
80103df5:	8d 76 00             	lea    0x0(%esi),%esi
    if((p->state == UNUSED))
80103df8:	8b 43 10             	mov    0x10(%ebx),%eax
80103dfb:	85 c0                	test   %eax,%eax
80103dfd:	74 14                	je     80103e13 <print_rss+0x43>
    cprintf("((P)) id: %d, state: %d, rss: %d\n",p->pid,p->state,p->rss);
80103dff:	ff 73 04             	push   0x4(%ebx)
80103e02:	50                   	push   %eax
80103e03:	ff 73 14             	push   0x14(%ebx)
80103e06:	68 9c 89 10 80       	push   $0x8010899c
80103e0b:	e8 90 c9 ff ff       	call   801007a0 <cprintf>
80103e10:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e13:	83 eb 80             	sub    $0xffffff80,%ebx
80103e16:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
80103e1c:	75 da                	jne    80103df8 <print_rss+0x28>
  release(&ptable.lock);
80103e1e:	83 ec 0c             	sub    $0xc,%esp
80103e21:	68 80 38 11 80       	push   $0x80113880
80103e26:	e8 85 0b 00 00       	call   801049b0 <release>
}
80103e2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e2e:	83 c4 10             	add    $0x10,%esp
80103e31:	c9                   	leave
80103e32:	c3                   	ret
80103e33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e40 <scheduler>:
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	57                   	push   %edi
80103e44:	56                   	push   %esi
80103e45:	53                   	push   %ebx
80103e46:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e49:	e8 52 fc ff ff       	call   80103aa0 <mycpu>
  c->proc = 0;
80103e4e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e55:	00 00 00 
  struct cpu *c = mycpu();
80103e58:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e5a:	8d 78 04             	lea    0x4(%eax),%edi
80103e5d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e60:	fb                   	sti
    acquire(&ptable.lock);
80103e61:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e64:	bb b4 38 11 80       	mov    $0x801138b4,%ebx
    acquire(&ptable.lock);
80103e69:	68 80 38 11 80       	push   $0x80113880
80103e6e:	e8 9d 0b 00 00       	call   80104a10 <acquire>
80103e73:	83 c4 10             	add    $0x10,%esp
80103e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e7d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103e80:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80103e84:	75 33                	jne    80103eb9 <scheduler+0x79>
      switchuvm(p);
80103e86:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e89:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e8f:	53                   	push   %ebx
80103e90:	e8 7b 32 00 00       	call   80107110 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103e95:	58                   	pop    %eax
80103e96:	5a                   	pop    %edx
80103e97:	ff 73 20             	push   0x20(%ebx)
80103e9a:	57                   	push   %edi
      p->state = RUNNING;
80103e9b:	c7 43 10 04 00 00 00 	movl   $0x4,0x10(%ebx)
      swtch(&(c->scheduler), p->context);
80103ea2:	e8 74 0e 00 00       	call   80104d1b <swtch>
      switchkvm();
80103ea7:	e8 54 32 00 00       	call   80107100 <switchkvm>
      c->proc = 0;
80103eac:	83 c4 10             	add    $0x10,%esp
80103eaf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103eb6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eb9:	83 eb 80             	sub    $0xffffff80,%ebx
80103ebc:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
80103ec2:	75 bc                	jne    80103e80 <scheduler+0x40>
    release(&ptable.lock);
80103ec4:	83 ec 0c             	sub    $0xc,%esp
80103ec7:	68 80 38 11 80       	push   $0x80113880
80103ecc:	e8 df 0a 00 00       	call   801049b0 <release>
    sti();
80103ed1:	83 c4 10             	add    $0x10,%esp
80103ed4:	eb 8a                	jmp    80103e60 <scheduler+0x20>
80103ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103edd:	8d 76 00             	lea    0x0(%esi),%esi

80103ee0 <sched>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	56                   	push   %esi
80103ee4:	53                   	push   %ebx
  pushcli();
80103ee5:	e8 d6 09 00 00       	call   801048c0 <pushcli>
  c = mycpu();
80103eea:	e8 b1 fb ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103eef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ef5:	e8 16 0a 00 00       	call   80104910 <popcli>
  if(!holding(&ptable.lock))
80103efa:	83 ec 0c             	sub    $0xc,%esp
80103efd:	68 80 38 11 80       	push   $0x80113880
80103f02:	e8 69 0a 00 00       	call   80104970 <holding>
80103f07:	83 c4 10             	add    $0x10,%esp
80103f0a:	85 c0                	test   %eax,%eax
80103f0c:	74 4f                	je     80103f5d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f0e:	e8 8d fb ff ff       	call   80103aa0 <mycpu>
80103f13:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f1a:	75 68                	jne    80103f84 <sched+0xa4>
  if(p->state == RUNNING)
80103f1c:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80103f20:	74 55                	je     80103f77 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f22:	9c                   	pushf
80103f23:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f24:	f6 c4 02             	test   $0x2,%ah
80103f27:	75 41                	jne    80103f6a <sched+0x8a>
  intena = mycpu()->intena;
80103f29:	e8 72 fb ff ff       	call   80103aa0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f2e:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
80103f31:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f37:	e8 64 fb ff ff       	call   80103aa0 <mycpu>
80103f3c:	83 ec 08             	sub    $0x8,%esp
80103f3f:	ff 70 04             	push   0x4(%eax)
80103f42:	53                   	push   %ebx
80103f43:	e8 d3 0d 00 00       	call   80104d1b <swtch>
  mycpu()->intena = intena;
80103f48:	e8 53 fb ff ff       	call   80103aa0 <mycpu>
}
80103f4d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f50:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f59:	5b                   	pop    %ebx
80103f5a:	5e                   	pop    %esi
80103f5b:	5d                   	pop    %ebp
80103f5c:	c3                   	ret
    panic("sched ptable.lock");
80103f5d:	83 ec 0c             	sub    $0xc,%esp
80103f60:	68 9e 85 10 80       	push   $0x8010859e
80103f65:	e8 06 c5 ff ff       	call   80100470 <panic>
    panic("sched interruptible");
80103f6a:	83 ec 0c             	sub    $0xc,%esp
80103f6d:	68 ca 85 10 80       	push   $0x801085ca
80103f72:	e8 f9 c4 ff ff       	call   80100470 <panic>
    panic("sched running");
80103f77:	83 ec 0c             	sub    $0xc,%esp
80103f7a:	68 bc 85 10 80       	push   $0x801085bc
80103f7f:	e8 ec c4 ff ff       	call   80100470 <panic>
    panic("sched locks");
80103f84:	83 ec 0c             	sub    $0xc,%esp
80103f87:	68 b0 85 10 80       	push   $0x801085b0
80103f8c:	e8 df c4 ff ff       	call   80100470 <panic>
80103f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f9f:	90                   	nop

80103fa0 <exit>:
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	57                   	push   %edi
80103fa4:	56                   	push   %esi
80103fa5:	53                   	push   %ebx
80103fa6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103fa9:	e8 62 fb ff ff       	call   80103b10 <myproc>
  if(curproc == initproc)
80103fae:	39 05 b4 58 11 80    	cmp    %eax,0x801158b4
80103fb4:	0f 84 fd 00 00 00    	je     801040b7 <exit+0x117>
80103fba:	89 c3                	mov    %eax,%ebx
80103fbc:	8d 70 2c             	lea    0x2c(%eax),%esi
80103fbf:	8d 78 6c             	lea    0x6c(%eax),%edi
80103fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103fc8:	8b 06                	mov    (%esi),%eax
80103fca:	85 c0                	test   %eax,%eax
80103fcc:	74 12                	je     80103fe0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103fce:	83 ec 0c             	sub    $0xc,%esp
80103fd1:	50                   	push   %eax
80103fd2:	e8 29 d0 ff ff       	call   80101000 <fileclose>
      curproc->ofile[fd] = 0;
80103fd7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103fdd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103fe0:	83 c6 04             	add    $0x4,%esi
80103fe3:	39 f7                	cmp    %esi,%edi
80103fe5:	75 e1                	jne    80103fc8 <exit+0x28>
  begin_op();
80103fe7:	e8 14 ef ff ff       	call   80102f00 <begin_op>
  iput(curproc->cwd);
80103fec:	83 ec 0c             	sub    $0xc,%esp
80103fef:	ff 73 6c             	push   0x6c(%ebx)
80103ff2:	e8 c9 d9 ff ff       	call   801019c0 <iput>
  end_op();
80103ff7:	e8 74 ef ff ff       	call   80102f70 <end_op>
  curproc->cwd = 0;
80103ffc:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
80104003:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
8010400a:	e8 01 0a 00 00       	call   80104a10 <acquire>
  wakeup1(curproc->parent);
8010400f:	8b 53 18             	mov    0x18(%ebx),%edx
80104012:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104015:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
8010401a:	eb 0e                	jmp    8010402a <exit+0x8a>
8010401c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104020:	83 e8 80             	sub    $0xffffff80,%eax
80104023:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104028:	74 1c                	je     80104046 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010402a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010402e:	75 f0                	jne    80104020 <exit+0x80>
80104030:	3b 50 24             	cmp    0x24(%eax),%edx
80104033:	75 eb                	jne    80104020 <exit+0x80>
      p->state = RUNNABLE;
80104035:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010403c:	83 e8 80             	sub    $0xffffff80,%eax
8010403f:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104044:	75 e4                	jne    8010402a <exit+0x8a>
      p->parent = initproc;
80104046:	8b 0d b4 58 11 80    	mov    0x801158b4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010404c:	ba b4 38 11 80       	mov    $0x801138b4,%edx
80104051:	eb 10                	jmp    80104063 <exit+0xc3>
80104053:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104057:	90                   	nop
80104058:	83 ea 80             	sub    $0xffffff80,%edx
8010405b:	81 fa b4 58 11 80    	cmp    $0x801158b4,%edx
80104061:	74 3b                	je     8010409e <exit+0xfe>
    if(p->parent == curproc){
80104063:	39 5a 18             	cmp    %ebx,0x18(%edx)
80104066:	75 f0                	jne    80104058 <exit+0xb8>
      if(p->state == ZOMBIE)
80104068:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
      p->parent = initproc;
8010406c:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
8010406f:	75 e7                	jne    80104058 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104071:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
80104076:	eb 12                	jmp    8010408a <exit+0xea>
80104078:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010407f:	90                   	nop
80104080:	83 e8 80             	sub    $0xffffff80,%eax
80104083:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104088:	74 ce                	je     80104058 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010408a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010408e:	75 f0                	jne    80104080 <exit+0xe0>
80104090:	3b 48 24             	cmp    0x24(%eax),%ecx
80104093:	75 eb                	jne    80104080 <exit+0xe0>
      p->state = RUNNABLE;
80104095:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
8010409c:	eb e2                	jmp    80104080 <exit+0xe0>
  curproc->state = ZOMBIE;
8010409e:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
801040a5:	e8 36 fe ff ff       	call   80103ee0 <sched>
  panic("zombie exit");
801040aa:	83 ec 0c             	sub    $0xc,%esp
801040ad:	68 eb 85 10 80       	push   $0x801085eb
801040b2:	e8 b9 c3 ff ff       	call   80100470 <panic>
    panic("init exiting");
801040b7:	83 ec 0c             	sub    $0xc,%esp
801040ba:	68 de 85 10 80       	push   $0x801085de
801040bf:	e8 ac c3 ff ff       	call   80100470 <panic>
801040c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040cf:	90                   	nop

801040d0 <wait>:
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	56                   	push   %esi
801040d4:	53                   	push   %ebx
  pushcli();
801040d5:	e8 e6 07 00 00       	call   801048c0 <pushcli>
  c = mycpu();
801040da:	e8 c1 f9 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
801040df:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040e5:	e8 26 08 00 00       	call   80104910 <popcli>
  acquire(&ptable.lock);
801040ea:	83 ec 0c             	sub    $0xc,%esp
801040ed:	68 80 38 11 80       	push   $0x80113880
801040f2:	e8 19 09 00 00       	call   80104a10 <acquire>
801040f7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801040fa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040fc:	bb b4 38 11 80       	mov    $0x801138b4,%ebx
80104101:	eb 10                	jmp    80104113 <wait+0x43>
80104103:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104107:	90                   	nop
80104108:	83 eb 80             	sub    $0xffffff80,%ebx
8010410b:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
80104111:	74 1b                	je     8010412e <wait+0x5e>
      if(p->parent != curproc)
80104113:	39 73 18             	cmp    %esi,0x18(%ebx)
80104116:	75 f0                	jne    80104108 <wait+0x38>
      if(p->state == ZOMBIE){
80104118:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
8010411c:	74 62                	je     80104180 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010411e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104121:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104126:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
8010412c:	75 e5                	jne    80104113 <wait+0x43>
    if(!havekids || curproc->killed){
8010412e:	85 c0                	test   %eax,%eax
80104130:	0f 84 a2 00 00 00    	je     801041d8 <wait+0x108>
80104136:	8b 46 28             	mov    0x28(%esi),%eax
80104139:	85 c0                	test   %eax,%eax
8010413b:	0f 85 97 00 00 00    	jne    801041d8 <wait+0x108>
  pushcli();
80104141:	e8 7a 07 00 00       	call   801048c0 <pushcli>
  c = mycpu();
80104146:	e8 55 f9 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
8010414b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104151:	e8 ba 07 00 00       	call   80104910 <popcli>
  if(p == 0)
80104156:	85 db                	test   %ebx,%ebx
80104158:	0f 84 91 00 00 00    	je     801041ef <wait+0x11f>
  p->chan = chan;
8010415e:	89 73 24             	mov    %esi,0x24(%ebx)
  p->state = SLEEPING;
80104161:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104168:	e8 73 fd ff ff       	call   80103ee0 <sched>
  p->chan = 0;
8010416d:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
80104174:	eb 84                	jmp    801040fa <wait+0x2a>
80104176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010417d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104180:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104183:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
80104186:	ff 73 0c             	push   0xc(%ebx)
80104189:	e8 12 e4 ff ff       	call   801025a0 <kfree>
        p->kstack = 0;
8010418e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm_proc(p,p->pgdir);
80104195:	5a                   	pop    %edx
80104196:	59                   	pop    %ecx
80104197:	ff 73 08             	push   0x8(%ebx)
8010419a:	53                   	push   %ebx
8010419b:	e8 b0 37 00 00       	call   80107950 <freevm_proc>
        p->pid = 0;
801041a0:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
801041a7:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
801041ae:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
801041b2:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
801041b9:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
801041c0:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
801041c7:	e8 e4 07 00 00       	call   801049b0 <release>
        return pid;
801041cc:	83 c4 10             	add    $0x10,%esp
}
801041cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041d2:	89 f0                	mov    %esi,%eax
801041d4:	5b                   	pop    %ebx
801041d5:	5e                   	pop    %esi
801041d6:	5d                   	pop    %ebp
801041d7:	c3                   	ret
      release(&ptable.lock);
801041d8:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041db:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041e0:	68 80 38 11 80       	push   $0x80113880
801041e5:	e8 c6 07 00 00       	call   801049b0 <release>
      return -1;
801041ea:	83 c4 10             	add    $0x10,%esp
801041ed:	eb e0                	jmp    801041cf <wait+0xff>
    panic("sleep");
801041ef:	83 ec 0c             	sub    $0xc,%esp
801041f2:	68 f7 85 10 80       	push   $0x801085f7
801041f7:	e8 74 c2 ff ff       	call   80100470 <panic>
801041fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104200 <yield>:
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	53                   	push   %ebx
80104204:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104207:	68 80 38 11 80       	push   $0x80113880
8010420c:	e8 ff 07 00 00       	call   80104a10 <acquire>
  pushcli();
80104211:	e8 aa 06 00 00       	call   801048c0 <pushcli>
  c = mycpu();
80104216:	e8 85 f8 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
8010421b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104221:	e8 ea 06 00 00       	call   80104910 <popcli>
  myproc()->state = RUNNABLE;
80104226:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
8010422d:	e8 ae fc ff ff       	call   80103ee0 <sched>
  release(&ptable.lock);
80104232:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80104239:	e8 72 07 00 00       	call   801049b0 <release>
}
8010423e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104241:	83 c4 10             	add    $0x10,%esp
80104244:	c9                   	leave
80104245:	c3                   	ret
80104246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010424d:	8d 76 00             	lea    0x0(%esi),%esi

80104250 <sleep>:
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	57                   	push   %edi
80104254:	56                   	push   %esi
80104255:	53                   	push   %ebx
80104256:	83 ec 0c             	sub    $0xc,%esp
80104259:	8b 7d 08             	mov    0x8(%ebp),%edi
8010425c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010425f:	e8 5c 06 00 00       	call   801048c0 <pushcli>
  c = mycpu();
80104264:	e8 37 f8 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80104269:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010426f:	e8 9c 06 00 00       	call   80104910 <popcli>
  if(p == 0)
80104274:	85 db                	test   %ebx,%ebx
80104276:	0f 84 87 00 00 00    	je     80104303 <sleep+0xb3>
  if(lk == 0)
8010427c:	85 f6                	test   %esi,%esi
8010427e:	74 76                	je     801042f6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104280:	81 fe 80 38 11 80    	cmp    $0x80113880,%esi
80104286:	74 50                	je     801042d8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104288:	83 ec 0c             	sub    $0xc,%esp
8010428b:	68 80 38 11 80       	push   $0x80113880
80104290:	e8 7b 07 00 00       	call   80104a10 <acquire>
    release(lk);
80104295:	89 34 24             	mov    %esi,(%esp)
80104298:	e8 13 07 00 00       	call   801049b0 <release>
  p->chan = chan;
8010429d:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
801042a0:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801042a7:	e8 34 fc ff ff       	call   80103ee0 <sched>
  p->chan = 0;
801042ac:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
801042b3:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
801042ba:	e8 f1 06 00 00       	call   801049b0 <release>
    acquire(lk);
801042bf:	89 75 08             	mov    %esi,0x8(%ebp)
801042c2:	83 c4 10             	add    $0x10,%esp
}
801042c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042c8:	5b                   	pop    %ebx
801042c9:	5e                   	pop    %esi
801042ca:	5f                   	pop    %edi
801042cb:	5d                   	pop    %ebp
    acquire(lk);
801042cc:	e9 3f 07 00 00       	jmp    80104a10 <acquire>
801042d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801042d8:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
801042db:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801042e2:	e8 f9 fb ff ff       	call   80103ee0 <sched>
  p->chan = 0;
801042e7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
801042ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042f1:	5b                   	pop    %ebx
801042f2:	5e                   	pop    %esi
801042f3:	5f                   	pop    %edi
801042f4:	5d                   	pop    %ebp
801042f5:	c3                   	ret
    panic("sleep without lk");
801042f6:	83 ec 0c             	sub    $0xc,%esp
801042f9:	68 fd 85 10 80       	push   $0x801085fd
801042fe:	e8 6d c1 ff ff       	call   80100470 <panic>
    panic("sleep");
80104303:	83 ec 0c             	sub    $0xc,%esp
80104306:	68 f7 85 10 80       	push   $0x801085f7
8010430b:	e8 60 c1 ff ff       	call   80100470 <panic>

80104310 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	53                   	push   %ebx
80104314:	83 ec 10             	sub    $0x10,%esp
80104317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010431a:	68 80 38 11 80       	push   $0x80113880
8010431f:	e8 ec 06 00 00       	call   80104a10 <acquire>
80104324:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104327:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
8010432c:	eb 0c                	jmp    8010433a <wakeup+0x2a>
8010432e:	66 90                	xchg   %ax,%ax
80104330:	83 e8 80             	sub    $0xffffff80,%eax
80104333:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104338:	74 1c                	je     80104356 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010433a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010433e:	75 f0                	jne    80104330 <wakeup+0x20>
80104340:	3b 58 24             	cmp    0x24(%eax),%ebx
80104343:	75 eb                	jne    80104330 <wakeup+0x20>
      p->state = RUNNABLE;
80104345:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010434c:	83 e8 80             	sub    $0xffffff80,%eax
8010434f:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104354:	75 e4                	jne    8010433a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104356:	c7 45 08 80 38 11 80 	movl   $0x80113880,0x8(%ebp)
}
8010435d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104360:	c9                   	leave
  release(&ptable.lock);
80104361:	e9 4a 06 00 00       	jmp    801049b0 <release>
80104366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010436d:	8d 76 00             	lea    0x0(%esi),%esi

80104370 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	53                   	push   %ebx
80104374:	83 ec 10             	sub    $0x10,%esp
80104377:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010437a:	68 80 38 11 80       	push   $0x80113880
8010437f:	e8 8c 06 00 00       	call   80104a10 <acquire>
80104384:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104387:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
8010438c:	eb 0c                	jmp    8010439a <kill+0x2a>
8010438e:	66 90                	xchg   %ax,%ax
80104390:	83 e8 80             	sub    $0xffffff80,%eax
80104393:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104398:	74 36                	je     801043d0 <kill+0x60>
    if(p->pid == pid){
8010439a:	39 58 14             	cmp    %ebx,0x14(%eax)
8010439d:	75 f1                	jne    80104390 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010439f:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
801043a3:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
801043aa:	75 07                	jne    801043b3 <kill+0x43>
        p->state = RUNNABLE;
801043ac:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
801043b3:	83 ec 0c             	sub    $0xc,%esp
801043b6:	68 80 38 11 80       	push   $0x80113880
801043bb:	e8 f0 05 00 00       	call   801049b0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801043c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801043c3:	83 c4 10             	add    $0x10,%esp
801043c6:	31 c0                	xor    %eax,%eax
}
801043c8:	c9                   	leave
801043c9:	c3                   	ret
801043ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801043d0:	83 ec 0c             	sub    $0xc,%esp
801043d3:	68 80 38 11 80       	push   $0x80113880
801043d8:	e8 d3 05 00 00       	call   801049b0 <release>
}
801043dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801043e0:	83 c4 10             	add    $0x10,%esp
801043e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043e8:	c9                   	leave
801043e9:	c3                   	ret
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	57                   	push   %edi
801043f4:	56                   	push   %esi
801043f5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801043f8:	53                   	push   %ebx
801043f9:	bb 24 39 11 80       	mov    $0x80113924,%ebx
801043fe:	83 ec 3c             	sub    $0x3c,%esp
80104401:	eb 24                	jmp    80104427 <procdump+0x37>
80104403:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104407:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104408:	83 ec 0c             	sub    $0xc,%esp
8010440b:	68 bc 87 10 80       	push   $0x801087bc
80104410:	e8 8b c3 ff ff       	call   801007a0 <cprintf>
80104415:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104418:	83 eb 80             	sub    $0xffffff80,%ebx
8010441b:	81 fb 24 59 11 80    	cmp    $0x80115924,%ebx
80104421:	0f 84 81 00 00 00    	je     801044a8 <procdump+0xb8>
    if(p->state == UNUSED)
80104427:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010442a:	85 c0                	test   %eax,%eax
8010442c:	74 ea                	je     80104418 <procdump+0x28>
      state = "???";
8010442e:	ba 0e 86 10 80       	mov    $0x8010860e,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104433:	83 f8 05             	cmp    $0x5,%eax
80104436:	77 11                	ja     80104449 <procdump+0x59>
80104438:	8b 14 85 e0 8c 10 80 	mov    -0x7fef7320(,%eax,4),%edx
      state = "???";
8010443f:	b8 0e 86 10 80       	mov    $0x8010860e,%eax
80104444:	85 d2                	test   %edx,%edx
80104446:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104449:	53                   	push   %ebx
8010444a:	52                   	push   %edx
8010444b:	ff 73 a4             	push   -0x5c(%ebx)
8010444e:	68 12 86 10 80       	push   $0x80108612
80104453:	e8 48 c3 ff ff       	call   801007a0 <cprintf>
    if(p->state == SLEEPING){
80104458:	83 c4 10             	add    $0x10,%esp
8010445b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010445f:	75 a7                	jne    80104408 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104461:	83 ec 08             	sub    $0x8,%esp
80104464:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104467:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010446a:	50                   	push   %eax
8010446b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010446e:	8b 40 0c             	mov    0xc(%eax),%eax
80104471:	83 c0 08             	add    $0x8,%eax
80104474:	50                   	push   %eax
80104475:	e8 c6 03 00 00       	call   80104840 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010447a:	83 c4 10             	add    $0x10,%esp
8010447d:	8d 76 00             	lea    0x0(%esi),%esi
80104480:	8b 17                	mov    (%edi),%edx
80104482:	85 d2                	test   %edx,%edx
80104484:	74 82                	je     80104408 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104486:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104489:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010448c:	52                   	push   %edx
8010448d:	68 41 83 10 80       	push   $0x80108341
80104492:	e8 09 c3 ff ff       	call   801007a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104497:	83 c4 10             	add    $0x10,%esp
8010449a:	39 f7                	cmp    %esi,%edi
8010449c:	75 e2                	jne    80104480 <procdump+0x90>
8010449e:	e9 65 ff ff ff       	jmp    80104408 <procdump+0x18>
801044a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044a7:	90                   	nop
  }
}
801044a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044ab:	5b                   	pop    %ebx
801044ac:	5e                   	pop    %esi
801044ad:	5f                   	pop    %edi
801044ae:	5d                   	pop    %ebp
801044af:	c3                   	ret

801044b0 <get_victim_process>:
struct proc * get_victim_process(void){
801044b0:	55                   	push   %ebp
  struct proc * p;
  uint max_rss = 0;
801044b1:	31 c9                	xor    %ecx,%ecx
  struct proc * v = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044b3:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
struct proc * get_victim_process(void){
801044b8:	89 e5                	mov    %esp,%ebp
801044ba:	53                   	push   %ebx
  struct proc * v = 0;
801044bb:	31 db                	xor    %ebx,%ebx
801044bd:	eb 0f                	jmp    801044ce <get_victim_process+0x1e>
801044bf:	90                   	nop
    // if(p->state == UNUSED)
    //   continue;
    if(p->rss > max_rss){
      max_rss = p->rss;
      v = p;
    } else if (p->rss == max_rss){
801044c0:	39 ca                	cmp    %ecx,%edx
801044c2:	74 2c                	je     801044f0 <get_victim_process+0x40>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044c4:	83 e8 80             	sub    $0xffffff80,%eax
801044c7:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
801044cc:	74 15                	je     801044e3 <get_victim_process+0x33>
    if(p->rss > max_rss){
801044ce:	8b 50 04             	mov    0x4(%eax),%edx
801044d1:	39 d1                	cmp    %edx,%ecx
801044d3:	73 eb                	jae    801044c0 <get_victim_process+0x10>
      v = p;
801044d5:	89 c3                	mov    %eax,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044d7:	83 e8 80             	sub    $0xffffff80,%eax
      max_rss = p->rss;
801044da:	89 d1                	mov    %edx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044dc:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
801044e1:	75 eb                	jne    801044ce <get_victim_process+0x1e>
          v = p;
        }
      }
    }
    return v;
}
801044e3:	89 d8                	mov    %ebx,%eax
801044e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044e8:	c9                   	leave
801044e9:	c3                   	ret
801044ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(v == 0){
801044f0:	85 db                	test   %ebx,%ebx
801044f2:	74 0c                	je     80104500 <get_victim_process+0x50>
          v = p;
801044f4:	8b 53 14             	mov    0x14(%ebx),%edx
801044f7:	39 50 14             	cmp    %edx,0x14(%eax)
801044fa:	0f 4c d8             	cmovl  %eax,%ebx
801044fd:	eb c5                	jmp    801044c4 <get_victim_process+0x14>
801044ff:	90                   	nop
          v = p;
80104500:	89 c3                	mov    %eax,%ebx
80104502:	eb c0                	jmp    801044c4 <get_victim_process+0x14>
80104504:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010450f:	90                   	nop

80104510 <get_victim_page>:
//     // entries, if necessary.
//     *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
//   }
//   return &pgtab[PTX(va)];
// }
pte_t* get_victim_page(struct proc * v){
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	57                   	push   %edi
80104514:	8b 45 08             	mov    0x8(%ebp),%eax
80104517:	56                   	push   %esi
80104518:	53                   	push   %ebx
80104519:	8b 58 08             	mov    0x8(%eax),%ebx
8010451c:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
  pde_t * pgdir = v->pgdir;
  // pte_t* pte;
  for (int i = 0; i < NPDENTRIES; i++)
  {
    if (pgdir[i] & PTE_P)
80104522:	8b 0b                	mov    (%ebx),%ecx
80104524:	f6 c1 01             	test   $0x1,%cl
80104527:	75 17                	jne    80104540 <get_victim_page+0x30>
  for (int i = 0; i < NPDENTRIES; i++)
80104529:	83 c3 04             	add    $0x4,%ebx
8010452c:	39 de                	cmp    %ebx,%esi
8010452e:	75 f2                	jne    80104522 <get_victim_page+0x12>
        }
      }
    }
  }

  return 0;
80104530:	31 ff                	xor    %edi,%edi
}
80104532:	5b                   	pop    %ebx
80104533:	5e                   	pop    %esi
80104534:	89 f8                	mov    %edi,%eax
80104536:	5f                   	pop    %edi
80104537:	5d                   	pop    %ebp
80104538:	c3                   	ret
80104539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      pte_t *pgtab = (pte_t *)P2V(PTE_ADDR(pgdir[i]));
80104540:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80104546:	8d 81 00 00 00 80    	lea    -0x80000000(%ecx),%eax
      for (int j = 0; j < NPTENTRIES; j++)
8010454c:	81 e9 00 f0 ff 7f    	sub    $0x7ffff000,%ecx
80104552:	eb 0b                	jmp    8010455f <get_victim_page+0x4f>
80104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104558:	83 c0 04             	add    $0x4,%eax
8010455b:	39 c1                	cmp    %eax,%ecx
8010455d:	74 ca                	je     80104529 <get_victim_page+0x19>
        if ((pgtab[j] & PTE_P) && (pgtab[j] & PTE_U) && !(pgtab[j] & PTE_A))
8010455f:	8b 10                	mov    (%eax),%edx
80104561:	89 c7                	mov    %eax,%edi
80104563:	83 e2 25             	and    $0x25,%edx
80104566:	83 fa 05             	cmp    $0x5,%edx
80104569:	75 ed                	jne    80104558 <get_victim_page+0x48>
}
8010456b:	5b                   	pop    %ebx
8010456c:	89 f8                	mov    %edi,%eax
8010456e:	5e                   	pop    %esi
8010456f:	5f                   	pop    %edi
80104570:	5d                   	pop    %ebp
80104571:	c3                   	ret
80104572:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104580 <flush_table>:

void flush_table(struct proc * p){
80104580:	55                   	push   %ebp
  pde_t * pgdir = p->pgdir;
  int ctr = 0;
80104581:	31 d2                	xor    %edx,%edx
void flush_table(struct proc * p){
80104583:	89 e5                	mov    %esp,%ebp
80104585:	57                   	push   %edi
   for(int j = 0 ; j < NPTENTRIES; j++){
     if((pgtable[j] & PTE_P) && (pgtable[j] & PTE_U)){
       if(ctr == 0){
         pgtable[j] &= ~PTE_A;
       }
       ctr = (ctr + 1) % 10;
80104586:	bf 67 66 66 66       	mov    $0x66666667,%edi
void flush_table(struct proc * p){
8010458b:	56                   	push   %esi
8010458c:	53                   	push   %ebx
8010458d:	83 ec 08             	sub    $0x8,%esp
80104590:	8b 45 08             	mov    0x8(%ebp),%eax
80104593:	8b 58 08             	mov    0x8(%eax),%ebx
80104596:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010459c:	eb 09                	jmp    801045a7 <flush_table+0x27>
8010459e:	66 90                	xchg   %ax,%ax
  for(int i = 0 ; i < NPDENTRIES; i++){
801045a0:	83 c3 04             	add    $0x4,%ebx
801045a3:	39 c3                	cmp    %eax,%ebx
801045a5:	74 72                	je     80104619 <flush_table+0x99>
   if(!(pgdir[i] & PTE_P)){
801045a7:	8b 33                	mov    (%ebx),%esi
801045a9:	f7 c6 01 00 00 00    	test   $0x1,%esi
801045af:	74 ef                	je     801045a0 <flush_table+0x20>
   pte_t * pgtable = (pte_t*) P2V(PTE_ADDR(pgdir[i]));
801045b1:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801045b7:	89 5d f0             	mov    %ebx,-0x10(%ebp)
801045ba:	8d 8e 00 00 00 80    	lea    -0x80000000(%esi),%ecx
   for(int j = 0 ; j < NPTENTRIES; j++){
801045c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
801045c3:	81 ee 00 f0 ff 7f    	sub    $0x7ffff000,%esi
801045c9:	eb 0c                	jmp    801045d7 <flush_table+0x57>
801045cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045cf:	90                   	nop
801045d0:	83 c1 04             	add    $0x4,%ecx
801045d3:	39 f1                	cmp    %esi,%ecx
801045d5:	74 35                	je     8010460c <flush_table+0x8c>
     if((pgtable[j] & PTE_P) && (pgtable[j] & PTE_U)){
801045d7:	8b 01                	mov    (%ecx),%eax
801045d9:	89 c3                	mov    %eax,%ebx
801045db:	f7 d3                	not    %ebx
801045dd:	83 e3 05             	and    $0x5,%ebx
801045e0:	75 ee                	jne    801045d0 <flush_table+0x50>
       if(ctr == 0){
801045e2:	85 d2                	test   %edx,%edx
801045e4:	75 05                	jne    801045eb <flush_table+0x6b>
         pgtable[j] &= ~PTE_A;
801045e6:	83 e0 df             	and    $0xffffffdf,%eax
801045e9:	89 01                	mov    %eax,(%ecx)
       ctr = (ctr + 1) % 10;
801045eb:	8d 5a 01             	lea    0x1(%edx),%ebx
   for(int j = 0 ; j < NPTENTRIES; j++){
801045ee:	83 c1 04             	add    $0x4,%ecx
       ctr = (ctr + 1) % 10;
801045f1:	89 d8                	mov    %ebx,%eax
801045f3:	f7 ef                	imul   %edi
801045f5:	89 d8                	mov    %ebx,%eax
801045f7:	c1 f8 1f             	sar    $0x1f,%eax
801045fa:	c1 fa 02             	sar    $0x2,%edx
801045fd:	29 c2                	sub    %eax,%edx
801045ff:	8d 04 92             	lea    (%edx,%edx,4),%eax
80104602:	89 da                	mov    %ebx,%edx
80104604:	01 c0                	add    %eax,%eax
80104606:	29 c2                	sub    %eax,%edx
   for(int j = 0 ; j < NPTENTRIES; j++){
80104608:	39 f1                	cmp    %esi,%ecx
8010460a:	75 cb                	jne    801045d7 <flush_table+0x57>
8010460c:	8b 5d f0             	mov    -0x10(%ebp),%ebx
8010460f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  for(int i = 0 ; i < NPDENTRIES; i++){
80104612:	83 c3 04             	add    $0x4,%ebx
80104615:	39 c3                	cmp    %eax,%ebx
80104617:	75 8e                	jne    801045a7 <flush_table+0x27>
        //                         }
        //                         ctr = (ctr + 1) % 10;
        //                 }
        //         }

}
80104619:	83 c4 08             	add    $0x8,%esp
8010461c:	5b                   	pop    %ebx
8010461d:	5e                   	pop    %esi
8010461e:	5f                   	pop    %edi
8010461f:	5d                   	pop    %ebp
80104620:	c3                   	ret
80104621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010462f:	90                   	nop

80104630 <final_page>:

pte_t* final_page(){
80104630:	55                   	push   %ebp
  uint max_rss = 0;
80104631:	31 c9                	xor    %ecx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104633:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
pte_t* final_page(){
80104638:	89 e5                	mov    %esp,%ebp
8010463a:	53                   	push   %ebx
  struct proc * v = 0;
8010463b:	31 db                	xor    %ebx,%ebx
pte_t* final_page(){
8010463d:	83 ec 04             	sub    $0x4,%esp
80104640:	eb 14                	jmp    80104656 <final_page+0x26>
80104642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if (p->rss == max_rss){
80104648:	39 ca                	cmp    %ecx,%edx
8010464a:	74 54                	je     801046a0 <final_page+0x70>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010464c:	83 e8 80             	sub    $0xffffff80,%eax
8010464f:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104654:	74 15                	je     8010466b <final_page+0x3b>
    if(p->rss > max_rss){
80104656:	8b 50 04             	mov    0x4(%eax),%edx
80104659:	39 d1                	cmp    %edx,%ecx
8010465b:	73 eb                	jae    80104648 <final_page+0x18>
      v = p;
8010465d:	89 c3                	mov    %eax,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010465f:	83 e8 80             	sub    $0xffffff80,%eax
      max_rss = p->rss;
80104662:	89 d1                	mov    %edx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104664:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104669:	75 eb                	jne    80104656 <final_page+0x26>
  struct proc * v = get_victim_process();
  pte_t* pte = get_victim_page(v);
8010466b:	83 ec 0c             	sub    $0xc,%esp
8010466e:	53                   	push   %ebx
8010466f:	e8 9c fe ff ff       	call   80104510 <get_victim_page>
80104674:	83 c4 10             	add    $0x10,%esp
  while(pte == 0){
80104677:	85 c0                	test   %eax,%eax
80104679:	75 1d                	jne    80104698 <final_page+0x68>
8010467b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010467f:	90                   	nop
    flush_table(v);
80104680:	83 ec 0c             	sub    $0xc,%esp
80104683:	53                   	push   %ebx
80104684:	e8 f7 fe ff ff       	call   80104580 <flush_table>
    pte = get_victim_page(v);
80104689:	89 1c 24             	mov    %ebx,(%esp)
8010468c:	e8 7f fe ff ff       	call   80104510 <get_victim_page>
80104691:	83 c4 10             	add    $0x10,%esp
  while(pte == 0){
80104694:	85 c0                	test   %eax,%eax
80104696:	74 e8                	je     80104680 <final_page+0x50>
    // if(pte == 0){
      // cprintf("Flusing again\n");
    // }
  }
  return pte;
}
80104698:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010469b:	c9                   	leave
8010469c:	c3                   	ret
8010469d:	8d 76 00             	lea    0x0(%esi),%esi
        if(v == 0){
801046a0:	85 db                	test   %ebx,%ebx
801046a2:	74 0c                	je     801046b0 <final_page+0x80>
          v = p;
801046a4:	8b 53 14             	mov    0x14(%ebx),%edx
801046a7:	39 50 14             	cmp    %edx,0x14(%eax)
801046aa:	0f 4c d8             	cmovl  %eax,%ebx
801046ad:	eb 9d                	jmp    8010464c <final_page+0x1c>
801046af:	90                   	nop
          v = p;
801046b0:	89 c3                	mov    %eax,%ebx
801046b2:	eb 98                	jmp    8010464c <final_page+0x1c>
801046b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046bf:	90                   	nop

801046c0 <update_rss>:
void update_rss(int pid, int increment){
801046c0:	55                   	push   %ebp
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046c1:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
void update_rss(int pid, int increment){
801046c6:	89 e5                	mov    %esp,%ebp
801046c8:	8b 55 08             	mov    0x8(%ebp),%edx
801046cb:	eb 0d                	jmp    801046da <update_rss+0x1a>
801046cd:	8d 76 00             	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046d0:	83 e8 80             	sub    $0xffffff80,%eax
801046d3:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
801046d8:	74 0b                	je     801046e5 <update_rss+0x25>
  {
    if (p->pid == pid)
801046da:	39 50 14             	cmp    %edx,0x14(%eax)
801046dd:	75 f1                	jne    801046d0 <update_rss+0x10>
    {
      p->rss += increment;
801046df:	8b 55 0c             	mov    0xc(%ebp),%edx
801046e2:	01 50 04             	add    %edx,0x4(%eax)
      return;
    }
  }
801046e5:	5d                   	pop    %ebp
801046e6:	c3                   	ret
801046e7:	66 90                	xchg   %ax,%ax
801046e9:	66 90                	xchg   %ax,%ax
801046eb:	66 90                	xchg   %ax,%ax
801046ed:	66 90                	xchg   %ax,%ax
801046ef:	90                   	nop

801046f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
801046f4:	83 ec 0c             	sub    $0xc,%esp
801046f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801046fa:	68 45 86 10 80       	push   $0x80108645
801046ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104702:	50                   	push   %eax
80104703:	e8 18 01 00 00       	call   80104820 <initlock>
  lk->name = name;
80104708:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010470b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104711:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104714:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010471b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010471e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104721:	c9                   	leave
80104722:	c3                   	ret
80104723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010472a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104730 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	56                   	push   %esi
80104734:	53                   	push   %ebx
80104735:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104738:	8d 73 04             	lea    0x4(%ebx),%esi
8010473b:	83 ec 0c             	sub    $0xc,%esp
8010473e:	56                   	push   %esi
8010473f:	e8 cc 02 00 00       	call   80104a10 <acquire>
  while (lk->locked) {
80104744:	8b 13                	mov    (%ebx),%edx
80104746:	83 c4 10             	add    $0x10,%esp
80104749:	85 d2                	test   %edx,%edx
8010474b:	74 16                	je     80104763 <acquiresleep+0x33>
8010474d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104750:	83 ec 08             	sub    $0x8,%esp
80104753:	56                   	push   %esi
80104754:	53                   	push   %ebx
80104755:	e8 f6 fa ff ff       	call   80104250 <sleep>
  while (lk->locked) {
8010475a:	8b 03                	mov    (%ebx),%eax
8010475c:	83 c4 10             	add    $0x10,%esp
8010475f:	85 c0                	test   %eax,%eax
80104761:	75 ed                	jne    80104750 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104763:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104769:	e8 a2 f3 ff ff       	call   80103b10 <myproc>
8010476e:	8b 40 14             	mov    0x14(%eax),%eax
80104771:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104774:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104777:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010477a:	5b                   	pop    %ebx
8010477b:	5e                   	pop    %esi
8010477c:	5d                   	pop    %ebp
  release(&lk->lk);
8010477d:	e9 2e 02 00 00       	jmp    801049b0 <release>
80104782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104790 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
80104795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104798:	8d 73 04             	lea    0x4(%ebx),%esi
8010479b:	83 ec 0c             	sub    $0xc,%esp
8010479e:	56                   	push   %esi
8010479f:	e8 6c 02 00 00       	call   80104a10 <acquire>
  lk->locked = 0;
801047a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801047aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801047b1:	89 1c 24             	mov    %ebx,(%esp)
801047b4:	e8 57 fb ff ff       	call   80104310 <wakeup>
  release(&lk->lk);
801047b9:	89 75 08             	mov    %esi,0x8(%ebp)
801047bc:	83 c4 10             	add    $0x10,%esp
}
801047bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047c2:	5b                   	pop    %ebx
801047c3:	5e                   	pop    %esi
801047c4:	5d                   	pop    %ebp
  release(&lk->lk);
801047c5:	e9 e6 01 00 00       	jmp    801049b0 <release>
801047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	57                   	push   %edi
801047d4:	31 ff                	xor    %edi,%edi
801047d6:	56                   	push   %esi
801047d7:	53                   	push   %ebx
801047d8:	83 ec 18             	sub    $0x18,%esp
801047db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801047de:	8d 73 04             	lea    0x4(%ebx),%esi
801047e1:	56                   	push   %esi
801047e2:	e8 29 02 00 00       	call   80104a10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801047e7:	8b 03                	mov    (%ebx),%eax
801047e9:	83 c4 10             	add    $0x10,%esp
801047ec:	85 c0                	test   %eax,%eax
801047ee:	75 18                	jne    80104808 <holdingsleep+0x38>
  release(&lk->lk);
801047f0:	83 ec 0c             	sub    $0xc,%esp
801047f3:	56                   	push   %esi
801047f4:	e8 b7 01 00 00       	call   801049b0 <release>
  return r;
}
801047f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047fc:	89 f8                	mov    %edi,%eax
801047fe:	5b                   	pop    %ebx
801047ff:	5e                   	pop    %esi
80104800:	5f                   	pop    %edi
80104801:	5d                   	pop    %ebp
80104802:	c3                   	ret
80104803:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104807:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104808:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010480b:	e8 00 f3 ff ff       	call   80103b10 <myproc>
80104810:	39 58 14             	cmp    %ebx,0x14(%eax)
80104813:	0f 94 c0             	sete   %al
80104816:	0f b6 c0             	movzbl %al,%eax
80104819:	89 c7                	mov    %eax,%edi
8010481b:	eb d3                	jmp    801047f0 <holdingsleep+0x20>
8010481d:	66 90                	xchg   %ax,%ax
8010481f:	90                   	nop

80104820 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104826:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104829:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010482f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104832:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104839:	5d                   	pop    %ebp
8010483a:	c3                   	ret
8010483b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010483f:	90                   	nop

80104840 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	53                   	push   %ebx
80104844:	8b 45 08             	mov    0x8(%ebp),%eax
80104847:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010484a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010484d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104852:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104857:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010485c:	76 10                	jbe    8010486e <getcallerpcs+0x2e>
8010485e:	eb 28                	jmp    80104888 <getcallerpcs+0x48>
80104860:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104866:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010486c:	77 1a                	ja     80104888 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010486e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104871:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104874:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104877:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104879:	83 f8 0a             	cmp    $0xa,%eax
8010487c:	75 e2                	jne    80104860 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010487e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104881:	c9                   	leave
80104882:	c3                   	ret
80104883:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104887:	90                   	nop
80104888:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010488b:	83 c1 28             	add    $0x28,%ecx
8010488e:	89 ca                	mov    %ecx,%edx
80104890:	29 c2                	sub    %eax,%edx
80104892:	83 e2 04             	and    $0x4,%edx
80104895:	74 11                	je     801048a8 <getcallerpcs+0x68>
    pcs[i] = 0;
80104897:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010489d:	83 c0 04             	add    $0x4,%eax
801048a0:	39 c1                	cmp    %eax,%ecx
801048a2:	74 da                	je     8010487e <getcallerpcs+0x3e>
801048a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801048a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801048ae:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801048b1:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801048b8:	39 c1                	cmp    %eax,%ecx
801048ba:	75 ec                	jne    801048a8 <getcallerpcs+0x68>
801048bc:	eb c0                	jmp    8010487e <getcallerpcs+0x3e>
801048be:	66 90                	xchg   %ax,%ax

801048c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	53                   	push   %ebx
801048c4:	83 ec 04             	sub    $0x4,%esp
801048c7:	9c                   	pushf
801048c8:	5b                   	pop    %ebx
  asm volatile("cli");
801048c9:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801048ca:	e8 d1 f1 ff ff       	call   80103aa0 <mycpu>
801048cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801048d5:	85 c0                	test   %eax,%eax
801048d7:	74 17                	je     801048f0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801048d9:	e8 c2 f1 ff ff       	call   80103aa0 <mycpu>
801048de:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801048e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048e8:	c9                   	leave
801048e9:	c3                   	ret
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801048f0:	e8 ab f1 ff ff       	call   80103aa0 <mycpu>
801048f5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801048fb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104901:	eb d6                	jmp    801048d9 <pushcli+0x19>
80104903:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010490a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104910 <popcli>:

void
popcli(void)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104916:	9c                   	pushf
80104917:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104918:	f6 c4 02             	test   $0x2,%ah
8010491b:	75 35                	jne    80104952 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010491d:	e8 7e f1 ff ff       	call   80103aa0 <mycpu>
80104922:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104929:	78 34                	js     8010495f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010492b:	e8 70 f1 ff ff       	call   80103aa0 <mycpu>
80104930:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104936:	85 d2                	test   %edx,%edx
80104938:	74 06                	je     80104940 <popcli+0x30>
    sti();
}
8010493a:	c9                   	leave
8010493b:	c3                   	ret
8010493c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104940:	e8 5b f1 ff ff       	call   80103aa0 <mycpu>
80104945:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010494b:	85 c0                	test   %eax,%eax
8010494d:	74 eb                	je     8010493a <popcli+0x2a>
  asm volatile("sti");
8010494f:	fb                   	sti
}
80104950:	c9                   	leave
80104951:	c3                   	ret
    panic("popcli - interruptible");
80104952:	83 ec 0c             	sub    $0xc,%esp
80104955:	68 50 86 10 80       	push   $0x80108650
8010495a:	e8 11 bb ff ff       	call   80100470 <panic>
    panic("popcli");
8010495f:	83 ec 0c             	sub    $0xc,%esp
80104962:	68 67 86 10 80       	push   $0x80108667
80104967:	e8 04 bb ff ff       	call   80100470 <panic>
8010496c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104970 <holding>:
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	56                   	push   %esi
80104974:	53                   	push   %ebx
80104975:	8b 75 08             	mov    0x8(%ebp),%esi
80104978:	31 db                	xor    %ebx,%ebx
  pushcli();
8010497a:	e8 41 ff ff ff       	call   801048c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010497f:	8b 06                	mov    (%esi),%eax
80104981:	85 c0                	test   %eax,%eax
80104983:	75 0b                	jne    80104990 <holding+0x20>
  popcli();
80104985:	e8 86 ff ff ff       	call   80104910 <popcli>
}
8010498a:	89 d8                	mov    %ebx,%eax
8010498c:	5b                   	pop    %ebx
8010498d:	5e                   	pop    %esi
8010498e:	5d                   	pop    %ebp
8010498f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104990:	8b 5e 08             	mov    0x8(%esi),%ebx
80104993:	e8 08 f1 ff ff       	call   80103aa0 <mycpu>
80104998:	39 c3                	cmp    %eax,%ebx
8010499a:	0f 94 c3             	sete   %bl
  popcli();
8010499d:	e8 6e ff ff ff       	call   80104910 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801049a2:	0f b6 db             	movzbl %bl,%ebx
}
801049a5:	89 d8                	mov    %ebx,%eax
801049a7:	5b                   	pop    %ebx
801049a8:	5e                   	pop    %esi
801049a9:	5d                   	pop    %ebp
801049aa:	c3                   	ret
801049ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049af:	90                   	nop

801049b0 <release>:
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	53                   	push   %ebx
801049b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801049b8:	e8 03 ff ff ff       	call   801048c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801049bd:	8b 03                	mov    (%ebx),%eax
801049bf:	85 c0                	test   %eax,%eax
801049c1:	75 15                	jne    801049d8 <release+0x28>
  popcli();
801049c3:	e8 48 ff ff ff       	call   80104910 <popcli>
    panic("release");
801049c8:	83 ec 0c             	sub    $0xc,%esp
801049cb:	68 6e 86 10 80       	push   $0x8010866e
801049d0:	e8 9b ba ff ff       	call   80100470 <panic>
801049d5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801049d8:	8b 73 08             	mov    0x8(%ebx),%esi
801049db:	e8 c0 f0 ff ff       	call   80103aa0 <mycpu>
801049e0:	39 c6                	cmp    %eax,%esi
801049e2:	75 df                	jne    801049c3 <release+0x13>
  popcli();
801049e4:	e8 27 ff ff ff       	call   80104910 <popcli>
  lk->pcs[0] = 0;
801049e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801049f0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801049f7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801049fc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a05:	5b                   	pop    %ebx
80104a06:	5e                   	pop    %esi
80104a07:	5d                   	pop    %ebp
  popcli();
80104a08:	e9 03 ff ff ff       	jmp    80104910 <popcli>
80104a0d:	8d 76 00             	lea    0x0(%esi),%esi

80104a10 <acquire>:
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	53                   	push   %ebx
80104a14:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104a17:	e8 a4 fe ff ff       	call   801048c0 <pushcli>
  if(holding(lk))
80104a1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104a1f:	e8 9c fe ff ff       	call   801048c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a24:	8b 03                	mov    (%ebx),%eax
80104a26:	85 c0                	test   %eax,%eax
80104a28:	0f 85 b2 00 00 00    	jne    80104ae0 <acquire+0xd0>
  popcli();
80104a2e:	e8 dd fe ff ff       	call   80104910 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104a33:	b9 01 00 00 00       	mov    $0x1,%ecx
80104a38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3f:	90                   	nop
  while(xchg(&lk->locked, 1) != 0)
80104a40:	8b 55 08             	mov    0x8(%ebp),%edx
80104a43:	89 c8                	mov    %ecx,%eax
80104a45:	f0 87 02             	lock xchg %eax,(%edx)
80104a48:	85 c0                	test   %eax,%eax
80104a4a:	75 f4                	jne    80104a40 <acquire+0x30>
  __sync_synchronize();
80104a4c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104a51:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a54:	e8 47 f0 ff ff       	call   80103aa0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104a59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
80104a5c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
80104a5e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a61:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104a67:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80104a6c:	77 32                	ja     80104aa0 <acquire+0x90>
  ebp = (uint*)v - 2;
80104a6e:	89 e8                	mov    %ebp,%eax
80104a70:	eb 14                	jmp    80104a86 <acquire+0x76>
80104a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a78:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a7e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a84:	77 1a                	ja     80104aa0 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104a86:	8b 58 04             	mov    0x4(%eax),%ebx
80104a89:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104a8d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104a90:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a92:	83 fa 0a             	cmp    $0xa,%edx
80104a95:	75 e1                	jne    80104a78 <acquire+0x68>
}
80104a97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a9a:	c9                   	leave
80104a9b:	c3                   	ret
80104a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aa0:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104aa4:	83 c1 34             	add    $0x34,%ecx
80104aa7:	89 ca                	mov    %ecx,%edx
80104aa9:	29 c2                	sub    %eax,%edx
80104aab:	83 e2 04             	and    $0x4,%edx
80104aae:	74 10                	je     80104ac0 <acquire+0xb0>
    pcs[i] = 0;
80104ab0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ab6:	83 c0 04             	add    $0x4,%eax
80104ab9:	39 c1                	cmp    %eax,%ecx
80104abb:	74 da                	je     80104a97 <acquire+0x87>
80104abd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104ac0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ac6:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104ac9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104ad0:	39 c1                	cmp    %eax,%ecx
80104ad2:	75 ec                	jne    80104ac0 <acquire+0xb0>
80104ad4:	eb c1                	jmp    80104a97 <acquire+0x87>
80104ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104add:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104ae0:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104ae3:	e8 b8 ef ff ff       	call   80103aa0 <mycpu>
80104ae8:	39 c3                	cmp    %eax,%ebx
80104aea:	0f 85 3e ff ff ff    	jne    80104a2e <acquire+0x1e>
  popcli();
80104af0:	e8 1b fe ff ff       	call   80104910 <popcli>
    panic("acquire");
80104af5:	83 ec 0c             	sub    $0xc,%esp
80104af8:	68 76 86 10 80       	push   $0x80108676
80104afd:	e8 6e b9 ff ff       	call   80100470 <panic>
80104b02:	66 90                	xchg   %ax,%ax
80104b04:	66 90                	xchg   %ax,%ax
80104b06:	66 90                	xchg   %ax,%ax
80104b08:	66 90                	xchg   %ax,%ax
80104b0a:	66 90                	xchg   %ax,%ax
80104b0c:	66 90                	xchg   %ax,%ax
80104b0e:	66 90                	xchg   %ax,%ax

80104b10 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	57                   	push   %edi
80104b14:	8b 55 08             	mov    0x8(%ebp),%edx
80104b17:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104b1a:	89 d0                	mov    %edx,%eax
80104b1c:	09 c8                	or     %ecx,%eax
80104b1e:	a8 03                	test   $0x3,%al
80104b20:	75 1e                	jne    80104b40 <memset+0x30>
    c &= 0xFF;
80104b22:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104b26:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104b29:	89 d7                	mov    %edx,%edi
80104b2b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104b31:	fc                   	cld
80104b32:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104b34:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104b37:	89 d0                	mov    %edx,%eax
80104b39:	c9                   	leave
80104b3a:	c3                   	ret
80104b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b3f:	90                   	nop
  asm volatile("cld; rep stosb" :
80104b40:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b43:	89 d7                	mov    %edx,%edi
80104b45:	fc                   	cld
80104b46:	f3 aa                	rep stos %al,%es:(%edi)
80104b48:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104b4b:	89 d0                	mov    %edx,%eax
80104b4d:	c9                   	leave
80104b4e:	c3                   	ret
80104b4f:	90                   	nop

80104b50 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	56                   	push   %esi
80104b54:	8b 75 10             	mov    0x10(%ebp),%esi
80104b57:	8b 45 08             	mov    0x8(%ebp),%eax
80104b5a:	53                   	push   %ebx
80104b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104b5e:	85 f6                	test   %esi,%esi
80104b60:	74 2e                	je     80104b90 <memcmp+0x40>
80104b62:	01 c6                	add    %eax,%esi
80104b64:	eb 14                	jmp    80104b7a <memcmp+0x2a>
80104b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104b70:	83 c0 01             	add    $0x1,%eax
80104b73:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104b76:	39 f0                	cmp    %esi,%eax
80104b78:	74 16                	je     80104b90 <memcmp+0x40>
    if(*s1 != *s2)
80104b7a:	0f b6 08             	movzbl (%eax),%ecx
80104b7d:	0f b6 1a             	movzbl (%edx),%ebx
80104b80:	38 d9                	cmp    %bl,%cl
80104b82:	74 ec                	je     80104b70 <memcmp+0x20>
      return *s1 - *s2;
80104b84:	0f b6 c1             	movzbl %cl,%eax
80104b87:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104b89:	5b                   	pop    %ebx
80104b8a:	5e                   	pop    %esi
80104b8b:	5d                   	pop    %ebp
80104b8c:	c3                   	ret
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi
80104b90:	5b                   	pop    %ebx
  return 0;
80104b91:	31 c0                	xor    %eax,%eax
}
80104b93:	5e                   	pop    %esi
80104b94:	5d                   	pop    %ebp
80104b95:	c3                   	ret
80104b96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b9d:	8d 76 00             	lea    0x0(%esi),%esi

80104ba0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	57                   	push   %edi
80104ba4:	8b 55 08             	mov    0x8(%ebp),%edx
80104ba7:	8b 45 10             	mov    0x10(%ebp),%eax
80104baa:	56                   	push   %esi
80104bab:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104bae:	39 d6                	cmp    %edx,%esi
80104bb0:	73 26                	jae    80104bd8 <memmove+0x38>
80104bb2:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104bb5:	39 ca                	cmp    %ecx,%edx
80104bb7:	73 1f                	jae    80104bd8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104bb9:	85 c0                	test   %eax,%eax
80104bbb:	74 0f                	je     80104bcc <memmove+0x2c>
80104bbd:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104bc0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104bc4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104bc7:	83 e8 01             	sub    $0x1,%eax
80104bca:	73 f4                	jae    80104bc0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104bcc:	5e                   	pop    %esi
80104bcd:	89 d0                	mov    %edx,%eax
80104bcf:	5f                   	pop    %edi
80104bd0:	5d                   	pop    %ebp
80104bd1:	c3                   	ret
80104bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104bd8:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104bdb:	89 d7                	mov    %edx,%edi
80104bdd:	85 c0                	test   %eax,%eax
80104bdf:	74 eb                	je     80104bcc <memmove+0x2c>
80104be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104be8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104be9:	39 ce                	cmp    %ecx,%esi
80104beb:	75 fb                	jne    80104be8 <memmove+0x48>
}
80104bed:	5e                   	pop    %esi
80104bee:	89 d0                	mov    %edx,%eax
80104bf0:	5f                   	pop    %edi
80104bf1:	5d                   	pop    %ebp
80104bf2:	c3                   	ret
80104bf3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c00 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104c00:	eb 9e                	jmp    80104ba0 <memmove>
80104c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c10 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	53                   	push   %ebx
80104c14:	8b 55 10             	mov    0x10(%ebp),%edx
80104c17:	8b 45 08             	mov    0x8(%ebp),%eax
80104c1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
80104c1d:	85 d2                	test   %edx,%edx
80104c1f:	75 16                	jne    80104c37 <strncmp+0x27>
80104c21:	eb 2d                	jmp    80104c50 <strncmp+0x40>
80104c23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c27:	90                   	nop
80104c28:	3a 19                	cmp    (%ecx),%bl
80104c2a:	75 12                	jne    80104c3e <strncmp+0x2e>
    n--, p++, q++;
80104c2c:	83 c0 01             	add    $0x1,%eax
80104c2f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104c32:	83 ea 01             	sub    $0x1,%edx
80104c35:	74 19                	je     80104c50 <strncmp+0x40>
80104c37:	0f b6 18             	movzbl (%eax),%ebx
80104c3a:	84 db                	test   %bl,%bl
80104c3c:	75 ea                	jne    80104c28 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104c3e:	0f b6 00             	movzbl (%eax),%eax
80104c41:	0f b6 11             	movzbl (%ecx),%edx
}
80104c44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c47:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104c48:	29 d0                	sub    %edx,%eax
}
80104c4a:	c3                   	ret
80104c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c4f:	90                   	nop
80104c50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104c53:	31 c0                	xor    %eax,%eax
}
80104c55:	c9                   	leave
80104c56:	c3                   	ret
80104c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5e:	66 90                	xchg   %ax,%ax

80104c60 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	57                   	push   %edi
80104c64:	56                   	push   %esi
80104c65:	8b 75 08             	mov    0x8(%ebp),%esi
80104c68:	53                   	push   %ebx
80104c69:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104c6c:	89 f0                	mov    %esi,%eax
80104c6e:	eb 15                	jmp    80104c85 <strncpy+0x25>
80104c70:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104c74:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104c77:	83 c0 01             	add    $0x1,%eax
80104c7a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80104c7e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104c81:	84 c9                	test   %cl,%cl
80104c83:	74 13                	je     80104c98 <strncpy+0x38>
80104c85:	89 d3                	mov    %edx,%ebx
80104c87:	83 ea 01             	sub    $0x1,%edx
80104c8a:	85 db                	test   %ebx,%ebx
80104c8c:	7f e2                	jg     80104c70 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104c8e:	5b                   	pop    %ebx
80104c8f:	89 f0                	mov    %esi,%eax
80104c91:	5e                   	pop    %esi
80104c92:	5f                   	pop    %edi
80104c93:	5d                   	pop    %ebp
80104c94:	c3                   	ret
80104c95:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104c98:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104c9b:	83 e9 01             	sub    $0x1,%ecx
80104c9e:	85 d2                	test   %edx,%edx
80104ca0:	74 ec                	je     80104c8e <strncpy+0x2e>
80104ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104ca8:	83 c0 01             	add    $0x1,%eax
80104cab:	89 ca                	mov    %ecx,%edx
80104cad:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104cb1:	29 c2                	sub    %eax,%edx
80104cb3:	85 d2                	test   %edx,%edx
80104cb5:	7f f1                	jg     80104ca8 <strncpy+0x48>
}
80104cb7:	5b                   	pop    %ebx
80104cb8:	89 f0                	mov    %esi,%eax
80104cba:	5e                   	pop    %esi
80104cbb:	5f                   	pop    %edi
80104cbc:	5d                   	pop    %ebp
80104cbd:	c3                   	ret
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	56                   	push   %esi
80104cc4:	8b 55 10             	mov    0x10(%ebp),%edx
80104cc7:	8b 75 08             	mov    0x8(%ebp),%esi
80104cca:	53                   	push   %ebx
80104ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104cce:	85 d2                	test   %edx,%edx
80104cd0:	7e 25                	jle    80104cf7 <safestrcpy+0x37>
80104cd2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104cd6:	89 f2                	mov    %esi,%edx
80104cd8:	eb 16                	jmp    80104cf0 <safestrcpy+0x30>
80104cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ce0:	0f b6 08             	movzbl (%eax),%ecx
80104ce3:	83 c0 01             	add    $0x1,%eax
80104ce6:	83 c2 01             	add    $0x1,%edx
80104ce9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104cec:	84 c9                	test   %cl,%cl
80104cee:	74 04                	je     80104cf4 <safestrcpy+0x34>
80104cf0:	39 d8                	cmp    %ebx,%eax
80104cf2:	75 ec                	jne    80104ce0 <safestrcpy+0x20>
    ;
  *s = 0;
80104cf4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104cf7:	89 f0                	mov    %esi,%eax
80104cf9:	5b                   	pop    %ebx
80104cfa:	5e                   	pop    %esi
80104cfb:	5d                   	pop    %ebp
80104cfc:	c3                   	ret
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi

80104d00 <strlen>:

int
strlen(const char *s)
{
80104d00:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104d01:	31 c0                	xor    %eax,%eax
{
80104d03:	89 e5                	mov    %esp,%ebp
80104d05:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104d08:	80 3a 00             	cmpb   $0x0,(%edx)
80104d0b:	74 0c                	je     80104d19 <strlen+0x19>
80104d0d:	8d 76 00             	lea    0x0(%esi),%esi
80104d10:	83 c0 01             	add    $0x1,%eax
80104d13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104d17:	75 f7                	jne    80104d10 <strlen+0x10>
    ;
  return n;
}
80104d19:	5d                   	pop    %ebp
80104d1a:	c3                   	ret

80104d1b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104d1b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104d1f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104d23:	55                   	push   %ebp
  pushl %ebx
80104d24:	53                   	push   %ebx
  pushl %esi
80104d25:	56                   	push   %esi
  pushl %edi
80104d26:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104d27:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104d29:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104d2b:	5f                   	pop    %edi
  popl %esi
80104d2c:	5e                   	pop    %esi
  popl %ebx
80104d2d:	5b                   	pop    %ebx
  popl %ebp
80104d2e:	5d                   	pop    %ebp
  ret
80104d2f:	c3                   	ret

80104d30 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	53                   	push   %ebx
80104d34:	83 ec 04             	sub    $0x4,%esp
80104d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104d3a:	e8 d1 ed ff ff       	call   80103b10 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d3f:	8b 00                	mov    (%eax),%eax
80104d41:	39 c3                	cmp    %eax,%ebx
80104d43:	73 1b                	jae    80104d60 <fetchint+0x30>
80104d45:	8d 53 04             	lea    0x4(%ebx),%edx
80104d48:	39 d0                	cmp    %edx,%eax
80104d4a:	72 14                	jb     80104d60 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d4f:	8b 13                	mov    (%ebx),%edx
80104d51:	89 10                	mov    %edx,(%eax)
  return 0;
80104d53:	31 c0                	xor    %eax,%eax
}
80104d55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d58:	c9                   	leave
80104d59:	c3                   	ret
80104d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d65:	eb ee                	jmp    80104d55 <fetchint+0x25>
80104d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d6e:	66 90                	xchg   %ax,%ax

80104d70 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	53                   	push   %ebx
80104d74:	83 ec 04             	sub    $0x4,%esp
80104d77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104d7a:	e8 91 ed ff ff       	call   80103b10 <myproc>

  if(addr >= curproc->sz)
80104d7f:	3b 18                	cmp    (%eax),%ebx
80104d81:	73 2d                	jae    80104db0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104d83:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d86:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104d88:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104d8a:	39 d3                	cmp    %edx,%ebx
80104d8c:	73 22                	jae    80104db0 <fetchstr+0x40>
80104d8e:	89 d8                	mov    %ebx,%eax
80104d90:	eb 0d                	jmp    80104d9f <fetchstr+0x2f>
80104d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d98:	83 c0 01             	add    $0x1,%eax
80104d9b:	39 d0                	cmp    %edx,%eax
80104d9d:	73 11                	jae    80104db0 <fetchstr+0x40>
    if(*s == 0)
80104d9f:	80 38 00             	cmpb   $0x0,(%eax)
80104da2:	75 f4                	jne    80104d98 <fetchstr+0x28>
      return s - *pp;
80104da4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104da6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104da9:	c9                   	leave
80104daa:	c3                   	ret
80104dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104daf:	90                   	nop
80104db0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104db3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104db8:	c9                   	leave
80104db9:	c3                   	ret
80104dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104dc0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	56                   	push   %esi
80104dc4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104dc5:	e8 46 ed ff ff       	call   80103b10 <myproc>
80104dca:	8b 55 08             	mov    0x8(%ebp),%edx
80104dcd:	8b 40 1c             	mov    0x1c(%eax),%eax
80104dd0:	8b 40 44             	mov    0x44(%eax),%eax
80104dd3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104dd6:	e8 35 ed ff ff       	call   80103b10 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ddb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dde:	8b 00                	mov    (%eax),%eax
80104de0:	39 c6                	cmp    %eax,%esi
80104de2:	73 1c                	jae    80104e00 <argint+0x40>
80104de4:	8d 53 08             	lea    0x8(%ebx),%edx
80104de7:	39 d0                	cmp    %edx,%eax
80104de9:	72 15                	jb     80104e00 <argint+0x40>
  *ip = *(int*)(addr);
80104deb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dee:	8b 53 04             	mov    0x4(%ebx),%edx
80104df1:	89 10                	mov    %edx,(%eax)
  return 0;
80104df3:	31 c0                	xor    %eax,%eax
}
80104df5:	5b                   	pop    %ebx
80104df6:	5e                   	pop    %esi
80104df7:	5d                   	pop    %ebp
80104df8:	c3                   	ret
80104df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e05:	eb ee                	jmp    80104df5 <argint+0x35>
80104e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0e:	66 90                	xchg   %ax,%ax

80104e10 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	57                   	push   %edi
80104e14:	56                   	push   %esi
80104e15:	53                   	push   %ebx
80104e16:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104e19:	e8 f2 ec ff ff       	call   80103b10 <myproc>
80104e1e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e20:	e8 eb ec ff ff       	call   80103b10 <myproc>
80104e25:	8b 55 08             	mov    0x8(%ebp),%edx
80104e28:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e2b:	8b 40 44             	mov    0x44(%eax),%eax
80104e2e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104e31:	e8 da ec ff ff       	call   80103b10 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e36:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e39:	8b 00                	mov    (%eax),%eax
80104e3b:	39 c7                	cmp    %eax,%edi
80104e3d:	73 31                	jae    80104e70 <argptr+0x60>
80104e3f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104e42:	39 c8                	cmp    %ecx,%eax
80104e44:	72 2a                	jb     80104e70 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104e46:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104e49:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104e4c:	85 d2                	test   %edx,%edx
80104e4e:	78 20                	js     80104e70 <argptr+0x60>
80104e50:	8b 16                	mov    (%esi),%edx
80104e52:	39 d0                	cmp    %edx,%eax
80104e54:	73 1a                	jae    80104e70 <argptr+0x60>
80104e56:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104e59:	01 c3                	add    %eax,%ebx
80104e5b:	39 da                	cmp    %ebx,%edx
80104e5d:	72 11                	jb     80104e70 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104e5f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e62:	89 02                	mov    %eax,(%edx)
  return 0;
80104e64:	31 c0                	xor    %eax,%eax
}
80104e66:	83 c4 0c             	add    $0xc,%esp
80104e69:	5b                   	pop    %ebx
80104e6a:	5e                   	pop    %esi
80104e6b:	5f                   	pop    %edi
80104e6c:	5d                   	pop    %ebp
80104e6d:	c3                   	ret
80104e6e:	66 90                	xchg   %ax,%ax
    return -1;
80104e70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e75:	eb ef                	jmp    80104e66 <argptr+0x56>
80104e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e7e:	66 90                	xchg   %ax,%ax

80104e80 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	56                   	push   %esi
80104e84:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e85:	e8 86 ec ff ff       	call   80103b10 <myproc>
80104e8a:	8b 55 08             	mov    0x8(%ebp),%edx
80104e8d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e90:	8b 40 44             	mov    0x44(%eax),%eax
80104e93:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104e96:	e8 75 ec ff ff       	call   80103b10 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e9b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e9e:	8b 00                	mov    (%eax),%eax
80104ea0:	39 c6                	cmp    %eax,%esi
80104ea2:	73 44                	jae    80104ee8 <argstr+0x68>
80104ea4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ea7:	39 d0                	cmp    %edx,%eax
80104ea9:	72 3d                	jb     80104ee8 <argstr+0x68>
  *ip = *(int*)(addr);
80104eab:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104eae:	e8 5d ec ff ff       	call   80103b10 <myproc>
  if(addr >= curproc->sz)
80104eb3:	3b 18                	cmp    (%eax),%ebx
80104eb5:	73 31                	jae    80104ee8 <argstr+0x68>
  *pp = (char*)addr;
80104eb7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104eba:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104ebc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104ebe:	39 d3                	cmp    %edx,%ebx
80104ec0:	73 26                	jae    80104ee8 <argstr+0x68>
80104ec2:	89 d8                	mov    %ebx,%eax
80104ec4:	eb 11                	jmp    80104ed7 <argstr+0x57>
80104ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ecd:	8d 76 00             	lea    0x0(%esi),%esi
80104ed0:	83 c0 01             	add    $0x1,%eax
80104ed3:	39 d0                	cmp    %edx,%eax
80104ed5:	73 11                	jae    80104ee8 <argstr+0x68>
    if(*s == 0)
80104ed7:	80 38 00             	cmpb   $0x0,(%eax)
80104eda:	75 f4                	jne    80104ed0 <argstr+0x50>
      return s - *pp;
80104edc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104ede:	5b                   	pop    %ebx
80104edf:	5e                   	pop    %esi
80104ee0:	5d                   	pop    %ebp
80104ee1:	c3                   	ret
80104ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ee8:	5b                   	pop    %ebx
    return -1;
80104ee9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eee:	5e                   	pop    %esi
80104eef:	5d                   	pop    %ebp
80104ef0:	c3                   	ret
80104ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eff:	90                   	nop

80104f00 <syscall>:
[SYS_getNumFreePages]   sys_getNumFreePages,
};

void
syscall(void)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	53                   	push   %ebx
80104f04:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104f07:	e8 04 ec ff ff       	call   80103b10 <myproc>
80104f0c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f0e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104f11:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f14:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f17:	83 fa 16             	cmp    $0x16,%edx
80104f1a:	77 24                	ja     80104f40 <syscall+0x40>
80104f1c:	8b 14 85 00 8d 10 80 	mov    -0x7fef7300(,%eax,4),%edx
80104f23:	85 d2                	test   %edx,%edx
80104f25:	74 19                	je     80104f40 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104f27:	ff d2                	call   *%edx
80104f29:	89 c2                	mov    %eax,%edx
80104f2b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104f2e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104f31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f34:	c9                   	leave
80104f35:	c3                   	ret
80104f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104f40:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104f41:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104f44:	50                   	push   %eax
80104f45:	ff 73 14             	push   0x14(%ebx)
80104f48:	68 7e 86 10 80       	push   $0x8010867e
80104f4d:	e8 4e b8 ff ff       	call   801007a0 <cprintf>
    curproc->tf->eax = -1;
80104f52:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104f55:	83 c4 10             	add    $0x10,%esp
80104f58:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104f5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f62:	c9                   	leave
80104f63:	c3                   	ret
80104f64:	66 90                	xchg   %ax,%ax
80104f66:	66 90                	xchg   %ax,%ax
80104f68:	66 90                	xchg   %ax,%ax
80104f6a:	66 90                	xchg   %ax,%ax
80104f6c:	66 90                	xchg   %ax,%ax
80104f6e:	66 90                	xchg   %ax,%ax

80104f70 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	57                   	push   %edi
80104f74:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104f75:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104f78:	53                   	push   %ebx
80104f79:	83 ec 34             	sub    $0x34,%esp
80104f7c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104f7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f82:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104f85:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104f88:	57                   	push   %edi
80104f89:	50                   	push   %eax
80104f8a:	e8 01 d2 ff ff       	call   80102190 <nameiparent>
80104f8f:	83 c4 10             	add    $0x10,%esp
80104f92:	85 c0                	test   %eax,%eax
80104f94:	74 5e                	je     80104ff4 <create+0x84>
    return 0;
  ilock(dp);
80104f96:	83 ec 0c             	sub    $0xc,%esp
80104f99:	89 c3                	mov    %eax,%ebx
80104f9b:	50                   	push   %eax
80104f9c:	e8 ef c8 ff ff       	call   80101890 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104fa1:	83 c4 0c             	add    $0xc,%esp
80104fa4:	6a 00                	push   $0x0
80104fa6:	57                   	push   %edi
80104fa7:	53                   	push   %ebx
80104fa8:	e8 33 ce ff ff       	call   80101de0 <dirlookup>
80104fad:	83 c4 10             	add    $0x10,%esp
80104fb0:	89 c6                	mov    %eax,%esi
80104fb2:	85 c0                	test   %eax,%eax
80104fb4:	74 4a                	je     80105000 <create+0x90>
    iunlockput(dp);
80104fb6:	83 ec 0c             	sub    $0xc,%esp
80104fb9:	53                   	push   %ebx
80104fba:	e8 61 cb ff ff       	call   80101b20 <iunlockput>
    ilock(ip);
80104fbf:	89 34 24             	mov    %esi,(%esp)
80104fc2:	e8 c9 c8 ff ff       	call   80101890 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104fc7:	83 c4 10             	add    $0x10,%esp
80104fca:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104fcf:	75 17                	jne    80104fe8 <create+0x78>
80104fd1:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104fd6:	75 10                	jne    80104fe8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fdb:	89 f0                	mov    %esi,%eax
80104fdd:	5b                   	pop    %ebx
80104fde:	5e                   	pop    %esi
80104fdf:	5f                   	pop    %edi
80104fe0:	5d                   	pop    %ebp
80104fe1:	c3                   	ret
80104fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104fe8:	83 ec 0c             	sub    $0xc,%esp
80104feb:	56                   	push   %esi
80104fec:	e8 2f cb ff ff       	call   80101b20 <iunlockput>
    return 0;
80104ff1:	83 c4 10             	add    $0x10,%esp
}
80104ff4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104ff7:	31 f6                	xor    %esi,%esi
}
80104ff9:	5b                   	pop    %ebx
80104ffa:	89 f0                	mov    %esi,%eax
80104ffc:	5e                   	pop    %esi
80104ffd:	5f                   	pop    %edi
80104ffe:	5d                   	pop    %ebp
80104fff:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80105000:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105004:	83 ec 08             	sub    $0x8,%esp
80105007:	50                   	push   %eax
80105008:	ff 33                	push   (%ebx)
8010500a:	e8 11 c7 ff ff       	call   80101720 <ialloc>
8010500f:	83 c4 10             	add    $0x10,%esp
80105012:	89 c6                	mov    %eax,%esi
80105014:	85 c0                	test   %eax,%eax
80105016:	0f 84 bc 00 00 00    	je     801050d8 <create+0x168>
  ilock(ip);
8010501c:	83 ec 0c             	sub    $0xc,%esp
8010501f:	50                   	push   %eax
80105020:	e8 6b c8 ff ff       	call   80101890 <ilock>
  ip->major = major;
80105025:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105029:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010502d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105031:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105035:	b8 01 00 00 00       	mov    $0x1,%eax
8010503a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010503e:	89 34 24             	mov    %esi,(%esp)
80105041:	e8 9a c7 ff ff       	call   801017e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105046:	83 c4 10             	add    $0x10,%esp
80105049:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010504e:	74 30                	je     80105080 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80105050:	83 ec 04             	sub    $0x4,%esp
80105053:	ff 76 04             	push   0x4(%esi)
80105056:	57                   	push   %edi
80105057:	53                   	push   %ebx
80105058:	e8 53 d0 ff ff       	call   801020b0 <dirlink>
8010505d:	83 c4 10             	add    $0x10,%esp
80105060:	85 c0                	test   %eax,%eax
80105062:	78 67                	js     801050cb <create+0x15b>
  iunlockput(dp);
80105064:	83 ec 0c             	sub    $0xc,%esp
80105067:	53                   	push   %ebx
80105068:	e8 b3 ca ff ff       	call   80101b20 <iunlockput>
  return ip;
8010506d:	83 c4 10             	add    $0x10,%esp
}
80105070:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105073:	89 f0                	mov    %esi,%eax
80105075:	5b                   	pop    %ebx
80105076:	5e                   	pop    %esi
80105077:	5f                   	pop    %edi
80105078:	5d                   	pop    %ebp
80105079:	c3                   	ret
8010507a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105080:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105083:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105088:	53                   	push   %ebx
80105089:	e8 52 c7 ff ff       	call   801017e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010508e:	83 c4 0c             	add    $0xc,%esp
80105091:	ff 76 04             	push   0x4(%esi)
80105094:	68 b6 86 10 80       	push   $0x801086b6
80105099:	56                   	push   %esi
8010509a:	e8 11 d0 ff ff       	call   801020b0 <dirlink>
8010509f:	83 c4 10             	add    $0x10,%esp
801050a2:	85 c0                	test   %eax,%eax
801050a4:	78 18                	js     801050be <create+0x14e>
801050a6:	83 ec 04             	sub    $0x4,%esp
801050a9:	ff 73 04             	push   0x4(%ebx)
801050ac:	68 b5 86 10 80       	push   $0x801086b5
801050b1:	56                   	push   %esi
801050b2:	e8 f9 cf ff ff       	call   801020b0 <dirlink>
801050b7:	83 c4 10             	add    $0x10,%esp
801050ba:	85 c0                	test   %eax,%eax
801050bc:	79 92                	jns    80105050 <create+0xe0>
      panic("create dots");
801050be:	83 ec 0c             	sub    $0xc,%esp
801050c1:	68 a9 86 10 80       	push   $0x801086a9
801050c6:	e8 a5 b3 ff ff       	call   80100470 <panic>
    panic("create: dirlink");
801050cb:	83 ec 0c             	sub    $0xc,%esp
801050ce:	68 b8 86 10 80       	push   $0x801086b8
801050d3:	e8 98 b3 ff ff       	call   80100470 <panic>
    panic("create: ialloc");
801050d8:	83 ec 0c             	sub    $0xc,%esp
801050db:	68 9a 86 10 80       	push   $0x8010869a
801050e0:	e8 8b b3 ff ff       	call   80100470 <panic>
801050e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050f0 <sys_dup>:
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	56                   	push   %esi
801050f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801050f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050fb:	50                   	push   %eax
801050fc:	6a 00                	push   $0x0
801050fe:	e8 bd fc ff ff       	call   80104dc0 <argint>
80105103:	83 c4 10             	add    $0x10,%esp
80105106:	85 c0                	test   %eax,%eax
80105108:	78 36                	js     80105140 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010510a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010510e:	77 30                	ja     80105140 <sys_dup+0x50>
80105110:	e8 fb e9 ff ff       	call   80103b10 <myproc>
80105115:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105118:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010511c:	85 f6                	test   %esi,%esi
8010511e:	74 20                	je     80105140 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105120:	e8 eb e9 ff ff       	call   80103b10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105125:	31 db                	xor    %ebx,%ebx
80105127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010512e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105130:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105134:	85 d2                	test   %edx,%edx
80105136:	74 18                	je     80105150 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105138:	83 c3 01             	add    $0x1,%ebx
8010513b:	83 fb 10             	cmp    $0x10,%ebx
8010513e:	75 f0                	jne    80105130 <sys_dup+0x40>
}
80105140:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105143:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105148:	89 d8                	mov    %ebx,%eax
8010514a:	5b                   	pop    %ebx
8010514b:	5e                   	pop    %esi
8010514c:	5d                   	pop    %ebp
8010514d:	c3                   	ret
8010514e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105150:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105153:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
80105157:	56                   	push   %esi
80105158:	e8 53 be ff ff       	call   80100fb0 <filedup>
  return fd;
8010515d:	83 c4 10             	add    $0x10,%esp
}
80105160:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105163:	89 d8                	mov    %ebx,%eax
80105165:	5b                   	pop    %ebx
80105166:	5e                   	pop    %esi
80105167:	5d                   	pop    %ebp
80105168:	c3                   	ret
80105169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105170 <sys_read>:
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	56                   	push   %esi
80105174:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105175:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105178:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010517b:	53                   	push   %ebx
8010517c:	6a 00                	push   $0x0
8010517e:	e8 3d fc ff ff       	call   80104dc0 <argint>
80105183:	83 c4 10             	add    $0x10,%esp
80105186:	85 c0                	test   %eax,%eax
80105188:	78 5e                	js     801051e8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010518a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010518e:	77 58                	ja     801051e8 <sys_read+0x78>
80105190:	e8 7b e9 ff ff       	call   80103b10 <myproc>
80105195:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105198:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010519c:	85 f6                	test   %esi,%esi
8010519e:	74 48                	je     801051e8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051a0:	83 ec 08             	sub    $0x8,%esp
801051a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051a6:	50                   	push   %eax
801051a7:	6a 02                	push   $0x2
801051a9:	e8 12 fc ff ff       	call   80104dc0 <argint>
801051ae:	83 c4 10             	add    $0x10,%esp
801051b1:	85 c0                	test   %eax,%eax
801051b3:	78 33                	js     801051e8 <sys_read+0x78>
801051b5:	83 ec 04             	sub    $0x4,%esp
801051b8:	ff 75 f0             	push   -0x10(%ebp)
801051bb:	53                   	push   %ebx
801051bc:	6a 01                	push   $0x1
801051be:	e8 4d fc ff ff       	call   80104e10 <argptr>
801051c3:	83 c4 10             	add    $0x10,%esp
801051c6:	85 c0                	test   %eax,%eax
801051c8:	78 1e                	js     801051e8 <sys_read+0x78>
  return fileread(f, p, n);
801051ca:	83 ec 04             	sub    $0x4,%esp
801051cd:	ff 75 f0             	push   -0x10(%ebp)
801051d0:	ff 75 f4             	push   -0xc(%ebp)
801051d3:	56                   	push   %esi
801051d4:	e8 57 bf ff ff       	call   80101130 <fileread>
801051d9:	83 c4 10             	add    $0x10,%esp
}
801051dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051df:	5b                   	pop    %ebx
801051e0:	5e                   	pop    %esi
801051e1:	5d                   	pop    %ebp
801051e2:	c3                   	ret
801051e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051e7:	90                   	nop
    return -1;
801051e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ed:	eb ed                	jmp    801051dc <sys_read+0x6c>
801051ef:	90                   	nop

801051f0 <sys_write>:
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	56                   	push   %esi
801051f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801051f5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801051f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051fb:	53                   	push   %ebx
801051fc:	6a 00                	push   $0x0
801051fe:	e8 bd fb ff ff       	call   80104dc0 <argint>
80105203:	83 c4 10             	add    $0x10,%esp
80105206:	85 c0                	test   %eax,%eax
80105208:	78 5e                	js     80105268 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010520a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010520e:	77 58                	ja     80105268 <sys_write+0x78>
80105210:	e8 fb e8 ff ff       	call   80103b10 <myproc>
80105215:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105218:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010521c:	85 f6                	test   %esi,%esi
8010521e:	74 48                	je     80105268 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105220:	83 ec 08             	sub    $0x8,%esp
80105223:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105226:	50                   	push   %eax
80105227:	6a 02                	push   $0x2
80105229:	e8 92 fb ff ff       	call   80104dc0 <argint>
8010522e:	83 c4 10             	add    $0x10,%esp
80105231:	85 c0                	test   %eax,%eax
80105233:	78 33                	js     80105268 <sys_write+0x78>
80105235:	83 ec 04             	sub    $0x4,%esp
80105238:	ff 75 f0             	push   -0x10(%ebp)
8010523b:	53                   	push   %ebx
8010523c:	6a 01                	push   $0x1
8010523e:	e8 cd fb ff ff       	call   80104e10 <argptr>
80105243:	83 c4 10             	add    $0x10,%esp
80105246:	85 c0                	test   %eax,%eax
80105248:	78 1e                	js     80105268 <sys_write+0x78>
  return filewrite(f, p, n);
8010524a:	83 ec 04             	sub    $0x4,%esp
8010524d:	ff 75 f0             	push   -0x10(%ebp)
80105250:	ff 75 f4             	push   -0xc(%ebp)
80105253:	56                   	push   %esi
80105254:	e8 67 bf ff ff       	call   801011c0 <filewrite>
80105259:	83 c4 10             	add    $0x10,%esp
}
8010525c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010525f:	5b                   	pop    %ebx
80105260:	5e                   	pop    %esi
80105261:	5d                   	pop    %ebp
80105262:	c3                   	ret
80105263:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105267:	90                   	nop
    return -1;
80105268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010526d:	eb ed                	jmp    8010525c <sys_write+0x6c>
8010526f:	90                   	nop

80105270 <sys_close>:
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	56                   	push   %esi
80105274:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105275:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105278:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010527b:	50                   	push   %eax
8010527c:	6a 00                	push   $0x0
8010527e:	e8 3d fb ff ff       	call   80104dc0 <argint>
80105283:	83 c4 10             	add    $0x10,%esp
80105286:	85 c0                	test   %eax,%eax
80105288:	78 3e                	js     801052c8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010528a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010528e:	77 38                	ja     801052c8 <sys_close+0x58>
80105290:	e8 7b e8 ff ff       	call   80103b10 <myproc>
80105295:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105298:	8d 5a 08             	lea    0x8(%edx),%ebx
8010529b:	8b 74 98 0c          	mov    0xc(%eax,%ebx,4),%esi
8010529f:	85 f6                	test   %esi,%esi
801052a1:	74 25                	je     801052c8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801052a3:	e8 68 e8 ff ff       	call   80103b10 <myproc>
  fileclose(f);
801052a8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801052ab:	c7 44 98 0c 00 00 00 	movl   $0x0,0xc(%eax,%ebx,4)
801052b2:	00 
  fileclose(f);
801052b3:	56                   	push   %esi
801052b4:	e8 47 bd ff ff       	call   80101000 <fileclose>
  return 0;
801052b9:	83 c4 10             	add    $0x10,%esp
801052bc:	31 c0                	xor    %eax,%eax
}
801052be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052c1:	5b                   	pop    %ebx
801052c2:	5e                   	pop    %esi
801052c3:	5d                   	pop    %ebp
801052c4:	c3                   	ret
801052c5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052cd:	eb ef                	jmp    801052be <sys_close+0x4e>
801052cf:	90                   	nop

801052d0 <sys_fstat>:
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	56                   	push   %esi
801052d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801052d5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801052d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801052db:	53                   	push   %ebx
801052dc:	6a 00                	push   $0x0
801052de:	e8 dd fa ff ff       	call   80104dc0 <argint>
801052e3:	83 c4 10             	add    $0x10,%esp
801052e6:	85 c0                	test   %eax,%eax
801052e8:	78 46                	js     80105330 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801052ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052ee:	77 40                	ja     80105330 <sys_fstat+0x60>
801052f0:	e8 1b e8 ff ff       	call   80103b10 <myproc>
801052f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052f8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
801052fc:	85 f6                	test   %esi,%esi
801052fe:	74 30                	je     80105330 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105300:	83 ec 04             	sub    $0x4,%esp
80105303:	6a 14                	push   $0x14
80105305:	53                   	push   %ebx
80105306:	6a 01                	push   $0x1
80105308:	e8 03 fb ff ff       	call   80104e10 <argptr>
8010530d:	83 c4 10             	add    $0x10,%esp
80105310:	85 c0                	test   %eax,%eax
80105312:	78 1c                	js     80105330 <sys_fstat+0x60>
  return filestat(f, st);
80105314:	83 ec 08             	sub    $0x8,%esp
80105317:	ff 75 f4             	push   -0xc(%ebp)
8010531a:	56                   	push   %esi
8010531b:	e8 c0 bd ff ff       	call   801010e0 <filestat>
80105320:	83 c4 10             	add    $0x10,%esp
}
80105323:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105326:	5b                   	pop    %ebx
80105327:	5e                   	pop    %esi
80105328:	5d                   	pop    %ebp
80105329:	c3                   	ret
8010532a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105335:	eb ec                	jmp    80105323 <sys_fstat+0x53>
80105337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010533e:	66 90                	xchg   %ax,%ax

80105340 <sys_link>:
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	57                   	push   %edi
80105344:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105345:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105348:	53                   	push   %ebx
80105349:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010534c:	50                   	push   %eax
8010534d:	6a 00                	push   $0x0
8010534f:	e8 2c fb ff ff       	call   80104e80 <argstr>
80105354:	83 c4 10             	add    $0x10,%esp
80105357:	85 c0                	test   %eax,%eax
80105359:	0f 88 fb 00 00 00    	js     8010545a <sys_link+0x11a>
8010535f:	83 ec 08             	sub    $0x8,%esp
80105362:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105365:	50                   	push   %eax
80105366:	6a 01                	push   $0x1
80105368:	e8 13 fb ff ff       	call   80104e80 <argstr>
8010536d:	83 c4 10             	add    $0x10,%esp
80105370:	85 c0                	test   %eax,%eax
80105372:	0f 88 e2 00 00 00    	js     8010545a <sys_link+0x11a>
  begin_op();
80105378:	e8 83 db ff ff       	call   80102f00 <begin_op>
  if((ip = namei(old)) == 0){
8010537d:	83 ec 0c             	sub    $0xc,%esp
80105380:	ff 75 d4             	push   -0x2c(%ebp)
80105383:	e8 e8 cd ff ff       	call   80102170 <namei>
80105388:	83 c4 10             	add    $0x10,%esp
8010538b:	89 c3                	mov    %eax,%ebx
8010538d:	85 c0                	test   %eax,%eax
8010538f:	0f 84 df 00 00 00    	je     80105474 <sys_link+0x134>
  ilock(ip);
80105395:	83 ec 0c             	sub    $0xc,%esp
80105398:	50                   	push   %eax
80105399:	e8 f2 c4 ff ff       	call   80101890 <ilock>
  if(ip->type == T_DIR){
8010539e:	83 c4 10             	add    $0x10,%esp
801053a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053a6:	0f 84 b5 00 00 00    	je     80105461 <sys_link+0x121>
  iupdate(ip);
801053ac:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801053af:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801053b4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801053b7:	53                   	push   %ebx
801053b8:	e8 23 c4 ff ff       	call   801017e0 <iupdate>
  iunlock(ip);
801053bd:	89 1c 24             	mov    %ebx,(%esp)
801053c0:	e8 ab c5 ff ff       	call   80101970 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801053c5:	58                   	pop    %eax
801053c6:	5a                   	pop    %edx
801053c7:	57                   	push   %edi
801053c8:	ff 75 d0             	push   -0x30(%ebp)
801053cb:	e8 c0 cd ff ff       	call   80102190 <nameiparent>
801053d0:	83 c4 10             	add    $0x10,%esp
801053d3:	89 c6                	mov    %eax,%esi
801053d5:	85 c0                	test   %eax,%eax
801053d7:	74 5b                	je     80105434 <sys_link+0xf4>
  ilock(dp);
801053d9:	83 ec 0c             	sub    $0xc,%esp
801053dc:	50                   	push   %eax
801053dd:	e8 ae c4 ff ff       	call   80101890 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801053e2:	8b 03                	mov    (%ebx),%eax
801053e4:	83 c4 10             	add    $0x10,%esp
801053e7:	39 06                	cmp    %eax,(%esi)
801053e9:	75 3d                	jne    80105428 <sys_link+0xe8>
801053eb:	83 ec 04             	sub    $0x4,%esp
801053ee:	ff 73 04             	push   0x4(%ebx)
801053f1:	57                   	push   %edi
801053f2:	56                   	push   %esi
801053f3:	e8 b8 cc ff ff       	call   801020b0 <dirlink>
801053f8:	83 c4 10             	add    $0x10,%esp
801053fb:	85 c0                	test   %eax,%eax
801053fd:	78 29                	js     80105428 <sys_link+0xe8>
  iunlockput(dp);
801053ff:	83 ec 0c             	sub    $0xc,%esp
80105402:	56                   	push   %esi
80105403:	e8 18 c7 ff ff       	call   80101b20 <iunlockput>
  iput(ip);
80105408:	89 1c 24             	mov    %ebx,(%esp)
8010540b:	e8 b0 c5 ff ff       	call   801019c0 <iput>
  end_op();
80105410:	e8 5b db ff ff       	call   80102f70 <end_op>
  return 0;
80105415:	83 c4 10             	add    $0x10,%esp
80105418:	31 c0                	xor    %eax,%eax
}
8010541a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010541d:	5b                   	pop    %ebx
8010541e:	5e                   	pop    %esi
8010541f:	5f                   	pop    %edi
80105420:	5d                   	pop    %ebp
80105421:	c3                   	ret
80105422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105428:	83 ec 0c             	sub    $0xc,%esp
8010542b:	56                   	push   %esi
8010542c:	e8 ef c6 ff ff       	call   80101b20 <iunlockput>
    goto bad;
80105431:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105434:	83 ec 0c             	sub    $0xc,%esp
80105437:	53                   	push   %ebx
80105438:	e8 53 c4 ff ff       	call   80101890 <ilock>
  ip->nlink--;
8010543d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105442:	89 1c 24             	mov    %ebx,(%esp)
80105445:	e8 96 c3 ff ff       	call   801017e0 <iupdate>
  iunlockput(ip);
8010544a:	89 1c 24             	mov    %ebx,(%esp)
8010544d:	e8 ce c6 ff ff       	call   80101b20 <iunlockput>
  end_op();
80105452:	e8 19 db ff ff       	call   80102f70 <end_op>
  return -1;
80105457:	83 c4 10             	add    $0x10,%esp
    return -1;
8010545a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545f:	eb b9                	jmp    8010541a <sys_link+0xda>
    iunlockput(ip);
80105461:	83 ec 0c             	sub    $0xc,%esp
80105464:	53                   	push   %ebx
80105465:	e8 b6 c6 ff ff       	call   80101b20 <iunlockput>
    end_op();
8010546a:	e8 01 db ff ff       	call   80102f70 <end_op>
    return -1;
8010546f:	83 c4 10             	add    $0x10,%esp
80105472:	eb e6                	jmp    8010545a <sys_link+0x11a>
    end_op();
80105474:	e8 f7 da ff ff       	call   80102f70 <end_op>
    return -1;
80105479:	eb df                	jmp    8010545a <sys_link+0x11a>
8010547b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010547f:	90                   	nop

80105480 <sys_unlink>:
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	57                   	push   %edi
80105484:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105485:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105488:	53                   	push   %ebx
80105489:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010548c:	50                   	push   %eax
8010548d:	6a 00                	push   $0x0
8010548f:	e8 ec f9 ff ff       	call   80104e80 <argstr>
80105494:	83 c4 10             	add    $0x10,%esp
80105497:	85 c0                	test   %eax,%eax
80105499:	0f 88 54 01 00 00    	js     801055f3 <sys_unlink+0x173>
  begin_op();
8010549f:	e8 5c da ff ff       	call   80102f00 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801054a4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801054a7:	83 ec 08             	sub    $0x8,%esp
801054aa:	53                   	push   %ebx
801054ab:	ff 75 c0             	push   -0x40(%ebp)
801054ae:	e8 dd cc ff ff       	call   80102190 <nameiparent>
801054b3:	83 c4 10             	add    $0x10,%esp
801054b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801054b9:	85 c0                	test   %eax,%eax
801054bb:	0f 84 58 01 00 00    	je     80105619 <sys_unlink+0x199>
  ilock(dp);
801054c1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801054c4:	83 ec 0c             	sub    $0xc,%esp
801054c7:	57                   	push   %edi
801054c8:	e8 c3 c3 ff ff       	call   80101890 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801054cd:	58                   	pop    %eax
801054ce:	5a                   	pop    %edx
801054cf:	68 b6 86 10 80       	push   $0x801086b6
801054d4:	53                   	push   %ebx
801054d5:	e8 e6 c8 ff ff       	call   80101dc0 <namecmp>
801054da:	83 c4 10             	add    $0x10,%esp
801054dd:	85 c0                	test   %eax,%eax
801054df:	0f 84 fb 00 00 00    	je     801055e0 <sys_unlink+0x160>
801054e5:	83 ec 08             	sub    $0x8,%esp
801054e8:	68 b5 86 10 80       	push   $0x801086b5
801054ed:	53                   	push   %ebx
801054ee:	e8 cd c8 ff ff       	call   80101dc0 <namecmp>
801054f3:	83 c4 10             	add    $0x10,%esp
801054f6:	85 c0                	test   %eax,%eax
801054f8:	0f 84 e2 00 00 00    	je     801055e0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801054fe:	83 ec 04             	sub    $0x4,%esp
80105501:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105504:	50                   	push   %eax
80105505:	53                   	push   %ebx
80105506:	57                   	push   %edi
80105507:	e8 d4 c8 ff ff       	call   80101de0 <dirlookup>
8010550c:	83 c4 10             	add    $0x10,%esp
8010550f:	89 c3                	mov    %eax,%ebx
80105511:	85 c0                	test   %eax,%eax
80105513:	0f 84 c7 00 00 00    	je     801055e0 <sys_unlink+0x160>
  ilock(ip);
80105519:	83 ec 0c             	sub    $0xc,%esp
8010551c:	50                   	push   %eax
8010551d:	e8 6e c3 ff ff       	call   80101890 <ilock>
  if(ip->nlink < 1)
80105522:	83 c4 10             	add    $0x10,%esp
80105525:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010552a:	0f 8e 0a 01 00 00    	jle    8010563a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105530:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105535:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105538:	74 66                	je     801055a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010553a:	83 ec 04             	sub    $0x4,%esp
8010553d:	6a 10                	push   $0x10
8010553f:	6a 00                	push   $0x0
80105541:	57                   	push   %edi
80105542:	e8 c9 f5 ff ff       	call   80104b10 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105547:	6a 10                	push   $0x10
80105549:	ff 75 c4             	push   -0x3c(%ebp)
8010554c:	57                   	push   %edi
8010554d:	ff 75 b4             	push   -0x4c(%ebp)
80105550:	e8 4b c7 ff ff       	call   80101ca0 <writei>
80105555:	83 c4 20             	add    $0x20,%esp
80105558:	83 f8 10             	cmp    $0x10,%eax
8010555b:	0f 85 cc 00 00 00    	jne    8010562d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105561:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105566:	0f 84 94 00 00 00    	je     80105600 <sys_unlink+0x180>
  iunlockput(dp);
8010556c:	83 ec 0c             	sub    $0xc,%esp
8010556f:	ff 75 b4             	push   -0x4c(%ebp)
80105572:	e8 a9 c5 ff ff       	call   80101b20 <iunlockput>
  ip->nlink--;
80105577:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010557c:	89 1c 24             	mov    %ebx,(%esp)
8010557f:	e8 5c c2 ff ff       	call   801017e0 <iupdate>
  iunlockput(ip);
80105584:	89 1c 24             	mov    %ebx,(%esp)
80105587:	e8 94 c5 ff ff       	call   80101b20 <iunlockput>
  end_op();
8010558c:	e8 df d9 ff ff       	call   80102f70 <end_op>
  return 0;
80105591:	83 c4 10             	add    $0x10,%esp
80105594:	31 c0                	xor    %eax,%eax
}
80105596:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105599:	5b                   	pop    %ebx
8010559a:	5e                   	pop    %esi
8010559b:	5f                   	pop    %edi
8010559c:	5d                   	pop    %ebp
8010559d:	c3                   	ret
8010559e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801055a0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801055a4:	76 94                	jbe    8010553a <sys_unlink+0xba>
801055a6:	be 20 00 00 00       	mov    $0x20,%esi
801055ab:	eb 0b                	jmp    801055b8 <sys_unlink+0x138>
801055ad:	8d 76 00             	lea    0x0(%esi),%esi
801055b0:	83 c6 10             	add    $0x10,%esi
801055b3:	3b 73 58             	cmp    0x58(%ebx),%esi
801055b6:	73 82                	jae    8010553a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055b8:	6a 10                	push   $0x10
801055ba:	56                   	push   %esi
801055bb:	57                   	push   %edi
801055bc:	53                   	push   %ebx
801055bd:	e8 de c5 ff ff       	call   80101ba0 <readi>
801055c2:	83 c4 10             	add    $0x10,%esp
801055c5:	83 f8 10             	cmp    $0x10,%eax
801055c8:	75 56                	jne    80105620 <sys_unlink+0x1a0>
    if(de.inum != 0)
801055ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801055cf:	74 df                	je     801055b0 <sys_unlink+0x130>
    iunlockput(ip);
801055d1:	83 ec 0c             	sub    $0xc,%esp
801055d4:	53                   	push   %ebx
801055d5:	e8 46 c5 ff ff       	call   80101b20 <iunlockput>
    goto bad;
801055da:	83 c4 10             	add    $0x10,%esp
801055dd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801055e0:	83 ec 0c             	sub    $0xc,%esp
801055e3:	ff 75 b4             	push   -0x4c(%ebp)
801055e6:	e8 35 c5 ff ff       	call   80101b20 <iunlockput>
  end_op();
801055eb:	e8 80 d9 ff ff       	call   80102f70 <end_op>
  return -1;
801055f0:	83 c4 10             	add    $0x10,%esp
    return -1;
801055f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055f8:	eb 9c                	jmp    80105596 <sys_unlink+0x116>
801055fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105600:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105603:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105606:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010560b:	50                   	push   %eax
8010560c:	e8 cf c1 ff ff       	call   801017e0 <iupdate>
80105611:	83 c4 10             	add    $0x10,%esp
80105614:	e9 53 ff ff ff       	jmp    8010556c <sys_unlink+0xec>
    end_op();
80105619:	e8 52 d9 ff ff       	call   80102f70 <end_op>
    return -1;
8010561e:	eb d3                	jmp    801055f3 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105620:	83 ec 0c             	sub    $0xc,%esp
80105623:	68 da 86 10 80       	push   $0x801086da
80105628:	e8 43 ae ff ff       	call   80100470 <panic>
    panic("unlink: writei");
8010562d:	83 ec 0c             	sub    $0xc,%esp
80105630:	68 ec 86 10 80       	push   $0x801086ec
80105635:	e8 36 ae ff ff       	call   80100470 <panic>
    panic("unlink: nlink < 1");
8010563a:	83 ec 0c             	sub    $0xc,%esp
8010563d:	68 c8 86 10 80       	push   $0x801086c8
80105642:	e8 29 ae ff ff       	call   80100470 <panic>
80105647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010564e:	66 90                	xchg   %ax,%ax

80105650 <sys_open>:

int
sys_open(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	57                   	push   %edi
80105654:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105655:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105658:	53                   	push   %ebx
80105659:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010565c:	50                   	push   %eax
8010565d:	6a 00                	push   $0x0
8010565f:	e8 1c f8 ff ff       	call   80104e80 <argstr>
80105664:	83 c4 10             	add    $0x10,%esp
80105667:	85 c0                	test   %eax,%eax
80105669:	0f 88 8e 00 00 00    	js     801056fd <sys_open+0xad>
8010566f:	83 ec 08             	sub    $0x8,%esp
80105672:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105675:	50                   	push   %eax
80105676:	6a 01                	push   $0x1
80105678:	e8 43 f7 ff ff       	call   80104dc0 <argint>
8010567d:	83 c4 10             	add    $0x10,%esp
80105680:	85 c0                	test   %eax,%eax
80105682:	78 79                	js     801056fd <sys_open+0xad>
    return -1;

  begin_op();
80105684:	e8 77 d8 ff ff       	call   80102f00 <begin_op>

  if(omode & O_CREATE){
80105689:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010568d:	75 79                	jne    80105708 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010568f:	83 ec 0c             	sub    $0xc,%esp
80105692:	ff 75 e0             	push   -0x20(%ebp)
80105695:	e8 d6 ca ff ff       	call   80102170 <namei>
8010569a:	83 c4 10             	add    $0x10,%esp
8010569d:	89 c6                	mov    %eax,%esi
8010569f:	85 c0                	test   %eax,%eax
801056a1:	0f 84 7e 00 00 00    	je     80105725 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801056a7:	83 ec 0c             	sub    $0xc,%esp
801056aa:	50                   	push   %eax
801056ab:	e8 e0 c1 ff ff       	call   80101890 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801056b0:	83 c4 10             	add    $0x10,%esp
801056b3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801056b8:	0f 84 ba 00 00 00    	je     80105778 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801056be:	e8 7d b8 ff ff       	call   80100f40 <filealloc>
801056c3:	89 c7                	mov    %eax,%edi
801056c5:	85 c0                	test   %eax,%eax
801056c7:	74 23                	je     801056ec <sys_open+0x9c>
  struct proc *curproc = myproc();
801056c9:	e8 42 e4 ff ff       	call   80103b10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056ce:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801056d0:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
801056d4:	85 d2                	test   %edx,%edx
801056d6:	74 58                	je     80105730 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
801056d8:	83 c3 01             	add    $0x1,%ebx
801056db:	83 fb 10             	cmp    $0x10,%ebx
801056de:	75 f0                	jne    801056d0 <sys_open+0x80>
    if(f)
      fileclose(f);
801056e0:	83 ec 0c             	sub    $0xc,%esp
801056e3:	57                   	push   %edi
801056e4:	e8 17 b9 ff ff       	call   80101000 <fileclose>
801056e9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801056ec:	83 ec 0c             	sub    $0xc,%esp
801056ef:	56                   	push   %esi
801056f0:	e8 2b c4 ff ff       	call   80101b20 <iunlockput>
    end_op();
801056f5:	e8 76 d8 ff ff       	call   80102f70 <end_op>
    return -1;
801056fa:	83 c4 10             	add    $0x10,%esp
    return -1;
801056fd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105702:	eb 65                	jmp    80105769 <sys_open+0x119>
80105704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105708:	83 ec 0c             	sub    $0xc,%esp
8010570b:	31 c9                	xor    %ecx,%ecx
8010570d:	ba 02 00 00 00       	mov    $0x2,%edx
80105712:	6a 00                	push   $0x0
80105714:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105717:	e8 54 f8 ff ff       	call   80104f70 <create>
    if(ip == 0){
8010571c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010571f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105721:	85 c0                	test   %eax,%eax
80105723:	75 99                	jne    801056be <sys_open+0x6e>
      end_op();
80105725:	e8 46 d8 ff ff       	call   80102f70 <end_op>
      return -1;
8010572a:	eb d1                	jmp    801056fd <sys_open+0xad>
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105730:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105733:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
80105737:	56                   	push   %esi
80105738:	e8 33 c2 ff ff       	call   80101970 <iunlock>
  end_op();
8010573d:	e8 2e d8 ff ff       	call   80102f70 <end_op>

  f->type = FD_INODE;
80105742:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105748:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010574b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010574e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105751:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105753:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010575a:	f7 d0                	not    %eax
8010575c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010575f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105762:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105765:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105769:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010576c:	89 d8                	mov    %ebx,%eax
8010576e:	5b                   	pop    %ebx
8010576f:	5e                   	pop    %esi
80105770:	5f                   	pop    %edi
80105771:	5d                   	pop    %ebp
80105772:	c3                   	ret
80105773:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105777:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105778:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010577b:	85 c9                	test   %ecx,%ecx
8010577d:	0f 84 3b ff ff ff    	je     801056be <sys_open+0x6e>
80105783:	e9 64 ff ff ff       	jmp    801056ec <sys_open+0x9c>
80105788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578f:	90                   	nop

80105790 <sys_mkdir>:

int
sys_mkdir(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105796:	e8 65 d7 ff ff       	call   80102f00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010579b:	83 ec 08             	sub    $0x8,%esp
8010579e:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057a1:	50                   	push   %eax
801057a2:	6a 00                	push   $0x0
801057a4:	e8 d7 f6 ff ff       	call   80104e80 <argstr>
801057a9:	83 c4 10             	add    $0x10,%esp
801057ac:	85 c0                	test   %eax,%eax
801057ae:	78 30                	js     801057e0 <sys_mkdir+0x50>
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b6:	31 c9                	xor    %ecx,%ecx
801057b8:	ba 01 00 00 00       	mov    $0x1,%edx
801057bd:	6a 00                	push   $0x0
801057bf:	e8 ac f7 ff ff       	call   80104f70 <create>
801057c4:	83 c4 10             	add    $0x10,%esp
801057c7:	85 c0                	test   %eax,%eax
801057c9:	74 15                	je     801057e0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057cb:	83 ec 0c             	sub    $0xc,%esp
801057ce:	50                   	push   %eax
801057cf:	e8 4c c3 ff ff       	call   80101b20 <iunlockput>
  end_op();
801057d4:	e8 97 d7 ff ff       	call   80102f70 <end_op>
  return 0;
801057d9:	83 c4 10             	add    $0x10,%esp
801057dc:	31 c0                	xor    %eax,%eax
}
801057de:	c9                   	leave
801057df:	c3                   	ret
    end_op();
801057e0:	e8 8b d7 ff ff       	call   80102f70 <end_op>
    return -1;
801057e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057ea:	c9                   	leave
801057eb:	c3                   	ret
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_mknod>:

int
sys_mknod(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801057f6:	e8 05 d7 ff ff       	call   80102f00 <begin_op>
  if((argstr(0, &path)) < 0 ||
801057fb:	83 ec 08             	sub    $0x8,%esp
801057fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105801:	50                   	push   %eax
80105802:	6a 00                	push   $0x0
80105804:	e8 77 f6 ff ff       	call   80104e80 <argstr>
80105809:	83 c4 10             	add    $0x10,%esp
8010580c:	85 c0                	test   %eax,%eax
8010580e:	78 60                	js     80105870 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105810:	83 ec 08             	sub    $0x8,%esp
80105813:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105816:	50                   	push   %eax
80105817:	6a 01                	push   $0x1
80105819:	e8 a2 f5 ff ff       	call   80104dc0 <argint>
  if((argstr(0, &path)) < 0 ||
8010581e:	83 c4 10             	add    $0x10,%esp
80105821:	85 c0                	test   %eax,%eax
80105823:	78 4b                	js     80105870 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105825:	83 ec 08             	sub    $0x8,%esp
80105828:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010582b:	50                   	push   %eax
8010582c:	6a 02                	push   $0x2
8010582e:	e8 8d f5 ff ff       	call   80104dc0 <argint>
     argint(1, &major) < 0 ||
80105833:	83 c4 10             	add    $0x10,%esp
80105836:	85 c0                	test   %eax,%eax
80105838:	78 36                	js     80105870 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010583a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010583e:	83 ec 0c             	sub    $0xc,%esp
80105841:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105845:	ba 03 00 00 00       	mov    $0x3,%edx
8010584a:	50                   	push   %eax
8010584b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010584e:	e8 1d f7 ff ff       	call   80104f70 <create>
     argint(2, &minor) < 0 ||
80105853:	83 c4 10             	add    $0x10,%esp
80105856:	85 c0                	test   %eax,%eax
80105858:	74 16                	je     80105870 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010585a:	83 ec 0c             	sub    $0xc,%esp
8010585d:	50                   	push   %eax
8010585e:	e8 bd c2 ff ff       	call   80101b20 <iunlockput>
  end_op();
80105863:	e8 08 d7 ff ff       	call   80102f70 <end_op>
  return 0;
80105868:	83 c4 10             	add    $0x10,%esp
8010586b:	31 c0                	xor    %eax,%eax
}
8010586d:	c9                   	leave
8010586e:	c3                   	ret
8010586f:	90                   	nop
    end_op();
80105870:	e8 fb d6 ff ff       	call   80102f70 <end_op>
    return -1;
80105875:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010587a:	c9                   	leave
8010587b:	c3                   	ret
8010587c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105880 <sys_chdir>:

int
sys_chdir(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	56                   	push   %esi
80105884:	53                   	push   %ebx
80105885:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105888:	e8 83 e2 ff ff       	call   80103b10 <myproc>
8010588d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010588f:	e8 6c d6 ff ff       	call   80102f00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105894:	83 ec 08             	sub    $0x8,%esp
80105897:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010589a:	50                   	push   %eax
8010589b:	6a 00                	push   $0x0
8010589d:	e8 de f5 ff ff       	call   80104e80 <argstr>
801058a2:	83 c4 10             	add    $0x10,%esp
801058a5:	85 c0                	test   %eax,%eax
801058a7:	78 77                	js     80105920 <sys_chdir+0xa0>
801058a9:	83 ec 0c             	sub    $0xc,%esp
801058ac:	ff 75 f4             	push   -0xc(%ebp)
801058af:	e8 bc c8 ff ff       	call   80102170 <namei>
801058b4:	83 c4 10             	add    $0x10,%esp
801058b7:	89 c3                	mov    %eax,%ebx
801058b9:	85 c0                	test   %eax,%eax
801058bb:	74 63                	je     80105920 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801058bd:	83 ec 0c             	sub    $0xc,%esp
801058c0:	50                   	push   %eax
801058c1:	e8 ca bf ff ff       	call   80101890 <ilock>
  if(ip->type != T_DIR){
801058c6:	83 c4 10             	add    $0x10,%esp
801058c9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058ce:	75 30                	jne    80105900 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801058d0:	83 ec 0c             	sub    $0xc,%esp
801058d3:	53                   	push   %ebx
801058d4:	e8 97 c0 ff ff       	call   80101970 <iunlock>
  iput(curproc->cwd);
801058d9:	58                   	pop    %eax
801058da:	ff 76 6c             	push   0x6c(%esi)
801058dd:	e8 de c0 ff ff       	call   801019c0 <iput>
  end_op();
801058e2:	e8 89 d6 ff ff       	call   80102f70 <end_op>
  curproc->cwd = ip;
801058e7:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
801058ea:	83 c4 10             	add    $0x10,%esp
801058ed:	31 c0                	xor    %eax,%eax
}
801058ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058f2:	5b                   	pop    %ebx
801058f3:	5e                   	pop    %esi
801058f4:	5d                   	pop    %ebp
801058f5:	c3                   	ret
801058f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058fd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105900:	83 ec 0c             	sub    $0xc,%esp
80105903:	53                   	push   %ebx
80105904:	e8 17 c2 ff ff       	call   80101b20 <iunlockput>
    end_op();
80105909:	e8 62 d6 ff ff       	call   80102f70 <end_op>
    return -1;
8010590e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105911:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105916:	eb d7                	jmp    801058ef <sys_chdir+0x6f>
80105918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591f:	90                   	nop
    end_op();
80105920:	e8 4b d6 ff ff       	call   80102f70 <end_op>
    return -1;
80105925:	eb ea                	jmp    80105911 <sys_chdir+0x91>
80105927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010592e:	66 90                	xchg   %ax,%ax

80105930 <sys_exec>:

int
sys_exec(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	57                   	push   %edi
80105934:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105935:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010593b:	53                   	push   %ebx
8010593c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105942:	50                   	push   %eax
80105943:	6a 00                	push   $0x0
80105945:	e8 36 f5 ff ff       	call   80104e80 <argstr>
8010594a:	83 c4 10             	add    $0x10,%esp
8010594d:	85 c0                	test   %eax,%eax
8010594f:	0f 88 87 00 00 00    	js     801059dc <sys_exec+0xac>
80105955:	83 ec 08             	sub    $0x8,%esp
80105958:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010595e:	50                   	push   %eax
8010595f:	6a 01                	push   $0x1
80105961:	e8 5a f4 ff ff       	call   80104dc0 <argint>
80105966:	83 c4 10             	add    $0x10,%esp
80105969:	85 c0                	test   %eax,%eax
8010596b:	78 6f                	js     801059dc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010596d:	83 ec 04             	sub    $0x4,%esp
80105970:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105976:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105978:	68 80 00 00 00       	push   $0x80
8010597d:	6a 00                	push   $0x0
8010597f:	56                   	push   %esi
80105980:	e8 8b f1 ff ff       	call   80104b10 <memset>
80105985:	83 c4 10             	add    $0x10,%esp
80105988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105990:	83 ec 08             	sub    $0x8,%esp
80105993:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105999:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801059a0:	50                   	push   %eax
801059a1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801059a7:	01 f8                	add    %edi,%eax
801059a9:	50                   	push   %eax
801059aa:	e8 81 f3 ff ff       	call   80104d30 <fetchint>
801059af:	83 c4 10             	add    $0x10,%esp
801059b2:	85 c0                	test   %eax,%eax
801059b4:	78 26                	js     801059dc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801059b6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801059bc:	85 c0                	test   %eax,%eax
801059be:	74 30                	je     801059f0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801059c0:	83 ec 08             	sub    $0x8,%esp
801059c3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801059c6:	52                   	push   %edx
801059c7:	50                   	push   %eax
801059c8:	e8 a3 f3 ff ff       	call   80104d70 <fetchstr>
801059cd:	83 c4 10             	add    $0x10,%esp
801059d0:	85 c0                	test   %eax,%eax
801059d2:	78 08                	js     801059dc <sys_exec+0xac>
  for(i=0;; i++){
801059d4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801059d7:	83 fb 20             	cmp    $0x20,%ebx
801059da:	75 b4                	jne    80105990 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801059dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801059df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059e4:	5b                   	pop    %ebx
801059e5:	5e                   	pop    %esi
801059e6:	5f                   	pop    %edi
801059e7:	5d                   	pop    %ebp
801059e8:	c3                   	ret
801059e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801059f0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801059f7:	00 00 00 00 
  return exec(path, argv);
801059fb:	83 ec 08             	sub    $0x8,%esp
801059fe:	56                   	push   %esi
801059ff:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105a05:	e8 96 b1 ff ff       	call   80100ba0 <exec>
80105a0a:	83 c4 10             	add    $0x10,%esp
}
80105a0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a10:	5b                   	pop    %ebx
80105a11:	5e                   	pop    %esi
80105a12:	5f                   	pop    %edi
80105a13:	5d                   	pop    %ebp
80105a14:	c3                   	ret
80105a15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_pipe>:

int
sys_pipe(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	57                   	push   %edi
80105a24:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a25:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105a28:	53                   	push   %ebx
80105a29:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a2c:	6a 08                	push   $0x8
80105a2e:	50                   	push   %eax
80105a2f:	6a 00                	push   $0x0
80105a31:	e8 da f3 ff ff       	call   80104e10 <argptr>
80105a36:	83 c4 10             	add    $0x10,%esp
80105a39:	85 c0                	test   %eax,%eax
80105a3b:	0f 88 8b 00 00 00    	js     80105acc <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105a41:	83 ec 08             	sub    $0x8,%esp
80105a44:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a47:	50                   	push   %eax
80105a48:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105a4b:	50                   	push   %eax
80105a4c:	e8 7f db ff ff       	call   801035d0 <pipealloc>
80105a51:	83 c4 10             	add    $0x10,%esp
80105a54:	85 c0                	test   %eax,%eax
80105a56:	78 74                	js     80105acc <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a58:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105a5b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105a5d:	e8 ae e0 ff ff       	call   80103b10 <myproc>
    if(curproc->ofile[fd] == 0){
80105a62:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105a66:	85 f6                	test   %esi,%esi
80105a68:	74 16                	je     80105a80 <sys_pipe+0x60>
80105a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105a70:	83 c3 01             	add    $0x1,%ebx
80105a73:	83 fb 10             	cmp    $0x10,%ebx
80105a76:	74 3d                	je     80105ab5 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105a78:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105a7c:	85 f6                	test   %esi,%esi
80105a7e:	75 f0                	jne    80105a70 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105a80:	8d 73 08             	lea    0x8(%ebx),%esi
80105a83:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a87:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105a8a:	e8 81 e0 ff ff       	call   80103b10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a8f:	31 d2                	xor    %edx,%edx
80105a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105a98:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
80105a9c:	85 c9                	test   %ecx,%ecx
80105a9e:	74 38                	je     80105ad8 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105aa0:	83 c2 01             	add    $0x1,%edx
80105aa3:	83 fa 10             	cmp    $0x10,%edx
80105aa6:	75 f0                	jne    80105a98 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105aa8:	e8 63 e0 ff ff       	call   80103b10 <myproc>
80105aad:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105ab4:	00 
    fileclose(rf);
80105ab5:	83 ec 0c             	sub    $0xc,%esp
80105ab8:	ff 75 e0             	push   -0x20(%ebp)
80105abb:	e8 40 b5 ff ff       	call   80101000 <fileclose>
    fileclose(wf);
80105ac0:	58                   	pop    %eax
80105ac1:	ff 75 e4             	push   -0x1c(%ebp)
80105ac4:	e8 37 b5 ff ff       	call   80101000 <fileclose>
    return -1;
80105ac9:	83 c4 10             	add    $0x10,%esp
    return -1;
80105acc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ad1:	eb 16                	jmp    80105ae9 <sys_pipe+0xc9>
80105ad3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ad7:	90                   	nop
      curproc->ofile[fd] = f;
80105ad8:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  }
  fd[0] = fd0;
80105adc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105adf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ae1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ae4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105ae7:	31 c0                	xor    %eax,%eax
}
80105ae9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aec:	5b                   	pop    %ebx
80105aed:	5e                   	pop    %esi
80105aee:	5f                   	pop    %edi
80105aef:	5d                   	pop    %ebp
80105af0:	c3                   	ret
80105af1:	66 90                	xchg   %ax,%ax
80105af3:	66 90                	xchg   %ax,%ax
80105af5:	66 90                	xchg   %ax,%ax
80105af7:	66 90                	xchg   %ax,%ax
80105af9:	66 90                	xchg   %ax,%ax
80105afb:	66 90                	xchg   %ax,%ax
80105afd:	66 90                	xchg   %ax,%ax
80105aff:	90                   	nop

80105b00 <sys_getNumFreePages>:


int
sys_getNumFreePages(void)
{
  return num_of_FreePages();  
80105b00:	e9 6b cd ff ff       	jmp    80102870 <num_of_FreePages>
80105b05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b10 <sys_getrss>:
}

int 
sys_getrss()
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	83 ec 08             	sub    $0x8,%esp
  print_rss();
80105b16:	e8 b5 e2 ff ff       	call   80103dd0 <print_rss>
  return 0;
}
80105b1b:	31 c0                	xor    %eax,%eax
80105b1d:	c9                   	leave
80105b1e:	c3                   	ret
80105b1f:	90                   	nop

80105b20 <sys_fork>:

int
sys_fork(void)
{
  return fork();
80105b20:	e9 8b e1 ff ff       	jmp    80103cb0 <fork>
80105b25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b30 <sys_exit>:
}

int
sys_exit(void)
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b36:	e8 65 e4 ff ff       	call   80103fa0 <exit>
  return 0;  // not reached
}
80105b3b:	31 c0                	xor    %eax,%eax
80105b3d:	c9                   	leave
80105b3e:	c3                   	ret
80105b3f:	90                   	nop

80105b40 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105b40:	e9 8b e5 ff ff       	jmp    801040d0 <wait>
80105b45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b50 <sys_kill>:
}

int
sys_kill(void)
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105b56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b59:	50                   	push   %eax
80105b5a:	6a 00                	push   $0x0
80105b5c:	e8 5f f2 ff ff       	call   80104dc0 <argint>
80105b61:	83 c4 10             	add    $0x10,%esp
80105b64:	85 c0                	test   %eax,%eax
80105b66:	78 18                	js     80105b80 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105b68:	83 ec 0c             	sub    $0xc,%esp
80105b6b:	ff 75 f4             	push   -0xc(%ebp)
80105b6e:	e8 fd e7 ff ff       	call   80104370 <kill>
80105b73:	83 c4 10             	add    $0x10,%esp
}
80105b76:	c9                   	leave
80105b77:	c3                   	ret
80105b78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b7f:	90                   	nop
80105b80:	c9                   	leave
    return -1;
80105b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b86:	c3                   	ret
80105b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8e:	66 90                	xchg   %ax,%ax

80105b90 <sys_getpid>:

int
sys_getpid(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b96:	e8 75 df ff ff       	call   80103b10 <myproc>
80105b9b:	8b 40 14             	mov    0x14(%eax),%eax
}
80105b9e:	c9                   	leave
80105b9f:	c3                   	ret

80105ba0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ba4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ba7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105baa:	50                   	push   %eax
80105bab:	6a 00                	push   $0x0
80105bad:	e8 0e f2 ff ff       	call   80104dc0 <argint>
80105bb2:	83 c4 10             	add    $0x10,%esp
80105bb5:	85 c0                	test   %eax,%eax
80105bb7:	78 27                	js     80105be0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105bb9:	e8 52 df ff ff       	call   80103b10 <myproc>
  if(growproc(n) < 0)
80105bbe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105bc1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105bc3:	ff 75 f4             	push   -0xc(%ebp)
80105bc6:	e8 65 e0 ff ff       	call   80103c30 <growproc>
80105bcb:	83 c4 10             	add    $0x10,%esp
80105bce:	85 c0                	test   %eax,%eax
80105bd0:	78 0e                	js     80105be0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105bd2:	89 d8                	mov    %ebx,%eax
80105bd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bd7:	c9                   	leave
80105bd8:	c3                   	ret
80105bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105be0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105be5:	eb eb                	jmp    80105bd2 <sys_sbrk+0x32>
80105be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bee:	66 90                	xchg   %ax,%ax

80105bf0 <sys_sleep>:

int
sys_sleep(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105bf4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105bf7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105bfa:	50                   	push   %eax
80105bfb:	6a 00                	push   $0x0
80105bfd:	e8 be f1 ff ff       	call   80104dc0 <argint>
80105c02:	83 c4 10             	add    $0x10,%esp
80105c05:	85 c0                	test   %eax,%eax
80105c07:	78 64                	js     80105c6d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105c09:	83 ec 0c             	sub    $0xc,%esp
80105c0c:	68 e0 58 11 80       	push   $0x801158e0
80105c11:	e8 fa ed ff ff       	call   80104a10 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105c19:	8b 1d c0 58 11 80    	mov    0x801158c0,%ebx
  while(ticks - ticks0 < n){
80105c1f:	83 c4 10             	add    $0x10,%esp
80105c22:	85 d2                	test   %edx,%edx
80105c24:	75 2b                	jne    80105c51 <sys_sleep+0x61>
80105c26:	eb 58                	jmp    80105c80 <sys_sleep+0x90>
80105c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c2f:	90                   	nop
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105c30:	83 ec 08             	sub    $0x8,%esp
80105c33:	68 e0 58 11 80       	push   $0x801158e0
80105c38:	68 c0 58 11 80       	push   $0x801158c0
80105c3d:	e8 0e e6 ff ff       	call   80104250 <sleep>
  while(ticks - ticks0 < n){
80105c42:	a1 c0 58 11 80       	mov    0x801158c0,%eax
80105c47:	83 c4 10             	add    $0x10,%esp
80105c4a:	29 d8                	sub    %ebx,%eax
80105c4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105c4f:	73 2f                	jae    80105c80 <sys_sleep+0x90>
    if(myproc()->killed){
80105c51:	e8 ba de ff ff       	call   80103b10 <myproc>
80105c56:	8b 40 28             	mov    0x28(%eax),%eax
80105c59:	85 c0                	test   %eax,%eax
80105c5b:	74 d3                	je     80105c30 <sys_sleep+0x40>
      release(&tickslock);
80105c5d:	83 ec 0c             	sub    $0xc,%esp
80105c60:	68 e0 58 11 80       	push   $0x801158e0
80105c65:	e8 46 ed ff ff       	call   801049b0 <release>
      return -1;
80105c6a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80105c6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c75:	c9                   	leave
80105c76:	c3                   	ret
80105c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105c80:	83 ec 0c             	sub    $0xc,%esp
80105c83:	68 e0 58 11 80       	push   $0x801158e0
80105c88:	e8 23 ed ff ff       	call   801049b0 <release>
}
80105c8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105c90:	83 c4 10             	add    $0x10,%esp
80105c93:	31 c0                	xor    %eax,%eax
}
80105c95:	c9                   	leave
80105c96:	c3                   	ret
80105c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9e:	66 90                	xchg   %ax,%ax

80105ca0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	53                   	push   %ebx
80105ca4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ca7:	68 e0 58 11 80       	push   $0x801158e0
80105cac:	e8 5f ed ff ff       	call   80104a10 <acquire>
  xticks = ticks;
80105cb1:	8b 1d c0 58 11 80    	mov    0x801158c0,%ebx
  release(&tickslock);
80105cb7:	c7 04 24 e0 58 11 80 	movl   $0x801158e0,(%esp)
80105cbe:	e8 ed ec ff ff       	call   801049b0 <release>
  return xticks;
}
80105cc3:	89 d8                	mov    %ebx,%eax
80105cc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cc8:	c9                   	leave
80105cc9:	c3                   	ret

80105cca <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105cca:	1e                   	push   %ds
  pushl %es
80105ccb:	06                   	push   %es
  pushl %fs
80105ccc:	0f a0                	push   %fs
  pushl %gs
80105cce:	0f a8                	push   %gs
  pushal
80105cd0:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105cd1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105cd5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105cd7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105cd9:	54                   	push   %esp
  call trap
80105cda:	e8 c1 00 00 00       	call   80105da0 <trap>
  addl $4, %esp
80105cdf:	83 c4 04             	add    $0x4,%esp

80105ce2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ce2:	61                   	popa
  popl %gs
80105ce3:	0f a9                	pop    %gs
  popl %fs
80105ce5:	0f a1                	pop    %fs
  popl %es
80105ce7:	07                   	pop    %es
  popl %ds
80105ce8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ce9:	83 c4 08             	add    $0x8,%esp
  iret
80105cec:	cf                   	iret
80105ced:	66 90                	xchg   %ax,%ax
80105cef:	90                   	nop

80105cf0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105cf0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105cf1:	31 c0                	xor    %eax,%eax
{
80105cf3:	89 e5                	mov    %esp,%ebp
80105cf5:	83 ec 08             	sub    $0x8,%esp
80105cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cff:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d00:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105d07:	c7 04 c5 22 59 11 80 	movl   $0x8e000008,-0x7feea6de(,%eax,8)
80105d0e:	08 00 00 8e 
80105d12:	66 89 14 c5 20 59 11 	mov    %dx,-0x7feea6e0(,%eax,8)
80105d19:	80 
80105d1a:	c1 ea 10             	shr    $0x10,%edx
80105d1d:	66 89 14 c5 26 59 11 	mov    %dx,-0x7feea6da(,%eax,8)
80105d24:	80 
  for(i = 0; i < 256; i++)
80105d25:	83 c0 01             	add    $0x1,%eax
80105d28:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d2d:	75 d1                	jne    80105d00 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105d2f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d32:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105d37:	c7 05 22 5b 11 80 08 	movl   $0xef000008,0x80115b22
80105d3e:	00 00 ef 
  initlock(&tickslock, "time");
80105d41:	68 fb 86 10 80       	push   $0x801086fb
80105d46:	68 e0 58 11 80       	push   $0x801158e0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d4b:	66 a3 20 5b 11 80    	mov    %ax,0x80115b20
80105d51:	c1 e8 10             	shr    $0x10,%eax
80105d54:	66 a3 26 5b 11 80    	mov    %ax,0x80115b26
  initlock(&tickslock, "time");
80105d5a:	e8 c1 ea ff ff       	call   80104820 <initlock>
}
80105d5f:	83 c4 10             	add    $0x10,%esp
80105d62:	c9                   	leave
80105d63:	c3                   	ret
80105d64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d6f:	90                   	nop

80105d70 <idtinit>:

void
idtinit(void)
{
80105d70:	55                   	push   %ebp
  pd[0] = size-1;
80105d71:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105d76:	89 e5                	mov    %esp,%ebp
80105d78:	83 ec 10             	sub    $0x10,%esp
80105d7b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105d7f:	b8 20 59 11 80       	mov    $0x80115920,%eax
80105d84:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105d88:	c1 e8 10             	shr    $0x10,%eax
80105d8b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105d8f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105d92:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105d95:	c9                   	leave
80105d96:	c3                   	ret
80105d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9e:	66 90                	xchg   %ax,%ax

80105da0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	57                   	push   %edi
80105da4:	56                   	push   %esi
80105da5:	53                   	push   %ebx
80105da6:	83 ec 1c             	sub    $0x1c,%esp
80105da9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105dac:	8b 43 30             	mov    0x30(%ebx),%eax
80105daf:	83 f8 40             	cmp    $0x40,%eax
80105db2:	0f 84 30 01 00 00    	je     80105ee8 <trap+0x148>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105db8:	83 e8 0e             	sub    $0xe,%eax
80105dbb:	83 f8 31             	cmp    $0x31,%eax
80105dbe:	0f 87 8c 00 00 00    	ja     80105e50 <trap+0xb0>
80105dc4:	ff 24 85 60 8d 10 80 	jmp    *-0x7fef72a0(,%eax,4)
80105dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dcf:	90                   	nop
    // panic("wohooo\n");
    handle_page_fault();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105dd0:	e8 1b dd ff ff       	call   80103af0 <cpuid>
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	0f 84 13 02 00 00    	je     80105ff0 <trap+0x250>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105ddd:	e8 ce cc ff ff       	call   80102ab0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105de2:	e8 29 dd ff ff       	call   80103b10 <myproc>
80105de7:	85 c0                	test   %eax,%eax
80105de9:	74 1a                	je     80105e05 <trap+0x65>
80105deb:	e8 20 dd ff ff       	call   80103b10 <myproc>
80105df0:	8b 50 28             	mov    0x28(%eax),%edx
80105df3:	85 d2                	test   %edx,%edx
80105df5:	74 0e                	je     80105e05 <trap+0x65>
80105df7:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105dfb:	f7 d0                	not    %eax
80105dfd:	a8 03                	test   $0x3,%al
80105dff:	0f 84 cb 01 00 00    	je     80105fd0 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105e05:	e8 06 dd ff ff       	call   80103b10 <myproc>
80105e0a:	85 c0                	test   %eax,%eax
80105e0c:	74 0f                	je     80105e1d <trap+0x7d>
80105e0e:	e8 fd dc ff ff       	call   80103b10 <myproc>
80105e13:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80105e17:	0f 84 b3 00 00 00    	je     80105ed0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e1d:	e8 ee dc ff ff       	call   80103b10 <myproc>
80105e22:	85 c0                	test   %eax,%eax
80105e24:	74 1a                	je     80105e40 <trap+0xa0>
80105e26:	e8 e5 dc ff ff       	call   80103b10 <myproc>
80105e2b:	8b 40 28             	mov    0x28(%eax),%eax
80105e2e:	85 c0                	test   %eax,%eax
80105e30:	74 0e                	je     80105e40 <trap+0xa0>
80105e32:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e36:	f7 d0                	not    %eax
80105e38:	a8 03                	test   $0x3,%al
80105e3a:	0f 84 d5 00 00 00    	je     80105f15 <trap+0x175>
    exit();
}
80105e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e43:	5b                   	pop    %ebx
80105e44:	5e                   	pop    %esi
80105e45:	5f                   	pop    %edi
80105e46:	5d                   	pop    %ebp
80105e47:	c3                   	ret
80105e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4f:	90                   	nop
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e50:	e8 bb dc ff ff       	call   80103b10 <myproc>
80105e55:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e58:	85 c0                	test   %eax,%eax
80105e5a:	0f 84 c4 01 00 00    	je     80106024 <trap+0x284>
80105e60:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105e64:	0f 84 ba 01 00 00    	je     80106024 <trap+0x284>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e6a:	0f 20 d1             	mov    %cr2,%ecx
80105e6d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e70:	e8 7b dc ff ff       	call   80103af0 <cpuid>
80105e75:	8b 73 30             	mov    0x30(%ebx),%esi
80105e78:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105e7b:	8b 43 34             	mov    0x34(%ebx),%eax
80105e7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105e81:	e8 8a dc ff ff       	call   80103b10 <myproc>
80105e86:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105e89:	e8 82 dc ff ff       	call   80103b10 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e8e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105e91:	51                   	push   %ecx
80105e92:	57                   	push   %edi
80105e93:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e96:	52                   	push   %edx
80105e97:	ff 75 e4             	push   -0x1c(%ebp)
80105e9a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105e9b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105e9e:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ea1:	56                   	push   %esi
80105ea2:	ff 70 14             	push   0x14(%eax)
80105ea5:	68 18 8a 10 80       	push   $0x80108a18
80105eaa:	e8 f1 a8 ff ff       	call   801007a0 <cprintf>
    myproc()->killed = 1;
80105eaf:	83 c4 20             	add    $0x20,%esp
80105eb2:	e8 59 dc ff ff       	call   80103b10 <myproc>
80105eb7:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ebe:	e8 4d dc ff ff       	call   80103b10 <myproc>
80105ec3:	85 c0                	test   %eax,%eax
80105ec5:	0f 85 20 ff ff ff    	jne    80105deb <trap+0x4b>
80105ecb:	e9 35 ff ff ff       	jmp    80105e05 <trap+0x65>
  if(myproc() && myproc()->state == RUNNING &&
80105ed0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105ed4:	0f 85 43 ff ff ff    	jne    80105e1d <trap+0x7d>
    yield();
80105eda:	e8 21 e3 ff ff       	call   80104200 <yield>
80105edf:	e9 39 ff ff ff       	jmp    80105e1d <trap+0x7d>
80105ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105ee8:	e8 23 dc ff ff       	call   80103b10 <myproc>
80105eed:	8b 70 28             	mov    0x28(%eax),%esi
80105ef0:	85 f6                	test   %esi,%esi
80105ef2:	0f 85 e8 00 00 00    	jne    80105fe0 <trap+0x240>
    myproc()->tf = tf;
80105ef8:	e8 13 dc ff ff       	call   80103b10 <myproc>
80105efd:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80105f00:	e8 fb ef ff ff       	call   80104f00 <syscall>
    if(myproc()->killed)
80105f05:	e8 06 dc ff ff       	call   80103b10 <myproc>
80105f0a:	8b 48 28             	mov    0x28(%eax),%ecx
80105f0d:	85 c9                	test   %ecx,%ecx
80105f0f:	0f 84 2b ff ff ff    	je     80105e40 <trap+0xa0>
}
80105f15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f18:	5b                   	pop    %ebx
80105f19:	5e                   	pop    %esi
80105f1a:	5f                   	pop    %edi
80105f1b:	5d                   	pop    %ebp
      exit();
80105f1c:	e9 7f e0 ff ff       	jmp    80103fa0 <exit>
80105f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f28:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f2b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105f2f:	e8 bc db ff ff       	call   80103af0 <cpuid>
80105f34:	57                   	push   %edi
80105f35:	56                   	push   %esi
80105f36:	50                   	push   %eax
80105f37:	68 c0 89 10 80       	push   $0x801089c0
80105f3c:	e8 5f a8 ff ff       	call   801007a0 <cprintf>
    lapiceoi();
80105f41:	e8 6a cb ff ff       	call   80102ab0 <lapiceoi>
    break;
80105f46:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f49:	e8 c2 db ff ff       	call   80103b10 <myproc>
80105f4e:	85 c0                	test   %eax,%eax
80105f50:	0f 85 95 fe ff ff    	jne    80105deb <trap+0x4b>
80105f56:	e9 aa fe ff ff       	jmp    80105e05 <trap+0x65>
80105f5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f5f:	90                   	nop
    kbdintr();
80105f60:	e8 1b ca ff ff       	call   80102980 <kbdintr>
    lapiceoi();
80105f65:	e8 46 cb ff ff       	call   80102ab0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f6a:	e8 a1 db ff ff       	call   80103b10 <myproc>
80105f6f:	85 c0                	test   %eax,%eax
80105f71:	0f 85 74 fe ff ff    	jne    80105deb <trap+0x4b>
80105f77:	e9 89 fe ff ff       	jmp    80105e05 <trap+0x65>
80105f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105f80:	e8 4b 02 00 00       	call   801061d0 <uartintr>
    lapiceoi();
80105f85:	e8 26 cb ff ff       	call   80102ab0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f8a:	e8 81 db ff ff       	call   80103b10 <myproc>
80105f8f:	85 c0                	test   %eax,%eax
80105f91:	0f 85 54 fe ff ff    	jne    80105deb <trap+0x4b>
80105f97:	e9 69 fe ff ff       	jmp    80105e05 <trap+0x65>
80105f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105fa0:	e8 7b c3 ff ff       	call   80102320 <ideintr>
80105fa5:	e9 33 fe ff ff       	jmp    80105ddd <trap+0x3d>
80105faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    handle_page_fault();
80105fb0:	e8 6b 21 00 00       	call   80108120 <handle_page_fault>
    lapiceoi();
80105fb5:	e8 f6 ca ff ff       	call   80102ab0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fba:	e8 51 db ff ff       	call   80103b10 <myproc>
80105fbf:	85 c0                	test   %eax,%eax
80105fc1:	0f 85 24 fe ff ff    	jne    80105deb <trap+0x4b>
80105fc7:	e9 39 fe ff ff       	jmp    80105e05 <trap+0x65>
80105fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105fd0:	e8 cb df ff ff       	call   80103fa0 <exit>
80105fd5:	e9 2b fe ff ff       	jmp    80105e05 <trap+0x65>
80105fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105fe0:	e8 bb df ff ff       	call   80103fa0 <exit>
80105fe5:	e9 0e ff ff ff       	jmp    80105ef8 <trap+0x158>
80105fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105ff0:	83 ec 0c             	sub    $0xc,%esp
80105ff3:	68 e0 58 11 80       	push   $0x801158e0
80105ff8:	e8 13 ea ff ff       	call   80104a10 <acquire>
      ticks++;
80105ffd:	83 05 c0 58 11 80 01 	addl   $0x1,0x801158c0
      wakeup(&ticks);
80106004:	c7 04 24 c0 58 11 80 	movl   $0x801158c0,(%esp)
8010600b:	e8 00 e3 ff ff       	call   80104310 <wakeup>
      release(&tickslock);
80106010:	c7 04 24 e0 58 11 80 	movl   $0x801158e0,(%esp)
80106017:	e8 94 e9 ff ff       	call   801049b0 <release>
8010601c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010601f:	e9 b9 fd ff ff       	jmp    80105ddd <trap+0x3d>
80106024:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106027:	e8 c4 da ff ff       	call   80103af0 <cpuid>
8010602c:	83 ec 0c             	sub    $0xc,%esp
8010602f:	56                   	push   %esi
80106030:	57                   	push   %edi
80106031:	50                   	push   %eax
80106032:	ff 73 30             	push   0x30(%ebx)
80106035:	68 e4 89 10 80       	push   $0x801089e4
8010603a:	e8 61 a7 ff ff       	call   801007a0 <cprintf>
      panic("trap");
8010603f:	83 c4 14             	add    $0x14,%esp
80106042:	68 00 87 10 80       	push   $0x80108700
80106047:	e8 24 a4 ff ff       	call   80100470 <panic>
8010604c:	66 90                	xchg   %ax,%ax
8010604e:	66 90                	xchg   %ax,%ax

80106050 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106050:	a1 20 61 11 80       	mov    0x80116120,%eax
80106055:	85 c0                	test   %eax,%eax
80106057:	74 17                	je     80106070 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106059:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010605e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010605f:	a8 01                	test   $0x1,%al
80106061:	74 0d                	je     80106070 <uartgetc+0x20>
80106063:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106068:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106069:	0f b6 c0             	movzbl %al,%eax
8010606c:	c3                   	ret
8010606d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106075:	c3                   	ret
80106076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010607d:	8d 76 00             	lea    0x0(%esi),%esi

80106080 <uartinit>:
{
80106080:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106081:	31 c9                	xor    %ecx,%ecx
80106083:	89 c8                	mov    %ecx,%eax
80106085:	89 e5                	mov    %esp,%ebp
80106087:	57                   	push   %edi
80106088:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010608d:	56                   	push   %esi
8010608e:	89 fa                	mov    %edi,%edx
80106090:	53                   	push   %ebx
80106091:	83 ec 1c             	sub    $0x1c,%esp
80106094:	ee                   	out    %al,(%dx)
80106095:	be fb 03 00 00       	mov    $0x3fb,%esi
8010609a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010609f:	89 f2                	mov    %esi,%edx
801060a1:	ee                   	out    %al,(%dx)
801060a2:	b8 0c 00 00 00       	mov    $0xc,%eax
801060a7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060ac:	ee                   	out    %al,(%dx)
801060ad:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801060b2:	89 c8                	mov    %ecx,%eax
801060b4:	89 da                	mov    %ebx,%edx
801060b6:	ee                   	out    %al,(%dx)
801060b7:	b8 03 00 00 00       	mov    $0x3,%eax
801060bc:	89 f2                	mov    %esi,%edx
801060be:	ee                   	out    %al,(%dx)
801060bf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801060c4:	89 c8                	mov    %ecx,%eax
801060c6:	ee                   	out    %al,(%dx)
801060c7:	b8 01 00 00 00       	mov    $0x1,%eax
801060cc:	89 da                	mov    %ebx,%edx
801060ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060cf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060d4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801060d5:	3c ff                	cmp    $0xff,%al
801060d7:	0f 84 7c 00 00 00    	je     80106159 <uartinit+0xd9>
  uart = 1;
801060dd:	c7 05 20 61 11 80 01 	movl   $0x1,0x80116120
801060e4:	00 00 00 
801060e7:	89 fa                	mov    %edi,%edx
801060e9:	ec                   	in     (%dx),%al
801060ea:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060ef:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801060f0:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801060f3:	bf 05 87 10 80       	mov    $0x80108705,%edi
801060f8:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801060fd:	6a 00                	push   $0x0
801060ff:	6a 04                	push   $0x4
80106101:	e8 4a c4 ff ff       	call   80102550 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106106:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
8010610a:	83 c4 10             	add    $0x10,%esp
8010610d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80106110:	a1 20 61 11 80       	mov    0x80116120,%eax
80106115:	85 c0                	test   %eax,%eax
80106117:	74 32                	je     8010614b <uartinit+0xcb>
80106119:	89 f2                	mov    %esi,%edx
8010611b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010611c:	a8 20                	test   $0x20,%al
8010611e:	75 21                	jne    80106141 <uartinit+0xc1>
80106120:	bb 80 00 00 00       	mov    $0x80,%ebx
80106125:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80106128:	83 ec 0c             	sub    $0xc,%esp
8010612b:	6a 0a                	push   $0xa
8010612d:	e8 9e c9 ff ff       	call   80102ad0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106132:	83 c4 10             	add    $0x10,%esp
80106135:	83 eb 01             	sub    $0x1,%ebx
80106138:	74 07                	je     80106141 <uartinit+0xc1>
8010613a:	89 f2                	mov    %esi,%edx
8010613c:	ec                   	in     (%dx),%al
8010613d:	a8 20                	test   $0x20,%al
8010613f:	74 e7                	je     80106128 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106141:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106146:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010614a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010614b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
8010614f:	83 c7 01             	add    $0x1,%edi
80106152:	88 45 e7             	mov    %al,-0x19(%ebp)
80106155:	84 c0                	test   %al,%al
80106157:	75 b7                	jne    80106110 <uartinit+0x90>
}
80106159:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010615c:	5b                   	pop    %ebx
8010615d:	5e                   	pop    %esi
8010615e:	5f                   	pop    %edi
8010615f:	5d                   	pop    %ebp
80106160:	c3                   	ret
80106161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010616f:	90                   	nop

80106170 <uartputc>:
  if(!uart)
80106170:	a1 20 61 11 80       	mov    0x80116120,%eax
80106175:	85 c0                	test   %eax,%eax
80106177:	74 4f                	je     801061c8 <uartputc+0x58>
{
80106179:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010617a:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010617f:	89 e5                	mov    %esp,%ebp
80106181:	56                   	push   %esi
80106182:	53                   	push   %ebx
80106183:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106184:	a8 20                	test   $0x20,%al
80106186:	75 29                	jne    801061b1 <uartputc+0x41>
80106188:	bb 80 00 00 00       	mov    $0x80,%ebx
8010618d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106198:	83 ec 0c             	sub    $0xc,%esp
8010619b:	6a 0a                	push   $0xa
8010619d:	e8 2e c9 ff ff       	call   80102ad0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061a2:	83 c4 10             	add    $0x10,%esp
801061a5:	83 eb 01             	sub    $0x1,%ebx
801061a8:	74 07                	je     801061b1 <uartputc+0x41>
801061aa:	89 f2                	mov    %esi,%edx
801061ac:	ec                   	in     (%dx),%al
801061ad:	a8 20                	test   $0x20,%al
801061af:	74 e7                	je     80106198 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061b1:	8b 45 08             	mov    0x8(%ebp),%eax
801061b4:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061b9:	ee                   	out    %al,(%dx)
}
801061ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061bd:	5b                   	pop    %ebx
801061be:	5e                   	pop    %esi
801061bf:	5d                   	pop    %ebp
801061c0:	c3                   	ret
801061c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061c8:	c3                   	ret
801061c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061d0 <uartintr>:

void
uartintr(void)
{
801061d0:	55                   	push   %ebp
801061d1:	89 e5                	mov    %esp,%ebp
801061d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801061d6:	68 50 60 10 80       	push   $0x80106050
801061db:	e8 b0 a7 ff ff       	call   80100990 <consoleintr>
}
801061e0:	83 c4 10             	add    $0x10,%esp
801061e3:	c9                   	leave
801061e4:	c3                   	ret

801061e5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801061e5:	6a 00                	push   $0x0
  pushl $0
801061e7:	6a 00                	push   $0x0
  jmp alltraps
801061e9:	e9 dc fa ff ff       	jmp    80105cca <alltraps>

801061ee <vector1>:
.globl vector1
vector1:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $1
801061f0:	6a 01                	push   $0x1
  jmp alltraps
801061f2:	e9 d3 fa ff ff       	jmp    80105cca <alltraps>

801061f7 <vector2>:
.globl vector2
vector2:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $2
801061f9:	6a 02                	push   $0x2
  jmp alltraps
801061fb:	e9 ca fa ff ff       	jmp    80105cca <alltraps>

80106200 <vector3>:
.globl vector3
vector3:
  pushl $0
80106200:	6a 00                	push   $0x0
  pushl $3
80106202:	6a 03                	push   $0x3
  jmp alltraps
80106204:	e9 c1 fa ff ff       	jmp    80105cca <alltraps>

80106209 <vector4>:
.globl vector4
vector4:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $4
8010620b:	6a 04                	push   $0x4
  jmp alltraps
8010620d:	e9 b8 fa ff ff       	jmp    80105cca <alltraps>

80106212 <vector5>:
.globl vector5
vector5:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $5
80106214:	6a 05                	push   $0x5
  jmp alltraps
80106216:	e9 af fa ff ff       	jmp    80105cca <alltraps>

8010621b <vector6>:
.globl vector6
vector6:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $6
8010621d:	6a 06                	push   $0x6
  jmp alltraps
8010621f:	e9 a6 fa ff ff       	jmp    80105cca <alltraps>

80106224 <vector7>:
.globl vector7
vector7:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $7
80106226:	6a 07                	push   $0x7
  jmp alltraps
80106228:	e9 9d fa ff ff       	jmp    80105cca <alltraps>

8010622d <vector8>:
.globl vector8
vector8:
  pushl $8
8010622d:	6a 08                	push   $0x8
  jmp alltraps
8010622f:	e9 96 fa ff ff       	jmp    80105cca <alltraps>

80106234 <vector9>:
.globl vector9
vector9:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $9
80106236:	6a 09                	push   $0x9
  jmp alltraps
80106238:	e9 8d fa ff ff       	jmp    80105cca <alltraps>

8010623d <vector10>:
.globl vector10
vector10:
  pushl $10
8010623d:	6a 0a                	push   $0xa
  jmp alltraps
8010623f:	e9 86 fa ff ff       	jmp    80105cca <alltraps>

80106244 <vector11>:
.globl vector11
vector11:
  pushl $11
80106244:	6a 0b                	push   $0xb
  jmp alltraps
80106246:	e9 7f fa ff ff       	jmp    80105cca <alltraps>

8010624b <vector12>:
.globl vector12
vector12:
  pushl $12
8010624b:	6a 0c                	push   $0xc
  jmp alltraps
8010624d:	e9 78 fa ff ff       	jmp    80105cca <alltraps>

80106252 <vector13>:
.globl vector13
vector13:
  pushl $13
80106252:	6a 0d                	push   $0xd
  jmp alltraps
80106254:	e9 71 fa ff ff       	jmp    80105cca <alltraps>

80106259 <vector14>:
.globl vector14
vector14:
  pushl $14
80106259:	6a 0e                	push   $0xe
  jmp alltraps
8010625b:	e9 6a fa ff ff       	jmp    80105cca <alltraps>

80106260 <vector15>:
.globl vector15
vector15:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $15
80106262:	6a 0f                	push   $0xf
  jmp alltraps
80106264:	e9 61 fa ff ff       	jmp    80105cca <alltraps>

80106269 <vector16>:
.globl vector16
vector16:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $16
8010626b:	6a 10                	push   $0x10
  jmp alltraps
8010626d:	e9 58 fa ff ff       	jmp    80105cca <alltraps>

80106272 <vector17>:
.globl vector17
vector17:
  pushl $17
80106272:	6a 11                	push   $0x11
  jmp alltraps
80106274:	e9 51 fa ff ff       	jmp    80105cca <alltraps>

80106279 <vector18>:
.globl vector18
vector18:
  pushl $0
80106279:	6a 00                	push   $0x0
  pushl $18
8010627b:	6a 12                	push   $0x12
  jmp alltraps
8010627d:	e9 48 fa ff ff       	jmp    80105cca <alltraps>

80106282 <vector19>:
.globl vector19
vector19:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $19
80106284:	6a 13                	push   $0x13
  jmp alltraps
80106286:	e9 3f fa ff ff       	jmp    80105cca <alltraps>

8010628b <vector20>:
.globl vector20
vector20:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $20
8010628d:	6a 14                	push   $0x14
  jmp alltraps
8010628f:	e9 36 fa ff ff       	jmp    80105cca <alltraps>

80106294 <vector21>:
.globl vector21
vector21:
  pushl $0
80106294:	6a 00                	push   $0x0
  pushl $21
80106296:	6a 15                	push   $0x15
  jmp alltraps
80106298:	e9 2d fa ff ff       	jmp    80105cca <alltraps>

8010629d <vector22>:
.globl vector22
vector22:
  pushl $0
8010629d:	6a 00                	push   $0x0
  pushl $22
8010629f:	6a 16                	push   $0x16
  jmp alltraps
801062a1:	e9 24 fa ff ff       	jmp    80105cca <alltraps>

801062a6 <vector23>:
.globl vector23
vector23:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $23
801062a8:	6a 17                	push   $0x17
  jmp alltraps
801062aa:	e9 1b fa ff ff       	jmp    80105cca <alltraps>

801062af <vector24>:
.globl vector24
vector24:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $24
801062b1:	6a 18                	push   $0x18
  jmp alltraps
801062b3:	e9 12 fa ff ff       	jmp    80105cca <alltraps>

801062b8 <vector25>:
.globl vector25
vector25:
  pushl $0
801062b8:	6a 00                	push   $0x0
  pushl $25
801062ba:	6a 19                	push   $0x19
  jmp alltraps
801062bc:	e9 09 fa ff ff       	jmp    80105cca <alltraps>

801062c1 <vector26>:
.globl vector26
vector26:
  pushl $0
801062c1:	6a 00                	push   $0x0
  pushl $26
801062c3:	6a 1a                	push   $0x1a
  jmp alltraps
801062c5:	e9 00 fa ff ff       	jmp    80105cca <alltraps>

801062ca <vector27>:
.globl vector27
vector27:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $27
801062cc:	6a 1b                	push   $0x1b
  jmp alltraps
801062ce:	e9 f7 f9 ff ff       	jmp    80105cca <alltraps>

801062d3 <vector28>:
.globl vector28
vector28:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $28
801062d5:	6a 1c                	push   $0x1c
  jmp alltraps
801062d7:	e9 ee f9 ff ff       	jmp    80105cca <alltraps>

801062dc <vector29>:
.globl vector29
vector29:
  pushl $0
801062dc:	6a 00                	push   $0x0
  pushl $29
801062de:	6a 1d                	push   $0x1d
  jmp alltraps
801062e0:	e9 e5 f9 ff ff       	jmp    80105cca <alltraps>

801062e5 <vector30>:
.globl vector30
vector30:
  pushl $0
801062e5:	6a 00                	push   $0x0
  pushl $30
801062e7:	6a 1e                	push   $0x1e
  jmp alltraps
801062e9:	e9 dc f9 ff ff       	jmp    80105cca <alltraps>

801062ee <vector31>:
.globl vector31
vector31:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $31
801062f0:	6a 1f                	push   $0x1f
  jmp alltraps
801062f2:	e9 d3 f9 ff ff       	jmp    80105cca <alltraps>

801062f7 <vector32>:
.globl vector32
vector32:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $32
801062f9:	6a 20                	push   $0x20
  jmp alltraps
801062fb:	e9 ca f9 ff ff       	jmp    80105cca <alltraps>

80106300 <vector33>:
.globl vector33
vector33:
  pushl $0
80106300:	6a 00                	push   $0x0
  pushl $33
80106302:	6a 21                	push   $0x21
  jmp alltraps
80106304:	e9 c1 f9 ff ff       	jmp    80105cca <alltraps>

80106309 <vector34>:
.globl vector34
vector34:
  pushl $0
80106309:	6a 00                	push   $0x0
  pushl $34
8010630b:	6a 22                	push   $0x22
  jmp alltraps
8010630d:	e9 b8 f9 ff ff       	jmp    80105cca <alltraps>

80106312 <vector35>:
.globl vector35
vector35:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $35
80106314:	6a 23                	push   $0x23
  jmp alltraps
80106316:	e9 af f9 ff ff       	jmp    80105cca <alltraps>

8010631b <vector36>:
.globl vector36
vector36:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $36
8010631d:	6a 24                	push   $0x24
  jmp alltraps
8010631f:	e9 a6 f9 ff ff       	jmp    80105cca <alltraps>

80106324 <vector37>:
.globl vector37
vector37:
  pushl $0
80106324:	6a 00                	push   $0x0
  pushl $37
80106326:	6a 25                	push   $0x25
  jmp alltraps
80106328:	e9 9d f9 ff ff       	jmp    80105cca <alltraps>

8010632d <vector38>:
.globl vector38
vector38:
  pushl $0
8010632d:	6a 00                	push   $0x0
  pushl $38
8010632f:	6a 26                	push   $0x26
  jmp alltraps
80106331:	e9 94 f9 ff ff       	jmp    80105cca <alltraps>

80106336 <vector39>:
.globl vector39
vector39:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $39
80106338:	6a 27                	push   $0x27
  jmp alltraps
8010633a:	e9 8b f9 ff ff       	jmp    80105cca <alltraps>

8010633f <vector40>:
.globl vector40
vector40:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $40
80106341:	6a 28                	push   $0x28
  jmp alltraps
80106343:	e9 82 f9 ff ff       	jmp    80105cca <alltraps>

80106348 <vector41>:
.globl vector41
vector41:
  pushl $0
80106348:	6a 00                	push   $0x0
  pushl $41
8010634a:	6a 29                	push   $0x29
  jmp alltraps
8010634c:	e9 79 f9 ff ff       	jmp    80105cca <alltraps>

80106351 <vector42>:
.globl vector42
vector42:
  pushl $0
80106351:	6a 00                	push   $0x0
  pushl $42
80106353:	6a 2a                	push   $0x2a
  jmp alltraps
80106355:	e9 70 f9 ff ff       	jmp    80105cca <alltraps>

8010635a <vector43>:
.globl vector43
vector43:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $43
8010635c:	6a 2b                	push   $0x2b
  jmp alltraps
8010635e:	e9 67 f9 ff ff       	jmp    80105cca <alltraps>

80106363 <vector44>:
.globl vector44
vector44:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $44
80106365:	6a 2c                	push   $0x2c
  jmp alltraps
80106367:	e9 5e f9 ff ff       	jmp    80105cca <alltraps>

8010636c <vector45>:
.globl vector45
vector45:
  pushl $0
8010636c:	6a 00                	push   $0x0
  pushl $45
8010636e:	6a 2d                	push   $0x2d
  jmp alltraps
80106370:	e9 55 f9 ff ff       	jmp    80105cca <alltraps>

80106375 <vector46>:
.globl vector46
vector46:
  pushl $0
80106375:	6a 00                	push   $0x0
  pushl $46
80106377:	6a 2e                	push   $0x2e
  jmp alltraps
80106379:	e9 4c f9 ff ff       	jmp    80105cca <alltraps>

8010637e <vector47>:
.globl vector47
vector47:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $47
80106380:	6a 2f                	push   $0x2f
  jmp alltraps
80106382:	e9 43 f9 ff ff       	jmp    80105cca <alltraps>

80106387 <vector48>:
.globl vector48
vector48:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $48
80106389:	6a 30                	push   $0x30
  jmp alltraps
8010638b:	e9 3a f9 ff ff       	jmp    80105cca <alltraps>

80106390 <vector49>:
.globl vector49
vector49:
  pushl $0
80106390:	6a 00                	push   $0x0
  pushl $49
80106392:	6a 31                	push   $0x31
  jmp alltraps
80106394:	e9 31 f9 ff ff       	jmp    80105cca <alltraps>

80106399 <vector50>:
.globl vector50
vector50:
  pushl $0
80106399:	6a 00                	push   $0x0
  pushl $50
8010639b:	6a 32                	push   $0x32
  jmp alltraps
8010639d:	e9 28 f9 ff ff       	jmp    80105cca <alltraps>

801063a2 <vector51>:
.globl vector51
vector51:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $51
801063a4:	6a 33                	push   $0x33
  jmp alltraps
801063a6:	e9 1f f9 ff ff       	jmp    80105cca <alltraps>

801063ab <vector52>:
.globl vector52
vector52:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $52
801063ad:	6a 34                	push   $0x34
  jmp alltraps
801063af:	e9 16 f9 ff ff       	jmp    80105cca <alltraps>

801063b4 <vector53>:
.globl vector53
vector53:
  pushl $0
801063b4:	6a 00                	push   $0x0
  pushl $53
801063b6:	6a 35                	push   $0x35
  jmp alltraps
801063b8:	e9 0d f9 ff ff       	jmp    80105cca <alltraps>

801063bd <vector54>:
.globl vector54
vector54:
  pushl $0
801063bd:	6a 00                	push   $0x0
  pushl $54
801063bf:	6a 36                	push   $0x36
  jmp alltraps
801063c1:	e9 04 f9 ff ff       	jmp    80105cca <alltraps>

801063c6 <vector55>:
.globl vector55
vector55:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $55
801063c8:	6a 37                	push   $0x37
  jmp alltraps
801063ca:	e9 fb f8 ff ff       	jmp    80105cca <alltraps>

801063cf <vector56>:
.globl vector56
vector56:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $56
801063d1:	6a 38                	push   $0x38
  jmp alltraps
801063d3:	e9 f2 f8 ff ff       	jmp    80105cca <alltraps>

801063d8 <vector57>:
.globl vector57
vector57:
  pushl $0
801063d8:	6a 00                	push   $0x0
  pushl $57
801063da:	6a 39                	push   $0x39
  jmp alltraps
801063dc:	e9 e9 f8 ff ff       	jmp    80105cca <alltraps>

801063e1 <vector58>:
.globl vector58
vector58:
  pushl $0
801063e1:	6a 00                	push   $0x0
  pushl $58
801063e3:	6a 3a                	push   $0x3a
  jmp alltraps
801063e5:	e9 e0 f8 ff ff       	jmp    80105cca <alltraps>

801063ea <vector59>:
.globl vector59
vector59:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $59
801063ec:	6a 3b                	push   $0x3b
  jmp alltraps
801063ee:	e9 d7 f8 ff ff       	jmp    80105cca <alltraps>

801063f3 <vector60>:
.globl vector60
vector60:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $60
801063f5:	6a 3c                	push   $0x3c
  jmp alltraps
801063f7:	e9 ce f8 ff ff       	jmp    80105cca <alltraps>

801063fc <vector61>:
.globl vector61
vector61:
  pushl $0
801063fc:	6a 00                	push   $0x0
  pushl $61
801063fe:	6a 3d                	push   $0x3d
  jmp alltraps
80106400:	e9 c5 f8 ff ff       	jmp    80105cca <alltraps>

80106405 <vector62>:
.globl vector62
vector62:
  pushl $0
80106405:	6a 00                	push   $0x0
  pushl $62
80106407:	6a 3e                	push   $0x3e
  jmp alltraps
80106409:	e9 bc f8 ff ff       	jmp    80105cca <alltraps>

8010640e <vector63>:
.globl vector63
vector63:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $63
80106410:	6a 3f                	push   $0x3f
  jmp alltraps
80106412:	e9 b3 f8 ff ff       	jmp    80105cca <alltraps>

80106417 <vector64>:
.globl vector64
vector64:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $64
80106419:	6a 40                	push   $0x40
  jmp alltraps
8010641b:	e9 aa f8 ff ff       	jmp    80105cca <alltraps>

80106420 <vector65>:
.globl vector65
vector65:
  pushl $0
80106420:	6a 00                	push   $0x0
  pushl $65
80106422:	6a 41                	push   $0x41
  jmp alltraps
80106424:	e9 a1 f8 ff ff       	jmp    80105cca <alltraps>

80106429 <vector66>:
.globl vector66
vector66:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $66
8010642b:	6a 42                	push   $0x42
  jmp alltraps
8010642d:	e9 98 f8 ff ff       	jmp    80105cca <alltraps>

80106432 <vector67>:
.globl vector67
vector67:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $67
80106434:	6a 43                	push   $0x43
  jmp alltraps
80106436:	e9 8f f8 ff ff       	jmp    80105cca <alltraps>

8010643b <vector68>:
.globl vector68
vector68:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $68
8010643d:	6a 44                	push   $0x44
  jmp alltraps
8010643f:	e9 86 f8 ff ff       	jmp    80105cca <alltraps>

80106444 <vector69>:
.globl vector69
vector69:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $69
80106446:	6a 45                	push   $0x45
  jmp alltraps
80106448:	e9 7d f8 ff ff       	jmp    80105cca <alltraps>

8010644d <vector70>:
.globl vector70
vector70:
  pushl $0
8010644d:	6a 00                	push   $0x0
  pushl $70
8010644f:	6a 46                	push   $0x46
  jmp alltraps
80106451:	e9 74 f8 ff ff       	jmp    80105cca <alltraps>

80106456 <vector71>:
.globl vector71
vector71:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $71
80106458:	6a 47                	push   $0x47
  jmp alltraps
8010645a:	e9 6b f8 ff ff       	jmp    80105cca <alltraps>

8010645f <vector72>:
.globl vector72
vector72:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $72
80106461:	6a 48                	push   $0x48
  jmp alltraps
80106463:	e9 62 f8 ff ff       	jmp    80105cca <alltraps>

80106468 <vector73>:
.globl vector73
vector73:
  pushl $0
80106468:	6a 00                	push   $0x0
  pushl $73
8010646a:	6a 49                	push   $0x49
  jmp alltraps
8010646c:	e9 59 f8 ff ff       	jmp    80105cca <alltraps>

80106471 <vector74>:
.globl vector74
vector74:
  pushl $0
80106471:	6a 00                	push   $0x0
  pushl $74
80106473:	6a 4a                	push   $0x4a
  jmp alltraps
80106475:	e9 50 f8 ff ff       	jmp    80105cca <alltraps>

8010647a <vector75>:
.globl vector75
vector75:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $75
8010647c:	6a 4b                	push   $0x4b
  jmp alltraps
8010647e:	e9 47 f8 ff ff       	jmp    80105cca <alltraps>

80106483 <vector76>:
.globl vector76
vector76:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $76
80106485:	6a 4c                	push   $0x4c
  jmp alltraps
80106487:	e9 3e f8 ff ff       	jmp    80105cca <alltraps>

8010648c <vector77>:
.globl vector77
vector77:
  pushl $0
8010648c:	6a 00                	push   $0x0
  pushl $77
8010648e:	6a 4d                	push   $0x4d
  jmp alltraps
80106490:	e9 35 f8 ff ff       	jmp    80105cca <alltraps>

80106495 <vector78>:
.globl vector78
vector78:
  pushl $0
80106495:	6a 00                	push   $0x0
  pushl $78
80106497:	6a 4e                	push   $0x4e
  jmp alltraps
80106499:	e9 2c f8 ff ff       	jmp    80105cca <alltraps>

8010649e <vector79>:
.globl vector79
vector79:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $79
801064a0:	6a 4f                	push   $0x4f
  jmp alltraps
801064a2:	e9 23 f8 ff ff       	jmp    80105cca <alltraps>

801064a7 <vector80>:
.globl vector80
vector80:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $80
801064a9:	6a 50                	push   $0x50
  jmp alltraps
801064ab:	e9 1a f8 ff ff       	jmp    80105cca <alltraps>

801064b0 <vector81>:
.globl vector81
vector81:
  pushl $0
801064b0:	6a 00                	push   $0x0
  pushl $81
801064b2:	6a 51                	push   $0x51
  jmp alltraps
801064b4:	e9 11 f8 ff ff       	jmp    80105cca <alltraps>

801064b9 <vector82>:
.globl vector82
vector82:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $82
801064bb:	6a 52                	push   $0x52
  jmp alltraps
801064bd:	e9 08 f8 ff ff       	jmp    80105cca <alltraps>

801064c2 <vector83>:
.globl vector83
vector83:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $83
801064c4:	6a 53                	push   $0x53
  jmp alltraps
801064c6:	e9 ff f7 ff ff       	jmp    80105cca <alltraps>

801064cb <vector84>:
.globl vector84
vector84:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $84
801064cd:	6a 54                	push   $0x54
  jmp alltraps
801064cf:	e9 f6 f7 ff ff       	jmp    80105cca <alltraps>

801064d4 <vector85>:
.globl vector85
vector85:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $85
801064d6:	6a 55                	push   $0x55
  jmp alltraps
801064d8:	e9 ed f7 ff ff       	jmp    80105cca <alltraps>

801064dd <vector86>:
.globl vector86
vector86:
  pushl $0
801064dd:	6a 00                	push   $0x0
  pushl $86
801064df:	6a 56                	push   $0x56
  jmp alltraps
801064e1:	e9 e4 f7 ff ff       	jmp    80105cca <alltraps>

801064e6 <vector87>:
.globl vector87
vector87:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $87
801064e8:	6a 57                	push   $0x57
  jmp alltraps
801064ea:	e9 db f7 ff ff       	jmp    80105cca <alltraps>

801064ef <vector88>:
.globl vector88
vector88:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $88
801064f1:	6a 58                	push   $0x58
  jmp alltraps
801064f3:	e9 d2 f7 ff ff       	jmp    80105cca <alltraps>

801064f8 <vector89>:
.globl vector89
vector89:
  pushl $0
801064f8:	6a 00                	push   $0x0
  pushl $89
801064fa:	6a 59                	push   $0x59
  jmp alltraps
801064fc:	e9 c9 f7 ff ff       	jmp    80105cca <alltraps>

80106501 <vector90>:
.globl vector90
vector90:
  pushl $0
80106501:	6a 00                	push   $0x0
  pushl $90
80106503:	6a 5a                	push   $0x5a
  jmp alltraps
80106505:	e9 c0 f7 ff ff       	jmp    80105cca <alltraps>

8010650a <vector91>:
.globl vector91
vector91:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $91
8010650c:	6a 5b                	push   $0x5b
  jmp alltraps
8010650e:	e9 b7 f7 ff ff       	jmp    80105cca <alltraps>

80106513 <vector92>:
.globl vector92
vector92:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $92
80106515:	6a 5c                	push   $0x5c
  jmp alltraps
80106517:	e9 ae f7 ff ff       	jmp    80105cca <alltraps>

8010651c <vector93>:
.globl vector93
vector93:
  pushl $0
8010651c:	6a 00                	push   $0x0
  pushl $93
8010651e:	6a 5d                	push   $0x5d
  jmp alltraps
80106520:	e9 a5 f7 ff ff       	jmp    80105cca <alltraps>

80106525 <vector94>:
.globl vector94
vector94:
  pushl $0
80106525:	6a 00                	push   $0x0
  pushl $94
80106527:	6a 5e                	push   $0x5e
  jmp alltraps
80106529:	e9 9c f7 ff ff       	jmp    80105cca <alltraps>

8010652e <vector95>:
.globl vector95
vector95:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $95
80106530:	6a 5f                	push   $0x5f
  jmp alltraps
80106532:	e9 93 f7 ff ff       	jmp    80105cca <alltraps>

80106537 <vector96>:
.globl vector96
vector96:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $96
80106539:	6a 60                	push   $0x60
  jmp alltraps
8010653b:	e9 8a f7 ff ff       	jmp    80105cca <alltraps>

80106540 <vector97>:
.globl vector97
vector97:
  pushl $0
80106540:	6a 00                	push   $0x0
  pushl $97
80106542:	6a 61                	push   $0x61
  jmp alltraps
80106544:	e9 81 f7 ff ff       	jmp    80105cca <alltraps>

80106549 <vector98>:
.globl vector98
vector98:
  pushl $0
80106549:	6a 00                	push   $0x0
  pushl $98
8010654b:	6a 62                	push   $0x62
  jmp alltraps
8010654d:	e9 78 f7 ff ff       	jmp    80105cca <alltraps>

80106552 <vector99>:
.globl vector99
vector99:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $99
80106554:	6a 63                	push   $0x63
  jmp alltraps
80106556:	e9 6f f7 ff ff       	jmp    80105cca <alltraps>

8010655b <vector100>:
.globl vector100
vector100:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $100
8010655d:	6a 64                	push   $0x64
  jmp alltraps
8010655f:	e9 66 f7 ff ff       	jmp    80105cca <alltraps>

80106564 <vector101>:
.globl vector101
vector101:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $101
80106566:	6a 65                	push   $0x65
  jmp alltraps
80106568:	e9 5d f7 ff ff       	jmp    80105cca <alltraps>

8010656d <vector102>:
.globl vector102
vector102:
  pushl $0
8010656d:	6a 00                	push   $0x0
  pushl $102
8010656f:	6a 66                	push   $0x66
  jmp alltraps
80106571:	e9 54 f7 ff ff       	jmp    80105cca <alltraps>

80106576 <vector103>:
.globl vector103
vector103:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $103
80106578:	6a 67                	push   $0x67
  jmp alltraps
8010657a:	e9 4b f7 ff ff       	jmp    80105cca <alltraps>

8010657f <vector104>:
.globl vector104
vector104:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $104
80106581:	6a 68                	push   $0x68
  jmp alltraps
80106583:	e9 42 f7 ff ff       	jmp    80105cca <alltraps>

80106588 <vector105>:
.globl vector105
vector105:
  pushl $0
80106588:	6a 00                	push   $0x0
  pushl $105
8010658a:	6a 69                	push   $0x69
  jmp alltraps
8010658c:	e9 39 f7 ff ff       	jmp    80105cca <alltraps>

80106591 <vector106>:
.globl vector106
vector106:
  pushl $0
80106591:	6a 00                	push   $0x0
  pushl $106
80106593:	6a 6a                	push   $0x6a
  jmp alltraps
80106595:	e9 30 f7 ff ff       	jmp    80105cca <alltraps>

8010659a <vector107>:
.globl vector107
vector107:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $107
8010659c:	6a 6b                	push   $0x6b
  jmp alltraps
8010659e:	e9 27 f7 ff ff       	jmp    80105cca <alltraps>

801065a3 <vector108>:
.globl vector108
vector108:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $108
801065a5:	6a 6c                	push   $0x6c
  jmp alltraps
801065a7:	e9 1e f7 ff ff       	jmp    80105cca <alltraps>

801065ac <vector109>:
.globl vector109
vector109:
  pushl $0
801065ac:	6a 00                	push   $0x0
  pushl $109
801065ae:	6a 6d                	push   $0x6d
  jmp alltraps
801065b0:	e9 15 f7 ff ff       	jmp    80105cca <alltraps>

801065b5 <vector110>:
.globl vector110
vector110:
  pushl $0
801065b5:	6a 00                	push   $0x0
  pushl $110
801065b7:	6a 6e                	push   $0x6e
  jmp alltraps
801065b9:	e9 0c f7 ff ff       	jmp    80105cca <alltraps>

801065be <vector111>:
.globl vector111
vector111:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $111
801065c0:	6a 6f                	push   $0x6f
  jmp alltraps
801065c2:	e9 03 f7 ff ff       	jmp    80105cca <alltraps>

801065c7 <vector112>:
.globl vector112
vector112:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $112
801065c9:	6a 70                	push   $0x70
  jmp alltraps
801065cb:	e9 fa f6 ff ff       	jmp    80105cca <alltraps>

801065d0 <vector113>:
.globl vector113
vector113:
  pushl $0
801065d0:	6a 00                	push   $0x0
  pushl $113
801065d2:	6a 71                	push   $0x71
  jmp alltraps
801065d4:	e9 f1 f6 ff ff       	jmp    80105cca <alltraps>

801065d9 <vector114>:
.globl vector114
vector114:
  pushl $0
801065d9:	6a 00                	push   $0x0
  pushl $114
801065db:	6a 72                	push   $0x72
  jmp alltraps
801065dd:	e9 e8 f6 ff ff       	jmp    80105cca <alltraps>

801065e2 <vector115>:
.globl vector115
vector115:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $115
801065e4:	6a 73                	push   $0x73
  jmp alltraps
801065e6:	e9 df f6 ff ff       	jmp    80105cca <alltraps>

801065eb <vector116>:
.globl vector116
vector116:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $116
801065ed:	6a 74                	push   $0x74
  jmp alltraps
801065ef:	e9 d6 f6 ff ff       	jmp    80105cca <alltraps>

801065f4 <vector117>:
.globl vector117
vector117:
  pushl $0
801065f4:	6a 00                	push   $0x0
  pushl $117
801065f6:	6a 75                	push   $0x75
  jmp alltraps
801065f8:	e9 cd f6 ff ff       	jmp    80105cca <alltraps>

801065fd <vector118>:
.globl vector118
vector118:
  pushl $0
801065fd:	6a 00                	push   $0x0
  pushl $118
801065ff:	6a 76                	push   $0x76
  jmp alltraps
80106601:	e9 c4 f6 ff ff       	jmp    80105cca <alltraps>

80106606 <vector119>:
.globl vector119
vector119:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $119
80106608:	6a 77                	push   $0x77
  jmp alltraps
8010660a:	e9 bb f6 ff ff       	jmp    80105cca <alltraps>

8010660f <vector120>:
.globl vector120
vector120:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $120
80106611:	6a 78                	push   $0x78
  jmp alltraps
80106613:	e9 b2 f6 ff ff       	jmp    80105cca <alltraps>

80106618 <vector121>:
.globl vector121
vector121:
  pushl $0
80106618:	6a 00                	push   $0x0
  pushl $121
8010661a:	6a 79                	push   $0x79
  jmp alltraps
8010661c:	e9 a9 f6 ff ff       	jmp    80105cca <alltraps>

80106621 <vector122>:
.globl vector122
vector122:
  pushl $0
80106621:	6a 00                	push   $0x0
  pushl $122
80106623:	6a 7a                	push   $0x7a
  jmp alltraps
80106625:	e9 a0 f6 ff ff       	jmp    80105cca <alltraps>

8010662a <vector123>:
.globl vector123
vector123:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $123
8010662c:	6a 7b                	push   $0x7b
  jmp alltraps
8010662e:	e9 97 f6 ff ff       	jmp    80105cca <alltraps>

80106633 <vector124>:
.globl vector124
vector124:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $124
80106635:	6a 7c                	push   $0x7c
  jmp alltraps
80106637:	e9 8e f6 ff ff       	jmp    80105cca <alltraps>

8010663c <vector125>:
.globl vector125
vector125:
  pushl $0
8010663c:	6a 00                	push   $0x0
  pushl $125
8010663e:	6a 7d                	push   $0x7d
  jmp alltraps
80106640:	e9 85 f6 ff ff       	jmp    80105cca <alltraps>

80106645 <vector126>:
.globl vector126
vector126:
  pushl $0
80106645:	6a 00                	push   $0x0
  pushl $126
80106647:	6a 7e                	push   $0x7e
  jmp alltraps
80106649:	e9 7c f6 ff ff       	jmp    80105cca <alltraps>

8010664e <vector127>:
.globl vector127
vector127:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $127
80106650:	6a 7f                	push   $0x7f
  jmp alltraps
80106652:	e9 73 f6 ff ff       	jmp    80105cca <alltraps>

80106657 <vector128>:
.globl vector128
vector128:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $128
80106659:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010665e:	e9 67 f6 ff ff       	jmp    80105cca <alltraps>

80106663 <vector129>:
.globl vector129
vector129:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $129
80106665:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010666a:	e9 5b f6 ff ff       	jmp    80105cca <alltraps>

8010666f <vector130>:
.globl vector130
vector130:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $130
80106671:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106676:	e9 4f f6 ff ff       	jmp    80105cca <alltraps>

8010667b <vector131>:
.globl vector131
vector131:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $131
8010667d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106682:	e9 43 f6 ff ff       	jmp    80105cca <alltraps>

80106687 <vector132>:
.globl vector132
vector132:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $132
80106689:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010668e:	e9 37 f6 ff ff       	jmp    80105cca <alltraps>

80106693 <vector133>:
.globl vector133
vector133:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $133
80106695:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010669a:	e9 2b f6 ff ff       	jmp    80105cca <alltraps>

8010669f <vector134>:
.globl vector134
vector134:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $134
801066a1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801066a6:	e9 1f f6 ff ff       	jmp    80105cca <alltraps>

801066ab <vector135>:
.globl vector135
vector135:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $135
801066ad:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801066b2:	e9 13 f6 ff ff       	jmp    80105cca <alltraps>

801066b7 <vector136>:
.globl vector136
vector136:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $136
801066b9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801066be:	e9 07 f6 ff ff       	jmp    80105cca <alltraps>

801066c3 <vector137>:
.globl vector137
vector137:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $137
801066c5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801066ca:	e9 fb f5 ff ff       	jmp    80105cca <alltraps>

801066cf <vector138>:
.globl vector138
vector138:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $138
801066d1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801066d6:	e9 ef f5 ff ff       	jmp    80105cca <alltraps>

801066db <vector139>:
.globl vector139
vector139:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $139
801066dd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801066e2:	e9 e3 f5 ff ff       	jmp    80105cca <alltraps>

801066e7 <vector140>:
.globl vector140
vector140:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $140
801066e9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801066ee:	e9 d7 f5 ff ff       	jmp    80105cca <alltraps>

801066f3 <vector141>:
.globl vector141
vector141:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $141
801066f5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801066fa:	e9 cb f5 ff ff       	jmp    80105cca <alltraps>

801066ff <vector142>:
.globl vector142
vector142:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $142
80106701:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106706:	e9 bf f5 ff ff       	jmp    80105cca <alltraps>

8010670b <vector143>:
.globl vector143
vector143:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $143
8010670d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106712:	e9 b3 f5 ff ff       	jmp    80105cca <alltraps>

80106717 <vector144>:
.globl vector144
vector144:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $144
80106719:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010671e:	e9 a7 f5 ff ff       	jmp    80105cca <alltraps>

80106723 <vector145>:
.globl vector145
vector145:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $145
80106725:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010672a:	e9 9b f5 ff ff       	jmp    80105cca <alltraps>

8010672f <vector146>:
.globl vector146
vector146:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $146
80106731:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106736:	e9 8f f5 ff ff       	jmp    80105cca <alltraps>

8010673b <vector147>:
.globl vector147
vector147:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $147
8010673d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106742:	e9 83 f5 ff ff       	jmp    80105cca <alltraps>

80106747 <vector148>:
.globl vector148
vector148:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $148
80106749:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010674e:	e9 77 f5 ff ff       	jmp    80105cca <alltraps>

80106753 <vector149>:
.globl vector149
vector149:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $149
80106755:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010675a:	e9 6b f5 ff ff       	jmp    80105cca <alltraps>

8010675f <vector150>:
.globl vector150
vector150:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $150
80106761:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106766:	e9 5f f5 ff ff       	jmp    80105cca <alltraps>

8010676b <vector151>:
.globl vector151
vector151:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $151
8010676d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106772:	e9 53 f5 ff ff       	jmp    80105cca <alltraps>

80106777 <vector152>:
.globl vector152
vector152:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $152
80106779:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010677e:	e9 47 f5 ff ff       	jmp    80105cca <alltraps>

80106783 <vector153>:
.globl vector153
vector153:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $153
80106785:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010678a:	e9 3b f5 ff ff       	jmp    80105cca <alltraps>

8010678f <vector154>:
.globl vector154
vector154:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $154
80106791:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106796:	e9 2f f5 ff ff       	jmp    80105cca <alltraps>

8010679b <vector155>:
.globl vector155
vector155:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $155
8010679d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801067a2:	e9 23 f5 ff ff       	jmp    80105cca <alltraps>

801067a7 <vector156>:
.globl vector156
vector156:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $156
801067a9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801067ae:	e9 17 f5 ff ff       	jmp    80105cca <alltraps>

801067b3 <vector157>:
.globl vector157
vector157:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $157
801067b5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801067ba:	e9 0b f5 ff ff       	jmp    80105cca <alltraps>

801067bf <vector158>:
.globl vector158
vector158:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $158
801067c1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801067c6:	e9 ff f4 ff ff       	jmp    80105cca <alltraps>

801067cb <vector159>:
.globl vector159
vector159:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $159
801067cd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801067d2:	e9 f3 f4 ff ff       	jmp    80105cca <alltraps>

801067d7 <vector160>:
.globl vector160
vector160:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $160
801067d9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801067de:	e9 e7 f4 ff ff       	jmp    80105cca <alltraps>

801067e3 <vector161>:
.globl vector161
vector161:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $161
801067e5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801067ea:	e9 db f4 ff ff       	jmp    80105cca <alltraps>

801067ef <vector162>:
.globl vector162
vector162:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $162
801067f1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801067f6:	e9 cf f4 ff ff       	jmp    80105cca <alltraps>

801067fb <vector163>:
.globl vector163
vector163:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $163
801067fd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106802:	e9 c3 f4 ff ff       	jmp    80105cca <alltraps>

80106807 <vector164>:
.globl vector164
vector164:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $164
80106809:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010680e:	e9 b7 f4 ff ff       	jmp    80105cca <alltraps>

80106813 <vector165>:
.globl vector165
vector165:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $165
80106815:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010681a:	e9 ab f4 ff ff       	jmp    80105cca <alltraps>

8010681f <vector166>:
.globl vector166
vector166:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $166
80106821:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106826:	e9 9f f4 ff ff       	jmp    80105cca <alltraps>

8010682b <vector167>:
.globl vector167
vector167:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $167
8010682d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106832:	e9 93 f4 ff ff       	jmp    80105cca <alltraps>

80106837 <vector168>:
.globl vector168
vector168:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $168
80106839:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010683e:	e9 87 f4 ff ff       	jmp    80105cca <alltraps>

80106843 <vector169>:
.globl vector169
vector169:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $169
80106845:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010684a:	e9 7b f4 ff ff       	jmp    80105cca <alltraps>

8010684f <vector170>:
.globl vector170
vector170:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $170
80106851:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106856:	e9 6f f4 ff ff       	jmp    80105cca <alltraps>

8010685b <vector171>:
.globl vector171
vector171:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $171
8010685d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106862:	e9 63 f4 ff ff       	jmp    80105cca <alltraps>

80106867 <vector172>:
.globl vector172
vector172:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $172
80106869:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010686e:	e9 57 f4 ff ff       	jmp    80105cca <alltraps>

80106873 <vector173>:
.globl vector173
vector173:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $173
80106875:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010687a:	e9 4b f4 ff ff       	jmp    80105cca <alltraps>

8010687f <vector174>:
.globl vector174
vector174:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $174
80106881:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106886:	e9 3f f4 ff ff       	jmp    80105cca <alltraps>

8010688b <vector175>:
.globl vector175
vector175:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $175
8010688d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106892:	e9 33 f4 ff ff       	jmp    80105cca <alltraps>

80106897 <vector176>:
.globl vector176
vector176:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $176
80106899:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010689e:	e9 27 f4 ff ff       	jmp    80105cca <alltraps>

801068a3 <vector177>:
.globl vector177
vector177:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $177
801068a5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801068aa:	e9 1b f4 ff ff       	jmp    80105cca <alltraps>

801068af <vector178>:
.globl vector178
vector178:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $178
801068b1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801068b6:	e9 0f f4 ff ff       	jmp    80105cca <alltraps>

801068bb <vector179>:
.globl vector179
vector179:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $179
801068bd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801068c2:	e9 03 f4 ff ff       	jmp    80105cca <alltraps>

801068c7 <vector180>:
.globl vector180
vector180:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $180
801068c9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801068ce:	e9 f7 f3 ff ff       	jmp    80105cca <alltraps>

801068d3 <vector181>:
.globl vector181
vector181:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $181
801068d5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801068da:	e9 eb f3 ff ff       	jmp    80105cca <alltraps>

801068df <vector182>:
.globl vector182
vector182:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $182
801068e1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801068e6:	e9 df f3 ff ff       	jmp    80105cca <alltraps>

801068eb <vector183>:
.globl vector183
vector183:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $183
801068ed:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801068f2:	e9 d3 f3 ff ff       	jmp    80105cca <alltraps>

801068f7 <vector184>:
.globl vector184
vector184:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $184
801068f9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801068fe:	e9 c7 f3 ff ff       	jmp    80105cca <alltraps>

80106903 <vector185>:
.globl vector185
vector185:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $185
80106905:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010690a:	e9 bb f3 ff ff       	jmp    80105cca <alltraps>

8010690f <vector186>:
.globl vector186
vector186:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $186
80106911:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106916:	e9 af f3 ff ff       	jmp    80105cca <alltraps>

8010691b <vector187>:
.globl vector187
vector187:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $187
8010691d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106922:	e9 a3 f3 ff ff       	jmp    80105cca <alltraps>

80106927 <vector188>:
.globl vector188
vector188:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $188
80106929:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010692e:	e9 97 f3 ff ff       	jmp    80105cca <alltraps>

80106933 <vector189>:
.globl vector189
vector189:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $189
80106935:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010693a:	e9 8b f3 ff ff       	jmp    80105cca <alltraps>

8010693f <vector190>:
.globl vector190
vector190:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $190
80106941:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106946:	e9 7f f3 ff ff       	jmp    80105cca <alltraps>

8010694b <vector191>:
.globl vector191
vector191:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $191
8010694d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106952:	e9 73 f3 ff ff       	jmp    80105cca <alltraps>

80106957 <vector192>:
.globl vector192
vector192:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $192
80106959:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010695e:	e9 67 f3 ff ff       	jmp    80105cca <alltraps>

80106963 <vector193>:
.globl vector193
vector193:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $193
80106965:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010696a:	e9 5b f3 ff ff       	jmp    80105cca <alltraps>

8010696f <vector194>:
.globl vector194
vector194:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $194
80106971:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106976:	e9 4f f3 ff ff       	jmp    80105cca <alltraps>

8010697b <vector195>:
.globl vector195
vector195:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $195
8010697d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106982:	e9 43 f3 ff ff       	jmp    80105cca <alltraps>

80106987 <vector196>:
.globl vector196
vector196:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $196
80106989:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010698e:	e9 37 f3 ff ff       	jmp    80105cca <alltraps>

80106993 <vector197>:
.globl vector197
vector197:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $197
80106995:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010699a:	e9 2b f3 ff ff       	jmp    80105cca <alltraps>

8010699f <vector198>:
.globl vector198
vector198:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $198
801069a1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801069a6:	e9 1f f3 ff ff       	jmp    80105cca <alltraps>

801069ab <vector199>:
.globl vector199
vector199:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $199
801069ad:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801069b2:	e9 13 f3 ff ff       	jmp    80105cca <alltraps>

801069b7 <vector200>:
.globl vector200
vector200:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $200
801069b9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801069be:	e9 07 f3 ff ff       	jmp    80105cca <alltraps>

801069c3 <vector201>:
.globl vector201
vector201:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $201
801069c5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801069ca:	e9 fb f2 ff ff       	jmp    80105cca <alltraps>

801069cf <vector202>:
.globl vector202
vector202:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $202
801069d1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801069d6:	e9 ef f2 ff ff       	jmp    80105cca <alltraps>

801069db <vector203>:
.globl vector203
vector203:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $203
801069dd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801069e2:	e9 e3 f2 ff ff       	jmp    80105cca <alltraps>

801069e7 <vector204>:
.globl vector204
vector204:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $204
801069e9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801069ee:	e9 d7 f2 ff ff       	jmp    80105cca <alltraps>

801069f3 <vector205>:
.globl vector205
vector205:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $205
801069f5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801069fa:	e9 cb f2 ff ff       	jmp    80105cca <alltraps>

801069ff <vector206>:
.globl vector206
vector206:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $206
80106a01:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a06:	e9 bf f2 ff ff       	jmp    80105cca <alltraps>

80106a0b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $207
80106a0d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a12:	e9 b3 f2 ff ff       	jmp    80105cca <alltraps>

80106a17 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $208
80106a19:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a1e:	e9 a7 f2 ff ff       	jmp    80105cca <alltraps>

80106a23 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $209
80106a25:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a2a:	e9 9b f2 ff ff       	jmp    80105cca <alltraps>

80106a2f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $210
80106a31:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a36:	e9 8f f2 ff ff       	jmp    80105cca <alltraps>

80106a3b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $211
80106a3d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a42:	e9 83 f2 ff ff       	jmp    80105cca <alltraps>

80106a47 <vector212>:
.globl vector212
vector212:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $212
80106a49:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a4e:	e9 77 f2 ff ff       	jmp    80105cca <alltraps>

80106a53 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $213
80106a55:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a5a:	e9 6b f2 ff ff       	jmp    80105cca <alltraps>

80106a5f <vector214>:
.globl vector214
vector214:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $214
80106a61:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a66:	e9 5f f2 ff ff       	jmp    80105cca <alltraps>

80106a6b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $215
80106a6d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a72:	e9 53 f2 ff ff       	jmp    80105cca <alltraps>

80106a77 <vector216>:
.globl vector216
vector216:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $216
80106a79:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a7e:	e9 47 f2 ff ff       	jmp    80105cca <alltraps>

80106a83 <vector217>:
.globl vector217
vector217:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $217
80106a85:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106a8a:	e9 3b f2 ff ff       	jmp    80105cca <alltraps>

80106a8f <vector218>:
.globl vector218
vector218:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $218
80106a91:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106a96:	e9 2f f2 ff ff       	jmp    80105cca <alltraps>

80106a9b <vector219>:
.globl vector219
vector219:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $219
80106a9d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106aa2:	e9 23 f2 ff ff       	jmp    80105cca <alltraps>

80106aa7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $220
80106aa9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106aae:	e9 17 f2 ff ff       	jmp    80105cca <alltraps>

80106ab3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $221
80106ab5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106aba:	e9 0b f2 ff ff       	jmp    80105cca <alltraps>

80106abf <vector222>:
.globl vector222
vector222:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $222
80106ac1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ac6:	e9 ff f1 ff ff       	jmp    80105cca <alltraps>

80106acb <vector223>:
.globl vector223
vector223:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $223
80106acd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ad2:	e9 f3 f1 ff ff       	jmp    80105cca <alltraps>

80106ad7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $224
80106ad9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106ade:	e9 e7 f1 ff ff       	jmp    80105cca <alltraps>

80106ae3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $225
80106ae5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106aea:	e9 db f1 ff ff       	jmp    80105cca <alltraps>

80106aef <vector226>:
.globl vector226
vector226:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $226
80106af1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106af6:	e9 cf f1 ff ff       	jmp    80105cca <alltraps>

80106afb <vector227>:
.globl vector227
vector227:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $227
80106afd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b02:	e9 c3 f1 ff ff       	jmp    80105cca <alltraps>

80106b07 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $228
80106b09:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b0e:	e9 b7 f1 ff ff       	jmp    80105cca <alltraps>

80106b13 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $229
80106b15:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b1a:	e9 ab f1 ff ff       	jmp    80105cca <alltraps>

80106b1f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $230
80106b21:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b26:	e9 9f f1 ff ff       	jmp    80105cca <alltraps>

80106b2b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $231
80106b2d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b32:	e9 93 f1 ff ff       	jmp    80105cca <alltraps>

80106b37 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $232
80106b39:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b3e:	e9 87 f1 ff ff       	jmp    80105cca <alltraps>

80106b43 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $233
80106b45:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b4a:	e9 7b f1 ff ff       	jmp    80105cca <alltraps>

80106b4f <vector234>:
.globl vector234
vector234:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $234
80106b51:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b56:	e9 6f f1 ff ff       	jmp    80105cca <alltraps>

80106b5b <vector235>:
.globl vector235
vector235:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $235
80106b5d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b62:	e9 63 f1 ff ff       	jmp    80105cca <alltraps>

80106b67 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $236
80106b69:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b6e:	e9 57 f1 ff ff       	jmp    80105cca <alltraps>

80106b73 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $237
80106b75:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b7a:	e9 4b f1 ff ff       	jmp    80105cca <alltraps>

80106b7f <vector238>:
.globl vector238
vector238:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $238
80106b81:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106b86:	e9 3f f1 ff ff       	jmp    80105cca <alltraps>

80106b8b <vector239>:
.globl vector239
vector239:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $239
80106b8d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106b92:	e9 33 f1 ff ff       	jmp    80105cca <alltraps>

80106b97 <vector240>:
.globl vector240
vector240:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $240
80106b99:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106b9e:	e9 27 f1 ff ff       	jmp    80105cca <alltraps>

80106ba3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $241
80106ba5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106baa:	e9 1b f1 ff ff       	jmp    80105cca <alltraps>

80106baf <vector242>:
.globl vector242
vector242:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $242
80106bb1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106bb6:	e9 0f f1 ff ff       	jmp    80105cca <alltraps>

80106bbb <vector243>:
.globl vector243
vector243:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $243
80106bbd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106bc2:	e9 03 f1 ff ff       	jmp    80105cca <alltraps>

80106bc7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $244
80106bc9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106bce:	e9 f7 f0 ff ff       	jmp    80105cca <alltraps>

80106bd3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $245
80106bd5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106bda:	e9 eb f0 ff ff       	jmp    80105cca <alltraps>

80106bdf <vector246>:
.globl vector246
vector246:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $246
80106be1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106be6:	e9 df f0 ff ff       	jmp    80105cca <alltraps>

80106beb <vector247>:
.globl vector247
vector247:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $247
80106bed:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106bf2:	e9 d3 f0 ff ff       	jmp    80105cca <alltraps>

80106bf7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $248
80106bf9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106bfe:	e9 c7 f0 ff ff       	jmp    80105cca <alltraps>

80106c03 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $249
80106c05:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c0a:	e9 bb f0 ff ff       	jmp    80105cca <alltraps>

80106c0f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $250
80106c11:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c16:	e9 af f0 ff ff       	jmp    80105cca <alltraps>

80106c1b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $251
80106c1d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c22:	e9 a3 f0 ff ff       	jmp    80105cca <alltraps>

80106c27 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $252
80106c29:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c2e:	e9 97 f0 ff ff       	jmp    80105cca <alltraps>

80106c33 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $253
80106c35:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c3a:	e9 8b f0 ff ff       	jmp    80105cca <alltraps>

80106c3f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $254
80106c41:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c46:	e9 7f f0 ff ff       	jmp    80105cca <alltraps>

80106c4b <vector255>:
.globl vector255
vector255:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $255
80106c4d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c52:	e9 73 f0 ff ff       	jmp    80105cca <alltraps>
80106c57:	66 90                	xchg   %ax,%ax
80106c59:	66 90                	xchg   %ax,%ax
80106c5b:	66 90                	xchg   %ax,%ax
80106c5d:	66 90                	xchg   %ax,%ax
80106c5f:	90                   	nop

80106c60 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106c60:	55                   	push   %ebp
80106c61:	89 e5                	mov    %esp,%ebp
80106c63:	57                   	push   %edi
80106c64:	56                   	push   %esi
80106c65:	89 d6                	mov    %edx,%esi
80106c67:	53                   	push   %ebx
80106c68:	89 c3                	mov    %eax,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106c6a:	89 d0                	mov    %edx,%eax
80106c6c:	c1 e8 16             	shr    $0x16,%eax
80106c6f:	8d 3c 83             	lea    (%ebx,%eax,4),%edi
{
80106c72:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106c75:	8b 1f                	mov    (%edi),%ebx
80106c77:	f6 c3 01             	test   $0x1,%bl
80106c7a:	74 24                	je     80106ca0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c7c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106c82:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106c88:	89 f0                	mov    %esi,%eax
}
80106c8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106c8d:	c1 e8 0a             	shr    $0xa,%eax
80106c90:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c95:	01 d8                	add    %ebx,%eax
}
80106c97:	5b                   	pop    %ebx
80106c98:	5e                   	pop    %esi
80106c99:	5f                   	pop    %edi
80106c9a:	5d                   	pop    %ebp
80106c9b:	c3                   	ret
80106c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ca0:	85 c9                	test   %ecx,%ecx
80106ca2:	74 2c                	je     80106cd0 <walkpgdir+0x70>
80106ca4:	e8 07 bb ff ff       	call   801027b0 <kalloc>
80106ca9:	89 c3                	mov    %eax,%ebx
80106cab:	85 c0                	test   %eax,%eax
80106cad:	74 21                	je     80106cd0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106caf:	83 ec 04             	sub    $0x4,%esp
80106cb2:	68 00 10 00 00       	push   $0x1000
80106cb7:	6a 00                	push   $0x0
80106cb9:	50                   	push   %eax
80106cba:	e8 51 de ff ff       	call   80104b10 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106cbf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106cc5:	83 c4 10             	add    $0x10,%esp
80106cc8:	83 c8 07             	or     $0x7,%eax
80106ccb:	89 07                	mov    %eax,(%edi)
80106ccd:	eb b9                	jmp    80106c88 <walkpgdir+0x28>
80106ccf:	90                   	nop
}
80106cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106cd3:	31 c0                	xor    %eax,%eax
}
80106cd5:	5b                   	pop    %ebx
80106cd6:	5e                   	pop    %esi
80106cd7:	5f                   	pop    %edi
80106cd8:	5d                   	pop    %ebp
80106cd9:	c3                   	ret
80106cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ce0 <mappages_memory_update.constprop.0>:
    pa += PGSIZE;
  }
  return 0;
}
static int
mappages_memory_update(pde_t *pgdir, void *va, uint size, uint pa, int perm, int pid)
80106ce0:	55                   	push   %ebp
80106ce1:	89 e5                	mov    %esp,%ebp
80106ce3:	57                   	push   %edi
80106ce4:	89 c7                	mov    %eax,%edi
80106ce6:	89 d0                	mov    %edx,%eax
80106ce8:	56                   	push   %esi
{
  char *a, *last;
  pte_t *pte;

  a = (char *)PGROUNDDOWN((uint)va);
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
80106ce9:	05 ff 0f 00 00       	add    $0xfff,%eax
  a = (char *)PGROUNDDOWN((uint)va);
80106cee:	89 d6                	mov    %edx,%esi
mappages_memory_update(pde_t *pgdir, void *va, uint size, uint pa, int perm, int pid)
80106cf0:	53                   	push   %ebx
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
80106cf1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char *)PGROUNDDOWN((uint)va);
80106cf6:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
mappages_memory_update(pde_t *pgdir, void *va, uint size, uint pa, int perm, int pid)
80106cfc:	83 ec 1c             	sub    $0x1c,%esp
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
80106cff:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d02:	89 c8                	mov    %ecx,%eax
80106d04:	29 f0                	sub    %esi,%eax
80106d06:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106d09:	89 c7                	mov    %eax,%edi
80106d0b:	eb 2d                	jmp    80106d3a <mappages_memory_update.constprop.0+0x5a>
80106d0d:	8d 76 00             	lea    0x0(%esi),%esi
  for (;;)
  {
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if (*pte & PTE_P)
80106d10:	f6 00 01             	testb  $0x1,(%eax)
80106d13:	75 55                	jne    80106d6a <mappages_memory_update.constprop.0+0x8a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d15:	8b 4d 08             	mov    0x8(%ebp),%ecx
    inc_refcnt_in_memory(pa, pte, pid);
80106d18:	83 ec 04             	sub    $0x4,%esp
    *pte = pa | perm | PTE_P;
80106d1b:	09 d9                	or     %ebx,%ecx
80106d1d:	83 c9 01             	or     $0x1,%ecx
80106d20:	89 08                	mov    %ecx,(%eax)
    inc_refcnt_in_memory(pa, pte, pid);
80106d22:	ff 75 0c             	push   0xc(%ebp)
80106d25:	50                   	push   %eax
80106d26:	53                   	push   %ebx
80106d27:	e8 04 10 00 00       	call   80107d30 <inc_refcnt_in_memory>
    if (a == last)
80106d2c:	83 c4 10             	add    $0x10,%esp
80106d2f:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80106d32:	74 2c                	je     80106d60 <mappages_memory_update.constprop.0+0x80>
      break;
    a += PGSIZE;
80106d34:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d3d:	b9 01 00 00 00       	mov    $0x1,%ecx
80106d42:	89 f2                	mov    %esi,%edx
80106d44:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
80106d47:	e8 14 ff ff ff       	call   80106c60 <walkpgdir>
80106d4c:	85 c0                	test   %eax,%eax
80106d4e:	75 c0                	jne    80106d10 <mappages_memory_update.constprop.0+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d58:	5b                   	pop    %ebx
80106d59:	5e                   	pop    %esi
80106d5a:	5f                   	pop    %edi
80106d5b:	5d                   	pop    %ebp
80106d5c:	c3                   	ret
80106d5d:	8d 76 00             	lea    0x0(%esi),%esi
80106d60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d63:	31 c0                	xor    %eax,%eax
}
80106d65:	5b                   	pop    %ebx
80106d66:	5e                   	pop    %esi
80106d67:	5f                   	pop    %edi
80106d68:	5d                   	pop    %ebp
80106d69:	c3                   	ret
      panic("remap");
80106d6a:	83 ec 0c             	sub    $0xc,%esp
80106d6d:	68 0d 87 10 80       	push   $0x8010870d
80106d72:	e8 f9 96 ff ff       	call   80100470 <panic>
80106d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d7e:	66 90                	xchg   %ax,%ax

80106d80 <deallocuvm_proc.part.0>:
    }
  }
  return newsz;
}
int
deallocuvm_proc(struct proc * p, pde_t *pgdir, uint oldsz, uint newsz)
80106d80:	55                   	push   %ebp
80106d81:	89 e5                	mov    %esp,%ebp
80106d83:	57                   	push   %edi
80106d84:	56                   	push   %esi
80106d85:	53                   	push   %ebx
80106d86:	83 ec 1c             	sub    $0x1c,%esp
80106d89:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106d8c:	8b 45 08             	mov    0x8(%ebp),%eax
80106d8f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106d95:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d9b:	39 cb                	cmp    %ecx,%ebx
80106d9d:	0f 83 90 00 00 00    	jae    80106e33 <deallocuvm_proc.part.0+0xb3>
80106da3:	89 d6                	mov    %edx,%esi
80106da5:	89 cf                	mov    %ecx,%edi
80106da7:	eb 13                	jmp    80106dbc <deallocuvm_proc.part.0+0x3c>
80106da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106db0:	83 c2 01             	add    $0x1,%edx
80106db3:	89 d3                	mov    %edx,%ebx
80106db5:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106db8:	39 fb                	cmp    %edi,%ebx
80106dba:	73 77                	jae    80106e33 <deallocuvm_proc.part.0+0xb3>
  pde = &pgdir[PDX(va)];
80106dbc:	89 da                	mov    %ebx,%edx
80106dbe:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106dc1:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106dc4:	a8 01                	test   $0x1,%al
80106dc6:	74 e8                	je     80106db0 <deallocuvm_proc.part.0+0x30>
  return &pgtab[PTX(va)];
80106dc8:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106dca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106dcf:	c1 e9 0a             	shr    $0xa,%ecx
80106dd2:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106dd8:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106ddf:	85 c0                	test   %eax,%eax
80106de1:	74 cd                	je     80106db0 <deallocuvm_proc.part.0+0x30>
    else if((*pte & PTE_P) != 0){
80106de3:	8b 10                	mov    (%eax),%edx
80106de5:	f6 c2 01             	test   $0x1,%dl
80106de8:	74 56                	je     80106e40 <deallocuvm_proc.part.0+0xc0>

      pa = PTE_ADDR(*pte);
      if (pa == 0)
80106dea:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106df0:	74 7c                	je     80106e6e <deallocuvm_proc.part.0+0xee>
        panic("kfree");
      char *v = P2V(pa);
      dec_refcnt_in_memory(pa, pte);
80106df2:	83 ec 08             	sub    $0x8,%esp
  for(; a  < oldsz; a += PGSIZE){
80106df5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      dec_refcnt_in_memory(pa, pte);
80106dfb:	50                   	push   %eax
80106dfc:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106dff:	52                   	push   %edx
80106e00:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106e03:	e8 b8 0f 00 00       	call   80107dc0 <dec_refcnt_in_memory>
      char *v = P2V(pa);
80106e08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106e0b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106e11:	89 14 24             	mov    %edx,(%esp)
80106e14:	e8 87 b7 ff ff       	call   801025a0 <kfree>
      p->rss -= PGSIZE;
80106e19:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106e1c:	83 c4 10             	add    $0x10,%esp
80106e1f:	81 68 04 00 10 00 00 	subl   $0x1000,0x4(%eax)
      *pte = 0;
80106e26:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106e2f:	39 fb                	cmp    %edi,%ebx
80106e31:	72 89                	jb     80106dbc <deallocuvm_proc.part.0+0x3c>
      dec_refcnt_in_hdr(slot_no_i, pte);
      *pte = 0;
    }
  }
  return newsz;
}
80106e33:	8b 45 08             	mov    0x8(%ebp),%eax
80106e36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e39:	5b                   	pop    %ebx
80106e3a:	5e                   	pop    %esi
80106e3b:	5f                   	pop    %edi
80106e3c:	5d                   	pop    %ebp
80106e3d:	c3                   	ret
80106e3e:	66 90                	xchg   %ax,%ax
    } else if((*pte & PTE_SW)){
80106e40:	f6 c2 08             	test   $0x8,%dl
80106e43:	75 0b                	jne    80106e50 <deallocuvm_proc.part.0+0xd0>
  for(; a  < oldsz; a += PGSIZE){
80106e45:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e4b:	e9 68 ff ff ff       	jmp    80106db8 <deallocuvm_proc.part.0+0x38>
      dec_refcnt_in_hdr(slot_no_i, pte);
80106e50:	83 ec 08             	sub    $0x8,%esp
      int slot_no_i = PTE_ADDR(*pte) >> PTXSHIFT;
80106e53:	c1 ea 0c             	shr    $0xc,%edx
      dec_refcnt_in_hdr(slot_no_i, pte);
80106e56:	50                   	push   %eax
80106e57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e5a:	52                   	push   %edx
80106e5b:	e8 10 10 00 00       	call   80107e70 <dec_refcnt_in_hdr>
      *pte = 0;
80106e60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e63:	83 c4 10             	add    $0x10,%esp
80106e66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106e6c:	eb d7                	jmp    80106e45 <deallocuvm_proc.part.0+0xc5>
        panic("kfree");
80106e6e:	83 ec 0c             	sub    $0xc,%esp
80106e71:	68 cc 84 10 80       	push   $0x801084cc
80106e76:	e8 f5 95 ff ff       	call   80100470 <panic>
80106e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e7f:	90                   	nop

80106e80 <deallocuvm.part.0>:
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	57                   	push   %edi
80106e84:	56                   	push   %esi
80106e85:	89 c6                	mov    %eax,%esi
80106e87:	89 c8                	mov    %ecx,%eax
80106e89:	53                   	push   %ebx
  a = PGROUNDUP(newsz);
80106e8a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106e90:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e96:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106e99:	39 d3                	cmp    %edx,%ebx
80106e9b:	0f 83 94 00 00 00    	jae    80106f35 <deallocuvm.part.0+0xb5>
80106ea1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80106ea4:	89 d7                	mov    %edx,%edi
80106ea6:	eb 14                	jmp    80106ebc <deallocuvm.part.0+0x3c>
80106ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eaf:	90                   	nop
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106eb0:	83 c2 01             	add    $0x1,%edx
80106eb3:	89 d3                	mov    %edx,%ebx
80106eb5:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106eb8:	39 fb                	cmp    %edi,%ebx
80106eba:	73 76                	jae    80106f32 <deallocuvm.part.0+0xb2>
  pde = &pgdir[PDX(va)];
80106ebc:	89 da                	mov    %ebx,%edx
80106ebe:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106ec1:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106ec4:	a8 01                	test   $0x1,%al
80106ec6:	74 e8                	je     80106eb0 <deallocuvm.part.0+0x30>
  return &pgtab[PTX(va)];
80106ec8:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106eca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106ecf:	c1 e9 0a             	shr    $0xa,%ecx
80106ed2:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106ed8:	8d 8c 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%ecx
    if(!pte)
80106edf:	85 c9                	test   %ecx,%ecx
80106ee1:	74 cd                	je     80106eb0 <deallocuvm.part.0+0x30>
    else if((*pte & PTE_P) != 0){
80106ee3:	8b 01                	mov    (%ecx),%eax
80106ee5:	a8 01                	test   $0x1,%al
80106ee7:	74 57                	je     80106f40 <deallocuvm.part.0+0xc0>
      if (pa == 0)
80106ee9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106eee:	74 7e                	je     80106f6e <deallocuvm.part.0+0xee>
      dec_refcnt_in_memory(pa, pte);
80106ef0:	83 ec 08             	sub    $0x8,%esp
  for(; a  < oldsz; a += PGSIZE){
80106ef3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      dec_refcnt_in_memory(pa, pte);
80106ef9:	51                   	push   %ecx
80106efa:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106efd:	50                   	push   %eax
80106efe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f01:	e8 ba 0e 00 00       	call   80107dc0 <dec_refcnt_in_memory>
      char *v = P2V(pa);
80106f06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f09:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106f0e:	89 04 24             	mov    %eax,(%esp)
80106f11:	e8 8a b6 ff ff       	call   801025a0 <kfree>
      myproc()->rss -= PGSIZE;
80106f16:	e8 f5 cb ff ff       	call   80103b10 <myproc>
      *pte = 0;
80106f1b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106f1e:	83 c4 10             	add    $0x10,%esp
      myproc()->rss -= PGSIZE;
80106f21:	81 68 04 00 10 00 00 	subl   $0x1000,0x4(%eax)
      *pte = 0;
80106f28:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
  for(; a  < oldsz; a += PGSIZE){
80106f2e:	39 fb                	cmp    %edi,%ebx
80106f30:	72 8a                	jb     80106ebc <deallocuvm.part.0+0x3c>
80106f32:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80106f35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f38:	5b                   	pop    %ebx
80106f39:	5e                   	pop    %esi
80106f3a:	5f                   	pop    %edi
80106f3b:	5d                   	pop    %ebp
80106f3c:	c3                   	ret
80106f3d:	8d 76 00             	lea    0x0(%esi),%esi
    } else if ((*pte & PTE_SW)) {
80106f40:	a8 08                	test   $0x8,%al
80106f42:	75 0c                	jne    80106f50 <deallocuvm.part.0+0xd0>
  for(; a  < oldsz; a += PGSIZE){
80106f44:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f4a:	e9 69 ff ff ff       	jmp    80106eb8 <deallocuvm.part.0+0x38>
80106f4f:	90                   	nop
      dec_refcnt_in_hdr(slot_no_i, pte);
80106f50:	83 ec 08             	sub    $0x8,%esp
      int slot_no_i = PTE_ADDR(*pte) >> PTXSHIFT;
80106f53:	c1 e8 0c             	shr    $0xc,%eax
      dec_refcnt_in_hdr(slot_no_i, pte);
80106f56:	51                   	push   %ecx
80106f57:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106f5a:	50                   	push   %eax
80106f5b:	e8 10 0f 00 00       	call   80107e70 <dec_refcnt_in_hdr>
      *pte = 0;
80106f60:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f63:	83 c4 10             	add    $0x10,%esp
80106f66:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
80106f6c:	eb d6                	jmp    80106f44 <deallocuvm.part.0+0xc4>
        panic("kfree");
80106f6e:	83 ec 0c             	sub    $0xc,%esp
80106f71:	68 cc 84 10 80       	push   $0x801084cc
80106f76:	e8 f5 94 ff ff       	call   80100470 <panic>
80106f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f7f:	90                   	nop

80106f80 <mappages>:
{
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	57                   	push   %edi
80106f84:	56                   	push   %esi
80106f85:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106f86:	89 d3                	mov    %edx,%ebx
80106f88:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106f8e:	83 ec 1c             	sub    $0x1c,%esp
80106f91:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f94:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106f98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106fa0:	8b 45 08             	mov    0x8(%ebp),%eax
80106fa3:	29 d8                	sub    %ebx,%eax
80106fa5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fa8:	eb 3f                	jmp    80106fe9 <mappages+0x69>
80106faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106fb0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106fb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106fb7:	c1 ea 0a             	shr    $0xa,%edx
80106fba:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106fc0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106fc7:	85 c0                	test   %eax,%eax
80106fc9:	74 75                	je     80107040 <mappages+0xc0>
    if(*pte & PTE_P)
80106fcb:	f6 00 01             	testb  $0x1,(%eax)
80106fce:	0f 85 86 00 00 00    	jne    8010705a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106fd4:	0b 75 0c             	or     0xc(%ebp),%esi
80106fd7:	83 ce 01             	or     $0x1,%esi
80106fda:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106fdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106fdf:	39 c3                	cmp    %eax,%ebx
80106fe1:	74 6d                	je     80107050 <mappages+0xd0>
    a += PGSIZE;
80106fe3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106fe9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106fec:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106fef:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106ff2:	89 d8                	mov    %ebx,%eax
80106ff4:	c1 e8 16             	shr    $0x16,%eax
80106ff7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106ffa:	8b 07                	mov    (%edi),%eax
80106ffc:	a8 01                	test   $0x1,%al
80106ffe:	75 b0                	jne    80106fb0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107000:	e8 ab b7 ff ff       	call   801027b0 <kalloc>
80107005:	85 c0                	test   %eax,%eax
80107007:	74 37                	je     80107040 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107009:	83 ec 04             	sub    $0x4,%esp
8010700c:	68 00 10 00 00       	push   $0x1000
80107011:	6a 00                	push   $0x0
80107013:	50                   	push   %eax
80107014:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107017:	e8 f4 da ff ff       	call   80104b10 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010701c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010701f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107022:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107028:	83 c8 07             	or     $0x7,%eax
8010702b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010702d:	89 d8                	mov    %ebx,%eax
8010702f:	c1 e8 0a             	shr    $0xa,%eax
80107032:	25 fc 0f 00 00       	and    $0xffc,%eax
80107037:	01 d0                	add    %edx,%eax
80107039:	eb 90                	jmp    80106fcb <mappages+0x4b>
8010703b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010703f:	90                   	nop
}
80107040:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107043:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107048:	5b                   	pop    %ebx
80107049:	5e                   	pop    %esi
8010704a:	5f                   	pop    %edi
8010704b:	5d                   	pop    %ebp
8010704c:	c3                   	ret
8010704d:	8d 76 00             	lea    0x0(%esi),%esi
80107050:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107053:	31 c0                	xor    %eax,%eax
}
80107055:	5b                   	pop    %ebx
80107056:	5e                   	pop    %esi
80107057:	5f                   	pop    %edi
80107058:	5d                   	pop    %ebp
80107059:	c3                   	ret
      panic("remap");
8010705a:	83 ec 0c             	sub    $0xc,%esp
8010705d:	68 0d 87 10 80       	push   $0x8010870d
80107062:	e8 09 94 ff ff       	call   80100470 <panic>
80107067:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010706e:	66 90                	xchg   %ax,%ax

80107070 <seginit>:
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107076:	e8 75 ca ff ff       	call   80103af0 <cpuid>
  pd[0] = size-1;
8010707b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107080:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107086:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
8010708a:	c7 80 38 38 11 80 ff 	movl   $0xffff,-0x7feec7c8(%eax)
80107091:	ff 00 00 
80107094:	c7 80 3c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7c4(%eax)
8010709b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010709e:	c7 80 40 38 11 80 ff 	movl   $0xffff,-0x7feec7c0(%eax)
801070a5:	ff 00 00 
801070a8:	c7 80 44 38 11 80 00 	movl   $0xcf9200,-0x7feec7bc(%eax)
801070af:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801070b2:	c7 80 48 38 11 80 ff 	movl   $0xffff,-0x7feec7b8(%eax)
801070b9:	ff 00 00 
801070bc:	c7 80 4c 38 11 80 00 	movl   $0xcffa00,-0x7feec7b4(%eax)
801070c3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801070c6:	c7 80 50 38 11 80 ff 	movl   $0xffff,-0x7feec7b0(%eax)
801070cd:	ff 00 00 
801070d0:	c7 80 54 38 11 80 00 	movl   $0xcff200,-0x7feec7ac(%eax)
801070d7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801070da:	05 30 38 11 80       	add    $0x80113830,%eax
  pd[1] = (uint)p;
801070df:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801070e3:	c1 e8 10             	shr    $0x10,%eax
801070e6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801070ea:	8d 45 f2             	lea    -0xe(%ebp),%eax
801070ed:	0f 01 10             	lgdtl  (%eax)
}
801070f0:	c9                   	leave
801070f1:	c3                   	ret
801070f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107100 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107100:	a1 24 61 11 80       	mov    0x80116124,%eax
80107105:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010710a:	0f 22 d8             	mov    %eax,%cr3
}
8010710d:	c3                   	ret
8010710e:	66 90                	xchg   %ax,%ax

80107110 <switchuvm>:
{
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	57                   	push   %edi
80107114:	56                   	push   %esi
80107115:	53                   	push   %ebx
80107116:	83 ec 1c             	sub    $0x1c,%esp
80107119:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010711c:	85 f6                	test   %esi,%esi
8010711e:	0f 84 cb 00 00 00    	je     801071ef <switchuvm+0xdf>
  if(p->kstack == 0)
80107124:	8b 46 0c             	mov    0xc(%esi),%eax
80107127:	85 c0                	test   %eax,%eax
80107129:	0f 84 da 00 00 00    	je     80107209 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010712f:	8b 46 08             	mov    0x8(%esi),%eax
80107132:	85 c0                	test   %eax,%eax
80107134:	0f 84 c2 00 00 00    	je     801071fc <switchuvm+0xec>
  pushcli();
8010713a:	e8 81 d7 ff ff       	call   801048c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010713f:	e8 5c c9 ff ff       	call   80103aa0 <mycpu>
80107144:	89 c3                	mov    %eax,%ebx
80107146:	e8 55 c9 ff ff       	call   80103aa0 <mycpu>
8010714b:	89 c7                	mov    %eax,%edi
8010714d:	e8 4e c9 ff ff       	call   80103aa0 <mycpu>
80107152:	83 c7 08             	add    $0x8,%edi
80107155:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107158:	e8 43 c9 ff ff       	call   80103aa0 <mycpu>
8010715d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107160:	ba 67 00 00 00       	mov    $0x67,%edx
80107165:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010716c:	83 c0 08             	add    $0x8,%eax
8010716f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107176:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010717b:	83 c1 08             	add    $0x8,%ecx
8010717e:	c1 e8 18             	shr    $0x18,%eax
80107181:	c1 e9 10             	shr    $0x10,%ecx
80107184:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010718a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107190:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107195:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010719c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801071a1:	e8 fa c8 ff ff       	call   80103aa0 <mycpu>
801071a6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801071ad:	e8 ee c8 ff ff       	call   80103aa0 <mycpu>
801071b2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801071b6:	8b 5e 0c             	mov    0xc(%esi),%ebx
801071b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071bf:	e8 dc c8 ff ff       	call   80103aa0 <mycpu>
801071c4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801071c7:	e8 d4 c8 ff ff       	call   80103aa0 <mycpu>
801071cc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801071d0:	b8 28 00 00 00       	mov    $0x28,%eax
801071d5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801071d8:	8b 46 08             	mov    0x8(%esi),%eax
801071db:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801071e0:	0f 22 d8             	mov    %eax,%cr3
}
801071e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071e6:	5b                   	pop    %ebx
801071e7:	5e                   	pop    %esi
801071e8:	5f                   	pop    %edi
801071e9:	5d                   	pop    %ebp
  popcli();
801071ea:	e9 21 d7 ff ff       	jmp    80104910 <popcli>
    panic("switchuvm: no process");
801071ef:	83 ec 0c             	sub    $0xc,%esp
801071f2:	68 13 87 10 80       	push   $0x80108713
801071f7:	e8 74 92 ff ff       	call   80100470 <panic>
    panic("switchuvm: no pgdir");
801071fc:	83 ec 0c             	sub    $0xc,%esp
801071ff:	68 3e 87 10 80       	push   $0x8010873e
80107204:	e8 67 92 ff ff       	call   80100470 <panic>
    panic("switchuvm: no kstack");
80107209:	83 ec 0c             	sub    $0xc,%esp
8010720c:	68 29 87 10 80       	push   $0x80108729
80107211:	e8 5a 92 ff ff       	call   80100470 <panic>
80107216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010721d:	8d 76 00             	lea    0x0(%esi),%esi

80107220 <inituvm>:
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	57                   	push   %edi
80107224:	56                   	push   %esi
80107225:	53                   	push   %ebx
80107226:	83 ec 1c             	sub    $0x1c,%esp
80107229:	8b 45 08             	mov    0x8(%ebp),%eax
8010722c:	8b 75 10             	mov    0x10(%ebp),%esi
8010722f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80107232:	8b 55 14             	mov    0x14(%ebp),%edx
80107235:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107238:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010723e:	77 4a                	ja     8010728a <inituvm+0x6a>
80107240:	89 55 e0             	mov    %edx,-0x20(%ebp)
  mem = kalloc();
80107243:	e8 68 b5 ff ff       	call   801027b0 <kalloc>
  memset(mem, 0, PGSIZE);
80107248:	83 ec 04             	sub    $0x4,%esp
8010724b:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107250:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107252:	6a 00                	push   $0x0
80107254:	50                   	push   %eax
80107255:	e8 b6 d8 ff ff       	call   80104b10 <memset>
  mappages_memory_update(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U, pid);
8010725a:	58                   	pop    %eax
8010725b:	5a                   	pop    %edx
8010725c:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
80107262:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107265:	52                   	push   %edx
80107266:	31 d2                	xor    %edx,%edx
80107268:	6a 06                	push   $0x6
8010726a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010726d:	e8 6e fa ff ff       	call   80106ce0 <mappages_memory_update.constprop.0>
  memmove(mem, init, sz);
80107272:	89 75 10             	mov    %esi,0x10(%ebp)
80107275:	83 c4 10             	add    $0x10,%esp
80107278:	89 7d 0c             	mov    %edi,0xc(%ebp)
8010727b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010727e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107281:	5b                   	pop    %ebx
80107282:	5e                   	pop    %esi
80107283:	5f                   	pop    %edi
80107284:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107285:	e9 16 d9 ff ff       	jmp    80104ba0 <memmove>
    panic("inituvm: more than a page");
8010728a:	83 ec 0c             	sub    $0xc,%esp
8010728d:	68 52 87 10 80       	push   $0x80108752
80107292:	e8 d9 91 ff ff       	call   80100470 <panic>
80107297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010729e:	66 90                	xchg   %ax,%ax

801072a0 <loaduvm>:
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	57                   	push   %edi
801072a4:	56                   	push   %esi
801072a5:	53                   	push   %ebx
801072a6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
801072a9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
801072ac:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
801072af:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
801072b5:	0f 85 a2 00 00 00    	jne    8010735d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
801072bb:	85 ff                	test   %edi,%edi
801072bd:	74 7d                	je     8010733c <loaduvm+0x9c>
801072bf:	90                   	nop
  pde = &pgdir[PDX(va)];
801072c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801072c3:	8b 55 08             	mov    0x8(%ebp),%edx
801072c6:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
801072c8:	89 c1                	mov    %eax,%ecx
801072ca:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801072cd:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
801072d0:	f6 c1 01             	test   $0x1,%cl
801072d3:	75 13                	jne    801072e8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
801072d5:	83 ec 0c             	sub    $0xc,%esp
801072d8:	68 6c 87 10 80       	push   $0x8010876c
801072dd:	e8 8e 91 ff ff       	call   80100470 <panic>
801072e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801072e8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072eb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801072f1:	25 fc 0f 00 00       	and    $0xffc,%eax
801072f6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801072fd:	85 c9                	test   %ecx,%ecx
801072ff:	74 d4                	je     801072d5 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80107301:	89 fb                	mov    %edi,%ebx
80107303:	b8 00 10 00 00       	mov    $0x1000,%eax
80107308:	29 f3                	sub    %esi,%ebx
8010730a:	39 c3                	cmp    %eax,%ebx
8010730c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010730f:	53                   	push   %ebx
80107310:	8b 45 14             	mov    0x14(%ebp),%eax
80107313:	01 f0                	add    %esi,%eax
80107315:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80107316:	8b 01                	mov    (%ecx),%eax
80107318:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010731d:	05 00 00 00 80       	add    $0x80000000,%eax
80107322:	50                   	push   %eax
80107323:	ff 75 10             	push   0x10(%ebp)
80107326:	e8 75 a8 ff ff       	call   80101ba0 <readi>
8010732b:	83 c4 10             	add    $0x10,%esp
8010732e:	39 d8                	cmp    %ebx,%eax
80107330:	75 1e                	jne    80107350 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80107332:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107338:	39 fe                	cmp    %edi,%esi
8010733a:	72 84                	jb     801072c0 <loaduvm+0x20>
}
8010733c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010733f:	31 c0                	xor    %eax,%eax
}
80107341:	5b                   	pop    %ebx
80107342:	5e                   	pop    %esi
80107343:	5f                   	pop    %edi
80107344:	5d                   	pop    %ebp
80107345:	c3                   	ret
80107346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010734d:	8d 76 00             	lea    0x0(%esi),%esi
80107350:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107353:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107358:	5b                   	pop    %ebx
80107359:	5e                   	pop    %esi
8010735a:	5f                   	pop    %edi
8010735b:	5d                   	pop    %ebp
8010735c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
8010735d:	83 ec 0c             	sub    $0xc,%esp
80107360:	68 5c 8a 10 80       	push   $0x80108a5c
80107365:	e8 06 91 ff ff       	call   80100470 <panic>
8010736a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107370 <allocuvm>:
{
80107370:	55                   	push   %ebp
80107371:	89 e5                	mov    %esp,%ebp
80107373:	57                   	push   %edi
80107374:	56                   	push   %esi
80107375:	53                   	push   %ebx
80107376:	83 ec 1c             	sub    $0x1c,%esp
80107379:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
8010737c:	85 ff                	test   %edi,%edi
8010737e:	0f 88 9b 00 00 00    	js     8010741f <allocuvm+0xaf>
80107384:	89 f8                	mov    %edi,%eax
  if(newsz < oldsz)
80107386:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107389:	0f 82 a1 00 00 00    	jb     80107430 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010738f:	8b 55 0c             	mov    0xc(%ebp),%edx
80107392:	8d b2 ff 0f 00 00    	lea    0xfff(%edx),%esi
80107398:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
8010739e:	39 fe                	cmp    %edi,%esi
801073a0:	0f 83 8d 00 00 00    	jae    80107433 <allocuvm+0xc3>
801073a6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801073a9:	eb 47                	jmp    801073f2 <allocuvm+0x82>
801073ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073af:	90                   	nop
    memset(mem, 0, PGSIZE);
801073b0:	83 ec 04             	sub    $0x4,%esp
801073b3:	68 00 10 00 00       	push   $0x1000
801073b8:	6a 00                	push   $0x0
801073ba:	50                   	push   %eax
801073bb:	e8 50 d7 ff ff       	call   80104b10 <memset>
    if(mappages_memory_update(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U, myproc()->pid) < 0){
801073c0:	e8 4b c7 ff ff       	call   80103b10 <myproc>
801073c5:	83 c4 08             	add    $0x8,%esp
801073c8:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
801073ce:	89 f2                	mov    %esi,%edx
801073d0:	ff 70 14             	push   0x14(%eax)
801073d3:	6a 06                	push   $0x6
801073d5:	8b 45 08             	mov    0x8(%ebp),%eax
801073d8:	e8 03 f9 ff ff       	call   80106ce0 <mappages_memory_update.constprop.0>
801073dd:	83 c4 10             	add    $0x10,%esp
801073e0:	85 c0                	test   %eax,%eax
801073e2:	78 5c                	js     80107440 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
801073e4:	81 c6 00 10 00 00    	add    $0x1000,%esi
801073ea:	39 fe                	cmp    %edi,%esi
801073ec:	0f 83 86 00 00 00    	jae    80107478 <allocuvm+0x108>
    mem = kalloc();
801073f2:	e8 b9 b3 ff ff       	call   801027b0 <kalloc>
801073f7:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801073f9:	85 c0                	test   %eax,%eax
801073fb:	75 b3                	jne    801073b0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801073fd:	83 ec 0c             	sub    $0xc,%esp
80107400:	68 8a 87 10 80       	push   $0x8010878a
80107405:	e8 96 93 ff ff       	call   801007a0 <cprintf>
  if(newsz >= oldsz)
8010740a:	83 c4 10             	add    $0x10,%esp
8010740d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107410:	74 0d                	je     8010741f <allocuvm+0xaf>
80107412:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107415:	8b 45 08             	mov    0x8(%ebp),%eax
80107418:	89 fa                	mov    %edi,%edx
8010741a:	e8 61 fa ff ff       	call   80106e80 <deallocuvm.part.0>
    return 0;
8010741f:	31 c0                	xor    %eax,%eax
}
80107421:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107424:	5b                   	pop    %ebx
80107425:	5e                   	pop    %esi
80107426:	5f                   	pop    %edi
80107427:	5d                   	pop    %ebp
80107428:	c3                   	ret
80107429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107430:	8b 45 0c             	mov    0xc(%ebp),%eax
}
80107433:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107436:	5b                   	pop    %ebx
80107437:	5e                   	pop    %esi
80107438:	5f                   	pop    %edi
80107439:	5d                   	pop    %ebp
8010743a:	c3                   	ret
8010743b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010743f:	90                   	nop
      cprintf("allocuvm out of memory (2)\n");
80107440:	83 ec 0c             	sub    $0xc,%esp
80107443:	68 a2 87 10 80       	push   $0x801087a2
80107448:	e8 53 93 ff ff       	call   801007a0 <cprintf>
  if(newsz >= oldsz)
8010744d:	83 c4 10             	add    $0x10,%esp
80107450:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107453:	74 0d                	je     80107462 <allocuvm+0xf2>
80107455:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107458:	8b 45 08             	mov    0x8(%ebp),%eax
8010745b:	89 fa                	mov    %edi,%edx
8010745d:	e8 1e fa ff ff       	call   80106e80 <deallocuvm.part.0>
      kfree(mem);
80107462:	83 ec 0c             	sub    $0xc,%esp
80107465:	53                   	push   %ebx
80107466:	e8 35 b1 ff ff       	call   801025a0 <kfree>
      return 0;
8010746b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010746e:	31 c0                	xor    %eax,%eax
80107470:	eb af                	jmp    80107421 <allocuvm+0xb1>
80107472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
8010747b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010747e:	5b                   	pop    %ebx
8010747f:	5e                   	pop    %esi
80107480:	5f                   	pop    %edi
80107481:	5d                   	pop    %ebp
80107482:	c3                   	ret
80107483:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010748a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107490 <deallocuvm>:
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	8b 55 0c             	mov    0xc(%ebp),%edx
80107496:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107499:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010749c:	39 d1                	cmp    %edx,%ecx
8010749e:	73 10                	jae    801074b0 <deallocuvm+0x20>
}
801074a0:	5d                   	pop    %ebp
801074a1:	e9 da f9 ff ff       	jmp    80106e80 <deallocuvm.part.0>
801074a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ad:	8d 76 00             	lea    0x0(%esi),%esi
801074b0:	89 d0                	mov    %edx,%eax
801074b2:	5d                   	pop    %ebp
801074b3:	c3                   	ret
801074b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074bf:	90                   	nop

801074c0 <deallocuvm_proc>:
{
801074c0:	55                   	push   %ebp
801074c1:	89 e5                	mov    %esp,%ebp
801074c3:	53                   	push   %ebx
801074c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
801074c7:	8b 45 14             	mov    0x14(%ebp),%eax
801074ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
801074cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  if(newsz >= oldsz)
801074d0:	39 c8                	cmp    %ecx,%eax
801074d2:	73 14                	jae    801074e8 <deallocuvm_proc+0x28>
801074d4:	89 45 08             	mov    %eax,0x8(%ebp)
801074d7:	89 d8                	mov    %ebx,%eax
}
801074d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801074dc:	c9                   	leave
801074dd:	e9 9e f8 ff ff       	jmp    80106d80 <deallocuvm_proc.part.0>
801074e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801074e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801074eb:	89 c8                	mov    %ecx,%eax
801074ed:	c9                   	leave
801074ee:	c3                   	ret
801074ef:	90                   	nop

801074f0 <freevm>:
// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801074f0:	55                   	push   %ebp
801074f1:	89 e5                	mov    %esp,%ebp
801074f3:	57                   	push   %edi
801074f4:	56                   	push   %esi
801074f5:	53                   	push   %ebx
801074f6:	83 ec 0c             	sub    $0xc,%esp
801074f9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801074fc:	85 f6                	test   %esi,%esi
801074fe:	74 59                	je     80107559 <freevm+0x69>
  if(newsz >= oldsz)
80107500:	31 c9                	xor    %ecx,%ecx
80107502:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107507:	89 f0                	mov    %esi,%eax
80107509:	89 f3                	mov    %esi,%ebx
8010750b:	e8 70 f9 ff ff       	call   80106e80 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107510:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107516:	eb 0f                	jmp    80107527 <freevm+0x37>
80107518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010751f:	90                   	nop
80107520:	83 c3 04             	add    $0x4,%ebx
80107523:	39 fb                	cmp    %edi,%ebx
80107525:	74 23                	je     8010754a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107527:	8b 03                	mov    (%ebx),%eax
80107529:	a8 01                	test   $0x1,%al
8010752b:	74 f3                	je     80107520 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010752d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107532:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107535:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107538:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010753d:	50                   	push   %eax
8010753e:	e8 5d b0 ff ff       	call   801025a0 <kfree>
80107543:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107546:	39 fb                	cmp    %edi,%ebx
80107548:	75 dd                	jne    80107527 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010754a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010754d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107550:	5b                   	pop    %ebx
80107551:	5e                   	pop    %esi
80107552:	5f                   	pop    %edi
80107553:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107554:	e9 47 b0 ff ff       	jmp    801025a0 <kfree>
    panic("freevm: no pgdir");
80107559:	83 ec 0c             	sub    $0xc,%esp
8010755c:	68 be 87 10 80       	push   $0x801087be
80107561:	e8 0a 8f ff ff       	call   80100470 <panic>
80107566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010756d:	8d 76 00             	lea    0x0(%esi),%esi

80107570 <setupkvm>:
{
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	56                   	push   %esi
80107574:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107575:	e8 36 b2 ff ff       	call   801027b0 <kalloc>
8010757a:	85 c0                	test   %eax,%eax
8010757c:	74 5e                	je     801075dc <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
8010757e:	83 ec 04             	sub    $0x4,%esp
80107581:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107583:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107588:	68 00 10 00 00       	push   $0x1000
8010758d:	6a 00                	push   $0x0
8010758f:	50                   	push   %eax
80107590:	e8 7b d5 ff ff       	call   80104b10 <memset>
80107595:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107598:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010759b:	83 ec 08             	sub    $0x8,%esp
8010759e:	8b 4b 08             	mov    0x8(%ebx),%ecx
801075a1:	8b 13                	mov    (%ebx),%edx
801075a3:	ff 73 0c             	push   0xc(%ebx)
801075a6:	50                   	push   %eax
801075a7:	29 c1                	sub    %eax,%ecx
801075a9:	89 f0                	mov    %esi,%eax
801075ab:	e8 d0 f9 ff ff       	call   80106f80 <mappages>
801075b0:	83 c4 10             	add    $0x10,%esp
801075b3:	85 c0                	test   %eax,%eax
801075b5:	78 19                	js     801075d0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075b7:	83 c3 10             	add    $0x10,%ebx
801075ba:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801075c0:	75 d6                	jne    80107598 <setupkvm+0x28>
}
801075c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801075c5:	89 f0                	mov    %esi,%eax
801075c7:	5b                   	pop    %ebx
801075c8:	5e                   	pop    %esi
801075c9:	5d                   	pop    %ebp
801075ca:	c3                   	ret
801075cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075cf:	90                   	nop
      freevm(pgdir);
801075d0:	83 ec 0c             	sub    $0xc,%esp
801075d3:	56                   	push   %esi
801075d4:	e8 17 ff ff ff       	call   801074f0 <freevm>
      return 0;
801075d9:	83 c4 10             	add    $0x10,%esp
}
801075dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
801075df:	31 f6                	xor    %esi,%esi
}
801075e1:	89 f0                	mov    %esi,%eax
801075e3:	5b                   	pop    %ebx
801075e4:	5e                   	pop    %esi
801075e5:	5d                   	pop    %ebp
801075e6:	c3                   	ret
801075e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ee:	66 90                	xchg   %ax,%ax

801075f0 <kvmalloc>:
{
801075f0:	55                   	push   %ebp
801075f1:	89 e5                	mov    %esp,%ebp
801075f3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801075f6:	e8 75 ff ff ff       	call   80107570 <setupkvm>
801075fb:	a3 24 61 11 80       	mov    %eax,0x80116124
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107600:	05 00 00 00 80       	add    $0x80000000,%eax
80107605:	0f 22 d8             	mov    %eax,%cr3
}
80107608:	c9                   	leave
80107609:	c3                   	ret
8010760a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107610 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	83 ec 08             	sub    $0x8,%esp
80107616:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107619:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010761c:	89 c1                	mov    %eax,%ecx
8010761e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107621:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107624:	f6 c2 01             	test   $0x1,%dl
80107627:	75 17                	jne    80107640 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107629:	83 ec 0c             	sub    $0xc,%esp
8010762c:	68 cf 87 10 80       	push   $0x801087cf
80107631:	e8 3a 8e ff ff       	call   80100470 <panic>
80107636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010763d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107640:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107643:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107649:	25 fc 0f 00 00       	and    $0xffc,%eax
8010764e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107655:	85 c0                	test   %eax,%eax
80107657:	74 d0                	je     80107629 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107659:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010765c:	c9                   	leave
8010765d:	c3                   	ret
8010765e:	66 90                	xchg   %ax,%ax

80107660 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	57                   	push   %edi
80107664:	56                   	push   %esi
80107665:	53                   	push   %ebx
80107666:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107669:	e8 02 ff ff ff       	call   80107570 <setupkvm>
8010766e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107671:	85 c0                	test   %eax,%eax
80107673:	0f 84 e9 00 00 00    	je     80107762 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107679:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010767c:	85 c9                	test   %ecx,%ecx
8010767e:	0f 84 b2 00 00 00    	je     80107736 <copyuvm+0xd6>
80107684:	31 f6                	xor    %esi,%esi
80107686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010768d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107690:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107693:	89 f0                	mov    %esi,%eax
80107695:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107698:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010769b:	a8 01                	test   $0x1,%al
8010769d:	75 11                	jne    801076b0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010769f:	83 ec 0c             	sub    $0xc,%esp
801076a2:	68 d9 87 10 80       	push   $0x801087d9
801076a7:	e8 c4 8d ff ff       	call   80100470 <panic>
801076ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801076b0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801076b7:	c1 ea 0a             	shr    $0xa,%edx
801076ba:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801076c0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801076c7:	85 c0                	test   %eax,%eax
801076c9:	74 d4                	je     8010769f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801076cb:	8b 00                	mov    (%eax),%eax
801076cd:	a8 01                	test   $0x1,%al
801076cf:	0f 84 9f 00 00 00    	je     80107774 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801076d5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801076d7:	25 ff 0f 00 00       	and    $0xfff,%eax
801076dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801076df:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801076e5:	e8 c6 b0 ff ff       	call   801027b0 <kalloc>
801076ea:	89 c3                	mov    %eax,%ebx
801076ec:	85 c0                	test   %eax,%eax
801076ee:	74 64                	je     80107754 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801076f0:	83 ec 04             	sub    $0x4,%esp
801076f3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801076f9:	68 00 10 00 00       	push   $0x1000
801076fe:	57                   	push   %edi
801076ff:	50                   	push   %eax
80107700:	e8 9b d4 ff ff       	call   80104ba0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107705:	58                   	pop    %eax
80107706:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010770c:	5a                   	pop    %edx
8010770d:	ff 75 e4             	push   -0x1c(%ebp)
80107710:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107715:	89 f2                	mov    %esi,%edx
80107717:	50                   	push   %eax
80107718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010771b:	e8 60 f8 ff ff       	call   80106f80 <mappages>
80107720:	83 c4 10             	add    $0x10,%esp
80107723:	85 c0                	test   %eax,%eax
80107725:	78 21                	js     80107748 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107727:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010772d:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107730:	0f 82 5a ff ff ff    	jb     80107690 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107736:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107739:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010773c:	5b                   	pop    %ebx
8010773d:	5e                   	pop    %esi
8010773e:	5f                   	pop    %edi
8010773f:	5d                   	pop    %ebp
80107740:	c3                   	ret
80107741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107748:	83 ec 0c             	sub    $0xc,%esp
8010774b:	53                   	push   %ebx
8010774c:	e8 4f ae ff ff       	call   801025a0 <kfree>
      goto bad;
80107751:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107754:	83 ec 0c             	sub    $0xc,%esp
80107757:	ff 75 e0             	push   -0x20(%ebp)
8010775a:	e8 91 fd ff ff       	call   801074f0 <freevm>
  return 0;
8010775f:	83 c4 10             	add    $0x10,%esp
    return 0;
80107762:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107769:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010776c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010776f:	5b                   	pop    %ebx
80107770:	5e                   	pop    %esi
80107771:	5f                   	pop    %edi
80107772:	5d                   	pop    %ebp
80107773:	c3                   	ret
      panic("copyuvm: page not present");
80107774:	83 ec 0c             	sub    $0xc,%esp
80107777:	68 f3 87 10 80       	push   $0x801087f3
8010777c:	e8 ef 8c ff ff       	call   80100470 <panic>
80107781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010778f:	90                   	nop

80107790 <copyuvm_cow>:
pde_t*
copyuvm_cow(pde_t *pgdir, uint sz, struct proc * p)
{
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	57                   	push   %edi
80107794:	56                   	push   %esi
80107795:	53                   	push   %ebx
80107796:	83 ec 2c             	sub    $0x2c,%esp

  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  if((d = setupkvm()) == 0)
80107799:	e8 d2 fd ff ff       	call   80107570 <setupkvm>
8010779e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801077a1:	85 c0                	test   %eax,%eax
801077a3:	0f 84 09 01 00 00    	je     801078b2 <copyuvm_cow+0x122>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801077a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801077ac:	85 c0                	test   %eax,%eax
801077ae:	0f 84 05 01 00 00    	je     801078b9 <copyuvm_cow+0x129>
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if(mappages_memory_update(d, (void*)i, PGSIZE, pa, flags, p->pid) < 0) {
      goto bad;
    }
    lcr3(V2P(pgdir));
801077b4:	8b 45 08             	mov    0x8(%ebp),%eax
  for(i = 0; i < sz; i += PGSIZE){
801077b7:	31 db                	xor    %ebx,%ebx
    lcr3(V2P(pgdir));
801077b9:	05 00 00 00 80       	add    $0x80000000,%eax
801077be:	89 45 d0             	mov    %eax,-0x30(%ebp)
801077c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*pde & PTE_P){
801077c8:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801077cb:	89 d8                	mov    %ebx,%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801077cd:	89 df                	mov    %ebx,%edi
  pde = &pgdir[PDX(va)];
801077cf:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801077d2:	8b 04 82             	mov    (%edx,%eax,4),%eax
801077d5:	a8 01                	test   $0x1,%al
801077d7:	75 17                	jne    801077f0 <copyuvm_cow+0x60>
      panic("copyuvm: pte should exist");
801077d9:	83 ec 0c             	sub    $0xc,%esp
801077dc:	68 d9 87 10 80       	push   $0x801087d9
801077e1:	e8 8a 8c ff ff       	call   80100470 <panic>
801077e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ed:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801077f0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801077f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801077f7:	c1 e9 0a             	shr    $0xa,%ecx
801077fa:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80107800:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107807:	85 c0                	test   %eax,%eax
80107809:	74 ce                	je     801077d9 <copyuvm_cow+0x49>
    if(!(*pte & PTE_P)){
8010780b:	8b 30                	mov    (%eax),%esi
8010780d:	f7 c6 01 00 00 00    	test   $0x1,%esi
80107813:	0f 85 cf 00 00 00    	jne    801078e8 <copyuvm_cow+0x158>
      if (*pte & PTE_SW){
80107819:	f7 c6 08 00 00 00    	test   $0x8,%esi
8010781f:	0f 84 11 01 00 00    	je     80107936 <copyuvm_cow+0x1a6>
        *pte &= ~PTE_W;
80107825:	89 f1                	mov    %esi,%ecx
        pa = PTE_ADDR(*pte);
80107827:	89 f2                	mov    %esi,%edx
        flags = PTE_FLAGS(*pte);
80107829:	81 e6 fd 0f 00 00    	and    $0xffd,%esi
8010782f:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
        *pte &= ~PTE_W;
80107832:	83 e1 fd             	and    $0xfffffffd,%ecx
        pa = PTE_ADDR(*pte);
80107835:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010783b:	89 75 d8             	mov    %esi,-0x28(%ebp)
        *pte &= ~PTE_W;
8010783e:	89 08                	mov    %ecx,(%eax)
        if (mappages_hdr_update(d, (void *)i, PGSIZE, pa, flags, p->pid) < 0){
80107840:	8b 45 10             	mov    0x10(%ebp),%eax
80107843:	8b 40 14             	mov    0x14(%eax),%eax
80107846:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
80107849:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
8010784f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107854:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107857:	89 d0                	mov    %edx,%eax
80107859:	29 d8                	sub    %ebx,%eax
8010785b:	89 c6                	mov    %eax,%esi
8010785d:	eb 2f                	jmp    8010788e <copyuvm_cow+0xfe>
8010785f:	90                   	nop
    if (*pte & PTE_P)
80107860:	f6 00 01             	testb  $0x1,(%eax)
80107863:	0f 85 c0 00 00 00    	jne    80107929 <copyuvm_cow+0x199>
    *pte = pa | perm;
80107869:	8b 4d d8             	mov    -0x28(%ebp),%ecx
    inc_refcnt_in_hdr(pa >> PTXSHIFT, pte, pid);
8010786c:	83 ec 04             	sub    $0x4,%esp
    *pte = pa | perm;
8010786f:	09 d9                	or     %ebx,%ecx
    inc_refcnt_in_hdr(pa >> PTXSHIFT, pte, pid);
80107871:	c1 eb 0c             	shr    $0xc,%ebx
    *pte = pa | perm;
80107874:	89 08                	mov    %ecx,(%eax)
    inc_refcnt_in_hdr(pa >> PTXSHIFT, pte, pid);
80107876:	ff 75 e0             	push   -0x20(%ebp)
80107879:	50                   	push   %eax
8010787a:	53                   	push   %ebx
8010787b:	e8 00 05 00 00       	call   80107d80 <inc_refcnt_in_hdr>
    if (a == last)
80107880:	83 c4 10             	add    $0x10,%esp
80107883:	39 7d dc             	cmp    %edi,-0x24(%ebp)
80107886:	74 40                	je     801078c8 <copyuvm_cow+0x138>
    a += PGSIZE;
80107888:	81 c7 00 10 00 00    	add    $0x1000,%edi
    if ((pte = walkpgdir(pgdir, a, 1)) == 0)
8010788e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107891:	b9 01 00 00 00       	mov    $0x1,%ecx
80107896:	89 fa                	mov    %edi,%edx
80107898:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010789b:	e8 c0 f3 ff ff       	call   80106c60 <walkpgdir>
801078a0:	85 c0                	test   %eax,%eax
801078a2:	75 bc                	jne    80107860 <copyuvm_cow+0xd0>
  }
  return d;

bad:
  freevm(d);
801078a4:	83 ec 0c             	sub    $0xc,%esp
801078a7:	ff 75 e4             	push   -0x1c(%ebp)
801078aa:	e8 41 fc ff ff       	call   801074f0 <freevm>
  return 0;
801078af:	83 c4 10             	add    $0x10,%esp
    return 0;
801078b2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)


}
801078b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078bf:	5b                   	pop    %ebx
801078c0:	5e                   	pop    %esi
801078c1:	5f                   	pop    %edi
801078c2:	5d                   	pop    %ebp
801078c3:	c3                   	ret
801078c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078c8:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
801078cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
801078ce:	0f 22 d8             	mov    %eax,%cr3
  for(i = 0; i < sz; i += PGSIZE){
801078d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801078d7:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
801078da:	0f 82 e8 fe ff ff    	jb     801077c8 <copyuvm_cow+0x38>
801078e0:	eb d7                	jmp    801078b9 <copyuvm_cow+0x129>
801078e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    p->rss += PGSIZE;
801078e8:	8b 75 10             	mov    0x10(%ebp),%esi
    if(mappages_memory_update(d, (void*)i, PGSIZE, pa, flags, p->pid) < 0) {
801078eb:	83 ec 08             	sub    $0x8,%esp
    p->rss += PGSIZE;
801078ee:	81 46 04 00 10 00 00 	addl   $0x1000,0x4(%esi)
    *pte &= ~PTE_W;
801078f5:	8b 10                	mov    (%eax),%edx
801078f7:	89 d1                	mov    %edx,%ecx
801078f9:	83 e1 fd             	and    $0xfffffffd,%ecx
801078fc:	89 08                	mov    %ecx,(%eax)
    pa = PTE_ADDR(*pte);
801078fe:	89 d1                	mov    %edx,%ecx
    flags = PTE_FLAGS(*pte);
80107900:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
    if(mappages_memory_update(d, (void*)i, PGSIZE, pa, flags, p->pid) < 0) {
80107906:	ff 76 14             	push   0x14(%esi)
    pa = PTE_ADDR(*pte);
80107909:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
    if(mappages_memory_update(d, (void*)i, PGSIZE, pa, flags, p->pid) < 0) {
8010790f:	52                   	push   %edx
80107910:	89 da                	mov    %ebx,%edx
80107912:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107915:	e8 c6 f3 ff ff       	call   80106ce0 <mappages_memory_update.constprop.0>
8010791a:	83 c4 10             	add    $0x10,%esp
8010791d:	85 c0                	test   %eax,%eax
8010791f:	78 83                	js     801078a4 <copyuvm_cow+0x114>
80107921:	8b 45 d0             	mov    -0x30(%ebp),%eax
80107924:	0f 22 d8             	mov    %eax,%cr3
}
80107927:	eb a8                	jmp    801078d1 <copyuvm_cow+0x141>
      panic("remap");
80107929:	83 ec 0c             	sub    $0xc,%esp
8010792c:	68 0d 87 10 80       	push   $0x8010870d
80107931:	e8 3a 8b ff ff       	call   80100470 <panic>
      panic("copyuvm: page not present");
80107936:	83 ec 0c             	sub    $0xc,%esp
80107939:	68 f3 87 10 80       	push   $0x801087f3
8010793e:	e8 2d 8b ff ff       	call   80100470 <panic>
80107943:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010794a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107950 <freevm_proc>:
void
freevm_proc(struct proc * p, pde_t *pgdir)
{
80107950:	55                   	push   %ebp
80107951:	89 e5                	mov    %esp,%ebp
80107953:	57                   	push   %edi
80107954:	56                   	push   %esi
80107955:	53                   	push   %ebx
80107956:	83 ec 0c             	sub    $0xc,%esp
80107959:	8b 75 0c             	mov    0xc(%ebp),%esi
8010795c:	8b 45 08             	mov    0x8(%ebp),%eax
  uint i;

  if(pgdir == 0)
8010795f:	85 f6                	test   %esi,%esi
80107961:	74 5e                	je     801079c1 <freevm_proc+0x71>
  if(newsz >= oldsz)
80107963:	83 ec 0c             	sub    $0xc,%esp
80107966:	b9 00 00 00 80       	mov    $0x80000000,%ecx
8010796b:	89 f2                	mov    %esi,%edx
8010796d:	89 f3                	mov    %esi,%ebx
8010796f:	6a 00                	push   $0x0
80107971:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107977:	e8 04 f4 ff ff       	call   80106d80 <deallocuvm_proc.part.0>
    panic("freevm: no pgdir");
  deallocuvm_proc(p, pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010797c:	83 c4 10             	add    $0x10,%esp
8010797f:	eb 0e                	jmp    8010798f <freevm_proc+0x3f>
80107981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107988:	83 c3 04             	add    $0x4,%ebx
8010798b:	39 fb                	cmp    %edi,%ebx
8010798d:	74 23                	je     801079b2 <freevm_proc+0x62>
    if(pgdir[i] & PTE_P){
8010798f:	8b 03                	mov    (%ebx),%eax
80107991:	a8 01                	test   $0x1,%al
80107993:	74 f3                	je     80107988 <freevm_proc+0x38>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107995:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
8010799a:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010799d:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801079a0:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801079a5:	50                   	push   %eax
801079a6:	e8 f5 ab ff ff       	call   801025a0 <kfree>
801079ab:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801079ae:	39 fb                	cmp    %edi,%ebx
801079b0:	75 dd                	jne    8010798f <freevm_proc+0x3f>
    }
  }
  kfree((char*)pgdir);
801079b2:	89 75 08             	mov    %esi,0x8(%ebp)
}
801079b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079b8:	5b                   	pop    %ebx
801079b9:	5e                   	pop    %esi
801079ba:	5f                   	pop    %edi
801079bb:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801079bc:	e9 df ab ff ff       	jmp    801025a0 <kfree>
    panic("freevm: no pgdir");
801079c1:	83 ec 0c             	sub    $0xc,%esp
801079c4:	68 be 87 10 80       	push   $0x801087be
801079c9:	e8 a2 8a ff ff       	call   80100470 <panic>
801079ce:	66 90                	xchg   %ax,%ax

801079d0 <clear_zombie>:
void clear_zombie(struct proc * p){
801079d0:	55                   	push   %ebp
801079d1:	89 e5                	mov    %esp,%ebp
801079d3:	57                   	push   %edi
801079d4:	56                   	push   %esi
801079d5:	53                   	push   %ebx
801079d6:	83 ec 1c             	sub    $0x1c,%esp
801079d9:	8b 45 08             	mov    0x8(%ebp),%eax
801079dc:	8b 70 08             	mov    0x8(%eax),%esi
801079df:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
801079e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801079e8:	eb 10                	jmp    801079fa <clear_zombie+0x2a>
801079ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  pde_t * pgdir = p->pgdir;
  for(int i = 0 ; i < NPDENTRIES; i++){
801079f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079f3:	83 c6 04             	add    $0x4,%esi
801079f6:	39 c6                	cmp    %eax,%esi
801079f8:	74 43                	je     80107a3d <clear_zombie+0x6d>
    if(pgdir[i] & PTE_P){
801079fa:	8b 16                	mov    (%esi),%edx
801079fc:	f6 c2 01             	test   $0x1,%dl
801079ff:	74 ef                	je     801079f0 <clear_zombie+0x20>
      pte_t* pte = (pte_t*) P2V(PTE_ADDR(pgdir[i]));
80107a01:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107a07:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
      for(int j= 0 ; j < NPTENTRIES; j++){
80107a0d:	8d ba 00 10 00 80    	lea    -0x7ffff000(%edx),%edi
80107a13:	eb 0a                	jmp    80107a1f <clear_zombie+0x4f>
80107a15:	8d 76 00             	lea    0x0(%esi),%esi
80107a18:	83 c3 04             	add    $0x4,%ebx
80107a1b:	39 df                	cmp    %ebx,%edi
80107a1d:	74 d1                	je     801079f0 <clear_zombie+0x20>
        if(!(pte[j] & PTE_P) && (pte[j] & PTE_SW)){
80107a1f:	8b 03                	mov    (%ebx),%eax
80107a21:	83 e0 09             	and    $0x9,%eax
80107a24:	83 f8 08             	cmp    $0x8,%eax
80107a27:	75 ef                	jne    80107a18 <clear_zombie+0x48>
          clear_slot(&pte[j]);
80107a29:	83 ec 0c             	sub    $0xc,%esp
80107a2c:	53                   	push   %ebx
80107a2d:	e8 6e 06 00 00       	call   801080a0 <clear_slot>
          pte[j] = 0;
80107a32:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107a38:	83 c4 10             	add    $0x10,%esp
80107a3b:	eb db                	jmp    80107a18 <clear_zombie+0x48>
        }
      }
    }
  }
}
80107a3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a40:	5b                   	pop    %ebx
80107a41:	5e                   	pop    %esi
80107a42:	5f                   	pop    %edi
80107a43:	5d                   	pop    %ebp
80107a44:	c3                   	ret
80107a45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107a50 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107a50:	55                   	push   %ebp
80107a51:	89 e5                	mov    %esp,%ebp
80107a53:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107a56:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107a59:	89 c1                	mov    %eax,%ecx
80107a5b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107a5e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107a61:	f6 c2 01             	test   $0x1,%dl
80107a64:	0f 84 f8 00 00 00    	je     80107b62 <uva2ka.cold>
  return &pgtab[PTX(va)];
80107a6a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a6d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107a73:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107a74:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107a79:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107a80:	89 d0                	mov    %edx,%eax
80107a82:	f7 d2                	not    %edx
80107a84:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a89:	05 00 00 00 80       	add    $0x80000000,%eax
80107a8e:	83 e2 05             	and    $0x5,%edx
80107a91:	ba 00 00 00 00       	mov    $0x0,%edx
80107a96:	0f 45 c2             	cmovne %edx,%eax
}
80107a99:	c3                   	ret
80107a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107aa0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107aa0:	55                   	push   %ebp
80107aa1:	89 e5                	mov    %esp,%ebp
80107aa3:	57                   	push   %edi
80107aa4:	56                   	push   %esi
80107aa5:	53                   	push   %ebx
80107aa6:	83 ec 0c             	sub    $0xc,%esp
80107aa9:	8b 75 14             	mov    0x14(%ebp),%esi
80107aac:	8b 45 0c             	mov    0xc(%ebp),%eax
80107aaf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107ab2:	85 f6                	test   %esi,%esi
80107ab4:	75 51                	jne    80107b07 <copyout+0x67>
80107ab6:	e9 9d 00 00 00       	jmp    80107b58 <copyout+0xb8>
80107abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107abf:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107ac0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107ac6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107acc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107ad2:	74 74                	je     80107b48 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80107ad4:	89 fb                	mov    %edi,%ebx
80107ad6:	29 c3                	sub    %eax,%ebx
80107ad8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107ade:	39 f3                	cmp    %esi,%ebx
80107ae0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107ae3:	29 f8                	sub    %edi,%eax
80107ae5:	83 ec 04             	sub    $0x4,%esp
80107ae8:	01 c1                	add    %eax,%ecx
80107aea:	53                   	push   %ebx
80107aeb:	52                   	push   %edx
80107aec:	89 55 10             	mov    %edx,0x10(%ebp)
80107aef:	51                   	push   %ecx
80107af0:	e8 ab d0 ff ff       	call   80104ba0 <memmove>
    len -= n;
    buf += n;
80107af5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107af8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107afe:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107b01:	01 da                	add    %ebx,%edx
  while(len > 0){
80107b03:	29 de                	sub    %ebx,%esi
80107b05:	74 51                	je     80107b58 <copyout+0xb8>
  if(*pde & PTE_P){
80107b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107b0a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107b0c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107b0e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107b11:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107b17:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107b1a:	f6 c1 01             	test   $0x1,%cl
80107b1d:	0f 84 46 00 00 00    	je     80107b69 <copyout.cold>
  return &pgtab[PTX(va)];
80107b23:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b25:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107b2b:	c1 eb 0c             	shr    $0xc,%ebx
80107b2e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107b34:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107b3b:	89 d9                	mov    %ebx,%ecx
80107b3d:	f7 d1                	not    %ecx
80107b3f:	83 e1 05             	and    $0x5,%ecx
80107b42:	0f 84 78 ff ff ff    	je     80107ac0 <copyout+0x20>
  }
  return 0;
}
80107b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107b4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107b50:	5b                   	pop    %ebx
80107b51:	5e                   	pop    %esi
80107b52:	5f                   	pop    %edi
80107b53:	5d                   	pop    %ebp
80107b54:	c3                   	ret
80107b55:	8d 76 00             	lea    0x0(%esi),%esi
80107b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107b5b:	31 c0                	xor    %eax,%eax
}
80107b5d:	5b                   	pop    %ebx
80107b5e:	5e                   	pop    %esi
80107b5f:	5f                   	pop    %edi
80107b60:	5d                   	pop    %ebp
80107b61:	c3                   	ret

80107b62 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107b62:	a1 00 00 00 00       	mov    0x0,%eax
80107b67:	0f 0b                	ud2

80107b69 <copyout.cold>:
80107b69:	a1 00 00 00 00       	mov    0x0,%eax
80107b6e:	0f 0b                	ud2

80107b70 <cow_fault>:
#include "spinlock.h"


void cow_fault(){
	// create new page entry when page fault occurs due to cow
80107b70:	c3                   	ret
80107b71:	66 90                	xchg   %ax,%ax
80107b73:	66 90                	xchg   %ax,%ax
80107b75:	66 90                	xchg   %ax,%ax
80107b77:	66 90                	xchg   %ax,%ax
80107b79:	66 90                	xchg   %ax,%ax
80107b7b:	66 90                	xchg   %ax,%ax
80107b7d:	66 90                	xchg   %ax,%ax
80107b7f:	90                   	nop

80107b80 <swapinit>:

#define SWAPBASE 2
#define NPAGE (SWAPBLOCKS / BPPAGE)

struct swapslothdr swap_slots[NPAGE];
void swapinit(void){
80107b80:	55                   	push   %ebp
80107b81:	b8 40 61 11 80       	mov    $0x80116140,%eax
80107b86:	ba 02 00 00 00       	mov    $0x2,%edx
80107b8b:	89 e5                	mov    %esp,%ebp
80107b8d:	83 ec 08             	sub    $0x8,%esp
	for(int i = 0 ; i < NPAGE ; i++){
		swap_slots[i].is_free = FREE;
		swap_slots[i].page_perm = 0;
		swap_slots[i].blockno = SWAPBASE + i * BPPAGE;
80107b90:	89 50 08             	mov    %edx,0x8(%eax)
	for(int i = 0 ; i < NPAGE ; i++){
80107b93:	05 10 02 00 00       	add    $0x210,%eax
80107b98:	83 c2 08             	add    $0x8,%edx
		swap_slots[i].is_free = FREE;
80107b9b:	c7 80 f0 fd ff ff 01 	movl   $0x1,-0x210(%eax)
80107ba2:	00 00 00 
		swap_slots[i].page_perm = 0;
80107ba5:	c7 80 f4 fd ff ff 00 	movl   $0x0,-0x20c(%eax)
80107bac:	00 00 00 
	for(int i = 0 ; i < NPAGE ; i++){
80107baf:	3d 40 9a 14 80       	cmp    $0x80149a40,%eax
80107bb4:	75 da                	jne    80107b90 <swapinit+0x10>
	}
	cprintf("Swap slots initialized\n");
80107bb6:	83 ec 0c             	sub    $0xc,%esp
80107bb9:	68 0d 88 10 80       	push   $0x8010880d
80107bbe:	e8 dd 8b ff ff       	call   801007a0 <cprintf>
}
80107bc3:	83 c4 10             	add    $0x10,%esp
80107bc6:	c9                   	leave
80107bc7:	c3                   	ret
80107bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bcf:	90                   	nop

80107bd0 <swap_info_on_hdr>:

void swap_info_on_hdr(uint pa, uint slot_num){
80107bd0:	55                   	push   %ebp
80107bd1:	89 e5                	mov    %esp,%ebp
80107bd3:	57                   	push   %edi
80107bd4:	56                   	push   %esi
80107bd5:	53                   	push   %ebx
80107bd6:	83 ec 1c             	sub    $0x1c,%esp
80107bd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    swap_slots[slot_num].refcnt_to_disk = page_to_ref_cnt[pa>>PTXSHIFT];
80107bdc:	8b 55 08             	mov    0x8(%ebp),%edx
80107bdf:	69 d9 10 02 00 00    	imul   $0x210,%ecx,%ebx
80107be5:	c1 ea 0c             	shr    $0xc,%edx
80107be8:	8b 04 95 40 9a 1c 80 	mov    -0x7fe365c0(,%edx,4),%eax
80107bef:	89 83 4c 61 11 80    	mov    %eax,-0x7fee9eb4(%ebx)
80107bf5:	81 c3 40 61 11 80    	add    $0x80116140,%ebx

    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
80107bfb:	85 c0                	test   %eax,%eax
80107bfd:	74 70                	je     80107c6f <swap_info_on_hdr+0x9f>
        pte_t *pte = page_to_ptes_map[pa >> PTXSHIFT][i];
        swap_slots[slot_num].proc_pte_refs[i] = pte;
        swap_slots[slot_num].proc_pid_refs[i] = page_to_proc_pid_map[pa >> PTXSHIFT][i];
        *pte = (slot_num << PTXSHIFT) | PTE_FLAGS(*pte) | PTE_SW;
80107bff:	c1 e1 0c             	shl    $0xc,%ecx
80107c02:	89 d6                	mov    %edx,%esi
    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
80107c04:	89 55 dc             	mov    %edx,-0x24(%ebp)
80107c07:	89 d8                	mov    %ebx,%eax
        *pte = (slot_num << PTXSHIFT) | PTE_FLAGS(*pte) | PTE_SW;
80107c09:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107c0c:	c1 e6 08             	shl    $0x8,%esi
    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
80107c0f:	31 ff                	xor    %edi,%edi
80107c11:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80107c14:	89 f3                	mov    %esi,%ebx
80107c16:	89 c6                	mov    %eax,%esi
80107c18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c1f:	90                   	nop
        pte_t *pte = page_to_ptes_map[pa >> PTXSHIFT][i];
80107c20:	8b 94 bb 40 9a 18 80 	mov    -0x7fe765c0(%ebx,%edi,4),%edx
        *pte &= (~PTE_P);
80107c27:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
	update_rss(swap_slots[slot_num].proc_pid_refs[i], -PGSIZE);
80107c2a:	83 ec 08             	sub    $0x8,%esp
    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
80107c2d:	83 c6 04             	add    $0x4,%esi
        swap_slots[slot_num].proc_pid_refs[i] = page_to_proc_pid_map[pa >> PTXSHIFT][i];
80107c30:	8b 84 bb 40 9a 14 80 	mov    -0x7feb65c0(%ebx,%edi,4),%eax
    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
80107c37:	83 c7 01             	add    $0x1,%edi
        swap_slots[slot_num].proc_pte_refs[i] = pte;
80107c3a:	89 56 0c             	mov    %edx,0xc(%esi)
        swap_slots[slot_num].proc_pid_refs[i] = page_to_proc_pid_map[pa >> PTXSHIFT][i];
80107c3d:	89 86 0c 01 00 00    	mov    %eax,0x10c(%esi)
        *pte = (slot_num << PTXSHIFT) | PTE_FLAGS(*pte) | PTE_SW;
80107c43:	8b 02                	mov    (%edx),%eax
80107c45:	25 fe 0f 00 00       	and    $0xffe,%eax
        *pte &= (~PTE_P);
80107c4a:	09 c8                	or     %ecx,%eax
80107c4c:	83 c8 08             	or     $0x8,%eax
80107c4f:	89 02                	mov    %eax,(%edx)
	update_rss(swap_slots[slot_num].proc_pid_refs[i], -PGSIZE);
80107c51:	68 00 f0 ff ff       	push   $0xfffff000
80107c56:	ff b6 0c 01 00 00    	push   0x10c(%esi)
80107c5c:	e8 5f ca ff ff       	call   801046c0 <update_rss>
    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
80107c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c64:	83 c4 10             	add    $0x10,%esp
80107c67:	3b 78 0c             	cmp    0xc(%eax),%edi
80107c6a:	72 b4                	jb     80107c20 <swap_info_on_hdr+0x50>
80107c6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
    }
	page_to_ref_cnt[pa >> PTXSHIFT] = 0; // no longer on the memory
80107c6f:	c7 04 95 40 9a 1c 80 	movl   $0x0,-0x7fe365c0(,%edx,4)
80107c76:	00 00 00 00 
}
80107c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c7d:	5b                   	pop    %ebx
80107c7e:	5e                   	pop    %esi
80107c7f:	5f                   	pop    %edi
80107c80:	5d                   	pop    %ebp
80107c81:	c3                   	ret
80107c82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107c90 <get_hdrs_from_disk>:

void get_hdrs_from_disk(uint pa, uint slot_num)
{
80107c90:	55                   	push   %ebp
80107c91:	89 e5                	mov    %esp,%ebp
80107c93:	57                   	push   %edi
80107c94:	56                   	push   %esi
80107c95:	53                   	push   %ebx
80107c96:	83 ec 1c             	sub    $0x1c,%esp
    page_to_ref_cnt[pa >> PTXSHIFT]  = swap_slots[slot_num].refcnt_to_disk;
80107c99:	69 7d 0c 10 02 00 00 	imul   $0x210,0xc(%ebp),%edi
80107ca0:	8b 75 08             	mov    0x8(%ebp),%esi
80107ca3:	c1 ee 0c             	shr    $0xc,%esi
80107ca6:	8b 87 4c 61 11 80    	mov    -0x7fee9eb4(%edi),%eax
80107cac:	89 04 b5 40 9a 1c 80 	mov    %eax,-0x7fe365c0(,%esi,4)
    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
80107cb3:	85 c0                	test   %eax,%eax
80107cb5:	74 63                	je     80107d1a <get_hdrs_from_disk+0x8a>
80107cb7:	8d 8f 40 61 11 80    	lea    -0x7fee9ec0(%edi),%ecx
80107cbd:	c1 e6 08             	shl    $0x8,%esi
80107cc0:	89 f8                	mov    %edi,%eax
80107cc2:	31 db                	xor    %ebx,%ebx
80107cc4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107cc7:	89 f7                	mov    %esi,%edi
80107cc9:	89 c6                	mov    %eax,%esi
80107ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ccf:	90                   	nop
        pte_t *pte = swap_slots[slot_num].proc_pte_refs[i];
80107cd0:	8b 94 9e 50 61 11 80 	mov    -0x7fee9eb0(%esi,%ebx,4),%edx
        *pte = pa | (PTE_FLAGS(*pte)) | PTE_P;
        *pte &= ~PTE_SW;
        page_to_ptes_map[pa >> PTXSHIFT][i] = pte;
        page_to_proc_pid_map[pa >> PTXSHIFT][i] = swap_slots[slot_num].proc_pid_refs[i];
	update_rss(swap_slots[slot_num].proc_pid_refs[i], PGSIZE);
80107cd7:	83 ec 08             	sub    $0x8,%esp
        *pte = pa | (PTE_FLAGS(*pte)) | PTE_P;
80107cda:	8b 02                	mov    (%edx),%eax
80107cdc:	25 ff 0f 00 00       	and    $0xfff,%eax
80107ce1:	0b 45 08             	or     0x8(%ebp),%eax
        *pte &= ~PTE_SW;
80107ce4:	83 e0 f7             	and    $0xfffffff7,%eax
80107ce7:	83 c8 01             	or     $0x1,%eax
80107cea:	89 02                	mov    %eax,(%edx)
        page_to_proc_pid_map[pa >> PTXSHIFT][i] = swap_slots[slot_num].proc_pid_refs[i];
80107cec:	8b 84 9e 50 62 11 80 	mov    -0x7fee9db0(%esi,%ebx,4),%eax
        page_to_ptes_map[pa >> PTXSHIFT][i] = pte;
80107cf3:	89 94 9f 40 9a 18 80 	mov    %edx,-0x7fe765c0(%edi,%ebx,4)
        page_to_proc_pid_map[pa >> PTXSHIFT][i] = swap_slots[slot_num].proc_pid_refs[i];
80107cfa:	89 84 9f 40 9a 14 80 	mov    %eax,-0x7feb65c0(%edi,%ebx,4)
    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
80107d01:	83 c3 01             	add    $0x1,%ebx
	update_rss(swap_slots[slot_num].proc_pid_refs[i], PGSIZE);
80107d04:	68 00 10 00 00       	push   $0x1000
80107d09:	50                   	push   %eax
80107d0a:	e8 b1 c9 ff ff       	call   801046c0 <update_rss>
    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
80107d0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d12:	83 c4 10             	add    $0x10,%esp
80107d15:	3b 58 0c             	cmp    0xc(%eax),%ebx
80107d18:	72 b6                	jb     80107cd0 <get_hdrs_from_disk+0x40>
    }
}
80107d1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d1d:	5b                   	pop    %ebx
80107d1e:	5e                   	pop    %esi
80107d1f:	5f                   	pop    %edi
80107d20:	5d                   	pop    %ebp
80107d21:	c3                   	ret
80107d22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107d30 <inc_refcnt_in_memory>:
  }
  return &pgtab[PTX(va)];
}


void inc_refcnt_in_memory(uint pa, pte_t* pte, int pid){
80107d30:	55                   	push   %ebp
80107d31:	89 e5                	mov    %esp,%ebp
80107d33:	56                   	push   %esi
    page_to_ptes_map[pa >> PTXSHIFT][page_to_ref_cnt[pa >> PTXSHIFT]] = pte;
80107d34:	8b 45 08             	mov    0x8(%ebp),%eax
80107d37:	8b 75 0c             	mov    0xc(%ebp),%esi
void inc_refcnt_in_memory(uint pa, pte_t* pte, int pid){
80107d3a:	53                   	push   %ebx
80107d3b:	8b 5d 10             	mov    0x10(%ebp),%ebx
    page_to_proc_pid_map[pa >> PTXSHIFT][page_to_ref_cnt[pa >> PTXSHIFT]] = pid;
    page_to_ref_cnt[pa >> PTXSHIFT] += 1;
    update_rss(pid, PGSIZE);
80107d3e:	c7 45 0c 00 10 00 00 	movl   $0x1000,0xc(%ebp)
    page_to_ptes_map[pa >> PTXSHIFT][page_to_ref_cnt[pa >> PTXSHIFT]] = pte;
80107d45:	c1 e8 0c             	shr    $0xc,%eax
80107d48:	8b 14 85 40 9a 1c 80 	mov    -0x7fe365c0(,%eax,4),%edx
80107d4f:	89 c1                	mov    %eax,%ecx
    update_rss(pid, PGSIZE);
80107d51:	89 5d 08             	mov    %ebx,0x8(%ebp)
    page_to_ptes_map[pa >> PTXSHIFT][page_to_ref_cnt[pa >> PTXSHIFT]] = pte;
80107d54:	c1 e1 06             	shl    $0x6,%ecx
80107d57:	01 d1                	add    %edx,%ecx
    page_to_ref_cnt[pa >> PTXSHIFT] += 1;
80107d59:	83 c2 01             	add    $0x1,%edx
    page_to_ptes_map[pa >> PTXSHIFT][page_to_ref_cnt[pa >> PTXSHIFT]] = pte;
80107d5c:	89 34 8d 40 9a 18 80 	mov    %esi,-0x7fe765c0(,%ecx,4)
    page_to_proc_pid_map[pa >> PTXSHIFT][page_to_ref_cnt[pa >> PTXSHIFT]] = pid;
80107d63:	89 1c 8d 40 9a 14 80 	mov    %ebx,-0x7feb65c0(,%ecx,4)
}
80107d6a:	5b                   	pop    %ebx
80107d6b:	5e                   	pop    %esi
80107d6c:	5d                   	pop    %ebp
    page_to_ref_cnt[pa >> PTXSHIFT] += 1;
80107d6d:	89 14 85 40 9a 1c 80 	mov    %edx,-0x7fe365c0(,%eax,4)
    update_rss(pid, PGSIZE);
80107d74:	e9 47 c9 ff ff       	jmp    801046c0 <update_rss>
80107d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107d80 <inc_refcnt_in_hdr>:


void inc_refcnt_in_hdr(int slot_no_i, pte_t *pte, int pid)
{
80107d80:	55                   	push   %ebp
80107d81:	89 e5                	mov    %esp,%ebp
80107d83:	53                   	push   %ebx
80107d84:	8b 45 08             	mov    0x8(%ebp),%eax
    swap_slots[slot_no_i].proc_pte_refs[swap_slots[slot_no_i].refcnt_to_disk] = pte;
80107d87:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80107d8a:	69 d0 10 02 00 00    	imul   $0x210,%eax,%edx
80107d90:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
80107d96:	8b 8a 4c 61 11 80    	mov    -0x7fee9eb4(%edx),%ecx
80107d9c:	01 c8                	add    %ecx,%eax
    swap_slots[slot_no_i].proc_pid_refs[swap_slots[slot_no_i].refcnt_to_disk] = pid;
    swap_slots[slot_no_i].refcnt_to_disk += 1;
80107d9e:	83 c1 01             	add    $0x1,%ecx
    swap_slots[slot_no_i].proc_pte_refs[swap_slots[slot_no_i].refcnt_to_disk] = pte;
80107da1:	89 1c 85 50 61 11 80 	mov    %ebx,-0x7fee9eb0(,%eax,4)
    swap_slots[slot_no_i].proc_pid_refs[swap_slots[slot_no_i].refcnt_to_disk] = pid;
80107da8:	8b 5d 10             	mov    0x10(%ebp),%ebx
    swap_slots[slot_no_i].refcnt_to_disk += 1;
80107dab:	89 8a 4c 61 11 80    	mov    %ecx,-0x7fee9eb4(%edx)
    swap_slots[slot_no_i].proc_pid_refs[swap_slots[slot_no_i].refcnt_to_disk] = pid;
80107db1:	89 1c 85 50 62 11 80 	mov    %ebx,-0x7fee9db0(,%eax,4)
}
80107db8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107dbb:	c9                   	leave
80107dbc:	c3                   	ret
80107dbd:	8d 76 00             	lea    0x0(%esi),%esi

80107dc0 <dec_refcnt_in_memory>:
void dec_refcnt_in_memory(uint pa, pte_t* pte)
{
80107dc0:	55                   	push   %ebp
80107dc1:	89 e5                	mov    %esp,%ebp
80107dc3:	57                   	push   %edi
80107dc4:	56                   	push   %esi
80107dc5:	53                   	push   %ebx
80107dc6:	83 ec 0c             	sub    $0xc,%esp
    for (int i = 0; i < page_to_ref_cnt[pa>>PTXSHIFT]; i++){
80107dc9:	8b 7d 08             	mov    0x8(%ebp),%edi
{
80107dcc:	8b 55 0c             	mov    0xc(%ebp),%edx
    for (int i = 0; i < page_to_ref_cnt[pa>>PTXSHIFT]; i++){
80107dcf:	c1 ef 0c             	shr    $0xc,%edi
80107dd2:	8b 04 bd 40 9a 1c 80 	mov    -0x7fe365c0(,%edi,4),%eax
80107dd9:	85 c0                	test   %eax,%eax
80107ddb:	0f 84 80 00 00 00    	je     80107e61 <dec_refcnt_in_memory+0xa1>
80107de1:	89 f9                	mov    %edi,%ecx
80107de3:	31 db                	xor    %ebx,%ebx
80107de5:	c1 e1 08             	shl    $0x8,%ecx
80107de8:	eb 0d                	jmp    80107df7 <dec_refcnt_in_memory+0x37>
80107dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107df0:	83 c3 01             	add    $0x1,%ebx
80107df3:	39 c3                	cmp    %eax,%ebx
80107df5:	74 6a                	je     80107e61 <dec_refcnt_in_memory+0xa1>
        if (page_to_ptes_map[pa>>PTXSHIFT][i] == pte){
80107df7:	39 94 99 40 9a 18 80 	cmp    %edx,-0x7fe765c0(%ecx,%ebx,4)
80107dfe:	75 f0                	jne    80107df0 <dec_refcnt_in_memory+0x30>
		update_rss(page_to_proc_pid_map[pa >> PTXSHIFT][i], -PGSIZE);
80107e00:	89 f8                	mov    %edi,%eax
80107e02:	83 ec 08             	sub    $0x8,%esp
80107e05:	c1 e0 06             	shl    $0x6,%eax
80107e08:	68 00 f0 ff ff       	push   $0xfffff000
80107e0d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107e10:	ff 34 b5 40 9a 14 80 	push   -0x7feb65c0(,%esi,4)
80107e17:	e8 a4 c8 ff ff       	call   801046c0 <update_rss>
		for (int j = i; j < page_to_ref_cnt[pa >> PTXSHIFT] - 1; j++)
80107e1c:	8b 04 bd 40 9a 1c 80 	mov    -0x7fe365c0(,%edi,4),%eax
80107e23:	83 c4 10             	add    $0x10,%esp
80107e26:	8d 48 ff             	lea    -0x1(%eax),%ecx
80107e29:	39 cb                	cmp    %ecx,%ebx
80107e2b:	73 2d                	jae    80107e5a <dec_refcnt_in_memory+0x9a>
80107e2d:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
80107e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		{
			// shift to left
			page_to_ptes_map[pa >> PTXSHIFT][j] = page_to_ptes_map[pa >> PTXSHIFT][j + 1];
80107e38:	8b 90 44 9a 18 80    	mov    -0x7fe765bc(%eax),%edx
80107e3e:	83 c3 01             	add    $0x1,%ebx
		for (int j = i; j < page_to_ref_cnt[pa >> PTXSHIFT] - 1; j++)
80107e41:	83 c0 04             	add    $0x4,%eax
			page_to_ptes_map[pa >> PTXSHIFT][j] = page_to_ptes_map[pa >> PTXSHIFT][j + 1];
80107e44:	89 90 3c 9a 18 80    	mov    %edx,-0x7fe765c4(%eax)
			page_to_proc_pid_map[pa >> PTXSHIFT][j] = page_to_proc_pid_map[pa >> PTXSHIFT][j + 1];
80107e4a:	8b 90 40 9a 14 80    	mov    -0x7feb65c0(%eax),%edx
80107e50:	89 90 3c 9a 14 80    	mov    %edx,-0x7feb65c4(%eax)
		for (int j = i; j < page_to_ref_cnt[pa >> PTXSHIFT] - 1; j++)
80107e56:	39 cb                	cmp    %ecx,%ebx
80107e58:	72 de                	jb     80107e38 <dec_refcnt_in_memory+0x78>
		}
		page_to_ref_cnt[pa >> PTXSHIFT] -= 1;
80107e5a:	89 0c bd 40 9a 1c 80 	mov    %ecx,-0x7fe365c0(,%edi,4)
		return;
        }
    }
// 	panic("pte not found in decrementing");

}
80107e61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e64:	5b                   	pop    %ebx
80107e65:	5e                   	pop    %esi
80107e66:	5f                   	pop    %edi
80107e67:	5d                   	pop    %ebp
80107e68:	c3                   	ret
80107e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107e70 <dec_refcnt_in_hdr>:

void dec_refcnt_in_hdr(int slot_no_i, pte_t *pte)
{
80107e70:	55                   	push   %ebp
80107e71:	89 e5                	mov    %esp,%ebp
80107e73:	56                   	push   %esi
80107e74:	53                   	push   %ebx
80107e75:	8b 5d 08             	mov    0x8(%ebp),%ebx
80107e78:	8b 75 0c             	mov    0xc(%ebp),%esi

    for (int i = 0; i < swap_slots[slot_no_i].refcnt_to_disk; i++)
80107e7b:	69 cb 10 02 00 00    	imul   $0x210,%ebx,%ecx
80107e81:	8b 91 4c 61 11 80    	mov    -0x7fee9eb4(%ecx),%edx
80107e87:	85 d2                	test   %edx,%edx
80107e89:	7e 61                	jle    80107eec <dec_refcnt_in_hdr+0x7c>
80107e8b:	31 c0                	xor    %eax,%eax
80107e8d:	eb 08                	jmp    80107e97 <dec_refcnt_in_hdr+0x27>
80107e8f:	90                   	nop
80107e90:	83 c0 01             	add    $0x1,%eax
80107e93:	39 d0                	cmp    %edx,%eax
80107e95:	74 55                	je     80107eec <dec_refcnt_in_hdr+0x7c>
    {
        if (swap_slots[slot_no_i].proc_pte_refs[i] == pte)
80107e97:	39 b4 81 50 61 11 80 	cmp    %esi,-0x7fee9eb0(%ecx,%eax,4)
80107e9e:	75 f0                	jne    80107e90 <dec_refcnt_in_hdr+0x20>
        {
		      
		for (int j = i; j < swap_slots[slot_no_i].refcnt_to_disk - 1; j++)
80107ea0:	8d 4a ff             	lea    -0x1(%edx),%ecx
80107ea3:	39 c1                	cmp    %eax,%ecx
80107ea5:	7e 49                	jle    80107ef0 <dec_refcnt_in_hdr+0x80>
80107ea7:	69 f3 84 00 00 00    	imul   $0x84,%ebx,%esi
80107ead:	8d 44 06 04          	lea    0x4(%esi,%eax,1),%eax
80107eb1:	01 f2                	add    %esi,%edx
80107eb3:	8d 04 85 40 61 11 80 	lea    -0x7fee9ec0(,%eax,4),%eax
80107eba:	8d 34 95 4c 61 11 80 	lea    -0x7fee9eb4(,%edx,4),%esi
80107ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		{
			// shift to left
			swap_slots[slot_no_i].proc_pid_refs[j] = swap_slots[slot_no_i].proc_pid_refs[j + 1];
80107ec8:	8b 90 04 01 00 00    	mov    0x104(%eax),%edx
		for (int j = i; j < swap_slots[slot_no_i].refcnt_to_disk - 1; j++)
80107ece:	83 c0 04             	add    $0x4,%eax
			swap_slots[slot_no_i].proc_pid_refs[j] = swap_slots[slot_no_i].proc_pid_refs[j + 1];
80107ed1:	89 90 fc 00 00 00    	mov    %edx,0xfc(%eax)
			swap_slots[slot_no_i].proc_pte_refs[j] = swap_slots[slot_no_i].proc_pte_refs[j + 1];
80107ed7:	8b 10                	mov    (%eax),%edx
80107ed9:	89 50 fc             	mov    %edx,-0x4(%eax)
		for (int j = i; j < swap_slots[slot_no_i].refcnt_to_disk - 1; j++)
80107edc:	39 f0                	cmp    %esi,%eax
80107ede:	75 e8                	jne    80107ec8 <dec_refcnt_in_hdr+0x58>
		}
		swap_slots[slot_no_i].refcnt_to_disk -= 1;
80107ee0:	69 db 10 02 00 00    	imul   $0x210,%ebx,%ebx
80107ee6:	89 8b 4c 61 11 80    	mov    %ecx,-0x7fee9eb4(%ebx)
        }

    }
	// cprintf("%x %x\n", pte, *pte);
	// panic("pte not found in decrementing");
}
80107eec:	5b                   	pop    %ebx
80107eed:	5e                   	pop    %esi
80107eee:	5d                   	pop    %ebp
80107eef:	c3                   	ret
		swap_slots[slot_no_i].refcnt_to_disk -= 1;
80107ef0:	69 db 10 02 00 00    	imul   $0x210,%ebx,%ebx
80107ef6:	89 8b 4c 61 11 80    	mov    %ecx,-0x7fee9eb4(%ebx)
		if (swap_slots[slot_no_i].refcnt_to_disk == 0)
80107efc:	85 c9                	test   %ecx,%ecx
80107efe:	75 ec                	jne    80107eec <dec_refcnt_in_hdr+0x7c>
			swap_slots[slot_no_i].is_free = FREE;
80107f00:	c7 83 40 61 11 80 01 	movl   $0x1,-0x7fee9ec0(%ebx)
80107f07:	00 00 00 
}
80107f0a:	5b                   	pop    %ebx
80107f0b:	5e                   	pop    %esi
80107f0c:	5d                   	pop    %ebp
80107f0d:	c3                   	ret
80107f0e:	66 90                	xchg   %ax,%ax

80107f10 <get_refcnt>:

uint get_refcnt(uint pa)
{
80107f10:	55                   	push   %ebp
80107f11:	89 e5                	mov    %esp,%ebp
    return page_to_ref_cnt[pa >> PTXSHIFT];
80107f13:	8b 45 08             	mov    0x8(%ebp),%eax
}
80107f16:	5d                   	pop    %ebp
    return page_to_ref_cnt[pa >> PTXSHIFT];
80107f17:	c1 e8 0c             	shr    $0xc,%eax
80107f1a:	8b 04 85 40 9a 1c 80 	mov    -0x7fe365c0(,%eax,4),%eax
}
80107f21:	c3                   	ret
80107f22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107f30 <init_refcnt>:

void init_refcnt(uint pa)
{
80107f30:	55                   	push   %ebp
80107f31:	89 e5                	mov    %esp,%ebp
    page_to_ref_cnt[pa >> PTXSHIFT] = 0;
80107f33:	8b 45 08             	mov    0x8(%ebp),%eax
}
80107f36:	5d                   	pop    %ebp
    page_to_ref_cnt[pa >> PTXSHIFT] = 0;
80107f37:	c1 e8 0c             	shr    $0xc,%eax
80107f3a:	c7 04 85 40 9a 1c 80 	movl   $0x0,-0x7fe365c0(,%eax,4)
80107f41:	00 00 00 00 
}
80107f45:	c3                   	ret
80107f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f4d:	8d 76 00             	lea    0x0(%esi),%esi

80107f50 <swap_out>:

void swap_out(){
80107f50:	55                   	push   %ebp
80107f51:	89 e5                	mov    %esp,%ebp
80107f53:	57                   	push   %edi
80107f54:	56                   	push   %esi
80107f55:	53                   	push   %ebx
80107f56:	83 ec 0c             	sub    $0xc,%esp
	// int * page_to_refcnt = get_refcnt_table();
	// cprintf("here\n");
	pte_t* pte = final_page();
80107f59:	e8 d2 c6 ff ff       	call   80104630 <final_page>
	if(pte == 0){
80107f5e:	85 c0                	test   %eax,%eax
80107f60:	74 77                	je     80107fd9 <swap_out+0x89>
80107f62:	ba 40 61 11 80       	mov    $0x80116140,%edx
		panic("No page to swap out\n");
	}
	// cprintf("here2\n");
	for(int i = 0 ; i < NPAGE; i++){
80107f67:	31 db                	xor    %ebx,%ebx
80107f69:	eb 16                	jmp    80107f81 <swap_out+0x31>
80107f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107f6f:	90                   	nop
80107f70:	83 c3 01             	add    $0x1,%ebx
80107f73:	81 c2 10 02 00 00    	add    $0x210,%edx
80107f79:	81 fb 90 01 00 00    	cmp    $0x190,%ebx
80107f7f:	74 4b                	je     80107fcc <swap_out+0x7c>
		if(swap_slots[i].is_free == FREE){
80107f81:	83 3a 01             	cmpl   $0x1,(%edx)
80107f84:	75 ea                	jne    80107f70 <swap_out+0x20>
			swap_slots[i].is_free = NOT_FREE;
80107f86:	69 d3 10 02 00 00    	imul   $0x210,%ebx,%edx
			char* va = P2V(PTE_ADDR(*pte));
			write_page_to_swap(swap_slots[i].blockno, va);
80107f8c:	83 ec 08             	sub    $0x8,%esp
			swap_slots[i].is_free = NOT_FREE;
80107f8f:	c7 82 40 61 11 80 00 	movl   $0x0,-0x7fee9ec0(%edx)
80107f96:	00 00 00 
			char* va = P2V(PTE_ADDR(*pte));
80107f99:	8b 30                	mov    (%eax),%esi
80107f9b:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80107fa1:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
			write_page_to_swap(swap_slots[i].blockno, va);
80107fa7:	57                   	push   %edi
80107fa8:	ff b2 48 61 11 80    	push   -0x7fee9eb8(%edx)
80107fae:	e8 cd 82 ff ff       	call   80100280 <write_page_to_swap>
			swap_info_on_hdr(V2P(va), i);
80107fb3:	58                   	pop    %eax
80107fb4:	5a                   	pop    %edx
80107fb5:	53                   	push   %ebx
80107fb6:	56                   	push   %esi
80107fb7:	e8 14 fc ff ff       	call   80107bd0 <swap_info_on_hdr>
			// int refcnt = page_to_refcnt[pa >> PTXSHIFT];
			// this is needed because when we are swapping out a page that is referred to by 
			// multiple page table entries, we need to free the page only when all the references are gone
			// swap_slots[i].refcnt_to_disk = refcnt;
			// for(int i = 0 ; i < refcnt; i++){
			kfree(va);
80107fbc:	89 3c 24             	mov    %edi,(%esp)
80107fbf:	e8 dc a5 ff ff       	call   801025a0 <kfree>
			// }
			return;
		}
	}
	panic("Swap full\n");
}
80107fc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fc7:	5b                   	pop    %ebx
80107fc8:	5e                   	pop    %esi
80107fc9:	5f                   	pop    %edi
80107fca:	5d                   	pop    %ebp
80107fcb:	c3                   	ret
	panic("Swap full\n");
80107fcc:	83 ec 0c             	sub    $0xc,%esp
80107fcf:	68 3a 88 10 80       	push   $0x8010883a
80107fd4:	e8 97 84 ff ff       	call   80100470 <panic>
		panic("No page to swap out\n");
80107fd9:	83 ec 0c             	sub    $0xc,%esp
80107fdc:	68 25 88 10 80       	push   $0x80108825
80107fe1:	e8 8a 84 ff ff       	call   80100470 <panic>
80107fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fed:	8d 76 00             	lea    0x0(%esi),%esi

80107ff0 <cow_page>:
// the following function is called when a copy is needed to be created for the page pointed to by pte
// constratin : pte is present in the pagetable
void cow_page(pte_t * pte){
80107ff0:	55                   	push   %ebp
80107ff1:	89 e5                	mov    %esp,%ebp
80107ff3:	57                   	push   %edi
80107ff4:	56                   	push   %esi
80107ff5:	53                   	push   %ebx
80107ff6:	83 ec 0c             	sub    $0xc,%esp
80107ff9:	8b 75 08             	mov    0x8(%ebp),%esi
	char * copy_mem = kalloc();
80107ffc:	e8 af a7 ff ff       	call   801027b0 <kalloc>
80108001:	89 c3                	mov    %eax,%ebx
	int * page_to_refcnt = get_refcnt_table();
80108003:	e8 88 a5 ff ff       	call   80102590 <get_refcnt_table>
	// allocating new page using kalloc
	if(copy_mem == 0){
80108008:	85 db                	test   %ebx,%ebx
8010800a:	74 7e                	je     8010808a <cow_page+0x9a>
8010800c:	89 c7                	mov    %eax,%edi
		panic("kalloc failing in cow_page\n");
	}
	// whe arent we setting the refcnt of the new page to 1
	cprintf("before refcnt = %d", page_to_refcnt[(*pte) >> PTXSHIFT]);
8010800e:	8b 06                	mov    (%esi),%eax
80108010:	83 ec 08             	sub    $0x8,%esp
80108013:	c1 e8 0c             	shr    $0xc,%eax
80108016:	ff 34 87             	push   (%edi,%eax,4)
80108019:	68 61 88 10 80       	push   $0x80108861
8010801e:	e8 7d 87 ff ff       	call   801007a0 <cprintf>
	page_to_refcnt[(*pte) >> PTXSHIFT]--;
80108023:	8b 06                	mov    (%esi),%eax
80108025:	c1 e8 0c             	shr    $0xc,%eax
80108028:	83 2c 87 01          	subl   $0x1,(%edi,%eax,4)
	cprintf("after refcnt = %d", page_to_refcnt[(*pte) >> PTXSHIFT]);
8010802c:	58                   	pop    %eax
8010802d:	8b 06                	mov    (%esi),%eax
8010802f:	5a                   	pop    %edx
80108030:	c1 e8 0c             	shr    $0xc,%eax
80108033:	ff 34 87             	push   (%edi,%eax,4)
80108036:	68 74 88 10 80       	push   $0x80108874
8010803b:	e8 60 87 ff ff       	call   801007a0 <cprintf>

	memmove(copy_mem, (char*)P2V(PTE_ADDR(*pte)), PGSIZE);
80108040:	83 c4 0c             	add    $0xc,%esp
80108043:	68 00 10 00 00       	push   $0x1000
80108048:	8b 06                	mov    (%esi),%eax
8010804a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010804f:	05 00 00 00 80       	add    $0x80000000,%eax
80108054:	50                   	push   %eax
80108055:	53                   	push   %ebx
	// now modify the pgdir
	*pte = V2P(copy_mem) | PTE_FLAGS(*pte) | PTE_W;
80108056:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
	memmove(copy_mem, (char*)P2V(PTE_ADDR(*pte)), PGSIZE);
8010805c:	e8 3f cb ff ff       	call   80104ba0 <memmove>
	*pte = V2P(copy_mem) | PTE_FLAGS(*pte) | PTE_W;
80108061:	8b 06                	mov    (%esi),%eax
80108063:	25 ff 0f 00 00       	and    $0xfff,%eax
80108068:	09 c3                	or     %eax,%ebx
8010806a:	83 cb 02             	or     $0x2,%ebx
8010806d:	89 1e                	mov    %ebx,(%esi)
	lcr3(V2P(myproc()->pgdir));
8010806f:	e8 9c ba ff ff       	call   80103b10 <myproc>
80108074:	8b 40 08             	mov    0x8(%eax),%eax
80108077:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010807c:	0f 22 d8             	mov    %eax,%cr3

}
8010807f:	83 c4 10             	add    $0x10,%esp
80108082:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108085:	5b                   	pop    %ebx
80108086:	5e                   	pop    %esi
80108087:	5f                   	pop    %edi
80108088:	5d                   	pop    %ebp
80108089:	c3                   	ret
		panic("kalloc failing in cow_page\n");
8010808a:	83 ec 0c             	sub    $0xc,%esp
8010808d:	68 45 88 10 80       	push   $0x80108845
80108092:	e8 d9 83 ff ff       	call   80100470 <panic>
80108097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010809e:	66 90                	xchg   %ax,%ax

801080a0 <clear_slot>:

void clear_slot(pte_t* page){
801080a0:	55                   	push   %ebp
801080a1:	89 e5                	mov    %esp,%ebp
	int blockno = PTE_ADDR(*page) >> PTXSHIFT;
801080a3:	8b 45 08             	mov    0x8(%ebp),%eax
	swap_slots[(blockno - SWAPBASE) / BPPAGE].is_free = FREE;
}
801080a6:	5d                   	pop    %ebp
	int blockno = PTE_ADDR(*page) >> PTXSHIFT;
801080a7:	8b 10                	mov    (%eax),%edx
801080a9:	c1 ea 0c             	shr    $0xc,%edx
	swap_slots[(blockno - SWAPBASE) / BPPAGE].is_free = FREE;
801080ac:	8d 42 05             	lea    0x5(%edx),%eax
801080af:	83 ea 02             	sub    $0x2,%edx
801080b2:	0f 49 c2             	cmovns %edx,%eax
801080b5:	c1 f8 03             	sar    $0x3,%eax
801080b8:	69 c0 10 02 00 00    	imul   $0x210,%eax,%eax
801080be:	c7 80 40 61 11 80 01 	movl   $0x1,-0x7fee9ec0(%eax)
801080c5:	00 00 00 
}
801080c8:	c3                   	ret
801080c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801080d0 <dec_swap_slot_refcnt>:
int dec_swap_slot_refcnt(pte_t * pte){
801080d0:	55                   	push   %ebp
801080d1:	89 e5                	mov    %esp,%ebp
801080d3:	83 ec 08             	sub    $0x8,%esp
	int blockno = PTE_ADDR(*pte) >> PTXSHIFT;
801080d6:	8b 45 08             	mov    0x8(%ebp),%eax
801080d9:	8b 00                	mov    (%eax),%eax
801080db:	c1 e8 0c             	shr    $0xc,%eax
	int x = swap_slots[(blockno - SWAPBASE) / BPPAGE].refcnt_to_disk;
801080de:	8d 50 05             	lea    0x5(%eax),%edx
801080e1:	83 e8 02             	sub    $0x2,%eax
801080e4:	0f 49 d0             	cmovns %eax,%edx
801080e7:	c1 fa 03             	sar    $0x3,%edx
801080ea:	69 d2 10 02 00 00    	imul   $0x210,%edx,%edx
801080f0:	81 c2 40 61 11 80    	add    $0x80116140,%edx
801080f6:	8b 42 0c             	mov    0xc(%edx),%eax
	if(x == 0){
801080f9:	85 c0                	test   %eax,%eax
801080fb:	74 08                	je     80108105 <dec_swap_slot_refcnt+0x35>
		panic("refcnt already 0\n");
	}
	return --(swap_slots[(blockno - SWAPBASE) / BPPAGE].refcnt_to_disk);
801080fd:	83 e8 01             	sub    $0x1,%eax
80108100:	89 42 0c             	mov    %eax,0xc(%edx)
};
80108103:	c9                   	leave
80108104:	c3                   	ret
		panic("refcnt already 0\n");
80108105:	83 ec 0c             	sub    $0xc,%esp
80108108:	68 86 88 10 80       	push   $0x80108886
8010810d:	e8 5e 83 ff ff       	call   80100470 <panic>
80108112:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108120 <handle_page_fault>:

void handle_page_fault(void)
{
80108120:	55                   	push   %ebp
80108121:	89 e5                	mov    %esp,%ebp
80108123:	57                   	push   %edi
80108124:	56                   	push   %esi
80108125:	53                   	push   %ebx
80108126:	83 ec 1c             	sub    $0x1c,%esp
  asm volatile("movl %%cr2,%0" : "=r" (val));
80108129:	0f 20 d3             	mov    %cr2,%ebx
    uint va = rcr2();
    pte_t *pte = walkpgdir(myproc()->pgdir, (void *)va, 0);
8010812c:	e8 df b9 ff ff       	call   80103b10 <myproc>
  pde = &pgdir[PDX(va)];
80108131:	89 da                	mov    %ebx,%edx
  if(*pde & PTE_P){
80108133:	8b 40 08             	mov    0x8(%eax),%eax
  pde = &pgdir[PDX(va)];
80108136:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80108139:	8b 04 90             	mov    (%eax,%edx,4),%eax
8010813c:	a8 01                	test   $0x1,%al
8010813e:	0f 84 ad 01 00 00    	je     801082f1 <handle_page_fault.cold>
  return &pgtab[PTX(va)];
80108144:	c1 eb 0a             	shr    $0xa,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108147:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
8010814c:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80108152:	8d b4 18 00 00 00 80 	lea    -0x80000000(%eax,%ebx,1),%esi
    if ((*pte & PTE_P))
80108159:	8b 1e                	mov    (%esi),%ebx
8010815b:	f6 c3 01             	test   $0x1,%bl
8010815e:	0f 84 e4 00 00 00    	je     80108248 <handle_page_fault+0x128>
    {
	// cow fault has occured
        if (!(*pte & PTE_W)){
80108164:	f6 c3 02             	test   $0x2,%bl
80108167:	0f 85 cd 00 00 00    	jne    8010823a <handle_page_fault+0x11a>
		char *mem;
		uint flags = PTE_FLAGS(*pte);
		uint pa = PTE_ADDR(*pte);
8010816d:	89 d8                	mov    %ebx,%eax
8010816f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108174:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return page_to_ref_cnt[pa >> PTXSHIFT];
80108177:	89 d8                	mov    %ebx,%eax
80108179:	c1 e8 0c             	shr    $0xc,%eax
		if (get_refcnt(pa) > 1){
8010817c:	83 3c 85 40 9a 1c 80 	cmpl   $0x1,-0x7fe365c0(,%eax,4)
80108183:	01 
    return page_to_ref_cnt[pa >> PTXSHIFT];
80108184:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (get_refcnt(pa) > 1){
80108187:	0f 86 0b 01 00 00    	jbe    80108298 <handle_page_fault+0x178>
			if ((mem = kalloc()) == 0){
8010818d:	e8 1e a6 ff ff       	call   801027b0 <kalloc>
80108192:	89 c7                	mov    %eax,%edi
80108194:	85 c0                	test   %eax,%eax
80108196:	0f 84 48 01 00 00    	je     801082e4 <handle_page_fault+0x1c4>
				panic("kalloc failed in handle page fault");
			}
			inc_refcnt_in_memory(V2P(mem), pte, myproc()->pid);
8010819c:	e8 6f b9 ff ff       	call   80103b10 <myproc>
    update_rss(pid, PGSIZE);
801081a1:	83 ec 08             	sub    $0x8,%esp
			inc_refcnt_in_memory(V2P(mem), pte, myproc()->pid);
801081a4:	8b 48 14             	mov    0x14(%eax),%ecx
801081a7:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
    page_to_ptes_map[pa >> PTXSHIFT][page_to_ref_cnt[pa >> PTXSHIFT]] = pte;
801081ad:	89 c2                	mov    %eax,%edx
			inc_refcnt_in_memory(V2P(mem), pte, myproc()->pid);
801081af:	89 45 e0             	mov    %eax,-0x20(%ebp)
    page_to_ptes_map[pa >> PTXSHIFT][page_to_ref_cnt[pa >> PTXSHIFT]] = pte;
801081b2:	c1 ea 0c             	shr    $0xc,%edx
801081b5:	89 d0                	mov    %edx,%eax
801081b7:	c1 e0 06             	shl    $0x6,%eax
801081ba:	03 04 95 40 9a 1c 80 	add    -0x7fe365c0(,%edx,4),%eax
801081c1:	89 34 85 40 9a 18 80 	mov    %esi,-0x7fe765c0(,%eax,4)
    page_to_proc_pid_map[pa >> PTXSHIFT][page_to_ref_cnt[pa >> PTXSHIFT]] = pid;
801081c8:	89 0c 85 40 9a 14 80 	mov    %ecx,-0x7feb65c0(,%eax,4)
    page_to_ref_cnt[pa >> PTXSHIFT] += 1;
801081cf:	8b 04 95 40 9a 1c 80 	mov    -0x7fe365c0(,%edx,4),%eax
801081d6:	83 c0 01             	add    $0x1,%eax
801081d9:	89 04 95 40 9a 1c 80 	mov    %eax,-0x7fe365c0(,%edx,4)
    update_rss(pid, PGSIZE);
801081e0:	68 00 10 00 00       	push   $0x1000
801081e5:	51                   	push   %ecx
801081e6:	e8 d5 c4 ff ff       	call   801046c0 <update_rss>
			if (*pte & PTE_P){
801081eb:	8b 06                	mov    (%esi),%eax
801081ed:	83 c4 10             	add    $0x10,%esp
801081f0:	a8 01                	test   $0x1,%al
801081f2:	0f 85 c0 00 00 00    	jne    801082b8 <handle_page_fault+0x198>
				// if in memory
				dec_refcnt_in_memory(pa, pte);
			}
			else if (*pte & PTE_SW)
801081f8:	a8 08                	test   $0x8,%al
801081fa:	0f 85 d0 00 00 00    	jne    801082d0 <handle_page_fault+0x1b0>
				// if swapped
				int slot_no_i = pa >> PTXSHIFT;
				dec_refcnt_in_hdr(slot_no_i, pte);
			}
			
			memmove(mem, (char *)P2V(pa), PGSIZE);
80108200:	83 ec 04             	sub    $0x4,%esp
		uint flags = PTE_FLAGS(*pte);
80108203:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
			memmove(mem, (char *)P2V(pa), PGSIZE);
80108209:	68 00 10 00 00       	push   $0x1000
8010820e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108211:	05 00 00 00 80       	add    $0x80000000,%eax
80108216:	50                   	push   %eax
80108217:	57                   	push   %edi
80108218:	e8 83 c9 ff ff       	call   80104ba0 <memmove>
			*pte = V2P(mem) | PTE_W | flags;
8010821d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108220:	09 c3                	or     %eax,%ebx
80108222:	83 cb 02             	or     $0x2,%ebx
80108225:	89 1e                	mov    %ebx,(%esi)
			lcr3(V2P(myproc()->pgdir));
80108227:	e8 e4 b8 ff ff       	call   80103b10 <myproc>
8010822c:	8b 40 08             	mov    0x8(%eax),%eax
8010822f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108234:	0f 22 d8             	mov    %eax,%cr3
			
			return;
80108237:	83 c4 10             	add    $0x10,%esp
            write_page_to_swap(swap_slots[slot_no_i].blockno, pg);
	    get_hdrs_from_disk(V2P(pg), slot_no_i);
        }

    }
8010823a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010823d:	5b                   	pop    %ebx
8010823e:	5e                   	pop    %esi
8010823f:	5f                   	pop    %edi
80108240:	5d                   	pop    %ebp
80108241:	c3                   	ret
80108242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (!(*pte & PTE_SW)){
80108248:	f6 c3 08             	test   $0x8,%bl
8010824b:	74 58                	je     801082a5 <handle_page_fault+0x185>
            int slot_no_i = (*pte) >> PTXSHIFT;
8010824d:	c1 eb 0c             	shr    $0xc,%ebx
            swap_slots[slot_no_i].is_free = FREE;
80108250:	69 c3 10 02 00 00    	imul   $0x210,%ebx,%eax
80108256:	c7 80 40 61 11 80 01 	movl   $0x1,-0x7fee9ec0(%eax)
8010825d:	00 00 00 
80108260:	8d b8 40 61 11 80    	lea    -0x7fee9ec0(%eax),%edi
            char *pg = kalloc();
80108266:	e8 45 a5 ff ff       	call   801027b0 <kalloc>
            write_page_to_swap(swap_slots[slot_no_i].blockno, pg);
8010826b:	83 ec 08             	sub    $0x8,%esp
8010826e:	50                   	push   %eax
            char *pg = kalloc();
8010826f:	89 c6                	mov    %eax,%esi
            write_page_to_swap(swap_slots[slot_no_i].blockno, pg);
80108271:	ff 77 08             	push   0x8(%edi)
	    get_hdrs_from_disk(V2P(pg), slot_no_i);
80108274:	81 c6 00 00 00 80    	add    $0x80000000,%esi
            write_page_to_swap(swap_slots[slot_no_i].blockno, pg);
8010827a:	e8 01 80 ff ff       	call   80100280 <write_page_to_swap>
	    get_hdrs_from_disk(V2P(pg), slot_no_i);
8010827f:	58                   	pop    %eax
80108280:	5a                   	pop    %edx
80108281:	53                   	push   %ebx
80108282:	56                   	push   %esi
80108283:	e8 08 fa ff ff       	call   80107c90 <get_hdrs_from_disk>
80108288:	83 c4 10             	add    $0x10,%esp
8010828b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010828e:	5b                   	pop    %ebx
8010828f:	5e                   	pop    %esi
80108290:	5f                   	pop    %edi
80108291:	5d                   	pop    %ebp
80108292:	c3                   	ret
80108293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108297:	90                   	nop
			*pte |= PTE_W;
80108298:	83 cb 02             	or     $0x2,%ebx
8010829b:	89 1e                	mov    %ebx,(%esi)
8010829d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082a0:	5b                   	pop    %ebx
801082a1:	5e                   	pop    %esi
801082a2:	5f                   	pop    %edi
801082a3:	5d                   	pop    %ebp
801082a4:	c3                   	ret
            panic("page not present nor swapped");
801082a5:	83 ec 0c             	sub    $0xc,%esp
801082a8:	68 98 88 10 80       	push   $0x80108898
801082ad:	e8 be 81 ff ff       	call   80100470 <panic>
801082b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				dec_refcnt_in_memory(pa, pte);
801082b8:	83 ec 08             	sub    $0x8,%esp
801082bb:	56                   	push   %esi
801082bc:	ff 75 e4             	push   -0x1c(%ebp)
801082bf:	e8 fc fa ff ff       	call   80107dc0 <dec_refcnt_in_memory>
801082c4:	83 c4 10             	add    $0x10,%esp
801082c7:	e9 34 ff ff ff       	jmp    80108200 <handle_page_fault+0xe0>
801082cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
				dec_refcnt_in_hdr(slot_no_i, pte);
801082d0:	83 ec 08             	sub    $0x8,%esp
801082d3:	56                   	push   %esi
801082d4:	ff 75 dc             	push   -0x24(%ebp)
801082d7:	e8 94 fb ff ff       	call   80107e70 <dec_refcnt_in_hdr>
801082dc:	83 c4 10             	add    $0x10,%esp
801082df:	e9 1c ff ff ff       	jmp    80108200 <handle_page_fault+0xe0>
				panic("kalloc failed in handle page fault");
801082e4:	83 ec 0c             	sub    $0xc,%esp
801082e7:	68 80 8a 10 80       	push   $0x80108a80
801082ec:	e8 7f 81 ff ff       	call   80100470 <panic>

801082f1 <handle_page_fault.cold>:
    if ((*pte & PTE_P))
801082f1:	a1 00 00 00 00       	mov    0x0,%eax
801082f6:	0f 0b                	ud2
