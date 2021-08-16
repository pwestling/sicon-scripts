organizeTimers = {}

function onLoad(state)
    addHotkey("Organize Cubes", function (playerColor, hoveredObject, cursorLocation, key_down_up)
        organizeCubes(playerColor)
    end)
    addContextMenuItem("Organize Cubes", function (playerColor) organizeCubes(playerColor) end, 
        false, true)
end


function rotateVec(vec, degrees)
  return {
    x = vec.x * math.cos(math.rad(degrees)) - vec.z * math.sin(math.rad(degrees)),
    y = vec.y,
    z = vec.x * math.sin(math.rad(degrees)) + vec.z * math.cos(math.rad(degrees))
  }
end

function vecAdd(p, vec)
  return {x = vec.x + p.x, y = vec.y + p.y, z = vec.z + p.z}
end

function organizeCubes(playerColor)
    local selected = Player[playerColor].getSelectedObjects()
    local organized = {
        ["Food & Life Support"] = {},
        ["Culture"] = {},
        ["Industry"] = {},
        ["Wild %(1%)"] = {},
        ["Power"] = {},
        ["Biotechnology"] = {},
        ["Information"]  = {},
        ["Wild %(1.5%)"] = {},
        ["Ultratech"] = {},
        ["Ship"] = {}, 
    }


    for k, obj in pairs(selected) do
        for cubeName, cubeList in pairs(organized) do
            if obj.getName():find(cubeName) then
                table.insert(cubeList, obj)
            end
        end
    end
    local cols = 5
    local start = Player[playerColor].getPointerPosition()
    local rot = Player[playerColor].getPointerRotation()
    log("Rotation is " .. rot)
    rot = (math.floor((rot+45)/90) % 4) * 90
    cuberot = rot
    if rot == 180 or rot == 0 then
      rot = (rot + 180) % 360
    end
    log("Quadrant rot is " .. rot)
    for cubeName, cubeList in pairs(organized) do
        -- log("Organizing " .. #cubeList .. " " .. cubeName)
        if #cubeList > 0 then
            local width = cubeList[1].getBoundsNormalized().size.x + 0.1
            for i,cube in ipairs(cubeList) do
               
                local col = (i-1) % cols
                local row = math.floor((i-1)/cols)
                -- log("Index " .. i .. " Col " .. col .. " Row " .. row)
                local x = col * width
                local z = row * width
                 local rotatedColRowVec = rotateVec({x=x,z=-z,y=1}, rot)
                --   local rotatedColRowVec = {x=x,z=-z,y=1}
                local newPos = vecAdd(start, rotatedColRowVec)
                cube.setPositionSmooth(newPos, false, true)
                cube.setRotationSmooth({x=0,z=0,y=cuberot}, false, true)
 
            end
            local groupWidth = width * math.min(#cubeList, cols)
            local rotatedWidthVec = rotateVec({x=groupWidth+1,z=0,y=0}, rot)
            -- local rotatedWidthVec = {x=groupWidth+1,z=0,y=0}
            start = vecAdd(start, rotatedWidthVec)
        end
    end
    organizeTimers[playerColor] = nil
end
