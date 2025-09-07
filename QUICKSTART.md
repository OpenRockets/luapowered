# Getting Started with LuaPowered

Welcome to your journey into hardware programming with Lua! This quick start guide will get you up and running in just a few minutes.

## 🚀 Quick Start (5 minutes)

### 1. Check Your System
```bash
# Check if Lua is installed
lua5.4 -v

# If not installed (Ubuntu/Raspberry Pi):
sudo apt update && sudo apt install lua5.4

# If you're on macOS:
brew install lua

# If you're on Windows:
# Download LuaForWindows from GitHub releases
```

### 2. Try the Demo
```bash
# Clone or download this repository
git clone https://github.com/OpenRockets/luapowered.git
cd luapowered

# Run the LED controller demo
lua5.4 demos/smart_led_controller.lua
```

You should see a simulation of a smart LED controller with multiple patterns!

### 3. Start Learning
Open the [Complete Guide](guide/README.md) and begin with:
1. [What is Lua?](guide/basics/01-what-is-lua.md) - Learn why Lua is perfect for hardware
2. [Your First Program](guide/basics/02-first-program.md) - Write your first Lua script
3. [Hardware Introduction](guide/hardware/01-introduction.md) - Start controlling real hardware

## 📖 Learning Paths

### 🌱 Complete Beginner
**Time**: 6-8 hours  
**Goal**: Build your first LED controller

1. **Lua Basics** (3-4 hours)
   - [What is Lua?](guide/basics/01-what-is-lua.md)
   - [First Program](guide/basics/02-first-program.md) 
   - [Basic Syntax](guide/basics/03-syntax.md)
   - [Control Structures](guide/basics/04-control-structures.md)

2. **First Hardware Project** (2-3 hours)
   - [Hardware Introduction](guide/hardware/01-introduction.md)
   - [LED Blink Project](guide/projects/beginner/01-led-blink.md)

3. **Interactive Hardware** (1-2 hours)
   - [Button Input Project](guide/projects/beginner/02-button-input.md)

### 🔧 Hardware Enthusiast
**Time**: 12-15 hours  
**Goal**: Build a complete IoT weather station

1. Complete the Beginner path (6-8 hours)
2. **Advanced Hardware** (3-4 hours)
   - [GPIO Control](guide/hardware/02-gpio.md)
   - [Sensors and Communication](guide/hardware/05-communication.md)
3. **Intermediate Projects** (5-6 hours)
   - [Weather Station](guide/projects/intermediate/02-weather-station.md)
   - [Home Automation](guide/projects/intermediate/01-home-automation.md)

### 🚁 Maker/Engineer
**Time**: 20+ hours  
**Goal**: Production-ready embedded systems

1. Complete previous paths (12-15 hours)
2. **Advanced Projects** (8-12 hours)
   - [Robot Control System](guide/projects/intermediate/03-robot-control.md)
   - [Security Camera System](guide/projects/intermediate/04-security-camera.md)
   - [Smart Garden Controller](guide/projects/intermediate/05-smart-garden.md)

## 🛠 Required Hardware

### Minimum Setup ($20-30)
Perfect for all beginner projects:
- Raspberry Pi Zero 2 W or Pi 3/4
- MicroSD card (16GB)
- Breadboard
- Jumper wires
- LEDs and resistors
- Push buttons

### Complete Learning Kit ($50-80)
Everything you need for intermediate projects:
- Raspberry Pi 4 (4GB)
- Sensors (temperature, humidity, light)
- Motors (servo, DC motor)
- Camera module
- Relay modules
- LCD display

### Advanced Maker Setup ($100-200)
For production-level projects:
- Multiple Pi boards
- Industrial sensors
- Motor drivers
- Communication modules
- Power supplies
- Enclosures

See our [Hardware Shopping Guide](guide/references/README.md#component-suppliers) for specific recommendations.

## 🎯 What You'll Build

### Beginner Projects
- **LED Blinker**: Classic "Hello World" of hardware
- **Button Controller**: Interactive LED patterns
- **Temperature Monitor**: Read and display sensor data

### Intermediate Projects  
- **Home Automation**: Control lights and appliances remotely
- **Weather Station**: Multi-sensor data collection with web interface
- **Security System**: Motion detection and alerts

### Advanced Projects
- **Robot Controller**: Autonomous navigation and control
- **IoT Gateway**: Connect multiple devices to the internet
- **Industrial Monitor**: Real-time data logging and analysis

## 💡 Why Lua for Hardware?

```lua
-- Lua is simple and powerful
local temperature = read_sensor()

if temperature > 25 then
    turn_on_fan()
    send_alert("Temperature high: " .. temperature .. "°C")
end
```

- **Easy to learn**: Simple, clean syntax
- **Fast execution**: Perfect for real-time control
- **Small footprint**: Runs on resource-constrained devices
- **Powerful features**: Tables, functions, and coroutines
- **Great community**: Active forums and libraries

## 🆘 Getting Help

### Documentation
- 📖 [Complete Guide](guide/README.md) - Start here for systematic learning
- 🔧 [Hardware Setup](guide/setup/installation.md) - Installation and configuration
- 📚 [Reference Materials](guide/references/README.md) - Links and resources

### Community Support
- 💬 **GitHub Issues**: Report bugs or ask questions
- 🌐 **Lua Community**: Join the global Lua programming community
- 📺 **Video Tutorials**: Coming soon!

### Troubleshooting
- ⚡ **Hardware not working?** Check connections and power
- 🐛 **Code errors?** Read error messages carefully
- 🔍 **Need examples?** Look in the [demos folder](demos/)

## 📈 Next Steps

1. **Try the demo**: Run `lua5.4 demos/smart_led_controller.lua`
2. **Read the guide**: Start with [guide/README.md](guide/README.md)
3. **Build a project**: Follow [LED Blink Project](guide/projects/beginner/01-led-blink.md)
4. **Join the community**: Share your projects and get help
5. **Contribute**: Help make this guide even better!

## 🌟 Success Stories

*"I had never programmed hardware before, but with this guide I built a complete home automation system in a weekend!"* - Sarah, Maker

*"Lua's simplicity let me focus on the hardware instead of fighting with the language. Perfect for rapid prototyping."* - Mike, Engineer

*"The step-by-step projects gave me confidence to tackle my own ideas. Now I'm building IoT devices professionally."* - David, Student

---

**Ready to start?** 🚀

**[Begin Your Journey →](guide/README.md)**

---

*Happy hardware hacking! 🔧⚡*