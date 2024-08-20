import os, winlean, times, system, strutils, osproc, math

# Windows API to detect key pressed
proc GetAsyncKeyState(vKey: int32): int32 {.stdcall, importc: "GetAsyncKeyState", dynlib: "user32.dll".}

# Constants for the Windows key bindings for WIN+SHIFT+T
const
  VK_LWIN   = 0x5B # Left Windows key
  VK_RWIN   = 0x5C # Right Windows key
  VK_LSHIFT = 0xA0 # Left Shift key
  VK_RSHIFT = 0xA1 # Right Shift key
  VK_T      = 0x54 # 'T' key

# Root directory of temporary folders
const ROOT_FOLDER = "C://TempFolders//"

# Method to check whether a key is pressed
proc isPressed(vKey: int32): bool =
    return (GetAsyncKeyState(vKey) and 0x8000) != 0

# Method to create and open a temporary folder
proc createTemporaryFolder() =
    var current = $epochTime().int
    if not existsDir(ROOT_FOLDER): createDir(ROOT_FOLDER)
    if not existsDir(ROOT_FOLDER & current): createDir(ROOT_FOLDER & current)
    discard execCmd("explorer \"" & ROOT_FOLDER & current & "\"")

# Main process
proc detectWinT() =
  while true:
    let winPressed = (isPressed(VK_LWIN) or isPressed(VK_RWIN))
    let shiftPressed = (isPressed(VK_LSHIFT) or isPressed(VK_RSHIFT))
    let tPressed = (isPressed(VK_T))

    # If all keys are pressed together
    if tPressed and winPressed and shiftPressed:
      
      # Create the temporary folder
      createTemporaryFolder()

      # Wait until keys been released to prevent overlapping 
      while isPressed(VK_LWIN) or isPressed(VK_RWIN) or isPressed(VK_T) or isPressed(VK_LSHIFT) or isPressed(VK_RSHIFT):
        
        # Waiting time
        sleep(1000)

    # The interval of checking, to prevent high CPU usage
    sleep(50)

# Launch
detectWinT()
