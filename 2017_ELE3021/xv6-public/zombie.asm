
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 75 02 00 00       	call   283 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 fd 02 00 00       	call   31b <sleep>
  exit();
  1e:	e8 68 02 00 00       	call   28b <exit>

00000023 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  23:	55                   	push   %ebp
  24:	89 e5                	mov    %esp,%ebp
  26:	57                   	push   %edi
  27:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2b:	8b 55 10             	mov    0x10(%ebp),%edx
  2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  31:	89 cb                	mov    %ecx,%ebx
  33:	89 df                	mov    %ebx,%edi
  35:	89 d1                	mov    %edx,%ecx
  37:	fc                   	cld    
  38:	f3 aa                	rep stos %al,%es:(%edi)
  3a:	89 ca                	mov    %ecx,%edx
  3c:	89 fb                	mov    %edi,%ebx
  3e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  41:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  44:	5b                   	pop    %ebx
  45:	5f                   	pop    %edi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    

00000048 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4e:	8b 45 08             	mov    0x8(%ebp),%eax
  51:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  54:	90                   	nop
  55:	8b 45 08             	mov    0x8(%ebp),%eax
  58:	8d 50 01             	lea    0x1(%eax),%edx
  5b:	89 55 08             	mov    %edx,0x8(%ebp)
  5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  61:	8d 4a 01             	lea    0x1(%edx),%ecx
  64:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  67:	0f b6 12             	movzbl (%edx),%edx
  6a:	88 10                	mov    %dl,(%eax)
  6c:	0f b6 00             	movzbl (%eax),%eax
  6f:	84 c0                	test   %al,%al
  71:	75 e2                	jne    55 <strcpy+0xd>
    ;
  return os;
  73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  76:	c9                   	leave  
  77:	c3                   	ret    

00000078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7b:	eb 08                	jmp    85 <strcmp+0xd>
    p++, q++;
  7d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  81:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  85:	8b 45 08             	mov    0x8(%ebp),%eax
  88:	0f b6 00             	movzbl (%eax),%eax
  8b:	84 c0                	test   %al,%al
  8d:	74 10                	je     9f <strcmp+0x27>
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 10             	movzbl (%eax),%edx
  95:	8b 45 0c             	mov    0xc(%ebp),%eax
  98:	0f b6 00             	movzbl (%eax),%eax
  9b:	38 c2                	cmp    %al,%dl
  9d:	74 de                	je     7d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	0f b6 d0             	movzbl %al,%edx
  a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  ab:	0f b6 00             	movzbl (%eax),%eax
  ae:	0f b6 c0             	movzbl %al,%eax
  b1:	29 c2                	sub    %eax,%edx
  b3:	89 d0                	mov    %edx,%eax
}
  b5:	5d                   	pop    %ebp
  b6:	c3                   	ret    

000000b7 <strlen>:

