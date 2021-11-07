;===============================================================================
; @file AdventStage.ahk
; @author hbesthee@naver.com
; @date 2021-01-16
;
; @description AdventStage 도우미 스크립트
;
;===============================================================================


hwndSubWin := DllCall( "FindWindow", "str", "subWin", "str", "sub")
; Top Level (Desktop 바로 하위 윈도우) 윈도우만 검색이 가능함



	g_hwndAppPlayerClient := 0
	strTitle = AppPlayer2
	g_hwndAppPlayer := WinExist( strTitle )
	If ( g_hwndAppPlayer )
	{
		hwndChild1 := 0
		while (1)
		{
			hwndChild1 := DllCall( "FindWindowEx", "uint", g_hwndAppPlayer, "uint", hwndChild1, "str", "Qt5QWindowIcon", "str", "Nox")
			If (hwndChild1 = 0)
				break

			hwndChild2 := 0
			while (1)
			{
				hwndChild2 := DllCall( "FindWindowEx", "uint", hwndChild1, "uint", hwndChild2, "str", "Qt5QWindowIcon", "str", "Nox")
				if (hwndChild2 = 0)
					break

				hwndChild3 := 0
				while (1)
				{
					hwndChild3 := DllCall( "FindWindowEx", "uint", hwndChild2, "uint", hwndChild3, "str", "Qt5QWindowIcon", "str", "Nox")
					if (hwndChild3 = 0)
						break

					g_hwndAppPlayerClient := hwndChild3
					break
					;g_hwndAppPlayerClient := DllCall( "FindWindowEx", "uint", hwndChild2, "uint", hwndChild3, "str", "Qt5QWindowIcon", "str", "Nox")
				}
				if (g_hwndAppPlayerClient != 0)
					break
			}
			if (g_hwndAppPlayerClient != 0)
				break
		}

		VarSetCapacity( ptLeftTop, 8, 0 ), NumPut(ptLeftTop, 0, "Int"), NumPut(ptLeftTop, 0, "Int")
		DllCall( "ClientToScreen", UInt, g_hwndAppPlayerClient, Ptr, &ptLeftTop )
		g_nClientX := NumGet(ptLeftTop, 0, "Int"), g_nClientY := NumGet(ptLeftTop, 4, "Int") ; Client 영역의 L, T를 스크린 좌표 기준으로 구함
		; g_nClientX := 1094, g_nClientY := 32
		;return g_hwndAppPlayerClient
	}

