
#
# - Bloombox - bloombox-logo
#

BUILDBOT ?= 0
ENV ?= .env/
TARGET ?= target/
CREDENTIALS ?= 1
VERSION ?= 0.0.3

all: build
	@echo "bloombox-logo is ready."


#
## Build Flow
#

build: $(TARGET) $(ENV) dependencies
	@mkdir -p $(TARGET)/
	@cp -frv ./*.html ./bower.json ./demo ./README.md ./*.js $(TARGET)/;
	@echo "Project build complete."

ifeq ($(BUILDBOT),yes)
test:
	wct --job-name "bloombox-logo" --expanded --build-number "$(BUILD_NUMBER)" --sauce-tunnel-id "$(SAUCE_TUNNEL)" --plugin wct-jenkins
else
test:
	@wct --job-name "bloombox-logo"
endif

quickbuild:
	@echo "Quickbuilding..."
	@cp -frv ./*.html ./bower.json ./demo ./README.md ./*.js $(TARGET)/;

release: build
	@echo "Building release package..."
	@cd $(TARGET) && tar -czvf ../$(VERSION).tar.gz *
	@echo "Release ready."

dependencies:
	@echo "Installing project dependencies..."
	@npm install
	@bower install
	@echo "Dependencies ready."

clean:
	@echo "Cleaning project..."
	@find . -name .DS_Store -delete
	@rm -frv $(TARGET) *.tar.gz

distclean: clean
	@echo "Resetting project..."
	@rm -frv $(TARGET) $(ENV)
	@git reset --hard

forceclean: distclean
	@echo "Sanitizing project..."
	@git clean -xdf

watch:
	@echo "Watching project..."
	@gulp serve

#
## Dependencies
#

$(ENV):
	@echo "Establishing envroot..."
	@mkdir -p $(ENV)

$(TARGET):
	@echo "Establishing buildroot..."
	@mkdir -p $(TARGET)


.PHONY: all build release dependencies clean distclean forceclean test