uint
strlen(char *s)
{
  b7:	55                   	push   %ebp
  b8:	89 e5                	mov    %esp,%ebp
  ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c4:	eb 04                	jmp    ca <strlen+0x13>
  c6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  cd:	8b 45 08             	mov    0x8(%ebp),%eax
  d0:	01 d0                	add    %edx,%eax
  d2:	0f b6 00             	movzbl (%eax),%eax
  d5:	84 c0                	test   %al,%al
  d7:	75 ed                	jne    c6 <strlen+0xf>
    ;
  return n;
  d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  dc:	c9                   	leave  
  dd:	c3                   	ret    

000000de <memset>:

void*
memset(void *dst, int c, uint n)
{
  de:	55                   	push   %ebp
  df:	89 e5                	mov    %esp,%ebp
  e1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  e4:	8b 45 10             	mov    0x10(%ebp),%eax
  e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	89 04 24             	mov    %eax,(%esp)
  f8:	e8 26 ff ff ff       	call   23 <stosb>
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	3a 45 fc             	cmp    -0x4(%ebp),%al
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 4c                	jmp    190 <gets+0x5b>
    cc = read(0, &c, 1);
 144:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 14b:	00 
 14c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14f:	89 44 24 04          	mov    %eax,0x4(%esp)
 153:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 15a:	e8 44 01 00 00       	call   2a3 <read>
 15f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 166:	7f 02                	jg     16a <gets+0x35>
      break;
 168:	eb 31                	jmp    19b <gets+0x66>
    buf[i++] = c;
 16a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 16d:	8d 50 01             	lea    0x1(%eax),%edx
 170:	89 55 f4             	mov    %edx,-0xc(%ebp)
 173:	89 c2                	mov    %eax,%edx
 175:	8b 45 08             	mov    0x8(%ebp),%eax
 178:	01 c2                	add    %eax,%edx
 17a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 180:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 184:	3c 0a                	cmp    $0xa,%al
 186:	74 13                	je     19b <gets+0x66>
 188:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18c:	3c 0d                	cmp    $0xd,%al
 18e:	74 0b                	je     19b <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 190:	8b 45 f4             	mov    -0xc(%ebp),%eax
 193:	83 c0 01             	add    $0x1,%eax
 196:	3b 45 0c             	cmp    0xc(%ebp),%eax
 199:	7c a9                	jl     144 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 19b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	01 d0                	add    %edx,%eax
 1a3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a9:	c9                   	leave  
 1aa:	c3                   	ret    

000001ab <stat>:

int
stat(char *n, struct stat *st)
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1b8:	00 
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
 1bc:	89 04 24             	mov    %eax,(%esp)
 1bf:	e8 07 01 00 00       	call   2cb <open>
 1c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1cb:	79 07                	jns    1d4 <stat+0x29>
    return -1;
 1cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1d2:	eb 23                	jmp    1f7 <stat+0x4c>
  r = fstat(fd, st);
 1d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1de:	89 04 24             	mov    %eax,(%esp)
 1e1:	e8 fd 00 00 00       	call   2e3 <fstat>
 1e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ec:	89 04 24             	mov    %eax,(%esp)
 1ef:	e8 bf 00 00 00       	call   2b3 <close>
  return r;
 1f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1f7:	c9                   	leave  
 1f8:	c3                   	ret    

000001f9 <atoi>:

int
atoi(const char *s)
{
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 206:	eb 25                	jmp    22d <atoi+0x34>
    n = n*10 + *s++ - '0';
 208:	8b 55 fc             	mov    -0x4(%ebp),%edx
 20b:	89 d0                	mov    %edx,%eax
 20d:	c1 e0 02             	shl    $0x2,%eax
 210:	01 d0                	add    %edx,%eax
 212:	01 c0                	add    %eax,%eax
 214:	89 c1                	mov    %eax,%ecx
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	8d 50 01             	lea    0x1(%eax),%edx
 21c:	89 55 08             	mov    %edx,0x8(%ebp)
 21f:	0f b6 00             	movzbl (%eax),%eax
 222:	0f be c0             	movsbl %al,%eax
 225:	01 c8                	add    %ecx,%eax
 227:	83 e8 30             	sub    $0x30,%eax
 22a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	3c 2f                	cmp    $0x2f,%al
 235:	7e 0a                	jle    241 <atoi+0x48>
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	0f b6 00             	movzbl (%eax),%eax
 23d:	3c 39                	cmp    $0x39,%al
 23f:	7e c7                	jle    208 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 241:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 244:	c9                   	leave  
 245:	c3                   	ret    

00000246 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 246:	55                   	push   %ebp
 247:	89 e5                	mov    %esp,%ebp
 249:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 252:	8b 45 0c             	mov    0xc(%ebp),%eax
 255:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 258:	eb 17                	jmp    271 <memmove+0x2b>
    *dst++ = *src++;
 25a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 25d:	8d 50 01             	lea    0x1(%eax),%edx
 260:	89 55 fc             	mov    %edx,-0x4(%ebp)
 263:	8b 55 f8             	mov    -0x8(%ebp),%edx
 266:	8d 4a 01             	lea    0x1(%edx),%ecx
 269:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 26c:	0f b6 12             	movzbl (%edx),%edx
 26f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 271:	8b 45 10             	mov    0x10(%ebp),%eax
 274:	8d 50 ff             	lea    -0x1(%eax),%edx
 277:	89 55 10             	mov    %edx,0x10(%ebp)
 27a:	85 c0                	test   %eax,%eax
 27c:	7f dc                	jg     25a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 281:	c9                   	leave  
 282:	c3                   	ret    

00000283 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 283:	b8 01 00 00 00       	mov    $0x1,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <exit>:
SYSCALL(exit)
 28b:	b8 02 00 00 00       	mov    $0x2,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <wait>:
SYSCALL(wait)
 293:	b8 03 00 00 00       	mov    $0x3,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <pipe>:
SYSCALL(pipe)
 29b:	b8 04 00 00 00       	mov    $0x4,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <read>:
SYSCALL(read)
 2a3:	b8 05 00 00 00       	mov    $0x5,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <write>:
SYSCALL(write)
 2ab:	b8 10 00 00 00       	mov    $0x10,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <close>:
SYSCALL(close)
 2b3:	b8 15 00 00 00       	mov    $0x15,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <kill>:
SYSCALL(kill)
 2bb:	b8 06 00 00 00       	mov    $0x6,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <exec>:
SYSCALL(exec)
 2c3:	b8 07 00 00 00       	mov    $0x7,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <open>:
SYSCALL(open)
 2cb:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <mknod>:
SYSCALL(mknod)
 2d3:	b8 11 00 00 00       	mov    $0x11,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <unlink>:
SYSCALL(unlink)
 2db:	b8 12 00 00 00       	mov    $0x12,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <fstat>:
SYSCALL(fstat)
 2e3:	b8 08 00 00 00       	mov    $0x8,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <link>:
SYSCALL(link)
 2eb:	b8 13 00 00 00       	mov    $0x13,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <mkdir>:
SYSCALL(mkdir)
 2f3:	b8 14 00 00 00       	mov    $0x14,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <chdir>:
SYSCALL(chdir)
 2fb:	b8 09 00 00 00       	mov    $0x9,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <dup>:
SYSCALL(dup)
 303:	b8 0a 00 00 00       	mov    $0xa,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <getpid>:
SYSCALL(getpid)
 30b:	b8 0b 00 00 00       	mov    $0xb,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <sbrk>:
SYSCALL(sbrk)
 313:	b8 0c 00 00 00       	mov    $0xc,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <sleep>:
SYSCALL(sleep)
 31b:	b8 0d 00 00 00       	mov    $0xd,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <uptime>:
SYSCALL(uptime)
 323:	b8 0e 00 00 00       	mov    $0xe,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <my_syscall>:
SYSCALL(my_syscall)
 32b:	b8 16 00 00 00       	mov    $0x16,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <getppid>:
SYSCALL(getppid)
 333:	b8 17 00 00 00       	mov    $0x17,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <yield>:
SYSCALL(yield)
 33b:	b8 18 00 00 00       	mov    $0x18,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <getlev>:
SYSCALL(getlev)
 343:	b8 19 00 00 00       	mov    $0x19,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <clone>:
SYSCALL(clone)
 34b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <join>:
SYSCALL(join)
 353:	b8 1b 00 00 00       	mov    $0x1b,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <thexit>:
SYSCALL(thexit)
 35b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 363:	55                   	push   %ebp
 364:	89 e5                	mov    %esp,%ebp
 366:	83 ec 18             	sub    $0x18,%esp
 369:	8b 45 0c             	mov    0xc(%ebp),%eax
 36c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 36f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 376:	00 
 377:	8d 45 f4             	lea    -0xc(%ebp),%eax
 37a:	89 44 24 04          	mov    %eax,0x4(%esp)
 37e:	8b 45 08             	mov    0x8(%ebp),%eax
 381:	89 04 24             	mov    %eax,(%esp)
 384:	e8 22 ff ff ff       	call   2ab <write>
}
 389:	c9                   	leave  
 38a:	c3                   	ret    

0000038b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38b:	55                   	push   %ebp
 38c:	89 e5                	mov    %esp,%ebp
 38e:	56                   	push   %esi
 38f:	53                   	push   %ebx
 390:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 393:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 39a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 39e:	74 17                	je     3b7 <printint+0x2c>
 3a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3a4:	79 11                	jns    3b7 <printint+0x2c>
    neg = 1;
 3a6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b0:	f7 d8                	neg    %eax
 3b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b5:	eb 06                	jmp    3bd <printint+0x32>
  } else {
    x = xx;
 3b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3c4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3c7:	8d 41 01             	lea    0x1(%ecx),%eax
 3ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d3:	ba 00 00 00 00       	mov    $0x0,%edx
 3d8:	f7 f3                	div    %ebx
 3da:	89 d0                	mov    %edx,%eax
 3dc:	0f b6 80 d4 0b 00 00 	movzbl 0xbd4(%eax),%eax
 3e3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3e7:	8b 75 10             	mov    0x10(%ebp),%esi
 3ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ed:	ba 00 00 00 00       	mov    $0x0,%edx
 3f2:	f7 f6                	div    %esi
 3f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3fb:	75 c7                	jne    3c4 <printint+0x39>
  if(neg)
 3fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 401:	74 10                	je     413 <printint+0x88>
    buf[i++] = '-';
 403:	8b 45 f4             	mov    -0xc(%ebp),%eax
 406:	8d 50 01             	lea    0x1(%eax),%edx
 409:	89 55 f4             	mov    %edx,-0xc(%ebp)
 40c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 411:	eb 1f                	jmp    432 <printint+0xa7>
 413:	eb 1d                	jmp    432 <printint+0xa7>
    putc(fd, buf[i]);
 415:	8d 55 dc             	lea    -0x24(%ebp),%edx
 418:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41b:	01 d0                	add    %edx,%eax
 41d:	0f b6 00             	movzbl (%eax),%eax
 420:	0f be c0             	movsbl %al,%eax
 423:	89 44 24 04          	mov    %eax,0x4(%esp)
 427:	8b 45 08             	mov    0x8(%ebp),%eax
 42a:	89 04 24             	mov    %eax,(%esp)
 42d:	e8 31 ff ff ff       	call   363 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 432:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 436:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 43a:	79 d9                	jns    415 <printint+0x8a>
    putc(fd, buf[i]);
}
 43c:	83 c4 30             	add    $0x30,%esp
 43f:	5b                   	pop    %ebx
 440:	5e                   	pop    %esi
 441:	5d                   	pop    %ebp
 442:	c3                   	ret    

00000443 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 443:	55                   	push   %ebp
 444:	89 e5                	mov    %esp,%ebp
 446:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 449:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 450:	8d 45 0c             	lea    0xc(%ebp),%eax
 453:	83 c0 04             	add    $0x4,%eax
 456:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 459:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 460:	e9 7c 01 00 00       	jmp    5e1 <printf+0x19e>
    c = fmt[i] & 0xff;
 465:	8b 55 0c             	mov    0xc(%ebp),%edx
 468:	8b 45 f0             	mov    -0x10(%ebp),%eax
 46b:	01 d0                	add    %edx,%eax
 46d:	0f b6 00             	movzbl (%eax),%eax
 470:	0f be c0             	movsbl %al,%eax
 473:	25 ff 00 00 00       	and    $0xff,%eax
 478:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 47b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 47f:	75 2c                	jne    4ad <printf+0x6a>
      if(c == '%'){
 481:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 485:	75 0c                	jne    493 <printf+0x50>
        state = '%';
 487:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 48e:	e9 4a 01 00 00       	jmp    5dd <printf+0x19a>
      } else {
        putc(fd, c);
 493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 496:	0f be c0             	movsbl %al,%eax
 499:	89 44 24 04          	mov    %eax,0x4(%esp)
 49d:	8b 45 08             	mov    0x8(%ebp),%eax
 4a0:	89 04 24             	mov    %eax,(%esp)
 4a3:	e8 bb fe ff ff       	call   363 <putc>
 4a8:	e9 30 01 00 00       	jmp    5dd <printf+0x19a>
      }
    } else if(state == '%'){
 4ad:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4b1:	0f 85 26 01 00 00    	jne    5dd <printf+0x19a>
      if(c == 'd'){
 4b7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4bb:	75 2d                	jne    4ea <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c0:	8b 00                	mov    (%eax),%eax
 4c2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4c9:	00 
 4ca:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4d1:	00 
 4d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d6:	8b 45 08             	mov    0x8(%ebp),%eax
 4d9:	89 04 24             	mov    %eax,(%esp)
 4dc:	e8 aa fe ff ff       	call   38b <printint>
        ap++;
 4e1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e5:	e9 ec 00 00 00       	jmp    5d6 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 4ea:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4ee:	74 06                	je     4f6 <printf+0xb3>
 4f0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4f4:	75 2d                	jne    523 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 4f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f9:	8b 00                	mov    (%eax),%eax
 4fb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 502:	00 
 503:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 50a:	00 
 50b:	89 44 24 04          	mov    %eax,0x4(%esp)
 50f:	8b 45 08             	mov    0x8(%ebp),%eax
 512:	89 04 24             	mov    %eax,(%esp)
 515:	e8 71 fe ff ff       	call   38b <printint>
        ap++;
 51a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51e:	e9 b3 00 00 00       	jmp    5d6 <printf+0x193>
      } else if(c == 's'){
 523:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 527:	75 45                	jne    56e <printf+0x12b>
        s = (char*)*ap;
 529:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52c:	8b 00                	mov    (%eax),%eax
 52e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 531:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 535:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 539:	75 09                	jne    544 <printf+0x101>
          s = "(null)";
 53b:	c7 45 f4 07 09 00 00 	movl   $0x907,-0xc(%ebp)
        while(*s != 0){
 542:	eb 1e                	jmp    562 <printf+0x11f>
 544:	eb 1c                	jmp    562 <printf+0x11f>
          putc(fd, *s);
 546:	8b 45 f4             	mov    -0xc(%ebp),%eax
 549:	0f b6 00             	movzbl (%eax),%eax
 54c:	0f be c0             	movsbl %al,%eax
 54f:	89 44 24 04          	mov    %eax,0x4(%esp)
 553:	8b 45 08             	mov    0x8(%ebp),%eax
 556:	89 04 24             	mov    %eax,(%esp)
 559:	e8 05 fe ff ff       	call   363 <putc>
          s++;
 55e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 562:	8b 45 f4             	mov    -0xc(%ebp),%eax
 565:	0f b6 00             	movzbl (%eax),%eax
 568:	84 c0                	test   %al,%al
 56a:	75 da                	jne    546 <printf+0x103>
 56c:	eb 68                	jmp    5d6 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 56e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 572:	75 1d                	jne    591 <printf+0x14e>
        putc(fd, *ap);
 574:	8b 45 e8             	mov    -0x18(%ebp),%eax
 577:	8b 00                	mov    (%eax),%eax
 579:	0f be c0             	movsbl %al,%eax
 57c:	89 44 24 04          	mov    %eax,0x4(%esp)
 580:	8b 45 08             	mov    0x8(%ebp),%eax
 583:	89 04 24             	mov    %eax,(%esp)
 586:	e8 d8 fd ff ff       	call   363 <putc>
        ap++;
 58b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58f:	eb 45                	jmp    5d6 <printf+0x193>
      } else if(c == '%'){
 591:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 595:	75 17                	jne    5ae <printf+0x16b>
        putc(fd, c);
 597:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59a:	0f be c0             	movsbl %al,%eax
 59d:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a1:	8b 45 08             	mov    0x8(%ebp),%eax
 5a4:	89 04 24             	mov    %eax,(%esp)
 5a7:	e8 b7 fd ff ff       	call   363 <putc>
 5ac:	eb 28                	jmp    5d6 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ae:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5b5:	00 
 5b6:	8b 45 08             	mov    0x8(%ebp),%eax
 5b9:	89 04 24             	mov    %eax,(%esp)
 5bc:	e8 a2 fd ff ff       	call   363 <putc>
        putc(fd, c);
 5c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c4:	0f be c0             	movsbl %al,%eax
 5c7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cb:	8b 45 08             	mov    0x8(%ebp),%eax
 5ce:	89 04 24             	mov    %eax,(%esp)
 5d1:	e8 8d fd ff ff       	call   363 <putc>
      }
      state = 0;
 5d6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5dd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5e1:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e7:	01 d0                	add    %edx,%eax
 5e9:	0f b6 00             	movzbl (%eax),%eax
 5ec:	84 c0                	test   %al,%al
 5ee:	0f 85 71 fe ff ff    	jne    465 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5f4:	c9                   	leave  
 5f5:	c3                   	ret    

000005f6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f6:	55                   	push   %ebp
 5f7:	89 e5                	mov    %esp,%ebp
 5f9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5fc:	8b 45 08             	mov    0x8(%ebp),%eax
 5ff:	83 e8 08             	sub    $0x8,%eax
 602:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 605:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 60a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 60d:	eb 24                	jmp    633 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 60f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 612:	8b 00                	mov    (%eax),%eax
 614:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 617:	77 12                	ja     62b <free+0x35>
 619:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 61f:	77 24                	ja     645 <free+0x4f>
 621:	8b 45 fc             	mov    -0x4(%ebp),%eax
 624:	8b 00                	mov    (%eax),%eax
 626:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 629:	77 1a                	ja     645 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62e:	8b 00                	mov    (%eax),%eax
 630:	89 45 fc             	mov    %eax,-0x4(%ebp)
 633:	8b 45 f8             	mov    -0x8(%ebp),%eax
 636:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 639:	76 d4                	jbe    60f <free+0x19>
 63b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63e:	8b 00                	mov    (%eax),%eax
 640:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 643:	76 ca                	jbe    60f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 645:	8b 45 f8             	mov    -0x8(%ebp),%eax
 648:	8b 40 04             	mov    0x4(%eax),%eax
 64b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 652:	8b 45 f8             	mov    -0x8(%ebp),%eax
 655:	01 c2                	add    %eax,%edx
 657:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65a:	8b 00                	mov    (%eax),%eax
 65c:	39 c2                	cmp    %eax,%edx
 65e:	75 24                	jne    684 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 660:	8b 45 f8             	mov    -0x8(%ebp),%eax
 663:	8b 50 04             	mov    0x4(%eax),%edx
 666:	8b 45 fc             	mov    -0x4(%ebp),%eax
 669:	8b 00                	mov    (%eax),%eax
 66b:	8b 40 04             	mov    0x4(%eax),%eax
 66e:	01 c2                	add    %eax,%edx
 670:	8b 45 f8             	mov    -0x8(%ebp),%eax
 673:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 676:	8b 45 fc             	mov    -0x4(%ebp),%eax
 679:	8b 00                	mov    (%eax),%eax
 67b:	8b 10                	mov    (%eax),%edx
 67d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 680:	89 10                	mov    %edx,(%eax)
 682:	eb 0a                	jmp    68e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 10                	mov    (%eax),%edx
 689:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	8b 40 04             	mov    0x4(%eax),%eax
 694:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 69b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69e:	01 d0                	add    %edx,%eax
 6a0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a3:	75 20                	jne    6c5 <free+0xcf>
    p->s.size += bp->s.size;
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	8b 50 04             	mov    0x4(%eax),%edx
 6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ae:	8b 40 04             	mov    0x4(%eax),%eax
 6b1:	01 c2                	add    %eax,%edx
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bc:	8b 10                	mov    (%eax),%edx
 6be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c1:	89 10                	mov    %edx,(%eax)
 6c3:	eb 08                	jmp    6cd <free+0xd7>
  } else
    p->s.ptr = bp;
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6cb:	89 10                	mov    %edx,(%eax)
  freep = p;
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	a3 f0 0b 00 00       	mov    %eax,0xbf0
}
 6d5:	c9                   	leave  
 6d6:	c3                   	ret    

