
_hugefiletest:     file format elf32-i386


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
   6:	81 ec 30 04 00 00    	sub    $0x430,%esp
  int fd, i, j; 
  int r;
  int total;
  char *path = (argc > 1) ? argv[1] : "hugefile";
   c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  10:	7e 08                	jle    1a <main+0x1a>
  12:	8b 45 0c             	mov    0xc(%ebp),%eax
  15:	8b 40 04             	mov    0x4(%eax),%eax
  18:	eb 05                	jmp    1f <main+0x1f>
  1a:	b8 ee 0d 00 00       	mov    $0xdee,%eax
  1f:	89 84 24 20 04 00 00 	mov    %eax,0x420(%esp)
  char data[512];
  char buf[512];

  printf(1, "hugefiletest starting\n");
  26:	c7 44 24 04 f7 0d 00 	movl   $0xdf7,0x4(%esp)
  2d:	00 
  2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  35:	e8 f0 08 00 00       	call   92a <printf>
  const int sz = sizeof(data);
  3a:	c7 84 24 1c 04 00 00 	movl   $0x200,0x41c(%esp)
  41:	00 02 00 00 
  for (i = 0; i < sz; i++) {
  45:	c7 84 24 2c 04 00 00 	movl   $0x0,0x42c(%esp)
  4c:	00 00 00 00 
  50:	eb 2c                	jmp    7e <main+0x7e>
      data[i] = i % 128;
  52:	8b 84 24 2c 04 00 00 	mov    0x42c(%esp),%eax
  59:	99                   	cltd   
  5a:	c1 ea 19             	shr    $0x19,%edx
  5d:	01 d0                	add    %edx,%eax
  5f:	83 e0 7f             	and    $0x7f,%eax
  62:	29 d0                	sub    %edx,%eax
  64:	8d 8c 24 14 02 00 00 	lea    0x214(%esp),%ecx
  6b:	8b 94 24 2c 04 00 00 	mov    0x42c(%esp),%edx
  72:	01 ca                	add    %ecx,%edx
  74:	88 02                	mov    %al,(%edx)
  char data[512];
  char buf[512];

  printf(1, "hugefiletest starting\n");
  const int sz = sizeof(data);
  for (i = 0; i < sz; i++) {
  76:	83 84 24 2c 04 00 00 	addl   $0x1,0x42c(%esp)
  7d:	01 
  7e:	8b 84 24 2c 04 00 00 	mov    0x42c(%esp),%eax
  85:	3b 84 24 1c 04 00 00 	cmp    0x41c(%esp),%eax
  8c:	7c c4                	jl     52 <main+0x52>
      data[i] = i % 128;
  }

  printf(1, "1. create test\n");
  8e:	c7 44 24 04 0e 0e 00 	movl   $0xe0e,0x4(%esp)
  95:	00 
  96:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9d:	e8 88 08 00 00       	call   92a <printf>
  fd = open(path, O_CREATE | O_RDWR);
  a2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  a9:	00 
  aa:	8b 84 24 20 04 00 00 	mov    0x420(%esp),%eax
  b1:	89 04 24             	mov    %eax,(%esp)
  b4:	e8 f9 06 00 00       	call   7b2 <open>
  b9:	89 84 24 18 04 00 00 	mov    %eax,0x418(%esp)
  for(i = 0; i < 1024; i++){
  c0:	c7 84 24 2c 04 00 00 	movl   $0x0,0x42c(%esp)
  c7:	00 00 00 00 
  cb:	e9 ab 00 00 00       	jmp    17b <main+0x17b>
    if (i % 100 == 0){
  d0:	8b 8c 24 2c 04 00 00 	mov    0x42c(%esp),%ecx
  d7:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  dc:	89 c8                	mov    %ecx,%eax
  de:	f7 ea                	imul   %edx
  e0:	c1 fa 05             	sar    $0x5,%edx
  e3:	89 c8                	mov    %ecx,%eax
  e5:	c1 f8 1f             	sar    $0x1f,%eax
  e8:	29 c2                	sub    %eax,%edx
  ea:	89 d0                	mov    %edx,%eax
  ec:	6b c0 64             	imul   $0x64,%eax,%eax
  ef:	29 c1                	sub    %eax,%ecx
  f1:	89 c8                	mov    %ecx,%eax
  f3:	85 c0                	test   %eax,%eax
  f5:	75 22                	jne    119 <main+0x119>
      printf(1, "%d bytes written\n", i * 512);
  f7:	8b 84 24 2c 04 00 00 	mov    0x42c(%esp),%eax
  fe:	c1 e0 09             	shl    $0x9,%eax
 101:	89 44 24 08          	mov    %eax,0x8(%esp)
 105:	c7 44 24 04 1e 0e 00 	movl   $0xe1e,0x4(%esp)
 10c:	00 
 10d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 114:	e8 11 08 00 00       	call   92a <printf>
    }
    if ((r = write(fd, data, sizeof(data))) != sizeof(data)){
 119:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 120:	00 
 121:	8d 84 24 14 02 00 00 	lea    0x214(%esp),%eax
 128:	89 44 24 04          	mov    %eax,0x4(%esp)
 12c:	8b 84 24 18 04 00 00 	mov    0x418(%esp),%eax
 133:	89 04 24             	mov    %eax,(%esp)
 136:	e8 57 06 00 00       	call   792 <write>
 13b:	89 84 24 14 04 00 00 	mov    %eax,0x414(%esp)
 142:	81 bc 24 14 04 00 00 	cmpl   $0x200,0x414(%esp)
 149:	00 02 00 00 
 14d:	74 24                	je     173 <main+0x173>
      printf(1, "write returned %d : failed\n", r);
 14f:	8b 84 24 14 04 00 00 	mov    0x414(%esp),%eax
 156:	89 44 24 08          	mov    %eax,0x8(%esp)
 15a:	c7 44 24 04 30 0e 00 	movl   $0xe30,0x4(%esp)
 161:	00 
 162:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 169:	e8 bc 07 00 00       	call   92a <printf>
      exit();
 16e:	e8 ff 05 00 00       	call   772 <exit>
      data[i] = i % 128;
  }

  printf(1, "1. create test\n");
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 1024; i++){
 173:	83 84 24 2c 04 00 00 	addl   $0x1,0x42c(%esp)
 17a:	01 
 17b:	81 bc 24 2c 04 00 00 	cmpl   $0x3ff,0x42c(%esp)
 182:	ff 03 00 00 
 186:	0f 8e 44 ff ff ff    	jle    d0 <main+0xd0>
    if ((r = write(fd, data, sizeof(data))) != sizeof(data)){
      printf(1, "write returned %d : failed\n", r);
      exit();
    }
  }
  printf(1, "%d bytes written\n", 1024 * 512);
 18c:	c7 44 24 08 00 00 08 	movl   $0x80000,0x8(%esp)
 193:	00 
 194:	c7 44 24 04 1e 0e 00 	movl   $0xe1e,0x4(%esp)
 19b:	00 
 19c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1a3:	e8 82 07 00 00       	call   92a <printf>
  close(fd);
 1a8:	8b 84 24 18 04 00 00 	mov    0x418(%esp),%eax
 1af:	89 04 24             	mov    %eax,(%esp)
 1b2:	e8 e3 05 00 00       	call   79a <close>

  printf(1, "2. read test\n");
 1b7:	c7 44 24 04 4c 0e 00 	movl   $0xe4c,0x4(%esp)
 1be:	00 
 1bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c6:	e8 5f 07 00 00       	call   92a <printf>
  fd = open(path, O_RDONLY);
 1cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1d2:	00 
 1d3:	8b 84 24 20 04 00 00 	mov    0x420(%esp),%eax
 1da:	89 04 24             	mov    %eax,(%esp)
 1dd:	e8 d0 05 00 00       	call   7b2 <open>
 1e2:	89 84 24 18 04 00 00 	mov    %eax,0x418(%esp)
  for (i = 0; i < 1024; i++){
 1e9:	c7 84 24 2c 04 00 00 	movl   $0x0,0x42c(%esp)
 1f0:	00 00 00 00 
 1f4:	e9 0d 01 00 00       	jmp    306 <main+0x306>
    if (i % 100 == 0){
 1f9:	8b 8c 24 2c 04 00 00 	mov    0x42c(%esp),%ecx
 200:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 205:	89 c8                	mov    %ecx,%eax
 207:	f7 ea                	imul   %edx
 209:	c1 fa 05             	sar    $0x5,%edx
 20c:	89 c8                	mov    %ecx,%eax
 20e:	c1 f8 1f             	sar    $0x1f,%eax
 211:	29 c2                	sub    %eax,%edx
 213:	89 d0                	mov    %edx,%eax
 215:	6b c0 64             	imul   $0x64,%eax,%eax
 218:	29 c1                	sub    %eax,%ecx
 21a:	89 c8                	mov    %ecx,%eax
 21c:	85 c0                	test   %eax,%eax
 21e:	75 22                	jne    242 <main+0x242>
      printf(1, "%d bytes read\n", i * 512);
 220:	8b 84 24 2c 04 00 00 	mov    0x42c(%esp),%eax
 227:	c1 e0 09             	shl    $0x9,%eax
 22a:	89 44 24 08          	mov    %eax,0x8(%esp)
 22e:	c7 44 24 04 5a 0e 00 	movl   $0xe5a,0x4(%esp)
 235:	00 
 236:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 23d:	e8 e8 06 00 00       	call   92a <printf>
    }
    if ((r = read(fd, buf, sizeof(data))) != sizeof(data)){
 242:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 249:	00 
 24a:	8d 44 24 14          	lea    0x14(%esp),%eax
 24e:	89 44 24 04          	mov    %eax,0x4(%esp)
 252:	8b 84 24 18 04 00 00 	mov    0x418(%esp),%eax
 259:	89 04 24             	mov    %eax,(%esp)
 25c:	e8 29 05 00 00       	call   78a <read>
 261:	89 84 24 14 04 00 00 	mov    %eax,0x414(%esp)
 268:	81 bc 24 14 04 00 00 	cmpl   $0x200,0x414(%esp)
 26f:	00 02 00 00 
 273:	74 24                	je     299 <main+0x299>
      printf(1, "read returned %d : failed\n", r);
 275:	8b 84 24 14 04 00 00 	mov    0x414(%esp),%eax
 27c:	89 44 24 08          	mov    %eax,0x8(%esp)
 280:	c7 44 24 04 69 0e 00 	movl   $0xe69,0x4(%esp)
 287:	00 
 288:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 28f:	e8 96 06 00 00       	call   92a <printf>
      exit();
 294:	e8 d9 04 00 00       	call   772 <exit>
    }
    for (j = 0; j < sz; j++) {
 299:	c7 84 24 28 04 00 00 	movl   $0x0,0x428(%esp)
 2a0:	00 00 00 00 
 2a4:	eb 48                	jmp    2ee <main+0x2ee>
      if (buf[j] != data[j]) {
 2a6:	8d 54 24 14          	lea    0x14(%esp),%edx
 2aa:	8b 84 24 28 04 00 00 	mov    0x428(%esp),%eax
 2b1:	01 d0                	add    %edx,%eax
 2b3:	0f b6 10             	movzbl (%eax),%edx
 2b6:	8d 8c 24 14 02 00 00 	lea    0x214(%esp),%ecx
 2bd:	8b 84 24 28 04 00 00 	mov    0x428(%esp),%eax
 2c4:	01 c8                	add    %ecx,%eax
 2c6:	0f b6 00             	movzbl (%eax),%eax
 2c9:	38 c2                	cmp    %al,%dl
 2cb:	74 19                	je     2e6 <main+0x2e6>
        printf(1, "data inconsistency detected\n");
 2cd:	c7 44 24 04 84 0e 00 	movl   $0xe84,0x4(%esp)
 2d4:	00 
 2d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2dc:	e8 49 06 00 00       	call   92a <printf>
        exit();
 2e1:	e8 8c 04 00 00       	call   772 <exit>
    }
    if ((r = read(fd, buf, sizeof(data))) != sizeof(data)){
      printf(1, "read returned %d : failed\n", r);
      exit();
    }
    for (j = 0; j < sz; j++) {
 2e6:	83 84 24 28 04 00 00 	addl   $0x1,0x428(%esp)
 2ed:	01 
 2ee:	8b 84 24 28 04 00 00 	mov    0x428(%esp),%eax
 2f5:	3b 84 24 1c 04 00 00 	cmp    0x41c(%esp),%eax
 2fc:	7c a8                	jl     2a6 <main+0x2a6>
  printf(1, "%d bytes written\n", 1024 * 512);
  close(fd);

  printf(1, "2. read test\n");
  fd = open(path, O_RDONLY);
  for (i = 0; i < 1024; i++){
 2fe:	83 84 24 2c 04 00 00 	addl   $0x1,0x42c(%esp)
 305:	01 
 306:	81 bc 24 2c 04 00 00 	cmpl   $0x3ff,0x42c(%esp)
 30d:	ff 03 00 00 
 311:	0f 8e e2 fe ff ff    	jle    1f9 <main+0x1f9>
        printf(1, "data inconsistency detected\n");
        exit();
      }
    }
  }
  printf(1, "%d bytes read\n", 1024 * 512);
 317:	c7 44 24 08 00 00 08 	movl   $0x80000,0x8(%esp)
 31e:	00 
 31f:	c7 44 24 04 5a 0e 00 	movl   $0xe5a,0x4(%esp)
 326:	00 
 327:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 32e:	e8 f7 05 00 00       	call   92a <printf>
  close(fd);
 333:	8b 84 24 18 04 00 00 	mov    0x418(%esp),%eax
 33a:	89 04 24             	mov    %eax,(%esp)
 33d:	e8 58 04 00 00       	call   79a <close>

  printf(1, "3. stress test\n");
 342:	c7 44 24 04 a1 0e 00 	movl   $0xea1,0x4(%esp)
 349:	00 
 34a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 351:	e8 d4 05 00 00       	call   92a <printf>
  total = 0;
 356:	c7 84 24 24 04 00 00 	movl   $0x0,0x424(%esp)
 35d:	00 00 00 00 
  for (i = 0; i < 20; i++) {
 361:	c7 84 24 2c 04 00 00 	movl   $0x0,0x42c(%esp)
 368:	00 00 00 00 
 36c:	e9 86 01 00 00       	jmp    4f7 <main+0x4f7>
    printf(1, "stress test...%d \n", i);
 371:	8b 84 24 2c 04 00 00 	mov    0x42c(%esp),%eax
 378:	89 44 24 08          	mov    %eax,0x8(%esp)
 37c:	c7 44 24 04 b1 0e 00 	movl   $0xeb1,0x4(%esp)
 383:	00 
 384:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 38b:	e8 9a 05 00 00       	call   92a <printf>
    if(unlink(path) < 0){
 390:	8b 84 24 20 04 00 00 	mov    0x420(%esp),%eax
 397:	89 04 24             	mov    %eax,(%esp)
 39a:	e8 23 04 00 00       	call   7c2 <unlink>
 39f:	85 c0                	test   %eax,%eax
 3a1:	79 24                	jns    3c7 <main+0x3c7>
      printf(1, "rm: %s failed to delete\n", path);
 3a3:	8b 84 24 20 04 00 00 	mov    0x420(%esp),%eax
 3aa:	89 44 24 08          	mov    %eax,0x8(%esp)
 3ae:	c7 44 24 04 c4 0e 00 	movl   $0xec4,0x4(%esp)
 3b5:	00 
 3b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3bd:	e8 68 05 00 00       	call   92a <printf>
      exit();
 3c2:	e8 ab 03 00 00       	call   772 <exit>
    }
    
    fd = open(path, O_CREATE | O_RDWR);
 3c7:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
 3ce:	00 
 3cf:	8b 84 24 20 04 00 00 	mov    0x420(%esp),%eax
 3d6:	89 04 24             	mov    %eax,(%esp)
 3d9:	e8 d4 03 00 00       	call   7b2 <open>
 3de:	89 84 24 18 04 00 00 	mov    %eax,0x418(%esp)
      for(j = 0; j < 1024; j++){
 3e5:	c7 84 24 28 04 00 00 	movl   $0x0,0x428(%esp)
 3ec:	00 00 00 00 
 3f0:	e9 bb 00 00 00       	jmp    4b0 <main+0x4b0>
        if (j % 100 == 0){
 3f5:	8b 8c 24 28 04 00 00 	mov    0x428(%esp),%ecx
 3fc:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 401:	89 c8                	mov    %ecx,%eax
 403:	f7 ea                	imul   %edx
 405:	c1 fa 05             	sar    $0x5,%edx
 408:	89 c8                	mov    %ecx,%eax
 40a:	c1 f8 1f             	sar    $0x1f,%eax
 40d:	29 c2                	sub    %eax,%edx
 40f:	89 d0                	mov    %edx,%eax
 411:	6b c0 64             	imul   $0x64,%eax,%eax
 414:	29 c1                	sub    %eax,%ecx
 416:	89 c8                	mov    %ecx,%eax
 418:	85 c0                	test   %eax,%eax
 41a:	75 1f                	jne    43b <main+0x43b>
          printf(1, "%d bytes totally written\n", total);
 41c:	8b 84 24 24 04 00 00 	mov    0x424(%esp),%eax
 423:	89 44 24 08          	mov    %eax,0x8(%esp)
 427:	c7 44 24 04 dd 0e 00 	movl   $0xedd,0x4(%esp)
 42e:	00 
 42f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 436:	e8 ef 04 00 00       	call   92a <printf>
        }
        if ((r = write(fd, data, sizeof(data))) != sizeof(data)){
 43b:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 442:	00 
 443:	8d 84 24 14 02 00 00 	lea    0x214(%esp),%eax
 44a:	89 44 24 04          	mov    %eax,0x4(%esp)
 44e:	8b 84 24 18 04 00 00 	mov    0x418(%esp),%eax
 455:	89 04 24             	mov    %eax,(%esp)
 458:	e8 35 03 00 00       	call   792 <write>
 45d:	89 84 24 14 04 00 00 	mov    %eax,0x414(%esp)
 464:	81 bc 24 14 04 00 00 	cmpl   $0x200,0x414(%esp)
 46b:	00 02 00 00 
 46f:	74 24                	je     495 <main+0x495>
          printf(1, "write returned %d : failed\n", r);
 471:	8b 84 24 14 04 00 00 	mov    0x414(%esp),%eax
 478:	89 44 24 08          	mov    %eax,0x8(%esp)
 47c:	c7 44 24 04 30 0e 00 	movl   $0xe30,0x4(%esp)
 483:	00 
 484:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 48b:	e8 9a 04 00 00       	call   92a <printf>
          exit();
 490:	e8 dd 02 00 00       	call   772 <exit>
        }
        total += sizeof(data);
 495:	8b 84 24 24 04 00 00 	mov    0x424(%esp),%eax
 49c:	05 00 02 00 00       	add    $0x200,%eax
 4a1:	89 84 24 24 04 00 00 	mov    %eax,0x424(%esp)
      printf(1, "rm: %s failed to delete\n", path);
      exit();
    }
    
    fd = open(path, O_CREATE | O_RDWR);
      for(j = 0; j < 1024; j++){
 4a8:	83 84 24 28 04 00 00 	addl   $0x1,0x428(%esp)
 4af:	01 
 4b0:	81 bc 24 28 04 00 00 	cmpl   $0x3ff,0x428(%esp)
 4b7:	ff 03 00 00 
 4bb:	0f 8e 34 ff ff ff    	jle    3f5 <main+0x3f5>
          printf(1, "write returned %d : failed\n", r);
          exit();
        }
        total += sizeof(data);
      }
      printf(1, "%d bytes written\n", total);
 4c1:	8b 84 24 24 04 00 00 	mov    0x424(%esp),%eax
 4c8:	89 44 24 08          	mov    %eax,0x8(%esp)
 4cc:	c7 44 24 04 1e 0e 00 	movl   $0xe1e,0x4(%esp)
 4d3:	00 
 4d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4db:	e8 4a 04 00 00       	call   92a <printf>
    close(fd);
 4e0:	8b 84 24 18 04 00 00 	mov    0x418(%esp),%eax
 4e7:	89 04 24             	mov    %eax,(%esp)
 4ea:	e8 ab 02 00 00       	call   79a <close>
  printf(1, "%d bytes read\n", 1024 * 512);
  close(fd);

  printf(1, "3. stress test\n");
  total = 0;
  for (i = 0; i < 20; i++) {
 4ef:	83 84 24 2c 04 00 00 	addl   $0x1,0x42c(%esp)
 4f6:	01 
 4f7:	83 bc 24 2c 04 00 00 	cmpl   $0x13,0x42c(%esp)
 4fe:	13 
 4ff:	0f 8e 6c fe ff ff    	jle    371 <main+0x371>
      }
      printf(1, "%d bytes written\n", total);
    close(fd);
  }

  exit();
 505:	e8 68 02 00 00       	call   772 <exit>

0000050a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 50a:	55                   	push   %ebp
 50b:	89 e5                	mov    %esp,%ebp
 50d:	57                   	push   %edi
 50e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 50f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 512:	8b 55 10             	mov    0x10(%ebp),%edx
 515:	8b 45 0c             	mov    0xc(%ebp),%eax
 518:	89 cb                	mov    %ecx,%ebx
 51a:	89 df                	mov    %ebx,%edi
 51c:	89 d1                	mov    %edx,%ecx
 51e:	fc                   	cld    
 51f:	f3 aa                	rep stos %al,%es:(%edi)
 521:	89 ca                	mov    %ecx,%edx
 523:	89 fb                	mov    %edi,%ebx
 525:	89 5d 08             	mov    %ebx,0x8(%ebp)
 528:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 52b:	5b                   	pop    %ebx
 52c:	5f                   	pop    %edi
 52d:	5d                   	pop    %ebp
 52e:	c3                   	ret    

0000052f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 52f:	55                   	push   %ebp
 530:	89 e5                	mov    %esp,%ebp
 532:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 535:	8b 45 08             	mov    0x8(%ebp),%eax
 538:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 53b:	90                   	nop
 53c:	8b 45 08             	mov    0x8(%ebp),%eax
 53f:	8d 50 01             	lea    0x1(%eax),%edx
 542:	89 55 08             	mov    %edx,0x8(%ebp)
 545:	8b 55 0c             	mov    0xc(%ebp),%edx
 548:	8d 4a 01             	lea    0x1(%edx),%ecx
 54b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 54e:	0f b6 12             	movzbl (%edx),%edx
 551:	88 10                	mov    %dl,(%eax)
 553:	0f b6 00             	movzbl (%eax),%eax
 556:	84 c0                	test   %al,%al
 558:	75 e2                	jne    53c <strcpy+0xd>
    ;
  return os;
 55a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 55d:	c9                   	leave  
 55e:	c3                   	ret    

0000055f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 55f:	55                   	push   %ebp
 560:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 562:	eb 08                	jmp    56c <strcmp+0xd>
    p++, q++;
 564:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 568:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 56c:	8b 45 08             	mov    0x8(%ebp),%eax
 56f:	0f b6 00             	movzbl (%eax),%eax
 572:	84 c0                	test   %al,%al
 574:	74 10                	je     586 <strcmp+0x27>
 576:	8b 45 08             	mov    0x8(%ebp),%eax
 579:	0f b6 10             	movzbl (%eax),%edx
 57c:	8b 45 0c             	mov    0xc(%ebp),%eax
 57f:	0f b6 00             	movzbl (%eax),%eax
 582:	38 c2                	cmp    %al,%dl
 584:	74 de                	je     564 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 586:	8b 45 08             	mov    0x8(%ebp),%eax
 589:	0f b6 00             	movzbl (%eax),%eax
 58c:	0f b6 d0             	movzbl %al,%edx
 58f:	8b 45 0c             	mov    0xc(%ebp),%eax
 592:	0f b6 00             	movzbl (%eax),%eax
 595:	0f b6 c0             	movzbl %al,%eax
 598:	29 c2                	sub    %eax,%edx
 59a:	89 d0                	mov    %edx,%eax
}
 59c:	5d                   	pop    %ebp
 59d:	c3                   	ret    

