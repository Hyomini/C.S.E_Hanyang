
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  for(i = 1; i < argc; i++)
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 4b                	jmp    5e <main+0x5e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	83 c0 01             	add    $0x1,%eax
  1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  1d:	7d 07                	jge    26 <main+0x26>
  1f:	b8 50 09 00 00       	mov    $0x950,%eax
  24:	eb 05                	jmp    2b <main+0x2b>
  26:	b8 52 09 00 00       	mov    $0x952,%eax
  2b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2f:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  36:	8b 55 0c             	mov    0xc(%ebp),%edx
  39:	01 ca                	add    %ecx,%edx
  3b:	8b 12                	mov    (%edx),%edx
  3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  41:	89 54 24 08          	mov    %edx,0x8(%esp)
  45:	c7 44 24 04 54 09 00 	movl   $0x954,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  54:	e8 33 04 00 00       	call   48c <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  59:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  5e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  62:	3b 45 08             	cmp    0x8(%ebp),%eax
  65:	7c ac                	jl     13 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  67:	e8 68 02 00 00       	call   2d4 <exit>

0000006c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	57                   	push   %edi
  70:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  74:	8b 55 10             	mov    0x10(%ebp),%edx
  77:	8b 45 0c             	mov    0xc(%ebp),%eax
  7a:	89 cb                	mov    %ecx,%ebx
  7c:	89 df                	mov    %ebx,%edi
  7e:	89 d1                	mov    %edx,%ecx
  80:	fc                   	cld    
  81:	f3 aa                	rep stos %al,%es:(%edi)
  83:	89 ca                	mov    %ecx,%edx
  85:	89 fb                	mov    %edi,%ebx
  87:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8d:	5b                   	pop    %ebx
  8e:	5f                   	pop    %edi
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    

00000091 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  91:	55                   	push   %ebp
  92:	89 e5                	mov    %esp,%ebp
  94:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  97:	8b 45 08             	mov    0x8(%ebp),%eax
  9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  9d:	90                   	nop
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	8d 50 01             	lea    0x1(%eax),%edx
  a4:	89 55 08             	mov    %edx,0x8(%ebp)
  a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b0:	0f b6 12             	movzbl (%edx),%edx
  b3:	88 10                	mov    %dl,(%eax)
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	84 c0                	test   %al,%al
  ba:	75 e2                	jne    9e <strcpy+0xd>
    ;
  return os;
  bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  bf:	c9                   	leave  
  c0:	c3                   	ret    

000000c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c4:	eb 08                	jmp    ce <strcmp+0xd>
    p++, q++;
  c6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ca:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ce:	8b 45 08             	mov    0x8(%ebp),%eax
  d1:	0f b6 00             	movzbl (%eax),%eax
  d4:	84 c0                	test   %al,%al
  d6:	74 10                	je     e8 <strcmp+0x27>
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	0f b6 10             	movzbl (%eax),%edx
  de:	8b 45 0c             	mov    0xc(%ebp),%eax
  e1:	0f b6 00             	movzbl (%eax),%eax
  e4:	38 c2                	cmp    %al,%dl
  e6:	74 de                	je     c6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	0f b6 00             	movzbl (%eax),%eax
  ee:	0f b6 d0             	movzbl %al,%edx
  f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 c0             	movzbl %al,%eax
  fa:	29 c2                	sub    %eax,%edx
  fc:	89 d0                	mov    %edx,%eax
}
  fe:	5d                   	pop    %ebp
  ff:	c3                   	ret    

00000100 <strlen>:

uint
strlen(char *s)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 106:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10d:	eb 04                	jmp    113 <strlen+0x13>
 10f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 113:	8b 55 fc             	mov    -0x4(%ebp),%edx
 116:	8b 45 08             	mov    0x8(%ebp),%eax
 119:	01 d0                	add    %edx,%eax
 11b:	0f b6 00             	movzbl (%eax),%eax
 11e:	84 c0                	test   %al,%al
 120:	75 ed                	jne    10f <strlen+0xf>
    ;
  return n;
 122:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 125:	c9                   	leave  
 126:	c3                   	ret    

00000127 <memset>:

void*
memset(void *dst, int c, uint n)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 12d:	8b 45 10             	mov    0x10(%ebp),%eax
 130:	89 44 24 08          	mov    %eax,0x8(%esp)
 134:	8b 45 0c             	mov    0xc(%ebp),%eax
 137:	89 44 24 04          	mov    %eax,0x4(%esp)
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 04 24             	mov    %eax,(%esp)
 141:	e8 26 ff ff ff       	call   6c <stosb>
  return dst;
 146:	8b 45 08             	mov    0x8(%ebp),%eax
}
 149:	c9                   	leave  
 14a:	c3                   	ret    

0000014b <strchr>:

char*
strchr(const char *s, char c)
{
 14b:	55                   	push   %ebp
 14c:	89 e5                	mov    %esp,%ebp
 14e:	83 ec 04             	sub    $0x4,%esp
 151:	8b 45 0c             	mov    0xc(%ebp),%eax
 154:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 157:	eb 14                	jmp    16d <strchr+0x22>
    if(*s == c)
 159:	8b 45 08             	mov    0x8(%ebp),%eax
 15c:	0f b6 00             	movzbl (%eax),%eax
 15f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 162:	75 05                	jne    169 <strchr+0x1e>
      return (char*)s;
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	eb 13                	jmp    17c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 169:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	0f b6 00             	movzbl (%eax),%eax
 173:	84 c0                	test   %al,%al
 175:	75 e2                	jne    159 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 177:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17c:	c9                   	leave  
 17d:	c3                   	ret    

0000017e <gets>:

char*
gets(char *buf, int max)
{
 17e:	55                   	push   %ebp
 17f:	89 e5                	mov    %esp,%ebp
 181:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 184:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18b:	eb 4c                	jmp    1d9 <gets+0x5b>
    cc = read(0, &c, 1);
 18d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 194:	00 
 195:	8d 45 ef             	lea    -0x11(%ebp),%eax
 198:	89 44 24 04          	mov    %eax,0x4(%esp)
 19c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a3:	e8 44 01 00 00       	call   2ec <read>
 1a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1af:	7f 02                	jg     1b3 <gets+0x35>
      break;
 1b1:	eb 31                	jmp    1e4 <gets+0x66>
    buf[i++] = c;
 1b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b6:	8d 50 01             	lea    0x1(%eax),%edx
 1b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1bc:	89 c2                	mov    %eax,%edx
 1be:	8b 45 08             	mov    0x8(%ebp),%eax
 1c1:	01 c2                	add    %eax,%edx
 1c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cd:	3c 0a                	cmp    $0xa,%al
 1cf:	74 13                	je     1e4 <gets+0x66>
 1d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d5:	3c 0d                	cmp    $0xd,%al
 1d7:	74 0b                	je     1e4 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1dc:	83 c0 01             	add    $0x1,%eax
 1df:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1e2:	7c a9                	jl     18d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	01 d0                	add    %edx,%eax
 1ec:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f2:	c9                   	leave  
 1f3:	c3                   	ret    

000001f4 <stat>:

int
stat(char *n, struct stat *st)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 201:	00 
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	89 04 24             	mov    %eax,(%esp)
 208:	e8 07 01 00 00       	call   314 <open>
 20d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 210:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 214:	79 07                	jns    21d <stat+0x29>
    return -1;
 216:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 21b:	eb 23                	jmp    240 <stat+0x4c>
  r = fstat(fd, st);
 21d:	8b 45 0c             	mov    0xc(%ebp),%eax
 220:	89 44 24 04          	mov    %eax,0x4(%esp)
 224:	8b 45 f4             	mov    -0xc(%ebp),%eax
 227:	89 04 24             	mov    %eax,(%esp)
 22a:	e8 fd 00 00 00       	call   32c <fstat>
 22f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 232:	8b 45 f4             	mov    -0xc(%ebp),%eax
 235:	89 04 24             	mov    %eax,(%esp)
 238:	e8 bf 00 00 00       	call   2fc <close>
  return r;
 23d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 240:	c9                   	leave  
 241:	c3                   	ret    

00000242 <atoi>:

int
atoi(const char *s)
{
 242:	55                   	push   %ebp
 243:	89 e5                	mov    %esp,%ebp
 245:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 24f:	eb 25                	jmp    276 <atoi+0x34>
    n = n*10 + *s++ - '0';
 251:	8b 55 fc             	mov    -0x4(%ebp),%edx
 254:	89 d0                	mov    %edx,%eax
 256:	c1 e0 02             	shl    $0x2,%eax
 259:	01 d0                	add    %edx,%eax
 25b:	01 c0                	add    %eax,%eax
 25d:	89 c1                	mov    %eax,%ecx
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	8d 50 01             	lea    0x1(%eax),%edx
 265:	89 55 08             	mov    %edx,0x8(%ebp)
 268:	0f b6 00             	movzbl (%eax),%eax
 26b:	0f be c0             	movsbl %al,%eax
 26e:	01 c8                	add    %ecx,%eax
 270:	83 e8 30             	sub    $0x30,%eax
 273:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	0f b6 00             	movzbl (%eax),%eax
 27c:	3c 2f                	cmp    $0x2f,%al
 27e:	7e 0a                	jle    28a <atoi+0x48>
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	0f b6 00             	movzbl (%eax),%eax
 286:	3c 39                	cmp    $0x39,%al
 288:	7e c7                	jle    251 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 28a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 28d:	c9                   	leave  
 28e:	c3                   	ret    

0000028f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 28f:	55                   	push   %ebp
 290:	89 e5                	mov    %esp,%ebp
 292:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 29b:	8b 45 0c             	mov    0xc(%ebp),%eax
 29e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2a1:	eb 17                	jmp    2ba <memmove+0x2b>
    *dst++ = *src++;
 2a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a6:	8d 50 01             	lea    0x1(%eax),%edx
 2a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2af:	8d 4a 01             	lea    0x1(%edx),%ecx
 2b2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2b5:	0f b6 12             	movzbl (%edx),%edx
 2b8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ba:	8b 45 10             	mov    0x10(%ebp),%eax
 2bd:	8d 50 ff             	lea    -0x1(%eax),%edx
 2c0:	89 55 10             	mov    %edx,0x10(%ebp)
 2c3:	85 c0                	test   %eax,%eax
 2c5:	7f dc                	jg     2a3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ca:	c9                   	leave  
 2cb:	c3                   	ret    

000002cc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2cc:	b8 01 00 00 00       	mov    $0x1,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <exit>:
SYSCALL(exit)
 2d4:	b8 02 00 00 00       	mov    $0x2,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <wait>:
SYSCALL(wait)
 2dc:	b8 03 00 00 00       	mov    $0x3,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <pipe>:
SYSCALL(pipe)
 2e4:	b8 04 00 00 00       	mov    $0x4,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <read>:
SYSCALL(read)
 2ec:	b8 05 00 00 00       	mov    $0x5,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <write>:
SYSCALL(write)
 2f4:	b8 10 00 00 00       	mov    $0x10,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <close>:
SYSCALL(close)
 2fc:	b8 15 00 00 00       	mov    $0x15,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <kill>:
SYSCALL(kill)
 304:	b8 06 00 00 00       	mov    $0x6,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <exec>:
SYSCALL(exec)
 30c:	b8 07 00 00 00       	mov    $0x7,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <open>:
SYSCALL(open)
 314:	b8 0f 00 00 00       	mov    $0xf,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <mknod>:
SYSCALL(mknod)
 31c:	b8 11 00 00 00       	mov    $0x11,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <unlink>:
SYSCALL(unlink)
 324:	b8 12 00 00 00       	mov    $0x12,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <fstat>:
SYSCALL(fstat)
 32c:	b8 08 00 00 00       	mov    $0x8,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <link>:
SYSCALL(link)
 334:	b8 13 00 00 00       	mov    $0x13,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <mkdir>:
SYSCALL(mkdir)
 33c:	b8 14 00 00 00       	mov    $0x14,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <chdir>:
SYSCALL(chdir)
 344:	b8 09 00 00 00       	mov    $0x9,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <dup>:
SYSCALL(dup)
 34c:	b8 0a 00 00 00       	mov    $0xa,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <getpid>:
SYSCALL(getpid)
 354:	b8 0b 00 00 00       	mov    $0xb,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <sbrk>:
SYSCALL(sbrk)
 35c:	b8 0c 00 00 00       	mov    $0xc,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <sleep>:
SYSCALL(sleep)
 364:	b8 0d 00 00 00       	mov    $0xd,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <uptime>:
SYSCALL(uptime)
 36c:	b8 0e 00 00 00       	mov    $0xe,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <my_syscall>:
SYSCALL(my_syscall)
 374:	b8 16 00 00 00       	mov    $0x16,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <getppid>:
SYSCALL(getppid)
 37c:	b8 17 00 00 00       	mov    $0x17,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <yield>:
SYSCALL(yield)
 384:	b8 18 00 00 00       	mov    $0x18,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <getlev>:
SYSCALL(getlev)
 38c:	b8 19 00 00 00       	mov    $0x19,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <clone>:
SYSCALL(clone)
 394:	b8 1a 00 00 00       	mov    $0x1a,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <join>:
SYSCALL(join)
 39c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <thexit>:
SYSCALL(thexit)
 3a4:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
 3af:	83 ec 18             	sub    $0x18,%esp
 3b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3b8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3bf:	00 
 3c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	89 04 24             	mov    %eax,(%esp)
 3cd:	e8 22 ff ff ff       	call   2f4 <write>
}
 3d2:	c9                   	leave  
 3d3:	c3                   	ret    

000003d4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d4:	55                   	push   %ebp
 3d5:	89 e5                	mov    %esp,%ebp
 3d7:	56                   	push   %esi
 3d8:	53                   	push   %ebx
 3d9:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3e3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3e7:	74 17                	je     400 <printint+0x2c>
 3e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3ed:	79 11                	jns    400 <printint+0x2c>
    neg = 1;
 3ef:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f9:	f7 d8                	neg    %eax
 3fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3fe:	eb 06                	jmp    406 <printint+0x32>
  } else {
    x = xx;
 400:	8b 45 0c             	mov    0xc(%ebp),%eax
 403:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 40d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 410:	8d 41 01             	lea    0x1(%ecx),%eax
 413:	89 45 f4             	mov    %eax,-0xc(%ebp)
 416:	8b 5d 10             	mov    0x10(%ebp),%ebx
 419:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41c:	ba 00 00 00 00       	mov    $0x0,%edx
 421:	f7 f3                	div    %ebx
 423:	89 d0                	mov    %edx,%eax
 425:	0f b6 80 24 0c 00 00 	movzbl 0xc24(%eax),%eax
 42c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 430:	8b 75 10             	mov    0x10(%ebp),%esi
 433:	8b 45 ec             	mov    -0x14(%ebp),%eax
 436:	ba 00 00 00 00       	mov    $0x0,%edx
 43b:	f7 f6                	div    %esi
 43d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 440:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 444:	75 c7                	jne    40d <printint+0x39>
  if(neg)
 446:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 44a:	74 10                	je     45c <printint+0x88>
    buf[i++] = '-';
 44c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44f:	8d 50 01             	lea    0x1(%eax),%edx
 452:	89 55 f4             	mov    %edx,-0xc(%ebp)
 455:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 45a:	eb 1f                	jmp    47b <printint+0xa7>
 45c:	eb 1d                	jmp    47b <printint+0xa7>
    putc(fd, buf[i]);
 45e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 461:	8b 45 f4             	mov    -0xc(%ebp),%eax
 464:	01 d0                	add    %edx,%eax
 466:	0f b6 00             	movzbl (%eax),%eax
 469:	0f be c0             	movsbl %al,%eax
 46c:	89 44 24 04          	mov    %eax,0x4(%esp)
 470:	8b 45 08             	mov    0x8(%ebp),%eax
 473:	89 04 24             	mov    %eax,(%esp)
 476:	e8 31 ff ff ff       	call   3ac <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 47b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 47f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 483:	79 d9                	jns    45e <printint+0x8a>
    putc(fd, buf[i]);
}
 485:	83 c4 30             	add    $0x30,%esp
 488:	5b                   	pop    %ebx
 489:	5e                   	pop    %esi
 48a:	5d                   	pop    %ebp
 48b:	c3                   	ret    

0000048c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 48c:	55                   	push   %ebp
 48d:	89 e5                	mov    %esp,%ebp
 48f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 492:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 499:	8d 45 0c             	lea    0xc(%ebp),%eax
 49c:	83 c0 04             	add    $0x4,%eax
 49f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4a9:	e9 7c 01 00 00       	jmp    62a <printf+0x19e>
    c = fmt[i] & 0xff;
 4ae:	8b 55 0c             	mov    0xc(%ebp),%edx
 4b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4b4:	01 d0                	add    %edx,%eax
 4b6:	0f b6 00             	movzbl (%eax),%eax
 4b9:	0f be c0             	movsbl %al,%eax
 4bc:	25 ff 00 00 00       	and    $0xff,%eax
 4c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c8:	75 2c                	jne    4f6 <printf+0x6a>
      if(c == '%'){
 4ca:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4ce:	75 0c                	jne    4dc <printf+0x50>
        state = '%';
 4d0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4d7:	e9 4a 01 00 00       	jmp    626 <printf+0x19a>
      } else {
        putc(fd, c);
 4dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4df:	0f be c0             	movsbl %al,%eax
 4e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e6:	8b 45 08             	mov    0x8(%ebp),%eax
 4e9:	89 04 24             	mov    %eax,(%esp)
 4ec:	e8 bb fe ff ff       	call   3ac <putc>
 4f1:	e9 30 01 00 00       	jmp    626 <printf+0x19a>
      }
    } else if(state == '%'){
 4f6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4fa:	0f 85 26 01 00 00    	jne    626 <printf+0x19a>
      if(c == 'd'){
 500:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 504:	75 2d                	jne    533 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 506:	8b 45 e8             	mov    -0x18(%ebp),%eax
 509:	8b 00                	mov    (%eax),%eax
 50b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 512:	00 
 513:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 51a:	00 
 51b:	89 44 24 04          	mov    %eax,0x4(%esp)
 51f:	8b 45 08             	mov    0x8(%ebp),%eax
 522:	89 04 24             	mov    %eax,(%esp)
 525:	e8 aa fe ff ff       	call   3d4 <printint>
        ap++;
 52a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52e:	e9 ec 00 00 00       	jmp    61f <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 533:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 537:	74 06                	je     53f <printf+0xb3>
 539:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 53d:	75 2d                	jne    56c <printf+0xe0>
        printint(fd, *ap, 16, 0);
 53f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 542:	8b 00                	mov    (%eax),%eax
 544:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 54b:	00 
 54c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 553:	00 
 554:	89 44 24 04          	mov    %eax,0x4(%esp)
 558:	8b 45 08             	mov    0x8(%ebp),%eax
 55b:	89 04 24             	mov    %eax,(%esp)
 55e:	e8 71 fe ff ff       	call   3d4 <printint>
        ap++;
 563:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 567:	e9 b3 00 00 00       	jmp    61f <printf+0x193>
      } else if(c == 's'){
 56c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 570:	75 45                	jne    5b7 <printf+0x12b>
        s = (char*)*ap;
 572:	8b 45 e8             	mov    -0x18(%ebp),%eax
 575:	8b 00                	mov    (%eax),%eax
 577:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 57a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 57e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 582:	75 09                	jne    58d <printf+0x101>
          s = "(null)";
 584:	c7 45 f4 59 09 00 00 	movl   $0x959,-0xc(%ebp)
        while(*s != 0){
 58b:	eb 1e                	jmp    5ab <printf+0x11f>
 58d:	eb 1c                	jmp    5ab <printf+0x11f>
          putc(fd, *s);
 58f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 592:	0f b6 00             	movzbl (%eax),%eax
 595:	0f be c0             	movsbl %al,%eax
 598:	89 44 24 04          	mov    %eax,0x4(%esp)
 59c:	8b 45 08             	mov    0x8(%ebp),%eax
 59f:	89 04 24             	mov    %eax,(%esp)
 5a2:	e8 05 fe ff ff       	call   3ac <putc>
          s++;
 5a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ae:	0f b6 00             	movzbl (%eax),%eax
 5b1:	84 c0                	test   %al,%al
 5b3:	75 da                	jne    58f <printf+0x103>
 5b5:	eb 68                	jmp    61f <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5b7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5bb:	75 1d                	jne    5da <printf+0x14e>
        putc(fd, *ap);
 5bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c0:	8b 00                	mov    (%eax),%eax
 5c2:	0f be c0             	movsbl %al,%eax
 5c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c9:	8b 45 08             	mov    0x8(%ebp),%eax
 5cc:	89 04 24             	mov    %eax,(%esp)
 5cf:	e8 d8 fd ff ff       	call   3ac <putc>
        ap++;
 5d4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d8:	eb 45                	jmp    61f <printf+0x193>
      } else if(c == '%'){
 5da:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5de:	75 17                	jne    5f7 <printf+0x16b>
        putc(fd, c);
 5e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e3:	0f be c0             	movsbl %al,%eax
 5e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ea:	8b 45 08             	mov    0x8(%ebp),%eax
 5ed:	89 04 24             	mov    %eax,(%esp)
 5f0:	e8 b7 fd ff ff       	call   3ac <putc>
 5f5:	eb 28                	jmp    61f <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5fe:	00 
 5ff:	8b 45 08             	mov    0x8(%ebp),%eax
 602:	89 04 24             	mov    %eax,(%esp)
 605:	e8 a2 fd ff ff       	call   3ac <putc>
        putc(fd, c);
 60a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60d:	0f be c0             	movsbl %al,%eax
 610:	89 44 24 04          	mov    %eax,0x4(%esp)
 614:	8b 45 08             	mov    0x8(%ebp),%eax
 617:	89 04 24             	mov    %eax,(%esp)
 61a:	e8 8d fd ff ff       	call   3ac <putc>
      }
      state = 0;
 61f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 626:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 62a:	8b 55 0c             	mov    0xc(%ebp),%edx
 62d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 630:	01 d0                	add    %edx,%eax
 632:	0f b6 00             	movzbl (%eax),%eax
 635:	84 c0                	test   %al,%al
 637:	0f 85 71 fe ff ff    	jne    4ae <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 63d:	c9                   	leave  
 63e:	c3                   	ret    

0000063f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 63f:	55                   	push   %ebp
 640:	89 e5                	mov    %esp,%ebp
 642:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 645:	8b 45 08             	mov    0x8(%ebp),%eax
 648:	83 e8 08             	sub    $0x8,%eax
 64b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64e:	a1 40 0c 00 00       	mov    0xc40,%eax
 653:	89 45 fc             	mov    %eax,-0x4(%ebp)
 656:	eb 24                	jmp    67c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 658:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65b:	8b 00                	mov    (%eax),%eax
 65d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 660:	77 12                	ja     674 <free+0x35>
 662:	8b 45 f8             	mov    -0x8(%ebp),%eax
 665:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 668:	77 24                	ja     68e <free+0x4f>
 66a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66d:	8b 00                	mov    (%eax),%eax
 66f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 672:	77 1a                	ja     68e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 682:	76 d4                	jbe    658 <free+0x19>
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68c:	76 ca                	jbe    658 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 68e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 691:	8b 40 04             	mov    0x4(%eax),%eax
 694:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 69b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69e:	01 c2                	add    %eax,%edx
 6a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a3:	8b 00                	mov    (%eax),%eax
 6a5:	39 c2                	cmp    %eax,%edx
 6a7:	75 24                	jne    6cd <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ac:	8b 50 04             	mov    0x4(%eax),%edx
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 00                	mov    (%eax),%eax
 6b4:	8b 40 04             	mov    0x4(%eax),%eax
 6b7:	01 c2                	add    %eax,%edx
 6b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bc:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	8b 00                	mov    (%eax),%eax
 6c4:	8b 10                	mov    (%eax),%edx
 6c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c9:	89 10                	mov    %edx,(%eax)
 6cb:	eb 0a                	jmp    6d7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 10                	mov    (%eax),%edx
 6d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 40 04             	mov    0x4(%eax),%eax
 6dd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	01 d0                	add    %edx,%eax
 6e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ec:	75 20                	jne    70e <free+0xcf>
    p->s.size += bp->s.size;
 6ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f1:	8b 50 04             	mov    0x4(%eax),%edx
 6f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f7:	8b 40 04             	mov    0x4(%eax),%eax
 6fa:	01 c2                	add    %eax,%edx
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 702:	8b 45 f8             	mov    -0x8(%ebp),%eax
 705:	8b 10                	mov    (%eax),%edx
 707:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70a:	89 10                	mov    %edx,(%eax)
 70c:	eb 08                	jmp    716 <free+0xd7>
  } else
    p->s.ptr = bp;
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	8b 55 f8             	mov    -0x8(%ebp),%edx
 714:	89 10                	mov    %edx,(%eax)
  freep = p;
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	a3 40 0c 00 00       	mov    %eax,0xc40
}
 71e:	c9                   	leave  
 71f:	c3                   	ret    

