#!/bin/bash
###############################################################################
# commit-changes-linux-mac.sh - Save Ignition changes to Git (LINUX/MAC ONLY)
###############################################################################
#
# What this does:
#   1. Saves changes in the data/ folder to Git
#   2. Logs everything to data/git-commits.log
#   3. Returns 0 if successful, 1 if failed
#
# Place this file in the ROOT of your Ignition installation folder
# Example: /usr/local/bin/ignition/commit-changes-linux-mac.sh
#
# Usage from command line:
#   ./commit-changes-linux-mac.sh "Your message here"
#
# Usage from Ignition Gateway Script:
#   system.util.execute(["./commit-changes-linux-mac.sh", "Your message"])
#
###############################################################################

# Go to the folder where this script is located (Ignition root)
cd "$(dirname "$0")" || exit 1

# Get the message (or create one with timestamp if not provided)
if [ -z "$1" ]; then
    MESSAGE="Auto save $(date '+%Y-%m-%d %H:%M:%S')"
else
    MESSAGE="$1"
fi

# Create log file if needed
LOG="data/git-commits.log"
if [ ! -f "$LOG" ]; then
    echo "Git Commit Log" > "$LOG"
    echo "==============" >> "$LOG"
fi

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"
}

log "Saving: $MESSAGE"

# Check if Git is installed
if ! command -v git &> /dev/null; then
    log "ERROR: Git not found. Install Git first."
    echo "ERROR: Git not found. Install Git first."
    exit 1
fi

# Check if Git is set up
if [ ! -d ".git" ]; then
    log "ERROR: Not a Git repo. Run 'git init' first."
    echo "ERROR: Not a Git repo. Run 'git init' first."
    exit 1
fi

# Add all changes in data/ folder (relative path)
git add data/ >> "$LOG" 2>&1

# Check if anything actually changed
if git diff --cached --quiet; then
    log "INFO: Nothing changed, nothing to save"
    echo "INFO: Nothing changed, nothing to save"
    exit 0
fi

# Save the changes
if git commit -m "$MESSAGE" >> "$LOG" 2>&1; then
    log "SUCCESS: Changes saved to Git"
    echo "SUCCESS: Changes saved to Git"
else
    log "ERROR: Save failed"
    echo "ERROR: Save failed"
    exit 1
fi

# Optional: Uncomment these lines to auto-push to GitHub/GitLab
# git push >> "$LOG" 2>&1

exit 0
