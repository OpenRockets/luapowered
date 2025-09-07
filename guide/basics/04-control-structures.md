# Control Structures

Control structures determine the flow of your program - when to execute certain code, how many times to repeat actions, and how to make decisions. They're essential for creating interactive hardware that responds to conditions and events.

## Conditional Statements (if/else)

### Basic if Statement

```lua
local temperature = 28

if temperature > 25 then
    print("It's warm!")
end

-- Hardware example: LED warning system
local voltage = 3.5
if voltage > 3.3 then
    print("WARNING: Voltage too high!")
    -- Turn on warning LED
    led_warning:write(true)
end
```

### if...else Statement

```lua
local button_pressed = read_button()

if button_pressed then
    print("Button is pressed")
    led:write(true)
else
    print("Button is not pressed")
    led:write(false)
end
```

### if...elseif...else Chain

```lua
local temperature = read_temperature()

if temperature > 30 then
    print("Hot! Turn on cooling fan")
    fan:write(true)
    status_led = "red"
elseif temperature > 20 then
    print("Comfortable temperature")
    fan:write(false)
    status_led = "green"  
elseif temperature > 10 then
    print("Cool, but OK")
    status_led = "yellow"
else
    print("Cold! Turn on heater")
    heater:write(true)
    status_led = "blue"
end
```

### Logical Operators in Conditions

```lua
local temp = 25
local humidity = 65
local light_level = 800

-- AND: Both conditions must be true
if temp > 20 and temp < 30 then
    print("Perfect temperature range")
end

-- OR: At least one condition must be true  
if temp > 35 or humidity > 80 then
    print("Uncomfortable conditions!")
end

-- NOT: Inverts the condition
if not button_pressed then
    print("Waiting for button press...")
end

-- Complex conditions
if (temp > 25 and humidity > 70) or light_level < 100 then
    print("Turn on air conditioning or lights")
end
```

## Loops

Loops let you repeat actions - essential for reading sensors continuously or creating patterns.

### while Loop

Executes while a condition is true:

```lua
-- Basic while loop
local count = 0
while count < 5 do
    print("Count: " .. count)
    count = count + 1
end

-- Hardware example: Wait for button press
print("Waiting for button press...")
while not read_button() do
    -- Check every 100ms
    delay(0.1)
end
print("Button pressed!")

-- Sensor monitoring loop
local temperature = 0
while temperature < 30 do
    temperature = read_temperature()
    print("Current temperature: " .. temperature .. "°C")
    
    if temperature < 25 then
        heater:write(true)
    else
        heater:write(false)
    end
    
    delay(1)  -- Wait 1 second
end
print("Target temperature reached!")
```

### for Loop (Numeric)

Great for repeating actions a specific number of times:

```lua
-- Basic for loop: for var = start, end, step
for i = 1, 5 do
    print("Iteration: " .. i)
end

-- Hardware example: Blink LED 10 times
print("Blinking LED 10 times...")
for blink = 1, 10 do
    print("Blink " .. blink)
    led:write(true)
    delay(0.5)
    led:write(false)
    delay(0.5)
end

-- Count down (step = -1)
print("Countdown:")
for count = 5, 1, -1 do
    print(count)
    status_display:show(count)
    delay(1)
end
print("Launch!")

-- Custom step size
print("Even numbers from 2 to 10:")
for num = 2, 10, 2 do
    print(num)
end
```

### for Loop (Generic) - Tables

Perfect for processing lists and configurations:

```lua
-- Iterating over arrays
local sensors = {"temperature", "humidity", "pressure", "light"}

for index, sensor_name in ipairs(sensors) do
    print(index .. ": Reading " .. sensor_name .. " sensor")
    -- Read each sensor
    local value = read_sensor(sensor_name)
    print("  Value: " .. value)
end

-- Iterating over configuration
local gpio_config = {
    led_red = 18,
    led_green = 23,
    led_blue = 24,
    button = 2,
    sensor = 4
}

print("GPIO Configuration:")
for device, pin in pairs(gpio_config) do
    print("  " .. device .. " -> GPIO " .. pin)
    -- Initialize each GPIO pin
    initialize_gpio(pin, device)
end
```

### repeat...until Loop

Executes at least once, then repeats until condition becomes true:

```lua
-- Basic repeat...until
local count = 0
repeat
    print("Count: " .. count)
    count = count + 1
until count >= 5

-- Hardware example: Calibration routine
print("Calibrating sensor...")
local calibration_complete = false
repeat
    print("Please ensure sensor is in reference environment")
    delay(2)
    
    local reading = read_sensor()
    if math.abs(reading - reference_value) < tolerance then
        calibration_complete = true
        print("Calibration successful!")
    else
        print("Calibration failed, retrying...")
    end
until calibration_complete

-- Menu system example
local choice = 0
repeat
    print("\n=== Control Menu ===")
    print("1. Turn on LED")
    print("2. Read temperature")  
    print("3. Start motor")
    print("4. Exit")
    print("Enter choice (1-4): ")
    
    choice = tonumber(io.read())
    
    if choice == 1 then
        led:write(true)
        print("LED turned on")
    elseif choice == 2 then
        local temp = read_temperature()
        print("Temperature: " .. temp .. "°C")
    elseif choice == 3 then
        motor:start()
        print("Motor started")
    elseif choice == 4 then
        print("Goodbye!")
    else
        print("Invalid choice, try again")
    end
until choice == 4
```

