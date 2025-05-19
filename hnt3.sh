#!/bin/bash
# filepath: /home/simon/hunter3/hnt3.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}DEV.SOMOYAMO.COM${NC}"
echo -e "${YELLOW}${BOLD}Created by: Simon (simon@somoyamo.com)${NC}"
echo -e "${BLUE}${BOLD}https://hunter3.ninja/${NC}"
echo -e "${BLUE}${BOLD}https://github.com/simon-msdos${NC}"
echo -e "${PURPLE}${BOLD}============================================${NC}\n"

LOG_FILE="/tmp/hunter3_tools_install.log"
touch "$LOG_FILE"

REQUIRED_PKGS=(git make python3 python3-pip ruby curl golang)
MISSING_PKGS=()
for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! dpkg -s "$pkg" &>/dev/null; then
        MISSING_PKGS+=("$pkg")
    fi
done

if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
    echo -e "${YELLOW}Installing missing dependencies: ${MISSING_PKGS[*]}${NC}"
    sudo apt-get update &>>"$LOG_FILE"
    sudo apt-get install -y "${MISSING_PKGS[@]}" &>>"$LOG_FILE"
fi

export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

declare -A TOOL_METHODS
declare -A TOOL_REPOS

TOOL_METHODS[subfinder]=go
TOOL_REPOS[subfinder]="github.com/projectdiscovery/subfinder/v2/cmd/subfinder"
TOOL_METHODS[httpx]=go
TOOL_REPOS[httpx]="github.com/projectdiscovery/httpx/cmd/httpx"
TOOL_METHODS[subzy]=go
TOOL_REPOS[subzy]="github.com/PentestPad/subzy"
TOOL_METHODS[naabu]=go
TOOL_REPOS[naabu]="github.com/projectdiscovery/naabu/v2/cmd/naabu"
TOOL_METHODS[katana]=go
TOOL_REPOS[katana]="github.com/projectdiscovery/katana/cmd/katana"
TOOL_METHODS[gau]=go
TOOL_REPOS[gau]="github.com/lc/gau/v2/cmd/gau"
TOOL_METHODS[gf]=go
TOOL_REPOS[gf]="github.com/tomnomnom/gf"
TOOL_METHODS[Gxss]=go
TOOL_REPOS[Gxss]="github.com/KathanP19/Gxss"
TOOL_METHODS[kxss]=go
TOOL_REPOS[kxss]="github.com/tomnomnom/hacks/kxss"
TOOL_METHODS[dalfox]=go
TOOL_REPOS[dalfox]="github.com/hahwul/dalfox/v2"
TOOL_METHODS[nuclei]=go
TOOL_REPOS[nuclei]="github.com/projectdiscovery/nuclei/v3/cmd/nuclei"
TOOL_METHODS[ffuf]=go
TOOL_REPOS[ffuf]="github.com/ffuf/ffuf/v2"
TOOL_METHODS[qsreplace]=go
TOOL_REPOS[qsreplace]="github.com/tomnomnom/qsreplace"
TOOL_METHODS[assetfinder]=go
TOOL_REPOS[assetfinder]="github.com/tomnomnom/assetfinder"
TOOL_METHODS[httprobe]=go
TOOL_REPOS[httprobe]="github.com/tomnomnom/httprobe"
TOOL_METHODS[s3scanner]=go
TOOL_REPOS[s3scanner]="github.com/sa7mon/s3scanner"

TOOL_METHODS[uro]=pip
TOOL_METHODS[arjun]=pip
TOOL_METHODS[CORScanner]=pip

TOOL_METHODS[wpscan]=gem

TOOL_METHODS[nmap]=apt
TOOL_METHODS[masscan]=apt
TOOL_METHODS[curl]=apt
TOOL_METHODS[git]=apt
TOOL_METHODS[make]=apt
TOOL_METHODS[python3]=apt
TOOL_METHODS[python3-pip]=apt
TOOL_METHODS[ruby]=apt
TOOL_METHODS[golang]=apt

ALL_TOOLS=(
    git make python3 python3-pip ruby golang
    nmap masscan curl
    subfinder httpx subzy naabu katana gau gf Gxss kxss dalfox nuclei ffuf qsreplace assetfinder httprobe
    uro arjun CORScanner
    wpscan
    s3scanner
)

progress_bar() {
    local progress=$1
    local total=$2
    local width=40
    local percent=$((progress * 100 / total))
    local filled=$((width * progress / total))
    local empty=$((width - filled))
    printf "\r${YELLOW}[${GREEN}%s${NC}%s] %3d%%${NC}" \
        "$(printf '█%.0s' $(seq 1 $filled))" \
        "$(printf ' %.0s' $(seq 1 $empty))" \
        "$percent"
}