0000059e <strlen>:

uint
strlen(char *s)
{
 59e:	55                   	push   %ebp
 59f:	89 e5                	mov    %esp,%ebp
 5a1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 5a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 5ab:	eb 04                	jmp    5b1 <strlen+0x13>
 5ad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 5b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5b4:	8b 45 08             	mov    0x8(%ebp),%eax
 5b7:	01 d0                	add    %edx,%eax
 5b9:	0f b6 00             	movzbl (%eax),%eax
 5bc:	84 c0                	test   %al,%al
 5be:	75 ed                	jne    5ad <strlen+0xf>
    ;
  return n;
 5c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5c3:	c9                   	leave  
 5c4:	c3                   	ret    

000005c5 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5c5:	55                   	push   %ebp
 5c6:	89 e5                	mov    %esp,%ebp
 5c8:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 5cb:	8b 45 10             	mov    0x10(%ebp),%eax
 5ce:	89 44 24 08          	mov    %eax,0x8(%esp)
 5d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
 5dc:	89 04 24             	mov    %eax,(%esp)
 5df:	e8 26 ff ff ff       	call   50a <stosb>
  return dst;
 5e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5e7:	c9                   	leave  
 5e8:	c3                   	ret    

000005e9 <strchr>:

char*
strchr(const char *s, char c)
{
 5e9:	55                   	push   %ebp
 5ea:	89 e5                	mov    %esp,%ebp
 5ec:	83 ec 04             	sub    $0x4,%esp
 5ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 5f5:	eb 14                	jmp    60b <strchr+0x22>
    if(*s == c)
 5f7:	8b 45 08             	mov    0x8(%ebp),%eax
 5fa:	0f b6 00             	movzbl (%eax),%eax
 5fd:	3a 45 fc             	cmp    -0x4(%ebp),%al
 600:	75 05                	jne    607 <strchr+0x1e>
      return (char*)s;
 602:	8b 45 08             	mov    0x8(%ebp),%eax
 605:	eb 13                	jmp    61a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 607:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 60b:	8b 45 08             	mov    0x8(%ebp),%eax
 60e:	0f b6 00             	movzbl (%eax),%eax
 611:	84 c0                	test   %al,%al
 613:	75 e2                	jne    5f7 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 615:	b8 00 00 00 00       	mov    $0x0,%eax
}
 61a:	c9                   	leave  
 61b:	c3                   	ret    

0000061c <gets>:

char*
gets(char *buf, int max)
{
 61c:	55                   	push   %ebp
 61d:	89 e5                	mov    %esp,%ebp
 61f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 622:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 629:	eb 4c                	jmp    677 <gets+0x5b>
    cc = read(0, &c, 1);
 62b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 632:	00 
 633:	8d 45 ef             	lea    -0x11(%ebp),%eax
 636:	89 44 24 04          	mov    %eax,0x4(%esp)
 63a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 641:	e8 44 01 00 00       	call   78a <read>
 646:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 649:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 64d:	7f 02                	jg     651 <gets+0x35>
      break;
 64f:	eb 31                	jmp    682 <gets+0x66>
    buf[i++] = c;
 651:	8b 45 f4             	mov    -0xc(%ebp),%eax
 654:	8d 50 01             	lea    0x1(%eax),%edx
 657:	89 55 f4             	mov    %edx,-0xc(%ebp)
 65a:	89 c2                	mov    %eax,%edx
 65c:	8b 45 08             	mov    0x8(%ebp),%eax
 65f:	01 c2                	add    %eax,%edx
 661:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 665:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 667:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 66b:	3c 0a                	cmp    $0xa,%al
 66d:	74 13                	je     682 <gets+0x66>
 66f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 673:	3c 0d                	cmp    $0xd,%al
 675:	74 0b                	je     682 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 677:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67a:	83 c0 01             	add    $0x1,%eax
 67d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 680:	7c a9                	jl     62b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 682:	8b 55 f4             	mov    -0xc(%ebp),%edx
 685:	8b 45 08             	mov    0x8(%ebp),%eax
 688:	01 d0                	add    %edx,%eax
 68a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 68d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 690:	c9                   	leave  
 691:	c3                   	ret    

00000692 <stat>:

int
stat(char *n, struct stat *st)
{
 692:	55                   	push   %ebp
 693:	89 e5                	mov    %esp,%ebp
 695:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 698:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 69f:	00 
 6a0:	8b 45 08             	mov    0x8(%ebp),%eax
 6a3:	89 04 24             	mov    %eax,(%esp)
 6a6:	e8 07 01 00 00       	call   7b2 <open>
 6ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 6ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6b2:	79 07                	jns    6bb <stat+0x29>
    return -1;
 6b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 6b9:	eb 23                	jmp    6de <stat+0x4c>
  r = fstat(fd, st);
 6bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 6be:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c5:	89 04 24             	mov    %eax,(%esp)
 6c8:	e8 fd 00 00 00       	call   7ca <fstat>
 6cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 6d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d3:	89 04 24             	mov    %eax,(%esp)
 6d6:	e8 bf 00 00 00       	call   79a <close>
  return r;
 6db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 6de:	c9                   	leave  
 6df:	c3                   	ret    

000006e0 <atoi>:

int
atoi(const char *s)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 6e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 6ed:	eb 25                	jmp    714 <atoi+0x34>
    n = n*10 + *s++ - '0';
 6ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6f2:	89 d0                	mov    %edx,%eax
 6f4:	c1 e0 02             	shl    $0x2,%eax
 6f7:	01 d0                	add    %edx,%eax
 6f9:	01 c0                	add    %eax,%eax
 6fb:	89 c1                	mov    %eax,%ecx
 6fd:	8b 45 08             	mov    0x8(%ebp),%eax
 700:	8d 50 01             	lea    0x1(%eax),%edx
 703:	89 55 08             	mov    %edx,0x8(%ebp)
 706:	0f b6 00             	movzbl (%eax),%eax
 709:	0f be c0             	movsbl %al,%eax
 70c:	01 c8                	add    %ecx,%eax
 70e:	83 e8 30             	sub    $0x30,%eax
 711:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 714:	8b 45 08             	mov    0x8(%ebp),%eax
 717:	0f b6 00             	movzbl (%eax),%eax
 71a:	3c 2f                	cmp    $0x2f,%al
 71c:	7e 0a                	jle    728 <atoi+0x48>
 71e:	8b 45 08             	mov    0x8(%ebp),%eax
 721:	0f b6 00             	movzbl (%eax),%eax
 724:	3c 39                	cmp    $0x39,%al
 726:	7e c7                	jle    6ef <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 72b:	c9                   	leave  
 72c:	c3                   	ret    

0000072d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 72d:	55                   	push   %ebp
 72e:	89 e5                	mov    %esp,%ebp
 730:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 733:	8b 45 08             	mov    0x8(%ebp),%eax
 736:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 739:	8b 45 0c             	mov    0xc(%ebp),%eax
 73c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 73f:	eb 17                	jmp    758 <memmove+0x2b>
    *dst++ = *src++;
 741:	8b 45 fc             	mov    -0x4(%ebp),%eax
 744:	8d 50 01             	lea    0x1(%eax),%edx
 747:	89 55 fc             	mov    %edx,-0x4(%ebp)
 74a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 74d:	8d 4a 01             	lea    0x1(%edx),%ecx
 750:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 753:	0f b6 12             	movzbl (%edx),%edx
 756:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 758:	8b 45 10             	mov    0x10(%ebp),%eax
 75b:	8d 50 ff             	lea    -0x1(%eax),%edx
 75e:	89 55 10             	mov    %edx,0x10(%ebp)
 761:	85 c0                	test   %eax,%eax
 763:	7f dc                	jg     741 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 765:	8b 45 08             	mov    0x8(%ebp),%eax
}
 768:	c9                   	leave  
 769:	c3                   	ret    

0000076a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 76a:	b8 01 00 00 00       	mov    $0x1,%eax
 76f:	cd 40                	int    $0x40
 771:	c3                   	ret    

00000772 <exit>:
SYSCALL(exit)
 772:	b8 02 00 00 00       	mov    $0x2,%eax
 777:	cd 40                	int    $0x40
 779:	c3                   	ret    

0000077a <wait>:
SYSCALL(wait)
 77a:	b8 03 00 00 00       	mov    $0x3,%eax
 77f:	cd 40                	int    $0x40
 781:	c3                   	ret    

00000782 <pipe>:
SYSCALL(pipe)
 782:	b8 04 00 00 00       	mov    $0x4,%eax
 787:	cd 40                	int    $0x40
 789:	c3                   	ret    

0000078a <read>:
SYSCALL(read)
 78a:	b8 05 00 00 00       	mov    $0x5,%eax
 78f:	cd 40                	int    $0x40
 791:	c3                   	ret    

00000792 <write>:
SYSCALL(write)
 792:	b8 10 00 00 00       	mov    $0x10,%eax
 797:	cd 40                	int    $0x40
 799:	c3                   	ret    

0000079a <close>:
SYSCALL(close)
 79a:	b8 15 00 00 00       	mov    $0x15,%eax
 79f:	cd 40                	int    $0x40
 7a1:	c3                   	ret    

000007a2 <kill>:
SYSCALL(kill)
 7a2:	b8 06 00 00 00       	mov    $0x6,%eax
 7a7:	cd 40                	int    $0x40
 7a9:	c3                   	ret    

000007aa <exec>:
SYSCALL(exec)
 7aa:	b8 07 00 00 00       	mov    $0x7,%eax
 7af:	cd 40                	int    $0x40
 7b1:	c3                   	ret    

000007b2 <open>:
SYSCALL(open)
 7b2:	b8 0f 00 00 00       	mov    $0xf,%eax
 7b7:	cd 40                	int    $0x40
 7b9:	c3                   	ret    

000007ba <mknod>:
SYSCALL(mknod)
 7ba:	b8 11 00 00 00       	mov    $0x11,%eax
 7bf:	cd 40                	int    $0x40
 7c1:	c3                   	ret    

000007c2 <unlink>:
SYSCALL(unlink)
 7c2:	b8 12 00 00 00       	mov    $0x12,%eax
 7c7:	cd 40                	int    $0x40
 7c9:	c3                   	ret    

000007ca <fstat>:
SYSCALL(fstat)
 7ca:	b8 08 00 00 00       	mov    $0x8,%eax
 7cf:	cd 40                	int    $0x40
 7d1:	c3                   	ret    

000007d2 <link>:
SYSCALL(link)
 7d2:	b8 13 00 00 00       	mov    $0x13,%eax
 7d7:	cd 40                	int    $0x40
 7d9:	c3                   	ret    

000007da <mkdir>:
SYSCALL(mkdir)
 7da:	b8 14 00 00 00       	mov    $0x14,%eax
 7df:	cd 40                	int    $0x40
 7e1:	c3                   	ret    

000007e2 <chdir>:
SYSCALL(chdir)
 7e2:	b8 09 00 00 00       	mov    $0x9,%eax
 7e7:	cd 40                	int    $0x40
 7e9:	c3                   	ret    

000007ea <dup>:
SYSCALL(dup)
 7ea:	b8 0a 00 00 00       	mov    $0xa,%eax
 7ef:	cd 40                	int    $0x40
 7f1:	c3                   	ret    

000007f2 <getpid>:
SYSCALL(getpid)
 7f2:	b8 0b 00 00 00       	mov    $0xb,%eax
 7f7:	cd 40                	int    $0x40
 7f9:	c3                   	ret    

000007fa <sbrk>:
SYSCALL(sbrk)
 7fa:	b8 0c 00 00 00       	mov    $0xc,%eax
 7ff:	cd 40                	int    $0x40
 801:	c3                   	ret    

00000802 <sleep>:
SYSCALL(sleep)
 802:	b8 0d 00 00 00       	mov    $0xd,%eax
 807:	cd 40                	int    $0x40
 809:	c3                   	ret    

0000080a <uptime>:
SYSCALL(uptime)
 80a:	b8 0e 00 00 00       	mov    $0xe,%eax
 80f:	cd 40                	int    $0x40
 811:	c3                   	ret    

00000812 <my_syscall>:
SYSCALL(my_syscall)
 812:	b8 16 00 00 00       	mov    $0x16,%eax
 817:	cd 40                	int    $0x40
 819:	c3                   	ret    

0000081a <getppid>:
SYSCALL(getppid)
 81a:	b8 17 00 00 00       	mov    $0x17,%eax
 81f:	cd 40                	int    $0x40
 821:	c3                   	ret    

00000822 <yield>:
SYSCALL(yield)
 822:	b8 18 00 00 00       	mov    $0x18,%eax
 827:	cd 40                	int    $0x40
 829:	c3                   	ret    

0000082a <getlev>:
SYSCALL(getlev)
 82a:	b8 19 00 00 00       	mov    $0x19,%eax
 82f:	cd 40                	int    $0x40
 831:	c3                   	ret    

00000832 <clone>:
SYSCALL(clone)
 832:	b8 1a 00 00 00       	mov    $0x1a,%eax
 837:	cd 40                	int    $0x40
 839:	c3                   	ret    

0000083a <join>:
SYSCALL(join)
 83a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 83f:	cd 40                	int    $0x40
 841:	c3                   	ret    

00000842 <thexit>:
SYSCALL(thexit)
 842:	b8 1c 00 00 00       	mov    $0x1c,%eax
 847:	cd 40                	int    $0x40
 849:	c3                   	ret    

0000084a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 84a:	55                   	push   %ebp
 84b:	89 e5                	mov    %esp,%ebp
 84d:	83 ec 18             	sub    $0x18,%esp
 850:	8b 45 0c             	mov    0xc(%ebp),%eax
 853:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 856:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 85d:	00 
 85e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 861:	89 44 24 04          	mov    %eax,0x4(%esp)
 865:	8b 45 08             	mov    0x8(%ebp),%eax
 868:	89 04 24             	mov    %eax,(%esp)
 86b:	e8 22 ff ff ff       	call   792 <write>
}
 870:	c9                   	leave  
 871:	c3                   	ret    

00000872 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 872:	55                   	push   %ebp
 873:	89 e5                	mov    %esp,%ebp
 875:	56                   	push   %esi
 876:	53                   	push   %ebx
 877:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 87a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 881:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 885:	74 17                	je     89e <printint+0x2c>
 887:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 88b:	79 11                	jns    89e <printint+0x2c>
    neg = 1;
 88d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 894:	8b 45 0c             	mov    0xc(%ebp),%eax
 897:	f7 d8                	neg    %eax
 899:	89 45 ec             	mov    %eax,-0x14(%ebp)
 89c:	eb 06                	jmp    8a4 <printint+0x32>
  } else {
    x = xx;
 89e:	8b 45 0c             	mov    0xc(%ebp),%eax
 8a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 8a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 8ab:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 8ae:	8d 41 01             	lea    0x1(%ecx),%eax
 8b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 8b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ba:	ba 00 00 00 00       	mov    $0x0,%edx
 8bf:	f7 f3                	div    %ebx
 8c1:	89 d0                	mov    %edx,%eax
 8c3:	0f b6 80 c4 11 00 00 	movzbl 0x11c4(%eax),%eax
 8ca:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 8ce:	8b 75 10             	mov    0x10(%ebp),%esi
 8d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8d4:	ba 00 00 00 00       	mov    $0x0,%edx
 8d9:	f7 f6                	div    %esi
 8db:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8e2:	75 c7                	jne    8ab <printint+0x39>
  if(neg)
 8e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8e8:	74 10                	je     8fa <printint+0x88>
    buf[i++] = '-';
 8ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ed:	8d 50 01             	lea    0x1(%eax),%edx
 8f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8f3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 8f8:	eb 1f                	jmp    919 <printint+0xa7>
 8fa:	eb 1d                	jmp    919 <printint+0xa7>
    putc(fd, buf[i]);
 8fc:	8d 55 dc             	lea    -0x24(%ebp),%edx
 8ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 902:	01 d0                	add    %edx,%eax
 904:	0f b6 00             	movzbl (%eax),%eax
 907:	0f be c0             	movsbl %al,%eax
 90a:	89 44 24 04          	mov    %eax,0x4(%esp)
 90e:	8b 45 08             	mov    0x8(%ebp),%eax
 911:	89 04 24             	mov    %eax,(%esp)
 914:	e8 31 ff ff ff       	call   84a <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 919:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 91d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 921:	79 d9                	jns    8fc <printint+0x8a>
    putc(fd, buf[i]);
}
 923:	83 c4 30             	add    $0x30,%esp
 926:	5b                   	pop    %ebx
 927:	5e                   	pop    %esi
 928:	5d                   	pop    %ebp
 929:	c3                   	ret    

