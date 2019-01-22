
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   6:	eb 39                	jmp    41 <cat+0x41>
    if (write(1, buf, n) != n) {
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 80 0d 00 	movl   $0xd80,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 a0 03 00 00       	call   3c3 <write>
  23:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  26:	74 19                	je     41 <cat+0x41>
      printf(1, "cat: write error\n");
  28:	c7 44 24 04 1f 0a 00 	movl   $0xa1f,0x4(%esp)
  2f:	00 
  30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  37:	e8 1f 05 00 00       	call   55b <printf>
      exit();
  3c:	e8 62 03 00 00       	call   3a3 <exit>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  41:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  48:	00 
  49:	c7 44 24 04 80 0d 00 	movl   $0xd80,0x4(%esp)
  50:	00 
  51:	8b 45 08             	mov    0x8(%ebp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 5f 03 00 00       	call   3bb <read>
  5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  63:	7f a3                	jg     8 <cat+0x8>
    if (write(1, buf, n) != n) {
      printf(1, "cat: write error\n");
      exit();
    }
  }
  if(n < 0){
  65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  69:	79 19                	jns    84 <cat+0x84>
    printf(1, "cat: read error\n");
  6b:	c7 44 24 04 31 0a 00 	movl   $0xa31,0x4(%esp)
  72:	00 
  73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7a:	e8 dc 04 00 00       	call   55b <printf>
    exit();
  7f:	e8 1f 03 00 00       	call   3a3 <exit>
  }
}
  84:	c9                   	leave  
  85:	c3                   	ret    

00000086 <main>:

int
main(int argc, char *argv[])
{
  86:	55                   	push   %ebp
  87:	89 e5                	mov    %esp,%ebp
  89:	83 e4 f0             	and    $0xfffffff0,%esp
  8c:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  8f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  93:	7f 11                	jg     a6 <main+0x20>
    cat(0);
  95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  9c:	e8 5f ff ff ff       	call   0 <cat>
    exit();
  a1:	e8 fd 02 00 00       	call   3a3 <exit>
  }

  for(i = 1; i < argc; i++){
  a6:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  ad:	00 
  ae:	eb 79                	jmp    129 <main+0xa3>
    if((fd = open(argv[i], 0)) < 0){
  b0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  be:	01 d0                	add    %edx,%eax
  c0:	8b 00                	mov    (%eax),%eax
  c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  c9:	00 
  ca:	89 04 24             	mov    %eax,(%esp)
  cd:	e8 11 03 00 00       	call   3e3 <open>
  d2:	89 44 24 18          	mov    %eax,0x18(%esp)
  d6:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  db:	79 2f                	jns    10c <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
  dd:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  eb:	01 d0                	add    %edx,%eax
  ed:	8b 00                	mov    (%eax),%eax
  ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  f3:	c7 44 24 04 42 0a 00 	movl   $0xa42,0x4(%esp)
  fa:	00 
  fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 102:	e8 54 04 00 00       	call   55b <printf>
      exit();
 107:	e8 97 02 00 00       	call   3a3 <exit>
    }
    cat(fd);
 10c:	8b 44 24 18          	mov    0x18(%esp),%eax
 110:	89 04 24             	mov    %eax,(%esp)
 113:	e8 e8 fe ff ff       	call   0 <cat>
    close(fd);
 118:	8b 44 24 18          	mov    0x18(%esp),%eax
 11c:	89 04 24             	mov    %eax,(%esp)
 11f:	e8 a7 02 00 00       	call   3cb <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
 124:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 129:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 12d:	3b 45 08             	cmp    0x8(%ebp),%eax
 130:	0f 8c 7a ff ff ff    	jl     b0 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 136:	e8 68 02 00 00       	call   3a3 <exit>

0000013b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	57                   	push   %edi
 13f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 140:	8b 4d 08             	mov    0x8(%ebp),%ecx
 143:	8b 55 10             	mov    0x10(%ebp),%edx
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	89 cb                	mov    %ecx,%ebx
 14b:	89 df                	mov    %ebx,%edi
 14d:	89 d1                	mov    %edx,%ecx
 14f:	fc                   	cld    
 150:	f3 aa                	rep stos %al,%es:(%edi)
 152:	89 ca                	mov    %ecx,%edx
 154:	89 fb                	mov    %edi,%ebx
 156:	89 5d 08             	mov    %ebx,0x8(%ebp)
 159:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 15c:	5b                   	pop    %ebx
 15d:	5f                   	pop    %edi
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    

00000160 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 16c:	90                   	nop
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	8d 50 01             	lea    0x1(%eax),%edx
 173:	89 55 08             	mov    %edx,0x8(%ebp)
 176:	8b 55 0c             	mov    0xc(%ebp),%edx
 179:	8d 4a 01             	lea    0x1(%edx),%ecx
 17c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 17f:	0f b6 12             	movzbl (%edx),%edx
 182:	88 10                	mov    %dl,(%eax)
 184:	0f b6 00             	movzbl (%eax),%eax
 187:	84 c0                	test   %al,%al
 189:	75 e2                	jne    16d <strcpy+0xd>
    ;
  return os;
 18b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 18e:	c9                   	leave  
 18f:	c3                   	ret    

00000190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 193:	eb 08                	jmp    19d <strcmp+0xd>
    p++, q++;
 195:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 199:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 19d:	8b 45 08             	mov    0x8(%ebp),%eax
 1a0:	0f b6 00             	movzbl (%eax),%eax
 1a3:	84 c0                	test   %al,%al
 1a5:	74 10                	je     1b7 <strcmp+0x27>
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	0f b6 10             	movzbl (%eax),%edx
 1ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b0:	0f b6 00             	movzbl (%eax),%eax
 1b3:	38 c2                	cmp    %al,%dl
 1b5:	74 de                	je     195 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1b7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ba:	0f b6 00             	movzbl (%eax),%eax
 1bd:	0f b6 d0             	movzbl %al,%edx
 1c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c3:	0f b6 00             	movzbl (%eax),%eax
 1c6:	0f b6 c0             	movzbl %al,%eax
 1c9:	29 c2                	sub    %eax,%edx
 1cb:	89 d0                	mov    %edx,%eax
}
 1cd:	5d                   	pop    %ebp
 1ce:	c3                   	ret    

