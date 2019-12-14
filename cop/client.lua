local unloadd = createMarker ( 2188.6001,-1997.9,10.5,"cylinder",3, 254, 0, 0,255);
local money = 50; -- 1 Adet Çöp Fiyatı
local aInfos =
{
    { vecPos = {2200.8999,-1972.7,13.6}, sText = "Bilgi"};
	{ vecPos = {2198.3999,-1972.7,13.6}, sText = "İş Başvurusu"};
	{ vecPos = {2188.6001,-1997.9,13.5}, sText = "Boşaltma İşlemi"};
	
};
racech1={
	{2230.1001, -1943.5, 13.4},
	{2046.3, -1897.8, 13.4},
	{1847.1, -1860.6, 13.4},
	{1729.2, -1743.3, 13.4},
	{1538.8, -1849.3, 13.4},
	{1512.9, -1850.1, 13.4},
	{1466.6, -1848.1, 13.4},
	{1419.9, -1846.9, 13.4},
	{1303.7, -1880, 13.4},
	{1288.1, -1863.4, 13.4},
	{1358.9, -1483.8, 13.4},
	{1355, -1491, 13.4},
	{1149.4, -1383.1, 13.7},
	{1148.9, -1343, 13.5},
	{1131.4, -1316.6, 13.5},
	{1210.7, -1130.2, 23.9},
	{786.40002, -1141.5, 23.7},
	{777.90002, -1120.5, 23.7},
	{763, -1011.8, 24},
	{693.90002, -1178.1, 15.2},
	{689.29999, -1188.1, 15.1},
	{470.29999, -1324, 15.3},
	{441.79999, -1304.3, 15},
	{410.59961, -1309.5, 14.8},
	{412.89999, -1313, 14.8},
}

addEvent("onClientRabOn", true);
addEvent("infoRmafion", true);
----- Kaplar için PE oluşturma
function markerCont()
	local destMarker = racech1[getElementData(localPlayer,"racenomber")]
	destinationMarker = createMarker(destMarker[1], destMarker[2], destMarker[3], "checkpoint", 2.7, 255, 0, 0, 130)
	visibleEnter = createMarker(destMarker[1], destMarker[2], destMarker[3]-1.5, "cylinder", 20, 255, 255, 255,0)-- Konteynere olan mesafeyi kontrol etmek için. Bu İşaretçi görünmez
	destBlip = createBlipAttachedTo(destinationMarker, 0)
	setElementData(localPlayer,"racenomber",getElementData(localPlayer,"racenomber")+1)
	addEventHandler("onClientMarkerHit", destinationMarker, marketOn)
	addEventHandler("onClientMarkerHit", visibleEnter, playerToPoint)
	addEventHandler ("onClientMarkerLeave", visibleEnter, markerLeave )
end
----- Konteynere olan mesafeyi kontrol etmek. Bu kontrol bagaj içindir, böylece hiçbir yerde Marker oluşturulmaz.
function playerToPoint(he, md)
	if not getPedOccupiedVehicle(he) then return end
	setElementData(he,"openbagaz",1);
end

function markerLeave ( leavingPlayer, matchingDimension )
    if not getPedOccupiedVehicle(leavingPlayer) then return end
	setElementData(leavingPlayer,"openbagaz",0);
end
----- çöpe atıldığında
function marketOn(he, md)
	if getElementData(he,"OpenBaga") == 0 then return outputChatBox ("Bagajı aç!",255, 255, 255); end
	if(getElementData(he,"raceloadcar") == 1) then triggerServerEvent ( "animJobPickupDel",localPlayer) end
	setElementData(he,"raceloadcar",1)
	triggerServerEvent ( "animJobPickup",he)
	addEventHandler("onClientMarkerHit", pickupOnLoad, marketCarLoad)
end
---- Tezgahta boşaltma kargo. Yani, 100 birim çöpün gövdesinde, o zaman kedi türü temizlik için çağrılır!
function marketCarUnLoad(he, md)
	if not getPedOccupiedVehicle(he) then return end
	outputChatBox ("Bagajı kaldırıldı",234, 184, 68 );
	outputChatBox ("Eğer çalışmaya devam etmek için düğmesine basarak '2' tuşu ya da gidip maaşını al",255, 255, 255);
	setElementData(he,"gryzKolvo",0)
	setElementData(he,"racenomber",1)
	setElementData(he,"racejob",false)
	destroyElement(unload)
	destroyElement(unloadBlip)
