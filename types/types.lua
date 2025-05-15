-- ALL IS WIP
---@meta

---@class Entity
---@field public New fun(self: Entity, handle: integer, netid: integer, entityType: string, model: string | integer): Entity | nil
---@field private TrackEntity fun(self: Entity, handle: integer, entityType: string)
---@field private RemoveTrackedEntity fun(self: Entity, handle: integer, entityType: string)
---@field private ValidateEntity fun(self: Entity, handle: integer): boolean
---@field private GetNetworkID fun(self: Entity, handle: integer, isNetworked: boolean): integer
---@field private SetHeading fun(self: Entity, handle: integer, data: table)
---@field private SetEntityRotation fun(self: Entity, handle: integer, data: table)
---@field private SetPedIntoVehicle fun(self: Entity, handle: integer, data: table)
---@field private PlaceOnGround fun(self: Entity, handle: integer, data: table)
---@field private LoadModel fun(self: Entity, data: table)
---@field public GetNetID fun(self: Entity): integer
---@field public GetHandle fun(self: Entity): integer
---@field public GetModel fun(self: Entity): string | integer
---@field public DeleteEntity fun(self: Entity)
---@field public GetTrackedEntitiesByType fun(self: Entity, entityType: string) :table | nil static
---@field public GetNumberOfTrackedEntitiesByType fun(self: Entity, entityType: string): integer | nil static

---@class Ped : Entity
---@field public Create fun(self: Ped, data: table): Ped | nil

---@class Object : Entity
---@field public Create fun(self: Object, data: table): Object | nil

---@class Vehicle : Entity
---@field public Create fun(self: Vehicle, data: table): Vehicle | nil


---@class Events
---@field public Register fun(self:Events, name:string|integer, group:integer, callback:fun(data:table):any):Events
---@field public Start fun(self:Events)
---@field public Pause fun(self:Events)
---@field public Resume fun(self:Events)
---@field public Destroy fun(self:Events)

---@class Streaming
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

---@class Notify
---@field public Left fun( self:Notify, title: string, subtitle: string, dict: string, icon: string, duration: number, color: string?): nil
---@field public Tip fun( self:Notify, tipMessage: string, duration?: number): nil
---@field public Top fun( self:Notify, message: string, location: string, duration?: number): nil
---@field public RightTip fun( self:Notify, tipMessage: string, duration?: number): nil
---@field public Objective fun( self:Notify, message: string, duration?: number): nil
---@field public SimpleTop fun( self:Notify, title: string,subTitle:string, duration?: number): nil
---@field public RightAdvanced fun( self:Notify, text: string, dict: string, icon: string, text_color: string, duration?: number, quality?: number, showquality?: boolean): nil
---@field public BasicTop fun( self:Notify, text: string, duration?: number): nil
---@field public Center fun( self:Notify, text: string, duration?: number, text_color?: string): nil
---@field public BottomRight fun( self:Notify, text: string, duration?: number): nil
---@field public Fail fun( self:Notify, title: string, subtitle: string, duration?: number): nil
---@field public Dead fun( self:Notify, title: string, audioRef: string, audioName: string, duration?: number): nil
---@field public Update fun( self:Notify, title: string, message: string, duration?: number): nil
---@field public Warning fun( self:Notify, title: string, message: string, audioRef: string, audioName: string, duration?: number): nil
---@field public NotifyLeftRank fun( self:Notify, title: string, subtitle: string, dict: string, texture: string, duration?: number, color?: string): nil

