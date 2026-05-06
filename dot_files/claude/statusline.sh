#!/bin/bash

# =============================================================================
# Input Parsing
# =============================================================================

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // ""')
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
context_percentage=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
context_max=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
five_h_percentage=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0')
five_h_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // 0')
seven_d_percentage=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // 0')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')

# =============================================================================
# Colors (Catppuccin Mocha palette)
# =============================================================================

fg=$'\033[38;2;17;17;27m'         # #11111b (crust) - text on colored backgrounds
reset=$'\033[0m'

# Background colors (gradient from cool to warm)
bg_blue=$'\033[48;2;137;180;250m'      # #89b4fa
bg_sapphire=$'\033[48;2;116;199;236m'  # #74c7ec
bg_sky=$'\033[48;2;137;220;235m'       # #89dceb
bg_green=$'\033[48;2;166;227;161m'     # #a6e3a1
bg_yellow=$'\033[48;2;249;226;175m'    # #f9e2af
bg_peach=$'\033[48;2;250;179;135m'     # #fab387
bg_maroon=$'\033[48;2;235;160;172m'   # #eba0ac
bg_red=$'\033[48;2;243;139;168m'      # #f38ba8

# Foreground colors (for separator symbols)
fg_blue=$'\033[38;2;137;180;250m'
fg_sapphire=$'\033[38;2;116;199;236m'
fg_sky=$'\033[38;2;137;220;235m'
fg_green=$'\033[38;2;166;227;161m'
fg_yellow=$'\033[38;2;249;226;175m'
fg_peach=$'\033[38;2;250;179;135m'
fg_maroon=$'\033[38;2;235;160;172m'
fg_red=$'\033[38;2;243;139;168m'

# =============================================================================
# Symbols & Icons
# =============================================================================

# Powerline separators:
#   left_segment_end    - pointed right, fg=current bg, bg=next segment
#   right_segment_start - pointed left, fg=next segment, bg=current
left_cap=''
right_cap=''
left_segment_end=''
right_segment_start=''

# Status icons
icon_branch=''
icon_uncommited=''
icon_behind=''
icon_ahead=''

# =============================================================================
# Data Processing
# =============================================================================

# Current time
current_time=$(date +"%H:%M")

# Directory (last component only)
dir=$(basename "$cwd")

# Git information
git_branch_name=""
git_status=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    git_branch_name=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || \
                      git -C "$cwd" rev-parse --short HEAD 2>/dev/null)

    if [ -n "$git_branch_name" ]; then
        # Uncommitted changes
        git_porcelain=$(git -C "$cwd" status --porcelain 2>/dev/null)
        if [ -n "$git_porcelain" ]; then
            git_status="${git_status}${icon_uncommited}"
        fi

        # Ahead/behind tracking branch
        ahead_behind=$(git -C "$cwd" rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)
        if [ -n "$ahead_behind" ]; then
            ahead=$(echo "$ahead_behind" | awk '{print $1}')
            behind=$(echo "$ahead_behind" | awk '{print $2}')
            [ "$behind" -gt 0 ] 2>/dev/null && git_status="${git_status}${icon_behind}${behind}"
            [ "$ahead" -gt 0 ] 2>/dev/null && git_status="${git_status}${icon_ahead}${ahead}"
        fi
    fi
fi

# Context window percentage (e.g., "45%")
if [ "$context_percentage" != "null" ]; then
    context_display=$(printf "%.0f%%" "$context_percentage")
else
    context_display="--"
fi

# Five-hour rate limit (e.g., "5h 32% →17:30")
if [ "$five_h_percentage" != "null" ]; then
    five_h_pct_display=$(printf "%.0f%%" "$five_h_percentage")
else
    five_h_pct_display="--"
fi

five_h_resets_display=""
if [ "$five_h_resets" != "0" ] && [ "$five_h_resets" != "" ]; then
    five_h_resets_display=$(date -r "$five_h_resets" +"%H:%M")
fi

# Seven-day rate limit (e.g., "7d 12%")
if [ "$seven_d_percentage" != "null" ]; then
    seven_d_pct_display=$(printf "%.0f%%" "$seven_d_percentage")
else
    seven_d_pct_display="--"
fi

# Cost
if [ "$cost" != "0" ] && [ "$cost" != "null" ]; then
    cost_display=$(printf "$%.2f" "$cost")
else
    cost_display="\$0.00"
fi

# =============================================================================
# Output Generation
# =============================================================================

output=""

# Segment 1: Directory (sapphire)
output="${output}${fg_sapphire}${left_cap}${bg_sapphire}${fg}  ${dir} "
output="${output}${reset}${fg_sapphire}${bg_sky}${left_segment_end}${reset}"

# Segment 3: Git (sky) - only if in git repo
if [ -n "$git_branch_name" ]; then
    if [ -n "$git_status" ]; then
        output="${output}${bg_sky}${fg} ${icon_branch} ${git_branch_name} ${git_status} "
    else
        output="${output}${bg_sky}${fg} ${icon_branch} ${git_branch_name} ✓ "
    fi
    output="${output}${reset}${bg_sky}${fg_green}${right_segment_start}${reset}"
else
    output="${output}${bg_sky}${fg} "
    output="${output}${reset}${bg_sky}${fg_green}${right_segment_start}${reset}"
fi

# Segment 4: Model (green)
output="${output}${bg_green}${fg} 󰧑 ${model} "
output="${output}${reset}${bg_green}${fg_yellow}${right_segment_start}${reset}"

# Segment 5: Context (yellow)
output="${output}${bg_yellow}${fg} 󰍛 ${context_display} "
output="${output}${reset}${bg_yellow}${fg_peach}${right_segment_start}${reset}"

# Segment 6: 5h rate limit (peach)
if [ -n "$five_h_resets_display" ]; then
    output="${output}${bg_peach}${fg} 󰎫 ${five_h_pct_display} →${five_h_resets_display} "
else
    output="${output}${bg_peach}${fg} 󰎫 ${five_h_pct_display} "
fi
output="${output}${reset}${bg_peach}${fg_maroon}${right_segment_start}${reset}"

# Segment 7: 7d rate limit (maroon)
output="${output}${bg_maroon}${fg} 󰃭 ${seven_d_pct_display} "
output="${output}${reset}${bg_maroon}${fg_red}${right_segment_start}${reset}"

# Segment 8: Cost (red)
output="${output}${bg_red}${fg}  ${cost_display} "
output="${output}${reset}${fg_red}${right_cap}${reset}"

# Time on second line (no background)
time_line="${fg_blue}${current_time}${reset}"

printf "%s\n%s\n" "$output" "$time_line"
