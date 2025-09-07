# Basic Syntax and Data Types

Now that you've written your first Lua program, let's dive deeper into Lua's syntax and data types. This lesson covers the fundamental building blocks you'll use in every Lua program.

## Variables and Assignment

### Creating Variables

In Lua, variables are created simply by assigning values to them:

```lua
-- Global variables (avoid these in most cases)
temperature = 25.6
device_name = "Arduino"

-- Local variables (recommended)
local voltage = 3.3
local current = 0.02
local is_active = true
```

**Always use `local`** unless you specifically need a global variable. Local variables are:
- Faster to access
- Automatically cleaned up when no longer needed
- Don't pollute the global namespace

### Multiple Assignment

Lua supports multiple assignment, which is very handy:

```lua
-- Assign multiple variables at once
local x, y, z = 1, 2, 3
local name, age = "Arduino", 15

-- Swap variables easily
local a, b = 10, 20
a, b = b, a  -- Now a=20, b=10

-- Hardware example: multiple sensor readings
local temp, humidity, pressure = read_sensors()
```

## Data Types

Lua has eight basic data types. Let's explore each one:

### 1. Numbers

Lua has only one numeric type that represents both integers and floating-point numbers:

```lua
-- Integers
local led_count = 5
local gpio_pin = 18

-- Floating-point numbers  
local voltage = 3.3
local temperature = 23.5
local frequency = 1.5e6  -- Scientific notation: 1,500,000

-- Arithmetic operations
local resistance = 1000  -- 1k ohm
local current = voltage / resistance  -- Ohm's law: I = V / R
local power = voltage * current       -- Power: P = V * I

print("Current: " .. current .. " amps")
print("Power: " .. power .. " watts")
```

### 2. Strings

Strings represent text and can be created in several ways:

```lua
-- Simple strings
local device = "Raspberry Pi"
local status = 'active'

-- Multi-line strings
local description = [[
This is a multi-line string.
It can span several lines
and includes everything, even "quotes"
]]

-- String concatenation with ..
local message = "Temperature: " .. temperature .. "°C"

-- String length
local name = "Arduino"
print("Device name has " .. #name .. " characters")

-- String methods
local sensor = "DHT22-Temperature-Sensor"
print(string.upper(sensor))        -- DHT22-TEMPERATURE-SENSOR
print(string.lower(sensor))        -- dht22-temperature-sensor
print(string.sub(sensor, 1, 5))    -- DHT22

-- String formatting (like printf)
local formatted = string.format("Temp: %.1f°C, Humidity: %.1f%%", 
                                temp, humidity)
```

### 3. Booleans

Booleans represent true/false values:

```lua
local led_on = true
local sensor_connected = false
local debug_mode = true

-- Boolean operations
local all_good = sensor_connected and led_on
local has_problem = not sensor_connected
local any_issue = has_problem or debug_mode

-- Conditional assignment
local status = led_on and "ON" or "OFF"  -- Ternary-like operator
```

**Important**: In Lua, only `false` and `nil` are considered false. Everything else (including 0 and empty strings) is true!

```lua
-- These are all TRUE in Lua:
if 0 then print("0 is true!") end
if "" then print("Empty string is true!") end
if {} then print("Empty table is true!") end

-- Only these are FALSE:
if false then print("This won't print") end
if nil then print("This won't print either") end
```

### 4. Tables

Tables are Lua's only data structure, but they're incredibly versatile:

```lua
-- Array-like tables (indexed starting from 1)
local sensors = {"temperature", "humidity", "pressure"}
print(sensors[1])  -- temperature
print(sensors[2])  -- humidity

-- Dictionary-like tables
local config = {
    pin = 18,
    frequency = 1000,
    active = true
}
print(config.pin)       -- 18
print(config["pin"])    -- 18 (alternative syntax)

-- Mixed tables
local device = {
    name = "ESP32",
    pins = 30,
    wifi = true,
    sensors = {"temp", "humidity"},  -- nested table
    
    -- Functions can be stored in tables
    turn_on = function()
        print("Device is turning on...")
    end
}

device.turn_on()  -- Call the function
```

### 5. Functions

Functions are first-class values in Lua:

```lua
-- Simple function
local function greet(name)
    return "Hello, " .. name .. "!"
end

-- Function as variable
local say_hello = function(name)
    print("Hello, " .. name)
end

-- Function with multiple returns
local function read_dht22()
    local temperature = 25.6
    local humidity = 60.2
    return temperature, humidity
end

local temp, hum = read_dht22()

-- Function stored in table (method-like)
local sensor = {
    name = "DHT22",
    
    read = function(self)
        return math.random(20, 30)  -- Simulate reading
    end
}

-- Call methods
local reading = sensor:read()  -- The colon adds 'self' automatically
-- Equivalent to: sensor.read(sensor)
```