## Break and Continue

### break Statement

Exits the current loop:

```lua
-- Exit loop when condition met
for i = 1, 100 do
    local button_state = read_button()
    
    if button_state then
        print("Button pressed at iteration " .. i)
        break  -- Exit the loop immediately
    end
    
    print("Waiting... " .. i)
    delay(0.1)
end

-- Safety check in monitoring loop
while true do
    local temperature = read_temperature()
    
    if temperature > 50 then
        print("EMERGENCY: Temperature too high!")
        emergency_shutdown()
        break  -- Exit monitoring loop
    end
    
    print("Temperature OK: " .. temperature .. "°C")
    delay(1)
end
```

Note: Lua doesn't have a `continue` statement like some other languages. Use conditional logic instead:

```lua
-- Instead of continue, use if statements
for i = 1, 10 do
    if i % 2 == 0 then
        -- Skip even numbers
        -- (no continue in Lua)
    else
        print("Odd number: " .. i)
    end
end

-- Or restructure the logic
for i = 1, 10 do
    if i % 2 ~= 0 then  -- Only process odd numbers
        print("Odd number: " .. i)
    end
end
```

## Nested Control Structures

You can combine control structures for complex logic:

```lua
-- Nested loops for LED matrix
local led_matrix = {
    {false, true, false},
    {true, false, true}, 
    {false, true, false}
}

print("Displaying LED pattern:")
for row = 1, #led_matrix do
    for col = 1, #led_matrix[row] do
        if led_matrix[row][col] then
            set_led(row, col, true)
            print("*", "")  -- Print without newline
        else
            set_led(row, col, false)
            print(" ", "")
        end
    end
    print()  -- New line after each row
end

-- Nested conditions for smart thermostat
local temperature = read_temperature()
local humidity = read_humidity()
local time_of_day = get_hour()

if temperature > 25 then
    if humidity > 70 then
        print("Hot and humid - turn on AC with dehumidifier")
        ac:set_mode("cool_dry")
    else
        print("Hot but dry - turn on AC only")
        ac:set_mode("cool")
    end
elseif temperature < 18 then
    if time_of_day >= 22 or time_of_day <= 6 then
        print("Cold at night - turn on heater (low)")
        heater:set_level("low")
    else
        print("Cold during day - turn on heater (medium)")
        heater:set_level("medium")
    end
else
    print("Comfortable temperature - systems off")
    ac:off()
    heater:off()
end
```

## Practical Hardware Examples

### Traffic Light Controller

```lua
local function traffic_light_cycle()
    local states = {
        {red = true,  yellow = false, green = false, duration = 30},
        {red = true,  yellow = true,  green = false, duration = 3},
        {red = false, yellow = false, green = true,  duration = 25},
        {red = false, yellow = true,  green = false, duration = 3}
    }
    
    print("Starting traffic light controller...")
    
    while true do
        for step, state in ipairs(states) do
            -- Set LED states
            led_red:write(state.red)
            led_yellow:write(state.yellow)
            led_green:write(state.green)
            
            -- Display current state
            local active_light = state.red and "RED" or 
                               (state.yellow and "YELLOW" or "GREEN")
            print("Light: " .. active_light .. " for " .. state.duration .. " seconds")
            
            -- Wait for duration
            for second = 1, state.duration do
                delay(1)
                
                -- Check for emergency button
                if read_emergency_button() then
                    print("EMERGENCY STOP!")
                    all_lights_flash()
                    return  -- Exit function
                end
            end
        end
    end
end
```

### Sensor Data Logger

```lua
local function data_logger()
    local readings = {}
    local max_readings = 100
    
    print("Starting data logger...")
    print("Press button to stop logging")
    
    while not read_stop_button() do
        -- Read all sensors
        local timestamp = os.time()
        local temp = read_temperature()
        local humidity = read_humidity()
        local light = read_light_level()
        
        -- Store reading
        local reading = {
            time = timestamp,
            temperature = temp,
            humidity = humidity,
            light = light
        }
        
        table.insert(readings, reading)
        
        -- Display current reading
        print(string.format("Time: %s, Temp: %.1f°C, Humidity: %.1f%%, Light: %d",
              os.date("%H:%M:%S", timestamp), temp, humidity, light))
        
        -- Check for alerts
        if temp > 30 then
            led_warning:write(true)
            print("  WARNING: High temperature!")
        elseif temp < 10 then
            led_warning:write(true)
            print("  WARNING: Low temperature!")
        else
            led_warning:write(false)
        end
        
        -- Limit memory usage
        if #readings > max_readings then
            table.remove(readings, 1)  -- Remove oldest reading
        end
        
        delay(5)  -- Log every 5 seconds
    end
    
    print("Data logging stopped.")
    print("Total readings collected: " .. #readings)
    
    -- Save data to file
    save_readings_to_file(readings)
end
```

