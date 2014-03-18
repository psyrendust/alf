OUTPUT?= ./terminfo
FILE?= coloredman.txt
INSTALL?= install
INSTALLMAN= ${INSTALL} -m 644

all: uninstall install

uninstall:
	rm -rf ${OUTPUT}

install:
	mkdir -p ${OUTPUT}
	tic -o ${OUTPUT} ./${FILE}

.PHONY: uninstall install
