# Ignition 8.3 Easy Git Version Control 

**Version 1.0.0** | Last Updated: November 20, 2025

> **📝 Customize This:** Feel free to modify this README to match your organization's needs!

**The simplest way to track changes in Ignition 8.3**

---

## 🎯 It's This Simple

![Drag and drop files to Ignition folder](./docs/Ignition-3-Step-Git_CopyPaste.png)

**Three steps:** Copy files → Run 4 commands → Done!

![What Git tracks and ignores](./docs/Ignition-3-Step-Git-Ignored-2.png)

✅ **Tracked:** Projects, Gateway config, Settings  
❌ **Ignored:** Databases, Backups, Logs

---

## 📦 What You're Copying

**Required:**
- `.gitignore` - Tells Git what to track/ignore

**Pick ONE script** (they all do the same thing):
- `commit-changes-windows.bat` - For Windows
- `commit-changes-linux-mac.sh` - For Linux/Mac  
- `commit-changes.py` - Works everywhere (needs Python)

> **Don't be scared of the .bat and .sh files!** They're optional helper scripts that save you from typing Git commands manually. All they do is run `git add` and `git commit` for you. You can open them in a text editor to see exactly what they do - they're well commented in plain English.

---

## 🚀 Setup (5 Minutes)

### 1. Copy Files

Copy `.gitignore` + your chosen script to your Ignition folder:
- **Windows:** `C:\Program Files\Inductive Automation\Ignition\`
- **Linux:** `/usr/local/bin/ignition/`
- **Mac:** `/usr/local/ignition/`

Put them in the **root folder** (same level as the `data/` folder).

### 2. Install Git (if needed)

- **Windows:** https://git-scm.com/download/windows
- **Linux:** `sudo apt-get install git`
- **Mac:** `brew install git`

### 3. Initialize Git

Open a terminal in your Ignition folder and run:

```bash
git init
git config user.name "Your Name"
git config user.email "your.email@company.com"
git add .
git commit -m "Initial Ignition setup"
```

### 4. Test It

**Windows:**
```cmd
commit-changes-windows.bat "Test commit"
```

**Linux/Mac:**
```bash
chmod +x commit-changes-linux-mac.sh
./commit-changes-linux-mac.sh "Test commit"
```

**Python:**
```bash
python commit-changes.py "Test commit"
```

You should see: `SUCCESS: Changes saved to Git!`

---

## 🔧 Use from Ignition (Optional but Recommended)

Once you've done the setup above, you can automate Git saves from inside Ignition.

### Auto-Save When Publishing Projects

**Where:** Gateway webpage → Config → System → Events → Add Project Published Event

**What it does:** Every time you publish a project in Designer, it automatically saves to Git with a message like "Published: MyProject (by admin)"

**Simple version (pick your OS):**

**Windows:**
```python
import system
projectName = projectPublishedEvent.getProjectName()
userName = projectPublishedEvent.getActorName()
message = "Published: %s (by %s)" % (projectName, userName)
system.util.execute(["commit-changes-windows.bat", message])
```

**Linux/Mac:**
```python
import system
projectName = projectPublishedEvent.getProjectName()
userName = projectPublishedEvent.getActorName()
message = "Published: %s (by %s)" % (projectName, userName)
system.util.execute(["./commit-changes-linux-mac.sh", message])
```

**Auto-detect OS:**
```python
import system

isWindows = system.util.getSystemFlags() & system.util.SYSTEM_FLAG_WINDOWS
script = ["commit-changes-windows.bat"] if isWindows else ["./commit-changes-linux-mac.sh"]

projectName = projectPublishedEvent.getProjectName()
userName = projectPublishedEvent.getActorName()
message = "Published: %s (by %s)" % (projectName, userName)

system.util.execute(script + [message])
```

---

### Add a "Save to Git" Button

**Vision:** Button → Scripting → `actionPerformed`  
**Perspective:** Button → Component Events → `onClick` → Script

```python
import system

# Change this to match your script
result = system.util.execute(["commit-changes-windows.bat", "Manual save"])

if result == 0:
    print("Saved to Git!")
else:
    print("Failed - check logs")
```

---

### Schedule Daily Backups

**Where:** Gateway → Config → System → Schedule → Add Scheduled Script  
**When:** Set schedule to `0 0 2 ? * * *` (2 AM daily)

```python
import system

today = system.date.format(system.date.now(), "yyyy-MM-dd HH:mm")
message = "Daily backup: %s" % today

system.util.execute(["commit-changes-windows.bat", message])  # Change to your script
```

---

## ✅ Verify It's Working

**Check the log:** `data/git-commits.log`

```bash
# Windows
type "data\git-commits.log"

# Linux/Mac  
tail data/git-commits.log
```

**Check Git history:**

```bash
git log --oneline
```

---

## 🐛 Troubleshooting

**"Git not found"**  
→ Install Git (step 2 above)

**"Not a git repository"**  
→ Run `git init` (step 3 above)

**"Permission denied" (Linux/Mac)**  
→ Run `chmod +x commit-changes-linux-mac.sh`

**Nothing happens from Ignition**  
→ Check Gateway logs (Config → System → Logging)  
→ Verify script filename matches exactly

---

## 📚 What Gets Tracked

✅ **Saved to Git:**
- Projects (`data/projects/`)
- Gateway config (`data/gateway.xml`)
- Settings (`data/ignition.conf`)

❌ **Ignored:**
- Databases (`data/db/`)
- Backups (`*.gwbk`)
- Logs and temp files
- Certificates and licenses

---

## 🔄 Useful Git Commands

```bash
# View history
git log --oneline

# See what changed
git status

# Restore old version of a file
git checkout <commit-hash> -- data/projects/MyProject

# Push to GitHub/GitLab
git remote add origin https://github.com/yourcompany/ignition.git
git push -u origin main
```

---

## 💡 How It Works

The `.gitignore` file in your Ignition root folder tells Git: "Track everything in `data/` except the stuff in `data/db/`". The scripts just run `git add data/` and `git commit` for you so you don't have to type those commands manually. Simple!

---

**Questions?** Check `data/git-commits.log` to see what's happening.
