
_my_userapp:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
    char *buf ="Hello xv6!";
   9:	c7 44 24 1c 26 09 00 	movl   $0x926,0x1c(%esp)
  10:	00 
    int ret_val;
    ret_val = my_syscall(buf);
  11:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  15:	89 04 24             	mov    %eax,(%esp)
  18:	e8 2d 03 00 00       	call   34a <my_syscall>
  1d:	89 44 24 18          	mov    %eax,0x18(%esp)
    printf(1, "Return value : 0x%x\n", ret_val);
  21:	8b 44 24 18          	mov    0x18(%esp),%eax
  25:	89 44 24 08          	mov    %eax,0x8(%esp)
  29:	c7 44 24 04 31 09 00 	movl   $0x931,0x4(%esp)
  30:	00 
  31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  38:	e8 25 04 00 00       	call   462 <printf>
    exit();
  3d:	e8 68 02 00 00       	call   2aa <exit>

00000042 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  42:	55                   	push   %ebp
  43:	89 e5                	mov    %esp,%ebp
  45:	57                   	push   %edi
  46:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  4a:	8b 55 10             	mov    0x10(%ebp),%edx
  4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  50:	89 cb                	mov    %ecx,%ebx
  52:	89 df                	mov    %ebx,%edi
  54:	89 d1                	mov    %edx,%ecx
  56:	fc                   	cld    
  57:	f3 aa                	rep stos %al,%es:(%edi)
  59:	89 ca                	mov    %ecx,%edx
  5b:	89 fb                	mov    %edi,%ebx
  5d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  60:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  63:	5b                   	pop    %ebx
  64:	5f                   	pop    %edi
  65:	5d                   	pop    %ebp
  66:	c3                   	ret    

00000067 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  6d:	8b 45 08             	mov    0x8(%ebp),%eax
  70:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  73:	90                   	nop
  74:	8b 45 08             	mov    0x8(%ebp),%eax
  77:	8d 50 01             	lea    0x1(%eax),%edx
  7a:	89 55 08             	mov    %edx,0x8(%ebp)
  7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  80:	8d 4a 01             	lea    0x1(%edx),%ecx
  83:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  86:	0f b6 12             	movzbl (%edx),%edx
  89:	88 10                	mov    %dl,(%eax)
  8b:	0f b6 00             	movzbl (%eax),%eax
  8e:	84 c0                	test   %al,%al
  90:	75 e2                	jne    74 <strcpy+0xd>
    ;
  return os;
  92:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  95:	c9                   	leave  
  96:	c3                   	ret    

00000097 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  97:	55                   	push   %ebp
  98:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  9a:	eb 08                	jmp    a4 <strcmp+0xd>
    p++, q++;
  9c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  a0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	0f b6 00             	movzbl (%eax),%eax
  aa:	84 c0                	test   %al,%al
  ac:	74 10                	je     be <strcmp+0x27>
  ae:	8b 45 08             	mov    0x8(%ebp),%eax
  b1:	0f b6 10             	movzbl (%eax),%edx
  b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  b7:	0f b6 00             	movzbl (%eax),%eax
  ba:	38 c2                	cmp    %al,%dl
  bc:	74 de                	je     9c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  be:	8b 45 08             	mov    0x8(%ebp),%eax
  c1:	0f b6 00             	movzbl (%eax),%eax
  c4:	0f b6 d0             	movzbl %al,%edx
  c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ca:	0f b6 00             	movzbl (%eax),%eax
  cd:	0f b6 c0             	movzbl %al,%eax
  d0:	29 c2                	sub    %eax,%edx
  d2:	89 d0                	mov    %edx,%eax
}
  d4:	5d                   	pop    %ebp
  d5:	c3                   	ret    

000000d6 <strlen>:

uint
strlen(char *s)
{
  d6:	55                   	push   %ebp
  d7:	89 e5                	mov    %esp,%ebp
  d9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  e3:	eb 04                	jmp    e9 <strlen+0x13>
  e5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
  ef:	01 d0                	add    %edx,%eax
  f1:	0f b6 00             	movzbl (%eax),%eax
  f4:	84 c0                	test   %al,%al
  f6:	75 ed                	jne    e5 <strlen+0xf>
    ;
  return n;
  f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  fb:	c9                   	leave  
  fc:	c3                   	ret    

000000fd <memset>:

void*
memset(void *dst, int c, uint n)
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 103:	8b 45 10             	mov    0x10(%ebp),%eax
 106:	89 44 24 08          	mov    %eax,0x8(%esp)
 10a:	8b 45 0c             	mov    0xc(%ebp),%eax
 10d:	89 44 24 04          	mov    %eax,0x4(%esp)
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	89 04 24             	mov    %eax,(%esp)
 117:	e8 26 ff ff ff       	call   42 <stosb>
  return dst;
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 11f:	c9                   	leave  
 120:	c3                   	ret    

00000121 <strchr>:

char*
strchr(const char *s, char c)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
 124:	83 ec 04             	sub    $0x4,%esp
 127:	8b 45 0c             	mov    0xc(%ebp),%eax
 12a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 12d:	eb 14                	jmp    143 <strchr+0x22>
    if(*s == c)
 12f:	8b 45 08             	mov    0x8(%ebp),%eax
 132:	0f b6 00             	movzbl (%eax),%eax
 135:	3a 45 fc             	cmp    -0x4(%ebp),%al
 138:	75 05                	jne    13f <strchr+0x1e>
      return (char*)s;
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	eb 13                	jmp    152 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 13f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 00             	movzbl (%eax),%eax
 149:	84 c0                	test   %al,%al
 14b:	75 e2                	jne    12f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 14d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 152:	c9                   	leave  
 153:	c3                   	ret    

00000154 <gets>:

char*
gets(char *buf, int max)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 161:	eb 4c                	jmp    1af <gets+0x5b>
    cc = read(0, &c, 1);
 163:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 16a:	00 
 16b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 16e:	89 44 24 04          	mov    %eax,0x4(%esp)
 172:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 179:	e8 44 01 00 00       	call   2c2 <read>
 17e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 181:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 185:	7f 02                	jg     189 <gets+0x35>
      break;
 187:	eb 31                	jmp    1ba <gets+0x66>
    buf[i++] = c;
 189:	8b 45 f4             	mov    -0xc(%ebp),%eax
 18c:	8d 50 01             	lea    0x1(%eax),%edx
 18f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 192:	89 c2                	mov    %eax,%edx
 194:	8b 45 08             	mov    0x8(%ebp),%eax
 197:	01 c2                	add    %eax,%edx
 199:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 19d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 19f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1a3:	3c 0a                	cmp    $0xa,%al
 1a5:	74 13                	je     1ba <gets+0x66>
 1a7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ab:	3c 0d                	cmp    $0xd,%al
 1ad:	74 0b                	je     1ba <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b2:	83 c0 01             	add    $0x1,%eax
 1b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1b8:	7c a9                	jl     163 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1bd:	8b 45 08             	mov    0x8(%ebp),%eax
 1c0:	01 d0                	add    %edx,%eax
 1c2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c8:	c9                   	leave  
 1c9:	c3                   	ret    

000001ca <stat>:

int
stat(char *n, struct stat *st)
{
 1ca:	55                   	push   %ebp
 1cb:	89 e5                	mov    %esp,%ebp
 1cd:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1d7:	00 
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
 1db:	89 04 24             	mov    %eax,(%esp)
 1de:	e8 07 01 00 00       	call   2ea <open>
 1e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ea:	79 07                	jns    1f3 <stat+0x29>
    return -1;
 1ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1f1:	eb 23                	jmp    216 <stat+0x4c>
  r = fstat(fd, st);
 1f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1fd:	89 04 24             	mov    %eax,(%esp)
 200:	e8 fd 00 00 00       	call   302 <fstat>
 205:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 208:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20b:	89 04 24             	mov    %eax,(%esp)
 20e:	e8 bf 00 00 00       	call   2d2 <close>
  return r;
 213:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 216:	c9                   	leave  
 217:	c3                   	ret    

00000218 <atoi>:

int
atoi(const char *s)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 21e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 225:	eb 25                	jmp    24c <atoi+0x34>
    n = n*10 + *s++ - '0';
 227:	8b 55 fc             	mov    -0x4(%ebp),%edx
 22a:	89 d0                	mov    %edx,%eax
 22c:	c1 e0 02             	shl    $0x2,%eax
 22f:	01 d0                	add    %edx,%eax
 231:	01 c0                	add    %eax,%eax
 233:	89 c1                	mov    %eax,%ecx
 235:	8b 45 08             	mov    0x8(%ebp),%eax
 238:	8d 50 01             	lea    0x1(%eax),%edx
 23b:	89 55 08             	mov    %edx,0x8(%ebp)
 23e:	0f b6 00             	movzbl (%eax),%eax
 241:	0f be c0             	movsbl %al,%eax
 244:	01 c8                	add    %ecx,%eax
 246:	83 e8 30             	sub    $0x30,%eax
 249:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	0f b6 00             	movzbl (%eax),%eax
 252:	3c 2f                	cmp    $0x2f,%al
 254:	7e 0a                	jle    260 <atoi+0x48>
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	0f b6 00             	movzbl (%eax),%eax
 25c:	3c 39                	cmp    $0x39,%al
 25e:	7e c7                	jle    227 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 260:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 263:	c9                   	leave  
 264:	c3                   	ret    

00000265 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 265:	55                   	push   %ebp
 266:	89 e5                	mov    %esp,%ebp
 268:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 271:	8b 45 0c             	mov    0xc(%ebp),%eax
 274:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 277:	eb 17                	jmp    290 <memmove+0x2b>
    *dst++ = *src++;
 279:	8b 45 fc             	mov    -0x4(%ebp),%eax
 27c:	8d 50 01             	lea    0x1(%eax),%edx
 27f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 282:	8b 55 f8             	mov    -0x8(%ebp),%edx
 285:	8d 4a 01             	lea    0x1(%edx),%ecx
 288:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 28b:	0f b6 12             	movzbl (%edx),%edx
 28e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 290:	8b 45 10             	mov    0x10(%ebp),%eax
 293:	8d 50 ff             	lea    -0x1(%eax),%edx
 296:	89 55 10             	mov    %edx,0x10(%ebp)
 299:	85 c0                	test   %eax,%eax
 29b:	7f dc                	jg     279 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a0:	c9                   	leave  
 2a1:	c3                   	ret    

000002a2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2a2:	b8 01 00 00 00       	mov    $0x1,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <exit>:
SYSCALL(exit)
 2aa:	b8 02 00 00 00       	mov    $0x2,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <wait>:
SYSCALL(wait)
 2b2:	b8 03 00 00 00       	mov    $0x3,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <pipe>:
SYSCALL(pipe)
 2ba:	b8 04 00 00 00       	mov    $0x4,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <read>:
SYSCALL(read)
 2c2:	b8 05 00 00 00       	mov    $0x5,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <write>:
SYSCALL(write)
 2ca:	b8 10 00 00 00       	mov    $0x10,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <close>:
SYSCALL(close)
 2d2:	b8 15 00 00 00       	mov    $0x15,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <kill>:
SYSCALL(kill)
 2da:	b8 06 00 00 00       	mov    $0x6,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <exec>:
SYSCALL(exec)
 2e2:	b8 07 00 00 00       	mov    $0x7,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <open>:
SYSCALL(open)
 2ea:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <mknod>:
SYSCALL(mknod)
 2f2:	b8 11 00 00 00       	mov    $0x11,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <unlink>:
SYSCALL(unlink)
 2fa:	b8 12 00 00 00       	mov    $0x12,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <fstat>:
SYSCALL(fstat)
 302:	b8 08 00 00 00       	mov    $0x8,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <link>:
SYSCALL(link)
 30a:	b8 13 00 00 00       	mov    $0x13,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <mkdir>:
SYSCALL(mkdir)
 312:	b8 14 00 00 00       	mov    $0x14,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <chdir>:
SYSCALL(chdir)
 31a:	b8 09 00 00 00       	mov    $0x9,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <dup>:
SYSCALL(dup)
 322:	b8 0a 00 00 00       	mov    $0xa,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <getpid>:
SYSCALL(getpid)
 32a:	b8 0b 00 00 00       	mov    $0xb,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <sbrk>:
SYSCALL(sbrk)
 332:	b8 0c 00 00 00       	mov    $0xc,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <sleep>:
SYSCALL(sleep)
 33a:	b8 0d 00 00 00       	mov    $0xd,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <uptime>:
SYSCALL(uptime)
 342:	b8 0e 00 00 00       	mov    $0xe,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <my_syscall>:
SYSCALL(my_syscall)
 34a:	b8 16 00 00 00       	mov    $0x16,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <getppid>:
SYSCALL(getppid)
 352:	b8 17 00 00 00       	mov    $0x17,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <yield>:
SYSCALL(yield)
 35a:	b8 18 00 00 00       	mov    $0x18,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <getlev>:
SYSCALL(getlev)
 362:	b8 19 00 00 00       	mov    $0x19,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <clone>:
SYSCALL(clone)
 36a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <join>:
SYSCALL(join)
 372:	b8 1b 00 00 00       	mov    $0x1b,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <thexit>:
SYSCALL(thexit)
 37a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 382:	55                   	push   %ebp
 383:	89 e5                	mov    %esp,%ebp
 385:	83 ec 18             	sub    $0x18,%esp
 388:	8b 45 0c             	mov    0xc(%ebp),%eax
 38b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 38e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 395:	00 
 396:	8d 45 f4             	lea    -0xc(%ebp),%eax
 399:	89 44 24 04          	mov    %eax,0x4(%esp)
 39d:	8b 45 08             	mov    0x8(%ebp),%eax
 3a0:	89 04 24             	mov    %eax,(%esp)
 3a3:	e8 22 ff ff ff       	call   2ca <write>
}
 3a8:	c9                   	leave  
 3a9:	c3                   	ret    

000003aa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3aa:	55                   	push   %ebp
 3ab:	89 e5                	mov    %esp,%ebp
 3ad:	56                   	push   %esi
 3ae:	53                   	push   %ebx
 3af:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3b9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3bd:	74 17                	je     3d6 <printint+0x2c>
 3bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c3:	79 11                	jns    3d6 <printint+0x2c>
    neg = 1;
 3c5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cf:	f7 d8                	neg    %eax
 3d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d4:	eb 06                	jmp    3dc <printint+0x32>
  } else {
    x = xx;
 3d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3e6:	8d 41 01             	lea    0x1(%ecx),%eax
 3e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f2:	ba 00 00 00 00       	mov    $0x0,%edx
 3f7:	f7 f3                	div    %ebx
 3f9:	89 d0                	mov    %edx,%eax
 3fb:	0f b6 80 10 0c 00 00 	movzbl 0xc10(%eax),%eax
 402:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 406:	8b 75 10             	mov    0x10(%ebp),%esi
 409:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40c:	ba 00 00 00 00       	mov    $0x0,%edx
 411:	f7 f6                	div    %esi
 413:	89 45 ec             	mov    %eax,-0x14(%ebp)
 416:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 41a:	75 c7                	jne    3e3 <printint+0x39>
  if(neg)
 41c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 420:	74 10                	je     432 <printint+0x88>
    buf[i++] = '-';
 422:	8b 45 f4             	mov    -0xc(%ebp),%eax
 425:	8d 50 01             	lea    0x1(%eax),%edx
 428:	89 55 f4             	mov    %edx,-0xc(%ebp)
 42b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 430:	eb 1f                	jmp    451 <printint+0xa7>
 432:	eb 1d                	jmp    451 <printint+0xa7>
    putc(fd, buf[i]);
 434:	8d 55 dc             	lea    -0x24(%ebp),%edx
 437:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43a:	01 d0                	add    %edx,%eax
 43c:	0f b6 00             	movzbl (%eax),%eax
 43f:	0f be c0             	movsbl %al,%eax
 442:	89 44 24 04          	mov    %eax,0x4(%esp)
 446:	8b 45 08             	mov    0x8(%ebp),%eax
 449:	89 04 24             	mov    %eax,(%esp)
 44c:	e8 31 ff ff ff       	call   382 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 451:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 455:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 459:	79 d9                	jns    434 <printint+0x8a>
    putc(fd, buf[i]);
}
 45b:	83 c4 30             	add    $0x30,%esp
 45e:	5b                   	pop    %ebx
 45f:	5e                   	pop    %esi
 460:	5d                   	pop    %ebp
 461:	c3                   	ret    

