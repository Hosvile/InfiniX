# Introduction
### What exactly is Anti-Debug?
Anti-Debug is meant for exploiters (or perhaps game developers) who want to possibly replicate your script and this protects you from remote spies and more. I won't be in depth with what it protects you from to allow for more anonymity.

# Usage
```luau
local AntiDebug = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/InfiniX/main/Library/Anti/AntiDebug/main.lua", true))()

if not (type(AntiDebug) == "table") then
  while true do end
end
```

## Whitelisted Actions
```lua
AntiDebug:hookfunction(closure, newclosure)
AntiDebug:hookmetamethod(metatable, method, closure)
AntiDebug:clonefunction(closure)
```