0000092a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 92a:	55                   	push   %ebp
 92b:	89 e5                	mov    %esp,%ebp
 92d:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 930:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 937:	8d 45 0c             	lea    0xc(%ebp),%eax
 93a:	83 c0 04             	add    $0x4,%eax
 93d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 940:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 947:	e9 7c 01 00 00       	jmp    ac8 <printf+0x19e>
    c = fmt[i] & 0xff;
 94c:	8b 55 0c             	mov    0xc(%ebp),%edx
 94f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 952:	01 d0                	add    %edx,%eax
 954:	0f b6 00             	movzbl (%eax),%eax
 957:	0f be c0             	movsbl %al,%eax
 95a:	25 ff 00 00 00       	and    $0xff,%eax
 95f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 962:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 966:	75 2c                	jne    994 <printf+0x6a>
      if(c == '%'){
 968:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 96c:	75 0c                	jne    97a <printf+0x50>
        state = '%';
 96e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 975:	e9 4a 01 00 00       	jmp    ac4 <printf+0x19a>
      } else {
        putc(fd, c);
 97a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 97d:	0f be c0             	movsbl %al,%eax
 980:	89 44 24 04          	mov    %eax,0x4(%esp)
 984:	8b 45 08             	mov    0x8(%ebp),%eax
 987:	89 04 24             	mov    %eax,(%esp)
 98a:	e8 bb fe ff ff       	call   84a <putc>
 98f:	e9 30 01 00 00       	jmp    ac4 <printf+0x19a>
      }
    } else if(state == '%'){
 994:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 998:	0f 85 26 01 00 00    	jne    ac4 <printf+0x19a>
      if(c == 'd'){
 99e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 9a2:	75 2d                	jne    9d1 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 9a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9a7:	8b 00                	mov    (%eax),%eax
 9a9:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 9b0:	00 
 9b1:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 9b8:	00 
 9b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 9bd:	8b 45 08             	mov    0x8(%ebp),%eax
 9c0:	89 04 24             	mov    %eax,(%esp)
 9c3:	e8 aa fe ff ff       	call   872 <printint>
        ap++;
 9c8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9cc:	e9 ec 00 00 00       	jmp    abd <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 9d1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 9d5:	74 06                	je     9dd <printf+0xb3>
 9d7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 9db:	75 2d                	jne    a0a <printf+0xe0>
        printint(fd, *ap, 16, 0);
 9dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9e0:	8b 00                	mov    (%eax),%eax
 9e2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 9e9:	00 
 9ea:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 9f1:	00 
 9f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 9f6:	8b 45 08             	mov    0x8(%ebp),%eax
 9f9:	89 04 24             	mov    %eax,(%esp)
 9fc:	e8 71 fe ff ff       	call   872 <printint>
        ap++;
 a01:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a05:	e9 b3 00 00 00       	jmp    abd <printf+0x193>
      } else if(c == 's'){
 a0a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 a0e:	75 45                	jne    a55 <printf+0x12b>
        s = (char*)*ap;
 a10:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a13:	8b 00                	mov    (%eax),%eax
 a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 a18:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 a1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a20:	75 09                	jne    a2b <printf+0x101>
          s = "(null)";
 a22:	c7 45 f4 f7 0e 00 00 	movl   $0xef7,-0xc(%ebp)
        while(*s != 0){
 a29:	eb 1e                	jmp    a49 <printf+0x11f>
 a2b:	eb 1c                	jmp    a49 <printf+0x11f>
          putc(fd, *s);
 a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a30:	0f b6 00             	movzbl (%eax),%eax
 a33:	0f be c0             	movsbl %al,%eax
 a36:	89 44 24 04          	mov    %eax,0x4(%esp)
 a3a:	8b 45 08             	mov    0x8(%ebp),%eax
 a3d:	89 04 24             	mov    %eax,(%esp)
 a40:	e8 05 fe ff ff       	call   84a <putc>
          s++;
 a45:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4c:	0f b6 00             	movzbl (%eax),%eax
 a4f:	84 c0                	test   %al,%al
 a51:	75 da                	jne    a2d <printf+0x103>
 a53:	eb 68                	jmp    abd <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 a55:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 a59:	75 1d                	jne    a78 <printf+0x14e>
        putc(fd, *ap);
 a5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a5e:	8b 00                	mov    (%eax),%eax
 a60:	0f be c0             	movsbl %al,%eax
 a63:	89 44 24 04          	mov    %eax,0x4(%esp)
 a67:	8b 45 08             	mov    0x8(%ebp),%eax
 a6a:	89 04 24             	mov    %eax,(%esp)
 a6d:	e8 d8 fd ff ff       	call   84a <putc>
        ap++;
 a72:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a76:	eb 45                	jmp    abd <printf+0x193>
      } else if(c == '%'){
 a78:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a7c:	75 17                	jne    a95 <printf+0x16b>
        putc(fd, c);
 a7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a81:	0f be c0             	movsbl %al,%eax
 a84:	89 44 24 04          	mov    %eax,0x4(%esp)
 a88:	8b 45 08             	mov    0x8(%ebp),%eax
 a8b:	89 04 24             	mov    %eax,(%esp)
 a8e:	e8 b7 fd ff ff       	call   84a <putc>
 a93:	eb 28                	jmp    abd <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a95:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 a9c:	00 
 a9d:	8b 45 08             	mov    0x8(%ebp),%eax
 aa0:	89 04 24             	mov    %eax,(%esp)
 aa3:	e8 a2 fd ff ff       	call   84a <putc>
        putc(fd, c);
 aa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 aab:	0f be c0             	movsbl %al,%eax
 aae:	89 44 24 04          	mov    %eax,0x4(%esp)
 ab2:	8b 45 08             	mov    0x8(%ebp),%eax
 ab5:	89 04 24             	mov    %eax,(%esp)
 ab8:	e8 8d fd ff ff       	call   84a <putc>
      }
      state = 0;
 abd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 ac4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 ac8:	8b 55 0c             	mov    0xc(%ebp),%edx
 acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ace:	01 d0                	add    %edx,%eax
 ad0:	0f b6 00             	movzbl (%eax),%eax
 ad3:	84 c0                	test   %al,%al
 ad5:	0f 85 71 fe ff ff    	jne    94c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 adb:	c9                   	leave  
 adc:	c3                   	ret    

00000add <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 add:	55                   	push   %ebp
 ade:	89 e5                	mov    %esp,%ebp
 ae0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ae3:	8b 45 08             	mov    0x8(%ebp),%eax
 ae6:	83 e8 08             	sub    $0x8,%eax
 ae9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aec:	a1 e0 11 00 00       	mov    0x11e0,%eax
 af1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 af4:	eb 24                	jmp    b1a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 af6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af9:	8b 00                	mov    (%eax),%eax
 afb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 afe:	77 12                	ja     b12 <free+0x35>
 b00:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b03:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b06:	77 24                	ja     b2c <free+0x4f>
 b08:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b0b:	8b 00                	mov    (%eax),%eax
 b0d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b10:	77 1a                	ja     b2c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b12:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b15:	8b 00                	mov    (%eax),%eax
 b17:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b1d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b20:	76 d4                	jbe    af6 <free+0x19>
 b22:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b25:	8b 00                	mov    (%eax),%eax
 b27:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b2a:	76 ca                	jbe    af6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 b2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b2f:	8b 40 04             	mov    0x4(%eax),%eax
 b32:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b39:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b3c:	01 c2                	add    %eax,%edx
 b3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b41:	8b 00                	mov    (%eax),%eax
 b43:	39 c2                	cmp    %eax,%edx
 b45:	75 24                	jne    b6b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 b47:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b4a:	8b 50 04             	mov    0x4(%eax),%edx
 b4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b50:	8b 00                	mov    (%eax),%eax
 b52:	8b 40 04             	mov    0x4(%eax),%eax
 b55:	01 c2                	add    %eax,%edx
 b57:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b5a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 b5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b60:	8b 00                	mov    (%eax),%eax
 b62:	8b 10                	mov    (%eax),%edx
 b64:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b67:	89 10                	mov    %edx,(%eax)
 b69:	eb 0a                	jmp    b75 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 b6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b6e:	8b 10                	mov    (%eax),%edx
 b70:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b73:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 b75:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b78:	8b 40 04             	mov    0x4(%eax),%eax
 b7b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b82:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b85:	01 d0                	add    %edx,%eax
 b87:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b8a:	75 20                	jne    bac <free+0xcf>
    p->s.size += bp->s.size;
 b8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b8f:	8b 50 04             	mov    0x4(%eax),%edx
 b92:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b95:	8b 40 04             	mov    0x4(%eax),%eax
 b98:	01 c2                	add    %eax,%edx
 b9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b9d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 ba0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ba3:	8b 10                	mov    (%eax),%edx
 ba5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ba8:	89 10                	mov    %edx,(%eax)
 baa:	eb 08                	jmp    bb4 <free+0xd7>
  } else
    p->s.ptr = bp;
 bac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 baf:	8b 55 f8             	mov    -0x8(%ebp),%edx
 bb2:	89 10                	mov    %edx,(%eax)
  freep = p;
 bb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bb7:	a3 e0 11 00 00       	mov    %eax,0x11e0
}
 bbc:	c9                   	leave  
 bbd:	c3                   	ret    

