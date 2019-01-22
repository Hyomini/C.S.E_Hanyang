
_user_app:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"
#include "stat.h"

int main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
    __asm__("int $128");
   3:	cd 80                	int    $0x80
    return 0;
   5:	b8 00 00 00 00       	mov    $0x0,%eax
}
   a:	5d                   	pop    %ebp
   b:	c3                   	ret    

0000000c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
   c:	55                   	push   %ebp
   d:	89 e5                	mov    %esp,%ebp
   f:	57                   	push   %edi
  10:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  14:	8b 55 10             	mov    0x10(%ebp),%edx
  17:	8b 45 0c             	mov    0xc(%ebp),%eax
  1a:	89 cb                	mov    %ecx,%ebx
  1c:	89 df                	mov    %ebx,%edi
  1e:	89 d1                	mov    %edx,%ecx
  20:	fc                   	cld    
  21:	f3 aa                	rep stos %al,%es:(%edi)
  23:	89 ca                	mov    %ecx,%edx
  25:	89 fb                	mov    %edi,%ebx
  27:	89 5d 08             	mov    %ebx,0x8(%ebp)
  2a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  2d:	5b                   	pop    %ebx
  2e:	5f                   	pop    %edi
  2f:	5d                   	pop    %ebp
  30:	c3                   	ret    

00000031 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  31:	55                   	push   %ebp
  32:	89 e5                	mov    %esp,%ebp
  34:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  37:	8b 45 08             	mov    0x8(%ebp),%eax
  3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  3d:	90                   	nop
  3e:	8b 45 08             	mov    0x8(%ebp),%eax
  41:	8d 50 01             	lea    0x1(%eax),%edx
  44:	89 55 08             	mov    %edx,0x8(%ebp)
  47:	8b 55 0c             	mov    0xc(%ebp),%edx
  4a:	8d 4a 01             	lea    0x1(%edx),%ecx
  4d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  50:	0f b6 12             	movzbl (%edx),%edx
  53:	88 10                	mov    %dl,(%eax)
  55:	0f b6 00             	movzbl (%eax),%eax
  58:	84 c0                	test   %al,%al
  5a:	75 e2                	jne    3e <strcpy+0xd>
    ;
  return os;
  5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  5f:	c9                   	leave  
  60:	c3                   	ret    

00000061 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  61:	55                   	push   %ebp
  62:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  64:	eb 08                	jmp    6e <strcmp+0xd>
    p++, q++;
  66:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  6a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  6e:	8b 45 08             	mov    0x8(%ebp),%eax
  71:	0f b6 00             	movzbl (%eax),%eax
  74:	84 c0                	test   %al,%al
  76:	74 10                	je     88 <strcmp+0x27>
  78:	8b 45 08             	mov    0x8(%ebp),%eax
  7b:	0f b6 10             	movzbl (%eax),%edx
  7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  81:	0f b6 00             	movzbl (%eax),%eax
  84:	38 c2                	cmp    %al,%dl
  86:	74 de                	je     66 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  88:	8b 45 08             	mov    0x8(%ebp),%eax
  8b:	0f b6 00             	movzbl (%eax),%eax
  8e:	0f b6 d0             	movzbl %al,%edx
  91:	8b 45 0c             	mov    0xc(%ebp),%eax
  94:	0f b6 00             	movzbl (%eax),%eax
  97:	0f b6 c0             	movzbl %al,%eax
  9a:	29 c2                	sub    %eax,%edx
  9c:	89 d0                	mov    %edx,%eax
}
  9e:	5d                   	pop    %ebp
  9f:	c3                   	ret    

000000a0 <strlen>:

uint
strlen(char *s)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ad:	eb 04                	jmp    b3 <strlen+0x13>
  af:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  b6:	8b 45 08             	mov    0x8(%ebp),%eax
  b9:	01 d0                	add    %edx,%eax
  bb:	0f b6 00             	movzbl (%eax),%eax
  be:	84 c0                	test   %al,%al
  c0:	75 ed                	jne    af <strlen+0xf>
    ;
  return n;
  c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c5:	c9                   	leave  
  c6:	c3                   	ret    

000000c7 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c7:	55                   	push   %ebp
  c8:	89 e5                	mov    %esp,%ebp
  ca:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  cd:	8b 45 10             	mov    0x10(%ebp),%eax
  d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  db:	8b 45 08             	mov    0x8(%ebp),%eax
  de:	89 04 24             	mov    %eax,(%esp)
  e1:	e8 26 ff ff ff       	call   c <stosb>
  return dst;
  e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  e9:	c9                   	leave  
  ea:	c3                   	ret    