000006d7 <morecore>:

static Header*
morecore(uint nu)
{
 6d7:	55                   	push   %ebp
 6d8:	89 e5                	mov    %esp,%ebp
 6da:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6dd:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6e4:	77 07                	ja     6ed <morecore+0x16>
    nu = 4096;
 6e6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6ed:	8b 45 08             	mov    0x8(%ebp),%eax
 6f0:	c1 e0 03             	shl    $0x3,%eax
 6f3:	89 04 24             	mov    %eax,(%esp)
 6f6:	e8 18 fc ff ff       	call   313 <sbrk>
 6fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6fe:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 702:	75 07                	jne    70b <morecore+0x34>
    return 0;
 704:	b8 00 00 00 00       	mov    $0x0,%eax
 709:	eb 22                	jmp    72d <morecore+0x56>
  hp = (Header*)p;
 70b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 711:	8b 45 f0             	mov    -0x10(%ebp),%eax
 714:	8b 55 08             	mov    0x8(%ebp),%edx
 717:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 71a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71d:	83 c0 08             	add    $0x8,%eax
 720:	89 04 24             	mov    %eax,(%esp)
 723:	e8 ce fe ff ff       	call   5f6 <free>
  return freep;
 728:	a1 f0 0b 00 00       	mov    0xbf0,%eax
}
 72d:	c9                   	leave  
 72e:	c3                   	ret    

