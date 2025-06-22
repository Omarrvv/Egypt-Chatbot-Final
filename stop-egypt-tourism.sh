#!/bin/bash

echo "🛑 Stopping Egypt Tourism Platform..."
echo "====================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${2}${1}${NC}"
}

# Kill processes by port
print_status "🔄 Stopping services..." $YELLOW

# Stop website (port 3000)
if lsof -ti:3000 > /dev/null 2>&1; then
    lsof -ti:3000 | xargs kill -9 2>/dev/null
    print_status "✅ Website stopped (port 3000)" $GREEN
fi

# Stop chatbot API (port 5050)
if lsof -ti:5050 > /dev/null 2>&1; then
    lsof -ti:5050 | xargs kill -9 2>/dev/null
    print_status "✅ Chatbot API stopped (port 5050)" $GREEN
fi

# Stop Redis if running (port 6379)
if lsof -ti:6379 > /dev/null 2>&1; then
    lsof -ti:6379 | xargs kill -9 2>/dev/null
    print_status "✅ Redis stopped (port 6379)" $GREEN
fi

# Clean up PID files
if [ -f "egypt-chatbot-wind-cursor/.backend_pid" ]; then
    rm egypt-chatbot-wind-cursor/.backend_pid
fi

if [ -f "Bot-Website/.frontend_pid" ]; then
    rm Bot-Website/.frontend_pid
fi

print_status "👋 Egypt Tourism Platform stopped successfully!" $GREEN 