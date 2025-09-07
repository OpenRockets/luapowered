# Hardware Programming

This module covers programming hardware devices using Lua. You'll learn to control GPIO pins, read sensors, communicate with devices, and build real-world projects.

## Module Overview

1. [Introduction to Hardware Programming](01-introduction.md) - Basic concepts and principles
2. [GPIO Control](02-gpio.md) - Digital input and output
3. [Digital Signals](03-digital-signals.md) - Working with digital sensors and actuators
4. [Analog Signals](04-analog-signals.md) - ADC, PWM, and analog devices
5. [Communication Protocols](05-communication.md) - I2C, SPI, UART basics

## Prerequisites

- Completion of [Lua Basics](../basics/README.md) module
- Basic understanding of electronics (voltage, current, resistance)
- Hardware platform (Raspberry Pi recommended for beginners)

## Required Hardware

### Minimum Hardware (for basic lessons)
- Raspberry Pi 3B+ or 4 (or compatible single-board computer)
- MicroSD card with OS installed
- Breadboard
- Jumper wires (male-to-male, male-to-female)
- LEDs (various colors)
- Resistors (220Ω, 1kΩ, 10kΩ)
- Push buttons

### Additional Hardware (for advanced lessons)
- Temperature sensor (DS18B20 or DHT22)
- Light sensor (photoresistor)
- Servo motor
- Ultrasonic sensor (HC-SR04)
- Basic multimeter

## Learning Goals

After completing this module, you will:
- Understand basic hardware programming concepts
- Control GPIO pins with Lua
- Read digital and analog sensors
- Control motors and actuators
- Understand common communication protocols
- Build simple hardware projects

## Safety First

⚠️ **Important Safety Guidelines:**

1. **Power off** your device before connecting/disconnecting wires
2. **Check connections** twice before applying power
3. **Use appropriate resistors** to protect LEDs and other components
4. **Never short circuit** power and ground
5. **Start with low voltages** (3.3V or 5V systems)
6. **Keep a multimeter handy** for testing connections

## Estimated Time

4-6 hours total (45-60 minutes per lesson)

## Hardware Platforms Covered

This module focuses on **Raspberry Pi** but concepts apply to:
- ESP32/ESP8266 (with appropriate Lua firmware)
- BeagleBone Black
- Other single-board computers with GPIO

## Next Steps

Once you complete this module, you'll be ready for:
- [Beginner Projects](../projects/beginner/README.md)
- More advanced hardware programming techniques

---

Ready to start controlling hardware? Let's begin with [Introduction to Hardware Programming](01-introduction.md)!