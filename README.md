# ➤ ヤンザリのモ・ポリ (Yanzari's Mo Poly)

---
## ➤ Badges

[![Static Badge](https://img.shields.io/badge/github-repo-blue?style=plastic&logo=github&label=Yanzari's%20Mo%20Poly)](https://github.com/Yanzaris-Mo-Poly-s-Team/YANZARI-S.MO.POLY.SRB2/)

---

リポジトリは英語ですが、いくつかを日本語に翻訳しました。 (The repository is in English, but I have translated some parts into Japanese.)\
A large and very good mod that will be reworked and made open source.

We Accept Contributions Now!

The mod information is from before it was paused;\
the [status](#-status) is Current.

---
## ➤ Table of Contents

* [➤ ヤンザリのモ・ポリ (Yanzari's Mo Poly)](#-yanzaris-mo-poly)
    * [➤ Badges](#-badges)
	* [➤ About the Mod](#-about-the-mod)
		* [What are your plans for the mod?](#what-are-your-plans-for-the-mod)
		* [What else do you plan to include in the mod?](#what-else-do-you-plan-to-include-in-the-mod)
		* [This shows a bit of scripting for YMKP](#this_shows_a_bit_of_scripting_for_ymkp)
		* [Do you care about file security?](#do_you_care_about_file_security)
		* [What is the purpose of this mod?](#what-is-the-purpose-of-this-mod)
		* [How much storage does it consume?](#how-much-storage-does-it-consume)
		* [Which languages are supported?](#which_languages_are_supported)
		* [Will there be a sequel?](#will-there-be-a-sequel)
		* [Will the mod support other mods?](#will-the-mod-support-other-mods)
			* [Will there be a Wiki?](#will-there-be-a-wiki)
			* [Will it support SRB2VR and SRB2Mobile?](#will-it-support-srb2vr-and-srb2mobile)
		* [Bugs](#bugs)
	* [➤ Installation](#-installation)
	* [➤ Contribution](#-contribution)
	* [➤ Owner?](#-owner)
	* [➤ How to run it?](#-how-to-run-it)
	* [➤ Status](#-status)
	* [➤ Compile](#-compile)
		* [Compilation instructions for Lua:](#compilation-instructions-for-lua)
		* [Compilation instructions for QMake:](#compilation-instructions-for-qmake)
		* [Compilation instructions for Make:](#compilation-instructions-for-make)
		* [Compilation instructions for CMake (Requires CMake 3.10 or above.):](#compilation-instructions-for-cmake-requires-cmake-310-or-above)

---

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/colored.png)](#about-the-mod)

## ➤ About the Mod

* This mod will be very complex, very cool, and fun;
it will have many characters and many DLCs.

### What are your plans for the mod?
* Characters:
  * Sonic from Sonic and the Fallen Star (Credits to StarDrop)
  * Tails from Sonic and the Fallen Star (Credits to StarDrop)
  * Amy from Sonic and the Moon Facility (Credits to StarDrop)
  * Alex from Super Cat Tales 2 (Credits to Neotronized)
 
* Map Themes:
  * Super Phantom Cat 2 (Credits to Veewo)
  * Super Cat Tales 2 (Credits to Neotronized)
  * Sonic and the Fallen Star (Credits to StarDrop)
  * Original Maps
  * Exclusive DLC Maps

* Hud
  * Themed Super Cat Tales 2 (Credits to Neotronized)
  * Themed Sonic and the Fallen Star (Credits to StarDrop)
  * Menus
    * Themed around Sonic and the Fallen Star and Super Cat Tales, with some original content.
    
* Sounds & Musics
  * Themes from Super Cat Tales 2, Sonic and the Fallen Star, etc.
  
* SRB2 Lua Scripts
  * All scripts were created by me and perhaps by others.
  * I will review the scripts you submit for your contributions.
    * If everything is alright, I will accept.
    * If everything isn't alright, I won't accept it.
 
### What else do you plan to include in the mod?
I plan to put a **lot of stuff** on it, I think the SRB2 will be able to handle it.

* Custom Character Selection Screen
* Customized Credits Screen
* Customized Player Setup Screen
* Customized Chat
* many DLCs
* A Command Prompt Instead of the SRB2 Console
* Recreating some functions of Lua 5.4
* Partitions
* Heavy File I/O Encryption!!
  * SQLite3, Aes, base64 and others
* LoadString (Lua 5.1)
* Load (Lua 5.4)
* Floating Numbers
* Classes
* SRB2 Thokker
* Menus so you don't have to mess with console variables.
* Yanzari's Mo Poly Table (`YanzMoPoly`) will no longer be accessible; only YMKP and YMSP will be available.
* Yanzari's Modding Kit Poly (YMKP)
  * ヤンザリの改造キット ポリ
  * Basically, an SDK (Software Development Kit).
  * a brief explanation: SDK (Software Development Kit) is a complete set of tools that allows developers to create, test, and integrate applications on a specific platform.
* Yanzari's Modding Space Poly (YMSP)
  * ヤンザリのモッディングスペースポリ
  * This will be a space where you can put functions, variables, constants, classes, hooks, etc. Everything your mod stores must be in this space.
  * Example to create (if YMKP is implemented): `YMKP:AddSpace(name : string)`
* Among many other things that will make your game good.

### This shows a bit of scripting for YMKP
This depends on whether **YMKP is fully added**:\
  Let's assume that this file is not **init.lua**:
    -- It will probably only work in the final version.
    local Mod = YMKP:AddSpace(spacename : string)
    Mod:Init(function(API)
      -- when the Space is Loaded
      -- Example
      -- You can only use what the API exposes.
      local Players = API:GetAllPlayers()
      local Log = API:GetLog()
        if Log
          Log:Print(text : string)
          local Player = Players:GetLocalPlayer()
          if (Player and Player:IsValid() and Player:GetMobj() and Player:GetMobj():IsValid()) ~= nil
            Log:Printf(Player : userdata : ymp_player_t, text : string)
          end
        end
       -- ...
    end)
    
    Mod:SetAttributes({
    -- Example
    ["Space"] = "LOL"
    -- Define the attributes of the Mod...
    },type : string) -- The type can be YAML, XML, or JSON, Mod:GetAttributes It will return a string in the way the type was defined.
    
    Mod:NetVars(function(Net)
      -- Example
      Net:Set(var) -- Variables to Synchronize
    end)
    
    Mod:Credits({
    -- Example
    "Yanzari",
    "You",
    -- other people
    })
    
    Mod:Freeslot({
    -- Example
    "MYSPRITE" = "SPRITE",
    --Freeslot Everything Here, Not Counting SkinColors
    })   
    
    local MySkinColor = Mod:Skincolor(skincolorname : string)
    -- Example
    MySkinColor:Set("name",name : string)
    MySkinColor:Set("colors",colors : table)
    MySkinColor:Set("Chat Color",chatcolor : string)
    MySkinColor:Set("Is Super Color?",supercolor : boolean)
    -- etc
    MySkinColor:Def() --Turn SkinColor
    
    Mod:MobjDef(mobjtype : string,{
    -- define the attributes
    })
    
    Mod:StateDef(state : string,{
    -- define the attributes
    })
    
    Mod:SoundDef(sound : string,{
    -- define the attributes
    })
    
    Mod:AddConstants({
    -- Example
    [Const : String] = Value : Any
    -- define the Constants and Its Values
    })
    
    Mod:Hud(function(API : userdata)
      -- Example
      local Players = API:GetAllHudPlayer()
      local Player = Players:GetLocalPlayer()
      local Hud = API:HudAdd(hudtype : string)
      local HudSpace = Hud:AddItem(name : string)
      local FRACUNIT = API:GetSRB2Const("FRACUNIT")
      
      HudSpace:Draw(x : fracunit,y : fracunit,type : string,text_or_patch : string,color : ymp_skincolor_t,text_align : string : if text,font : string : if text) -- Supports accents on words!!! It also supports emojis!!!🥳
      --Example1: HudSpace:Draw(1*FRACUNIT,1*FRACUNIT,"String","IShowSpēēd😌",API:GetSkinColor("Yellow"),"Center","PLS_SPEED_I_NEED_THIS")
      --Example2: HudSpace:Draw(1*FRACUNIT,1*FRACUNIT,"Patch","ISKINDAHOMELESS",API:GetSkinColor("RICKROLL"))
      API:Enable(item : string)
      API:Disable(item : string)
      API:Enabled(item : string)
    end)
    
    Mod:Hook(hook : string,function(API : userdata)
      -- Example
      -- You can only use what the API exposes.
      local Mobjs = API:GetAllMobjs()
      local Mobj = Mobjs:GetByType(type : string)
      local Players = API:GetAllPlayers()
      local Player = Players:GetLocalPlayer()
      local SkinName = Player:GetSkinName()
      local ExpectedSkinName = skinname : string
      local Skin = API:GetSkinTableByName(Player:GetSkinName())
      local Const = Mod:GetConstants("Const")
      if SkinName == ExpectedSkinName
        local Log = API:GetLog()
        if Log
          Log:Print(text : string)
        end
        local Io = API:GetIO(privatekey : string, name : string : optional) -- Encrypted with AES!
        local File = nil
        local Write = nil
        local ModLog = Mod:GetMyLog()
          File = Io:Create(filename : string,mode)
          Write = File:Write(text : string) -- Encrypted with Base64 & ZLib!
          if Write:Writed() == true
            ModLog:Write(text : string)
          end
          if File:IsClosed() == true
            -- ...
          end
          if File:Type() == var : string
            -- ...
          end
          File:CreateSha1(File:Read("*a"),privatekey : string) -- Creates a Sha1 at the end of the file.
          File:CheckSha1(start : number, end : number,publickey : string) -- Check the Sha1 to see if there are any inconsistencies.
      end
    end,extra : any : depends)
    
    local filename = Mod:Require(filename : string) -- returns an addonfile_t or nil
    local filename = Mod:Include(filename : string) -- returns an addonfile_t or error
    
    Mod:Exit(function(API)
    -- When the game performs an action considered to be closed
    -- an example
    local ExitType = API:GetExitType()
    if ExitType == "SRB2"
    elseif ExitType == "Kick"
      local KickReason = API:GetKickReason()
      if KickReason == "Ban"
        local Io = API:GetIO("A1B2C3D4E5F6G7H8I9", name : string : optional) -- Encrypted with AES!
        local File = nil
        local Write = nil
        File = Io:Create(filename : string,mode)
        Write = File:Write(API:GetServerName()) -- Encrypted with Base64 & ZLib!
      end
    end
    end)
    
Get your space back; if you run this while it's private, it returns an error: `local GetMySpace = YMKP:GetSpace(spacename : string)`\
When the Mod is fully loaded via init.lua, if you want the Space to be private: `YMKP:SetSpacePrivate(spacename : string)`\
If you want to load the files, we will assume you want to load files using init.lua: `YMKP:LoadFile(path : string)`

And... For God's sake🛐,\
don't access or modify the YanzMoPoly table,\
otherwise you'll get an error:\
  `Yanzari's Mo Poly Error: Do not access or modify me. I have private things. Please access YMKP instead.`
  
Use YMKP and YMSP responsibly\
if they are implemented.😉
  
### Do you care about file security?
Yes, that's why we use Base64,\
AES, sha1, and zlib; we don't\
use only base64 like other modders\
for security reasons.

Being safe... is good,\
especially against unwanted\
and harmful changes.

### What is the purpose of this mod?
It's a mod that gets stuck in your memory because it's so good,\
and I also want to know if **SRB2 is capable**\
**of running complex things.**

### How much storage does it consume?
more than ~**1GB**.

### Which languages are supported?
🇧🇷**Portuguese: Brazil** (with Accents in Words),\
🇵🇹**Portuguese: Portugal** (with Accents in Words),\
🇺🇲**English**,\
🇪🇸**Spanish** (with Accents in Words),\
🇰🇷**Korean** (With Korean Characters),\
🇯🇵**Japanese** (With Japanese Characters) and\
🇷🇺**Russian** (With Russian Characters).

### Will there be a sequel?
Yes. It was called "**Yanzari's Lost Island**"\
The sequel will be... MUCH better.

### Will the mod support other mods?
**Yes**, full support.

#### Will there be a Wiki?
we will have **YWikiPedia**,\
there, there will be documentation of Yanzari's Mo Poly and Yanzari's Mo Poly++.

#### Will it support SRB2VR and SRB2Mobile?
**yes**, SRB2VR and SRB2Mobile supported Yanzari's Mo Poly, however...\
it requires SRB2 2.2.15.

You will need to have the SRB2VR version of SRB2 2.2.15,\
if it exists; otherwise, you will have to create a version of SRB2VR for SRB2 2.2.15. 

### Bugs
When you started a multiplayer server and someone joined,\
it would cause your game to crash.

---

I know that if you have the source code, you'll be able to make add-ons that modify my mod.\
(I consider a mod to be a modification and an addon to be a mod that alters another mod.)

Requirements:\
• Sonic Robo Blast 2 v2.2.15
  
This mod cannot be redistributed Unofficially, parts of the project may be distributed, but not the entire mod.

---

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/colored.png)](#installation)

## ➤ Installation
Open your command prompt.\
Install Git.\
run `git clone https://github.com/Yanzaris-Mo-Poly-s-Team/YANZARI-S.MO.POLY.SRB2.git`.\
Compile and run.


[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/colored.png)](#contribution)

## ➤ Contribution
It's very simple to contribute, it's very simple and easy.

Go to the discussion area.\
You'll jump into any discussion that comes along.\
You say you want to participate and specify which area of the mod (e.g., scripter, spritter) you want to help with.\
Wait a moment and we'll add you.

It's very easy and it helps a lot.

---

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/colored.png)](#owner)

## ➤ Owner?
Yanzari

---


[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/colored.png)](#how-to-run-it)

## ➤ How to run it?
Open your srb2, and leave it on the title screen (the mod cannot be started by joining the server).\
Run `addfile <Yanzari's Mo Poly Archive>`.\
Optional, After Run `addfile <Yanzari's Mo Poly++ Archive>`.\
Then, run other mods if you want.

--- 

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/colored.png)](#status)

## ➤ Status

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


[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/colored.png)](#compile)

## ➤ Compile

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

---
