local Iteration = 1
local Type = "first"
local file = io.open("VehPosition.txt", "w")
local file2 = io.open("RaceInfo.txt", "w")
file:write(
	"Iteration" .. 
	"\t" ..
	"Time" .. 
	"\t" ..
	"HPos" ..
	"\t" ..
	"VPos" ..
	"\t" ..
	"Lap"	..		 
	"\t" ..
	"Speed" ..		
	"\t" ..
	"Player" ..		
	"\t" ..
	"Character" ..		
	"\n"

)

file2:write(
	"Iteration" .. 
	"\t" ..
	"P1Character" ..	
	"\t" ..
	"Class" ..	
	"\t" ..
	"Type" ..	
			
	"\n"

)


for Iteration = 0, 29 do 

savestate.loadslot(1)

Class = "50CC"

if Iteration % 2 == 0 then
	Type = "idle"
	else 
		Type = "first"
end

ButtonToPress = {}
ButtonToPress['Down'] = true
if Iteration >= 10 then	--100CC--
	joypad.set(ButtonToPress,1)
	emu.frameadvance()
	emu.frameadvance()
	Class = "100CC"
end

if Iteration >= 20 then --150CC--
	joypad.set(ButtonToPress,1)
	emu.frameadvance()
	Class = "150CC"
end

ButtonToPress = {}
ButtonToPress['B'] = true

joypad.set(ButtonToPress,1) --Choose CC--

for i=1, 50 do --wait for next pop up
	emu.frameadvance();
end

joypad.set(ButtonToPress,1)	--is this correct? yes--

for i=1, math.random(1000) do --wait a random time for races to be different--
	emu.frameadvance();
end

ButtonToPress = {}
ButtonToPress['Right'] = true
	
for i=0, math.random(8)-1 do	--choose a random character--

	joypad.set(ButtonToPress,1)
	emu.frameadvance();
	emu.frameadvance();
end

ButtonToPress = {}
ButtonToPress['B'] = true

for i=1, 200  do	-- press B--

	joypad.set(ButtonToPress,1)
	emu.frameadvance()
	emu.frameadvance()
end

time1 = memory.readbyte(0x0101)

while time1 == 0 do	--wait for race to start--
	emu.frameadvance()
	time1 = memory.readbyte(0x0101)
end

RaceInProgress = true

if Type == "first" then
	memory.writebyte(0x10C1,133) --finish the "race"--
end