000001cf <strlen>:

uint
strlen(char *s)
{
 1cf:	55                   	push   %ebp
 1d0:	89 e5                	mov    %esp,%ebp
 1d2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1dc:	eb 04                	jmp    1e2 <strlen+0x13>
 1de:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	01 d0                	add    %edx,%eax
 1ea:	0f b6 00             	movzbl (%eax),%eax
 1ed:	84 c0                	test   %al,%al
 1ef:	75 ed                	jne    1de <strlen+0xf>
    ;
  return n;
 1f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1f4:	c9                   	leave  
 1f5:	c3                   	ret    

000001f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f6:	55                   	push   %ebp
 1f7:	89 e5                	mov    %esp,%ebp
 1f9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1fc:	8b 45 10             	mov    0x10(%ebp),%eax
 1ff:	89 44 24 08          	mov    %eax,0x8(%esp)
 203:	8b 45 0c             	mov    0xc(%ebp),%eax
 206:	89 44 24 04          	mov    %eax,0x4(%esp)
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	89 04 24             	mov    %eax,(%esp)
 210:	e8 26 ff ff ff       	call   13b <stosb>
  return dst;
 215:	8b 45 08             	mov    0x8(%ebp),%eax
}
 218:	c9                   	leave  
 219:	c3                   	ret    

0000021a <strchr>:

char*
strchr(const char *s, char c)
{
 21a:	55                   	push   %ebp
 21b:	89 e5                	mov    %esp,%ebp
 21d:	83 ec 04             	sub    $0x4,%esp
 220:	8b 45 0c             	mov    0xc(%ebp),%eax
 223:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 226:	eb 14                	jmp    23c <strchr+0x22>
    if(*s == c)
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	0f b6 00             	movzbl (%eax),%eax
 22e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 231:	75 05                	jne    238 <strchr+0x1e>
      return (char*)s;
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	eb 13                	jmp    24b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 238:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23c:	8b 45 08             	mov    0x8(%ebp),%eax
 23f:	0f b6 00             	movzbl (%eax),%eax
 242:	84 c0                	test   %al,%al
 244:	75 e2                	jne    228 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 246:	b8 00 00 00 00       	mov    $0x0,%eax
}
 24b:	c9                   	leave  
 24c:	c3                   	ret    

0000024d <gets>:

char*
gets(char *buf, int max)
{
 24d:	55                   	push   %ebp
 24e:	89 e5                	mov    %esp,%ebp
 250:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 253:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 25a:	eb 4c                	jmp    2a8 <gets+0x5b>
    cc = read(0, &c, 1);
 25c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 263:	00 
 264:	8d 45 ef             	lea    -0x11(%ebp),%eax
 267:	89 44 24 04          	mov    %eax,0x4(%esp)
 26b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 272:	e8 44 01 00 00       	call   3bb <read>
 277:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 27a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 27e:	7f 02                	jg     282 <gets+0x35>
      break;
 280:	eb 31                	jmp    2b3 <gets+0x66>
    buf[i++] = c;
 282:	8b 45 f4             	mov    -0xc(%ebp),%eax
 285:	8d 50 01             	lea    0x1(%eax),%edx
 288:	89 55 f4             	mov    %edx,-0xc(%ebp)
 28b:	89 c2                	mov    %eax,%edx
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
 290:	01 c2                	add    %eax,%edx
 292:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 296:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 298:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29c:	3c 0a                	cmp    $0xa,%al
 29e:	74 13                	je     2b3 <gets+0x66>
 2a0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a4:	3c 0d                	cmp    $0xd,%al
 2a6:	74 0b                	je     2b3 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ab:	83 c0 01             	add    $0x1,%eax
 2ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2b1:	7c a9                	jl     25c <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	01 d0                	add    %edx,%eax
 2bb:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <stat>:

int
stat(char *n, struct stat *st)
{
 2c3:	55                   	push   %ebp
 2c4:	89 e5                	mov    %esp,%ebp
 2c6:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2d0:	00 
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	89 04 24             	mov    %eax,(%esp)
 2d7:	e8 07 01 00 00       	call   3e3 <open>
 2dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e3:	79 07                	jns    2ec <stat+0x29>
    return -1;
 2e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ea:	eb 23                	jmp    30f <stat+0x4c>
  r = fstat(fd, st);
 2ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f6:	89 04 24             	mov    %eax,(%esp)
 2f9:	e8 fd 00 00 00       	call   3fb <fstat>
 2fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 301:	8b 45 f4             	mov    -0xc(%ebp),%eax
 304:	89 04 24             	mov    %eax,(%esp)
 307:	e8 bf 00 00 00       	call   3cb <close>
  return r;
 30c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 30f:	c9                   	leave  
 310:	c3                   	ret    

00000311 <atoi>:

int
atoi(const char *s)
{
 311:	55                   	push   %ebp
 312:	89 e5                	mov    %esp,%ebp
 314:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 317:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 31e:	eb 25                	jmp    345 <atoi+0x34>
    n = n*10 + *s++ - '0';
 320:	8b 55 fc             	mov    -0x4(%ebp),%edx
 323:	89 d0                	mov    %edx,%eax
 325:	c1 e0 02             	shl    $0x2,%eax
 328:	01 d0                	add    %edx,%eax
 32a:	01 c0                	add    %eax,%eax
 32c:	89 c1                	mov    %eax,%ecx
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	8d 50 01             	lea    0x1(%eax),%edx
 334:	89 55 08             	mov    %edx,0x8(%ebp)
 337:	0f b6 00             	movzbl (%eax),%eax
 33a:	0f be c0             	movsbl %al,%eax
 33d:	01 c8                	add    %ecx,%eax
 33f:	83 e8 30             	sub    $0x30,%eax
 342:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 345:	8b 45 08             	mov    0x8(%ebp),%eax
 348:	0f b6 00             	movzbl (%eax),%eax
 34b:	3c 2f                	cmp    $0x2f,%al
 34d:	7e 0a                	jle    359 <atoi+0x48>
 34f:	8b 45 08             	mov    0x8(%ebp),%eax
 352:	0f b6 00             	movzbl (%eax),%eax
 355:	3c 39                	cmp    $0x39,%al
 357:	7e c7                	jle    320 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 359:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 35c:	c9                   	leave  
 35d:	c3                   	ret    

0000035e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 35e:	55                   	push   %ebp
 35f:	89 e5                	mov    %esp,%ebp
 361:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 364:	8b 45 08             	mov    0x8(%ebp),%eax
 367:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 36a:	8b 45 0c             	mov    0xc(%ebp),%eax
 36d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 370:	eb 17                	jmp    389 <memmove+0x2b>
    *dst++ = *src++;
 372:	8b 45 fc             	mov    -0x4(%ebp),%eax
 375:	8d 50 01             	lea    0x1(%eax),%edx
 378:	89 55 fc             	mov    %edx,-0x4(%ebp)
 37b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 37e:	8d 4a 01             	lea    0x1(%edx),%ecx
 381:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 384:	0f b6 12             	movzbl (%edx),%edx
 387:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 389:	8b 45 10             	mov    0x10(%ebp),%eax
 38c:	8d 50 ff             	lea    -0x1(%eax),%edx
 38f:	89 55 10             	mov    %edx,0x10(%ebp)
 392:	85 c0                	test   %eax,%eax
 394:	7f dc                	jg     372 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 396:	8b 45 08             	mov    0x8(%ebp),%eax
}
 399:	c9                   	leave  
 39a:	c3                   	ret    

0000039b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 39b:	b8 01 00 00 00       	mov    $0x1,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <exit>:
SYSCALL(exit)
 3a3:	b8 02 00 00 00       	mov    $0x2,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <wait>:
SYSCALL(wait)
 3ab:	b8 03 00 00 00       	mov    $0x3,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <pipe>:
SYSCALL(pipe)
 3b3:	b8 04 00 00 00       	mov    $0x4,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <read>:
SYSCALL(read)
 3bb:	b8 05 00 00 00       	mov    $0x5,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <write>:
SYSCALL(write)
 3c3:	b8 10 00 00 00       	mov    $0x10,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <close>:
SYSCALL(close)
 3cb:	b8 15 00 00 00       	mov    $0x15,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <kill>:
SYSCALL(kill)
 3d3:	b8 06 00 00 00       	mov    $0x6,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <exec>:
SYSCALL(exec)
 3db:	b8 07 00 00 00       	mov    $0x7,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <open>:
SYSCALL(open)
 3e3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <mknod>:
SYSCALL(mknod)
 3eb:	b8 11 00 00 00       	mov    $0x11,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <unlink>:
SYSCALL(unlink)
 3f3:	b8 12 00 00 00       	mov    $0x12,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <fstat>:
SYSCALL(fstat)
 3fb:	b8 08 00 00 00       	mov    $0x8,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <link>:
SYSCALL(link)
 403:	b8 13 00 00 00       	mov    $0x13,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <mkdir>:
SYSCALL(mkdir)
 40b:	b8 14 00 00 00       	mov    $0x14,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <chdir>:
SYSCALL(chdir)
 413:	b8 09 00 00 00       	mov    $0x9,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <dup>:
SYSCALL(dup)
 41b:	b8 0a 00 00 00       	mov    $0xa,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <getpid>:
SYSCALL(getpid)
 423:	b8 0b 00 00 00       	mov    $0xb,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <sbrk>:
SYSCALL(sbrk)
 42b:	b8 0c 00 00 00       	mov    $0xc,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <sleep>:
SYSCALL(sleep)
 433:	b8 0d 00 00 00       	mov    $0xd,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <uptime>:
SYSCALL(uptime)
 43b:	b8 0e 00 00 00       	mov    $0xe,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <my_syscall>:
SYSCALL(my_syscall)
 443:	b8 16 00 00 00       	mov    $0x16,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <getppid>:
SYSCALL(getppid)
 44b:	b8 17 00 00 00       	mov    $0x17,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <yield>:
SYSCALL(yield)
 453:	b8 18 00 00 00       	mov    $0x18,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <getlev>:
SYSCALL(getlev)
 45b:	b8 19 00 00 00       	mov    $0x19,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <clone>:
SYSCALL(clone)
 463:	b8 1a 00 00 00       	mov    $0x1a,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <join>:
SYSCALL(join)
 46b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <thexit>:
SYSCALL(thexit)
 473:	b8 1c 00 00 00       	mov    $0x1c,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 47b:	55                   	push   %ebp
 47c:	89 e5                	mov    %esp,%ebp
 47e:	83 ec 18             	sub    $0x18,%esp
 481:	8b 45 0c             	mov    0xc(%ebp),%eax
 484:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 487:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 48e:	00 
 48f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 492:	89 44 24 04          	mov    %eax,0x4(%esp)
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	89 04 24             	mov    %eax,(%esp)
 49c:	e8 22 ff ff ff       	call   3c3 <write>
}
 4a1:	c9                   	leave  
 4a2:	c3                   	ret    

000004a3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a3:	55                   	push   %ebp
 4a4:	89 e5                	mov    %esp,%ebp
 4a6:	56                   	push   %esi
 4a7:	53                   	push   %ebx
 4a8:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4b2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4b6:	74 17                	je     4cf <printint+0x2c>
 4b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4bc:	79 11                	jns    4cf <printint+0x2c>
    neg = 1;
 4be:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c8:	f7 d8                	neg    %eax
 4ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4cd:	eb 06                	jmp    4d5 <printint+0x32>
  } else {
    x = xx;
 4cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4dc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4df:	8d 41 01             	lea    0x1(%ecx),%eax
 4e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4eb:	ba 00 00 00 00       	mov    $0x0,%edx
 4f0:	f7 f3                	div    %ebx
 4f2:	89 d0                	mov    %edx,%eax
 4f4:	0f b6 80 44 0d 00 00 	movzbl 0xd44(%eax),%eax
 4fb:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4ff:	8b 75 10             	mov    0x10(%ebp),%esi
 502:	8b 45 ec             	mov    -0x14(%ebp),%eax
 505:	ba 00 00 00 00       	mov    $0x0,%edx
 50a:	f7 f6                	div    %esi
 50c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 50f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 513:	75 c7                	jne    4dc <printint+0x39>
  if(neg)
 515:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 519:	74 10                	je     52b <printint+0x88>
    buf[i++] = '-';
 51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51e:	8d 50 01             	lea    0x1(%eax),%edx
 521:	89 55 f4             	mov    %edx,-0xc(%ebp)
 524:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 529:	eb 1f                	jmp    54a <printint+0xa7>
 52b:	eb 1d                	jmp    54a <printint+0xa7>
    putc(fd, buf[i]);
 52d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 530:	8b 45 f4             	mov    -0xc(%ebp),%eax
 533:	01 d0                	add    %edx,%eax
 535:	0f b6 00             	movzbl (%eax),%eax
 538:	0f be c0             	movsbl %al,%eax
 53b:	89 44 24 04          	mov    %eax,0x4(%esp)
 53f:	8b 45 08             	mov    0x8(%ebp),%eax
 542:	89 04 24             	mov    %eax,(%esp)
 545:	e8 31 ff ff ff       	call   47b <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 54a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 54e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 552:	79 d9                	jns    52d <printint+0x8a>
    putc(fd, buf[i]);
}
 554:	83 c4 30             	add    $0x30,%esp
 557:	5b                   	pop    %ebx
 558:	5e                   	pop    %esi
 559:	5d                   	pop    %ebp
 55a:	c3                   	ret    

