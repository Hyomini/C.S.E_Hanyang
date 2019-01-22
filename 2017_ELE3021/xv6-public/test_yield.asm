
_test_yield:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main()
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
   int pid;
    int count = 0;
   9:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  10:	00 

    pid = fork();
  11:	e8 f0 02 00 00       	call   306 <fork>
  16:	89 44 24 18          	mov    %eax,0x18(%esp)

    while(count++ < 100){
  1a:	eb 70                	jmp    8c <main+0x8c>
        if( pid == 0){
  1c:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  21:	75 23                	jne    46 <main+0x46>
            write(1,"Child\n",6);
  23:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 8a 09 00 	movl   $0x98a,0x4(%esp)
  32:	00 
  33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3a:	e8 ef 02 00 00       	call   32e <write>
            yield();
  3f:	e8 7a 03 00 00       	call   3be <yield>
  44:	eb 46                	jmp    8c <main+0x8c>

        }
        else if(pid > 0){
  46:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  4b:	7e 23                	jle    70 <main+0x70>
            write(1,"Parent\n",7);
  4d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  54:	00 
  55:	c7 44 24 04 91 09 00 	movl   $0x991,0x4(%esp)
  5c:	00 
  5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  64:	e8 c5 02 00 00       	call   32e <write>
            yield();
  69:	e8 50 03 00 00       	call   3be <yield>
  6e:	eb 1c                	jmp    8c <main+0x8c>
        }
        else
            write(1,"fork error\n",11);
  70:	c7 44 24 08 0b 00 00 	movl   $0xb,0x8(%esp)
  77:	00 
  78:	c7 44 24 04 99 09 00 	movl   $0x999,0x4(%esp)
  7f:	00 
  80:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  87:	e8 a2 02 00 00       	call   32e <write>
   int pid;
    int count = 0;

    pid = fork();

    while(count++ < 100){
  8c:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  90:	8d 50 01             	lea    0x1(%eax),%edx
  93:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  97:	83 f8 63             	cmp    $0x63,%eax
  9a:	7e 80                	jle    1c <main+0x1c>
            yield();
        }
        else
            write(1,"fork error\n",11);
    }
    wait();
  9c:	e8 75 02 00 00       	call   316 <wait>
    exit();
  a1:	e8 68 02 00 00       	call   30e <exit>

000000a6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  a6:	55                   	push   %ebp
  a7:	89 e5                	mov    %esp,%ebp
  a9:	57                   	push   %edi
  aa:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ae:	8b 55 10             	mov    0x10(%ebp),%edx
  b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  b4:	89 cb                	mov    %ecx,%ebx
  b6:	89 df                	mov    %ebx,%edi
  b8:	89 d1                	mov    %edx,%ecx
  ba:	fc                   	cld    
  bb:	f3 aa                	rep stos %al,%es:(%edi)
  bd:	89 ca                	mov    %ecx,%edx
  bf:	89 fb                	mov    %edi,%ebx
  c1:	89 5d 08             	mov    %ebx,0x8(%ebp)
  c4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  c7:	5b                   	pop    %ebx
  c8:	5f                   	pop    %edi
  c9:	5d                   	pop    %ebp
  ca:	c3                   	ret    

000000cb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  cb:	55                   	push   %ebp
  cc:	89 e5                	mov    %esp,%ebp
  ce:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  d1:	8b 45 08             	mov    0x8(%ebp),%eax
  d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  d7:	90                   	nop
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	8d 50 01             	lea    0x1(%eax),%edx
  de:	89 55 08             	mov    %edx,0x8(%ebp)
  e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  e4:	8d 4a 01             	lea    0x1(%edx),%ecx
  e7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ea:	0f b6 12             	movzbl (%edx),%edx
  ed:	88 10                	mov    %dl,(%eax)
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	84 c0                	test   %al,%al
  f4:	75 e2                	jne    d8 <strcpy+0xd>
    ;
  return os;
  f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  f9:	c9                   	leave  
  fa:	c3                   	ret    

000000fb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fb:	55                   	push   %ebp
  fc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  fe:	eb 08                	jmp    108 <strcmp+0xd>
    p++, q++;
 100:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 104:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 108:	8b 45 08             	mov    0x8(%ebp),%eax
 10b:	0f b6 00             	movzbl (%eax),%eax
 10e:	84 c0                	test   %al,%al
 110:	74 10                	je     122 <strcmp+0x27>
 112:	8b 45 08             	mov    0x8(%ebp),%eax
 115:	0f b6 10             	movzbl (%eax),%edx
 118:	8b 45 0c             	mov    0xc(%ebp),%eax
 11b:	0f b6 00             	movzbl (%eax),%eax
 11e:	38 c2                	cmp    %al,%dl
 120:	74 de                	je     100 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 122:	8b 45 08             	mov    0x8(%ebp),%eax
 125:	0f b6 00             	movzbl (%eax),%eax
 128:	0f b6 d0             	movzbl %al,%edx
 12b:	8b 45 0c             	mov    0xc(%ebp),%eax
 12e:	0f b6 00             	movzbl (%eax),%eax
 131:	0f b6 c0             	movzbl %al,%eax
 134:	29 c2                	sub    %eax,%edx
 136:	89 d0                	mov    %edx,%eax
}
 138:	5d                   	pop    %ebp
 139:	c3                   	ret    

