
_test_mlfq:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
// Number of level(priority) of MLFQ scheduler
#define MLFQ_LEVEL      3

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	83 ec 40             	sub    $0x40,%esp
    uint i;
    int cnt_level[MLFQ_LEVEL] = {0, 0, 0};
   a:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%esp)
  11:	00 
  12:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
  19:	00 
  1a:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%esp)
  21:	00 
    int do_yield;
    int curr_mlfq_level;

    if (argc < 2) {
  22:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  26:	7f 19                	jg     41 <main+0x41>
        printf(1, "usage: sched_test_mlfq do_yield_or_not(0|1)\n");
  28:	c7 44 24 04 f4 09 00 	movl   $0x9f4,0x4(%esp)
  2f:	00 
  30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  37:	e8 f4 04 00 00       	call   530 <printf>
        exit();
  3c:	e8 37 03 00 00       	call   378 <exit>
    }

    do_yield = atoi(argv[1]);
  41:	8b 45 0c             	mov    0xc(%ebp),%eax
  44:	83 c0 04             	add    $0x4,%eax
  47:	8b 00                	mov    (%eax),%eax
  49:	89 04 24             	mov    %eax,(%esp)
  4c:	e8 95 02 00 00       	call   2e6 <atoi>
  51:	89 44 24 38          	mov    %eax,0x38(%esp)

    i = 0;
  55:	c7 44 24 3c 00 00 00 	movl   $0x0,0x3c(%esp)
  5c:	00 
    while (1) {
        i++;
  5d:	83 44 24 3c 01       	addl   $0x1,0x3c(%esp)
        
        // Prevent code optimization
        __sync_synchronize();
  62:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

        if (i % YIELD_PERIOD == 0) {
  67:	8b 4c 24 3c          	mov    0x3c(%esp),%ecx
  6b:	ba 59 17 b7 d1       	mov    $0xd1b71759,%edx
  70:	89 c8                	mov    %ecx,%eax
  72:	f7 e2                	mul    %edx
  74:	89 d0                	mov    %edx,%eax
  76:	c1 e8 0d             	shr    $0xd,%eax
  79:	69 c0 10 27 00 00    	imul   $0x2710,%eax,%eax
  7f:	29 c1                	sub    %eax,%ecx
  81:	89 c8                	mov    %ecx,%eax
  83:	85 c0                	test   %eax,%eax
  85:	0f 85 80 00 00 00    	jne    10b <main+0x10b>
            // Get current MLFQ level(priority) of this process
            curr_mlfq_level = getlev();
  8b:	e8 a0 03 00 00       	call   430 <getlev>
  90:	89 44 24 34          	mov    %eax,0x34(%esp)
            cnt_level[curr_mlfq_level]++;
  94:	8b 44 24 34          	mov    0x34(%esp),%eax
  98:	8b 44 84 28          	mov    0x28(%esp,%eax,4),%eax
  9c:	8d 50 01             	lea    0x1(%eax),%edx
  9f:	8b 44 24 34          	mov    0x34(%esp),%eax
  a3:	89 54 84 28          	mov    %edx,0x28(%esp,%eax,4)

            if (i > LIFETIME) {
  a7:	81 7c 24 3c 00 c2 eb 	cmpl   $0xbebc200,0x3c(%esp)
  ae:	0b 
  af:	76 49                	jbe    fa <main+0xfa>
                printf(1, "MLFQ(%s), lev[0]: %d, lev[1]: %d, lev[2]: %d\n",
  b1:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  b5:	8b 4c 24 2c          	mov    0x2c(%esp),%ecx
  b9:	8b 54 24 28          	mov    0x28(%esp),%edx
  bd:	83 7c 24 38 00       	cmpl   $0x0,0x38(%esp)
  c2:	75 07                	jne    cb <main+0xcb>
  c4:	b8 21 0a 00 00       	mov    $0xa21,%eax
  c9:	eb 05                	jmp    d0 <main+0xd0>
  cb:	b8 29 0a 00 00       	mov    $0xa29,%eax
  d0:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  d4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  d8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  e0:	c7 44 24 04 30 0a 00 	movl   $0xa30,0x4(%esp)
  e7:	00 
  e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ef:	e8 3c 04 00 00       	call   530 <printf>
                        do_yield==0 ? "compute" : "yield",
                        cnt_level[0], cnt_level[1], cnt_level[2]);
                break;
  f4:	90                   	nop
                yield();
            }
        }
    }

    exit();
  f5:	e8 7e 02 00 00       	call   378 <exit>
                        do_yield==0 ? "compute" : "yield",
                        cnt_level[0], cnt_level[1], cnt_level[2]);
                break;
            }

            if (do_yield) {
  fa:	83 7c 24 38 00       	cmpl   $0x0,0x38(%esp)
  ff:	74 0a                	je     10b <main+0x10b>
                // Yield process itself, not by timer interrupt
                yield();
 101:	e8 22 03 00 00       	call   428 <yield>
            }
        }
    }
 106:	e9 52 ff ff ff       	jmp    5d <main+0x5d>
 10b:	e9 4d ff ff ff       	jmp    5d <main+0x5d>

