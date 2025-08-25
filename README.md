# vorp lib

A comprehensive library for RedM .

### INSTALLATION

- add `ensure vorp_lib` bellow vorp_core since it needs the export
- make sure this is in your server.cfg
  - add_ace resource.vorp_lib command.add_ace allow
  - add_ace resource.vorp_lib command.remove_ace allow

**Note:** This project is a work in progress. All content in this repository is subject to change, including folders, files, and logic.

## Features

### Import System

- Import modules 
- Reduce global pollution by importing locally modules, from:
  - This library
  - Other resources
  - the resource you are using the import
- Efficient caching system:
  - Loads files only once
- Instance-based execution:
  - Each import runs independently within its script
  - Eliminates overhead from shared code usage

### Entity Creation
 creation of entities with a tracking management system

- Entity 
  - Peds
  - Objects
  - Vehicles

### Blip Management

create blips instanced to your script using methods
- coords
- entity
- area
- radius

### Utility Functions
with life cycle manegement

- Switch
- SetInterval
- SetTimeout

### Register Game Events
listen to game events and register only what you need
- Life cycle manegement with methods
- DedMode to allow listen to all but some events and see the data

### Register Inputs
listent to inputs register only what you need

- Life cycle manegement with methods

### Register Prompts

- Life cycle manegement with methods
- group prompts or single

### Game Notifcations
incorporated when you import the lib just use NOTIFY key word

```lua
LIB.NOTIFY:Objective("text", 5000)
```


### Vorp Core
Core  export is accessible when you import the lib just use CORE keyword

```lua
local r = LIB.CORE.Callback.TriggerAwait("name")
```

### Commands
- Life cycle manegement


### DataView
import data view to your projects

### Object-Oriented Programming (OOP) System
Implement OOP in Lua with:
- Class definitions
- Inheritance
- Property management with custom logic
- Traditional Lua methods
- Structured "Real OOP" approach with automatic setters and getters



