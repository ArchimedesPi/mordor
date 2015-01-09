TEST_DIRECTORY=test
PREFIX?=/usr/local

.PHONY: test

test:
		bats test/

install:
		@echo "Installing Mordor to $(PREFIX)"
