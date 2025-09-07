# Demo Projects

Welcome to the demo projects! These are complete, working examples that showcase what you can build with Lua hardware programming. Each demo is fully documented and ready to run.

## Available Demos

### 1. Smart LED Controller
**File**: `smart_led_controller.lua`  
**Hardware**: 3 LEDs, 2 buttons, Raspberry Pi  
**Features**: Multiple lighting patterns, button control, automatic modes

A complete LED control system with:
- 5 different lighting patterns
- Manual and automatic modes  
- Button-controlled pattern switching
- Brightness adjustment
- Status display

### 2. Temperature Monitor
**File**: `temperature_monitor.lua`  
**Hardware**: DHT22 sensor, LCD display, LEDs, buzzer  
**Features**: Real-time monitoring, alerts, data logging

A professional temperature monitoring system with:
- Continuous temperature/humidity monitoring
- Visual and audio alerts
- Data logging to files
- Web interface for remote monitoring
- Configurable thresholds

### 3. Home Security System  
**File**: `security_system.lua`  
**Hardware**: PIR sensor, door switch, LED, buzzer, keypad  
**Features**: Motion detection, entry alerts, keypad control

A basic home security system featuring:
- Motion detection with PIR sensor
- Door/window monitoring
- Keypad arm/disarm functionality
- Alert notifications
- Event logging

## Getting Started

### Prerequisites
- Raspberry Pi with Raspberry Pi OS
- Lua 5.4 installed
- Basic electronic components (see individual demo requirements)
- Breadboard and jumper wires

### Installation
```bash
# Navigate to the luapowered directory
cd /path/to/luapowered

# Make demos executable
chmod +x demos/*.lua

# Run a demo
lua demos/smart_led_controller.lua
```

### Hardware Setup
Each demo includes:
- Complete circuit diagrams
- Component lists
- Step-by-step wiring instructions
- Safety guidelines

## Demo Categories

### 🟢 Beginner Demos
Simple projects perfect for learning:
- LED controllers
- Button interfaces
- Basic sensors

### 🟡 Intermediate Demos  
More complex projects with multiple components:
- Environmental monitors
- Data logging systems
- Simple automation

### 🔴 Advanced Demos
Professional-grade examples:
- Security systems
- IoT integration
- Machine learning applications

## Learning Path

1. **Start with basics**: Try the Smart LED Controller first
2. **Add sensors**: Move to the Temperature Monitor
3. **Build systems**: Tackle the Security System
4. **Customize**: Modify demos for your specific needs
5. **Create new**: Use demos as templates for original projects

## Support

If you encounter issues:
1. Check the hardware connections
2. Verify component compatibility
3. Review the troubleshooting section in each demo
4. Ask for help in the community forums

Happy building! 🚀