end
--- Bir çöp kamyonunun bagajına yakın bir marker. Daha doğrusu işlevselliği
function marketCarLoad(he, md)
	if getElementData(he,"raceloadcar")== 0 then return outputChatBox ("Çöpün yok",255, 255, 255); end
	if getElementData(he,"racekolvo") < 3 then
		setElementData(he,"racekolvo",getElementData(he,"racekolvo")+1)
		setElementData(he,"gryzKolvo",getElementData(he,"gryzKolvo")+1)
		setElementData(he,"gryzKolvoZp",getElementData(he,"gryzKolvoZp")+1)
		setElementData(he,"raceloadcar",0)
		triggerServerEvent ("animJob",he)
		triggerServerEvent ("animJobPickupDel",he)
	else 
		setElementData(he,"racekolvo",getElementData(he,"racekolvo")+1)
		setElementData(he,"gryzKolvo",getElementData(he,"gryzKolvo")+1)
		setElementData(he,"gryzKolvoZp",getElementData(he,"gryzKolvoZp")+1)
		setElementData(he,"raceloadcar",0)
		setElementData(he,"racekolvo",0);
		triggerServerEvent ( "animJob",he)
		triggerServerEvent ( "animJobPickupDel",he)
		destroyElement(destinationMarker)
		destroyElement(visibleEnter)
		destroyElement(destBlip)
		if getElementData(he,"gryzKolvo") <100 then
			outputChatBox ("Başka bir konteyner gidin, haritada işaretlenmiştir.",234, 184, 68 );
			markerCont()
		else	
			outputChatBox ("Kamyon dolu! Git boşaltıp Gel lan!",234, 184, 68 );
			unload = createMarker ( 2188.6001,-1997.9,13.6,"checkpoint",2.7, 254, 0, 0,255);
			unloadBlip = createBlipAttachedTo(unload, 0)
			addEventHandler("onClientMarkerHit", unload, marketCarUnLoad)	
		end
	end	
end
---Çalışmaya başlayan sistem!
function goJob()
	if getElementData(localPlayer,"gryzKolvo") >= 100 then return outputChatBox ("Kamyonun dolu! Çalışmaya başlayamazsınız.",234, 184, 68 );end 
	if not getPedOccupiedVehicle(getLocalPlayer()) then return end
	if getElementData(getLocalPlayer(),"worldjob") == false then return end
	if getElementData(getLocalPlayer(),"racejob") == true then return end
	for i =1,8 do
		outputChatBox ("");
	end 
	outputChatBox ("Kırmızı belirteçler doğru gidin orada çöp konteynerını temizleyin",234, 184, 68 );
	outputChatBox ("Düğmeleri kullanın\n'3' - Aç/Kapat Hadi Görüşürük",234, 184, 68 );
	setElementData(localPlayer,"racenomber",1)
	setElementData(localPlayer,"gogogorace",1)
	setElementData(localPlayer,"racekolvo",0)
	setElementData(localPlayer,"raceloadcar",0)
	setElementData(localPlayer,"racejob",true)
	setElementData(localPlayer,"OpenBaga",0);
	markerCont();
end
---- Bagajın yanında bir işaretçi yaratmak!
function openBagaznik()
	if getElementData(getLocalPlayer(),"worldjob") == false then return end
	if not getPedOccupiedVehicle(getLocalPlayer()) then return end
	if getElementData(getLocalPlayer(),"openbagaz") == 0 then return outputChatBox ("Çöpten uzaksın!",255, 255, 255); end
	if getElementData(getLocalPlayer(),"OpenBaga") == 1 then 
		destroyElement(pickupOnLoad);
		setElementData(getLocalPlayer(),"OpenBaga",0);
		setElementFrozen(getElementData(getLocalPlayer(),"EngineCar"), false)
		removeEventHandler("onClientRender",getRootElement(), UpdateBagaz);
	else
		local car = getPedOccupiedVehicle(getLocalPlayer())
		local x,y,z = getPositionFromElementOffset(car,0,-4.5,-1.5)
		pickupOnLoad = createMarker(x, y, z,"cylinder",1.5, 255, 215, 0,50);
		setElementFrozen(getElementData(getLocalPlayer(),"EngineCar"), true)
		setElementData(getLocalPlayer(),"OpenBaga",1);
		addEventHandler( "onClientRender", getRootElement(), UpdateBagaz );
	end
