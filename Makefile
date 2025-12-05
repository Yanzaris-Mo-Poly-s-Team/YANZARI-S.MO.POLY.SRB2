MOD_NAME = "SMRFCL_Yanzaris-Mo-Poly"
VERSION = "v0.0.1"
OUTPUT = $(MOD_NAME)_$(VERSION).pk3

SRC_DIR = src

ZIP_TEMP = yanzmopoly_temp.zip

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