0000055b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 55b:	55                   	push   %ebp
 55c:	89 e5                	mov    %esp,%ebp
 55e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 561:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 568:	8d 45 0c             	lea    0xc(%ebp),%eax
 56b:	83 c0 04             	add    $0x4,%eax
 56e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 571:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 578:	e9 7c 01 00 00       	jmp    6f9 <printf+0x19e>
    c = fmt[i] & 0xff;
 57d:	8b 55 0c             	mov    0xc(%ebp),%edx
 580:	8b 45 f0             	mov    -0x10(%ebp),%eax
 583:	01 d0                	add    %edx,%eax
 585:	0f b6 00             	movzbl (%eax),%eax
 588:	0f be c0             	movsbl %al,%eax
 58b:	25 ff 00 00 00       	and    $0xff,%eax
 590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 593:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 597:	75 2c                	jne    5c5 <printf+0x6a>
      if(c == '%'){
 599:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 59d:	75 0c                	jne    5ab <printf+0x50>
        state = '%';
 59f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5a6:	e9 4a 01 00 00       	jmp    6f5 <printf+0x19a>
      } else {
        putc(fd, c);
 5ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ae:	0f be c0             	movsbl %al,%eax
 5b1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b5:	8b 45 08             	mov    0x8(%ebp),%eax
 5b8:	89 04 24             	mov    %eax,(%esp)
 5bb:	e8 bb fe ff ff       	call   47b <putc>
 5c0:	e9 30 01 00 00       	jmp    6f5 <printf+0x19a>
      }
    } else if(state == '%'){
 5c5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5c9:	0f 85 26 01 00 00    	jne    6f5 <printf+0x19a>
      if(c == 'd'){
 5cf:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5d3:	75 2d                	jne    602 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d8:	8b 00                	mov    (%eax),%eax
 5da:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5e1:	00 
 5e2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5e9:	00 
 5ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ee:	8b 45 08             	mov    0x8(%ebp),%eax
 5f1:	89 04 24             	mov    %eax,(%esp)
 5f4:	e8 aa fe ff ff       	call   4a3 <printint>
        ap++;
 5f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fd:	e9 ec 00 00 00       	jmp    6ee <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 602:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 606:	74 06                	je     60e <printf+0xb3>
 608:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 60c:	75 2d                	jne    63b <printf+0xe0>
        printint(fd, *ap, 16, 0);
 60e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 611:	8b 00                	mov    (%eax),%eax
 613:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 61a:	00 
 61b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 622:	00 
 623:	89 44 24 04          	mov    %eax,0x4(%esp)
 627:	8b 45 08             	mov    0x8(%ebp),%eax
 62a:	89 04 24             	mov    %eax,(%esp)
 62d:	e8 71 fe ff ff       	call   4a3 <printint>
        ap++;
 632:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 636:	e9 b3 00 00 00       	jmp    6ee <printf+0x193>
      } else if(c == 's'){
 63b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 63f:	75 45                	jne    686 <printf+0x12b>
        s = (char*)*ap;
 641:	8b 45 e8             	mov    -0x18(%ebp),%eax
 644:	8b 00                	mov    (%eax),%eax
 646:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 649:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 64d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 651:	75 09                	jne    65c <printf+0x101>
          s = "(null)";
 653:	c7 45 f4 57 0a 00 00 	movl   $0xa57,-0xc(%ebp)
        while(*s != 0){
 65a:	eb 1e                	jmp    67a <printf+0x11f>
 65c:	eb 1c                	jmp    67a <printf+0x11f>
          putc(fd, *s);
 65e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 661:	0f b6 00             	movzbl (%eax),%eax
 664:	0f be c0             	movsbl %al,%eax
 667:	89 44 24 04          	mov    %eax,0x4(%esp)
 66b:	8b 45 08             	mov    0x8(%ebp),%eax
 66e:	89 04 24             	mov    %eax,(%esp)
 671:	e8 05 fe ff ff       	call   47b <putc>
          s++;
 676:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 67a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67d:	0f b6 00             	movzbl (%eax),%eax
 680:	84 c0                	test   %al,%al
 682:	75 da                	jne    65e <printf+0x103>
 684:	eb 68                	jmp    6ee <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 686:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 68a:	75 1d                	jne    6a9 <printf+0x14e>
        putc(fd, *ap);
 68c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68f:	8b 00                	mov    (%eax),%eax
 691:	0f be c0             	movsbl %al,%eax
 694:	89 44 24 04          	mov    %eax,0x4(%esp)
 698:	8b 45 08             	mov    0x8(%ebp),%eax
 69b:	89 04 24             	mov    %eax,(%esp)
 69e:	e8 d8 fd ff ff       	call   47b <putc>
        ap++;
 6a3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a7:	eb 45                	jmp    6ee <printf+0x193>
      } else if(c == '%'){
 6a9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ad:	75 17                	jne    6c6 <printf+0x16b>
        putc(fd, c);
 6af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b2:	0f be c0             	movsbl %al,%eax
 6b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b9:	8b 45 08             	mov    0x8(%ebp),%eax
 6bc:	89 04 24             	mov    %eax,(%esp)
 6bf:	e8 b7 fd ff ff       	call   47b <putc>
 6c4:	eb 28                	jmp    6ee <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c6:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6cd:	00 
 6ce:	8b 45 08             	mov    0x8(%ebp),%eax
 6d1:	89 04 24             	mov    %eax,(%esp)
 6d4:	e8 a2 fd ff ff       	call   47b <putc>
        putc(fd, c);
 6d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6dc:	0f be c0             	movsbl %al,%eax
 6df:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e3:	8b 45 08             	mov    0x8(%ebp),%eax
 6e6:	89 04 24             	mov    %eax,(%esp)
 6e9:	e8 8d fd ff ff       	call   47b <putc>
      }
      state = 0;
 6ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6f5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 6fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ff:	01 d0                	add    %edx,%eax
 701:	0f b6 00             	movzbl (%eax),%eax
 704:	84 c0                	test   %al,%al
 706:	0f 85 71 fe ff ff    	jne    57d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 70c:	c9                   	leave  
 70d:	c3                   	ret    

0000070e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 70e:	55                   	push   %ebp
 70f:	89 e5                	mov    %esp,%ebp
 711:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 714:	8b 45 08             	mov    0x8(%ebp),%eax
 717:	83 e8 08             	sub    $0x8,%eax
 71a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71d:	a1 68 0d 00 00       	mov    0xd68,%eax
 722:	89 45 fc             	mov    %eax,-0x4(%ebp)
 725:	eb 24                	jmp    74b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 727:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72a:	8b 00                	mov    (%eax),%eax
 72c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 72f:	77 12                	ja     743 <free+0x35>
 731:	8b 45 f8             	mov    -0x8(%ebp),%eax
 734:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 737:	77 24                	ja     75d <free+0x4f>
 739:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73c:	8b 00                	mov    (%eax),%eax
 73e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 741:	77 1a                	ja     75d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	8b 00                	mov    (%eax),%eax
 748:	89 45 fc             	mov    %eax,-0x4(%ebp)
 74b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 751:	76 d4                	jbe    727 <free+0x19>
 753:	8b 45 fc             	mov    -0x4(%ebp),%eax
 756:	8b 00                	mov    (%eax),%eax
 758:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75b:	76 ca                	jbe    727 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 75d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 760:	8b 40 04             	mov    0x4(%eax),%eax
 763:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 76a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76d:	01 c2                	add    %eax,%edx
 76f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 772:	8b 00                	mov    (%eax),%eax
 774:	39 c2                	cmp    %eax,%edx
 776:	75 24                	jne    79c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 778:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77b:	8b 50 04             	mov    0x4(%eax),%edx
 77e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 781:	8b 00                	mov    (%eax),%eax
 783:	8b 40 04             	mov    0x4(%eax),%eax
 786:	01 c2                	add    %eax,%edx
 788:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 78e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 791:	8b 00                	mov    (%eax),%eax
 793:	8b 10                	mov    (%eax),%edx
 795:	8b 45 f8             	mov    -0x8(%ebp),%eax
 798:	89 10                	mov    %edx,(%eax)
 79a:	eb 0a                	jmp    7a6 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 79c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79f:	8b 10                	mov    (%eax),%edx
 7a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a4:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a9:	8b 40 04             	mov    0x4(%eax),%eax
 7ac:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b6:	01 d0                	add    %edx,%eax
 7b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7bb:	75 20                	jne    7dd <free+0xcf>
    p->s.size += bp->s.size;
 7bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c0:	8b 50 04             	mov    0x4(%eax),%edx
 7c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c6:	8b 40 04             	mov    0x4(%eax),%eax
 7c9:	01 c2                	add    %eax,%edx
 7cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ce:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d4:	8b 10                	mov    (%eax),%edx
 7d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d9:	89 10                	mov    %edx,(%eax)
 7db:	eb 08                	jmp    7e5 <free+0xd7>
  } else
    p->s.ptr = bp;
 7dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7e3:	89 10                	mov    %edx,(%eax)
  freep = p;
 7e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e8:	a3 68 0d 00 00       	mov    %eax,0xd68
}
 7ed:	c9                   	leave  
 7ee:	c3                   	ret    

