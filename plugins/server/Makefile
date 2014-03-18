MANDIR?= ./man
MANFILE?= server.1
INSTALL?= install
INSTALLMAN= ${INSTALL} -m 644

all: uninstall man install cleanup

uninstall:
	rm -rf ${MANDIR}/man1

install:
	mkdir -p ${MANDIR}/man1
	${INSTALLMAN} ${MANFILE} ${MANDIR}/man1/${MANFILE}
	${INSTALLMAN} ${MANFILE}.html ${MANDIR}/man1/${MANFILE}.html

man:
	ronn ${MANFILE}.ronn

cleanup:
	rm -f ./${MANFILE}
	rm -f ./${MANFILE}.html

.PHONY: uninstall man install cleanup