00000110 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 115:	8b 4d 08             	mov    0x8(%ebp),%ecx
 118:	8b 55 10             	mov    0x10(%ebp),%edx
 11b:	8b 45 0c             	mov    0xc(%ebp),%eax
 11e:	89 cb                	mov    %ecx,%ebx
 120:	89 df                	mov    %ebx,%edi
 122:	89 d1                	mov    %edx,%ecx
 124:	fc                   	cld    
 125:	f3 aa                	rep stos %al,%es:(%edi)
 127:	89 ca                	mov    %ecx,%edx
 129:	89 fb                	mov    %edi,%ebx
 12b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 131:	5b                   	pop    %ebx
 132:	5f                   	pop    %edi
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    

00000135 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 141:	90                   	nop
 142:	8b 45 08             	mov    0x8(%ebp),%eax
 145:	8d 50 01             	lea    0x1(%eax),%edx
 148:	89 55 08             	mov    %edx,0x8(%ebp)
 14b:	8b 55 0c             	mov    0xc(%ebp),%edx
 14e:	8d 4a 01             	lea    0x1(%edx),%ecx
 151:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 154:	0f b6 12             	movzbl (%edx),%edx
 157:	88 10                	mov    %dl,(%eax)
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	84 c0                	test   %al,%al
 15e:	75 e2                	jne    142 <strcpy+0xd>
    ;
  return os;
 160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 168:	eb 08                	jmp    172 <strcmp+0xd>
    p++, q++;
 16a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	74 10                	je     18c <strcmp+0x27>
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 10             	movzbl (%eax),%edx
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	38 c2                	cmp    %al,%dl
 18a:	74 de                	je     16a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	0f b6 d0             	movzbl %al,%edx
 195:	8b 45 0c             	mov    0xc(%ebp),%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	0f b6 c0             	movzbl %al,%eax
 19e:	29 c2                	sub    %eax,%edx
 1a0:	89 d0                	mov    %edx,%eax
}
 1a2:	5d                   	pop    %ebp
 1a3:	c3                   	ret    

000001a4 <strlen>:

uint
strlen(char *s)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b1:	eb 04                	jmp    1b7 <strlen+0x13>
 1b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 d0                	add    %edx,%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	84 c0                	test   %al,%al
 1c4:	75 ed                	jne    1b3 <strlen+0xf>
    ;
  return n;
 1c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
 1ce:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d1:	8b 45 10             	mov    0x10(%ebp),%eax
 1d4:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1db:	89 44 24 04          	mov    %eax,0x4(%esp)
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	89 04 24             	mov    %eax,(%esp)
 1e5:	e8 26 ff ff ff       	call   110 <stosb>
  return dst;
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ed:	c9                   	leave  
 1ee:	c3                   	ret    

000001ef <strchr>:

char*
strchr(const char *s, char c)
{
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	83 ec 04             	sub    $0x4,%esp
 1f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f8:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1fb:	eb 14                	jmp    211 <strchr+0x22>
    if(*s == c)
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	0f b6 00             	movzbl (%eax),%eax
 203:	3a 45 fc             	cmp    -0x4(%ebp),%al
 206:	75 05                	jne    20d <strchr+0x1e>
      return (char*)s;
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	eb 13                	jmp    220 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 20d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 211:	8b 45 08             	mov    0x8(%ebp),%eax
 214:	0f b6 00             	movzbl (%eax),%eax
 217:	84 c0                	test   %al,%al
 219:	75 e2                	jne    1fd <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 21b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 220:	c9                   	leave  
 221:	c3                   	ret    

00000222 <gets>:

char*
gets(char *buf, int max)
{
 222:	55                   	push   %ebp
 223:	89 e5                	mov    %esp,%ebp
 225:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 22f:	eb 4c                	jmp    27d <gets+0x5b>
    cc = read(0, &c, 1);
 231:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 238:	00 
 239:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23c:	89 44 24 04          	mov    %eax,0x4(%esp)
 240:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 247:	e8 44 01 00 00       	call   390 <read>
 24c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 24f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 253:	7f 02                	jg     257 <gets+0x35>
      break;
 255:	eb 31                	jmp    288 <gets+0x66>
    buf[i++] = c;
 257:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25a:	8d 50 01             	lea    0x1(%eax),%edx
 25d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 260:	89 c2                	mov    %eax,%edx
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	01 c2                	add    %eax,%edx
 267:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 26d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 271:	3c 0a                	cmp    $0xa,%al
 273:	74 13                	je     288 <gets+0x66>
 275:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 279:	3c 0d                	cmp    $0xd,%al
 27b:	74 0b                	je     288 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 280:	83 c0 01             	add    $0x1,%eax
 283:	3b 45 0c             	cmp    0xc(%ebp),%eax
 286:	7c a9                	jl     231 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 288:	8b 55 f4             	mov    -0xc(%ebp),%edx
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	01 d0                	add    %edx,%eax
 290:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 293:	8b 45 08             	mov    0x8(%ebp),%eax
}
 296:	c9                   	leave  
 297:	c3                   	ret    

00000298 <stat>:

int
stat(char *n, struct stat *st)
{
 298:	55                   	push   %ebp
 299:	89 e5                	mov    %esp,%ebp
 29b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a5:	00 
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	89 04 24             	mov    %eax,(%esp)
 2ac:	e8 07 01 00 00       	call   3b8 <open>
 2b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b8:	79 07                	jns    2c1 <stat+0x29>
    return -1;
 2ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2bf:	eb 23                	jmp    2e4 <stat+0x4c>
  r = fstat(fd, st);
 2c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2cb:	89 04 24             	mov    %eax,(%esp)
 2ce:	e8 fd 00 00 00       	call   3d0 <fstat>
 2d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d9:	89 04 24             	mov    %eax,(%esp)
 2dc:	e8 bf 00 00 00       	call   3a0 <close>
  return r;
 2e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e4:	c9                   	leave  
 2e5:	c3                   	ret    

000002e6 <atoi>:

int
atoi(const char *s)
{
 2e6:	55                   	push   %ebp
 2e7:	89 e5                	mov    %esp,%ebp
 2e9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f3:	eb 25                	jmp    31a <atoi+0x34>
    n = n*10 + *s++ - '0';
 2f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f8:	89 d0                	mov    %edx,%eax
 2fa:	c1 e0 02             	shl    $0x2,%eax
 2fd:	01 d0                	add    %edx,%eax
 2ff:	01 c0                	add    %eax,%eax
 301:	89 c1                	mov    %eax,%ecx
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	8d 50 01             	lea    0x1(%eax),%edx
 309:	89 55 08             	mov    %edx,0x8(%ebp)
 30c:	0f b6 00             	movzbl (%eax),%eax
 30f:	0f be c0             	movsbl %al,%eax
 312:	01 c8                	add    %ecx,%eax
 314:	83 e8 30             	sub    $0x30,%eax
 317:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 31a:	8b 45 08             	mov    0x8(%ebp),%eax
 31d:	0f b6 00             	movzbl (%eax),%eax
 320:	3c 2f                	cmp    $0x2f,%al
 322:	7e 0a                	jle    32e <atoi+0x48>
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	0f b6 00             	movzbl (%eax),%eax
 32a:	3c 39                	cmp    $0x39,%al
 32c:	7e c7                	jle    2f5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 32e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 331:	c9                   	leave  
 332:	c3                   	ret    

00000333 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 333:	55                   	push   %ebp
 334:	89 e5                	mov    %esp,%ebp
 336:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 339:	8b 45 08             	mov    0x8(%ebp),%eax
 33c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 33f:	8b 45 0c             	mov    0xc(%ebp),%eax
 342:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 345:	eb 17                	jmp    35e <memmove+0x2b>
    *dst++ = *src++;
 347:	8b 45 fc             	mov    -0x4(%ebp),%eax
 34a:	8d 50 01             	lea    0x1(%eax),%edx
 34d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 350:	8b 55 f8             	mov    -0x8(%ebp),%edx
 353:	8d 4a 01             	lea    0x1(%edx),%ecx
 356:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 359:	0f b6 12             	movzbl (%edx),%edx
 35c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35e:	8b 45 10             	mov    0x10(%ebp),%eax
 361:	8d 50 ff             	lea    -0x1(%eax),%edx
 364:	89 55 10             	mov    %edx,0x10(%ebp)
 367:	85 c0                	test   %eax,%eax
 369:	7f dc                	jg     347 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 36b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36e:	c9                   	leave  
 36f:	c3                   	ret    

00000370 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 370:	b8 01 00 00 00       	mov    $0x1,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <exit>:
SYSCALL(exit)
 378:	b8 02 00 00 00       	mov    $0x2,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <wait>:
SYSCALL(wait)
 380:	b8 03 00 00 00       	mov    $0x3,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <pipe>:
SYSCALL(pipe)
 388:	b8 04 00 00 00       	mov    $0x4,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <read>:
SYSCALL(read)
 390:	b8 05 00 00 00       	mov    $0x5,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <write>:
SYSCALL(write)
 398:	b8 10 00 00 00       	mov    $0x10,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <close>:
SYSCALL(close)
 3a0:	b8 15 00 00 00       	mov    $0x15,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <kill>:
SYSCALL(kill)
 3a8:	b8 06 00 00 00       	mov    $0x6,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <exec>:
SYSCALL(exec)
 3b0:	b8 07 00 00 00       	mov    $0x7,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <open>:
SYSCALL(open)
 3b8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <mknod>:
SYSCALL(mknod)
 3c0:	b8 11 00 00 00       	mov    $0x11,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <unlink>:
SYSCALL(unlink)
 3c8:	b8 12 00 00 00       	mov    $0x12,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <fstat>:
SYSCALL(fstat)
 3d0:	b8 08 00 00 00       	mov    $0x8,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <link>:
SYSCALL(link)
 3d8:	b8 13 00 00 00       	mov    $0x13,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <mkdir>:
SYSCALL(mkdir)
 3e0:	b8 14 00 00 00       	mov    $0x14,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <chdir>:
SYSCALL(chdir)
 3e8:	b8 09 00 00 00       	mov    $0x9,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <dup>:
SYSCALL(dup)
 3f0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <getpid>:
SYSCALL(getpid)
 3f8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <sbrk>:
SYSCALL(sbrk)
 400:	b8 0c 00 00 00       	mov    $0xc,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <sleep>:
SYSCALL(sleep)
 408:	b8 0d 00 00 00       	mov    $0xd,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <uptime>:
SYSCALL(uptime)
 410:	b8 0e 00 00 00       	mov    $0xe,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <my_syscall>:
SYSCALL(my_syscall)
 418:	b8 16 00 00 00       	mov    $0x16,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <getppid>:
SYSCALL(getppid)
 420:	b8 17 00 00 00       	mov    $0x17,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <yield>:
SYSCALL(yield)
 428:	b8 18 00 00 00       	mov    $0x18,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <getlev>:
SYSCALL(getlev)
 430:	b8 19 00 00 00       	mov    $0x19,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <clone>:
SYSCALL(clone)
 438:	b8 1a 00 00 00       	mov    $0x1a,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <join>:
SYSCALL(join)
 440:	b8 1b 00 00 00       	mov    $0x1b,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <thexit>:
SYSCALL(thexit)
 448:	b8 1c 00 00 00       	mov    $0x1c,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	83 ec 18             	sub    $0x18,%esp
 456:	8b 45 0c             	mov    0xc(%ebp),%eax
 459:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 45c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 463:	00 
 464:	8d 45 f4             	lea    -0xc(%ebp),%eax
 467:	89 44 24 04          	mov    %eax,0x4(%esp)
 46b:	8b 45 08             	mov    0x8(%ebp),%eax
 46e:	89 04 24             	mov    %eax,(%esp)
 471:	e8 22 ff ff ff       	call   398 <write>
}
 476:	c9                   	leave  
 477:	c3                   	ret    

00000478 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 478:	55                   	push   %ebp
 479:	89 e5                	mov    %esp,%ebp
 47b:	56                   	push   %esi
 47c:	53                   	push   %ebx
 47d:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 480:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 487:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 48b:	74 17                	je     4a4 <printint+0x2c>
 48d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 491:	79 11                	jns    4a4 <printint+0x2c>
    neg = 1;
 493:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 49a:	8b 45 0c             	mov    0xc(%ebp),%eax
 49d:	f7 d8                	neg    %eax
 49f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a2:	eb 06                	jmp    4aa <printint+0x32>
  } else {
    x = xx;
 4a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4b1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4b4:	8d 41 01             	lea    0x1(%ecx),%eax
 4b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c0:	ba 00 00 00 00       	mov    $0x0,%edx
 4c5:	f7 f3                	div    %ebx
 4c7:	89 d0                	mov    %edx,%eax
 4c9:	0f b6 80 28 0d 00 00 	movzbl 0xd28(%eax),%eax
 4d0:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4d4:	8b 75 10             	mov    0x10(%ebp),%esi
 4d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4da:	ba 00 00 00 00       	mov    $0x0,%edx
 4df:	f7 f6                	div    %esi
 4e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e8:	75 c7                	jne    4b1 <printint+0x39>
  if(neg)
 4ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ee:	74 10                	je     500 <printint+0x88>
    buf[i++] = '-';
 4f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f3:	8d 50 01             	lea    0x1(%eax),%edx
 4f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4f9:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4fe:	eb 1f                	jmp    51f <printint+0xa7>
 500:	eb 1d                	jmp    51f <printint+0xa7>
    putc(fd, buf[i]);
 502:	8d 55 dc             	lea    -0x24(%ebp),%edx
 505:	8b 45 f4             	mov    -0xc(%ebp),%eax
 508:	01 d0                	add    %edx,%eax
 50a:	0f b6 00             	movzbl (%eax),%eax
 50d:	0f be c0             	movsbl %al,%eax
 510:	89 44 24 04          	mov    %eax,0x4(%esp)
 514:	8b 45 08             	mov    0x8(%ebp),%eax
 517:	89 04 24             	mov    %eax,(%esp)
 51a:	e8 31 ff ff ff       	call   450 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 51f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 523:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 527:	79 d9                	jns    502 <printint+0x8a>
    putc(fd, buf[i]);
}
 529:	83 c4 30             	add    $0x30,%esp
 52c:	5b                   	pop    %ebx
 52d:	5e                   	pop    %esi
 52e:	5d                   	pop    %ebp
 52f:	c3                   	ret    

00000530 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 536:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 53d:	8d 45 0c             	lea    0xc(%ebp),%eax
 540:	83 c0 04             	add    $0x4,%eax
 543:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 546:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 54d:	e9 7c 01 00 00       	jmp    6ce <printf+0x19e>
    c = fmt[i] & 0xff;
 552:	8b 55 0c             	mov    0xc(%ebp),%edx
 555:	8b 45 f0             	mov    -0x10(%ebp),%eax
 558:	01 d0                	add    %edx,%eax
 55a:	0f b6 00             	movzbl (%eax),%eax
 55d:	0f be c0             	movsbl %al,%eax
 560:	25 ff 00 00 00       	and    $0xff,%eax
 565:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 568:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 56c:	75 2c                	jne    59a <printf+0x6a>
      if(c == '%'){
 56e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 572:	75 0c                	jne    580 <printf+0x50>
        state = '%';
 574:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 57b:	e9 4a 01 00 00       	jmp    6ca <printf+0x19a>
      } else {
        putc(fd, c);
 580:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 583:	0f be c0             	movsbl %al,%eax
 586:	89 44 24 04          	mov    %eax,0x4(%esp)
 58a:	8b 45 08             	mov    0x8(%ebp),%eax
 58d:	89 04 24             	mov    %eax,(%esp)
 590:	e8 bb fe ff ff       	call   450 <putc>
 595:	e9 30 01 00 00       	jmp    6ca <printf+0x19a>
      }
    } else if(state == '%'){
 59a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 59e:	0f 85 26 01 00 00    	jne    6ca <printf+0x19a>
      if(c == 'd'){
 5a4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5a8:	75 2d                	jne    5d7 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ad:	8b 00                	mov    (%eax),%eax
 5af:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5b6:	00 
 5b7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5be:	00 
 5bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c3:	8b 45 08             	mov    0x8(%ebp),%eax
 5c6:	89 04 24             	mov    %eax,(%esp)
 5c9:	e8 aa fe ff ff       	call   478 <printint>
        ap++;
 5ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d2:	e9 ec 00 00 00       	jmp    6c3 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5d7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5db:	74 06                	je     5e3 <printf+0xb3>
 5dd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5e1:	75 2d                	jne    610 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e6:	8b 00                	mov    (%eax),%eax
 5e8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5ef:	00 
 5f0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5f7:	00 
 5f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fc:	8b 45 08             	mov    0x8(%ebp),%eax
 5ff:	89 04 24             	mov    %eax,(%esp)
 602:	e8 71 fe ff ff       	call   478 <printint>
        ap++;
 607:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60b:	e9 b3 00 00 00       	jmp    6c3 <printf+0x193>
      } else if(c == 's'){
 610:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 614:	75 45                	jne    65b <printf+0x12b>
        s = (char*)*ap;
 616:	8b 45 e8             	mov    -0x18(%ebp),%eax
 619:	8b 00                	mov    (%eax),%eax
 61b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 61e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 622:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 626:	75 09                	jne    631 <printf+0x101>
          s = "(null)";
 628:	c7 45 f4 5e 0a 00 00 	movl   $0xa5e,-0xc(%ebp)
        while(*s != 0){
 62f:	eb 1e                	jmp    64f <printf+0x11f>
 631:	eb 1c                	jmp    64f <printf+0x11f>
          putc(fd, *s);
 633:	8b 45 f4             	mov    -0xc(%ebp),%eax
 636:	0f b6 00             	movzbl (%eax),%eax
 639:	0f be c0             	movsbl %al,%eax
 63c:	89 44 24 04          	mov    %eax,0x4(%esp)
 640:	8b 45 08             	mov    0x8(%ebp),%eax
 643:	89 04 24             	mov    %eax,(%esp)
 646:	e8 05 fe ff ff       	call   450 <putc>
          s++;
 64b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 64f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 652:	0f b6 00             	movzbl (%eax),%eax
 655:	84 c0                	test   %al,%al
 657:	75 da                	jne    633 <printf+0x103>
 659:	eb 68                	jmp    6c3 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 65b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 65f:	75 1d                	jne    67e <printf+0x14e>
        putc(fd, *ap);
 661:	8b 45 e8             	mov    -0x18(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	0f be c0             	movsbl %al,%eax
 669:	89 44 24 04          	mov    %eax,0x4(%esp)
 66d:	8b 45 08             	mov    0x8(%ebp),%eax
 670:	89 04 24             	mov    %eax,(%esp)
 673:	e8 d8 fd ff ff       	call   450 <putc>
        ap++;
 678:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67c:	eb 45                	jmp    6c3 <printf+0x193>
      } else if(c == '%'){
 67e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 682:	75 17                	jne    69b <printf+0x16b>
        putc(fd, c);
 684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 687:	0f be c0             	movsbl %al,%eax
 68a:	89 44 24 04          	mov    %eax,0x4(%esp)
 68e:	8b 45 08             	mov    0x8(%ebp),%eax
 691:	89 04 24             	mov    %eax,(%esp)
 694:	e8 b7 fd ff ff       	call   450 <putc>
 699:	eb 28                	jmp    6c3 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 69b:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6a2:	00 
 6a3:	8b 45 08             	mov    0x8(%ebp),%eax
 6a6:	89 04 24             	mov    %eax,(%esp)
 6a9:	e8 a2 fd ff ff       	call   450 <putc>
        putc(fd, c);
 6ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b1:	0f be c0             	movsbl %al,%eax
 6b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b8:	8b 45 08             	mov    0x8(%ebp),%eax
 6bb:	89 04 24             	mov    %eax,(%esp)
 6be:	e8 8d fd ff ff       	call   450 <putc>
      }
      state = 0;
 6c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ca:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6ce:	8b 55 0c             	mov    0xc(%ebp),%edx
 6d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d4:	01 d0                	add    %edx,%eax
 6d6:	0f b6 00             	movzbl (%eax),%eax
 6d9:	84 c0                	test   %al,%al
 6db:	0f 85 71 fe ff ff    	jne    552 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6e1:	c9                   	leave  
 6e2:	c3                   	ret    

000006e3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e3:	55                   	push   %ebp
 6e4:	89 e5                	mov    %esp,%ebp
 6e6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e9:	8b 45 08             	mov    0x8(%ebp),%eax
 6ec:	83 e8 08             	sub    $0x8,%eax
 6ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f2:	a1 44 0d 00 00       	mov    0xd44,%eax
 6f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6fa:	eb 24                	jmp    720 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	8b 00                	mov    (%eax),%eax
 701:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 704:	77 12                	ja     718 <free+0x35>
 706:	8b 45 f8             	mov    -0x8(%ebp),%eax
 709:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70c:	77 24                	ja     732 <free+0x4f>
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	8b 00                	mov    (%eax),%eax
 713:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 716:	77 1a                	ja     732 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 718:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71b:	8b 00                	mov    (%eax),%eax
 71d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 720:	8b 45 f8             	mov    -0x8(%ebp),%eax
 723:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 726:	76 d4                	jbe    6fc <free+0x19>
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 00                	mov    (%eax),%eax
 72d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 730:	76 ca                	jbe    6fc <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 732:	8b 45 f8             	mov    -0x8(%ebp),%eax
 735:	8b 40 04             	mov    0x4(%eax),%eax
 738:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 73f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 742:	01 c2                	add    %eax,%edx
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	8b 00                	mov    (%eax),%eax
 749:	39 c2                	cmp    %eax,%edx
 74b:	75 24                	jne    771 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 74d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 750:	8b 50 04             	mov    0x4(%eax),%edx
 753:	8b 45 fc             	mov    -0x4(%ebp),%eax
 756:	8b 00                	mov    (%eax),%eax
 758:	8b 40 04             	mov    0x4(%eax),%eax
 75b:	01 c2                	add    %eax,%edx
 75d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 760:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 763:	8b 45 fc             	mov    -0x4(%ebp),%eax
 766:	8b 00                	mov    (%eax),%eax
 768:	8b 10                	mov    (%eax),%edx
 76a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76d:	89 10                	mov    %edx,(%eax)
 76f:	eb 0a                	jmp    77b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	8b 10                	mov    (%eax),%edx
 776:	8b 45 f8             	mov    -0x8(%ebp),%eax
 779:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 40 04             	mov    0x4(%eax),%eax
 781:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 788:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78b:	01 d0                	add    %edx,%eax
 78d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 790:	75 20                	jne    7b2 <free+0xcf>
    p->s.size += bp->s.size;
 792:	8b 45 fc             	mov    -0x4(%ebp),%eax
 795:	8b 50 04             	mov    0x4(%eax),%edx
 798:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79b:	8b 40 04             	mov    0x4(%eax),%eax
 79e:	01 c2                	add    %eax,%edx
 7a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a9:	8b 10                	mov    (%eax),%edx
 7ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ae:	89 10                	mov    %edx,(%eax)
 7b0:	eb 08                	jmp    7ba <free+0xd7>
  } else
    p->s.ptr = bp;
 7b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7b8:	89 10                	mov    %edx,(%eax)
  freep = p;
 7ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bd:	a3 44 0d 00 00       	mov    %eax,0xd44
}
 7c2:	c9                   	leave  
 7c3:	c3                   	ret    

000007c4 <morecore>:

static Header*
morecore(uint nu)
{
 7c4:	55                   	push   %ebp
 7c5:	89 e5                	mov    %esp,%ebp
 7c7:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7ca:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7d1:	77 07                	ja     7da <morecore+0x16>
    nu = 4096;
 7d3:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7da:	8b 45 08             	mov    0x8(%ebp),%eax
 7dd:	c1 e0 03             	shl    $0x3,%eax
 7e0:	89 04 24             	mov    %eax,(%esp)
 7e3:	e8 18 fc ff ff       	call   400 <sbrk>
 7e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7eb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7ef:	75 07                	jne    7f8 <morecore+0x34>
    return 0;
 7f1:	b8 00 00 00 00       	mov    $0x0,%eax
 7f6:	eb 22                	jmp    81a <morecore+0x56>
  hp = (Header*)p;
 7f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 801:	8b 55 08             	mov    0x8(%ebp),%edx
 804:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 807:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80a:	83 c0 08             	add    $0x8,%eax
 80d:	89 04 24             	mov    %eax,(%esp)
 810:	e8 ce fe ff ff       	call   6e3 <free>
  return freep;
 815:	a1 44 0d 00 00       	mov    0xd44,%eax
}
 81a:	c9                   	leave  
 81b:	c3                   	ret    

0000081c <malloc>:

void*
malloc(uint nbytes)
{
 81c:	55                   	push   %ebp
 81d:	89 e5                	mov    %esp,%ebp
 81f:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 822:	8b 45 08             	mov    0x8(%ebp),%eax
 825:	83 c0 07             	add    $0x7,%eax
 828:	c1 e8 03             	shr    $0x3,%eax
 82b:	83 c0 01             	add    $0x1,%eax
 82e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 831:	a1 44 0d 00 00       	mov    0xd44,%eax
 836:	89 45 f0             	mov    %eax,-0x10(%ebp)
 839:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 83d:	75 23                	jne    862 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 83f:	c7 45 f0 3c 0d 00 00 	movl   $0xd3c,-0x10(%ebp)
 846:	8b 45 f0             	mov    -0x10(%ebp),%eax
 849:	a3 44 0d 00 00       	mov    %eax,0xd44
 84e:	a1 44 0d 00 00       	mov    0xd44,%eax
 853:	a3 3c 0d 00 00       	mov    %eax,0xd3c
    base.s.size = 0;
 858:	c7 05 40 0d 00 00 00 	movl   $0x0,0xd40
 85f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 862:	8b 45 f0             	mov    -0x10(%ebp),%eax
 865:	8b 00                	mov    (%eax),%eax
 867:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 86a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86d:	8b 40 04             	mov    0x4(%eax),%eax
 870:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 873:	72 4d                	jb     8c2 <malloc+0xa6>
      if(p->s.size == nunits)
 875:	8b 45 f4             	mov    -0xc(%ebp),%eax
 878:	8b 40 04             	mov    0x4(%eax),%eax
 87b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 87e:	75 0c                	jne    88c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 880:	8b 45 f4             	mov    -0xc(%ebp),%eax
 883:	8b 10                	mov    (%eax),%edx
 885:	8b 45 f0             	mov    -0x10(%ebp),%eax
 888:	89 10                	mov    %edx,(%eax)
 88a:	eb 26                	jmp    8b2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	8b 40 04             	mov    0x4(%eax),%eax
 892:	2b 45 ec             	sub    -0x14(%ebp),%eax
 895:	89 c2                	mov    %eax,%edx
 897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 89d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a0:	8b 40 04             	mov    0x4(%eax),%eax
 8a3:	c1 e0 03             	shl    $0x3,%eax
 8a6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8af:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b5:	a3 44 0d 00 00       	mov    %eax,0xd44
      return (void*)(p + 1);
 8ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bd:	83 c0 08             	add    $0x8,%eax
 8c0:	eb 38                	jmp    8fa <malloc+0xde>
    }
    if(p == freep)
 8c2:	a1 44 0d 00 00       	mov    0xd44,%eax
 8c7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8ca:	75 1b                	jne    8e7 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8cf:	89 04 24             	mov    %eax,(%esp)
 8d2:	e8 ed fe ff ff       	call   7c4 <morecore>
 8d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8de:	75 07                	jne    8e7 <malloc+0xcb>
        return 0;
 8e0:	b8 00 00 00 00       	mov    $0x0,%eax
 8e5:	eb 13                	jmp    8fa <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f0:	8b 00                	mov    (%eax),%eax
 8f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8f5:	e9 70 ff ff ff       	jmp    86a <malloc+0x4e>
}
 8fa:	c9                   	leave  
 8fb:	c3                   	ret    