000007ef <morecore>:

static Header*
morecore(uint nu)
{
 7ef:	55                   	push   %ebp
 7f0:	89 e5                	mov    %esp,%ebp
 7f2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7f5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7fc:	77 07                	ja     805 <morecore+0x16>
    nu = 4096;
 7fe:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 805:	8b 45 08             	mov    0x8(%ebp),%eax
 808:	c1 e0 03             	shl    $0x3,%eax
 80b:	89 04 24             	mov    %eax,(%esp)
 80e:	e8 18 fc ff ff       	call   42b <sbrk>
 813:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 816:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 81a:	75 07                	jne    823 <morecore+0x34>
    return 0;
 81c:	b8 00 00 00 00       	mov    $0x0,%eax
 821:	eb 22                	jmp    845 <morecore+0x56>
  hp = (Header*)p;
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 829:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82c:	8b 55 08             	mov    0x8(%ebp),%edx
 82f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 832:	8b 45 f0             	mov    -0x10(%ebp),%eax
 835:	83 c0 08             	add    $0x8,%eax
 838:	89 04 24             	mov    %eax,(%esp)
 83b:	e8 ce fe ff ff       	call   70e <free>
  return freep;
 840:	a1 68 0d 00 00       	mov    0xd68,%eax
}
 845:	c9                   	leave  
 846:	c3                   	ret    

