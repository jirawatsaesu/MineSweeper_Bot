#include <Array.au3>
#include <MsgBoxConstants.au3>

WinWaitActive("Microsoft Minesweeper")
WinSetState("Microsoft Minesweeper", "", @SW_MAXIMIZE)
WinGetHandle("Microsoft Minesweeper")

HotKeySet("{ESC}", "Terminate")

$x_middle = 542
$y_middle = 187
MouseClick("", 800, 445, 1, 0.1)
Sleep(0.2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; all initial $atable is "B"
Global $atable[9][9]
Global $aclick[1][2] = [['','']]

While True
   Global $click = 0
   Scan_window()
   For $row = 0 to 8
	  For $column = 0 to 8
		 If Hex(PixelGetColor(457, 612), 6) = 000000 Then
			MsgBox($MB_OK, "", "Finish")
			Send("{Esc}")
		 EndIf
		 If IsInt($atable[$row][$column]) Then
			check_around($row, $column, $atable[$row][$column])
		 EndIf
	  Next
   Next
   If $click = 0 Then
	  $bWall = get_wall($atable)
	  _ArrayDisplay($bWall, "")
	  ran_click($bWall)
   EndIf
WEnd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; no duplicate scan
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; by create new array that keep row and column
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; when capture, don't care any in an array
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; don't keep "B" in an array
; Scan window check for color.
Func Scan_window()
   For $row = 0 to 8
	  For $column = 0 to 8
		 $x_left = 514 + 64.5 * $column
		 $y_top = 160 + 64.5 * $row
		 $x_right = 570 + 64.5 * $column
		 $y_bottom = 215 + 64.5 * $row
		 ;small size
		 ;$x_left = 533 + 64.5 * $column
		 ;$y_top = 174 + 64.5 * $row
		 ;$x_right = 552 + 64.5 * $column
		 ;$y_bottom = 200 + 64.5 * $row

		 If Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0x19BBDE, 20) = 0) Then
			$atable[$row][$column] = 1
		 ElseIf Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0x5E7A1B, 16) = 0) Then
			$atable[$row][$column] = 2
		 ElseIf Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0xC70000) = 0) Then
			$atable[$row][$column] = "F"
		 ElseIf Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0x80D7FF, 20) = 0) Then
			$atable[$row][$column] = "B"
		 ElseIf Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0xBD1D59, 14) = 0) Then
			$atable[$row][$column] = 3
		 ElseIf Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0x1A57C7, 6) = 0) Then
			$atable[$row][$column] = 4
		 Else
			$atable[$row][$column] = "W"
		 EndIf
	  Next
   Next
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Algorithm probablility.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Algorithm bomb count.


Func get_wall(ByRef $atable)
   Local $aWall[0][2]
   For $row = 0 to 8
	  For $column = 0 to 8
		 If $atable[$row][$column] = "B" Then

			Local $aFill[1][2] = [[$row, $column]]
			If $row - 1 >= 0 and $column - 1 >= 0 And IsInt($atable[$row-1][$column-1]) Then
			   _ArrayAdd($aWall, $aFill)

			ElseIf $row - 1 >= 0 And IsInt($atable[$row-1][$column]) Then
			   _ArrayAdd($aWall, $aFill)

			ElseIf $row - 1 >= 0 and $column + 1 <= 8 And IsInt($atable[$row-1][$column+1]) Then
			  _ArrayAdd($aWall, $aFill)

			ElseIf $column - 1 >= 0 And IsInt($atable[$row][$column-1]) Then
			  _ArrayAdd($aWall, $aFill)

			ElseIf $column + 1 <= 8 And IsInt($atable[$row][$column+1]) Then
			  _ArrayAdd($aWall, $aFill)

			ElseIf $row + 1 <= 8 and $column - 1 >= 0 And IsInt($atable[$row+1][$column-1]) Then
			  _ArrayAdd($aWall, $aFill)

			ElseIf $row + 1 <= 8 And IsInt($atable[$row+1][$column]) Then
			  _ArrayAdd($aWall, $aFill)

			ElseIf $row + 1 <= 8 and $column + 1 <= 8 And IsInt($atable[$row+1][$column+1]) Then
			  _ArrayAdd($aWall, $aFill)
			EndIf
		 EndIf
	  Next
   Next
   ;_ArrayDisplay($atable, "atable")
   _ArrayDisplay($aWall, "awll")
   Return $aWall
EndFunc

Func ran_click(ByRef $bWall)
   For $i = 0 to UBound($bWall) - 1
	  If $bWall[$i][1] - 1 < 0 Then
		 MouseClick("", $x_middle + 64.5 * $bWall[$i][1], $y_middle + 64.5 * $bWall[$i][0], 1, 0.1)
		 ExitLoop(1)
	  ElseIf $bWall[$i][1] + 1 > 8 Then
		 MouseClick("", $x_middle + 64.5 * $bWall[$i][1], $y_middle + 64.5 * $bWall[$i][0], 1, 0.1)
		 ExitLoop(1)
	  ElseIf $bWall[$i][0] - 1 < 0 Then
		 MouseClick("", $x_middle + 64.5 * $bWall[$i][1], $y_middle + 64.5 * $bWall[$i][0], 1, 0.1)
		 ExitLoop(1)
	  ElseIf $bWall[$i][0] + 1 > 8 Then
		 MouseClick("", $x_middle + 64.5 * $bWall[$i][1], $y_middle + 64.5 * $bWall[$i][0], 1, 0.1)
		 ExitLoop(1)
	  EndIf
   Next
EndFunc

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

   If UBound($table_f) = $num Then
	  ;_ArrayDisplay($aclick, "")
	  $count = 0
	  For $i = 0 to UBound($aclick, 1) - 1
		 If $aclick[$i][0] = $row And $aclick[$i][1] = $column Then
			$count += 1
		 EndIf
	  Next
 	  If Not($count = 1) Then
		 MouseClick("middle", $x_middle + 64.5 * $column, $y_middle + 64.5 * $row, 1, 0.1)
		 Local $aFill[1][2] = [[$row, $column]]
		 _ArrayAdd($aclick, $aFill)
		 $click += 1
		 ;_ArrayDisplay($aclick, "After Add")
	  EndIf
   ElseIf (UBound($table_b) + UBound($table_f)) = $num Then
	  For $i = 0 to UBound($table_b) - 1
		 MouseClick("right", $x_middle + 64.5 * $table_b[$i][1], $y_middle + 64.5 * $table_b[$i][0], 1, 0.1)
		 $atable[$table_b[$i][0]][$table_b[$i][1]] = "F"
		 $click += 1
	  Next
   EndIf


   ;If No click call Func get_wall
EndFunc

Func Terminate()
   Exit
EndFunc
