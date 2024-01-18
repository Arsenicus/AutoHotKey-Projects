; Digital clock made out of segments using progress bar LOL
; Author: Arekusei

#NoEnv
#NoTrayIcon
SetBatchLines,-1

global WinTitle := "Digital Clock"
Menu, SectionMenu, Add, ❌ | Exit`tDel, Exit

;Menu, Tray, DeleteAll
Menu, Tray, NoStandard
Menu, Tray, Add, Show/Hide, Menu_ShowHide
Menu, Tray, Add,
Menu, Tray, Add, Exit, Exit
Menu, Tray, Default, Show/Hide
Menu, Tray, Click, 1 ;opens on single click
Menu, Tray, Tip , % WinTitle

Menu, Tray, UseErrorLevel
hICON := Base64toHICON()               ; Create a HICON
Menu, Tray, Icon, HICON:*%hICON%       ; AHK makes a copy of HICON when * is used
Menu, Tray, Icon
DllCall( "DestroyIcon", "Ptr",hICON )  ; Destroy original HICON
ST:= A_TickCount

global width:= 27, height:= 5
global map:=
(Join
"1,1,1,0,1,1,1,0,0,0,1,1,1,0,1,1,1,0,0,0,1,1,1,0,1,1,1
,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1
,1,0,1,0,1,0,1,0,0,0,1,0,1,0,1,0,1,0,0,0,1,0,1,0,1,0,1
,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1
,1,1,1,0,1,1,1,0,0,0,1,1,1,0,1,1,1,0,0,0,1,1,1,0,1,1,1"
)
map := StrSplit(map, ",")

digit0:= [2,2,2, 2,1,2, 2,1,2, 2,1,2, 2,2,2] ;0
digit1:= [1,1,2, 1,1,2, 1,1,2, 1,1,2, 1,1,2] ;1
digit2:= [2,2,2, 1,1,2, 2,2,2, 2,1,1, 2,2,2] ;2
digit3:= [2,2,2, 1,1,2, 2,2,2, 1,1,2, 2,2,2] ;3
digit4:= [2,1,2, 2,1,2, 2,2,2, 1,1,2, 1,1,2] ;4
digit5:= [2,2,2, 2,1,1, 2,2,2, 1,1,2, 2,2,2] ;5
digit6:= [2,2,2, 2,1,1, 2,2,2, 2,1,2, 2,2,2] ;6
digit7:= [2,2,2, 1,1,2, 1,1,2, 1,1,2, 1,1,2] ;7
digit8:= [2,2,2, 2,1,2, 2,2,2, 2,1,2, 2,2,2] ;8
digit9:= [2,2,2, 2,1,2, 2,2,2, 1,1,2, 2,2,2] ;9
; arrays start from 1 in ahk ---------------

;loop % width * height
    ;map.push(0)

global mrg:= 6 ;margin
global size := 8 ;tile size

Gui,Margin, %mrg% , %mrg%

num:= []

global tilecolors:= ["c272828","c4E9D9D"]
;global tilecolors:= ["cAE81FF","cF92672"]
;global tilecolors:= ["cBB1818","cF8F96B"]
;global tilecolors:= ["c2D1A1B", "c604141"]

cback := tilecolors[1]

Loop % width * height
{
	n:=A_Index -1
    
	x := (Mod(n, width) * size) +mrg
	y := (n // width * size) + mrg
    
    ;get position without margin
	;xpos:= Floor((Mod(n, width) * size) / size)
	;ypos:= Floor((n // width * size) / size)
    xpos:= Floor((x-mrg) / size)
	ypos:= Floor((y-mrg) / size)
    
	arrPos:= (ypos) * (width) + xpos 
    ;msgbox % xpos "`n" ypos "`n" arrpos
	;color := tilecolors[map[arrpos+1]+1]

    color := tilecolors[map[arrpos+1]+1]
    ;msgbox % color
	Gui, Add,Progress, x%x% y%y% w%size% h%size% Disabled -Smooth vBAR%n% Background%color%
    ;Gui, Add, Picture, x%x%  y%y% w%size% h%size%   vBAR%n% Background%color%,
    
	
}
;Gui Add, Text,  x1 y1 w157 h58 0x7 BackGroundTrans gWM_LBUTTONDOWN
Gosub firstcheck
SetTimer, Check, 100
OnMessage(0x201, "WM_LBUTTONDOWN") ;to move gui

Gui, Color, % cback ;0x272828 ;0x33BBA5
gui, +AlwaysOnTop  -Caption  +ToolWindow +border ;+Resize
Gui,Show, , % WinTitle


;sub menu / context menu
Gui menu:Default
Gui, +AlwaysOnTop -Caption +Border +ToolWindow
Gui, Color, 22262a
;Gui, Font, s8 Bold, Segoe UI
Gui, Font, s10  Bold, Segoe UI
Gui, Margin, 2, 2



addBtn("Minimize")
addBtn("Exit","F8F96B","BB1818")
Return

addBtn(text:="btn", cText:="4E9D9D", cBack:="272828", w:= 100, h:=20, pos:= "xm+0", menu:= "menu"){
    Global
    Static count:= 0
    count++
    Gui %menu%:Default
    Gui, Add,Progress, % pos "   w" w " h" h " Disabled Background" cback
    Gui, Add  , Text , % " xp yp w" w " h" h " border Center BackgroundTrans glaunch c" cText " vbtn" count , % text 
    launch := Func("launch").Bind(text)
    GuiControl,+G, btn%count%, %launch%
}


RunIt:
	MouseGetPos,,,, ctrl, 2
    ;MsgBox test ;% ctrl
	try{
		;ToolTip, % ControlHandles[ ctrl ].RunPath
        gosub % ControlHandles[ ctrl ].RunPath
        ;ControlHandles[ ctrl ].RunPath
	}catch{
		;MsgBox, ERROR
	}
	Gui, menu:Hide
	return
    
launch(arg){
    ;ToolTip % A_GuiControl "`n" arg
    ;return
    Gui, menu:Hide ;hide before action or it will look delayed
    try{
        Gosub % arg
    } catch {
        ;ToolTip some problem occured
    }
    
}