i=0
time=0
while RaceInProgress do

	if Type == "first" then
		if memory.readbyte(0x1040) ~= 0 and time < 1000 then --until we get first
			joypad.set(ButtonToPress,1) --get first--
		end
	end

	P1Char = memory.readbyte(0x1012)

	time = 	
		tonumber(bizstring.hex(memory.readbyte(0x0104)))*60*100 + --Time, minutes--
		tonumber(bizstring.hex(memory.readbyte(0x0102)))*100 + --Time, seconds--
		tonumber(bizstring.hex(memory.readbyte(0x0101))) --Time, hundreth of seconds--



	i = (i + 1) % 5
	if i == 0 then 
		
		file:write(
		
			Iteration ..
			"\t" ..		
			time ..
			"\t" ..
			memory.read_s32_le(0x1117) .. -- HPos --
			"\t" ..
			memory.read_s32_le(0x111B) .. -- VPos --	
			"\t" ..
			memory.readbyte(0x11C1) .. -- Lap --				
			"\t" ..
			memory.read_u16_le(0x11EA) .. -- Speed --				
			"\t" ..
			"Player2" .. -- Player --				
			"\t" ..
			memory.readbyte(0x1112) .. -- Player --									
			"\n" ..
			
			Iteration ..
			"\t" ..					
			time ..		
			"\t" ..
			memory.read_s32_le(0x1217) .. -- HPos --
			"\t" ..
			memory.read_s32_le(0x121B) .. -- VPos --	
			"\t" ..
			memory.readbyte(0x12C1) .. -- Lap --				
			"\t" ..
			memory.read_u16_le(0x12EA) .. -- Speed --
			"\t" ..
			"Player3" .. -- Player --				
			"\t" ..
			memory.readbyte(0x1212) .. -- Player --		
					
			"\n" ..
			
			Iteration ..
			"\t" ..					
			time ..		
			"\t" ..			
			memory.read_s32_le(0x1317) .. -- HPos --
			"\t" ..
			memory.read_s32_le(0x131B) .. -- VPos --	
			"\t" ..
			memory.readbyte(0x13C1) .. -- Lap --				
			"\t" ..
			memory.read_u16_le(0x13EA) .. -- Speed --
			"\t" ..
			"Player4" .. -- Player --				
			"\t" ..
			memory.readbyte(0x1312) .. -- Player --			
					
			"\n" ..
			
			Iteration ..
			"\t" ..					
			time ..		
			"\t" ..
			memory.read_s32_le(0x1417) .. -- HPos --
			"\t" ..
			memory.read_s32_le(0x141B) .. -- VPos --	
			"\t" ..
			memory.readbyte(0x14C1) .. -- Lap --				
			"\t" ..
			memory.read_u16_le(0x14EA) .. -- Speed --
			"\t" ..
			"Player5" .. -- Player --				
			"\t" ..
			memory.readbyte(0x1412) .. -- Player --		
					
			"\n" ..
			
			Iteration ..
			"\t" ..					
			time ..		
			"\t" ..
			memory.read_s32_le(0x1517) .. -- HPos --
			"\t" ..
			memory.read_s32_le(0x151B) .. -- VPos --	
			"\t" ..
			memory.readbyte(0x15C1) .. -- Lap --				
			"\t" ..
			memory.read_u16_le(0x15EA) .. -- Speed --
			"\t" ..
			"Player6" .. -- Player --				
			"\t" ..
			memory.readbyte(0x1512) .. -- Player --		
					
			"\n" ..
			
			Iteration ..
			"\t" ..					
			time ..		
			"\t" ..
			memory.read_s32_le(0x1617) .. -- HPos --
			"\t" ..
			memory.read_s32_le(0x161B) .. -- VPos --	
			"\t" ..
			memory.readbyte(0x16C1) .. -- Lap --				
			"\t" ..
			memory.read_u16_le(0x16EA) .. -- Speed --
			"\t" ..
			"Player7" .. -- Player --				
			"\t" ..
			memory.readbyte(0x1612) .. -- Player --		

			"\n" ..
			
			Iteration ..
			"\t" ..					
			time ..		
			"\t" ..
			memory.read_s32_le(0x1717) .. -- HPos --
			"\t" ..
			memory.read_s32_le(0x171B) .. -- VPos --	
			"\t" ..
			memory.readbyte(0x17C1) .. -- Lap --				
			"\t" ..
			memory.read_u16_le(0x17EA) .. -- Speed --			
			"\t" ..
			"Player8" .. -- Player --				
			"\t" ..
			memory.readbyte(0x1712) .. -- Player --		
					
			"\n"
		)

	end
  	if math.min(
  		memory.readbyte(0x11C1),
  		memory.readbyte(0x12C1),
  		memory.readbyte(0x13C1),
  		memory.readbyte(0x14C1),
  		memory.readbyte(0x15C1),
  		memory.readbyte(0x16C1),
  		memory.readbyte(0x17C1)
  	)	== 133 then	--all finished
	
		RaceInProgress = false		
		file2:write(
			Iteration ..	
			"\t" ..
			P1Char .. -- Player Char --		
			"\t" ..
			Class .. -- Class --		
			"\t" ..
			Type .. -- Class --		
			"\n"			
  		--file:close()
		
		)
		--return
  	
  	end
	
	emu.frameadvance();
	
end
print(Iteration)

end

file:close()
file2:close()