000000eb <strchr>:

char*
strchr(const char *s, char c)
{
  eb:	55                   	push   %ebp
  ec:	89 e5                	mov    %esp,%ebp
  ee:	83 ec 04             	sub    $0x4,%esp
  f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  f4:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
  f7:	eb 14                	jmp    10d <strchr+0x22>
    if(*s == c)
  f9:	8b 45 08             	mov    0x8(%ebp),%eax
  fc:	0f b6 00             	movzbl (%eax),%eax
  ff:	3a 45 fc             	cmp    -0x4(%ebp),%al
 102:	75 05                	jne    109 <strchr+0x1e>
      return (char*)s;
 104:	8b 45 08             	mov    0x8(%ebp),%eax
 107:	eb 13                	jmp    11c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 109:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 10d:	8b 45 08             	mov    0x8(%ebp),%eax
 110:	0f b6 00             	movzbl (%eax),%eax
 113:	84 c0                	test   %al,%al
 115:	75 e2                	jne    f9 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 117:	b8 00 00 00 00       	mov    $0x0,%eax
}
 11c:	c9                   	leave  
 11d:	c3                   	ret    

0000011e <gets>:

char*
gets(char *buf, int max)
{
 11e:	55                   	push   %ebp
 11f:	89 e5                	mov    %esp,%ebp
 121:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 124:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 12b:	eb 4c                	jmp    179 <gets+0x5b>
    cc = read(0, &c, 1);
 12d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 134:	00 
 135:	8d 45 ef             	lea    -0x11(%ebp),%eax
 138:	89 44 24 04          	mov    %eax,0x4(%esp)
 13c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 143:	e8 44 01 00 00       	call   28c <read>
 148:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 14b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 14f:	7f 02                	jg     153 <gets+0x35>
      break;
 151:	eb 31                	jmp    184 <gets+0x66>
    buf[i++] = c;
 153:	8b 45 f4             	mov    -0xc(%ebp),%eax
 156:	8d 50 01             	lea    0x1(%eax),%edx
 159:	89 55 f4             	mov    %edx,-0xc(%ebp)
 15c:	89 c2                	mov    %eax,%edx
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	01 c2                	add    %eax,%edx
 163:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 167:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 169:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 16d:	3c 0a                	cmp    $0xa,%al
 16f:	74 13                	je     184 <gets+0x66>
 171:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 175:	3c 0d                	cmp    $0xd,%al
 177:	74 0b                	je     184 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 179:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17c:	83 c0 01             	add    $0x1,%eax
 17f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 182:	7c a9                	jl     12d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 184:	8b 55 f4             	mov    -0xc(%ebp),%edx
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	01 d0                	add    %edx,%eax
 18c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 18f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 192:	c9                   	leave  
 193:	c3                   	ret    

00000194 <stat>:

int
stat(char *n, struct stat *st)
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1a1:	00 
 1a2:	8b 45 08             	mov    0x8(%ebp),%eax
 1a5:	89 04 24             	mov    %eax,(%esp)
 1a8:	e8 07 01 00 00       	call   2b4 <open>
 1ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b4:	79 07                	jns    1bd <stat+0x29>
    return -1;
 1b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1bb:	eb 23                	jmp    1e0 <stat+0x4c>
  r = fstat(fd, st);
 1bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c7:	89 04 24             	mov    %eax,(%esp)
 1ca:	e8 fd 00 00 00       	call   2cc <fstat>
 1cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d5:	89 04 24             	mov    %eax,(%esp)
 1d8:	e8 bf 00 00 00       	call   29c <close>
  return r;
 1dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e0:	c9                   	leave  
 1e1:	c3                   	ret    

000001e2 <atoi>:

int
atoi(const char *s)
{
 1e2:	55                   	push   %ebp
 1e3:	89 e5                	mov    %esp,%ebp
 1e5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1ef:	eb 25                	jmp    216 <atoi+0x34>
    n = n*10 + *s++ - '0';
 1f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f4:	89 d0                	mov    %edx,%eax
 1f6:	c1 e0 02             	shl    $0x2,%eax
 1f9:	01 d0                	add    %edx,%eax
 1fb:	01 c0                	add    %eax,%eax
 1fd:	89 c1                	mov    %eax,%ecx
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	8d 50 01             	lea    0x1(%eax),%edx
 205:	89 55 08             	mov    %edx,0x8(%ebp)
 208:	0f b6 00             	movzbl (%eax),%eax
 20b:	0f be c0             	movsbl %al,%eax
 20e:	01 c8                	add    %ecx,%eax
 210:	83 e8 30             	sub    $0x30,%eax
 213:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	0f b6 00             	movzbl (%eax),%eax
 21c:	3c 2f                	cmp    $0x2f,%al
 21e:	7e 0a                	jle    22a <atoi+0x48>
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	3c 39                	cmp    $0x39,%al
 228:	7e c7                	jle    1f1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 22a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 22d:	c9                   	leave  
 22e:	c3                   	ret    

0000022f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 235:	8b 45 08             	mov    0x8(%ebp),%eax
 238:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 23b:	8b 45 0c             	mov    0xc(%ebp),%eax
 23e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 241:	eb 17                	jmp    25a <memmove+0x2b>
    *dst++ = *src++;
 243:	8b 45 fc             	mov    -0x4(%ebp),%eax
 246:	8d 50 01             	lea    0x1(%eax),%edx
 249:	89 55 fc             	mov    %edx,-0x4(%ebp)
 24c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 24f:	8d 4a 01             	lea    0x1(%edx),%ecx
 252:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 255:	0f b6 12             	movzbl (%edx),%edx
 258:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 25a:	8b 45 10             	mov    0x10(%ebp),%eax
 25d:	8d 50 ff             	lea    -0x1(%eax),%edx
 260:	89 55 10             	mov    %edx,0x10(%ebp)
 263:	85 c0                	test   %eax,%eax
 265:	7f dc                	jg     243 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 267:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26a:	c9                   	leave  
 26b:	c3                   	ret    

0000026c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 26c:	b8 01 00 00 00       	mov    $0x1,%eax
 271:	cd 40                	int    $0x40
 273:	c3                   	ret    

00000274 <exit>:
SYSCALL(exit)
 274:	b8 02 00 00 00       	mov    $0x2,%eax
 279:	cd 40                	int    $0x40
 27b:	c3                   	ret    

0000027c <wait>:
SYSCALL(wait)
 27c:	b8 03 00 00 00       	mov    $0x3,%eax
 281:	cd 40                	int    $0x40
 283:	c3                   	ret    

00000284 <pipe>:
SYSCALL(pipe)
 284:	b8 04 00 00 00       	mov    $0x4,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <read>:
SYSCALL(read)
 28c:	b8 05 00 00 00       	mov    $0x5,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <write>:
SYSCALL(write)
 294:	b8 10 00 00 00       	mov    $0x10,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <close>:
SYSCALL(close)
 29c:	b8 15 00 00 00       	mov    $0x15,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <kill>:
SYSCALL(kill)
 2a4:	b8 06 00 00 00       	mov    $0x6,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <exec>:
SYSCALL(exec)
 2ac:	b8 07 00 00 00       	mov    $0x7,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <open>:
SYSCALL(open)
 2b4:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <mknod>:
SYSCALL(mknod)
 2bc:	b8 11 00 00 00       	mov    $0x11,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <unlink>:
SYSCALL(unlink)
 2c4:	b8 12 00 00 00       	mov    $0x12,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <fstat>:
SYSCALL(fstat)
 2cc:	b8 08 00 00 00       	mov    $0x8,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <link>:
SYSCALL(link)
 2d4:	b8 13 00 00 00       	mov    $0x13,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <mkdir>:
SYSCALL(mkdir)
 2dc:	b8 14 00 00 00       	mov    $0x14,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <chdir>:
SYSCALL(chdir)
 2e4:	b8 09 00 00 00       	mov    $0x9,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <dup>:
SYSCALL(dup)
 2ec:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <getpid>:
SYSCALL(getpid)
 2f4:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <sbrk>:
SYSCALL(sbrk)
 2fc:	b8 0c 00 00 00       	mov    $0xc,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <sleep>:
SYSCALL(sleep)
 304:	b8 0d 00 00 00       	mov    $0xd,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <uptime>:
SYSCALL(uptime)
 30c:	b8 0e 00 00 00       	mov    $0xe,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <my_syscall>:
SYSCALL(my_syscall)
 314:	b8 16 00 00 00       	mov    $0x16,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <getppid>:
SYSCALL(getppid)
 31c:	b8 17 00 00 00       	mov    $0x17,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <yield>:
SYSCALL(yield)
 324:	b8 18 00 00 00       	mov    $0x18,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <getlev>:
SYSCALL(getlev)
 32c:	b8 19 00 00 00       	mov    $0x19,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <clone>:
SYSCALL(clone)
 334:	b8 1a 00 00 00       	mov    $0x1a,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <join>:
SYSCALL(join)
 33c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <thexit>:
SYSCALL(thexit)
 344:	b8 1c 00 00 00       	mov    $0x1c,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 34c:	55                   	push   %ebp
 34d:	89 e5                	mov    %esp,%ebp
 34f:	83 ec 18             	sub    $0x18,%esp
 352:	8b 45 0c             	mov    0xc(%ebp),%eax
 355:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 358:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 35f:	00 
 360:	8d 45 f4             	lea    -0xc(%ebp),%eax
 363:	89 44 24 04          	mov    %eax,0x4(%esp)
 367:	8b 45 08             	mov    0x8(%ebp),%eax
 36a:	89 04 24             	mov    %eax,(%esp)
 36d:	e8 22 ff ff ff       	call   294 <write>
}
 372:	c9                   	leave  
 373:	c3                   	ret    

00000374 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	56                   	push   %esi
 378:	53                   	push   %ebx
 379:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 37c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 383:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 387:	74 17                	je     3a0 <printint+0x2c>
 389:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 38d:	79 11                	jns    3a0 <printint+0x2c>
    neg = 1;
 38f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 396:	8b 45 0c             	mov    0xc(%ebp),%eax
 399:	f7 d8                	neg    %eax
 39b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 39e:	eb 06                	jmp    3a6 <printint+0x32>
  } else {
    x = xx;
 3a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3ad:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3b0:	8d 41 01             	lea    0x1(%ecx),%eax
 3b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3bc:	ba 00 00 00 00       	mov    $0x0,%edx
 3c1:	f7 f3                	div    %ebx
 3c3:	89 d0                	mov    %edx,%eax
 3c5:	0f b6 80 c0 0b 00 00 	movzbl 0xbc0(%eax),%eax
 3cc:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3d0:	8b 75 10             	mov    0x10(%ebp),%esi
 3d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d6:	ba 00 00 00 00       	mov    $0x0,%edx
 3db:	f7 f6                	div    %esi
 3dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3e4:	75 c7                	jne    3ad <printint+0x39>
  if(neg)
 3e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3ea:	74 10                	je     3fc <printint+0x88>
    buf[i++] = '-';
 3ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ef:	8d 50 01             	lea    0x1(%eax),%edx
 3f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3f5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3fa:	eb 1f                	jmp    41b <printint+0xa7>
 3fc:	eb 1d                	jmp    41b <printint+0xa7>
    putc(fd, buf[i]);
 3fe:	8d 55 dc             	lea    -0x24(%ebp),%edx
 401:	8b 45 f4             	mov    -0xc(%ebp),%eax
 404:	01 d0                	add    %edx,%eax
 406:	0f b6 00             	movzbl (%eax),%eax
 409:	0f be c0             	movsbl %al,%eax
 40c:	89 44 24 04          	mov    %eax,0x4(%esp)
 410:	8b 45 08             	mov    0x8(%ebp),%eax
 413:	89 04 24             	mov    %eax,(%esp)
 416:	e8 31 ff ff ff       	call   34c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 41b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 41f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 423:	79 d9                	jns    3fe <printint+0x8a>
    putc(fd, buf[i]);
}
 425:	83 c4 30             	add    $0x30,%esp
 428:	5b                   	pop    %ebx
 429:	5e                   	pop    %esi
 42a:	5d                   	pop    %ebp
 42b:	c3                   	ret    

