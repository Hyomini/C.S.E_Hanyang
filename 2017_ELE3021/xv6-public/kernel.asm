
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 8e 3a 10 80       	mov    $0x80103a8e,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 f4 8e 10 	movl   $0x80108ef4,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100049:	e8 fe 55 00 00       	call   8010564c <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 cc 1d 11 80 7c 	movl   $0x80111d7c,0x80111dcc
80100055:	1d 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 d0 1d 11 80 7c 	movl   $0x80111d7c,0x80111dd0
8010005f:	1d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
80100069:	eb 46                	jmp    801000b1 <binit+0x7d>
    b->next = bcache.head.next;
8010006b:	8b 15 d0 1d 11 80    	mov    0x80111dd0,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 50 7c 1d 11 80 	movl   $0x80111d7c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	83 c0 0c             	add    $0xc,%eax
80100087:	c7 44 24 04 fb 8e 10 	movl   $0x80108efb,0x4(%esp)
8010008e:	80 
8010008f:	89 04 24             	mov    %eax,(%esp)
80100092:	e8 78 54 00 00       	call   8010550f <initsleeplock>
    bcache.head.next->prev = b;
80100097:	a1 d0 1d 11 80       	mov    0x80111dd0,%eax
8010009c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010009f:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a5:	a3 d0 1d 11 80       	mov    %eax,0x80111dd0

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b1:	81 7d f4 7c 1d 11 80 	cmpl   $0x80111d7c,-0xc(%ebp)
801000b8:	72 b1                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ba:	c9                   	leave  
801000bb:	c3                   	ret    

801000bc <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000bc:	55                   	push   %ebp
801000bd:	89 e5                	mov    %esp,%ebp
801000bf:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000c2:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801000c9:	e8 9f 55 00 00       	call   8010566d <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ce:	a1 d0 1d 11 80       	mov    0x80111dd0,%eax
801000d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d6:	eb 50                	jmp    80100128 <bget+0x6c>
    if(b->dev == dev && b->blockno == blockno){
801000d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000db:	8b 40 04             	mov    0x4(%eax),%eax
801000de:	3b 45 08             	cmp    0x8(%ebp),%eax
801000e1:	75 3c                	jne    8010011f <bget+0x63>
801000e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e6:	8b 40 08             	mov    0x8(%eax),%eax
801000e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000ec:	75 31                	jne    8010011f <bget+0x63>
      b->refcnt++;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 40 4c             	mov    0x4c(%eax),%eax
801000f4:	8d 50 01             	lea    0x1(%eax),%edx
801000f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fa:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
801000fd:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100104:	e8 cb 55 00 00       	call   801056d4 <release>
      acquiresleep(&b->lock);
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	83 c0 0c             	add    $0xc,%eax
8010010f:	89 04 24             	mov    %eax,(%esp)
80100112:	e8 32 54 00 00       	call   80105549 <acquiresleep>
      return b;
80100117:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011a:	e9 94 00 00 00       	jmp    801001b3 <bget+0xf7>
  struct buf *b;

  acquire(&bcache.lock);

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100122:	8b 40 54             	mov    0x54(%eax),%eax
80100125:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100128:	81 7d f4 7c 1d 11 80 	cmpl   $0x80111d7c,-0xc(%ebp)
8010012f:	75 a7                	jne    801000d8 <bget+0x1c>
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100131:	a1 cc 1d 11 80       	mov    0x80111dcc,%eax
80100136:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100139:	eb 63                	jmp    8010019e <bget+0xe2>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010013e:	8b 40 4c             	mov    0x4c(%eax),%eax
80100141:	85 c0                	test   %eax,%eax
80100143:	75 50                	jne    80100195 <bget+0xd9>
80100145:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100148:	8b 00                	mov    (%eax),%eax
8010014a:	83 e0 04             	and    $0x4,%eax
8010014d:	85 c0                	test   %eax,%eax
8010014f:	75 44                	jne    80100195 <bget+0xd9>
      b->dev = dev;
80100151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100154:	8b 55 08             	mov    0x8(%ebp),%edx
80100157:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 0c             	mov    0xc(%ebp),%edx
80100160:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
80100176:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010017d:	e8 52 55 00 00       	call   801056d4 <release>
      acquiresleep(&b->lock);
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	83 c0 0c             	add    $0xc,%eax
80100188:	89 04 24             	mov    %eax,(%esp)
8010018b:	e8 b9 53 00 00       	call   80105549 <acquiresleep>
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1e                	jmp    801001b3 <bget+0xf7>
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 50             	mov    0x50(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 7c 1d 11 80 	cmpl   $0x80111d7c,-0xc(%ebp)
801001a5:	75 94                	jne    8010013b <bget+0x7f>
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	c7 04 24 02 8f 10 80 	movl   $0x80108f02,(%esp)
801001ae:	e8 af 03 00 00       	call   80100562 <panic>
}
801001b3:	c9                   	leave  
801001b4:	c3                   	ret    

801001b5 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b5:	55                   	push   %ebp
801001b6:	89 e5                	mov    %esp,%ebp
801001b8:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801001be:	89 44 24 04          	mov    %eax,0x4(%esp)
801001c2:	8b 45 08             	mov    0x8(%ebp),%eax
801001c5:	89 04 24             	mov    %eax,(%esp)
801001c8:	e8 ef fe ff ff       	call   801000bc <bget>
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0b                	jne    801001e7 <bread+0x32>
    iderw(b);
801001dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001df:	89 04 24             	mov    %eax,(%esp)
801001e2:	e8 1b 29 00 00       	call   80102b02 <iderw>
  }
  return b;
801001e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ea:	c9                   	leave  
801001eb:	c3                   	ret    

801001ec <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001ec:	55                   	push   %ebp
801001ed:	89 e5                	mov    %esp,%ebp
801001ef:	83 ec 18             	sub    $0x18,%esp
  if(!holdingsleep(&b->lock))
801001f2:	8b 45 08             	mov    0x8(%ebp),%eax
801001f5:	83 c0 0c             	add    $0xc,%eax
801001f8:	89 04 24             	mov    %eax,(%esp)
801001fb:	e8 e7 53 00 00       	call   801055e7 <holdingsleep>
80100200:	85 c0                	test   %eax,%eax
80100202:	75 0c                	jne    80100210 <bwrite+0x24>
    panic("bwrite");
80100204:	c7 04 24 13 8f 10 80 	movl   $0x80108f13,(%esp)
8010020b:	e8 52 03 00 00       	call   80100562 <panic>
  b->flags |= B_DIRTY;
80100210:	8b 45 08             	mov    0x8(%ebp),%eax
80100213:	8b 00                	mov    (%eax),%eax
80100215:	83 c8 04             	or     $0x4,%eax
80100218:	89 c2                	mov    %eax,%edx
8010021a:	8b 45 08             	mov    0x8(%ebp),%eax
8010021d:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021f:	8b 45 08             	mov    0x8(%ebp),%eax
80100222:	89 04 24             	mov    %eax,(%esp)
80100225:	e8 d8 28 00 00       	call   80102b02 <iderw>
}
8010022a:	c9                   	leave  
8010022b:	c3                   	ret    

8010022c <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022c:	55                   	push   %ebp
8010022d:	89 e5                	mov    %esp,%ebp
8010022f:	83 ec 18             	sub    $0x18,%esp
  if(!holdingsleep(&b->lock))
80100232:	8b 45 08             	mov    0x8(%ebp),%eax
80100235:	83 c0 0c             	add    $0xc,%eax
80100238:	89 04 24             	mov    %eax,(%esp)
8010023b:	e8 a7 53 00 00       	call   801055e7 <holdingsleep>
80100240:	85 c0                	test   %eax,%eax
80100242:	75 0c                	jne    80100250 <brelse+0x24>
    panic("brelse");
80100244:	c7 04 24 1a 8f 10 80 	movl   $0x80108f1a,(%esp)
8010024b:	e8 12 03 00 00       	call   80100562 <panic>

  releasesleep(&b->lock);
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	83 c0 0c             	add    $0xc,%eax
80100256:	89 04 24             	mov    %eax,(%esp)
80100259:	e8 47 53 00 00       	call   801055a5 <releasesleep>

  acquire(&bcache.lock);
8010025e:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100265:	e8 03 54 00 00       	call   8010566d <acquire>
  b->refcnt--;
8010026a:	8b 45 08             	mov    0x8(%ebp),%eax
8010026d:	8b 40 4c             	mov    0x4c(%eax),%eax
80100270:	8d 50 ff             	lea    -0x1(%eax),%edx
80100273:	8b 45 08             	mov    0x8(%ebp),%eax
80100276:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
80100279:	8b 45 08             	mov    0x8(%ebp),%eax
8010027c:	8b 40 4c             	mov    0x4c(%eax),%eax
8010027f:	85 c0                	test   %eax,%eax
80100281:	75 47                	jne    801002ca <brelse+0x9e>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100283:	8b 45 08             	mov    0x8(%ebp),%eax
80100286:	8b 40 54             	mov    0x54(%eax),%eax
80100289:	8b 55 08             	mov    0x8(%ebp),%edx
8010028c:	8b 52 50             	mov    0x50(%edx),%edx
8010028f:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	8b 40 50             	mov    0x50(%eax),%eax
80100298:	8b 55 08             	mov    0x8(%ebp),%edx
8010029b:	8b 52 54             	mov    0x54(%edx),%edx
8010029e:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002a1:	8b 15 d0 1d 11 80    	mov    0x80111dd0,%edx
801002a7:	8b 45 08             	mov    0x8(%ebp),%eax
801002aa:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002ad:	8b 45 08             	mov    0x8(%ebp),%eax
801002b0:	c7 40 50 7c 1d 11 80 	movl   $0x80111d7c,0x50(%eax)
    bcache.head.next->prev = b;
801002b7:	a1 d0 1d 11 80       	mov    0x80111dd0,%eax
801002bc:	8b 55 08             	mov    0x8(%ebp),%edx
801002bf:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002c2:	8b 45 08             	mov    0x8(%ebp),%eax
801002c5:	a3 d0 1d 11 80       	mov    %eax,0x80111dd0
  }
  
  release(&bcache.lock);
801002ca:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801002d1:	e8 fe 53 00 00       	call   801056d4 <release>
}
801002d6:	c9                   	leave  
801002d7:	c3                   	ret    

801002d8 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d8:	55                   	push   %ebp
801002d9:	89 e5                	mov    %esp,%ebp
801002db:	83 ec 14             	sub    $0x14,%esp
801002de:	8b 45 08             	mov    0x8(%ebp),%eax
801002e1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e9:	89 c2                	mov    %eax,%edx
801002eb:	ec                   	in     (%dx),%al
801002ec:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002ef:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002f3:	c9                   	leave  
801002f4:	c3                   	ret    

801002f5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f5:	55                   	push   %ebp
801002f6:	89 e5                	mov    %esp,%ebp
801002f8:	83 ec 08             	sub    $0x8,%esp
801002fb:	8b 55 08             	mov    0x8(%ebp),%edx
801002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100301:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100305:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100308:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010030c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100310:	ee                   	out    %al,(%dx)
}
80100311:	c9                   	leave  
80100312:	c3                   	ret    

80100313 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100313:	55                   	push   %ebp
80100314:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100316:	fa                   	cli    
}
80100317:	5d                   	pop    %ebp
80100318:	c3                   	ret    

80100319 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100319:	55                   	push   %ebp
8010031a:	89 e5                	mov    %esp,%ebp
8010031c:	56                   	push   %esi
8010031d:	53                   	push   %ebx
8010031e:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100321:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100325:	74 1c                	je     80100343 <printint+0x2a>
80100327:	8b 45 08             	mov    0x8(%ebp),%eax
8010032a:	c1 e8 1f             	shr    $0x1f,%eax
8010032d:	0f b6 c0             	movzbl %al,%eax
80100330:	89 45 10             	mov    %eax,0x10(%ebp)
80100333:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100337:	74 0a                	je     80100343 <printint+0x2a>
    x = -xx;
80100339:	8b 45 08             	mov    0x8(%ebp),%eax
8010033c:	f7 d8                	neg    %eax
8010033e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100341:	eb 06                	jmp    80100349 <printint+0x30>
  else
    x = xx;
80100343:	8b 45 08             	mov    0x8(%ebp),%eax
80100346:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100349:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100350:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100353:	8d 41 01             	lea    0x1(%ecx),%eax
80100356:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100359:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010035c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035f:	ba 00 00 00 00       	mov    $0x0,%edx
80100364:	f7 f3                	div    %ebx
80100366:	89 d0                	mov    %edx,%eax
80100368:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
8010036f:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100373:	8b 75 0c             	mov    0xc(%ebp),%esi
80100376:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100379:	ba 00 00 00 00       	mov    $0x0,%edx
8010037e:	f7 f6                	div    %esi
80100380:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100387:	75 c7                	jne    80100350 <printint+0x37>

  if(sign)
80100389:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038d:	74 10                	je     8010039f <printint+0x86>
    buf[i++] = '-';
8010038f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100392:	8d 50 01             	lea    0x1(%eax),%edx
80100395:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100398:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039d:	eb 18                	jmp    801003b7 <printint+0x9e>
8010039f:	eb 16                	jmp    801003b7 <printint+0x9e>
    consputc(buf[i]);
801003a1:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a7:	01 d0                	add    %edx,%eax
801003a9:	0f b6 00             	movzbl (%eax),%eax
801003ac:	0f be c0             	movsbl %al,%eax
801003af:	89 04 24             	mov    %eax,(%esp)
801003b2:	e8 dc 03 00 00       	call   80100793 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003bf:	79 e0                	jns    801003a1 <printint+0x88>
    consputc(buf[i]);
}
801003c1:	83 c4 30             	add    $0x30,%esp
801003c4:	5b                   	pop    %ebx
801003c5:	5e                   	pop    %esi
801003c6:	5d                   	pop    %ebp
801003c7:	c3                   	ret    

801003c8 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c8:	55                   	push   %ebp
801003c9:	89 e5                	mov    %esp,%ebp
801003cb:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003ce:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003da:	74 0c                	je     801003e8 <cprintf+0x20>
    acquire(&cons.lock);
801003dc:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
801003e3:	e8 85 52 00 00       	call   8010566d <acquire>

  if (fmt == 0)
801003e8:	8b 45 08             	mov    0x8(%ebp),%eax
801003eb:	85 c0                	test   %eax,%eax
801003ed:	75 0c                	jne    801003fb <cprintf+0x33>
    panic("null fmt");
801003ef:	c7 04 24 21 8f 10 80 	movl   $0x80108f21,(%esp)
801003f6:	e8 67 01 00 00       	call   80100562 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fb:	8d 45 0c             	lea    0xc(%ebp),%eax
801003fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100408:	e9 21 01 00 00       	jmp    8010052e <cprintf+0x166>
    if(c != '%'){
8010040d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100411:	74 10                	je     80100423 <cprintf+0x5b>
      consputc(c);
80100413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100416:	89 04 24             	mov    %eax,(%esp)
80100419:	e8 75 03 00 00       	call   80100793 <consputc>
      continue;
8010041e:	e9 07 01 00 00       	jmp    8010052a <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
80100423:	8b 55 08             	mov    0x8(%ebp),%edx
80100426:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010042a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010042d:	01 d0                	add    %edx,%eax
8010042f:	0f b6 00             	movzbl (%eax),%eax
80100432:	0f be c0             	movsbl %al,%eax
80100435:	25 ff 00 00 00       	and    $0xff,%eax
8010043a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010043d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100441:	75 05                	jne    80100448 <cprintf+0x80>
      break;
80100443:	e9 06 01 00 00       	jmp    8010054e <cprintf+0x186>
    switch(c){
80100448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010044b:	83 f8 70             	cmp    $0x70,%eax
8010044e:	74 4f                	je     8010049f <cprintf+0xd7>
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	7f 13                	jg     80100468 <cprintf+0xa0>
80100455:	83 f8 25             	cmp    $0x25,%eax
80100458:	0f 84 a6 00 00 00    	je     80100504 <cprintf+0x13c>
8010045e:	83 f8 64             	cmp    $0x64,%eax
80100461:	74 14                	je     80100477 <cprintf+0xaf>
80100463:	e9 aa 00 00 00       	jmp    80100512 <cprintf+0x14a>
80100468:	83 f8 73             	cmp    $0x73,%eax
8010046b:	74 57                	je     801004c4 <cprintf+0xfc>
8010046d:	83 f8 78             	cmp    $0x78,%eax
80100470:	74 2d                	je     8010049f <cprintf+0xd7>
80100472:	e9 9b 00 00 00       	jmp    80100512 <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 7f fe ff ff       	call   80100319 <printint>
      break;
8010049a:	e9 8b 00 00 00       	jmp    8010052a <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004a2:	8d 50 04             	lea    0x4(%eax),%edx
801004a5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a8:	8b 00                	mov    (%eax),%eax
801004aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801004b1:	00 
801004b2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801004b9:	00 
801004ba:	89 04 24             	mov    %eax,(%esp)
801004bd:	e8 57 fe ff ff       	call   80100319 <printint>
      break;
801004c2:	eb 66                	jmp    8010052a <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
801004c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004c7:	8d 50 04             	lea    0x4(%eax),%edx
801004ca:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004cd:	8b 00                	mov    (%eax),%eax
801004cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004d6:	75 09                	jne    801004e1 <cprintf+0x119>
        s = "(null)";
801004d8:	c7 45 ec 2a 8f 10 80 	movl   $0x80108f2a,-0x14(%ebp)
      for(; *s; s++)
801004df:	eb 17                	jmp    801004f8 <cprintf+0x130>
801004e1:	eb 15                	jmp    801004f8 <cprintf+0x130>
        consputc(*s);
801004e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004e6:	0f b6 00             	movzbl (%eax),%eax
801004e9:	0f be c0             	movsbl %al,%eax
801004ec:	89 04 24             	mov    %eax,(%esp)
801004ef:	e8 9f 02 00 00       	call   80100793 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004f4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004fb:	0f b6 00             	movzbl (%eax),%eax
801004fe:	84 c0                	test   %al,%al
80100500:	75 e1                	jne    801004e3 <cprintf+0x11b>
        consputc(*s);
      break;
80100502:	eb 26                	jmp    8010052a <cprintf+0x162>
    case '%':
      consputc('%');
80100504:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
8010050b:	e8 83 02 00 00       	call   80100793 <consputc>
      break;
80100510:	eb 18                	jmp    8010052a <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100512:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
80100519:	e8 75 02 00 00       	call   80100793 <consputc>
      consputc(c);
8010051e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100521:	89 04 24             	mov    %eax,(%esp)
80100524:	e8 6a 02 00 00       	call   80100793 <consputc>
      break;
80100529:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010052a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052e:	8b 55 08             	mov    0x8(%ebp),%edx
80100531:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100534:	01 d0                	add    %edx,%eax
80100536:	0f b6 00             	movzbl (%eax),%eax
80100539:	0f be c0             	movsbl %al,%eax
8010053c:	25 ff 00 00 00       	and    $0xff,%eax
80100541:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100544:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100548:	0f 85 bf fe ff ff    	jne    8010040d <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
8010054e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100552:	74 0c                	je     80100560 <cprintf+0x198>
    release(&cons.lock);
80100554:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010055b:	e8 74 51 00 00       	call   801056d4 <release>
}
80100560:	c9                   	leave  
80100561:	c3                   	ret    

80100562 <panic>:

void
panic(char *s)
{
80100562:	55                   	push   %ebp
80100563:	89 e5                	mov    %esp,%ebp
80100565:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];

  cli();
80100568:	e8 a6 fd ff ff       	call   80100313 <cli>
  cons.locking = 0;
8010056d:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
80100574:	00 00 00 
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100577:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010057d:	0f b6 00             	movzbl (%eax),%eax
80100580:	0f b6 c0             	movzbl %al,%eax
80100583:	89 44 24 04          	mov    %eax,0x4(%esp)
80100587:	c7 04 24 31 8f 10 80 	movl   $0x80108f31,(%esp)
8010058e:	e8 35 fe ff ff       	call   801003c8 <cprintf>
  cprintf(s);
80100593:	8b 45 08             	mov    0x8(%ebp),%eax
80100596:	89 04 24             	mov    %eax,(%esp)
80100599:	e8 2a fe ff ff       	call   801003c8 <cprintf>
  cprintf("\n");
8010059e:	c7 04 24 4d 8f 10 80 	movl   $0x80108f4d,(%esp)
801005a5:	e8 1e fe ff ff       	call   801003c8 <cprintf>
  getcallerpcs(&s, pcs);
801005aa:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801005b1:	8d 45 08             	lea    0x8(%ebp),%eax
801005b4:	89 04 24             	mov    %eax,(%esp)
801005b7:	e8 65 51 00 00       	call   80105721 <getcallerpcs>
  for(i=0; i<10; i++)
801005bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005c3:	eb 1b                	jmp    801005e0 <panic+0x7e>
    cprintf(" %p", pcs[i]);
801005c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005c8:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801005d0:	c7 04 24 4f 8f 10 80 	movl   $0x80108f4f,(%esp)
801005d7:	e8 ec fd ff ff       	call   801003c8 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005e0:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005e4:	7e df                	jle    801005c5 <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005e6:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
801005ed:	00 00 00 
  for(;;)
    ;
801005f0:	eb fe                	jmp    801005f0 <panic+0x8e>

801005f2 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005f2:	55                   	push   %ebp
801005f3:	89 e5                	mov    %esp,%ebp
801005f5:	83 ec 28             	sub    $0x28,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005f8:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005ff:	00 
80100600:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100607:	e8 e9 fc ff ff       	call   801002f5 <outb>
  pos = inb(CRTPORT+1) << 8;
8010060c:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100613:	e8 c0 fc ff ff       	call   801002d8 <inb>
80100618:	0f b6 c0             	movzbl %al,%eax
8010061b:	c1 e0 08             	shl    $0x8,%eax
8010061e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100621:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100628:	00 
80100629:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100630:	e8 c0 fc ff ff       	call   801002f5 <outb>
  pos |= inb(CRTPORT+1);
80100635:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010063c:	e8 97 fc ff ff       	call   801002d8 <inb>
80100641:	0f b6 c0             	movzbl %al,%eax
80100644:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100647:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010064b:	75 30                	jne    8010067d <cgaputc+0x8b>
    pos += 80 - pos%80;
8010064d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100650:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100655:	89 c8                	mov    %ecx,%eax
80100657:	f7 ea                	imul   %edx
80100659:	c1 fa 05             	sar    $0x5,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	c1 f8 1f             	sar    $0x1f,%eax
80100661:	29 c2                	sub    %eax,%edx
80100663:	89 d0                	mov    %edx,%eax
80100665:	c1 e0 02             	shl    $0x2,%eax
80100668:	01 d0                	add    %edx,%eax
8010066a:	c1 e0 04             	shl    $0x4,%eax
8010066d:	29 c1                	sub    %eax,%ecx
8010066f:	89 ca                	mov    %ecx,%edx
80100671:	b8 50 00 00 00       	mov    $0x50,%eax
80100676:	29 d0                	sub    %edx,%eax
80100678:	01 45 f4             	add    %eax,-0xc(%ebp)
8010067b:	eb 35                	jmp    801006b2 <cgaputc+0xc0>
  else if(c == BACKSPACE){
8010067d:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100684:	75 0c                	jne    80100692 <cgaputc+0xa0>
    if(pos > 0) --pos;
80100686:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010068a:	7e 26                	jle    801006b2 <cgaputc+0xc0>
8010068c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100690:	eb 20                	jmp    801006b2 <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100692:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
80100698:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010069b:	8d 50 01             	lea    0x1(%eax),%edx
8010069e:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a1:	01 c0                	add    %eax,%eax
801006a3:	8d 14 01             	lea    (%ecx,%eax,1),%edx
801006a6:	8b 45 08             	mov    0x8(%ebp),%eax
801006a9:	0f b6 c0             	movzbl %al,%eax
801006ac:	80 cc 07             	or     $0x7,%ah
801006af:	66 89 02             	mov    %ax,(%edx)

  if(pos < 0 || pos > 25*80)
801006b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006b6:	78 09                	js     801006c1 <cgaputc+0xcf>
801006b8:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006bf:	7e 0c                	jle    801006cd <cgaputc+0xdb>
    panic("pos under/overflow");
801006c1:	c7 04 24 53 8f 10 80 	movl   $0x80108f53,(%esp)
801006c8:	e8 95 fe ff ff       	call   80100562 <panic>

  if((pos/80) >= 24){  // Scroll up.
801006cd:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006d4:	7e 53                	jle    80100729 <cgaputc+0x137>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006d6:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006db:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e1:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006e6:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006ed:	00 
801006ee:	89 54 24 04          	mov    %edx,0x4(%esp)
801006f2:	89 04 24             	mov    %eax,(%esp)
801006f5:	e8 ab 52 00 00       	call   801059a5 <memmove>
    pos -= 80;
801006fa:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006fe:	b8 80 07 00 00       	mov    $0x780,%eax
80100703:	2b 45 f4             	sub    -0xc(%ebp),%eax
80100706:	8d 14 00             	lea    (%eax,%eax,1),%edx
80100709:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010070e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100711:	01 c9                	add    %ecx,%ecx
80100713:	01 c8                	add    %ecx,%eax
80100715:	89 54 24 08          	mov    %edx,0x8(%esp)
80100719:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100720:	00 
80100721:	89 04 24             	mov    %eax,(%esp)
80100724:	e8 ad 51 00 00       	call   801058d6 <memset>
  }

  outb(CRTPORT, 14);
80100729:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
80100730:	00 
80100731:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100738:	e8 b8 fb ff ff       	call   801002f5 <outb>
  outb(CRTPORT+1, pos>>8);
8010073d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100740:	c1 f8 08             	sar    $0x8,%eax
80100743:	0f b6 c0             	movzbl %al,%eax
80100746:	89 44 24 04          	mov    %eax,0x4(%esp)
8010074a:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100751:	e8 9f fb ff ff       	call   801002f5 <outb>
  outb(CRTPORT, 15);
80100756:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010075d:	00 
8010075e:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100765:	e8 8b fb ff ff       	call   801002f5 <outb>
  outb(CRTPORT+1, pos);
8010076a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076d:	0f b6 c0             	movzbl %al,%eax
80100770:	89 44 24 04          	mov    %eax,0x4(%esp)
80100774:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010077b:	e8 75 fb ff ff       	call   801002f5 <outb>
  crt[pos] = ' ' | 0x0700;
80100780:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100785:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100788:	01 d2                	add    %edx,%edx
8010078a:	01 d0                	add    %edx,%eax
8010078c:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100791:	c9                   	leave  
80100792:	c3                   	ret    

80100793 <consputc>:

void
consputc(int c)
{
80100793:	55                   	push   %ebp
80100794:	89 e5                	mov    %esp,%ebp
80100796:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100799:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
8010079e:	85 c0                	test   %eax,%eax
801007a0:	74 07                	je     801007a9 <consputc+0x16>
    cli();
801007a2:	e8 6c fb ff ff       	call   80100313 <cli>
    for(;;)
      ;
801007a7:	eb fe                	jmp    801007a7 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007a9:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007b0:	75 26                	jne    801007d8 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007b9:	e8 b3 6c 00 00       	call   80107471 <uartputc>
801007be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801007c5:	e8 a7 6c 00 00       	call   80107471 <uartputc>
801007ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007d1:	e8 9b 6c 00 00       	call   80107471 <uartputc>
801007d6:	eb 0b                	jmp    801007e3 <consputc+0x50>
  } else
    uartputc(c);
801007d8:	8b 45 08             	mov    0x8(%ebp),%eax
801007db:	89 04 24             	mov    %eax,(%esp)
801007de:	e8 8e 6c 00 00       	call   80107471 <uartputc>
  cgaputc(c);
801007e3:	8b 45 08             	mov    0x8(%ebp),%eax
801007e6:	89 04 24             	mov    %eax,(%esp)
801007e9:	e8 04 fe ff ff       	call   801005f2 <cgaputc>
}
801007ee:	c9                   	leave  
801007ef:	c3                   	ret    

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	83 ec 28             	sub    $0x28,%esp
  int c, doprocdump = 0;
801007f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
801007fd:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100804:	e8 64 4e 00 00       	call   8010566d <acquire>
  while((c = getc()) >= 0){
80100809:	e9 39 01 00 00       	jmp    80100947 <consoleintr+0x157>
    switch(c){
8010080e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100811:	83 f8 10             	cmp    $0x10,%eax
80100814:	74 1e                	je     80100834 <consoleintr+0x44>
80100816:	83 f8 10             	cmp    $0x10,%eax
80100819:	7f 0a                	jg     80100825 <consoleintr+0x35>
8010081b:	83 f8 08             	cmp    $0x8,%eax
8010081e:	74 66                	je     80100886 <consoleintr+0x96>
80100820:	e9 93 00 00 00       	jmp    801008b8 <consoleintr+0xc8>
80100825:	83 f8 15             	cmp    $0x15,%eax
80100828:	74 31                	je     8010085b <consoleintr+0x6b>
8010082a:	83 f8 7f             	cmp    $0x7f,%eax
8010082d:	74 57                	je     80100886 <consoleintr+0x96>
8010082f:	e9 84 00 00 00       	jmp    801008b8 <consoleintr+0xc8>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100834:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
8010083b:	e9 07 01 00 00       	jmp    80100947 <consoleintr+0x157>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100840:	a1 68 20 11 80       	mov    0x80112068,%eax
80100845:	83 e8 01             	sub    $0x1,%eax
80100848:	a3 68 20 11 80       	mov    %eax,0x80112068
        consputc(BACKSPACE);
8010084d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100854:	e8 3a ff ff ff       	call   80100793 <consputc>
80100859:	eb 01                	jmp    8010085c <consoleintr+0x6c>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010085b:	90                   	nop
8010085c:	8b 15 68 20 11 80    	mov    0x80112068,%edx
80100862:	a1 64 20 11 80       	mov    0x80112064,%eax
80100867:	39 c2                	cmp    %eax,%edx
80100869:	74 16                	je     80100881 <consoleintr+0x91>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010086b:	a1 68 20 11 80       	mov    0x80112068,%eax
80100870:	83 e8 01             	sub    $0x1,%eax
80100873:	83 e0 7f             	and    $0x7f,%eax
80100876:	0f b6 80 e0 1f 11 80 	movzbl -0x7feee020(%eax),%eax
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010087d:	3c 0a                	cmp    $0xa,%al
8010087f:	75 bf                	jne    80100840 <consoleintr+0x50>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100881:	e9 c1 00 00 00       	jmp    80100947 <consoleintr+0x157>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100886:	8b 15 68 20 11 80    	mov    0x80112068,%edx
8010088c:	a1 64 20 11 80       	mov    0x80112064,%eax
80100891:	39 c2                	cmp    %eax,%edx
80100893:	74 1e                	je     801008b3 <consoleintr+0xc3>
        input.e--;
80100895:	a1 68 20 11 80       	mov    0x80112068,%eax
8010089a:	83 e8 01             	sub    $0x1,%eax
8010089d:	a3 68 20 11 80       	mov    %eax,0x80112068
        consputc(BACKSPACE);
801008a2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
801008a9:	e8 e5 fe ff ff       	call   80100793 <consputc>
      }
      break;
801008ae:	e9 94 00 00 00       	jmp    80100947 <consoleintr+0x157>
801008b3:	e9 8f 00 00 00       	jmp    80100947 <consoleintr+0x157>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008bc:	0f 84 84 00 00 00    	je     80100946 <consoleintr+0x156>
801008c2:	8b 15 68 20 11 80    	mov    0x80112068,%edx
801008c8:	a1 60 20 11 80       	mov    0x80112060,%eax
801008cd:	29 c2                	sub    %eax,%edx
801008cf:	89 d0                	mov    %edx,%eax
801008d1:	83 f8 7f             	cmp    $0x7f,%eax
801008d4:	77 70                	ja     80100946 <consoleintr+0x156>
        c = (c == '\r') ? '\n' : c;
801008d6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008da:	74 05                	je     801008e1 <consoleintr+0xf1>
801008dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008df:	eb 05                	jmp    801008e6 <consoleintr+0xf6>
801008e1:	b8 0a 00 00 00       	mov    $0xa,%eax
801008e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008e9:	a1 68 20 11 80       	mov    0x80112068,%eax
801008ee:	8d 50 01             	lea    0x1(%eax),%edx
801008f1:	89 15 68 20 11 80    	mov    %edx,0x80112068
801008f7:	83 e0 7f             	and    $0x7f,%eax
801008fa:	89 c2                	mov    %eax,%edx
801008fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008ff:	88 82 e0 1f 11 80    	mov    %al,-0x7feee020(%edx)
        consputc(c);
80100905:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100908:	89 04 24             	mov    %eax,(%esp)
8010090b:	e8 83 fe ff ff       	call   80100793 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100910:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100914:	74 18                	je     8010092e <consoleintr+0x13e>
80100916:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
8010091a:	74 12                	je     8010092e <consoleintr+0x13e>
8010091c:	a1 68 20 11 80       	mov    0x80112068,%eax
80100921:	8b 15 60 20 11 80    	mov    0x80112060,%edx
80100927:	83 ea 80             	sub    $0xffffff80,%edx
8010092a:	39 d0                	cmp    %edx,%eax
8010092c:	75 18                	jne    80100946 <consoleintr+0x156>
          input.w = input.e;
8010092e:	a1 68 20 11 80       	mov    0x80112068,%eax
80100933:	a3 64 20 11 80       	mov    %eax,0x80112064
          wakeup(&input.r);
80100938:	c7 04 24 60 20 11 80 	movl   $0x80112060,(%esp)
8010093f:	e8 2b 4a 00 00       	call   8010536f <wakeup>
        }
      }
      break;
80100944:	eb 00                	jmp    80100946 <consoleintr+0x156>
80100946:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100947:	8b 45 08             	mov    0x8(%ebp),%eax
8010094a:	ff d0                	call   *%eax
8010094c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010094f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100953:	0f 89 b5 fe ff ff    	jns    8010080e <consoleintr+0x1e>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100959:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100960:	e8 6f 4d 00 00       	call   801056d4 <release>
  if(doprocdump) {
80100965:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100969:	74 05                	je     80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
8010096b:	e8 a5 4a 00 00       	call   80105415 <procdump>
  }
}
80100970:	c9                   	leave  
80100971:	c3                   	ret    

80100972 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100972:	55                   	push   %ebp
80100973:	89 e5                	mov    %esp,%ebp
80100975:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100978:	8b 45 08             	mov    0x8(%ebp),%eax
8010097b:	89 04 24             	mov    %eax,(%esp)
8010097e:	e8 06 11 00 00       	call   80101a89 <iunlock>
  target = n;
80100983:	8b 45 10             	mov    0x10(%ebp),%eax
80100986:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100989:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100990:	e8 d8 4c 00 00       	call   8010566d <acquire>
  while(n > 0){
80100995:	e9 aa 00 00 00       	jmp    80100a44 <consoleread+0xd2>
    while(input.r == input.w){
8010099a:	eb 42                	jmp    801009de <consoleread+0x6c>
      if(proc->killed){
8010099c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801009a2:	8b 40 24             	mov    0x24(%eax),%eax
801009a5:	85 c0                	test   %eax,%eax
801009a7:	74 21                	je     801009ca <consoleread+0x58>
        release(&cons.lock);
801009a9:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
801009b0:	e8 1f 4d 00 00       	call   801056d4 <release>
        ilock(ip);
801009b5:	8b 45 08             	mov    0x8(%ebp),%eax
801009b8:	89 04 24             	mov    %eax,(%esp)
801009bb:	e8 b2 0f 00 00       	call   80101972 <ilock>
        return -1;
801009c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009c5:	e9 a5 00 00 00       	jmp    80100a6f <consoleread+0xfd>
      }
      sleep(&input.r, &cons.lock);
801009ca:	c7 44 24 04 e0 c5 10 	movl   $0x8010c5e0,0x4(%esp)
801009d1:	80 
801009d2:	c7 04 24 60 20 11 80 	movl   $0x80112060,(%esp)
801009d9:	e8 b5 48 00 00       	call   80105293 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801009de:	8b 15 60 20 11 80    	mov    0x80112060,%edx
801009e4:	a1 64 20 11 80       	mov    0x80112064,%eax
801009e9:	39 c2                	cmp    %eax,%edx
801009eb:	74 af                	je     8010099c <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009ed:	a1 60 20 11 80       	mov    0x80112060,%eax
801009f2:	8d 50 01             	lea    0x1(%eax),%edx
801009f5:	89 15 60 20 11 80    	mov    %edx,0x80112060
801009fb:	83 e0 7f             	and    $0x7f,%eax
801009fe:	0f b6 80 e0 1f 11 80 	movzbl -0x7feee020(%eax),%eax
80100a05:	0f be c0             	movsbl %al,%eax
80100a08:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a0b:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a0f:	75 19                	jne    80100a2a <consoleread+0xb8>
      if(n < target){
80100a11:	8b 45 10             	mov    0x10(%ebp),%eax
80100a14:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a17:	73 0f                	jae    80100a28 <consoleread+0xb6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a19:	a1 60 20 11 80       	mov    0x80112060,%eax
80100a1e:	83 e8 01             	sub    $0x1,%eax
80100a21:	a3 60 20 11 80       	mov    %eax,0x80112060
      }
      break;
80100a26:	eb 26                	jmp    80100a4e <consoleread+0xdc>
80100a28:	eb 24                	jmp    80100a4e <consoleread+0xdc>
    }
    *dst++ = c;
80100a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a2d:	8d 50 01             	lea    0x1(%eax),%edx
80100a30:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a33:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a36:	88 10                	mov    %dl,(%eax)
    --n;
80100a38:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a3c:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a40:	75 02                	jne    80100a44 <consoleread+0xd2>
      break;
80100a42:	eb 0a                	jmp    80100a4e <consoleread+0xdc>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100a44:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a48:	0f 8f 4c ff ff ff    	jg     8010099a <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100a4e:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a55:	e8 7a 4c 00 00       	call   801056d4 <release>
  ilock(ip);
80100a5a:	8b 45 08             	mov    0x8(%ebp),%eax
80100a5d:	89 04 24             	mov    %eax,(%esp)
80100a60:	e8 0d 0f 00 00       	call   80101972 <ilock>

  return target - n;
80100a65:	8b 45 10             	mov    0x10(%ebp),%eax
80100a68:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a6b:	29 c2                	sub    %eax,%edx
80100a6d:	89 d0                	mov    %edx,%eax
}
80100a6f:	c9                   	leave  
80100a70:	c3                   	ret    

80100a71 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a71:	55                   	push   %ebp
80100a72:	89 e5                	mov    %esp,%ebp
80100a74:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a77:	8b 45 08             	mov    0x8(%ebp),%eax
80100a7a:	89 04 24             	mov    %eax,(%esp)
80100a7d:	e8 07 10 00 00       	call   80101a89 <iunlock>
  acquire(&cons.lock);
80100a82:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a89:	e8 df 4b 00 00       	call   8010566d <acquire>
  for(i = 0; i < n; i++)
80100a8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a95:	eb 1d                	jmp    80100ab4 <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a9d:	01 d0                	add    %edx,%eax
80100a9f:	0f b6 00             	movzbl (%eax),%eax
80100aa2:	0f be c0             	movsbl %al,%eax
80100aa5:	0f b6 c0             	movzbl %al,%eax
80100aa8:	89 04 24             	mov    %eax,(%esp)
80100aab:	e8 e3 fc ff ff       	call   80100793 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100ab0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ab7:	3b 45 10             	cmp    0x10(%ebp),%eax
80100aba:	7c db                	jl     80100a97 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100abc:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100ac3:	e8 0c 4c 00 00       	call   801056d4 <release>
  ilock(ip);
80100ac8:	8b 45 08             	mov    0x8(%ebp),%eax
80100acb:	89 04 24             	mov    %eax,(%esp)
80100ace:	e8 9f 0e 00 00       	call   80101972 <ilock>

  return n;
80100ad3:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ad6:	c9                   	leave  
80100ad7:	c3                   	ret    

80100ad8 <consoleinit>:

void
consoleinit(void)
{
80100ad8:	55                   	push   %ebp
80100ad9:	89 e5                	mov    %esp,%ebp
80100adb:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100ade:	c7 44 24 04 66 8f 10 	movl   $0x80108f66,0x4(%esp)
80100ae5:	80 
80100ae6:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100aed:	e8 5a 4b 00 00       	call   8010564c <initlock>

  devsw[CONSOLE].write = consolewrite;
80100af2:	c7 05 2c 2a 11 80 71 	movl   $0x80100a71,0x80112a2c
80100af9:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100afc:	c7 05 28 2a 11 80 72 	movl   $0x80100972,0x80112a28
80100b03:	09 10 80 
  cons.locking = 1;
80100b06:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100b0d:	00 00 00 

  picenable(IRQ_KBD);
80100b10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100b17:	e8 37 35 00 00       	call   80104053 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100b1c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100b23:	00 
80100b24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100b2b:	e8 94 21 00 00       	call   80102cc4 <ioapicenable>
}
80100b30:	c9                   	leave  
80100b31:	c3                   	ret    

80100b32 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b32:	55                   	push   %ebp
80100b33:	89 e5                	mov    %esp,%ebp
80100b35:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b3b:	e8 61 2c 00 00       	call   801037a1 <begin_op>

  if((ip = namei(path)) == 0){
80100b40:	8b 45 08             	mov    0x8(%ebp),%eax
80100b43:	89 04 24             	mov    %eax,(%esp)
80100b46:	e8 b7 1b 00 00       	call   80102702 <namei>
80100b4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b4e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b52:	75 0f                	jne    80100b63 <exec+0x31>
    end_op();
80100b54:	e8 cc 2c 00 00       	call   80103825 <end_op>
    return -1;
80100b59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b5e:	e9 19 04 00 00       	jmp    80100f7c <exec+0x44a>
  }
  ilock(ip);
80100b63:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b66:	89 04 24             	mov    %eax,(%esp)
80100b69:	e8 04 0e 00 00       	call   80101972 <ilock>
  pgdir = 0;
80100b6e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b75:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b7c:	00 
80100b7d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b84:	00 
80100b85:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b92:	89 04 24             	mov    %eax,(%esp)
80100b95:	e8 ca 14 00 00       	call   80102064 <readi>
80100b9a:	83 f8 34             	cmp    $0x34,%eax
80100b9d:	74 05                	je     80100ba4 <exec+0x72>
    goto bad;
80100b9f:	e9 ac 03 00 00       	jmp    80100f50 <exec+0x41e>
  if(elf.magic != ELF_MAGIC)
80100ba4:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100baa:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100baf:	74 05                	je     80100bb6 <exec+0x84>
    goto bad;
80100bb1:	e9 9a 03 00 00       	jmp    80100f50 <exec+0x41e>

  if((pgdir = setupkvm()) == 0)
80100bb6:	e8 e7 79 00 00       	call   801085a2 <setupkvm>
80100bbb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bbe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bc2:	75 05                	jne    80100bc9 <exec+0x97>
    goto bad;
80100bc4:	e9 87 03 00 00       	jmp    80100f50 <exec+0x41e>

  // Load program into memory.
  sz = 0;
80100bc9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bd0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100bd7:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bdd:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100be0:	e9 fc 00 00 00       	jmp    80100ce1 <exec+0x1af>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100be5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100be8:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bef:	00 
80100bf0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bf4:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c01:	89 04 24             	mov    %eax,(%esp)
80100c04:	e8 5b 14 00 00       	call   80102064 <readi>
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	74 05                	je     80100c13 <exec+0xe1>
      goto bad;
80100c0e:	e9 3d 03 00 00       	jmp    80100f50 <exec+0x41e>
    if(ph.type != ELF_PROG_LOAD)
80100c13:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c19:	83 f8 01             	cmp    $0x1,%eax
80100c1c:	74 05                	je     80100c23 <exec+0xf1>
      continue;
80100c1e:	e9 b1 00 00 00       	jmp    80100cd4 <exec+0x1a2>
    if(ph.memsz < ph.filesz)
80100c23:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c29:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c2f:	39 c2                	cmp    %eax,%edx
80100c31:	73 05                	jae    80100c38 <exec+0x106>
      goto bad;
80100c33:	e9 18 03 00 00       	jmp    80100f50 <exec+0x41e>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c38:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c3e:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c44:	01 c2                	add    %eax,%edx
80100c46:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c4c:	39 c2                	cmp    %eax,%edx
80100c4e:	73 05                	jae    80100c55 <exec+0x123>
      goto bad;
80100c50:	e9 fb 02 00 00       	jmp    80100f50 <exec+0x41e>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c55:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c5b:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c61:	01 d0                	add    %edx,%eax
80100c63:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c67:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c6e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c71:	89 04 24             	mov    %eax,(%esp)
80100c74:	e8 f4 7c 00 00       	call   8010896d <allocuvm>
80100c79:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c7c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c80:	75 05                	jne    80100c87 <exec+0x155>
      goto bad;
80100c82:	e9 c9 02 00 00       	jmp    80100f50 <exec+0x41e>
    if(ph.vaddr % PGSIZE != 0)
80100c87:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c8d:	25 ff 0f 00 00       	and    $0xfff,%eax
80100c92:	85 c0                	test   %eax,%eax
80100c94:	74 05                	je     80100c9b <exec+0x169>
      goto bad;
80100c96:	e9 b5 02 00 00       	jmp    80100f50 <exec+0x41e>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c9b:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100ca1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100ca7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100cad:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100cb1:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100cb5:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100cb8:	89 54 24 08          	mov    %edx,0x8(%esp)
80100cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cc0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cc3:	89 04 24             	mov    %eax,(%esp)
80100cc6:	e8 bf 7b 00 00       	call   8010888a <loaduvm>
80100ccb:	85 c0                	test   %eax,%eax
80100ccd:	79 05                	jns    80100cd4 <exec+0x1a2>
      goto bad;
80100ccf:	e9 7c 02 00 00       	jmp    80100f50 <exec+0x41e>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cd4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100cd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cdb:	83 c0 20             	add    $0x20,%eax
80100cde:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ce1:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100ce8:	0f b7 c0             	movzwl %ax,%eax
80100ceb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cee:	0f 8f f1 fe ff ff    	jg     80100be5 <exec+0xb3>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100cf4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100cf7:	89 04 24             	mov    %eax,(%esp)
80100cfa:	e8 62 0e 00 00       	call   80101b61 <iunlockput>
  end_op();
80100cff:	e8 21 2b 00 00       	call   80103825 <end_op>
  ip = 0;
80100d04:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d0e:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d13:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d18:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d1e:	05 00 20 00 00       	add    $0x2000,%eax
80100d23:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d27:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d31:	89 04 24             	mov    %eax,(%esp)
80100d34:	e8 34 7c 00 00       	call   8010896d <allocuvm>
80100d39:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d40:	75 05                	jne    80100d47 <exec+0x215>
    goto bad;
80100d42:	e9 09 02 00 00       	jmp    80100f50 <exec+0x41e>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d47:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d4a:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d56:	89 04 24             	mov    %eax,(%esp)
80100d59:	e8 82 7e 00 00       	call   80108be0 <clearpteu>
  sp = sz;
80100d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d61:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d6b:	e9 9a 00 00 00       	jmp    80100e0a <exec+0x2d8>
    if(argc >= MAXARG)
80100d70:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d74:	76 05                	jbe    80100d7b <exec+0x249>
      goto bad;
80100d76:	e9 d5 01 00 00       	jmp    80100f50 <exec+0x41e>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d7e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d85:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d88:	01 d0                	add    %edx,%eax
80100d8a:	8b 00                	mov    (%eax),%eax
80100d8c:	89 04 24             	mov    %eax,(%esp)
80100d8f:	e8 ac 4d 00 00       	call   80105b40 <strlen>
80100d94:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d97:	29 c2                	sub    %eax,%edx
80100d99:	89 d0                	mov    %edx,%eax
80100d9b:	83 e8 01             	sub    $0x1,%eax
80100d9e:	83 e0 fc             	and    $0xfffffffc,%eax
80100da1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100da4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100da7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dae:	8b 45 0c             	mov    0xc(%ebp),%eax
80100db1:	01 d0                	add    %edx,%eax
80100db3:	8b 00                	mov    (%eax),%eax
80100db5:	89 04 24             	mov    %eax,(%esp)
80100db8:	e8 83 4d 00 00       	call   80105b40 <strlen>
80100dbd:	83 c0 01             	add    $0x1,%eax
80100dc0:	89 c2                	mov    %eax,%edx
80100dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dcf:	01 c8                	add    %ecx,%eax
80100dd1:	8b 00                	mov    (%eax),%eax
80100dd3:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100dd7:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ddb:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dde:	89 44 24 04          	mov    %eax,0x4(%esp)
80100de2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100de5:	89 04 24             	mov    %eax,(%esp)
80100de8:	e8 ab 7f 00 00       	call   80108d98 <copyout>
80100ded:	85 c0                	test   %eax,%eax
80100def:	79 05                	jns    80100df6 <exec+0x2c4>
      goto bad;
80100df1:	e9 5a 01 00 00       	jmp    80100f50 <exec+0x41e>
    ustack[3+argc] = sp;
80100df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df9:	8d 50 03             	lea    0x3(%eax),%edx
80100dfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dff:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e06:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e14:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e17:	01 d0                	add    %edx,%eax
80100e19:	8b 00                	mov    (%eax),%eax
80100e1b:	85 c0                	test   %eax,%eax
80100e1d:	0f 85 4d ff ff ff    	jne    80100d70 <exec+0x23e>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e26:	83 c0 03             	add    $0x3,%eax
80100e29:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e30:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e34:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e3b:	ff ff ff 
  ustack[1] = argc;
80100e3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e41:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4a:	83 c0 01             	add    $0x1,%eax
80100e4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e57:	29 d0                	sub    %edx,%eax
80100e59:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e62:	83 c0 04             	add    $0x4,%eax
80100e65:	c1 e0 02             	shl    $0x2,%eax
80100e68:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e6e:	83 c0 04             	add    $0x4,%eax
80100e71:	c1 e0 02             	shl    $0x2,%eax
80100e74:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e78:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e7e:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e82:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e85:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e8c:	89 04 24             	mov    %eax,(%esp)
80100e8f:	e8 04 7f 00 00       	call   80108d98 <copyout>
80100e94:	85 c0                	test   %eax,%eax
80100e96:	79 05                	jns    80100e9d <exec+0x36b>
    goto bad;
80100e98:	e9 b3 00 00 00       	jmp    80100f50 <exec+0x41e>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e9d:	8b 45 08             	mov    0x8(%ebp),%eax
80100ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ea6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ea9:	eb 17                	jmp    80100ec2 <exec+0x390>
    if(*s == '/')
80100eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eae:	0f b6 00             	movzbl (%eax),%eax
80100eb1:	3c 2f                	cmp    $0x2f,%al
80100eb3:	75 09                	jne    80100ebe <exec+0x38c>
      last = s+1;
80100eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eb8:	83 c0 01             	add    $0x1,%eax
80100ebb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ebe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ec5:	0f b6 00             	movzbl (%eax),%eax
80100ec8:	84 c0                	test   %al,%al
80100eca:	75 df                	jne    80100eab <exec+0x379>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100ecc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed2:	8d 50 6c             	lea    0x6c(%eax),%edx
80100ed5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100edc:	00 
80100edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100ee0:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ee4:	89 14 24             	mov    %edx,(%esp)
80100ee7:	e8 0a 4c 00 00       	call   80105af6 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100eec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ef2:	8b 40 04             	mov    0x4(%eax),%eax
80100ef5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ef8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100efe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f01:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100f04:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f0d:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100f0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f15:	8b 40 18             	mov    0x18(%eax),%eax
80100f18:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f1e:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f27:	8b 40 18             	mov    0x18(%eax),%eax
80100f2a:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f2d:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f36:	89 04 24             	mov    %eax,(%esp)
80100f39:	e8 30 77 00 00       	call   8010866e <switchuvm>
  freevm(oldpgdir);
80100f3e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f41:	89 04 24             	mov    %eax,(%esp)
80100f44:	e8 00 7c 00 00       	call   80108b49 <freevm>
  return 0;
80100f49:	b8 00 00 00 00       	mov    $0x0,%eax
80100f4e:	eb 2c                	jmp    80100f7c <exec+0x44a>

 bad:
  if(pgdir)
80100f50:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f54:	74 0b                	je     80100f61 <exec+0x42f>
    freevm(pgdir);
80100f56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f59:	89 04 24             	mov    %eax,(%esp)
80100f5c:	e8 e8 7b 00 00       	call   80108b49 <freevm>
  if(ip){
80100f61:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f65:	74 10                	je     80100f77 <exec+0x445>
    iunlockput(ip);
80100f67:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f6a:	89 04 24             	mov    %eax,(%esp)
80100f6d:	e8 ef 0b 00 00       	call   80101b61 <iunlockput>
    end_op();
80100f72:	e8 ae 28 00 00       	call   80103825 <end_op>
  }
  return -1;
80100f77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f7c:	c9                   	leave  
80100f7d:	c3                   	ret    

80100f7e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f7e:	55                   	push   %ebp
80100f7f:	89 e5                	mov    %esp,%ebp
80100f81:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f84:	c7 44 24 04 6e 8f 10 	movl   $0x80108f6e,0x4(%esp)
80100f8b:	80 
80100f8c:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
80100f93:	e8 b4 46 00 00       	call   8010564c <initlock>
}
80100f98:	c9                   	leave  
80100f99:	c3                   	ret    

80100f9a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f9a:	55                   	push   %ebp
80100f9b:	89 e5                	mov    %esp,%ebp
80100f9d:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fa0:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
80100fa7:	e8 c1 46 00 00       	call   8010566d <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fac:	c7 45 f4 b4 20 11 80 	movl   $0x801120b4,-0xc(%ebp)
80100fb3:	eb 29                	jmp    80100fde <filealloc+0x44>
    if(f->ref == 0){
80100fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fb8:	8b 40 04             	mov    0x4(%eax),%eax
80100fbb:	85 c0                	test   %eax,%eax
80100fbd:	75 1b                	jne    80100fda <filealloc+0x40>
      f->ref = 1;
80100fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fc2:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fc9:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
80100fd0:	e8 ff 46 00 00       	call   801056d4 <release>
      return f;
80100fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fd8:	eb 1e                	jmp    80100ff8 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fda:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fde:	81 7d f4 14 2a 11 80 	cmpl   $0x80112a14,-0xc(%ebp)
80100fe5:	72 ce                	jb     80100fb5 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fe7:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
80100fee:	e8 e1 46 00 00       	call   801056d4 <release>
  return 0;
80100ff3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100ff8:	c9                   	leave  
80100ff9:	c3                   	ret    

80100ffa <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ffa:	55                   	push   %ebp
80100ffb:	89 e5                	mov    %esp,%ebp
80100ffd:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80101000:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
80101007:	e8 61 46 00 00       	call   8010566d <acquire>
  if(f->ref < 1)
8010100c:	8b 45 08             	mov    0x8(%ebp),%eax
8010100f:	8b 40 04             	mov    0x4(%eax),%eax
80101012:	85 c0                	test   %eax,%eax
80101014:	7f 0c                	jg     80101022 <filedup+0x28>
    panic("filedup");
80101016:	c7 04 24 75 8f 10 80 	movl   $0x80108f75,(%esp)
8010101d:	e8 40 f5 ff ff       	call   80100562 <panic>
  f->ref++;
80101022:	8b 45 08             	mov    0x8(%ebp),%eax
80101025:	8b 40 04             	mov    0x4(%eax),%eax
80101028:	8d 50 01             	lea    0x1(%eax),%edx
8010102b:	8b 45 08             	mov    0x8(%ebp),%eax
8010102e:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101031:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
80101038:	e8 97 46 00 00       	call   801056d4 <release>
  return f;
8010103d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101040:	c9                   	leave  
80101041:	c3                   	ret    

80101042 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101042:	55                   	push   %ebp
80101043:	89 e5                	mov    %esp,%ebp
80101045:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80101048:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
8010104f:	e8 19 46 00 00       	call   8010566d <acquire>
  if(f->ref < 1)
80101054:	8b 45 08             	mov    0x8(%ebp),%eax
80101057:	8b 40 04             	mov    0x4(%eax),%eax
8010105a:	85 c0                	test   %eax,%eax
8010105c:	7f 0c                	jg     8010106a <fileclose+0x28>
    panic("fileclose");
8010105e:	c7 04 24 7d 8f 10 80 	movl   $0x80108f7d,(%esp)
80101065:	e8 f8 f4 ff ff       	call   80100562 <panic>
  if(--f->ref > 0){
8010106a:	8b 45 08             	mov    0x8(%ebp),%eax
8010106d:	8b 40 04             	mov    0x4(%eax),%eax
80101070:	8d 50 ff             	lea    -0x1(%eax),%edx
80101073:	8b 45 08             	mov    0x8(%ebp),%eax
80101076:	89 50 04             	mov    %edx,0x4(%eax)
80101079:	8b 45 08             	mov    0x8(%ebp),%eax
8010107c:	8b 40 04             	mov    0x4(%eax),%eax
8010107f:	85 c0                	test   %eax,%eax
80101081:	7e 11                	jle    80101094 <fileclose+0x52>
    release(&ftable.lock);
80101083:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
8010108a:	e8 45 46 00 00       	call   801056d4 <release>
8010108f:	e9 82 00 00 00       	jmp    80101116 <fileclose+0xd4>
    return;
  }
  ff = *f;
80101094:	8b 45 08             	mov    0x8(%ebp),%eax
80101097:	8b 10                	mov    (%eax),%edx
80101099:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010109c:	8b 50 04             	mov    0x4(%eax),%edx
8010109f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801010a2:	8b 50 08             	mov    0x8(%eax),%edx
801010a5:	89 55 e8             	mov    %edx,-0x18(%ebp)
801010a8:	8b 50 0c             	mov    0xc(%eax),%edx
801010ab:	89 55 ec             	mov    %edx,-0x14(%ebp)
801010ae:	8b 50 10             	mov    0x10(%eax),%edx
801010b1:	89 55 f0             	mov    %edx,-0x10(%ebp)
801010b4:	8b 40 14             	mov    0x14(%eax),%eax
801010b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801010ba:	8b 45 08             	mov    0x8(%ebp),%eax
801010bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010c4:	8b 45 08             	mov    0x8(%ebp),%eax
801010c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010cd:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
801010d4:	e8 fb 45 00 00       	call   801056d4 <release>

  if(ff.type == FD_PIPE)
801010d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010dc:	83 f8 01             	cmp    $0x1,%eax
801010df:	75 18                	jne    801010f9 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
801010e1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010e5:	0f be d0             	movsbl %al,%edx
801010e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010eb:	89 54 24 04          	mov    %edx,0x4(%esp)
801010ef:	89 04 24             	mov    %eax,(%esp)
801010f2:	e8 0c 32 00 00       	call   80104303 <pipeclose>
801010f7:	eb 1d                	jmp    80101116 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801010f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010fc:	83 f8 02             	cmp    $0x2,%eax
801010ff:	75 15                	jne    80101116 <fileclose+0xd4>
    begin_op();
80101101:	e8 9b 26 00 00       	call   801037a1 <begin_op>
    iput(ff.ip);
80101106:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101109:	89 04 24             	mov    %eax,(%esp)
8010110c:	e8 bc 09 00 00       	call   80101acd <iput>
    end_op();
80101111:	e8 0f 27 00 00       	call   80103825 <end_op>
  }
}
80101116:	c9                   	leave  
80101117:	c3                   	ret    

80101118 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101118:	55                   	push   %ebp
80101119:	89 e5                	mov    %esp,%ebp
8010111b:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
8010111e:	8b 45 08             	mov    0x8(%ebp),%eax
80101121:	8b 00                	mov    (%eax),%eax
80101123:	83 f8 02             	cmp    $0x2,%eax
80101126:	75 38                	jne    80101160 <filestat+0x48>
    ilock(f->ip);
80101128:	8b 45 08             	mov    0x8(%ebp),%eax
8010112b:	8b 40 10             	mov    0x10(%eax),%eax
8010112e:	89 04 24             	mov    %eax,(%esp)
80101131:	e8 3c 08 00 00       	call   80101972 <ilock>
    stati(f->ip, st);
80101136:	8b 45 08             	mov    0x8(%ebp),%eax
80101139:	8b 40 10             	mov    0x10(%eax),%eax
8010113c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010113f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101143:	89 04 24             	mov    %eax,(%esp)
80101146:	e8 d4 0e 00 00       	call   8010201f <stati>
    iunlock(f->ip);
8010114b:	8b 45 08             	mov    0x8(%ebp),%eax
8010114e:	8b 40 10             	mov    0x10(%eax),%eax
80101151:	89 04 24             	mov    %eax,(%esp)
80101154:	e8 30 09 00 00       	call   80101a89 <iunlock>
    return 0;
80101159:	b8 00 00 00 00       	mov    $0x0,%eax
8010115e:	eb 05                	jmp    80101165 <filestat+0x4d>
  }
  return -1;
80101160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101165:	c9                   	leave  
80101166:	c3                   	ret    

80101167 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101167:	55                   	push   %ebp
80101168:	89 e5                	mov    %esp,%ebp
8010116a:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
8010116d:	8b 45 08             	mov    0x8(%ebp),%eax
80101170:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101174:	84 c0                	test   %al,%al
80101176:	75 0a                	jne    80101182 <fileread+0x1b>
    return -1;
80101178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010117d:	e9 9f 00 00 00       	jmp    80101221 <fileread+0xba>
  if(f->type == FD_PIPE)
80101182:	8b 45 08             	mov    0x8(%ebp),%eax
80101185:	8b 00                	mov    (%eax),%eax
80101187:	83 f8 01             	cmp    $0x1,%eax
8010118a:	75 1e                	jne    801011aa <fileread+0x43>
    return piperead(f->pipe, addr, n);
8010118c:	8b 45 08             	mov    0x8(%ebp),%eax
8010118f:	8b 40 0c             	mov    0xc(%eax),%eax
80101192:	8b 55 10             	mov    0x10(%ebp),%edx
80101195:	89 54 24 08          	mov    %edx,0x8(%esp)
80101199:	8b 55 0c             	mov    0xc(%ebp),%edx
8010119c:	89 54 24 04          	mov    %edx,0x4(%esp)
801011a0:	89 04 24             	mov    %eax,(%esp)
801011a3:	e8 dc 32 00 00       	call   80104484 <piperead>
801011a8:	eb 77                	jmp    80101221 <fileread+0xba>
  if(f->type == FD_INODE){
801011aa:	8b 45 08             	mov    0x8(%ebp),%eax
801011ad:	8b 00                	mov    (%eax),%eax
801011af:	83 f8 02             	cmp    $0x2,%eax
801011b2:	75 61                	jne    80101215 <fileread+0xae>
    ilock(f->ip);
801011b4:	8b 45 08             	mov    0x8(%ebp),%eax
801011b7:	8b 40 10             	mov    0x10(%eax),%eax
801011ba:	89 04 24             	mov    %eax,(%esp)
801011bd:	e8 b0 07 00 00       	call   80101972 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011c5:	8b 45 08             	mov    0x8(%ebp),%eax
801011c8:	8b 50 14             	mov    0x14(%eax),%edx
801011cb:	8b 45 08             	mov    0x8(%ebp),%eax
801011ce:	8b 40 10             	mov    0x10(%eax),%eax
801011d1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801011d5:	89 54 24 08          	mov    %edx,0x8(%esp)
801011d9:	8b 55 0c             	mov    0xc(%ebp),%edx
801011dc:	89 54 24 04          	mov    %edx,0x4(%esp)
801011e0:	89 04 24             	mov    %eax,(%esp)
801011e3:	e8 7c 0e 00 00       	call   80102064 <readi>
801011e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011ef:	7e 11                	jle    80101202 <fileread+0x9b>
      f->off += r;
801011f1:	8b 45 08             	mov    0x8(%ebp),%eax
801011f4:	8b 50 14             	mov    0x14(%eax),%edx
801011f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011fa:	01 c2                	add    %eax,%edx
801011fc:	8b 45 08             	mov    0x8(%ebp),%eax
801011ff:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101202:	8b 45 08             	mov    0x8(%ebp),%eax
80101205:	8b 40 10             	mov    0x10(%eax),%eax
80101208:	89 04 24             	mov    %eax,(%esp)
8010120b:	e8 79 08 00 00       	call   80101a89 <iunlock>
    return r;
80101210:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101213:	eb 0c                	jmp    80101221 <fileread+0xba>
  }
  panic("fileread");
80101215:	c7 04 24 87 8f 10 80 	movl   $0x80108f87,(%esp)
8010121c:	e8 41 f3 ff ff       	call   80100562 <panic>
}
80101221:	c9                   	leave  
80101222:	c3                   	ret    

80101223 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101223:	55                   	push   %ebp
80101224:	89 e5                	mov    %esp,%ebp
80101226:	53                   	push   %ebx
80101227:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
8010122a:	8b 45 08             	mov    0x8(%ebp),%eax
8010122d:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101231:	84 c0                	test   %al,%al
80101233:	75 0a                	jne    8010123f <filewrite+0x1c>
    return -1;
80101235:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010123a:	e9 20 01 00 00       	jmp    8010135f <filewrite+0x13c>
  if(f->type == FD_PIPE)
8010123f:	8b 45 08             	mov    0x8(%ebp),%eax
80101242:	8b 00                	mov    (%eax),%eax
80101244:	83 f8 01             	cmp    $0x1,%eax
80101247:	75 21                	jne    8010126a <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
80101249:	8b 45 08             	mov    0x8(%ebp),%eax
8010124c:	8b 40 0c             	mov    0xc(%eax),%eax
8010124f:	8b 55 10             	mov    0x10(%ebp),%edx
80101252:	89 54 24 08          	mov    %edx,0x8(%esp)
80101256:	8b 55 0c             	mov    0xc(%ebp),%edx
80101259:	89 54 24 04          	mov    %edx,0x4(%esp)
8010125d:	89 04 24             	mov    %eax,(%esp)
80101260:	e8 30 31 00 00       	call   80104395 <pipewrite>
80101265:	e9 f5 00 00 00       	jmp    8010135f <filewrite+0x13c>
  if(f->type == FD_INODE){
8010126a:	8b 45 08             	mov    0x8(%ebp),%eax
8010126d:	8b 00                	mov    (%eax),%eax
8010126f:	83 f8 02             	cmp    $0x2,%eax
80101272:	0f 85 db 00 00 00    	jne    80101353 <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101278:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
8010127f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101286:	e9 a8 00 00 00       	jmp    80101333 <filewrite+0x110>
      int n1 = n - i;
8010128b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010128e:	8b 55 10             	mov    0x10(%ebp),%edx
80101291:	29 c2                	sub    %eax,%edx
80101293:	89 d0                	mov    %edx,%eax
80101295:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101298:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010129b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010129e:	7e 06                	jle    801012a6 <filewrite+0x83>
        n1 = max;
801012a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012a3:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801012a6:	e8 f6 24 00 00       	call   801037a1 <begin_op>
      ilock(f->ip);
801012ab:	8b 45 08             	mov    0x8(%ebp),%eax
801012ae:	8b 40 10             	mov    0x10(%eax),%eax
801012b1:	89 04 24             	mov    %eax,(%esp)
801012b4:	e8 b9 06 00 00       	call   80101972 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012b9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012bc:	8b 45 08             	mov    0x8(%ebp),%eax
801012bf:	8b 50 14             	mov    0x14(%eax),%edx
801012c2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801012c8:	01 c3                	add    %eax,%ebx
801012ca:	8b 45 08             	mov    0x8(%ebp),%eax
801012cd:	8b 40 10             	mov    0x10(%eax),%eax
801012d0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801012d4:	89 54 24 08          	mov    %edx,0x8(%esp)
801012d8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801012dc:	89 04 24             	mov    %eax,(%esp)
801012df:	e8 e4 0e 00 00       	call   801021c8 <writei>
801012e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012eb:	7e 11                	jle    801012fe <filewrite+0xdb>
        f->off += r;
801012ed:	8b 45 08             	mov    0x8(%ebp),%eax
801012f0:	8b 50 14             	mov    0x14(%eax),%edx
801012f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012f6:	01 c2                	add    %eax,%edx
801012f8:	8b 45 08             	mov    0x8(%ebp),%eax
801012fb:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101301:	8b 40 10             	mov    0x10(%eax),%eax
80101304:	89 04 24             	mov    %eax,(%esp)
80101307:	e8 7d 07 00 00       	call   80101a89 <iunlock>
      end_op();
8010130c:	e8 14 25 00 00       	call   80103825 <end_op>

      if(r < 0)
80101311:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101315:	79 02                	jns    80101319 <filewrite+0xf6>
        break;
80101317:	eb 26                	jmp    8010133f <filewrite+0x11c>
      if(r != n1)
80101319:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010131c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010131f:	74 0c                	je     8010132d <filewrite+0x10a>
        panic("short filewrite");
80101321:	c7 04 24 90 8f 10 80 	movl   $0x80108f90,(%esp)
80101328:	e8 35 f2 ff ff       	call   80100562 <panic>
      i += r;
8010132d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101330:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101333:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101336:	3b 45 10             	cmp    0x10(%ebp),%eax
80101339:	0f 8c 4c ff ff ff    	jl     8010128b <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010133f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101342:	3b 45 10             	cmp    0x10(%ebp),%eax
80101345:	75 05                	jne    8010134c <filewrite+0x129>
80101347:	8b 45 10             	mov    0x10(%ebp),%eax
8010134a:	eb 05                	jmp    80101351 <filewrite+0x12e>
8010134c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101351:	eb 0c                	jmp    8010135f <filewrite+0x13c>
  }
  panic("filewrite");
80101353:	c7 04 24 a0 8f 10 80 	movl   $0x80108fa0,(%esp)
8010135a:	e8 03 f2 ff ff       	call   80100562 <panic>
}
8010135f:	83 c4 24             	add    $0x24,%esp
80101362:	5b                   	pop    %ebx
80101363:	5d                   	pop    %ebp
80101364:	c3                   	ret    

80101365 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101365:	55                   	push   %ebp
80101366:	89 e5                	mov    %esp,%ebp
80101368:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, 1);
8010136b:	8b 45 08             	mov    0x8(%ebp),%eax
8010136e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101375:	00 
80101376:	89 04 24             	mov    %eax,(%esp)
80101379:	e8 37 ee ff ff       	call   801001b5 <bread>
8010137e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101381:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101384:	83 c0 5c             	add    $0x5c,%eax
80101387:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
8010138e:	00 
8010138f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101393:	8b 45 0c             	mov    0xc(%ebp),%eax
80101396:	89 04 24             	mov    %eax,(%esp)
80101399:	e8 07 46 00 00       	call   801059a5 <memmove>
  brelse(bp);
8010139e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a1:	89 04 24             	mov    %eax,(%esp)
801013a4:	e8 83 ee ff ff       	call   8010022c <brelse>
}
801013a9:	c9                   	leave  
801013aa:	c3                   	ret    

801013ab <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013ab:	55                   	push   %ebp
801013ac:	89 e5                	mov    %esp,%ebp
801013ae:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, bno);
801013b1:	8b 55 0c             	mov    0xc(%ebp),%edx
801013b4:	8b 45 08             	mov    0x8(%ebp),%eax
801013b7:	89 54 24 04          	mov    %edx,0x4(%esp)
801013bb:	89 04 24             	mov    %eax,(%esp)
801013be:	e8 f2 ed ff ff       	call   801001b5 <bread>
801013c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013c9:	83 c0 5c             	add    $0x5c,%eax
801013cc:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801013d3:	00 
801013d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801013db:	00 
801013dc:	89 04 24             	mov    %eax,(%esp)
801013df:	e8 f2 44 00 00       	call   801058d6 <memset>
  log_write(bp);
801013e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013e7:	89 04 24             	mov    %eax,(%esp)
801013ea:	e8 bd 25 00 00       	call   801039ac <log_write>
  brelse(bp);
801013ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f2:	89 04 24             	mov    %eax,(%esp)
801013f5:	e8 32 ee ff ff       	call   8010022c <brelse>
}
801013fa:	c9                   	leave  
801013fb:	c3                   	ret    

801013fc <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013fc:	55                   	push   %ebp
801013fd:	89 e5                	mov    %esp,%ebp
801013ff:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101402:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101409:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101410:	e9 07 01 00 00       	jmp    8010151c <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
80101415:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101418:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
8010141e:	85 c0                	test   %eax,%eax
80101420:	0f 48 c2             	cmovs  %edx,%eax
80101423:	c1 f8 0c             	sar    $0xc,%eax
80101426:	89 c2                	mov    %eax,%edx
80101428:	a1 98 2a 11 80       	mov    0x80112a98,%eax
8010142d:	01 d0                	add    %edx,%eax
8010142f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101433:	8b 45 08             	mov    0x8(%ebp),%eax
80101436:	89 04 24             	mov    %eax,(%esp)
80101439:	e8 77 ed ff ff       	call   801001b5 <bread>
8010143e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101441:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101448:	e9 9d 00 00 00       	jmp    801014ea <balloc+0xee>
      m = 1 << (bi % 8);
8010144d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101450:	99                   	cltd   
80101451:	c1 ea 1d             	shr    $0x1d,%edx
80101454:	01 d0                	add    %edx,%eax
80101456:	83 e0 07             	and    $0x7,%eax
80101459:	29 d0                	sub    %edx,%eax
8010145b:	ba 01 00 00 00       	mov    $0x1,%edx
80101460:	89 c1                	mov    %eax,%ecx
80101462:	d3 e2                	shl    %cl,%edx
80101464:	89 d0                	mov    %edx,%eax
80101466:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101469:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010146c:	8d 50 07             	lea    0x7(%eax),%edx
8010146f:	85 c0                	test   %eax,%eax
80101471:	0f 48 c2             	cmovs  %edx,%eax
80101474:	c1 f8 03             	sar    $0x3,%eax
80101477:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010147a:	0f b6 44 02 5c       	movzbl 0x5c(%edx,%eax,1),%eax
8010147f:	0f b6 c0             	movzbl %al,%eax
80101482:	23 45 e8             	and    -0x18(%ebp),%eax
80101485:	85 c0                	test   %eax,%eax
80101487:	75 5d                	jne    801014e6 <balloc+0xea>
        bp->data[bi/8] |= m;  // Mark block in use.
80101489:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010148c:	8d 50 07             	lea    0x7(%eax),%edx
8010148f:	85 c0                	test   %eax,%eax
80101491:	0f 48 c2             	cmovs  %edx,%eax
80101494:	c1 f8 03             	sar    $0x3,%eax
80101497:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010149a:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
8010149f:	89 d1                	mov    %edx,%ecx
801014a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014a4:	09 ca                	or     %ecx,%edx
801014a6:	89 d1                	mov    %edx,%ecx
801014a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014ab:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
801014af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014b2:	89 04 24             	mov    %eax,(%esp)
801014b5:	e8 f2 24 00 00       	call   801039ac <log_write>
        brelse(bp);
801014ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014bd:	89 04 24             	mov    %eax,(%esp)
801014c0:	e8 67 ed ff ff       	call   8010022c <brelse>
        bzero(dev, b + bi);
801014c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014cb:	01 c2                	add    %eax,%edx
801014cd:	8b 45 08             	mov    0x8(%ebp),%eax
801014d0:	89 54 24 04          	mov    %edx,0x4(%esp)
801014d4:	89 04 24             	mov    %eax,(%esp)
801014d7:	e8 cf fe ff ff       	call   801013ab <bzero>
        return b + bi;
801014dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014df:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014e2:	01 d0                	add    %edx,%eax
801014e4:	eb 52                	jmp    80101538 <balloc+0x13c>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014e6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014ea:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014f1:	7f 17                	jg     8010150a <balloc+0x10e>
801014f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014f9:	01 d0                	add    %edx,%eax
801014fb:	89 c2                	mov    %eax,%edx
801014fd:	a1 80 2a 11 80       	mov    0x80112a80,%eax
80101502:	39 c2                	cmp    %eax,%edx
80101504:	0f 82 43 ff ff ff    	jb     8010144d <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010150a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010150d:	89 04 24             	mov    %eax,(%esp)
80101510:	e8 17 ed ff ff       	call   8010022c <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101515:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010151c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010151f:	a1 80 2a 11 80       	mov    0x80112a80,%eax
80101524:	39 c2                	cmp    %eax,%edx
80101526:	0f 82 e9 fe ff ff    	jb     80101415 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010152c:	c7 04 24 ac 8f 10 80 	movl   $0x80108fac,(%esp)
80101533:	e8 2a f0 ff ff       	call   80100562 <panic>
}
80101538:	c9                   	leave  
80101539:	c3                   	ret    

8010153a <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010153a:	55                   	push   %ebp
8010153b:	89 e5                	mov    %esp,%ebp
8010153d:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101540:	c7 44 24 04 80 2a 11 	movl   $0x80112a80,0x4(%esp)
80101547:	80 
80101548:	8b 45 08             	mov    0x8(%ebp),%eax
8010154b:	89 04 24             	mov    %eax,(%esp)
8010154e:	e8 12 fe ff ff       	call   80101365 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101553:	8b 45 0c             	mov    0xc(%ebp),%eax
80101556:	c1 e8 0c             	shr    $0xc,%eax
80101559:	89 c2                	mov    %eax,%edx
8010155b:	a1 98 2a 11 80       	mov    0x80112a98,%eax
80101560:	01 c2                	add    %eax,%edx
80101562:	8b 45 08             	mov    0x8(%ebp),%eax
80101565:	89 54 24 04          	mov    %edx,0x4(%esp)
80101569:	89 04 24             	mov    %eax,(%esp)
8010156c:	e8 44 ec ff ff       	call   801001b5 <bread>
80101571:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101574:	8b 45 0c             	mov    0xc(%ebp),%eax
80101577:	25 ff 0f 00 00       	and    $0xfff,%eax
8010157c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010157f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101582:	99                   	cltd   
80101583:	c1 ea 1d             	shr    $0x1d,%edx
80101586:	01 d0                	add    %edx,%eax
80101588:	83 e0 07             	and    $0x7,%eax
8010158b:	29 d0                	sub    %edx,%eax
8010158d:	ba 01 00 00 00       	mov    $0x1,%edx
80101592:	89 c1                	mov    %eax,%ecx
80101594:	d3 e2                	shl    %cl,%edx
80101596:	89 d0                	mov    %edx,%eax
80101598:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010159b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010159e:	8d 50 07             	lea    0x7(%eax),%edx
801015a1:	85 c0                	test   %eax,%eax
801015a3:	0f 48 c2             	cmovs  %edx,%eax
801015a6:	c1 f8 03             	sar    $0x3,%eax
801015a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015ac:	0f b6 44 02 5c       	movzbl 0x5c(%edx,%eax,1),%eax
801015b1:	0f b6 c0             	movzbl %al,%eax
801015b4:	23 45 ec             	and    -0x14(%ebp),%eax
801015b7:	85 c0                	test   %eax,%eax
801015b9:	75 0c                	jne    801015c7 <bfree+0x8d>
    panic("freeing free block");
801015bb:	c7 04 24 c2 8f 10 80 	movl   $0x80108fc2,(%esp)
801015c2:	e8 9b ef ff ff       	call   80100562 <panic>
  bp->data[bi/8] &= ~m;
801015c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015ca:	8d 50 07             	lea    0x7(%eax),%edx
801015cd:	85 c0                	test   %eax,%eax
801015cf:	0f 48 c2             	cmovs  %edx,%eax
801015d2:	c1 f8 03             	sar    $0x3,%eax
801015d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015d8:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
801015dd:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015e0:	f7 d1                	not    %ecx
801015e2:	21 ca                	and    %ecx,%edx
801015e4:	89 d1                	mov    %edx,%ecx
801015e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015e9:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
801015ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015f0:	89 04 24             	mov    %eax,(%esp)
801015f3:	e8 b4 23 00 00       	call   801039ac <log_write>
  brelse(bp);
801015f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015fb:	89 04 24             	mov    %eax,(%esp)
801015fe:	e8 29 ec ff ff       	call   8010022c <brelse>
}
80101603:	c9                   	leave  
80101604:	c3                   	ret    

80101605 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101605:	55                   	push   %ebp
80101606:	89 e5                	mov    %esp,%ebp
80101608:	57                   	push   %edi
80101609:	56                   	push   %esi
8010160a:	53                   	push   %ebx
8010160b:	83 ec 4c             	sub    $0x4c,%esp
  int i = 0;
8010160e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
80101615:	c7 44 24 04 d5 8f 10 	movl   $0x80108fd5,0x4(%esp)
8010161c:	80 
8010161d:	c7 04 24 a0 2a 11 80 	movl   $0x80112aa0,(%esp)
80101624:	e8 23 40 00 00       	call   8010564c <initlock>
  for(i = 0; i < NINODE; i++) {
80101629:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101630:	eb 2c                	jmp    8010165e <iinit+0x59>
    initsleeplock(&icache.inode[i].lock, "inode");
80101632:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101635:	89 d0                	mov    %edx,%eax
80101637:	c1 e0 03             	shl    $0x3,%eax
8010163a:	01 d0                	add    %edx,%eax
8010163c:	c1 e0 04             	shl    $0x4,%eax
8010163f:	83 c0 30             	add    $0x30,%eax
80101642:	05 a0 2a 11 80       	add    $0x80112aa0,%eax
80101647:	83 c0 10             	add    $0x10,%eax
8010164a:	c7 44 24 04 dc 8f 10 	movl   $0x80108fdc,0x4(%esp)
80101651:	80 
80101652:	89 04 24             	mov    %eax,(%esp)
80101655:	e8 b5 3e 00 00       	call   8010550f <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
8010165a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010165e:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
80101662:	7e ce                	jle    80101632 <iinit+0x2d>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
80101664:	c7 44 24 04 80 2a 11 	movl   $0x80112a80,0x4(%esp)
8010166b:	80 
8010166c:	8b 45 08             	mov    0x8(%ebp),%eax
8010166f:	89 04 24             	mov    %eax,(%esp)
80101672:	e8 ee fc ff ff       	call   80101365 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101677:	a1 98 2a 11 80       	mov    0x80112a98,%eax
8010167c:	8b 3d 94 2a 11 80    	mov    0x80112a94,%edi
80101682:	8b 35 90 2a 11 80    	mov    0x80112a90,%esi
80101688:	8b 1d 8c 2a 11 80    	mov    0x80112a8c,%ebx
8010168e:	8b 0d 88 2a 11 80    	mov    0x80112a88,%ecx
80101694:	8b 15 84 2a 11 80    	mov    0x80112a84,%edx
8010169a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010169d:	8b 15 80 2a 11 80    	mov    0x80112a80,%edx
801016a3:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801016a7:	89 7c 24 18          	mov    %edi,0x18(%esp)
801016ab:	89 74 24 14          	mov    %esi,0x14(%esp)
801016af:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801016b3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801016b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801016ba:	89 44 24 08          	mov    %eax,0x8(%esp)
801016be:	89 d0                	mov    %edx,%eax
801016c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801016c4:	c7 04 24 e4 8f 10 80 	movl   $0x80108fe4,(%esp)
801016cb:	e8 f8 ec ff ff       	call   801003c8 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801016d0:	83 c4 4c             	add    $0x4c,%esp
801016d3:	5b                   	pop    %ebx
801016d4:	5e                   	pop    %esi
801016d5:	5f                   	pop    %edi
801016d6:	5d                   	pop    %ebp
801016d7:	c3                   	ret    

801016d8 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801016d8:	55                   	push   %ebp
801016d9:	89 e5                	mov    %esp,%ebp
801016db:	83 ec 28             	sub    $0x28,%esp
801016de:	8b 45 0c             	mov    0xc(%ebp),%eax
801016e1:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016e5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801016ec:	e9 9e 00 00 00       	jmp    8010178f <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
801016f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016f4:	c1 e8 03             	shr    $0x3,%eax
801016f7:	89 c2                	mov    %eax,%edx
801016f9:	a1 94 2a 11 80       	mov    0x80112a94,%eax
801016fe:	01 d0                	add    %edx,%eax
80101700:	89 44 24 04          	mov    %eax,0x4(%esp)
80101704:	8b 45 08             	mov    0x8(%ebp),%eax
80101707:	89 04 24             	mov    %eax,(%esp)
8010170a:	e8 a6 ea ff ff       	call   801001b5 <bread>
8010170f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101712:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101715:	8d 50 5c             	lea    0x5c(%eax),%edx
80101718:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010171b:	83 e0 07             	and    $0x7,%eax
8010171e:	c1 e0 06             	shl    $0x6,%eax
80101721:	01 d0                	add    %edx,%eax
80101723:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101726:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101729:	0f b7 00             	movzwl (%eax),%eax
8010172c:	66 85 c0             	test   %ax,%ax
8010172f:	75 4f                	jne    80101780 <ialloc+0xa8>
      memset(dip, 0, sizeof(*dip));
80101731:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101738:	00 
80101739:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101740:	00 
80101741:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101744:	89 04 24             	mov    %eax,(%esp)
80101747:	e8 8a 41 00 00       	call   801058d6 <memset>
      dip->type = type;
8010174c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010174f:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
80101753:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101756:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101759:	89 04 24             	mov    %eax,(%esp)
8010175c:	e8 4b 22 00 00       	call   801039ac <log_write>
      brelse(bp);
80101761:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101764:	89 04 24             	mov    %eax,(%esp)
80101767:	e8 c0 ea ff ff       	call   8010022c <brelse>
      return iget(dev, inum);
8010176c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010176f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101773:	8b 45 08             	mov    0x8(%ebp),%eax
80101776:	89 04 24             	mov    %eax,(%esp)
80101779:	e8 ed 00 00 00       	call   8010186b <iget>
8010177e:	eb 2b                	jmp    801017ab <ialloc+0xd3>
    }
    brelse(bp);
80101780:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101783:	89 04 24             	mov    %eax,(%esp)
80101786:	e8 a1 ea ff ff       	call   8010022c <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010178b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010178f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101792:	a1 88 2a 11 80       	mov    0x80112a88,%eax
80101797:	39 c2                	cmp    %eax,%edx
80101799:	0f 82 52 ff ff ff    	jb     801016f1 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
8010179f:	c7 04 24 37 90 10 80 	movl   $0x80109037,(%esp)
801017a6:	e8 b7 ed ff ff       	call   80100562 <panic>
}
801017ab:	c9                   	leave  
801017ac:	c3                   	ret    

801017ad <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801017ad:	55                   	push   %ebp
801017ae:	89 e5                	mov    %esp,%ebp
801017b0:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017b3:	8b 45 08             	mov    0x8(%ebp),%eax
801017b6:	8b 40 04             	mov    0x4(%eax),%eax
801017b9:	c1 e8 03             	shr    $0x3,%eax
801017bc:	89 c2                	mov    %eax,%edx
801017be:	a1 94 2a 11 80       	mov    0x80112a94,%eax
801017c3:	01 c2                	add    %eax,%edx
801017c5:	8b 45 08             	mov    0x8(%ebp),%eax
801017c8:	8b 00                	mov    (%eax),%eax
801017ca:	89 54 24 04          	mov    %edx,0x4(%esp)
801017ce:	89 04 24             	mov    %eax,(%esp)
801017d1:	e8 df e9 ff ff       	call   801001b5 <bread>
801017d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017dc:	8d 50 5c             	lea    0x5c(%eax),%edx
801017df:	8b 45 08             	mov    0x8(%ebp),%eax
801017e2:	8b 40 04             	mov    0x4(%eax),%eax
801017e5:	83 e0 07             	and    $0x7,%eax
801017e8:	c1 e0 06             	shl    $0x6,%eax
801017eb:	01 d0                	add    %edx,%eax
801017ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801017f0:	8b 45 08             	mov    0x8(%ebp),%eax
801017f3:	0f b7 50 50          	movzwl 0x50(%eax),%edx
801017f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017fa:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101800:	0f b7 50 52          	movzwl 0x52(%eax),%edx
80101804:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101807:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010180b:	8b 45 08             	mov    0x8(%ebp),%eax
8010180e:	0f b7 50 54          	movzwl 0x54(%eax),%edx
80101812:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101815:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101819:	8b 45 08             	mov    0x8(%ebp),%eax
8010181c:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101820:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101823:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101827:	8b 45 08             	mov    0x8(%ebp),%eax
8010182a:	8b 50 58             	mov    0x58(%eax),%edx
8010182d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101830:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101833:	8b 45 08             	mov    0x8(%ebp),%eax
80101836:	8d 50 5c             	lea    0x5c(%eax),%edx
80101839:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010183c:	83 c0 0c             	add    $0xc,%eax
8010183f:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101846:	00 
80101847:	89 54 24 04          	mov    %edx,0x4(%esp)
8010184b:	89 04 24             	mov    %eax,(%esp)
8010184e:	e8 52 41 00 00       	call   801059a5 <memmove>
  log_write(bp);
80101853:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101856:	89 04 24             	mov    %eax,(%esp)
80101859:	e8 4e 21 00 00       	call   801039ac <log_write>
  brelse(bp);
8010185e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101861:	89 04 24             	mov    %eax,(%esp)
80101864:	e8 c3 e9 ff ff       	call   8010022c <brelse>
}
80101869:	c9                   	leave  
8010186a:	c3                   	ret    

8010186b <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010186b:	55                   	push   %ebp
8010186c:	89 e5                	mov    %esp,%ebp
8010186e:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101871:	c7 04 24 a0 2a 11 80 	movl   $0x80112aa0,(%esp)
80101878:	e8 f0 3d 00 00       	call   8010566d <acquire>

  // Is the inode already cached?
  empty = 0;
8010187d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101884:	c7 45 f4 d4 2a 11 80 	movl   $0x80112ad4,-0xc(%ebp)
8010188b:	eb 5c                	jmp    801018e9 <iget+0x7e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010188d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101890:	8b 40 08             	mov    0x8(%eax),%eax
80101893:	85 c0                	test   %eax,%eax
80101895:	7e 35                	jle    801018cc <iget+0x61>
80101897:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010189a:	8b 00                	mov    (%eax),%eax
8010189c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010189f:	75 2b                	jne    801018cc <iget+0x61>
801018a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a4:	8b 40 04             	mov    0x4(%eax),%eax
801018a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
801018aa:	75 20                	jne    801018cc <iget+0x61>
      ip->ref++;
801018ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018af:	8b 40 08             	mov    0x8(%eax),%eax
801018b2:	8d 50 01             	lea    0x1(%eax),%edx
801018b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b8:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801018bb:	c7 04 24 a0 2a 11 80 	movl   $0x80112aa0,(%esp)
801018c2:	e8 0d 3e 00 00       	call   801056d4 <release>
      return ip;
801018c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ca:	eb 72                	jmp    8010193e <iget+0xd3>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801018cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018d0:	75 10                	jne    801018e2 <iget+0x77>
801018d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018d5:	8b 40 08             	mov    0x8(%eax),%eax
801018d8:	85 c0                	test   %eax,%eax
801018da:	75 06                	jne    801018e2 <iget+0x77>
      empty = ip;
801018dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018df:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018e2:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
801018e9:	81 7d f4 f4 46 11 80 	cmpl   $0x801146f4,-0xc(%ebp)
801018f0:	72 9b                	jb     8010188d <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801018f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018f6:	75 0c                	jne    80101904 <iget+0x99>
    panic("iget: no inodes");
801018f8:	c7 04 24 49 90 10 80 	movl   $0x80109049,(%esp)
801018ff:	e8 5e ec ff ff       	call   80100562 <panic>

  ip = empty;
80101904:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101907:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
8010190a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190d:	8b 55 08             	mov    0x8(%ebp),%edx
80101910:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101915:	8b 55 0c             	mov    0xc(%ebp),%edx
80101918:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
8010191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101925:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101928:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
8010192f:	c7 04 24 a0 2a 11 80 	movl   $0x80112aa0,(%esp)
80101936:	e8 99 3d 00 00       	call   801056d4 <release>

  return ip;
8010193b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010193e:	c9                   	leave  
8010193f:	c3                   	ret    

80101940 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101946:	c7 04 24 a0 2a 11 80 	movl   $0x80112aa0,(%esp)
8010194d:	e8 1b 3d 00 00       	call   8010566d <acquire>
  ip->ref++;
80101952:	8b 45 08             	mov    0x8(%ebp),%eax
80101955:	8b 40 08             	mov    0x8(%eax),%eax
80101958:	8d 50 01             	lea    0x1(%eax),%edx
8010195b:	8b 45 08             	mov    0x8(%ebp),%eax
8010195e:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101961:	c7 04 24 a0 2a 11 80 	movl   $0x80112aa0,(%esp)
80101968:	e8 67 3d 00 00       	call   801056d4 <release>
  return ip;
8010196d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101970:	c9                   	leave  
80101971:	c3                   	ret    

80101972 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101972:	55                   	push   %ebp
80101973:	89 e5                	mov    %esp,%ebp
80101975:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101978:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010197c:	74 0a                	je     80101988 <ilock+0x16>
8010197e:	8b 45 08             	mov    0x8(%ebp),%eax
80101981:	8b 40 08             	mov    0x8(%eax),%eax
80101984:	85 c0                	test   %eax,%eax
80101986:	7f 0c                	jg     80101994 <ilock+0x22>
    panic("ilock");
80101988:	c7 04 24 59 90 10 80 	movl   $0x80109059,(%esp)
8010198f:	e8 ce eb ff ff       	call   80100562 <panic>

  acquiresleep(&ip->lock);
80101994:	8b 45 08             	mov    0x8(%ebp),%eax
80101997:	83 c0 0c             	add    $0xc,%eax
8010199a:	89 04 24             	mov    %eax,(%esp)
8010199d:	e8 a7 3b 00 00       	call   80105549 <acquiresleep>

  if(!(ip->flags & I_VALID)){
801019a2:	8b 45 08             	mov    0x8(%ebp),%eax
801019a5:	8b 40 4c             	mov    0x4c(%eax),%eax
801019a8:	83 e0 02             	and    $0x2,%eax
801019ab:	85 c0                	test   %eax,%eax
801019ad:	0f 85 d4 00 00 00    	jne    80101a87 <ilock+0x115>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019b3:	8b 45 08             	mov    0x8(%ebp),%eax
801019b6:	8b 40 04             	mov    0x4(%eax),%eax
801019b9:	c1 e8 03             	shr    $0x3,%eax
801019bc:	89 c2                	mov    %eax,%edx
801019be:	a1 94 2a 11 80       	mov    0x80112a94,%eax
801019c3:	01 c2                	add    %eax,%edx
801019c5:	8b 45 08             	mov    0x8(%ebp),%eax
801019c8:	8b 00                	mov    (%eax),%eax
801019ca:	89 54 24 04          	mov    %edx,0x4(%esp)
801019ce:	89 04 24             	mov    %eax,(%esp)
801019d1:	e8 df e7 ff ff       	call   801001b5 <bread>
801019d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019dc:	8d 50 5c             	lea    0x5c(%eax),%edx
801019df:	8b 45 08             	mov    0x8(%ebp),%eax
801019e2:	8b 40 04             	mov    0x4(%eax),%eax
801019e5:	83 e0 07             	and    $0x7,%eax
801019e8:	c1 e0 06             	shl    $0x6,%eax
801019eb:	01 d0                	add    %edx,%eax
801019ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801019f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019f3:	0f b7 10             	movzwl (%eax),%edx
801019f6:	8b 45 08             	mov    0x8(%ebp),%eax
801019f9:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
801019fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a00:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a04:	8b 45 08             	mov    0x8(%ebp),%eax
80101a07:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a0e:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a12:	8b 45 08             	mov    0x8(%ebp),%eax
80101a15:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a1c:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a20:	8b 45 08             	mov    0x8(%ebp),%eax
80101a23:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a2a:	8b 50 08             	mov    0x8(%eax),%edx
80101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a30:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a36:	8d 50 0c             	lea    0xc(%eax),%edx
80101a39:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3c:	83 c0 5c             	add    $0x5c,%eax
80101a3f:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101a46:	00 
80101a47:	89 54 24 04          	mov    %edx,0x4(%esp)
80101a4b:	89 04 24             	mov    %eax,(%esp)
80101a4e:	e8 52 3f 00 00       	call   801059a5 <memmove>
    brelse(bp);
80101a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a56:	89 04 24             	mov    %eax,(%esp)
80101a59:	e8 ce e7 ff ff       	call   8010022c <brelse>
    ip->flags |= I_VALID;
80101a5e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a61:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a64:	83 c8 02             	or     $0x2,%eax
80101a67:	89 c2                	mov    %eax,%edx
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	89 50 4c             	mov    %edx,0x4c(%eax)
    if(ip->type == 0)
80101a6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a72:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101a76:	66 85 c0             	test   %ax,%ax
80101a79:	75 0c                	jne    80101a87 <ilock+0x115>
      panic("ilock: no type");
80101a7b:	c7 04 24 5f 90 10 80 	movl   $0x8010905f,(%esp)
80101a82:	e8 db ea ff ff       	call   80100562 <panic>
  }
}
80101a87:	c9                   	leave  
80101a88:	c3                   	ret    

80101a89 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a89:	55                   	push   %ebp
80101a8a:	89 e5                	mov    %esp,%ebp
80101a8c:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a93:	74 1c                	je     80101ab1 <iunlock+0x28>
80101a95:	8b 45 08             	mov    0x8(%ebp),%eax
80101a98:	83 c0 0c             	add    $0xc,%eax
80101a9b:	89 04 24             	mov    %eax,(%esp)
80101a9e:	e8 44 3b 00 00       	call   801055e7 <holdingsleep>
80101aa3:	85 c0                	test   %eax,%eax
80101aa5:	74 0a                	je     80101ab1 <iunlock+0x28>
80101aa7:	8b 45 08             	mov    0x8(%ebp),%eax
80101aaa:	8b 40 08             	mov    0x8(%eax),%eax
80101aad:	85 c0                	test   %eax,%eax
80101aaf:	7f 0c                	jg     80101abd <iunlock+0x34>
    panic("iunlock");
80101ab1:	c7 04 24 6e 90 10 80 	movl   $0x8010906e,(%esp)
80101ab8:	e8 a5 ea ff ff       	call   80100562 <panic>

  releasesleep(&ip->lock);
80101abd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac0:	83 c0 0c             	add    $0xc,%eax
80101ac3:	89 04 24             	mov    %eax,(%esp)
80101ac6:	e8 da 3a 00 00       	call   801055a5 <releasesleep>
}
80101acb:	c9                   	leave  
80101acc:	c3                   	ret    

80101acd <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101acd:	55                   	push   %ebp
80101ace:	89 e5                	mov    %esp,%ebp
80101ad0:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101ad3:	c7 04 24 a0 2a 11 80 	movl   $0x80112aa0,(%esp)
80101ada:	e8 8e 3b 00 00       	call   8010566d <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101adf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae2:	8b 40 08             	mov    0x8(%eax),%eax
80101ae5:	83 f8 01             	cmp    $0x1,%eax
80101ae8:	75 5a                	jne    80101b44 <iput+0x77>
80101aea:	8b 45 08             	mov    0x8(%ebp),%eax
80101aed:	8b 40 4c             	mov    0x4c(%eax),%eax
80101af0:	83 e0 02             	and    $0x2,%eax
80101af3:	85 c0                	test   %eax,%eax
80101af5:	74 4d                	je     80101b44 <iput+0x77>
80101af7:	8b 45 08             	mov    0x8(%ebp),%eax
80101afa:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101afe:	66 85 c0             	test   %ax,%ax
80101b01:	75 41                	jne    80101b44 <iput+0x77>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
80101b03:	c7 04 24 a0 2a 11 80 	movl   $0x80112aa0,(%esp)
80101b0a:	e8 c5 3b 00 00       	call   801056d4 <release>
    itrunc(ip);
80101b0f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b12:	89 04 24             	mov    %eax,(%esp)
80101b15:	e8 b5 02 00 00       	call   80101dcf <itrunc>
    ip->type = 0;
80101b1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1d:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
    iupdate(ip);
80101b23:	8b 45 08             	mov    0x8(%ebp),%eax
80101b26:	89 04 24             	mov    %eax,(%esp)
80101b29:	e8 7f fc ff ff       	call   801017ad <iupdate>
    acquire(&icache.lock);
80101b2e:	c7 04 24 a0 2a 11 80 	movl   $0x80112aa0,(%esp)
80101b35:	e8 33 3b 00 00       	call   8010566d <acquire>
    ip->flags = 0;
80101b3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3d:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }
  ip->ref--;
80101b44:	8b 45 08             	mov    0x8(%ebp),%eax
80101b47:	8b 40 08             	mov    0x8(%eax),%eax
80101b4a:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b50:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b53:	c7 04 24 a0 2a 11 80 	movl   $0x80112aa0,(%esp)
80101b5a:	e8 75 3b 00 00       	call   801056d4 <release>
}
80101b5f:	c9                   	leave  
80101b60:	c3                   	ret    

80101b61 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b61:	55                   	push   %ebp
80101b62:	89 e5                	mov    %esp,%ebp
80101b64:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b67:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6a:	89 04 24             	mov    %eax,(%esp)
80101b6d:	e8 17 ff ff ff       	call   80101a89 <iunlock>
  iput(ip);
80101b72:	8b 45 08             	mov    0x8(%ebp),%eax
80101b75:	89 04 24             	mov    %eax,(%esp)
80101b78:	e8 50 ff ff ff       	call   80101acd <iput>
}
80101b7d:	c9                   	leave  
80101b7e:	c3                   	ret    

80101b7f <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b7f:	55                   	push   %ebp
80101b80:	89 e5                	mov    %esp,%ebp
80101b82:	53                   	push   %ebx
80101b83:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b86:	83 7d 0c 0a          	cmpl   $0xa,0xc(%ebp)
80101b8a:	77 3e                	ja     80101bca <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b92:	83 c2 14             	add    $0x14,%edx
80101b95:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b99:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ba0:	75 20                	jne    80101bc2 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101ba2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba5:	8b 00                	mov    (%eax),%eax
80101ba7:	89 04 24             	mov    %eax,(%esp)
80101baa:	e8 4d f8 ff ff       	call   801013fc <balloc>
80101baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bb2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bb8:	8d 4a 14             	lea    0x14(%edx),%ecx
80101bbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bbe:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bc5:	e9 ff 01 00 00       	jmp    80101dc9 <bmap+0x24a>
  }
  bn -= NDIRECT;
80101bca:	83 6d 0c 0b          	subl   $0xb,0xc(%ebp)

  if(bn < NINDIRECT){
80101bce:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101bd2:	0f 87 ab 00 00 00    	ja     80101c83 <bmap+0x104>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101bd8:	8b 45 08             	mov    0x8(%ebp),%eax
80101bdb:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80101be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101be4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101be8:	75 1c                	jne    80101c06 <bmap+0x87>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101bea:	8b 45 08             	mov    0x8(%ebp),%eax
80101bed:	8b 00                	mov    (%eax),%eax
80101bef:	89 04 24             	mov    %eax,(%esp)
80101bf2:	e8 05 f8 ff ff       	call   801013fc <balloc>
80101bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bfa:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c00:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
    bp = bread(ip->dev, addr);
80101c06:	8b 45 08             	mov    0x8(%ebp),%eax
80101c09:	8b 00                	mov    (%eax),%eax
80101c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c0e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c12:	89 04 24             	mov    %eax,(%esp)
80101c15:	e8 9b e5 ff ff       	call   801001b5 <bread>
80101c1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c20:	83 c0 5c             	add    $0x5c,%eax
80101c23:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c26:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c30:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c33:	01 d0                	add    %edx,%eax
80101c35:	8b 00                	mov    (%eax),%eax
80101c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c3e:	75 30                	jne    80101c70 <bmap+0xf1>
      a[bn] = addr = balloc(ip->dev);
80101c40:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c4d:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c50:	8b 45 08             	mov    0x8(%ebp),%eax
80101c53:	8b 00                	mov    (%eax),%eax
80101c55:	89 04 24             	mov    %eax,(%esp)
80101c58:	e8 9f f7 ff ff       	call   801013fc <balloc>
80101c5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c63:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c68:	89 04 24             	mov    %eax,(%esp)
80101c6b:	e8 3c 1d 00 00       	call   801039ac <log_write>
    }
    brelse(bp);
80101c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c73:	89 04 24             	mov    %eax,(%esp)
80101c76:	e8 b1 e5 ff ff       	call   8010022c <brelse>
    return addr;
80101c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c7e:	e9 46 01 00 00       	jmp    80101dc9 <bmap+0x24a>
  }

  bn -= NINDIRECT;
80101c83:	83 45 0c 80          	addl   $0xffffff80,0xc(%ebp)
  if(bn < NINDIRECT*NINDIRECT){
80101c87:	81 7d 0c ff 3f 00 00 	cmpl   $0x3fff,0xc(%ebp)
80101c8e:	0f 87 29 01 00 00    	ja     80101dbd <bmap+0x23e>
      if((addr = ip->addrs[NDIRECT+1]) == 0)// Load double indirect block
80101c94:	8b 45 08             	mov    0x8(%ebp),%eax
80101c97:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101c9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ca0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ca4:	75 1c                	jne    80101cc2 <bmap+0x143>
          ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
80101ca6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca9:	8b 00                	mov    (%eax),%eax
80101cab:	89 04 24             	mov    %eax,(%esp)
80101cae:	e8 49 f7 ff ff       	call   801013fc <balloc>
80101cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cbc:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
      bp = bread(ip->dev, addr);
80101cc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc5:	8b 00                	mov    (%eax),%eax
80101cc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cca:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cce:	89 04 24             	mov    %eax,(%esp)
80101cd1:	e8 df e4 ff ff       	call   801001b5 <bread>
80101cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
      a = (uint*)bp->data;
80101cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cdc:	83 c0 5c             	add    $0x5c,%eax
80101cdf:	89 45 ec             	mov    %eax,-0x14(%ebp)

      if((addr = a[bn/(NINDIRECT)]) == 0){
80101ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ce5:	c1 e8 07             	shr    $0x7,%eax
80101ce8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cf2:	01 d0                	add    %edx,%eax
80101cf4:	8b 00                	mov    (%eax),%eax
80101cf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cfd:	75 33                	jne    80101d32 <bmap+0x1b3>
          a[bn/(NINDIRECT)] = addr = balloc(ip->dev);
80101cff:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d02:	c1 e8 07             	shr    $0x7,%eax
80101d05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d0f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101d12:	8b 45 08             	mov    0x8(%ebp),%eax
80101d15:	8b 00                	mov    (%eax),%eax
80101d17:	89 04 24             	mov    %eax,(%esp)
80101d1a:	e8 dd f6 ff ff       	call   801013fc <balloc>
80101d1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d25:	89 03                	mov    %eax,(%ebx)
          log_write(bp);
80101d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d2a:	89 04 24             	mov    %eax,(%esp)
80101d2d:	e8 7a 1c 00 00       	call   801039ac <log_write>
      }
      brelse(bp);
80101d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d35:	89 04 24             	mov    %eax,(%esp)
80101d38:	e8 ef e4 ff ff       	call   8010022c <brelse>

      bp = bread(ip->dev,addr);
80101d3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d40:	8b 00                	mov    (%eax),%eax
80101d42:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d45:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d49:	89 04 24             	mov    %eax,(%esp)
80101d4c:	e8 64 e4 ff ff       	call   801001b5 <bread>
80101d51:	89 45 f0             	mov    %eax,-0x10(%ebp)
      a = (uint*)bp->data;
80101d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d57:	83 c0 5c             	add    $0x5c,%eax
80101d5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if((addr = a[bn%(NINDIRECT)]) == 0){
80101d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d60:	83 e0 7f             	and    $0x7f,%eax
80101d63:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d6d:	01 d0                	add    %edx,%eax
80101d6f:	8b 00                	mov    (%eax),%eax
80101d71:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d78:	75 33                	jne    80101dad <bmap+0x22e>
          a[bn%(NINDIRECT)] = addr = balloc(ip->dev);
80101d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d7d:	83 e0 7f             	and    $0x7f,%eax
80101d80:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d8a:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101d8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d90:	8b 00                	mov    (%eax),%eax
80101d92:	89 04 24             	mov    %eax,(%esp)
80101d95:	e8 62 f6 ff ff       	call   801013fc <balloc>
80101d9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101da0:	89 03                	mov    %eax,(%ebx)
          log_write(bp);
80101da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101da5:	89 04 24             	mov    %eax,(%esp)
80101da8:	e8 ff 1b 00 00       	call   801039ac <log_write>
      }
      brelse(bp);
80101dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101db0:	89 04 24             	mov    %eax,(%esp)
80101db3:	e8 74 e4 ff ff       	call   8010022c <brelse>
      return addr;
80101db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101dbb:	eb 0c                	jmp    80101dc9 <bmap+0x24a>
  }

  panic("bmap: out of range");
80101dbd:	c7 04 24 76 90 10 80 	movl   $0x80109076,(%esp)
80101dc4:	e8 99 e7 ff ff       	call   80100562 <panic>
}
80101dc9:	83 c4 24             	add    $0x24,%esp
80101dcc:	5b                   	pop    %ebx
80101dcd:	5d                   	pop    %ebp
80101dce:	c3                   	ret    

80101dcf <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101dcf:	55                   	push   %ebp
80101dd0:	89 e5                	mov    %esp,%ebp
80101dd2:	83 ec 38             	sub    $0x38,%esp
  struct buf *bp;
  struct buf *bq;
  uint *a;
  uint *b;

  for(i = 0; i < NDIRECT; i++){
80101dd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ddc:	eb 44                	jmp    80101e22 <itrunc+0x53>
    if(ip->addrs[i]){
80101dde:	8b 45 08             	mov    0x8(%ebp),%eax
80101de1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101de4:	83 c2 14             	add    $0x14,%edx
80101de7:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101deb:	85 c0                	test   %eax,%eax
80101ded:	74 2f                	je     80101e1e <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101def:	8b 45 08             	mov    0x8(%ebp),%eax
80101df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101df5:	83 c2 14             	add    $0x14,%edx
80101df8:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101dfc:	8b 45 08             	mov    0x8(%ebp),%eax
80101dff:	8b 00                	mov    (%eax),%eax
80101e01:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e05:	89 04 24             	mov    %eax,(%esp)
80101e08:	e8 2d f7 ff ff       	call   8010153a <bfree>
      ip->addrs[i] = 0;
80101e0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e10:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e13:	83 c2 14             	add    $0x14,%edx
80101e16:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101e1d:	00 
  struct buf *bp;
  struct buf *bq;
  uint *a;
  uint *b;

  for(i = 0; i < NDIRECT; i++){
80101e1e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101e22:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
80101e26:	7e b6                	jle    80101dde <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
80101e28:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2b:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80101e31:	85 c0                	test   %eax,%eax
80101e33:	0f 84 a4 00 00 00    	je     80101edd <itrunc+0x10e>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e39:	8b 45 08             	mov    0x8(%ebp),%eax
80101e3c:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80101e42:	8b 45 08             	mov    0x8(%ebp),%eax
80101e45:	8b 00                	mov    (%eax),%eax
80101e47:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e4b:	89 04 24             	mov    %eax,(%esp)
80101e4e:	e8 62 e3 ff ff       	call   801001b5 <bread>
80101e53:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e56:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e59:	83 c0 5c             	add    $0x5c,%eax
80101e5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e5f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e66:	eb 3b                	jmp    80101ea3 <itrunc+0xd4>
      if(a[j])
80101e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e72:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e75:	01 d0                	add    %edx,%eax
80101e77:	8b 00                	mov    (%eax),%eax
80101e79:	85 c0                	test   %eax,%eax
80101e7b:	74 22                	je     80101e9f <itrunc+0xd0>
        bfree(ip->dev, a[j]);
80101e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e80:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e87:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e8a:	01 d0                	add    %edx,%eax
80101e8c:	8b 10                	mov    (%eax),%edx
80101e8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e91:	8b 00                	mov    (%eax),%eax
80101e93:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e97:	89 04 24             	mov    %eax,(%esp)
80101e9a:	e8 9b f6 ff ff       	call   8010153a <bfree>
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101e9f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ea6:	83 f8 7f             	cmp    $0x7f,%eax
80101ea9:	76 bd                	jbe    80101e68 <itrunc+0x99>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eae:	89 04 24             	mov    %eax,(%esp)
80101eb1:	e8 76 e3 ff ff       	call   8010022c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101eb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb9:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80101ebf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec2:	8b 00                	mov    (%eax),%eax
80101ec4:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ec8:	89 04 24             	mov    %eax,(%esp)
80101ecb:	e8 6a f6 ff ff       	call   8010153a <bfree>
    ip->addrs[NDIRECT] = 0;
80101ed0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed3:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80101eda:	00 00 00 
  }

  if(ip->addrs[NDIRECT+1]){
80101edd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ee6:	85 c0                	test   %eax,%eax
80101ee8:	0f 84 1a 01 00 00    	je     80102008 <itrunc+0x239>
    bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
80101eee:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef1:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101ef7:	8b 45 08             	mov    0x8(%ebp),%eax
80101efa:	8b 00                	mov    (%eax),%eax
80101efc:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f00:	89 04 24             	mov    %eax,(%esp)
80101f03:	e8 ad e2 ff ff       	call   801001b5 <bread>
80101f08:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101f0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f0e:	83 c0 5c             	add    $0x5c,%eax
80101f11:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101f14:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101f1b:	e9 c4 00 00 00       	jmp    80101fe4 <itrunc+0x215>
        if(a[j]){
80101f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101f2d:	01 d0                	add    %edx,%eax
80101f2f:	8b 00                	mov    (%eax),%eax
80101f31:	85 c0                	test   %eax,%eax
80101f33:	0f 84 a7 00 00 00    	je     80101fe0 <itrunc+0x211>
            bq = bread(ip->dev, a[j]);
80101f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f43:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101f46:	01 d0                	add    %edx,%eax
80101f48:	8b 10                	mov    (%eax),%edx
80101f4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4d:	8b 00                	mov    (%eax),%eax
80101f4f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f53:	89 04 24             	mov    %eax,(%esp)
80101f56:	e8 5a e2 ff ff       	call   801001b5 <bread>
80101f5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            b = (uint*)bq->data;
80101f5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f61:	83 c0 5c             	add    $0x5c,%eax
80101f64:	89 45 e0             	mov    %eax,-0x20(%ebp)
            for(i = 0; i < NINDIRECT; i++){
80101f67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f6e:	eb 3b                	jmp    80101fab <itrunc+0x1dc>
                if(b[i])
80101f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f73:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f7d:	01 d0                	add    %edx,%eax
80101f7f:	8b 00                	mov    (%eax),%eax
80101f81:	85 c0                	test   %eax,%eax
80101f83:	74 22                	je     80101fa7 <itrunc+0x1d8>
                    bfree(ip->dev, b[i]);
80101f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f88:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f92:	01 d0                	add    %edx,%eax
80101f94:	8b 10                	mov    (%eax),%edx
80101f96:	8b 45 08             	mov    0x8(%ebp),%eax
80101f99:	8b 00                	mov    (%eax),%eax
80101f9b:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f9f:	89 04 24             	mov    %eax,(%esp)
80101fa2:	e8 93 f5 ff ff       	call   8010153a <bfree>
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
        if(a[j]){
            bq = bread(ip->dev, a[j]);
            b = (uint*)bq->data;
            for(i = 0; i < NINDIRECT; i++){
80101fa7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fae:	83 f8 7f             	cmp    $0x7f,%eax
80101fb1:	76 bd                	jbe    80101f70 <itrunc+0x1a1>
                if(b[i])
                    bfree(ip->dev, b[i]);
            }
            brelse(bq);
80101fb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101fb6:	89 04 24             	mov    %eax,(%esp)
80101fb9:	e8 6e e2 ff ff       	call   8010022c <brelse>
            bfree(ip->dev, a[j]);
80101fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fc1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101fc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101fcb:	01 d0                	add    %edx,%eax
80101fcd:	8b 10                	mov    (%eax),%edx
80101fcf:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd2:	8b 00                	mov    (%eax),%eax
80101fd4:	89 54 24 04          	mov    %edx,0x4(%esp)
80101fd8:	89 04 24             	mov    %eax,(%esp)
80101fdb:	e8 5a f5 ff ff       	call   8010153a <bfree>
  }

  if(ip->addrs[NDIRECT+1]){
    bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101fe0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fe7:	83 f8 7f             	cmp    $0x7f,%eax
80101fea:	0f 86 30 ff ff ff    	jbe    80101f20 <itrunc+0x151>
            }
            brelse(bq);
            bfree(ip->dev, a[j]);
        }
    }
    brelse(bp);
80101ff0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ff3:	89 04 24             	mov    %eax,(%esp)
80101ff6:	e8 31 e2 ff ff       	call   8010022c <brelse>
    ip->addrs[NDIRECT+1] = 0;
80101ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffe:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80102005:	00 00 00 
  }

  ip->size = 0;
80102008:	8b 45 08             	mov    0x8(%ebp),%eax
8010200b:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80102012:	8b 45 08             	mov    0x8(%ebp),%eax
80102015:	89 04 24             	mov    %eax,(%esp)
80102018:	e8 90 f7 ff ff       	call   801017ad <iupdate>
}
8010201d:	c9                   	leave  
8010201e:	c3                   	ret    

8010201f <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
8010201f:	55                   	push   %ebp
80102020:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80102022:	8b 45 08             	mov    0x8(%ebp),%eax
80102025:	8b 00                	mov    (%eax),%eax
80102027:	89 c2                	mov    %eax,%edx
80102029:	8b 45 0c             	mov    0xc(%ebp),%eax
8010202c:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
8010202f:	8b 45 08             	mov    0x8(%ebp),%eax
80102032:	8b 50 04             	mov    0x4(%eax),%edx
80102035:	8b 45 0c             	mov    0xc(%ebp),%eax
80102038:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
8010203b:	8b 45 08             	mov    0x8(%ebp),%eax
8010203e:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80102042:	8b 45 0c             	mov    0xc(%ebp),%eax
80102045:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80102048:	8b 45 08             	mov    0x8(%ebp),%eax
8010204b:	0f b7 50 56          	movzwl 0x56(%eax),%edx
8010204f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102052:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80102056:	8b 45 08             	mov    0x8(%ebp),%eax
80102059:	8b 50 58             	mov    0x58(%eax),%edx
8010205c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010205f:	89 50 10             	mov    %edx,0x10(%eax)
}
80102062:	5d                   	pop    %ebp
80102063:	c3                   	ret    

80102064 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102064:	55                   	push   %ebp
80102065:	89 e5                	mov    %esp,%ebp
80102067:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010206a:	8b 45 08             	mov    0x8(%ebp),%eax
8010206d:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102071:	66 83 f8 03          	cmp    $0x3,%ax
80102075:	75 60                	jne    801020d7 <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102077:	8b 45 08             	mov    0x8(%ebp),%eax
8010207a:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010207e:	66 85 c0             	test   %ax,%ax
80102081:	78 20                	js     801020a3 <readi+0x3f>
80102083:	8b 45 08             	mov    0x8(%ebp),%eax
80102086:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010208a:	66 83 f8 09          	cmp    $0x9,%ax
8010208e:	7f 13                	jg     801020a3 <readi+0x3f>
80102090:	8b 45 08             	mov    0x8(%ebp),%eax
80102093:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102097:	98                   	cwtl   
80102098:	8b 04 c5 20 2a 11 80 	mov    -0x7feed5e0(,%eax,8),%eax
8010209f:	85 c0                	test   %eax,%eax
801020a1:	75 0a                	jne    801020ad <readi+0x49>
      return -1;
801020a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020a8:	e9 19 01 00 00       	jmp    801021c6 <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
801020ad:	8b 45 08             	mov    0x8(%ebp),%eax
801020b0:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801020b4:	98                   	cwtl   
801020b5:	8b 04 c5 20 2a 11 80 	mov    -0x7feed5e0(,%eax,8),%eax
801020bc:	8b 55 14             	mov    0x14(%ebp),%edx
801020bf:	89 54 24 08          	mov    %edx,0x8(%esp)
801020c3:	8b 55 0c             	mov    0xc(%ebp),%edx
801020c6:	89 54 24 04          	mov    %edx,0x4(%esp)
801020ca:	8b 55 08             	mov    0x8(%ebp),%edx
801020cd:	89 14 24             	mov    %edx,(%esp)
801020d0:	ff d0                	call   *%eax
801020d2:	e9 ef 00 00 00       	jmp    801021c6 <readi+0x162>
  }

  if(off > ip->size || off + n < off)
801020d7:	8b 45 08             	mov    0x8(%ebp),%eax
801020da:	8b 40 58             	mov    0x58(%eax),%eax
801020dd:	3b 45 10             	cmp    0x10(%ebp),%eax
801020e0:	72 0d                	jb     801020ef <readi+0x8b>
801020e2:	8b 45 14             	mov    0x14(%ebp),%eax
801020e5:	8b 55 10             	mov    0x10(%ebp),%edx
801020e8:	01 d0                	add    %edx,%eax
801020ea:	3b 45 10             	cmp    0x10(%ebp),%eax
801020ed:	73 0a                	jae    801020f9 <readi+0x95>
    return -1;
801020ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020f4:	e9 cd 00 00 00       	jmp    801021c6 <readi+0x162>
  if(off + n > ip->size)
801020f9:	8b 45 14             	mov    0x14(%ebp),%eax
801020fc:	8b 55 10             	mov    0x10(%ebp),%edx
801020ff:	01 c2                	add    %eax,%edx
80102101:	8b 45 08             	mov    0x8(%ebp),%eax
80102104:	8b 40 58             	mov    0x58(%eax),%eax
80102107:	39 c2                	cmp    %eax,%edx
80102109:	76 0c                	jbe    80102117 <readi+0xb3>
    n = ip->size - off;
8010210b:	8b 45 08             	mov    0x8(%ebp),%eax
8010210e:	8b 40 58             	mov    0x58(%eax),%eax
80102111:	2b 45 10             	sub    0x10(%ebp),%eax
80102114:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102117:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010211e:	e9 94 00 00 00       	jmp    801021b7 <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102123:	8b 45 10             	mov    0x10(%ebp),%eax
80102126:	c1 e8 09             	shr    $0x9,%eax
80102129:	89 44 24 04          	mov    %eax,0x4(%esp)
8010212d:	8b 45 08             	mov    0x8(%ebp),%eax
80102130:	89 04 24             	mov    %eax,(%esp)
80102133:	e8 47 fa ff ff       	call   80101b7f <bmap>
80102138:	8b 55 08             	mov    0x8(%ebp),%edx
8010213b:	8b 12                	mov    (%edx),%edx
8010213d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102141:	89 14 24             	mov    %edx,(%esp)
80102144:	e8 6c e0 ff ff       	call   801001b5 <bread>
80102149:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010214c:	8b 45 10             	mov    0x10(%ebp),%eax
8010214f:	25 ff 01 00 00       	and    $0x1ff,%eax
80102154:	89 c2                	mov    %eax,%edx
80102156:	b8 00 02 00 00       	mov    $0x200,%eax
8010215b:	29 d0                	sub    %edx,%eax
8010215d:	89 c2                	mov    %eax,%edx
8010215f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102162:	8b 4d 14             	mov    0x14(%ebp),%ecx
80102165:	29 c1                	sub    %eax,%ecx
80102167:	89 c8                	mov    %ecx,%eax
80102169:	39 c2                	cmp    %eax,%edx
8010216b:	0f 46 c2             	cmovbe %edx,%eax
8010216e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80102171:	8b 45 10             	mov    0x10(%ebp),%eax
80102174:	25 ff 01 00 00       	and    $0x1ff,%eax
80102179:	8d 50 50             	lea    0x50(%eax),%edx
8010217c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010217f:	01 d0                	add    %edx,%eax
80102181:	8d 50 0c             	lea    0xc(%eax),%edx
80102184:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102187:	89 44 24 08          	mov    %eax,0x8(%esp)
8010218b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010218f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102192:	89 04 24             	mov    %eax,(%esp)
80102195:	e8 0b 38 00 00       	call   801059a5 <memmove>
    brelse(bp);
8010219a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010219d:	89 04 24             	mov    %eax,(%esp)
801021a0:	e8 87 e0 ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801021a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021a8:	01 45 f4             	add    %eax,-0xc(%ebp)
801021ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021ae:	01 45 10             	add    %eax,0x10(%ebp)
801021b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021b4:	01 45 0c             	add    %eax,0xc(%ebp)
801021b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021ba:	3b 45 14             	cmp    0x14(%ebp),%eax
801021bd:	0f 82 60 ff ff ff    	jb     80102123 <readi+0xbf>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801021c3:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021c6:	c9                   	leave  
801021c7:	c3                   	ret    

801021c8 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801021c8:	55                   	push   %ebp
801021c9:	89 e5                	mov    %esp,%ebp
801021cb:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801021ce:	8b 45 08             	mov    0x8(%ebp),%eax
801021d1:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801021d5:	66 83 f8 03          	cmp    $0x3,%ax
801021d9:	75 60                	jne    8010223b <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801021db:	8b 45 08             	mov    0x8(%ebp),%eax
801021de:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801021e2:	66 85 c0             	test   %ax,%ax
801021e5:	78 20                	js     80102207 <writei+0x3f>
801021e7:	8b 45 08             	mov    0x8(%ebp),%eax
801021ea:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801021ee:	66 83 f8 09          	cmp    $0x9,%ax
801021f2:	7f 13                	jg     80102207 <writei+0x3f>
801021f4:	8b 45 08             	mov    0x8(%ebp),%eax
801021f7:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801021fb:	98                   	cwtl   
801021fc:	8b 04 c5 24 2a 11 80 	mov    -0x7feed5dc(,%eax,8),%eax
80102203:	85 c0                	test   %eax,%eax
80102205:	75 0a                	jne    80102211 <writei+0x49>
      return -1;
80102207:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010220c:	e9 44 01 00 00       	jmp    80102355 <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80102211:	8b 45 08             	mov    0x8(%ebp),%eax
80102214:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102218:	98                   	cwtl   
80102219:	8b 04 c5 24 2a 11 80 	mov    -0x7feed5dc(,%eax,8),%eax
80102220:	8b 55 14             	mov    0x14(%ebp),%edx
80102223:	89 54 24 08          	mov    %edx,0x8(%esp)
80102227:	8b 55 0c             	mov    0xc(%ebp),%edx
8010222a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010222e:	8b 55 08             	mov    0x8(%ebp),%edx
80102231:	89 14 24             	mov    %edx,(%esp)
80102234:	ff d0                	call   *%eax
80102236:	e9 1a 01 00 00       	jmp    80102355 <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
8010223b:	8b 45 08             	mov    0x8(%ebp),%eax
8010223e:	8b 40 58             	mov    0x58(%eax),%eax
80102241:	3b 45 10             	cmp    0x10(%ebp),%eax
80102244:	72 0d                	jb     80102253 <writei+0x8b>
80102246:	8b 45 14             	mov    0x14(%ebp),%eax
80102249:	8b 55 10             	mov    0x10(%ebp),%edx
8010224c:	01 d0                	add    %edx,%eax
8010224e:	3b 45 10             	cmp    0x10(%ebp),%eax
80102251:	73 0a                	jae    8010225d <writei+0x95>
    return -1;
80102253:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102258:	e9 f8 00 00 00       	jmp    80102355 <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
8010225d:	8b 45 14             	mov    0x14(%ebp),%eax
80102260:	8b 55 10             	mov    0x10(%ebp),%edx
80102263:	01 d0                	add    %edx,%eax
80102265:	3d 00 16 81 00       	cmp    $0x811600,%eax
8010226a:	76 0a                	jbe    80102276 <writei+0xae>
    return -1;
8010226c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102271:	e9 df 00 00 00       	jmp    80102355 <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102276:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010227d:	e9 9f 00 00 00       	jmp    80102321 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102282:	8b 45 10             	mov    0x10(%ebp),%eax
80102285:	c1 e8 09             	shr    $0x9,%eax
80102288:	89 44 24 04          	mov    %eax,0x4(%esp)
8010228c:	8b 45 08             	mov    0x8(%ebp),%eax
8010228f:	89 04 24             	mov    %eax,(%esp)
80102292:	e8 e8 f8 ff ff       	call   80101b7f <bmap>
80102297:	8b 55 08             	mov    0x8(%ebp),%edx
8010229a:	8b 12                	mov    (%edx),%edx
8010229c:	89 44 24 04          	mov    %eax,0x4(%esp)
801022a0:	89 14 24             	mov    %edx,(%esp)
801022a3:	e8 0d df ff ff       	call   801001b5 <bread>
801022a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801022ab:	8b 45 10             	mov    0x10(%ebp),%eax
801022ae:	25 ff 01 00 00       	and    $0x1ff,%eax
801022b3:	89 c2                	mov    %eax,%edx
801022b5:	b8 00 02 00 00       	mov    $0x200,%eax
801022ba:	29 d0                	sub    %edx,%eax
801022bc:	89 c2                	mov    %eax,%edx
801022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022c1:	8b 4d 14             	mov    0x14(%ebp),%ecx
801022c4:	29 c1                	sub    %eax,%ecx
801022c6:	89 c8                	mov    %ecx,%eax
801022c8:	39 c2                	cmp    %eax,%edx
801022ca:	0f 46 c2             	cmovbe %edx,%eax
801022cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801022d0:	8b 45 10             	mov    0x10(%ebp),%eax
801022d3:	25 ff 01 00 00       	and    $0x1ff,%eax
801022d8:	8d 50 50             	lea    0x50(%eax),%edx
801022db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022de:	01 d0                	add    %edx,%eax
801022e0:	8d 50 0c             	lea    0xc(%eax),%edx
801022e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022e6:	89 44 24 08          	mov    %eax,0x8(%esp)
801022ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801022ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801022f1:	89 14 24             	mov    %edx,(%esp)
801022f4:	e8 ac 36 00 00       	call   801059a5 <memmove>
    log_write(bp);
801022f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022fc:	89 04 24             	mov    %eax,(%esp)
801022ff:	e8 a8 16 00 00       	call   801039ac <log_write>
    brelse(bp);
80102304:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102307:	89 04 24             	mov    %eax,(%esp)
8010230a:	e8 1d df ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010230f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102312:	01 45 f4             	add    %eax,-0xc(%ebp)
80102315:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102318:	01 45 10             	add    %eax,0x10(%ebp)
8010231b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010231e:	01 45 0c             	add    %eax,0xc(%ebp)
80102321:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102324:	3b 45 14             	cmp    0x14(%ebp),%eax
80102327:	0f 82 55 ff ff ff    	jb     80102282 <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010232d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102331:	74 1f                	je     80102352 <writei+0x18a>
80102333:	8b 45 08             	mov    0x8(%ebp),%eax
80102336:	8b 40 58             	mov    0x58(%eax),%eax
80102339:	3b 45 10             	cmp    0x10(%ebp),%eax
8010233c:	73 14                	jae    80102352 <writei+0x18a>
    ip->size = off;
8010233e:	8b 45 08             	mov    0x8(%ebp),%eax
80102341:	8b 55 10             	mov    0x10(%ebp),%edx
80102344:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
80102347:	8b 45 08             	mov    0x8(%ebp),%eax
8010234a:	89 04 24             	mov    %eax,(%esp)
8010234d:	e8 5b f4 ff ff       	call   801017ad <iupdate>
  }
  return n;
80102352:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102355:	c9                   	leave  
80102356:	c3                   	ret    

80102357 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102357:	55                   	push   %ebp
80102358:	89 e5                	mov    %esp,%ebp
8010235a:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
8010235d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102364:	00 
80102365:	8b 45 0c             	mov    0xc(%ebp),%eax
80102368:	89 44 24 04          	mov    %eax,0x4(%esp)
8010236c:	8b 45 08             	mov    0x8(%ebp),%eax
8010236f:	89 04 24             	mov    %eax,(%esp)
80102372:	e8 d1 36 00 00       	call   80105a48 <strncmp>
}
80102377:	c9                   	leave  
80102378:	c3                   	ret    

80102379 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102379:	55                   	push   %ebp
8010237a:	89 e5                	mov    %esp,%ebp
8010237c:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010237f:	8b 45 08             	mov    0x8(%ebp),%eax
80102382:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102386:	66 83 f8 01          	cmp    $0x1,%ax
8010238a:	74 0c                	je     80102398 <dirlookup+0x1f>
    panic("dirlookup not DIR");
8010238c:	c7 04 24 89 90 10 80 	movl   $0x80109089,(%esp)
80102393:	e8 ca e1 ff ff       	call   80100562 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102398:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010239f:	e9 88 00 00 00       	jmp    8010242c <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023a4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801023ab:	00 
801023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023af:	89 44 24 08          	mov    %eax,0x8(%esp)
801023b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023b6:	89 44 24 04          	mov    %eax,0x4(%esp)
801023ba:	8b 45 08             	mov    0x8(%ebp),%eax
801023bd:	89 04 24             	mov    %eax,(%esp)
801023c0:	e8 9f fc ff ff       	call   80102064 <readi>
801023c5:	83 f8 10             	cmp    $0x10,%eax
801023c8:	74 0c                	je     801023d6 <dirlookup+0x5d>
      panic("dirlink read");
801023ca:	c7 04 24 9b 90 10 80 	movl   $0x8010909b,(%esp)
801023d1:	e8 8c e1 ff ff       	call   80100562 <panic>
    if(de.inum == 0)
801023d6:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801023da:	66 85 c0             	test   %ax,%ax
801023dd:	75 02                	jne    801023e1 <dirlookup+0x68>
      continue;
801023df:	eb 47                	jmp    80102428 <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
801023e1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023e4:	83 c0 02             	add    $0x2,%eax
801023e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801023eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801023ee:	89 04 24             	mov    %eax,(%esp)
801023f1:	e8 61 ff ff ff       	call   80102357 <namecmp>
801023f6:	85 c0                	test   %eax,%eax
801023f8:	75 2e                	jne    80102428 <dirlookup+0xaf>
      // entry matches path element
      if(poff)
801023fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801023fe:	74 08                	je     80102408 <dirlookup+0x8f>
        *poff = off;
80102400:	8b 45 10             	mov    0x10(%ebp),%eax
80102403:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102406:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102408:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010240c:	0f b7 c0             	movzwl %ax,%eax
8010240f:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102412:	8b 45 08             	mov    0x8(%ebp),%eax
80102415:	8b 00                	mov    (%eax),%eax
80102417:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010241a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010241e:	89 04 24             	mov    %eax,(%esp)
80102421:	e8 45 f4 ff ff       	call   8010186b <iget>
80102426:	eb 18                	jmp    80102440 <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102428:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010242c:	8b 45 08             	mov    0x8(%ebp),%eax
8010242f:	8b 40 58             	mov    0x58(%eax),%eax
80102432:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102435:	0f 87 69 ff ff ff    	ja     801023a4 <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010243b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102440:	c9                   	leave  
80102441:	c3                   	ret    

80102442 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102442:	55                   	push   %ebp
80102443:	89 e5                	mov    %esp,%ebp
80102445:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102448:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010244f:	00 
80102450:	8b 45 0c             	mov    0xc(%ebp),%eax
80102453:	89 44 24 04          	mov    %eax,0x4(%esp)
80102457:	8b 45 08             	mov    0x8(%ebp),%eax
8010245a:	89 04 24             	mov    %eax,(%esp)
8010245d:	e8 17 ff ff ff       	call   80102379 <dirlookup>
80102462:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102465:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102469:	74 15                	je     80102480 <dirlink+0x3e>
    iput(ip);
8010246b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010246e:	89 04 24             	mov    %eax,(%esp)
80102471:	e8 57 f6 ff ff       	call   80101acd <iput>
    return -1;
80102476:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010247b:	e9 b7 00 00 00       	jmp    80102537 <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102480:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102487:	eb 46                	jmp    801024cf <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102489:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010248c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102493:	00 
80102494:	89 44 24 08          	mov    %eax,0x8(%esp)
80102498:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010249b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010249f:	8b 45 08             	mov    0x8(%ebp),%eax
801024a2:	89 04 24             	mov    %eax,(%esp)
801024a5:	e8 ba fb ff ff       	call   80102064 <readi>
801024aa:	83 f8 10             	cmp    $0x10,%eax
801024ad:	74 0c                	je     801024bb <dirlink+0x79>
      panic("dirlink read");
801024af:	c7 04 24 9b 90 10 80 	movl   $0x8010909b,(%esp)
801024b6:	e8 a7 e0 ff ff       	call   80100562 <panic>
    if(de.inum == 0)
801024bb:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801024bf:	66 85 c0             	test   %ax,%ax
801024c2:	75 02                	jne    801024c6 <dirlink+0x84>
      break;
801024c4:	eb 16                	jmp    801024dc <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024c9:	83 c0 10             	add    $0x10,%eax
801024cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801024d2:	8b 45 08             	mov    0x8(%ebp),%eax
801024d5:	8b 40 58             	mov    0x58(%eax),%eax
801024d8:	39 c2                	cmp    %eax,%edx
801024da:	72 ad                	jb     80102489 <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801024dc:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801024e3:	00 
801024e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801024e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801024eb:	8d 45 e0             	lea    -0x20(%ebp),%eax
801024ee:	83 c0 02             	add    $0x2,%eax
801024f1:	89 04 24             	mov    %eax,(%esp)
801024f4:	e8 a5 35 00 00       	call   80105a9e <strncpy>
  de.inum = inum;
801024f9:	8b 45 10             	mov    0x10(%ebp),%eax
801024fc:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102500:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102503:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010250a:	00 
8010250b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010250f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102512:	89 44 24 04          	mov    %eax,0x4(%esp)
80102516:	8b 45 08             	mov    0x8(%ebp),%eax
80102519:	89 04 24             	mov    %eax,(%esp)
8010251c:	e8 a7 fc ff ff       	call   801021c8 <writei>
80102521:	83 f8 10             	cmp    $0x10,%eax
80102524:	74 0c                	je     80102532 <dirlink+0xf0>
    panic("dirlink");
80102526:	c7 04 24 a8 90 10 80 	movl   $0x801090a8,(%esp)
8010252d:	e8 30 e0 ff ff       	call   80100562 <panic>

  return 0;
80102532:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102537:	c9                   	leave  
80102538:	c3                   	ret    

80102539 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102539:	55                   	push   %ebp
8010253a:	89 e5                	mov    %esp,%ebp
8010253c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
8010253f:	eb 04                	jmp    80102545 <skipelem+0xc>
    path++;
80102541:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102545:	8b 45 08             	mov    0x8(%ebp),%eax
80102548:	0f b6 00             	movzbl (%eax),%eax
8010254b:	3c 2f                	cmp    $0x2f,%al
8010254d:	74 f2                	je     80102541 <skipelem+0x8>
    path++;
  if(*path == 0)
8010254f:	8b 45 08             	mov    0x8(%ebp),%eax
80102552:	0f b6 00             	movzbl (%eax),%eax
80102555:	84 c0                	test   %al,%al
80102557:	75 0a                	jne    80102563 <skipelem+0x2a>
    return 0;
80102559:	b8 00 00 00 00       	mov    $0x0,%eax
8010255e:	e9 86 00 00 00       	jmp    801025e9 <skipelem+0xb0>
  s = path;
80102563:	8b 45 08             	mov    0x8(%ebp),%eax
80102566:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102569:	eb 04                	jmp    8010256f <skipelem+0x36>
    path++;
8010256b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010256f:	8b 45 08             	mov    0x8(%ebp),%eax
80102572:	0f b6 00             	movzbl (%eax),%eax
80102575:	3c 2f                	cmp    $0x2f,%al
80102577:	74 0a                	je     80102583 <skipelem+0x4a>
80102579:	8b 45 08             	mov    0x8(%ebp),%eax
8010257c:	0f b6 00             	movzbl (%eax),%eax
8010257f:	84 c0                	test   %al,%al
80102581:	75 e8                	jne    8010256b <skipelem+0x32>
    path++;
  len = path - s;
80102583:	8b 55 08             	mov    0x8(%ebp),%edx
80102586:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102589:	29 c2                	sub    %eax,%edx
8010258b:	89 d0                	mov    %edx,%eax
8010258d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102590:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102594:	7e 1c                	jle    801025b2 <skipelem+0x79>
    memmove(name, s, DIRSIZ);
80102596:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010259d:	00 
8010259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801025a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801025a8:	89 04 24             	mov    %eax,(%esp)
801025ab:	e8 f5 33 00 00       	call   801059a5 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801025b0:	eb 2a                	jmp    801025dc <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801025b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801025b5:	89 44 24 08          	mov    %eax,0x8(%esp)
801025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801025c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801025c3:	89 04 24             	mov    %eax,(%esp)
801025c6:	e8 da 33 00 00       	call   801059a5 <memmove>
    name[len] = 0;
801025cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801025ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801025d1:	01 d0                	add    %edx,%eax
801025d3:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801025d6:	eb 04                	jmp    801025dc <skipelem+0xa3>
    path++;
801025d8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801025dc:	8b 45 08             	mov    0x8(%ebp),%eax
801025df:	0f b6 00             	movzbl (%eax),%eax
801025e2:	3c 2f                	cmp    $0x2f,%al
801025e4:	74 f2                	je     801025d8 <skipelem+0x9f>
    path++;
  return path;
801025e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
801025e9:	c9                   	leave  
801025ea:	c3                   	ret    

801025eb <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801025eb:	55                   	push   %ebp
801025ec:	89 e5                	mov    %esp,%ebp
801025ee:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
801025f1:	8b 45 08             	mov    0x8(%ebp),%eax
801025f4:	0f b6 00             	movzbl (%eax),%eax
801025f7:	3c 2f                	cmp    $0x2f,%al
801025f9:	75 1c                	jne    80102617 <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
801025fb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102602:	00 
80102603:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010260a:	e8 5c f2 ff ff       	call   8010186b <iget>
8010260f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102612:	e9 af 00 00 00       	jmp    801026c6 <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80102617:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010261d:	8b 40 68             	mov    0x68(%eax),%eax
80102620:	89 04 24             	mov    %eax,(%esp)
80102623:	e8 18 f3 ff ff       	call   80101940 <idup>
80102628:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010262b:	e9 96 00 00 00       	jmp    801026c6 <namex+0xdb>
    ilock(ip);
80102630:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102633:	89 04 24             	mov    %eax,(%esp)
80102636:	e8 37 f3 ff ff       	call   80101972 <ilock>
    if(ip->type != T_DIR){
8010263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010263e:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102642:	66 83 f8 01          	cmp    $0x1,%ax
80102646:	74 15                	je     8010265d <namex+0x72>
      iunlockput(ip);
80102648:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010264b:	89 04 24             	mov    %eax,(%esp)
8010264e:	e8 0e f5 ff ff       	call   80101b61 <iunlockput>
      return 0;
80102653:	b8 00 00 00 00       	mov    $0x0,%eax
80102658:	e9 a3 00 00 00       	jmp    80102700 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
8010265d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102661:	74 1d                	je     80102680 <namex+0x95>
80102663:	8b 45 08             	mov    0x8(%ebp),%eax
80102666:	0f b6 00             	movzbl (%eax),%eax
80102669:	84 c0                	test   %al,%al
8010266b:	75 13                	jne    80102680 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
8010266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102670:	89 04 24             	mov    %eax,(%esp)
80102673:	e8 11 f4 ff ff       	call   80101a89 <iunlock>
      return ip;
80102678:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010267b:	e9 80 00 00 00       	jmp    80102700 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102680:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102687:	00 
80102688:	8b 45 10             	mov    0x10(%ebp),%eax
8010268b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102692:	89 04 24             	mov    %eax,(%esp)
80102695:	e8 df fc ff ff       	call   80102379 <dirlookup>
8010269a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010269d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801026a1:	75 12                	jne    801026b5 <namex+0xca>
      iunlockput(ip);
801026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026a6:	89 04 24             	mov    %eax,(%esp)
801026a9:	e8 b3 f4 ff ff       	call   80101b61 <iunlockput>
      return 0;
801026ae:	b8 00 00 00 00       	mov    $0x0,%eax
801026b3:	eb 4b                	jmp    80102700 <namex+0x115>
    }
    iunlockput(ip);
801026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026b8:	89 04 24             	mov    %eax,(%esp)
801026bb:	e8 a1 f4 ff ff       	call   80101b61 <iunlockput>
    ip = next;
801026c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801026c6:	8b 45 10             	mov    0x10(%ebp),%eax
801026c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801026cd:	8b 45 08             	mov    0x8(%ebp),%eax
801026d0:	89 04 24             	mov    %eax,(%esp)
801026d3:	e8 61 fe ff ff       	call   80102539 <skipelem>
801026d8:	89 45 08             	mov    %eax,0x8(%ebp)
801026db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026df:	0f 85 4b ff ff ff    	jne    80102630 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801026e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801026e9:	74 12                	je     801026fd <namex+0x112>
    iput(ip);
801026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026ee:	89 04 24             	mov    %eax,(%esp)
801026f1:	e8 d7 f3 ff ff       	call   80101acd <iput>
    return 0;
801026f6:	b8 00 00 00 00       	mov    $0x0,%eax
801026fb:	eb 03                	jmp    80102700 <namex+0x115>
  }
  return ip;
801026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102700:	c9                   	leave  
80102701:	c3                   	ret    

80102702 <namei>:

struct inode*
namei(char *path)
{
80102702:	55                   	push   %ebp
80102703:	89 e5                	mov    %esp,%ebp
80102705:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102708:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010270b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010270f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102716:	00 
80102717:	8b 45 08             	mov    0x8(%ebp),%eax
8010271a:	89 04 24             	mov    %eax,(%esp)
8010271d:	e8 c9 fe ff ff       	call   801025eb <namex>
}
80102722:	c9                   	leave  
80102723:	c3                   	ret    

80102724 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102724:	55                   	push   %ebp
80102725:	89 e5                	mov    %esp,%ebp
80102727:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
8010272a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010272d:	89 44 24 08          	mov    %eax,0x8(%esp)
80102731:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102738:	00 
80102739:	8b 45 08             	mov    0x8(%ebp),%eax
8010273c:	89 04 24             	mov    %eax,(%esp)
8010273f:	e8 a7 fe ff ff       	call   801025eb <namex>
}
80102744:	c9                   	leave  
80102745:	c3                   	ret    

80102746 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102746:	55                   	push   %ebp
80102747:	89 e5                	mov    %esp,%ebp
80102749:	83 ec 14             	sub    $0x14,%esp
8010274c:	8b 45 08             	mov    0x8(%ebp),%eax
8010274f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102753:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102757:	89 c2                	mov    %eax,%edx
80102759:	ec                   	in     (%dx),%al
8010275a:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010275d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102761:	c9                   	leave  
80102762:	c3                   	ret    

80102763 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102763:	55                   	push   %ebp
80102764:	89 e5                	mov    %esp,%ebp
80102766:	57                   	push   %edi
80102767:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102768:	8b 55 08             	mov    0x8(%ebp),%edx
8010276b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010276e:	8b 45 10             	mov    0x10(%ebp),%eax
80102771:	89 cb                	mov    %ecx,%ebx
80102773:	89 df                	mov    %ebx,%edi
80102775:	89 c1                	mov    %eax,%ecx
80102777:	fc                   	cld    
80102778:	f3 6d                	rep insl (%dx),%es:(%edi)
8010277a:	89 c8                	mov    %ecx,%eax
8010277c:	89 fb                	mov    %edi,%ebx
8010277e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102781:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102784:	5b                   	pop    %ebx
80102785:	5f                   	pop    %edi
80102786:	5d                   	pop    %ebp
80102787:	c3                   	ret    

80102788 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102788:	55                   	push   %ebp
80102789:	89 e5                	mov    %esp,%ebp
8010278b:	83 ec 08             	sub    $0x8,%esp
8010278e:	8b 55 08             	mov    0x8(%ebp),%edx
80102791:	8b 45 0c             	mov    0xc(%ebp),%eax
80102794:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102798:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010279b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010279f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801027a3:	ee                   	out    %al,(%dx)
}
801027a4:	c9                   	leave  
801027a5:	c3                   	ret    

801027a6 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801027a6:	55                   	push   %ebp
801027a7:	89 e5                	mov    %esp,%ebp
801027a9:	56                   	push   %esi
801027aa:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801027ab:	8b 55 08             	mov    0x8(%ebp),%edx
801027ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027b1:	8b 45 10             	mov    0x10(%ebp),%eax
801027b4:	89 cb                	mov    %ecx,%ebx
801027b6:	89 de                	mov    %ebx,%esi
801027b8:	89 c1                	mov    %eax,%ecx
801027ba:	fc                   	cld    
801027bb:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801027bd:	89 c8                	mov    %ecx,%eax
801027bf:	89 f3                	mov    %esi,%ebx
801027c1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801027c4:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801027c7:	5b                   	pop    %ebx
801027c8:	5e                   	pop    %esi
801027c9:	5d                   	pop    %ebp
801027ca:	c3                   	ret    

801027cb <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801027cb:	55                   	push   %ebp
801027cc:	89 e5                	mov    %esp,%ebp
801027ce:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801027d1:	90                   	nop
801027d2:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801027d9:	e8 68 ff ff ff       	call   80102746 <inb>
801027de:	0f b6 c0             	movzbl %al,%eax
801027e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
801027e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801027e7:	25 c0 00 00 00       	and    $0xc0,%eax
801027ec:	83 f8 40             	cmp    $0x40,%eax
801027ef:	75 e1                	jne    801027d2 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801027f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801027f5:	74 11                	je     80102808 <idewait+0x3d>
801027f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801027fa:	83 e0 21             	and    $0x21,%eax
801027fd:	85 c0                	test   %eax,%eax
801027ff:	74 07                	je     80102808 <idewait+0x3d>
    return -1;
80102801:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102806:	eb 05                	jmp    8010280d <idewait+0x42>
  return 0;
80102808:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010280d:	c9                   	leave  
8010280e:	c3                   	ret    

8010280f <ideinit>:

void
ideinit(void)
{
8010280f:	55                   	push   %ebp
80102810:	89 e5                	mov    %esp,%ebp
80102812:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102815:	c7 44 24 04 b0 90 10 	movl   $0x801090b0,0x4(%esp)
8010281c:	80 
8010281d:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102824:	e8 23 2e 00 00       	call   8010564c <initlock>
  picenable(IRQ_IDE);
80102829:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102830:	e8 1e 18 00 00       	call   80104053 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102835:	a1 20 4e 11 80       	mov    0x80114e20,%eax
8010283a:	83 e8 01             	sub    $0x1,%eax
8010283d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102841:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102848:	e8 77 04 00 00       	call   80102cc4 <ioapicenable>
  idewait(0);
8010284d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102854:	e8 72 ff ff ff       	call   801027cb <idewait>

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102859:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102860:	00 
80102861:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102868:	e8 1b ff ff ff       	call   80102788 <outb>
  for(i=0; i<1000; i++){
8010286d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102874:	eb 20                	jmp    80102896 <ideinit+0x87>
    if(inb(0x1f7) != 0){
80102876:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010287d:	e8 c4 fe ff ff       	call   80102746 <inb>
80102882:	84 c0                	test   %al,%al
80102884:	74 0c                	je     80102892 <ideinit+0x83>
      havedisk1 = 1;
80102886:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
8010288d:	00 00 00 
      break;
80102890:	eb 0d                	jmp    8010289f <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102892:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102896:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
8010289d:	7e d7                	jle    80102876 <ideinit+0x67>
      break;
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
8010289f:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801028a6:	00 
801028a7:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801028ae:	e8 d5 fe ff ff       	call   80102788 <outb>
}
801028b3:	c9                   	leave  
801028b4:	c3                   	ret    

801028b5 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801028b5:	55                   	push   %ebp
801028b6:	89 e5                	mov    %esp,%ebp
801028b8:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
801028bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801028bf:	75 0c                	jne    801028cd <idestart+0x18>
    panic("idestart");
801028c1:	c7 04 24 b4 90 10 80 	movl   $0x801090b4,(%esp)
801028c8:	e8 95 dc ff ff       	call   80100562 <panic>
  if(b->blockno >= FSSIZE)
801028cd:	8b 45 08             	mov    0x8(%ebp),%eax
801028d0:	8b 40 08             	mov    0x8(%eax),%eax
801028d3:	3d cf 07 00 00       	cmp    $0x7cf,%eax
801028d8:	76 0c                	jbe    801028e6 <idestart+0x31>
    panic("incorrect blockno");
801028da:	c7 04 24 bd 90 10 80 	movl   $0x801090bd,(%esp)
801028e1:	e8 7c dc ff ff       	call   80100562 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801028e6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801028ed:	8b 45 08             	mov    0x8(%ebp),%eax
801028f0:	8b 50 08             	mov    0x8(%eax),%edx
801028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028f6:	0f af c2             	imul   %edx,%eax
801028f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
801028fc:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102900:	75 07                	jne    80102909 <idestart+0x54>
80102902:	b8 20 00 00 00       	mov    $0x20,%eax
80102907:	eb 05                	jmp    8010290e <idestart+0x59>
80102909:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010290e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
80102911:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102915:	75 07                	jne    8010291e <idestart+0x69>
80102917:	b8 30 00 00 00       	mov    $0x30,%eax
8010291c:	eb 05                	jmp    80102923 <idestart+0x6e>
8010291e:	b8 c5 00 00 00       	mov    $0xc5,%eax
80102923:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102926:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
8010292a:	7e 0c                	jle    80102938 <idestart+0x83>
8010292c:	c7 04 24 b4 90 10 80 	movl   $0x801090b4,(%esp)
80102933:	e8 2a dc ff ff       	call   80100562 <panic>

  idewait(0);
80102938:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010293f:	e8 87 fe ff ff       	call   801027cb <idewait>
  outb(0x3f6, 0);  // generate interrupt
80102944:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010294b:	00 
8010294c:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
80102953:	e8 30 fe ff ff       	call   80102788 <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
80102958:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010295b:	0f b6 c0             	movzbl %al,%eax
8010295e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102962:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102969:	e8 1a fe ff ff       	call   80102788 <outb>
  outb(0x1f3, sector & 0xff);
8010296e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102971:	0f b6 c0             	movzbl %al,%eax
80102974:	89 44 24 04          	mov    %eax,0x4(%esp)
80102978:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
8010297f:	e8 04 fe ff ff       	call   80102788 <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
80102984:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102987:	c1 f8 08             	sar    $0x8,%eax
8010298a:	0f b6 c0             	movzbl %al,%eax
8010298d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102991:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102998:	e8 eb fd ff ff       	call   80102788 <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
8010299d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801029a0:	c1 f8 10             	sar    $0x10,%eax
801029a3:	0f b6 c0             	movzbl %al,%eax
801029a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801029aa:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
801029b1:	e8 d2 fd ff ff       	call   80102788 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801029b6:	8b 45 08             	mov    0x8(%ebp),%eax
801029b9:	8b 40 04             	mov    0x4(%eax),%eax
801029bc:	83 e0 01             	and    $0x1,%eax
801029bf:	c1 e0 04             	shl    $0x4,%eax
801029c2:	89 c2                	mov    %eax,%edx
801029c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801029c7:	c1 f8 18             	sar    $0x18,%eax
801029ca:	83 e0 0f             	and    $0xf,%eax
801029cd:	09 d0                	or     %edx,%eax
801029cf:	83 c8 e0             	or     $0xffffffe0,%eax
801029d2:	0f b6 c0             	movzbl %al,%eax
801029d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801029d9:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801029e0:	e8 a3 fd ff ff       	call   80102788 <outb>
  if(b->flags & B_DIRTY){
801029e5:	8b 45 08             	mov    0x8(%ebp),%eax
801029e8:	8b 00                	mov    (%eax),%eax
801029ea:	83 e0 04             	and    $0x4,%eax
801029ed:	85 c0                	test   %eax,%eax
801029ef:	74 36                	je     80102a27 <idestart+0x172>
    outb(0x1f7, write_cmd);
801029f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801029f4:	0f b6 c0             	movzbl %al,%eax
801029f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801029fb:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102a02:	e8 81 fd ff ff       	call   80102788 <outb>
    outsl(0x1f0, b->data, BSIZE/4);
80102a07:	8b 45 08             	mov    0x8(%ebp),%eax
80102a0a:	83 c0 5c             	add    $0x5c,%eax
80102a0d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102a14:	00 
80102a15:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a19:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102a20:	e8 81 fd ff ff       	call   801027a6 <outsl>
80102a25:	eb 16                	jmp    80102a3d <idestart+0x188>
  } else {
    outb(0x1f7, read_cmd);
80102a27:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102a2a:	0f b6 c0             	movzbl %al,%eax
80102a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a31:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102a38:	e8 4b fd ff ff       	call   80102788 <outb>
  }
}
80102a3d:	c9                   	leave  
80102a3e:	c3                   	ret    

80102a3f <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102a3f:	55                   	push   %ebp
80102a40:	89 e5                	mov    %esp,%ebp
80102a42:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102a45:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102a4c:	e8 1c 2c 00 00       	call   8010566d <acquire>
  if((b = idequeue) == 0){
80102a51:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102a5d:	75 11                	jne    80102a70 <ideintr+0x31>
    release(&idelock);
80102a5f:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102a66:	e8 69 2c 00 00       	call   801056d4 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
80102a6b:	e9 90 00 00 00       	jmp    80102b00 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a73:	8b 40 58             	mov    0x58(%eax),%eax
80102a76:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a7e:	8b 00                	mov    (%eax),%eax
80102a80:	83 e0 04             	and    $0x4,%eax
80102a83:	85 c0                	test   %eax,%eax
80102a85:	75 2e                	jne    80102ab5 <ideintr+0x76>
80102a87:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102a8e:	e8 38 fd ff ff       	call   801027cb <idewait>
80102a93:	85 c0                	test   %eax,%eax
80102a95:	78 1e                	js     80102ab5 <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
80102a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a9a:	83 c0 5c             	add    $0x5c,%eax
80102a9d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102aa4:	00 
80102aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102aa9:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102ab0:	e8 ae fc ff ff       	call   80102763 <insl>

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ab8:	8b 00                	mov    (%eax),%eax
80102aba:	83 c8 02             	or     $0x2,%eax
80102abd:	89 c2                	mov    %eax,%edx
80102abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ac2:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ac7:	8b 00                	mov    (%eax),%eax
80102ac9:	83 e0 fb             	and    $0xfffffffb,%eax
80102acc:	89 c2                	mov    %eax,%edx
80102ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad6:	89 04 24             	mov    %eax,(%esp)
80102ad9:	e8 91 28 00 00       	call   8010536f <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102ade:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102ae3:	85 c0                	test   %eax,%eax
80102ae5:	74 0d                	je     80102af4 <ideintr+0xb5>
    idestart(idequeue);
80102ae7:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102aec:	89 04 24             	mov    %eax,(%esp)
80102aef:	e8 c1 fd ff ff       	call   801028b5 <idestart>

  release(&idelock);
80102af4:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102afb:	e8 d4 2b 00 00       	call   801056d4 <release>
}
80102b00:	c9                   	leave  
80102b01:	c3                   	ret    

80102b02 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102b02:	55                   	push   %ebp
80102b03:	89 e5                	mov    %esp,%ebp
80102b05:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102b08:	8b 45 08             	mov    0x8(%ebp),%eax
80102b0b:	83 c0 0c             	add    $0xc,%eax
80102b0e:	89 04 24             	mov    %eax,(%esp)
80102b11:	e8 d1 2a 00 00       	call   801055e7 <holdingsleep>
80102b16:	85 c0                	test   %eax,%eax
80102b18:	75 0c                	jne    80102b26 <iderw+0x24>
    panic("iderw: buf not locked");
80102b1a:	c7 04 24 cf 90 10 80 	movl   $0x801090cf,(%esp)
80102b21:	e8 3c da ff ff       	call   80100562 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102b26:	8b 45 08             	mov    0x8(%ebp),%eax
80102b29:	8b 00                	mov    (%eax),%eax
80102b2b:	83 e0 06             	and    $0x6,%eax
80102b2e:	83 f8 02             	cmp    $0x2,%eax
80102b31:	75 0c                	jne    80102b3f <iderw+0x3d>
    panic("iderw: nothing to do");
80102b33:	c7 04 24 e5 90 10 80 	movl   $0x801090e5,(%esp)
80102b3a:	e8 23 da ff ff       	call   80100562 <panic>
  if(b->dev != 0 && !havedisk1)
80102b3f:	8b 45 08             	mov    0x8(%ebp),%eax
80102b42:	8b 40 04             	mov    0x4(%eax),%eax
80102b45:	85 c0                	test   %eax,%eax
80102b47:	74 15                	je     80102b5e <iderw+0x5c>
80102b49:	a1 58 c6 10 80       	mov    0x8010c658,%eax
80102b4e:	85 c0                	test   %eax,%eax
80102b50:	75 0c                	jne    80102b5e <iderw+0x5c>
    panic("iderw: ide disk 1 not present");
80102b52:	c7 04 24 fa 90 10 80 	movl   $0x801090fa,(%esp)
80102b59:	e8 04 da ff ff       	call   80100562 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102b5e:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102b65:	e8 03 2b 00 00       	call   8010566d <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102b6a:	8b 45 08             	mov    0x8(%ebp),%eax
80102b6d:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102b74:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
80102b7b:	eb 0b                	jmp    80102b88 <iderw+0x86>
80102b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b80:	8b 00                	mov    (%eax),%eax
80102b82:	83 c0 58             	add    $0x58,%eax
80102b85:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b8b:	8b 00                	mov    (%eax),%eax
80102b8d:	85 c0                	test   %eax,%eax
80102b8f:	75 ec                	jne    80102b7d <iderw+0x7b>
    ;
  *pp = b;
80102b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b94:	8b 55 08             	mov    0x8(%ebp),%edx
80102b97:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
80102b99:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102b9e:	3b 45 08             	cmp    0x8(%ebp),%eax
80102ba1:	75 0d                	jne    80102bb0 <iderw+0xae>
    idestart(b);
80102ba3:	8b 45 08             	mov    0x8(%ebp),%eax
80102ba6:	89 04 24             	mov    %eax,(%esp)
80102ba9:	e8 07 fd ff ff       	call   801028b5 <idestart>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102bae:	eb 15                	jmp    80102bc5 <iderw+0xc3>
80102bb0:	eb 13                	jmp    80102bc5 <iderw+0xc3>
    sleep(b, &idelock);
80102bb2:	c7 44 24 04 20 c6 10 	movl   $0x8010c620,0x4(%esp)
80102bb9:	80 
80102bba:	8b 45 08             	mov    0x8(%ebp),%eax
80102bbd:	89 04 24             	mov    %eax,(%esp)
80102bc0:	e8 ce 26 00 00       	call   80105293 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102bc5:	8b 45 08             	mov    0x8(%ebp),%eax
80102bc8:	8b 00                	mov    (%eax),%eax
80102bca:	83 e0 06             	and    $0x6,%eax
80102bcd:	83 f8 02             	cmp    $0x2,%eax
80102bd0:	75 e0                	jne    80102bb2 <iderw+0xb0>
    sleep(b, &idelock);
  }

  release(&idelock);
80102bd2:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102bd9:	e8 f6 2a 00 00       	call   801056d4 <release>
}
80102bde:	c9                   	leave  
80102bdf:	c3                   	ret    

80102be0 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102be0:	55                   	push   %ebp
80102be1:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102be3:	a1 f4 46 11 80       	mov    0x801146f4,%eax
80102be8:	8b 55 08             	mov    0x8(%ebp),%edx
80102beb:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102bed:	a1 f4 46 11 80       	mov    0x801146f4,%eax
80102bf2:	8b 40 10             	mov    0x10(%eax),%eax
}
80102bf5:	5d                   	pop    %ebp
80102bf6:	c3                   	ret    

80102bf7 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102bf7:	55                   	push   %ebp
80102bf8:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102bfa:	a1 f4 46 11 80       	mov    0x801146f4,%eax
80102bff:	8b 55 08             	mov    0x8(%ebp),%edx
80102c02:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102c04:	a1 f4 46 11 80       	mov    0x801146f4,%eax
80102c09:	8b 55 0c             	mov    0xc(%ebp),%edx
80102c0c:	89 50 10             	mov    %edx,0x10(%eax)
}
80102c0f:	5d                   	pop    %ebp
80102c10:	c3                   	ret    

80102c11 <ioapicinit>:

void
ioapicinit(void)
{
80102c11:	55                   	push   %ebp
80102c12:	89 e5                	mov    %esp,%ebp
80102c14:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
80102c17:	a1 24 48 11 80       	mov    0x80114824,%eax
80102c1c:	85 c0                	test   %eax,%eax
80102c1e:	75 05                	jne    80102c25 <ioapicinit+0x14>
    return;
80102c20:	e9 9d 00 00 00       	jmp    80102cc2 <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
80102c25:	c7 05 f4 46 11 80 00 	movl   $0xfec00000,0x801146f4
80102c2c:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102c2f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102c36:	e8 a5 ff ff ff       	call   80102be0 <ioapicread>
80102c3b:	c1 e8 10             	shr    $0x10,%eax
80102c3e:	25 ff 00 00 00       	and    $0xff,%eax
80102c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102c46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102c4d:	e8 8e ff ff ff       	call   80102be0 <ioapicread>
80102c52:	c1 e8 18             	shr    $0x18,%eax
80102c55:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102c58:	0f b6 05 20 48 11 80 	movzbl 0x80114820,%eax
80102c5f:	0f b6 c0             	movzbl %al,%eax
80102c62:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102c65:	74 0c                	je     80102c73 <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102c67:	c7 04 24 18 91 10 80 	movl   $0x80109118,(%esp)
80102c6e:	e8 55 d7 ff ff       	call   801003c8 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102c73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102c7a:	eb 3e                	jmp    80102cba <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c7f:	83 c0 20             	add    $0x20,%eax
80102c82:	0d 00 00 01 00       	or     $0x10000,%eax
80102c87:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102c8a:	83 c2 08             	add    $0x8,%edx
80102c8d:	01 d2                	add    %edx,%edx
80102c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c93:	89 14 24             	mov    %edx,(%esp)
80102c96:	e8 5c ff ff ff       	call   80102bf7 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c9e:	83 c0 08             	add    $0x8,%eax
80102ca1:	01 c0                	add    %eax,%eax
80102ca3:	83 c0 01             	add    $0x1,%eax
80102ca6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102cad:	00 
80102cae:	89 04 24             	mov    %eax,(%esp)
80102cb1:	e8 41 ff ff ff       	call   80102bf7 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102cb6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cbd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102cc0:	7e ba                	jle    80102c7c <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102cc2:	c9                   	leave  
80102cc3:	c3                   	ret    

80102cc4 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102cc4:	55                   	push   %ebp
80102cc5:	89 e5                	mov    %esp,%ebp
80102cc7:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102cca:	a1 24 48 11 80       	mov    0x80114824,%eax
80102ccf:	85 c0                	test   %eax,%eax
80102cd1:	75 02                	jne    80102cd5 <ioapicenable+0x11>
    return;
80102cd3:	eb 37                	jmp    80102d0c <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102cd5:	8b 45 08             	mov    0x8(%ebp),%eax
80102cd8:	83 c0 20             	add    $0x20,%eax
80102cdb:	8b 55 08             	mov    0x8(%ebp),%edx
80102cde:	83 c2 08             	add    $0x8,%edx
80102ce1:	01 d2                	add    %edx,%edx
80102ce3:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ce7:	89 14 24             	mov    %edx,(%esp)
80102cea:	e8 08 ff ff ff       	call   80102bf7 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102cef:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cf2:	c1 e0 18             	shl    $0x18,%eax
80102cf5:	8b 55 08             	mov    0x8(%ebp),%edx
80102cf8:	83 c2 08             	add    $0x8,%edx
80102cfb:	01 d2                	add    %edx,%edx
80102cfd:	83 c2 01             	add    $0x1,%edx
80102d00:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d04:	89 14 24             	mov    %edx,(%esp)
80102d07:	e8 eb fe ff ff       	call   80102bf7 <ioapicwrite>
}
80102d0c:	c9                   	leave  
80102d0d:	c3                   	ret    

80102d0e <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102d0e:	55                   	push   %ebp
80102d0f:	89 e5                	mov    %esp,%ebp
80102d11:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102d14:	c7 44 24 04 4a 91 10 	movl   $0x8010914a,0x4(%esp)
80102d1b:	80 
80102d1c:	c7 04 24 00 47 11 80 	movl   $0x80114700,(%esp)
80102d23:	e8 24 29 00 00       	call   8010564c <initlock>
  kmem.use_lock = 0;
80102d28:	c7 05 34 47 11 80 00 	movl   $0x0,0x80114734
80102d2f:	00 00 00 
  freerange(vstart, vend);
80102d32:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d35:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d39:	8b 45 08             	mov    0x8(%ebp),%eax
80102d3c:	89 04 24             	mov    %eax,(%esp)
80102d3f:	e8 26 00 00 00       	call   80102d6a <freerange>
}
80102d44:	c9                   	leave  
80102d45:	c3                   	ret    

80102d46 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102d46:	55                   	push   %ebp
80102d47:	89 e5                	mov    %esp,%ebp
80102d49:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d53:	8b 45 08             	mov    0x8(%ebp),%eax
80102d56:	89 04 24             	mov    %eax,(%esp)
80102d59:	e8 0c 00 00 00       	call   80102d6a <freerange>
  kmem.use_lock = 1;
80102d5e:	c7 05 34 47 11 80 01 	movl   $0x1,0x80114734
80102d65:	00 00 00 
}
80102d68:	c9                   	leave  
80102d69:	c3                   	ret    

80102d6a <freerange>:

void
freerange(void *vstart, void *vend)
{
80102d6a:	55                   	push   %ebp
80102d6b:	89 e5                	mov    %esp,%ebp
80102d6d:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102d70:	8b 45 08             	mov    0x8(%ebp),%eax
80102d73:	05 ff 0f 00 00       	add    $0xfff,%eax
80102d78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102d7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d80:	eb 12                	jmp    80102d94 <freerange+0x2a>
    kfree(p);
80102d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d85:	89 04 24             	mov    %eax,(%esp)
80102d88:	e8 16 00 00 00       	call   80102da3 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d8d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d97:	05 00 10 00 00       	add    $0x1000,%eax
80102d9c:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102d9f:	76 e1                	jbe    80102d82 <freerange+0x18>
    kfree(p);
}
80102da1:	c9                   	leave  
80102da2:	c3                   	ret    

80102da3 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102da3:	55                   	push   %ebp
80102da4:	89 e5                	mov    %esp,%ebp
80102da6:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102da9:	8b 45 08             	mov    0x8(%ebp),%eax
80102dac:	25 ff 0f 00 00       	and    $0xfff,%eax
80102db1:	85 c0                	test   %eax,%eax
80102db3:	75 18                	jne    80102dcd <kfree+0x2a>
80102db5:	81 7d 08 c8 79 11 80 	cmpl   $0x801179c8,0x8(%ebp)
80102dbc:	72 0f                	jb     80102dcd <kfree+0x2a>
80102dbe:	8b 45 08             	mov    0x8(%ebp),%eax
80102dc1:	05 00 00 00 80       	add    $0x80000000,%eax
80102dc6:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102dcb:	76 0c                	jbe    80102dd9 <kfree+0x36>
    panic("kfree");
80102dcd:	c7 04 24 4f 91 10 80 	movl   $0x8010914f,(%esp)
80102dd4:	e8 89 d7 ff ff       	call   80100562 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102dd9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102de0:	00 
80102de1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102de8:	00 
80102de9:	8b 45 08             	mov    0x8(%ebp),%eax
80102dec:	89 04 24             	mov    %eax,(%esp)
80102def:	e8 e2 2a 00 00       	call   801058d6 <memset>

  if(kmem.use_lock)
80102df4:	a1 34 47 11 80       	mov    0x80114734,%eax
80102df9:	85 c0                	test   %eax,%eax
80102dfb:	74 0c                	je     80102e09 <kfree+0x66>
    acquire(&kmem.lock);
80102dfd:	c7 04 24 00 47 11 80 	movl   $0x80114700,(%esp)
80102e04:	e8 64 28 00 00       	call   8010566d <acquire>
  r = (struct run*)v;
80102e09:	8b 45 08             	mov    0x8(%ebp),%eax
80102e0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102e0f:	8b 15 38 47 11 80    	mov    0x80114738,%edx
80102e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e18:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e1d:	a3 38 47 11 80       	mov    %eax,0x80114738
  if(kmem.use_lock)
80102e22:	a1 34 47 11 80       	mov    0x80114734,%eax
80102e27:	85 c0                	test   %eax,%eax
80102e29:	74 0c                	je     80102e37 <kfree+0x94>
    release(&kmem.lock);
80102e2b:	c7 04 24 00 47 11 80 	movl   $0x80114700,(%esp)
80102e32:	e8 9d 28 00 00       	call   801056d4 <release>
}
80102e37:	c9                   	leave  
80102e38:	c3                   	ret    

80102e39 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102e39:	55                   	push   %ebp
80102e3a:	89 e5                	mov    %esp,%ebp
80102e3c:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102e3f:	a1 34 47 11 80       	mov    0x80114734,%eax
80102e44:	85 c0                	test   %eax,%eax
80102e46:	74 0c                	je     80102e54 <kalloc+0x1b>
    acquire(&kmem.lock);
80102e48:	c7 04 24 00 47 11 80 	movl   $0x80114700,(%esp)
80102e4f:	e8 19 28 00 00       	call   8010566d <acquire>
  r = kmem.freelist;
80102e54:	a1 38 47 11 80       	mov    0x80114738,%eax
80102e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102e5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102e60:	74 0a                	je     80102e6c <kalloc+0x33>
    kmem.freelist = r->next;
80102e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e65:	8b 00                	mov    (%eax),%eax
80102e67:	a3 38 47 11 80       	mov    %eax,0x80114738
  if(kmem.use_lock)
80102e6c:	a1 34 47 11 80       	mov    0x80114734,%eax
80102e71:	85 c0                	test   %eax,%eax
80102e73:	74 0c                	je     80102e81 <kalloc+0x48>
    release(&kmem.lock);
80102e75:	c7 04 24 00 47 11 80 	movl   $0x80114700,(%esp)
80102e7c:	e8 53 28 00 00       	call   801056d4 <release>
  return (char*)r;
80102e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102e84:	c9                   	leave  
80102e85:	c3                   	ret    

80102e86 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102e86:	55                   	push   %ebp
80102e87:	89 e5                	mov    %esp,%ebp
80102e89:	83 ec 14             	sub    $0x14,%esp
80102e8c:	8b 45 08             	mov    0x8(%ebp),%eax
80102e8f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e93:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e97:	89 c2                	mov    %eax,%edx
80102e99:	ec                   	in     (%dx),%al
80102e9a:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e9d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102ea1:	c9                   	leave  
80102ea2:	c3                   	ret    

80102ea3 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102ea3:	55                   	push   %ebp
80102ea4:	89 e5                	mov    %esp,%ebp
80102ea6:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102ea9:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102eb0:	e8 d1 ff ff ff       	call   80102e86 <inb>
80102eb5:	0f b6 c0             	movzbl %al,%eax
80102eb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ebe:	83 e0 01             	and    $0x1,%eax
80102ec1:	85 c0                	test   %eax,%eax
80102ec3:	75 0a                	jne    80102ecf <kbdgetc+0x2c>
    return -1;
80102ec5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102eca:	e9 25 01 00 00       	jmp    80102ff4 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102ecf:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102ed6:	e8 ab ff ff ff       	call   80102e86 <inb>
80102edb:	0f b6 c0             	movzbl %al,%eax
80102ede:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102ee1:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102ee8:	75 17                	jne    80102f01 <kbdgetc+0x5e>
    shift |= E0ESC;
80102eea:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102eef:	83 c8 40             	or     $0x40,%eax
80102ef2:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102ef7:	b8 00 00 00 00       	mov    $0x0,%eax
80102efc:	e9 f3 00 00 00       	jmp    80102ff4 <kbdgetc+0x151>
  } else if(data & 0x80){
80102f01:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f04:	25 80 00 00 00       	and    $0x80,%eax
80102f09:	85 c0                	test   %eax,%eax
80102f0b:	74 45                	je     80102f52 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102f0d:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102f12:	83 e0 40             	and    $0x40,%eax
80102f15:	85 c0                	test   %eax,%eax
80102f17:	75 08                	jne    80102f21 <kbdgetc+0x7e>
80102f19:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f1c:	83 e0 7f             	and    $0x7f,%eax
80102f1f:	eb 03                	jmp    80102f24 <kbdgetc+0x81>
80102f21:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f24:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102f27:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f2a:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102f2f:	0f b6 00             	movzbl (%eax),%eax
80102f32:	83 c8 40             	or     $0x40,%eax
80102f35:	0f b6 c0             	movzbl %al,%eax
80102f38:	f7 d0                	not    %eax
80102f3a:	89 c2                	mov    %eax,%edx
80102f3c:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102f41:	21 d0                	and    %edx,%eax
80102f43:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102f48:	b8 00 00 00 00       	mov    $0x0,%eax
80102f4d:	e9 a2 00 00 00       	jmp    80102ff4 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102f52:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102f57:	83 e0 40             	and    $0x40,%eax
80102f5a:	85 c0                	test   %eax,%eax
80102f5c:	74 14                	je     80102f72 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f5e:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102f65:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102f6a:	83 e0 bf             	and    $0xffffffbf,%eax
80102f6d:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102f72:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f75:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102f7a:	0f b6 00             	movzbl (%eax),%eax
80102f7d:	0f b6 d0             	movzbl %al,%edx
80102f80:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102f85:	09 d0                	or     %edx,%eax
80102f87:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102f8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f8f:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102f94:	0f b6 00             	movzbl (%eax),%eax
80102f97:	0f b6 d0             	movzbl %al,%edx
80102f9a:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102f9f:	31 d0                	xor    %edx,%eax
80102fa1:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102fa6:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102fab:	83 e0 03             	and    $0x3,%eax
80102fae:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102fb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102fb8:	01 d0                	add    %edx,%eax
80102fba:	0f b6 00             	movzbl (%eax),%eax
80102fbd:	0f b6 c0             	movzbl %al,%eax
80102fc0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102fc3:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102fc8:	83 e0 08             	and    $0x8,%eax
80102fcb:	85 c0                	test   %eax,%eax
80102fcd:	74 22                	je     80102ff1 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102fcf:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102fd3:	76 0c                	jbe    80102fe1 <kbdgetc+0x13e>
80102fd5:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102fd9:	77 06                	ja     80102fe1 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102fdb:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102fdf:	eb 10                	jmp    80102ff1 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102fe1:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102fe5:	76 0a                	jbe    80102ff1 <kbdgetc+0x14e>
80102fe7:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102feb:	77 04                	ja     80102ff1 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102fed:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102ff4:	c9                   	leave  
80102ff5:	c3                   	ret    

80102ff6 <kbdintr>:

void
kbdintr(void)
{
80102ff6:	55                   	push   %ebp
80102ff7:	89 e5                	mov    %esp,%ebp
80102ff9:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102ffc:	c7 04 24 a3 2e 10 80 	movl   $0x80102ea3,(%esp)
80103003:	e8 e8 d7 ff ff       	call   801007f0 <consoleintr>
}
80103008:	c9                   	leave  
80103009:	c3                   	ret    

8010300a <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010300a:	55                   	push   %ebp
8010300b:	89 e5                	mov    %esp,%ebp
8010300d:	83 ec 14             	sub    $0x14,%esp
80103010:	8b 45 08             	mov    0x8(%ebp),%eax
80103013:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103017:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010301b:	89 c2                	mov    %eax,%edx
8010301d:	ec                   	in     (%dx),%al
8010301e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103021:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103025:	c9                   	leave  
80103026:	c3                   	ret    

80103027 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103027:	55                   	push   %ebp
80103028:	89 e5                	mov    %esp,%ebp
8010302a:	83 ec 08             	sub    $0x8,%esp
8010302d:	8b 55 08             	mov    0x8(%ebp),%edx
80103030:	8b 45 0c             	mov    0xc(%ebp),%eax
80103033:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103037:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010303a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010303e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103042:	ee                   	out    %al,(%dx)
}
80103043:	c9                   	leave  
80103044:	c3                   	ret    

80103045 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103045:	55                   	push   %ebp
80103046:	89 e5                	mov    %esp,%ebp
80103048:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010304b:	9c                   	pushf  
8010304c:	58                   	pop    %eax
8010304d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103050:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103053:	c9                   	leave  
80103054:	c3                   	ret    

80103055 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80103055:	55                   	push   %ebp
80103056:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80103058:	a1 3c 47 11 80       	mov    0x8011473c,%eax
8010305d:	8b 55 08             	mov    0x8(%ebp),%edx
80103060:	c1 e2 02             	shl    $0x2,%edx
80103063:	01 c2                	add    %eax,%edx
80103065:	8b 45 0c             	mov    0xc(%ebp),%eax
80103068:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
8010306a:	a1 3c 47 11 80       	mov    0x8011473c,%eax
8010306f:	83 c0 20             	add    $0x20,%eax
80103072:	8b 00                	mov    (%eax),%eax
}
80103074:	5d                   	pop    %ebp
80103075:	c3                   	ret    

80103076 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80103076:	55                   	push   %ebp
80103077:	89 e5                	mov    %esp,%ebp
80103079:	83 ec 08             	sub    $0x8,%esp
  if(!lapic)
8010307c:	a1 3c 47 11 80       	mov    0x8011473c,%eax
80103081:	85 c0                	test   %eax,%eax
80103083:	75 05                	jne    8010308a <lapicinit+0x14>
    return;
80103085:	e9 43 01 00 00       	jmp    801031cd <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
8010308a:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80103091:	00 
80103092:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80103099:	e8 b7 ff ff ff       	call   80103055 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
8010309e:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
801030a5:	00 
801030a6:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
801030ad:	e8 a3 ff ff ff       	call   80103055 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
801030b2:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
801030b9:	00 
801030ba:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801030c1:	e8 8f ff ff ff       	call   80103055 <lapicw>
  lapicw(TICR, 10000000);
801030c6:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
801030cd:	00 
801030ce:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
801030d5:	e8 7b ff ff ff       	call   80103055 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
801030da:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801030e1:	00 
801030e2:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
801030e9:	e8 67 ff ff ff       	call   80103055 <lapicw>
  lapicw(LINT1, MASKED);
801030ee:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801030f5:	00 
801030f6:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
801030fd:	e8 53 ff ff ff       	call   80103055 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80103102:	a1 3c 47 11 80       	mov    0x8011473c,%eax
80103107:	83 c0 30             	add    $0x30,%eax
8010310a:	8b 00                	mov    (%eax),%eax
8010310c:	c1 e8 10             	shr    $0x10,%eax
8010310f:	0f b6 c0             	movzbl %al,%eax
80103112:	83 f8 03             	cmp    $0x3,%eax
80103115:	76 14                	jbe    8010312b <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80103117:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
8010311e:	00 
8010311f:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80103126:	e8 2a ff ff ff       	call   80103055 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
8010312b:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80103132:	00 
80103133:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
8010313a:	e8 16 ff ff ff       	call   80103055 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
8010313f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103146:	00 
80103147:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
8010314e:	e8 02 ff ff ff       	call   80103055 <lapicw>
  lapicw(ESR, 0);
80103153:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010315a:	00 
8010315b:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103162:	e8 ee fe ff ff       	call   80103055 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103167:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010316e:	00 
8010316f:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80103176:	e8 da fe ff ff       	call   80103055 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
8010317b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103182:	00 
80103183:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010318a:	e8 c6 fe ff ff       	call   80103055 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010318f:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80103196:	00 
80103197:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010319e:	e8 b2 fe ff ff       	call   80103055 <lapicw>
  while(lapic[ICRLO] & DELIVS)
801031a3:	90                   	nop
801031a4:	a1 3c 47 11 80       	mov    0x8011473c,%eax
801031a9:	05 00 03 00 00       	add    $0x300,%eax
801031ae:	8b 00                	mov    (%eax),%eax
801031b0:	25 00 10 00 00       	and    $0x1000,%eax
801031b5:	85 c0                	test   %eax,%eax
801031b7:	75 eb                	jne    801031a4 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
801031b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801031c0:	00 
801031c1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801031c8:	e8 88 fe ff ff       	call   80103055 <lapicw>
}
801031cd:	c9                   	leave  
801031ce:	c3                   	ret    

801031cf <cpunum>:

int
cpunum(void)
{
801031cf:	55                   	push   %ebp
801031d0:	89 e5                	mov    %esp,%ebp
801031d2:	83 ec 28             	sub    $0x28,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
801031d5:	e8 6b fe ff ff       	call   80103045 <readeflags>
801031da:	25 00 02 00 00       	and    $0x200,%eax
801031df:	85 c0                	test   %eax,%eax
801031e1:	74 25                	je     80103208 <cpunum+0x39>
    static int n;
    if(n++ == 0)
801031e3:	a1 60 c6 10 80       	mov    0x8010c660,%eax
801031e8:	8d 50 01             	lea    0x1(%eax),%edx
801031eb:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
801031f1:	85 c0                	test   %eax,%eax
801031f3:	75 13                	jne    80103208 <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
801031f5:	8b 45 04             	mov    0x4(%ebp),%eax
801031f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801031fc:	c7 04 24 58 91 10 80 	movl   $0x80109158,(%esp)
80103203:	e8 c0 d1 ff ff       	call   801003c8 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
80103208:	a1 3c 47 11 80       	mov    0x8011473c,%eax
8010320d:	85 c0                	test   %eax,%eax
8010320f:	75 07                	jne    80103218 <cpunum+0x49>
    return 0;
80103211:	b8 00 00 00 00       	mov    $0x0,%eax
80103216:	eb 51                	jmp    80103269 <cpunum+0x9a>

  apicid = lapic[ID] >> 24;
80103218:	a1 3c 47 11 80       	mov    0x8011473c,%eax
8010321d:	83 c0 20             	add    $0x20,%eax
80103220:	8b 00                	mov    (%eax),%eax
80103222:	c1 e8 18             	shr    $0x18,%eax
80103225:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; i < ncpu; ++i) {
80103228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010322f:	eb 22                	jmp    80103253 <cpunum+0x84>
    if (cpus[i].apicid == apicid)
80103231:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103234:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010323a:	05 40 48 11 80       	add    $0x80114840,%eax
8010323f:	0f b6 00             	movzbl (%eax),%eax
80103242:	0f b6 c0             	movzbl %al,%eax
80103245:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80103248:	75 05                	jne    8010324f <cpunum+0x80>
      return i;
8010324a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010324d:	eb 1a                	jmp    80103269 <cpunum+0x9a>

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
8010324f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103253:	a1 20 4e 11 80       	mov    0x80114e20,%eax
80103258:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010325b:	7c d4                	jl     80103231 <cpunum+0x62>
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
8010325d:	c7 04 24 84 91 10 80 	movl   $0x80109184,(%esp)
80103264:	e8 f9 d2 ff ff       	call   80100562 <panic>
}
80103269:	c9                   	leave  
8010326a:	c3                   	ret    

8010326b <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
8010326b:	55                   	push   %ebp
8010326c:	89 e5                	mov    %esp,%ebp
8010326e:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80103271:	a1 3c 47 11 80       	mov    0x8011473c,%eax
80103276:	85 c0                	test   %eax,%eax
80103278:	74 14                	je     8010328e <lapiceoi+0x23>
    lapicw(EOI, 0);
8010327a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103281:	00 
80103282:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80103289:	e8 c7 fd ff ff       	call   80103055 <lapicw>
}
8010328e:	c9                   	leave  
8010328f:	c3                   	ret    

80103290 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
}
80103293:	5d                   	pop    %ebp
80103294:	c3                   	ret    

80103295 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103295:	55                   	push   %ebp
80103296:	89 e5                	mov    %esp,%ebp
80103298:	83 ec 1c             	sub    $0x1c,%esp
8010329b:	8b 45 08             	mov    0x8(%ebp),%eax
8010329e:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801032a1:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
801032a8:	00 
801032a9:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
801032b0:	e8 72 fd ff ff       	call   80103027 <outb>
  outb(CMOS_PORT+1, 0x0A);
801032b5:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
801032bc:	00 
801032bd:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
801032c4:	e8 5e fd ff ff       	call   80103027 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
801032c9:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801032d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
801032d3:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801032d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
801032db:	8d 50 02             	lea    0x2(%eax),%edx
801032de:	8b 45 0c             	mov    0xc(%ebp),%eax
801032e1:	c1 e8 04             	shr    $0x4,%eax
801032e4:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801032e7:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801032eb:	c1 e0 18             	shl    $0x18,%eax
801032ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801032f2:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
801032f9:	e8 57 fd ff ff       	call   80103055 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801032fe:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80103305:	00 
80103306:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010330d:	e8 43 fd ff ff       	call   80103055 <lapicw>
  microdelay(200);
80103312:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103319:	e8 72 ff ff ff       	call   80103290 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
8010331e:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80103325:	00 
80103326:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010332d:	e8 23 fd ff ff       	call   80103055 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103332:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80103339:	e8 52 ff ff ff       	call   80103290 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010333e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103345:	eb 40                	jmp    80103387 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80103347:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010334b:	c1 e0 18             	shl    $0x18,%eax
8010334e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103352:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103359:	e8 f7 fc ff ff       	call   80103055 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010335e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103361:	c1 e8 0c             	shr    $0xc,%eax
80103364:	80 cc 06             	or     $0x6,%ah
80103367:	89 44 24 04          	mov    %eax,0x4(%esp)
8010336b:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103372:	e8 de fc ff ff       	call   80103055 <lapicw>
    microdelay(200);
80103377:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010337e:	e8 0d ff ff ff       	call   80103290 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103383:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103387:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010338b:	7e ba                	jle    80103347 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010338d:	c9                   	leave  
8010338e:	c3                   	ret    

8010338f <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
8010338f:	55                   	push   %ebp
80103390:	89 e5                	mov    %esp,%ebp
80103392:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
80103395:	8b 45 08             	mov    0x8(%ebp),%eax
80103398:	0f b6 c0             	movzbl %al,%eax
8010339b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010339f:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
801033a6:	e8 7c fc ff ff       	call   80103027 <outb>
  microdelay(200);
801033ab:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801033b2:	e8 d9 fe ff ff       	call   80103290 <microdelay>

  return inb(CMOS_RETURN);
801033b7:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
801033be:	e8 47 fc ff ff       	call   8010300a <inb>
801033c3:	0f b6 c0             	movzbl %al,%eax
}
801033c6:	c9                   	leave  
801033c7:	c3                   	ret    

801033c8 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801033c8:	55                   	push   %ebp
801033c9:	89 e5                	mov    %esp,%ebp
801033cb:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
801033ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801033d5:	e8 b5 ff ff ff       	call   8010338f <cmos_read>
801033da:	8b 55 08             	mov    0x8(%ebp),%edx
801033dd:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
801033df:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801033e6:	e8 a4 ff ff ff       	call   8010338f <cmos_read>
801033eb:	8b 55 08             	mov    0x8(%ebp),%edx
801033ee:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
801033f1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801033f8:	e8 92 ff ff ff       	call   8010338f <cmos_read>
801033fd:	8b 55 08             	mov    0x8(%ebp),%edx
80103400:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80103403:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
8010340a:	e8 80 ff ff ff       	call   8010338f <cmos_read>
8010340f:	8b 55 08             	mov    0x8(%ebp),%edx
80103412:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80103415:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010341c:	e8 6e ff ff ff       	call   8010338f <cmos_read>
80103421:	8b 55 08             	mov    0x8(%ebp),%edx
80103424:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
80103427:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
8010342e:	e8 5c ff ff ff       	call   8010338f <cmos_read>
80103433:	8b 55 08             	mov    0x8(%ebp),%edx
80103436:	89 42 14             	mov    %eax,0x14(%edx)
}
80103439:	c9                   	leave  
8010343a:	c3                   	ret    

8010343b <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
8010343b:	55                   	push   %ebp
8010343c:	89 e5                	mov    %esp,%ebp
8010343e:	83 ec 58             	sub    $0x58,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103441:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
80103448:	e8 42 ff ff ff       	call   8010338f <cmos_read>
8010344d:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103450:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103453:	83 e0 04             	and    $0x4,%eax
80103456:	85 c0                	test   %eax,%eax
80103458:	0f 94 c0             	sete   %al
8010345b:	0f b6 c0             	movzbl %al,%eax
8010345e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80103461:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103464:	89 04 24             	mov    %eax,(%esp)
80103467:	e8 5c ff ff ff       	call   801033c8 <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010346c:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80103473:	e8 17 ff ff ff       	call   8010338f <cmos_read>
80103478:	25 80 00 00 00       	and    $0x80,%eax
8010347d:	85 c0                	test   %eax,%eax
8010347f:	74 02                	je     80103483 <cmostime+0x48>
        continue;
80103481:	eb 36                	jmp    801034b9 <cmostime+0x7e>
    fill_rtcdate(&t2);
80103483:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103486:	89 04 24             	mov    %eax,(%esp)
80103489:	e8 3a ff ff ff       	call   801033c8 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010348e:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80103495:	00 
80103496:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103499:	89 44 24 04          	mov    %eax,0x4(%esp)
8010349d:	8d 45 d8             	lea    -0x28(%ebp),%eax
801034a0:	89 04 24             	mov    %eax,(%esp)
801034a3:	e8 a5 24 00 00       	call   8010594d <memcmp>
801034a8:	85 c0                	test   %eax,%eax
801034aa:	75 0d                	jne    801034b9 <cmostime+0x7e>
      break;
801034ac:	90                   	nop
  }

  // convert
  if(bcd) {
801034ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801034b1:	0f 84 ac 00 00 00    	je     80103563 <cmostime+0x128>
801034b7:	eb 02                	jmp    801034bb <cmostime+0x80>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801034b9:	eb a6                	jmp    80103461 <cmostime+0x26>

  // convert
  if(bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801034bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
801034be:	c1 e8 04             	shr    $0x4,%eax
801034c1:	89 c2                	mov    %eax,%edx
801034c3:	89 d0                	mov    %edx,%eax
801034c5:	c1 e0 02             	shl    $0x2,%eax
801034c8:	01 d0                	add    %edx,%eax
801034ca:	01 c0                	add    %eax,%eax
801034cc:	8b 55 d8             	mov    -0x28(%ebp),%edx
801034cf:	83 e2 0f             	and    $0xf,%edx
801034d2:	01 d0                	add    %edx,%eax
801034d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801034d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801034da:	c1 e8 04             	shr    $0x4,%eax
801034dd:	89 c2                	mov    %eax,%edx
801034df:	89 d0                	mov    %edx,%eax
801034e1:	c1 e0 02             	shl    $0x2,%eax
801034e4:	01 d0                	add    %edx,%eax
801034e6:	01 c0                	add    %eax,%eax
801034e8:	8b 55 dc             	mov    -0x24(%ebp),%edx
801034eb:	83 e2 0f             	and    $0xf,%edx
801034ee:	01 d0                	add    %edx,%eax
801034f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801034f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801034f6:	c1 e8 04             	shr    $0x4,%eax
801034f9:	89 c2                	mov    %eax,%edx
801034fb:	89 d0                	mov    %edx,%eax
801034fd:	c1 e0 02             	shl    $0x2,%eax
80103500:	01 d0                	add    %edx,%eax
80103502:	01 c0                	add    %eax,%eax
80103504:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103507:	83 e2 0f             	and    $0xf,%edx
8010350a:	01 d0                	add    %edx,%eax
8010350c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
8010350f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103512:	c1 e8 04             	shr    $0x4,%eax
80103515:	89 c2                	mov    %eax,%edx
80103517:	89 d0                	mov    %edx,%eax
80103519:	c1 e0 02             	shl    $0x2,%eax
8010351c:	01 d0                	add    %edx,%eax
8010351e:	01 c0                	add    %eax,%eax
80103520:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103523:	83 e2 0f             	and    $0xf,%edx
80103526:	01 d0                	add    %edx,%eax
80103528:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
8010352b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010352e:	c1 e8 04             	shr    $0x4,%eax
80103531:	89 c2                	mov    %eax,%edx
80103533:	89 d0                	mov    %edx,%eax
80103535:	c1 e0 02             	shl    $0x2,%eax
80103538:	01 d0                	add    %edx,%eax
8010353a:	01 c0                	add    %eax,%eax
8010353c:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010353f:	83 e2 0f             	and    $0xf,%edx
80103542:	01 d0                	add    %edx,%eax
80103544:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103547:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010354a:	c1 e8 04             	shr    $0x4,%eax
8010354d:	89 c2                	mov    %eax,%edx
8010354f:	89 d0                	mov    %edx,%eax
80103551:	c1 e0 02             	shl    $0x2,%eax
80103554:	01 d0                	add    %edx,%eax
80103556:	01 c0                	add    %eax,%eax
80103558:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010355b:	83 e2 0f             	and    $0xf,%edx
8010355e:	01 d0                	add    %edx,%eax
80103560:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103563:	8b 45 08             	mov    0x8(%ebp),%eax
80103566:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103569:	89 10                	mov    %edx,(%eax)
8010356b:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010356e:	89 50 04             	mov    %edx,0x4(%eax)
80103571:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103574:	89 50 08             	mov    %edx,0x8(%eax)
80103577:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010357a:	89 50 0c             	mov    %edx,0xc(%eax)
8010357d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103580:	89 50 10             	mov    %edx,0x10(%eax)
80103583:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103586:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103589:	8b 45 08             	mov    0x8(%ebp),%eax
8010358c:	8b 40 14             	mov    0x14(%eax),%eax
8010358f:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103595:	8b 45 08             	mov    0x8(%ebp),%eax
80103598:	89 50 14             	mov    %edx,0x14(%eax)
}
8010359b:	c9                   	leave  
8010359c:	c3                   	ret    

8010359d <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
8010359d:	55                   	push   %ebp
8010359e:	89 e5                	mov    %esp,%ebp
801035a0:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801035a3:	c7 44 24 04 94 91 10 	movl   $0x80109194,0x4(%esp)
801035aa:	80 
801035ab:	c7 04 24 40 47 11 80 	movl   $0x80114740,(%esp)
801035b2:	e8 95 20 00 00       	call   8010564c <initlock>
  readsb(dev, &sb);
801035b7:	8d 45 dc             	lea    -0x24(%ebp),%eax
801035ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801035be:	8b 45 08             	mov    0x8(%ebp),%eax
801035c1:	89 04 24             	mov    %eax,(%esp)
801035c4:	e8 9c dd ff ff       	call   80101365 <readsb>
  log.start = sb.logstart;
801035c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035cc:	a3 74 47 11 80       	mov    %eax,0x80114774
  log.size = sb.nlog;
801035d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801035d4:	a3 78 47 11 80       	mov    %eax,0x80114778
  log.dev = dev;
801035d9:	8b 45 08             	mov    0x8(%ebp),%eax
801035dc:	a3 84 47 11 80       	mov    %eax,0x80114784
  recover_from_log();
801035e1:	e8 9a 01 00 00       	call   80103780 <recover_from_log>
}
801035e6:	c9                   	leave  
801035e7:	c3                   	ret    

801035e8 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801035e8:	55                   	push   %ebp
801035e9:	89 e5                	mov    %esp,%ebp
801035eb:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035f5:	e9 8c 00 00 00       	jmp    80103686 <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801035fa:	8b 15 74 47 11 80    	mov    0x80114774,%edx
80103600:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103603:	01 d0                	add    %edx,%eax
80103605:	83 c0 01             	add    $0x1,%eax
80103608:	89 c2                	mov    %eax,%edx
8010360a:	a1 84 47 11 80       	mov    0x80114784,%eax
8010360f:	89 54 24 04          	mov    %edx,0x4(%esp)
80103613:	89 04 24             	mov    %eax,(%esp)
80103616:	e8 9a cb ff ff       	call   801001b5 <bread>
8010361b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010361e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103621:	83 c0 10             	add    $0x10,%eax
80103624:	8b 04 85 4c 47 11 80 	mov    -0x7feeb8b4(,%eax,4),%eax
8010362b:	89 c2                	mov    %eax,%edx
8010362d:	a1 84 47 11 80       	mov    0x80114784,%eax
80103632:	89 54 24 04          	mov    %edx,0x4(%esp)
80103636:	89 04 24             	mov    %eax,(%esp)
80103639:	e8 77 cb ff ff       	call   801001b5 <bread>
8010363e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103641:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103644:	8d 50 5c             	lea    0x5c(%eax),%edx
80103647:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010364a:	83 c0 5c             	add    $0x5c,%eax
8010364d:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103654:	00 
80103655:	89 54 24 04          	mov    %edx,0x4(%esp)
80103659:	89 04 24             	mov    %eax,(%esp)
8010365c:	e8 44 23 00 00       	call   801059a5 <memmove>
    bwrite(dbuf);  // write dst to disk
80103661:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103664:	89 04 24             	mov    %eax,(%esp)
80103667:	e8 80 cb ff ff       	call   801001ec <bwrite>
    brelse(lbuf);
8010366c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010366f:	89 04 24             	mov    %eax,(%esp)
80103672:	e8 b5 cb ff ff       	call   8010022c <brelse>
    brelse(dbuf);
80103677:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010367a:	89 04 24             	mov    %eax,(%esp)
8010367d:	e8 aa cb ff ff       	call   8010022c <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103682:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103686:	a1 88 47 11 80       	mov    0x80114788,%eax
8010368b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010368e:	0f 8f 66 ff ff ff    	jg     801035fa <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80103694:	c9                   	leave  
80103695:	c3                   	ret    

80103696 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103696:	55                   	push   %ebp
80103697:	89 e5                	mov    %esp,%ebp
80103699:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010369c:	a1 74 47 11 80       	mov    0x80114774,%eax
801036a1:	89 c2                	mov    %eax,%edx
801036a3:	a1 84 47 11 80       	mov    0x80114784,%eax
801036a8:	89 54 24 04          	mov    %edx,0x4(%esp)
801036ac:	89 04 24             	mov    %eax,(%esp)
801036af:	e8 01 cb ff ff       	call   801001b5 <bread>
801036b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801036b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036ba:	83 c0 5c             	add    $0x5c,%eax
801036bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801036c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036c3:	8b 00                	mov    (%eax),%eax
801036c5:	a3 88 47 11 80       	mov    %eax,0x80114788
  for (i = 0; i < log.lh.n; i++) {
801036ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036d1:	eb 1b                	jmp    801036ee <read_head+0x58>
    log.lh.block[i] = lh->block[i];
801036d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036d9:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801036dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036e0:	83 c2 10             	add    $0x10,%edx
801036e3:	89 04 95 4c 47 11 80 	mov    %eax,-0x7feeb8b4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801036ea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036ee:	a1 88 47 11 80       	mov    0x80114788,%eax
801036f3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036f6:	7f db                	jg     801036d3 <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801036f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036fb:	89 04 24             	mov    %eax,(%esp)
801036fe:	e8 29 cb ff ff       	call   8010022c <brelse>
}
80103703:	c9                   	leave  
80103704:	c3                   	ret    

80103705 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103705:	55                   	push   %ebp
80103706:	89 e5                	mov    %esp,%ebp
80103708:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010370b:	a1 74 47 11 80       	mov    0x80114774,%eax
80103710:	89 c2                	mov    %eax,%edx
80103712:	a1 84 47 11 80       	mov    0x80114784,%eax
80103717:	89 54 24 04          	mov    %edx,0x4(%esp)
8010371b:	89 04 24             	mov    %eax,(%esp)
8010371e:	e8 92 ca ff ff       	call   801001b5 <bread>
80103723:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103726:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103729:	83 c0 5c             	add    $0x5c,%eax
8010372c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010372f:	8b 15 88 47 11 80    	mov    0x80114788,%edx
80103735:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103738:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010373a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103741:	eb 1b                	jmp    8010375e <write_head+0x59>
    hb->block[i] = log.lh.block[i];
80103743:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103746:	83 c0 10             	add    $0x10,%eax
80103749:	8b 0c 85 4c 47 11 80 	mov    -0x7feeb8b4(,%eax,4),%ecx
80103750:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103753:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103756:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
8010375a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010375e:	a1 88 47 11 80       	mov    0x80114788,%eax
80103763:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103766:	7f db                	jg     80103743 <write_head+0x3e>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80103768:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010376b:	89 04 24             	mov    %eax,(%esp)
8010376e:	e8 79 ca ff ff       	call   801001ec <bwrite>
  brelse(buf);
80103773:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103776:	89 04 24             	mov    %eax,(%esp)
80103779:	e8 ae ca ff ff       	call   8010022c <brelse>
}
8010377e:	c9                   	leave  
8010377f:	c3                   	ret    

80103780 <recover_from_log>:

static void
recover_from_log(void)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	83 ec 08             	sub    $0x8,%esp
  read_head();
80103786:	e8 0b ff ff ff       	call   80103696 <read_head>
  install_trans(); // if committed, copy from log to disk
8010378b:	e8 58 fe ff ff       	call   801035e8 <install_trans>
  log.lh.n = 0;
80103790:	c7 05 88 47 11 80 00 	movl   $0x0,0x80114788
80103797:	00 00 00 
  write_head(); // clear the log
8010379a:	e8 66 ff ff ff       	call   80103705 <write_head>
}
8010379f:	c9                   	leave  
801037a0:	c3                   	ret    

801037a1 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801037a1:	55                   	push   %ebp
801037a2:	89 e5                	mov    %esp,%ebp
801037a4:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801037a7:	c7 04 24 40 47 11 80 	movl   $0x80114740,(%esp)
801037ae:	e8 ba 1e 00 00       	call   8010566d <acquire>
  while(1){
    if(log.committing){
801037b3:	a1 80 47 11 80       	mov    0x80114780,%eax
801037b8:	85 c0                	test   %eax,%eax
801037ba:	74 16                	je     801037d2 <begin_op+0x31>
      sleep(&log, &log.lock);
801037bc:	c7 44 24 04 40 47 11 	movl   $0x80114740,0x4(%esp)
801037c3:	80 
801037c4:	c7 04 24 40 47 11 80 	movl   $0x80114740,(%esp)
801037cb:	e8 c3 1a 00 00       	call   80105293 <sleep>
801037d0:	eb 4f                	jmp    80103821 <begin_op+0x80>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801037d2:	8b 0d 88 47 11 80    	mov    0x80114788,%ecx
801037d8:	a1 7c 47 11 80       	mov    0x8011477c,%eax
801037dd:	8d 50 01             	lea    0x1(%eax),%edx
801037e0:	89 d0                	mov    %edx,%eax
801037e2:	c1 e0 02             	shl    $0x2,%eax
801037e5:	01 d0                	add    %edx,%eax
801037e7:	01 c0                	add    %eax,%eax
801037e9:	01 c8                	add    %ecx,%eax
801037eb:	83 f8 1e             	cmp    $0x1e,%eax
801037ee:	7e 16                	jle    80103806 <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801037f0:	c7 44 24 04 40 47 11 	movl   $0x80114740,0x4(%esp)
801037f7:	80 
801037f8:	c7 04 24 40 47 11 80 	movl   $0x80114740,(%esp)
801037ff:	e8 8f 1a 00 00       	call   80105293 <sleep>
80103804:	eb 1b                	jmp    80103821 <begin_op+0x80>
    } else {
      log.outstanding += 1;
80103806:	a1 7c 47 11 80       	mov    0x8011477c,%eax
8010380b:	83 c0 01             	add    $0x1,%eax
8010380e:	a3 7c 47 11 80       	mov    %eax,0x8011477c
      release(&log.lock);
80103813:	c7 04 24 40 47 11 80 	movl   $0x80114740,(%esp)
8010381a:	e8 b5 1e 00 00       	call   801056d4 <release>
      break;
8010381f:	eb 02                	jmp    80103823 <begin_op+0x82>
    }
  }
80103821:	eb 90                	jmp    801037b3 <begin_op+0x12>
}
80103823:	c9                   	leave  
80103824:	c3                   	ret    

80103825 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103825:	55                   	push   %ebp
80103826:	89 e5                	mov    %esp,%ebp
80103828:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
8010382b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103832:	c7 04 24 40 47 11 80 	movl   $0x80114740,(%esp)
80103839:	e8 2f 1e 00 00       	call   8010566d <acquire>
  log.outstanding -= 1;
8010383e:	a1 7c 47 11 80       	mov    0x8011477c,%eax
80103843:	83 e8 01             	sub    $0x1,%eax
80103846:	a3 7c 47 11 80       	mov    %eax,0x8011477c
  if(log.committing)
8010384b:	a1 80 47 11 80       	mov    0x80114780,%eax
80103850:	85 c0                	test   %eax,%eax
80103852:	74 0c                	je     80103860 <end_op+0x3b>
    panic("log.committing");
80103854:	c7 04 24 98 91 10 80 	movl   $0x80109198,(%esp)
8010385b:	e8 02 cd ff ff       	call   80100562 <panic>
  if(log.outstanding == 0){
80103860:	a1 7c 47 11 80       	mov    0x8011477c,%eax
80103865:	85 c0                	test   %eax,%eax
80103867:	75 13                	jne    8010387c <end_op+0x57>
    do_commit = 1;
80103869:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103870:	c7 05 80 47 11 80 01 	movl   $0x1,0x80114780
80103877:	00 00 00 
8010387a:	eb 0c                	jmp    80103888 <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
8010387c:	c7 04 24 40 47 11 80 	movl   $0x80114740,(%esp)
80103883:	e8 e7 1a 00 00       	call   8010536f <wakeup>
  }
  release(&log.lock);
80103888:	c7 04 24 40 47 11 80 	movl   $0x80114740,(%esp)
8010388f:	e8 40 1e 00 00       	call   801056d4 <release>

  if(do_commit){
80103894:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103898:	74 33                	je     801038cd <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010389a:	e8 de 00 00 00       	call   8010397d <commit>
    acquire(&log.lock);
8010389f:	c7 04 24 40 47 11 80 	movl   $0x80114740,(%esp)
801038a6:	e8 c2 1d 00 00       	call   8010566d <acquire>
    log.committing = 0;
801038ab:	c7 05 80 47 11 80 00 	movl   $0x0,0x80114780
801038b2:	00 00 00 
    wakeup(&log);
801038b5:	c7 04 24 40 47 11 80 	movl   $0x80114740,(%esp)
801038bc:	e8 ae 1a 00 00       	call   8010536f <wakeup>
    release(&log.lock);
801038c1:	c7 04 24 40 47 11 80 	movl   $0x80114740,(%esp)
801038c8:	e8 07 1e 00 00       	call   801056d4 <release>
  }
}
801038cd:	c9                   	leave  
801038ce:	c3                   	ret    

801038cf <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
801038cf:	55                   	push   %ebp
801038d0:	89 e5                	mov    %esp,%ebp
801038d2:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801038d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801038dc:	e9 8c 00 00 00       	jmp    8010396d <write_log+0x9e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801038e1:	8b 15 74 47 11 80    	mov    0x80114774,%edx
801038e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038ea:	01 d0                	add    %edx,%eax
801038ec:	83 c0 01             	add    $0x1,%eax
801038ef:	89 c2                	mov    %eax,%edx
801038f1:	a1 84 47 11 80       	mov    0x80114784,%eax
801038f6:	89 54 24 04          	mov    %edx,0x4(%esp)
801038fa:	89 04 24             	mov    %eax,(%esp)
801038fd:	e8 b3 c8 ff ff       	call   801001b5 <bread>
80103902:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103905:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103908:	83 c0 10             	add    $0x10,%eax
8010390b:	8b 04 85 4c 47 11 80 	mov    -0x7feeb8b4(,%eax,4),%eax
80103912:	89 c2                	mov    %eax,%edx
80103914:	a1 84 47 11 80       	mov    0x80114784,%eax
80103919:	89 54 24 04          	mov    %edx,0x4(%esp)
8010391d:	89 04 24             	mov    %eax,(%esp)
80103920:	e8 90 c8 ff ff       	call   801001b5 <bread>
80103925:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103928:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010392b:	8d 50 5c             	lea    0x5c(%eax),%edx
8010392e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103931:	83 c0 5c             	add    $0x5c,%eax
80103934:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010393b:	00 
8010393c:	89 54 24 04          	mov    %edx,0x4(%esp)
80103940:	89 04 24             	mov    %eax,(%esp)
80103943:	e8 5d 20 00 00       	call   801059a5 <memmove>
    bwrite(to);  // write the log
80103948:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010394b:	89 04 24             	mov    %eax,(%esp)
8010394e:	e8 99 c8 ff ff       	call   801001ec <bwrite>
    brelse(from);
80103953:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103956:	89 04 24             	mov    %eax,(%esp)
80103959:	e8 ce c8 ff ff       	call   8010022c <brelse>
    brelse(to);
8010395e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103961:	89 04 24             	mov    %eax,(%esp)
80103964:	e8 c3 c8 ff ff       	call   8010022c <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103969:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010396d:	a1 88 47 11 80       	mov    0x80114788,%eax
80103972:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103975:	0f 8f 66 ff ff ff    	jg     801038e1 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from);
    brelse(to);
  }
}
8010397b:	c9                   	leave  
8010397c:	c3                   	ret    

8010397d <commit>:

static void
commit()
{
8010397d:	55                   	push   %ebp
8010397e:	89 e5                	mov    %esp,%ebp
80103980:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103983:	a1 88 47 11 80       	mov    0x80114788,%eax
80103988:	85 c0                	test   %eax,%eax
8010398a:	7e 1e                	jle    801039aa <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010398c:	e8 3e ff ff ff       	call   801038cf <write_log>
    write_head();    // Write header to disk -- the real commit
80103991:	e8 6f fd ff ff       	call   80103705 <write_head>
    install_trans(); // Now install writes to home locations
80103996:	e8 4d fc ff ff       	call   801035e8 <install_trans>
    log.lh.n = 0;
8010399b:	c7 05 88 47 11 80 00 	movl   $0x0,0x80114788
801039a2:	00 00 00 
    write_head();    // Erase the transaction from the log
801039a5:	e8 5b fd ff ff       	call   80103705 <write_head>
  }
}
801039aa:	c9                   	leave  
801039ab:	c3                   	ret    

801039ac <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801039ac:	55                   	push   %ebp
801039ad:	89 e5                	mov    %esp,%ebp
801039af:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801039b2:	a1 88 47 11 80       	mov    0x80114788,%eax
801039b7:	83 f8 1d             	cmp    $0x1d,%eax
801039ba:	7f 12                	jg     801039ce <log_write+0x22>
801039bc:	a1 88 47 11 80       	mov    0x80114788,%eax
801039c1:	8b 15 78 47 11 80    	mov    0x80114778,%edx
801039c7:	83 ea 01             	sub    $0x1,%edx
801039ca:	39 d0                	cmp    %edx,%eax
801039cc:	7c 0c                	jl     801039da <log_write+0x2e>
    panic("too big a transaction");
801039ce:	c7 04 24 a7 91 10 80 	movl   $0x801091a7,(%esp)
801039d5:	e8 88 cb ff ff       	call   80100562 <panic>
  if (log.outstanding < 1)
801039da:	a1 7c 47 11 80       	mov    0x8011477c,%eax
801039df:	85 c0                	test   %eax,%eax
801039e1:	7f 0c                	jg     801039ef <log_write+0x43>
    panic("log_write outside of trans");
801039e3:	c7 04 24 bd 91 10 80 	movl   $0x801091bd,(%esp)
801039ea:	e8 73 cb ff ff       	call   80100562 <panic>

  acquire(&log.lock);
801039ef:	c7 04 24 40 47 11 80 	movl   $0x80114740,(%esp)
801039f6:	e8 72 1c 00 00       	call   8010566d <acquire>
  for (i = 0; i < log.lh.n; i++) {
801039fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103a02:	eb 1f                	jmp    80103a23 <log_write+0x77>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a07:	83 c0 10             	add    $0x10,%eax
80103a0a:	8b 04 85 4c 47 11 80 	mov    -0x7feeb8b4(,%eax,4),%eax
80103a11:	89 c2                	mov    %eax,%edx
80103a13:	8b 45 08             	mov    0x8(%ebp),%eax
80103a16:	8b 40 08             	mov    0x8(%eax),%eax
80103a19:	39 c2                	cmp    %eax,%edx
80103a1b:	75 02                	jne    80103a1f <log_write+0x73>
      break;
80103a1d:	eb 0e                	jmp    80103a2d <log_write+0x81>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103a1f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a23:	a1 88 47 11 80       	mov    0x80114788,%eax
80103a28:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a2b:	7f d7                	jg     80103a04 <log_write+0x58>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80103a30:	8b 40 08             	mov    0x8(%eax),%eax
80103a33:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103a36:	83 c2 10             	add    $0x10,%edx
80103a39:	89 04 95 4c 47 11 80 	mov    %eax,-0x7feeb8b4(,%edx,4)
  if (i == log.lh.n)
80103a40:	a1 88 47 11 80       	mov    0x80114788,%eax
80103a45:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a48:	75 0d                	jne    80103a57 <log_write+0xab>
    log.lh.n++;
80103a4a:	a1 88 47 11 80       	mov    0x80114788,%eax
80103a4f:	83 c0 01             	add    $0x1,%eax
80103a52:	a3 88 47 11 80       	mov    %eax,0x80114788
  b->flags |= B_DIRTY; // prevent eviction
80103a57:	8b 45 08             	mov    0x8(%ebp),%eax
80103a5a:	8b 00                	mov    (%eax),%eax
80103a5c:	83 c8 04             	or     $0x4,%eax
80103a5f:	89 c2                	mov    %eax,%edx
80103a61:	8b 45 08             	mov    0x8(%ebp),%eax
80103a64:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103a66:	c7 04 24 40 47 11 80 	movl   $0x80114740,(%esp)
80103a6d:	e8 62 1c 00 00       	call   801056d4 <release>
}
80103a72:	c9                   	leave  
80103a73:	c3                   	ret    

80103a74 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103a74:	55                   	push   %ebp
80103a75:	89 e5                	mov    %esp,%ebp
80103a77:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103a7a:	8b 55 08             	mov    0x8(%ebp),%edx
80103a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a80:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103a83:	f0 87 02             	lock xchg %eax,(%edx)
80103a86:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103a89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103a8c:	c9                   	leave  
80103a8d:	c3                   	ret    

80103a8e <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103a8e:	55                   	push   %ebp
80103a8f:	89 e5                	mov    %esp,%ebp
80103a91:	83 e4 f0             	and    $0xfffffff0,%esp
80103a94:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103a97:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103a9e:	80 
80103a9f:	c7 04 24 c8 79 11 80 	movl   $0x801179c8,(%esp)
80103aa6:	e8 63 f2 ff ff       	call   80102d0e <kinit1>
  kvmalloc();      // kernel page table
80103aab:	e8 8d 4b 00 00       	call   8010863d <kvmalloc>
  mpinit();        // detect other processors
80103ab0:	e8 f1 03 00 00       	call   80103ea6 <mpinit>
  lapicinit();     // interrupt controller
80103ab5:	e8 bc f5 ff ff       	call   80103076 <lapicinit>
  seginit();       // segment descriptors
80103aba:	e8 39 45 00 00       	call   80107ff8 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80103abf:	e8 0b f7 ff ff       	call   801031cf <cpunum>
80103ac4:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ac8:	c7 04 24 d8 91 10 80 	movl   $0x801091d8,(%esp)
80103acf:	e8 f4 c8 ff ff       	call   801003c8 <cprintf>
  picinit();       // another interrupt controller
80103ad4:	e8 a8 05 00 00       	call   80104081 <picinit>
  ioapicinit();    // another interrupt controller
80103ad9:	e8 33 f1 ff ff       	call   80102c11 <ioapicinit>
  consoleinit();   // console hardware
80103ade:	e8 f5 cf ff ff       	call   80100ad8 <consoleinit>
  uartinit();      // serial port
80103ae3:	e8 79 38 00 00       	call   80107361 <uartinit>
  pinit();         // process table
80103ae8:	e8 9e 0a 00 00       	call   8010458b <pinit>
  tvinit();        // trap vectors
80103aed:	e8 63 33 00 00       	call   80106e55 <tvinit>
  binit();         // buffer cache
80103af2:	e8 3d c5 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103af7:	e8 82 d4 ff ff       	call   80100f7e <fileinit>
  ideinit();       // disk
80103afc:	e8 0e ed ff ff       	call   8010280f <ideinit>
  if(!ismp)
80103b01:	a1 24 48 11 80       	mov    0x80114824,%eax
80103b06:	85 c0                	test   %eax,%eax
80103b08:	75 05                	jne    80103b0f <main+0x81>
    timerinit();   // uniprocessor timer
80103b0a:	e8 91 32 00 00       	call   80106da0 <timerinit>
  startothers();   // start other processors
80103b0f:	e8 78 00 00 00       	call   80103b8c <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103b14:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103b1b:	8e 
80103b1c:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103b23:	e8 1e f2 ff ff       	call   80102d46 <kinit2>
  userinit();      // first user process
80103b28:	e8 7c 0b 00 00       	call   801046a9 <userinit>
  mpmain();        // finish this processor's setup
80103b2d:	e8 1a 00 00 00       	call   80103b4c <mpmain>

80103b32 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103b32:	55                   	push   %ebp
80103b33:	89 e5                	mov    %esp,%ebp
80103b35:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103b38:	e8 17 4b 00 00       	call   80108654 <switchkvm>
  seginit();
80103b3d:	e8 b6 44 00 00       	call   80107ff8 <seginit>
  lapicinit();
80103b42:	e8 2f f5 ff ff       	call   80103076 <lapicinit>
  mpmain();
80103b47:	e8 00 00 00 00       	call   80103b4c <mpmain>

80103b4c <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103b4c:	55                   	push   %ebp
80103b4d:	89 e5                	mov    %esp,%ebp
80103b4f:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpunum());
80103b52:	e8 78 f6 ff ff       	call   801031cf <cpunum>
80103b57:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b5b:	c7 04 24 ef 91 10 80 	movl   $0x801091ef,(%esp)
80103b62:	e8 61 c8 ff ff       	call   801003c8 <cprintf>
  idtinit();       // load idt register
80103b67:	e8 d9 34 00 00       	call   80107045 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103b6c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103b72:	05 a8 00 00 00       	add    $0xa8,%eax
80103b77:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80103b7e:	00 
80103b7f:	89 04 24             	mov    %eax,(%esp)
80103b82:	e8 ed fe ff ff       	call   80103a74 <xchg>
  scheduler();     // start running processes
80103b87:	e8 4c 15 00 00       	call   801050d8 <scheduler>

80103b8c <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103b8c:	55                   	push   %ebp
80103b8d:	89 e5                	mov    %esp,%ebp
80103b8f:	83 ec 28             	sub    $0x28,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103b92:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103b99:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103b9e:	89 44 24 08          	mov    %eax,0x8(%esp)
80103ba2:	c7 44 24 04 2c c5 10 	movl   $0x8010c52c,0x4(%esp)
80103ba9:	80 
80103baa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bad:	89 04 24             	mov    %eax,(%esp)
80103bb0:	e8 f0 1d 00 00       	call   801059a5 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103bb5:	c7 45 f4 40 48 11 80 	movl   $0x80114840,-0xc(%ebp)
80103bbc:	e9 81 00 00 00       	jmp    80103c42 <startothers+0xb6>
    if(c == cpus+cpunum())  // We've started already.
80103bc1:	e8 09 f6 ff ff       	call   801031cf <cpunum>
80103bc6:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103bcc:	05 40 48 11 80       	add    $0x80114840,%eax
80103bd1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103bd4:	75 02                	jne    80103bd8 <startothers+0x4c>
      continue;
80103bd6:	eb 63                	jmp    80103c3b <startothers+0xaf>

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103bd8:	e8 5c f2 ff ff       	call   80102e39 <kalloc>
80103bdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103be3:	83 e8 04             	sub    $0x4,%eax
80103be6:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103be9:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103bef:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bf4:	83 e8 08             	sub    $0x8,%eax
80103bf7:	c7 00 32 3b 10 80    	movl   $0x80103b32,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c00:	8d 50 f4             	lea    -0xc(%eax),%edx
80103c03:	b8 00 b0 10 80       	mov    $0x8010b000,%eax
80103c08:	05 00 00 00 80       	add    $0x80000000,%eax
80103c0d:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->apicid, V2P(code));
80103c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c12:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c1b:	0f b6 00             	movzbl (%eax),%eax
80103c1e:	0f b6 c0             	movzbl %al,%eax
80103c21:	89 54 24 04          	mov    %edx,0x4(%esp)
80103c25:	89 04 24             	mov    %eax,(%esp)
80103c28:	e8 68 f6 ff ff       	call   80103295 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103c2d:	90                   	nop
80103c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c31:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103c37:	85 c0                	test   %eax,%eax
80103c39:	74 f3                	je     80103c2e <startothers+0xa2>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103c3b:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103c42:	a1 20 4e 11 80       	mov    0x80114e20,%eax
80103c47:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103c4d:	05 40 48 11 80       	add    $0x80114840,%eax
80103c52:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103c55:	0f 87 66 ff ff ff    	ja     80103bc1 <startothers+0x35>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103c5b:	c9                   	leave  
80103c5c:	c3                   	ret    

80103c5d <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103c5d:	55                   	push   %ebp
80103c5e:	89 e5                	mov    %esp,%ebp
80103c60:	83 ec 14             	sub    $0x14,%esp
80103c63:	8b 45 08             	mov    0x8(%ebp),%eax
80103c66:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103c6a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103c6e:	89 c2                	mov    %eax,%edx
80103c70:	ec                   	in     (%dx),%al
80103c71:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103c74:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103c78:	c9                   	leave  
80103c79:	c3                   	ret    

80103c7a <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103c7a:	55                   	push   %ebp
80103c7b:	89 e5                	mov    %esp,%ebp
80103c7d:	83 ec 08             	sub    $0x8,%esp
80103c80:	8b 55 08             	mov    0x8(%ebp),%edx
80103c83:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c86:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103c8a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c8d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103c91:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103c95:	ee                   	out    %al,(%dx)
}
80103c96:	c9                   	leave  
80103c97:	c3                   	ret    

80103c98 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103c98:	55                   	push   %ebp
80103c99:	89 e5                	mov    %esp,%ebp
80103c9b:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103c9e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103ca5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103cac:	eb 15                	jmp    80103cc3 <sum+0x2b>
    sum += addr[i];
80103cae:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80103cb4:	01 d0                	add    %edx,%eax
80103cb6:	0f b6 00             	movzbl (%eax),%eax
80103cb9:	0f b6 c0             	movzbl %al,%eax
80103cbc:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103cbf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103cc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103cc6:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103cc9:	7c e3                	jl     80103cae <sum+0x16>
    sum += addr[i];
  return sum;
80103ccb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103cce:	c9                   	leave  
80103ccf:	c3                   	ret    

80103cd0 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103cd6:	8b 45 08             	mov    0x8(%ebp),%eax
80103cd9:	05 00 00 00 80       	add    $0x80000000,%eax
80103cde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103ce1:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ce7:	01 d0                	add    %edx,%eax
80103ce9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cf2:	eb 3f                	jmp    80103d33 <mpsearch1+0x63>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103cf4:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103cfb:	00 
80103cfc:	c7 44 24 04 00 92 10 	movl   $0x80109200,0x4(%esp)
80103d03:	80 
80103d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d07:	89 04 24             	mov    %eax,(%esp)
80103d0a:	e8 3e 1c 00 00       	call   8010594d <memcmp>
80103d0f:	85 c0                	test   %eax,%eax
80103d11:	75 1c                	jne    80103d2f <mpsearch1+0x5f>
80103d13:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103d1a:	00 
80103d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d1e:	89 04 24             	mov    %eax,(%esp)
80103d21:	e8 72 ff ff ff       	call   80103c98 <sum>
80103d26:	84 c0                	test   %al,%al
80103d28:	75 05                	jne    80103d2f <mpsearch1+0x5f>
      return (struct mp*)p;
80103d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d2d:	eb 11                	jmp    80103d40 <mpsearch1+0x70>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103d2f:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d36:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103d39:	72 b9                	jb     80103cf4 <mpsearch1+0x24>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103d3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103d40:	c9                   	leave  
80103d41:	c3                   	ret    

80103d42 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103d42:	55                   	push   %ebp
80103d43:	89 e5                	mov    %esp,%ebp
80103d45:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103d48:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d52:	83 c0 0f             	add    $0xf,%eax
80103d55:	0f b6 00             	movzbl (%eax),%eax
80103d58:	0f b6 c0             	movzbl %al,%eax
80103d5b:	c1 e0 08             	shl    $0x8,%eax
80103d5e:	89 c2                	mov    %eax,%edx
80103d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d63:	83 c0 0e             	add    $0xe,%eax
80103d66:	0f b6 00             	movzbl (%eax),%eax
80103d69:	0f b6 c0             	movzbl %al,%eax
80103d6c:	09 d0                	or     %edx,%eax
80103d6e:	c1 e0 04             	shl    $0x4,%eax
80103d71:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103d74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d78:	74 21                	je     80103d9b <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103d7a:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103d81:	00 
80103d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d85:	89 04 24             	mov    %eax,(%esp)
80103d88:	e8 43 ff ff ff       	call   80103cd0 <mpsearch1>
80103d8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d90:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d94:	74 50                	je     80103de6 <mpsearch+0xa4>
      return mp;
80103d96:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d99:	eb 5f                	jmp    80103dfa <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d9e:	83 c0 14             	add    $0x14,%eax
80103da1:	0f b6 00             	movzbl (%eax),%eax
80103da4:	0f b6 c0             	movzbl %al,%eax
80103da7:	c1 e0 08             	shl    $0x8,%eax
80103daa:	89 c2                	mov    %eax,%edx
80103dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103daf:	83 c0 13             	add    $0x13,%eax
80103db2:	0f b6 00             	movzbl (%eax),%eax
80103db5:	0f b6 c0             	movzbl %al,%eax
80103db8:	09 d0                	or     %edx,%eax
80103dba:	c1 e0 0a             	shl    $0xa,%eax
80103dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103dc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dc3:	2d 00 04 00 00       	sub    $0x400,%eax
80103dc8:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103dcf:	00 
80103dd0:	89 04 24             	mov    %eax,(%esp)
80103dd3:	e8 f8 fe ff ff       	call   80103cd0 <mpsearch1>
80103dd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ddb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103ddf:	74 05                	je     80103de6 <mpsearch+0xa4>
      return mp;
80103de1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103de4:	eb 14                	jmp    80103dfa <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103de6:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103ded:	00 
80103dee:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103df5:	e8 d6 fe ff ff       	call   80103cd0 <mpsearch1>
}
80103dfa:	c9                   	leave  
80103dfb:	c3                   	ret    

80103dfc <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103dfc:	55                   	push   %ebp
80103dfd:	89 e5                	mov    %esp,%ebp
80103dff:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103e02:	e8 3b ff ff ff       	call   80103d42 <mpsearch>
80103e07:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103e0e:	74 0a                	je     80103e1a <mpconfig+0x1e>
80103e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e13:	8b 40 04             	mov    0x4(%eax),%eax
80103e16:	85 c0                	test   %eax,%eax
80103e18:	75 0a                	jne    80103e24 <mpconfig+0x28>
    return 0;
80103e1a:	b8 00 00 00 00       	mov    $0x0,%eax
80103e1f:	e9 80 00 00 00       	jmp    80103ea4 <mpconfig+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e27:	8b 40 04             	mov    0x4(%eax),%eax
80103e2a:	05 00 00 00 80       	add    $0x80000000,%eax
80103e2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103e32:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103e39:	00 
80103e3a:	c7 44 24 04 05 92 10 	movl   $0x80109205,0x4(%esp)
80103e41:	80 
80103e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e45:	89 04 24             	mov    %eax,(%esp)
80103e48:	e8 00 1b 00 00       	call   8010594d <memcmp>
80103e4d:	85 c0                	test   %eax,%eax
80103e4f:	74 07                	je     80103e58 <mpconfig+0x5c>
    return 0;
80103e51:	b8 00 00 00 00       	mov    $0x0,%eax
80103e56:	eb 4c                	jmp    80103ea4 <mpconfig+0xa8>
  if(conf->version != 1 && conf->version != 4)
80103e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e5b:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103e5f:	3c 01                	cmp    $0x1,%al
80103e61:	74 12                	je     80103e75 <mpconfig+0x79>
80103e63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e66:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103e6a:	3c 04                	cmp    $0x4,%al
80103e6c:	74 07                	je     80103e75 <mpconfig+0x79>
    return 0;
80103e6e:	b8 00 00 00 00       	mov    $0x0,%eax
80103e73:	eb 2f                	jmp    80103ea4 <mpconfig+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e78:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103e7c:	0f b7 c0             	movzwl %ax,%eax
80103e7f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e86:	89 04 24             	mov    %eax,(%esp)
80103e89:	e8 0a fe ff ff       	call   80103c98 <sum>
80103e8e:	84 c0                	test   %al,%al
80103e90:	74 07                	je     80103e99 <mpconfig+0x9d>
    return 0;
80103e92:	b8 00 00 00 00       	mov    $0x0,%eax
80103e97:	eb 0b                	jmp    80103ea4 <mpconfig+0xa8>
  *pmp = mp;
80103e99:	8b 45 08             	mov    0x8(%ebp),%eax
80103e9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e9f:	89 10                	mov    %edx,(%eax)
  return conf;
80103ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103ea4:	c9                   	leave  
80103ea5:	c3                   	ret    

80103ea6 <mpinit>:

void
mpinit(void)
{
80103ea6:	55                   	push   %ebp
80103ea7:	89 e5                	mov    %esp,%ebp
80103ea9:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103eac:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103eaf:	89 04 24             	mov    %eax,(%esp)
80103eb2:	e8 45 ff ff ff       	call   80103dfc <mpconfig>
80103eb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103eba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103ebe:	75 05                	jne    80103ec5 <mpinit+0x1f>
    return;
80103ec0:	e9 23 01 00 00       	jmp    80103fe8 <mpinit+0x142>
  ismp = 1;
80103ec5:	c7 05 24 48 11 80 01 	movl   $0x1,0x80114824
80103ecc:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ed2:	8b 40 24             	mov    0x24(%eax),%eax
80103ed5:	a3 3c 47 11 80       	mov    %eax,0x8011473c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103edd:	83 c0 2c             	add    $0x2c,%eax
80103ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ee6:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103eea:	0f b7 d0             	movzwl %ax,%edx
80103eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ef0:	01 d0                	add    %edx,%eax
80103ef2:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ef5:	eb 7e                	jmp    80103f75 <mpinit+0xcf>
    switch(*p){
80103ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103efa:	0f b6 00             	movzbl (%eax),%eax
80103efd:	0f b6 c0             	movzbl %al,%eax
80103f00:	83 f8 04             	cmp    $0x4,%eax
80103f03:	77 65                	ja     80103f6a <mpinit+0xc4>
80103f05:	8b 04 85 0c 92 10 80 	mov    -0x7fef6df4(,%eax,4),%eax
80103f0c:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f11:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu < NCPU) {
80103f14:	a1 20 4e 11 80       	mov    0x80114e20,%eax
80103f19:	83 f8 07             	cmp    $0x7,%eax
80103f1c:	7f 28                	jg     80103f46 <mpinit+0xa0>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103f1e:	8b 15 20 4e 11 80    	mov    0x80114e20,%edx
80103f24:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103f27:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103f2b:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103f31:	81 c2 40 48 11 80    	add    $0x80114840,%edx
80103f37:	88 02                	mov    %al,(%edx)
        ncpu++;
80103f39:	a1 20 4e 11 80       	mov    0x80114e20,%eax
80103f3e:	83 c0 01             	add    $0x1,%eax
80103f41:	a3 20 4e 11 80       	mov    %eax,0x80114e20
      }
      p += sizeof(struct mpproc);
80103f46:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103f4a:	eb 29                	jmp    80103f75 <mpinit+0xcf>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103f52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103f55:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103f59:	a2 20 48 11 80       	mov    %al,0x80114820
      p += sizeof(struct mpioapic);
80103f5e:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103f62:	eb 11                	jmp    80103f75 <mpinit+0xcf>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103f64:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103f68:	eb 0b                	jmp    80103f75 <mpinit+0xcf>
    default:
      ismp = 0;
80103f6a:	c7 05 24 48 11 80 00 	movl   $0x0,0x80114824
80103f71:	00 00 00 
      break;
80103f74:	90                   	nop

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f78:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103f7b:	0f 82 76 ff ff ff    	jb     80103ef7 <mpinit+0x51>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
80103f81:	a1 24 48 11 80       	mov    0x80114824,%eax
80103f86:	85 c0                	test   %eax,%eax
80103f88:	75 1d                	jne    80103fa7 <mpinit+0x101>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103f8a:	c7 05 20 4e 11 80 01 	movl   $0x1,0x80114e20
80103f91:	00 00 00 
    lapic = 0;
80103f94:	c7 05 3c 47 11 80 00 	movl   $0x0,0x8011473c
80103f9b:	00 00 00 
    ioapicid = 0;
80103f9e:	c6 05 20 48 11 80 00 	movb   $0x0,0x80114820
    return;
80103fa5:	eb 41                	jmp    80103fe8 <mpinit+0x142>
  }

  if(mp->imcrp){
80103fa7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103faa:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103fae:	84 c0                	test   %al,%al
80103fb0:	74 36                	je     80103fe8 <mpinit+0x142>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103fb2:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103fb9:	00 
80103fba:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103fc1:	e8 b4 fc ff ff       	call   80103c7a <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103fc6:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103fcd:	e8 8b fc ff ff       	call   80103c5d <inb>
80103fd2:	83 c8 01             	or     $0x1,%eax
80103fd5:	0f b6 c0             	movzbl %al,%eax
80103fd8:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fdc:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103fe3:	e8 92 fc ff ff       	call   80103c7a <outb>
  }
}
80103fe8:	c9                   	leave  
80103fe9:	c3                   	ret    

80103fea <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103fea:	55                   	push   %ebp
80103feb:	89 e5                	mov    %esp,%ebp
80103fed:	83 ec 08             	sub    $0x8,%esp
80103ff0:	8b 55 08             	mov    0x8(%ebp),%edx
80103ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ff6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103ffa:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ffd:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80104001:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80104005:	ee                   	out    %al,(%dx)
}
80104006:	c9                   	leave  
80104007:	c3                   	ret    

80104008 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80104008:	55                   	push   %ebp
80104009:	89 e5                	mov    %esp,%ebp
8010400b:	83 ec 0c             	sub    $0xc,%esp
8010400e:	8b 45 08             	mov    0x8(%ebp),%eax
80104011:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80104015:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80104019:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
8010401f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80104023:	0f b6 c0             	movzbl %al,%eax
80104026:	89 44 24 04          	mov    %eax,0x4(%esp)
8010402a:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80104031:	e8 b4 ff ff ff       	call   80103fea <outb>
  outb(IO_PIC2+1, mask >> 8);
80104036:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010403a:	66 c1 e8 08          	shr    $0x8,%ax
8010403e:	0f b6 c0             	movzbl %al,%eax
80104041:	89 44 24 04          	mov    %eax,0x4(%esp)
80104045:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
8010404c:	e8 99 ff ff ff       	call   80103fea <outb>
}
80104051:	c9                   	leave  
80104052:	c3                   	ret    

80104053 <picenable>:

void
picenable(int irq)
{
80104053:	55                   	push   %ebp
80104054:	89 e5                	mov    %esp,%ebp
80104056:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80104059:	8b 45 08             	mov    0x8(%ebp),%eax
8010405c:	ba 01 00 00 00       	mov    $0x1,%edx
80104061:	89 c1                	mov    %eax,%ecx
80104063:	d3 e2                	shl    %cl,%edx
80104065:	89 d0                	mov    %edx,%eax
80104067:	f7 d0                	not    %eax
80104069:	89 c2                	mov    %eax,%edx
8010406b:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80104072:	21 d0                	and    %edx,%eax
80104074:	0f b7 c0             	movzwl %ax,%eax
80104077:	89 04 24             	mov    %eax,(%esp)
8010407a:	e8 89 ff ff ff       	call   80104008 <picsetmask>
}
8010407f:	c9                   	leave  
80104080:	c3                   	ret    

80104081 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80104081:	55                   	push   %ebp
80104082:	89 e5                	mov    %esp,%ebp
80104084:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80104087:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
8010408e:	00 
8010408f:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80104096:	e8 4f ff ff ff       	call   80103fea <outb>
  outb(IO_PIC2+1, 0xFF);
8010409b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
801040a2:	00 
801040a3:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
801040aa:	e8 3b ff ff ff       	call   80103fea <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
801040af:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
801040b6:	00 
801040b7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801040be:	e8 27 ff ff ff       	call   80103fea <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
801040c3:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801040ca:	00 
801040cb:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
801040d2:	e8 13 ff ff ff       	call   80103fea <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
801040d7:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
801040de:	00 
801040df:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
801040e6:	e8 ff fe ff ff       	call   80103fea <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
801040eb:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801040f2:	00 
801040f3:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
801040fa:	e8 eb fe ff ff       	call   80103fea <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
801040ff:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80104106:	00 
80104107:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
8010410e:	e8 d7 fe ff ff       	call   80103fea <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80104113:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
8010411a:	00 
8010411b:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80104122:	e8 c3 fe ff ff       	call   80103fea <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80104127:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
8010412e:	00 
8010412f:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80104136:	e8 af fe ff ff       	call   80103fea <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
8010413b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80104142:	00 
80104143:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
8010414a:	e8 9b fe ff ff       	call   80103fea <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
8010414f:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80104156:	00 
80104157:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010415e:	e8 87 fe ff ff       	call   80103fea <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80104163:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
8010416a:	00 
8010416b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80104172:	e8 73 fe ff ff       	call   80103fea <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80104177:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
8010417e:	00 
8010417f:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80104186:	e8 5f fe ff ff       	call   80103fea <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
8010418b:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80104192:	00 
80104193:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
8010419a:	e8 4b fe ff ff       	call   80103fea <outb>

  if(irqmask != 0xFFFF)
8010419f:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
801041a6:	66 83 f8 ff          	cmp    $0xffff,%ax
801041aa:	74 12                	je     801041be <picinit+0x13d>
    picsetmask(irqmask);
801041ac:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
801041b3:	0f b7 c0             	movzwl %ax,%eax
801041b6:	89 04 24             	mov    %eax,(%esp)
801041b9:	e8 4a fe ff ff       	call   80104008 <picsetmask>
}
801041be:	c9                   	leave  
801041bf:	c3                   	ret    

801041c0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
801041c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
801041cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801041d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801041d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801041d9:	8b 10                	mov    (%eax),%edx
801041db:	8b 45 08             	mov    0x8(%ebp),%eax
801041de:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801041e0:	e8 b5 cd ff ff       	call   80100f9a <filealloc>
801041e5:	8b 55 08             	mov    0x8(%ebp),%edx
801041e8:	89 02                	mov    %eax,(%edx)
801041ea:	8b 45 08             	mov    0x8(%ebp),%eax
801041ed:	8b 00                	mov    (%eax),%eax
801041ef:	85 c0                	test   %eax,%eax
801041f1:	0f 84 c8 00 00 00    	je     801042bf <pipealloc+0xff>
801041f7:	e8 9e cd ff ff       	call   80100f9a <filealloc>
801041fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801041ff:	89 02                	mov    %eax,(%edx)
80104201:	8b 45 0c             	mov    0xc(%ebp),%eax
80104204:	8b 00                	mov    (%eax),%eax
80104206:	85 c0                	test   %eax,%eax
80104208:	0f 84 b1 00 00 00    	je     801042bf <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010420e:	e8 26 ec ff ff       	call   80102e39 <kalloc>
80104213:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104216:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010421a:	75 05                	jne    80104221 <pipealloc+0x61>
    goto bad;
8010421c:	e9 9e 00 00 00       	jmp    801042bf <pipealloc+0xff>
  p->readopen = 1;
80104221:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104224:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010422b:	00 00 00 
  p->writeopen = 1;
8010422e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104231:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104238:	00 00 00 
  p->nwrite = 0;
8010423b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010423e:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104245:	00 00 00 
  p->nread = 0;
80104248:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010424b:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104252:	00 00 00 
  initlock(&p->lock, "pipe");
80104255:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104258:	c7 44 24 04 20 92 10 	movl   $0x80109220,0x4(%esp)
8010425f:	80 
80104260:	89 04 24             	mov    %eax,(%esp)
80104263:	e8 e4 13 00 00       	call   8010564c <initlock>
  (*f0)->type = FD_PIPE;
80104268:	8b 45 08             	mov    0x8(%ebp),%eax
8010426b:	8b 00                	mov    (%eax),%eax
8010426d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104273:	8b 45 08             	mov    0x8(%ebp),%eax
80104276:	8b 00                	mov    (%eax),%eax
80104278:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010427c:	8b 45 08             	mov    0x8(%ebp),%eax
8010427f:	8b 00                	mov    (%eax),%eax
80104281:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104285:	8b 45 08             	mov    0x8(%ebp),%eax
80104288:	8b 00                	mov    (%eax),%eax
8010428a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010428d:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104290:	8b 45 0c             	mov    0xc(%ebp),%eax
80104293:	8b 00                	mov    (%eax),%eax
80104295:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010429b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010429e:	8b 00                	mov    (%eax),%eax
801042a0:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801042a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801042a7:	8b 00                	mov    (%eax),%eax
801042a9:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801042ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801042b0:	8b 00                	mov    (%eax),%eax
801042b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042b5:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801042b8:	b8 00 00 00 00       	mov    $0x0,%eax
801042bd:	eb 42                	jmp    80104301 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
801042bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801042c3:	74 0b                	je     801042d0 <pipealloc+0x110>
    kfree((char*)p);
801042c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c8:	89 04 24             	mov    %eax,(%esp)
801042cb:	e8 d3 ea ff ff       	call   80102da3 <kfree>
  if(*f0)
801042d0:	8b 45 08             	mov    0x8(%ebp),%eax
801042d3:	8b 00                	mov    (%eax),%eax
801042d5:	85 c0                	test   %eax,%eax
801042d7:	74 0d                	je     801042e6 <pipealloc+0x126>
    fileclose(*f0);
801042d9:	8b 45 08             	mov    0x8(%ebp),%eax
801042dc:	8b 00                	mov    (%eax),%eax
801042de:	89 04 24             	mov    %eax,(%esp)
801042e1:	e8 5c cd ff ff       	call   80101042 <fileclose>
  if(*f1)
801042e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801042e9:	8b 00                	mov    (%eax),%eax
801042eb:	85 c0                	test   %eax,%eax
801042ed:	74 0d                	je     801042fc <pipealloc+0x13c>
    fileclose(*f1);
801042ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801042f2:	8b 00                	mov    (%eax),%eax
801042f4:	89 04 24             	mov    %eax,(%esp)
801042f7:	e8 46 cd ff ff       	call   80101042 <fileclose>
  return -1;
801042fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104301:	c9                   	leave  
80104302:	c3                   	ret    

80104303 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104303:	55                   	push   %ebp
80104304:	89 e5                	mov    %esp,%ebp
80104306:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80104309:	8b 45 08             	mov    0x8(%ebp),%eax
8010430c:	89 04 24             	mov    %eax,(%esp)
8010430f:	e8 59 13 00 00       	call   8010566d <acquire>
  if(writable){
80104314:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104318:	74 1f                	je     80104339 <pipeclose+0x36>
    p->writeopen = 0;
8010431a:	8b 45 08             	mov    0x8(%ebp),%eax
8010431d:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104324:	00 00 00 
    wakeup(&p->nread);
80104327:	8b 45 08             	mov    0x8(%ebp),%eax
8010432a:	05 34 02 00 00       	add    $0x234,%eax
8010432f:	89 04 24             	mov    %eax,(%esp)
80104332:	e8 38 10 00 00       	call   8010536f <wakeup>
80104337:	eb 1d                	jmp    80104356 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80104339:	8b 45 08             	mov    0x8(%ebp),%eax
8010433c:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104343:	00 00 00 
    wakeup(&p->nwrite);
80104346:	8b 45 08             	mov    0x8(%ebp),%eax
80104349:	05 38 02 00 00       	add    $0x238,%eax
8010434e:	89 04 24             	mov    %eax,(%esp)
80104351:	e8 19 10 00 00       	call   8010536f <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104356:	8b 45 08             	mov    0x8(%ebp),%eax
80104359:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010435f:	85 c0                	test   %eax,%eax
80104361:	75 25                	jne    80104388 <pipeclose+0x85>
80104363:	8b 45 08             	mov    0x8(%ebp),%eax
80104366:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010436c:	85 c0                	test   %eax,%eax
8010436e:	75 18                	jne    80104388 <pipeclose+0x85>
    release(&p->lock);
80104370:	8b 45 08             	mov    0x8(%ebp),%eax
80104373:	89 04 24             	mov    %eax,(%esp)
80104376:	e8 59 13 00 00       	call   801056d4 <release>
    kfree((char*)p);
8010437b:	8b 45 08             	mov    0x8(%ebp),%eax
8010437e:	89 04 24             	mov    %eax,(%esp)
80104381:	e8 1d ea ff ff       	call   80102da3 <kfree>
80104386:	eb 0b                	jmp    80104393 <pipeclose+0x90>
  } else
    release(&p->lock);
80104388:	8b 45 08             	mov    0x8(%ebp),%eax
8010438b:	89 04 24             	mov    %eax,(%esp)
8010438e:	e8 41 13 00 00       	call   801056d4 <release>
}
80104393:	c9                   	leave  
80104394:	c3                   	ret    

80104395 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104395:	55                   	push   %ebp
80104396:	89 e5                	mov    %esp,%ebp
80104398:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
8010439b:	8b 45 08             	mov    0x8(%ebp),%eax
8010439e:	89 04 24             	mov    %eax,(%esp)
801043a1:	e8 c7 12 00 00       	call   8010566d <acquire>
  for(i = 0; i < n; i++){
801043a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801043ad:	e9 a6 00 00 00       	jmp    80104458 <pipewrite+0xc3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801043b2:	eb 57                	jmp    8010440b <pipewrite+0x76>
      if(p->readopen == 0 || proc->killed){
801043b4:	8b 45 08             	mov    0x8(%ebp),%eax
801043b7:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801043bd:	85 c0                	test   %eax,%eax
801043bf:	74 0d                	je     801043ce <pipewrite+0x39>
801043c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043c7:	8b 40 24             	mov    0x24(%eax),%eax
801043ca:	85 c0                	test   %eax,%eax
801043cc:	74 15                	je     801043e3 <pipewrite+0x4e>
        release(&p->lock);
801043ce:	8b 45 08             	mov    0x8(%ebp),%eax
801043d1:	89 04 24             	mov    %eax,(%esp)
801043d4:	e8 fb 12 00 00       	call   801056d4 <release>
        return -1;
801043d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043de:	e9 9f 00 00 00       	jmp    80104482 <pipewrite+0xed>
      }
      wakeup(&p->nread);
801043e3:	8b 45 08             	mov    0x8(%ebp),%eax
801043e6:	05 34 02 00 00       	add    $0x234,%eax
801043eb:	89 04 24             	mov    %eax,(%esp)
801043ee:	e8 7c 0f 00 00       	call   8010536f <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801043f3:	8b 45 08             	mov    0x8(%ebp),%eax
801043f6:	8b 55 08             	mov    0x8(%ebp),%edx
801043f9:	81 c2 38 02 00 00    	add    $0x238,%edx
801043ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80104403:	89 14 24             	mov    %edx,(%esp)
80104406:	e8 88 0e 00 00       	call   80105293 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010440b:	8b 45 08             	mov    0x8(%ebp),%eax
8010440e:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104414:	8b 45 08             	mov    0x8(%ebp),%eax
80104417:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010441d:	05 00 02 00 00       	add    $0x200,%eax
80104422:	39 c2                	cmp    %eax,%edx
80104424:	74 8e                	je     801043b4 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104426:	8b 45 08             	mov    0x8(%ebp),%eax
80104429:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010442f:	8d 48 01             	lea    0x1(%eax),%ecx
80104432:	8b 55 08             	mov    0x8(%ebp),%edx
80104435:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
8010443b:	25 ff 01 00 00       	and    $0x1ff,%eax
80104440:	89 c1                	mov    %eax,%ecx
80104442:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104445:	8b 45 0c             	mov    0xc(%ebp),%eax
80104448:	01 d0                	add    %edx,%eax
8010444a:	0f b6 10             	movzbl (%eax),%edx
8010444d:	8b 45 08             	mov    0x8(%ebp),%eax
80104450:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104454:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104458:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010445b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010445e:	0f 8c 4e ff ff ff    	jl     801043b2 <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104464:	8b 45 08             	mov    0x8(%ebp),%eax
80104467:	05 34 02 00 00       	add    $0x234,%eax
8010446c:	89 04 24             	mov    %eax,(%esp)
8010446f:	e8 fb 0e 00 00       	call   8010536f <wakeup>
  release(&p->lock);
80104474:	8b 45 08             	mov    0x8(%ebp),%eax
80104477:	89 04 24             	mov    %eax,(%esp)
8010447a:	e8 55 12 00 00       	call   801056d4 <release>
  return n;
8010447f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104482:	c9                   	leave  
80104483:	c3                   	ret    

80104484 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104484:	55                   	push   %ebp
80104485:	89 e5                	mov    %esp,%ebp
80104487:	53                   	push   %ebx
80104488:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
8010448b:	8b 45 08             	mov    0x8(%ebp),%eax
8010448e:	89 04 24             	mov    %eax,(%esp)
80104491:	e8 d7 11 00 00       	call   8010566d <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104496:	eb 3a                	jmp    801044d2 <piperead+0x4e>
    if(proc->killed){
80104498:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010449e:	8b 40 24             	mov    0x24(%eax),%eax
801044a1:	85 c0                	test   %eax,%eax
801044a3:	74 15                	je     801044ba <piperead+0x36>
      release(&p->lock);
801044a5:	8b 45 08             	mov    0x8(%ebp),%eax
801044a8:	89 04 24             	mov    %eax,(%esp)
801044ab:	e8 24 12 00 00       	call   801056d4 <release>
      return -1;
801044b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044b5:	e9 b5 00 00 00       	jmp    8010456f <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801044ba:	8b 45 08             	mov    0x8(%ebp),%eax
801044bd:	8b 55 08             	mov    0x8(%ebp),%edx
801044c0:	81 c2 34 02 00 00    	add    $0x234,%edx
801044c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801044ca:	89 14 24             	mov    %edx,(%esp)
801044cd:	e8 c1 0d 00 00       	call   80105293 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801044d2:	8b 45 08             	mov    0x8(%ebp),%eax
801044d5:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801044db:	8b 45 08             	mov    0x8(%ebp),%eax
801044de:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801044e4:	39 c2                	cmp    %eax,%edx
801044e6:	75 0d                	jne    801044f5 <piperead+0x71>
801044e8:	8b 45 08             	mov    0x8(%ebp),%eax
801044eb:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801044f1:	85 c0                	test   %eax,%eax
801044f3:	75 a3                	jne    80104498 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801044f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801044fc:	eb 4b                	jmp    80104549 <piperead+0xc5>
    if(p->nread == p->nwrite)
801044fe:	8b 45 08             	mov    0x8(%ebp),%eax
80104501:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104507:	8b 45 08             	mov    0x8(%ebp),%eax
8010450a:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104510:	39 c2                	cmp    %eax,%edx
80104512:	75 02                	jne    80104516 <piperead+0x92>
      break;
80104514:	eb 3b                	jmp    80104551 <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104516:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104519:	8b 45 0c             	mov    0xc(%ebp),%eax
8010451c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010451f:	8b 45 08             	mov    0x8(%ebp),%eax
80104522:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104528:	8d 48 01             	lea    0x1(%eax),%ecx
8010452b:	8b 55 08             	mov    0x8(%ebp),%edx
8010452e:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104534:	25 ff 01 00 00       	and    $0x1ff,%eax
80104539:	89 c2                	mov    %eax,%edx
8010453b:	8b 45 08             	mov    0x8(%ebp),%eax
8010453e:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104543:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104545:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104549:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010454c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010454f:	7c ad                	jl     801044fe <piperead+0x7a>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104551:	8b 45 08             	mov    0x8(%ebp),%eax
80104554:	05 38 02 00 00       	add    $0x238,%eax
80104559:	89 04 24             	mov    %eax,(%esp)
8010455c:	e8 0e 0e 00 00       	call   8010536f <wakeup>
  release(&p->lock);
80104561:	8b 45 08             	mov    0x8(%ebp),%eax
80104564:	89 04 24             	mov    %eax,(%esp)
80104567:	e8 68 11 00 00       	call   801056d4 <release>
  return i;
8010456c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010456f:	83 c4 24             	add    $0x24,%esp
80104572:	5b                   	pop    %ebx
80104573:	5d                   	pop    %ebp
80104574:	c3                   	ret    

80104575 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104575:	55                   	push   %ebp
80104576:	89 e5                	mov    %esp,%ebp
80104578:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010457b:	9c                   	pushf  
8010457c:	58                   	pop    %eax
8010457d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104580:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104583:	c9                   	leave  
80104584:	c3                   	ret    

80104585 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104585:	55                   	push   %ebp
80104586:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104588:	fb                   	sti    
}
80104589:	5d                   	pop    %ebp
8010458a:	c3                   	ret    

8010458b <pinit>:
static void wakeup1(void *chan);


void
pinit(void)
{
8010458b:	55                   	push   %ebp
8010458c:	89 e5                	mov    %esp,%ebp
8010458e:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80104591:	c7 44 24 04 25 92 10 	movl   $0x80109225,0x4(%esp)
80104598:	80 
80104599:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
801045a0:	e8 a7 10 00 00       	call   8010564c <initlock>
}
801045a5:	c9                   	leave  
801045a6:	c3                   	ret    

801045a7 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801045a7:	55                   	push   %ebp
801045a8:	89 e5                	mov    %esp,%ebp
801045aa:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801045ad:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
801045b4:	e8 b4 10 00 00       	call   8010566d <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045b9:	c7 45 f4 74 4e 11 80 	movl   $0x80114e74,-0xc(%ebp)
801045c0:	eb 53                	jmp    80104615 <allocproc+0x6e>
    if(p->state == UNUSED)
801045c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c5:	8b 40 0c             	mov    0xc(%eax),%eax
801045c8:	85 c0                	test   %eax,%eax
801045ca:	75 42                	jne    8010460e <allocproc+0x67>
      goto found;
801045cc:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801045cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d0:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801045d7:	a1 04 c0 10 80       	mov    0x8010c004,%eax
801045dc:	8d 50 01             	lea    0x1(%eax),%edx
801045df:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
801045e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045e8:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
801045eb:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
801045f2:	e8 dd 10 00 00       	call   801056d4 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801045f7:	e8 3d e8 ff ff       	call   80102e39 <kalloc>
801045fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045ff:	89 42 08             	mov    %eax,0x8(%edx)
80104602:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104605:	8b 40 08             	mov    0x8(%eax),%eax
80104608:	85 c0                	test   %eax,%eax
8010460a:	75 36                	jne    80104642 <allocproc+0x9b>
8010460c:	eb 23                	jmp    80104631 <allocproc+0x8a>
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010460e:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104615:	81 7d f4 74 71 11 80 	cmpl   $0x80117174,-0xc(%ebp)
8010461c:	72 a4                	jb     801045c2 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
8010461e:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80104625:	e8 aa 10 00 00       	call   801056d4 <release>
  return 0;
8010462a:	b8 00 00 00 00       	mov    $0x0,%eax
8010462f:	eb 76                	jmp    801046a7 <allocproc+0x100>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80104631:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104634:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
8010463b:	b8 00 00 00 00       	mov    $0x0,%eax
80104640:	eb 65                	jmp    801046a7 <allocproc+0x100>
  }
  sp = p->kstack + KSTACKSIZE;
80104642:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104645:	8b 40 08             	mov    0x8(%eax),%eax
80104648:	05 00 10 00 00       	add    $0x1000,%eax
8010464d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104650:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104654:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104657:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010465a:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
8010465d:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104661:	ba 10 6e 10 80       	mov    $0x80106e10,%edx
80104666:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104669:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010466b:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
8010466f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104672:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104675:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104678:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010467b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010467e:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104685:	00 
80104686:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010468d:	00 
8010468e:	89 04 24             	mov    %eax,(%esp)
80104691:	e8 40 12 00 00       	call   801058d6 <memset>
  p->context->eip = (uint)forkret;
80104696:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104699:	8b 40 1c             	mov    0x1c(%eax),%eax
8010469c:	ba 54 52 10 80       	mov    $0x80105254,%edx
801046a1:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801046a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801046a7:	c9                   	leave  
801046a8:	c3                   	ret    

801046a9 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801046a9:	55                   	push   %ebp
801046aa:	89 e5                	mov    %esp,%ebp
801046ac:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801046af:	e8 f3 fe ff ff       	call   801045a7 <allocproc>
801046b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
801046b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ba:	a3 64 c6 10 80       	mov    %eax,0x8010c664
  if((p->pgdir = setupkvm()) == 0)
801046bf:	e8 de 3e 00 00       	call   801085a2 <setupkvm>
801046c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046c7:	89 42 04             	mov    %eax,0x4(%edx)
801046ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046cd:	8b 40 04             	mov    0x4(%eax),%eax
801046d0:	85 c0                	test   %eax,%eax
801046d2:	75 0c                	jne    801046e0 <userinit+0x37>
    panic("userinit: out of memory?");
801046d4:	c7 04 24 2c 92 10 80 	movl   $0x8010922c,(%esp)
801046db:	e8 82 be ff ff       	call   80100562 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801046e0:	ba 2c 00 00 00       	mov    $0x2c,%edx
801046e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e8:	8b 40 04             	mov    0x4(%eax),%eax
801046eb:	89 54 24 08          	mov    %edx,0x8(%esp)
801046ef:	c7 44 24 04 00 c5 10 	movl   $0x8010c500,0x4(%esp)
801046f6:	80 
801046f7:	89 04 24             	mov    %eax,(%esp)
801046fa:	e8 03 41 00 00       	call   80108802 <inituvm>
  p->sz = PGSIZE;
801046ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104702:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104708:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010470b:	8b 40 18             	mov    0x18(%eax),%eax
8010470e:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104715:	00 
80104716:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010471d:	00 
8010471e:	89 04 24             	mov    %eax,(%esp)
80104721:	e8 b0 11 00 00       	call   801058d6 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104726:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104729:	8b 40 18             	mov    0x18(%eax),%eax
8010472c:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104732:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104735:	8b 40 18             	mov    0x18(%eax),%eax
80104738:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010473e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104741:	8b 40 18             	mov    0x18(%eax),%eax
80104744:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104747:	8b 52 18             	mov    0x18(%edx),%edx
8010474a:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010474e:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104752:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104755:	8b 40 18             	mov    0x18(%eax),%eax
80104758:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010475b:	8b 52 18             	mov    0x18(%edx),%edx
8010475e:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104762:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104766:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104769:	8b 40 18             	mov    0x18(%eax),%eax
8010476c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104776:	8b 40 18             	mov    0x18(%eax),%eax
80104779:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104783:	8b 40 18             	mov    0x18(%eax),%eax
80104786:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010478d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104790:	83 c0 6c             	add    $0x6c,%eax
80104793:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010479a:	00 
8010479b:	c7 44 24 04 45 92 10 	movl   $0x80109245,0x4(%esp)
801047a2:	80 
801047a3:	89 04 24             	mov    %eax,(%esp)
801047a6:	e8 4b 13 00 00       	call   80105af6 <safestrcpy>
  p->cwd = namei("/");
801047ab:	c7 04 24 4e 92 10 80 	movl   $0x8010924e,(%esp)
801047b2:	e8 4b df ff ff       	call   80102702 <namei>
801047b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047ba:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801047bd:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
801047c4:	e8 a4 0e 00 00       	call   8010566d <acquire>

  p->state = RUNNABLE;
801047c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047cc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
801047d3:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
801047da:	e8 f5 0e 00 00       	call   801056d4 <release>
}
801047df:	c9                   	leave  
801047e0:	c3                   	ret    

801047e1 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801047e1:	55                   	push   %ebp
801047e2:	89 e5                	mov    %esp,%ebp
801047e4:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  struct proc *p;
  sz = proc->sz;
801047e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ed:	8b 00                	mov    (%eax),%eax
801047ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801047f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801047f6:	7e 37                	jle    8010482f <growproc+0x4e>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801047f8:	8b 55 08             	mov    0x8(%ebp),%edx
801047fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047fe:	01 c2                	add    %eax,%edx
80104800:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104806:	8b 40 04             	mov    0x4(%eax),%eax
80104809:	89 54 24 08          	mov    %edx,0x8(%esp)
8010480d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104810:	89 54 24 04          	mov    %edx,0x4(%esp)
80104814:	89 04 24             	mov    %eax,(%esp)
80104817:	e8 51 41 00 00       	call   8010896d <allocuvm>
8010481c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010481f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104823:	75 44                	jne    80104869 <growproc+0x88>
      return -1;
80104825:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010482a:	e9 af 00 00 00       	jmp    801048de <growproc+0xfd>
  } else if(n < 0){
8010482f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104833:	79 34                	jns    80104869 <growproc+0x88>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104835:	8b 55 08             	mov    0x8(%ebp),%edx
80104838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010483b:	01 c2                	add    %eax,%edx
8010483d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104843:	8b 40 04             	mov    0x4(%eax),%eax
80104846:	89 54 24 08          	mov    %edx,0x8(%esp)
8010484a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010484d:	89 54 24 04          	mov    %edx,0x4(%esp)
80104851:	89 04 24             	mov    %eax,(%esp)
80104854:	e8 2a 42 00 00       	call   80108a83 <deallocuvm>
80104859:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010485c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104860:	75 07                	jne    80104869 <growproc+0x88>
      return -1;
80104862:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104867:	eb 75                	jmp    801048de <growproc+0xfd>
  }
  proc->sz = sz;
80104869:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010486f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104872:	89 10                	mov    %edx,(%eax)
  acquire(&ptable.lock);
80104874:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
8010487b:	e8 ed 0d 00 00       	call   8010566d <acquire>
  for(p=ptable.proc; p<&ptable.proc[NPROC]; p++){
80104880:	c7 45 f0 74 4e 11 80 	movl   $0x80114e74,-0x10(%ebp)
80104887:	eb 2d                	jmp    801048b6 <growproc+0xd5>
      if(p->parent != proc || p->isThread == 1)
80104889:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010488c:	8b 50 14             	mov    0x14(%eax),%edx
8010488f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104895:	39 c2                	cmp    %eax,%edx
80104897:	75 0e                	jne    801048a7 <growproc+0xc6>
80104899:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010489c:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801048a2:	83 f8 01             	cmp    $0x1,%eax
801048a5:	75 08                	jne    801048af <growproc+0xce>
          p->sz = sz;
801048a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048ad:	89 10                	mov    %edx,(%eax)
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  acquire(&ptable.lock);
  for(p=ptable.proc; p<&ptable.proc[NPROC]; p++){
801048af:	81 45 f0 8c 00 00 00 	addl   $0x8c,-0x10(%ebp)
801048b6:	81 7d f0 74 71 11 80 	cmpl   $0x80117174,-0x10(%ebp)
801048bd:	72 ca                	jb     80104889 <growproc+0xa8>
      if(p->parent != proc || p->isThread == 1)
          p->sz = sz;
  }
  release(&ptable.lock);
801048bf:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
801048c6:	e8 09 0e 00 00       	call   801056d4 <release>
  switchuvm(proc);
801048cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048d1:	89 04 24             	mov    %eax,(%esp)
801048d4:	e8 95 3d 00 00       	call   8010866e <switchuvm>
  return 0;
801048d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801048de:	c9                   	leave  
801048df:	c3                   	ret    

801048e0 <clone>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
clone(void*(*start_routine)(void*), void* arg, void* stack)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	57                   	push   %edi
801048e4:	56                   	push   %esi
801048e5:	53                   	push   %ebx
801048e6:	83 ec 2c             	sub    $0x2c,%esp
    int i, tid;
    struct proc *nt;
    void *top;

    if((uint)stack + PGSIZE > proc->sz)
801048e9:	8b 45 10             	mov    0x10(%ebp),%eax
801048ec:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
801048f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048f8:	8b 00                	mov    (%eax),%eax
801048fa:	39 c2                	cmp    %eax,%edx
801048fc:	76 0a                	jbe    80104908 <clone+0x28>
        return -1;
801048fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104903:	e9 ce 01 00 00       	jmp    80104ad6 <clone+0x1f6>

    if((uint)stack%PGSIZE != 0)
80104908:	8b 45 10             	mov    0x10(%ebp),%eax
8010490b:	25 ff 0f 00 00       	and    $0xfff,%eax
80104910:	85 c0                	test   %eax,%eax
80104912:	74 0a                	je     8010491e <clone+0x3e>
        return -1;
80104914:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104919:	e9 b8 01 00 00       	jmp    80104ad6 <clone+0x1f6>

    if((nt = allocproc()) == 0)
8010491e:	e8 84 fc ff ff       	call   801045a7 <allocproc>
80104923:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104926:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010492a:	75 0a                	jne    80104936 <clone+0x56>
        return -1;
8010492c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104931:	e9 a0 01 00 00       	jmp    80104ad6 <clone+0x1f6>

    top = stack+PGSIZE;
80104936:	8b 45 10             	mov    0x10(%ebp),%eax
80104939:	05 00 10 00 00       	add    $0x1000,%eax
8010493e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    nt->sz = proc->sz;
80104941:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104947:	8b 10                	mov    (%eax),%edx
80104949:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010494c:	89 10                	mov    %edx,(%eax)
    nt->parent = proc;
8010494e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104955:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104958:	89 50 14             	mov    %edx,0x14(%eax)
    *nt->tf = *proc->tf;
8010495b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010495e:	8b 50 18             	mov    0x18(%eax),%edx
80104961:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104967:	8b 40 18             	mov    0x18(%eax),%eax
8010496a:	89 c3                	mov    %eax,%ebx
8010496c:	b8 13 00 00 00       	mov    $0x13,%eax
80104971:	89 d7                	mov    %edx,%edi
80104973:	89 de                	mov    %ebx,%esi
80104975:	89 c1                	mov    %eax,%ecx
80104977:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    nt->pgdir = proc->pgdir;
80104979:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010497f:	8b 50 04             	mov    0x4(%eax),%edx
80104982:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104985:	89 50 04             	mov    %edx,0x4(%eax)
    //trap frame setting
    cprintf("2\n");
80104988:	c7 04 24 50 92 10 80 	movl   $0x80109250,(%esp)
8010498f:	e8 34 ba ff ff       	call   801003c8 <cprintf>
    nt->isThread = 1;
80104994:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104997:	c7 80 80 00 00 00 01 	movl   $0x1,0x80(%eax)
8010499e:	00 00 00 

    nt->tf->eax = 0;
801049a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049a4:	8b 40 18             	mov    0x18(%eax),%eax
801049a7:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    nt->tf->eip = (uint)start_routine;
801049ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049b1:	8b 40 18             	mov    0x18(%eax),%eax
801049b4:	8b 55 08             	mov    0x8(%ebp),%edx
801049b7:	89 50 38             	mov    %edx,0x38(%eax)
    nt->ustack = stack;
801049ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049bd:	8b 55 10             	mov    0x10(%ebp),%edx
801049c0:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

    for(i=0;i<NOFILE;i++)
801049c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801049cd:	eb 3d                	jmp    80104a0c <clone+0x12c>
        if(proc->ofile[i])
801049cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801049d8:	83 c2 08             	add    $0x8,%edx
801049db:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801049df:	85 c0                	test   %eax,%eax
801049e1:	74 25                	je     80104a08 <clone+0x128>
            nt->ofile[i] = filedup(proc->ofile[i]);
801049e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801049ec:	83 c2 08             	add    $0x8,%edx
801049ef:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801049f3:	89 04 24             	mov    %eax,(%esp)
801049f6:	e8 ff c5 ff ff       	call   80100ffa <filedup>
801049fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
801049fe:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104a01:	83 c1 08             	add    $0x8,%ecx
80104a04:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)

    nt->tf->eax = 0;
    nt->tf->eip = (uint)start_routine;
    nt->ustack = stack;

    for(i=0;i<NOFILE;i++)
80104a08:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104a0c:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104a10:	7e bd                	jle    801049cf <clone+0xef>
        if(proc->ofile[i])
            nt->ofile[i] = filedup(proc->ofile[i]);
    nt->cwd = idup(proc->cwd);
80104a12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a18:	8b 40 68             	mov    0x68(%eax),%eax
80104a1b:	89 04 24             	mov    %eax,(%esp)
80104a1e:	e8 1d cf ff ff       	call   80101940 <idup>
80104a23:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104a26:	89 42 68             	mov    %eax,0x68(%edx)
    
    *((uint*)(nt->tf->esp)) = (uint)arg;
80104a29:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a2c:	8b 40 18             	mov    0x18(%eax),%eax
80104a2f:	8b 40 44             	mov    0x44(%eax),%eax
80104a32:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a35:	89 10                	mov    %edx,(%eax)
    *((uint*)(nt->tf->esp)-4) = 0xffffffff;
80104a37:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a3a:	8b 40 18             	mov    0x18(%eax),%eax
80104a3d:	8b 40 44             	mov    0x44(%eax),%eax
80104a40:	83 e8 10             	sub    $0x10,%eax
80104a43:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
    nt->tf->esp = (uint)(top-4);
80104a49:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a4c:	8b 40 18             	mov    0x18(%eax),%eax
80104a4f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104a52:	83 ea 04             	sub    $0x4,%edx
80104a55:	89 50 44             	mov    %edx,0x44(%eax)
    nt->tf->esp = (nt->tf->esp) -4;
80104a58:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a5b:	8b 40 18             	mov    0x18(%eax),%eax
80104a5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104a61:	8b 52 18             	mov    0x18(%edx),%edx
80104a64:	8b 52 44             	mov    0x44(%edx),%edx
80104a67:	83 ea 04             	sub    $0x4,%edx
80104a6a:	89 50 44             	mov    %edx,0x44(%eax)
    
    cprintf("3\n");
80104a6d:	c7 04 24 53 92 10 80 	movl   $0x80109253,(%esp)
80104a74:	e8 4f b9 ff ff       	call   801003c8 <cprintf>

    safestrcpy(nt->name, proc->name, sizeof(proc->name));
80104a79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a7f:	8d 50 6c             	lea    0x6c(%eax),%edx
80104a82:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a85:	83 c0 6c             	add    $0x6c,%eax
80104a88:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104a8f:	00 
80104a90:	89 54 24 04          	mov    %edx,0x4(%esp)
80104a94:	89 04 24             	mov    %eax,(%esp)
80104a97:	e8 5a 10 00 00       	call   80105af6 <safestrcpy>
    tid = nt->pid;
80104a9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a9f:	8b 40 10             	mov    0x10(%eax),%eax
80104aa2:	89 45 d8             	mov    %eax,-0x28(%ebp)
    acquire(&ptable.lock);
80104aa5:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80104aac:	e8 bc 0b 00 00       	call   8010566d <acquire>
    nt->state = RUNNABLE;
80104ab1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ab4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    release(&ptable.lock);
80104abb:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80104ac2:	e8 0d 0c 00 00       	call   801056d4 <release>
    cprintf("4\n");
80104ac7:	c7 04 24 56 92 10 80 	movl   $0x80109256,(%esp)
80104ace:	e8 f5 b8 ff ff       	call   801003c8 <cprintf>
    return tid;
80104ad3:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80104ad6:	83 c4 2c             	add    $0x2c,%esp
80104ad9:	5b                   	pop    %ebx
80104ada:	5e                   	pop    %esi
80104adb:	5f                   	pop    %edi
80104adc:	5d                   	pop    %ebp
80104add:	c3                   	ret    

80104ade <join>:

int 
join(int tid, void **stack, void **retval)
{
80104ade:	55                   	push   %ebp
80104adf:	89 e5                	mov    %esp,%ebp
80104ae1:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    int havekid, pid;
    acquire(&ptable.lock);
80104ae4:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80104aeb:	e8 7d 0b 00 00       	call   8010566d <acquire>
    for(;;)
    {
        havekid = 0;
80104af0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104af7:	c7 45 f4 74 4e 11 80 	movl   $0x80114e74,-0xc(%ebp)
80104afe:	e9 d8 00 00 00       	jmp    80104bdb <join+0xfd>
        {
            if(p->parent != proc || p->isThread == 0)
80104b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b06:	8b 50 14             	mov    0x14(%eax),%edx
80104b09:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b0f:	39 c2                	cmp    %eax,%edx
80104b11:	75 0d                	jne    80104b20 <join+0x42>
80104b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b16:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104b1c:	85 c0                	test   %eax,%eax
80104b1e:	75 05                	jne    80104b25 <join+0x47>
                continue;
80104b20:	e9 af 00 00 00       	jmp    80104bd4 <join+0xf6>
            havekid = 1;
80104b25:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if(p->state == ZOMBIE && p->pid == tid)
80104b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b2f:	8b 40 0c             	mov    0xc(%eax),%eax
80104b32:	83 f8 05             	cmp    $0x5,%eax
80104b35:	0f 85 99 00 00 00    	jne    80104bd4 <join+0xf6>
80104b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b3e:	8b 40 10             	mov    0x10(%eax),%eax
80104b41:	3b 45 08             	cmp    0x8(%ebp),%eax
80104b44:	0f 85 8a 00 00 00    	jne    80104bd4 <join+0xf6>
            {
                pid = p->pid;
80104b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b4d:	8b 40 10             	mov    0x10(%eax),%eax
80104b50:	89 45 ec             	mov    %eax,-0x14(%ebp)
                kfree(p->kstack);
80104b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b56:	8b 40 08             	mov    0x8(%eax),%eax
80104b59:	89 04 24             	mov    %eax,(%esp)
80104b5c:	e8 42 e2 ff ff       	call   80102da3 <kfree>
                p->kstack = 0;
80104b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b64:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                p->state = UNUSED;
80104b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b6e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                p->parent = 0;
80104b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b78:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
                p->pid = 0;
80104b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b82:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                p->name[0] = 0;
80104b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b8c:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
                p->killed = 0;
80104b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b93:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
                p->isThread = 0;
80104b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b9d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104ba4:	00 00 00 
                release(&ptable.lock);
80104ba7:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80104bae:	e8 21 0b 00 00       	call   801056d4 <release>
                *stack = p->ustack;
80104bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bbf:	89 10                	mov    %edx,(%eax)
                *retval = p->retval;
80104bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc4:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80104bca:	8b 45 10             	mov    0x10(%ebp),%eax
80104bcd:	89 10                	mov    %edx,(%eax)
                return pid;
80104bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104bd2:	eb 56                	jmp    80104c2a <join+0x14c>
    int havekid, pid;
    acquire(&ptable.lock);
    for(;;)
    {
        havekid = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bd4:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104bdb:	81 7d f4 74 71 11 80 	cmpl   $0x80117174,-0xc(%ebp)
80104be2:	0f 82 1b ff ff ff    	jb     80104b03 <join+0x25>
                *stack = p->ustack;
                *retval = p->retval;
                return pid;
            }
        }
        if(havekid==0 || proc->killed==1)
80104be8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104bec:	74 0e                	je     80104bfc <join+0x11e>
80104bee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bf4:	8b 40 24             	mov    0x24(%eax),%eax
80104bf7:	83 f8 01             	cmp    $0x1,%eax
80104bfa:	75 13                	jne    80104c0f <join+0x131>
        {
            release(&ptable.lock);
80104bfc:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80104c03:	e8 cc 0a 00 00       	call   801056d4 <release>
            return -1;
80104c08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c0d:	eb 1b                	jmp    80104c2a <join+0x14c>
        }
        sleep(proc, &ptable.lock);
80104c0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c15:	c7 44 24 04 40 4e 11 	movl   $0x80114e40,0x4(%esp)
80104c1c:	80 
80104c1d:	89 04 24             	mov    %eax,(%esp)
80104c20:	e8 6e 06 00 00       	call   80105293 <sleep>
    }
80104c25:	e9 c6 fe ff ff       	jmp    80104af0 <join+0x12>
}
80104c2a:	c9                   	leave  
80104c2b:	c3                   	ret    

80104c2c <thexit>:

void
thexit(void)
{
80104c2c:	55                   	push   %ebp
80104c2d:	89 e5                	mov    %esp,%ebp
80104c2f:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    
    if(proc == initproc)
80104c32:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c39:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80104c3e:	39 c2                	cmp    %eax,%edx
80104c40:	75 0c                	jne    80104c4e <thexit+0x22>
        panic("init exiting");
80104c42:	c7 04 24 59 92 10 80 	movl   $0x80109259,(%esp)
80104c49:	e8 14 b9 ff ff       	call   80100562 <panic>

    begin_op();
80104c4e:	e8 4e eb ff ff       	call   801037a1 <begin_op>
    iput(proc->cwd);
80104c53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c59:	8b 40 68             	mov    0x68(%eax),%eax
80104c5c:	89 04 24             	mov    %eax,(%esp)
80104c5f:	e8 69 ce ff ff       	call   80101acd <iput>
    end_op();
80104c64:	e8 bc eb ff ff       	call   80103825 <end_op>
    proc->cwd = 0;
80104c69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c6f:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
80104c76:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80104c7d:	e8 eb 09 00 00       	call   8010566d <acquire>

    wakeup1(proc->parent);
80104c82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c88:	8b 40 14             	mov    0x14(%eax),%eax
80104c8b:	89 04 24             	mov    %eax,(%esp)
80104c8e:	e8 9b 06 00 00       	call   8010532e <wakeup1>

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c93:	c7 45 f4 74 4e 11 80 	movl   $0x80114e74,-0xc(%ebp)
80104c9a:	eb 3b                	jmp    80104cd7 <thexit+0xab>
    {
        if(p->parent == proc)
80104c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c9f:	8b 50 14             	mov    0x14(%eax),%edx
80104ca2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ca8:	39 c2                	cmp    %eax,%edx
80104caa:	75 24                	jne    80104cd0 <thexit+0xa4>
        {
            p->parent = initproc;
80104cac:	8b 15 64 c6 10 80    	mov    0x8010c664,%edx
80104cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cb5:	89 50 14             	mov    %edx,0x14(%eax)
            if(p->state == ZOMBIE)
80104cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cbb:	8b 40 0c             	mov    0xc(%eax),%eax
80104cbe:	83 f8 05             	cmp    $0x5,%eax
80104cc1:	75 0d                	jne    80104cd0 <thexit+0xa4>
                wakeup1(initproc);
80104cc3:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80104cc8:	89 04 24             	mov    %eax,(%esp)
80104ccb:	e8 5e 06 00 00       	call   8010532e <wakeup1>

    acquire(&ptable.lock);

    wakeup1(proc->parent);

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cd0:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104cd7:	81 7d f4 74 71 11 80 	cmpl   $0x80117174,-0xc(%ebp)
80104cde:	72 bc                	jb     80104c9c <thexit+0x70>
            p->parent = initproc;
            if(p->state == ZOMBIE)
                wakeup1(initproc);
        }
    }
    proc->state = ZOMBIE;
80104ce0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ce6:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    sched();
80104ced:	e8 7e 04 00 00       	call   80105170 <sched>
    panic("zombie exit");
80104cf2:	c7 04 24 66 92 10 80 	movl   $0x80109266,(%esp)
80104cf9:	e8 64 b8 ff ff       	call   80100562 <panic>

80104cfe <fork>:
}
    
int
fork(void)
{
80104cfe:	55                   	push   %ebp
80104cff:	89 e5                	mov    %esp,%ebp
80104d01:	57                   	push   %edi
80104d02:	56                   	push   %esi
80104d03:	53                   	push   %ebx
80104d04:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
80104d07:	e8 9b f8 ff ff       	call   801045a7 <allocproc>
80104d0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104d0f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104d13:	75 0a                	jne    80104d1f <fork+0x21>
    return -1;
80104d15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d1a:	e9 5f 01 00 00       	jmp    80104e7e <fork+0x180>
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104d1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d25:	8b 10                	mov    (%eax),%edx
80104d27:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d2d:	8b 40 04             	mov    0x4(%eax),%eax
80104d30:	89 54 24 04          	mov    %edx,0x4(%esp)
80104d34:	89 04 24             	mov    %eax,(%esp)
80104d37:	e8 ea 3e 00 00       	call   80108c26 <copyuvm>
80104d3c:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104d3f:	89 42 04             	mov    %eax,0x4(%edx)
80104d42:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d45:	8b 40 04             	mov    0x4(%eax),%eax
80104d48:	85 c0                	test   %eax,%eax
80104d4a:	75 2c                	jne    80104d78 <fork+0x7a>
    kfree(np->kstack);
80104d4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d4f:	8b 40 08             	mov    0x8(%eax),%eax
80104d52:	89 04 24             	mov    %eax,(%esp)
80104d55:	e8 49 e0 ff ff       	call   80102da3 <kfree>
    np->kstack = 0;
80104d5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d5d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104d64:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d67:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104d6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d73:	e9 06 01 00 00       	jmp    80104e7e <fork+0x180>
  }
  np->sz = proc->sz;
80104d78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d7e:	8b 10                	mov    (%eax),%edx
80104d80:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d83:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104d85:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d8f:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104d92:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d95:	8b 50 18             	mov    0x18(%eax),%edx
80104d98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d9e:	8b 40 18             	mov    0x18(%eax),%eax
80104da1:	89 c3                	mov    %eax,%ebx
80104da3:	b8 13 00 00 00       	mov    $0x13,%eax
80104da8:	89 d7                	mov    %edx,%edi
80104daa:	89 de                	mov    %ebx,%esi
80104dac:	89 c1                	mov    %eax,%ecx
80104dae:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104db0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104db3:	8b 40 18             	mov    0x18(%eax),%eax
80104db6:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104dbd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104dc4:	eb 3d                	jmp    80104e03 <fork+0x105>
    if(proc->ofile[i])
80104dc6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dcc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104dcf:	83 c2 08             	add    $0x8,%edx
80104dd2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104dd6:	85 c0                	test   %eax,%eax
80104dd8:	74 25                	je     80104dff <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
80104dda:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104de3:	83 c2 08             	add    $0x8,%edx
80104de6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104dea:	89 04 24             	mov    %eax,(%esp)
80104ded:	e8 08 c2 ff ff       	call   80100ffa <filedup>
80104df2:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104df5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104df8:	83 c1 08             	add    $0x8,%ecx
80104dfb:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104dff:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104e03:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104e07:	7e bd                	jle    80104dc6 <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104e09:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e0f:	8b 40 68             	mov    0x68(%eax),%eax
80104e12:	89 04 24             	mov    %eax,(%esp)
80104e15:	e8 26 cb ff ff       	call   80101940 <idup>
80104e1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104e1d:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104e20:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e26:	8d 50 6c             	lea    0x6c(%eax),%edx
80104e29:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e2c:	83 c0 6c             	add    $0x6c,%eax
80104e2f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104e36:	00 
80104e37:	89 54 24 04          	mov    %edx,0x4(%esp)
80104e3b:	89 04 24             	mov    %eax,(%esp)
80104e3e:	e8 b3 0c 00 00       	call   80105af6 <safestrcpy>

  pid = np->pid;
80104e43:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e46:	8b 40 10             	mov    0x10(%eax),%eax
80104e49:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->isThread = 0;
80104e4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e4f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104e56:	00 00 00 
  acquire(&ptable.lock);
80104e59:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80104e60:	e8 08 08 00 00       	call   8010566d <acquire>

  np->state = RUNNABLE;
80104e65:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e68:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104e6f:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80104e76:	e8 59 08 00 00       	call   801056d4 <release>

  return pid;
80104e7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104e7e:	83 c4 2c             	add    $0x2c,%esp
80104e81:	5b                   	pop    %ebx
80104e82:	5e                   	pop    %esi
80104e83:	5f                   	pop    %edi
80104e84:	5d                   	pop    %ebp
80104e85:	c3                   	ret    

80104e86 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104e86:	55                   	push   %ebp
80104e87:	89 e5                	mov    %esp,%ebp
80104e89:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104e8c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104e93:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80104e98:	39 c2                	cmp    %eax,%edx
80104e9a:	75 0c                	jne    80104ea8 <exit+0x22>
    panic("init exiting");
80104e9c:	c7 04 24 59 92 10 80 	movl   $0x80109259,(%esp)
80104ea3:	e8 ba b6 ff ff       	call   80100562 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104ea8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104eaf:	eb 44                	jmp    80104ef5 <exit+0x6f>
    if(proc->ofile[fd]){
80104eb1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eb7:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104eba:	83 c2 08             	add    $0x8,%edx
80104ebd:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104ec1:	85 c0                	test   %eax,%eax
80104ec3:	74 2c                	je     80104ef1 <exit+0x6b>
      fileclose(proc->ofile[fd]);
80104ec5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ecb:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ece:	83 c2 08             	add    $0x8,%edx
80104ed1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104ed5:	89 04 24             	mov    %eax,(%esp)
80104ed8:	e8 65 c1 ff ff       	call   80101042 <fileclose>
      proc->ofile[fd] = 0;
80104edd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ee3:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ee6:	83 c2 08             	add    $0x8,%edx
80104ee9:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104ef0:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104ef1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104ef5:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104ef9:	7e b6                	jle    80104eb1 <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104efb:	e8 a1 e8 ff ff       	call   801037a1 <begin_op>
  iput(proc->cwd);
80104f00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f06:	8b 40 68             	mov    0x68(%eax),%eax
80104f09:	89 04 24             	mov    %eax,(%esp)
80104f0c:	e8 bc cb ff ff       	call   80101acd <iput>
  end_op();
80104f11:	e8 0f e9 ff ff       	call   80103825 <end_op>
  proc->cwd = 0;
80104f16:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f1c:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104f23:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80104f2a:	e8 3e 07 00 00       	call   8010566d <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104f2f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f35:	8b 40 14             	mov    0x14(%eax),%eax
80104f38:	89 04 24             	mov    %eax,(%esp)
80104f3b:	e8 ee 03 00 00       	call   8010532e <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f40:	c7 45 f4 74 4e 11 80 	movl   $0x80114e74,-0xc(%ebp)
80104f47:	eb 3b                	jmp    80104f84 <exit+0xfe>
    if(p->parent == proc){
80104f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f4c:	8b 50 14             	mov    0x14(%eax),%edx
80104f4f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f55:	39 c2                	cmp    %eax,%edx
80104f57:	75 24                	jne    80104f7d <exit+0xf7>
      p->parent = initproc;
80104f59:	8b 15 64 c6 10 80    	mov    0x8010c664,%edx
80104f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f62:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f68:	8b 40 0c             	mov    0xc(%eax),%eax
80104f6b:	83 f8 05             	cmp    $0x5,%eax
80104f6e:	75 0d                	jne    80104f7d <exit+0xf7>
        wakeup1(initproc);
80104f70:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80104f75:	89 04 24             	mov    %eax,(%esp)
80104f78:	e8 b1 03 00 00       	call   8010532e <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f7d:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104f84:	81 7d f4 74 71 11 80 	cmpl   $0x80117174,-0xc(%ebp)
80104f8b:	72 bc                	jb     80104f49 <exit+0xc3>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104f8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f93:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104f9a:	e8 d1 01 00 00       	call   80105170 <sched>
  panic("zombie exit");
80104f9f:	c7 04 24 66 92 10 80 	movl   $0x80109266,(%esp)
80104fa6:	e8 b7 b5 ff ff       	call   80100562 <panic>

80104fab <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104fab:	55                   	push   %ebp
80104fac:	89 e5                	mov    %esp,%ebp
80104fae:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104fb1:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80104fb8:	e8 b0 06 00 00       	call   8010566d <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104fbd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fc4:	c7 45 f4 74 4e 11 80 	movl   $0x80114e74,-0xc(%ebp)
80104fcb:	e9 b8 00 00 00       	jmp    80105088 <wait+0xdd>
      if(p->parent != proc || p->isThread == 1)
80104fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd3:	8b 50 14             	mov    0x14(%eax),%edx
80104fd6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fdc:	39 c2                	cmp    %eax,%edx
80104fde:	75 0e                	jne    80104fee <wait+0x43>
80104fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fe3:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104fe9:	83 f8 01             	cmp    $0x1,%eax
80104fec:	75 05                	jne    80104ff3 <wait+0x48>
        continue;
80104fee:	e9 8e 00 00 00       	jmp    80105081 <wait+0xd6>
      havekids = 1;
80104ff3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ffd:	8b 40 0c             	mov    0xc(%eax),%eax
80105000:	83 f8 05             	cmp    $0x5,%eax
80105003:	75 7c                	jne    80105081 <wait+0xd6>
        // Found one.
        pid = p->pid;
80105005:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105008:	8b 40 10             	mov    0x10(%eax),%eax
8010500b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
8010500e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105011:	8b 40 08             	mov    0x8(%eax),%eax
80105014:	89 04 24             	mov    %eax,(%esp)
80105017:	e8 87 dd ff ff       	call   80102da3 <kfree>
        p->kstack = 0;
8010501c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010501f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80105026:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105029:	8b 40 04             	mov    0x4(%eax),%eax
8010502c:	89 04 24             	mov    %eax,(%esp)
8010502f:	e8 15 3b 00 00       	call   80108b49 <freevm>
        p->pid = 0;
80105034:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105037:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010503e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105041:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80105048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010504b:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
8010504f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105052:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80105059:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010505c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->isThread = 0;
80105063:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105066:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010506d:	00 00 00 
        release(&ptable.lock);
80105070:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80105077:	e8 58 06 00 00       	call   801056d4 <release>
        return pid;
8010507c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010507f:	eb 55                	jmp    801050d6 <wait+0x12b>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105081:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80105088:	81 7d f4 74 71 11 80 	cmpl   $0x80117174,-0xc(%ebp)
8010508f:	0f 82 3b ff ff ff    	jb     80104fd0 <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80105095:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105099:	74 0d                	je     801050a8 <wait+0xfd>
8010509b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050a1:	8b 40 24             	mov    0x24(%eax),%eax
801050a4:	85 c0                	test   %eax,%eax
801050a6:	74 13                	je     801050bb <wait+0x110>
      release(&ptable.lock);
801050a8:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
801050af:	e8 20 06 00 00       	call   801056d4 <release>
      return -1;
801050b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050b9:	eb 1b                	jmp    801050d6 <wait+0x12b>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
801050bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050c1:	c7 44 24 04 40 4e 11 	movl   $0x80114e40,0x4(%esp)
801050c8:	80 
801050c9:	89 04 24             	mov    %eax,(%esp)
801050cc:	e8 c2 01 00 00       	call   80105293 <sleep>
  }
801050d1:	e9 e7 fe ff ff       	jmp    80104fbd <wait+0x12>
}
801050d6:	c9                   	leave  
801050d7:	c3                   	ret    

801050d8 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801050d8:	55                   	push   %ebp
801050d9:	89 e5                	mov    %esp,%ebp
801050db:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  for(;;){
    // Enable interrupts on this processor.
    sti();
801050de:	e8 a2 f4 ff ff       	call   80104585 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801050e3:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
801050ea:	e8 7e 05 00 00       	call   8010566d <acquire>

            

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050ef:	c7 45 f4 74 4e 11 80 	movl   $0x80114e74,-0xc(%ebp)
801050f6:	eb 5e                	jmp    80105156 <scheduler+0x7e>
      if(p->state != RUNNABLE)
801050f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050fb:	8b 40 0c             	mov    0xc(%eax),%eax
801050fe:	83 f8 03             	cmp    $0x3,%eax
80105101:	74 02                	je     80105105 <scheduler+0x2d>
        continue;
80105103:	eb 4a                	jmp    8010514f <scheduler+0x77>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80105105:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105108:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
8010510e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105111:	89 04 24             	mov    %eax,(%esp)
80105114:	e8 55 35 00 00       	call   8010866e <switchuvm>
      p->state = RUNNING;
80105119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010511c:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, p->context);
80105123:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105126:	8b 40 1c             	mov    0x1c(%eax),%eax
80105129:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105130:	83 c2 04             	add    $0x4,%edx
80105133:	89 44 24 04          	mov    %eax,0x4(%esp)
80105137:	89 14 24             	mov    %edx,(%esp)
8010513a:	e8 28 0a 00 00       	call   80105b67 <swtch>
      switchkvm();
8010513f:	e8 10 35 00 00       	call   80108654 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80105144:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010514b:	00 00 00 00 
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);

            

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010514f:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80105156:	81 7d f4 74 71 11 80 	cmpl   $0x80117174,-0xc(%ebp)
8010515d:	72 99                	jb     801050f8 <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);  // yield 이후 release를 대신 해주는 것
8010515f:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80105166:	e8 69 05 00 00       	call   801056d4 <release>

  }
8010516b:	e9 6e ff ff ff       	jmp    801050de <scheduler+0x6>

80105170 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80105176:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
8010517d:	e8 18 06 00 00       	call   8010579a <holding>
80105182:	85 c0                	test   %eax,%eax
80105184:	75 0c                	jne    80105192 <sched+0x22>
    panic("sched ptable.lock");
80105186:	c7 04 24 72 92 10 80 	movl   $0x80109272,(%esp)
8010518d:	e8 d0 b3 ff ff       	call   80100562 <panic>
  if(cpu->ncli != 1)
80105192:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105198:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010519e:	83 f8 01             	cmp    $0x1,%eax
801051a1:	74 0c                	je     801051af <sched+0x3f>
    panic("sched locks");
801051a3:	c7 04 24 84 92 10 80 	movl   $0x80109284,(%esp)
801051aa:	e8 b3 b3 ff ff       	call   80100562 <panic>
  if(proc->state == RUNNING)
801051af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051b5:	8b 40 0c             	mov    0xc(%eax),%eax
801051b8:	83 f8 04             	cmp    $0x4,%eax
801051bb:	75 0c                	jne    801051c9 <sched+0x59>
    panic("sched running");
801051bd:	c7 04 24 90 92 10 80 	movl   $0x80109290,(%esp)
801051c4:	e8 99 b3 ff ff       	call   80100562 <panic>
  if(readeflags()&FL_IF)
801051c9:	e8 a7 f3 ff ff       	call   80104575 <readeflags>
801051ce:	25 00 02 00 00       	and    $0x200,%eax
801051d3:	85 c0                	test   %eax,%eax
801051d5:	74 0c                	je     801051e3 <sched+0x73>
    panic("sched interruptible");
801051d7:	c7 04 24 9e 92 10 80 	movl   $0x8010929e,(%esp)
801051de:	e8 7f b3 ff ff       	call   80100562 <panic>
  intena = cpu->intena;
801051e3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051e9:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801051ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
801051f2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051f8:	8b 40 04             	mov    0x4(%eax),%eax
801051fb:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105202:	83 c2 1c             	add    $0x1c,%edx
80105205:	89 44 24 04          	mov    %eax,0x4(%esp)
80105209:	89 14 24             	mov    %edx,(%esp)
8010520c:	e8 56 09 00 00       	call   80105b67 <swtch>
  cpu->intena = intena;
80105211:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105217:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010521a:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105220:	c9                   	leave  
80105221:	c3                   	ret    

80105222 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80105222:	55                   	push   %ebp
80105223:	89 e5                	mov    %esp,%ebp
80105225:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80105228:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
8010522f:	e8 39 04 00 00       	call   8010566d <acquire>
  proc->state = RUNNABLE; //proc은 전역변수 cpu당 1개밖에없다
80105234:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010523a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80105241:	e8 2a ff ff ff       	call   80105170 <sched>
  release(&ptable.lock);
80105246:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
8010524d:	e8 82 04 00 00       	call   801056d4 <release>
}
80105252:	c9                   	leave  
80105253:	c3                   	ret    

80105254 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80105254:	55                   	push   %ebp
80105255:	89 e5                	mov    %esp,%ebp
80105257:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010525a:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80105261:	e8 6e 04 00 00       	call   801056d4 <release>

  if (first) {
80105266:	a1 08 c0 10 80       	mov    0x8010c008,%eax
8010526b:	85 c0                	test   %eax,%eax
8010526d:	74 22                	je     80105291 <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
8010526f:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80105276:	00 00 00 
    iinit(ROOTDEV);
80105279:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105280:	e8 80 c3 ff ff       	call   80101605 <iinit>
    initlog(ROOTDEV);
80105285:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010528c:	e8 0c e3 ff ff       	call   8010359d <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80105291:	c9                   	leave  
80105292:	c3                   	ret    

80105293 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80105293:	55                   	push   %ebp
80105294:	89 e5                	mov    %esp,%ebp
80105296:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80105299:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010529f:	85 c0                	test   %eax,%eax
801052a1:	75 0c                	jne    801052af <sleep+0x1c>
    panic("sleep");
801052a3:	c7 04 24 b2 92 10 80 	movl   $0x801092b2,(%esp)
801052aa:	e8 b3 b2 ff ff       	call   80100562 <panic>

  if(lk == 0)
801052af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801052b3:	75 0c                	jne    801052c1 <sleep+0x2e>
    panic("sleep without lk");
801052b5:	c7 04 24 b8 92 10 80 	movl   $0x801092b8,(%esp)
801052bc:	e8 a1 b2 ff ff       	call   80100562 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801052c1:	81 7d 0c 40 4e 11 80 	cmpl   $0x80114e40,0xc(%ebp)
801052c8:	74 17                	je     801052e1 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
801052ca:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
801052d1:	e8 97 03 00 00       	call   8010566d <acquire>
    release(lk);
801052d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801052d9:	89 04 24             	mov    %eax,(%esp)
801052dc:	e8 f3 03 00 00       	call   801056d4 <release>
  }

  // Go to sleep.
  proc->chan = chan;
801052e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052e7:	8b 55 08             	mov    0x8(%ebp),%edx
801052ea:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
801052ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052f3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801052fa:	e8 71 fe ff ff       	call   80105170 <sched>

  // Tidy up.
  proc->chan = 0;
801052ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105305:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
8010530c:	81 7d 0c 40 4e 11 80 	cmpl   $0x80114e40,0xc(%ebp)
80105313:	74 17                	je     8010532c <sleep+0x99>
    release(&ptable.lock);
80105315:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
8010531c:	e8 b3 03 00 00       	call   801056d4 <release>
    acquire(lk);
80105321:	8b 45 0c             	mov    0xc(%ebp),%eax
80105324:	89 04 24             	mov    %eax,(%esp)
80105327:	e8 41 03 00 00       	call   8010566d <acquire>
  }
}
8010532c:	c9                   	leave  
8010532d:	c3                   	ret    

8010532e <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
8010532e:	55                   	push   %ebp
8010532f:	89 e5                	mov    %esp,%ebp
80105331:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105334:	c7 45 fc 74 4e 11 80 	movl   $0x80114e74,-0x4(%ebp)
8010533b:	eb 27                	jmp    80105364 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
8010533d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105340:	8b 40 0c             	mov    0xc(%eax),%eax
80105343:	83 f8 02             	cmp    $0x2,%eax
80105346:	75 15                	jne    8010535d <wakeup1+0x2f>
80105348:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010534b:	8b 40 20             	mov    0x20(%eax),%eax
8010534e:	3b 45 08             	cmp    0x8(%ebp),%eax
80105351:	75 0a                	jne    8010535d <wakeup1+0x2f>
       p->state = RUNNABLE;
80105353:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105356:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010535d:	81 45 fc 8c 00 00 00 	addl   $0x8c,-0x4(%ebp)
80105364:	81 7d fc 74 71 11 80 	cmpl   $0x80117174,-0x4(%ebp)
8010536b:	72 d0                	jb     8010533d <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
       p->state = RUNNABLE;
}
8010536d:	c9                   	leave  
8010536e:	c3                   	ret    

8010536f <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010536f:	55                   	push   %ebp
80105370:	89 e5                	mov    %esp,%ebp
80105372:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105375:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
8010537c:	e8 ec 02 00 00       	call   8010566d <acquire>
  wakeup1(chan);
80105381:	8b 45 08             	mov    0x8(%ebp),%eax
80105384:	89 04 24             	mov    %eax,(%esp)
80105387:	e8 a2 ff ff ff       	call   8010532e <wakeup1>
  release(&ptable.lock);
8010538c:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80105393:	e8 3c 03 00 00       	call   801056d4 <release>
}
80105398:	c9                   	leave  
80105399:	c3                   	ret    

8010539a <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
8010539a:	55                   	push   %ebp
8010539b:	89 e5                	mov    %esp,%ebp
8010539d:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
801053a0:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
801053a7:	e8 c1 02 00 00       	call   8010566d <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801053ac:	c7 45 f4 74 4e 11 80 	movl   $0x80114e74,-0xc(%ebp)
801053b3:	eb 44                	jmp    801053f9 <kill+0x5f>
    if(p->pid == pid){
801053b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b8:	8b 40 10             	mov    0x10(%eax),%eax
801053bb:	3b 45 08             	cmp    0x8(%ebp),%eax
801053be:	75 32                	jne    801053f2 <kill+0x58>
      p->killed = 1;
801053c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801053ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053cd:	8b 40 0c             	mov    0xc(%eax),%eax
801053d0:	83 f8 02             	cmp    $0x2,%eax
801053d3:	75 0a                	jne    801053df <kill+0x45>
        p->state = RUNNABLE;
801053d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053d8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801053df:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
801053e6:	e8 e9 02 00 00       	call   801056d4 <release>
      return 0;
801053eb:	b8 00 00 00 00       	mov    $0x0,%eax
801053f0:	eb 21                	jmp    80105413 <kill+0x79>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801053f2:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
801053f9:	81 7d f4 74 71 11 80 	cmpl   $0x80117174,-0xc(%ebp)
80105400:	72 b3                	jb     801053b5 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80105402:	c7 04 24 40 4e 11 80 	movl   $0x80114e40,(%esp)
80105409:	e8 c6 02 00 00       	call   801056d4 <release>
  return -1;
8010540e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105413:	c9                   	leave  
80105414:	c3                   	ret    

80105415 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105415:	55                   	push   %ebp
80105416:	89 e5                	mov    %esp,%ebp
80105418:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010541b:	c7 45 f0 74 4e 11 80 	movl   $0x80114e74,-0x10(%ebp)
80105422:	e9 d9 00 00 00       	jmp    80105500 <procdump+0xeb>
    if(p->state == UNUSED)
80105427:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010542a:	8b 40 0c             	mov    0xc(%eax),%eax
8010542d:	85 c0                	test   %eax,%eax
8010542f:	75 05                	jne    80105436 <procdump+0x21>
      continue;
80105431:	e9 c3 00 00 00       	jmp    801054f9 <procdump+0xe4>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105436:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105439:	8b 40 0c             	mov    0xc(%eax),%eax
8010543c:	83 f8 05             	cmp    $0x5,%eax
8010543f:	77 23                	ja     80105464 <procdump+0x4f>
80105441:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105444:	8b 40 0c             	mov    0xc(%eax),%eax
80105447:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
8010544e:	85 c0                	test   %eax,%eax
80105450:	74 12                	je     80105464 <procdump+0x4f>
      state = states[p->state];
80105452:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105455:	8b 40 0c             	mov    0xc(%eax),%eax
80105458:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
8010545f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105462:	eb 07                	jmp    8010546b <procdump+0x56>
    else
      state = "???";
80105464:	c7 45 ec c9 92 10 80 	movl   $0x801092c9,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
8010546b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010546e:	8d 50 6c             	lea    0x6c(%eax),%edx
80105471:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105474:	8b 40 10             	mov    0x10(%eax),%eax
80105477:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010547b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010547e:	89 54 24 08          	mov    %edx,0x8(%esp)
80105482:	89 44 24 04          	mov    %eax,0x4(%esp)
80105486:	c7 04 24 cd 92 10 80 	movl   $0x801092cd,(%esp)
8010548d:	e8 36 af ff ff       	call   801003c8 <cprintf>
    if(p->state == SLEEPING){
80105492:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105495:	8b 40 0c             	mov    0xc(%eax),%eax
80105498:	83 f8 02             	cmp    $0x2,%eax
8010549b:	75 50                	jne    801054ed <procdump+0xd8>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010549d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054a0:	8b 40 1c             	mov    0x1c(%eax),%eax
801054a3:	8b 40 0c             	mov    0xc(%eax),%eax
801054a6:	83 c0 08             	add    $0x8,%eax
801054a9:	8d 55 c4             	lea    -0x3c(%ebp),%edx
801054ac:	89 54 24 04          	mov    %edx,0x4(%esp)
801054b0:	89 04 24             	mov    %eax,(%esp)
801054b3:	e8 69 02 00 00       	call   80105721 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801054b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801054bf:	eb 1b                	jmp    801054dc <procdump+0xc7>
        cprintf(" %p", pc[i]);
801054c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054c4:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801054c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801054cc:	c7 04 24 d6 92 10 80 	movl   $0x801092d6,(%esp)
801054d3:	e8 f0 ae ff ff       	call   801003c8 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801054d8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801054dc:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801054e0:	7f 0b                	jg     801054ed <procdump+0xd8>
801054e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e5:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801054e9:	85 c0                	test   %eax,%eax
801054eb:	75 d4                	jne    801054c1 <procdump+0xac>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801054ed:	c7 04 24 da 92 10 80 	movl   $0x801092da,(%esp)
801054f4:	e8 cf ae ff ff       	call   801003c8 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801054f9:	81 45 f0 8c 00 00 00 	addl   $0x8c,-0x10(%ebp)
80105500:	81 7d f0 74 71 11 80 	cmpl   $0x80117174,-0x10(%ebp)
80105507:	0f 82 1a ff ff ff    	jb     80105427 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
8010550d:	c9                   	leave  
8010550e:	c3                   	ret    

8010550f <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
8010550f:	55                   	push   %ebp
80105510:	89 e5                	mov    %esp,%ebp
80105512:	83 ec 18             	sub    $0x18,%esp
  initlock(&lk->lk, "sleep lock");
80105515:	8b 45 08             	mov    0x8(%ebp),%eax
80105518:	83 c0 04             	add    $0x4,%eax
8010551b:	c7 44 24 04 06 93 10 	movl   $0x80109306,0x4(%esp)
80105522:	80 
80105523:	89 04 24             	mov    %eax,(%esp)
80105526:	e8 21 01 00 00       	call   8010564c <initlock>
  lk->name = name;
8010552b:	8b 45 08             	mov    0x8(%ebp),%eax
8010552e:	8b 55 0c             	mov    0xc(%ebp),%edx
80105531:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80105534:	8b 45 08             	mov    0x8(%ebp),%eax
80105537:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
8010553d:	8b 45 08             	mov    0x8(%ebp),%eax
80105540:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80105547:	c9                   	leave  
80105548:	c3                   	ret    

80105549 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105549:	55                   	push   %ebp
8010554a:	89 e5                	mov    %esp,%ebp
8010554c:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
8010554f:	8b 45 08             	mov    0x8(%ebp),%eax
80105552:	83 c0 04             	add    $0x4,%eax
80105555:	89 04 24             	mov    %eax,(%esp)
80105558:	e8 10 01 00 00       	call   8010566d <acquire>
  while (lk->locked) {
8010555d:	eb 15                	jmp    80105574 <acquiresleep+0x2b>
    sleep(lk, &lk->lk);
8010555f:	8b 45 08             	mov    0x8(%ebp),%eax
80105562:	83 c0 04             	add    $0x4,%eax
80105565:	89 44 24 04          	mov    %eax,0x4(%esp)
80105569:	8b 45 08             	mov    0x8(%ebp),%eax
8010556c:	89 04 24             	mov    %eax,(%esp)
8010556f:	e8 1f fd ff ff       	call   80105293 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80105574:	8b 45 08             	mov    0x8(%ebp),%eax
80105577:	8b 00                	mov    (%eax),%eax
80105579:	85 c0                	test   %eax,%eax
8010557b:	75 e2                	jne    8010555f <acquiresleep+0x16>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
8010557d:	8b 45 08             	mov    0x8(%ebp),%eax
80105580:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = proc->pid;
80105586:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010558c:	8b 50 10             	mov    0x10(%eax),%edx
8010558f:	8b 45 08             	mov    0x8(%ebp),%eax
80105592:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80105595:	8b 45 08             	mov    0x8(%ebp),%eax
80105598:	83 c0 04             	add    $0x4,%eax
8010559b:	89 04 24             	mov    %eax,(%esp)
8010559e:	e8 31 01 00 00       	call   801056d4 <release>
}
801055a3:	c9                   	leave  
801055a4:	c3                   	ret    

801055a5 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801055a5:	55                   	push   %ebp
801055a6:	89 e5                	mov    %esp,%ebp
801055a8:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
801055ab:	8b 45 08             	mov    0x8(%ebp),%eax
801055ae:	83 c0 04             	add    $0x4,%eax
801055b1:	89 04 24             	mov    %eax,(%esp)
801055b4:	e8 b4 00 00 00       	call   8010566d <acquire>
  lk->locked = 0;
801055b9:	8b 45 08             	mov    0x8(%ebp),%eax
801055bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801055c2:	8b 45 08             	mov    0x8(%ebp),%eax
801055c5:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
801055cc:	8b 45 08             	mov    0x8(%ebp),%eax
801055cf:	89 04 24             	mov    %eax,(%esp)
801055d2:	e8 98 fd ff ff       	call   8010536f <wakeup>
  release(&lk->lk);
801055d7:	8b 45 08             	mov    0x8(%ebp),%eax
801055da:	83 c0 04             	add    $0x4,%eax
801055dd:	89 04 24             	mov    %eax,(%esp)
801055e0:	e8 ef 00 00 00       	call   801056d4 <release>
}
801055e5:	c9                   	leave  
801055e6:	c3                   	ret    

801055e7 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801055e7:	55                   	push   %ebp
801055e8:	89 e5                	mov    %esp,%ebp
801055ea:	83 ec 28             	sub    $0x28,%esp
  int r;
  
  acquire(&lk->lk);
801055ed:	8b 45 08             	mov    0x8(%ebp),%eax
801055f0:	83 c0 04             	add    $0x4,%eax
801055f3:	89 04 24             	mov    %eax,(%esp)
801055f6:	e8 72 00 00 00       	call   8010566d <acquire>
  r = lk->locked;
801055fb:	8b 45 08             	mov    0x8(%ebp),%eax
801055fe:	8b 00                	mov    (%eax),%eax
80105600:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80105603:	8b 45 08             	mov    0x8(%ebp),%eax
80105606:	83 c0 04             	add    $0x4,%eax
80105609:	89 04 24             	mov    %eax,(%esp)
8010560c:	e8 c3 00 00 00       	call   801056d4 <release>
  return r;
80105611:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105614:	c9                   	leave  
80105615:	c3                   	ret    

80105616 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105616:	55                   	push   %ebp
80105617:	89 e5                	mov    %esp,%ebp
80105619:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010561c:	9c                   	pushf  
8010561d:	58                   	pop    %eax
8010561e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105621:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105624:	c9                   	leave  
80105625:	c3                   	ret    

80105626 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105626:	55                   	push   %ebp
80105627:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105629:	fa                   	cli    
}
8010562a:	5d                   	pop    %ebp
8010562b:	c3                   	ret    

8010562c <sti>:

static inline void
sti(void)
{
8010562c:	55                   	push   %ebp
8010562d:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010562f:	fb                   	sti    
}
80105630:	5d                   	pop    %ebp
80105631:	c3                   	ret    

80105632 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105632:	55                   	push   %ebp
80105633:	89 e5                	mov    %esp,%ebp
80105635:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105638:	8b 55 08             	mov    0x8(%ebp),%edx
8010563b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010563e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105641:	f0 87 02             	lock xchg %eax,(%edx)
80105644:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105647:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010564a:	c9                   	leave  
8010564b:	c3                   	ret    

8010564c <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010564c:	55                   	push   %ebp
8010564d:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010564f:	8b 45 08             	mov    0x8(%ebp),%eax
80105652:	8b 55 0c             	mov    0xc(%ebp),%edx
80105655:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105658:	8b 45 08             	mov    0x8(%ebp),%eax
8010565b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105661:	8b 45 08             	mov    0x8(%ebp),%eax
80105664:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010566b:	5d                   	pop    %ebp
8010566c:	c3                   	ret    

8010566d <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010566d:	55                   	push   %ebp
8010566e:	89 e5                	mov    %esp,%ebp
80105670:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105673:	e8 4c 01 00 00       	call   801057c4 <pushcli>
  if(holding(lk))
80105678:	8b 45 08             	mov    0x8(%ebp),%eax
8010567b:	89 04 24             	mov    %eax,(%esp)
8010567e:	e8 17 01 00 00       	call   8010579a <holding>
80105683:	85 c0                	test   %eax,%eax
80105685:	74 0c                	je     80105693 <acquire+0x26>
    panic("acquire");
80105687:	c7 04 24 11 93 10 80 	movl   $0x80109311,(%esp)
8010568e:	e8 cf ae ff ff       	call   80100562 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80105693:	90                   	nop
80105694:	8b 45 08             	mov    0x8(%ebp),%eax
80105697:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010569e:	00 
8010569f:	89 04 24             	mov    %eax,(%esp)
801056a2:	e8 8b ff ff ff       	call   80105632 <xchg>
801056a7:	85 c0                	test   %eax,%eax
801056a9:	75 e9                	jne    80105694 <acquire+0x27>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801056ab:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801056b0:	8b 45 08             	mov    0x8(%ebp),%eax
801056b3:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801056ba:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801056bd:	8b 45 08             	mov    0x8(%ebp),%eax
801056c0:	83 c0 0c             	add    $0xc,%eax
801056c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801056c7:	8d 45 08             	lea    0x8(%ebp),%eax
801056ca:	89 04 24             	mov    %eax,(%esp)
801056cd:	e8 4f 00 00 00       	call   80105721 <getcallerpcs>
}
801056d2:	c9                   	leave  
801056d3:	c3                   	ret    

801056d4 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801056d4:	55                   	push   %ebp
801056d5:	89 e5                	mov    %esp,%ebp
801056d7:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
801056da:	8b 45 08             	mov    0x8(%ebp),%eax
801056dd:	89 04 24             	mov    %eax,(%esp)
801056e0:	e8 b5 00 00 00       	call   8010579a <holding>
801056e5:	85 c0                	test   %eax,%eax
801056e7:	75 0c                	jne    801056f5 <release+0x21>
    panic("release");
801056e9:	c7 04 24 19 93 10 80 	movl   $0x80109319,(%esp)
801056f0:	e8 6d ae ff ff       	call   80100562 <panic>

  lk->pcs[0] = 0;
801056f5:	8b 45 08             	mov    0x8(%ebp),%eax
801056f8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801056ff:	8b 45 08             	mov    0x8(%ebp),%eax
80105702:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80105709:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010570e:	8b 45 08             	mov    0x8(%ebp),%eax
80105711:	8b 55 08             	mov    0x8(%ebp),%edx
80105714:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
8010571a:	e8 fb 00 00 00       	call   8010581a <popcli>
}
8010571f:	c9                   	leave  
80105720:	c3                   	ret    

80105721 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105721:	55                   	push   %ebp
80105722:	89 e5                	mov    %esp,%ebp
80105724:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80105727:	8b 45 08             	mov    0x8(%ebp),%eax
8010572a:	83 e8 08             	sub    $0x8,%eax
8010572d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105730:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105737:	eb 38                	jmp    80105771 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105739:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010573d:	74 38                	je     80105777 <getcallerpcs+0x56>
8010573f:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105746:	76 2f                	jbe    80105777 <getcallerpcs+0x56>
80105748:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010574c:	74 29                	je     80105777 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010574e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105751:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105758:	8b 45 0c             	mov    0xc(%ebp),%eax
8010575b:	01 c2                	add    %eax,%edx
8010575d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105760:	8b 40 04             	mov    0x4(%eax),%eax
80105763:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105765:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105768:	8b 00                	mov    (%eax),%eax
8010576a:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010576d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105771:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105775:	7e c2                	jle    80105739 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105777:	eb 19                	jmp    80105792 <getcallerpcs+0x71>
    pcs[i] = 0;
80105779:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010577c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105783:	8b 45 0c             	mov    0xc(%ebp),%eax
80105786:	01 d0                	add    %edx,%eax
80105788:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010578e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105792:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105796:	7e e1                	jle    80105779 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105798:	c9                   	leave  
80105799:	c3                   	ret    

8010579a <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010579a:	55                   	push   %ebp
8010579b:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
8010579d:	8b 45 08             	mov    0x8(%ebp),%eax
801057a0:	8b 00                	mov    (%eax),%eax
801057a2:	85 c0                	test   %eax,%eax
801057a4:	74 17                	je     801057bd <holding+0x23>
801057a6:	8b 45 08             	mov    0x8(%ebp),%eax
801057a9:	8b 50 08             	mov    0x8(%eax),%edx
801057ac:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801057b2:	39 c2                	cmp    %eax,%edx
801057b4:	75 07                	jne    801057bd <holding+0x23>
801057b6:	b8 01 00 00 00       	mov    $0x1,%eax
801057bb:	eb 05                	jmp    801057c2 <holding+0x28>
801057bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057c2:	5d                   	pop    %ebp
801057c3:	c3                   	ret    

801057c4 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801057c4:	55                   	push   %ebp
801057c5:	89 e5                	mov    %esp,%ebp
801057c7:	83 ec 10             	sub    $0x10,%esp
  int eflags;

  eflags = readeflags();
801057ca:	e8 47 fe ff ff       	call   80105616 <readeflags>
801057cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801057d2:	e8 4f fe ff ff       	call   80105626 <cli>
  if(cpu->ncli == 0)
801057d7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801057dd:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801057e3:	85 c0                	test   %eax,%eax
801057e5:	75 15                	jne    801057fc <pushcli+0x38>
    cpu->intena = eflags & FL_IF;
801057e7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801057ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
801057f0:	81 e2 00 02 00 00    	and    $0x200,%edx
801057f6:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
  cpu->ncli += 1;
801057fc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105802:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105809:	8b 92 ac 00 00 00    	mov    0xac(%edx),%edx
8010580f:	83 c2 01             	add    $0x1,%edx
80105812:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
}
80105818:	c9                   	leave  
80105819:	c3                   	ret    

8010581a <popcli>:

void
popcli(void)
{
8010581a:	55                   	push   %ebp
8010581b:	89 e5                	mov    %esp,%ebp
8010581d:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80105820:	e8 f1 fd ff ff       	call   80105616 <readeflags>
80105825:	25 00 02 00 00       	and    $0x200,%eax
8010582a:	85 c0                	test   %eax,%eax
8010582c:	74 0c                	je     8010583a <popcli+0x20>
    panic("popcli - interruptible");
8010582e:	c7 04 24 21 93 10 80 	movl   $0x80109321,(%esp)
80105835:	e8 28 ad ff ff       	call   80100562 <panic>
  if(--cpu->ncli < 0)
8010583a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105840:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105846:	83 ea 01             	sub    $0x1,%edx
80105849:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010584f:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105855:	85 c0                	test   %eax,%eax
80105857:	79 0c                	jns    80105865 <popcli+0x4b>
    panic("popcli");
80105859:	c7 04 24 38 93 10 80 	movl   $0x80109338,(%esp)
80105860:	e8 fd ac ff ff       	call   80100562 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105865:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010586b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105871:	85 c0                	test   %eax,%eax
80105873:	75 15                	jne    8010588a <popcli+0x70>
80105875:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010587b:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105881:	85 c0                	test   %eax,%eax
80105883:	74 05                	je     8010588a <popcli+0x70>
    sti();
80105885:	e8 a2 fd ff ff       	call   8010562c <sti>
}
8010588a:	c9                   	leave  
8010588b:	c3                   	ret    

8010588c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
8010588c:	55                   	push   %ebp
8010588d:	89 e5                	mov    %esp,%ebp
8010588f:	57                   	push   %edi
80105890:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105891:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105894:	8b 55 10             	mov    0x10(%ebp),%edx
80105897:	8b 45 0c             	mov    0xc(%ebp),%eax
8010589a:	89 cb                	mov    %ecx,%ebx
8010589c:	89 df                	mov    %ebx,%edi
8010589e:	89 d1                	mov    %edx,%ecx
801058a0:	fc                   	cld    
801058a1:	f3 aa                	rep stos %al,%es:(%edi)
801058a3:	89 ca                	mov    %ecx,%edx
801058a5:	89 fb                	mov    %edi,%ebx
801058a7:	89 5d 08             	mov    %ebx,0x8(%ebp)
801058aa:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801058ad:	5b                   	pop    %ebx
801058ae:	5f                   	pop    %edi
801058af:	5d                   	pop    %ebp
801058b0:	c3                   	ret    

801058b1 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801058b1:	55                   	push   %ebp
801058b2:	89 e5                	mov    %esp,%ebp
801058b4:	57                   	push   %edi
801058b5:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801058b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801058b9:	8b 55 10             	mov    0x10(%ebp),%edx
801058bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801058bf:	89 cb                	mov    %ecx,%ebx
801058c1:	89 df                	mov    %ebx,%edi
801058c3:	89 d1                	mov    %edx,%ecx
801058c5:	fc                   	cld    
801058c6:	f3 ab                	rep stos %eax,%es:(%edi)
801058c8:	89 ca                	mov    %ecx,%edx
801058ca:	89 fb                	mov    %edi,%ebx
801058cc:	89 5d 08             	mov    %ebx,0x8(%ebp)
801058cf:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801058d2:	5b                   	pop    %ebx
801058d3:	5f                   	pop    %edi
801058d4:	5d                   	pop    %ebp
801058d5:	c3                   	ret    

801058d6 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801058d6:	55                   	push   %ebp
801058d7:	89 e5                	mov    %esp,%ebp
801058d9:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
801058dc:	8b 45 08             	mov    0x8(%ebp),%eax
801058df:	83 e0 03             	and    $0x3,%eax
801058e2:	85 c0                	test   %eax,%eax
801058e4:	75 49                	jne    8010592f <memset+0x59>
801058e6:	8b 45 10             	mov    0x10(%ebp),%eax
801058e9:	83 e0 03             	and    $0x3,%eax
801058ec:	85 c0                	test   %eax,%eax
801058ee:	75 3f                	jne    8010592f <memset+0x59>
    c &= 0xFF;
801058f0:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801058f7:	8b 45 10             	mov    0x10(%ebp),%eax
801058fa:	c1 e8 02             	shr    $0x2,%eax
801058fd:	89 c2                	mov    %eax,%edx
801058ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80105902:	c1 e0 18             	shl    $0x18,%eax
80105905:	89 c1                	mov    %eax,%ecx
80105907:	8b 45 0c             	mov    0xc(%ebp),%eax
8010590a:	c1 e0 10             	shl    $0x10,%eax
8010590d:	09 c1                	or     %eax,%ecx
8010590f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105912:	c1 e0 08             	shl    $0x8,%eax
80105915:	09 c8                	or     %ecx,%eax
80105917:	0b 45 0c             	or     0xc(%ebp),%eax
8010591a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010591e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105922:	8b 45 08             	mov    0x8(%ebp),%eax
80105925:	89 04 24             	mov    %eax,(%esp)
80105928:	e8 84 ff ff ff       	call   801058b1 <stosl>
8010592d:	eb 19                	jmp    80105948 <memset+0x72>
  } else
    stosb(dst, c, n);
8010592f:	8b 45 10             	mov    0x10(%ebp),%eax
80105932:	89 44 24 08          	mov    %eax,0x8(%esp)
80105936:	8b 45 0c             	mov    0xc(%ebp),%eax
80105939:	89 44 24 04          	mov    %eax,0x4(%esp)
8010593d:	8b 45 08             	mov    0x8(%ebp),%eax
80105940:	89 04 24             	mov    %eax,(%esp)
80105943:	e8 44 ff ff ff       	call   8010588c <stosb>
  return dst;
80105948:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010594b:	c9                   	leave  
8010594c:	c3                   	ret    

8010594d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010594d:	55                   	push   %ebp
8010594e:	89 e5                	mov    %esp,%ebp
80105950:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
80105953:	8b 45 08             	mov    0x8(%ebp),%eax
80105956:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105959:	8b 45 0c             	mov    0xc(%ebp),%eax
8010595c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010595f:	eb 30                	jmp    80105991 <memcmp+0x44>
    if(*s1 != *s2)
80105961:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105964:	0f b6 10             	movzbl (%eax),%edx
80105967:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010596a:	0f b6 00             	movzbl (%eax),%eax
8010596d:	38 c2                	cmp    %al,%dl
8010596f:	74 18                	je     80105989 <memcmp+0x3c>
      return *s1 - *s2;
80105971:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105974:	0f b6 00             	movzbl (%eax),%eax
80105977:	0f b6 d0             	movzbl %al,%edx
8010597a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010597d:	0f b6 00             	movzbl (%eax),%eax
80105980:	0f b6 c0             	movzbl %al,%eax
80105983:	29 c2                	sub    %eax,%edx
80105985:	89 d0                	mov    %edx,%eax
80105987:	eb 1a                	jmp    801059a3 <memcmp+0x56>
    s1++, s2++;
80105989:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010598d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105991:	8b 45 10             	mov    0x10(%ebp),%eax
80105994:	8d 50 ff             	lea    -0x1(%eax),%edx
80105997:	89 55 10             	mov    %edx,0x10(%ebp)
8010599a:	85 c0                	test   %eax,%eax
8010599c:	75 c3                	jne    80105961 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010599e:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059a3:	c9                   	leave  
801059a4:	c3                   	ret    

801059a5 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801059a5:	55                   	push   %ebp
801059a6:	89 e5                	mov    %esp,%ebp
801059a8:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801059ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801059ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801059b1:	8b 45 08             	mov    0x8(%ebp),%eax
801059b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801059b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801059bd:	73 3d                	jae    801059fc <memmove+0x57>
801059bf:	8b 45 10             	mov    0x10(%ebp),%eax
801059c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801059c5:	01 d0                	add    %edx,%eax
801059c7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801059ca:	76 30                	jbe    801059fc <memmove+0x57>
    s += n;
801059cc:	8b 45 10             	mov    0x10(%ebp),%eax
801059cf:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801059d2:	8b 45 10             	mov    0x10(%ebp),%eax
801059d5:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801059d8:	eb 13                	jmp    801059ed <memmove+0x48>
      *--d = *--s;
801059da:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801059de:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801059e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059e5:	0f b6 10             	movzbl (%eax),%edx
801059e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
801059eb:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801059ed:	8b 45 10             	mov    0x10(%ebp),%eax
801059f0:	8d 50 ff             	lea    -0x1(%eax),%edx
801059f3:	89 55 10             	mov    %edx,0x10(%ebp)
801059f6:	85 c0                	test   %eax,%eax
801059f8:	75 e0                	jne    801059da <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801059fa:	eb 26                	jmp    80105a22 <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801059fc:	eb 17                	jmp    80105a15 <memmove+0x70>
      *d++ = *s++;
801059fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105a01:	8d 50 01             	lea    0x1(%eax),%edx
80105a04:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105a07:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a0a:	8d 4a 01             	lea    0x1(%edx),%ecx
80105a0d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105a10:	0f b6 12             	movzbl (%edx),%edx
80105a13:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105a15:	8b 45 10             	mov    0x10(%ebp),%eax
80105a18:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a1b:	89 55 10             	mov    %edx,0x10(%ebp)
80105a1e:	85 c0                	test   %eax,%eax
80105a20:	75 dc                	jne    801059fe <memmove+0x59>
      *d++ = *s++;

  return dst;
80105a22:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105a25:	c9                   	leave  
80105a26:	c3                   	ret    

80105a27 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105a27:	55                   	push   %ebp
80105a28:	89 e5                	mov    %esp,%ebp
80105a2a:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105a2d:	8b 45 10             	mov    0x10(%ebp),%eax
80105a30:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a34:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a37:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a3b:	8b 45 08             	mov    0x8(%ebp),%eax
80105a3e:	89 04 24             	mov    %eax,(%esp)
80105a41:	e8 5f ff ff ff       	call   801059a5 <memmove>
}
80105a46:	c9                   	leave  
80105a47:	c3                   	ret    

80105a48 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105a48:	55                   	push   %ebp
80105a49:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105a4b:	eb 0c                	jmp    80105a59 <strncmp+0x11>
    n--, p++, q++;
80105a4d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105a51:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105a55:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105a59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a5d:	74 1a                	je     80105a79 <strncmp+0x31>
80105a5f:	8b 45 08             	mov    0x8(%ebp),%eax
80105a62:	0f b6 00             	movzbl (%eax),%eax
80105a65:	84 c0                	test   %al,%al
80105a67:	74 10                	je     80105a79 <strncmp+0x31>
80105a69:	8b 45 08             	mov    0x8(%ebp),%eax
80105a6c:	0f b6 10             	movzbl (%eax),%edx
80105a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a72:	0f b6 00             	movzbl (%eax),%eax
80105a75:	38 c2                	cmp    %al,%dl
80105a77:	74 d4                	je     80105a4d <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105a79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a7d:	75 07                	jne    80105a86 <strncmp+0x3e>
    return 0;
80105a7f:	b8 00 00 00 00       	mov    $0x0,%eax
80105a84:	eb 16                	jmp    80105a9c <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105a86:	8b 45 08             	mov    0x8(%ebp),%eax
80105a89:	0f b6 00             	movzbl (%eax),%eax
80105a8c:	0f b6 d0             	movzbl %al,%edx
80105a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a92:	0f b6 00             	movzbl (%eax),%eax
80105a95:	0f b6 c0             	movzbl %al,%eax
80105a98:	29 c2                	sub    %eax,%edx
80105a9a:	89 d0                	mov    %edx,%eax
}
80105a9c:	5d                   	pop    %ebp
80105a9d:	c3                   	ret    

80105a9e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105a9e:	55                   	push   %ebp
80105a9f:	89 e5                	mov    %esp,%ebp
80105aa1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80105aa7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105aaa:	90                   	nop
80105aab:	8b 45 10             	mov    0x10(%ebp),%eax
80105aae:	8d 50 ff             	lea    -0x1(%eax),%edx
80105ab1:	89 55 10             	mov    %edx,0x10(%ebp)
80105ab4:	85 c0                	test   %eax,%eax
80105ab6:	7e 1e                	jle    80105ad6 <strncpy+0x38>
80105ab8:	8b 45 08             	mov    0x8(%ebp),%eax
80105abb:	8d 50 01             	lea    0x1(%eax),%edx
80105abe:	89 55 08             	mov    %edx,0x8(%ebp)
80105ac1:	8b 55 0c             	mov    0xc(%ebp),%edx
80105ac4:	8d 4a 01             	lea    0x1(%edx),%ecx
80105ac7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105aca:	0f b6 12             	movzbl (%edx),%edx
80105acd:	88 10                	mov    %dl,(%eax)
80105acf:	0f b6 00             	movzbl (%eax),%eax
80105ad2:	84 c0                	test   %al,%al
80105ad4:	75 d5                	jne    80105aab <strncpy+0xd>
    ;
  while(n-- > 0)
80105ad6:	eb 0c                	jmp    80105ae4 <strncpy+0x46>
    *s++ = 0;
80105ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80105adb:	8d 50 01             	lea    0x1(%eax),%edx
80105ade:	89 55 08             	mov    %edx,0x8(%ebp)
80105ae1:	c6 00 00             	movb   $0x0,(%eax)
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105ae4:	8b 45 10             	mov    0x10(%ebp),%eax
80105ae7:	8d 50 ff             	lea    -0x1(%eax),%edx
80105aea:	89 55 10             	mov    %edx,0x10(%ebp)
80105aed:	85 c0                	test   %eax,%eax
80105aef:	7f e7                	jg     80105ad8 <strncpy+0x3a>
    *s++ = 0;
  return os;
80105af1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105af4:	c9                   	leave  
80105af5:	c3                   	ret    

80105af6 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105af6:	55                   	push   %ebp
80105af7:	89 e5                	mov    %esp,%ebp
80105af9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105afc:	8b 45 08             	mov    0x8(%ebp),%eax
80105aff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105b02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105b06:	7f 05                	jg     80105b0d <safestrcpy+0x17>
    return os;
80105b08:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b0b:	eb 31                	jmp    80105b3e <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105b0d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105b11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105b15:	7e 1e                	jle    80105b35 <safestrcpy+0x3f>
80105b17:	8b 45 08             	mov    0x8(%ebp),%eax
80105b1a:	8d 50 01             	lea    0x1(%eax),%edx
80105b1d:	89 55 08             	mov    %edx,0x8(%ebp)
80105b20:	8b 55 0c             	mov    0xc(%ebp),%edx
80105b23:	8d 4a 01             	lea    0x1(%edx),%ecx
80105b26:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105b29:	0f b6 12             	movzbl (%edx),%edx
80105b2c:	88 10                	mov    %dl,(%eax)
80105b2e:	0f b6 00             	movzbl (%eax),%eax
80105b31:	84 c0                	test   %al,%al
80105b33:	75 d8                	jne    80105b0d <safestrcpy+0x17>
    ;
  *s = 0;
80105b35:	8b 45 08             	mov    0x8(%ebp),%eax
80105b38:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105b3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105b3e:	c9                   	leave  
80105b3f:	c3                   	ret    

80105b40 <strlen>:

int
strlen(const char *s)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105b46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105b4d:	eb 04                	jmp    80105b53 <strlen+0x13>
80105b4f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105b53:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b56:	8b 45 08             	mov    0x8(%ebp),%eax
80105b59:	01 d0                	add    %edx,%eax
80105b5b:	0f b6 00             	movzbl (%eax),%eax
80105b5e:	84 c0                	test   %al,%al
80105b60:	75 ed                	jne    80105b4f <strlen+0xf>
    ;
  return n;
80105b62:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105b65:	c9                   	leave  
80105b66:	c3                   	ret    

80105b67 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105b67:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105b6b:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105b6f:	55                   	push   %ebp
  pushl %ebx
80105b70:	53                   	push   %ebx
  pushl %esi
80105b71:	56                   	push   %esi
  pushl %edi
80105b72:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105b73:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105b75:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105b77:	5f                   	pop    %edi
  popl %esi
80105b78:	5e                   	pop    %esi
  popl %ebx
80105b79:	5b                   	pop    %ebx
  popl %ebp
80105b7a:	5d                   	pop    %ebp
  ret
80105b7b:	c3                   	ret    

80105b7c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105b7c:	55                   	push   %ebp
80105b7d:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105b7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b85:	8b 00                	mov    (%eax),%eax
80105b87:	3b 45 08             	cmp    0x8(%ebp),%eax
80105b8a:	76 12                	jbe    80105b9e <fetchint+0x22>
80105b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80105b8f:	8d 50 04             	lea    0x4(%eax),%edx
80105b92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b98:	8b 00                	mov    (%eax),%eax
80105b9a:	39 c2                	cmp    %eax,%edx
80105b9c:	76 07                	jbe    80105ba5 <fetchint+0x29>
    return -1;
80105b9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ba3:	eb 0f                	jmp    80105bb4 <fetchint+0x38>
  *ip = *(int*)(addr);
80105ba5:	8b 45 08             	mov    0x8(%ebp),%eax
80105ba8:	8b 10                	mov    (%eax),%edx
80105baa:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bad:	89 10                	mov    %edx,(%eax)
  return 0;
80105baf:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105bb4:	5d                   	pop    %ebp
80105bb5:	c3                   	ret    

80105bb6 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105bb6:	55                   	push   %ebp
80105bb7:	89 e5                	mov    %esp,%ebp
80105bb9:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105bbc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bc2:	8b 00                	mov    (%eax),%eax
80105bc4:	3b 45 08             	cmp    0x8(%ebp),%eax
80105bc7:	77 07                	ja     80105bd0 <fetchstr+0x1a>
    return -1;
80105bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bce:	eb 46                	jmp    80105c16 <fetchstr+0x60>
  *pp = (char*)addr;
80105bd0:	8b 55 08             	mov    0x8(%ebp),%edx
80105bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bd6:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105bd8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bde:	8b 00                	mov    (%eax),%eax
80105be0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105be3:	8b 45 0c             	mov    0xc(%ebp),%eax
80105be6:	8b 00                	mov    (%eax),%eax
80105be8:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105beb:	eb 1c                	jmp    80105c09 <fetchstr+0x53>
    if(*s == 0)
80105bed:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bf0:	0f b6 00             	movzbl (%eax),%eax
80105bf3:	84 c0                	test   %al,%al
80105bf5:	75 0e                	jne    80105c05 <fetchstr+0x4f>
      return s - *pp;
80105bf7:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bfd:	8b 00                	mov    (%eax),%eax
80105bff:	29 c2                	sub    %eax,%edx
80105c01:	89 d0                	mov    %edx,%eax
80105c03:	eb 11                	jmp    80105c16 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105c05:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c0c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105c0f:	72 dc                	jb     80105bed <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c16:	c9                   	leave  
80105c17:	c3                   	ret    

80105c18 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105c18:	55                   	push   %ebp
80105c19:	89 e5                	mov    %esp,%ebp
80105c1b:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105c1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c24:	8b 40 18             	mov    0x18(%eax),%eax
80105c27:	8b 50 44             	mov    0x44(%eax),%edx
80105c2a:	8b 45 08             	mov    0x8(%ebp),%eax
80105c2d:	c1 e0 02             	shl    $0x2,%eax
80105c30:	01 d0                	add    %edx,%eax
80105c32:	8d 50 04             	lea    0x4(%eax),%edx
80105c35:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c38:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c3c:	89 14 24             	mov    %edx,(%esp)
80105c3f:	e8 38 ff ff ff       	call   80105b7c <fetchint>
}
80105c44:	c9                   	leave  
80105c45:	c3                   	ret    

80105c46 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105c46:	55                   	push   %ebp
80105c47:	89 e5                	mov    %esp,%ebp
80105c49:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(argint(n, &i) < 0)
80105c4c:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105c4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c53:	8b 45 08             	mov    0x8(%ebp),%eax
80105c56:	89 04 24             	mov    %eax,(%esp)
80105c59:	e8 ba ff ff ff       	call   80105c18 <argint>
80105c5e:	85 c0                	test   %eax,%eax
80105c60:	79 07                	jns    80105c69 <argptr+0x23>
    return -1;
80105c62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c67:	eb 43                	jmp    80105cac <argptr+0x66>
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80105c69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105c6d:	78 27                	js     80105c96 <argptr+0x50>
80105c6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c72:	89 c2                	mov    %eax,%edx
80105c74:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c7a:	8b 00                	mov    (%eax),%eax
80105c7c:	39 c2                	cmp    %eax,%edx
80105c7e:	73 16                	jae    80105c96 <argptr+0x50>
80105c80:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c83:	89 c2                	mov    %eax,%edx
80105c85:	8b 45 10             	mov    0x10(%ebp),%eax
80105c88:	01 c2                	add    %eax,%edx
80105c8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c90:	8b 00                	mov    (%eax),%eax
80105c92:	39 c2                	cmp    %eax,%edx
80105c94:	76 07                	jbe    80105c9d <argptr+0x57>
    return -1;
80105c96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c9b:	eb 0f                	jmp    80105cac <argptr+0x66>
  *pp = (char*)i;
80105c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ca0:	89 c2                	mov    %eax,%edx
80105ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ca5:	89 10                	mov    %edx,(%eax)
  return 0;
80105ca7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105cac:	c9                   	leave  
80105cad:	c3                   	ret    

80105cae <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105cae:	55                   	push   %ebp
80105caf:	89 e5                	mov    %esp,%ebp
80105cb1:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105cb4:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cbb:	8b 45 08             	mov    0x8(%ebp),%eax
80105cbe:	89 04 24             	mov    %eax,(%esp)
80105cc1:	e8 52 ff ff ff       	call   80105c18 <argint>
80105cc6:	85 c0                	test   %eax,%eax
80105cc8:	79 07                	jns    80105cd1 <argstr+0x23>
    return -1;
80105cca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ccf:	eb 12                	jmp    80105ce3 <argstr+0x35>
  return fetchstr(addr, pp);
80105cd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105cd4:	8b 55 0c             	mov    0xc(%ebp),%edx
80105cd7:	89 54 24 04          	mov    %edx,0x4(%esp)
80105cdb:	89 04 24             	mov    %eax,(%esp)
80105cde:	e8 d3 fe ff ff       	call   80105bb6 <fetchstr>
}
80105ce3:	c9                   	leave  
80105ce4:	c3                   	ret    

80105ce5 <syscall>:
[SYS_thexit] sys_thexit,
};

void
syscall(void)
{
80105ce5:	55                   	push   %ebp
80105ce6:	89 e5                	mov    %esp,%ebp
80105ce8:	53                   	push   %ebx
80105ce9:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105cec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cf2:	8b 40 18             	mov    0x18(%eax),%eax
80105cf5:	8b 40 1c             	mov    0x1c(%eax),%eax
80105cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105cfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cff:	7e 30                	jle    80105d31 <syscall+0x4c>
80105d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d04:	83 f8 1c             	cmp    $0x1c,%eax
80105d07:	77 28                	ja     80105d31 <syscall+0x4c>
80105d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d0c:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105d13:	85 c0                	test   %eax,%eax
80105d15:	74 1a                	je     80105d31 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105d17:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d1d:	8b 58 18             	mov    0x18(%eax),%ebx
80105d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d23:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105d2a:	ff d0                	call   *%eax
80105d2c:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105d2f:	eb 3d                	jmp    80105d6e <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105d31:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d37:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105d3a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105d40:	8b 40 10             	mov    0x10(%eax),%eax
80105d43:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d46:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105d4a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d52:	c7 04 24 3f 93 10 80 	movl   $0x8010933f,(%esp)
80105d59:	e8 6a a6 ff ff       	call   801003c8 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105d5e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d64:	8b 40 18             	mov    0x18(%eax),%eax
80105d67:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105d6e:	83 c4 24             	add    $0x24,%esp
80105d71:	5b                   	pop    %ebx
80105d72:	5d                   	pop    %ebp
80105d73:	c3                   	ret    

80105d74 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105d74:	55                   	push   %ebp
80105d75:	89 e5                	mov    %esp,%ebp
80105d77:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105d7a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d81:	8b 45 08             	mov    0x8(%ebp),%eax
80105d84:	89 04 24             	mov    %eax,(%esp)
80105d87:	e8 8c fe ff ff       	call   80105c18 <argint>
80105d8c:	85 c0                	test   %eax,%eax
80105d8e:	79 07                	jns    80105d97 <argfd+0x23>
    return -1;
80105d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d95:	eb 50                	jmp    80105de7 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d9a:	85 c0                	test   %eax,%eax
80105d9c:	78 21                	js     80105dbf <argfd+0x4b>
80105d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105da1:	83 f8 0f             	cmp    $0xf,%eax
80105da4:	7f 19                	jg     80105dbf <argfd+0x4b>
80105da6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105dac:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105daf:	83 c2 08             	add    $0x8,%edx
80105db2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105db6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105db9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dbd:	75 07                	jne    80105dc6 <argfd+0x52>
    return -1;
80105dbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dc4:	eb 21                	jmp    80105de7 <argfd+0x73>
  if(pfd)
80105dc6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105dca:	74 08                	je     80105dd4 <argfd+0x60>
    *pfd = fd;
80105dcc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
80105dd2:	89 10                	mov    %edx,(%eax)
  if(pf)
80105dd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105dd8:	74 08                	je     80105de2 <argfd+0x6e>
    *pf = f;
80105dda:	8b 45 10             	mov    0x10(%ebp),%eax
80105ddd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105de0:	89 10                	mov    %edx,(%eax)
  return 0;
80105de2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105de7:	c9                   	leave  
80105de8:	c3                   	ret    

80105de9 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105de9:	55                   	push   %ebp
80105dea:	89 e5                	mov    %esp,%ebp
80105dec:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105def:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105df6:	eb 30                	jmp    80105e28 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105df8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105dfe:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105e01:	83 c2 08             	add    $0x8,%edx
80105e04:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105e08:	85 c0                	test   %eax,%eax
80105e0a:	75 18                	jne    80105e24 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105e0c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e12:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105e15:	8d 4a 08             	lea    0x8(%edx),%ecx
80105e18:	8b 55 08             	mov    0x8(%ebp),%edx
80105e1b:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105e1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e22:	eb 0f                	jmp    80105e33 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105e24:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105e28:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105e2c:	7e ca                	jle    80105df8 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105e2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e33:	c9                   	leave  
80105e34:	c3                   	ret    

80105e35 <sys_dup>:

int
sys_dup(void)
{
80105e35:	55                   	push   %ebp
80105e36:	89 e5                	mov    %esp,%ebp
80105e38:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105e3b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e3e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e42:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e49:	00 
80105e4a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e51:	e8 1e ff ff ff       	call   80105d74 <argfd>
80105e56:	85 c0                	test   %eax,%eax
80105e58:	79 07                	jns    80105e61 <sys_dup+0x2c>
    return -1;
80105e5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e5f:	eb 29                	jmp    80105e8a <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e64:	89 04 24             	mov    %eax,(%esp)
80105e67:	e8 7d ff ff ff       	call   80105de9 <fdalloc>
80105e6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e73:	79 07                	jns    80105e7c <sys_dup+0x47>
    return -1;
80105e75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e7a:	eb 0e                	jmp    80105e8a <sys_dup+0x55>
  filedup(f);
80105e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e7f:	89 04 24             	mov    %eax,(%esp)
80105e82:	e8 73 b1 ff ff       	call   80100ffa <filedup>
  return fd;
80105e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105e8a:	c9                   	leave  
80105e8b:	c3                   	ret    

80105e8c <sys_read>:

int
sys_read(void)
{
80105e8c:	55                   	push   %ebp
80105e8d:	89 e5                	mov    %esp,%ebp
80105e8f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105e92:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e95:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e99:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105ea0:	00 
80105ea1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ea8:	e8 c7 fe ff ff       	call   80105d74 <argfd>
80105ead:	85 c0                	test   %eax,%eax
80105eaf:	78 35                	js     80105ee6 <sys_read+0x5a>
80105eb1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105eb4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105eb8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105ebf:	e8 54 fd ff ff       	call   80105c18 <argint>
80105ec4:	85 c0                	test   %eax,%eax
80105ec6:	78 1e                	js     80105ee6 <sys_read+0x5a>
80105ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ecb:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ecf:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ed2:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ed6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105edd:	e8 64 fd ff ff       	call   80105c46 <argptr>
80105ee2:	85 c0                	test   %eax,%eax
80105ee4:	79 07                	jns    80105eed <sys_read+0x61>
    return -1;
80105ee6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eeb:	eb 19                	jmp    80105f06 <sys_read+0x7a>
  return fileread(f, p, n);
80105eed:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105ef0:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105efa:	89 54 24 04          	mov    %edx,0x4(%esp)
80105efe:	89 04 24             	mov    %eax,(%esp)
80105f01:	e8 61 b2 ff ff       	call   80101167 <fileread>
}
80105f06:	c9                   	leave  
80105f07:	c3                   	ret    

80105f08 <sys_write>:

int
sys_write(void)
{
80105f08:	55                   	push   %ebp
80105f09:	89 e5                	mov    %esp,%ebp
80105f0b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105f0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f11:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f15:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105f1c:	00 
80105f1d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f24:	e8 4b fe ff ff       	call   80105d74 <argfd>
80105f29:	85 c0                	test   %eax,%eax
80105f2b:	78 35                	js     80105f62 <sys_write+0x5a>
80105f2d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f30:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f34:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105f3b:	e8 d8 fc ff ff       	call   80105c18 <argint>
80105f40:	85 c0                	test   %eax,%eax
80105f42:	78 1e                	js     80105f62 <sys_write+0x5a>
80105f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f47:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f4b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f52:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f59:	e8 e8 fc ff ff       	call   80105c46 <argptr>
80105f5e:	85 c0                	test   %eax,%eax
80105f60:	79 07                	jns    80105f69 <sys_write+0x61>
    return -1;
80105f62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f67:	eb 19                	jmp    80105f82 <sys_write+0x7a>
  return filewrite(f, p, n);
80105f69:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105f6c:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f72:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105f76:	89 54 24 04          	mov    %edx,0x4(%esp)
80105f7a:	89 04 24             	mov    %eax,(%esp)
80105f7d:	e8 a1 b2 ff ff       	call   80101223 <filewrite>
}
80105f82:	c9                   	leave  
80105f83:	c3                   	ret    

80105f84 <sys_close>:

int
sys_close(void)
{
80105f84:	55                   	push   %ebp
80105f85:	89 e5                	mov    %esp,%ebp
80105f87:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105f8a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f8d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f91:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f94:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f98:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f9f:	e8 d0 fd ff ff       	call   80105d74 <argfd>
80105fa4:	85 c0                	test   %eax,%eax
80105fa6:	79 07                	jns    80105faf <sys_close+0x2b>
    return -1;
80105fa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fad:	eb 24                	jmp    80105fd3 <sys_close+0x4f>
  proc->ofile[fd] = 0;
80105faf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105fb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fb8:	83 c2 08             	add    $0x8,%edx
80105fbb:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105fc2:	00 
  fileclose(f);
80105fc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fc6:	89 04 24             	mov    %eax,(%esp)
80105fc9:	e8 74 b0 ff ff       	call   80101042 <fileclose>
  return 0;
80105fce:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105fd3:	c9                   	leave  
80105fd4:	c3                   	ret    

80105fd5 <sys_fstat>:

int
sys_fstat(void)
{
80105fd5:	55                   	push   %ebp
80105fd6:	89 e5                	mov    %esp,%ebp
80105fd8:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105fdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fde:	89 44 24 08          	mov    %eax,0x8(%esp)
80105fe2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105fe9:	00 
80105fea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ff1:	e8 7e fd ff ff       	call   80105d74 <argfd>
80105ff6:	85 c0                	test   %eax,%eax
80105ff8:	78 1f                	js     80106019 <sys_fstat+0x44>
80105ffa:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80106001:	00 
80106002:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106005:	89 44 24 04          	mov    %eax,0x4(%esp)
80106009:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106010:	e8 31 fc ff ff       	call   80105c46 <argptr>
80106015:	85 c0                	test   %eax,%eax
80106017:	79 07                	jns    80106020 <sys_fstat+0x4b>
    return -1;
80106019:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010601e:	eb 12                	jmp    80106032 <sys_fstat+0x5d>
  return filestat(f, st);
80106020:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106023:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106026:	89 54 24 04          	mov    %edx,0x4(%esp)
8010602a:	89 04 24             	mov    %eax,(%esp)
8010602d:	e8 e6 b0 ff ff       	call   80101118 <filestat>
}
80106032:	c9                   	leave  
80106033:	c3                   	ret    

80106034 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106034:	55                   	push   %ebp
80106035:	89 e5                	mov    %esp,%ebp
80106037:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010603a:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010603d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106041:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106048:	e8 61 fc ff ff       	call   80105cae <argstr>
8010604d:	85 c0                	test   %eax,%eax
8010604f:	78 17                	js     80106068 <sys_link+0x34>
80106051:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106054:	89 44 24 04          	mov    %eax,0x4(%esp)
80106058:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010605f:	e8 4a fc ff ff       	call   80105cae <argstr>
80106064:	85 c0                	test   %eax,%eax
80106066:	79 0a                	jns    80106072 <sys_link+0x3e>
    return -1;
80106068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010606d:	e9 42 01 00 00       	jmp    801061b4 <sys_link+0x180>

  begin_op();
80106072:	e8 2a d7 ff ff       	call   801037a1 <begin_op>
  if((ip = namei(old)) == 0){
80106077:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010607a:	89 04 24             	mov    %eax,(%esp)
8010607d:	e8 80 c6 ff ff       	call   80102702 <namei>
80106082:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106085:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106089:	75 0f                	jne    8010609a <sys_link+0x66>
    end_op();
8010608b:	e8 95 d7 ff ff       	call   80103825 <end_op>
    return -1;
80106090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106095:	e9 1a 01 00 00       	jmp    801061b4 <sys_link+0x180>
  }

  ilock(ip);
8010609a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010609d:	89 04 24             	mov    %eax,(%esp)
801060a0:	e8 cd b8 ff ff       	call   80101972 <ilock>
  if(ip->type == T_DIR){
801060a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060a8:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801060ac:	66 83 f8 01          	cmp    $0x1,%ax
801060b0:	75 1a                	jne    801060cc <sys_link+0x98>
    iunlockput(ip);
801060b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060b5:	89 04 24             	mov    %eax,(%esp)
801060b8:	e8 a4 ba ff ff       	call   80101b61 <iunlockput>
    end_op();
801060bd:	e8 63 d7 ff ff       	call   80103825 <end_op>
    return -1;
801060c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060c7:	e9 e8 00 00 00       	jmp    801061b4 <sys_link+0x180>
  }

  ip->nlink++;
801060cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060cf:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801060d3:	8d 50 01             	lea    0x1(%eax),%edx
801060d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d9:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801060dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e0:	89 04 24             	mov    %eax,(%esp)
801060e3:	e8 c5 b6 ff ff       	call   801017ad <iupdate>
  iunlock(ip);
801060e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060eb:	89 04 24             	mov    %eax,(%esp)
801060ee:	e8 96 b9 ff ff       	call   80101a89 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801060f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801060f6:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801060f9:	89 54 24 04          	mov    %edx,0x4(%esp)
801060fd:	89 04 24             	mov    %eax,(%esp)
80106100:	e8 1f c6 ff ff       	call   80102724 <nameiparent>
80106105:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106108:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010610c:	75 02                	jne    80106110 <sys_link+0xdc>
    goto bad;
8010610e:	eb 68                	jmp    80106178 <sys_link+0x144>
  ilock(dp);
80106110:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106113:	89 04 24             	mov    %eax,(%esp)
80106116:	e8 57 b8 ff ff       	call   80101972 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010611b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010611e:	8b 10                	mov    (%eax),%edx
80106120:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106123:	8b 00                	mov    (%eax),%eax
80106125:	39 c2                	cmp    %eax,%edx
80106127:	75 20                	jne    80106149 <sys_link+0x115>
80106129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010612c:	8b 40 04             	mov    0x4(%eax),%eax
8010612f:	89 44 24 08          	mov    %eax,0x8(%esp)
80106133:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106136:	89 44 24 04          	mov    %eax,0x4(%esp)
8010613a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010613d:	89 04 24             	mov    %eax,(%esp)
80106140:	e8 fd c2 ff ff       	call   80102442 <dirlink>
80106145:	85 c0                	test   %eax,%eax
80106147:	79 0d                	jns    80106156 <sys_link+0x122>
    iunlockput(dp);
80106149:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010614c:	89 04 24             	mov    %eax,(%esp)
8010614f:	e8 0d ba ff ff       	call   80101b61 <iunlockput>
    goto bad;
80106154:	eb 22                	jmp    80106178 <sys_link+0x144>
  }
  iunlockput(dp);
80106156:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106159:	89 04 24             	mov    %eax,(%esp)
8010615c:	e8 00 ba ff ff       	call   80101b61 <iunlockput>
  iput(ip);
80106161:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106164:	89 04 24             	mov    %eax,(%esp)
80106167:	e8 61 b9 ff ff       	call   80101acd <iput>

  end_op();
8010616c:	e8 b4 d6 ff ff       	call   80103825 <end_op>

  return 0;
80106171:	b8 00 00 00 00       	mov    $0x0,%eax
80106176:	eb 3c                	jmp    801061b4 <sys_link+0x180>

bad:
  ilock(ip);
80106178:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010617b:	89 04 24             	mov    %eax,(%esp)
8010617e:	e8 ef b7 ff ff       	call   80101972 <ilock>
  ip->nlink--;
80106183:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106186:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010618a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010618d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106190:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80106194:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106197:	89 04 24             	mov    %eax,(%esp)
8010619a:	e8 0e b6 ff ff       	call   801017ad <iupdate>
  iunlockput(ip);
8010619f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a2:	89 04 24             	mov    %eax,(%esp)
801061a5:	e8 b7 b9 ff ff       	call   80101b61 <iunlockput>
  end_op();
801061aa:	e8 76 d6 ff ff       	call   80103825 <end_op>
  return -1;
801061af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061b4:	c9                   	leave  
801061b5:	c3                   	ret    

801061b6 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801061b6:	55                   	push   %ebp
801061b7:	89 e5                	mov    %esp,%ebp
801061b9:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801061bc:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801061c3:	eb 4b                	jmp    80106210 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801061c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061c8:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801061cf:	00 
801061d0:	89 44 24 08          	mov    %eax,0x8(%esp)
801061d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801061d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801061db:	8b 45 08             	mov    0x8(%ebp),%eax
801061de:	89 04 24             	mov    %eax,(%esp)
801061e1:	e8 7e be ff ff       	call   80102064 <readi>
801061e6:	83 f8 10             	cmp    $0x10,%eax
801061e9:	74 0c                	je     801061f7 <isdirempty+0x41>
      panic("isdirempty: readi");
801061eb:	c7 04 24 5b 93 10 80 	movl   $0x8010935b,(%esp)
801061f2:	e8 6b a3 ff ff       	call   80100562 <panic>
    if(de.inum != 0)
801061f7:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801061fb:	66 85 c0             	test   %ax,%ax
801061fe:	74 07                	je     80106207 <isdirempty+0x51>
      return 0;
80106200:	b8 00 00 00 00       	mov    $0x0,%eax
80106205:	eb 1b                	jmp    80106222 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106207:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010620a:	83 c0 10             	add    $0x10,%eax
8010620d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106210:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106213:	8b 45 08             	mov    0x8(%ebp),%eax
80106216:	8b 40 58             	mov    0x58(%eax),%eax
80106219:	39 c2                	cmp    %eax,%edx
8010621b:	72 a8                	jb     801061c5 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
8010621d:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106222:	c9                   	leave  
80106223:	c3                   	ret    

80106224 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80106224:	55                   	push   %ebp
80106225:	89 e5                	mov    %esp,%ebp
80106227:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010622a:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010622d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106231:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106238:	e8 71 fa ff ff       	call   80105cae <argstr>
8010623d:	85 c0                	test   %eax,%eax
8010623f:	79 0a                	jns    8010624b <sys_unlink+0x27>
    return -1;
80106241:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106246:	e9 af 01 00 00       	jmp    801063fa <sys_unlink+0x1d6>

  begin_op();
8010624b:	e8 51 d5 ff ff       	call   801037a1 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106250:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106253:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80106256:	89 54 24 04          	mov    %edx,0x4(%esp)
8010625a:	89 04 24             	mov    %eax,(%esp)
8010625d:	e8 c2 c4 ff ff       	call   80102724 <nameiparent>
80106262:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106265:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106269:	75 0f                	jne    8010627a <sys_unlink+0x56>
    end_op();
8010626b:	e8 b5 d5 ff ff       	call   80103825 <end_op>
    return -1;
80106270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106275:	e9 80 01 00 00       	jmp    801063fa <sys_unlink+0x1d6>
  }

  ilock(dp);
8010627a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010627d:	89 04 24             	mov    %eax,(%esp)
80106280:	e8 ed b6 ff ff       	call   80101972 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106285:	c7 44 24 04 6d 93 10 	movl   $0x8010936d,0x4(%esp)
8010628c:	80 
8010628d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106290:	89 04 24             	mov    %eax,(%esp)
80106293:	e8 bf c0 ff ff       	call   80102357 <namecmp>
80106298:	85 c0                	test   %eax,%eax
8010629a:	0f 84 45 01 00 00    	je     801063e5 <sys_unlink+0x1c1>
801062a0:	c7 44 24 04 6f 93 10 	movl   $0x8010936f,0x4(%esp)
801062a7:	80 
801062a8:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801062ab:	89 04 24             	mov    %eax,(%esp)
801062ae:	e8 a4 c0 ff ff       	call   80102357 <namecmp>
801062b3:	85 c0                	test   %eax,%eax
801062b5:	0f 84 2a 01 00 00    	je     801063e5 <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801062bb:	8d 45 c8             	lea    -0x38(%ebp),%eax
801062be:	89 44 24 08          	mov    %eax,0x8(%esp)
801062c2:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801062c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801062c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062cc:	89 04 24             	mov    %eax,(%esp)
801062cf:	e8 a5 c0 ff ff       	call   80102379 <dirlookup>
801062d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062db:	75 05                	jne    801062e2 <sys_unlink+0xbe>
    goto bad;
801062dd:	e9 03 01 00 00       	jmp    801063e5 <sys_unlink+0x1c1>
  ilock(ip);
801062e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062e5:	89 04 24             	mov    %eax,(%esp)
801062e8:	e8 85 b6 ff ff       	call   80101972 <ilock>

  if(ip->nlink < 1)
801062ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062f0:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801062f4:	66 85 c0             	test   %ax,%ax
801062f7:	7f 0c                	jg     80106305 <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
801062f9:	c7 04 24 72 93 10 80 	movl   $0x80109372,(%esp)
80106300:	e8 5d a2 ff ff       	call   80100562 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106305:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106308:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010630c:	66 83 f8 01          	cmp    $0x1,%ax
80106310:	75 1f                	jne    80106331 <sys_unlink+0x10d>
80106312:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106315:	89 04 24             	mov    %eax,(%esp)
80106318:	e8 99 fe ff ff       	call   801061b6 <isdirempty>
8010631d:	85 c0                	test   %eax,%eax
8010631f:	75 10                	jne    80106331 <sys_unlink+0x10d>
    iunlockput(ip);
80106321:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106324:	89 04 24             	mov    %eax,(%esp)
80106327:	e8 35 b8 ff ff       	call   80101b61 <iunlockput>
    goto bad;
8010632c:	e9 b4 00 00 00       	jmp    801063e5 <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
80106331:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80106338:	00 
80106339:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106340:	00 
80106341:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106344:	89 04 24             	mov    %eax,(%esp)
80106347:	e8 8a f5 ff ff       	call   801058d6 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010634c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010634f:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80106356:	00 
80106357:	89 44 24 08          	mov    %eax,0x8(%esp)
8010635b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010635e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106362:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106365:	89 04 24             	mov    %eax,(%esp)
80106368:	e8 5b be ff ff       	call   801021c8 <writei>
8010636d:	83 f8 10             	cmp    $0x10,%eax
80106370:	74 0c                	je     8010637e <sys_unlink+0x15a>
    panic("unlink: writei");
80106372:	c7 04 24 84 93 10 80 	movl   $0x80109384,(%esp)
80106379:	e8 e4 a1 ff ff       	call   80100562 <panic>
  if(ip->type == T_DIR){
8010637e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106381:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106385:	66 83 f8 01          	cmp    $0x1,%ax
80106389:	75 1c                	jne    801063a7 <sys_unlink+0x183>
    dp->nlink--;
8010638b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010638e:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106392:	8d 50 ff             	lea    -0x1(%eax),%edx
80106395:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106398:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
8010639c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010639f:	89 04 24             	mov    %eax,(%esp)
801063a2:	e8 06 b4 ff ff       	call   801017ad <iupdate>
  }
  iunlockput(dp);
801063a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063aa:	89 04 24             	mov    %eax,(%esp)
801063ad:	e8 af b7 ff ff       	call   80101b61 <iunlockput>

  ip->nlink--;
801063b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063b5:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801063b9:	8d 50 ff             	lea    -0x1(%eax),%edx
801063bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063bf:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801063c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063c6:	89 04 24             	mov    %eax,(%esp)
801063c9:	e8 df b3 ff ff       	call   801017ad <iupdate>
  iunlockput(ip);
801063ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063d1:	89 04 24             	mov    %eax,(%esp)
801063d4:	e8 88 b7 ff ff       	call   80101b61 <iunlockput>

  end_op();
801063d9:	e8 47 d4 ff ff       	call   80103825 <end_op>

  return 0;
801063de:	b8 00 00 00 00       	mov    $0x0,%eax
801063e3:	eb 15                	jmp    801063fa <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
801063e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063e8:	89 04 24             	mov    %eax,(%esp)
801063eb:	e8 71 b7 ff ff       	call   80101b61 <iunlockput>
  end_op();
801063f0:	e8 30 d4 ff ff       	call   80103825 <end_op>
  return -1;
801063f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063fa:	c9                   	leave  
801063fb:	c3                   	ret    

801063fc <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801063fc:	55                   	push   %ebp
801063fd:	89 e5                	mov    %esp,%ebp
801063ff:	83 ec 48             	sub    $0x48,%esp
80106402:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106405:	8b 55 10             	mov    0x10(%ebp),%edx
80106408:	8b 45 14             	mov    0x14(%ebp),%eax
8010640b:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010640f:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106413:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106417:	8d 45 de             	lea    -0x22(%ebp),%eax
8010641a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010641e:	8b 45 08             	mov    0x8(%ebp),%eax
80106421:	89 04 24             	mov    %eax,(%esp)
80106424:	e8 fb c2 ff ff       	call   80102724 <nameiparent>
80106429:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010642c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106430:	75 0a                	jne    8010643c <create+0x40>
    return 0;
80106432:	b8 00 00 00 00       	mov    $0x0,%eax
80106437:	e9 7e 01 00 00       	jmp    801065ba <create+0x1be>
  ilock(dp);
8010643c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010643f:	89 04 24             	mov    %eax,(%esp)
80106442:	e8 2b b5 ff ff       	call   80101972 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80106447:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010644a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010644e:	8d 45 de             	lea    -0x22(%ebp),%eax
80106451:	89 44 24 04          	mov    %eax,0x4(%esp)
80106455:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106458:	89 04 24             	mov    %eax,(%esp)
8010645b:	e8 19 bf ff ff       	call   80102379 <dirlookup>
80106460:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106463:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106467:	74 47                	je     801064b0 <create+0xb4>
    iunlockput(dp);
80106469:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010646c:	89 04 24             	mov    %eax,(%esp)
8010646f:	e8 ed b6 ff ff       	call   80101b61 <iunlockput>
    ilock(ip);
80106474:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106477:	89 04 24             	mov    %eax,(%esp)
8010647a:	e8 f3 b4 ff ff       	call   80101972 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010647f:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106484:	75 15                	jne    8010649b <create+0x9f>
80106486:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106489:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010648d:	66 83 f8 02          	cmp    $0x2,%ax
80106491:	75 08                	jne    8010649b <create+0x9f>
      return ip;
80106493:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106496:	e9 1f 01 00 00       	jmp    801065ba <create+0x1be>
    iunlockput(ip);
8010649b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010649e:	89 04 24             	mov    %eax,(%esp)
801064a1:	e8 bb b6 ff ff       	call   80101b61 <iunlockput>
    return 0;
801064a6:	b8 00 00 00 00       	mov    $0x0,%eax
801064ab:	e9 0a 01 00 00       	jmp    801065ba <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801064b0:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801064b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064b7:	8b 00                	mov    (%eax),%eax
801064b9:	89 54 24 04          	mov    %edx,0x4(%esp)
801064bd:	89 04 24             	mov    %eax,(%esp)
801064c0:	e8 13 b2 ff ff       	call   801016d8 <ialloc>
801064c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801064c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064cc:	75 0c                	jne    801064da <create+0xde>
    panic("create: ialloc");
801064ce:	c7 04 24 93 93 10 80 	movl   $0x80109393,(%esp)
801064d5:	e8 88 a0 ff ff       	call   80100562 <panic>

  ilock(ip);
801064da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064dd:	89 04 24             	mov    %eax,(%esp)
801064e0:	e8 8d b4 ff ff       	call   80101972 <ilock>
  ip->major = major;
801064e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064e8:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801064ec:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
801064f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064f3:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801064f7:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
801064fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064fe:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80106504:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106507:	89 04 24             	mov    %eax,(%esp)
8010650a:	e8 9e b2 ff ff       	call   801017ad <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
8010650f:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106514:	75 6a                	jne    80106580 <create+0x184>
    dp->nlink++;  // for ".."
80106516:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106519:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010651d:	8d 50 01             	lea    0x1(%eax),%edx
80106520:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106523:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80106527:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010652a:	89 04 24             	mov    %eax,(%esp)
8010652d:	e8 7b b2 ff ff       	call   801017ad <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106532:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106535:	8b 40 04             	mov    0x4(%eax),%eax
80106538:	89 44 24 08          	mov    %eax,0x8(%esp)
8010653c:	c7 44 24 04 6d 93 10 	movl   $0x8010936d,0x4(%esp)
80106543:	80 
80106544:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106547:	89 04 24             	mov    %eax,(%esp)
8010654a:	e8 f3 be ff ff       	call   80102442 <dirlink>
8010654f:	85 c0                	test   %eax,%eax
80106551:	78 21                	js     80106574 <create+0x178>
80106553:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106556:	8b 40 04             	mov    0x4(%eax),%eax
80106559:	89 44 24 08          	mov    %eax,0x8(%esp)
8010655d:	c7 44 24 04 6f 93 10 	movl   $0x8010936f,0x4(%esp)
80106564:	80 
80106565:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106568:	89 04 24             	mov    %eax,(%esp)
8010656b:	e8 d2 be ff ff       	call   80102442 <dirlink>
80106570:	85 c0                	test   %eax,%eax
80106572:	79 0c                	jns    80106580 <create+0x184>
      panic("create dots");
80106574:	c7 04 24 a2 93 10 80 	movl   $0x801093a2,(%esp)
8010657b:	e8 e2 9f ff ff       	call   80100562 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106580:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106583:	8b 40 04             	mov    0x4(%eax),%eax
80106586:	89 44 24 08          	mov    %eax,0x8(%esp)
8010658a:	8d 45 de             	lea    -0x22(%ebp),%eax
8010658d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106591:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106594:	89 04 24             	mov    %eax,(%esp)
80106597:	e8 a6 be ff ff       	call   80102442 <dirlink>
8010659c:	85 c0                	test   %eax,%eax
8010659e:	79 0c                	jns    801065ac <create+0x1b0>
    panic("create: dirlink");
801065a0:	c7 04 24 ae 93 10 80 	movl   $0x801093ae,(%esp)
801065a7:	e8 b6 9f ff ff       	call   80100562 <panic>

  iunlockput(dp);
801065ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065af:	89 04 24             	mov    %eax,(%esp)
801065b2:	e8 aa b5 ff ff       	call   80101b61 <iunlockput>

  return ip;
801065b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801065ba:	c9                   	leave  
801065bb:	c3                   	ret    

801065bc <sys_open>:

int
sys_open(void)
{
801065bc:	55                   	push   %ebp
801065bd:	89 e5                	mov    %esp,%ebp
801065bf:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801065c2:	8d 45 e8             	lea    -0x18(%ebp),%eax
801065c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801065c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801065d0:	e8 d9 f6 ff ff       	call   80105cae <argstr>
801065d5:	85 c0                	test   %eax,%eax
801065d7:	78 17                	js     801065f0 <sys_open+0x34>
801065d9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801065dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801065e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801065e7:	e8 2c f6 ff ff       	call   80105c18 <argint>
801065ec:	85 c0                	test   %eax,%eax
801065ee:	79 0a                	jns    801065fa <sys_open+0x3e>
    return -1;
801065f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065f5:	e9 5c 01 00 00       	jmp    80106756 <sys_open+0x19a>

  begin_op();
801065fa:	e8 a2 d1 ff ff       	call   801037a1 <begin_op>

  if(omode & O_CREATE){
801065ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106602:	25 00 02 00 00       	and    $0x200,%eax
80106607:	85 c0                	test   %eax,%eax
80106609:	74 3b                	je     80106646 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
8010660b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010660e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106615:	00 
80106616:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010661d:	00 
8010661e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80106625:	00 
80106626:	89 04 24             	mov    %eax,(%esp)
80106629:	e8 ce fd ff ff       	call   801063fc <create>
8010662e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106631:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106635:	75 6b                	jne    801066a2 <sys_open+0xe6>
      end_op();
80106637:	e8 e9 d1 ff ff       	call   80103825 <end_op>
      return -1;
8010663c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106641:	e9 10 01 00 00       	jmp    80106756 <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
80106646:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106649:	89 04 24             	mov    %eax,(%esp)
8010664c:	e8 b1 c0 ff ff       	call   80102702 <namei>
80106651:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106654:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106658:	75 0f                	jne    80106669 <sys_open+0xad>
      end_op();
8010665a:	e8 c6 d1 ff ff       	call   80103825 <end_op>
      return -1;
8010665f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106664:	e9 ed 00 00 00       	jmp    80106756 <sys_open+0x19a>
    }
    ilock(ip);
80106669:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010666c:	89 04 24             	mov    %eax,(%esp)
8010666f:	e8 fe b2 ff ff       	call   80101972 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106674:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106677:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010667b:	66 83 f8 01          	cmp    $0x1,%ax
8010667f:	75 21                	jne    801066a2 <sys_open+0xe6>
80106681:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106684:	85 c0                	test   %eax,%eax
80106686:	74 1a                	je     801066a2 <sys_open+0xe6>
      iunlockput(ip);
80106688:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010668b:	89 04 24             	mov    %eax,(%esp)
8010668e:	e8 ce b4 ff ff       	call   80101b61 <iunlockput>
      end_op();
80106693:	e8 8d d1 ff ff       	call   80103825 <end_op>
      return -1;
80106698:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010669d:	e9 b4 00 00 00       	jmp    80106756 <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801066a2:	e8 f3 a8 ff ff       	call   80100f9a <filealloc>
801066a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801066aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066ae:	74 14                	je     801066c4 <sys_open+0x108>
801066b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066b3:	89 04 24             	mov    %eax,(%esp)
801066b6:	e8 2e f7 ff ff       	call   80105de9 <fdalloc>
801066bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
801066be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801066c2:	79 28                	jns    801066ec <sys_open+0x130>
    if(f)
801066c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066c8:	74 0b                	je     801066d5 <sys_open+0x119>
      fileclose(f);
801066ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066cd:	89 04 24             	mov    %eax,(%esp)
801066d0:	e8 6d a9 ff ff       	call   80101042 <fileclose>
    iunlockput(ip);
801066d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066d8:	89 04 24             	mov    %eax,(%esp)
801066db:	e8 81 b4 ff ff       	call   80101b61 <iunlockput>
    end_op();
801066e0:	e8 40 d1 ff ff       	call   80103825 <end_op>
    return -1;
801066e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066ea:	eb 6a                	jmp    80106756 <sys_open+0x19a>
  }
  iunlock(ip);
801066ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066ef:	89 04 24             	mov    %eax,(%esp)
801066f2:	e8 92 b3 ff ff       	call   80101a89 <iunlock>
  end_op();
801066f7:	e8 29 d1 ff ff       	call   80103825 <end_op>

  f->type = FD_INODE;
801066fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066ff:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106705:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106708:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010670b:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010670e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106711:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010671b:	83 e0 01             	and    $0x1,%eax
8010671e:	85 c0                	test   %eax,%eax
80106720:	0f 94 c0             	sete   %al
80106723:	89 c2                	mov    %eax,%edx
80106725:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106728:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010672b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010672e:	83 e0 01             	and    $0x1,%eax
80106731:	85 c0                	test   %eax,%eax
80106733:	75 0a                	jne    8010673f <sys_open+0x183>
80106735:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106738:	83 e0 02             	and    $0x2,%eax
8010673b:	85 c0                	test   %eax,%eax
8010673d:	74 07                	je     80106746 <sys_open+0x18a>
8010673f:	b8 01 00 00 00       	mov    $0x1,%eax
80106744:	eb 05                	jmp    8010674b <sys_open+0x18f>
80106746:	b8 00 00 00 00       	mov    $0x0,%eax
8010674b:	89 c2                	mov    %eax,%edx
8010674d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106750:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106753:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106756:	c9                   	leave  
80106757:	c3                   	ret    

80106758 <sys_mkdir>:

int
sys_mkdir(void)
{
80106758:	55                   	push   %ebp
80106759:	89 e5                	mov    %esp,%ebp
8010675b:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010675e:	e8 3e d0 ff ff       	call   801037a1 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106763:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106766:	89 44 24 04          	mov    %eax,0x4(%esp)
8010676a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106771:	e8 38 f5 ff ff       	call   80105cae <argstr>
80106776:	85 c0                	test   %eax,%eax
80106778:	78 2c                	js     801067a6 <sys_mkdir+0x4e>
8010677a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010677d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106784:	00 
80106785:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010678c:	00 
8010678d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106794:	00 
80106795:	89 04 24             	mov    %eax,(%esp)
80106798:	e8 5f fc ff ff       	call   801063fc <create>
8010679d:	89 45 f4             	mov    %eax,-0xc(%ebp)
801067a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067a4:	75 0c                	jne    801067b2 <sys_mkdir+0x5a>
    end_op();
801067a6:	e8 7a d0 ff ff       	call   80103825 <end_op>
    return -1;
801067ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067b0:	eb 15                	jmp    801067c7 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801067b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067b5:	89 04 24             	mov    %eax,(%esp)
801067b8:	e8 a4 b3 ff ff       	call   80101b61 <iunlockput>
  end_op();
801067bd:	e8 63 d0 ff ff       	call   80103825 <end_op>
  return 0;
801067c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067c7:	c9                   	leave  
801067c8:	c3                   	ret    

801067c9 <sys_mknod>:

int
sys_mknod(void)
{
801067c9:	55                   	push   %ebp
801067ca:	89 e5                	mov    %esp,%ebp
801067cc:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801067cf:	e8 cd cf ff ff       	call   801037a1 <begin_op>
  if((argstr(0, &path)) < 0 ||
801067d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801067db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801067e2:	e8 c7 f4 ff ff       	call   80105cae <argstr>
801067e7:	85 c0                	test   %eax,%eax
801067e9:	78 5e                	js     80106849 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801067eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801067ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801067f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801067f9:	e8 1a f4 ff ff       	call   80105c18 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801067fe:	85 c0                	test   %eax,%eax
80106800:	78 47                	js     80106849 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106802:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106805:	89 44 24 04          	mov    %eax,0x4(%esp)
80106809:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106810:	e8 03 f4 ff ff       	call   80105c18 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106815:	85 c0                	test   %eax,%eax
80106817:	78 30                	js     80106849 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106819:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010681c:	0f bf c8             	movswl %ax,%ecx
8010681f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106822:	0f bf d0             	movswl %ax,%edx
80106825:	8b 45 f0             	mov    -0x10(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106828:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010682c:	89 54 24 08          	mov    %edx,0x8(%esp)
80106830:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106837:	00 
80106838:	89 04 24             	mov    %eax,(%esp)
8010683b:	e8 bc fb ff ff       	call   801063fc <create>
80106840:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106843:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106847:	75 0c                	jne    80106855 <sys_mknod+0x8c>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106849:	e8 d7 cf ff ff       	call   80103825 <end_op>
    return -1;
8010684e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106853:	eb 15                	jmp    8010686a <sys_mknod+0xa1>
  }
  iunlockput(ip);
80106855:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106858:	89 04 24             	mov    %eax,(%esp)
8010685b:	e8 01 b3 ff ff       	call   80101b61 <iunlockput>
  end_op();
80106860:	e8 c0 cf ff ff       	call   80103825 <end_op>
  return 0;
80106865:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010686a:	c9                   	leave  
8010686b:	c3                   	ret    

8010686c <sys_chdir>:

int
sys_chdir(void)
{
8010686c:	55                   	push   %ebp
8010686d:	89 e5                	mov    %esp,%ebp
8010686f:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106872:	e8 2a cf ff ff       	call   801037a1 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106877:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010687a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010687e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106885:	e8 24 f4 ff ff       	call   80105cae <argstr>
8010688a:	85 c0                	test   %eax,%eax
8010688c:	78 14                	js     801068a2 <sys_chdir+0x36>
8010688e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106891:	89 04 24             	mov    %eax,(%esp)
80106894:	e8 69 be ff ff       	call   80102702 <namei>
80106899:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010689c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801068a0:	75 0c                	jne    801068ae <sys_chdir+0x42>
    end_op();
801068a2:	e8 7e cf ff ff       	call   80103825 <end_op>
    return -1;
801068a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068ac:	eb 61                	jmp    8010690f <sys_chdir+0xa3>
  }
  ilock(ip);
801068ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068b1:	89 04 24             	mov    %eax,(%esp)
801068b4:	e8 b9 b0 ff ff       	call   80101972 <ilock>
  if(ip->type != T_DIR){
801068b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068bc:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801068c0:	66 83 f8 01          	cmp    $0x1,%ax
801068c4:	74 17                	je     801068dd <sys_chdir+0x71>
    iunlockput(ip);
801068c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068c9:	89 04 24             	mov    %eax,(%esp)
801068cc:	e8 90 b2 ff ff       	call   80101b61 <iunlockput>
    end_op();
801068d1:	e8 4f cf ff ff       	call   80103825 <end_op>
    return -1;
801068d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068db:	eb 32                	jmp    8010690f <sys_chdir+0xa3>
  }
  iunlock(ip);
801068dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068e0:	89 04 24             	mov    %eax,(%esp)
801068e3:	e8 a1 b1 ff ff       	call   80101a89 <iunlock>
  iput(proc->cwd);
801068e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068ee:	8b 40 68             	mov    0x68(%eax),%eax
801068f1:	89 04 24             	mov    %eax,(%esp)
801068f4:	e8 d4 b1 ff ff       	call   80101acd <iput>
  end_op();
801068f9:	e8 27 cf ff ff       	call   80103825 <end_op>
  proc->cwd = ip;
801068fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106904:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106907:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010690a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010690f:	c9                   	leave  
80106910:	c3                   	ret    

80106911 <sys_exec>:

int
sys_exec(void)
{
80106911:	55                   	push   %ebp
80106912:	89 e5                	mov    %esp,%ebp
80106914:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010691a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010691d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106921:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106928:	e8 81 f3 ff ff       	call   80105cae <argstr>
8010692d:	85 c0                	test   %eax,%eax
8010692f:	78 1a                	js     8010694b <sys_exec+0x3a>
80106931:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106937:	89 44 24 04          	mov    %eax,0x4(%esp)
8010693b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106942:	e8 d1 f2 ff ff       	call   80105c18 <argint>
80106947:	85 c0                	test   %eax,%eax
80106949:	79 0a                	jns    80106955 <sys_exec+0x44>
    return -1;
8010694b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106950:	e9 c8 00 00 00       	jmp    80106a1d <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
80106955:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010695c:	00 
8010695d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106964:	00 
80106965:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010696b:	89 04 24             	mov    %eax,(%esp)
8010696e:	e8 63 ef ff ff       	call   801058d6 <memset>
  for(i=0;; i++){
80106973:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010697a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010697d:	83 f8 1f             	cmp    $0x1f,%eax
80106980:	76 0a                	jbe    8010698c <sys_exec+0x7b>
      return -1;
80106982:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106987:	e9 91 00 00 00       	jmp    80106a1d <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010698c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010698f:	c1 e0 02             	shl    $0x2,%eax
80106992:	89 c2                	mov    %eax,%edx
80106994:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010699a:	01 c2                	add    %eax,%edx
8010699c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801069a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801069a6:	89 14 24             	mov    %edx,(%esp)
801069a9:	e8 ce f1 ff ff       	call   80105b7c <fetchint>
801069ae:	85 c0                	test   %eax,%eax
801069b0:	79 07                	jns    801069b9 <sys_exec+0xa8>
      return -1;
801069b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069b7:	eb 64                	jmp    80106a1d <sys_exec+0x10c>
    if(uarg == 0){
801069b9:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801069bf:	85 c0                	test   %eax,%eax
801069c1:	75 26                	jne    801069e9 <sys_exec+0xd8>
      argv[i] = 0;
801069c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069c6:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801069cd:	00 00 00 00 
      break;
801069d1:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801069d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069d5:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801069db:	89 54 24 04          	mov    %edx,0x4(%esp)
801069df:	89 04 24             	mov    %eax,(%esp)
801069e2:	e8 4b a1 ff ff       	call   80100b32 <exec>
801069e7:	eb 34                	jmp    80106a1d <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801069e9:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801069ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
801069f2:	c1 e2 02             	shl    $0x2,%edx
801069f5:	01 c2                	add    %eax,%edx
801069f7:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801069fd:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a01:	89 04 24             	mov    %eax,(%esp)
80106a04:	e8 ad f1 ff ff       	call   80105bb6 <fetchstr>
80106a09:	85 c0                	test   %eax,%eax
80106a0b:	79 07                	jns    80106a14 <sys_exec+0x103>
      return -1;
80106a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a12:	eb 09                	jmp    80106a1d <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106a14:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106a18:	e9 5d ff ff ff       	jmp    8010697a <sys_exec+0x69>
  return exec(path, argv);
}
80106a1d:	c9                   	leave  
80106a1e:	c3                   	ret    

80106a1f <sys_pipe>:

int
sys_pipe(void)
{
80106a1f:	55                   	push   %ebp
80106a20:	89 e5                	mov    %esp,%ebp
80106a22:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106a25:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106a2c:	00 
80106a2d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106a30:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a3b:	e8 06 f2 ff ff       	call   80105c46 <argptr>
80106a40:	85 c0                	test   %eax,%eax
80106a42:	79 0a                	jns    80106a4e <sys_pipe+0x2f>
    return -1;
80106a44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a49:	e9 9b 00 00 00       	jmp    80106ae9 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80106a4e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106a51:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a55:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106a58:	89 04 24             	mov    %eax,(%esp)
80106a5b:	e8 60 d7 ff ff       	call   801041c0 <pipealloc>
80106a60:	85 c0                	test   %eax,%eax
80106a62:	79 07                	jns    80106a6b <sys_pipe+0x4c>
    return -1;
80106a64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a69:	eb 7e                	jmp    80106ae9 <sys_pipe+0xca>
  fd0 = -1;
80106a6b:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106a72:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106a75:	89 04 24             	mov    %eax,(%esp)
80106a78:	e8 6c f3 ff ff       	call   80105de9 <fdalloc>
80106a7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106a80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a84:	78 14                	js     80106a9a <sys_pipe+0x7b>
80106a86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a89:	89 04 24             	mov    %eax,(%esp)
80106a8c:	e8 58 f3 ff ff       	call   80105de9 <fdalloc>
80106a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106a94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106a98:	79 37                	jns    80106ad1 <sys_pipe+0xb2>
    if(fd0 >= 0)
80106a9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a9e:	78 14                	js     80106ab4 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80106aa0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106aa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106aa9:	83 c2 08             	add    $0x8,%edx
80106aac:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106ab3:	00 
    fileclose(rf);
80106ab4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106ab7:	89 04 24             	mov    %eax,(%esp)
80106aba:	e8 83 a5 ff ff       	call   80101042 <fileclose>
    fileclose(wf);
80106abf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ac2:	89 04 24             	mov    %eax,(%esp)
80106ac5:	e8 78 a5 ff ff       	call   80101042 <fileclose>
    return -1;
80106aca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106acf:	eb 18                	jmp    80106ae9 <sys_pipe+0xca>
  }
  fd[0] = fd0;
80106ad1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106ad4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ad7:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106ad9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106adc:	8d 50 04             	lea    0x4(%eax),%edx
80106adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ae2:	89 02                	mov    %eax,(%edx)
  return 0;
80106ae4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ae9:	c9                   	leave  
80106aea:	c3                   	ret    

80106aeb <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106aeb:	55                   	push   %ebp
80106aec:	89 e5                	mov    %esp,%ebp
80106aee:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106af1:	e8 08 e2 ff ff       	call   80104cfe <fork>
}
80106af6:	c9                   	leave  
80106af7:	c3                   	ret    

80106af8 <sys_clone>:

int sys_clone(void)
{
80106af8:	55                   	push   %ebp
80106af9:	89 e5                	mov    %esp,%ebp
80106afb:	83 ec 28             	sub    $0x28,%esp
    void *stack, *arg;
    void *(*func)(void*);
    if(argptr(0,(void*)*&func, sizeof(func))<0 || argptr(1,(void*)&arg,sizeof(arg))<0 || argptr(2,(void*)&stack,sizeof(stack))<0)
80106afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106b01:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106b08:	00 
80106b09:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b0d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b14:	e8 2d f1 ff ff       	call   80105c46 <argptr>
80106b19:	85 c0                	test   %eax,%eax
80106b1b:	78 3e                	js     80106b5b <sys_clone+0x63>
80106b1d:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106b24:	00 
80106b25:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b28:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b2c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106b33:	e8 0e f1 ff ff       	call   80105c46 <argptr>
80106b38:	85 c0                	test   %eax,%eax
80106b3a:	78 1f                	js     80106b5b <sys_clone+0x63>
80106b3c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106b43:	00 
80106b44:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b47:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b4b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106b52:	e8 ef f0 ff ff       	call   80105c46 <argptr>
80106b57:	85 c0                	test   %eax,%eax
80106b59:	79 07                	jns    80106b62 <sys_clone+0x6a>
        return -1;
80106b5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b60:	eb 19                	jmp    80106b7b <sys_clone+0x83>
    
    return clone(func,arg,stack);
80106b62:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80106b65:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106b6b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106b6f:	89 54 24 04          	mov    %edx,0x4(%esp)
80106b73:	89 04 24             	mov    %eax,(%esp)
80106b76:	e8 65 dd ff ff       	call   801048e0 <clone>
}
80106b7b:	c9                   	leave  
80106b7c:	c3                   	ret    

80106b7d <sys_join>:

int sys_join(void)
{
80106b7d:	55                   	push   %ebp
80106b7e:	89 e5                	mov    %esp,%ebp
80106b80:	83 ec 28             	sub    $0x28,%esp
    void **stack;
    int tid;
    void **retval;
    if(argint(0, &tid)<0 || argptr(1, (void*)&stack, sizeof(stack))<0 || argptr(2, (void*)&retval, sizeof(retval))<0)
80106b83:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b86:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b91:	e8 82 f0 ff ff       	call   80105c18 <argint>
80106b96:	85 c0                	test   %eax,%eax
80106b98:	78 3e                	js     80106bd8 <sys_join+0x5b>
80106b9a:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106ba1:	00 
80106ba2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ba5:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ba9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106bb0:	e8 91 f0 ff ff       	call   80105c46 <argptr>
80106bb5:	85 c0                	test   %eax,%eax
80106bb7:	78 1f                	js     80106bd8 <sys_join+0x5b>
80106bb9:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106bc0:	00 
80106bc1:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106bc4:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bc8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106bcf:	e8 72 f0 ff ff       	call   80105c46 <argptr>
80106bd4:	85 c0                	test   %eax,%eax
80106bd6:	79 07                	jns    80106bdf <sys_join+0x62>
        return -1;
80106bd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bdd:	eb 19                	jmp    80106bf8 <sys_join+0x7b>
    return join(tid, stack,retval);
80106bdf:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80106be2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106be8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106bec:	89 54 24 04          	mov    %edx,0x4(%esp)
80106bf0:	89 04 24             	mov    %eax,(%esp)
80106bf3:	e8 e6 de ff ff       	call   80104ade <join>
}
80106bf8:	c9                   	leave  
80106bf9:	c3                   	ret    

80106bfa <sys_thexit>:

int
sys_thexit(void)
{
80106bfa:	55                   	push   %ebp
80106bfb:	89 e5                	mov    %esp,%ebp
80106bfd:	83 ec 08             	sub    $0x8,%esp
    thexit();
80106c00:	e8 27 e0 ff ff       	call   80104c2c <thexit>
    return 0;
80106c05:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c0a:	c9                   	leave  
80106c0b:	c3                   	ret    

80106c0c <sys_exit>:

int
sys_exit(void)
{
80106c0c:	55                   	push   %ebp
80106c0d:	89 e5                	mov    %esp,%ebp
80106c0f:	83 ec 08             	sub    $0x8,%esp
  exit();
80106c12:	e8 6f e2 ff ff       	call   80104e86 <exit>
  return 0;  // not reached
80106c17:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c1c:	c9                   	leave  
80106c1d:	c3                   	ret    

80106c1e <sys_wait>:

int
sys_wait(void)
{
80106c1e:	55                   	push   %ebp
80106c1f:	89 e5                	mov    %esp,%ebp
80106c21:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106c24:	e8 82 e3 ff ff       	call   80104fab <wait>
}
80106c29:	c9                   	leave  
80106c2a:	c3                   	ret    

80106c2b <sys_kill>:

int
sys_kill(void)
{
80106c2b:	55                   	push   %ebp
80106c2c:	89 e5                	mov    %esp,%ebp
80106c2e:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106c31:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c34:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c3f:	e8 d4 ef ff ff       	call   80105c18 <argint>
80106c44:	85 c0                	test   %eax,%eax
80106c46:	79 07                	jns    80106c4f <sys_kill+0x24>
    return -1;
80106c48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c4d:	eb 0b                	jmp    80106c5a <sys_kill+0x2f>
  return kill(pid);
80106c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c52:	89 04 24             	mov    %eax,(%esp)
80106c55:	e8 40 e7 ff ff       	call   8010539a <kill>
}
80106c5a:	c9                   	leave  
80106c5b:	c3                   	ret    

80106c5c <sys_getpid>:

int
sys_getpid(void)
{
80106c5c:	55                   	push   %ebp
80106c5d:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106c5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c65:	8b 40 10             	mov    0x10(%eax),%eax
}
80106c68:	5d                   	pop    %ebp
80106c69:	c3                   	ret    

80106c6a <sys_getppid>:

int
sys_getppid(void)
{
80106c6a:	55                   	push   %ebp
80106c6b:	89 e5                	mov    %esp,%ebp
    return proc->parent->pid;
80106c6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c73:	8b 40 14             	mov    0x14(%eax),%eax
80106c76:	8b 40 10             	mov    0x10(%eax),%eax
}
80106c79:	5d                   	pop    %ebp
80106c7a:	c3                   	ret    

80106c7b <sys_sbrk>:

int
sys_sbrk(void)
{
80106c7b:	55                   	push   %ebp
80106c7c:	89 e5                	mov    %esp,%ebp
80106c7e:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106c81:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c84:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c8f:	e8 84 ef ff ff       	call   80105c18 <argint>
80106c94:	85 c0                	test   %eax,%eax
80106c96:	79 07                	jns    80106c9f <sys_sbrk+0x24>
    return -1;
80106c98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c9d:	eb 24                	jmp    80106cc3 <sys_sbrk+0x48>
  addr = proc->sz;
80106c9f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ca5:	8b 00                	mov    (%eax),%eax
80106ca7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cad:	89 04 24             	mov    %eax,(%esp)
80106cb0:	e8 2c db ff ff       	call   801047e1 <growproc>
80106cb5:	85 c0                	test   %eax,%eax
80106cb7:	79 07                	jns    80106cc0 <sys_sbrk+0x45>
    return -1;
80106cb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cbe:	eb 03                	jmp    80106cc3 <sys_sbrk+0x48>
  return addr;
80106cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106cc3:	c9                   	leave  
80106cc4:	c3                   	ret    

80106cc5 <sys_sleep>:

int
sys_sleep(void)
{
80106cc5:	55                   	push   %ebp
80106cc6:	89 e5                	mov    %esp,%ebp
80106cc8:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106ccb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106cce:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cd2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106cd9:	e8 3a ef ff ff       	call   80105c18 <argint>
80106cde:	85 c0                	test   %eax,%eax
80106ce0:	79 07                	jns    80106ce9 <sys_sleep+0x24>
    return -1;
80106ce2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ce7:	eb 6c                	jmp    80106d55 <sys_sleep+0x90>
  acquire(&tickslock);
80106ce9:	c7 04 24 80 71 11 80 	movl   $0x80117180,(%esp)
80106cf0:	e8 78 e9 ff ff       	call   8010566d <acquire>
  ticks0 = ticks;
80106cf5:	a1 c0 79 11 80       	mov    0x801179c0,%eax
80106cfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106cfd:	eb 34                	jmp    80106d33 <sys_sleep+0x6e>
    if(proc->killed){
80106cff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d05:	8b 40 24             	mov    0x24(%eax),%eax
80106d08:	85 c0                	test   %eax,%eax
80106d0a:	74 13                	je     80106d1f <sys_sleep+0x5a>
      release(&tickslock);
80106d0c:	c7 04 24 80 71 11 80 	movl   $0x80117180,(%esp)
80106d13:	e8 bc e9 ff ff       	call   801056d4 <release>
      return -1;
80106d18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d1d:	eb 36                	jmp    80106d55 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80106d1f:	c7 44 24 04 80 71 11 	movl   $0x80117180,0x4(%esp)
80106d26:	80 
80106d27:	c7 04 24 c0 79 11 80 	movl   $0x801179c0,(%esp)
80106d2e:	e8 60 e5 ff ff       	call   80105293 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106d33:	a1 c0 79 11 80       	mov    0x801179c0,%eax
80106d38:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106d3b:	89 c2                	mov    %eax,%edx
80106d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d40:	39 c2                	cmp    %eax,%edx
80106d42:	72 bb                	jb     80106cff <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106d44:	c7 04 24 80 71 11 80 	movl   $0x80117180,(%esp)
80106d4b:	e8 84 e9 ff ff       	call   801056d4 <release>
  return 0;
80106d50:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d55:	c9                   	leave  
80106d56:	c3                   	ret    

80106d57 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106d57:	55                   	push   %ebp
80106d58:	89 e5                	mov    %esp,%ebp
80106d5a:	83 ec 28             	sub    $0x28,%esp
  uint xticks;

  acquire(&tickslock);
80106d5d:	c7 04 24 80 71 11 80 	movl   $0x80117180,(%esp)
80106d64:	e8 04 e9 ff ff       	call   8010566d <acquire>
  xticks = ticks;
80106d69:	a1 c0 79 11 80       	mov    0x801179c0,%eax
80106d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106d71:	c7 04 24 80 71 11 80 	movl   $0x80117180,(%esp)
80106d78:	e8 57 e9 ff ff       	call   801056d4 <release>
  return xticks;
80106d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106d80:	c9                   	leave  
80106d81:	c3                   	ret    

80106d82 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106d82:	55                   	push   %ebp
80106d83:	89 e5                	mov    %esp,%ebp
80106d85:	83 ec 08             	sub    $0x8,%esp
80106d88:	8b 55 08             	mov    0x8(%ebp),%edx
80106d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d8e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106d92:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106d95:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106d99:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106d9d:	ee                   	out    %al,(%dx)
}
80106d9e:	c9                   	leave  
80106d9f:	c3                   	ret    

80106da0 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106da6:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106dad:	00 
80106dae:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106db5:	e8 c8 ff ff ff       	call   80106d82 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106dba:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106dc1:	00 
80106dc2:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106dc9:	e8 b4 ff ff ff       	call   80106d82 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106dce:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106dd5:	00 
80106dd6:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106ddd:	e8 a0 ff ff ff       	call   80106d82 <outb>
  picenable(IRQ_TIMER);
80106de2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106de9:	e8 65 d2 ff ff       	call   80104053 <picenable>
}
80106dee:	c9                   	leave  
80106def:	c3                   	ret    

80106df0 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106df0:	1e                   	push   %ds
  pushl %es
80106df1:	06                   	push   %es
  pushl %fs
80106df2:	0f a0                	push   %fs
  pushl %gs
80106df4:	0f a8                	push   %gs
  pushal
80106df6:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106df7:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106dfb:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106dfd:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106dff:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106e03:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106e05:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106e07:	54                   	push   %esp
  call trap
80106e08:	e8 54 02 00 00       	call   80107061 <trap>
  addl $4, %esp
80106e0d:	83 c4 04             	add    $0x4,%esp

80106e10 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106e10:	61                   	popa   
  popl %gs
80106e11:	0f a9                	pop    %gs
  popl %fs
80106e13:	0f a1                	pop    %fs
  popl %es
80106e15:	07                   	pop    %es
  popl %ds
80106e16:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106e17:	83 c4 08             	add    $0x8,%esp
  iret
80106e1a:	cf                   	iret   

80106e1b <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106e1b:	55                   	push   %ebp
80106e1c:	89 e5                	mov    %esp,%ebp
80106e1e:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106e21:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e24:	83 e8 01             	sub    $0x1,%eax
80106e27:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106e2b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e2e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106e32:	8b 45 08             	mov    0x8(%ebp),%eax
80106e35:	c1 e8 10             	shr    $0x10,%eax
80106e38:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106e3c:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106e3f:	0f 01 18             	lidtl  (%eax)
}
80106e42:	c9                   	leave  
80106e43:	c3                   	ret    

80106e44 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106e44:	55                   	push   %ebp
80106e45:	89 e5                	mov    %esp,%ebp
80106e47:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106e4a:	0f 20 d0             	mov    %cr2,%eax
80106e4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106e50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106e53:	c9                   	leave  
80106e54:	c3                   	ret    

80106e55 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106e55:	55                   	push   %ebp
80106e56:	89 e5                	mov    %esp,%ebp
80106e58:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106e5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106e62:	e9 c3 00 00 00       	jmp    80106f2a <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e6a:	8b 04 85 b4 c0 10 80 	mov    -0x7fef3f4c(,%eax,4),%eax
80106e71:	89 c2                	mov    %eax,%edx
80106e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e76:	66 89 14 c5 c0 71 11 	mov    %dx,-0x7fee8e40(,%eax,8)
80106e7d:	80 
80106e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e81:	66 c7 04 c5 c2 71 11 	movw   $0x8,-0x7fee8e3e(,%eax,8)
80106e88:	80 08 00 
80106e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e8e:	0f b6 14 c5 c4 71 11 	movzbl -0x7fee8e3c(,%eax,8),%edx
80106e95:	80 
80106e96:	83 e2 e0             	and    $0xffffffe0,%edx
80106e99:	88 14 c5 c4 71 11 80 	mov    %dl,-0x7fee8e3c(,%eax,8)
80106ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ea3:	0f b6 14 c5 c4 71 11 	movzbl -0x7fee8e3c(,%eax,8),%edx
80106eaa:	80 
80106eab:	83 e2 1f             	and    $0x1f,%edx
80106eae:	88 14 c5 c4 71 11 80 	mov    %dl,-0x7fee8e3c(,%eax,8)
80106eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106eb8:	0f b6 14 c5 c5 71 11 	movzbl -0x7fee8e3b(,%eax,8),%edx
80106ebf:	80 
80106ec0:	83 e2 f0             	and    $0xfffffff0,%edx
80106ec3:	83 ca 0e             	or     $0xe,%edx
80106ec6:	88 14 c5 c5 71 11 80 	mov    %dl,-0x7fee8e3b(,%eax,8)
80106ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ed0:	0f b6 14 c5 c5 71 11 	movzbl -0x7fee8e3b(,%eax,8),%edx
80106ed7:	80 
80106ed8:	83 e2 ef             	and    $0xffffffef,%edx
80106edb:	88 14 c5 c5 71 11 80 	mov    %dl,-0x7fee8e3b(,%eax,8)
80106ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ee5:	0f b6 14 c5 c5 71 11 	movzbl -0x7fee8e3b(,%eax,8),%edx
80106eec:	80 
80106eed:	83 e2 9f             	and    $0xffffff9f,%edx
80106ef0:	88 14 c5 c5 71 11 80 	mov    %dl,-0x7fee8e3b(,%eax,8)
80106ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106efa:	0f b6 14 c5 c5 71 11 	movzbl -0x7fee8e3b(,%eax,8),%edx
80106f01:	80 
80106f02:	83 ca 80             	or     $0xffffff80,%edx
80106f05:	88 14 c5 c5 71 11 80 	mov    %dl,-0x7fee8e3b(,%eax,8)
80106f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f0f:	8b 04 85 b4 c0 10 80 	mov    -0x7fef3f4c(,%eax,4),%eax
80106f16:	c1 e8 10             	shr    $0x10,%eax
80106f19:	89 c2                	mov    %eax,%edx
80106f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f1e:	66 89 14 c5 c6 71 11 	mov    %dx,-0x7fee8e3a(,%eax,8)
80106f25:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106f26:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106f2a:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106f31:	0f 8e 30 ff ff ff    	jle    80106e67 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106f37:	a1 b4 c1 10 80       	mov    0x8010c1b4,%eax
80106f3c:	66 a3 c0 73 11 80    	mov    %ax,0x801173c0
80106f42:	66 c7 05 c2 73 11 80 	movw   $0x8,0x801173c2
80106f49:	08 00 
80106f4b:	0f b6 05 c4 73 11 80 	movzbl 0x801173c4,%eax
80106f52:	83 e0 e0             	and    $0xffffffe0,%eax
80106f55:	a2 c4 73 11 80       	mov    %al,0x801173c4
80106f5a:	0f b6 05 c4 73 11 80 	movzbl 0x801173c4,%eax
80106f61:	83 e0 1f             	and    $0x1f,%eax
80106f64:	a2 c4 73 11 80       	mov    %al,0x801173c4
80106f69:	0f b6 05 c5 73 11 80 	movzbl 0x801173c5,%eax
80106f70:	83 c8 0f             	or     $0xf,%eax
80106f73:	a2 c5 73 11 80       	mov    %al,0x801173c5
80106f78:	0f b6 05 c5 73 11 80 	movzbl 0x801173c5,%eax
80106f7f:	83 e0 ef             	and    $0xffffffef,%eax
80106f82:	a2 c5 73 11 80       	mov    %al,0x801173c5
80106f87:	0f b6 05 c5 73 11 80 	movzbl 0x801173c5,%eax
80106f8e:	83 c8 60             	or     $0x60,%eax
80106f91:	a2 c5 73 11 80       	mov    %al,0x801173c5
80106f96:	0f b6 05 c5 73 11 80 	movzbl 0x801173c5,%eax
80106f9d:	83 c8 80             	or     $0xffffff80,%eax
80106fa0:	a2 c5 73 11 80       	mov    %al,0x801173c5
80106fa5:	a1 b4 c1 10 80       	mov    0x8010c1b4,%eax
80106faa:	c1 e8 10             	shr    $0x10,%eax
80106fad:	66 a3 c6 73 11 80    	mov    %ax,0x801173c6
  SETGATE(idt[U_CALL], 1, SEG_KCODE<<3, vectors[U_CALL], DPL_USER);
80106fb3:	a1 b4 c2 10 80       	mov    0x8010c2b4,%eax
80106fb8:	66 a3 c0 75 11 80    	mov    %ax,0x801175c0
80106fbe:	66 c7 05 c2 75 11 80 	movw   $0x8,0x801175c2
80106fc5:	08 00 
80106fc7:	0f b6 05 c4 75 11 80 	movzbl 0x801175c4,%eax
80106fce:	83 e0 e0             	and    $0xffffffe0,%eax
80106fd1:	a2 c4 75 11 80       	mov    %al,0x801175c4
80106fd6:	0f b6 05 c4 75 11 80 	movzbl 0x801175c4,%eax
80106fdd:	83 e0 1f             	and    $0x1f,%eax
80106fe0:	a2 c4 75 11 80       	mov    %al,0x801175c4
80106fe5:	0f b6 05 c5 75 11 80 	movzbl 0x801175c5,%eax
80106fec:	83 c8 0f             	or     $0xf,%eax
80106fef:	a2 c5 75 11 80       	mov    %al,0x801175c5
80106ff4:	0f b6 05 c5 75 11 80 	movzbl 0x801175c5,%eax
80106ffb:	83 e0 ef             	and    $0xffffffef,%eax
80106ffe:	a2 c5 75 11 80       	mov    %al,0x801175c5
80107003:	0f b6 05 c5 75 11 80 	movzbl 0x801175c5,%eax
8010700a:	83 c8 60             	or     $0x60,%eax
8010700d:	a2 c5 75 11 80       	mov    %al,0x801175c5
80107012:	0f b6 05 c5 75 11 80 	movzbl 0x801175c5,%eax
80107019:	83 c8 80             	or     $0xffffff80,%eax
8010701c:	a2 c5 75 11 80       	mov    %al,0x801175c5
80107021:	a1 b4 c2 10 80       	mov    0x8010c2b4,%eax
80107026:	c1 e8 10             	shr    $0x10,%eax
80107029:	66 a3 c6 75 11 80    	mov    %ax,0x801175c6
  initlock(&tickslock, "time");
8010702f:	c7 44 24 04 c0 93 10 	movl   $0x801093c0,0x4(%esp)
80107036:	80 
80107037:	c7 04 24 80 71 11 80 	movl   $0x80117180,(%esp)
8010703e:	e8 09 e6 ff ff       	call   8010564c <initlock>
}
80107043:	c9                   	leave  
80107044:	c3                   	ret    

80107045 <idtinit>:

void
idtinit(void)
{
80107045:	55                   	push   %ebp
80107046:	89 e5                	mov    %esp,%ebp
80107048:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
8010704b:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80107052:	00 
80107053:	c7 04 24 c0 71 11 80 	movl   $0x801171c0,(%esp)
8010705a:	e8 bc fd ff ff       	call   80106e1b <lidt>
}
8010705f:	c9                   	leave  
80107060:	c3                   	ret    

80107061 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107061:	55                   	push   %ebp
80107062:	89 e5                	mov    %esp,%ebp
80107064:	57                   	push   %edi
80107065:	56                   	push   %esi
80107066:	53                   	push   %ebx
80107067:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
8010706a:	8b 45 08             	mov    0x8(%ebp),%eax
8010706d:	8b 40 30             	mov    0x30(%eax),%eax
80107070:	83 f8 40             	cmp    $0x40,%eax
80107073:	75 3f                	jne    801070b4 <trap+0x53>
    if(proc->killed)
80107075:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010707b:	8b 40 24             	mov    0x24(%eax),%eax
8010707e:	85 c0                	test   %eax,%eax
80107080:	74 05                	je     80107087 <trap+0x26>
      exit();
80107082:	e8 ff dd ff ff       	call   80104e86 <exit>
    proc->tf = tf;
80107087:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010708d:	8b 55 08             	mov    0x8(%ebp),%edx
80107090:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80107093:	e8 4d ec ff ff       	call   80105ce5 <syscall>
    if(proc->killed)
80107098:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010709e:	8b 40 24             	mov    0x24(%eax),%eax
801070a1:	85 c0                	test   %eax,%eax
801070a3:	74 0a                	je     801070af <trap+0x4e>
      exit();
801070a5:	e8 dc dd ff ff       	call   80104e86 <exit>
    return;
801070aa:	e9 6f 02 00 00       	jmp    8010731e <trap+0x2bd>
801070af:	e9 6a 02 00 00       	jmp    8010731e <trap+0x2bd>
  }

  /* practice*/
  if(tf->trapno == U_CALL){
801070b4:	8b 45 08             	mov    0x8(%ebp),%eax
801070b7:	8b 40 30             	mov    0x30(%eax),%eax
801070ba:	3d 80 00 00 00       	cmp    $0x80,%eax
801070bf:	75 4b                	jne    8010710c <trap+0xab>
      if(proc->killed)
801070c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070c7:	8b 40 24             	mov    0x24(%eax),%eax
801070ca:	85 c0                	test   %eax,%eax
801070cc:	74 05                	je     801070d3 <trap+0x72>
          exit();
801070ce:	e8 b3 dd ff ff       	call   80104e86 <exit>
      proc->tf = tf;
801070d3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070d9:	8b 55 08             	mov    0x8(%ebp),%edx
801070dc:	89 50 18             	mov    %edx,0x18(%eax)
      cprintf("user interrupt 128 called!\n");
801070df:	c7 04 24 c5 93 10 80 	movl   $0x801093c5,(%esp)
801070e6:	e8 dd 92 ff ff       	call   801003c8 <cprintf>
      exit();
801070eb:	e8 96 dd ff ff       	call   80104e86 <exit>
      if(proc->killed)
801070f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070f6:	8b 40 24             	mov    0x24(%eax),%eax
801070f9:	85 c0                	test   %eax,%eax
801070fb:	74 0a                	je     80107107 <trap+0xa6>
        exit();
801070fd:	e8 84 dd ff ff       	call   80104e86 <exit>
      return;
80107102:	e9 17 02 00 00       	jmp    8010731e <trap+0x2bd>
80107107:	e9 12 02 00 00       	jmp    8010731e <trap+0x2bd>
  }

  switch(tf->trapno){
8010710c:	8b 45 08             	mov    0x8(%ebp),%eax
8010710f:	8b 40 30             	mov    0x30(%eax),%eax
80107112:	83 e8 20             	sub    $0x20,%eax
80107115:	83 f8 1f             	cmp    $0x1f,%eax
80107118:	0f 87 b1 00 00 00    	ja     801071cf <trap+0x16e>
8010711e:	8b 04 85 84 94 10 80 	mov    -0x7fef6b7c(,%eax,4),%eax
80107125:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80107127:	e8 a3 c0 ff ff       	call   801031cf <cpunum>
8010712c:	85 c0                	test   %eax,%eax
8010712e:	75 31                	jne    80107161 <trap+0x100>
      acquire(&tickslock);
80107130:	c7 04 24 80 71 11 80 	movl   $0x80117180,(%esp)
80107137:	e8 31 e5 ff ff       	call   8010566d <acquire>
      ticks++;
8010713c:	a1 c0 79 11 80       	mov    0x801179c0,%eax
80107141:	83 c0 01             	add    $0x1,%eax
80107144:	a3 c0 79 11 80       	mov    %eax,0x801179c0
      wakeup(&ticks);
80107149:	c7 04 24 c0 79 11 80 	movl   $0x801179c0,(%esp)
80107150:	e8 1a e2 ff ff       	call   8010536f <wakeup>
      release(&tickslock);
80107155:	c7 04 24 80 71 11 80 	movl   $0x80117180,(%esp)
8010715c:	e8 73 e5 ff ff       	call   801056d4 <release>
    }
    lapiceoi();
80107161:	e8 05 c1 ff ff       	call   8010326b <lapiceoi>
    break;
80107166:	e9 2f 01 00 00       	jmp    8010729a <trap+0x239>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
8010716b:	e8 cf b8 ff ff       	call   80102a3f <ideintr>
    lapiceoi();
80107170:	e8 f6 c0 ff ff       	call   8010326b <lapiceoi>
    break;
80107175:	e9 20 01 00 00       	jmp    8010729a <trap+0x239>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010717a:	e8 77 be ff ff       	call   80102ff6 <kbdintr>
    lapiceoi();
8010717f:	e8 e7 c0 ff ff       	call   8010326b <lapiceoi>
    break;
80107184:	e9 11 01 00 00       	jmp    8010729a <trap+0x239>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107189:	e8 85 03 00 00       	call   80107513 <uartintr>
    lapiceoi();
8010718e:	e8 d8 c0 ff ff       	call   8010326b <lapiceoi>
    break;
80107193:	e9 02 01 00 00       	jmp    8010729a <trap+0x239>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107198:	8b 45 08             	mov    0x8(%ebp),%eax
8010719b:	8b 70 38             	mov    0x38(%eax),%esi
            cpunum(), tf->cs, tf->eip);
8010719e:	8b 45 08             	mov    0x8(%ebp),%eax
801071a1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801071a5:	0f b7 d8             	movzwl %ax,%ebx
801071a8:	e8 22 c0 ff ff       	call   801031cf <cpunum>
801071ad:	89 74 24 0c          	mov    %esi,0xc(%esp)
801071b1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801071b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801071b9:	c7 04 24 e4 93 10 80 	movl   $0x801093e4,(%esp)
801071c0:	e8 03 92 ff ff       	call   801003c8 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
801071c5:	e8 a1 c0 ff ff       	call   8010326b <lapiceoi>
    break;
801071ca:	e9 cb 00 00 00       	jmp    8010729a <trap+0x239>

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801071cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071d5:	85 c0                	test   %eax,%eax
801071d7:	74 11                	je     801071ea <trap+0x189>
801071d9:	8b 45 08             	mov    0x8(%ebp),%eax
801071dc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801071e0:	0f b7 c0             	movzwl %ax,%eax
801071e3:	83 e0 03             	and    $0x3,%eax
801071e6:	85 c0                	test   %eax,%eax
801071e8:	75 40                	jne    8010722a <trap+0x1c9>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801071ea:	e8 55 fc ff ff       	call   80106e44 <rcr2>
801071ef:	89 c3                	mov    %eax,%ebx
801071f1:	8b 45 08             	mov    0x8(%ebp),%eax
801071f4:	8b 70 38             	mov    0x38(%eax),%esi
801071f7:	e8 d3 bf ff ff       	call   801031cf <cpunum>
801071fc:	8b 55 08             	mov    0x8(%ebp),%edx
801071ff:	8b 52 30             	mov    0x30(%edx),%edx
80107202:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80107206:	89 74 24 0c          	mov    %esi,0xc(%esp)
8010720a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010720e:	89 54 24 04          	mov    %edx,0x4(%esp)
80107212:	c7 04 24 08 94 10 80 	movl   $0x80109408,(%esp)
80107219:	e8 aa 91 ff ff       	call   801003c8 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
8010721e:	c7 04 24 3a 94 10 80 	movl   $0x8010943a,(%esp)
80107225:	e8 38 93 ff ff       	call   80100562 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010722a:	e8 15 fc ff ff       	call   80106e44 <rcr2>
8010722f:	89 c3                	mov    %eax,%ebx
80107231:	8b 45 08             	mov    0x8(%ebp),%eax
80107234:	8b 78 38             	mov    0x38(%eax),%edi
80107237:	e8 93 bf ff ff       	call   801031cf <cpunum>
8010723c:	89 c2                	mov    %eax,%edx
8010723e:	8b 45 08             	mov    0x8(%ebp),%eax
80107241:	8b 70 34             	mov    0x34(%eax),%esi
80107244:	8b 45 08             	mov    0x8(%ebp),%eax
80107247:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
8010724a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107250:	83 c0 6c             	add    $0x6c,%eax
80107253:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107256:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010725c:	8b 40 10             	mov    0x10(%eax),%eax
8010725f:	89 5c 24 1c          	mov    %ebx,0x1c(%esp)
80107263:	89 7c 24 18          	mov    %edi,0x18(%esp)
80107267:	89 54 24 14          	mov    %edx,0x14(%esp)
8010726b:	89 74 24 10          	mov    %esi,0x10(%esp)
8010726f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80107273:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107276:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010727a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010727e:	c7 04 24 40 94 10 80 	movl   $0x80109440,(%esp)
80107285:	e8 3e 91 ff ff       	call   801003c8 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
8010728a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107290:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107297:	eb 01                	jmp    8010729a <trap+0x239>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107299:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010729a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072a0:	85 c0                	test   %eax,%eax
801072a2:	74 24                	je     801072c8 <trap+0x267>
801072a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072aa:	8b 40 24             	mov    0x24(%eax),%eax
801072ad:	85 c0                	test   %eax,%eax
801072af:	74 17                	je     801072c8 <trap+0x267>
801072b1:	8b 45 08             	mov    0x8(%ebp),%eax
801072b4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801072b8:	0f b7 c0             	movzwl %ax,%eax
801072bb:	83 e0 03             	and    $0x3,%eax
801072be:	83 f8 03             	cmp    $0x3,%eax
801072c1:	75 05                	jne    801072c8 <trap+0x267>
    exit();
801072c3:	e8 be db ff ff       	call   80104e86 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801072c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072ce:	85 c0                	test   %eax,%eax
801072d0:	74 1e                	je     801072f0 <trap+0x28f>
801072d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072d8:	8b 40 0c             	mov    0xc(%eax),%eax
801072db:	83 f8 04             	cmp    $0x4,%eax
801072de:	75 10                	jne    801072f0 <trap+0x28f>
801072e0:	8b 45 08             	mov    0x8(%ebp),%eax
801072e3:	8b 40 30             	mov    0x30(%eax),%eax
801072e6:	83 f8 20             	cmp    $0x20,%eax
801072e9:	75 05                	jne    801072f0 <trap+0x28f>
    yield();
801072eb:	e8 32 df ff ff       	call   80105222 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801072f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072f6:	85 c0                	test   %eax,%eax
801072f8:	74 24                	je     8010731e <trap+0x2bd>
801072fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107300:	8b 40 24             	mov    0x24(%eax),%eax
80107303:	85 c0                	test   %eax,%eax
80107305:	74 17                	je     8010731e <trap+0x2bd>
80107307:	8b 45 08             	mov    0x8(%ebp),%eax
8010730a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010730e:	0f b7 c0             	movzwl %ax,%eax
80107311:	83 e0 03             	and    $0x3,%eax
80107314:	83 f8 03             	cmp    $0x3,%eax
80107317:	75 05                	jne    8010731e <trap+0x2bd>
    exit();
80107319:	e8 68 db ff ff       	call   80104e86 <exit>
}
8010731e:	83 c4 3c             	add    $0x3c,%esp
80107321:	5b                   	pop    %ebx
80107322:	5e                   	pop    %esi
80107323:	5f                   	pop    %edi
80107324:	5d                   	pop    %ebp
80107325:	c3                   	ret    

80107326 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80107326:	55                   	push   %ebp
80107327:	89 e5                	mov    %esp,%ebp
80107329:	83 ec 14             	sub    $0x14,%esp
8010732c:	8b 45 08             	mov    0x8(%ebp),%eax
8010732f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107333:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107337:	89 c2                	mov    %eax,%edx
80107339:	ec                   	in     (%dx),%al
8010733a:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010733d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107341:	c9                   	leave  
80107342:	c3                   	ret    

80107343 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107343:	55                   	push   %ebp
80107344:	89 e5                	mov    %esp,%ebp
80107346:	83 ec 08             	sub    $0x8,%esp
80107349:	8b 55 08             	mov    0x8(%ebp),%edx
8010734c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010734f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107353:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107356:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010735a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010735e:	ee                   	out    %al,(%dx)
}
8010735f:	c9                   	leave  
80107360:	c3                   	ret    

80107361 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107361:	55                   	push   %ebp
80107362:	89 e5                	mov    %esp,%ebp
80107364:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107367:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010736e:	00 
8010736f:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80107376:	e8 c8 ff ff ff       	call   80107343 <outb>

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
8010737b:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80107382:	00 
80107383:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
8010738a:	e8 b4 ff ff ff       	call   80107343 <outb>
  outb(COM1+0, 115200/9600);
8010738f:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80107396:	00 
80107397:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010739e:	e8 a0 ff ff ff       	call   80107343 <outb>
  outb(COM1+1, 0);
801073a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801073aa:	00 
801073ab:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801073b2:	e8 8c ff ff ff       	call   80107343 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801073b7:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801073be:	00 
801073bf:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801073c6:	e8 78 ff ff ff       	call   80107343 <outb>
  outb(COM1+4, 0);
801073cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801073d2:	00 
801073d3:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
801073da:	e8 64 ff ff ff       	call   80107343 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801073df:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801073e6:	00 
801073e7:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801073ee:	e8 50 ff ff ff       	call   80107343 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801073f3:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801073fa:	e8 27 ff ff ff       	call   80107326 <inb>
801073ff:	3c ff                	cmp    $0xff,%al
80107401:	75 02                	jne    80107405 <uartinit+0xa4>
    return;
80107403:	eb 6a                	jmp    8010746f <uartinit+0x10e>
  uart = 1;
80107405:	c7 05 68 c6 10 80 01 	movl   $0x1,0x8010c668
8010740c:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
8010740f:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80107416:	e8 0b ff ff ff       	call   80107326 <inb>
  inb(COM1+0);
8010741b:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107422:	e8 ff fe ff ff       	call   80107326 <inb>
  picenable(IRQ_COM1);
80107427:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010742e:	e8 20 cc ff ff       	call   80104053 <picenable>
  ioapicenable(IRQ_COM1, 0);
80107433:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010743a:	00 
8010743b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107442:	e8 7d b8 ff ff       	call   80102cc4 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107447:	c7 45 f4 04 95 10 80 	movl   $0x80109504,-0xc(%ebp)
8010744e:	eb 15                	jmp    80107465 <uartinit+0x104>
    uartputc(*p);
80107450:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107453:	0f b6 00             	movzbl (%eax),%eax
80107456:	0f be c0             	movsbl %al,%eax
80107459:	89 04 24             	mov    %eax,(%esp)
8010745c:	e8 10 00 00 00       	call   80107471 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107461:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107465:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107468:	0f b6 00             	movzbl (%eax),%eax
8010746b:	84 c0                	test   %al,%al
8010746d:	75 e1                	jne    80107450 <uartinit+0xef>
    uartputc(*p);
}
8010746f:	c9                   	leave  
80107470:	c3                   	ret    

80107471 <uartputc>:

void
uartputc(int c)
{
80107471:	55                   	push   %ebp
80107472:	89 e5                	mov    %esp,%ebp
80107474:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80107477:	a1 68 c6 10 80       	mov    0x8010c668,%eax
8010747c:	85 c0                	test   %eax,%eax
8010747e:	75 02                	jne    80107482 <uartputc+0x11>
    return;
80107480:	eb 4b                	jmp    801074cd <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107482:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107489:	eb 10                	jmp    8010749b <uartputc+0x2a>
    microdelay(10);
8010748b:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80107492:	e8 f9 bd ff ff       	call   80103290 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107497:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010749b:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010749f:	7f 16                	jg     801074b7 <uartputc+0x46>
801074a1:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801074a8:	e8 79 fe ff ff       	call   80107326 <inb>
801074ad:	0f b6 c0             	movzbl %al,%eax
801074b0:	83 e0 20             	and    $0x20,%eax
801074b3:	85 c0                	test   %eax,%eax
801074b5:	74 d4                	je     8010748b <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
801074b7:	8b 45 08             	mov    0x8(%ebp),%eax
801074ba:	0f b6 c0             	movzbl %al,%eax
801074bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801074c1:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801074c8:	e8 76 fe ff ff       	call   80107343 <outb>
}
801074cd:	c9                   	leave  
801074ce:	c3                   	ret    

801074cf <uartgetc>:

static int
uartgetc(void)
{
801074cf:	55                   	push   %ebp
801074d0:	89 e5                	mov    %esp,%ebp
801074d2:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
801074d5:	a1 68 c6 10 80       	mov    0x8010c668,%eax
801074da:	85 c0                	test   %eax,%eax
801074dc:	75 07                	jne    801074e5 <uartgetc+0x16>
    return -1;
801074de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074e3:	eb 2c                	jmp    80107511 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
801074e5:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801074ec:	e8 35 fe ff ff       	call   80107326 <inb>
801074f1:	0f b6 c0             	movzbl %al,%eax
801074f4:	83 e0 01             	and    $0x1,%eax
801074f7:	85 c0                	test   %eax,%eax
801074f9:	75 07                	jne    80107502 <uartgetc+0x33>
    return -1;
801074fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107500:	eb 0f                	jmp    80107511 <uartgetc+0x42>
  return inb(COM1+0);
80107502:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107509:	e8 18 fe ff ff       	call   80107326 <inb>
8010750e:	0f b6 c0             	movzbl %al,%eax
}
80107511:	c9                   	leave  
80107512:	c3                   	ret    

80107513 <uartintr>:

void
uartintr(void)
{
80107513:	55                   	push   %ebp
80107514:	89 e5                	mov    %esp,%ebp
80107516:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80107519:	c7 04 24 cf 74 10 80 	movl   $0x801074cf,(%esp)
80107520:	e8 cb 92 ff ff       	call   801007f0 <consoleintr>
}
80107525:	c9                   	leave  
80107526:	c3                   	ret    

80107527 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $0
80107529:	6a 00                	push   $0x0
  jmp alltraps
8010752b:	e9 c0 f8 ff ff       	jmp    80106df0 <alltraps>

80107530 <vector1>:
.globl vector1
vector1:
  pushl $0
80107530:	6a 00                	push   $0x0
  pushl $1
80107532:	6a 01                	push   $0x1
  jmp alltraps
80107534:	e9 b7 f8 ff ff       	jmp    80106df0 <alltraps>

80107539 <vector2>:
.globl vector2
vector2:
  pushl $0
80107539:	6a 00                	push   $0x0
  pushl $2
8010753b:	6a 02                	push   $0x2
  jmp alltraps
8010753d:	e9 ae f8 ff ff       	jmp    80106df0 <alltraps>

80107542 <vector3>:
.globl vector3
vector3:
  pushl $0
80107542:	6a 00                	push   $0x0
  pushl $3
80107544:	6a 03                	push   $0x3
  jmp alltraps
80107546:	e9 a5 f8 ff ff       	jmp    80106df0 <alltraps>

8010754b <vector4>:
.globl vector4
vector4:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $4
8010754d:	6a 04                	push   $0x4
  jmp alltraps
8010754f:	e9 9c f8 ff ff       	jmp    80106df0 <alltraps>

80107554 <vector5>:
.globl vector5
vector5:
  pushl $0
80107554:	6a 00                	push   $0x0
  pushl $5
80107556:	6a 05                	push   $0x5
  jmp alltraps
80107558:	e9 93 f8 ff ff       	jmp    80106df0 <alltraps>

8010755d <vector6>:
.globl vector6
vector6:
  pushl $0
8010755d:	6a 00                	push   $0x0
  pushl $6
8010755f:	6a 06                	push   $0x6
  jmp alltraps
80107561:	e9 8a f8 ff ff       	jmp    80106df0 <alltraps>

80107566 <vector7>:
.globl vector7
vector7:
  pushl $0
80107566:	6a 00                	push   $0x0
  pushl $7
80107568:	6a 07                	push   $0x7
  jmp alltraps
8010756a:	e9 81 f8 ff ff       	jmp    80106df0 <alltraps>

8010756f <vector8>:
.globl vector8
vector8:
  pushl $8
8010756f:	6a 08                	push   $0x8
  jmp alltraps
80107571:	e9 7a f8 ff ff       	jmp    80106df0 <alltraps>

80107576 <vector9>:
.globl vector9
vector9:
  pushl $0
80107576:	6a 00                	push   $0x0
  pushl $9
80107578:	6a 09                	push   $0x9
  jmp alltraps
8010757a:	e9 71 f8 ff ff       	jmp    80106df0 <alltraps>

8010757f <vector10>:
.globl vector10
vector10:
  pushl $10
8010757f:	6a 0a                	push   $0xa
  jmp alltraps
80107581:	e9 6a f8 ff ff       	jmp    80106df0 <alltraps>

80107586 <vector11>:
.globl vector11
vector11:
  pushl $11
80107586:	6a 0b                	push   $0xb
  jmp alltraps
80107588:	e9 63 f8 ff ff       	jmp    80106df0 <alltraps>

8010758d <vector12>:
.globl vector12
vector12:
  pushl $12
8010758d:	6a 0c                	push   $0xc
  jmp alltraps
8010758f:	e9 5c f8 ff ff       	jmp    80106df0 <alltraps>

80107594 <vector13>:
.globl vector13
vector13:
  pushl $13
80107594:	6a 0d                	push   $0xd
  jmp alltraps
80107596:	e9 55 f8 ff ff       	jmp    80106df0 <alltraps>

8010759b <vector14>:
.globl vector14
vector14:
  pushl $14
8010759b:	6a 0e                	push   $0xe
  jmp alltraps
8010759d:	e9 4e f8 ff ff       	jmp    80106df0 <alltraps>

801075a2 <vector15>:
.globl vector15
vector15:
  pushl $0
801075a2:	6a 00                	push   $0x0
  pushl $15
801075a4:	6a 0f                	push   $0xf
  jmp alltraps
801075a6:	e9 45 f8 ff ff       	jmp    80106df0 <alltraps>

801075ab <vector16>:
.globl vector16
vector16:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $16
801075ad:	6a 10                	push   $0x10
  jmp alltraps
801075af:	e9 3c f8 ff ff       	jmp    80106df0 <alltraps>

801075b4 <vector17>:
.globl vector17
vector17:
  pushl $17
801075b4:	6a 11                	push   $0x11
  jmp alltraps
801075b6:	e9 35 f8 ff ff       	jmp    80106df0 <alltraps>

801075bb <vector18>:
.globl vector18
vector18:
  pushl $0
801075bb:	6a 00                	push   $0x0
  pushl $18
801075bd:	6a 12                	push   $0x12
  jmp alltraps
801075bf:	e9 2c f8 ff ff       	jmp    80106df0 <alltraps>

801075c4 <vector19>:
.globl vector19
vector19:
  pushl $0
801075c4:	6a 00                	push   $0x0
  pushl $19
801075c6:	6a 13                	push   $0x13
  jmp alltraps
801075c8:	e9 23 f8 ff ff       	jmp    80106df0 <alltraps>

801075cd <vector20>:
.globl vector20
vector20:
  pushl $0
801075cd:	6a 00                	push   $0x0
  pushl $20
801075cf:	6a 14                	push   $0x14
  jmp alltraps
801075d1:	e9 1a f8 ff ff       	jmp    80106df0 <alltraps>

801075d6 <vector21>:
.globl vector21
vector21:
  pushl $0
801075d6:	6a 00                	push   $0x0
  pushl $21
801075d8:	6a 15                	push   $0x15
  jmp alltraps
801075da:	e9 11 f8 ff ff       	jmp    80106df0 <alltraps>

801075df <vector22>:
.globl vector22
vector22:
  pushl $0
801075df:	6a 00                	push   $0x0
  pushl $22
801075e1:	6a 16                	push   $0x16
  jmp alltraps
801075e3:	e9 08 f8 ff ff       	jmp    80106df0 <alltraps>

801075e8 <vector23>:
.globl vector23
vector23:
  pushl $0
801075e8:	6a 00                	push   $0x0
  pushl $23
801075ea:	6a 17                	push   $0x17
  jmp alltraps
801075ec:	e9 ff f7 ff ff       	jmp    80106df0 <alltraps>

801075f1 <vector24>:
.globl vector24
vector24:
  pushl $0
801075f1:	6a 00                	push   $0x0
  pushl $24
801075f3:	6a 18                	push   $0x18
  jmp alltraps
801075f5:	e9 f6 f7 ff ff       	jmp    80106df0 <alltraps>

801075fa <vector25>:
.globl vector25
vector25:
  pushl $0
801075fa:	6a 00                	push   $0x0
  pushl $25
801075fc:	6a 19                	push   $0x19
  jmp alltraps
801075fe:	e9 ed f7 ff ff       	jmp    80106df0 <alltraps>

80107603 <vector26>:
.globl vector26
vector26:
  pushl $0
80107603:	6a 00                	push   $0x0
  pushl $26
80107605:	6a 1a                	push   $0x1a
  jmp alltraps
80107607:	e9 e4 f7 ff ff       	jmp    80106df0 <alltraps>

8010760c <vector27>:
.globl vector27
vector27:
  pushl $0
8010760c:	6a 00                	push   $0x0
  pushl $27
8010760e:	6a 1b                	push   $0x1b
  jmp alltraps
80107610:	e9 db f7 ff ff       	jmp    80106df0 <alltraps>

80107615 <vector28>:
.globl vector28
vector28:
  pushl $0
80107615:	6a 00                	push   $0x0
  pushl $28
80107617:	6a 1c                	push   $0x1c
  jmp alltraps
80107619:	e9 d2 f7 ff ff       	jmp    80106df0 <alltraps>

8010761e <vector29>:
.globl vector29
vector29:
  pushl $0
8010761e:	6a 00                	push   $0x0
  pushl $29
80107620:	6a 1d                	push   $0x1d
  jmp alltraps
80107622:	e9 c9 f7 ff ff       	jmp    80106df0 <alltraps>

80107627 <vector30>:
.globl vector30
vector30:
  pushl $0
80107627:	6a 00                	push   $0x0
  pushl $30
80107629:	6a 1e                	push   $0x1e
  jmp alltraps
8010762b:	e9 c0 f7 ff ff       	jmp    80106df0 <alltraps>

80107630 <vector31>:
.globl vector31
vector31:
  pushl $0
80107630:	6a 00                	push   $0x0
  pushl $31
80107632:	6a 1f                	push   $0x1f
  jmp alltraps
80107634:	e9 b7 f7 ff ff       	jmp    80106df0 <alltraps>

80107639 <vector32>:
.globl vector32
vector32:
  pushl $0
80107639:	6a 00                	push   $0x0
  pushl $32
8010763b:	6a 20                	push   $0x20
  jmp alltraps
8010763d:	e9 ae f7 ff ff       	jmp    80106df0 <alltraps>

80107642 <vector33>:
.globl vector33
vector33:
  pushl $0
80107642:	6a 00                	push   $0x0
  pushl $33
80107644:	6a 21                	push   $0x21
  jmp alltraps
80107646:	e9 a5 f7 ff ff       	jmp    80106df0 <alltraps>

8010764b <vector34>:
.globl vector34
vector34:
  pushl $0
8010764b:	6a 00                	push   $0x0
  pushl $34
8010764d:	6a 22                	push   $0x22
  jmp alltraps
8010764f:	e9 9c f7 ff ff       	jmp    80106df0 <alltraps>

80107654 <vector35>:
.globl vector35
vector35:
  pushl $0
80107654:	6a 00                	push   $0x0
  pushl $35
80107656:	6a 23                	push   $0x23
  jmp alltraps
80107658:	e9 93 f7 ff ff       	jmp    80106df0 <alltraps>

8010765d <vector36>:
.globl vector36
vector36:
  pushl $0
8010765d:	6a 00                	push   $0x0
  pushl $36
8010765f:	6a 24                	push   $0x24
  jmp alltraps
80107661:	e9 8a f7 ff ff       	jmp    80106df0 <alltraps>

80107666 <vector37>:
.globl vector37
vector37:
  pushl $0
80107666:	6a 00                	push   $0x0
  pushl $37
80107668:	6a 25                	push   $0x25
  jmp alltraps
8010766a:	e9 81 f7 ff ff       	jmp    80106df0 <alltraps>

8010766f <vector38>:
.globl vector38
vector38:
  pushl $0
8010766f:	6a 00                	push   $0x0
  pushl $38
80107671:	6a 26                	push   $0x26
  jmp alltraps
80107673:	e9 78 f7 ff ff       	jmp    80106df0 <alltraps>

80107678 <vector39>:
.globl vector39
vector39:
  pushl $0
80107678:	6a 00                	push   $0x0
  pushl $39
8010767a:	6a 27                	push   $0x27
  jmp alltraps
8010767c:	e9 6f f7 ff ff       	jmp    80106df0 <alltraps>

80107681 <vector40>:
.globl vector40
vector40:
  pushl $0
80107681:	6a 00                	push   $0x0
  pushl $40
80107683:	6a 28                	push   $0x28
  jmp alltraps
80107685:	e9 66 f7 ff ff       	jmp    80106df0 <alltraps>

8010768a <vector41>:
.globl vector41
vector41:
  pushl $0
8010768a:	6a 00                	push   $0x0
  pushl $41
8010768c:	6a 29                	push   $0x29
  jmp alltraps
8010768e:	e9 5d f7 ff ff       	jmp    80106df0 <alltraps>

80107693 <vector42>:
.globl vector42
vector42:
  pushl $0
80107693:	6a 00                	push   $0x0
  pushl $42
80107695:	6a 2a                	push   $0x2a
  jmp alltraps
80107697:	e9 54 f7 ff ff       	jmp    80106df0 <alltraps>

8010769c <vector43>:
.globl vector43
vector43:
  pushl $0
8010769c:	6a 00                	push   $0x0
  pushl $43
8010769e:	6a 2b                	push   $0x2b
  jmp alltraps
801076a0:	e9 4b f7 ff ff       	jmp    80106df0 <alltraps>

801076a5 <vector44>:
.globl vector44
vector44:
  pushl $0
801076a5:	6a 00                	push   $0x0
  pushl $44
801076a7:	6a 2c                	push   $0x2c
  jmp alltraps
801076a9:	e9 42 f7 ff ff       	jmp    80106df0 <alltraps>

801076ae <vector45>:
.globl vector45
vector45:
  pushl $0
801076ae:	6a 00                	push   $0x0
  pushl $45
801076b0:	6a 2d                	push   $0x2d
  jmp alltraps
801076b2:	e9 39 f7 ff ff       	jmp    80106df0 <alltraps>

801076b7 <vector46>:
.globl vector46
vector46:
  pushl $0
801076b7:	6a 00                	push   $0x0
  pushl $46
801076b9:	6a 2e                	push   $0x2e
  jmp alltraps
801076bb:	e9 30 f7 ff ff       	jmp    80106df0 <alltraps>

801076c0 <vector47>:
.globl vector47
vector47:
  pushl $0
801076c0:	6a 00                	push   $0x0
  pushl $47
801076c2:	6a 2f                	push   $0x2f
  jmp alltraps
801076c4:	e9 27 f7 ff ff       	jmp    80106df0 <alltraps>

801076c9 <vector48>:
.globl vector48
vector48:
  pushl $0
801076c9:	6a 00                	push   $0x0
  pushl $48
801076cb:	6a 30                	push   $0x30
  jmp alltraps
801076cd:	e9 1e f7 ff ff       	jmp    80106df0 <alltraps>

801076d2 <vector49>:
.globl vector49
vector49:
  pushl $0
801076d2:	6a 00                	push   $0x0
  pushl $49
801076d4:	6a 31                	push   $0x31
  jmp alltraps
801076d6:	e9 15 f7 ff ff       	jmp    80106df0 <alltraps>

801076db <vector50>:
.globl vector50
vector50:
  pushl $0
801076db:	6a 00                	push   $0x0
  pushl $50
801076dd:	6a 32                	push   $0x32
  jmp alltraps
801076df:	e9 0c f7 ff ff       	jmp    80106df0 <alltraps>

801076e4 <vector51>:
.globl vector51
vector51:
  pushl $0
801076e4:	6a 00                	push   $0x0
  pushl $51
801076e6:	6a 33                	push   $0x33
  jmp alltraps
801076e8:	e9 03 f7 ff ff       	jmp    80106df0 <alltraps>

801076ed <vector52>:
.globl vector52
vector52:
  pushl $0
801076ed:	6a 00                	push   $0x0
  pushl $52
801076ef:	6a 34                	push   $0x34
  jmp alltraps
801076f1:	e9 fa f6 ff ff       	jmp    80106df0 <alltraps>

801076f6 <vector53>:
.globl vector53
vector53:
  pushl $0
801076f6:	6a 00                	push   $0x0
  pushl $53
801076f8:	6a 35                	push   $0x35
  jmp alltraps
801076fa:	e9 f1 f6 ff ff       	jmp    80106df0 <alltraps>

801076ff <vector54>:
.globl vector54
vector54:
  pushl $0
801076ff:	6a 00                	push   $0x0
  pushl $54
80107701:	6a 36                	push   $0x36
  jmp alltraps
80107703:	e9 e8 f6 ff ff       	jmp    80106df0 <alltraps>

80107708 <vector55>:
.globl vector55
vector55:
  pushl $0
80107708:	6a 00                	push   $0x0
  pushl $55
8010770a:	6a 37                	push   $0x37
  jmp alltraps
8010770c:	e9 df f6 ff ff       	jmp    80106df0 <alltraps>

80107711 <vector56>:
.globl vector56
vector56:
  pushl $0
80107711:	6a 00                	push   $0x0
  pushl $56
80107713:	6a 38                	push   $0x38
  jmp alltraps
80107715:	e9 d6 f6 ff ff       	jmp    80106df0 <alltraps>

8010771a <vector57>:
.globl vector57
vector57:
  pushl $0
8010771a:	6a 00                	push   $0x0
  pushl $57
8010771c:	6a 39                	push   $0x39
  jmp alltraps
8010771e:	e9 cd f6 ff ff       	jmp    80106df0 <alltraps>

80107723 <vector58>:
.globl vector58
vector58:
  pushl $0
80107723:	6a 00                	push   $0x0
  pushl $58
80107725:	6a 3a                	push   $0x3a
  jmp alltraps
80107727:	e9 c4 f6 ff ff       	jmp    80106df0 <alltraps>

8010772c <vector59>:
.globl vector59
vector59:
  pushl $0
8010772c:	6a 00                	push   $0x0
  pushl $59
8010772e:	6a 3b                	push   $0x3b
  jmp alltraps
80107730:	e9 bb f6 ff ff       	jmp    80106df0 <alltraps>

80107735 <vector60>:
.globl vector60
vector60:
  pushl $0
80107735:	6a 00                	push   $0x0
  pushl $60
80107737:	6a 3c                	push   $0x3c
  jmp alltraps
80107739:	e9 b2 f6 ff ff       	jmp    80106df0 <alltraps>

8010773e <vector61>:
.globl vector61
vector61:
  pushl $0
8010773e:	6a 00                	push   $0x0
  pushl $61
80107740:	6a 3d                	push   $0x3d
  jmp alltraps
80107742:	e9 a9 f6 ff ff       	jmp    80106df0 <alltraps>

80107747 <vector62>:
.globl vector62
vector62:
  pushl $0
80107747:	6a 00                	push   $0x0
  pushl $62
80107749:	6a 3e                	push   $0x3e
  jmp alltraps
8010774b:	e9 a0 f6 ff ff       	jmp    80106df0 <alltraps>

80107750 <vector63>:
.globl vector63
vector63:
  pushl $0
80107750:	6a 00                	push   $0x0
  pushl $63
80107752:	6a 3f                	push   $0x3f
  jmp alltraps
80107754:	e9 97 f6 ff ff       	jmp    80106df0 <alltraps>

80107759 <vector64>:
.globl vector64
vector64:
  pushl $0
80107759:	6a 00                	push   $0x0
  pushl $64
8010775b:	6a 40                	push   $0x40
  jmp alltraps
8010775d:	e9 8e f6 ff ff       	jmp    80106df0 <alltraps>

80107762 <vector65>:
.globl vector65
vector65:
  pushl $0
80107762:	6a 00                	push   $0x0
  pushl $65
80107764:	6a 41                	push   $0x41
  jmp alltraps
80107766:	e9 85 f6 ff ff       	jmp    80106df0 <alltraps>

8010776b <vector66>:
.globl vector66
vector66:
  pushl $0
8010776b:	6a 00                	push   $0x0
  pushl $66
8010776d:	6a 42                	push   $0x42
  jmp alltraps
8010776f:	e9 7c f6 ff ff       	jmp    80106df0 <alltraps>

80107774 <vector67>:
.globl vector67
vector67:
  pushl $0
80107774:	6a 00                	push   $0x0
  pushl $67
80107776:	6a 43                	push   $0x43
  jmp alltraps
80107778:	e9 73 f6 ff ff       	jmp    80106df0 <alltraps>

8010777d <vector68>:
.globl vector68
vector68:
  pushl $0
8010777d:	6a 00                	push   $0x0
  pushl $68
8010777f:	6a 44                	push   $0x44
  jmp alltraps
80107781:	e9 6a f6 ff ff       	jmp    80106df0 <alltraps>

80107786 <vector69>:
.globl vector69
vector69:
  pushl $0
80107786:	6a 00                	push   $0x0
  pushl $69
80107788:	6a 45                	push   $0x45
  jmp alltraps
8010778a:	e9 61 f6 ff ff       	jmp    80106df0 <alltraps>

8010778f <vector70>:
.globl vector70
vector70:
  pushl $0
8010778f:	6a 00                	push   $0x0
  pushl $70
80107791:	6a 46                	push   $0x46
  jmp alltraps
80107793:	e9 58 f6 ff ff       	jmp    80106df0 <alltraps>

80107798 <vector71>:
.globl vector71
vector71:
  pushl $0
80107798:	6a 00                	push   $0x0
  pushl $71
8010779a:	6a 47                	push   $0x47
  jmp alltraps
8010779c:	e9 4f f6 ff ff       	jmp    80106df0 <alltraps>

801077a1 <vector72>:
.globl vector72
vector72:
  pushl $0
801077a1:	6a 00                	push   $0x0
  pushl $72
801077a3:	6a 48                	push   $0x48
  jmp alltraps
801077a5:	e9 46 f6 ff ff       	jmp    80106df0 <alltraps>

801077aa <vector73>:
.globl vector73
vector73:
  pushl $0
801077aa:	6a 00                	push   $0x0
  pushl $73
801077ac:	6a 49                	push   $0x49
  jmp alltraps
801077ae:	e9 3d f6 ff ff       	jmp    80106df0 <alltraps>

801077b3 <vector74>:
.globl vector74
vector74:
  pushl $0
801077b3:	6a 00                	push   $0x0
  pushl $74
801077b5:	6a 4a                	push   $0x4a
  jmp alltraps
801077b7:	e9 34 f6 ff ff       	jmp    80106df0 <alltraps>

801077bc <vector75>:
.globl vector75
vector75:
  pushl $0
801077bc:	6a 00                	push   $0x0
  pushl $75
801077be:	6a 4b                	push   $0x4b
  jmp alltraps
801077c0:	e9 2b f6 ff ff       	jmp    80106df0 <alltraps>

801077c5 <vector76>:
.globl vector76
vector76:
  pushl $0
801077c5:	6a 00                	push   $0x0
  pushl $76
801077c7:	6a 4c                	push   $0x4c
  jmp alltraps
801077c9:	e9 22 f6 ff ff       	jmp    80106df0 <alltraps>

801077ce <vector77>:
.globl vector77
vector77:
  pushl $0
801077ce:	6a 00                	push   $0x0
  pushl $77
801077d0:	6a 4d                	push   $0x4d
  jmp alltraps
801077d2:	e9 19 f6 ff ff       	jmp    80106df0 <alltraps>

801077d7 <vector78>:
.globl vector78
vector78:
  pushl $0
801077d7:	6a 00                	push   $0x0
  pushl $78
801077d9:	6a 4e                	push   $0x4e
  jmp alltraps
801077db:	e9 10 f6 ff ff       	jmp    80106df0 <alltraps>

801077e0 <vector79>:
.globl vector79
vector79:
  pushl $0
801077e0:	6a 00                	push   $0x0
  pushl $79
801077e2:	6a 4f                	push   $0x4f
  jmp alltraps
801077e4:	e9 07 f6 ff ff       	jmp    80106df0 <alltraps>

801077e9 <vector80>:
.globl vector80
vector80:
  pushl $0
801077e9:	6a 00                	push   $0x0
  pushl $80
801077eb:	6a 50                	push   $0x50
  jmp alltraps
801077ed:	e9 fe f5 ff ff       	jmp    80106df0 <alltraps>

801077f2 <vector81>:
.globl vector81
vector81:
  pushl $0
801077f2:	6a 00                	push   $0x0
  pushl $81
801077f4:	6a 51                	push   $0x51
  jmp alltraps
801077f6:	e9 f5 f5 ff ff       	jmp    80106df0 <alltraps>

801077fb <vector82>:
.globl vector82
vector82:
  pushl $0
801077fb:	6a 00                	push   $0x0
  pushl $82
801077fd:	6a 52                	push   $0x52
  jmp alltraps
801077ff:	e9 ec f5 ff ff       	jmp    80106df0 <alltraps>

80107804 <vector83>:
.globl vector83
vector83:
  pushl $0
80107804:	6a 00                	push   $0x0
  pushl $83
80107806:	6a 53                	push   $0x53
  jmp alltraps
80107808:	e9 e3 f5 ff ff       	jmp    80106df0 <alltraps>

8010780d <vector84>:
.globl vector84
vector84:
  pushl $0
8010780d:	6a 00                	push   $0x0
  pushl $84
8010780f:	6a 54                	push   $0x54
  jmp alltraps
80107811:	e9 da f5 ff ff       	jmp    80106df0 <alltraps>

80107816 <vector85>:
.globl vector85
vector85:
  pushl $0
80107816:	6a 00                	push   $0x0
  pushl $85
80107818:	6a 55                	push   $0x55
  jmp alltraps
8010781a:	e9 d1 f5 ff ff       	jmp    80106df0 <alltraps>

8010781f <vector86>:
.globl vector86
vector86:
  pushl $0
8010781f:	6a 00                	push   $0x0
  pushl $86
80107821:	6a 56                	push   $0x56
  jmp alltraps
80107823:	e9 c8 f5 ff ff       	jmp    80106df0 <alltraps>

80107828 <vector87>:
.globl vector87
vector87:
  pushl $0
80107828:	6a 00                	push   $0x0
  pushl $87
8010782a:	6a 57                	push   $0x57
  jmp alltraps
8010782c:	e9 bf f5 ff ff       	jmp    80106df0 <alltraps>

80107831 <vector88>:
.globl vector88
vector88:
  pushl $0
80107831:	6a 00                	push   $0x0
  pushl $88
80107833:	6a 58                	push   $0x58
  jmp alltraps
80107835:	e9 b6 f5 ff ff       	jmp    80106df0 <alltraps>

8010783a <vector89>:
.globl vector89
vector89:
  pushl $0
8010783a:	6a 00                	push   $0x0
  pushl $89
8010783c:	6a 59                	push   $0x59
  jmp alltraps
8010783e:	e9 ad f5 ff ff       	jmp    80106df0 <alltraps>

80107843 <vector90>:
.globl vector90
vector90:
  pushl $0
80107843:	6a 00                	push   $0x0
  pushl $90
80107845:	6a 5a                	push   $0x5a
  jmp alltraps
80107847:	e9 a4 f5 ff ff       	jmp    80106df0 <alltraps>

8010784c <vector91>:
.globl vector91
vector91:
  pushl $0
8010784c:	6a 00                	push   $0x0
  pushl $91
8010784e:	6a 5b                	push   $0x5b
  jmp alltraps
80107850:	e9 9b f5 ff ff       	jmp    80106df0 <alltraps>

80107855 <vector92>:
.globl vector92
vector92:
  pushl $0
80107855:	6a 00                	push   $0x0
  pushl $92
80107857:	6a 5c                	push   $0x5c
  jmp alltraps
80107859:	e9 92 f5 ff ff       	jmp    80106df0 <alltraps>

8010785e <vector93>:
.globl vector93
vector93:
  pushl $0
8010785e:	6a 00                	push   $0x0
  pushl $93
80107860:	6a 5d                	push   $0x5d
  jmp alltraps
80107862:	e9 89 f5 ff ff       	jmp    80106df0 <alltraps>

80107867 <vector94>:
.globl vector94
vector94:
  pushl $0
80107867:	6a 00                	push   $0x0
  pushl $94
80107869:	6a 5e                	push   $0x5e
  jmp alltraps
8010786b:	e9 80 f5 ff ff       	jmp    80106df0 <alltraps>

80107870 <vector95>:
.globl vector95
vector95:
  pushl $0
80107870:	6a 00                	push   $0x0
  pushl $95
80107872:	6a 5f                	push   $0x5f
  jmp alltraps
80107874:	e9 77 f5 ff ff       	jmp    80106df0 <alltraps>

80107879 <vector96>:
.globl vector96
vector96:
  pushl $0
80107879:	6a 00                	push   $0x0
  pushl $96
8010787b:	6a 60                	push   $0x60
  jmp alltraps
8010787d:	e9 6e f5 ff ff       	jmp    80106df0 <alltraps>

80107882 <vector97>:
.globl vector97
vector97:
  pushl $0
80107882:	6a 00                	push   $0x0
  pushl $97
80107884:	6a 61                	push   $0x61
  jmp alltraps
80107886:	e9 65 f5 ff ff       	jmp    80106df0 <alltraps>

8010788b <vector98>:
.globl vector98
vector98:
  pushl $0
8010788b:	6a 00                	push   $0x0
  pushl $98
8010788d:	6a 62                	push   $0x62
  jmp alltraps
8010788f:	e9 5c f5 ff ff       	jmp    80106df0 <alltraps>

80107894 <vector99>:
.globl vector99
vector99:
  pushl $0
80107894:	6a 00                	push   $0x0
  pushl $99
80107896:	6a 63                	push   $0x63
  jmp alltraps
80107898:	e9 53 f5 ff ff       	jmp    80106df0 <alltraps>

8010789d <vector100>:
.globl vector100
vector100:
  pushl $0
8010789d:	6a 00                	push   $0x0
  pushl $100
8010789f:	6a 64                	push   $0x64
  jmp alltraps
801078a1:	e9 4a f5 ff ff       	jmp    80106df0 <alltraps>

801078a6 <vector101>:
.globl vector101
vector101:
  pushl $0
801078a6:	6a 00                	push   $0x0
  pushl $101
801078a8:	6a 65                	push   $0x65
  jmp alltraps
801078aa:	e9 41 f5 ff ff       	jmp    80106df0 <alltraps>

801078af <vector102>:
.globl vector102
vector102:
  pushl $0
801078af:	6a 00                	push   $0x0
  pushl $102
801078b1:	6a 66                	push   $0x66
  jmp alltraps
801078b3:	e9 38 f5 ff ff       	jmp    80106df0 <alltraps>

801078b8 <vector103>:
.globl vector103
vector103:
  pushl $0
801078b8:	6a 00                	push   $0x0
  pushl $103
801078ba:	6a 67                	push   $0x67
  jmp alltraps
801078bc:	e9 2f f5 ff ff       	jmp    80106df0 <alltraps>

801078c1 <vector104>:
.globl vector104
vector104:
  pushl $0
801078c1:	6a 00                	push   $0x0
  pushl $104
801078c3:	6a 68                	push   $0x68
  jmp alltraps
801078c5:	e9 26 f5 ff ff       	jmp    80106df0 <alltraps>

801078ca <vector105>:
.globl vector105
vector105:
  pushl $0
801078ca:	6a 00                	push   $0x0
  pushl $105
801078cc:	6a 69                	push   $0x69
  jmp alltraps
801078ce:	e9 1d f5 ff ff       	jmp    80106df0 <alltraps>

801078d3 <vector106>:
.globl vector106
vector106:
  pushl $0
801078d3:	6a 00                	push   $0x0
  pushl $106
801078d5:	6a 6a                	push   $0x6a
  jmp alltraps
801078d7:	e9 14 f5 ff ff       	jmp    80106df0 <alltraps>

801078dc <vector107>:
.globl vector107
vector107:
  pushl $0
801078dc:	6a 00                	push   $0x0
  pushl $107
801078de:	6a 6b                	push   $0x6b
  jmp alltraps
801078e0:	e9 0b f5 ff ff       	jmp    80106df0 <alltraps>

801078e5 <vector108>:
.globl vector108
vector108:
  pushl $0
801078e5:	6a 00                	push   $0x0
  pushl $108
801078e7:	6a 6c                	push   $0x6c
  jmp alltraps
801078e9:	e9 02 f5 ff ff       	jmp    80106df0 <alltraps>

801078ee <vector109>:
.globl vector109
vector109:
  pushl $0
801078ee:	6a 00                	push   $0x0
  pushl $109
801078f0:	6a 6d                	push   $0x6d
  jmp alltraps
801078f2:	e9 f9 f4 ff ff       	jmp    80106df0 <alltraps>

801078f7 <vector110>:
.globl vector110
vector110:
  pushl $0
801078f7:	6a 00                	push   $0x0
  pushl $110
801078f9:	6a 6e                	push   $0x6e
  jmp alltraps
801078fb:	e9 f0 f4 ff ff       	jmp    80106df0 <alltraps>

80107900 <vector111>:
.globl vector111
vector111:
  pushl $0
80107900:	6a 00                	push   $0x0
  pushl $111
80107902:	6a 6f                	push   $0x6f
  jmp alltraps
80107904:	e9 e7 f4 ff ff       	jmp    80106df0 <alltraps>

80107909 <vector112>:
.globl vector112
vector112:
  pushl $0
80107909:	6a 00                	push   $0x0
  pushl $112
8010790b:	6a 70                	push   $0x70
  jmp alltraps
8010790d:	e9 de f4 ff ff       	jmp    80106df0 <alltraps>

80107912 <vector113>:
.globl vector113
vector113:
  pushl $0
80107912:	6a 00                	push   $0x0
  pushl $113
80107914:	6a 71                	push   $0x71
  jmp alltraps
80107916:	e9 d5 f4 ff ff       	jmp    80106df0 <alltraps>

8010791b <vector114>:
.globl vector114
vector114:
  pushl $0
8010791b:	6a 00                	push   $0x0
  pushl $114
8010791d:	6a 72                	push   $0x72
  jmp alltraps
8010791f:	e9 cc f4 ff ff       	jmp    80106df0 <alltraps>

80107924 <vector115>:
.globl vector115
vector115:
  pushl $0
80107924:	6a 00                	push   $0x0
  pushl $115
80107926:	6a 73                	push   $0x73
  jmp alltraps
80107928:	e9 c3 f4 ff ff       	jmp    80106df0 <alltraps>

8010792d <vector116>:
.globl vector116
vector116:
  pushl $0
8010792d:	6a 00                	push   $0x0
  pushl $116
8010792f:	6a 74                	push   $0x74
  jmp alltraps
80107931:	e9 ba f4 ff ff       	jmp    80106df0 <alltraps>

80107936 <vector117>:
.globl vector117
vector117:
  pushl $0
80107936:	6a 00                	push   $0x0
  pushl $117
80107938:	6a 75                	push   $0x75
  jmp alltraps
8010793a:	e9 b1 f4 ff ff       	jmp    80106df0 <alltraps>

8010793f <vector118>:
.globl vector118
vector118:
  pushl $0
8010793f:	6a 00                	push   $0x0
  pushl $118
80107941:	6a 76                	push   $0x76
  jmp alltraps
80107943:	e9 a8 f4 ff ff       	jmp    80106df0 <alltraps>

80107948 <vector119>:
.globl vector119
vector119:
  pushl $0
80107948:	6a 00                	push   $0x0
  pushl $119
8010794a:	6a 77                	push   $0x77
  jmp alltraps
8010794c:	e9 9f f4 ff ff       	jmp    80106df0 <alltraps>

80107951 <vector120>:
.globl vector120
vector120:
  pushl $0
80107951:	6a 00                	push   $0x0
  pushl $120
80107953:	6a 78                	push   $0x78
  jmp alltraps
80107955:	e9 96 f4 ff ff       	jmp    80106df0 <alltraps>

8010795a <vector121>:
.globl vector121
vector121:
  pushl $0
8010795a:	6a 00                	push   $0x0
  pushl $121
8010795c:	6a 79                	push   $0x79
  jmp alltraps
8010795e:	e9 8d f4 ff ff       	jmp    80106df0 <alltraps>

80107963 <vector122>:
.globl vector122
vector122:
  pushl $0
80107963:	6a 00                	push   $0x0
  pushl $122
80107965:	6a 7a                	push   $0x7a
  jmp alltraps
80107967:	e9 84 f4 ff ff       	jmp    80106df0 <alltraps>

8010796c <vector123>:
.globl vector123
vector123:
  pushl $0
8010796c:	6a 00                	push   $0x0
  pushl $123
8010796e:	6a 7b                	push   $0x7b
  jmp alltraps
80107970:	e9 7b f4 ff ff       	jmp    80106df0 <alltraps>

80107975 <vector124>:
.globl vector124
vector124:
  pushl $0
80107975:	6a 00                	push   $0x0
  pushl $124
80107977:	6a 7c                	push   $0x7c
  jmp alltraps
80107979:	e9 72 f4 ff ff       	jmp    80106df0 <alltraps>

8010797e <vector125>:
.globl vector125
vector125:
  pushl $0
8010797e:	6a 00                	push   $0x0
  pushl $125
80107980:	6a 7d                	push   $0x7d
  jmp alltraps
80107982:	e9 69 f4 ff ff       	jmp    80106df0 <alltraps>

80107987 <vector126>:
.globl vector126
vector126:
  pushl $0
80107987:	6a 00                	push   $0x0
  pushl $126
80107989:	6a 7e                	push   $0x7e
  jmp alltraps
8010798b:	e9 60 f4 ff ff       	jmp    80106df0 <alltraps>

80107990 <vector127>:
.globl vector127
vector127:
  pushl $0
80107990:	6a 00                	push   $0x0
  pushl $127
80107992:	6a 7f                	push   $0x7f
  jmp alltraps
80107994:	e9 57 f4 ff ff       	jmp    80106df0 <alltraps>

80107999 <vector128>:
.globl vector128
vector128:
  pushl $0
80107999:	6a 00                	push   $0x0
  pushl $128
8010799b:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801079a0:	e9 4b f4 ff ff       	jmp    80106df0 <alltraps>

801079a5 <vector129>:
.globl vector129
vector129:
  pushl $0
801079a5:	6a 00                	push   $0x0
  pushl $129
801079a7:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801079ac:	e9 3f f4 ff ff       	jmp    80106df0 <alltraps>

801079b1 <vector130>:
.globl vector130
vector130:
  pushl $0
801079b1:	6a 00                	push   $0x0
  pushl $130
801079b3:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801079b8:	e9 33 f4 ff ff       	jmp    80106df0 <alltraps>

801079bd <vector131>:
.globl vector131
vector131:
  pushl $0
801079bd:	6a 00                	push   $0x0
  pushl $131
801079bf:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801079c4:	e9 27 f4 ff ff       	jmp    80106df0 <alltraps>

801079c9 <vector132>:
.globl vector132
vector132:
  pushl $0
801079c9:	6a 00                	push   $0x0
  pushl $132
801079cb:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801079d0:	e9 1b f4 ff ff       	jmp    80106df0 <alltraps>

801079d5 <vector133>:
.globl vector133
vector133:
  pushl $0
801079d5:	6a 00                	push   $0x0
  pushl $133
801079d7:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801079dc:	e9 0f f4 ff ff       	jmp    80106df0 <alltraps>

801079e1 <vector134>:
.globl vector134
vector134:
  pushl $0
801079e1:	6a 00                	push   $0x0
  pushl $134
801079e3:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801079e8:	e9 03 f4 ff ff       	jmp    80106df0 <alltraps>

801079ed <vector135>:
.globl vector135
vector135:
  pushl $0
801079ed:	6a 00                	push   $0x0
  pushl $135
801079ef:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801079f4:	e9 f7 f3 ff ff       	jmp    80106df0 <alltraps>

801079f9 <vector136>:
.globl vector136
vector136:
  pushl $0
801079f9:	6a 00                	push   $0x0
  pushl $136
801079fb:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107a00:	e9 eb f3 ff ff       	jmp    80106df0 <alltraps>

80107a05 <vector137>:
.globl vector137
vector137:
  pushl $0
80107a05:	6a 00                	push   $0x0
  pushl $137
80107a07:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107a0c:	e9 df f3 ff ff       	jmp    80106df0 <alltraps>

80107a11 <vector138>:
.globl vector138
vector138:
  pushl $0
80107a11:	6a 00                	push   $0x0
  pushl $138
80107a13:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107a18:	e9 d3 f3 ff ff       	jmp    80106df0 <alltraps>

80107a1d <vector139>:
.globl vector139
vector139:
  pushl $0
80107a1d:	6a 00                	push   $0x0
  pushl $139
80107a1f:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107a24:	e9 c7 f3 ff ff       	jmp    80106df0 <alltraps>

80107a29 <vector140>:
.globl vector140
vector140:
  pushl $0
80107a29:	6a 00                	push   $0x0
  pushl $140
80107a2b:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107a30:	e9 bb f3 ff ff       	jmp    80106df0 <alltraps>

80107a35 <vector141>:
.globl vector141
vector141:
  pushl $0
80107a35:	6a 00                	push   $0x0
  pushl $141
80107a37:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107a3c:	e9 af f3 ff ff       	jmp    80106df0 <alltraps>

80107a41 <vector142>:
.globl vector142
vector142:
  pushl $0
80107a41:	6a 00                	push   $0x0
  pushl $142
80107a43:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107a48:	e9 a3 f3 ff ff       	jmp    80106df0 <alltraps>

80107a4d <vector143>:
.globl vector143
vector143:
  pushl $0
80107a4d:	6a 00                	push   $0x0
  pushl $143
80107a4f:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107a54:	e9 97 f3 ff ff       	jmp    80106df0 <alltraps>

80107a59 <vector144>:
.globl vector144
vector144:
  pushl $0
80107a59:	6a 00                	push   $0x0
  pushl $144
80107a5b:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107a60:	e9 8b f3 ff ff       	jmp    80106df0 <alltraps>

80107a65 <vector145>:
.globl vector145
vector145:
  pushl $0
80107a65:	6a 00                	push   $0x0
  pushl $145
80107a67:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107a6c:	e9 7f f3 ff ff       	jmp    80106df0 <alltraps>

80107a71 <vector146>:
.globl vector146
vector146:
  pushl $0
80107a71:	6a 00                	push   $0x0
  pushl $146
80107a73:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107a78:	e9 73 f3 ff ff       	jmp    80106df0 <alltraps>

80107a7d <vector147>:
.globl vector147
vector147:
  pushl $0
80107a7d:	6a 00                	push   $0x0
  pushl $147
80107a7f:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107a84:	e9 67 f3 ff ff       	jmp    80106df0 <alltraps>

80107a89 <vector148>:
.globl vector148
vector148:
  pushl $0
80107a89:	6a 00                	push   $0x0
  pushl $148
80107a8b:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107a90:	e9 5b f3 ff ff       	jmp    80106df0 <alltraps>

80107a95 <vector149>:
.globl vector149
vector149:
  pushl $0
80107a95:	6a 00                	push   $0x0
  pushl $149
80107a97:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107a9c:	e9 4f f3 ff ff       	jmp    80106df0 <alltraps>

80107aa1 <vector150>:
.globl vector150
vector150:
  pushl $0
80107aa1:	6a 00                	push   $0x0
  pushl $150
80107aa3:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107aa8:	e9 43 f3 ff ff       	jmp    80106df0 <alltraps>

80107aad <vector151>:
.globl vector151
vector151:
  pushl $0
80107aad:	6a 00                	push   $0x0
  pushl $151
80107aaf:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107ab4:	e9 37 f3 ff ff       	jmp    80106df0 <alltraps>

80107ab9 <vector152>:
.globl vector152
vector152:
  pushl $0
80107ab9:	6a 00                	push   $0x0
  pushl $152
80107abb:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107ac0:	e9 2b f3 ff ff       	jmp    80106df0 <alltraps>

80107ac5 <vector153>:
.globl vector153
vector153:
  pushl $0
80107ac5:	6a 00                	push   $0x0
  pushl $153
80107ac7:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107acc:	e9 1f f3 ff ff       	jmp    80106df0 <alltraps>

80107ad1 <vector154>:
.globl vector154
vector154:
  pushl $0
80107ad1:	6a 00                	push   $0x0
  pushl $154
80107ad3:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107ad8:	e9 13 f3 ff ff       	jmp    80106df0 <alltraps>

80107add <vector155>:
.globl vector155
vector155:
  pushl $0
80107add:	6a 00                	push   $0x0
  pushl $155
80107adf:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107ae4:	e9 07 f3 ff ff       	jmp    80106df0 <alltraps>

80107ae9 <vector156>:
.globl vector156
vector156:
  pushl $0
80107ae9:	6a 00                	push   $0x0
  pushl $156
80107aeb:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107af0:	e9 fb f2 ff ff       	jmp    80106df0 <alltraps>

80107af5 <vector157>:
.globl vector157
vector157:
  pushl $0
80107af5:	6a 00                	push   $0x0
  pushl $157
80107af7:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107afc:	e9 ef f2 ff ff       	jmp    80106df0 <alltraps>

80107b01 <vector158>:
.globl vector158
vector158:
  pushl $0
80107b01:	6a 00                	push   $0x0
  pushl $158
80107b03:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107b08:	e9 e3 f2 ff ff       	jmp    80106df0 <alltraps>

80107b0d <vector159>:
.globl vector159
vector159:
  pushl $0
80107b0d:	6a 00                	push   $0x0
  pushl $159
80107b0f:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107b14:	e9 d7 f2 ff ff       	jmp    80106df0 <alltraps>

80107b19 <vector160>:
.globl vector160
vector160:
  pushl $0
80107b19:	6a 00                	push   $0x0
  pushl $160
80107b1b:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107b20:	e9 cb f2 ff ff       	jmp    80106df0 <alltraps>

80107b25 <vector161>:
.globl vector161
vector161:
  pushl $0
80107b25:	6a 00                	push   $0x0
  pushl $161
80107b27:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107b2c:	e9 bf f2 ff ff       	jmp    80106df0 <alltraps>

80107b31 <vector162>:
.globl vector162
vector162:
  pushl $0
80107b31:	6a 00                	push   $0x0
  pushl $162
80107b33:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107b38:	e9 b3 f2 ff ff       	jmp    80106df0 <alltraps>

80107b3d <vector163>:
.globl vector163
vector163:
  pushl $0
80107b3d:	6a 00                	push   $0x0
  pushl $163
80107b3f:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107b44:	e9 a7 f2 ff ff       	jmp    80106df0 <alltraps>

80107b49 <vector164>:
.globl vector164
vector164:
  pushl $0
80107b49:	6a 00                	push   $0x0
  pushl $164
80107b4b:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107b50:	e9 9b f2 ff ff       	jmp    80106df0 <alltraps>

80107b55 <vector165>:
.globl vector165
vector165:
  pushl $0
80107b55:	6a 00                	push   $0x0
  pushl $165
80107b57:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107b5c:	e9 8f f2 ff ff       	jmp    80106df0 <alltraps>

80107b61 <vector166>:
.globl vector166
vector166:
  pushl $0
80107b61:	6a 00                	push   $0x0
  pushl $166
80107b63:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107b68:	e9 83 f2 ff ff       	jmp    80106df0 <alltraps>

80107b6d <vector167>:
.globl vector167
vector167:
  pushl $0
80107b6d:	6a 00                	push   $0x0
  pushl $167
80107b6f:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107b74:	e9 77 f2 ff ff       	jmp    80106df0 <alltraps>

80107b79 <vector168>:
.globl vector168
vector168:
  pushl $0
80107b79:	6a 00                	push   $0x0
  pushl $168
80107b7b:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107b80:	e9 6b f2 ff ff       	jmp    80106df0 <alltraps>

80107b85 <vector169>:
.globl vector169
vector169:
  pushl $0
80107b85:	6a 00                	push   $0x0
  pushl $169
80107b87:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107b8c:	e9 5f f2 ff ff       	jmp    80106df0 <alltraps>

80107b91 <vector170>:
.globl vector170
vector170:
  pushl $0
80107b91:	6a 00                	push   $0x0
  pushl $170
80107b93:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107b98:	e9 53 f2 ff ff       	jmp    80106df0 <alltraps>

80107b9d <vector171>:
.globl vector171
vector171:
  pushl $0
80107b9d:	6a 00                	push   $0x0
  pushl $171
80107b9f:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107ba4:	e9 47 f2 ff ff       	jmp    80106df0 <alltraps>

80107ba9 <vector172>:
.globl vector172
vector172:
  pushl $0
80107ba9:	6a 00                	push   $0x0
  pushl $172
80107bab:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107bb0:	e9 3b f2 ff ff       	jmp    80106df0 <alltraps>

80107bb5 <vector173>:
.globl vector173
vector173:
  pushl $0
80107bb5:	6a 00                	push   $0x0
  pushl $173
80107bb7:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107bbc:	e9 2f f2 ff ff       	jmp    80106df0 <alltraps>

80107bc1 <vector174>:
.globl vector174
vector174:
  pushl $0
80107bc1:	6a 00                	push   $0x0
  pushl $174
80107bc3:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107bc8:	e9 23 f2 ff ff       	jmp    80106df0 <alltraps>

80107bcd <vector175>:
.globl vector175
vector175:
  pushl $0
80107bcd:	6a 00                	push   $0x0
  pushl $175
80107bcf:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107bd4:	e9 17 f2 ff ff       	jmp    80106df0 <alltraps>

80107bd9 <vector176>:
.globl vector176
vector176:
  pushl $0
80107bd9:	6a 00                	push   $0x0
  pushl $176
80107bdb:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107be0:	e9 0b f2 ff ff       	jmp    80106df0 <alltraps>

80107be5 <vector177>:
.globl vector177
vector177:
  pushl $0
80107be5:	6a 00                	push   $0x0
  pushl $177
80107be7:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107bec:	e9 ff f1 ff ff       	jmp    80106df0 <alltraps>

80107bf1 <vector178>:
.globl vector178
vector178:
  pushl $0
80107bf1:	6a 00                	push   $0x0
  pushl $178
80107bf3:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107bf8:	e9 f3 f1 ff ff       	jmp    80106df0 <alltraps>

80107bfd <vector179>:
.globl vector179
vector179:
  pushl $0
80107bfd:	6a 00                	push   $0x0
  pushl $179
80107bff:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107c04:	e9 e7 f1 ff ff       	jmp    80106df0 <alltraps>

80107c09 <vector180>:
.globl vector180
vector180:
  pushl $0
80107c09:	6a 00                	push   $0x0
  pushl $180
80107c0b:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107c10:	e9 db f1 ff ff       	jmp    80106df0 <alltraps>

80107c15 <vector181>:
.globl vector181
vector181:
  pushl $0
80107c15:	6a 00                	push   $0x0
  pushl $181
80107c17:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107c1c:	e9 cf f1 ff ff       	jmp    80106df0 <alltraps>

80107c21 <vector182>:
.globl vector182
vector182:
  pushl $0
80107c21:	6a 00                	push   $0x0
  pushl $182
80107c23:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107c28:	e9 c3 f1 ff ff       	jmp    80106df0 <alltraps>

80107c2d <vector183>:
.globl vector183
vector183:
  pushl $0
80107c2d:	6a 00                	push   $0x0
  pushl $183
80107c2f:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107c34:	e9 b7 f1 ff ff       	jmp    80106df0 <alltraps>

80107c39 <vector184>:
.globl vector184
vector184:
  pushl $0
80107c39:	6a 00                	push   $0x0
  pushl $184
80107c3b:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107c40:	e9 ab f1 ff ff       	jmp    80106df0 <alltraps>

80107c45 <vector185>:
.globl vector185
vector185:
  pushl $0
80107c45:	6a 00                	push   $0x0
  pushl $185
80107c47:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107c4c:	e9 9f f1 ff ff       	jmp    80106df0 <alltraps>

80107c51 <vector186>:
.globl vector186
vector186:
  pushl $0
80107c51:	6a 00                	push   $0x0
  pushl $186
80107c53:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107c58:	e9 93 f1 ff ff       	jmp    80106df0 <alltraps>

80107c5d <vector187>:
.globl vector187
vector187:
  pushl $0
80107c5d:	6a 00                	push   $0x0
  pushl $187
80107c5f:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107c64:	e9 87 f1 ff ff       	jmp    80106df0 <alltraps>

80107c69 <vector188>:
.globl vector188
vector188:
  pushl $0
80107c69:	6a 00                	push   $0x0
  pushl $188
80107c6b:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107c70:	e9 7b f1 ff ff       	jmp    80106df0 <alltraps>

80107c75 <vector189>:
.globl vector189
vector189:
  pushl $0
80107c75:	6a 00                	push   $0x0
  pushl $189
80107c77:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107c7c:	e9 6f f1 ff ff       	jmp    80106df0 <alltraps>

80107c81 <vector190>:
.globl vector190
vector190:
  pushl $0
80107c81:	6a 00                	push   $0x0
  pushl $190
80107c83:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107c88:	e9 63 f1 ff ff       	jmp    80106df0 <alltraps>

80107c8d <vector191>:
.globl vector191
vector191:
  pushl $0
80107c8d:	6a 00                	push   $0x0
  pushl $191
80107c8f:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107c94:	e9 57 f1 ff ff       	jmp    80106df0 <alltraps>

80107c99 <vector192>:
.globl vector192
vector192:
  pushl $0
80107c99:	6a 00                	push   $0x0
  pushl $192
80107c9b:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107ca0:	e9 4b f1 ff ff       	jmp    80106df0 <alltraps>

80107ca5 <vector193>:
.globl vector193
vector193:
  pushl $0
80107ca5:	6a 00                	push   $0x0
  pushl $193
80107ca7:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107cac:	e9 3f f1 ff ff       	jmp    80106df0 <alltraps>

80107cb1 <vector194>:
.globl vector194
vector194:
  pushl $0
80107cb1:	6a 00                	push   $0x0
  pushl $194
80107cb3:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107cb8:	e9 33 f1 ff ff       	jmp    80106df0 <alltraps>

80107cbd <vector195>:
.globl vector195
vector195:
  pushl $0
80107cbd:	6a 00                	push   $0x0
  pushl $195
80107cbf:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107cc4:	e9 27 f1 ff ff       	jmp    80106df0 <alltraps>

80107cc9 <vector196>:
.globl vector196
vector196:
  pushl $0
80107cc9:	6a 00                	push   $0x0
  pushl $196
80107ccb:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107cd0:	e9 1b f1 ff ff       	jmp    80106df0 <alltraps>

80107cd5 <vector197>:
.globl vector197
vector197:
  pushl $0
80107cd5:	6a 00                	push   $0x0
  pushl $197
80107cd7:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107cdc:	e9 0f f1 ff ff       	jmp    80106df0 <alltraps>

80107ce1 <vector198>:
.globl vector198
vector198:
  pushl $0
80107ce1:	6a 00                	push   $0x0
  pushl $198
80107ce3:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107ce8:	e9 03 f1 ff ff       	jmp    80106df0 <alltraps>

80107ced <vector199>:
.globl vector199
vector199:
  pushl $0
80107ced:	6a 00                	push   $0x0
  pushl $199
80107cef:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107cf4:	e9 f7 f0 ff ff       	jmp    80106df0 <alltraps>

80107cf9 <vector200>:
.globl vector200
vector200:
  pushl $0
80107cf9:	6a 00                	push   $0x0
  pushl $200
80107cfb:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107d00:	e9 eb f0 ff ff       	jmp    80106df0 <alltraps>

80107d05 <vector201>:
.globl vector201
vector201:
  pushl $0
80107d05:	6a 00                	push   $0x0
  pushl $201
80107d07:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107d0c:	e9 df f0 ff ff       	jmp    80106df0 <alltraps>

80107d11 <vector202>:
.globl vector202
vector202:
  pushl $0
80107d11:	6a 00                	push   $0x0
  pushl $202
80107d13:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107d18:	e9 d3 f0 ff ff       	jmp    80106df0 <alltraps>

80107d1d <vector203>:
.globl vector203
vector203:
  pushl $0
80107d1d:	6a 00                	push   $0x0
  pushl $203
80107d1f:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107d24:	e9 c7 f0 ff ff       	jmp    80106df0 <alltraps>

80107d29 <vector204>:
.globl vector204
vector204:
  pushl $0
80107d29:	6a 00                	push   $0x0
  pushl $204
80107d2b:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107d30:	e9 bb f0 ff ff       	jmp    80106df0 <alltraps>

80107d35 <vector205>:
.globl vector205
vector205:
  pushl $0
80107d35:	6a 00                	push   $0x0
  pushl $205
80107d37:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107d3c:	e9 af f0 ff ff       	jmp    80106df0 <alltraps>

80107d41 <vector206>:
.globl vector206
vector206:
  pushl $0
80107d41:	6a 00                	push   $0x0
  pushl $206
80107d43:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107d48:	e9 a3 f0 ff ff       	jmp    80106df0 <alltraps>

80107d4d <vector207>:
.globl vector207
vector207:
  pushl $0
80107d4d:	6a 00                	push   $0x0
  pushl $207
80107d4f:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107d54:	e9 97 f0 ff ff       	jmp    80106df0 <alltraps>

80107d59 <vector208>:
.globl vector208
vector208:
  pushl $0
80107d59:	6a 00                	push   $0x0
  pushl $208
80107d5b:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107d60:	e9 8b f0 ff ff       	jmp    80106df0 <alltraps>

80107d65 <vector209>:
.globl vector209
vector209:
  pushl $0
80107d65:	6a 00                	push   $0x0
  pushl $209
80107d67:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107d6c:	e9 7f f0 ff ff       	jmp    80106df0 <alltraps>

80107d71 <vector210>:
.globl vector210
vector210:
  pushl $0
80107d71:	6a 00                	push   $0x0
  pushl $210
80107d73:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107d78:	e9 73 f0 ff ff       	jmp    80106df0 <alltraps>

80107d7d <vector211>:
.globl vector211
vector211:
  pushl $0
80107d7d:	6a 00                	push   $0x0
  pushl $211
80107d7f:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107d84:	e9 67 f0 ff ff       	jmp    80106df0 <alltraps>

80107d89 <vector212>:
.globl vector212
vector212:
  pushl $0
80107d89:	6a 00                	push   $0x0
  pushl $212
80107d8b:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107d90:	e9 5b f0 ff ff       	jmp    80106df0 <alltraps>

80107d95 <vector213>:
.globl vector213
vector213:
  pushl $0
80107d95:	6a 00                	push   $0x0
  pushl $213
80107d97:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107d9c:	e9 4f f0 ff ff       	jmp    80106df0 <alltraps>

80107da1 <vector214>:
.globl vector214
vector214:
  pushl $0
80107da1:	6a 00                	push   $0x0
  pushl $214
80107da3:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107da8:	e9 43 f0 ff ff       	jmp    80106df0 <alltraps>

80107dad <vector215>:
.globl vector215
vector215:
  pushl $0
80107dad:	6a 00                	push   $0x0
  pushl $215
80107daf:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107db4:	e9 37 f0 ff ff       	jmp    80106df0 <alltraps>

80107db9 <vector216>:
.globl vector216
vector216:
  pushl $0
80107db9:	6a 00                	push   $0x0
  pushl $216
80107dbb:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107dc0:	e9 2b f0 ff ff       	jmp    80106df0 <alltraps>

80107dc5 <vector217>:
.globl vector217
vector217:
  pushl $0
80107dc5:	6a 00                	push   $0x0
  pushl $217
80107dc7:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107dcc:	e9 1f f0 ff ff       	jmp    80106df0 <alltraps>

80107dd1 <vector218>:
.globl vector218
vector218:
  pushl $0
80107dd1:	6a 00                	push   $0x0
  pushl $218
80107dd3:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107dd8:	e9 13 f0 ff ff       	jmp    80106df0 <alltraps>

80107ddd <vector219>:
.globl vector219
vector219:
  pushl $0
80107ddd:	6a 00                	push   $0x0
  pushl $219
80107ddf:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107de4:	e9 07 f0 ff ff       	jmp    80106df0 <alltraps>

80107de9 <vector220>:
.globl vector220
vector220:
  pushl $0
80107de9:	6a 00                	push   $0x0
  pushl $220
80107deb:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107df0:	e9 fb ef ff ff       	jmp    80106df0 <alltraps>

80107df5 <vector221>:
.globl vector221
vector221:
  pushl $0
80107df5:	6a 00                	push   $0x0
  pushl $221
80107df7:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107dfc:	e9 ef ef ff ff       	jmp    80106df0 <alltraps>

80107e01 <vector222>:
.globl vector222
vector222:
  pushl $0
80107e01:	6a 00                	push   $0x0
  pushl $222
80107e03:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107e08:	e9 e3 ef ff ff       	jmp    80106df0 <alltraps>

80107e0d <vector223>:
.globl vector223
vector223:
  pushl $0
80107e0d:	6a 00                	push   $0x0
  pushl $223
80107e0f:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107e14:	e9 d7 ef ff ff       	jmp    80106df0 <alltraps>

80107e19 <vector224>:
.globl vector224
vector224:
  pushl $0
80107e19:	6a 00                	push   $0x0
  pushl $224
80107e1b:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107e20:	e9 cb ef ff ff       	jmp    80106df0 <alltraps>

80107e25 <vector225>:
.globl vector225
vector225:
  pushl $0
80107e25:	6a 00                	push   $0x0
  pushl $225
80107e27:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107e2c:	e9 bf ef ff ff       	jmp    80106df0 <alltraps>

80107e31 <vector226>:
.globl vector226
vector226:
  pushl $0
80107e31:	6a 00                	push   $0x0
  pushl $226
80107e33:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107e38:	e9 b3 ef ff ff       	jmp    80106df0 <alltraps>

80107e3d <vector227>:
.globl vector227
vector227:
  pushl $0
80107e3d:	6a 00                	push   $0x0
  pushl $227
80107e3f:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107e44:	e9 a7 ef ff ff       	jmp    80106df0 <alltraps>

80107e49 <vector228>:
.globl vector228
vector228:
  pushl $0
80107e49:	6a 00                	push   $0x0
  pushl $228
80107e4b:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107e50:	e9 9b ef ff ff       	jmp    80106df0 <alltraps>

80107e55 <vector229>:
.globl vector229
vector229:
  pushl $0
80107e55:	6a 00                	push   $0x0
  pushl $229
80107e57:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107e5c:	e9 8f ef ff ff       	jmp    80106df0 <alltraps>

80107e61 <vector230>:
.globl vector230
vector230:
  pushl $0
80107e61:	6a 00                	push   $0x0
  pushl $230
80107e63:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107e68:	e9 83 ef ff ff       	jmp    80106df0 <alltraps>

80107e6d <vector231>:
.globl vector231
vector231:
  pushl $0
80107e6d:	6a 00                	push   $0x0
  pushl $231
80107e6f:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107e74:	e9 77 ef ff ff       	jmp    80106df0 <alltraps>

80107e79 <vector232>:
.globl vector232
vector232:
  pushl $0
80107e79:	6a 00                	push   $0x0
  pushl $232
80107e7b:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107e80:	e9 6b ef ff ff       	jmp    80106df0 <alltraps>

80107e85 <vector233>:
.globl vector233
vector233:
  pushl $0
80107e85:	6a 00                	push   $0x0
  pushl $233
80107e87:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107e8c:	e9 5f ef ff ff       	jmp    80106df0 <alltraps>

80107e91 <vector234>:
.globl vector234
vector234:
  pushl $0
80107e91:	6a 00                	push   $0x0
  pushl $234
80107e93:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107e98:	e9 53 ef ff ff       	jmp    80106df0 <alltraps>

80107e9d <vector235>:
.globl vector235
vector235:
  pushl $0
80107e9d:	6a 00                	push   $0x0
  pushl $235
80107e9f:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107ea4:	e9 47 ef ff ff       	jmp    80106df0 <alltraps>

80107ea9 <vector236>:
.globl vector236
vector236:
  pushl $0
80107ea9:	6a 00                	push   $0x0
  pushl $236
80107eab:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107eb0:	e9 3b ef ff ff       	jmp    80106df0 <alltraps>

80107eb5 <vector237>:
.globl vector237
vector237:
  pushl $0
80107eb5:	6a 00                	push   $0x0
  pushl $237
80107eb7:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107ebc:	e9 2f ef ff ff       	jmp    80106df0 <alltraps>

80107ec1 <vector238>:
.globl vector238
vector238:
  pushl $0
80107ec1:	6a 00                	push   $0x0
  pushl $238
80107ec3:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107ec8:	e9 23 ef ff ff       	jmp    80106df0 <alltraps>

80107ecd <vector239>:
.globl vector239
vector239:
  pushl $0
80107ecd:	6a 00                	push   $0x0
  pushl $239
80107ecf:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107ed4:	e9 17 ef ff ff       	jmp    80106df0 <alltraps>

80107ed9 <vector240>:
.globl vector240
vector240:
  pushl $0
80107ed9:	6a 00                	push   $0x0
  pushl $240
80107edb:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107ee0:	e9 0b ef ff ff       	jmp    80106df0 <alltraps>

80107ee5 <vector241>:
.globl vector241
vector241:
  pushl $0
80107ee5:	6a 00                	push   $0x0
  pushl $241
80107ee7:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107eec:	e9 ff ee ff ff       	jmp    80106df0 <alltraps>

80107ef1 <vector242>:
.globl vector242
vector242:
  pushl $0
80107ef1:	6a 00                	push   $0x0
  pushl $242
80107ef3:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107ef8:	e9 f3 ee ff ff       	jmp    80106df0 <alltraps>

80107efd <vector243>:
.globl vector243
vector243:
  pushl $0
80107efd:	6a 00                	push   $0x0
  pushl $243
80107eff:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107f04:	e9 e7 ee ff ff       	jmp    80106df0 <alltraps>

80107f09 <vector244>:
.globl vector244
vector244:
  pushl $0
80107f09:	6a 00                	push   $0x0
  pushl $244
80107f0b:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107f10:	e9 db ee ff ff       	jmp    80106df0 <alltraps>

80107f15 <vector245>:
.globl vector245
vector245:
  pushl $0
80107f15:	6a 00                	push   $0x0
  pushl $245
80107f17:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107f1c:	e9 cf ee ff ff       	jmp    80106df0 <alltraps>

80107f21 <vector246>:
.globl vector246
vector246:
  pushl $0
80107f21:	6a 00                	push   $0x0
  pushl $246
80107f23:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107f28:	e9 c3 ee ff ff       	jmp    80106df0 <alltraps>

80107f2d <vector247>:
.globl vector247
vector247:
  pushl $0
80107f2d:	6a 00                	push   $0x0
  pushl $247
80107f2f:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107f34:	e9 b7 ee ff ff       	jmp    80106df0 <alltraps>

80107f39 <vector248>:
.globl vector248
vector248:
  pushl $0
80107f39:	6a 00                	push   $0x0
  pushl $248
80107f3b:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107f40:	e9 ab ee ff ff       	jmp    80106df0 <alltraps>

80107f45 <vector249>:
.globl vector249
vector249:
  pushl $0
80107f45:	6a 00                	push   $0x0
  pushl $249
80107f47:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107f4c:	e9 9f ee ff ff       	jmp    80106df0 <alltraps>

80107f51 <vector250>:
.globl vector250
vector250:
  pushl $0
80107f51:	6a 00                	push   $0x0
  pushl $250
80107f53:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107f58:	e9 93 ee ff ff       	jmp    80106df0 <alltraps>

80107f5d <vector251>:
.globl vector251
vector251:
  pushl $0
80107f5d:	6a 00                	push   $0x0
  pushl $251
80107f5f:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107f64:	e9 87 ee ff ff       	jmp    80106df0 <alltraps>

80107f69 <vector252>:
.globl vector252
vector252:
  pushl $0
80107f69:	6a 00                	push   $0x0
  pushl $252
80107f6b:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107f70:	e9 7b ee ff ff       	jmp    80106df0 <alltraps>

80107f75 <vector253>:
.globl vector253
vector253:
  pushl $0
80107f75:	6a 00                	push   $0x0
  pushl $253
80107f77:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107f7c:	e9 6f ee ff ff       	jmp    80106df0 <alltraps>

80107f81 <vector254>:
.globl vector254
vector254:
  pushl $0
80107f81:	6a 00                	push   $0x0
  pushl $254
80107f83:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107f88:	e9 63 ee ff ff       	jmp    80106df0 <alltraps>

80107f8d <vector255>:
.globl vector255
vector255:
  pushl $0
80107f8d:	6a 00                	push   $0x0
  pushl $255
80107f8f:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107f94:	e9 57 ee ff ff       	jmp    80106df0 <alltraps>

80107f99 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107f99:	55                   	push   %ebp
80107f9a:	89 e5                	mov    %esp,%ebp
80107f9c:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fa2:	83 e8 01             	sub    $0x1,%eax
80107fa5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107fa9:	8b 45 08             	mov    0x8(%ebp),%eax
80107fac:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80107fb3:	c1 e8 10             	shr    $0x10,%eax
80107fb6:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107fba:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107fbd:	0f 01 10             	lgdtl  (%eax)
}
80107fc0:	c9                   	leave  
80107fc1:	c3                   	ret    

80107fc2 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107fc2:	55                   	push   %ebp
80107fc3:	89 e5                	mov    %esp,%ebp
80107fc5:	83 ec 04             	sub    $0x4,%esp
80107fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80107fcb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107fcf:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107fd3:	0f 00 d8             	ltr    %ax
}
80107fd6:	c9                   	leave  
80107fd7:	c3                   	ret    

80107fd8 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107fd8:	55                   	push   %ebp
80107fd9:	89 e5                	mov    %esp,%ebp
80107fdb:	83 ec 04             	sub    $0x4,%esp
80107fde:	8b 45 08             	mov    0x8(%ebp),%eax
80107fe1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107fe5:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107fe9:	8e e8                	mov    %eax,%gs
}
80107feb:	c9                   	leave  
80107fec:	c3                   	ret    

80107fed <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
80107fed:	55                   	push   %ebp
80107fee:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107ff0:	8b 45 08             	mov    0x8(%ebp),%eax
80107ff3:	0f 22 d8             	mov    %eax,%cr3
}
80107ff6:	5d                   	pop    %ebp
80107ff7:	c3                   	ret    

80107ff8 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107ff8:	55                   	push   %ebp
80107ff9:	89 e5                	mov    %esp,%ebp
80107ffb:	53                   	push   %ebx
80107ffc:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107fff:	e8 cb b1 ff ff       	call   801031cf <cpunum>
80108004:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010800a:	05 40 48 11 80       	add    $0x80114840,%eax
8010800f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108012:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108015:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010801b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801e:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108024:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108027:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010802b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108032:	83 e2 f0             	and    $0xfffffff0,%edx
80108035:	83 ca 0a             	or     $0xa,%edx
80108038:	88 50 7d             	mov    %dl,0x7d(%eax)
8010803b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108042:	83 ca 10             	or     $0x10,%edx
80108045:	88 50 7d             	mov    %dl,0x7d(%eax)
80108048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010804f:	83 e2 9f             	and    $0xffffff9f,%edx
80108052:	88 50 7d             	mov    %dl,0x7d(%eax)
80108055:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108058:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010805c:	83 ca 80             	or     $0xffffff80,%edx
8010805f:	88 50 7d             	mov    %dl,0x7d(%eax)
80108062:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108065:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108069:	83 ca 0f             	or     $0xf,%edx
8010806c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010806f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108072:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108076:	83 e2 ef             	and    $0xffffffef,%edx
80108079:	88 50 7e             	mov    %dl,0x7e(%eax)
8010807c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010807f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108083:	83 e2 df             	and    $0xffffffdf,%edx
80108086:	88 50 7e             	mov    %dl,0x7e(%eax)
80108089:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108090:	83 ca 40             	or     $0x40,%edx
80108093:	88 50 7e             	mov    %dl,0x7e(%eax)
80108096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108099:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010809d:	83 ca 80             	or     $0xffffff80,%edx
801080a0:	88 50 7e             	mov    %dl,0x7e(%eax)
801080a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a6:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801080aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ad:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801080b4:	ff ff 
801080b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b9:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801080c0:	00 00 
801080c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c5:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801080cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080cf:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801080d6:	83 e2 f0             	and    $0xfffffff0,%edx
801080d9:	83 ca 02             	or     $0x2,%edx
801080dc:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e5:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801080ec:	83 ca 10             	or     $0x10,%edx
801080ef:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801080ff:	83 e2 9f             	and    $0xffffff9f,%edx
80108102:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010810b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108112:	83 ca 80             	or     $0xffffff80,%edx
80108115:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010811b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010811e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108125:	83 ca 0f             	or     $0xf,%edx
80108128:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010812e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108131:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108138:	83 e2 ef             	and    $0xffffffef,%edx
8010813b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108141:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108144:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010814b:	83 e2 df             	and    $0xffffffdf,%edx
8010814e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108154:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108157:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010815e:	83 ca 40             	or     $0x40,%edx
80108161:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108167:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010816a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108171:	83 ca 80             	or     $0xffffff80,%edx
80108174:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010817a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010817d:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108184:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108187:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010818e:	ff ff 
80108190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108193:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
8010819a:	00 00 
8010819c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010819f:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801081a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a9:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801081b0:	83 e2 f0             	and    $0xfffffff0,%edx
801081b3:	83 ca 0a             	or     $0xa,%edx
801081b6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081bf:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801081c6:	83 ca 10             	or     $0x10,%edx
801081c9:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801081d9:	83 ca 60             	or     $0x60,%edx
801081dc:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e5:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801081ec:	83 ca 80             	or     $0xffffff80,%edx
801081ef:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081ff:	83 ca 0f             	or     $0xf,%edx
80108202:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108208:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010820b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108212:	83 e2 ef             	and    $0xffffffef,%edx
80108215:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010821b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010821e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108225:	83 e2 df             	and    $0xffffffdf,%edx
80108228:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010822e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108231:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108238:	83 ca 40             	or     $0x40,%edx
8010823b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108241:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108244:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010824b:	83 ca 80             	or     $0xffffff80,%edx
8010824e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108254:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108257:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010825e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108261:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80108268:	ff ff 
8010826a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010826d:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108274:	00 00 
80108276:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108279:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108280:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108283:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010828a:	83 e2 f0             	and    $0xfffffff0,%edx
8010828d:	83 ca 02             	or     $0x2,%edx
80108290:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108296:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108299:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801082a0:	83 ca 10             	or     $0x10,%edx
801082a3:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801082a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ac:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801082b3:	83 ca 60             	or     $0x60,%edx
801082b6:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801082bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082bf:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801082c6:	83 ca 80             	or     $0xffffff80,%edx
801082c9:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801082cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082d2:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082d9:	83 ca 0f             	or     $0xf,%edx
801082dc:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082e5:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082ec:	83 e2 ef             	and    $0xffffffef,%edx
801082ef:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f8:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801082ff:	83 e2 df             	and    $0xffffffdf,%edx
80108302:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010830b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108312:	83 ca 40             	or     $0x40,%edx
80108315:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010831b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010831e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108325:	83 ca 80             	or     $0xffffff80,%edx
80108328:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010832e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108331:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010833b:	05 b4 00 00 00       	add    $0xb4,%eax
80108340:	89 c3                	mov    %eax,%ebx
80108342:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108345:	05 b4 00 00 00       	add    $0xb4,%eax
8010834a:	c1 e8 10             	shr    $0x10,%eax
8010834d:	89 c1                	mov    %eax,%ecx
8010834f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108352:	05 b4 00 00 00       	add    $0xb4,%eax
80108357:	c1 e8 18             	shr    $0x18,%eax
8010835a:	89 c2                	mov    %eax,%edx
8010835c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835f:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108366:	00 00 
80108368:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836b:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108372:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108375:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
8010837b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010837e:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108385:	83 e1 f0             	and    $0xfffffff0,%ecx
80108388:	83 c9 02             	or     $0x2,%ecx
8010838b:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108391:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108394:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010839b:	83 c9 10             	or     $0x10,%ecx
8010839e:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801083a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083a7:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801083ae:	83 e1 9f             	and    $0xffffff9f,%ecx
801083b1:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801083b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ba:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801083c1:	83 c9 80             	or     $0xffffff80,%ecx
801083c4:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801083ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083cd:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801083d4:	83 e1 f0             	and    $0xfffffff0,%ecx
801083d7:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801083dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e0:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801083e7:	83 e1 ef             	and    $0xffffffef,%ecx
801083ea:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801083f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083f3:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801083fa:	83 e1 df             	and    $0xffffffdf,%ecx
801083fd:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108403:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108406:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010840d:	83 c9 40             	or     $0x40,%ecx
80108410:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108416:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108419:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108420:	83 c9 80             	or     $0xffffff80,%ecx
80108423:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010842c:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108432:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108435:	83 c0 70             	add    $0x70,%eax
80108438:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
8010843f:	00 
80108440:	89 04 24             	mov    %eax,(%esp)
80108443:	e8 51 fb ff ff       	call   80107f99 <lgdt>
  loadgs(SEG_KCPU << 3);
80108448:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
8010844f:	e8 84 fb ff ff       	call   80107fd8 <loadgs>

  // Initialize cpu-local storage.
  cpu = c;
80108454:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108457:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
8010845d:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108464:	00 00 00 00 
}
80108468:	83 c4 24             	add    $0x24,%esp
8010846b:	5b                   	pop    %ebx
8010846c:	5d                   	pop    %ebp
8010846d:	c3                   	ret    

8010846e <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010846e:	55                   	push   %ebp
8010846f:	89 e5                	mov    %esp,%ebp
80108471:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108474:	8b 45 0c             	mov    0xc(%ebp),%eax
80108477:	c1 e8 16             	shr    $0x16,%eax
8010847a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108481:	8b 45 08             	mov    0x8(%ebp),%eax
80108484:	01 d0                	add    %edx,%eax
80108486:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108489:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010848c:	8b 00                	mov    (%eax),%eax
8010848e:	83 e0 01             	and    $0x1,%eax
80108491:	85 c0                	test   %eax,%eax
80108493:	74 14                	je     801084a9 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108495:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108498:	8b 00                	mov    (%eax),%eax
8010849a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010849f:	05 00 00 00 80       	add    $0x80000000,%eax
801084a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801084a7:	eb 48                	jmp    801084f1 <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801084a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801084ad:	74 0e                	je     801084bd <walkpgdir+0x4f>
801084af:	e8 85 a9 ff ff       	call   80102e39 <kalloc>
801084b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801084b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801084bb:	75 07                	jne    801084c4 <walkpgdir+0x56>
      return 0;
801084bd:	b8 00 00 00 00       	mov    $0x0,%eax
801084c2:	eb 44                	jmp    80108508 <walkpgdir+0x9a>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801084c4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801084cb:	00 
801084cc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801084d3:	00 
801084d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084d7:	89 04 24             	mov    %eax,(%esp)
801084da:	e8 f7 d3 ff ff       	call   801058d6 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801084df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084e2:	05 00 00 00 80       	add    $0x80000000,%eax
801084e7:	83 c8 07             	or     $0x7,%eax
801084ea:	89 c2                	mov    %eax,%edx
801084ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084ef:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801084f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801084f4:	c1 e8 0c             	shr    $0xc,%eax
801084f7:	25 ff 03 00 00       	and    $0x3ff,%eax
801084fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108503:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108506:	01 d0                	add    %edx,%eax
}
80108508:	c9                   	leave  
80108509:	c3                   	ret    

8010850a <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010850a:	55                   	push   %ebp
8010850b:	89 e5                	mov    %esp,%ebp
8010850d:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80108510:	8b 45 0c             	mov    0xc(%ebp),%eax
80108513:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108518:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010851b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010851e:	8b 45 10             	mov    0x10(%ebp),%eax
80108521:	01 d0                	add    %edx,%eax
80108523:	83 e8 01             	sub    $0x1,%eax
80108526:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010852b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010852e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80108535:	00 
80108536:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108539:	89 44 24 04          	mov    %eax,0x4(%esp)
8010853d:	8b 45 08             	mov    0x8(%ebp),%eax
80108540:	89 04 24             	mov    %eax,(%esp)
80108543:	e8 26 ff ff ff       	call   8010846e <walkpgdir>
80108548:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010854b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010854f:	75 07                	jne    80108558 <mappages+0x4e>
      return -1;
80108551:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108556:	eb 48                	jmp    801085a0 <mappages+0x96>
    if(*pte & PTE_P)
80108558:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010855b:	8b 00                	mov    (%eax),%eax
8010855d:	83 e0 01             	and    $0x1,%eax
80108560:	85 c0                	test   %eax,%eax
80108562:	74 0c                	je     80108570 <mappages+0x66>
      panic("remap");
80108564:	c7 04 24 0c 95 10 80 	movl   $0x8010950c,(%esp)
8010856b:	e8 f2 7f ff ff       	call   80100562 <panic>
    *pte = pa | perm | PTE_P;
80108570:	8b 45 18             	mov    0x18(%ebp),%eax
80108573:	0b 45 14             	or     0x14(%ebp),%eax
80108576:	83 c8 01             	or     $0x1,%eax
80108579:	89 c2                	mov    %eax,%edx
8010857b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010857e:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108580:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108583:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108586:	75 08                	jne    80108590 <mappages+0x86>
      break;
80108588:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108589:	b8 00 00 00 00       	mov    $0x0,%eax
8010858e:	eb 10                	jmp    801085a0 <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80108590:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108597:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010859e:	eb 8e                	jmp    8010852e <mappages+0x24>
  return 0;
}
801085a0:	c9                   	leave  
801085a1:	c3                   	ret    

801085a2 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801085a2:	55                   	push   %ebp
801085a3:	89 e5                	mov    %esp,%ebp
801085a5:	53                   	push   %ebx
801085a6:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801085a9:	e8 8b a8 ff ff       	call   80102e39 <kalloc>
801085ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
801085b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801085b5:	75 07                	jne    801085be <setupkvm+0x1c>
    return 0;
801085b7:	b8 00 00 00 00       	mov    $0x0,%eax
801085bc:	eb 79                	jmp    80108637 <setupkvm+0x95>
  memset(pgdir, 0, PGSIZE);
801085be:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801085c5:	00 
801085c6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801085cd:	00 
801085ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085d1:	89 04 24             	mov    %eax,(%esp)
801085d4:	e8 fd d2 ff ff       	call   801058d6 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801085d9:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
801085e0:	eb 49                	jmp    8010862b <setupkvm+0x89>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801085e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085e5:	8b 48 0c             	mov    0xc(%eax),%ecx
801085e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085eb:	8b 50 04             	mov    0x4(%eax),%edx
801085ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085f1:	8b 58 08             	mov    0x8(%eax),%ebx
801085f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085f7:	8b 40 04             	mov    0x4(%eax),%eax
801085fa:	29 c3                	sub    %eax,%ebx
801085fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085ff:	8b 00                	mov    (%eax),%eax
80108601:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80108605:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108609:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010860d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108611:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108614:	89 04 24             	mov    %eax,(%esp)
80108617:	e8 ee fe ff ff       	call   8010850a <mappages>
8010861c:	85 c0                	test   %eax,%eax
8010861e:	79 07                	jns    80108627 <setupkvm+0x85>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108620:	b8 00 00 00 00       	mov    $0x0,%eax
80108625:	eb 10                	jmp    80108637 <setupkvm+0x95>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108627:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010862b:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
80108632:	72 ae                	jb     801085e2 <setupkvm+0x40>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80108634:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108637:	83 c4 34             	add    $0x34,%esp
8010863a:	5b                   	pop    %ebx
8010863b:	5d                   	pop    %ebp
8010863c:	c3                   	ret    

8010863d <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010863d:	55                   	push   %ebp
8010863e:	89 e5                	mov    %esp,%ebp
80108640:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108643:	e8 5a ff ff ff       	call   801085a2 <setupkvm>
80108648:	a3 c4 79 11 80       	mov    %eax,0x801179c4
  switchkvm();
8010864d:	e8 02 00 00 00       	call   80108654 <switchkvm>
}
80108652:	c9                   	leave  
80108653:	c3                   	ret    

80108654 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108654:	55                   	push   %ebp
80108655:	89 e5                	mov    %esp,%ebp
80108657:	83 ec 04             	sub    $0x4,%esp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010865a:	a1 c4 79 11 80       	mov    0x801179c4,%eax
8010865f:	05 00 00 00 80       	add    $0x80000000,%eax
80108664:	89 04 24             	mov    %eax,(%esp)
80108667:	e8 81 f9 ff ff       	call   80107fed <lcr3>
}
8010866c:	c9                   	leave  
8010866d:	c3                   	ret    

8010866e <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010866e:	55                   	push   %ebp
8010866f:	89 e5                	mov    %esp,%ebp
80108671:	53                   	push   %ebx
80108672:	83 ec 14             	sub    $0x14,%esp
  if(p == 0)
80108675:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108679:	75 0c                	jne    80108687 <switchuvm+0x19>
    panic("switchuvm: no process");
8010867b:	c7 04 24 12 95 10 80 	movl   $0x80109512,(%esp)
80108682:	e8 db 7e ff ff       	call   80100562 <panic>
  if(p->kstack == 0)
80108687:	8b 45 08             	mov    0x8(%ebp),%eax
8010868a:	8b 40 08             	mov    0x8(%eax),%eax
8010868d:	85 c0                	test   %eax,%eax
8010868f:	75 0c                	jne    8010869d <switchuvm+0x2f>
    panic("switchuvm: no kstack");
80108691:	c7 04 24 28 95 10 80 	movl   $0x80109528,(%esp)
80108698:	e8 c5 7e ff ff       	call   80100562 <panic>
  if(p->pgdir == 0)
8010869d:	8b 45 08             	mov    0x8(%ebp),%eax
801086a0:	8b 40 04             	mov    0x4(%eax),%eax
801086a3:	85 c0                	test   %eax,%eax
801086a5:	75 0c                	jne    801086b3 <switchuvm+0x45>
    panic("switchuvm: no pgdir");
801086a7:	c7 04 24 3d 95 10 80 	movl   $0x8010953d,(%esp)
801086ae:	e8 af 7e ff ff       	call   80100562 <panic>

  pushcli();
801086b3:	e8 0c d1 ff ff       	call   801057c4 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801086b8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801086be:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801086c5:	83 c2 08             	add    $0x8,%edx
801086c8:	89 d3                	mov    %edx,%ebx
801086ca:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801086d1:	83 c2 08             	add    $0x8,%edx
801086d4:	c1 ea 10             	shr    $0x10,%edx
801086d7:	89 d1                	mov    %edx,%ecx
801086d9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801086e0:	83 c2 08             	add    $0x8,%edx
801086e3:	c1 ea 18             	shr    $0x18,%edx
801086e6:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801086ed:	67 00 
801086ef:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
801086f6:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
801086fc:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108703:	83 e1 f0             	and    $0xfffffff0,%ecx
80108706:	83 c9 09             	or     $0x9,%ecx
80108709:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010870f:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108716:	83 c9 10             	or     $0x10,%ecx
80108719:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010871f:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108726:	83 e1 9f             	and    $0xffffff9f,%ecx
80108729:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010872f:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108736:	83 c9 80             	or     $0xffffff80,%ecx
80108739:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010873f:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108746:	83 e1 f0             	and    $0xfffffff0,%ecx
80108749:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010874f:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108756:	83 e1 ef             	and    $0xffffffef,%ecx
80108759:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010875f:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108766:	83 e1 df             	and    $0xffffffdf,%ecx
80108769:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010876f:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108776:	83 c9 40             	or     $0x40,%ecx
80108779:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010877f:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108786:	83 e1 7f             	and    $0x7f,%ecx
80108789:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010878f:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108795:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010879b:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801087a2:	83 e2 ef             	and    $0xffffffef,%edx
801087a5:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801087ab:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801087b1:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801087b7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801087bd:	8b 55 08             	mov    0x8(%ebp),%edx
801087c0:	8b 52 08             	mov    0x8(%edx),%edx
801087c3:	81 c2 00 10 00 00    	add    $0x1000,%edx
801087c9:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
801087cc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801087d2:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
801087d8:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
801087df:	e8 de f7 ff ff       	call   80107fc2 <ltr>
  lcr3(V2P(p->pgdir));  // switch to process's address space
801087e4:	8b 45 08             	mov    0x8(%ebp),%eax
801087e7:	8b 40 04             	mov    0x4(%eax),%eax
801087ea:	05 00 00 00 80       	add    $0x80000000,%eax
801087ef:	89 04 24             	mov    %eax,(%esp)
801087f2:	e8 f6 f7 ff ff       	call   80107fed <lcr3>
  popcli();
801087f7:	e8 1e d0 ff ff       	call   8010581a <popcli>
}
801087fc:	83 c4 14             	add    $0x14,%esp
801087ff:	5b                   	pop    %ebx
80108800:	5d                   	pop    %ebp
80108801:	c3                   	ret    

80108802 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108802:	55                   	push   %ebp
80108803:	89 e5                	mov    %esp,%ebp
80108805:	83 ec 38             	sub    $0x38,%esp
  char *mem;

  if(sz >= PGSIZE)
80108808:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010880f:	76 0c                	jbe    8010881d <inituvm+0x1b>
    panic("inituvm: more than a page");
80108811:	c7 04 24 51 95 10 80 	movl   $0x80109551,(%esp)
80108818:	e8 45 7d ff ff       	call   80100562 <panic>
  mem = kalloc();
8010881d:	e8 17 a6 ff ff       	call   80102e39 <kalloc>
80108822:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108825:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010882c:	00 
8010882d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108834:	00 
80108835:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108838:	89 04 24             	mov    %eax,(%esp)
8010883b:	e8 96 d0 ff ff       	call   801058d6 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108840:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108843:	05 00 00 00 80       	add    $0x80000000,%eax
80108848:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010884f:	00 
80108850:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108854:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010885b:	00 
8010885c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108863:	00 
80108864:	8b 45 08             	mov    0x8(%ebp),%eax
80108867:	89 04 24             	mov    %eax,(%esp)
8010886a:	e8 9b fc ff ff       	call   8010850a <mappages>
  memmove(mem, init, sz);
8010886f:	8b 45 10             	mov    0x10(%ebp),%eax
80108872:	89 44 24 08          	mov    %eax,0x8(%esp)
80108876:	8b 45 0c             	mov    0xc(%ebp),%eax
80108879:	89 44 24 04          	mov    %eax,0x4(%esp)
8010887d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108880:	89 04 24             	mov    %eax,(%esp)
80108883:	e8 1d d1 ff ff       	call   801059a5 <memmove>
}
80108888:	c9                   	leave  
80108889:	c3                   	ret    

8010888a <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010888a:	55                   	push   %ebp
8010888b:	89 e5                	mov    %esp,%ebp
8010888d:	83 ec 28             	sub    $0x28,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108890:	8b 45 0c             	mov    0xc(%ebp),%eax
80108893:	25 ff 0f 00 00       	and    $0xfff,%eax
80108898:	85 c0                	test   %eax,%eax
8010889a:	74 0c                	je     801088a8 <loaduvm+0x1e>
    panic("loaduvm: addr must be page aligned");
8010889c:	c7 04 24 6c 95 10 80 	movl   $0x8010956c,(%esp)
801088a3:	e8 ba 7c ff ff       	call   80100562 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801088a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801088af:	e9 a6 00 00 00       	jmp    8010895a <loaduvm+0xd0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801088b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088b7:	8b 55 0c             	mov    0xc(%ebp),%edx
801088ba:	01 d0                	add    %edx,%eax
801088bc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801088c3:	00 
801088c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801088c8:	8b 45 08             	mov    0x8(%ebp),%eax
801088cb:	89 04 24             	mov    %eax,(%esp)
801088ce:	e8 9b fb ff ff       	call   8010846e <walkpgdir>
801088d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801088d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801088da:	75 0c                	jne    801088e8 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
801088dc:	c7 04 24 8f 95 10 80 	movl   $0x8010958f,(%esp)
801088e3:	e8 7a 7c ff ff       	call   80100562 <panic>
    pa = PTE_ADDR(*pte);
801088e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088eb:	8b 00                	mov    (%eax),%eax
801088ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801088f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088f8:	8b 55 18             	mov    0x18(%ebp),%edx
801088fb:	29 c2                	sub    %eax,%edx
801088fd:	89 d0                	mov    %edx,%eax
801088ff:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108904:	77 0f                	ja     80108915 <loaduvm+0x8b>
      n = sz - i;
80108906:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108909:	8b 55 18             	mov    0x18(%ebp),%edx
8010890c:	29 c2                	sub    %eax,%edx
8010890e:	89 d0                	mov    %edx,%eax
80108910:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108913:	eb 07                	jmp    8010891c <loaduvm+0x92>
    else
      n = PGSIZE;
80108915:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010891c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010891f:	8b 55 14             	mov    0x14(%ebp),%edx
80108922:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80108925:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108928:	05 00 00 00 80       	add    $0x80000000,%eax
8010892d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108930:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108934:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80108938:	89 44 24 04          	mov    %eax,0x4(%esp)
8010893c:	8b 45 10             	mov    0x10(%ebp),%eax
8010893f:	89 04 24             	mov    %eax,(%esp)
80108942:	e8 1d 97 ff ff       	call   80102064 <readi>
80108947:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010894a:	74 07                	je     80108953 <loaduvm+0xc9>
      return -1;
8010894c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108951:	eb 18                	jmp    8010896b <loaduvm+0xe1>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108953:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010895a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010895d:	3b 45 18             	cmp    0x18(%ebp),%eax
80108960:	0f 82 4e ff ff ff    	jb     801088b4 <loaduvm+0x2a>
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108966:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010896b:	c9                   	leave  
8010896c:	c3                   	ret    

8010896d <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010896d:	55                   	push   %ebp
8010896e:	89 e5                	mov    %esp,%ebp
80108970:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108973:	8b 45 10             	mov    0x10(%ebp),%eax
80108976:	85 c0                	test   %eax,%eax
80108978:	79 0a                	jns    80108984 <allocuvm+0x17>
    return 0;
8010897a:	b8 00 00 00 00       	mov    $0x0,%eax
8010897f:	e9 fd 00 00 00       	jmp    80108a81 <allocuvm+0x114>
  if(newsz < oldsz)
80108984:	8b 45 10             	mov    0x10(%ebp),%eax
80108987:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010898a:	73 08                	jae    80108994 <allocuvm+0x27>
    return oldsz;
8010898c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010898f:	e9 ed 00 00 00       	jmp    80108a81 <allocuvm+0x114>

  a = PGROUNDUP(oldsz);
80108994:	8b 45 0c             	mov    0xc(%ebp),%eax
80108997:	05 ff 0f 00 00       	add    $0xfff,%eax
8010899c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801089a4:	e9 c9 00 00 00       	jmp    80108a72 <allocuvm+0x105>
    mem = kalloc();
801089a9:	e8 8b a4 ff ff       	call   80102e39 <kalloc>
801089ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801089b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801089b5:	75 2f                	jne    801089e6 <allocuvm+0x79>
      cprintf("allocuvm out of memory\n");
801089b7:	c7 04 24 ad 95 10 80 	movl   $0x801095ad,(%esp)
801089be:	e8 05 7a ff ff       	call   801003c8 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801089c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801089c6:	89 44 24 08          	mov    %eax,0x8(%esp)
801089ca:	8b 45 10             	mov    0x10(%ebp),%eax
801089cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801089d1:	8b 45 08             	mov    0x8(%ebp),%eax
801089d4:	89 04 24             	mov    %eax,(%esp)
801089d7:	e8 a7 00 00 00       	call   80108a83 <deallocuvm>
      return 0;
801089dc:	b8 00 00 00 00       	mov    $0x0,%eax
801089e1:	e9 9b 00 00 00       	jmp    80108a81 <allocuvm+0x114>
    }
    memset(mem, 0, PGSIZE);
801089e6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801089ed:	00 
801089ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801089f5:	00 
801089f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089f9:	89 04 24             	mov    %eax,(%esp)
801089fc:	e8 d5 ce ff ff       	call   801058d6 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a04:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a0d:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108a14:	00 
80108a15:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108a19:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108a20:	00 
80108a21:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a25:	8b 45 08             	mov    0x8(%ebp),%eax
80108a28:	89 04 24             	mov    %eax,(%esp)
80108a2b:	e8 da fa ff ff       	call   8010850a <mappages>
80108a30:	85 c0                	test   %eax,%eax
80108a32:	79 37                	jns    80108a6b <allocuvm+0xfe>
      cprintf("allocuvm out of memory (2)\n");
80108a34:	c7 04 24 c5 95 10 80 	movl   $0x801095c5,(%esp)
80108a3b:	e8 88 79 ff ff       	call   801003c8 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108a40:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a43:	89 44 24 08          	mov    %eax,0x8(%esp)
80108a47:	8b 45 10             	mov    0x10(%ebp),%eax
80108a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a4e:	8b 45 08             	mov    0x8(%ebp),%eax
80108a51:	89 04 24             	mov    %eax,(%esp)
80108a54:	e8 2a 00 00 00       	call   80108a83 <deallocuvm>
      kfree(mem);
80108a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a5c:	89 04 24             	mov    %eax,(%esp)
80108a5f:	e8 3f a3 ff ff       	call   80102da3 <kfree>
      return 0;
80108a64:	b8 00 00 00 00       	mov    $0x0,%eax
80108a69:	eb 16                	jmp    80108a81 <allocuvm+0x114>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108a6b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a75:	3b 45 10             	cmp    0x10(%ebp),%eax
80108a78:	0f 82 2b ff ff ff    	jb     801089a9 <allocuvm+0x3c>
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
80108a7e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108a81:	c9                   	leave  
80108a82:	c3                   	ret    

80108a83 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108a83:	55                   	push   %ebp
80108a84:	89 e5                	mov    %esp,%ebp
80108a86:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108a89:	8b 45 10             	mov    0x10(%ebp),%eax
80108a8c:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108a8f:	72 08                	jb     80108a99 <deallocuvm+0x16>
    return oldsz;
80108a91:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a94:	e9 ae 00 00 00       	jmp    80108b47 <deallocuvm+0xc4>

  a = PGROUNDUP(newsz);
80108a99:	8b 45 10             	mov    0x10(%ebp),%eax
80108a9c:	05 ff 0f 00 00       	add    $0xfff,%eax
80108aa1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108aa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108aa9:	e9 8a 00 00 00       	jmp    80108b38 <deallocuvm+0xb5>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ab1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108ab8:	00 
80108ab9:	89 44 24 04          	mov    %eax,0x4(%esp)
80108abd:	8b 45 08             	mov    0x8(%ebp),%eax
80108ac0:	89 04 24             	mov    %eax,(%esp)
80108ac3:	e8 a6 f9 ff ff       	call   8010846e <walkpgdir>
80108ac8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108acb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108acf:	75 16                	jne    80108ae7 <deallocuvm+0x64>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80108ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ad4:	c1 e8 16             	shr    $0x16,%eax
80108ad7:	83 c0 01             	add    $0x1,%eax
80108ada:	c1 e0 16             	shl    $0x16,%eax
80108add:	2d 00 10 00 00       	sub    $0x1000,%eax
80108ae2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108ae5:	eb 4a                	jmp    80108b31 <deallocuvm+0xae>
    else if((*pte & PTE_P) != 0){
80108ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108aea:	8b 00                	mov    (%eax),%eax
80108aec:	83 e0 01             	and    $0x1,%eax
80108aef:	85 c0                	test   %eax,%eax
80108af1:	74 3e                	je     80108b31 <deallocuvm+0xae>
      pa = PTE_ADDR(*pte);
80108af3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108af6:	8b 00                	mov    (%eax),%eax
80108af8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108afd:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108b00:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108b04:	75 0c                	jne    80108b12 <deallocuvm+0x8f>
        panic("kfree");
80108b06:	c7 04 24 e1 95 10 80 	movl   $0x801095e1,(%esp)
80108b0d:	e8 50 7a ff ff       	call   80100562 <panic>
      char *v = P2V(pa);
80108b12:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b15:	05 00 00 00 80       	add    $0x80000000,%eax
80108b1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108b1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b20:	89 04 24             	mov    %eax,(%esp)
80108b23:	e8 7b a2 ff ff       	call   80102da3 <kfree>
      *pte = 0;
80108b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108b31:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b3b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108b3e:	0f 82 6a ff ff ff    	jb     80108aae <deallocuvm+0x2b>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108b44:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108b47:	c9                   	leave  
80108b48:	c3                   	ret    

80108b49 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108b49:	55                   	push   %ebp
80108b4a:	89 e5                	mov    %esp,%ebp
80108b4c:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108b4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108b53:	75 0c                	jne    80108b61 <freevm+0x18>
    panic("freevm: no pgdir");
80108b55:	c7 04 24 e7 95 10 80 	movl   $0x801095e7,(%esp)
80108b5c:	e8 01 7a ff ff       	call   80100562 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108b61:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108b68:	00 
80108b69:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108b70:	80 
80108b71:	8b 45 08             	mov    0x8(%ebp),%eax
80108b74:	89 04 24             	mov    %eax,(%esp)
80108b77:	e8 07 ff ff ff       	call   80108a83 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108b7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b83:	eb 45                	jmp    80108bca <freevm+0x81>
    if(pgdir[i] & PTE_P){
80108b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b88:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108b8f:	8b 45 08             	mov    0x8(%ebp),%eax
80108b92:	01 d0                	add    %edx,%eax
80108b94:	8b 00                	mov    (%eax),%eax
80108b96:	83 e0 01             	and    $0x1,%eax
80108b99:	85 c0                	test   %eax,%eax
80108b9b:	74 29                	je     80108bc6 <freevm+0x7d>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ba0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108ba7:	8b 45 08             	mov    0x8(%ebp),%eax
80108baa:	01 d0                	add    %edx,%eax
80108bac:	8b 00                	mov    (%eax),%eax
80108bae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108bb3:	05 00 00 00 80       	add    $0x80000000,%eax
80108bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bbe:	89 04 24             	mov    %eax,(%esp)
80108bc1:	e8 dd a1 ff ff       	call   80102da3 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108bc6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108bca:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108bd1:	76 b2                	jbe    80108b85 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108bd3:	8b 45 08             	mov    0x8(%ebp),%eax
80108bd6:	89 04 24             	mov    %eax,(%esp)
80108bd9:	e8 c5 a1 ff ff       	call   80102da3 <kfree>
}
80108bde:	c9                   	leave  
80108bdf:	c3                   	ret    

80108be0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108be0:	55                   	push   %ebp
80108be1:	89 e5                	mov    %esp,%ebp
80108be3:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108be6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108bed:	00 
80108bee:	8b 45 0c             	mov    0xc(%ebp),%eax
80108bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
80108bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80108bf8:	89 04 24             	mov    %eax,(%esp)
80108bfb:	e8 6e f8 ff ff       	call   8010846e <walkpgdir>
80108c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108c03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108c07:	75 0c                	jne    80108c15 <clearpteu+0x35>
    panic("clearpteu");
80108c09:	c7 04 24 f8 95 10 80 	movl   $0x801095f8,(%esp)
80108c10:	e8 4d 79 ff ff       	call   80100562 <panic>
  *pte &= ~PTE_U;
80108c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c18:	8b 00                	mov    (%eax),%eax
80108c1a:	83 e0 fb             	and    $0xfffffffb,%eax
80108c1d:	89 c2                	mov    %eax,%edx
80108c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c22:	89 10                	mov    %edx,(%eax)
}
80108c24:	c9                   	leave  
80108c25:	c3                   	ret    

80108c26 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108c26:	55                   	push   %ebp
80108c27:	89 e5                	mov    %esp,%ebp
80108c29:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108c2c:	e8 71 f9 ff ff       	call   801085a2 <setupkvm>
80108c31:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108c34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108c38:	75 0a                	jne    80108c44 <copyuvm+0x1e>
    return 0;
80108c3a:	b8 00 00 00 00       	mov    $0x0,%eax
80108c3f:	e9 f8 00 00 00       	jmp    80108d3c <copyuvm+0x116>
  for(i = 0; i < sz; i += PGSIZE){
80108c44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108c4b:	e9 cb 00 00 00       	jmp    80108d1b <copyuvm+0xf5>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c53:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108c5a:	00 
80108c5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c5f:	8b 45 08             	mov    0x8(%ebp),%eax
80108c62:	89 04 24             	mov    %eax,(%esp)
80108c65:	e8 04 f8 ff ff       	call   8010846e <walkpgdir>
80108c6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108c6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108c71:	75 0c                	jne    80108c7f <copyuvm+0x59>
      panic("copyuvm: pte should exist");
80108c73:	c7 04 24 02 96 10 80 	movl   $0x80109602,(%esp)
80108c7a:	e8 e3 78 ff ff       	call   80100562 <panic>
    if(!(*pte & PTE_P))
80108c7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c82:	8b 00                	mov    (%eax),%eax
80108c84:	83 e0 01             	and    $0x1,%eax
80108c87:	85 c0                	test   %eax,%eax
80108c89:	75 0c                	jne    80108c97 <copyuvm+0x71>
      panic("copyuvm: page not present");
80108c8b:	c7 04 24 1c 96 10 80 	movl   $0x8010961c,(%esp)
80108c92:	e8 cb 78 ff ff       	call   80100562 <panic>
    pa = PTE_ADDR(*pte);
80108c97:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c9a:	8b 00                	mov    (%eax),%eax
80108c9c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ca1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108ca4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ca7:	8b 00                	mov    (%eax),%eax
80108ca9:	25 ff 0f 00 00       	and    $0xfff,%eax
80108cae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108cb1:	e8 83 a1 ff ff       	call   80102e39 <kalloc>
80108cb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108cb9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108cbd:	75 02                	jne    80108cc1 <copyuvm+0x9b>
      goto bad;
80108cbf:	eb 6b                	jmp    80108d2c <copyuvm+0x106>
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108cc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108cc4:	05 00 00 00 80       	add    $0x80000000,%eax
80108cc9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108cd0:	00 
80108cd1:	89 44 24 04          	mov    %eax,0x4(%esp)
80108cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108cd8:	89 04 24             	mov    %eax,(%esp)
80108cdb:	e8 c5 cc ff ff       	call   801059a5 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80108ce0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108ce3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108ce6:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80108cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cef:	89 54 24 10          	mov    %edx,0x10(%esp)
80108cf3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80108cf7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108cfe:	00 
80108cff:	89 44 24 04          	mov    %eax,0x4(%esp)
80108d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d06:	89 04 24             	mov    %eax,(%esp)
80108d09:	e8 fc f7 ff ff       	call   8010850a <mappages>
80108d0e:	85 c0                	test   %eax,%eax
80108d10:	79 02                	jns    80108d14 <copyuvm+0xee>
      goto bad;
80108d12:	eb 18                	jmp    80108d2c <copyuvm+0x106>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108d14:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d1e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108d21:	0f 82 29 ff ff ff    	jb     80108c50 <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  return d;
80108d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d2a:	eb 10                	jmp    80108d3c <copyuvm+0x116>

bad:
  freevm(d);
80108d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d2f:	89 04 24             	mov    %eax,(%esp)
80108d32:	e8 12 fe ff ff       	call   80108b49 <freevm>
  return 0;
80108d37:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d3c:	c9                   	leave  
80108d3d:	c3                   	ret    

80108d3e <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108d3e:	55                   	push   %ebp
80108d3f:	89 e5                	mov    %esp,%ebp
80108d41:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108d44:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108d4b:	00 
80108d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108d53:	8b 45 08             	mov    0x8(%ebp),%eax
80108d56:	89 04 24             	mov    %eax,(%esp)
80108d59:	e8 10 f7 ff ff       	call   8010846e <walkpgdir>
80108d5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d64:	8b 00                	mov    (%eax),%eax
80108d66:	83 e0 01             	and    $0x1,%eax
80108d69:	85 c0                	test   %eax,%eax
80108d6b:	75 07                	jne    80108d74 <uva2ka+0x36>
    return 0;
80108d6d:	b8 00 00 00 00       	mov    $0x0,%eax
80108d72:	eb 22                	jmp    80108d96 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d77:	8b 00                	mov    (%eax),%eax
80108d79:	83 e0 04             	and    $0x4,%eax
80108d7c:	85 c0                	test   %eax,%eax
80108d7e:	75 07                	jne    80108d87 <uva2ka+0x49>
    return 0;
80108d80:	b8 00 00 00 00       	mov    $0x0,%eax
80108d85:	eb 0f                	jmp    80108d96 <uva2ka+0x58>
  return (char*)P2V(PTE_ADDR(*pte));
80108d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d8a:	8b 00                	mov    (%eax),%eax
80108d8c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d91:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108d96:	c9                   	leave  
80108d97:	c3                   	ret    

80108d98 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108d98:	55                   	push   %ebp
80108d99:	89 e5                	mov    %esp,%ebp
80108d9b:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108d9e:	8b 45 10             	mov    0x10(%ebp),%eax
80108da1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108da4:	e9 87 00 00 00       	jmp    80108e30 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
80108da9:	8b 45 0c             	mov    0xc(%ebp),%eax
80108dac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108db1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108db4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108db7:	89 44 24 04          	mov    %eax,0x4(%esp)
80108dbb:	8b 45 08             	mov    0x8(%ebp),%eax
80108dbe:	89 04 24             	mov    %eax,(%esp)
80108dc1:	e8 78 ff ff ff       	call   80108d3e <uva2ka>
80108dc6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108dc9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108dcd:	75 07                	jne    80108dd6 <copyout+0x3e>
      return -1;
80108dcf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108dd4:	eb 69                	jmp    80108e3f <copyout+0xa7>
    n = PGSIZE - (va - va0);
80108dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80108dd9:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108ddc:	29 c2                	sub    %eax,%edx
80108dde:	89 d0                	mov    %edx,%eax
80108de0:	05 00 10 00 00       	add    $0x1000,%eax
80108de5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108deb:	3b 45 14             	cmp    0x14(%ebp),%eax
80108dee:	76 06                	jbe    80108df6 <copyout+0x5e>
      n = len;
80108df0:	8b 45 14             	mov    0x14(%ebp),%eax
80108df3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108df6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108df9:	8b 55 0c             	mov    0xc(%ebp),%edx
80108dfc:	29 c2                	sub    %eax,%edx
80108dfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e01:	01 c2                	add    %eax,%edx
80108e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e06:	89 44 24 08          	mov    %eax,0x8(%esp)
80108e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108e11:	89 14 24             	mov    %edx,(%esp)
80108e14:	e8 8c cb ff ff       	call   801059a5 <memmove>
    len -= n;
80108e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e1c:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e22:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108e25:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e28:	05 00 10 00 00       	add    $0x1000,%eax
80108e2d:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108e30:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108e34:	0f 85 6f ff ff ff    	jne    80108da9 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108e3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108e3f:	c9                   	leave  
80108e40:	c3                   	ret    

80108e41 <my_syscall>:
#include "defs.h"

//Simple system call
int
my_syscall(char *str)
{
80108e41:	55                   	push   %ebp
80108e42:	89 e5                	mov    %esp,%ebp
80108e44:	83 ec 18             	sub    $0x18,%esp
    cprintf("%s\n", str);
80108e47:	8b 45 08             	mov    0x8(%ebp),%eax
80108e4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80108e4e:	c7 04 24 36 96 10 80 	movl   $0x80109636,(%esp)
80108e55:	e8 6e 75 ff ff       	call   801003c8 <cprintf>
    return 0xABCDABCD;
80108e5a:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
}
80108e5f:	c9                   	leave  
80108e60:	c3                   	ret    

80108e61 <sys_my_syscall>:
//Wrapper for my_syscall
int
sys_my_syscall(void)
{
80108e61:	55                   	push   %ebp
80108e62:	89 e5                	mov    %esp,%ebp
80108e64:	83 ec 28             	sub    $0x28,%esp
    char *str;
    //Decode argument using argstr
    if (argstr(0, &str) < 0)
80108e67:	8d 45 f4             	lea    -0xc(%ebp),%eax
80108e6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80108e6e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80108e75:	e8 34 ce ff ff       	call   80105cae <argstr>
80108e7a:	85 c0                	test   %eax,%eax
80108e7c:	79 07                	jns    80108e85 <sys_my_syscall+0x24>
        return -1;
80108e7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e83:	eb 0b                	jmp    80108e90 <sys_my_syscall+0x2f>
        return my_syscall(str);
80108e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e88:	89 04 24             	mov    %eax,(%esp)
80108e8b:	e8 b1 ff ff ff       	call   80108e41 <my_syscall>
}
80108e90:	c9                   	leave  
80108e91:	c3                   	ret    

80108e92 <my_yield>:
#include "types.h"
#include "defs.h"

void my_yield(void){
80108e92:	55                   	push   %ebp
80108e93:	89 e5                	mov    %esp,%ebp
80108e95:	83 ec 08             	sub    $0x8,%esp
    
    yield();
80108e98:	e8 85 c3 ff ff       	call   80105222 <yield>
}
80108e9d:	c9                   	leave  
80108e9e:	c3                   	ret    

80108e9f <sys_yield>:
int sys_yield(void)
{
80108e9f:	55                   	push   %ebp
80108ea0:	89 e5                	mov    %esp,%ebp
80108ea2:	83 ec 08             	sub    $0x8,%esp
   my_yield();
80108ea5:	e8 e8 ff ff ff       	call   80108e92 <my_yield>
   return 0;
80108eaa:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108eaf:	c9                   	leave  
80108eb0:	c3                   	ret    

80108eb1 <getlev>:
#include "param.h"
#include "mmu.h"
#include "proc.h"

int getlev(void)
{
80108eb1:	55                   	push   %ebp
80108eb2:	89 e5                	mov    %esp,%ebp
80108eb4:	83 ec 28             	sub    $0x28,%esp
    //get MLFQ priority level
   int level=0;
80108eb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
   level = proc->level;
80108ebe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108ec4:	8b 40 7c             	mov    0x7c(%eax),%eax
80108ec7:	89 45 f4             	mov    %eax,-0xc(%ebp)
   cprintf("current process is %d\n",level);
80108eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ecd:	89 44 24 04          	mov    %eax,0x4(%esp)
80108ed1:	c7 04 24 3a 96 10 80 	movl   $0x8010963a,(%esp)
80108ed8:	e8 eb 74 ff ff       	call   801003c8 <cprintf>
   return 0;
80108edd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108ee2:	c9                   	leave  
80108ee3:	c3                   	ret    

80108ee4 <sys_getlev>:
//Wrapper
int sys_getlev(void)
{
80108ee4:	55                   	push   %ebp
80108ee5:	89 e5                	mov    %esp,%ebp
80108ee7:	83 ec 08             	sub    $0x8,%esp
    return getlev();
80108eea:	e8 c2 ff ff ff       	call   80108eb1 <getlev>
}
80108eef:	c9                   	leave  
80108ef0:	c3                   	ret    
