#include <Array.au3>
WinWaitActive("Microsoft Minesweeper")
;WinSetState("Microsoft Minesweeper", "", @SW_MAXIMIZE)
WinGetHandle("Microsoft Minesweeper")
HotKeySet("{ESC}", "Terminate")

; Initialization
Func Initialize()
   Global $table[9][9] = [["B", "B", "B", "B", "B", "B", "B", "B", "B"], _
			["B", "B", "B", "B", "B", "B", "B", "B", "B"], _
			["B", "B", "B", "B", "B", "B", "B", "B", "B"], _
			["B", "B", "B", "B", "B", "B", "B", "B", "B"], _
			["B", "B", "B", "B", "B", "B", "B", "B", "B"], _
			["B", "B", "B", "B", "B", "B", "B", "B", "B"], _
			["B", "B", "B", "B", "B", "B", "B", "B", "B"], _
			["B", "B", "B", "B", "B", "B", "B", "B", "B"], _
			["B", "B", "B", "B", "B", "B", "B", "B", "B"]]
   Global $table_dup[9][9] = [["B", "B", "B", "B", "B", "B", "B", "B", "B"], _
			["B", "B", "B", "B", "B", "B", "B", "B", "B"], _
			["B", "B", "B", "B", "B", "B", "B", "B", "B"], _
			["B", "B", "B", "B", "B", "B", "B", "B", "B"], _
			["B", "B", "B", "B", "B", "B", "B", "B", "B"], _
			["B", "B", "B", "B", "B", "B", "B", "B", "B"], _
			["B", "B", "B", "B", "B", "B", "B", "B", "B"], _
			["B", "B", "B", "B", "B", "B", "B", "B", "B"], _
			["B", "B", "B", "B", "B", "B", "B", "B", "B"]]
   Global $flag = 0
   Global $wall_b[0][2]
   Global $wall_num[0][2]
   Global $cnt_click = 0
   Global $x_middle = 542
   Global $y_middle = 187




   Global $cnt_e = 0

   MouseClick("", 800, 445, 2, 0)
EndFunc

For $stat = 1 to 100
   Sleep(1000)
   Initialize()
   While True
	  Control()
	  If $cnt_e >= 1 Then
		 ExitLoop(1)
	  EndIf
   WEnd
   Sleep(1000)
   MouseClick("", 586, 642, 2, 0)
Next
MsgBox($MB_OK, "End_script", "Finished " & $stat - 1 & " Rounds")

Func Control()
   $cnt_click = 0
   Sleep(213)
   For $row = 0 To 8
	  For $col = 0 To 8
		 If $table[$row][$col] = "B" Then
			Get_color($row, $col)
		 EndIf
	  Next
   Next
   ;_ArrayDisplay($table, "After get color table")
   ;_ArrayDisplay($table_dup, "table_dup")
   For $row = 0 To 8
	  For $col = 0 To 8
		 If IsInt($table[$row][$col]) And Not($table[$row][$col] = $table_dup[$row][$col]) Then
			Neighbor($row, $col)
		 ElseIf $table[$row][$col] = "B" And $flag = 10 Then
			MouseClick("", $x_middle + 64.5 * $col, $y_middle + 64.5 * $row, 1, 0)
		 EndIf
	  Next
   Next

   ;_ArrayDisplay($table, "After Neighbor table")

   If $cnt_click = 0 Then
	  For $row = 0 to 8
		 For $col = 0 to 8
			If Not($table[$row][$col] = $table_dup[$row][$col]) Or $table_dup[$row][$col] = "B" Then
			   Get_wall($row, $col)
			EndIf
		 Next
	  Next

	  ;_ArrayDisplay($wall_b, "wall_b")
	  ;_ArrayDisplay($wall_num, "wall_num")

	  Local $sim = Simulation()
	  Probability($sim)

	  ;Rnd_click()
   EndIf

   _ArrayDelete($wall_b, "0-" & String(UBound($wall_b) - 1))
   _ArrayDelete($wall_num, "0-" & String(UBound($wall_num) - 1))

   End_game()
EndFunc

