// This C++ script is for compilation, intended only for those who want to compile using the srb2 compilation method, since it uses C/C++. Here we will use C++, so use g++ to compile.
// Made by Yanzari
#include <iostream>
#include <fstream>
#include <string>
#include <filesystem>
#include <cstdlib>
#include <sstream>
#include <vector>

// Namespace to simplify the use of standard libraries.
namespace fs = std::filesystem;
using namespace std;

// ==============================================
// Log function
// ==============================================
void printlog(const string& txt) {
    cout << "Build.cpp: " << txt << endl;
}

// ==============================================
// Class for Operating System manipulation
// ==============================================
class Os {
public:
    // Detects OS: Windows, Android, or Linux
    static string Detected() {
        // Check folder separator (Windows = \, Unix = /)
        if (fs::path::preferred_separator == '\\') {
            return "Windows";
        } else {
            // Check if it's Android (check the /system/build.prop file)
            if (fs::exists("/system/build.prop")) {
                return "Android";
            } else {
                return "Linux";
            }
        }
    }

    // Check if you are running as admin/root.
    static bool IsAdmin(const string& os) {
        if (os == "Windows") {
            // Windows command to check access to HKLM
            const char* cmd = "reg query \"HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\" 2>nul";
            FILE* pipe = popen(cmd, "r");
            if (!pipe) return false;

            char buffer[128];
            string result;
            while (fgets(buffer, sizeof(buffer), pipe) != nullptr) {
                result += buffer;
            }
            pclose(pipe);
            return !result.empty();
        } else {
            // Linux/Android: UID 0 = root
            FILE* pipe = popen("id -u", "r");
            if (!pipe) return false;

            char buffer[128];
            fgets(buffer, sizeof(buffer), pipe);
            pclose(pipe);
            int uid = stoi(buffer);
            return uid == 0;
        }
    }
};

// ==============================================
// Project settings
// ==============================================
const string MOD_NAME = "SMRFCL_Yanzaris-Mo-Poly";
const string VERSION = "v0.0.1";
const string OUTPUT = MOD_NAME + "_" + VERSION + ".pk3";

const string SRC_DIR = "src";
const string LUA_DIR = SRC_DIR + "/Lua";
const string BUILD_DIR = "build";
const string TEMP_DIR = BUILD_DIR + "/temp";

// ==============================================
// File/Folder Handling Functions
// ==============================================
bool IsWindows() {
    return fs::path::preferred_separator == '\\';
}

void F_CreateDirectory(const string& path) {
    if (IsWindows()) {
        string cmd = "mkdir \"" + path + "\" 2>nul";
        system(cmd.c_str());
    } else {
        string cmd = "mkdir -p \"" + path + "\"";
        system(cmd.c_str());
    }
}

void F_RemoveDirectory(const string& path) {
    if (IsWindows()) {
        string cmd = "rmdir /s /q \"" + path + "\" 2>nul";
        system(cmd.c_str());
    } else {
        string cmd = "rm -rf \"" + path + "\"";
        system(cmd.c_str());
    }
}

void F_CopyDirectory(const string& src, const string& dest) {
    F_CreateDirectory(dest); // Ensures destination folder exists
    if (IsWindows()) {
        // XCOPY: /E (all files/folders), /I (treat dest as folder), /Y (overwrite)
        string cmd = "xcopy \"" + src + "\" \"" + dest + "\" /E /I /Y >nul";
        system(cmd.c_str());
    } else {
        string cmd = "cp -r \"" + src + "\"/* \"" + dest + "\"";
        system(cmd.c_str());
    }
}

void F_Echo(const string& msg) {
    printlog(msg);
}

void F_Usage() {
    F_Echo("Usage: ./Build [release|debug|clean|distclean|info]");
}

void F_CreateCompilationNote(const string& tempdir) {
    ofstream file(tempdir + "/.build-note");
    if (file.is_open()) {
        file << "Thank you for building the mod via Build.cpp, yanzari appreciates it.\n\n—Yanzari\n";
        file.close();
    } else {
        printlog("Warning: Could not create .build-note");
    }
}

void F_CreateBuildIdentificationFile(const string& tempdir, const string& build_type) {
    string lua_dir = tempdir + "/Lua";
    F_CreateDirectory(lua_dir);
    
    ofstream file(lua_dir + "/Maketype.lua");
    if (file.is_open()) {
        file << "local YMP = YanzMoPoly\n";
        if (build_type == "debug") {
            file << "YMP.BuildType = { build = \"Debug\", compmod = \"Build.cpp\" }\n";
        } else {
            file << "YMP.BuildType = { build = \"Release\", compmod = \"Build.cpp\" }\n";
        }
        file.close();
    } else {
        printlog("Warning: Could not create Maketype.lua");
    }
}

