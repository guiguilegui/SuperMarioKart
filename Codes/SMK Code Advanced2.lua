local file = io.open("VehPosition2.txt", "w")
file:write(
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




savestate.loadslot(2)

RaceInProgress = true


i=0
time=0
while RaceInProgress do
	i = i + 1

	P1Char = memory.readbyte(0x1012)

	time = 	
		tonumber(bizstring.hex(memory.readbyte(0x0104)))*60*100 + --Time, minutes--
		tonumber(bizstring.hex(memory.readbyte(0x0102)))*100 + --Time, seconds--
		tonumber(bizstring.hex(memory.readbyte(0x0101))) --Time, hundreth of seconds--
		
	if i % 3 == 1 then
			client.screenshot("Cheat-" .. i+1000 ..".png")
		--convert -delay 5 -loop 0 Cheat-*png cheat.gif --cmd command
	end
	
	if time > 0 then
	memory.write_s32_le(0x1017,(memory.read_s32_le(0x1617) + memory.read_s32_le(0x1717))/2)
	memory.write_s32_le(0x101B,(memory.read_s32_le(0x161B) + memory.read_s32_le(0x171B))/2)
	memory.writebyte(0x10C1,memory.readbyte(0x16C1)) --get # of lap of player 7--
	end
	
	if i % 5 == 0 and time > 0 then 



		
		file:write(		
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
  		memory.readbyte(0x16C1),
  		memory.readbyte(0x17C1)
  	)	== 129 then	--all finished
	
		RaceInProgress = false		
  	
  	end
	
	emu.frameadvance();
	
end


file:close()