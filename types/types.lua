---@meta

---@class ENTITY
---@field private TrackEntity fun(self: ENTITY)
---@field private RemoveTrackedEntity fun(self: ENTITY)
---@field private ValidateEntity fun(self: ENTITY): boolean
---@field private SetHeading fun(self: ENTITY, data: table)
---@field private SetEntityRotation fun(self: ENTITY, data: table)
---@field private SetPedIntoVehicle fun(self: ENTITY, data: table)
---@field private PlaceOnGround fun(self: ENTITY, data: table)
---@field private LoadModel fun(self: ENTITY, data: table)
---@field public handle integer
---@field public netid integer
---@field private entityType string
---@field public model string | integer
---@field public OnDelete fun()
---@field public GetNetID fun(self: ENTITY): integer
---@field public GetHandle fun(self: ENTITY): integer
---@field public GetModel fun(self: ENTITY): string | integer
---@field public Delete fun(self: ENTITY)
---@field public GetTrackedEntitiesByType fun(self: ENTITY, entityType: string) :table | nil static
---@field public GetNumberOfTrackedEntitiesByType fun(self: ENTITY, entityType: string): integer | nil static
---@field public SetPosition fun(self: ENTITY, pos: vector3 | {x: number, y: number, z: number,w: number} | vector4 | {x: number, y: number, z: number, w: number})
---@field public GetPosition fun(self: ENTITY): vector3
---@field public GetHeading fun(self: ENTITY): number
---@field public GetRotation fun(self: ENTITY): vector3

---@class PED : ENTITY
---@field public Create fun(self: PED, data: table): PED
---@field public New fun(self: PED, entityType: string, data: table): PED

---@class OBJECT : ENTITY
---@field public Create fun(self: OBJECT, data: table): OBJECT
---@field public New fun(self: OBJECT, entityType: string, data: table): OBJECT

---@class VEHICLE : ENTITY
---@field public Create fun(self: VEHICLE, data: table): VEHICLE
---@field public New fun(self: VEHICLE, entityType: string, data: table): VEHICLE

---@class EVENTS
---@field public Register fun(self:EVENTS, name:string|integer, group:integer, callback:fun(data:table), state:boolean):EVENTS
---@field public Start fun(self:EVENTS)
---@field public Pause fun(self:EVENTS)
---@field public Resume fun(self:EVENTS)
---@field public Destroy fun(self:EVENTS)
---@field public DevMode fun(self:EVENTS, turn_on:boolean, events:string|integer|table|nil)

---@class STREAMING
---@field public LoadModel fun(model: string | integer, timeout: integer?)
---@field public LoadTextureDict fun(dict: string, timeout: integer?)
---@field public LoadParticleFx fun(dict: string, timeout: integer?)
---@field public LoadAnimDict fun(dict: string, timeout: integer?)
---@field public LoadWeaponAsset fun(weapon: string | integer, p1: integer, p2: boolean, timeout: number?)
---@field public RequestCollisionAtCoord fun(coords: vector3 | {x: number, y: number, z: number})
---@field public RequestCollisionForModel fun(model: string | integer)
---@field public RequestIpl fun(ipl: string | integer)
---@field public LoadMoveNetworkDef fun(netDef: string, timeout: number?)
---@field public LoadClipSet fun(clipSet: string, timeout: number?)
---@field public LoadScene fun(pos: vector3 | {x: number, y: number, z: number}, offset: vector3 | {x: number, y: number, z: number}, radius: number, p7: integer)


---@class MAP
---@field public New fun(self:MAP, handle:number):Blip
---@field public TrackBlips fun(self:MAP, handle:number)
---@field public GetTrackedBlips fun(self:MAP):table<number, number>
---@field public GetTrackedBlipData fun(self:MAP, handle:number):table
---@field public RemoveTrackedBlip fun(self:MAP, handle:number)
---@field public GetBlipColor fun(self:MAP, color:string | integer):table
---@field public Remove fun(self:MAP)
---@field public SetName fun(self:MAP, name:string)
---@field public SetCoords fun(self:MAP, pos:vector3 | {x: number, y: number, z: number})
---@field public SetStyle fun(self:MAP, style:number|integer)
---@field public SetScale fun(self:MAP, scale:number)
---@field public SetSprite fun(self:MAP, sprite:number|integer)
---@field public AddModifier fun(self:MAP, modifier:string | integer)
---@field public RemoveModifier fun(self:MAP, modifier:string|integer)
---@field public GetHandle fun(self:MAP):number
---@field public AddModifierColor fun(self:MAP, modifier:string | integer)

