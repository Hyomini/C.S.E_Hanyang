
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
    int ret_val1;
    int ret_val2;
    
    ret_val1 = getpid();
   9:	e8 32 03 00 00       	call   340 <getpid>
   e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    ret_val2 = getppid();
  12:	e8 51 03 00 00       	call   368 <getppid>
  17:	89 44 24 18          	mov    %eax,0x18(%esp)

    printf(1,"My pid is %d\n", ret_val1);
  1b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  1f:	89 44 24 08          	mov    %eax,0x8(%esp)
  23:	c7 44 24 04 3c 09 00 	movl   $0x93c,0x4(%esp)
  2a:	00 
  2b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  32:	e8 41 04 00 00       	call   478 <printf>
    printf(1,"My ppid is %d\n", ret_val2);
  37:	8b 44 24 18          	mov    0x18(%esp),%eax
  3b:	89 44 24 08          	mov    %eax,0x8(%esp)
  3f:	c7 44 24 04 4a 09 00 	movl   $0x94a,0x4(%esp)
  46:	00 
  47:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4e:	e8 25 04 00 00       	call   478 <printf>
    exit();
  53:	e8 68 02 00 00       	call   2c0 <exit>

00000058 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  58:	55                   	push   %ebp
  59:	89 e5                	mov    %esp,%ebp
  5b:	57                   	push   %edi
  5c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  60:	8b 55 10             	mov    0x10(%ebp),%edx
  63:	8b 45 0c             	mov    0xc(%ebp),%eax
  66:	89 cb                	mov    %ecx,%ebx
  68:	89 df                	mov    %ebx,%edi
  6a:	89 d1                	mov    %edx,%ecx
  6c:	fc                   	cld    
  6d:	f3 aa                	rep stos %al,%es:(%edi)
  6f:	89 ca                	mov    %ecx,%edx
  71:	89 fb                	mov    %edi,%ebx
  73:	89 5d 08             	mov    %ebx,0x8(%ebp)
  76:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  79:	5b                   	pop    %ebx
  7a:	5f                   	pop    %edi
  7b:	5d                   	pop    %ebp
  7c:	c3                   	ret    

0000007d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  7d:	55                   	push   %ebp
  7e:	89 e5                	mov    %esp,%ebp
  80:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  83:	8b 45 08             	mov    0x8(%ebp),%eax
  86:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  89:	90                   	nop
  8a:	8b 45 08             	mov    0x8(%ebp),%eax
  8d:	8d 50 01             	lea    0x1(%eax),%edx
  90:	89 55 08             	mov    %edx,0x8(%ebp)
  93:	8b 55 0c             	mov    0xc(%ebp),%edx
  96:	8d 4a 01             	lea    0x1(%edx),%ecx
  99:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  9c:	0f b6 12             	movzbl (%edx),%edx
  9f:	88 10                	mov    %dl,(%eax)
  a1:	0f b6 00             	movzbl (%eax),%eax
  a4:	84 c0                	test   %al,%al
  a6:	75 e2                	jne    8a <strcpy+0xd>
    ;
  return os;
  a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ab:	c9                   	leave  
  ac:	c3                   	ret    

000000ad <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ad:	55                   	push   %ebp
  ae:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  b0:	eb 08                	jmp    ba <strcmp+0xd>
    p++, q++;
  b2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  b6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ba:	8b 45 08             	mov    0x8(%ebp),%eax
  bd:	0f b6 00             	movzbl (%eax),%eax
  c0:	84 c0                	test   %al,%al
  c2:	74 10                	je     d4 <strcmp+0x27>
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	0f b6 10             	movzbl (%eax),%edx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	0f b6 00             	movzbl (%eax),%eax
  d0:	38 c2                	cmp    %al,%dl
  d2:	74 de                	je     b2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	0f b6 00             	movzbl (%eax),%eax
  da:	0f b6 d0             	movzbl %al,%edx
  dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  e0:	0f b6 00             	movzbl (%eax),%eax
  e3:	0f b6 c0             	movzbl %al,%eax
  e6:	29 c2                	sub    %eax,%edx
  e8:	89 d0                	mov    %edx,%eax
}
  ea:	5d                   	pop    %ebp
  eb:	c3                   	ret    

000000ec <strlen>:

uint
strlen(char *s)
{
  ec:	55                   	push   %ebp
  ed:	89 e5                	mov    %esp,%ebp
  ef:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  f9:	eb 04                	jmp    ff <strlen+0x13>
  fb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
 102:	8b 45 08             	mov    0x8(%ebp),%eax
 105:	01 d0                	add    %edx,%eax
 107:	0f b6 00             	movzbl (%eax),%eax
 10a:	84 c0                	test   %al,%al
 10c:	75 ed                	jne    fb <strlen+0xf>
    ;
  return n;
 10e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 111:	c9                   	leave  
 112:	c3                   	ret    

00000113 <memset>:

void*
memset(void *dst, int c, uint n)
{
 113:	55                   	push   %ebp
 114:	89 e5                	mov    %esp,%ebp
 116:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 119:	8b 45 10             	mov    0x10(%ebp),%eax
 11c:	89 44 24 08          	mov    %eax,0x8(%esp)
 120:	8b 45 0c             	mov    0xc(%ebp),%eax
 123:	89 44 24 04          	mov    %eax,0x4(%esp)
 127:	8b 45 08             	mov    0x8(%ebp),%eax
 12a:	89 04 24             	mov    %eax,(%esp)
 12d:	e8 26 ff ff ff       	call   58 <stosb>
  return dst;
 132:	8b 45 08             	mov    0x8(%ebp),%eax
}
 135:	c9                   	leave  
 136:	c3                   	ret    

00000137 <strchr>:

char*
strchr(const char *s, char c)
{
 137:	55                   	push   %ebp
 138:	89 e5                	mov    %esp,%ebp
 13a:	83 ec 04             	sub    $0x4,%esp
 13d:	8b 45 0c             	mov    0xc(%ebp),%eax
 140:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 143:	eb 14                	jmp    159 <strchr+0x22>
    if(*s == c)
 145:	8b 45 08             	mov    0x8(%ebp),%eax
 148:	0f b6 00             	movzbl (%eax),%eax
 14b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 14e:	75 05                	jne    155 <strchr+0x1e>
      return (char*)s;
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	eb 13                	jmp    168 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 155:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 159:	8b 45 08             	mov    0x8(%ebp),%eax
 15c:	0f b6 00             	movzbl (%eax),%eax
 15f:	84 c0                	test   %al,%al
 161:	75 e2                	jne    145 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 163:	b8 00 00 00 00       	mov    $0x0,%eax
}
 168:	c9                   	leave  
 169:	c3                   	ret    

0000016a <gets>:

char*
gets(char *buf, int max)
{
 16a:	55                   	push   %ebp
 16b:	89 e5                	mov    %esp,%ebp
 16d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 170:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 177:	eb 4c                	jmp    1c5 <gets+0x5b>
    cc = read(0, &c, 1);
 179:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 180:	00 
 181:	8d 45 ef             	lea    -0x11(%ebp),%eax
 184:	89 44 24 04          	mov    %eax,0x4(%esp)
 188:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 18f:	e8 44 01 00 00       	call   2d8 <read>
 194:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 197:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 19b:	7f 02                	jg     19f <gets+0x35>
      break;
 19d:	eb 31                	jmp    1d0 <gets+0x66>
    buf[i++] = c;
 19f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a2:	8d 50 01             	lea    0x1(%eax),%edx
 1a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1a8:	89 c2                	mov    %eax,%edx
 1aa:	8b 45 08             	mov    0x8(%ebp),%eax
 1ad:	01 c2                	add    %eax,%edx
 1af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b3:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1b5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b9:	3c 0a                	cmp    $0xa,%al
 1bb:	74 13                	je     1d0 <gets+0x66>
 1bd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c1:	3c 0d                	cmp    $0xd,%al
 1c3:	74 0b                	je     1d0 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c8:	83 c0 01             	add    $0x1,%eax
 1cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ce:	7c a9                	jl     179 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	01 d0                	add    %edx,%eax
 1d8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1de:	c9                   	leave  
 1df:	c3                   	ret    

000001e0 <stat>:

int
stat(char *n, struct stat *st)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1ed:	00 
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	89 04 24             	mov    %eax,(%esp)
 1f4:	e8 07 01 00 00       	call   300 <open>
 1f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 200:	79 07                	jns    209 <stat+0x29>
    return -1;
 202:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 207:	eb 23                	jmp    22c <stat+0x4c>
  r = fstat(fd, st);
 209:	8b 45 0c             	mov    0xc(%ebp),%eax
 20c:	89 44 24 04          	mov    %eax,0x4(%esp)
 210:	8b 45 f4             	mov    -0xc(%ebp),%eax
 213:	89 04 24             	mov    %eax,(%esp)
 216:	e8 fd 00 00 00       	call   318 <fstat>
 21b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 21e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 221:	89 04 24             	mov    %eax,(%esp)
 224:	e8 bf 00 00 00       	call   2e8 <close>
  return r;
 229:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 22c:	c9                   	leave  
 22d:	c3                   	ret    

0000022e <atoi>:

int
atoi(const char *s)
{
 22e:	55                   	push   %ebp
 22f:	89 e5                	mov    %esp,%ebp
 231:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 234:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 23b:	eb 25                	jmp    262 <atoi+0x34>
    n = n*10 + *s++ - '0';
 23d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 240:	89 d0                	mov    %edx,%eax
 242:	c1 e0 02             	shl    $0x2,%eax
 245:	01 d0                	add    %edx,%eax
 247:	01 c0                	add    %eax,%eax
 249:	89 c1                	mov    %eax,%ecx
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
 24e:	8d 50 01             	lea    0x1(%eax),%edx
 251:	89 55 08             	mov    %edx,0x8(%ebp)
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	0f be c0             	movsbl %al,%eax
 25a:	01 c8                	add    %ecx,%eax
 25c:	83 e8 30             	sub    $0x30,%eax
 25f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	0f b6 00             	movzbl (%eax),%eax
 268:	3c 2f                	cmp    $0x2f,%al
 26a:	7e 0a                	jle    276 <atoi+0x48>
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	0f b6 00             	movzbl (%eax),%eax
 272:	3c 39                	cmp    $0x39,%al
 274:	7e c7                	jle    23d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 276:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 279:	c9                   	leave  
 27a:	c3                   	ret    

0000027b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 27b:	55                   	push   %ebp
 27c:	89 e5                	mov    %esp,%ebp
 27e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 287:	8b 45 0c             	mov    0xc(%ebp),%eax
 28a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 28d:	eb 17                	jmp    2a6 <memmove+0x2b>
    *dst++ = *src++;
 28f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 292:	8d 50 01             	lea    0x1(%eax),%edx
 295:	89 55 fc             	mov    %edx,-0x4(%ebp)
 298:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29b:	8d 4a 01             	lea    0x1(%edx),%ecx
 29e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2a1:	0f b6 12             	movzbl (%edx),%edx
 2a4:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a6:	8b 45 10             	mov    0x10(%ebp),%eax
 2a9:	8d 50 ff             	lea    -0x1(%eax),%edx
 2ac:	89 55 10             	mov    %edx,0x10(%ebp)
 2af:	85 c0                	test   %eax,%eax
 2b1:	7f dc                	jg     28f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b6:	c9                   	leave  
 2b7:	c3                   	ret    

000002b8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b8:	b8 01 00 00 00       	mov    $0x1,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <exit>:
SYSCALL(exit)
 2c0:	b8 02 00 00 00       	mov    $0x2,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <wait>:
SYSCALL(wait)
 2c8:	b8 03 00 00 00       	mov    $0x3,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <pipe>:
SYSCALL(pipe)
 2d0:	b8 04 00 00 00       	mov    $0x4,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <read>:
SYSCALL(read)
 2d8:	b8 05 00 00 00       	mov    $0x5,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <write>:
SYSCALL(write)
 2e0:	b8 10 00 00 00       	mov    $0x10,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <close>:
SYSCALL(close)
 2e8:	b8 15 00 00 00       	mov    $0x15,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <kill>:
SYSCALL(kill)
 2f0:	b8 06 00 00 00       	mov    $0x6,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <exec>:
SYSCALL(exec)
 2f8:	b8 07 00 00 00       	mov    $0x7,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <open>:
SYSCALL(open)
 300:	b8 0f 00 00 00       	mov    $0xf,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <mknod>:
SYSCALL(mknod)
 308:	b8 11 00 00 00       	mov    $0x11,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <unlink>:
SYSCALL(unlink)
 310:	b8 12 00 00 00       	mov    $0x12,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <fstat>:
SYSCALL(fstat)
 318:	b8 08 00 00 00       	mov    $0x8,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <link>:
SYSCALL(link)
 320:	b8 13 00 00 00       	mov    $0x13,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <mkdir>:
SYSCALL(mkdir)
 328:	b8 14 00 00 00       	mov    $0x14,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <chdir>:
SYSCALL(chdir)
 330:	b8 09 00 00 00       	mov    $0x9,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <dup>:
SYSCALL(dup)
 338:	b8 0a 00 00 00       	mov    $0xa,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <getpid>:
SYSCALL(getpid)
 340:	b8 0b 00 00 00       	mov    $0xb,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <sbrk>:
SYSCALL(sbrk)
 348:	b8 0c 00 00 00       	mov    $0xc,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <sleep>:
SYSCALL(sleep)
 350:	b8 0d 00 00 00       	mov    $0xd,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <uptime>:
SYSCALL(uptime)
 358:	b8 0e 00 00 00       	mov    $0xe,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <my_syscall>:
SYSCALL(my_syscall)
 360:	b8 16 00 00 00       	mov    $0x16,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <getppid>:
SYSCALL(getppid)
 368:	b8 17 00 00 00       	mov    $0x17,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <yield>:
SYSCALL(yield)
 370:	b8 18 00 00 00       	mov    $0x18,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <getlev>:
SYSCALL(getlev)
 378:	b8 19 00 00 00       	mov    $0x19,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <clone>:
SYSCALL(clone)
 380:	b8 1a 00 00 00       	mov    $0x1a,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <join>:
SYSCALL(join)
 388:	b8 1b 00 00 00       	mov    $0x1b,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <thexit>:
SYSCALL(thexit)
 390:	b8 1c 00 00 00       	mov    $0x1c,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 398:	55                   	push   %ebp
 399:	89 e5                	mov    %esp,%ebp
 39b:	83 ec 18             	sub    $0x18,%esp
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3a4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3ab:	00 
 3ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3af:	89 44 24 04          	mov    %eax,0x4(%esp)
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	89 04 24             	mov    %eax,(%esp)
 3b9:	e8 22 ff ff ff       	call   2e0 <write>
}
 3be:	c9                   	leave  
 3bf:	c3                   	ret    

000003c0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	56                   	push   %esi
 3c4:	53                   	push   %ebx
 3c5:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3cf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3d3:	74 17                	je     3ec <printint+0x2c>
 3d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3d9:	79 11                	jns    3ec <printint+0x2c>
    neg = 1;
 3db:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e5:	f7 d8                	neg    %eax
 3e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ea:	eb 06                	jmp    3f2 <printint+0x32>
  } else {
    x = xx;
 3ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3f9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3fc:	8d 41 01             	lea    0x1(%ecx),%eax
 3ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
 402:	8b 5d 10             	mov    0x10(%ebp),%ebx
 405:	8b 45 ec             	mov    -0x14(%ebp),%eax
 408:	ba 00 00 00 00       	mov    $0x0,%edx
 40d:	f7 f3                	div    %ebx
 40f:	89 d0                	mov    %edx,%eax
 411:	0f b6 80 24 0c 00 00 	movzbl 0xc24(%eax),%eax
 418:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 41c:	8b 75 10             	mov    0x10(%ebp),%esi
 41f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 422:	ba 00 00 00 00       	mov    $0x0,%edx
 427:	f7 f6                	div    %esi
 429:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 430:	75 c7                	jne    3f9 <printint+0x39>
  if(neg)
 432:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 436:	74 10                	je     448 <printint+0x88>
    buf[i++] = '-';
 438:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43b:	8d 50 01             	lea    0x1(%eax),%edx
 43e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 441:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 446:	eb 1f                	jmp    467 <printint+0xa7>
 448:	eb 1d                	jmp    467 <printint+0xa7>
    putc(fd, buf[i]);
 44a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 44d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 450:	01 d0                	add    %edx,%eax
 452:	0f b6 00             	movzbl (%eax),%eax
 455:	0f be c0             	movsbl %al,%eax
 458:	89 44 24 04          	mov    %eax,0x4(%esp)
 45c:	8b 45 08             	mov    0x8(%ebp),%eax
 45f:	89 04 24             	mov    %eax,(%esp)
 462:	e8 31 ff ff ff       	call   398 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 467:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 46b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 46f:	79 d9                	jns    44a <printint+0x8a>
    putc(fd, buf[i]);
}
 471:	83 c4 30             	add    $0x30,%esp
 474:	5b                   	pop    %ebx
 475:	5e                   	pop    %esi
 476:	5d                   	pop    %ebp
 477:	c3                   	ret    

00000478 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 478:	55                   	push   %ebp
 479:	89 e5                	mov    %esp,%ebp
 47b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 47e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 485:	8d 45 0c             	lea    0xc(%ebp),%eax
 488:	83 c0 04             	add    $0x4,%eax
 48b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 48e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 495:	e9 7c 01 00 00       	jmp    616 <printf+0x19e>
    c = fmt[i] & 0xff;
 49a:	8b 55 0c             	mov    0xc(%ebp),%edx
 49d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a0:	01 d0                	add    %edx,%eax
 4a2:	0f b6 00             	movzbl (%eax),%eax
 4a5:	0f be c0             	movsbl %al,%eax
 4a8:	25 ff 00 00 00       	and    $0xff,%eax
 4ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b4:	75 2c                	jne    4e2 <printf+0x6a>
      if(c == '%'){
 4b6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4ba:	75 0c                	jne    4c8 <printf+0x50>
        state = '%';
 4bc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4c3:	e9 4a 01 00 00       	jmp    612 <printf+0x19a>
      } else {
        putc(fd, c);
 4c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4cb:	0f be c0             	movsbl %al,%eax
 4ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d2:	8b 45 08             	mov    0x8(%ebp),%eax
 4d5:	89 04 24             	mov    %eax,(%esp)
 4d8:	e8 bb fe ff ff       	call   398 <putc>
 4dd:	e9 30 01 00 00       	jmp    612 <printf+0x19a>
      }
    } else if(state == '%'){
 4e2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e6:	0f 85 26 01 00 00    	jne    612 <printf+0x19a>
      if(c == 'd'){
 4ec:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4f0:	75 2d                	jne    51f <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f5:	8b 00                	mov    (%eax),%eax
 4f7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4fe:	00 
 4ff:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 506:	00 
 507:	89 44 24 04          	mov    %eax,0x4(%esp)
 50b:	8b 45 08             	mov    0x8(%ebp),%eax
 50e:	89 04 24             	mov    %eax,(%esp)
 511:	e8 aa fe ff ff       	call   3c0 <printint>
        ap++;
 516:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51a:	e9 ec 00 00 00       	jmp    60b <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 51f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 523:	74 06                	je     52b <printf+0xb3>
 525:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 529:	75 2d                	jne    558 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 52b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52e:	8b 00                	mov    (%eax),%eax
 530:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 537:	00 
 538:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 53f:	00 
 540:	89 44 24 04          	mov    %eax,0x4(%esp)
 544:	8b 45 08             	mov    0x8(%ebp),%eax
 547:	89 04 24             	mov    %eax,(%esp)
 54a:	e8 71 fe ff ff       	call   3c0 <printint>
        ap++;
 54f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 553:	e9 b3 00 00 00       	jmp    60b <printf+0x193>
      } else if(c == 's'){
 558:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 55c:	75 45                	jne    5a3 <printf+0x12b>
        s = (char*)*ap;
 55e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 561:	8b 00                	mov    (%eax),%eax
 563:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 566:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 56a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 56e:	75 09                	jne    579 <printf+0x101>
          s = "(null)";
 570:	c7 45 f4 59 09 00 00 	movl   $0x959,-0xc(%ebp)
        while(*s != 0){
 577:	eb 1e                	jmp    597 <printf+0x11f>
 579:	eb 1c                	jmp    597 <printf+0x11f>
          putc(fd, *s);
 57b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57e:	0f b6 00             	movzbl (%eax),%eax
 581:	0f be c0             	movsbl %al,%eax
 584:	89 44 24 04          	mov    %eax,0x4(%esp)
 588:	8b 45 08             	mov    0x8(%ebp),%eax
 58b:	89 04 24             	mov    %eax,(%esp)
 58e:	e8 05 fe ff ff       	call   398 <putc>
          s++;
 593:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 597:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59a:	0f b6 00             	movzbl (%eax),%eax
 59d:	84 c0                	test   %al,%al
 59f:	75 da                	jne    57b <printf+0x103>
 5a1:	eb 68                	jmp    60b <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5a3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5a7:	75 1d                	jne    5c6 <printf+0x14e>
        putc(fd, *ap);
 5a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ac:	8b 00                	mov    (%eax),%eax
 5ae:	0f be c0             	movsbl %al,%eax
 5b1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b5:	8b 45 08             	mov    0x8(%ebp),%eax
 5b8:	89 04 24             	mov    %eax,(%esp)
 5bb:	e8 d8 fd ff ff       	call   398 <putc>
        ap++;
 5c0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c4:	eb 45                	jmp    60b <printf+0x193>
      } else if(c == '%'){
 5c6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ca:	75 17                	jne    5e3 <printf+0x16b>
        putc(fd, c);
 5cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5cf:	0f be c0             	movsbl %al,%eax
 5d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d6:	8b 45 08             	mov    0x8(%ebp),%eax
 5d9:	89 04 24             	mov    %eax,(%esp)
 5dc:	e8 b7 fd ff ff       	call   398 <putc>
 5e1:	eb 28                	jmp    60b <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5ea:	00 
 5eb:	8b 45 08             	mov    0x8(%ebp),%eax
 5ee:	89 04 24             	mov    %eax,(%esp)
 5f1:	e8 a2 fd ff ff       	call   398 <putc>
        putc(fd, c);
 5f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f9:	0f be c0             	movsbl %al,%eax
 5fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 600:	8b 45 08             	mov    0x8(%ebp),%eax
 603:	89 04 24             	mov    %eax,(%esp)
 606:	e8 8d fd ff ff       	call   398 <putc>
      }
      state = 0;
 60b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 612:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 616:	8b 55 0c             	mov    0xc(%ebp),%edx
 619:	8b 45 f0             	mov    -0x10(%ebp),%eax
 61c:	01 d0                	add    %edx,%eax
 61e:	0f b6 00             	movzbl (%eax),%eax
 621:	84 c0                	test   %al,%al
 623:	0f 85 71 fe ff ff    	jne    49a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 629:	c9                   	leave  
 62a:	c3                   	ret    

0000062b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 62b:	55                   	push   %ebp
 62c:	89 e5                	mov    %esp,%ebp
 62e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 631:	8b 45 08             	mov    0x8(%ebp),%eax
 634:	83 e8 08             	sub    $0x8,%eax
 637:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63a:	a1 40 0c 00 00       	mov    0xc40,%eax
 63f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 642:	eb 24                	jmp    668 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 644:	8b 45 fc             	mov    -0x4(%ebp),%eax
 647:	8b 00                	mov    (%eax),%eax
 649:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64c:	77 12                	ja     660 <free+0x35>
 64e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 651:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 654:	77 24                	ja     67a <free+0x4f>
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65e:	77 1a                	ja     67a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 660:	8b 45 fc             	mov    -0x4(%ebp),%eax
 663:	8b 00                	mov    (%eax),%eax
 665:	89 45 fc             	mov    %eax,-0x4(%ebp)
 668:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 66e:	76 d4                	jbe    644 <free+0x19>
 670:	8b 45 fc             	mov    -0x4(%ebp),%eax
 673:	8b 00                	mov    (%eax),%eax
 675:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 678:	76 ca                	jbe    644 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 67a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67d:	8b 40 04             	mov    0x4(%eax),%eax
 680:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 687:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68a:	01 c2                	add    %eax,%edx
 68c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68f:	8b 00                	mov    (%eax),%eax
 691:	39 c2                	cmp    %eax,%edx
 693:	75 24                	jne    6b9 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 695:	8b 45 f8             	mov    -0x8(%ebp),%eax
 698:	8b 50 04             	mov    0x4(%eax),%edx
 69b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69e:	8b 00                	mov    (%eax),%eax
 6a0:	8b 40 04             	mov    0x4(%eax),%eax
 6a3:	01 c2                	add    %eax,%edx
 6a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 00                	mov    (%eax),%eax
 6b0:	8b 10                	mov    (%eax),%edx
 6b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b5:	89 10                	mov    %edx,(%eax)
 6b7:	eb 0a                	jmp    6c3 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	8b 10                	mov    (%eax),%edx
 6be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c1:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c6:	8b 40 04             	mov    0x4(%eax),%eax
 6c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	01 d0                	add    %edx,%eax
 6d5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d8:	75 20                	jne    6fa <free+0xcf>
    p->s.size += bp->s.size;
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	8b 50 04             	mov    0x4(%eax),%edx
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	8b 40 04             	mov    0x4(%eax),%eax
 6e6:	01 c2                	add    %eax,%edx
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	8b 10                	mov    (%eax),%edx
 6f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f6:	89 10                	mov    %edx,(%eax)
 6f8:	eb 08                	jmp    702 <free+0xd7>
  } else
    p->s.ptr = bp;
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 700:	89 10                	mov    %edx,(%eax)
  freep = p;
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	a3 40 0c 00 00       	mov    %eax,0xc40
}
 70a:	c9                   	leave  
 70b:	c3                   	ret    