000008fc <thread_create>:
#include"x86.h"
#include"param.h"
#include"proc.h"

int thread_create(thread_t *thread, void*(*start_routine)(void*),void *arg)
{
 8fc:	55                   	push   %ebp
 8fd:	89 e5                	mov    %esp,%ebp
 8ff:	83 ec 28             	sub    $0x28,%esp
    void *stack = malloc(PGSIZE);
 902:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 909:	e8 0e ff ff ff       	call   81c <malloc>
 90e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if((uint)stack <=0)
 911:	8b 45 f4             	mov    -0xc(%ebp),%eax
 914:	85 c0                	test   %eax,%eax
 916:	75 1b                	jne    933 <thread_create+0x37>
    {
        printf(1,"malloc thread stack failed\n");
 918:	c7 44 24 04 65 0a 00 	movl   $0xa65,0x4(%esp)
 91f:	00 
 920:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 927:	e8 04 fc ff ff       	call   530 <printf>
        return -1;
 92c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 931:	eb 67                	jmp    99a <thread_create+0x9e>
    }
    
    if((uint)stack%PGSIZE)
 933:	8b 45 f4             	mov    -0xc(%ebp),%eax
 936:	25 ff 0f 00 00       	and    $0xfff,%eax
 93b:	85 c0                	test   %eax,%eax
 93d:	74 14                	je     953 <thread_create+0x57>
        stack += PGSIZE-((uint)stack%PGSIZE);
 93f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 942:	25 ff 0f 00 00       	and    $0xfff,%eax
 947:	89 c2                	mov    %eax,%edx
 949:	b8 00 10 00 00       	mov    $0x1000,%eax
 94e:	29 d0                	sub    %edx,%eax
 950:	01 45 f4             	add    %eax,-0xc(%ebp)
    printf(1,"1\n");
 953:	c7 44 24 04 81 0a 00 	movl   $0xa81,0x4(%esp)
 95a:	00 
 95b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 962:	e8 c9 fb ff ff       	call   530 <printf>
    if((*thread = clone(start_routine,arg,stack))<0)
 967:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96a:	89 44 24 08          	mov    %eax,0x8(%esp)
 96e:	8b 45 10             	mov    0x10(%ebp),%eax
 971:	89 44 24 04          	mov    %eax,0x4(%esp)
 975:	8b 45 0c             	mov    0xc(%ebp),%eax
 978:	89 04 24             	mov    %eax,(%esp)
 97b:	e8 b8 fa ff ff       	call   438 <clone>
 980:	8b 55 08             	mov    0x8(%ebp),%edx
 983:	89 02                	mov    %eax,(%edx)
 985:	8b 45 08             	mov    0x8(%ebp),%eax
 988:	8b 00                	mov    (%eax),%eax
 98a:	85 c0                	test   %eax,%eax
 98c:	79 07                	jns    995 <thread_create+0x99>
        return -1;
 98e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 993:	eb 05                	jmp    99a <thread_create+0x9e>
    return 0;
 995:	b8 00 00 00 00       	mov    $0x0,%eax
}
 99a:	c9                   	leave  
 99b:	c3                   	ret    

