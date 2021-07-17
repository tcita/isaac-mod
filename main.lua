local fDp = RegisterMod("Four-Dimensional Pocket", 1)

local json = require("json")

-- boolean value is true when you continue a run
-- false when you start a new one.
function fDp:OnGameStart(continue)
    -- print('start')

   
    if fDp:HasData() and continue
    -- return to memu and continue && exit and continue
    then
        local table_t={}
        table_t= json.decode(fDp:LoadData())    
     
        local type,variant,subtype=0

        local k=1
        for i, e in ipairs(table_t)  do
            if table_t[k]==nil
            then
                break
            end

            type=table_t[k]
            k=k+1
            variant=table_t[k]
            k=k+1
            subtype=table_t[k]
            k=k+1

            -- print(type)
            -- print(variant)
            -- print(subtype)
            Isaac.Spawn(type, variant, subtype, Isaac.GetRandomPosition (), Vector(0,0), nil)
            -- print("loop3",i)
        end
        
        -- print('continue')
        
        mytable={}

        RD=false
        fDp:RemoveData ()
    -- new Game
    else
    
        mytable={}
        RD=false
    end
end

fDp:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, fDp.OnGameStart)





local function filter(e,tb)

    if e.Variant == PickupVariant.PICKUP_HEART
    or e.Variant == PickupVariant.PICKUP_COIN
    or e.Variant == PickupVariant.PICKUP_KEY
    or e.Variant == PickupVariant.PICKUP_BOMB
    or e.Variant == PickupVariant.PICKUP_GRAB_BAG
    or e.Variant == PickupVariant.PICKUP_PILL
    or e.Variant == PickupVariant.PICKUP_LIL_BATTERY
    or e.Variant == PickupVariant.PICKUP_TAROTCARD
    or e.Variant == PickupVariant.PICKUP_TRINKET
    -- or e.Variant == PickupVariant.PICKUP_TROPHY
    or e.Variant == PickupVariant.PICKUP_COLLECTIBLE
    or e.Variant == PickupVariant.PICKUP_CHEST	
    or e.Variant == PickupVariant.PICKUP_BOMBCHEST	
    or e.Variant == PickupVariant.PICKUP_SPIKEDCHEST	
    or e.Variant == PickupVariant.PICKUP_ETERNALCHEST	
    or e.Variant == PickupVariant.PICKUP_MIMICCHEST	
    or e.Variant == PickupVariant.PICKUP_OLDCHEST	
    or e.Variant == PickupVariant.PICKUP_WOODENCHEST	
    or e.Variant == PickupVariant.PICKUP_MEGACHEST	
    or e.Variant == PickupVariant.PICKUP_HAUNTEDCHEST
    
    then
         
        e:Remove()
        table.insert(tb, e)
    end    
    return tb
end




local function get()
    local player1 = Isaac.GetPlayer(0)
    local mytable_t= Isaac.GetRoomEntities()


    for _, i in pairs(mytable_t) do
        
        -- i.Type ==5 and i.Variant==100 and i.SubType==0  -> bottom of item
        if (i.Type == EntityType.ENTITY_PICKUP and not(i.Type ==5 and i.Variant==100 and i.SubType==0)) then
            local item=i:ToPickup()
            local shopitem=item:IsShopItem()
            if not shopitem then
                mytable=filter(i,mytable)
                -- print(i.Type)
                -- print(i.Variant)
                -- print(i.SubType)
                -- print('\n')
                

                i:ToPickup ():PlayPickupSound()   
            end         
        end    
    end
    -- print("get")

    if next(mytable) ~= nil then
        
        local PICKUP_table = {}
        local k=1
      
        for i, v in pairs(mytable) do
           
            -- local  r = PICKUP_table:new(nil,v.Type,v.Variant,v.Subtype)
            PICKUP_table[k]= v.Type
            k=k+1
            PICKUP_table[k]= v.Variant
            k=k+1
            PICKUP_table[k]= v.SubType
            k=k+1 
            -- print("loop:",i)
        end

        RD=true
        
        fDp:SaveData(json.encode(PICKUP_table)) 

        -- tt= json.decode(fDp:LoadData())
        
    end

end

local function pour(e)
    -- local player1 = Isaac.GetPlayer(0)
	local type, variant, subtype,position = e.Type, e.Variant, e.SubType, e.Position
    
	Isaac.Spawn(type, variant, subtype, Isaac.GetRandomPosition (), Vector(0,0), nil)
    -- player1:AnimateHappy ()
    RD=false
    
end


local u = Sprite()
u:Load("gfx/ui/p.anm2", true)
u:Play("got")


  

fDp:AddCallback(ModCallbacks.MC_POST_RENDER, function ()
    if RD==true then
        u:Render(Vector(20,220), Vector(0,0), Vector(0,0))
    end

end)


fDp:AddCallback(ModCallbacks.MC_POST_UPDATE, function ()
        
   
    -- if (Game():GetRoom():GetType ())==RoomType.ROOM_DEFAULT
    -- or (Game():GetRoom():GetType ())==RoomType.ROOM_SUPERSECRET
    -- or (Game():GetRoom():GetType ())==RoomType.ROOM_SECRET
    -- or (Game():GetRoom():GetType ())==RoomType.ROOM_SACRIFICE
    -- or (Game():GetRoom():GetType ())==RoomType.ROOM_TREASURE
    
    -- then

    
        if Input.IsButtonPressed(Keyboard.KEY_I, 0)  then
                get()   
                                 
        end

        
        if Input.IsButtonPressed(Keyboard.KEY_O, 0)  then
            -- print("spawn")
           
            for _, i in pairs(mytable) do            
                pour(i)
                -- e.Type, e.Variant, e.SubType
                -- print(i.Type)
                -- print(i.Variant)
                -- print(i.SubType)
                -- print('\n')
            end
            mytable = {}
            fDp:RemoveData ()
        end
    -- end
end)






