#!/bin/bash

# Okiro Beta Repository Restructure Script
# This script automatically organizes all addons into proper categories

echo "🚀 Starting Okiro Beta restructure..."
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo "${RED}❌ Error: Not a git repository!${NC}"
    echo "Please run this script from the root of okiro_beta repository"
    exit 1
fi

echo "${YELLOW}📁 Creating new directory structure...${NC}"

# Create main category directories
mkdir -p okiro_core
mkdir -p okiro_ui
mkdir -p okiro_gameplay
mkdir -p admin
mkdir -p third_party
mkdir -p workshop

echo "${GREEN}✓ Directories created${NC}"
echo ""

echo "${YELLOW}📦 Moving Okiro Core modules...${NC}"
git mv _okiro_main_system okiro_core/ 2>/dev/null && echo "  ✓ _okiro_main_system"
git mv _okiro_main_level okiro_core/ 2>/dev/null && echo "  ✓ _okiro_main_level"
git mv _okiro_sololeveling_mob okiro_core/ 2>/dev/null && echo "  ✓ _okiro_sololeveling_mob"
git mv _okiro_tlib okiro_core/ 2>/dev/null && echo "  ✓ _okiro_tlib"
git mv _okiro_ost okiro_core/ 2>/dev/null && echo "  ✓ _okiro_ost"
echo ""

echo "${YELLOW}🎨 Moving Okiro UI modules...${NC}"
git mv _okiro_hud okiro_ui/ 2>/dev/null && echo "  ✓ _okiro_hud"
git mv _okiro_tab okiro_ui/ 2>/dev/null && echo "  ✓ _okiro_tab"
git mv _okiro_esc okiro_ui/ 2>/dev/null && echo "  ✓ _okiro_esc"
git mv _okiro_deathscreen okiro_ui/ 2>/dev/null && echo "  ✓ _okiro_deathscreen"
echo ""

echo "${YELLOW}🎮 Moving Okiro Gameplay modules...${NC}"
git mv _okiro_weapon_selector okiro_gameplay/ 2>/dev/null && echo "  ✓ _okiro_weapon_selector"
git mv _okiro_revive okiro_gameplay/ 2>/dev/null && echo "  ✓ _okiro_revive"
git mv _okiro_reroll_system okiro_gameplay/ 2>/dev/null && echo "  ✓ _okiro_reroll_system"
git mv _okiro_inconnu okiro_gameplay/ 2>/dev/null && echo "  ✓ _okiro_inconnu"
echo ""

echo "${YELLOW}🛡️ Moving Admin systems...${NC}"
git mv sam-156 admin/ 2>/dev/null && echo "  ✓ sam-156"
git mv awarn3 admin/ 2>/dev/null && echo "  ✓ awarn3"
git mv improved_admin_system admin/ 2>/dev/null && echo "  ✓ improved_admin_system"
echo ""

echo "${YELLOW}📚 Moving Third Party addons...${NC}"
git mv mc_quests third_party/ 2>/dev/null && echo "  ✓ mc_quests"
git mv mc_simple_npcs third_party/ 2>/dev/null && echo "  ✓ mc_simple_npcs"
git mv chatbox third_party/ 2>/dev/null && echo "  ✓ chatbox"
git mv voice third_party/ 2>/dev/null && echo "  ✓ voice"
git mv the_perfect_training_system third_party/ 2>/dev/null && echo "  ✓ the_perfect_training_system"
git mv squad_reborn third_party/ 2>/dev/null && echo "  ✓ squad_reborn"
git mv employer_npc third_party/ 2>/dev/null && echo "  ✓ employer_npc"
git mv npcstorerob third_party/ 2>/dev/null && echo "  ✓ npcstorerob"
git mv darkrp_old_advert third_party/ 2>/dev/null && echo "  ✓ darkrp_old_advert"
git mv tebexgmod third_party/ 2>/dev/null && echo "  ✓ tebexgmod"
git mv whitelist third_party/ 2>/dev/null && echo "  ✓ whitelist"
git mv nordal_whitelist third_party/ 2>/dev/null && echo "  ✓ nordal_whitelist"
git mv sui third_party/ 2>/dev/null && echo "  ✓ sui"
git mv msd_ui third_party/ 2>/dev/null && echo "  ✓ msd_ui"
git mv glibs third_party/ 2>/dev/null && echo "  ✓ glibs"
git mv pac_admin third_party/ 2>/dev/null && echo "  ✓ pac_admin"
git mv pacres third_party/ 2>/dev/null && echo "  ✓ pacres"
git mv improved_fps_booster third_party/ 2>/dev/null && echo "  ✓ improved_fps_booster"
git mv particle_loader third_party/ 2>/dev/null && echo "  ✓ particle_loader"
git mv autorun_taxi_teleport third_party/ 2>/dev/null && echo "  ✓ autorun_taxi_teleport"
git mv nokill third_party/ 2>/dev/null && echo "  ✓ nokill"
git mv blues-decals third_party/ 2>/dev/null && echo "  ✓ blues-decals"
git mv 122 third_party/ 2>/dev/null && echo "  ✓ 122"
echo ""

