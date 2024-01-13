; Evriq launcher is a tool to search files and quickly open, edit, copy, etc.
; Author: Arekusei

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, Force 
SetBatchLines -1
SetControlDelay, -1
SetWinDelay, -1
SetWorkingDir %A_ScriptDir%
ListLines Off
#MaxThreadsPerHotkey 4
#MaxHotkeysPerInterval 100
DetectHiddenWindows, On

Global IconNumber

Global WinTitle := "Evriq Launcher"

{
;dark
cBackground := "c" . "1C1C1A"
cText := "c" . "F5DA42"
cSelection := "0x40403c"

;dark blue
;cBackground := "c" . "000F14 "
;cText := "c" . "A0A0B4"
;cSelection := "0x40403c"

;commie
;cBackground := "c" . "BE0000"
;cText := "c" . "F7EA00"
;cSelection := "0x810101"

;red yellow desat
;cBackground := "c" . "1C1C1A"
;cText := "c" . "F5DA42"
;cBackground := "c" . "B91C1B"

;Hex codes: Charcoal #101820FF, Yellow #FEE715FF 
;cBackground := "c" . "101820"
;cText := "c" . "FEE715"
;cSelection := "0x810101"

;Hex codes: Lavender #E2D1F9, Teal #317773
;cBackground := "c" . "317773"
;cText := "c" . "E2D1F9"
;cSelection := "0x225451"

;white black
;cBackground := "cFFFFFF", cText := "c000000"

;black white
;cBackground := "c000000", cText := "cFFFFFF"
}

gui_control_options := " w190 " . cText . " -E0x200"

;210 243 188 imageres.dll
;Menu, Tray, Icon, Shell32.dll, 31
;Menu, Tray, Icon, imageres.dll, 243

hICON := Base64toHICON()               ; Create a HICON
Menu, Tray, Icon, HICON:*%hICON%       ; AHK makes a copy of HICON when * is used
Menu, Tray, Icon
DllCall( "DestroyIcon", "Ptr",hICON )  ; Destroy original HICON


;Menu, Tray, DeleteAll
Menu, Tray, NoStandard
Menu, Tray, Add, Show/Hide, Menu_ShowHide
Menu, Tray, Add, Settings, Menu_Settings
Menu, Tray, Add, Open Folder, Menu_DataFolder
Menu, Tray, Add,
Menu, Tray, Add, Exit, Close

Menu, Tray, Click, 1 ;opens on single click
Menu, Tray, Default, Show/Hide
Menu, Tray, Tip , % WinTitle


Menu, Menu, Add, Open, ContextOpenFile
Menu, Menu, Add, Edit, ContextEdit
Menu, Menu, Add, Properties, ContextProperties
Menu, Menu, Add, Copy Path, CopyPath
Menu, Menu, Default, Open


Gui, +LastFound ; Added
Gui, +ToolWindow +AlwaysOnTop -Theme -Caption +Border


Gui, Font, S15  Bold, Verdana
Gui, Add, Edit, x6 y7 h26 %gui_control_options% vv_edit gfn_edit , ; Text here
GuiControl, Focus, v_edit

Gui, Color, %cBackground%, %cBackground%

if true {
Gui, Font, S8 CDefault, Verdana
Gui, Add, Text , right x+20 +0x201 -Border y12 w30 %cText% vv_count , 0
Gui, Font, CDefault s14 ,Webdings 
Gui, Add  , Text , xp+33 y9 w16 h18 %cText% gWM_LBUTTONDOWN, g ;1 ;Drag
Gui, Add  , Text , xp+20 y7 w25 h25 %cText% gAppExit, r ;exit	
}



Global FS:= 8
Gui, Font, S%FS% CDefault , Verdana
;Gui Add, ListView, x8 y37 w283 h154 AltSubmit  hWndhlv vLV1  , Split ;+Background0xf5da42
;LV_ModifyCol(1, 200)
Gui, Color, %cBackground% ;, %cBackground%

