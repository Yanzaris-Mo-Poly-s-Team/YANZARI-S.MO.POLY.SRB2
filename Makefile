Ou seja, o yanzari mo poly seria "SMRFCL_Yanzaris-Mo-Poly-v0.0.1" para o srb2 e "KRBCL_Yanzaris-Mo-Karloy-v0.0.1" para srb2kart, mas.. e para ringracers?

# Nome do mod e versão
MOD_NAME = "SMRFCL_Yanzaris-Mo-Poly"
VERSION = "v0.0.1"
OUTPUT = $(MOD_NAME)_$(VERSION).pk3

# Pasta com os arquivos do mod
SRC_DIR = src

# Arquivo temporário .zip antes de renomear
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