end
---- Bagajın yanında bir işaretleyiciyi çıkarma
function closeBagaznik()
	if getElementData(getLocalPlayer(),"worldjob") == false then return end
	if not getPedOccupiedVehicle(getLocalPlayer()) then return end
	if getElementData(getLocalPlayer(),"openbagaz") == 0 then return outputChatBox ("Uzakta Çöp Panpa!",255, 255, 255); end
	destroyElement(pickupOnLoad);
	setElementData(getLocalPlayer(),"OpenBaga",0);
	setElementData(getLocalPlayer(),"openbagaz",0);
	setElementFrozen(getElementData(getLocalPlayer(),"EngineCar"), false)
	removeEventHandler("onClientRender",getRootElement(), UpdateBagaz);
end
bindKey("2", "down", goJob);
bindKey("3", "down", openBagaznik);
--bindKey("4", "down", closeBagaznik);
--/////////**************Gui 
GUIEditor = {
    button = {},
    window = {},
    staticimage = {},
    label = {}
}
GUIRazdevalka = {
    button = {},
    window = {},
    staticimage = {},
    label = {}
}
addEventHandler( "onClientRabOn", getLocalPlayer(),
 function()
		GUIEditor.window[1] = guiCreateWindow(533, 217, 544, 297, "Çöpçülük mesleği V.1'", false)
		guiWindowSetSizable(GUIEditor.window[1], false)
		GUIEditor.staticimage[1] = guiCreateStaticImage(211, 46, 121, 95, "opaha.png", false, GUIEditor.window[1])
		if getElementData(getLocalPlayer(),"worldjob") == true then
			GUIEditor.button[1] = guiCreateButton(56, 235, 117, 30, "Evet", false, GUIEditor.window[1])
			GUIEditor.button[2] = guiCreateButton(366, 235, 117, 30, "Hayır", false, GUIEditor.window[1])
			GUIEditor.label[1] = guiCreateLabel(54, 168, 429, 31, "İşi iptal etmek istiyor musun?", false, GUIEditor.window[1])
		else		
			GUIEditor.button[1] = guiCreateButton(56, 235, 117, 30, "Onaylıyorum", false, GUIEditor.window[1])
			GUIEditor.button[2] = guiCreateButton(366, 235, 117, 30, "Hayır", false, GUIEditor.window[1])
			GUIEditor.label[1] = guiCreateLabel(54, 168, 429, 31, "İş başvurusuna hoşgeldin'?", false, GUIEditor.window[1])
		end
		guiSetFont(GUIEditor.label[1], "default-bold-small")
		guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
		guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
		centerWindow (GUIEditor.window[1]);
        guiSetVisible (GUIEditor.window[1], true )
		showCursor(true);
		addEventHandler( "onClientGUIClick", GUIEditor.button[1], function()
		if getElementData(getLocalPlayer(),"worldjob") == false then
			guiSetVisible (GUIEditor.window[1], false )
			showCursor(false);
			setElementData(getLocalPlayer(),"worldjob",true)
			triggerServerEvent ( "skinJob",getLocalPlayer())
			setElementData(localPlayer,"gryzKolvo",0)
			setElementData(localPlayer,"gryzKolvoZp",0)
			setElementData(localPlayer,"openbagaz",0);
			setElementData(localPlayer,"gogogorace",0)
			setElementData(localPlayer,"racejob",false)
			for i =1,9 do
				outputChatBox ("");
			end 
			outputChatBox ("Göreve hoş geldin çaylak",234, 184, 68 );
		else	
			guiSetVisible (GUIEditor.window[1], false )
			showCursor(false);
			setElementData(getLocalPlayer(),"worldjob",false)
			triggerServerEvent ( "skinJob",getLocalPlayer())
			local newmoney = getElementData(localPlayer,"gryzKolvoZp")*money;
			givePlayerMoney(newmoney);
			setElementData(localPlayer,"gogogorace",0)
			outputChatBox ("------------------------",255, 255, 255);
			outputChatBox ("İş günü bitti, maaşınız:"..jobmoney.."$",255, 255, 255);
			outputChatBox ("------------------------",255, 255, 255);
			local veh = getElementData(localPlayer,"EngineCar");
			triggerServerEvent( "onSpCars", getRootElement(),veh);
			triggerServerEvent ( "animJobPickupDel",localPlayer)
			destroyElement(destinationMarker)
			destroyElement(visibleEnter)
			destroyElement(destBlip)
			setElementData(getLocalPlayer(),"racenomber",1);
			if(getElementData(getLocalPlayer(),"OpenBaga") == 1) then 
				destroyElement(pickupOnLoad);
				setElementData(getLocalPlayer(),"OpenBaga",0);
				setElementData(getLocalPlayer(),"openbagaz",0);
				setElementFrozen(getElementData(getLocalPlayer(),"EngineCar"), false)
				removeEventHandler("onClientRender",getRootElement(), UpdateBagaz); 
			end
		end	
		end, false )
		addEventHandler( "onClientGUIClick", GUIEditor.button[2], function()
			guiSetVisible (GUIEditor.window[1], false )
			showCursor(false);
		end, false )
	end
);
addEventHandler( "infoRmafion", getLocalPlayer(),
    function()
		local nemoney=money*100;
		GUIRazdevalka.window[1] = guiCreateWindow(562,317, 562, 317, "Bilgi", false)
		guiWindowSetSizable(GUIRazdevalka.window[1], false)
		GUIRazdevalka.label[1] = guiCreateLabel(23, 129, 516, 122, "bu eserin özü, çöplerin devlet tarafından konteyner halinde toplanmasıdır "..nemoney.."$'", false, GUIRazdevalka.window[1])
		guiSetFont(GUIRazdevalka.label[1], "default-bold-small")
		guiLabelSetHorizontalAlign(GUIRazdevalka.label[1], "center", true)
		guiLabelSetVerticalAlign(GUIRazdevalka.label[1], "center")
		GUIRazdevalka.button[1] = guiCreateButton(231, 261, 99, 28, "Ок", false, GUIRazdevalka.window[1])
		GUIRazdevalka.staticimage[1] = guiCreateStaticImage(231, 44, 99, 75, "opaha.png", false, GUIRazdevalka.window[1])
		centerWindow (GUIRazdevalka.window[1]);
		guiSetVisible (GUIRazdevalka.window[1], true )
		showCursor(true);
		addEventHandler( "onClientGUIClick", GUIRazdevalka.button[1], function()
			guiSetVisible (GUIRazdevalka.window[1], false )
			showCursor(false);
		end, false )
    end
)	
--//////////****** Diğer fonksiyonlar
function getPositionFromElementOffset(element,offX,offY,offZ) --// kamyon  koordinatları
	if not offX or not offY or not offZ then
		return false
	end
    local m = getElementMatrix ( element )
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z 
end
function centerWindow (center_window)--// Ekranın merkezi, Gui için
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (screenW - windowW)/2,(screenH - windowH)/2
    guiSetPosition(center_window, x, y, false)
