
_ttest:     file format elf32-i386


Disassembly of section .text:

00000000 <threadmain>:
#include "stat.h"
#include "user.h"
#define NUM_THREAD 10
void*
threadmain(void *data)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
    int n = *((int*)data);
   6:	8b 45 08             	mov    0x8(%ebp),%eax
   9:	8b 00                	mov    (%eax),%eax
   b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(1," %d thread created completely",n);
   e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  11:	89 44 24 08          	mov    %eax,0x8(%esp)
  15:	c7 44 24 04 99 09 00 	movl   $0x999,0x4(%esp)
  1c:	00 
  1d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  24:	e8 ac 04 00 00       	call   4d5 <printf>
}
  29:	c9                   	leave  
  2a:	c3                   	ret    

0000002b <main>:

int
main(void)
{
  2b:	55                   	push   %ebp
  2c:	89 e5                	mov    %esp,%ebp
  2e:	83 e4 f0             	and    $0xfffffff0,%esp
  31:	83 ec 70             	sub    $0x70,%esp
  thread_t threads[NUM_THREAD];
  int i;
  int pid[10];
  void *retval;
  printf(1,"start"); 
  34:	c7 44 24 04 b7 09 00 	movl   $0x9b7,0x4(%esp)
  3b:	00 
  3c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  43:	e8 8d 04 00 00       	call   4d5 <printf>
  for (i = 0; i < 3; i++){
  48:	c7 44 24 6c 00 00 00 	movl   $0x0,0x6c(%esp)
  4f:	00 
  50:	eb 55                	jmp    a7 <main+0x7c>
    if (thread_create(&threads[i], threadmain, (void*)i) != 0){
  52:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  56:	8d 54 24 44          	lea    0x44(%esp),%edx
  5a:	8b 4c 24 6c          	mov    0x6c(%esp),%ecx
  5e:	c1 e1 02             	shl    $0x2,%ecx
  61:	01 ca                	add    %ecx,%edx
  63:	89 44 24 08          	mov    %eax,0x8(%esp)
  67:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  6e:	00 
  6f:	89 14 24             	mov    %edx,(%esp)
  72:	e8 2a 08 00 00       	call   8a1 <thread_create>
  77:	85 c0                	test   %eax,%eax
  79:	74 07                	je     82 <main+0x57>
      return -1;
  7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80:	eb 31                	jmp    b3 <main+0x88>
    }
    else
        printf(1,"created %d \n",threads[i]);
  82:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  86:	8b 44 84 44          	mov    0x44(%esp,%eax,4),%eax
  8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  8e:	c7 44 24 04 bd 09 00 	movl   $0x9bd,0x4(%esp)
  95:	00 
  96:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9d:	e8 33 04 00 00       	call   4d5 <printf>
  thread_t threads[NUM_THREAD];
  int i;
  int pid[10];
  void *retval;
  printf(1,"start"); 
  for (i = 0; i < 3; i++){
  a2:	83 44 24 6c 01       	addl   $0x1,0x6c(%esp)
  a7:	83 7c 24 6c 02       	cmpl   $0x2,0x6c(%esp)
  ac:	7e a4                	jle    52 <main+0x27>
      return -1;
    }
    else
        printf(1,"created %d \n",threads[i]);
  }
  return 0;
  ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  b3:	c9                   	leave  
  b4:	c3                   	ret    

000000b5 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	57                   	push   %edi
  b9:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  bd:	8b 55 10             	mov    0x10(%ebp),%edx
  c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  c3:	89 cb                	mov    %ecx,%ebx
  c5:	89 df                	mov    %ebx,%edi
  c7:	89 d1                	mov    %edx,%ecx
  c9:	fc                   	cld    
  ca:	f3 aa                	rep stos %al,%es:(%edi)
  cc:	89 ca                	mov    %ecx,%edx
  ce:	89 fb                	mov    %edi,%ebx
  d0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  d3:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  d6:	5b                   	pop    %ebx
  d7:	5f                   	pop    %edi
  d8:	5d                   	pop    %ebp
  d9:	c3                   	ret    

000000da <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  da:	55                   	push   %ebp
  db:	89 e5                	mov    %esp,%ebp
  dd:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  e0:	8b 45 08             	mov    0x8(%ebp),%eax
  e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  e6:	90                   	nop
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
  ea:	8d 50 01             	lea    0x1(%eax),%edx
  ed:	89 55 08             	mov    %edx,0x8(%ebp)
  f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  f3:	8d 4a 01             	lea    0x1(%edx),%ecx
  f6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  f9:	0f b6 12             	movzbl (%edx),%edx
  fc:	88 10                	mov    %dl,(%eax)
  fe:	0f b6 00             	movzbl (%eax),%eax
 101:	84 c0                	test   %al,%al
 103:	75 e2                	jne    e7 <strcpy+0xd>
    ;
  return os;
 105:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 108:	c9                   	leave  
 109:	c3                   	ret    

0000010a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 10a:	55                   	push   %ebp
 10b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 10d:	eb 08                	jmp    117 <strcmp+0xd>
    p++, q++;
 10f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 113:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	0f b6 00             	movzbl (%eax),%eax
 11d:	84 c0                	test   %al,%al
 11f:	74 10                	je     131 <strcmp+0x27>
 121:	8b 45 08             	mov    0x8(%ebp),%eax
 124:	0f b6 10             	movzbl (%eax),%edx
 127:	8b 45 0c             	mov    0xc(%ebp),%eax
 12a:	0f b6 00             	movzbl (%eax),%eax
 12d:	38 c2                	cmp    %al,%dl
 12f:	74 de                	je     10f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 131:	8b 45 08             	mov    0x8(%ebp),%eax
 134:	0f b6 00             	movzbl (%eax),%eax
 137:	0f b6 d0             	movzbl %al,%edx
 13a:	8b 45 0c             	mov    0xc(%ebp),%eax
 13d:	0f b6 00             	movzbl (%eax),%eax
 140:	0f b6 c0             	movzbl %al,%eax
 143:	29 c2                	sub    %eax,%edx
 145:	89 d0                	mov    %edx,%eax
}
 147:	5d                   	pop    %ebp
 148:	c3                   	ret    