00000720 <morecore>:

static Header*
morecore(uint nu)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 726:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 72d:	77 07                	ja     736 <morecore+0x16>
    nu = 4096;
 72f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 736:	8b 45 08             	mov    0x8(%ebp),%eax
 739:	c1 e0 03             	shl    $0x3,%eax
 73c:	89 04 24             	mov    %eax,(%esp)
 73f:	e8 18 fc ff ff       	call   35c <sbrk>
 744:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 747:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 74b:	75 07                	jne    754 <morecore+0x34>
    return 0;
 74d:	b8 00 00 00 00       	mov    $0x0,%eax
 752:	eb 22                	jmp    776 <morecore+0x56>
  hp = (Header*)p;
 754:	8b 45 f4             	mov    -0xc(%ebp),%eax
 757:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 75a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75d:	8b 55 08             	mov    0x8(%ebp),%edx
 760:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 763:	8b 45 f0             	mov    -0x10(%ebp),%eax
 766:	83 c0 08             	add    $0x8,%eax
 769:	89 04 24             	mov    %eax,(%esp)
 76c:	e8 ce fe ff ff       	call   63f <free>
  return freep;
 771:	a1 40 0c 00 00       	mov    0xc40,%eax
}
 776:	c9                   	leave  
 777:	c3                   	ret    