end 
--///*********** 3Dэ Text Render
function UpdateBagaz()
	-- _, Görüyorum gündem tayfa rapte ölü sevici
		local cx,cy,cz = getCameraMatrix()
		local px,py,pz = getElementPosition(pickupOnLoad);
		pz = pz+1
		local distance = getDistanceBetweenPoints3D(cx,cy,cz,px,py,pz)
		local posx,posy = getScreenFromWorldPosition(px,py,pz+0.025*distance+0.40)
		if posx and distance <= 15 then
			dxDrawBorderedText("yüklenen: "..getElementData(localPlayer,"gryzKolvo").."/100",posx-(0.5),posy-(20),posx-(0.5),posy-(20),tocolor(255,175,0,255),1,1,"default-bold","center","top",false,false,false)
		end
	--end
end
function xyi()
	for _, Data in pairs( aInfos ) do
		local cx,cy,cz = getCameraMatrix()
		local px,py,pz = unpack(Data.vecPos);
		local distance = getDistanceBetweenPoints3D(cx,cy,cz,px,py,pz)
		local posx,posy = getScreenFromWorldPosition(px,py,pz+0.025*distance+0.40)
		if posx and distance <= 15 then
			dxDrawBorderedText(Data.sText,posx-(0.5),posy-(20),posx-(0.5),posy-(20),tocolor(255,175,0,255),1,1,"default-bold","center","top",false,false,false)
		end
	end
end
function dxDrawBorderedText(text,left,top,right,bottom,color,scale,outlinesize,font,alignX,alignY,clip,wordBreak,postGUI,colorCoded)
	local outlinesize = math.min(scale,outlinesize)
	if outlinesize > 0 then
		for offsetX=-outlinesize,outlinesize,outlinesize do
			for offsetY=-outlinesize,outlinesize,outlinesize do
				if not (offsetX == 0 and offsetY == 0) then
					dxDrawText(text:gsub("#%x%x%x%x%x%x",""), left+offsetX, top+offsetY, right+offsetX, bottom+offsetY, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI)
				end
			end
		end
	end
	dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
end
addEventHandler( "onClientRender", root, xyi );