#!/bin/bash

echo "🇪🇬 EGYPT TOURISM - INTEGRATED WEBSITE & CHATBOT"
echo "================================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${2}${1}${NC}"
}

print_status "🚀 Starting Egypt Tourism Platform..." $CYAN
echo ""

# Kill any existing processes
print_status "🔄 Cleaning up existing processes..." $YELLOW
lsof -ti:3000 | xargs kill -9 2>/dev/null || true  # Website
lsof -ti:5050 | xargs kill -9 2>/dev/null || true  # Chatbot API
lsof -ti:6379 | xargs kill -9 2>/dev/null || true  # Redis (if running)
print_status "✅ Ports cleared (3000, 5050, 6379)" $GREEN
echo ""

# Check if we're in the right directory
if [ ! -d "Bot-Website" ] || [ ! -d "egypt-chatbot-wind-cursor" ]; then
    print_status "❌ Please run this script from the ChatBot-Egypt directory" $RED
    exit 1
fi

# ============================================================================
# CHATBOT BACKEND SETUP
# ============================================================================

print_status "🤖 Setting up Chatbot Backend..." $BLUE
cd egypt-chatbot-wind-cursor

# Check backend dependencies
if ! command -v python &> /dev/null; then
    print_status "❌ Python not found! Please install Python 3.8+." $RED
    exit 1
fi

# Check if virtual environment exists and activate it
if [ -d "venv" ]; then
    print_status "🐍 Activating virtual environment..." $YELLOW
    source venv/bin/activate
elif [ -d ".venv" ]; then
    print_status "🐍 Activating virtual environment..." $YELLOW
    source .venv/bin/activate
else
    print_status "⚠️ No virtual environment found. Using system Python." $YELLOW
fi

# Install backend dependencies if needed
if [ ! -f "requirements_installed.marker" ]; then
    print_status "📥 Installing backend dependencies..." $YELLOW
    pip install -r requirements.txt
    touch requirements_installed.marker
    print_status "✅ Backend dependencies installed!" $GREEN
fi

# Start the FastAPI backend
print_status "🚀 Starting Chatbot API (port 5050)..." $BLUE
python src/main.py &
BACKEND_PID=$!
echo $BACKEND_PID > .backend_pid
print_status "Backend PID: $BACKEND_PID" $CYAN

# Go back to project root
cd ..

# ============================================================================
# WEBSITE FRONTEND SETUP
# ============================================================================

print_status "🌐 Setting up Website Frontend..." $BLUE
cd Bot-Website

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_status "❌ Node.js not found! Please install Node.js 18+." $RED
    exit 1
fi

# Check if bun is installed, fallback to npm
if command -v bun &> /dev/null; then
    PACKAGE_MANAGER="bun"
    print_status "📦 Using Bun package manager" $GREEN
else
    PACKAGE_MANAGER="npm"
    print_status "📦 Using NPM package manager" $YELLOW
fi

# Install frontend dependencies if needed
if [ ! -d "node_modules" ]; then
    print_status "📥 Installing frontend dependencies..." $YELLOW
    $PACKAGE_MANAGER install
    print_status "✅ Frontend dependencies installed!" $GREEN
fi

# Initialize database if needed
print_status "🗄️ Checking database..." $BLUE
if [ ! -f ".db_initialized" ]; then
    print_status "📥 Initializing website database..." $YELLOW
    $PACKAGE_MANAGER run init-db
    touch .db_initialized
    print_status "✅ Database initialized!" $GREEN
fi

# Start the Next.js website
print_status "🚀 Starting Website (port 3000)..." $BLUE
$PACKAGE_MANAGER run dev &
FRONTEND_PID=$!
echo $FRONTEND_PID > .frontend_pid
print_status "Frontend PID: $FRONTEND_PID" $CYAN

# Go back to project root
cd ..

# ============================================================================
# HEALTH CHECKS & STARTUP VERIFICATION
# ============================================================================

echo ""
print_status "⏳ Waiting for services to initialize..." $YELLOW
print_status "   (Chatbot needs time to load AI models...)" $YELLOW
print_status "   (Website needs time to compile...)" $YELLOW

# Wait up to 90 seconds for backend to be ready
print_status "🔄 Testing chatbot API connection..." $BLUE
for i in {1..90}; do
    if curl -s http://localhost:5050/api/health > /dev/null 2>&1; then
        print_status "✅ Chatbot API is healthy! (Ready in ${i}s)" $GREEN
        BACKEND_READY=true
        break
    fi
    if [ $i -eq 90 ]; then
        print_status "❌ Chatbot failed to start after 90s. Check the logs." $RED
        kill $FRONTEND_PID 2>/dev/null || true
        exit 1
    fi
    echo -n "."
    sleep 1
done

echo ""

