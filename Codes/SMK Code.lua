local i = 0

local file = io.open("Results.txt", "w")
file:write(
	"Time" .. 
	
	"\t" ..
	
	"HPos2" ..
	"\t" ..
	"VPos2" ..
	"\t" ..
	"Lap2"	..		 
	"\t" ..
	"Speed2" ..		
	
	"\t" ..
	
	"HPos3" ..
	"\t" ..
	"VPos3" ..
	"\t" ..
	"Lap3"	 ..		
	"\t" ..
	"Speed3" ..	

	"\t" ..
				
	"HPos4" ..
	"\t" ..
	"VPos4" ..
	"\t" ..
	"Lap4" ..			
	"\t" ..
	"Speed4" ..	

	"\t" ..
	
	"HPos5" ..
	"\t" ..
	"VPos5" ..
	"\t" ..
	"Lap5" ..			
	"\t" ..
	"Speed5" ..	
	
	"\t" ..
	
	"HPos6" ..
	"\t" ..
	"VPos6" ..
	"\t" ..
	"Lap6"	 ..		
	"\t" ..
	"Speed6" ..	
	
	"\t" ..
	
	"HPos7" ..
	"\t" ..
	"VPos7" ..
	"\t" ..
	"Lap7"	 ..		
	"\t" ..
	"Speed7" ..	
	
	"\t" ..
	
	"HPos8" ..
	"\t" ..
	"VPos8" ..
	"\t" ..
	"Lap8"	 ..		
	"\t" ..
	"Speed8" ..
	
	"\n"

)
		
while true do
	i = (i + 1) % 5
	if i == 0 then 
		file:write(
			string.format("%x", memory.readbyte(0x0104),16) ..
			string.format("%x", memory.readbyte(0x0102),16) .. 
			string.format("%x", memory.readbyte(0x0101),16) ..
			
			"\t" ..
			
			memory.read_s32_le(0x1117) .. -- HPos --
			"\t" ..
			memory.read_s32_le(0x111B) .. -- VPos --	
			"\t" ..
			memory.readbyte(0x11C1) .. -- Lap --				
			"\t" ..
			memory.read_u16_le(0x11EA) .. -- Speed --				
			
			"\t" ..
			
			memory.read_s32_le(0x1217) .. -- HPos --
			"\t" ..
			memory.read_s32_le(0x121B) .. -- VPos --	
			"\t" ..
			memory.readbyte(0x12C1) .. -- Lap --				
			"\t" ..
			memory.read_u16_le(0x12EA) .. -- Speed --

			"\t" ..
						
			memory.read_s32_le(0x1317) .. -- HPos --
			"\t" ..
			memory.read_s32_le(0x131B) .. -- VPos --	
			"\t" ..
			memory.readbyte(0x13C1) .. -- Lap --				
			"\t" ..
			memory.read_u16_le(0x13EA) .. -- Speed --

			"\t" ..
			
			memory.read_s32_le(0x1417) .. -- HPos --
			"\t" ..
			memory.read_s32_le(0x141B) .. -- VPos --	
			"\t" ..
			memory.readbyte(0x14C1) .. -- Lap --				
			"\t" ..
			memory.read_u16_le(0x14EA) .. -- Speed --
			
			"\t" ..
			
			memory.read_s32_le(0x1517) .. -- HPos --
			"\t" ..
			memory.read_s32_le(0x151B) .. -- VPos --	
			"\t" ..
			memory.readbyte(0x15C1) .. -- Lap --				
			"\t" ..
			memory.read_u16_le(0x15EA) .. -- Speed --
			
			"\t" ..
			
			memory.read_s32_le(0x1617) .. -- HPos --
			"\t" ..
			memory.read_s32_le(0x161B) .. -- VPos --	
			"\t" ..
			memory.readbyte(0x16C1) .. -- Lap --				
			"\t" ..
			memory.read_u16_le(0x16EA) .. -- Speed --
			
			"\t" ..
			
			memory.read_s32_le(0x1717) .. -- HPos --
			"\t" ..
			memory.read_s32_le(0x171B) .. -- VPos --	
			"\t" ..
			memory.readbyte(0x17C1) .. -- Lap --				
			"\t" ..
			memory.read_u16_le(0x17EA) .. -- Speed --			
			
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
  		
  		file:close()
		return
  	
  	end
	
	emu.frameadvance();
	
end