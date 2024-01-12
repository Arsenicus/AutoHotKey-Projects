;Author: Arekusei
;Version 0.2
;2018.07.28. updated: 12.01.2024

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#SingleInstance, Force 

SetWorkingDir %A_ScriptDir%
SetBatchLines -1
ListLines Off

;cBackground := "c" . "1D1A1F", cForeground := "c" . "F5DA42"
;cBackground := "c" . "F5DA42", cForeground := "c" . "1D1A1F"
cBackground := "c" . "F5DA42", cForeground := "c" . "1C1C1A"

Global AdjTime := 0
Global WinTitle := "StopWatch By Arekusei"
Tick := A_TickCount

hICON := Base64toHICON()               ; Create a HICON
Menu, Tray, Icon, HICON:*%hICON%       ; AHK makes a copy of HICON when * is used
Menu, Tray, Icon
DllCall( "DestroyIcon", "Ptr",hICON )  ; Destroy original HICON

Menu, Tray, Add, Show/Hide, Menu_ShowHide ;RestoreTray
Menu, Tray, Add, Exit, ExitApp
Menu, Tray, Default, Show/Hide
Menu, Tray, Click, 1 ;opens on single click
;Menu, Tray, Icon, shell32.dll,266
Menu, Tray, Tip , % WinTitle

 ;StopWatch GUI
Gui, +LastFound ; Added
Gui, +ToolWindow +AlwaysOnTop -Theme -Caption +Border
Gui, Font, S15 CDefault Bold, Verdana
Gui, Color, %cForeground%
Gui, Add  , Text ,  x11 y6 w150 h25  gWM_LBUTTONDOWN vDisplay %cBackground%, 00:00:00.000
Gui, Font, s14 ,Webdings 


Gui, Add  , Text , x+5 y7 w25 h25 %cBackground% vStartStop gStart, 4 ;start ►	
Gui, Add  , Text , xp+25 yp  w25 h25 %cBackground% vReset gReset , < ;reset ■
Gui, Add  , Text , xp+25 yp  w25 h25 %cBackground% vMinimize gMenu_ShowHide, 6 ;Minimize
Gui, Add  , Text , xp+25 yp    w25 h25 %cBackground% gExitApp , r ;exit	


Gui, Font, S8 CDefault , Verdana
Gui Add, Text,  x5 y5 w265 h30 +0x201 +Border BackGroundTrans 


Gui, Show , h40 w275, % WinTitle
OnMessage(0x0205, "WM_RBUTTONUP") 
;OnMessage(0x201, "WM_LBUTTONDOWN") ;to move gui
return



WM_LBUTTONDOWN()  {
   ;PostMessage, WM_NCLBUTTONDOWN := 0xA1, HTCAPTION := 2 
   PostMessage, 0xA1, 2
}
WM_RBUTTONUP()  {
   ;PostMessage, WM_NCLBUTTONDOWN := 0xA1, HTCAPTION := 2 
   Menu_ShowHide()
}

Menu_ShowHide(){

    WinGet, winStyle, Style, %WinTitle%
    if (winStyle & 0x10000000)
    {
        WinHide, %WinTitle%
    }
    else
    {
        WinShow, %WinTitle%
        WinActivate , %WinTitle%
        WinSet, AlwaysOnTop, Toggle, %WinTitle%
        WinSet, AlwaysOnTop, Toggle, %WinTitle%
    }
    ;ToolTip
}



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


Base64toHICON() { ; 16x16 PNG image (236 bytes), requires WIN Vista and later
Local B64 :="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAIVJREFUOE9jVNfQ+M9AAWAEGRARHk6WEStWrmSAGwDikAJAluI14NhiWRTzrGIfo/AJGgBSnR7IBNY0c/0/DMfhNQDddphuZFfgNACkGd25MAOQ5YgyAN0w+htweCYbAzOXONgHIG+R7AL0oKePASBbKYpGYpMzRjQSqxFZHTwvkKMZpgcAs2OecXLJ7n0AAAAASUVORK5CYII=",  Bin, Blen, nBytes:=356, hICON:=0                     
  
  VarSetCapacity( Bin,nBytes,0 ), BLen := StrLen(B64)
  If DllCall( "Crypt32.dll\CryptStringToBinary", "Str",B64, "UInt",BLen, "UInt",0x1
            , "Ptr",&Bin, "UIntP",nBytes, "Int",0, "Int",0 )
     hICON := DllCall( "CreateIconFromResourceEx", "Ptr",&Bin, "UInt",nBytes, "Int",True
                     , "UInt",0x30000, "Int",16, "Int",16, "UInt",0, "UPtr" )            
Return hICON
}

ExitApp:
GuiClose:
    ExitApp