0000013a <strlen>:

uint
strlen(char *s)
{
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 140:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 147:	eb 04                	jmp    14d <strlen+0x13>
 149:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 14d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	01 d0                	add    %edx,%eax
 155:	0f b6 00             	movzbl (%eax),%eax
 158:	84 c0                	test   %al,%al
 15a:	75 ed                	jne    149 <strlen+0xf>
    ;
  return n;
 15c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 15f:	c9                   	leave  
 160:	c3                   	ret    

00000161 <memset>:

void*
memset(void *dst, int c, uint n)
{
 161:	55                   	push   %ebp
 162:	89 e5                	mov    %esp,%ebp
 164:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 167:	8b 45 10             	mov    0x10(%ebp),%eax
 16a:	89 44 24 08          	mov    %eax,0x8(%esp)
 16e:	8b 45 0c             	mov    0xc(%ebp),%eax
 171:	89 44 24 04          	mov    %eax,0x4(%esp)
 175:	8b 45 08             	mov    0x8(%ebp),%eax
 178:	89 04 24             	mov    %eax,(%esp)
 17b:	e8 26 ff ff ff       	call   a6 <stosb>
  return dst;
 180:	8b 45 08             	mov    0x8(%ebp),%eax
}
 183:	c9                   	leave  
 184:	c3                   	ret    

00000185 <strchr>:

char*
strchr(const char *s, char c)
{
 185:	55                   	push   %ebp
 186:	89 e5                	mov    %esp,%ebp
 188:	83 ec 04             	sub    $0x4,%esp
 18b:	8b 45 0c             	mov    0xc(%ebp),%eax
 18e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 191:	eb 14                	jmp    1a7 <strchr+0x22>
    if(*s == c)
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	0f b6 00             	movzbl (%eax),%eax
 199:	3a 45 fc             	cmp    -0x4(%ebp),%al
 19c:	75 05                	jne    1a3 <strchr+0x1e>
      return (char*)s;
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	eb 13                	jmp    1b6 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	0f b6 00             	movzbl (%eax),%eax
 1ad:	84 c0                	test   %al,%al
 1af:	75 e2                	jne    193 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1b6:	c9                   	leave  
 1b7:	c3                   	ret    

000001b8 <gets>:

char*
gets(char *buf, int max)
{
 1b8:	55                   	push   %ebp
 1b9:	89 e5                	mov    %esp,%ebp
 1bb:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1c5:	eb 4c                	jmp    213 <gets+0x5b>
    cc = read(0, &c, 1);
 1c7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1ce:	00 
 1cf:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1dd:	e8 44 01 00 00       	call   326 <read>
 1e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1e9:	7f 02                	jg     1ed <gets+0x35>
      break;
 1eb:	eb 31                	jmp    21e <gets+0x66>
    buf[i++] = c;
 1ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f0:	8d 50 01             	lea    0x1(%eax),%edx
 1f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1f6:	89 c2                	mov    %eax,%edx
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
 1fb:	01 c2                	add    %eax,%edx
 1fd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 201:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 203:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 207:	3c 0a                	cmp    $0xa,%al
 209:	74 13                	je     21e <gets+0x66>
 20b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 20f:	3c 0d                	cmp    $0xd,%al
 211:	74 0b                	je     21e <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 213:	8b 45 f4             	mov    -0xc(%ebp),%eax
 216:	83 c0 01             	add    $0x1,%eax
 219:	3b 45 0c             	cmp    0xc(%ebp),%eax
 21c:	7c a9                	jl     1c7 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 21e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	01 d0                	add    %edx,%eax
 226:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 229:	8b 45 08             	mov    0x8(%ebp),%eax
}
 22c:	c9                   	leave  
 22d:	c3                   	ret    

0000022e <stat>:

int
stat(char *n, struct stat *st)
{
 22e:	55                   	push   %ebp
 22f:	89 e5                	mov    %esp,%ebp
 231:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 234:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 23b:	00 
 23c:	8b 45 08             	mov    0x8(%ebp),%eax
 23f:	89 04 24             	mov    %eax,(%esp)
 242:	e8 07 01 00 00       	call   34e <open>
 247:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 24a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 24e:	79 07                	jns    257 <stat+0x29>
    return -1;
 250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 255:	eb 23                	jmp    27a <stat+0x4c>
  r = fstat(fd, st);
 257:	8b 45 0c             	mov    0xc(%ebp),%eax
 25a:	89 44 24 04          	mov    %eax,0x4(%esp)
 25e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 261:	89 04 24             	mov    %eax,(%esp)
 264:	e8 fd 00 00 00       	call   366 <fstat>
 269:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 26c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26f:	89 04 24             	mov    %eax,(%esp)
 272:	e8 bf 00 00 00       	call   336 <close>
  return r;
 277:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 27a:	c9                   	leave  
 27b:	c3                   	ret    

0000027c <atoi>:

int
atoi(const char *s)
{
 27c:	55                   	push   %ebp
 27d:	89 e5                	mov    %esp,%ebp
 27f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 282:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 289:	eb 25                	jmp    2b0 <atoi+0x34>
    n = n*10 + *s++ - '0';
 28b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28e:	89 d0                	mov    %edx,%eax
 290:	c1 e0 02             	shl    $0x2,%eax
 293:	01 d0                	add    %edx,%eax
 295:	01 c0                	add    %eax,%eax
 297:	89 c1                	mov    %eax,%ecx
 299:	8b 45 08             	mov    0x8(%ebp),%eax
 29c:	8d 50 01             	lea    0x1(%eax),%edx
 29f:	89 55 08             	mov    %edx,0x8(%ebp)
 2a2:	0f b6 00             	movzbl (%eax),%eax
 2a5:	0f be c0             	movsbl %al,%eax
 2a8:	01 c8                	add    %ecx,%eax
 2aa:	83 e8 30             	sub    $0x30,%eax
 2ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b0:	8b 45 08             	mov    0x8(%ebp),%eax
 2b3:	0f b6 00             	movzbl (%eax),%eax
 2b6:	3c 2f                	cmp    $0x2f,%al
 2b8:	7e 0a                	jle    2c4 <atoi+0x48>
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	0f b6 00             	movzbl (%eax),%eax
 2c0:	3c 39                	cmp    $0x39,%al
 2c2:	7e c7                	jle    28b <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2c7:	c9                   	leave  
 2c8:	c3                   	ret    

000002c9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2c9:	55                   	push   %ebp
 2ca:	89 e5                	mov    %esp,%ebp
 2cc:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2db:	eb 17                	jmp    2f4 <memmove+0x2b>
    *dst++ = *src++;
 2dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2e0:	8d 50 01             	lea    0x1(%eax),%edx
 2e3:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2e6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2e9:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ec:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2ef:	0f b6 12             	movzbl (%edx),%edx
 2f2:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2f4:	8b 45 10             	mov    0x10(%ebp),%eax
 2f7:	8d 50 ff             	lea    -0x1(%eax),%edx
 2fa:	89 55 10             	mov    %edx,0x10(%ebp)
 2fd:	85 c0                	test   %eax,%eax
 2ff:	7f dc                	jg     2dd <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 301:	8b 45 08             	mov    0x8(%ebp),%eax
}
 304:	c9                   	leave  
 305:	c3                   	ret    

00000306 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 306:	b8 01 00 00 00       	mov    $0x1,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <exit>:
SYSCALL(exit)
 30e:	b8 02 00 00 00       	mov    $0x2,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <wait>:
SYSCALL(wait)
 316:	b8 03 00 00 00       	mov    $0x3,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <pipe>:
SYSCALL(pipe)
 31e:	b8 04 00 00 00       	mov    $0x4,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <read>:
SYSCALL(read)
 326:	b8 05 00 00 00       	mov    $0x5,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <write>:
SYSCALL(write)
 32e:	b8 10 00 00 00       	mov    $0x10,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <close>:
SYSCALL(close)
 336:	b8 15 00 00 00       	mov    $0x15,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <kill>:
SYSCALL(kill)
 33e:	b8 06 00 00 00       	mov    $0x6,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <exec>:
SYSCALL(exec)
 346:	b8 07 00 00 00       	mov    $0x7,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <open>:
SYSCALL(open)
 34e:	b8 0f 00 00 00       	mov    $0xf,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <mknod>:
SYSCALL(mknod)
 356:	b8 11 00 00 00       	mov    $0x11,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <unlink>:
SYSCALL(unlink)
 35e:	b8 12 00 00 00       	mov    $0x12,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <fstat>:
SYSCALL(fstat)
 366:	b8 08 00 00 00       	mov    $0x8,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <link>:
SYSCALL(link)
 36e:	b8 13 00 00 00       	mov    $0x13,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <mkdir>:
SYSCALL(mkdir)
 376:	b8 14 00 00 00       	mov    $0x14,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <chdir>:
SYSCALL(chdir)
 37e:	b8 09 00 00 00       	mov    $0x9,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <dup>:
SYSCALL(dup)
 386:	b8 0a 00 00 00       	mov    $0xa,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <getpid>:
SYSCALL(getpid)
 38e:	b8 0b 00 00 00       	mov    $0xb,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <sbrk>:
SYSCALL(sbrk)
 396:	b8 0c 00 00 00       	mov    $0xc,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <sleep>:
SYSCALL(sleep)
 39e:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <uptime>:
SYSCALL(uptime)
 3a6:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <my_syscall>:
SYSCALL(my_syscall)
 3ae:	b8 16 00 00 00       	mov    $0x16,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <getppid>:
SYSCALL(getppid)
 3b6:	b8 17 00 00 00       	mov    $0x17,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <yield>:
SYSCALL(yield)
 3be:	b8 18 00 00 00       	mov    $0x18,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <getlev>:
SYSCALL(getlev)
 3c6:	b8 19 00 00 00       	mov    $0x19,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <clone>:
SYSCALL(clone)
 3ce:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <join>:
SYSCALL(join)
 3d6:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <thexit>:
SYSCALL(thexit)
 3de:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3e6:	55                   	push   %ebp
 3e7:	89 e5                	mov    %esp,%ebp
 3e9:	83 ec 18             	sub    $0x18,%esp
 3ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ef:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3f2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3f9:	00 
 3fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 401:	8b 45 08             	mov    0x8(%ebp),%eax
 404:	89 04 24             	mov    %eax,(%esp)
 407:	e8 22 ff ff ff       	call   32e <write>
}
 40c:	c9                   	leave  
 40d:	c3                   	ret    

0000040e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40e:	55                   	push   %ebp
 40f:	89 e5                	mov    %esp,%ebp
 411:	56                   	push   %esi
 412:	53                   	push   %ebx
 413:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 416:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 41d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 421:	74 17                	je     43a <printint+0x2c>
 423:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 427:	79 11                	jns    43a <printint+0x2c>
    neg = 1;
 429:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 430:	8b 45 0c             	mov    0xc(%ebp),%eax
 433:	f7 d8                	neg    %eax
 435:	89 45 ec             	mov    %eax,-0x14(%ebp)
 438:	eb 06                	jmp    440 <printint+0x32>
  } else {
    x = xx;
 43a:	8b 45 0c             	mov    0xc(%ebp),%eax
 43d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 440:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 447:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 44a:	8d 41 01             	lea    0x1(%ecx),%eax
 44d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 450:	8b 5d 10             	mov    0x10(%ebp),%ebx
 453:	8b 45 ec             	mov    -0x14(%ebp),%eax
 456:	ba 00 00 00 00       	mov    $0x0,%edx
 45b:	f7 f3                	div    %ebx
 45d:	89 d0                	mov    %edx,%eax
 45f:	0f b6 80 70 0c 00 00 	movzbl 0xc70(%eax),%eax
 466:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 46a:	8b 75 10             	mov    0x10(%ebp),%esi
 46d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 470:	ba 00 00 00 00       	mov    $0x0,%edx
 475:	f7 f6                	div    %esi
 477:	89 45 ec             	mov    %eax,-0x14(%ebp)
 47a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 47e:	75 c7                	jne    447 <printint+0x39>
  if(neg)
 480:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 484:	74 10                	je     496 <printint+0x88>
    buf[i++] = '-';
 486:	8b 45 f4             	mov    -0xc(%ebp),%eax
 489:	8d 50 01             	lea    0x1(%eax),%edx
 48c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 48f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 494:	eb 1f                	jmp    4b5 <printint+0xa7>
 496:	eb 1d                	jmp    4b5 <printint+0xa7>
    putc(fd, buf[i]);
 498:	8d 55 dc             	lea    -0x24(%ebp),%edx
 49b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49e:	01 d0                	add    %edx,%eax
 4a0:	0f b6 00             	movzbl (%eax),%eax
 4a3:	0f be c0             	movsbl %al,%eax
 4a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 4aa:	8b 45 08             	mov    0x8(%ebp),%eax
 4ad:	89 04 24             	mov    %eax,(%esp)
 4b0:	e8 31 ff ff ff       	call   3e6 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4b5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4bd:	79 d9                	jns    498 <printint+0x8a>
    putc(fd, buf[i]);
}
 4bf:	83 c4 30             	add    $0x30,%esp
 4c2:	5b                   	pop    %ebx
 4c3:	5e                   	pop    %esi
 4c4:	5d                   	pop    %ebp
 4c5:	c3                   	ret    

000004c6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4c6:	55                   	push   %ebp
 4c7:	89 e5                	mov    %esp,%ebp
 4c9:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4d3:	8d 45 0c             	lea    0xc(%ebp),%eax
 4d6:	83 c0 04             	add    $0x4,%eax
 4d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4e3:	e9 7c 01 00 00       	jmp    664 <printf+0x19e>
    c = fmt[i] & 0xff;
 4e8:	8b 55 0c             	mov    0xc(%ebp),%edx
 4eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ee:	01 d0                	add    %edx,%eax
 4f0:	0f b6 00             	movzbl (%eax),%eax
 4f3:	0f be c0             	movsbl %al,%eax
 4f6:	25 ff 00 00 00       	and    $0xff,%eax
 4fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 502:	75 2c                	jne    530 <printf+0x6a>
      if(c == '%'){
 504:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 508:	75 0c                	jne    516 <printf+0x50>
        state = '%';
 50a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 511:	e9 4a 01 00 00       	jmp    660 <printf+0x19a>
      } else {
        putc(fd, c);
 516:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 519:	0f be c0             	movsbl %al,%eax
 51c:	89 44 24 04          	mov    %eax,0x4(%esp)
 520:	8b 45 08             	mov    0x8(%ebp),%eax
 523:	89 04 24             	mov    %eax,(%esp)
 526:	e8 bb fe ff ff       	call   3e6 <putc>
 52b:	e9 30 01 00 00       	jmp    660 <printf+0x19a>
      }
    } else if(state == '%'){
 530:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 534:	0f 85 26 01 00 00    	jne    660 <printf+0x19a>
      if(c == 'd'){
 53a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 53e:	75 2d                	jne    56d <printf+0xa7>
        printint(fd, *ap, 10, 1);
 540:	8b 45 e8             	mov    -0x18(%ebp),%eax
 543:	8b 00                	mov    (%eax),%eax
 545:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 54c:	00 
 54d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 554:	00 
 555:	89 44 24 04          	mov    %eax,0x4(%esp)
 559:	8b 45 08             	mov    0x8(%ebp),%eax
 55c:	89 04 24             	mov    %eax,(%esp)
 55f:	e8 aa fe ff ff       	call   40e <printint>
        ap++;
 564:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 568:	e9 ec 00 00 00       	jmp    659 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 56d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 571:	74 06                	je     579 <printf+0xb3>
 573:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 577:	75 2d                	jne    5a6 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 579:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57c:	8b 00                	mov    (%eax),%eax
 57e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 585:	00 
 586:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 58d:	00 
 58e:	89 44 24 04          	mov    %eax,0x4(%esp)
 592:	8b 45 08             	mov    0x8(%ebp),%eax
 595:	89 04 24             	mov    %eax,(%esp)
 598:	e8 71 fe ff ff       	call   40e <printint>
        ap++;
 59d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a1:	e9 b3 00 00 00       	jmp    659 <printf+0x193>
      } else if(c == 's'){
 5a6:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5aa:	75 45                	jne    5f1 <printf+0x12b>
        s = (char*)*ap;
 5ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5af:	8b 00                	mov    (%eax),%eax
 5b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5b4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5bc:	75 09                	jne    5c7 <printf+0x101>
          s = "(null)";
 5be:	c7 45 f4 a5 09 00 00 	movl   $0x9a5,-0xc(%ebp)
        while(*s != 0){
 5c5:	eb 1e                	jmp    5e5 <printf+0x11f>
 5c7:	eb 1c                	jmp    5e5 <printf+0x11f>
          putc(fd, *s);
 5c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cc:	0f b6 00             	movzbl (%eax),%eax
 5cf:	0f be c0             	movsbl %al,%eax
 5d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d6:	8b 45 08             	mov    0x8(%ebp),%eax
 5d9:	89 04 24             	mov    %eax,(%esp)
 5dc:	e8 05 fe ff ff       	call   3e6 <putc>
          s++;
 5e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e8:	0f b6 00             	movzbl (%eax),%eax
 5eb:	84 c0                	test   %al,%al
 5ed:	75 da                	jne    5c9 <printf+0x103>
 5ef:	eb 68                	jmp    659 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5f1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5f5:	75 1d                	jne    614 <printf+0x14e>
        putc(fd, *ap);
 5f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fa:	8b 00                	mov    (%eax),%eax
 5fc:	0f be c0             	movsbl %al,%eax
 5ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 603:	8b 45 08             	mov    0x8(%ebp),%eax
 606:	89 04 24             	mov    %eax,(%esp)
 609:	e8 d8 fd ff ff       	call   3e6 <putc>
        ap++;
 60e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 612:	eb 45                	jmp    659 <printf+0x193>
      } else if(c == '%'){
 614:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 618:	75 17                	jne    631 <printf+0x16b>
        putc(fd, c);
 61a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61d:	0f be c0             	movsbl %al,%eax
 620:	89 44 24 04          	mov    %eax,0x4(%esp)
 624:	8b 45 08             	mov    0x8(%ebp),%eax
 627:	89 04 24             	mov    %eax,(%esp)
 62a:	e8 b7 fd ff ff       	call   3e6 <putc>
 62f:	eb 28                	jmp    659 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 631:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 638:	00 
 639:	8b 45 08             	mov    0x8(%ebp),%eax
 63c:	89 04 24             	mov    %eax,(%esp)
 63f:	e8 a2 fd ff ff       	call   3e6 <putc>
        putc(fd, c);
 644:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 647:	0f be c0             	movsbl %al,%eax
 64a:	89 44 24 04          	mov    %eax,0x4(%esp)
 64e:	8b 45 08             	mov    0x8(%ebp),%eax
 651:	89 04 24             	mov    %eax,(%esp)
 654:	e8 8d fd ff ff       	call   3e6 <putc>
      }
      state = 0;
 659:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 660:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 664:	8b 55 0c             	mov    0xc(%ebp),%edx
 667:	8b 45 f0             	mov    -0x10(%ebp),%eax
 66a:	01 d0                	add    %edx,%eax
 66c:	0f b6 00             	movzbl (%eax),%eax
 66f:	84 c0                	test   %al,%al
 671:	0f 85 71 fe ff ff    	jne    4e8 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 677:	c9                   	leave  
 678:	c3                   	ret    

00000679 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 679:	55                   	push   %ebp
 67a:	89 e5                	mov    %esp,%ebp
 67c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 67f:	8b 45 08             	mov    0x8(%ebp),%eax
 682:	83 e8 08             	sub    $0x8,%eax
 685:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 688:	a1 8c 0c 00 00       	mov    0xc8c,%eax
 68d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 690:	eb 24                	jmp    6b6 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 00                	mov    (%eax),%eax
 697:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69a:	77 12                	ja     6ae <free+0x35>
 69c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a2:	77 24                	ja     6c8 <free+0x4f>
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	8b 00                	mov    (%eax),%eax
 6a9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ac:	77 1a                	ja     6c8 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b1:	8b 00                	mov    (%eax),%eax
 6b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6bc:	76 d4                	jbe    692 <free+0x19>
 6be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c1:	8b 00                	mov    (%eax),%eax
 6c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c6:	76 ca                	jbe    692 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cb:	8b 40 04             	mov    0x4(%eax),%eax
 6ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d8:	01 c2                	add    %eax,%edx
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	8b 00                	mov    (%eax),%eax
 6df:	39 c2                	cmp    %eax,%edx
 6e1:	75 24                	jne    707 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e6:	8b 50 04             	mov    0x4(%eax),%edx
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 00                	mov    (%eax),%eax
 6ee:	8b 40 04             	mov    0x4(%eax),%eax
 6f1:	01 c2                	add    %eax,%edx
 6f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	8b 00                	mov    (%eax),%eax
 6fe:	8b 10                	mov    (%eax),%edx
 700:	8b 45 f8             	mov    -0x8(%ebp),%eax
 703:	89 10                	mov    %edx,(%eax)
 705:	eb 0a                	jmp    711 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 707:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70a:	8b 10                	mov    (%eax),%edx
 70c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 40 04             	mov    0x4(%eax),%eax
 717:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	01 d0                	add    %edx,%eax
 723:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 726:	75 20                	jne    748 <free+0xcf>
    p->s.size += bp->s.size;
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 50 04             	mov    0x4(%eax),%edx
 72e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 731:	8b 40 04             	mov    0x4(%eax),%eax
 734:	01 c2                	add    %eax,%edx
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 73c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73f:	8b 10                	mov    (%eax),%edx
 741:	8b 45 fc             	mov    -0x4(%ebp),%eax
 744:	89 10                	mov    %edx,(%eax)
 746:	eb 08                	jmp    750 <free+0xd7>
  } else
    p->s.ptr = bp;
 748:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 74e:	89 10                	mov    %edx,(%eax)
  freep = p;
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	a3 8c 0c 00 00       	mov    %eax,0xc8c
}
 758:	c9                   	leave  
 759:	c3                   	ret    

