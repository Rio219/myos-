#!/bin/bash
CACHE_FILE="/tmp/agy_quota_cache.txt"
NOW=$(date +%s)

# Fetch Quota asynchronously every 300 seconds
if [ ! -f "$CACHE_FILE" ] || [ $(($NOW - $(stat -c %Y "$CACHE_FILE"))) -gt 300 ]; then
    (
        QUOTA_LINE=$(/usr/bin/env agy --print "/usage" 2>/dev/null | grep -i "Gemini Models.*Five Hour")
        if [ -n "$QUOTA_LINE" ]; then
            QUOTA_PCT=$(echo "$QUOTA_LINE" | awk '{print $(NF-1)}')
            QUOTA_TIME=$(echo "$QUOTA_LINE" | awk '{print $NF}')
            if [ -n "$QUOTA_PCT" ] && [ -n "$QUOTA_TIME" ]; then
                echo "$QUOTA_PCT|$QUOTA_TIME" > "$CACHE_FILE"
            fi
        fi
    ) &
fi

QUOTA_PCT="N/A"
TIME_REMAINING=""

if [ -f "$CACHE_FILE" ]; then
    CACHED=$(cat "$CACHE_FILE")
    QUOTA_PCT=$(echo "$CACHED" | cut -d'|' -f1 | tr -d ' ')
    QUOTA_TIME=$(echo "$CACHED" | cut -d'|' -f2 | tr -d ' ')
    
    if [ -n "$QUOTA_TIME" ]; then
        RESET_EPOCH=$(date -d "$QUOTA_TIME" +%s 2>/dev/null)
        if [ -n "$RESET_EPOCH" ]; then
            DIFF=$((RESET_EPOCH - NOW))
            if [ "$DIFF" -gt 0 ]; then
                HOURS=$((DIFF / 3600))
                MINS=$(((DIFF % 3600) / 60))
                
                if [ "$HOURS" -gt 0 ]; then
                    TIME_REMAINING="${HOURS}h${MINS}m"
                else
                    TIME_REMAINING="${MINS}m"
                fi
            else
                TIME_REMAINING="Đã reset"
            fi
        fi
    fi
fi

if [ -n "$TIME_REMAINING" ]; then
    DISP_TEXT="🧠 ${QUOTA_PCT} (Reset: $TIME_REMAINING)"
else
    DISP_TEXT="🧠 ${QUOTA_PCT}"
fi

# 1. Fetch transcript usage instantly for Tooltip
LATEST_TRANSCRIPT=$(ls -t /home/riohoang/.gemini/antigravity-cli/brain/*/.system_generated/logs/transcript.jsonl 2>/dev/null | head -n 1)
TOTAL=0
IN=0
OUT=0
TEXT_TOTAL="0"

if [ -n "$LATEST_TRANSCRIPT" ]; then
    TOTAL=$(jq -c 'select(.type == "PLANNER_RESPONSE") | {input: (.input_tokens // 0), cache: (.cache_read_tokens // 0), output: (.output_tokens // 0)}' "$LATEST_TRANSCRIPT" | jq -s 'map(.input + .cache + .output) | add')
    IN=$(jq -c 'select(.type == "PLANNER_RESPONSE") | {input: (.input_tokens // 0)}' "$LATEST_TRANSCRIPT" | jq -s 'map(.input) | add')
    OUT=$(jq -c 'select(.type == "PLANNER_RESPONSE") | {output: (.output_tokens // 0)}' "$LATEST_TRANSCRIPT" | jq -s 'map(.output) | add')
fi

if [ -n "$TOTAL" ] && [ "$TOTAL" != "null" ] && [ "$TOTAL" -gt 0 ]; then
    TEXT_TOTAL=$(awk -v t="$TOTAL" 'BEGIN { if (t >= 1000000) printf "%.1fM", t/1000000; else if (t >= 1000) printf "%.1fK", t/1000; else print t }')
fi

echo "{\"text\": \"$DISP_TEXT\", \"tooltip\": \"Token phiên này:\\n- Input: $IN\\n- Output: $OUT\\n- Tổng: $TEXT_TOTAL ($TOTAL)\\n\\nHạn mức 5 giờ (Quota): $QUOTA_PCT\\nThời gian reset: $QUOTA_TIME\"}"
