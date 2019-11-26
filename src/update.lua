local LIB_FOLDER = "lib/"

function update(update_path)
	-- Constants
	local TMP_FILE = "/~tmp"
	local PROPERTIES_FILE = "config/urls.prop"
	local PROPERTIES_PROGRAM = LIB_FOLDER.."properties"

	-- Get pure name of file to be updated
	local update_name = fs.getName(update_path)

	--Retrieve the pastebin code for the file to be updated
	os.loadAPI(PROPERTIES_PROGRAM)
	local urls = properties.readFile(PROPERTIES_FILE)
	local code = urls[update_name]

	-- Make sure that the filepath at TMP_FILE is free
	fs.delete(TMP_FILE)
	-- Retrieve the file from pastebin.com/[code]
	shell.run("pastebin", "get", code, TMP_FILE)

	-- Check to make sure it properly downloaded
	local testfile = io.open(TMP_FILE)
	local is_empty = true
	for line in testfile:lines() do
		is_empty = false
		break
	end

	--If the file did not download correctly
	if is_empty then
		print("File did not download from pastebin correctly!")
		fs.delete(TMP_FILE)
	else
		-- Remove the current file
		fs.delete(update_path)
		-- Move the temp file to its final destination
		fs.move(TMP_FILE, update_path)
		print("Successfully updated " .. update_name)
	end
end

local argument = ...
if argument ~= nil then
	if string.find(argument, LIB_FOLDER) ~= nil then
		update(argument)
	else
		update(LIB_FOLDER..argument)
	end
end