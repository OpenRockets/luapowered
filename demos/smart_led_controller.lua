#!/usr/bin/env lua

--[[
Smart LED Controller Demo
========================

A comprehensive LED control system demonstrating:
- Multiple lighting patterns
- Button-controlled mode switching
- Automatic pattern cycling
- Status feedback
- Clean code organization

Hardware Required:
- Raspberry Pi (any model with GPIO)
- 3x LEDs (Red, Green, Blue recommended)
- 3x 220Ω resistors  
- 2x Push buttons
- 2x 10kΩ resistors (pull-up)
- Breadboard and jumper wires

GPIO Connections:
- LED Red:    GPIO 18 → 220Ω → LED → GND
- LED Green:  GPIO 23 → 220Ω → LED → GND  
- LED Blue:   GPIO 24 → 220Ω → LED → GND
- Button1:    3.3V → 10kΩ → GPIO 2 ← Button → GND
- Button2:    3.3V → 10kΩ → GPIO 3 ← Button → GND

Safety:
- Always power off Pi before connecting wires
- Double-check connections before powering on
- Use appropriate resistor values to protect LEDs

Features:
- Pattern cycling with Button 1
- Mode switching with Button 2  
- 6 different LED patterns
- Manual and automatic modes
- Status feedback via console
]]

-- Configuration
local CONFIG = {
    pins = {
        led_red = 18,
        led_green = 23, 
        led_blue = 24,
        button_mode = 2,    -- Mode switch button
        button_action = 3   -- Action/pattern button
    },
    timing = {
        pattern_delay = 0.3,     -- Delay between pattern steps
        button_debounce = 0.05,  -- Button debounce time
        auto_cycle_time = 3.0    -- Auto pattern cycle time
    }
}

-- Initialize hardware interface
local function init_hardware()
    -- In a real implementation, this would initialize GPIO
    -- For demo purposes, we'll simulate hardware
    print("🔧 Initializing hardware...")
    
    local hardware = {
        leds = {
            red = {pin = CONFIG.pins.led_red, state = false},
            green = {pin = CONFIG.pins.led_green, state = false},
            blue = {pin = CONFIG.pins.led_blue, state = false}
        },
        buttons = {
            mode = {pin = CONFIG.pins.button_mode, last_state = false},
            action = {pin = CONFIG.pins.button_action, last_state = false}
        }
    }
    
    print("✅ Hardware initialized successfully")
    return hardware
end

-- LED control functions
local function set_led(hardware, color, state)
    if hardware.leds[color] then
        hardware.leds[color].state = state
        local symbol = state and "●" or "○"
        local status = state and "ON" or "OFF"
        print(string.format("  %s LED %s: %s", 
              string.upper(color), symbol, status))
    end
end

local function all_leds_off(hardware)
    set_led(hardware, "red", false)
    set_led(hardware, "green", false)
    set_led(hardware, "blue", false)
end

local function all_leds_on(hardware)
    set_led(hardware, "red", true)
    set_led(hardware, "green", true)
    set_led(hardware, "blue", true)
end

-- Pattern definitions
local PATTERNS = {
    {
        name = "Sequential",
        description = "Light LEDs one by one",
        steps = {
            {red = true,  green = false, blue = false},
            {red = false, green = true,  blue = false},
            {red = false, green = false, blue = true},
            {red = false, green = false, blue = false}
        }
    },
    {
        name = "Binary Counter", 
        description = "Count from 0-7 in binary",
        steps = {
            {red = false, green = false, blue = false}, -- 0
            {red = false, green = false, blue = true},  -- 1
            {red = false, green = true,  blue = false}, -- 2
            {red = false, green = true,  blue = true},  -- 3
            {red = true,  green = false, blue = false}, -- 4
            {red = true,  green = false, blue = true},  -- 5
            {red = true,  green = true,  blue = false}, -- 6
            {red = true,  green = true,  blue = true}   -- 7
        }
    },
    {
        name = "Breathing",
        description = "All LEDs fade in and out",
        steps = {
            {red = false, green = false, blue = false},
            {red = true,  green = true,  blue = true},
            {red = false, green = false, blue = false},
            {red = true,  green = true,  blue = true}
        }
    },
    {
        name = "Traffic Light",
        description = "Simulate traffic light sequence", 
        steps = {
            {red = true,  green = false, blue = false}, -- Red
            {red = true,  green = true,  blue = false}, -- Red + Yellow
            {red = false, green = true,  blue = false}, -- Green  
            {red = false, green = true,  blue = true}   -- Yellow (blue as yellow)
        }
    },
    {
        name = "Knight Rider",
        description = "Sweep left to right and back",
        steps = {
            {red = true,  green = false, blue = false},
            {red = false, green = true,  blue = false},
            {red = false, green = false, blue = true},
            {red = false, green = true,  blue = false}
        }
    },
    {
        name = "Random Flash",
        description = "Random LED combinations",
        steps = {} -- Will be generated randomly
    }
}

-- Generate random pattern steps
local function generate_random_steps()
    local steps = {}
    for i = 1, 8 do
        table.insert(steps, {
            red = math.random() > 0.5,
            green = math.random() > 0.5, 
            blue = math.random() > 0.5
        })
    end
    return steps
end

