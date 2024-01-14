#SingleInstance, force
SetControlDelay, -1
SetBatchLines, -1 

Global stopped := true
Global WinTitle := "Learn2type"
myScore := 0
chars := 0
;startTime := "00:45"
startTime := "00:05"
;startTime := "00:30"


cBackground := "c" . "1C1C1A"
cText := "c" . "F5DA42"
cSelection := "0x40403c"

gui_control_options := "  " . cText . " -E0x200"


words2 :=
(LTrim Join Comments
[
    "own",
    "just"
  ]
 )

Global words ;:= words2


Rand_Number := RandChar()

hICON := Base64toHICON()               ; Create a HICON
Menu, Tray, Icon, HICON:*%hICON%       ; AHK makes a copy of HICON when * is used
;Menu, Tray, Icon
DllCall( "DestroyIcon", "Ptr",hICON )  ; Destroy original HICON
#NoTrayIcon

gui, Margin, 10, 10
Gui, +AlwaysOnTop
;gui, Color, 666633
Gui, Color, %cBackground%, %cBackground%
gui, font, s25 Bold, Console

Gui, Add, Button, x-111 y-111, Hello
Gui, Add, Text, +Center xm+115 y10 %cText% border BackgroundTrans  vDisplay,  % startTime ;00:10
Gui, Font
Gui, add, Text, xp-9 y+2 %cText%, Press Enter to Restart!

Gui, Font, S15  Bold, Console
Gui, add, Text, xm w300 y+1 vNew_Word border +0x200 %cText%, % words[Rand_Number]

Gui, add, Edit, xm y+2 w300 h30 vMy_Word %gui_control_options%  border gEdit1,


gui, font
Gui Add, DropDownList, xm y+5 w150 vDropDownList gDropDownListEvents

words_list:= ""
Loop, Files, %A_ScriptDir%\Data\*.txt, F
{
    words_list.= A_LoopFileName "|"
}
GuiControl,, DropDownList, % words_list
GuiControl, Choose, DropDownList, 2

Gui, Font, Bold
Gui, add, Text, x+15 yp+3 %cText%, Time:

for k, v in ["N15", "N30", "N60", "N120"]{
    Gui, add, Text, x+7 yp gSetTime w15 v%v% %cText%, % SubStr(v, 2)
}
SetTime("N60")

gui, font, 
gui, add, Edit, xm y+10 w150 h85 vCorrect_Words %cText% ReadOnly , Score per game
gui, font, s12, Console ;Bauhaus 93
gui, add, Text, x+20 w100 h55 %cText% vScore , Words: 0

GuiControl, Focus, Edit1
gui, show, AutoSize, % WinTitle
;GuiControl, +Redraw, v_edit
generateNewList()
return

#If WinActive(WinTitle)
~enter::
GuiControl, Enable, My_Word
GuiControl, Focus, Edit1
generateNewList()
GuiControl, , Display, % startTime
gosub Edit1
return
#If


DropDownListEvents:
    generateNewList()
    Gosub Edit1
return

generateNewList(){
    SetTimer, Stopwatch, Off
    ;GuiControl, , Display, 00:00
    stopped := true
    GuiControlGet, DropDownList
    ;MsgBox % DropDownList
    FileRead, list, % A_ScriptDir "\Data\" DropDownList
    if (ErrorLevel)
        return
    words := StrSplit(list, "`n", "`r")
    Rand_Number := RandChar()
    ;StrSplit(words[Rand_Number], "`n", "`r") 
    GuiControl,, New_Word, % words[Rand_Number]

}

SetTime(strTime := "N15"){
Global
    strTime := (A_GuiControl ? A_GuiControl : strTime)
    startTime := ToDigital( SubStr(strTime, 2) * 1000)
    ;msgbox % A_GuiControl
    SetTimer, Stopwatch, Off
    stopped := true
    GuiControl, , Display, % startTime ;00:00
    
    for k, v in ["N15", "N30", "N60", "N120"]{
        Gui, Font, s8 Norm  %cText% , Console
        GuiControl, Font, % v
    }
    Gui, Font, s8 cRed %cText% Bold, Console
    GuiControl, Font, % strTime
    
}

Edit1:
;ToolTip % words.Length()
GuiControlGet, new_input,, My_Word
GuiControlGet, old_word,, New_Word


if (new_input != SubStr(old_word, 1, StrLen(new_input))){
    Gui, Font, s15 cRed Bold, Console
    GuiControl, Font, Edit1
} else {
    Gui, Font, s15 %cText% Bold, Console
    GuiControl, Font, Edit1
}

