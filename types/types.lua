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
