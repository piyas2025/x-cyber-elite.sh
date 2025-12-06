#!/data/data/com.termux/files/usr/bin/bash
#==== Color Codes ====#
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
CYAN='\033[1;36m'
NC='\033[0m'
#==== Files ====#
SPECIAL_FILE="special-tools.txt"
DISPLAY_NAMES_FILE="display-names.txt"
touch "$SPECIAL_FILE"
touch "$DISPLAY_NAMES_FILE"
#==== Tools Repository ====#
declare -A tools_repo=(
  ["Zphisher"]="rm -rf zphisher && git clone --depth=1 https://github.com/htr-tech/zphisher.git && cd zphisher && bash zphisher.sh"
  ["ShellPhish"]="apt update && apt upgrade -y && apt install git wget php unzip curl -y && rm -rf ShellPhish && git clone https://github.com/AbirHasan2005/ShellPhish && cd ShellPhish && chmod +x * && bash shellphish.sh"
  ["Shark"]="pkg update -y && pkg install wget -y && wget -qO- https://github.com/Bhaviktutorials/shark/raw/master/setup | bash"
  ["Tool-X"]="apt update && apt upgrade -y && pkg install git -y && rm -rf Tool-X && git clone https://github.com/rajkumardusad/Tool-X.git && cd Tool-X && chmod +x install.aex && bash install.aex && Tool-X"
)
#==== Greeting Function ====#
display_greeting() {
  clear
  echo -e "${CYAN}=========================================${NC}"
  echo -e "${GREEN}       ░P░I░Y░A░S░ ░B░O░S░S░${NC}"
  echo -e "${CYAN}-----------------------------------------${NC}"
  echo -e "${YELLOW}Time: $(date +"%I:%M %p")  Date: $(date +"%d-%m-%Y")${NC}"
  echo -e "${CYAN}=========================================${NC}"
}
#==== Display Name Fetch ====#
get_display_name() {
  grep "^$1:" "$DISPLAY_NAMES_FILE" | cut -d':' -f2- | head -n1
}
#==== Get Star Mark ====#
get_star() {
  grep -q "^$1$" "$SPECIAL_FILE" && echo " *" || echo ""
}
#==== Main Menu ====#
print_menu() {
  display_greeting
  echo -e "${YELLOW}[1] System Setup${NC}"
  echo -e "${YELLOW}[2] Phishing Tools${NC}"
  echo -e "${YELLOW}[3] Special Tools${NC}"
  echo -e "${YELLOW}[4] Run Any .sh File${NC}"
  echo -e "${YELLOW}[0] Exit${NC}"
  read -p "Choose an option: " opt
  case $opt in
    1) system_setup_menu ;;
    2) phishing_tools_menu ;;
    3) special_tools_menu ;;
    4) run_any_sh_menu ;;
    0) exit 0 ;;
    *) echo -e "${RED}Invalid option.${NC}"
       sleep 1
       print_menu ;;
  esac
}
#==== System Setup Menu ====#
system_setup_menu() {
  display_greeting
  echo -e "${CYAN}----- System Setup -----${NC}"
  echo -e "${YELLOW}[1] apt update${NC}"
  echo -e "${YELLOW}[2] apt upgrade -y${NC}"
  echo -e "${YELLOW}[3] Install python${NC}"
  echo -e "${YELLOW}[4] Install python2${NC}"
  echo -e "${YELLOW}[5] Install git${NC}"
  echo -e "${YELLOW}[6] Clone & Setup termux-setup-${NC}"
  echo -e "${YELLOW}[0] Back${NC}"
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
    0) print_menu ;;
    *) echo -e "${RED}Invalid option.${NC}"; sleep 1 ;;
  esac
  read -p "Press Enter to return..."
  system_setup_menu
}
#==== Phishing Tools Menu ====#
phishing_tools_menu() {
  display_greeting
  echo -e "${CYAN}----- Phishing Tools -----${NC}"
  local i=1
  tools_arr=()
  for tool in "${!tools_repo[@]}"; do
    tools_arr+=("$tool")
    display_name=$(get_display_name "$tool")
    [[ -z "$display_name" ]] && display_name="$tool"
    printf "${YELLOW}[%d] %-20s${NC}%s\n" "$i" "$display_name" "$(get_star "$tool")"
    ((i++))
  done
  echo -e "${YELLOW}[b] Back${NC}"
  read -p "Select Tool: " choice
  if [[ "$choice" == "b" ]]; then
    print_menu
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
#==== Phishing Tool Actions ====#
phishing_tool_actions() {
  local tool="$1"
  display_name=$(get_display_name "$tool")
  [[ -z "$display_name" ]] && display_name="$tool"
  display_greeting
  echo -e "${CYAN}--- $display_name Menu ---${NC}"
  echo -e "${YELLOW}[1] Install${NC}"
  echo -e "${YELLOW}[2] Run${NC}"
  echo -e "${YELLOW}[3] Update${NC}"
  echo -e "${YELLOW}[4] Toggle Star${NC}"
  echo -e "${YELLOW}[5] Rename Display Name${NC}"
  echo -e "${YELLOW}[6] Remove Tool Directory${NC}"
  echo -e "${YELLOW}[0] Back${NC}"
  read -p "Choose: " opt
  case $opt in
    1) eval "${tools_repo[$tool]}" && echo -e "${GREEN}$tool Installed.${NC}" ;;
    2) eval "${tools_repo[$tool]}" ;;
    3) update_tool "$tool" ;;
    4) toggle_star "$tool" ;;
    5) rename_display_name "$tool" ;;
    6) rm -rf "$tool" && echo -e "${RED}$tool removed.${NC}" ;;
    0) phishing_tools_menu ;;
    *) echo -e "${RED}Invalid option.${NC}" ;;
  esac
  read -p "Press Enter to return..."
  phishing_tool_actions "$tool"
}
#==== Rename Display Name ====#
rename_display_name() {
  local tool="$1"
  read -p "New display name: " newname
  grep -v "^$tool:" "$DISPLAY_NAMES_FILE" > temp && mv temp "$DISPLAY_NAMES_FILE"
  echo "$tool:$newname" >> "$DISPLAY_NAMES_FILE"
  echo -e "${GREEN}Display name updated!${NC}"
}
#==== Toggle Star ====#
toggle_star() {
  local tool="$1"
  if grep -q "^$tool$" "$SPECIAL_FILE"; then
    grep -v "^$tool$" "$SPECIAL_FILE" > temp && mv temp "$SPECIAL_FILE"
    echo -e "${YELLOW}Star removed.${NC}"
  else
    echo "$tool" >> "$SPECIAL_FILE"
    echo -e "${YELLOW}Star added.${NC}"
  fi
}
#==== Update Tool ====#
update_tool() {
  local tool="$1"
  echo -e "${CYAN}Updating $tool...${NC}"
  case $tool in
    "Zphisher") cd zphisher && git pull && cd .. ;;
    "ShellPhish") cd ShellPhish && git pull && cd .. ;;
    "Tool-X") cd Tool-X && git pull && cd .. ;;
    "Shark") echo -e "${GREEN}Update handled by setup script.${NC}" ;;
    *) echo -e "${RED}No update logic defined.${NC}" ;;
  esac
  echo -e "${GREEN}$tool updated.${NC}"
}
#==== Special Tools Menu ====#
special_tools_menu() {
  display_greeting
  echo -e "${CYAN}----- Special Tools -----${NC}"
  mapfile -t stars < "$SPECIAL_FILE"
  if [[ ${#stars[@]} -eq 0 ]]; then
    echo -e "${RED}No starred tools.${NC}"
    sleep 2
    print_menu
    return
  fi
  local i=1
  declare -A actual_names
  for tool in "${stars[@]}"; do
    display_name=$(get_display_name "$tool")
    [[ -z "$display_name" ]] && display_name="$tool"
    echo -e "${YELLOW}[$i] $display_name${NC}"
    actual_names[$i]="$tool"
    ((i++))
  done
  echo -e "${YELLOW}[b] Back${NC}"
  read -p "Select Tool: " choice
  if [[ "$choice" == "b" ]]; then
    print_menu
  elif [[ "$choice" =~ ^[0-9]+$ && $choice -le ${#stars[@]} ]]; then
    selected="${actual_names[$choice]}"
    if [[ -n "${tools_repo[$selected]}" ]]; then
      phishing_tool_actions "$selected"
    elif [[ -f "./$selected" ]]; then
      run_sh_file_menu "./$selected"
    else
      echo -e "${RED}Tool '$selected' not found.${NC}"
      sleep 2
    fi
  else
    echo -e "${RED}Invalid option.${NC}"
    sleep 1
  fi
  special_tools_menu
}
#==== Run Any .sh File Menu ====#
run_any_sh_menu() {
  display_greeting
  mapfile -t sh_files < <(find . -maxdepth 1 -name "*.sh")
  if [[ ${#sh_files[@]} -eq 0 ]]; then
    echo -e "${RED}No .sh files found.${NC}"
    sleep 2
    print_menu
    return
  fi
  local i=1
  for file in "${sh_files[@]}"; do
    base="${file##*/}"
    display_name=$(grep "^$base:" "$DISPLAY_NAMES_FILE" | cut -d':' -f2- | head -n1)
    [[ -z "$display_name" ]] && display_name="$base"
    echo -e "${YELLOW}[$i] $display_name${NC}"
    ((i++))
  done
  echo -e "${YELLOW}[b] Back${NC}"
  read -p "Choose file: " choice
  if [[ "$choice" == "b" ]]; then
    print_menu
  elif [[ "$choice" =~ ^[0-9]+$ && $choice -le ${#sh_files[@]} ]]; then
    run_sh_file_menu "${sh_files[$((choice-1))]}"
  else
    echo -e "${RED}Invalid input.${NC}"
    sleep 1
    run_any_sh_menu
  fi
}
#==== Run .sh File Actions ====#
run_sh_file_menu() {
  local file="$1"
  local base="${file##*/}"
  display_greeting
  echo -e "${YELLOW}[1] Run${NC}"
  echo -e "${YELLOW}[2] Rename Display Name${NC}"
  echo -e "${YELLOW}[3] Add/Remove Star${NC}"
  echo -e "${YELLOW}[4] Delete File${NC}"
  echo -e "${YELLOW}[0] Back${NC}"
  read -p "Choose: " act
  case $act in
    1) bash "$file" ;;
    2)
      read -p "New display name: " newname
      grep -v "^$base:" "$DISPLAY_NAMES_FILE" > temp && mv temp "$DISPLAY_NAMES_FILE"
      echo "$base:$newname" >> "$DISPLAY_NAMES_FILE"
      echo -e "${GREEN}Renamed.${NC}"
      ;;
    3)
      if grep -q "^$base$" "$SPECIAL_FILE"; then
        grep -v "^$base$" "$SPECIAL_FILE" > temp && mv temp "$SPECIAL_FILE"
        echo -e "${YELLOW}Star removed.${NC}"
      else
        echo "$base" >> "$SPECIAL_FILE"
        echo -e "${YELLOW}Star added.${NC}"
      fi
      ;;
    4)
      rm -f "$file"
      grep -v "^$base:" "$DISPLAY_NAMES_FILE" > temp && mv temp "$DISPLAY_NAMES_FILE"
      grep -v "^$base$" "$SPECIAL_FILE" > temp && mv temp "$SPECIAL_FILE"
      echo -e "${RED}Deleted.${NC}"
      run_any_sh_menu
      ;;
    0) run_any_sh_menu ;;
    *) echo -e "${RED}Invalid.${NC}" ;;
  esac
  read -p "Press Enter to return..."
  run_sh_file_menu "$file"
}
#==== Start Script ====#
print_menu



chmod +x piyas-boss.sh


./piyas-boss.sh
nano piyas-boss.sh


#!/data/data/com.termux/files/usr/bin/bash
#==== Color Codes ====#
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
CYAN='\033[1;36m'
NC='\033[0m'
#==== Files ====#
SPECIAL_FILE="special-tools.txt"
DISPLAY_NAMES_FILE="display-names.txt"
touch "$SPECIAL_FILE"
touch "$DISPLAY_NAMES_FILE"
#==== Tools Repository ====#
declare -A tools_repo=(
  ["Zphisher"]="rm -rf zphisher && git clone --depth=1 https://github.com/htr-tech/zphisher.git && cd zphisher && bash zphisher.sh"
  ["ShellPhish"]="apt update && apt upgrade -y && apt install git wget php unzip curl -y && rm -rf ShellPhish && git clone https://github.com/AbirHasan2005/ShellPhish && cd ShellPhish && chmod +x * && bash shellphish.sh"
  ["Shark"]="pkg update -y && pkg install wget -y && wget -qO- https://github.com/Bhaviktutorials/shark/raw/master/setup | bash"
  ["Tool-X"]="apt update && apt upgrade -y && pkg install git -y && rm -rf Tool-X && git clone https://github.com/rajkumardusad/Tool-X.git && cd Tool-X && chmod +x install.aex && bash install.aex && Tool-X"
)
#==== Greeting Function ====#
display_greeting() {
  clear
  echo -e "${CYAN}=========================================${NC}"
  echo -e "${GREEN}       ░P░I░Y░A░S░ ░B░O░S░S░${NC}"
  echo -e "${CYAN}-----------------------------------------${NC}"
  echo -e "${YELLOW}Time: $(date +"%I:%M %p")  Date: $(date +"%d-%m-%Y")${NC}"
  echo -e "${CYAN}=========================================${NC}"
}
#==== Display Name Fetch ====#
get_display_name() {
  grep "^$1:" "$DISPLAY_NAMES_FILE" | cut -d':' -f2- | head -n1
}
#==== Get Star Mark ====#
get_star() {
  grep -q "^$1$" "$SPECIAL_FILE" && echo " *" || echo ""
}
#==== Main Menu ====#
print_menu() {
  display_greeting
  echo -e "${YELLOW}[1] System Setup${NC}"
  echo -e "${YELLOW}[2] Phishing Tools${NC}"
  echo -e "${YELLOW}[3] Special Tools${NC}"
  echo -e "${YELLOW}[4] Run Any .sh File${NC}"
  echo -e "${YELLOW}[0] Exit${NC}"
  read -p "Choose an option: " opt
  case $opt in
    1) system_setup_menu ;;
    2) phishing_tools_menu ;;
    3) special_tools_menu ;;
    4) run_any_sh_menu ;;
    0) exit 0 ;;
    *) echo -e "${RED}Invalid option.${NC}"
       sleep 1
       print_menu ;;
  esac
}
#==== System Setup Menu ====#
system_setup_menu() {
  display_greeting
  echo -e "${CYAN}----- System Setup -----${NC}"
  echo -e "${YELLOW}[1] apt update${NC}"
  echo -e "${YELLOW}[2] apt upgrade -y${NC}"
  echo -e "${YELLOW}[3] Install python${NC}"
  echo -e "${YELLOW}[4] Install python2${NC}"
  echo -e "${YELLOW}[5] Install git${NC}"
  echo -e "${YELLOW}[6] Clone & Setup termux-setup-${NC}"
  echo -e "${YELLOW}[0] Back${NC}"
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
    0) print_menu ;;
    *) echo -e "${RED}Invalid option.${NC}"; sleep 1 ;;
  esac
  read -p "Press Enter to return..."
  system_setup_menu
}
#==== Phishing Tools Menu ====#
phishing_tools_menu() {
  display_greeting
  echo -e "${CYAN}----- Phishing Tools -----${NC}"
  local i=1
  tools_arr=()
  for tool in "${!tools_repo[@]}"; do
    tools_arr+=("$tool")
    display_name=$(get_display_name "$tool")
    [[ -z "$display_name" ]] && display_name="$tool"
    printf "${YELLOW}[%d] %-20s${NC}%s\n" "$i" "$display_name" "$(get_star "$tool")"
    ((i++))
  done
  echo -e "${YELLOW}[b] Back${NC}"
  read -p "Select Tool: " choice
  if [[ "$choice" == "b" ]]; then
    print_menu
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
#==== Phishing Tool Actions ====#
phishing_tool_actions() {
  local tool="$1"
  display_name=$(get_display_name "$tool")
  [[ -z "$display_name" ]] && display_name="$tool"
  display_greeting
  echo -e "${CYAN}--- $display_name Menu ---${NC}"
  echo -e "${YELLOW}[1] Install${NC}"
  echo -e "${YELLOW}[2] Run${NC}"
  echo -e "${YELLOW}[3] Update${NC}"
  echo -e "${YELLOW}[4] Toggle Star${NC}"
  echo -e "${YELLOW}[5] Rename Display Name${NC}"
  echo -e "${YELLOW}[6] Remove Tool Directory${NC}"
  echo -e "${YELLOW}[0] Back${NC}"
  read -p "Choose: " opt
  case $opt in
    1) eval "${tools_repo[$tool]}" && echo -e "${GREEN}$tool Installed.${NC}" ;;
    2) eval "${tools_repo[$tool]}" ;;
    3) update_tool "$tool" ;;
    4) toggle_star "$tool" ;;
    5) rename_display_name "$tool" ;;
    6) rm -rf "$tool" && echo -e "${RED}$tool removed.${NC}" ;;
    0) phishing_tools_menu ;;
    *) echo -e "${RED}Invalid option.${NC}" ;;
  esac
  read -p "Press Enter to return..."
  phishing_tool_actions "$tool"
}
#==== Rename Display Name ====#
rename_display_name() {
  local tool="$1"
  read -p "New display name: " newname
  grep -v "^$tool:" "$DISPLAY_NAMES_FILE" > temp && mv temp "$DISPLAY_NAMES_FILE"
  echo "$tool:$newname" >> "$DISPLAY_NAMES_FILE"
  echo -e "${GREEN}Display name updated!${NC}"
}
#==== Toggle Star ====#
toggle_star() {
  local tool="$1"
  if grep -q "^$tool$" "$SPECIAL_FILE"; then
    grep -v "^$tool$" "$SPECIAL_FILE" > temp && mv temp "$SPECIAL_FILE"
    echo -e "${YELLOW}Star removed.${NC}"
  else
    echo "$tool" >> "$SPECIAL_FILE"
    echo -e "${YELLOW}Star added.${NC}"
  fi
}
#==== Update Tool ====#
update_tool() {
  local tool="$1"
  echo -e "${CYAN}Updating $tool...${NC}"
  case $tool in
    "Zphisher") cd zphisher && git pull && cd .. ;;
    "ShellPhish") cd ShellPhish && git pull && cd .. ;;
    "Tool-X") cd Tool-X && git pull && cd .. ;;
    "Shark") echo -e "${GREEN}Update handled by setup script.${NC}" ;;
    *) echo -e "${RED}No update logic defined.${NC}" ;;
  esac
  echo -e "${GREEN}$tool updated.${NC}"
}
#==== Special Tools Menu ====#
special_tools_menu() {
  display_greeting
  echo -e "${CYAN}----- Special Tools -----${NC}"
  mapfile -t stars < "$SPECIAL_FILE"
  if [[ ${#stars[@]} -eq 0 ]]; then
    echo -e "${RED}No starred tools.${NC}"
    sleep 2
    print_menu
    return
  fi
  local i=1
  declare -A actual_names
  for tool in "${stars[@]}"; do
    display_name=$(get_display_name "$tool")
    [[ -z "$display_name" ]] && display_name="$tool"
    echo -e "${YELLOW}[$i] $display_name${NC}"
    actual_names[$i]="$tool"
    ((i++))
  done
  echo -e "${YELLOW}[b] Back${NC}"
  read -p "Select Tool: " choice
  if [[ "$choice" == "b" ]]; then
    print_menu
  elif [[ "$choice" =~ ^[0-9]+$ && $choice -le ${#stars[@]} ]]; then
    selected="${actual_names[$choice]}"
    if [[ -n "${tools_repo[$selected]}" ]]; then
      phishing_tool_actions "$selected"
    elif [[ -f "./$selected" ]]; then
      run_sh_file_menu "./$selected"
    else
      echo -e "${RED}Tool '$selected' not found.${NC}"
      sleep 2
    fi
  else
    echo -e "${RED}Invalid option.${NC}"
    sleep 1
  fi
  special_tools_menu
}
#==== Run Any .sh File Menu ====#
run_any_sh_menu() {
  display_greeting
  mapfile -t sh_files < <(find . -maxdepth 1 -name "*.sh")
  if [[ ${#sh_files[@]} -eq 0 ]]; then
    echo -e "${RED}No .sh files found.${NC}"
    sleep 2
    print_menu
    return
  fi
  local i=1
  for file in "${sh_files[@]}"; do
    base="${file##*/}"
    display_name=$(grep "^$base:" "$DISPLAY_NAMES_FILE" | cut -d':' -f2- | head -n1)
    [[ -z "$display_name" ]] && display_name="$base"
    echo -e "${YELLOW}[$i] $display_name${NC}"
    ((i++))
  done
  echo -e "${YELLOW}[b] Back${NC}"
  read -p "Choose file: " choice
  if [[ "$choice" == "b" ]]; then
    print_menu
  elif [[ "$choice" =~ ^[0-9]+$ && $choice -le ${#sh_files[@]} ]]; then
    run_sh_file_menu "${sh_files[$((choice-1))]}"
  else
    echo -e "${RED}Invalid input.${NC}"
    sleep 1
    run_any_sh_menu
  fi
}
#==== Run .sh File Actions ====#
run_sh_file_menu() {
  local file="$1"
  local base="${file##*/}"
  display_greeting
  echo -e "${YELLOW}[1] Run${NC}"
  echo -e "${YELLOW}[2] Rename Display Name${NC}"
  echo -e "${YELLOW}[3] Add/Remove Star${NC}"
  echo -e "${YELLOW}[4] Delete File${NC}"
  echo -e "${YELLOW}[0] Back${NC}"
  read -p "Choose: " act
  case $act in
    1) bash "$file" ;;
    2)
      read -p "New display name: " newname
      grep -v "^$base:" "$DISPLAY_NAMES_FILE" > temp && mv temp "$DISPLAY_NAMES_FILE"
      echo "$base:$newname" >> "$DISPLAY_NAMES_FILE"
      echo -e "${GREEN}Renamed.${NC}"
      ;;
    3)
      if grep -q "^$base$" "$SPECIAL_FILE"; then
        grep -v "^$base$" "$SPECIAL_FILE" > temp && mv temp "$SPECIAL_FILE"
        echo -e "${YELLOW}Star removed.${NC}"
      else
        echo "$base" >> "$SPECIAL_FILE"
        echo -e "${YELLOW}Star added.${NC}"
      fi
      ;;
    4)
      rm -f "$file"
      grep -v "^$base:" "$DISPLAY_NAMES_FILE" > temp && mv temp "$DISPLAY_NAMES_FILE"
      grep -v "^$base$" "$SPECIAL_FILE" > temp && mv temp "$SPECIAL_FILE"
      echo -e "${RED}Deleted.${NC}"
      run_any_sh_menu
      ;;
    0) run_any_sh_menu ;;
    *) echo -e "${RED}Invalid.${NC}" ;;
  esac
  read -p "Press Enter to return..."
  run_sh_file_menu "$file"
}
#==== Start Script ====#
print_menu