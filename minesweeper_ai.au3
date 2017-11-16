#include <Array.au3>
WinWaitActive("Microsoft Minesweeper")
WinSetState("Microsoft Minesweeper", "", @SW_MAXIMIZE)
WinGetHandle("Microsoft Minesweeper")
HotKeySet("{ESC}", "Terminate")

; Initialization
Global $table[9][9]
Global $table_dup[9][9]
Global $flag = 0
For $row = 0 To 8
   For $col = 0 To 8
	  $table[$row][$col] = "B"
	  $table_dup[$row][$col] = "B"
   Next
Next
Global $x_middle = 542
Global $y_middle = 187
MouseClick("", 800, 445, 1, 0.1)
Sleep(1)
While True
   State()
WEnd


Func State()
   For $row = 0 To 8
	  For $col = 0 To 8
		 If $table[$row][$col] = $table_dup[$row][$col] Then
			If $table_dup[$row][$col] = "B" Then
			   Get_color($row, $col)
			EndIf
		 Else
			Get_color($row, $col)
		 EndIf
	  Next
   Next

   ;_ArrayDisplay($table, "table")
   ;_ArrayDisplay($table_dup, "table_dup")
   For $row = 0 To 8
	  For $col = 0 To 8
		 If IsInt($table[$row][$col]) And Not($table[$row][$col] = $table_dup[$row][$col]) Then
		 ;If IsInt($table[$row][$col]) Then
			Neightbor($row, $col)
		 EndIf
	  Next
   Next

EndFunc

; Neightbor 3x3 grid
Func Neightbor(ByRef $row, ByRef $col)
   Local $list_b[0][2]
   Local $list_f[0][2]
   Local $new_row = 0
   Local $new_col = 0

   For $drow = -1 To 1
	  For $dcol = -1 To 1
		 If $drow = 0 And $dcol = 0 Then
			ContinueLoop(1)
		 EndIf

		 ; Count B and F
		 $new_row = $row + $drow
		 $new_col = $col + $dcol
		 If $new_row >= 0 And $new_row <= 8 And $new_col >= 0 And $new_col <= 8 Then
			If $table[$new_row][$new_col] = "B" Then
			   Local $fill[1][2] = [[$new_row, $new_col]]
			   _ArrayAdd($list_b, $fill)
			EndIf
			If $table[$new_row][$new_col] = "F" Then
			   Local $fill[1][2] = [[$new_row, $new_col]]
			   _ArrayAdd($list_f, $fill)
			EndIf
		 EndIf

	  Next
   Next

   If UBound($list_b) = 0 Then
	  $table_dup[$row][$col] = $table[$row][$col]
   ElseIf UBound($list_f) = $table[$row][$col] Then
	  MouseClick("Middle", $x_middle + 64.5 * $col, $y_middle + 64.5 * $row, 1, 0.1)
   ElseIf UBound($list_b) + UBound($list_f) = $table[$row][$col] Then
	  Left_click($list_b)
   EndIf
EndFunc

; Marked flag
Func Left_click(ByRef $list_b)
   For $i = 0 to UBound($list_b) - 1
	  MouseClick("Right", $x_middle + 64.5 * $list_b[$i][1], $y_middle + 64.5 * $list_b[$i][0], 1, 0.1)
	  $table[$list_b[$i][0]][$list_b[$i][1]] = "F"
	  $table_dup[$list_b[$i][0]][$list_b[$i][1]] = "F"
   Next
   $flag += UBound($list_b)
EndFunc

; Scan windows
Func Get_color(ByRef $row, ByRef $col)
   ; Can smaller
   $x_left = 514 + 64.5 * $col
   $y_top = 160 + 64.5 * $row
   $x_right = 570 + 64.5 * $col
   $y_bottom = 215 + 64.5 * $row

   If Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0x19BBDE, 20) = 0) Then
	  $table[$row][$col] = 1
   ElseIf Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0x5E7A1B, 16) = 0) Then
	  $table[$row][$col] = 2
   ElseIf Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0x80D7FF, 20) = 0) Then
	  $table[$row][$col] = "B"
   ElseIf Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0xC70000) = 0) Then
	  $table[$row][$col] = "F"
	  $table_dup[$row][$col] = "F"
   ElseIf Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0xBD1D59, 14) = 0) Then
	  $table[$row][$col] = 3
   ElseIf Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0x1A57C7, 6) = 0) Then
	  $table[$row][$col] = 4
   Else
	  $table[$row][$col] = "W"
	  $table_dup[$row][$col] = "W"
   EndIf
EndFunc

; Exit
Func Terminate()
   Exit
EndFunc