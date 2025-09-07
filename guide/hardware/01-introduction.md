# Introduction to Hardware Programming

Welcome to the exciting world of hardware programming! In this lesson, you'll learn the fundamental concepts of controlling physical devices with code.

## What is Hardware Programming?

Hardware programming is the art of writing software that directly controls physical devices like:
- **LEDs** (Light Emitting Diodes)
- **Sensors** (temperature, light, motion)
- **Motors** (servo, stepper, DC motors)
- **Displays** (LCD, OLED screens)
- **Communication devices** (WiFi, Bluetooth modules)

Instead of just processing data in memory, your programs will interact with the real world!

## Key Concepts

### 1. GPIO (General Purpose Input/Output)
GPIO pins are the interface between your computer and the physical world.

```
Raspberry Pi GPIO Layout (simplified):
  3.3V  [ 1] [ 2]  5V
 GPIO2  [ 3] [ 4]  5V
 GPIO3  [ 5] [ 6]  GND
 GPIO4  [ 7] [ 8]  GPIO14
   GND  [ 9] [10]  GPIO15
GPIO17  [11] [12]  GPIO18
...and many more
```

Each GPIO pin can be:
- **Output**: Send signals to control devices (turn on LED, move motor)
- **Input**: Receive signals from sensors (button pressed, temperature reading)

### 2. Digital vs Analog Signals

#### Digital Signals
- Only two states: **HIGH** (on/1/3.3V) or **LOW** (off/0/0V)
- Like a light switch - either on or off
- Perfect for: LEDs, buttons, relay control

```lua
-- Example: Digital output (LED control)
gpio.output(18, gpio.HIGH)  -- LED on
gpio.output(18, gpio.LOW)   -- LED off
```

#### Analog Signals
- Continuous range of values (0V to 3.3V)
- Like a dimmer switch - can be anywhere between off and full brightness
- Perfect for: sensor readings, motor speed control

```lua
-- Example: Analog input (reading a sensor)
local sensor_value = adc.read(0)  -- Returns 0-4095
local voltage = sensor_value * 3.3 / 4095
```

### 3. Pull-up and Pull-down Resistors

When reading digital inputs (like buttons), you need to ensure the pin has a defined state:

```lua
-- Setup with internal pull-up resistor
gpio.setup(2, gpio.IN, gpio.PUD_UP)

-- Now when button is NOT pressed: pin reads HIGH
-- When button IS pressed (connected to ground): pin reads LOW
```

### 4. PWM (Pulse Width Modulation)

PWM lets you simulate analog output using digital pins:

```lua
-- Control LED brightness or motor speed
pwm.start(18, 50)  -- 50% duty cycle = half brightness/speed
```

## Common Hardware Programming Patterns

### 1. Initialization Pattern
Always set up your hardware before using it:

```lua
local gpio = require("periphery").GPIO

-- Setup LED pin as output
local led = gpio(18, "out")

-- Setup button pin as input with pull-up
local button = gpio(2, "in", "pull_up")
```

### 2. Main Loop Pattern
Most hardware programs run continuously:

```lua
-- Hardware setup here

while true do
    -- Read sensors
    local button_pressed = not button:read()  -- Active low
    
    -- Process data
    if button_pressed then
        led:write(true)   -- Turn on LED
    else
        led:write(false)  -- Turn off LED
    end
    
    -- Small delay to prevent excessive CPU usage
    gpio.sleep(0.1)  -- 100ms delay
end
```

### 3. State Machine Pattern
For more complex behaviors:

```lua
local state = "idle"
local last_button_time = 0

while true do
    local current_time = os.time()
    local button_pressed = not button:read()
    
    if state == "idle" and button_pressed then
        state = "blinking"
        last_button_time = current_time
    elseif state == "blinking" then
        -- Blink LED
        led:write(true)
        gpio.sleep(0.2)
        led:write(false)
        gpio.sleep(0.2)
        
        -- Return to idle after 5 seconds
        if current_time - last_button_time > 5 then
            state = "idle"
        end
    end
    
    gpio.sleep(0.1)
end
```

