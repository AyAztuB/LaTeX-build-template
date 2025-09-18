.PHONY: all clean veryclean

all clean veryclean:
	${MAKE} -C examples/builder/ $@
