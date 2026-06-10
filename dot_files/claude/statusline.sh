#!/bin/bash

# =============================================================================
# Input Parsing
# =============================================================================

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // ""')
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
context_percentage=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
five_h_percentage=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0')
five_h_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // 0')
seven_d_percentage=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // 0')
seven_d_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // 0')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')

# =============================================================================
# Colors (Catppuccin Mocha palette, foreground only — no backgrounds)
# =============================================================================

reset=$'\033[0m'

fg_sapphire=$'\033[38;2;116;199;236m'
fg_sky=$'\033[38;2;137;220;235m'
fg_green=$'\033[38;2;166;227;161m'
fg_yellow=$'\033[38;2;249;226;175m'
fg_peach=$'\033[38;2;250;179;135m'
fg_maroon=$'\033[38;2;235;160;172m'
fg_red=$'\033[38;2;243;139;168m'
fg_blue=$'\033[38;2;137;180;250m'
fg_dim=$'\033[38;2;88;91;112m'    # #585b70 (surface2) - separator

sep="${fg_dim} | ${reset}"

# =============================================================================
# Data Processing
# =============================================================================

# Current time
current_time=$(date +"%H:%M")

# Git information
git_branch_name=""
git_status_str=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    git_branch_name=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || \
                      git -C "$cwd" rev-parse --short HEAD 2>/dev/null)

    if [ -n "$git_branch_name" ]; then
        git_porcelain=$(git -C "$cwd" status --porcelain 2>/dev/null)
        if [ -n "$git_porcelain" ]; then
            git_status_str="${git_status_str}*"
        fi

        ahead_behind=$(git -C "$cwd" rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)
        if [ -n "$ahead_behind" ]; then
            ahead=$(echo "$ahead_behind" | awk '{print $1}')
            behind=$(echo "$ahead_behind" | awk '{print $2}')
            [ "$behind" -gt 0 ] 2>/dev/null && git_status_str="${git_status_str}-${behind}"
            [ "$ahead" -gt 0 ] 2>/dev/null && git_status_str="${git_status_str}+${ahead}"
        fi
    fi
fi

# Context window percentage
if [ "$context_percentage" != "null" ]; then
    context_display=$(printf "%.0f%%" "$context_percentage")
else
    context_display="--"
fi

# Five-hour rate limit
if [ "$five_h_percentage" != "null" ]; then
    five_h_pct_display=$(printf "%.0f%%" "$five_h_percentage")
else
    five_h_pct_display="--"
fi

five_h_resets_display=""
if [ "$five_h_resets" != "0" ] && [ "$five_h_resets" != "" ]; then
    five_h_resets_display=$(date -r "$five_h_resets" +"%H:%M")
fi

# Seven-day rate limit
if [ "$seven_d_percentage" != "null" ]; then
    seven_d_pct_display=$(printf "%.0f%%" "$seven_d_percentage")
else
    seven_d_pct_display="--"
fi

seven_d_reset_display=""
if [ "$seven_d_resets" != "0" ] && [ "$seven_d_resets" != "" ]; then
    reset_date=$(date -r "$seven_d_resets" +"%Y-%m-%d")
    today=$(date +"%Y-%m-%d")
    if [ "$reset_date" = "$today" ]; then
        seven_d_reset_display="→$(date -r "$seven_d_resets" +"%H:%M")"
    else
        day_num=$(date -r "$seven_d_resets" +"%u")
        case "$day_num" in
            1) seven_d_reset_display="M" ;;
            2) seven_d_reset_display="T" ;;
            3) seven_d_reset_display="W" ;;
            4) seven_d_reset_display="R" ;;
            5) seven_d_reset_display="F" ;;
            6) seven_d_reset_display="S" ;;
            7) seven_d_reset_display="" ;;
        esac
    fi
fi

# Cost
if [ "$cost" != "0" ] && [ "$cost" != "null" ]; then
    cost_display=$(printf "$%.2f" "$cost")
else
    cost_display="\$0.00"
fi

# =============================================================================
# Output — single line, no trailing newline
# =============================================================================

output=""

# Git (only if in a repo)
if [ -n "$git_branch_name" ]; then
    output="${output}${fg_sapphire}${git_branch_name}${git_status_str}${reset}"
    output="${output}${sep}"
fi

# Model
output="${output}${fg_green}${model}${reset}"
output="${output}${sep}"

# Context
output="${output}${fg_yellow}ctx ${context_display}${reset}"
output="${output}${sep}"

# 5h rate limit
if [ -n "$five_h_resets_display" ]; then
    output="${output}${fg_peach}5h ${five_h_pct_display} ->${five_h_resets_display}${reset}"
else
    output="${output}${fg_peach}5h ${five_h_pct_display}${reset}"
fi
output="${output}${sep}"

# 7d rate limit
if [ -n "$seven_d_reset_display" ]; then
    output="${output}${fg_maroon}7d ${seven_d_pct_display} ${seven_d_reset_display}${reset}"
else
    output="${output}${fg_maroon}7d ${seven_d_pct_display}${reset}"
fi
output="${output}${sep}"

# Cost
output="${output}${fg_red}${cost_display}${reset}"
output="${output}${sep}"

# Time
output="${output}${fg_blue}${current_time}${reset}"

printf '%s' "$output"
