# vorp_lib
A library to be used for RedM  by vorp

### Features

#### Import
- able to import modules without declaring them in your fxmanifest , this eliminates global polution
  - import modules either from the lib, from another resource or from  your own resource eliminating  global polution like config files
  - cache system only loads the file once and you can use them in other files of your resource this enables having al lthat info localy
  - every import will run by that script, eliminating the overhead of other scripts using the Lib, all functions etc, it's all instanced

#### Creation 
- creation of entities with multiple options using metatables and ability to use predefined methods
  - peds /animals / horses
  - objects
  - vehicles

#### Creation of bips 
- creation of blips with multiple options and ability to use predefined methods
  - blip for coords
  - blip for entity
  - blip for area

#### Usefull Functions
- eleminates code repetion through out your scripts
  - RequestModel
  - RequestDict
  - RequestIpl
  
#### Data
- get data easily like inputs events etc

#### Class system OOP

- allows for object-oriented programming in Lua, providing a way to define classes, handle inheritance, and manage properties with custom logic
  - with traditional lua methods 
  - structured to use them like "Real OOP" with automatic setters and getters 
  - inheritance

