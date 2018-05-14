SRC=src
BUILD=build

RMD_IN = $(wildcard $(SRC)/*.Rmd)
RMD_OUT := $(patsubst $(SRC)/%.Rmd,$(BUILD)/%.html,$(RMD_IN))

all: $(RMD_OUT)
	@mkdir -p build
	@echo "Building index"
	@Rscript build_RMD.R $(SRC)/index.Rmd $(BUILD)/index.html > /dev/null 2>&1 
	@echo "Done"

deploy:
	@rsync -r --progress --delete --update build/ \
		kllnr.net:/var/www/kenkellner.com/blog/

$(BUILD)/%.html: $(SRC)/%.Rmd $(SRC)/_navbar.yml 
	Rscript build_RMD.R $< $@

clean:
	rm -f build/*
