
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
8010002d:	b8 30 32 10 80       	mov    $0x80103230,%eax
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
8010004c:	68 a0 81 10 80       	push   $0x801081a0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 25 48 00 00       	call   80104880 <initlock>
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
80100092:	68 a7 81 10 80       	push   $0x801081a7
80100097:	50                   	push   %eax
80100098:	e8 b3 46 00 00       	call   80104750 <initsleeplock>
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
801000e4:	e8 87 49 00 00       	call   80104a70 <acquire>
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
80100162:	e8 a9 48 00 00       	call   80104a10 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 46 00 00       	call   80104790 <acquiresleep>
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
801001a1:	68 ae 81 10 80       	push   $0x801081ae
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
801001be:	e8 6d 46 00 00       	call   80104830 <holdingsleep>
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
801001dc:	68 bf 81 10 80       	push   $0x801081bf
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
801001ff:	e8 2c 46 00 00       	call   80104830 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 dc 45 00 00       	call   801047f0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 50 48 00 00       	call   80104a70 <acquire>
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
80100269:	e9 a2 47 00 00       	jmp    80104a10 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 c6 81 10 80       	push   $0x801081c6
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
801002b2:	e8 49 49 00 00       	call   80104c00 <memmove>
  if(!holdingsleep(&b->lock))
801002b7:	8d 47 0c             	lea    0xc(%edi),%eax
801002ba:	89 04 24             	mov    %eax,(%esp)
801002bd:	e8 6e 45 00 00       	call   80104830 <holdingsleep>
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
801002fb:	68 bf 81 10 80       	push   $0x801081bf
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
8010034b:	e8 b0 48 00 00       	call   80104c00 <memmove>
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
80100390:	e8 db 46 00 00       	call   80104a70 <acquire>
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
801003bd:	e8 de 3e 00 00       	call   801042a0 <sleep>
    while(input.r == input.w){
801003c2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801003c7:	83 c4 10             	add    $0x10,%esp
801003ca:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801003d0:	75 36                	jne    80100408 <consoleread+0x98>
      if(myproc()->killed){
801003d2:	e8 79 37 00 00       	call   80103b50 <myproc>
801003d7:	8b 48 28             	mov    0x28(%eax),%ecx
801003da:	85 c9                	test   %ecx,%ecx
801003dc:	74 d2                	je     801003b0 <consoleread+0x40>
        release(&cons.lock);
801003de:	83 ec 0c             	sub    $0xc,%esp
801003e1:	68 20 ff 10 80       	push   $0x8010ff20
801003e6:	e8 25 46 00 00       	call   80104a10 <release>
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
8010043c:	e8 cf 45 00 00       	call   80104a10 <release>
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
80100489:	e8 42 26 00 00       	call   80102ad0 <lapicid>
8010048e:	83 ec 08             	sub    $0x8,%esp
80100491:	50                   	push   %eax
80100492:	68 cd 81 10 80       	push   $0x801081cd
80100497:	e8 04 03 00 00       	call   801007a0 <cprintf>
  cprintf(s);
8010049c:	58                   	pop    %eax
8010049d:	ff 75 08             	push   0x8(%ebp)
801004a0:	e8 fb 02 00 00       	call   801007a0 <cprintf>
  cprintf("\n");
801004a5:	c7 04 24 82 86 10 80 	movl   $0x80108682,(%esp)
801004ac:	e8 ef 02 00 00       	call   801007a0 <cprintf>
  getcallerpcs(&s, pcs);
801004b1:	8d 45 08             	lea    0x8(%ebp),%eax
801004b4:	5a                   	pop    %edx
801004b5:	59                   	pop    %ecx
801004b6:	53                   	push   %ebx
801004b7:	50                   	push   %eax
801004b8:	e8 e3 43 00 00       	call   801048a0 <getcallerpcs>
  for(i=0; i<10; i++)
801004bd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801004c0:	83 ec 08             	sub    $0x8,%esp
801004c3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801004c5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801004c8:	68 e1 81 10 80       	push   $0x801081e1
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
8010050f:	e8 bc 5c 00 00       	call   801061d0 <uartputc>
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
801005da:	e8 f1 5b 00 00       	call   801061d0 <uartputc>
801005df:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801005e6:	e8 e5 5b 00 00       	call   801061d0 <uartputc>
801005eb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801005f2:	e8 d9 5b 00 00       	call   801061d0 <uartputc>
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
80100651:	e8 aa 45 00 00       	call   80104c00 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100656:	b8 80 07 00 00       	mov    $0x780,%eax
8010065b:	83 c4 0c             	add    $0xc,%esp
8010065e:	29 d8                	sub    %ebx,%eax
80100660:	01 c0                	add    %eax,%eax
80100662:	50                   	push   %eax
80100663:	6a 00                	push   $0x0
80100665:	56                   	push   %esi
80100666:	e8 05 45 00 00       	call   80104b70 <memset>
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
80100693:	68 e5 81 10 80       	push   $0x801081e5
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
801006bb:	e8 b0 43 00 00       	call   80104a70 <acquire>
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
801006f4:	e8 17 43 00 00       	call   80104a10 <release>
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
8010073b:	0f b6 92 84 87 10 80 	movzbl -0x7fef787c(%edx),%edx
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
801008c8:	e8 a3 41 00 00       	call   80104a70 <acquire>
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
801008eb:	e8 20 41 00 00       	call   80104a10 <release>
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
8010092d:	bf f8 81 10 80       	mov    $0x801081f8,%edi
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
8010097c:	68 ff 81 10 80       	push   $0x801081ff
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
801009a3:	e8 c8 40 00 00       	call   80104a70 <acquire>
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
801009dd:	e8 2e 40 00 00       	call   80104a10 <release>
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
80100b1c:	e8 3f 38 00 00       	call   80104360 <wakeup>
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
80100b3f:	e9 fc 38 00 00       	jmp    80104440 <procdump>
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
80100b56:	68 08 82 10 80       	push   $0x80108208
80100b5b:	68 20 ff 10 80       	push   $0x8010ff20
80100b60:	e8 1b 3d 00 00       	call   80104880 <initlock>

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
80100bac:	e8 9f 2f 00 00       	call   80103b50 <myproc>
80100bb1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100bb7:	e8 84 23 00 00       	call   80102f40 <begin_op>

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
80100c0a:	e8 81 68 00 00       	call   80107490 <setupkvm>
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
80100c7b:	e8 10 66 00 00       	call   80107290 <allocuvm>
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
80100cb1:	e8 0a 65 00 00       	call   801071c0 <loaduvm>
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
80100cf3:	e8 18 67 00 00       	call   80107410 <freevm>
  if(ip){
80100cf8:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100cfb:	83 ec 0c             	sub    $0xc,%esp
80100cfe:	57                   	push   %edi
80100cff:	e8 1c 0e 00 00       	call   80101b20 <iunlockput>
    end_op();
80100d04:	e8 a7 22 00 00       	call   80102fb0 <end_op>
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
80100d41:	e8 6a 22 00 00       	call   80102fb0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d46:	83 c4 0c             	add    $0xc,%esp
80100d49:	53                   	push   %ebx
80100d4a:	56                   	push   %esi
80100d4b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100d51:	56                   	push   %esi
80100d52:	e8 39 65 00 00       	call   80107290 <allocuvm>
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
80100d73:	e8 b8 67 00 00       	call   80107530 <clearpteu>
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
80100dba:	e8 a1 3f 00 00       	call   80104d60 <strlen>
80100dbf:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dc1:	58                   	pop    %eax
80100dc2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dc5:	83 eb 01             	sub    $0x1,%ebx
80100dc8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dcb:	e8 90 3f 00 00       	call   80104d60 <strlen>
80100dd0:	83 c0 01             	add    $0x1,%eax
80100dd3:	50                   	push   %eax
80100dd4:	ff 34 b7             	push   (%edi,%esi,4)
80100dd7:	53                   	push   %ebx
80100dd8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100dde:	e8 4d 6b 00 00       	call   80107930 <copyout>
80100de3:	83 c4 20             	add    $0x20,%esp
80100de6:	85 c0                	test   %eax,%eax
80100de8:	79 ae                	jns    80100d98 <exec+0x1f8>
    freevm(pgdir);
80100dea:	83 ec 0c             	sub    $0xc,%esp
80100ded:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100df3:	e8 18 66 00 00       	call   80107410 <freevm>
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
80100e4f:	e8 dc 6a 00 00       	call   80107930 <copyout>
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
80100e8f:	e8 8c 3e 00 00       	call   80104d20 <safestrcpy>
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
80100ebb:	e8 70 61 00 00       	call   80107030 <switchuvm>
  freevm(oldpgdir);
80100ec0:	89 34 24             	mov    %esi,(%esp)
80100ec3:	e8 48 65 00 00       	call   80107410 <freevm>
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
80100f02:	e8 a9 20 00 00       	call   80102fb0 <end_op>
    cprintf("exec: fail\n");
80100f07:	83 ec 0c             	sub    $0xc,%esp
80100f0a:	68 10 82 10 80       	push   $0x80108210
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
80100f26:	68 1c 82 10 80       	push   $0x8010821c
80100f2b:	68 60 ff 10 80       	push   $0x8010ff60
80100f30:	e8 4b 39 00 00       	call   80104880 <initlock>
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
80100f51:	e8 1a 3b 00 00       	call   80104a70 <acquire>
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
80100f81:	e8 8a 3a 00 00       	call   80104a10 <release>
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
80100f9a:	e8 71 3a 00 00       	call   80104a10 <release>
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
80100fbf:	e8 ac 3a 00 00       	call   80104a70 <acquire>
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
80100fdc:	e8 2f 3a 00 00       	call   80104a10 <release>
  return f;
}
80100fe1:	89 d8                	mov    %ebx,%eax
80100fe3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fe6:	c9                   	leave
80100fe7:	c3                   	ret
    panic("filedup");
80100fe8:	83 ec 0c             	sub    $0xc,%esp
80100feb:	68 23 82 10 80       	push   $0x80108223
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
80101011:	e8 5a 3a 00 00       	call   80104a70 <acquire>
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
8010104c:	e8 bf 39 00 00       	call   80104a10 <release>

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
8010107e:	e9 8d 39 00 00       	jmp    80104a10 <release>
80101083:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101087:	90                   	nop
    begin_op();
80101088:	e8 b3 1e 00 00       	call   80102f40 <begin_op>
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
801010a2:	e9 09 1f 00 00       	jmp    80102fb0 <end_op>
801010a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ae:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801010b0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801010b4:	83 ec 08             	sub    $0x8,%esp
801010b7:	53                   	push   %ebx
801010b8:	56                   	push   %esi
801010b9:	e8 42 26 00 00       	call   80103700 <pipeclose>
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
801010cc:	68 2b 82 10 80       	push   $0x8010822b
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
8010119d:	e9 1e 27 00 00       	jmp    801038c0 <piperead>
801011a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801011a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801011ad:	eb d7                	jmp    80101186 <fileread+0x56>
  panic("fileread");
801011af:	83 ec 0c             	sub    $0xc,%esp
801011b2:	68 35 82 10 80       	push   $0x80108235
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
80101219:	e8 92 1d 00 00       	call   80102fb0 <end_op>

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
8010123e:	e8 fd 1c 00 00       	call   80102f40 <begin_op>
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
80101275:	e8 36 1d 00 00       	call   80102fb0 <end_op>
      if(r < 0)
8010127a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010127d:	83 c4 10             	add    $0x10,%esp
80101280:	85 c0                	test   %eax,%eax
80101282:	75 14                	jne    80101298 <filewrite+0xd8>
        panic("short filewrite");
80101284:	83 ec 0c             	sub    $0xc,%esp
80101287:	68 3e 82 10 80       	push   $0x8010823e
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
801012b9:	e9 e2 24 00 00       	jmp    801037a0 <pipewrite>
  panic("filewrite");
801012be:	83 ec 0c             	sub    $0xc,%esp
801012c1:	68 44 82 10 80       	push   $0x80108244
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
80101379:	68 4e 82 10 80       	push   $0x8010824e
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
80101395:	e8 86 1d 00 00       	call   80103120 <log_write>
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
801013bd:	e8 ae 37 00 00       	call   80104b70 <memset>
  log_write(bp);
801013c2:	89 1c 24             	mov    %ebx,(%esp)
801013c5:	e8 56 1d 00 00       	call   80103120 <log_write>
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
801013fa:	e8 71 36 00 00       	call   80104a70 <acquire>
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
80101467:	e8 a4 35 00 00       	call   80104a10 <release>

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
80101495:	e8 76 35 00 00       	call   80104a10 <release>
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
801014c8:	68 64 82 10 80       	push   $0x80108264
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
8010152d:	e8 ee 1b 00 00       	call   80103120 <log_write>
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
80101547:	68 74 82 10 80       	push   $0x80108274
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
801015d5:	e8 46 1b 00 00       	call   80103120 <log_write>
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
80101625:	68 87 82 10 80       	push   $0x80108287
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
80101651:	e8 aa 35 00 00       	call   80104c00 <memmove>
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
8010167c:	68 9a 82 10 80       	push   $0x8010829a
80101681:	68 60 09 11 80       	push   $0x80110960
80101686:	e8 f5 31 00 00       	call   80104880 <initlock>
  for(i = 0; i < NINODE; i++) {
8010168b:	83 c4 10             	add    $0x10,%esp
8010168e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101690:	83 ec 08             	sub    $0x8,%esp
80101693:	68 a1 82 10 80       	push   $0x801082a1
80101698:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101699:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010169f:	e8 ac 30 00 00       	call   80104750 <initsleeplock>
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
801016cc:	e8 2f 35 00 00       	call   80104c00 <memmove>
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
80101703:	68 98 87 10 80       	push   $0x80108798
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
8010179e:	e8 cd 33 00 00       	call   80104b70 <memset>
      dip->type = type;
801017a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017ad:	89 1c 24             	mov    %ebx,(%esp)
801017b0:	e8 6b 19 00 00       	call   80103120 <log_write>
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
801017d3:	68 a7 82 10 80       	push   $0x801082a7
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
80101841:	e8 ba 33 00 00       	call   80104c00 <memmove>
  log_write(bp);
80101846:	89 34 24             	mov    %esi,(%esp)
80101849:	e8 d2 18 00 00       	call   80103120 <log_write>
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
8010186f:	e8 fc 31 00 00       	call   80104a70 <acquire>
  ip->ref++;
80101874:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101878:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010187f:	e8 8c 31 00 00       	call   80104a10 <release>
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
801018b2:	e8 d9 2e 00 00       	call   80104790 <acquiresleep>
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
80101928:	e8 d3 32 00 00       	call   80104c00 <memmove>
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
8010194d:	68 bf 82 10 80       	push   $0x801082bf
80101952:	e8 19 eb ff ff       	call   80100470 <panic>
    panic("ilock");
80101957:	83 ec 0c             	sub    $0xc,%esp
8010195a:	68 b9 82 10 80       	push   $0x801082b9
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
80101983:	e8 a8 2e 00 00       	call   80104830 <holdingsleep>
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
8010199f:	e9 4c 2e 00 00       	jmp    801047f0 <releasesleep>
    panic("iunlock");
801019a4:	83 ec 0c             	sub    $0xc,%esp
801019a7:	68 ce 82 10 80       	push   $0x801082ce
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
801019d0:	e8 bb 2d 00 00       	call   80104790 <acquiresleep>
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
801019ea:	e8 01 2e 00 00       	call   801047f0 <releasesleep>
  acquire(&icache.lock);
801019ef:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801019f6:	e8 75 30 00 00       	call   80104a70 <acquire>
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
80101a10:	e9 fb 2f 00 00       	jmp    80104a10 <release>
80101a15:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101a18:	83 ec 0c             	sub    $0xc,%esp
80101a1b:	68 60 09 11 80       	push   $0x80110960
80101a20:	e8 4b 30 00 00       	call   80104a70 <acquire>
    int r = ip->ref;
80101a25:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a28:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101a2f:	e8 dc 2f 00 00       	call   80104a10 <release>
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
80101b33:	e8 f8 2c 00 00       	call   80104830 <holdingsleep>
80101b38:	83 c4 10             	add    $0x10,%esp
80101b3b:	85 c0                	test   %eax,%eax
80101b3d:	74 21                	je     80101b60 <iunlockput+0x40>
80101b3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b42:	85 c0                	test   %eax,%eax
80101b44:	7e 1a                	jle    80101b60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101b46:	83 ec 0c             	sub    $0xc,%esp
80101b49:	56                   	push   %esi
80101b4a:	e8 a1 2c 00 00       	call   801047f0 <releasesleep>
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
80101b63:	68 ce 82 10 80       	push   $0x801082ce
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
80101c47:	e8 b4 2f 00 00       	call   80104c00 <memmove>
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
80101d45:	e8 b6 2e 00 00       	call   80104c00 <memmove>
    log_write(bp);
80101d4a:	89 34 24             	mov    %esi,(%esp)
80101d4d:	e8 ce 13 00 00       	call   80103120 <log_write>
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
80101dce:	e8 9d 2e 00 00       	call   80104c70 <strncmp>
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
80101e2d:	e8 3e 2e 00 00       	call   80104c70 <strncmp>
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
80101e72:	68 e8 82 10 80       	push   $0x801082e8
80101e77:	e8 f4 e5 ff ff       	call   80100470 <panic>
    panic("dirlookup not DIR");
80101e7c:	83 ec 0c             	sub    $0xc,%esp
80101e7f:	68 d6 82 10 80       	push   $0x801082d6
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
80101eaa:	e8 a1 1c 00 00       	call   80103b50 <myproc>
  acquire(&icache.lock);
80101eaf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101eb2:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101eb5:	68 60 09 11 80       	push   $0x80110960
80101eba:	e8 b1 2b 00 00       	call   80104a70 <acquire>
  ip->ref++;
80101ebf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ec3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101eca:	e8 41 2b 00 00       	call   80104a10 <release>
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
80101f27:	e8 d4 2c 00 00       	call   80104c00 <memmove>
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
80101f8c:	e8 9f 28 00 00       	call   80104830 <holdingsleep>
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
80101fae:	e8 3d 28 00 00       	call   801047f0 <releasesleep>
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
80101fdb:	e8 20 2c 00 00       	call   80104c00 <memmove>
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
80102015:	e8 16 28 00 00       	call   80104830 <holdingsleep>
8010201a:	83 c4 10             	add    $0x10,%esp
8010201d:	85 c0                	test   %eax,%eax
8010201f:	74 7d                	je     8010209e <namex+0x20e>
80102021:	8b 4e 08             	mov    0x8(%esi),%ecx
80102024:	85 c9                	test   %ecx,%ecx
80102026:	7e 76                	jle    8010209e <namex+0x20e>
  releasesleep(&ip->lock);
80102028:	83 ec 0c             	sub    $0xc,%esp
8010202b:	53                   	push   %ebx
8010202c:	e8 bf 27 00 00       	call   801047f0 <releasesleep>
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
80102065:	e8 c6 27 00 00       	call   80104830 <holdingsleep>
8010206a:	83 c4 10             	add    $0x10,%esp
8010206d:	85 c0                	test   %eax,%eax
8010206f:	74 2d                	je     8010209e <namex+0x20e>
80102071:	8b 7e 08             	mov    0x8(%esi),%edi
80102074:	85 ff                	test   %edi,%edi
80102076:	7e 26                	jle    8010209e <namex+0x20e>
  releasesleep(&ip->lock);
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	53                   	push   %ebx
8010207c:	e8 6f 27 00 00       	call   801047f0 <releasesleep>
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
801020a1:	68 ce 82 10 80       	push   $0x801082ce
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
8010210d:	e8 ae 2b 00 00       	call   80104cc0 <strncpy>
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
8010214b:	68 f7 82 10 80       	push   $0x801082f7
80102150:	e8 1b e3 ff ff       	call   80100470 <panic>
    panic("dirlink");
80102155:	83 ec 0c             	sub    $0xc,%esp
80102158:	68 86 85 10 80       	push   $0x80108586
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
8010226b:	68 0d 83 10 80       	push   $0x8010830d
80102270:	e8 fb e1 ff ff       	call   80100470 <panic>
    panic("idestart");
80102275:	83 ec 0c             	sub    $0xc,%esp
80102278:	68 04 83 10 80       	push   $0x80108304
8010227d:	e8 ee e1 ff ff       	call   80100470 <panic>
80102282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102290 <ideinit>:
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102296:	68 1f 83 10 80       	push   $0x8010831f
8010229b:	68 20 26 11 80       	push   $0x80112620
801022a0:	e8 db 25 00 00       	call   80104880 <initlock>
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
8010232e:	e8 3d 27 00 00       	call   80104a70 <acquire>

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
8010238d:	e8 ce 1f 00 00       	call   80104360 <wakeup>

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
801023ab:	e8 60 26 00 00       	call   80104a10 <release>

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
801023ce:	e8 5d 24 00 00       	call   80104830 <holdingsleep>
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
80102408:	e8 63 26 00 00       	call   80104a70 <acquire>

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
80102449:	e8 52 1e 00 00       	call   801042a0 <sleep>
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
80102466:	e9 a5 25 00 00       	jmp    80104a10 <release>
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
8010248a:	68 4e 83 10 80       	push   $0x8010834e
8010248f:	e8 dc df ff ff       	call   80100470 <panic>
    panic("iderw: nothing to do");
80102494:	83 ec 0c             	sub    $0xc,%esp
80102497:	68 39 83 10 80       	push   $0x80108339
8010249c:	e8 cf df ff ff       	call   80100470 <panic>
    panic("iderw: buf not locked");
801024a1:	83 ec 0c             	sub    $0xc,%esp
801024a4:	68 23 83 10 80       	push   $0x80108323
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
801024fa:	68 ec 87 10 80       	push   $0x801087ec
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
801025b0:	0f 85 b2 00 00 00    	jne    80102668 <kfree+0xc8>
801025b6:	81 fb 40 ba 1c 80    	cmp    $0x801cba40,%ebx
801025bc:	0f 82 a6 00 00 00    	jb     80102668 <kfree+0xc8>
801025c2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801025c8:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
801025cd:	0f 87 95 00 00 00    	ja     80102668 <kfree+0xc8>
    panic("kfree");
  // Fill with junk to catch dangling refs.
  if(get_refcnt(V2P(v)) == 0){
801025d3:	83 ec 0c             	sub    $0xc,%esp
801025d6:	50                   	push   %eax
801025d7:	e8 d4 57 00 00       	call   80107db0 <get_refcnt>
801025dc:	83 c4 10             	add    $0x10,%esp
801025df:	85 c0                	test   %eax,%eax
801025e1:	75 45                	jne    80102628 <kfree+0x88>
    memset(v, 1, PGSIZE);
801025e3:	83 ec 04             	sub    $0x4,%esp
801025e6:	68 00 10 00 00       	push   $0x1000
801025eb:	6a 01                	push   $0x1
801025ed:	53                   	push   %ebx
801025ee:	e8 7d 25 00 00       	call   80104b70 <memset>

    if(kmem.use_lock)
801025f3:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801025f9:	83 c4 10             	add    $0x10,%esp
801025fc:	85 d2                	test   %edx,%edx
801025fe:	75 40                	jne    80102640 <kfree+0xa0>
      acquire(&kmem.lock);
    r = (struct run*)v;
    r->next = kmem.freelist;
80102600:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102605:	89 03                	mov    %eax,(%ebx)
    kmem.num_free_pages+=1;
    kmem.freelist = r;
    if(kmem.use_lock)
80102607:	a1 94 26 11 80       	mov    0x80112694,%eax
    kmem.num_free_pages+=1;
8010260c:	83 05 98 26 11 80 01 	addl   $0x1,0x80112698
    kmem.freelist = r;
80102613:	89 1d 9c 26 11 80    	mov    %ebx,0x8011269c
    if(kmem.use_lock)
80102619:	85 c0                	test   %eax,%eax
8010261b:	75 3b                	jne    80102658 <kfree+0xb8>
  }
  else{
    // cprintf("page %d is not free\n", V2P(v) >> PTXSHIFT);
    cprintf("Wait till refcnt is 0\n");
  }
}
8010261d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102620:	c9                   	leave
80102621:	c3                   	ret
80102622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("Wait till refcnt is 0\n");
80102628:	c7 45 08 72 83 10 80 	movl   $0x80108372,0x8(%ebp)
}
8010262f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102632:	c9                   	leave
    cprintf("Wait till refcnt is 0\n");
80102633:	e9 68 e1 ff ff       	jmp    801007a0 <cprintf>
80102638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010263f:	90                   	nop
      acquire(&kmem.lock);
80102640:	83 ec 0c             	sub    $0xc,%esp
80102643:	68 60 26 11 80       	push   $0x80112660
80102648:	e8 23 24 00 00       	call   80104a70 <acquire>
8010264d:	83 c4 10             	add    $0x10,%esp
80102650:	eb ae                	jmp    80102600 <kfree+0x60>
80102652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      release(&kmem.lock);
80102658:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010265f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102662:	c9                   	leave
      release(&kmem.lock);
80102663:	e9 a8 23 00 00       	jmp    80104a10 <release>
    panic("kfree");
80102668:	83 ec 0c             	sub    $0xc,%esp
8010266b:	68 6c 83 10 80       	push   $0x8010836c
80102670:	e8 fb dd ff ff       	call   80100470 <panic>
80102675:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102680 <freerange>:
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	56                   	push   %esi
80102684:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102685:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102688:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010268b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102691:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102697:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010269d:	39 de                	cmp    %ebx,%esi
8010269f:	72 37                	jb     801026d8 <freerange+0x58>
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801026ae:	83 ec 0c             	sub    $0xc,%esp
801026b1:	50                   	push   %eax
801026b2:	e8 e9 fe ff ff       	call   801025a0 <kfree>
    page_to_refcnt[V2P(p) >> PTXSHIFT] = 0;
801026b7:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026bd:	83 c4 10             	add    $0x10,%esp
801026c0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    page_to_refcnt[V2P(p) >> PTXSHIFT] = 0;
801026c6:	c1 e8 0c             	shr    $0xc,%eax
801026c9:	c7 04 85 a0 26 11 80 	movl   $0x0,-0x7feed960(,%eax,4)
801026d0:	00 00 00 00 
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d4:	39 de                	cmp    %ebx,%esi
801026d6:	73 d0                	jae    801026a8 <freerange+0x28>
}
801026d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026db:	5b                   	pop    %ebx
801026dc:	5e                   	pop    %esi
801026dd:	5d                   	pop    %ebp
801026de:	c3                   	ret
801026df:	90                   	nop

801026e0 <kinit2>:
{
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	56                   	push   %esi
801026e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801026eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026fd:	39 de                	cmp    %ebx,%esi
801026ff:	72 37                	jb     80102738 <kinit2+0x58>
80102701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102708:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010270e:	83 ec 0c             	sub    $0xc,%esp
80102711:	50                   	push   %eax
80102712:	e8 89 fe ff ff       	call   801025a0 <kfree>
    page_to_refcnt[V2P(p) >> PTXSHIFT] = 0;
80102717:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010271d:	83 c4 10             	add    $0x10,%esp
80102720:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    page_to_refcnt[V2P(p) >> PTXSHIFT] = 0;
80102726:	c1 e8 0c             	shr    $0xc,%eax
80102729:	c7 04 85 a0 26 11 80 	movl   $0x0,-0x7feed960(,%eax,4)
80102730:	00 00 00 00 
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102734:	39 de                	cmp    %ebx,%esi
80102736:	73 d0                	jae    80102708 <kinit2+0x28>
  kmem.use_lock = 1;
80102738:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
8010273f:	00 00 00 
}
80102742:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102745:	5b                   	pop    %ebx
80102746:	5e                   	pop    %esi
80102747:	5d                   	pop    %ebp
80102748:	c3                   	ret
80102749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102750 <kinit1>:
{
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	56                   	push   %esi
80102754:	53                   	push   %ebx
80102755:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102758:	83 ec 08             	sub    $0x8,%esp
8010275b:	68 89 83 10 80       	push   $0x80108389
80102760:	68 60 26 11 80       	push   $0x80112660
80102765:	e8 16 21 00 00       	call   80104880 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010276a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010276d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102770:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102777:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010277a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102780:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102786:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010278c:	39 de                	cmp    %ebx,%esi
8010278e:	72 30                	jb     801027c0 <kinit1+0x70>
    kfree(p);
80102790:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102796:	83 ec 0c             	sub    $0xc,%esp
80102799:	50                   	push   %eax
8010279a:	e8 01 fe ff ff       	call   801025a0 <kfree>
    page_to_refcnt[V2P(p) >> PTXSHIFT] = 0;
8010279f:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027a5:	83 c4 10             	add    $0x10,%esp
801027a8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    page_to_refcnt[V2P(p) >> PTXSHIFT] = 0;
801027ae:	c1 e8 0c             	shr    $0xc,%eax
801027b1:	c7 04 85 a0 26 11 80 	movl   $0x0,-0x7feed960(,%eax,4)
801027b8:	00 00 00 00 
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027bc:	39 de                	cmp    %ebx,%esi
801027be:	73 d0                	jae    80102790 <kinit1+0x40>
}
801027c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027c3:	5b                   	pop    %ebx
801027c4:	5e                   	pop    %esi
801027c5:	5d                   	pop    %ebp
801027c6:	c3                   	ret
801027c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ce:	66 90                	xchg   %ax,%ax

801027d0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	53                   	push   %ebx
801027d4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801027d7:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
801027dd:	85 c9                	test   %ecx,%ecx
801027df:	75 68                	jne    80102849 <kalloc+0x79>
801027e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
  r = kmem.freelist;
801027e8:	8b 1d 9c 26 11 80    	mov    0x8011269c,%ebx
  if(r)
801027ee:	85 db                	test   %ebx,%ebx
801027f0:	74 48                	je     8010283a <kalloc+0x6a>
  {
    kmem.freelist = r->next;
801027f2:	8b 03                	mov    (%ebx),%eax
    kmem.num_free_pages-=1;
801027f4:	83 2d 98 26 11 80 01 	subl   $0x1,0x80112698
    kmem.freelist = r->next;
801027fb:	a3 9c 26 11 80       	mov    %eax,0x8011269c
    page_to_refcnt[V2P(r) >> PTXSHIFT] = 1;
80102800:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102806:	c1 e8 0c             	shr    $0xc,%eax
80102809:	c7 04 85 a0 26 11 80 	movl   $0x1,-0x7feed960(,%eax,4)
80102810:	01 00 00 00 

  if(r) return (char*)r;

  swap_out();
  return kalloc();
}
80102814:	89 d8                	mov    %ebx,%eax
80102816:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102819:	c9                   	leave
8010281a:	c3                   	ret
8010281b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010281f:	90                   	nop
  if(kmem.use_lock)
80102820:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102826:	85 d2                	test   %edx,%edx
80102828:	74 10                	je     8010283a <kalloc+0x6a>
    release(&kmem.lock);
8010282a:	83 ec 0c             	sub    $0xc,%esp
8010282d:	68 60 26 11 80       	push   $0x80112660
80102832:	e8 d9 21 00 00       	call   80104a10 <release>
80102837:	83 c4 10             	add    $0x10,%esp
  swap_out();
8010283a:	e8 b1 55 00 00       	call   80107df0 <swap_out>
  if(kmem.use_lock)
8010283f:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
80102845:	85 c9                	test   %ecx,%ecx
80102847:	74 9f                	je     801027e8 <kalloc+0x18>
    acquire(&kmem.lock);
80102849:	83 ec 0c             	sub    $0xc,%esp
8010284c:	68 60 26 11 80       	push   $0x80112660
80102851:	e8 1a 22 00 00       	call   80104a70 <acquire>
  r = kmem.freelist;
80102856:	8b 1d 9c 26 11 80    	mov    0x8011269c,%ebx
  if(r)
8010285c:	83 c4 10             	add    $0x10,%esp
8010285f:	85 db                	test   %ebx,%ebx
80102861:	74 bd                	je     80102820 <kalloc+0x50>
    kmem.freelist = r->next;
80102863:	8b 03                	mov    (%ebx),%eax
    kmem.num_free_pages-=1;
80102865:	83 2d 98 26 11 80 01 	subl   $0x1,0x80112698
    kmem.freelist = r->next;
8010286c:	a3 9c 26 11 80       	mov    %eax,0x8011269c
    page_to_refcnt[V2P(r) >> PTXSHIFT] = 1;
80102871:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102877:	c1 e8 0c             	shr    $0xc,%eax
8010287a:	c7 04 85 a0 26 11 80 	movl   $0x1,-0x7feed960(,%eax,4)
80102881:	01 00 00 00 
  if(kmem.use_lock)
80102885:	a1 94 26 11 80       	mov    0x80112694,%eax
8010288a:	85 c0                	test   %eax,%eax
8010288c:	74 86                	je     80102814 <kalloc+0x44>
    release(&kmem.lock);
8010288e:	83 ec 0c             	sub    $0xc,%esp
80102891:	68 60 26 11 80       	push   $0x80112660
80102896:	e8 75 21 00 00       	call   80104a10 <release>
}
8010289b:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010289d:	83 c4 10             	add    $0x10,%esp
}
801028a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028a3:	c9                   	leave
801028a4:	c3                   	ret
801028a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028b0 <num_of_FreePages>:
uint 
num_of_FreePages(void)
{
801028b0:	55                   	push   %ebp
801028b1:	89 e5                	mov    %esp,%ebp
801028b3:	53                   	push   %ebx
801028b4:	83 ec 10             	sub    $0x10,%esp
  acquire(&kmem.lock);
801028b7:	68 60 26 11 80       	push   $0x80112660
801028bc:	e8 af 21 00 00       	call   80104a70 <acquire>

  uint num_free_pages = kmem.num_free_pages;
801028c1:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  
  release(&kmem.lock);
801028c7:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801028ce:	e8 3d 21 00 00       	call   80104a10 <release>
  
  return num_free_pages;
}
801028d3:	89 d8                	mov    %ebx,%eax
801028d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028d8:	c9                   	leave
801028d9:	c3                   	ret
801028da:	66 90                	xchg   %ax,%ax
801028dc:	66 90                	xchg   %ax,%ax
801028de:	66 90                	xchg   %ax,%ax

801028e0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028e0:	ba 64 00 00 00       	mov    $0x64,%edx
801028e5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028e6:	a8 01                	test   $0x1,%al
801028e8:	0f 84 c2 00 00 00    	je     801029b0 <kbdgetc+0xd0>
{
801028ee:	55                   	push   %ebp
801028ef:	ba 60 00 00 00       	mov    $0x60,%edx
801028f4:	89 e5                	mov    %esp,%ebp
801028f6:	53                   	push   %ebx
801028f7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801028f8:	8b 1d a0 36 11 80    	mov    0x801136a0,%ebx
  data = inb(KBDATAP);
801028fe:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102901:	3c e0                	cmp    $0xe0,%al
80102903:	74 5b                	je     80102960 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102905:	89 da                	mov    %ebx,%edx
80102907:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010290a:	84 c0                	test   %al,%al
8010290c:	78 62                	js     80102970 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010290e:	85 d2                	test   %edx,%edx
80102910:	74 09                	je     8010291b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102912:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102915:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102918:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010291b:	0f b6 91 c0 8a 10 80 	movzbl -0x7fef7540(%ecx),%edx
  shift ^= togglecode[data];
80102922:	0f b6 81 c0 89 10 80 	movzbl -0x7fef7640(%ecx),%eax
  shift |= shiftcode[data];
80102929:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010292b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010292d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010292f:	89 15 a0 36 11 80    	mov    %edx,0x801136a0
  c = charcode[shift & (CTL | SHIFT)][data];
80102935:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102938:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010293b:	8b 04 85 a0 89 10 80 	mov    -0x7fef7660(,%eax,4),%eax
80102942:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102946:	74 0b                	je     80102953 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102948:	8d 50 9f             	lea    -0x61(%eax),%edx
8010294b:	83 fa 19             	cmp    $0x19,%edx
8010294e:	77 48                	ja     80102998 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102950:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102953:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102956:	c9                   	leave
80102957:	c3                   	ret
80102958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010295f:	90                   	nop
    shift |= E0ESC;
80102960:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102963:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102965:	89 1d a0 36 11 80    	mov    %ebx,0x801136a0
}
8010296b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010296e:	c9                   	leave
8010296f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102970:	83 e0 7f             	and    $0x7f,%eax
80102973:	85 d2                	test   %edx,%edx
80102975:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102978:	0f b6 81 c0 8a 10 80 	movzbl -0x7fef7540(%ecx),%eax
8010297f:	83 c8 40             	or     $0x40,%eax
80102982:	0f b6 c0             	movzbl %al,%eax
80102985:	f7 d0                	not    %eax
80102987:	21 d8                	and    %ebx,%eax
80102989:	a3 a0 36 11 80       	mov    %eax,0x801136a0
    return 0;
8010298e:	31 c0                	xor    %eax,%eax
80102990:	eb d9                	jmp    8010296b <kbdgetc+0x8b>
80102992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102998:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010299b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010299e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029a1:	c9                   	leave
      c += 'a' - 'A';
801029a2:	83 f9 1a             	cmp    $0x1a,%ecx
801029a5:	0f 42 c2             	cmovb  %edx,%eax
}
801029a8:	c3                   	ret
801029a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801029b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801029b5:	c3                   	ret
801029b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029bd:	8d 76 00             	lea    0x0(%esi),%esi

801029c0 <kbdintr>:

void
kbdintr(void)
{
801029c0:	55                   	push   %ebp
801029c1:	89 e5                	mov    %esp,%ebp
801029c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029c6:	68 e0 28 10 80       	push   $0x801028e0
801029cb:	e8 c0 df ff ff       	call   80100990 <consoleintr>
}
801029d0:	83 c4 10             	add    $0x10,%esp
801029d3:	c9                   	leave
801029d4:	c3                   	ret
801029d5:	66 90                	xchg   %ax,%ax
801029d7:	66 90                	xchg   %ax,%ax
801029d9:	66 90                	xchg   %ax,%ax
801029db:	66 90                	xchg   %ax,%ax
801029dd:	66 90                	xchg   %ax,%ax
801029df:	90                   	nop

801029e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029e0:	a1 a4 36 11 80       	mov    0x801136a4,%eax
801029e5:	85 c0                	test   %eax,%eax
801029e7:	0f 84 c3 00 00 00    	je     80102ab0 <lapicinit+0xd0>
  lapic[index] = value;
801029ed:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029f4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029fa:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102a01:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a04:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a07:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a0e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a11:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a14:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a1b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a1e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a21:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a28:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a2e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a35:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a38:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a3b:	8b 50 30             	mov    0x30(%eax),%edx
80102a3e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102a44:	75 72                	jne    80102ab8 <lapicinit+0xd8>
  lapic[index] = value;
80102a46:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a4d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a50:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a53:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a5a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a5d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a60:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a67:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a6a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a6d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a74:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a77:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a7a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a81:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a84:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a87:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a8e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a91:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a98:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a9e:	80 e6 10             	and    $0x10,%dh
80102aa1:	75 f5                	jne    80102a98 <lapicinit+0xb8>
  lapic[index] = value;
80102aa3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102aaa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aad:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102ab0:	c3                   	ret
80102ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102ab8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102abf:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac2:	8b 50 20             	mov    0x20(%eax),%edx
}
80102ac5:	e9 7c ff ff ff       	jmp    80102a46 <lapicinit+0x66>
80102aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ad0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102ad0:	a1 a4 36 11 80       	mov    0x801136a4,%eax
80102ad5:	85 c0                	test   %eax,%eax
80102ad7:	74 07                	je     80102ae0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102ad9:	8b 40 20             	mov    0x20(%eax),%eax
80102adc:	c1 e8 18             	shr    $0x18,%eax
80102adf:	c3                   	ret
    return 0;
80102ae0:	31 c0                	xor    %eax,%eax
}
80102ae2:	c3                   	ret
80102ae3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102af0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102af0:	a1 a4 36 11 80       	mov    0x801136a4,%eax
80102af5:	85 c0                	test   %eax,%eax
80102af7:	74 0d                	je     80102b06 <lapiceoi+0x16>
  lapic[index] = value;
80102af9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b00:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b03:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102b06:	c3                   	ret
80102b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b0e:	66 90                	xchg   %ax,%ax

80102b10 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102b10:	c3                   	ret
80102b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b1f:	90                   	nop

80102b20 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b20:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b21:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b26:	ba 70 00 00 00       	mov    $0x70,%edx
80102b2b:	89 e5                	mov    %esp,%ebp
80102b2d:	53                   	push   %ebx
80102b2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b31:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b34:	ee                   	out    %al,(%dx)
80102b35:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b3a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b3f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b40:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102b42:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b45:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b4b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b4d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102b50:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102b52:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b55:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b58:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b5e:	a1 a4 36 11 80       	mov    0x801136a4,%eax
80102b63:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b69:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b6c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b73:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b76:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b79:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b80:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b83:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b86:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b8c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b8f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b95:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b98:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b9e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ba1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ba7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102baa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bad:	c9                   	leave
80102bae:	c3                   	ret
80102baf:	90                   	nop

80102bb0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102bb0:	55                   	push   %ebp
80102bb1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102bb6:	ba 70 00 00 00       	mov    $0x70,%edx
80102bbb:	89 e5                	mov    %esp,%ebp
80102bbd:	57                   	push   %edi
80102bbe:	56                   	push   %esi
80102bbf:	53                   	push   %ebx
80102bc0:	83 ec 4c             	sub    $0x4c,%esp
80102bc3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc4:	ba 71 00 00 00       	mov    $0x71,%edx
80102bc9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102bca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bcd:	bf 70 00 00 00       	mov    $0x70,%edi
80102bd2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102bd5:	8d 76 00             	lea    0x0(%esi),%esi
80102bd8:	31 c0                	xor    %eax,%eax
80102bda:	89 fa                	mov    %edi,%edx
80102bdc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bdd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102be2:	89 ca                	mov    %ecx,%edx
80102be4:	ec                   	in     (%dx),%al
80102be5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be8:	89 fa                	mov    %edi,%edx
80102bea:	b8 02 00 00 00       	mov    $0x2,%eax
80102bef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf0:	89 ca                	mov    %ecx,%edx
80102bf2:	ec                   	in     (%dx),%al
80102bf3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf6:	89 fa                	mov    %edi,%edx
80102bf8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bfd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfe:	89 ca                	mov    %ecx,%edx
80102c00:	ec                   	in     (%dx),%al
80102c01:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c04:	89 fa                	mov    %edi,%edx
80102c06:	b8 07 00 00 00       	mov    $0x7,%eax
80102c0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0c:	89 ca                	mov    %ecx,%edx
80102c0e:	ec                   	in     (%dx),%al
80102c0f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c12:	89 fa                	mov    %edi,%edx
80102c14:	b8 08 00 00 00       	mov    $0x8,%eax
80102c19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1a:	89 ca                	mov    %ecx,%edx
80102c1c:	ec                   	in     (%dx),%al
80102c1d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c1f:	89 fa                	mov    %edi,%edx
80102c21:	b8 09 00 00 00       	mov    $0x9,%eax
80102c26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c27:	89 ca                	mov    %ecx,%edx
80102c29:	ec                   	in     (%dx),%al
80102c2a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c2d:	89 fa                	mov    %edi,%edx
80102c2f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c34:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c35:	89 ca                	mov    %ecx,%edx
80102c37:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c38:	84 c0                	test   %al,%al
80102c3a:	78 9c                	js     80102bd8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c3c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c40:	89 f2                	mov    %esi,%edx
80102c42:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102c45:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c48:	89 fa                	mov    %edi,%edx
80102c4a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c4d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c51:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102c54:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c57:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c5b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c5e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c62:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c65:	31 c0                	xor    %eax,%eax
80102c67:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c68:	89 ca                	mov    %ecx,%edx
80102c6a:	ec                   	in     (%dx),%al
80102c6b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c6e:	89 fa                	mov    %edi,%edx
80102c70:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c73:	b8 02 00 00 00       	mov    $0x2,%eax
80102c78:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c79:	89 ca                	mov    %ecx,%edx
80102c7b:	ec                   	in     (%dx),%al
80102c7c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c7f:	89 fa                	mov    %edi,%edx
80102c81:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c84:	b8 04 00 00 00       	mov    $0x4,%eax
80102c89:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c8a:	89 ca                	mov    %ecx,%edx
80102c8c:	ec                   	in     (%dx),%al
80102c8d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c90:	89 fa                	mov    %edi,%edx
80102c92:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c95:	b8 07 00 00 00       	mov    $0x7,%eax
80102c9a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9b:	89 ca                	mov    %ecx,%edx
80102c9d:	ec                   	in     (%dx),%al
80102c9e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca1:	89 fa                	mov    %edi,%edx
80102ca3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ca6:	b8 08 00 00 00       	mov    $0x8,%eax
80102cab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cac:	89 ca                	mov    %ecx,%edx
80102cae:	ec                   	in     (%dx),%al
80102caf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb2:	89 fa                	mov    %edi,%edx
80102cb4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102cb7:	b8 09 00 00 00       	mov    $0x9,%eax
80102cbc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cbd:	89 ca                	mov    %ecx,%edx
80102cbf:	ec                   	in     (%dx),%al
80102cc0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cc3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102cc6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cc9:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ccc:	6a 18                	push   $0x18
80102cce:	50                   	push   %eax
80102ccf:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102cd2:	50                   	push   %eax
80102cd3:	e8 d8 1e 00 00       	call   80104bb0 <memcmp>
80102cd8:	83 c4 10             	add    $0x10,%esp
80102cdb:	85 c0                	test   %eax,%eax
80102cdd:	0f 85 f5 fe ff ff    	jne    80102bd8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ce3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102ce7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102cea:	89 f0                	mov    %esi,%eax
80102cec:	84 c0                	test   %al,%al
80102cee:	75 78                	jne    80102d68 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102cf0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cf3:	89 c2                	mov    %eax,%edx
80102cf5:	83 e0 0f             	and    $0xf,%eax
80102cf8:	c1 ea 04             	shr    $0x4,%edx
80102cfb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cfe:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d01:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d04:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d07:	89 c2                	mov    %eax,%edx
80102d09:	83 e0 0f             	and    $0xf,%eax
80102d0c:	c1 ea 04             	shr    $0x4,%edx
80102d0f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d12:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d15:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d18:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d1b:	89 c2                	mov    %eax,%edx
80102d1d:	83 e0 0f             	and    $0xf,%eax
80102d20:	c1 ea 04             	shr    $0x4,%edx
80102d23:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d26:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d29:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d2c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d2f:	89 c2                	mov    %eax,%edx
80102d31:	83 e0 0f             	and    $0xf,%eax
80102d34:	c1 ea 04             	shr    $0x4,%edx
80102d37:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d3a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d3d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d40:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d43:	89 c2                	mov    %eax,%edx
80102d45:	83 e0 0f             	and    $0xf,%eax
80102d48:	c1 ea 04             	shr    $0x4,%edx
80102d4b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d4e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d51:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d54:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d57:	89 c2                	mov    %eax,%edx
80102d59:	83 e0 0f             	and    $0xf,%eax
80102d5c:	c1 ea 04             	shr    $0x4,%edx
80102d5f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d62:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d65:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d6b:	89 03                	mov    %eax,(%ebx)
80102d6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d70:	89 43 04             	mov    %eax,0x4(%ebx)
80102d73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d76:	89 43 08             	mov    %eax,0x8(%ebx)
80102d79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d7c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102d7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d82:	89 43 10             	mov    %eax,0x10(%ebx)
80102d85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d88:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102d8b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d95:	5b                   	pop    %ebx
80102d96:	5e                   	pop    %esi
80102d97:	5f                   	pop    %edi
80102d98:	5d                   	pop    %ebp
80102d99:	c3                   	ret
80102d9a:	66 90                	xchg   %ax,%ax
80102d9c:	66 90                	xchg   %ax,%ax
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102da0:	8b 0d 08 37 11 80    	mov    0x80113708,%ecx
80102da6:	85 c9                	test   %ecx,%ecx
80102da8:	0f 8e 8a 00 00 00    	jle    80102e38 <install_trans+0x98>
{
80102dae:	55                   	push   %ebp
80102daf:	89 e5                	mov    %esp,%ebp
80102db1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102db2:	31 ff                	xor    %edi,%edi
{
80102db4:	56                   	push   %esi
80102db5:	53                   	push   %ebx
80102db6:	83 ec 0c             	sub    $0xc,%esp
80102db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102dc0:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102dc5:	83 ec 08             	sub    $0x8,%esp
80102dc8:	01 f8                	add    %edi,%eax
80102dca:	83 c0 01             	add    $0x1,%eax
80102dcd:	50                   	push   %eax
80102dce:	ff 35 04 37 11 80    	push   0x80113704
80102dd4:	e8 f7 d2 ff ff       	call   801000d0 <bread>
80102dd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ddb:	58                   	pop    %eax
80102ddc:	5a                   	pop    %edx
80102ddd:	ff 34 bd 0c 37 11 80 	push   -0x7feec8f4(,%edi,4)
80102de4:	ff 35 04 37 11 80    	push   0x80113704
  for (tail = 0; tail < log.lh.n; tail++) {
80102dea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ded:	e8 de d2 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102df2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102df5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102df7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dfa:	68 00 02 00 00       	push   $0x200
80102dff:	50                   	push   %eax
80102e00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102e03:	50                   	push   %eax
80102e04:	e8 f7 1d 00 00       	call   80104c00 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e09:	89 1c 24             	mov    %ebx,(%esp)
80102e0c:	e8 9f d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102e11:	89 34 24             	mov    %esi,(%esp)
80102e14:	e8 d7 d3 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102e19:	89 1c 24             	mov    %ebx,(%esp)
80102e1c:	e8 cf d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e21:	83 c4 10             	add    $0x10,%esp
80102e24:	39 3d 08 37 11 80    	cmp    %edi,0x80113708
80102e2a:	7f 94                	jg     80102dc0 <install_trans+0x20>
  }
}
80102e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e2f:	5b                   	pop    %ebx
80102e30:	5e                   	pop    %esi
80102e31:	5f                   	pop    %edi
80102e32:	5d                   	pop    %ebp
80102e33:	c3                   	ret
80102e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e38:	c3                   	ret
80102e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e47:	ff 35 f4 36 11 80    	push   0x801136f4
80102e4d:	ff 35 04 37 11 80    	push   0x80113704
80102e53:	e8 78 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e5d:	a1 08 37 11 80       	mov    0x80113708,%eax
80102e62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102e65:	85 c0                	test   %eax,%eax
80102e67:	7e 19                	jle    80102e82 <write_head+0x42>
80102e69:	31 d2                	xor    %edx,%edx
80102e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102e70:	8b 0c 95 0c 37 11 80 	mov    -0x7feec8f4(,%edx,4),%ecx
80102e77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e7b:	83 c2 01             	add    $0x1,%edx
80102e7e:	39 d0                	cmp    %edx,%eax
80102e80:	75 ee                	jne    80102e70 <write_head+0x30>
  }
  bwrite(buf);
80102e82:	83 ec 0c             	sub    $0xc,%esp
80102e85:	53                   	push   %ebx
80102e86:	e8 25 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102e8b:	89 1c 24             	mov    %ebx,(%esp)
80102e8e:	e8 5d d3 ff ff       	call   801001f0 <brelse>
}
80102e93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e96:	83 c4 10             	add    $0x10,%esp
80102e99:	c9                   	leave
80102e9a:	c3                   	ret
80102e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e9f:	90                   	nop

80102ea0 <initlog>:
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	53                   	push   %ebx
80102ea4:	83 ec 3c             	sub    $0x3c,%esp
80102ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102eaa:	68 8e 83 10 80       	push   $0x8010838e
80102eaf:	68 c0 36 11 80       	push   $0x801136c0
80102eb4:	e8 c7 19 00 00       	call   80104880 <initlock>
  readsb(dev, &sb);
80102eb9:	58                   	pop    %eax
80102eba:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80102ebd:	5a                   	pop    %edx
80102ebe:	50                   	push   %eax
80102ebf:	53                   	push   %ebx
80102ec0:	e8 6b e7 ff ff       	call   80101630 <readsb>
  log.start = sb.logstart;
80102ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ec8:	59                   	pop    %ecx
  log.dev = dev;
80102ec9:	89 1d 04 37 11 80    	mov    %ebx,0x80113704
  log.size = sb.nlog;
80102ecf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  log.start = sb.logstart;
80102ed2:	a3 f4 36 11 80       	mov    %eax,0x801136f4
  log.size = sb.nlog;
80102ed7:	89 15 f8 36 11 80    	mov    %edx,0x801136f8
  struct buf *buf = bread(log.dev, log.start);
80102edd:	5a                   	pop    %edx
80102ede:	50                   	push   %eax
80102edf:	53                   	push   %ebx
80102ee0:	e8 eb d1 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ee5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102ee8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102eeb:	89 1d 08 37 11 80    	mov    %ebx,0x80113708
  for (i = 0; i < log.lh.n; i++) {
80102ef1:	85 db                	test   %ebx,%ebx
80102ef3:	7e 1d                	jle    80102f12 <initlog+0x72>
80102ef5:	31 d2                	xor    %edx,%edx
80102ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102efe:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102f00:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102f04:	89 0c 95 0c 37 11 80 	mov    %ecx,-0x7feec8f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102f0b:	83 c2 01             	add    $0x1,%edx
80102f0e:	39 d3                	cmp    %edx,%ebx
80102f10:	75 ee                	jne    80102f00 <initlog+0x60>
  brelse(buf);
80102f12:	83 ec 0c             	sub    $0xc,%esp
80102f15:	50                   	push   %eax
80102f16:	e8 d5 d2 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f1b:	e8 80 fe ff ff       	call   80102da0 <install_trans>
  log.lh.n = 0;
80102f20:	c7 05 08 37 11 80 00 	movl   $0x0,0x80113708
80102f27:	00 00 00 
  write_head(); // clear the log
80102f2a:	e8 11 ff ff ff       	call   80102e40 <write_head>
}
80102f2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f32:	83 c4 10             	add    $0x10,%esp
80102f35:	c9                   	leave
80102f36:	c3                   	ret
80102f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3e:	66 90                	xchg   %ax,%ax

80102f40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f46:	68 c0 36 11 80       	push   $0x801136c0
80102f4b:	e8 20 1b 00 00       	call   80104a70 <acquire>
80102f50:	83 c4 10             	add    $0x10,%esp
80102f53:	eb 18                	jmp    80102f6d <begin_op+0x2d>
80102f55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f58:	83 ec 08             	sub    $0x8,%esp
80102f5b:	68 c0 36 11 80       	push   $0x801136c0
80102f60:	68 c0 36 11 80       	push   $0x801136c0
80102f65:	e8 36 13 00 00       	call   801042a0 <sleep>
80102f6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f6d:	a1 00 37 11 80       	mov    0x80113700,%eax
80102f72:	85 c0                	test   %eax,%eax
80102f74:	75 e2                	jne    80102f58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f76:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102f7b:	8b 15 08 37 11 80    	mov    0x80113708,%edx
80102f81:	83 c0 01             	add    $0x1,%eax
80102f84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f8a:	83 fa 1e             	cmp    $0x1e,%edx
80102f8d:	7f c9                	jg     80102f58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f92:	a3 fc 36 11 80       	mov    %eax,0x801136fc
      release(&log.lock);
80102f97:	68 c0 36 11 80       	push   $0x801136c0
80102f9c:	e8 6f 1a 00 00       	call   80104a10 <release>
      break;
    }
  }
}
80102fa1:	83 c4 10             	add    $0x10,%esp
80102fa4:	c9                   	leave
80102fa5:	c3                   	ret
80102fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fad:	8d 76 00             	lea    0x0(%esi),%esi

80102fb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	57                   	push   %edi
80102fb4:	56                   	push   %esi
80102fb5:	53                   	push   %ebx
80102fb6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102fb9:	68 c0 36 11 80       	push   $0x801136c0
80102fbe:	e8 ad 1a 00 00       	call   80104a70 <acquire>
  log.outstanding -= 1;
80102fc3:	a1 fc 36 11 80       	mov    0x801136fc,%eax
  if(log.committing)
80102fc8:	8b 35 00 37 11 80    	mov    0x80113700,%esi
80102fce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102fd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102fd4:	89 1d fc 36 11 80    	mov    %ebx,0x801136fc
  if(log.committing)
80102fda:	85 f6                	test   %esi,%esi
80102fdc:	0f 85 22 01 00 00    	jne    80103104 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102fe2:	85 db                	test   %ebx,%ebx
80102fe4:	0f 85 f6 00 00 00    	jne    801030e0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102fea:	c7 05 00 37 11 80 01 	movl   $0x1,0x80113700
80102ff1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ff4:	83 ec 0c             	sub    $0xc,%esp
80102ff7:	68 c0 36 11 80       	push   $0x801136c0
80102ffc:	e8 0f 1a 00 00       	call   80104a10 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103001:	8b 0d 08 37 11 80    	mov    0x80113708,%ecx
80103007:	83 c4 10             	add    $0x10,%esp
8010300a:	85 c9                	test   %ecx,%ecx
8010300c:	7f 42                	jg     80103050 <end_op+0xa0>
    acquire(&log.lock);
8010300e:	83 ec 0c             	sub    $0xc,%esp
80103011:	68 c0 36 11 80       	push   $0x801136c0
80103016:	e8 55 1a 00 00       	call   80104a70 <acquire>
    log.committing = 0;
8010301b:	c7 05 00 37 11 80 00 	movl   $0x0,0x80113700
80103022:	00 00 00 
    wakeup(&log);
80103025:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
8010302c:	e8 2f 13 00 00       	call   80104360 <wakeup>
    release(&log.lock);
80103031:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80103038:	e8 d3 19 00 00       	call   80104a10 <release>
8010303d:	83 c4 10             	add    $0x10,%esp
}
80103040:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103043:	5b                   	pop    %ebx
80103044:	5e                   	pop    %esi
80103045:	5f                   	pop    %edi
80103046:	5d                   	pop    %ebp
80103047:	c3                   	ret
80103048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010304f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103050:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80103055:	83 ec 08             	sub    $0x8,%esp
80103058:	01 d8                	add    %ebx,%eax
8010305a:	83 c0 01             	add    $0x1,%eax
8010305d:	50                   	push   %eax
8010305e:	ff 35 04 37 11 80    	push   0x80113704
80103064:	e8 67 d0 ff ff       	call   801000d0 <bread>
80103069:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010306b:	58                   	pop    %eax
8010306c:	5a                   	pop    %edx
8010306d:	ff 34 9d 0c 37 11 80 	push   -0x7feec8f4(,%ebx,4)
80103074:	ff 35 04 37 11 80    	push   0x80113704
  for (tail = 0; tail < log.lh.n; tail++) {
8010307a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010307d:	e8 4e d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103082:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103085:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103087:	8d 40 5c             	lea    0x5c(%eax),%eax
8010308a:	68 00 02 00 00       	push   $0x200
8010308f:	50                   	push   %eax
80103090:	8d 46 5c             	lea    0x5c(%esi),%eax
80103093:	50                   	push   %eax
80103094:	e8 67 1b 00 00       	call   80104c00 <memmove>
    bwrite(to);  // write the log
80103099:	89 34 24             	mov    %esi,(%esp)
8010309c:	e8 0f d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
801030a1:	89 3c 24             	mov    %edi,(%esp)
801030a4:	e8 47 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
801030a9:	89 34 24             	mov    %esi,(%esp)
801030ac:	e8 3f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030b1:	83 c4 10             	add    $0x10,%esp
801030b4:	3b 1d 08 37 11 80    	cmp    0x80113708,%ebx
801030ba:	7c 94                	jl     80103050 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801030bc:	e8 7f fd ff ff       	call   80102e40 <write_head>
    install_trans(); // Now install writes to home locations
801030c1:	e8 da fc ff ff       	call   80102da0 <install_trans>
    log.lh.n = 0;
801030c6:	c7 05 08 37 11 80 00 	movl   $0x0,0x80113708
801030cd:	00 00 00 
    write_head();    // Erase the transaction from the log
801030d0:	e8 6b fd ff ff       	call   80102e40 <write_head>
801030d5:	e9 34 ff ff ff       	jmp    8010300e <end_op+0x5e>
801030da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801030e0:	83 ec 0c             	sub    $0xc,%esp
801030e3:	68 c0 36 11 80       	push   $0x801136c0
801030e8:	e8 73 12 00 00       	call   80104360 <wakeup>
  release(&log.lock);
801030ed:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
801030f4:	e8 17 19 00 00       	call   80104a10 <release>
801030f9:	83 c4 10             	add    $0x10,%esp
}
801030fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030ff:	5b                   	pop    %ebx
80103100:	5e                   	pop    %esi
80103101:	5f                   	pop    %edi
80103102:	5d                   	pop    %ebp
80103103:	c3                   	ret
    panic("log.committing");
80103104:	83 ec 0c             	sub    $0xc,%esp
80103107:	68 92 83 10 80       	push   $0x80108392
8010310c:	e8 5f d3 ff ff       	call   80100470 <panic>
80103111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010311f:	90                   	nop

80103120 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	53                   	push   %ebx
80103124:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103127:	8b 15 08 37 11 80    	mov    0x80113708,%edx
{
8010312d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103130:	83 fa 1d             	cmp    $0x1d,%edx
80103133:	7f 7d                	jg     801031b2 <log_write+0x92>
80103135:	a1 f8 36 11 80       	mov    0x801136f8,%eax
8010313a:	83 e8 01             	sub    $0x1,%eax
8010313d:	39 c2                	cmp    %eax,%edx
8010313f:	7d 71                	jge    801031b2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103141:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80103146:	85 c0                	test   %eax,%eax
80103148:	7e 75                	jle    801031bf <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010314a:	83 ec 0c             	sub    $0xc,%esp
8010314d:	68 c0 36 11 80       	push   $0x801136c0
80103152:	e8 19 19 00 00       	call   80104a70 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103157:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010315a:	83 c4 10             	add    $0x10,%esp
8010315d:	31 c0                	xor    %eax,%eax
8010315f:	8b 15 08 37 11 80    	mov    0x80113708,%edx
80103165:	85 d2                	test   %edx,%edx
80103167:	7f 0e                	jg     80103177 <log_write+0x57>
80103169:	eb 15                	jmp    80103180 <log_write+0x60>
8010316b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010316f:	90                   	nop
80103170:	83 c0 01             	add    $0x1,%eax
80103173:	39 c2                	cmp    %eax,%edx
80103175:	74 29                	je     801031a0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103177:	39 0c 85 0c 37 11 80 	cmp    %ecx,-0x7feec8f4(,%eax,4)
8010317e:	75 f0                	jne    80103170 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103180:	89 0c 85 0c 37 11 80 	mov    %ecx,-0x7feec8f4(,%eax,4)
  if (i == log.lh.n)
80103187:	39 c2                	cmp    %eax,%edx
80103189:	74 1c                	je     801031a7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010318b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010318e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103191:	c7 45 08 c0 36 11 80 	movl   $0x801136c0,0x8(%ebp)
}
80103198:	c9                   	leave
  release(&log.lock);
80103199:	e9 72 18 00 00       	jmp    80104a10 <release>
8010319e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
801031a0:	89 0c 95 0c 37 11 80 	mov    %ecx,-0x7feec8f4(,%edx,4)
    log.lh.n++;
801031a7:	83 c2 01             	add    $0x1,%edx
801031aa:	89 15 08 37 11 80    	mov    %edx,0x80113708
801031b0:	eb d9                	jmp    8010318b <log_write+0x6b>
    panic("too big a transaction");
801031b2:	83 ec 0c             	sub    $0xc,%esp
801031b5:	68 a1 83 10 80       	push   $0x801083a1
801031ba:	e8 b1 d2 ff ff       	call   80100470 <panic>
    panic("log_write outside of trans");
801031bf:	83 ec 0c             	sub    $0xc,%esp
801031c2:	68 b7 83 10 80       	push   $0x801083b7
801031c7:	e8 a4 d2 ff ff       	call   80100470 <panic>
801031cc:	66 90                	xchg   %ax,%ax
801031ce:	66 90                	xchg   %ax,%ax

801031d0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	53                   	push   %ebx
801031d4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031d7:	e8 54 09 00 00       	call   80103b30 <cpuid>
801031dc:	89 c3                	mov    %eax,%ebx
801031de:	e8 4d 09 00 00       	call   80103b30 <cpuid>
801031e3:	83 ec 04             	sub    $0x4,%esp
801031e6:	53                   	push   %ebx
801031e7:	50                   	push   %eax
801031e8:	68 d2 83 10 80       	push   $0x801083d2
801031ed:	e8 ae d5 ff ff       	call   801007a0 <cprintf>
  idtinit();       // load idt register
801031f2:	e8 d9 2b 00 00       	call   80105dd0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031f7:	e8 e4 08 00 00       	call   80103ae0 <mycpu>
801031fc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031fe:	b8 01 00 00 00       	mov    $0x1,%eax
80103203:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010320a:	e8 71 0c 00 00       	call   80103e80 <scheduler>
8010320f:	90                   	nop

80103210 <mpenter>:
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103216:	e8 05 3e 00 00       	call   80107020 <switchkvm>
  seginit();
8010321b:	e8 70 3d 00 00       	call   80106f90 <seginit>
  lapicinit();
80103220:	e8 bb f7 ff ff       	call   801029e0 <lapicinit>
  mpmain();
80103225:	e8 a6 ff ff ff       	call   801031d0 <mpmain>
8010322a:	66 90                	xchg   %ax,%ax
8010322c:	66 90                	xchg   %ax,%ax
8010322e:	66 90                	xchg   %ax,%ax

80103230 <main>:
{
80103230:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103234:	83 e4 f0             	and    $0xfffffff0,%esp
80103237:	ff 71 fc             	push   -0x4(%ecx)
8010323a:	55                   	push   %ebp
8010323b:	89 e5                	mov    %esp,%ebp
8010323d:	53                   	push   %ebx
8010323e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010323f:	83 ec 08             	sub    $0x8,%esp
80103242:	68 00 00 40 80       	push   $0x80400000
80103247:	68 40 ba 1c 80       	push   $0x801cba40
8010324c:	e8 ff f4 ff ff       	call   80102750 <kinit1>
  kvmalloc();      // kernel page table
80103251:	e8 ba 42 00 00       	call   80107510 <kvmalloc>
  mpinit();        // detect other processors
80103256:	e8 85 01 00 00       	call   801033e0 <mpinit>
  lapicinit();     // interrupt controller
8010325b:	e8 80 f7 ff ff       	call   801029e0 <lapicinit>
  seginit();       // segment descriptors
80103260:	e8 2b 3d 00 00       	call   80106f90 <seginit>
  picinit();       // disable pic
80103265:	e8 86 03 00 00       	call   801035f0 <picinit>
  ioapicinit();    // another interrupt controller
8010326a:	e8 41 f2 ff ff       	call   801024b0 <ioapicinit>
  consoleinit();   // console hardware
8010326f:	e8 dc d8 ff ff       	call   80100b50 <consoleinit>
  uartinit();      // serial port
80103274:	e8 67 2e 00 00       	call   801060e0 <uartinit>
  pinit();         // process table
80103279:	e8 42 08 00 00       	call   80103ac0 <pinit>
  tvinit();        // trap vectors
8010327e:	e8 cd 2a 00 00       	call   80105d50 <tvinit>
  binit();         // buffer cache
80103283:	e8 b8 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103288:	e8 93 dc ff ff       	call   80100f20 <fileinit>
  ideinit();       // disk 
8010328d:	e8 fe ef ff ff       	call   80102290 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103292:	83 c4 0c             	add    $0xc,%esp
80103295:	68 8a 00 00 00       	push   $0x8a
8010329a:	68 8c b4 10 80       	push   $0x8010b48c
8010329f:	68 00 70 00 80       	push   $0x80007000
801032a4:	e8 57 19 00 00       	call   80104c00 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032a9:	83 c4 10             	add    $0x10,%esp
801032ac:	69 05 a4 37 11 80 b0 	imul   $0xb0,0x801137a4,%eax
801032b3:	00 00 00 
801032b6:	05 c0 37 11 80       	add    $0x801137c0,%eax
801032bb:	3d c0 37 11 80       	cmp    $0x801137c0,%eax
801032c0:	76 7e                	jbe    80103340 <main+0x110>
801032c2:	bb c0 37 11 80       	mov    $0x801137c0,%ebx
801032c7:	eb 20                	jmp    801032e9 <main+0xb9>
801032c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032d0:	69 05 a4 37 11 80 b0 	imul   $0xb0,0x801137a4,%eax
801032d7:	00 00 00 
801032da:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032e0:	05 c0 37 11 80       	add    $0x801137c0,%eax
801032e5:	39 c3                	cmp    %eax,%ebx
801032e7:	73 57                	jae    80103340 <main+0x110>
    if(c == mycpu())  // We've started already.
801032e9:	e8 f2 07 00 00       	call   80103ae0 <mycpu>
801032ee:	39 c3                	cmp    %eax,%ebx
801032f0:	74 de                	je     801032d0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032f2:	e8 d9 f4 ff ff       	call   801027d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801032f7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801032fa:	c7 05 f8 6f 00 80 10 	movl   $0x80103210,0x80006ff8
80103301:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103304:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010330b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010330e:	05 00 10 00 00       	add    $0x1000,%eax
80103313:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103318:	0f b6 03             	movzbl (%ebx),%eax
8010331b:	68 00 70 00 00       	push   $0x7000
80103320:	50                   	push   %eax
80103321:	e8 fa f7 ff ff       	call   80102b20 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103326:	83 c4 10             	add    $0x10,%esp
80103329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103330:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103336:	85 c0                	test   %eax,%eax
80103338:	74 f6                	je     80103330 <main+0x100>
8010333a:	eb 94                	jmp    801032d0 <main+0xa0>
8010333c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103340:	83 ec 08             	sub    $0x8,%esp
80103343:	68 00 00 40 80       	push   $0x80400000
80103348:	68 00 00 40 80       	push   $0x80400000
8010334d:	e8 8e f3 ff ff       	call   801026e0 <kinit2>
  userinit();      // first user process
80103352:	e8 29 08 00 00       	call   80103b80 <userinit>
  mpmain();        // finish this processor's setup
80103357:	e8 74 fe ff ff       	call   801031d0 <mpmain>
8010335c:	66 90                	xchg   %ax,%ax
8010335e:	66 90                	xchg   %ax,%ax

80103360 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	57                   	push   %edi
80103364:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103365:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010336b:	53                   	push   %ebx
  e = addr+len;
8010336c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010336f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103372:	39 de                	cmp    %ebx,%esi
80103374:	72 10                	jb     80103386 <mpsearch1+0x26>
80103376:	eb 50                	jmp    801033c8 <mpsearch1+0x68>
80103378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010337f:	90                   	nop
80103380:	89 fe                	mov    %edi,%esi
80103382:	39 df                	cmp    %ebx,%edi
80103384:	73 42                	jae    801033c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103386:	83 ec 04             	sub    $0x4,%esp
80103389:	8d 7e 10             	lea    0x10(%esi),%edi
8010338c:	6a 04                	push   $0x4
8010338e:	68 e6 83 10 80       	push   $0x801083e6
80103393:	56                   	push   %esi
80103394:	e8 17 18 00 00       	call   80104bb0 <memcmp>
80103399:	83 c4 10             	add    $0x10,%esp
8010339c:	85 c0                	test   %eax,%eax
8010339e:	75 e0                	jne    80103380 <mpsearch1+0x20>
801033a0:	89 f2                	mov    %esi,%edx
801033a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801033a8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033ab:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033ae:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033b0:	39 fa                	cmp    %edi,%edx
801033b2:	75 f4                	jne    801033a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033b4:	84 c0                	test   %al,%al
801033b6:	75 c8                	jne    80103380 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033bb:	89 f0                	mov    %esi,%eax
801033bd:	5b                   	pop    %ebx
801033be:	5e                   	pop    %esi
801033bf:	5f                   	pop    %edi
801033c0:	5d                   	pop    %ebp
801033c1:	c3                   	ret
801033c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033cb:	31 f6                	xor    %esi,%esi
}
801033cd:	5b                   	pop    %ebx
801033ce:	89 f0                	mov    %esi,%eax
801033d0:	5e                   	pop    %esi
801033d1:	5f                   	pop    %edi
801033d2:	5d                   	pop    %ebp
801033d3:	c3                   	ret
801033d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033df:	90                   	nop

801033e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	57                   	push   %edi
801033e4:	56                   	push   %esi
801033e5:	53                   	push   %ebx
801033e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033f7:	c1 e0 08             	shl    $0x8,%eax
801033fa:	09 d0                	or     %edx,%eax
801033fc:	c1 e0 04             	shl    $0x4,%eax
801033ff:	75 1b                	jne    8010341c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103401:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103408:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010340f:	c1 e0 08             	shl    $0x8,%eax
80103412:	09 d0                	or     %edx,%eax
80103414:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103417:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010341c:	ba 00 04 00 00       	mov    $0x400,%edx
80103421:	e8 3a ff ff ff       	call   80103360 <mpsearch1>
80103426:	89 c3                	mov    %eax,%ebx
80103428:	85 c0                	test   %eax,%eax
8010342a:	0f 84 58 01 00 00    	je     80103588 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103430:	8b 73 04             	mov    0x4(%ebx),%esi
80103433:	85 f6                	test   %esi,%esi
80103435:	0f 84 3d 01 00 00    	je     80103578 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
8010343b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010343e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103444:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103447:	6a 04                	push   $0x4
80103449:	68 eb 83 10 80       	push   $0x801083eb
8010344e:	50                   	push   %eax
8010344f:	e8 5c 17 00 00       	call   80104bb0 <memcmp>
80103454:	83 c4 10             	add    $0x10,%esp
80103457:	85 c0                	test   %eax,%eax
80103459:	0f 85 19 01 00 00    	jne    80103578 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010345f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103466:	3c 01                	cmp    $0x1,%al
80103468:	74 08                	je     80103472 <mpinit+0x92>
8010346a:	3c 04                	cmp    $0x4,%al
8010346c:	0f 85 06 01 00 00    	jne    80103578 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103472:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103479:	66 85 d2             	test   %dx,%dx
8010347c:	74 22                	je     801034a0 <mpinit+0xc0>
8010347e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103481:	89 f0                	mov    %esi,%eax
  sum = 0;
80103483:	31 d2                	xor    %edx,%edx
80103485:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103488:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010348f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103492:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103494:	39 f8                	cmp    %edi,%eax
80103496:	75 f0                	jne    80103488 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103498:	84 d2                	test   %dl,%dl
8010349a:	0f 85 d8 00 00 00    	jne    80103578 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034a0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801034a9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
801034ac:	a3 a4 36 11 80       	mov    %eax,0x801136a4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034b1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801034b8:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801034be:	01 d7                	add    %edx,%edi
801034c0:	89 fa                	mov    %edi,%edx
  ismp = 1;
801034c2:	bf 01 00 00 00       	mov    $0x1,%edi
801034c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034ce:	66 90                	xchg   %ax,%ax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034d0:	39 d0                	cmp    %edx,%eax
801034d2:	73 19                	jae    801034ed <mpinit+0x10d>
    switch(*p){
801034d4:	0f b6 08             	movzbl (%eax),%ecx
801034d7:	80 f9 02             	cmp    $0x2,%cl
801034da:	0f 84 80 00 00 00    	je     80103560 <mpinit+0x180>
801034e0:	77 6e                	ja     80103550 <mpinit+0x170>
801034e2:	84 c9                	test   %cl,%cl
801034e4:	74 3a                	je     80103520 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034e6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034e9:	39 d0                	cmp    %edx,%eax
801034eb:	72 e7                	jb     801034d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034ed:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801034f0:	85 ff                	test   %edi,%edi
801034f2:	0f 84 dd 00 00 00    	je     801035d5 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034f8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801034fc:	74 15                	je     80103513 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034fe:	b8 70 00 00 00       	mov    $0x70,%eax
80103503:	ba 22 00 00 00       	mov    $0x22,%edx
80103508:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103509:	ba 23 00 00 00       	mov    $0x23,%edx
8010350e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010350f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103512:	ee                   	out    %al,(%dx)
  }
}
80103513:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103516:	5b                   	pop    %ebx
80103517:	5e                   	pop    %esi
80103518:	5f                   	pop    %edi
80103519:	5d                   	pop    %ebp
8010351a:	c3                   	ret
8010351b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010351f:	90                   	nop
      if(ncpu < NCPU) {
80103520:	8b 0d a4 37 11 80    	mov    0x801137a4,%ecx
80103526:	85 c9                	test   %ecx,%ecx
80103528:	7f 19                	jg     80103543 <mpinit+0x163>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010352a:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80103530:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103534:	83 c1 01             	add    $0x1,%ecx
80103537:	89 0d a4 37 11 80    	mov    %ecx,0x801137a4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010353d:	88 9e c0 37 11 80    	mov    %bl,-0x7feec840(%esi)
      p += sizeof(struct mpproc);
80103543:	83 c0 14             	add    $0x14,%eax
      continue;
80103546:	eb 88                	jmp    801034d0 <mpinit+0xf0>
80103548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010354f:	90                   	nop
    switch(*p){
80103550:	83 e9 03             	sub    $0x3,%ecx
80103553:	80 f9 01             	cmp    $0x1,%cl
80103556:	76 8e                	jbe    801034e6 <mpinit+0x106>
80103558:	31 ff                	xor    %edi,%edi
8010355a:	e9 71 ff ff ff       	jmp    801034d0 <mpinit+0xf0>
8010355f:	90                   	nop
      ioapicid = ioapic->apicno;
80103560:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103564:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103567:	88 0d a0 37 11 80    	mov    %cl,0x801137a0
      continue;
8010356d:	e9 5e ff ff ff       	jmp    801034d0 <mpinit+0xf0>
80103572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103578:	83 ec 0c             	sub    $0xc,%esp
8010357b:	68 f0 83 10 80       	push   $0x801083f0
80103580:	e8 eb ce ff ff       	call   80100470 <panic>
80103585:	8d 76 00             	lea    0x0(%esi),%esi
{
80103588:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010358d:	eb 0b                	jmp    8010359a <mpinit+0x1ba>
8010358f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103590:	89 f3                	mov    %esi,%ebx
80103592:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103598:	74 de                	je     80103578 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010359a:	83 ec 04             	sub    $0x4,%esp
8010359d:	8d 73 10             	lea    0x10(%ebx),%esi
801035a0:	6a 04                	push   $0x4
801035a2:	68 e6 83 10 80       	push   $0x801083e6
801035a7:	53                   	push   %ebx
801035a8:	e8 03 16 00 00       	call   80104bb0 <memcmp>
801035ad:	83 c4 10             	add    $0x10,%esp
801035b0:	85 c0                	test   %eax,%eax
801035b2:	75 dc                	jne    80103590 <mpinit+0x1b0>
801035b4:	89 da                	mov    %ebx,%edx
801035b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035bd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035c0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801035c3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801035c6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801035c8:	39 d6                	cmp    %edx,%esi
801035ca:	75 f4                	jne    801035c0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035cc:	84 c0                	test   %al,%al
801035ce:	75 c0                	jne    80103590 <mpinit+0x1b0>
801035d0:	e9 5b fe ff ff       	jmp    80103430 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801035d5:	83 ec 0c             	sub    $0xc,%esp
801035d8:	68 20 88 10 80       	push   $0x80108820
801035dd:	e8 8e ce ff ff       	call   80100470 <panic>
801035e2:	66 90                	xchg   %ax,%ax
801035e4:	66 90                	xchg   %ax,%ax
801035e6:	66 90                	xchg   %ax,%ax
801035e8:	66 90                	xchg   %ax,%ax
801035ea:	66 90                	xchg   %ax,%ax
801035ec:	66 90                	xchg   %ax,%ax
801035ee:	66 90                	xchg   %ax,%ax

801035f0 <picinit>:
801035f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035f5:	ba 21 00 00 00       	mov    $0x21,%edx
801035fa:	ee                   	out    %al,(%dx)
801035fb:	ba a1 00 00 00       	mov    $0xa1,%edx
80103600:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103601:	c3                   	ret
80103602:	66 90                	xchg   %ax,%ax
80103604:	66 90                	xchg   %ax,%ax
80103606:	66 90                	xchg   %ax,%ax
80103608:	66 90                	xchg   %ax,%ax
8010360a:	66 90                	xchg   %ax,%ax
8010360c:	66 90                	xchg   %ax,%ax
8010360e:	66 90                	xchg   %ax,%ax

80103610 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	57                   	push   %edi
80103614:	56                   	push   %esi
80103615:	53                   	push   %ebx
80103616:	83 ec 0c             	sub    $0xc,%esp
80103619:	8b 75 08             	mov    0x8(%ebp),%esi
8010361c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010361f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103625:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010362b:	e8 10 d9 ff ff       	call   80100f40 <filealloc>
80103630:	89 06                	mov    %eax,(%esi)
80103632:	85 c0                	test   %eax,%eax
80103634:	0f 84 a5 00 00 00    	je     801036df <pipealloc+0xcf>
8010363a:	e8 01 d9 ff ff       	call   80100f40 <filealloc>
8010363f:	89 07                	mov    %eax,(%edi)
80103641:	85 c0                	test   %eax,%eax
80103643:	0f 84 84 00 00 00    	je     801036cd <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103649:	e8 82 f1 ff ff       	call   801027d0 <kalloc>
8010364e:	89 c3                	mov    %eax,%ebx
80103650:	85 c0                	test   %eax,%eax
80103652:	0f 84 a0 00 00 00    	je     801036f8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103658:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010365f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103662:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103665:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010366c:	00 00 00 
  p->nwrite = 0;
8010366f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103676:	00 00 00 
  p->nread = 0;
80103679:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103680:	00 00 00 
  initlock(&p->lock, "pipe");
80103683:	68 08 84 10 80       	push   $0x80108408
80103688:	50                   	push   %eax
80103689:	e8 f2 11 00 00       	call   80104880 <initlock>
  (*f0)->type = FD_PIPE;
8010368e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103690:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103693:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103699:	8b 06                	mov    (%esi),%eax
8010369b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010369f:	8b 06                	mov    (%esi),%eax
801036a1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036a5:	8b 06                	mov    (%esi),%eax
801036a7:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036aa:	8b 07                	mov    (%edi),%eax
801036ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036b2:	8b 07                	mov    (%edi),%eax
801036b4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036b8:	8b 07                	mov    (%edi),%eax
801036ba:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036be:	8b 07                	mov    (%edi),%eax
801036c0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801036c3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036c8:	5b                   	pop    %ebx
801036c9:	5e                   	pop    %esi
801036ca:	5f                   	pop    %edi
801036cb:	5d                   	pop    %ebp
801036cc:	c3                   	ret
  if(*f0)
801036cd:	8b 06                	mov    (%esi),%eax
801036cf:	85 c0                	test   %eax,%eax
801036d1:	74 1e                	je     801036f1 <pipealloc+0xe1>
    fileclose(*f0);
801036d3:	83 ec 0c             	sub    $0xc,%esp
801036d6:	50                   	push   %eax
801036d7:	e8 24 d9 ff ff       	call   80101000 <fileclose>
801036dc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801036df:	8b 07                	mov    (%edi),%eax
801036e1:	85 c0                	test   %eax,%eax
801036e3:	74 0c                	je     801036f1 <pipealloc+0xe1>
    fileclose(*f1);
801036e5:	83 ec 0c             	sub    $0xc,%esp
801036e8:	50                   	push   %eax
801036e9:	e8 12 d9 ff ff       	call   80101000 <fileclose>
801036ee:	83 c4 10             	add    $0x10,%esp
  return -1;
801036f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801036f6:	eb cd                	jmp    801036c5 <pipealloc+0xb5>
  if(*f0)
801036f8:	8b 06                	mov    (%esi),%eax
801036fa:	85 c0                	test   %eax,%eax
801036fc:	75 d5                	jne    801036d3 <pipealloc+0xc3>
801036fe:	eb df                	jmp    801036df <pipealloc+0xcf>

80103700 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	56                   	push   %esi
80103704:	53                   	push   %ebx
80103705:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103708:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010370b:	83 ec 0c             	sub    $0xc,%esp
8010370e:	53                   	push   %ebx
8010370f:	e8 5c 13 00 00       	call   80104a70 <acquire>
  if(writable){
80103714:	83 c4 10             	add    $0x10,%esp
80103717:	85 f6                	test   %esi,%esi
80103719:	74 65                	je     80103780 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010371b:	83 ec 0c             	sub    $0xc,%esp
8010371e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103724:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010372b:	00 00 00 
    wakeup(&p->nread);
8010372e:	50                   	push   %eax
8010372f:	e8 2c 0c 00 00       	call   80104360 <wakeup>
80103734:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103737:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010373d:	85 d2                	test   %edx,%edx
8010373f:	75 0a                	jne    8010374b <pipeclose+0x4b>
80103741:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103747:	85 c0                	test   %eax,%eax
80103749:	74 15                	je     80103760 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010374b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010374e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103751:	5b                   	pop    %ebx
80103752:	5e                   	pop    %esi
80103753:	5d                   	pop    %ebp
    release(&p->lock);
80103754:	e9 b7 12 00 00       	jmp    80104a10 <release>
80103759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103760:	83 ec 0c             	sub    $0xc,%esp
80103763:	53                   	push   %ebx
80103764:	e8 a7 12 00 00       	call   80104a10 <release>
    kfree((char*)p);
80103769:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010376c:	83 c4 10             	add    $0x10,%esp
}
8010376f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103772:	5b                   	pop    %ebx
80103773:	5e                   	pop    %esi
80103774:	5d                   	pop    %ebp
    kfree((char*)p);
80103775:	e9 26 ee ff ff       	jmp    801025a0 <kfree>
8010377a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103780:	83 ec 0c             	sub    $0xc,%esp
80103783:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103789:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103790:	00 00 00 
    wakeup(&p->nwrite);
80103793:	50                   	push   %eax
80103794:	e8 c7 0b 00 00       	call   80104360 <wakeup>
80103799:	83 c4 10             	add    $0x10,%esp
8010379c:	eb 99                	jmp    80103737 <pipeclose+0x37>
8010379e:	66 90                	xchg   %ax,%ax

801037a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	57                   	push   %edi
801037a4:	56                   	push   %esi
801037a5:	53                   	push   %ebx
801037a6:	83 ec 28             	sub    $0x28,%esp
801037a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801037ac:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
801037af:	53                   	push   %ebx
801037b0:	e8 bb 12 00 00       	call   80104a70 <acquire>
  for(i = 0; i < n; i++){
801037b5:	83 c4 10             	add    $0x10,%esp
801037b8:	85 ff                	test   %edi,%edi
801037ba:	0f 8e ce 00 00 00    	jle    8010388e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037c0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801037c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801037c9:	89 7d 10             	mov    %edi,0x10(%ebp)
801037cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801037cf:	8d 34 39             	lea    (%ecx,%edi,1),%esi
801037d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037d5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037db:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037e1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037e7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801037ed:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801037f0:	0f 85 b6 00 00 00    	jne    801038ac <pipewrite+0x10c>
801037f6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801037f9:	eb 3b                	jmp    80103836 <pipewrite+0x96>
801037fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037ff:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103800:	e8 4b 03 00 00       	call   80103b50 <myproc>
80103805:	8b 48 28             	mov    0x28(%eax),%ecx
80103808:	85 c9                	test   %ecx,%ecx
8010380a:	75 34                	jne    80103840 <pipewrite+0xa0>
      wakeup(&p->nread);
8010380c:	83 ec 0c             	sub    $0xc,%esp
8010380f:	56                   	push   %esi
80103810:	e8 4b 0b 00 00       	call   80104360 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103815:	58                   	pop    %eax
80103816:	5a                   	pop    %edx
80103817:	53                   	push   %ebx
80103818:	57                   	push   %edi
80103819:	e8 82 0a 00 00       	call   801042a0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010381e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103824:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010382a:	83 c4 10             	add    $0x10,%esp
8010382d:	05 00 02 00 00       	add    $0x200,%eax
80103832:	39 c2                	cmp    %eax,%edx
80103834:	75 2a                	jne    80103860 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103836:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010383c:	85 c0                	test   %eax,%eax
8010383e:	75 c0                	jne    80103800 <pipewrite+0x60>
        release(&p->lock);
80103840:	83 ec 0c             	sub    $0xc,%esp
80103843:	53                   	push   %ebx
80103844:	e8 c7 11 00 00       	call   80104a10 <release>
        return -1;
80103849:	83 c4 10             	add    $0x10,%esp
8010384c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103851:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103854:	5b                   	pop    %ebx
80103855:	5e                   	pop    %esi
80103856:	5f                   	pop    %edi
80103857:	5d                   	pop    %ebp
80103858:	c3                   	ret
80103859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103860:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103863:	8d 42 01             	lea    0x1(%edx),%eax
80103866:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010386c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010386f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103875:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103878:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010387c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103880:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103883:	39 c1                	cmp    %eax,%ecx
80103885:	0f 85 50 ff ff ff    	jne    801037db <pipewrite+0x3b>
8010388b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010388e:	83 ec 0c             	sub    $0xc,%esp
80103891:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103897:	50                   	push   %eax
80103898:	e8 c3 0a 00 00       	call   80104360 <wakeup>
  release(&p->lock);
8010389d:	89 1c 24             	mov    %ebx,(%esp)
801038a0:	e8 6b 11 00 00       	call   80104a10 <release>
  return n;
801038a5:	83 c4 10             	add    $0x10,%esp
801038a8:	89 f8                	mov    %edi,%eax
801038aa:	eb a5                	jmp    80103851 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038af:	eb b2                	jmp    80103863 <pipewrite+0xc3>
801038b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038bf:	90                   	nop

801038c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	57                   	push   %edi
801038c4:	56                   	push   %esi
801038c5:	53                   	push   %ebx
801038c6:	83 ec 18             	sub    $0x18,%esp
801038c9:	8b 75 08             	mov    0x8(%ebp),%esi
801038cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038cf:	56                   	push   %esi
801038d0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801038d6:	e8 95 11 00 00       	call   80104a70 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038db:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038e1:	83 c4 10             	add    $0x10,%esp
801038e4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801038ea:	74 2f                	je     8010391b <piperead+0x5b>
801038ec:	eb 37                	jmp    80103925 <piperead+0x65>
801038ee:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801038f0:	e8 5b 02 00 00       	call   80103b50 <myproc>
801038f5:	8b 40 28             	mov    0x28(%eax),%eax
801038f8:	85 c0                	test   %eax,%eax
801038fa:	0f 85 80 00 00 00    	jne    80103980 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103900:	83 ec 08             	sub    $0x8,%esp
80103903:	56                   	push   %esi
80103904:	53                   	push   %ebx
80103905:	e8 96 09 00 00       	call   801042a0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010390a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103910:	83 c4 10             	add    $0x10,%esp
80103913:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103919:	75 0a                	jne    80103925 <piperead+0x65>
8010391b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103921:	85 d2                	test   %edx,%edx
80103923:	75 cb                	jne    801038f0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103925:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103928:	31 db                	xor    %ebx,%ebx
8010392a:	85 c9                	test   %ecx,%ecx
8010392c:	7f 26                	jg     80103954 <piperead+0x94>
8010392e:	eb 2c                	jmp    8010395c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103930:	8d 48 01             	lea    0x1(%eax),%ecx
80103933:	25 ff 01 00 00       	and    $0x1ff,%eax
80103938:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010393e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103943:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103946:	83 c3 01             	add    $0x1,%ebx
80103949:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010394c:	74 0e                	je     8010395c <piperead+0x9c>
8010394e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103954:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010395a:	75 d4                	jne    80103930 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010395c:	83 ec 0c             	sub    $0xc,%esp
8010395f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103965:	50                   	push   %eax
80103966:	e8 f5 09 00 00       	call   80104360 <wakeup>
  release(&p->lock);
8010396b:	89 34 24             	mov    %esi,(%esp)
8010396e:	e8 9d 10 00 00       	call   80104a10 <release>
  return i;
80103973:	83 c4 10             	add    $0x10,%esp
}
80103976:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103979:	89 d8                	mov    %ebx,%eax
8010397b:	5b                   	pop    %ebx
8010397c:	5e                   	pop    %esi
8010397d:	5f                   	pop    %edi
8010397e:	5d                   	pop    %ebp
8010397f:	c3                   	ret
      release(&p->lock);
80103980:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103983:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103988:	56                   	push   %esi
80103989:	e8 82 10 00 00       	call   80104a10 <release>
      return -1;
8010398e:	83 c4 10             	add    $0x10,%esp
}
80103991:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103994:	89 d8                	mov    %ebx,%eax
80103996:	5b                   	pop    %ebx
80103997:	5e                   	pop    %esi
80103998:	5f                   	pop    %edi
80103999:	5d                   	pop    %ebp
8010399a:	c3                   	ret
8010399b:	66 90                	xchg   %ax,%ax
8010399d:	66 90                	xchg   %ax,%ax
8010399f:	90                   	nop

801039a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039a4:	bb b4 38 11 80       	mov    $0x801138b4,%ebx
{
801039a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801039ac:	68 80 38 11 80       	push   $0x80113880
801039b1:	e8 ba 10 00 00       	call   80104a70 <acquire>
801039b6:	83 c4 10             	add    $0x10,%esp
801039b9:	eb 10                	jmp    801039cb <allocproc+0x2b>
801039bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039bf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039c0:	83 eb 80             	sub    $0xffffff80,%ebx
801039c3:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
801039c9:	74 75                	je     80103a40 <allocproc+0xa0>
    if(p->state == UNUSED)
801039cb:	8b 43 10             	mov    0x10(%ebx),%eax
801039ce:	85 c0                	test   %eax,%eax
801039d0:	75 ee                	jne    801039c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039d2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801039d7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039da:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
801039e1:	89 43 14             	mov    %eax,0x14(%ebx)
801039e4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801039e7:	68 80 38 11 80       	push   $0x80113880
  p->pid = nextpid++;
801039ec:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801039f2:	e8 19 10 00 00       	call   80104a10 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039f7:	e8 d4 ed ff ff       	call   801027d0 <kalloc>
801039fc:	83 c4 10             	add    $0x10,%esp
801039ff:	89 43 0c             	mov    %eax,0xc(%ebx)
80103a02:	85 c0                	test   %eax,%eax
80103a04:	74 53                	je     80103a59 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a06:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a0c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103a0f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a14:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
80103a17:	c7 40 14 42 5d 10 80 	movl   $0x80105d42,0x14(%eax)
  p->context = (struct context*)sp;
80103a1e:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a21:	6a 14                	push   $0x14
80103a23:	6a 00                	push   $0x0
80103a25:	50                   	push   %eax
80103a26:	e8 45 11 00 00       	call   80104b70 <memset>
  p->context->eip = (uint)forkret;
80103a2b:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
80103a2e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a31:	c7 40 10 70 3a 10 80 	movl   $0x80103a70,0x10(%eax)
}
80103a38:	89 d8                	mov    %ebx,%eax
80103a3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a3d:	c9                   	leave
80103a3e:	c3                   	ret
80103a3f:	90                   	nop
  release(&ptable.lock);
80103a40:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a43:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a45:	68 80 38 11 80       	push   $0x80113880
80103a4a:	e8 c1 0f 00 00       	call   80104a10 <release>
  return 0;
80103a4f:	83 c4 10             	add    $0x10,%esp
}
80103a52:	89 d8                	mov    %ebx,%eax
80103a54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a57:	c9                   	leave
80103a58:	c3                   	ret
    p->state = UNUSED;
80103a59:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  return 0;
80103a60:	31 db                	xor    %ebx,%ebx
80103a62:	eb ee                	jmp    80103a52 <allocproc+0xb2>
80103a64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a6f:	90                   	nop

80103a70 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a76:	68 80 38 11 80       	push   $0x80113880
80103a7b:	e8 90 0f 00 00       	call   80104a10 <release>

  if (first) {
80103a80:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a85:	83 c4 10             	add    $0x10,%esp
80103a88:	85 c0                	test   %eax,%eax
80103a8a:	75 04                	jne    80103a90 <forkret+0x20>
    initlog(ROOTDEV);
    swapinit();
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a8c:	c9                   	leave
80103a8d:	c3                   	ret
80103a8e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a90:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a97:	00 00 00 
    iinit(ROOTDEV);
80103a9a:	83 ec 0c             	sub    $0xc,%esp
80103a9d:	6a 01                	push   $0x1
80103a9f:	e8 cc db ff ff       	call   80101670 <iinit>
    initlog(ROOTDEV);
80103aa4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103aab:	e8 f0 f3 ff ff       	call   80102ea0 <initlog>
    swapinit();
80103ab0:	83 c4 10             	add    $0x10,%esp
}
80103ab3:	c9                   	leave
    swapinit();
80103ab4:	e9 57 3f 00 00       	jmp    80107a10 <swapinit>
80103ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ac0 <pinit>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ac6:	68 0d 84 10 80       	push   $0x8010840d
80103acb:	68 80 38 11 80       	push   $0x80113880
80103ad0:	e8 ab 0d 00 00       	call   80104880 <initlock>
}
80103ad5:	83 c4 10             	add    $0x10,%esp
80103ad8:	c9                   	leave
80103ad9:	c3                   	ret
80103ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ae0 <mycpu>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ae6:	9c                   	pushf
80103ae7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ae8:	f6 c4 02             	test   $0x2,%ah
80103aeb:	75 32                	jne    80103b1f <mycpu+0x3f>
  apicid = lapicid();
80103aed:	e8 de ef ff ff       	call   80102ad0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103af2:	8b 15 a4 37 11 80    	mov    0x801137a4,%edx
80103af8:	85 d2                	test   %edx,%edx
80103afa:	7e 0b                	jle    80103b07 <mycpu+0x27>
    if (cpus[i].apicid == apicid)
80103afc:	0f b6 15 c0 37 11 80 	movzbl 0x801137c0,%edx
80103b03:	39 d0                	cmp    %edx,%eax
80103b05:	74 11                	je     80103b18 <mycpu+0x38>
  panic("unknown apicid\n");
80103b07:	83 ec 0c             	sub    $0xc,%esp
80103b0a:	68 14 84 10 80       	push   $0x80108414
80103b0f:	e8 5c c9 ff ff       	call   80100470 <panic>
80103b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80103b18:	c9                   	leave
80103b19:	b8 c0 37 11 80       	mov    $0x801137c0,%eax
80103b1e:	c3                   	ret
    panic("mycpu called with interrupts enabled\n");
80103b1f:	83 ec 0c             	sub    $0xc,%esp
80103b22:	68 40 88 10 80       	push   $0x80108840
80103b27:	e8 44 c9 ff ff       	call   80100470 <panic>
80103b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b30 <cpuid>:
cpuid() {
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b36:	e8 a5 ff ff ff       	call   80103ae0 <mycpu>
}
80103b3b:	c9                   	leave
  return mycpu()-cpus;
80103b3c:	2d c0 37 11 80       	sub    $0x801137c0,%eax
80103b41:	c1 f8 04             	sar    $0x4,%eax
80103b44:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b4a:	c3                   	ret
80103b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b4f:	90                   	nop

80103b50 <myproc>:
myproc(void) {
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	53                   	push   %ebx
80103b54:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b57:	e8 c4 0d 00 00       	call   80104920 <pushcli>
  c = mycpu();
80103b5c:	e8 7f ff ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103b61:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b67:	e8 04 0e 00 00       	call   80104970 <popcli>
}
80103b6c:	89 d8                	mov    %ebx,%eax
80103b6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b71:	c9                   	leave
80103b72:	c3                   	ret
80103b73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b80 <userinit>:
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	53                   	push   %ebx
80103b84:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b87:	e8 14 fe ff ff       	call   801039a0 <allocproc>
80103b8c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b8e:	a3 b4 58 11 80       	mov    %eax,0x801158b4
  if((p->pgdir = setupkvm()) == 0)
80103b93:	e8 f8 38 00 00       	call   80107490 <setupkvm>
80103b98:	89 43 08             	mov    %eax,0x8(%ebx)
80103b9b:	85 c0                	test   %eax,%eax
80103b9d:	0f 84 bd 00 00 00    	je     80103c60 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ba3:	83 ec 04             	sub    $0x4,%esp
80103ba6:	68 2c 00 00 00       	push   $0x2c
80103bab:	68 60 b4 10 80       	push   $0x8010b460
80103bb0:	50                   	push   %eax
80103bb1:	e8 8a 35 00 00       	call   80107140 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103bb6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103bb9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bbf:	6a 4c                	push   $0x4c
80103bc1:	6a 00                	push   $0x0
80103bc3:	ff 73 1c             	push   0x1c(%ebx)
80103bc6:	e8 a5 0f 00 00       	call   80104b70 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bcb:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bce:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bd3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bd6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bdb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bdf:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103be2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103be6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103be9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bed:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bf1:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bf4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bf8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bfc:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c06:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c09:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c10:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c13:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c1a:	8d 43 70             	lea    0x70(%ebx),%eax
80103c1d:	6a 10                	push   $0x10
80103c1f:	68 3d 84 10 80       	push   $0x8010843d
80103c24:	50                   	push   %eax
80103c25:	e8 f6 10 00 00       	call   80104d20 <safestrcpy>
  p->cwd = namei("/");
80103c2a:	c7 04 24 46 84 10 80 	movl   $0x80108446,(%esp)
80103c31:	e8 3a e5 ff ff       	call   80102170 <namei>
80103c36:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
80103c39:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103c40:	e8 2b 0e 00 00       	call   80104a70 <acquire>
  p->state = RUNNABLE;
80103c45:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
80103c4c:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103c53:	e8 b8 0d 00 00       	call   80104a10 <release>
}
80103c58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c5b:	83 c4 10             	add    $0x10,%esp
80103c5e:	c9                   	leave
80103c5f:	c3                   	ret
    panic("userinit: out of memory?");
80103c60:	83 ec 0c             	sub    $0xc,%esp
80103c63:	68 24 84 10 80       	push   $0x80108424
80103c68:	e8 03 c8 ff ff       	call   80100470 <panic>
80103c6d:	8d 76 00             	lea    0x0(%esi),%esi

80103c70 <growproc>:
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	56                   	push   %esi
80103c74:	53                   	push   %ebx
80103c75:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c78:	e8 a3 0c 00 00       	call   80104920 <pushcli>
  c = mycpu();
80103c7d:	e8 5e fe ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103c82:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c88:	e8 e3 0c 00 00       	call   80104970 <popcli>
  sz = curproc->sz;
80103c8d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c8f:	85 f6                	test   %esi,%esi
80103c91:	7f 1d                	jg     80103cb0 <growproc+0x40>
  } else if(n < 0){
80103c93:	75 3b                	jne    80103cd0 <growproc+0x60>
  switchuvm(curproc);
80103c95:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c98:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c9a:	53                   	push   %ebx
80103c9b:	e8 90 33 00 00       	call   80107030 <switchuvm>
  return 0;
80103ca0:	83 c4 10             	add    $0x10,%esp
80103ca3:	31 c0                	xor    %eax,%eax
}
80103ca5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ca8:	5b                   	pop    %ebx
80103ca9:	5e                   	pop    %esi
80103caa:	5d                   	pop    %ebp
80103cab:	c3                   	ret
80103cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cb0:	83 ec 04             	sub    $0x4,%esp
80103cb3:	01 c6                	add    %eax,%esi
80103cb5:	56                   	push   %esi
80103cb6:	50                   	push   %eax
80103cb7:	ff 73 08             	push   0x8(%ebx)
80103cba:	e8 d1 35 00 00       	call   80107290 <allocuvm>
80103cbf:	83 c4 10             	add    $0x10,%esp
80103cc2:	85 c0                	test   %eax,%eax
80103cc4:	75 cf                	jne    80103c95 <growproc+0x25>
      return -1;
80103cc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ccb:	eb d8                	jmp    80103ca5 <growproc+0x35>
80103ccd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cd0:	83 ec 04             	sub    $0x4,%esp
80103cd3:	01 c6                	add    %eax,%esi
80103cd5:	56                   	push   %esi
80103cd6:	50                   	push   %eax
80103cd7:	ff 73 08             	push   0x8(%ebx)
80103cda:	e8 d1 36 00 00       	call   801073b0 <deallocuvm>
80103cdf:	83 c4 10             	add    $0x10,%esp
80103ce2:	85 c0                	test   %eax,%eax
80103ce4:	75 af                	jne    80103c95 <growproc+0x25>
80103ce6:	eb de                	jmp    80103cc6 <growproc+0x56>
80103ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cef:	90                   	nop

80103cf0 <fork>:
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	57                   	push   %edi
80103cf4:	56                   	push   %esi
80103cf5:	53                   	push   %ebx
80103cf6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103cf9:	e8 22 0c 00 00       	call   80104920 <pushcli>
  c = mycpu();
80103cfe:	e8 dd fd ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103d03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d09:	e8 62 0c 00 00       	call   80104970 <popcli>
  if((np = allocproc()) == 0){
80103d0e:	e8 8d fc ff ff       	call   801039a0 <allocproc>
80103d13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d16:	85 c0                	test   %eax,%eax
80103d18:	0f 84 de 00 00 00    	je     80103dfc <fork+0x10c>
  if((np->pgdir = copyuvm_cow(curproc->pgdir, curproc->sz,np)) == 0){
80103d1e:	83 ec 04             	sub    $0x4,%esp
80103d21:	89 c7                	mov    %eax,%edi
80103d23:	50                   	push   %eax
80103d24:	ff 33                	push   (%ebx)
80103d26:	ff 73 08             	push   0x8(%ebx)
80103d29:	e8 82 39 00 00       	call   801076b0 <copyuvm_cow>
80103d2e:	83 c4 10             	add    $0x10,%esp
80103d31:	89 47 08             	mov    %eax,0x8(%edi)
80103d34:	85 c0                	test   %eax,%eax
80103d36:	0f 84 a1 00 00 00    	je     80103ddd <fork+0xed>
  np->sz = curproc->sz;
80103d3c:	8b 03                	mov    (%ebx),%eax
80103d3e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d41:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d43:	8b 79 1c             	mov    0x1c(%ecx),%edi
  np->parent = curproc;
80103d46:	89 c8                	mov    %ecx,%eax
80103d48:	89 59 18             	mov    %ebx,0x18(%ecx)
  *np->tf = *curproc->tf;
80103d4b:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d50:	8b 73 1c             	mov    0x1c(%ebx),%esi
80103d53:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d55:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d57:	8b 40 1c             	mov    0x1c(%eax),%eax
80103d5a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103d68:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103d6c:	85 c0                	test   %eax,%eax
80103d6e:	74 13                	je     80103d83 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d70:	83 ec 0c             	sub    $0xc,%esp
80103d73:	50                   	push   %eax
80103d74:	e8 37 d2 ff ff       	call   80100fb0 <filedup>
80103d79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d7c:	83 c4 10             	add    $0x10,%esp
80103d7f:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d83:	83 c6 01             	add    $0x1,%esi
80103d86:	83 fe 10             	cmp    $0x10,%esi
80103d89:	75 dd                	jne    80103d68 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103d8b:	83 ec 0c             	sub    $0xc,%esp
80103d8e:	ff 73 6c             	push   0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d91:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103d94:	e8 c7 da ff ff       	call   80101860 <idup>
80103d99:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d9c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d9f:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103da2:	8d 47 70             	lea    0x70(%edi),%eax
80103da5:	6a 10                	push   $0x10
80103da7:	53                   	push   %ebx
80103da8:	50                   	push   %eax
80103da9:	e8 72 0f 00 00       	call   80104d20 <safestrcpy>
  pid = np->pid;
80103dae:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
80103db1:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103db8:	e8 b3 0c 00 00       	call   80104a70 <acquire>
  np->state = RUNNABLE;
80103dbd:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
80103dc4:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103dcb:	e8 40 0c 00 00       	call   80104a10 <release>
  return pid;
80103dd0:	83 c4 10             	add    $0x10,%esp
}
80103dd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dd6:	89 d8                	mov    %ebx,%eax
80103dd8:	5b                   	pop    %ebx
80103dd9:	5e                   	pop    %esi
80103dda:	5f                   	pop    %edi
80103ddb:	5d                   	pop    %ebp
80103ddc:	c3                   	ret
    kfree(np->kstack);
80103ddd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103de0:	83 ec 0c             	sub    $0xc,%esp
80103de3:	ff 73 0c             	push   0xc(%ebx)
80103de6:	e8 b5 e7 ff ff       	call   801025a0 <kfree>
    np->kstack = 0;
80103deb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103df2:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103df5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
80103dfc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e01:	eb d0                	jmp    80103dd3 <fork+0xe3>
80103e03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e10 <print_rss>:
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e14:	bb b4 38 11 80       	mov    $0x801138b4,%ebx
{
80103e19:	83 ec 10             	sub    $0x10,%esp
  cprintf("PrintingRSS\n");
80103e1c:	68 48 84 10 80       	push   $0x80108448
80103e21:	e8 7a c9 ff ff       	call   801007a0 <cprintf>
  acquire(&ptable.lock);
80103e26:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80103e2d:	e8 3e 0c 00 00       	call   80104a70 <acquire>
80103e32:	83 c4 10             	add    $0x10,%esp
80103e35:	8d 76 00             	lea    0x0(%esi),%esi
    if((p->state == UNUSED))
80103e38:	8b 43 10             	mov    0x10(%ebx),%eax
80103e3b:	85 c0                	test   %eax,%eax
80103e3d:	74 14                	je     80103e53 <print_rss+0x43>
    cprintf("((P)) id: %d, state: %d, rss: %d\n",p->pid,p->state,p->rss);
80103e3f:	ff 73 04             	push   0x4(%ebx)
80103e42:	50                   	push   %eax
80103e43:	ff 73 14             	push   0x14(%ebx)
80103e46:	68 68 88 10 80       	push   $0x80108868
80103e4b:	e8 50 c9 ff ff       	call   801007a0 <cprintf>
80103e50:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e53:	83 eb 80             	sub    $0xffffff80,%ebx
80103e56:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
80103e5c:	75 da                	jne    80103e38 <print_rss+0x28>
  release(&ptable.lock);
80103e5e:	83 ec 0c             	sub    $0xc,%esp
80103e61:	68 80 38 11 80       	push   $0x80113880
80103e66:	e8 a5 0b 00 00       	call   80104a10 <release>
}
80103e6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e6e:	83 c4 10             	add    $0x10,%esp
80103e71:	c9                   	leave
80103e72:	c3                   	ret
80103e73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e80 <scheduler>:
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	57                   	push   %edi
80103e84:	56                   	push   %esi
80103e85:	53                   	push   %ebx
80103e86:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e89:	e8 52 fc ff ff       	call   80103ae0 <mycpu>
  c->proc = 0;
80103e8e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e95:	00 00 00 
  struct cpu *c = mycpu();
80103e98:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e9a:	8d 78 04             	lea    0x4(%eax),%edi
80103e9d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103ea0:	fb                   	sti
    acquire(&ptable.lock);
80103ea1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ea4:	bb b4 38 11 80       	mov    $0x801138b4,%ebx
    acquire(&ptable.lock);
80103ea9:	68 80 38 11 80       	push   $0x80113880
80103eae:	e8 bd 0b 00 00       	call   80104a70 <acquire>
80103eb3:	83 c4 10             	add    $0x10,%esp
80103eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ebd:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103ec0:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80103ec4:	75 33                	jne    80103ef9 <scheduler+0x79>
      switchuvm(p);
80103ec6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103ec9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103ecf:	53                   	push   %ebx
80103ed0:	e8 5b 31 00 00       	call   80107030 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ed5:	58                   	pop    %eax
80103ed6:	5a                   	pop    %edx
80103ed7:	ff 73 20             	push   0x20(%ebx)
80103eda:	57                   	push   %edi
      p->state = RUNNING;
80103edb:	c7 43 10 04 00 00 00 	movl   $0x4,0x10(%ebx)
      swtch(&(c->scheduler), p->context);
80103ee2:	e8 94 0e 00 00       	call   80104d7b <swtch>
      switchkvm();
80103ee7:	e8 34 31 00 00       	call   80107020 <switchkvm>
      c->proc = 0;
80103eec:	83 c4 10             	add    $0x10,%esp
80103eef:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ef6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef9:	83 eb 80             	sub    $0xffffff80,%ebx
80103efc:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
80103f02:	75 bc                	jne    80103ec0 <scheduler+0x40>
    release(&ptable.lock);
80103f04:	83 ec 0c             	sub    $0xc,%esp
80103f07:	68 80 38 11 80       	push   $0x80113880
80103f0c:	e8 ff 0a 00 00       	call   80104a10 <release>
    sti();
80103f11:	83 c4 10             	add    $0x10,%esp
80103f14:	eb 8a                	jmp    80103ea0 <scheduler+0x20>
80103f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f1d:	8d 76 00             	lea    0x0(%esi),%esi

80103f20 <sched>:
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	56                   	push   %esi
80103f24:	53                   	push   %ebx
  pushcli();
80103f25:	e8 f6 09 00 00       	call   80104920 <pushcli>
  c = mycpu();
80103f2a:	e8 b1 fb ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103f2f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f35:	e8 36 0a 00 00       	call   80104970 <popcli>
  if(!holding(&ptable.lock))
80103f3a:	83 ec 0c             	sub    $0xc,%esp
80103f3d:	68 80 38 11 80       	push   $0x80113880
80103f42:	e8 89 0a 00 00       	call   801049d0 <holding>
80103f47:	83 c4 10             	add    $0x10,%esp
80103f4a:	85 c0                	test   %eax,%eax
80103f4c:	74 4f                	je     80103f9d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f4e:	e8 8d fb ff ff       	call   80103ae0 <mycpu>
80103f53:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f5a:	75 68                	jne    80103fc4 <sched+0xa4>
  if(p->state == RUNNING)
80103f5c:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80103f60:	74 55                	je     80103fb7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f62:	9c                   	pushf
80103f63:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f64:	f6 c4 02             	test   $0x2,%ah
80103f67:	75 41                	jne    80103faa <sched+0x8a>
  intena = mycpu()->intena;
80103f69:	e8 72 fb ff ff       	call   80103ae0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f6e:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
80103f71:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f77:	e8 64 fb ff ff       	call   80103ae0 <mycpu>
80103f7c:	83 ec 08             	sub    $0x8,%esp
80103f7f:	ff 70 04             	push   0x4(%eax)
80103f82:	53                   	push   %ebx
80103f83:	e8 f3 0d 00 00       	call   80104d7b <swtch>
  mycpu()->intena = intena;
80103f88:	e8 53 fb ff ff       	call   80103ae0 <mycpu>
}
80103f8d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f90:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f99:	5b                   	pop    %ebx
80103f9a:	5e                   	pop    %esi
80103f9b:	5d                   	pop    %ebp
80103f9c:	c3                   	ret
    panic("sched ptable.lock");
80103f9d:	83 ec 0c             	sub    $0xc,%esp
80103fa0:	68 55 84 10 80       	push   $0x80108455
80103fa5:	e8 c6 c4 ff ff       	call   80100470 <panic>
    panic("sched interruptible");
80103faa:	83 ec 0c             	sub    $0xc,%esp
80103fad:	68 81 84 10 80       	push   $0x80108481
80103fb2:	e8 b9 c4 ff ff       	call   80100470 <panic>
    panic("sched running");
80103fb7:	83 ec 0c             	sub    $0xc,%esp
80103fba:	68 73 84 10 80       	push   $0x80108473
80103fbf:	e8 ac c4 ff ff       	call   80100470 <panic>
    panic("sched locks");
80103fc4:	83 ec 0c             	sub    $0xc,%esp
80103fc7:	68 67 84 10 80       	push   $0x80108467
80103fcc:	e8 9f c4 ff ff       	call   80100470 <panic>
80103fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fdf:	90                   	nop

80103fe0 <exit>:
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	57                   	push   %edi
80103fe4:	56                   	push   %esi
80103fe5:	53                   	push   %ebx
80103fe6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103fe9:	e8 62 fb ff ff       	call   80103b50 <myproc>
  if(curproc == initproc)
80103fee:	39 05 b4 58 11 80    	cmp    %eax,0x801158b4
80103ff4:	0f 84 fd 00 00 00    	je     801040f7 <exit+0x117>
80103ffa:	89 c3                	mov    %eax,%ebx
80103ffc:	8d 70 2c             	lea    0x2c(%eax),%esi
80103fff:	8d 78 6c             	lea    0x6c(%eax),%edi
80104002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104008:	8b 06                	mov    (%esi),%eax
8010400a:	85 c0                	test   %eax,%eax
8010400c:	74 12                	je     80104020 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010400e:	83 ec 0c             	sub    $0xc,%esp
80104011:	50                   	push   %eax
80104012:	e8 e9 cf ff ff       	call   80101000 <fileclose>
      curproc->ofile[fd] = 0;
80104017:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010401d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104020:	83 c6 04             	add    $0x4,%esi
80104023:	39 f7                	cmp    %esi,%edi
80104025:	75 e1                	jne    80104008 <exit+0x28>
  begin_op();
80104027:	e8 14 ef ff ff       	call   80102f40 <begin_op>
  iput(curproc->cwd);
8010402c:	83 ec 0c             	sub    $0xc,%esp
8010402f:	ff 73 6c             	push   0x6c(%ebx)
80104032:	e8 89 d9 ff ff       	call   801019c0 <iput>
  end_op();
80104037:	e8 74 ef ff ff       	call   80102fb0 <end_op>
  curproc->cwd = 0;
8010403c:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
80104043:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
8010404a:	e8 21 0a 00 00       	call   80104a70 <acquire>
  wakeup1(curproc->parent);
8010404f:	8b 53 18             	mov    0x18(%ebx),%edx
80104052:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104055:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
8010405a:	eb 0e                	jmp    8010406a <exit+0x8a>
8010405c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104060:	83 e8 80             	sub    $0xffffff80,%eax
80104063:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104068:	74 1c                	je     80104086 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010406a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010406e:	75 f0                	jne    80104060 <exit+0x80>
80104070:	3b 50 24             	cmp    0x24(%eax),%edx
80104073:	75 eb                	jne    80104060 <exit+0x80>
      p->state = RUNNABLE;
80104075:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010407c:	83 e8 80             	sub    $0xffffff80,%eax
8010407f:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104084:	75 e4                	jne    8010406a <exit+0x8a>
      p->parent = initproc;
80104086:	8b 0d b4 58 11 80    	mov    0x801158b4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010408c:	ba b4 38 11 80       	mov    $0x801138b4,%edx
80104091:	eb 10                	jmp    801040a3 <exit+0xc3>
80104093:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104097:	90                   	nop
80104098:	83 ea 80             	sub    $0xffffff80,%edx
8010409b:	81 fa b4 58 11 80    	cmp    $0x801158b4,%edx
801040a1:	74 3b                	je     801040de <exit+0xfe>
    if(p->parent == curproc){
801040a3:	39 5a 18             	cmp    %ebx,0x18(%edx)
801040a6:	75 f0                	jne    80104098 <exit+0xb8>
      if(p->state == ZOMBIE)
801040a8:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
      p->parent = initproc;
801040ac:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
801040af:	75 e7                	jne    80104098 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040b1:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
801040b6:	eb 12                	jmp    801040ca <exit+0xea>
801040b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040bf:	90                   	nop
801040c0:	83 e8 80             	sub    $0xffffff80,%eax
801040c3:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
801040c8:	74 ce                	je     80104098 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
801040ca:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801040ce:	75 f0                	jne    801040c0 <exit+0xe0>
801040d0:	3b 48 24             	cmp    0x24(%eax),%ecx
801040d3:	75 eb                	jne    801040c0 <exit+0xe0>
      p->state = RUNNABLE;
801040d5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
801040dc:	eb e2                	jmp    801040c0 <exit+0xe0>
  curproc->state = ZOMBIE;
801040de:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
801040e5:	e8 36 fe ff ff       	call   80103f20 <sched>
  panic("zombie exit");
801040ea:	83 ec 0c             	sub    $0xc,%esp
801040ed:	68 a2 84 10 80       	push   $0x801084a2
801040f2:	e8 79 c3 ff ff       	call   80100470 <panic>
    panic("init exiting");
801040f7:	83 ec 0c             	sub    $0xc,%esp
801040fa:	68 95 84 10 80       	push   $0x80108495
801040ff:	e8 6c c3 ff ff       	call   80100470 <panic>
80104104:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010410b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010410f:	90                   	nop

80104110 <wait>:
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	56                   	push   %esi
80104114:	53                   	push   %ebx
  pushcli();
80104115:	e8 06 08 00 00       	call   80104920 <pushcli>
  c = mycpu();
8010411a:	e8 c1 f9 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
8010411f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104125:	e8 46 08 00 00       	call   80104970 <popcli>
  acquire(&ptable.lock);
8010412a:	83 ec 0c             	sub    $0xc,%esp
8010412d:	68 80 38 11 80       	push   $0x80113880
80104132:	e8 39 09 00 00       	call   80104a70 <acquire>
80104137:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010413a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010413c:	bb b4 38 11 80       	mov    $0x801138b4,%ebx
80104141:	eb 10                	jmp    80104153 <wait+0x43>
80104143:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104147:	90                   	nop
80104148:	83 eb 80             	sub    $0xffffff80,%ebx
8010414b:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
80104151:	74 1b                	je     8010416e <wait+0x5e>
      if(p->parent != curproc)
80104153:	39 73 18             	cmp    %esi,0x18(%ebx)
80104156:	75 f0                	jne    80104148 <wait+0x38>
      if(p->state == ZOMBIE){
80104158:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
8010415c:	74 62                	je     801041c0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010415e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104161:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104166:	81 fb b4 58 11 80    	cmp    $0x801158b4,%ebx
8010416c:	75 e5                	jne    80104153 <wait+0x43>
    if(!havekids || curproc->killed){
8010416e:	85 c0                	test   %eax,%eax
80104170:	0f 84 b0 00 00 00    	je     80104226 <wait+0x116>
80104176:	8b 46 28             	mov    0x28(%esi),%eax
80104179:	85 c0                	test   %eax,%eax
8010417b:	0f 85 a5 00 00 00    	jne    80104226 <wait+0x116>
  pushcli();
80104181:	e8 9a 07 00 00       	call   80104920 <pushcli>
  c = mycpu();
80104186:	e8 55 f9 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
8010418b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104191:	e8 da 07 00 00       	call   80104970 <popcli>
  if(p == 0)
80104196:	85 db                	test   %ebx,%ebx
80104198:	0f 84 9f 00 00 00    	je     8010423d <wait+0x12d>
  p->chan = chan;
8010419e:	89 73 24             	mov    %esi,0x24(%ebx)
  p->state = SLEEPING;
801041a1:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801041a8:	e8 73 fd ff ff       	call   80103f20 <sched>
  p->chan = 0;
801041ad:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
801041b4:	eb 84                	jmp    8010413a <wait+0x2a>
801041b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041bd:	8d 76 00             	lea    0x0(%esi),%esi
        clear_zombie(p);
801041c0:	83 ec 0c             	sub    $0xc,%esp
801041c3:	53                   	push   %ebx
801041c4:	e8 97 36 00 00       	call   80107860 <clear_zombie>
        kfree(p->kstack);
801041c9:	5a                   	pop    %edx
        pid = p->pid;
801041ca:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
801041cd:	ff 73 0c             	push   0xc(%ebx)
801041d0:	e8 cb e3 ff ff       	call   801025a0 <kfree>
        p->rss -= PGSIZE; // for k-stack
801041d5:	81 6b 04 00 10 00 00 	subl   $0x1000,0x4(%ebx)
        p->kstack = 0;
801041dc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm_proc(p,p->pgdir);
801041e3:	59                   	pop    %ecx
801041e4:	58                   	pop    %eax
801041e5:	ff 73 08             	push   0x8(%ebx)
801041e8:	53                   	push   %ebx
801041e9:	e8 f2 35 00 00       	call   801077e0 <freevm_proc>
        p->pid = 0;
801041ee:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
801041f5:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
801041fc:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
80104200:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80104207:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
8010420e:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80104215:	e8 f6 07 00 00       	call   80104a10 <release>
        return pid;
8010421a:	83 c4 10             	add    $0x10,%esp
}
8010421d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104220:	89 f0                	mov    %esi,%eax
80104222:	5b                   	pop    %ebx
80104223:	5e                   	pop    %esi
80104224:	5d                   	pop    %ebp
80104225:	c3                   	ret
      release(&ptable.lock);
80104226:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104229:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010422e:	68 80 38 11 80       	push   $0x80113880
80104233:	e8 d8 07 00 00       	call   80104a10 <release>
      return -1;
80104238:	83 c4 10             	add    $0x10,%esp
8010423b:	eb e0                	jmp    8010421d <wait+0x10d>
    panic("sleep");
8010423d:	83 ec 0c             	sub    $0xc,%esp
80104240:	68 ae 84 10 80       	push   $0x801084ae
80104245:	e8 26 c2 ff ff       	call   80100470 <panic>
8010424a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104250 <yield>:
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	53                   	push   %ebx
80104254:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104257:	68 80 38 11 80       	push   $0x80113880
8010425c:	e8 0f 08 00 00       	call   80104a70 <acquire>
  pushcli();
80104261:	e8 ba 06 00 00       	call   80104920 <pushcli>
  c = mycpu();
80104266:	e8 75 f8 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
8010426b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104271:	e8 fa 06 00 00       	call   80104970 <popcli>
  myproc()->state = RUNNABLE;
80104276:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
8010427d:	e8 9e fc ff ff       	call   80103f20 <sched>
  release(&ptable.lock);
80104282:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80104289:	e8 82 07 00 00       	call   80104a10 <release>
}
8010428e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104291:	83 c4 10             	add    $0x10,%esp
80104294:	c9                   	leave
80104295:	c3                   	ret
80104296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010429d:	8d 76 00             	lea    0x0(%esi),%esi

801042a0 <sleep>:
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	57                   	push   %edi
801042a4:	56                   	push   %esi
801042a5:	53                   	push   %ebx
801042a6:	83 ec 0c             	sub    $0xc,%esp
801042a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801042ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801042af:	e8 6c 06 00 00       	call   80104920 <pushcli>
  c = mycpu();
801042b4:	e8 27 f8 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
801042b9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042bf:	e8 ac 06 00 00       	call   80104970 <popcli>
  if(p == 0)
801042c4:	85 db                	test   %ebx,%ebx
801042c6:	0f 84 87 00 00 00    	je     80104353 <sleep+0xb3>
  if(lk == 0)
801042cc:	85 f6                	test   %esi,%esi
801042ce:	74 76                	je     80104346 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042d0:	81 fe 80 38 11 80    	cmp    $0x80113880,%esi
801042d6:	74 50                	je     80104328 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042d8:	83 ec 0c             	sub    $0xc,%esp
801042db:	68 80 38 11 80       	push   $0x80113880
801042e0:	e8 8b 07 00 00       	call   80104a70 <acquire>
    release(lk);
801042e5:	89 34 24             	mov    %esi,(%esp)
801042e8:	e8 23 07 00 00       	call   80104a10 <release>
  p->chan = chan;
801042ed:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
801042f0:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801042f7:	e8 24 fc ff ff       	call   80103f20 <sched>
  p->chan = 0;
801042fc:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
80104303:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
8010430a:	e8 01 07 00 00       	call   80104a10 <release>
    acquire(lk);
8010430f:	89 75 08             	mov    %esi,0x8(%ebp)
80104312:	83 c4 10             	add    $0x10,%esp
}
80104315:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104318:	5b                   	pop    %ebx
80104319:	5e                   	pop    %esi
8010431a:	5f                   	pop    %edi
8010431b:	5d                   	pop    %ebp
    acquire(lk);
8010431c:	e9 4f 07 00 00       	jmp    80104a70 <acquire>
80104321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104328:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
8010432b:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104332:	e8 e9 fb ff ff       	call   80103f20 <sched>
  p->chan = 0;
80104337:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
8010433e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104341:	5b                   	pop    %ebx
80104342:	5e                   	pop    %esi
80104343:	5f                   	pop    %edi
80104344:	5d                   	pop    %ebp
80104345:	c3                   	ret
    panic("sleep without lk");
80104346:	83 ec 0c             	sub    $0xc,%esp
80104349:	68 b4 84 10 80       	push   $0x801084b4
8010434e:	e8 1d c1 ff ff       	call   80100470 <panic>
    panic("sleep");
80104353:	83 ec 0c             	sub    $0xc,%esp
80104356:	68 ae 84 10 80       	push   $0x801084ae
8010435b:	e8 10 c1 ff ff       	call   80100470 <panic>

80104360 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	83 ec 10             	sub    $0x10,%esp
80104367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010436a:	68 80 38 11 80       	push   $0x80113880
8010436f:	e8 fc 06 00 00       	call   80104a70 <acquire>
80104374:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104377:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
8010437c:	eb 0c                	jmp    8010438a <wakeup+0x2a>
8010437e:	66 90                	xchg   %ax,%ax
80104380:	83 e8 80             	sub    $0xffffff80,%eax
80104383:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104388:	74 1c                	je     801043a6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010438a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010438e:	75 f0                	jne    80104380 <wakeup+0x20>
80104390:	3b 58 24             	cmp    0x24(%eax),%ebx
80104393:	75 eb                	jne    80104380 <wakeup+0x20>
      p->state = RUNNABLE;
80104395:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010439c:	83 e8 80             	sub    $0xffffff80,%eax
8010439f:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
801043a4:	75 e4                	jne    8010438a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801043a6:	c7 45 08 80 38 11 80 	movl   $0x80113880,0x8(%ebp)
}
801043ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b0:	c9                   	leave
  release(&ptable.lock);
801043b1:	e9 5a 06 00 00       	jmp    80104a10 <release>
801043b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043bd:	8d 76 00             	lea    0x0(%esi),%esi

801043c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	53                   	push   %ebx
801043c4:	83 ec 10             	sub    $0x10,%esp
801043c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801043ca:	68 80 38 11 80       	push   $0x80113880
801043cf:	e8 9c 06 00 00       	call   80104a70 <acquire>
801043d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043d7:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
801043dc:	eb 0c                	jmp    801043ea <kill+0x2a>
801043de:	66 90                	xchg   %ax,%ax
801043e0:	83 e8 80             	sub    $0xffffff80,%eax
801043e3:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
801043e8:	74 36                	je     80104420 <kill+0x60>
    if(p->pid == pid){
801043ea:	39 58 14             	cmp    %ebx,0x14(%eax)
801043ed:	75 f1                	jne    801043e0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043ef:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
801043f3:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
801043fa:	75 07                	jne    80104403 <kill+0x43>
        p->state = RUNNABLE;
801043fc:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
80104403:	83 ec 0c             	sub    $0xc,%esp
80104406:	68 80 38 11 80       	push   $0x80113880
8010440b:	e8 00 06 00 00       	call   80104a10 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104410:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104413:	83 c4 10             	add    $0x10,%esp
80104416:	31 c0                	xor    %eax,%eax
}
80104418:	c9                   	leave
80104419:	c3                   	ret
8010441a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104420:	83 ec 0c             	sub    $0xc,%esp
80104423:	68 80 38 11 80       	push   $0x80113880
80104428:	e8 e3 05 00 00       	call   80104a10 <release>
}
8010442d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104430:	83 c4 10             	add    $0x10,%esp
80104433:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104438:	c9                   	leave
80104439:	c3                   	ret
8010443a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104440 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	57                   	push   %edi
80104444:	56                   	push   %esi
80104445:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104448:	53                   	push   %ebx
80104449:	bb 24 39 11 80       	mov    $0x80113924,%ebx
8010444e:	83 ec 3c             	sub    $0x3c,%esp
80104451:	eb 24                	jmp    80104477 <procdump+0x37>
80104453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104457:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104458:	83 ec 0c             	sub    $0xc,%esp
8010445b:	68 82 86 10 80       	push   $0x80108682
80104460:	e8 3b c3 ff ff       	call   801007a0 <cprintf>
80104465:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104468:	83 eb 80             	sub    $0xffffff80,%ebx
8010446b:	81 fb 24 59 11 80    	cmp    $0x80115924,%ebx
80104471:	0f 84 81 00 00 00    	je     801044f8 <procdump+0xb8>
    if(p->state == UNUSED)
80104477:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010447a:	85 c0                	test   %eax,%eax
8010447c:	74 ea                	je     80104468 <procdump+0x28>
      state = "???";
8010447e:	ba c5 84 10 80       	mov    $0x801084c5,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104483:	83 f8 05             	cmp    $0x5,%eax
80104486:	77 11                	ja     80104499 <procdump+0x59>
80104488:	8b 14 85 c0 8b 10 80 	mov    -0x7fef7440(,%eax,4),%edx
      state = "???";
8010448f:	b8 c5 84 10 80       	mov    $0x801084c5,%eax
80104494:	85 d2                	test   %edx,%edx
80104496:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104499:	53                   	push   %ebx
8010449a:	52                   	push   %edx
8010449b:	ff 73 a4             	push   -0x5c(%ebx)
8010449e:	68 c9 84 10 80       	push   $0x801084c9
801044a3:	e8 f8 c2 ff ff       	call   801007a0 <cprintf>
    if(p->state == SLEEPING){
801044a8:	83 c4 10             	add    $0x10,%esp
801044ab:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801044af:	75 a7                	jne    80104458 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044b1:	83 ec 08             	sub    $0x8,%esp
801044b4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801044b7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801044ba:	50                   	push   %eax
801044bb:	8b 43 b0             	mov    -0x50(%ebx),%eax
801044be:	8b 40 0c             	mov    0xc(%eax),%eax
801044c1:	83 c0 08             	add    $0x8,%eax
801044c4:	50                   	push   %eax
801044c5:	e8 d6 03 00 00       	call   801048a0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801044ca:	83 c4 10             	add    $0x10,%esp
801044cd:	8d 76 00             	lea    0x0(%esi),%esi
801044d0:	8b 17                	mov    (%edi),%edx
801044d2:	85 d2                	test   %edx,%edx
801044d4:	74 82                	je     80104458 <procdump+0x18>
        cprintf(" %p", pc[i]);
801044d6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801044d9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801044dc:	52                   	push   %edx
801044dd:	68 e1 81 10 80       	push   $0x801081e1
801044e2:	e8 b9 c2 ff ff       	call   801007a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044e7:	83 c4 10             	add    $0x10,%esp
801044ea:	39 f7                	cmp    %esi,%edi
801044ec:	75 e2                	jne    801044d0 <procdump+0x90>
801044ee:	e9 65 ff ff ff       	jmp    80104458 <procdump+0x18>
801044f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044f7:	90                   	nop
  }
}
801044f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044fb:	5b                   	pop    %ebx
801044fc:	5e                   	pop    %esi
801044fd:	5f                   	pop    %edi
801044fe:	5d                   	pop    %ebp
801044ff:	c3                   	ret

80104500 <get_victim_process>:
struct proc * get_victim_process(void){
80104500:	55                   	push   %ebp
  struct proc * p;
  uint max_rss = 0;
80104501:	31 c9                	xor    %ecx,%ecx
  struct proc * v = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104503:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
struct proc * get_victim_process(void){
80104508:	89 e5                	mov    %esp,%ebp
8010450a:	53                   	push   %ebx
  struct proc * v = 0;
8010450b:	31 db                	xor    %ebx,%ebx
8010450d:	eb 0f                	jmp    8010451e <get_victim_process+0x1e>
8010450f:	90                   	nop
    // if(p->state == UNUSED)
    //   continue;
    if(p->rss > max_rss){
      max_rss = p->rss;
      v = p;
    } else if (p->rss == max_rss){
80104510:	39 ca                	cmp    %ecx,%edx
80104512:	74 2c                	je     80104540 <get_victim_process+0x40>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104514:	83 e8 80             	sub    $0xffffff80,%eax
80104517:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
8010451c:	74 15                	je     80104533 <get_victim_process+0x33>
    if(p->rss > max_rss){
8010451e:	8b 50 04             	mov    0x4(%eax),%edx
80104521:	39 d1                	cmp    %edx,%ecx
80104523:	73 eb                	jae    80104510 <get_victim_process+0x10>
      v = p;
80104525:	89 c3                	mov    %eax,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104527:	83 e8 80             	sub    $0xffffff80,%eax
      max_rss = p->rss;
8010452a:	89 d1                	mov    %edx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010452c:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104531:	75 eb                	jne    8010451e <get_victim_process+0x1e>
          v = p;
        }
      }
    }
    return v;
}
80104533:	89 d8                	mov    %ebx,%eax
80104535:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104538:	c9                   	leave
80104539:	c3                   	ret
8010453a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(v == 0){
80104540:	85 db                	test   %ebx,%ebx
80104542:	74 0c                	je     80104550 <get_victim_process+0x50>
          v = p;
80104544:	8b 53 14             	mov    0x14(%ebx),%edx
80104547:	39 50 14             	cmp    %edx,0x14(%eax)
8010454a:	0f 4c d8             	cmovl  %eax,%ebx
8010454d:	eb c5                	jmp    80104514 <get_victim_process+0x14>
8010454f:	90                   	nop
          v = p;
80104550:	89 c3                	mov    %eax,%ebx
80104552:	eb c0                	jmp    80104514 <get_victim_process+0x14>
80104554:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010455b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010455f:	90                   	nop

80104560 <get_victim_page>:
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
pte_t* get_victim_page(struct proc * v){
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	56                   	push   %esi
80104564:	8b 45 08             	mov    0x8(%ebp),%eax
80104567:	53                   	push   %ebx
  //      pte = &pgtable[j];
  //      return pte;
  //    }
  //  }
  //}
        for(int i = 0 ; i < v->sz; i+= PGSIZE){
80104568:	8b 08                	mov    (%eax),%ecx
  pde_t* pgdir = v->pgdir;
8010456a:	8b 58 08             	mov    0x8(%eax),%ebx
        for(int i = 0 ; i < v->sz; i+= PGSIZE){
8010456d:	85 c9                	test   %ecx,%ecx
8010456f:	74 43                	je     801045b4 <get_victim_page+0x54>
80104571:	31 c0                	xor    %eax,%eax
80104573:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104577:	90                   	nop
  pde = &pgdir[PDX(va)];
80104578:	89 c2                	mov    %eax,%edx
8010457a:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
8010457d:	8b 14 93             	mov    (%ebx,%edx,4),%edx
80104580:	f6 c2 01             	test   $0x1,%dl
80104583:	0f 84 ae 01 00 00    	je     80104737 <get_victim_page.cold>
  return &pgtab[PTX(va)];
80104589:	89 c6                	mov    %eax,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010458b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80104591:	c1 ee 0a             	shr    $0xa,%esi
80104594:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010459a:	8d b4 32 00 00 00 80 	lea    -0x80000000(%edx,%esi,1),%esi
                pte = walkpgdir(pgdir, (void * ) i , 0);
                if((*pte & PTE_P) && (*pte & PTE_U) && !(*pte & PTE_A)){
801045a1:	8b 16                	mov    (%esi),%edx
801045a3:	83 e2 25             	and    $0x25,%edx
801045a6:	83 fa 05             	cmp    $0x5,%edx
801045a9:	74 0b                	je     801045b6 <get_victim_page+0x56>
        for(int i = 0 ; i < v->sz; i+= PGSIZE){
801045ab:	05 00 10 00 00       	add    $0x1000,%eax
801045b0:	39 c8                	cmp    %ecx,%eax
801045b2:	72 c4                	jb     80104578 <get_victim_page+0x18>
                        return pte;
                }
        }
  return 0;
801045b4:	31 f6                	xor    %esi,%esi
}
801045b6:	89 f0                	mov    %esi,%eax
801045b8:	5b                   	pop    %ebx
801045b9:	5e                   	pop    %esi
801045ba:	5d                   	pop    %ebp
801045bb:	c3                   	ret
801045bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045c0 <flush_table>:

void flush_table(struct proc * p){
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	57                   	push   %edi
801045c4:	56                   	push   %esi
801045c5:	8b 75 08             	mov    0x8(%ebp),%esi
801045c8:	53                   	push   %ebx
  //      ctr = (ctr + 1) % 10;
  //    }
  //  }
  //}
        pte_t * pte;
        for(int i = 0 ; i < p->sz; i+= PGSIZE){
801045c9:	8b 06                	mov    (%esi),%eax
  pde_t * pgdir = p->pgdir;
801045cb:	8b 7e 08             	mov    0x8(%esi),%edi
        for(int i = 0 ; i < p->sz; i+= PGSIZE){
801045ce:	85 c0                	test   %eax,%eax
801045d0:	0f 84 7c 00 00 00    	je     80104652 <flush_table+0x92>
801045d6:	31 c9                	xor    %ecx,%ecx
  int ctr = 0;
801045d8:	31 d2                	xor    %edx,%edx
801045da:	eb 11                	jmp    801045ed <flush_table+0x2d>
801045dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        for(int i = 0 ; i < p->sz; i+= PGSIZE){
801045e0:	8b 45 08             	mov    0x8(%ebp),%eax
801045e3:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801045e9:	3b 08                	cmp    (%eax),%ecx
801045eb:	73 65                	jae    80104652 <flush_table+0x92>
  pde = &pgdir[PDX(va)];
801045ed:	89 c8                	mov    %ecx,%eax
801045ef:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801045f2:	8b 04 87             	mov    (%edi,%eax,4),%eax
801045f5:	a8 01                	test   $0x1,%al
801045f7:	0f 84 41 01 00 00    	je     8010473e <flush_table.cold>
  return &pgtab[PTX(va)];
801045fd:	89 cb                	mov    %ecx,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801045ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80104604:	c1 eb 0a             	shr    $0xa,%ebx
80104607:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010460d:	8d 9c 18 00 00 00 80 	lea    -0x80000000(%eax,%ebx,1),%ebx
                        pte = walkpgdir(pgdir , (void *) i , 0);
                        if((*pte & PTE_P) && (*pte & PTE_U) && (*pte & PTE_A)){
80104614:	8b 03                	mov    (%ebx),%eax
80104616:	89 c6                	mov    %eax,%esi
80104618:	f7 d6                	not    %esi
8010461a:	83 e6 25             	and    $0x25,%esi
8010461d:	75 c1                	jne    801045e0 <flush_table+0x20>
                                if(ctr == 0){
8010461f:	85 d2                	test   %edx,%edx
80104621:	75 05                	jne    80104628 <flush_table+0x68>
                                        *pte &= ~PTE_A;
80104623:	83 e0 df             	and    $0xffffffdf,%eax
80104626:	89 03                	mov    %eax,(%ebx)
                                }
                                ctr = (ctr + 1) % 10;
80104628:	8d 5a 01             	lea    0x1(%edx),%ebx
8010462b:	b8 67 66 66 66       	mov    $0x66666667,%eax
        for(int i = 0 ; i < p->sz; i+= PGSIZE){
80104630:	81 c1 00 10 00 00    	add    $0x1000,%ecx
                                ctr = (ctr + 1) % 10;
80104636:	f7 eb                	imul   %ebx
80104638:	89 d8                	mov    %ebx,%eax
8010463a:	c1 f8 1f             	sar    $0x1f,%eax
8010463d:	c1 fa 02             	sar    $0x2,%edx
80104640:	29 c2                	sub    %eax,%edx
80104642:	8d 04 92             	lea    (%edx,%edx,4),%eax
80104645:	89 da                	mov    %ebx,%edx
80104647:	01 c0                	add    %eax,%eax
80104649:	29 c2                	sub    %eax,%edx
        for(int i = 0 ; i < p->sz; i+= PGSIZE){
8010464b:	8b 45 08             	mov    0x8(%ebp),%eax
8010464e:	3b 08                	cmp    (%eax),%ecx
80104650:	72 9b                	jb     801045ed <flush_table+0x2d>
                        }
                }

}
80104652:	5b                   	pop    %ebx
80104653:	5e                   	pop    %esi
80104654:	5f                   	pop    %edi
80104655:	5d                   	pop    %ebp
80104656:	c3                   	ret
80104657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010465e:	66 90                	xchg   %ax,%ax

80104660 <final_page>:

pte_t* final_page(){
80104660:	55                   	push   %ebp
  uint max_rss = 0;
80104661:	31 c9                	xor    %ecx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104663:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
pte_t* final_page(){
80104668:	89 e5                	mov    %esp,%ebp
8010466a:	53                   	push   %ebx
  struct proc * v = 0;
8010466b:	31 db                	xor    %ebx,%ebx
pte_t* final_page(){
8010466d:	83 ec 14             	sub    $0x14,%esp
80104670:	eb 12                	jmp    80104684 <final_page+0x24>
80104672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if (p->rss == max_rss){
80104678:	74 3e                	je     801046b8 <final_page+0x58>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010467a:	83 e8 80             	sub    $0xffffff80,%eax
8010467d:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104682:	74 15                	je     80104699 <final_page+0x39>
    if(p->rss > max_rss){
80104684:	8b 50 04             	mov    0x4(%eax),%edx
80104687:	39 d1                	cmp    %edx,%ecx
80104689:	73 ed                	jae    80104678 <final_page+0x18>
      v = p;
8010468b:	89 c3                	mov    %eax,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010468d:	83 e8 80             	sub    $0xffffff80,%eax
      max_rss = p->rss;
80104690:	89 d1                	mov    %edx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104692:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104697:	75 eb                	jne    80104684 <final_page+0x24>
  struct proc * v = get_victim_process();
  // cprintf("victim process is %d\n", (int) v->pid);
  v->rss -= PGSIZE;
  pte_t* pte = get_victim_page(v);
80104699:	83 ec 0c             	sub    $0xc,%esp
  v->rss -= PGSIZE;
8010469c:	81 6b 04 00 10 00 00 	subl   $0x1000,0x4(%ebx)
  pte_t* pte = get_victim_page(v);
801046a3:	53                   	push   %ebx
801046a4:	e8 b7 fe ff ff       	call   80104560 <get_victim_page>
801046a9:	83 c4 10             	add    $0x10,%esp
  if(pte == 0){
801046ac:	85 c0                	test   %eax,%eax
801046ae:	74 24                	je     801046d4 <final_page+0x74>
    if(pte == 0){
      cprintf("Flusing again\n");
    }
  }
  return pte;
}
801046b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046b3:	c9                   	leave
801046b4:	c3                   	ret
801046b5:	8d 76 00             	lea    0x0(%esi),%esi
        if(v == 0){
801046b8:	85 db                	test   %ebx,%ebx
801046ba:	74 14                	je     801046d0 <final_page+0x70>
      v = p;
801046bc:	8b 53 14             	mov    0x14(%ebx),%edx
801046bf:	39 50 14             	cmp    %edx,0x14(%eax)
801046c2:	0f 4c d8             	cmovl  %eax,%ebx
801046c5:	eb b3                	jmp    8010467a <final_page+0x1a>
801046c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ce:	66 90                	xchg   %ax,%ax
801046d0:	89 c3                	mov    %eax,%ebx
801046d2:	eb a6                	jmp    8010467a <final_page+0x1a>
    flush_table(v);
801046d4:	83 ec 0c             	sub    $0xc,%esp
801046d7:	53                   	push   %ebx
801046d8:	e8 e3 fe ff ff       	call   801045c0 <flush_table>
    pte = get_victim_page(v);
801046dd:	89 1c 24             	mov    %ebx,(%esp)
801046e0:	e8 7b fe ff ff       	call   80104560 <get_victim_page>
801046e5:	83 c4 10             	add    $0x10,%esp
    if(pte == 0){
801046e8:	85 c0                	test   %eax,%eax
801046ea:	75 c4                	jne    801046b0 <final_page+0x50>
      cprintf("Flusing again\n");
801046ec:	83 ec 0c             	sub    $0xc,%esp
801046ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
801046f2:	68 d2 84 10 80       	push   $0x801084d2
801046f7:	e8 a4 c0 ff ff       	call   801007a0 <cprintf>
801046fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ff:	83 c4 10             	add    $0x10,%esp
80104702:	eb ac                	jmp    801046b0 <final_page+0x50>
80104704:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010470b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010470f:	90                   	nop

80104710 <update_rss>:
void update_rss(int pid, int increment){
80104710:	55                   	push   %ebp
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104711:	b8 b4 38 11 80       	mov    $0x801138b4,%eax
void update_rss(int pid, int increment){
80104716:	89 e5                	mov    %esp,%ebp
80104718:	8b 55 08             	mov    0x8(%ebp),%edx
8010471b:	eb 0d                	jmp    8010472a <update_rss+0x1a>
8010471d:	8d 76 00             	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104720:	83 e8 80             	sub    $0xffffff80,%eax
80104723:	3d b4 58 11 80       	cmp    $0x801158b4,%eax
80104728:	74 0b                	je     80104735 <update_rss+0x25>
  {
    if (p->pid == pid)
8010472a:	39 50 14             	cmp    %edx,0x14(%eax)
8010472d:	75 f1                	jne    80104720 <update_rss+0x10>
    {
      p->rss += increment;
8010472f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104732:	01 50 04             	add    %edx,0x4(%eax)
      return;
    }
  }
80104735:	5d                   	pop    %ebp
80104736:	c3                   	ret

80104737 <get_victim_page.cold>:
                if((*pte & PTE_P) && (*pte & PTE_U) && !(*pte & PTE_A)){
80104737:	a1 00 00 00 00       	mov    0x0,%eax
8010473c:	0f 0b                	ud2

8010473e <flush_table.cold>:
                        if((*pte & PTE_P) && (*pte & PTE_U) && (*pte & PTE_A)){
8010473e:	a1 00 00 00 00       	mov    0x0,%eax
80104743:	0f 0b                	ud2
80104745:	66 90                	xchg   %ax,%ax
80104747:	66 90                	xchg   %ax,%ax
80104749:	66 90                	xchg   %ax,%ax
8010474b:	66 90                	xchg   %ax,%ax
8010474d:	66 90                	xchg   %ax,%ax
8010474f:	90                   	nop

80104750 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	53                   	push   %ebx
80104754:	83 ec 0c             	sub    $0xc,%esp
80104757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010475a:	68 0b 85 10 80       	push   $0x8010850b
8010475f:	8d 43 04             	lea    0x4(%ebx),%eax
80104762:	50                   	push   %eax
80104763:	e8 18 01 00 00       	call   80104880 <initlock>
  lk->name = name;
80104768:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010476b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104771:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104774:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010477b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010477e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104781:	c9                   	leave
80104782:	c3                   	ret
80104783:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010478a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104790 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
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
8010479f:	e8 cc 02 00 00       	call   80104a70 <acquire>
  while (lk->locked) {
801047a4:	8b 13                	mov    (%ebx),%edx
801047a6:	83 c4 10             	add    $0x10,%esp
801047a9:	85 d2                	test   %edx,%edx
801047ab:	74 16                	je     801047c3 <acquiresleep+0x33>
801047ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801047b0:	83 ec 08             	sub    $0x8,%esp
801047b3:	56                   	push   %esi
801047b4:	53                   	push   %ebx
801047b5:	e8 e6 fa ff ff       	call   801042a0 <sleep>
  while (lk->locked) {
801047ba:	8b 03                	mov    (%ebx),%eax
801047bc:	83 c4 10             	add    $0x10,%esp
801047bf:	85 c0                	test   %eax,%eax
801047c1:	75 ed                	jne    801047b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801047c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801047c9:	e8 82 f3 ff ff       	call   80103b50 <myproc>
801047ce:	8b 40 14             	mov    0x14(%eax),%eax
801047d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801047d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801047d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047da:	5b                   	pop    %ebx
801047db:	5e                   	pop    %esi
801047dc:	5d                   	pop    %ebp
  release(&lk->lk);
801047dd:	e9 2e 02 00 00       	jmp    80104a10 <release>
801047e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	56                   	push   %esi
801047f4:	53                   	push   %ebx
801047f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047f8:	8d 73 04             	lea    0x4(%ebx),%esi
801047fb:	83 ec 0c             	sub    $0xc,%esp
801047fe:	56                   	push   %esi
801047ff:	e8 6c 02 00 00       	call   80104a70 <acquire>
  lk->locked = 0;
80104804:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010480a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104811:	89 1c 24             	mov    %ebx,(%esp)
80104814:	e8 47 fb ff ff       	call   80104360 <wakeup>
  release(&lk->lk);
80104819:	89 75 08             	mov    %esi,0x8(%ebp)
8010481c:	83 c4 10             	add    $0x10,%esp
}
8010481f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104822:	5b                   	pop    %ebx
80104823:	5e                   	pop    %esi
80104824:	5d                   	pop    %ebp
  release(&lk->lk);
80104825:	e9 e6 01 00 00       	jmp    80104a10 <release>
8010482a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104830 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	57                   	push   %edi
80104834:	31 ff                	xor    %edi,%edi
80104836:	56                   	push   %esi
80104837:	53                   	push   %ebx
80104838:	83 ec 18             	sub    $0x18,%esp
8010483b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010483e:	8d 73 04             	lea    0x4(%ebx),%esi
80104841:	56                   	push   %esi
80104842:	e8 29 02 00 00       	call   80104a70 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104847:	8b 03                	mov    (%ebx),%eax
80104849:	83 c4 10             	add    $0x10,%esp
8010484c:	85 c0                	test   %eax,%eax
8010484e:	75 18                	jne    80104868 <holdingsleep+0x38>
  release(&lk->lk);
80104850:	83 ec 0c             	sub    $0xc,%esp
80104853:	56                   	push   %esi
80104854:	e8 b7 01 00 00       	call   80104a10 <release>
  return r;
}
80104859:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010485c:	89 f8                	mov    %edi,%eax
8010485e:	5b                   	pop    %ebx
8010485f:	5e                   	pop    %esi
80104860:	5f                   	pop    %edi
80104861:	5d                   	pop    %ebp
80104862:	c3                   	ret
80104863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104867:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104868:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010486b:	e8 e0 f2 ff ff       	call   80103b50 <myproc>
80104870:	39 58 14             	cmp    %ebx,0x14(%eax)
80104873:	0f 94 c0             	sete   %al
80104876:	0f b6 c0             	movzbl %al,%eax
80104879:	89 c7                	mov    %eax,%edi
8010487b:	eb d3                	jmp    80104850 <holdingsleep+0x20>
8010487d:	66 90                	xchg   %ax,%ax
8010487f:	90                   	nop

80104880 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104886:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104889:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010488f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104892:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104899:	5d                   	pop    %ebp
8010489a:	c3                   	ret
8010489b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010489f:	90                   	nop

801048a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	53                   	push   %ebx
801048a4:	8b 45 08             	mov    0x8(%ebp),%eax
801048a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801048aa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048ad:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
801048b2:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
801048b7:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048bc:	76 10                	jbe    801048ce <getcallerpcs+0x2e>
801048be:	eb 28                	jmp    801048e8 <getcallerpcs+0x48>
801048c0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801048c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048cc:	77 1a                	ja     801048e8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
801048ce:	8b 5a 04             	mov    0x4(%edx),%ebx
801048d1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801048d4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801048d7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801048d9:	83 f8 0a             	cmp    $0xa,%eax
801048dc:	75 e2                	jne    801048c0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801048de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048e1:	c9                   	leave
801048e2:	c3                   	ret
801048e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048e7:	90                   	nop
801048e8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801048eb:	83 c1 28             	add    $0x28,%ecx
801048ee:	89 ca                	mov    %ecx,%edx
801048f0:	29 c2                	sub    %eax,%edx
801048f2:	83 e2 04             	and    $0x4,%edx
801048f5:	74 11                	je     80104908 <getcallerpcs+0x68>
    pcs[i] = 0;
801048f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801048fd:	83 c0 04             	add    $0x4,%eax
80104900:	39 c1                	cmp    %eax,%ecx
80104902:	74 da                	je     801048de <getcallerpcs+0x3e>
80104904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104908:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010490e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104911:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104918:	39 c1                	cmp    %eax,%ecx
8010491a:	75 ec                	jne    80104908 <getcallerpcs+0x68>
8010491c:	eb c0                	jmp    801048de <getcallerpcs+0x3e>
8010491e:	66 90                	xchg   %ax,%ax

80104920 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	53                   	push   %ebx
80104924:	83 ec 04             	sub    $0x4,%esp
80104927:	9c                   	pushf
80104928:	5b                   	pop    %ebx
  asm volatile("cli");
80104929:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010492a:	e8 b1 f1 ff ff       	call   80103ae0 <mycpu>
8010492f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104935:	85 c0                	test   %eax,%eax
80104937:	74 17                	je     80104950 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104939:	e8 a2 f1 ff ff       	call   80103ae0 <mycpu>
8010493e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104945:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104948:	c9                   	leave
80104949:	c3                   	ret
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104950:	e8 8b f1 ff ff       	call   80103ae0 <mycpu>
80104955:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010495b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104961:	eb d6                	jmp    80104939 <pushcli+0x19>
80104963:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104970 <popcli>:

void
popcli(void)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104976:	9c                   	pushf
80104977:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104978:	f6 c4 02             	test   $0x2,%ah
8010497b:	75 35                	jne    801049b2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010497d:	e8 5e f1 ff ff       	call   80103ae0 <mycpu>
80104982:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104989:	78 34                	js     801049bf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010498b:	e8 50 f1 ff ff       	call   80103ae0 <mycpu>
80104990:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104996:	85 d2                	test   %edx,%edx
80104998:	74 06                	je     801049a0 <popcli+0x30>
    sti();
}
8010499a:	c9                   	leave
8010499b:	c3                   	ret
8010499c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049a0:	e8 3b f1 ff ff       	call   80103ae0 <mycpu>
801049a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801049ab:	85 c0                	test   %eax,%eax
801049ad:	74 eb                	je     8010499a <popcli+0x2a>
  asm volatile("sti");
801049af:	fb                   	sti
}
801049b0:	c9                   	leave
801049b1:	c3                   	ret
    panic("popcli - interruptible");
801049b2:	83 ec 0c             	sub    $0xc,%esp
801049b5:	68 16 85 10 80       	push   $0x80108516
801049ba:	e8 b1 ba ff ff       	call   80100470 <panic>
    panic("popcli");
801049bf:	83 ec 0c             	sub    $0xc,%esp
801049c2:	68 2d 85 10 80       	push   $0x8010852d
801049c7:	e8 a4 ba ff ff       	call   80100470 <panic>
801049cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049d0 <holding>:
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	53                   	push   %ebx
801049d5:	8b 75 08             	mov    0x8(%ebp),%esi
801049d8:	31 db                	xor    %ebx,%ebx
  pushcli();
801049da:	e8 41 ff ff ff       	call   80104920 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801049df:	8b 06                	mov    (%esi),%eax
801049e1:	85 c0                	test   %eax,%eax
801049e3:	75 0b                	jne    801049f0 <holding+0x20>
  popcli();
801049e5:	e8 86 ff ff ff       	call   80104970 <popcli>
}
801049ea:	89 d8                	mov    %ebx,%eax
801049ec:	5b                   	pop    %ebx
801049ed:	5e                   	pop    %esi
801049ee:	5d                   	pop    %ebp
801049ef:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
801049f0:	8b 5e 08             	mov    0x8(%esi),%ebx
801049f3:	e8 e8 f0 ff ff       	call   80103ae0 <mycpu>
801049f8:	39 c3                	cmp    %eax,%ebx
801049fa:	0f 94 c3             	sete   %bl
  popcli();
801049fd:	e8 6e ff ff ff       	call   80104970 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104a02:	0f b6 db             	movzbl %bl,%ebx
}
80104a05:	89 d8                	mov    %ebx,%eax
80104a07:	5b                   	pop    %ebx
80104a08:	5e                   	pop    %esi
80104a09:	5d                   	pop    %ebp
80104a0a:	c3                   	ret
80104a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a0f:	90                   	nop

80104a10 <release>:
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	56                   	push   %esi
80104a14:	53                   	push   %ebx
80104a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104a18:	e8 03 ff ff ff       	call   80104920 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a1d:	8b 03                	mov    (%ebx),%eax
80104a1f:	85 c0                	test   %eax,%eax
80104a21:	75 15                	jne    80104a38 <release+0x28>
  popcli();
80104a23:	e8 48 ff ff ff       	call   80104970 <popcli>
    panic("release");
80104a28:	83 ec 0c             	sub    $0xc,%esp
80104a2b:	68 34 85 10 80       	push   $0x80108534
80104a30:	e8 3b ba ff ff       	call   80100470 <panic>
80104a35:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104a38:	8b 73 08             	mov    0x8(%ebx),%esi
80104a3b:	e8 a0 f0 ff ff       	call   80103ae0 <mycpu>
80104a40:	39 c6                	cmp    %eax,%esi
80104a42:	75 df                	jne    80104a23 <release+0x13>
  popcli();
80104a44:	e8 27 ff ff ff       	call   80104970 <popcli>
  lk->pcs[0] = 0;
80104a49:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a50:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104a57:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a5c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a65:	5b                   	pop    %ebx
80104a66:	5e                   	pop    %esi
80104a67:	5d                   	pop    %ebp
  popcli();
80104a68:	e9 03 ff ff ff       	jmp    80104970 <popcli>
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi

80104a70 <acquire>:
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	53                   	push   %ebx
80104a74:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104a77:	e8 a4 fe ff ff       	call   80104920 <pushcli>
  if(holding(lk))
80104a7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104a7f:	e8 9c fe ff ff       	call   80104920 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a84:	8b 03                	mov    (%ebx),%eax
80104a86:	85 c0                	test   %eax,%eax
80104a88:	0f 85 b2 00 00 00    	jne    80104b40 <acquire+0xd0>
  popcli();
80104a8e:	e8 dd fe ff ff       	call   80104970 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104a93:	b9 01 00 00 00       	mov    $0x1,%ecx
80104a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9f:	90                   	nop
  while(xchg(&lk->locked, 1) != 0)
80104aa0:	8b 55 08             	mov    0x8(%ebp),%edx
80104aa3:	89 c8                	mov    %ecx,%eax
80104aa5:	f0 87 02             	lock xchg %eax,(%edx)
80104aa8:	85 c0                	test   %eax,%eax
80104aaa:	75 f4                	jne    80104aa0 <acquire+0x30>
  __sync_synchronize();
80104aac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104ab1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ab4:	e8 27 f0 ff ff       	call   80103ae0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104ab9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
80104abc:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
80104abe:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ac1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104ac7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80104acc:	77 32                	ja     80104b00 <acquire+0x90>
  ebp = (uint*)v - 2;
80104ace:	89 e8                	mov    %ebp,%eax
80104ad0:	eb 14                	jmp    80104ae6 <acquire+0x76>
80104ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ad8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104ade:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104ae4:	77 1a                	ja     80104b00 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104ae6:	8b 58 04             	mov    0x4(%eax),%ebx
80104ae9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104aed:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104af0:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104af2:	83 fa 0a             	cmp    $0xa,%edx
80104af5:	75 e1                	jne    80104ad8 <acquire+0x68>
}
80104af7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104afa:	c9                   	leave
80104afb:	c3                   	ret
80104afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b00:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104b04:	83 c1 34             	add    $0x34,%ecx
80104b07:	89 ca                	mov    %ecx,%edx
80104b09:	29 c2                	sub    %eax,%edx
80104b0b:	83 e2 04             	and    $0x4,%edx
80104b0e:	74 10                	je     80104b20 <acquire+0xb0>
    pcs[i] = 0;
80104b10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b16:	83 c0 04             	add    $0x4,%eax
80104b19:	39 c1                	cmp    %eax,%ecx
80104b1b:	74 da                	je     80104af7 <acquire+0x87>
80104b1d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104b20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b26:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104b29:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104b30:	39 c1                	cmp    %eax,%ecx
80104b32:	75 ec                	jne    80104b20 <acquire+0xb0>
80104b34:	eb c1                	jmp    80104af7 <acquire+0x87>
80104b36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b3d:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104b40:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104b43:	e8 98 ef ff ff       	call   80103ae0 <mycpu>
80104b48:	39 c3                	cmp    %eax,%ebx
80104b4a:	0f 85 3e ff ff ff    	jne    80104a8e <acquire+0x1e>
  popcli();
80104b50:	e8 1b fe ff ff       	call   80104970 <popcli>
    panic("acquire");
80104b55:	83 ec 0c             	sub    $0xc,%esp
80104b58:	68 3c 85 10 80       	push   $0x8010853c
80104b5d:	e8 0e b9 ff ff       	call   80100470 <panic>
80104b62:	66 90                	xchg   %ax,%ax
80104b64:	66 90                	xchg   %ax,%ax
80104b66:	66 90                	xchg   %ax,%ax
80104b68:	66 90                	xchg   %ax,%ax
80104b6a:	66 90                	xchg   %ax,%ax
80104b6c:	66 90                	xchg   %ax,%ax
80104b6e:	66 90                	xchg   %ax,%ax

80104b70 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	57                   	push   %edi
80104b74:	8b 55 08             	mov    0x8(%ebp),%edx
80104b77:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104b7a:	89 d0                	mov    %edx,%eax
80104b7c:	09 c8                	or     %ecx,%eax
80104b7e:	a8 03                	test   $0x3,%al
80104b80:	75 1e                	jne    80104ba0 <memset+0x30>
    c &= 0xFF;
80104b82:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104b86:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104b89:	89 d7                	mov    %edx,%edi
80104b8b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104b91:	fc                   	cld
80104b92:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104b94:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104b97:	89 d0                	mov    %edx,%eax
80104b99:	c9                   	leave
80104b9a:	c3                   	ret
80104b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b9f:	90                   	nop
  asm volatile("cld; rep stosb" :
80104ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ba3:	89 d7                	mov    %edx,%edi
80104ba5:	fc                   	cld
80104ba6:	f3 aa                	rep stos %al,%es:(%edi)
80104ba8:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104bab:	89 d0                	mov    %edx,%eax
80104bad:	c9                   	leave
80104bae:	c3                   	ret
80104baf:	90                   	nop

80104bb0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	56                   	push   %esi
80104bb4:	8b 75 10             	mov    0x10(%ebp),%esi
80104bb7:	8b 45 08             	mov    0x8(%ebp),%eax
80104bba:	53                   	push   %ebx
80104bbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104bbe:	85 f6                	test   %esi,%esi
80104bc0:	74 2e                	je     80104bf0 <memcmp+0x40>
80104bc2:	01 c6                	add    %eax,%esi
80104bc4:	eb 14                	jmp    80104bda <memcmp+0x2a>
80104bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bcd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104bd0:	83 c0 01             	add    $0x1,%eax
80104bd3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104bd6:	39 f0                	cmp    %esi,%eax
80104bd8:	74 16                	je     80104bf0 <memcmp+0x40>
    if(*s1 != *s2)
80104bda:	0f b6 08             	movzbl (%eax),%ecx
80104bdd:	0f b6 1a             	movzbl (%edx),%ebx
80104be0:	38 d9                	cmp    %bl,%cl
80104be2:	74 ec                	je     80104bd0 <memcmp+0x20>
      return *s1 - *s2;
80104be4:	0f b6 c1             	movzbl %cl,%eax
80104be7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104be9:	5b                   	pop    %ebx
80104bea:	5e                   	pop    %esi
80104beb:	5d                   	pop    %ebp
80104bec:	c3                   	ret
80104bed:	8d 76 00             	lea    0x0(%esi),%esi
80104bf0:	5b                   	pop    %ebx
  return 0;
80104bf1:	31 c0                	xor    %eax,%eax
}
80104bf3:	5e                   	pop    %esi
80104bf4:	5d                   	pop    %ebp
80104bf5:	c3                   	ret
80104bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bfd:	8d 76 00             	lea    0x0(%esi),%esi

80104c00 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	57                   	push   %edi
80104c04:	8b 55 08             	mov    0x8(%ebp),%edx
80104c07:	8b 45 10             	mov    0x10(%ebp),%eax
80104c0a:	56                   	push   %esi
80104c0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104c0e:	39 d6                	cmp    %edx,%esi
80104c10:	73 26                	jae    80104c38 <memmove+0x38>
80104c12:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104c15:	39 ca                	cmp    %ecx,%edx
80104c17:	73 1f                	jae    80104c38 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104c19:	85 c0                	test   %eax,%eax
80104c1b:	74 0f                	je     80104c2c <memmove+0x2c>
80104c1d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104c20:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104c24:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104c27:	83 e8 01             	sub    $0x1,%eax
80104c2a:	73 f4                	jae    80104c20 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104c2c:	5e                   	pop    %esi
80104c2d:	89 d0                	mov    %edx,%eax
80104c2f:	5f                   	pop    %edi
80104c30:	5d                   	pop    %ebp
80104c31:	c3                   	ret
80104c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104c38:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104c3b:	89 d7                	mov    %edx,%edi
80104c3d:	85 c0                	test   %eax,%eax
80104c3f:	74 eb                	je     80104c2c <memmove+0x2c>
80104c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104c48:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104c49:	39 ce                	cmp    %ecx,%esi
80104c4b:	75 fb                	jne    80104c48 <memmove+0x48>
}
80104c4d:	5e                   	pop    %esi
80104c4e:	89 d0                	mov    %edx,%eax
80104c50:	5f                   	pop    %edi
80104c51:	5d                   	pop    %ebp
80104c52:	c3                   	ret
80104c53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c60 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104c60:	eb 9e                	jmp    80104c00 <memmove>
80104c62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c70 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	53                   	push   %ebx
80104c74:	8b 55 10             	mov    0x10(%ebp),%edx
80104c77:	8b 45 08             	mov    0x8(%ebp),%eax
80104c7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
80104c7d:	85 d2                	test   %edx,%edx
80104c7f:	75 16                	jne    80104c97 <strncmp+0x27>
80104c81:	eb 2d                	jmp    80104cb0 <strncmp+0x40>
80104c83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c87:	90                   	nop
80104c88:	3a 19                	cmp    (%ecx),%bl
80104c8a:	75 12                	jne    80104c9e <strncmp+0x2e>
    n--, p++, q++;
80104c8c:	83 c0 01             	add    $0x1,%eax
80104c8f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104c92:	83 ea 01             	sub    $0x1,%edx
80104c95:	74 19                	je     80104cb0 <strncmp+0x40>
80104c97:	0f b6 18             	movzbl (%eax),%ebx
80104c9a:	84 db                	test   %bl,%bl
80104c9c:	75 ea                	jne    80104c88 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104c9e:	0f b6 00             	movzbl (%eax),%eax
80104ca1:	0f b6 11             	movzbl (%ecx),%edx
}
80104ca4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104ca8:	29 d0                	sub    %edx,%eax
}
80104caa:	c3                   	ret
80104cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104caf:	90                   	nop
80104cb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104cb3:	31 c0                	xor    %eax,%eax
}
80104cb5:	c9                   	leave
80104cb6:	c3                   	ret
80104cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	56                   	push   %esi
80104cc5:	8b 75 08             	mov    0x8(%ebp),%esi
80104cc8:	53                   	push   %ebx
80104cc9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104ccc:	89 f0                	mov    %esi,%eax
80104cce:	eb 15                	jmp    80104ce5 <strncpy+0x25>
80104cd0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104cd4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104cd7:	83 c0 01             	add    $0x1,%eax
80104cda:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80104cde:	88 48 ff             	mov    %cl,-0x1(%eax)
80104ce1:	84 c9                	test   %cl,%cl
80104ce3:	74 13                	je     80104cf8 <strncpy+0x38>
80104ce5:	89 d3                	mov    %edx,%ebx
80104ce7:	83 ea 01             	sub    $0x1,%edx
80104cea:	85 db                	test   %ebx,%ebx
80104cec:	7f e2                	jg     80104cd0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104cee:	5b                   	pop    %ebx
80104cef:	89 f0                	mov    %esi,%eax
80104cf1:	5e                   	pop    %esi
80104cf2:	5f                   	pop    %edi
80104cf3:	5d                   	pop    %ebp
80104cf4:	c3                   	ret
80104cf5:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104cf8:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104cfb:	83 e9 01             	sub    $0x1,%ecx
80104cfe:	85 d2                	test   %edx,%edx
80104d00:	74 ec                	je     80104cee <strncpy+0x2e>
80104d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104d08:	83 c0 01             	add    $0x1,%eax
80104d0b:	89 ca                	mov    %ecx,%edx
80104d0d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104d11:	29 c2                	sub    %eax,%edx
80104d13:	85 d2                	test   %edx,%edx
80104d15:	7f f1                	jg     80104d08 <strncpy+0x48>
}
80104d17:	5b                   	pop    %ebx
80104d18:	89 f0                	mov    %esi,%eax
80104d1a:	5e                   	pop    %esi
80104d1b:	5f                   	pop    %edi
80104d1c:	5d                   	pop    %ebp
80104d1d:	c3                   	ret
80104d1e:	66 90                	xchg   %ax,%ax

80104d20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	56                   	push   %esi
80104d24:	8b 55 10             	mov    0x10(%ebp),%edx
80104d27:	8b 75 08             	mov    0x8(%ebp),%esi
80104d2a:	53                   	push   %ebx
80104d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104d2e:	85 d2                	test   %edx,%edx
80104d30:	7e 25                	jle    80104d57 <safestrcpy+0x37>
80104d32:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104d36:	89 f2                	mov    %esi,%edx
80104d38:	eb 16                	jmp    80104d50 <safestrcpy+0x30>
80104d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104d40:	0f b6 08             	movzbl (%eax),%ecx
80104d43:	83 c0 01             	add    $0x1,%eax
80104d46:	83 c2 01             	add    $0x1,%edx
80104d49:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d4c:	84 c9                	test   %cl,%cl
80104d4e:	74 04                	je     80104d54 <safestrcpy+0x34>
80104d50:	39 d8                	cmp    %ebx,%eax
80104d52:	75 ec                	jne    80104d40 <safestrcpy+0x20>
    ;
  *s = 0;
80104d54:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104d57:	89 f0                	mov    %esi,%eax
80104d59:	5b                   	pop    %ebx
80104d5a:	5e                   	pop    %esi
80104d5b:	5d                   	pop    %ebp
80104d5c:	c3                   	ret
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi

80104d60 <strlen>:

int
strlen(const char *s)
{
80104d60:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104d61:	31 c0                	xor    %eax,%eax
{
80104d63:	89 e5                	mov    %esp,%ebp
80104d65:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104d68:	80 3a 00             	cmpb   $0x0,(%edx)
80104d6b:	74 0c                	je     80104d79 <strlen+0x19>
80104d6d:	8d 76 00             	lea    0x0(%esi),%esi
80104d70:	83 c0 01             	add    $0x1,%eax
80104d73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104d77:	75 f7                	jne    80104d70 <strlen+0x10>
    ;
  return n;
}
80104d79:	5d                   	pop    %ebp
80104d7a:	c3                   	ret

80104d7b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104d7b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104d7f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104d83:	55                   	push   %ebp
  pushl %ebx
80104d84:	53                   	push   %ebx
  pushl %esi
80104d85:	56                   	push   %esi
  pushl %edi
80104d86:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104d87:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104d89:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104d8b:	5f                   	pop    %edi
  popl %esi
80104d8c:	5e                   	pop    %esi
  popl %ebx
80104d8d:	5b                   	pop    %ebx
  popl %ebp
80104d8e:	5d                   	pop    %ebp
  ret
80104d8f:	c3                   	ret

80104d90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	53                   	push   %ebx
80104d94:	83 ec 04             	sub    $0x4,%esp
80104d97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104d9a:	e8 b1 ed ff ff       	call   80103b50 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d9f:	8b 00                	mov    (%eax),%eax
80104da1:	39 c3                	cmp    %eax,%ebx
80104da3:	73 1b                	jae    80104dc0 <fetchint+0x30>
80104da5:	8d 53 04             	lea    0x4(%ebx),%edx
80104da8:	39 d0                	cmp    %edx,%eax
80104daa:	72 14                	jb     80104dc0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104dac:	8b 45 0c             	mov    0xc(%ebp),%eax
80104daf:	8b 13                	mov    (%ebx),%edx
80104db1:	89 10                	mov    %edx,(%eax)
  return 0;
80104db3:	31 c0                	xor    %eax,%eax
}
80104db5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104db8:	c9                   	leave
80104db9:	c3                   	ret
80104dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dc5:	eb ee                	jmp    80104db5 <fetchint+0x25>
80104dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dce:	66 90                	xchg   %ax,%ax

80104dd0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	53                   	push   %ebx
80104dd4:	83 ec 04             	sub    $0x4,%esp
80104dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104dda:	e8 71 ed ff ff       	call   80103b50 <myproc>

  if(addr >= curproc->sz)
80104ddf:	3b 18                	cmp    (%eax),%ebx
80104de1:	73 2d                	jae    80104e10 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104de3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104de6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104de8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104dea:	39 d3                	cmp    %edx,%ebx
80104dec:	73 22                	jae    80104e10 <fetchstr+0x40>
80104dee:	89 d8                	mov    %ebx,%eax
80104df0:	eb 0d                	jmp    80104dff <fetchstr+0x2f>
80104df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104df8:	83 c0 01             	add    $0x1,%eax
80104dfb:	39 d0                	cmp    %edx,%eax
80104dfd:	73 11                	jae    80104e10 <fetchstr+0x40>
    if(*s == 0)
80104dff:	80 38 00             	cmpb   $0x0,(%eax)
80104e02:	75 f4                	jne    80104df8 <fetchstr+0x28>
      return s - *pp;
80104e04:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104e06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e09:	c9                   	leave
80104e0a:	c3                   	ret
80104e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e0f:	90                   	nop
80104e10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104e13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e18:	c9                   	leave
80104e19:	c3                   	ret
80104e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	56                   	push   %esi
80104e24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e25:	e8 26 ed ff ff       	call   80103b50 <myproc>
80104e2a:	8b 55 08             	mov    0x8(%ebp),%edx
80104e2d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e30:	8b 40 44             	mov    0x44(%eax),%eax
80104e33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104e36:	e8 15 ed ff ff       	call   80103b50 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e3b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e3e:	8b 00                	mov    (%eax),%eax
80104e40:	39 c6                	cmp    %eax,%esi
80104e42:	73 1c                	jae    80104e60 <argint+0x40>
80104e44:	8d 53 08             	lea    0x8(%ebx),%edx
80104e47:	39 d0                	cmp    %edx,%eax
80104e49:	72 15                	jb     80104e60 <argint+0x40>
  *ip = *(int*)(addr);
80104e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e4e:	8b 53 04             	mov    0x4(%ebx),%edx
80104e51:	89 10                	mov    %edx,(%eax)
  return 0;
80104e53:	31 c0                	xor    %eax,%eax
}
80104e55:	5b                   	pop    %ebx
80104e56:	5e                   	pop    %esi
80104e57:	5d                   	pop    %ebp
80104e58:	c3                   	ret
80104e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e65:	eb ee                	jmp    80104e55 <argint+0x35>
80104e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6e:	66 90                	xchg   %ax,%ax

80104e70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	57                   	push   %edi
80104e74:	56                   	push   %esi
80104e75:	53                   	push   %ebx
80104e76:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104e79:	e8 d2 ec ff ff       	call   80103b50 <myproc>
80104e7e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e80:	e8 cb ec ff ff       	call   80103b50 <myproc>
80104e85:	8b 55 08             	mov    0x8(%ebp),%edx
80104e88:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e8b:	8b 40 44             	mov    0x44(%eax),%eax
80104e8e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104e91:	e8 ba ec ff ff       	call   80103b50 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e96:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e99:	8b 00                	mov    (%eax),%eax
80104e9b:	39 c7                	cmp    %eax,%edi
80104e9d:	73 31                	jae    80104ed0 <argptr+0x60>
80104e9f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104ea2:	39 c8                	cmp    %ecx,%eax
80104ea4:	72 2a                	jb     80104ed0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ea6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104ea9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104eac:	85 d2                	test   %edx,%edx
80104eae:	78 20                	js     80104ed0 <argptr+0x60>
80104eb0:	8b 16                	mov    (%esi),%edx
80104eb2:	39 d0                	cmp    %edx,%eax
80104eb4:	73 1a                	jae    80104ed0 <argptr+0x60>
80104eb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104eb9:	01 c3                	add    %eax,%ebx
80104ebb:	39 da                	cmp    %ebx,%edx
80104ebd:	72 11                	jb     80104ed0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104ebf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ec2:	89 02                	mov    %eax,(%edx)
  return 0;
80104ec4:	31 c0                	xor    %eax,%eax
}
80104ec6:	83 c4 0c             	add    $0xc,%esp
80104ec9:	5b                   	pop    %ebx
80104eca:	5e                   	pop    %esi
80104ecb:	5f                   	pop    %edi
80104ecc:	5d                   	pop    %ebp
80104ecd:	c3                   	ret
80104ece:	66 90                	xchg   %ax,%ax
    return -1;
80104ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ed5:	eb ef                	jmp    80104ec6 <argptr+0x56>
80104ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ede:	66 90                	xchg   %ax,%ax

80104ee0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ee5:	e8 66 ec ff ff       	call   80103b50 <myproc>
80104eea:	8b 55 08             	mov    0x8(%ebp),%edx
80104eed:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ef0:	8b 40 44             	mov    0x44(%eax),%eax
80104ef3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ef6:	e8 55 ec ff ff       	call   80103b50 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104efb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104efe:	8b 00                	mov    (%eax),%eax
80104f00:	39 c6                	cmp    %eax,%esi
80104f02:	73 44                	jae    80104f48 <argstr+0x68>
80104f04:	8d 53 08             	lea    0x8(%ebx),%edx
80104f07:	39 d0                	cmp    %edx,%eax
80104f09:	72 3d                	jb     80104f48 <argstr+0x68>
  *ip = *(int*)(addr);
80104f0b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104f0e:	e8 3d ec ff ff       	call   80103b50 <myproc>
  if(addr >= curproc->sz)
80104f13:	3b 18                	cmp    (%eax),%ebx
80104f15:	73 31                	jae    80104f48 <argstr+0x68>
  *pp = (char*)addr;
80104f17:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f1a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104f1c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104f1e:	39 d3                	cmp    %edx,%ebx
80104f20:	73 26                	jae    80104f48 <argstr+0x68>
80104f22:	89 d8                	mov    %ebx,%eax
80104f24:	eb 11                	jmp    80104f37 <argstr+0x57>
80104f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
80104f30:	83 c0 01             	add    $0x1,%eax
80104f33:	39 d0                	cmp    %edx,%eax
80104f35:	73 11                	jae    80104f48 <argstr+0x68>
    if(*s == 0)
80104f37:	80 38 00             	cmpb   $0x0,(%eax)
80104f3a:	75 f4                	jne    80104f30 <argstr+0x50>
      return s - *pp;
80104f3c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104f3e:	5b                   	pop    %ebx
80104f3f:	5e                   	pop    %esi
80104f40:	5d                   	pop    %ebp
80104f41:	c3                   	ret
80104f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f48:	5b                   	pop    %ebx
    return -1;
80104f49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f4e:	5e                   	pop    %esi
80104f4f:	5d                   	pop    %ebp
80104f50:	c3                   	ret
80104f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f5f:	90                   	nop

80104f60 <syscall>:
[SYS_getNumFreePages]   sys_getNumFreePages,
};

void
syscall(void)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	53                   	push   %ebx
80104f64:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104f67:	e8 e4 eb ff ff       	call   80103b50 <myproc>
80104f6c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f6e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104f71:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f74:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f77:	83 fa 16             	cmp    $0x16,%edx
80104f7a:	77 24                	ja     80104fa0 <syscall+0x40>
80104f7c:	8b 14 85 e0 8b 10 80 	mov    -0x7fef7420(,%eax,4),%edx
80104f83:	85 d2                	test   %edx,%edx
80104f85:	74 19                	je     80104fa0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104f87:	ff d2                	call   *%edx
80104f89:	89 c2                	mov    %eax,%edx
80104f8b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104f8e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104f91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f94:	c9                   	leave
80104f95:	c3                   	ret
80104f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104fa0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104fa1:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104fa4:	50                   	push   %eax
80104fa5:	ff 73 14             	push   0x14(%ebx)
80104fa8:	68 44 85 10 80       	push   $0x80108544
80104fad:	e8 ee b7 ff ff       	call   801007a0 <cprintf>
    curproc->tf->eax = -1;
80104fb2:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104fb5:	83 c4 10             	add    $0x10,%esp
80104fb8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104fbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fc2:	c9                   	leave
80104fc3:	c3                   	ret
80104fc4:	66 90                	xchg   %ax,%ax
80104fc6:	66 90                	xchg   %ax,%ax
80104fc8:	66 90                	xchg   %ax,%ax
80104fca:	66 90                	xchg   %ax,%ax
80104fcc:	66 90                	xchg   %ax,%ax
80104fce:	66 90                	xchg   %ax,%ax

80104fd0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	57                   	push   %edi
80104fd4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104fd5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104fd8:	53                   	push   %ebx
80104fd9:	83 ec 34             	sub    $0x34,%esp
80104fdc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104fdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104fe2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104fe5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104fe8:	57                   	push   %edi
80104fe9:	50                   	push   %eax
80104fea:	e8 a1 d1 ff ff       	call   80102190 <nameiparent>
80104fef:	83 c4 10             	add    $0x10,%esp
80104ff2:	85 c0                	test   %eax,%eax
80104ff4:	74 5e                	je     80105054 <create+0x84>
    return 0;
  ilock(dp);
80104ff6:	83 ec 0c             	sub    $0xc,%esp
80104ff9:	89 c3                	mov    %eax,%ebx
80104ffb:	50                   	push   %eax
80104ffc:	e8 8f c8 ff ff       	call   80101890 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105001:	83 c4 0c             	add    $0xc,%esp
80105004:	6a 00                	push   $0x0
80105006:	57                   	push   %edi
80105007:	53                   	push   %ebx
80105008:	e8 d3 cd ff ff       	call   80101de0 <dirlookup>
8010500d:	83 c4 10             	add    $0x10,%esp
80105010:	89 c6                	mov    %eax,%esi
80105012:	85 c0                	test   %eax,%eax
80105014:	74 4a                	je     80105060 <create+0x90>
    iunlockput(dp);
80105016:	83 ec 0c             	sub    $0xc,%esp
80105019:	53                   	push   %ebx
8010501a:	e8 01 cb ff ff       	call   80101b20 <iunlockput>
    ilock(ip);
8010501f:	89 34 24             	mov    %esi,(%esp)
80105022:	e8 69 c8 ff ff       	call   80101890 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105027:	83 c4 10             	add    $0x10,%esp
8010502a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010502f:	75 17                	jne    80105048 <create+0x78>
80105031:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105036:	75 10                	jne    80105048 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105038:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010503b:	89 f0                	mov    %esi,%eax
8010503d:	5b                   	pop    %ebx
8010503e:	5e                   	pop    %esi
8010503f:	5f                   	pop    %edi
80105040:	5d                   	pop    %ebp
80105041:	c3                   	ret
80105042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105048:	83 ec 0c             	sub    $0xc,%esp
8010504b:	56                   	push   %esi
8010504c:	e8 cf ca ff ff       	call   80101b20 <iunlockput>
    return 0;
80105051:	83 c4 10             	add    $0x10,%esp
}
80105054:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105057:	31 f6                	xor    %esi,%esi
}
80105059:	5b                   	pop    %ebx
8010505a:	89 f0                	mov    %esi,%eax
8010505c:	5e                   	pop    %esi
8010505d:	5f                   	pop    %edi
8010505e:	5d                   	pop    %ebp
8010505f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80105060:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105064:	83 ec 08             	sub    $0x8,%esp
80105067:	50                   	push   %eax
80105068:	ff 33                	push   (%ebx)
8010506a:	e8 b1 c6 ff ff       	call   80101720 <ialloc>
8010506f:	83 c4 10             	add    $0x10,%esp
80105072:	89 c6                	mov    %eax,%esi
80105074:	85 c0                	test   %eax,%eax
80105076:	0f 84 bc 00 00 00    	je     80105138 <create+0x168>
  ilock(ip);
8010507c:	83 ec 0c             	sub    $0xc,%esp
8010507f:	50                   	push   %eax
80105080:	e8 0b c8 ff ff       	call   80101890 <ilock>
  ip->major = major;
80105085:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105089:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010508d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105091:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105095:	b8 01 00 00 00       	mov    $0x1,%eax
8010509a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010509e:	89 34 24             	mov    %esi,(%esp)
801050a1:	e8 3a c7 ff ff       	call   801017e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801050a6:	83 c4 10             	add    $0x10,%esp
801050a9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801050ae:	74 30                	je     801050e0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
801050b0:	83 ec 04             	sub    $0x4,%esp
801050b3:	ff 76 04             	push   0x4(%esi)
801050b6:	57                   	push   %edi
801050b7:	53                   	push   %ebx
801050b8:	e8 f3 cf ff ff       	call   801020b0 <dirlink>
801050bd:	83 c4 10             	add    $0x10,%esp
801050c0:	85 c0                	test   %eax,%eax
801050c2:	78 67                	js     8010512b <create+0x15b>
  iunlockput(dp);
801050c4:	83 ec 0c             	sub    $0xc,%esp
801050c7:	53                   	push   %ebx
801050c8:	e8 53 ca ff ff       	call   80101b20 <iunlockput>
  return ip;
801050cd:	83 c4 10             	add    $0x10,%esp
}
801050d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050d3:	89 f0                	mov    %esi,%eax
801050d5:	5b                   	pop    %ebx
801050d6:	5e                   	pop    %esi
801050d7:	5f                   	pop    %edi
801050d8:	5d                   	pop    %ebp
801050d9:	c3                   	ret
801050da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801050e0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801050e3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801050e8:	53                   	push   %ebx
801050e9:	e8 f2 c6 ff ff       	call   801017e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801050ee:	83 c4 0c             	add    $0xc,%esp
801050f1:	ff 76 04             	push   0x4(%esi)
801050f4:	68 7c 85 10 80       	push   $0x8010857c
801050f9:	56                   	push   %esi
801050fa:	e8 b1 cf ff ff       	call   801020b0 <dirlink>
801050ff:	83 c4 10             	add    $0x10,%esp
80105102:	85 c0                	test   %eax,%eax
80105104:	78 18                	js     8010511e <create+0x14e>
80105106:	83 ec 04             	sub    $0x4,%esp
80105109:	ff 73 04             	push   0x4(%ebx)
8010510c:	68 7b 85 10 80       	push   $0x8010857b
80105111:	56                   	push   %esi
80105112:	e8 99 cf ff ff       	call   801020b0 <dirlink>
80105117:	83 c4 10             	add    $0x10,%esp
8010511a:	85 c0                	test   %eax,%eax
8010511c:	79 92                	jns    801050b0 <create+0xe0>
      panic("create dots");
8010511e:	83 ec 0c             	sub    $0xc,%esp
80105121:	68 6f 85 10 80       	push   $0x8010856f
80105126:	e8 45 b3 ff ff       	call   80100470 <panic>
    panic("create: dirlink");
8010512b:	83 ec 0c             	sub    $0xc,%esp
8010512e:	68 7e 85 10 80       	push   $0x8010857e
80105133:	e8 38 b3 ff ff       	call   80100470 <panic>
    panic("create: ialloc");
80105138:	83 ec 0c             	sub    $0xc,%esp
8010513b:	68 60 85 10 80       	push   $0x80108560
80105140:	e8 2b b3 ff ff       	call   80100470 <panic>
80105145:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010514c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105150 <sys_dup>:
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	56                   	push   %esi
80105154:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105155:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105158:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010515b:	50                   	push   %eax
8010515c:	6a 00                	push   $0x0
8010515e:	e8 bd fc ff ff       	call   80104e20 <argint>
80105163:	83 c4 10             	add    $0x10,%esp
80105166:	85 c0                	test   %eax,%eax
80105168:	78 36                	js     801051a0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010516a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010516e:	77 30                	ja     801051a0 <sys_dup+0x50>
80105170:	e8 db e9 ff ff       	call   80103b50 <myproc>
80105175:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105178:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010517c:	85 f6                	test   %esi,%esi
8010517e:	74 20                	je     801051a0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105180:	e8 cb e9 ff ff       	call   80103b50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105185:	31 db                	xor    %ebx,%ebx
80105187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010518e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105190:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105194:	85 d2                	test   %edx,%edx
80105196:	74 18                	je     801051b0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105198:	83 c3 01             	add    $0x1,%ebx
8010519b:	83 fb 10             	cmp    $0x10,%ebx
8010519e:	75 f0                	jne    80105190 <sys_dup+0x40>
}
801051a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801051a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801051a8:	89 d8                	mov    %ebx,%eax
801051aa:	5b                   	pop    %ebx
801051ab:	5e                   	pop    %esi
801051ac:	5d                   	pop    %ebp
801051ad:	c3                   	ret
801051ae:	66 90                	xchg   %ax,%ax
  filedup(f);
801051b0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801051b3:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
801051b7:	56                   	push   %esi
801051b8:	e8 f3 bd ff ff       	call   80100fb0 <filedup>
  return fd;
801051bd:	83 c4 10             	add    $0x10,%esp
}
801051c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051c3:	89 d8                	mov    %ebx,%eax
801051c5:	5b                   	pop    %ebx
801051c6:	5e                   	pop    %esi
801051c7:	5d                   	pop    %ebp
801051c8:	c3                   	ret
801051c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801051d0 <sys_read>:
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	56                   	push   %esi
801051d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801051d5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801051d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051db:	53                   	push   %ebx
801051dc:	6a 00                	push   $0x0
801051de:	e8 3d fc ff ff       	call   80104e20 <argint>
801051e3:	83 c4 10             	add    $0x10,%esp
801051e6:	85 c0                	test   %eax,%eax
801051e8:	78 5e                	js     80105248 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051ee:	77 58                	ja     80105248 <sys_read+0x78>
801051f0:	e8 5b e9 ff ff       	call   80103b50 <myproc>
801051f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051f8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
801051fc:	85 f6                	test   %esi,%esi
801051fe:	74 48                	je     80105248 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105200:	83 ec 08             	sub    $0x8,%esp
80105203:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105206:	50                   	push   %eax
80105207:	6a 02                	push   $0x2
80105209:	e8 12 fc ff ff       	call   80104e20 <argint>
8010520e:	83 c4 10             	add    $0x10,%esp
80105211:	85 c0                	test   %eax,%eax
80105213:	78 33                	js     80105248 <sys_read+0x78>
80105215:	83 ec 04             	sub    $0x4,%esp
80105218:	ff 75 f0             	push   -0x10(%ebp)
8010521b:	53                   	push   %ebx
8010521c:	6a 01                	push   $0x1
8010521e:	e8 4d fc ff ff       	call   80104e70 <argptr>
80105223:	83 c4 10             	add    $0x10,%esp
80105226:	85 c0                	test   %eax,%eax
80105228:	78 1e                	js     80105248 <sys_read+0x78>
  return fileread(f, p, n);
8010522a:	83 ec 04             	sub    $0x4,%esp
8010522d:	ff 75 f0             	push   -0x10(%ebp)
80105230:	ff 75 f4             	push   -0xc(%ebp)
80105233:	56                   	push   %esi
80105234:	e8 f7 be ff ff       	call   80101130 <fileread>
80105239:	83 c4 10             	add    $0x10,%esp
}
8010523c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010523f:	5b                   	pop    %ebx
80105240:	5e                   	pop    %esi
80105241:	5d                   	pop    %ebp
80105242:	c3                   	ret
80105243:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105247:	90                   	nop
    return -1;
80105248:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010524d:	eb ed                	jmp    8010523c <sys_read+0x6c>
8010524f:	90                   	nop

80105250 <sys_write>:
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	56                   	push   %esi
80105254:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105255:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105258:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010525b:	53                   	push   %ebx
8010525c:	6a 00                	push   $0x0
8010525e:	e8 bd fb ff ff       	call   80104e20 <argint>
80105263:	83 c4 10             	add    $0x10,%esp
80105266:	85 c0                	test   %eax,%eax
80105268:	78 5e                	js     801052c8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010526a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010526e:	77 58                	ja     801052c8 <sys_write+0x78>
80105270:	e8 db e8 ff ff       	call   80103b50 <myproc>
80105275:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105278:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010527c:	85 f6                	test   %esi,%esi
8010527e:	74 48                	je     801052c8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105280:	83 ec 08             	sub    $0x8,%esp
80105283:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105286:	50                   	push   %eax
80105287:	6a 02                	push   $0x2
80105289:	e8 92 fb ff ff       	call   80104e20 <argint>
8010528e:	83 c4 10             	add    $0x10,%esp
80105291:	85 c0                	test   %eax,%eax
80105293:	78 33                	js     801052c8 <sys_write+0x78>
80105295:	83 ec 04             	sub    $0x4,%esp
80105298:	ff 75 f0             	push   -0x10(%ebp)
8010529b:	53                   	push   %ebx
8010529c:	6a 01                	push   $0x1
8010529e:	e8 cd fb ff ff       	call   80104e70 <argptr>
801052a3:	83 c4 10             	add    $0x10,%esp
801052a6:	85 c0                	test   %eax,%eax
801052a8:	78 1e                	js     801052c8 <sys_write+0x78>
  return filewrite(f, p, n);
801052aa:	83 ec 04             	sub    $0x4,%esp
801052ad:	ff 75 f0             	push   -0x10(%ebp)
801052b0:	ff 75 f4             	push   -0xc(%ebp)
801052b3:	56                   	push   %esi
801052b4:	e8 07 bf ff ff       	call   801011c0 <filewrite>
801052b9:	83 c4 10             	add    $0x10,%esp
}
801052bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052bf:	5b                   	pop    %ebx
801052c0:	5e                   	pop    %esi
801052c1:	5d                   	pop    %ebp
801052c2:	c3                   	ret
801052c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052c7:	90                   	nop
    return -1;
801052c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052cd:	eb ed                	jmp    801052bc <sys_write+0x6c>
801052cf:	90                   	nop

801052d0 <sys_close>:
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	56                   	push   %esi
801052d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801052d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801052d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801052db:	50                   	push   %eax
801052dc:	6a 00                	push   $0x0
801052de:	e8 3d fb ff ff       	call   80104e20 <argint>
801052e3:	83 c4 10             	add    $0x10,%esp
801052e6:	85 c0                	test   %eax,%eax
801052e8:	78 3e                	js     80105328 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801052ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052ee:	77 38                	ja     80105328 <sys_close+0x58>
801052f0:	e8 5b e8 ff ff       	call   80103b50 <myproc>
801052f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052f8:	8d 5a 08             	lea    0x8(%edx),%ebx
801052fb:	8b 74 98 0c          	mov    0xc(%eax,%ebx,4),%esi
801052ff:	85 f6                	test   %esi,%esi
80105301:	74 25                	je     80105328 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105303:	e8 48 e8 ff ff       	call   80103b50 <myproc>
  fileclose(f);
80105308:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010530b:	c7 44 98 0c 00 00 00 	movl   $0x0,0xc(%eax,%ebx,4)
80105312:	00 
  fileclose(f);
80105313:	56                   	push   %esi
80105314:	e8 e7 bc ff ff       	call   80101000 <fileclose>
  return 0;
80105319:	83 c4 10             	add    $0x10,%esp
8010531c:	31 c0                	xor    %eax,%eax
}
8010531e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105321:	5b                   	pop    %ebx
80105322:	5e                   	pop    %esi
80105323:	5d                   	pop    %ebp
80105324:	c3                   	ret
80105325:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105328:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010532d:	eb ef                	jmp    8010531e <sys_close+0x4e>
8010532f:	90                   	nop

80105330 <sys_fstat>:
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	56                   	push   %esi
80105334:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105335:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105338:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010533b:	53                   	push   %ebx
8010533c:	6a 00                	push   $0x0
8010533e:	e8 dd fa ff ff       	call   80104e20 <argint>
80105343:	83 c4 10             	add    $0x10,%esp
80105346:	85 c0                	test   %eax,%eax
80105348:	78 46                	js     80105390 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010534a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010534e:	77 40                	ja     80105390 <sys_fstat+0x60>
80105350:	e8 fb e7 ff ff       	call   80103b50 <myproc>
80105355:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105358:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010535c:	85 f6                	test   %esi,%esi
8010535e:	74 30                	je     80105390 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105360:	83 ec 04             	sub    $0x4,%esp
80105363:	6a 14                	push   $0x14
80105365:	53                   	push   %ebx
80105366:	6a 01                	push   $0x1
80105368:	e8 03 fb ff ff       	call   80104e70 <argptr>
8010536d:	83 c4 10             	add    $0x10,%esp
80105370:	85 c0                	test   %eax,%eax
80105372:	78 1c                	js     80105390 <sys_fstat+0x60>
  return filestat(f, st);
80105374:	83 ec 08             	sub    $0x8,%esp
80105377:	ff 75 f4             	push   -0xc(%ebp)
8010537a:	56                   	push   %esi
8010537b:	e8 60 bd ff ff       	call   801010e0 <filestat>
80105380:	83 c4 10             	add    $0x10,%esp
}
80105383:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105386:	5b                   	pop    %ebx
80105387:	5e                   	pop    %esi
80105388:	5d                   	pop    %ebp
80105389:	c3                   	ret
8010538a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105390:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105395:	eb ec                	jmp    80105383 <sys_fstat+0x53>
80105397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010539e:	66 90                	xchg   %ax,%ax

801053a0 <sys_link>:
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	57                   	push   %edi
801053a4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801053a5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801053a8:	53                   	push   %ebx
801053a9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801053ac:	50                   	push   %eax
801053ad:	6a 00                	push   $0x0
801053af:	e8 2c fb ff ff       	call   80104ee0 <argstr>
801053b4:	83 c4 10             	add    $0x10,%esp
801053b7:	85 c0                	test   %eax,%eax
801053b9:	0f 88 fb 00 00 00    	js     801054ba <sys_link+0x11a>
801053bf:	83 ec 08             	sub    $0x8,%esp
801053c2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801053c5:	50                   	push   %eax
801053c6:	6a 01                	push   $0x1
801053c8:	e8 13 fb ff ff       	call   80104ee0 <argstr>
801053cd:	83 c4 10             	add    $0x10,%esp
801053d0:	85 c0                	test   %eax,%eax
801053d2:	0f 88 e2 00 00 00    	js     801054ba <sys_link+0x11a>
  begin_op();
801053d8:	e8 63 db ff ff       	call   80102f40 <begin_op>
  if((ip = namei(old)) == 0){
801053dd:	83 ec 0c             	sub    $0xc,%esp
801053e0:	ff 75 d4             	push   -0x2c(%ebp)
801053e3:	e8 88 cd ff ff       	call   80102170 <namei>
801053e8:	83 c4 10             	add    $0x10,%esp
801053eb:	89 c3                	mov    %eax,%ebx
801053ed:	85 c0                	test   %eax,%eax
801053ef:	0f 84 df 00 00 00    	je     801054d4 <sys_link+0x134>
  ilock(ip);
801053f5:	83 ec 0c             	sub    $0xc,%esp
801053f8:	50                   	push   %eax
801053f9:	e8 92 c4 ff ff       	call   80101890 <ilock>
  if(ip->type == T_DIR){
801053fe:	83 c4 10             	add    $0x10,%esp
80105401:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105406:	0f 84 b5 00 00 00    	je     801054c1 <sys_link+0x121>
  iupdate(ip);
8010540c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010540f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105414:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105417:	53                   	push   %ebx
80105418:	e8 c3 c3 ff ff       	call   801017e0 <iupdate>
  iunlock(ip);
8010541d:	89 1c 24             	mov    %ebx,(%esp)
80105420:	e8 4b c5 ff ff       	call   80101970 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105425:	58                   	pop    %eax
80105426:	5a                   	pop    %edx
80105427:	57                   	push   %edi
80105428:	ff 75 d0             	push   -0x30(%ebp)
8010542b:	e8 60 cd ff ff       	call   80102190 <nameiparent>
80105430:	83 c4 10             	add    $0x10,%esp
80105433:	89 c6                	mov    %eax,%esi
80105435:	85 c0                	test   %eax,%eax
80105437:	74 5b                	je     80105494 <sys_link+0xf4>
  ilock(dp);
80105439:	83 ec 0c             	sub    $0xc,%esp
8010543c:	50                   	push   %eax
8010543d:	e8 4e c4 ff ff       	call   80101890 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105442:	8b 03                	mov    (%ebx),%eax
80105444:	83 c4 10             	add    $0x10,%esp
80105447:	39 06                	cmp    %eax,(%esi)
80105449:	75 3d                	jne    80105488 <sys_link+0xe8>
8010544b:	83 ec 04             	sub    $0x4,%esp
8010544e:	ff 73 04             	push   0x4(%ebx)
80105451:	57                   	push   %edi
80105452:	56                   	push   %esi
80105453:	e8 58 cc ff ff       	call   801020b0 <dirlink>
80105458:	83 c4 10             	add    $0x10,%esp
8010545b:	85 c0                	test   %eax,%eax
8010545d:	78 29                	js     80105488 <sys_link+0xe8>
  iunlockput(dp);
8010545f:	83 ec 0c             	sub    $0xc,%esp
80105462:	56                   	push   %esi
80105463:	e8 b8 c6 ff ff       	call   80101b20 <iunlockput>
  iput(ip);
80105468:	89 1c 24             	mov    %ebx,(%esp)
8010546b:	e8 50 c5 ff ff       	call   801019c0 <iput>
  end_op();
80105470:	e8 3b db ff ff       	call   80102fb0 <end_op>
  return 0;
80105475:	83 c4 10             	add    $0x10,%esp
80105478:	31 c0                	xor    %eax,%eax
}
8010547a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010547d:	5b                   	pop    %ebx
8010547e:	5e                   	pop    %esi
8010547f:	5f                   	pop    %edi
80105480:	5d                   	pop    %ebp
80105481:	c3                   	ret
80105482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105488:	83 ec 0c             	sub    $0xc,%esp
8010548b:	56                   	push   %esi
8010548c:	e8 8f c6 ff ff       	call   80101b20 <iunlockput>
    goto bad;
80105491:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105494:	83 ec 0c             	sub    $0xc,%esp
80105497:	53                   	push   %ebx
80105498:	e8 f3 c3 ff ff       	call   80101890 <ilock>
  ip->nlink--;
8010549d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054a2:	89 1c 24             	mov    %ebx,(%esp)
801054a5:	e8 36 c3 ff ff       	call   801017e0 <iupdate>
  iunlockput(ip);
801054aa:	89 1c 24             	mov    %ebx,(%esp)
801054ad:	e8 6e c6 ff ff       	call   80101b20 <iunlockput>
  end_op();
801054b2:	e8 f9 da ff ff       	call   80102fb0 <end_op>
  return -1;
801054b7:	83 c4 10             	add    $0x10,%esp
    return -1;
801054ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054bf:	eb b9                	jmp    8010547a <sys_link+0xda>
    iunlockput(ip);
801054c1:	83 ec 0c             	sub    $0xc,%esp
801054c4:	53                   	push   %ebx
801054c5:	e8 56 c6 ff ff       	call   80101b20 <iunlockput>
    end_op();
801054ca:	e8 e1 da ff ff       	call   80102fb0 <end_op>
    return -1;
801054cf:	83 c4 10             	add    $0x10,%esp
801054d2:	eb e6                	jmp    801054ba <sys_link+0x11a>
    end_op();
801054d4:	e8 d7 da ff ff       	call   80102fb0 <end_op>
    return -1;
801054d9:	eb df                	jmp    801054ba <sys_link+0x11a>
801054db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054df:	90                   	nop

801054e0 <sys_unlink>:
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	57                   	push   %edi
801054e4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801054e5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801054e8:	53                   	push   %ebx
801054e9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801054ec:	50                   	push   %eax
801054ed:	6a 00                	push   $0x0
801054ef:	e8 ec f9 ff ff       	call   80104ee0 <argstr>
801054f4:	83 c4 10             	add    $0x10,%esp
801054f7:	85 c0                	test   %eax,%eax
801054f9:	0f 88 54 01 00 00    	js     80105653 <sys_unlink+0x173>
  begin_op();
801054ff:	e8 3c da ff ff       	call   80102f40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105504:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105507:	83 ec 08             	sub    $0x8,%esp
8010550a:	53                   	push   %ebx
8010550b:	ff 75 c0             	push   -0x40(%ebp)
8010550e:	e8 7d cc ff ff       	call   80102190 <nameiparent>
80105513:	83 c4 10             	add    $0x10,%esp
80105516:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105519:	85 c0                	test   %eax,%eax
8010551b:	0f 84 58 01 00 00    	je     80105679 <sys_unlink+0x199>
  ilock(dp);
80105521:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105524:	83 ec 0c             	sub    $0xc,%esp
80105527:	57                   	push   %edi
80105528:	e8 63 c3 ff ff       	call   80101890 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010552d:	58                   	pop    %eax
8010552e:	5a                   	pop    %edx
8010552f:	68 7c 85 10 80       	push   $0x8010857c
80105534:	53                   	push   %ebx
80105535:	e8 86 c8 ff ff       	call   80101dc0 <namecmp>
8010553a:	83 c4 10             	add    $0x10,%esp
8010553d:	85 c0                	test   %eax,%eax
8010553f:	0f 84 fb 00 00 00    	je     80105640 <sys_unlink+0x160>
80105545:	83 ec 08             	sub    $0x8,%esp
80105548:	68 7b 85 10 80       	push   $0x8010857b
8010554d:	53                   	push   %ebx
8010554e:	e8 6d c8 ff ff       	call   80101dc0 <namecmp>
80105553:	83 c4 10             	add    $0x10,%esp
80105556:	85 c0                	test   %eax,%eax
80105558:	0f 84 e2 00 00 00    	je     80105640 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010555e:	83 ec 04             	sub    $0x4,%esp
80105561:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105564:	50                   	push   %eax
80105565:	53                   	push   %ebx
80105566:	57                   	push   %edi
80105567:	e8 74 c8 ff ff       	call   80101de0 <dirlookup>
8010556c:	83 c4 10             	add    $0x10,%esp
8010556f:	89 c3                	mov    %eax,%ebx
80105571:	85 c0                	test   %eax,%eax
80105573:	0f 84 c7 00 00 00    	je     80105640 <sys_unlink+0x160>
  ilock(ip);
80105579:	83 ec 0c             	sub    $0xc,%esp
8010557c:	50                   	push   %eax
8010557d:	e8 0e c3 ff ff       	call   80101890 <ilock>
  if(ip->nlink < 1)
80105582:	83 c4 10             	add    $0x10,%esp
80105585:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010558a:	0f 8e 0a 01 00 00    	jle    8010569a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105590:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105595:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105598:	74 66                	je     80105600 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010559a:	83 ec 04             	sub    $0x4,%esp
8010559d:	6a 10                	push   $0x10
8010559f:	6a 00                	push   $0x0
801055a1:	57                   	push   %edi
801055a2:	e8 c9 f5 ff ff       	call   80104b70 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055a7:	6a 10                	push   $0x10
801055a9:	ff 75 c4             	push   -0x3c(%ebp)
801055ac:	57                   	push   %edi
801055ad:	ff 75 b4             	push   -0x4c(%ebp)
801055b0:	e8 eb c6 ff ff       	call   80101ca0 <writei>
801055b5:	83 c4 20             	add    $0x20,%esp
801055b8:	83 f8 10             	cmp    $0x10,%eax
801055bb:	0f 85 cc 00 00 00    	jne    8010568d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
801055c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055c6:	0f 84 94 00 00 00    	je     80105660 <sys_unlink+0x180>
  iunlockput(dp);
801055cc:	83 ec 0c             	sub    $0xc,%esp
801055cf:	ff 75 b4             	push   -0x4c(%ebp)
801055d2:	e8 49 c5 ff ff       	call   80101b20 <iunlockput>
  ip->nlink--;
801055d7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055dc:	89 1c 24             	mov    %ebx,(%esp)
801055df:	e8 fc c1 ff ff       	call   801017e0 <iupdate>
  iunlockput(ip);
801055e4:	89 1c 24             	mov    %ebx,(%esp)
801055e7:	e8 34 c5 ff ff       	call   80101b20 <iunlockput>
  end_op();
801055ec:	e8 bf d9 ff ff       	call   80102fb0 <end_op>
  return 0;
801055f1:	83 c4 10             	add    $0x10,%esp
801055f4:	31 c0                	xor    %eax,%eax
}
801055f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055f9:	5b                   	pop    %ebx
801055fa:	5e                   	pop    %esi
801055fb:	5f                   	pop    %edi
801055fc:	5d                   	pop    %ebp
801055fd:	c3                   	ret
801055fe:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105600:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105604:	76 94                	jbe    8010559a <sys_unlink+0xba>
80105606:	be 20 00 00 00       	mov    $0x20,%esi
8010560b:	eb 0b                	jmp    80105618 <sys_unlink+0x138>
8010560d:	8d 76 00             	lea    0x0(%esi),%esi
80105610:	83 c6 10             	add    $0x10,%esi
80105613:	3b 73 58             	cmp    0x58(%ebx),%esi
80105616:	73 82                	jae    8010559a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105618:	6a 10                	push   $0x10
8010561a:	56                   	push   %esi
8010561b:	57                   	push   %edi
8010561c:	53                   	push   %ebx
8010561d:	e8 7e c5 ff ff       	call   80101ba0 <readi>
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	83 f8 10             	cmp    $0x10,%eax
80105628:	75 56                	jne    80105680 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010562a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010562f:	74 df                	je     80105610 <sys_unlink+0x130>
    iunlockput(ip);
80105631:	83 ec 0c             	sub    $0xc,%esp
80105634:	53                   	push   %ebx
80105635:	e8 e6 c4 ff ff       	call   80101b20 <iunlockput>
    goto bad;
8010563a:	83 c4 10             	add    $0x10,%esp
8010563d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	ff 75 b4             	push   -0x4c(%ebp)
80105646:	e8 d5 c4 ff ff       	call   80101b20 <iunlockput>
  end_op();
8010564b:	e8 60 d9 ff ff       	call   80102fb0 <end_op>
  return -1;
80105650:	83 c4 10             	add    $0x10,%esp
    return -1;
80105653:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105658:	eb 9c                	jmp    801055f6 <sys_unlink+0x116>
8010565a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105660:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105663:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105666:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010566b:	50                   	push   %eax
8010566c:	e8 6f c1 ff ff       	call   801017e0 <iupdate>
80105671:	83 c4 10             	add    $0x10,%esp
80105674:	e9 53 ff ff ff       	jmp    801055cc <sys_unlink+0xec>
    end_op();
80105679:	e8 32 d9 ff ff       	call   80102fb0 <end_op>
    return -1;
8010567e:	eb d3                	jmp    80105653 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105680:	83 ec 0c             	sub    $0xc,%esp
80105683:	68 a0 85 10 80       	push   $0x801085a0
80105688:	e8 e3 ad ff ff       	call   80100470 <panic>
    panic("unlink: writei");
8010568d:	83 ec 0c             	sub    $0xc,%esp
80105690:	68 b2 85 10 80       	push   $0x801085b2
80105695:	e8 d6 ad ff ff       	call   80100470 <panic>
    panic("unlink: nlink < 1");
8010569a:	83 ec 0c             	sub    $0xc,%esp
8010569d:	68 8e 85 10 80       	push   $0x8010858e
801056a2:	e8 c9 ad ff ff       	call   80100470 <panic>
801056a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ae:	66 90                	xchg   %ax,%ax

801056b0 <sys_open>:

int
sys_open(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	57                   	push   %edi
801056b4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801056b8:	53                   	push   %ebx
801056b9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056bc:	50                   	push   %eax
801056bd:	6a 00                	push   $0x0
801056bf:	e8 1c f8 ff ff       	call   80104ee0 <argstr>
801056c4:	83 c4 10             	add    $0x10,%esp
801056c7:	85 c0                	test   %eax,%eax
801056c9:	0f 88 8e 00 00 00    	js     8010575d <sys_open+0xad>
801056cf:	83 ec 08             	sub    $0x8,%esp
801056d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801056d5:	50                   	push   %eax
801056d6:	6a 01                	push   $0x1
801056d8:	e8 43 f7 ff ff       	call   80104e20 <argint>
801056dd:	83 c4 10             	add    $0x10,%esp
801056e0:	85 c0                	test   %eax,%eax
801056e2:	78 79                	js     8010575d <sys_open+0xad>
    return -1;

  begin_op();
801056e4:	e8 57 d8 ff ff       	call   80102f40 <begin_op>

  if(omode & O_CREATE){
801056e9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801056ed:	75 79                	jne    80105768 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801056ef:	83 ec 0c             	sub    $0xc,%esp
801056f2:	ff 75 e0             	push   -0x20(%ebp)
801056f5:	e8 76 ca ff ff       	call   80102170 <namei>
801056fa:	83 c4 10             	add    $0x10,%esp
801056fd:	89 c6                	mov    %eax,%esi
801056ff:	85 c0                	test   %eax,%eax
80105701:	0f 84 7e 00 00 00    	je     80105785 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105707:	83 ec 0c             	sub    $0xc,%esp
8010570a:	50                   	push   %eax
8010570b:	e8 80 c1 ff ff       	call   80101890 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105710:	83 c4 10             	add    $0x10,%esp
80105713:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105718:	0f 84 ba 00 00 00    	je     801057d8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010571e:	e8 1d b8 ff ff       	call   80100f40 <filealloc>
80105723:	89 c7                	mov    %eax,%edi
80105725:	85 c0                	test   %eax,%eax
80105727:	74 23                	je     8010574c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105729:	e8 22 e4 ff ff       	call   80103b50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010572e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105730:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105734:	85 d2                	test   %edx,%edx
80105736:	74 58                	je     80105790 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105738:	83 c3 01             	add    $0x1,%ebx
8010573b:	83 fb 10             	cmp    $0x10,%ebx
8010573e:	75 f0                	jne    80105730 <sys_open+0x80>
    if(f)
      fileclose(f);
80105740:	83 ec 0c             	sub    $0xc,%esp
80105743:	57                   	push   %edi
80105744:	e8 b7 b8 ff ff       	call   80101000 <fileclose>
80105749:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010574c:	83 ec 0c             	sub    $0xc,%esp
8010574f:	56                   	push   %esi
80105750:	e8 cb c3 ff ff       	call   80101b20 <iunlockput>
    end_op();
80105755:	e8 56 d8 ff ff       	call   80102fb0 <end_op>
    return -1;
8010575a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010575d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105762:	eb 65                	jmp    801057c9 <sys_open+0x119>
80105764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105768:	83 ec 0c             	sub    $0xc,%esp
8010576b:	31 c9                	xor    %ecx,%ecx
8010576d:	ba 02 00 00 00       	mov    $0x2,%edx
80105772:	6a 00                	push   $0x0
80105774:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105777:	e8 54 f8 ff ff       	call   80104fd0 <create>
    if(ip == 0){
8010577c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010577f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105781:	85 c0                	test   %eax,%eax
80105783:	75 99                	jne    8010571e <sys_open+0x6e>
      end_op();
80105785:	e8 26 d8 ff ff       	call   80102fb0 <end_op>
      return -1;
8010578a:	eb d1                	jmp    8010575d <sys_open+0xad>
8010578c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105790:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105793:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
80105797:	56                   	push   %esi
80105798:	e8 d3 c1 ff ff       	call   80101970 <iunlock>
  end_op();
8010579d:	e8 0e d8 ff ff       	call   80102fb0 <end_op>

  f->type = FD_INODE;
801057a2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801057a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057ab:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801057ae:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801057b1:	89 d0                	mov    %edx,%eax
  f->off = 0;
801057b3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801057ba:	f7 d0                	not    %eax
801057bc:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057bf:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801057c2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057c5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801057c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057cc:	89 d8                	mov    %ebx,%eax
801057ce:	5b                   	pop    %ebx
801057cf:	5e                   	pop    %esi
801057d0:	5f                   	pop    %edi
801057d1:	5d                   	pop    %ebp
801057d2:	c3                   	ret
801057d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057d7:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801057d8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801057db:	85 c9                	test   %ecx,%ecx
801057dd:	0f 84 3b ff ff ff    	je     8010571e <sys_open+0x6e>
801057e3:	e9 64 ff ff ff       	jmp    8010574c <sys_open+0x9c>
801057e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ef:	90                   	nop

801057f0 <sys_mkdir>:

int
sys_mkdir(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801057f6:	e8 45 d7 ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801057fb:	83 ec 08             	sub    $0x8,%esp
801057fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105801:	50                   	push   %eax
80105802:	6a 00                	push   $0x0
80105804:	e8 d7 f6 ff ff       	call   80104ee0 <argstr>
80105809:	83 c4 10             	add    $0x10,%esp
8010580c:	85 c0                	test   %eax,%eax
8010580e:	78 30                	js     80105840 <sys_mkdir+0x50>
80105810:	83 ec 0c             	sub    $0xc,%esp
80105813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105816:	31 c9                	xor    %ecx,%ecx
80105818:	ba 01 00 00 00       	mov    $0x1,%edx
8010581d:	6a 00                	push   $0x0
8010581f:	e8 ac f7 ff ff       	call   80104fd0 <create>
80105824:	83 c4 10             	add    $0x10,%esp
80105827:	85 c0                	test   %eax,%eax
80105829:	74 15                	je     80105840 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010582b:	83 ec 0c             	sub    $0xc,%esp
8010582e:	50                   	push   %eax
8010582f:	e8 ec c2 ff ff       	call   80101b20 <iunlockput>
  end_op();
80105834:	e8 77 d7 ff ff       	call   80102fb0 <end_op>
  return 0;
80105839:	83 c4 10             	add    $0x10,%esp
8010583c:	31 c0                	xor    %eax,%eax
}
8010583e:	c9                   	leave
8010583f:	c3                   	ret
    end_op();
80105840:	e8 6b d7 ff ff       	call   80102fb0 <end_op>
    return -1;
80105845:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010584a:	c9                   	leave
8010584b:	c3                   	ret
8010584c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105850 <sys_mknod>:

int
sys_mknod(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105856:	e8 e5 d6 ff ff       	call   80102f40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010585b:	83 ec 08             	sub    $0x8,%esp
8010585e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105861:	50                   	push   %eax
80105862:	6a 00                	push   $0x0
80105864:	e8 77 f6 ff ff       	call   80104ee0 <argstr>
80105869:	83 c4 10             	add    $0x10,%esp
8010586c:	85 c0                	test   %eax,%eax
8010586e:	78 60                	js     801058d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105870:	83 ec 08             	sub    $0x8,%esp
80105873:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105876:	50                   	push   %eax
80105877:	6a 01                	push   $0x1
80105879:	e8 a2 f5 ff ff       	call   80104e20 <argint>
  if((argstr(0, &path)) < 0 ||
8010587e:	83 c4 10             	add    $0x10,%esp
80105881:	85 c0                	test   %eax,%eax
80105883:	78 4b                	js     801058d0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105885:	83 ec 08             	sub    $0x8,%esp
80105888:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010588b:	50                   	push   %eax
8010588c:	6a 02                	push   $0x2
8010588e:	e8 8d f5 ff ff       	call   80104e20 <argint>
     argint(1, &major) < 0 ||
80105893:	83 c4 10             	add    $0x10,%esp
80105896:	85 c0                	test   %eax,%eax
80105898:	78 36                	js     801058d0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010589a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010589e:	83 ec 0c             	sub    $0xc,%esp
801058a1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801058a5:	ba 03 00 00 00       	mov    $0x3,%edx
801058aa:	50                   	push   %eax
801058ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801058ae:	e8 1d f7 ff ff       	call   80104fd0 <create>
     argint(2, &minor) < 0 ||
801058b3:	83 c4 10             	add    $0x10,%esp
801058b6:	85 c0                	test   %eax,%eax
801058b8:	74 16                	je     801058d0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801058ba:	83 ec 0c             	sub    $0xc,%esp
801058bd:	50                   	push   %eax
801058be:	e8 5d c2 ff ff       	call   80101b20 <iunlockput>
  end_op();
801058c3:	e8 e8 d6 ff ff       	call   80102fb0 <end_op>
  return 0;
801058c8:	83 c4 10             	add    $0x10,%esp
801058cb:	31 c0                	xor    %eax,%eax
}
801058cd:	c9                   	leave
801058ce:	c3                   	ret
801058cf:	90                   	nop
    end_op();
801058d0:	e8 db d6 ff ff       	call   80102fb0 <end_op>
    return -1;
801058d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058da:	c9                   	leave
801058db:	c3                   	ret
801058dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058e0 <sys_chdir>:

int
sys_chdir(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	56                   	push   %esi
801058e4:	53                   	push   %ebx
801058e5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801058e8:	e8 63 e2 ff ff       	call   80103b50 <myproc>
801058ed:	89 c6                	mov    %eax,%esi
  
  begin_op();
801058ef:	e8 4c d6 ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801058f4:	83 ec 08             	sub    $0x8,%esp
801058f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058fa:	50                   	push   %eax
801058fb:	6a 00                	push   $0x0
801058fd:	e8 de f5 ff ff       	call   80104ee0 <argstr>
80105902:	83 c4 10             	add    $0x10,%esp
80105905:	85 c0                	test   %eax,%eax
80105907:	78 77                	js     80105980 <sys_chdir+0xa0>
80105909:	83 ec 0c             	sub    $0xc,%esp
8010590c:	ff 75 f4             	push   -0xc(%ebp)
8010590f:	e8 5c c8 ff ff       	call   80102170 <namei>
80105914:	83 c4 10             	add    $0x10,%esp
80105917:	89 c3                	mov    %eax,%ebx
80105919:	85 c0                	test   %eax,%eax
8010591b:	74 63                	je     80105980 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010591d:	83 ec 0c             	sub    $0xc,%esp
80105920:	50                   	push   %eax
80105921:	e8 6a bf ff ff       	call   80101890 <ilock>
  if(ip->type != T_DIR){
80105926:	83 c4 10             	add    $0x10,%esp
80105929:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010592e:	75 30                	jne    80105960 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105930:	83 ec 0c             	sub    $0xc,%esp
80105933:	53                   	push   %ebx
80105934:	e8 37 c0 ff ff       	call   80101970 <iunlock>
  iput(curproc->cwd);
80105939:	58                   	pop    %eax
8010593a:	ff 76 6c             	push   0x6c(%esi)
8010593d:	e8 7e c0 ff ff       	call   801019c0 <iput>
  end_op();
80105942:	e8 69 d6 ff ff       	call   80102fb0 <end_op>
  curproc->cwd = ip;
80105947:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
8010594a:	83 c4 10             	add    $0x10,%esp
8010594d:	31 c0                	xor    %eax,%eax
}
8010594f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105952:	5b                   	pop    %ebx
80105953:	5e                   	pop    %esi
80105954:	5d                   	pop    %ebp
80105955:	c3                   	ret
80105956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	53                   	push   %ebx
80105964:	e8 b7 c1 ff ff       	call   80101b20 <iunlockput>
    end_op();
80105969:	e8 42 d6 ff ff       	call   80102fb0 <end_op>
    return -1;
8010596e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105971:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105976:	eb d7                	jmp    8010594f <sys_chdir+0x6f>
80105978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010597f:	90                   	nop
    end_op();
80105980:	e8 2b d6 ff ff       	call   80102fb0 <end_op>
    return -1;
80105985:	eb ea                	jmp    80105971 <sys_chdir+0x91>
80105987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598e:	66 90                	xchg   %ax,%ax

80105990 <sys_exec>:

int
sys_exec(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	57                   	push   %edi
80105994:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105995:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010599b:	53                   	push   %ebx
8010599c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059a2:	50                   	push   %eax
801059a3:	6a 00                	push   $0x0
801059a5:	e8 36 f5 ff ff       	call   80104ee0 <argstr>
801059aa:	83 c4 10             	add    $0x10,%esp
801059ad:	85 c0                	test   %eax,%eax
801059af:	0f 88 87 00 00 00    	js     80105a3c <sys_exec+0xac>
801059b5:	83 ec 08             	sub    $0x8,%esp
801059b8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801059be:	50                   	push   %eax
801059bf:	6a 01                	push   $0x1
801059c1:	e8 5a f4 ff ff       	call   80104e20 <argint>
801059c6:	83 c4 10             	add    $0x10,%esp
801059c9:	85 c0                	test   %eax,%eax
801059cb:	78 6f                	js     80105a3c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801059cd:	83 ec 04             	sub    $0x4,%esp
801059d0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801059d6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801059d8:	68 80 00 00 00       	push   $0x80
801059dd:	6a 00                	push   $0x0
801059df:	56                   	push   %esi
801059e0:	e8 8b f1 ff ff       	call   80104b70 <memset>
801059e5:	83 c4 10             	add    $0x10,%esp
801059e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ef:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801059f0:	83 ec 08             	sub    $0x8,%esp
801059f3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801059f9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105a00:	50                   	push   %eax
80105a01:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a07:	01 f8                	add    %edi,%eax
80105a09:	50                   	push   %eax
80105a0a:	e8 81 f3 ff ff       	call   80104d90 <fetchint>
80105a0f:	83 c4 10             	add    $0x10,%esp
80105a12:	85 c0                	test   %eax,%eax
80105a14:	78 26                	js     80105a3c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105a16:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a1c:	85 c0                	test   %eax,%eax
80105a1e:	74 30                	je     80105a50 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105a20:	83 ec 08             	sub    $0x8,%esp
80105a23:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105a26:	52                   	push   %edx
80105a27:	50                   	push   %eax
80105a28:	e8 a3 f3 ff ff       	call   80104dd0 <fetchstr>
80105a2d:	83 c4 10             	add    $0x10,%esp
80105a30:	85 c0                	test   %eax,%eax
80105a32:	78 08                	js     80105a3c <sys_exec+0xac>
  for(i=0;; i++){
80105a34:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105a37:	83 fb 20             	cmp    $0x20,%ebx
80105a3a:	75 b4                	jne    801059f0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105a3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105a3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a44:	5b                   	pop    %ebx
80105a45:	5e                   	pop    %esi
80105a46:	5f                   	pop    %edi
80105a47:	5d                   	pop    %ebp
80105a48:	c3                   	ret
80105a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105a50:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105a57:	00 00 00 00 
  return exec(path, argv);
80105a5b:	83 ec 08             	sub    $0x8,%esp
80105a5e:	56                   	push   %esi
80105a5f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105a65:	e8 36 b1 ff ff       	call   80100ba0 <exec>
80105a6a:	83 c4 10             	add    $0x10,%esp
}
80105a6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a70:	5b                   	pop    %ebx
80105a71:	5e                   	pop    %esi
80105a72:	5f                   	pop    %edi
80105a73:	5d                   	pop    %ebp
80105a74:	c3                   	ret
80105a75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a80 <sys_pipe>:

int
sys_pipe(void)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	57                   	push   %edi
80105a84:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a85:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105a88:	53                   	push   %ebx
80105a89:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a8c:	6a 08                	push   $0x8
80105a8e:	50                   	push   %eax
80105a8f:	6a 00                	push   $0x0
80105a91:	e8 da f3 ff ff       	call   80104e70 <argptr>
80105a96:	83 c4 10             	add    $0x10,%esp
80105a99:	85 c0                	test   %eax,%eax
80105a9b:	0f 88 8b 00 00 00    	js     80105b2c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105aa1:	83 ec 08             	sub    $0x8,%esp
80105aa4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105aa7:	50                   	push   %eax
80105aa8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105aab:	50                   	push   %eax
80105aac:	e8 5f db ff ff       	call   80103610 <pipealloc>
80105ab1:	83 c4 10             	add    $0x10,%esp
80105ab4:	85 c0                	test   %eax,%eax
80105ab6:	78 74                	js     80105b2c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ab8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105abb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105abd:	e8 8e e0 ff ff       	call   80103b50 <myproc>
    if(curproc->ofile[fd] == 0){
80105ac2:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105ac6:	85 f6                	test   %esi,%esi
80105ac8:	74 16                	je     80105ae0 <sys_pipe+0x60>
80105aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105ad0:	83 c3 01             	add    $0x1,%ebx
80105ad3:	83 fb 10             	cmp    $0x10,%ebx
80105ad6:	74 3d                	je     80105b15 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105ad8:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105adc:	85 f6                	test   %esi,%esi
80105ade:	75 f0                	jne    80105ad0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105ae0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ae3:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ae7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105aea:	e8 61 e0 ff ff       	call   80103b50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105aef:	31 d2                	xor    %edx,%edx
80105af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105af8:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
80105afc:	85 c9                	test   %ecx,%ecx
80105afe:	74 38                	je     80105b38 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105b00:	83 c2 01             	add    $0x1,%edx
80105b03:	83 fa 10             	cmp    $0x10,%edx
80105b06:	75 f0                	jne    80105af8 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105b08:	e8 43 e0 ff ff       	call   80103b50 <myproc>
80105b0d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105b14:	00 
    fileclose(rf);
80105b15:	83 ec 0c             	sub    $0xc,%esp
80105b18:	ff 75 e0             	push   -0x20(%ebp)
80105b1b:	e8 e0 b4 ff ff       	call   80101000 <fileclose>
    fileclose(wf);
80105b20:	58                   	pop    %eax
80105b21:	ff 75 e4             	push   -0x1c(%ebp)
80105b24:	e8 d7 b4 ff ff       	call   80101000 <fileclose>
    return -1;
80105b29:	83 c4 10             	add    $0x10,%esp
    return -1;
80105b2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b31:	eb 16                	jmp    80105b49 <sys_pipe+0xc9>
80105b33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b37:	90                   	nop
      curproc->ofile[fd] = f;
80105b38:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  }
  fd[0] = fd0;
80105b3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b3f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105b41:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b44:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105b47:	31 c0                	xor    %eax,%eax
}
80105b49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b4c:	5b                   	pop    %ebx
80105b4d:	5e                   	pop    %esi
80105b4e:	5f                   	pop    %edi
80105b4f:	5d                   	pop    %ebp
80105b50:	c3                   	ret
80105b51:	66 90                	xchg   %ax,%ax
80105b53:	66 90                	xchg   %ax,%ax
80105b55:	66 90                	xchg   %ax,%ax
80105b57:	66 90                	xchg   %ax,%ax
80105b59:	66 90                	xchg   %ax,%ax
80105b5b:	66 90                	xchg   %ax,%ax
80105b5d:	66 90                	xchg   %ax,%ax
80105b5f:	90                   	nop

80105b60 <sys_getNumFreePages>:


int
sys_getNumFreePages(void)
{
  return num_of_FreePages();  
80105b60:	e9 4b cd ff ff       	jmp    801028b0 <num_of_FreePages>
80105b65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b70 <sys_getrss>:
}

int 
sys_getrss()
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	83 ec 08             	sub    $0x8,%esp
  print_rss();
80105b76:	e8 95 e2 ff ff       	call   80103e10 <print_rss>
  return 0;
}
80105b7b:	31 c0                	xor    %eax,%eax
80105b7d:	c9                   	leave
80105b7e:	c3                   	ret
80105b7f:	90                   	nop

80105b80 <sys_fork>:

int
sys_fork(void)
{
  return fork();
80105b80:	e9 6b e1 ff ff       	jmp    80103cf0 <fork>
80105b85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b90 <sys_exit>:
}

int
sys_exit(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b96:	e8 45 e4 ff ff       	call   80103fe0 <exit>
  return 0;  // not reached
}
80105b9b:	31 c0                	xor    %eax,%eax
80105b9d:	c9                   	leave
80105b9e:	c3                   	ret
80105b9f:	90                   	nop

80105ba0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105ba0:	e9 6b e5 ff ff       	jmp    80104110 <wait>
80105ba5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bb0 <sys_kill>:
}

int
sys_kill(void)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105bb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bb9:	50                   	push   %eax
80105bba:	6a 00                	push   $0x0
80105bbc:	e8 5f f2 ff ff       	call   80104e20 <argint>
80105bc1:	83 c4 10             	add    $0x10,%esp
80105bc4:	85 c0                	test   %eax,%eax
80105bc6:	78 18                	js     80105be0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105bc8:	83 ec 0c             	sub    $0xc,%esp
80105bcb:	ff 75 f4             	push   -0xc(%ebp)
80105bce:	e8 ed e7 ff ff       	call   801043c0 <kill>
80105bd3:	83 c4 10             	add    $0x10,%esp
}
80105bd6:	c9                   	leave
80105bd7:	c3                   	ret
80105bd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bdf:	90                   	nop
80105be0:	c9                   	leave
    return -1;
80105be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105be6:	c3                   	ret
80105be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bee:	66 90                	xchg   %ax,%ax

80105bf0 <sys_getpid>:

int
sys_getpid(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105bf6:	e8 55 df ff ff       	call   80103b50 <myproc>
80105bfb:	8b 40 14             	mov    0x14(%eax),%eax
}
80105bfe:	c9                   	leave
80105bff:	c3                   	ret

80105c00 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c04:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c07:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c0a:	50                   	push   %eax
80105c0b:	6a 00                	push   $0x0
80105c0d:	e8 0e f2 ff ff       	call   80104e20 <argint>
80105c12:	83 c4 10             	add    $0x10,%esp
80105c15:	85 c0                	test   %eax,%eax
80105c17:	78 27                	js     80105c40 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c19:	e8 32 df ff ff       	call   80103b50 <myproc>
  if(growproc(n) < 0)
80105c1e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105c21:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c23:	ff 75 f4             	push   -0xc(%ebp)
80105c26:	e8 45 e0 ff ff       	call   80103c70 <growproc>
80105c2b:	83 c4 10             	add    $0x10,%esp
80105c2e:	85 c0                	test   %eax,%eax
80105c30:	78 0e                	js     80105c40 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105c32:	89 d8                	mov    %ebx,%eax
80105c34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c37:	c9                   	leave
80105c38:	c3                   	ret
80105c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c40:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c45:	eb eb                	jmp    80105c32 <sys_sbrk+0x32>
80105c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4e:	66 90                	xchg   %ax,%ax

80105c50 <sys_sleep>:

int
sys_sleep(void)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c54:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c57:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c5a:	50                   	push   %eax
80105c5b:	6a 00                	push   $0x0
80105c5d:	e8 be f1 ff ff       	call   80104e20 <argint>
80105c62:	83 c4 10             	add    $0x10,%esp
80105c65:	85 c0                	test   %eax,%eax
80105c67:	78 64                	js     80105ccd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105c69:	83 ec 0c             	sub    $0xc,%esp
80105c6c:	68 e0 58 11 80       	push   $0x801158e0
80105c71:	e8 fa ed ff ff       	call   80104a70 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105c79:	8b 1d c0 58 11 80    	mov    0x801158c0,%ebx
  while(ticks - ticks0 < n){
80105c7f:	83 c4 10             	add    $0x10,%esp
80105c82:	85 d2                	test   %edx,%edx
80105c84:	75 2b                	jne    80105cb1 <sys_sleep+0x61>
80105c86:	eb 58                	jmp    80105ce0 <sys_sleep+0x90>
80105c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c8f:	90                   	nop
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105c90:	83 ec 08             	sub    $0x8,%esp
80105c93:	68 e0 58 11 80       	push   $0x801158e0
80105c98:	68 c0 58 11 80       	push   $0x801158c0
80105c9d:	e8 fe e5 ff ff       	call   801042a0 <sleep>
  while(ticks - ticks0 < n){
80105ca2:	a1 c0 58 11 80       	mov    0x801158c0,%eax
80105ca7:	83 c4 10             	add    $0x10,%esp
80105caa:	29 d8                	sub    %ebx,%eax
80105cac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105caf:	73 2f                	jae    80105ce0 <sys_sleep+0x90>
    if(myproc()->killed){
80105cb1:	e8 9a de ff ff       	call   80103b50 <myproc>
80105cb6:	8b 40 28             	mov    0x28(%eax),%eax
80105cb9:	85 c0                	test   %eax,%eax
80105cbb:	74 d3                	je     80105c90 <sys_sleep+0x40>
      release(&tickslock);
80105cbd:	83 ec 0c             	sub    $0xc,%esp
80105cc0:	68 e0 58 11 80       	push   $0x801158e0
80105cc5:	e8 46 ed ff ff       	call   80104a10 <release>
      return -1;
80105cca:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80105ccd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cd5:	c9                   	leave
80105cd6:	c3                   	ret
80105cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cde:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105ce0:	83 ec 0c             	sub    $0xc,%esp
80105ce3:	68 e0 58 11 80       	push   $0x801158e0
80105ce8:	e8 23 ed ff ff       	call   80104a10 <release>
}
80105ced:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105cf0:	83 c4 10             	add    $0x10,%esp
80105cf3:	31 c0                	xor    %eax,%eax
}
80105cf5:	c9                   	leave
80105cf6:	c3                   	ret
80105cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cfe:	66 90                	xchg   %ax,%ax

80105d00 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	53                   	push   %ebx
80105d04:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d07:	68 e0 58 11 80       	push   $0x801158e0
80105d0c:	e8 5f ed ff ff       	call   80104a70 <acquire>
  xticks = ticks;
80105d11:	8b 1d c0 58 11 80    	mov    0x801158c0,%ebx
  release(&tickslock);
80105d17:	c7 04 24 e0 58 11 80 	movl   $0x801158e0,(%esp)
80105d1e:	e8 ed ec ff ff       	call   80104a10 <release>
  return xticks;
}
80105d23:	89 d8                	mov    %ebx,%eax
80105d25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d28:	c9                   	leave
80105d29:	c3                   	ret

80105d2a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d2a:	1e                   	push   %ds
  pushl %es
80105d2b:	06                   	push   %es
  pushl %fs
80105d2c:	0f a0                	push   %fs
  pushl %gs
80105d2e:	0f a8                	push   %gs
  pushal
80105d30:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d31:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d35:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d37:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d39:	54                   	push   %esp
  call trap
80105d3a:	e8 c1 00 00 00       	call   80105e00 <trap>
  addl $4, %esp
80105d3f:	83 c4 04             	add    $0x4,%esp

80105d42 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d42:	61                   	popa
  popl %gs
80105d43:	0f a9                	pop    %gs
  popl %fs
80105d45:	0f a1                	pop    %fs
  popl %es
80105d47:	07                   	pop    %es
  popl %ds
80105d48:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d49:	83 c4 08             	add    $0x8,%esp
  iret
80105d4c:	cf                   	iret
80105d4d:	66 90                	xchg   %ax,%ax
80105d4f:	90                   	nop

80105d50 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d50:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105d51:	31 c0                	xor    %eax,%eax
{
80105d53:	89 e5                	mov    %esp,%ebp
80105d55:	83 ec 08             	sub    $0x8,%esp
80105d58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d5f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d60:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105d67:	c7 04 c5 22 59 11 80 	movl   $0x8e000008,-0x7feea6de(,%eax,8)
80105d6e:	08 00 00 8e 
80105d72:	66 89 14 c5 20 59 11 	mov    %dx,-0x7feea6e0(,%eax,8)
80105d79:	80 
80105d7a:	c1 ea 10             	shr    $0x10,%edx
80105d7d:	66 89 14 c5 26 59 11 	mov    %dx,-0x7feea6da(,%eax,8)
80105d84:	80 
  for(i = 0; i < 256; i++)
80105d85:	83 c0 01             	add    $0x1,%eax
80105d88:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d8d:	75 d1                	jne    80105d60 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105d8f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d92:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105d97:	c7 05 22 5b 11 80 08 	movl   $0xef000008,0x80115b22
80105d9e:	00 00 ef 
  initlock(&tickslock, "time");
80105da1:	68 c1 85 10 80       	push   $0x801085c1
80105da6:	68 e0 58 11 80       	push   $0x801158e0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105dab:	66 a3 20 5b 11 80    	mov    %ax,0x80115b20
80105db1:	c1 e8 10             	shr    $0x10,%eax
80105db4:	66 a3 26 5b 11 80    	mov    %ax,0x80115b26
  initlock(&tickslock, "time");
80105dba:	e8 c1 ea ff ff       	call   80104880 <initlock>
}
80105dbf:	83 c4 10             	add    $0x10,%esp
80105dc2:	c9                   	leave
80105dc3:	c3                   	ret
80105dc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dcf:	90                   	nop

80105dd0 <idtinit>:

void
idtinit(void)
{
80105dd0:	55                   	push   %ebp
  pd[0] = size-1;
80105dd1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105dd6:	89 e5                	mov    %esp,%ebp
80105dd8:	83 ec 10             	sub    $0x10,%esp
80105ddb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105ddf:	b8 20 59 11 80       	mov    $0x80115920,%eax
80105de4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105de8:	c1 e8 10             	shr    $0x10,%eax
80105deb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105def:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105df2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105df5:	c9                   	leave
80105df6:	c3                   	ret
80105df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dfe:	66 90                	xchg   %ax,%ax

80105e00 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	57                   	push   %edi
80105e04:	56                   	push   %esi
80105e05:	53                   	push   %ebx
80105e06:	83 ec 1c             	sub    $0x1c,%esp
80105e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105e0c:	8b 43 30             	mov    0x30(%ebx),%eax
80105e0f:	83 f8 40             	cmp    $0x40,%eax
80105e12:	0f 84 30 01 00 00    	je     80105f48 <trap+0x148>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105e18:	83 e8 0e             	sub    $0xe,%eax
80105e1b:	83 f8 31             	cmp    $0x31,%eax
80105e1e:	0f 87 8c 00 00 00    	ja     80105eb0 <trap+0xb0>
80105e24:	ff 24 85 40 8c 10 80 	jmp    *-0x7fef73c0(,%eax,4)
80105e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e2f:	90                   	nop
    // panic("wohooo\n");
    handle_page_fault();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105e30:	e8 fb dc ff ff       	call   80103b30 <cpuid>
80105e35:	85 c0                	test   %eax,%eax
80105e37:	0f 84 13 02 00 00    	je     80106050 <trap+0x250>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105e3d:	e8 ae cc ff ff       	call   80102af0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e42:	e8 09 dd ff ff       	call   80103b50 <myproc>
80105e47:	85 c0                	test   %eax,%eax
80105e49:	74 1a                	je     80105e65 <trap+0x65>
80105e4b:	e8 00 dd ff ff       	call   80103b50 <myproc>
80105e50:	8b 50 28             	mov    0x28(%eax),%edx
80105e53:	85 d2                	test   %edx,%edx
80105e55:	74 0e                	je     80105e65 <trap+0x65>
80105e57:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e5b:	f7 d0                	not    %eax
80105e5d:	a8 03                	test   $0x3,%al
80105e5f:	0f 84 cb 01 00 00    	je     80106030 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105e65:	e8 e6 dc ff ff       	call   80103b50 <myproc>
80105e6a:	85 c0                	test   %eax,%eax
80105e6c:	74 0f                	je     80105e7d <trap+0x7d>
80105e6e:	e8 dd dc ff ff       	call   80103b50 <myproc>
80105e73:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80105e77:	0f 84 b3 00 00 00    	je     80105f30 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e7d:	e8 ce dc ff ff       	call   80103b50 <myproc>
80105e82:	85 c0                	test   %eax,%eax
80105e84:	74 1a                	je     80105ea0 <trap+0xa0>
80105e86:	e8 c5 dc ff ff       	call   80103b50 <myproc>
80105e8b:	8b 40 28             	mov    0x28(%eax),%eax
80105e8e:	85 c0                	test   %eax,%eax
80105e90:	74 0e                	je     80105ea0 <trap+0xa0>
80105e92:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e96:	f7 d0                	not    %eax
80105e98:	a8 03                	test   $0x3,%al
80105e9a:	0f 84 d5 00 00 00    	je     80105f75 <trap+0x175>
    exit();
}
80105ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea3:	5b                   	pop    %ebx
80105ea4:	5e                   	pop    %esi
80105ea5:	5f                   	pop    %edi
80105ea6:	5d                   	pop    %ebp
80105ea7:	c3                   	ret
80105ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eaf:	90                   	nop
    if(myproc() == 0 || (tf->cs&3) == 0){
80105eb0:	e8 9b dc ff ff       	call   80103b50 <myproc>
80105eb5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105eb8:	85 c0                	test   %eax,%eax
80105eba:	0f 84 c4 01 00 00    	je     80106084 <trap+0x284>
80105ec0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105ec4:	0f 84 ba 01 00 00    	je     80106084 <trap+0x284>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105eca:	0f 20 d1             	mov    %cr2,%ecx
80105ecd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ed0:	e8 5b dc ff ff       	call   80103b30 <cpuid>
80105ed5:	8b 73 30             	mov    0x30(%ebx),%esi
80105ed8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105edb:	8b 43 34             	mov    0x34(%ebx),%eax
80105ede:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105ee1:	e8 6a dc ff ff       	call   80103b50 <myproc>
80105ee6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ee9:	e8 62 dc ff ff       	call   80103b50 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105eee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ef1:	51                   	push   %ecx
80105ef2:	57                   	push   %edi
80105ef3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ef6:	52                   	push   %edx
80105ef7:	ff 75 e4             	push   -0x1c(%ebp)
80105efa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105efb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105efe:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f01:	56                   	push   %esi
80105f02:	ff 70 14             	push   0x14(%eax)
80105f05:	68 e4 88 10 80       	push   $0x801088e4
80105f0a:	e8 91 a8 ff ff       	call   801007a0 <cprintf>
    myproc()->killed = 1;
80105f0f:	83 c4 20             	add    $0x20,%esp
80105f12:	e8 39 dc ff ff       	call   80103b50 <myproc>
80105f17:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f1e:	e8 2d dc ff ff       	call   80103b50 <myproc>
80105f23:	85 c0                	test   %eax,%eax
80105f25:	0f 85 20 ff ff ff    	jne    80105e4b <trap+0x4b>
80105f2b:	e9 35 ff ff ff       	jmp    80105e65 <trap+0x65>
  if(myproc() && myproc()->state == RUNNING &&
80105f30:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105f34:	0f 85 43 ff ff ff    	jne    80105e7d <trap+0x7d>
    yield();
80105f3a:	e8 11 e3 ff ff       	call   80104250 <yield>
80105f3f:	e9 39 ff ff ff       	jmp    80105e7d <trap+0x7d>
80105f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105f48:	e8 03 dc ff ff       	call   80103b50 <myproc>
80105f4d:	8b 70 28             	mov    0x28(%eax),%esi
80105f50:	85 f6                	test   %esi,%esi
80105f52:	0f 85 e8 00 00 00    	jne    80106040 <trap+0x240>
    myproc()->tf = tf;
80105f58:	e8 f3 db ff ff       	call   80103b50 <myproc>
80105f5d:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80105f60:	e8 fb ef ff ff       	call   80104f60 <syscall>
    if(myproc()->killed)
80105f65:	e8 e6 db ff ff       	call   80103b50 <myproc>
80105f6a:	8b 48 28             	mov    0x28(%eax),%ecx
80105f6d:	85 c9                	test   %ecx,%ecx
80105f6f:	0f 84 2b ff ff ff    	je     80105ea0 <trap+0xa0>
}
80105f75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f78:	5b                   	pop    %ebx
80105f79:	5e                   	pop    %esi
80105f7a:	5f                   	pop    %edi
80105f7b:	5d                   	pop    %ebp
      exit();
80105f7c:	e9 5f e0 ff ff       	jmp    80103fe0 <exit>
80105f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f88:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f8b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105f8f:	e8 9c db ff ff       	call   80103b30 <cpuid>
80105f94:	57                   	push   %edi
80105f95:	56                   	push   %esi
80105f96:	50                   	push   %eax
80105f97:	68 8c 88 10 80       	push   $0x8010888c
80105f9c:	e8 ff a7 ff ff       	call   801007a0 <cprintf>
    lapiceoi();
80105fa1:	e8 4a cb ff ff       	call   80102af0 <lapiceoi>
    break;
80105fa6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fa9:	e8 a2 db ff ff       	call   80103b50 <myproc>
80105fae:	85 c0                	test   %eax,%eax
80105fb0:	0f 85 95 fe ff ff    	jne    80105e4b <trap+0x4b>
80105fb6:	e9 aa fe ff ff       	jmp    80105e65 <trap+0x65>
80105fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fbf:	90                   	nop
    kbdintr();
80105fc0:	e8 fb c9 ff ff       	call   801029c0 <kbdintr>
    lapiceoi();
80105fc5:	e8 26 cb ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fca:	e8 81 db ff ff       	call   80103b50 <myproc>
80105fcf:	85 c0                	test   %eax,%eax
80105fd1:	0f 85 74 fe ff ff    	jne    80105e4b <trap+0x4b>
80105fd7:	e9 89 fe ff ff       	jmp    80105e65 <trap+0x65>
80105fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105fe0:	e8 4b 02 00 00       	call   80106230 <uartintr>
    lapiceoi();
80105fe5:	e8 06 cb ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fea:	e8 61 db ff ff       	call   80103b50 <myproc>
80105fef:	85 c0                	test   %eax,%eax
80105ff1:	0f 85 54 fe ff ff    	jne    80105e4b <trap+0x4b>
80105ff7:	e9 69 fe ff ff       	jmp    80105e65 <trap+0x65>
80105ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106000:	e8 1b c3 ff ff       	call   80102320 <ideintr>
80106005:	e9 33 fe ff ff       	jmp    80105e3d <trap+0x3d>
8010600a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    handle_page_fault();
80106010:	e8 ab 1f 00 00       	call   80107fc0 <handle_page_fault>
    lapiceoi();
80106015:	e8 d6 ca ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010601a:	e8 31 db ff ff       	call   80103b50 <myproc>
8010601f:	85 c0                	test   %eax,%eax
80106021:	0f 85 24 fe ff ff    	jne    80105e4b <trap+0x4b>
80106027:	e9 39 fe ff ff       	jmp    80105e65 <trap+0x65>
8010602c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106030:	e8 ab df ff ff       	call   80103fe0 <exit>
80106035:	e9 2b fe ff ff       	jmp    80105e65 <trap+0x65>
8010603a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106040:	e8 9b df ff ff       	call   80103fe0 <exit>
80106045:	e9 0e ff ff ff       	jmp    80105f58 <trap+0x158>
8010604a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106050:	83 ec 0c             	sub    $0xc,%esp
80106053:	68 e0 58 11 80       	push   $0x801158e0
80106058:	e8 13 ea ff ff       	call   80104a70 <acquire>
      ticks++;
8010605d:	83 05 c0 58 11 80 01 	addl   $0x1,0x801158c0
      wakeup(&ticks);
80106064:	c7 04 24 c0 58 11 80 	movl   $0x801158c0,(%esp)
8010606b:	e8 f0 e2 ff ff       	call   80104360 <wakeup>
      release(&tickslock);
80106070:	c7 04 24 e0 58 11 80 	movl   $0x801158e0,(%esp)
80106077:	e8 94 e9 ff ff       	call   80104a10 <release>
8010607c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010607f:	e9 b9 fd ff ff       	jmp    80105e3d <trap+0x3d>
80106084:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106087:	e8 a4 da ff ff       	call   80103b30 <cpuid>
8010608c:	83 ec 0c             	sub    $0xc,%esp
8010608f:	56                   	push   %esi
80106090:	57                   	push   %edi
80106091:	50                   	push   %eax
80106092:	ff 73 30             	push   0x30(%ebx)
80106095:	68 b0 88 10 80       	push   $0x801088b0
8010609a:	e8 01 a7 ff ff       	call   801007a0 <cprintf>
      panic("trap");
8010609f:	83 c4 14             	add    $0x14,%esp
801060a2:	68 c6 85 10 80       	push   $0x801085c6
801060a7:	e8 c4 a3 ff ff       	call   80100470 <panic>
801060ac:	66 90                	xchg   %ax,%ax
801060ae:	66 90                	xchg   %ax,%ax

801060b0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801060b0:	a1 20 61 11 80       	mov    0x80116120,%eax
801060b5:	85 c0                	test   %eax,%eax
801060b7:	74 17                	je     801060d0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060b9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060be:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801060bf:	a8 01                	test   $0x1,%al
801060c1:	74 0d                	je     801060d0 <uartgetc+0x20>
801060c3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060c8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801060c9:	0f b6 c0             	movzbl %al,%eax
801060cc:	c3                   	ret
801060cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801060d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060d5:	c3                   	ret
801060d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060dd:	8d 76 00             	lea    0x0(%esi),%esi

801060e0 <uartinit>:
{
801060e0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060e1:	31 c9                	xor    %ecx,%ecx
801060e3:	89 c8                	mov    %ecx,%eax
801060e5:	89 e5                	mov    %esp,%ebp
801060e7:	57                   	push   %edi
801060e8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801060ed:	56                   	push   %esi
801060ee:	89 fa                	mov    %edi,%edx
801060f0:	53                   	push   %ebx
801060f1:	83 ec 1c             	sub    $0x1c,%esp
801060f4:	ee                   	out    %al,(%dx)
801060f5:	be fb 03 00 00       	mov    $0x3fb,%esi
801060fa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801060ff:	89 f2                	mov    %esi,%edx
80106101:	ee                   	out    %al,(%dx)
80106102:	b8 0c 00 00 00       	mov    $0xc,%eax
80106107:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010610c:	ee                   	out    %al,(%dx)
8010610d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106112:	89 c8                	mov    %ecx,%eax
80106114:	89 da                	mov    %ebx,%edx
80106116:	ee                   	out    %al,(%dx)
80106117:	b8 03 00 00 00       	mov    $0x3,%eax
8010611c:	89 f2                	mov    %esi,%edx
8010611e:	ee                   	out    %al,(%dx)
8010611f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106124:	89 c8                	mov    %ecx,%eax
80106126:	ee                   	out    %al,(%dx)
80106127:	b8 01 00 00 00       	mov    $0x1,%eax
8010612c:	89 da                	mov    %ebx,%edx
8010612e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010612f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106134:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106135:	3c ff                	cmp    $0xff,%al
80106137:	0f 84 7c 00 00 00    	je     801061b9 <uartinit+0xd9>
  uart = 1;
8010613d:	c7 05 20 61 11 80 01 	movl   $0x1,0x80116120
80106144:	00 00 00 
80106147:	89 fa                	mov    %edi,%edx
80106149:	ec                   	in     (%dx),%al
8010614a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010614f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106150:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106153:	bf cb 85 10 80       	mov    $0x801085cb,%edi
80106158:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
8010615d:	6a 00                	push   $0x0
8010615f:	6a 04                	push   $0x4
80106161:	e8 ea c3 ff ff       	call   80102550 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106166:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
8010616a:	83 c4 10             	add    $0x10,%esp
8010616d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80106170:	a1 20 61 11 80       	mov    0x80116120,%eax
80106175:	85 c0                	test   %eax,%eax
80106177:	74 32                	je     801061ab <uartinit+0xcb>
80106179:	89 f2                	mov    %esi,%edx
8010617b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010617c:	a8 20                	test   $0x20,%al
8010617e:	75 21                	jne    801061a1 <uartinit+0xc1>
80106180:	bb 80 00 00 00       	mov    $0x80,%ebx
80106185:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80106188:	83 ec 0c             	sub    $0xc,%esp
8010618b:	6a 0a                	push   $0xa
8010618d:	e8 7e c9 ff ff       	call   80102b10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106192:	83 c4 10             	add    $0x10,%esp
80106195:	83 eb 01             	sub    $0x1,%ebx
80106198:	74 07                	je     801061a1 <uartinit+0xc1>
8010619a:	89 f2                	mov    %esi,%edx
8010619c:	ec                   	in     (%dx),%al
8010619d:	a8 20                	test   $0x20,%al
8010619f:	74 e7                	je     80106188 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061a1:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061a6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801061aa:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801061ab:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801061af:	83 c7 01             	add    $0x1,%edi
801061b2:	88 45 e7             	mov    %al,-0x19(%ebp)
801061b5:	84 c0                	test   %al,%al
801061b7:	75 b7                	jne    80106170 <uartinit+0x90>
}
801061b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061bc:	5b                   	pop    %ebx
801061bd:	5e                   	pop    %esi
801061be:	5f                   	pop    %edi
801061bf:	5d                   	pop    %ebp
801061c0:	c3                   	ret
801061c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061cf:	90                   	nop

801061d0 <uartputc>:
  if(!uart)
801061d0:	a1 20 61 11 80       	mov    0x80116120,%eax
801061d5:	85 c0                	test   %eax,%eax
801061d7:	74 4f                	je     80106228 <uartputc+0x58>
{
801061d9:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061da:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061df:	89 e5                	mov    %esp,%ebp
801061e1:	56                   	push   %esi
801061e2:	53                   	push   %ebx
801061e3:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061e4:	a8 20                	test   $0x20,%al
801061e6:	75 29                	jne    80106211 <uartputc+0x41>
801061e8:	bb 80 00 00 00       	mov    $0x80,%ebx
801061ed:	be fd 03 00 00       	mov    $0x3fd,%esi
801061f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801061f8:	83 ec 0c             	sub    $0xc,%esp
801061fb:	6a 0a                	push   $0xa
801061fd:	e8 0e c9 ff ff       	call   80102b10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106202:	83 c4 10             	add    $0x10,%esp
80106205:	83 eb 01             	sub    $0x1,%ebx
80106208:	74 07                	je     80106211 <uartputc+0x41>
8010620a:	89 f2                	mov    %esi,%edx
8010620c:	ec                   	in     (%dx),%al
8010620d:	a8 20                	test   $0x20,%al
8010620f:	74 e7                	je     801061f8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106211:	8b 45 08             	mov    0x8(%ebp),%eax
80106214:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106219:	ee                   	out    %al,(%dx)
}
8010621a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010621d:	5b                   	pop    %ebx
8010621e:	5e                   	pop    %esi
8010621f:	5d                   	pop    %ebp
80106220:	c3                   	ret
80106221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106228:	c3                   	ret
80106229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106230 <uartintr>:

void
uartintr(void)
{
80106230:	55                   	push   %ebp
80106231:	89 e5                	mov    %esp,%ebp
80106233:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106236:	68 b0 60 10 80       	push   $0x801060b0
8010623b:	e8 50 a7 ff ff       	call   80100990 <consoleintr>
}
80106240:	83 c4 10             	add    $0x10,%esp
80106243:	c9                   	leave
80106244:	c3                   	ret

80106245 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106245:	6a 00                	push   $0x0
  pushl $0
80106247:	6a 00                	push   $0x0
  jmp alltraps
80106249:	e9 dc fa ff ff       	jmp    80105d2a <alltraps>

8010624e <vector1>:
.globl vector1
vector1:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $1
80106250:	6a 01                	push   $0x1
  jmp alltraps
80106252:	e9 d3 fa ff ff       	jmp    80105d2a <alltraps>

80106257 <vector2>:
.globl vector2
vector2:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $2
80106259:	6a 02                	push   $0x2
  jmp alltraps
8010625b:	e9 ca fa ff ff       	jmp    80105d2a <alltraps>

80106260 <vector3>:
.globl vector3
vector3:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $3
80106262:	6a 03                	push   $0x3
  jmp alltraps
80106264:	e9 c1 fa ff ff       	jmp    80105d2a <alltraps>

80106269 <vector4>:
.globl vector4
vector4:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $4
8010626b:	6a 04                	push   $0x4
  jmp alltraps
8010626d:	e9 b8 fa ff ff       	jmp    80105d2a <alltraps>

80106272 <vector5>:
.globl vector5
vector5:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $5
80106274:	6a 05                	push   $0x5
  jmp alltraps
80106276:	e9 af fa ff ff       	jmp    80105d2a <alltraps>

8010627b <vector6>:
.globl vector6
vector6:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $6
8010627d:	6a 06                	push   $0x6
  jmp alltraps
8010627f:	e9 a6 fa ff ff       	jmp    80105d2a <alltraps>

80106284 <vector7>:
.globl vector7
vector7:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $7
80106286:	6a 07                	push   $0x7
  jmp alltraps
80106288:	e9 9d fa ff ff       	jmp    80105d2a <alltraps>

8010628d <vector8>:
.globl vector8
vector8:
  pushl $8
8010628d:	6a 08                	push   $0x8
  jmp alltraps
8010628f:	e9 96 fa ff ff       	jmp    80105d2a <alltraps>

80106294 <vector9>:
.globl vector9
vector9:
  pushl $0
80106294:	6a 00                	push   $0x0
  pushl $9
80106296:	6a 09                	push   $0x9
  jmp alltraps
80106298:	e9 8d fa ff ff       	jmp    80105d2a <alltraps>

8010629d <vector10>:
.globl vector10
vector10:
  pushl $10
8010629d:	6a 0a                	push   $0xa
  jmp alltraps
8010629f:	e9 86 fa ff ff       	jmp    80105d2a <alltraps>

801062a4 <vector11>:
.globl vector11
vector11:
  pushl $11
801062a4:	6a 0b                	push   $0xb
  jmp alltraps
801062a6:	e9 7f fa ff ff       	jmp    80105d2a <alltraps>

801062ab <vector12>:
.globl vector12
vector12:
  pushl $12
801062ab:	6a 0c                	push   $0xc
  jmp alltraps
801062ad:	e9 78 fa ff ff       	jmp    80105d2a <alltraps>

801062b2 <vector13>:
.globl vector13
vector13:
  pushl $13
801062b2:	6a 0d                	push   $0xd
  jmp alltraps
801062b4:	e9 71 fa ff ff       	jmp    80105d2a <alltraps>

801062b9 <vector14>:
.globl vector14
vector14:
  pushl $14
801062b9:	6a 0e                	push   $0xe
  jmp alltraps
801062bb:	e9 6a fa ff ff       	jmp    80105d2a <alltraps>

801062c0 <vector15>:
.globl vector15
vector15:
  pushl $0
801062c0:	6a 00                	push   $0x0
  pushl $15
801062c2:	6a 0f                	push   $0xf
  jmp alltraps
801062c4:	e9 61 fa ff ff       	jmp    80105d2a <alltraps>

801062c9 <vector16>:
.globl vector16
vector16:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $16
801062cb:	6a 10                	push   $0x10
  jmp alltraps
801062cd:	e9 58 fa ff ff       	jmp    80105d2a <alltraps>

801062d2 <vector17>:
.globl vector17
vector17:
  pushl $17
801062d2:	6a 11                	push   $0x11
  jmp alltraps
801062d4:	e9 51 fa ff ff       	jmp    80105d2a <alltraps>

801062d9 <vector18>:
.globl vector18
vector18:
  pushl $0
801062d9:	6a 00                	push   $0x0
  pushl $18
801062db:	6a 12                	push   $0x12
  jmp alltraps
801062dd:	e9 48 fa ff ff       	jmp    80105d2a <alltraps>

801062e2 <vector19>:
.globl vector19
vector19:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $19
801062e4:	6a 13                	push   $0x13
  jmp alltraps
801062e6:	e9 3f fa ff ff       	jmp    80105d2a <alltraps>

801062eb <vector20>:
.globl vector20
vector20:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $20
801062ed:	6a 14                	push   $0x14
  jmp alltraps
801062ef:	e9 36 fa ff ff       	jmp    80105d2a <alltraps>

801062f4 <vector21>:
.globl vector21
vector21:
  pushl $0
801062f4:	6a 00                	push   $0x0
  pushl $21
801062f6:	6a 15                	push   $0x15
  jmp alltraps
801062f8:	e9 2d fa ff ff       	jmp    80105d2a <alltraps>

801062fd <vector22>:
.globl vector22
vector22:
  pushl $0
801062fd:	6a 00                	push   $0x0
  pushl $22
801062ff:	6a 16                	push   $0x16
  jmp alltraps
80106301:	e9 24 fa ff ff       	jmp    80105d2a <alltraps>

80106306 <vector23>:
.globl vector23
vector23:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $23
80106308:	6a 17                	push   $0x17
  jmp alltraps
8010630a:	e9 1b fa ff ff       	jmp    80105d2a <alltraps>

8010630f <vector24>:
.globl vector24
vector24:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $24
80106311:	6a 18                	push   $0x18
  jmp alltraps
80106313:	e9 12 fa ff ff       	jmp    80105d2a <alltraps>

80106318 <vector25>:
.globl vector25
vector25:
  pushl $0
80106318:	6a 00                	push   $0x0
  pushl $25
8010631a:	6a 19                	push   $0x19
  jmp alltraps
8010631c:	e9 09 fa ff ff       	jmp    80105d2a <alltraps>

80106321 <vector26>:
.globl vector26
vector26:
  pushl $0
80106321:	6a 00                	push   $0x0
  pushl $26
80106323:	6a 1a                	push   $0x1a
  jmp alltraps
80106325:	e9 00 fa ff ff       	jmp    80105d2a <alltraps>

8010632a <vector27>:
.globl vector27
vector27:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $27
8010632c:	6a 1b                	push   $0x1b
  jmp alltraps
8010632e:	e9 f7 f9 ff ff       	jmp    80105d2a <alltraps>

80106333 <vector28>:
.globl vector28
vector28:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $28
80106335:	6a 1c                	push   $0x1c
  jmp alltraps
80106337:	e9 ee f9 ff ff       	jmp    80105d2a <alltraps>

8010633c <vector29>:
.globl vector29
vector29:
  pushl $0
8010633c:	6a 00                	push   $0x0
  pushl $29
8010633e:	6a 1d                	push   $0x1d
  jmp alltraps
80106340:	e9 e5 f9 ff ff       	jmp    80105d2a <alltraps>

80106345 <vector30>:
.globl vector30
vector30:
  pushl $0
80106345:	6a 00                	push   $0x0
  pushl $30
80106347:	6a 1e                	push   $0x1e
  jmp alltraps
80106349:	e9 dc f9 ff ff       	jmp    80105d2a <alltraps>

8010634e <vector31>:
.globl vector31
vector31:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $31
80106350:	6a 1f                	push   $0x1f
  jmp alltraps
80106352:	e9 d3 f9 ff ff       	jmp    80105d2a <alltraps>

80106357 <vector32>:
.globl vector32
vector32:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $32
80106359:	6a 20                	push   $0x20
  jmp alltraps
8010635b:	e9 ca f9 ff ff       	jmp    80105d2a <alltraps>

80106360 <vector33>:
.globl vector33
vector33:
  pushl $0
80106360:	6a 00                	push   $0x0
  pushl $33
80106362:	6a 21                	push   $0x21
  jmp alltraps
80106364:	e9 c1 f9 ff ff       	jmp    80105d2a <alltraps>

80106369 <vector34>:
.globl vector34
vector34:
  pushl $0
80106369:	6a 00                	push   $0x0
  pushl $34
8010636b:	6a 22                	push   $0x22
  jmp alltraps
8010636d:	e9 b8 f9 ff ff       	jmp    80105d2a <alltraps>

80106372 <vector35>:
.globl vector35
vector35:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $35
80106374:	6a 23                	push   $0x23
  jmp alltraps
80106376:	e9 af f9 ff ff       	jmp    80105d2a <alltraps>

8010637b <vector36>:
.globl vector36
vector36:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $36
8010637d:	6a 24                	push   $0x24
  jmp alltraps
8010637f:	e9 a6 f9 ff ff       	jmp    80105d2a <alltraps>

80106384 <vector37>:
.globl vector37
vector37:
  pushl $0
80106384:	6a 00                	push   $0x0
  pushl $37
80106386:	6a 25                	push   $0x25
  jmp alltraps
80106388:	e9 9d f9 ff ff       	jmp    80105d2a <alltraps>

8010638d <vector38>:
.globl vector38
vector38:
  pushl $0
8010638d:	6a 00                	push   $0x0
  pushl $38
8010638f:	6a 26                	push   $0x26
  jmp alltraps
80106391:	e9 94 f9 ff ff       	jmp    80105d2a <alltraps>

80106396 <vector39>:
.globl vector39
vector39:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $39
80106398:	6a 27                	push   $0x27
  jmp alltraps
8010639a:	e9 8b f9 ff ff       	jmp    80105d2a <alltraps>

8010639f <vector40>:
.globl vector40
vector40:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $40
801063a1:	6a 28                	push   $0x28
  jmp alltraps
801063a3:	e9 82 f9 ff ff       	jmp    80105d2a <alltraps>

801063a8 <vector41>:
.globl vector41
vector41:
  pushl $0
801063a8:	6a 00                	push   $0x0
  pushl $41
801063aa:	6a 29                	push   $0x29
  jmp alltraps
801063ac:	e9 79 f9 ff ff       	jmp    80105d2a <alltraps>

801063b1 <vector42>:
.globl vector42
vector42:
  pushl $0
801063b1:	6a 00                	push   $0x0
  pushl $42
801063b3:	6a 2a                	push   $0x2a
  jmp alltraps
801063b5:	e9 70 f9 ff ff       	jmp    80105d2a <alltraps>

801063ba <vector43>:
.globl vector43
vector43:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $43
801063bc:	6a 2b                	push   $0x2b
  jmp alltraps
801063be:	e9 67 f9 ff ff       	jmp    80105d2a <alltraps>

801063c3 <vector44>:
.globl vector44
vector44:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $44
801063c5:	6a 2c                	push   $0x2c
  jmp alltraps
801063c7:	e9 5e f9 ff ff       	jmp    80105d2a <alltraps>

801063cc <vector45>:
.globl vector45
vector45:
  pushl $0
801063cc:	6a 00                	push   $0x0
  pushl $45
801063ce:	6a 2d                	push   $0x2d
  jmp alltraps
801063d0:	e9 55 f9 ff ff       	jmp    80105d2a <alltraps>

801063d5 <vector46>:
.globl vector46
vector46:
  pushl $0
801063d5:	6a 00                	push   $0x0
  pushl $46
801063d7:	6a 2e                	push   $0x2e
  jmp alltraps
801063d9:	e9 4c f9 ff ff       	jmp    80105d2a <alltraps>

801063de <vector47>:
.globl vector47
vector47:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $47
801063e0:	6a 2f                	push   $0x2f
  jmp alltraps
801063e2:	e9 43 f9 ff ff       	jmp    80105d2a <alltraps>

801063e7 <vector48>:
.globl vector48
vector48:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $48
801063e9:	6a 30                	push   $0x30
  jmp alltraps
801063eb:	e9 3a f9 ff ff       	jmp    80105d2a <alltraps>

801063f0 <vector49>:
.globl vector49
vector49:
  pushl $0
801063f0:	6a 00                	push   $0x0
  pushl $49
801063f2:	6a 31                	push   $0x31
  jmp alltraps
801063f4:	e9 31 f9 ff ff       	jmp    80105d2a <alltraps>

801063f9 <vector50>:
.globl vector50
vector50:
  pushl $0
801063f9:	6a 00                	push   $0x0
  pushl $50
801063fb:	6a 32                	push   $0x32
  jmp alltraps
801063fd:	e9 28 f9 ff ff       	jmp    80105d2a <alltraps>

80106402 <vector51>:
.globl vector51
vector51:
  pushl $0
80106402:	6a 00                	push   $0x0
  pushl $51
80106404:	6a 33                	push   $0x33
  jmp alltraps
80106406:	e9 1f f9 ff ff       	jmp    80105d2a <alltraps>

8010640b <vector52>:
.globl vector52
vector52:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $52
8010640d:	6a 34                	push   $0x34
  jmp alltraps
8010640f:	e9 16 f9 ff ff       	jmp    80105d2a <alltraps>

80106414 <vector53>:
.globl vector53
vector53:
  pushl $0
80106414:	6a 00                	push   $0x0
  pushl $53
80106416:	6a 35                	push   $0x35
  jmp alltraps
80106418:	e9 0d f9 ff ff       	jmp    80105d2a <alltraps>

8010641d <vector54>:
.globl vector54
vector54:
  pushl $0
8010641d:	6a 00                	push   $0x0
  pushl $54
8010641f:	6a 36                	push   $0x36
  jmp alltraps
80106421:	e9 04 f9 ff ff       	jmp    80105d2a <alltraps>

80106426 <vector55>:
.globl vector55
vector55:
  pushl $0
80106426:	6a 00                	push   $0x0
  pushl $55
80106428:	6a 37                	push   $0x37
  jmp alltraps
8010642a:	e9 fb f8 ff ff       	jmp    80105d2a <alltraps>

8010642f <vector56>:
.globl vector56
vector56:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $56
80106431:	6a 38                	push   $0x38
  jmp alltraps
80106433:	e9 f2 f8 ff ff       	jmp    80105d2a <alltraps>

80106438 <vector57>:
.globl vector57
vector57:
  pushl $0
80106438:	6a 00                	push   $0x0
  pushl $57
8010643a:	6a 39                	push   $0x39
  jmp alltraps
8010643c:	e9 e9 f8 ff ff       	jmp    80105d2a <alltraps>

80106441 <vector58>:
.globl vector58
vector58:
  pushl $0
80106441:	6a 00                	push   $0x0
  pushl $58
80106443:	6a 3a                	push   $0x3a
  jmp alltraps
80106445:	e9 e0 f8 ff ff       	jmp    80105d2a <alltraps>

8010644a <vector59>:
.globl vector59
vector59:
  pushl $0
8010644a:	6a 00                	push   $0x0
  pushl $59
8010644c:	6a 3b                	push   $0x3b
  jmp alltraps
8010644e:	e9 d7 f8 ff ff       	jmp    80105d2a <alltraps>

80106453 <vector60>:
.globl vector60
vector60:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $60
80106455:	6a 3c                	push   $0x3c
  jmp alltraps
80106457:	e9 ce f8 ff ff       	jmp    80105d2a <alltraps>

8010645c <vector61>:
.globl vector61
vector61:
  pushl $0
8010645c:	6a 00                	push   $0x0
  pushl $61
8010645e:	6a 3d                	push   $0x3d
  jmp alltraps
80106460:	e9 c5 f8 ff ff       	jmp    80105d2a <alltraps>

80106465 <vector62>:
.globl vector62
vector62:
  pushl $0
80106465:	6a 00                	push   $0x0
  pushl $62
80106467:	6a 3e                	push   $0x3e
  jmp alltraps
80106469:	e9 bc f8 ff ff       	jmp    80105d2a <alltraps>

8010646e <vector63>:
.globl vector63
vector63:
  pushl $0
8010646e:	6a 00                	push   $0x0
  pushl $63
80106470:	6a 3f                	push   $0x3f
  jmp alltraps
80106472:	e9 b3 f8 ff ff       	jmp    80105d2a <alltraps>

80106477 <vector64>:
.globl vector64
vector64:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $64
80106479:	6a 40                	push   $0x40
  jmp alltraps
8010647b:	e9 aa f8 ff ff       	jmp    80105d2a <alltraps>

80106480 <vector65>:
.globl vector65
vector65:
  pushl $0
80106480:	6a 00                	push   $0x0
  pushl $65
80106482:	6a 41                	push   $0x41
  jmp alltraps
80106484:	e9 a1 f8 ff ff       	jmp    80105d2a <alltraps>

80106489 <vector66>:
.globl vector66
vector66:
  pushl $0
80106489:	6a 00                	push   $0x0
  pushl $66
8010648b:	6a 42                	push   $0x42
  jmp alltraps
8010648d:	e9 98 f8 ff ff       	jmp    80105d2a <alltraps>

80106492 <vector67>:
.globl vector67
vector67:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $67
80106494:	6a 43                	push   $0x43
  jmp alltraps
80106496:	e9 8f f8 ff ff       	jmp    80105d2a <alltraps>

8010649b <vector68>:
.globl vector68
vector68:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $68
8010649d:	6a 44                	push   $0x44
  jmp alltraps
8010649f:	e9 86 f8 ff ff       	jmp    80105d2a <alltraps>

801064a4 <vector69>:
.globl vector69
vector69:
  pushl $0
801064a4:	6a 00                	push   $0x0
  pushl $69
801064a6:	6a 45                	push   $0x45
  jmp alltraps
801064a8:	e9 7d f8 ff ff       	jmp    80105d2a <alltraps>

801064ad <vector70>:
.globl vector70
vector70:
  pushl $0
801064ad:	6a 00                	push   $0x0
  pushl $70
801064af:	6a 46                	push   $0x46
  jmp alltraps
801064b1:	e9 74 f8 ff ff       	jmp    80105d2a <alltraps>

801064b6 <vector71>:
.globl vector71
vector71:
  pushl $0
801064b6:	6a 00                	push   $0x0
  pushl $71
801064b8:	6a 47                	push   $0x47
  jmp alltraps
801064ba:	e9 6b f8 ff ff       	jmp    80105d2a <alltraps>

801064bf <vector72>:
.globl vector72
vector72:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $72
801064c1:	6a 48                	push   $0x48
  jmp alltraps
801064c3:	e9 62 f8 ff ff       	jmp    80105d2a <alltraps>

801064c8 <vector73>:
.globl vector73
vector73:
  pushl $0
801064c8:	6a 00                	push   $0x0
  pushl $73
801064ca:	6a 49                	push   $0x49
  jmp alltraps
801064cc:	e9 59 f8 ff ff       	jmp    80105d2a <alltraps>

801064d1 <vector74>:
.globl vector74
vector74:
  pushl $0
801064d1:	6a 00                	push   $0x0
  pushl $74
801064d3:	6a 4a                	push   $0x4a
  jmp alltraps
801064d5:	e9 50 f8 ff ff       	jmp    80105d2a <alltraps>

801064da <vector75>:
.globl vector75
vector75:
  pushl $0
801064da:	6a 00                	push   $0x0
  pushl $75
801064dc:	6a 4b                	push   $0x4b
  jmp alltraps
801064de:	e9 47 f8 ff ff       	jmp    80105d2a <alltraps>

801064e3 <vector76>:
.globl vector76
vector76:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $76
801064e5:	6a 4c                	push   $0x4c
  jmp alltraps
801064e7:	e9 3e f8 ff ff       	jmp    80105d2a <alltraps>

801064ec <vector77>:
.globl vector77
vector77:
  pushl $0
801064ec:	6a 00                	push   $0x0
  pushl $77
801064ee:	6a 4d                	push   $0x4d
  jmp alltraps
801064f0:	e9 35 f8 ff ff       	jmp    80105d2a <alltraps>

801064f5 <vector78>:
.globl vector78
vector78:
  pushl $0
801064f5:	6a 00                	push   $0x0
  pushl $78
801064f7:	6a 4e                	push   $0x4e
  jmp alltraps
801064f9:	e9 2c f8 ff ff       	jmp    80105d2a <alltraps>

801064fe <vector79>:
.globl vector79
vector79:
  pushl $0
801064fe:	6a 00                	push   $0x0
  pushl $79
80106500:	6a 4f                	push   $0x4f
  jmp alltraps
80106502:	e9 23 f8 ff ff       	jmp    80105d2a <alltraps>

80106507 <vector80>:
.globl vector80
vector80:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $80
80106509:	6a 50                	push   $0x50
  jmp alltraps
8010650b:	e9 1a f8 ff ff       	jmp    80105d2a <alltraps>

80106510 <vector81>:
.globl vector81
vector81:
  pushl $0
80106510:	6a 00                	push   $0x0
  pushl $81
80106512:	6a 51                	push   $0x51
  jmp alltraps
80106514:	e9 11 f8 ff ff       	jmp    80105d2a <alltraps>

80106519 <vector82>:
.globl vector82
vector82:
  pushl $0
80106519:	6a 00                	push   $0x0
  pushl $82
8010651b:	6a 52                	push   $0x52
  jmp alltraps
8010651d:	e9 08 f8 ff ff       	jmp    80105d2a <alltraps>

80106522 <vector83>:
.globl vector83
vector83:
  pushl $0
80106522:	6a 00                	push   $0x0
  pushl $83
80106524:	6a 53                	push   $0x53
  jmp alltraps
80106526:	e9 ff f7 ff ff       	jmp    80105d2a <alltraps>

8010652b <vector84>:
.globl vector84
vector84:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $84
8010652d:	6a 54                	push   $0x54
  jmp alltraps
8010652f:	e9 f6 f7 ff ff       	jmp    80105d2a <alltraps>

80106534 <vector85>:
.globl vector85
vector85:
  pushl $0
80106534:	6a 00                	push   $0x0
  pushl $85
80106536:	6a 55                	push   $0x55
  jmp alltraps
80106538:	e9 ed f7 ff ff       	jmp    80105d2a <alltraps>

8010653d <vector86>:
.globl vector86
vector86:
  pushl $0
8010653d:	6a 00                	push   $0x0
  pushl $86
8010653f:	6a 56                	push   $0x56
  jmp alltraps
80106541:	e9 e4 f7 ff ff       	jmp    80105d2a <alltraps>

80106546 <vector87>:
.globl vector87
vector87:
  pushl $0
80106546:	6a 00                	push   $0x0
  pushl $87
80106548:	6a 57                	push   $0x57
  jmp alltraps
8010654a:	e9 db f7 ff ff       	jmp    80105d2a <alltraps>

8010654f <vector88>:
.globl vector88
vector88:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $88
80106551:	6a 58                	push   $0x58
  jmp alltraps
80106553:	e9 d2 f7 ff ff       	jmp    80105d2a <alltraps>

80106558 <vector89>:
.globl vector89
vector89:
  pushl $0
80106558:	6a 00                	push   $0x0
  pushl $89
8010655a:	6a 59                	push   $0x59
  jmp alltraps
8010655c:	e9 c9 f7 ff ff       	jmp    80105d2a <alltraps>

80106561 <vector90>:
.globl vector90
vector90:
  pushl $0
80106561:	6a 00                	push   $0x0
  pushl $90
80106563:	6a 5a                	push   $0x5a
  jmp alltraps
80106565:	e9 c0 f7 ff ff       	jmp    80105d2a <alltraps>

8010656a <vector91>:
.globl vector91
vector91:
  pushl $0
8010656a:	6a 00                	push   $0x0
  pushl $91
8010656c:	6a 5b                	push   $0x5b
  jmp alltraps
8010656e:	e9 b7 f7 ff ff       	jmp    80105d2a <alltraps>

80106573 <vector92>:
.globl vector92
vector92:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $92
80106575:	6a 5c                	push   $0x5c
  jmp alltraps
80106577:	e9 ae f7 ff ff       	jmp    80105d2a <alltraps>

8010657c <vector93>:
.globl vector93
vector93:
  pushl $0
8010657c:	6a 00                	push   $0x0
  pushl $93
8010657e:	6a 5d                	push   $0x5d
  jmp alltraps
80106580:	e9 a5 f7 ff ff       	jmp    80105d2a <alltraps>

80106585 <vector94>:
.globl vector94
vector94:
  pushl $0
80106585:	6a 00                	push   $0x0
  pushl $94
80106587:	6a 5e                	push   $0x5e
  jmp alltraps
80106589:	e9 9c f7 ff ff       	jmp    80105d2a <alltraps>

8010658e <vector95>:
.globl vector95
vector95:
  pushl $0
8010658e:	6a 00                	push   $0x0
  pushl $95
80106590:	6a 5f                	push   $0x5f
  jmp alltraps
80106592:	e9 93 f7 ff ff       	jmp    80105d2a <alltraps>

80106597 <vector96>:
.globl vector96
vector96:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $96
80106599:	6a 60                	push   $0x60
  jmp alltraps
8010659b:	e9 8a f7 ff ff       	jmp    80105d2a <alltraps>

801065a0 <vector97>:
.globl vector97
vector97:
  pushl $0
801065a0:	6a 00                	push   $0x0
  pushl $97
801065a2:	6a 61                	push   $0x61
  jmp alltraps
801065a4:	e9 81 f7 ff ff       	jmp    80105d2a <alltraps>

801065a9 <vector98>:
.globl vector98
vector98:
  pushl $0
801065a9:	6a 00                	push   $0x0
  pushl $98
801065ab:	6a 62                	push   $0x62
  jmp alltraps
801065ad:	e9 78 f7 ff ff       	jmp    80105d2a <alltraps>

801065b2 <vector99>:
.globl vector99
vector99:
  pushl $0
801065b2:	6a 00                	push   $0x0
  pushl $99
801065b4:	6a 63                	push   $0x63
  jmp alltraps
801065b6:	e9 6f f7 ff ff       	jmp    80105d2a <alltraps>

801065bb <vector100>:
.globl vector100
vector100:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $100
801065bd:	6a 64                	push   $0x64
  jmp alltraps
801065bf:	e9 66 f7 ff ff       	jmp    80105d2a <alltraps>

801065c4 <vector101>:
.globl vector101
vector101:
  pushl $0
801065c4:	6a 00                	push   $0x0
  pushl $101
801065c6:	6a 65                	push   $0x65
  jmp alltraps
801065c8:	e9 5d f7 ff ff       	jmp    80105d2a <alltraps>

801065cd <vector102>:
.globl vector102
vector102:
  pushl $0
801065cd:	6a 00                	push   $0x0
  pushl $102
801065cf:	6a 66                	push   $0x66
  jmp alltraps
801065d1:	e9 54 f7 ff ff       	jmp    80105d2a <alltraps>

801065d6 <vector103>:
.globl vector103
vector103:
  pushl $0
801065d6:	6a 00                	push   $0x0
  pushl $103
801065d8:	6a 67                	push   $0x67
  jmp alltraps
801065da:	e9 4b f7 ff ff       	jmp    80105d2a <alltraps>

801065df <vector104>:
.globl vector104
vector104:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $104
801065e1:	6a 68                	push   $0x68
  jmp alltraps
801065e3:	e9 42 f7 ff ff       	jmp    80105d2a <alltraps>

801065e8 <vector105>:
.globl vector105
vector105:
  pushl $0
801065e8:	6a 00                	push   $0x0
  pushl $105
801065ea:	6a 69                	push   $0x69
  jmp alltraps
801065ec:	e9 39 f7 ff ff       	jmp    80105d2a <alltraps>

801065f1 <vector106>:
.globl vector106
vector106:
  pushl $0
801065f1:	6a 00                	push   $0x0
  pushl $106
801065f3:	6a 6a                	push   $0x6a
  jmp alltraps
801065f5:	e9 30 f7 ff ff       	jmp    80105d2a <alltraps>

801065fa <vector107>:
.globl vector107
vector107:
  pushl $0
801065fa:	6a 00                	push   $0x0
  pushl $107
801065fc:	6a 6b                	push   $0x6b
  jmp alltraps
801065fe:	e9 27 f7 ff ff       	jmp    80105d2a <alltraps>

80106603 <vector108>:
.globl vector108
vector108:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $108
80106605:	6a 6c                	push   $0x6c
  jmp alltraps
80106607:	e9 1e f7 ff ff       	jmp    80105d2a <alltraps>

8010660c <vector109>:
.globl vector109
vector109:
  pushl $0
8010660c:	6a 00                	push   $0x0
  pushl $109
8010660e:	6a 6d                	push   $0x6d
  jmp alltraps
80106610:	e9 15 f7 ff ff       	jmp    80105d2a <alltraps>

80106615 <vector110>:
.globl vector110
vector110:
  pushl $0
80106615:	6a 00                	push   $0x0
  pushl $110
80106617:	6a 6e                	push   $0x6e
  jmp alltraps
80106619:	e9 0c f7 ff ff       	jmp    80105d2a <alltraps>

8010661e <vector111>:
.globl vector111
vector111:
  pushl $0
8010661e:	6a 00                	push   $0x0
  pushl $111
80106620:	6a 6f                	push   $0x6f
  jmp alltraps
80106622:	e9 03 f7 ff ff       	jmp    80105d2a <alltraps>

80106627 <vector112>:
.globl vector112
vector112:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $112
80106629:	6a 70                	push   $0x70
  jmp alltraps
8010662b:	e9 fa f6 ff ff       	jmp    80105d2a <alltraps>

80106630 <vector113>:
.globl vector113
vector113:
  pushl $0
80106630:	6a 00                	push   $0x0
  pushl $113
80106632:	6a 71                	push   $0x71
  jmp alltraps
80106634:	e9 f1 f6 ff ff       	jmp    80105d2a <alltraps>

80106639 <vector114>:
.globl vector114
vector114:
  pushl $0
80106639:	6a 00                	push   $0x0
  pushl $114
8010663b:	6a 72                	push   $0x72
  jmp alltraps
8010663d:	e9 e8 f6 ff ff       	jmp    80105d2a <alltraps>

80106642 <vector115>:
.globl vector115
vector115:
  pushl $0
80106642:	6a 00                	push   $0x0
  pushl $115
80106644:	6a 73                	push   $0x73
  jmp alltraps
80106646:	e9 df f6 ff ff       	jmp    80105d2a <alltraps>

8010664b <vector116>:
.globl vector116
vector116:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $116
8010664d:	6a 74                	push   $0x74
  jmp alltraps
8010664f:	e9 d6 f6 ff ff       	jmp    80105d2a <alltraps>

80106654 <vector117>:
.globl vector117
vector117:
  pushl $0
80106654:	6a 00                	push   $0x0
  pushl $117
80106656:	6a 75                	push   $0x75
  jmp alltraps
80106658:	e9 cd f6 ff ff       	jmp    80105d2a <alltraps>

8010665d <vector118>:
.globl vector118
vector118:
  pushl $0
8010665d:	6a 00                	push   $0x0
  pushl $118
8010665f:	6a 76                	push   $0x76
  jmp alltraps
80106661:	e9 c4 f6 ff ff       	jmp    80105d2a <alltraps>

80106666 <vector119>:
.globl vector119
vector119:
  pushl $0
80106666:	6a 00                	push   $0x0
  pushl $119
80106668:	6a 77                	push   $0x77
  jmp alltraps
8010666a:	e9 bb f6 ff ff       	jmp    80105d2a <alltraps>

8010666f <vector120>:
.globl vector120
vector120:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $120
80106671:	6a 78                	push   $0x78
  jmp alltraps
80106673:	e9 b2 f6 ff ff       	jmp    80105d2a <alltraps>

80106678 <vector121>:
.globl vector121
vector121:
  pushl $0
80106678:	6a 00                	push   $0x0
  pushl $121
8010667a:	6a 79                	push   $0x79
  jmp alltraps
8010667c:	e9 a9 f6 ff ff       	jmp    80105d2a <alltraps>

80106681 <vector122>:
.globl vector122
vector122:
  pushl $0
80106681:	6a 00                	push   $0x0
  pushl $122
80106683:	6a 7a                	push   $0x7a
  jmp alltraps
80106685:	e9 a0 f6 ff ff       	jmp    80105d2a <alltraps>

8010668a <vector123>:
.globl vector123
vector123:
  pushl $0
8010668a:	6a 00                	push   $0x0
  pushl $123
8010668c:	6a 7b                	push   $0x7b
  jmp alltraps
8010668e:	e9 97 f6 ff ff       	jmp    80105d2a <alltraps>

80106693 <vector124>:
.globl vector124
vector124:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $124
80106695:	6a 7c                	push   $0x7c
  jmp alltraps
80106697:	e9 8e f6 ff ff       	jmp    80105d2a <alltraps>

8010669c <vector125>:
.globl vector125
vector125:
  pushl $0
8010669c:	6a 00                	push   $0x0
  pushl $125
8010669e:	6a 7d                	push   $0x7d
  jmp alltraps
801066a0:	e9 85 f6 ff ff       	jmp    80105d2a <alltraps>

801066a5 <vector126>:
.globl vector126
vector126:
  pushl $0
801066a5:	6a 00                	push   $0x0
  pushl $126
801066a7:	6a 7e                	push   $0x7e
  jmp alltraps
801066a9:	e9 7c f6 ff ff       	jmp    80105d2a <alltraps>

801066ae <vector127>:
.globl vector127
vector127:
  pushl $0
801066ae:	6a 00                	push   $0x0
  pushl $127
801066b0:	6a 7f                	push   $0x7f
  jmp alltraps
801066b2:	e9 73 f6 ff ff       	jmp    80105d2a <alltraps>

801066b7 <vector128>:
.globl vector128
vector128:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $128
801066b9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801066be:	e9 67 f6 ff ff       	jmp    80105d2a <alltraps>

801066c3 <vector129>:
.globl vector129
vector129:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $129
801066c5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801066ca:	e9 5b f6 ff ff       	jmp    80105d2a <alltraps>

801066cf <vector130>:
.globl vector130
vector130:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $130
801066d1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801066d6:	e9 4f f6 ff ff       	jmp    80105d2a <alltraps>

801066db <vector131>:
.globl vector131
vector131:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $131
801066dd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801066e2:	e9 43 f6 ff ff       	jmp    80105d2a <alltraps>

801066e7 <vector132>:
.globl vector132
vector132:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $132
801066e9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801066ee:	e9 37 f6 ff ff       	jmp    80105d2a <alltraps>

801066f3 <vector133>:
.globl vector133
vector133:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $133
801066f5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801066fa:	e9 2b f6 ff ff       	jmp    80105d2a <alltraps>

801066ff <vector134>:
.globl vector134
vector134:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $134
80106701:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106706:	e9 1f f6 ff ff       	jmp    80105d2a <alltraps>

8010670b <vector135>:
.globl vector135
vector135:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $135
8010670d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106712:	e9 13 f6 ff ff       	jmp    80105d2a <alltraps>

80106717 <vector136>:
.globl vector136
vector136:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $136
80106719:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010671e:	e9 07 f6 ff ff       	jmp    80105d2a <alltraps>

80106723 <vector137>:
.globl vector137
vector137:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $137
80106725:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010672a:	e9 fb f5 ff ff       	jmp    80105d2a <alltraps>

8010672f <vector138>:
.globl vector138
vector138:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $138
80106731:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106736:	e9 ef f5 ff ff       	jmp    80105d2a <alltraps>

8010673b <vector139>:
.globl vector139
vector139:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $139
8010673d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106742:	e9 e3 f5 ff ff       	jmp    80105d2a <alltraps>

80106747 <vector140>:
.globl vector140
vector140:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $140
80106749:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010674e:	e9 d7 f5 ff ff       	jmp    80105d2a <alltraps>

80106753 <vector141>:
.globl vector141
vector141:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $141
80106755:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010675a:	e9 cb f5 ff ff       	jmp    80105d2a <alltraps>

8010675f <vector142>:
.globl vector142
vector142:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $142
80106761:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106766:	e9 bf f5 ff ff       	jmp    80105d2a <alltraps>

8010676b <vector143>:
.globl vector143
vector143:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $143
8010676d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106772:	e9 b3 f5 ff ff       	jmp    80105d2a <alltraps>

80106777 <vector144>:
.globl vector144
vector144:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $144
80106779:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010677e:	e9 a7 f5 ff ff       	jmp    80105d2a <alltraps>

80106783 <vector145>:
.globl vector145
vector145:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $145
80106785:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010678a:	e9 9b f5 ff ff       	jmp    80105d2a <alltraps>

8010678f <vector146>:
.globl vector146
vector146:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $146
80106791:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106796:	e9 8f f5 ff ff       	jmp    80105d2a <alltraps>

8010679b <vector147>:
.globl vector147
vector147:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $147
8010679d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801067a2:	e9 83 f5 ff ff       	jmp    80105d2a <alltraps>

801067a7 <vector148>:
.globl vector148
vector148:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $148
801067a9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801067ae:	e9 77 f5 ff ff       	jmp    80105d2a <alltraps>

801067b3 <vector149>:
.globl vector149
vector149:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $149
801067b5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801067ba:	e9 6b f5 ff ff       	jmp    80105d2a <alltraps>

801067bf <vector150>:
.globl vector150
vector150:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $150
801067c1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801067c6:	e9 5f f5 ff ff       	jmp    80105d2a <alltraps>

801067cb <vector151>:
.globl vector151
vector151:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $151
801067cd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801067d2:	e9 53 f5 ff ff       	jmp    80105d2a <alltraps>

801067d7 <vector152>:
.globl vector152
vector152:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $152
801067d9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801067de:	e9 47 f5 ff ff       	jmp    80105d2a <alltraps>

801067e3 <vector153>:
.globl vector153
vector153:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $153
801067e5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801067ea:	e9 3b f5 ff ff       	jmp    80105d2a <alltraps>

801067ef <vector154>:
.globl vector154
vector154:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $154
801067f1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801067f6:	e9 2f f5 ff ff       	jmp    80105d2a <alltraps>

801067fb <vector155>:
.globl vector155
vector155:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $155
801067fd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106802:	e9 23 f5 ff ff       	jmp    80105d2a <alltraps>

80106807 <vector156>:
.globl vector156
vector156:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $156
80106809:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010680e:	e9 17 f5 ff ff       	jmp    80105d2a <alltraps>

80106813 <vector157>:
.globl vector157
vector157:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $157
80106815:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010681a:	e9 0b f5 ff ff       	jmp    80105d2a <alltraps>

8010681f <vector158>:
.globl vector158
vector158:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $158
80106821:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106826:	e9 ff f4 ff ff       	jmp    80105d2a <alltraps>

8010682b <vector159>:
.globl vector159
vector159:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $159
8010682d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106832:	e9 f3 f4 ff ff       	jmp    80105d2a <alltraps>

80106837 <vector160>:
.globl vector160
vector160:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $160
80106839:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010683e:	e9 e7 f4 ff ff       	jmp    80105d2a <alltraps>

80106843 <vector161>:
.globl vector161
vector161:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $161
80106845:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010684a:	e9 db f4 ff ff       	jmp    80105d2a <alltraps>

8010684f <vector162>:
.globl vector162
vector162:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $162
80106851:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106856:	e9 cf f4 ff ff       	jmp    80105d2a <alltraps>

8010685b <vector163>:
.globl vector163
vector163:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $163
8010685d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106862:	e9 c3 f4 ff ff       	jmp    80105d2a <alltraps>

80106867 <vector164>:
.globl vector164
vector164:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $164
80106869:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010686e:	e9 b7 f4 ff ff       	jmp    80105d2a <alltraps>

80106873 <vector165>:
.globl vector165
vector165:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $165
80106875:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010687a:	e9 ab f4 ff ff       	jmp    80105d2a <alltraps>

8010687f <vector166>:
.globl vector166
vector166:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $166
80106881:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106886:	e9 9f f4 ff ff       	jmp    80105d2a <alltraps>

8010688b <vector167>:
.globl vector167
vector167:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $167
8010688d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106892:	e9 93 f4 ff ff       	jmp    80105d2a <alltraps>

80106897 <vector168>:
.globl vector168
vector168:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $168
80106899:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010689e:	e9 87 f4 ff ff       	jmp    80105d2a <alltraps>

801068a3 <vector169>:
.globl vector169
vector169:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $169
801068a5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801068aa:	e9 7b f4 ff ff       	jmp    80105d2a <alltraps>

801068af <vector170>:
.globl vector170
vector170:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $170
801068b1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801068b6:	e9 6f f4 ff ff       	jmp    80105d2a <alltraps>

801068bb <vector171>:
.globl vector171
vector171:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $171
801068bd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801068c2:	e9 63 f4 ff ff       	jmp    80105d2a <alltraps>

801068c7 <vector172>:
.globl vector172
vector172:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $172
801068c9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801068ce:	e9 57 f4 ff ff       	jmp    80105d2a <alltraps>

801068d3 <vector173>:
.globl vector173
vector173:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $173
801068d5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801068da:	e9 4b f4 ff ff       	jmp    80105d2a <alltraps>

801068df <vector174>:
.globl vector174
vector174:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $174
801068e1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801068e6:	e9 3f f4 ff ff       	jmp    80105d2a <alltraps>

801068eb <vector175>:
.globl vector175
vector175:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $175
801068ed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801068f2:	e9 33 f4 ff ff       	jmp    80105d2a <alltraps>

801068f7 <vector176>:
.globl vector176
vector176:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $176
801068f9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801068fe:	e9 27 f4 ff ff       	jmp    80105d2a <alltraps>

80106903 <vector177>:
.globl vector177
vector177:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $177
80106905:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010690a:	e9 1b f4 ff ff       	jmp    80105d2a <alltraps>

8010690f <vector178>:
.globl vector178
vector178:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $178
80106911:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106916:	e9 0f f4 ff ff       	jmp    80105d2a <alltraps>

8010691b <vector179>:
.globl vector179
vector179:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $179
8010691d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106922:	e9 03 f4 ff ff       	jmp    80105d2a <alltraps>

80106927 <vector180>:
.globl vector180
vector180:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $180
80106929:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010692e:	e9 f7 f3 ff ff       	jmp    80105d2a <alltraps>

80106933 <vector181>:
.globl vector181
vector181:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $181
80106935:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010693a:	e9 eb f3 ff ff       	jmp    80105d2a <alltraps>

8010693f <vector182>:
.globl vector182
vector182:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $182
80106941:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106946:	e9 df f3 ff ff       	jmp    80105d2a <alltraps>

8010694b <vector183>:
.globl vector183
vector183:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $183
8010694d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106952:	e9 d3 f3 ff ff       	jmp    80105d2a <alltraps>

80106957 <vector184>:
.globl vector184
vector184:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $184
80106959:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010695e:	e9 c7 f3 ff ff       	jmp    80105d2a <alltraps>

80106963 <vector185>:
.globl vector185
vector185:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $185
80106965:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010696a:	e9 bb f3 ff ff       	jmp    80105d2a <alltraps>

8010696f <vector186>:
.globl vector186
vector186:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $186
80106971:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106976:	e9 af f3 ff ff       	jmp    80105d2a <alltraps>

8010697b <vector187>:
.globl vector187
vector187:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $187
8010697d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106982:	e9 a3 f3 ff ff       	jmp    80105d2a <alltraps>

80106987 <vector188>:
.globl vector188
vector188:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $188
80106989:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010698e:	e9 97 f3 ff ff       	jmp    80105d2a <alltraps>

80106993 <vector189>:
.globl vector189
vector189:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $189
80106995:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010699a:	e9 8b f3 ff ff       	jmp    80105d2a <alltraps>

8010699f <vector190>:
.globl vector190
vector190:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $190
801069a1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801069a6:	e9 7f f3 ff ff       	jmp    80105d2a <alltraps>

801069ab <vector191>:
.globl vector191
vector191:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $191
801069ad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801069b2:	e9 73 f3 ff ff       	jmp    80105d2a <alltraps>

801069b7 <vector192>:
.globl vector192
vector192:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $192
801069b9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801069be:	e9 67 f3 ff ff       	jmp    80105d2a <alltraps>

801069c3 <vector193>:
.globl vector193
vector193:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $193
801069c5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801069ca:	e9 5b f3 ff ff       	jmp    80105d2a <alltraps>

801069cf <vector194>:
.globl vector194
vector194:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $194
801069d1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801069d6:	e9 4f f3 ff ff       	jmp    80105d2a <alltraps>

801069db <vector195>:
.globl vector195
vector195:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $195
801069dd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801069e2:	e9 43 f3 ff ff       	jmp    80105d2a <alltraps>

801069e7 <vector196>:
.globl vector196
vector196:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $196
801069e9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801069ee:	e9 37 f3 ff ff       	jmp    80105d2a <alltraps>

801069f3 <vector197>:
.globl vector197
vector197:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $197
801069f5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801069fa:	e9 2b f3 ff ff       	jmp    80105d2a <alltraps>

801069ff <vector198>:
.globl vector198
vector198:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $198
80106a01:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106a06:	e9 1f f3 ff ff       	jmp    80105d2a <alltraps>

80106a0b <vector199>:
.globl vector199
vector199:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $199
80106a0d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a12:	e9 13 f3 ff ff       	jmp    80105d2a <alltraps>

80106a17 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $200
80106a19:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a1e:	e9 07 f3 ff ff       	jmp    80105d2a <alltraps>

80106a23 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $201
80106a25:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a2a:	e9 fb f2 ff ff       	jmp    80105d2a <alltraps>

80106a2f <vector202>:
.globl vector202
vector202:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $202
80106a31:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a36:	e9 ef f2 ff ff       	jmp    80105d2a <alltraps>

80106a3b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $203
80106a3d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a42:	e9 e3 f2 ff ff       	jmp    80105d2a <alltraps>

80106a47 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $204
80106a49:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a4e:	e9 d7 f2 ff ff       	jmp    80105d2a <alltraps>

80106a53 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $205
80106a55:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a5a:	e9 cb f2 ff ff       	jmp    80105d2a <alltraps>

80106a5f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $206
80106a61:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a66:	e9 bf f2 ff ff       	jmp    80105d2a <alltraps>

80106a6b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $207
80106a6d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a72:	e9 b3 f2 ff ff       	jmp    80105d2a <alltraps>

80106a77 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $208
80106a79:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a7e:	e9 a7 f2 ff ff       	jmp    80105d2a <alltraps>

80106a83 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $209
80106a85:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a8a:	e9 9b f2 ff ff       	jmp    80105d2a <alltraps>

80106a8f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $210
80106a91:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a96:	e9 8f f2 ff ff       	jmp    80105d2a <alltraps>

80106a9b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $211
80106a9d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106aa2:	e9 83 f2 ff ff       	jmp    80105d2a <alltraps>

80106aa7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $212
80106aa9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106aae:	e9 77 f2 ff ff       	jmp    80105d2a <alltraps>

80106ab3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $213
80106ab5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106aba:	e9 6b f2 ff ff       	jmp    80105d2a <alltraps>

80106abf <vector214>:
.globl vector214
vector214:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $214
80106ac1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ac6:	e9 5f f2 ff ff       	jmp    80105d2a <alltraps>

80106acb <vector215>:
.globl vector215
vector215:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $215
80106acd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106ad2:	e9 53 f2 ff ff       	jmp    80105d2a <alltraps>

80106ad7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $216
80106ad9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106ade:	e9 47 f2 ff ff       	jmp    80105d2a <alltraps>

80106ae3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $217
80106ae5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106aea:	e9 3b f2 ff ff       	jmp    80105d2a <alltraps>

80106aef <vector218>:
.globl vector218
vector218:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $218
80106af1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106af6:	e9 2f f2 ff ff       	jmp    80105d2a <alltraps>

80106afb <vector219>:
.globl vector219
vector219:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $219
80106afd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106b02:	e9 23 f2 ff ff       	jmp    80105d2a <alltraps>

80106b07 <vector220>:
.globl vector220
vector220:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $220
80106b09:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106b0e:	e9 17 f2 ff ff       	jmp    80105d2a <alltraps>

80106b13 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $221
80106b15:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b1a:	e9 0b f2 ff ff       	jmp    80105d2a <alltraps>

80106b1f <vector222>:
.globl vector222
vector222:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $222
80106b21:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b26:	e9 ff f1 ff ff       	jmp    80105d2a <alltraps>

80106b2b <vector223>:
.globl vector223
vector223:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $223
80106b2d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b32:	e9 f3 f1 ff ff       	jmp    80105d2a <alltraps>

80106b37 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $224
80106b39:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b3e:	e9 e7 f1 ff ff       	jmp    80105d2a <alltraps>

80106b43 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $225
80106b45:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b4a:	e9 db f1 ff ff       	jmp    80105d2a <alltraps>

80106b4f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $226
80106b51:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b56:	e9 cf f1 ff ff       	jmp    80105d2a <alltraps>

80106b5b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $227
80106b5d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b62:	e9 c3 f1 ff ff       	jmp    80105d2a <alltraps>

80106b67 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $228
80106b69:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b6e:	e9 b7 f1 ff ff       	jmp    80105d2a <alltraps>

80106b73 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $229
80106b75:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b7a:	e9 ab f1 ff ff       	jmp    80105d2a <alltraps>

80106b7f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $230
80106b81:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b86:	e9 9f f1 ff ff       	jmp    80105d2a <alltraps>

80106b8b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $231
80106b8d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b92:	e9 93 f1 ff ff       	jmp    80105d2a <alltraps>

80106b97 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $232
80106b99:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b9e:	e9 87 f1 ff ff       	jmp    80105d2a <alltraps>

80106ba3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $233
80106ba5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106baa:	e9 7b f1 ff ff       	jmp    80105d2a <alltraps>

80106baf <vector234>:
.globl vector234
vector234:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $234
80106bb1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106bb6:	e9 6f f1 ff ff       	jmp    80105d2a <alltraps>

80106bbb <vector235>:
.globl vector235
vector235:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $235
80106bbd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106bc2:	e9 63 f1 ff ff       	jmp    80105d2a <alltraps>

80106bc7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $236
80106bc9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106bce:	e9 57 f1 ff ff       	jmp    80105d2a <alltraps>

80106bd3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $237
80106bd5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106bda:	e9 4b f1 ff ff       	jmp    80105d2a <alltraps>

80106bdf <vector238>:
.globl vector238
vector238:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $238
80106be1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106be6:	e9 3f f1 ff ff       	jmp    80105d2a <alltraps>

80106beb <vector239>:
.globl vector239
vector239:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $239
80106bed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106bf2:	e9 33 f1 ff ff       	jmp    80105d2a <alltraps>

80106bf7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $240
80106bf9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106bfe:	e9 27 f1 ff ff       	jmp    80105d2a <alltraps>

80106c03 <vector241>:
.globl vector241
vector241:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $241
80106c05:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106c0a:	e9 1b f1 ff ff       	jmp    80105d2a <alltraps>

80106c0f <vector242>:
.globl vector242
vector242:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $242
80106c11:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c16:	e9 0f f1 ff ff       	jmp    80105d2a <alltraps>

80106c1b <vector243>:
.globl vector243
vector243:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $243
80106c1d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c22:	e9 03 f1 ff ff       	jmp    80105d2a <alltraps>

80106c27 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $244
80106c29:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c2e:	e9 f7 f0 ff ff       	jmp    80105d2a <alltraps>

80106c33 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $245
80106c35:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c3a:	e9 eb f0 ff ff       	jmp    80105d2a <alltraps>

80106c3f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $246
80106c41:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c46:	e9 df f0 ff ff       	jmp    80105d2a <alltraps>

80106c4b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $247
80106c4d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c52:	e9 d3 f0 ff ff       	jmp    80105d2a <alltraps>

80106c57 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $248
80106c59:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c5e:	e9 c7 f0 ff ff       	jmp    80105d2a <alltraps>

80106c63 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $249
80106c65:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c6a:	e9 bb f0 ff ff       	jmp    80105d2a <alltraps>

80106c6f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $250
80106c71:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c76:	e9 af f0 ff ff       	jmp    80105d2a <alltraps>

80106c7b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $251
80106c7d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c82:	e9 a3 f0 ff ff       	jmp    80105d2a <alltraps>

80106c87 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $252
80106c89:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c8e:	e9 97 f0 ff ff       	jmp    80105d2a <alltraps>

80106c93 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $253
80106c95:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c9a:	e9 8b f0 ff ff       	jmp    80105d2a <alltraps>

80106c9f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $254
80106ca1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ca6:	e9 7f f0 ff ff       	jmp    80105d2a <alltraps>

80106cab <vector255>:
.globl vector255
vector255:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $255
80106cad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106cb2:	e9 73 f0 ff ff       	jmp    80105d2a <alltraps>
80106cb7:	66 90                	xchg   %ax,%ax
80106cb9:	66 90                	xchg   %ax,%ax
80106cbb:	66 90                	xchg   %ax,%ax
80106cbd:	66 90                	xchg   %ax,%ax
80106cbf:	90                   	nop

80106cc0 <deallocuvm_proc.part.0>:
    }
  }
  return newsz;
}
int
deallocuvm_proc(struct proc * p, pde_t *pgdir, uint oldsz, uint newsz)
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	57                   	push   %edi
80106cc4:	56                   	push   %esi
80106cc5:	53                   	push   %ebx
80106cc6:	83 ec 1c             	sub    $0x1c,%esp
80106cc9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ccc:	8b 45 08             	mov    0x8(%ebp),%eax
80106ccf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106cd5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106cdb:	39 cb                	cmp    %ecx,%ebx
80106cdd:	73 7d                	jae    80106d5c <deallocuvm_proc.part.0+0x9c>
80106cdf:	89 d6                	mov    %edx,%esi
80106ce1:	89 cf                	mov    %ecx,%edi
80106ce3:	eb 0f                	jmp    80106cf4 <deallocuvm_proc.part.0+0x34>
80106ce5:	8d 76 00             	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106ce8:	83 c2 01             	add    $0x1,%edx
80106ceb:	89 d3                	mov    %edx,%ebx
80106ced:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106cf0:	39 fb                	cmp    %edi,%ebx
80106cf2:	73 68                	jae    80106d5c <deallocuvm_proc.part.0+0x9c>
  pde = &pgdir[PDX(va)];
80106cf4:	89 da                	mov    %ebx,%edx
80106cf6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106cf9:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106cfc:	a8 01                	test   $0x1,%al
80106cfe:	74 e8                	je     80106ce8 <deallocuvm_proc.part.0+0x28>
  return &pgtab[PTX(va)];
80106d00:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106d07:	c1 e9 0a             	shr    $0xa,%ecx
80106d0a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106d10:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106d17:	85 c0                	test   %eax,%eax
80106d19:	74 cd                	je     80106ce8 <deallocuvm_proc.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106d1b:	8b 10                	mov    (%eax),%edx
80106d1d:	f6 c2 01             	test   $0x1,%dl
80106d20:	74 4e                	je     80106d70 <deallocuvm_proc.part.0+0xb0>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106d22:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106d28:	74 64                	je     80106d8e <deallocuvm_proc.part.0+0xce>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106d2a:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d2d:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106d33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d36:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106d3c:	52                   	push   %edx
80106d3d:	e8 5e b8 ff ff       	call   801025a0 <kfree>
      p->rss -= PGSIZE;
80106d42:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d45:	83 c4 10             	add    $0x10,%esp
80106d48:	81 68 04 00 10 00 00 	subl   $0x1000,0x4(%eax)
      *pte = 0;
80106d4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106d58:	39 fb                	cmp    %edi,%ebx
80106d5a:	72 98                	jb     80106cf4 <deallocuvm_proc.part.0+0x34>
        clear_slot(pte);
      }
    }
  }
  return newsz;
}
80106d5c:	8b 45 08             	mov    0x8(%ebp),%eax
80106d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d62:	5b                   	pop    %ebx
80106d63:	5e                   	pop    %esi
80106d64:	5f                   	pop    %edi
80106d65:	5d                   	pop    %ebp
80106d66:	c3                   	ret
80106d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d6e:	66 90                	xchg   %ax,%ax
      if(*pte & PTE_SW){
80106d70:	83 e2 08             	and    $0x8,%edx
80106d73:	75 0b                	jne    80106d80 <deallocuvm_proc.part.0+0xc0>
  for(; a  < oldsz; a += PGSIZE){
80106d75:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d7b:	e9 70 ff ff ff       	jmp    80106cf0 <deallocuvm_proc.part.0+0x30>
        clear_slot(pte);
80106d80:	83 ec 0c             	sub    $0xc,%esp
80106d83:	50                   	push   %eax
80106d84:	e8 b7 11 00 00       	call   80107f40 <clear_slot>
80106d89:	83 c4 10             	add    $0x10,%esp
80106d8c:	eb e7                	jmp    80106d75 <deallocuvm_proc.part.0+0xb5>
        panic("kfree");
80106d8e:	83 ec 0c             	sub    $0xc,%esp
80106d91:	68 6c 83 10 80       	push   $0x8010836c
80106d96:	e8 d5 96 ff ff       	call   80100470 <panic>
80106d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d9f:	90                   	nop

80106da0 <deallocuvm.part.0>:
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	57                   	push   %edi
80106da4:	56                   	push   %esi
80106da5:	89 c6                	mov    %eax,%esi
80106da7:	89 c8                	mov    %ecx,%eax
80106da9:	53                   	push   %ebx
  a = PGROUNDUP(newsz);
80106daa:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106db0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106db6:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106db9:	39 d3                	cmp    %edx,%ebx
80106dbb:	0f 83 85 00 00 00    	jae    80106e46 <deallocuvm.part.0+0xa6>
80106dc1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106dc4:	89 d7                	mov    %edx,%edi
80106dc6:	eb 14                	jmp    80106ddc <deallocuvm.part.0+0x3c>
80106dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dcf:	90                   	nop
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106dd0:	83 c2 01             	add    $0x1,%edx
80106dd3:	89 d3                	mov    %edx,%ebx
80106dd5:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106dd8:	39 fb                	cmp    %edi,%ebx
80106dda:	73 67                	jae    80106e43 <deallocuvm.part.0+0xa3>
  pde = &pgdir[PDX(va)];
80106ddc:	89 da                	mov    %ebx,%edx
80106dde:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106de1:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106de4:	a8 01                	test   $0x1,%al
80106de6:	74 e8                	je     80106dd0 <deallocuvm.part.0+0x30>
  return &pgtab[PTX(va)];
80106de8:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106dea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106def:	c1 e9 0a             	shr    $0xa,%ecx
80106df2:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106df8:	8d 8c 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%ecx
    if(!pte)
80106dff:	85 c9                	test   %ecx,%ecx
80106e01:	74 cd                	je     80106dd0 <deallocuvm.part.0+0x30>
    else if((*pte & PTE_P) != 0){
80106e03:	8b 01                	mov    (%ecx),%eax
80106e05:	a8 01                	test   $0x1,%al
80106e07:	74 47                	je     80106e50 <deallocuvm.part.0+0xb0>
      if(pa == 0)
80106e09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e0e:	74 74                	je     80106e84 <deallocuvm.part.0+0xe4>
      kfree(v);
80106e10:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106e13:	05 00 00 00 80       	add    $0x80000000,%eax
80106e18:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106e1b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106e21:	50                   	push   %eax
80106e22:	e8 79 b7 ff ff       	call   801025a0 <kfree>
      myproc()->rss -= PGSIZE;
80106e27:	e8 24 cd ff ff       	call   80103b50 <myproc>
      *pte = 0;
80106e2c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e2f:	83 c4 10             	add    $0x10,%esp
      myproc()->rss -= PGSIZE;
80106e32:	81 68 04 00 10 00 00 	subl   $0x1000,0x4(%eax)
      *pte = 0;
80106e39:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
  for(; a  < oldsz; a += PGSIZE){
80106e3f:	39 fb                	cmp    %edi,%ebx
80106e41:	72 99                	jb     80106ddc <deallocuvm.part.0+0x3c>
80106e43:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80106e46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e49:	5b                   	pop    %ebx
80106e4a:	5e                   	pop    %esi
80106e4b:	5f                   	pop    %edi
80106e4c:	5d                   	pop    %ebp
80106e4d:	c3                   	ret
80106e4e:	66 90                	xchg   %ax,%ax
      if((*pte & PTE_SW)){
80106e50:	a8 08                	test   $0x8,%al
80106e52:	75 0c                	jne    80106e60 <deallocuvm.part.0+0xc0>
  for(; a  < oldsz; a += PGSIZE){
80106e54:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e5a:	e9 79 ff ff ff       	jmp    80106dd8 <deallocuvm.part.0+0x38>
80106e5f:	90                   	nop
        int refcnt = dec_swap_slot_refcnt(pte);
80106e60:	83 ec 0c             	sub    $0xc,%esp
80106e63:	51                   	push   %ecx
80106e64:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106e67:	e8 04 11 00 00       	call   80107f70 <dec_swap_slot_refcnt>
        if(refcnt == 0){
80106e6c:	83 c4 10             	add    $0x10,%esp
80106e6f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e72:	85 c0                	test   %eax,%eax
80106e74:	75 de                	jne    80106e54 <deallocuvm.part.0+0xb4>
          clear_slot(pte);
80106e76:	83 ec 0c             	sub    $0xc,%esp
80106e79:	51                   	push   %ecx
80106e7a:	e8 c1 10 00 00       	call   80107f40 <clear_slot>
80106e7f:	83 c4 10             	add    $0x10,%esp
80106e82:	eb d0                	jmp    80106e54 <deallocuvm.part.0+0xb4>
        panic("kfree");
80106e84:	83 ec 0c             	sub    $0xc,%esp
80106e87:	68 6c 83 10 80       	push   $0x8010836c
80106e8c:	e8 df 95 ff ff       	call   80100470 <panic>
80106e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e9f:	90                   	nop

80106ea0 <mappages>:
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106ea6:	89 d3                	mov    %edx,%ebx
80106ea8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106eae:	83 ec 1c             	sub    $0x1c,%esp
80106eb1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106eb4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106eb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ebd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106ec0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ec3:	29 d8                	sub    %ebx,%eax
80106ec5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ec8:	eb 3f                	jmp    80106f09 <mappages+0x69>
80106eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106ed0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ed2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106ed7:	c1 ea 0a             	shr    $0xa,%edx
80106eda:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106ee0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ee7:	85 c0                	test   %eax,%eax
80106ee9:	74 75                	je     80106f60 <mappages+0xc0>
    if(*pte & PTE_P)
80106eeb:	f6 00 01             	testb  $0x1,(%eax)
80106eee:	0f 85 86 00 00 00    	jne    80106f7a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106ef4:	0b 75 0c             	or     0xc(%ebp),%esi
80106ef7:	83 ce 01             	or     $0x1,%esi
80106efa:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106efc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106eff:	39 c3                	cmp    %eax,%ebx
80106f01:	74 6d                	je     80106f70 <mappages+0xd0>
    a += PGSIZE;
80106f03:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106f09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106f0c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106f0f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106f12:	89 d8                	mov    %ebx,%eax
80106f14:	c1 e8 16             	shr    $0x16,%eax
80106f17:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106f1a:	8b 07                	mov    (%edi),%eax
80106f1c:	a8 01                	test   $0x1,%al
80106f1e:	75 b0                	jne    80106ed0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106f20:	e8 ab b8 ff ff       	call   801027d0 <kalloc>
80106f25:	85 c0                	test   %eax,%eax
80106f27:	74 37                	je     80106f60 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106f29:	83 ec 04             	sub    $0x4,%esp
80106f2c:	68 00 10 00 00       	push   $0x1000
80106f31:	6a 00                	push   $0x0
80106f33:	50                   	push   %eax
80106f34:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106f37:	e8 34 dc ff ff       	call   80104b70 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106f3c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106f3f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106f42:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106f48:	83 c8 07             	or     $0x7,%eax
80106f4b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106f4d:	89 d8                	mov    %ebx,%eax
80106f4f:	c1 e8 0a             	shr    $0xa,%eax
80106f52:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f57:	01 d0                	add    %edx,%eax
80106f59:	eb 90                	jmp    80106eeb <mappages+0x4b>
80106f5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f5f:	90                   	nop
}
80106f60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f68:	5b                   	pop    %ebx
80106f69:	5e                   	pop    %esi
80106f6a:	5f                   	pop    %edi
80106f6b:	5d                   	pop    %ebp
80106f6c:	c3                   	ret
80106f6d:	8d 76 00             	lea    0x0(%esi),%esi
80106f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f73:	31 c0                	xor    %eax,%eax
}
80106f75:	5b                   	pop    %ebx
80106f76:	5e                   	pop    %esi
80106f77:	5f                   	pop    %edi
80106f78:	5d                   	pop    %ebp
80106f79:	c3                   	ret
      panic("remap");
80106f7a:	83 ec 0c             	sub    $0xc,%esp
80106f7d:	68 d3 85 10 80       	push   $0x801085d3
80106f82:	e8 e9 94 ff ff       	call   80100470 <panic>
80106f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f8e:	66 90                	xchg   %ax,%ax

80106f90 <seginit>:
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106f96:	e8 95 cb ff ff       	call   80103b30 <cpuid>
  pd[0] = size-1;
80106f9b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106fa0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106fa6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106faa:	c7 80 38 38 11 80 ff 	movl   $0xffff,-0x7feec7c8(%eax)
80106fb1:	ff 00 00 
80106fb4:	c7 80 3c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7c4(%eax)
80106fbb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106fbe:	c7 80 40 38 11 80 ff 	movl   $0xffff,-0x7feec7c0(%eax)
80106fc5:	ff 00 00 
80106fc8:	c7 80 44 38 11 80 00 	movl   $0xcf9200,-0x7feec7bc(%eax)
80106fcf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106fd2:	c7 80 48 38 11 80 ff 	movl   $0xffff,-0x7feec7b8(%eax)
80106fd9:	ff 00 00 
80106fdc:	c7 80 4c 38 11 80 00 	movl   $0xcffa00,-0x7feec7b4(%eax)
80106fe3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106fe6:	c7 80 50 38 11 80 ff 	movl   $0xffff,-0x7feec7b0(%eax)
80106fed:	ff 00 00 
80106ff0:	c7 80 54 38 11 80 00 	movl   $0xcff200,-0x7feec7ac(%eax)
80106ff7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106ffa:	05 30 38 11 80       	add    $0x80113830,%eax
  pd[1] = (uint)p;
80106fff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107003:	c1 e8 10             	shr    $0x10,%eax
80107006:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010700a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010700d:	0f 01 10             	lgdtl  (%eax)
}
80107010:	c9                   	leave
80107011:	c3                   	ret
80107012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107020 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107020:	a1 24 61 11 80       	mov    0x80116124,%eax
80107025:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010702a:	0f 22 d8             	mov    %eax,%cr3
}
8010702d:	c3                   	ret
8010702e:	66 90                	xchg   %ax,%ax

80107030 <switchuvm>:
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	57                   	push   %edi
80107034:	56                   	push   %esi
80107035:	53                   	push   %ebx
80107036:	83 ec 1c             	sub    $0x1c,%esp
80107039:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010703c:	85 f6                	test   %esi,%esi
8010703e:	0f 84 cb 00 00 00    	je     8010710f <switchuvm+0xdf>
  if(p->kstack == 0)
80107044:	8b 46 0c             	mov    0xc(%esi),%eax
80107047:	85 c0                	test   %eax,%eax
80107049:	0f 84 da 00 00 00    	je     80107129 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010704f:	8b 46 08             	mov    0x8(%esi),%eax
80107052:	85 c0                	test   %eax,%eax
80107054:	0f 84 c2 00 00 00    	je     8010711c <switchuvm+0xec>
  pushcli();
8010705a:	e8 c1 d8 ff ff       	call   80104920 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010705f:	e8 7c ca ff ff       	call   80103ae0 <mycpu>
80107064:	89 c3                	mov    %eax,%ebx
80107066:	e8 75 ca ff ff       	call   80103ae0 <mycpu>
8010706b:	89 c7                	mov    %eax,%edi
8010706d:	e8 6e ca ff ff       	call   80103ae0 <mycpu>
80107072:	83 c7 08             	add    $0x8,%edi
80107075:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107078:	e8 63 ca ff ff       	call   80103ae0 <mycpu>
8010707d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107080:	ba 67 00 00 00       	mov    $0x67,%edx
80107085:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010708c:	83 c0 08             	add    $0x8,%eax
8010708f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107096:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010709b:	83 c1 08             	add    $0x8,%ecx
8010709e:	c1 e8 18             	shr    $0x18,%eax
801070a1:	c1 e9 10             	shr    $0x10,%ecx
801070a4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801070aa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801070b0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801070b5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801070bc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801070c1:	e8 1a ca ff ff       	call   80103ae0 <mycpu>
801070c6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801070cd:	e8 0e ca ff ff       	call   80103ae0 <mycpu>
801070d2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801070d6:	8b 5e 0c             	mov    0xc(%esi),%ebx
801070d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070df:	e8 fc c9 ff ff       	call   80103ae0 <mycpu>
801070e4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801070e7:	e8 f4 c9 ff ff       	call   80103ae0 <mycpu>
801070ec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801070f0:	b8 28 00 00 00       	mov    $0x28,%eax
801070f5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801070f8:	8b 46 08             	mov    0x8(%esi),%eax
801070fb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107100:	0f 22 d8             	mov    %eax,%cr3
}
80107103:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107106:	5b                   	pop    %ebx
80107107:	5e                   	pop    %esi
80107108:	5f                   	pop    %edi
80107109:	5d                   	pop    %ebp
  popcli();
8010710a:	e9 61 d8 ff ff       	jmp    80104970 <popcli>
    panic("switchuvm: no process");
8010710f:	83 ec 0c             	sub    $0xc,%esp
80107112:	68 d9 85 10 80       	push   $0x801085d9
80107117:	e8 54 93 ff ff       	call   80100470 <panic>
    panic("switchuvm: no pgdir");
8010711c:	83 ec 0c             	sub    $0xc,%esp
8010711f:	68 04 86 10 80       	push   $0x80108604
80107124:	e8 47 93 ff ff       	call   80100470 <panic>
    panic("switchuvm: no kstack");
80107129:	83 ec 0c             	sub    $0xc,%esp
8010712c:	68 ef 85 10 80       	push   $0x801085ef
80107131:	e8 3a 93 ff ff       	call   80100470 <panic>
80107136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010713d:	8d 76 00             	lea    0x0(%esi),%esi

80107140 <inituvm>:
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
80107146:	83 ec 1c             	sub    $0x1c,%esp
80107149:	8b 45 08             	mov    0x8(%ebp),%eax
8010714c:	8b 75 10             	mov    0x10(%ebp),%esi
8010714f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80107152:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107155:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010715b:	77 49                	ja     801071a6 <inituvm+0x66>
  mem = kalloc();
8010715d:	e8 6e b6 ff ff       	call   801027d0 <kalloc>
  memset(mem, 0, PGSIZE);
80107162:	83 ec 04             	sub    $0x4,%esp
80107165:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010716a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010716c:	6a 00                	push   $0x0
8010716e:	50                   	push   %eax
8010716f:	e8 fc d9 ff ff       	call   80104b70 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107174:	58                   	pop    %eax
80107175:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010717b:	5a                   	pop    %edx
8010717c:	6a 06                	push   $0x6
8010717e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107183:	31 d2                	xor    %edx,%edx
80107185:	50                   	push   %eax
80107186:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107189:	e8 12 fd ff ff       	call   80106ea0 <mappages>
  memmove(mem, init, sz);
8010718e:	89 75 10             	mov    %esi,0x10(%ebp)
80107191:	83 c4 10             	add    $0x10,%esp
80107194:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107197:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010719a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010719d:	5b                   	pop    %ebx
8010719e:	5e                   	pop    %esi
8010719f:	5f                   	pop    %edi
801071a0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801071a1:	e9 5a da ff ff       	jmp    80104c00 <memmove>
    panic("inituvm: more than a page");
801071a6:	83 ec 0c             	sub    $0xc,%esp
801071a9:	68 18 86 10 80       	push   $0x80108618
801071ae:	e8 bd 92 ff ff       	call   80100470 <panic>
801071b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071c0 <loaduvm>:
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	57                   	push   %edi
801071c4:	56                   	push   %esi
801071c5:	53                   	push   %ebx
801071c6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
801071c9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
801071cc:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
801071cf:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
801071d5:	0f 85 a2 00 00 00    	jne    8010727d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
801071db:	85 ff                	test   %edi,%edi
801071dd:	74 7d                	je     8010725c <loaduvm+0x9c>
801071df:	90                   	nop
  pde = &pgdir[PDX(va)];
801071e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801071e3:	8b 55 08             	mov    0x8(%ebp),%edx
801071e6:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
801071e8:	89 c1                	mov    %eax,%ecx
801071ea:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801071ed:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
801071f0:	f6 c1 01             	test   $0x1,%cl
801071f3:	75 13                	jne    80107208 <loaduvm+0x48>
      panic("loaduvm: address should exist");
801071f5:	83 ec 0c             	sub    $0xc,%esp
801071f8:	68 32 86 10 80       	push   $0x80108632
801071fd:	e8 6e 92 ff ff       	call   80100470 <panic>
80107202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107208:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010720b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107211:	25 fc 0f 00 00       	and    $0xffc,%eax
80107216:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010721d:	85 c9                	test   %ecx,%ecx
8010721f:	74 d4                	je     801071f5 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80107221:	89 fb                	mov    %edi,%ebx
80107223:	b8 00 10 00 00       	mov    $0x1000,%eax
80107228:	29 f3                	sub    %esi,%ebx
8010722a:	39 c3                	cmp    %eax,%ebx
8010722c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010722f:	53                   	push   %ebx
80107230:	8b 45 14             	mov    0x14(%ebp),%eax
80107233:	01 f0                	add    %esi,%eax
80107235:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80107236:	8b 01                	mov    (%ecx),%eax
80107238:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010723d:	05 00 00 00 80       	add    $0x80000000,%eax
80107242:	50                   	push   %eax
80107243:	ff 75 10             	push   0x10(%ebp)
80107246:	e8 55 a9 ff ff       	call   80101ba0 <readi>
8010724b:	83 c4 10             	add    $0x10,%esp
8010724e:	39 d8                	cmp    %ebx,%eax
80107250:	75 1e                	jne    80107270 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80107252:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107258:	39 fe                	cmp    %edi,%esi
8010725a:	72 84                	jb     801071e0 <loaduvm+0x20>
}
8010725c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010725f:	31 c0                	xor    %eax,%eax
}
80107261:	5b                   	pop    %ebx
80107262:	5e                   	pop    %esi
80107263:	5f                   	pop    %edi
80107264:	5d                   	pop    %ebp
80107265:	c3                   	ret
80107266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726d:	8d 76 00             	lea    0x0(%esi),%esi
80107270:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107273:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107278:	5b                   	pop    %ebx
80107279:	5e                   	pop    %esi
8010727a:	5f                   	pop    %edi
8010727b:	5d                   	pop    %ebp
8010727c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
8010727d:	83 ec 0c             	sub    $0xc,%esp
80107280:	68 28 89 10 80       	push   $0x80108928
80107285:	e8 e6 91 ff ff       	call   80100470 <panic>
8010728a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107290 <allocuvm>:
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	57                   	push   %edi
80107294:	56                   	push   %esi
80107295:	53                   	push   %ebx
80107296:	83 ec 1c             	sub    $0x1c,%esp
80107299:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010729c:	85 f6                	test   %esi,%esi
8010729e:	0f 88 a4 00 00 00    	js     80107348 <allocuvm+0xb8>
801072a4:	89 f1                	mov    %esi,%ecx
  if(newsz < oldsz)
801072a6:	3b 75 0c             	cmp    0xc(%ebp),%esi
801072a9:	0f 82 a9 00 00 00    	jb     80107358 <allocuvm+0xc8>
  a = PGROUNDUP(oldsz);
801072af:	8b 45 0c             	mov    0xc(%ebp),%eax
801072b2:	05 ff 0f 00 00       	add    $0xfff,%eax
801072b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801072bc:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
801072be:	39 f0                	cmp    %esi,%eax
801072c0:	0f 83 95 00 00 00    	jae    8010735b <allocuvm+0xcb>
801072c6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801072c9:	eb 50                	jmp    8010731b <allocuvm+0x8b>
801072cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072cf:	90                   	nop
    memset(mem, 0, PGSIZE);
801072d0:	83 ec 04             	sub    $0x4,%esp
801072d3:	68 00 10 00 00       	push   $0x1000
801072d8:	6a 00                	push   $0x0
801072da:	50                   	push   %eax
801072db:	e8 90 d8 ff ff       	call   80104b70 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801072e0:	58                   	pop    %eax
801072e1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072e7:	5a                   	pop    %edx
801072e8:	6a 06                	push   $0x6
801072ea:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072ef:	89 fa                	mov    %edi,%edx
801072f1:	50                   	push   %eax
801072f2:	8b 45 08             	mov    0x8(%ebp),%eax
801072f5:	e8 a6 fb ff ff       	call   80106ea0 <mappages>
801072fa:	83 c4 10             	add    $0x10,%esp
801072fd:	85 c0                	test   %eax,%eax
801072ff:	78 67                	js     80107368 <allocuvm+0xd8>
    myproc()->rss += PGSIZE;
80107301:	e8 4a c8 ff ff       	call   80103b50 <myproc>
  for(; a < newsz; a += PGSIZE){
80107306:	81 c7 00 10 00 00    	add    $0x1000,%edi
    myproc()->rss += PGSIZE;
8010730c:	81 40 04 00 10 00 00 	addl   $0x1000,0x4(%eax)
  for(; a < newsz; a += PGSIZE){
80107313:	39 f7                	cmp    %esi,%edi
80107315:	0f 83 85 00 00 00    	jae    801073a0 <allocuvm+0x110>
    mem = kalloc();
8010731b:	e8 b0 b4 ff ff       	call   801027d0 <kalloc>
80107320:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107322:	85 c0                	test   %eax,%eax
80107324:	75 aa                	jne    801072d0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107326:	83 ec 0c             	sub    $0xc,%esp
80107329:	68 50 86 10 80       	push   $0x80108650
8010732e:	e8 6d 94 ff ff       	call   801007a0 <cprintf>
  if(newsz >= oldsz)
80107333:	83 c4 10             	add    $0x10,%esp
80107336:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107339:	74 0d                	je     80107348 <allocuvm+0xb8>
8010733b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010733e:	8b 45 08             	mov    0x8(%ebp),%eax
80107341:	89 f2                	mov    %esi,%edx
80107343:	e8 58 fa ff ff       	call   80106da0 <deallocuvm.part.0>
    return 0;
80107348:	31 c9                	xor    %ecx,%ecx
}
8010734a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010734d:	89 c8                	mov    %ecx,%eax
8010734f:	5b                   	pop    %ebx
80107350:	5e                   	pop    %esi
80107351:	5f                   	pop    %edi
80107352:	5d                   	pop    %ebp
80107353:	c3                   	ret
80107354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107358:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}
8010735b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010735e:	89 c8                	mov    %ecx,%eax
80107360:	5b                   	pop    %ebx
80107361:	5e                   	pop    %esi
80107362:	5f                   	pop    %edi
80107363:	5d                   	pop    %ebp
80107364:	c3                   	ret
80107365:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107368:	83 ec 0c             	sub    $0xc,%esp
8010736b:	68 68 86 10 80       	push   $0x80108668
80107370:	e8 2b 94 ff ff       	call   801007a0 <cprintf>
  if(newsz >= oldsz)
80107375:	83 c4 10             	add    $0x10,%esp
80107378:	3b 75 0c             	cmp    0xc(%ebp),%esi
8010737b:	74 0d                	je     8010738a <allocuvm+0xfa>
8010737d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107380:	8b 45 08             	mov    0x8(%ebp),%eax
80107383:	89 f2                	mov    %esi,%edx
80107385:	e8 16 fa ff ff       	call   80106da0 <deallocuvm.part.0>
      kfree(mem);
8010738a:	83 ec 0c             	sub    $0xc,%esp
8010738d:	53                   	push   %ebx
8010738e:	e8 0d b2 ff ff       	call   801025a0 <kfree>
      return 0;
80107393:	83 c4 10             	add    $0x10,%esp
    return 0;
80107396:	31 c9                	xor    %ecx,%ecx
80107398:	eb b0                	jmp    8010734a <allocuvm+0xba>
8010739a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
}
801073a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073a6:	5b                   	pop    %ebx
801073a7:	5e                   	pop    %esi
801073a8:	89 c8                	mov    %ecx,%eax
801073aa:	5f                   	pop    %edi
801073ab:	5d                   	pop    %ebp
801073ac:	c3                   	ret
801073ad:	8d 76 00             	lea    0x0(%esi),%esi

801073b0 <deallocuvm>:
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801073b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801073b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801073bc:	39 d1                	cmp    %edx,%ecx
801073be:	73 10                	jae    801073d0 <deallocuvm+0x20>
}
801073c0:	5d                   	pop    %ebp
801073c1:	e9 da f9 ff ff       	jmp    80106da0 <deallocuvm.part.0>
801073c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073cd:	8d 76 00             	lea    0x0(%esi),%esi
801073d0:	89 d0                	mov    %edx,%eax
801073d2:	5d                   	pop    %ebp
801073d3:	c3                   	ret
801073d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073df:	90                   	nop

801073e0 <deallocuvm_proc>:
{
801073e0:	55                   	push   %ebp
801073e1:	89 e5                	mov    %esp,%ebp
801073e3:	53                   	push   %ebx
801073e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
801073e7:	8b 45 14             	mov    0x14(%ebp),%eax
801073ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
801073ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  if(newsz >= oldsz)
801073f0:	39 c8                	cmp    %ecx,%eax
801073f2:	73 14                	jae    80107408 <deallocuvm_proc+0x28>
801073f4:	89 45 08             	mov    %eax,0x8(%ebp)
801073f7:	89 d8                	mov    %ebx,%eax
}
801073f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801073fc:	c9                   	leave
801073fd:	e9 be f8 ff ff       	jmp    80106cc0 <deallocuvm_proc.part.0>
80107402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107408:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010740b:	89 c8                	mov    %ecx,%eax
8010740d:	c9                   	leave
8010740e:	c3                   	ret
8010740f:	90                   	nop

80107410 <freevm>:
// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	57                   	push   %edi
80107414:	56                   	push   %esi
80107415:	53                   	push   %ebx
80107416:	83 ec 0c             	sub    $0xc,%esp
80107419:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010741c:	85 f6                	test   %esi,%esi
8010741e:	74 59                	je     80107479 <freevm+0x69>
  if(newsz >= oldsz)
80107420:	31 c9                	xor    %ecx,%ecx
80107422:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107427:	89 f0                	mov    %esi,%eax
80107429:	89 f3                	mov    %esi,%ebx
8010742b:	e8 70 f9 ff ff       	call   80106da0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107430:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107436:	eb 0f                	jmp    80107447 <freevm+0x37>
80107438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010743f:	90                   	nop
80107440:	83 c3 04             	add    $0x4,%ebx
80107443:	39 fb                	cmp    %edi,%ebx
80107445:	74 23                	je     8010746a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107447:	8b 03                	mov    (%ebx),%eax
80107449:	a8 01                	test   $0x1,%al
8010744b:	74 f3                	je     80107440 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010744d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107452:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107455:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107458:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010745d:	50                   	push   %eax
8010745e:	e8 3d b1 ff ff       	call   801025a0 <kfree>
80107463:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107466:	39 fb                	cmp    %edi,%ebx
80107468:	75 dd                	jne    80107447 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010746a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010746d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107470:	5b                   	pop    %ebx
80107471:	5e                   	pop    %esi
80107472:	5f                   	pop    %edi
80107473:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107474:	e9 27 b1 ff ff       	jmp    801025a0 <kfree>
    panic("freevm: no pgdir");
80107479:	83 ec 0c             	sub    $0xc,%esp
8010747c:	68 84 86 10 80       	push   $0x80108684
80107481:	e8 ea 8f ff ff       	call   80100470 <panic>
80107486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010748d:	8d 76 00             	lea    0x0(%esi),%esi

80107490 <setupkvm>:
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	56                   	push   %esi
80107494:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107495:	e8 36 b3 ff ff       	call   801027d0 <kalloc>
8010749a:	85 c0                	test   %eax,%eax
8010749c:	74 5e                	je     801074fc <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
8010749e:	83 ec 04             	sub    $0x4,%esp
801074a1:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801074a3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801074a8:	68 00 10 00 00       	push   $0x1000
801074ad:	6a 00                	push   $0x0
801074af:	50                   	push   %eax
801074b0:	e8 bb d6 ff ff       	call   80104b70 <memset>
801074b5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801074b8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801074bb:	83 ec 08             	sub    $0x8,%esp
801074be:	8b 4b 08             	mov    0x8(%ebx),%ecx
801074c1:	8b 13                	mov    (%ebx),%edx
801074c3:	ff 73 0c             	push   0xc(%ebx)
801074c6:	50                   	push   %eax
801074c7:	29 c1                	sub    %eax,%ecx
801074c9:	89 f0                	mov    %esi,%eax
801074cb:	e8 d0 f9 ff ff       	call   80106ea0 <mappages>
801074d0:	83 c4 10             	add    $0x10,%esp
801074d3:	85 c0                	test   %eax,%eax
801074d5:	78 19                	js     801074f0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801074d7:	83 c3 10             	add    $0x10,%ebx
801074da:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801074e0:	75 d6                	jne    801074b8 <setupkvm+0x28>
}
801074e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801074e5:	89 f0                	mov    %esi,%eax
801074e7:	5b                   	pop    %ebx
801074e8:	5e                   	pop    %esi
801074e9:	5d                   	pop    %ebp
801074ea:	c3                   	ret
801074eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074ef:	90                   	nop
      freevm(pgdir);
801074f0:	83 ec 0c             	sub    $0xc,%esp
801074f3:	56                   	push   %esi
801074f4:	e8 17 ff ff ff       	call   80107410 <freevm>
      return 0;
801074f9:	83 c4 10             	add    $0x10,%esp
}
801074fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
801074ff:	31 f6                	xor    %esi,%esi
}
80107501:	89 f0                	mov    %esi,%eax
80107503:	5b                   	pop    %ebx
80107504:	5e                   	pop    %esi
80107505:	5d                   	pop    %ebp
80107506:	c3                   	ret
80107507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010750e:	66 90                	xchg   %ax,%ax

80107510 <kvmalloc>:
{
80107510:	55                   	push   %ebp
80107511:	89 e5                	mov    %esp,%ebp
80107513:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107516:	e8 75 ff ff ff       	call   80107490 <setupkvm>
8010751b:	a3 24 61 11 80       	mov    %eax,0x80116124
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107520:	05 00 00 00 80       	add    $0x80000000,%eax
80107525:	0f 22 d8             	mov    %eax,%cr3
}
80107528:	c9                   	leave
80107529:	c3                   	ret
8010752a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107530 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107530:	55                   	push   %ebp
80107531:	89 e5                	mov    %esp,%ebp
80107533:	83 ec 08             	sub    $0x8,%esp
80107536:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107539:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010753c:	89 c1                	mov    %eax,%ecx
8010753e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107541:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107544:	f6 c2 01             	test   $0x1,%dl
80107547:	75 17                	jne    80107560 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107549:	83 ec 0c             	sub    $0xc,%esp
8010754c:	68 95 86 10 80       	push   $0x80108695
80107551:	e8 1a 8f ff ff       	call   80100470 <panic>
80107556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010755d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107560:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107563:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107569:	25 fc 0f 00 00       	and    $0xffc,%eax
8010756e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107575:	85 c0                	test   %eax,%eax
80107577:	74 d0                	je     80107549 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107579:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010757c:	c9                   	leave
8010757d:	c3                   	ret
8010757e:	66 90                	xchg   %ax,%ax

80107580 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107580:	55                   	push   %ebp
80107581:	89 e5                	mov    %esp,%ebp
80107583:	57                   	push   %edi
80107584:	56                   	push   %esi
80107585:	53                   	push   %ebx
80107586:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107589:	e8 02 ff ff ff       	call   80107490 <setupkvm>
8010758e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107591:	85 c0                	test   %eax,%eax
80107593:	0f 84 e9 00 00 00    	je     80107682 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107599:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010759c:	85 c9                	test   %ecx,%ecx
8010759e:	0f 84 b2 00 00 00    	je     80107656 <copyuvm+0xd6>
801075a4:	31 f6                	xor    %esi,%esi
801075a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801075b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801075b3:	89 f0                	mov    %esi,%eax
801075b5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801075b8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801075bb:	a8 01                	test   $0x1,%al
801075bd:	75 11                	jne    801075d0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801075bf:	83 ec 0c             	sub    $0xc,%esp
801075c2:	68 9f 86 10 80       	push   $0x8010869f
801075c7:	e8 a4 8e ff ff       	call   80100470 <panic>
801075cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801075d0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801075d7:	c1 ea 0a             	shr    $0xa,%edx
801075da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801075e0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801075e7:	85 c0                	test   %eax,%eax
801075e9:	74 d4                	je     801075bf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801075eb:	8b 00                	mov    (%eax),%eax
801075ed:	a8 01                	test   $0x1,%al
801075ef:	0f 84 9f 00 00 00    	je     80107694 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801075f5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801075f7:	25 ff 0f 00 00       	and    $0xfff,%eax
801075fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801075ff:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107605:	e8 c6 b1 ff ff       	call   801027d0 <kalloc>
8010760a:	89 c3                	mov    %eax,%ebx
8010760c:	85 c0                	test   %eax,%eax
8010760e:	74 64                	je     80107674 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107610:	83 ec 04             	sub    $0x4,%esp
80107613:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107619:	68 00 10 00 00       	push   $0x1000
8010761e:	57                   	push   %edi
8010761f:	50                   	push   %eax
80107620:	e8 db d5 ff ff       	call   80104c00 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107625:	58                   	pop    %eax
80107626:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010762c:	5a                   	pop    %edx
8010762d:	ff 75 e4             	push   -0x1c(%ebp)
80107630:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107635:	89 f2                	mov    %esi,%edx
80107637:	50                   	push   %eax
80107638:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010763b:	e8 60 f8 ff ff       	call   80106ea0 <mappages>
80107640:	83 c4 10             	add    $0x10,%esp
80107643:	85 c0                	test   %eax,%eax
80107645:	78 21                	js     80107668 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107647:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010764d:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107650:	0f 82 5a ff ff ff    	jb     801075b0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107656:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107659:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010765c:	5b                   	pop    %ebx
8010765d:	5e                   	pop    %esi
8010765e:	5f                   	pop    %edi
8010765f:	5d                   	pop    %ebp
80107660:	c3                   	ret
80107661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107668:	83 ec 0c             	sub    $0xc,%esp
8010766b:	53                   	push   %ebx
8010766c:	e8 2f af ff ff       	call   801025a0 <kfree>
      goto bad;
80107671:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107674:	83 ec 0c             	sub    $0xc,%esp
80107677:	ff 75 e0             	push   -0x20(%ebp)
8010767a:	e8 91 fd ff ff       	call   80107410 <freevm>
  return 0;
8010767f:	83 c4 10             	add    $0x10,%esp
    return 0;
80107682:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107689:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010768c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010768f:	5b                   	pop    %ebx
80107690:	5e                   	pop    %esi
80107691:	5f                   	pop    %edi
80107692:	5d                   	pop    %ebp
80107693:	c3                   	ret
      panic("copyuvm: page not present");
80107694:	83 ec 0c             	sub    $0xc,%esp
80107697:	68 b9 86 10 80       	push   $0x801086b9
8010769c:	e8 cf 8d ff ff       	call   80100470 <panic>
801076a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076af:	90                   	nop

801076b0 <copyuvm_cow>:
pde_t*
copyuvm_cow(pde_t *pgdir, uint sz, struct proc * p)
{
801076b0:	55                   	push   %ebp
801076b1:	89 e5                	mov    %esp,%ebp
801076b3:	57                   	push   %edi
801076b4:	56                   	push   %esi
801076b5:	53                   	push   %ebx
801076b6:	83 ec 1c             	sub    $0x1c,%esp
801076b9:	8b 75 10             	mov    0x10(%ebp),%esi
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  // char *mem;
  int * page_to_refcnt = get_refcnt_table();
801076bc:	e8 cf ae ff ff       	call   80102590 <get_refcnt_table>
801076c1:	89 45 e0             	mov    %eax,-0x20(%ebp)

  if((d = setupkvm()) == 0)
801076c4:	e8 c7 fd ff ff       	call   80107490 <setupkvm>
801076c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801076cc:	85 c0                	test   %eax,%eax
801076ce:	0f 84 ea 00 00 00    	je     801077be <copyuvm_cow+0x10e>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801076d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801076d7:	85 c0                	test   %eax,%eax
801076d9:	0f 84 ba 00 00 00    	je     80107799 <copyuvm_cow+0xe9>
801076df:	31 ff                	xor    %edi,%edi
801076e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*pde & PTE_P){
801076e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801076eb:	89 f8                	mov    %edi,%eax
    p->rss += PGSIZE;
801076ed:	81 46 04 00 10 00 00 	addl   $0x1000,0x4(%esi)
  pde = &pgdir[PDX(va)];
801076f4:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801076f7:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801076fa:	a8 01                	test   $0x1,%al
801076fc:	75 12                	jne    80107710 <copyuvm_cow+0x60>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801076fe:	83 ec 0c             	sub    $0xc,%esp
80107701:	68 9f 86 10 80       	push   $0x8010869f
80107706:	e8 65 8d ff ff       	call   80100470 <panic>
8010770b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010770f:	90                   	nop
  return &pgtab[PTX(va)];
80107710:	89 fa                	mov    %edi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107712:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107717:	c1 ea 0a             	shr    $0xa,%edx
8010771a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107720:	8d 94 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%edx
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107727:	85 d2                	test   %edx,%edx
80107729:	74 d3                	je     801076fe <copyuvm_cow+0x4e>
    // change here
    if(!(*pte & PTE_P))
8010772b:	8b 02                	mov    (%edx),%eax
8010772d:	a8 01                	test   $0x1,%al
8010772f:	0f 84 9b 00 00 00    	je     801077d0 <copyuvm_cow+0x120>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107735:	89 c3                	mov    %eax,%ebx
    // if((mem = kalloc()) == 0)
    //   goto bad;
    // memmove(mem, (char*)P2V(pa), PGSIZE);

    int new_flags = flags & ~PTE_W;
    *pte &= ~PTE_W;
80107737:	89 c1                	mov    %eax,%ecx
    if(mappages(d, (void*)i, PGSIZE, pa, new_flags) < 0) {
80107739:	83 ec 08             	sub    $0x8,%esp
    int new_flags = flags & ~PTE_W;
8010773c:	25 fd 0f 00 00       	and    $0xffd,%eax
    *pte &= ~PTE_W;
80107741:	83 e1 fd             	and    $0xfffffffd,%ecx
    pa = PTE_ADDR(*pte);
80107744:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    *pte &= ~PTE_W;
8010774a:	89 0a                	mov    %ecx,(%edx)
    if(mappages(d, (void*)i, PGSIZE, pa, new_flags) < 0) {
8010774c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107751:	89 fa                	mov    %edi,%edx
80107753:	50                   	push   %eax
80107754:	53                   	push   %ebx
80107755:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107758:	e8 43 f7 ff ff       	call   80106ea0 <mappages>
8010775d:	83 c4 10             	add    $0x10,%esp
80107760:	85 c0                	test   %eax,%eax
80107762:	78 4c                	js     801077b0 <copyuvm_cow+0x100>
      // kfree(mem);
      goto bad;
    }

    page_to_refcnt[pa >> PTXSHIFT]++;
80107764:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80107767:	89 d8                	mov    %ebx,%eax
80107769:	c1 eb 0a             	shr    $0xa,%ebx
    cprintf("copyuvm_cow: refcnt = %d of pageno %d\n", page_to_refcnt[pa >> PTXSHIFT], pa >> PTXSHIFT);
8010776c:	83 ec 04             	sub    $0x4,%esp
    page_to_refcnt[pa >> PTXSHIFT]++;
8010776f:	c1 e8 0c             	shr    $0xc,%eax
  for(i = 0; i < sz; i += PGSIZE){
80107772:	81 c7 00 10 00 00    	add    $0x1000,%edi
    page_to_refcnt[pa >> PTXSHIFT]++;
80107778:	01 cb                	add    %ecx,%ebx
8010777a:	8b 13                	mov    (%ebx),%edx
8010777c:	83 c2 01             	add    $0x1,%edx
8010777f:	89 13                	mov    %edx,(%ebx)
    cprintf("copyuvm_cow: refcnt = %d of pageno %d\n", page_to_refcnt[pa >> PTXSHIFT], pa >> PTXSHIFT);
80107781:	50                   	push   %eax
80107782:	52                   	push   %edx
80107783:	68 4c 89 10 80       	push   $0x8010894c
80107788:	e8 13 90 ff ff       	call   801007a0 <cprintf>
  for(i = 0; i < sz; i += PGSIZE){
8010778d:	83 c4 10             	add    $0x10,%esp
80107790:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107793:	0f 82 4f ff ff ff    	jb     801076e8 <copyuvm_cow+0x38>

  }

  lcr3(V2P(pgdir));
80107799:	8b 45 08             	mov    0x8(%ebp),%eax
8010779c:	05 00 00 00 80       	add    $0x80000000,%eax
801077a1:	0f 22 d8             	mov    %eax,%cr3
  return d;

bad:
  freevm(d);
  return 0;
}
801077a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077aa:	5b                   	pop    %ebx
801077ab:	5e                   	pop    %esi
801077ac:	5f                   	pop    %edi
801077ad:	5d                   	pop    %ebp
801077ae:	c3                   	ret
801077af:	90                   	nop
  freevm(d);
801077b0:	83 ec 0c             	sub    $0xc,%esp
801077b3:	ff 75 e4             	push   -0x1c(%ebp)
801077b6:	e8 55 fc ff ff       	call   80107410 <freevm>
  return 0;
801077bb:	83 c4 10             	add    $0x10,%esp
    return 0;
801077be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801077c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077cb:	5b                   	pop    %ebx
801077cc:	5e                   	pop    %esi
801077cd:	5f                   	pop    %edi
801077ce:	5d                   	pop    %ebp
801077cf:	c3                   	ret
      panic("copyuvm: page not present");
801077d0:	83 ec 0c             	sub    $0xc,%esp
801077d3:	68 b9 86 10 80       	push   $0x801086b9
801077d8:	e8 93 8c ff ff       	call   80100470 <panic>
801077dd:	8d 76 00             	lea    0x0(%esi),%esi

801077e0 <freevm_proc>:
void
freevm_proc(struct proc * p, pde_t *pgdir)
{
801077e0:	55                   	push   %ebp
801077e1:	89 e5                	mov    %esp,%ebp
801077e3:	57                   	push   %edi
801077e4:	56                   	push   %esi
801077e5:	53                   	push   %ebx
801077e6:	83 ec 0c             	sub    $0xc,%esp
801077e9:	8b 75 0c             	mov    0xc(%ebp),%esi
801077ec:	8b 45 08             	mov    0x8(%ebp),%eax
  uint i;

  if(pgdir == 0)
801077ef:	85 f6                	test   %esi,%esi
801077f1:	74 5e                	je     80107851 <freevm_proc+0x71>
  if(newsz >= oldsz)
801077f3:	83 ec 0c             	sub    $0xc,%esp
801077f6:	b9 00 00 00 80       	mov    $0x80000000,%ecx
801077fb:	89 f2                	mov    %esi,%edx
801077fd:	89 f3                	mov    %esi,%ebx
801077ff:	6a 00                	push   $0x0
80107801:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107807:	e8 b4 f4 ff ff       	call   80106cc0 <deallocuvm_proc.part.0>
    panic("freevm: no pgdir");
  deallocuvm_proc(p, pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010780c:	83 c4 10             	add    $0x10,%esp
8010780f:	eb 0e                	jmp    8010781f <freevm_proc+0x3f>
80107811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107818:	83 c3 04             	add    $0x4,%ebx
8010781b:	39 fb                	cmp    %edi,%ebx
8010781d:	74 23                	je     80107842 <freevm_proc+0x62>
    if(pgdir[i] & PTE_P){
8010781f:	8b 03                	mov    (%ebx),%eax
80107821:	a8 01                	test   $0x1,%al
80107823:	74 f3                	je     80107818 <freevm_proc+0x38>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107825:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
8010782a:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010782d:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107830:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107835:	50                   	push   %eax
80107836:	e8 65 ad ff ff       	call   801025a0 <kfree>
8010783b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010783e:	39 fb                	cmp    %edi,%ebx
80107840:	75 dd                	jne    8010781f <freevm_proc+0x3f>
    }
  }
  kfree((char*)pgdir);
80107842:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107845:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107848:	5b                   	pop    %ebx
80107849:	5e                   	pop    %esi
8010784a:	5f                   	pop    %edi
8010784b:	5d                   	pop    %ebp
  kfree((char*)pgdir);
8010784c:	e9 4f ad ff ff       	jmp    801025a0 <kfree>
    panic("freevm: no pgdir");
80107851:	83 ec 0c             	sub    $0xc,%esp
80107854:	68 84 86 10 80       	push   $0x80108684
80107859:	e8 12 8c ff ff       	call   80100470 <panic>
8010785e:	66 90                	xchg   %ax,%ax

80107860 <clear_zombie>:
void clear_zombie(struct proc * p){
80107860:	55                   	push   %ebp
80107861:	89 e5                	mov    %esp,%ebp
80107863:	57                   	push   %edi
80107864:	56                   	push   %esi
80107865:	53                   	push   %ebx
80107866:	83 ec 1c             	sub    $0x1c,%esp
80107869:	8b 45 08             	mov    0x8(%ebp),%eax
8010786c:	8b 70 08             	mov    0x8(%eax),%esi
8010786f:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
80107875:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107878:	eb 10                	jmp    8010788a <clear_zombie+0x2a>
8010787a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  pde_t * pgdir = p->pgdir;
  for(int i = 0 ; i < NPDENTRIES; i++){
80107880:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107883:	83 c6 04             	add    $0x4,%esi
80107886:	39 c6                	cmp    %eax,%esi
80107888:	74 43                	je     801078cd <clear_zombie+0x6d>
    if(pgdir[i] & PTE_P){
8010788a:	8b 16                	mov    (%esi),%edx
8010788c:	f6 c2 01             	test   $0x1,%dl
8010788f:	74 ef                	je     80107880 <clear_zombie+0x20>
      pte_t* pte = (pte_t*) P2V(PTE_ADDR(pgdir[i]));
80107891:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107897:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
      for(int j= 0 ; j < NPTENTRIES; j++){
8010789d:	8d ba 00 10 00 80    	lea    -0x7ffff000(%edx),%edi
801078a3:	eb 0a                	jmp    801078af <clear_zombie+0x4f>
801078a5:	8d 76 00             	lea    0x0(%esi),%esi
801078a8:	83 c3 04             	add    $0x4,%ebx
801078ab:	39 df                	cmp    %ebx,%edi
801078ad:	74 d1                	je     80107880 <clear_zombie+0x20>
        if(!(pte[j] & PTE_P) && (pte[j] & PTE_SW)){
801078af:	8b 03                	mov    (%ebx),%eax
801078b1:	83 e0 09             	and    $0x9,%eax
801078b4:	83 f8 08             	cmp    $0x8,%eax
801078b7:	75 ef                	jne    801078a8 <clear_zombie+0x48>
          clear_slot(&pte[j]);
801078b9:	83 ec 0c             	sub    $0xc,%esp
801078bc:	53                   	push   %ebx
801078bd:	e8 7e 06 00 00       	call   80107f40 <clear_slot>
          pte[j] = 0;
801078c2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801078c8:	83 c4 10             	add    $0x10,%esp
801078cb:	eb db                	jmp    801078a8 <clear_zombie+0x48>
        }
      }
    }
  }
}
801078cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078d0:	5b                   	pop    %ebx
801078d1:	5e                   	pop    %esi
801078d2:	5f                   	pop    %edi
801078d3:	5d                   	pop    %ebp
801078d4:	c3                   	ret
801078d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801078e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801078e0:	55                   	push   %ebp
801078e1:	89 e5                	mov    %esp,%ebp
801078e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801078e6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801078e9:	89 c1                	mov    %eax,%ecx
801078eb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801078ee:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801078f1:	f6 c2 01             	test   $0x1,%dl
801078f4:	0f 84 f8 00 00 00    	je     801079f2 <uva2ka.cold>
  return &pgtab[PTX(va)];
801078fa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078fd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107903:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107904:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107909:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107910:	89 d0                	mov    %edx,%eax
80107912:	f7 d2                	not    %edx
80107914:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107919:	05 00 00 00 80       	add    $0x80000000,%eax
8010791e:	83 e2 05             	and    $0x5,%edx
80107921:	ba 00 00 00 00       	mov    $0x0,%edx
80107926:	0f 45 c2             	cmovne %edx,%eax
}
80107929:	c3                   	ret
8010792a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107930 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107930:	55                   	push   %ebp
80107931:	89 e5                	mov    %esp,%ebp
80107933:	57                   	push   %edi
80107934:	56                   	push   %esi
80107935:	53                   	push   %ebx
80107936:	83 ec 0c             	sub    $0xc,%esp
80107939:	8b 75 14             	mov    0x14(%ebp),%esi
8010793c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010793f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107942:	85 f6                	test   %esi,%esi
80107944:	75 51                	jne    80107997 <copyout+0x67>
80107946:	e9 9d 00 00 00       	jmp    801079e8 <copyout+0xb8>
8010794b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010794f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107950:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107956:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010795c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107962:	74 74                	je     801079d8 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80107964:	89 fb                	mov    %edi,%ebx
80107966:	29 c3                	sub    %eax,%ebx
80107968:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010796e:	39 f3                	cmp    %esi,%ebx
80107970:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107973:	29 f8                	sub    %edi,%eax
80107975:	83 ec 04             	sub    $0x4,%esp
80107978:	01 c1                	add    %eax,%ecx
8010797a:	53                   	push   %ebx
8010797b:	52                   	push   %edx
8010797c:	89 55 10             	mov    %edx,0x10(%ebp)
8010797f:	51                   	push   %ecx
80107980:	e8 7b d2 ff ff       	call   80104c00 <memmove>
    len -= n;
    buf += n;
80107985:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107988:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010798e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107991:	01 da                	add    %ebx,%edx
  while(len > 0){
80107993:	29 de                	sub    %ebx,%esi
80107995:	74 51                	je     801079e8 <copyout+0xb8>
  if(*pde & PTE_P){
80107997:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010799a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010799c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010799e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801079a1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801079a7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801079aa:	f6 c1 01             	test   $0x1,%cl
801079ad:	0f 84 46 00 00 00    	je     801079f9 <copyout.cold>
  return &pgtab[PTX(va)];
801079b3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079b5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801079bb:	c1 eb 0c             	shr    $0xc,%ebx
801079be:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801079c4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801079cb:	89 d9                	mov    %ebx,%ecx
801079cd:	f7 d1                	not    %ecx
801079cf:	83 e1 05             	and    $0x5,%ecx
801079d2:	0f 84 78 ff ff ff    	je     80107950 <copyout+0x20>
  }
  return 0;
}
801079d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801079db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079e0:	5b                   	pop    %ebx
801079e1:	5e                   	pop    %esi
801079e2:	5f                   	pop    %edi
801079e3:	5d                   	pop    %ebp
801079e4:	c3                   	ret
801079e5:	8d 76 00             	lea    0x0(%esi),%esi
801079e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079eb:	31 c0                	xor    %eax,%eax
}
801079ed:	5b                   	pop    %ebx
801079ee:	5e                   	pop    %esi
801079ef:	5f                   	pop    %edi
801079f0:	5d                   	pop    %ebp
801079f1:	c3                   	ret

801079f2 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801079f2:	a1 00 00 00 00       	mov    0x0,%eax
801079f7:	0f 0b                	ud2

801079f9 <copyout.cold>:
801079f9:	a1 00 00 00 00       	mov    0x0,%eax
801079fe:	0f 0b                	ud2

80107a00 <cow_fault>:
#include "spinlock.h"


void cow_fault(){
	// create new page entry when page fault occurs due to cow
80107a00:	c3                   	ret
80107a01:	66 90                	xchg   %ax,%ax
80107a03:	66 90                	xchg   %ax,%ax
80107a05:	66 90                	xchg   %ax,%ax
80107a07:	66 90                	xchg   %ax,%ax
80107a09:	66 90                	xchg   %ax,%ax
80107a0b:	66 90                	xchg   %ax,%ax
80107a0d:	66 90                	xchg   %ax,%ax
80107a0f:	90                   	nop

80107a10 <swapinit>:

#define SWAPBASE 2
#define NPAGE (SWAPBLOCKS / BPPAGE)

struct swapslothdr swap_slots[NPAGE];
void swapinit(void){
80107a10:	55                   	push   %ebp
80107a11:	b8 40 61 11 80       	mov    $0x80116140,%eax
80107a16:	ba 02 00 00 00       	mov    $0x2,%edx
80107a1b:	89 e5                	mov    %esp,%ebp
80107a1d:	83 ec 08             	sub    $0x8,%esp
	for(int i = 0 ; i < NPAGE ; i++){
		swap_slots[i].is_free = FREE;
		swap_slots[i].page_perm = 0;
		swap_slots[i].blockno = SWAPBASE + i * BPPAGE;
80107a20:	89 50 08             	mov    %edx,0x8(%eax)
	for(int i = 0 ; i < NPAGE ; i++){
80107a23:	05 10 02 00 00       	add    $0x210,%eax
80107a28:	83 c2 08             	add    $0x8,%edx
		swap_slots[i].is_free = FREE;
80107a2b:	c7 80 f0 fd ff ff 01 	movl   $0x1,-0x210(%eax)
80107a32:	00 00 00 
		swap_slots[i].page_perm = 0;
80107a35:	c7 80 f4 fd ff ff 00 	movl   $0x0,-0x20c(%eax)
80107a3c:	00 00 00 
	for(int i = 0 ; i < NPAGE ; i++){
80107a3f:	3d 40 9a 14 80       	cmp    $0x80149a40,%eax
80107a44:	75 da                	jne    80107a20 <swapinit+0x10>
	}
	cprintf("Swap slots initialized\n");
80107a46:	83 ec 0c             	sub    $0xc,%esp
80107a49:	68 d3 86 10 80       	push   $0x801086d3
80107a4e:	e8 4d 8d ff ff       	call   801007a0 <cprintf>
}
80107a53:	83 c4 10             	add    $0x10,%esp
80107a56:	c9                   	leave
80107a57:	c3                   	ret
80107a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a5f:	90                   	nop

80107a60 <swap_info_on_hdr>:

void swap_info_on_hdr(uint pa, uint slot_num){
80107a60:	55                   	push   %ebp
80107a61:	89 e5                	mov    %esp,%ebp
80107a63:	57                   	push   %edi
80107a64:	56                   	push   %esi
80107a65:	53                   	push   %ebx
80107a66:	83 ec 1c             	sub    $0x1c,%esp
80107a69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    swap_slots[slot_num].refcnt_to_disk = page_to_ref_cnt[pa>>PTXSHIFT];
80107a6c:	8b 55 08             	mov    0x8(%ebp),%edx
80107a6f:	69 d9 10 02 00 00    	imul   $0x210,%ecx,%ebx
80107a75:	c1 ea 0c             	shr    $0xc,%edx
80107a78:	8b 04 95 40 9a 1c 80 	mov    -0x7fe365c0(,%edx,4),%eax
80107a7f:	89 83 4c 61 11 80    	mov    %eax,-0x7fee9eb4(%ebx)
80107a85:	81 c3 40 61 11 80    	add    $0x80116140,%ebx

    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
80107a8b:	85 c0                	test   %eax,%eax
80107a8d:	74 70                	je     80107aff <swap_info_on_hdr+0x9f>
        pte_t *pte = page_to_ptes_map[pa >> PTXSHIFT][i];
        swap_slots[slot_num].proc_pte_refs[i] = pte;
        swap_slots[slot_num].proc_pid_refs[i] = page_to_proc_pid_map[pa >> PTXSHIFT][i];
        *pte = (slot_num << PTXSHIFT) | PTE_FLAGS(*pte) | PTE_SW;
80107a8f:	c1 e1 0c             	shl    $0xc,%ecx
80107a92:	89 d6                	mov    %edx,%esi
    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
80107a94:	89 55 dc             	mov    %edx,-0x24(%ebp)
80107a97:	89 d8                	mov    %ebx,%eax
        *pte = (slot_num << PTXSHIFT) | PTE_FLAGS(*pte) | PTE_SW;
80107a99:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107a9c:	c1 e6 08             	shl    $0x8,%esi
    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
80107a9f:	31 ff                	xor    %edi,%edi
80107aa1:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80107aa4:	89 f3                	mov    %esi,%ebx
80107aa6:	89 c6                	mov    %eax,%esi
80107aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107aaf:	90                   	nop
        pte_t *pte = page_to_ptes_map[pa >> PTXSHIFT][i];
80107ab0:	8b 94 bb 40 9a 18 80 	mov    -0x7fe765c0(%ebx,%edi,4),%edx
        *pte &= (~PTE_P);
80107ab7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
	update_rss(swap_slots[slot_num].proc_pid_refs[i], -PGSIZE);
80107aba:	83 ec 08             	sub    $0x8,%esp
    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
80107abd:	83 c6 04             	add    $0x4,%esi
        swap_slots[slot_num].proc_pid_refs[i] = page_to_proc_pid_map[pa >> PTXSHIFT][i];
80107ac0:	8b 84 bb 40 9a 14 80 	mov    -0x7feb65c0(%ebx,%edi,4),%eax
    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
80107ac7:	83 c7 01             	add    $0x1,%edi
        swap_slots[slot_num].proc_pte_refs[i] = pte;
80107aca:	89 56 0c             	mov    %edx,0xc(%esi)
        swap_slots[slot_num].proc_pid_refs[i] = page_to_proc_pid_map[pa >> PTXSHIFT][i];
80107acd:	89 86 0c 01 00 00    	mov    %eax,0x10c(%esi)
        *pte = (slot_num << PTXSHIFT) | PTE_FLAGS(*pte) | PTE_SW;
80107ad3:	8b 02                	mov    (%edx),%eax
80107ad5:	25 fe 0f 00 00       	and    $0xffe,%eax
        *pte &= (~PTE_P);
80107ada:	09 c8                	or     %ecx,%eax
80107adc:	83 c8 08             	or     $0x8,%eax
80107adf:	89 02                	mov    %eax,(%edx)
	update_rss(swap_slots[slot_num].proc_pid_refs[i], -PGSIZE);
80107ae1:	68 00 f0 ff ff       	push   $0xfffff000
80107ae6:	ff b6 0c 01 00 00    	push   0x10c(%esi)
80107aec:	e8 1f cc ff ff       	call   80104710 <update_rss>
    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
80107af1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107af4:	83 c4 10             	add    $0x10,%esp
80107af7:	3b 78 0c             	cmp    0xc(%eax),%edi
80107afa:	72 b4                	jb     80107ab0 <swap_info_on_hdr+0x50>
80107afc:	8b 55 dc             	mov    -0x24(%ebp),%edx
    }
	page_to_ref_cnt[pa >> PTXSHIFT] = 0; // no longer on the memory
80107aff:	c7 04 95 40 9a 1c 80 	movl   $0x0,-0x7fe365c0(,%edx,4)
80107b06:	00 00 00 00 
}
80107b0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b0d:	5b                   	pop    %ebx
80107b0e:	5e                   	pop    %esi
80107b0f:	5f                   	pop    %edi
80107b10:	5d                   	pop    %ebp
80107b11:	c3                   	ret
80107b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107b20 <get_hdrs_from_disk>:

void get_hdrs_from_disk(uint pa, uint slot_num)
{
80107b20:	55                   	push   %ebp
80107b21:	89 e5                	mov    %esp,%ebp
80107b23:	57                   	push   %edi
80107b24:	56                   	push   %esi
80107b25:	53                   	push   %ebx
80107b26:	83 ec 1c             	sub    $0x1c,%esp
    page_to_ref_cnt[pa >> PTXSHIFT]  = swap_slots[slot_num].refcnt_to_disk;
80107b29:	69 7d 0c 10 02 00 00 	imul   $0x210,0xc(%ebp),%edi
80107b30:	8b 75 08             	mov    0x8(%ebp),%esi
80107b33:	c1 ee 0c             	shr    $0xc,%esi
80107b36:	8b 87 4c 61 11 80    	mov    -0x7fee9eb4(%edi),%eax
80107b3c:	89 04 b5 40 9a 1c 80 	mov    %eax,-0x7fe365c0(,%esi,4)
    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
80107b43:	85 c0                	test   %eax,%eax
80107b45:	74 63                	je     80107baa <get_hdrs_from_disk+0x8a>
80107b47:	8d 8f 40 61 11 80    	lea    -0x7fee9ec0(%edi),%ecx
80107b4d:	c1 e6 08             	shl    $0x8,%esi
80107b50:	89 f8                	mov    %edi,%eax
80107b52:	31 db                	xor    %ebx,%ebx
80107b54:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107b57:	89 f7                	mov    %esi,%edi
80107b59:	89 c6                	mov    %eax,%esi
80107b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107b5f:	90                   	nop
        pte_t *pte = swap_slots[slot_num].proc_pte_refs[i];
80107b60:	8b 94 9e 50 61 11 80 	mov    -0x7fee9eb0(%esi,%ebx,4),%edx
        *pte = pa | (PTE_FLAGS(*pte)) | PTE_P;
        *pte &= ~PTE_SW;
        page_to_ptes_map[pa >> PTXSHIFT][i] = pte;
        page_to_proc_pid_map[pa >> PTXSHIFT][i] = swap_slots[slot_num].proc_pid_refs[i];
	update_rss(swap_slots[slot_num].proc_pid_refs[i], PGSIZE);
80107b67:	83 ec 08             	sub    $0x8,%esp
        *pte = pa | (PTE_FLAGS(*pte)) | PTE_P;
80107b6a:	8b 02                	mov    (%edx),%eax
80107b6c:	25 ff 0f 00 00       	and    $0xfff,%eax
80107b71:	0b 45 08             	or     0x8(%ebp),%eax
        *pte &= ~PTE_SW;
80107b74:	83 e0 f7             	and    $0xfffffff7,%eax
80107b77:	83 c8 01             	or     $0x1,%eax
80107b7a:	89 02                	mov    %eax,(%edx)
        page_to_proc_pid_map[pa >> PTXSHIFT][i] = swap_slots[slot_num].proc_pid_refs[i];
80107b7c:	8b 84 9e 50 62 11 80 	mov    -0x7fee9db0(%esi,%ebx,4),%eax
        page_to_ptes_map[pa >> PTXSHIFT][i] = pte;
80107b83:	89 94 9f 40 9a 18 80 	mov    %edx,-0x7fe765c0(%edi,%ebx,4)
        page_to_proc_pid_map[pa >> PTXSHIFT][i] = swap_slots[slot_num].proc_pid_refs[i];
80107b8a:	89 84 9f 40 9a 14 80 	mov    %eax,-0x7feb65c0(%edi,%ebx,4)
    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
80107b91:	83 c3 01             	add    $0x1,%ebx
	update_rss(swap_slots[slot_num].proc_pid_refs[i], PGSIZE);
80107b94:	68 00 10 00 00       	push   $0x1000
80107b99:	50                   	push   %eax
80107b9a:	e8 71 cb ff ff       	call   80104710 <update_rss>
    for (uint i = 0; i < swap_slots[slot_num].refcnt_to_disk; i++){
80107b9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ba2:	83 c4 10             	add    $0x10,%esp
80107ba5:	3b 58 0c             	cmp    0xc(%eax),%ebx
80107ba8:	72 b6                	jb     80107b60 <get_hdrs_from_disk+0x40>
    }
}
80107baa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bad:	5b                   	pop    %ebx
80107bae:	5e                   	pop    %esi
80107baf:	5f                   	pop    %edi
80107bb0:	5d                   	pop    %ebp
80107bb1:	c3                   	ret
80107bb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107bc0 <inc_refcnt_in_memory>:
  }
  return &pgtab[PTX(va)];
}


void inc_refcnt_in_memory(uint pa, pte_t* pte, int pid){
80107bc0:	55                   	push   %ebp
80107bc1:	89 e5                	mov    %esp,%ebp
80107bc3:	56                   	push   %esi
    // acquiresleep(&reflock);
    page_to_ptes_map[pa >> PTXSHIFT][page_to_ref_cnt[pa>>12]] = pte;
80107bc4:	8b 45 08             	mov    0x8(%ebp),%eax
80107bc7:	8b 75 0c             	mov    0xc(%ebp),%esi
void inc_refcnt_in_memory(uint pa, pte_t* pte, int pid){
80107bca:	53                   	push   %ebx
80107bcb:	8b 5d 10             	mov    0x10(%ebp),%ebx
    page_to_proc_pid_map[pa >> PTXSHIFT][page_to_ref_cnt[pa >> PTXSHIFT]] = pid;
    // cprintf("incrementing pid: %d", pid);
    page_to_ref_cnt[pa >> PTXSHIFT] += 1;
    update_rss(pid, PGSIZE);
80107bce:	c7 45 0c 00 10 00 00 	movl   $0x1000,0xc(%ebp)
    page_to_ptes_map[pa >> PTXSHIFT][page_to_ref_cnt[pa>>12]] = pte;
80107bd5:	c1 e8 0c             	shr    $0xc,%eax
80107bd8:	8b 14 85 40 9a 1c 80 	mov    -0x7fe365c0(,%eax,4),%edx
80107bdf:	89 c1                	mov    %eax,%ecx
    update_rss(pid, PGSIZE);
80107be1:	89 5d 08             	mov    %ebx,0x8(%ebp)
    page_to_ptes_map[pa >> PTXSHIFT][page_to_ref_cnt[pa>>12]] = pte;
80107be4:	c1 e1 06             	shl    $0x6,%ecx
80107be7:	01 d1                	add    %edx,%ecx
    page_to_ref_cnt[pa >> PTXSHIFT] += 1;
80107be9:	83 c2 01             	add    $0x1,%edx
    page_to_ptes_map[pa >> PTXSHIFT][page_to_ref_cnt[pa>>12]] = pte;
80107bec:	89 34 8d 40 9a 18 80 	mov    %esi,-0x7fe765c0(,%ecx,4)
    page_to_proc_pid_map[pa >> PTXSHIFT][page_to_ref_cnt[pa >> PTXSHIFT]] = pid;
80107bf3:	89 1c 8d 40 9a 14 80 	mov    %ebx,-0x7feb65c0(,%ecx,4)
    // releasesleep(&reflock);
    // cprintf("incremented %x to %x with pte:%x\n", pa, rmap[pa >> 12], pte);
}
80107bfa:	5b                   	pop    %ebx
80107bfb:	5e                   	pop    %esi
80107bfc:	5d                   	pop    %ebp
    page_to_ref_cnt[pa >> PTXSHIFT] += 1;
80107bfd:	89 14 85 40 9a 1c 80 	mov    %edx,-0x7fe365c0(,%eax,4)
    update_rss(pid, PGSIZE);
80107c04:	e9 07 cb ff ff       	jmp    80104710 <update_rss>
80107c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107c10 <inc_refcnt_in_hdr>:


void inc_refcnt_in_hdr(int slot_no_i, pte_t *pte, int pid)
{
80107c10:	55                   	push   %ebp
80107c11:	89 e5                	mov    %esp,%ebp
80107c13:	53                   	push   %ebx
80107c14:	8b 45 08             	mov    0x8(%ebp),%eax
    swap_slots[slot_no_i].proc_pte_refs[swap_slots[slot_no_i].refcnt_to_disk] = pte;
80107c17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80107c1a:	69 d0 10 02 00 00    	imul   $0x210,%eax,%edx
80107c20:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
80107c26:	8b 8a 4c 61 11 80    	mov    -0x7fee9eb4(%edx),%ecx
80107c2c:	01 c8                	add    %ecx,%eax
    swap_slots[slot_no_i].proc_pid_refs[swap_slots[slot_no_i].refcnt_to_disk] = pid;
    swap_slots[slot_no_i].refcnt_to_disk += 1;
80107c2e:	83 c1 01             	add    $0x1,%ecx
    swap_slots[slot_no_i].proc_pte_refs[swap_slots[slot_no_i].refcnt_to_disk] = pte;
80107c31:	89 1c 85 50 61 11 80 	mov    %ebx,-0x7fee9eb0(,%eax,4)
    swap_slots[slot_no_i].proc_pid_refs[swap_slots[slot_no_i].refcnt_to_disk] = pid;
80107c38:	8b 5d 10             	mov    0x10(%ebp),%ebx
    swap_slots[slot_no_i].refcnt_to_disk += 1;
80107c3b:	89 8a 4c 61 11 80    	mov    %ecx,-0x7fee9eb4(%edx)
    swap_slots[slot_no_i].proc_pid_refs[swap_slots[slot_no_i].refcnt_to_disk] = pid;
80107c41:	89 1c 85 50 62 11 80 	mov    %ebx,-0x7fee9db0(,%eax,4)
}
80107c48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107c4b:	c9                   	leave
80107c4c:	c3                   	ret
80107c4d:	8d 76 00             	lea    0x0(%esi),%esi

80107c50 <dec_refcnt_in_memory>:
void dec_refcnt_in_memory(uint pa, pte_t* pte)
{
80107c50:	55                   	push   %ebp
80107c51:	89 e5                	mov    %esp,%ebp
80107c53:	56                   	push   %esi
80107c54:	53                   	push   %ebx
    for (int i = 0; i < page_to_ref_cnt[pa>>PTXSHIFT]; i++){
80107c55:	8b 75 08             	mov    0x8(%ebp),%esi
80107c58:	c1 ee 0c             	shr    $0xc,%esi
80107c5b:	8b 04 b5 40 9a 1c 80 	mov    -0x7fe365c0(,%esi,4),%eax
80107c62:	85 c0                	test   %eax,%eax
80107c64:	74 7f                	je     80107ce5 <dec_refcnt_in_memory+0x95>
        if (page_to_ptes_map[pa>>PTXSHIFT][i] == pte){
80107c66:	89 f3                	mov    %esi,%ebx
80107c68:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c6b:	c1 e3 08             	shl    $0x8,%ebx
80107c6e:	39 83 40 9a 18 80    	cmp    %eax,-0x7fe765c0(%ebx)
80107c74:	74 0a                	je     80107c80 <dec_refcnt_in_memory+0x30>
		page_to_ref_cnt[pa >> PTXSHIFT] -= 1;
        }
	return;
    }
	panic("pte not found in decrementing");
}
80107c76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107c79:	5b                   	pop    %ebx
80107c7a:	5e                   	pop    %esi
80107c7b:	5d                   	pop    %ebp
80107c7c:	c3                   	ret
80107c7d:	8d 76 00             	lea    0x0(%esi),%esi
		update_rss(page_to_proc_pid_map[pa >> PTXSHIFT][i], -PGSIZE);
80107c80:	83 ec 08             	sub    $0x8,%esp
80107c83:	68 00 f0 ff ff       	push   $0xfffff000
80107c88:	ff b3 40 9a 14 80    	push   -0x7feb65c0(%ebx)
80107c8e:	e8 7d ca ff ff       	call   80104710 <update_rss>
		for (int j = i; j < page_to_ref_cnt[pa >> PTXSHIFT] - 1; j++)
80107c93:	8b 14 b5 40 9a 1c 80 	mov    -0x7fe365c0(,%esi,4),%edx
80107c9a:	83 c4 10             	add    $0x10,%esp
80107c9d:	89 d1                	mov    %edx,%ecx
80107c9f:	83 e9 01             	sub    $0x1,%ecx
80107ca2:	74 33                	je     80107cd7 <dec_refcnt_in_memory+0x87>
80107ca4:	89 d8                	mov    %ebx,%eax
80107ca6:	89 f3                	mov    %esi,%ebx
80107ca8:	c1 e3 06             	shl    $0x6,%ebx
80107cab:	8d 9c 1a ff ff ff 3f 	lea    0x3fffffff(%edx,%ebx,1),%ebx
80107cb2:	c1 e3 02             	shl    $0x2,%ebx
80107cb5:	8d 76 00             	lea    0x0(%esi),%esi
			page_to_ptes_map[pa >> PTXSHIFT][j] = page_to_ptes_map[pa >> PTXSHIFT][j + 1];
80107cb8:	8b 90 44 9a 18 80    	mov    -0x7fe765bc(%eax),%edx
		for (int j = i; j < page_to_ref_cnt[pa >> PTXSHIFT] - 1; j++)
80107cbe:	83 c0 04             	add    $0x4,%eax
			page_to_ptes_map[pa >> PTXSHIFT][j] = page_to_ptes_map[pa >> PTXSHIFT][j + 1];
80107cc1:	89 90 3c 9a 18 80    	mov    %edx,-0x7fe765c4(%eax)
			page_to_proc_pid_map[pa >> PTXSHIFT][j] = page_to_proc_pid_map[pa >> PTXSHIFT][j + 1];
80107cc7:	8b 90 40 9a 14 80    	mov    -0x7feb65c0(%eax),%edx
80107ccd:	89 90 3c 9a 14 80    	mov    %edx,-0x7feb65c4(%eax)
		for (int j = i; j < page_to_ref_cnt[pa >> PTXSHIFT] - 1; j++)
80107cd3:	39 c3                	cmp    %eax,%ebx
80107cd5:	75 e1                	jne    80107cb8 <dec_refcnt_in_memory+0x68>
		page_to_ref_cnt[pa >> PTXSHIFT] -= 1;
80107cd7:	89 0c b5 40 9a 1c 80 	mov    %ecx,-0x7fe365c0(,%esi,4)
}
80107cde:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ce1:	5b                   	pop    %ebx
80107ce2:	5e                   	pop    %esi
80107ce3:	5d                   	pop    %ebp
80107ce4:	c3                   	ret
	panic("pte not found in decrementing");
80107ce5:	83 ec 0c             	sub    $0xc,%esp
80107ce8:	68 eb 86 10 80       	push   $0x801086eb
80107ced:	e8 7e 87 ff ff       	call   80100470 <panic>
80107cf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107d00 <dec_refcnt_in_hdr>:

void dec_refcnt_in_hdr(int slot_no_i, pte_t *pte)
{
80107d00:	55                   	push   %ebp
80107d01:	89 e5                	mov    %esp,%ebp
80107d03:	56                   	push   %esi
80107d04:	53                   	push   %ebx
80107d05:	8b 4d 08             	mov    0x8(%ebp),%ecx

    for (int i = 0; i < swap_slots[slot_no_i].refcnt_to_disk; i++)
80107d08:	69 f1 10 02 00 00    	imul   $0x210,%ecx,%esi
80107d0e:	8d 86 40 61 11 80    	lea    -0x7fee9ec0(%esi),%eax
80107d14:	8b 50 0c             	mov    0xc(%eax),%edx
80107d17:	85 d2                	test   %edx,%edx
80107d19:	7e 7d                	jle    80107d98 <dec_refcnt_in_hdr+0x98>
    {
        if (swap_slots[slot_no_i].proc_pte_refs[i] == pte)
80107d1b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80107d1e:	39 58 10             	cmp    %ebx,0x10(%eax)
80107d21:	74 0d                	je     80107d30 <dec_refcnt_in_hdr+0x30>
        }
	return;
    }
	// cprintf("%x %x\n", pte, *pte);
	panic("pte not found in decrementing");
}
80107d23:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d26:	5b                   	pop    %ebx
80107d27:	5e                   	pop    %esi
80107d28:	5d                   	pop    %ebp
80107d29:	c3                   	ret
80107d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		for (int j = i; j < swap_slots[slot_no_i].refcnt_to_disk - 1; j++)
80107d30:	89 d3                	mov    %edx,%ebx
80107d32:	83 eb 01             	sub    $0x1,%ebx
80107d35:	74 49                	je     80107d80 <dec_refcnt_in_hdr+0x80>
80107d37:	69 f1 84 00 00 00    	imul   $0x84,%ecx,%esi
80107d3d:	01 f2                	add    %esi,%edx
80107d3f:	8d 34 95 3c 61 11 80 	lea    -0x7fee9ec4(,%edx,4),%esi
80107d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d4d:	8d 76 00             	lea    0x0(%esi),%esi
			swap_slots[slot_no_i].proc_pid_refs[j] = swap_slots[slot_no_i].proc_pid_refs[j + 1];
80107d50:	8b 90 14 01 00 00    	mov    0x114(%eax),%edx
		for (int j = i; j < swap_slots[slot_no_i].refcnt_to_disk - 1; j++)
80107d56:	83 c0 04             	add    $0x4,%eax
			swap_slots[slot_no_i].proc_pid_refs[j] = swap_slots[slot_no_i].proc_pid_refs[j + 1];
80107d59:	89 90 0c 01 00 00    	mov    %edx,0x10c(%eax)
			swap_slots[slot_no_i].proc_pte_refs[j] = swap_slots[slot_no_i].proc_pte_refs[j + 1];
80107d5f:	8b 50 10             	mov    0x10(%eax),%edx
80107d62:	89 50 0c             	mov    %edx,0xc(%eax)
		for (int j = i; j < swap_slots[slot_no_i].refcnt_to_disk - 1; j++)
80107d65:	39 f0                	cmp    %esi,%eax
80107d67:	75 e7                	jne    80107d50 <dec_refcnt_in_hdr+0x50>
		swap_slots[slot_no_i].refcnt_to_disk -= 1;
80107d69:	69 c9 10 02 00 00    	imul   $0x210,%ecx,%ecx
80107d6f:	89 99 4c 61 11 80    	mov    %ebx,-0x7fee9eb4(%ecx)
}
80107d75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d78:	5b                   	pop    %ebx
80107d79:	5e                   	pop    %esi
80107d7a:	5d                   	pop    %ebp
80107d7b:	c3                   	ret
80107d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		swap_slots[slot_no_i].refcnt_to_disk -= 1;
80107d80:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			swap_slots[slot_no_i].is_free = FREE;
80107d87:	c7 86 40 61 11 80 01 	movl   $0x1,-0x7fee9ec0(%esi)
80107d8e:	00 00 00 
}
80107d91:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d94:	5b                   	pop    %ebx
80107d95:	5e                   	pop    %esi
80107d96:	5d                   	pop    %ebp
80107d97:	c3                   	ret
	panic("pte not found in decrementing");
80107d98:	83 ec 0c             	sub    $0xc,%esp
80107d9b:	68 eb 86 10 80       	push   $0x801086eb
80107da0:	e8 cb 86 ff ff       	call   80100470 <panic>
80107da5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107db0 <get_refcnt>:

uint get_refcnt(uint pa)
{
80107db0:	55                   	push   %ebp
80107db1:	89 e5                	mov    %esp,%ebp
    return page_to_ref_cnt[pa >> PTXSHIFT];
80107db3:	8b 45 08             	mov    0x8(%ebp),%eax
}
80107db6:	5d                   	pop    %ebp
    return page_to_ref_cnt[pa >> PTXSHIFT];
80107db7:	c1 e8 0c             	shr    $0xc,%eax
80107dba:	8b 04 85 40 9a 1c 80 	mov    -0x7fe365c0(,%eax,4),%eax
}
80107dc1:	c3                   	ret
80107dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107dd0 <init_refcnt>:

void init_refcnt(uint pa)
{
80107dd0:	55                   	push   %ebp
80107dd1:	89 e5                	mov    %esp,%ebp
    page_to_ref_cnt[pa >> PTXSHIFT] = 0;
80107dd3:	8b 45 08             	mov    0x8(%ebp),%eax
}
80107dd6:	5d                   	pop    %ebp
    page_to_ref_cnt[pa >> PTXSHIFT] = 0;
80107dd7:	c1 e8 0c             	shr    $0xc,%eax
80107dda:	c7 04 85 40 9a 1c 80 	movl   $0x0,-0x7fe365c0(,%eax,4)
80107de1:	00 00 00 00 
}
80107de5:	c3                   	ret
80107de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ded:	8d 76 00             	lea    0x0(%esi),%esi

80107df0 <swap_out>:

void swap_out(){
80107df0:	55                   	push   %ebp
80107df1:	89 e5                	mov    %esp,%ebp
80107df3:	57                   	push   %edi
80107df4:	56                   	push   %esi
80107df5:	53                   	push   %ebx
	// int * page_to_refcnt = get_refcnt_table();
	pte_t* pte = final_page();
	for(int i = 0 ; i < NPAGE; i++){
80107df6:	31 db                	xor    %ebx,%ebx
void swap_out(){
80107df8:	83 ec 0c             	sub    $0xc,%esp
	pte_t* pte = final_page();
80107dfb:	e8 60 c8 ff ff       	call   80104660 <final_page>
	for(int i = 0 ; i < NPAGE; i++){
80107e00:	ba 40 61 11 80       	mov    $0x80116140,%edx
80107e05:	eb 1a                	jmp    80107e21 <swap_out+0x31>
80107e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e0e:	66 90                	xchg   %ax,%ax
80107e10:	83 c3 01             	add    $0x1,%ebx
80107e13:	81 c2 10 02 00 00    	add    $0x210,%edx
80107e19:	81 fb 90 01 00 00    	cmp    $0x190,%ebx
80107e1f:	74 59                	je     80107e7a <swap_out+0x8a>
		if(swap_slots[i].is_free == FREE){
80107e21:	83 3a 01             	cmpl   $0x1,(%edx)
80107e24:	75 ea                	jne    80107e10 <swap_out+0x20>
			swap_slots[i].is_free = NOT_FREE;
80107e26:	69 d3 10 02 00 00    	imul   $0x210,%ebx,%edx
			swap_slots[i].page_perm = PTE_FLAGS(*pte);
			uint pa = PTE_ADDR(*pte);
			write_page_to_swap(swap_slots[i].blockno, (char*)P2V(pa));
80107e2c:	83 ec 08             	sub    $0x8,%esp
			swap_slots[i].is_free = NOT_FREE;
80107e2f:	c7 82 40 61 11 80 00 	movl   $0x0,-0x7fee9ec0(%edx)
80107e36:	00 00 00 
80107e39:	8d 8a 40 61 11 80    	lea    -0x7fee9ec0(%edx),%ecx
			swap_slots[i].page_perm = PTE_FLAGS(*pte);
80107e3f:	8b 10                	mov    (%eax),%edx
80107e41:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
80107e47:	89 51 04             	mov    %edx,0x4(%ecx)
			uint pa = PTE_ADDR(*pte);
80107e4a:	8b 30                	mov    (%eax),%esi
80107e4c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
			write_page_to_swap(swap_slots[i].blockno, (char*)P2V(pa));
80107e52:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
80107e58:	57                   	push   %edi
80107e59:	ff 71 08             	push   0x8(%ecx)
80107e5c:	e8 1f 84 ff ff       	call   80100280 <write_page_to_swap>
			swap_info_on_hdr(pa, i);
80107e61:	58                   	pop    %eax
80107e62:	5a                   	pop    %edx
80107e63:	53                   	push   %ebx
80107e64:	56                   	push   %esi
80107e65:	e8 f6 fb ff ff       	call   80107a60 <swap_info_on_hdr>
			// int refcnt = page_to_refcnt[pa >> PTXSHIFT];
			// this is needed because when we are swapping out a page that is referred to by 
			// multiple page table entries, we need to free the page only when all the references are gone
			// swap_slots[i].refcnt_to_disk = refcnt;
			// for(int i = 0 ; i < refcnt; i++){
			kfree((char*)P2V(pa));
80107e6a:	89 3c 24             	mov    %edi,(%esp)
80107e6d:	e8 2e a7 ff ff       	call   801025a0 <kfree>
			// }
			return;
		}
	}
	panic("Swap full\n");
}
80107e72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e75:	5b                   	pop    %ebx
80107e76:	5e                   	pop    %esi
80107e77:	5f                   	pop    %edi
80107e78:	5d                   	pop    %ebp
80107e79:	c3                   	ret
	panic("Swap full\n");
80107e7a:	83 ec 0c             	sub    $0xc,%esp
80107e7d:	68 09 87 10 80       	push   $0x80108709
80107e82:	e8 e9 85 ff ff       	call   80100470 <panic>
80107e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e8e:	66 90                	xchg   %ax,%ax

80107e90 <cow_page>:
// the following function is called when a copy is needed to be created for the page pointed to by pte
// constratin : pte is present in the pagetable
void cow_page(pte_t * pte){
80107e90:	55                   	push   %ebp
80107e91:	89 e5                	mov    %esp,%ebp
80107e93:	57                   	push   %edi
80107e94:	56                   	push   %esi
80107e95:	53                   	push   %ebx
80107e96:	83 ec 0c             	sub    $0xc,%esp
80107e99:	8b 75 08             	mov    0x8(%ebp),%esi
	char * copy_mem = kalloc();
80107e9c:	e8 2f a9 ff ff       	call   801027d0 <kalloc>
80107ea1:	89 c3                	mov    %eax,%ebx
	int * page_to_refcnt = get_refcnt_table();
80107ea3:	e8 e8 a6 ff ff       	call   80102590 <get_refcnt_table>
	// allocating new page using kalloc
	if(copy_mem == 0){
80107ea8:	85 db                	test   %ebx,%ebx
80107eaa:	74 7e                	je     80107f2a <cow_page+0x9a>
80107eac:	89 c7                	mov    %eax,%edi
		panic("kalloc failing in cow_page\n");
	}
	// whe arent we setting the refcnt of the new page to 1
	cprintf("before refcnt = %d", page_to_refcnt[(*pte) >> PTXSHIFT]);
80107eae:	8b 06                	mov    (%esi),%eax
80107eb0:	83 ec 08             	sub    $0x8,%esp
80107eb3:	c1 e8 0c             	shr    $0xc,%eax
80107eb6:	ff 34 87             	push   (%edi,%eax,4)
80107eb9:	68 30 87 10 80       	push   $0x80108730
80107ebe:	e8 dd 88 ff ff       	call   801007a0 <cprintf>
	page_to_refcnt[(*pte) >> PTXSHIFT]--;
80107ec3:	8b 06                	mov    (%esi),%eax
80107ec5:	c1 e8 0c             	shr    $0xc,%eax
80107ec8:	83 2c 87 01          	subl   $0x1,(%edi,%eax,4)
	cprintf("after refcnt = %d", page_to_refcnt[(*pte) >> PTXSHIFT]);
80107ecc:	58                   	pop    %eax
80107ecd:	8b 06                	mov    (%esi),%eax
80107ecf:	5a                   	pop    %edx
80107ed0:	c1 e8 0c             	shr    $0xc,%eax
80107ed3:	ff 34 87             	push   (%edi,%eax,4)
80107ed6:	68 43 87 10 80       	push   $0x80108743
80107edb:	e8 c0 88 ff ff       	call   801007a0 <cprintf>

	memmove(copy_mem, (char*)P2V(PTE_ADDR(*pte)), PGSIZE);
80107ee0:	83 c4 0c             	add    $0xc,%esp
80107ee3:	68 00 10 00 00       	push   $0x1000
80107ee8:	8b 06                	mov    (%esi),%eax
80107eea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107eef:	05 00 00 00 80       	add    $0x80000000,%eax
80107ef4:	50                   	push   %eax
80107ef5:	53                   	push   %ebx
	// now modify the pgdir
	*pte = V2P(copy_mem) | PTE_FLAGS(*pte) | PTE_W;
80107ef6:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
	memmove(copy_mem, (char*)P2V(PTE_ADDR(*pte)), PGSIZE);
80107efc:	e8 ff cc ff ff       	call   80104c00 <memmove>
	*pte = V2P(copy_mem) | PTE_FLAGS(*pte) | PTE_W;
80107f01:	8b 06                	mov    (%esi),%eax
80107f03:	25 ff 0f 00 00       	and    $0xfff,%eax
80107f08:	09 c3                	or     %eax,%ebx
80107f0a:	83 cb 02             	or     $0x2,%ebx
80107f0d:	89 1e                	mov    %ebx,(%esi)
	lcr3(V2P(myproc()->pgdir));
80107f0f:	e8 3c bc ff ff       	call   80103b50 <myproc>
80107f14:	8b 40 08             	mov    0x8(%eax),%eax
80107f17:	05 00 00 00 80       	add    $0x80000000,%eax
80107f1c:	0f 22 d8             	mov    %eax,%cr3

}
80107f1f:	83 c4 10             	add    $0x10,%esp
80107f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f25:	5b                   	pop    %ebx
80107f26:	5e                   	pop    %esi
80107f27:	5f                   	pop    %edi
80107f28:	5d                   	pop    %ebp
80107f29:	c3                   	ret
		panic("kalloc failing in cow_page\n");
80107f2a:	83 ec 0c             	sub    $0xc,%esp
80107f2d:	68 14 87 10 80       	push   $0x80108714
80107f32:	e8 39 85 ff ff       	call   80100470 <panic>
80107f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f3e:	66 90                	xchg   %ax,%ax

80107f40 <clear_slot>:

void clear_slot(pte_t* page){
80107f40:	55                   	push   %ebp
80107f41:	89 e5                	mov    %esp,%ebp
	int blockno = PTE_ADDR(*page) >> PTXSHIFT;
80107f43:	8b 45 08             	mov    0x8(%ebp),%eax
	swap_slots[(blockno - SWAPBASE) / BPPAGE].is_free = FREE;
}
80107f46:	5d                   	pop    %ebp
	int blockno = PTE_ADDR(*page) >> PTXSHIFT;
80107f47:	8b 10                	mov    (%eax),%edx
80107f49:	c1 ea 0c             	shr    $0xc,%edx
	swap_slots[(blockno - SWAPBASE) / BPPAGE].is_free = FREE;
80107f4c:	8d 42 05             	lea    0x5(%edx),%eax
80107f4f:	83 ea 02             	sub    $0x2,%edx
80107f52:	0f 49 c2             	cmovns %edx,%eax
80107f55:	c1 f8 03             	sar    $0x3,%eax
80107f58:	69 c0 10 02 00 00    	imul   $0x210,%eax,%eax
80107f5e:	c7 80 40 61 11 80 01 	movl   $0x1,-0x7fee9ec0(%eax)
80107f65:	00 00 00 
}
80107f68:	c3                   	ret
80107f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107f70 <dec_swap_slot_refcnt>:
int dec_swap_slot_refcnt(pte_t * pte){
80107f70:	55                   	push   %ebp
80107f71:	89 e5                	mov    %esp,%ebp
80107f73:	83 ec 08             	sub    $0x8,%esp
	int blockno = PTE_ADDR(*pte) >> PTXSHIFT;
80107f76:	8b 45 08             	mov    0x8(%ebp),%eax
80107f79:	8b 00                	mov    (%eax),%eax
80107f7b:	c1 e8 0c             	shr    $0xc,%eax
	int x = swap_slots[(blockno - SWAPBASE) / BPPAGE].refcnt_to_disk;
80107f7e:	8d 50 05             	lea    0x5(%eax),%edx
80107f81:	83 e8 02             	sub    $0x2,%eax
80107f84:	0f 49 d0             	cmovns %eax,%edx
80107f87:	c1 fa 03             	sar    $0x3,%edx
80107f8a:	69 d2 10 02 00 00    	imul   $0x210,%edx,%edx
80107f90:	81 c2 40 61 11 80    	add    $0x80116140,%edx
80107f96:	8b 42 0c             	mov    0xc(%edx),%eax
	if(x == 0){
80107f99:	85 c0                	test   %eax,%eax
80107f9b:	74 08                	je     80107fa5 <dec_swap_slot_refcnt+0x35>
		panic("refcnt already 0\n");
	}
	return --(swap_slots[(blockno - SWAPBASE) / BPPAGE].refcnt_to_disk);
80107f9d:	83 e8 01             	sub    $0x1,%eax
80107fa0:	89 42 0c             	mov    %eax,0xc(%edx)
};
80107fa3:	c9                   	leave
80107fa4:	c3                   	ret
		panic("refcnt already 0\n");
80107fa5:	83 ec 0c             	sub    $0xc,%esp
80107fa8:	68 55 87 10 80       	push   $0x80108755
80107fad:	e8 be 84 ff ff       	call   80100470 <panic>
80107fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107fc0 <handle_page_fault>:
// 	}
// }


void handle_page_fault(void)
{
80107fc0:	55                   	push   %ebp
80107fc1:	89 e5                	mov    %esp,%ebp
80107fc3:	57                   	push   %edi
80107fc4:	56                   	push   %esi
80107fc5:	53                   	push   %ebx
80107fc6:	83 ec 1c             	sub    $0x1c,%esp
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107fc9:	0f 20 d3             	mov    %cr2,%ebx
    uint va = rcr2();
    pte_t *pte = walkpgdir(myproc()->pgdir, (void *)va, 0);
80107fcc:	e8 7f bb ff ff       	call   80103b50 <myproc>
  pde = &pgdir[PDX(va)];
80107fd1:	89 da                	mov    %ebx,%edx
  if(*pde & PTE_P){
80107fd3:	8b 40 08             	mov    0x8(%eax),%eax
  pde = &pgdir[PDX(va)];
80107fd6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107fd9:	8b 04 90             	mov    (%eax,%edx,4),%eax
80107fdc:	a8 01                	test   $0x1,%al
80107fde:	0f 84 ad 01 00 00    	je     80108191 <handle_page_fault.cold>
  return &pgtab[PTX(va)];
80107fe4:	c1 eb 0a             	shr    $0xa,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107fe7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107fec:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80107ff2:	8d b4 18 00 00 00 80 	lea    -0x80000000(%eax,%ebx,1),%esi
    if ((*pte & PTE_P))
80107ff9:	8b 1e                	mov    (%esi),%ebx
80107ffb:	f6 c3 01             	test   $0x1,%bl
80107ffe:	0f 84 e4 00 00 00    	je     801080e8 <handle_page_fault+0x128>
    {
	// cow fault has occured
        if (!(*pte & PTE_W)){
80108004:	f6 c3 02             	test   $0x2,%bl
80108007:	0f 85 cd 00 00 00    	jne    801080da <handle_page_fault+0x11a>
		char *mem;
		uint flags = PTE_FLAGS(*pte);
		uint pa = PTE_ADDR(*pte);
8010800d:	89 d8                	mov    %ebx,%eax
8010800f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108014:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return page_to_ref_cnt[pa >> PTXSHIFT];
80108017:	89 d8                	mov    %ebx,%eax
80108019:	c1 e8 0c             	shr    $0xc,%eax
		if (get_refcnt(pa) > 1){
8010801c:	83 3c 85 40 9a 1c 80 	cmpl   $0x1,-0x7fe365c0(,%eax,4)
80108023:	01 
    return page_to_ref_cnt[pa >> PTXSHIFT];
80108024:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (get_refcnt(pa) > 1){
80108027:	0f 86 0b 01 00 00    	jbe    80108138 <handle_page_fault+0x178>
			if ((mem = kalloc()) == 0){
8010802d:	e8 9e a7 ff ff       	call   801027d0 <kalloc>
80108032:	89 c7                	mov    %eax,%edi
80108034:	85 c0                	test   %eax,%eax
80108036:	0f 84 48 01 00 00    	je     80108184 <handle_page_fault+0x1c4>
				panic("kalloc failed in handle page fault");
			}
			inc_refcnt_in_memory(V2P(mem), pte, myproc()->pid);
8010803c:	e8 0f bb ff ff       	call   80103b50 <myproc>
    update_rss(pid, PGSIZE);
80108041:	83 ec 08             	sub    $0x8,%esp
			inc_refcnt_in_memory(V2P(mem), pte, myproc()->pid);
80108044:	8b 48 14             	mov    0x14(%eax),%ecx
80108047:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
    page_to_ptes_map[pa >> PTXSHIFT][page_to_ref_cnt[pa>>12]] = pte;
8010804d:	89 c2                	mov    %eax,%edx
			inc_refcnt_in_memory(V2P(mem), pte, myproc()->pid);
8010804f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    page_to_ptes_map[pa >> PTXSHIFT][page_to_ref_cnt[pa>>12]] = pte;
80108052:	c1 ea 0c             	shr    $0xc,%edx
80108055:	89 d0                	mov    %edx,%eax
80108057:	c1 e0 06             	shl    $0x6,%eax
8010805a:	03 04 95 40 9a 1c 80 	add    -0x7fe365c0(,%edx,4),%eax
80108061:	89 34 85 40 9a 18 80 	mov    %esi,-0x7fe765c0(,%eax,4)
    page_to_proc_pid_map[pa >> PTXSHIFT][page_to_ref_cnt[pa >> PTXSHIFT]] = pid;
80108068:	89 0c 85 40 9a 14 80 	mov    %ecx,-0x7feb65c0(,%eax,4)
    page_to_ref_cnt[pa >> PTXSHIFT] += 1;
8010806f:	8b 04 95 40 9a 1c 80 	mov    -0x7fe365c0(,%edx,4),%eax
80108076:	83 c0 01             	add    $0x1,%eax
80108079:	89 04 95 40 9a 1c 80 	mov    %eax,-0x7fe365c0(,%edx,4)
    update_rss(pid, PGSIZE);
80108080:	68 00 10 00 00       	push   $0x1000
80108085:	51                   	push   %ecx
80108086:	e8 85 c6 ff ff       	call   80104710 <update_rss>
			if (*pte & PTE_P){
8010808b:	8b 06                	mov    (%esi),%eax
8010808d:	83 c4 10             	add    $0x10,%esp
80108090:	a8 01                	test   $0x1,%al
80108092:	0f 85 c0 00 00 00    	jne    80108158 <handle_page_fault+0x198>
				// if in memory
				dec_refcnt_in_memory(pa, pte);
			}
			else if (*pte & PTE_SW)
80108098:	a8 08                	test   $0x8,%al
8010809a:	0f 85 d0 00 00 00    	jne    80108170 <handle_page_fault+0x1b0>
				// if swapped
				int slot_no_i = pa >> PTXSHIFT;
				dec_refcnt_in_hdr(slot_no_i, pte);
			}
			
			memmove(mem, (char *)P2V(pa), PGSIZE);
801080a0:	83 ec 04             	sub    $0x4,%esp
		uint flags = PTE_FLAGS(*pte);
801080a3:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
			memmove(mem, (char *)P2V(pa), PGSIZE);
801080a9:	68 00 10 00 00       	push   $0x1000
801080ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080b1:	05 00 00 00 80       	add    $0x80000000,%eax
801080b6:	50                   	push   %eax
801080b7:	57                   	push   %edi
801080b8:	e8 43 cb ff ff       	call   80104c00 <memmove>
			*pte = V2P(mem) | PTE_W | flags;
801080bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080c0:	09 c3                	or     %eax,%ebx
801080c2:	83 cb 02             	or     $0x2,%ebx
801080c5:	89 1e                	mov    %ebx,(%esi)
			lcr3(V2P(myproc()->pgdir));
801080c7:	e8 84 ba ff ff       	call   80103b50 <myproc>
801080cc:	8b 40 08             	mov    0x8(%eax),%eax
801080cf:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801080d4:	0f 22 d8             	mov    %eax,%cr3
			
			return;
801080d7:	83 c4 10             	add    $0x10,%esp
            write_page_to_swap(swap_slots[slot_no_i].blockno, pg);
	    get_hdrs_from_disk(V2P(pg), slot_no_i);
        }

    }
801080da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080dd:	5b                   	pop    %ebx
801080de:	5e                   	pop    %esi
801080df:	5f                   	pop    %edi
801080e0:	5d                   	pop    %ebp
801080e1:	c3                   	ret
801080e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (!(*pte & PTE_SW)){
801080e8:	f6 c3 08             	test   $0x8,%bl
801080eb:	74 58                	je     80108145 <handle_page_fault+0x185>
            int slot_no_i = (*pte) >> PTXSHIFT;
801080ed:	c1 eb 0c             	shr    $0xc,%ebx
            swap_slots[slot_no_i].is_free = FREE;
801080f0:	69 c3 10 02 00 00    	imul   $0x210,%ebx,%eax
801080f6:	c7 80 40 61 11 80 01 	movl   $0x1,-0x7fee9ec0(%eax)
801080fd:	00 00 00 
80108100:	8d b8 40 61 11 80    	lea    -0x7fee9ec0(%eax),%edi
            char *pg = kalloc();
80108106:	e8 c5 a6 ff ff       	call   801027d0 <kalloc>
            write_page_to_swap(swap_slots[slot_no_i].blockno, pg);
8010810b:	83 ec 08             	sub    $0x8,%esp
8010810e:	50                   	push   %eax
            char *pg = kalloc();
8010810f:	89 c6                	mov    %eax,%esi
            write_page_to_swap(swap_slots[slot_no_i].blockno, pg);
80108111:	ff 77 08             	push   0x8(%edi)
	    get_hdrs_from_disk(V2P(pg), slot_no_i);
80108114:	81 c6 00 00 00 80    	add    $0x80000000,%esi
            write_page_to_swap(swap_slots[slot_no_i].blockno, pg);
8010811a:	e8 61 81 ff ff       	call   80100280 <write_page_to_swap>
	    get_hdrs_from_disk(V2P(pg), slot_no_i);
8010811f:	58                   	pop    %eax
80108120:	5a                   	pop    %edx
80108121:	53                   	push   %ebx
80108122:	56                   	push   %esi
80108123:	e8 f8 f9 ff ff       	call   80107b20 <get_hdrs_from_disk>
80108128:	83 c4 10             	add    $0x10,%esp
8010812b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010812e:	5b                   	pop    %ebx
8010812f:	5e                   	pop    %esi
80108130:	5f                   	pop    %edi
80108131:	5d                   	pop    %ebp
80108132:	c3                   	ret
80108133:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108137:	90                   	nop
			*pte |= PTE_W;
80108138:	83 cb 02             	or     $0x2,%ebx
8010813b:	89 1e                	mov    %ebx,(%esi)
8010813d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108140:	5b                   	pop    %ebx
80108141:	5e                   	pop    %esi
80108142:	5f                   	pop    %edi
80108143:	5d                   	pop    %ebp
80108144:	c3                   	ret
            panic("page not present nor swapped");
80108145:	83 ec 0c             	sub    $0xc,%esp
80108148:	68 67 87 10 80       	push   $0x80108767
8010814d:	e8 1e 83 ff ff       	call   80100470 <panic>
80108152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				dec_refcnt_in_memory(pa, pte);
80108158:	83 ec 08             	sub    $0x8,%esp
8010815b:	56                   	push   %esi
8010815c:	ff 75 e4             	push   -0x1c(%ebp)
8010815f:	e8 ec fa ff ff       	call   80107c50 <dec_refcnt_in_memory>
80108164:	83 c4 10             	add    $0x10,%esp
80108167:	e9 34 ff ff ff       	jmp    801080a0 <handle_page_fault+0xe0>
8010816c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
				dec_refcnt_in_hdr(slot_no_i, pte);
80108170:	83 ec 08             	sub    $0x8,%esp
80108173:	56                   	push   %esi
80108174:	ff 75 dc             	push   -0x24(%ebp)
80108177:	e8 84 fb ff ff       	call   80107d00 <dec_refcnt_in_hdr>
8010817c:	83 c4 10             	add    $0x10,%esp
8010817f:	e9 1c ff ff ff       	jmp    801080a0 <handle_page_fault+0xe0>
				panic("kalloc failed in handle page fault");
80108184:	83 ec 0c             	sub    $0xc,%esp
80108187:	68 74 89 10 80       	push   $0x80108974
8010818c:	e8 df 82 ff ff       	call   80100470 <panic>

80108191 <handle_page_fault.cold>:
    if ((*pte & PTE_P))
80108191:	a1 00 00 00 00       	mov    0x0,%eax
80108196:	0f 0b                	ud2