---@class BLIP_PARAMS
---@field public Options? BLIP_OPTIONS
---@field public Entity? number if type is entity, you need to provide a handle
---@field public Pos? vector3
---@field public Blip? number bliphash the style of the blip
---@field public Scale? vector3 for type area only
---@field public Radius? number for type radius or area
---@field public P7? number default is 0
---@field public OnCreate? fun(instance:Blip)

---@class BLIP_OPTIONS
---@field public sprite? number
---@field public name? string
---@field public style? number
---@field public modifier? string
---@field public color? string

---@class BLIP: MAP
---@field public Create fun(self:BLIP, blipType:'entity'|'coords'|'area'|'radius', params:BLIP_PARAMS):BLIP

---@class INPUTS
---@field private New fun(self: INPUTS, inputParams: INPUT_PARAMS, callback: fun(input: INPUTS), state: boolean): INPUTS
---@field public IsRunning fun(self: INPUTS): boolean
---@field public Start fun(self: INPUTS)
---@field public Remove fun(self: INPUTS)
---@field public Pause fun(self: INPUTS)
---@field public Resume fun(self: INPUTS)
---@field public Register fun(self: INPUTS, inputParams: INPUT_PARAMS, callback:fun(input:INPUTS), state:boolean?):INPUTS

---@class INPUT_PARAMS
---@field public inputType string
---@field public key string | number
---@field public callback fun(input: INPUTS)
---@field public state boolean


---@class COMMANDS
---@field private New fun(self: COMMANDS, commandName: string, params: COMMAND_PARAMS, state: boolean?): COMMANDS
---@field private isRequiredArgument fun(self: COMMANDS, args: table)
---@field private validate fun(self: COMMANDS, args: table)
---@field private getTypes fun(self: COMMANDS, args: table)
---@field public Register fun(self: COMMANDS, commandName: string, params: COMMAND_PARAMS, state: boolean?): COMMANDS
---@field public Pause fun(self: COMMANDS)
---@field public Start fun(self: COMMANDS, addSuggestion: boolean?)
---@field public Resume fun(self: COMMANDS)
---@field public Remove fun(self: COMMANDS)
---@field public Destroy fun(self: COMMANDS)
---@field public AddSuggestion fun(self: COMMANDS, target: number)
---@field public RemoveSuggestion fun(self: COMMANDS, target: number)
---@field public OnExecute? fun(self: COMMANDS, callback: fun(source: number, args: table, rawCommand: string))
---@field public OnError? fun(self: COMMANDS, callback: fun(error: string))


---@class COMMAND_PARAMS
---@field public Permissions? {Jobs?:{ [string]:{ Ranks?:{[number]:boolean } | boolean }},Groups?:{[string]:{[string]:boolean }},CharIds?:{[number]:boolean },Ace?:string }
---@field public Suggestion? {Description: string, Arguments: {name: string, help: string, required: boolean, type: string}}
---@field public OnExecute? fun(source: number, args: table, rawCommand: string, self: COMMANDS)
---@field public OnError? fun(error: string)
---@field public State boolean?
---@field public AddSuggestion? boolean?

---@class POINTS
---@field private New fun(self: POINTS, data: POINTS_PARAMS): POINTS
---@field public Start fun(self: POINTS)
---@field public Pause fun(self: POINTS)
---@field public Resume fun(self: POINTS)
---@field public Destroy fun(self: POINTS)
---@field public OnEnter fun(self: POINTS, callback: fun(self: POINTS))
---@field public OnExit fun(self: POINTS, callback: fun(self: POINTS))
---@field public OnUpdate fun(self: POINTS, callback: fun(self: POINTS))
---@field public OnDestroy fun(self: POINTS, callback: fun(self: POINTS))
---@field public Register fun(self: POINTS, data: POINTS_PARAMS, state: boolean?): POINTS


