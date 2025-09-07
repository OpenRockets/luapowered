# Project 2: Button Input Reading

Now that you can control outputs (LEDs), it's time to learn about inputs! This project teaches you to read button presses and create interactive hardware that responds to user actions.

## What You'll Learn

- Digital input programming
- Pull-up and pull-down resistors
- Debouncing techniques
- Event-driven programming
- Combining inputs and outputs
- State management in hardware

## Required Components

- Raspberry Pi with previous LED setup
- 2x Push buttons (momentary switches)
- 2x 10kΩ resistors (for pull-up)
- Additional jumper wires
- Breadboard space

## Understanding Digital Inputs

### Pull-up vs Pull-down Resistors

Without a pull resistor, a floating input pin can randomly read HIGH or LOW:

```
Floating Pin (Bad):
GPIO Pin ←─ (nothing) ←─ Button ←─ GND
Result: Random readings when button not pressed

Pull-up Resistor (Good):  
3.3V ←─ 10kΩ ←─ GPIO Pin ←─ Button ←─ GND
Result: HIGH when button open, LOW when pressed

Pull-down Resistor (Alternative):
GPIO Pin ←─ 10kΩ ←─ GND
     │
   Button
     │
   3.3V
Result: LOW when button open, HIGH when pressed
```

### Button Debouncing

Mechanical buttons "bounce" - they rapidly open/close when pressed:

```
Ideal Button Press:    Reality:
     ┌─────────        ┌┐┌┐┌──────
     │               │││││
─────┘               ─┘└┘└┘

Software sees multiple presses instead of one!
```

We'll handle this in software with timing delays.

## Circuit Diagram

```
Extended Circuit (LED + Buttons):

Previous LEDs:
GPIO18 → 220Ω → LED1 → GND
GPIO23 → 220Ω → LED2 → GND  
GPIO24 → 220Ω → LED3 → GND

New Buttons:
3.3V → 10kΩ → GPIO2 ← Button1 → GND
3.3V → 10kΩ → GPIO3 ← Button2 → GND

Complete Layout:
┌─────────────────────────┐
│ 3.3V [ 1] [ 2] 5V      │  Pin 1 (3.3V) → Pull-up resistors
│GPIO2 [ 3] [ 4] 5V      │  Pin 3 (GPIO2) → Button1 
│GPIO3 [ 5] [ 6] GND     │  Pin 5 (GPIO3) → Button2
│GPIO4 [ 7] [ 8] GPIO14  │  Pin 6 (GND) → Buttons & LEDs
│ GND  [ 9] [10] GPIO15  │  Pin 9 (GND) → Additional GND
│GPIO17[11] [12] GPIO18  │  Pin 12 (GPIO18) → LED1
│GPIO27[13] [14] GND     │  Pin 14 (GND) → More GND
│GPIO22[15] [16] GPIO23  │  Pin 16 (GPIO23) → LED2
│ 3.3V[17] [18] GPIO24  │  Pin 18 (GPIO24) → LED3
└─────────────────────────┘
```

### Breadboard Layout

```
     Breadboard (Extended)
 a b c d e   f g h i j
 ┌─┬─┬─┬─┬───┬─┬─┬─┬─┐
1│+│R│2│ │   │ │ │ │ │  ← +: 3.3V, R: 10kΩ, 2: GPIO2
 ├─┼─┼─┼─┼───┼─┼─┼─┼─┤
2│B│ │ │ │   │ │G│ │ │  ← B: Button1, G: GND
 ├─┼─┼─┼─┼───┼─┼─┼─┼─┤
3│+│R│3│ │   │ │ │ │ │  ← 3: GPIO3  
 ├─┼─┼─┼─┼───┼─┼─┼─┼─┤
4│B│ │ │ │   │ │G│ │ │  ← B: Button2
 ├─┼─┼─┼─┼───┼─┼─┼─┼─┤
5│ │R│8│ │   │+│-│ │G│  ← 8: GPIO18, LED1
 ├─┼─┼─┼─┼───┼─┼─┼─┼─┤
6│ │R│3│ │   │+│-│ │G│  ← 3: GPIO23, LED2  
 ├─┼─┼─┼─┼───┼─┼─┼─┼─┤
7│ │R│4│ │   │+│-│ │G│  ← 4: GPIO24, LED3
 └─┴─┴─┴─┴───┴─┴─┴─┴─┘
```

## Code Examples

### Basic Button Reading

Create `button_test.lua`:

```lua
#!/usr/bin/env lua

-- Button Input Test - Basic Version
-- Hardware: Button connected to GPIO2 with pull-up resistor

local periphery = require('periphery')
local GPIO = periphery.GPIO

-- Configuration
local BUTTON_PIN = 2
local LED_PIN = 18

print("=== Button Input Test ===")
print("Button Pin: GPIO" .. BUTTON_PIN)
print("LED Pin: GPIO" .. LED_PIN)
print("Press the button to toggle LED")
print("Press Ctrl+C to stop")

-- Initialize GPIO
local button = GPIO(BUTTON_PIN, "in", "pull_up")  -- Built-in pull-up
local led = GPIO(LED_PIN, "out")

-- Initialize state
led:write(false)
local led_state = false

-- Cleanup function
local function cleanup()
    print("\nCleaning up...")
    led:write(false)
    led:close()
    button:close()
    print("Goodbye!")
    os.exit(0)
end

-- Helper function for delays
local function delay(seconds)
    os.execute("sleep " .. seconds)
end

-- Debounced button reading
local function read_button_debounced()
    local state1 = button:read()
    delay(0.02)  -- 20ms debounce delay
    local state2 = button:read()
    
    -- Return true only if both readings are consistent
    return state1 == state2 and not state1  -- Active low (pressed = false)
end

-- Main loop
local function main()
    local last_button_state = false
    local button_press_count = 0
    
    print("Ready! Press the button...")
    
    while true do
        local current_button_state = read_button_debounced()
        
        -- Detect button press (transition from not pressed to pressed)
        if current_button_state and not last_button_state then
            button_press_count = button_press_count + 1
            print("Button pressed! Count: " .. button_press_count)
            
            -- Toggle LED
            led_state = not led_state
            led:write(led_state)
            
            local state_text = led_state and "ON" or "OFF"
            print("LED is now: " .. state_text)
        end
        
        last_button_state = current_button_state
        delay(0.01)  -- Small delay to prevent excessive CPU usage
    end
end

-- Run with error handling
local success, error_msg = pcall(main)
if not success then
    print("Error: " .. error_msg)
    cleanup()
end
```

### Two-Button LED Controller

Create `two_button_control.lua`:

```lua
#!/usr/bin/env lua

-- Two Button LED Controller
-- Button1: Cycle through LEDs
-- Button2: Change pattern mode

local periphery = require('periphery')
local GPIO = periphery.GPIO

-- Configuration
local BUTTON1_PIN = 2    -- Mode button
local BUTTON2_PIN = 3    -- Action button
local LED_PINS = {18, 23, 24}

print("=== Two Button LED Controller ===")
print("Button 1 (GPIO" .. BUTTON1_PIN .. "): Change mode")
print("Button 2 (GPIO" .. BUTTON2_PIN .. "): Action/Next")
print("Press Ctrl+C to stop")

-- Initialize GPIO
local button1 = GPIO(BUTTON1_PIN, "in", "pull_up")
local button2 = GPIO(BUTTON2_PIN, "in", "pull_up")

local leds = {}
for i, pin in ipairs(LED_PINS) do
    leds[i] = GPIO(pin, "out")
    leds[i]:write(false)
end

-- State variables
local mode = 1  -- 1: Single LED, 2: Sequential, 3: All flash
local current_led = 1
local all_on = false

-- Mode descriptions
local modes = {
    [1] = "Single LED Selection",
    [2] = "Sequential Pattern", 
    [3] = "All Flash Together"
}

-- Cleanup function
local function cleanup()
    print("\nTurning off all LEDs...")
    for i, led in ipairs(leds) do
        led:write(false)
        led:close()
    end
    button1:close()
    button2:close()
    print("Cleanup complete!")
    os.exit(0)
end

-- Helper functions
local function delay(seconds)
    os.execute("sleep " .. seconds)
end

local function all_leds_off()
    for i, led in ipairs(leds) do
        led:write(false)
    end
end

local function all_leds_on()
    for i, led in ipairs(leds) do
        led:write(true)
    end
end

-- Debounced button reading
local function read_button_debounced(button)
    local state1 = button:read()
    delay(0.02)
    local state2 = button:read()
    return state1 == state2 and not state1
end

-- Display current status
local function display_status()
    print("\n--- Status ---")
    print("Mode " .. mode .. ": " .. modes[mode])
    if mode == 1 then
        print("Selected LED: " .. current_led)
    elseif mode == 3 then
        local state_text = all_on and "ON" or "OFF"
        print("All LEDs: " .. state_text)
    end
    print("Press Button1 for next mode, Button2 for action")
end

-- Mode 1: Single LED selection
local function mode_single_led()
    all_leds_off()
    leds[current_led]:write(true)
end

-- Mode 2: Sequential pattern
local function mode_sequential()
    for i, led in ipairs(leds) do
        all_leds_off()
        led:write(true)
        delay(0.3)
    end
    all_leds_off()
end

-- Mode 3: All flash
local function mode_all_flash()
    if all_on then
        all_leds_on()
    else
        all_leds_off()
    end
end

-- Handle button1 press (mode change)
local function handle_mode_button()
    mode = mode + 1
    if mode > 3 then
        mode = 1
    end
    
    -- Reset state for new mode
    all_leds_off()
    current_led = 1
    all_on = false
    
    display_status()
end

-- Handle button2 press (action)
local function handle_action_button()
    if mode == 1 then
        -- Cycle to next LED
        current_led = current_led + 1
        if current_led > #leds then
            current_led = 1
        end
        print("Selected LED: " .. current_led)
        mode_single_led()
        
    elseif mode == 2 then
        -- Run sequential pattern
        print("Running sequential pattern...")
        mode_sequential()
        
    elseif mode == 3 then
        -- Toggle all LEDs
        all_on = not all_on
        local state_text = all_on and "ON" or "OFF"
        print("All LEDs: " .. state_text)
        mode_all_flash()
    end
end

-- Main loop
local function main()
    local last_button1_state = false
    local last_button2_state = false
    
    display_status()
    mode_single_led()  -- Start with first LED on
    
    while true do
        -- Read buttons
        local button1_state = read_button_debounced(button1)
        local button2_state = read_button_debounced(button2)
        
        -- Handle button1 press (mode change)
        if button1_state and not last_button1_state then
            handle_mode_button()
        end
        
        -- Handle button2 press (action)
        if button2_state and not last_button2_state then
            handle_action_button()
        end
        
        -- Update button states
        last_button1_state = button1_state
        last_button2_state = button2_state
        
        delay(0.01)  -- Small delay
    end
end

-- Run with error handling
local success, error_msg = pcall(main)
if not success then
    print("Error: " .. error_msg)
    cleanup()
end
```

