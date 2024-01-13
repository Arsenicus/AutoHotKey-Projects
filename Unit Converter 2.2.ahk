
; Original author: fuzz54 http://www.autohotkey.com/forum/viewtopic.php?t=42809
; Rewritten by: Arekusei
; v2.2 refactored and fixed some conversion errors

xe := 2.718281828459045, xpi := 3.141592653589793

global unitsObj:= []
unitsObj["Mass"] := {boxList:"kilograms||grams|ounces|pounds|stone|ton|ton(uk)|slugs"}
unitsObj["Distance"] := {boxList:"feet|inches||mil|meters|centimeter|kilometer|millimeter|micron|mile|furlong|yard|Angstrom|light year|parsec|AU"}
unitsObj["Density"] := {boxList:"lb/in³||lb/ft³|g/cm³|kg/m³|slugs/ft³"}
unitsObj["Acceleration"] := {boxList:"m/s²||in/s²|ft/s²|g's"}
unitsObj["Force"] := {boxList:"Newton||lbf|dyne"}
unitsObj["Pressure"] := {boxList:"Pascal||psi|psf|torr|bar|atm|mm mercury|cm water"}
unitsObj["Energy"] := {boxList:"Joule||BTU|in lbf|ft lbf|kcal|therm"}
unitsObj["Power"] := {boxList:"Watt||BTU/sec|BTU/hour|hp|ft lbf/s"}
unitsObj["Time"] := {boxList:"seconds||minutes|hours|days|weeks|months(30d)|years"}
unitsObj["Thermal Conductivity"] := {boxList:"Watt/m-K||kiloWatt/m-K|BTU/hr-ft-F|BTU/hr-in-F|BTU-in/hr-ft²-F|cal/s-cm-C"}
unitsObj["Specific Heat"] := {boxList:"KiloJoule/kg-K||BTU/lb-F|cal/g-C"}
unitsObj["Heat Capacity"] := {boxList:"J/kg-K||BTU/lb-C|BTU/lb-F|cal/g-C"}
unitsObj["Heat Transfer Coefficient"] := {boxList:"Watt/m²-K||BTU/hr-ft²-F|cal/s-cm²-C|kcal/hr-ft²-C"}
unitsObj["Area"] := {boxList:"m²||cm²|mm²|micron²|in²|ft²|yd²|mil²|acre"}
unitsObj["Volume"] := {boxList:"m³||cm³|mm³|in³|ft³|yd³|ounce|pint|quart|tsp|tbsp|liter"}
unitsObj["Angle"] := {boxList:"radians||degrees|mils|minute|second|grad|cycle"}
unitsObj["Temperature"] := {boxList:"Kelvin||Celsius|Fahrenheit|Rankine|Reaumur"}
unitsObj["Speed"] := {boxList:"m/s||km/h|in/s|ft/s|yard/s|mph|Mach Number|speed of light"}
unitsObj["Electric Current"] := {boxList:"ampere||coulomb/s|statampere"}
unitsObj["Physical Constants"] := {boxList:"Speed of Light (m/s)||Gravitation (m³/kg-s²)|Planck's Constant (J-s)|magnetic constant (N/A²)|electric constant (F/m)|Coulomb cons. (N-m²/C²)|elementary charge (C)|Electron Mass (kg)|Proton Mass (kg)|fine structure constant|Rydberg constant (1/m)|atomic mass unit (kg)|Avogadro's # (1/mol)|Boltzmann constant (J/K)|Faraday constant (C/mol)|gas constant (J/K-mol)|Stefan-Boltz. (W/m²-K^4)"}

unitsObj["Coeff. of Thermal Expansion"] := {boxList:"1/°K||1/°C|1/°F|1/°R"}
unitsObj["Mathematical Constants"] := {boxList:"Pi||e|Euler-Mascheroni|Golden Ratio|Silver Ratio|Feigenbaum 1|Feigenbaum 2|Twin Prime constant|Meissel-Mertens|Laplace limit|Apéry's constant|Lévy's constant|Omega constant|Plastic Constant|Parabolic Constant|Brun's Twin Prime|Brun's Quad Prime|Khinchin's constant|Fransén-Robinson|"}