0000075a <morecore>:

static Header*
morecore(uint nu)
{
 75a:	55                   	push   %ebp
 75b:	89 e5                	mov    %esp,%ebp
 75d:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 760:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 767:	77 07                	ja     770 <morecore+0x16>
    nu = 4096;
 769:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 770:	8b 45 08             	mov    0x8(%ebp),%eax
 773:	c1 e0 03             	shl    $0x3,%eax
 776:	89 04 24             	mov    %eax,(%esp)
 779:	e8 18 fc ff ff       	call   396 <sbrk>
 77e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 781:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 785:	75 07                	jne    78e <morecore+0x34>
    return 0;
 787:	b8 00 00 00 00       	mov    $0x0,%eax
 78c:	eb 22                	jmp    7b0 <morecore+0x56>
  hp = (Header*)p;
 78e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 791:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 794:	8b 45 f0             	mov    -0x10(%ebp),%eax
 797:	8b 55 08             	mov    0x8(%ebp),%edx
 79a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 79d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a0:	83 c0 08             	add    $0x8,%eax
 7a3:	89 04 24             	mov    %eax,(%esp)
 7a6:	e8 ce fe ff ff       	call   679 <free>
  return freep;
 7ab:	a1 8c 0c 00 00       	mov    0xc8c,%eax
}
 7b0:	c9                   	leave  
 7b1:	c3                   	ret    