0000042c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 42c:	55                   	push   %ebp
 42d:	89 e5                	mov    %esp,%ebp
 42f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 432:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 439:	8d 45 0c             	lea    0xc(%ebp),%eax
 43c:	83 c0 04             	add    $0x4,%eax
 43f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 442:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 449:	e9 7c 01 00 00       	jmp    5ca <printf+0x19e>
    c = fmt[i] & 0xff;
 44e:	8b 55 0c             	mov    0xc(%ebp),%edx
 451:	8b 45 f0             	mov    -0x10(%ebp),%eax
 454:	01 d0                	add    %edx,%eax
 456:	0f b6 00             	movzbl (%eax),%eax
 459:	0f be c0             	movsbl %al,%eax
 45c:	25 ff 00 00 00       	and    $0xff,%eax
 461:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 464:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 468:	75 2c                	jne    496 <printf+0x6a>
      if(c == '%'){
 46a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 46e:	75 0c                	jne    47c <printf+0x50>
        state = '%';
 470:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 477:	e9 4a 01 00 00       	jmp    5c6 <printf+0x19a>
      } else {
        putc(fd, c);
 47c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 47f:	0f be c0             	movsbl %al,%eax
 482:	89 44 24 04          	mov    %eax,0x4(%esp)
 486:	8b 45 08             	mov    0x8(%ebp),%eax
 489:	89 04 24             	mov    %eax,(%esp)
 48c:	e8 bb fe ff ff       	call   34c <putc>
 491:	e9 30 01 00 00       	jmp    5c6 <printf+0x19a>
      }
    } else if(state == '%'){
 496:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 49a:	0f 85 26 01 00 00    	jne    5c6 <printf+0x19a>
      if(c == 'd'){
 4a0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4a4:	75 2d                	jne    4d3 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4a9:	8b 00                	mov    (%eax),%eax
 4ab:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4b2:	00 
 4b3:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4ba:	00 
 4bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bf:	8b 45 08             	mov    0x8(%ebp),%eax
 4c2:	89 04 24             	mov    %eax,(%esp)
 4c5:	e8 aa fe ff ff       	call   374 <printint>
        ap++;
 4ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ce:	e9 ec 00 00 00       	jmp    5bf <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 4d3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4d7:	74 06                	je     4df <printf+0xb3>
 4d9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4dd:	75 2d                	jne    50c <printf+0xe0>
        printint(fd, *ap, 16, 0);
 4df:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e2:	8b 00                	mov    (%eax),%eax
 4e4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4eb:	00 
 4ec:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4f3:	00 
 4f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f8:	8b 45 08             	mov    0x8(%ebp),%eax
 4fb:	89 04 24             	mov    %eax,(%esp)
 4fe:	e8 71 fe ff ff       	call   374 <printint>
        ap++;
 503:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 507:	e9 b3 00 00 00       	jmp    5bf <printf+0x193>
      } else if(c == 's'){
 50c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 510:	75 45                	jne    557 <printf+0x12b>
        s = (char*)*ap;
 512:	8b 45 e8             	mov    -0x18(%ebp),%eax
 515:	8b 00                	mov    (%eax),%eax
 517:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 51a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 51e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 522:	75 09                	jne    52d <printf+0x101>
          s = "(null)";
 524:	c7 45 f4 f0 08 00 00 	movl   $0x8f0,-0xc(%ebp)
        while(*s != 0){
 52b:	eb 1e                	jmp    54b <printf+0x11f>
 52d:	eb 1c                	jmp    54b <printf+0x11f>
          putc(fd, *s);
 52f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 532:	0f b6 00             	movzbl (%eax),%eax
 535:	0f be c0             	movsbl %al,%eax
 538:	89 44 24 04          	mov    %eax,0x4(%esp)
 53c:	8b 45 08             	mov    0x8(%ebp),%eax
 53f:	89 04 24             	mov    %eax,(%esp)
 542:	e8 05 fe ff ff       	call   34c <putc>
          s++;
 547:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 54b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54e:	0f b6 00             	movzbl (%eax),%eax
 551:	84 c0                	test   %al,%al
 553:	75 da                	jne    52f <printf+0x103>
 555:	eb 68                	jmp    5bf <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 557:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 55b:	75 1d                	jne    57a <printf+0x14e>
        putc(fd, *ap);
 55d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 560:	8b 00                	mov    (%eax),%eax
 562:	0f be c0             	movsbl %al,%eax
 565:	89 44 24 04          	mov    %eax,0x4(%esp)
 569:	8b 45 08             	mov    0x8(%ebp),%eax
 56c:	89 04 24             	mov    %eax,(%esp)
 56f:	e8 d8 fd ff ff       	call   34c <putc>
        ap++;
 574:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 578:	eb 45                	jmp    5bf <printf+0x193>
      } else if(c == '%'){
 57a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 57e:	75 17                	jne    597 <printf+0x16b>
        putc(fd, c);
 580:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 583:	0f be c0             	movsbl %al,%eax
 586:	89 44 24 04          	mov    %eax,0x4(%esp)
 58a:	8b 45 08             	mov    0x8(%ebp),%eax
 58d:	89 04 24             	mov    %eax,(%esp)
 590:	e8 b7 fd ff ff       	call   34c <putc>
 595:	eb 28                	jmp    5bf <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 597:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 59e:	00 
 59f:	8b 45 08             	mov    0x8(%ebp),%eax
 5a2:	89 04 24             	mov    %eax,(%esp)
 5a5:	e8 a2 fd ff ff       	call   34c <putc>
        putc(fd, c);
 5aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ad:	0f be c0             	movsbl %al,%eax
 5b0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b4:	8b 45 08             	mov    0x8(%ebp),%eax
 5b7:	89 04 24             	mov    %eax,(%esp)
 5ba:	e8 8d fd ff ff       	call   34c <putc>
      }
      state = 0;
 5bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5c6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5ca:	8b 55 0c             	mov    0xc(%ebp),%edx
 5cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d0:	01 d0                	add    %edx,%eax
 5d2:	0f b6 00             	movzbl (%eax),%eax
 5d5:	84 c0                	test   %al,%al
 5d7:	0f 85 71 fe ff ff    	jne    44e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5dd:	c9                   	leave  
 5de:	c3                   	ret    

000005df <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5df:	55                   	push   %ebp
 5e0:	89 e5                	mov    %esp,%ebp
 5e2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5e5:	8b 45 08             	mov    0x8(%ebp),%eax
 5e8:	83 e8 08             	sub    $0x8,%eax
 5eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ee:	a1 dc 0b 00 00       	mov    0xbdc,%eax
 5f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5f6:	eb 24                	jmp    61c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fb:	8b 00                	mov    (%eax),%eax
 5fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 600:	77 12                	ja     614 <free+0x35>
 602:	8b 45 f8             	mov    -0x8(%ebp),%eax
 605:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 608:	77 24                	ja     62e <free+0x4f>
 60a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60d:	8b 00                	mov    (%eax),%eax
 60f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 612:	77 1a                	ja     62e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 614:	8b 45 fc             	mov    -0x4(%ebp),%eax
 617:	8b 00                	mov    (%eax),%eax
 619:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 622:	76 d4                	jbe    5f8 <free+0x19>
 624:	8b 45 fc             	mov    -0x4(%ebp),%eax
 627:	8b 00                	mov    (%eax),%eax
 629:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 62c:	76 ca                	jbe    5f8 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 62e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 631:	8b 40 04             	mov    0x4(%eax),%eax
 634:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 63b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63e:	01 c2                	add    %eax,%edx
 640:	8b 45 fc             	mov    -0x4(%ebp),%eax
 643:	8b 00                	mov    (%eax),%eax
 645:	39 c2                	cmp    %eax,%edx
 647:	75 24                	jne    66d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 649:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64c:	8b 50 04             	mov    0x4(%eax),%edx
 64f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 652:	8b 00                	mov    (%eax),%eax
 654:	8b 40 04             	mov    0x4(%eax),%eax
 657:	01 c2                	add    %eax,%edx
 659:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 65f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 662:	8b 00                	mov    (%eax),%eax
 664:	8b 10                	mov    (%eax),%edx
 666:	8b 45 f8             	mov    -0x8(%ebp),%eax
 669:	89 10                	mov    %edx,(%eax)
 66b:	eb 0a                	jmp    677 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	8b 10                	mov    (%eax),%edx
 672:	8b 45 f8             	mov    -0x8(%ebp),%eax
 675:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	8b 40 04             	mov    0x4(%eax),%eax
 67d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	01 d0                	add    %edx,%eax
 689:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68c:	75 20                	jne    6ae <free+0xcf>
    p->s.size += bp->s.size;
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	8b 50 04             	mov    0x4(%eax),%edx
 694:	8b 45 f8             	mov    -0x8(%ebp),%eax
 697:	8b 40 04             	mov    0x4(%eax),%eax
 69a:	01 c2                	add    %eax,%edx
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a5:	8b 10                	mov    (%eax),%edx
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	89 10                	mov    %edx,(%eax)
 6ac:	eb 08                	jmp    6b6 <free+0xd7>
  } else
    p->s.ptr = bp;
 6ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6b4:	89 10                	mov    %edx,(%eax)
  freep = p;
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	a3 dc 0b 00 00       	mov    %eax,0xbdc
}
 6be:	c9                   	leave  
 6bf:	c3                   	ret    