00000778 <malloc>:

void*
malloc(uint nbytes)
{
 778:	55                   	push   %ebp
 779:	89 e5                	mov    %esp,%ebp
 77b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 77e:	8b 45 08             	mov    0x8(%ebp),%eax
 781:	83 c0 07             	add    $0x7,%eax
 784:	c1 e8 03             	shr    $0x3,%eax
 787:	83 c0 01             	add    $0x1,%eax
 78a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 78d:	a1 40 0c 00 00       	mov    0xc40,%eax
 792:	89 45 f0             	mov    %eax,-0x10(%ebp)
 795:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 799:	75 23                	jne    7be <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 79b:	c7 45 f0 38 0c 00 00 	movl   $0xc38,-0x10(%ebp)
 7a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a5:	a3 40 0c 00 00       	mov    %eax,0xc40
 7aa:	a1 40 0c 00 00       	mov    0xc40,%eax
 7af:	a3 38 0c 00 00       	mov    %eax,0xc38
    base.s.size = 0;
 7b4:	c7 05 3c 0c 00 00 00 	movl   $0x0,0xc3c
 7bb:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c1:	8b 00                	mov    (%eax),%eax
 7c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c9:	8b 40 04             	mov    0x4(%eax),%eax
 7cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7cf:	72 4d                	jb     81e <malloc+0xa6>
      if(p->s.size == nunits)
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	8b 40 04             	mov    0x4(%eax),%eax
 7d7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7da:	75 0c                	jne    7e8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	8b 10                	mov    (%eax),%edx
 7e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e4:	89 10                	mov    %edx,(%eax)
 7e6:	eb 26                	jmp    80e <malloc+0x96>
      else {
        p->s.size -= nunits;
 7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7eb:	8b 40 04             	mov    0x4(%eax),%eax
 7ee:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7f1:	89 c2                	mov    %eax,%edx
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	8b 40 04             	mov    0x4(%eax),%eax
 7ff:	c1 e0 03             	shl    $0x3,%eax
 802:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 805:	8b 45 f4             	mov    -0xc(%ebp),%eax
 808:	8b 55 ec             	mov    -0x14(%ebp),%edx
 80b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 80e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 811:	a3 40 0c 00 00       	mov    %eax,0xc40
      return (void*)(p + 1);
 816:	8b 45 f4             	mov    -0xc(%ebp),%eax
 819:	83 c0 08             	add    $0x8,%eax
 81c:	eb 38                	jmp    856 <malloc+0xde>
    }
    if(p == freep)
 81e:	a1 40 0c 00 00       	mov    0xc40,%eax
 823:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 826:	75 1b                	jne    843 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 828:	8b 45 ec             	mov    -0x14(%ebp),%eax
 82b:	89 04 24             	mov    %eax,(%esp)
 82e:	e8 ed fe ff ff       	call   720 <morecore>
 833:	89 45 f4             	mov    %eax,-0xc(%ebp)
 836:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 83a:	75 07                	jne    843 <malloc+0xcb>
        return 0;
 83c:	b8 00 00 00 00       	mov    $0x0,%eax
 841:	eb 13                	jmp    856 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	89 45 f0             	mov    %eax,-0x10(%ebp)
 849:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84c:	8b 00                	mov    (%eax),%eax
 84e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 851:	e9 70 ff ff ff       	jmp    7c6 <malloc+0x4e>
}
 856:	c9                   	leave  
 857:	c3                   	ret    