global NameArr := 0
global StoreList := []
Global List := []


Gui, Add, ListView, x6 y7 h26 x5 y40 w340 h154 hWndHLV Choose1 %cText% -E0x200 +LV0x4000 -hdr +NoSortHdr vLB1 gMyBoxView , Name|File
LV_ModifyCol(1,223)
LV_ModifyCol(2,60)
LV_ModifyCol(3,60)

;0x40403c
;LV_SetSelColors(HLV, cSelection) ;comment this out if it freezes program 

;Gui Add, Text,  x150 y34 w289 h160 +0x201 +Border  ;vText1 ;gMoveWin
global ImageListID1 := IL_Create(10)
global ImageListID2 := IL_Create(10, 10, true)  ; A list of large icons to go with the small ones.

; Attach the ImageLists to the ListView so that it can later display the icons:
LV_SetImageList(ImageListID1)
LV_SetImageList(ImageListID2)

;-E0x200
;Gui, Color, %cBackground%

Gui Add, Text, x5 y5 w289 h30 +0x201 +Border BackGroundTrans 
;Gui Add, Text,  x5 y34 w289 h160 +0x201 +Border BackGroundTrans vText1 ;gMoveWin


Gui Load:Default ;Set GUI to Load
Gui, Add, GroupBox, x12 y10 w300 h50 , Loading..
Gui, Add, Text, x22 y30 h20 w280 r1 vText, Path
Gui, +AlwaysOnTop
Gui, Show, , Loading paths..

create_list()
Gui, Destroy

Gui 1:Default ;Set GUI to Default
Gui, Show , h40 w300 , %WinTitle%
OnMessage(0x201, "WM_LBUTTONDOWN") ;to move gui

GuiControl, +Redraw, v_edit

return

;WM_LBUTTONDOWN(wParam, lParam)
;{
    ;X := lParam & 0xFFFF
    ;Y := lParam >> 16
    ;if A_GuiControl
        ;Ctrl := "`n(in control " . A_GuiControl . ")"
    ;;ToolTip You left-clicked in Gui window #%A_Gui% at client coordinates %X%x%Y%.%Ctrl%
    ;PostMessage, 0xA1, 2,,, A 
;}

WM_LBUTTONDOWN(){
    PostMessage, 0xA1, 2
}
return

GuiContextMenu:
Menu, Menu, Show ;Shows the menu
return

ContextOpenFile:  ; The user selected "Open" in the context menu.
ContextProperties:  ; The user selected "Properties" in the context menu.
ContextEdit:
CopyPath:
;IconNumber, A_LoopFileName, Fileext, A_LoopFilePath
Gui, Default
FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
FileDir:= StoreList[FocusedRowNumber][4]
if not FocusedRowNumber
	return

IfInString A_ThisMenuItem, Open  ; User selected "Open" from the context menu.
	Run %FileDir%,, UseErrorLevel
IfInString A_ThisMenuItem, Properties
	Run Properties %FileDir%,, UseErrorLevel
IfInString A_ThisMenuItem, Edit
	Run edit %FileDir% ;Run "C:\Program Files\Notepad++\notepad++.exe" "%FileDir%",, UseErrorLevel
if InStr(A_ThisMenuItem,"Copy Path")
    Clipboard := FileDir
if ErrorLevel
	MsgBox Could not perform requested action on "%FileDir%".

return


Minimize(){

;GuiControlGet, v_edit, , v_edit
GuiControlGet, v_edit ;calls and sets the var at same time

if (NameArr>0 && StrLen(v_edit))
{
    arrlen:= nameArr ;? nameArr : 0

    if (arrlen > 9){
        arrlen := 10
    }

    Height := arrlen * 17
    ;msgbox % Height
    GuiControl, Move, LB1, % "H" . Height ;+ 4
    Gui Show, % "H" . Height + 45 . "NA"
    Return
}
 
Gui Show, % " h40 NA"  ;, Selection

}
Return