00000462 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 462:	55                   	push   %ebp
 463:	89 e5                	mov    %esp,%ebp
 465:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 468:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 46f:	8d 45 0c             	lea    0xc(%ebp),%eax
 472:	83 c0 04             	add    $0x4,%eax
 475:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 478:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 47f:	e9 7c 01 00 00       	jmp    600 <printf+0x19e>
    c = fmt[i] & 0xff;
 484:	8b 55 0c             	mov    0xc(%ebp),%edx
 487:	8b 45 f0             	mov    -0x10(%ebp),%eax
 48a:	01 d0                	add    %edx,%eax
 48c:	0f b6 00             	movzbl (%eax),%eax
 48f:	0f be c0             	movsbl %al,%eax
 492:	25 ff 00 00 00       	and    $0xff,%eax
 497:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 49a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49e:	75 2c                	jne    4cc <printf+0x6a>
      if(c == '%'){
 4a0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4a4:	75 0c                	jne    4b2 <printf+0x50>
        state = '%';
 4a6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ad:	e9 4a 01 00 00       	jmp    5fc <printf+0x19a>
      } else {
        putc(fd, c);
 4b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b5:	0f be c0             	movsbl %al,%eax
 4b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bc:	8b 45 08             	mov    0x8(%ebp),%eax
 4bf:	89 04 24             	mov    %eax,(%esp)
 4c2:	e8 bb fe ff ff       	call   382 <putc>
 4c7:	e9 30 01 00 00       	jmp    5fc <printf+0x19a>
      }
    } else if(state == '%'){
 4cc:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4d0:	0f 85 26 01 00 00    	jne    5fc <printf+0x19a>
      if(c == 'd'){
 4d6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4da:	75 2d                	jne    509 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4df:	8b 00                	mov    (%eax),%eax
 4e1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4e8:	00 
 4e9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4f0:	00 
 4f1:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
 4f8:	89 04 24             	mov    %eax,(%esp)
 4fb:	e8 aa fe ff ff       	call   3aa <printint>
        ap++;
 500:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 504:	e9 ec 00 00 00       	jmp    5f5 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 509:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 50d:	74 06                	je     515 <printf+0xb3>
 50f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 513:	75 2d                	jne    542 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 515:	8b 45 e8             	mov    -0x18(%ebp),%eax
 518:	8b 00                	mov    (%eax),%eax
 51a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 521:	00 
 522:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 529:	00 
 52a:	89 44 24 04          	mov    %eax,0x4(%esp)
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
 531:	89 04 24             	mov    %eax,(%esp)
 534:	e8 71 fe ff ff       	call   3aa <printint>
        ap++;
 539:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53d:	e9 b3 00 00 00       	jmp    5f5 <printf+0x193>
      } else if(c == 's'){
 542:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 546:	75 45                	jne    58d <printf+0x12b>
        s = (char*)*ap;
 548:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54b:	8b 00                	mov    (%eax),%eax
 54d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 550:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 554:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 558:	75 09                	jne    563 <printf+0x101>
          s = "(null)";
 55a:	c7 45 f4 46 09 00 00 	movl   $0x946,-0xc(%ebp)
        while(*s != 0){
 561:	eb 1e                	jmp    581 <printf+0x11f>
 563:	eb 1c                	jmp    581 <printf+0x11f>
          putc(fd, *s);
 565:	8b 45 f4             	mov    -0xc(%ebp),%eax
 568:	0f b6 00             	movzbl (%eax),%eax
 56b:	0f be c0             	movsbl %al,%eax
 56e:	89 44 24 04          	mov    %eax,0x4(%esp)
 572:	8b 45 08             	mov    0x8(%ebp),%eax
 575:	89 04 24             	mov    %eax,(%esp)
 578:	e8 05 fe ff ff       	call   382 <putc>
          s++;
 57d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 581:	8b 45 f4             	mov    -0xc(%ebp),%eax
 584:	0f b6 00             	movzbl (%eax),%eax
 587:	84 c0                	test   %al,%al
 589:	75 da                	jne    565 <printf+0x103>
 58b:	eb 68                	jmp    5f5 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 58d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 591:	75 1d                	jne    5b0 <printf+0x14e>
        putc(fd, *ap);
 593:	8b 45 e8             	mov    -0x18(%ebp),%eax
 596:	8b 00                	mov    (%eax),%eax
 598:	0f be c0             	movsbl %al,%eax
 59b:	89 44 24 04          	mov    %eax,0x4(%esp)
 59f:	8b 45 08             	mov    0x8(%ebp),%eax
 5a2:	89 04 24             	mov    %eax,(%esp)
 5a5:	e8 d8 fd ff ff       	call   382 <putc>
        ap++;
 5aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ae:	eb 45                	jmp    5f5 <printf+0x193>
      } else if(c == '%'){
 5b0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b4:	75 17                	jne    5cd <printf+0x16b>
        putc(fd, c);
 5b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b9:	0f be c0             	movsbl %al,%eax
 5bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c0:	8b 45 08             	mov    0x8(%ebp),%eax
 5c3:	89 04 24             	mov    %eax,(%esp)
 5c6:	e8 b7 fd ff ff       	call   382 <putc>
 5cb:	eb 28                	jmp    5f5 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5cd:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5d4:	00 
 5d5:	8b 45 08             	mov    0x8(%ebp),%eax
 5d8:	89 04 24             	mov    %eax,(%esp)
 5db:	e8 a2 fd ff ff       	call   382 <putc>
        putc(fd, c);
 5e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e3:	0f be c0             	movsbl %al,%eax
 5e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ea:	8b 45 08             	mov    0x8(%ebp),%eax
 5ed:	89 04 24             	mov    %eax,(%esp)
 5f0:	e8 8d fd ff ff       	call   382 <putc>
      }
      state = 0;
 5f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5fc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 600:	8b 55 0c             	mov    0xc(%ebp),%edx
 603:	8b 45 f0             	mov    -0x10(%ebp),%eax
 606:	01 d0                	add    %edx,%eax
 608:	0f b6 00             	movzbl (%eax),%eax
 60b:	84 c0                	test   %al,%al
 60d:	0f 85 71 fe ff ff    	jne    484 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 613:	c9                   	leave  
 614:	c3                   	ret    

00000615 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 615:	55                   	push   %ebp
 616:	89 e5                	mov    %esp,%ebp
 618:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 61b:	8b 45 08             	mov    0x8(%ebp),%eax
 61e:	83 e8 08             	sub    $0x8,%eax
 621:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 624:	a1 2c 0c 00 00       	mov    0xc2c,%eax
 629:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62c:	eb 24                	jmp    652 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 631:	8b 00                	mov    (%eax),%eax
 633:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 636:	77 12                	ja     64a <free+0x35>
 638:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63e:	77 24                	ja     664 <free+0x4f>
 640:	8b 45 fc             	mov    -0x4(%ebp),%eax
 643:	8b 00                	mov    (%eax),%eax
 645:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 648:	77 1a                	ja     664 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64d:	8b 00                	mov    (%eax),%eax
 64f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 652:	8b 45 f8             	mov    -0x8(%ebp),%eax
 655:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 658:	76 d4                	jbe    62e <free+0x19>
 65a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65d:	8b 00                	mov    (%eax),%eax
 65f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 662:	76 ca                	jbe    62e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 664:	8b 45 f8             	mov    -0x8(%ebp),%eax
 667:	8b 40 04             	mov    0x4(%eax),%eax
 66a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 671:	8b 45 f8             	mov    -0x8(%ebp),%eax
 674:	01 c2                	add    %eax,%edx
 676:	8b 45 fc             	mov    -0x4(%ebp),%eax
 679:	8b 00                	mov    (%eax),%eax
 67b:	39 c2                	cmp    %eax,%edx
 67d:	75 24                	jne    6a3 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 67f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 682:	8b 50 04             	mov    0x4(%eax),%edx
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	8b 40 04             	mov    0x4(%eax),%eax
 68d:	01 c2                	add    %eax,%edx
 68f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 692:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	8b 00                	mov    (%eax),%eax
 69a:	8b 10                	mov    (%eax),%edx
 69c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69f:	89 10                	mov    %edx,(%eax)
 6a1:	eb 0a                	jmp    6ad <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a6:	8b 10                	mov    (%eax),%edx
 6a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ab:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 40 04             	mov    0x4(%eax),%eax
 6b3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	01 d0                	add    %edx,%eax
 6bf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c2:	75 20                	jne    6e4 <free+0xcf>
    p->s.size += bp->s.size;
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	8b 50 04             	mov    0x4(%eax),%edx
 6ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cd:	8b 40 04             	mov    0x4(%eax),%eax
 6d0:	01 c2                	add    %eax,%edx
 6d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6db:	8b 10                	mov    (%eax),%edx
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	89 10                	mov    %edx,(%eax)
 6e2:	eb 08                	jmp    6ec <free+0xd7>
  } else
    p->s.ptr = bp;
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ea:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	a3 2c 0c 00 00       	mov    %eax,0xc2c
}
 6f4:	c9                   	leave  
 6f5:	c3                   	ret    