global unitsValue := []
;distance from
unitsValue["feet"] := 1.0
unitsValue["inches"] := .0833333
unitsValue["mil"] := .0000833333
unitsValue["microns"] := 3.2808E-6
unitsValue["meters"] := 3.2808
unitsValue["kilometer"] := 3280.8399
unitsValue["centimeter"] := 0.032808399
unitsValue["millimeter"] := 0.0032808399
unitsValue["mile"] := 5280
unitsValue["furlong"] := 660
unitsValue["yard"] := 3
unitsValue["Angstrom"] := 3.280839895E-10
unitsValue["light year"] := 31017896836000000
unitsValue["parsec"] := 101236138050000000
unitsValue["AU"] := 490806662370

;Area from
unitsValue["m²"] := 1.0
unitsValue["cm²"] := .0001
unitsValue["mm²"] := 0.000001
unitsValue["micron²"] := 1.0E-12
unitsValue["in²"] := 0.00064516
unitsValue["ft²"] := 0.09290304
unitsValue["yd²"] := 0.83612736
unitsValue["mil²"] := 6.4516E-10
unitsValue["acre"] := 4046.8564224

;Volume from
unitsValue["m³"] := 1.0
unitsValue["cm³"] := 0.000001
unitsValue["mm³"] := 1.0E-9
unitsValue["in³"] := 0.000016387064
unitsValue["ft³"] := 0.028316846592
unitsValue["yd³"] := 0.76455485798
unitsValue["cup"] := 0.0002365882365
unitsValue["ounce"] := 0.000029573529563
unitsValue["pint"] := 0.000473176473
unitsValue["quart"] := 0.000946352946
unitsValue["tsp"] := 0.0000049289215938
unitsValue["tbsp"] := 0.000014786764781
unitsValue["liter"] := 0.001

;Angle from
unitsValue["radians"] := 1.0
unitsValue["degrees"] := 0.01745329252
unitsValue["minute"] := 0.00029088820867
unitsValue["second"] := 0.0000048481368111
unitsValue["mils"] := 0.00098174770425
unitsValue["grad"] := 0.015707963268
unitsValue["cycle"] := 6.2831853072
unitsValue["circle"] := 6.2831853072

;weight from
unitsValue["Kilograms"] := 2.2046226218
unitsValue["Grams"] := 0.0022046226218
unitsValue["Ounces"] := 0.0625
unitsValue["Pounds"] := 1
unitsValue["Stone"] := 14
unitsValue["Ton"] := 2000
unitsValue["Ton(Uk)"] := 2240
unitsValue["slugs"] := 32.174048695

;density from
unitsValue["lb/in³"] := 1
unitsValue["lb/ft³"] := 0.000578703
unitsValue["Kg/m³"] := 3.6127E-5
unitsValue["slugs/ft³"] := 515.31788206
unitsValue["g/cm³"] := 0.036127292927

;acceleration from
unitsValue["m/s²"] := 1
unitsValue["in/s²"] := 0.0254
unitsValue["ft/s²"] := 0.3048
unitsValue["g's"] := 9.80665

;Force from
unitsValue["Newton"] := 1
unitsValue["lbf"] := 4.4482
unitsValue["dyne"] := 10.0E-6

;Pressure from
unitsValue["Pascal"] := 1
unitsValue["psi"] := 6894.757
unitsValue["psf"] := 47.88025
unitsValue["torr"] := 133.3224
unitsValue["mm mercury"] := 133.3224
unitsValue["bar"] := 1.0E5
unitsValue["atm"] := 101325
unitsValue["cm water"] := 98.0665

;Energy from
unitsValue["Joule"] := 1
unitsValue["BTU"] := 1.055055E3
unitsValue["in lbf"] := 0.112984
unitsValue["ft lbf"] := 1.355817
unitsValue["kcal"] := 4186.8
unitsValue["therm"] := 105505585.257348

;Power from
unitsValue["Watt"] := 1
unitsValue["BTU/hour"] := 0.293071
unitsValue["BTU/sec"] := 1055.055
unitsValue["hp"] := 735.49875
unitsValue["ft lbf/s"] := 1.355817

;Time from
unitsValue["seconds"] := 1
unitsValue["minutes"] := 60
unitsValue["hours"] := 3600
unitsValue["days"] := 86400
unitsValue["weeks"] := 604800
unitsValue["months(30d)"] := 2592000
unitsValue["years"] := 31536000

;Thermal Conductivity from
unitsValue["Watt/m-K"] := 1
unitsValue["kiloWatt/m-K"] := 1000
unitsValue["BTU/hr-ft-F"] := 1.729577
unitsValue["BTU/hr-in-F"] := 20.754924
unitsValue["BTU-in/hr-ft²-F"] := 0.144131
unitsValue["cal/s-cm-C"] := 418.4

