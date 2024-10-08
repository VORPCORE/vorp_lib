# VORP Library

A comprehensive library for RedM development by VORP.

**Note:** This project is a work in progress. All content in this repository is subject to change, including folders, files, and logic.

## Features

### Import System
- Import modules without declaring them in your `fxmanifest.lua`
- Reduce global pollution by importing modules from:
  - This library
  - Other resources
  - Your own resource
- Efficient caching system:
  - Loads files only once
  - Allows local usage of imported data across your resource
- Instance-based execution:
  - Each import runs independently within its script
  - Eliminates overhead from shared code usage

### Entity Creation
Create entities with multiple options using metatables and predefined methods:
- Peds (including animals and horses)
- Objects
- Vehicles

### Blip Management
Create and manage blips with various options and predefined methods:
- Coordinate-based blips
- Entity-attached blips
- Area blips

### Utility Functions
Reduce code repetition with helpful functions:
- `RequestModel`
- `RequestDict`
- `RequestIpl`

### Data Handling
Easily access and manage data such as inputs and events

### Object-Oriented Programming (OOP) System
Implement OOP in Lua with:
- Class definitions
- Inheritance
- Property management with custom logic
- Traditional Lua methods
- Structured "Real OOP" approach with automatic setters and getters

## Work in Progress
Future additions may include:
- Prompt registration
- Event handlers
- And more!

## Contributing
We welcome contributions to the VORP Library. Please see our [Contributing Guidelines](CONTRIBUTING.md) for more information.

## License
This project is licensed under the [MIT License](LICENSE.md).

## Contact
For questions or support, please [open an issue](https://github.com/VORP-Core/vorp_lib/issues) on our GitHub repository.