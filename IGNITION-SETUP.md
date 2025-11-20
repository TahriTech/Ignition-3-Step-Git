# Ignition Setup Guide - Where to Add the Commit Code

This guide shows you **exactly where** to add the Git commit code in Ignition Gateway.

---

## 🎯 Three Ways to Use Git from Ignition

### Option 1: Auto-Commit When Publishing Projects (RECOMMENDED)

**When:** Every time you publish a project in Designer  
**Where:** Gateway Events  

#### Step-by-Step:

1. **Open Ignition Gateway webpage** (usually http://localhost:8088)

2. **Login** with admin credentials

3. **Navigate to:**
   ```
   Config → System → Events
   ```

4. **Click "Add Project Published Event"**

5. **Paste this script** into the editor:

   **Windows:**
   ```python
   import system
   
   # Get project info
   projectName = projectPublishedEvent.getProjectName()
   userName = projectPublishedEvent.getActorName()
   
   # Create message
   message = "Published: %s (by %s)" % (projectName, userName)
   
   # Save to Git
   system.util.execute(["commit-changes-windows.bat", message])
   ```

   **Linux/Mac:**
   ```python
   import system
   
   # Get project info
   projectName = projectPublishedEvent.getProjectName()
   userName = projectPublishedEvent.getActorName()
   
   # Create message
   message = "Published: %s (by %s)" % (projectName, userName)
   
   # Save to Git
   system.util.execute(["./commit-changes-linux-mac.sh", message])
   ```

   **Cross-Platform (detects OS automatically):**
   ```python
   import system
   
   # Detect OS
   isWindows = system.util.getSystemFlags() & system.util.SYSTEM_FLAG_WINDOWS
   script = "commit-changes-windows.bat" if isWindows else "./commit-changes-linux-mac.sh"
   
   # Get project info
   projectName = projectPublishedEvent.getProjectName()
   userName = projectPublishedEvent.getActorName()
   
   # Save to Git
   message = "Published: %s (by %s)" % (projectName, userName)
   system.util.execute([script, message])
   ```

6. **Save** the event

7. **Test it:** Publish any project in Designer and check the log file at `data/git-commits.log`

---

### Option 2: Manual "Save to Git" Button in Vision

**When:** Click a button in your Vision HMI  
**Where:** Vision window → Button component  

#### Step-by-Step:

1. **Open your Vision project** in Designer

2. **Add a Button** component to your window

3. **Right-click the button** → Scripting → `actionPerformed`

4. **Paste this script:**

   **Windows:**
   ```python
   import system
   
   # Save to Git
   result = system.util.execute(["commit-changes-windows.bat", "Manual save from HMI"])
   
   # Show result
   if result == 0:
       system.gui.messageBox("Saved to Git successfully!")
   else:
       system.gui.warningBox("Failed to save - check logs")
   ```

   **Linux/Mac:**
   ```python
   import system
   
   # Save to Git
   result = system.util.execute(["./commit-changes-linux-mac.sh", "Manual save from HMI"])
   
   # Show result
   if result == 0:
       system.gui.messageBox("Saved to Git successfully!")
   else:
       system.gui.warningBox("Failed to save - check logs")
   ```

5. **Save** and test the button

---

### Option 3: Manual "Save to Git" Button in Perspective

**When:** Click a button in your Perspective view  
**Where:** Perspective view → Button component  

#### Step-by-Step:

1. **Open your Perspective view** in Designer

2. **Add a Button** component

3. **Configure the button:**
   - Click on the button
   - In the Component Events panel, add an `onClick` event
   - Set Event Type: **Script**

4. **Paste this script:**

   **Windows:**
   ```python
   import system
   
   # Save to Git
   result = system.util.execute(["commit-changes-windows.bat", "Manual save from Perspective"])
   
   # Show notification
   if result == 0:
       system.perspective.print("Saved to Git!")
   else:
       system.perspective.print("Failed to save - check logs")
   ```

   **Linux/Mac:**
   ```python
   import system
   
   # Save to Git
   result = system.util.execute(["./commit-changes-linux-mac.sh", "Manual save from Perspective"])
   
   # Show notification
   if result == 0:
       system.perspective.print("Saved to Git!")
   else:
       system.perspective.print("Failed to save - check logs")
   ```

---

### Option 4: Scheduled Automatic Backups

**When:** Every night at 2 AM (or your chosen time)  
**Where:** Gateway Scheduled Scripts  

#### Step-by-Step:

1. **Open Ignition Gateway webpage**

2. **Navigate to:**
   ```
   Config → System → Schedule
   ```

3. **Click "Add Scheduled Script"**

4. **Set the schedule:**
   - **Name:** Git Daily Backup
   - **Schedule:** `0 0 2 ? * * *` (every day at 2 AM)
   - Or use the schedule builder for custom times

5. **Paste this script:**

   **Windows:**
   ```python
   import system
   
   # Create timestamp message
   today = system.date.format(system.date.now(), "yyyy-MM-dd HH:mm")
   message = "Daily backup: %s" % today
   
   # Save to Git
   system.util.execute(["commit-changes-windows.bat", message])
   ```

   **Linux/Mac:**
   ```python
   import system
   
   # Create timestamp message
   today = system.date.format(system.date.now(), "yyyy-MM-dd HH:mm")
   message = "Daily backup: %s" % today
   
   # Save to Git
   system.util.execute(["./commit-changes-linux-mac.sh", message])
   ```

6. **Save** the scheduled script

7. **Enable** the schedule

---

## 🔍 How to Check if It's Working

### Check the Log File

The commit script logs everything to:
```
data/git-commits.log
```

**Windows:**
```cmd
type "C:\Program Files\Inductive Automation\Ignition\data\git-commits.log"
```

**Linux/Mac:**
```bash
tail -f /usr/local/bin/ignition/data/git-commits.log
```

You should see entries like:
```
[2025-11-20 14:30:15] Saving: Published: MyProject (by admin)
[2025-11-20 14:30:15] SUCCESS: Changes saved to Git
```

### Check Git History

Open terminal in Ignition folder and run:
```bash
git log --oneline
```

You should see your commits listed.

---

## 🐛 Troubleshooting

### Script Returns Error Code 1

**Check:**
1. Git is installed: `git --version`
2. Git is initialized: Look for `.git` folder in Ignition root
3. Scripts are in the right location (Ignition root folder)

### Nothing Happens When Button Clicked

**Check:**
1. Script console in Gateway logs (Config → System → Logging)
2. Make sure script file name matches exactly
3. On Linux/Mac, make script executable: `chmod +x commit-changes-linux-mac.sh`

### "Permission Denied" Error

**Windows:**
- Run Ignition Gateway service as Administrator (or user with write permissions)

**Linux/Mac:**
- Make script executable: `chmod +x commit-changes-linux-mac.sh`
- Check Ignition service user has write permissions

---

## 📝 Script Reference

### Basic Syntax

**Windows:**
```python
system.util.execute(["commit-changes-windows.bat", "Your message here"])
```

**Linux/Mac:**
```python
system.util.execute(["./commit-changes-linux-mac.sh", "Your message here"])
```

### With Error Handling

```python
import system

script = "commit-changes-windows.bat"  # or "./commit-changes-linux-mac.sh"
message = "My commit message"

result = system.util.execute([script, message])

if result == 0:
    # Success
    print("Saved to Git")
else:
    # Failed
    print("Save failed - check logs")
```

### Get Username in Message

```python
import system

username = system.security.getUsername()
message = "Changes by %s" % username

system.util.execute(["commit-changes-windows.bat", message])
```

---

## 💡 Tips

1. **Start with Gateway Events** - Easiest way to get automatic tracking
2. **Add a manual button** - Good for important milestones
3. **Use scheduled backups** - Safety net if you forget to commit
4. **Check the log file** - Always verify it's working
5. **Descriptive messages** - Future you will thank present you!

---

**Questions? Check `data/git-commits.log` for detailed information about what's happening.**
