
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
   c:	c7 84 24 1e 02 00 00 	movl   $0x65727473,0x21e(%esp)
  13:	73 74 72 65 
  17:	c7 84 24 22 02 00 00 	movl   $0x73667373,0x222(%esp)
  1e:	73 73 66 73 
  22:	66 c7 84 24 26 02 00 	movw   $0x30,0x226(%esp)
  29:	00 30 00 
  char data[512];

  printf(1, "stressfs starting\n");
  2c:	c7 44 24 04 97 0a 00 	movl   $0xa97,0x4(%esp)
  33:	00 
  34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3b:	e8 93 05 00 00       	call   5d3 <printf>
  memset(data, 'a', sizeof(data));
  40:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  47:	00 
  48:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  4f:	00 
  50:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 12 02 00 00       	call   26e <memset>

  for(i = 0; i < 4; i++)
  5c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  63:	00 00 00 00 
  67:	eb 13                	jmp    7c <main+0x7c>
    if(fork() > 0)
  69:	e8 a5 03 00 00       	call   413 <fork>
  6e:	85 c0                	test   %eax,%eax
  70:	7e 02                	jle    74 <main+0x74>
      break;
  72:	eb 12                	jmp    86 <main+0x86>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  74:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
  7b:	01 
  7c:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
  83:	03 
  84:	7e e3                	jle    69 <main+0x69>
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);
  86:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  91:	c7 44 24 04 aa 0a 00 	movl   $0xaaa,0x4(%esp)
  98:	00 
  99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a0:	e8 2e 05 00 00       	call   5d3 <printf>

  path[8] += i;
  a5:	0f b6 84 24 26 02 00 	movzbl 0x226(%esp),%eax
  ac:	00 
  ad:	89 c2                	mov    %eax,%edx
  af:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  b6:	01 d0                	add    %edx,%eax
  b8:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  bf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c6:	00 
  c7:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
  ce:	89 04 24             	mov    %eax,(%esp)
  d1:	e8 85 03 00 00       	call   45b <open>
  d6:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
  dd:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  e4:	00 00 00 00 
  e8:	eb 27                	jmp    111 <main+0x111>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  ea:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  f1:	00 
  f2:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  fa:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 101:	89 04 24             	mov    %eax,(%esp)
 104:	e8 32 03 00 00       	call   43b <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
 109:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 110:	01 
 111:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 118:	13 
 119:	7e cf                	jle    ea <main+0xea>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
 11b:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 122:	89 04 24             	mov    %eax,(%esp)
 125:	e8 19 03 00 00       	call   443 <close>

  printf(1, "read\n");
 12a:	c7 44 24 04 b4 0a 00 	movl   $0xab4,0x4(%esp)
 131:	00 
 132:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 139:	e8 95 04 00 00       	call   5d3 <printf>

  fd = open(path, O_RDONLY);
 13e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 145:	00 
 146:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
 14d:	89 04 24             	mov    %eax,(%esp)
 150:	e8 06 03 00 00       	call   45b <open>
 155:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
 15c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 163:	00 00 00 00 
 167:	eb 27                	jmp    190 <main+0x190>
    read(fd, data, sizeof(data));
 169:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 170:	00 
 171:	8d 44 24 1e          	lea    0x1e(%esp),%eax
 175:	89 44 24 04          	mov    %eax,0x4(%esp)
 179:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 180:	89 04 24             	mov    %eax,(%esp)
 183:	e8 ab 02 00 00       	call   433 <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 188:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 18f:	01 
 190:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 197:	13 
 198:	7e cf                	jle    169 <main+0x169>
    read(fd, data, sizeof(data));
  close(fd);
 19a:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 1a1:	89 04 24             	mov    %eax,(%esp)
 1a4:	e8 9a 02 00 00       	call   443 <close>

  wait();
 1a9:	e8 75 02 00 00       	call   423 <wait>

  exit();
 1ae:	e8 68 02 00 00       	call   41b <exit>

000001b3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
 1b6:	57                   	push   %edi
 1b7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1bb:	8b 55 10             	mov    0x10(%ebp),%edx
 1be:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c1:	89 cb                	mov    %ecx,%ebx
 1c3:	89 df                	mov    %ebx,%edi
 1c5:	89 d1                	mov    %edx,%ecx
 1c7:	fc                   	cld    
 1c8:	f3 aa                	rep stos %al,%es:(%edi)
 1ca:	89 ca                	mov    %ecx,%edx
 1cc:	89 fb                	mov    %edi,%ebx
 1ce:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1d1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1d4:	5b                   	pop    %ebx
 1d5:	5f                   	pop    %edi
 1d6:	5d                   	pop    %ebp
 1d7:	c3                   	ret    

