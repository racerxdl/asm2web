ASM_FILES=$(shell find . -name "*.asm")
OBJECT_FILES=$(ASM_FILES:%.asm=%.o)

NASM_OPTS=-f elf64 -F dwarf -g
LD_OPTS=-m elf_x86_64

all: helloworld


%.o: %.asm
	@echo "Montando arquivo $< -> $@"
	@nasm $(NASM_OPTS) -o $@ $<

clean:
	@echo "Limpando projeto"
	@rm -f helloworld *.o

link: $(OBJECT_FILES)
	@echo "Ligando objetos $(OBJECT_FILES)"
	@ld $(LD_OPTS) -o helloworld $(OBJECT_FILES)


helloworld: link
	@echo "YEY!"

.PHONY: clean
