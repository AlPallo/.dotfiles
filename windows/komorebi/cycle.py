import sys
import json
import subprocess

def main():
    if len(sys.argv) < 2:
        return

    direction = sys.argv[1]  # "next" or "previous"

    try:
        # 1. Fetch current state from komorebic
        # We use check_output to get the JSON string
        output = subprocess.check_output(["komorebic", "state"], encoding="utf-8")
        state = json.loads(output)

        # 2. Drill down to find the active workspace index
        # Hierarchy: State -> Monitors -> Focused Monitor -> Workspaces -> Focused Index
        monitors = state.get("monitors", {}).get("elements", [])
        focused_monitor_idx = state.get("monitors", {}).get("focused", 0)
        
        current_monitor = monitors[focused_monitor_idx]
        workspaces = current_monitor.get("workspaces", {}).get("elements", [])
        current_idx = current_monitor.get("workspaces", {}).get("focused", 0)
        total_workspaces = len(workspaces)

        # 3. Determine if we should move
        should_move = False

        if direction == "next":
            # Only move if we are NOT at the last index
            if current_idx < total_workspaces - 1:
                should_move = True
                
        elif direction == "previous":
            # Only move if we are NOT at the first index (0)
            if current_idx > 0:
                should_move = True

        # 4. Execute command if valid
        if should_move:
            subprocess.Popen(["komorebic", "cycle-workspace", direction], shell=True)

    except Exception as e:
        # If komorebic is not running or JSON fails, fail silently
        pass

if __name__ == "__main__":
    main()