; Scan windows
Func Get_color(ByRef $row, ByRef $col)

   $x_left = 533 + 64.5 * $col
   $y_top = 174 + 64.5 * $row
   $x_right = 552 + 64.5 * $col
   $y_bottom = 200 + 64.5 * $row

   If Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0x80D7FF, 6) = 0) Then
	  $table[$row][$col] = "B"
   ElseIf Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0x19BBDE, 20) = 0) Then
	  $table[$row][$col] = 1
   ElseIf Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0x5E7A1B, 20) = 0) Then
	  $table[$row][$col] = 2
   ElseIf Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0xC70000) = 0) Then
	  $table[$row][$col] = "F"
	  $table_dup[$row][$col] = "F"
	  $flag += 1
   ElseIf Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0xBD1D59, 14) = 0) Then
	  $table[$row][$col] = 3
   ElseIf Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0x1A57C7, 6) = 0) Then
	  $table[$row][$col] = 4
   ElseIf Not(PixelSearch($x_left, $y_top, $x_right, $y_bottom, 0xB91F1F, 6) = 0) Then
	  $table[$row][$col] = 5
   Else
	  $table[$row][$col] = "W"
	  $table_dup[$row][$col] = "W"
   EndIf
EndFunc

; Neighbor 3x3 grid
Func Neighbor(ByRef $row, ByRef $col)
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
	  MouseClick("Middle", $x_middle + 64.5 * $col, $y_middle + 64.5 * $row, 1, 0)
	  $cnt_click += 1
   ElseIf UBound($list_b) + UBound($list_f) = $table[$row][$col] Then
	  Right_click($list_b)
	  $cnt_click += 1
   EndIf
EndFunc

; Marked flag
Func Right_click(ByRef $list_b)
   For $i = 0 to UBound($list_b) - 1
	  MouseClick("Right", $x_middle + 64.5 * $list_b[$i][1], $y_middle + 64.5 * $list_b[$i][0], 1, 0)
	  $table[$list_b[$i][0]][$list_b[$i][1]] = "F"
	  $table_dup[$list_b[$i][0]][$list_b[$i][1]] = "F"
   Next
   $flag += UBound($list_b)
EndFunc

; Get wall if Neighbor() doesn't work
Func Get_wall(ByRef $row, ByRef $col)
   Local $fill[1][2] = [[$row, $col]]

   ; Trigger blue wall
   If $table[$row][$col] = "B" Then
	  For $drow = -1 To 1
		 For $dcol = -1 To 1
			If $drow = 0 And $dcol = 0 Then
			   ContinueLoop(1)
			EndIf
			$new_row = $row + $drow
			$new_col = $col + $dcol
			If $new_row >= 0 And $new_row <= 8 And $new_col >= 0 And $new_col <= 8 And IsInt($table[$new_row][$new_col]) Then
			   _ArrayAdd($wall_b, $fill)
			   ExitLoop(2)
			EndIf
		 Next
	  Next
   ; Trigger number wall
   ElseIf IsInt($table[$row][$col]) Then
	  For $drow = -1 To 1
		 For $dcol = -1 To 1
			If $drow = 0 And $dcol = 0 Then
			   ContinueLoop(1)
			EndIf
			$new_row = $row + $drow
			$new_col = $col + $dcol
			If $new_row >= 0 And $new_row <= 8 And $new_col >= 0 And $new_col <= 8 And $table[$new_row][$new_col] = "B" Then
			   _ArrayAdd($wall_num, $fill)
			   ExitLoop(2)
			EndIf
		 Next
	  Next
   EndIf
EndFunc

