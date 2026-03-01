#!/bin/bash
# fleet watch · Live session tail for a named agent
# Polls the agent gateway session history and shows new messages as they arrive
# Usage: fleet watch <agent> [--interval <seconds>]

cmd_watch() {
    local agent="" interval=3

    if [[ $# -lt 1 ]]; then
        echo "  Usage: fleet watch <agent> [--interval <seconds>]"
        echo "  Example: fleet watch coder"
        return 1
    fi

    agent="$1"; shift

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --interval|-i) interval="${2:-3}"; shift 2 ;;
            *) shift ;;
        esac
    done

    local port token role session_key
    port="$(_agent_config "$agent" "port")"
    token="$(_agent_config "$agent" "token")"
    role="$(_agent_config "$agent" "role")"

    if [ -z "$port" ]; then
        out_fail "Agent '$agent' not found in fleet config."
        return 1
    fi

    # Coordinator runs the main session; employees get isolated fleet sessions
    if [ "$role" = "coordinator" ]; then
        session_key="main"
    else
        session_key="fleet-$agent"
    fi

    out_header "Watching $agent"
    echo -e "  ${CLR_DIM}Session: ${session_key} · polling every ${interval}s · Ctrl+C to stop${CLR_RESET}"
    echo ""

    python3 -u - "$port" "$token" "$agent" "$interval" "$session_key" <<'PY'
import subprocess, sys, json, time, signal

port        = sys.argv[1]
token       = sys.argv[2]
agent       = sys.argv[3]
interval    = float(sys.argv[4])
session_key = sys.argv[5]

G = "\033[32m"; R = "\033[31m"; Y = "\033[33m"; D = "\033[2m"
BOLD = "\033[1m"; C = "\033[36m"; N = "\033[0m"

seen_ids = set()

def fetch_history(limit=30):
    payload = json.dumps({
        "tool": "sessions_history",
        "args": {"sessionKey": session_key, "limit": limit},
    })
    try:
        r = subprocess.run(
            ["curl", "-s", "--max-time", "5",
             f"http://127.0.0.1:{port}/tools/invoke",
             "-H", f"Authorization: Bearer {token}",
             "-H", "Content-Type: application/json",
             "-d", payload],
            capture_output=True, text=True
        )
        data = json.loads(r.stdout)
        if not data.get("ok"):
            return []

        result = data.get("result", {})

        # tools/invoke wraps the result in content[0].text as a JSON string
        if isinstance(result, dict) and "content" in result:
            content_blocks = result.get("content", [])
            for block in content_blocks:
                if isinstance(block, dict) and block.get("type") == "text":
                    try:
                        inner = json.loads(block["text"])
                        return inner.get("messages", [])
                    except Exception:
                        pass
            return []

        # Fallback: result is already the dict we want
        if isinstance(result, dict):
            return result.get("messages", [])
        if isinstance(result, list):
            return result
    except Exception:
        pass
    return []

def fmt_ts(ts):
    """Convert int ms epoch or ISO string to HH:MM readable."""
    if isinstance(ts, (int, float)):
        from datetime import datetime, timezone
        dt = datetime.fromtimestamp(ts / 1000, tz=timezone.utc)
        return dt.strftime("%H:%M UTC")
    if isinstance(ts, str):
        return ts[:16].replace("T", " ")
    return ""

def extract_text(content):
    if isinstance(content, str):
        return content
    if isinstance(content, list):
        parts = []
        for block in content:
            if not isinstance(block, dict):
                continue
            if block.get("type") == "text":
                parts.append(block.get("text", ""))
        return " ".join(parts)
    return str(content)

def print_message(msg):
    role    = msg.get("role", "?")
    content = extract_text(msg.get("content", ""))
    ts      = fmt_ts(msg.get("timestamp", ""))
    model   = msg.get("model", "")

    if role == "user":
        color = C
        label = "you"
    elif role == "assistant":
        color = G
        label = f"{agent}" + (f" ({model.split('/')[-1][:16]})" if model else "")
    else:
        color = D
        label = role

    preview = content.strip()[:300]
    if len(content.strip()) > 300:
        preview += "…"

    print(f"  {color}{BOLD}{label}{N}  {D}{ts}{N}")
    for line in preview.splitlines():
        print(f"  {line}")
    print()

print(f"  {D}Connecting to {agent} session...{N}")

# Index-based dedup: track how many messages we have seen
seen_count = 0

# Initial load
messages = fetch_history(15)
if not messages:
    print(f"  {D}No messages yet. Waiting for activity...{N}")
else:
    seen_count = len(messages)
    print(f"  {D}Last {seen_count} message(s):{N}\n")
    for m in messages:
        print_message(m)

# Poll loop
try:
    while True:
        time.sleep(interval)
        fresh = fetch_history(50)
        if len(fresh) > seen_count:
            new_msgs = fresh[seen_count:]
            seen_count = len(fresh)
            for m in new_msgs:
                print_message(m)
except KeyboardInterrupt:
    print(f"\n  {D}Watch stopped.{N}")
PY
}