echo "${YELLOW}🔧 Moving Workshop addons...${NC}"
git mv zworkshop_pac3 workshop/ 2>/dev/null && echo "  ✓ zworkshop_pac3"
git mv zworkshop_gmodlegs workshop/ 2>/dev/null && echo "  ✓ zworkshop_gmodlegs"
git mv zworkshop_simple_thirdperson workshop/ 2>/dev/null && echo "  ✓ zworkshop_simple_thirdperson"
git mv zworkshop_the_sit_anywhere workshop/ 2>/dev/null && echo "  ✓ zworkshop_the_sit_anywhere"
git mv zworkshop_cancelhunger workshop/ 2>/dev/null && echo "  ✓ zworkshop_cancelhunger"
git mv zworkshop_antipropskill workshop/ 2>/dev/null && echo "  ✓ zworkshop_antipropskill"
git mv zworkshop_advanced_duplicator workshop/ 2>/dev/null && echo "  ✓ zworkshop_advanced_duplicator"
git mv zworkshop_precision_tool workshop/ 2>/dev/null && echo "  ✓ zworkshop_precision_tool"
git mv zworkshop_permaprops workshop/ 2>/dev/null && echo "  ✓ zworkshop_permaprops"
git mv zworkshop_3d2d_textscreens workshop/ 2>/dev/null && echo "  ✓ zworkshop_3d2d_textscreens"
echo ""

echo "${YELLOW}🧹 Cleaning up...${NC}"
# Remove .DS_Store files
find . -name ".DS_Store" -type f -delete 2>/dev/null && echo "  ✓ Removed .DS_Store files"
echo ""

echo "${YELLOW}💾 Creating commit...${NC}"
git add .
git status --short
echo ""

read -p "Do you want to commit these changes? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    git commit -m "Реструктуризация: организация аддонов по категориям

- Создана структура папок: okiro_core, okiro_ui, okiro_gameplay, admin, third_party, workshop
- Перемещены все модули в соответствующие категории
- Удалены системные файлы .DS_Store
- Обновлена документация (README.md, STRUCTURE.md, INSTALLATION.md)"
    
    echo ""
    echo "${GREEN}✅ Commit created successfully!${NC}"
    echo ""
    
    read -p "Do you want to push to GitHub? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        git push origin main
        echo ""
        echo "${GREEN}🎉 Restructure complete and pushed to GitHub!${NC}"
    else
        echo "${YELLOW}⚠️  Changes committed locally but not pushed${NC}"
        echo "Run 'git push origin main' when ready to push"
    fi
else
    echo "${RED}❌ Commit cancelled${NC}"
    echo "Changes are staged. Run 'git status' to see them"
    exit 1
fi

echo ""
echo "${GREEN}═══════════════════════════════════════${NC}"
echo "${GREEN}  Okiro Beta Restructure Complete!${NC}"
echo "${GREEN}═══════════════════════════════════════${NC}"
echo ""
echo "New structure:"
echo "  📁 okiro_core/      - Core systems"
echo "  📁 okiro_ui/        - UI modules"
echo "  📁 okiro_gameplay/  - Gameplay mechanics"
echo "  📁 admin/           - Admin systems"
echo "  📁 third_party/     - Third party addons"
echo "  📁 workshop/        - Workshop addons"
echo ""
echo "View the repository: https://github.com/DeusOfSanguis/okiro_beta"
echo ""