00000858 <thread_create>:
#include"x86.h"
#include"param.h"
#include"proc.h"

int thread_create(thread_t *thread, void*(*start_routine)(void*),void *arg)
{
 858:	55                   	push   %ebp
 859:	89 e5                	mov    %esp,%ebp
 85b:	83 ec 28             	sub    $0x28,%esp
    void *stack = malloc(PGSIZE);
 85e:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 865:	e8 0e ff ff ff       	call   778 <malloc>
 86a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if((uint)stack <=0)
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	85 c0                	test   %eax,%eax
 872:	75 1b                	jne    88f <thread_create+0x37>
    {
        printf(1,"malloc thread stack failed\n");
 874:	c7 44 24 04 60 09 00 	movl   $0x960,0x4(%esp)
 87b:	00 
 87c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 883:	e8 04 fc ff ff       	call   48c <printf>
        return -1;
 888:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 88d:	eb 67                	jmp    8f6 <thread_create+0x9e>
    }
    
    if((uint)stack%PGSIZE)
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	25 ff 0f 00 00       	and    $0xfff,%eax
 897:	85 c0                	test   %eax,%eax
 899:	74 14                	je     8af <thread_create+0x57>
        stack += PGSIZE-((uint)stack%PGSIZE);
 89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89e:	25 ff 0f 00 00       	and    $0xfff,%eax
 8a3:	89 c2                	mov    %eax,%edx
 8a5:	b8 00 10 00 00       	mov    $0x1000,%eax
 8aa:	29 d0                	sub    %edx,%eax
 8ac:	01 45 f4             	add    %eax,-0xc(%ebp)
    printf(1,"1\n");
 8af:	c7 44 24 04 7c 09 00 	movl   $0x97c,0x4(%esp)
 8b6:	00 
 8b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8be:	e8 c9 fb ff ff       	call   48c <printf>
    if((*thread = clone(start_routine,arg,stack))<0)
 8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c6:	89 44 24 08          	mov    %eax,0x8(%esp)
 8ca:	8b 45 10             	mov    0x10(%ebp),%eax
 8cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 8d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 8d4:	89 04 24             	mov    %eax,(%esp)
 8d7:	e8 b8 fa ff ff       	call   394 <clone>
 8dc:	8b 55 08             	mov    0x8(%ebp),%edx
 8df:	89 02                	mov    %eax,(%edx)
 8e1:	8b 45 08             	mov    0x8(%ebp),%eax
 8e4:	8b 00                	mov    (%eax),%eax
 8e6:	85 c0                	test   %eax,%eax
 8e8:	79 07                	jns    8f1 <thread_create+0x99>
        return -1;
 8ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8ef:	eb 05                	jmp    8f6 <thread_create+0x9e>
    return 0;
 8f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8f6:	c9                   	leave  
 8f7:	c3                   	ret    

000008f8 <thread_join>:

int thread_join(thread_t thread, void **retval)
{
 8f8:	55                   	push   %ebp
 8f9:	89 e5                	mov    %esp,%ebp
 8fb:	83 ec 28             	sub    $0x28,%esp
    void *stack;
    if(join((uint)thread, &stack, retval)<0)
 8fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 901:	89 44 24 08          	mov    %eax,0x8(%esp)
 905:	8d 45 f4             	lea    -0xc(%ebp),%eax
 908:	89 44 24 04          	mov    %eax,0x4(%esp)
 90c:	8b 45 08             	mov    0x8(%ebp),%eax
 90f:	89 04 24             	mov    %eax,(%esp)
 912:	e8 85 fa ff ff       	call   39c <join>
 917:	85 c0                	test   %eax,%eax
 919:	79 07                	jns    922 <thread_join+0x2a>
        return -1;
 91b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 920:	eb 10                	jmp    932 <thread_join+0x3a>

    free(stack);
 922:	8b 45 f4             	mov    -0xc(%ebp),%eax
 925:	89 04 24             	mov    %eax,(%esp)
 928:	e8 12 fd ff ff       	call   63f <free>
    return 0;
 92d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 932:	c9                   	leave  
 933:	c3                   	ret    

00000934 <thread_exit>:

void thread_exit(void *retval)
{
 934:	55                   	push   %ebp
 935:	89 e5                	mov    %esp,%ebp
 937:	83 ec 08             	sub    $0x8,%esp
    proc->retval = retval;
 93a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 940:	8b 55 08             	mov    0x8(%ebp),%edx
 943:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
    thexit();
 949:	e8 56 fa ff ff       	call   3a4 <thexit>
}
 94e:	c9                   	leave  
 94f:	c3                   	ret    
