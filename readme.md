# 📘 PCP Automation – README (Updated & Clean Preview)

This README explains how to configure and run the **PCP Leader** and **PCP Member** automation scripts, including required game folder setup.

---

# 📁🔧 0. Game Folder Setup (VERY IMPORTANT)

Your PCP automation requires UI, model, and image modifications.

Inside your installation package you will find:

```
PCP/setup/
    ├── mods
    ├── local
    ├── model
    └── ui
```

### ✅ You MUST copy these folders into your game directory exactly as they are:

- Do **not** rename them  
- Do **not** partially merge  
- Copy all four folders directly into the **game root folder**

### Example

```
<Your Game Folder>/
    ├── mods/
    ├── local/
    ├── model/
    └── ui/
```

These folders contain:

- Modified UI icons  
- Custom UI elements  
- Bitmaps for image recognition  
- Movement & model metadata  

Without this setup, PCP will **not function**.

---

# 🧩 Overview

This automation handles **PCP Cave Runs** in *Shark Sea*, including:

- Auto-navigation  
- Auto-teaming  
- Leader logic  
- Cave entry/exit  
- Target detection & combat  
- CSV signaling  
- Team dismissal  
- Return to Guild  

---

# 📁 Folder Requirements

```
Bot/
PCP/
```

Inside:

```
PCP/
    ├── itemdelete/
    ├── team.bmp
    ├── cave.csv (auto)
    ├── <CHAR>.csv (auto)
    ├── specter_*.bmp
    └── other detection images
```

---

# 🧙‍♂️ 1. Leader Script Setup

**File:** `PCP Leader.txt`

```lua
Leader = "YES"
LeaderName = "<leader name>"
teamcount = 5

Team1 = "<member1>"
Team2 = "<member2>"
Team3 = "<member3>"
Team4 = "<member4>"
team  = "<member5>"

CHAR_NAME = "<leader character>"
```

Leader handles:

- CSV control  
- Team formation  
- Cave entry  
- Combat via `inside2()`  
- Detect boss death  
- Team dismiss  
- Guild return  
- Loop  

---

# 👥 2. Member Script Setup

Each member script sets:

```lua
Leader = "NO"
LeaderName = "<leader>"
team = "<their number>"
CHAR_NAME = "<their name>"
```

Members automatically:

- Wait for CSV  
- Auto-join  
- Follow leader  
- Attack via `inside1()`  
- Delete cave.csv  
- Exit  
- Return to Guild  
- Loop  

---

# 📌 3. CSV Signal System

Leader creates:

```
PCP\<TeamX>.csv
PCP\cave.csv
PCP\<TeamX>cave.csv
```

Members wait for:

```
PCP\<CHAR>.csv
```

Boss death delays:

| Team | Delay |
|------|-------|
| 1 | 200ms |
| 2 | 400ms |
| 3 | 600ms |
| 4 | 800ms |
| 5 | 100ms |

---

# ⚔️ 4. Attack Logic

**AOE Mode:** first 150s  
**Single Target Mode:** after timer  

Leader uses `inside2()`  
Members use `inside1()`

Detection includes:

- specter_fish  
- specter_shark  
- specter_servant  
- Coral  
- YeChun (boss)

HP check:

```lua
PCP.Targethpzero()
```

---

# 🧭 5. Cave Navigation

```lua
Boss.gettotargetspot_notstrict(x, y, tol)
Boss.isInToleranceArea()
```

Default:

```
X = 270
Y = -24
```

---

# 🛑 6. Team Dismissal

Boss dies → leader:

- Deletes CSVs  
- Runs `PCP.Dismissteam()`  
- Teleports  

Members return to Guild.

---

# 🔁 7. Automation Loop

```lua
while true do
    PCP.start()
end
```

---

# 🧪 8. Stable Run Requirements

- FOE list updated  
- Correct team numbers  
- All .bmp present  
- No leftover CSVs  
- Skill mapping correct  

**Leader Example:**

```lua
attackskills = "F5"
aoe = "333222111"
```

**Member Example:**

```lua
attackskills = "321"
aoe = "332221"
```

---

# 🟢 9. Start Sequence

### Leader:
1. Run leader script  
2. Wait for Guild  
3. Members join  

### Members:
1. Start scripts  
2. Auto-join  
3. Follow leader  
4. Kill boss → exit → Guild  

---

# 🎉 README Complete

