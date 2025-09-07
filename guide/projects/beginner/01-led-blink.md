# Project 1: LED Blink Control

The LED blink is the "Hello, World!" of hardware programming. In this project, you'll learn to control LEDs with different blinking patterns and create a foundation for all future hardware projects.

## What You'll Learn

- Basic GPIO setup and control
- Digital output programming
- Creating timing loops
- Working with multiple LEDs
- Pattern programming
- Safe hardware practices

## Required Components

- Raspberry Pi (any model with GPIO)
- Breadboard
- 3x LEDs (different colors recommended)
- 3x 220Ω resistors
- Jumper wires (male-to-female)
- Multimeter (for testing)

## Circuit Diagram

```
Raspberry Pi GPIO Layout:
┌─────────────────────────┐
│ 3.3V [ 1] [ 2] 5V      │
│GPIO2 [ 3] [ 4] 5V      │
│GPIO3 [ 5] [ 6] GND     │
│GPIO4 [ 7] [ 8] GPIO14  │
│ GND  [ 9] [10] GPIO15  │
│GPIO17[11] [12] GPIO18  │
│GPIO27[13] [14] GND     │
│GPIO22[15] [16] GPIO23  │
│ 3.3V[17] [18] GPIO24  │
│     ...more pins...     │
└─────────────────────────┘

Simple LED Circuit:
GPIO18 → 220Ω Resistor → LED(+) → LED(-) → GND

Multiple LED Circuit:
GPIO18 → 220Ω → LED1 → GND
GPIO23 → 220Ω → LED2 → GND  
GPIO24 → 220Ω → LED3 → GND
```

### Breadboard Layout
```
     Breadboard
 a b c d e   f g h i j
 ┌─┬─┬─┬─┬───┬─┬─┬─┬─┐
1│ │ │ │ │   │ │ │ │ │  ← 3.3V (Pin 17)
 ├─┼─┼─┼─┼───┼─┼─┼─┼─┤
2│ │R│ │ │   │+│-│ │ │  ← R=220Ω, LED
 ├─┼─┼─┼─┼───┼─┼─┼─┼─┤
3│ │ │ │ │   │ │G│ │ │  ← G=GND
 └─┴─┴─┴─┴───┴─┴─┴─┴─┘

Connections:
- GPIO18 → a2 (through resistor b2-f2)
- LED + → g2, LED - → h2  
- GND → i2 (connects to h2)
```

## Building the Circuit

### Step 1: Safety First
1. **Power off** your Raspberry Pi
2. **Unplug** power cable
3. **Organize** your components on a clean workspace

### Step 2: Single LED Circuit
1. Place LED on breadboard (note polarity - longer leg is positive)
2. Connect 220Ω resistor to LED's positive leg
3. Connect GPIO18 to the other end of resistor
4. Connect LED's negative leg to GND
5. **Double-check connections** before powering on

### Step 3: Test Your Circuit
Use a multimeter to verify:
- Continuity from GPIO18 to LED positive (through resistor)
- Continuity from LED negative to GND
- No short circuits between power and ground

## Code Examples

### Basic LED Blink

Create `led_blink.lua`:

```lua
#!/usr/bin/env lua

-- LED Blink Control - Basic Version
-- Hardware: LED connected to GPIO18 through 220Ω resistor

local periphery = require('periphery')
local GPIO = periphery.GPIO

-- Configuration
local LED_PIN = 18
local BLINK_DELAY = 0.5  -- seconds

print("=== LED Blink Control ===")
print("LED Pin: GPIO" .. LED_PIN)
print("Press Ctrl+C to stop")

-- Initialize GPIO
local led = GPIO(LED_PIN, "out")

-- Cleanup function
local function cleanup()
    print("\nCleaning up...")
    led:write(false)  -- Turn off LED
    led:close()       -- Release GPIO
    print("Goodbye!")
    os.exit(0)
end

-- Set up signal handler for Ctrl+C
-- Note: This is a simplified version - proper signal handling varies by system
local function signal_handler()
    cleanup()
end

-- Main blinking loop
local function main()
    local blink_count = 0
    
    while true do
        blink_count = blink_count + 1
        
        -- Turn LED on
        print("Blink " .. blink_count .. " - LED ON")
        led:write(true)
        os.execute("sleep " .. BLINK_DELAY)
        
        -- Turn LED off  
        print("Blink " .. blink_count .. " - LED OFF")
        led:write(false)
        os.execute("sleep " .. BLINK_DELAY)
    end
end

-- Run the program
main()
```