00000149 <strlen>:

uint
strlen(char *s)
{
 149:	55                   	push   %ebp
 14a:	89 e5                	mov    %esp,%ebp
 14c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 14f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 156:	eb 04                	jmp    15c <strlen+0x13>
 158:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 15c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	01 d0                	add    %edx,%eax
 164:	0f b6 00             	movzbl (%eax),%eax
 167:	84 c0                	test   %al,%al
 169:	75 ed                	jne    158 <strlen+0xf>
    ;
  return n;
 16b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16e:	c9                   	leave  
 16f:	c3                   	ret    

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 176:	8b 45 10             	mov    0x10(%ebp),%eax
 179:	89 44 24 08          	mov    %eax,0x8(%esp)
 17d:	8b 45 0c             	mov    0xc(%ebp),%eax
 180:	89 44 24 04          	mov    %eax,0x4(%esp)
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	89 04 24             	mov    %eax,(%esp)
 18a:	e8 26 ff ff ff       	call   b5 <stosb>
  return dst;
 18f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 192:	c9                   	leave  
 193:	c3                   	ret    

00000194 <strchr>:

char*
strchr(const char *s, char c)
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	83 ec 04             	sub    $0x4,%esp
 19a:	8b 45 0c             	mov    0xc(%ebp),%eax
 19d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1a0:	eb 14                	jmp    1b6 <strchr+0x22>
    if(*s == c)
 1a2:	8b 45 08             	mov    0x8(%ebp),%eax
 1a5:	0f b6 00             	movzbl (%eax),%eax
 1a8:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1ab:	75 05                	jne    1b2 <strchr+0x1e>
      return (char*)s;
 1ad:	8b 45 08             	mov    0x8(%ebp),%eax
 1b0:	eb 13                	jmp    1c5 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1b2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
 1b9:	0f b6 00             	movzbl (%eax),%eax
 1bc:	84 c0                	test   %al,%al
 1be:	75 e2                	jne    1a2 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1c5:	c9                   	leave  
 1c6:	c3                   	ret    

000001c7 <gets>:

char*
gets(char *buf, int max)
{
 1c7:	55                   	push   %ebp
 1c8:	89 e5                	mov    %esp,%ebp
 1ca:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1d4:	eb 4c                	jmp    222 <gets+0x5b>
    cc = read(0, &c, 1);
 1d6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1dd:	00 
 1de:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1ec:	e8 44 01 00 00       	call   335 <read>
 1f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1f8:	7f 02                	jg     1fc <gets+0x35>
      break;
 1fa:	eb 31                	jmp    22d <gets+0x66>
    buf[i++] = c;
 1fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ff:	8d 50 01             	lea    0x1(%eax),%edx
 202:	89 55 f4             	mov    %edx,-0xc(%ebp)
 205:	89 c2                	mov    %eax,%edx
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	01 c2                	add    %eax,%edx
 20c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 210:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 212:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 216:	3c 0a                	cmp    $0xa,%al
 218:	74 13                	je     22d <gets+0x66>
 21a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 21e:	3c 0d                	cmp    $0xd,%al
 220:	74 0b                	je     22d <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 222:	8b 45 f4             	mov    -0xc(%ebp),%eax
 225:	83 c0 01             	add    $0x1,%eax
 228:	3b 45 0c             	cmp    0xc(%ebp),%eax
 22b:	7c a9                	jl     1d6 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 22d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 230:	8b 45 08             	mov    0x8(%ebp),%eax
 233:	01 d0                	add    %edx,%eax
 235:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 238:	8b 45 08             	mov    0x8(%ebp),%eax
}
 23b:	c9                   	leave  
 23c:	c3                   	ret    

0000023d <stat>:

int
stat(char *n, struct stat *st)
{
 23d:	55                   	push   %ebp
 23e:	89 e5                	mov    %esp,%ebp
 240:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 243:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 24a:	00 
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
 24e:	89 04 24             	mov    %eax,(%esp)
 251:	e8 07 01 00 00       	call   35d <open>
 256:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 259:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 25d:	79 07                	jns    266 <stat+0x29>
    return -1;
 25f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 264:	eb 23                	jmp    289 <stat+0x4c>
  r = fstat(fd, st);
 266:	8b 45 0c             	mov    0xc(%ebp),%eax
 269:	89 44 24 04          	mov    %eax,0x4(%esp)
 26d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 270:	89 04 24             	mov    %eax,(%esp)
 273:	e8 fd 00 00 00       	call   375 <fstat>
 278:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 27b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27e:	89 04 24             	mov    %eax,(%esp)
 281:	e8 bf 00 00 00       	call   345 <close>
  return r;
 286:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 289:	c9                   	leave  
 28a:	c3                   	ret    

0000028b <atoi>:

int
atoi(const char *s)
{
 28b:	55                   	push   %ebp
 28c:	89 e5                	mov    %esp,%ebp
 28e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 291:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 298:	eb 25                	jmp    2bf <atoi+0x34>
    n = n*10 + *s++ - '0';
 29a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 29d:	89 d0                	mov    %edx,%eax
 29f:	c1 e0 02             	shl    $0x2,%eax
 2a2:	01 d0                	add    %edx,%eax
 2a4:	01 c0                	add    %eax,%eax
 2a6:	89 c1                	mov    %eax,%ecx
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	8d 50 01             	lea    0x1(%eax),%edx
 2ae:	89 55 08             	mov    %edx,0x8(%ebp)
 2b1:	0f b6 00             	movzbl (%eax),%eax
 2b4:	0f be c0             	movsbl %al,%eax
 2b7:	01 c8                	add    %ecx,%eax
 2b9:	83 e8 30             	sub    $0x30,%eax
 2bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2bf:	8b 45 08             	mov    0x8(%ebp),%eax
 2c2:	0f b6 00             	movzbl (%eax),%eax
 2c5:	3c 2f                	cmp    $0x2f,%al
 2c7:	7e 0a                	jle    2d3 <atoi+0x48>
 2c9:	8b 45 08             	mov    0x8(%ebp),%eax
 2cc:	0f b6 00             	movzbl (%eax),%eax
 2cf:	3c 39                	cmp    $0x39,%al
 2d1:	7e c7                	jle    29a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2d6:	c9                   	leave  
 2d7:	c3                   	ret    

000002d8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2d8:	55                   	push   %ebp
 2d9:	89 e5                	mov    %esp,%ebp
 2db:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 2de:	8b 45 08             	mov    0x8(%ebp),%eax
 2e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ea:	eb 17                	jmp    303 <memmove+0x2b>
    *dst++ = *src++;
 2ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ef:	8d 50 01             	lea    0x1(%eax),%edx
 2f2:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2f5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2f8:	8d 4a 01             	lea    0x1(%edx),%ecx
 2fb:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2fe:	0f b6 12             	movzbl (%edx),%edx
 301:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 303:	8b 45 10             	mov    0x10(%ebp),%eax
 306:	8d 50 ff             	lea    -0x1(%eax),%edx
 309:	89 55 10             	mov    %edx,0x10(%ebp)
 30c:	85 c0                	test   %eax,%eax
 30e:	7f dc                	jg     2ec <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 310:	8b 45 08             	mov    0x8(%ebp),%eax
}
 313:	c9                   	leave  
 314:	c3                   	ret    

00000315 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 315:	b8 01 00 00 00       	mov    $0x1,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <exit>:
SYSCALL(exit)
 31d:	b8 02 00 00 00       	mov    $0x2,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <wait>:
SYSCALL(wait)
 325:	b8 03 00 00 00       	mov    $0x3,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <pipe>:
SYSCALL(pipe)
 32d:	b8 04 00 00 00       	mov    $0x4,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <read>:
SYSCALL(read)
 335:	b8 05 00 00 00       	mov    $0x5,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <write>:
SYSCALL(write)
 33d:	b8 10 00 00 00       	mov    $0x10,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <close>:
SYSCALL(close)
 345:	b8 15 00 00 00       	mov    $0x15,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <kill>:
SYSCALL(kill)
 34d:	b8 06 00 00 00       	mov    $0x6,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <exec>:
SYSCALL(exec)
 355:	b8 07 00 00 00       	mov    $0x7,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <open>:
SYSCALL(open)
 35d:	b8 0f 00 00 00       	mov    $0xf,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <mknod>:
SYSCALL(mknod)
 365:	b8 11 00 00 00       	mov    $0x11,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <unlink>:
SYSCALL(unlink)
 36d:	b8 12 00 00 00       	mov    $0x12,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <fstat>:
SYSCALL(fstat)
 375:	b8 08 00 00 00       	mov    $0x8,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <link>:
SYSCALL(link)
 37d:	b8 13 00 00 00       	mov    $0x13,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <mkdir>:
SYSCALL(mkdir)
 385:	b8 14 00 00 00       	mov    $0x14,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <chdir>:
SYSCALL(chdir)
 38d:	b8 09 00 00 00       	mov    $0x9,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <dup>:
SYSCALL(dup)
 395:	b8 0a 00 00 00       	mov    $0xa,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <getpid>:
SYSCALL(getpid)
 39d:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <sbrk>:
SYSCALL(sbrk)
 3a5:	b8 0c 00 00 00       	mov    $0xc,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <sleep>:
SYSCALL(sleep)
 3ad:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <uptime>:
SYSCALL(uptime)
 3b5:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <my_syscall>:
SYSCALL(my_syscall)
 3bd:	b8 16 00 00 00       	mov    $0x16,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <getppid>:
SYSCALL(getppid)
 3c5:	b8 17 00 00 00       	mov    $0x17,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <yield>:
SYSCALL(yield)
 3cd:	b8 18 00 00 00       	mov    $0x18,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <getlev>:
SYSCALL(getlev)
 3d5:	b8 19 00 00 00       	mov    $0x19,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <clone>:
SYSCALL(clone)
 3dd:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <join>:
SYSCALL(join)
 3e5:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <thexit>:
SYSCALL(thexit)
 3ed:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3f5:	55                   	push   %ebp
 3f6:	89 e5                	mov    %esp,%ebp
 3f8:	83 ec 18             	sub    $0x18,%esp
 3fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fe:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 401:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 408:	00 
 409:	8d 45 f4             	lea    -0xc(%ebp),%eax
 40c:	89 44 24 04          	mov    %eax,0x4(%esp)
 410:	8b 45 08             	mov    0x8(%ebp),%eax
 413:	89 04 24             	mov    %eax,(%esp)
 416:	e8 22 ff ff ff       	call   33d <write>
}
 41b:	c9                   	leave  
 41c:	c3                   	ret    

0000041d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41d:	55                   	push   %ebp
 41e:	89 e5                	mov    %esp,%ebp
 420:	56                   	push   %esi
 421:	53                   	push   %ebx
 422:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 425:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 42c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 430:	74 17                	je     449 <printint+0x2c>
 432:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 436:	79 11                	jns    449 <printint+0x2c>
    neg = 1;
 438:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 43f:	8b 45 0c             	mov    0xc(%ebp),%eax
 442:	f7 d8                	neg    %eax
 444:	89 45 ec             	mov    %eax,-0x14(%ebp)
 447:	eb 06                	jmp    44f <printint+0x32>
  } else {
    x = xx;
 449:	8b 45 0c             	mov    0xc(%ebp),%eax
 44c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 44f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 456:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 459:	8d 41 01             	lea    0x1(%ecx),%eax
 45c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 45f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 462:	8b 45 ec             	mov    -0x14(%ebp),%eax
 465:	ba 00 00 00 00       	mov    $0x0,%edx
 46a:	f7 f3                	div    %ebx
 46c:	89 d0                	mov    %edx,%eax
 46e:	0f b6 80 b8 0c 00 00 	movzbl 0xcb8(%eax),%eax
 475:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 479:	8b 75 10             	mov    0x10(%ebp),%esi
 47c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 47f:	ba 00 00 00 00       	mov    $0x0,%edx
 484:	f7 f6                	div    %esi
 486:	89 45 ec             	mov    %eax,-0x14(%ebp)
 489:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48d:	75 c7                	jne    456 <printint+0x39>
  if(neg)
 48f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 493:	74 10                	je     4a5 <printint+0x88>
    buf[i++] = '-';
 495:	8b 45 f4             	mov    -0xc(%ebp),%eax
 498:	8d 50 01             	lea    0x1(%eax),%edx
 49b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 49e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4a3:	eb 1f                	jmp    4c4 <printint+0xa7>
 4a5:	eb 1d                	jmp    4c4 <printint+0xa7>
    putc(fd, buf[i]);
 4a7:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ad:	01 d0                	add    %edx,%eax
 4af:	0f b6 00             	movzbl (%eax),%eax
 4b2:	0f be c0             	movsbl %al,%eax
 4b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b9:	8b 45 08             	mov    0x8(%ebp),%eax
 4bc:	89 04 24             	mov    %eax,(%esp)
 4bf:	e8 31 ff ff ff       	call   3f5 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4c4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4cc:	79 d9                	jns    4a7 <printint+0x8a>
    putc(fd, buf[i]);
}
 4ce:	83 c4 30             	add    $0x30,%esp
 4d1:	5b                   	pop    %ebx
 4d2:	5e                   	pop    %esi
 4d3:	5d                   	pop    %ebp
 4d4:	c3                   	ret    

