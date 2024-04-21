
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
80100028:	bc 00 84 11 80       	mov    $0x80118400,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 32 10 80       	mov    $0x80103210,%eax
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
8010004c:	68 60 7a 10 80       	push   $0x80107a60
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 b5 47 00 00       	call   80104810 <initlock>
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
80100092:	68 67 7a 10 80       	push   $0x80107a67
80100097:	50                   	push   %eax
80100098:	e8 43 46 00 00       	call   801046e0 <initsleeplock>
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
801000e4:	e8 17 49 00 00       	call   80104a00 <acquire>
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
80100162:	e8 39 48 00 00       	call   801049a0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 45 00 00       	call   80104720 <acquiresleep>
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
801001a1:	68 6e 7a 10 80       	push   $0x80107a6e
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
801001be:	e8 fd 45 00 00       	call   801047c0 <holdingsleep>
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
801001dc:	68 7f 7a 10 80       	push   $0x80107a7f
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
801001ff:	e8 bc 45 00 00       	call   801047c0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 6c 45 00 00       	call   80104780 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 e0 47 00 00       	call   80104a00 <acquire>
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
80100269:	e9 32 47 00 00       	jmp    801049a0 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 86 7a 10 80       	push   $0x80107a86
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
801002b2:	e8 d9 48 00 00       	call   80104b90 <memmove>
  if(!holdingsleep(&b->lock))
801002b7:	8d 47 0c             	lea    0xc(%edi),%eax
801002ba:	89 04 24             	mov    %eax,(%esp)
801002bd:	e8 fe 44 00 00       	call   801047c0 <holdingsleep>
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
801002fb:	68 7f 7a 10 80       	push   $0x80107a7f
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
8010034b:	e8 40 48 00 00       	call   80104b90 <memmove>
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
80100390:	e8 6b 46 00 00       	call   80104a00 <acquire>
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
801003bd:	e8 9e 3e 00 00       	call   80104260 <sleep>
    while(input.r == input.w){
801003c2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801003c7:	83 c4 10             	add    $0x10,%esp
801003ca:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801003d0:	75 36                	jne    80100408 <consoleread+0x98>
      if(myproc()->killed){
801003d2:	e8 59 37 00 00       	call   80103b30 <myproc>
801003d7:	8b 48 28             	mov    0x28(%eax),%ecx
801003da:	85 c9                	test   %ecx,%ecx
801003dc:	74 d2                	je     801003b0 <consoleread+0x40>
        release(&cons.lock);
801003de:	83 ec 0c             	sub    $0xc,%esp
801003e1:	68 20 ff 10 80       	push   $0x8010ff20
801003e6:	e8 b5 45 00 00       	call   801049a0 <release>
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
8010043c:	e8 5f 45 00 00       	call   801049a0 <release>
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
80100489:	e8 22 26 00 00       	call   80102ab0 <lapicid>
8010048e:	83 ec 08             	sub    $0x8,%esp
80100491:	50                   	push   %eax
80100492:	68 8d 7a 10 80       	push   $0x80107a8d
80100497:	e8 04 03 00 00       	call   801007a0 <cprintf>
  cprintf(s);
8010049c:	58                   	pop    %eax
8010049d:	ff 75 08             	push   0x8(%ebp)
801004a0:	e8 fb 02 00 00       	call   801007a0 <cprintf>
  cprintf("\n");
801004a5:	c7 04 24 46 7f 10 80 	movl   $0x80107f46,(%esp)
801004ac:	e8 ef 02 00 00       	call   801007a0 <cprintf>
  getcallerpcs(&s, pcs);
801004b1:	8d 45 08             	lea    0x8(%ebp),%eax
801004b4:	5a                   	pop    %edx
801004b5:	59                   	pop    %ecx
801004b6:	53                   	push   %ebx
801004b7:	50                   	push   %eax
801004b8:	e8 73 43 00 00       	call   80104830 <getcallerpcs>
  for(i=0; i<10; i++)
801004bd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801004c0:	83 ec 08             	sub    $0x8,%esp
801004c3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801004c5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801004c8:	68 a1 7a 10 80       	push   $0x80107aa1
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
8010050f:	e8 4c 5c 00 00       	call   80106160 <uartputc>
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
801005da:	e8 81 5b 00 00       	call   80106160 <uartputc>
801005df:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801005e6:	e8 75 5b 00 00       	call   80106160 <uartputc>
801005eb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801005f2:	e8 69 5b 00 00       	call   80106160 <uartputc>
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
80100651:	e8 3a 45 00 00       	call   80104b90 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100656:	b8 80 07 00 00       	mov    $0x780,%eax
8010065b:	83 c4 0c             	add    $0xc,%esp
8010065e:	29 d8                	sub    %ebx,%eax
80100660:	01 c0                	add    %eax,%eax
80100662:	50                   	push   %eax
80100663:	6a 00                	push   $0x0
80100665:	56                   	push   %esi
80100666:	e8 95 44 00 00       	call   80104b00 <memset>
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
80100693:	68 a5 7a 10 80       	push   $0x80107aa5
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
801006bb:	e8 40 43 00 00       	call   80104a00 <acquire>
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
801006f4:	e8 a7 42 00 00       	call   801049a0 <release>
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
8010073b:	0f b6 92 5c 80 10 80 	movzbl -0x7fef7fa4(%edx),%edx
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
801008c8:	e8 33 41 00 00       	call   80104a00 <acquire>
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
801008eb:	e8 b0 40 00 00       	call   801049a0 <release>
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
8010092d:	bf b8 7a 10 80       	mov    $0x80107ab8,%edi
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
8010097c:	68 bf 7a 10 80       	push   $0x80107abf
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
801009a3:	e8 58 40 00 00       	call   80104a00 <acquire>
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
801009dd:	e8 be 3f 00 00       	call   801049a0 <release>
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
80100b1c:	e8 ff 37 00 00       	call   80104320 <wakeup>
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
80100b3f:	e9 bc 38 00 00       	jmp    80104400 <procdump>
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
80100b56:	68 c8 7a 10 80       	push   $0x80107ac8
80100b5b:	68 20 ff 10 80       	push   $0x8010ff20
80100b60:	e8 ab 3c 00 00       	call   80104810 <initlock>

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
80100bac:	e8 7f 2f 00 00       	call   80103b30 <myproc>
80100bb1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100bb7:	e8 64 23 00 00       	call   80102f20 <begin_op>

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
80100c0a:	e8 c1 66 00 00       	call   801072d0 <setupkvm>
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
80100c7b:	e8 80 64 00 00       	call   80107100 <allocuvm>
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
80100cb1:	e8 7a 63 00 00       	call   80107030 <loaduvm>
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
80100cf3:	e8 58 65 00 00       	call   80107250 <freevm>
  if(ip){
80100cf8:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100cfb:	83 ec 0c             	sub    $0xc,%esp
80100cfe:	57                   	push   %edi
80100cff:	e8 1c 0e 00 00       	call   80101b20 <iunlockput>
    end_op();
80100d04:	e8 87 22 00 00       	call   80102f90 <end_op>
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
80100d41:	e8 4a 22 00 00       	call   80102f90 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d46:	83 c4 0c             	add    $0xc,%esp
80100d49:	53                   	push   %ebx
80100d4a:	56                   	push   %esi
80100d4b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100d51:	56                   	push   %esi
80100d52:	e8 a9 63 00 00       	call   80107100 <allocuvm>
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
80100d73:	e8 f8 65 00 00       	call   80107370 <clearpteu>
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
80100dba:	e8 31 3f 00 00       	call   80104cf0 <strlen>
80100dbf:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dc1:	58                   	pop    %eax
80100dc2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dc5:	83 eb 01             	sub    $0x1,%ebx
80100dc8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dcb:	e8 20 3f 00 00       	call   80104cf0 <strlen>
80100dd0:	83 c0 01             	add    $0x1,%eax
80100dd3:	50                   	push   %eax
80100dd4:	ff 34 b7             	push   (%edi,%esi,4)
80100dd7:	53                   	push   %ebx
80100dd8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100dde:	e8 8d 68 00 00       	call   80107670 <copyout>
80100de3:	83 c4 20             	add    $0x20,%esp
80100de6:	85 c0                	test   %eax,%eax
80100de8:	79 ae                	jns    80100d98 <exec+0x1f8>
    freevm(pgdir);
80100dea:	83 ec 0c             	sub    $0xc,%esp
80100ded:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100df3:	e8 58 64 00 00       	call   80107250 <freevm>
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
80100e4f:	e8 1c 68 00 00       	call   80107670 <copyout>
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
80100e8f:	e8 1c 3e 00 00       	call   80104cb0 <safestrcpy>
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
80100ebb:	e8 e0 5f 00 00       	call   80106ea0 <switchuvm>
  freevm(oldpgdir);
80100ec0:	89 34 24             	mov    %esi,(%esp)
80100ec3:	e8 88 63 00 00       	call   80107250 <freevm>
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
80100f02:	e8 89 20 00 00       	call   80102f90 <end_op>
    cprintf("exec: fail\n");
80100f07:	83 ec 0c             	sub    $0xc,%esp
80100f0a:	68 d0 7a 10 80       	push   $0x80107ad0
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
80100f26:	68 dc 7a 10 80       	push   $0x80107adc
80100f2b:	68 60 ff 10 80       	push   $0x8010ff60
80100f30:	e8 db 38 00 00       	call   80104810 <initlock>
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
80100f51:	e8 aa 3a 00 00       	call   80104a00 <acquire>
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
80100f81:	e8 1a 3a 00 00       	call   801049a0 <release>
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
80100f9a:	e8 01 3a 00 00       	call   801049a0 <release>
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
80100fbf:	e8 3c 3a 00 00       	call   80104a00 <acquire>
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
80100fdc:	e8 bf 39 00 00       	call   801049a0 <release>
  return f;
}
80100fe1:	89 d8                	mov    %ebx,%eax
80100fe3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fe6:	c9                   	leave
80100fe7:	c3                   	ret
    panic("filedup");
80100fe8:	83 ec 0c             	sub    $0xc,%esp
80100feb:	68 e3 7a 10 80       	push   $0x80107ae3
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
80101011:	e8 ea 39 00 00       	call   80104a00 <acquire>
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
8010104c:	e8 4f 39 00 00       	call   801049a0 <release>

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
8010107e:	e9 1d 39 00 00       	jmp    801049a0 <release>
80101083:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101087:	90                   	nop
    begin_op();
80101088:	e8 93 1e 00 00       	call   80102f20 <begin_op>
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
801010a2:	e9 e9 1e 00 00       	jmp    80102f90 <end_op>
801010a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ae:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801010b0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801010b4:	83 ec 08             	sub    $0x8,%esp
801010b7:	53                   	push   %ebx
801010b8:	56                   	push   %esi
801010b9:	e8 22 26 00 00       	call   801036e0 <pipeclose>
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
801010cc:	68 eb 7a 10 80       	push   $0x80107aeb
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
8010119d:	e9 fe 26 00 00       	jmp    801038a0 <piperead>
801011a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801011a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801011ad:	eb d7                	jmp    80101186 <fileread+0x56>
  panic("fileread");
801011af:	83 ec 0c             	sub    $0xc,%esp
801011b2:	68 f5 7a 10 80       	push   $0x80107af5
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
80101219:	e8 72 1d 00 00       	call   80102f90 <end_op>

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
8010123e:	e8 dd 1c 00 00       	call   80102f20 <begin_op>
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
80101275:	e8 16 1d 00 00       	call   80102f90 <end_op>
      if(r < 0)
8010127a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010127d:	83 c4 10             	add    $0x10,%esp
80101280:	85 c0                	test   %eax,%eax
80101282:	75 14                	jne    80101298 <filewrite+0xd8>
        panic("short filewrite");
80101284:	83 ec 0c             	sub    $0xc,%esp
80101287:	68 fe 7a 10 80       	push   $0x80107afe
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
801012b9:	e9 c2 24 00 00       	jmp    80103780 <pipewrite>
  panic("filewrite");
801012be:	83 ec 0c             	sub    $0xc,%esp
801012c1:	68 04 7b 10 80       	push   $0x80107b04
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
80101379:	68 0e 7b 10 80       	push   $0x80107b0e
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
80101395:	e8 66 1d 00 00       	call   80103100 <log_write>
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
801013bd:	e8 3e 37 00 00       	call   80104b00 <memset>
  log_write(bp);
801013c2:	89 1c 24             	mov    %ebx,(%esp)
801013c5:	e8 36 1d 00 00       	call   80103100 <log_write>
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
801013fa:	e8 01 36 00 00       	call   80104a00 <acquire>
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
80101467:	e8 34 35 00 00       	call   801049a0 <release>

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
80101495:	e8 06 35 00 00       	call   801049a0 <release>
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
801014c8:	68 24 7b 10 80       	push   $0x80107b24
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
8010152d:	e8 ce 1b 00 00       	call   80103100 <log_write>
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
80101547:	68 34 7b 10 80       	push   $0x80107b34
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
801015d5:	e8 26 1b 00 00       	call   80103100 <log_write>
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
80101625:	68 47 7b 10 80       	push   $0x80107b47
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
80101651:	e8 3a 35 00 00       	call   80104b90 <memmove>
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
8010167c:	68 5a 7b 10 80       	push   $0x80107b5a
80101681:	68 60 09 11 80       	push   $0x80110960
80101686:	e8 85 31 00 00       	call   80104810 <initlock>
  for(i = 0; i < NINODE; i++) {
8010168b:	83 c4 10             	add    $0x10,%esp
8010168e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101690:	83 ec 08             	sub    $0x8,%esp
80101693:	68 61 7b 10 80       	push   $0x80107b61
80101698:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101699:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010169f:	e8 3c 30 00 00       	call   801046e0 <initsleeplock>
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
801016cc:	e8 bf 34 00 00       	call   80104b90 <memmove>
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
80101703:	68 70 80 10 80       	push   $0x80108070
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
8010179e:	e8 5d 33 00 00       	call   80104b00 <memset>
      dip->type = type;
801017a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017ad:	89 1c 24             	mov    %ebx,(%esp)
801017b0:	e8 4b 19 00 00       	call   80103100 <log_write>
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
801017d3:	68 67 7b 10 80       	push   $0x80107b67
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
80101841:	e8 4a 33 00 00       	call   80104b90 <memmove>
  log_write(bp);
80101846:	89 34 24             	mov    %esi,(%esp)
80101849:	e8 b2 18 00 00       	call   80103100 <log_write>
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
8010186f:	e8 8c 31 00 00       	call   80104a00 <acquire>
  ip->ref++;
80101874:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101878:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010187f:	e8 1c 31 00 00       	call   801049a0 <release>
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
801018b2:	e8 69 2e 00 00       	call   80104720 <acquiresleep>
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
80101928:	e8 63 32 00 00       	call   80104b90 <memmove>
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
8010194d:	68 7f 7b 10 80       	push   $0x80107b7f
80101952:	e8 19 eb ff ff       	call   80100470 <panic>
    panic("ilock");
80101957:	83 ec 0c             	sub    $0xc,%esp
8010195a:	68 79 7b 10 80       	push   $0x80107b79
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
80101983:	e8 38 2e 00 00       	call   801047c0 <holdingsleep>
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
8010199f:	e9 dc 2d 00 00       	jmp    80104780 <releasesleep>
    panic("iunlock");
801019a4:	83 ec 0c             	sub    $0xc,%esp
801019a7:	68 8e 7b 10 80       	push   $0x80107b8e
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
801019d0:	e8 4b 2d 00 00       	call   80104720 <acquiresleep>
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
801019ea:	e8 91 2d 00 00       	call   80104780 <releasesleep>
  acquire(&icache.lock);
801019ef:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801019f6:	e8 05 30 00 00       	call   80104a00 <acquire>
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
80101a10:	e9 8b 2f 00 00       	jmp    801049a0 <release>
80101a15:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101a18:	83 ec 0c             	sub    $0xc,%esp
80101a1b:	68 60 09 11 80       	push   $0x80110960
80101a20:	e8 db 2f 00 00       	call   80104a00 <acquire>
    int r = ip->ref;
80101a25:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a28:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101a2f:	e8 6c 2f 00 00       	call   801049a0 <release>
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
80101b33:	e8 88 2c 00 00       	call   801047c0 <holdingsleep>
80101b38:	83 c4 10             	add    $0x10,%esp
80101b3b:	85 c0                	test   %eax,%eax
80101b3d:	74 21                	je     80101b60 <iunlockput+0x40>
80101b3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b42:	85 c0                	test   %eax,%eax
80101b44:	7e 1a                	jle    80101b60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101b46:	83 ec 0c             	sub    $0xc,%esp
80101b49:	56                   	push   %esi
80101b4a:	e8 31 2c 00 00       	call   80104780 <releasesleep>
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
80101b63:	68 8e 7b 10 80       	push   $0x80107b8e
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
80101c47:	e8 44 2f 00 00       	call   80104b90 <memmove>
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
80101d45:	e8 46 2e 00 00       	call   80104b90 <memmove>
    log_write(bp);
80101d4a:	89 34 24             	mov    %esi,(%esp)
80101d4d:	e8 ae 13 00 00       	call   80103100 <log_write>
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
80101dce:	e8 2d 2e 00 00       	call   80104c00 <strncmp>
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
80101e2d:	e8 ce 2d 00 00       	call   80104c00 <strncmp>
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
80101e72:	68 a8 7b 10 80       	push   $0x80107ba8
80101e77:	e8 f4 e5 ff ff       	call   80100470 <panic>
    panic("dirlookup not DIR");
80101e7c:	83 ec 0c             	sub    $0xc,%esp
80101e7f:	68 96 7b 10 80       	push   $0x80107b96
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
80101eaa:	e8 81 1c 00 00       	call   80103b30 <myproc>
  acquire(&icache.lock);
80101eaf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101eb2:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101eb5:	68 60 09 11 80       	push   $0x80110960
80101eba:	e8 41 2b 00 00       	call   80104a00 <acquire>
  ip->ref++;
80101ebf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ec3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101eca:	e8 d1 2a 00 00       	call   801049a0 <release>
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
80101f27:	e8 64 2c 00 00       	call   80104b90 <memmove>
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
80101f8c:	e8 2f 28 00 00       	call   801047c0 <holdingsleep>
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
80101fae:	e8 cd 27 00 00       	call   80104780 <releasesleep>
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
80101fdb:	e8 b0 2b 00 00       	call   80104b90 <memmove>
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
80102015:	e8 a6 27 00 00       	call   801047c0 <holdingsleep>
8010201a:	83 c4 10             	add    $0x10,%esp
8010201d:	85 c0                	test   %eax,%eax
8010201f:	74 7d                	je     8010209e <namex+0x20e>
80102021:	8b 4e 08             	mov    0x8(%esi),%ecx
80102024:	85 c9                	test   %ecx,%ecx
80102026:	7e 76                	jle    8010209e <namex+0x20e>
  releasesleep(&ip->lock);
80102028:	83 ec 0c             	sub    $0xc,%esp
8010202b:	53                   	push   %ebx
8010202c:	e8 4f 27 00 00       	call   80104780 <releasesleep>
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
80102065:	e8 56 27 00 00       	call   801047c0 <holdingsleep>
8010206a:	83 c4 10             	add    $0x10,%esp
8010206d:	85 c0                	test   %eax,%eax
8010206f:	74 2d                	je     8010209e <namex+0x20e>
80102071:	8b 7e 08             	mov    0x8(%esi),%edi
80102074:	85 ff                	test   %edi,%edi
80102076:	7e 26                	jle    8010209e <namex+0x20e>
  releasesleep(&ip->lock);
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	53                   	push   %ebx
8010207c:	e8 ff 26 00 00       	call   80104780 <releasesleep>
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
801020a1:	68 8e 7b 10 80       	push   $0x80107b8e
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
8010210d:	e8 3e 2b 00 00       	call   80104c50 <strncpy>
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
8010214b:	68 b7 7b 10 80       	push   $0x80107bb7
80102150:	e8 1b e3 ff ff       	call   80100470 <panic>
    panic("dirlink");
80102155:	83 ec 0c             	sub    $0xc,%esp
80102158:	68 4a 7e 10 80       	push   $0x80107e4a
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
8010226b:	68 cd 7b 10 80       	push   $0x80107bcd
80102270:	e8 fb e1 ff ff       	call   80100470 <panic>
    panic("idestart");
80102275:	83 ec 0c             	sub    $0xc,%esp
80102278:	68 c4 7b 10 80       	push   $0x80107bc4
8010227d:	e8 ee e1 ff ff       	call   80100470 <panic>
80102282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102290 <ideinit>:
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102296:	68 df 7b 10 80       	push   $0x80107bdf
8010229b:	68 20 26 11 80       	push   $0x80112620
801022a0:	e8 6b 25 00 00       	call   80104810 <initlock>
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
8010232e:	e8 cd 26 00 00       	call   80104a00 <acquire>

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
8010238d:	e8 8e 1f 00 00       	call   80104320 <wakeup>

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
801023ab:	e8 f0 25 00 00       	call   801049a0 <release>

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
801023ce:	e8 ed 23 00 00       	call   801047c0 <holdingsleep>
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
80102408:	e8 f3 25 00 00       	call   80104a00 <acquire>

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
80102449:	e8 12 1e 00 00       	call   80104260 <sleep>
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
80102466:	e9 35 25 00 00       	jmp    801049a0 <release>
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
8010248a:	68 0e 7c 10 80       	push   $0x80107c0e
8010248f:	e8 dc df ff ff       	call   80100470 <panic>
    panic("iderw: nothing to do");
80102494:	83 ec 0c             	sub    $0xc,%esp
80102497:	68 f9 7b 10 80       	push   $0x80107bf9
8010249c:	e8 cf df ff ff       	call   80100470 <panic>
    panic("iderw: buf not locked");
801024a1:	83 ec 0c             	sub    $0xc,%esp
801024a4:	68 e3 7b 10 80       	push   $0x80107be3
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
801024fa:	68 c4 80 10 80       	push   $0x801080c4
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
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801025aa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801025b0:	0f 85 a4 00 00 00    	jne    8010265a <kfree+0xba>
801025b6:	81 fb 00 84 11 80    	cmp    $0x80118400,%ebx
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
80102603:	e8 f8 24 00 00       	call   80104b00 <memset>
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
8010263d:	e9 5e 23 00 00       	jmp    801049a0 <release>
80102642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102648:	83 ec 0c             	sub    $0xc,%esp
8010264b:	68 60 26 11 80       	push   $0x80112660
80102650:	e8 ab 23 00 00       	call   80104a00 <acquire>
80102655:	83 c4 10             	add    $0x10,%esp
80102658:	eb bb                	jmp    80102615 <kfree+0x75>
    panic("kfree");
8010265a:	83 ec 0c             	sub    $0xc,%esp
8010265d:	68 2c 7c 10 80       	push   $0x80107c2c
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
8010274b:	68 32 7c 10 80       	push   $0x80107c32
80102750:	68 60 26 11 80       	push   $0x80112660
80102755:	e8 b6 20 00 00       	call   80104810 <initlock>
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
801027c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ce:	66 90                	xchg   %ax,%ax
  struct run *r;

  if(kmem.use_lock)
801027d0:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
801027d6:	85 c9                	test   %ecx,%ecx
801027d8:	75 56                	jne    80102830 <kalloc+0x70>
    acquire(&kmem.lock);
  r = kmem.freelist;
801027da:	8b 1d 9c 26 11 80    	mov    0x8011269c,%ebx
  if(r)
801027e0:	85 db                	test   %ebx,%ebx
801027e2:	0f 84 7c 00 00 00    	je     80102864 <kalloc+0xa4>
  {
    kmem.freelist = r->next;
801027e8:	8b 03                	mov    (%ebx),%eax
    kmem.num_free_pages-=1;
    page_to_refcnt[V2P(r) >> PTXSHIFT] = 1;
    cprintf("setting refcnt of page %d\n", V2P(r) >> PTXSHIFT);
801027ea:	83 ec 08             	sub    $0x8,%esp
    kmem.num_free_pages-=1;
801027ed:	83 2d 98 26 11 80 01 	subl   $0x1,0x80112698
    kmem.freelist = r->next;
801027f4:	a3 9c 26 11 80       	mov    %eax,0x8011269c
    page_to_refcnt[V2P(r) >> PTXSHIFT] = 1;
801027f9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801027ff:	c1 e8 0c             	shr    $0xc,%eax
    cprintf("setting refcnt of page %d\n", V2P(r) >> PTXSHIFT);
80102802:	50                   	push   %eax
80102803:	68 37 7c 10 80       	push   $0x80107c37
    page_to_refcnt[V2P(r) >> PTXSHIFT] = 1;
80102808:	c7 04 85 a0 26 11 80 	movl   $0x1,-0x7feed960(,%eax,4)
8010280f:	01 00 00 00 
    cprintf("setting refcnt of page %d\n", V2P(r) >> PTXSHIFT);
80102813:	e8 88 df ff ff       	call   801007a0 <cprintf>
  }
    
  if(kmem.use_lock)
80102818:	a1 94 26 11 80       	mov    0x80112694,%eax
8010281d:	83 c4 10             	add    $0x10,%esp
80102820:	85 c0                	test   %eax,%eax
80102822:	75 4c                	jne    80102870 <kalloc+0xb0>

  if(r) return (char*)r;

  swap_out();
  return kalloc();
}
80102824:	89 d8                	mov    %ebx,%eax
80102826:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102829:	c9                   	leave
8010282a:	c3                   	ret
8010282b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010282f:	90                   	nop
    acquire(&kmem.lock);
80102830:	83 ec 0c             	sub    $0xc,%esp
80102833:	68 60 26 11 80       	push   $0x80112660
80102838:	e8 c3 21 00 00       	call   80104a00 <acquire>
  r = kmem.freelist;
8010283d:	8b 1d 9c 26 11 80    	mov    0x8011269c,%ebx
  if(r)
80102843:	83 c4 10             	add    $0x10,%esp
80102846:	85 db                	test   %ebx,%ebx
80102848:	75 9e                	jne    801027e8 <kalloc+0x28>
  if(kmem.use_lock)
8010284a:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102850:	85 d2                	test   %edx,%edx
80102852:	74 10                	je     80102864 <kalloc+0xa4>
    release(&kmem.lock);
80102854:	83 ec 0c             	sub    $0xc,%esp
80102857:	68 60 26 11 80       	push   $0x80112660
8010285c:	e8 3f 21 00 00       	call   801049a0 <release>
80102861:	83 c4 10             	add    $0x10,%esp
  swap_out();
80102864:	e8 27 4f 00 00       	call   80107790 <swap_out>
  return kalloc();
80102869:	e9 62 ff ff ff       	jmp    801027d0 <kalloc+0x10>
8010286e:	66 90                	xchg   %ax,%ax
    release(&kmem.lock);
80102870:	83 ec 0c             	sub    $0xc,%esp
80102873:	68 60 26 11 80       	push   $0x80112660
80102878:	e8 23 21 00 00       	call   801049a0 <release>
}
8010287d:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010287f:	83 c4 10             	add    $0x10,%esp
}
80102882:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102885:	c9                   	leave
80102886:	c3                   	ret
80102887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010288e:	66 90                	xchg   %ax,%ax

80102890 <num_of_FreePages>:
uint 
num_of_FreePages(void)
{
80102890:	55                   	push   %ebp
80102891:	89 e5                	mov    %esp,%ebp
80102893:	53                   	push   %ebx
80102894:	83 ec 10             	sub    $0x10,%esp
  acquire(&kmem.lock);
80102897:	68 60 26 11 80       	push   $0x80112660
8010289c:	e8 5f 21 00 00       	call   80104a00 <acquire>

  uint num_free_pages = kmem.num_free_pages;
801028a1:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  
  release(&kmem.lock);
801028a7:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801028ae:	e8 ed 20 00 00       	call   801049a0 <release>
  
  return num_free_pages;
}
801028b3:	89 d8                	mov    %ebx,%eax
801028b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028b8:	c9                   	leave
801028b9:	c3                   	ret
801028ba:	66 90                	xchg   %ax,%ax
801028bc:	66 90                	xchg   %ax,%ax
801028be:	66 90                	xchg   %ax,%ax

801028c0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c0:	ba 64 00 00 00       	mov    $0x64,%edx
801028c5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028c6:	a8 01                	test   $0x1,%al
801028c8:	0f 84 c2 00 00 00    	je     80102990 <kbdgetc+0xd0>
{
801028ce:	55                   	push   %ebp
801028cf:	ba 60 00 00 00       	mov    $0x60,%edx
801028d4:	89 e5                	mov    %esp,%ebp
801028d6:	53                   	push   %ebx
801028d7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801028d8:	8b 1d a0 36 11 80    	mov    0x801136a0,%ebx
  data = inb(KBDATAP);
801028de:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801028e1:	3c e0                	cmp    $0xe0,%al
801028e3:	74 5b                	je     80102940 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028e5:	89 da                	mov    %ebx,%edx
801028e7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801028ea:	84 c0                	test   %al,%al
801028ec:	78 62                	js     80102950 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801028ee:	85 d2                	test   %edx,%edx
801028f0:	74 09                	je     801028fb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028f2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801028f5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801028f8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801028fb:	0f b6 91 a0 83 10 80 	movzbl -0x7fef7c60(%ecx),%edx
  shift ^= togglecode[data];
80102902:	0f b6 81 a0 82 10 80 	movzbl -0x7fef7d60(%ecx),%eax
  shift |= shiftcode[data];
80102909:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010290b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010290d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010290f:	89 15 a0 36 11 80    	mov    %edx,0x801136a0
  c = charcode[shift & (CTL | SHIFT)][data];
80102915:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102918:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010291b:	8b 04 85 80 82 10 80 	mov    -0x7fef7d80(,%eax,4),%eax
80102922:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102926:	74 0b                	je     80102933 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102928:	8d 50 9f             	lea    -0x61(%eax),%edx
8010292b:	83 fa 19             	cmp    $0x19,%edx
8010292e:	77 48                	ja     80102978 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102930:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102933:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102936:	c9                   	leave
80102937:	c3                   	ret
80102938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop
    shift |= E0ESC;
80102940:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102943:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102945:	89 1d a0 36 11 80    	mov    %ebx,0x801136a0
}
8010294b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010294e:	c9                   	leave
8010294f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102950:	83 e0 7f             	and    $0x7f,%eax
80102953:	85 d2                	test   %edx,%edx
80102955:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102958:	0f b6 81 a0 83 10 80 	movzbl -0x7fef7c60(%ecx),%eax
8010295f:	83 c8 40             	or     $0x40,%eax
80102962:	0f b6 c0             	movzbl %al,%eax
80102965:	f7 d0                	not    %eax
80102967:	21 d8                	and    %ebx,%eax
80102969:	a3 a0 36 11 80       	mov    %eax,0x801136a0
    return 0;
8010296e:	31 c0                	xor    %eax,%eax
80102970:	eb d9                	jmp    8010294b <kbdgetc+0x8b>
80102972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102978:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010297b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010297e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102981:	c9                   	leave
      c += 'a' - 'A';
80102982:	83 f9 1a             	cmp    $0x1a,%ecx
80102985:	0f 42 c2             	cmovb  %edx,%eax
}
80102988:	c3                   	ret
80102989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102995:	c3                   	ret
80102996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299d:	8d 76 00             	lea    0x0(%esi),%esi

801029a0 <kbdintr>:

void
kbdintr(void)
{
801029a0:	55                   	push   %ebp
801029a1:	89 e5                	mov    %esp,%ebp
801029a3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029a6:	68 c0 28 10 80       	push   $0x801028c0
801029ab:	e8 e0 df ff ff       	call   80100990 <consoleintr>
}
801029b0:	83 c4 10             	add    $0x10,%esp
801029b3:	c9                   	leave
801029b4:	c3                   	ret
801029b5:	66 90                	xchg   %ax,%ax
801029b7:	66 90                	xchg   %ax,%ax
801029b9:	66 90                	xchg   %ax,%ax
801029bb:	66 90                	xchg   %ax,%ax
801029bd:	66 90                	xchg   %ax,%ax
801029bf:	90                   	nop

801029c0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029c0:	a1 a4 36 11 80       	mov    0x801136a4,%eax
801029c5:	85 c0                	test   %eax,%eax
801029c7:	0f 84 c3 00 00 00    	je     80102a90 <lapicinit+0xd0>
  lapic[index] = value;
801029cd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029d4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029da:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029e1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029e7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029ee:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029f1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029f4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029fb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801029fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a01:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a08:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a0b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a0e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a15:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a18:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a1b:	8b 50 30             	mov    0x30(%eax),%edx
80102a1e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102a24:	75 72                	jne    80102a98 <lapicinit+0xd8>
  lapic[index] = value;
80102a26:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a2d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a30:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a33:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a3a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a3d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a40:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a47:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a4a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a4d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a54:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a57:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a5a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a61:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a64:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a67:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a6e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a71:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a78:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a7e:	80 e6 10             	and    $0x10,%dh
80102a81:	75 f5                	jne    80102a78 <lapicinit+0xb8>
  lapic[index] = value;
80102a83:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a8a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a8d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a90:	c3                   	ret
80102a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102a98:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a9f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa2:	8b 50 20             	mov    0x20(%eax),%edx
}
80102aa5:	e9 7c ff ff ff       	jmp    80102a26 <lapicinit+0x66>
80102aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ab0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102ab0:	a1 a4 36 11 80       	mov    0x801136a4,%eax
80102ab5:	85 c0                	test   %eax,%eax
80102ab7:	74 07                	je     80102ac0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102ab9:	8b 40 20             	mov    0x20(%eax),%eax
80102abc:	c1 e8 18             	shr    $0x18,%eax
80102abf:	c3                   	ret
    return 0;
80102ac0:	31 c0                	xor    %eax,%eax
}
80102ac2:	c3                   	ret
80102ac3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ad0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ad0:	a1 a4 36 11 80       	mov    0x801136a4,%eax
80102ad5:	85 c0                	test   %eax,%eax
80102ad7:	74 0d                	je     80102ae6 <lapiceoi+0x16>
  lapic[index] = value;
80102ad9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ae0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ae3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102ae6:	c3                   	ret
80102ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aee:	66 90                	xchg   %ax,%ax

80102af0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102af0:	c3                   	ret
80102af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aff:	90                   	nop

80102b00 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b00:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b01:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b06:	ba 70 00 00 00       	mov    $0x70,%edx
80102b0b:	89 e5                	mov    %esp,%ebp
80102b0d:	53                   	push   %ebx
80102b0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b11:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b14:	ee                   	out    %al,(%dx)
80102b15:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b1a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b1f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b20:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102b22:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b25:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b2b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b2d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102b30:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102b32:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b35:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b38:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b3e:	a1 a4 36 11 80       	mov    0x801136a4,%eax
80102b43:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b49:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b4c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b53:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b56:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b59:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b60:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b63:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b66:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b6c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b6f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b75:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b78:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b7e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b81:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b87:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102b8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b8d:	c9                   	leave
80102b8e:	c3                   	ret
80102b8f:	90                   	nop

80102b90 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b90:	55                   	push   %ebp
80102b91:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b96:	ba 70 00 00 00       	mov    $0x70,%edx
80102b9b:	89 e5                	mov    %esp,%ebp
80102b9d:	57                   	push   %edi
80102b9e:	56                   	push   %esi
80102b9f:	53                   	push   %ebx
80102ba0:	83 ec 4c             	sub    $0x4c,%esp
80102ba3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ba4:	ba 71 00 00 00       	mov    $0x71,%edx
80102ba9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102baa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bad:	bf 70 00 00 00       	mov    $0x70,%edi
80102bb2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
80102bb8:	31 c0                	xor    %eax,%eax
80102bba:	89 fa                	mov    %edi,%edx
80102bbc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bbd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102bc2:	89 ca                	mov    %ecx,%edx
80102bc4:	ec                   	in     (%dx),%al
80102bc5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc8:	89 fa                	mov    %edi,%edx
80102bca:	b8 02 00 00 00       	mov    $0x2,%eax
80102bcf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bd0:	89 ca                	mov    %ecx,%edx
80102bd2:	ec                   	in     (%dx),%al
80102bd3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd6:	89 fa                	mov    %edi,%edx
80102bd8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bdd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bde:	89 ca                	mov    %ecx,%edx
80102be0:	ec                   	in     (%dx),%al
80102be1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be4:	89 fa                	mov    %edi,%edx
80102be6:	b8 07 00 00 00       	mov    $0x7,%eax
80102beb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bec:	89 ca                	mov    %ecx,%edx
80102bee:	ec                   	in     (%dx),%al
80102bef:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf2:	89 fa                	mov    %edi,%edx
80102bf4:	b8 08 00 00 00       	mov    $0x8,%eax
80102bf9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfa:	89 ca                	mov    %ecx,%edx
80102bfc:	ec                   	in     (%dx),%al
80102bfd:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bff:	89 fa                	mov    %edi,%edx
80102c01:	b8 09 00 00 00       	mov    $0x9,%eax
80102c06:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c07:	89 ca                	mov    %ecx,%edx
80102c09:	ec                   	in     (%dx),%al
80102c0a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c0d:	89 fa                	mov    %edi,%edx
80102c0f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c14:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c15:	89 ca                	mov    %ecx,%edx
80102c17:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c18:	84 c0                	test   %al,%al
80102c1a:	78 9c                	js     80102bb8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c1c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c20:	89 f2                	mov    %esi,%edx
80102c22:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102c25:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c28:	89 fa                	mov    %edi,%edx
80102c2a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c2d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c31:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102c34:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c37:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c3b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c3e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c42:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c45:	31 c0                	xor    %eax,%eax
80102c47:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c48:	89 ca                	mov    %ecx,%edx
80102c4a:	ec                   	in     (%dx),%al
80102c4b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c4e:	89 fa                	mov    %edi,%edx
80102c50:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c53:	b8 02 00 00 00       	mov    $0x2,%eax
80102c58:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c59:	89 ca                	mov    %ecx,%edx
80102c5b:	ec                   	in     (%dx),%al
80102c5c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c5f:	89 fa                	mov    %edi,%edx
80102c61:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c64:	b8 04 00 00 00       	mov    $0x4,%eax
80102c69:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6a:	89 ca                	mov    %ecx,%edx
80102c6c:	ec                   	in     (%dx),%al
80102c6d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c70:	89 fa                	mov    %edi,%edx
80102c72:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c75:	b8 07 00 00 00       	mov    $0x7,%eax
80102c7a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7b:	89 ca                	mov    %ecx,%edx
80102c7d:	ec                   	in     (%dx),%al
80102c7e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c81:	89 fa                	mov    %edi,%edx
80102c83:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c86:	b8 08 00 00 00       	mov    $0x8,%eax
80102c8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c8c:	89 ca                	mov    %ecx,%edx
80102c8e:	ec                   	in     (%dx),%al
80102c8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c92:	89 fa                	mov    %edi,%edx
80102c94:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c97:	b8 09 00 00 00       	mov    $0x9,%eax
80102c9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9d:	89 ca                	mov    %ecx,%edx
80102c9f:	ec                   	in     (%dx),%al
80102ca0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ca3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ca6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ca9:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102cac:	6a 18                	push   $0x18
80102cae:	50                   	push   %eax
80102caf:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102cb2:	50                   	push   %eax
80102cb3:	e8 88 1e 00 00       	call   80104b40 <memcmp>
80102cb8:	83 c4 10             	add    $0x10,%esp
80102cbb:	85 c0                	test   %eax,%eax
80102cbd:	0f 85 f5 fe ff ff    	jne    80102bb8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102cc3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102cca:	89 f0                	mov    %esi,%eax
80102ccc:	84 c0                	test   %al,%al
80102cce:	75 78                	jne    80102d48 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102cd0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cd3:	89 c2                	mov    %eax,%edx
80102cd5:	83 e0 0f             	and    $0xf,%eax
80102cd8:	c1 ea 04             	shr    $0x4,%edx
80102cdb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cde:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ce1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ce4:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ce7:	89 c2                	mov    %eax,%edx
80102ce9:	83 e0 0f             	and    $0xf,%eax
80102cec:	c1 ea 04             	shr    $0x4,%edx
80102cef:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cf2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cf5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102cf8:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102cfb:	89 c2                	mov    %eax,%edx
80102cfd:	83 e0 0f             	and    $0xf,%eax
80102d00:	c1 ea 04             	shr    $0x4,%edx
80102d03:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d06:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d09:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d0c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d0f:	89 c2                	mov    %eax,%edx
80102d11:	83 e0 0f             	and    $0xf,%eax
80102d14:	c1 ea 04             	shr    $0x4,%edx
80102d17:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d1a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d1d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d20:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d23:	89 c2                	mov    %eax,%edx
80102d25:	83 e0 0f             	and    $0xf,%eax
80102d28:	c1 ea 04             	shr    $0x4,%edx
80102d2b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d2e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d31:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d34:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d37:	89 c2                	mov    %eax,%edx
80102d39:	83 e0 0f             	and    $0xf,%eax
80102d3c:	c1 ea 04             	shr    $0x4,%edx
80102d3f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d42:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d45:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d48:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d4b:	89 03                	mov    %eax,(%ebx)
80102d4d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d50:	89 43 04             	mov    %eax,0x4(%ebx)
80102d53:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d56:	89 43 08             	mov    %eax,0x8(%ebx)
80102d59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d5c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102d5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d62:	89 43 10             	mov    %eax,0x10(%ebx)
80102d65:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d68:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102d6b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102d72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d75:	5b                   	pop    %ebx
80102d76:	5e                   	pop    %esi
80102d77:	5f                   	pop    %edi
80102d78:	5d                   	pop    %ebp
80102d79:	c3                   	ret
80102d7a:	66 90                	xchg   %ax,%ax
80102d7c:	66 90                	xchg   %ax,%ax
80102d7e:	66 90                	xchg   %ax,%ax

80102d80 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d80:	8b 0d 08 37 11 80    	mov    0x80113708,%ecx
80102d86:	85 c9                	test   %ecx,%ecx
80102d88:	0f 8e 8a 00 00 00    	jle    80102e18 <install_trans+0x98>
{
80102d8e:	55                   	push   %ebp
80102d8f:	89 e5                	mov    %esp,%ebp
80102d91:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102d92:	31 ff                	xor    %edi,%edi
{
80102d94:	56                   	push   %esi
80102d95:	53                   	push   %ebx
80102d96:	83 ec 0c             	sub    $0xc,%esp
80102d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102da0:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102da5:	83 ec 08             	sub    $0x8,%esp
80102da8:	01 f8                	add    %edi,%eax
80102daa:	83 c0 01             	add    $0x1,%eax
80102dad:	50                   	push   %eax
80102dae:	ff 35 04 37 11 80    	push   0x80113704
80102db4:	e8 17 d3 ff ff       	call   801000d0 <bread>
80102db9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dbb:	58                   	pop    %eax
80102dbc:	5a                   	pop    %edx
80102dbd:	ff 34 bd 0c 37 11 80 	push   -0x7feec8f4(,%edi,4)
80102dc4:	ff 35 04 37 11 80    	push   0x80113704
  for (tail = 0; tail < log.lh.n; tail++) {
80102dca:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dcd:	e8 fe d2 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102dd2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dd5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102dd7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dda:	68 00 02 00 00       	push   $0x200
80102ddf:	50                   	push   %eax
80102de0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102de3:	50                   	push   %eax
80102de4:	e8 a7 1d 00 00       	call   80104b90 <memmove>
    bwrite(dbuf);  // write dst to disk
80102de9:	89 1c 24             	mov    %ebx,(%esp)
80102dec:	e8 bf d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102df1:	89 34 24             	mov    %esi,(%esp)
80102df4:	e8 f7 d3 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102df9:	89 1c 24             	mov    %ebx,(%esp)
80102dfc:	e8 ef d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e01:	83 c4 10             	add    $0x10,%esp
80102e04:	39 3d 08 37 11 80    	cmp    %edi,0x80113708
80102e0a:	7f 94                	jg     80102da0 <install_trans+0x20>
  }
}
80102e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e0f:	5b                   	pop    %ebx
80102e10:	5e                   	pop    %esi
80102e11:	5f                   	pop    %edi
80102e12:	5d                   	pop    %ebp
80102e13:	c3                   	ret
80102e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e18:	c3                   	ret
80102e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	53                   	push   %ebx
80102e24:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e27:	ff 35 f4 36 11 80    	push   0x801136f4
80102e2d:	ff 35 04 37 11 80    	push   0x80113704
80102e33:	e8 98 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e38:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e3b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e3d:	a1 08 37 11 80       	mov    0x80113708,%eax
80102e42:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102e45:	85 c0                	test   %eax,%eax
80102e47:	7e 19                	jle    80102e62 <write_head+0x42>
80102e49:	31 d2                	xor    %edx,%edx
80102e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e4f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102e50:	8b 0c 95 0c 37 11 80 	mov    -0x7feec8f4(,%edx,4),%ecx
80102e57:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e5b:	83 c2 01             	add    $0x1,%edx
80102e5e:	39 d0                	cmp    %edx,%eax
80102e60:	75 ee                	jne    80102e50 <write_head+0x30>
  }
  bwrite(buf);
80102e62:	83 ec 0c             	sub    $0xc,%esp
80102e65:	53                   	push   %ebx
80102e66:	e8 45 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102e6b:	89 1c 24             	mov    %ebx,(%esp)
80102e6e:	e8 7d d3 ff ff       	call   801001f0 <brelse>
}
80102e73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e76:	83 c4 10             	add    $0x10,%esp
80102e79:	c9                   	leave
80102e7a:	c3                   	ret
80102e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e7f:	90                   	nop

80102e80 <initlog>:
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	53                   	push   %ebx
80102e84:	83 ec 3c             	sub    $0x3c,%esp
80102e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e8a:	68 52 7c 10 80       	push   $0x80107c52
80102e8f:	68 c0 36 11 80       	push   $0x801136c0
80102e94:	e8 77 19 00 00       	call   80104810 <initlock>
  readsb(dev, &sb);
80102e99:	58                   	pop    %eax
80102e9a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80102e9d:	5a                   	pop    %edx
80102e9e:	50                   	push   %eax
80102e9f:	53                   	push   %ebx
80102ea0:	e8 8b e7 ff ff       	call   80101630 <readsb>
  log.start = sb.logstart;
80102ea5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ea8:	59                   	pop    %ecx
  log.dev = dev;
80102ea9:	89 1d 04 37 11 80    	mov    %ebx,0x80113704
  log.size = sb.nlog;
80102eaf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  log.start = sb.logstart;
80102eb2:	a3 f4 36 11 80       	mov    %eax,0x801136f4
  log.size = sb.nlog;
80102eb7:	89 15 f8 36 11 80    	mov    %edx,0x801136f8
  struct buf *buf = bread(log.dev, log.start);
80102ebd:	5a                   	pop    %edx
80102ebe:	50                   	push   %eax
80102ebf:	53                   	push   %ebx
80102ec0:	e8 0b d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ec5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102ec8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ecb:	89 1d 08 37 11 80    	mov    %ebx,0x80113708
  for (i = 0; i < log.lh.n; i++) {
80102ed1:	85 db                	test   %ebx,%ebx
80102ed3:	7e 1d                	jle    80102ef2 <initlog+0x72>
80102ed5:	31 d2                	xor    %edx,%edx
80102ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ede:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102ee0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102ee4:	89 0c 95 0c 37 11 80 	mov    %ecx,-0x7feec8f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102eeb:	83 c2 01             	add    $0x1,%edx
80102eee:	39 d3                	cmp    %edx,%ebx
80102ef0:	75 ee                	jne    80102ee0 <initlog+0x60>
  brelse(buf);
80102ef2:	83 ec 0c             	sub    $0xc,%esp
80102ef5:	50                   	push   %eax
80102ef6:	e8 f5 d2 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102efb:	e8 80 fe ff ff       	call   80102d80 <install_trans>
  log.lh.n = 0;
80102f00:	c7 05 08 37 11 80 00 	movl   $0x0,0x80113708
80102f07:	00 00 00 
  write_head(); // clear the log
80102f0a:	e8 11 ff ff ff       	call   80102e20 <write_head>
}
80102f0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f12:	83 c4 10             	add    $0x10,%esp
80102f15:	c9                   	leave
80102f16:	c3                   	ret
80102f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f1e:	66 90                	xchg   %ax,%ax

80102f20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f26:	68 c0 36 11 80       	push   $0x801136c0
80102f2b:	e8 d0 1a 00 00       	call   80104a00 <acquire>
80102f30:	83 c4 10             	add    $0x10,%esp
80102f33:	eb 18                	jmp    80102f4d <begin_op+0x2d>
80102f35:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f38:	83 ec 08             	sub    $0x8,%esp
80102f3b:	68 c0 36 11 80       	push   $0x801136c0
80102f40:	68 c0 36 11 80       	push   $0x801136c0
80102f45:	e8 16 13 00 00       	call   80104260 <sleep>
80102f4a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f4d:	a1 00 37 11 80       	mov    0x80113700,%eax
80102f52:	85 c0                	test   %eax,%eax
80102f54:	75 e2                	jne    80102f38 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f56:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102f5b:	8b 15 08 37 11 80    	mov    0x80113708,%edx
80102f61:	83 c0 01             	add    $0x1,%eax
80102f64:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f67:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f6a:	83 fa 1e             	cmp    $0x1e,%edx
80102f6d:	7f c9                	jg     80102f38 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f6f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f72:	a3 fc 36 11 80       	mov    %eax,0x801136fc
      release(&log.lock);
80102f77:	68 c0 36 11 80       	push   $0x801136c0
80102f7c:	e8 1f 1a 00 00       	call   801049a0 <release>
      break;
    }
  }
}
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	c9                   	leave
80102f85:	c3                   	ret
80102f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f8d:	8d 76 00             	lea    0x0(%esi),%esi

80102f90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	57                   	push   %edi
80102f94:	56                   	push   %esi
80102f95:	53                   	push   %ebx
80102f96:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f99:	68 c0 36 11 80       	push   $0x801136c0
80102f9e:	e8 5d 1a 00 00       	call   80104a00 <acquire>
  log.outstanding -= 1;
80102fa3:	a1 fc 36 11 80       	mov    0x801136fc,%eax
  if(log.committing)
80102fa8:	8b 35 00 37 11 80    	mov    0x80113700,%esi
80102fae:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102fb1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102fb4:	89 1d fc 36 11 80    	mov    %ebx,0x801136fc
  if(log.committing)
80102fba:	85 f6                	test   %esi,%esi
80102fbc:	0f 85 22 01 00 00    	jne    801030e4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102fc2:	85 db                	test   %ebx,%ebx
80102fc4:	0f 85 f6 00 00 00    	jne    801030c0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102fca:	c7 05 00 37 11 80 01 	movl   $0x1,0x80113700
80102fd1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fd4:	83 ec 0c             	sub    $0xc,%esp
80102fd7:	68 c0 36 11 80       	push   $0x801136c0
80102fdc:	e8 bf 19 00 00       	call   801049a0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fe1:	8b 0d 08 37 11 80    	mov    0x80113708,%ecx
80102fe7:	83 c4 10             	add    $0x10,%esp
80102fea:	85 c9                	test   %ecx,%ecx
80102fec:	7f 42                	jg     80103030 <end_op+0xa0>
    acquire(&log.lock);
80102fee:	83 ec 0c             	sub    $0xc,%esp
80102ff1:	68 c0 36 11 80       	push   $0x801136c0
80102ff6:	e8 05 1a 00 00       	call   80104a00 <acquire>
    log.committing = 0;
80102ffb:	c7 05 00 37 11 80 00 	movl   $0x0,0x80113700
80103002:	00 00 00 
    wakeup(&log);
80103005:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
8010300c:	e8 0f 13 00 00       	call   80104320 <wakeup>
    release(&log.lock);
80103011:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80103018:	e8 83 19 00 00       	call   801049a0 <release>
8010301d:	83 c4 10             	add    $0x10,%esp
}
80103020:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103023:	5b                   	pop    %ebx
80103024:	5e                   	pop    %esi
80103025:	5f                   	pop    %edi
80103026:	5d                   	pop    %ebp
80103027:	c3                   	ret
80103028:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010302f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103030:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80103035:	83 ec 08             	sub    $0x8,%esp
80103038:	01 d8                	add    %ebx,%eax
8010303a:	83 c0 01             	add    $0x1,%eax
8010303d:	50                   	push   %eax
8010303e:	ff 35 04 37 11 80    	push   0x80113704
80103044:	e8 87 d0 ff ff       	call   801000d0 <bread>
80103049:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010304b:	58                   	pop    %eax
8010304c:	5a                   	pop    %edx
8010304d:	ff 34 9d 0c 37 11 80 	push   -0x7feec8f4(,%ebx,4)
80103054:	ff 35 04 37 11 80    	push   0x80113704
  for (tail = 0; tail < log.lh.n; tail++) {
8010305a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010305d:	e8 6e d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103062:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103065:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103067:	8d 40 5c             	lea    0x5c(%eax),%eax
8010306a:	68 00 02 00 00       	push   $0x200
8010306f:	50                   	push   %eax
80103070:	8d 46 5c             	lea    0x5c(%esi),%eax
80103073:	50                   	push   %eax
80103074:	e8 17 1b 00 00       	call   80104b90 <memmove>
    bwrite(to);  // write the log
80103079:	89 34 24             	mov    %esi,(%esp)
8010307c:	e8 2f d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103081:	89 3c 24             	mov    %edi,(%esp)
80103084:	e8 67 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103089:	89 34 24             	mov    %esi,(%esp)
8010308c:	e8 5f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103091:	83 c4 10             	add    $0x10,%esp
80103094:	3b 1d 08 37 11 80    	cmp    0x80113708,%ebx
8010309a:	7c 94                	jl     80103030 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010309c:	e8 7f fd ff ff       	call   80102e20 <write_head>
    install_trans(); // Now install writes to home locations
801030a1:	e8 da fc ff ff       	call   80102d80 <install_trans>
    log.lh.n = 0;
801030a6:	c7 05 08 37 11 80 00 	movl   $0x0,0x80113708
801030ad:	00 00 00 
    write_head();    // Erase the transaction from the log
801030b0:	e8 6b fd ff ff       	call   80102e20 <write_head>
801030b5:	e9 34 ff ff ff       	jmp    80102fee <end_op+0x5e>
801030ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801030c0:	83 ec 0c             	sub    $0xc,%esp
801030c3:	68 c0 36 11 80       	push   $0x801136c0
801030c8:	e8 53 12 00 00       	call   80104320 <wakeup>
  release(&log.lock);
801030cd:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
801030d4:	e8 c7 18 00 00       	call   801049a0 <release>
801030d9:	83 c4 10             	add    $0x10,%esp
}
801030dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030df:	5b                   	pop    %ebx
801030e0:	5e                   	pop    %esi
801030e1:	5f                   	pop    %edi
801030e2:	5d                   	pop    %ebp
801030e3:	c3                   	ret
    panic("log.committing");
801030e4:	83 ec 0c             	sub    $0xc,%esp
801030e7:	68 56 7c 10 80       	push   $0x80107c56
801030ec:	e8 7f d3 ff ff       	call   80100470 <panic>
801030f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ff:	90                   	nop

80103100 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103100:	55                   	push   %ebp
80103101:	89 e5                	mov    %esp,%ebp
80103103:	53                   	push   %ebx
80103104:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103107:	8b 15 08 37 11 80    	mov    0x80113708,%edx
{
8010310d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103110:	83 fa 1d             	cmp    $0x1d,%edx
80103113:	7f 7d                	jg     80103192 <log_write+0x92>
80103115:	a1 f8 36 11 80       	mov    0x801136f8,%eax
8010311a:	83 e8 01             	sub    $0x1,%eax
8010311d:	39 c2                	cmp    %eax,%edx
8010311f:	7d 71                	jge    80103192 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103121:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80103126:	85 c0                	test   %eax,%eax
80103128:	7e 75                	jle    8010319f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010312a:	83 ec 0c             	sub    $0xc,%esp
8010312d:	68 c0 36 11 80       	push   $0x801136c0
80103132:	e8 c9 18 00 00       	call   80104a00 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103137:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010313a:	83 c4 10             	add    $0x10,%esp
8010313d:	31 c0                	xor    %eax,%eax
8010313f:	8b 15 08 37 11 80    	mov    0x80113708,%edx
80103145:	85 d2                	test   %edx,%edx
80103147:	7f 0e                	jg     80103157 <log_write+0x57>
80103149:	eb 15                	jmp    80103160 <log_write+0x60>
8010314b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010314f:	90                   	nop
80103150:	83 c0 01             	add    $0x1,%eax
80103153:	39 c2                	cmp    %eax,%edx
80103155:	74 29                	je     80103180 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103157:	39 0c 85 0c 37 11 80 	cmp    %ecx,-0x7feec8f4(,%eax,4)
8010315e:	75 f0                	jne    80103150 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103160:	89 0c 85 0c 37 11 80 	mov    %ecx,-0x7feec8f4(,%eax,4)
  if (i == log.lh.n)
80103167:	39 c2                	cmp    %eax,%edx
80103169:	74 1c                	je     80103187 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010316b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010316e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103171:	c7 45 08 c0 36 11 80 	movl   $0x801136c0,0x8(%ebp)
}
80103178:	c9                   	leave
  release(&log.lock);
80103179:	e9 22 18 00 00       	jmp    801049a0 <release>
8010317e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103180:	89 0c 95 0c 37 11 80 	mov    %ecx,-0x7feec8f4(,%edx,4)
    log.lh.n++;
80103187:	83 c2 01             	add    $0x1,%edx
8010318a:	89 15 08 37 11 80    	mov    %edx,0x80113708
80103190:	eb d9                	jmp    8010316b <log_write+0x6b>
    panic("too big a transaction");
80103192:	83 ec 0c             	sub    $0xc,%esp
80103195:	68 65 7c 10 80       	push   $0x80107c65
8010319a:	e8 d1 d2 ff ff       	call   80100470 <panic>
    panic("log_write outside of trans");
8010319f:	83 ec 0c             	sub    $0xc,%esp
801031a2:	68 7b 7c 10 80       	push   $0x80107c7b
801031a7:	e8 c4 d2 ff ff       	call   80100470 <panic>
801031ac:	66 90                	xchg   %ax,%ax
801031ae:	66 90                	xchg   %ax,%ax

801031b0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	53                   	push   %ebx
801031b4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031b7:	e8 54 09 00 00       	call   80103b10 <cpuid>
801031bc:	89 c3                	mov    %eax,%ebx
801031be:	e8 4d 09 00 00       	call   80103b10 <cpuid>
801031c3:	83 ec 04             	sub    $0x4,%esp
801031c6:	53                   	push   %ebx
801031c7:	50                   	push   %eax
801031c8:	68 96 7c 10 80       	push   $0x80107c96
801031cd:	e8 ce d5 ff ff       	call   801007a0 <cprintf>
  idtinit();       // load idt register
801031d2:	e8 89 2b 00 00       	call   80105d60 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031d7:	e8 e4 08 00 00       	call   80103ac0 <mycpu>
801031dc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031de:	b8 01 00 00 00       	mov    $0x1,%eax
801031e3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801031ea:	e8 61 0c 00 00       	call   80103e50 <scheduler>
801031ef:	90                   	nop

801031f0 <mpenter>:
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801031f6:	e8 95 3c 00 00       	call   80106e90 <switchkvm>
  seginit();
801031fb:	e8 00 3c 00 00       	call   80106e00 <seginit>
  lapicinit();
80103200:	e8 bb f7 ff ff       	call   801029c0 <lapicinit>
  mpmain();
80103205:	e8 a6 ff ff ff       	call   801031b0 <mpmain>
8010320a:	66 90                	xchg   %ax,%ax
8010320c:	66 90                	xchg   %ax,%ax
8010320e:	66 90                	xchg   %ax,%ax

80103210 <main>:
{
80103210:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103214:	83 e4 f0             	and    $0xfffffff0,%esp
80103217:	ff 71 fc             	push   -0x4(%ecx)
8010321a:	55                   	push   %ebp
8010321b:	89 e5                	mov    %esp,%ebp
8010321d:	53                   	push   %ebx
8010321e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010321f:	83 ec 08             	sub    $0x8,%esp
80103222:	68 00 00 40 80       	push   $0x80400000
80103227:	68 00 84 11 80       	push   $0x80118400
8010322c:	e8 0f f5 ff ff       	call   80102740 <kinit1>
  kvmalloc();      // kernel page table
80103231:	e8 1a 41 00 00       	call   80107350 <kvmalloc>
  mpinit();        // detect other processors
80103236:	e8 85 01 00 00       	call   801033c0 <mpinit>
  lapicinit();     // interrupt controller
8010323b:	e8 80 f7 ff ff       	call   801029c0 <lapicinit>
  seginit();       // segment descriptors
80103240:	e8 bb 3b 00 00       	call   80106e00 <seginit>
  picinit();       // disable pic
80103245:	e8 86 03 00 00       	call   801035d0 <picinit>
  ioapicinit();    // another interrupt controller
8010324a:	e8 61 f2 ff ff       	call   801024b0 <ioapicinit>
  consoleinit();   // console hardware
8010324f:	e8 fc d8 ff ff       	call   80100b50 <consoleinit>
  uartinit();      // serial port
80103254:	e8 17 2e 00 00       	call   80106070 <uartinit>
  pinit();         // process table
80103259:	e8 42 08 00 00       	call   80103aa0 <pinit>
  tvinit();        // trap vectors
8010325e:	e8 7d 2a 00 00       	call   80105ce0 <tvinit>
  binit();         // buffer cache
80103263:	e8 d8 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103268:	e8 b3 dc ff ff       	call   80100f20 <fileinit>
  ideinit();       // disk 
8010326d:	e8 1e f0 ff ff       	call   80102290 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103272:	83 c4 0c             	add    $0xc,%esp
80103275:	68 8a 00 00 00       	push   $0x8a
8010327a:	68 8c b4 10 80       	push   $0x8010b48c
8010327f:	68 00 70 00 80       	push   $0x80007000
80103284:	e8 07 19 00 00       	call   80104b90 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103289:	83 c4 10             	add    $0x10,%esp
8010328c:	69 05 a4 37 11 80 b0 	imul   $0xb0,0x801137a4,%eax
80103293:	00 00 00 
80103296:	05 c0 37 11 80       	add    $0x801137c0,%eax
8010329b:	3d c0 37 11 80       	cmp    $0x801137c0,%eax
801032a0:	76 7e                	jbe    80103320 <main+0x110>
801032a2:	bb c0 37 11 80       	mov    $0x801137c0,%ebx
801032a7:	eb 20                	jmp    801032c9 <main+0xb9>
801032a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032b0:	69 05 a4 37 11 80 b0 	imul   $0xb0,0x801137a4,%eax
801032b7:	00 00 00 
801032ba:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032c0:	05 c0 37 11 80       	add    $0x801137c0,%eax
801032c5:	39 c3                	cmp    %eax,%ebx
801032c7:	73 57                	jae    80103320 <main+0x110>
    if(c == mycpu())  // We've started already.
801032c9:	e8 f2 07 00 00       	call   80103ac0 <mycpu>
801032ce:	39 c3                	cmp    %eax,%ebx
801032d0:	74 de                	je     801032b0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032d2:	e8 e9 f4 ff ff       	call   801027c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801032d7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801032da:	c7 05 f8 6f 00 80 f0 	movl   $0x801031f0,0x80006ff8
801032e1:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032e4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801032eb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801032ee:	05 00 10 00 00       	add    $0x1000,%eax
801032f3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801032f8:	0f b6 03             	movzbl (%ebx),%eax
801032fb:	68 00 70 00 00       	push   $0x7000
80103300:	50                   	push   %eax
80103301:	e8 fa f7 ff ff       	call   80102b00 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103306:	83 c4 10             	add    $0x10,%esp
80103309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103310:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103316:	85 c0                	test   %eax,%eax
80103318:	74 f6                	je     80103310 <main+0x100>
8010331a:	eb 94                	jmp    801032b0 <main+0xa0>
8010331c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103320:	83 ec 08             	sub    $0x8,%esp
80103323:	68 00 00 40 80       	push   $0x80400000
80103328:	68 00 00 40 80       	push   $0x80400000
8010332d:	e8 9e f3 ff ff       	call   801026d0 <kinit2>
  userinit();      // first user process
80103332:	e8 29 08 00 00       	call   80103b60 <userinit>
  mpmain();        // finish this processor's setup
80103337:	e8 74 fe ff ff       	call   801031b0 <mpmain>
8010333c:	66 90                	xchg   %ax,%ax
8010333e:	66 90                	xchg   %ax,%ax

80103340 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	57                   	push   %edi
80103344:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103345:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010334b:	53                   	push   %ebx
  e = addr+len;
8010334c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010334f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103352:	39 de                	cmp    %ebx,%esi
80103354:	72 10                	jb     80103366 <mpsearch1+0x26>
80103356:	eb 50                	jmp    801033a8 <mpsearch1+0x68>
80103358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010335f:	90                   	nop
80103360:	89 fe                	mov    %edi,%esi
80103362:	39 df                	cmp    %ebx,%edi
80103364:	73 42                	jae    801033a8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103366:	83 ec 04             	sub    $0x4,%esp
80103369:	8d 7e 10             	lea    0x10(%esi),%edi
8010336c:	6a 04                	push   $0x4
8010336e:	68 aa 7c 10 80       	push   $0x80107caa
80103373:	56                   	push   %esi
80103374:	e8 c7 17 00 00       	call   80104b40 <memcmp>
80103379:	83 c4 10             	add    $0x10,%esp
8010337c:	85 c0                	test   %eax,%eax
8010337e:	75 e0                	jne    80103360 <mpsearch1+0x20>
80103380:	89 f2                	mov    %esi,%edx
80103382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103388:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010338b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010338e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103390:	39 fa                	cmp    %edi,%edx
80103392:	75 f4                	jne    80103388 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103394:	84 c0                	test   %al,%al
80103396:	75 c8                	jne    80103360 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103398:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010339b:	89 f0                	mov    %esi,%eax
8010339d:	5b                   	pop    %ebx
8010339e:	5e                   	pop    %esi
8010339f:	5f                   	pop    %edi
801033a0:	5d                   	pop    %ebp
801033a1:	c3                   	ret
801033a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033ab:	31 f6                	xor    %esi,%esi
}
801033ad:	5b                   	pop    %ebx
801033ae:	89 f0                	mov    %esi,%eax
801033b0:	5e                   	pop    %esi
801033b1:	5f                   	pop    %edi
801033b2:	5d                   	pop    %ebp
801033b3:	c3                   	ret
801033b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033bf:	90                   	nop

801033c0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	57                   	push   %edi
801033c4:	56                   	push   %esi
801033c5:	53                   	push   %ebx
801033c6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033c9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033d0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033d7:	c1 e0 08             	shl    $0x8,%eax
801033da:	09 d0                	or     %edx,%eax
801033dc:	c1 e0 04             	shl    $0x4,%eax
801033df:	75 1b                	jne    801033fc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801033e1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033e8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801033ef:	c1 e0 08             	shl    $0x8,%eax
801033f2:	09 d0                	or     %edx,%eax
801033f4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801033f7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801033fc:	ba 00 04 00 00       	mov    $0x400,%edx
80103401:	e8 3a ff ff ff       	call   80103340 <mpsearch1>
80103406:	89 c3                	mov    %eax,%ebx
80103408:	85 c0                	test   %eax,%eax
8010340a:	0f 84 58 01 00 00    	je     80103568 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103410:	8b 73 04             	mov    0x4(%ebx),%esi
80103413:	85 f6                	test   %esi,%esi
80103415:	0f 84 3d 01 00 00    	je     80103558 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
8010341b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010341e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103424:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103427:	6a 04                	push   $0x4
80103429:	68 af 7c 10 80       	push   $0x80107caf
8010342e:	50                   	push   %eax
8010342f:	e8 0c 17 00 00       	call   80104b40 <memcmp>
80103434:	83 c4 10             	add    $0x10,%esp
80103437:	85 c0                	test   %eax,%eax
80103439:	0f 85 19 01 00 00    	jne    80103558 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010343f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103446:	3c 01                	cmp    $0x1,%al
80103448:	74 08                	je     80103452 <mpinit+0x92>
8010344a:	3c 04                	cmp    $0x4,%al
8010344c:	0f 85 06 01 00 00    	jne    80103558 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103452:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103459:	66 85 d2             	test   %dx,%dx
8010345c:	74 22                	je     80103480 <mpinit+0xc0>
8010345e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103461:	89 f0                	mov    %esi,%eax
  sum = 0;
80103463:	31 d2                	xor    %edx,%edx
80103465:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103468:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010346f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103472:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103474:	39 f8                	cmp    %edi,%eax
80103476:	75 f0                	jne    80103468 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103478:	84 d2                	test   %dl,%dl
8010347a:	0f 85 d8 00 00 00    	jne    80103558 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103480:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103486:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103489:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010348c:	a3 a4 36 11 80       	mov    %eax,0x801136a4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103491:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103498:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
8010349e:	01 d7                	add    %edx,%edi
801034a0:	89 fa                	mov    %edi,%edx
  ismp = 1;
801034a2:	bf 01 00 00 00       	mov    $0x1,%edi
801034a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034ae:	66 90                	xchg   %ax,%ax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034b0:	39 d0                	cmp    %edx,%eax
801034b2:	73 19                	jae    801034cd <mpinit+0x10d>
    switch(*p){
801034b4:	0f b6 08             	movzbl (%eax),%ecx
801034b7:	80 f9 02             	cmp    $0x2,%cl
801034ba:	0f 84 80 00 00 00    	je     80103540 <mpinit+0x180>
801034c0:	77 6e                	ja     80103530 <mpinit+0x170>
801034c2:	84 c9                	test   %cl,%cl
801034c4:	74 3a                	je     80103500 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034c6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034c9:	39 d0                	cmp    %edx,%eax
801034cb:	72 e7                	jb     801034b4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034cd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801034d0:	85 ff                	test   %edi,%edi
801034d2:	0f 84 dd 00 00 00    	je     801035b5 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034d8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801034dc:	74 15                	je     801034f3 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034de:	b8 70 00 00 00       	mov    $0x70,%eax
801034e3:	ba 22 00 00 00       	mov    $0x22,%edx
801034e8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034e9:	ba 23 00 00 00       	mov    $0x23,%edx
801034ee:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801034ef:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034f2:	ee                   	out    %al,(%dx)
  }
}
801034f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034f6:	5b                   	pop    %ebx
801034f7:	5e                   	pop    %esi
801034f8:	5f                   	pop    %edi
801034f9:	5d                   	pop    %ebp
801034fa:	c3                   	ret
801034fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034ff:	90                   	nop
      if(ncpu < NCPU) {
80103500:	8b 0d a4 37 11 80    	mov    0x801137a4,%ecx
80103506:	85 c9                	test   %ecx,%ecx
80103508:	7f 19                	jg     80103523 <mpinit+0x163>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010350a:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80103510:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103514:	83 c1 01             	add    $0x1,%ecx
80103517:	89 0d a4 37 11 80    	mov    %ecx,0x801137a4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010351d:	88 9e c0 37 11 80    	mov    %bl,-0x7feec840(%esi)
      p += sizeof(struct mpproc);
80103523:	83 c0 14             	add    $0x14,%eax
      continue;
80103526:	eb 88                	jmp    801034b0 <mpinit+0xf0>
80103528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010352f:	90                   	nop
    switch(*p){
80103530:	83 e9 03             	sub    $0x3,%ecx
80103533:	80 f9 01             	cmp    $0x1,%cl
80103536:	76 8e                	jbe    801034c6 <mpinit+0x106>
80103538:	31 ff                	xor    %edi,%edi
8010353a:	e9 71 ff ff ff       	jmp    801034b0 <mpinit+0xf0>
8010353f:	90                   	nop
      ioapicid = ioapic->apicno;
80103540:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103544:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103547:	88 0d a0 37 11 80    	mov    %cl,0x801137a0
      continue;
8010354d:	e9 5e ff ff ff       	jmp    801034b0 <mpinit+0xf0>
80103552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103558:	83 ec 0c             	sub    $0xc,%esp
8010355b:	68 b4 7c 10 80       	push   $0x80107cb4
80103560:	e8 0b cf ff ff       	call   80100470 <panic>
80103565:	8d 76 00             	lea    0x0(%esi),%esi
{
80103568:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010356d:	eb 0b                	jmp    8010357a <mpinit+0x1ba>
8010356f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103570:	89 f3                	mov    %esi,%ebx
80103572:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103578:	74 de                	je     80103558 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010357a:	83 ec 04             	sub    $0x4,%esp
8010357d:	8d 73 10             	lea    0x10(%ebx),%esi
80103580:	6a 04                	push   $0x4
80103582:	68 aa 7c 10 80       	push   $0x80107caa
80103587:	53                   	push   %ebx
80103588:	e8 b3 15 00 00       	call   80104b40 <memcmp>
8010358d:	83 c4 10             	add    $0x10,%esp
80103590:	85 c0                	test   %eax,%eax
80103592:	75 dc                	jne    80103570 <mpinit+0x1b0>
80103594:	89 da                	mov    %ebx,%edx
80103596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010359d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035a0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801035a3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801035a6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801035a8:	39 d6                	cmp    %edx,%esi
801035aa:	75 f4                	jne    801035a0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035ac:	84 c0                	test   %al,%al
801035ae:	75 c0                	jne    80103570 <mpinit+0x1b0>
801035b0:	e9 5b fe ff ff       	jmp    80103410 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801035b5:	83 ec 0c             	sub    $0xc,%esp
801035b8:	68 f8 80 10 80       	push   $0x801080f8
801035bd:	e8 ae ce ff ff       	call   80100470 <panic>
801035c2:	66 90                	xchg   %ax,%ax
801035c4:	66 90                	xchg   %ax,%ax
801035c6:	66 90                	xchg   %ax,%ax
801035c8:	66 90                	xchg   %ax,%ax
801035ca:	66 90                	xchg   %ax,%ax
801035cc:	66 90                	xchg   %ax,%ax
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <picinit>:
801035d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035d5:	ba 21 00 00 00       	mov    $0x21,%edx
801035da:	ee                   	out    %al,(%dx)
801035db:	ba a1 00 00 00       	mov    $0xa1,%edx
801035e0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801035e1:	c3                   	ret
801035e2:	66 90                	xchg   %ax,%ax
801035e4:	66 90                	xchg   %ax,%ax
801035e6:	66 90                	xchg   %ax,%ax
801035e8:	66 90                	xchg   %ax,%ax
801035ea:	66 90                	xchg   %ax,%ax
801035ec:	66 90                	xchg   %ax,%ax
801035ee:	66 90                	xchg   %ax,%ax

801035f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	57                   	push   %edi
801035f4:	56                   	push   %esi
801035f5:	53                   	push   %ebx
801035f6:	83 ec 0c             	sub    $0xc,%esp
801035f9:	8b 75 08             	mov    0x8(%ebp),%esi
801035fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801035ff:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103605:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010360b:	e8 30 d9 ff ff       	call   80100f40 <filealloc>
80103610:	89 06                	mov    %eax,(%esi)
80103612:	85 c0                	test   %eax,%eax
80103614:	0f 84 a5 00 00 00    	je     801036bf <pipealloc+0xcf>
8010361a:	e8 21 d9 ff ff       	call   80100f40 <filealloc>
8010361f:	89 07                	mov    %eax,(%edi)
80103621:	85 c0                	test   %eax,%eax
80103623:	0f 84 84 00 00 00    	je     801036ad <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103629:	e8 92 f1 ff ff       	call   801027c0 <kalloc>
8010362e:	89 c3                	mov    %eax,%ebx
80103630:	85 c0                	test   %eax,%eax
80103632:	0f 84 a0 00 00 00    	je     801036d8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103638:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010363f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103642:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103645:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010364c:	00 00 00 
  p->nwrite = 0;
8010364f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103656:	00 00 00 
  p->nread = 0;
80103659:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103660:	00 00 00 
  initlock(&p->lock, "pipe");
80103663:	68 cc 7c 10 80       	push   $0x80107ccc
80103668:	50                   	push   %eax
80103669:	e8 a2 11 00 00       	call   80104810 <initlock>
  (*f0)->type = FD_PIPE;
8010366e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103670:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103673:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103679:	8b 06                	mov    (%esi),%eax
8010367b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010367f:	8b 06                	mov    (%esi),%eax
80103681:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103685:	8b 06                	mov    (%esi),%eax
80103687:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010368a:	8b 07                	mov    (%edi),%eax
8010368c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103692:	8b 07                	mov    (%edi),%eax
80103694:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103698:	8b 07                	mov    (%edi),%eax
8010369a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010369e:	8b 07                	mov    (%edi),%eax
801036a0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801036a3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036a8:	5b                   	pop    %ebx
801036a9:	5e                   	pop    %esi
801036aa:	5f                   	pop    %edi
801036ab:	5d                   	pop    %ebp
801036ac:	c3                   	ret
  if(*f0)
801036ad:	8b 06                	mov    (%esi),%eax
801036af:	85 c0                	test   %eax,%eax
801036b1:	74 1e                	je     801036d1 <pipealloc+0xe1>
    fileclose(*f0);
801036b3:	83 ec 0c             	sub    $0xc,%esp
801036b6:	50                   	push   %eax
801036b7:	e8 44 d9 ff ff       	call   80101000 <fileclose>
801036bc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801036bf:	8b 07                	mov    (%edi),%eax
801036c1:	85 c0                	test   %eax,%eax
801036c3:	74 0c                	je     801036d1 <pipealloc+0xe1>
    fileclose(*f1);
801036c5:	83 ec 0c             	sub    $0xc,%esp
801036c8:	50                   	push   %eax
801036c9:	e8 32 d9 ff ff       	call   80101000 <fileclose>
801036ce:	83 c4 10             	add    $0x10,%esp
  return -1;
801036d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801036d6:	eb cd                	jmp    801036a5 <pipealloc+0xb5>
  if(*f0)
801036d8:	8b 06                	mov    (%esi),%eax
801036da:	85 c0                	test   %eax,%eax
801036dc:	75 d5                	jne    801036b3 <pipealloc+0xc3>
801036de:	eb df                	jmp    801036bf <pipealloc+0xcf>

801036e0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	56                   	push   %esi
801036e4:	53                   	push   %ebx
801036e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801036eb:	83 ec 0c             	sub    $0xc,%esp
801036ee:	53                   	push   %ebx
801036ef:	e8 0c 13 00 00       	call   80104a00 <acquire>
  if(writable){
801036f4:	83 c4 10             	add    $0x10,%esp
801036f7:	85 f6                	test   %esi,%esi
801036f9:	74 65                	je     80103760 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801036fb:	83 ec 0c             	sub    $0xc,%esp
801036fe:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103704:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010370b:	00 00 00 
    wakeup(&p->nread);
8010370e:	50                   	push   %eax
8010370f:	e8 0c 0c 00 00       	call   80104320 <wakeup>
80103714:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103717:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010371d:	85 d2                	test   %edx,%edx
8010371f:	75 0a                	jne    8010372b <pipeclose+0x4b>
80103721:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103727:	85 c0                	test   %eax,%eax
80103729:	74 15                	je     80103740 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010372b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010372e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103731:	5b                   	pop    %ebx
80103732:	5e                   	pop    %esi
80103733:	5d                   	pop    %ebp
    release(&p->lock);
80103734:	e9 67 12 00 00       	jmp    801049a0 <release>
80103739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103740:	83 ec 0c             	sub    $0xc,%esp
80103743:	53                   	push   %ebx
80103744:	e8 57 12 00 00       	call   801049a0 <release>
    kfree((char*)p);
80103749:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010374c:	83 c4 10             	add    $0x10,%esp
}
8010374f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103752:	5b                   	pop    %ebx
80103753:	5e                   	pop    %esi
80103754:	5d                   	pop    %ebp
    kfree((char*)p);
80103755:	e9 46 ee ff ff       	jmp    801025a0 <kfree>
8010375a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103760:	83 ec 0c             	sub    $0xc,%esp
80103763:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103769:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103770:	00 00 00 
    wakeup(&p->nwrite);
80103773:	50                   	push   %eax
80103774:	e8 a7 0b 00 00       	call   80104320 <wakeup>
80103779:	83 c4 10             	add    $0x10,%esp
8010377c:	eb 99                	jmp    80103717 <pipeclose+0x37>
8010377e:	66 90                	xchg   %ax,%ax

80103780 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	57                   	push   %edi
80103784:	56                   	push   %esi
80103785:	53                   	push   %ebx
80103786:	83 ec 28             	sub    $0x28,%esp
80103789:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010378c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010378f:	53                   	push   %ebx
80103790:	e8 6b 12 00 00       	call   80104a00 <acquire>
  for(i = 0; i < n; i++){
80103795:	83 c4 10             	add    $0x10,%esp
80103798:	85 ff                	test   %edi,%edi
8010379a:	0f 8e ce 00 00 00    	jle    8010386e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037a0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801037a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801037a9:	89 7d 10             	mov    %edi,0x10(%ebp)
801037ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801037af:	8d 34 39             	lea    (%ecx,%edi,1),%esi
801037b2:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037b5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037bb:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037c1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037c7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801037cd:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801037d0:	0f 85 b6 00 00 00    	jne    8010388c <pipewrite+0x10c>
801037d6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801037d9:	eb 3b                	jmp    80103816 <pipewrite+0x96>
801037db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037df:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
801037e0:	e8 4b 03 00 00       	call   80103b30 <myproc>
801037e5:	8b 48 28             	mov    0x28(%eax),%ecx
801037e8:	85 c9                	test   %ecx,%ecx
801037ea:	75 34                	jne    80103820 <pipewrite+0xa0>
      wakeup(&p->nread);
801037ec:	83 ec 0c             	sub    $0xc,%esp
801037ef:	56                   	push   %esi
801037f0:	e8 2b 0b 00 00       	call   80104320 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037f5:	58                   	pop    %eax
801037f6:	5a                   	pop    %edx
801037f7:	53                   	push   %ebx
801037f8:	57                   	push   %edi
801037f9:	e8 62 0a 00 00       	call   80104260 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037fe:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103804:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010380a:	83 c4 10             	add    $0x10,%esp
8010380d:	05 00 02 00 00       	add    $0x200,%eax
80103812:	39 c2                	cmp    %eax,%edx
80103814:	75 2a                	jne    80103840 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103816:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010381c:	85 c0                	test   %eax,%eax
8010381e:	75 c0                	jne    801037e0 <pipewrite+0x60>
        release(&p->lock);
80103820:	83 ec 0c             	sub    $0xc,%esp
80103823:	53                   	push   %ebx
80103824:	e8 77 11 00 00       	call   801049a0 <release>
        return -1;
80103829:	83 c4 10             	add    $0x10,%esp
8010382c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103831:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103834:	5b                   	pop    %ebx
80103835:	5e                   	pop    %esi
80103836:	5f                   	pop    %edi
80103837:	5d                   	pop    %ebp
80103838:	c3                   	ret
80103839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103840:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103843:	8d 42 01             	lea    0x1(%edx),%eax
80103846:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010384c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010384f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103855:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103858:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010385c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103860:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103863:	39 c1                	cmp    %eax,%ecx
80103865:	0f 85 50 ff ff ff    	jne    801037bb <pipewrite+0x3b>
8010386b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010386e:	83 ec 0c             	sub    $0xc,%esp
80103871:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103877:	50                   	push   %eax
80103878:	e8 a3 0a 00 00       	call   80104320 <wakeup>
  release(&p->lock);
8010387d:	89 1c 24             	mov    %ebx,(%esp)
80103880:	e8 1b 11 00 00       	call   801049a0 <release>
  return n;
80103885:	83 c4 10             	add    $0x10,%esp
80103888:	89 f8                	mov    %edi,%eax
8010388a:	eb a5                	jmp    80103831 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010388c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010388f:	eb b2                	jmp    80103843 <pipewrite+0xc3>
80103891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103898:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010389f:	90                   	nop

801038a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	57                   	push   %edi
801038a4:	56                   	push   %esi
801038a5:	53                   	push   %ebx
801038a6:	83 ec 18             	sub    $0x18,%esp
801038a9:	8b 75 08             	mov    0x8(%ebp),%esi
801038ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038af:	56                   	push   %esi
801038b0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801038b6:	e8 45 11 00 00       	call   80104a00 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038bb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038c1:	83 c4 10             	add    $0x10,%esp
801038c4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801038ca:	74 2f                	je     801038fb <piperead+0x5b>
801038cc:	eb 37                	jmp    80103905 <piperead+0x65>
801038ce:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801038d0:	e8 5b 02 00 00       	call   80103b30 <myproc>
801038d5:	8b 40 28             	mov    0x28(%eax),%eax
801038d8:	85 c0                	test   %eax,%eax
801038da:	0f 85 80 00 00 00    	jne    80103960 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038e0:	83 ec 08             	sub    $0x8,%esp
801038e3:	56                   	push   %esi
801038e4:	53                   	push   %ebx
801038e5:	e8 76 09 00 00       	call   80104260 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038ea:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038f0:	83 c4 10             	add    $0x10,%esp
801038f3:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801038f9:	75 0a                	jne    80103905 <piperead+0x65>
801038fb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103901:	85 d2                	test   %edx,%edx
80103903:	75 cb                	jne    801038d0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103905:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103908:	31 db                	xor    %ebx,%ebx
8010390a:	85 c9                	test   %ecx,%ecx
8010390c:	7f 26                	jg     80103934 <piperead+0x94>
8010390e:	eb 2c                	jmp    8010393c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103910:	8d 48 01             	lea    0x1(%eax),%ecx
80103913:	25 ff 01 00 00       	and    $0x1ff,%eax
80103918:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010391e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103923:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103926:	83 c3 01             	add    $0x1,%ebx
80103929:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010392c:	74 0e                	je     8010393c <piperead+0x9c>
8010392e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103934:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010393a:	75 d4                	jne    80103910 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010393c:	83 ec 0c             	sub    $0xc,%esp
8010393f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103945:	50                   	push   %eax
80103946:	e8 d5 09 00 00       	call   80104320 <wakeup>
  release(&p->lock);
8010394b:	89 34 24             	mov    %esi,(%esp)
8010394e:	e8 4d 10 00 00       	call   801049a0 <release>
  return i;
80103953:	83 c4 10             	add    $0x10,%esp
}
80103956:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103959:	89 d8                	mov    %ebx,%eax
8010395b:	5b                   	pop    %ebx
8010395c:	5e                   	pop    %esi
8010395d:	5f                   	pop    %edi
8010395e:	5d                   	pop    %ebp
8010395f:	c3                   	ret
      release(&p->lock);
80103960:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103963:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103968:	56                   	push   %esi
80103969:	e8 32 10 00 00       	call   801049a0 <release>
      return -1;
8010396e:	83 c4 10             	add    $0x10,%esp
}
80103971:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103974:	89 d8                	mov    %ebx,%eax
80103976:	5b                   	pop    %ebx
80103977:	5e                   	pop    %esi
80103978:	5f                   	pop    %edi
80103979:	5d                   	pop    %ebp
8010397a:	c3                   	ret
8010397b:	66 90                	xchg   %ax,%ax
8010397d:	66 90                	xchg   %ax,%ax
8010397f:	90                   	nop

80103980 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103984:	bb b4 38 11 80       	mov    $0x801138b4,%ebx
{
80103989:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010398c:	68 80 38 11 80       	push   $0x80113880
80103991:	e8 6a 10 00 00       	call   80104a00 <acquire>
80103996:	83 c4 10             	add    $0x10,%esp
80103999:	eb 10                	jmp    801039ab <allocproc+0x2b>
8010399b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010399f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039a0:	83 eb 80             	sub    $0xffffff80,%ebx
801039a3:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
801039a9:	74 75                	je     80103a20 <allocproc+0xa0>
    if(p->state == UNUSED)
801039ab:	8b 43 10             	mov    0x10(%ebx),%eax
801039ae:	85 c0                	test   %eax,%eax
801039b0:	75 ee                	jne    801039a0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039b2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801039b7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039ba:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
801039c1:	89 43 14             	mov    %eax,0x14(%ebx)
801039c4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801039c7:	68 80 38 11 80       	push   $0x80113880
  p->pid = nextpid++;
801039cc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801039d2:	e8 c9 0f 00 00       	call   801049a0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039d7:	e8 e4 ed ff ff       	call   801027c0 <kalloc>
801039dc:	83 c4 10             	add    $0x10,%esp
801039df:	89 43 0c             	mov    %eax,0xc(%ebx)
801039e2:	85 c0                	test   %eax,%eax
801039e4:	74 53                	je     80103a39 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039e6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039ec:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801039ef:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801039f4:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
801039f7:	c7 40 14 d2 5c 10 80 	movl   $0x80105cd2,0x14(%eax)
  p->context = (struct context*)sp;
801039fe:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a01:	6a 14                	push   $0x14
80103a03:	6a 00                	push   $0x0
80103a05:	50                   	push   %eax
80103a06:	e8 f5 10 00 00       	call   80104b00 <memset>
  p->context->eip = (uint)forkret;
80103a0b:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
80103a0e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a11:	c7 40 10 50 3a 10 80 	movl   $0x80103a50,0x10(%eax)
}
80103a18:	89 d8                	mov    %ebx,%eax
80103a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a1d:	c9                   	leave
80103a1e:	c3                   	ret
80103a1f:	90                   	nop
  release(&ptable.lock);
80103a20:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a23:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a25:	68 80 38 11 80       	push   $0x80113880
80103a2a:	e8 71 0f 00 00       	call   801049a0 <release>
  return 0;
80103a2f:	83 c4 10             	add    $0x10,%esp
}
80103a32:	89 d8                	mov    %ebx,%eax
80103a34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a37:	c9                   	leave
80103a38:	c3                   	ret
    p->state = UNUSED;
80103a39:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  return 0;
80103a40:	31 db                	xor    %ebx,%ebx
80103a42:	eb ee                	jmp    80103a32 <allocproc+0xb2>
80103a44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a4f:	90                   	nop

80103a50 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a56:	68 80 38 11 80       	push   $0x80113880
80103a5b:	e8 40 0f 00 00       	call   801049a0 <release>

  if (first) {
80103a60:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a65:	83 c4 10             	add    $0x10,%esp
80103a68:	85 c0                	test   %eax,%eax
80103a6a:	75 04                	jne    80103a70 <forkret+0x20>
    initlog(ROOTDEV);
    swapinit();
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a6c:	c9                   	leave
80103a6d:	c3                   	ret
80103a6e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a70:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a77:	00 00 00 
    iinit(ROOTDEV);
80103a7a:	83 ec 0c             	sub    $0xc,%esp
80103a7d:	6a 01                	push   $0x1
80103a7f:	e8 ec db ff ff       	call   80101670 <iinit>
    initlog(ROOTDEV);
80103a84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a8b:	e8 f0 f3 ff ff       	call   80102e80 <initlog>
    swapinit();
80103a90:	83 c4 10             	add    $0x10,%esp
}
80103a93:	c9                   	leave
    swapinit();
80103a94:	e9 b7 3c 00 00       	jmp    80107750 <swapinit>
80103a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103aa0 <pinit>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103aa6:	68 d1 7c 10 80       	push   $0x80107cd1
80103aab:	68 80 38 11 80       	push   $0x80113880
80103ab0:	e8 5b 0d 00 00       	call   80104810 <initlock>
}
80103ab5:	83 c4 10             	add    $0x10,%esp
80103ab8:	c9                   	leave
80103ab9:	c3                   	ret
80103aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ac0 <mycpu>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ac6:	9c                   	pushf
80103ac7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ac8:	f6 c4 02             	test   $0x2,%ah
80103acb:	75 32                	jne    80103aff <mycpu+0x3f>
  apicid = lapicid();
80103acd:	e8 de ef ff ff       	call   80102ab0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ad2:	8b 15 a4 37 11 80    	mov    0x801137a4,%edx
80103ad8:	85 d2                	test   %edx,%edx
80103ada:	7e 0b                	jle    80103ae7 <mycpu+0x27>
    if (cpus[i].apicid == apicid)
80103adc:	0f b6 15 c0 37 11 80 	movzbl 0x801137c0,%edx
80103ae3:	39 d0                	cmp    %edx,%eax
80103ae5:	74 11                	je     80103af8 <mycpu+0x38>
  panic("unknown apicid\n");
80103ae7:	83 ec 0c             	sub    $0xc,%esp
80103aea:	68 d8 7c 10 80       	push   $0x80107cd8
80103aef:	e8 7c c9 ff ff       	call   80100470 <panic>
80103af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80103af8:	c9                   	leave
80103af9:	b8 c0 37 11 80       	mov    $0x801137c0,%eax
80103afe:	c3                   	ret
    panic("mycpu called with interrupts enabled\n");
80103aff:	83 ec 0c             	sub    $0xc,%esp
80103b02:	68 18 81 10 80       	push   $0x80108118
80103b07:	e8 64 c9 ff ff       	call   80100470 <panic>
80103b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b10 <cpuid>:
cpuid() {
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b16:	e8 a5 ff ff ff       	call   80103ac0 <mycpu>
}
80103b1b:	c9                   	leave
  return mycpu()-cpus;
80103b1c:	2d c0 37 11 80       	sub    $0x801137c0,%eax
80103b21:	c1 f8 04             	sar    $0x4,%eax
80103b24:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b2a:	c3                   	ret
80103b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b2f:	90                   	nop

80103b30 <myproc>:
myproc(void) {
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	53                   	push   %ebx
80103b34:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b37:	e8 74 0d 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80103b3c:	e8 7f ff ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
80103b41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b47:	e8 b4 0d 00 00       	call   80104900 <popcli>
}
80103b4c:	89 d8                	mov    %ebx,%eax
80103b4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b51:	c9                   	leave
80103b52:	c3                   	ret
80103b53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b60 <userinit>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	53                   	push   %ebx
80103b64:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b67:	e8 14 fe ff ff       	call   80103980 <allocproc>
80103b6c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b6e:	a3 b4 58 11 80       	mov    %eax,0x801158b4
  if((p->pgdir = setupkvm()) == 0)
80103b73:	e8 58 37 00 00       	call   801072d0 <setupkvm>
80103b78:	89 43 08             	mov    %eax,0x8(%ebx)
80103b7b:	85 c0                	test   %eax,%eax
80103b7d:	0f 84 bd 00 00 00    	je     80103c40 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b83:	83 ec 04             	sub    $0x4,%esp
80103b86:	68 2c 00 00 00       	push   $0x2c
80103b8b:	68 60 b4 10 80       	push   $0x8010b460
80103b90:	50                   	push   %eax
80103b91:	e8 1a 34 00 00       	call   80106fb0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b9f:	6a 4c                	push   $0x4c
80103ba1:	6a 00                	push   $0x0
80103ba3:	ff 73 1c             	push   0x1c(%ebx)
80103ba6:	e8 55 0f 00 00       	call   80104b00 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bab:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bb3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bb6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bbb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bbf:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bc2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bc6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bc9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bcd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bd1:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bd4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bd8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bdc:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bdf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103be6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103be9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103bf0:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bf3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bfa:	8d 43 70             	lea    0x70(%ebx),%eax
80103bfd:	6a 10                	push   $0x10
80103bff:	68 01 7d 10 80       	push   $0x80107d01
80103c04:	50                   	push   %eax
80103c05:	e8 a6 10 00 00       	call   80104cb0 <safestrcpy>
  p->cwd = namei("/");
80103c0a:	c7 04 24 0a 7d 10 80 	movl   $0x80107d0a,(%esp)
80103c11:	e8 5a e5 ff ff       	call   80102170 <namei>
80103c16:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
80103c19:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103c20:	e8 db 0d 00 00       	call   80104a00 <acquire>
  p->state = RUNNABLE;
80103c25:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
80103c2c:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103c33:	e8 68 0d 00 00       	call   801049a0 <release>
}
80103c38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c3b:	83 c4 10             	add    $0x10,%esp
80103c3e:	c9                   	leave
80103c3f:	c3                   	ret
    panic("userinit: out of memory?");
80103c40:	83 ec 0c             	sub    $0xc,%esp
80103c43:	68 e8 7c 10 80       	push   $0x80107ce8
80103c48:	e8 23 c8 ff ff       	call   80100470 <panic>
80103c4d:	8d 76 00             	lea    0x0(%esi),%esi

80103c50 <growproc>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	56                   	push   %esi
80103c54:	53                   	push   %ebx
80103c55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c58:	e8 53 0c 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80103c5d:	e8 5e fe ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
80103c62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c68:	e8 93 0c 00 00       	call   80104900 <popcli>
  sz = curproc->sz;
80103c6d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c6f:	85 f6                	test   %esi,%esi
80103c71:	7f 1d                	jg     80103c90 <growproc+0x40>
  } else if(n < 0){
80103c73:	75 3b                	jne    80103cb0 <growproc+0x60>
  switchuvm(curproc);
80103c75:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c78:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c7a:	53                   	push   %ebx
80103c7b:	e8 20 32 00 00       	call   80106ea0 <switchuvm>
  return 0;
80103c80:	83 c4 10             	add    $0x10,%esp
80103c83:	31 c0                	xor    %eax,%eax
}
80103c85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c88:	5b                   	pop    %ebx
80103c89:	5e                   	pop    %esi
80103c8a:	5d                   	pop    %ebp
80103c8b:	c3                   	ret
80103c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c90:	83 ec 04             	sub    $0x4,%esp
80103c93:	01 c6                	add    %eax,%esi
80103c95:	56                   	push   %esi
80103c96:	50                   	push   %eax
80103c97:	ff 73 08             	push   0x8(%ebx)
80103c9a:	e8 61 34 00 00       	call   80107100 <allocuvm>
80103c9f:	83 c4 10             	add    $0x10,%esp
80103ca2:	85 c0                	test   %eax,%eax
80103ca4:	75 cf                	jne    80103c75 <growproc+0x25>
      return -1;
80103ca6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cab:	eb d8                	jmp    80103c85 <growproc+0x35>
80103cad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cb0:	83 ec 04             	sub    $0x4,%esp
80103cb3:	01 c6                	add    %eax,%esi
80103cb5:	56                   	push   %esi
80103cb6:	50                   	push   %eax
80103cb7:	ff 73 08             	push   0x8(%ebx)
80103cba:	e8 61 35 00 00       	call   80107220 <deallocuvm>
80103cbf:	83 c4 10             	add    $0x10,%esp
80103cc2:	85 c0                	test   %eax,%eax
80103cc4:	75 af                	jne    80103c75 <growproc+0x25>
80103cc6:	eb de                	jmp    80103ca6 <growproc+0x56>
80103cc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ccf:	90                   	nop

80103cd0 <fork>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	57                   	push   %edi
80103cd4:	56                   	push   %esi
80103cd5:	53                   	push   %ebx
80103cd6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103cd9:	e8 d2 0b 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80103cde:	e8 dd fd ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
80103ce3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ce9:	e8 12 0c 00 00       	call   80104900 <popcli>
  if((np = allocproc()) == 0){
80103cee:	e8 8d fc ff ff       	call   80103980 <allocproc>
80103cf3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103cf6:	85 c0                	test   %eax,%eax
80103cf8:	0f 84 d6 00 00 00    	je     80103dd4 <fork+0x104>
  if((np->pgdir = copyuvm_cow(curproc->pgdir, curproc->sz)) == 0){
80103cfe:	83 ec 08             	sub    $0x8,%esp
80103d01:	ff 33                	push   (%ebx)
80103d03:	89 c7                	mov    %eax,%edi
80103d05:	ff 73 08             	push   0x8(%ebx)
80103d08:	e8 e3 37 00 00       	call   801074f0 <copyuvm_cow>
80103d0d:	83 c4 10             	add    $0x10,%esp
80103d10:	89 47 08             	mov    %eax,0x8(%edi)
80103d13:	85 c0                	test   %eax,%eax
80103d15:	0f 84 9a 00 00 00    	je     80103db5 <fork+0xe5>
  np->sz = curproc->sz;
80103d1b:	8b 03                	mov    (%ebx),%eax
80103d1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d20:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d22:	8b 79 1c             	mov    0x1c(%ecx),%edi
  np->parent = curproc;
80103d25:	89 c8                	mov    %ecx,%eax
80103d27:	89 59 18             	mov    %ebx,0x18(%ecx)
  *np->tf = *curproc->tf;
80103d2a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d2f:	8b 73 1c             	mov    0x1c(%ebx),%esi
80103d32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d34:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d36:	8b 40 1c             	mov    0x1c(%eax),%eax
80103d39:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103d40:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103d44:	85 c0                	test   %eax,%eax
80103d46:	74 13                	je     80103d5b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d48:	83 ec 0c             	sub    $0xc,%esp
80103d4b:	50                   	push   %eax
80103d4c:	e8 5f d2 ff ff       	call   80100fb0 <filedup>
80103d51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d54:	83 c4 10             	add    $0x10,%esp
80103d57:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d5b:	83 c6 01             	add    $0x1,%esi
80103d5e:	83 fe 10             	cmp    $0x10,%esi
80103d61:	75 dd                	jne    80103d40 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103d63:	83 ec 0c             	sub    $0xc,%esp
80103d66:	ff 73 6c             	push   0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d69:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103d6c:	e8 ef da ff ff       	call   80101860 <idup>
80103d71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d74:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d77:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d7a:	8d 47 70             	lea    0x70(%edi),%eax
80103d7d:	6a 10                	push   $0x10
80103d7f:	53                   	push   %ebx
80103d80:	50                   	push   %eax
80103d81:	e8 2a 0f 00 00       	call   80104cb0 <safestrcpy>
  pid = np->pid;
80103d86:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
80103d89:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103d90:	e8 6b 0c 00 00       	call   80104a00 <acquire>
  np->state = RUNNABLE;
80103d95:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
80103d9c:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103da3:	e8 f8 0b 00 00       	call   801049a0 <release>
  return pid;
80103da8:	83 c4 10             	add    $0x10,%esp
}
80103dab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dae:	89 d8                	mov    %ebx,%eax
80103db0:	5b                   	pop    %ebx
80103db1:	5e                   	pop    %esi
80103db2:	5f                   	pop    %edi
80103db3:	5d                   	pop    %ebp
80103db4:	c3                   	ret
    kfree(np->kstack);
80103db5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103db8:	83 ec 0c             	sub    $0xc,%esp
80103dbb:	ff 73 0c             	push   0xc(%ebx)
80103dbe:	e8 dd e7 ff ff       	call   801025a0 <kfree>
    np->kstack = 0;
80103dc3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103dca:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103dcd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
80103dd4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103dd9:	eb d0                	jmp    80103dab <fork+0xdb>
80103ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ddf:	90                   	nop

80103de0 <print_rss>:
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103de4:	bb b4 38 11 80       	mov    $0x801138b4,%ebx
{
80103de9:	83 ec 10             	sub    $0x10,%esp
  cprintf("PrintingRSS\n");
80103dec:	68 0c 7d 10 80       	push   $0x80107d0c
80103df1:	e8 aa c9 ff ff       	call   801007a0 <cprintf>
  acquire(&ptable.lock);
80103df6:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103dfd:	e8 fe 0b 00 00       	call   80104a00 <acquire>
80103e02:	83 c4 10             	add    $0x10,%esp
80103e05:	8d 76 00             	lea    0x0(%esi),%esi
    if((p->state == UNUSED))
80103e08:	8b 43 10             	mov    0x10(%ebx),%eax
80103e0b:	85 c0                	test   %eax,%eax
80103e0d:	74 14                	je     80103e23 <print_rss+0x43>
    cprintf("((P)) id: %d, state: %d, rss: %d\n",p->pid,p->state,p->rss);
80103e0f:	ff 73 04             	push   0x4(%ebx)
80103e12:	50                   	push   %eax
80103e13:	ff 73 14             	push   0x14(%ebx)
80103e16:	68 40 81 10 80       	push   $0x80108140
80103e1b:	e8 80 c9 ff ff       	call   801007a0 <cprintf>
80103e20:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e23:	83 eb 80             	sub    $0xffffff80,%ebx
80103e26:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
80103e2c:	75 da                	jne    80103e08 <print_rss+0x28>
  release(&ptable.lock);
80103e2e:	83 ec 0c             	sub    $0xc,%esp
80103e31:	68 80 38 11 80       	push   $0x80113880
80103e36:	e8 65 0b 00 00       	call   801049a0 <release>
}
80103e3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e3e:	83 c4 10             	add    $0x10,%esp
80103e41:	c9                   	leave
80103e42:	c3                   	ret
80103e43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e50 <scheduler>:
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	57                   	push   %edi
80103e54:	56                   	push   %esi
80103e55:	53                   	push   %ebx
80103e56:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e59:	e8 62 fc ff ff       	call   80103ac0 <mycpu>
  c->proc = 0;
80103e5e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e65:	00 00 00 
  struct cpu *c = mycpu();
80103e68:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e6a:	8d 78 04             	lea    0x4(%eax),%edi
80103e6d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e70:	fb                   	sti
    acquire(&ptable.lock);
80103e71:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e74:	bb b4 38 11 80       	mov    $0x801138b4,%ebx
    acquire(&ptable.lock);
80103e79:	68 80 38 11 80       	push   $0x80113880
80103e7e:	e8 7d 0b 00 00       	call   80104a00 <acquire>
80103e83:	83 c4 10             	add    $0x10,%esp
80103e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103e90:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80103e94:	75 33                	jne    80103ec9 <scheduler+0x79>
      switchuvm(p);
80103e96:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e99:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e9f:	53                   	push   %ebx
80103ea0:	e8 fb 2f 00 00       	call   80106ea0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ea5:	58                   	pop    %eax
80103ea6:	5a                   	pop    %edx
80103ea7:	ff 73 20             	push   0x20(%ebx)
80103eaa:	57                   	push   %edi
      p->state = RUNNING;
80103eab:	c7 43 10 04 00 00 00 	movl   $0x4,0x10(%ebx)
      swtch(&(c->scheduler), p->context);
80103eb2:	e8 54 0e 00 00       	call   80104d0b <swtch>
      switchkvm();
80103eb7:	e8 d4 2f 00 00       	call   80106e90 <switchkvm>
      c->proc = 0;
80103ebc:	83 c4 10             	add    $0x10,%esp
80103ebf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ec6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec9:	83 eb 80             	sub    $0xffffff80,%ebx
80103ecc:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
80103ed2:	75 bc                	jne    80103e90 <scheduler+0x40>
    release(&ptable.lock);
80103ed4:	83 ec 0c             	sub    $0xc,%esp
80103ed7:	68 80 38 11 80       	push   $0x80113880
80103edc:	e8 bf 0a 00 00       	call   801049a0 <release>
    sti();
80103ee1:	83 c4 10             	add    $0x10,%esp
80103ee4:	eb 8a                	jmp    80103e70 <scheduler+0x20>
80103ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eed:	8d 76 00             	lea    0x0(%esi),%esi

80103ef0 <sched>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	56                   	push   %esi
80103ef4:	53                   	push   %ebx
  pushcli();
80103ef5:	e8 b6 09 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80103efa:	e8 c1 fb ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
80103eff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f05:	e8 f6 09 00 00       	call   80104900 <popcli>
  if(!holding(&ptable.lock))
80103f0a:	83 ec 0c             	sub    $0xc,%esp
80103f0d:	68 80 38 11 80       	push   $0x80113880
80103f12:	e8 49 0a 00 00       	call   80104960 <holding>
80103f17:	83 c4 10             	add    $0x10,%esp
80103f1a:	85 c0                	test   %eax,%eax
80103f1c:	74 4f                	je     80103f6d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f1e:	e8 9d fb ff ff       	call   80103ac0 <mycpu>
80103f23:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f2a:	75 68                	jne    80103f94 <sched+0xa4>
  if(p->state == RUNNING)
80103f2c:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80103f30:	74 55                	je     80103f87 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f32:	9c                   	pushf
80103f33:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f34:	f6 c4 02             	test   $0x2,%ah
80103f37:	75 41                	jne    80103f7a <sched+0x8a>
  intena = mycpu()->intena;
80103f39:	e8 82 fb ff ff       	call   80103ac0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f3e:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
80103f41:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f47:	e8 74 fb ff ff       	call   80103ac0 <mycpu>
80103f4c:	83 ec 08             	sub    $0x8,%esp
80103f4f:	ff 70 04             	push   0x4(%eax)
80103f52:	53                   	push   %ebx
80103f53:	e8 b3 0d 00 00       	call   80104d0b <swtch>
  mycpu()->intena = intena;
80103f58:	e8 63 fb ff ff       	call   80103ac0 <mycpu>
}
80103f5d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f60:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f69:	5b                   	pop    %ebx
80103f6a:	5e                   	pop    %esi
80103f6b:	5d                   	pop    %ebp
80103f6c:	c3                   	ret
    panic("sched ptable.lock");
80103f6d:	83 ec 0c             	sub    $0xc,%esp
80103f70:	68 19 7d 10 80       	push   $0x80107d19
80103f75:	e8 f6 c4 ff ff       	call   80100470 <panic>
    panic("sched interruptible");
80103f7a:	83 ec 0c             	sub    $0xc,%esp
80103f7d:	68 45 7d 10 80       	push   $0x80107d45
80103f82:	e8 e9 c4 ff ff       	call   80100470 <panic>
    panic("sched running");
80103f87:	83 ec 0c             	sub    $0xc,%esp
80103f8a:	68 37 7d 10 80       	push   $0x80107d37
80103f8f:	e8 dc c4 ff ff       	call   80100470 <panic>
    panic("sched locks");
80103f94:	83 ec 0c             	sub    $0xc,%esp
80103f97:	68 2b 7d 10 80       	push   $0x80107d2b
80103f9c:	e8 cf c4 ff ff       	call   80100470 <panic>
80103fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103faf:	90                   	nop

80103fb0 <exit>:
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	57                   	push   %edi
80103fb4:	56                   	push   %esi
80103fb5:	53                   	push   %ebx
80103fb6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103fb9:	e8 72 fb ff ff       	call   80103b30 <myproc>
  if(curproc == initproc)
80103fbe:	39 05 b4 58 11 80    	cmp    %eax,0x801158b4
80103fc4:	0f 84 fd 00 00 00    	je     801040c7 <exit+0x117>
80103fca:	89 c3                	mov    %eax,%ebx
80103fcc:	8d 70 2c             	lea    0x2c(%eax),%esi
80103fcf:	8d 78 6c             	lea    0x6c(%eax),%edi
80103fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103fd8:	8b 06                	mov    (%esi),%eax
80103fda:	85 c0                	test   %eax,%eax
80103fdc:	74 12                	je     80103ff0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103fde:	83 ec 0c             	sub    $0xc,%esp
80103fe1:	50                   	push   %eax
80103fe2:	e8 19 d0 ff ff       	call   80101000 <fileclose>
      curproc->ofile[fd] = 0;
80103fe7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103fed:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103ff0:	83 c6 04             	add    $0x4,%esi
80103ff3:	39 f7                	cmp    %esi,%edi
80103ff5:	75 e1                	jne    80103fd8 <exit+0x28>
  begin_op();
80103ff7:	e8 24 ef ff ff       	call   80102f20 <begin_op>
  iput(curproc->cwd);
80103ffc:	83 ec 0c             	sub    $0xc,%esp
80103fff:	ff 73 6c             	push   0x6c(%ebx)
80104002:	e8 b9 d9 ff ff       	call   801019c0 <iput>
  end_op();
80104007:	e8 84 ef ff ff       	call   80102f90 <end_op>
  curproc->cwd = 0;
8010400c:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
80104013:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
8010401a:	e8 e1 09 00 00       	call   80104a00 <acquire>
  wakeup1(curproc->parent);
8010401f:	8b 53 18             	mov    0x18(%ebx),%edx
80104022:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104025:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
8010402a:	eb 0e                	jmp    8010403a <exit+0x8a>
8010402c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104030:	83 e8 80             	sub    $0xffffff80,%eax
80104033:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104038:	74 1c                	je     80104056 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010403a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010403e:	75 f0                	jne    80104030 <exit+0x80>
80104040:	3b 50 24             	cmp    0x24(%eax),%edx
80104043:	75 eb                	jne    80104030 <exit+0x80>
      p->state = RUNNABLE;
80104045:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010404c:	83 e8 80             	sub    $0xffffff80,%eax
8010404f:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104054:	75 e4                	jne    8010403a <exit+0x8a>
      p->parent = initproc;
80104056:	8b 0d b4 58 11 80    	mov    0x801158b4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010405c:	ba b4 38 11 80       	mov    $0x801138b4,%edx
80104061:	eb 10                	jmp    80104073 <exit+0xc3>
80104063:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104067:	90                   	nop
80104068:	83 ea 80             	sub    $0xffffff80,%edx
8010406b:	81 fa b4 58 11 80    	cmp    $0x801158b4,%edx
80104071:	74 3b                	je     801040ae <exit+0xfe>
    if(p->parent == curproc){
80104073:	39 5a 18             	cmp    %ebx,0x18(%edx)
80104076:	75 f0                	jne    80104068 <exit+0xb8>
      if(p->state == ZOMBIE)
80104078:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
      p->parent = initproc;
8010407c:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
8010407f:	75 e7                	jne    80104068 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104081:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
80104086:	eb 12                	jmp    8010409a <exit+0xea>
80104088:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010408f:	90                   	nop
80104090:	83 e8 80             	sub    $0xffffff80,%eax
80104093:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104098:	74 ce                	je     80104068 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010409a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010409e:	75 f0                	jne    80104090 <exit+0xe0>
801040a0:	3b 48 24             	cmp    0x24(%eax),%ecx
801040a3:	75 eb                	jne    80104090 <exit+0xe0>
      p->state = RUNNABLE;
801040a5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
801040ac:	eb e2                	jmp    80104090 <exit+0xe0>
  curproc->state = ZOMBIE;
801040ae:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
801040b5:	e8 36 fe ff ff       	call   80103ef0 <sched>
  panic("zombie exit");
801040ba:	83 ec 0c             	sub    $0xc,%esp
801040bd:	68 66 7d 10 80       	push   $0x80107d66
801040c2:	e8 a9 c3 ff ff       	call   80100470 <panic>
    panic("init exiting");
801040c7:	83 ec 0c             	sub    $0xc,%esp
801040ca:	68 59 7d 10 80       	push   $0x80107d59
801040cf:	e8 9c c3 ff ff       	call   80100470 <panic>
801040d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040df:	90                   	nop

801040e0 <wait>:
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	56                   	push   %esi
801040e4:	53                   	push   %ebx
  pushcli();
801040e5:	e8 c6 07 00 00       	call   801048b0 <pushcli>
  c = mycpu();
801040ea:	e8 d1 f9 ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
801040ef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040f5:	e8 06 08 00 00       	call   80104900 <popcli>
  acquire(&ptable.lock);
801040fa:	83 ec 0c             	sub    $0xc,%esp
801040fd:	68 80 38 11 80       	push   $0x80113880
80104102:	e8 f9 08 00 00       	call   80104a00 <acquire>
80104107:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010410a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010410c:	bb b4 38 11 80       	mov    $0x801138b4,%ebx
80104111:	eb 10                	jmp    80104123 <wait+0x43>
80104113:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104117:	90                   	nop
80104118:	83 eb 80             	sub    $0xffffff80,%ebx
8010411b:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
80104121:	74 1b                	je     8010413e <wait+0x5e>
      if(p->parent != curproc)
80104123:	39 73 18             	cmp    %esi,0x18(%ebx)
80104126:	75 f0                	jne    80104118 <wait+0x38>
      if(p->state == ZOMBIE){
80104128:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
8010412c:	74 62                	je     80104190 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010412e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104131:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104136:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
8010413c:	75 e5                	jne    80104123 <wait+0x43>
    if(!havekids || curproc->killed){
8010413e:	85 c0                	test   %eax,%eax
80104140:	0f 84 a0 00 00 00    	je     801041e6 <wait+0x106>
80104146:	8b 46 28             	mov    0x28(%esi),%eax
80104149:	85 c0                	test   %eax,%eax
8010414b:	0f 85 95 00 00 00    	jne    801041e6 <wait+0x106>
  pushcli();
80104151:	e8 5a 07 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80104156:	e8 65 f9 ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
8010415b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104161:	e8 9a 07 00 00       	call   80104900 <popcli>
  if(p == 0)
80104166:	85 db                	test   %ebx,%ebx
80104168:	0f 84 8f 00 00 00    	je     801041fd <wait+0x11d>
  p->chan = chan;
8010416e:	89 73 24             	mov    %esi,0x24(%ebx)
  p->state = SLEEPING;
80104171:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104178:	e8 73 fd ff ff       	call   80103ef0 <sched>
  p->chan = 0;
8010417d:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
80104184:	eb 84                	jmp    8010410a <wait+0x2a>
80104186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010418d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104190:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104193:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
80104196:	ff 73 0c             	push   0xc(%ebx)
80104199:	e8 02 e4 ff ff       	call   801025a0 <kfree>
        p->kstack = 0;
8010419e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
801041a5:	5a                   	pop    %edx
801041a6:	ff 73 08             	push   0x8(%ebx)
801041a9:	e8 a2 30 00 00       	call   80107250 <freevm>
        p->pid = 0;
801041ae:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
801041b5:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
801041bc:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
801041c0:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
801041c7:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
801041ce:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
801041d5:	e8 c6 07 00 00       	call   801049a0 <release>
        return pid;
801041da:	83 c4 10             	add    $0x10,%esp
}
801041dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041e0:	89 f0                	mov    %esi,%eax
801041e2:	5b                   	pop    %ebx
801041e3:	5e                   	pop    %esi
801041e4:	5d                   	pop    %ebp
801041e5:	c3                   	ret
      release(&ptable.lock);
801041e6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041e9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041ee:	68 80 38 11 80       	push   $0x80113880
801041f3:	e8 a8 07 00 00       	call   801049a0 <release>
      return -1;
801041f8:	83 c4 10             	add    $0x10,%esp
801041fb:	eb e0                	jmp    801041dd <wait+0xfd>
    panic("sleep");
801041fd:	83 ec 0c             	sub    $0xc,%esp
80104200:	68 72 7d 10 80       	push   $0x80107d72
80104205:	e8 66 c2 ff ff       	call   80100470 <panic>
8010420a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104210 <yield>:
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	53                   	push   %ebx
80104214:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104217:	68 80 38 11 80       	push   $0x80113880
8010421c:	e8 df 07 00 00       	call   80104a00 <acquire>
  pushcli();
80104221:	e8 8a 06 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80104226:	e8 95 f8 ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
8010422b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104231:	e8 ca 06 00 00       	call   80104900 <popcli>
  myproc()->state = RUNNABLE;
80104236:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
8010423d:	e8 ae fc ff ff       	call   80103ef0 <sched>
  release(&ptable.lock);
80104242:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80104249:	e8 52 07 00 00       	call   801049a0 <release>
}
8010424e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104251:	83 c4 10             	add    $0x10,%esp
80104254:	c9                   	leave
80104255:	c3                   	ret
80104256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010425d:	8d 76 00             	lea    0x0(%esi),%esi

80104260 <sleep>:
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	57                   	push   %edi
80104264:	56                   	push   %esi
80104265:	53                   	push   %ebx
80104266:	83 ec 0c             	sub    $0xc,%esp
80104269:	8b 7d 08             	mov    0x8(%ebp),%edi
8010426c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010426f:	e8 3c 06 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80104274:	e8 47 f8 ff ff       	call   80103ac0 <mycpu>
  p = c->proc;
80104279:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010427f:	e8 7c 06 00 00       	call   80104900 <popcli>
  if(p == 0)
80104284:	85 db                	test   %ebx,%ebx
80104286:	0f 84 87 00 00 00    	je     80104313 <sleep+0xb3>
  if(lk == 0)
8010428c:	85 f6                	test   %esi,%esi
8010428e:	74 76                	je     80104306 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104290:	81 fe 80 38 11 80    	cmp    $0x80113880,%esi
80104296:	74 50                	je     801042e8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104298:	83 ec 0c             	sub    $0xc,%esp
8010429b:	68 80 38 11 80       	push   $0x80113880
801042a0:	e8 5b 07 00 00       	call   80104a00 <acquire>
    release(lk);
801042a5:	89 34 24             	mov    %esi,(%esp)
801042a8:	e8 f3 06 00 00       	call   801049a0 <release>
  p->chan = chan;
801042ad:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
801042b0:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801042b7:	e8 34 fc ff ff       	call   80103ef0 <sched>
  p->chan = 0;
801042bc:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
801042c3:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
801042ca:	e8 d1 06 00 00       	call   801049a0 <release>
    acquire(lk);
801042cf:	89 75 08             	mov    %esi,0x8(%ebp)
801042d2:	83 c4 10             	add    $0x10,%esp
}
801042d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042d8:	5b                   	pop    %ebx
801042d9:	5e                   	pop    %esi
801042da:	5f                   	pop    %edi
801042db:	5d                   	pop    %ebp
    acquire(lk);
801042dc:	e9 1f 07 00 00       	jmp    80104a00 <acquire>
801042e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801042e8:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
801042eb:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801042f2:	e8 f9 fb ff ff       	call   80103ef0 <sched>
  p->chan = 0;
801042f7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
801042fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104301:	5b                   	pop    %ebx
80104302:	5e                   	pop    %esi
80104303:	5f                   	pop    %edi
80104304:	5d                   	pop    %ebp
80104305:	c3                   	ret
    panic("sleep without lk");
80104306:	83 ec 0c             	sub    $0xc,%esp
80104309:	68 78 7d 10 80       	push   $0x80107d78
8010430e:	e8 5d c1 ff ff       	call   80100470 <panic>
    panic("sleep");
80104313:	83 ec 0c             	sub    $0xc,%esp
80104316:	68 72 7d 10 80       	push   $0x80107d72
8010431b:	e8 50 c1 ff ff       	call   80100470 <panic>

80104320 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	53                   	push   %ebx
80104324:	83 ec 10             	sub    $0x10,%esp
80104327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010432a:	68 80 38 11 80       	push   $0x80113880
8010432f:	e8 cc 06 00 00       	call   80104a00 <acquire>
80104334:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104337:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
8010433c:	eb 0c                	jmp    8010434a <wakeup+0x2a>
8010433e:	66 90                	xchg   %ax,%ax
80104340:	83 e8 80             	sub    $0xffffff80,%eax
80104343:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104348:	74 1c                	je     80104366 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010434a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010434e:	75 f0                	jne    80104340 <wakeup+0x20>
80104350:	3b 58 24             	cmp    0x24(%eax),%ebx
80104353:	75 eb                	jne    80104340 <wakeup+0x20>
      p->state = RUNNABLE;
80104355:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010435c:	83 e8 80             	sub    $0xffffff80,%eax
8010435f:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104364:	75 e4                	jne    8010434a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104366:	c7 45 08 80 38 11 80 	movl   $0x80113880,0x8(%ebp)
}
8010436d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104370:	c9                   	leave
  release(&ptable.lock);
80104371:	e9 2a 06 00 00       	jmp    801049a0 <release>
80104376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010437d:	8d 76 00             	lea    0x0(%esi),%esi

80104380 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	53                   	push   %ebx
80104384:	83 ec 10             	sub    $0x10,%esp
80104387:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010438a:	68 80 38 11 80       	push   $0x80113880
8010438f:	e8 6c 06 00 00       	call   80104a00 <acquire>
80104394:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104397:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
8010439c:	eb 0c                	jmp    801043aa <kill+0x2a>
8010439e:	66 90                	xchg   %ax,%ax
801043a0:	83 e8 80             	sub    $0xffffff80,%eax
801043a3:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
801043a8:	74 36                	je     801043e0 <kill+0x60>
    if(p->pid == pid){
801043aa:	39 58 14             	cmp    %ebx,0x14(%eax)
801043ad:	75 f1                	jne    801043a0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043af:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
801043b3:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
801043ba:	75 07                	jne    801043c3 <kill+0x43>
        p->state = RUNNABLE;
801043bc:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
801043c3:	83 ec 0c             	sub    $0xc,%esp
801043c6:	68 80 38 11 80       	push   $0x80113880
801043cb:	e8 d0 05 00 00       	call   801049a0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801043d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801043d3:	83 c4 10             	add    $0x10,%esp
801043d6:	31 c0                	xor    %eax,%eax
}
801043d8:	c9                   	leave
801043d9:	c3                   	ret
801043da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801043e0:	83 ec 0c             	sub    $0xc,%esp
801043e3:	68 80 38 11 80       	push   $0x80113880
801043e8:	e8 b3 05 00 00       	call   801049a0 <release>
}
801043ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801043f0:	83 c4 10             	add    $0x10,%esp
801043f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043f8:	c9                   	leave
801043f9:	c3                   	ret
801043fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104400 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	57                   	push   %edi
80104404:	56                   	push   %esi
80104405:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104408:	53                   	push   %ebx
80104409:	bb 24 39 11 80       	mov    $0x80113924,%ebx
8010440e:	83 ec 3c             	sub    $0x3c,%esp
80104411:	eb 24                	jmp    80104437 <procdump+0x37>
80104413:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104417:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104418:	83 ec 0c             	sub    $0xc,%esp
8010441b:	68 46 7f 10 80       	push   $0x80107f46
80104420:	e8 7b c3 ff ff       	call   801007a0 <cprintf>
80104425:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104428:	83 eb 80             	sub    $0xffffff80,%ebx
8010442b:	81 fb 24 59 11 80    	cmp    $0x80115924,%ebx
80104431:	0f 84 81 00 00 00    	je     801044b8 <procdump+0xb8>
    if(p->state == UNUSED)
80104437:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010443a:	85 c0                	test   %eax,%eax
8010443c:	74 ea                	je     80104428 <procdump+0x28>
      state = "???";
8010443e:	ba 89 7d 10 80       	mov    $0x80107d89,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104443:	83 f8 05             	cmp    $0x5,%eax
80104446:	77 11                	ja     80104459 <procdump+0x59>
80104448:	8b 14 85 a0 84 10 80 	mov    -0x7fef7b60(,%eax,4),%edx
      state = "???";
8010444f:	b8 89 7d 10 80       	mov    $0x80107d89,%eax
80104454:	85 d2                	test   %edx,%edx
80104456:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104459:	53                   	push   %ebx
8010445a:	52                   	push   %edx
8010445b:	ff 73 a4             	push   -0x5c(%ebx)
8010445e:	68 8d 7d 10 80       	push   $0x80107d8d
80104463:	e8 38 c3 ff ff       	call   801007a0 <cprintf>
    if(p->state == SLEEPING){
80104468:	83 c4 10             	add    $0x10,%esp
8010446b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010446f:	75 a7                	jne    80104418 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104471:	83 ec 08             	sub    $0x8,%esp
80104474:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104477:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010447a:	50                   	push   %eax
8010447b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010447e:	8b 40 0c             	mov    0xc(%eax),%eax
80104481:	83 c0 08             	add    $0x8,%eax
80104484:	50                   	push   %eax
80104485:	e8 a6 03 00 00       	call   80104830 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010448a:	83 c4 10             	add    $0x10,%esp
8010448d:	8d 76 00             	lea    0x0(%esi),%esi
80104490:	8b 17                	mov    (%edi),%edx
80104492:	85 d2                	test   %edx,%edx
80104494:	74 82                	je     80104418 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104496:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104499:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010449c:	52                   	push   %edx
8010449d:	68 a1 7a 10 80       	push   $0x80107aa1
801044a2:	e8 f9 c2 ff ff       	call   801007a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044a7:	83 c4 10             	add    $0x10,%esp
801044aa:	39 f7                	cmp    %esi,%edi
801044ac:	75 e2                	jne    80104490 <procdump+0x90>
801044ae:	e9 65 ff ff ff       	jmp    80104418 <procdump+0x18>
801044b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044b7:	90                   	nop
  }
}
801044b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044bb:	5b                   	pop    %ebx
801044bc:	5e                   	pop    %esi
801044bd:	5f                   	pop    %edi
801044be:	5d                   	pop    %ebp
801044bf:	c3                   	ret

801044c0 <get_victim_process>:
struct proc * get_victim_process(void){
801044c0:	55                   	push   %ebp
  struct proc * p;
  uint max_rss = 0;
801044c1:	31 c9                	xor    %ecx,%ecx
  struct proc * v = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044c3:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
struct proc * get_victim_process(void){
801044c8:	89 e5                	mov    %esp,%ebp
801044ca:	53                   	push   %ebx
  struct proc * v = 0;
801044cb:	31 db                	xor    %ebx,%ebx
801044cd:	eb 0f                	jmp    801044de <get_victim_process+0x1e>
801044cf:	90                   	nop
    // if(p->state == UNUSED)
    //   continue;
    if(p->rss > max_rss){
      max_rss = p->rss;
      v = p;
    } else if (p->rss == max_rss){
801044d0:	39 ca                	cmp    %ecx,%edx
801044d2:	74 2c                	je     80104500 <get_victim_process+0x40>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044d4:	83 e8 80             	sub    $0xffffff80,%eax
801044d7:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
801044dc:	74 15                	je     801044f3 <get_victim_process+0x33>
    if(p->rss > max_rss){
801044de:	8b 50 04             	mov    0x4(%eax),%edx
801044e1:	39 d1                	cmp    %edx,%ecx
801044e3:	73 eb                	jae    801044d0 <get_victim_process+0x10>
      v = p;
801044e5:	89 c3                	mov    %eax,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044e7:	83 e8 80             	sub    $0xffffff80,%eax
      max_rss = p->rss;
801044ea:	89 d1                	mov    %edx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044ec:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
801044f1:	75 eb                	jne    801044de <get_victim_process+0x1e>
          v = p;
        }
      }
    }
    return v;
}
801044f3:	89 d8                	mov    %ebx,%eax
801044f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044f8:	c9                   	leave
801044f9:	c3                   	ret
801044fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(v == 0){
80104500:	85 db                	test   %ebx,%ebx
80104502:	74 0c                	je     80104510 <get_victim_process+0x50>
          v = p;
80104504:	8b 53 14             	mov    0x14(%ebx),%edx
80104507:	39 50 14             	cmp    %edx,0x14(%eax)
8010450a:	0f 4c d8             	cmovl  %eax,%ebx
8010450d:	eb c5                	jmp    801044d4 <get_victim_process+0x14>
8010450f:	90                   	nop
          v = p;
80104510:	89 c3                	mov    %eax,%ebx
80104512:	eb c0                	jmp    801044d4 <get_victim_process+0x14>
80104514:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010451b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010451f:	90                   	nop

80104520 <get_victim_page>:
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
pte_t* get_victim_page(struct proc * v){
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	56                   	push   %esi
80104524:	8b 45 08             	mov    0x8(%ebp),%eax
80104527:	53                   	push   %ebx
  //      pte = &pgtable[j];
  //      return pte;
  //    }
  //  }
  //}
        for(int i = 0 ; i < v->sz; i+= PGSIZE){
80104528:	8b 08                	mov    (%eax),%ecx
  pde_t* pgdir = v->pgdir;
8010452a:	8b 58 08             	mov    0x8(%eax),%ebx
        for(int i = 0 ; i < v->sz; i+= PGSIZE){
8010452d:	85 c9                	test   %ecx,%ecx
8010452f:	74 43                	je     80104574 <get_victim_page+0x54>
80104531:	31 c0                	xor    %eax,%eax
80104533:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104537:	90                   	nop
  pde = &pgdir[PDX(va)];
80104538:	89 c2                	mov    %eax,%edx
8010453a:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
8010453d:	8b 14 93             	mov    (%ebx,%edx,4),%edx
80104540:	f6 c2 01             	test   $0x1,%dl
80104543:	0f 84 7b 01 00 00    	je     801046c4 <get_victim_page.cold>
  return &pgtab[PTX(va)];
80104549:	89 c6                	mov    %eax,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010454b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80104551:	c1 ee 0a             	shr    $0xa,%esi
80104554:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010455a:	8d b4 32 00 00 00 80 	lea    -0x80000000(%edx,%esi,1),%esi
                pte = walkpgdir(pgdir, (void * ) i , 0);
                if((*pte & PTE_P) && (*pte & PTE_U) && !(*pte & PTE_A)){
80104561:	8b 16                	mov    (%esi),%edx
80104563:	83 e2 25             	and    $0x25,%edx
80104566:	83 fa 05             	cmp    $0x5,%edx
80104569:	74 0b                	je     80104576 <get_victim_page+0x56>
        for(int i = 0 ; i < v->sz; i+= PGSIZE){
8010456b:	05 00 10 00 00       	add    $0x1000,%eax
80104570:	39 c8                	cmp    %ecx,%eax
80104572:	72 c4                	jb     80104538 <get_victim_page+0x18>
                        return pte;
                }
        }
  return 0;
80104574:	31 f6                	xor    %esi,%esi
}
80104576:	89 f0                	mov    %esi,%eax
80104578:	5b                   	pop    %ebx
80104579:	5e                   	pop    %esi
8010457a:	5d                   	pop    %ebp
8010457b:	c3                   	ret
8010457c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104580 <flush_table>:

void flush_table(struct proc * p){
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	57                   	push   %edi
80104584:	56                   	push   %esi
80104585:	8b 75 08             	mov    0x8(%ebp),%esi
80104588:	53                   	push   %ebx
  //      ctr = (ctr + 1) % 10;
  //    }
  //  }
  //}
        pte_t * pte;
        for(int i = 0 ; i < p->sz; i+= PGSIZE){
80104589:	8b 06                	mov    (%esi),%eax
  pde_t * pgdir = p->pgdir;
8010458b:	8b 7e 08             	mov    0x8(%esi),%edi
        for(int i = 0 ; i < p->sz; i+= PGSIZE){
8010458e:	85 c0                	test   %eax,%eax
80104590:	0f 84 7c 00 00 00    	je     80104612 <flush_table+0x92>
80104596:	31 c9                	xor    %ecx,%ecx
  int ctr = 0;
80104598:	31 d2                	xor    %edx,%edx
8010459a:	eb 11                	jmp    801045ad <flush_table+0x2d>
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        for(int i = 0 ; i < p->sz; i+= PGSIZE){
801045a0:	8b 45 08             	mov    0x8(%ebp),%eax
801045a3:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801045a9:	3b 08                	cmp    (%eax),%ecx
801045ab:	73 65                	jae    80104612 <flush_table+0x92>
  pde = &pgdir[PDX(va)];
801045ad:	89 c8                	mov    %ecx,%eax
801045af:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801045b2:	8b 04 87             	mov    (%edi,%eax,4),%eax
801045b5:	a8 01                	test   $0x1,%al
801045b7:	0f 84 0e 01 00 00    	je     801046cb <flush_table.cold>
  return &pgtab[PTX(va)];
801045bd:	89 cb                	mov    %ecx,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801045bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801045c4:	c1 eb 0a             	shr    $0xa,%ebx
801045c7:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
801045cd:	8d 9c 18 00 00 00 80 	lea    -0x80000000(%eax,%ebx,1),%ebx
                        pte = walkpgdir(pgdir , (void *) i , 0);
                        if((*pte & PTE_P) && (*pte & PTE_U) && (*pte & PTE_A)){
801045d4:	8b 03                	mov    (%ebx),%eax
801045d6:	89 c6                	mov    %eax,%esi
801045d8:	f7 d6                	not    %esi
801045da:	83 e6 25             	and    $0x25,%esi
801045dd:	75 c1                	jne    801045a0 <flush_table+0x20>
                                if(ctr == 0){
801045df:	85 d2                	test   %edx,%edx
801045e1:	75 05                	jne    801045e8 <flush_table+0x68>
                                        *pte &= ~PTE_A;
801045e3:	83 e0 df             	and    $0xffffffdf,%eax
801045e6:	89 03                	mov    %eax,(%ebx)
                                }
                                ctr = (ctr + 1) % 10;
801045e8:	8d 5a 01             	lea    0x1(%edx),%ebx
801045eb:	b8 67 66 66 66       	mov    $0x66666667,%eax
        for(int i = 0 ; i < p->sz; i+= PGSIZE){
801045f0:	81 c1 00 10 00 00    	add    $0x1000,%ecx
                                ctr = (ctr + 1) % 10;
801045f6:	f7 eb                	imul   %ebx
801045f8:	89 d8                	mov    %ebx,%eax
801045fa:	c1 f8 1f             	sar    $0x1f,%eax
801045fd:	c1 fa 02             	sar    $0x2,%edx
80104600:	29 c2                	sub    %eax,%edx
80104602:	8d 04 92             	lea    (%edx,%edx,4),%eax
80104605:	89 da                	mov    %ebx,%edx
80104607:	01 c0                	add    %eax,%eax
80104609:	29 c2                	sub    %eax,%edx
        for(int i = 0 ; i < p->sz; i+= PGSIZE){
8010460b:	8b 45 08             	mov    0x8(%ebp),%eax
8010460e:	3b 08                	cmp    (%eax),%ecx
80104610:	72 9b                	jb     801045ad <flush_table+0x2d>
                        }
                }

}
80104612:	5b                   	pop    %ebx
80104613:	5e                   	pop    %esi
80104614:	5f                   	pop    %edi
80104615:	5d                   	pop    %ebp
80104616:	c3                   	ret
80104617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010461e:	66 90                	xchg   %ax,%ax

80104620 <final_page>:

pte_t* final_page(){
80104620:	55                   	push   %ebp
  uint max_rss = 0;
80104621:	31 c9                	xor    %ecx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104623:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
pte_t* final_page(){
80104628:	89 e5                	mov    %esp,%ebp
8010462a:	53                   	push   %ebx
  struct proc * v = 0;
8010462b:	31 db                	xor    %ebx,%ebx
pte_t* final_page(){
8010462d:	83 ec 14             	sub    $0x14,%esp
80104630:	eb 12                	jmp    80104644 <final_page+0x24>
80104632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if (p->rss == max_rss){
80104638:	74 3e                	je     80104678 <final_page+0x58>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010463a:	83 e8 80             	sub    $0xffffff80,%eax
8010463d:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104642:	74 15                	je     80104659 <final_page+0x39>
    if(p->rss > max_rss){
80104644:	8b 50 04             	mov    0x4(%eax),%edx
80104647:	39 d1                	cmp    %edx,%ecx
80104649:	73 ed                	jae    80104638 <final_page+0x18>
      v = p;
8010464b:	89 c3                	mov    %eax,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010464d:	83 e8 80             	sub    $0xffffff80,%eax
      max_rss = p->rss;
80104650:	89 d1                	mov    %edx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104652:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104657:	75 eb                	jne    80104644 <final_page+0x24>
  struct proc * v = get_victim_process();
  // cprintf("victim process is %d\n", (int) v->pid);
  v->rss -= PGSIZE;
  pte_t* pte = get_victim_page(v);
80104659:	83 ec 0c             	sub    $0xc,%esp
  v->rss -= PGSIZE;
8010465c:	81 6b 04 00 10 00 00 	subl   $0x1000,0x4(%ebx)
  pte_t* pte = get_victim_page(v);
80104663:	53                   	push   %ebx
80104664:	e8 b7 fe ff ff       	call   80104520 <get_victim_page>
80104669:	83 c4 10             	add    $0x10,%esp
  if(pte == 0){
8010466c:	85 c0                	test   %eax,%eax
8010466e:	74 24                	je     80104694 <final_page+0x74>
    if(pte == 0){
      cprintf("Flusing again\n");
    }
  }
  return pte;
}
80104670:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104673:	c9                   	leave
80104674:	c3                   	ret
80104675:	8d 76 00             	lea    0x0(%esi),%esi
        if(v == 0){
80104678:	85 db                	test   %ebx,%ebx
8010467a:	74 14                	je     80104690 <final_page+0x70>
      v = p;
8010467c:	8b 53 14             	mov    0x14(%ebx),%edx
8010467f:	39 50 14             	cmp    %edx,0x14(%eax)
80104682:	0f 4c d8             	cmovl  %eax,%ebx
80104685:	eb b3                	jmp    8010463a <final_page+0x1a>
80104687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010468e:	66 90                	xchg   %ax,%ax
80104690:	89 c3                	mov    %eax,%ebx
80104692:	eb a6                	jmp    8010463a <final_page+0x1a>
    flush_table(v);
80104694:	83 ec 0c             	sub    $0xc,%esp
80104697:	53                   	push   %ebx
80104698:	e8 e3 fe ff ff       	call   80104580 <flush_table>
    pte = get_victim_page(v);
8010469d:	89 1c 24             	mov    %ebx,(%esp)
801046a0:	e8 7b fe ff ff       	call   80104520 <get_victim_page>
801046a5:	83 c4 10             	add    $0x10,%esp
    if(pte == 0){
801046a8:	85 c0                	test   %eax,%eax
801046aa:	75 c4                	jne    80104670 <final_page+0x50>
      cprintf("Flusing again\n");
801046ac:	83 ec 0c             	sub    $0xc,%esp
801046af:	89 45 f4             	mov    %eax,-0xc(%ebp)
801046b2:	68 96 7d 10 80       	push   $0x80107d96
801046b7:	e8 e4 c0 ff ff       	call   801007a0 <cprintf>
801046bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046bf:	83 c4 10             	add    $0x10,%esp
801046c2:	eb ac                	jmp    80104670 <final_page+0x50>

801046c4 <get_victim_page.cold>:
                if((*pte & PTE_P) && (*pte & PTE_U) && !(*pte & PTE_A)){
801046c4:	a1 00 00 00 00       	mov    0x0,%eax
801046c9:	0f 0b                	ud2

801046cb <flush_table.cold>:
                        if((*pte & PTE_P) && (*pte & PTE_U) && (*pte & PTE_A)){
801046cb:	a1 00 00 00 00       	mov    0x0,%eax
801046d0:	0f 0b                	ud2
801046d2:	66 90                	xchg   %ax,%ax
801046d4:	66 90                	xchg   %ax,%ax
801046d6:	66 90                	xchg   %ax,%ax
801046d8:	66 90                	xchg   %ax,%ax
801046da:	66 90                	xchg   %ax,%ax
801046dc:	66 90                	xchg   %ax,%ax
801046de:	66 90                	xchg   %ax,%ax

801046e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	53                   	push   %ebx
801046e4:	83 ec 0c             	sub    $0xc,%esp
801046e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801046ea:	68 cf 7d 10 80       	push   $0x80107dcf
801046ef:	8d 43 04             	lea    0x4(%ebx),%eax
801046f2:	50                   	push   %eax
801046f3:	e8 18 01 00 00       	call   80104810 <initlock>
  lk->name = name;
801046f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801046fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104701:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104704:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010470b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010470e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104711:	c9                   	leave
80104712:	c3                   	ret
80104713:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010471a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104720 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	56                   	push   %esi
80104724:	53                   	push   %ebx
80104725:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104728:	8d 73 04             	lea    0x4(%ebx),%esi
8010472b:	83 ec 0c             	sub    $0xc,%esp
8010472e:	56                   	push   %esi
8010472f:	e8 cc 02 00 00       	call   80104a00 <acquire>
  while (lk->locked) {
80104734:	8b 13                	mov    (%ebx),%edx
80104736:	83 c4 10             	add    $0x10,%esp
80104739:	85 d2                	test   %edx,%edx
8010473b:	74 16                	je     80104753 <acquiresleep+0x33>
8010473d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104740:	83 ec 08             	sub    $0x8,%esp
80104743:	56                   	push   %esi
80104744:	53                   	push   %ebx
80104745:	e8 16 fb ff ff       	call   80104260 <sleep>
  while (lk->locked) {
8010474a:	8b 03                	mov    (%ebx),%eax
8010474c:	83 c4 10             	add    $0x10,%esp
8010474f:	85 c0                	test   %eax,%eax
80104751:	75 ed                	jne    80104740 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104753:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104759:	e8 d2 f3 ff ff       	call   80103b30 <myproc>
8010475e:	8b 40 14             	mov    0x14(%eax),%eax
80104761:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104764:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104767:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010476a:	5b                   	pop    %ebx
8010476b:	5e                   	pop    %esi
8010476c:	5d                   	pop    %ebp
  release(&lk->lk);
8010476d:	e9 2e 02 00 00       	jmp    801049a0 <release>
80104772:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104780 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	53                   	push   %ebx
80104785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104788:	8d 73 04             	lea    0x4(%ebx),%esi
8010478b:	83 ec 0c             	sub    $0xc,%esp
8010478e:	56                   	push   %esi
8010478f:	e8 6c 02 00 00       	call   80104a00 <acquire>
  lk->locked = 0;
80104794:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010479a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801047a1:	89 1c 24             	mov    %ebx,(%esp)
801047a4:	e8 77 fb ff ff       	call   80104320 <wakeup>
  release(&lk->lk);
801047a9:	89 75 08             	mov    %esi,0x8(%ebp)
801047ac:	83 c4 10             	add    $0x10,%esp
}
801047af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047b2:	5b                   	pop    %ebx
801047b3:	5e                   	pop    %esi
801047b4:	5d                   	pop    %ebp
  release(&lk->lk);
801047b5:	e9 e6 01 00 00       	jmp    801049a0 <release>
801047ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	57                   	push   %edi
801047c4:	31 ff                	xor    %edi,%edi
801047c6:	56                   	push   %esi
801047c7:	53                   	push   %ebx
801047c8:	83 ec 18             	sub    $0x18,%esp
801047cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801047ce:	8d 73 04             	lea    0x4(%ebx),%esi
801047d1:	56                   	push   %esi
801047d2:	e8 29 02 00 00       	call   80104a00 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801047d7:	8b 03                	mov    (%ebx),%eax
801047d9:	83 c4 10             	add    $0x10,%esp
801047dc:	85 c0                	test   %eax,%eax
801047de:	75 18                	jne    801047f8 <holdingsleep+0x38>
  release(&lk->lk);
801047e0:	83 ec 0c             	sub    $0xc,%esp
801047e3:	56                   	push   %esi
801047e4:	e8 b7 01 00 00       	call   801049a0 <release>
  return r;
}
801047e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047ec:	89 f8                	mov    %edi,%eax
801047ee:	5b                   	pop    %ebx
801047ef:	5e                   	pop    %esi
801047f0:	5f                   	pop    %edi
801047f1:	5d                   	pop    %ebp
801047f2:	c3                   	ret
801047f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047f7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801047f8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801047fb:	e8 30 f3 ff ff       	call   80103b30 <myproc>
80104800:	39 58 14             	cmp    %ebx,0x14(%eax)
80104803:	0f 94 c0             	sete   %al
80104806:	0f b6 c0             	movzbl %al,%eax
80104809:	89 c7                	mov    %eax,%edi
8010480b:	eb d3                	jmp    801047e0 <holdingsleep+0x20>
8010480d:	66 90                	xchg   %ax,%ax
8010480f:	90                   	nop

80104810 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104816:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104819:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010481f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104822:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104829:	5d                   	pop    %ebp
8010482a:	c3                   	ret
8010482b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010482f:	90                   	nop

80104830 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	53                   	push   %ebx
80104834:	8b 45 08             	mov    0x8(%ebp),%eax
80104837:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010483a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010483d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104842:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104847:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010484c:	76 10                	jbe    8010485e <getcallerpcs+0x2e>
8010484e:	eb 28                	jmp    80104878 <getcallerpcs+0x48>
80104850:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104856:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010485c:	77 1a                	ja     80104878 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010485e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104861:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104864:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104867:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104869:	83 f8 0a             	cmp    $0xa,%eax
8010486c:	75 e2                	jne    80104850 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010486e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104871:	c9                   	leave
80104872:	c3                   	ret
80104873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104877:	90                   	nop
80104878:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010487b:	83 c1 28             	add    $0x28,%ecx
8010487e:	89 ca                	mov    %ecx,%edx
80104880:	29 c2                	sub    %eax,%edx
80104882:	83 e2 04             	and    $0x4,%edx
80104885:	74 11                	je     80104898 <getcallerpcs+0x68>
    pcs[i] = 0;
80104887:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010488d:	83 c0 04             	add    $0x4,%eax
80104890:	39 c1                	cmp    %eax,%ecx
80104892:	74 da                	je     8010486e <getcallerpcs+0x3e>
80104894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104898:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010489e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801048a1:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801048a8:	39 c1                	cmp    %eax,%ecx
801048aa:	75 ec                	jne    80104898 <getcallerpcs+0x68>
801048ac:	eb c0                	jmp    8010486e <getcallerpcs+0x3e>
801048ae:	66 90                	xchg   %ax,%ax

801048b0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	53                   	push   %ebx
801048b4:	83 ec 04             	sub    $0x4,%esp
801048b7:	9c                   	pushf
801048b8:	5b                   	pop    %ebx
  asm volatile("cli");
801048b9:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801048ba:	e8 01 f2 ff ff       	call   80103ac0 <mycpu>
801048bf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801048c5:	85 c0                	test   %eax,%eax
801048c7:	74 17                	je     801048e0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801048c9:	e8 f2 f1 ff ff       	call   80103ac0 <mycpu>
801048ce:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801048d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048d8:	c9                   	leave
801048d9:	c3                   	ret
801048da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801048e0:	e8 db f1 ff ff       	call   80103ac0 <mycpu>
801048e5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801048eb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801048f1:	eb d6                	jmp    801048c9 <pushcli+0x19>
801048f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104900 <popcli>:

void
popcli(void)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104906:	9c                   	pushf
80104907:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104908:	f6 c4 02             	test   $0x2,%ah
8010490b:	75 35                	jne    80104942 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010490d:	e8 ae f1 ff ff       	call   80103ac0 <mycpu>
80104912:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104919:	78 34                	js     8010494f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010491b:	e8 a0 f1 ff ff       	call   80103ac0 <mycpu>
80104920:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104926:	85 d2                	test   %edx,%edx
80104928:	74 06                	je     80104930 <popcli+0x30>
    sti();
}
8010492a:	c9                   	leave
8010492b:	c3                   	ret
8010492c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104930:	e8 8b f1 ff ff       	call   80103ac0 <mycpu>
80104935:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010493b:	85 c0                	test   %eax,%eax
8010493d:	74 eb                	je     8010492a <popcli+0x2a>
  asm volatile("sti");
8010493f:	fb                   	sti
}
80104940:	c9                   	leave
80104941:	c3                   	ret
    panic("popcli - interruptible");
80104942:	83 ec 0c             	sub    $0xc,%esp
80104945:	68 da 7d 10 80       	push   $0x80107dda
8010494a:	e8 21 bb ff ff       	call   80100470 <panic>
    panic("popcli");
8010494f:	83 ec 0c             	sub    $0xc,%esp
80104952:	68 f1 7d 10 80       	push   $0x80107df1
80104957:	e8 14 bb ff ff       	call   80100470 <panic>
8010495c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104960 <holding>:
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	56                   	push   %esi
80104964:	53                   	push   %ebx
80104965:	8b 75 08             	mov    0x8(%ebp),%esi
80104968:	31 db                	xor    %ebx,%ebx
  pushcli();
8010496a:	e8 41 ff ff ff       	call   801048b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010496f:	8b 06                	mov    (%esi),%eax
80104971:	85 c0                	test   %eax,%eax
80104973:	75 0b                	jne    80104980 <holding+0x20>
  popcli();
80104975:	e8 86 ff ff ff       	call   80104900 <popcli>
}
8010497a:	89 d8                	mov    %ebx,%eax
8010497c:	5b                   	pop    %ebx
8010497d:	5e                   	pop    %esi
8010497e:	5d                   	pop    %ebp
8010497f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104980:	8b 5e 08             	mov    0x8(%esi),%ebx
80104983:	e8 38 f1 ff ff       	call   80103ac0 <mycpu>
80104988:	39 c3                	cmp    %eax,%ebx
8010498a:	0f 94 c3             	sete   %bl
  popcli();
8010498d:	e8 6e ff ff ff       	call   80104900 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104992:	0f b6 db             	movzbl %bl,%ebx
}
80104995:	89 d8                	mov    %ebx,%eax
80104997:	5b                   	pop    %ebx
80104998:	5e                   	pop    %esi
80104999:	5d                   	pop    %ebp
8010499a:	c3                   	ret
8010499b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010499f:	90                   	nop

801049a0 <release>:
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	53                   	push   %ebx
801049a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801049a8:	e8 03 ff ff ff       	call   801048b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801049ad:	8b 03                	mov    (%ebx),%eax
801049af:	85 c0                	test   %eax,%eax
801049b1:	75 15                	jne    801049c8 <release+0x28>
  popcli();
801049b3:	e8 48 ff ff ff       	call   80104900 <popcli>
    panic("release");
801049b8:	83 ec 0c             	sub    $0xc,%esp
801049bb:	68 f8 7d 10 80       	push   $0x80107df8
801049c0:	e8 ab ba ff ff       	call   80100470 <panic>
801049c5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801049c8:	8b 73 08             	mov    0x8(%ebx),%esi
801049cb:	e8 f0 f0 ff ff       	call   80103ac0 <mycpu>
801049d0:	39 c6                	cmp    %eax,%esi
801049d2:	75 df                	jne    801049b3 <release+0x13>
  popcli();
801049d4:	e8 27 ff ff ff       	call   80104900 <popcli>
  lk->pcs[0] = 0;
801049d9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801049e0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801049e7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801049ec:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801049f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049f5:	5b                   	pop    %ebx
801049f6:	5e                   	pop    %esi
801049f7:	5d                   	pop    %ebp
  popcli();
801049f8:	e9 03 ff ff ff       	jmp    80104900 <popcli>
801049fd:	8d 76 00             	lea    0x0(%esi),%esi

80104a00 <acquire>:
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	53                   	push   %ebx
80104a04:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104a07:	e8 a4 fe ff ff       	call   801048b0 <pushcli>
  if(holding(lk))
80104a0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104a0f:	e8 9c fe ff ff       	call   801048b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a14:	8b 03                	mov    (%ebx),%eax
80104a16:	85 c0                	test   %eax,%eax
80104a18:	0f 85 b2 00 00 00    	jne    80104ad0 <acquire+0xd0>
  popcli();
80104a1e:	e8 dd fe ff ff       	call   80104900 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104a23:	b9 01 00 00 00       	mov    $0x1,%ecx
80104a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a2f:	90                   	nop
  while(xchg(&lk->locked, 1) != 0)
80104a30:	8b 55 08             	mov    0x8(%ebp),%edx
80104a33:	89 c8                	mov    %ecx,%eax
80104a35:	f0 87 02             	lock xchg %eax,(%edx)
80104a38:	85 c0                	test   %eax,%eax
80104a3a:	75 f4                	jne    80104a30 <acquire+0x30>
  __sync_synchronize();
80104a3c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104a41:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a44:	e8 77 f0 ff ff       	call   80103ac0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104a49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
80104a4c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
80104a4e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a51:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104a57:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80104a5c:	77 32                	ja     80104a90 <acquire+0x90>
  ebp = (uint*)v - 2;
80104a5e:	89 e8                	mov    %ebp,%eax
80104a60:	eb 14                	jmp    80104a76 <acquire+0x76>
80104a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a68:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a6e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a74:	77 1a                	ja     80104a90 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104a76:	8b 58 04             	mov    0x4(%eax),%ebx
80104a79:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104a7d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104a80:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a82:	83 fa 0a             	cmp    $0xa,%edx
80104a85:	75 e1                	jne    80104a68 <acquire+0x68>
}
80104a87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a8a:	c9                   	leave
80104a8b:	c3                   	ret
80104a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a90:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104a94:	83 c1 34             	add    $0x34,%ecx
80104a97:	89 ca                	mov    %ecx,%edx
80104a99:	29 c2                	sub    %eax,%edx
80104a9b:	83 e2 04             	and    $0x4,%edx
80104a9e:	74 10                	je     80104ab0 <acquire+0xb0>
    pcs[i] = 0;
80104aa0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104aa6:	83 c0 04             	add    $0x4,%eax
80104aa9:	39 c1                	cmp    %eax,%ecx
80104aab:	74 da                	je     80104a87 <acquire+0x87>
80104aad:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104ab0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ab6:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104ab9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104ac0:	39 c1                	cmp    %eax,%ecx
80104ac2:	75 ec                	jne    80104ab0 <acquire+0xb0>
80104ac4:	eb c1                	jmp    80104a87 <acquire+0x87>
80104ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104acd:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104ad0:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104ad3:	e8 e8 ef ff ff       	call   80103ac0 <mycpu>
80104ad8:	39 c3                	cmp    %eax,%ebx
80104ada:	0f 85 3e ff ff ff    	jne    80104a1e <acquire+0x1e>
  popcli();
80104ae0:	e8 1b fe ff ff       	call   80104900 <popcli>
    panic("acquire");
80104ae5:	83 ec 0c             	sub    $0xc,%esp
80104ae8:	68 00 7e 10 80       	push   $0x80107e00
80104aed:	e8 7e b9 ff ff       	call   80100470 <panic>
80104af2:	66 90                	xchg   %ax,%ax
80104af4:	66 90                	xchg   %ax,%ax
80104af6:	66 90                	xchg   %ax,%ax
80104af8:	66 90                	xchg   %ax,%ax
80104afa:	66 90                	xchg   %ax,%ax
80104afc:	66 90                	xchg   %ax,%ax
80104afe:	66 90                	xchg   %ax,%ax

80104b00 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	57                   	push   %edi
80104b04:	8b 55 08             	mov    0x8(%ebp),%edx
80104b07:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104b0a:	89 d0                	mov    %edx,%eax
80104b0c:	09 c8                	or     %ecx,%eax
80104b0e:	a8 03                	test   $0x3,%al
80104b10:	75 1e                	jne    80104b30 <memset+0x30>
    c &= 0xFF;
80104b12:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104b16:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104b19:	89 d7                	mov    %edx,%edi
80104b1b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104b21:	fc                   	cld
80104b22:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104b24:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104b27:	89 d0                	mov    %edx,%eax
80104b29:	c9                   	leave
80104b2a:	c3                   	ret
80104b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b2f:	90                   	nop
  asm volatile("cld; rep stosb" :
80104b30:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b33:	89 d7                	mov    %edx,%edi
80104b35:	fc                   	cld
80104b36:	f3 aa                	rep stos %al,%es:(%edi)
80104b38:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104b3b:	89 d0                	mov    %edx,%eax
80104b3d:	c9                   	leave
80104b3e:	c3                   	ret
80104b3f:	90                   	nop

80104b40 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	56                   	push   %esi
80104b44:	8b 75 10             	mov    0x10(%ebp),%esi
80104b47:	8b 45 08             	mov    0x8(%ebp),%eax
80104b4a:	53                   	push   %ebx
80104b4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104b4e:	85 f6                	test   %esi,%esi
80104b50:	74 2e                	je     80104b80 <memcmp+0x40>
80104b52:	01 c6                	add    %eax,%esi
80104b54:	eb 14                	jmp    80104b6a <memcmp+0x2a>
80104b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104b60:	83 c0 01             	add    $0x1,%eax
80104b63:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104b66:	39 f0                	cmp    %esi,%eax
80104b68:	74 16                	je     80104b80 <memcmp+0x40>
    if(*s1 != *s2)
80104b6a:	0f b6 08             	movzbl (%eax),%ecx
80104b6d:	0f b6 1a             	movzbl (%edx),%ebx
80104b70:	38 d9                	cmp    %bl,%cl
80104b72:	74 ec                	je     80104b60 <memcmp+0x20>
      return *s1 - *s2;
80104b74:	0f b6 c1             	movzbl %cl,%eax
80104b77:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104b79:	5b                   	pop    %ebx
80104b7a:	5e                   	pop    %esi
80104b7b:	5d                   	pop    %ebp
80104b7c:	c3                   	ret
80104b7d:	8d 76 00             	lea    0x0(%esi),%esi
80104b80:	5b                   	pop    %ebx
  return 0;
80104b81:	31 c0                	xor    %eax,%eax
}
80104b83:	5e                   	pop    %esi
80104b84:	5d                   	pop    %ebp
80104b85:	c3                   	ret
80104b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi

80104b90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	57                   	push   %edi
80104b94:	8b 55 08             	mov    0x8(%ebp),%edx
80104b97:	8b 45 10             	mov    0x10(%ebp),%eax
80104b9a:	56                   	push   %esi
80104b9b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104b9e:	39 d6                	cmp    %edx,%esi
80104ba0:	73 26                	jae    80104bc8 <memmove+0x38>
80104ba2:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104ba5:	39 ca                	cmp    %ecx,%edx
80104ba7:	73 1f                	jae    80104bc8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104ba9:	85 c0                	test   %eax,%eax
80104bab:	74 0f                	je     80104bbc <memmove+0x2c>
80104bad:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104bb0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104bb4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104bb7:	83 e8 01             	sub    $0x1,%eax
80104bba:	73 f4                	jae    80104bb0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104bbc:	5e                   	pop    %esi
80104bbd:	89 d0                	mov    %edx,%eax
80104bbf:	5f                   	pop    %edi
80104bc0:	5d                   	pop    %ebp
80104bc1:	c3                   	ret
80104bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104bc8:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104bcb:	89 d7                	mov    %edx,%edi
80104bcd:	85 c0                	test   %eax,%eax
80104bcf:	74 eb                	je     80104bbc <memmove+0x2c>
80104bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104bd8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104bd9:	39 ce                	cmp    %ecx,%esi
80104bdb:	75 fb                	jne    80104bd8 <memmove+0x48>
}
80104bdd:	5e                   	pop    %esi
80104bde:	89 d0                	mov    %edx,%eax
80104be0:	5f                   	pop    %edi
80104be1:	5d                   	pop    %ebp
80104be2:	c3                   	ret
80104be3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bf0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104bf0:	eb 9e                	jmp    80104b90 <memmove>
80104bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c00 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	53                   	push   %ebx
80104c04:	8b 55 10             	mov    0x10(%ebp),%edx
80104c07:	8b 45 08             	mov    0x8(%ebp),%eax
80104c0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
80104c0d:	85 d2                	test   %edx,%edx
80104c0f:	75 16                	jne    80104c27 <strncmp+0x27>
80104c11:	eb 2d                	jmp    80104c40 <strncmp+0x40>
80104c13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c17:	90                   	nop
80104c18:	3a 19                	cmp    (%ecx),%bl
80104c1a:	75 12                	jne    80104c2e <strncmp+0x2e>
    n--, p++, q++;
80104c1c:	83 c0 01             	add    $0x1,%eax
80104c1f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104c22:	83 ea 01             	sub    $0x1,%edx
80104c25:	74 19                	je     80104c40 <strncmp+0x40>
80104c27:	0f b6 18             	movzbl (%eax),%ebx
80104c2a:	84 db                	test   %bl,%bl
80104c2c:	75 ea                	jne    80104c18 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104c2e:	0f b6 00             	movzbl (%eax),%eax
80104c31:	0f b6 11             	movzbl (%ecx),%edx
}
80104c34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c37:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104c38:	29 d0                	sub    %edx,%eax
}
80104c3a:	c3                   	ret
80104c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c3f:	90                   	nop
80104c40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104c43:	31 c0                	xor    %eax,%eax
}
80104c45:	c9                   	leave
80104c46:	c3                   	ret
80104c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c4e:	66 90                	xchg   %ax,%ax

80104c50 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	57                   	push   %edi
80104c54:	56                   	push   %esi
80104c55:	8b 75 08             	mov    0x8(%ebp),%esi
80104c58:	53                   	push   %ebx
80104c59:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104c5c:	89 f0                	mov    %esi,%eax
80104c5e:	eb 15                	jmp    80104c75 <strncpy+0x25>
80104c60:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104c64:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104c67:	83 c0 01             	add    $0x1,%eax
80104c6a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80104c6e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104c71:	84 c9                	test   %cl,%cl
80104c73:	74 13                	je     80104c88 <strncpy+0x38>
80104c75:	89 d3                	mov    %edx,%ebx
80104c77:	83 ea 01             	sub    $0x1,%edx
80104c7a:	85 db                	test   %ebx,%ebx
80104c7c:	7f e2                	jg     80104c60 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104c7e:	5b                   	pop    %ebx
80104c7f:	89 f0                	mov    %esi,%eax
80104c81:	5e                   	pop    %esi
80104c82:	5f                   	pop    %edi
80104c83:	5d                   	pop    %ebp
80104c84:	c3                   	ret
80104c85:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104c88:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104c8b:	83 e9 01             	sub    $0x1,%ecx
80104c8e:	85 d2                	test   %edx,%edx
80104c90:	74 ec                	je     80104c7e <strncpy+0x2e>
80104c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104c98:	83 c0 01             	add    $0x1,%eax
80104c9b:	89 ca                	mov    %ecx,%edx
80104c9d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104ca1:	29 c2                	sub    %eax,%edx
80104ca3:	85 d2                	test   %edx,%edx
80104ca5:	7f f1                	jg     80104c98 <strncpy+0x48>
}
80104ca7:	5b                   	pop    %ebx
80104ca8:	89 f0                	mov    %esi,%eax
80104caa:	5e                   	pop    %esi
80104cab:	5f                   	pop    %edi
80104cac:	5d                   	pop    %ebp
80104cad:	c3                   	ret
80104cae:	66 90                	xchg   %ax,%ax

80104cb0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	56                   	push   %esi
80104cb4:	8b 55 10             	mov    0x10(%ebp),%edx
80104cb7:	8b 75 08             	mov    0x8(%ebp),%esi
80104cba:	53                   	push   %ebx
80104cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104cbe:	85 d2                	test   %edx,%edx
80104cc0:	7e 25                	jle    80104ce7 <safestrcpy+0x37>
80104cc2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104cc6:	89 f2                	mov    %esi,%edx
80104cc8:	eb 16                	jmp    80104ce0 <safestrcpy+0x30>
80104cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104cd0:	0f b6 08             	movzbl (%eax),%ecx
80104cd3:	83 c0 01             	add    $0x1,%eax
80104cd6:	83 c2 01             	add    $0x1,%edx
80104cd9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104cdc:	84 c9                	test   %cl,%cl
80104cde:	74 04                	je     80104ce4 <safestrcpy+0x34>
80104ce0:	39 d8                	cmp    %ebx,%eax
80104ce2:	75 ec                	jne    80104cd0 <safestrcpy+0x20>
    ;
  *s = 0;
80104ce4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104ce7:	89 f0                	mov    %esi,%eax
80104ce9:	5b                   	pop    %ebx
80104cea:	5e                   	pop    %esi
80104ceb:	5d                   	pop    %ebp
80104cec:	c3                   	ret
80104ced:	8d 76 00             	lea    0x0(%esi),%esi

80104cf0 <strlen>:

int
strlen(const char *s)
{
80104cf0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104cf1:	31 c0                	xor    %eax,%eax
{
80104cf3:	89 e5                	mov    %esp,%ebp
80104cf5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104cf8:	80 3a 00             	cmpb   $0x0,(%edx)
80104cfb:	74 0c                	je     80104d09 <strlen+0x19>
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi
80104d00:	83 c0 01             	add    $0x1,%eax
80104d03:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104d07:	75 f7                	jne    80104d00 <strlen+0x10>
    ;
  return n;
}
80104d09:	5d                   	pop    %ebp
80104d0a:	c3                   	ret

80104d0b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104d0b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104d0f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104d13:	55                   	push   %ebp
  pushl %ebx
80104d14:	53                   	push   %ebx
  pushl %esi
80104d15:	56                   	push   %esi
  pushl %edi
80104d16:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104d17:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104d19:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104d1b:	5f                   	pop    %edi
  popl %esi
80104d1c:	5e                   	pop    %esi
  popl %ebx
80104d1d:	5b                   	pop    %ebx
  popl %ebp
80104d1e:	5d                   	pop    %ebp
  ret
80104d1f:	c3                   	ret

80104d20 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	53                   	push   %ebx
80104d24:	83 ec 04             	sub    $0x4,%esp
80104d27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104d2a:	e8 01 ee ff ff       	call   80103b30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d2f:	8b 00                	mov    (%eax),%eax
80104d31:	39 c3                	cmp    %eax,%ebx
80104d33:	73 1b                	jae    80104d50 <fetchint+0x30>
80104d35:	8d 53 04             	lea    0x4(%ebx),%edx
80104d38:	39 d0                	cmp    %edx,%eax
80104d3a:	72 14                	jb     80104d50 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d3f:	8b 13                	mov    (%ebx),%edx
80104d41:	89 10                	mov    %edx,(%eax)
  return 0;
80104d43:	31 c0                	xor    %eax,%eax
}
80104d45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d48:	c9                   	leave
80104d49:	c3                   	ret
80104d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d55:	eb ee                	jmp    80104d45 <fetchint+0x25>
80104d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5e:	66 90                	xchg   %ax,%ax

80104d60 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	53                   	push   %ebx
80104d64:	83 ec 04             	sub    $0x4,%esp
80104d67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104d6a:	e8 c1 ed ff ff       	call   80103b30 <myproc>

  if(addr >= curproc->sz)
80104d6f:	3b 18                	cmp    (%eax),%ebx
80104d71:	73 2d                	jae    80104da0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104d73:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d76:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104d78:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104d7a:	39 d3                	cmp    %edx,%ebx
80104d7c:	73 22                	jae    80104da0 <fetchstr+0x40>
80104d7e:	89 d8                	mov    %ebx,%eax
80104d80:	eb 0d                	jmp    80104d8f <fetchstr+0x2f>
80104d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d88:	83 c0 01             	add    $0x1,%eax
80104d8b:	39 d0                	cmp    %edx,%eax
80104d8d:	73 11                	jae    80104da0 <fetchstr+0x40>
    if(*s == 0)
80104d8f:	80 38 00             	cmpb   $0x0,(%eax)
80104d92:	75 f4                	jne    80104d88 <fetchstr+0x28>
      return s - *pp;
80104d94:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104d96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d99:	c9                   	leave
80104d9a:	c3                   	ret
80104d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d9f:	90                   	nop
80104da0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104da3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104da8:	c9                   	leave
80104da9:	c3                   	ret
80104daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104db0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	56                   	push   %esi
80104db4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104db5:	e8 76 ed ff ff       	call   80103b30 <myproc>
80104dba:	8b 55 08             	mov    0x8(%ebp),%edx
80104dbd:	8b 40 1c             	mov    0x1c(%eax),%eax
80104dc0:	8b 40 44             	mov    0x44(%eax),%eax
80104dc3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104dc6:	e8 65 ed ff ff       	call   80103b30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104dcb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dce:	8b 00                	mov    (%eax),%eax
80104dd0:	39 c6                	cmp    %eax,%esi
80104dd2:	73 1c                	jae    80104df0 <argint+0x40>
80104dd4:	8d 53 08             	lea    0x8(%ebx),%edx
80104dd7:	39 d0                	cmp    %edx,%eax
80104dd9:	72 15                	jb     80104df0 <argint+0x40>
  *ip = *(int*)(addr);
80104ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dde:	8b 53 04             	mov    0x4(%ebx),%edx
80104de1:	89 10                	mov    %edx,(%eax)
  return 0;
80104de3:	31 c0                	xor    %eax,%eax
}
80104de5:	5b                   	pop    %ebx
80104de6:	5e                   	pop    %esi
80104de7:	5d                   	pop    %ebp
80104de8:	c3                   	ret
80104de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104df5:	eb ee                	jmp    80104de5 <argint+0x35>
80104df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dfe:	66 90                	xchg   %ax,%ax

80104e00 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	57                   	push   %edi
80104e04:	56                   	push   %esi
80104e05:	53                   	push   %ebx
80104e06:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104e09:	e8 22 ed ff ff       	call   80103b30 <myproc>
80104e0e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e10:	e8 1b ed ff ff       	call   80103b30 <myproc>
80104e15:	8b 55 08             	mov    0x8(%ebp),%edx
80104e18:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e1b:	8b 40 44             	mov    0x44(%eax),%eax
80104e1e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104e21:	e8 0a ed ff ff       	call   80103b30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e26:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e29:	8b 00                	mov    (%eax),%eax
80104e2b:	39 c7                	cmp    %eax,%edi
80104e2d:	73 31                	jae    80104e60 <argptr+0x60>
80104e2f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104e32:	39 c8                	cmp    %ecx,%eax
80104e34:	72 2a                	jb     80104e60 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104e36:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104e39:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104e3c:	85 d2                	test   %edx,%edx
80104e3e:	78 20                	js     80104e60 <argptr+0x60>
80104e40:	8b 16                	mov    (%esi),%edx
80104e42:	39 d0                	cmp    %edx,%eax
80104e44:	73 1a                	jae    80104e60 <argptr+0x60>
80104e46:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104e49:	01 c3                	add    %eax,%ebx
80104e4b:	39 da                	cmp    %ebx,%edx
80104e4d:	72 11                	jb     80104e60 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104e4f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e52:	89 02                	mov    %eax,(%edx)
  return 0;
80104e54:	31 c0                	xor    %eax,%eax
}
80104e56:	83 c4 0c             	add    $0xc,%esp
80104e59:	5b                   	pop    %ebx
80104e5a:	5e                   	pop    %esi
80104e5b:	5f                   	pop    %edi
80104e5c:	5d                   	pop    %ebp
80104e5d:	c3                   	ret
80104e5e:	66 90                	xchg   %ax,%ax
    return -1;
80104e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e65:	eb ef                	jmp    80104e56 <argptr+0x56>
80104e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6e:	66 90                	xchg   %ax,%ax

80104e70 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	56                   	push   %esi
80104e74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e75:	e8 b6 ec ff ff       	call   80103b30 <myproc>
80104e7a:	8b 55 08             	mov    0x8(%ebp),%edx
80104e7d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e80:	8b 40 44             	mov    0x44(%eax),%eax
80104e83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104e86:	e8 a5 ec ff ff       	call   80103b30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e8b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e8e:	8b 00                	mov    (%eax),%eax
80104e90:	39 c6                	cmp    %eax,%esi
80104e92:	73 44                	jae    80104ed8 <argstr+0x68>
80104e94:	8d 53 08             	lea    0x8(%ebx),%edx
80104e97:	39 d0                	cmp    %edx,%eax
80104e99:	72 3d                	jb     80104ed8 <argstr+0x68>
  *ip = *(int*)(addr);
80104e9b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104e9e:	e8 8d ec ff ff       	call   80103b30 <myproc>
  if(addr >= curproc->sz)
80104ea3:	3b 18                	cmp    (%eax),%ebx
80104ea5:	73 31                	jae    80104ed8 <argstr+0x68>
  *pp = (char*)addr;
80104ea7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104eaa:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104eac:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104eae:	39 d3                	cmp    %edx,%ebx
80104eb0:	73 26                	jae    80104ed8 <argstr+0x68>
80104eb2:	89 d8                	mov    %ebx,%eax
80104eb4:	eb 11                	jmp    80104ec7 <argstr+0x57>
80104eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ebd:	8d 76 00             	lea    0x0(%esi),%esi
80104ec0:	83 c0 01             	add    $0x1,%eax
80104ec3:	39 d0                	cmp    %edx,%eax
80104ec5:	73 11                	jae    80104ed8 <argstr+0x68>
    if(*s == 0)
80104ec7:	80 38 00             	cmpb   $0x0,(%eax)
80104eca:	75 f4                	jne    80104ec0 <argstr+0x50>
      return s - *pp;
80104ecc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104ece:	5b                   	pop    %ebx
80104ecf:	5e                   	pop    %esi
80104ed0:	5d                   	pop    %ebp
80104ed1:	c3                   	ret
80104ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ed8:	5b                   	pop    %ebx
    return -1;
80104ed9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ede:	5e                   	pop    %esi
80104edf:	5d                   	pop    %ebp
80104ee0:	c3                   	ret
80104ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ee8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eef:	90                   	nop

80104ef0 <syscall>:
[SYS_getNumFreePages]   sys_getNumFreePages,
};

void
syscall(void)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	53                   	push   %ebx
80104ef4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ef7:	e8 34 ec ff ff       	call   80103b30 <myproc>
80104efc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104efe:	8b 40 1c             	mov    0x1c(%eax),%eax
80104f01:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f04:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f07:	83 fa 16             	cmp    $0x16,%edx
80104f0a:	77 24                	ja     80104f30 <syscall+0x40>
80104f0c:	8b 14 85 c0 84 10 80 	mov    -0x7fef7b40(,%eax,4),%edx
80104f13:	85 d2                	test   %edx,%edx
80104f15:	74 19                	je     80104f30 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104f17:	ff d2                	call   *%edx
80104f19:	89 c2                	mov    %eax,%edx
80104f1b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104f1e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104f21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f24:	c9                   	leave
80104f25:	c3                   	ret
80104f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104f30:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104f31:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104f34:	50                   	push   %eax
80104f35:	ff 73 14             	push   0x14(%ebx)
80104f38:	68 08 7e 10 80       	push   $0x80107e08
80104f3d:	e8 5e b8 ff ff       	call   801007a0 <cprintf>
    curproc->tf->eax = -1;
80104f42:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104f45:	83 c4 10             	add    $0x10,%esp
80104f48:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104f4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f52:	c9                   	leave
80104f53:	c3                   	ret
80104f54:	66 90                	xchg   %ax,%ax
80104f56:	66 90                	xchg   %ax,%ax
80104f58:	66 90                	xchg   %ax,%ax
80104f5a:	66 90                	xchg   %ax,%ax
80104f5c:	66 90                	xchg   %ax,%ax
80104f5e:	66 90                	xchg   %ax,%ax

80104f60 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	57                   	push   %edi
80104f64:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104f65:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104f68:	53                   	push   %ebx
80104f69:	83 ec 34             	sub    $0x34,%esp
80104f6c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104f6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f72:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104f75:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104f78:	57                   	push   %edi
80104f79:	50                   	push   %eax
80104f7a:	e8 11 d2 ff ff       	call   80102190 <nameiparent>
80104f7f:	83 c4 10             	add    $0x10,%esp
80104f82:	85 c0                	test   %eax,%eax
80104f84:	74 5e                	je     80104fe4 <create+0x84>
    return 0;
  ilock(dp);
80104f86:	83 ec 0c             	sub    $0xc,%esp
80104f89:	89 c3                	mov    %eax,%ebx
80104f8b:	50                   	push   %eax
80104f8c:	e8 ff c8 ff ff       	call   80101890 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104f91:	83 c4 0c             	add    $0xc,%esp
80104f94:	6a 00                	push   $0x0
80104f96:	57                   	push   %edi
80104f97:	53                   	push   %ebx
80104f98:	e8 43 ce ff ff       	call   80101de0 <dirlookup>
80104f9d:	83 c4 10             	add    $0x10,%esp
80104fa0:	89 c6                	mov    %eax,%esi
80104fa2:	85 c0                	test   %eax,%eax
80104fa4:	74 4a                	je     80104ff0 <create+0x90>
    iunlockput(dp);
80104fa6:	83 ec 0c             	sub    $0xc,%esp
80104fa9:	53                   	push   %ebx
80104faa:	e8 71 cb ff ff       	call   80101b20 <iunlockput>
    ilock(ip);
80104faf:	89 34 24             	mov    %esi,(%esp)
80104fb2:	e8 d9 c8 ff ff       	call   80101890 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104fb7:	83 c4 10             	add    $0x10,%esp
80104fba:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104fbf:	75 17                	jne    80104fd8 <create+0x78>
80104fc1:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104fc6:	75 10                	jne    80104fd8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104fc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fcb:	89 f0                	mov    %esi,%eax
80104fcd:	5b                   	pop    %ebx
80104fce:	5e                   	pop    %esi
80104fcf:	5f                   	pop    %edi
80104fd0:	5d                   	pop    %ebp
80104fd1:	c3                   	ret
80104fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104fd8:	83 ec 0c             	sub    $0xc,%esp
80104fdb:	56                   	push   %esi
80104fdc:	e8 3f cb ff ff       	call   80101b20 <iunlockput>
    return 0;
80104fe1:	83 c4 10             	add    $0x10,%esp
}
80104fe4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104fe7:	31 f6                	xor    %esi,%esi
}
80104fe9:	5b                   	pop    %ebx
80104fea:	89 f0                	mov    %esi,%eax
80104fec:	5e                   	pop    %esi
80104fed:	5f                   	pop    %edi
80104fee:	5d                   	pop    %ebp
80104fef:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104ff0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104ff4:	83 ec 08             	sub    $0x8,%esp
80104ff7:	50                   	push   %eax
80104ff8:	ff 33                	push   (%ebx)
80104ffa:	e8 21 c7 ff ff       	call   80101720 <ialloc>
80104fff:	83 c4 10             	add    $0x10,%esp
80105002:	89 c6                	mov    %eax,%esi
80105004:	85 c0                	test   %eax,%eax
80105006:	0f 84 bc 00 00 00    	je     801050c8 <create+0x168>
  ilock(ip);
8010500c:	83 ec 0c             	sub    $0xc,%esp
8010500f:	50                   	push   %eax
80105010:	e8 7b c8 ff ff       	call   80101890 <ilock>
  ip->major = major;
80105015:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105019:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010501d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105021:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105025:	b8 01 00 00 00       	mov    $0x1,%eax
8010502a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010502e:	89 34 24             	mov    %esi,(%esp)
80105031:	e8 aa c7 ff ff       	call   801017e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105036:	83 c4 10             	add    $0x10,%esp
80105039:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010503e:	74 30                	je     80105070 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80105040:	83 ec 04             	sub    $0x4,%esp
80105043:	ff 76 04             	push   0x4(%esi)
80105046:	57                   	push   %edi
80105047:	53                   	push   %ebx
80105048:	e8 63 d0 ff ff       	call   801020b0 <dirlink>
8010504d:	83 c4 10             	add    $0x10,%esp
80105050:	85 c0                	test   %eax,%eax
80105052:	78 67                	js     801050bb <create+0x15b>
  iunlockput(dp);
80105054:	83 ec 0c             	sub    $0xc,%esp
80105057:	53                   	push   %ebx
80105058:	e8 c3 ca ff ff       	call   80101b20 <iunlockput>
  return ip;
8010505d:	83 c4 10             	add    $0x10,%esp
}
80105060:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105063:	89 f0                	mov    %esi,%eax
80105065:	5b                   	pop    %ebx
80105066:	5e                   	pop    %esi
80105067:	5f                   	pop    %edi
80105068:	5d                   	pop    %ebp
80105069:	c3                   	ret
8010506a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105070:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105073:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105078:	53                   	push   %ebx
80105079:	e8 62 c7 ff ff       	call   801017e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010507e:	83 c4 0c             	add    $0xc,%esp
80105081:	ff 76 04             	push   0x4(%esi)
80105084:	68 40 7e 10 80       	push   $0x80107e40
80105089:	56                   	push   %esi
8010508a:	e8 21 d0 ff ff       	call   801020b0 <dirlink>
8010508f:	83 c4 10             	add    $0x10,%esp
80105092:	85 c0                	test   %eax,%eax
80105094:	78 18                	js     801050ae <create+0x14e>
80105096:	83 ec 04             	sub    $0x4,%esp
80105099:	ff 73 04             	push   0x4(%ebx)
8010509c:	68 3f 7e 10 80       	push   $0x80107e3f
801050a1:	56                   	push   %esi
801050a2:	e8 09 d0 ff ff       	call   801020b0 <dirlink>
801050a7:	83 c4 10             	add    $0x10,%esp
801050aa:	85 c0                	test   %eax,%eax
801050ac:	79 92                	jns    80105040 <create+0xe0>
      panic("create dots");
801050ae:	83 ec 0c             	sub    $0xc,%esp
801050b1:	68 33 7e 10 80       	push   $0x80107e33
801050b6:	e8 b5 b3 ff ff       	call   80100470 <panic>
    panic("create: dirlink");
801050bb:	83 ec 0c             	sub    $0xc,%esp
801050be:	68 42 7e 10 80       	push   $0x80107e42
801050c3:	e8 a8 b3 ff ff       	call   80100470 <panic>
    panic("create: ialloc");
801050c8:	83 ec 0c             	sub    $0xc,%esp
801050cb:	68 24 7e 10 80       	push   $0x80107e24
801050d0:	e8 9b b3 ff ff       	call   80100470 <panic>
801050d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050e0 <sys_dup>:
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	56                   	push   %esi
801050e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801050e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050eb:	50                   	push   %eax
801050ec:	6a 00                	push   $0x0
801050ee:	e8 bd fc ff ff       	call   80104db0 <argint>
801050f3:	83 c4 10             	add    $0x10,%esp
801050f6:	85 c0                	test   %eax,%eax
801050f8:	78 36                	js     80105130 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050fe:	77 30                	ja     80105130 <sys_dup+0x50>
80105100:	e8 2b ea ff ff       	call   80103b30 <myproc>
80105105:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105108:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010510c:	85 f6                	test   %esi,%esi
8010510e:	74 20                	je     80105130 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105110:	e8 1b ea ff ff       	call   80103b30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105115:	31 db                	xor    %ebx,%ebx
80105117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105120:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105124:	85 d2                	test   %edx,%edx
80105126:	74 18                	je     80105140 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105128:	83 c3 01             	add    $0x1,%ebx
8010512b:	83 fb 10             	cmp    $0x10,%ebx
8010512e:	75 f0                	jne    80105120 <sys_dup+0x40>
}
80105130:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105133:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105138:	89 d8                	mov    %ebx,%eax
8010513a:	5b                   	pop    %ebx
8010513b:	5e                   	pop    %esi
8010513c:	5d                   	pop    %ebp
8010513d:	c3                   	ret
8010513e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105140:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105143:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
80105147:	56                   	push   %esi
80105148:	e8 63 be ff ff       	call   80100fb0 <filedup>
  return fd;
8010514d:	83 c4 10             	add    $0x10,%esp
}
80105150:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105153:	89 d8                	mov    %ebx,%eax
80105155:	5b                   	pop    %ebx
80105156:	5e                   	pop    %esi
80105157:	5d                   	pop    %ebp
80105158:	c3                   	ret
80105159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105160 <sys_read>:
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	56                   	push   %esi
80105164:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105165:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105168:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010516b:	53                   	push   %ebx
8010516c:	6a 00                	push   $0x0
8010516e:	e8 3d fc ff ff       	call   80104db0 <argint>
80105173:	83 c4 10             	add    $0x10,%esp
80105176:	85 c0                	test   %eax,%eax
80105178:	78 5e                	js     801051d8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010517a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010517e:	77 58                	ja     801051d8 <sys_read+0x78>
80105180:	e8 ab e9 ff ff       	call   80103b30 <myproc>
80105185:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105188:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010518c:	85 f6                	test   %esi,%esi
8010518e:	74 48                	je     801051d8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105190:	83 ec 08             	sub    $0x8,%esp
80105193:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105196:	50                   	push   %eax
80105197:	6a 02                	push   $0x2
80105199:	e8 12 fc ff ff       	call   80104db0 <argint>
8010519e:	83 c4 10             	add    $0x10,%esp
801051a1:	85 c0                	test   %eax,%eax
801051a3:	78 33                	js     801051d8 <sys_read+0x78>
801051a5:	83 ec 04             	sub    $0x4,%esp
801051a8:	ff 75 f0             	push   -0x10(%ebp)
801051ab:	53                   	push   %ebx
801051ac:	6a 01                	push   $0x1
801051ae:	e8 4d fc ff ff       	call   80104e00 <argptr>
801051b3:	83 c4 10             	add    $0x10,%esp
801051b6:	85 c0                	test   %eax,%eax
801051b8:	78 1e                	js     801051d8 <sys_read+0x78>
  return fileread(f, p, n);
801051ba:	83 ec 04             	sub    $0x4,%esp
801051bd:	ff 75 f0             	push   -0x10(%ebp)
801051c0:	ff 75 f4             	push   -0xc(%ebp)
801051c3:	56                   	push   %esi
801051c4:	e8 67 bf ff ff       	call   80101130 <fileread>
801051c9:	83 c4 10             	add    $0x10,%esp
}
801051cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051cf:	5b                   	pop    %ebx
801051d0:	5e                   	pop    %esi
801051d1:	5d                   	pop    %ebp
801051d2:	c3                   	ret
801051d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051d7:	90                   	nop
    return -1;
801051d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051dd:	eb ed                	jmp    801051cc <sys_read+0x6c>
801051df:	90                   	nop

801051e0 <sys_write>:
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	56                   	push   %esi
801051e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801051e5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801051e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051eb:	53                   	push   %ebx
801051ec:	6a 00                	push   $0x0
801051ee:	e8 bd fb ff ff       	call   80104db0 <argint>
801051f3:	83 c4 10             	add    $0x10,%esp
801051f6:	85 c0                	test   %eax,%eax
801051f8:	78 5e                	js     80105258 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051fe:	77 58                	ja     80105258 <sys_write+0x78>
80105200:	e8 2b e9 ff ff       	call   80103b30 <myproc>
80105205:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105208:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010520c:	85 f6                	test   %esi,%esi
8010520e:	74 48                	je     80105258 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105210:	83 ec 08             	sub    $0x8,%esp
80105213:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105216:	50                   	push   %eax
80105217:	6a 02                	push   $0x2
80105219:	e8 92 fb ff ff       	call   80104db0 <argint>
8010521e:	83 c4 10             	add    $0x10,%esp
80105221:	85 c0                	test   %eax,%eax
80105223:	78 33                	js     80105258 <sys_write+0x78>
80105225:	83 ec 04             	sub    $0x4,%esp
80105228:	ff 75 f0             	push   -0x10(%ebp)
8010522b:	53                   	push   %ebx
8010522c:	6a 01                	push   $0x1
8010522e:	e8 cd fb ff ff       	call   80104e00 <argptr>
80105233:	83 c4 10             	add    $0x10,%esp
80105236:	85 c0                	test   %eax,%eax
80105238:	78 1e                	js     80105258 <sys_write+0x78>
  return filewrite(f, p, n);
8010523a:	83 ec 04             	sub    $0x4,%esp
8010523d:	ff 75 f0             	push   -0x10(%ebp)
80105240:	ff 75 f4             	push   -0xc(%ebp)
80105243:	56                   	push   %esi
80105244:	e8 77 bf ff ff       	call   801011c0 <filewrite>
80105249:	83 c4 10             	add    $0x10,%esp
}
8010524c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010524f:	5b                   	pop    %ebx
80105250:	5e                   	pop    %esi
80105251:	5d                   	pop    %ebp
80105252:	c3                   	ret
80105253:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105257:	90                   	nop
    return -1;
80105258:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010525d:	eb ed                	jmp    8010524c <sys_write+0x6c>
8010525f:	90                   	nop

80105260 <sys_close>:
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	56                   	push   %esi
80105264:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105265:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105268:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010526b:	50                   	push   %eax
8010526c:	6a 00                	push   $0x0
8010526e:	e8 3d fb ff ff       	call   80104db0 <argint>
80105273:	83 c4 10             	add    $0x10,%esp
80105276:	85 c0                	test   %eax,%eax
80105278:	78 3e                	js     801052b8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010527a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010527e:	77 38                	ja     801052b8 <sys_close+0x58>
80105280:	e8 ab e8 ff ff       	call   80103b30 <myproc>
80105285:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105288:	8d 5a 08             	lea    0x8(%edx),%ebx
8010528b:	8b 74 98 0c          	mov    0xc(%eax,%ebx,4),%esi
8010528f:	85 f6                	test   %esi,%esi
80105291:	74 25                	je     801052b8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105293:	e8 98 e8 ff ff       	call   80103b30 <myproc>
  fileclose(f);
80105298:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010529b:	c7 44 98 0c 00 00 00 	movl   $0x0,0xc(%eax,%ebx,4)
801052a2:	00 
  fileclose(f);
801052a3:	56                   	push   %esi
801052a4:	e8 57 bd ff ff       	call   80101000 <fileclose>
  return 0;
801052a9:	83 c4 10             	add    $0x10,%esp
801052ac:	31 c0                	xor    %eax,%eax
}
801052ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052b1:	5b                   	pop    %ebx
801052b2:	5e                   	pop    %esi
801052b3:	5d                   	pop    %ebp
801052b4:	c3                   	ret
801052b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052bd:	eb ef                	jmp    801052ae <sys_close+0x4e>
801052bf:	90                   	nop

801052c0 <sys_fstat>:
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	56                   	push   %esi
801052c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801052c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801052c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801052cb:	53                   	push   %ebx
801052cc:	6a 00                	push   $0x0
801052ce:	e8 dd fa ff ff       	call   80104db0 <argint>
801052d3:	83 c4 10             	add    $0x10,%esp
801052d6:	85 c0                	test   %eax,%eax
801052d8:	78 46                	js     80105320 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801052da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052de:	77 40                	ja     80105320 <sys_fstat+0x60>
801052e0:	e8 4b e8 ff ff       	call   80103b30 <myproc>
801052e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052e8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
801052ec:	85 f6                	test   %esi,%esi
801052ee:	74 30                	je     80105320 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052f0:	83 ec 04             	sub    $0x4,%esp
801052f3:	6a 14                	push   $0x14
801052f5:	53                   	push   %ebx
801052f6:	6a 01                	push   $0x1
801052f8:	e8 03 fb ff ff       	call   80104e00 <argptr>
801052fd:	83 c4 10             	add    $0x10,%esp
80105300:	85 c0                	test   %eax,%eax
80105302:	78 1c                	js     80105320 <sys_fstat+0x60>
  return filestat(f, st);
80105304:	83 ec 08             	sub    $0x8,%esp
80105307:	ff 75 f4             	push   -0xc(%ebp)
8010530a:	56                   	push   %esi
8010530b:	e8 d0 bd ff ff       	call   801010e0 <filestat>
80105310:	83 c4 10             	add    $0x10,%esp
}
80105313:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105316:	5b                   	pop    %ebx
80105317:	5e                   	pop    %esi
80105318:	5d                   	pop    %ebp
80105319:	c3                   	ret
8010531a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105325:	eb ec                	jmp    80105313 <sys_fstat+0x53>
80105327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010532e:	66 90                	xchg   %ax,%ax

80105330 <sys_link>:
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	57                   	push   %edi
80105334:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105335:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105338:	53                   	push   %ebx
80105339:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010533c:	50                   	push   %eax
8010533d:	6a 00                	push   $0x0
8010533f:	e8 2c fb ff ff       	call   80104e70 <argstr>
80105344:	83 c4 10             	add    $0x10,%esp
80105347:	85 c0                	test   %eax,%eax
80105349:	0f 88 fb 00 00 00    	js     8010544a <sys_link+0x11a>
8010534f:	83 ec 08             	sub    $0x8,%esp
80105352:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105355:	50                   	push   %eax
80105356:	6a 01                	push   $0x1
80105358:	e8 13 fb ff ff       	call   80104e70 <argstr>
8010535d:	83 c4 10             	add    $0x10,%esp
80105360:	85 c0                	test   %eax,%eax
80105362:	0f 88 e2 00 00 00    	js     8010544a <sys_link+0x11a>
  begin_op();
80105368:	e8 b3 db ff ff       	call   80102f20 <begin_op>
  if((ip = namei(old)) == 0){
8010536d:	83 ec 0c             	sub    $0xc,%esp
80105370:	ff 75 d4             	push   -0x2c(%ebp)
80105373:	e8 f8 cd ff ff       	call   80102170 <namei>
80105378:	83 c4 10             	add    $0x10,%esp
8010537b:	89 c3                	mov    %eax,%ebx
8010537d:	85 c0                	test   %eax,%eax
8010537f:	0f 84 df 00 00 00    	je     80105464 <sys_link+0x134>
  ilock(ip);
80105385:	83 ec 0c             	sub    $0xc,%esp
80105388:	50                   	push   %eax
80105389:	e8 02 c5 ff ff       	call   80101890 <ilock>
  if(ip->type == T_DIR){
8010538e:	83 c4 10             	add    $0x10,%esp
80105391:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105396:	0f 84 b5 00 00 00    	je     80105451 <sys_link+0x121>
  iupdate(ip);
8010539c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010539f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801053a4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801053a7:	53                   	push   %ebx
801053a8:	e8 33 c4 ff ff       	call   801017e0 <iupdate>
  iunlock(ip);
801053ad:	89 1c 24             	mov    %ebx,(%esp)
801053b0:	e8 bb c5 ff ff       	call   80101970 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801053b5:	58                   	pop    %eax
801053b6:	5a                   	pop    %edx
801053b7:	57                   	push   %edi
801053b8:	ff 75 d0             	push   -0x30(%ebp)
801053bb:	e8 d0 cd ff ff       	call   80102190 <nameiparent>
801053c0:	83 c4 10             	add    $0x10,%esp
801053c3:	89 c6                	mov    %eax,%esi
801053c5:	85 c0                	test   %eax,%eax
801053c7:	74 5b                	je     80105424 <sys_link+0xf4>
  ilock(dp);
801053c9:	83 ec 0c             	sub    $0xc,%esp
801053cc:	50                   	push   %eax
801053cd:	e8 be c4 ff ff       	call   80101890 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801053d2:	8b 03                	mov    (%ebx),%eax
801053d4:	83 c4 10             	add    $0x10,%esp
801053d7:	39 06                	cmp    %eax,(%esi)
801053d9:	75 3d                	jne    80105418 <sys_link+0xe8>
801053db:	83 ec 04             	sub    $0x4,%esp
801053de:	ff 73 04             	push   0x4(%ebx)
801053e1:	57                   	push   %edi
801053e2:	56                   	push   %esi
801053e3:	e8 c8 cc ff ff       	call   801020b0 <dirlink>
801053e8:	83 c4 10             	add    $0x10,%esp
801053eb:	85 c0                	test   %eax,%eax
801053ed:	78 29                	js     80105418 <sys_link+0xe8>
  iunlockput(dp);
801053ef:	83 ec 0c             	sub    $0xc,%esp
801053f2:	56                   	push   %esi
801053f3:	e8 28 c7 ff ff       	call   80101b20 <iunlockput>
  iput(ip);
801053f8:	89 1c 24             	mov    %ebx,(%esp)
801053fb:	e8 c0 c5 ff ff       	call   801019c0 <iput>
  end_op();
80105400:	e8 8b db ff ff       	call   80102f90 <end_op>
  return 0;
80105405:	83 c4 10             	add    $0x10,%esp
80105408:	31 c0                	xor    %eax,%eax
}
8010540a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010540d:	5b                   	pop    %ebx
8010540e:	5e                   	pop    %esi
8010540f:	5f                   	pop    %edi
80105410:	5d                   	pop    %ebp
80105411:	c3                   	ret
80105412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105418:	83 ec 0c             	sub    $0xc,%esp
8010541b:	56                   	push   %esi
8010541c:	e8 ff c6 ff ff       	call   80101b20 <iunlockput>
    goto bad;
80105421:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105424:	83 ec 0c             	sub    $0xc,%esp
80105427:	53                   	push   %ebx
80105428:	e8 63 c4 ff ff       	call   80101890 <ilock>
  ip->nlink--;
8010542d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105432:	89 1c 24             	mov    %ebx,(%esp)
80105435:	e8 a6 c3 ff ff       	call   801017e0 <iupdate>
  iunlockput(ip);
8010543a:	89 1c 24             	mov    %ebx,(%esp)
8010543d:	e8 de c6 ff ff       	call   80101b20 <iunlockput>
  end_op();
80105442:	e8 49 db ff ff       	call   80102f90 <end_op>
  return -1;
80105447:	83 c4 10             	add    $0x10,%esp
    return -1;
8010544a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010544f:	eb b9                	jmp    8010540a <sys_link+0xda>
    iunlockput(ip);
80105451:	83 ec 0c             	sub    $0xc,%esp
80105454:	53                   	push   %ebx
80105455:	e8 c6 c6 ff ff       	call   80101b20 <iunlockput>
    end_op();
8010545a:	e8 31 db ff ff       	call   80102f90 <end_op>
    return -1;
8010545f:	83 c4 10             	add    $0x10,%esp
80105462:	eb e6                	jmp    8010544a <sys_link+0x11a>
    end_op();
80105464:	e8 27 db ff ff       	call   80102f90 <end_op>
    return -1;
80105469:	eb df                	jmp    8010544a <sys_link+0x11a>
8010546b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010546f:	90                   	nop

80105470 <sys_unlink>:
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	57                   	push   %edi
80105474:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105475:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105478:	53                   	push   %ebx
80105479:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010547c:	50                   	push   %eax
8010547d:	6a 00                	push   $0x0
8010547f:	e8 ec f9 ff ff       	call   80104e70 <argstr>
80105484:	83 c4 10             	add    $0x10,%esp
80105487:	85 c0                	test   %eax,%eax
80105489:	0f 88 54 01 00 00    	js     801055e3 <sys_unlink+0x173>
  begin_op();
8010548f:	e8 8c da ff ff       	call   80102f20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105494:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105497:	83 ec 08             	sub    $0x8,%esp
8010549a:	53                   	push   %ebx
8010549b:	ff 75 c0             	push   -0x40(%ebp)
8010549e:	e8 ed cc ff ff       	call   80102190 <nameiparent>
801054a3:	83 c4 10             	add    $0x10,%esp
801054a6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801054a9:	85 c0                	test   %eax,%eax
801054ab:	0f 84 58 01 00 00    	je     80105609 <sys_unlink+0x199>
  ilock(dp);
801054b1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801054b4:	83 ec 0c             	sub    $0xc,%esp
801054b7:	57                   	push   %edi
801054b8:	e8 d3 c3 ff ff       	call   80101890 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801054bd:	58                   	pop    %eax
801054be:	5a                   	pop    %edx
801054bf:	68 40 7e 10 80       	push   $0x80107e40
801054c4:	53                   	push   %ebx
801054c5:	e8 f6 c8 ff ff       	call   80101dc0 <namecmp>
801054ca:	83 c4 10             	add    $0x10,%esp
801054cd:	85 c0                	test   %eax,%eax
801054cf:	0f 84 fb 00 00 00    	je     801055d0 <sys_unlink+0x160>
801054d5:	83 ec 08             	sub    $0x8,%esp
801054d8:	68 3f 7e 10 80       	push   $0x80107e3f
801054dd:	53                   	push   %ebx
801054de:	e8 dd c8 ff ff       	call   80101dc0 <namecmp>
801054e3:	83 c4 10             	add    $0x10,%esp
801054e6:	85 c0                	test   %eax,%eax
801054e8:	0f 84 e2 00 00 00    	je     801055d0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801054ee:	83 ec 04             	sub    $0x4,%esp
801054f1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801054f4:	50                   	push   %eax
801054f5:	53                   	push   %ebx
801054f6:	57                   	push   %edi
801054f7:	e8 e4 c8 ff ff       	call   80101de0 <dirlookup>
801054fc:	83 c4 10             	add    $0x10,%esp
801054ff:	89 c3                	mov    %eax,%ebx
80105501:	85 c0                	test   %eax,%eax
80105503:	0f 84 c7 00 00 00    	je     801055d0 <sys_unlink+0x160>
  ilock(ip);
80105509:	83 ec 0c             	sub    $0xc,%esp
8010550c:	50                   	push   %eax
8010550d:	e8 7e c3 ff ff       	call   80101890 <ilock>
  if(ip->nlink < 1)
80105512:	83 c4 10             	add    $0x10,%esp
80105515:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010551a:	0f 8e 0a 01 00 00    	jle    8010562a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105520:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105525:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105528:	74 66                	je     80105590 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010552a:	83 ec 04             	sub    $0x4,%esp
8010552d:	6a 10                	push   $0x10
8010552f:	6a 00                	push   $0x0
80105531:	57                   	push   %edi
80105532:	e8 c9 f5 ff ff       	call   80104b00 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105537:	6a 10                	push   $0x10
80105539:	ff 75 c4             	push   -0x3c(%ebp)
8010553c:	57                   	push   %edi
8010553d:	ff 75 b4             	push   -0x4c(%ebp)
80105540:	e8 5b c7 ff ff       	call   80101ca0 <writei>
80105545:	83 c4 20             	add    $0x20,%esp
80105548:	83 f8 10             	cmp    $0x10,%eax
8010554b:	0f 85 cc 00 00 00    	jne    8010561d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105551:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105556:	0f 84 94 00 00 00    	je     801055f0 <sys_unlink+0x180>
  iunlockput(dp);
8010555c:	83 ec 0c             	sub    $0xc,%esp
8010555f:	ff 75 b4             	push   -0x4c(%ebp)
80105562:	e8 b9 c5 ff ff       	call   80101b20 <iunlockput>
  ip->nlink--;
80105567:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010556c:	89 1c 24             	mov    %ebx,(%esp)
8010556f:	e8 6c c2 ff ff       	call   801017e0 <iupdate>
  iunlockput(ip);
80105574:	89 1c 24             	mov    %ebx,(%esp)
80105577:	e8 a4 c5 ff ff       	call   80101b20 <iunlockput>
  end_op();
8010557c:	e8 0f da ff ff       	call   80102f90 <end_op>
  return 0;
80105581:	83 c4 10             	add    $0x10,%esp
80105584:	31 c0                	xor    %eax,%eax
}
80105586:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105589:	5b                   	pop    %ebx
8010558a:	5e                   	pop    %esi
8010558b:	5f                   	pop    %edi
8010558c:	5d                   	pop    %ebp
8010558d:	c3                   	ret
8010558e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105590:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105594:	76 94                	jbe    8010552a <sys_unlink+0xba>
80105596:	be 20 00 00 00       	mov    $0x20,%esi
8010559b:	eb 0b                	jmp    801055a8 <sys_unlink+0x138>
8010559d:	8d 76 00             	lea    0x0(%esi),%esi
801055a0:	83 c6 10             	add    $0x10,%esi
801055a3:	3b 73 58             	cmp    0x58(%ebx),%esi
801055a6:	73 82                	jae    8010552a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055a8:	6a 10                	push   $0x10
801055aa:	56                   	push   %esi
801055ab:	57                   	push   %edi
801055ac:	53                   	push   %ebx
801055ad:	e8 ee c5 ff ff       	call   80101ba0 <readi>
801055b2:	83 c4 10             	add    $0x10,%esp
801055b5:	83 f8 10             	cmp    $0x10,%eax
801055b8:	75 56                	jne    80105610 <sys_unlink+0x1a0>
    if(de.inum != 0)
801055ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801055bf:	74 df                	je     801055a0 <sys_unlink+0x130>
    iunlockput(ip);
801055c1:	83 ec 0c             	sub    $0xc,%esp
801055c4:	53                   	push   %ebx
801055c5:	e8 56 c5 ff ff       	call   80101b20 <iunlockput>
    goto bad;
801055ca:	83 c4 10             	add    $0x10,%esp
801055cd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	ff 75 b4             	push   -0x4c(%ebp)
801055d6:	e8 45 c5 ff ff       	call   80101b20 <iunlockput>
  end_op();
801055db:	e8 b0 d9 ff ff       	call   80102f90 <end_op>
  return -1;
801055e0:	83 c4 10             	add    $0x10,%esp
    return -1;
801055e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055e8:	eb 9c                	jmp    80105586 <sys_unlink+0x116>
801055ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801055f0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801055f3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801055f6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801055fb:	50                   	push   %eax
801055fc:	e8 df c1 ff ff       	call   801017e0 <iupdate>
80105601:	83 c4 10             	add    $0x10,%esp
80105604:	e9 53 ff ff ff       	jmp    8010555c <sys_unlink+0xec>
    end_op();
80105609:	e8 82 d9 ff ff       	call   80102f90 <end_op>
    return -1;
8010560e:	eb d3                	jmp    801055e3 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105610:	83 ec 0c             	sub    $0xc,%esp
80105613:	68 64 7e 10 80       	push   $0x80107e64
80105618:	e8 53 ae ff ff       	call   80100470 <panic>
    panic("unlink: writei");
8010561d:	83 ec 0c             	sub    $0xc,%esp
80105620:	68 76 7e 10 80       	push   $0x80107e76
80105625:	e8 46 ae ff ff       	call   80100470 <panic>
    panic("unlink: nlink < 1");
8010562a:	83 ec 0c             	sub    $0xc,%esp
8010562d:	68 52 7e 10 80       	push   $0x80107e52
80105632:	e8 39 ae ff ff       	call   80100470 <panic>
80105637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010563e:	66 90                	xchg   %ax,%ax

80105640 <sys_open>:

int
sys_open(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	57                   	push   %edi
80105644:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105645:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105648:	53                   	push   %ebx
80105649:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010564c:	50                   	push   %eax
8010564d:	6a 00                	push   $0x0
8010564f:	e8 1c f8 ff ff       	call   80104e70 <argstr>
80105654:	83 c4 10             	add    $0x10,%esp
80105657:	85 c0                	test   %eax,%eax
80105659:	0f 88 8e 00 00 00    	js     801056ed <sys_open+0xad>
8010565f:	83 ec 08             	sub    $0x8,%esp
80105662:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105665:	50                   	push   %eax
80105666:	6a 01                	push   $0x1
80105668:	e8 43 f7 ff ff       	call   80104db0 <argint>
8010566d:	83 c4 10             	add    $0x10,%esp
80105670:	85 c0                	test   %eax,%eax
80105672:	78 79                	js     801056ed <sys_open+0xad>
    return -1;

  begin_op();
80105674:	e8 a7 d8 ff ff       	call   80102f20 <begin_op>

  if(omode & O_CREATE){
80105679:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010567d:	75 79                	jne    801056f8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010567f:	83 ec 0c             	sub    $0xc,%esp
80105682:	ff 75 e0             	push   -0x20(%ebp)
80105685:	e8 e6 ca ff ff       	call   80102170 <namei>
8010568a:	83 c4 10             	add    $0x10,%esp
8010568d:	89 c6                	mov    %eax,%esi
8010568f:	85 c0                	test   %eax,%eax
80105691:	0f 84 7e 00 00 00    	je     80105715 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105697:	83 ec 0c             	sub    $0xc,%esp
8010569a:	50                   	push   %eax
8010569b:	e8 f0 c1 ff ff       	call   80101890 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801056a0:	83 c4 10             	add    $0x10,%esp
801056a3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801056a8:	0f 84 ba 00 00 00    	je     80105768 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801056ae:	e8 8d b8 ff ff       	call   80100f40 <filealloc>
801056b3:	89 c7                	mov    %eax,%edi
801056b5:	85 c0                	test   %eax,%eax
801056b7:	74 23                	je     801056dc <sys_open+0x9c>
  struct proc *curproc = myproc();
801056b9:	e8 72 e4 ff ff       	call   80103b30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056be:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801056c0:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
801056c4:	85 d2                	test   %edx,%edx
801056c6:	74 58                	je     80105720 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
801056c8:	83 c3 01             	add    $0x1,%ebx
801056cb:	83 fb 10             	cmp    $0x10,%ebx
801056ce:	75 f0                	jne    801056c0 <sys_open+0x80>
    if(f)
      fileclose(f);
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	57                   	push   %edi
801056d4:	e8 27 b9 ff ff       	call   80101000 <fileclose>
801056d9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801056dc:	83 ec 0c             	sub    $0xc,%esp
801056df:	56                   	push   %esi
801056e0:	e8 3b c4 ff ff       	call   80101b20 <iunlockput>
    end_op();
801056e5:	e8 a6 d8 ff ff       	call   80102f90 <end_op>
    return -1;
801056ea:	83 c4 10             	add    $0x10,%esp
    return -1;
801056ed:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801056f2:	eb 65                	jmp    80105759 <sys_open+0x119>
801056f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801056f8:	83 ec 0c             	sub    $0xc,%esp
801056fb:	31 c9                	xor    %ecx,%ecx
801056fd:	ba 02 00 00 00       	mov    $0x2,%edx
80105702:	6a 00                	push   $0x0
80105704:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105707:	e8 54 f8 ff ff       	call   80104f60 <create>
    if(ip == 0){
8010570c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010570f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105711:	85 c0                	test   %eax,%eax
80105713:	75 99                	jne    801056ae <sys_open+0x6e>
      end_op();
80105715:	e8 76 d8 ff ff       	call   80102f90 <end_op>
      return -1;
8010571a:	eb d1                	jmp    801056ed <sys_open+0xad>
8010571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105720:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105723:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
80105727:	56                   	push   %esi
80105728:	e8 43 c2 ff ff       	call   80101970 <iunlock>
  end_op();
8010572d:	e8 5e d8 ff ff       	call   80102f90 <end_op>

  f->type = FD_INODE;
80105732:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105738:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010573b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010573e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105741:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105743:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010574a:	f7 d0                	not    %eax
8010574c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010574f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105752:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105755:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105759:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010575c:	89 d8                	mov    %ebx,%eax
8010575e:	5b                   	pop    %ebx
8010575f:	5e                   	pop    %esi
80105760:	5f                   	pop    %edi
80105761:	5d                   	pop    %ebp
80105762:	c3                   	ret
80105763:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105767:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105768:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010576b:	85 c9                	test   %ecx,%ecx
8010576d:	0f 84 3b ff ff ff    	je     801056ae <sys_open+0x6e>
80105773:	e9 64 ff ff ff       	jmp    801056dc <sys_open+0x9c>
80105778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577f:	90                   	nop

80105780 <sys_mkdir>:

int
sys_mkdir(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105786:	e8 95 d7 ff ff       	call   80102f20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010578b:	83 ec 08             	sub    $0x8,%esp
8010578e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105791:	50                   	push   %eax
80105792:	6a 00                	push   $0x0
80105794:	e8 d7 f6 ff ff       	call   80104e70 <argstr>
80105799:	83 c4 10             	add    $0x10,%esp
8010579c:	85 c0                	test   %eax,%eax
8010579e:	78 30                	js     801057d0 <sys_mkdir+0x50>
801057a0:	83 ec 0c             	sub    $0xc,%esp
801057a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057a6:	31 c9                	xor    %ecx,%ecx
801057a8:	ba 01 00 00 00       	mov    $0x1,%edx
801057ad:	6a 00                	push   $0x0
801057af:	e8 ac f7 ff ff       	call   80104f60 <create>
801057b4:	83 c4 10             	add    $0x10,%esp
801057b7:	85 c0                	test   %eax,%eax
801057b9:	74 15                	je     801057d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057bb:	83 ec 0c             	sub    $0xc,%esp
801057be:	50                   	push   %eax
801057bf:	e8 5c c3 ff ff       	call   80101b20 <iunlockput>
  end_op();
801057c4:	e8 c7 d7 ff ff       	call   80102f90 <end_op>
  return 0;
801057c9:	83 c4 10             	add    $0x10,%esp
801057cc:	31 c0                	xor    %eax,%eax
}
801057ce:	c9                   	leave
801057cf:	c3                   	ret
    end_op();
801057d0:	e8 bb d7 ff ff       	call   80102f90 <end_op>
    return -1;
801057d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057da:	c9                   	leave
801057db:	c3                   	ret
801057dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057e0 <sys_mknod>:

int
sys_mknod(void)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801057e6:	e8 35 d7 ff ff       	call   80102f20 <begin_op>
  if((argstr(0, &path)) < 0 ||
801057eb:	83 ec 08             	sub    $0x8,%esp
801057ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057f1:	50                   	push   %eax
801057f2:	6a 00                	push   $0x0
801057f4:	e8 77 f6 ff ff       	call   80104e70 <argstr>
801057f9:	83 c4 10             	add    $0x10,%esp
801057fc:	85 c0                	test   %eax,%eax
801057fe:	78 60                	js     80105860 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105800:	83 ec 08             	sub    $0x8,%esp
80105803:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105806:	50                   	push   %eax
80105807:	6a 01                	push   $0x1
80105809:	e8 a2 f5 ff ff       	call   80104db0 <argint>
  if((argstr(0, &path)) < 0 ||
8010580e:	83 c4 10             	add    $0x10,%esp
80105811:	85 c0                	test   %eax,%eax
80105813:	78 4b                	js     80105860 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105815:	83 ec 08             	sub    $0x8,%esp
80105818:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010581b:	50                   	push   %eax
8010581c:	6a 02                	push   $0x2
8010581e:	e8 8d f5 ff ff       	call   80104db0 <argint>
     argint(1, &major) < 0 ||
80105823:	83 c4 10             	add    $0x10,%esp
80105826:	85 c0                	test   %eax,%eax
80105828:	78 36                	js     80105860 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010582a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010582e:	83 ec 0c             	sub    $0xc,%esp
80105831:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105835:	ba 03 00 00 00       	mov    $0x3,%edx
8010583a:	50                   	push   %eax
8010583b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010583e:	e8 1d f7 ff ff       	call   80104f60 <create>
     argint(2, &minor) < 0 ||
80105843:	83 c4 10             	add    $0x10,%esp
80105846:	85 c0                	test   %eax,%eax
80105848:	74 16                	je     80105860 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010584a:	83 ec 0c             	sub    $0xc,%esp
8010584d:	50                   	push   %eax
8010584e:	e8 cd c2 ff ff       	call   80101b20 <iunlockput>
  end_op();
80105853:	e8 38 d7 ff ff       	call   80102f90 <end_op>
  return 0;
80105858:	83 c4 10             	add    $0x10,%esp
8010585b:	31 c0                	xor    %eax,%eax
}
8010585d:	c9                   	leave
8010585e:	c3                   	ret
8010585f:	90                   	nop
    end_op();
80105860:	e8 2b d7 ff ff       	call   80102f90 <end_op>
    return -1;
80105865:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010586a:	c9                   	leave
8010586b:	c3                   	ret
8010586c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105870 <sys_chdir>:

int
sys_chdir(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	56                   	push   %esi
80105874:	53                   	push   %ebx
80105875:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105878:	e8 b3 e2 ff ff       	call   80103b30 <myproc>
8010587d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010587f:	e8 9c d6 ff ff       	call   80102f20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105884:	83 ec 08             	sub    $0x8,%esp
80105887:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010588a:	50                   	push   %eax
8010588b:	6a 00                	push   $0x0
8010588d:	e8 de f5 ff ff       	call   80104e70 <argstr>
80105892:	83 c4 10             	add    $0x10,%esp
80105895:	85 c0                	test   %eax,%eax
80105897:	78 77                	js     80105910 <sys_chdir+0xa0>
80105899:	83 ec 0c             	sub    $0xc,%esp
8010589c:	ff 75 f4             	push   -0xc(%ebp)
8010589f:	e8 cc c8 ff ff       	call   80102170 <namei>
801058a4:	83 c4 10             	add    $0x10,%esp
801058a7:	89 c3                	mov    %eax,%ebx
801058a9:	85 c0                	test   %eax,%eax
801058ab:	74 63                	je     80105910 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801058ad:	83 ec 0c             	sub    $0xc,%esp
801058b0:	50                   	push   %eax
801058b1:	e8 da bf ff ff       	call   80101890 <ilock>
  if(ip->type != T_DIR){
801058b6:	83 c4 10             	add    $0x10,%esp
801058b9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058be:	75 30                	jne    801058f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801058c0:	83 ec 0c             	sub    $0xc,%esp
801058c3:	53                   	push   %ebx
801058c4:	e8 a7 c0 ff ff       	call   80101970 <iunlock>
  iput(curproc->cwd);
801058c9:	58                   	pop    %eax
801058ca:	ff 76 6c             	push   0x6c(%esi)
801058cd:	e8 ee c0 ff ff       	call   801019c0 <iput>
  end_op();
801058d2:	e8 b9 d6 ff ff       	call   80102f90 <end_op>
  curproc->cwd = ip;
801058d7:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
801058da:	83 c4 10             	add    $0x10,%esp
801058dd:	31 c0                	xor    %eax,%eax
}
801058df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058e2:	5b                   	pop    %ebx
801058e3:	5e                   	pop    %esi
801058e4:	5d                   	pop    %ebp
801058e5:	c3                   	ret
801058e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801058f0:	83 ec 0c             	sub    $0xc,%esp
801058f3:	53                   	push   %ebx
801058f4:	e8 27 c2 ff ff       	call   80101b20 <iunlockput>
    end_op();
801058f9:	e8 92 d6 ff ff       	call   80102f90 <end_op>
    return -1;
801058fe:	83 c4 10             	add    $0x10,%esp
    return -1;
80105901:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105906:	eb d7                	jmp    801058df <sys_chdir+0x6f>
80105908:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590f:	90                   	nop
    end_op();
80105910:	e8 7b d6 ff ff       	call   80102f90 <end_op>
    return -1;
80105915:	eb ea                	jmp    80105901 <sys_chdir+0x91>
80105917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591e:	66 90                	xchg   %ax,%ax

80105920 <sys_exec>:

int
sys_exec(void)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	57                   	push   %edi
80105924:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105925:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010592b:	53                   	push   %ebx
8010592c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105932:	50                   	push   %eax
80105933:	6a 00                	push   $0x0
80105935:	e8 36 f5 ff ff       	call   80104e70 <argstr>
8010593a:	83 c4 10             	add    $0x10,%esp
8010593d:	85 c0                	test   %eax,%eax
8010593f:	0f 88 87 00 00 00    	js     801059cc <sys_exec+0xac>
80105945:	83 ec 08             	sub    $0x8,%esp
80105948:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010594e:	50                   	push   %eax
8010594f:	6a 01                	push   $0x1
80105951:	e8 5a f4 ff ff       	call   80104db0 <argint>
80105956:	83 c4 10             	add    $0x10,%esp
80105959:	85 c0                	test   %eax,%eax
8010595b:	78 6f                	js     801059cc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010595d:	83 ec 04             	sub    $0x4,%esp
80105960:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105966:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105968:	68 80 00 00 00       	push   $0x80
8010596d:	6a 00                	push   $0x0
8010596f:	56                   	push   %esi
80105970:	e8 8b f1 ff ff       	call   80104b00 <memset>
80105975:	83 c4 10             	add    $0x10,%esp
80105978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010597f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105980:	83 ec 08             	sub    $0x8,%esp
80105983:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105989:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105990:	50                   	push   %eax
80105991:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105997:	01 f8                	add    %edi,%eax
80105999:	50                   	push   %eax
8010599a:	e8 81 f3 ff ff       	call   80104d20 <fetchint>
8010599f:	83 c4 10             	add    $0x10,%esp
801059a2:	85 c0                	test   %eax,%eax
801059a4:	78 26                	js     801059cc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801059a6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801059ac:	85 c0                	test   %eax,%eax
801059ae:	74 30                	je     801059e0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801059b0:	83 ec 08             	sub    $0x8,%esp
801059b3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801059b6:	52                   	push   %edx
801059b7:	50                   	push   %eax
801059b8:	e8 a3 f3 ff ff       	call   80104d60 <fetchstr>
801059bd:	83 c4 10             	add    $0x10,%esp
801059c0:	85 c0                	test   %eax,%eax
801059c2:	78 08                	js     801059cc <sys_exec+0xac>
  for(i=0;; i++){
801059c4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801059c7:	83 fb 20             	cmp    $0x20,%ebx
801059ca:	75 b4                	jne    80105980 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801059cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801059cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059d4:	5b                   	pop    %ebx
801059d5:	5e                   	pop    %esi
801059d6:	5f                   	pop    %edi
801059d7:	5d                   	pop    %ebp
801059d8:	c3                   	ret
801059d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801059e0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801059e7:	00 00 00 00 
  return exec(path, argv);
801059eb:	83 ec 08             	sub    $0x8,%esp
801059ee:	56                   	push   %esi
801059ef:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801059f5:	e8 a6 b1 ff ff       	call   80100ba0 <exec>
801059fa:	83 c4 10             	add    $0x10,%esp
}
801059fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a00:	5b                   	pop    %ebx
80105a01:	5e                   	pop    %esi
80105a02:	5f                   	pop    %edi
80105a03:	5d                   	pop    %ebp
80105a04:	c3                   	ret
80105a05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a10 <sys_pipe>:

int
sys_pipe(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	57                   	push   %edi
80105a14:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a15:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105a18:	53                   	push   %ebx
80105a19:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a1c:	6a 08                	push   $0x8
80105a1e:	50                   	push   %eax
80105a1f:	6a 00                	push   $0x0
80105a21:	e8 da f3 ff ff       	call   80104e00 <argptr>
80105a26:	83 c4 10             	add    $0x10,%esp
80105a29:	85 c0                	test   %eax,%eax
80105a2b:	0f 88 8b 00 00 00    	js     80105abc <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105a31:	83 ec 08             	sub    $0x8,%esp
80105a34:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a37:	50                   	push   %eax
80105a38:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105a3b:	50                   	push   %eax
80105a3c:	e8 af db ff ff       	call   801035f0 <pipealloc>
80105a41:	83 c4 10             	add    $0x10,%esp
80105a44:	85 c0                	test   %eax,%eax
80105a46:	78 74                	js     80105abc <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a48:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105a4b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105a4d:	e8 de e0 ff ff       	call   80103b30 <myproc>
    if(curproc->ofile[fd] == 0){
80105a52:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105a56:	85 f6                	test   %esi,%esi
80105a58:	74 16                	je     80105a70 <sys_pipe+0x60>
80105a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105a60:	83 c3 01             	add    $0x1,%ebx
80105a63:	83 fb 10             	cmp    $0x10,%ebx
80105a66:	74 3d                	je     80105aa5 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105a68:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105a6c:	85 f6                	test   %esi,%esi
80105a6e:	75 f0                	jne    80105a60 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105a70:	8d 73 08             	lea    0x8(%ebx),%esi
80105a73:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105a7a:	e8 b1 e0 ff ff       	call   80103b30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a7f:	31 d2                	xor    %edx,%edx
80105a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105a88:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
80105a8c:	85 c9                	test   %ecx,%ecx
80105a8e:	74 38                	je     80105ac8 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105a90:	83 c2 01             	add    $0x1,%edx
80105a93:	83 fa 10             	cmp    $0x10,%edx
80105a96:	75 f0                	jne    80105a88 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105a98:	e8 93 e0 ff ff       	call   80103b30 <myproc>
80105a9d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105aa4:	00 
    fileclose(rf);
80105aa5:	83 ec 0c             	sub    $0xc,%esp
80105aa8:	ff 75 e0             	push   -0x20(%ebp)
80105aab:	e8 50 b5 ff ff       	call   80101000 <fileclose>
    fileclose(wf);
80105ab0:	58                   	pop    %eax
80105ab1:	ff 75 e4             	push   -0x1c(%ebp)
80105ab4:	e8 47 b5 ff ff       	call   80101000 <fileclose>
    return -1;
80105ab9:	83 c4 10             	add    $0x10,%esp
    return -1;
80105abc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ac1:	eb 16                	jmp    80105ad9 <sys_pipe+0xc9>
80105ac3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ac7:	90                   	nop
      curproc->ofile[fd] = f;
80105ac8:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  }
  fd[0] = fd0;
80105acc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105acf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ad1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ad4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105ad7:	31 c0                	xor    %eax,%eax
}
80105ad9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105adc:	5b                   	pop    %ebx
80105add:	5e                   	pop    %esi
80105ade:	5f                   	pop    %edi
80105adf:	5d                   	pop    %ebp
80105ae0:	c3                   	ret
80105ae1:	66 90                	xchg   %ax,%ax
80105ae3:	66 90                	xchg   %ax,%ax
80105ae5:	66 90                	xchg   %ax,%ax
80105ae7:	66 90                	xchg   %ax,%ax
80105ae9:	66 90                	xchg   %ax,%ax
80105aeb:	66 90                	xchg   %ax,%ax
80105aed:	66 90                	xchg   %ax,%ax
80105aef:	90                   	nop

80105af0 <sys_getNumFreePages>:


int
sys_getNumFreePages(void)
{
  return num_of_FreePages();  
80105af0:	e9 9b cd ff ff       	jmp    80102890 <num_of_FreePages>
80105af5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b00 <sys_getrss>:
}

int 
sys_getrss()
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	83 ec 08             	sub    $0x8,%esp
  print_rss();
80105b06:	e8 d5 e2 ff ff       	call   80103de0 <print_rss>
  return 0;
}
80105b0b:	31 c0                	xor    %eax,%eax
80105b0d:	c9                   	leave
80105b0e:	c3                   	ret
80105b0f:	90                   	nop

80105b10 <sys_fork>:

int
sys_fork(void)
{
  return fork();
80105b10:	e9 bb e1 ff ff       	jmp    80103cd0 <fork>
80105b15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b20 <sys_exit>:
}

int
sys_exit(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b26:	e8 85 e4 ff ff       	call   80103fb0 <exit>
  return 0;  // not reached
}
80105b2b:	31 c0                	xor    %eax,%eax
80105b2d:	c9                   	leave
80105b2e:	c3                   	ret
80105b2f:	90                   	nop

80105b30 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105b30:	e9 ab e5 ff ff       	jmp    801040e0 <wait>
80105b35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b40 <sys_kill>:
}

int
sys_kill(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105b46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b49:	50                   	push   %eax
80105b4a:	6a 00                	push   $0x0
80105b4c:	e8 5f f2 ff ff       	call   80104db0 <argint>
80105b51:	83 c4 10             	add    $0x10,%esp
80105b54:	85 c0                	test   %eax,%eax
80105b56:	78 18                	js     80105b70 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105b58:	83 ec 0c             	sub    $0xc,%esp
80105b5b:	ff 75 f4             	push   -0xc(%ebp)
80105b5e:	e8 1d e8 ff ff       	call   80104380 <kill>
80105b63:	83 c4 10             	add    $0x10,%esp
}
80105b66:	c9                   	leave
80105b67:	c3                   	ret
80105b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b6f:	90                   	nop
80105b70:	c9                   	leave
    return -1;
80105b71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b76:	c3                   	ret
80105b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b7e:	66 90                	xchg   %ax,%ax

80105b80 <sys_getpid>:

int
sys_getpid(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b86:	e8 a5 df ff ff       	call   80103b30 <myproc>
80105b8b:	8b 40 14             	mov    0x14(%eax),%eax
}
80105b8e:	c9                   	leave
80105b8f:	c3                   	ret

80105b90 <sys_sbrk>:

int
sys_sbrk(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b94:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b97:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b9a:	50                   	push   %eax
80105b9b:	6a 00                	push   $0x0
80105b9d:	e8 0e f2 ff ff       	call   80104db0 <argint>
80105ba2:	83 c4 10             	add    $0x10,%esp
80105ba5:	85 c0                	test   %eax,%eax
80105ba7:	78 27                	js     80105bd0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ba9:	e8 82 df ff ff       	call   80103b30 <myproc>
  if(growproc(n) < 0)
80105bae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105bb1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105bb3:	ff 75 f4             	push   -0xc(%ebp)
80105bb6:	e8 95 e0 ff ff       	call   80103c50 <growproc>
80105bbb:	83 c4 10             	add    $0x10,%esp
80105bbe:	85 c0                	test   %eax,%eax
80105bc0:	78 0e                	js     80105bd0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105bc2:	89 d8                	mov    %ebx,%eax
80105bc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bc7:	c9                   	leave
80105bc8:	c3                   	ret
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105bd0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105bd5:	eb eb                	jmp    80105bc2 <sys_sbrk+0x32>
80105bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bde:	66 90                	xchg   %ax,%ax

80105be0 <sys_sleep>:

int
sys_sleep(void)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105be4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105be7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105bea:	50                   	push   %eax
80105beb:	6a 00                	push   $0x0
80105bed:	e8 be f1 ff ff       	call   80104db0 <argint>
80105bf2:	83 c4 10             	add    $0x10,%esp
80105bf5:	85 c0                	test   %eax,%eax
80105bf7:	78 64                	js     80105c5d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105bf9:	83 ec 0c             	sub    $0xc,%esp
80105bfc:	68 e0 58 11 80       	push   $0x801158e0
80105c01:	e8 fa ed ff ff       	call   80104a00 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105c09:	8b 1d c0 58 11 80    	mov    0x801158c0,%ebx
  while(ticks - ticks0 < n){
80105c0f:	83 c4 10             	add    $0x10,%esp
80105c12:	85 d2                	test   %edx,%edx
80105c14:	75 2b                	jne    80105c41 <sys_sleep+0x61>
80105c16:	eb 58                	jmp    80105c70 <sys_sleep+0x90>
80105c18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1f:	90                   	nop
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105c20:	83 ec 08             	sub    $0x8,%esp
80105c23:	68 e0 58 11 80       	push   $0x801158e0
80105c28:	68 c0 58 11 80       	push   $0x801158c0
80105c2d:	e8 2e e6 ff ff       	call   80104260 <sleep>
  while(ticks - ticks0 < n){
80105c32:	a1 c0 58 11 80       	mov    0x801158c0,%eax
80105c37:	83 c4 10             	add    $0x10,%esp
80105c3a:	29 d8                	sub    %ebx,%eax
80105c3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105c3f:	73 2f                	jae    80105c70 <sys_sleep+0x90>
    if(myproc()->killed){
80105c41:	e8 ea de ff ff       	call   80103b30 <myproc>
80105c46:	8b 40 28             	mov    0x28(%eax),%eax
80105c49:	85 c0                	test   %eax,%eax
80105c4b:	74 d3                	je     80105c20 <sys_sleep+0x40>
      release(&tickslock);
80105c4d:	83 ec 0c             	sub    $0xc,%esp
80105c50:	68 e0 58 11 80       	push   $0x801158e0
80105c55:	e8 46 ed ff ff       	call   801049a0 <release>
      return -1;
80105c5a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80105c5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c65:	c9                   	leave
80105c66:	c3                   	ret
80105c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c6e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105c70:	83 ec 0c             	sub    $0xc,%esp
80105c73:	68 e0 58 11 80       	push   $0x801158e0
80105c78:	e8 23 ed ff ff       	call   801049a0 <release>
}
80105c7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105c80:	83 c4 10             	add    $0x10,%esp
80105c83:	31 c0                	xor    %eax,%eax
}
80105c85:	c9                   	leave
80105c86:	c3                   	ret
80105c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c8e:	66 90                	xchg   %ax,%ax

80105c90 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	53                   	push   %ebx
80105c94:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105c97:	68 e0 58 11 80       	push   $0x801158e0
80105c9c:	e8 5f ed ff ff       	call   80104a00 <acquire>
  xticks = ticks;
80105ca1:	8b 1d c0 58 11 80    	mov    0x801158c0,%ebx
  release(&tickslock);
80105ca7:	c7 04 24 e0 58 11 80 	movl   $0x801158e0,(%esp)
80105cae:	e8 ed ec ff ff       	call   801049a0 <release>
  return xticks;
}
80105cb3:	89 d8                	mov    %ebx,%eax
80105cb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cb8:	c9                   	leave
80105cb9:	c3                   	ret

80105cba <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105cba:	1e                   	push   %ds
  pushl %es
80105cbb:	06                   	push   %es
  pushl %fs
80105cbc:	0f a0                	push   %fs
  pushl %gs
80105cbe:	0f a8                	push   %gs
  pushal
80105cc0:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105cc1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105cc5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105cc7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105cc9:	54                   	push   %esp
  call trap
80105cca:	e8 c1 00 00 00       	call   80105d90 <trap>
  addl $4, %esp
80105ccf:	83 c4 04             	add    $0x4,%esp

80105cd2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105cd2:	61                   	popa
  popl %gs
80105cd3:	0f a9                	pop    %gs
  popl %fs
80105cd5:	0f a1                	pop    %fs
  popl %es
80105cd7:	07                   	pop    %es
  popl %ds
80105cd8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105cd9:	83 c4 08             	add    $0x8,%esp
  iret
80105cdc:	cf                   	iret
80105cdd:	66 90                	xchg   %ax,%ax
80105cdf:	90                   	nop

80105ce0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ce0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105ce1:	31 c0                	xor    %eax,%eax
{
80105ce3:	89 e5                	mov    %esp,%ebp
80105ce5:	83 ec 08             	sub    $0x8,%esp
80105ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cef:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105cf0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105cf7:	c7 04 c5 22 59 11 80 	movl   $0x8e000008,-0x7feea6de(,%eax,8)
80105cfe:	08 00 00 8e 
80105d02:	66 89 14 c5 20 59 11 	mov    %dx,-0x7feea6e0(,%eax,8)
80105d09:	80 
80105d0a:	c1 ea 10             	shr    $0x10,%edx
80105d0d:	66 89 14 c5 26 59 11 	mov    %dx,-0x7feea6da(,%eax,8)
80105d14:	80 
  for(i = 0; i < 256; i++)
80105d15:	83 c0 01             	add    $0x1,%eax
80105d18:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d1d:	75 d1                	jne    80105cf0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105d1f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d22:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105d27:	c7 05 22 5b 11 80 08 	movl   $0xef000008,0x80115b22
80105d2e:	00 00 ef 
  initlock(&tickslock, "time");
80105d31:	68 85 7e 10 80       	push   $0x80107e85
80105d36:	68 e0 58 11 80       	push   $0x801158e0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d3b:	66 a3 20 5b 11 80    	mov    %ax,0x80115b20
80105d41:	c1 e8 10             	shr    $0x10,%eax
80105d44:	66 a3 26 5b 11 80    	mov    %ax,0x80115b26
  initlock(&tickslock, "time");
80105d4a:	e8 c1 ea ff ff       	call   80104810 <initlock>
}
80105d4f:	83 c4 10             	add    $0x10,%esp
80105d52:	c9                   	leave
80105d53:	c3                   	ret
80105d54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d5f:	90                   	nop

80105d60 <idtinit>:

void
idtinit(void)
{
80105d60:	55                   	push   %ebp
  pd[0] = size-1;
80105d61:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105d66:	89 e5                	mov    %esp,%ebp
80105d68:	83 ec 10             	sub    $0x10,%esp
80105d6b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105d6f:	b8 20 59 11 80       	mov    $0x80115920,%eax
80105d74:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105d78:	c1 e8 10             	shr    $0x10,%eax
80105d7b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105d7f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105d82:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105d85:	c9                   	leave
80105d86:	c3                   	ret
80105d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d8e:	66 90                	xchg   %ax,%ax

80105d90 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	57                   	push   %edi
80105d94:	56                   	push   %esi
80105d95:	53                   	push   %ebx
80105d96:	83 ec 1c             	sub    $0x1c,%esp
80105d99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105d9c:	8b 43 30             	mov    0x30(%ebx),%eax
80105d9f:	83 f8 40             	cmp    $0x40,%eax
80105da2:	0f 84 30 01 00 00    	je     80105ed8 <trap+0x148>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105da8:	83 e8 0e             	sub    $0xe,%eax
80105dab:	83 f8 31             	cmp    $0x31,%eax
80105dae:	0f 87 8c 00 00 00    	ja     80105e40 <trap+0xb0>
80105db4:	ff 24 85 20 85 10 80 	jmp    *-0x7fef7ae0(,%eax,4)
80105dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dbf:	90                   	nop
    // panic("wohooo\n");
    handle_page_fault();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105dc0:	e8 4b dd ff ff       	call   80103b10 <cpuid>
80105dc5:	85 c0                	test   %eax,%eax
80105dc7:	0f 84 13 02 00 00    	je     80105fe0 <trap+0x250>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105dcd:	e8 fe cc ff ff       	call   80102ad0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dd2:	e8 59 dd ff ff       	call   80103b30 <myproc>
80105dd7:	85 c0                	test   %eax,%eax
80105dd9:	74 1a                	je     80105df5 <trap+0x65>
80105ddb:	e8 50 dd ff ff       	call   80103b30 <myproc>
80105de0:	8b 50 28             	mov    0x28(%eax),%edx
80105de3:	85 d2                	test   %edx,%edx
80105de5:	74 0e                	je     80105df5 <trap+0x65>
80105de7:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105deb:	f7 d0                	not    %eax
80105ded:	a8 03                	test   $0x3,%al
80105def:	0f 84 cb 01 00 00    	je     80105fc0 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105df5:	e8 36 dd ff ff       	call   80103b30 <myproc>
80105dfa:	85 c0                	test   %eax,%eax
80105dfc:	74 0f                	je     80105e0d <trap+0x7d>
80105dfe:	e8 2d dd ff ff       	call   80103b30 <myproc>
80105e03:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80105e07:	0f 84 b3 00 00 00    	je     80105ec0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e0d:	e8 1e dd ff ff       	call   80103b30 <myproc>
80105e12:	85 c0                	test   %eax,%eax
80105e14:	74 1a                	je     80105e30 <trap+0xa0>
80105e16:	e8 15 dd ff ff       	call   80103b30 <myproc>
80105e1b:	8b 40 28             	mov    0x28(%eax),%eax
80105e1e:	85 c0                	test   %eax,%eax
80105e20:	74 0e                	je     80105e30 <trap+0xa0>
80105e22:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e26:	f7 d0                	not    %eax
80105e28:	a8 03                	test   $0x3,%al
80105e2a:	0f 84 d5 00 00 00    	je     80105f05 <trap+0x175>
    exit();
}
80105e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e33:	5b                   	pop    %ebx
80105e34:	5e                   	pop    %esi
80105e35:	5f                   	pop    %edi
80105e36:	5d                   	pop    %ebp
80105e37:	c3                   	ret
80105e38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e3f:	90                   	nop
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e40:	e8 eb dc ff ff       	call   80103b30 <myproc>
80105e45:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e48:	85 c0                	test   %eax,%eax
80105e4a:	0f 84 c4 01 00 00    	je     80106014 <trap+0x284>
80105e50:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105e54:	0f 84 ba 01 00 00    	je     80106014 <trap+0x284>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e5a:	0f 20 d1             	mov    %cr2,%ecx
80105e5d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e60:	e8 ab dc ff ff       	call   80103b10 <cpuid>
80105e65:	8b 73 30             	mov    0x30(%ebx),%esi
80105e68:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105e6b:	8b 43 34             	mov    0x34(%ebx),%eax
80105e6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105e71:	e8 ba dc ff ff       	call   80103b30 <myproc>
80105e76:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105e79:	e8 b2 dc ff ff       	call   80103b30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e7e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105e81:	51                   	push   %ecx
80105e82:	57                   	push   %edi
80105e83:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e86:	52                   	push   %edx
80105e87:	ff 75 e4             	push   -0x1c(%ebp)
80105e8a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105e8b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105e8e:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e91:	56                   	push   %esi
80105e92:	ff 70 14             	push   0x14(%eax)
80105e95:	68 bc 81 10 80       	push   $0x801081bc
80105e9a:	e8 01 a9 ff ff       	call   801007a0 <cprintf>
    myproc()->killed = 1;
80105e9f:	83 c4 20             	add    $0x20,%esp
80105ea2:	e8 89 dc ff ff       	call   80103b30 <myproc>
80105ea7:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eae:	e8 7d dc ff ff       	call   80103b30 <myproc>
80105eb3:	85 c0                	test   %eax,%eax
80105eb5:	0f 85 20 ff ff ff    	jne    80105ddb <trap+0x4b>
80105ebb:	e9 35 ff ff ff       	jmp    80105df5 <trap+0x65>
  if(myproc() && myproc()->state == RUNNING &&
80105ec0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105ec4:	0f 85 43 ff ff ff    	jne    80105e0d <trap+0x7d>
    yield();
80105eca:	e8 41 e3 ff ff       	call   80104210 <yield>
80105ecf:	e9 39 ff ff ff       	jmp    80105e0d <trap+0x7d>
80105ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105ed8:	e8 53 dc ff ff       	call   80103b30 <myproc>
80105edd:	8b 70 28             	mov    0x28(%eax),%esi
80105ee0:	85 f6                	test   %esi,%esi
80105ee2:	0f 85 e8 00 00 00    	jne    80105fd0 <trap+0x240>
    myproc()->tf = tf;
80105ee8:	e8 43 dc ff ff       	call   80103b30 <myproc>
80105eed:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80105ef0:	e8 fb ef ff ff       	call   80104ef0 <syscall>
    if(myproc()->killed)
80105ef5:	e8 36 dc ff ff       	call   80103b30 <myproc>
80105efa:	8b 48 28             	mov    0x28(%eax),%ecx
80105efd:	85 c9                	test   %ecx,%ecx
80105eff:	0f 84 2b ff ff ff    	je     80105e30 <trap+0xa0>
}
80105f05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f08:	5b                   	pop    %ebx
80105f09:	5e                   	pop    %esi
80105f0a:	5f                   	pop    %edi
80105f0b:	5d                   	pop    %ebp
      exit();
80105f0c:	e9 9f e0 ff ff       	jmp    80103fb0 <exit>
80105f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f18:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f1b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105f1f:	e8 ec db ff ff       	call   80103b10 <cpuid>
80105f24:	57                   	push   %edi
80105f25:	56                   	push   %esi
80105f26:	50                   	push   %eax
80105f27:	68 64 81 10 80       	push   $0x80108164
80105f2c:	e8 6f a8 ff ff       	call   801007a0 <cprintf>
    lapiceoi();
80105f31:	e8 9a cb ff ff       	call   80102ad0 <lapiceoi>
    break;
80105f36:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f39:	e8 f2 db ff ff       	call   80103b30 <myproc>
80105f3e:	85 c0                	test   %eax,%eax
80105f40:	0f 85 95 fe ff ff    	jne    80105ddb <trap+0x4b>
80105f46:	e9 aa fe ff ff       	jmp    80105df5 <trap+0x65>
80105f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f4f:	90                   	nop
    kbdintr();
80105f50:	e8 4b ca ff ff       	call   801029a0 <kbdintr>
    lapiceoi();
80105f55:	e8 76 cb ff ff       	call   80102ad0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f5a:	e8 d1 db ff ff       	call   80103b30 <myproc>
80105f5f:	85 c0                	test   %eax,%eax
80105f61:	0f 85 74 fe ff ff    	jne    80105ddb <trap+0x4b>
80105f67:	e9 89 fe ff ff       	jmp    80105df5 <trap+0x65>
80105f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105f70:	e8 4b 02 00 00       	call   801061c0 <uartintr>
    lapiceoi();
80105f75:	e8 56 cb ff ff       	call   80102ad0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f7a:	e8 b1 db ff ff       	call   80103b30 <myproc>
80105f7f:	85 c0                	test   %eax,%eax
80105f81:	0f 85 54 fe ff ff    	jne    80105ddb <trap+0x4b>
80105f87:	e9 69 fe ff ff       	jmp    80105df5 <trap+0x65>
80105f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105f90:	e8 8b c3 ff ff       	call   80102320 <ideintr>
80105f95:	e9 33 fe ff ff       	jmp    80105dcd <trap+0x3d>
80105f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    handle_page_fault();
80105fa0:	e8 3b 19 00 00       	call   801078e0 <handle_page_fault>
    lapiceoi();
80105fa5:	e8 26 cb ff ff       	call   80102ad0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105faa:	e8 81 db ff ff       	call   80103b30 <myproc>
80105faf:	85 c0                	test   %eax,%eax
80105fb1:	0f 85 24 fe ff ff    	jne    80105ddb <trap+0x4b>
80105fb7:	e9 39 fe ff ff       	jmp    80105df5 <trap+0x65>
80105fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105fc0:	e8 eb df ff ff       	call   80103fb0 <exit>
80105fc5:	e9 2b fe ff ff       	jmp    80105df5 <trap+0x65>
80105fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105fd0:	e8 db df ff ff       	call   80103fb0 <exit>
80105fd5:	e9 0e ff ff ff       	jmp    80105ee8 <trap+0x158>
80105fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105fe0:	83 ec 0c             	sub    $0xc,%esp
80105fe3:	68 e0 58 11 80       	push   $0x801158e0
80105fe8:	e8 13 ea ff ff       	call   80104a00 <acquire>
      ticks++;
80105fed:	83 05 c0 58 11 80 01 	addl   $0x1,0x801158c0
      wakeup(&ticks);
80105ff4:	c7 04 24 c0 58 11 80 	movl   $0x801158c0,(%esp)
80105ffb:	e8 20 e3 ff ff       	call   80104320 <wakeup>
      release(&tickslock);
80106000:	c7 04 24 e0 58 11 80 	movl   $0x801158e0,(%esp)
80106007:	e8 94 e9 ff ff       	call   801049a0 <release>
8010600c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010600f:	e9 b9 fd ff ff       	jmp    80105dcd <trap+0x3d>
80106014:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106017:	e8 f4 da ff ff       	call   80103b10 <cpuid>
8010601c:	83 ec 0c             	sub    $0xc,%esp
8010601f:	56                   	push   %esi
80106020:	57                   	push   %edi
80106021:	50                   	push   %eax
80106022:	ff 73 30             	push   0x30(%ebx)
80106025:	68 88 81 10 80       	push   $0x80108188
8010602a:	e8 71 a7 ff ff       	call   801007a0 <cprintf>
      panic("trap");
8010602f:	83 c4 14             	add    $0x14,%esp
80106032:	68 8a 7e 10 80       	push   $0x80107e8a
80106037:	e8 34 a4 ff ff       	call   80100470 <panic>
8010603c:	66 90                	xchg   %ax,%ax
8010603e:	66 90                	xchg   %ax,%ax

80106040 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106040:	a1 20 61 11 80       	mov    0x80116120,%eax
80106045:	85 c0                	test   %eax,%eax
80106047:	74 17                	je     80106060 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106049:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010604e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010604f:	a8 01                	test   $0x1,%al
80106051:	74 0d                	je     80106060 <uartgetc+0x20>
80106053:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106058:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106059:	0f b6 c0             	movzbl %al,%eax
8010605c:	c3                   	ret
8010605d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106065:	c3                   	ret
80106066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010606d:	8d 76 00             	lea    0x0(%esi),%esi

80106070 <uartinit>:
{
80106070:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106071:	31 c9                	xor    %ecx,%ecx
80106073:	89 c8                	mov    %ecx,%eax
80106075:	89 e5                	mov    %esp,%ebp
80106077:	57                   	push   %edi
80106078:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010607d:	56                   	push   %esi
8010607e:	89 fa                	mov    %edi,%edx
80106080:	53                   	push   %ebx
80106081:	83 ec 1c             	sub    $0x1c,%esp
80106084:	ee                   	out    %al,(%dx)
80106085:	be fb 03 00 00       	mov    $0x3fb,%esi
8010608a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010608f:	89 f2                	mov    %esi,%edx
80106091:	ee                   	out    %al,(%dx)
80106092:	b8 0c 00 00 00       	mov    $0xc,%eax
80106097:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010609c:	ee                   	out    %al,(%dx)
8010609d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801060a2:	89 c8                	mov    %ecx,%eax
801060a4:	89 da                	mov    %ebx,%edx
801060a6:	ee                   	out    %al,(%dx)
801060a7:	b8 03 00 00 00       	mov    $0x3,%eax
801060ac:	89 f2                	mov    %esi,%edx
801060ae:	ee                   	out    %al,(%dx)
801060af:	ba fc 03 00 00       	mov    $0x3fc,%edx
801060b4:	89 c8                	mov    %ecx,%eax
801060b6:	ee                   	out    %al,(%dx)
801060b7:	b8 01 00 00 00       	mov    $0x1,%eax
801060bc:	89 da                	mov    %ebx,%edx
801060be:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060bf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060c4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801060c5:	3c ff                	cmp    $0xff,%al
801060c7:	0f 84 7c 00 00 00    	je     80106149 <uartinit+0xd9>
  uart = 1;
801060cd:	c7 05 20 61 11 80 01 	movl   $0x1,0x80116120
801060d4:	00 00 00 
801060d7:	89 fa                	mov    %edi,%edx
801060d9:	ec                   	in     (%dx),%al
801060da:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060df:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801060e0:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801060e3:	bf 8f 7e 10 80       	mov    $0x80107e8f,%edi
801060e8:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801060ed:	6a 00                	push   $0x0
801060ef:	6a 04                	push   $0x4
801060f1:	e8 5a c4 ff ff       	call   80102550 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801060f6:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
801060fa:	83 c4 10             	add    $0x10,%esp
801060fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80106100:	a1 20 61 11 80       	mov    0x80116120,%eax
80106105:	85 c0                	test   %eax,%eax
80106107:	74 32                	je     8010613b <uartinit+0xcb>
80106109:	89 f2                	mov    %esi,%edx
8010610b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010610c:	a8 20                	test   $0x20,%al
8010610e:	75 21                	jne    80106131 <uartinit+0xc1>
80106110:	bb 80 00 00 00       	mov    $0x80,%ebx
80106115:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80106118:	83 ec 0c             	sub    $0xc,%esp
8010611b:	6a 0a                	push   $0xa
8010611d:	e8 ce c9 ff ff       	call   80102af0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106122:	83 c4 10             	add    $0x10,%esp
80106125:	83 eb 01             	sub    $0x1,%ebx
80106128:	74 07                	je     80106131 <uartinit+0xc1>
8010612a:	89 f2                	mov    %esi,%edx
8010612c:	ec                   	in     (%dx),%al
8010612d:	a8 20                	test   $0x20,%al
8010612f:	74 e7                	je     80106118 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106131:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106136:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010613a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010613b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
8010613f:	83 c7 01             	add    $0x1,%edi
80106142:	88 45 e7             	mov    %al,-0x19(%ebp)
80106145:	84 c0                	test   %al,%al
80106147:	75 b7                	jne    80106100 <uartinit+0x90>
}
80106149:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010614c:	5b                   	pop    %ebx
8010614d:	5e                   	pop    %esi
8010614e:	5f                   	pop    %edi
8010614f:	5d                   	pop    %ebp
80106150:	c3                   	ret
80106151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010615f:	90                   	nop

80106160 <uartputc>:
  if(!uart)
80106160:	a1 20 61 11 80       	mov    0x80116120,%eax
80106165:	85 c0                	test   %eax,%eax
80106167:	74 4f                	je     801061b8 <uartputc+0x58>
{
80106169:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010616a:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010616f:	89 e5                	mov    %esp,%ebp
80106171:	56                   	push   %esi
80106172:	53                   	push   %ebx
80106173:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106174:	a8 20                	test   $0x20,%al
80106176:	75 29                	jne    801061a1 <uartputc+0x41>
80106178:	bb 80 00 00 00       	mov    $0x80,%ebx
8010617d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106188:	83 ec 0c             	sub    $0xc,%esp
8010618b:	6a 0a                	push   $0xa
8010618d:	e8 5e c9 ff ff       	call   80102af0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106192:	83 c4 10             	add    $0x10,%esp
80106195:	83 eb 01             	sub    $0x1,%ebx
80106198:	74 07                	je     801061a1 <uartputc+0x41>
8010619a:	89 f2                	mov    %esi,%edx
8010619c:	ec                   	in     (%dx),%al
8010619d:	a8 20                	test   $0x20,%al
8010619f:	74 e7                	je     80106188 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061a1:	8b 45 08             	mov    0x8(%ebp),%eax
801061a4:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061a9:	ee                   	out    %al,(%dx)
}
801061aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061ad:	5b                   	pop    %ebx
801061ae:	5e                   	pop    %esi
801061af:	5d                   	pop    %ebp
801061b0:	c3                   	ret
801061b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061b8:	c3                   	ret
801061b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061c0 <uartintr>:

void
uartintr(void)
{
801061c0:	55                   	push   %ebp
801061c1:	89 e5                	mov    %esp,%ebp
801061c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801061c6:	68 40 60 10 80       	push   $0x80106040
801061cb:	e8 c0 a7 ff ff       	call   80100990 <consoleintr>
}
801061d0:	83 c4 10             	add    $0x10,%esp
801061d3:	c9                   	leave
801061d4:	c3                   	ret

801061d5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $0
801061d7:	6a 00                	push   $0x0
  jmp alltraps
801061d9:	e9 dc fa ff ff       	jmp    80105cba <alltraps>

801061de <vector1>:
.globl vector1
vector1:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $1
801061e0:	6a 01                	push   $0x1
  jmp alltraps
801061e2:	e9 d3 fa ff ff       	jmp    80105cba <alltraps>

801061e7 <vector2>:
.globl vector2
vector2:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $2
801061e9:	6a 02                	push   $0x2
  jmp alltraps
801061eb:	e9 ca fa ff ff       	jmp    80105cba <alltraps>

801061f0 <vector3>:
.globl vector3
vector3:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $3
801061f2:	6a 03                	push   $0x3
  jmp alltraps
801061f4:	e9 c1 fa ff ff       	jmp    80105cba <alltraps>

801061f9 <vector4>:
.globl vector4
vector4:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $4
801061fb:	6a 04                	push   $0x4
  jmp alltraps
801061fd:	e9 b8 fa ff ff       	jmp    80105cba <alltraps>

80106202 <vector5>:
.globl vector5
vector5:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $5
80106204:	6a 05                	push   $0x5
  jmp alltraps
80106206:	e9 af fa ff ff       	jmp    80105cba <alltraps>

8010620b <vector6>:
.globl vector6
vector6:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $6
8010620d:	6a 06                	push   $0x6
  jmp alltraps
8010620f:	e9 a6 fa ff ff       	jmp    80105cba <alltraps>

80106214 <vector7>:
.globl vector7
vector7:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $7
80106216:	6a 07                	push   $0x7
  jmp alltraps
80106218:	e9 9d fa ff ff       	jmp    80105cba <alltraps>

8010621d <vector8>:
.globl vector8
vector8:
  pushl $8
8010621d:	6a 08                	push   $0x8
  jmp alltraps
8010621f:	e9 96 fa ff ff       	jmp    80105cba <alltraps>

80106224 <vector9>:
.globl vector9
vector9:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $9
80106226:	6a 09                	push   $0x9
  jmp alltraps
80106228:	e9 8d fa ff ff       	jmp    80105cba <alltraps>

8010622d <vector10>:
.globl vector10
vector10:
  pushl $10
8010622d:	6a 0a                	push   $0xa
  jmp alltraps
8010622f:	e9 86 fa ff ff       	jmp    80105cba <alltraps>

80106234 <vector11>:
.globl vector11
vector11:
  pushl $11
80106234:	6a 0b                	push   $0xb
  jmp alltraps
80106236:	e9 7f fa ff ff       	jmp    80105cba <alltraps>

8010623b <vector12>:
.globl vector12
vector12:
  pushl $12
8010623b:	6a 0c                	push   $0xc
  jmp alltraps
8010623d:	e9 78 fa ff ff       	jmp    80105cba <alltraps>

80106242 <vector13>:
.globl vector13
vector13:
  pushl $13
80106242:	6a 0d                	push   $0xd
  jmp alltraps
80106244:	e9 71 fa ff ff       	jmp    80105cba <alltraps>

80106249 <vector14>:
.globl vector14
vector14:
  pushl $14
80106249:	6a 0e                	push   $0xe
  jmp alltraps
8010624b:	e9 6a fa ff ff       	jmp    80105cba <alltraps>

80106250 <vector15>:
.globl vector15
vector15:
  pushl $0
80106250:	6a 00                	push   $0x0
  pushl $15
80106252:	6a 0f                	push   $0xf
  jmp alltraps
80106254:	e9 61 fa ff ff       	jmp    80105cba <alltraps>

80106259 <vector16>:
.globl vector16
vector16:
  pushl $0
80106259:	6a 00                	push   $0x0
  pushl $16
8010625b:	6a 10                	push   $0x10
  jmp alltraps
8010625d:	e9 58 fa ff ff       	jmp    80105cba <alltraps>

80106262 <vector17>:
.globl vector17
vector17:
  pushl $17
80106262:	6a 11                	push   $0x11
  jmp alltraps
80106264:	e9 51 fa ff ff       	jmp    80105cba <alltraps>

80106269 <vector18>:
.globl vector18
vector18:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $18
8010626b:	6a 12                	push   $0x12
  jmp alltraps
8010626d:	e9 48 fa ff ff       	jmp    80105cba <alltraps>

80106272 <vector19>:
.globl vector19
vector19:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $19
80106274:	6a 13                	push   $0x13
  jmp alltraps
80106276:	e9 3f fa ff ff       	jmp    80105cba <alltraps>

8010627b <vector20>:
.globl vector20
vector20:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $20
8010627d:	6a 14                	push   $0x14
  jmp alltraps
8010627f:	e9 36 fa ff ff       	jmp    80105cba <alltraps>

80106284 <vector21>:
.globl vector21
vector21:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $21
80106286:	6a 15                	push   $0x15
  jmp alltraps
80106288:	e9 2d fa ff ff       	jmp    80105cba <alltraps>

8010628d <vector22>:
.globl vector22
vector22:
  pushl $0
8010628d:	6a 00                	push   $0x0
  pushl $22
8010628f:	6a 16                	push   $0x16
  jmp alltraps
80106291:	e9 24 fa ff ff       	jmp    80105cba <alltraps>

80106296 <vector23>:
.globl vector23
vector23:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $23
80106298:	6a 17                	push   $0x17
  jmp alltraps
8010629a:	e9 1b fa ff ff       	jmp    80105cba <alltraps>

8010629f <vector24>:
.globl vector24
vector24:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $24
801062a1:	6a 18                	push   $0x18
  jmp alltraps
801062a3:	e9 12 fa ff ff       	jmp    80105cba <alltraps>

801062a8 <vector25>:
.globl vector25
vector25:
  pushl $0
801062a8:	6a 00                	push   $0x0
  pushl $25
801062aa:	6a 19                	push   $0x19
  jmp alltraps
801062ac:	e9 09 fa ff ff       	jmp    80105cba <alltraps>

801062b1 <vector26>:
.globl vector26
vector26:
  pushl $0
801062b1:	6a 00                	push   $0x0
  pushl $26
801062b3:	6a 1a                	push   $0x1a
  jmp alltraps
801062b5:	e9 00 fa ff ff       	jmp    80105cba <alltraps>

801062ba <vector27>:
.globl vector27
vector27:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $27
801062bc:	6a 1b                	push   $0x1b
  jmp alltraps
801062be:	e9 f7 f9 ff ff       	jmp    80105cba <alltraps>

801062c3 <vector28>:
.globl vector28
vector28:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $28
801062c5:	6a 1c                	push   $0x1c
  jmp alltraps
801062c7:	e9 ee f9 ff ff       	jmp    80105cba <alltraps>

801062cc <vector29>:
.globl vector29
vector29:
  pushl $0
801062cc:	6a 00                	push   $0x0
  pushl $29
801062ce:	6a 1d                	push   $0x1d
  jmp alltraps
801062d0:	e9 e5 f9 ff ff       	jmp    80105cba <alltraps>

801062d5 <vector30>:
.globl vector30
vector30:
  pushl $0
801062d5:	6a 00                	push   $0x0
  pushl $30
801062d7:	6a 1e                	push   $0x1e
  jmp alltraps
801062d9:	e9 dc f9 ff ff       	jmp    80105cba <alltraps>

801062de <vector31>:
.globl vector31
vector31:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $31
801062e0:	6a 1f                	push   $0x1f
  jmp alltraps
801062e2:	e9 d3 f9 ff ff       	jmp    80105cba <alltraps>

801062e7 <vector32>:
.globl vector32
vector32:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $32
801062e9:	6a 20                	push   $0x20
  jmp alltraps
801062eb:	e9 ca f9 ff ff       	jmp    80105cba <alltraps>

801062f0 <vector33>:
.globl vector33
vector33:
  pushl $0
801062f0:	6a 00                	push   $0x0
  pushl $33
801062f2:	6a 21                	push   $0x21
  jmp alltraps
801062f4:	e9 c1 f9 ff ff       	jmp    80105cba <alltraps>

801062f9 <vector34>:
.globl vector34
vector34:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $34
801062fb:	6a 22                	push   $0x22
  jmp alltraps
801062fd:	e9 b8 f9 ff ff       	jmp    80105cba <alltraps>

80106302 <vector35>:
.globl vector35
vector35:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $35
80106304:	6a 23                	push   $0x23
  jmp alltraps
80106306:	e9 af f9 ff ff       	jmp    80105cba <alltraps>

8010630b <vector36>:
.globl vector36
vector36:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $36
8010630d:	6a 24                	push   $0x24
  jmp alltraps
8010630f:	e9 a6 f9 ff ff       	jmp    80105cba <alltraps>

80106314 <vector37>:
.globl vector37
vector37:
  pushl $0
80106314:	6a 00                	push   $0x0
  pushl $37
80106316:	6a 25                	push   $0x25
  jmp alltraps
80106318:	e9 9d f9 ff ff       	jmp    80105cba <alltraps>

8010631d <vector38>:
.globl vector38
vector38:
  pushl $0
8010631d:	6a 00                	push   $0x0
  pushl $38
8010631f:	6a 26                	push   $0x26
  jmp alltraps
80106321:	e9 94 f9 ff ff       	jmp    80105cba <alltraps>

80106326 <vector39>:
.globl vector39
vector39:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $39
80106328:	6a 27                	push   $0x27
  jmp alltraps
8010632a:	e9 8b f9 ff ff       	jmp    80105cba <alltraps>

8010632f <vector40>:
.globl vector40
vector40:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $40
80106331:	6a 28                	push   $0x28
  jmp alltraps
80106333:	e9 82 f9 ff ff       	jmp    80105cba <alltraps>

80106338 <vector41>:
.globl vector41
vector41:
  pushl $0
80106338:	6a 00                	push   $0x0
  pushl $41
8010633a:	6a 29                	push   $0x29
  jmp alltraps
8010633c:	e9 79 f9 ff ff       	jmp    80105cba <alltraps>

80106341 <vector42>:
.globl vector42
vector42:
  pushl $0
80106341:	6a 00                	push   $0x0
  pushl $42
80106343:	6a 2a                	push   $0x2a
  jmp alltraps
80106345:	e9 70 f9 ff ff       	jmp    80105cba <alltraps>

8010634a <vector43>:
.globl vector43
vector43:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $43
8010634c:	6a 2b                	push   $0x2b
  jmp alltraps
8010634e:	e9 67 f9 ff ff       	jmp    80105cba <alltraps>

80106353 <vector44>:
.globl vector44
vector44:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $44
80106355:	6a 2c                	push   $0x2c
  jmp alltraps
80106357:	e9 5e f9 ff ff       	jmp    80105cba <alltraps>

8010635c <vector45>:
.globl vector45
vector45:
  pushl $0
8010635c:	6a 00                	push   $0x0
  pushl $45
8010635e:	6a 2d                	push   $0x2d
  jmp alltraps
80106360:	e9 55 f9 ff ff       	jmp    80105cba <alltraps>

80106365 <vector46>:
.globl vector46
vector46:
  pushl $0
80106365:	6a 00                	push   $0x0
  pushl $46
80106367:	6a 2e                	push   $0x2e
  jmp alltraps
80106369:	e9 4c f9 ff ff       	jmp    80105cba <alltraps>

8010636e <vector47>:
.globl vector47
vector47:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $47
80106370:	6a 2f                	push   $0x2f
  jmp alltraps
80106372:	e9 43 f9 ff ff       	jmp    80105cba <alltraps>

80106377 <vector48>:
.globl vector48
vector48:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $48
80106379:	6a 30                	push   $0x30
  jmp alltraps
8010637b:	e9 3a f9 ff ff       	jmp    80105cba <alltraps>

80106380 <vector49>:
.globl vector49
vector49:
  pushl $0
80106380:	6a 00                	push   $0x0
  pushl $49
80106382:	6a 31                	push   $0x31
  jmp alltraps
80106384:	e9 31 f9 ff ff       	jmp    80105cba <alltraps>

80106389 <vector50>:
.globl vector50
vector50:
  pushl $0
80106389:	6a 00                	push   $0x0
  pushl $50
8010638b:	6a 32                	push   $0x32
  jmp alltraps
8010638d:	e9 28 f9 ff ff       	jmp    80105cba <alltraps>

80106392 <vector51>:
.globl vector51
vector51:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $51
80106394:	6a 33                	push   $0x33
  jmp alltraps
80106396:	e9 1f f9 ff ff       	jmp    80105cba <alltraps>

8010639b <vector52>:
.globl vector52
vector52:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $52
8010639d:	6a 34                	push   $0x34
  jmp alltraps
8010639f:	e9 16 f9 ff ff       	jmp    80105cba <alltraps>

801063a4 <vector53>:
.globl vector53
vector53:
  pushl $0
801063a4:	6a 00                	push   $0x0
  pushl $53
801063a6:	6a 35                	push   $0x35
  jmp alltraps
801063a8:	e9 0d f9 ff ff       	jmp    80105cba <alltraps>

801063ad <vector54>:
.globl vector54
vector54:
  pushl $0
801063ad:	6a 00                	push   $0x0
  pushl $54
801063af:	6a 36                	push   $0x36
  jmp alltraps
801063b1:	e9 04 f9 ff ff       	jmp    80105cba <alltraps>

801063b6 <vector55>:
.globl vector55
vector55:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $55
801063b8:	6a 37                	push   $0x37
  jmp alltraps
801063ba:	e9 fb f8 ff ff       	jmp    80105cba <alltraps>

801063bf <vector56>:
.globl vector56
vector56:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $56
801063c1:	6a 38                	push   $0x38
  jmp alltraps
801063c3:	e9 f2 f8 ff ff       	jmp    80105cba <alltraps>

801063c8 <vector57>:
.globl vector57
vector57:
  pushl $0
801063c8:	6a 00                	push   $0x0
  pushl $57
801063ca:	6a 39                	push   $0x39
  jmp alltraps
801063cc:	e9 e9 f8 ff ff       	jmp    80105cba <alltraps>

801063d1 <vector58>:
.globl vector58
vector58:
  pushl $0
801063d1:	6a 00                	push   $0x0
  pushl $58
801063d3:	6a 3a                	push   $0x3a
  jmp alltraps
801063d5:	e9 e0 f8 ff ff       	jmp    80105cba <alltraps>

801063da <vector59>:
.globl vector59
vector59:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $59
801063dc:	6a 3b                	push   $0x3b
  jmp alltraps
801063de:	e9 d7 f8 ff ff       	jmp    80105cba <alltraps>

801063e3 <vector60>:
.globl vector60
vector60:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $60
801063e5:	6a 3c                	push   $0x3c
  jmp alltraps
801063e7:	e9 ce f8 ff ff       	jmp    80105cba <alltraps>

801063ec <vector61>:
.globl vector61
vector61:
  pushl $0
801063ec:	6a 00                	push   $0x0
  pushl $61
801063ee:	6a 3d                	push   $0x3d
  jmp alltraps
801063f0:	e9 c5 f8 ff ff       	jmp    80105cba <alltraps>

801063f5 <vector62>:
.globl vector62
vector62:
  pushl $0
801063f5:	6a 00                	push   $0x0
  pushl $62
801063f7:	6a 3e                	push   $0x3e
  jmp alltraps
801063f9:	e9 bc f8 ff ff       	jmp    80105cba <alltraps>

801063fe <vector63>:
.globl vector63
vector63:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $63
80106400:	6a 3f                	push   $0x3f
  jmp alltraps
80106402:	e9 b3 f8 ff ff       	jmp    80105cba <alltraps>

80106407 <vector64>:
.globl vector64
vector64:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $64
80106409:	6a 40                	push   $0x40
  jmp alltraps
8010640b:	e9 aa f8 ff ff       	jmp    80105cba <alltraps>

80106410 <vector65>:
.globl vector65
vector65:
  pushl $0
80106410:	6a 00                	push   $0x0
  pushl $65
80106412:	6a 41                	push   $0x41
  jmp alltraps
80106414:	e9 a1 f8 ff ff       	jmp    80105cba <alltraps>

80106419 <vector66>:
.globl vector66
vector66:
  pushl $0
80106419:	6a 00                	push   $0x0
  pushl $66
8010641b:	6a 42                	push   $0x42
  jmp alltraps
8010641d:	e9 98 f8 ff ff       	jmp    80105cba <alltraps>

80106422 <vector67>:
.globl vector67
vector67:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $67
80106424:	6a 43                	push   $0x43
  jmp alltraps
80106426:	e9 8f f8 ff ff       	jmp    80105cba <alltraps>

8010642b <vector68>:
.globl vector68
vector68:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $68
8010642d:	6a 44                	push   $0x44
  jmp alltraps
8010642f:	e9 86 f8 ff ff       	jmp    80105cba <alltraps>

80106434 <vector69>:
.globl vector69
vector69:
  pushl $0
80106434:	6a 00                	push   $0x0
  pushl $69
80106436:	6a 45                	push   $0x45
  jmp alltraps
80106438:	e9 7d f8 ff ff       	jmp    80105cba <alltraps>

8010643d <vector70>:
.globl vector70
vector70:
  pushl $0
8010643d:	6a 00                	push   $0x0
  pushl $70
8010643f:	6a 46                	push   $0x46
  jmp alltraps
80106441:	e9 74 f8 ff ff       	jmp    80105cba <alltraps>

80106446 <vector71>:
.globl vector71
vector71:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $71
80106448:	6a 47                	push   $0x47
  jmp alltraps
8010644a:	e9 6b f8 ff ff       	jmp    80105cba <alltraps>

8010644f <vector72>:
.globl vector72
vector72:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $72
80106451:	6a 48                	push   $0x48
  jmp alltraps
80106453:	e9 62 f8 ff ff       	jmp    80105cba <alltraps>

80106458 <vector73>:
.globl vector73
vector73:
  pushl $0
80106458:	6a 00                	push   $0x0
  pushl $73
8010645a:	6a 49                	push   $0x49
  jmp alltraps
8010645c:	e9 59 f8 ff ff       	jmp    80105cba <alltraps>

80106461 <vector74>:
.globl vector74
vector74:
  pushl $0
80106461:	6a 00                	push   $0x0
  pushl $74
80106463:	6a 4a                	push   $0x4a
  jmp alltraps
80106465:	e9 50 f8 ff ff       	jmp    80105cba <alltraps>

8010646a <vector75>:
.globl vector75
vector75:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $75
8010646c:	6a 4b                	push   $0x4b
  jmp alltraps
8010646e:	e9 47 f8 ff ff       	jmp    80105cba <alltraps>

80106473 <vector76>:
.globl vector76
vector76:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $76
80106475:	6a 4c                	push   $0x4c
  jmp alltraps
80106477:	e9 3e f8 ff ff       	jmp    80105cba <alltraps>

8010647c <vector77>:
.globl vector77
vector77:
  pushl $0
8010647c:	6a 00                	push   $0x0
  pushl $77
8010647e:	6a 4d                	push   $0x4d
  jmp alltraps
80106480:	e9 35 f8 ff ff       	jmp    80105cba <alltraps>

80106485 <vector78>:
.globl vector78
vector78:
  pushl $0
80106485:	6a 00                	push   $0x0
  pushl $78
80106487:	6a 4e                	push   $0x4e
  jmp alltraps
80106489:	e9 2c f8 ff ff       	jmp    80105cba <alltraps>

8010648e <vector79>:
.globl vector79
vector79:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $79
80106490:	6a 4f                	push   $0x4f
  jmp alltraps
80106492:	e9 23 f8 ff ff       	jmp    80105cba <alltraps>

80106497 <vector80>:
.globl vector80
vector80:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $80
80106499:	6a 50                	push   $0x50
  jmp alltraps
8010649b:	e9 1a f8 ff ff       	jmp    80105cba <alltraps>

801064a0 <vector81>:
.globl vector81
vector81:
  pushl $0
801064a0:	6a 00                	push   $0x0
  pushl $81
801064a2:	6a 51                	push   $0x51
  jmp alltraps
801064a4:	e9 11 f8 ff ff       	jmp    80105cba <alltraps>

801064a9 <vector82>:
.globl vector82
vector82:
  pushl $0
801064a9:	6a 00                	push   $0x0
  pushl $82
801064ab:	6a 52                	push   $0x52
  jmp alltraps
801064ad:	e9 08 f8 ff ff       	jmp    80105cba <alltraps>

801064b2 <vector83>:
.globl vector83
vector83:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $83
801064b4:	6a 53                	push   $0x53
  jmp alltraps
801064b6:	e9 ff f7 ff ff       	jmp    80105cba <alltraps>

801064bb <vector84>:
.globl vector84
vector84:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $84
801064bd:	6a 54                	push   $0x54
  jmp alltraps
801064bf:	e9 f6 f7 ff ff       	jmp    80105cba <alltraps>

801064c4 <vector85>:
.globl vector85
vector85:
  pushl $0
801064c4:	6a 00                	push   $0x0
  pushl $85
801064c6:	6a 55                	push   $0x55
  jmp alltraps
801064c8:	e9 ed f7 ff ff       	jmp    80105cba <alltraps>

801064cd <vector86>:
.globl vector86
vector86:
  pushl $0
801064cd:	6a 00                	push   $0x0
  pushl $86
801064cf:	6a 56                	push   $0x56
  jmp alltraps
801064d1:	e9 e4 f7 ff ff       	jmp    80105cba <alltraps>

801064d6 <vector87>:
.globl vector87
vector87:
  pushl $0
801064d6:	6a 00                	push   $0x0
  pushl $87
801064d8:	6a 57                	push   $0x57
  jmp alltraps
801064da:	e9 db f7 ff ff       	jmp    80105cba <alltraps>

801064df <vector88>:
.globl vector88
vector88:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $88
801064e1:	6a 58                	push   $0x58
  jmp alltraps
801064e3:	e9 d2 f7 ff ff       	jmp    80105cba <alltraps>

801064e8 <vector89>:
.globl vector89
vector89:
  pushl $0
801064e8:	6a 00                	push   $0x0
  pushl $89
801064ea:	6a 59                	push   $0x59
  jmp alltraps
801064ec:	e9 c9 f7 ff ff       	jmp    80105cba <alltraps>

801064f1 <vector90>:
.globl vector90
vector90:
  pushl $0
801064f1:	6a 00                	push   $0x0
  pushl $90
801064f3:	6a 5a                	push   $0x5a
  jmp alltraps
801064f5:	e9 c0 f7 ff ff       	jmp    80105cba <alltraps>

801064fa <vector91>:
.globl vector91
vector91:
  pushl $0
801064fa:	6a 00                	push   $0x0
  pushl $91
801064fc:	6a 5b                	push   $0x5b
  jmp alltraps
801064fe:	e9 b7 f7 ff ff       	jmp    80105cba <alltraps>

80106503 <vector92>:
.globl vector92
vector92:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $92
80106505:	6a 5c                	push   $0x5c
  jmp alltraps
80106507:	e9 ae f7 ff ff       	jmp    80105cba <alltraps>

8010650c <vector93>:
.globl vector93
vector93:
  pushl $0
8010650c:	6a 00                	push   $0x0
  pushl $93
8010650e:	6a 5d                	push   $0x5d
  jmp alltraps
80106510:	e9 a5 f7 ff ff       	jmp    80105cba <alltraps>

80106515 <vector94>:
.globl vector94
vector94:
  pushl $0
80106515:	6a 00                	push   $0x0
  pushl $94
80106517:	6a 5e                	push   $0x5e
  jmp alltraps
80106519:	e9 9c f7 ff ff       	jmp    80105cba <alltraps>

8010651e <vector95>:
.globl vector95
vector95:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $95
80106520:	6a 5f                	push   $0x5f
  jmp alltraps
80106522:	e9 93 f7 ff ff       	jmp    80105cba <alltraps>

80106527 <vector96>:
.globl vector96
vector96:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $96
80106529:	6a 60                	push   $0x60
  jmp alltraps
8010652b:	e9 8a f7 ff ff       	jmp    80105cba <alltraps>

80106530 <vector97>:
.globl vector97
vector97:
  pushl $0
80106530:	6a 00                	push   $0x0
  pushl $97
80106532:	6a 61                	push   $0x61
  jmp alltraps
80106534:	e9 81 f7 ff ff       	jmp    80105cba <alltraps>

80106539 <vector98>:
.globl vector98
vector98:
  pushl $0
80106539:	6a 00                	push   $0x0
  pushl $98
8010653b:	6a 62                	push   $0x62
  jmp alltraps
8010653d:	e9 78 f7 ff ff       	jmp    80105cba <alltraps>

80106542 <vector99>:
.globl vector99
vector99:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $99
80106544:	6a 63                	push   $0x63
  jmp alltraps
80106546:	e9 6f f7 ff ff       	jmp    80105cba <alltraps>

8010654b <vector100>:
.globl vector100
vector100:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $100
8010654d:	6a 64                	push   $0x64
  jmp alltraps
8010654f:	e9 66 f7 ff ff       	jmp    80105cba <alltraps>

80106554 <vector101>:
.globl vector101
vector101:
  pushl $0
80106554:	6a 00                	push   $0x0
  pushl $101
80106556:	6a 65                	push   $0x65
  jmp alltraps
80106558:	e9 5d f7 ff ff       	jmp    80105cba <alltraps>

8010655d <vector102>:
.globl vector102
vector102:
  pushl $0
8010655d:	6a 00                	push   $0x0
  pushl $102
8010655f:	6a 66                	push   $0x66
  jmp alltraps
80106561:	e9 54 f7 ff ff       	jmp    80105cba <alltraps>

80106566 <vector103>:
.globl vector103
vector103:
  pushl $0
80106566:	6a 00                	push   $0x0
  pushl $103
80106568:	6a 67                	push   $0x67
  jmp alltraps
8010656a:	e9 4b f7 ff ff       	jmp    80105cba <alltraps>

8010656f <vector104>:
.globl vector104
vector104:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $104
80106571:	6a 68                	push   $0x68
  jmp alltraps
80106573:	e9 42 f7 ff ff       	jmp    80105cba <alltraps>

80106578 <vector105>:
.globl vector105
vector105:
  pushl $0
80106578:	6a 00                	push   $0x0
  pushl $105
8010657a:	6a 69                	push   $0x69
  jmp alltraps
8010657c:	e9 39 f7 ff ff       	jmp    80105cba <alltraps>

80106581 <vector106>:
.globl vector106
vector106:
  pushl $0
80106581:	6a 00                	push   $0x0
  pushl $106
80106583:	6a 6a                	push   $0x6a
  jmp alltraps
80106585:	e9 30 f7 ff ff       	jmp    80105cba <alltraps>

8010658a <vector107>:
.globl vector107
vector107:
  pushl $0
8010658a:	6a 00                	push   $0x0
  pushl $107
8010658c:	6a 6b                	push   $0x6b
  jmp alltraps
8010658e:	e9 27 f7 ff ff       	jmp    80105cba <alltraps>

80106593 <vector108>:
.globl vector108
vector108:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $108
80106595:	6a 6c                	push   $0x6c
  jmp alltraps
80106597:	e9 1e f7 ff ff       	jmp    80105cba <alltraps>

8010659c <vector109>:
.globl vector109
vector109:
  pushl $0
8010659c:	6a 00                	push   $0x0
  pushl $109
8010659e:	6a 6d                	push   $0x6d
  jmp alltraps
801065a0:	e9 15 f7 ff ff       	jmp    80105cba <alltraps>

801065a5 <vector110>:
.globl vector110
vector110:
  pushl $0
801065a5:	6a 00                	push   $0x0
  pushl $110
801065a7:	6a 6e                	push   $0x6e
  jmp alltraps
801065a9:	e9 0c f7 ff ff       	jmp    80105cba <alltraps>

801065ae <vector111>:
.globl vector111
vector111:
  pushl $0
801065ae:	6a 00                	push   $0x0
  pushl $111
801065b0:	6a 6f                	push   $0x6f
  jmp alltraps
801065b2:	e9 03 f7 ff ff       	jmp    80105cba <alltraps>

801065b7 <vector112>:
.globl vector112
vector112:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $112
801065b9:	6a 70                	push   $0x70
  jmp alltraps
801065bb:	e9 fa f6 ff ff       	jmp    80105cba <alltraps>

801065c0 <vector113>:
.globl vector113
vector113:
  pushl $0
801065c0:	6a 00                	push   $0x0
  pushl $113
801065c2:	6a 71                	push   $0x71
  jmp alltraps
801065c4:	e9 f1 f6 ff ff       	jmp    80105cba <alltraps>

801065c9 <vector114>:
.globl vector114
vector114:
  pushl $0
801065c9:	6a 00                	push   $0x0
  pushl $114
801065cb:	6a 72                	push   $0x72
  jmp alltraps
801065cd:	e9 e8 f6 ff ff       	jmp    80105cba <alltraps>

801065d2 <vector115>:
.globl vector115
vector115:
  pushl $0
801065d2:	6a 00                	push   $0x0
  pushl $115
801065d4:	6a 73                	push   $0x73
  jmp alltraps
801065d6:	e9 df f6 ff ff       	jmp    80105cba <alltraps>

801065db <vector116>:
.globl vector116
vector116:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $116
801065dd:	6a 74                	push   $0x74
  jmp alltraps
801065df:	e9 d6 f6 ff ff       	jmp    80105cba <alltraps>

801065e4 <vector117>:
.globl vector117
vector117:
  pushl $0
801065e4:	6a 00                	push   $0x0
  pushl $117
801065e6:	6a 75                	push   $0x75
  jmp alltraps
801065e8:	e9 cd f6 ff ff       	jmp    80105cba <alltraps>

801065ed <vector118>:
.globl vector118
vector118:
  pushl $0
801065ed:	6a 00                	push   $0x0
  pushl $118
801065ef:	6a 76                	push   $0x76
  jmp alltraps
801065f1:	e9 c4 f6 ff ff       	jmp    80105cba <alltraps>

801065f6 <vector119>:
.globl vector119
vector119:
  pushl $0
801065f6:	6a 00                	push   $0x0
  pushl $119
801065f8:	6a 77                	push   $0x77
  jmp alltraps
801065fa:	e9 bb f6 ff ff       	jmp    80105cba <alltraps>

801065ff <vector120>:
.globl vector120
vector120:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $120
80106601:	6a 78                	push   $0x78
  jmp alltraps
80106603:	e9 b2 f6 ff ff       	jmp    80105cba <alltraps>

80106608 <vector121>:
.globl vector121
vector121:
  pushl $0
80106608:	6a 00                	push   $0x0
  pushl $121
8010660a:	6a 79                	push   $0x79
  jmp alltraps
8010660c:	e9 a9 f6 ff ff       	jmp    80105cba <alltraps>

80106611 <vector122>:
.globl vector122
vector122:
  pushl $0
80106611:	6a 00                	push   $0x0
  pushl $122
80106613:	6a 7a                	push   $0x7a
  jmp alltraps
80106615:	e9 a0 f6 ff ff       	jmp    80105cba <alltraps>

8010661a <vector123>:
.globl vector123
vector123:
  pushl $0
8010661a:	6a 00                	push   $0x0
  pushl $123
8010661c:	6a 7b                	push   $0x7b
  jmp alltraps
8010661e:	e9 97 f6 ff ff       	jmp    80105cba <alltraps>

80106623 <vector124>:
.globl vector124
vector124:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $124
80106625:	6a 7c                	push   $0x7c
  jmp alltraps
80106627:	e9 8e f6 ff ff       	jmp    80105cba <alltraps>

8010662c <vector125>:
.globl vector125
vector125:
  pushl $0
8010662c:	6a 00                	push   $0x0
  pushl $125
8010662e:	6a 7d                	push   $0x7d
  jmp alltraps
80106630:	e9 85 f6 ff ff       	jmp    80105cba <alltraps>

80106635 <vector126>:
.globl vector126
vector126:
  pushl $0
80106635:	6a 00                	push   $0x0
  pushl $126
80106637:	6a 7e                	push   $0x7e
  jmp alltraps
80106639:	e9 7c f6 ff ff       	jmp    80105cba <alltraps>

8010663e <vector127>:
.globl vector127
vector127:
  pushl $0
8010663e:	6a 00                	push   $0x0
  pushl $127
80106640:	6a 7f                	push   $0x7f
  jmp alltraps
80106642:	e9 73 f6 ff ff       	jmp    80105cba <alltraps>

80106647 <vector128>:
.globl vector128
vector128:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $128
80106649:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010664e:	e9 67 f6 ff ff       	jmp    80105cba <alltraps>

80106653 <vector129>:
.globl vector129
vector129:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $129
80106655:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010665a:	e9 5b f6 ff ff       	jmp    80105cba <alltraps>

8010665f <vector130>:
.globl vector130
vector130:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $130
80106661:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106666:	e9 4f f6 ff ff       	jmp    80105cba <alltraps>

8010666b <vector131>:
.globl vector131
vector131:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $131
8010666d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106672:	e9 43 f6 ff ff       	jmp    80105cba <alltraps>

80106677 <vector132>:
.globl vector132
vector132:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $132
80106679:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010667e:	e9 37 f6 ff ff       	jmp    80105cba <alltraps>

80106683 <vector133>:
.globl vector133
vector133:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $133
80106685:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010668a:	e9 2b f6 ff ff       	jmp    80105cba <alltraps>

8010668f <vector134>:
.globl vector134
vector134:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $134
80106691:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106696:	e9 1f f6 ff ff       	jmp    80105cba <alltraps>

8010669b <vector135>:
.globl vector135
vector135:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $135
8010669d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801066a2:	e9 13 f6 ff ff       	jmp    80105cba <alltraps>

801066a7 <vector136>:
.globl vector136
vector136:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $136
801066a9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801066ae:	e9 07 f6 ff ff       	jmp    80105cba <alltraps>

801066b3 <vector137>:
.globl vector137
vector137:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $137
801066b5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801066ba:	e9 fb f5 ff ff       	jmp    80105cba <alltraps>

801066bf <vector138>:
.globl vector138
vector138:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $138
801066c1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801066c6:	e9 ef f5 ff ff       	jmp    80105cba <alltraps>

801066cb <vector139>:
.globl vector139
vector139:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $139
801066cd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801066d2:	e9 e3 f5 ff ff       	jmp    80105cba <alltraps>

801066d7 <vector140>:
.globl vector140
vector140:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $140
801066d9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801066de:	e9 d7 f5 ff ff       	jmp    80105cba <alltraps>

801066e3 <vector141>:
.globl vector141
vector141:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $141
801066e5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801066ea:	e9 cb f5 ff ff       	jmp    80105cba <alltraps>

801066ef <vector142>:
.globl vector142
vector142:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $142
801066f1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801066f6:	e9 bf f5 ff ff       	jmp    80105cba <alltraps>

801066fb <vector143>:
.globl vector143
vector143:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $143
801066fd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106702:	e9 b3 f5 ff ff       	jmp    80105cba <alltraps>

80106707 <vector144>:
.globl vector144
vector144:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $144
80106709:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010670e:	e9 a7 f5 ff ff       	jmp    80105cba <alltraps>

80106713 <vector145>:
.globl vector145
vector145:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $145
80106715:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010671a:	e9 9b f5 ff ff       	jmp    80105cba <alltraps>

8010671f <vector146>:
.globl vector146
vector146:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $146
80106721:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106726:	e9 8f f5 ff ff       	jmp    80105cba <alltraps>

8010672b <vector147>:
.globl vector147
vector147:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $147
8010672d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106732:	e9 83 f5 ff ff       	jmp    80105cba <alltraps>

80106737 <vector148>:
.globl vector148
vector148:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $148
80106739:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010673e:	e9 77 f5 ff ff       	jmp    80105cba <alltraps>

80106743 <vector149>:
.globl vector149
vector149:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $149
80106745:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010674a:	e9 6b f5 ff ff       	jmp    80105cba <alltraps>

8010674f <vector150>:
.globl vector150
vector150:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $150
80106751:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106756:	e9 5f f5 ff ff       	jmp    80105cba <alltraps>

8010675b <vector151>:
.globl vector151
vector151:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $151
8010675d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106762:	e9 53 f5 ff ff       	jmp    80105cba <alltraps>

80106767 <vector152>:
.globl vector152
vector152:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $152
80106769:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010676e:	e9 47 f5 ff ff       	jmp    80105cba <alltraps>

80106773 <vector153>:
.globl vector153
vector153:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $153
80106775:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010677a:	e9 3b f5 ff ff       	jmp    80105cba <alltraps>

8010677f <vector154>:
.globl vector154
vector154:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $154
80106781:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106786:	e9 2f f5 ff ff       	jmp    80105cba <alltraps>

8010678b <vector155>:
.globl vector155
vector155:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $155
8010678d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106792:	e9 23 f5 ff ff       	jmp    80105cba <alltraps>

80106797 <vector156>:
.globl vector156
vector156:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $156
80106799:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010679e:	e9 17 f5 ff ff       	jmp    80105cba <alltraps>

801067a3 <vector157>:
.globl vector157
vector157:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $157
801067a5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801067aa:	e9 0b f5 ff ff       	jmp    80105cba <alltraps>

801067af <vector158>:
.globl vector158
vector158:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $158
801067b1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801067b6:	e9 ff f4 ff ff       	jmp    80105cba <alltraps>

801067bb <vector159>:
.globl vector159
vector159:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $159
801067bd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801067c2:	e9 f3 f4 ff ff       	jmp    80105cba <alltraps>

801067c7 <vector160>:
.globl vector160
vector160:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $160
801067c9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801067ce:	e9 e7 f4 ff ff       	jmp    80105cba <alltraps>

801067d3 <vector161>:
.globl vector161
vector161:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $161
801067d5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801067da:	e9 db f4 ff ff       	jmp    80105cba <alltraps>

801067df <vector162>:
.globl vector162
vector162:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $162
801067e1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801067e6:	e9 cf f4 ff ff       	jmp    80105cba <alltraps>

801067eb <vector163>:
.globl vector163
vector163:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $163
801067ed:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801067f2:	e9 c3 f4 ff ff       	jmp    80105cba <alltraps>

801067f7 <vector164>:
.globl vector164
vector164:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $164
801067f9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801067fe:	e9 b7 f4 ff ff       	jmp    80105cba <alltraps>

80106803 <vector165>:
.globl vector165
vector165:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $165
80106805:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010680a:	e9 ab f4 ff ff       	jmp    80105cba <alltraps>

8010680f <vector166>:
.globl vector166
vector166:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $166
80106811:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106816:	e9 9f f4 ff ff       	jmp    80105cba <alltraps>

8010681b <vector167>:
.globl vector167
vector167:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $167
8010681d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106822:	e9 93 f4 ff ff       	jmp    80105cba <alltraps>

80106827 <vector168>:
.globl vector168
vector168:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $168
80106829:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010682e:	e9 87 f4 ff ff       	jmp    80105cba <alltraps>

80106833 <vector169>:
.globl vector169
vector169:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $169
80106835:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010683a:	e9 7b f4 ff ff       	jmp    80105cba <alltraps>

8010683f <vector170>:
.globl vector170
vector170:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $170
80106841:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106846:	e9 6f f4 ff ff       	jmp    80105cba <alltraps>

8010684b <vector171>:
.globl vector171
vector171:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $171
8010684d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106852:	e9 63 f4 ff ff       	jmp    80105cba <alltraps>

80106857 <vector172>:
.globl vector172
vector172:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $172
80106859:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010685e:	e9 57 f4 ff ff       	jmp    80105cba <alltraps>

80106863 <vector173>:
.globl vector173
vector173:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $173
80106865:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010686a:	e9 4b f4 ff ff       	jmp    80105cba <alltraps>

8010686f <vector174>:
.globl vector174
vector174:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $174
80106871:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106876:	e9 3f f4 ff ff       	jmp    80105cba <alltraps>

8010687b <vector175>:
.globl vector175
vector175:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $175
8010687d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106882:	e9 33 f4 ff ff       	jmp    80105cba <alltraps>

80106887 <vector176>:
.globl vector176
vector176:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $176
80106889:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010688e:	e9 27 f4 ff ff       	jmp    80105cba <alltraps>

80106893 <vector177>:
.globl vector177
vector177:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $177
80106895:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010689a:	e9 1b f4 ff ff       	jmp    80105cba <alltraps>

8010689f <vector178>:
.globl vector178
vector178:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $178
801068a1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801068a6:	e9 0f f4 ff ff       	jmp    80105cba <alltraps>

801068ab <vector179>:
.globl vector179
vector179:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $179
801068ad:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801068b2:	e9 03 f4 ff ff       	jmp    80105cba <alltraps>

801068b7 <vector180>:
.globl vector180
vector180:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $180
801068b9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801068be:	e9 f7 f3 ff ff       	jmp    80105cba <alltraps>

801068c3 <vector181>:
.globl vector181
vector181:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $181
801068c5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801068ca:	e9 eb f3 ff ff       	jmp    80105cba <alltraps>

801068cf <vector182>:
.globl vector182
vector182:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $182
801068d1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801068d6:	e9 df f3 ff ff       	jmp    80105cba <alltraps>

801068db <vector183>:
.globl vector183
vector183:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $183
801068dd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801068e2:	e9 d3 f3 ff ff       	jmp    80105cba <alltraps>

801068e7 <vector184>:
.globl vector184
vector184:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $184
801068e9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801068ee:	e9 c7 f3 ff ff       	jmp    80105cba <alltraps>

801068f3 <vector185>:
.globl vector185
vector185:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $185
801068f5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801068fa:	e9 bb f3 ff ff       	jmp    80105cba <alltraps>

801068ff <vector186>:
.globl vector186
vector186:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $186
80106901:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106906:	e9 af f3 ff ff       	jmp    80105cba <alltraps>

8010690b <vector187>:
.globl vector187
vector187:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $187
8010690d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106912:	e9 a3 f3 ff ff       	jmp    80105cba <alltraps>

80106917 <vector188>:
.globl vector188
vector188:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $188
80106919:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010691e:	e9 97 f3 ff ff       	jmp    80105cba <alltraps>

80106923 <vector189>:
.globl vector189
vector189:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $189
80106925:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010692a:	e9 8b f3 ff ff       	jmp    80105cba <alltraps>

8010692f <vector190>:
.globl vector190
vector190:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $190
80106931:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106936:	e9 7f f3 ff ff       	jmp    80105cba <alltraps>

8010693b <vector191>:
.globl vector191
vector191:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $191
8010693d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106942:	e9 73 f3 ff ff       	jmp    80105cba <alltraps>

80106947 <vector192>:
.globl vector192
vector192:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $192
80106949:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010694e:	e9 67 f3 ff ff       	jmp    80105cba <alltraps>

80106953 <vector193>:
.globl vector193
vector193:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $193
80106955:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010695a:	e9 5b f3 ff ff       	jmp    80105cba <alltraps>

8010695f <vector194>:
.globl vector194
vector194:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $194
80106961:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106966:	e9 4f f3 ff ff       	jmp    80105cba <alltraps>

8010696b <vector195>:
.globl vector195
vector195:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $195
8010696d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106972:	e9 43 f3 ff ff       	jmp    80105cba <alltraps>

80106977 <vector196>:
.globl vector196
vector196:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $196
80106979:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010697e:	e9 37 f3 ff ff       	jmp    80105cba <alltraps>

80106983 <vector197>:
.globl vector197
vector197:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $197
80106985:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010698a:	e9 2b f3 ff ff       	jmp    80105cba <alltraps>

8010698f <vector198>:
.globl vector198
vector198:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $198
80106991:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106996:	e9 1f f3 ff ff       	jmp    80105cba <alltraps>

8010699b <vector199>:
.globl vector199
vector199:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $199
8010699d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801069a2:	e9 13 f3 ff ff       	jmp    80105cba <alltraps>

801069a7 <vector200>:
.globl vector200
vector200:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $200
801069a9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801069ae:	e9 07 f3 ff ff       	jmp    80105cba <alltraps>

801069b3 <vector201>:
.globl vector201
vector201:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $201
801069b5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801069ba:	e9 fb f2 ff ff       	jmp    80105cba <alltraps>

801069bf <vector202>:
.globl vector202
vector202:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $202
801069c1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801069c6:	e9 ef f2 ff ff       	jmp    80105cba <alltraps>

801069cb <vector203>:
.globl vector203
vector203:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $203
801069cd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801069d2:	e9 e3 f2 ff ff       	jmp    80105cba <alltraps>

801069d7 <vector204>:
.globl vector204
vector204:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $204
801069d9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801069de:	e9 d7 f2 ff ff       	jmp    80105cba <alltraps>

801069e3 <vector205>:
.globl vector205
vector205:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $205
801069e5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801069ea:	e9 cb f2 ff ff       	jmp    80105cba <alltraps>

801069ef <vector206>:
.globl vector206
vector206:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $206
801069f1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801069f6:	e9 bf f2 ff ff       	jmp    80105cba <alltraps>

801069fb <vector207>:
.globl vector207
vector207:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $207
801069fd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a02:	e9 b3 f2 ff ff       	jmp    80105cba <alltraps>

80106a07 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $208
80106a09:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a0e:	e9 a7 f2 ff ff       	jmp    80105cba <alltraps>

80106a13 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $209
80106a15:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a1a:	e9 9b f2 ff ff       	jmp    80105cba <alltraps>

80106a1f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $210
80106a21:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a26:	e9 8f f2 ff ff       	jmp    80105cba <alltraps>

80106a2b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $211
80106a2d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a32:	e9 83 f2 ff ff       	jmp    80105cba <alltraps>

80106a37 <vector212>:
.globl vector212
vector212:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $212
80106a39:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a3e:	e9 77 f2 ff ff       	jmp    80105cba <alltraps>

80106a43 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $213
80106a45:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a4a:	e9 6b f2 ff ff       	jmp    80105cba <alltraps>

80106a4f <vector214>:
.globl vector214
vector214:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $214
80106a51:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a56:	e9 5f f2 ff ff       	jmp    80105cba <alltraps>

80106a5b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $215
80106a5d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a62:	e9 53 f2 ff ff       	jmp    80105cba <alltraps>

80106a67 <vector216>:
.globl vector216
vector216:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $216
80106a69:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a6e:	e9 47 f2 ff ff       	jmp    80105cba <alltraps>

80106a73 <vector217>:
.globl vector217
vector217:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $217
80106a75:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106a7a:	e9 3b f2 ff ff       	jmp    80105cba <alltraps>

80106a7f <vector218>:
.globl vector218
vector218:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $218
80106a81:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106a86:	e9 2f f2 ff ff       	jmp    80105cba <alltraps>

80106a8b <vector219>:
.globl vector219
vector219:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $219
80106a8d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a92:	e9 23 f2 ff ff       	jmp    80105cba <alltraps>

80106a97 <vector220>:
.globl vector220
vector220:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $220
80106a99:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a9e:	e9 17 f2 ff ff       	jmp    80105cba <alltraps>

80106aa3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $221
80106aa5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106aaa:	e9 0b f2 ff ff       	jmp    80105cba <alltraps>

80106aaf <vector222>:
.globl vector222
vector222:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $222
80106ab1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ab6:	e9 ff f1 ff ff       	jmp    80105cba <alltraps>

80106abb <vector223>:
.globl vector223
vector223:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $223
80106abd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ac2:	e9 f3 f1 ff ff       	jmp    80105cba <alltraps>

80106ac7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $224
80106ac9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106ace:	e9 e7 f1 ff ff       	jmp    80105cba <alltraps>

80106ad3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $225
80106ad5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106ada:	e9 db f1 ff ff       	jmp    80105cba <alltraps>

80106adf <vector226>:
.globl vector226
vector226:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $226
80106ae1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ae6:	e9 cf f1 ff ff       	jmp    80105cba <alltraps>

80106aeb <vector227>:
.globl vector227
vector227:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $227
80106aed:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106af2:	e9 c3 f1 ff ff       	jmp    80105cba <alltraps>

80106af7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $228
80106af9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106afe:	e9 b7 f1 ff ff       	jmp    80105cba <alltraps>

80106b03 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $229
80106b05:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b0a:	e9 ab f1 ff ff       	jmp    80105cba <alltraps>

80106b0f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $230
80106b11:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b16:	e9 9f f1 ff ff       	jmp    80105cba <alltraps>

80106b1b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $231
80106b1d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b22:	e9 93 f1 ff ff       	jmp    80105cba <alltraps>

80106b27 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $232
80106b29:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b2e:	e9 87 f1 ff ff       	jmp    80105cba <alltraps>

80106b33 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $233
80106b35:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b3a:	e9 7b f1 ff ff       	jmp    80105cba <alltraps>

80106b3f <vector234>:
.globl vector234
vector234:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $234
80106b41:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b46:	e9 6f f1 ff ff       	jmp    80105cba <alltraps>

80106b4b <vector235>:
.globl vector235
vector235:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $235
80106b4d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b52:	e9 63 f1 ff ff       	jmp    80105cba <alltraps>

80106b57 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $236
80106b59:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b5e:	e9 57 f1 ff ff       	jmp    80105cba <alltraps>

80106b63 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $237
80106b65:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b6a:	e9 4b f1 ff ff       	jmp    80105cba <alltraps>

80106b6f <vector238>:
.globl vector238
vector238:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $238
80106b71:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106b76:	e9 3f f1 ff ff       	jmp    80105cba <alltraps>

80106b7b <vector239>:
.globl vector239
vector239:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $239
80106b7d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106b82:	e9 33 f1 ff ff       	jmp    80105cba <alltraps>

80106b87 <vector240>:
.globl vector240
vector240:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $240
80106b89:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106b8e:	e9 27 f1 ff ff       	jmp    80105cba <alltraps>

80106b93 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $241
80106b95:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b9a:	e9 1b f1 ff ff       	jmp    80105cba <alltraps>

80106b9f <vector242>:
.globl vector242
vector242:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $242
80106ba1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ba6:	e9 0f f1 ff ff       	jmp    80105cba <alltraps>

80106bab <vector243>:
.globl vector243
vector243:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $243
80106bad:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106bb2:	e9 03 f1 ff ff       	jmp    80105cba <alltraps>

80106bb7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $244
80106bb9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106bbe:	e9 f7 f0 ff ff       	jmp    80105cba <alltraps>

80106bc3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $245
80106bc5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106bca:	e9 eb f0 ff ff       	jmp    80105cba <alltraps>

80106bcf <vector246>:
.globl vector246
vector246:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $246
80106bd1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106bd6:	e9 df f0 ff ff       	jmp    80105cba <alltraps>

80106bdb <vector247>:
.globl vector247
vector247:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $247
80106bdd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106be2:	e9 d3 f0 ff ff       	jmp    80105cba <alltraps>

80106be7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $248
80106be9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106bee:	e9 c7 f0 ff ff       	jmp    80105cba <alltraps>

80106bf3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $249
80106bf5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106bfa:	e9 bb f0 ff ff       	jmp    80105cba <alltraps>

80106bff <vector250>:
.globl vector250
vector250:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $250
80106c01:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c06:	e9 af f0 ff ff       	jmp    80105cba <alltraps>

80106c0b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $251
80106c0d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c12:	e9 a3 f0 ff ff       	jmp    80105cba <alltraps>

80106c17 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $252
80106c19:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c1e:	e9 97 f0 ff ff       	jmp    80105cba <alltraps>

80106c23 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $253
80106c25:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c2a:	e9 8b f0 ff ff       	jmp    80105cba <alltraps>

80106c2f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $254
80106c31:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c36:	e9 7f f0 ff ff       	jmp    80105cba <alltraps>

80106c3b <vector255>:
.globl vector255
vector255:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $255
80106c3d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c42:	e9 73 f0 ff ff       	jmp    80105cba <alltraps>
80106c47:	66 90                	xchg   %ax,%ax
80106c49:	66 90                	xchg   %ax,%ax
80106c4b:	66 90                	xchg   %ax,%ax
80106c4d:	66 90                	xchg   %ax,%ax
80106c4f:	90                   	nop

80106c50 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c56:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106c5c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c62:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106c65:	39 d3                	cmp    %edx,%ebx
80106c67:	73 56                	jae    80106cbf <deallocuvm.part.0+0x6f>
80106c69:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106c6c:	89 c6                	mov    %eax,%esi
80106c6e:	89 d7                	mov    %edx,%edi
80106c70:	eb 12                	jmp    80106c84 <deallocuvm.part.0+0x34>
80106c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c78:	83 c2 01             	add    $0x1,%edx
80106c7b:	89 d3                	mov    %edx,%ebx
80106c7d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106c80:	39 fb                	cmp    %edi,%ebx
80106c82:	73 38                	jae    80106cbc <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106c84:	89 da                	mov    %ebx,%edx
80106c86:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106c89:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106c8c:	a8 01                	test   $0x1,%al
80106c8e:	74 e8                	je     80106c78 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106c90:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106c97:	c1 e9 0a             	shr    $0xa,%ecx
80106c9a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106ca0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106ca7:	85 c0                	test   %eax,%eax
80106ca9:	74 cd                	je     80106c78 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106cab:	8b 10                	mov    (%eax),%edx
80106cad:	f6 c2 01             	test   $0x1,%dl
80106cb0:	75 1e                	jne    80106cd0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106cb2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cb8:	39 fb                	cmp    %edi,%ebx
80106cba:	72 c8                	jb     80106c84 <deallocuvm.part.0+0x34>
80106cbc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106cbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cc2:	89 c8                	mov    %ecx,%eax
80106cc4:	5b                   	pop    %ebx
80106cc5:	5e                   	pop    %esi
80106cc6:	5f                   	pop    %edi
80106cc7:	5d                   	pop    %ebp
80106cc8:	c3                   	ret
80106cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106cd0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106cd6:	74 26                	je     80106cfe <deallocuvm.part.0+0xae>
      kfree(v);
80106cd8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106cdb:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106ce1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106ce4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106cea:	52                   	push   %edx
80106ceb:	e8 b0 b8 ff ff       	call   801025a0 <kfree>
      *pte = 0;
80106cf0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106cf3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106cf6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106cfc:	eb 82                	jmp    80106c80 <deallocuvm.part.0+0x30>
        panic("kfree");
80106cfe:	83 ec 0c             	sub    $0xc,%esp
80106d01:	68 2c 7c 10 80       	push   $0x80107c2c
80106d06:	e8 65 97 ff ff       	call   80100470 <panic>
80106d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d0f:	90                   	nop

80106d10 <mappages>:
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106d16:	89 d3                	mov    %edx,%ebx
80106d18:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106d1e:	83 ec 1c             	sub    $0x1c,%esp
80106d21:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d24:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d2d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d30:	8b 45 08             	mov    0x8(%ebp),%eax
80106d33:	29 d8                	sub    %ebx,%eax
80106d35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d38:	eb 3f                	jmp    80106d79 <mappages+0x69>
80106d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106d40:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106d47:	c1 ea 0a             	shr    $0xa,%edx
80106d4a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106d50:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d57:	85 c0                	test   %eax,%eax
80106d59:	74 75                	je     80106dd0 <mappages+0xc0>
    if(*pte & PTE_P)
80106d5b:	f6 00 01             	testb  $0x1,(%eax)
80106d5e:	0f 85 86 00 00 00    	jne    80106dea <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106d64:	0b 75 0c             	or     0xc(%ebp),%esi
80106d67:	83 ce 01             	or     $0x1,%esi
80106d6a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106d6f:	39 c3                	cmp    %eax,%ebx
80106d71:	74 6d                	je     80106de0 <mappages+0xd0>
    a += PGSIZE;
80106d73:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106d79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106d7c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106d7f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106d82:	89 d8                	mov    %ebx,%eax
80106d84:	c1 e8 16             	shr    $0x16,%eax
80106d87:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106d8a:	8b 07                	mov    (%edi),%eax
80106d8c:	a8 01                	test   $0x1,%al
80106d8e:	75 b0                	jne    80106d40 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d90:	e8 2b ba ff ff       	call   801027c0 <kalloc>
80106d95:	85 c0                	test   %eax,%eax
80106d97:	74 37                	je     80106dd0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106d99:	83 ec 04             	sub    $0x4,%esp
80106d9c:	68 00 10 00 00       	push   $0x1000
80106da1:	6a 00                	push   $0x0
80106da3:	50                   	push   %eax
80106da4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106da7:	e8 54 dd ff ff       	call   80104b00 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106dac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106daf:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106db2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106db8:	83 c8 07             	or     $0x7,%eax
80106dbb:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106dbd:	89 d8                	mov    %ebx,%eax
80106dbf:	c1 e8 0a             	shr    $0xa,%eax
80106dc2:	25 fc 0f 00 00       	and    $0xffc,%eax
80106dc7:	01 d0                	add    %edx,%eax
80106dc9:	eb 90                	jmp    80106d5b <mappages+0x4b>
80106dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106dcf:	90                   	nop
}
80106dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106dd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106dd8:	5b                   	pop    %ebx
80106dd9:	5e                   	pop    %esi
80106dda:	5f                   	pop    %edi
80106ddb:	5d                   	pop    %ebp
80106ddc:	c3                   	ret
80106ddd:	8d 76 00             	lea    0x0(%esi),%esi
80106de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106de3:	31 c0                	xor    %eax,%eax
}
80106de5:	5b                   	pop    %ebx
80106de6:	5e                   	pop    %esi
80106de7:	5f                   	pop    %edi
80106de8:	5d                   	pop    %ebp
80106de9:	c3                   	ret
      panic("remap");
80106dea:	83 ec 0c             	sub    $0xc,%esp
80106ded:	68 97 7e 10 80       	push   $0x80107e97
80106df2:	e8 79 96 ff ff       	call   80100470 <panic>
80106df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dfe:	66 90                	xchg   %ax,%ax

80106e00 <seginit>:
{
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e06:	e8 05 cd ff ff       	call   80103b10 <cpuid>
  pd[0] = size-1;
80106e0b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e10:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106e16:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106e1a:	c7 80 38 38 11 80 ff 	movl   $0xffff,-0x7feec7c8(%eax)
80106e21:	ff 00 00 
80106e24:	c7 80 3c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7c4(%eax)
80106e2b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e2e:	c7 80 40 38 11 80 ff 	movl   $0xffff,-0x7feec7c0(%eax)
80106e35:	ff 00 00 
80106e38:	c7 80 44 38 11 80 00 	movl   $0xcf9200,-0x7feec7bc(%eax)
80106e3f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e42:	c7 80 48 38 11 80 ff 	movl   $0xffff,-0x7feec7b8(%eax)
80106e49:	ff 00 00 
80106e4c:	c7 80 4c 38 11 80 00 	movl   $0xcffa00,-0x7feec7b4(%eax)
80106e53:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e56:	c7 80 50 38 11 80 ff 	movl   $0xffff,-0x7feec7b0(%eax)
80106e5d:	ff 00 00 
80106e60:	c7 80 54 38 11 80 00 	movl   $0xcff200,-0x7feec7ac(%eax)
80106e67:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106e6a:	05 30 38 11 80       	add    $0x80113830,%eax
  pd[1] = (uint)p;
80106e6f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106e73:	c1 e8 10             	shr    $0x10,%eax
80106e76:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106e7a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106e7d:	0f 01 10             	lgdtl  (%eax)
}
80106e80:	c9                   	leave
80106e81:	c3                   	ret
80106e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e90 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e90:	a1 24 61 11 80       	mov    0x80116124,%eax
80106e95:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e9a:	0f 22 d8             	mov    %eax,%cr3
}
80106e9d:	c3                   	ret
80106e9e:	66 90                	xchg   %ax,%ax

80106ea0 <switchuvm>:
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
80106ea6:	83 ec 1c             	sub    $0x1c,%esp
80106ea9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106eac:	85 f6                	test   %esi,%esi
80106eae:	0f 84 cb 00 00 00    	je     80106f7f <switchuvm+0xdf>
  if(p->kstack == 0)
80106eb4:	8b 46 0c             	mov    0xc(%esi),%eax
80106eb7:	85 c0                	test   %eax,%eax
80106eb9:	0f 84 da 00 00 00    	je     80106f99 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106ebf:	8b 46 08             	mov    0x8(%esi),%eax
80106ec2:	85 c0                	test   %eax,%eax
80106ec4:	0f 84 c2 00 00 00    	je     80106f8c <switchuvm+0xec>
  pushcli();
80106eca:	e8 e1 d9 ff ff       	call   801048b0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106ecf:	e8 ec cb ff ff       	call   80103ac0 <mycpu>
80106ed4:	89 c3                	mov    %eax,%ebx
80106ed6:	e8 e5 cb ff ff       	call   80103ac0 <mycpu>
80106edb:	89 c7                	mov    %eax,%edi
80106edd:	e8 de cb ff ff       	call   80103ac0 <mycpu>
80106ee2:	83 c7 08             	add    $0x8,%edi
80106ee5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ee8:	e8 d3 cb ff ff       	call   80103ac0 <mycpu>
80106eed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ef0:	ba 67 00 00 00       	mov    $0x67,%edx
80106ef5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106efc:	83 c0 08             	add    $0x8,%eax
80106eff:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f06:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f0b:	83 c1 08             	add    $0x8,%ecx
80106f0e:	c1 e8 18             	shr    $0x18,%eax
80106f11:	c1 e9 10             	shr    $0x10,%ecx
80106f14:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106f1a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106f20:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f25:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f2c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106f31:	e8 8a cb ff ff       	call   80103ac0 <mycpu>
80106f36:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f3d:	e8 7e cb ff ff       	call   80103ac0 <mycpu>
80106f42:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f46:	8b 5e 0c             	mov    0xc(%esi),%ebx
80106f49:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f4f:	e8 6c cb ff ff       	call   80103ac0 <mycpu>
80106f54:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f57:	e8 64 cb ff ff       	call   80103ac0 <mycpu>
80106f5c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106f60:	b8 28 00 00 00       	mov    $0x28,%eax
80106f65:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106f68:	8b 46 08             	mov    0x8(%esi),%eax
80106f6b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f70:	0f 22 d8             	mov    %eax,%cr3
}
80106f73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f76:	5b                   	pop    %ebx
80106f77:	5e                   	pop    %esi
80106f78:	5f                   	pop    %edi
80106f79:	5d                   	pop    %ebp
  popcli();
80106f7a:	e9 81 d9 ff ff       	jmp    80104900 <popcli>
    panic("switchuvm: no process");
80106f7f:	83 ec 0c             	sub    $0xc,%esp
80106f82:	68 9d 7e 10 80       	push   $0x80107e9d
80106f87:	e8 e4 94 ff ff       	call   80100470 <panic>
    panic("switchuvm: no pgdir");
80106f8c:	83 ec 0c             	sub    $0xc,%esp
80106f8f:	68 c8 7e 10 80       	push   $0x80107ec8
80106f94:	e8 d7 94 ff ff       	call   80100470 <panic>
    panic("switchuvm: no kstack");
80106f99:	83 ec 0c             	sub    $0xc,%esp
80106f9c:	68 b3 7e 10 80       	push   $0x80107eb3
80106fa1:	e8 ca 94 ff ff       	call   80100470 <panic>
80106fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fad:	8d 76 00             	lea    0x0(%esi),%esi

80106fb0 <inituvm>:
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	56                   	push   %esi
80106fb5:	53                   	push   %ebx
80106fb6:	83 ec 1c             	sub    $0x1c,%esp
80106fb9:	8b 45 08             	mov    0x8(%ebp),%eax
80106fbc:	8b 75 10             	mov    0x10(%ebp),%esi
80106fbf:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106fc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106fc5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106fcb:	77 49                	ja     80107016 <inituvm+0x66>
  mem = kalloc();
80106fcd:	e8 ee b7 ff ff       	call   801027c0 <kalloc>
  memset(mem, 0, PGSIZE);
80106fd2:	83 ec 04             	sub    $0x4,%esp
80106fd5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106fda:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106fdc:	6a 00                	push   $0x0
80106fde:	50                   	push   %eax
80106fdf:	e8 1c db ff ff       	call   80104b00 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106fe4:	58                   	pop    %eax
80106fe5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106feb:	5a                   	pop    %edx
80106fec:	6a 06                	push   $0x6
80106fee:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ff3:	31 d2                	xor    %edx,%edx
80106ff5:	50                   	push   %eax
80106ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ff9:	e8 12 fd ff ff       	call   80106d10 <mappages>
  memmove(mem, init, sz);
80106ffe:	89 75 10             	mov    %esi,0x10(%ebp)
80107001:	83 c4 10             	add    $0x10,%esp
80107004:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107007:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010700a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010700d:	5b                   	pop    %ebx
8010700e:	5e                   	pop    %esi
8010700f:	5f                   	pop    %edi
80107010:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107011:	e9 7a db ff ff       	jmp    80104b90 <memmove>
    panic("inituvm: more than a page");
80107016:	83 ec 0c             	sub    $0xc,%esp
80107019:	68 dc 7e 10 80       	push   $0x80107edc
8010701e:	e8 4d 94 ff ff       	call   80100470 <panic>
80107023:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010702a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107030 <loaduvm>:
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	57                   	push   %edi
80107034:	56                   	push   %esi
80107035:	53                   	push   %ebx
80107036:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107039:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010703c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010703f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107045:	0f 85 a2 00 00 00    	jne    801070ed <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
8010704b:	85 ff                	test   %edi,%edi
8010704d:	74 7d                	je     801070cc <loaduvm+0x9c>
8010704f:	90                   	nop
  pde = &pgdir[PDX(va)];
80107050:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107053:	8b 55 08             	mov    0x8(%ebp),%edx
80107056:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80107058:	89 c1                	mov    %eax,%ecx
8010705a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010705d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80107060:	f6 c1 01             	test   $0x1,%cl
80107063:	75 13                	jne    80107078 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80107065:	83 ec 0c             	sub    $0xc,%esp
80107068:	68 f6 7e 10 80       	push   $0x80107ef6
8010706d:	e8 fe 93 ff ff       	call   80100470 <panic>
80107072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107078:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010707b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107081:	25 fc 0f 00 00       	and    $0xffc,%eax
80107086:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010708d:	85 c9                	test   %ecx,%ecx
8010708f:	74 d4                	je     80107065 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80107091:	89 fb                	mov    %edi,%ebx
80107093:	b8 00 10 00 00       	mov    $0x1000,%eax
80107098:	29 f3                	sub    %esi,%ebx
8010709a:	39 c3                	cmp    %eax,%ebx
8010709c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010709f:	53                   	push   %ebx
801070a0:	8b 45 14             	mov    0x14(%ebp),%eax
801070a3:	01 f0                	add    %esi,%eax
801070a5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
801070a6:	8b 01                	mov    (%ecx),%eax
801070a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070ad:	05 00 00 00 80       	add    $0x80000000,%eax
801070b2:	50                   	push   %eax
801070b3:	ff 75 10             	push   0x10(%ebp)
801070b6:	e8 e5 aa ff ff       	call   80101ba0 <readi>
801070bb:	83 c4 10             	add    $0x10,%esp
801070be:	39 d8                	cmp    %ebx,%eax
801070c0:	75 1e                	jne    801070e0 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
801070c2:	81 c6 00 10 00 00    	add    $0x1000,%esi
801070c8:	39 fe                	cmp    %edi,%esi
801070ca:	72 84                	jb     80107050 <loaduvm+0x20>
}
801070cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070cf:	31 c0                	xor    %eax,%eax
}
801070d1:	5b                   	pop    %ebx
801070d2:	5e                   	pop    %esi
801070d3:	5f                   	pop    %edi
801070d4:	5d                   	pop    %ebp
801070d5:	c3                   	ret
801070d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070dd:	8d 76 00             	lea    0x0(%esi),%esi
801070e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070e8:	5b                   	pop    %ebx
801070e9:	5e                   	pop    %esi
801070ea:	5f                   	pop    %edi
801070eb:	5d                   	pop    %ebp
801070ec:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
801070ed:	83 ec 0c             	sub    $0xc,%esp
801070f0:	68 00 82 10 80       	push   $0x80108200
801070f5:	e8 76 93 ff ff       	call   80100470 <panic>
801070fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107100 <allocuvm>:
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	57                   	push   %edi
80107104:	56                   	push   %esi
80107105:	53                   	push   %ebx
80107106:	83 ec 1c             	sub    $0x1c,%esp
80107109:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010710c:	85 f6                	test   %esi,%esi
8010710e:	0f 88 98 00 00 00    	js     801071ac <allocuvm+0xac>
80107114:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80107116:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107119:	0f 82 a1 00 00 00    	jb     801071c0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010711f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107122:	05 ff 0f 00 00       	add    $0xfff,%eax
80107127:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010712c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010712e:	39 f0                	cmp    %esi,%eax
80107130:	0f 83 8d 00 00 00    	jae    801071c3 <allocuvm+0xc3>
80107136:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107139:	eb 44                	jmp    8010717f <allocuvm+0x7f>
8010713b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010713f:	90                   	nop
    memset(mem, 0, PGSIZE);
80107140:	83 ec 04             	sub    $0x4,%esp
80107143:	68 00 10 00 00       	push   $0x1000
80107148:	6a 00                	push   $0x0
8010714a:	50                   	push   %eax
8010714b:	e8 b0 d9 ff ff       	call   80104b00 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107150:	58                   	pop    %eax
80107151:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107157:	5a                   	pop    %edx
80107158:	6a 06                	push   $0x6
8010715a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010715f:	89 fa                	mov    %edi,%edx
80107161:	50                   	push   %eax
80107162:	8b 45 08             	mov    0x8(%ebp),%eax
80107165:	e8 a6 fb ff ff       	call   80106d10 <mappages>
8010716a:	83 c4 10             	add    $0x10,%esp
8010716d:	85 c0                	test   %eax,%eax
8010716f:	78 5f                	js     801071d0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80107171:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107177:	39 f7                	cmp    %esi,%edi
80107179:	0f 83 89 00 00 00    	jae    80107208 <allocuvm+0x108>
    mem = kalloc();
8010717f:	e8 3c b6 ff ff       	call   801027c0 <kalloc>
80107184:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107186:	85 c0                	test   %eax,%eax
80107188:	75 b6                	jne    80107140 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010718a:	83 ec 0c             	sub    $0xc,%esp
8010718d:	68 14 7f 10 80       	push   $0x80107f14
80107192:	e8 09 96 ff ff       	call   801007a0 <cprintf>
  if(newsz >= oldsz)
80107197:	83 c4 10             	add    $0x10,%esp
8010719a:	3b 75 0c             	cmp    0xc(%ebp),%esi
8010719d:	74 0d                	je     801071ac <allocuvm+0xac>
8010719f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071a2:	8b 45 08             	mov    0x8(%ebp),%eax
801071a5:	89 f2                	mov    %esi,%edx
801071a7:	e8 a4 fa ff ff       	call   80106c50 <deallocuvm.part.0>
    return 0;
801071ac:	31 d2                	xor    %edx,%edx
}
801071ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071b1:	89 d0                	mov    %edx,%eax
801071b3:	5b                   	pop    %ebx
801071b4:	5e                   	pop    %esi
801071b5:	5f                   	pop    %edi
801071b6:	5d                   	pop    %ebp
801071b7:	c3                   	ret
801071b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071bf:	90                   	nop
    return oldsz;
801071c0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
801071c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071c6:	89 d0                	mov    %edx,%eax
801071c8:	5b                   	pop    %ebx
801071c9:	5e                   	pop    %esi
801071ca:	5f                   	pop    %edi
801071cb:	5d                   	pop    %ebp
801071cc:	c3                   	ret
801071cd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801071d0:	83 ec 0c             	sub    $0xc,%esp
801071d3:	68 2c 7f 10 80       	push   $0x80107f2c
801071d8:	e8 c3 95 ff ff       	call   801007a0 <cprintf>
  if(newsz >= oldsz)
801071dd:	83 c4 10             	add    $0x10,%esp
801071e0:	3b 75 0c             	cmp    0xc(%ebp),%esi
801071e3:	74 0d                	je     801071f2 <allocuvm+0xf2>
801071e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071e8:	8b 45 08             	mov    0x8(%ebp),%eax
801071eb:	89 f2                	mov    %esi,%edx
801071ed:	e8 5e fa ff ff       	call   80106c50 <deallocuvm.part.0>
      kfree(mem);
801071f2:	83 ec 0c             	sub    $0xc,%esp
801071f5:	53                   	push   %ebx
801071f6:	e8 a5 b3 ff ff       	call   801025a0 <kfree>
      return 0;
801071fb:	83 c4 10             	add    $0x10,%esp
    return 0;
801071fe:	31 d2                	xor    %edx,%edx
80107200:	eb ac                	jmp    801071ae <allocuvm+0xae>
80107202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107208:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
8010720b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010720e:	5b                   	pop    %ebx
8010720f:	5e                   	pop    %esi
80107210:	89 d0                	mov    %edx,%eax
80107212:	5f                   	pop    %edi
80107213:	5d                   	pop    %ebp
80107214:	c3                   	ret
80107215:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010721c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107220 <deallocuvm>:
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	8b 55 0c             	mov    0xc(%ebp),%edx
80107226:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107229:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010722c:	39 d1                	cmp    %edx,%ecx
8010722e:	73 10                	jae    80107240 <deallocuvm+0x20>
}
80107230:	5d                   	pop    %ebp
80107231:	e9 1a fa ff ff       	jmp    80106c50 <deallocuvm.part.0>
80107236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010723d:	8d 76 00             	lea    0x0(%esi),%esi
80107240:	89 d0                	mov    %edx,%eax
80107242:	5d                   	pop    %ebp
80107243:	c3                   	ret
80107244:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010724b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010724f:	90                   	nop

80107250 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	57                   	push   %edi
80107254:	56                   	push   %esi
80107255:	53                   	push   %ebx
80107256:	83 ec 0c             	sub    $0xc,%esp
80107259:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010725c:	85 f6                	test   %esi,%esi
8010725e:	74 59                	je     801072b9 <freevm+0x69>
  if(newsz >= oldsz)
80107260:	31 c9                	xor    %ecx,%ecx
80107262:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107267:	89 f0                	mov    %esi,%eax
80107269:	89 f3                	mov    %esi,%ebx
8010726b:	e8 e0 f9 ff ff       	call   80106c50 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107270:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107276:	eb 0f                	jmp    80107287 <freevm+0x37>
80107278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010727f:	90                   	nop
80107280:	83 c3 04             	add    $0x4,%ebx
80107283:	39 fb                	cmp    %edi,%ebx
80107285:	74 23                	je     801072aa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107287:	8b 03                	mov    (%ebx),%eax
80107289:	a8 01                	test   $0x1,%al
8010728b:	74 f3                	je     80107280 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010728d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107292:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107295:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107298:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010729d:	50                   	push   %eax
8010729e:	e8 fd b2 ff ff       	call   801025a0 <kfree>
801072a3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801072a6:	39 fb                	cmp    %edi,%ebx
801072a8:	75 dd                	jne    80107287 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801072aa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801072ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072b0:	5b                   	pop    %ebx
801072b1:	5e                   	pop    %esi
801072b2:	5f                   	pop    %edi
801072b3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801072b4:	e9 e7 b2 ff ff       	jmp    801025a0 <kfree>
    panic("freevm: no pgdir");
801072b9:	83 ec 0c             	sub    $0xc,%esp
801072bc:	68 48 7f 10 80       	push   $0x80107f48
801072c1:	e8 aa 91 ff ff       	call   80100470 <panic>
801072c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072cd:	8d 76 00             	lea    0x0(%esi),%esi

801072d0 <setupkvm>:
{
801072d0:	55                   	push   %ebp
801072d1:	89 e5                	mov    %esp,%ebp
801072d3:	56                   	push   %esi
801072d4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801072d5:	e8 e6 b4 ff ff       	call   801027c0 <kalloc>
801072da:	85 c0                	test   %eax,%eax
801072dc:	74 5e                	je     8010733c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
801072de:	83 ec 04             	sub    $0x4,%esp
801072e1:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801072e3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801072e8:	68 00 10 00 00       	push   $0x1000
801072ed:	6a 00                	push   $0x0
801072ef:	50                   	push   %eax
801072f0:	e8 0b d8 ff ff       	call   80104b00 <memset>
801072f5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801072f8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801072fb:	83 ec 08             	sub    $0x8,%esp
801072fe:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107301:	8b 13                	mov    (%ebx),%edx
80107303:	ff 73 0c             	push   0xc(%ebx)
80107306:	50                   	push   %eax
80107307:	29 c1                	sub    %eax,%ecx
80107309:	89 f0                	mov    %esi,%eax
8010730b:	e8 00 fa ff ff       	call   80106d10 <mappages>
80107310:	83 c4 10             	add    $0x10,%esp
80107313:	85 c0                	test   %eax,%eax
80107315:	78 19                	js     80107330 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107317:	83 c3 10             	add    $0x10,%ebx
8010731a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107320:	75 d6                	jne    801072f8 <setupkvm+0x28>
}
80107322:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107325:	89 f0                	mov    %esi,%eax
80107327:	5b                   	pop    %ebx
80107328:	5e                   	pop    %esi
80107329:	5d                   	pop    %ebp
8010732a:	c3                   	ret
8010732b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010732f:	90                   	nop
      freevm(pgdir);
80107330:	83 ec 0c             	sub    $0xc,%esp
80107333:	56                   	push   %esi
80107334:	e8 17 ff ff ff       	call   80107250 <freevm>
      return 0;
80107339:	83 c4 10             	add    $0x10,%esp
}
8010733c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010733f:	31 f6                	xor    %esi,%esi
}
80107341:	89 f0                	mov    %esi,%eax
80107343:	5b                   	pop    %ebx
80107344:	5e                   	pop    %esi
80107345:	5d                   	pop    %ebp
80107346:	c3                   	ret
80107347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010734e:	66 90                	xchg   %ax,%ax

80107350 <kvmalloc>:
{
80107350:	55                   	push   %ebp
80107351:	89 e5                	mov    %esp,%ebp
80107353:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107356:	e8 75 ff ff ff       	call   801072d0 <setupkvm>
8010735b:	a3 24 61 11 80       	mov    %eax,0x80116124
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107360:	05 00 00 00 80       	add    $0x80000000,%eax
80107365:	0f 22 d8             	mov    %eax,%cr3
}
80107368:	c9                   	leave
80107369:	c3                   	ret
8010736a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107370 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107370:	55                   	push   %ebp
80107371:	89 e5                	mov    %esp,%ebp
80107373:	83 ec 08             	sub    $0x8,%esp
80107376:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107379:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010737c:	89 c1                	mov    %eax,%ecx
8010737e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107381:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107384:	f6 c2 01             	test   $0x1,%dl
80107387:	75 17                	jne    801073a0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107389:	83 ec 0c             	sub    $0xc,%esp
8010738c:	68 59 7f 10 80       	push   $0x80107f59
80107391:	e8 da 90 ff ff       	call   80100470 <panic>
80107396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010739d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801073a0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073a3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801073a9:	25 fc 0f 00 00       	and    $0xffc,%eax
801073ae:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801073b5:	85 c0                	test   %eax,%eax
801073b7:	74 d0                	je     80107389 <clearpteu+0x19>
  *pte &= ~PTE_U;
801073b9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801073bc:	c9                   	leave
801073bd:	c3                   	ret
801073be:	66 90                	xchg   %ax,%ax

801073c0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	57                   	push   %edi
801073c4:	56                   	push   %esi
801073c5:	53                   	push   %ebx
801073c6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801073c9:	e8 02 ff ff ff       	call   801072d0 <setupkvm>
801073ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
801073d1:	85 c0                	test   %eax,%eax
801073d3:	0f 84 e9 00 00 00    	je     801074c2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801073d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801073dc:	85 c9                	test   %ecx,%ecx
801073de:	0f 84 b2 00 00 00    	je     80107496 <copyuvm+0xd6>
801073e4:	31 f6                	xor    %esi,%esi
801073e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801073f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801073f3:	89 f0                	mov    %esi,%eax
801073f5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801073f8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801073fb:	a8 01                	test   $0x1,%al
801073fd:	75 11                	jne    80107410 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801073ff:	83 ec 0c             	sub    $0xc,%esp
80107402:	68 63 7f 10 80       	push   $0x80107f63
80107407:	e8 64 90 ff ff       	call   80100470 <panic>
8010740c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107410:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107412:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107417:	c1 ea 0a             	shr    $0xa,%edx
8010741a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107420:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107427:	85 c0                	test   %eax,%eax
80107429:	74 d4                	je     801073ff <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010742b:	8b 00                	mov    (%eax),%eax
8010742d:	a8 01                	test   $0x1,%al
8010742f:	0f 84 9f 00 00 00    	je     801074d4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107435:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107437:	25 ff 0f 00 00       	and    $0xfff,%eax
8010743c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010743f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107445:	e8 76 b3 ff ff       	call   801027c0 <kalloc>
8010744a:	89 c3                	mov    %eax,%ebx
8010744c:	85 c0                	test   %eax,%eax
8010744e:	74 64                	je     801074b4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107450:	83 ec 04             	sub    $0x4,%esp
80107453:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107459:	68 00 10 00 00       	push   $0x1000
8010745e:	57                   	push   %edi
8010745f:	50                   	push   %eax
80107460:	e8 2b d7 ff ff       	call   80104b90 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107465:	58                   	pop    %eax
80107466:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010746c:	5a                   	pop    %edx
8010746d:	ff 75 e4             	push   -0x1c(%ebp)
80107470:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107475:	89 f2                	mov    %esi,%edx
80107477:	50                   	push   %eax
80107478:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010747b:	e8 90 f8 ff ff       	call   80106d10 <mappages>
80107480:	83 c4 10             	add    $0x10,%esp
80107483:	85 c0                	test   %eax,%eax
80107485:	78 21                	js     801074a8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107487:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010748d:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107490:	0f 82 5a ff ff ff    	jb     801073f0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107496:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107499:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010749c:	5b                   	pop    %ebx
8010749d:	5e                   	pop    %esi
8010749e:	5f                   	pop    %edi
8010749f:	5d                   	pop    %ebp
801074a0:	c3                   	ret
801074a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801074a8:	83 ec 0c             	sub    $0xc,%esp
801074ab:	53                   	push   %ebx
801074ac:	e8 ef b0 ff ff       	call   801025a0 <kfree>
      goto bad;
801074b1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801074b4:	83 ec 0c             	sub    $0xc,%esp
801074b7:	ff 75 e0             	push   -0x20(%ebp)
801074ba:	e8 91 fd ff ff       	call   80107250 <freevm>
  return 0;
801074bf:	83 c4 10             	add    $0x10,%esp
    return 0;
801074c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801074c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074cf:	5b                   	pop    %ebx
801074d0:	5e                   	pop    %esi
801074d1:	5f                   	pop    %edi
801074d2:	5d                   	pop    %ebp
801074d3:	c3                   	ret
      panic("copyuvm: page not present");
801074d4:	83 ec 0c             	sub    $0xc,%esp
801074d7:	68 7d 7f 10 80       	push   $0x80107f7d
801074dc:	e8 8f 8f ff ff       	call   80100470 <panic>
801074e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ef:	90                   	nop

801074f0 <copyuvm_cow>:
pde_t*
copyuvm_cow(pde_t *pgdir, uint sz)
{
801074f0:	55                   	push   %ebp
801074f1:	89 e5                	mov    %esp,%ebp
801074f3:	57                   	push   %edi
801074f4:	56                   	push   %esi
801074f5:	53                   	push   %ebx
801074f6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  // char *mem;
  int * page_to_refcnt = get_refcnt_table();
801074f9:	e8 92 b0 ff ff       	call   80102590 <get_refcnt_table>
801074fe:	89 45 e0             	mov    %eax,-0x20(%ebp)

  if((d = setupkvm()) == 0)
80107501:	e8 ca fd ff ff       	call   801072d0 <setupkvm>
80107506:	85 c0                	test   %eax,%eax
80107508:	0f 84 f1 00 00 00    	je     801075ff <copyuvm_cow+0x10f>
8010750e:	89 c7                	mov    %eax,%edi
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107510:	8b 45 0c             	mov    0xc(%ebp),%eax
80107513:	85 c0                	test   %eax,%eax
80107515:	0f 84 b9 00 00 00    	je     801075d4 <copyuvm_cow+0xe4>
8010751b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010751e:	8b 7d 08             	mov    0x8(%ebp),%edi
80107521:	31 f6                	xor    %esi,%esi
80107523:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107527:	90                   	nop
  pde = &pgdir[PDX(va)];
80107528:	89 f0                	mov    %esi,%eax
8010752a:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
8010752d:	8b 04 87             	mov    (%edi,%eax,4),%eax
80107530:	a8 01                	test   $0x1,%al
80107532:	75 14                	jne    80107548 <copyuvm_cow+0x58>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80107534:	83 ec 0c             	sub    $0xc,%esp
80107537:	68 63 7f 10 80       	push   $0x80107f63
8010753c:	e8 2f 8f ff ff       	call   80100470 <panic>
80107541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107548:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010754a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
8010754f:	c1 ea 0a             	shr    $0xa,%edx
80107552:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107558:	8d 94 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%edx
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010755f:	85 d2                	test   %edx,%edx
80107561:	74 d1                	je     80107534 <copyuvm_cow+0x44>
    if(!(*pte & PTE_P))
80107563:	8b 02                	mov    (%edx),%eax
80107565:	a8 01                	test   $0x1,%al
80107567:	0f 84 9e 00 00 00    	je     8010760b <copyuvm_cow+0x11b>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010756d:	89 c3                	mov    %eax,%ebx
    // if((mem = kalloc()) == 0)
    //   goto bad;
    // memmove(mem, (char*)P2V(pa), PGSIZE);

    int new_flags = flags & ~PTE_W;
    *pte &= ~PTE_W;
8010756f:	89 c1                	mov    %eax,%ecx
    if(mappages(d, (void*)i, PGSIZE, pa, new_flags) < 0) {
80107571:	83 ec 08             	sub    $0x8,%esp
    int new_flags = flags & ~PTE_W;
80107574:	25 fd 0f 00 00       	and    $0xffd,%eax
    *pte &= ~PTE_W;
80107579:	83 e1 fd             	and    $0xfffffffd,%ecx
    pa = PTE_ADDR(*pte);
8010757c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    *pte &= ~PTE_W;
80107582:	89 0a                	mov    %ecx,(%edx)
    if(mappages(d, (void*)i, PGSIZE, pa, new_flags) < 0) {
80107584:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107589:	89 f2                	mov    %esi,%edx
8010758b:	50                   	push   %eax
8010758c:	53                   	push   %ebx
8010758d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107590:	e8 7b f7 ff ff       	call   80106d10 <mappages>
80107595:	83 c4 10             	add    $0x10,%esp
80107598:	85 c0                	test   %eax,%eax
8010759a:	78 54                	js     801075f0 <copyuvm_cow+0x100>
      // kfree(mem);
      goto bad;
    }

    page_to_refcnt[pa >> PTXSHIFT]++;
8010759c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010759f:	89 d8                	mov    %ebx,%eax
801075a1:	c1 eb 0a             	shr    $0xa,%ebx
    cprintf("copyuvm_cow: refcnt = %d of pageno %d\n", page_to_refcnt[pa >> PTXSHIFT], pa >> PTXSHIFT);
801075a4:	83 ec 04             	sub    $0x4,%esp
    page_to_refcnt[pa >> PTXSHIFT]++;
801075a7:	c1 e8 0c             	shr    $0xc,%eax
  for(i = 0; i < sz; i += PGSIZE){
801075aa:	81 c6 00 10 00 00    	add    $0x1000,%esi
    page_to_refcnt[pa >> PTXSHIFT]++;
801075b0:	01 cb                	add    %ecx,%ebx
801075b2:	8b 0b                	mov    (%ebx),%ecx
801075b4:	8d 51 01             	lea    0x1(%ecx),%edx
801075b7:	89 13                	mov    %edx,(%ebx)
    cprintf("copyuvm_cow: refcnt = %d of pageno %d\n", page_to_refcnt[pa >> PTXSHIFT], pa >> PTXSHIFT);
801075b9:	50                   	push   %eax
801075ba:	52                   	push   %edx
801075bb:	68 24 82 10 80       	push   $0x80108224
801075c0:	e8 db 91 ff ff       	call   801007a0 <cprintf>
  for(i = 0; i < sz; i += PGSIZE){
801075c5:	83 c4 10             	add    $0x10,%esp
801075c8:	3b 75 0c             	cmp    0xc(%ebp),%esi
801075cb:	0f 82 57 ff ff ff    	jb     80107528 <copyuvm_cow+0x38>
801075d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  }

  lcr3(V2P(pgdir));
801075d4:	8b 45 08             	mov    0x8(%ebp),%eax
801075d7:	05 00 00 00 80       	add    $0x80000000,%eax
801075dc:	0f 22 d8             	mov    %eax,%cr3
  return d;

bad:
  freevm(d);
  return 0;
}
801075df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075e2:	89 f8                	mov    %edi,%eax
801075e4:	5b                   	pop    %ebx
801075e5:	5e                   	pop    %esi
801075e6:	5f                   	pop    %edi
801075e7:	5d                   	pop    %ebp
801075e8:	c3                   	ret
801075e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  freevm(d);
801075f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801075f3:	83 ec 0c             	sub    $0xc,%esp
801075f6:	57                   	push   %edi
801075f7:	e8 54 fc ff ff       	call   80107250 <freevm>
  return 0;
801075fc:	83 c4 10             	add    $0x10,%esp
}
801075ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107602:	31 ff                	xor    %edi,%edi
}
80107604:	5b                   	pop    %ebx
80107605:	89 f8                	mov    %edi,%eax
80107607:	5e                   	pop    %esi
80107608:	5f                   	pop    %edi
80107609:	5d                   	pop    %ebp
8010760a:	c3                   	ret
      panic("copyuvm: page not present");
8010760b:	83 ec 0c             	sub    $0xc,%esp
8010760e:	68 7d 7f 10 80       	push   $0x80107f7d
80107613:	e8 58 8e ff ff       	call   80100470 <panic>
80107618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010761f:	90                   	nop

80107620 <uva2ka>:
//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107620:	55                   	push   %ebp
80107621:	89 e5                	mov    %esp,%ebp
80107623:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107626:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107629:	89 c1                	mov    %eax,%ecx
8010762b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010762e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107631:	f6 c2 01             	test   $0x1,%dl
80107634:	0f 84 f8 00 00 00    	je     80107732 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010763a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010763d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107643:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107644:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107649:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107650:	89 d0                	mov    %edx,%eax
80107652:	f7 d2                	not    %edx
80107654:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107659:	05 00 00 00 80       	add    $0x80000000,%eax
8010765e:	83 e2 05             	and    $0x5,%edx
80107661:	ba 00 00 00 00       	mov    $0x0,%edx
80107666:	0f 45 c2             	cmovne %edx,%eax
}
80107669:	c3                   	ret
8010766a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107670 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107670:	55                   	push   %ebp
80107671:	89 e5                	mov    %esp,%ebp
80107673:	57                   	push   %edi
80107674:	56                   	push   %esi
80107675:	53                   	push   %ebx
80107676:	83 ec 0c             	sub    $0xc,%esp
80107679:	8b 75 14             	mov    0x14(%ebp),%esi
8010767c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010767f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107682:	85 f6                	test   %esi,%esi
80107684:	75 51                	jne    801076d7 <copyout+0x67>
80107686:	e9 9d 00 00 00       	jmp    80107728 <copyout+0xb8>
8010768b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010768f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107690:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107696:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010769c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801076a2:	74 74                	je     80107718 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
801076a4:	89 fb                	mov    %edi,%ebx
801076a6:	29 c3                	sub    %eax,%ebx
801076a8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801076ae:	39 f3                	cmp    %esi,%ebx
801076b0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801076b3:	29 f8                	sub    %edi,%eax
801076b5:	83 ec 04             	sub    $0x4,%esp
801076b8:	01 c1                	add    %eax,%ecx
801076ba:	53                   	push   %ebx
801076bb:	52                   	push   %edx
801076bc:	89 55 10             	mov    %edx,0x10(%ebp)
801076bf:	51                   	push   %ecx
801076c0:	e8 cb d4 ff ff       	call   80104b90 <memmove>
    len -= n;
    buf += n;
801076c5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801076c8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801076ce:	83 c4 10             	add    $0x10,%esp
    buf += n;
801076d1:	01 da                	add    %ebx,%edx
  while(len > 0){
801076d3:	29 de                	sub    %ebx,%esi
801076d5:	74 51                	je     80107728 <copyout+0xb8>
  if(*pde & PTE_P){
801076d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801076da:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801076dc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801076de:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801076e1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801076e7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801076ea:	f6 c1 01             	test   $0x1,%cl
801076ed:	0f 84 46 00 00 00    	je     80107739 <copyout.cold>
  return &pgtab[PTX(va)];
801076f3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076f5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801076fb:	c1 eb 0c             	shr    $0xc,%ebx
801076fe:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107704:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010770b:	89 d9                	mov    %ebx,%ecx
8010770d:	f7 d1                	not    %ecx
8010770f:	83 e1 05             	and    $0x5,%ecx
80107712:	0f 84 78 ff ff ff    	je     80107690 <copyout+0x20>
  }
  return 0;
}
80107718:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010771b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107720:	5b                   	pop    %ebx
80107721:	5e                   	pop    %esi
80107722:	5f                   	pop    %edi
80107723:	5d                   	pop    %ebp
80107724:	c3                   	ret
80107725:	8d 76 00             	lea    0x0(%esi),%esi
80107728:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010772b:	31 c0                	xor    %eax,%eax
}
8010772d:	5b                   	pop    %ebx
8010772e:	5e                   	pop    %esi
8010772f:	5f                   	pop    %edi
80107730:	5d                   	pop    %ebp
80107731:	c3                   	ret

80107732 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107732:	a1 00 00 00 00       	mov    0x0,%eax
80107737:	0f 0b                	ud2

80107739 <copyout.cold>:
80107739:	a1 00 00 00 00       	mov    0x0,%eax
8010773e:	0f 0b                	ud2

80107740 <cow_fault>:
#include "spinlock.h"


void cow_fault(){
	// create new page entry when page fault occurs due to cow
80107740:	c3                   	ret
80107741:	66 90                	xchg   %ax,%ax
80107743:	66 90                	xchg   %ax,%ax
80107745:	66 90                	xchg   %ax,%ax
80107747:	66 90                	xchg   %ax,%ax
80107749:	66 90                	xchg   %ax,%ax
8010774b:	66 90                	xchg   %ax,%ax
8010774d:	66 90                	xchg   %ax,%ax
8010774f:	90                   	nop

80107750 <swapinit>:

#define SWAPBASE 2
#define NPAGE (SWAPBLOCKS / BPPAGE)

struct swapslothdr swap_slots[NPAGE];
void swapinit(void){
80107750:	55                   	push   %ebp
80107751:	b8 40 61 11 80       	mov    $0x80116140,%eax
80107756:	ba 02 00 00 00       	mov    $0x2,%edx
8010775b:	89 e5                	mov    %esp,%ebp
8010775d:	83 ec 08             	sub    $0x8,%esp
	for(int i = 0 ; i < NPAGE ; i++){
		swap_slots[i].is_free = FREE;
		swap_slots[i].page_perm = 0;
		swap_slots[i].blockno = SWAPBASE + i * BPPAGE;
80107760:	89 50 08             	mov    %edx,0x8(%eax)
	for(int i = 0 ; i < NPAGE ; i++){
80107763:	83 c0 0c             	add    $0xc,%eax
80107766:	83 c2 08             	add    $0x8,%edx
		swap_slots[i].is_free = FREE;
80107769:	c7 40 f4 01 00 00 00 	movl   $0x1,-0xc(%eax)
		swap_slots[i].page_perm = 0;
80107770:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
	for(int i = 0 ; i < NPAGE ; i++){
80107777:	3d 00 74 11 80       	cmp    $0x80117400,%eax
8010777c:	75 e2                	jne    80107760 <swapinit+0x10>
	}
	cprintf("Swap slots initialized\n");
8010777e:	83 ec 0c             	sub    $0xc,%esp
80107781:	68 97 7f 10 80       	push   $0x80107f97
80107786:	e8 15 90 ff ff       	call   801007a0 <cprintf>
}
8010778b:	83 c4 10             	add    $0x10,%esp
8010778e:	c9                   	leave
8010778f:	c3                   	ret

80107790 <swap_out>:
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

void swap_out(){
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	57                   	push   %edi
80107794:	56                   	push   %esi
80107795:	53                   	push   %ebx
80107796:	83 ec 0c             	sub    $0xc,%esp
	pte_t* pte = final_page();
80107799:	e8 82 ce ff ff       	call   80104620 <final_page>
8010779e:	ba 40 61 11 80       	mov    $0x80116140,%edx
801077a3:	89 c6                	mov    %eax,%esi
	for(int i = 0 ; i < NPAGE; i++){
801077a5:	31 c0                	xor    %eax,%eax
801077a7:	eb 14                	jmp    801077bd <swap_out+0x2d>
801077a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077b0:	83 c0 01             	add    $0x1,%eax
801077b3:	83 c2 0c             	add    $0xc,%edx
801077b6:	3d 90 01 00 00       	cmp    $0x190,%eax
801077bb:	74 5a                	je     80107817 <swap_out+0x87>
		if(swap_slots[i].is_free == FREE){
801077bd:	83 3a 01             	cmpl   $0x1,(%edx)
801077c0:	75 ee                	jne    801077b0 <swap_out+0x20>
			swap_slots[i].is_free = NOT_FREE;
801077c2:	8d 04 40             	lea    (%eax,%eax,2),%eax
			swap_slots[i].page_perm = PTE_FLAGS(*pte);
			uint pa = PTE_ADDR(*pte);
			write_page_to_swap(swap_slots[i].blockno, (char*)P2V(pa));
801077c5:	83 ec 08             	sub    $0x8,%esp
			swap_slots[i].is_free = NOT_FREE;
801077c8:	c1 e0 02             	shl    $0x2,%eax
801077cb:	c7 80 40 61 11 80 00 	movl   $0x0,-0x7fee9ec0(%eax)
801077d2:	00 00 00 
801077d5:	8d b8 40 61 11 80    	lea    -0x7fee9ec0(%eax),%edi
			swap_slots[i].page_perm = PTE_FLAGS(*pte);
801077db:	8b 06                	mov    (%esi),%eax
801077dd:	25 ff 0f 00 00       	and    $0xfff,%eax
801077e2:	89 47 04             	mov    %eax,0x4(%edi)
			uint pa = PTE_ADDR(*pte);
801077e5:	8b 1e                	mov    (%esi),%ebx
801077e7:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
			write_page_to_swap(swap_slots[i].blockno, (char*)P2V(pa));
801077ed:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801077f3:	53                   	push   %ebx
801077f4:	ff 77 08             	push   0x8(%edi)
801077f7:	e8 84 8a ff ff       	call   80100280 <write_page_to_swap>
			kfree((char*)P2V(pa));
801077fc:	89 1c 24             	mov    %ebx,(%esp)
801077ff:	e8 9c ad ff ff       	call   801025a0 <kfree>
			*pte = swap_slots[i].blockno << PTXSHIFT;
80107804:	8b 47 08             	mov    0x8(%edi),%eax
80107807:	c1 e0 0c             	shl    $0xc,%eax
			*pte |= PTE_FLAGS(*pte);
			*pte |= PTE_SW;
8010780a:	83 c8 08             	or     $0x8,%eax
8010780d:	89 06                	mov    %eax,(%esi)
			*pte &= ~PTE_P;
			return;
		}
	}
	panic("Swap full\n");
}
8010780f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107812:	5b                   	pop    %ebx
80107813:	5e                   	pop    %esi
80107814:	5f                   	pop    %edi
80107815:	5d                   	pop    %ebp
80107816:	c3                   	ret
	panic("Swap full\n");
80107817:	83 ec 0c             	sub    $0xc,%esp
8010781a:	68 af 7f 10 80       	push   $0x80107faf
8010781f:	e8 4c 8c ff ff       	call   80100470 <panic>
80107824:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010782b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010782f:	90                   	nop

80107830 <cow_page>:
// the following function is called when a copy is needed to be created for the page pointed to by pte
// constratin : pte is present in the pagetable
void cow_page(pte_t * pte){
80107830:	55                   	push   %ebp
80107831:	89 e5                	mov    %esp,%ebp
80107833:	57                   	push   %edi
80107834:	56                   	push   %esi
80107835:	53                   	push   %ebx
80107836:	83 ec 0c             	sub    $0xc,%esp
80107839:	8b 75 08             	mov    0x8(%ebp),%esi
	char * copy_mem = kalloc();
8010783c:	e8 7f af ff ff       	call   801027c0 <kalloc>
80107841:	89 c3                	mov    %eax,%ebx
	int * page_to_refcnt = get_refcnt_table();
80107843:	e8 48 ad ff ff       	call   80102590 <get_refcnt_table>
	// allocating new page using kalloc
	if(copy_mem == 0){
80107848:	85 db                	test   %ebx,%ebx
8010784a:	74 7e                	je     801078ca <cow_page+0x9a>
8010784c:	89 c7                	mov    %eax,%edi
		panic("kalloc failing in cow_page\n");
	}
	// whe arent we setting the refcnt of the new page to 1
	cprintf("before refcnt = %d", page_to_refcnt[(*pte) >> PTXSHIFT]);
8010784e:	8b 06                	mov    (%esi),%eax
80107850:	83 ec 08             	sub    $0x8,%esp
80107853:	c1 e8 0c             	shr    $0xc,%eax
80107856:	ff 34 87             	push   (%edi,%eax,4)
80107859:	68 d6 7f 10 80       	push   $0x80107fd6
8010785e:	e8 3d 8f ff ff       	call   801007a0 <cprintf>
	page_to_refcnt[(*pte) >> PTXSHIFT]--;
80107863:	8b 06                	mov    (%esi),%eax
80107865:	c1 e8 0c             	shr    $0xc,%eax
80107868:	83 2c 87 01          	subl   $0x1,(%edi,%eax,4)
	cprintf("after refcnt = %d", page_to_refcnt[(*pte) >> PTXSHIFT]);
8010786c:	58                   	pop    %eax
8010786d:	8b 06                	mov    (%esi),%eax
8010786f:	5a                   	pop    %edx
80107870:	c1 e8 0c             	shr    $0xc,%eax
80107873:	ff 34 87             	push   (%edi,%eax,4)
80107876:	68 e9 7f 10 80       	push   $0x80107fe9
8010787b:	e8 20 8f ff ff       	call   801007a0 <cprintf>

	memmove(copy_mem, (char*)P2V(PTE_ADDR(*pte)), PGSIZE);
80107880:	83 c4 0c             	add    $0xc,%esp
80107883:	68 00 10 00 00       	push   $0x1000
80107888:	8b 06                	mov    (%esi),%eax
8010788a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010788f:	05 00 00 00 80       	add    $0x80000000,%eax
80107894:	50                   	push   %eax
80107895:	53                   	push   %ebx
	// now modify the pgdir
	*pte = V2P(copy_mem) | PTE_FLAGS(*pte) | PTE_W;
80107896:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
	memmove(copy_mem, (char*)P2V(PTE_ADDR(*pte)), PGSIZE);
8010789c:	e8 ef d2 ff ff       	call   80104b90 <memmove>
	*pte = V2P(copy_mem) | PTE_FLAGS(*pte) | PTE_W;
801078a1:	8b 06                	mov    (%esi),%eax
801078a3:	25 ff 0f 00 00       	and    $0xfff,%eax
801078a8:	09 c3                	or     %eax,%ebx
801078aa:	83 cb 02             	or     $0x2,%ebx
801078ad:	89 1e                	mov    %ebx,(%esi)
	lcr3(V2P(myproc()->pgdir));
801078af:	e8 7c c2 ff ff       	call   80103b30 <myproc>
801078b4:	8b 40 08             	mov    0x8(%eax),%eax
801078b7:	05 00 00 00 80       	add    $0x80000000,%eax
801078bc:	0f 22 d8             	mov    %eax,%cr3

}
801078bf:	83 c4 10             	add    $0x10,%esp
801078c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078c5:	5b                   	pop    %ebx
801078c6:	5e                   	pop    %esi
801078c7:	5f                   	pop    %edi
801078c8:	5d                   	pop    %ebp
801078c9:	c3                   	ret
		panic("kalloc failing in cow_page\n");
801078ca:	83 ec 0c             	sub    $0xc,%esp
801078cd:	68 ba 7f 10 80       	push   $0x80107fba
801078d2:	e8 99 8b ff ff       	call   80100470 <panic>
801078d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078de:	66 90                	xchg   %ax,%ax

801078e0 <handle_page_fault>:


void handle_page_fault(){
801078e0:	55                   	push   %ebp
801078e1:	89 e5                	mov    %esp,%ebp
801078e3:	57                   	push   %edi
801078e4:	56                   	push   %esi
801078e5:	53                   	push   %ebx
801078e6:	83 ec 1c             	sub    $0x1c,%esp
	// cprintf("Page fault\n");
	int * page_to_refcnt = get_refcnt_table();
801078e9:	e8 a2 ac ff ff       	call   80102590 <get_refcnt_table>
801078ee:	89 c7                	mov    %eax,%edi
  asm volatile("movl %%cr2,%0" : "=r" (val));
801078f0:	0f 20 d6             	mov    %cr2,%esi
	uint va = rcr2();
	struct proc* p = myproc();
801078f3:	e8 38 c2 ff ff       	call   80103b30 <myproc>
  pde = &pgdir[PDX(va)];
801078f8:	89 f2                	mov    %esi,%edx
	struct proc* p = myproc();
801078fa:	89 c3                	mov    %eax,%ebx
  if(*pde & PTE_P){
801078fc:	8b 40 08             	mov    0x8(%eax),%eax
  pde = &pgdir[PDX(va)];
801078ff:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107902:	8b 04 90             	mov    (%eax,%edx,4),%eax
80107905:	a8 01                	test   $0x1,%al
80107907:	0f 84 34 01 00 00    	je     80107a41 <handle_page_fault.cold>
  return &pgtab[PTX(va)];
8010790d:	c1 ee 0a             	shr    $0xa,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107910:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107915:	89 f1                	mov    %esi,%ecx
80107917:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
8010791d:	8d b4 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%esi
80107924:	89 4d e0             	mov    %ecx,-0x20(%ebp)
	pte_t * pte = walkpgdir(p->pgdir, (void*) va, 0);
	if(!(*pte & PTE_U)){
80107927:	8b 0e                	mov    (%esi),%ecx
80107929:	f6 c1 04             	test   $0x4,%cl
8010792c:	0f 84 f5 00 00 00    	je     80107a27 <handle_page_fault+0x147>
		panic("OS pages cant be swapped");
	}
	if(*pte & PTE_P){
80107932:	83 e1 01             	and    $0x1,%ecx
80107935:	0f 85 95 00 00 00    	jne    801079d0 <handle_page_fault+0xf0>
			*pte = *pte | PTE_W;
			lcr3(V2P(p->pgdir));
		}
	}
	else {
		cprintf("normal pagefault\n");
8010793b:	83 ec 0c             	sub    $0xc,%esp
8010793e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107941:	68 2b 80 10 80       	push   $0x8010802b
80107946:	e8 55 8e ff ff       	call   801007a0 <cprintf>
		char * pg = kalloc();
8010794b:	e8 70 ae ff ff       	call   801027c0 <kalloc>
		if(pg == 0){
80107950:	83 c4 10             	add    $0x10,%esp
80107953:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107956:	85 c0                	test   %eax,%eax
		char * pg = kalloc();
80107958:	89 c7                	mov    %eax,%edi
		if(pg == 0){
8010795a:	0f 84 d4 00 00 00    	je     80107a34 <handle_page_fault+0x154>
  if(*pde & PTE_P){
80107960:	8b 43 08             	mov    0x8(%ebx),%eax
			panic("kalloc failing in pagefault\n");
		}
		p->rss += PGSIZE;
80107963:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
  if(*pde & PTE_P){
8010796a:	8b 04 90             	mov    (%eax,%edx,4),%eax
8010796d:	a8 01                	test   $0x1,%al
8010796f:	0f 84 cc 00 00 00    	je     80107a41 <handle_page_fault.cold>
  return &pgtab[PTX(va)];
80107975:	8b 5d e0             	mov    -0x20(%ebp),%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107978:	25 00 f0 ff ff       	and    $0xfffff000,%eax
		pte_t * pte = walkpgdir(p->pgdir, (void*) va, 0);
		uint blockno = *pte >> PTXSHIFT;
		read_page_from_swap(blockno, pg);
8010797d:	83 ec 08             	sub    $0x8,%esp
  return &pgtab[PTX(va)];
80107980:	8d 9c 03 00 00 00 80 	lea    -0x80000000(%ebx,%eax,1),%ebx
		uint blockno = *pte >> PTXSHIFT;
80107987:	8b 33                	mov    (%ebx),%esi
		read_page_from_swap(blockno, pg);
80107989:	57                   	push   %edi
		int swap_slot_i = (blockno - SWAPBASE) / BPPAGE;
		*pte = (V2P(pg) & ~0xFFF)  | swap_slots[swap_slot_i].page_perm;
8010798a:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107990:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
		uint blockno = *pte >> PTXSHIFT;
80107996:	c1 ee 0c             	shr    $0xc,%esi
		read_page_from_swap(blockno, pg);
80107999:	56                   	push   %esi
8010799a:	e8 71 89 ff ff       	call   80100310 <read_page_from_swap>
		int swap_slot_i = (blockno - SWAPBASE) / BPPAGE;
8010799f:	8d 46 fe             	lea    -0x2(%esi),%eax
		*pte |= PTE_P;
		swap_slots[swap_slot_i].is_free = FREE;
801079a2:	83 c4 10             	add    $0x10,%esp
		int swap_slot_i = (blockno - SWAPBASE) / BPPAGE;
801079a5:	c1 e8 03             	shr    $0x3,%eax
		*pte = (V2P(pg) & ~0xFFF)  | swap_slots[swap_slot_i].page_perm;
801079a8:	8d 04 40             	lea    (%eax,%eax,2),%eax
801079ab:	c1 e0 02             	shl    $0x2,%eax
801079ae:	0b b8 44 61 11 80    	or     -0x7fee9ebc(%eax),%edi
		*pte |= PTE_P;
801079b4:	83 cf 01             	or     $0x1,%edi
801079b7:	89 3b                	mov    %edi,(%ebx)
		swap_slots[swap_slot_i].is_free = FREE;
801079b9:	c7 80 40 61 11 80 01 	movl   $0x1,-0x7fee9ec0(%eax)
801079c0:	00 00 00 
	}
801079c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079c6:	5b                   	pop    %ebx
801079c7:	5e                   	pop    %esi
801079c8:	5f                   	pop    %edi
801079c9:	5d                   	pop    %ebp
801079ca:	c3                   	ret
801079cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079cf:	90                   	nop
		cprintf("page fault due to cow\n");
801079d0:	83 ec 0c             	sub    $0xc,%esp
801079d3:	68 14 80 10 80       	push   $0x80108014
801079d8:	e8 c3 8d ff ff       	call   801007a0 <cprintf>
		if(page_to_refcnt[*pte >> PTXSHIFT] > 1){
801079dd:	8b 16                	mov    (%esi),%edx
801079df:	83 c4 10             	add    $0x10,%esp
801079e2:	c1 ea 0c             	shr    $0xc,%edx
801079e5:	83 3c 97 01          	cmpl   $0x1,(%edi,%edx,4)
801079e9:	7e 15                	jle    80107a00 <handle_page_fault+0x120>
			cow_page(pte);
801079eb:	83 ec 0c             	sub    $0xc,%esp
801079ee:	56                   	push   %esi
801079ef:	e8 3c fe ff ff       	call   80107830 <cow_page>
801079f4:	83 c4 10             	add    $0x10,%esp
801079f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079fa:	5b                   	pop    %ebx
801079fb:	5e                   	pop    %esi
801079fc:	5f                   	pop    %edi
801079fd:	5d                   	pop    %ebp
801079fe:	c3                   	ret
801079ff:	90                   	nop
			cprintf("no duplicatin is needed for pg = %d", *pte >> PTXSHIFT);
80107a00:	83 ec 08             	sub    $0x8,%esp
80107a03:	52                   	push   %edx
80107a04:	68 4c 82 10 80       	push   $0x8010824c
80107a09:	e8 92 8d ff ff       	call   801007a0 <cprintf>
			*pte = *pte | PTE_W;
80107a0e:	83 0e 02             	orl    $0x2,(%esi)
			lcr3(V2P(p->pgdir));
80107a11:	8b 43 08             	mov    0x8(%ebx),%eax
80107a14:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107a19:	0f 22 d8             	mov    %eax,%cr3
}
80107a1c:	83 c4 10             	add    $0x10,%esp
80107a1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a22:	5b                   	pop    %ebx
80107a23:	5e                   	pop    %esi
80107a24:	5f                   	pop    %edi
80107a25:	5d                   	pop    %ebp
80107a26:	c3                   	ret
		panic("OS pages cant be swapped");
80107a27:	83 ec 0c             	sub    $0xc,%esp
80107a2a:	68 fb 7f 10 80       	push   $0x80107ffb
80107a2f:	e8 3c 8a ff ff       	call   80100470 <panic>
			panic("kalloc failing in pagefault\n");
80107a34:	83 ec 0c             	sub    $0xc,%esp
80107a37:	68 3d 80 10 80       	push   $0x8010803d
80107a3c:	e8 2f 8a ff ff       	call   80100470 <panic>

80107a41 <handle_page_fault.cold>:
		uint blockno = *pte >> PTXSHIFT;
80107a41:	a1 00 00 00 00       	mov    0x0,%eax
80107a46:	0f 0b                	ud2
