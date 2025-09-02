# VORP Lib

VORP Lib is a modular scripting library for RedM that simplifies game development by providing reusable, instance-based components with automatic cleanup. Designed specifically for VORP Core Framework, it helps developers write cleaner, more efficient scripts while eliminating common issues like memory leaks and global variable pollution.

## Features

###  Import System
- **Modular imports** - Import only what you need from the library, other resources, or your own scripts
- **Zero global pollution** - All imports are scoped locally to prevent conflicts
- **Efficient caching** - Files are loaded once and cached for performance
- **Instance-based execution** - Each script gets its own independent instances
- **Cross-resource imports** - Import from other resources using `@resource_name/path`

###  Entity Management
Complete entity creation and management system with automatic cleanup:
- **Peds** - Create and manage NPCs with outfit presets and callbacks
- **Vehicles** - Spawn vehicles with passenger seating and configurations  
- **Objects** - Place objects with rotation and ground placement options
- **Lifecycle management** - Automatic cleanup on resource restart

###  Map & UI Systems
- **Blips** - Create various blip types (coords, entity, area, radius) with full customization
- **Prompts** - Coordinate-based interactive prompts with grouping support
- **Input Controls** - Register key inputs (Press, Hold, Release) without manual loops
- **Points** - Create enter/exit zones with radius detection and debug visualization

###  Advanced Features
- **Game Events** - Listen to native game events with automatic data parsing and dev mode
- **Command System** - Register client/server commands with permissions and argument validation
- **Asset Streaming** - Load models, animations, textures with automatic cleanup and timeouts
- **DataView** - JavaScript-like binary data manipulation for advanced use cases
- **OOP System** - Full object-oriented programming with classes and inheritance

###  Developer Tools
- **Automatic cleanup** - All resources are cleaned up on script restart for easy development
- **Error handling** - Comprehensive validation and error reporting
- **Debug modes** - Visual markers and logging for development
- **TypeScript annotations** - IntelliSense support for better development experience

## Installation

1. Add `vorp_lib` to your server resources folder
2. Add the following to your `server.cfg`:
   ```cfg
   ensure vorp_lib #at the top of vorp scripts
   add_ace resource.vorp_lib command.add_ace allow
   add_ace resource.vorp_lib command.remove_ace allow
   ```

## Quick Start

### Import the library in your script's `fxmanifest.lua`:

```lua
shared_script "@vorp_lib/import.lua"
```

## Documentation

Full documentation with examples and API reference is available o nthe [docs](https://docs.vorp-core.com/introduction)

## Contributing

We welcome contributions to VORP Lib! Here's how you can help:

###  Reporting Issues
- Check existing [issues](https://github.com/VORPCORE/vorp_lib/issues) before creating new ones
- Use the issue templates when available
- Include detailed reproduction steps and environment information

###  Feature Requests
- Describe the feature and its use case clearly
- Explain how it would benefit the community
- Consider backward compatibility implications
- Provide examples of the desired API if possible


###  Code Guidelines
- Follow existing code style and patterns
- Add proper error handling and validation
- Include TypeScript annotations for IntelliSense support
- Test your changes thoroughly before submitting
- Update documentation if you're adding new features

###  Pull Request Process
1. Ensure your code follows the project's style guidelines
2. Update documentation for any new features or changes
3. Test your changes with the latest VORP Core version
4. Create a detailed pull request description explaining:
   - What changes were made and why
   - How to test the changes
   - Any breaking changes or migration notes
5. Link to any related issues

###  Module Development Guidelines
When creating new modules:
- Follow the instance-based pattern used by existing modules
- Implement automatic cleanup on resource restart
- Include proper parameter validation and error handling
- Create usage examples and documentation


## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE

## Acknowledgments

- Special thanks to [gottfriedleibniz](https://github.com/gottfriedleibniz) for the DataView implementation

---

**Note**: This library is under active development. While we strive for stability, breaking changes may occur until the v1.0 release. Check the changelog and migration guide when updating.