### Automatic Plant Watering System

```lua
local function auto_watering_system()
    local watering_schedule = {
        {hour = 8,  duration = 30},   -- 8 AM, 30 seconds
        {hour = 18, duration = 45}    -- 6 PM, 45 seconds
    }
    
    print("Automatic watering system started")
    
    while true do
        local current_hour = tonumber(os.date("%H"))
        local current_minute = tonumber(os.date("%M"))
        local soil_moisture = read_soil_moisture()
        
        -- Check scheduled watering times
        for _, schedule in ipairs(watering_schedule) do
            if current_hour == schedule.hour and current_minute == 0 then
                print("Scheduled watering time!")
                water_plants(schedule.duration)
            end
        end
        
        -- Emergency watering if soil too dry
        if soil_moisture < 30 then  -- Less than 30% moisture
            print("EMERGENCY: Soil too dry! Starting emergency watering...")
            led_warning:write(true)
            water_plants(60)  -- Water for 1 minute
            led_warning:write(false)
        elseif soil_moisture > 80 then  -- More than 80% moisture
            print("Soil moisture high, skipping watering")
        end
        
        -- Status update
        print(string.format("Time: %s, Soil moisture: %d%%", 
              os.date("%H:%M"), soil_moisture))
        
        delay(60)  -- Check every minute
    end
end
```

## Common Control Flow Patterns

### State Machine Pattern

```lua
local state = "idle"
local last_button_press = 0

while true do
    local current_time = os.time()
    local button_pressed = read_button()
    
    if state == "idle" then
        led_status:write(false)  -- LED off
        
        if button_pressed then
            state = "active"
            last_button_press = current_time
            print("Entering active mode")
        end
        
    elseif state == "active" then
        led_status:write(true)   -- LED on
        
        if button_pressed then
            state = "shutdown"
            print("Shutting down...")
        elseif current_time - last_button_press > 30 then
            state = "timeout"
            print("Timeout - entering low power mode")
        end
        
    elseif state == "timeout" then
        -- Blink LED slowly
        led_status:write(current_time % 2 == 0)
        
        if button_pressed then
            state = "active"
            last_button_press = current_time
            print("Reactivated!")
        end
        
    elseif state == "shutdown" then
        led_status:write(false)
        print("System shut down")
        break  -- Exit main loop
    end
    
    delay(0.1)
end
```

### Debounced Input Pattern

```lua
local function read_button_debounced(pin, debounce_time)
    debounce_time = debounce_time or 0.05  -- 50ms default
    
    local state1 = gpio.read(pin)
    delay(debounce_time)
    local state2 = gpio.read(pin)
    
    return state1 == state2 and state1
end

-- Usage in main loop
local last_button_state = false

while true do
    local current_button_state = read_button_debounced(2)
    
    -- Detect button press (transition from false to true)
    if current_button_state and not last_button_state then
        print("Button pressed!")
        toggle_led()
    end
    
    last_button_state = current_button_state
    delay(0.01)
end
```

## Error Handling with Control Structures

```lua
local function safe_sensor_read()
    local max_retries = 3
    local retry_count = 0
    
    while retry_count < max_retries do
        local success, value = pcall(read_temperature_sensor)
        
        if success and value then
            return value  -- Success!
        else
            retry_count = retry_count + 1
            print("Sensor read failed, retry " .. retry_count)
            
            if retry_count < max_retries then
                delay(1)  -- Wait before retry
            end
        end
    end
    
    print("ERROR: Could not read sensor after " .. max_retries .. " attempts")
    return nil
end
```

## What You've Learned

✅ Conditional statements (if/else/elseif)  
✅ All types of loops (while, for, repeat...until)  
✅ Loop control with break  
✅ Nested control structures  
✅ Real-world hardware programming patterns  
✅ State machines and error handling  

## Practice Exercises

Try these exercises to master control structures:

1. **Temperature Controller**: Create a system that maintains temperature between 20-25°C using a heater and fan

2. **Security System**: Build a system that monitors multiple sensors and triggers alarms based on different conditions

3. **LED Patterns**: Create different LED blinking patterns controlled by button presses

4. **Menu System**: Build an interactive menu for controlling various hardware functions

## Next Steps

Excellent! You now know how to control program flow and make decisions. Next, you'll learn about:

👉 **[Functions](05-functions.md)** - Writing reusable code and organizing your programs

Functions will help you organize your hardware control code into manageable, reusable pieces!

---

**Key Takeaway**: Control structures are the foundation of interactive hardware programming. Master these patterns and you can build sophisticated automated systems that respond intelligently to their environment!