#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <sys/mman.h>

#define MAX_EMITTED 40 
#define MAX_INSTR 0x100
#define EMIT(a) dest[bytes] = a; bytes++;
#define EMIT_32LE(a) *((uint32_t*)(&dest[bytes])) = a; bytes+=4;

uint64_t memory[0x1000];
void* addr[0x1000];

int jit_compile_instr(uint8_t* dest, char* src, int step)
{
	// r9 = &addr
	// r10 = &memory
	int bytes = 0;
	if (!strncmp(src, "ptr ", 4))
	{
		int n = ((atoi(src+4)) & 0x1fffffff);
		// mov rax, n
		EMIT(0x48); EMIT(0xc7); EMIT(0xc0); EMIT_32LE(n);
		return bytes;
	}
	else if (!strncmp(src, "add ", 4))
        {
		int n = ((atoi(src+4)) & 0x1fffffff);
		// mov rbx, n
		EMIT(0x48); EMIT(0xc7); EMIT(0xc3); EMIT_32LE(n);
		// add qword ptr [r10+rax], rbx
		EMIT(0x49); EMIT(0x01); EMIT(0x1c); EMIT(0x02);
		return bytes;
        }
        else if (!strncmp(src, "sub ", 4))
        {
		int n = ((atoi(src+4)) & 0x1fffffff);
                // mov rbx, n
		EMIT(0x48); EMIT(0xc7); EMIT(0xc3); EMIT_32LE(n);
                // sub qword ptr [r10+rax], rbx
		EMIT(0x49); EMIT(0x29); EMIT(0x1c); EMIT(0x02);
                return bytes;
        }
	else if (!strncmp(src, "clear", 5))
	{
		// mov qword ptr [r10+rax], 0
		EMIT(0x49); EMIT(0xc7); EMIT(0x04); EMIT(0x02); EMIT_32LE(0);
		return bytes;
	}
        else if (!strncmp(src, "print", 5))
        {
		// mov r15, rax 
		EMIT(0x49); EMIT(0x89); EMIT(0xc7);
		// mov rax, 1
		EMIT(0x48); EMIT(0xc7); EMIT(0xc0);
		EMIT_32LE(1);
		// mov rdi, 1
                EMIT(0x48); EMIT(0xc7); EMIT(0xc7);
                EMIT_32LE(1);
		// mov rsi, r10
		EMIT(0x4c); EMIT(0x89); EMIT(0xd6);
		// add rsi, r15
		EMIT(0x4c); EMIT(0x01); EMIT(0xfe);
		// mov rdx, 64 
                EMIT(0x48); EMIT(0xc7); EMIT(0xc2); EMIT_32LE(0x40);
		// syscall
		EMIT(0x0f); EMIT(0x05);
		// mov rax, r15
		EMIT(0x4c); EMIT(0x89); EMIT(0xf8);
		return bytes;
        }
        else if (!strncmp(src, "jump ", 5))
        {
		int n = ((atoi(src+5)) & 0x1fffffff);
		// mov r11, n
		EMIT(0x49); EMIT(0xc7); EMIT(0xc3); EMIT_32LE(n);
		// shl r11, 3
		EMIT(0x49); EMIT(0xc1); EMIT(0xe3);
		EMIT(0x03);
		// add r11, r9
		EMIT(0x4d); EMIT(0x01); EMIT(0xcb);
		// call qword ptr [r11]
		EMIT(0x41); EMIT(0xff); EMIT(0x13);
		return bytes;
        }
        else if (!strncmp(src, "skip", 4))
        {
		// mov r11, step
		EMIT(0x49); EMIT(0xc7); EMIT(0xc3); EMIT_32LE(step);
		// shl r11, 3
                EMIT(0x49); EMIT(0xc1); EMIT(0xe3); EMIT(0x03);
		// add r11, r9
                EMIT(0x4d); EMIT(0x01); EMIT(0xcb);
		// add r11, 16 
		EMIT(0x49); EMIT(0x83); EMIT(0xc3); EMIT(0x10);
		// cmp qword ptr [rax], 0
		EMIT(0x48); EMIT(0x83); EMIT(0x38); EMIT(0);
		// jne next
		EMIT(0x75); EMIT(0x03);
		// call qword ptr [r11]
		EMIT(0x41); EMIT(0xff); EMIT(0x13);
		// next:
		return bytes;
        }
        else if (!strncmp(src, "halt", 4)) 
        {
		// mov rax, 60
		EMIT(0x48); EMIT(0xc7); EMIT(0xc0); EMIT(0x3c); EMIT(0); EMIT(0); EMIT(0);
		// syscall
		EMIT(0x0f); EMIT(0x05);
		return bytes;
        }
        else if (!strncmp(src, "stop", 4)) 
        {
                // mov rax, 60
                EMIT(0x48); EMIT(0xc7); EMIT(0xc0); EMIT(0x3c); EMIT(0); EMIT(0); EMIT(0);
                // syscall
                EMIT(0x0f); EMIT(0x05);
                return -1;
        } 
	else
	{
		printf("\nInstruction not found. Aborting.\n");
		exit(0);
	}
}

void* jit_compile()
{
	void (*compiled_code)(void) =
	mmap(0, MAX_INSTR*MAX_EMITTED+14, 
	PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);

	// mov r9, addr
	*(uint8_t*)(compiled_code+0) = 0x49;
        *(uint8_t*)(compiled_code+1) = 0xc7;
        *(uint8_t*)(compiled_code+2) = 0xc1;
	*(uint32_t*)(compiled_code+3)= (uint32_t)addr;
	// mov r10, memory
        *(uint8_t*)(compiled_code+7) = 0x49;
        *(uint8_t*)(compiled_code+8) = 0xc7;
        *(uint8_t*)(compiled_code+9) = 0xc2;
        *(uint32_t*)(compiled_code+10)=(uint32_t)memory;

        char input[0x20];
        int step = 0;

	void (*compiled_code_ptr)(void) = compiled_code + 14;

        while(1)
        {
		memset(input, 0, 0x20);
		read(0, input, 0x20);
                if (!strncmp(input, "stop", 4) || step == MAX_INSTR-1)
                {
                        strncpy(input, "halt", 4);
                        addr[step] = compiled_code_ptr;
                        jit_compile_instr((uint8_t*)compiled_code_ptr, input, step);
                        break;
                }

                addr[step] = compiled_code_ptr; 
                compiled_code_ptr += jit_compile_instr((uint8_t*)compiled_code_ptr, input, step);
                step++;
        }


	return compiled_code;
}

void __attribute__((naked)) helper()
{
	asm("mov rdi, rax"); asm("ret");
        asm("mov rsi, rax"); asm("ret");
        asm("mov rdx, rax"); asm("ret");
	asm("syscall"); asm("ret");
}

int main()
{
	printf("The flag is in flag.txt");
	printf("\ngood luck :)\n");

	memset(memory, 0, 0x1000);
	memset(addr, 0, 0x1000);

	void (*f)(void) = jit_compile();
	f();
}
