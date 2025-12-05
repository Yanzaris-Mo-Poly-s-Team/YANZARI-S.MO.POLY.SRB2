# To Do: A Better Makefile

# Settings
PREFIX = "SMRFCL"
MOD_NAME = "Yanzaris-Mo-Poly"
VERSION = "v0.0.1"
OUTPUT = $(PREFIX)_$(MOD_NAME)_$(VERSION).pk3
SRC_DIR = src
ZIP_TEMP = Yanzaris_Mo_Poly_Temporary_Zip.zip

# Code
.PHONY: all clean

all: $(OUTPUT)

$(OUTPUT): $(SRC_DIR)
	@echo "Creating a temporary zip file..."
	zip -r $(ZIP_TEMP) $(SRC_DIR)
	@echo "Renaming to $(OUTPUT)..."
	mv $(ZIP_TEMP) $(OUTPUT)
	@echo "File $(OUTPUT) created successfully."

clean:
	@echo "Removing $(OUTPUT)..."

	rm -f $(OUTPUT)
