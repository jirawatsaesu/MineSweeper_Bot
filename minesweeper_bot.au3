#include <Array.au3>

WinWaitActive("Microsoft Minesweeper")
WinSetState("Microsoft Minesweeper", "", @SW_MAXIMIZE)
WinGetHandle("Microsoft Minesweeper")

HotKeySet("{ESC}", "Terminate")

$x_middle = 542
$y_middle = 187
MouseClick("", 800, 445, 1, 0.1)
Sleep(0.5)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; all initial $atable is "B"
Global $atable[9][9]

While True
   Scan_window()
   For $row = 0 to 8
	  For $column = 0 to 8
		 ;MouseMove($x_middle + 64.5 * $column, $y_middle + 64.5 * $row, 0.1)
		 ;If Hex(PixelGetColor(457, 612), 6) = 000000 Then ExitLoop(3)
		 If IsInt($atable[$row][$column]) Then
			check_around($row, $column, $atable[$row][$column])
		 EndIf
	  Next
   Next
WEnd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; no duplicate scan
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; by create new array that keep row and column
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; when capture, don't care any in an array
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; don't keep "B" in an array
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End game??
; Scan window check for color.
Func Scan_window()
   For $row = 0 to 8
	  For $column = 0 to 8
		 $x_left = 514 + 64.5 * $column
		 $y_top = 160 + 64.5 * $row
		 $x_right = 570 + 64.5 * $column
		 $y_bottom = 215 + 64.5 * $row
		 $color_1 = PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0x19BBDE, 20)
		 $color_2 = PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0x5E7A1B, 16)
		 $color_3 = PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0xBD1D59, 14)
		 $color_4 = PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0x1A57C7, 6)
		 $color_B = PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0x80D7FF, 16)
		 $color_W = PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0xFFFFFF)
		 $color_F = PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0xC70000)

		 If Not($color_1 = 0) Then
			$atable[$row][$column] = 1
		 ElseIf Not($color_2 = 0) Then
			$atable[$row][$column] = 2
		 ElseIf Not($color_3 = 0) Then
			$atable[$row][$column] = 3
		 ElseIf Not($color_4 = 0) Then
			$atable[$row][$column] = 4
		 ElseIf Not($color_B = 0) Then
			$atable[$row][$column] = "B"
		 ElseIf Not($color_W = 0) Then
			$atable[$row][$column] = "W"
		 ElseIf Not($color_F = 0) Then
			$atable[$row][$column] = "F"
		 Else
			$num = 0
		 EndIf
	  Next
   Next
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Algorithm the lease chance of row and column of bomb
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Algorithm random click
; Check around of current row and column.
Func check_around(ByRef $row, ByRef $column, ByRef $num)
   Local $table_b[0][2]
   Local $table_f[0][2]

   ; Check
   If $atable[$row][$column] = $num Then
	  If $row - 1 >= 0 and $column - 1 >= 0 Then
		 If $atable[$row-1][$column-1] = "F" Then
			Local $aFill[1][2] = [[$row - 1, $column - 1]]
			_ArrayAdd($table_f, $aFill)
		 EndIf
		 If $atable[$row-1][$column-1] = "B" Then
			Local $aFill[1][2] = [[$row - 1, $column - 1]]
			_ArrayAdd($table_b, $aFill)
		 EndIf
	  EndIf

	  If $row - 1 >= 0 Then
		 If $atable[$row-1][$column] = "F" Then
			Local $aFill[1][2] = [[$row - 1, $column]]
			_ArrayAdd($table_f, $aFill)
		 EndIf
		 If $atable[$row-1][$column] = "B" Then
			Local $aFill[1][2] = [[$row - 1, $column]]
			_ArrayAdd($table_b, $aFill)
		 EndIf
	  EndIf

	  If $row - 1 >= 0 and $column + 1 <= 8 Then
		 If $atable[$row-1][$column+1] = "F" Then
			Local $aFill[1][2] = [[$row - 1, $column + 1]]
			_ArrayAdd($table_f, $aFill)
		 EndIf
		 If $atable[$row-1][$column+1] = "B" Then
			Local $aFill[1][2] = [[$row - 1, $column + 1]]
			_ArrayAdd($table_b, $aFill)
		 EndIf
	  EndIf

	  If $column - 1 >= 0 Then
		 If $atable[$row][$column-1] = "F" Then
			Local $aFill[1][2] = [[$row, $column - 1]]
			_ArrayAdd($table_f, $aFill)
		 EndIf
		 If $atable[$row][$column-1] = "B" Then
			Local $aFill[1][2] = [[$row, $column - 1]]
			_ArrayAdd($table_b, $aFill)
		 EndIf
	  EndIf

	  If $column + 1 <= 8 Then
		 If $atable[$row][$column+1] = "F" Then
			Local $aFill[1][2] = [[$row, $column + 1]]
			_ArrayAdd($table_f, $aFill)
		 EndIf
		 If $atable[$row][$column+1] = "B" Then
			Local $aFill[1][2] = [[$row, $column + 1]]
			_ArrayAdd($table_b, $aFill)
		 EndIf
	  EndIf

	  If $row + 1 <= 8 and $column - 1 >= 0 Then
		 If $atable[$row+1][$column-1] = "F" Then
			Local $aFill[1][2] = [[$row + 1, $column - 1]]
			_ArrayAdd($table_f, $aFill)
		 EndIf
		 If $atable[$row+1][$column-1] = "B" Then
			Local $aFill[1][2] = [[$row + 1, $column - 1]]
			_ArrayAdd($table_b, $aFill)
		 EndIf
	  EndIf

	  If $row + 1 <= 8 Then
		 If $atable[$row+1][$column] = "F" Then
			Local $aFill[1][2] = [[$row + 1, $column]]
			_ArrayAdd($table_f, $aFill)
		 EndIf
		 If $atable[$row+1][$column] = "B" Then
			Local $aFill[1][2] = [[$row + 1, $column]]
			_ArrayAdd($table_b, $aFill)
		 EndIf
	  EndIf

	  If $row + 1 <= 8 and $column + 1 <= 8 Then
		 If $atable[$row+1][$column+1] = "F" Then
			Local $aFill[1][2] = [[$row + 1, $column + 1]]
			_ArrayAdd($table_f, $aFill)
		 EndIf
		 If $atable[$row+1][$column+1] = "B" Then
			Local $aFill[1][2] = [[$row + 1, $column + 1]]
			_ArrayAdd($table_b, $aFill)
		 EndIf
	  EndIf
   EndIf

   ; Click
   If Hex(PixelGetColor(457, 612), 6) = 000000 Then
	  Send("{Esc}")
   ElseIf UBound($table_f) = $num Then
	  MouseClick("middle", $x_middle + 64.5 * $column, $y_middle + 64.5 * $row, 1, 0.1)
   ElseIf (UBound($table_b) + UBound($table_f)) = $num Then
	  For $i = 0 to UBound($table_b) - 1
		 MouseClick("right", $x_middle + 64.5 * $table_b[$i][1], $y_middle + 64.5 * $table_b[$i][0], 1, 0.1)
		 $atable[$table_b[$i][0]][$table_b[$i][1]] = "F"
	  Next
   EndIf
EndFunc

Func Terminate()
   Exit
EndFunc