GuiContextMenu:  ; Launched in response to a right-click or press of the Apps key.
;ToolTip % A_EventInfo ;A_GuiControl ;wot ze fok
    ;Menu, SectionMenu, Show , %A_GuiX%, %A_GuiY%
    CoordMode, Mouse, Screen
	MouseGetPos, x , y
	Gui, menu:Show, % "x" x - 1 " y" y - 1, subMenu 
    return

~*LButton::
~*RButton::
if (!MouseIsOver("subMenu")){
        Gui menu:Hide
    ;ToolTip
}
return


MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return !!WinExist(WinTitle . " ahk_id " . Win)
}

;Menu_ShowHide(){
Minimize:
Menu_ShowHide:
    
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
    ToolTip
;}
return

;#If MouseIsOver(WinTitle)
;#if



getpos(){
    while (GetKeyState("Lbutton", "P")){
        CoordMode Mouse , Client
        MouseGetPos x,y
        xpos:= Floor((x-10) / 16) 
        ypos:= Floor((y-10) / 16) 
        arrPos:=  (ypos) * 27 + (xpos)

        ToolTip % (ypos*width)+xpos+1
        MouseGetPos, , , HWIN, HCTRL, 2
        GuiControlGet, VarName, %HWIN%:Name, %HCTRL%
    ;ToolTip % VarName

        if (InStr(VarName, "clr"))
            selectedColor:= SubStr(VarName, 4)
        ;ToolTip % "X: " x " Y: " y " Tile: " (ypos*width)+xpos+1 " `nXpos: " xpos " Ypos: " ypos "`nS " selectedColor " COLORS: " tilecolors[selectedColor+1] , -30, -30
        map[arrpos+1]:= selectedColor
    ;GuiControl, % "+Backgroundc" SubStr("0xFF0000", 3) , % VarName
        GuiControl, % "+Background" tilecolors[selectedColor+1] , % VarName
    ;GuiControl,+Redraw, % VarName	
        sleep 20
    }
    
}
return

;q::


check:
;quick fix for performance reasons lol
if ((ST+1000) > A_TickCount) {
    return
} else {
    ST:= A_TickCount
}
firstcheck:
;if (num = 10)
hours:= StrSplit(A_Hour)
mins:= StrSplit(A_Min)
secs:= StrSplit(A_Sec)
num:= secs.2
digit := digit%num%
;Random clr, 1,6

sectors := {0:hours.1, 4:hours.2, 10:mins.1, 14:mins.2 , 20:secs.1, 24:secs.2}

for sk, sv in sectors{
        ;MsgBox % sk "`n" sv
        digit:= digit%sv% ;select digit
    for k,v in digit{
        ;msgbox % k "`n" v
        ;msgbox % s
        i := (Floor((k-1)/3) * 27) + sk + mod(k-1,3) 

        GuiControl, % "+Background" tilecolors[digit[k]] , BAR%i% ;VarName
    }
}
;sleep 100
return

WM_LBUTTONDOWN()  {
    ;PostMessage, WM_NCLBUTTONDOWN := 0xA1, HTCAPTION := 2 
    SetTimer Check, off ;need to avoid conflic from timer
    PostMessage, 0xA1, 2
    While(GetKeyState("LButton")){
        sleep 100
    }
    SetTimer Check, 100
}
Move_Window:
	PostMessage,0xA1,2
	While(GetKeyState("LButton"))
		sleep 10
return

; Ask for help topic: https://autohotkey.com/boards/viewtopic.php?t=36640
Base64toHICON() { ; 16x16 PNG image (236 bytes), requires WIN Vista and later
Local B64 :="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAI1JREFUOE9j9Js79z8DBYARZMD5xkayjDCsr2eAG8DFxUWyIeqlpdgNAElgAyCXIluE1wB0b4GcS18DPj56hOILfjk54l0A0gnyH8wQbJphavDGAiww0f0OcxrOQISZDgtIWACCxOkbC0qJiQz35s8Hu5jkaESOBZAhJBtAUUr89u0bznyBNRBJzkVIGgC2WJSBjuiNYgAAAABJRU5ErkJggg==",  Bin, Blen, nBytes:=236, hICON:=0                     
  
  VarSetCapacity( Bin,nBytes,0 ), BLen := StrLen(B64)
  If DllCall( "Crypt32.dll\CryptStringToBinary", "Str",B64, "UInt",BLen, "UInt",0x1
            , "Ptr",&Bin, "UIntP",nBytes, "Int",0, "Int",0 )
     hICON := DllCall( "CreateIconFromResourceEx", "Ptr",&Bin, "UInt",nBytes, "Int",True
                     , "UInt",0x30000, "Int",16, "Int",16, "UInt",0, "UPtr" )            
Return hICON
}

GuiClose:
;*ESC::
exit:
;esc::
ExitApp
