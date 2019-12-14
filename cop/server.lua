local pInfo = createPickup(2200.8999,-1972.7,13.6, 3, 1239, 1, 1 );
local pRazdeval = createPickup(2198.3999,-1972.7,13.6, 3, 1275, 1, 1 );

addEvent( "onSpCars", true )
addEvent ( "skinJob", true )
addEvent ( "animJob", true )
addEvent ( "animJobPickupDel", true )
--//////// Bir araba oluşturun
-- x, y, z, döngüsü
CarLoadSpawn={
	{2177,-1977.8,14.3,270},
	{2177.1001,-1982.9,14.3,270},
	{2178.9004,-1988.5996,14.3,270},
	{2199,-1984.6,14.3,90},
	{2199,-1989.4,14.3,90},
	{2198.8999,-1994.5,14.3,90}
}

for i,v in ipairs(CarLoadSpawn) do
	local Pojazd = createVehicle(408, v[1], v[2], v[3], 0, 0, v[4])
    setElementData(Pojazd, "CarMysorshik",1)
    setVehicleColor (Pojazd, 255, 255, 255 )
    setVehicleEngineState(Pojazd, false)
	setVehicleRespawnPosition ( Pojazd, v[1], v[2], v[3], 0, 0, v[4])
end

addEventHandler("onVehicleEnter", resourceRoot, 
function(plr, seat)
    if seat == 0 then
        if getElementData(source, "CarMysorshik") == 1 then
			setElementData(plr,"EngineCar",source);
			if getElementData(plr,"worldjob") == false then
				outputChatBox("Bu arabanın anahtarları sende değil.", plr, 255, 255, 255)
				removePedFromVehicle (plr )
				return 
			end
			if getElementData(plr,"OpenBaga") == 1 then 
				outputChatBox ("Çöp kamyonunu almak için bagaj kapağını kapatın.- '4'", plr,255, 255, 255);
				setElementFrozen(source, true)
				setElementData(plr,"EngineCar",source);
				return			
			end
			if getElementData(plr,"gogogorace") == 0 then outputChatBox("Başlamak için '2' tuşuna basın bea", plr, 255, 255, 255) end
        end
    end
end)
function quitPlayer ( quitType )
	respawnVehicle(getElementData(source,"EngineCar"));
end
addEventHandler ( "onPlayerQuit", getRootElement(), quitPlayer )
function spawnOnCar(veh)
	respawnVehicle(veh)
end
addEvent( "onSpCars", true )
addEventHandler( "onSpCars", getRootElement(), spawnOnCar ) 
--////// Kamyonet	
function razdevalka(player)
	triggerClientEvent(player,"onClientRabOn", player);
end
addEventHandler("onPickupHit" , pRazdeval, razdevalka );

function informafion(player)
	triggerClientEvent(player,"infoRmafion", player);
end
addEventHandler("onPickupHit" , pInfo, informafion );
---////////////////Animasyonlar / Skins / Nesneler - herkes için görüntüleme------------
function anim()
setPedAnimation (source,"CARRY","putdwn",-1,false,false,true,false)
end
addEventHandler ( "animJob",root,anim)

function skinJob()
	if getElementData(source,"worldjob") == true then
		setElementData(source,"worldjobskinlater",tonumber(getElementModel (source)))
		setElementModel (source,16)
	else 
		setElementModel (source,getElementData(source,"worldjobskinlater"));
	end	
end
addEventHandler ( "skinJob",root,skinJob)

function animzjob()
	local skrzynia = createObject(1265, 0, 0, 0, 0, 0, 0)
    attachElements ( skrzynia, source, 0, 0.6, 0.7)
	setElementCollisionsEnabled(skrzynia, false)
	setPedAnimation (source, "CARRY", "crry_prtial", 1,true )
	setElementData(source,"ObjectSyka",skrzynia)
end
addEvent ( "animJobPickup", true )
addEventHandler ( "animJobPickup",root,animzjob)


function animzjobDel()
	if isElement (getElementData(source,"ObjectSyka")) then
		destroyElement(getElementData(source,"ObjectSyka"))
	end
end
addEventHandler ( "animJobPickupDel",root,animzjobDel)
