;Author: Arekusei
;Version 0.1

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, Force ;15:17 2018.07.28. updated: 13:23 2020.02.13.

SetWorkingDir %A_ScriptDir%
SetBatchLines -1
ListLines Off

;cBackground := "c" . "1D1A1F", cForeground := "c" . "F5DA42"
;cBackground := "c" . "F5DA42", cForeground := "c" . "1D1A1F"
cBackground := "c" . "F5DA42", cForeground := "c" . "1C1C1A"

Global AdjTime := 0
Tick := A_TickCount
 ;Timer GUI
Gui, +LastFound ; Added
Gui, +ToolWindow +AlwaysOnTop -Theme -Caption +Border
;Gui, +E0x02000000  +E0x00080000
Gui, Font, S15 CDefault Bold, Verdana
;Gui, Color, 10898d
Gui, Color, %cForeground%
Gui, Add  , Text ,  x11 y6 w150 h25  gWM_LBUTTONDOWN vDisplay %cBackground%, 00:00:00.000
Gui, Font, s14 ,Webdings 


Gui, Add  , Text , x265 y6  w25 h25 %cBackground% gAppExit , r ;exit	

Gui, Add  , Text , x170 y7 w25 h25 %cBackground% vStartStop gStart, 4 ;start ►	
Gui, Add  , Text , xp+25 yp  w25 h25 %cBackground% vReset gReset , < ;reset ■
Gui, Add  , Text , xp+25 yp  w25 h25 %cBackground% vMinimize gMinimize, 5 ;Minimize
Gui, Add  , Text , xp+20 yp  w20 h25 %cBackground% vSplit gSplit, | ;Split


Gui, Font, S8 CDefault , Verdana

Gui Add, ListView, x8 y37 w283 h154 AltSubmit  hWndhlv vLV1  , Split ;+Background0xf5da42
LV_ModifyCol(1, 200)

Gui Add, Text,  x5 y5 w289 h30 +0x201 +Border BackGroundTrans 

Gui Add, Text,  x5 y34 w289 h160 +0x201 +Border BackGroundTrans vText1 ;gMoveWin



Gui, Show , h200 w300, Timer

;OnMessage(0x201, "WM_LBUTTONDOWN") ;to move gui
return



WM_LBUTTONDOWN()  {
   ;PostMessage, WM_NCLBUTTONDOWN := 0xA1, HTCAPTION := 2 
   PostMessage, 0xA1, 2
}

Split(){

    Gui, Submit, NoHide
    GuiControlGet, Display
    LV_Add("", Display)
    LV_Modify(LV_GetCount(), "Vis")
   ; sendmessage, 0x115, 7, 0,, ahk_id %hlv%
    
}

~#!LButton::
;MouseGetPos,,,, curCon, 1
;MsgBox % curCon

MouseGetPos,,, X, Y
ControlGetText, OUT , %Y%, ahk_id %X%
;Msgbox, The window says, "%OUT%"

;MouseGetPos, , , HWIN, HCTRL, 2
;GuiControlGet, VarName, %HWIN%:Name, %HCTRL%
;ToolTip % OUT
    ;mouseGetPos,,,, HoverControl
    ;ToolTip % hovercontrol
    ; If (InStr(OUT, "5"))
    If (OUT = "5" || OUT = "6")
    {
       ;SetTimer, Minimize, -1
        Minimize()
       ;ToolTip % OUT
       ;PrevControl := CurrControl
       GuiControl,+Redraw, % OUT
    }    
return


Minimize(){
 
    Global toggle
	;MsgBox Minimize

    ;WinGetPos XN, YN, , , A
        if (Toggle)
        {
        toggle:=!toggle
        GuiControl Show, Text1
        GuiControl Show, LV1
        GuiControl ,, Minimize, 5
        Gui Show, % " h200"  "NA"  , Selection

        
        Return
      }

        toggle:=!toggle
        GuiControl Hide, Text1
        GuiControl Hide, LV1
        GuiControl ,, Minimize, 6   
        Gui Show, % " h40"  "NA"  , Selection
        

}
Return

Start:
    GuiControlGet, StartStop
  
    If (StartStop = "4" or StartStop = ""){
    
        GuiControl, , StartStop,;   ;Webdings char
        ST := A_TickCount ; Start Time
        SetTimer, StopWatch, 10

    } else {

        SetTimer, StopWatch, Off  
        AdjTime := ((A_TickCount - ST) + AdjTime)
        GuiControl, , StartStop, 4  ;Webdings char
    }

Return

Stop:
Reset:
    	GuiControlGet, Reset

    	if (Reset = "<")
    	{
    		SetTimer, StopWatch, Off  
            GuiControl, , StartStop, 4  ;Webdings char
            GuiControl, , Display, 00:00:00.000
            AdjTime := 0
            LV_Delete()
    	}
    Return
	
	
Display:
    GuiControlGet, Display
    Clipboard := Display

    ;ControlGetText , Clipboard , Static1
    MsgBox, 262192, Time Copied to Clipboard, Copied to Clipboard: %Clipboard%, 2
    Exit

 

ToDigital(currentTime) {
    ms := Mod(currentTime, 1000)
    s  := Mod(Floor(currentTime / 1000), 60)
    m  := Mod(Floor(currentTime / (1000 * 60)), 60)
    h  := Floor(currentTime / (1000 * 60 * 60))
    return Format("{:02d}:{:02d}:{:02d}.{:03d}", h, m, s, ms)
}
    

; StopWatch:

        ; GuiControl, -Redraw, Display
        ; GuiControl, , Display, % ToDigital((A_TickCount - ST) + AdjTime) 
        ; GuiControl, +Redraw, Display
; Return


StopWatch:
	td := ToDigital((A_TickCount - ST) + AdjTime)
	If (A_TickCount - Tick > 60)
	{
		Tick := A_TickCount
		GuiControl, , Display, % td
	}
Return
    
AppExit:
ExitApp 