;Specific Heat from
;If units=Specific Heat
;{
unitsValue["KiloJoule/kg-K"] := 1
unitsValue["BTU/lb-F"] := 4.1868
unitsValue["cal/g-C"] := 4.1868
;}

;Heat Capacity from
unitsValue["J/kg-K"] := 1
unitsValue["BTU/lb-C"] := 2326
unitsValue["BTU/lb-F"] := 4186.8
unitsValue["cal/g-C"] := 4186.8

;Heat Transfer Coefficient from
unitsValue["Watt/m²-K"] := 1
unitsValue["BTU/hr-ft²-F"] := 5.678263
unitsValue["cal/s-cm²-C"] := 41868
unitsValue["kcal/hr-ft²-C"] := 12.518428

;Speed from
unitsValue["m/s"] := 1
unitsValue["km/h"] := 0.277777777778
unitsValue["in/s"] := 0.0254
unitsValue["ft/s"] := 0.3048
unitsValue["yard/s"] := 0.9144
unitsValue["mph"] := 0.44704
unitsValue["Mach Number"] := 340.2933
unitsValue["speed of light"] := 299790000

;Electric Current from
unitsValue["ampere"] := 1
unitsValue["coulomb/s"] := 1
unitsValue["statampere"] := 3.335641E-10

;Coefficient of Thermal Expansion from
unitsValue["1/°K"] := 1.0
unitsValue["1/°C"] := 1.0
unitsValue["1/°F"] := 1.8
unitsValue["1/°R"] := 1.8

;Mathematical Constants
unitsValue["Pi"] := 3.14159265358979323846264338327950288
unitsValue["e"] := 2.71828182845904523536028747135266249
unitsValue["Euler-Mascheroni"] := 0.57721566490153286060651209008240243
unitsValue["Golden Ratio"] := 1.61803398874989484820458683436563811
unitsValue["Silver Ratio"] := 2.4142135623730949
unitsValue["Feigenbaum 1"] := 4.66920160910299067185320382046620161
unitsValue["Feigenbaum 2"] := 4.66920160910299067185320382046620161
unitsValue["Twin Prime constant"] := 0.66016181584686957392781211001455577
unitsValue["Meissel-Mertens"] := 0.26149721284764278375542683860869585
unitsValue["Laplace limit"] := 0.66274341934918158097474209710925290
unitsValue["Apéry's constant"] := 1.20205690315959428539973816151144999
unitsValue["Lévy's constant"] := 3.27582291872181115978768188245384386
unitsValue["Omega constant"] :=  0.56714329040978387299996866221035555
unitsValue["Plastic Constant"] := 1.32471795724474602596090885447809734
unitsValue["Brun's Twin Prime"] := 1.9021605823
unitsValue["Brun's Quad Prime"] := 0.8705883800
unitsValue["Khinchin's constant"] := 2.68545200106530644530971483548179569
unitsValue["Fransén-Robinson"] := 2.80777024202851936522150118655777293
unitsValue["Parabolic Constant"] := 2.29558714939263807403429804918949039

;Physical Constants
unitsValue["Speed of Light (m/s)"] := 299792458.
unitsValue["Gravitation (m³/kg-s²)"] := 6.67428E-11
unitsValue["Planck's constant (J-s)"] := 6.62606896E-34
unitsValue["magnetic constant (N/A²)"] := 1.256637061E-6
unitsValue["electric constant (F/m)"] := 8.854187817E-12
unitsValue["Coulomb cons. (N-m²/C²)"] := 8.9875517873681764E9
unitsValue["elementary charge (C)"] := 1.602176487E-19
unitsValue["Electron Mass (kg)"] := 9.10938215E-31
unitsValue["Proton Mass (kg)"] := 1.672621637E-27
unitsValue["fine structure constant"] := 7.2973525376E-3
unitsValue["Rydberg constant (1/m)"] := 10973731.568525
unitsValue["atomic mass unit (kg)"] := 1.66053886E-27
unitsValue["Avogadro's # (1/mol)"] := 6.0221415E23
unitsValue["Boltzmann constant (J/K)"] := 1.3806503882381375462532721956135E-23
unitsValue["Faraday constant (C/mol)"] := 96485.3371638995
unitsValue["gas constant (J/K-mol)"] := 8.314472
unitsValue["Stefan-Boltz. (W/m²-K^4)"] := 5.670400E-8


;Number formatting, decimals, and groupbox dividers
Gui, Margin, 2, 2