000004d5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d5:	55                   	push   %ebp
 4d6:	89 e5                	mov    %esp,%ebp
 4d8:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4db:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4e2:	8d 45 0c             	lea    0xc(%ebp),%eax
 4e5:	83 c0 04             	add    $0x4,%eax
 4e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4f2:	e9 7c 01 00 00       	jmp    673 <printf+0x19e>
    c = fmt[i] & 0xff;
 4f7:	8b 55 0c             	mov    0xc(%ebp),%edx
 4fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4fd:	01 d0                	add    %edx,%eax
 4ff:	0f b6 00             	movzbl (%eax),%eax
 502:	0f be c0             	movsbl %al,%eax
 505:	25 ff 00 00 00       	and    $0xff,%eax
 50a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 50d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 511:	75 2c                	jne    53f <printf+0x6a>
      if(c == '%'){
 513:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 517:	75 0c                	jne    525 <printf+0x50>
        state = '%';
 519:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 520:	e9 4a 01 00 00       	jmp    66f <printf+0x19a>
      } else {
        putc(fd, c);
 525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 528:	0f be c0             	movsbl %al,%eax
 52b:	89 44 24 04          	mov    %eax,0x4(%esp)
 52f:	8b 45 08             	mov    0x8(%ebp),%eax
 532:	89 04 24             	mov    %eax,(%esp)
 535:	e8 bb fe ff ff       	call   3f5 <putc>
 53a:	e9 30 01 00 00       	jmp    66f <printf+0x19a>
      }
    } else if(state == '%'){
 53f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 543:	0f 85 26 01 00 00    	jne    66f <printf+0x19a>
      if(c == 'd'){
 549:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 54d:	75 2d                	jne    57c <printf+0xa7>
        printint(fd, *ap, 10, 1);
 54f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 552:	8b 00                	mov    (%eax),%eax
 554:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 55b:	00 
 55c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 563:	00 
 564:	89 44 24 04          	mov    %eax,0x4(%esp)
 568:	8b 45 08             	mov    0x8(%ebp),%eax
 56b:	89 04 24             	mov    %eax,(%esp)
 56e:	e8 aa fe ff ff       	call   41d <printint>
        ap++;
 573:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 577:	e9 ec 00 00 00       	jmp    668 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 57c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 580:	74 06                	je     588 <printf+0xb3>
 582:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 586:	75 2d                	jne    5b5 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 588:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58b:	8b 00                	mov    (%eax),%eax
 58d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 594:	00 
 595:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 59c:	00 
 59d:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a1:	8b 45 08             	mov    0x8(%ebp),%eax
 5a4:	89 04 24             	mov    %eax,(%esp)
 5a7:	e8 71 fe ff ff       	call   41d <printint>
        ap++;
 5ac:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b0:	e9 b3 00 00 00       	jmp    668 <printf+0x193>
      } else if(c == 's'){
 5b5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5b9:	75 45                	jne    600 <printf+0x12b>
        s = (char*)*ap;
 5bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5be:	8b 00                	mov    (%eax),%eax
 5c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5c3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5cb:	75 09                	jne    5d6 <printf+0x101>
          s = "(null)";
 5cd:	c7 45 f4 ca 09 00 00 	movl   $0x9ca,-0xc(%ebp)
        while(*s != 0){
 5d4:	eb 1e                	jmp    5f4 <printf+0x11f>
 5d6:	eb 1c                	jmp    5f4 <printf+0x11f>
          putc(fd, *s);
 5d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5db:	0f b6 00             	movzbl (%eax),%eax
 5de:	0f be c0             	movsbl %al,%eax
 5e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e5:	8b 45 08             	mov    0x8(%ebp),%eax
 5e8:	89 04 24             	mov    %eax,(%esp)
 5eb:	e8 05 fe ff ff       	call   3f5 <putc>
          s++;
 5f0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f7:	0f b6 00             	movzbl (%eax),%eax
 5fa:	84 c0                	test   %al,%al
 5fc:	75 da                	jne    5d8 <printf+0x103>
 5fe:	eb 68                	jmp    668 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 600:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 604:	75 1d                	jne    623 <printf+0x14e>
        putc(fd, *ap);
 606:	8b 45 e8             	mov    -0x18(%ebp),%eax
 609:	8b 00                	mov    (%eax),%eax
 60b:	0f be c0             	movsbl %al,%eax
 60e:	89 44 24 04          	mov    %eax,0x4(%esp)
 612:	8b 45 08             	mov    0x8(%ebp),%eax
 615:	89 04 24             	mov    %eax,(%esp)
 618:	e8 d8 fd ff ff       	call   3f5 <putc>
        ap++;
 61d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 621:	eb 45                	jmp    668 <printf+0x193>
      } else if(c == '%'){
 623:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 627:	75 17                	jne    640 <printf+0x16b>
        putc(fd, c);
 629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62c:	0f be c0             	movsbl %al,%eax
 62f:	89 44 24 04          	mov    %eax,0x4(%esp)
 633:	8b 45 08             	mov    0x8(%ebp),%eax
 636:	89 04 24             	mov    %eax,(%esp)
 639:	e8 b7 fd ff ff       	call   3f5 <putc>
 63e:	eb 28                	jmp    668 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 640:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 647:	00 
 648:	8b 45 08             	mov    0x8(%ebp),%eax
 64b:	89 04 24             	mov    %eax,(%esp)
 64e:	e8 a2 fd ff ff       	call   3f5 <putc>
        putc(fd, c);
 653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 656:	0f be c0             	movsbl %al,%eax
 659:	89 44 24 04          	mov    %eax,0x4(%esp)
 65d:	8b 45 08             	mov    0x8(%ebp),%eax
 660:	89 04 24             	mov    %eax,(%esp)
 663:	e8 8d fd ff ff       	call   3f5 <putc>
      }
      state = 0;
 668:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 66f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 673:	8b 55 0c             	mov    0xc(%ebp),%edx
 676:	8b 45 f0             	mov    -0x10(%ebp),%eax
 679:	01 d0                	add    %edx,%eax
 67b:	0f b6 00             	movzbl (%eax),%eax
 67e:	84 c0                	test   %al,%al
 680:	0f 85 71 fe ff ff    	jne    4f7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 686:	c9                   	leave  
 687:	c3                   	ret    

00000688 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 688:	55                   	push   %ebp
 689:	89 e5                	mov    %esp,%ebp
 68b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 68e:	8b 45 08             	mov    0x8(%ebp),%eax
 691:	83 e8 08             	sub    $0x8,%eax
 694:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 697:	a1 d4 0c 00 00       	mov    0xcd4,%eax
 69c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69f:	eb 24                	jmp    6c5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a9:	77 12                	ja     6bd <free+0x35>
 6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b1:	77 24                	ja     6d7 <free+0x4f>
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	8b 00                	mov    (%eax),%eax
 6b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6bb:	77 1a                	ja     6d7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cb:	76 d4                	jbe    6a1 <free+0x19>
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d5:	76 ca                	jbe    6a1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6da:	8b 40 04             	mov    0x4(%eax),%eax
 6dd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e7:	01 c2                	add    %eax,%edx
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 00                	mov    (%eax),%eax
 6ee:	39 c2                	cmp    %eax,%edx
 6f0:	75 24                	jne    716 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f5:	8b 50 04             	mov    0x4(%eax),%edx
 6f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fb:	8b 00                	mov    (%eax),%eax
 6fd:	8b 40 04             	mov    0x4(%eax),%eax
 700:	01 c2                	add    %eax,%edx
 702:	8b 45 f8             	mov    -0x8(%ebp),%eax
 705:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 00                	mov    (%eax),%eax
 70d:	8b 10                	mov    (%eax),%edx
 70f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 712:	89 10                	mov    %edx,(%eax)
 714:	eb 0a                	jmp    720 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	8b 10                	mov    (%eax),%edx
 71b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 40 04             	mov    0x4(%eax),%eax
 726:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	01 d0                	add    %edx,%eax
 732:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 735:	75 20                	jne    757 <free+0xcf>
    p->s.size += bp->s.size;
 737:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73a:	8b 50 04             	mov    0x4(%eax),%edx
 73d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 740:	8b 40 04             	mov    0x4(%eax),%eax
 743:	01 c2                	add    %eax,%edx
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 74b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74e:	8b 10                	mov    (%eax),%edx
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	89 10                	mov    %edx,(%eax)
 755:	eb 08                	jmp    75f <free+0xd7>
  } else
    p->s.ptr = bp;
 757:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 75d:	89 10                	mov    %edx,(%eax)
  freep = p;
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	a3 d4 0c 00 00       	mov    %eax,0xcd4
}
 767:	c9                   	leave  
 768:	c3                   	ret    