---@class POINTS_PARAMS
---@field public Arguments { id: string, center: vector3, radius: number, wait: number, debug: boolean, deActivate: boolean }[]

---@class FUNCTIONS
---@field public Switch fun(self: FUNCTIONS): FUNCTIONS
---@field public SetInterval fun(self: FUNCTIONS): FUNCTIONS
---@field public SetTimeout fun(self: FUNCTIONS): FUNCTIONS


---@class CLASS
---@field public Create fun(self: CLASS, data: table, name: string?)


---@class Switch
---@field cases table
---@field value any
---@field public default fun(self:Switch, value:any):any
---@field public execute fun(self:Switch):any

---@class Interval
---@field callback fun(self:Interval):any
---@field delay integer
---@field id string
---@field state boolean
---@field customArgs? table
---@field start? boolean
---@field public Start fun(self:Interval):any
---@field public Pause fun(self:Interval)
---@field public Resume fun(self:Interval, ...:any)
---@field public Destroy fun(self:Interval)
---@field public Update fun(self:Interval, ...:any)


---@class Timeout
---@field callback fun(self:Timeout):any
---@field delay integer
---@field id string
---@field state boolean
---@field customArgs? table
---@field start? boolean
---@field public Start fun(self:Timeout):any
---@field public Pause fun(self:Timeout)
---@field public Resume fun(self:Timeout, ...:any)
---@field public Destroy fun(self:Timeout)


---@class PROMPTS
---@field private New fun(self: PROMPTS, data: PROMPTS_PARAMS): PROMPTS
---@field private _SetUpPrompts fun(self: PROMPTS, data: PROMPTS_PARAMS)
---@field private _CreateMarker fun(self: PROMPTS)
---@field public Start fun(self: PROMPTS)
---@field public Pause fun(self: PROMPTS)
---@field public Resume fun(self: PROMPTS)
---@field public Destroy fun(self: PROMPTS)
---@field public Register fun(self: PROMPTS, data: PROMPTS_PARAMS, callback: fun(prompt: table, index: number, self: PROMPTS), state: boolean?): PROMPTS
---@field public SetLocationLabel fun(self: PROMPTS, index: number, label: string)
---@field public PauseLocation fun(self: PROMPTS, index: number)
---@field public ResumeLocation fun(self: PROMPTS, index: number)
---@field public RemoveLocation fun(self: PROMPTS, index: number)
---@field public AddLocation fun(self: PROMPTS, location: table)
---@field public RemoveModifier fun(self: PROMPTS, modifier: string)
---@field public AddModifier fun(self: PROMPTS, modifier: string)
---@field public SetLabel fun(self: PROMPTS, label: string, key: string)
---@field public SetEnabled fun(self: PROMPTS, enabled: boolean, key: string)
---@field public SetVisible fun(self: PROMPTS, visible: boolean, key: string)
---@field public SetMashMode fun(self: PROMPTS, mashCount: number, key: string)
---@field public SetMashIndefinitelyMode fun(self: PROMPTS, key: string)
---@field public GetPromptGroup fun(self: PROMPTS, key: string)
---@field public GetGroupLabel fun(self: PROMPTS, key: string)
---@field public IsRunning fun(self: PROMPTS)
---@field public GetHandle fun(self: PROMPTS): number

---@class PROMPTS_PARAMS
---@field public locations {coords: vector3, label: string, distance: number, marker: {type: string, scale: {x: number, y: number, z: number}, color: {r: number, g: number, b: number, a: number}, p7: number, entity: number, pos: vector3, heading: number, rotation: vector3}?, pause: boolean?}[]
---@field public marker? boolean
---@field public sleep? number
---@field public prompts {type: string, key: string | number, label: string, mode: string}[]
