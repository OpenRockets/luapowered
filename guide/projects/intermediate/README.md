# Intermediate Projects

Ready for more complex hardware programming? These intermediate projects combine multiple concepts and introduce advanced techniques like communication protocols, real-time data processing, and system integration.

## Project Overview

1. [Home Automation System](01-home-automation.md) - Control lights, monitor sensors, web interface
2. [IoT Weather Station](02-weather-station.md) - Multi-sensor data collection and web reporting
3. [Robot Control System](03-robot-control.md) - Motor control, sensor feedback, autonomous behavior
4. [Security Camera System](04-security-camera.md) - Motion detection, image capture, alerts
5. [Smart Garden Controller](05-smart-garden.md) - Automated watering, environmental monitoring

## Prerequisites

- Completion of all [Beginner Projects](../beginner/README.md)
- Understanding of [Hardware Communication Protocols](../../hardware/protocols.md)
- Basic networking concepts (HTTP, TCP/IP)
- Familiarity with file I/O and data processing

## Required Hardware

### Core Platform
- **Raspberry Pi 4** (recommended for performance)
- **32GB+ MicroSD card** (for data storage)
- **Reliable power supply** (3A+ for Pi 4)
- **Case with cooling** (heat sink/fan recommended)

### Communication Modules
- **WiFi adapter** (built-in on Pi 3/4)
- **Camera module** (Pi Camera v2 or USB webcam)
- **Real-time clock module** (DS3231)
- **GPIO expander** (MCP23017 for more pins)

### Sensors and Actuators
- **Environmental sensors**: DHT22 (temp/humidity), BMP280 (pressure)
- **Motion sensors**: PIR sensor, ultrasonic sensor (HC-SR04)
- **Light sensors**: LDR, TSL2561 digital light sensor
- **Motors**: Servo motors, stepper motors, DC motors with drivers
- **Relays**: 5V relay modules for high-power switching
- **Water sensors**: Soil moisture, water level sensors

### Additional Components
- **LCD display**: 16x2 or 20x4 character display
- **LEDs and indicators**: Status indicators, warning lights
- **Breadboards and perfboard**: For permanent installations
- **Enclosures**: Weather-resistant boxes for outdoor use

## Learning Objectives

After completing these projects, you will:
- Design and implement complex multi-component systems
- Integrate hardware with web services and databases
- Handle real-time data collection and processing
- Implement communication protocols (I2C, SPI, UART)
- Create robust, reliable embedded systems
- Design user interfaces for hardware control
- Implement security and error handling for production systems

## Project Difficulty Levels

### 🟡 Intermediate (Projects 1-2)
- Multiple sensors and actuators
- Web interfaces and data logging
- Network communication
- **Time**: 4-8 hours each

### 🟠 Advanced Intermediate (Projects 3-4)
- Real-time control systems
- Image/video processing
- Complex state machines
- **Time**: 8-12 hours each

### 🔴 Advanced (Project 5)
- Autonomous operation
- Machine learning integration
- Production-ready systems
- **Time**: 12-20 hours

## Development Environment Setup

### Enhanced Software Setup
```bash
# Install additional packages for intermediate projects
sudo apt update && sudo apt upgrade -y

# Web development tools
sudo apt install nginx python3-flask nodejs npm

# Image processing libraries
sudo apt install python3-opencv python3-pil

# Database support
sudo apt install sqlite3 python3-sqlite3

# Additional Lua libraries
luarocks install lua-cjson       # JSON processing
luarocks install luasocket       # Network communication
luarocks install lfs             # File system operations
luarocks install luasql-sqlite3  # Database connectivity
```

### Project Organization
Create a structured workspace:

```bash
mkdir -p ~/lua_projects/intermediate/{shared,home_automation,weather_station,robot_control,security_camera,smart_garden}

# Shared libraries and utilities
mkdir -p ~/lua_projects/intermediate/shared/{sensors,actuators,web,database}
```

## Common Patterns for Intermediate Projects

### 1. Modular Architecture
```lua
-- Project structure example
project/
├── main.lua              -- Main application entry point
├── config.lua           -- Configuration management
├── lib/                 -- Local libraries
│   ├── sensors.lua      -- Sensor abstraction layer
│   ├── actuators.lua    -- Actuator control
│   ├── web_server.lua   -- Web interface
│   └── database.lua     -- Data persistence
├── static/              -- Web assets (HTML, CSS, JS)
├── data/               -- Data files and databases
└── logs/               -- Application logs
```

### 2. Configuration Management
```lua
-- config.lua - Centralized configuration
local config = {
    -- Hardware pins
    pins = {
        led_status = 18,
        sensor_dht22 = 4,
        relay_pump = 17,
        button_mode = 2
    },
    
    -- Sensor settings
    sensors = {
        read_interval = 30,      -- seconds
        temp_threshold = 25.0,   -- celsius
        humidity_threshold = 60  -- percent
    },
    
    -- Network settings
    network = {
        web_port = 8080,
        api_endpoint = "http://iot.example.com/api",
        wifi_ssid = "your_wifi_name"
    },
    
    -- Data settings
    data = {
        database_path = "data/sensor_data.db",
        log_file = "logs/system.log",
        backup_interval = 3600  -- seconds
    }
}

return config
```

### 3. Error Handling and Logging
```lua
-- Enhanced error handling for production systems
local log = require('lib.logger')

local function safe_sensor_read(sensor_func, sensor_name)
    local success, result = pcall(sensor_func)
    
    if success then
        log.info("Successfully read " .. sensor_name .. ": " .. tostring(result))
        return result
    else
        log.error("Failed to read " .. sensor_name .. ": " .. result)
        return nil, result
    end
end

-- Usage
local temperature, error = safe_sensor_read(
    function() return dht22.read_temperature() end,
    "DHT22 Temperature"
)

if temperature then
    -- Process successful reading
    process_temperature(temperature)
else
    -- Handle error gracefully
    handle_sensor_error("temperature", error)
end
```

