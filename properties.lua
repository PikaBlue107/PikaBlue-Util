function readFile(filename)
	prop_table = {}
	prop_file = io.open(filename, "r")
	for line in prop_file:lines() do
		for key,value in string.gmatch(line, "(%a+)=(%w*)") do
			prop_table[key] = value
		end
	end
	prop_file:close()
	return prop_table
end