0000099c <thread_join>:

int thread_join(thread_t thread, void **retval)
{
 99c:	55                   	push   %ebp
 99d:	89 e5                	mov    %esp,%ebp
 99f:	83 ec 28             	sub    $0x28,%esp
    void *stack;
    if(join((uint)thread, &stack, retval)<0)
 9a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 9a5:	89 44 24 08          	mov    %eax,0x8(%esp)
 9a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 9ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 9b0:	8b 45 08             	mov    0x8(%ebp),%eax
 9b3:	89 04 24             	mov    %eax,(%esp)
 9b6:	e8 85 fa ff ff       	call   440 <join>
 9bb:	85 c0                	test   %eax,%eax
 9bd:	79 07                	jns    9c6 <thread_join+0x2a>
        return -1;
 9bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9c4:	eb 10                	jmp    9d6 <thread_join+0x3a>

    free(stack);
 9c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c9:	89 04 24             	mov    %eax,(%esp)
 9cc:	e8 12 fd ff ff       	call   6e3 <free>
    return 0;
 9d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 9d6:	c9                   	leave  
 9d7:	c3                   	ret    

000009d8 <thread_exit>:

void thread_exit(void *retval)
{
 9d8:	55                   	push   %ebp
 9d9:	89 e5                	mov    %esp,%ebp
 9db:	83 ec 08             	sub    $0x8,%esp
    proc->retval = retval;
 9de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 9e4:	8b 55 08             	mov    0x8(%ebp),%edx
 9e7:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
    thexit();
 9ed:	e8 56 fa ff ff       	call   448 <thexit>
}
 9f2:	c9                   	leave  
 9f3:	c3                   	ret    
