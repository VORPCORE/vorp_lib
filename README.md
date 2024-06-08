# vorp_lib
A library to be used for RedM  by vorp

### Features

- Import
  - able to import modules without declaring them in your fxmanifest , this eliminates global polution
  - import modules either from the lib, from another resource or from  your own resource eliminating  global polution like config files
  - cache system only loads the file once and you can use them in other files of your resource this enables having al lthat info localy
  - every import will run by that script, eliminating the overhead of other scripts using the Lib, all functions etc, it's all instanced

- Creation of entities using meta tables
  - peds /animals / horses
  - objects
  - vehicles

- Creation of bips using meta tables  
  - blip for coords
  - blip for entity
  - blip for area

- Usefull Functions that eleminates repetion through out your scripts like streaming
  - RequestModel
  - RequestDict
  - RequestIpl
  
- Get Data like blip colors inputs and more

