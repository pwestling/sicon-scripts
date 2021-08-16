pieces = {
  Green = "Food & Life Support",
  White = "Culture",
  Brown = "Industry",
  Yellow = "Power",
  Blue = "Biotechnology",
  Black  = "Information",
  Ultratech = "Ultratech",
  Ship = "Ship",
  ["Small Wild"] = "Wild %(1%)", 
  ["Large Wild"] = "Wild %(1.5%)"
}


pieceBagCache = {}

function getPieceBag(pieceName)
  if pieceBagCache[pieceName] and getObjectFromGUID(pieceBagCache[pieceName]) then
    log("bagCached")
    return getObjectFromGUID(pieceBagCache[pieceName])
  end
  for _, obj in pairs(getObjects()) do
    if obj.type == "Infinite" then
       if JSON.decode(obj.getJSON())["ContainedObjects"][1]["Nickname"]:find(pieceName) then
         log("Caching " .. pieceName .. " bag ".. obj.getGUID())
         pieceBagCache[pieceName] = obj.getGUID()
         return obj
       end
     end
  end
end

function getPiece(pieceName, pos)
  bagObj = getPieceBag(pieceName)
  bagObj.takeObject({
                    sound = false,
                    position = {x=pos.x,z=pos.z,y=pos.y+1.5},                   
                    smooth = false})
end

function onLoad(save_state)
  for k, v in pairs(pieces) do
    addHotkey("Add "..k, function (droppingPlayerColor, hoveredObject, cursorLocation, key_down_up)
       getPiece(v, cursorLocation)
    end)
    addContextMenuItem("Add "..k, function (playerColor, menu_position) getPiece(v, menu_position) end, 
        true, true)
    getPieceBag(v)
  end
end