if (new_input <> "" && stopped == true){
	stopped := false
    myScore := 0
    chars := 0
	gosub, Start
}
if (new_input == old_word){
    if (words.Length() <= 0){
            GuiControl,, New_Word, Out of words!
            SetTimer, Stopwatch, Off
            GuiControl, , Display, % startTime ;00:00
            stopped := true
            GuiControl, Disable, My_Word
            setScore([myScore, chars])
            ;generateNewList()
        return
    }
	myScore++
    chars += StrLen(new_input)
	Score_Count(myScore, chars)
	;Correct_Word(old_word)
    
    if (words.Length() > 0){
        words.Remove(Rand_Number)
    }
	GuiControl, , My_Word,
	Rand_Number := RandChar()
	GuiControl,, New_Word, % words[Rand_Number]
}
return


StopWatch:
;ToolTip % Display
;GuiControl, , Display, % ToDigital(A_TickCount - ST)    ;Time count up
GuiControl, , Display, % ToDigital(ET - (A_TickCount)) ;Time count down
;trayTime:= ToDigital(ET - (A_TickCount))
;Menu, Tray,Tip , Time in: %trayTime%
;tooltip % ToDigital(ET - (A_TickCount))
if (A_TickCount >= ET){
    SetTimer, Stopwatch, Off
    GuiControl, , Display, 00:00
    stopped := true
    GuiControl, Disable, My_Word
    GuiControl, , My_Word
    GuiControl, , New_Word, %A_Space%
    ;generateNewList()
    setScore([myScore, chars])
    

}

Return

Start:
    ;stopped := False
    ST := A_TickCount
    Time := (0*3600)+(0*60)+ ToMs(startTime)  
    ;GuiControl, , Display, % ToDigital(Time)
    ET := ST + (Time * 1000)
    SetTimer, Stopwatch, 100
return

ToDigital(currentTime)
{
    s  := Mod(Floor(currentTime / 1000), 60)
    m  := Mod(Floor(currentTime / (1000 * 60)), 60)
    h  := Floor(currentTime / (1000 * 60 * 60))
    return Format("{:02d}:{:02d}", m, s)
}


ToMs(currentTime)
{
    currentTime := StrSplit(currentTime, ":")
    ;msgbox %  remZero(currentTime[2])
    out := (remZero(currentTime[1]) * 60) + remZero(currentTime[2])
    ;msgbox % out " 123123"
    return out
}

remZero(num){
    zero := true
    Loop, parse, num
    {
        if(A_LoopField="0" && zero){
            Continue
        }
        else {
            zero := false
            num1.=A_LoopField
        }
    }
    if num1 =
        num1 := 0
    return Format("{:s}", num1)
}

RandChar()
{
	global
	Random, Rand, 1, % Words.Length() ;Word_for_Use.Length()
	return, Rand
}

Correct_Word(word)
{
	GuiControlGet, new_put,, Correct_Words, Text
	new_ver := word "`n" new_put
	GuiControl, , Correct_Words, % new_ver
	return
}

setScore(str){
    Global
	GuiControlGet, new_put,, Correct_Words, Text
    ;to ms is terrible name LOL
	new_ver := "W: " str[1] "   C: " str[2] "   T: " ToMs(startTime) "`n" new_put
	GuiControl, , Correct_Words, % new_ver 
}

Score_Count(newScore, chars)
{
	GuiControl, , Score, % "Words: " newScore "`nChars: " chars
	return
}

Base64toHICON() { ; 16x16 PNG image (236 bytes), requires WIN Vista and later
Local B64 :="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAGFJREFUOE9jZKAQMFKon4FyA+rr6/9T4gpGkAEbN24kywx/f38GuAF7Z4syOKe+ZiCGBtkGUotiADlOwHABzGR8roBZRBsXwMIAn3eQw4l6YUBOAML0UJ4SKbEdpHfgXQAARhpVbTAHY+IAAAAASUVORK5CYII=",  Bin, Blen, nBytes:=236, hICON:=0                     
  
  VarSetCapacity( Bin,nBytes,0 ), BLen := StrLen(B64)
  If DllCall( "Crypt32.dll\CryptStringToBinary", "Str",B64, "UInt",BLen, "UInt",0x1
            , "Ptr",&Bin, "UIntP",nBytes, "Int",0, "Int",0 )
     hICON := DllCall( "CreateIconFromResourceEx", "Ptr",&Bin, "UInt",nBytes, "Int",True
                     , "UInt",0x30000, "Int",16, "Int",16, "UInt",0, "UPtr" )            
Return hICON
}

GuiEscape:
GuiClose:
ExitApp