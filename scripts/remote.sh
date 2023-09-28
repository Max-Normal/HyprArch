#!/bin/bash
#  _                           _      __     ____  __  
# | |    __ _ _   _ _ __   ___| |__   \ \   / /  \/  | 
# | |   / _` | | | | '_ \ / __| '_ \   \ \ / /| |\/| | 
# | |__| (_| | |_| | | | | (__| | | |   \ V / | |  | | 
# |_____\__,_|\__,_|_| |_|\___|_| |_|    \_/  |_|  |_| 
#                                                      
#  
# by Zachary Albertyn (2023) 
# ----------------------------------------------------- 

notify-send "Starting Remote Desktop now..."
xfreerdp -grab-keyboard /v:192.168.122.130 /size:100% /cert-ignore /u:zachary /p:zachary /sound /d: /dynamic-resolution /gfx-h264:avc444 +gfx-progressive &
exit


