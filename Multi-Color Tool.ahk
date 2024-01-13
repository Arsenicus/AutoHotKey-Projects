
;Author: Arekusei
;and AHK community
;Color Tool v0.1

#SingleInstance Force
SetBatchLines, -1


hICON := Base64toHICON()               ; Create a HICON
Menu, Tray, Icon, HICON:*%hICON%       ; AHK makes a copy of HICON when * is used
Menu, Tray, Icon
DllCall( "DestroyIcon", "Ptr",hICON )  ; Destroy original HICON

Global BarSelect := 2
Global WinTitle := "Multi-Color Tool"

Menu, Tray, Add, Show/Hide, Menu_ShowHide ;RestoreTray
;Menu, Tray, Add, Exit, ExitApp
Menu, Tray, Default, Show/Hide
Menu, Tray, Click, 1 ;opens on single click
Menu, Tray, Tip , % WinTitle

Gui, Font, s8, Verdana
Gui, +AlwaysOnTop

Gui, Add, Edit, h130 w170 vEdit1

Gui, Add, Progress, x+5 yp w50 h50 BackgroundBlack vBar , 100

Gui, Add, Progress, xp y+3 w23 h23      BackgroundBlack cWhite vBar2 , 100
Gui, Add, Progress, x+4 yp w23 h23      BackgroundBlack cWhite vBar3 , 100
Gui, Add, Progress, x185 y+3 w23 h23    BackgroundBlack cWhite vBar4 , 100
Gui, Add, Progress, x+4 yp w23 h23      BackgroundBlack cWhite vBar5 , 100

Gui, Add, Button, x184 y+3 w52 gClear, Clear

Gui, Add, Text, xm, CTRL + Click to select color
Gui, Add, Text, xm, CTRL + Shift + Click Select color w/o tiles
Gui, Add, Text, xm, Alt + Drag Mouse to select coordinates 

Gui, Add, Radio, xp y+0 Checked h23 vHex, Hex
Gui, Add, Radio, x+0 yp  h23 vRGB, RGB

Gui, Add, Text, xm, Coordinates mode:

Gui, Add, Radio, xm y+0 h23 Checked vCtrlMode, Screen
Gui, Add, Radio, x+0 yp h23          , Window
Gui, Add, Radio, x+0 yp h23          , Client


Gui, Show,, % WinTitle
SetTimer, GetColor, 50, ON
Return

GetColor:
	MouseGetPos, MouseX, MouseY, MouseWin
	PixelGetColor, Color, % MouseX, % MouseY, RGB
	GuiControl, % "+c" SubStr(Color, 3) , Bar
    
Return

q::
Gui Submit, NoHide
;GuiControlGet, CtrlMode
MsgBox % CtrlMode
return

^LButton::
^+LButton::
    Gui Submit, NoHide
    MouseGetPos, MouseX, MouseY, MouseWin
    PixelGetColor, Color, % MouseX, % MouseY, RGB
    
    KeyIsDown := GetKeyState("LShift" , "P")
    if (!KeyIsDown){
        GuiControl, % "+c" SubStr(Color, 3) , Bar%BarSelect%
        BarSelect++
        BarSelect := BarSelect > 5 ? 2 : BarSelect
    }
    Clipboard := Color
    Color := IsChecked("Hex") ? Color : hexToRgb(Color) 
    Contents:=  Color "`n" Edit1
    GuiControl,,  Edit1, % Contents
    Tooltip("Copied!", 555)

Return


Tooltip(text, time){
    ToolTip
	ToolTip % text
	SetTimer, TP, -%time%
	return
	TP:
	ToolTip
	Return
}

clear:
GuiControl,, Edit1
Return


GuiClose:
;GuiEscape:
	ExitApp
Return




IsChecked(control) {
		GuiControlGet, chk,, % control
	return chk ? chk : false
}


marker(X:=0, Y:=0, W:=0, H:=0)
{
T:=3, ; Thickness of the Border
w2:=W-T,
h2:=H-T

Gui marker: +LastFound +AlwaysOnTop -Caption +ToolWindow +E0x08000000 +E0x80020
Gui marker: Color, Red ;Color
Gui marker: Show, w%W% h%H% x%X% y%Y% NA

WinSet, Transparent, 150
WinSet, Region, 0-0 %W%-0 %W%-%H% 0-%H% 0-0 %T%-%T% %w2%-%T% %w2%-%h2% %T%-%h2% %T%-%T%
Return  
}


