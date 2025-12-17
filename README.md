# ヤンザリのモ・ポリ (Yanzari's Mo Poly)

[![Static Badge](https://img.shields.io/badge/github-repo-blue?style=plastic&logo=github&label=Yanzari's%20Mo%20Poly)](https://github.com/Yanzaris-Mo-Poly-s-Team/YANZARI-S.MO.POLY.SRB2/)

リポジトリは英語ですが、いくつかを日本語に翻訳しました。 (The repository is in English, but I have translated some parts into Japanese.)\
A large and very good mod that will be reworked and made open source.

---
## About the Mod

- This mod will be very complex, very cool, and fun;
it will have many characters and many DLCs.

### What are your plans for the mod?
- Characters:\
  - Sonic from Sonic and the Fallen Star (Credits to StarDrop)
  - Tails from Sonic and the Fallen Star (Credits to StarDrop)
  - Amy from Sonic and the Moon Facility (Credits to StarDrop)
  - Alex from Super Cat Tales 2 (Credits to Neotronized)
 
- Map Themes:
  - Super Phantom Cat 2 (Credits to Veewo)
  - Super Cat Tales 2 (Credits to Neotronized)
  - Sonic and the Fallen Star (Credits to StarDrop)
  - Original Maps
  - Exclusive DLC Maps
 
### What else do you plan to include in the mod?
I plan to put a lot of stuff on it, I think the SRB2 will be able to handle it.

- Custom Character Selection Screen
- Customized Credits Screen
- Customized Player Setup Screen
- Customized Chat
- many DLCs
- A Command Prompt Instead of the SRB2 Console
- Recreating some functions of Lua 5.4
- Partitions
- Heavy File I/O Encryption!!
  - SQLite3, Aes, base64 and others
- LoadString (Lua 5.1)
- Load (Lua 5.4)
- Floating Numbers
- Classes
- SRB2 Thokker
- Menus so you don't have to mess with console variables.
- Among many other things that will make your game good.

### What is the purpose of this mod?
It's a mod that gets stuck in your memory because it's so good,\
and I also want to know if SRB2 is capable\
of running complex things.

### Will there be a sequel?
Yes. It was called "Yanzari's Lost Island"\
The sequel will be... MUCH better.

### Will the mod support other mods?
Yes, full support.

####  Will there be a Wiki?
we will have YWikiPedia,\
there, there will be documentation of Yanzari's Mo Poly and Yanzari's Mo Poly++.

#### Will it support SRB2VR and SRB2Mobile?
yes, SRB2VR and SRB2Mobile supported Yanzari's Mo Poly, however...\
it requires SRB2 2.2.15.

You will need to have the SRB2VR version of SRB2 2.2.15,\
if it exists; otherwise, you will have to create a version of SRB2VR for SRB2 2.2.15. 

### Bugs
When you started a multiplayer server and someone joined,\
it would cause your game to crash.
 ---

If you'd like to help, submit a Pull Request.

I know that if you have the source code, you'll be able to make add-ons that modify my mod.\
(I consider a mod to be a modification and an addon to be a mod that alters another mod.)

Requirements:\
• Sonic Robo Blast 2 v2.2.15
  
This mod cannot be redistributed.

Status:

    The open-source mod hasn't been cancelled,
    just temporarily paused until my computer is re-
    covered.
    I'm doing everything on my phone.

    When my computer is recovered,
    the repository will contain the Yanzari's Mo Poly 
    files from my PC.

    Play some SRB2 in multiplayer mode while eating a chili dog and have patience. 

    I wish you continued good health.

    I will still talk about it in the SRB2 workshop, but 
    I won't post anything about the mod. If you want 
    to contribute, wait until the status is okay. 

    When I recover it, the status will look like this: 
    "The Mod has been recovered, the Mod will be 
    uploaded to GitHub in an instant."

    I am really sorry about that. 

    —By ヤンザリ(Yanzari)

---

## Compile

You can use CMake, Make, QMake, or Lua.

Before following the instructions, open the command prompt (cmd). Now that you have opened the command prompt (cmd), execute the instructions.

---

### Compilation instructions for Lua:
Install Lua and LuaRocks\
Run `luarocks install luafilesystem`\
Then, Run `lua Build.lua`

---

### Compilation instructions for QMake:
Run `qmake Build.pro`

---

### Compilation instructions for Make:
Run `make`

---

### Compilation instructions for CMake (Requires CMake 3.10 or above.):
Run `cmake .`\
Run `make`