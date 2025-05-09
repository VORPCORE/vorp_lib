-- ALL IS WIP
---@meta

---@class Entity
---@field public New fun(self: Entity, handle: integer, netid: integer, entityType: string, model: string | integer): Entity | nil
---@field private TrackEntity fun(self: Entity, handle: integer, entityType: string)
---@field private RemoveTrackedEntity fun(self: Entity, handle: integer, entityType: string)
---@field private entityType string
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
---@field LoadModel fun(model: string | integer, timeout: integer?)
---@field LoadTextureDict fun(dict: string, timeout: integer?)
---@field LoadParticleFx fun(dict: string, timeout: integer?)
---@field LoadAnimDict fun(dict: string, timeout: integer?)
---@field LoadWeaponAsset fun(weapon: string | integer, p1: integer, p2: boolean, timeout: number?)
---@field RequestCollisionAtCoord fun(coords: vector3 | {x: number, y: number, z: number})
---@field RequestCollisionForModel fun(model: string | integer)
---@field RequestIpl fun(ipl: string | integer)
---@field LoadMoveNetworkDef fun(netDef: string, timeout: number?)
---@field LoadClipSet fun(clipSet: string, timeout: number?)
