#include <iostream>
#include <filesystem>
#include <fstream>
#include <cstdlib>
#include <string>

namespace fs = std::filesystem;

//--------------------------------------------------------------------------------------------
//---*Build.cpp
//--*A C++ build system so you can compile the Mod
//--*
//--*By ヤンザリ (Yanzari)
//--------------------------------------------------------------------------------------------

//--$ Project Configuration
const std::string MOD_NAME = "SMRFCL_Yanzaris-Mo-Poly";
const std::string VERSION = "v0.0.1";
const std::string OUTPUT = MOD_NAME + "_" + VERSION + ".pk3";

//--$ Directory Structure
const fs::path SRC_DIR   = "src";
const fs::path LUA_DIR   = SRC_DIR / "Lua";
const fs::path BUILD_DIR = "build";
const fs::path TEMP_DIR  = BUILD_DIR / "temp";

//--$ Colors
const std::string GREEN  = "\033[0;32m";
const std::string YELLOW = "\033[1;33m";
const std::string RED    = "\033[0;31m";
const std::string BLUE   = "\033[0;34m";
const std::string CYAN   = "\033[0;36m";
const std::string NC     = "\033[0m";

//--------------------------------------------------------------------------------------------
//--* Utility
//--------------------------------------------------------------------------------------------

void echo(const std::string& color, const std::string& text)
{
	std::cout << color << text << NC << std::endl;
}

void removeLauxFiles(const fs::path& dir)
{
	for (const auto& entry : fs::recursive_directory_iterator(dir))
	{
		if (entry.path().extension() == ".laux")
		{
			echo(BLUE, "Removing " + entry.path().string());
			fs::remove(entry.path());
		}
	}
}

//--------------------------------------------------------------------------------------------
//--* Main
//--------------------------------------------------------------------------------------------

int main(int argc, char** argv)
{
	std::string buildType = "release";

	if (argc > 1)
	{
		buildType = argv[1];
	}

	//----------------------------------------------------------------------------------------
	//--* Validation
	//----------------------------------------------------------------------------------------

	if (!fs::exists(SRC_DIR))
	{
		echo(RED, "Error: Source directory 'src' not found!");
		return 1;
	}

	//----------------------------------------------------------------------------------------
	//--* Prepare Build
	//----------------------------------------------------------------------------------------

	echo(CYAN, "Preparing build directories...");

	fs::create_directories(BUILD_DIR);
	fs::create_directories(TEMP_DIR);

	//----------------------------------------------------------------------------------------
	//--* Copy Source Files
	//----------------------------------------------------------------------------------------

	echo(BLUE, "Copying source files...");

	fs::copy(
		SRC_DIR,
		TEMP_DIR,
		fs::copy_options::recursive |
		fs::copy_options::overwrite_existing
	);

	fs::create_directories(TEMP_DIR / "Lua");

	//----------------------------------------------------------------------------------------
	//--* Compile LAUX
	//----------------------------------------------------------------------------------------

	echo(CYAN, "Compiling recursive .laux files...");

	int lauxResult = std::system("lauxc workspace");

	if (lauxResult != 0)
	{
		echo(RED, "LAUX compilation failed!");
		return 1;
	}

	//----------------------------------------------------------------------------------------
	//--* Remove .laux Files
	//----------------------------------------------------------------------------------------

	echo(BLUE, "Removing .laux files...");

	removeLauxFiles(TEMP_DIR);

	//----------------------------------------------------------------------------------------
	//--* Create .build-note
	//----------------------------------------------------------------------------------------

	echo(BLUE, "Creating .build-note...");

	{
		std::ofstream file(TEMP_DIR / ".build-note");

		file << "Thank you for building the mod via cpp, yanzari appreciates it.\n\n";
		file << "—Yanzari\n";
	}

	//----------------------------------------------------------------------------------------
	//--* Create Maketype.lua
	//----------------------------------------------------------------------------------------

	echo(BLUE, "Creating Maketype.lua (" + buildType + ")...");

	{
		std::ofstream file(TEMP_DIR / "Lua" / "Maketype.lua");

		file << "local YMP = YanzMoPoly\n";

		if (buildType == "debug")
		{
			file << "YMP.BuildType = {build=\"Debug\",compmod=\"cpp\"}\n";
		}
		else
		{
			file << "YMP.BuildType = {build=\"Release\",compmod=\"cpp\"}\n";
		}
	}

	//----------------------------------------------------------------------------------------
	//--* Create PK3
	//----------------------------------------------------------------------------------------

	echo(BLUE, "Creating PK3 archive...");

	std::string zipCommand =
		"cd \"" + TEMP_DIR.string() +
		"\" && zip -qr \"../../" + OUTPUT + "\" .";

	int zipResult = std::system(zipCommand.c_str());

	if (zipResult != 0)
	{
		echo(RED, "Failed to create PK3!");
		return 1;
	}

	echo(GREEN, "✓ Created " + OUTPUT);

	//----------------------------------------------------------------------------------------
	//--* Clean Temp
	//----------------------------------------------------------------------------------------

	echo(BLUE, "Cleaning temporary files...");

	fs::remove_all(TEMP_DIR);

	//----------------------------------------------------------------------------------------
	//--* Final Output
	//----------------------------------------------------------------------------------------

	echo(GREEN, "✓ The compilation was completed successfully.");
	echo(YELLOW, "Output: " + OUTPUT);
	echo(BLUE, "Build Type: " + buildType);
	echo(BLUE, "Build Tool: cpp");
	echo(BLUE, "File Made By Yanzari");

	return 0;
}

//--------------------------------------------------------------------------------------------
//--*End*--*Build.cpp
//--------------------------------------------------------------------------------------------