00000769 <morecore>:

static Header*
morecore(uint nu)
{
 769:	55                   	push   %ebp
 76a:	89 e5                	mov    %esp,%ebp
 76c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 76f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 776:	77 07                	ja     77f <morecore+0x16>
    nu = 4096;
 778:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 77f:	8b 45 08             	mov    0x8(%ebp),%eax
 782:	c1 e0 03             	shl    $0x3,%eax
 785:	89 04 24             	mov    %eax,(%esp)
 788:	e8 18 fc ff ff       	call   3a5 <sbrk>
 78d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 790:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 794:	75 07                	jne    79d <morecore+0x34>
    return 0;
 796:	b8 00 00 00 00       	mov    $0x0,%eax
 79b:	eb 22                	jmp    7bf <morecore+0x56>
  hp = (Header*)p;
 79d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a6:	8b 55 08             	mov    0x8(%ebp),%edx
 7a9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7af:	83 c0 08             	add    $0x8,%eax
 7b2:	89 04 24             	mov    %eax,(%esp)
 7b5:	e8 ce fe ff ff       	call   688 <free>
  return freep;
 7ba:	a1 d4 0c 00 00       	mov    0xcd4,%eax
}
 7bf:	c9                   	leave  
 7c0:	c3                   	ret    

000007c1 <malloc>:

void*
malloc(uint nbytes)
{
 7c1:	55                   	push   %ebp
 7c2:	89 e5                	mov    %esp,%ebp
 7c4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c7:	8b 45 08             	mov    0x8(%ebp),%eax
 7ca:	83 c0 07             	add    $0x7,%eax
 7cd:	c1 e8 03             	shr    $0x3,%eax
 7d0:	83 c0 01             	add    $0x1,%eax
 7d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7d6:	a1 d4 0c 00 00       	mov    0xcd4,%eax
 7db:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7e2:	75 23                	jne    807 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7e4:	c7 45 f0 cc 0c 00 00 	movl   $0xccc,-0x10(%ebp)
 7eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ee:	a3 d4 0c 00 00       	mov    %eax,0xcd4
 7f3:	a1 d4 0c 00 00       	mov    0xcd4,%eax
 7f8:	a3 cc 0c 00 00       	mov    %eax,0xccc
    base.s.size = 0;
 7fd:	c7 05 d0 0c 00 00 00 	movl   $0x0,0xcd0
 804:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 807:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80a:	8b 00                	mov    (%eax),%eax
 80c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 812:	8b 40 04             	mov    0x4(%eax),%eax
 815:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 818:	72 4d                	jb     867 <malloc+0xa6>
      if(p->s.size == nunits)
 81a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81d:	8b 40 04             	mov    0x4(%eax),%eax
 820:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 823:	75 0c                	jne    831 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 825:	8b 45 f4             	mov    -0xc(%ebp),%eax
 828:	8b 10                	mov    (%eax),%edx
 82a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82d:	89 10                	mov    %edx,(%eax)
 82f:	eb 26                	jmp    857 <malloc+0x96>
      else {
        p->s.size -= nunits;
 831:	8b 45 f4             	mov    -0xc(%ebp),%eax
 834:	8b 40 04             	mov    0x4(%eax),%eax
 837:	2b 45 ec             	sub    -0x14(%ebp),%eax
 83a:	89 c2                	mov    %eax,%edx
 83c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 842:	8b 45 f4             	mov    -0xc(%ebp),%eax
 845:	8b 40 04             	mov    0x4(%eax),%eax
 848:	c1 e0 03             	shl    $0x3,%eax
 84b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 84e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 851:	8b 55 ec             	mov    -0x14(%ebp),%edx
 854:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 857:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85a:	a3 d4 0c 00 00       	mov    %eax,0xcd4
      return (void*)(p + 1);
 85f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 862:	83 c0 08             	add    $0x8,%eax
 865:	eb 38                	jmp    89f <malloc+0xde>
    }
    if(p == freep)
 867:	a1 d4 0c 00 00       	mov    0xcd4,%eax
 86c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 86f:	75 1b                	jne    88c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 871:	8b 45 ec             	mov    -0x14(%ebp),%eax
 874:	89 04 24             	mov    %eax,(%esp)
 877:	e8 ed fe ff ff       	call   769 <morecore>
 87c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 87f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 883:	75 07                	jne    88c <malloc+0xcb>
        return 0;
 885:	b8 00 00 00 00       	mov    $0x0,%eax
 88a:	eb 13                	jmp    89f <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 892:	8b 45 f4             	mov    -0xc(%ebp),%eax
 895:	8b 00                	mov    (%eax),%eax
 897:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 89a:	e9 70 ff ff ff       	jmp    80f <malloc+0x4e>
}
 89f:	c9                   	leave  
 8a0:	c3                   	ret    

