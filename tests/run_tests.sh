#!/bin/bash
# Test Runner Script for OreNPMGuard
# Runs both Python and Node.js test suites

set -euo pipefail

echo "🧪 OreNPMGuard Test Suite"
echo "=" | head -c 60 && echo ""
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
PYTHON_TESTS=0
NODEJS_TESTS=0
PYTHON_PASSED=0
NODEJS_PASSED=0

# Check if Python is available
if command -v python3 &> /dev/null; then
    echo "🐍 Running Python Tests..."
    echo "----------------------------------------"
    cd "$(dirname "$0")/.."
    if python3 -m unittest discover -s tests -p "test_*.py" -v 2>&1 | tee /tmp/python_tests.log; then
        PYTHON_PASSED=1
        echo -e "${GREEN}✅ Python tests passed${NC}"
    else
        echo -e "${RED}❌ Python tests failed${NC}"
    fi
    PYTHON_TESTS=1
    echo ""
else
    echo -e "${YELLOW}⚠️  Python 3 not found, skipping Python tests${NC}"
    echo ""
fi

# Check if Node.js is available
if command -v node &> /dev/null; then
    echo "🟢 Running Node.js Tests..."
    echo "----------------------------------------"
    cd "$(dirname "$0")/.."
    npm install --silent > /dev/null 2>&1
    if node --test tests/test_nodejs_scanner.js 2>&1 | tee /tmp/nodejs_tests.log; then
        NODEJS_PASSED=1
        echo -e "${GREEN}✅ Node.js tests passed${NC}"
    else
        echo -e "${RED}❌ Node.js tests failed${NC}"
    fi
    NODEJS_TESTS=1
    echo ""
else
    echo -e "${YELLOW}⚠️  Node.js not found, skipping Node.js tests${NC}"
    echo ""
fi

# Summary
echo "========================================"
echo "📊 Test Summary:"
echo "----------------------------------------"

if [ $PYTHON_TESTS -eq 1 ]; then
    if [ $PYTHON_PASSED -eq 1 ]; then
        echo -e "🐍 Python: ${GREEN}✅ PASSED${NC}"
    else
        echo -e "🐍 Python: ${RED}❌ FAILED${NC}"
    fi
else
    echo -e "🐍 Python: ${YELLOW}⏭️  SKIPPED${NC}"
fi

if [ $NODEJS_TESTS -eq 1 ]; then
    if [ $NODEJS_PASSED -eq 1 ]; then
        echo -e "🟢 Node.js: ${GREEN}✅ PASSED${NC}"
    else
        echo -e "🟢 Node.js: ${RED}❌ FAILED${NC}"
    fi
else
    echo -e "🟢 Node.js: ${YELLOW}⏭️  SKIPPED${NC}"
fi

echo ""

# Exit with error if any tests failed
if [ $PYTHON_TESTS -eq 1 ] && [ $PYTHON_PASSED -eq 0 ]; then
    exit 1
fi

if [ $NODEJS_TESTS -eq 1 ] && [ $NODEJS_PASSED -eq 0 ]; then
    exit 1
fi

echo -e "${GREEN}🎉 All tests passed!${NC}"
exit 0

