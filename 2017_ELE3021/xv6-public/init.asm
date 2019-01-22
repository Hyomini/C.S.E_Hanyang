
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 f6 09 00 00 	movl   $0x9f6,(%esp)
  18:	e8 9a 03 00 00       	call   3b7 <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 f6 09 00 00 	movl   $0x9f6,(%esp)
  38:	e8 82 03 00 00       	call   3bf <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 f6 09 00 00 	movl   $0x9f6,(%esp)
  4c:	e8 66 03 00 00       	call   3b7 <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 92 03 00 00       	call   3ef <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 86 03 00 00       	call   3ef <dup>

  for(;;){
    printf(1, "init: starting sh\n");
  69:	c7 44 24 04 fe 09 00 	movl   $0x9fe,0x4(%esp)
  70:	00 
  71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  78:	e8 b2 04 00 00       	call   52f <printf>
    pid = fork();
  7d:	e8 ed 02 00 00       	call   36f <fork>
  82:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  86:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8b:	79 19                	jns    a6 <main+0xa6>
      printf(1, "init: fork failed\n");
  8d:	c7 44 24 04 11 0a 00 	movl   $0xa11,0x4(%esp)
  94:	00 
  95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9c:	e8 8e 04 00 00       	call   52f <printf>
      exit();
  a1:	e8 d1 02 00 00       	call   377 <exit>
    }
    if(pid == 0){
  a6:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ab:	75 2d                	jne    da <main+0xda>
      exec("sh", argv);
  ad:	c7 44 24 04 10 0d 00 	movl   $0xd10,0x4(%esp)
  b4:	00 
  b5:	c7 04 24 f3 09 00 00 	movl   $0x9f3,(%esp)
  bc:	e8 ee 02 00 00       	call   3af <exec>
      printf(1, "init: exec sh failed\n");
  c1:	c7 44 24 04 24 0a 00 	movl   $0xa24,0x4(%esp)
  c8:	00 
  c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d0:	e8 5a 04 00 00       	call   52f <printf>
      exit();
  d5:	e8 9d 02 00 00       	call   377 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  da:	eb 14                	jmp    f0 <main+0xf0>
      printf(1, "zombie!\n");
  dc:	c7 44 24 04 3a 0a 00 	movl   $0xa3a,0x4(%esp)
  e3:	00 
  e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  eb:	e8 3f 04 00 00       	call   52f <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  f0:	e8 8a 02 00 00       	call   37f <wait>
  f5:	89 44 24 18          	mov    %eax,0x18(%esp)
  f9:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  fe:	78 0a                	js     10a <main+0x10a>
 100:	8b 44 24 18          	mov    0x18(%esp),%eax
 104:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 108:	75 d2                	jne    dc <main+0xdc>
      printf(1, "zombie!\n");
  }
 10a:	e9 5a ff ff ff       	jmp    69 <main+0x69>

0000010f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	57                   	push   %edi
 113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 114:	8b 4d 08             	mov    0x8(%ebp),%ecx
 117:	8b 55 10             	mov    0x10(%ebp),%edx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 cb                	mov    %ecx,%ebx
 11f:	89 df                	mov    %ebx,%edi
 121:	89 d1                	mov    %edx,%ecx
 123:	fc                   	cld    
 124:	f3 aa                	rep stos %al,%es:(%edi)
 126:	89 ca                	mov    %ecx,%edx
 128:	89 fb                	mov    %edi,%ebx
 12a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 130:	5b                   	pop    %ebx
 131:	5f                   	pop    %edi
 132:	5d                   	pop    %ebp
 133:	c3                   	ret    

00000134 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 140:	90                   	nop
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	8d 50 01             	lea    0x1(%eax),%edx
 147:	89 55 08             	mov    %edx,0x8(%ebp)
 14a:	8b 55 0c             	mov    0xc(%ebp),%edx
 14d:	8d 4a 01             	lea    0x1(%edx),%ecx
 150:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 153:	0f b6 12             	movzbl (%edx),%edx
 156:	88 10                	mov    %dl,(%eax)
 158:	0f b6 00             	movzbl (%eax),%eax
 15b:	84 c0                	test   %al,%al
 15d:	75 e2                	jne    141 <strcpy+0xd>
    ;
  return os;
 15f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 162:	c9                   	leave  
 163:	c3                   	ret    