000006c0 <morecore>:

static Header*
morecore(uint nu)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6c6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6cd:	77 07                	ja     6d6 <morecore+0x16>
    nu = 4096;
 6cf:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6d6:	8b 45 08             	mov    0x8(%ebp),%eax
 6d9:	c1 e0 03             	shl    $0x3,%eax
 6dc:	89 04 24             	mov    %eax,(%esp)
 6df:	e8 18 fc ff ff       	call   2fc <sbrk>
 6e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6e7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6eb:	75 07                	jne    6f4 <morecore+0x34>
    return 0;
 6ed:	b8 00 00 00 00       	mov    $0x0,%eax
 6f2:	eb 22                	jmp    716 <morecore+0x56>
  hp = (Header*)p;
 6f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fd:	8b 55 08             	mov    0x8(%ebp),%edx
 700:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 703:	8b 45 f0             	mov    -0x10(%ebp),%eax
 706:	83 c0 08             	add    $0x8,%eax
 709:	89 04 24             	mov    %eax,(%esp)
 70c:	e8 ce fe ff ff       	call   5df <free>
  return freep;
 711:	a1 dc 0b 00 00       	mov    0xbdc,%eax
}
 716:	c9                   	leave  
 717:	c3                   	ret    

00000718 <malloc>:

void*
malloc(uint nbytes)
{
 718:	55                   	push   %ebp
 719:	89 e5                	mov    %esp,%ebp
 71b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71e:	8b 45 08             	mov    0x8(%ebp),%eax
 721:	83 c0 07             	add    $0x7,%eax
 724:	c1 e8 03             	shr    $0x3,%eax
 727:	83 c0 01             	add    $0x1,%eax
 72a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 72d:	a1 dc 0b 00 00       	mov    0xbdc,%eax
 732:	89 45 f0             	mov    %eax,-0x10(%ebp)
 735:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 739:	75 23                	jne    75e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 73b:	c7 45 f0 d4 0b 00 00 	movl   $0xbd4,-0x10(%ebp)
 742:	8b 45 f0             	mov    -0x10(%ebp),%eax
 745:	a3 dc 0b 00 00       	mov    %eax,0xbdc
 74a:	a1 dc 0b 00 00       	mov    0xbdc,%eax
 74f:	a3 d4 0b 00 00       	mov    %eax,0xbd4
    base.s.size = 0;
 754:	c7 05 d8 0b 00 00 00 	movl   $0x0,0xbd8
 75b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 761:	8b 00                	mov    (%eax),%eax
 763:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 766:	8b 45 f4             	mov    -0xc(%ebp),%eax
 769:	8b 40 04             	mov    0x4(%eax),%eax
 76c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 76f:	72 4d                	jb     7be <malloc+0xa6>
      if(p->s.size == nunits)
 771:	8b 45 f4             	mov    -0xc(%ebp),%eax
 774:	8b 40 04             	mov    0x4(%eax),%eax
 777:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 77a:	75 0c                	jne    788 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 77c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77f:	8b 10                	mov    (%eax),%edx
 781:	8b 45 f0             	mov    -0x10(%ebp),%eax
 784:	89 10                	mov    %edx,(%eax)
 786:	eb 26                	jmp    7ae <malloc+0x96>
      else {
        p->s.size -= nunits;
 788:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78b:	8b 40 04             	mov    0x4(%eax),%eax
 78e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 791:	89 c2                	mov    %eax,%edx
 793:	8b 45 f4             	mov    -0xc(%ebp),%eax
 796:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 799:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79c:	8b 40 04             	mov    0x4(%eax),%eax
 79f:	c1 e0 03             	shl    $0x3,%eax
 7a2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ab:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b1:	a3 dc 0b 00 00       	mov    %eax,0xbdc
      return (void*)(p + 1);
 7b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b9:	83 c0 08             	add    $0x8,%eax
 7bc:	eb 38                	jmp    7f6 <malloc+0xde>
    }
    if(p == freep)
 7be:	a1 dc 0b 00 00       	mov    0xbdc,%eax
 7c3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7c6:	75 1b                	jne    7e3 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7cb:	89 04 24             	mov    %eax,(%esp)
 7ce:	e8 ed fe ff ff       	call   6c0 <morecore>
 7d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7da:	75 07                	jne    7e3 <malloc+0xcb>
        return 0;
 7dc:	b8 00 00 00 00       	mov    $0x0,%eax
 7e1:	eb 13                	jmp    7f6 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ec:	8b 00                	mov    (%eax),%eax
 7ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7f1:	e9 70 ff ff ff       	jmp    766 <malloc+0x4e>
}
 7f6:	c9                   	leave  
 7f7:	c3                   	ret    