!LButton::
    Gui Submit, NoHide
    modes := {1:"Screen", 2:"Window", 3:"Client"}
    CoordMode, Mouse, % modes[CtrlMode]
    
    if (CtrlMode == 1){
        XN := 0, YN := 0
    } else {
        WinGetPos XN, YN, , , A
    }
    
    MouseGetPos x1, y1
    x1+=XN, y1+=YN
    While GetKeyState("LButton","P") {
       MouseGetPos x2, y2
       x2+=XN, y2+=YN
       x:= (x1<x2)?(x1):(x2)    ;x-coordinate of the top left corner
       y:= (y1<y2)?(y1):(y2)    ;y-coordinate of the top left corner
       
       w:= Abs(x2-x1), h:= Abs(y2-y1)
       ToolTip % "Coords " x - xn "," y - yn "  Dim " w "x" h
       
       marker(x, y, w, h)

    }
    Gui Submit, NoHide
    output := x - xn ", " y - yn ", " x - xn + w ", " y - yn + h
    ;GuiControlGet , Edit1
    Contents:=  output "`n" Edit1
    GuiControl,, Edit1, % Contents
    clipboard := % x - xn ", " y - yn ", " x - xn + w ", " y - yn + h
    
    ToolTip
Return

~RButton::
~Esc::
Gui, marker: Destroy
Return


;MsgBox, % "Example:`n`n" . rgbToHex("255,255,255") . "`n" . HexToRgb("#FFFFFF") . "`n" . CheckHexC("000000")

rgbToHex(s, d = "") {
   StringSplit, s, s, % d = "" ? "," : d
   SetFormat, Integer, % (f := A_FormatInteger) = "D" ? "H" : f
   h := s1 + 0 . s2 + 0 . s3 + 0
   SetFormat, Integer, %f%
   Return, "#" . RegExReplace(RegExReplace(h, "0x(.)(?=$|0x)", "0$1"), "0x")
}

hexToRgb(s, d = "") {
   SetFormat, Integer, % (f := A_FormatInteger) = "H" ? "D" : f
   Loop, % StrLen(s := RegExReplace(s, "^(?:0x|#)")) // 2
      c%A_Index% := 0 + (h := "0x" . SubStr(s, A_Index * 2 - 1, 2))
   SetFormat, Integer, %f%
   Return, c1 . (d := d = "" ? "," : d) . c2 . d . c3
}

CheckHexC(s, d = "") {
   If InStr(s, (d := d = "" ? "," : d))
      e := hexToRgb(rgbToHex(s, d), d) = s
   Else e := rgbToHex(hexToRgb(s)) = (InStr(s, "#") ? "" : "#"
      . RegExReplace(s, "^0x"))
   Return, e
}


;Minimize:
GuiSize:
  if (A_EventInfo = 1)
    ;WinHide
    Menu_ShowHide()
  return


Menu_ShowHide(){

    WinGet, winStyle, Style, %WinTitle%
    if (winStyle & 0x10000000)
    {
        WinHide, %WinTitle%
        SetTimer, GetColor, Off
    }
    else
    {
        WinShow, %WinTitle%
        WinActivate , %WinTitle%
        WinSet, AlwaysOnTop, Toggle, %WinTitle%
        WinSet, AlwaysOnTop, Toggle, %WinTitle%
        SetTimer, GetColor, 50, On
    }

}

Base64toHICON() { ; 16x16 PNG image (236 bytes), requires WIN Vista and later
Local B64 :="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAKZJREFUOE9jVNfQ+M9AAWAEGRARHk6WEStWrmSAGwDikAJAltLGgDO+vmCHNKXIgGnVg/5g2tUVElQenp5gGqcLKDbgoJoa2Ia0VGEwLbklAUxLSOwD07CwwukCig3Y+h/iV+80TjDNs6wITL95UwumOTgh4jhdQLEBq27cANugnw6mGBhmNkMZEBcAEx5+F1BsANQ6ghT1UyJBK7EogOcFcjTD9AAAkDaVcYRdgu0AAAAASUVORK5CYII=",  Bin, Blen, nBytes:=356, hICON:=0                     
  
  VarSetCapacity( Bin,nBytes,0 ), BLen := StrLen(B64)
  If DllCall( "Crypt32.dll\CryptStringToBinary", "Str",B64, "UInt",BLen, "UInt",0x1
            , "Ptr",&Bin, "UIntP",nBytes, "Int",0, "Int",0 )
     hICON := DllCall( "CreateIconFromResourceEx", "Ptr",&Bin, "UInt",nBytes, "Int",True
                     , "UInt",0x30000, "Int",16, "Int",16, "UInt",0, "UPtr" )            
Return hICON
}