Gui, Add, Text,  x2 y2    w298 h80 0x7 +0x201  BackGroundTrans
Gui, Add, Text,  x2 y81   w149 h46 0x7 +0x201  BackGroundTrans
Gui, Add, Text,  x+-1 y81 w150 hp  0x7 +0x201  BackGroundTrans

Gui, Add, Radio, x10 y87 h20 checked greg, Regular
Gui, Add, Radio, x10 y105 h20 gsci, Scientific
Gui, Add, Edit, x95 y102 w40 h20 gRpre vRP,
Gui, Add, UpDown, Range0-18 0x80, 2
Gui, Add, Text, x95 y87 Hide, decimals


;Memory variable controls
Gui, Add, Text, x180 y87 vgobyebye, save result to:
Gui, Add, Text, x180 y87 vgone, paste memory:
Gui, Add, DropDownList, x180 y102 w75 h17 r5 gmem    vmem   , Memory1|Memory2|Memory3|Memory4|Memory5
Gui, Add, DropDownList, x180 y102 w75 h17 r5 gmemrec vmemrec, Memory1|Memory2|Memory3|Memory4|Memory5

;Top GUI control - quanitity dropdown list
Gui, Add, DropDownList, x75 y5 w145 h20 r26 gunits vunits, Acceleration||Angle|Area|Coeff. of Thermal Expansion|Density|Distance|Electric Current|Energy|Force|Heat Capacity|Heat Transfer Coefficient|Mass|Power|Pressure|Specific Heat|Speed|Temperature|Thermal Conductivity|Time|Volume| |--------------------------------------------------|Physical Constants|Mathematical Constants|CALCULATOR

;Middle GUI controls, from and to units
Gui, Add, DropDownList, x6 y28 w130 h20 r30 vfrom gcalc,
Gui, Add, Text, x+7 y28 w17 h20 gswap vswap +Center, <=>
Gui, Add, DropDownList, x+6 y28 w130 h20 r30 vto gcalc,

;Bottom GUI controls, input and result
Gui, Add, Edit, x6 y48 w130 h20 gcalc vtot,
Gui, add, updown,range1-1000 +wrap 0x80 vgoaway,1
Gui, Add, Text, x+0 y48 w30 h20 +Center vequal, =
Gui, Add, Edit, x+0 y48 w130 h20 vrez +readonly,

;Calculator
Gui Add, Edit,   x5  y32 w165 h20 vcode Hidden,
Gui Add, Text,   x+6 y35 w5 h20 +Center vequals, =
Gui Add, Edit,   x+6 y32 w110 h20 vres Hidden Readonly ; no scroll bar for results
Gui Add, Button, x4  y58 w40 h20 Hidden vclear, &Clear
Gui Add, Button, x+2 y58 w55 h20 Default Hidden vevaluate, &Evaluate
Gui Add, Button, x+2 y58 w30 h20 Hidden vhelp, &Help

Gui Add, Button, x+45 y58 w16 h20 Hidden gBtn vlparen, (
Gui Add, Button, x+0 y58 w16 h20 Hidden gBtn vrparen, )
Gui Add, Button, x+0 y58 w16 h20 Hidden gBtn vmultiply, x
Gui Add, Button, x+0 y58 w16 h20 Hidden gBtn vdivide, /
Gui Add, Button, x+0 y58 w16 h20 Hidden gBtn vadd, +
Gui Add, Button, x+0 y58 w16 h20 Hidden gBtn vsubtract, -
Gui Add, Button, x+0 y58 w24 h20 Hidden gBtn vexponent,exp


gosub, units
gosub reg
Gui, +AlwaysOnTop
Gui, Show, AutoSize, Unit Converter v2.1
Return

GuiClose:
ExitApp


swap:
If (units == "Physical Constants" || units == "Mathematical Constants")
	return
Gui, submit, nohide
GuiControlGet, From, , Combobox4
GuiControlGet, To,   , Combobox5
ControlGet, List ,List, List, Combobox4

list:= StrSplit(list, "`n")
FromList := "|"
ToList := "|"
for k, v in list{ ;old method had a flaw with similar unit names

    FromList .= v "|"
    ToList .= v "|"
    if (v = From)
        FromList .= "|"
    if (v = To)
        ToList   .= "|"
}

GuiControl, , Combobox4, %ToList%
GuiControl, , Combobox5, %FromList%
gosub calc
Return

mem:
Gui, submit, nohide
If mem = Memory1
     Mem1=%rez%
If mem = Memory2
     Mem2=%rez%