000007b2 <malloc>:

void*
malloc(uint nbytes)
{
 7b2:	55                   	push   %ebp
 7b3:	89 e5                	mov    %esp,%ebp
 7b5:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b8:	8b 45 08             	mov    0x8(%ebp),%eax
 7bb:	83 c0 07             	add    $0x7,%eax
 7be:	c1 e8 03             	shr    $0x3,%eax
 7c1:	83 c0 01             	add    $0x1,%eax
 7c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7c7:	a1 8c 0c 00 00       	mov    0xc8c,%eax
 7cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7d3:	75 23                	jne    7f8 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7d5:	c7 45 f0 84 0c 00 00 	movl   $0xc84,-0x10(%ebp)
 7dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7df:	a3 8c 0c 00 00       	mov    %eax,0xc8c
 7e4:	a1 8c 0c 00 00       	mov    0xc8c,%eax
 7e9:	a3 84 0c 00 00       	mov    %eax,0xc84
    base.s.size = 0;
 7ee:	c7 05 88 0c 00 00 00 	movl   $0x0,0xc88
 7f5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fb:	8b 00                	mov    (%eax),%eax
 7fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 800:	8b 45 f4             	mov    -0xc(%ebp),%eax
 803:	8b 40 04             	mov    0x4(%eax),%eax
 806:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 809:	72 4d                	jb     858 <malloc+0xa6>
      if(p->s.size == nunits)
 80b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80e:	8b 40 04             	mov    0x4(%eax),%eax
 811:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 814:	75 0c                	jne    822 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 816:	8b 45 f4             	mov    -0xc(%ebp),%eax
 819:	8b 10                	mov    (%eax),%edx
 81b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81e:	89 10                	mov    %edx,(%eax)
 820:	eb 26                	jmp    848 <malloc+0x96>
      else {
        p->s.size -= nunits;
 822:	8b 45 f4             	mov    -0xc(%ebp),%eax
 825:	8b 40 04             	mov    0x4(%eax),%eax
 828:	2b 45 ec             	sub    -0x14(%ebp),%eax
 82b:	89 c2                	mov    %eax,%edx
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	8b 40 04             	mov    0x4(%eax),%eax
 839:	c1 e0 03             	shl    $0x3,%eax
 83c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	8b 55 ec             	mov    -0x14(%ebp),%edx
 845:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 848:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84b:	a3 8c 0c 00 00       	mov    %eax,0xc8c
      return (void*)(p + 1);
 850:	8b 45 f4             	mov    -0xc(%ebp),%eax
 853:	83 c0 08             	add    $0x8,%eax
 856:	eb 38                	jmp    890 <malloc+0xde>
    }
    if(p == freep)
 858:	a1 8c 0c 00 00       	mov    0xc8c,%eax
 85d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 860:	75 1b                	jne    87d <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 862:	8b 45 ec             	mov    -0x14(%ebp),%eax
 865:	89 04 24             	mov    %eax,(%esp)
 868:	e8 ed fe ff ff       	call   75a <morecore>
 86d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 870:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 874:	75 07                	jne    87d <malloc+0xcb>
        return 0;
 876:	b8 00 00 00 00       	mov    $0x0,%eax
 87b:	eb 13                	jmp    890 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 880:	89 45 f0             	mov    %eax,-0x10(%ebp)
 883:	8b 45 f4             	mov    -0xc(%ebp),%eax
 886:	8b 00                	mov    (%eax),%eax
 888:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 88b:	e9 70 ff ff ff       	jmp    800 <malloc+0x4e>
}
 890:	c9                   	leave  
 891:	c3                   	ret    