void F_CreateZip(const string& tempdir, const string& output) {
    if (IsWindows()) {
        // Use PowerShell to compress (available on Windows 10+)
        string cmd = "powershell -Command \"Compress-Archive -Path \"" + tempdir + "\\*\" -DestinationPath \"" + output + "\" -Force\"";
        system(cmd.c_str());
    } else {
        // Use the zip command (install with 'sudo apt install zip' on Linux/Android)
        string cwd = fs::current_path().string();
        string cmd = "cd \"" + tempdir + "\" && zip -qr \"" + cwd + "/" + output + "\" .";
        system(cmd.c_str());
    }
}

void F_CopySrc() {
    F_Echo("Copying source files...");
    F_CopyDirectory(SRC_DIR, TEMP_DIR);
    F_CreateDirectory(TEMP_DIR + "/Lua"); // Moon folder guarantees it exists.
}

void F_CleanTemp() {
    F_Echo("Cleaning temporary files...");
    F_RemoveDirectory(TEMP_DIR);
}

// ==============================================
// Target Functions (Main Commands)
// ==============================================
void F_TargetRelease() {
    F_CreateDirectory(BUILD_DIR);
    F_CreateDirectory(TEMP_DIR);
    F_CopySrc();
    F_CreateCompilationNote(TEMP_DIR);
    F_CreateBuildIdentificationFile(TEMP_DIR, "release");
    F_CreateZip(TEMP_DIR, OUTPUT);
    F_CleanTemp();
    
    F_Echo("✓ The compilation was completed successfully.");
    F_Echo("Output: " + OUTPUT);
    F_Echo("Build Type: release");
    F_Echo("Build Tool: Build.cpp");
    F_Echo("File Made By Yanzari");
}

void F_TargetDebug() {
    F_CreateDirectory(BUILD_DIR);
    F_CreateDirectory(TEMP_DIR);
    F_CopySrc();
    F_CreateCompilationNote(TEMP_DIR);
    F_CreateBuildIdentificationFile(TEMP_DIR, "debug");
    F_CreateZip(TEMP_DIR, OUTPUT);
    F_CleanTemp();
    
    F_Echo("✓ The compilation was completed successfully.");
    F_Echo("Output: " + OUTPUT);
    F_Echo("Build Type: debug");
    F_Echo("Build Tool: Build.cpp");
    F_Echo("File Made By Yanzari");
}

void F_Clean() {
    F_Echo("Cleaning build artifacts...");
    if (fs::exists(OUTPUT)) {
        fs::remove(OUTPUT);
    }
    F_Echo("✓ Clean completed");
}

void F_DistClean() {
    F_Clean();
    F_RemoveDirectory(BUILD_DIR);
    F_Echo("✓ All build files removed");
}

void F_Info() {
    cout << "A Tool for Compiling Yanzari's Mo Poly with C++" << endl;
    cout << endl;
    cout << "Available Commands: " << endl;
    cout << "  release   - Build in release mode (default)" << endl;
    cout << "  debug     - Build in debug mode" << endl;
    cout << "  clean     - Remove PK3 file" << endl;
    cout << "  distclean - Remove all build files" << endl;
    cout << "  info      - Show this information" << endl;
}

// ==============================================
// Função Principal (Main)
// ==============================================
int main(int argc, char* argv[]) {
    // Checks operating system and permissions.  
    string device = Os::Detected();
    bool is_admin = Os::IsAdmin(device);

    if (is_admin) {
        if (device != "Windows") {
            printlog("You are running as root.");
            if (device != "Linux") {
                printlog("Be careful with your guarantee.");
            }
        } else {
            printlog("You are running as administrator.");
        }
    } else {
        if (device != "Windows") {
            printlog("You are not running as root.");
        } else {
            printlog("You are not running as administrator.");
        }
    }

    // Check command argument (default = release)
    string cmd = (argc >= 2) ? argv[1] : "release";

    // Executes selected command.
    if (cmd == "release") {
        F_TargetRelease();
    } else if (cmd == "debug") {
        F_TargetDebug();
    } else if (cmd == "clean") {
        F_Clean();
    } else if (cmd == "distclean") {
        F_DistClean();
    } else if (cmd == "info") {
        F_Info();
    } else {
        F_Usage();
        return 1; // Error code for invalid command.
    }

    return 0; // Sucess
}