### 4. Real-time Data Processing
```lua
-- Real-time data collection with buffering
local DataCollector = {}
DataCollector.__index = DataCollector

function DataCollector:new(config)
    local obj = {
        buffer = {},
        buffer_size = config.buffer_size or 100,
        flush_interval = config.flush_interval or 60,
        last_flush = os.time()
    }
    setmetatable(obj, self)
    return obj
end

function DataCollector:add_reading(sensor, value, timestamp)
    timestamp = timestamp or os.time()
    
    table.insert(self.buffer, {
        sensor = sensor,
        value = value,
        timestamp = timestamp
    })
    
    -- Auto-flush if buffer is full or interval exceeded
    if #self.buffer >= self.buffer_size or 
       (os.time() - self.last_flush) >= self.flush_interval then
        self:flush()
    end
end

function DataCollector:flush()
    if #self.buffer > 0 then
        -- Save to database or send to server
        database.save_readings(self.buffer)
        self.buffer = {}
        self.last_flush = os.time()
    end
end
```

### 5. State Machine for Complex Behavior
```lua
-- State machine for automated systems
local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine:new(initial_state)
    local obj = {
        current_state = initial_state,
        states = {},
        transitions = {}
    }
    setmetatable(obj, self)
    return obj
end

function StateMachine:add_state(name, enter_func, exit_func, update_func)
    self.states[name] = {
        enter = enter_func,
        exit = exit_func,
        update = update_func
    }
end

function StateMachine:add_transition(from_state, to_state, condition_func)
    if not self.transitions[from_state] then
        self.transitions[from_state] = {}
    end
    table.insert(self.transitions[from_state], {
        to = to_state,
        condition = condition_func
    })
end

function StateMachine:update()
    local current = self.states[self.current_state]
    
    -- Update current state
    if current.update then
        current.update()
    end
    
    -- Check for transitions
    local transitions = self.transitions[self.current_state]
    if transitions then
        for _, transition in ipairs(transitions) do
            if transition.condition() then
                self:change_state(transition.to)
                break
            end
        end
    end
end

function StateMachine:change_state(new_state)
    if new_state == self.current_state then return end
    
    local old_state = self.states[self.current_state]
    local new_state_obj = self.states[new_state]
    
    -- Exit old state
    if old_state.exit then
        old_state.exit()
    end
    
    -- Change state
    print("State change: " .. self.current_state .. " → " .. new_state)
    self.current_state = new_state
    
    -- Enter new state
    if new_state_obj.enter then
        new_state_obj.enter()
    end
end
```

## Security Considerations

### 1. Network Security
- Use HTTPS for web interfaces
- Implement authentication for control functions
- Limit network access to necessary ports only
- Regular security updates

### 2. Data Protection
- Encrypt sensitive configuration data
- Secure database access
- Implement data retention policies
- Backup critical data regularly

### 3. Physical Security
- Secure hardware enclosures
- Tamper detection for critical systems
- Physical access controls
- Environmental protection

## Testing Strategies

### 1. Unit Testing
```lua
-- Simple unit testing framework
local test = {}

function test.assert_equal(actual, expected, message)
    if actual ~= expected then
        error(message or string.format("Expected %s, got %s", expected, actual))
    end
    print("✅ " .. (message or "Test passed"))
end

function test.assert_true(condition, message)
    if not condition then
        error(message or "Expected true condition")
    end
    print("✅ " .. (message or "Test passed"))
end

-- Example sensor test
function test_temperature_sensor()
    local temp = dht22.read_temperature()
    test.assert_true(temp and temp > -40 and temp < 80, "Temperature reading in valid range")
end
```

### 2. Integration Testing
- Test sensor-actuator combinations
- Verify network communication
- Test error recovery scenarios
- Performance testing under load

### 3. System Testing
- End-to-end functionality testing
- Long-running stability tests
- Environmental stress testing
- User acceptance testing

## Deployment Best Practices

### 1. System Service Setup
```bash
# Create systemd service for auto-start
sudo nano /etc/systemd/system/lua-iot.service

[Unit]
Description=Lua IoT Application
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/lua_projects/intermediate/home_automation
ExecStart=/usr/bin/lua main.lua
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target

# Enable and start service
sudo systemctl enable lua-iot
sudo systemctl start lua-iot
```

### 2. Monitoring and Maintenance
- System health monitoring
- Automated backups
- Log rotation
- Remote access for maintenance

## What You'll Accomplish

By completing these intermediate projects, you'll have built:
- A complete home automation system with web control
- An IoT weather station with data visualization
- A robot with autonomous navigation capabilities
- A security system with image recognition
- An automated garden with smart watering

These projects represent real-world applications that demonstrate professional-level embedded systems development skills.

## Ready to Begin?

Choose your first intermediate project:

1. **[Home Automation System](01-home-automation.md)** - Great for learning web integration
2. **[IoT Weather Station](02-weather-station.md)** - Perfect for data collection and visualization
3. **[Robot Control System](03-robot-control.md)** - Ideal for mechatronics enthusiasts
4. **[Security Camera System](04-security-camera.md)** - Excellent for image processing
5. **[Smart Garden Controller](05-smart-garden.md)** - Perfect for autonomous systems

Each project builds on the previous ones, so we recommend starting with the Home Automation System and progressing through the list.

---

**Good luck!** These projects will challenge you, but they'll also give you the skills to build production-quality embedded systems with Lua.