000007f8 <thread_create>:
#include"x86.h"
#include"param.h"
#include"proc.h"

int thread_create(thread_t *thread, void*(*start_routine)(void*),void *arg)
{
 7f8:	55                   	push   %ebp
 7f9:	89 e5                	mov    %esp,%ebp
 7fb:	83 ec 28             	sub    $0x28,%esp
    void *stack = malloc(PGSIZE);
 7fe:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 805:	e8 0e ff ff ff       	call   718 <malloc>
 80a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if((uint)stack <=0)
 80d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 810:	85 c0                	test   %eax,%eax
 812:	75 1b                	jne    82f <thread_create+0x37>
    {
        printf(1,"malloc thread stack failed\n");
 814:	c7 44 24 04 f7 08 00 	movl   $0x8f7,0x4(%esp)
 81b:	00 
 81c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 823:	e8 04 fc ff ff       	call   42c <printf>
        return -1;
 828:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 82d:	eb 67                	jmp    896 <thread_create+0x9e>
    }
    
    if((uint)stack%PGSIZE)
 82f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 832:	25 ff 0f 00 00       	and    $0xfff,%eax
 837:	85 c0                	test   %eax,%eax
 839:	74 14                	je     84f <thread_create+0x57>
        stack += PGSIZE-((uint)stack%PGSIZE);
 83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83e:	25 ff 0f 00 00       	and    $0xfff,%eax
 843:	89 c2                	mov    %eax,%edx
 845:	b8 00 10 00 00       	mov    $0x1000,%eax
 84a:	29 d0                	sub    %edx,%eax
 84c:	01 45 f4             	add    %eax,-0xc(%ebp)
    printf(1,"1\n");
 84f:	c7 44 24 04 13 09 00 	movl   $0x913,0x4(%esp)
 856:	00 
 857:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 85e:	e8 c9 fb ff ff       	call   42c <printf>
    if((*thread = clone(start_routine,arg,stack))<0)
 863:	8b 45 f4             	mov    -0xc(%ebp),%eax
 866:	89 44 24 08          	mov    %eax,0x8(%esp)
 86a:	8b 45 10             	mov    0x10(%ebp),%eax
 86d:	89 44 24 04          	mov    %eax,0x4(%esp)
 871:	8b 45 0c             	mov    0xc(%ebp),%eax
 874:	89 04 24             	mov    %eax,(%esp)
 877:	e8 b8 fa ff ff       	call   334 <clone>
 87c:	8b 55 08             	mov    0x8(%ebp),%edx
 87f:	89 02                	mov    %eax,(%edx)
 881:	8b 45 08             	mov    0x8(%ebp),%eax
 884:	8b 00                	mov    (%eax),%eax
 886:	85 c0                	test   %eax,%eax
 888:	79 07                	jns    891 <thread_create+0x99>
        return -1;
 88a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 88f:	eb 05                	jmp    896 <thread_create+0x9e>
    return 0;
 891:	b8 00 00 00 00       	mov    $0x0,%eax
}
 896:	c9                   	leave  
 897:	c3                   	ret    

