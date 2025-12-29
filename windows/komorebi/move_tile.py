import subprocess
import sys
import json

if len(sys.argv) != 2:
    print(f"Usage: {sys.argv[0]} <previous|next>")
    sys.exit(1)

if sys.argv[1] == "previous":
    target_delta = -1
elif sys.argv[1] == "next":
    target_delta = 1
else:
    print(f"Usage: {sys.argv[0]} <previous|next>")
    sys.exit(1)

command = ["komorebic", "state"]

try:
    result = subprocess.run(command, capture_output=True, text=True, check=True)
    command_output = result.stdout
    komorebic_state = json.loads(command_output)
except subprocess.CalledProcessError as e:
    print(f"Command failed with return code {e.returncode}")
    print(f"Error output (stderr): {e.stderr}")
    sys.exit(1)
except FileNotFoundError:
    print("Error: 'komorebic' not found. Check if it is installed and in your PATH.")
    sys.exit(1)
except json.JSONDecodeError as e:
    print(f"Failed to parse komorebic state JSON: {e}")
    sys.exit(1)
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)

if len(komorebic_state["monitors"]["elements"]) != 1:
    print("Multi monitor displays not supported")
    sys.exit(1)

total_ws = len(komorebic_state["monitors"]["elements"][0]["workspaces"]["elements"])
total_ws_idx = total_ws - 1
current_ws_idx = komorebic_state["monitors"]["elements"][0]["workspaces"]["focused"]
target_ws_idx = current_ws_idx + target_delta
if target_ws_idx > total_ws_idx:
    target_ws_idx = 0
if target_ws_idx < 0:
    target_ws_idx = total_ws_idx


mv_command = ["komorebic", "move-to-workspace", str(target_ws_idx)]

try:
    subprocess.run(mv_command, text=True, check=True)
except subprocess.CalledProcessError as e:
    print(f"Command failed with return code {e.returncode}")
    print(f"Error output (stderr): {e.stderr}")
    sys.exit(1)
except FileNotFoundError:
    print("Error: 'komorebic' not found. Check if it is installed and in your PATH.")
    sys.exit(1)
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
