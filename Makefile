SOURCES=$(wildcard src/*.s)

OBJECTS=$(SOURCES:.s=.o)

DEBUG= $(wildcard peda-session*) \
	   .gdb_history

NAME = pA-SM-ck_x86-64 
AS  = nasm
ASFLAGS = -f elf64

LD= gcc -m64 -no-pie -nostdlib

all: $(SOURCES) $(NAME)

$(NAME): $(OBJECTS)
	$(LD) $(OBJECTS) -o $@

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -f $(OBJECTS)

fclean: clean
	rm -f $(NAME)
	rm -f $(DEBUG)

re: fclean $(NAME)

.PHONY: all clean fclean re