### Advanced: Button State Machine

Create `button_state_machine.lua`:

```lua
#!/usr/bin/env lua

-- Advanced Button State Machine
-- Demonstrates different button press types:
-- - Short press: Single action
-- - Long press: Different action  
-- - Double press: Third action

local periphery = require('periphery')
local GPIO = periphery.GPIO

-- Configuration
local BUTTON_PIN = 2
local LED_PINS = {18, 23, 24}
local SHORT_PRESS_TIME = 0.05   -- 50ms minimum
local LONG_PRESS_TIME = 1.0     -- 1 second for long press
local DOUBLE_PRESS_TIME = 0.5   -- 500ms window for double press

print("=== Button State Machine ===")
print("Short press: Next LED")
print("Long press: All LEDs flash")
print("Double press: LED chase pattern")
print("Press Ctrl+C to stop")

-- Initialize GPIO
local button = GPIO(BUTTON_PIN, "in", "pull_up")
local leds = {}
for i, pin in ipairs(LED_PINS) do
    leds[i] = GPIO(pin, "out")
    leds[i]:write(false)
end

-- State variables
local current_led = 1
local press_start_time = 0
local last_press_time = 0
local waiting_for_double = false

-- Cleanup function
local function cleanup()
    print("\nCleaning up...")
    for i, led in ipairs(leds) do
        led:write(false)
        led:close()
    end
    button:close()
    print("Goodbye!")
    os.exit(0)
end

-- Helper functions
local function get_time()
    -- Get current time in seconds (with decimal precision)
    local handle = io.popen("date +%s.%N")
    local result = handle:read("*a")
    handle:close()
    return tonumber(result) or os.time()
end

local function delay(seconds)
    os.execute("sleep " .. seconds)
end

local function all_leds_off()
    for i, led in ipairs(leds) do
        led:write(false)
    end
end

-- Actions for different press types
local function short_press_action()
    print("Short press detected - Next LED")
    all_leds_off()
    current_led = current_led + 1
    if current_led > #leds then
        current_led = 1
    end
    leds[current_led]:write(true)
    print("LED " .. current_led .. " is now ON")
end

local function long_press_action()
    print("Long press detected - Flash all LEDs")
    for flash = 1, 5 do
        for i, led in ipairs(leds) do
            led:write(true)
        end
        delay(0.2)
        all_leds_off()
        delay(0.2)
    end
    -- Restore current LED
    leds[current_led]:write(true)
end

local function double_press_action()
    print("Double press detected - Chase pattern")
    for cycle = 1, 3 do
        for i, led in ipairs(leds) do
            all_leds_off()
            led:write(true)
            delay(0.15)
        end
    end
    -- Restore current LED
    all_leds_off()
    leds[current_led]:write(true)
end

-- Button state machine
local function handle_button_events()
    local button_pressed = not button:read()  -- Active low
    local current_time = get_time()
    
    -- Button press detected
    if button_pressed and press_start_time == 0 then
        press_start_time = current_time
        return
    end
    
    -- Button released
    if not button_pressed and press_start_time > 0 then
        local press_duration = current_time - press_start_time
        press_start_time = 0
        
        -- Check for long press
        if press_duration >= LONG_PRESS_TIME then
            waiting_for_double = false
            long_press_action()
            return
        end
        
        -- Check for double press
        if waiting_for_double and (current_time - last_press_time) <= DOUBLE_PRESS_TIME then
            waiting_for_double = false
            double_press_action()
            return
        end
        
        -- Short press - but wait to see if it's a double press
        if press_duration >= SHORT_PRESS_TIME then
            if not waiting_for_double then
                waiting_for_double = true
                last_press_time = current_time
                
                -- Set up a timer to handle single press if no double press comes
                -- This is simplified - in practice you'd use proper timers
                return
            end
        end
    end
    
    -- Handle timeout for waiting double press
    if waiting_for_double and (current_time - last_press_time) > DOUBLE_PRESS_TIME then
        waiting_for_double = false
        short_press_action()
    end
end

-- Main loop
local function main()
    print("Ready! Try different button press patterns...")
    
    -- Start with first LED on
    leds[current_led]:write(true)
    print("LED " .. current_led .. " is ON")
    
    while true do
        handle_button_events()
        delay(0.01)  -- Small delay
    end
end

-- Run with error handling
local success, error_msg = pcall(main)
if not success then
    print("Error: " .. error_msg)
    cleanup()
end
```