animate_progress() {
    local duration=$1
    local steps=40
    for ((i=1; i<=steps; i++)); do
        progress_bar $i $steps
        sleep $(awk "BEGIN{print $duration/$steps}")
    done
    printf "\n"
}

install_apt() {
    local pkg=$1
    if dpkg -s "$pkg" &>/dev/null; then
        echo -e "${CYAN}$pkg already installed.${NC}"
        return 0
    fi
    sudo apt-get install -y "$pkg" &>>"$LOG_FILE" &
    animate_progress 4
    if [[ "$pkg" == "python3-pip" ]]; then
        command -v pip3 &>/dev/null
    else
        dpkg -s "$pkg" &>/dev/null
    fi
}

install_go() {
    local tool=$1
    local repo=${TOOL_REPOS[$tool]}
    if command -v "$tool" &>/dev/null; then
        echo -e "${CYAN}$tool already installed.${NC}"
        return 0
    fi
    go install "$repo@latest" &>>"$LOG_FILE" 2>&1
    if [ -f "$HOME/go/bin/$tool" ]; then
        sudo mv "$HOME/go/bin/$tool" /usr/local/bin/
    else
        echo -e "${RED}Go build failed for $tool. See $LOG_FILE for details.${NC}"
        tail -n 10 "$LOG_FILE"
        return 1
    fi
    command -v "$tool" &>/dev/null
}

install_pip() {
    local pkg=$1
    if pip3 show "$pkg" &>/dev/null; then
        echo -e "${CYAN}$pkg already installed.${NC}"
        return 0
    fi
    pip3 install --break-system-packages "$pkg" &>>"$LOG_FILE" &
    animate_progress 5
    pip3 show "$pkg" &>/dev/null
}

install_gem() {
    local pkg=$1
    if gem list -i "$pkg" &>/dev/null; then
        echo -e "${CYAN}$pkg already installed.${NC}"
        return 0
    fi
    gem install "$pkg" &>>"$LOG_FILE" &
    animate_progress 6
    gem list -i "$pkg" &>/dev/null
}

install_masscan() {
    if ! dpkg -s masscan &>/dev/null; then
        sudo apt-get install -y masscan &>>"$LOG_FILE"
    fi
    if ! command -v masscan &>/dev/null; then
        echo -e "${YELLOW}Trying to build masscan from source...${NC}"
        rm -rf /tmp/masscan
        if ! git clone https://github.com/robertdavidgraham/masscan.git /tmp/masscan &>>"$LOG_FILE"; then
            echo -e "${RED}Failed to clone masscan repo. Check your network or git install.${NC}"
            return 1
        fi
        cd /tmp/masscan || { echo -e "${RED}Failed to enter masscan directory.${NC}"; return 1; }
        make &>>"$LOG_FILE"
        sudo cp bin/masscan /usr/local/bin/
        cd - &>/dev/null
        rm -rf /tmp/masscan
    fi
    command -v masscan &>/dev/null
}

uninstall_apt() {
    local pkg=$1
    if dpkg -s "$pkg" &>/dev/null; then
        sudo apt-get remove -y "$pkg" &>>"$LOG_FILE"
    fi
}
uninstall_go() {
    local tool=$1
    sudo rm -f "/usr/local/bin/$tool" "$HOME/go/bin/$tool"
}
uninstall_pip() {
    local pkg=$1
    if command -v pip3 &>/dev/null; then
        pip3 uninstall -y "$pkg" &>>"$LOG_FILE"
    fi
}
uninstall_gem() {
    local pkg=$1
    if command -v gem &>/dev/null; then
        gem uninstall -x "$pkg" &>>"$LOG_FILE"
    fi
}