0000072f <malloc>:

void*
malloc(uint nbytes)
{
 72f:	55                   	push   %ebp
 730:	89 e5                	mov    %esp,%ebp
 732:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 735:	8b 45 08             	mov    0x8(%ebp),%eax
 738:	83 c0 07             	add    $0x7,%eax
 73b:	c1 e8 03             	shr    $0x3,%eax
 73e:	83 c0 01             	add    $0x1,%eax
 741:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 744:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 749:	89 45 f0             	mov    %eax,-0x10(%ebp)
 74c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 750:	75 23                	jne    775 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 752:	c7 45 f0 e8 0b 00 00 	movl   $0xbe8,-0x10(%ebp)
 759:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75c:	a3 f0 0b 00 00       	mov    %eax,0xbf0
 761:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 766:	a3 e8 0b 00 00       	mov    %eax,0xbe8
    base.s.size = 0;
 76b:	c7 05 ec 0b 00 00 00 	movl   $0x0,0xbec
 772:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 775:	8b 45 f0             	mov    -0x10(%ebp),%eax
 778:	8b 00                	mov    (%eax),%eax
 77a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 77d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 780:	8b 40 04             	mov    0x4(%eax),%eax
 783:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 786:	72 4d                	jb     7d5 <malloc+0xa6>
      if(p->s.size == nunits)
 788:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78b:	8b 40 04             	mov    0x4(%eax),%eax
 78e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 791:	75 0c                	jne    79f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 793:	8b 45 f4             	mov    -0xc(%ebp),%eax
 796:	8b 10                	mov    (%eax),%edx
 798:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79b:	89 10                	mov    %edx,(%eax)
 79d:	eb 26                	jmp    7c5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a2:	8b 40 04             	mov    0x4(%eax),%eax
 7a5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7a8:	89 c2                	mov    %eax,%edx
 7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ad:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b3:	8b 40 04             	mov    0x4(%eax),%eax
 7b6:	c1 e0 03             	shl    $0x3,%eax
 7b9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7c2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c8:	a3 f0 0b 00 00       	mov    %eax,0xbf0
      return (void*)(p + 1);
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	83 c0 08             	add    $0x8,%eax
 7d3:	eb 38                	jmp    80d <malloc+0xde>
    }
    if(p == freep)
 7d5:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 7da:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7dd:	75 1b                	jne    7fa <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7df:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e2:	89 04 24             	mov    %eax,(%esp)
 7e5:	e8 ed fe ff ff       	call   6d7 <morecore>
 7ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f1:	75 07                	jne    7fa <malloc+0xcb>
        return 0;
 7f3:	b8 00 00 00 00       	mov    $0x0,%eax
 7f8:	eb 13                	jmp    80d <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 800:	8b 45 f4             	mov    -0xc(%ebp),%eax
 803:	8b 00                	mov    (%eax),%eax
 805:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 808:	e9 70 ff ff ff       	jmp    77d <malloc+0x4e>
}
 80d:	c9                   	leave  
 80e:	c3                   	ret    

0000080f <thread_create>:
#include"x86.h"
#include"param.h"
#include"proc.h"

int thread_create(thread_t *thread, void*(*start_routine)(void*),void *arg)
{
 80f:	55                   	push   %ebp
 810:	89 e5                	mov    %esp,%ebp
 812:	83 ec 28             	sub    $0x28,%esp
    void *stack = malloc(PGSIZE);
 815:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 81c:	e8 0e ff ff ff       	call   72f <malloc>
 821:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if((uint)stack <=0)
 824:	8b 45 f4             	mov    -0xc(%ebp),%eax
 827:	85 c0                	test   %eax,%eax
 829:	75 1b                	jne    846 <thread_create+0x37>
    {
        printf(1,"malloc thread stack failed\n");
 82b:	c7 44 24 04 0e 09 00 	movl   $0x90e,0x4(%esp)
 832:	00 
 833:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 83a:	e8 04 fc ff ff       	call   443 <printf>
        return -1;
 83f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 844:	eb 67                	jmp    8ad <thread_create+0x9e>
    }
    
    if((uint)stack%PGSIZE)
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	25 ff 0f 00 00       	and    $0xfff,%eax
 84e:	85 c0                	test   %eax,%eax
 850:	74 14                	je     866 <thread_create+0x57>
        stack += PGSIZE-((uint)stack%PGSIZE);
 852:	8b 45 f4             	mov    -0xc(%ebp),%eax
 855:	25 ff 0f 00 00       	and    $0xfff,%eax
 85a:	89 c2                	mov    %eax,%edx
 85c:	b8 00 10 00 00       	mov    $0x1000,%eax
 861:	29 d0                	sub    %edx,%eax
 863:	01 45 f4             	add    %eax,-0xc(%ebp)
    printf(1,"1\n");
 866:	c7 44 24 04 2a 09 00 	movl   $0x92a,0x4(%esp)
 86d:	00 
 86e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 875:	e8 c9 fb ff ff       	call   443 <printf>
    if((*thread = clone(start_routine,arg,stack))<0)
 87a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87d:	89 44 24 08          	mov    %eax,0x8(%esp)
 881:	8b 45 10             	mov    0x10(%ebp),%eax
 884:	89 44 24 04          	mov    %eax,0x4(%esp)
 888:	8b 45 0c             	mov    0xc(%ebp),%eax
 88b:	89 04 24             	mov    %eax,(%esp)
 88e:	e8 b8 fa ff ff       	call   34b <clone>
 893:	8b 55 08             	mov    0x8(%ebp),%edx
 896:	89 02                	mov    %eax,(%edx)
 898:	8b 45 08             	mov    0x8(%ebp),%eax
 89b:	8b 00                	mov    (%eax),%eax
 89d:	85 c0                	test   %eax,%eax
 89f:	79 07                	jns    8a8 <thread_create+0x99>
        return -1;
 8a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8a6:	eb 05                	jmp    8ad <thread_create+0x9e>
    return 0;
 8a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8ad:	c9                   	leave  
 8ae:	c3                   	ret    

000008af <thread_join>:

int thread_join(thread_t thread, void **retval)
{
 8af:	55                   	push   %ebp
 8b0:	89 e5                	mov    %esp,%ebp
 8b2:	83 ec 28             	sub    $0x28,%esp
    void *stack;
    if(join((uint)thread, &stack, retval)<0)
 8b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 8b8:	89 44 24 08          	mov    %eax,0x8(%esp)
 8bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 8bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 8c3:	8b 45 08             	mov    0x8(%ebp),%eax
 8c6:	89 04 24             	mov    %eax,(%esp)
 8c9:	e8 85 fa ff ff       	call   353 <join>
 8ce:	85 c0                	test   %eax,%eax
 8d0:	79 07                	jns    8d9 <thread_join+0x2a>
        return -1;
 8d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8d7:	eb 10                	jmp    8e9 <thread_join+0x3a>

    free(stack);
 8d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dc:	89 04 24             	mov    %eax,(%esp)
 8df:	e8 12 fd ff ff       	call   5f6 <free>
    return 0;
 8e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8e9:	c9                   	leave  
 8ea:	c3                   	ret    

000008eb <thread_exit>:

void thread_exit(void *retval)
{
 8eb:	55                   	push   %ebp
 8ec:	89 e5                	mov    %esp,%ebp
 8ee:	83 ec 08             	sub    $0x8,%esp
    proc->retval = retval;
 8f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 8f7:	8b 55 08             	mov    0x8(%ebp),%edx
 8fa:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
    thexit();
 900:	e8 56 fa ff ff       	call   35b <thexit>
}
 905:	c9                   	leave  
 906:	c3                   	ret    