fn_edit(){

	static editLength := 0
    GuiControlGet, v_edit ;, , v_edit

    if StrLen(v_edit) != editLength
    {
        editLength := StrLen(v_edit)
        SetTimer fn_edit, -200
        
    } else {   
        SetTimer fn_edit_exec, -0 ;a hack to prevent input from being blocked 
    }

}


;-------------------------------------------------------------------------------
build_Tree(Folder, Depth := 0) { ; return folder tree; to be improved when I find time lol
;-------------------------------------------------------------------------------

    ;Result .= Indent "[" Folder "]`n" ;comment out to not include root folder
    ;Static List := []

    if (depth+1 = 0){
        Return
    }
    Depth --

    Loop, Files, %Folder%\*.*, FD
    {
        
        if A_LoopFileAttrib contains H,R ;,S  ; Skip H (Hidden), R (Read-only), or S (System). Note: No spaces in "H,R,S".
            continue  ; Skip this file and move on to the next one.

        SplitPath, A_LoopFileName,,, FileExt  ; Get the file's extension.
        ;if FileExt not in EXE,ANI,CUR,LNK,AHK,URL,CMD ;,TXT,ICO
        ;    continue
        if FileExt contains dll
            continue
        if InStr(A_LoopFileAttrib, "D")
            FileExt := "DIR"
        ;if InStr(A_LoopFileAttrib, "D")
            ;Result .= Indent "`t" A_LoopFileName " [D]`n"
        ;else
            ;Result .= Indent "`t" A_LoopFileName "`n"
        
        ;############################################################################################
        
        ;uncomment this to load with icons, will be slower on startup
        /*
        sfi_size := A_PtrSize + 8 + (A_IsUnicode ? 680 : 340)
        VarSetCapacity(sfi, sfi_size)
        FileName := A_LoopFileFullPath  ; Must save it to a writable variable for use below.


        SplitPath, FileName,,, curExt   ; Get the file's extension.
        if curExt in EXE,ICO,ANI,CUR,LNK ; ,AHK,LNK
        {
            ExtID := curExt  ; Special ID as a placeholder.
            IconNumber := 0  ; Flag it as not found so that these types can each have a unique icon.
        }
        else  ; Some other extension/file-type, so calculate its unique ID.
        {
            ExtID := 0  ; Initialize to handle extensions that are shorter than others.
            Loop 7     ; Limit the extension to 7 characters so that it fits in a 64-bit value.
            {
                ExtChar := SubStr(curExt, A_Index, 1)
                if not ExtChar  ; No more characters.
                    break
                ; Derive a Unique ID by assigning a different bit position to each character:
                ExtID := ExtID | (Asc(ExtChar) << (8 * (A_Index - 1)))
                
            }

            IconNumber := IconArray%ExtID%
        }
        
        
        if !IconNumber  ; There is not yet any icon for this extension, so load it.
        {
            ; Get the high-quality small-icon associated with this file extension:
            if not DllCall("Shell32\SHGetFileInfo" . (A_IsUnicode ? "W":"A"), "Str", FileName
                , "UInt", 0, "Ptr", &sfi, "UInt", sfi_size, "UInt", 0x101)  ; 0x101 is SHGFI_ICON+SHGFI_SMALLICON
                IconNumber := -1  ; Set it out of bounds to display a blank icon.
            else ; Icon successfully loaded.
            {
                hIcon := NumGet(sfi, 0)
                IconNumber := DllCall("ImageList_ReplaceIcon", "Ptr", ImageListID1, "Int", -1, "Ptr", hIcon) + 1
                DllCall("ImageList_ReplaceIcon", "Ptr", ImageListID2, "Int", -1, "Ptr", hIcon)
                DllCall("DestroyIcon", "Ptr", hIcon)
                ; Cache the icon to save memory and improve loading performance:
                IconArray%ExtID% := IconNumber
            }
        }
        
      
        */
        ;DllCall("Shell32\SHGetFileInfo" . (A_IsUnicode ? "W":"A"), "Str", FileName
                ;, "UInt", 0, "Ptr", &sfi, "UInt", sfi_size, "UInt", 0x101)  ; 0x101 is SHGFI_ICON+SHGFI_SMALLICON
        ;hIcon := NumGet(sfi, 0)
        ;IconNumber := DllCall("ImageList_ReplaceIcon", "Ptr", ImageListID1, "Int", -1, "Ptr", hIcon) + 1
            ;MsgBox % iconnumber
            List.Push(["Icon"IconNumber, A_LoopFileName, Fileext, A_LoopFilePath])
        ;oList.push(["Icon" 1, A_LoopFileName, Fileext, A_LoopFilePath])        
    }


    Loop, Files, %Folder%\*.*, D
    {
        ;Result .= 
        build_Tree(A_LoopFileFullPath, Depth)
    }
    

    Return, List ;Output
}