0000070c <morecore>:

static Header*
morecore(uint nu)
{
 70c:	55                   	push   %ebp
 70d:	89 e5                	mov    %esp,%ebp
 70f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 712:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 719:	77 07                	ja     722 <morecore+0x16>
    nu = 4096;
 71b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 722:	8b 45 08             	mov    0x8(%ebp),%eax
 725:	c1 e0 03             	shl    $0x3,%eax
 728:	89 04 24             	mov    %eax,(%esp)
 72b:	e8 18 fc ff ff       	call   348 <sbrk>
 730:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 733:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 737:	75 07                	jne    740 <morecore+0x34>
    return 0;
 739:	b8 00 00 00 00       	mov    $0x0,%eax
 73e:	eb 22                	jmp    762 <morecore+0x56>
  hp = (Header*)p;
 740:	8b 45 f4             	mov    -0xc(%ebp),%eax
 743:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 746:	8b 45 f0             	mov    -0x10(%ebp),%eax
 749:	8b 55 08             	mov    0x8(%ebp),%edx
 74c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 74f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 752:	83 c0 08             	add    $0x8,%eax
 755:	89 04 24             	mov    %eax,(%esp)
 758:	e8 ce fe ff ff       	call   62b <free>
  return freep;
 75d:	a1 40 0c 00 00       	mov    0xc40,%eax
}
 762:	c9                   	leave  
 763:	c3                   	ret    