000006f6 <morecore>:

static Header*
morecore(uint nu)
{
 6f6:	55                   	push   %ebp
 6f7:	89 e5                	mov    %esp,%ebp
 6f9:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6fc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 703:	77 07                	ja     70c <morecore+0x16>
    nu = 4096;
 705:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 70c:	8b 45 08             	mov    0x8(%ebp),%eax
 70f:	c1 e0 03             	shl    $0x3,%eax
 712:	89 04 24             	mov    %eax,(%esp)
 715:	e8 18 fc ff ff       	call   332 <sbrk>
 71a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 71d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 721:	75 07                	jne    72a <morecore+0x34>
    return 0;
 723:	b8 00 00 00 00       	mov    $0x0,%eax
 728:	eb 22                	jmp    74c <morecore+0x56>
  hp = (Header*)p;
 72a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 730:	8b 45 f0             	mov    -0x10(%ebp),%eax
 733:	8b 55 08             	mov    0x8(%ebp),%edx
 736:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 739:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73c:	83 c0 08             	add    $0x8,%eax
 73f:	89 04 24             	mov    %eax,(%esp)
 742:	e8 ce fe ff ff       	call   615 <free>
  return freep;
 747:	a1 2c 0c 00 00       	mov    0xc2c,%eax
}
 74c:	c9                   	leave  
 74d:	c3                   	ret    

0000074e <malloc>:

void*
malloc(uint nbytes)
{
 74e:	55                   	push   %ebp
 74f:	89 e5                	mov    %esp,%ebp
 751:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 754:	8b 45 08             	mov    0x8(%ebp),%eax
 757:	83 c0 07             	add    $0x7,%eax
 75a:	c1 e8 03             	shr    $0x3,%eax
 75d:	83 c0 01             	add    $0x1,%eax
 760:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 763:	a1 2c 0c 00 00       	mov    0xc2c,%eax
 768:	89 45 f0             	mov    %eax,-0x10(%ebp)
 76b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 76f:	75 23                	jne    794 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 771:	c7 45 f0 24 0c 00 00 	movl   $0xc24,-0x10(%ebp)
 778:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77b:	a3 2c 0c 00 00       	mov    %eax,0xc2c
 780:	a1 2c 0c 00 00       	mov    0xc2c,%eax
 785:	a3 24 0c 00 00       	mov    %eax,0xc24
    base.s.size = 0;
 78a:	c7 05 28 0c 00 00 00 	movl   $0x0,0xc28
 791:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 794:	8b 45 f0             	mov    -0x10(%ebp),%eax
 797:	8b 00                	mov    (%eax),%eax
 799:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 79c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79f:	8b 40 04             	mov    0x4(%eax),%eax
 7a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a5:	72 4d                	jb     7f4 <malloc+0xa6>
      if(p->s.size == nunits)
 7a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7aa:	8b 40 04             	mov    0x4(%eax),%eax
 7ad:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b0:	75 0c                	jne    7be <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b5:	8b 10                	mov    (%eax),%edx
 7b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ba:	89 10                	mov    %edx,(%eax)
 7bc:	eb 26                	jmp    7e4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	8b 40 04             	mov    0x4(%eax),%eax
 7c4:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7c7:	89 c2                	mov    %eax,%edx
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	8b 40 04             	mov    0x4(%eax),%eax
 7d5:	c1 e0 03             	shl    $0x3,%eax
 7d8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7de:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7e1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e7:	a3 2c 0c 00 00       	mov    %eax,0xc2c
      return (void*)(p + 1);
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	83 c0 08             	add    $0x8,%eax
 7f2:	eb 38                	jmp    82c <malloc+0xde>
    }
    if(p == freep)
 7f4:	a1 2c 0c 00 00       	mov    0xc2c,%eax
 7f9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7fc:	75 1b                	jne    819 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
 801:	89 04 24             	mov    %eax,(%esp)
 804:	e8 ed fe ff ff       	call   6f6 <morecore>
 809:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 810:	75 07                	jne    819 <malloc+0xcb>
        return 0;
 812:	b8 00 00 00 00       	mov    $0x0,%eax
 817:	eb 13                	jmp    82c <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 819:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 81f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 822:	8b 00                	mov    (%eax),%eax
 824:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 827:	e9 70 ff ff ff       	jmp    79c <malloc+0x4e>
}
 82c:	c9                   	leave  
 82d:	c3                   	ret    