Run it:
```bash
lua led_blink.lua
```

### Multiple LED Pattern

Create `led_patterns.lua`:

```lua
#!/usr/bin/env lua

-- LED Pattern Control - Multiple LEDs
-- Hardware: 3 LEDs connected to GPIO18, 23, 24

local periphery = require('periphery')
local GPIO = periphery.GPIO

-- Configuration
local LED_PINS = {18, 23, 24}
local PATTERN_DELAY = 0.3

print("=== LED Pattern Control ===")
print("LED Pins: GPIO" .. table.concat(LED_PINS, ", GPIO"))
print("Press Ctrl+C to stop")

-- Initialize all LEDs
local leds = {}
for i, pin in ipairs(LED_PINS) do
    leds[i] = GPIO(pin, "out")
    leds[i]:write(false)  -- Start with all LEDs off
end

-- Cleanup function
local function cleanup()
    print("\nTurning off all LEDs...")
    for i, led in ipairs(leds) do
        led:write(false)
        led:close()
    end
    print("Cleanup complete!")
    os.exit(0)
end

-- Helper function for delays
local function delay(seconds)
    os.execute("sleep " .. seconds)
end

-- Turn all LEDs off
local function all_off()
    for i, led in ipairs(leds) do
        led:write(false)
    end
end

-- Turn all LEDs on
local function all_on()
    for i, led in ipairs(leds) do
        led:write(true)
    end
end

-- Pattern 1: Sequential blink
local function pattern_sequential()
    print("Pattern: Sequential")
    for cycle = 1, 3 do
        for i, led in ipairs(leds) do
            all_off()
            led:write(true)
            print("  LED " .. i .. " ON")
            delay(PATTERN_DELAY)
        end
    end
    all_off()
end

-- Pattern 2: All flash together
local function pattern_flash()
    print("Pattern: Flash All")
    for cycle = 1, 5 do
        all_on()
        print("  All LEDs ON")
        delay(PATTERN_DELAY)
        all_off()
        print("  All LEDs OFF")
        delay(PATTERN_DELAY)
    end
end

-- Pattern 3: Reverse sequential
local function pattern_reverse()
    print("Pattern: Reverse Sequential")
    for cycle = 1, 3 do
        for i = #leds, 1, -1 do
            all_off()
            leds[i]:write(true)
            print("  LED " .. i .. " ON")
            delay(PATTERN_DELAY)
        end
    end
    all_off()
end

-- Pattern 4: Binary counter
local function pattern_binary()
    print("Pattern: Binary Counter (0-7)")
    for count = 0, 7 do
        all_off()
        print("  Count: " .. count)
        
        -- Convert count to binary and set LEDs
        for bit = 0, 2 do
            if (count & (1 << bit)) ~= 0 then
                leds[bit + 1]:write(true)
            end
        end
        delay(PATTERN_DELAY * 2)
    end
    all_off()
end

-- Main function
local function main()
    while true do
        pattern_sequential()
        delay(1)
        
        pattern_flash()
        delay(1)
        
        pattern_reverse()
        delay(1)
        
        pattern_binary()
        delay(2)
        
        print("--- Repeating patterns ---")
    end
end

-- Error handling wrapper
local success, error_msg = pcall(main)
if not success then
    print("Error: " .. error_msg)
    cleanup()
end
```

### Advanced: SOS Signal

Create `sos_signal.lua`:

```lua
#!/usr/bin/env lua

-- SOS Signal - International distress signal
-- Pattern: ... --- ... (dot dot dot, dash dash dash, dot dot dot)

local periphery = require('periphery')
local GPIO = periphery.GPIO

-- Configuration
local LED_PIN = 18
local DOT_DURATION = 0.2      -- Short blink
local DASH_DURATION = 0.6     -- Long blink  
local SYMBOL_PAUSE = 0.2      -- Pause between dots/dashes
local LETTER_PAUSE = 0.6      -- Pause between letters
local WORD_PAUSE = 2.0        -- Pause before repeating

print("=== SOS Emergency Signal ===")
print("LED Pin: GPIO" .. LED_PIN)
print("Pattern: ... --- ... (S O S)")
print("Press Ctrl+C to stop")

-- Initialize LED
local led = GPIO(LED_PIN, "out")
led:write(false)

-- Cleanup function
local function cleanup()
    print("\nEmergency signal stopped")
    led:write(false)
    led:close()
    os.exit(0)
end

-- Helper functions
local function delay(seconds)
    os.execute("sleep " .. seconds)
end

local function dot()
    print(".")
    led:write(true)
    delay(DOT_DURATION)
    led:write(false)
    delay(SYMBOL_PAUSE)
end

local function dash()
    print("-")
    led:write(true)
    delay(DASH_DURATION)
    led:write(false)
    delay(SYMBOL_PAUSE)
end

-- SOS pattern
local function sos_signal()
    -- S: ... (3 dots)
    print("S: ", "")
    for i = 1, 3 do
        dot()
    end
    delay(LETTER_PAUSE)
    
    -- O: --- (3 dashes)  
    print("O: ", "")
    for i = 1, 3 do
        dash()
    end
    delay(LETTER_PAUSE)
    
    -- S: ... (3 dots)
    print("S: ", "")
    for i = 1, 3 do
        dot()
    end
    
    print("SOS complete - waiting before repeat")
    delay(WORD_PAUSE)
end

-- Main loop
local function main()
    local signal_count = 0
    
    while true do
        signal_count = signal_count + 1
        print("\n=== SOS Signal #" .. signal_count .. " ===")
        sos_signal()
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

### 1. Basic Functionality Test
```bash
# Test single LED blink
lua led_blink.lua

# Expected: LED blinks on/off every 0.5 seconds
# Look for: Steady, consistent blinking
```

### 2. Pattern Test  
```bash
# Test multiple LED patterns
lua led_patterns.lua

# Expected: Different patterns repeating
# Look for: All patterns working, no stuck LEDs
```

### 3. SOS Test
```bash
# Test SOS signal
lua sos_signal.lua

# Expected: ... --- ... pattern
# Look for: Correct timing, clear pattern
```

## Troubleshooting

### LED Not Lighting
1. **Check polarity**: Longer LED leg should be positive
2. **Check resistor**: Use 220Ω, not 220kΩ  
3. **Verify connections**: Use multimeter for continuity
4. **Test LED**: Connect directly to 3.3V with resistor

### Inconsistent Blinking
1. **Check power supply**: Ensure adequate current
2. **Verify GPIO assignment**: Use `gpio readall` command
3. **Check software**: Add debug print statements

### Permission Errors
```bash
# Add user to gpio group
sudo usermod -a -G gpio $USER

# Logout and login again, or use sudo
sudo lua led_blink.lua
```

## Experiments and Extensions

### 1. Timing Experiments
- Vary blink speeds from very slow (2 seconds) to very fast (0.1 seconds)
- Find the fastest speed where you can still see individual blinks

### 2. More Patterns
Try creating these patterns:
- Knight Rider sweep (left to right, right to left)
- Random blinking
- Fade effect (using PWM)
- Music visualization

### 3. User Control
- Read blink speed from user input
- Add command-line parameters for different patterns
- Create an interactive menu

### 4. Multiple Colors
If you have RGB LEDs:
- Create color mixing patterns
- Rainbow effects
- Mood lighting

## What You've Learned

✅ Basic GPIO setup and control  
✅ Digital output programming  
✅ Circuit building and testing  
✅ Pattern programming logic  
✅ Error handling in hardware code  
✅ Safe hardware practices  

## Next Steps

Great job! You've mastered LED control. Now you're ready for:

👉 **[Project 2: Button Input Reading](02-button-input.md)**

In the next project, you'll learn to read digital inputs and create interactive hardware that responds to user actions!

---

**Challenge**: Before moving on, try creating your own custom LED pattern. Can you make the LEDs spell out your initials in Morse code?