000001d8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
 1db:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
 1e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1e4:	90                   	nop
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	8d 50 01             	lea    0x1(%eax),%edx
 1eb:	89 55 08             	mov    %edx,0x8(%ebp)
 1ee:	8b 55 0c             	mov    0xc(%ebp),%edx
 1f1:	8d 4a 01             	lea    0x1(%edx),%ecx
 1f4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1f7:	0f b6 12             	movzbl (%edx),%edx
 1fa:	88 10                	mov    %dl,(%eax)
 1fc:	0f b6 00             	movzbl (%eax),%eax
 1ff:	84 c0                	test   %al,%al
 201:	75 e2                	jne    1e5 <strcpy+0xd>
    ;
  return os;
 203:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 206:	c9                   	leave  
 207:	c3                   	ret    

00000208 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 20b:	eb 08                	jmp    215 <strcmp+0xd>
    p++, q++;
 20d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 211:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	0f b6 00             	movzbl (%eax),%eax
 21b:	84 c0                	test   %al,%al
 21d:	74 10                	je     22f <strcmp+0x27>
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	0f b6 10             	movzbl (%eax),%edx
 225:	8b 45 0c             	mov    0xc(%ebp),%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	38 c2                	cmp    %al,%dl
 22d:	74 de                	je     20d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	0f b6 d0             	movzbl %al,%edx
 238:	8b 45 0c             	mov    0xc(%ebp),%eax
 23b:	0f b6 00             	movzbl (%eax),%eax
 23e:	0f b6 c0             	movzbl %al,%eax
 241:	29 c2                	sub    %eax,%edx
 243:	89 d0                	mov    %edx,%eax
}
 245:	5d                   	pop    %ebp
 246:	c3                   	ret    

00000247 <strlen>:

uint
strlen(char *s)
{
 247:	55                   	push   %ebp
 248:	89 e5                	mov    %esp,%ebp
 24a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 24d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 254:	eb 04                	jmp    25a <strlen+0x13>
 256:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 25a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
 260:	01 d0                	add    %edx,%eax
 262:	0f b6 00             	movzbl (%eax),%eax
 265:	84 c0                	test   %al,%al
 267:	75 ed                	jne    256 <strlen+0xf>
    ;
  return n;
 269:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 26c:	c9                   	leave  
 26d:	c3                   	ret    

0000026e <memset>:

void*
memset(void *dst, int c, uint n)
{
 26e:	55                   	push   %ebp
 26f:	89 e5                	mov    %esp,%ebp
 271:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 274:	8b 45 10             	mov    0x10(%ebp),%eax
 277:	89 44 24 08          	mov    %eax,0x8(%esp)
 27b:	8b 45 0c             	mov    0xc(%ebp),%eax
 27e:	89 44 24 04          	mov    %eax,0x4(%esp)
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	89 04 24             	mov    %eax,(%esp)
 288:	e8 26 ff ff ff       	call   1b3 <stosb>
  return dst;
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 290:	c9                   	leave  
 291:	c3                   	ret    

00000292 <strchr>:

char*
strchr(const char *s, char c)
{
 292:	55                   	push   %ebp
 293:	89 e5                	mov    %esp,%ebp
 295:	83 ec 04             	sub    $0x4,%esp
 298:	8b 45 0c             	mov    0xc(%ebp),%eax
 29b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29e:	eb 14                	jmp    2b4 <strchr+0x22>
    if(*s == c)
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	0f b6 00             	movzbl (%eax),%eax
 2a6:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2a9:	75 05                	jne    2b0 <strchr+0x1e>
      return (char*)s;
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	eb 13                	jmp    2c3 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	0f b6 00             	movzbl (%eax),%eax
 2ba:	84 c0                	test   %al,%al
 2bc:	75 e2                	jne    2a0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2be:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c3:	c9                   	leave  
 2c4:	c3                   	ret    

000002c5 <gets>:

char*
gets(char *buf, int max)
{
 2c5:	55                   	push   %ebp
 2c6:	89 e5                	mov    %esp,%ebp
 2c8:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d2:	eb 4c                	jmp    320 <gets+0x5b>
    cc = read(0, &c, 1);
 2d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2db:	00 
 2dc:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2df:	89 44 24 04          	mov    %eax,0x4(%esp)
 2e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2ea:	e8 44 01 00 00       	call   433 <read>
 2ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2f6:	7f 02                	jg     2fa <gets+0x35>
      break;
 2f8:	eb 31                	jmp    32b <gets+0x66>
    buf[i++] = c;
 2fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2fd:	8d 50 01             	lea    0x1(%eax),%edx
 300:	89 55 f4             	mov    %edx,-0xc(%ebp)
 303:	89 c2                	mov    %eax,%edx
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	01 c2                	add    %eax,%edx
 30a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 310:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 314:	3c 0a                	cmp    $0xa,%al
 316:	74 13                	je     32b <gets+0x66>
 318:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 31c:	3c 0d                	cmp    $0xd,%al
 31e:	74 0b                	je     32b <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 320:	8b 45 f4             	mov    -0xc(%ebp),%eax
 323:	83 c0 01             	add    $0x1,%eax
 326:	3b 45 0c             	cmp    0xc(%ebp),%eax
 329:	7c a9                	jl     2d4 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 32b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	01 d0                	add    %edx,%eax
 333:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 336:	8b 45 08             	mov    0x8(%ebp),%eax
}
 339:	c9                   	leave  
 33a:	c3                   	ret    

0000033b <stat>:

int
stat(char *n, struct stat *st)
{
 33b:	55                   	push   %ebp
 33c:	89 e5                	mov    %esp,%ebp
 33e:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 341:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 348:	00 
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	89 04 24             	mov    %eax,(%esp)
 34f:	e8 07 01 00 00       	call   45b <open>
 354:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 357:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 35b:	79 07                	jns    364 <stat+0x29>
    return -1;
 35d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 362:	eb 23                	jmp    387 <stat+0x4c>
  r = fstat(fd, st);
 364:	8b 45 0c             	mov    0xc(%ebp),%eax
 367:	89 44 24 04          	mov    %eax,0x4(%esp)
 36b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 36e:	89 04 24             	mov    %eax,(%esp)
 371:	e8 fd 00 00 00       	call   473 <fstat>
 376:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 379:	8b 45 f4             	mov    -0xc(%ebp),%eax
 37c:	89 04 24             	mov    %eax,(%esp)
 37f:	e8 bf 00 00 00       	call   443 <close>
  return r;
 384:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 387:	c9                   	leave  
 388:	c3                   	ret    

00000389 <atoi>:

int
atoi(const char *s)
{
 389:	55                   	push   %ebp
 38a:	89 e5                	mov    %esp,%ebp
 38c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 38f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 396:	eb 25                	jmp    3bd <atoi+0x34>
    n = n*10 + *s++ - '0';
 398:	8b 55 fc             	mov    -0x4(%ebp),%edx
 39b:	89 d0                	mov    %edx,%eax
 39d:	c1 e0 02             	shl    $0x2,%eax
 3a0:	01 d0                	add    %edx,%eax
 3a2:	01 c0                	add    %eax,%eax
 3a4:	89 c1                	mov    %eax,%ecx
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
 3a9:	8d 50 01             	lea    0x1(%eax),%edx
 3ac:	89 55 08             	mov    %edx,0x8(%ebp)
 3af:	0f b6 00             	movzbl (%eax),%eax
 3b2:	0f be c0             	movsbl %al,%eax
 3b5:	01 c8                	add    %ecx,%eax
 3b7:	83 e8 30             	sub    $0x30,%eax
 3ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	0f b6 00             	movzbl (%eax),%eax
 3c3:	3c 2f                	cmp    $0x2f,%al
 3c5:	7e 0a                	jle    3d1 <atoi+0x48>
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	0f b6 00             	movzbl (%eax),%eax
 3cd:	3c 39                	cmp    $0x39,%al
 3cf:	7e c7                	jle    398 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3d4:	c9                   	leave  
 3d5:	c3                   	ret    

000003d6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3d6:	55                   	push   %ebp
 3d7:	89 e5                	mov    %esp,%ebp
 3d9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 3dc:	8b 45 08             	mov    0x8(%ebp),%eax
 3df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3e8:	eb 17                	jmp    401 <memmove+0x2b>
    *dst++ = *src++;
 3ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ed:	8d 50 01             	lea    0x1(%eax),%edx
 3f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3f6:	8d 4a 01             	lea    0x1(%edx),%ecx
 3f9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3fc:	0f b6 12             	movzbl (%edx),%edx
 3ff:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 401:	8b 45 10             	mov    0x10(%ebp),%eax
 404:	8d 50 ff             	lea    -0x1(%eax),%edx
 407:	89 55 10             	mov    %edx,0x10(%ebp)
 40a:	85 c0                	test   %eax,%eax
 40c:	7f dc                	jg     3ea <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 40e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 411:	c9                   	leave  
 412:	c3                   	ret    

00000413 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 413:	b8 01 00 00 00       	mov    $0x1,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <exit>:
SYSCALL(exit)
 41b:	b8 02 00 00 00       	mov    $0x2,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <wait>:
SYSCALL(wait)
 423:	b8 03 00 00 00       	mov    $0x3,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <pipe>:
SYSCALL(pipe)
 42b:	b8 04 00 00 00       	mov    $0x4,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <read>:
SYSCALL(read)
 433:	b8 05 00 00 00       	mov    $0x5,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <write>:
SYSCALL(write)
 43b:	b8 10 00 00 00       	mov    $0x10,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <close>:
SYSCALL(close)
 443:	b8 15 00 00 00       	mov    $0x15,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <kill>:
SYSCALL(kill)
 44b:	b8 06 00 00 00       	mov    $0x6,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <exec>:
SYSCALL(exec)
 453:	b8 07 00 00 00       	mov    $0x7,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <open>:
SYSCALL(open)
 45b:	b8 0f 00 00 00       	mov    $0xf,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <mknod>:
SYSCALL(mknod)
 463:	b8 11 00 00 00       	mov    $0x11,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <unlink>:
SYSCALL(unlink)
 46b:	b8 12 00 00 00       	mov    $0x12,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <fstat>:
SYSCALL(fstat)
 473:	b8 08 00 00 00       	mov    $0x8,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <link>:
SYSCALL(link)
 47b:	b8 13 00 00 00       	mov    $0x13,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <mkdir>:
SYSCALL(mkdir)
 483:	b8 14 00 00 00       	mov    $0x14,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <chdir>:
SYSCALL(chdir)
 48b:	b8 09 00 00 00       	mov    $0x9,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <dup>:
SYSCALL(dup)
 493:	b8 0a 00 00 00       	mov    $0xa,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <getpid>:
SYSCALL(getpid)
 49b:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <sbrk>:
SYSCALL(sbrk)
 4a3:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <sleep>:
SYSCALL(sleep)
 4ab:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <uptime>:
SYSCALL(uptime)
 4b3:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <my_syscall>:
SYSCALL(my_syscall)
 4bb:	b8 16 00 00 00       	mov    $0x16,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <getppid>:
SYSCALL(getppid)
 4c3:	b8 17 00 00 00       	mov    $0x17,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <yield>:
SYSCALL(yield)
 4cb:	b8 18 00 00 00       	mov    $0x18,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <getlev>:
SYSCALL(getlev)
 4d3:	b8 19 00 00 00       	mov    $0x19,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <clone>:
SYSCALL(clone)
 4db:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <join>:
SYSCALL(join)
 4e3:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <thexit>:
SYSCALL(thexit)
 4eb:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4f3:	55                   	push   %ebp
 4f4:	89 e5                	mov    %esp,%ebp
 4f6:	83 ec 18             	sub    $0x18,%esp
 4f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fc:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4ff:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 506:	00 
 507:	8d 45 f4             	lea    -0xc(%ebp),%eax
 50a:	89 44 24 04          	mov    %eax,0x4(%esp)
 50e:	8b 45 08             	mov    0x8(%ebp),%eax
 511:	89 04 24             	mov    %eax,(%esp)
 514:	e8 22 ff ff ff       	call   43b <write>
}
 519:	c9                   	leave  
 51a:	c3                   	ret    

0000051b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 51b:	55                   	push   %ebp
 51c:	89 e5                	mov    %esp,%ebp
 51e:	56                   	push   %esi
 51f:	53                   	push   %ebx
 520:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 523:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 52a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 52e:	74 17                	je     547 <printint+0x2c>
 530:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 534:	79 11                	jns    547 <printint+0x2c>
    neg = 1;
 536:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 53d:	8b 45 0c             	mov    0xc(%ebp),%eax
 540:	f7 d8                	neg    %eax
 542:	89 45 ec             	mov    %eax,-0x14(%ebp)
 545:	eb 06                	jmp    54d <printint+0x32>
  } else {
    x = xx;
 547:	8b 45 0c             	mov    0xc(%ebp),%eax
 54a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 54d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 554:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 557:	8d 41 01             	lea    0x1(%ecx),%eax
 55a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 55d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 560:	8b 45 ec             	mov    -0x14(%ebp),%eax
 563:	ba 00 00 00 00       	mov    $0x0,%edx
 568:	f7 f3                	div    %ebx
 56a:	89 d0                	mov    %edx,%eax
 56c:	0f b6 80 84 0d 00 00 	movzbl 0xd84(%eax),%eax
 573:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 577:	8b 75 10             	mov    0x10(%ebp),%esi
 57a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 57d:	ba 00 00 00 00       	mov    $0x0,%edx
 582:	f7 f6                	div    %esi
 584:	89 45 ec             	mov    %eax,-0x14(%ebp)
 587:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 58b:	75 c7                	jne    554 <printint+0x39>
  if(neg)
 58d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 591:	74 10                	je     5a3 <printint+0x88>
    buf[i++] = '-';
 593:	8b 45 f4             	mov    -0xc(%ebp),%eax
 596:	8d 50 01             	lea    0x1(%eax),%edx
 599:	89 55 f4             	mov    %edx,-0xc(%ebp)
 59c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5a1:	eb 1f                	jmp    5c2 <printint+0xa7>
 5a3:	eb 1d                	jmp    5c2 <printint+0xa7>
    putc(fd, buf[i]);
 5a5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ab:	01 d0                	add    %edx,%eax
 5ad:	0f b6 00             	movzbl (%eax),%eax
 5b0:	0f be c0             	movsbl %al,%eax
 5b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ba:	89 04 24             	mov    %eax,(%esp)
 5bd:	e8 31 ff ff ff       	call   4f3 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5c2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ca:	79 d9                	jns    5a5 <printint+0x8a>
    putc(fd, buf[i]);
}
 5cc:	83 c4 30             	add    $0x30,%esp
 5cf:	5b                   	pop    %ebx
 5d0:	5e                   	pop    %esi
 5d1:	5d                   	pop    %ebp
 5d2:	c3                   	ret    

000005d3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5d3:	55                   	push   %ebp
 5d4:	89 e5                	mov    %esp,%ebp
 5d6:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5d9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5e0:	8d 45 0c             	lea    0xc(%ebp),%eax
 5e3:	83 c0 04             	add    $0x4,%eax
 5e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5f0:	e9 7c 01 00 00       	jmp    771 <printf+0x19e>
    c = fmt[i] & 0xff;
 5f5:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5fb:	01 d0                	add    %edx,%eax
 5fd:	0f b6 00             	movzbl (%eax),%eax
 600:	0f be c0             	movsbl %al,%eax
 603:	25 ff 00 00 00       	and    $0xff,%eax
 608:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 60b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 60f:	75 2c                	jne    63d <printf+0x6a>
      if(c == '%'){
 611:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 615:	75 0c                	jne    623 <printf+0x50>
        state = '%';
 617:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 61e:	e9 4a 01 00 00       	jmp    76d <printf+0x19a>
      } else {
        putc(fd, c);
 623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 626:	0f be c0             	movsbl %al,%eax
 629:	89 44 24 04          	mov    %eax,0x4(%esp)
 62d:	8b 45 08             	mov    0x8(%ebp),%eax
 630:	89 04 24             	mov    %eax,(%esp)
 633:	e8 bb fe ff ff       	call   4f3 <putc>
 638:	e9 30 01 00 00       	jmp    76d <printf+0x19a>
      }
    } else if(state == '%'){
 63d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 641:	0f 85 26 01 00 00    	jne    76d <printf+0x19a>
      if(c == 'd'){
 647:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 64b:	75 2d                	jne    67a <printf+0xa7>
        printint(fd, *ap, 10, 1);
 64d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 650:	8b 00                	mov    (%eax),%eax
 652:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 659:	00 
 65a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 661:	00 
 662:	89 44 24 04          	mov    %eax,0x4(%esp)
 666:	8b 45 08             	mov    0x8(%ebp),%eax
 669:	89 04 24             	mov    %eax,(%esp)
 66c:	e8 aa fe ff ff       	call   51b <printint>
        ap++;
 671:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 675:	e9 ec 00 00 00       	jmp    766 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 67a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 67e:	74 06                	je     686 <printf+0xb3>
 680:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 684:	75 2d                	jne    6b3 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 686:	8b 45 e8             	mov    -0x18(%ebp),%eax
 689:	8b 00                	mov    (%eax),%eax
 68b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 692:	00 
 693:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 69a:	00 
 69b:	89 44 24 04          	mov    %eax,0x4(%esp)
 69f:	8b 45 08             	mov    0x8(%ebp),%eax
 6a2:	89 04 24             	mov    %eax,(%esp)
 6a5:	e8 71 fe ff ff       	call   51b <printint>
        ap++;
 6aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ae:	e9 b3 00 00 00       	jmp    766 <printf+0x193>
      } else if(c == 's'){
 6b3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6b7:	75 45                	jne    6fe <printf+0x12b>
        s = (char*)*ap;
 6b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6bc:	8b 00                	mov    (%eax),%eax
 6be:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6c1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6c9:	75 09                	jne    6d4 <printf+0x101>
          s = "(null)";
 6cb:	c7 45 f4 ba 0a 00 00 	movl   $0xaba,-0xc(%ebp)
        while(*s != 0){
 6d2:	eb 1e                	jmp    6f2 <printf+0x11f>
 6d4:	eb 1c                	jmp    6f2 <printf+0x11f>
          putc(fd, *s);
 6d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d9:	0f b6 00             	movzbl (%eax),%eax
 6dc:	0f be c0             	movsbl %al,%eax
 6df:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e3:	8b 45 08             	mov    0x8(%ebp),%eax
 6e6:	89 04 24             	mov    %eax,(%esp)
 6e9:	e8 05 fe ff ff       	call   4f3 <putc>
          s++;
 6ee:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f5:	0f b6 00             	movzbl (%eax),%eax
 6f8:	84 c0                	test   %al,%al
 6fa:	75 da                	jne    6d6 <printf+0x103>
 6fc:	eb 68                	jmp    766 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6fe:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 702:	75 1d                	jne    721 <printf+0x14e>
        putc(fd, *ap);
 704:	8b 45 e8             	mov    -0x18(%ebp),%eax
 707:	8b 00                	mov    (%eax),%eax
 709:	0f be c0             	movsbl %al,%eax
 70c:	89 44 24 04          	mov    %eax,0x4(%esp)
 710:	8b 45 08             	mov    0x8(%ebp),%eax
 713:	89 04 24             	mov    %eax,(%esp)
 716:	e8 d8 fd ff ff       	call   4f3 <putc>
        ap++;
 71b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 71f:	eb 45                	jmp    766 <printf+0x193>
      } else if(c == '%'){
 721:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 725:	75 17                	jne    73e <printf+0x16b>
        putc(fd, c);
 727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 72a:	0f be c0             	movsbl %al,%eax
 72d:	89 44 24 04          	mov    %eax,0x4(%esp)
 731:	8b 45 08             	mov    0x8(%ebp),%eax
 734:	89 04 24             	mov    %eax,(%esp)
 737:	e8 b7 fd ff ff       	call   4f3 <putc>
 73c:	eb 28                	jmp    766 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 73e:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 745:	00 
 746:	8b 45 08             	mov    0x8(%ebp),%eax
 749:	89 04 24             	mov    %eax,(%esp)
 74c:	e8 a2 fd ff ff       	call   4f3 <putc>
        putc(fd, c);
 751:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 754:	0f be c0             	movsbl %al,%eax
 757:	89 44 24 04          	mov    %eax,0x4(%esp)
 75b:	8b 45 08             	mov    0x8(%ebp),%eax
 75e:	89 04 24             	mov    %eax,(%esp)
 761:	e8 8d fd ff ff       	call   4f3 <putc>
      }
      state = 0;
 766:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 76d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 771:	8b 55 0c             	mov    0xc(%ebp),%edx
 774:	8b 45 f0             	mov    -0x10(%ebp),%eax
 777:	01 d0                	add    %edx,%eax
 779:	0f b6 00             	movzbl (%eax),%eax
 77c:	84 c0                	test   %al,%al
 77e:	0f 85 71 fe ff ff    	jne    5f5 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 784:	c9                   	leave  
 785:	c3                   	ret    

00000786 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 786:	55                   	push   %ebp
 787:	89 e5                	mov    %esp,%ebp
 789:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 78c:	8b 45 08             	mov    0x8(%ebp),%eax
 78f:	83 e8 08             	sub    $0x8,%eax
 792:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 795:	a1 a0 0d 00 00       	mov    0xda0,%eax
 79a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 79d:	eb 24                	jmp    7c3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a2:	8b 00                	mov    (%eax),%eax
 7a4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a7:	77 12                	ja     7bb <free+0x35>
 7a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7af:	77 24                	ja     7d5 <free+0x4f>
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	8b 00                	mov    (%eax),%eax
 7b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b9:	77 1a                	ja     7d5 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7be:	8b 00                	mov    (%eax),%eax
 7c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c9:	76 d4                	jbe    79f <free+0x19>
 7cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ce:	8b 00                	mov    (%eax),%eax
 7d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d3:	76 ca                	jbe    79f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d8:	8b 40 04             	mov    0x4(%eax),%eax
 7db:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e5:	01 c2                	add    %eax,%edx
 7e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ea:	8b 00                	mov    (%eax),%eax
 7ec:	39 c2                	cmp    %eax,%edx
 7ee:	75 24                	jne    814 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f3:	8b 50 04             	mov    0x4(%eax),%edx
 7f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f9:	8b 00                	mov    (%eax),%eax
 7fb:	8b 40 04             	mov    0x4(%eax),%eax
 7fe:	01 c2                	add    %eax,%edx
 800:	8b 45 f8             	mov    -0x8(%ebp),%eax
 803:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 806:	8b 45 fc             	mov    -0x4(%ebp),%eax
 809:	8b 00                	mov    (%eax),%eax
 80b:	8b 10                	mov    (%eax),%edx
 80d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 810:	89 10                	mov    %edx,(%eax)
 812:	eb 0a                	jmp    81e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 814:	8b 45 fc             	mov    -0x4(%ebp),%eax
 817:	8b 10                	mov    (%eax),%edx
 819:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 81e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 821:	8b 40 04             	mov    0x4(%eax),%eax
 824:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 82b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82e:	01 d0                	add    %edx,%eax
 830:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 833:	75 20                	jne    855 <free+0xcf>
    p->s.size += bp->s.size;
 835:	8b 45 fc             	mov    -0x4(%ebp),%eax
 838:	8b 50 04             	mov    0x4(%eax),%edx
 83b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83e:	8b 40 04             	mov    0x4(%eax),%eax
 841:	01 c2                	add    %eax,%edx
 843:	8b 45 fc             	mov    -0x4(%ebp),%eax
 846:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 849:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84c:	8b 10                	mov    (%eax),%edx
 84e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 851:	89 10                	mov    %edx,(%eax)
 853:	eb 08                	jmp    85d <free+0xd7>
  } else
    p->s.ptr = bp;
 855:	8b 45 fc             	mov    -0x4(%ebp),%eax
 858:	8b 55 f8             	mov    -0x8(%ebp),%edx
 85b:	89 10                	mov    %edx,(%eax)
  freep = p;
 85d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 860:	a3 a0 0d 00 00       	mov    %eax,0xda0
}
 865:	c9                   	leave  
 866:	c3                   	ret    

00000867 <morecore>:

static Header*
morecore(uint nu)
{
 867:	55                   	push   %ebp
 868:	89 e5                	mov    %esp,%ebp
 86a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 86d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 874:	77 07                	ja     87d <morecore+0x16>
    nu = 4096;
 876:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 87d:	8b 45 08             	mov    0x8(%ebp),%eax
 880:	c1 e0 03             	shl    $0x3,%eax
 883:	89 04 24             	mov    %eax,(%esp)
 886:	e8 18 fc ff ff       	call   4a3 <sbrk>
 88b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 88e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 892:	75 07                	jne    89b <morecore+0x34>
    return 0;
 894:	b8 00 00 00 00       	mov    $0x0,%eax
 899:	eb 22                	jmp    8bd <morecore+0x56>
  hp = (Header*)p;
 89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a4:	8b 55 08             	mov    0x8(%ebp),%edx
 8a7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ad:	83 c0 08             	add    $0x8,%eax
 8b0:	89 04 24             	mov    %eax,(%esp)
 8b3:	e8 ce fe ff ff       	call   786 <free>
  return freep;
 8b8:	a1 a0 0d 00 00       	mov    0xda0,%eax
}
 8bd:	c9                   	leave  
 8be:	c3                   	ret    

000008bf <malloc>:

void*
malloc(uint nbytes)
{
 8bf:	55                   	push   %ebp
 8c0:	89 e5                	mov    %esp,%ebp
 8c2:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c5:	8b 45 08             	mov    0x8(%ebp),%eax
 8c8:	83 c0 07             	add    $0x7,%eax
 8cb:	c1 e8 03             	shr    $0x3,%eax
 8ce:	83 c0 01             	add    $0x1,%eax
 8d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8d4:	a1 a0 0d 00 00       	mov    0xda0,%eax
 8d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8e0:	75 23                	jne    905 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8e2:	c7 45 f0 98 0d 00 00 	movl   $0xd98,-0x10(%ebp)
 8e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ec:	a3 a0 0d 00 00       	mov    %eax,0xda0
 8f1:	a1 a0 0d 00 00       	mov    0xda0,%eax
 8f6:	a3 98 0d 00 00       	mov    %eax,0xd98
    base.s.size = 0;
 8fb:	c7 05 9c 0d 00 00 00 	movl   $0x0,0xd9c
 902:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 905:	8b 45 f0             	mov    -0x10(%ebp),%eax
 908:	8b 00                	mov    (%eax),%eax
 90a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 90d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 910:	8b 40 04             	mov    0x4(%eax),%eax
 913:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 916:	72 4d                	jb     965 <malloc+0xa6>
      if(p->s.size == nunits)
 918:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91b:	8b 40 04             	mov    0x4(%eax),%eax
 91e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 921:	75 0c                	jne    92f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 923:	8b 45 f4             	mov    -0xc(%ebp),%eax
 926:	8b 10                	mov    (%eax),%edx
 928:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92b:	89 10                	mov    %edx,(%eax)
 92d:	eb 26                	jmp    955 <malloc+0x96>
      else {
        p->s.size -= nunits;
 92f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 932:	8b 40 04             	mov    0x4(%eax),%eax
 935:	2b 45 ec             	sub    -0x14(%ebp),%eax
 938:	89 c2                	mov    %eax,%edx
 93a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 940:	8b 45 f4             	mov    -0xc(%ebp),%eax
 943:	8b 40 04             	mov    0x4(%eax),%eax
 946:	c1 e0 03             	shl    $0x3,%eax
 949:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 94c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 952:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 955:	8b 45 f0             	mov    -0x10(%ebp),%eax
 958:	a3 a0 0d 00 00       	mov    %eax,0xda0
      return (void*)(p + 1);
 95d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 960:	83 c0 08             	add    $0x8,%eax
 963:	eb 38                	jmp    99d <malloc+0xde>
    }
    if(p == freep)
 965:	a1 a0 0d 00 00       	mov    0xda0,%eax
 96a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 96d:	75 1b                	jne    98a <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 96f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 972:	89 04 24             	mov    %eax,(%esp)
 975:	e8 ed fe ff ff       	call   867 <morecore>
 97a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 97d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 981:	75 07                	jne    98a <malloc+0xcb>
        return 0;
 983:	b8 00 00 00 00       	mov    $0x0,%eax
 988:	eb 13                	jmp    99d <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 990:	8b 45 f4             	mov    -0xc(%ebp),%eax
 993:	8b 00                	mov    (%eax),%eax
 995:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 998:	e9 70 ff ff ff       	jmp    90d <malloc+0x4e>
}
 99d:	c9                   	leave  
 99e:	c3                   	ret    

0000099f <thread_create>:
#include"x86.h"
#include"param.h"
#include"proc.h"

int thread_create(thread_t *thread, void*(*start_routine)(void*),void *arg)
{
 99f:	55                   	push   %ebp
 9a0:	89 e5                	mov    %esp,%ebp
 9a2:	83 ec 28             	sub    $0x28,%esp
    void *stack = malloc(PGSIZE);
 9a5:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 9ac:	e8 0e ff ff ff       	call   8bf <malloc>
 9b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if((uint)stack <=0)
 9b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b7:	85 c0                	test   %eax,%eax
 9b9:	75 1b                	jne    9d6 <thread_create+0x37>
    {
        printf(1,"malloc thread stack failed\n");
 9bb:	c7 44 24 04 c1 0a 00 	movl   $0xac1,0x4(%esp)
 9c2:	00 
 9c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9ca:	e8 04 fc ff ff       	call   5d3 <printf>
        return -1;
 9cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9d4:	eb 67                	jmp    a3d <thread_create+0x9e>
    }
    
    if((uint)stack%PGSIZE)
 9d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d9:	25 ff 0f 00 00       	and    $0xfff,%eax
 9de:	85 c0                	test   %eax,%eax
 9e0:	74 14                	je     9f6 <thread_create+0x57>
        stack += PGSIZE-((uint)stack%PGSIZE);
 9e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e5:	25 ff 0f 00 00       	and    $0xfff,%eax
 9ea:	89 c2                	mov    %eax,%edx
 9ec:	b8 00 10 00 00       	mov    $0x1000,%eax
 9f1:	29 d0                	sub    %edx,%eax
 9f3:	01 45 f4             	add    %eax,-0xc(%ebp)
    printf(1,"1\n");
 9f6:	c7 44 24 04 dd 0a 00 	movl   $0xadd,0x4(%esp)
 9fd:	00 
 9fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a05:	e8 c9 fb ff ff       	call   5d3 <printf>
    if((*thread = clone(start_routine,arg,stack))<0)
 a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0d:	89 44 24 08          	mov    %eax,0x8(%esp)
 a11:	8b 45 10             	mov    0x10(%ebp),%eax
 a14:	89 44 24 04          	mov    %eax,0x4(%esp)
 a18:	8b 45 0c             	mov    0xc(%ebp),%eax
 a1b:	89 04 24             	mov    %eax,(%esp)
 a1e:	e8 b8 fa ff ff       	call   4db <clone>
 a23:	8b 55 08             	mov    0x8(%ebp),%edx
 a26:	89 02                	mov    %eax,(%edx)
 a28:	8b 45 08             	mov    0x8(%ebp),%eax
 a2b:	8b 00                	mov    (%eax),%eax
 a2d:	85 c0                	test   %eax,%eax
 a2f:	79 07                	jns    a38 <thread_create+0x99>
        return -1;
 a31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a36:	eb 05                	jmp    a3d <thread_create+0x9e>
    return 0;
 a38:	b8 00 00 00 00       	mov    $0x0,%eax
}
 a3d:	c9                   	leave  
 a3e:	c3                   	ret    

00000a3f <thread_join>:

int thread_join(thread_t thread, void **retval)
{
 a3f:	55                   	push   %ebp
 a40:	89 e5                	mov    %esp,%ebp
 a42:	83 ec 28             	sub    $0x28,%esp
    void *stack;
    if(join((uint)thread, &stack, retval)<0)
 a45:	8b 45 0c             	mov    0xc(%ebp),%eax
 a48:	89 44 24 08          	mov    %eax,0x8(%esp)
 a4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
 a53:	8b 45 08             	mov    0x8(%ebp),%eax
 a56:	89 04 24             	mov    %eax,(%esp)
 a59:	e8 85 fa ff ff       	call   4e3 <join>
 a5e:	85 c0                	test   %eax,%eax
 a60:	79 07                	jns    a69 <thread_join+0x2a>
        return -1;
 a62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a67:	eb 10                	jmp    a79 <thread_join+0x3a>

    free(stack);
 a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6c:	89 04 24             	mov    %eax,(%esp)
 a6f:	e8 12 fd ff ff       	call   786 <free>
    return 0;
 a74:	b8 00 00 00 00       	mov    $0x0,%eax
}
 a79:	c9                   	leave  
 a7a:	c3                   	ret    

00000a7b <thread_exit>:

void thread_exit(void *retval)
{
 a7b:	55                   	push   %ebp
 a7c:	89 e5                	mov    %esp,%ebp
 a7e:	83 ec 08             	sub    $0x8,%esp
    proc->retval = retval;
 a81:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 a87:	8b 55 08             	mov    0x8(%ebp),%edx
 a8a:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
    thexit();
 a90:	e8 56 fa ff ff       	call   4eb <thexit>
}
 a95:	c9                   	leave  
 a96:	c3                   	ret    
