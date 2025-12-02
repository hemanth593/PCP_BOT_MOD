-- TALISMAN ONLINE LUA HOOK MOD LOADER
-- MADE BY Hemanth credits Danski 
-- v0.02

--global helpers
executeCommand = function(command)
    local tmpFile = "temp_output.txt"
    os.execute(command .. " > " .. tmpFile) 
    local file = io.open(tmpFile, "r")
    local output = file:read("*all")
    file:close()
    os.remove(tmpFile)
    return output
end

string.trim = function (str)
    local startIndex = string.find(str, "%S") 
    if not startIndex then return "" end  
    
    -- Remove trailing whitespace
    local endIndex = string.find(str, "%S%s*$")
    return string.sub(str, startIndex, endIndex)
end

-- load all mods from /mods
local function loadMods(folder)
    local modules = {}
	
    local fileList = executeCommand("dir /b " .. folder)  -- Linux/macOS: 'ls', Windows: 'dir /b'
    
    if fileList == "" then
        print("No files found in folder: " .. folder)
        return modules
    end

    local files = {}
    
    for file in string.gfind(fileList, "([^\r\n]+)") do
        file = string.trim(file)

        if file ~= "" and string.find(file, "%.lua$") then
            local alreadyExists = false
            for _, v in ipairs(files) do
                if v == file then
                    alreadyExists = true
                    break
                end
            end
            
            if not alreadyExists then
                print("Found Lua file: " .. file)
                table.insert(files, file)
            end
        end
    end

    for _, file in ipairs(files) do
        if string.find(file, "%.lua$") then
            local moduleName = folder .. "/" .. file
			
            local success, module = pcall(dofile, moduleName)
            if success then
                print("Successfully loaded module: " .. moduleName) 
                modules[file] = module 
            else
                print("Failed to load module: " .. moduleName) 
            end
        end
    end

    return modules
end

local mods = nil

--HOOKS
--on ui load

function layWorld_frmEntrusthall_OnLoad( self )
	print("-- TO MODLOADER v0.01 --") --init and load mods
	mods = loadMods('mods')
	for modName, mod in pairs(mods) do
		if mod.onLoad then
			mod.onLoad() --call main func on mods
		end
	end
end

__layWorld_lbLayerAlern_OnUpdate = function(self)
	for modName, mod in pairs(mods) do
		if mod.onTick then
			mod.onTick() --call tick func in mods
		end
	end
end

function layWorld_frmEntrusthall_OnEvent( self, event, arg )

end

function layWorld_frmEntrusthall_OnShow( self )

end

function layWorld_frmEntrusthall_BtnRefresh_OnClicked( self )

end

function layWorld_frmEntrusthall_BtnPrepage_OnClicked( self )
	
end

function layWorld_frmEntrusthall_BtnNextpage_OnClicked( self )

end

function layWorld_frmEntrusthall_OnHide( self )

end

--developer credits in ping check
layWorld_frmSystemButtonEx_lbNetStatus_OnHint = function(self)
   local ping = uiNetGetData()
   local hint_text = string.format(LAN("net_status_hint1"), ping)
   hint_text = hint_text .. '\nMade by hemanth :)'
   self:SetHintText(hint_text)
end

function layWorld_frmDialogerEx_OnUpdate(self, delta)
	local bInside = uiNpcDialogCheckDistance();
	if bInside == false then
		print("nigga out of dist");
		--self:Hide();
	end
end

function layWorld_frmMailEx_OnUpdate(self, delta)
	local bInside = uiNpcDialogCheckDistance();
	if bInside == false then
		print("nigga out of dist");
		--self:Hide();
	end
end

_G.uiNpcDialogCheckDistance = function()
	return true;
end 