00000847 <malloc>:

void*
malloc(uint nbytes)
{
 847:	55                   	push   %ebp
 848:	89 e5                	mov    %esp,%ebp
 84a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84d:	8b 45 08             	mov    0x8(%ebp),%eax
 850:	83 c0 07             	add    $0x7,%eax
 853:	c1 e8 03             	shr    $0x3,%eax
 856:	83 c0 01             	add    $0x1,%eax
 859:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 85c:	a1 68 0d 00 00       	mov    0xd68,%eax
 861:	89 45 f0             	mov    %eax,-0x10(%ebp)
 864:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 868:	75 23                	jne    88d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 86a:	c7 45 f0 60 0d 00 00 	movl   $0xd60,-0x10(%ebp)
 871:	8b 45 f0             	mov    -0x10(%ebp),%eax
 874:	a3 68 0d 00 00       	mov    %eax,0xd68
 879:	a1 68 0d 00 00       	mov    0xd68,%eax
 87e:	a3 60 0d 00 00       	mov    %eax,0xd60
    base.s.size = 0;
 883:	c7 05 64 0d 00 00 00 	movl   $0x0,0xd64
 88a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 890:	8b 00                	mov    (%eax),%eax
 892:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 895:	8b 45 f4             	mov    -0xc(%ebp),%eax
 898:	8b 40 04             	mov    0x4(%eax),%eax
 89b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 89e:	72 4d                	jb     8ed <malloc+0xa6>
      if(p->s.size == nunits)
 8a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a3:	8b 40 04             	mov    0x4(%eax),%eax
 8a6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a9:	75 0c                	jne    8b7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ae:	8b 10                	mov    (%eax),%edx
 8b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b3:	89 10                	mov    %edx,(%eax)
 8b5:	eb 26                	jmp    8dd <malloc+0x96>
      else {
        p->s.size -= nunits;
 8b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ba:	8b 40 04             	mov    0x4(%eax),%eax
 8bd:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8c0:	89 c2                	mov    %eax,%edx
 8c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cb:	8b 40 04             	mov    0x4(%eax),%eax
 8ce:	c1 e0 03             	shl    $0x3,%eax
 8d1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8da:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e0:	a3 68 0d 00 00       	mov    %eax,0xd68
      return (void*)(p + 1);
 8e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e8:	83 c0 08             	add    $0x8,%eax
 8eb:	eb 38                	jmp    925 <malloc+0xde>
    }
    if(p == freep)
 8ed:	a1 68 0d 00 00       	mov    0xd68,%eax
 8f2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8f5:	75 1b                	jne    912 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8fa:	89 04 24             	mov    %eax,(%esp)
 8fd:	e8 ed fe ff ff       	call   7ef <morecore>
 902:	89 45 f4             	mov    %eax,-0xc(%ebp)
 905:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 909:	75 07                	jne    912 <malloc+0xcb>
        return 0;
 90b:	b8 00 00 00 00       	mov    $0x0,%eax
 910:	eb 13                	jmp    925 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 912:	8b 45 f4             	mov    -0xc(%ebp),%eax
 915:	89 45 f0             	mov    %eax,-0x10(%ebp)
 918:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91b:	8b 00                	mov    (%eax),%eax
 91d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 920:	e9 70 ff ff ff       	jmp    895 <malloc+0x4e>
}
 925:	c9                   	leave  
 926:	c3                   	ret    