## Testing Your Project

### 1. Basic Button Test
```bash
lua button_test.lua

# Test cases:
# - Press button → LED should toggle
# - Press multiple times → LED should toggle each time
# - Hold button → Should only toggle once per press
```

### 2. Two-Button Controller Test
```bash
lua two_button_control.lua

# Test each mode:
# Mode 1: Button2 cycles through LEDs
# Mode 2: Button2 runs sequential pattern  
# Mode 3: Button2 toggles all LEDs
# Button1 always changes mode
```

### 3. State Machine Test
```bash
lua button_state_machine.lua

# Test press patterns:
# Quick press → Next LED
# Hold for 1+ seconds → Flash all
# Two quick presses → Chase pattern
```

## Troubleshooting

### Button Not Responding
1. **Check pull-up resistor**: Should be 10kΩ
2. **Verify connections**: Button should connect GPIO to GND
3. **Test button mechanically**: Should have tactile click
4. **Check GPIO reading**: Add debug prints

### Inconsistent Button Readings
1. **Debouncing issues**: Increase debounce delay
2. **Floating pin**: Ensure pull-up resistor is connected
3. **Electrical noise**: Add capacitor across button (optional)

### Multiple Triggers
1. **Mechanical bouncing**: Implement better debouncing
2. **Software timing**: Check loop delay values
3. **Button quality**: Some cheap buttons bounce more

## Experiments and Extensions

### 1. Improved Debouncing
Try different debouncing methods:
- Software filtering
- State machines
- Interrupt-based reading

### 2. More Button Patterns
- Triple-click detection
- Button combinations (both buttons pressed)
- Rhythm patterns (morse code input)

### 3. Responsive Interface
- Real-time status display
- Button feedback (LED shows button state)
- Configuration menu system

## What You've Learned

✅ Digital input programming with pull-up resistors  
✅ Button debouncing techniques  
✅ Event-driven programming patterns  
✅ State management in hardware  
✅ Combining inputs and outputs effectively  
✅ Advanced button press detection  

## Next Steps

Excellent! You now understand both digital outputs and inputs. You're ready for:

👉 **[Project 3: Temperature Sensor](03-temperature-sensor.md)**

In the next project, you'll learn to read analog sensors and work with real-world data!

---

**Challenge**: Create a simple game using the buttons and LEDs. Maybe a reaction time game or a memory pattern game like Simon Says?