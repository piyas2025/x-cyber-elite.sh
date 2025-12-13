#!/data/data/com.termux/files/usr/bin/bash
# ===============================
# UTF-8 Safe
# ===============================
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ===============================
# State: Banner only once
# ===============================
BANNER_DONE=0

# ===============================
# Random RGB Color (bright)
# ===============================
rand_color() {
  local r=$((RANDOM % 256))
  local g=$((RANDOM % 256))
  local b=$((RANDOM % 256))
  # bold + truecolor
  printf '\033[1;38;2;%d;%d;%dm' "$r" "$g" "$b"
}

# ===============================
# REAL Shadow Banner Function
# ===============================
real_shadow_text() {
  local text="$1"
  local indent=12

  printf "\n"
  printf "%*s\033[2;30m%s\033[0m\n" $((indent+2)) "" "$text"
  printf "\033[1A"
  printf "%*s%s\n" "$indent" "" "$(printf "%s" "$text" | lolcat -p 0.6)"
}

banner() {
  clear

  if ! command -v lolcat >/dev/null 2>&1; then
    echo "Install lolcat first : pkg install lolcat"
    exit 1
  fi

  boot="✦  ⟪▒▒▒ 𝙻𝙾𝙰𝙳𝙸𝙽𝙶 𝚂𝚈𝚂𝚃𝙴𝙼 ▒▒▒⟫ ✦"
  
  # Typewriting effect: Slowly printing each character
  for ((i=0; i<${#boot}; i++)); do
    printf "%s" "${boot:$i:1}"
    sleep 0.1    # Adjust the speed of the typing effect
  done
  echo -e "\n"
  sleep 0.3

  line="========================================="
  echo -e "$line" | lolcat -a -d 2
  sleep 0.25

  cyber=$(printf "\u2591P\u2591I\u2591Y\u2591A\u2591S\u2591 \u2591B\u2591O\u2591S\u2591S\u2591")
  real_shadow_text "$cyber"

  echo
  echo "         𝙰𝙳𝚅𝙰𝙽𝙲𝙴𝙳 𝙷𝙰𝙲𝙺𝙸𝙽𝙶
       »» 𝙲𝙾𝙽𝚃𝚁𝙾𝙻 𝙿𝙰𝙽𝙴𝙻 ««" | lolcat -a -d 3
  echo "-----------------------------------------" | lolcat -a -d 2
  echo " Time: $(date +"%I:%M %p")   Date: $(date +"%d-%m-%Y")" | lolcat -a -d 3
  echo
}

# ==== Color Codes (reset etc) ==== #
YELLOW='\033[1;33m'   # এখন মেইনে ব্যবহার করব না, শুধু থাক
GREEN='\033[1;32m'
RED='\033[1;31m'
CYAN='\033[1;36m'
NC='\033[0m'

#==== Files ====#
SPECIAL_FILE="special-tools.txt"
DISPLAY_NAMES_FILE="display-names.txt"

# Create the files if they don't exist
[ ! -f "$SPECIAL_FILE" ] && touch "$SPECIAL_FILE"
[ ! -f "$DISPLAY_NAMES_FILE" ] && touch "$DISPLAY_NAMES_FILE"

#==== Tools Repository ====#
declare -A tools_repo=(
  ["Zphisher"]="rm -rf zphisher && git clone --depth=1 https://github.com/htr-tech/zphisher.git && cd zphisher && bash zphisher.sh"
  ["ShellPhish"]="apt update && apt upgrade -y && apt install git wget php unzip curl -y && rm -rf ShellPhish && git clone https://github.com/AbirHasan2005/ShellPhish && cd ShellPhish && chmod +x * && bash shellphish.sh"
  ["Shark"]="pkg update -y && pkg install wget -y && wget -qO- https://github.com/Bhaviktutorials/shark/raw/master/setup | bash"
  ["Tool-X"]="apt update && apt upgrade -y && pkg install git -y && rm -rf Tool-X && git clone https://github.com/rajkumardusad/Tool-X.git && cd Tool-X && chmod +x install.aex && bash install.aex && Tool-X"
)

# ===============================
# Simple Header (for menus)
# ===============================
show_header() {
  clear
  local c1 c2 c3 c4
  c1="$(rand_color)"
  c2="$(rand_color)"
  c3="$(rand_color)"
  c4="$(rand_color)"

  echo -e "${c1}=========================================${NC}"
  echo -e "${c2}           PIYAS BOSS PANEL${NC}"
  echo -e "${c3} Time: $(date +"%I:%M %p")   Date: $(date +"%d-%m-%Y")${NC}"
  echo -e "${c4}=========================================${NC}"
  echo
}

#===============================
# Display Name / Star Helpers
#===============================
get_display_name() {
  grep "^$1:" "$DISPLAY_NAMES_FILE" | cut -d':' -f2- | head -n1
}

get_star() {
  grep -q "^$1$" "$SPECIAL_FILE" && echo " *" || echo ""
}

#===============================
# MAIN MENU
#===============================
main_menu() {
  if [ "$BANNER_DONE" -eq 0 ]; then
    banner
    BANNER_DONE=1
  else
    show_header
  fi

  local c
  c="$(rand_color)"; echo -e "${c}[1] System Setup${NC}"
  c="$(rand_color)"; echo -e "${c}[2] Phishing Tools${NC}"
  c="$(rand_color)"; echo -e "${c}[3] Special Tools${NC}"
  c="$(rand_color)"; echo -e "${c}[4] Run Any .sh File${NC}"
  c="$(rand_color)"; echo -e "${c}[0] Exit${NC}"
  echo

  read -p "Choose an option: " opt
  case $opt in
    1) system_setup_menu ;;
    2) phishing_tools_menu ;;
    3) special_tools_menu ;;
    4) run_any_sh_menu ;;
    0) exit 0 ;;
    *) 
       echo -e "${RED}Invalid option.${NC}"
       sleep 1
       main_menu
       ;;
  esac
}

