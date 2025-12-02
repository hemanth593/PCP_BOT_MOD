local ffi = require("ffi")

-- Windows API definitions
ffi.cdef[[
    typedef void* HWND;
    typedef void* HANDLE;
    typedef unsigned long DWORD;
    typedef int BOOL;
    typedef const char* LPCSTR;
    typedef char* LPSTR;
    
    HWND FindWindowA(LPCSTR lpClassName, LPCSTR lpWindowName);
    BOOL EnumWindows(void* lpEnumFunc, void* lParam);
    BOOL GetWindowTextA(HWND hWnd, LPSTR lpString, int nMaxCount);
    BOOL SetWindowTextA(HWND hWnd, LPCSTR lpString);
    DWORD GetWindowThreadProcessId(HWND hWnd, DWORD* lpdwProcessId);
    HANDLE OpenProcess(DWORD dwDesiredAccess, BOOL bInheritHandle, DWORD dwProcessId);
    BOOL ReadProcessMemory(HANDLE hProcess, void* lpBaseAddress, void* lpBuffer, DWORD nSize, DWORD* lpNumberOfBytesRead);
    void CloseHandle(HANDLE hObject);
]]

local user32 = ffi.load("user32")
local kernel32 = ffi.load("kernel32")

-- Table to store found windows
local windows = {}

-- Callback function for window enumeration
local function enumWindowsProc(hwnd, lParam)
    local title = ffi.new("char[256]")
    if user32.GetWindowTextA(hwnd, title, 256) > 0 then
        local titleStr = ffi.string(title)
        if string.find(titleStr, "Talisman Online") then
            table.insert(windows, hwnd)
        end
    end
    return true
end

-- Find game windows with partial title matching
local function findGameWindows()
    windows = {} -- reset table
    local enumFunc = ffi.cast("BOOL(__stdcall*)(HWND, void*)", enumWindowsProc)
    user32.EnumWindows(enumFunc, nil)
    return windows
end

-- Memory reading functions
local function readMemory(pid, address, type, size)
    local process = kernel32.OpenProcess(0x0010, false, pid) -- PROCESS_VM_READ
    if process == nil then return nil end
    
    local buffer = ffi.new("char[?]", size)
    local bytesRead = ffi.new("DWORD[1]")
    
    local success = kernel32.ReadProcessMemory(
        process,
        ffi.cast("void*", address),
        buffer,
        size,
        bytesRead
    )
    
    kernel32.CloseHandle(process)
    
    if not success then return nil end
    
    if type == "d" then  -- DWORD (4 bytes)
        return tonumber(ffi.cast("uint32_t*", buffer)[0])
    elseif type == "s" then  -- String
        return ffi.string(buffer, bytesRead[0]):gsub("%z.*$", "") -- Remove null terminators
    end
    return nil
end

-- Get character name using your memory offsets
local function getCharacterName(pid)
    local CLIENT = 0x00400000
    local CHAR_NAME_POINTER = readMemory(pid, CLIENT + 0x00C20980, "d", 4)
    if not CHAR_NAME_POINTER then return "Unknown" end
    
    local name = readMemory(pid, CHAR_NAME_POINTER + 0x3C4, "s", 30)
    if name and string.match(name, "^[%w]+$") then
        return name
    else
        local namePtr = readMemory(pid, CHAR_NAME_POINTER + 0x3C4, "d", 4)
        if namePtr then
            return readMemory(pid, namePtr, "s", 30) or "Unknown"
        end
    end
    return "Unknown"
end

-- Main execution
print("Searching for Talisman Online windows...")
local gameWindows = findGameWindows()

if #gameWindows > 0 then
    print("Found", #gameWindows, "game windows")
    for _, hwnd in ipairs(gameWindows) do
        -- Get window title for confirmation
        local title = ffi.new("char[256]")
        user32.GetWindowTextA(hwnd, title, 256)
        local titleStr = ffi.string(title)
        print("Found window:", titleStr)
        
        -- Get PID from window handle
        local pid = ffi.new("DWORD[1]")
        user32.GetWindowThreadProcessId(hwnd, pid)
        pid = pid[0]
        
        if pid ~= 0 then
            local name = getCharacterName(pid)
            print("Setting window title to:", name)
            user32.SetWindowTextA(hwnd, name)
        else
            print("Could not get PID for window")
        end
    end
else
    print("No game windows found! Please check:")
    print("1. Game is running")
    print("2. Window title contains 'Talisman Online'")
    print("3. You're running as Administrator")
    print("Current window titles:")
    
    -- List all windows for debugging
    local allWindows = {}
    local enumFunc = ffi.cast("BOOL(__stdcall*)(HWND, void*)", function(hwnd, lParam)
        local title = ffi.new("char[256]")
        if user32.GetWindowTextA(hwnd, title, 256) > 0 then
            table.insert(allWindows, ffi.string(title))
        end
        return true
    end)
    user32.EnumWindows(enumFunc, nil)
    
    for i, title in ipairs(allWindows) do
        if #title > 0 then
            print(i, title)
        end
    end
end