If mem = Memory3
     Mem3=%rez%
If mem = Memory4
     Mem4=%rez%
If mem = Memory5
     Mem5=%rez%
return

memrec:
Gui, submit, nohide
If memrec = Memory1
     Pastemem=%Mem1%
If memrec = Memory2
     Pastemem=%Mem2%
If memrec = Memory3
     Pastemem=%Mem3%
If memrec = Memory4
     Pastemem=%Mem4%
If memrec = Memory5
     Pastemem=%Mem5%
coded=%code%%Pastemem%
Guicontrol,, code, %coded%
Guicontrol,focus,code
Send, {END}
gosub buttonevaluate
Return

reg:
pre = 0
If units=CALCULATOR
     gosub buttonevaluate
Else
     gosub calc
return

sci:
pre = 1
If units=CALCULATOR
     gosub buttonevaluate
Else
     gosub calc
return

Rpre:
Gui, submit, nohide
RegP = 0.%RP%
SetFormat, Float, %RegP%
If (Units == "CALCULATOR")
     gosub buttonevaluate
Else
     gosub calc
return


ButtonClear:
   Gui Submit, Nohide
   Guicontrol,, code,
   Guicontrol,, res,
   Guicontrol,focus,code
Return

ButtonEvaluate:                                ; Alt-V or Enter: evaluate expression
   Gui Submit, NoHide
   if pre
      SetFormat, float, %RegP%E
   else
      SetFormat, float, %RegP%
   coded:=code
   GuiControl,,Res,% Eval(coded)
   Guicontrol,focus,code
   Send, {END}
return


sendEdit(str){
    GuiControlGet, code
    codeadd := % code . str
    Guicontrol,, code, %codeadd%
    Guicontrol,focus,code
    Send, {END}   
}

btn:
GuiControlGet, btnname,, % A_GuiControl
if (btnname == "exp")
    btnname := "**"
sendEdit(btnname)
return


setUnits(units){
global

    Guicontrol,, from, % "|" unitsObj[units].boxList
    Guicontrol,, to, % "|" unitsObj[units].boxList
    if (units = "Physical Constants" || units = "Mathematical Constants"){
        Guicontrol,Hide, to
        Guicontrol,Hide, swap
    } else {
        Guicontrol,Show, to
        Guicontrol,Show, swap
    }
}



units:
Gui, submit, nohide

if (units = "CALCULATOR")
    Guicontrol,focus,code

ele := 
(LTrim Join
["Code","Res","gone","memrec","Help","Evaluate","Clear","multiply",
"divide","add","subtract","exponent","equals","lparen","rparen"]
)

for k, v in ele{
    if (units = "CALCULATOR")
        Guicontrol,Show, % v
    else
        Guicontrol,Hide, % v
}

for k, v in ["tot","rez","from","to","To:","goaway","gobyebye","mem","equal"]{
    if (units = "CALCULATOR")
        Guicontrol,Hide, % v
    else
        Guicontrol,Show, % v
}


if (units != "CALCULATOR"){
    setUnits(units)
}

gosub, calc
return

calc:
gui, submit, nohide
SetFormat, Float, 0.16E


ff := unitsValue[from]
tt := unitsValue[to]

val:=(ff/tt)*tot

;msgbox % from "`n" to "`n" 

;Temperature Equation - SPECIAL CASE
If (units == "Temperature"){
   value := convert_tmp(tot,  from,    "Kelvin")
   val := convert_tmp(value, "Kelvin",  to)
}

;Physical Constants - SPECIAL CASE
If (Units="Physical Constants"){
     val := unitsValue[From]
}

;Mathematical Constants - SPECIAL CASE
If (Units = "Mathematical Constants"){
     val := unitsValue[From]
}

if pre
   SetFormat, float, %RegP%E
else
   SetFormat, float, %RegP%
val := val + 0
guicontrol,, rez, %val%
return

convert_tmp(ttl, from, to){

    k := 
    (LTrim Join
    {
    "Kelvin"    : [ttl             , ttl], 
    "Celsius"   : [ttl-273.15      , ttl+273.15],
    "Fahrenheit": [ttl*(9/5)-459.67, (ttl+459.67)*5/9],  
    "Rankine"   : [ttl*(9/5)       , ttl*5/9], 
    "Reaumur"   : [(ttl-273.15)*4/5, ttl*5/4+273.15]
    }
    )
    if (to == "Kelvin")
        return k[from].2
    else
        return k[to].1
}