create_list(){

    FileRead, list, %A_ScriptDir%\Data\Paths.txt
    sourceRootDirs := StrSplit(list, "`r`n") 
 
    tmp := ""
    for k, v in sourceRootDirs {

        if instr(v, ";")
            continue
        Transform, OutputVar, Deref, % v
        if (StrLen(OutputVar) < 3)
            continue
        tmp.= OutputVar "`n"
    }
    sourceRootDirs := tmp

    list := [] ;rewrite it
    

    Loop, Parse, sourceRootDirs, `n
    {
        curdir := A_LoopField
        GuiControl ,Load:, text, %curdir%
        build_Tree(curdir, 1)
    }


}
return


fn_edit_exec(){

    GuiControlGet, v_edit ;, , v_edit

    ;list := []
    StoreList := []
    FilterText := v_edit
    NameArr:= 0
    
    ;ToolTip % v_edit
    

    if !StrLen(v_edit) ;check if not empty
    {
        Minimize()
        GuiControl, , v_count, 0
        return
    }
    ; filters
    ;MsgBox % list.Length()
    ST := A_TickCount
    ;loop % list.Length()
    for k, v in list
    {
        ;msgbox % list[A_Index][1]
        ;v := list[A_Index]
        ;if (k > 500) 
        ;    break
        ;MsgBox % k "`n1: " v.1 "`n2: " v.2 "`n3: " v.3 "`n4: " v.4
        ;MsgBox % v.4

        FilterPos:= 0
        if RegExMatch(v[2], "i)^\Q" FilterText "\E"){
            FilterPos:= 0
            StoreList.InsertAt(1,v)

        } else
        if RegExMatch(v[2], "i)" FilterText){
            FilterPos:= 1
            StoreList.Push(v)

        } else
        if (SubStr(FilterText, 1, 3) == "/m "){
            if (RegExMatch(v[2], "i).*" SubStr(FilterText, 4, StrLen(FilterText)) ".*\.(png|jpg|jpeg|webp)$")){
                FilterPos:= 1
                StoreList.Push(v)
            }

        } else
        if (SubStr(FilterText, 1, 3) == "/f "){
            str := StrSplit(FilterText," ")
            SplitPath, % v[4] ,, dir
            SplitPath, dir, parentdir

            ;if (InStr(v[4], str.2)){
            ;if (InStr(parentdir, str.2)){
            if (parentdir ~= "i)" str.2){

                if (RegExMatch(v[2], "i).*" str.3 ".*")){
                    FilterPos:= 1
                    StoreList.Push(v)
                }
            }

        } 
        else {
            Continue
        }
     }
        
        If  InStr(A_LoopFileAttrib, "D") ;If its a folder, D stands for directory
        {
            Filesize := ""
            Fileext := ":Folder"
        }
        Else ;If its a file
        {
            Filesize := A_LoopFileSizeKB "kb"
            Fileext :=  A_LoopFileExt
        }
        
        /*
        if (FilterPos = 1){
            ;list.Insert(["Icon" IconNumber, A_LoopFileName, Fileext, A_LoopFileFullPath])
            ;list.Push(["Icon" IconNumber, A_LoopFileName, Fileext, A_LoopFileFullPath])
            
        }
        else {
            ;list.Insert(1,["Icon" IconNumber, A_LoopFileName, Fileext, A_LoopFileFullPath])
            ;list.InsertAt(1,["Icon" IconNumber, A_LoopFileName, Fileext, A_LoopFileFullPath])
        }
        */

 
     ;MsgBox % StoreList.Length()
    ;} ;check if not empty 
    NameArr := StoreList.Length()
    ;StoreList:= list
    GuiControl, -Redraw, MyListView  ; Improve performance by disabling redrawing during load.
    LV_Delete()
    ;MsgBox % NameArr
    
    ;slowest part smh
    Loop, % StoreList.Length()
    {
        if (A_Index > 1000) 
            break
        index:= StoreList[A_index]
        ;i := Mod(a_index,10)+1
        ;MsgBox % index[1] " " index[2] " " index[3] " " index[4]
        ;LV_Add(index[1],index[2],index[3])
        ;LV_Insert(A_index, index[1],index[2],index[3])
        LV_Add(index[1],index[2],index[3], index[4])
    }
    
    GuiControl, , v_count, % (StoreList.Length() > 1000) ? (StoreList.Length() // 1000) " k" : StoreList.Length()
    GuiControl, +Redraw, MyListView  ; Re-enable redrawing (it was disabled above).

    Minimize()
    
    ;msgbox % A_TickCount - ST
    
}
return



scrollbox(pos, len := 8){
;GuiControl, +Redraw, MyListView
;gui Submit, NoHide
;GuiControlGet, lb1, , lb1
;ToolTip % LV_GetNext() "`n" LV_GetCount()

if (pos) {
    lb1 := LV_GetNext()
    ;tooltip % lb1 " " LV_GetCount() 
    if (lb1 >= LV_GetCount())
        return
    ;ToolTip % lb1
    LV_Modify(lb1, "-Focus -Select")  ; deselect only previous row to not cause glitches
    lb1 := min(lb1+len, min(NameArr,1000))
    ;lb1 := min(lb1+len, 1000) ;custom length
    GuiControl, Choose, lb1, % lb1
    LV_Modify(lb1, "Select Vis")
    ;tooltip % lb1

 } else {
    lb1 := LV_GetNext()
    if (lb1 = 0)
        return
    ;ToolTip % lb1
    LV_Modify(lb1, "-Focus -Select")  ; deselect only previous row to not cause glitches
    lb1 := max(lb1-len, 1)
    GuiControl, Choose, lb1, % lb1
    LV_Modify(lb1, "Select Vis")
    ;tooltip % lb1

 }
 ;tooltip % lb1

}
return