00000bbe <morecore>:

static Header*
morecore(uint nu)
{
 bbe:	55                   	push   %ebp
 bbf:	89 e5                	mov    %esp,%ebp
 bc1:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 bc4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 bcb:	77 07                	ja     bd4 <morecore+0x16>
    nu = 4096;
 bcd:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 bd4:	8b 45 08             	mov    0x8(%ebp),%eax
 bd7:	c1 e0 03             	shl    $0x3,%eax
 bda:	89 04 24             	mov    %eax,(%esp)
 bdd:	e8 18 fc ff ff       	call   7fa <sbrk>
 be2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 be5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 be9:	75 07                	jne    bf2 <morecore+0x34>
    return 0;
 beb:	b8 00 00 00 00       	mov    $0x0,%eax
 bf0:	eb 22                	jmp    c14 <morecore+0x56>
  hp = (Header*)p;
 bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bfb:	8b 55 08             	mov    0x8(%ebp),%edx
 bfe:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c04:	83 c0 08             	add    $0x8,%eax
 c07:	89 04 24             	mov    %eax,(%esp)
 c0a:	e8 ce fe ff ff       	call   add <free>
  return freep;
 c0f:	a1 e0 11 00 00       	mov    0x11e0,%eax
}
 c14:	c9                   	leave  
 c15:	c3                   	ret    