00000164 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 167:	eb 08                	jmp    171 <strcmp+0xd>
    p++, q++;
 169:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	0f b6 00             	movzbl (%eax),%eax
 177:	84 c0                	test   %al,%al
 179:	74 10                	je     18b <strcmp+0x27>
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	0f b6 10             	movzbl (%eax),%edx
 181:	8b 45 0c             	mov    0xc(%ebp),%eax
 184:	0f b6 00             	movzbl (%eax),%eax
 187:	38 c2                	cmp    %al,%dl
 189:	74 de                	je     169 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	0f b6 00             	movzbl (%eax),%eax
 191:	0f b6 d0             	movzbl %al,%edx
 194:	8b 45 0c             	mov    0xc(%ebp),%eax
 197:	0f b6 00             	movzbl (%eax),%eax
 19a:	0f b6 c0             	movzbl %al,%eax
 19d:	29 c2                	sub    %eax,%edx
 19f:	89 d0                	mov    %edx,%eax
}
 1a1:	5d                   	pop    %ebp
 1a2:	c3                   	ret    

000001a3 <strlen>:

uint
strlen(char *s)
{
 1a3:	55                   	push   %ebp
 1a4:	89 e5                	mov    %esp,%ebp
 1a6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b0:	eb 04                	jmp    1b6 <strlen+0x13>
 1b2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
 1bc:	01 d0                	add    %edx,%eax
 1be:	0f b6 00             	movzbl (%eax),%eax
 1c1:	84 c0                	test   %al,%al
 1c3:	75 ed                	jne    1b2 <strlen+0xf>
    ;
  return n;
 1c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c8:	c9                   	leave  
 1c9:	c3                   	ret    

000001ca <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ca:	55                   	push   %ebp
 1cb:	89 e5                	mov    %esp,%ebp
 1cd:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d0:	8b 45 10             	mov    0x10(%ebp),%eax
 1d3:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1da:	89 44 24 04          	mov    %eax,0x4(%esp)
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
 1e1:	89 04 24             	mov    %eax,(%esp)
 1e4:	e8 26 ff ff ff       	call   10f <stosb>
  return dst;
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ec:	c9                   	leave  
 1ed:	c3                   	ret    

000001ee <strchr>:

char*
strchr(const char *s, char c)
{
 1ee:	55                   	push   %ebp
 1ef:	89 e5                	mov    %esp,%ebp
 1f1:	83 ec 04             	sub    $0x4,%esp
 1f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1fa:	eb 14                	jmp    210 <strchr+0x22>
    if(*s == c)
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	0f b6 00             	movzbl (%eax),%eax
 202:	3a 45 fc             	cmp    -0x4(%ebp),%al
 205:	75 05                	jne    20c <strchr+0x1e>
      return (char*)s;
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	eb 13                	jmp    21f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 20c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	0f b6 00             	movzbl (%eax),%eax
 216:	84 c0                	test   %al,%al
 218:	75 e2                	jne    1fc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 21a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21f:	c9                   	leave  
 220:	c3                   	ret    

00000221 <gets>:

char*
gets(char *buf, int max)
{
 221:	55                   	push   %ebp
 222:	89 e5                	mov    %esp,%ebp
 224:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 227:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 22e:	eb 4c                	jmp    27c <gets+0x5b>
    cc = read(0, &c, 1);
 230:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 237:	00 
 238:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23b:	89 44 24 04          	mov    %eax,0x4(%esp)
 23f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 246:	e8 44 01 00 00       	call   38f <read>
 24b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 24e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 252:	7f 02                	jg     256 <gets+0x35>
      break;
 254:	eb 31                	jmp    287 <gets+0x66>
    buf[i++] = c;
 256:	8b 45 f4             	mov    -0xc(%ebp),%eax
 259:	8d 50 01             	lea    0x1(%eax),%edx
 25c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 25f:	89 c2                	mov    %eax,%edx
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	01 c2                	add    %eax,%edx
 266:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 26c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 270:	3c 0a                	cmp    $0xa,%al
 272:	74 13                	je     287 <gets+0x66>
 274:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 278:	3c 0d                	cmp    $0xd,%al
 27a:	74 0b                	je     287 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27f:	83 c0 01             	add    $0x1,%eax
 282:	3b 45 0c             	cmp    0xc(%ebp),%eax
 285:	7c a9                	jl     230 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 287:	8b 55 f4             	mov    -0xc(%ebp),%edx
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	01 d0                	add    %edx,%eax
 28f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 292:	8b 45 08             	mov    0x8(%ebp),%eax
}
 295:	c9                   	leave  
 296:	c3                   	ret    

00000297 <stat>:

int
stat(char *n, struct stat *st)
{
 297:	55                   	push   %ebp
 298:	89 e5                	mov    %esp,%ebp
 29a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a4:	00 
 2a5:	8b 45 08             	mov    0x8(%ebp),%eax
 2a8:	89 04 24             	mov    %eax,(%esp)
 2ab:	e8 07 01 00 00       	call   3b7 <open>
 2b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b7:	79 07                	jns    2c0 <stat+0x29>
    return -1;
 2b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2be:	eb 23                	jmp    2e3 <stat+0x4c>
  r = fstat(fd, st);
 2c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ca:	89 04 24             	mov    %eax,(%esp)
 2cd:	e8 fd 00 00 00       	call   3cf <fstat>
 2d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d8:	89 04 24             	mov    %eax,(%esp)
 2db:	e8 bf 00 00 00       	call   39f <close>
  return r;
 2e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e3:	c9                   	leave  
 2e4:	c3                   	ret    

000002e5 <atoi>:

int
atoi(const char *s)
{
 2e5:	55                   	push   %ebp
 2e6:	89 e5                	mov    %esp,%ebp
 2e8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f2:	eb 25                	jmp    319 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f7:	89 d0                	mov    %edx,%eax
 2f9:	c1 e0 02             	shl    $0x2,%eax
 2fc:	01 d0                	add    %edx,%eax
 2fe:	01 c0                	add    %eax,%eax
 300:	89 c1                	mov    %eax,%ecx
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	8d 50 01             	lea    0x1(%eax),%edx
 308:	89 55 08             	mov    %edx,0x8(%ebp)
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	0f be c0             	movsbl %al,%eax
 311:	01 c8                	add    %ecx,%eax
 313:	83 e8 30             	sub    $0x30,%eax
 316:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	0f b6 00             	movzbl (%eax),%eax
 31f:	3c 2f                	cmp    $0x2f,%al
 321:	7e 0a                	jle    32d <atoi+0x48>
 323:	8b 45 08             	mov    0x8(%ebp),%eax
 326:	0f b6 00             	movzbl (%eax),%eax
 329:	3c 39                	cmp    $0x39,%al
 32b:	7e c7                	jle    2f4 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 32d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 330:	c9                   	leave  
 331:	c3                   	ret    

00000332 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 33e:	8b 45 0c             	mov    0xc(%ebp),%eax
 341:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 344:	eb 17                	jmp    35d <memmove+0x2b>
    *dst++ = *src++;
 346:	8b 45 fc             	mov    -0x4(%ebp),%eax
 349:	8d 50 01             	lea    0x1(%eax),%edx
 34c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 34f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 352:	8d 4a 01             	lea    0x1(%edx),%ecx
 355:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 358:	0f b6 12             	movzbl (%edx),%edx
 35b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35d:	8b 45 10             	mov    0x10(%ebp),%eax
 360:	8d 50 ff             	lea    -0x1(%eax),%edx
 363:	89 55 10             	mov    %edx,0x10(%ebp)
 366:	85 c0                	test   %eax,%eax
 368:	7f dc                	jg     346 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36d:	c9                   	leave  
 36e:	c3                   	ret    

0000036f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 36f:	b8 01 00 00 00       	mov    $0x1,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <exit>:
SYSCALL(exit)
 377:	b8 02 00 00 00       	mov    $0x2,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <wait>:
SYSCALL(wait)
 37f:	b8 03 00 00 00       	mov    $0x3,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <pipe>:
SYSCALL(pipe)
 387:	b8 04 00 00 00       	mov    $0x4,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <read>:
SYSCALL(read)
 38f:	b8 05 00 00 00       	mov    $0x5,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <write>:
SYSCALL(write)
 397:	b8 10 00 00 00       	mov    $0x10,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <close>:
SYSCALL(close)
 39f:	b8 15 00 00 00       	mov    $0x15,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <kill>:
SYSCALL(kill)
 3a7:	b8 06 00 00 00       	mov    $0x6,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <exec>:
SYSCALL(exec)
 3af:	b8 07 00 00 00       	mov    $0x7,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <open>:
SYSCALL(open)
 3b7:	b8 0f 00 00 00       	mov    $0xf,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <mknod>:
SYSCALL(mknod)
 3bf:	b8 11 00 00 00       	mov    $0x11,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <unlink>:
SYSCALL(unlink)
 3c7:	b8 12 00 00 00       	mov    $0x12,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <fstat>:
SYSCALL(fstat)
 3cf:	b8 08 00 00 00       	mov    $0x8,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <link>:
SYSCALL(link)
 3d7:	b8 13 00 00 00       	mov    $0x13,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <mkdir>:
SYSCALL(mkdir)
 3df:	b8 14 00 00 00       	mov    $0x14,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <chdir>:
SYSCALL(chdir)
 3e7:	b8 09 00 00 00       	mov    $0x9,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <dup>:
SYSCALL(dup)
 3ef:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <getpid>:
SYSCALL(getpid)
 3f7:	b8 0b 00 00 00       	mov    $0xb,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <sbrk>:
SYSCALL(sbrk)
 3ff:	b8 0c 00 00 00       	mov    $0xc,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <sleep>:
SYSCALL(sleep)
 407:	b8 0d 00 00 00       	mov    $0xd,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <uptime>:
SYSCALL(uptime)
 40f:	b8 0e 00 00 00       	mov    $0xe,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <my_syscall>:
SYSCALL(my_syscall)
 417:	b8 16 00 00 00       	mov    $0x16,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <getppid>:
SYSCALL(getppid)
 41f:	b8 17 00 00 00       	mov    $0x17,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <yield>:
SYSCALL(yield)
 427:	b8 18 00 00 00       	mov    $0x18,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <getlev>:
SYSCALL(getlev)
 42f:	b8 19 00 00 00       	mov    $0x19,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <clone>:
SYSCALL(clone)
 437:	b8 1a 00 00 00       	mov    $0x1a,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <join>:
SYSCALL(join)
 43f:	b8 1b 00 00 00       	mov    $0x1b,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <thexit>:
SYSCALL(thexit)
 447:	b8 1c 00 00 00       	mov    $0x1c,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 44f:	55                   	push   %ebp
 450:	89 e5                	mov    %esp,%ebp
 452:	83 ec 18             	sub    $0x18,%esp
 455:	8b 45 0c             	mov    0xc(%ebp),%eax
 458:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 45b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 462:	00 
 463:	8d 45 f4             	lea    -0xc(%ebp),%eax
 466:	89 44 24 04          	mov    %eax,0x4(%esp)
 46a:	8b 45 08             	mov    0x8(%ebp),%eax
 46d:	89 04 24             	mov    %eax,(%esp)
 470:	e8 22 ff ff ff       	call   397 <write>
}
 475:	c9                   	leave  
 476:	c3                   	ret    

00000477 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 477:	55                   	push   %ebp
 478:	89 e5                	mov    %esp,%ebp
 47a:	56                   	push   %esi
 47b:	53                   	push   %ebx
 47c:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 47f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 486:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 48a:	74 17                	je     4a3 <printint+0x2c>
 48c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 490:	79 11                	jns    4a3 <printint+0x2c>
    neg = 1;
 492:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 499:	8b 45 0c             	mov    0xc(%ebp),%eax
 49c:	f7 d8                	neg    %eax
 49e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a1:	eb 06                	jmp    4a9 <printint+0x32>
  } else {
    x = xx;
 4a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4b0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4b3:	8d 41 01             	lea    0x1(%ecx),%eax
 4b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4bf:	ba 00 00 00 00       	mov    $0x0,%edx
 4c4:	f7 f3                	div    %ebx
 4c6:	89 d0                	mov    %edx,%eax
 4c8:	0f b6 80 18 0d 00 00 	movzbl 0xd18(%eax),%eax
 4cf:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4d3:	8b 75 10             	mov    0x10(%ebp),%esi
 4d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d9:	ba 00 00 00 00       	mov    $0x0,%edx
 4de:	f7 f6                	div    %esi
 4e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e7:	75 c7                	jne    4b0 <printint+0x39>
  if(neg)
 4e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ed:	74 10                	je     4ff <printint+0x88>
    buf[i++] = '-';
 4ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f2:	8d 50 01             	lea    0x1(%eax),%edx
 4f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4f8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4fd:	eb 1f                	jmp    51e <printint+0xa7>
 4ff:	eb 1d                	jmp    51e <printint+0xa7>
    putc(fd, buf[i]);
 501:	8d 55 dc             	lea    -0x24(%ebp),%edx
 504:	8b 45 f4             	mov    -0xc(%ebp),%eax
 507:	01 d0                	add    %edx,%eax
 509:	0f b6 00             	movzbl (%eax),%eax
 50c:	0f be c0             	movsbl %al,%eax
 50f:	89 44 24 04          	mov    %eax,0x4(%esp)
 513:	8b 45 08             	mov    0x8(%ebp),%eax
 516:	89 04 24             	mov    %eax,(%esp)
 519:	e8 31 ff ff ff       	call   44f <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 51e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 522:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 526:	79 d9                	jns    501 <printint+0x8a>
    putc(fd, buf[i]);
}
 528:	83 c4 30             	add    $0x30,%esp
 52b:	5b                   	pop    %ebx
 52c:	5e                   	pop    %esi
 52d:	5d                   	pop    %ebp
 52e:	c3                   	ret    

0000052f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 52f:	55                   	push   %ebp
 530:	89 e5                	mov    %esp,%ebp
 532:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 535:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 53c:	8d 45 0c             	lea    0xc(%ebp),%eax
 53f:	83 c0 04             	add    $0x4,%eax
 542:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 545:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 54c:	e9 7c 01 00 00       	jmp    6cd <printf+0x19e>
    c = fmt[i] & 0xff;
 551:	8b 55 0c             	mov    0xc(%ebp),%edx
 554:	8b 45 f0             	mov    -0x10(%ebp),%eax
 557:	01 d0                	add    %edx,%eax
 559:	0f b6 00             	movzbl (%eax),%eax
 55c:	0f be c0             	movsbl %al,%eax
 55f:	25 ff 00 00 00       	and    $0xff,%eax
 564:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 567:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 56b:	75 2c                	jne    599 <printf+0x6a>
      if(c == '%'){
 56d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 571:	75 0c                	jne    57f <printf+0x50>
        state = '%';
 573:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 57a:	e9 4a 01 00 00       	jmp    6c9 <printf+0x19a>
      } else {
        putc(fd, c);
 57f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 582:	0f be c0             	movsbl %al,%eax
 585:	89 44 24 04          	mov    %eax,0x4(%esp)
 589:	8b 45 08             	mov    0x8(%ebp),%eax
 58c:	89 04 24             	mov    %eax,(%esp)
 58f:	e8 bb fe ff ff       	call   44f <putc>
 594:	e9 30 01 00 00       	jmp    6c9 <printf+0x19a>
      }
    } else if(state == '%'){
 599:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 59d:	0f 85 26 01 00 00    	jne    6c9 <printf+0x19a>
      if(c == 'd'){
 5a3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5a7:	75 2d                	jne    5d6 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ac:	8b 00                	mov    (%eax),%eax
 5ae:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5b5:	00 
 5b6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5bd:	00 
 5be:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c2:	8b 45 08             	mov    0x8(%ebp),%eax
 5c5:	89 04 24             	mov    %eax,(%esp)
 5c8:	e8 aa fe ff ff       	call   477 <printint>
        ap++;
 5cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d1:	e9 ec 00 00 00       	jmp    6c2 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5d6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5da:	74 06                	je     5e2 <printf+0xb3>
 5dc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5e0:	75 2d                	jne    60f <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e5:	8b 00                	mov    (%eax),%eax
 5e7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5ee:	00 
 5ef:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5f6:	00 
 5f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fb:	8b 45 08             	mov    0x8(%ebp),%eax
 5fe:	89 04 24             	mov    %eax,(%esp)
 601:	e8 71 fe ff ff       	call   477 <printint>
        ap++;
 606:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60a:	e9 b3 00 00 00       	jmp    6c2 <printf+0x193>
      } else if(c == 's'){
 60f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 613:	75 45                	jne    65a <printf+0x12b>
        s = (char*)*ap;
 615:	8b 45 e8             	mov    -0x18(%ebp),%eax
 618:	8b 00                	mov    (%eax),%eax
 61a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 61d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 621:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 625:	75 09                	jne    630 <printf+0x101>
          s = "(null)";
 627:	c7 45 f4 43 0a 00 00 	movl   $0xa43,-0xc(%ebp)
        while(*s != 0){
 62e:	eb 1e                	jmp    64e <printf+0x11f>
 630:	eb 1c                	jmp    64e <printf+0x11f>
          putc(fd, *s);
 632:	8b 45 f4             	mov    -0xc(%ebp),%eax
 635:	0f b6 00             	movzbl (%eax),%eax
 638:	0f be c0             	movsbl %al,%eax
 63b:	89 44 24 04          	mov    %eax,0x4(%esp)
 63f:	8b 45 08             	mov    0x8(%ebp),%eax
 642:	89 04 24             	mov    %eax,(%esp)
 645:	e8 05 fe ff ff       	call   44f <putc>
          s++;
 64a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 64e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 651:	0f b6 00             	movzbl (%eax),%eax
 654:	84 c0                	test   %al,%al
 656:	75 da                	jne    632 <printf+0x103>
 658:	eb 68                	jmp    6c2 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 65a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 65e:	75 1d                	jne    67d <printf+0x14e>
        putc(fd, *ap);
 660:	8b 45 e8             	mov    -0x18(%ebp),%eax
 663:	8b 00                	mov    (%eax),%eax
 665:	0f be c0             	movsbl %al,%eax
 668:	89 44 24 04          	mov    %eax,0x4(%esp)
 66c:	8b 45 08             	mov    0x8(%ebp),%eax
 66f:	89 04 24             	mov    %eax,(%esp)
 672:	e8 d8 fd ff ff       	call   44f <putc>
        ap++;
 677:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67b:	eb 45                	jmp    6c2 <printf+0x193>
      } else if(c == '%'){
 67d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 681:	75 17                	jne    69a <printf+0x16b>
        putc(fd, c);
 683:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 686:	0f be c0             	movsbl %al,%eax
 689:	89 44 24 04          	mov    %eax,0x4(%esp)
 68d:	8b 45 08             	mov    0x8(%ebp),%eax
 690:	89 04 24             	mov    %eax,(%esp)
 693:	e8 b7 fd ff ff       	call   44f <putc>
 698:	eb 28                	jmp    6c2 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 69a:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6a1:	00 
 6a2:	8b 45 08             	mov    0x8(%ebp),%eax
 6a5:	89 04 24             	mov    %eax,(%esp)
 6a8:	e8 a2 fd ff ff       	call   44f <putc>
        putc(fd, c);
 6ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b0:	0f be c0             	movsbl %al,%eax
 6b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ba:	89 04 24             	mov    %eax,(%esp)
 6bd:	e8 8d fd ff ff       	call   44f <putc>
      }
      state = 0;
 6c2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6c9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6cd:	8b 55 0c             	mov    0xc(%ebp),%edx
 6d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d3:	01 d0                	add    %edx,%eax
 6d5:	0f b6 00             	movzbl (%eax),%eax
 6d8:	84 c0                	test   %al,%al
 6da:	0f 85 71 fe ff ff    	jne    551 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6e0:	c9                   	leave  
 6e1:	c3                   	ret    

000006e2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e2:	55                   	push   %ebp
 6e3:	89 e5                	mov    %esp,%ebp
 6e5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e8:	8b 45 08             	mov    0x8(%ebp),%eax
 6eb:	83 e8 08             	sub    $0x8,%eax
 6ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f1:	a1 34 0d 00 00       	mov    0xd34,%eax
 6f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f9:	eb 24                	jmp    71f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fe:	8b 00                	mov    (%eax),%eax
 700:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 703:	77 12                	ja     717 <free+0x35>
 705:	8b 45 f8             	mov    -0x8(%ebp),%eax
 708:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70b:	77 24                	ja     731 <free+0x4f>
 70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 710:	8b 00                	mov    (%eax),%eax
 712:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 715:	77 1a                	ja     731 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 717:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71a:	8b 00                	mov    (%eax),%eax
 71c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 71f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 722:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 725:	76 d4                	jbe    6fb <free+0x19>
 727:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72a:	8b 00                	mov    (%eax),%eax
 72c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 72f:	76 ca                	jbe    6fb <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 731:	8b 45 f8             	mov    -0x8(%ebp),%eax
 734:	8b 40 04             	mov    0x4(%eax),%eax
 737:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 73e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 741:	01 c2                	add    %eax,%edx
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	8b 00                	mov    (%eax),%eax
 748:	39 c2                	cmp    %eax,%edx
 74a:	75 24                	jne    770 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 74c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74f:	8b 50 04             	mov    0x4(%eax),%edx
 752:	8b 45 fc             	mov    -0x4(%ebp),%eax
 755:	8b 00                	mov    (%eax),%eax
 757:	8b 40 04             	mov    0x4(%eax),%eax
 75a:	01 c2                	add    %eax,%edx
 75c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 762:	8b 45 fc             	mov    -0x4(%ebp),%eax
 765:	8b 00                	mov    (%eax),%eax
 767:	8b 10                	mov    (%eax),%edx
 769:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76c:	89 10                	mov    %edx,(%eax)
 76e:	eb 0a                	jmp    77a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 770:	8b 45 fc             	mov    -0x4(%ebp),%eax
 773:	8b 10                	mov    (%eax),%edx
 775:	8b 45 f8             	mov    -0x8(%ebp),%eax
 778:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 77a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77d:	8b 40 04             	mov    0x4(%eax),%eax
 780:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 787:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78a:	01 d0                	add    %edx,%eax
 78c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 78f:	75 20                	jne    7b1 <free+0xcf>
    p->s.size += bp->s.size;
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	8b 50 04             	mov    0x4(%eax),%edx
 797:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79a:	8b 40 04             	mov    0x4(%eax),%eax
 79d:	01 c2                	add    %eax,%edx
 79f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a8:	8b 10                	mov    (%eax),%edx
 7aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ad:	89 10                	mov    %edx,(%eax)
 7af:	eb 08                	jmp    7b9 <free+0xd7>
  } else
    p->s.ptr = bp;
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7b7:	89 10                	mov    %edx,(%eax)
  freep = p;
 7b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bc:	a3 34 0d 00 00       	mov    %eax,0xd34
}
 7c1:	c9                   	leave  
 7c2:	c3                   	ret    

000007c3 <morecore>:

static Header*
morecore(uint nu)
{
 7c3:	55                   	push   %ebp
 7c4:	89 e5                	mov    %esp,%ebp
 7c6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7c9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7d0:	77 07                	ja     7d9 <morecore+0x16>
    nu = 4096;
 7d2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7d9:	8b 45 08             	mov    0x8(%ebp),%eax
 7dc:	c1 e0 03             	shl    $0x3,%eax
 7df:	89 04 24             	mov    %eax,(%esp)
 7e2:	e8 18 fc ff ff       	call   3ff <sbrk>
 7e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7ea:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7ee:	75 07                	jne    7f7 <morecore+0x34>
    return 0;
 7f0:	b8 00 00 00 00       	mov    $0x0,%eax
 7f5:	eb 22                	jmp    819 <morecore+0x56>
  hp = (Header*)p;
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 800:	8b 55 08             	mov    0x8(%ebp),%edx
 803:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 806:	8b 45 f0             	mov    -0x10(%ebp),%eax
 809:	83 c0 08             	add    $0x8,%eax
 80c:	89 04 24             	mov    %eax,(%esp)
 80f:	e8 ce fe ff ff       	call   6e2 <free>
  return freep;
 814:	a1 34 0d 00 00       	mov    0xd34,%eax
}
 819:	c9                   	leave  
 81a:	c3                   	ret    

0000081b <malloc>:

void*
malloc(uint nbytes)
{
 81b:	55                   	push   %ebp
 81c:	89 e5                	mov    %esp,%ebp
 81e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 821:	8b 45 08             	mov    0x8(%ebp),%eax
 824:	83 c0 07             	add    $0x7,%eax
 827:	c1 e8 03             	shr    $0x3,%eax
 82a:	83 c0 01             	add    $0x1,%eax
 82d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 830:	a1 34 0d 00 00       	mov    0xd34,%eax
 835:	89 45 f0             	mov    %eax,-0x10(%ebp)
 838:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 83c:	75 23                	jne    861 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 83e:	c7 45 f0 2c 0d 00 00 	movl   $0xd2c,-0x10(%ebp)
 845:	8b 45 f0             	mov    -0x10(%ebp),%eax
 848:	a3 34 0d 00 00       	mov    %eax,0xd34
 84d:	a1 34 0d 00 00       	mov    0xd34,%eax
 852:	a3 2c 0d 00 00       	mov    %eax,0xd2c
    base.s.size = 0;
 857:	c7 05 30 0d 00 00 00 	movl   $0x0,0xd30
 85e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 861:	8b 45 f0             	mov    -0x10(%ebp),%eax
 864:	8b 00                	mov    (%eax),%eax
 866:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	8b 40 04             	mov    0x4(%eax),%eax
 86f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 872:	72 4d                	jb     8c1 <malloc+0xa6>
      if(p->s.size == nunits)
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	8b 40 04             	mov    0x4(%eax),%eax
 87a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 87d:	75 0c                	jne    88b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 87f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 882:	8b 10                	mov    (%eax),%edx
 884:	8b 45 f0             	mov    -0x10(%ebp),%eax
 887:	89 10                	mov    %edx,(%eax)
 889:	eb 26                	jmp    8b1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 88b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88e:	8b 40 04             	mov    0x4(%eax),%eax
 891:	2b 45 ec             	sub    -0x14(%ebp),%eax
 894:	89 c2                	mov    %eax,%edx
 896:	8b 45 f4             	mov    -0xc(%ebp),%eax
 899:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 89c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89f:	8b 40 04             	mov    0x4(%eax),%eax
 8a2:	c1 e0 03             	shl    $0x3,%eax
 8a5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8ae:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b4:	a3 34 0d 00 00       	mov    %eax,0xd34
      return (void*)(p + 1);
 8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bc:	83 c0 08             	add    $0x8,%eax
 8bf:	eb 38                	jmp    8f9 <malloc+0xde>
    }
    if(p == freep)
 8c1:	a1 34 0d 00 00       	mov    0xd34,%eax
 8c6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8c9:	75 1b                	jne    8e6 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ce:	89 04 24             	mov    %eax,(%esp)
 8d1:	e8 ed fe ff ff       	call   7c3 <morecore>
 8d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8dd:	75 07                	jne    8e6 <malloc+0xcb>
        return 0;
 8df:	b8 00 00 00 00       	mov    $0x0,%eax
 8e4:	eb 13                	jmp    8f9 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ef:	8b 00                	mov    (%eax),%eax
 8f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8f4:	e9 70 ff ff ff       	jmp    869 <malloc+0x4e>
}
 8f9:	c9                   	leave  
 8fa:	c3                   	ret    