; nCr
Func Simulation()
   Local $list_p[0][UBound($wall_b)]
   Local $cnt_b = UBound($wall_b)
   If $cnt_b > 20 Then
	  Rnd_click()
   Else
	  Local $seq[0]
	  For $i = 0 To $cnt_b - 1
		 _ArrayAdd($seq, $i)
	  Next
	  ; seq = [0, 1, 2, 3, 4]
	  Local $bomb = 10 - $flag
	  For $k = $bomb To 1 Step -1
		 Local $nCr = _ArrayCombinations($seq, $k, ",")
		 ; nCr = [10(UBound()), 01, 02, 03, 04, 12, 13, 14, 23, 24, 34]
		 Local $cal[UBound($wall_b)]

		 ; nCr (bomb choose blue)
		 For $i = 1 To UBound($nCr) - 1
			Local $table_s = $table
			$nCr_split = StringSplit($nCr[$i], ",")
			; nCr_split = [2(UBound($)), 0, 1]
			For $j = 1 To UBound($nCr_split) - 1
			   $table_s[$wall_b[$nCr_split[$j]][0]][$wall_b[$nCr_split[$j]][1]] = "F"
			Next

			; Bomb check
			For $j = 0 To UBound($wall_num) - 1
			   Local $cnt_f = 0
			   Local $row = $wall_num[$j][0]
			   Local $col = $wall_num[$j][1]

			   ; Count bomb
			   For $drow = -1 To 1
				  For $dcol = -1 To 1
					 If $drow = 0 And $dcol = 0 Then
						ContinueLoop(1)
					 EndIf

					 $new_row = $row + $drow
					 $new_col = $col + $dcol
					 If $new_row >= 0 And $new_row <= 8 And $new_col >= 0 And $new_col <= 8 And $table_s[$new_row][$new_col] = "F" Then
						$cnt_f += 1
					 EndIf
				  Next
			   Next

			   ;MsgBox($MB_OK, "cnt_f", $cnt_f)
			   ;_ArrayDisplay($table_s, "table_s")
			   ;MsgBox($MB_OK, "row", $row)
			   ;MsgBox($MB_OK, "col", $col)

			   ; If bomb equal to num, That's correct
			   If $cnt_f = $table_s[$row][$col] Then
				  ExitLoop(0)
			   Else
				  ContinueLoop(2)
			   EndIf
			Next

			; Add to list probability
			Local $wall_p[1][UBound($wall_b)]
			For $j = 0 To UBound($wall_b) - 1
			   $wall_p[0][$j] = $table_s[$wall_b[$j][0]][$wall_b[$j][1]]
			Next

			_ArrayAdd($list_p, $wall_p)
		 Next
	  Next
	  ;_ArrayDisplay($list_p, "list_p")
	  Return $list_p
   EndIf
EndFunc

; Probability of bombs and not bombs
Func Probability(ByRef $list_p)
   Local $prob[UBound($wall_b)]
   For $col = 0 To UBound($wall_b) - 1
	  Local $prob_f = _ArrayFindAll($list_p, "F", Default, Default, Default, Default, $col)
	  $prob[$col] = UBound($prob_f) / UBound($list_p)
   Next

   Local $list_f[0][2]
   Local $list_b[0][2]
   If _ArrayMax($prob) = 1 Or _ArrayMin($prob) = 0 Then
	  For $i = 0 To UBound($wall_b) - 1
		 If $prob[$i] = 1 Then
			Local $fill[1][2] = [[$wall_b[$i][0], $wall_b[$i][1]]]
			_ArrayAdd($list_f, $fill)
		 EndIf
		 If $prob[$i] = 0 Then
			Local $fill[1][2] = [[$wall_b[$i][0], $wall_b[$i][1]]]
			_ArrayAdd($list_b, $fill)
		 EndIf
	  Next
   Else
	  Local $fill[1][2] = [[$wall_b[_ArrayMaxIndex($prob)][0], $wall_b[_ArrayMaxIndex($prob)][1]]]
	  _ArrayAdd($list_f, $fill)
   EndIf
   ;_ArrayDisplay($list_f, "list_f")
   ;_ArrayDisplay($list_b, "list_b")
   Left_click($list_b)
   End_game()
   Right_click($list_f)
EndFunc

; Marked flag
Func Left_click(ByRef $list_b)
   For $i = 0 to UBound($list_b) - 1
	  MouseClick("", $x_middle + 64.5 * $list_b[$i][1], $y_middle + 64.5 * $list_b[$i][0], 1, 0)
   Next
EndFunc

; Click element at the edge
Func Rnd_click()
   Local $cl = 0
   For $i = 0 to UBound($wall_b) - 1
	  If $wall_b[$i][1] - 1 < 0 Or $wall_b[$i][1] + 1 > 8 Or $wall_b[$i][0] - 1 < 0 Or $wall_b[$i][0] + 1 > 8 Then
		 MouseClick("Left", $x_middle + 64.5 * $wall_b[$i][1], $y_middle + 64.5 * $wall_b[$i][0], 1, 0)
		 $cl += 1
		 ExitLoop(1)
	  EndIf
   Next
   If $cl = 0 And Not(UBound($wall_b) = 0) Then
	  MouseClick("Left", $x_middle + 64.5 * $wall_b[0][1], $y_middle + 64.5 * $wall_b[0][0], 1, 0)
   EndIf
EndFunc

Func End_game()
   If Hex(PixelGetColor(457, 612), 6) = 000000 Then
	  ;MsgBox($MB_OK, "", "Finish")
	  $cnt_e += 1
	  ;Exit
   EndIf
EndFunc

; Exit
Func Terminate()
   Exit
EndFunc