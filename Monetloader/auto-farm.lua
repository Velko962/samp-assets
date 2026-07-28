script_name("Samp Auto Farm")
script_authors("Chandra")
script_description("Kimak")
script_version("0.1")
script_dependencies("SAMPFUNCS", "SAMP","CLEO")

---------------------------------------------------------------------------

require "lib.moonloader"

---------------------------------------------------------------------------

function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
    sampRegisterChatCommand("Botsrp", cmd_bot)

	local saveX = {}
	local saveY = {}
	local saveZ = {}
	while true do
		wait(0)
		if isPlayerPlaying(playerHandle) and enabled then
---------------------------------------------------------------------------
	  	 BeginToPoint(-1106.8093,-1267.5032,129.2188,104.5228, -255, false)
		
			BeginToPoint(-1104.5856,-1278.4640,129.2188,93.2635, -255, false)
			
			BeginToPoint(-1091.4186,-1269.4410,129.2188,245.0829, -255, false)
			
			BeginToPoint(-1099.1808,-1266.5135,129.2188,89.5871, -255, false)
			
			BeginToPoint(-1091.3673,-1269.7333,129.2188,257.7859, -255, false)
			
			BeginToPoint(-1094.8578,-1280.1429,129.2188,249.0543, -255, false)
			
			BeginToPoint(-1076.6193,-1270.0446,129.2188,266.9771, -255, false)
			
			BeginToPoint(-1099.1855,-1266.5985,129.2188,97.9242, -255, false)
			
			BeginToPoint(-1094.8497,-1280.1045,129.2188,257.3264, -255, false)
			
			BeginToPoint(-1071.8770,-1283.4872,129.2188,266.2878, -255, false)
			
			
---------------------------------------------------------------------------
		end
	end
end



--------------------------- STANDART FUNCTIONS ---------------------------

function BeginToPoint(x, y, z, radius, move_code, isSprint)
	repeat
		local posX, posY, posZ = GetCoordinates()
		SetAngle(x, y, z)
		MovePlayer(move_code, isSprint)
		local dist = getDistanceBetweenCoords3d(x, y, z, posX, posY, z)
		setGameKeyState(65536, 0)
		
	until not enabled or dist < radius
end
function MovePlayer(move_code, isSprint)
	setGameKeyState(1, move_code)
	--[[255 - berlari kembali secara teratur
	   -255 - lari ke depan normal
       65535 - maju selangkah 
      -65535 - berjalan mundur]]
	if isSprint then setGameKeyState(16, 255) end
end

function SetAngle(x, y, z)
	local posX, posY, posZ = GetCoordinates()
	local pX = x - posX
	local pY = y - posY
	local zAngle = getHeadingFromVector2d(pX, pY)

	if isCharInAnyCar(playerPed) then
		local car = storeCarCharIsInNoSave(playerPed)
		setCarHeading(car, zAngle)
	else
		setCharHeading(playerPed, zAngle)
	end

	restoreCameraJumpcut()
end

function GetCoordinates()
	if isCharInAnyCar(playerPed) then
		local car = storeCarCharIsInNoSave(playerPed)
		return getCarCoordinates(car)
	else
		return getCharCoordinates(playerPed)
	end
end

function cmd_bot(param)
	enabled = not enabled
	if enabled then
		sampAddChatMessage(string.format("[%s]: ����������� �� ��� �� ������.", thisScript().name), 0xFF0000FF)
	else
		sampAddChatMessage(string.format("[%s]: ������������� �������, ��� �������������� ���� ����� �����.", thisScript().name), 0xFFFF22FF)
	end
end

-- Teleport from ClickWarp (by FYP)
function teleportPlayer(x, y, z)
	if isCharInAnyCar(playerPed) then
		setCharCoordinates(playerPed, x, y, z)
	end
	setCharCoordinatesDontResetAnim(playerPed, x, y, z)
end

function setCharCoordinatesDontResetAnim(char, x, y, z)
	if doesCharExist(char) then
		local ptr = getCharPointer(char)
		setEntityCoordinates(ptr, x, y, z)
	end
end

function setEntityCoordinates(entityPtr, x, y, z)
	if entityPtr ~= 0 then
		local matrixPtr = readMemory(entityPtr + 0x14, 4, false)
		if matrixPtr ~= 0 then
			local posPtr = matrixPtr + 0x30
			writeMemory(posPtr + 0, 4, representFloatAsInt(x), false) --X
			writeMemory(posPtr + 4, 4, representFloatAsInt(y), false) --Y
			writeMemory(posPtr + 8, 4, representFloatAsInt(z), false) --Z
		end
	end
end
-- End Teleport code

--------------------------- ADDITIONAL FUNCTIONS ---------------------------

function SearchMarker(posX, posY, posZ, radius, isRace)
	local ret_posX = 0.0
	local ret_posY = 0.0
	local ret_posZ = 0.0
	local isFind = false

	for id = 0, 31 do
		local MarkerStruct = 0
		if isRace then MarkerStruct = 0xC7F168 + id * 56
		else MarkerStruct = 0xC7DD88 + id * 160 end
		local MarkerPosX = representIntAsFloat(readMemory(MarkerStruct + 0, 4, false))
		local MarkerPosY = representIntAsFloat(readMemory(MarkerStruct + 4, 4, false))
		local MarkerPosZ = representIntAsFloat(readMemory(MarkerStruct + 8, 4, false))

		if MarkerPosX ~= 0.0 or MarkerPosY ~= 0.0 or MarkerPosZ ~= 0.0 then
			if getDistanceBetweenCoords3d(MarkerPosX, MarkerPosY, MarkerPosZ, posX, posY, posZ) < radius then
				ret_posX = MarkerPosX
				ret_posY = MarkerPosY
				ret_posZ = MarkerPosZ
				isFind = true
				radius = getDistanceBetweenCoords3d(MarkerPosX, MarkerPosY, MarkerPosZ, posX, posY, posZ)
			end
		end
	end

	return isFind, ret_posX, ret_posY, ret_posZ
end
