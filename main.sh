#!/bin/bash

# Xenofetch Enhanced - Ultimate System Information Display
# Version: 1.0.0 - Enhanced Styling Edition

# Enhanced Colors with 256-color support
RED='\033[38;5;196m'
GREEN='\033[38;5;46m'
YELLOW='\033[38;5;226m'
BLUE='\033[38;5;33m'
PURPLE='\033[38;5;129m'
CYAN='\033[38;5;51m'
WHITE='\033[38;5;255m'
ORANGE='\033[38;5;208m'
PINK='\033[38;5;205m'
LIME='\033[38;5;154m'

# Gradient colors
GRAD1='\033[38;5;39m'   # Light blue
GRAD2='\033[38;5;45m'   # Cyan blue
GRAD3='\033[38;5;51m'   # Bright cyan
GRAD4='\033[38;5;87m'   # Light cyan
GRAD5='\033[38;5;123m'  # Sky blue

# Text styles
BOLD='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
REVERSE='\033[7m'
NC='\033[0m'

# Enhanced box drawing characters
BOX_H="━"
BOX_V="┃"
BOX_TL="┏"
BOX_TR="┓"
BOX_BL="┗"
BOX_BR="┛"
BOX_T="┳"
BOX_B="┻"
BOX_L="┣"
BOX_R="┫"
BOX_CROSS="╋"

# Light box drawing for inner borders
LIGHT_H="─"
LIGHT_V="│"
LIGHT_TL="┌"
LIGHT_TR="┐"
LIGHT_BL="└"
LIGHT_BR="┘"
LIGHT_L="├"
LIGHT_R="┤"

# Special symbols
ARROW="→"
BULLET="●"
DIAMOND="◆"
STAR="★"
HEART="♥"
GEAR="⚙"
LIGHTNING="⚡"
FIRE="🔥"
ROCKET="🚀"

# Configuration
SHOW_LOGO=true
JSON_OUTPUT=false

# Enhanced distro detection
detect_distro() {
    if [[ -f /etc/arch-release ]]; then echo "arch"
    elif [[ -f /etc/debian_version ]]; then
        if [[ -f /etc/os-release ]]; then
            local id=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
            case "$id" in
                ubuntu) echo "ubuntu" ;;
                kali) echo "kali" ;;
                *) echo "debian" ;;
            esac
        else
            echo "debian"
        fi
    elif [[ -f /etc/fedora-release ]]; then echo "fedora"
    elif [[ "$OSTYPE" == "darwin"* ]]; then echo "macos"
    else echo "linux"
    fi
}

# Get enhanced distro colors with gradients
get_distro_colors() {
    case "$1" in
        arch) echo "$BLUE" "$CYAN" "$GRAD1" ;;
        ubuntu) echo "$ORANGE" "$RED" "$YELLOW" ;;
        debian) echo "$RED" "$PINK" "$PURPLE" ;;
        kali) echo "$PURPLE" "$BLUE" "$CYAN" ;;
        fedora) echo "$BLUE" "$WHITE" "$CYAN" ;;
        macos) echo "$WHITE" "$CYAN" "$BLUE" ;;
        *) echo "$CYAN" "$BLUE" "$PURPLE" ;;
    esac
}

# Enhanced logo with better styling
get_logo() {
    case "$1" in
        debian)
            cat << 'EOF'
       _,met$$$$$gg.
    ,g$$$$$$$$$$$$$$$P.
  ,g$$P"     """Y$$.".
 ,$$P'              `$$$.
