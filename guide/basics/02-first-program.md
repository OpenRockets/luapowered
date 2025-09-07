# Your First Lua Program

Now that you have Lua installed, let's write and run your very first program! This lesson will teach you how to create, save, and execute Lua scripts.

## Writing Your First Script

### Method 1: Interactive Mode

First, let's try Lua's interactive mode (REPL - Read-Eval-Print Loop):

1. Open your terminal or command prompt
2. Type `lua` and press Enter
3. You should see something like:

```
Lua 5.4.6  Copyright (C) 1994-2023 Lua.org, PUC-Rio
>
```

Now you can type Lua commands directly:

```lua
> print("Hello, World!")
Hello, World!
> print("Welcome to hardware programming!")
Welcome to hardware programming!
> 2 + 3
5
> local name = "Arduino"
> print("I love programming " .. name)
I love programming Arduino
```

To exit interactive mode, type `os.exit()` or press Ctrl+C (Ctrl+Z on Windows).

### Method 2: Script Files

While interactive mode is great for testing, real programs are written in files. Let's create your first script file.

#### Step 1: Create the file
Create a new file called `hello.lua` using your text editor:

```lua
-- This is my first Lua program
-- Comments start with two dashes

print("Hello, Hardware World!")
print("This is my first Lua script")

-- Let's do some basic math
local voltage = 5.0
local current = 0.02  -- 20 milliamps
local power = voltage * current

print("Voltage: " .. voltage .. "V")
print("Current: " .. current .. "A") 
print("Power: " .. power .. "W")

-- Let's work with some hardware-related data
local sensors = {"temperature", "humidity", "pressure"}
print("\nAvailable sensors:")
for i, sensor in ipairs(sensors) do
    print(i .. ". " .. sensor)
end

print("\nProgram finished successfully!")
```

#### Step 2: Run the script
Open your terminal, navigate to the folder containing `hello.lua`, and run:

```bash
lua hello.lua
```

You should see output like:
```
Hello, Hardware World!
This is my first Lua script
Voltage: 5.0V
Current: 0.02A
Power: 0.1W

Available sensors:
1. temperature
2. humidity
3. pressure

Program finished successfully!
```

## Understanding the Code

Let's break down what each part does:

### Comments
```lua
-- This is a comment
--[[
    This is a
    multi-line comment
]]
```
Comments help explain your code and are ignored by Lua.

### Print Statements
```lua
print("Hello, Hardware World!")
```
The `print()` function displays text on the screen.

### Variables
```lua
local voltage = 5.0
local current = 0.02
```
- `local` creates a local variable (recommended)
- Variables can store numbers, text, or other values
- No need to declare the type - Lua figures it out

### String Concatenation
```lua
print("Voltage: " .. voltage .. "V")
```
The `..` operator joins strings together.

### Tables and Loops
```lua
local sensors = {"temperature", "humidity", "pressure"}
for i, sensor in ipairs(sensors) do
    print(i .. ". " .. sensor)
end
```
- Tables store lists of values
- `ipairs()` iterates through the table
- `i` is the index (1, 2, 3...), `sensor` is the value

## Practice Exercises

Try these exercises to reinforce what you've learned:

### Exercise 1: Personal Hardware Lab
Create a script called `my_lab.lua`:

```lua
-- Replace with your actual information
local your_name = "Your Name Here"
local favorite_board = "Raspberry Pi"  -- or Arduino, ESP32, etc.
local projects_completed = 0

print("=== My Hardware Programming Lab ===")
print("Programmer: " .. your_name)
print("Favorite Board: " .. favorite_board)
print("Projects Completed: " .. projects_completed)
print("Ready to learn more!")
```

### Exercise 2: Simple Calculator
Create `calculator.lua`:

```lua
-- Simple electronics calculator
local resistance = 1000  -- 1k ohm
local voltage = 5        -- 5 volts

-- Calculate current using Ohm's law (I = V / R)
local current = voltage / resistance

print("=== Electronics Calculator ===")
print("Resistance: " .. resistance .. " ohms")
print("Voltage: " .. voltage .. " volts")
print("Current: " .. current .. " amps")
print("Current: " .. (current * 1000) .. " milliamps")
```

### Exercise 3: Component Inventory
Create `inventory.lua`:

```lua
-- My electronics component inventory
local components = {
    "Arduino Uno",
    "Raspberry Pi 4",
    "LED (Red)",
    "LED (Blue)", 
    "Resistor 220Ω",
    "Resistor 1kΩ",
    "Breadboard",
    "Jumper Wires"
}

print("=== Component Inventory ===")
print("Total components: " .. #components)
print("\nComponent list:")

for i, component in ipairs(components) do
    print(string.format("%2d. %s", i, component))
end

print("\nInventory complete!")
```

## Best Practices from Day One

### 1. Use Local Variables
```lua
-- Good
local temperature = 25

-- Avoid (creates global variable)
temperature = 25
```

### 2. Use Meaningful Names
```lua
-- Good
local led_pin = 13
local temperature_celsius = 23.5

-- Avoid
local x = 13
local temp = 23.5
```

### 3. Add Comments
```lua
-- Set up the LED pin for output
local led_pin = 13

-- Read temperature from sensor
local temperature = read_temperature_sensor()
```

### 4. Keep It Simple
Start with simple, working code before making it complex.

## Common Beginner Mistakes

### 1. Forgetting `local`
```lua
-- Wrong - creates global variable
name = "Arduino"

-- Right - creates local variable
local name = "Arduino"
```

### 2. Case Sensitivity
```lua
local myVariable = 5
print(MyVariable)  -- Error! Lua is case-sensitive
print(myVariable)  -- Correct
```

### 3. String vs Number Confusion
```lua
local number = "5"     -- This is a string
local real_number = 5  -- This is a number

-- Lua is flexible, but be explicit when needed
local result = tonumber(number) + real_number
print(result)  -- 10
```

## Running Scripts from Different Locations

### Method 1: Navigate to the file
```bash
cd /path/to/your/script
lua script.lua
```

### Method 2: Full path
```bash
lua /path/to/your/script/script.lua
```

### Method 3: Make it executable (Linux/macOS)
Add this as the first line of your script:
```lua
#!/usr/bin/env lua
```

Then make it executable:
```bash
chmod +x script.lua
./script.lua
```

## What You've Learned

✅ How to run Lua in interactive mode  
✅ How to create and run Lua script files  
✅ Basic Lua syntax: variables, strings, numbers  
✅ How to use comments effectively  
✅ String concatenation with `..`  
✅ Basic tables and loops  
✅ Best practices for beginners  

## Troubleshooting

### "lua: cannot open hello.lua"
- Make sure you're in the correct directory
- Check that the file name is spelled correctly
- Verify the file was saved properly

### "syntax error"
- Check for missing quotes or parentheses
- Make sure all strings are properly closed
- Verify proper spelling of Lua keywords

### "attempt to concatenate a nil value"
- Make sure all variables are defined before using them
- Check variable names for typos

## Next Steps

Great job! You've written and run your first Lua programs. Now you're ready to learn about:
- [Basic Syntax and Data Types](03-syntax.md) - Dive deeper into Lua's core features
- Variables, numbers, strings, and booleans in detail
- More about tables and how they work

---

**Remember**: Programming is learned by doing. Keep experimenting with the code examples and try creating your own variations!