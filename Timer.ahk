;Author: Arekusei

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, Force 

SetWorkingDir %A_ScriptDir%
SetBatchLines -1
ListLines Off

cBackground := "c" . "F5DA42", cForeground := "c" . "1C1C1A"
;cBackground := "c" . "1D1A1F", cForeground := "c" . "F5DA42"
;cBackground := "c" . "F5DA42", cForeground := "c" . "1D1A1F"
;cBackground := "c" . "F5DA21", cForeground := "c" . "0E5034"
;cBackground := "c" . "551300", cForeground := "c" . "FF9900"
;cBackground := "c" . "FFFF00", cForeground := "c" . "003366" ;blue yellow
;cBackground := "c" . "EEDD22", cForeground := "c" . "111111" ;dark
;cBackground := "c" . "FFCC66", cForeground := "c" . "333333" ;dark n golden
;cBackground := "c" . "22BB22", cForeground := "c" . "111111" ;dark n green
;cBackground := "c" . "AACCFF", cForeground := "c" . "222233" ;bluish

Global AdjTime := 0
Global WinTitle := "Timer By Arekusei"
Tick := A_TickCount

Menu, Tray, Add, Show/Hide, Menu_ShowHide ;RestoreTray
Menu, Tray, Add, Exit, Appexit
Menu, Tray, Default, Show/Hide
;Menu, Tray, Icon, shell32.dll,266
Menu, Tray, Click, 1 ;opens on single click

hICON := Base64toHICON()               ; Create a HICON
Menu, Tray, Icon, HICON:*%hICON%       ; AHK makes a copy of HICON when * is used
Menu, Tray, Icon
DllCall( "DestroyIcon", "Ptr",hICON )  ; Destroy original HICON

 ;Timer GUI
;Gui, +LastFound
;Gui, Color,, %cForeground% ;0xAACCFF ;0x80BF7D
;Gui, Color,red , ;0x111111 ;0xAACCFF ;0x80BF7D

Gui, Color,, %cForeground% 
Gui, Font, %cBackground%

Gui, +AlwaysOnTop -Caption +Border
Gui, Margin, 5 5
;Gui, +E0x02000000  +E0x00080000

;Gui, Add  , Text , xp+25 yp  w25 h25 %cBackground% vReset gReset , < ;reset ■
;Gui, Add  , Text , xp+25 yp  w25 h25 %cBackground% vMinimize gMinimize, 5 ;Minimize
;Gui, Add  , Text , xp+20 yp  w20 h25 %cBackground% vSplit gSplit, | ;Split
Gui, Font, S8, Verdana

Gui, Add, Text, x+8 y8 h20  %cBackground%, Hours
Gui, Add, Text, x+30 yp h20  %cBackground%, Minutes
Gui, Add, Text, x+16 yp h20  %cBackground%, Seconds
;Gui, Add, Text, x+5 y10 h20 Center %cBackground%, H:M:S
;Gui, Add, Text, x+17 yp w33 h20 %cBackground% gStart, Start


Gui, Font, S8, Verdana
Gui, Color, %cForeground%

Gui, Add, Edit, xs y+-2 w58 h20  number right
Gui, Add, UpDown, va1  Range0-59 wrap, 0
Gui, Add, Edit, x+2 yp wp h20  number right
Gui, Add, UpDown, va2  Range0-59 wrap, 15
Gui, Add, Edit, x+2 yp wp h20  number right
Gui, Add, UpDown, va3  Range0-59 wrap, 0
;Gui, Add, Button, xs y+3  h20 , Remember


Gui, Font, S15 Bold, Verdana
Gui, Color, %cForeground%


Gui, Add , Text ,  xs+0 y+0 gWM_LBUTTONDOWN vDisplay %cBackground%, 00:00:00

Gui, Font, s12, Webdings 
;Gui, Add  , Text , x+50 yp-6 w25 h25 %cBackground% vStartStop gStart, 4 ;start ►


;Gui, Add, Progress, x+5 yp+5 w17 h17 Disabled Background646464 c222222 , 100
Gui, Add, Picture, x+5 yp+5 w17 h17 border gStart, ;ui/blank.png
Gui, Add, Text , xp yp-1 w17 h17 BackgroundTrans %cBackground% vStartStop , 4 ;start ►

;Gui, Add, Progress, x+2 yp+1 w17 h17 Disabled Background646464 c222222 , 100
Gui, Add, Picture, x+2 yp+1 w17 h17 border gReset, ;ui/blank.png
Gui, Add, Text , xp yp-2 w17 h17 BackgroundTrans %cBackground% , < ;reset ■

