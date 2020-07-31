

helloworld: .PHONY
	rm -f helloworld helloworld.o
	nasm -f elf64 -F dwarf -g -o helloworld.o helloworld.asm
	ld -m elf_x86_64 -o helloworld helloworld.o

.PHONY:
