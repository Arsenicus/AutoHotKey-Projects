;Author: Arekusei
;Version 0.1

#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
CoordMode, Mouse, Screen
#MaxThreadsPerHotkey 10

;------------------GUI----------------------

Global WinTitle := "Auto Clicker v0.1"
Global ClickerToggle := 0

Gui Margin, 5, 5
Gui Add, Text, x11 y10 w77 h13, Mouse Button
Gui Add, DropDownList, x11 y29 w74 vWhichBTN, Left||Right|Middle
Gui Add, Text, x94 y10 w109 h13, Mouse Coordinates
Gui Add, Edit, x93 y29 w50 h21 vxPos, 0
Gui Add, UpDown,Range0-1000 0x80,0
Gui Add, Edit, x153 y29 w50 h21 vyPos, 0
Gui Add, UpDown,Range0-1000 0x80,0
Gui Add, Button, x211 y28 w50 h23 gGetPos, SET
Gui Add, Text, x12 y68 w77 h13, Click Interval
Gui Add, Edit, x12 y89 w70 h21 vInterval, 1
Gui Add, UpDown,Range0-1000 0x80, 1
Gui Add, DropDownList, x93 y89 w82 AltSubmit vTimeUnit,Second(s)||Milisecond(s)
Gui Add, Button, x4 y118 w181 h29 gClickerSubmit vStart HWNDSubmit, Start [F1]
Gui Add, CheckBox, x276 y26 w91 h23 Checked vState gAlwaysOnTop, Always On Top
Gui Add, CheckBox, x276 y84 w84 h23 vClickForever gfn_Clickforever, Click Forever
Gui Add, Text, x198 y68 w77 h13, Amount: 
Gui Add, Edit, x197 y86 w70 h21 vAmount, 1
Gui Add, UpDown,Range0-1000 0x80 vRange,1

Gui Add, Edit, x197 y122 w70 h21 vAddRandom, 1
Gui Add, UpDown,Range0-1000 0x80, 0
Gui Add, Text, x276 y121 w81 h23 +0x200, Add Random ms
Gui Add, GroupBox, x189 y113 w187 h34 -Theme

Gui Add, GroupBox, x5 y0 w261 h58 -Theme
Gui Add, GroupBox, x5 y56 w180 h61 -Theme
Gui Add, GroupBox, x189 y56 w187 h61 -Theme
Gui Add, GroupBox, x270 y0 w106 h58 -Theme
;Gui Add, Text, x276 y9 w95 h13 +0x200, By Arekusei  v0.1
Gui Add, Link, x276 y9 w95 h13, <a href="">By Arekusei v0.1</a>
Gui +AlwaysOnTop
;w384 h156 
Gui Show, , % WinTitle ;AutoClicker v0.1
Hotkey, F1, ClickerSubmit



Return

;---------------GUI SUBMIT---------------

;F1::
ClickerSubmit:
    ClickerToggle := !ClickerToggle
    ;tooltip % ClickerToggle
    Gui, Submit , NoHide 
    GuiControl,,% Submit, % ClickerToggle ? "Stop [F1]" : "Start [F1]"
    if(!ClickerToggle){
        return
    }

    Gosub Clicker
Return



Clicker:

    vCount := 0
    if(!ClickForever){
        GuiControl,,% Submit, % ClickerToggle ? "Stop [F1]" : "Start [F1]"
        While(ClickerToggle && Amount > vCount){
            MouseClick, % WhichBTN, % xPos, % yPos, , 0
            vCount++
            vSleep := (TimeUnit = 1) ? Interval * 1000 : Interval
            Sleep % vSleep + random(0,AddRandom)
        }

        ClickerToggle := !ClickerToggle
        GuiControl,,% Submit, % ClickerToggle ? "Stop [F1]" : "Start [F1]"
        
    } else {
    
        while(ClickerToggle){ 
            MouseClick, % WhichBTN, % xPos, % yPos, , 0
            vSleep := (TimeUnit = 1) ? Interval * 1000 : Interval
            Sleep % vSleep + random(0,AddRandom)
        }
        ;ClickerToggle := !ClickerToggle
        GuiControl,,% Submit, % ClickerToggle ? "Stop [F1]" : "Start [F1]"
    }
    
Return

fn_Clickforever:
Gui Submit, NoHide
if (ClickForever){
    GUIControl,Disable, Amount
    GuiControl, MoveDraw, Range ;for some reason it won't redraw like Edit
} else {
    GUIControl,Enable, Amount
    GuiControl, MoveDraw, Range
}
return

GetPos:
    SetTimer, Tooltip, 10
    KeyWait, Ctrl, D	
    MouseGetPos, xPos, yPos 
    Gui, Show
    GuiControl, , xPos, % xPos
    GuiControl, , yPos, % yPos
    SetTimer, Tooltip, OFF
    ToolTip
Return

Tooltip:
    ToolTip,Move your cursor to the position you want to set `nand then press " ctrl " `n(The control key on your keyboard)
Return

AlwaysOnTop:
    Gui Submit, NoHide
	if(State=1)
		Gui,+Alwaysontop
	else
		Gui,-AlwaysOnTop
	return	

random(min, max) {
    random, out, % min, % max
    return out
}


;----------GUI SPECIFIC LABELS----------

GuiEscape:
GuiClose:
    ExitApp
Return