0000082e <thread_create>:
#include"x86.h"
#include"param.h"
#include"proc.h"

int thread_create(thread_t *thread, void*(*start_routine)(void*),void *arg)
{
 82e:	55                   	push   %ebp
 82f:	89 e5                	mov    %esp,%ebp
 831:	83 ec 28             	sub    $0x28,%esp
    void *stack = malloc(PGSIZE);
 834:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 83b:	e8 0e ff ff ff       	call   74e <malloc>
 840:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if((uint)stack <=0)
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	85 c0                	test   %eax,%eax
 848:	75 1b                	jne    865 <thread_create+0x37>
    {
        printf(1,"malloc thread stack failed\n");
 84a:	c7 44 24 04 4d 09 00 	movl   $0x94d,0x4(%esp)
 851:	00 
 852:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 859:	e8 04 fc ff ff       	call   462 <printf>
        return -1;
 85e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 863:	eb 67                	jmp    8cc <thread_create+0x9e>
    }
    
    if((uint)stack%PGSIZE)
 865:	8b 45 f4             	mov    -0xc(%ebp),%eax
 868:	25 ff 0f 00 00       	and    $0xfff,%eax
 86d:	85 c0                	test   %eax,%eax
 86f:	74 14                	je     885 <thread_create+0x57>
        stack += PGSIZE-((uint)stack%PGSIZE);
 871:	8b 45 f4             	mov    -0xc(%ebp),%eax
 874:	25 ff 0f 00 00       	and    $0xfff,%eax
 879:	89 c2                	mov    %eax,%edx
 87b:	b8 00 10 00 00       	mov    $0x1000,%eax
 880:	29 d0                	sub    %edx,%eax
 882:	01 45 f4             	add    %eax,-0xc(%ebp)
    printf(1,"1\n");
 885:	c7 44 24 04 69 09 00 	movl   $0x969,0x4(%esp)
 88c:	00 
 88d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 894:	e8 c9 fb ff ff       	call   462 <printf>
    if((*thread = clone(start_routine,arg,stack))<0)
 899:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89c:	89 44 24 08          	mov    %eax,0x8(%esp)
 8a0:	8b 45 10             	mov    0x10(%ebp),%eax
 8a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 8a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 8aa:	89 04 24             	mov    %eax,(%esp)
 8ad:	e8 b8 fa ff ff       	call   36a <clone>
 8b2:	8b 55 08             	mov    0x8(%ebp),%edx
 8b5:	89 02                	mov    %eax,(%edx)
 8b7:	8b 45 08             	mov    0x8(%ebp),%eax
 8ba:	8b 00                	mov    (%eax),%eax
 8bc:	85 c0                	test   %eax,%eax
 8be:	79 07                	jns    8c7 <thread_create+0x99>
        return -1;
 8c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8c5:	eb 05                	jmp    8cc <thread_create+0x9e>
    return 0;
 8c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8cc:	c9                   	leave  
 8cd:	c3                   	ret    

000008ce <thread_join>:

int thread_join(thread_t thread, void **retval)
{
 8ce:	55                   	push   %ebp
 8cf:	89 e5                	mov    %esp,%ebp
 8d1:	83 ec 28             	sub    $0x28,%esp
    void *stack;
    if(join((uint)thread, &stack, retval)<0)
 8d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 8d7:	89 44 24 08          	mov    %eax,0x8(%esp)
 8db:	8d 45 f4             	lea    -0xc(%ebp),%eax
 8de:	89 44 24 04          	mov    %eax,0x4(%esp)
 8e2:	8b 45 08             	mov    0x8(%ebp),%eax
 8e5:	89 04 24             	mov    %eax,(%esp)
 8e8:	e8 85 fa ff ff       	call   372 <join>
 8ed:	85 c0                	test   %eax,%eax
 8ef:	79 07                	jns    8f8 <thread_join+0x2a>
        return -1;
 8f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8f6:	eb 10                	jmp    908 <thread_join+0x3a>

    free(stack);
 8f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fb:	89 04 24             	mov    %eax,(%esp)
 8fe:	e8 12 fd ff ff       	call   615 <free>
    return 0;
 903:	b8 00 00 00 00       	mov    $0x0,%eax
}
 908:	c9                   	leave  
 909:	c3                   	ret    

0000090a <thread_exit>:

void thread_exit(void *retval)
{
 90a:	55                   	push   %ebp
 90b:	89 e5                	mov    %esp,%ebp
 90d:	83 ec 08             	sub    $0x8,%esp
    proc->retval = retval;
 910:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 916:	8b 55 08             	mov    0x8(%ebp),%edx
 919:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
    thexit();
 91f:	e8 56 fa ff ff       	call   37a <thexit>
}
 924:	c9                   	leave  
 925:	c3                   	ret    