### 6. Nil

`nil` represents "no value" or "undefined":

```lua
local undefined_var  -- This is nil
local sensor_reading = nil  -- Explicitly nil

-- Check for nil
if sensor_reading == nil then
    print("No sensor reading available")
end

-- or use 'not'
if not sensor_reading then
    print("Sensor reading is nil or false")
end

-- Remove table entries by setting to nil
local config = {pin = 18, frequency = 1000}
config.pin = nil  -- Remove the pin entry
```

### 7. Userdata and 8. Thread

These are advanced types used for C integration and coroutines. You won't need them for basic hardware programming.

## Operators

### Arithmetic Operators

```lua
local a, b = 10, 3

print(a + b)   -- 13 (addition)
print(a - b)   -- 7  (subtraction)  
print(a * b)   -- 30 (multiplication)
print(a / b)   -- 3.333... (division)
print(a % b)   -- 1  (modulo/remainder)
print(a ^ b)   -- 1000 (exponentiation: 10^3)

-- Integer division (Lua 5.3+)
print(a // b)  -- 3 (floor division)

-- Increment/decrement (no ++ or -- operators in Lua)
local counter = 0
counter = counter + 1  -- Must write it out
```

### Comparison Operators

```lua
local temp1, temp2 = 25, 30

print(temp1 == temp2)  -- false (equal)
print(temp1 ~= temp2)  -- true  (not equal)
print(temp1 < temp2)   -- true  (less than)
print(temp1 <= temp2)  -- true  (less than or equal)
print(temp1 > temp2)   -- false (greater than)
print(temp1 >= temp2)  -- false (greater than or equal)

-- String comparison
print("apple" < "banana")  -- true (lexicographic order)
```

### Logical Operators

```lua
local temp = 25
local humidity = 60

-- and, or, not (not &&, ||, !)
local comfortable = temp > 20 and temp < 30 and humidity < 70
local needs_attention = temp > 35 or humidity > 80
local sensor_ok = not (temp == nil)

-- Short-circuit evaluation
local safe_temp = temp and (temp < 40) or false
```

### String Operators

```lua
-- Concatenation with ..
local device = "Raspberry"
local model = "Pi 4"
local full_name = device .. " " .. model  -- "Raspberry Pi 4"

-- Length with #
local name = "Arduino"
print(#name)  -- 7
```

## Type Checking

Lua provides the `type()` function to check variable types:

```lua
local temp = 25.5
local name = "sensor"
local active = true
local config = {}
local func = function() end

print(type(temp))    -- number
print(type(name))    -- string  
print(type(active))  -- boolean
print(type(config))  -- table
print(type(func))    -- function
print(type(nil))     -- nil

-- Useful for debugging
local function debug_variable(var, var_name)
    print(var_name .. " is a " .. type(var) .. " with value: " .. tostring(var))
end

debug_variable(temp, "temperature")
```

## Type Conversion

Lua performs automatic type conversion in many cases, but you can also convert explicitly:

```lua
-- String to number
local str_num = "42"
local num = tonumber(str_num)  -- 42
print(type(num))  -- number

-- Number to string
local value = 25.6
local str_value = tostring(value)  -- "25.6"
print(type(str_value))  -- string

-- Automatic conversion in concatenation
local message = "Temperature: " .. 25.6  -- Lua converts 25.6 to string

-- Boolean to string
local status = true
print(tostring(status))  -- "true"

-- Be careful with automatic conversion
print("10" + "20")  -- 30 (strings converted to numbers)
print("10" .. 20)   -- "1020" (number converted to string)
```

## Variable Scope

Understanding scope is crucial for writing maintainable code:

```lua
local global_temp = 25  -- Available in entire file

local function read_sensors()
    local local_temp = 23    -- Only available in this function
    local humidity = 60
    
    if local_temp > 20 then
        local message = "Warm"  -- Only available in this if block
        print(message)
    end
    -- print(message)  -- Error! message not available here
    
    return local_temp, humidity
end

-- print(local_temp)  -- Error! local_temp not available here
print(global_temp)   -- OK! Available here
```

### Block Scope

You can create blocks with `do...end`:

```lua
local sensor_count = 0

do
    local temp_sensors = 3
    local humidity_sensors = 2
    sensor_count = temp_sensors + humidity_sensors
end

-- temp_sensors not available here
print("Total sensors: " .. sensor_count)  -- 5
```

## Comments

Good comments make your code easier to understand:

```lua
-- Single line comment

--[[
Multi-line comment
Useful for longer explanations
or temporarily disabling code
]]

local pin = 18  -- GPIO pin for LED

--[[
This function reads temperature from DHT22 sensor
connected to GPIO pin 4
Returns: temperature in Celsius or nil if error
]]
local function read_temperature()
    -- Implementation here
end
```

## Common Patterns and Idioms

### Safe Navigation

```lua
-- Check if value exists before using
local config = get_config()
local pin = config and config.gpio and config.gpio.led_pin or 18

-- Or more explicitly
local pin = 18  -- default
if config and config.gpio and config.gpio.led_pin then
    pin = config.gpio.led_pin
end
```

### Default Values

```lua
-- Using 'or' for defaults
local function set_frequency(freq)
    freq = freq or 1000  -- Default to 1000 if nil or false
    -- Set the frequency
end

-- For function parameters
local function blink_led(pin, duration, count)
    pin = pin or 18
    duration = duration or 0.5
    count = count or 10
    -- Blink implementation
end
```

### Table Iteration

```lua
-- Array-like iteration
local sensors = {"temp", "humidity", "pressure"}
for i, sensor in ipairs(sensors) do
    print(i .. ": " .. sensor)
end

-- Dictionary-like iteration  
local config = {pin = 18, frequency = 1000, active = true}
for key, value in pairs(config) do
    print(key .. " = " .. tostring(value))
end
```

## Hardware Programming Examples

Let's put it all together with some hardware-focused examples:

### GPIO Pin Configuration

```lua
local gpio_config = {
    led_pins = {18, 23, 24},
    button_pins = {2, 3},
    sensor_pins = {
        temperature = 4,
        light = 17
    },
    
    -- Configuration validation
    validate = function(self)
        for _, pin in ipairs(self.led_pins) do
            if type(pin) ~= "number" or pin < 1 or pin > 40 then
                return false, "Invalid LED pin: " .. tostring(pin)
            end
        end
        return true
    end
}

local valid, error_msg = gpio_config:validate()
if not valid then
    print("Configuration error: " .. error_msg)
end
```

### Sensor Data Processing

```lua
local function process_sensor_data(raw_data)
    -- Type checking and validation
    if type(raw_data) ~= "table" then
        return nil, "Expected table, got " .. type(raw_data)
    end
    
    local processed = {}
    
    -- Process temperature
    if raw_data.temperature then
        local temp = tonumber(raw_data.temperature)
        if temp and temp > -40 and temp < 80 then
            processed.temperature = {
                celsius = temp,
                fahrenheit = temp * 9/5 + 32,
                status = temp > 30 and "hot" or (temp < 10 and "cold" or "normal")
            }
        end
    end
    
    -- Process humidity
    if raw_data.humidity then
        local hum = tonumber(raw_data.humidity)
        if hum and hum >= 0 and hum <= 100 then
            processed.humidity = {
                percent = hum,
                status = hum > 70 and "high" or (hum < 30 and "low" or "normal")
            }
        end
    end
    
    return processed
end

-- Usage
local raw = {temperature = "25.6", humidity = "60"}
local data, error = process_sensor_data(raw)
if data then
    print("Temperature: " .. data.temperature.celsius .. "°C (" .. 
          data.temperature.status .. ")")
else
    print("Error: " .. error)
end
```

## What You've Learned

✅ Variables and local vs global scope  
✅ All eight Lua data types  
✅ Operators and expressions  
✅ Type checking and conversion  
✅ Common programming patterns  
✅ Hardware-specific examples  

## Common Beginner Mistakes

1. **Forgetting `local`**: Always use `local` unless you need global variables
2. **Mixing up `nil` and `false`**: Remember only `nil` and `false` are falsy
3. **Array indexing**: Lua arrays start at 1, not 0
4. **String concatenation**: Use `..` not `+`
5. **Type assumptions**: Use `type()` to check when unsure

## Practice Exercises

Try these exercises to reinforce what you've learned:

```lua
-- Exercise 1: Create a sensor configuration table
-- Include pins, thresholds, and validation function

-- Exercise 2: Write a function that converts between temperature units
-- Should handle Celsius, Fahrenheit, and Kelvin

-- Exercise 3: Create a function that validates GPIO pin numbers
-- Should return true/false and error message

-- Exercise 4: Build a simple data logger
-- Store sensor readings with timestamps in a table
```

## Next Steps

Great! You now understand Lua's basic syntax and data types. You're ready to learn about:

👉 **[Control Structures](04-control-structures.md)** - if/else statements, loops, and program flow

This will give you the tools to make decisions and repeat actions in your hardware programs!

---

**Key Takeaway**: Lua's simple syntax and flexible data types make it perfect for hardware programming. Focus on using `local` variables and understanding tables - they're the foundation of everything you'll build!