-- Execute a pattern
local function run_pattern(hardware, pattern, cycles)
    cycles = cycles or 1
    
    print(string.format("\n🌟 Running pattern: %s", pattern.name))
    print("   " .. pattern.description)
    
    local steps = pattern.steps
    if #steps == 0 then -- Random pattern
        steps = generate_random_steps()
    end
    
    for cycle = 1, cycles do
        if cycles > 1 then
            print(string.format("   Cycle %d/%d", cycle, cycles))
        end
        
        for step_num, step in ipairs(steps) do
            set_led(hardware, "red", step.red)
            set_led(hardware, "green", step.green)
            set_led(hardware, "blue", step.blue)
            
            -- Simulate delay
            local delay_ms = CONFIG.timing.pattern_delay * 1000
            os.execute(string.format("sleep %.3f", CONFIG.timing.pattern_delay))
        end
    end
    
    all_leds_off(hardware)
end

-- Button simulation (in real hardware, this would read GPIO)
local function read_button_debounced(hardware, button_name)
    -- Simulate button press occasionally for demo
    if math.random() > 0.95 then
        return true
    end
    return false
end

-- Main controller class
local SmartLEDController = {
    hardware = nil,
    current_pattern = 1,
    mode = "manual", -- "manual" or "auto"
    running = false
}

function SmartLEDController:new()
    local obj = {
        hardware = init_hardware(),
        current_pattern = 1,
        mode = "manual",
        running = false
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function SmartLEDController:display_status()
    print("\n" .. string.rep("=", 50))
    print("🎮 SMART LED CONTROLLER STATUS")
    print(string.rep("=", 50))
    print(string.format("Mode: %s", string.upper(self.mode)))
    print(string.format("Current Pattern: %d - %s", 
          self.current_pattern, PATTERNS[self.current_pattern].name))
    print(string.format("Description: %s", 
          PATTERNS[self.current_pattern].description))
    print(string.rep("=", 50))
end

function SmartLEDController:next_pattern()
    self.current_pattern = self.current_pattern + 1
    if self.current_pattern > #PATTERNS then
        self.current_pattern = 1
    end
    
    print(string.format("📋 Pattern changed to: %s", 
          PATTERNS[self.current_pattern].name))
end

function SmartLEDController:toggle_mode()
    self.mode = (self.mode == "manual") and "auto" or "manual"
    print(string.format("⚙️  Mode switched to: %s", string.upper(self.mode)))
end

function SmartLEDController:run_current_pattern()
    local pattern = PATTERNS[self.current_pattern]
    run_pattern(self.hardware, pattern, 1)
end

function SmartLEDController:handle_buttons()
    -- Check mode button
    if read_button_debounced(self.hardware, "mode") then
        self:toggle_mode()
        self:display_status()
    end
    
    -- Check action button
    if read_button_debounced(self.hardware, "action") then
        if self.mode == "manual" then
            self:next_pattern()
            self:run_current_pattern()
        else
            self:run_current_pattern()
        end
    end
end

function SmartLEDController:auto_mode_cycle()
    local start_time = os.time()
    
    while self.mode == "auto" and self.running do
        self:run_current_pattern()
        
        -- Check if it's time to change pattern
        if os.time() - start_time >= CONFIG.timing.auto_cycle_time then
            self:next_pattern()
            start_time = os.time()
        end
        
        -- Brief pause
        os.execute("sleep 0.5")
        
        -- Check for mode changes
        self:handle_buttons()
    end
end

function SmartLEDController:run()
    self.running = true
    
    print("🚀 Starting Smart LED Controller...")
    print("📖 Controls:")
    print("   - Button 1: Change mode (Manual/Auto)")
    print("   - Button 2: Next pattern (Manual) / Run pattern (Auto)")
    print("   - Ctrl+C: Exit")
    
    self:display_status()
    
    -- Main control loop
    while self.running do
        if self.mode == "manual" then
            print("\n⏸️  Manual mode - waiting for button press...")
            self:handle_buttons()
            os.execute("sleep 0.1")
        else
            print("\n▶️  Auto mode - running pattern cycle...")
            self:auto_mode_cycle()
        end
    end
    
    print("\n👋 Smart LED Controller stopped")
    all_leds_off(self.hardware)
end

function SmartLEDController:stop()
    self.running = false
end

-- Demo runner function
local function run_demo()
    math.randomseed(os.time()) -- Initialize random number generator
    
    print("🎯 SMART LED CONTROLLER DEMO")
    print("=============================")
    print("This demo simulates a complete LED controller system.")
    print("In real hardware, this would control actual LEDs and read buttons.")
    print()
    
    -- Create and run controller
    local controller = SmartLEDController:new()
    
    -- Simulate some interactions for demo
    print("🎪 Demo Mode: Showing automatic pattern cycling...")
    
    -- Run a few patterns automatically for demo
    for i = 1, #PATTERNS do
        controller.current_pattern = i
        controller:display_status()
        controller:run_current_pattern()
        os.execute("sleep 1")
    end
    
    print("\n✨ Demo complete!")
    print("📚 In real hardware:")
    print("   - LEDs would actually light up")
    print("   - Buttons would control the system")
    print("   - System would run continuously")
    print("   - GPIO pins would be controlled")
    
    all_leds_off(controller.hardware)
end

-- Main execution
if arg and arg[0] then
    -- Running as script
    run_demo()
else
    -- Being required as module
    return {
        SmartLEDController = SmartLEDController,
        PATTERNS = PATTERNS,
        CONFIG = CONFIG,
        run_demo = run_demo
    }
end