;=============================================================================================================
;=============================================================================================================
;=============================================================================================================
; Expression Evaluation code by Laszlo at http://www.autohotkey.com/forum/viewtopic.php?t=17058
;
; ALL THE CODE FROM HERE AND BELOW IS ONLY FOR CALCULATOR / EXPRESSION EVALUATOR!!
;
;=============================================================================================================


SetFormat Float, 0.16e                         ; max precise AHK internal format

ButtonHelp:                                    ; Alt-H

If units=CALCULATOR
{
   MsgBox,                                     ; list of shortcuts, functions
(
Shortcut commands:
   Alt-V, Enter: evaluate expression
   Alt-c, Clear: clear calculator

Functions (AHK's and the following):

   MONSTER Version 1.1 (needs AHK 1.0.46.12+)
   EVALUATE ARITHMETIC EXPRESSIONS containing HEX, Binary ('1001), scientific numbers (1.2e+5)
   (..); variables, constants: e, pi;
   (? :); logicals ||; &&; relationals =,<>; <,>,<=,>=; user operators GCD,MIN,MAX,Choose;
   |; ^; &; <<, >>; +, -; *, /, \ (or  = mod); ** (or @ = power); !,~;
   
   Functions AHK's and Abs|Ceil|Exp|Floor|Log|Ln|Round|Sqrt|Sin|Cos|Tan|ASin|ACos|ATan|SGN|Fib|fac;
   User defined functions: f(x) := expr;

Math Constants:
   pi = pi       e = e

)
}
Return

Eval(x) {                              ; non-recursive PRE/POST PROCESSING: I/O forms, numbers, ops, ";"
   Local FORM, FormF, FormI, i, W, y, y1, y2, y3, y4
   FormI := A_FormatInteger, FormF := A_FormatFloat

   SetFormat Integer, D                ; decimal intermediate results!
   RegExMatch(x, "\$(b|h|x|)(\d*[eEgG]?)", y)
   FORM := y1, W := y2                 ; HeX, Bin, .{digits} output format
   SetFormat FLOAT, 0.16e              ; Full intermediate float precision
   StringReplace x, x, %y%             ; remove $..
   Loop
      If RegExMatch(x, "i)(.*)(0x[a-f\d]*)(.*)", y)
         x := y1 . y2+0 . y3           ; convert hex numbers to decimal
      Else Break
   Loop
      If RegExMatch(x, "(.*)'([01]*)(.*)", y)
         x := y1 . FromBin(y2) . y3    ; convert binary numbers to decimal: sign = first bit
      Else Break
   x := RegExReplace(x,"(^|[^.\d])(\d+)(e|E)","$1$2.$3") ; add missing '.' before E (1e3 -> 1.e3)
                                       ; literal scientific numbers between ‘ and ’ chars
   x := RegExReplace(x,"(\d*\.\d*|\d)([eE][+-]?\d+)","‘$1$2’")

   StringReplace x, x,`%, \, All       ; %  -> \ (= MOD)
   StringReplace x, x, **,@, All       ; ** -> @ for easier process
   StringReplace x, x, +, ±, All       ; ± is addition
   x := RegExReplace(x,"(‘[^’]*)±","$1+") ; ...not inside literal numbers
   StringReplace x, x, -, ¬, All       ; ¬ is subtraction
   x := RegExReplace(x,"(‘[^’]*)¬","$1-") ; ...not inside literal numbers

   Loop Parse, x, `;
      y := Eval1(A_LoopField)          ; work on pre-processed sub expressions
                                       ; return result of last sub-expression (numeric)
   If FORM = b                         ; convert output to binary
      y := W ? ToBinW(Round(y),W) : ToBin(Round(y))
   Else If (FORM="h" or FORM="x") {
      if pre
         SetFormat, float, %RegP%E
      else
         SetFormat, float, %RegP%
;      SetFormat Integer, Hex           ; convert output to hex
      y := Round(y) + 0
   }
   Else {
      W := W="" ? "0.6g" : "0." . W    ; Set output form, Default = 6 decimal places
      if pre
         SetFormat, float, %RegP%E
      else
         SetFormat, float, %RegP%
;      SetFormat FLOAT, %W%
      y += 0.0
   }
   if pre
      SetFormat, float, %RegP%E
   else
      SetFormat, float, %RegP%
;   SetFormat Integer, %FormI%          ; restore original formats
;   SetFormat FLOAT,   %FormF%
   Return y
}

Eval1(x) {                             ; recursive PREPROCESSING of :=, vars, (..) [decimal, no ";"]
   Local i, y, y1, y2, y3
                                       ; save function definition: f(x) := expr
   If RegExMatch(x, "(\S*?)\((.*?)\)\s*:=\s*(.*)", y) {
      f%y1%__X := y2, f%y1%__F := y3
      Return
   }
                                       ; execute leftmost ":=" operator of a := b := ...
   If RegExMatch(x, "(\S*?)\s*:=\s*(.*)", y) {
      y := "x" . y1                    ; user vars internally start with x to avoid name conflicts
      Return %y% := Eval1(y2)
   }
                                       ; here: no variable to the left of last ":="
   x := RegExReplace(x,"([\)’.\w]\s+|[\)’])([a-z_A-Z]+)","$1«$2»")  ; op -> «op»

   x := RegExReplace(x,"\s+")          ; remove spaces, tabs, newlines

   x := RegExReplace(x,"([a-z_A-Z]\w*)\(","'$1'(") ; func( -> 'func'( to avoid atan|tan conflicts

   x := RegExReplace(x,"([a-z_A-Z]\w*)([^\w'»’]|$)","%x$1%$2") ; VAR -> %xVAR%
   x := RegExReplace(x,"(‘[^’]*)%x[eE]%","$1e") ; in numbers %xe% -> e
   x := RegExReplace(x,"‘|’")          ; no more need for number markers
   Transform x, Deref, %x%             ; dereference all right-hand-side %var%-s

   Loop {                              ; find last innermost (..)
      If RegExMatch(x, "(.*)\(([^\(\)]*)\)(.*)", y)
         x := y1 . Eval@(y2) . y3      ; replace (x) with value of x
      Else Break
   }

   Return Eval@(x)
}

Eval@(x) {                             ; EVALUATE PRE-PROCESSED EXPRESSIONS [decimal, NO space, vars, (..), ";", ":="]
   Local i, y, y1, y2, y3, y4

   If x is number                      ; no more operators left
      Return x
                                       ; execute rightmost ?,: operator
   RegExMatch(x, "(.*)(\?|:)(.*)", y)
   IfEqual y2,?,  Return Eval@(y1) ? Eval@(y3) : ""
   IfEqual y2,:,  Return ((y := Eval@(y1)) = "" ? Eval@(y3) : y)

   StringGetPos i, x, ||, R            ; execute rightmost || operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) || Eval@(SubStr(x,3+i))
   StringGetPos i, x, &&, R            ; execute rightmost && operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) && Eval@(SubStr(x,3+i))
                                       ; execute rightmost =, <> operator
   RegExMatch(x, "(.*)(?<![\<\>])(\<\>|=)(.*)", y)
   IfEqual y2,=,  Return Eval@(y1) =  Eval@(y3)
   IfEqual y2,<>, Return Eval@(y1) <> Eval@(y3)
                                       ; execute rightmost <,>,<=,>= operator
   RegExMatch(x, "(.*)(?<![\<\>])(\<=?|\>=?)(?![\<\>])(.*)", y)
   IfEqual y2,<,  Return Eval@(y1) <  Eval@(y3)
   IfEqual y2,>,  Return Eval@(y1) >  Eval@(y3)
   IfEqual y2,<=, Return Eval@(y1) <= Eval@(y3)
   IfEqual y2,>=, Return Eval@(y1) >= Eval@(y3)
                                       ; execute rightmost user operator (low precedence)
   RegExMatch(x, "i)(.*)«(.*?)»(.*)", y)
   IfEqual y2,choose,Return Choose(Eval@(y1),Eval@(y3))
   IfEqual y2,Gcd,   Return GCD(   Eval@(y1),Eval@(y3))
   IfEqual y2,Min,   Return (y1:=Eval@(y1)) < (y3:=Eval@(y3)) ? y1 : y3
   IfEqual y2,Max,   Return (y1:=Eval@(y1)) > (y3:=Eval@(y3)) ? y1 : y3

   StringGetPos i, x, |, R             ; execute rightmost | operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) | Eval@(SubStr(x,2+i))
   StringGetPos i, x, ^, R             ; execute rightmost ^ operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) ^ Eval@(SubStr(x,2+i))
   StringGetPos i, x, &, R             ; execute rightmost & operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) & Eval@(SubStr(x,2+i))
                                       ; execute rightmost <<, >> operator
   RegExMatch(x, "(.*)(\<\<|\>\>)(.*)", y)
   IfEqual y2,<<, Return Eval@(y1) << Eval@(y3)
   IfEqual y2,>>, Return Eval@(y1) >> Eval@(y3)
                                       ; execute rightmost +- (not unary) operator
   RegExMatch(x, "(.*[^!\~±¬\@\*/\\])(±|¬)(.*)", y) ; lower precedence ops already handled
   IfEqual y2,±,  Return Eval@(y1) + Eval@(y3)
   IfEqual y2,¬,  Return Eval@(y1) - Eval@(y3)
                                       ; execute rightmost */% operator
   RegExMatch(x, "(.*)(\*|/|\\)(.*)", y)
   IfEqual y2,*,  Return Eval@(y1) * Eval@(y3)
   IfEqual y2,/,  Return Eval@(y1) / Eval@(y3)
   IfEqual y2,\,  Return Mod(Eval@(y1),Eval@(y3))
                                       ; execute rightmost power
   StringGetPos i, x, @, R
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) ** Eval@(SubStr(x,2+i))
                                       ; execute rightmost function, unary operator
   If !RegExMatch(x,"(.*)(!|±|¬|~|'(.*)')(.*)", y)
      Return x                         ; no more function (y1 <> "" only at multiple unaries: --+-)
   IfEqual y2,!,Return Eval@(y1 . !y4) ; unary !
   IfEqual y2,±,Return Eval@(y1 .  y4) ; unary +
   IfEqual y2,¬,Return Eval@(y1 . -y4) ; unary - (they behave like functions)
   IfEqual y2,~,Return Eval@(y1 . ~y4) ; unary ~
   If IsLabel(y3)
      GoTo %y3%                        ; built-in functions are executed last: y4 is number
   Return Eval@(y1 . Eval1(RegExReplace(f%y3%__F, f%y3%__X, y4))) ; user defined function
