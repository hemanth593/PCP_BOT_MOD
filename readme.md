PCP Automation – README (Updated)

This README explains how to configure and run the PCP Leader and PCP Member automation scripts. It also includes the required game folder setup.

Scripts referenced:

PCP Leader Script 

PCP Leader

PCP Member Scripts (1–4)

PCP Core Logic – PCP.lua 

PCP

📁 🔧 0. Game Folder Setup (VERY IMPORTANT)

Your PCP automation requires certain game UI and model modifications.

Inside your installation package you will find:

PCP/setup/
    ├── mods
    ├── local
    ├── model
    └── ui

✅ You MUST copy these folders into your game directory exactly as they are.

Do not rename them.
Do not merge/replace partially.
Copy all four folders (mods, local, model, ui) directly into your game root folder.

Example:

<Your Game Folder>/
    ├── mods/       <-- copy here
    ├── local/      <-- copy here
    ├── model/      <-- copy here
    └── ui/         <-- copy here


These folders contain:

modified UI icons for specter_fish, specter_shark, specter_servant, YeChun, etc.

custom UI elements for FOE/team detection

custom bitmaps required for image recognition

movement/model metadata used by the bot

Without this folder setup, the bot cannot detect:

✔ Team icons
✔ Mob icons
✔ Target HP bar
✔ Calendar icon
✔ Dungeon entry points

Therefore PCP will not function without these files.

# 🧩 **Overview**

This automation handles **PCP Cave Runs** in *Shark Sea*, coordinating:

* Auto-navigation
* Auto-teaming
* Party leader logic
* Cave entry / exit
* Target detection & attack cycles
* Dismiss team + return to Guild
* CSV signalling system between characters

The Leader script organizes the team and controls flow.
Each Member script listens for signals (CSV files) and follows Leader’s actions.

---

# 📁 **Folder Requirements**

Place scripts inside:

```
Bot/
PCP/
```

Ensure folders exist:

```
PCP/
    ├── itemdelete/
    ├── team.bmp
    ├── cave.csv + <CHAR>.csv (auto-generated)
    ├── specter_*.bmp
    └── Other images used in detection
```

---

# 🧙‍♂️ **1. Leader Script Setup**

**File:** *PCP Leader.txt* (Leader Script) 

### 🔧 Leader Settings

The Leader script must set:

```lua
Leader = "YES"
LeaderName = "<name of the leader>"
teamcount = 5
Team1 = "<name of member 1>"
Team2 = "<name of member 2>"
Team3 = "<name of member 3>"
Team4 = "<name of member 4>"
team = "<name of member 5>"
CHAR_NAME = "<YOUR CHARACTER NAME FOR THE SCRIPT>"
```

### 📝 Leader Responsibilities (Automatically Handled)

✔ Creates CSV signals for members
✔ Deletes CSVs after each stage
✔ Forms the team using FOE list
✔ Detects when team members join
✔ Enters cave and coordinates members
✔ Handles attacks using **inside2()**
✔ Dismisses team after boss kill
✔ Clears all residual files

### 🎯 Leader Flow (Internal)

1. Verify client
2. Move to Guild
3. Remove dice popup
4. Reset view
5. Feed pet
6. Team members (`PCP.leaderteam()`)
7. Raise **cave.csv** signal
8. Enter cave
9. Run combat/attack logic
10. Detect Boss death
11. Delete member files
12. Dismiss Team
13. Return to Guild
14. Loop again

---

# 👥 **2. Member Script Setup**

**Files:**

* PCP member 1.txt (<name of member 1>) 
* PCP member 2.txt (<name of member 1>) 
* PCP member 3.txt (<name of member 1>) 
* PCP member 4.txt (<name of member 1>) 

Each member script must set:

```lua
Leader = "NO"
LeaderName = "<YOUR LEADER NAME OF THE TEAM>"
team = "<their-number>"
CHAR_NAME = "<their name>"
```

Examples:

### Member 1 — <name of member 1>

```
CHAR_NAME = "<name of member 1>"
team = "1"
Leader = "NO"
```

Each value traced from 

### Member 2 — <name of member 2>

```
CHAR_NAME = "<name of member 2>"
team = "2"
Leader = "NO"
```

From 

### Member 3 — <name of member 3>

```
CHAR_NAME = "<name of member 3>"
team = "3"
Leader = "NO"
```

From 

### Member 4 — <name of member 4>

```
CHAR_NAME = "<name of member 4>"
team = "4"
Leader = "NO"
```

From 

### 🧠 Member Responsibilities (Automatic)

✔ Waits for file `PCP/<CHAR_NAME>.csv`
✔ Auto-accepts team invites
✔ Follows Leader into cave
✔ Runs attack logic using **inside1()**
✔ Deletes cave.csv when boss dies
✔ Exits cave
✔ Returns to Guild on its own
✔ Loop again

---

# 📌 **3. CSV Signalling System**

This is the heart of Leader–Member sync.

### Leader Writes:

```
PCP\<TeamX>.csv
PCP\cave.csv
PCP\<TeamX>cave.csv
```

### Members Wait For:

```
PCP\<CHAR_NAME>.csv
```

### Boss Death Handling:

Each member deletes cave.csv with delay based on member number:

| Team | Delay |
| ---- | ----- |
| 1    | 200ms |
| 2    | 400ms |
| 3    | 600ms |
| 4    | 800ms |
| 5    | 100ms |

This logic verified in `PCP.allattack()` and `PCP.allattackaoe()` from core file.


---

# ⚔️ **4. Attack Logic**

Two modes:

### **AOE Mode** (first 150 sec)

Used before reset timer expires.

### **Single Target Mode**

Used after reset timer.

Leader uses `inside2()`
Members use `inside1()`

Both reference detection:

* specter_fish
* specter_shark
* specter_servant
* Coral
* YeChun (Boss)

HP detection handled via:

```
PCP.Targethpzero()
```

---

# 🧭 **5. Cave Navigation Logic**

Movement guided by:

```
Boss.gettotargetspot_notstrict(targetX, targetY, tolerance)
Boss.isInToleranceArea()
```

Initial coordinates:

```
targetX = 270
targetY = -24
```

The same for both leader & members.

---

# 🛑 **6. Team Dismissal Logic**

When Boss YeChun dies:

* Delete cave.csv and character CSVs
* Leader executes `PCP.Dismissteam()`
* Leader teleports out
* Members wait for Guild signal

Detection is performed using:

```
PCP.YeChun_down()
PCP.team_dismissied()
```

---

# 🔁 **7. Automation Loop**

Every script ends with:

```lua
while true do
    PCP.start()
end
```

Runs continuously until manually stopped.

---

# 🧪 **8. Key Requirements for Stable Runs**

✔ All characters must be in **FOE list**
✔ All characters must use **matching team numbers**
✔ All images (.bmp) must be in correct folders
✔ Ensure no leftover CSV files block the run
✔ Maintain correct skill mapping:

Leader example:

```
attackskills = "F5" -- Works with Function keys 
aoe = "333222111" 
```

Member example:

```
attackskills = "321"
aoe = "332221"
```

---

# 🟢 **9. How to Start a Run**

### **Leader**

1. Start Leader script first
2. Wait for leader to reach Guild
3. Leader creates CSVs
4. Leader waits for members to appear in team

### **Members**

1. Start Member scripts
2. They will auto-join team once they see their CSV
3. Follow leader into cave
4. Attack > Boss dies → exit → Guild

---

# 🎉 **README Completed**
 
