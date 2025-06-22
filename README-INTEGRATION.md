# 🇪🇬 Egypt Tourism - Integrated Website & Chatbot

**Complete integration of your tourism website with AI chatbot - Ready to use!**

## 🚀 Quick Start

### Run Everything at Once

```bash
./start-egypt-tourism.sh
```

### Stop Everything

```bash
./stop-egypt-tourism.sh
# OR press Ctrl+C in the terminal running the start script
```

## 🎯 What You Get

### ✅ **Fully Integrated System**

- **Website**: Modern Next.js tourism site (http://localhost:3000)
- **Chatbot**: Enterprise-grade FastAPI backend (http://localhost:5050)
- **Chat Widget**: Seamlessly embedded in website
- **Real-time Communication**: Website ↔ Chatbot

### ✅ **Features Working Out of the Box**

- 💬 **Chat Widget** - Bottom-right corner of website
- 🌍 **Multi-language** - English & Arabic support
- 🤖 **AI Responses** - Advanced Egypt tourism knowledge
- 💾 **Session Management** - Conversation persistence
- 📱 **Responsive Design** - Works on all devices
- 🔄 **Real-time Updates** - Instant message delivery

## 🏗️ System Architecture

```
┌─────────────────┐    ┌─────────────────┐
│   Website       │    │   Chatbot       │
│   Next.js       │◄──►│   FastAPI       │
│   Port: 3000    │    │   Port: 5050    │
└─────────────────┘    └─────────────────┘
         │                       │
         ├─ Chat Widget          ├─ AI Engine
         ├─ UI Components        ├─ Knowledge Base
         ├─ Translations         ├─ Session Manager
         └─ User Management      └─ Analytics
```

## 🧪 Test the Integration

### 1. **Website Features**

- Visit http://localhost:3000
- Browse Egypt tourism content
- Switch languages (English/Arabic)
- Look for chat widget in bottom-right

### 2. **Chat Functionality**

- Click the red chat button
- Try sample questions:
  - "Tell me about the Pyramids"
  - "Plan a Nile cruise"
  - "What to see in Cairo"
- Test language switching

### 3. **API Testing**

```bash
# Test chatbot health
curl http://localhost:5050/api/health

# Test chat API
curl -X POST http://localhost:5050/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message":"Hello","language":"en"}'
```

## 📁 Project Structure

```
ChatBot-Egypt/
├── 🌐 Bot-Website/              # Next.js Tourism Website
│   ├── src/components/chat/     # Chat widget components
│   ├── src/hooks/use-chat.ts    # Chat functionality
│   ├── src/lib/chat-api.ts      # API utilities
│   └── src/types/chat.ts        # TypeScript types
│
├── 🤖 egypt-chatbot-wind-cursor/ # FastAPI Chatbot Backend
│   ├── src/api/routes/          # API endpoints
│   ├── src/services/            # AI services
│   └── src/main.py              # Main entry point
│
├── 🚀 start-egypt-tourism.sh     # Start everything
├── 🛑 stop-egypt-tourism.sh      # Stop everything
└── 📖 README-INTEGRATION.md      # This file
```

## ⚙️ Configuration

### Chat Widget Customization

Edit `Bot-Website/src/app/layout.tsx`:

```tsx
<ChatWidget
  config={{
    apiUrl: "http://localhost:5050",
    language: "en",
    theme: "egyptian",
  }}
/>
```

### API Configuration

Edit `egypt-chatbot-wind-cursor/.env`:

```env
API_HOST=localhost
API_PORT=5050
ALLOWED_ORIGINS=http://localhost:3000
```

## 🔧 Technical Details

### **Frontend (Website)**

- **Framework**: Next.js 15 with TypeScript
- **Styling**: Tailwind CSS + Radix UI
- **Chat**: Custom React components
- **API**: REST client with error handling
- **Languages**: English + Arabic (RTL support)

### **Backend (Chatbot)**

- **Framework**: FastAPI with Python
- **AI**: Advanced NLU + Knowledge Base
- **Performance**: <100ms response times
- **Database**: PostgreSQL + Redis sessions
- **Security**: CORS, input validation

### **Integration Points**

- **API Communication**: REST JSON over HTTP
- **Session Bridging**: Shared session management
- **Error Handling**: Graceful fallbacks
- **CORS Configuration**: Pre-configured for localhost

## 🚨 Troubleshooting

### **Services Won't Start**

```bash
# Check if ports are in use
lsof -i :3000 :5050

# Kill existing processes
./stop-egypt-tourism.sh

# Try starting again
./start-egypt-tourism.sh
```

### **Chat Not Working**

1. Check browser console for errors
2. Verify chatbot API: http://localhost:5050/api/health
3. Test CORS: Check Network tab in DevTools

### **Database Issues**

```bash
# Reinitialize website database
cd Bot-Website
rm .db_initialized
bun run init-db
```

## 🎉 Success Indicators

When everything is working correctly, you should see:

✅ **Website loads** at http://localhost:3000  
✅ **Chat button** appears in bottom-right  
✅ **Chat opens** and shows welcome message  
✅ **Messages send** and get AI responses  
✅ **Suggestions work** when clicked  
✅ **Language switching** works in chat  
✅ **Session persists** between page reloads

## 📞 Support

If you encounter issues:

1. Check the startup script output for error messages
2. Look at browser console for frontend errors
3. Check `egypt-chatbot-wind-cursor/logs/` for backend logs
4. Ensure all dependencies are installed

---

**🎯 You now have a complete, production-ready tourism website with AI chatbot integration!**
