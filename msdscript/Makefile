INCS = cmdline.h catch.h expr.h parse.h val.h pointer.h env.h

OBJS = main.o cmdline.o expr.o parse.o tests.o val.o env.o

CXXFLAGS = -std=c++14 -O2

msdscript: $(OBJS)
	$(CXX) $(CXXFLAGS) -o msdscript $(OBJS)

.PHONY: test
test: msdscript
	./msdscript --test

main.o: $(INCS)
cmdline.o: $(INCS)
expr.o: $(INCS)
parse.o: $(INCS)
val.o: $(INCS)
env.o: $(INCS)