!Space::
;gosub Menu_ShowHide
Menu_ShowHide()
return
;window:= DllCall("IsWindowVisible", "UInt", WinExist(%WinTtle%))
;If !window
    ;Gui, Show
;Else
    ;Gui, Hide
;GuiControl,  +Redraw, v_edit ;we have to redraw edit above image
;return

;#IfWinActive Evriq Launcher ;vars arent's supported yet..
#If WinActive(WinTitle)
$^BS::Send ^+{Left}{Delete}

!esc::
ExitApp
return


Down::
$NumpadDown::
scrollbox(1,1)
return
Up::
$NumpadUp::
scrollbox(0,1)
return

+Down::
$+NumpadDown::
scrollbox(1)
return
+Up::
$+NumpadUp::
scrollbox(0)
return

$NumpadEnter::
$enter::
;GuiControlGet, lb1, , lb1
;gui Submit, NoHide
;GuiControlGet, v_edit, , v_edit
;tooltip % StoreList[lb1]
;tooltip % StoreList[LV_GetNext()]
Tooltip("Run...", 1000)
run % StoreList[LV_GetNext()][4] ;" ." ;dot prevents from starting lnk files instead of folders
;ToolTip % StoreList[LV_GetNext()][4]
return

MyBoxView:
;LVM_ShowScrollBar(hLV,1,False)
if (A_GuiEvent = "DoubleClick")
{
;GuiControlGet, lb1, , lb1
tooltip % StoreList[LV_GetNext()][4]
Tooltip("Run...", 1000)
run % StoreList[LV_GetNext()][4] ; " ."
;run % StoreList[LV_GetNext()]
;run % StoreList[lb1]
}
return

