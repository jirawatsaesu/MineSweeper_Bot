#include <MsgBoxConstants.au3>
WinWaitActive("Microsoft Minesweeper")
WinSetState("Microsoft Minesweeper", "", @SW_MAXIMIZE)
WinGetHandle("Microsoft Minesweeper")

HotKeySet("{ESC}", "Terminate")

Global $color[36]
;MouseMove(469, 166, 0)
;MouseClick("left")
For $i = 0 to 3
   For $j = 0 to 8
	  MouseMove(474 + $j * 52.7, 161 + $i * 52.7, 0.5)
	  $color[$i*9 + $j] = PixelGetColor(474 + $j * 52.7, 161 + $i * 52.7)
	  Sleep(100)

	  #cs
	  If $color = 0xFFFFFF Then
		 MouseClick("right")
	  Else
		 MouseClick("Right")

	  EndIf
	  #ce
   Next
Next

MsgBox($MB_SYSTEMMODAL, "", "00: " & HEX($color[0], 2) & "     " & _
"01: " & HEX($color[1], 2) & "     " & _
"02: " & HEX($color[2], 2) & "     " & _
"03: " & HEX($color[3], 2) & "     " & _
"04: " & HEX($color[4], 2) & "     " & _
"05: " & HEX($color[5], 2) & "     " & _
"06: " & HEX($color[6], 2) & "     " & _
"07: " & HEX($color[7], 2) & "     " & _
"08: " & HEX($color[8], 2) & @CRLF & _
"10: " & HEX($color[9], 2) & "     " & _
"11: " & HEX($color[10], 2) & "     " & _
"12: " & HEX($color[11], 2) & "     " & _
"13: " & HEX($color[12], 2) & "     " & _
"14: " & HEX($color[13], 2) & "     " & _
"15: " & HEX($color[14], 2) & "     " & _
"16: " & HEX($color[15], 2) & "     " & _
"17: " & HEX($color[16], 2) & "     " & _
"18: " & HEX($color[17], 2) & @CRLF & _
"20: " & HEX($color[18], 2) & "     " & _
"21: " & HEX($color[19], 2) & "     " & _
"22: " & HEX($color[20], 2) & "     " & _
"23: " & HEX($color[21], 2) & "     " & _
"24: " & HEX($color[22], 2) & "     " & _
"25: " & HEX($color[23], 2) & "     " & _
"26: " & HEX($color[24], 2) & "     " & _
"27: " & HEX($color[25], 2) & "     " & _
"28: " & HEX($color[26], 2) & @CRLF & _
"30: " & HEX($color[27], 2) & "     " & _
"31: " & HEX($color[28], 2) & "     " & _
"32: " & HEX($color[29], 2) & "     " & _
"33: " & HEX($color[30], 2) & "     " & _
"34: " & HEX($color[31], 2) & "     " & _
"35: " & HEX($color[32], 2) & "     " & _
"36: " & HEX($color[33], 2) & "     " & _
"37: " & HEX($color[34], 2) & "     " & _
"38: " & HEX($color[35], 2))



Func Terminate()
   Exit
EndFunc