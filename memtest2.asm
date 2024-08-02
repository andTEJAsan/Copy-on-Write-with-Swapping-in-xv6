
_memtest2:     file format elf32-i386


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
  28:	e8 63 07 00 00       	call   790 <malloc>
	for(int j=0;j<200;++j){
  2d:	83 c4 10             	add    $0x10,%esp
		memory[0] = (char) (65);
  30:	c6 00 41             	movb   $0x41,(%eax)
	for(int j=0;j<200;++j){
  33:	83 eb 01             	sub    $0x1,%ebx
  36:	75 e8                	jne    20 <mem+0x10>
	pid = fork();
  38:	e8 ce 03 00 00       	call   40b <fork>
	if(pid > 0) {
  3d:	85 c0                	test   %eax,%eax
  3f:	0f 8e 8c 00 00 00    	jle    d1 <mem+0xc1>
  45:	be 64 00 00 00       	mov    $0x64,%esi
				memory[k] = (char)(65+(k%26));
  4a:	bf 4f ec c4 4e       	mov    $0x4ec4ec4f,%edi
			char *memory = (char*) malloc(size); //4kb;
  4f:	83 ec 0c             	sub    $0xc,%esp
  52:	68 00 10 00 00       	push   $0x1000
  57:	e8 34 07 00 00       	call   790 <malloc>
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
  a1:	0f 84 c7 00 00 00    	je     16e <mem+0x15e>
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
	printf(1, "Memtest2 Failed!\n");
  bd:	83 ec 08             	sub    $0x8,%esp
  c0:	68 b9 08 00 00       	push   $0x8b9
  c5:	6a 01                	push   $0x1
  c7:	e8 a4 04 00 00       	call   570 <printf>
	exit();
  cc:	e8 42 03 00 00       	call   413 <exit>
	else if(pid < 0){ 
  d1:	74 16                	je     e9 <mem+0xd9>
		printf(1, "Fork Failed\n");
  d3:	53                   	push   %ebx
  d4:	53                   	push   %ebx
  d5:	68 8a 08 00 00       	push   $0x88a
  da:	6a 01                	push   $0x1
  dc:	e8 8f 04 00 00       	call   570 <printf>
  e1:	83 c4 10             	add    $0x10,%esp
	exit();
  e4:	e8 2a 03 00 00       	call   413 <exit>
		sleep(100);
  e9:	83 ec 0c             	sub    $0xc,%esp
  ec:	be 34 01 00 00       	mov    $0x134,%esi
				memory[k] = (char)(65+(k%26));
  f1:	bf 4f ec c4 4e       	mov    $0x4ec4ec4f,%edi
		sleep(100);
  f6:	6a 64                	push   $0x64
  f8:	e8 a6 03 00 00       	call   4a3 <sleep>
  fd:	83 c4 10             	add    $0x10,%esp
			char *memory = (char*) malloc(size); //4kb;
 100:	83 ec 0c             	sub    $0xc,%esp
 103:	68 00 10 00 00       	push   $0x1000
 108:	e8 83 06 00 00       	call   790 <malloc>
			if (memory == 0) goto failed;
 10d:	83 c4 10             	add    $0x10,%esp
			char *memory = (char*) malloc(size); //4kb;
 110:	89 c3                	mov    %eax,%ebx
			if (memory == 0) goto failed;
 112:	85 c0                	test   %eax,%eax
 114:	74 a7                	je     bd <mem+0xad>
			for(int k=0;k<size;++k){
 116:	31 c9                	xor    %ecx,%ecx
 118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11f:	90                   	nop
				memory[k] = (char)(65+(k%26));
 120:	89 c8                	mov    %ecx,%eax
 122:	f7 e7                	mul    %edi
 124:	89 c8                	mov    %ecx,%eax
 126:	c1 ea 03             	shr    $0x3,%edx
 129:	6b d2 1a             	imul   $0x1a,%edx,%edx
 12c:	29 d0                	sub    %edx,%eax
 12e:	83 c0 41             	add    $0x41,%eax
 131:	88 04 0b             	mov    %al,(%ebx,%ecx,1)
			for(int k=0;k<size;++k){
 134:	83 c1 01             	add    $0x1,%ecx
 137:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
 13d:	75 e1                	jne    120 <mem+0x110>
			for(int k=0;k<size;++k){
 13f:	31 c9                	xor    %ecx,%ecx
 141:	eb 10                	jmp    153 <mem+0x143>
 143:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 147:	90                   	nop
 148:	83 c1 01             	add    $0x1,%ecx
 14b:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
 151:	74 44                	je     197 <mem+0x187>
				if(memory[k] != (char)(65+(k%26))) goto failed;
 153:	89 c8                	mov    %ecx,%eax
 155:	f7 e7                	mul    %edi
 157:	89 c8                	mov    %ecx,%eax
 159:	c1 ea 03             	shr    $0x3,%edx
 15c:	6b d2 1a             	imul   $0x1a,%edx,%edx
 15f:	29 d0                	sub    %edx,%eax
 161:	83 c0 41             	add    $0x41,%eax
 164:	38 04 0b             	cmp    %al,(%ebx,%ecx,1)
 167:	74 df                	je     148 <mem+0x138>
 169:	e9 4f ff ff ff       	jmp    bd <mem+0xad>
		for(int j=0;j<100;++j){
 16e:	83 ee 01             	sub    $0x1,%esi
 171:	0f 85 d8 fe ff ff    	jne    4f <mem+0x3f>
		printf(1,"Parent alloc-ed:\n");
 177:	56                   	push   %esi
 178:	56                   	push   %esi
 179:	68 78 08 00 00       	push   $0x878
 17e:	6a 01                	push   $0x1
 180:	e8 eb 03 00 00       	call   570 <printf>
		getrss();
 185:	e8 29 03 00 00       	call   4b3 <getrss>
		wait();
 18a:	e8 8c 02 00 00       	call   41b <wait>
 18f:	83 c4 10             	add    $0x10,%esp
 192:	e9 4d ff ff ff       	jmp    e4 <mem+0xd4>
		for(int j=0;j<308;++j){
 197:	83 ee 01             	sub    $0x1,%esi
 19a:	0f 85 60 ff ff ff    	jne    100 <mem+0xf0>
		printf(1,"Child alloc-ed\n");
 1a0:	50                   	push   %eax
 1a1:	50                   	push   %eax
 1a2:	68 97 08 00 00       	push   $0x897
 1a7:	6a 01                	push   $0x1
 1a9:	e8 c2 03 00 00       	call   570 <printf>
		getrss();
 1ae:	e8 00 03 00 00       	call   4b3 <getrss>
		printf(1, "Memtest2 Passed!\n");
 1b3:	5a                   	pop    %edx
 1b4:	59                   	pop    %ecx
 1b5:	68 a7 08 00 00       	push   $0x8a7
 1ba:	6a 01                	push   $0x1
 1bc:	e8 af 03 00 00       	call   570 <printf>
 1c1:	83 c4 10             	add    $0x10,%esp
 1c4:	e9 1b ff ff ff       	jmp    e4 <mem+0xd4>
 1c9:	66 90                	xchg   %ax,%ax
 1cb:	66 90                	xchg   %ax,%ax
 1cd:	66 90                	xchg   %ax,%ax
 1cf:	90                   	nop

000001d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1d0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1d1:	31 c0                	xor    %eax,%eax
{
 1d3:	89 e5                	mov    %esp,%ebp
 1d5:	53                   	push   %ebx
 1d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 1e0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1e4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1e7:	83 c0 01             	add    $0x1,%eax
 1ea:	84 d2                	test   %dl,%dl
 1ec:	75 f2                	jne    1e0 <strcpy+0x10>
    ;
  return os;
}
 1ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1f1:	89 c8                	mov    %ecx,%eax
 1f3:	c9                   	leave
 1f4:	c3                   	ret
 1f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000200 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	53                   	push   %ebx
 204:	8b 55 08             	mov    0x8(%ebp),%edx
 207:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 20a:	0f b6 02             	movzbl (%edx),%eax
 20d:	84 c0                	test   %al,%al
 20f:	75 17                	jne    228 <strcmp+0x28>
 211:	eb 3a                	jmp    24d <strcmp+0x4d>
 213:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 217:	90                   	nop
 218:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 21c:	83 c2 01             	add    $0x1,%edx
 21f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 222:	84 c0                	test   %al,%al
 224:	74 1a                	je     240 <strcmp+0x40>
 226:	89 d9                	mov    %ebx,%ecx
 228:	0f b6 19             	movzbl (%ecx),%ebx
 22b:	38 c3                	cmp    %al,%bl
 22d:	74 e9                	je     218 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 22f:	29 d8                	sub    %ebx,%eax
}
 231:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 234:	c9                   	leave
 235:	c3                   	ret
 236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 240:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 244:	31 c0                	xor    %eax,%eax
 246:	29 d8                	sub    %ebx,%eax
}
 248:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 24b:	c9                   	leave
 24c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 24d:	0f b6 19             	movzbl (%ecx),%ebx
 250:	31 c0                	xor    %eax,%eax
 252:	eb db                	jmp    22f <strcmp+0x2f>
 254:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 25f:	90                   	nop

00000260 <strlen>:

uint
strlen(const char *s)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 266:	80 3a 00             	cmpb   $0x0,(%edx)
 269:	74 15                	je     280 <strlen+0x20>
 26b:	31 c0                	xor    %eax,%eax
 26d:	8d 76 00             	lea    0x0(%esi),%esi
 270:	83 c0 01             	add    $0x1,%eax
 273:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 277:	89 c1                	mov    %eax,%ecx
 279:	75 f5                	jne    270 <strlen+0x10>
    ;
  return n;
}
 27b:	89 c8                	mov    %ecx,%eax
 27d:	5d                   	pop    %ebp
 27e:	c3                   	ret
 27f:	90                   	nop
  for(n = 0; s[n]; n++)
 280:	31 c9                	xor    %ecx,%ecx
}
 282:	5d                   	pop    %ebp
 283:	89 c8                	mov    %ecx,%eax
 285:	c3                   	ret
 286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28d:	8d 76 00             	lea    0x0(%esi),%esi

00000290 <memset>:

void*
memset(void *dst, int c, uint n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	57                   	push   %edi
 294:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 297:	8b 4d 10             	mov    0x10(%ebp),%ecx
 29a:	8b 45 0c             	mov    0xc(%ebp),%eax
 29d:	89 d7                	mov    %edx,%edi
 29f:	fc                   	cld
 2a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2a2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 2a5:	89 d0                	mov    %edx,%eax
 2a7:	c9                   	leave
 2a8:	c3                   	ret
 2a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002b0 <strchr>:

char*
strchr(const char *s, char c)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 2ba:	0f b6 10             	movzbl (%eax),%edx
 2bd:	84 d2                	test   %dl,%dl
 2bf:	75 12                	jne    2d3 <strchr+0x23>
 2c1:	eb 1d                	jmp    2e0 <strchr+0x30>
 2c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2c7:	90                   	nop
 2c8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 2cc:	83 c0 01             	add    $0x1,%eax
 2cf:	84 d2                	test   %dl,%dl
 2d1:	74 0d                	je     2e0 <strchr+0x30>
    if(*s == c)
 2d3:	38 d1                	cmp    %dl,%cl
 2d5:	75 f1                	jne    2c8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 2d7:	5d                   	pop    %ebp
 2d8:	c3                   	ret
 2d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2e0:	31 c0                	xor    %eax,%eax
}
 2e2:	5d                   	pop    %ebp
 2e3:	c3                   	ret
 2e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2ef:	90                   	nop

000002f0 <gets>:

char*
gets(char *buf, int max)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	57                   	push   %edi
 2f4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 2f5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 2f8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 2f9:	31 db                	xor    %ebx,%ebx
{
 2fb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 2fe:	eb 27                	jmp    327 <gets+0x37>
    cc = read(0, &c, 1);
 300:	83 ec 04             	sub    $0x4,%esp
 303:	6a 01                	push   $0x1
 305:	56                   	push   %esi
 306:	6a 00                	push   $0x0
 308:	e8 1e 01 00 00       	call   42b <read>
    if(cc < 1)
 30d:	83 c4 10             	add    $0x10,%esp
 310:	85 c0                	test   %eax,%eax
 312:	7e 1d                	jle    331 <gets+0x41>
      break;
    buf[i++] = c;
 314:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 318:	8b 55 08             	mov    0x8(%ebp),%edx
 31b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 31f:	3c 0a                	cmp    $0xa,%al
 321:	74 10                	je     333 <gets+0x43>
 323:	3c 0d                	cmp    $0xd,%al
 325:	74 0c                	je     333 <gets+0x43>
  for(i=0; i+1 < max; ){
 327:	89 df                	mov    %ebx,%edi
 329:	83 c3 01             	add    $0x1,%ebx
 32c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 32f:	7c cf                	jl     300 <gets+0x10>
 331:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 333:	8b 45 08             	mov    0x8(%ebp),%eax
 336:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 33a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 33d:	5b                   	pop    %ebx
 33e:	5e                   	pop    %esi
 33f:	5f                   	pop    %edi
 340:	5d                   	pop    %ebp
 341:	c3                   	ret
 342:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000350 <stat>:

int
stat(const char *n, struct stat *st)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	56                   	push   %esi
 354:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 355:	83 ec 08             	sub    $0x8,%esp
 358:	6a 00                	push   $0x0
 35a:	ff 75 08             	push   0x8(%ebp)
 35d:	e8 f1 00 00 00       	call   453 <open>
  if(fd < 0)
 362:	83 c4 10             	add    $0x10,%esp
 365:	85 c0                	test   %eax,%eax
 367:	78 27                	js     390 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 369:	83 ec 08             	sub    $0x8,%esp
 36c:	ff 75 0c             	push   0xc(%ebp)
 36f:	89 c3                	mov    %eax,%ebx
 371:	50                   	push   %eax
 372:	e8 f4 00 00 00       	call   46b <fstat>
  close(fd);
 377:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 37a:	89 c6                	mov    %eax,%esi
  close(fd);
 37c:	e8 ba 00 00 00       	call   43b <close>
  return r;
 381:	83 c4 10             	add    $0x10,%esp
}
 384:	8d 65 f8             	lea    -0x8(%ebp),%esp
 387:	89 f0                	mov    %esi,%eax
 389:	5b                   	pop    %ebx
 38a:	5e                   	pop    %esi
 38b:	5d                   	pop    %ebp
 38c:	c3                   	ret
 38d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 390:	be ff ff ff ff       	mov    $0xffffffff,%esi
 395:	eb ed                	jmp    384 <stat+0x34>
 397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 39e:	66 90                	xchg   %ax,%ax

000003a0 <atoi>:

int
atoi(const char *s)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	53                   	push   %ebx
 3a4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3a7:	0f be 02             	movsbl (%edx),%eax
 3aa:	8d 48 d0             	lea    -0x30(%eax),%ecx
 3ad:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 3b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 3b5:	77 1e                	ja     3d5 <atoi+0x35>
 3b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3be:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 3c0:	83 c2 01             	add    $0x1,%edx
 3c3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 3c6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 3ca:	0f be 02             	movsbl (%edx),%eax
 3cd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3d0:	80 fb 09             	cmp    $0x9,%bl
 3d3:	76 eb                	jbe    3c0 <atoi+0x20>
  return n;
}
 3d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3d8:	89 c8                	mov    %ecx,%eax
 3da:	c9                   	leave
 3db:	c3                   	ret
 3dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	8b 45 10             	mov    0x10(%ebp),%eax
 3e7:	8b 55 08             	mov    0x8(%ebp),%edx
 3ea:	56                   	push   %esi
 3eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3ee:	85 c0                	test   %eax,%eax
 3f0:	7e 13                	jle    405 <memmove+0x25>
 3f2:	01 d0                	add    %edx,%eax
  dst = vdst;
 3f4:	89 d7                	mov    %edx,%edi
 3f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3fd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 400:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 401:	39 f8                	cmp    %edi,%eax
 403:	75 fb                	jne    400 <memmove+0x20>
  return vdst;
}
 405:	5e                   	pop    %esi
 406:	89 d0                	mov    %edx,%eax
 408:	5f                   	pop    %edi
 409:	5d                   	pop    %ebp
 40a:	c3                   	ret

0000040b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 40b:	b8 01 00 00 00       	mov    $0x1,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret

00000413 <exit>:
SYSCALL(exit)
 413:	b8 02 00 00 00       	mov    $0x2,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret

0000041b <wait>:
SYSCALL(wait)
 41b:	b8 03 00 00 00       	mov    $0x3,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret

00000423 <pipe>:
SYSCALL(pipe)
 423:	b8 04 00 00 00       	mov    $0x4,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret

0000042b <read>:
SYSCALL(read)
 42b:	b8 05 00 00 00       	mov    $0x5,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret

00000433 <write>:
SYSCALL(write)
 433:	b8 10 00 00 00       	mov    $0x10,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret

0000043b <close>:
SYSCALL(close)
 43b:	b8 15 00 00 00       	mov    $0x15,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret

00000443 <kill>:
SYSCALL(kill)
 443:	b8 06 00 00 00       	mov    $0x6,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret

0000044b <exec>:
SYSCALL(exec)
 44b:	b8 07 00 00 00       	mov    $0x7,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret

00000453 <open>:
SYSCALL(open)
 453:	b8 0f 00 00 00       	mov    $0xf,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret

0000045b <mknod>:
SYSCALL(mknod)
 45b:	b8 11 00 00 00       	mov    $0x11,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret

00000463 <unlink>:
SYSCALL(unlink)
 463:	b8 12 00 00 00       	mov    $0x12,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret

0000046b <fstat>:
SYSCALL(fstat)
 46b:	b8 08 00 00 00       	mov    $0x8,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret

00000473 <link>:
SYSCALL(link)
 473:	b8 13 00 00 00       	mov    $0x13,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret

0000047b <mkdir>:
SYSCALL(mkdir)
 47b:	b8 14 00 00 00       	mov    $0x14,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret

00000483 <chdir>:
SYSCALL(chdir)
 483:	b8 09 00 00 00       	mov    $0x9,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret

0000048b <dup>:
SYSCALL(dup)
 48b:	b8 0a 00 00 00       	mov    $0xa,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret

00000493 <getpid>:
SYSCALL(getpid)
 493:	b8 0b 00 00 00       	mov    $0xb,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret

0000049b <sbrk>:
SYSCALL(sbrk)
 49b:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret

000004a3 <sleep>:
SYSCALL(sleep)
 4a3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret

000004ab <uptime>:
SYSCALL(uptime)
 4ab:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret

000004b3 <getrss>:
SYSCALL(getrss)
 4b3:	b8 16 00 00 00       	mov    $0x16,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret

000004bb <getNumFreePages>:
 4bb:	b8 17 00 00 00       	mov    $0x17,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret
 4c3:	66 90                	xchg   %ax,%ax
 4c5:	66 90                	xchg   %ax,%ax
 4c7:	66 90                	xchg   %ax,%ax
 4c9:	66 90                	xchg   %ax,%ax
 4cb:	66 90                	xchg   %ax,%ax
 4cd:	66 90                	xchg   %ax,%ax
 4cf:	90                   	nop

000004d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	57                   	push   %edi
 4d4:	56                   	push   %esi
 4d5:	53                   	push   %ebx
 4d6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4d8:	89 d1                	mov    %edx,%ecx
{
 4da:	83 ec 3c             	sub    $0x3c,%esp
 4dd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 4e0:	85 d2                	test   %edx,%edx
 4e2:	0f 89 80 00 00 00    	jns    568 <printint+0x98>
 4e8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4ec:	74 7a                	je     568 <printint+0x98>
    x = -xx;
 4ee:	f7 d9                	neg    %ecx
    neg = 1;
 4f0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 4f5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 4f8:	31 f6                	xor    %esi,%esi
 4fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 500:	89 c8                	mov    %ecx,%eax
 502:	31 d2                	xor    %edx,%edx
 504:	89 f7                	mov    %esi,%edi
 506:	f7 f3                	div    %ebx
 508:	8d 76 01             	lea    0x1(%esi),%esi
 50b:	0f b6 92 40 09 00 00 	movzbl 0x940(%edx),%edx
 512:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 516:	89 ca                	mov    %ecx,%edx
 518:	89 c1                	mov    %eax,%ecx
 51a:	39 da                	cmp    %ebx,%edx
 51c:	73 e2                	jae    500 <printint+0x30>
  if(neg)
 51e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 521:	85 c0                	test   %eax,%eax
 523:	74 07                	je     52c <printint+0x5c>
    buf[i++] = '-';
 525:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 52a:	89 f7                	mov    %esi,%edi
 52c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 52f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 532:	01 df                	add    %ebx,%edi
 534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 538:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 53b:	83 ec 04             	sub    $0x4,%esp
 53e:	88 45 d7             	mov    %al,-0x29(%ebp)
 541:	8d 45 d7             	lea    -0x29(%ebp),%eax
 544:	6a 01                	push   $0x1
 546:	50                   	push   %eax
 547:	56                   	push   %esi
 548:	e8 e6 fe ff ff       	call   433 <write>
  while(--i >= 0)
 54d:	89 f8                	mov    %edi,%eax
 54f:	83 c4 10             	add    $0x10,%esp
 552:	83 ef 01             	sub    $0x1,%edi
 555:	39 c3                	cmp    %eax,%ebx
 557:	75 df                	jne    538 <printint+0x68>
}
 559:	8d 65 f4             	lea    -0xc(%ebp),%esp
 55c:	5b                   	pop    %ebx
 55d:	5e                   	pop    %esi
 55e:	5f                   	pop    %edi
 55f:	5d                   	pop    %ebp
 560:	c3                   	ret
 561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 568:	31 c0                	xor    %eax,%eax
 56a:	eb 89                	jmp    4f5 <printint+0x25>
 56c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000570 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	57                   	push   %edi
 574:	56                   	push   %esi
 575:	53                   	push   %ebx
 576:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 579:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 57c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 57f:	0f b6 1e             	movzbl (%esi),%ebx
 582:	83 c6 01             	add    $0x1,%esi
 585:	84 db                	test   %bl,%bl
 587:	74 67                	je     5f0 <printf+0x80>
 589:	8d 4d 10             	lea    0x10(%ebp),%ecx
 58c:	31 d2                	xor    %edx,%edx
 58e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 591:	eb 34                	jmp    5c7 <printf+0x57>
 593:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 597:	90                   	nop
 598:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 59b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 5a0:	83 f8 25             	cmp    $0x25,%eax
 5a3:	74 18                	je     5bd <printf+0x4d>
  write(fd, &c, 1);
 5a5:	83 ec 04             	sub    $0x4,%esp
 5a8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5ab:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5ae:	6a 01                	push   $0x1
 5b0:	50                   	push   %eax
 5b1:	57                   	push   %edi
 5b2:	e8 7c fe ff ff       	call   433 <write>
 5b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 5ba:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5bd:	0f b6 1e             	movzbl (%esi),%ebx
 5c0:	83 c6 01             	add    $0x1,%esi
 5c3:	84 db                	test   %bl,%bl
 5c5:	74 29                	je     5f0 <printf+0x80>
    c = fmt[i] & 0xff;
 5c7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5ca:	85 d2                	test   %edx,%edx
 5cc:	74 ca                	je     598 <printf+0x28>
      }
    } else if(state == '%'){
 5ce:	83 fa 25             	cmp    $0x25,%edx
 5d1:	75 ea                	jne    5bd <printf+0x4d>
      if(c == 'd'){
 5d3:	83 f8 25             	cmp    $0x25,%eax
 5d6:	0f 84 04 01 00 00    	je     6e0 <printf+0x170>
 5dc:	83 e8 63             	sub    $0x63,%eax
 5df:	83 f8 15             	cmp    $0x15,%eax
 5e2:	77 1c                	ja     600 <printf+0x90>
 5e4:	ff 24 85 e8 08 00 00 	jmp    *0x8e8(,%eax,4)
 5eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5ef:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5f3:	5b                   	pop    %ebx
 5f4:	5e                   	pop    %esi
 5f5:	5f                   	pop    %edi
 5f6:	5d                   	pop    %ebp
 5f7:	c3                   	ret
 5f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ff:	90                   	nop
  write(fd, &c, 1);
 600:	83 ec 04             	sub    $0x4,%esp
 603:	8d 55 e7             	lea    -0x19(%ebp),%edx
 606:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 60a:	6a 01                	push   $0x1
 60c:	52                   	push   %edx
 60d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 610:	57                   	push   %edi
 611:	e8 1d fe ff ff       	call   433 <write>
 616:	83 c4 0c             	add    $0xc,%esp
 619:	88 5d e7             	mov    %bl,-0x19(%ebp)
 61c:	6a 01                	push   $0x1
 61e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 621:	52                   	push   %edx
 622:	57                   	push   %edi
 623:	e8 0b fe ff ff       	call   433 <write>
        putc(fd, c);
 628:	83 c4 10             	add    $0x10,%esp
      state = 0;
 62b:	31 d2                	xor    %edx,%edx
 62d:	eb 8e                	jmp    5bd <printf+0x4d>
 62f:	90                   	nop
        printint(fd, *ap, 16, 0);
 630:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 633:	83 ec 0c             	sub    $0xc,%esp
 636:	b9 10 00 00 00       	mov    $0x10,%ecx
 63b:	8b 13                	mov    (%ebx),%edx
 63d:	6a 00                	push   $0x0
 63f:	89 f8                	mov    %edi,%eax
        ap++;
 641:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 644:	e8 87 fe ff ff       	call   4d0 <printint>
        ap++;
 649:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 64c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 64f:	31 d2                	xor    %edx,%edx
 651:	e9 67 ff ff ff       	jmp    5bd <printf+0x4d>
        s = (char*)*ap;
 656:	8b 45 d0             	mov    -0x30(%ebp),%eax
 659:	8b 18                	mov    (%eax),%ebx
        ap++;
 65b:	83 c0 04             	add    $0x4,%eax
 65e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 661:	85 db                	test   %ebx,%ebx
 663:	0f 84 87 00 00 00    	je     6f0 <printf+0x180>
        while(*s != 0){
 669:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 66c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 66e:	84 c0                	test   %al,%al
 670:	0f 84 47 ff ff ff    	je     5bd <printf+0x4d>
 676:	8d 55 e7             	lea    -0x19(%ebp),%edx
 679:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 67c:	89 de                	mov    %ebx,%esi
 67e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 680:	83 ec 04             	sub    $0x4,%esp
 683:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 686:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 689:	6a 01                	push   $0x1
 68b:	53                   	push   %ebx
 68c:	57                   	push   %edi
 68d:	e8 a1 fd ff ff       	call   433 <write>
        while(*s != 0){
 692:	0f b6 06             	movzbl (%esi),%eax
 695:	83 c4 10             	add    $0x10,%esp
 698:	84 c0                	test   %al,%al
 69a:	75 e4                	jne    680 <printf+0x110>
      state = 0;
 69c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 69f:	31 d2                	xor    %edx,%edx
 6a1:	e9 17 ff ff ff       	jmp    5bd <printf+0x4d>
        printint(fd, *ap, 10, 1);
 6a6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6a9:	83 ec 0c             	sub    $0xc,%esp
 6ac:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6b1:	8b 13                	mov    (%ebx),%edx
 6b3:	6a 01                	push   $0x1
 6b5:	eb 88                	jmp    63f <printf+0xcf>
        putc(fd, *ap);
 6b7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 6ba:	83 ec 04             	sub    $0x4,%esp
 6bd:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 6c0:	8b 03                	mov    (%ebx),%eax
        ap++;
 6c2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 6c5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6c8:	6a 01                	push   $0x1
 6ca:	52                   	push   %edx
 6cb:	57                   	push   %edi
 6cc:	e8 62 fd ff ff       	call   433 <write>
        ap++;
 6d1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6d4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6d7:	31 d2                	xor    %edx,%edx
 6d9:	e9 df fe ff ff       	jmp    5bd <printf+0x4d>
 6de:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 6e0:	83 ec 04             	sub    $0x4,%esp
 6e3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6e6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 6e9:	6a 01                	push   $0x1
 6eb:	e9 31 ff ff ff       	jmp    621 <printf+0xb1>
 6f0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 6f5:	bb e1 08 00 00       	mov    $0x8e1,%ebx
 6fa:	e9 77 ff ff ff       	jmp    676 <printf+0x106>
 6ff:	90                   	nop

00000700 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 700:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 701:	a1 a0 29 00 00       	mov    0x29a0,%eax
{
 706:	89 e5                	mov    %esp,%ebp
 708:	57                   	push   %edi
 709:	56                   	push   %esi
 70a:	53                   	push   %ebx
 70b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 70e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 718:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71a:	39 c8                	cmp    %ecx,%eax
 71c:	73 32                	jae    750 <free+0x50>
 71e:	39 d1                	cmp    %edx,%ecx
 720:	72 04                	jb     726 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 722:	39 d0                	cmp    %edx,%eax
 724:	72 32                	jb     758 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 726:	8b 73 fc             	mov    -0x4(%ebx),%esi
 729:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 72c:	39 fa                	cmp    %edi,%edx
 72e:	74 30                	je     760 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 730:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 733:	8b 50 04             	mov    0x4(%eax),%edx
 736:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 739:	39 f1                	cmp    %esi,%ecx
 73b:	74 3a                	je     777 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 73d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 73f:	5b                   	pop    %ebx
  freep = p;
 740:	a3 a0 29 00 00       	mov    %eax,0x29a0
}
 745:	5e                   	pop    %esi
 746:	5f                   	pop    %edi
 747:	5d                   	pop    %ebp
 748:	c3                   	ret
 749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 750:	39 d0                	cmp    %edx,%eax
 752:	72 04                	jb     758 <free+0x58>
 754:	39 d1                	cmp    %edx,%ecx
 756:	72 ce                	jb     726 <free+0x26>
{
 758:	89 d0                	mov    %edx,%eax
 75a:	eb bc                	jmp    718 <free+0x18>
 75c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 760:	03 72 04             	add    0x4(%edx),%esi
 763:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 766:	8b 10                	mov    (%eax),%edx
 768:	8b 12                	mov    (%edx),%edx
 76a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 76d:	8b 50 04             	mov    0x4(%eax),%edx
 770:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 773:	39 f1                	cmp    %esi,%ecx
 775:	75 c6                	jne    73d <free+0x3d>
    p->s.size += bp->s.size;
 777:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 77a:	a3 a0 29 00 00       	mov    %eax,0x29a0
    p->s.size += bp->s.size;
 77f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 782:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 785:	89 08                	mov    %ecx,(%eax)
}
 787:	5b                   	pop    %ebx
 788:	5e                   	pop    %esi
 789:	5f                   	pop    %edi
 78a:	5d                   	pop    %ebp
 78b:	c3                   	ret
 78c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000790 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	57                   	push   %edi
 794:	56                   	push   %esi
 795:	53                   	push   %ebx
 796:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 799:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 79c:	8b 15 a0 29 00 00    	mov    0x29a0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a2:	8d 78 07             	lea    0x7(%eax),%edi
 7a5:	c1 ef 03             	shr    $0x3,%edi
 7a8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7ab:	85 d2                	test   %edx,%edx
 7ad:	0f 84 8d 00 00 00    	je     840 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7b5:	8b 48 04             	mov    0x4(%eax),%ecx
 7b8:	39 f9                	cmp    %edi,%ecx
 7ba:	73 64                	jae    820 <malloc+0x90>
  if(nu < 4096)
 7bc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7c1:	39 df                	cmp    %ebx,%edi
 7c3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 7c6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 7cd:	eb 0a                	jmp    7d9 <malloc+0x49>
 7cf:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7d2:	8b 48 04             	mov    0x4(%eax),%ecx
 7d5:	39 f9                	cmp    %edi,%ecx
 7d7:	73 47                	jae    820 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7d9:	89 c2                	mov    %eax,%edx
 7db:	3b 05 a0 29 00 00    	cmp    0x29a0,%eax
 7e1:	75 ed                	jne    7d0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 7e3:	83 ec 0c             	sub    $0xc,%esp
 7e6:	56                   	push   %esi
 7e7:	e8 af fc ff ff       	call   49b <sbrk>
  if(p == (char*)-1)
 7ec:	83 c4 10             	add    $0x10,%esp
 7ef:	83 f8 ff             	cmp    $0xffffffff,%eax
 7f2:	74 1c                	je     810 <malloc+0x80>
  hp->s.size = nu;
 7f4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7f7:	83 ec 0c             	sub    $0xc,%esp
 7fa:	83 c0 08             	add    $0x8,%eax
 7fd:	50                   	push   %eax
 7fe:	e8 fd fe ff ff       	call   700 <free>
  return freep;
 803:	8b 15 a0 29 00 00    	mov    0x29a0,%edx
      if((p = morecore(nunits)) == 0)
 809:	83 c4 10             	add    $0x10,%esp
 80c:	85 d2                	test   %edx,%edx
 80e:	75 c0                	jne    7d0 <malloc+0x40>
        return 0;
  }
}
 810:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 813:	31 c0                	xor    %eax,%eax
}
 815:	5b                   	pop    %ebx
 816:	5e                   	pop    %esi
 817:	5f                   	pop    %edi
 818:	5d                   	pop    %ebp
 819:	c3                   	ret
 81a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 820:	39 cf                	cmp    %ecx,%edi
 822:	74 4c                	je     870 <malloc+0xe0>
        p->s.size -= nunits;
 824:	29 f9                	sub    %edi,%ecx
 826:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 829:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 82c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 82f:	89 15 a0 29 00 00    	mov    %edx,0x29a0
}
 835:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 838:	83 c0 08             	add    $0x8,%eax
}
 83b:	5b                   	pop    %ebx
 83c:	5e                   	pop    %esi
 83d:	5f                   	pop    %edi
 83e:	5d                   	pop    %ebp
 83f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 840:	c7 05 a0 29 00 00 a4 	movl   $0x29a4,0x29a0
 847:	29 00 00 
    base.s.size = 0;
 84a:	b8 a4 29 00 00       	mov    $0x29a4,%eax
    base.s.ptr = freep = prevp = &base;
 84f:	c7 05 a4 29 00 00 a4 	movl   $0x29a4,0x29a4
 856:	29 00 00 
    base.s.size = 0;
 859:	c7 05 a8 29 00 00 00 	movl   $0x0,0x29a8
 860:	00 00 00 
    if(p->s.size >= nunits){
 863:	e9 54 ff ff ff       	jmp    7bc <malloc+0x2c>
 868:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 86f:	90                   	nop
        prevp->s.ptr = p->s.ptr;
 870:	8b 08                	mov    (%eax),%ecx
 872:	89 0a                	mov    %ecx,(%edx)
 874:	eb b9                	jmp    82f <malloc+0x9f>