---@class Map
---@field public New fun(self:Map, handle:number):Blip
---@field private TrackBlips fun(self:Map, handle:number)
---@field private GetTrackedBlips fun(self:Map):table<number, number>
---@field private GetTrackedBlipData fun(self:Map, handle:number):table
---@field private RemoveTrackedBlip fun(self:Map, handle:number)
---@field private GetBlipColor fun(self:Map, color:string | integer):table
---@field public handle number
---@field public RemoveBlip fun(self:Map)
---@field public SetName fun(self:Map, name:string)
---@field public SetCoords fun(self:Map, pos:vector3 | {x: number, y: number, z: number})
---@field public SetStyle fun(self:Map, style:number|integer)
---@field public SetScale fun(self:Map, scale:number)
---@field public SetSprite fun(self:Map, sprite:number|integer)
---@field public AddModifier fun(self:Map, modifier:string | integer)
---@field public RemoveModifier fun(self:Map, modifier:string|integer)
---@field public GetHandle fun(self:Map):number
---@field public AddModifierColor fun(self:Map, modifier:string | integer)

---@class BlipParams
---@field public Options? BlipOptions
---@field public Entity? number
---@field public Pos? vector3
---@field public Blip? number
---@field public Scale? vector3
---@field public Radius? number
---@field public P7? number
---@field public OnCreate? fun(instance:Blip)

---@class BlipOptions
---@field public Sprite? number
---@field public Name? string
---@field public Style? number
---@field public Modifier? string
---@field public Color? string


---@class Blip: Map
---@field public CreateBlip fun(self:Blip, blipType:'entity'|'coords'|'area'|'radius', params:BlipParams):Blip

---@class Inputs
---@field private New fun(self: Inputs, inputParams: InputParams, callback: fun(input: Inputs), state: boolean): Inputs
---@field public IsRunning fun(self: Inputs): boolean
---@field public Start fun(self: Inputs)
---@field public Remove fun(self: Inputs)
---@field public Pause fun(self: Inputs)
---@field public Resume fun(self: Inputs)
---@field public Register fun(self: Inputs, inputParams: InputParams, callback:fun(input:Inputs), state:boolean?):Inputs

---@class InputParams
---@field public inputType string
---@field public key string | number
---@field public callback fun(input: Inputs)
---@field public state boolean


---@class Command
---@field private New fun(self: Command, commandName: string, params: CommandParams, state: boolean?): Command
---@field public Register fun(self: Command, commandName: string, params: CommandParams, state: boolean?): Command
---@field public Pause fun(self: Command)
---@field public Start fun(self: Command)
---@field public Resume fun(self: Command)
---@field public Remove fun(self: Command)
---@field public Destroy fun(self: Command)
---@field public AddSuggestion fun(self: Command, target: number)
---@field public RemoveSuggestion fun(self: Command, target: number)
---@field public OnExecute? fun(self: Command, callback: fun(source: number, args: table, rawCommand: string))
---@field public OnError? fun(self: Command, callback: fun(error: string))


---@class CommandParams
---@field public Permissions? {Jobs?:{ [string]:{ Ranks?:{[number]:boolean } | boolean }},Groups?:{[string]:{[string]:boolean }},CharIds?:{[number]:boolean },Ace?:string }
---@field public Suggestion? {Description: string, Arguments: {name: string, help: string, required: boolean, type: string}}
---@field public OnExecute? fun(source: number, args: table, rawCommand: string, self: Command)
---@field public OnError? fun(error: string)
---@field public State boolean?

---@class Points
---@field private New fun(self: Points, data: PointsParams): Points
---@field public Start fun(self: Points)
---@field public Pause fun(self: Points)
---@field public Resume fun(self: Points)
---@field public Destroy fun(self: Points)
---@field public OnEnter fun(self: Points, callback: fun(self: Points))
---@field public OnExit fun(self: Points, callback: fun(self: Points))
---@field public OnUpdate fun(self: Points, callback: fun(self: Points))
---@field public OnDestroy fun(self: Points, callback: fun(self: Points))
---@field public Register fun(self: Points, data: PointsParams, state: boolean?): Points


---@class PointsParams
---@field public id string
---@field public coords vector3
---@field public distance number
---@field public wait number
---@field public onEnter fun(self: Points)
---@field public onExit fun(self: Points)