',$$P       ,ggs.     `$$b:
`d$$'     ,$P"'   .    $$$
 $$P      d$'     ,    $$P
 $$:      $$.   -    ,d$$'
 $$;      Y$b._   _,d$P'
 Y$$.    `.`"Y$$$$P"'
 `$$b      "-.__
  `Y$$
   `Y$$.
     `$$b.
       `Y$$b.
          `"Y$b._
              `"""
EOF
            ;;
        arch)
            cat << 'EOF'
                   -`
                  .o+`
                 `ooo/
                `+oooo:
               `+oooooo:
               -+oooooo+:
             `/:-:++oooo+:
            `/++++/+++++++:
           `/++++++++++++++:
          `/+++ooooooooo++++/
         ./ooosssso++osssssso+`
        .oossssso-````/ossssss+`
       -osssssso.      :ssssssso.
      :osssssss/        osssso+++.
     /ossssssss/        +ssssooo/-
   `/ossssso+/:-        -:/+osssso+-
  `+sso+:-`                 `.-/+oso:
 `++:.                           `-/+/
 .`                                 `/
EOF
            ;;
        ubuntu)
            cat << 'EOF'
            .-/+oossssoo+/-.
        `:+ssssssssssssssssss+:`
      -+ssssssssssssssssssyyssss+-
    .ossssssssssssssssssdMMMNysssso.
   /ssssssssssshdmmNNmmyNMMMMhssssss/
  +ssssssssshmydMMMMMMMNddddyssssssss+
 /sssssssshNMMMyhhyyyyhmNMMMNhssssssss/
.ssssssssdMMMNhsssssssssshNMMMdssssssss.
+sssshhhyNMMNyssssssssssssyNMMMysssssss+
ossyNMMMNyMMhsssssssssssssshmmmhssssssso
ossyNMMMNyMMhsssssssssssssshmmmhssssssso
+sssshhhyNMMNyssssssssssssyNMMMysssssss+
.ssssssssdMMMNhsssssssssshNMMMdssssssss.
 /sssssssshNMMMyhhyyyyhdNMMMNhssssssss/
  +sssssssssdmydMMMMMMMMddddyssssssss+
   /ssssssssssshdmNNNNmyNMMMMhssssss/
    .ossssssssssssssssssdMMMNysssso.
      -+sssssssssssssssssyyyssss+-
        `:+ssssssssssssssssss+:`
            .-/+oossssoo+/-.
EOF
            ;;
        *)
            cat << 'EOF'
        #####
       #######
       ##O#O##
       #VVVVV#
     ##  VVV  ##
    #          ##
   #            ##
  #   @    @     #
  #              #
 #      _____     #
 #                #
  #      ___     #
   #            #
    #          #
     ##      ##
       ######
        ####
EOF
            ;;
    esac
}

# System Information Functions
get_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macOS $(sw_vers -productVersion 2>/dev/null)"
    elif [[ -f /etc/os-release ]]; then
        grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"'
    else
        echo "$(uname -s) $(uname -r)"
    fi
}

get_host() {
    local vendor="" product="" version=""
    if [[ -r /sys/devices/virtual/dmi/id/sys_vendor ]]; then
        vendor=$(cat /sys/devices/virtual/dmi/id/sys_vendor 2>/dev/null)
    fi
    if [[ -r /sys/devices/virtual/dmi/id/product_name ]]; then
        product=$(cat /sys/devices/virtual/dmi/id/product_name 2>/dev/null)
    fi
    if [[ -r /sys/devices/virtual/dmi/id/product_version ]]; then
        version=$(cat /sys/devices/virtual/dmi/id/product_version 2>/dev/null)
    fi
    
    if [[ -n "$vendor" && -n "$product" && "$product" != "System Product Name" ]]; then
        echo "$vendor $product${version:+ $version}"
    else
        echo "$(hostname)"
    fi
}

get_kernel() { uname -r; }

get_uptime() {
    if [[ -r /proc/uptime ]]; then
        local up=$(cut -d. -f1 /proc/uptime)
        local d=$((up/86400)) h=$(((up%86400)/3600)) m=$(((up%3600)/60)) s=$((up%60))
        if [[ $d -gt 0 ]]; then echo "${d}d ${h}h ${m}m"
        elif [[ $h -gt 0 ]]; then echo "${h}h ${m}m"
        elif [[ $m -gt 0 ]]; then echo "${m}m ${s}s"
        else echo "${s}s"
        fi
    else
        echo "Unknown"
    fi
}

get_packages() {
    local count=0
    local details=()
    
    command -v pacman &>/dev/null && {
        local pac_count=$(pacman -Q 2>/dev/null | wc -l)
        count=$((count + pac_count))
        details+=("pacman: $pac_count")
    }
    command -v dpkg &>/dev/null && {
        local dpkg_count=$(dpkg -l 2>/dev/null | grep -c '^ii')
        count=$((count + dpkg_count))
        details+=("dpkg: $dpkg_count")
    }
    command -v rpm &>/dev/null && {
        local rpm_count=$(rpm -qa 2>/dev/null | wc -l)
        count=$((count + rpm_count))
        details+=("rpm: $rpm_count")
    }
    command -v brew &>/dev/null && {
        local brew_count=$(brew list 2>/dev/null | wc -l)
        count=$((count + brew_count))
        details+=("brew: $brew_count")
    }
    command -v flatpak &>/dev/null && {
        local flat_count=$(flatpak list 2>/dev/null | wc -l)
        count=$((count + flat_count))
        details+=("flatpak: $flat_count")
    }
    command -v snap &>/dev/null && {
        local snap_count=$(snap list 2>/dev/null | tail -n +2 | wc -l)
        count=$((count + snap_count))
        details+=("snap: $snap_count")
    }
    
    echo "$count"
    printf '%s\n' "${details[@]}"
}

get_shell() {
    local shell_name=$(basename "$SHELL")
    local version=""
    case "$shell_name" in
        bash) version="$BASH_VERSION" ;;
        zsh) version="$ZSH_VERSION" ;;
        fish) version=$(fish --version 2>/dev/null | awk '{print $3}') ;;
    esac
    echo "$shell_name${version:+ $version}"
}

get_resolution() {
    if command -v xrandr &>/dev/null && [[ -n "$DISPLAY" ]]; then
        xrandr 2>/dev/null | grep ' connected' | grep -o '[0-9]*x[0-9]*' | sort -u | tr '\n' ', ' | sed 's/, $//'
    else
        echo "TTY"
    fi
}

get_de() { echo "${XDG_CURRENT_DESKTOP:-${DESKTOP_SESSION:-Unknown}}"; }

get_wm() {
    if [[ -n "$SWAYSOCK" ]]; then echo "Sway"
    elif [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then echo "Hyprland"
    elif command -v wmctrl &>/dev/null && [[ -n "$DISPLAY" ]]; then
        wmctrl -m 2>/dev/null | grep '^Name:' | cut -d' ' -f2-
    elif pgrep -x "i3" &>/dev/null; then echo "i3"
    elif pgrep -x "dwm" &>/dev/null; then echo "dwm"
    elif pgrep -x "bspwm" &>/dev/null; then echo "bspwm"
    else echo "Unknown"
    fi
}

get_theme() {
    if command -v gsettings &>/dev/null; then
        local gtk=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | tr -d "'")
        local icon=$(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null | tr -d "'")
        echo "GTK: $gtk, Icons: $icon"
    else
        echo "Unknown"
    fi
}

get_terminal() { echo "${TERM_PROGRAM:-${TERM}}"; }

get_cpu() {
    if [[ -r /proc/cpuinfo ]]; then
        local model=$(grep '^model name' /proc/cpuinfo | head -1 | cut -d: -f2 | sed 's/^ *//' | sed 's/(R)//g' | sed 's/(TM)//g' | sed 's/  */ /g')
        local cores=$(grep -c '^processor' /proc/cpuinfo)
        local max_freq=""
        
        # Try multiple methods to get CPU frequency
        if [[ -r /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq ]]; then
            local freq_khz=$(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq 2>/dev/null)
            if [[ -n "$freq_khz" && "$freq_khz" -gt 0 ]]; then
                max_freq=" @ $(awk "BEGIN {printf \"%.1f\", $freq_khz/1000000}")GHz"
            fi
        elif [[ -r /proc/cpuinfo ]]; then
            # Extract frequency from model name if available
            local freq_from_model=$(echo "$model" | grep -o '[0-9.]*GHz' | head -1)
            if [[ -n "$freq_from_model" ]]; then
                max_freq=" @ $freq_from_model"
            fi
        fi
        
        # If still no frequency, try to get current frequency
        if [[ -z "$max_freq" && -r /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq ]]; then
            local cur_freq_khz=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null)
            if [[ -n "$cur_freq_khz" && "$cur_freq_khz" -gt 0 ]]; then
                max_freq=" @ $(awk "BEGIN {printf \"%.1f\", $cur_freq_khz/1000000}")GHz"
            fi
        fi
        
        echo "$model ($cores cores$max_freq)"
    else
        echo "Unknown"
    fi
}

get_gpu() {
    if command -v lspci &>/dev/null; then
        lspci 2>/dev/null | grep -E "(VGA|3D|Display)" | sed 's/.*: //' | sed 's/Corporation //g' | sed 's/\[.*\]//g'
    else
        echo "Unknown"
    fi
}

get_memory() {
    if [[ -r /proc/meminfo ]]; then
        local total=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)
        local available=$(awk '/^MemAvailable:/ {print $2}' /proc/meminfo)
        local used=$((total - available))
        printf "%.1fGB / %.1fGB (%.0f%%)" \
            $((used))e-6 $((total))e-6 $((used * 100 / total))
    else
        echo "Unknown"
    fi
}

get_swap() {
    if [[ -r /proc/meminfo ]]; then
        local total=$(awk '/^SwapTotal:/ {print $2}' /proc/meminfo)
        local free=$(awk '/^SwapFree:/ {print $2}' /proc/meminfo)
        local used=$((total - free))
        if [[ $total -gt 0 ]]; then
            printf "%.1fGB / %.1fGB (%.0f%%)" $((used))e-6 $((total))e-6 $((used * 100 / total))
        else
            echo "Not configured"
        fi
    else
        echo "Unknown"
    fi
}

# Enhanced table printing with optimized layouts
print_enhanced_table() {
    local title="$1"
    local primary_color="$2"
    local secondary_color="$3"
    local accent_color="$4"
    local icon="$5"
    shift 5
    local data=("$@")
    
    # Calculate optimal width based on terminal size
    local term_width
    term_width=$(tput cols 2>/dev/null || echo 80)
    
    # Set reasonable table width (80% of terminal width, but between 70-120 chars)
    local table_width=$((term_width * 80 / 100))
    if [[ $table_width -lt 70 ]]; then
        table_width=70
    elif [[ $table_width -gt 120 ]]; then
        table_width=120
    fi
    
    # Calculate column widths
    local key_col_width=22
    local value_col_width=$((table_width - key_col_width - 7))  # 7 for borders and separators
    
    echo
    # Top border
    echo -e "${primary_color}┏$(printf "━%.0s" $(seq 1 $((table_width - 2))))┓${NC}"
    
    # Title with icon
    local title_with_icon="${icon} ${title}"
    # Calculate clean title length (without color codes)
    local title_clean=$(echo "$title_with_icon" | sed 's/\x1b\[[0-9;]*m//g')
    local title_padding=$(((table_width - ${#title_clean} - 2) / 2))
    
    printf "${primary_color}┃${NC}${BOLD}${secondary_color}"
    printf "%*s%s%*s" "$title_padding" "" "$title_with_icon" "$((table_width - title_padding - ${#title_clean} - 2))" ""
    printf "${NC}${primary_color}┃${NC}\n"
    
    # Separator
    echo -e "${primary_color}┣$(printf "━%.0s" $(seq 1 $((table_width - 2))))┫${NC}"
    
    # Data rows
    for ((i=0; i<${#data[@]}; i+=2)); do
        local key="${data[i]}"
        local value="${data[i+1]}"
        
        # Truncate long values to fit
        if [[ ${#value} -gt $value_col_width ]]; then
            value="${value:0:$((value_col_width - 3))}..."
        fi
        
        # Print row
        printf "${primary_color}┃${NC} ${BOLD}${accent_color}●${NC} ${BOLD}%-$((key_col_width - 4))s${NC} ${primary_color}│${NC} %-${value_col_width}s ${primary_color}┃${NC}\n" "$key" "$value"
    done
    
    # Bottom border
    echo -e "${primary_color}┗$(printf "━%.0s" $(seq 1 $((table_width - 2))))┛${NC}"
}

# Enhanced info display for main section
print_info() {
    local key="$1"
    local value="$2"
    local primary_color="$3"
    local secondary_color="$4"
    printf " ${BOLD}${primary_color}${DIAMOND} %-14s${NC} ${secondary_color}%s${NC}\n" "$key" "$value"
}

# Print header with dynamic width
print_header() {
    local text="$1"
    local term_width
    term_width=$(tput cols 2>/dev/null || echo 80)
    local width
    
    if [[ $term_width -gt 100 ]]; then
        width=100
    else
        width=$((term_width - 4))
    fi
    
    if [[ $width -lt 60 ]]; then
        width=60
    fi
    
    echo
    echo -e "${GRAD1}╔$(printf "═%.0s" $(seq 1 $((width-2))))╗${NC}"
    
    local text_clean
    text_clean=$(echo "$text" | sed 's/\x1b\[[0-9;]*m//g')  # Remove ANSI codes
    local text_padding=$(((width - ${#text_clean}) / 2))
    
    printf "${GRAD2}║${BOLD}${WHITE}"
    printf "%*s" "$text_padding" ""
    printf "%s" "$text"
    printf "%*s" "$((width - text_padding - ${#text_clean} - 2))" ""
    printf "${NC}${GRAD2}║${NC}\\n"
    
    echo -e "${GRAD3}╚$(printf "═%.0s" $(seq 1 $((width-2))))╝${NC}"
}

# Main function with enhanced styling
main() {
    # Parse args
    while [[ $# -gt 0 ]]; do
        case $1 in
            --no-logo) SHOW_LOGO=false ;;
            --json) JSON_OUTPUT=true ;;
            -h|--help)
                echo "Xenofetch Enhanced 1.0.0 - Ultimate System Information"
                echo "Usage: xenofetch [--no-logo] [--json] [-h|--help]"
                exit 0
                ;;
        esac
        shift
    done
    
    [[ -t 1 ]] && clear
    
    local distro=$(detect_distro)
    local colors=($(get_distro_colors "$distro"))
    local primary_color="${colors[0]}"
    local secondary_color="${colors[1]}"
    local accent_color="${colors[2]}"
    
    # Print animated header
    print_header "XENOFETCH ${ROCKET} SYSTEM INFORMATION DISPLAY"
    
    # Logo and main info display with enhanced styling
    if [[ "$SHOW_LOGO" == "true" ]]; then
        local logo_lines=()
        mapfile -t logo_lines < <(get_logo "$distro")
        
        # Get all info
        local os="$(get_os)"
        local host="$(get_host)"
        local kernel="$(get_kernel)"
        local uptime="$(get_uptime)"
        local shell="$(get_shell)"
        local resolution="$(get_resolution)"
        local de="$(get_de)"
        local wm="$(get_wm)"
        local theme="$(get_theme)"
        local terminal="$(get_terminal)"
        local cpu="$(get_cpu)"
        local memory="$(get_memory)"
        local swap="$(get_swap)"
        
        # Package info
        local pkg_info=$(get_packages)
        local pkg_count=$(echo "$pkg_info" | head -1)
        local pkg_details=$(echo "$pkg_info" | tail -n +2)
        
        # GPU info
        local gpu_lines=()
        while IFS= read -r line; do
            [[ -n "$line" && "$line" != "Unknown" ]] && gpu_lines+=("$line")
        done < <(get_gpu)
        
        # Main system information with enhanced display
        local main_info=(
            "Operating System" "$os"
            "Host Machine" "$host"
            "Kernel Version" "$kernel"
            "System Uptime" "$uptime"
            "Installed Packages" "$pkg_count"
            "Shell Environment" "$shell"
            "Display Resolution" "$resolution"
            "Desktop Environment" "$de"
            "Window Manager" "$wm"
            "System Theme" "$theme"
            "Terminal Emulator" "$terminal"
            "CPU Information" "$cpu"
            "Memory Usage" "$memory"
            "Swap Usage" "$swap"
        )
        
        local max_lines=${#logo_lines[@]}
        local total_info_lines=$(((${#main_info[@]} / 2) + ${#gpu_lines[@]}))
        [[ $total_info_lines -gt $max_lines ]] && max_lines=$total_info_lines
        
        echo
        local info_index=0
        local gpu_index=0
        
        for ((i=0; i<max_lines; i++)); do
            # Print logo with enhanced colors
            if [[ $i -lt ${#logo_lines[@]} ]]; then
                printf "${primary_color}%-42s${NC}" "${logo_lines[i]}"
            else
                printf "%-42s" ""
            fi
            
            # Print main info with enhanced styling
            if [[ $info_index -lt ${#main_info[@]} ]]; then
                print_info "${main_info[$info_index]}" "${main_info[$((info_index + 1))]}" "$primary_color" "$secondary_color"
                info_index=$((info_index + 2))
            elif [[ $gpu_index -lt ${#gpu_lines[@]} ]]; then
                local gpu_label="Graphics Card"
                [[ $gpu_index -gt 0 ]] && gpu_label="Graphics Card $((gpu_index + 1))"
                print_info "$gpu_label" "${gpu_lines[$gpu_index]}" "$primary_color" "$secondary_color"
                gpu_index=$((gpu_index + 1))
            else
                echo
            fi
        done
    fi
    
    # Enhanced tables with modern styling
    
    # Package Details Table
    if [[ -n "$pkg_details" ]]; then
        local pkg_table_data=()
        while IFS= read -r line; do
            local manager=$(echo "$line" | cut -d: -f1)
            local count=$(echo "$line" | cut -d: -f2 | sed 's/^ *//')
            pkg_table_data+=("$manager" "$count packages")
        done <<< "$pkg_details"
        
        print_enhanced_table "Package Managers" "$GREEN" "$LIME" "$YELLOW" "📦" "${pkg_table_data[@]}"
    fi
    
    # System Performance & Load Table
    local load_avg="Unknown"
    local cpu_usage="Unknown"
    local processes="Unknown"
    local boot_time="Unknown"
    
    if [[ -r /proc/loadavg ]]; then
        load_avg=$(awk '{print $1", "$2", "$3}' /proc/loadavg)
    fi
    
    if [[ -r /proc/stat ]]; then
        local cpu_line=$(head -1 /proc/stat)
        local cpu_times=($cpu_line)
        local idle=${cpu_times[4]}
        local total=0
        for value in "${cpu_times[@]:1}"; do
            total=$((total + value))
        done
        cpu_usage="$((100 * (total - idle) / total))%"
    fi
    
    processes=$(ps aux 2>/dev/null | wc -l | awk '{print $1-1}')
    
    if [[ -r /proc/stat ]]; then
        local btime=$(awk '/^btime/ {print $2}' /proc/stat)
        boot_time=$(date -d "@$btime" "+%Y-%m-%d %H:%M:%S" 2>/dev/null || echo "Unknown")
    fi
    
    print_enhanced_table "System Performance & Load" "$BLUE" "$CYAN" "$WHITE" "⚡" \
        "Load Average" "$load_avg" \
        "CPU Usage" "$cpu_usage" \
        "Running Processes" "$processes" \
        "Boot Time" "$boot_time" \
        "System Architecture" "$(uname -m)" \
        "Kernel Build Date" "$(uname -v)"
    
    # Hardware Details Table
    local battery="No battery detected"
    if [[ -d /sys/class/power_supply/BAT* ]]; then
        local bat_info=()
        for bat in /sys/class/power_supply/BAT*; do
            if [[ -r "$bat/capacity" && -r "$bat/status" ]]; then
                local capacity=$(cat "$bat/capacity")
                local status=$(cat "$bat/status")
                bat_info+=("$(basename "$bat"): $capacity% ($status)")
            fi
        done
        if [[ ${#bat_info[@]} -gt 0 ]]; then
            battery=$(IFS=', '; echo "${bat_info[*]}")
        fi
    fi
    
    local storage_info=""
    if command -v lsblk &>/dev/null; then
        storage_info=$(lsblk -d -o NAME,SIZE,TYPE,MODEL 2>/dev/null | grep -E "(disk|nvme)" | tail -n +1)
    fi
    
    local motherboard="Unknown"
    if [[ -r /sys/devices/virtual/dmi/id/board_vendor && -r /sys/devices/virtual/dmi/id/board_name ]]; then
        local board_vendor=$(cat /sys/devices/virtual/dmi/id/board_vendor 2>/dev/null)
        local board_name=$(cat /sys/devices/virtual/dmi/id/board_name 2>/dev/null)
        motherboard="$board_vendor $board_name"
    fi
    
    print_enhanced_table "Hardware Details" "$PURPLE" "$PINK" "$WHITE" "🔧" \
        "Battery Status" "$battery" \
        "Motherboard" "$motherboard" \
        "Storage Devices" "$storage_info"
    
    # Network Information Table
    local public_ip="Checking..."
    if command -v curl &>/dev/null; then
        public_ip=$(timeout 2 curl -s --max-time 2 ifconfig.me 2>/dev/null || echo "Unavailable")
    fi
    
    local local_ip="Unknown"
    if command -v ip &>/dev/null; then
        local_ip=$(ip route get 8.8.8.8 2>/dev/null | grep -oP 'src \K[0-9.]+' | head -1)
    fi
    
    local network_interfaces=""
    if command -v ip &>/dev/null; then
        network_interfaces=$(ip -br addr show up 2>/dev/null | awk '$1!="lo" && $3 {print $1}' | tr '\n' ', ' | sed 's/, $//')
    fi
    
    local dns_servers=""
    if [[ -r /etc/resolv.conf ]]; then
        dns_servers=$(grep '^nameserver' /etc/resolv.conf | awk '{print $2}' | head -2 | tr '\n' ', ' | sed 's/, $//')
    fi
    
    print_enhanced_table "Network Information" "$CYAN" "$BLUE" "$WHITE" "🌐" \
        "Public IP" "$public_ip" \
        "Local IP" "$local_ip" \
        "Active Interfaces" "$network_interfaces" \
        "DNS Servers" "$dns_servers" \
        "Hostname" "$(hostname)" \
        "Domain" "$(hostname -d 2>/dev/null || echo "None")"
    
    # Process Information Table
    local top_processes=""
    if command -v ps &>/dev/null; then
        top_processes=$(ps aux --sort=-%cpu 2>/dev/null | head -4 | awk 'NR>1 {printf "%s (%.1f%%)", $11, $3}' | tr '\n' ', ' | sed 's/, $//')
    fi
    
    local memory_top=""
    if command -v ps &>/dev/null; then
        memory_top=$(ps aux --sort=-%mem 2>/dev/null | head -4 | awk 'NR>1 {printf "%s (%.1f%%)", $11, $4}' | tr '\n' ', ' | sed 's/, $//')
    fi
    
    print_enhanced_table "Process Information" "$YELLOW" "$ORANGE" "$RED" "🔄" \
        "Total Processes" "$processes" \
        "Top CPU Users" "$top_processes" \
        "Top Memory Users" "$memory_top"
    
    # System Environment Table
    local locale="${LANG:-Unknown}"
    local timezone=""
    if command -v timedatectl &>/dev/null; then
        timezone=$(timedatectl show --property=Timezone --value 2>/dev/null)
    else
        timezone=$(date +%Z)
    fi
    
    local users_logged_in=""
    if command -v who &>/dev/null; then
        users_logged_in=$(who | wc -l)
    fi
    
    print_enhanced_table "System Environment" "$PURPLE" "$PINK" "$WHITE" "🌍" \
        "Locale" "$locale" \
        "Timezone" "$timezone" \
        "Logged In Users" "$users_logged_in" \
        "System Vendor" "$(cat /sys/devices/virtual/dmi/id/sys_vendor 2>/dev/null || echo "Unknown")" \
        "BIOS Version" "$(cat /sys/devices/virtual/dmi/id/bios_version 2>/dev/null || echo "Unknown")"
    
    # Temperature Information (if available)
    if command -v sensors &>/dev/null; then
        local temp_info=$(sensors 2>/dev/null | grep -E "(Core|temp)" | head -5 | sed 's/^[[:space:]]*//' | tr '\n' ', ' | sed 's/, $//')
        if [[ -n "$temp_info" ]]; then
            print_enhanced_table "Temperature Sensors" "$RED" "$ORANGE" "$YELLOW" "🌡️" \
                "System Temperatures" "$temp_info"
        fi
    fi
    
    # Enhanced color palette with gradient effect
    echo
    echo -e " ${BOLD}${WHITE}Color Palette:${NC}"
    echo -e " ${RED}██${GREEN}██${YELLOW}██${BLUE}██${PURPLE}██${CYAN}██${WHITE}██${NC} ${ORANGE}██${PINK}██${LIME}██${GRAD1}██${GRAD2}██${GRAD3}██${GRAD4}██${NC}"
    echo
    
    # Footer with system info summary
    local current_time=$(date "+%Y-%m-%d %H:%M:%S %Z")
    echo -e "${DIM}${ITALIC}Generated by Xenofetch v1.0.0 on $current_time${NC}"
    echo
}

main "$@"