#if



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
        ;GuiControlGet, v_edit , , v_edit
        GuiControl, Focus, v_edit

    }
    ToolTip
}

Menu_Settings(){
MsgBox 0x40030, , Settings to be added sometime ...
return
Gui Settings:Default

;Gui +Resize
Gui Font, s9, Segoe UI
Gui Margin, 10, 10
Gui Add, Tab3, x0 y0 h220, Indexing|Test
Gui Add, GroupBox, xm y+0 w600 h189, Paths
Gui Add, ListView, xp+10 yp+20 w573 h124 -Hdr  , Path

loop 11
LV_Add(0,"C:\ProgramData\Microsoft\Windows\Start Menu\Programs")
LV_ModifyCol()

Gui Add, Button, xp-1 y+2 w50 h25, Add
Gui Add, Button, x+0 yp w50 h25, Delete
Gui Add, Button, x+0 yp w111 h25, Default settings
;Gui Add, Button, x478 yp w39 h25, Help

Gui Tab

Gui Show, w620 h220, Evriq - Settings

}

Menu_DataFolder:
Run % A_ScriptDir "\Data\"

return

~*LButton::
~*RButton::
if (!MouseIsOver(WinTitle)){
    return
    WinGet, winStyle, Style, %WinTitle%
    if (winStyle & 0x10000000)
        WinHide, %WinTitle%
    ;ToolTip
}
return

#If MouseIsOver(WinTitle)

~!2::
WheelDown::
scrollbox(1)
;LVM_ShowScrollBar(hLV,1,False)
return

~!1::
WheelUp::
scrollbox(0)
;LVM_ShowScrollBar(hLV,1,False)
return
#if

MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return !!WinExist(WinTitle . " ahk_id " . Win)
}
Tooltip(text, time){
    ToolTip
	ToolTip % text
	SetTimer, TP, -%time%
	return
	TP:
	ToolTip
	Return
}