000008a1 <thread_create>:
#include"x86.h"
#include"param.h"
#include"proc.h"

int thread_create(thread_t *thread, void*(*start_routine)(void*),void *arg)
{
 8a1:	55                   	push   %ebp
 8a2:	89 e5                	mov    %esp,%ebp
 8a4:	83 ec 28             	sub    $0x28,%esp
    void *stack = malloc(PGSIZE);
 8a7:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 8ae:	e8 0e ff ff ff       	call   7c1 <malloc>
 8b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if((uint)stack <=0)
 8b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b9:	85 c0                	test   %eax,%eax
 8bb:	75 1b                	jne    8d8 <thread_create+0x37>
    {
        printf(1,"malloc thread stack failed\n");
 8bd:	c7 44 24 04 d1 09 00 	movl   $0x9d1,0x4(%esp)
 8c4:	00 
 8c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8cc:	e8 04 fc ff ff       	call   4d5 <printf>
        return -1;
 8d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8d6:	eb 67                	jmp    93f <thread_create+0x9e>
    }
    
    if((uint)stack%PGSIZE)
 8d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8db:	25 ff 0f 00 00       	and    $0xfff,%eax
 8e0:	85 c0                	test   %eax,%eax
 8e2:	74 14                	je     8f8 <thread_create+0x57>
        stack += PGSIZE-((uint)stack%PGSIZE);
 8e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e7:	25 ff 0f 00 00       	and    $0xfff,%eax
 8ec:	89 c2                	mov    %eax,%edx
 8ee:	b8 00 10 00 00       	mov    $0x1000,%eax
 8f3:	29 d0                	sub    %edx,%eax
 8f5:	01 45 f4             	add    %eax,-0xc(%ebp)
    printf(1,"1\n");
 8f8:	c7 44 24 04 ed 09 00 	movl   $0x9ed,0x4(%esp)
 8ff:	00 
 900:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 907:	e8 c9 fb ff ff       	call   4d5 <printf>
    if((*thread = clone(start_routine,arg,stack))<0)
 90c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90f:	89 44 24 08          	mov    %eax,0x8(%esp)
 913:	8b 45 10             	mov    0x10(%ebp),%eax
 916:	89 44 24 04          	mov    %eax,0x4(%esp)
 91a:	8b 45 0c             	mov    0xc(%ebp),%eax
 91d:	89 04 24             	mov    %eax,(%esp)
 920:	e8 b8 fa ff ff       	call   3dd <clone>
 925:	8b 55 08             	mov    0x8(%ebp),%edx
 928:	89 02                	mov    %eax,(%edx)
 92a:	8b 45 08             	mov    0x8(%ebp),%eax
 92d:	8b 00                	mov    (%eax),%eax
 92f:	85 c0                	test   %eax,%eax
 931:	79 07                	jns    93a <thread_create+0x99>
        return -1;
 933:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 938:	eb 05                	jmp    93f <thread_create+0x9e>
    return 0;
 93a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 93f:	c9                   	leave  
 940:	c3                   	ret    

00000941 <thread_join>:

int thread_join(thread_t thread, void **retval)
{
 941:	55                   	push   %ebp
 942:	89 e5                	mov    %esp,%ebp
 944:	83 ec 28             	sub    $0x28,%esp
    void *stack;
    if(join((uint)thread, &stack, retval)<0)
 947:	8b 45 0c             	mov    0xc(%ebp),%eax
 94a:	89 44 24 08          	mov    %eax,0x8(%esp)
 94e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 951:	89 44 24 04          	mov    %eax,0x4(%esp)
 955:	8b 45 08             	mov    0x8(%ebp),%eax
 958:	89 04 24             	mov    %eax,(%esp)
 95b:	e8 85 fa ff ff       	call   3e5 <join>
 960:	85 c0                	test   %eax,%eax
 962:	79 07                	jns    96b <thread_join+0x2a>
        return -1;
 964:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 969:	eb 10                	jmp    97b <thread_join+0x3a>

    free(stack);
 96b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96e:	89 04 24             	mov    %eax,(%esp)
 971:	e8 12 fd ff ff       	call   688 <free>
    return 0;
 976:	b8 00 00 00 00       	mov    $0x0,%eax
}
 97b:	c9                   	leave  
 97c:	c3                   	ret    

0000097d <thread_exit>:

void thread_exit(void *retval)
{
 97d:	55                   	push   %ebp
 97e:	89 e5                	mov    %esp,%ebp
 980:	83 ec 08             	sub    $0x8,%esp
    proc->retval = retval;
 983:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 989:	8b 55 08             	mov    0x8(%ebp),%edx
 98c:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
    thexit();
 992:	e8 56 fa ff ff       	call   3ed <thexit>
}
 997:	c9                   	leave  
 998:	c3                   	ret    
