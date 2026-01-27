import sys
import time
import subprocess
import os
from pathlib import Path
from datetime import datetime

# --- CONFIGURATION ---
TIMEOUT_SECONDS = 1.5 
STATE_FILE = Path(os.environ["TEMP"]) / "yasb_peek_state.txt"
WATCHER_SCRIPT = Path(os.environ["TEMP"]) / "yasb_watcher.py"
LOG_FILE = Path(os.environ["TEMP"]) / "yasb_peek.log"

def log_it(log_string: str):
    try:
        with open(LOG_FILE, "a") as f:
            f.write(f"[{datetime.now().strftime('%H:%M:%S.%f')[:-3]}] {log_string}\n")
    except:
        pass

def get_pythonw_path():
    """
    Finds pythonw.exe based on the current python interpreter.
    """
    current_python = sys.executable
    directory = os.path.dirname(current_python)
    pythonw = os.path.join(directory, "pythonw.exe")
    if os.path.exists(pythonw):
        return pythonw
    return "pythonw"

def main():
    # 1. HANDLE TOGGLE (Alt+B)
    if len(sys.argv) > 1 and sys.argv[1] == "toggle":
        handle_toggle()
        return

    # 2. STANDARD PEEK BEHAVIOR
    # Force show immediately
    subprocess.Popen(["yasbc", "show-bar"], shell=True)

    # Run the user command
    if len(sys.argv) > 1:
        try:
            subprocess.run(sys.argv[1:], shell=True)
        except Exception as e:
            log_it(f"Command Error: {e}")

    # 3. BREAK MANUAL LOCK & SET TIMEOUT
    # We overwrite any "MANUAL" state with a timestamp.
    new_deadline = time.time() + TIMEOUT_SECONDS
    try:
        STATE_FILE.write_text(str(new_deadline))
    except Exception as e:
        log_it(f"State Write Error: {e}")

    # 4. SPAWN WATCHER
    spawn_watcher()


def handle_toggle():
    """
    Toggles between HIDDEN and MANUAL (Persistent).
    """
    # If the file is missing, we assume the bar is ON.
    current_state = "MANUAL"
    
    if STATE_FILE.exists():
        try:
            content = STATE_FILE.read_text().strip()
            # If the file contains anything other than "MANUAL" (e.g. timestamp or "0"),
            # we consider the bar to be in a non-persistent state (Hidden or Peeking).
            if content != "MANUAL":
                current_state = "HIDDEN"
        except:
            pass

    if current_state == "MANUAL":
        # Switch to HIDDEN
        subprocess.run(["yasbc", "hide-bar"], shell=True)
        # Write 0 so any running watchers expire immediately
        STATE_FILE.write_text("0")
    else:
        # Switch to MANUAL
        subprocess.run(["yasbc", "show-bar"], shell=True)
        STATE_FILE.write_text("MANUAL")

def spawn_watcher():
    pythonw = get_pythonw_path()
    
    watcher_code = f"""
import time
import subprocess
import os
from pathlib import Path
from datetime import datetime

state_file = Path(r'{STATE_FILE}')
log_file = Path(r'{LOG_FILE}')

def w_log(msg):
    try:
        with open(log_file, "a") as f:
            f.write(f"[WATCHER] [{{datetime.now().strftime('%H:%M:%S.%f')[:-3]}}] {{msg}}\\n")
    except:
        pass

# Sleep first
time.sleep({TIMEOUT_SECONDS} + 0.1)

try:
    if state_file.exists():
        content = state_file.read_text().strip()
        
        # If MANUAL, abort
        if content == "MANUAL":
            exit()
        
        # Parse Deadline
        try:
            deadline = float(content)
            if time.time() > deadline:
                # Hide the bar
                subprocess.run(["yasbc", "hide-bar"], shell=True)
        except ValueError:
            pass
except Exception as e:
    w_log(f"Watcher Crash: {{e}}")
"""
    try:
        WATCHER_SCRIPT.write_text(watcher_code)
        
        # DETACHED_PROCESS = 0x00000008 
        # CREATE_NEW_PROCESS_GROUP = 0x00000200
        creation_flags = 0x00000008 | 0x00000200
        
        subprocess.Popen([pythonw, str(WATCHER_SCRIPT)], creationflags=creation_flags)
        
    except Exception as e:
        log_it(f"Failed to spawn watcher: {e}")

if __name__ == "__main__":
    main()