00000927 <thread_create>:
#include"x86.h"
#include"param.h"
#include"proc.h"

int thread_create(thread_t *thread, void*(*start_routine)(void*),void *arg)
{
 927:	55                   	push   %ebp
 928:	89 e5                	mov    %esp,%ebp
 92a:	83 ec 28             	sub    $0x28,%esp
    void *stack = malloc(PGSIZE);
 92d:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 934:	e8 0e ff ff ff       	call   847 <malloc>
 939:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if((uint)stack <=0)
 93c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93f:	85 c0                	test   %eax,%eax
 941:	75 1b                	jne    95e <thread_create+0x37>
    {
        printf(1,"malloc thread stack failed\n");
 943:	c7 44 24 04 5e 0a 00 	movl   $0xa5e,0x4(%esp)
 94a:	00 
 94b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 952:	e8 04 fc ff ff       	call   55b <printf>
        return -1;
 957:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 95c:	eb 67                	jmp    9c5 <thread_create+0x9e>
    }
    
    if((uint)stack%PGSIZE)
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	25 ff 0f 00 00       	and    $0xfff,%eax
 966:	85 c0                	test   %eax,%eax
 968:	74 14                	je     97e <thread_create+0x57>
        stack += PGSIZE-((uint)stack%PGSIZE);
 96a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96d:	25 ff 0f 00 00       	and    $0xfff,%eax
 972:	89 c2                	mov    %eax,%edx
 974:	b8 00 10 00 00       	mov    $0x1000,%eax
 979:	29 d0                	sub    %edx,%eax
 97b:	01 45 f4             	add    %eax,-0xc(%ebp)
    printf(1,"1\n");
 97e:	c7 44 24 04 7a 0a 00 	movl   $0xa7a,0x4(%esp)
 985:	00 
 986:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 98d:	e8 c9 fb ff ff       	call   55b <printf>
    if((*thread = clone(start_routine,arg,stack))<0)
 992:	8b 45 f4             	mov    -0xc(%ebp),%eax
 995:	89 44 24 08          	mov    %eax,0x8(%esp)
 999:	8b 45 10             	mov    0x10(%ebp),%eax
 99c:	89 44 24 04          	mov    %eax,0x4(%esp)
 9a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 9a3:	89 04 24             	mov    %eax,(%esp)
 9a6:	e8 b8 fa ff ff       	call   463 <clone>
 9ab:	8b 55 08             	mov    0x8(%ebp),%edx
 9ae:	89 02                	mov    %eax,(%edx)
 9b0:	8b 45 08             	mov    0x8(%ebp),%eax
 9b3:	8b 00                	mov    (%eax),%eax
 9b5:	85 c0                	test   %eax,%eax
 9b7:	79 07                	jns    9c0 <thread_create+0x99>
        return -1;
 9b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9be:	eb 05                	jmp    9c5 <thread_create+0x9e>
    return 0;
 9c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 9c5:	c9                   	leave  
 9c6:	c3                   	ret    

000009c7 <thread_join>:

int thread_join(thread_t thread, void **retval)
{
 9c7:	55                   	push   %ebp
 9c8:	89 e5                	mov    %esp,%ebp
 9ca:	83 ec 28             	sub    $0x28,%esp
    void *stack;
    if(join((uint)thread, &stack, retval)<0)
 9cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 9d0:	89 44 24 08          	mov    %eax,0x8(%esp)
 9d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 9d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 9db:	8b 45 08             	mov    0x8(%ebp),%eax
 9de:	89 04 24             	mov    %eax,(%esp)
 9e1:	e8 85 fa ff ff       	call   46b <join>
 9e6:	85 c0                	test   %eax,%eax
 9e8:	79 07                	jns    9f1 <thread_join+0x2a>
        return -1;
 9ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9ef:	eb 10                	jmp    a01 <thread_join+0x3a>

    free(stack);
 9f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f4:	89 04 24             	mov    %eax,(%esp)
 9f7:	e8 12 fd ff ff       	call   70e <free>
    return 0;
 9fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
 a01:	c9                   	leave  
 a02:	c3                   	ret    

00000a03 <thread_exit>:

void thread_exit(void *retval)
{
 a03:	55                   	push   %ebp
 a04:	89 e5                	mov    %esp,%ebp
 a06:	83 ec 08             	sub    $0x8,%esp
    proc->retval = retval;
 a09:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 a0f:	8b 55 08             	mov    0x8(%ebp),%edx
 a12:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
    thexit();
 a18:	e8 56 fa ff ff       	call   473 <thexit>
}
 a1d:	c9                   	leave  
 a1e:	c3                   	ret    