00000c16 <malloc>:

void*
malloc(uint nbytes)
{
 c16:	55                   	push   %ebp
 c17:	89 e5                	mov    %esp,%ebp
 c19:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c1c:	8b 45 08             	mov    0x8(%ebp),%eax
 c1f:	83 c0 07             	add    $0x7,%eax
 c22:	c1 e8 03             	shr    $0x3,%eax
 c25:	83 c0 01             	add    $0x1,%eax
 c28:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 c2b:	a1 e0 11 00 00       	mov    0x11e0,%eax
 c30:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 c37:	75 23                	jne    c5c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 c39:	c7 45 f0 d8 11 00 00 	movl   $0x11d8,-0x10(%ebp)
 c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c43:	a3 e0 11 00 00       	mov    %eax,0x11e0
 c48:	a1 e0 11 00 00       	mov    0x11e0,%eax
 c4d:	a3 d8 11 00 00       	mov    %eax,0x11d8
    base.s.size = 0;
 c52:	c7 05 dc 11 00 00 00 	movl   $0x0,0x11dc
 c59:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c5f:	8b 00                	mov    (%eax),%eax
 c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c67:	8b 40 04             	mov    0x4(%eax),%eax
 c6a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c6d:	72 4d                	jb     cbc <malloc+0xa6>
      if(p->s.size == nunits)
 c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c72:	8b 40 04             	mov    0x4(%eax),%eax
 c75:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c78:	75 0c                	jne    c86 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c7d:	8b 10                	mov    (%eax),%edx
 c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c82:	89 10                	mov    %edx,(%eax)
 c84:	eb 26                	jmp    cac <malloc+0x96>
      else {
        p->s.size -= nunits;
 c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c89:	8b 40 04             	mov    0x4(%eax),%eax
 c8c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 c8f:	89 c2                	mov    %eax,%edx
 c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c94:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c9a:	8b 40 04             	mov    0x4(%eax),%eax
 c9d:	c1 e0 03             	shl    $0x3,%eax
 ca0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ca6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ca9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 caf:	a3 e0 11 00 00       	mov    %eax,0x11e0
      return (void*)(p + 1);
 cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cb7:	83 c0 08             	add    $0x8,%eax
 cba:	eb 38                	jmp    cf4 <malloc+0xde>
    }
    if(p == freep)
 cbc:	a1 e0 11 00 00       	mov    0x11e0,%eax
 cc1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 cc4:	75 1b                	jne    ce1 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 cc9:	89 04 24             	mov    %eax,(%esp)
 ccc:	e8 ed fe ff ff       	call   bbe <morecore>
 cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 cd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 cd8:	75 07                	jne    ce1 <malloc+0xcb>
        return 0;
 cda:	b8 00 00 00 00       	mov    $0x0,%eax
 cdf:	eb 13                	jmp    cf4 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ce4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cea:	8b 00                	mov    (%eax),%eax
 cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 cef:	e9 70 ff ff ff       	jmp    c64 <malloc+0x4e>
}
 cf4:	c9                   	leave  
 cf5:	c3                   	ret    