## Hardware Programming vs Software Programming

| Aspect | Software Programming | Hardware Programming |
|--------|---------------------|---------------------|
| **Input** | Keyboard, files, network | Sensors, buttons, switches |
| **Output** | Screen, files, network | LEDs, motors, speakers |
| **Timing** | Not critical (usually) | Often critical |
| **Debugging** | Print statements, debuggers | LEDs, multimeter, oscilloscope |
| **Errors** | Crashes, exceptions | Magic smoke, component damage! |

## Why Lua for Hardware?

### Advantages
1. **Fast prototyping**: Write and test code quickly
2. **Easy syntax**: Focus on logic, not language complexity  
3. **Small footprint**: Works on resource-constrained devices
4. **Real-time capable**: Good for time-sensitive applications
5. **Interactive**: Test code snippets immediately

### When to Use Lua
- **Learning**: Great for understanding concepts
- **Prototyping**: Quick proof-of-concept projects
- **Scripting**: Automating hardware tasks
- **IoT projects**: WiFi-enabled sensors and controllers

### When to Consider Alternatives
- **Real-time critical**: Microsecond timing requirements → C
- **Complex math**: Heavy signal processing → Python with NumPy
- **Large projects**: Thousands of lines → C++ or Python

## Your First Hardware Experience

Let's give you a taste of what's coming. Here's a simple "Hello, Hardware!" program:

```lua
-- Blink an LED - the "Hello World" of hardware programming
local gpio = require("periphery").GPIO
local led = gpio(18, "out")  -- GPIO pin 18

print("Starting LED blink...")
print("Press Ctrl+C to stop")

for i = 1, 10 do
    print("Blink " .. i)
    led:write(true)   -- LED on
    os.execute("sleep 0.5")  -- Wait 0.5 seconds
    led:write(false)  -- LED off  
    os.execute("sleep 0.5")  -- Wait 0.5 seconds
end

led:close()  -- Clean up
print("Blinking complete!")
```

Don't worry about the details yet - we'll cover everything step by step!

## Safety and Best Practices

### 🔌 Electrical Safety
- **Never exceed voltage ratings** (3.3V for most GPIO pins)
- **Use current-limiting resistors** with LEDs
- **Double-check connections** before powering on
- **Keep components organized** to avoid mistakes

### 💻 Software Safety  
- **Always clean up resources** (`gpio:close()`)
- **Handle errors gracefully** with `pcall()`
- **Add debug output** to understand what's happening
- **Start simple** and add complexity gradually

### 🧪 Testing Strategy
1. **Test with LED first** - visual feedback is invaluable
2. **Use a multimeter** to verify voltages
3. **Add print statements** to track program flow
4. **Test one component at a time**

## Common Hardware Terms

| Term | Definition |
|------|------------|
| **GPIO** | General Purpose Input/Output pins |
| **VCC/VDD** | Positive power supply |
| **GND** | Ground (negative power supply) |
| **Pull-up/Pull-down** | Resistors that set default pin states |
| **PWM** | Pulse Width Modulation (for analog-like control) |
| **ADC** | Analog-to-Digital Converter |
| **I2C, SPI, UART** | Communication protocols |

## What's Next?

Now that you understand the basics, you're ready to start controlling actual hardware! In the next lesson, we'll:

1. Set up your first circuit
2. Control an LED with GPIO
3. Read a button input
4. Combine input and output

Continue to [GPIO Control](02-gpio.md) to start building your first hardware project!

---

**Key Takeaways:**
- Hardware programming controls physical devices
- GPIO pins are your interface to the real world
- Digital signals are on/off, analog signals are continuous
- Always prioritize safety when working with electronics
- Lua is excellent for learning and prototyping hardware projects