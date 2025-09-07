# Installation and Setup Guide

This guide will help you install Lua and set up your development environment on various platforms. We'll also set up the tools you need for hardware programming.

## Installing Lua

### Windows

#### Option 1: Using LuaForWindows (Recommended for beginners)
1. Download LuaForWindows from [GitHub](https://github.com/rjpcomputing/luaforwindows/releases)
2. Run the installer as administrator
3. Follow the installation wizard
4. Open Command Prompt and type `lua` to verify installation

#### Option 2: Using WSL (Windows Subsystem for Linux)
1. Install WSL2 from Microsoft Store
2. Open WSL terminal
3. Follow the Ubuntu/Linux instructions below

### macOS

#### Using Homebrew (Recommended)
```bash
# Install Homebrew if you don't have it
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Lua
brew install lua

# Verify installation
lua -v
```

#### Using MacPorts
```bash
sudo port install lua
```

### Linux (Ubuntu/Debian)

```bash
# Update package list
sudo apt update

# Install Lua
sudo apt install lua5.4 lua5.4-dev luarocks

# Verify installation
lua -v
```

### Linux (CentOS/RHEL/Fedora)

```bash
# For CentOS/RHEL
sudo yum install lua lua-devel luarocks

# For Fedora
sudo dnf install lua lua-devel luarocks

# Verify installation
lua -v
```

### Raspberry Pi (Raspberry Pi OS)

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Lua and development tools
sudo apt install lua5.4 lua5.4-dev luarocks git

# Install GPIO libraries for hardware programming
sudo apt install wiringpi

# Verify installation
lua -v
```

## Setting Up Your Development Environment

### Text Editors and IDEs

#### Visual Studio Code (Recommended)
1. Download and install [VS Code](https://code.visualstudio.com/)
2. Install the Lua extension:
   - Open VS Code
   - Go to Extensions (Ctrl+Shift+X)
   - Search for "Lua" by sumneko
   - Install it

#### Other Good Options
- **Sublime Text**: Lightweight with Lua syntax highlighting
- **Atom**: Good Lua packages available
- **Vim/Neovim**: For terminal-based editing
- **IntelliJ IDEA**: With Lua plugin
- **ZeroBrane Studio**: Lua-specific IDE

### Setting Up LuaRocks (Package Manager)

LuaRocks is Lua's package manager, essential for installing libraries:

```bash
# Check if LuaRocks is installed
luarocks --version

# If not installed, install it:
# Ubuntu/Debian
sudo apt install luarocks

# macOS
brew install luarocks

# Or build from source
wget https://luarocks.org/releases/luarocks-3.9.2.tar.gz
tar zxpf luarocks-3.9.2.tar.gz
cd luarocks-3.9.2
./configure && make && sudo make install
```

### Essential Libraries for Hardware Programming

Install these libraries for hardware programming:

```bash
# For GPIO control (Linux/Raspberry Pi)
luarocks install lua-periphery

# For serial communication
luarocks install luaserial

# For JSON handling (common in IoT)
luarocks install dkjson

# For HTTP requests (for IoT connectivity)
luarocks install lua-requests

# For system utilities
luarocks install luaposix
```

## Hardware Setup

### Raspberry Pi Specific Setup

If you're using a Raspberry Pi for hardware programming:

```bash
# Enable GPIO, SPI, I2C interfaces
sudo raspi-config
# Navigate to Interface Options and enable GPIO, SPI, I2C

# Install additional GPIO libraries
sudo apt install python3-gpiozero  # For reference
pip3 install RPi.GPIO  # Python library (for comparison)

# Install pigpio for advanced GPIO control
sudo apt install pigpio
sudo systemctl enable pigpiod
sudo systemctl start pigpiod
```

### ESP32/ESP8266 Setup (Optional)

For microcontroller programming with Lua:

1. **NodeMCU firmware** (Lua for ESP32/ESP8266):
   - Download firmware from [NodeMCU builds](https://nodemcu-build.com/)
   - Flash using ESPTool or NodeMCU Flasher
   - Use ESPlorer or similar tool for development

2. **MicroPython** (Alternative to Lua):
   - More commonly used than Lua on microcontrollers
   - Similar syntax and ease of use

## Testing Your Installation

Create a test file to verify everything works:

### Test 1: Basic Lua
Create `test.lua`:
```lua
print("Lua is working!")
print("Lua version: " .. _VERSION)

-- Test basic functionality
local function greet(name)
    return "Hello, " .. name .. "!"
end

print(greet("Hardware Programmer"))

-- Test table functionality
local devices = {"LED", "Sensor", "Motor"}
for i, device in ipairs(devices) do
    print(i .. ": " .. device)
end
```

Run it:
```bash
lua test.lua
```

### Test 2: LuaRocks
Test that LuaRocks can install packages:
```bash
luarocks install inspect
```

Create `test_luarocks.lua`:
```lua
local inspect = require('inspect')

local data = {
    sensor = "DHT22",
    reading = 23.5,
    timestamp = os.time()
}

print(inspect(data))
```

Run it:
```bash
lua test_luarocks.lua
```

### Test 3: Hardware (Raspberry Pi only)
Create `test_gpio.lua`:
```lua
-- This will only work on Raspberry Pi with proper setup
local success, periphery = pcall(require, 'periphery')

if success then
    print("GPIO library loaded successfully!")
    print("Ready for hardware programming")
else
    print("GPIO library not available (normal on non-Pi systems)")
    print("Lua is still working fine for general programming")
end
```

## Troubleshooting

### Common Issues

#### "lua: command not found"
- Make sure Lua is properly installed
- Check that Lua is in your PATH
- Try `lua5.4` instead of `lua`

#### "luarocks: command not found"
- Install LuaRocks using your system package manager
- Verify PATH includes LuaRocks installation directory

#### Permission denied errors (Linux/macOS)
- Use `sudo` for system-wide installations
- Consider using local installations: `luarocks install --local package_name`

#### GPIO access denied (Raspberry Pi)
- Add your user to the gpio group: `sudo usermod -a -G gpio $USER`
- Logout and login again
- Use `sudo` for GPIO operations if needed

### Getting Help

If you encounter issues:
1. Check the [official Lua documentation](https://www.lua.org/docs.html)
2. Visit [Lua Users Wiki](http://lua-users.org/wiki/)
3. Check platform-specific forums (Raspberry Pi Foundation, etc.)
4. Search Stack Overflow for Lua questions

## What's Next?

Now that you have Lua installed and configured, you're ready to:
1. Write your [First Lua Program](../basics/02-first-program.md)
2. Learn about [Basic Syntax](../basics/03-syntax.md)
3. Start experimenting with code!

---

**Congratulations!** You now have a complete Lua development environment ready for both general programming and hardware control.