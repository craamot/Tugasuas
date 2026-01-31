#!/bin/bash
# 📋 SETUP & VERIFICATION SCRIPT
# Run ini untuk memverifikasi semua file sudah dibuat dengan benar

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  🚀 SQLite Integration - Setup Verification                   ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counter
passed=0
failed=0

# Function untuk check file
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        ((passed++))
    else
        echo -e "${RED}✗${NC} $1 (MISSING)"
        ((failed++))
    fi
}

echo -e "${BLUE}📁 Checking Files...${NC}"
echo ""

# Check database files
echo "Database Layer:"
check_file "lib/database/db_helper.dart"

# Check model files
echo ""
echo "Model Layer:"
check_file "lib/models/user.dart"

# Check UI files
echo ""
echo "UI Layer:"
check_file "lib/screens/login_page.dart"
check_file "lib/screens/register_page.dart"

# Check example files
echo ""
echo "Examples:"
check_file "lib/examples/database_examples.dart"

# Check main files
echo ""
echo "Main App:"
check_file "lib/main.dart"
check_file "pubspec.yaml"

# Check documentation
echo ""
echo "Documentation:"
check_file "00_START_HERE.md"
check_file "README_SQLITE.md"
check_file "QUICK_START.md"
check_file "SQLITE_INTEGRATION.md"
check_file "IMPLEMENTATION_CHECKLIST.md"
check_file "SUMMARY.md"

# Results
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo -e "${BLUE}📊 Results:${NC}"
echo -e "   ${GREEN}Passed:${NC} $passed"
echo -e "   ${RED}Failed:${NC} $failed"
echo "╚════════════════════════════════════════════════════════════════╝"

if [ $failed -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ All files are in place!${NC}"
    echo ""
    echo "📋 Next Steps:"
    echo "   1. Run: flutter pub get"
    echo "   2. Run: flutter clean && flutter pub get && flutter run"
    echo "   3. Test register & login"
    echo "   4. Read 00_START_HERE.md for more info"
else
    echo ""
    echo -e "${RED}✗ Some files are missing!${NC}"
    echo "   Please ensure all files are created correctly."
fi

echo ""
echo "🎉 Happy Coding!"
echo ""