00000cf6 <thread_create>:
#include"x86.h"
#include"param.h"
#include"proc.h"

int thread_create(thread_t *thread, void*(*start_routine)(void*),void *arg)
{
 cf6:	55                   	push   %ebp
 cf7:	89 e5                	mov    %esp,%ebp
 cf9:	83 ec 28             	sub    $0x28,%esp
    void *stack = malloc(PGSIZE);
 cfc:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 d03:	e8 0e ff ff ff       	call   c16 <malloc>
 d08:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if((uint)stack <=0)
 d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d0e:	85 c0                	test   %eax,%eax
 d10:	75 1b                	jne    d2d <thread_create+0x37>
    {
        printf(1,"malloc thread stack failed\n");
 d12:	c7 44 24 04 fe 0e 00 	movl   $0xefe,0x4(%esp)
 d19:	00 
 d1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d21:	e8 04 fc ff ff       	call   92a <printf>
        return -1;
 d26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 d2b:	eb 67                	jmp    d94 <thread_create+0x9e>
    }
    
    if((uint)stack%PGSIZE)
 d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d30:	25 ff 0f 00 00       	and    $0xfff,%eax
 d35:	85 c0                	test   %eax,%eax
 d37:	74 14                	je     d4d <thread_create+0x57>
        stack += PGSIZE-((uint)stack%PGSIZE);
 d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d3c:	25 ff 0f 00 00       	and    $0xfff,%eax
 d41:	89 c2                	mov    %eax,%edx
 d43:	b8 00 10 00 00       	mov    $0x1000,%eax
 d48:	29 d0                	sub    %edx,%eax
 d4a:	01 45 f4             	add    %eax,-0xc(%ebp)
    printf(1,"1\n");
 d4d:	c7 44 24 04 1a 0f 00 	movl   $0xf1a,0x4(%esp)
 d54:	00 
 d55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d5c:	e8 c9 fb ff ff       	call   92a <printf>
    if((*thread = clone(start_routine,arg,stack))<0)
 d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d64:	89 44 24 08          	mov    %eax,0x8(%esp)
 d68:	8b 45 10             	mov    0x10(%ebp),%eax
 d6b:	89 44 24 04          	mov    %eax,0x4(%esp)
 d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
 d72:	89 04 24             	mov    %eax,(%esp)
 d75:	e8 b8 fa ff ff       	call   832 <clone>
 d7a:	8b 55 08             	mov    0x8(%ebp),%edx
 d7d:	89 02                	mov    %eax,(%edx)
 d7f:	8b 45 08             	mov    0x8(%ebp),%eax
 d82:	8b 00                	mov    (%eax),%eax
 d84:	85 c0                	test   %eax,%eax
 d86:	79 07                	jns    d8f <thread_create+0x99>
        return -1;
 d88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 d8d:	eb 05                	jmp    d94 <thread_create+0x9e>
    return 0;
 d8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 d94:	c9                   	leave  
 d95:	c3                   	ret    

00000d96 <thread_join>:

int thread_join(thread_t thread, void **retval)
{
 d96:	55                   	push   %ebp
 d97:	89 e5                	mov    %esp,%ebp
 d99:	83 ec 28             	sub    $0x28,%esp
    void *stack;
    if(join((uint)thread, &stack, retval)<0)
 d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
 d9f:	89 44 24 08          	mov    %eax,0x8(%esp)
 da3:	8d 45 f4             	lea    -0xc(%ebp),%eax
 da6:	89 44 24 04          	mov    %eax,0x4(%esp)
 daa:	8b 45 08             	mov    0x8(%ebp),%eax
 dad:	89 04 24             	mov    %eax,(%esp)
 db0:	e8 85 fa ff ff       	call   83a <join>
 db5:	85 c0                	test   %eax,%eax
 db7:	79 07                	jns    dc0 <thread_join+0x2a>
        return -1;
 db9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 dbe:	eb 10                	jmp    dd0 <thread_join+0x3a>

    free(stack);
 dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dc3:	89 04 24             	mov    %eax,(%esp)
 dc6:	e8 12 fd ff ff       	call   add <free>
    return 0;
 dcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
 dd0:	c9                   	leave  
 dd1:	c3                   	ret    

00000dd2 <thread_exit>:

void thread_exit(void *retval)
{
 dd2:	55                   	push   %ebp
 dd3:	89 e5                	mov    %esp,%ebp
 dd5:	83 ec 08             	sub    $0x8,%esp
    proc->retval = retval;
 dd8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
 dde:	8b 55 08             	mov    0x8(%ebp),%edx
 de1:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
    thexit();
 de7:	e8 56 fa ff ff       	call   842 <thexit>
}
 dec:	c9                   	leave  
 ded:	c3                   	ret    