000008fb <thread_create>:
#include"x86.h"
#include"param.h"
#include"proc.h"

int thread_create(thread_t *thread, void*(*start_routine)(void*),void *arg)
{
 8fb:	55                   	push   %ebp
 8fc:	89 e5                	mov    %esp,%ebp
 8fe:	83 ec 28             	sub    $0x28,%esp
    void *stack = malloc(PGSIZE);
 901:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 908:	e8 0e ff ff ff       	call   81b <malloc>
 90d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if((uint)stack <=0)
 910:	8b 45 f4             	mov    -0xc(%ebp),%eax
 913:	85 c0                	test   %eax,%eax
 915:	75 1b                	jne    932 <thread_create+0x37>
    {
        printf(1,"malloc thread stack failed\n");
 917:	c7 44 24 04 4a 0a 00 	movl   $0xa4a,0x4(%esp)
 91e:	00 
 91f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 926:	e8 04 fc ff ff       	call   52f <printf>
        return -1;
 92b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 930:	eb 67                	jmp    999 <thread_create+0x9e>
    }
    
    if((uint)stack%PGSIZE)
 932:	8b 45 f4             	mov    -0xc(%ebp),%eax
 935:	25 ff 0f 00 00       	and    $0xfff,%eax
 93a:	85 c0                	test   %eax,%eax
 93c:	74 14                	je     952 <thread_create+0x57>
        stack += PGSIZE-((uint)stack%PGSIZE);
 93e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 941:	25 ff 0f 00 00       	and    $0xfff,%eax
 946:	89 c2                	mov    %eax,%edx
 948:	b8 00 10 00 00       	mov    $0x1000,%eax
 94d:	29 d0                	sub    %edx,%eax
 94f:	01 45 f4             	add    %eax,-0xc(%ebp)
    printf(1,"1\n");
 952:	c7 44 24 04 66 0a 00 	movl   $0xa66,0x4(%esp)
 959:	00 
 95a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 961:	e8 c9 fb ff ff       	call   52f <printf>
    if((*thread = clone(start_routine,arg,stack))<0)
 966:	8b 45 f4             	mov    -0xc(%ebp),%eax
 969:	89 44 24 08          	mov    %eax,0x8(%esp)
 96d:	8b 45 10             	mov    0x10(%ebp),%eax
 970:	89 44 24 04          	mov    %eax,0x4(%esp)
 974:	8b 45 0c             	mov    0xc(%ebp),%eax
 977:	89 04 24             	mov    %eax,(%esp)
 97a:	e8 b8 fa ff ff       	call   437 <clone>
 97f:	8b 55 08             	mov    0x8(%ebp),%edx
 982:	89 02                	mov    %eax,(%edx)
 984:	8b 45 08             	mov    0x8(%ebp),%eax
 987:	8b 00                	mov    (%eax),%eax
 989:	85 c0                	test   %eax,%eax
 98b:	79 07                	jns    994 <thread_create+0x99>
        return -1;
 98d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 992:	eb 05                	jmp    999 <thread_create+0x9e>
    return 0;
 994:	b8 00 00 00 00       	mov    $0x0,%eax
}
 999:	c9                   	leave  
 99a:	c3                   	ret    