#===============================
# System Setup Menu
#===============================
system_setup_menu() {
  show_header
  local c

  c="$(rand_color)"; echo -e "${c}----- System Setup -----${NC}"
  c="$(rand_color)"; echo -e "${c}[1] apt update${NC}"
  c="$(rand_color)"; echo -e "${c}[2] apt upgrade -y${NC}"
  c="$(rand_color)"; echo -e "${c}[3] Install python${NC}"
  c="$(rand_color)"; echo -e "${c}[4] Install python2${NC}"
  c="$(rand_color)"; echo -e "${c}[5] Install git${NC}"
  c="$(rand_color)"; echo -e "${c}[6] Clone & Setup termux-setup-${NC}"
  c="$(rand_color)"; echo -e "${c}[0] Back${NC}"
  echo

  read -p "Choose: " opt
  case $opt in
    1) pkg update ;;
    2) pkg upgrade -y ;;
    3) pkg install python -y ;;
    4) pkg install python2 -y ;;
    5) pkg install git -y ;;
    6)
      rm -rf termux-setup-
      git clone https://github.com/DH-Alamin/termux-setup-
      cd termux-setup- || { echo -e "${RED}Failed to cd termux-setup-${NC}"; sleep 2; system_setup_menu; return; }
      ls
      python2 setup.py
      cd ..
      ;;
    0) main_menu ; return ;;
    *) echo -e "${RED}Invalid option.${NC}"; sleep 1 ;;
  esac
  read -p "Press Enter to return..." _
  system_setup_menu
}

#===============================
# Phishing Tools Menu
#===============================
phishing_tools_menu() {
  show_header
  local c
  c="$(rand_color)"; echo -e "${c}----- Phishing Tools -----${NC}"

  local i=1
  tools_arr=()
  for tool in "${!tools_repo[@]}"; do
    tools_arr+=("$tool")
    display_name=$(get_display_name "$tool")
    [[ -z "$display_name" ]] && display_name="$tool"
    c="$(rand_color)"
    printf "%b[%d] %-20s%b%s\n" "$c" "$i" "$display_name" "$NC" "$(get_star "$tool")"
    ((i++))
  done

  c="$(rand_color)"; echo -e "${c}[b] Back${NC}"
  echo
  read -p "Select Tool: " choice

  if [[ "$choice" == "b" ]]; then
    main_menu
  elif [[ "$choice" =~ ^[0-9]+$ ]]; then
    index=$((choice-1))
    if [[ $index -ge 0 && $index -lt ${#tools_arr[@]} ]]; then
      phishing_tool_actions "${tools_arr[$index]}"
    else
      echo -e "${RED}Invalid input.${NC}"
      sleep 1
      phishing_tools_menu
    fi
  else
    echo -e "${RED}Invalid input.${NC}"
    sleep 1
    phishing_tools_menu
  fi
}

phishing_tool_actions() {
  local tool="$1"
  display_name=$(get_display_name "$tool")
  [[ -z "$display_name" ]] && display_name="$tool"

  show_header
  local c
  c="$(rand_color)"; echo -e "${c}--- $display_name Menu ---${NC}"
  c="$(rand_color)"; echo -e "${c}[1] Install${NC}"
  c="$(rand_color)"; echo -e "${c}[2] Run${NC}"
  c="$(rand_color)"; echo -e "${c}[3] Update${NC}"
  c="$(rand_color)"; echo -e "${c}[4] Toggle Star${NC}"
  c="$(rand_color)"; echo -e "${c}[5] Rename Display Name${NC}"
  c="$(rand_color)"; echo -e "${c}[6] Remove Tool Directory${NC}"
  c="$(rand_color)"; echo -e "${c}[0] Back${NC}"
  echo

  read -p "Choose: " opt
  case $opt in
    1)
      eval "${tools_repo[$tool]}" && echo -e "${GREEN}$tool Installed.${NC}" ;;
    2)
      # Check if the tool is installed
      if [ ! -d "$tool" ]; then
        echo -e "${RED}Tool is not installed. Installing now...${NC}"
        eval "${tools_repo[$tool]}"
      else
        eval "${tools_repo[$tool]}"
      fi
      ;;
    3) update_tool "$tool" ;;
    4) toggle_star "$tool" ;;
    5) rename_display_name "$tool" ;;
    6) rm -rf "$tool" && echo -e "${RED}$tool removed.${NC}" ;;
    0) phishing_tools_menu ; return ;;
    *) echo -e "${RED}Invalid option.${NC}" ;;
  esac
  read -p "Press Enter to return..." _
  phishing_tool_actions "$tool"
}

#==== Start Script ====#
main_menu