choose_tools() {
    local -n _chosen=$1
    echo -e "${CYAN}Available tools:${NC}"
    for i in "${!ALL_TOOLS[@]}"; do
        echo "$((i+1)). ${ALL_TOOLS[$i]}"
    done
    echo -e "${YELLOW}Enter tool numbers separated by spaces (e.g. 1 3 5):${NC}"
    read -r choices
    _chosen=()
    for n in $choices; do
        idx=$((n-1))
        if [[ $idx -ge 0 && $idx -lt ${#ALL_TOOLS[@]} ]]; then
            _chosen+=("${ALL_TOOLS[$idx]}")
        fi
    done
}

main_menu() {
    echo -e "${CYAN}${BOLD}Choose an option:${NC}"
    echo "1) Install all tools"
    echo "2) Install selected tools"
    echo "3) Uninstall all tools"
    echo "4) Uninstall selected tools"
    echo "5) Exit"
    read -p "Enter choice [1-5]: " menu_choice
    case $menu_choice in
        1)
            SELECTED_TOOLS=("${ALL_TOOLS[@]}")
            ACTION="install"
            ;;
        2)
            choose_tools SELECTED_TOOLS
            ACTION="install"
            ;;
        3)
            SELECTED_TOOLS=("${ALL_TOOLS[@]}")
            ACTION="uninstall"
            ;;
        4)
            choose_tools SELECTED_TOOLS
            ACTION="uninstall"
            ;;
        5)
            exit 0
            ;;
        *)
            echo "Invalid choice."
            main_menu
            ;;
    esac
}

CORE_PKGS=(python3 git make ruby curl golang)
is_core_pkg() {
    local pkg=$1
    for core in "${CORE_PKGS[@]}"; do
        [[ "$pkg" == "$core" ]] && return 0
    done
    return 1
}

main_menu

total=${#SELECTED_TOOLS[@]}
success=0
fail=0

for idx in "${!SELECTED_TOOLS[@]}"; do
    tool="${SELECTED_TOOLS[$idx]}"
    num=$((idx+1))
    method="${TOOL_METHODS[$tool]}"
    echo -e "${BOLD}${YELLOW}[$num/$total] ${ACTION^}ing ${tool}...${NC}"
    if [[ $ACTION == "uninstall" && "$method" == "apt" ]] && is_core_pkg "$tool"; then
        echo -e "${PURPLE}Skipping uninstall of core package: $tool${NC}"
        ((success++))
        continue
    fi
    if [[ $ACTION == "install" ]]; then
        if [[ "$tool" == "masscan" ]]; then
            install_masscan
        else
            case "$method" in
                apt) install_apt "$tool" ;;
                go) install_go "$tool" ;;
                pip) install_pip "$tool" ;;
                gem) install_gem "$tool" ;;
                *) echo -e "${RED}Unknown install method for $tool${NC}" ;;
            esac
        fi
        if [[ "$method" == "apt" ]]; then
            if dpkg -s "$tool" &>/dev/null; then
                echo -e "${GREEN}✔ $tool installed.${NC}"
                ((success++))
            else
                echo -e "${RED}✖ $tool failed to install.${NC}"
                ((fail++))
            fi
        elif [[ "$method" == "go" ]]; then
            if command -v "$tool" &>/dev/null; then
                echo -e "${GREEN}✔ $tool installed.${NC}"
                ((success++))
            else
                echo -e "${RED}✖ $tool failed to install.${NC}"
                ((fail++))
            fi
        elif [[ "$method" == "pip" ]]; then
            if pip3 show "$tool" &>/dev/null; then
                echo -e "${GREEN}✔ $tool installed.${NC}"
                ((success++))
            else
                echo -e "${RED}✖ $tool failed to install.${NC}"
                ((fail++))
            fi
        elif [[ "$method" == "gem" ]]; then
            if gem list -i "$tool" &>/dev/null; then
                echo -e "${GREEN}✔ $tool installed.${NC}"
                ((success++))
            else
                echo -e "${RED}✖ $tool failed to install.${NC}"
                ((fail++))
            fi
        else
            echo -e "${RED}Unknown install method for $tool${NC}"
            ((fail++))
        fi
    else
        case "$method" in
            apt) uninstall_apt "$tool" ;;
            go) uninstall_go "$tool" ;;
            pip) uninstall_pip "$tool" ;;
            gem) uninstall_gem "$tool" ;;
            *) echo -e "${RED}Unknown uninstall method for $tool${NC}" ;;
        esac
        if ! command -v "$tool" &>/dev/null && ! pip3 show "$tool" &>/dev/null && ! gem list -i "$tool" &>/dev/null; then
            echo -e "${GREEN}✔ $tool uninstalled.${NC}"
            ((success++))
        else
            echo -e "${RED}✖ $tool failed to uninstall.${NC}"
            ((fail++))
        fi
    fi
    sleep 0.5
done

echo -e "\n${CYAN}${BOLD}${ACTION^}ation complete!${NC}"
echo -e "${GREEN}Success: $success${NC}  ${RED}Failed: $fail${NC}"
echo -e "${YELLOW}Check the log at $LOG_FILE for details.${NC}"
echo -e "${CYAN}To use Go tools, ensure /usr/local/go/bin and \$HOME/go/bin are in your PATH.${NC}"