0000099b <thread_join>:

int thread_join(thread_t thread, void **retval)
{
 99b:	55                   	push   %ebp
 99c:	89 e5                	mov    %esp,%ebp
 99e:	83 ec 28             	sub    $0x28,%esp
    void *stack;
    if(join((uint)thread, &stack, retval)<0)
 9a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 9a4:	89 44 24 08          	mov    %eax,0x8(%esp)
 9a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 9ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 9af:	8b 45 08             	mov    0x8(%ebp),%eax
 9b2:	89 04 24             	mov    %eax,(%esp)
 9b5:	e8 85 fa ff ff       	call   43f <join>
 9ba:	85 c0                	test   %eax,%eax
 9bc:	79 07                	jns    9c5 <thread_join+0x2a>
        return -1;
 9be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9c3:	eb 10                	jmp    9d5 <thread_join+0x3a>

    free(stack);
 9c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c8:	89 04 24             	mov    %eax,(%esp)
 9cb:	e8 12 fd ff ff       	call   6e2 <free>
    return 0;
 9d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 9d5:	c9                   	leave  
 9d6:	c3                   	ret    

000009d7 <thread_exit>:

void thread_exit(void *retval)
{
 9d7:	55                   	push   %ebp
 9d8:	89 e5                	mov    %esp,%ebp
 9da:	83 ec 08             	sub    $0x8,%esp
    proc->retval = retval;
 9dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 9e3:	8b 55 08             	mov    0x8(%ebp),%edx
 9e6:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
    thexit();
 9ec:	e8 56 fa ff ff       	call   447 <thexit>
}
 9f1:	c9                   	leave  
 9f2:	c3                   	ret    