;Gui, Add, Progress, x+2 yp+2 w17 h17 Disabled Background646464 c222222 , 100
Gui, Add, Picture, x+2 yp+2 w17 h17 border gMinimize, ;ui/blank.png
Gui, Add, Text , xp yp w17 h17 center BackgroundTrans %cBackground%  vMinimize , 6 ;Minimize

;Gui, Add, Progress, x+2 yp  w17 h17 Disabled Background646464 c222222, 100
Gui, Add, Picture, x+2 yp  w18 h17 border gAppExit, ;ui/blank.png
Gui, Add, Text , xp yp-2 w17 h17 BackgroundTrans %cBackground% , r ;exit

;Gui, Add  , Text , x+5 yp w25 h25 %cBackground% vStartStop gStart, 4 ;start ►	
;Gui, Add  , Text , x+0 yp w25 h25 %cBackground% gAppExit , r ;exit	

Gui, Font, S8 CDefault Normal , Verdana


Gui Add, Text,  x5 y5 w195 h69 +0x201 +Border BackGroundTrans vText1 ;gMoveWin



Gui, Show , h79 , % WinTitle

OnMessage(0x201, "WM_LBUTTONDOWN") ;to move gui
return

GuiSize:
  if (A_EventInfo = 1)
    WinHide
  return
  
Minimize:
WinMinimize
return

Reset:
    SetTimer, Stopwatch, Off
    GuiControl, , Display, 00:00:00
    GuiControl, , Display2, 00:00:00
return



~Space::
If WinActive("Timer")
    Gosub Start
return

~r::
If WinActive("Timer")
    Gosub Reset
return

Start:
    Gui, Submit, Nohide
    Gosub Minimize ;remove if not necessary 
    ST := A_TickCount
    Time := (a1*3600)+(a2*60)+a3
    GuiControl, , Display, % ToDigital(Time*1000)
    ET := ST + (Time * 1000)
    SetTimer, Stopwatch, 1000
return

StopWatch:
ToolTip % Display
;GuiControl, , Display, % ToDigital(A_TickCount - ST)    ;Time count up
GuiControl, , Display, % ToDigital(ET - (A_TickCount)) ;Time count down
trayTime:= ToDigital(ET - (A_TickCount))
Menu, Tray,Tip , Time in: %trayTime%

if (A_TickCount >= ET){
    SetTimer, Stopwatch, Off
    GuiControl, , Display, 00:00:00
    ;GuiControl, , Display2, 00:00:00
    ;MsgBox, 262144, Times up!, Done
    Menu_ShowHide()
}

Return


ToDigital(currentTime) {
    s  := Mod(Floor(currentTime / 1000), 60)
    m  := Mod(Floor(currentTime / (1000 * 60)), 60)
    h  := Floor(currentTime / (1000 * 60 * 60))
    return Format("{:02d}:{:02d}:{:02d}", h, m, s)
}

WM_LBUTTONDOWN()  {
   PostMessage, 0xA1, 2
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

}

Base64toHICON() { ; 16x16 PNG image (236 bytes), requires WIN Vista and later
Local B64 :="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAJlJREFUOE9jrK+v/89AAWAEGTBv/nyyjEhKTGSAG8DFxUWyIRHh4dgNOLZYFqthBsE3GZAtwmsASDEyuLBWnYG+Bixc9xTFBfFB0sS7AKQTFA4wQ7BpBqnBGQYwq2GBie53mDxeA0CaYQEJC0CQRvrGQmE0D0P/0i9gF5McjcixADKEZAOwJUWiE9K3b99w5gusgUhyLkLSAACXaZPRYxHm7QAAAABJRU5ErkJggg==",  Bin, Blen, nBytes:=300, hICON:=0                     
  
  VarSetCapacity( Bin,nBytes,0 ), BLen := StrLen(B64)
  If DllCall( "Crypt32.dll\CryptStringToBinary", "Str",B64, "UInt",BLen, "UInt",0x1
            , "Ptr",&Bin, "UIntP",nBytes, "Int",0, "Int",0 )
     hICON := DllCall( "CreateIconFromResourceEx", "Ptr",&Bin, "UInt",nBytes, "Int",True
                     , "UInt",0x30000, "Int",16, "Int",16, "UInt",0, "UPtr" )            
Return hICON
}

AppExit:
GuiEscape:
GuiClose:
    ExitApp