Abs:
   Return Eval@(y1 . Abs(y4))
Ceil:
   Return Eval@(y1 . Ceil(y4))
Exp:
   Return Eval@(y1 . Exp(y4))
Floor:
   Return Eval@(y1 . Floor(y4))
Log:
   Return Eval@(y1 . Log(y4))
Ln:
   Return Eval@(y1 . Ln(y4))
Round:
   Return Eval@(y1 . Round(y4))
Sqrt:
   Return Eval@(y1 . Sqrt(y4))
Sin:
   Return Eval@(y1 . Sin(y4))
Cos:
   Return Eval@(y1 . Cos(y4))
Tan:
   Return Eval@(y1 . Tan(y4))
ASin:
   Return Eval@(y1 . ASin(y4))
ACos:
   Return Eval@(y1 . ACos(y4))
ATan:
   Return Eval@(y1 . ATan(y4))
Sgn:
   Return Eval@(y1 . (y4>0)) ; Sign of x = (x>0)-(x<0)
Fib:
   Return Eval@(y1 . Fib(y4))
Fac:
   Return Eval@(y1 . Fac(y4))
}

ToBin(n) {      ; Binary representation of n. 1st bit is SIGN: -8 -> 1000, -1 -> 1, 0 -> 0, 8 -> 01000
   Return n=0||n=-1 ? -n : ToBin(n>>1) . n&1
}
ToBinW(n,W=8) { ; LS W-bits of Binary representation of n
   Loop %W%     ; Recursive (slower): Return W=1 ? n&1 : ToBinW(n>>1,W-1) . n&1
      b := n&1 . b, n >>= 1
   Return b
}
FromBin(bits) { ; Number converted from the binary "bits" string, 1st bit is SIGN
   n = 0
   Loop Parse, bits
      n += n + A_LoopField
   Return n - (SubStr(bits,1,1)<<StrLen(bits))
}

GCD(a,b) {      ; Euclidean GCD
   Return b=0 ? Abs(a) : GCD(b, mod(a,b))
}
Choose(n,k) {   ; Binomial coefficient
   p := 1, i := 0, k := k < n-k ? k : n-k
   Loop %k%                   ; Recursive (slower): Return k = 0 ? 1 : Choose(n-1,k-1)*n//k
      p *= (n-i)/(k-i), i+=1  ; FOR INTEGERS: p *= n-i, p //= ++i
   Return Round(p)
}

Fib(n) {        ; n-th Fibonacci number (n < 0 OK, iterative to avoid globals)
   a := 0, b := 1
   Loop % abs(n)-1
      c := b, b += a, a := c
   Return n=0 ? 0 : n>0 || n&1 ? b : -b
}
fac(n) {        ; n!
   Return n<2 ? 1 : n*fac(n-1)
}
