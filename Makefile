PKGNAME = pkgSrc.zip

EXEC = app

CC = g++

SRC = $(wildcard ./src/*.cc)

OBJECTS = $(patsubst ./src/%,./obj/%,$(SRC:.cc=.o))

DEPENDS = $(OBJECTS:.o=.d)

# TERRIBLE FOR PERFORMANCE, GREAT FOR DEBUGGING
OPT = -O1 -g -fsanitize=address -fno-omit-frame-pointer -fno-optimize-sibling-calls
# OPT = -O1 -g 
# OPT = -O3

CFLAGS = -Wall -Wextra -std=c++20 -Iinclude/ -MMD ${OPT}

${EXEC}: ${OBJECTS}
	${CC} ${CFLAGS} ${OBJECTS} -o ${EXEC} -lncurses

all: ${OBJECTS}
	ASAN_OPTIONS=detect_leaks=1
	${CC} ${CFLAGS} ${OBJECTS} -o ${EXEC} -lncurses

obj/%.o: src/%.cc
	@echo "Compiling: $< -> $@"
	$(CC) $(CFLAGS) -MP -MMD -c $< -o $@

-include ${DEPENDS}

.PHONY: clean
clean:
	rm obj/* ${EXEC}

.PHONY: pkg
pkg:
	zip -r $(PKGNAME) Makefile ./src ./include