00000764 <malloc>:

void*
malloc(uint nbytes)
{
 764:	55                   	push   %ebp
 765:	89 e5                	mov    %esp,%ebp
 767:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 76a:	8b 45 08             	mov    0x8(%ebp),%eax
 76d:	83 c0 07             	add    $0x7,%eax
 770:	c1 e8 03             	shr    $0x3,%eax
 773:	83 c0 01             	add    $0x1,%eax
 776:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 779:	a1 40 0c 00 00       	mov    0xc40,%eax
 77e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 781:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 785:	75 23                	jne    7aa <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 787:	c7 45 f0 38 0c 00 00 	movl   $0xc38,-0x10(%ebp)
 78e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 791:	a3 40 0c 00 00       	mov    %eax,0xc40
 796:	a1 40 0c 00 00       	mov    0xc40,%eax
 79b:	a3 38 0c 00 00       	mov    %eax,0xc38
    base.s.size = 0;
 7a0:	c7 05 3c 0c 00 00 00 	movl   $0x0,0xc3c
 7a7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ad:	8b 00                	mov    (%eax),%eax
 7af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b5:	8b 40 04             	mov    0x4(%eax),%eax
 7b8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7bb:	72 4d                	jb     80a <malloc+0xa6>
      if(p->s.size == nunits)
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	8b 40 04             	mov    0x4(%eax),%eax
 7c3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c6:	75 0c                	jne    7d4 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cb:	8b 10                	mov    (%eax),%edx
 7cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d0:	89 10                	mov    %edx,(%eax)
 7d2:	eb 26                	jmp    7fa <malloc+0x96>
      else {
        p->s.size -= nunits;
 7d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d7:	8b 40 04             	mov    0x4(%eax),%eax
 7da:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7dd:	89 c2                	mov    %eax,%edx
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e8:	8b 40 04             	mov    0x4(%eax),%eax
 7eb:	c1 e0 03             	shl    $0x3,%eax
 7ee:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7f7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fd:	a3 40 0c 00 00       	mov    %eax,0xc40
      return (void*)(p + 1);
 802:	8b 45 f4             	mov    -0xc(%ebp),%eax
 805:	83 c0 08             	add    $0x8,%eax
 808:	eb 38                	jmp    842 <malloc+0xde>
    }
    if(p == freep)
 80a:	a1 40 0c 00 00       	mov    0xc40,%eax
 80f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 812:	75 1b                	jne    82f <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 814:	8b 45 ec             	mov    -0x14(%ebp),%eax
 817:	89 04 24             	mov    %eax,(%esp)
 81a:	e8 ed fe ff ff       	call   70c <morecore>
 81f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 822:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 826:	75 07                	jne    82f <malloc+0xcb>
        return 0;
 828:	b8 00 00 00 00       	mov    $0x0,%eax
 82d:	eb 13                	jmp    842 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 832:	89 45 f0             	mov    %eax,-0x10(%ebp)
 835:	8b 45 f4             	mov    -0xc(%ebp),%eax
 838:	8b 00                	mov    (%eax),%eax
 83a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 83d:	e9 70 ff ff ff       	jmp    7b2 <malloc+0x4e>
}
 842:	c9                   	leave  
 843:	c3                   	ret    

