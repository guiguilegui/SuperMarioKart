ButtonToPress = {}
ButtonToPress['B'] = true
i = 0

time1 = memory.readbyte(0x0101)

while time1 == 0 do	--wait for race to start--
	emu.frameadvance()
	time1 = memory.readbyte(0x0101)
end

memory.writebyte(0x10C1,133) --finish the "race"--

while i < 300 do

	time=0
	
	if memory.readbyte(0x1040) ~= 0 then --until we get first
		joypad.set(ButtonToPress,1) --accelarate--
	end

	i = i + 1
	if i % 3 == 1 then
			client.screenshot("Cheat-" .. i+100 ..".png")

	end
	emu.frameadvance()
end
--convert -delay 5 -loop 0 Cheat-*png cheat.gif