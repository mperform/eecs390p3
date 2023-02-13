SCHEME ?= plt-r5rs

all: phase1 phase2 phase3 phase4

phase1: env_tests.internal

phase2: internal_phase2_tests.internal \
	$(patsubst %.scm,%.test,$(wildcard phase2*tests.scm))

phase3: internal_phase3_tests.internal \
	$(patsubst %.scm,%.test,$(wildcard phase3*tests.scm))

phase3_%: phase3_%_tests.test
	@: # null command

phase4: $(patsubst %.scm,%.test,$(wildcard phase4*tests.scm))

%.internal:
	plt-r5rs $(@:.internal=.scm) > $(@:.internal=.out)
	! grep -n Error $(@:.internal=.out)

%.test:
	$(SCHEME) driver.scm < $(@:.test=.scm) | sed "s/Error:.*$$/Error:/g" > $(@:.test=.out)
	diff -q $(@:.test=.out) $(@:.test=.expect)