# Wait up to 60 seconds for frontend to be ready
print_status "🔄 Testing website connection..." $BLUE
for i in {1..60}; do
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        print_status "✅ Website is running! (Ready in ${i}s)" $GREEN
        FRONTEND_READY=true
        break
    fi
    if [ $i -eq 60 ]; then
        print_status "❌ Website failed to start after 60s." $RED
        kill $BACKEND_PID 2>/dev/null || true
        exit 1
    fi
    echo -n "."
    sleep 1
done

echo ""

# ============================================================================
# INTEGRATION TESTS
# ============================================================================

print_status "🧪 Running integration tests..." $BLUE

# Test backend health
if curl -s http://localhost:5050/api/health | grep -q "healthy\|ok\|ready"; then
    print_status "✅ Chatbot health check passed" $GREEN
else
    print_status "⚠️ Chatbot health check unclear" $YELLOW
fi

# Test CORS configuration
if curl -s -H "Origin: http://localhost:3000" -I http://localhost:5050/api/health | grep -q "Access-Control-Allow-Origin"; then
    print_status "✅ CORS configuration working" $GREEN
else
    print_status "⚠️ CORS headers may need attention" $YELLOW
fi

# Test chat endpoint
if curl -s -X POST http://localhost:5050/api/chat \
   -H "Content-Type: application/json" \
   -H "Origin: http://localhost:3000" \
   -d '{"message":"Hello","language":"en"}' | grep -q "session_id\|text"; then
    print_status "✅ Chat API working" $GREEN
else
    print_status "⚠️ Chat API may have issues" $YELLOW
fi

echo ""

# ============================================================================
# SUCCESS MESSAGE & INFORMATION
# ============================================================================

print_status "🎉 EGYPT TOURISM PLATFORM IS READY!" $GREEN
print_status "====================================" $GREEN
echo ""
print_status "🌐 Website: http://localhost:3000" $CYAN
print_status "🤖 Chatbot API: http://localhost:5050" $CYAN
print_status "📋 API Health: http://localhost:5050/api/health" $CYAN
print_status "📚 API Docs: http://localhost:5050/docs" $CYAN
echo ""

print_status "💬 CHAT INTEGRATION:" $PURPLE
print_status "==================" $PURPLE
print_status "✨ Chat widget appears in bottom-right corner" $CYAN
print_status "🔄 Real-time communication between website & chatbot" $CYAN
print_status "🌍 Multi-language support (English & Arabic)" $CYAN
print_status "💾 Session management and user preferences" $CYAN
echo ""

print_status "🛑 TO STOP ALL SERVICES:" $YELLOW
print_status "========================" $YELLOW
print_status "   Ctrl+C in this terminal" $CYAN
print_status "   Or run: ./stop-egypt-tourism.sh" $CYAN
echo ""

# Open the website in default browser
print_status "🌐 Opening website in your browser..." $PURPLE

if command -v open &> /dev/null; then
    # macOS
    open http://localhost:3000
elif command -v xdg-open &> /dev/null; then
    # Linux
    xdg-open http://localhost:3000
elif command -v start &> /dev/null; then
    # Windows
    start http://localhost:3000
else
    print_status "🔗 Please open: http://localhost:3000" $CYAN
fi

# ============================================================================
# KEEP RUNNING AND HANDLE SHUTDOWN
# ============================================================================

# Function to cleanup on exit
cleanup() {
    echo ""
    print_status "🛑 Shutting down Egypt Tourism Platform..." $YELLOW
    
    # Kill backend
    if [ -f "egypt-chatbot-wind-cursor/.backend_pid" ]; then
        BACKEND_PID=$(cat egypt-chatbot-wind-cursor/.backend_pid)
        kill $BACKEND_PID 2>/dev/null || true
        rm egypt-chatbot-wind-cursor/.backend_pid 2>/dev/null || true
        print_status "✅ Chatbot API stopped" $GREEN
    fi
    
    # Kill frontend
    if [ -f "Bot-Website/.frontend_pid" ]; then
        FRONTEND_PID=$(cat Bot-Website/.frontend_pid)
        kill $FRONTEND_PID 2>/dev/null || true
        rm Bot-Website/.frontend_pid 2>/dev/null || true
        print_status "✅ Website stopped" $GREEN
    fi
    
    print_status "👋 Egypt Tourism Platform stopped successfully!" $GREEN
    exit 0
}

# Trap Ctrl+C
trap cleanup SIGINT SIGTERM

print_status "✨ Platform is running! Press Ctrl+C to stop all services." $GREEN
print_status "📊 Monitoring logs..." $CYAN
echo ""

# Keep the script running and show basic monitoring
while true; do
    # Check if both services are still running
    if ! kill -0 $BACKEND_PID 2>/dev/null; then
        print_status "❌ Chatbot API has stopped unexpectedly!" $RED
        break
    fi
    
    if ! kill -0 $FRONTEND_PID 2>/dev/null; then
        print_status "❌ Website has stopped unexpectedly!" $RED
        break
    fi
    
    sleep 10
done

# If we get here, something went wrong
cleanup 