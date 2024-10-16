CC = gcc -g -no-pie
CFLAGS = -Og -Wall
LDFLAGS = 
ASFLAGS = -g

# Configurable parameters
PROCEDURE ?= wbs.s:wbs
ILIMIT ?= 90
MAXSIZE ?= 512
BADINSNS ?= 'j*,call*'
MAXCPI ?= 16

MAXINSNS = $(ILIMIT)

CHECK = ./check-solution --procedure $(PROCEDURE) \
	                 --max-size $(MAXSIZE) --bad-insns $(BADINSNS) $(EXTRA)
RUN = ./run-solution --procedure $(PROCEDURE) \
                     --max-insns $(MAXINSNS) $(EXTRA) -- ./main

all: test-random

check: main
	$(CHECK)

main: main.o wbs.o
	$(CC) $(LDFLAGS) -o $@ $^

test-1: check
	$(RUN) 0x8000000000000000

test-2: check
	$(RUN) 0x00A12C2140051804

test-3: check
	$(RUN) 0x00000000000000FF

test-4: check
	$(RUN) 0xFFFFFFFFFFFFFFFF

test-random: MAXINSNS=$(shell echo $$(($(ILIMIT)*1000))) 
test-random: check
	$(RUN) -r 1000

test-all: test-1 test-2 test-3 test-4 test-random

test-bonus: CHECK += --max-cpi $(MAXCPI)
test-bonus: check

clean:
	rm -f main *.o *.out *~

.PHONY: check clean test-1 test-2 test-3 test-4 test-random test-all

# vim: ts=8 sw=8 noet