00000892 <thread_create>:
#include"x86.h"
#include"param.h"
#include"proc.h"

int thread_create(thread_t *thread, void*(*start_routine)(void*),void *arg)
{
 892:	55                   	push   %ebp
 893:	89 e5                	mov    %esp,%ebp
 895:	83 ec 28             	sub    $0x28,%esp
    void *stack = malloc(PGSIZE);
 898:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 89f:	e8 0e ff ff ff       	call   7b2 <malloc>
 8a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if((uint)stack <=0)
 8a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8aa:	85 c0                	test   %eax,%eax
 8ac:	75 1b                	jne    8c9 <thread_create+0x37>
    {
        printf(1,"malloc thread stack failed\n");
 8ae:	c7 44 24 04 ac 09 00 	movl   $0x9ac,0x4(%esp)
 8b5:	00 
 8b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8bd:	e8 04 fc ff ff       	call   4c6 <printf>
        return -1;
 8c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8c7:	eb 67                	jmp    930 <thread_create+0x9e>
    }
    
    if((uint)stack%PGSIZE)
 8c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cc:	25 ff 0f 00 00       	and    $0xfff,%eax
 8d1:	85 c0                	test   %eax,%eax
 8d3:	74 14                	je     8e9 <thread_create+0x57>
        stack += PGSIZE-((uint)stack%PGSIZE);
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	25 ff 0f 00 00       	and    $0xfff,%eax
 8dd:	89 c2                	mov    %eax,%edx
 8df:	b8 00 10 00 00       	mov    $0x1000,%eax
 8e4:	29 d0                	sub    %edx,%eax
 8e6:	01 45 f4             	add    %eax,-0xc(%ebp)
    printf(1,"1\n");
 8e9:	c7 44 24 04 c8 09 00 	movl   $0x9c8,0x4(%esp)
 8f0:	00 
 8f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8f8:	e8 c9 fb ff ff       	call   4c6 <printf>
    if((*thread = clone(start_routine,arg,stack))<0)
 8fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 900:	89 44 24 08          	mov    %eax,0x8(%esp)
 904:	8b 45 10             	mov    0x10(%ebp),%eax
 907:	89 44 24 04          	mov    %eax,0x4(%esp)
 90b:	8b 45 0c             	mov    0xc(%ebp),%eax
 90e:	89 04 24             	mov    %eax,(%esp)
 911:	e8 b8 fa ff ff       	call   3ce <clone>
 916:	8b 55 08             	mov    0x8(%ebp),%edx
 919:	89 02                	mov    %eax,(%edx)
 91b:	8b 45 08             	mov    0x8(%ebp),%eax
 91e:	8b 00                	mov    (%eax),%eax
 920:	85 c0                	test   %eax,%eax
 922:	79 07                	jns    92b <thread_create+0x99>
        return -1;
 924:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 929:	eb 05                	jmp    930 <thread_create+0x9e>
    return 0;
 92b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 930:	c9                   	leave  
 931:	c3                   	ret    

00000932 <thread_join>:

int thread_join(thread_t thread, void **retval)
{
 932:	55                   	push   %ebp
 933:	89 e5                	mov    %esp,%ebp
 935:	83 ec 28             	sub    $0x28,%esp
    void *stack;
    if(join((uint)thread, &stack, retval)<0)
 938:	8b 45 0c             	mov    0xc(%ebp),%eax
 93b:	89 44 24 08          	mov    %eax,0x8(%esp)
 93f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 942:	89 44 24 04          	mov    %eax,0x4(%esp)
 946:	8b 45 08             	mov    0x8(%ebp),%eax
 949:	89 04 24             	mov    %eax,(%esp)
 94c:	e8 85 fa ff ff       	call   3d6 <join>
 951:	85 c0                	test   %eax,%eax
 953:	79 07                	jns    95c <thread_join+0x2a>
        return -1;
 955:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 95a:	eb 10                	jmp    96c <thread_join+0x3a>

    free(stack);
 95c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95f:	89 04 24             	mov    %eax,(%esp)
 962:	e8 12 fd ff ff       	call   679 <free>
    return 0;
 967:	b8 00 00 00 00       	mov    $0x0,%eax
}
 96c:	c9                   	leave  
 96d:	c3                   	ret    

0000096e <thread_exit>:

void thread_exit(void *retval)
{
 96e:	55                   	push   %ebp
 96f:	89 e5                	mov    %esp,%ebp
 971:	83 ec 08             	sub    $0x8,%esp
    proc->retval = retval;
 974:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 97a:	8b 55 08             	mov    0x8(%ebp),%edx
 97d:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
    thexit();
 983:	e8 56 fa ff ff       	call   3de <thexit>
}
 988:	c9                   	leave  
 989:	c3                   	ret    
