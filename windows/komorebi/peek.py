import sys
import time
import subprocess
import os
from pathlib import Path

# --- CONFIGURATION ---
TIMEOUT_SECONDS = 1.5 
# File to track when the bar should hide
STATE_FILE = Path(os.environ["TEMP"]) / "yasb_peek_state.txt"
# Path to the temporary watcher script
WATCHER_SCRIPT = Path(os.environ["TEMP"]) / "yasb_watcher.py"

def main():
    # 1. FORCE SHOW IMMEDIATELY
    # We don't care if it's already shown; this ensures it is visible.
    # We run this BEFORE the command so the UI feels responsive.
    subprocess.Popen(["yasbc", "show-bar"], shell=True)

    # 2. RUN THE USER'S COMMAND
    if len(sys.argv) > 1:
        try:
            subprocess.run(sys.argv[1:], shell=True)
        except Exception as e:
            print(f"Error executing command: {e}")

    # 3. UPDATE THE DEADLINE
    # We set the "hide time" to be X seconds from now.
    new_deadline = time.time() + TIMEOUT_SECONDS
    STATE_FILE.write_text(str(new_deadline))

    # 4. SPAWN THE WATCHER
    # This watcher waits for the timeout, then checks if the deadline has passed.
    # If the user kept typing, the deadline in the file will be in the future,
    # and this specific watcher instance will die peacefully without hiding the bar.
    watcher_code = f"""
import time
import subprocess
from pathlib import Path

state_file = Path(r'{STATE_FILE}')

# Wait for the timeout duration
time.sleep({TIMEOUT_SECONDS} + 0.1)

try:
    if state_file.exists():
        deadline = float(state_file.read_text().strip())
        
        # KEY CHANGE: Only run hide-bar if we are past the deadline.
        # Since 'hide-bar' is safe to run even if hidden, we don't need complex checks.
        if time.time() > deadline:
            subprocess.run(["yasbc", "hide-bar"], shell=True)
except:
    pass
"""
    # Write and run the watcher
    try:
        WATCHER_SCRIPT.write_text(watcher_code)
        # pythonw runs without a console window
        subprocess.Popen(["pythonw", str(WATCHER_SCRIPT)], shell=True)
    except Exception as e:
        print(f"Failed to spawn watcher: {e}")

if __name__ == "__main__":
    main()
