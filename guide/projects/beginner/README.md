# Beginner Projects

Welcome to hands-on hardware programming! These projects will help you apply what you've learned and build confidence with real hardware.

## Project Overview

1. [LED Blink Control](01-led-blink.md) - Control LEDs with different patterns
2. [Button Input Reading](02-button-input.md) - Read button presses and respond
3. [Temperature Sensor](03-temperature-sensor.md) - Read and display temperature
4. [Simple Motor Control](04-motor-control.md) - Control servo and DC motors
5. [Data Logging](05-data-logging.md) - Save sensor data to files

## Prerequisites

- Completion of [Lua Basics](../../basics/README.md)
- Understanding of [Hardware Programming Introduction](../../hardware/01-introduction.md)
- Basic electronics knowledge (voltage, current, resistance)

## Required Hardware

### Essential Components (for all projects)
- Raspberry Pi 3B+ or 4 with Raspberry Pi OS
- MicroSD card (16GB minimum)
- Breadboard (half-size or full-size)
- Jumper wires (male-to-male, male-to-female)
- Resistors: 220Ω, 1kΩ, 10kΩ (at least 5 of each)

### Project-Specific Components
- **LEDs**: Red, green, blue, yellow (5 of each)
- **Push buttons**: Momentary push buttons (3-5 pieces)
- **Temperature sensor**: DS18B20 or DHT22
- **Servo motor**: SG90 or similar small servo
- **DC motor**: Small 3V-6V motor with motor driver board (L293D or L298N)
- **Potentiometer**: 10kΩ variable resistor
- **Photoresistor**: Light-dependent resistor (LDR)

### Tools
- Multimeter (for testing circuits)
- Small screwdriver set
- Wire strippers (optional but helpful)

## Project Difficulty Levels

### 🟢 Easy (Projects 1-2)
- Basic GPIO control
- Simple circuits
- Clear, step-by-step instructions
- **Time**: 30-60 minutes each

### 🟡 Medium (Projects 3-4)  
- Sensor integration
- More complex circuits
- Error handling
- **Time**: 1-2 hours each

### 🟠 Medium-Hard (Project 5)
- File operations
- Data processing
- Multiple components
- **Time**: 2-3 hours

## Learning Objectives

By completing these projects, you will learn to:
- Build and test electronic circuits safely
- Write Lua code that controls real hardware
- Read data from various types of sensors
- Control different types of actuators (LEDs, motors)
- Handle errors and edge cases in hardware programming
- Log and process data from hardware devices
- Debug both hardware and software issues

## Safety Reminders

⚠️ **Before starting any project:**

1. **Power off** your Raspberry Pi before connecting wires
2. **Double-check** all connections with the circuit diagram
3. **Use appropriate resistors** to protect components
4. **Start with low voltages** (3.3V or 5V only)
5. **Keep your workspace organized** to avoid mistakes

## Setting Up Your Workspace

### 1. Prepare Your Raspberry Pi
```bash
# Update your system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install lua5.4 lua5.4-dev luarocks git

# Install Lua GPIO library
luarocks install lua-periphery

# Enable GPIO interfaces
sudo raspi-config
# Navigate to Interface Options → GPIO → Enable
```

### 2. Test Your Setup
Create a test file `test_setup.lua`:

```lua
-- Test that everything is working
print("Testing Lua and GPIO setup...")

local success, periphery = pcall(require, 'periphery')
if success then
    print("✅ GPIO library loaded successfully!")
    print("✅ Ready for hardware programming!")
else
    print("❌ GPIO library not found")
    print("Please install lua-periphery: luarocks install lua-periphery")
end

print("Lua version: " .. _VERSION)
print("Setup test complete!")
```

Run it:
```bash
lua test_setup.lua
```

### 3. Organize Your Project Files
Create a folder structure for your projects:

```bash
mkdir -p ~/lua_projects/{led_blink,button_input,temperature,motor_control,data_logging}
```

## General Hardware Programming Tips

### 1. Always Start Simple
- Get the basic circuit working first
- Add complexity gradually
- Test each addition before moving on

### 2. Use Debug Output
```lua
-- Add debug prints to understand what's happening
print("Starting main loop...")
print("Button state: " .. tostring(button_pressed))
print("Setting LED to: " .. tostring(led_state))
```

### 3. Handle Errors Gracefully
```lua
-- Wrap hardware operations in pcall
local success, result = pcall(function()
    return gpio.read()
end)

if not success then
    print("Error reading GPIO: " .. result)
    return
end
```

### 4. Clean Up Resources
```lua
-- Always clean up when your program ends
local function cleanup()
    if led then led:close() end
    if button then button:close() end
    print("Hardware cleanup complete")
end

-- Set up signal handler for Ctrl+C
signal.signal(signal.SIGINT, function()
    cleanup()
    os.exit(0)
end)
```

## Common Circuit Patterns

### 1. LED with Current-Limiting Resistor
```
GPIO Pin → 220Ω Resistor → LED → Ground
```

### 2. Button with Pull-up Resistor
```
3.3V → 10kΩ Resistor → GPIO Pin
                   ↓
              Button → Ground
```

### 3. Voltage Divider (for analog sensors)
```
3.3V → Sensor → GPIO Pin → Fixed Resistor → Ground
```

## Troubleshooting Guide

### Hardware Issues
- **LED not lighting**: Check polarity, resistor value, connections
- **Button not responding**: Check pull-up resistor, switch connections
- **Inconsistent readings**: Check loose connections, power supply

### Software Issues
- **Permission denied**: Use `sudo` or add user to gpio group
- **Module not found**: Check luarocks installation
- **Unexpected behavior**: Add debug output, check logic

### Testing Tools
- **Multimeter**: Measure voltages and continuity
- **LED test**: Use known-good LED to test circuits
- **Print statements**: Debug program flow
- **Interactive mode**: Test code snippets in Lua REPL

## Getting Help

If you encounter problems:
1. **Check the circuit diagram** carefully
2. **Verify all connections** with a multimeter
3. **Test components individually** 
4. **Review error messages** thoroughly
5. **Search online** for similar issues
6. **Ask for help** in forums or communities

## What's Next?

Ready to build your first project? Let's start with the classic:

👉 **[Project 1: LED Blink Control](01-led-blink.md)**

This project will teach you the fundamentals of GPIO control and is the perfect introduction to hardware programming!

---

**Remember**: Take your time, be safe, and don't hesitate to experiment. Hardware programming is learned by doing, and every mistake is a learning opportunity!