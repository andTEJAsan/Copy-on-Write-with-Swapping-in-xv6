
_memtest4:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    exit();
}

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
    // printf(1, "Memtest starting\n");
    mem();
   6:	e8 05 00 00 00       	call   10 <mem>
   b:	66 90                	xchg   %ax,%ax
   d:	66 90                	xchg   %ax,%ax
   f:	90                   	nop

00000010 <mem>:
{
  10:	55                   	push   %ebp
  11:	89 e5                	mov    %esp,%ebp
  13:	57                   	push   %edi
  14:	56                   	push   %esi
  15:	53                   	push   %ebx
  16:	bb c8 00 00 00       	mov    $0xc8,%ebx
  1b:	83 ec 0c             	sub    $0xc,%esp
  1e:	66 90                	xchg   %ax,%ax
        char *memory = (char*) malloc(size); //4kb;
  20:	83 ec 0c             	sub    $0xc,%esp
  23:	68 00 10 00 00       	push   $0x1000
  28:	e8 b3 08 00 00       	call   8e0 <malloc>
    for(int j=0;j<200;++j){
  2d:	83 c4 10             	add    $0x10,%esp
        memory[0] = (char) (65);
  30:	c6 00 41             	movb   $0x41,(%eax)
    for(int j=0;j<200;++j){
  33:	83 eb 01             	sub    $0x1,%ebx
  36:	75 e8                	jne    20 <mem+0x10>
    pid = fork();
  38:	e8 1e 05 00 00       	call   55b <fork>
    if(pid > 0) {
  3d:	85 c0                	test   %eax,%eax
  3f:	0f 8e 8c 00 00 00    	jle    d1 <mem+0xc1>
  45:	be 64 00 00 00       	mov    $0x64,%esi
                memory[k] = (char)(65+(k%26));
  4a:	bf 4f ec c4 4e       	mov    $0x4ec4ec4f,%edi
            char *memory = (char*) malloc(size); //4kb;
  4f:	83 ec 0c             	sub    $0xc,%esp
  52:	68 00 10 00 00       	push   $0x1000
  57:	e8 84 08 00 00       	call   8e0 <malloc>
            if (memory == 0) goto failed;
  5c:	83 c4 10             	add    $0x10,%esp
            char *memory = (char*) malloc(size); //4kb;
  5f:	89 c3                	mov    %eax,%ebx
            if (memory == 0) goto failed;
  61:	85 c0                	test   %eax,%eax
  63:	74 58                	je     bd <mem+0xad>
            for(int k=0;k<size;++k){
  65:	31 c9                	xor    %ecx,%ecx
  67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  6e:	66 90                	xchg   %ax,%ax
                memory[k] = (char)(65+(k%26));
  70:	89 c8                	mov    %ecx,%eax
  72:	f7 e7                	mul    %edi
  74:	89 c8                	mov    %ecx,%eax
  76:	c1 ea 03             	shr    $0x3,%edx
  79:	6b d2 1a             	imul   $0x1a,%edx,%edx
  7c:	29 d0                	sub    %edx,%eax
  7e:	83 c0 41             	add    $0x41,%eax
  81:	88 04 0b             	mov    %al,(%ebx,%ecx,1)
            for(int k=0;k<size;++k){
  84:	83 c1 01             	add    $0x1,%ecx
  87:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  8d:	75 e1                	jne    70 <mem+0x60>
            for(int k=0;k<size;++k){
  8f:	31 c9                	xor    %ecx,%ecx
  91:	eb 14                	jmp    a7 <mem+0x97>
  93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  97:	90                   	nop
  98:	83 c1 01             	add    $0x1,%ecx
  9b:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  a1:	0f 84 d1 00 00 00    	je     178 <mem+0x168>
                if(memory[k] != (char)(65+(k%26))) goto failed;
  a7:	89 c8                	mov    %ecx,%eax
  a9:	f7 e7                	mul    %edi
  ab:	89 c8                	mov    %ecx,%eax
  ad:	c1 ea 03             	shr    $0x3,%edx
  b0:	6b d2 1a             	imul   $0x1a,%edx,%edx
  b3:	29 d0                	sub    %edx,%eax
  b5:	83 c0 41             	add    $0x41,%eax
  b8:	38 04 0b             	cmp    %al,(%ebx,%ecx,1)
  bb:	74 db                	je     98 <mem+0x88>
    printf(1, "memtest4 Failed!\n");
  bd:	83 ec 08             	sub    $0x8,%esp
  c0:	68 3b 0a 00 00       	push   $0xa3b
  c5:	6a 01                	push   $0x1
  c7:	e8 f4 05 00 00       	call   6c0 <printf>
    exit();
  cc:	e8 92 04 00 00       	call   563 <exit>
    else if(pid < 0){ 
  d1:	0f 85 8b 00 00 00    	jne    162 <mem+0x152>
        sleep(100);
  d7:	83 ec 0c             	sub    $0xc,%esp
  da:	be 34 01 00 00       	mov    $0x134,%esi
                memory[k] = (char)(65+(k%26));
  df:	bf 4f ec c4 4e       	mov    $0x4ec4ec4f,%edi
        sleep(100);
  e4:	6a 64                	push   $0x64
  e6:	e8 08 05 00 00       	call   5f3 <sleep>
  eb:	83 c4 10             	add    $0x10,%esp
            char *memory = (char*) malloc(size); //4kb;
  ee:	83 ec 0c             	sub    $0xc,%esp
  f1:	68 00 10 00 00       	push   $0x1000
  f6:	e8 e5 07 00 00       	call   8e0 <malloc>
            if (memory == 0) goto failed;
  fb:	83 c4 10             	add    $0x10,%esp
            char *memory = (char*) malloc(size); //4kb;
  fe:	89 c3                	mov    %eax,%ebx
            if (memory == 0) goto failed;
 100:	85 c0                	test   %eax,%eax
 102:	74 b9                	je     bd <mem+0xad>
            for(int k=0;k<size;++k){
 104:	31 c9                	xor    %ecx,%ecx
 106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10d:	8d 76 00             	lea    0x0(%esi),%esi
                memory[k] = (char)(65+(k%26));
 110:	89 c8                	mov    %ecx,%eax
 112:	f7 e7                	mul    %edi
 114:	89 c8                	mov    %ecx,%eax
 116:	c1 ea 03             	shr    $0x3,%edx
 119:	6b d2 1a             	imul   $0x1a,%edx,%edx
 11c:	29 d0                	sub    %edx,%eax
 11e:	83 c0 41             	add    $0x41,%eax
 121:	88 04 0b             	mov    %al,(%ebx,%ecx,1)
            for(int k=0;k<size;++k){
 124:	83 c1 01             	add    $0x1,%ecx
 127:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
 12d:	75 e1                	jne    110 <mem+0x100>
            for(int k=0;k<size;++k){
 12f:	31 c9                	xor    %ecx,%ecx
 131:	eb 14                	jmp    147 <mem+0x137>
 133:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 137:	90                   	nop
 138:	83 c1 01             	add    $0x1,%ecx
 13b:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
 141:	0f 84 c3 00 00 00    	je     20a <mem+0x1fa>
                if(memory[k] != (char)(65+(k%26))) goto failed;
 147:	89 c8                	mov    %ecx,%eax
 149:	f7 e7                	mul    %edi
 14b:	89 c8                	mov    %ecx,%eax
 14d:	c1 ea 03             	shr    $0x3,%edx
 150:	6b d2 1a             	imul   $0x1a,%edx,%edx
 153:	29 d0                	sub    %edx,%eax
 155:	83 c0 41             	add    $0x41,%eax
 158:	38 04 0b             	cmp    %al,(%ebx,%ecx,1)
 15b:	74 db                	je     138 <mem+0x128>
 15d:	e9 5b ff ff ff       	jmp    bd <mem+0xad>
            printf(1, "Fork Failed\n");
 162:	50                   	push   %eax
 163:	50                   	push   %eax
 164:	68 da 09 00 00       	push   $0x9da
 169:	6a 01                	push   $0x1
 16b:	e8 50 05 00 00       	call   6c0 <printf>
 170:	83 c4 10             	add    $0x10,%esp
        exit();
 173:	e8 eb 03 00 00       	call   563 <exit>
        for(int j=0;j<100;++j){
 178:	83 ee 01             	sub    $0x1,%esi
 17b:	0f 85 ce fe ff ff    	jne    4f <mem+0x3f>
        printf(1,"Parent alloc-ed:\n");
 181:	50                   	push   %eax
 182:	50                   	push   %eax
 183:	68 c8 09 00 00       	push   $0x9c8
 188:	6a 01                	push   $0x1
 18a:	e8 31 05 00 00       	call   6c0 <printf>
        getrss();
 18f:	e8 6f 04 00 00       	call   603 <getrss>
        wait();
 194:	e8 d2 03 00 00       	call   56b <wait>
        pid = fork();
 199:	e8 bd 03 00 00       	call   55b <fork>
        if (pid > 0)
 19e:	83 c4 10             	add    $0x10,%esp
 1a1:	85 c0                	test   %eax,%eax
 1a3:	0f 8e 93 00 00 00    	jle    23c <mem+0x22c>
 1a9:	bf 64 00 00 00       	mov    $0x64,%edi
                    memory[k] = (char)(65 + (k % 26));
 1ae:	bb 1a 00 00 00       	mov    $0x1a,%ebx
                char *memory = (char *)malloc(size); // 4kb;
 1b3:	83 ec 0c             	sub    $0xc,%esp
 1b6:	68 00 10 00 00       	push   $0x1000
 1bb:	e8 20 07 00 00       	call   8e0 <malloc>
                if (memory == 0)
 1c0:	83 c4 10             	add    $0x10,%esp
                char *memory = (char *)malloc(size); // 4kb;
 1c3:	89 c6                	mov    %eax,%esi
                if (memory == 0)
 1c5:	85 c0                	test   %eax,%eax
 1c7:	0f 84 f0 fe ff ff    	je     bd <mem+0xad>
                for (int k = 0; k < size; ++k)
 1cd:	31 c9                	xor    %ecx,%ecx
                    memory[k] = (char)(65 + (k % 26));
 1cf:	89 c8                	mov    %ecx,%eax
 1d1:	99                   	cltd
 1d2:	f7 fb                	idiv   %ebx
 1d4:	83 c2 41             	add    $0x41,%edx
 1d7:	88 14 0e             	mov    %dl,(%esi,%ecx,1)
                for (int k = 0; k < size; ++k)
 1da:	83 c1 01             	add    $0x1,%ecx
 1dd:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
 1e3:	75 ea                	jne    1cf <mem+0x1bf>
                for (int k = 0; k < size; ++k)
 1e5:	31 c9                	xor    %ecx,%ecx
 1e7:	eb 0f                	jmp    1f8 <mem+0x1e8>
 1e9:	83 c1 01             	add    $0x1,%ecx
 1ec:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
 1f2:	0f 84 be 00 00 00    	je     2b6 <mem+0x2a6>
                    if (memory[k] != (char)(65 + (k % 26)))
 1f8:	89 c8                	mov    %ecx,%eax
 1fa:	99                   	cltd
 1fb:	f7 fb                	idiv   %ebx
 1fd:	83 c2 41             	add    $0x41,%edx
 200:	38 14 0e             	cmp    %dl,(%esi,%ecx,1)
 203:	74 e4                	je     1e9 <mem+0x1d9>
 205:	e9 b3 fe ff ff       	jmp    bd <mem+0xad>
        for(int j=0;j<308;++j){
 20a:	83 ee 01             	sub    $0x1,%esi
 20d:	0f 85 db fe ff ff    	jne    ee <mem+0xde>
        printf(1,"Child alloc-ed\n");
 213:	50                   	push   %eax
 214:	50                   	push   %eax
 215:	68 e7 09 00 00       	push   $0x9e7
 21a:	6a 01                	push   $0x1
 21c:	e8 9f 04 00 00       	call   6c0 <printf>
        getrss();
 221:	e8 dd 03 00 00       	call   603 <getrss>
        printf(1, "memtest4 Passed part 1!\n");
 226:	5a                   	pop    %edx
 227:	59                   	pop    %ecx
 228:	68 22 0a 00 00       	push   $0xa22
 22d:	6a 01                	push   $0x1
 22f:	e8 8c 04 00 00       	call   6c0 <printf>
 234:	83 c4 10             	add    $0x10,%esp
 237:	e9 37 ff ff ff       	jmp    173 <mem+0x163>
        else if (pid < 0)
 23c:	0f 85 20 ff ff ff    	jne    162 <mem+0x152>
            sleep(100);
 242:	83 ec 0c             	sub    $0xc,%esp
 245:	bf 34 01 00 00       	mov    $0x134,%edi
                    memory[k] = (char)(65 + (k % 26));
 24a:	be 1a 00 00 00       	mov    $0x1a,%esi
            sleep(100);
 24f:	6a 64                	push   $0x64
 251:	e8 9d 03 00 00       	call   5f3 <sleep>
 256:	83 c4 10             	add    $0x10,%esp
                char *memory = (char *)malloc(size); // 4kb;
 259:	83 ec 0c             	sub    $0xc,%esp
 25c:	68 00 10 00 00       	push   $0x1000
 261:	e8 7a 06 00 00       	call   8e0 <malloc>
                if (memory == 0)
 266:	83 c4 10             	add    $0x10,%esp
                char *memory = (char *)malloc(size); // 4kb;
 269:	89 c3                	mov    %eax,%ebx
                if (memory == 0)
 26b:	85 c0                	test   %eax,%eax
 26d:	74 34                	je     2a3 <mem+0x293>
                for (int k = 0; k < size; ++k)
 26f:	31 c9                	xor    %ecx,%ecx
                    memory[k] = (char)(65 + (k % 26));
 271:	89 c8                	mov    %ecx,%eax
 273:	99                   	cltd
 274:	f7 fe                	idiv   %esi
 276:	83 c2 41             	add    $0x41,%edx
 279:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
                for (int k = 0; k < size; ++k)
 27c:	83 c1 01             	add    $0x1,%ecx
 27f:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
 285:	75 ea                	jne    271 <mem+0x261>
                for (int k = 0; k < size; ++k)
 287:	31 c9                	xor    %ecx,%ecx
 289:	eb 0b                	jmp    296 <mem+0x286>
 28b:	83 c1 01             	add    $0x1,%ecx
 28e:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
 294:	74 49                	je     2df <mem+0x2cf>
                    if (memory[k] != (char)(65 + (k % 26)))
 296:	89 c8                	mov    %ecx,%eax
 298:	99                   	cltd
 299:	f7 fe                	idiv   %esi
 29b:	83 c2 41             	add    $0x41,%edx
 29e:	38 14 0b             	cmp    %dl,(%ebx,%ecx,1)
 2a1:	74 e8                	je     28b <mem+0x27b>
        printf(1, "memtest3 Failed!\n");
 2a3:	53                   	push   %ebx
 2a4:	53                   	push   %ebx
 2a5:	68 10 0a 00 00       	push   $0xa10
 2aa:	6a 01                	push   $0x1
 2ac:	e8 0f 04 00 00       	call   6c0 <printf>
        exit();
 2b1:	e8 ad 02 00 00       	call   563 <exit>
            for (int j = 0; j < 100; ++j)
 2b6:	83 ef 01             	sub    $0x1,%edi
 2b9:	0f 85 f4 fe ff ff    	jne    1b3 <mem+0x1a3>
            printf(1, "Parent alloc-ed:\n");
 2bf:	50                   	push   %eax
 2c0:	50                   	push   %eax
 2c1:	68 c8 09 00 00       	push   $0x9c8
 2c6:	6a 01                	push   $0x1
 2c8:	e8 f3 03 00 00       	call   6c0 <printf>
            getrss();
 2cd:	e8 31 03 00 00       	call   603 <getrss>
            wait();
 2d2:	e8 94 02 00 00       	call   56b <wait>
 2d7:	83 c4 10             	add    $0x10,%esp
 2da:	e9 94 fe ff ff       	jmp    173 <mem+0x163>
            for (int j = 0; j < 308; ++j)
 2df:	83 ef 01             	sub    $0x1,%edi
 2e2:	0f 85 71 ff ff ff    	jne    259 <mem+0x249>
            printf(1, "Child alloc-ed\n");
 2e8:	56                   	push   %esi
 2e9:	56                   	push   %esi
 2ea:	68 e7 09 00 00       	push   $0x9e7
 2ef:	6a 01                	push   $0x1
 2f1:	e8 ca 03 00 00       	call   6c0 <printf>
            getrss();
 2f6:	e8 08 03 00 00       	call   603 <getrss>
            printf(1, "memtest3 Passed part 2!\n");
 2fb:	5f                   	pop    %edi
 2fc:	58                   	pop    %eax
 2fd:	68 f7 09 00 00       	push   $0x9f7
 302:	6a 01                	push   $0x1
 304:	e8 b7 03 00 00       	call   6c0 <printf>
 309:	83 c4 10             	add    $0x10,%esp
 30c:	e9 62 fe ff ff       	jmp    173 <mem+0x163>
 311:	66 90                	xchg   %ax,%ax
 313:	66 90                	xchg   %ax,%ax
 315:	66 90                	xchg   %ax,%ax
 317:	66 90                	xchg   %ax,%ax
 319:	66 90                	xchg   %ax,%ax
 31b:	66 90                	xchg   %ax,%ax
 31d:	66 90                	xchg   %ax,%ax
 31f:	90                   	nop

00000320 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 320:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 321:	31 c0                	xor    %eax,%eax
{
 323:	89 e5                	mov    %esp,%ebp
 325:	53                   	push   %ebx
 326:	8b 4d 08             	mov    0x8(%ebp),%ecx
 329:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 32c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 330:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 334:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 337:	83 c0 01             	add    $0x1,%eax
 33a:	84 d2                	test   %dl,%dl
 33c:	75 f2                	jne    330 <strcpy+0x10>
    ;
  return os;
}
 33e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 341:	89 c8                	mov    %ecx,%eax
 343:	c9                   	leave
 344:	c3                   	ret
 345:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 34c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000350 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	53                   	push   %ebx
 354:	8b 55 08             	mov    0x8(%ebp),%edx
 357:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 35a:	0f b6 02             	movzbl (%edx),%eax
 35d:	84 c0                	test   %al,%al
 35f:	75 17                	jne    378 <strcmp+0x28>
 361:	eb 3a                	jmp    39d <strcmp+0x4d>
 363:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 367:	90                   	nop
 368:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 36c:	83 c2 01             	add    $0x1,%edx
 36f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 372:	84 c0                	test   %al,%al
 374:	74 1a                	je     390 <strcmp+0x40>
 376:	89 d9                	mov    %ebx,%ecx
 378:	0f b6 19             	movzbl (%ecx),%ebx
 37b:	38 c3                	cmp    %al,%bl
 37d:	74 e9                	je     368 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 37f:	29 d8                	sub    %ebx,%eax
}
 381:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 384:	c9                   	leave
 385:	c3                   	ret
 386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 38d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 390:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 394:	31 c0                	xor    %eax,%eax
 396:	29 d8                	sub    %ebx,%eax
}
 398:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 39b:	c9                   	leave
 39c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 39d:	0f b6 19             	movzbl (%ecx),%ebx
 3a0:	31 c0                	xor    %eax,%eax
 3a2:	eb db                	jmp    37f <strcmp+0x2f>
 3a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3af:	90                   	nop

000003b0 <strlen>:

uint
strlen(const char *s)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 3b6:	80 3a 00             	cmpb   $0x0,(%edx)
 3b9:	74 15                	je     3d0 <strlen+0x20>
 3bb:	31 c0                	xor    %eax,%eax
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
 3c0:	83 c0 01             	add    $0x1,%eax
 3c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 3c7:	89 c1                	mov    %eax,%ecx
 3c9:	75 f5                	jne    3c0 <strlen+0x10>
    ;
  return n;
}
 3cb:	89 c8                	mov    %ecx,%eax
 3cd:	5d                   	pop    %ebp
 3ce:	c3                   	ret
 3cf:	90                   	nop
  for(n = 0; s[n]; n++)
 3d0:	31 c9                	xor    %ecx,%ecx
}
 3d2:	5d                   	pop    %ebp
 3d3:	89 c8                	mov    %ecx,%eax
 3d5:	c3                   	ret
 3d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3dd:	8d 76 00             	lea    0x0(%esi),%esi

000003e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ed:	89 d7                	mov    %edx,%edi
 3ef:	fc                   	cld
 3f0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3f2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 3f5:	89 d0                	mov    %edx,%eax
 3f7:	c9                   	leave
 3f8:	c3                   	ret
 3f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000400 <strchr>:

char*
strchr(const char *s, char c)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 40a:	0f b6 10             	movzbl (%eax),%edx
 40d:	84 d2                	test   %dl,%dl
 40f:	75 12                	jne    423 <strchr+0x23>
 411:	eb 1d                	jmp    430 <strchr+0x30>
 413:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 417:	90                   	nop
 418:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 41c:	83 c0 01             	add    $0x1,%eax
 41f:	84 d2                	test   %dl,%dl
 421:	74 0d                	je     430 <strchr+0x30>
    if(*s == c)
 423:	38 d1                	cmp    %dl,%cl
 425:	75 f1                	jne    418 <strchr+0x18>
      return (char*)s;
  return 0;
}
 427:	5d                   	pop    %ebp
 428:	c3                   	ret
 429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 430:	31 c0                	xor    %eax,%eax
}
 432:	5d                   	pop    %ebp
 433:	c3                   	ret
 434:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 43b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 43f:	90                   	nop

00000440 <gets>:

char*
gets(char *buf, int max)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 445:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 448:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 449:	31 db                	xor    %ebx,%ebx
{
 44b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 44e:	eb 27                	jmp    477 <gets+0x37>
    cc = read(0, &c, 1);
 450:	83 ec 04             	sub    $0x4,%esp
 453:	6a 01                	push   $0x1
 455:	56                   	push   %esi
 456:	6a 00                	push   $0x0
 458:	e8 1e 01 00 00       	call   57b <read>
    if(cc < 1)
 45d:	83 c4 10             	add    $0x10,%esp
 460:	85 c0                	test   %eax,%eax
 462:	7e 1d                	jle    481 <gets+0x41>
      break;
    buf[i++] = c;
 464:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 468:	8b 55 08             	mov    0x8(%ebp),%edx
 46b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 46f:	3c 0a                	cmp    $0xa,%al
 471:	74 10                	je     483 <gets+0x43>
 473:	3c 0d                	cmp    $0xd,%al
 475:	74 0c                	je     483 <gets+0x43>
  for(i=0; i+1 < max; ){
 477:	89 df                	mov    %ebx,%edi
 479:	83 c3 01             	add    $0x1,%ebx
 47c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 47f:	7c cf                	jl     450 <gets+0x10>
 481:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 483:	8b 45 08             	mov    0x8(%ebp),%eax
 486:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 48a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 48d:	5b                   	pop    %ebx
 48e:	5e                   	pop    %esi
 48f:	5f                   	pop    %edi
 490:	5d                   	pop    %ebp
 491:	c3                   	ret
 492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000004a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	56                   	push   %esi
 4a4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4a5:	83 ec 08             	sub    $0x8,%esp
 4a8:	6a 00                	push   $0x0
 4aa:	ff 75 08             	push   0x8(%ebp)
 4ad:	e8 f1 00 00 00       	call   5a3 <open>
  if(fd < 0)
 4b2:	83 c4 10             	add    $0x10,%esp
 4b5:	85 c0                	test   %eax,%eax
 4b7:	78 27                	js     4e0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 4b9:	83 ec 08             	sub    $0x8,%esp
 4bc:	ff 75 0c             	push   0xc(%ebp)
 4bf:	89 c3                	mov    %eax,%ebx
 4c1:	50                   	push   %eax
 4c2:	e8 f4 00 00 00       	call   5bb <fstat>
  close(fd);
 4c7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4ca:	89 c6                	mov    %eax,%esi
  close(fd);
 4cc:	e8 ba 00 00 00       	call   58b <close>
  return r;
 4d1:	83 c4 10             	add    $0x10,%esp
}
 4d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4d7:	89 f0                	mov    %esi,%eax
 4d9:	5b                   	pop    %ebx
 4da:	5e                   	pop    %esi
 4db:	5d                   	pop    %ebp
 4dc:	c3                   	ret
 4dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 4e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4e5:	eb ed                	jmp    4d4 <stat+0x34>
 4e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ee:	66 90                	xchg   %ax,%ax

000004f0 <atoi>:

int
atoi(const char *s)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	53                   	push   %ebx
 4f4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4f7:	0f be 02             	movsbl (%edx),%eax
 4fa:	8d 48 d0             	lea    -0x30(%eax),%ecx
 4fd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 500:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 505:	77 1e                	ja     525 <atoi+0x35>
 507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 50e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 510:	83 c2 01             	add    $0x1,%edx
 513:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 516:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 51a:	0f be 02             	movsbl (%edx),%eax
 51d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 520:	80 fb 09             	cmp    $0x9,%bl
 523:	76 eb                	jbe    510 <atoi+0x20>
  return n;
}
 525:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 528:	89 c8                	mov    %ecx,%eax
 52a:	c9                   	leave
 52b:	c3                   	ret
 52c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000530 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	57                   	push   %edi
 534:	8b 45 10             	mov    0x10(%ebp),%eax
 537:	8b 55 08             	mov    0x8(%ebp),%edx
 53a:	56                   	push   %esi
 53b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 53e:	85 c0                	test   %eax,%eax
 540:	7e 13                	jle    555 <memmove+0x25>
 542:	01 d0                	add    %edx,%eax
  dst = vdst;
 544:	89 d7                	mov    %edx,%edi
 546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 54d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 550:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 551:	39 f8                	cmp    %edi,%eax
 553:	75 fb                	jne    550 <memmove+0x20>
  return vdst;
}
 555:	5e                   	pop    %esi
 556:	89 d0                	mov    %edx,%eax
 558:	5f                   	pop    %edi
 559:	5d                   	pop    %ebp
 55a:	c3                   	ret

0000055b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 55b:	b8 01 00 00 00       	mov    $0x1,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret

00000563 <exit>:
SYSCALL(exit)
 563:	b8 02 00 00 00       	mov    $0x2,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret

0000056b <wait>:
SYSCALL(wait)
 56b:	b8 03 00 00 00       	mov    $0x3,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret

00000573 <pipe>:
SYSCALL(pipe)
 573:	b8 04 00 00 00       	mov    $0x4,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret

0000057b <read>:
SYSCALL(read)
 57b:	b8 05 00 00 00       	mov    $0x5,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret

00000583 <write>:
SYSCALL(write)
 583:	b8 10 00 00 00       	mov    $0x10,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret

0000058b <close>:
SYSCALL(close)
 58b:	b8 15 00 00 00       	mov    $0x15,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret

00000593 <kill>:
SYSCALL(kill)
 593:	b8 06 00 00 00       	mov    $0x6,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret

0000059b <exec>:
SYSCALL(exec)
 59b:	b8 07 00 00 00       	mov    $0x7,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret

000005a3 <open>:
SYSCALL(open)
 5a3:	b8 0f 00 00 00       	mov    $0xf,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret

000005ab <mknod>:
SYSCALL(mknod)
 5ab:	b8 11 00 00 00       	mov    $0x11,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret

000005b3 <unlink>:
SYSCALL(unlink)
 5b3:	b8 12 00 00 00       	mov    $0x12,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret

000005bb <fstat>:
SYSCALL(fstat)
 5bb:	b8 08 00 00 00       	mov    $0x8,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret

000005c3 <link>:
SYSCALL(link)
 5c3:	b8 13 00 00 00       	mov    $0x13,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret

000005cb <mkdir>:
SYSCALL(mkdir)
 5cb:	b8 14 00 00 00       	mov    $0x14,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret

000005d3 <chdir>:
SYSCALL(chdir)
 5d3:	b8 09 00 00 00       	mov    $0x9,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret

000005db <dup>:
SYSCALL(dup)
 5db:	b8 0a 00 00 00       	mov    $0xa,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret

000005e3 <getpid>:
SYSCALL(getpid)
 5e3:	b8 0b 00 00 00       	mov    $0xb,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret

000005eb <sbrk>:
SYSCALL(sbrk)
 5eb:	b8 0c 00 00 00       	mov    $0xc,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret

000005f3 <sleep>:
SYSCALL(sleep)
 5f3:	b8 0d 00 00 00       	mov    $0xd,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret

000005fb <uptime>:
SYSCALL(uptime)
 5fb:	b8 0e 00 00 00       	mov    $0xe,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret

00000603 <getrss>:
SYSCALL(getrss)
 603:	b8 16 00 00 00       	mov    $0x16,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret

0000060b <getNumFreePages>:
 60b:	b8 17 00 00 00       	mov    $0x17,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret
 613:	66 90                	xchg   %ax,%ax
 615:	66 90                	xchg   %ax,%ax
 617:	66 90                	xchg   %ax,%ax
 619:	66 90                	xchg   %ax,%ax
 61b:	66 90                	xchg   %ax,%ax
 61d:	66 90                	xchg   %ax,%ax
 61f:	90                   	nop

00000620 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	56                   	push   %esi
 625:	53                   	push   %ebx
 626:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 628:	89 d1                	mov    %edx,%ecx
{
 62a:	83 ec 3c             	sub    $0x3c,%esp
 62d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 630:	85 d2                	test   %edx,%edx
 632:	0f 89 80 00 00 00    	jns    6b8 <printint+0x98>
 638:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 63c:	74 7a                	je     6b8 <printint+0x98>
    x = -xx;
 63e:	f7 d9                	neg    %ecx
    neg = 1;
 640:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 645:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 648:	31 f6                	xor    %esi,%esi
 64a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 650:	89 c8                	mov    %ecx,%eax
 652:	31 d2                	xor    %edx,%edx
 654:	89 f7                	mov    %esi,%edi
 656:	f7 f3                	div    %ebx
 658:	8d 76 01             	lea    0x1(%esi),%esi
 65b:	0f b6 92 c4 0a 00 00 	movzbl 0xac4(%edx),%edx
 662:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 666:	89 ca                	mov    %ecx,%edx
 668:	89 c1                	mov    %eax,%ecx
 66a:	39 da                	cmp    %ebx,%edx
 66c:	73 e2                	jae    650 <printint+0x30>
  if(neg)
 66e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 671:	85 c0                	test   %eax,%eax
 673:	74 07                	je     67c <printint+0x5c>
    buf[i++] = '-';
 675:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 67a:	89 f7                	mov    %esi,%edi
 67c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 67f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 682:	01 df                	add    %ebx,%edi
 684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 688:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 68b:	83 ec 04             	sub    $0x4,%esp
 68e:	88 45 d7             	mov    %al,-0x29(%ebp)
 691:	8d 45 d7             	lea    -0x29(%ebp),%eax
 694:	6a 01                	push   $0x1
 696:	50                   	push   %eax
 697:	56                   	push   %esi
 698:	e8 e6 fe ff ff       	call   583 <write>
  while(--i >= 0)
 69d:	89 f8                	mov    %edi,%eax
 69f:	83 c4 10             	add    $0x10,%esp
 6a2:	83 ef 01             	sub    $0x1,%edi
 6a5:	39 c3                	cmp    %eax,%ebx
 6a7:	75 df                	jne    688 <printint+0x68>
}
 6a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6ac:	5b                   	pop    %ebx
 6ad:	5e                   	pop    %esi
 6ae:	5f                   	pop    %edi
 6af:	5d                   	pop    %ebp
 6b0:	c3                   	ret
 6b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 6b8:	31 c0                	xor    %eax,%eax
 6ba:	eb 89                	jmp    645 <printint+0x25>
 6bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	57                   	push   %edi
 6c4:	56                   	push   %esi
 6c5:	53                   	push   %ebx
 6c6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6c9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 6cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 6cf:	0f b6 1e             	movzbl (%esi),%ebx
 6d2:	83 c6 01             	add    $0x1,%esi
 6d5:	84 db                	test   %bl,%bl
 6d7:	74 67                	je     740 <printf+0x80>
 6d9:	8d 4d 10             	lea    0x10(%ebp),%ecx
 6dc:	31 d2                	xor    %edx,%edx
 6de:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 6e1:	eb 34                	jmp    717 <printf+0x57>
 6e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6e7:	90                   	nop
 6e8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 6eb:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 6f0:	83 f8 25             	cmp    $0x25,%eax
 6f3:	74 18                	je     70d <printf+0x4d>
  write(fd, &c, 1);
 6f5:	83 ec 04             	sub    $0x4,%esp
 6f8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6fb:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6fe:	6a 01                	push   $0x1
 700:	50                   	push   %eax
 701:	57                   	push   %edi
 702:	e8 7c fe ff ff       	call   583 <write>
 707:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 70a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 70d:	0f b6 1e             	movzbl (%esi),%ebx
 710:	83 c6 01             	add    $0x1,%esi
 713:	84 db                	test   %bl,%bl
 715:	74 29                	je     740 <printf+0x80>
    c = fmt[i] & 0xff;
 717:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 71a:	85 d2                	test   %edx,%edx
 71c:	74 ca                	je     6e8 <printf+0x28>
      }
    } else if(state == '%'){
 71e:	83 fa 25             	cmp    $0x25,%edx
 721:	75 ea                	jne    70d <printf+0x4d>
      if(c == 'd'){
 723:	83 f8 25             	cmp    $0x25,%eax
 726:	0f 84 04 01 00 00    	je     830 <printf+0x170>
 72c:	83 e8 63             	sub    $0x63,%eax
 72f:	83 f8 15             	cmp    $0x15,%eax
 732:	77 1c                	ja     750 <printf+0x90>
 734:	ff 24 85 6c 0a 00 00 	jmp    *0xa6c(,%eax,4)
 73b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 73f:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 740:	8d 65 f4             	lea    -0xc(%ebp),%esp
 743:	5b                   	pop    %ebx
 744:	5e                   	pop    %esi
 745:	5f                   	pop    %edi
 746:	5d                   	pop    %ebp
 747:	c3                   	ret
 748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 74f:	90                   	nop
  write(fd, &c, 1);
 750:	83 ec 04             	sub    $0x4,%esp
 753:	8d 55 e7             	lea    -0x19(%ebp),%edx
 756:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 75a:	6a 01                	push   $0x1
 75c:	52                   	push   %edx
 75d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 760:	57                   	push   %edi
 761:	e8 1d fe ff ff       	call   583 <write>
 766:	83 c4 0c             	add    $0xc,%esp
 769:	88 5d e7             	mov    %bl,-0x19(%ebp)
 76c:	6a 01                	push   $0x1
 76e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 771:	52                   	push   %edx
 772:	57                   	push   %edi
 773:	e8 0b fe ff ff       	call   583 <write>
        putc(fd, c);
 778:	83 c4 10             	add    $0x10,%esp
      state = 0;
 77b:	31 d2                	xor    %edx,%edx
 77d:	eb 8e                	jmp    70d <printf+0x4d>
 77f:	90                   	nop
        printint(fd, *ap, 16, 0);
 780:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 783:	83 ec 0c             	sub    $0xc,%esp
 786:	b9 10 00 00 00       	mov    $0x10,%ecx
 78b:	8b 13                	mov    (%ebx),%edx
 78d:	6a 00                	push   $0x0
 78f:	89 f8                	mov    %edi,%eax
        ap++;
 791:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 794:	e8 87 fe ff ff       	call   620 <printint>
        ap++;
 799:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 79c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 79f:	31 d2                	xor    %edx,%edx
 7a1:	e9 67 ff ff ff       	jmp    70d <printf+0x4d>
        s = (char*)*ap;
 7a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
 7a9:	8b 18                	mov    (%eax),%ebx
        ap++;
 7ab:	83 c0 04             	add    $0x4,%eax
 7ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 7b1:	85 db                	test   %ebx,%ebx
 7b3:	0f 84 87 00 00 00    	je     840 <printf+0x180>
        while(*s != 0){
 7b9:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 7bc:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 7be:	84 c0                	test   %al,%al
 7c0:	0f 84 47 ff ff ff    	je     70d <printf+0x4d>
 7c6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 7c9:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 7cc:	89 de                	mov    %ebx,%esi
 7ce:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 7d0:	83 ec 04             	sub    $0x4,%esp
 7d3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 7d6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 7d9:	6a 01                	push   $0x1
 7db:	53                   	push   %ebx
 7dc:	57                   	push   %edi
 7dd:	e8 a1 fd ff ff       	call   583 <write>
        while(*s != 0){
 7e2:	0f b6 06             	movzbl (%esi),%eax
 7e5:	83 c4 10             	add    $0x10,%esp
 7e8:	84 c0                	test   %al,%al
 7ea:	75 e4                	jne    7d0 <printf+0x110>
      state = 0;
 7ec:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 7ef:	31 d2                	xor    %edx,%edx
 7f1:	e9 17 ff ff ff       	jmp    70d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 7f6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7f9:	83 ec 0c             	sub    $0xc,%esp
 7fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 801:	8b 13                	mov    (%ebx),%edx
 803:	6a 01                	push   $0x1
 805:	eb 88                	jmp    78f <printf+0xcf>
        putc(fd, *ap);
 807:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 80a:	83 ec 04             	sub    $0x4,%esp
 80d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 810:	8b 03                	mov    (%ebx),%eax
        ap++;
 812:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 815:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 818:	6a 01                	push   $0x1
 81a:	52                   	push   %edx
 81b:	57                   	push   %edi
 81c:	e8 62 fd ff ff       	call   583 <write>
        ap++;
 821:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 824:	83 c4 10             	add    $0x10,%esp
      state = 0;
 827:	31 d2                	xor    %edx,%edx
 829:	e9 df fe ff ff       	jmp    70d <printf+0x4d>
 82e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 830:	83 ec 04             	sub    $0x4,%esp
 833:	88 5d e7             	mov    %bl,-0x19(%ebp)
 836:	8d 55 e7             	lea    -0x19(%ebp),%edx
 839:	6a 01                	push   $0x1
 83b:	e9 31 ff ff ff       	jmp    771 <printf+0xb1>
 840:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 845:	bb 63 0a 00 00       	mov    $0xa63,%ebx
 84a:	e9 77 ff ff ff       	jmp    7c6 <printf+0x106>
 84f:	90                   	nop

00000850 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 850:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 851:	a1 20 2b 00 00       	mov    0x2b20,%eax
{
 856:	89 e5                	mov    %esp,%ebp
 858:	57                   	push   %edi
 859:	56                   	push   %esi
 85a:	53                   	push   %ebx
 85b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 85e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 868:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86a:	39 c8                	cmp    %ecx,%eax
 86c:	73 32                	jae    8a0 <free+0x50>
 86e:	39 d1                	cmp    %edx,%ecx
 870:	72 04                	jb     876 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 872:	39 d0                	cmp    %edx,%eax
 874:	72 32                	jb     8a8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 876:	8b 73 fc             	mov    -0x4(%ebx),%esi
 879:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 87c:	39 fa                	cmp    %edi,%edx
 87e:	74 30                	je     8b0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 880:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 883:	8b 50 04             	mov    0x4(%eax),%edx
 886:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 889:	39 f1                	cmp    %esi,%ecx
 88b:	74 3a                	je     8c7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 88d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 88f:	5b                   	pop    %ebx
  freep = p;
 890:	a3 20 2b 00 00       	mov    %eax,0x2b20
}
 895:	5e                   	pop    %esi
 896:	5f                   	pop    %edi
 897:	5d                   	pop    %ebp
 898:	c3                   	ret
 899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a0:	39 d0                	cmp    %edx,%eax
 8a2:	72 04                	jb     8a8 <free+0x58>
 8a4:	39 d1                	cmp    %edx,%ecx
 8a6:	72 ce                	jb     876 <free+0x26>
{
 8a8:	89 d0                	mov    %edx,%eax
 8aa:	eb bc                	jmp    868 <free+0x18>
 8ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 8b0:	03 72 04             	add    0x4(%edx),%esi
 8b3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b6:	8b 10                	mov    (%eax),%edx
 8b8:	8b 12                	mov    (%edx),%edx
 8ba:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8bd:	8b 50 04             	mov    0x4(%eax),%edx
 8c0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8c3:	39 f1                	cmp    %esi,%ecx
 8c5:	75 c6                	jne    88d <free+0x3d>
    p->s.size += bp->s.size;
 8c7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 8ca:	a3 20 2b 00 00       	mov    %eax,0x2b20
    p->s.size += bp->s.size;
 8cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8d2:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 8d5:	89 08                	mov    %ecx,(%eax)
}
 8d7:	5b                   	pop    %ebx
 8d8:	5e                   	pop    %esi
 8d9:	5f                   	pop    %edi
 8da:	5d                   	pop    %ebp
 8db:	c3                   	ret
 8dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8e0:	55                   	push   %ebp
 8e1:	89 e5                	mov    %esp,%ebp
 8e3:	57                   	push   %edi
 8e4:	56                   	push   %esi
 8e5:	53                   	push   %ebx
 8e6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8ec:	8b 15 20 2b 00 00    	mov    0x2b20,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f2:	8d 78 07             	lea    0x7(%eax),%edi
 8f5:	c1 ef 03             	shr    $0x3,%edi
 8f8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 8fb:	85 d2                	test   %edx,%edx
 8fd:	0f 84 8d 00 00 00    	je     990 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 903:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 905:	8b 48 04             	mov    0x4(%eax),%ecx
 908:	39 f9                	cmp    %edi,%ecx
 90a:	73 64                	jae    970 <malloc+0x90>
  if(nu < 4096)
 90c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 911:	39 df                	cmp    %ebx,%edi
 913:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 916:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 91d:	eb 0a                	jmp    929 <malloc+0x49>
 91f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 920:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 922:	8b 48 04             	mov    0x4(%eax),%ecx
 925:	39 f9                	cmp    %edi,%ecx
 927:	73 47                	jae    970 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 929:	89 c2                	mov    %eax,%edx
 92b:	3b 05 20 2b 00 00    	cmp    0x2b20,%eax
 931:	75 ed                	jne    920 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 933:	83 ec 0c             	sub    $0xc,%esp
 936:	56                   	push   %esi
 937:	e8 af fc ff ff       	call   5eb <sbrk>
  if(p == (char*)-1)
 93c:	83 c4 10             	add    $0x10,%esp
 93f:	83 f8 ff             	cmp    $0xffffffff,%eax
 942:	74 1c                	je     960 <malloc+0x80>
  hp->s.size = nu;
 944:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 947:	83 ec 0c             	sub    $0xc,%esp
 94a:	83 c0 08             	add    $0x8,%eax
 94d:	50                   	push   %eax
 94e:	e8 fd fe ff ff       	call   850 <free>
  return freep;
 953:	8b 15 20 2b 00 00    	mov    0x2b20,%edx
      if((p = morecore(nunits)) == 0)
 959:	83 c4 10             	add    $0x10,%esp
 95c:	85 d2                	test   %edx,%edx
 95e:	75 c0                	jne    920 <malloc+0x40>
        return 0;
  }
}
 960:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 963:	31 c0                	xor    %eax,%eax
}
 965:	5b                   	pop    %ebx
 966:	5e                   	pop    %esi
 967:	5f                   	pop    %edi
 968:	5d                   	pop    %ebp
 969:	c3                   	ret
 96a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 970:	39 cf                	cmp    %ecx,%edi
 972:	74 4c                	je     9c0 <malloc+0xe0>
        p->s.size -= nunits;
 974:	29 f9                	sub    %edi,%ecx
 976:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 979:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 97c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 97f:	89 15 20 2b 00 00    	mov    %edx,0x2b20
}
 985:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 988:	83 c0 08             	add    $0x8,%eax
}
 98b:	5b                   	pop    %ebx
 98c:	5e                   	pop    %esi
 98d:	5f                   	pop    %edi
 98e:	5d                   	pop    %ebp
 98f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 990:	c7 05 20 2b 00 00 24 	movl   $0x2b24,0x2b20
 997:	2b 00 00 
    base.s.size = 0;
 99a:	b8 24 2b 00 00       	mov    $0x2b24,%eax
    base.s.ptr = freep = prevp = &base;
 99f:	c7 05 24 2b 00 00 24 	movl   $0x2b24,0x2b24
 9a6:	2b 00 00 
    base.s.size = 0;
 9a9:	c7 05 28 2b 00 00 00 	movl   $0x0,0x2b28
 9b0:	00 00 00 
    if(p->s.size >= nunits){
 9b3:	e9 54 ff ff ff       	jmp    90c <malloc+0x2c>
 9b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9bf:	90                   	nop
        prevp->s.ptr = p->s.ptr;
 9c0:	8b 08                	mov    (%eax),%ecx
 9c2:	89 0a                	mov    %ecx,(%edx)
 9c4:	eb b9                	jmp    97f <malloc+0x9f>