; ===========================================================================================================================
; Sets the colors for selected rows in a ListView.
; Parameters:
;     HLV      -  handle (HWND) of the ListView control.
;     BkgClr   -  background color as RGB integer value (0xRRGGBB).
;                 If omitted or empty the ListViews's background color will be used.
;     TxtClr   -  text color as RGB integer value (0xRRGGBB).
;                 If omitted or empty the ListView's text color will be used.
;                 If both BkgColor and TxtColor are omitted or empty the control will be reset to use the default colors.
;     Dummy    -  must be omitted or empty!!!
; Return value:
;     No return value.
; Remarks:
;     The function adds a handler for WM_NOTIFY messages to the chain of existing handlers.
; ===========================================================================================================================
LV_SetSelColors(HLV, BkgClr := "", TxtClr := "", Dummy := "") {
   Static OffCode := A_PtrSize * 2              ; offset of code        (NMHDR)
        , OffStage := A_PtrSize * 3             ; offset of dwDrawStage (NMCUSTOMDRAW)
        , OffItem := (A_PtrSize * 5) + 16       ; offset of dwItemSpec  (NMCUSTOMDRAW)
        , OffItemState := OffItem + A_PtrSize   ; offset of uItemState  (NMCUSTOMDRAW)
        , OffClrText := (A_PtrSize * 8) + 16    ; offset of clrText     (NMLVCUSTOMDRAW)
        , OffClrTextBk := OffClrText + 4        ; offset of clrTextBk   (NMLVCUSTOMDRAW)
        , Controls := {}
        , MsgFunc := Func("LV_SetSelColors")
        , IsActive := False
   Local Item, H, LV, Stage
   If (Dummy = "") { ; user call ------------------------------------------------------------------------------------------------------
      If (BkgClr = "") && (TxtClr = "")
         Controls.Delete(HLV)
      Else {
         If (BkgClr <> "")
            Controls[HLV, "B"] := ((BkgClr & 0xFF0000) >> 16) | (BkgClr & 0x00FF00) | ((BkgClr & 0x0000FF) << 16) ; RGB -> BGR
         If (TxtClr <> "")
            Controls[HLV, "T"] := ((TxtClr & 0xFF0000) >> 16) | (TxtClr & 0x00FF00) | ((TxtClr & 0x0000FF) << 16) ; RGB -> BGR
      }
      If (Controls.MaxIndex() = "") {
         If (IsActive) {
            OnMessage(0x004E, MsgFunc, 0)
            IsActive := False
      }  }
      Else If !(IsActive) {
         OnMessage(0x004E, MsgFunc)
         IsActive := True
   }  }
   Else { ; system call ------------------------------------------------------------------------------------------------------------
      ; HLV : wParam, BkgClr : lParam, TxtClr : uMsg, Dummy : hWnd
      H := NumGet(BkgClr + 0, "UPtr")
      If (LV := Controls[H]) && (NumGet(BkgClr + OffCode, "Int") = -12) { ; NM_CUSTOMDRAW
         Stage := NumGet(BkgClr + OffStage, "UInt")
         If (Stage = 0x00010001) { ; CDDS_ITEMPREPAINT
            Item := NumGet(BkgClr + OffItem, "UPtr")
            If DllCall("SendMessage", "Ptr", H, "UInt", 0x102C, "Ptr", Item, "Ptr", 0x0002, "UInt") { ; LVM_GETITEMSTATE, LVIS_SELECTED
               ; The trick: remove the CDIS_SELECTED (0x0001) and CDIS_FOCUS (0x0010) states from uItemState and set the colors.
               NumPut(NumGet(BkgClr + OffItemState, "UInt") & ~0x0011, BkgClr + OffItemState, "UInt")
               If (LV.B <> "")
                  NumPut(LV.B, BkgClr + OffClrTextBk, "UInt")
               If (LV.T <> "")
                  NumPut(LV.T, BkgClr + OffClrText, "UInt")
               Return 0x02 ; CDRF_NEWFONT
         }  }
         Else If (Stage = 0x00000001) ; CDDS_PREPAINT
            Return 0x20 ; CDRF_NOTIFYITEMDRAW
         Return 0x00 ; CDRF_DODEFAULT
}  }  }


Base64toHICON() { ; 16x16 PNG image (236 bytes), requires WIN Vista and later
Local B64 :="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAIdJREFUOE9jZKAQMFKon4FyA+rr6/9T4gpGkAEbN26Em8HDwwNmf/nyhQGZjc0Sf39/BgwD9s4WZViz8iHD9D1cDMhsogzIdPnGEJnqzWAXvp8BmY3LixguIMV2kKEoBuCzHWSwc+prsJeQaRQDSLUdwwXkRCXcBeRohumhPCVSYjtI78C7AAA5qmhtymm7awAAAABJRU5ErkJggg==",  Bin, Blen, nBytes:=236, hICON:=0                     
  
  VarSetCapacity( Bin,nBytes,0 ), BLen := StrLen(B64)
  If DllCall( "Crypt32.dll\CryptStringToBinary", "Str",B64, "UInt",BLen, "UInt",0x1
            , "Ptr",&Bin, "UIntP",nBytes, "Int",0, "Int",0 )
     hICON := DllCall( "CreateIconFromResourceEx", "Ptr",&Bin, "UInt",nBytes, "Int",True
                     , "UInt",0x30000, "Int",16, "Int",16, "UInt",0, "UPtr" )            
Return hICON
}



Close:
AppExit:
ExitApp 