00000844 <thread_create>:
#include"x86.h"
#include"param.h"
#include"proc.h"

int thread_create(thread_t *thread, void*(*start_routine)(void*),void *arg)
{
 844:	55                   	push   %ebp
 845:	89 e5                	mov    %esp,%ebp
 847:	83 ec 28             	sub    $0x28,%esp
    void *stack = malloc(PGSIZE);
 84a:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 851:	e8 0e ff ff ff       	call   764 <malloc>
 856:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if((uint)stack <=0)
 859:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85c:	85 c0                	test   %eax,%eax
 85e:	75 1b                	jne    87b <thread_create+0x37>
    {
        printf(1,"malloc thread stack failed\n");
 860:	c7 44 24 04 60 09 00 	movl   $0x960,0x4(%esp)
 867:	00 
 868:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 86f:	e8 04 fc ff ff       	call   478 <printf>
        return -1;
 874:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 879:	eb 67                	jmp    8e2 <thread_create+0x9e>
    }
    
    if((uint)stack%PGSIZE)
 87b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87e:	25 ff 0f 00 00       	and    $0xfff,%eax
 883:	85 c0                	test   %eax,%eax
 885:	74 14                	je     89b <thread_create+0x57>
        stack += PGSIZE-((uint)stack%PGSIZE);
 887:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88a:	25 ff 0f 00 00       	and    $0xfff,%eax
 88f:	89 c2                	mov    %eax,%edx
 891:	b8 00 10 00 00       	mov    $0x1000,%eax
 896:	29 d0                	sub    %edx,%eax
 898:	01 45 f4             	add    %eax,-0xc(%ebp)
    printf(1,"1\n");
 89b:	c7 44 24 04 7c 09 00 	movl   $0x97c,0x4(%esp)
 8a2:	00 
 8a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8aa:	e8 c9 fb ff ff       	call   478 <printf>
    if((*thread = clone(start_routine,arg,stack))<0)
 8af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b2:	89 44 24 08          	mov    %eax,0x8(%esp)
 8b6:	8b 45 10             	mov    0x10(%ebp),%eax
 8b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 8bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 8c0:	89 04 24             	mov    %eax,(%esp)
 8c3:	e8 b8 fa ff ff       	call   380 <clone>
 8c8:	8b 55 08             	mov    0x8(%ebp),%edx
 8cb:	89 02                	mov    %eax,(%edx)
 8cd:	8b 45 08             	mov    0x8(%ebp),%eax
 8d0:	8b 00                	mov    (%eax),%eax
 8d2:	85 c0                	test   %eax,%eax
 8d4:	79 07                	jns    8dd <thread_create+0x99>
        return -1;
 8d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8db:	eb 05                	jmp    8e2 <thread_create+0x9e>
    return 0;
 8dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8e2:	c9                   	leave  
 8e3:	c3                   	ret    

000008e4 <thread_join>:

int thread_join(thread_t thread, void **retval)
{
 8e4:	55                   	push   %ebp
 8e5:	89 e5                	mov    %esp,%ebp
 8e7:	83 ec 28             	sub    $0x28,%esp
    void *stack;
    if(join((uint)thread, &stack, retval)<0)
 8ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 8ed:	89 44 24 08          	mov    %eax,0x8(%esp)
 8f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
 8f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 8f8:	8b 45 08             	mov    0x8(%ebp),%eax
 8fb:	89 04 24             	mov    %eax,(%esp)
 8fe:	e8 85 fa ff ff       	call   388 <join>
 903:	85 c0                	test   %eax,%eax
 905:	79 07                	jns    90e <thread_join+0x2a>
        return -1;
 907:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 90c:	eb 10                	jmp    91e <thread_join+0x3a>

    free(stack);
 90e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 911:	89 04 24             	mov    %eax,(%esp)
 914:	e8 12 fd ff ff       	call   62b <free>
    return 0;
 919:	b8 00 00 00 00       	mov    $0x0,%eax
}
 91e:	c9                   	leave  
 91f:	c3                   	ret    

00000920 <thread_exit>:

void thread_exit(void *retval)
{
 920:	55                   	push   %ebp
 921:	89 e5                	mov    %esp,%ebp
 923:	83 ec 08             	sub    $0x8,%esp
    proc->retval = retval;
 926:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 92c:	8b 55 08             	mov    0x8(%ebp),%edx
 92f:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
    thexit();
 935:	e8 56 fa ff ff       	call   390 <thexit>
}
 93a:	c9                   	leave  
 93b:	c3                   	ret    
