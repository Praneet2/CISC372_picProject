
UNAME := $(shell uname -s)
ifeq ($(UNAME),Darwin)
  # Apple clang: use LLVM OpenMP from Homebrew (brew install libomp)
  LIBOMP :=
  ifneq ($(wildcard /opt/homebrew/opt/libomp/lib/libomp.dylib),)
    LIBOMP := /opt/homebrew/opt/libomp
  else ifneq ($(wildcard /usr/local/opt/libomp/lib/libomp.dylib),)
    LIBOMP := /usr/local/opt/libomp
  endif
  ifeq ($(LIBOMP),)
    $(error macOS: OpenMP needs libomp. Run: brew install libomp)
  endif
  OMPCFLAGS = -Xpreprocessor -fopenmp -I$(LIBOMP)/include
  OMPLDFLAGS = -L$(LIBOMP)/lib -lomp
else
  OMPCFLAGS = -fopenmp
  OMPLDFLAGS =
endif

image:image.c image.h
	gcc -g image.c -o image -lm

image_openMP:image_openMP.c image.h
	gcc $(OMPCFLAGS) -g image_openMP.c -o image_openMP -lm $(OMPLDFLAGS)

clean:
	rm -f image image_openMP output.png