00000898 <thread_join>:

int thread_join(thread_t thread, void **retval)
{
 898:	55                   	push   %ebp
 899:	89 e5                	mov    %esp,%ebp
 89b:	83 ec 28             	sub    $0x28,%esp
    void *stack;
    if(join((uint)thread, &stack, retval)<0)
 89e:	8b 45 0c             	mov    0xc(%ebp),%eax
 8a1:	89 44 24 08          	mov    %eax,0x8(%esp)
 8a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 8a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ac:	8b 45 08             	mov    0x8(%ebp),%eax
 8af:	89 04 24             	mov    %eax,(%esp)
 8b2:	e8 85 fa ff ff       	call   33c <join>
 8b7:	85 c0                	test   %eax,%eax
 8b9:	79 07                	jns    8c2 <thread_join+0x2a>
        return -1;
 8bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8c0:	eb 10                	jmp    8d2 <thread_join+0x3a>

    free(stack);
 8c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c5:	89 04 24             	mov    %eax,(%esp)
 8c8:	e8 12 fd ff ff       	call   5df <free>
    return 0;
 8cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8d2:	c9                   	leave  
 8d3:	c3                   	ret    

000008d4 <thread_exit>:

void thread_exit(void *retval)
{
 8d4:	55                   	push   %ebp
 8d5:	89 e5                	mov    %esp,%ebp
 8d7:	83 ec 08             	sub    $0x8,%esp
    proc->retval = retval;
 8da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 8e0:	8b 55 08             	mov    0x8(%ebp),%edx
 8e3:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
    thexit();
 8e9:	e8 56 fa ff ff       	call   344 <thexit>
}
 8ee:	c9                   	leave  
 8ef:	c3                   	ret    
