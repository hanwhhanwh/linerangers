;===============================================================================
; @file Utils_inc.ahk
; @author hbesthee@naver.com
; @date 2015-06-12
;
; @description 유용한 함수 모음
;
;===============================================================================

#include Global.ahk


; @brief CLEAR BONUS 창이 확인되면 OK를 눌러서 보상을 받는다.
; @param arrWaitingColorSet 보상 수령을 마친 후, 기다려야할 색 조합
; @return 없음.
AcceptClearBonus( arrWaitingColorSet )
{
	Global g_nClientX, g_nClientY, g_arrColorSetIsRetry

	ClickClientPoint( 400, 372, 500 ) ; 룰렛 멈추기
	ClickClientPoint( 470, 372, 1500 ) ; 보상 수령
	
	arrColorSetReonardBonus := [ [385, 76, 0xFFFFFF], [330, 391, 0x07DA46], [406, 407, 0xFFFFFF] ] ; 레오나드 보너스 색조합
	
	arrColorSetGearBox := [ [354, 386, 0x2D1708], [420, 415, 0xB0AEAD], [453, 406, 0x381C09] ]

	nLoopCount := 1
	nLoopTotal := 60 * 10

	While ( nLoopCount < nLoopTotal )
	{
		;If ( IsSameColorSet(arrWaitingColorSet) )
		If ( IsSimilarColorSet(arrWaitingColorSet, 10) )
			break

		;If ( IsSameColorSet( arrColorSetReonardBonus ) )
		If ( IsSimilarColorSet(arrColorSetReonardBonus, 10) )
		{
			AppendLogWindow( "    *** Reonard Bonus ^^ !!! ***" )
			Sleep 1500

			; 현재 마우스 위치 기록
;			WinGet, hwndActive, ID, A
;			MouseGetPos, nPrevX, nPrevY
;			nX := g_nClientX + 400
;			nY := g_nClientY + 407
;			Click, %nX%, %nY%
;			MouseMove, nPrevX, nPrevY
;			WinActivate, ahk_id %hwndActive%
;			Sleep 3500
		}

		;If ( IsSameColorSet(arrColorSetGearBox) )
		If ( IsSimilarColorSet(arrColorSetGearBox, 10) )
		{
			AppendLogWindow( "    --- Gear box ---" )
;			ClickClientPoint( 400, 400 )
			Sleep 1500
;			ClickClientPoint( 400, 400 )
;			Sleep 3500
		}

		;If ( IsSameColorSet(g_arrColorSetIsRetry) )
		If ( IsSimilarColorSet(g_arrColorSetIsRetry, 10) )
		{ ; RETRY가 나오면, RETRY 클릭 처리
			ClickClientPoint( g_ptRetryButton[0], g_ptRetryButton[1] )
			Sleep 3500
		}
		
		;If ( IsSameColorSet(arrWaitingColorSet) )
		If ( IsSimilarColorSet(arrWaitingColorSet, 10) )
			break

		ClickClientPoint( 400, 400 )
		nLoopCount := nLoopCount + 1
		Sleep 2000
	}
}



; @brief 입력한 내용을 로그 윈도우 및 파일에 기록한다.
;		로그 파일은 .\Logs\lr-yyyyMMdd.log 파일에 시각 정보를 포함하여 기록된다.
; @param strMsg 기록할 로그의 내용
AppendLogWindow(strMsg)
{
	global g_hwndLogEditControl

	FormatTime, strTime, , HH:mm:ss
	strTime .= " " . strMsg

	ControlSend, , ^{End}`n, ahk_id %g_hwndLogEditControl%
	SendMessage, 0xC2, 0, &strTime,, ahk_id %g_hwndLogEditControl%

	FormatTime, strLogFileName, , yyyyMMdd
	strLogFileName := ".\Logs\lr-" . strLogFileName . ".log"
	FileAppend, %strTime%`r`n, %strLogFileName%
}



; @brief LEVEL UP 창이 확인되면 OK를 누른다.
; @param nPosX OK 버튼을 확인할 기준(버튼의 좌측 상단) X 좌표 
; @param nPosY OK 버튼을 확인할 기준(버튼의 좌측 상단) Y 좌표 
; @return LEVEL UP 창을 찾으면 1, 그렇지 않으면 0을 반환한다.
CheckOkButton( nPosX, nPosY )
{
	Global g_nClientX, g_nClientY

	CoordMode, Pixel, Screen
	PixelGetColor, clrOutputColor1, g_nClientX + nPosX + 13, g_nClientY + nPosY + 13, RGB ; 0x07DA46
	PixelGetColor, clrOutputColor2, g_nClientX + nPosX + 60, g_nClientY + nPosY + 40, RGB ; 0x009B20
	PixelGetColor, clrOutputColor3, g_nClientX + nPosX + 65, g_nClientY + nPosY + 22, RGB ; 0xFFFFFF

	If IsSimilarColor( clrOutputColor1, 0x07DA46 ) and IsSimilarColor( clrOutputColor2, 0x009B20 ) and IsSimilarColor( clrOutputColor3, 0xFFFFFF )
	{
		return 1
	}
	else
	{
		return 0
	}
}



; @brief AppPlayer 가 실행되어 있는지 확인하여, 실행 중이면 전면으로 활성화시킨다.
;		AppPlayer 가 실행중이지 않으면 0, 실행중이라면 1을 반환한다.
CheckAppPlayer( nInstance, isActivate := false )
{
	Global g_hwndAppPlayer, g_hwndAppPlayerClient, g_nClientX, g_nClientY
	
	g_hwndAppPlayerClient := 0
	strTitle = AppPlayer%nInstance%
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

		return 1
	}
	else
	{
		ToolTip, AppPlayer%nInstance% 없음
		Sleep 500
		return 0
	}
}



; Nox AppPlayer 창을 활성화한 후에 지정한 위치를 클릭한다.
ClickActivateWIndow( nX, nY, nSleep := 1000 )
{
	Global g_nClientX, g_nClientY

	;AppendLogWindow( "    g_nClientX = " . g_nClientX . "  g_nClientY = " . g_nClientY)
	;AppendLogWindow( "    nX = " . nX . "  nY = " . nY)

	; 현재 마우스 위치 기록
	WinGet, hwndActive, ID, A
	MouseGetPos, nPrevX, nPrevY
	nScreenX := g_nClientX + nX
	nScreenY := g_nClientY + nY
	Click, %nScreenX%, %nScreenY%
	MouseMove, nPrevX, nPrevY
	WinActivate, ahk_id %hwndActive%
	Sleep %nSleep%
}



; @brief 입력한 좌표에 마우스 클릭 동작을 한다.
; @param arrPoint 클릭 동작을 할 좌표가 들어있는 배열( 1 = X좌표, 2 = Y좌표 )
; @param nPosY 클릭 동작을 할 Y 좌표값 (절대좌표)
ClickPoint( arrPoint, nDelayTime := 0 )
{
	Global g_hwndAppPlayer, g_hwndAppPlayerClient

	If ( nDelayTime > 0 )
		Sleep % nDelayTime
	;nPosX := arrPoint[1], nPosY := arrPoint[2] ; 절대좌표를 클라이언트 좌표로 변환
	;Click %nPosX%, %nPosY%
	nPosX := arrPoint[1] - 3, nPosY := arrPoint[2] - 36 ; 절대좌표를 클라이언트 좌표로 변환
	lParam := nPosX | nPosY << 16
	;ToolTip, g_hwndAppPlayer = %g_hwndAppPlayer%  nPosX = %nPosX%  nPosY = %nPosY%  lParam = %lParam%, 250, 5
	;Sleep 2000
	PostMessage, 0x201, 1, lParam , , ahk_id %g_hwndAppPlayer% ;A ; %strTitle% ; WM_LBUTTONDOWN, MK_LBUTTON, MAKEPOINT( X, Y )
	PostMessage, 0x200, 1, lParam , , ahk_id %g_hwndAppPlayer% ;A ; %strTitle% ; WM_MOUSEMOVE, MK_LBUTTON, MAKEPOINT( X, Y )
	PostMessage, 0x202, 0, lParam , , ahk_id %g_hwndAppPlayer% ;A ; %strTitle% ; WM_LBUTTONUP, 0, MAKEPOINT( X, Y )
}



; @brief 입력한 좌표에 마우스 클릭 동작을 한다.
; @param arrPoint 클릭 동작을 할 좌표가 들어있는 배열( 1 = X좌표, 2 = Y좌표 )
; @param nPosY 클릭 동작을 할 Y 좌표값 (절대좌표)
ClickClientPoint( nX, nY, nDelayTime := 0 )
{
	Global g_hwndAppPlayerClient

	If ( nDelayTime > 0 )
		Sleep % nDelayTime
	lParam := nX | nY << 16
	PostMessage, 0x201, 1, %lParam% , , ahk_id %g_hwndAppPlayerClient% ;A ; %strTitle% ; WM_LBUTTONDOWN, MK_LBUTTON, MAKEPOINT( X, Y )
	PostMessage, 0x200, 1, %lParam% , , ahk_id %g_hwndAppPlayerClient% ;A ; %strTitle% ; WM_MOUSEMOVE, MK_LBUTTON, MAKEPOINT( X, Y )
	PostMessage, 0x202, 0, %lParam% , , ahk_id %g_hwndAppPlayerClient% ;A ; %strTitle% ; WM_LBUTTONUP, 0, MAKEPOINT( X, Y )
}



; @brief LEVEL UP 창이 확인되면 OK를 누른다.
; @return LEVEL UP 창을 찾으면 1, 그렇지 않으면 0을 반환한다.
ClickLevelUp(  )
{
	Global g_hwndAppPlayer

	Sleep 500
	
	PixelGetColor, clrOutputColor1, 490, 775, RGB ; 0x07DA46
	PixelGetColor, clrOutputColor2, 480, 800, RGB ; 0x05C232
	PixelGetColor, clrOutputColor3, 641, 808, RGB ; 0xFFFFFF

	If ( clrOutputColor1 = 0x07DA46 ) and ( clrOutputColor2 = 0x05C232 ) and ( clrOutputColor3 = 0xFFFFFF )
	{
		SendClickAbsolute( g_hwndAppPlayer, 480, 800 ) ;Click 480, 800
		Sleep 500
		return 1
	}
	else
	{
		Sleep 500
		return 0
	}
}



; @brief Teamviewer 확인창이 확인되면 Teamviewer 창을 닫는다.
; @return Teamviewer창을 찾으면 1, 그렇지 않으면 0을 반환한다.
CloseTeamviewer(  )
{
	IfWinExist, 후원 세션
	{
		;MsgBox, Teamviewer 후원 세션창을 닫습니다.
		WinActivate
		Send {Enter}
		Sleep 50
	}
	IfWinExist, Sponsored session
	{
		;MsgBox, Teamviewer 후원 세션창을 닫습니다.
		WinActivate
		Send {Enter}
		Sleep 50
	}
}


; @brief	로그 기록을 위한 윈도우를 생성한다.
CreateLogWindow()
{
	global g_hwndLogEditControl, g_nClientX, g_nClientY

	nLogY := g_nClientY+480

	Gui, +LabelGUI_
	Gui, Margin, 5, 5
	Gui, Font, s12, NanumGothicCoding
	Gui, Add, Edit, w800 h200 Hwndg_hwndLogEditControl
	Gui, Font, s10, Arial
	Gui, Add, Button, xm w130 gGUI_EXIT, Exit
	Gui, Show, x%g_nClientX% y%nLogY%
}


; @brief 디버깅용 메시지를 ToolTip으로 출력한다.
DEBUG_STR(nInstance, strMsg)
{
	ToolTip, AppPlayer%nInstance% > %strMsg%, 120 + (nInstance - 1) * 500, 5
}



; @brief 마우스를 드래깅 처리한다.
DragMouse(nStartX, nStartY, nEndX, nEndY, nDraggingTime := 200, nUpDelay := 0)
{
	Global g_hwndAppPlayerClient

	If ( nDelayTime > 0 )
		Sleep % nDelayTime
	nStep := Max(Abs(nEndY - nStartY) + 1, Abs(nEndX - nStartX) + 1), nX := nStartX, nY := nStartY, lParam := nX | nY << 16, nDX := (nEndX - nStartX) / nStep, nDY := (nEndY - nStartY) / nStep
	;PostMessage, 0x200, 0, %lParam% , , ahk_id %g_hwndAppPlayerClient%
	PostMessage, 0x201, 1, %lParam% , , ahk_id %g_hwndAppPlayerClient%
	Loop, %nStep%
	{
		lParam := nX | nY << 16, nX := nX + nDX, nY := nY + nDY
		PostMessage, 0x200, 1, %lParam% , , ahk_id %g_hwndAppPlayerClient%
		Sleep 1
	}
/*
	nDy := 0, nDx := 0
	if ( nUpDelay > 0)
		Sleep, % nUpDelay
	if ( nEndY > nStartY )
		nDy := -1
	else if ( nEndY < nStartY )
		nDy := 1
	if ( nEndX > nStartX )
		nDx := -1
	else if ( nEndX < nStartX )
		nDx := 1
	nX := nEndX + nDX, nY := nEndY + nDY, lParam := nX | nY << 16
;	Sleep 400
;	PostMessage, 0x200, 1, %lParam% , , ahk_id %g_hwndAppPlayerClient%
	Sleep 500
	PostMessage, 0x200, 1, %lParam% , , ahk_id %g_hwndAppPlayerClient%
	if ( nUpDelay > 0)
		Sleep, % nUpDelay
		
*/
	lParam := nEndX | nEndY << 16
	Sleep 100
	PostMessage, 0x200, 1, %lParam% , , ahk_id %g_hwndAppPlayerClient%
	Sleep 500
;	PostMessage, 0x200, 1, %lParam% , , ahk_id %g_hwndAppPlayerClient%
	PostMessage, 0x202, 0, %lParam% , , ahk_id %g_hwndAppPlayerClient%
	PostMessage, 0x200, 0, %lParam% , , ahk_id %g_hwndAppPlayerClient%
}



; @brief AppPlayerManager를 실행한다.
ExecuteAppPlayerManager()
{
	IfWinNotExist AppPlayerManager
	{
		;Click 1861, 36
		;Sleep 2000
		
		RegRead, strAppPlayerInstallPath, HKEY_LOCAL_MACHINE, SOFTWARE\AppPlayerBox, InstallDir
		Run, %strAppPlayerInstallPath%AppPlayerManager.exe
	}
	
	Click 782, 479 ; 첫 번째 인스턴스 선택
	
	Click 782, 518 ; 두 번째 인스턴스 선택
	
	Click 813, 404 ; Start 버튼 클릭하여 해당 인스턴스 실행
	
	WinClose, AppPlayerManager
}


; 단축 이동 버튼이 있는지 확인한다.
HasShortMoveButon()
{
	Global g_nClientX, g_nClientY

	PixelGetColor, clrOutputColor1, 20 + g_nClientX, 31 + g_nClientY, RGB ; 0xFFFFDD
	PixelGetColor, clrOutputColor2, 34 + g_nClientX, 34 + g_nClientY, RGB ; 0xFFEE44

	if ( (clrOutputColor1 = 0xFFFFDD) And (clrOutputColor2 = 0xFFEE44) )
		return true
	
	return false
}


; @brief AppPlayer 내의 마우스 이벤트를 받을 클라이언트 영역의 화면상 좌표를 초기화한다.
InitializeClientPosition()
{
	Global g_hwndAppPlayerClient, g_nClientX, g_nClientY
	
	if ( g_hwndAppPlayerClient > 0 ) 
	{
		VarSetCapacity( ptLeftTop, 8, 0 ), NumPut(ptLeftTop, 0, "Int"), NumPut(ptLeftTop, 0, "Int")
		DllCall( "ClientToScreen", UInt, g_hwndAppPlayerClient, Ptr, &ptLeftTop )
		g_nClientX := NumGet(ptLeftTop, 0, "Int"), g_nClientY := NumGet(ptLeftTop, 4, "Int") ; Client 영역의 L, T를 스크린 좌표 기준으로 구함

		return true
	}

	return false
}



; @brief 친구가 선택되어 있는지 확인한다.
; @return 친구가 선택되어 있으면 true, 그렇지 않고 선택되어 있지 않으면 false를 반환한다.
IsCheckedFriend()
{
	global g_nClientX, g_nClientY

	PixelGetColor, clrOutputColor1, 287 + g_nClientX, 327 + g_nClientY, RGB ; 0xFBC817
	PixelGetColor, clrOutputColor2, 299 + g_nClientX, 327 + g_nClientY, RGB ; 0x592509
	If ( (clrOutputColor1 = 0xFBC817) And (clrOutputColor2 = 0x592509) )
	{
		return true
	}
	else
	{
		return false
	}
}


; @brief 지정된 위치(Left, Top)에 CLOSE 버튼이 있는지 확인한다.
; @return If identify CLOSE button then return true, otherwise return false
IsCloseButton( nLeft, nTop )
{
	PixelGetColor clrOutputColor1, nLeft + 23, nTop + 20, RGB ; 0x33CCDD
	PixelGetColor clrOutputColor2, nLeft + 120, nTop + 45, RGB ; 0x1A93AD
	PixelGetColor clrOutputColor3, nLeft + 127, nTop + 45, RGB ; 0xFFFFFF
	If ( ( clrOutputColor1 = 0x33CCDD ) And ( clrOutputColor2 = 0x1A93AD ) And ( clrOutputColor3 = 0xFFFFFF ) )
	{
		;ToolTip, clrOutputColor1 = %clrOutputColor1%   clrOutputColor2 = %clrOutputColor2%   clrOutputColor3 = %clrOutputColor3%, 150, 5
		return 1 ; OK button
	}

	return 0
}


; @brief 전투가 종료되었는지 확인한다.
; @return 전투가 종료되었다면 true, 그렇지 않고 전투가 진행중이라면 false를 반환한다.
IsFinishCombat()
{
	global g_arrColorSetIsWin	= [ [292, 154, 0xFFFFFF], [470, 153, 0xFFFFFF], [505, 146, 0x000000] ]
	global g_arrColorSetIsLoss	= [ [302, 191, 0xFFDDBA], [386, 195, 0xFF9900], [490, 252, 0xFF6600] ]

	return IsSameColorSet( g_arrColorSetIsWin ) or IsSameColorSet( g_arrColorSetIsLoss )
}


; @brief Line Rangers HOME 화면인지 확인한다.
; @return HOME 화면이면 true, 그렇지 않으면 false를 반환한다.
IsHome()
{
	PixelGetColor, clrOutputColor1, 850, 440, RGB ; 0x538F11
	PixelGetColor, clrOutputColor2, 284, 854, RGB ; 0xEEBB66
	PixelGetColor, clrOutputColor3, 1414, 844, RGB ; 0xFFFFFF

	If ( clrOutputColor1 = 0x538F11 ) and ( clrOutputColor2 = 0xEEBB66 ) and ( clrOutputColor3 = 0xFFFFFF )
	{
		;ToolTip, IsHome() clrOutputColor1 = %clrOutputColor1%   clrOutputColor2 = %clrOutputColor2%   clrOutputColor3 = %clrOutputColor3%, 150, 5
		return 1 ; Clear 시 빠져 나오기
	}

	return 0
}


; @brief 지정된 위치(Left, Top)에 OK 버튼이 있는지 확인한다.
; @return If identify OK button then return true, otherwise return false
IsOkButton( nLeft, nTop )
{
	arrColorSetOkButton := [ [116, 22, 0x00BB33], [64, 22, 0xFFFFFF], [11, 11, 0x00DD44] ]
	Loop, 3
	{
		arrColorSetOkButton[A_Index][1] := arrColorSetOkButton[A_Index][1] + nLeft, arrColorSetOkButton[A_Index][2] := arrColorSetOkButton[A_Index][2] + nTop
		; AppendLogWIndow( " #" . A_Index . " X = " . arrColorSetOkButton[A_Index][1] . " Y = " . arrColorSetOkButton[A_Index][2] )
	}
	return IsSameColorSet(arrColorSetOkButton)
}


; @brief Check team battle reword window
; @return If team battle reword window identified then return true, otherwise return false
IsRewordOfTeamBattle()
{
	PixelGetColor, clrOutputColor1, 460, 150, RGB ; 0x7F00FF
	PixelGetColor, clrOutputColor2, 493, 161, RGB ; 0xFFE63D
	PixelGetColor, clrOutputColor3, 501, 150, RGB ; 0x761600
	If ( (clrOutputColor1 = 0x7F00FF) And (clrOutputColor2 = 0xFFE63D) And (clrOutputColor3 = 0x761600) )
	{
		;ToolTip, 친구 선택 clrOutputColor1 = %clrOutputColor1%   clrOutputColor2 = %clrOutputColor2%, 150, 5
		return 1
	}
	else
	{
		;ToolTip, 친구 미선택 clrOutputColor1 = %clrOutputColor1%   clrOutputColor2 = %clrOutputColor2%, 150, 5
		return 0
	}
}


; @brief	입력한 클라이언트 영역의 점의 색이 동일한지 확인한다.
; @param	arrPoint	클라이언트 영역의 점 좌표 (x, y)
; @param	nColor	비교할 색
; @return	If same color set is true, otherwise false
IsSameColor( ByRef arrPoint, ByRef nColor )
{
	global g_nClientX, g_nClientY

	PixelGetColor, clrOutputColor, arrPoint[1] + g_nClientX, arrPoint[2] + g_nClientY, RGB
	if ( clrOutputColor != nColor )
		return false

	return true
}


; @brief	AppPlayer의 클라이언트 영역에서 동일한 색 조합인지 확인한다.
; @param	arrColorSet	색조합으로 (x, y, color) 에 대한 배열이다. 배열의 최대 개수의 제한은 없으나, 성능상 4개 이하를 권장한다.
; @return	If same color set is true, otherwise false
IsSameColorSet( ByRef arrColorSet )
{
	global g_nClientX, g_nClientY

	for nIndex, arrSet in arrColorSet
	{
		PixelGetColor, clrOutputColor, arrSet[1] + g_nClientX, arrSet[2] + g_nClientY, RGB
		if ( clrOutputColor != arrSet[3] )
			return false
	}
	return true
}


/**
@brief	허용오차 범위를 두고 두 색이 유사한 색인지 확인한다.
		RGB 단위로 분리 후, 각 바이트별 허용오차 내인지 확인한다.
@param	nRgbColor1 서로 비교할 색 1
@param	nRgbColor2 서로 비교할 색 2
@param	nTolerance +- 허용오차 값
@return	If similar color is true, otherwise false
*/
IsSimilarColor(nRgbColor1, nRgbColor2, nTolerance = 10)
{
	nR1 :=  nRgbColor1 >> 16
	nG1 := (nRgbColor1 >> 8) & 0xFF
	nB1 := (nRgbColor1) & 0xFF
	nR2 :=  nRgbColor2 >> 16
	nG2 := (nRgbColor2 >> 8) & 0xFF
	nB2 := (nRgbColor2) & 0xFF

	return ( Abs(nR1 - nR2) < nTolerance ) and ( Abs(nG1 - nG2) < nTolerance ) and ( Abs(nB1 - nB2) < nTolerance )
}


/**
@brief	AppPlayer의 클라이언트 영역에서 허용오차 범위를 두고 유사한 색 조합인지 확인한다.
		RGB 단위로 분리 후, 각 바이트별 허용오차 내인지 확인한다.
; @param	arrColorSet	색조합으로 (x, y, color) 에 대한 배열이다. 배열의 최대 개수의 제한은 없으나, 성능상 4개 이하를 권장한다.
@param	nTolerance +- 허용오차 값
@return	If similar color set is true, otherwise false
*/
IsSimilarColorSet( ByRef arrColorSet, nTolerance = 5 )
{
	global g_nClientX, g_nClientY

	for nIndex, arrSet in arrColorSet
	{
		PixelGetColor, clrOutputColor, arrSet[1] + g_nClientX, arrSet[2] + g_nClientY, RGB
		;AppendLogWindow( "  IsSimilarColorSet(" . arrSet[1] . ", " . arrSet[2] . ") clrOutputColor = " . clrOutputColor . " vs color = " . arrSet[3] )
		if ( !IsSimilarColor(clrOutputColor, arrSet[3], nTolerance ) )
			return false
	}
	return true
}


; @brief 라인 레인저스 아이콘을 클릭하여 실행시킨다.
; @param hwndAppPlayer App Player에 대한 윈도우 핸들
LaunchLineRangers(ByRef hwndAppPlayer)
{
	; SendClickAbsolute( hwndAppPlayer, 643, 250 )
	Click 643, 250 
}


; 미네랄을 생산한다. X 좌표에 미네랄 버튼의 가운데 위치를 입력한다.
ProduceMineral(ByRef nMineralPosX, ByRef nMineralPosY := 453)
{
	global g_nClientX, g_nClientY

	PixelGetColor, clrRangerColor, nMineralPosX + g_nClientX, nMineralPosY + g_nClientY, RGB
	if ( clrRangerColor = 0x351407 )
	{
		ClickClientPoint( nMineralPosX, nMineralPosY )
		Sleep, 50
	}
}


; 레인저를 생산한다. X 좌표에 레인저 버튼의 가운데 위치를 입력한다.
ProduceRanger(ByRef nRangerPosX, ByRef nRangerPosY := 454)
{
	global g_nClientX, g_nClientY

	PixelGetColor, clrRangerColor, nRangerPosX + g_nClientX, nRangerPosY + g_nClientY, RGB
	if ( IsSimilarColor(clrRangerColor, 0x16192E) or IsSimilarColor(clrRangerColor, 0x091735) or IsSimilarColor(clrRangerColor, 0x34002E) or IsSimilarColor(clrRangerColor, 0x351407) )
	{
		ClickClientPoint( nRangerPosX, nRangerPosY )
		Sleep 50
	}
}


/** @brief 전투가 종료될 때까지 레인져를 생산한다.
	@param hwndAppPlayer AppPlayer 인스턴스 핸들
	@param isChangingTeam 전투에서 A, B 팀을 바꾸면서 진행할 것인가?
	@param nPeriodOfChangingTerm 전투에서 팀을 바꾸는 주기 (ms)
*/
ProduceRangers( hwndAppPlayer, isChangingTeam, nPeriodOfChangingTerm, nTeamChangeBottonY := 165 )
{
	global g_nClientX, g_nClientY
	global g_nInstance
	global g_isUseFriend, g_nStartCombat, g_nUseTornado, g_nUseIceShot, g_nUseUseMeteor

	COMBAT_ITEM_START_X		:= 162
	COMBAT_ITEM_Y			:= nTeamChangeBottonY
	COMBAT_ITEM_GAP			:= 90

	;ToolTip, hwndAppPlayer = %hwndAppPlayer%
	nPrevChangingTeamTick := A_TickCount
	nPrevMineralClick := A_TickCount
	nPrevMissileTick := A_TickCount
	nRangerPosY := 725, nItemStartX := COMBAT_ITEM_START_X
	isUseTornado := 0,	isUseUseIceShot := 0,	isUseUseMeteor := 0
	
	Loop ; 무한정 레인져 뽑기
	{
		nCurrentTick := A_TickCount
		If ( IsFinishCombat() )
			break ; Clear 시 빠져 나오기

		If ( (g_nUseTornado > 0) And (isUseTornado == 0) And ( (nCurrentTick - g_nStartCombat) > (g_nUseTornado * 1000) ) )
		{ ; Tornado 아이템 사용하기
			isUseTornado := 1
			nItemStartX := COMBAT_ITEM_START_X + COMBAT_ITEM_GAP * 2
			If ( g_isUseFriend )
				nItemStartX += COMBAT_ITEM_GAP
			Sleep 10
			SendClickAbsolute( hwndAppPlayer, nItemStartX, COMBAT_ITEM_Y )
			Sleep 10
			SendClickAbsolute( hwndAppPlayer, nItemStartX, COMBAT_ITEM_Y )
			Sleep 10
			SendClickAbsolute( hwndAppPlayer, nItemStartX, COMBAT_ITEM_Y )
			ToolTip, g_nUseTornado nItemStartX = %nItemStartX%  COMBAT_ITEM_Y = %COMBAT_ITEM_Y%, 150, 5
		}

		If ( (g_nUseIceShot > 0) And (isUseUseIceShot == 0) And ( (nCurrentTick - g_nStartCombat) > (g_nUseIceShot * 1000) ) )
		{ ; IceShot 아이템 사용하기
			isUseUseIceShot := 1
			nItemStartX := COMBAT_ITEM_START_X + COMBAT_ITEM_GAP * 1
			If ( g_isUseFriend )
				nItemStartX += COMBAT_ITEM_GAP
			Sleep 10
			SendClickAbsolute( hwndAppPlayer, nItemStartX, COMBAT_ITEM_Y )
			Sleep 10
			SendClickAbsolute( hwndAppPlayer, nItemStartX, COMBAT_ITEM_Y )
			Sleep 10
			SendClickAbsolute( hwndAppPlayer, nItemStartX, COMBAT_ITEM_Y )
			ToolTip, g_nUseIceShot nItemStartX = %nItemStartX%  COMBAT_ITEM_Y = %COMBAT_ITEM_Y%, 150, 5
		}

		If ( isChangingTeam And ( nPeriodOfChangingTerm > 2500 ) )
		{ ; 팀 변경
			nCurrentChangingTeamTick := A_TickCount
			If ( Abs(nCurrentChangingTeamTick - nPrevChangingTeamTick) > nPeriodOfChangingTerm )
			{ ; 팀 바꾸기
				Sleep 10
				SendClickAbsolute( hwndAppPlayer, 90, nTeamChangeBottonY ) ; Click 90, 165
				Sleep 5
				SendClickAbsolute( hwndAppPlayer, 90, nTeamChangeBottonY ) ; Click 90, 165
				Sleep 10
				nPrevChangingTeamTick := A_TickCount
			}
		}

		;if (  )
		ProduceRanger( hwndAppPlayer, 235)

		ProduceRanger( hwndAppPlayer, 320)

		ProduceRanger( hwndAppPlayer, 400)

		ProduceRanger( hwndAppPlayer, 485)

		ProduceRanger( hwndAppPlayer, 570)

		; 미네랄 업그레이드
		;ProduceMineral( hwndAppPlayer )

		; 타워 미사일 발사 처리
		nCurrentMissleTick := A_TickCount
		If ( Abs(nCurrentMissleTick - nPrevMissileTick) > 500 )
		{ ; 지정된 시간마다 Missile을 클릭하여 발사함
			SendClickAbsolute( hwndAppPlayer, 200, nRangerPosY )
			Sleep 5
			nPrevMissileTick := A_TickCount
		}
		;ToolTip, A_Index = %A_Index% clrRangerColor = %clrRangerColor%
	}
	ToolTip, 전투 종료 감지, 150, 5
}


; @brief 전투가 종료될 때까지 레인져를 생산한다.
; @param hwndAppPlayer AppPlayer 인스턴스 핸들
; @param isChangingTeam 전투에서 A, B 팀을 바꾸면서 진행할 것인가?
; @param nPeriodOfChangingTerm 전투에서 팀을 바꾸는 주기 (ms)
ProduceRangers4GuildRaid( hwndAppPlayer, isChangingTeam, nPeriodOfChangingTerm )
{
	global g_nClientX, g_nClientY

	AppendLogWIndow( "    In GUILD-RAID combat..." )

	nPrevChangingTeamTick := A_TickCount
	
	Loop ; 무한정 레인져 뽑기
	{
		nCurrentTick := A_TickCount
		If ( IsFinishCombat() )
			break ; Clear 시 빠져 나오기

		If ( isChangingTeam And ( nPeriodOfChangingTerm > 2500 ) )
		{
			nCurrentChangingTeamTick := A_TickCount
			If ( Abs(nCurrentChangingTeamTick - nPrevChangingTeamTick) > nPeriodOfChangingTerm )
			{ ; 팀 바꾸기
				ClickClientPoint( 42, 50 )
				ClickClientPoint( 42, 50, 50 )
				nPrevChangingTeamTick := A_TickCount
			}
		}

		ProduceRanger( 120 )

		ProduceRanger( 204 )

		ProduceRanger( 288 )

		ProduceRanger( 372 )

		ProduceRanger( 456 )
	}
	AppendLogWIndow("    Guild Raid 전투 종료 감지")
}


; @brief 설정에 따라 친구를 선택한다.
SelectFriend( isUseFriend )
{
	If ( isUseFriend == 1 )
	{
		If ( !IsCheckedFriend() )
		{ ; 친구가 선택되어 있지 않으면, 선택한다.
			ClickClientPoint( 297, 326, 500 )
			Sleep 500
		}
	}
	else
	{
		If ( IsCheckedFriend() )
		{ ; 친구가 선택되어 있으면, 선택을 해제한다.
			ClickClientPoint( 297, 326, 500 )
			Sleep 500
		}
	}
}


; @brief 설정에 무적을 선택한다.
SelectUnbeatable( isUseUnbeatable, isUseFriend )
{
	If ( isUseUnbeatable )
	{
		If ( isUseFriend )
			ClickClientPoint( 327, 55 )
		else
			ClickClientPoint( 270, 55 )

		Sleep 100
	}
}


; @brief 지정한 타이틀 이름과 일치하는 윈도우의 x, y 좌표에 마우스 클릭 동작을 한다.
; @param hwndAppPlayer AppPlayer 인스턴스의 핸들
; @param nPosX 클릭 동작을 할 X 좌표값 (절대좌표)
; @param nPosY 클릭 동작을 할 Y 좌표값 (절대좌표)
SendClickAbsolute( hwndAppPlayer, nPosX, nPosY, nDelayTime := 0 )
{
	Sleep % nDelayTime
	; Click %nPosX%, %nPosY%
	nPosX -= 3, nPosY -= 36 ; 절대좌표를 클라이언트 좌표로 변환
	lParam := nPosX | nPosY << 16
	;ToolTip, hwndAppPlayer = %hwndAppPlayer%  nPosX = %nPosX%  nPosY = %nPosY%  lParam = %lParam%, 250, 5
	PostMessage, 0x201, 1, lParam , , ahk_id %hwndAppPlayer% ;A ; %strTitle% ; WM_LBUTTONDOWN, MK_LBUTTON, MAKEPOINT( X, Y )
	PostMessage, 0x200, 1, lParam , , ahk_id %hwndAppPlayer% ;A ; %strTitle% ; WM_MOUSEMOVE, MK_LBUTTON, MAKEPOINT( X, Y )
	PostMessage, 0x202, 0, lParam , , ahk_id %hwndAppPlayer% ;A ; %strTitle% ; WM_LBUTTONUP, 0, MAKEPOINT( X, Y )
}


; @brief 두 지점간의 드래깅 동작을 수행한다.
;		지정한 시작점에서 마우스 왼쪽 버튼을 눌러 끝낼점까지 지정한 속도로 이동한 이후에 마우스를 뗀다.
; @param nPosX 드래그 동작을 시작할 지점의 X 좌표값 (절대좌표)
; @param nPosY 드래그 동작을 시작할 지점의 Y 좌표값 (절대좌표)
; @param nEndPosY 드래그 동작을 끝내는 지점의 X 좌표값 (절대좌표)
; @param nEndPosY 드래그 동작을 끝내는 지점의 Y 좌표값 (절대좌표)
; @param nSpeed 드래깅시 마우스 이동 속도
SendTouchDrag( nPosX, nPosY, nEndPosX, nEndPosY, nSpeed )
{
	MouseMove, nPosX, nPosY
	Send {LButton down}
	MouseMove, nEndPosX, nEndPosY - 1, nSpeed
	Sleep 10
	MouseMove, nEndPosX, nEndPosY
	Send {LButton up}

	Sleep 100
}


; @brief Mineral을 지정한 단계까지 올려준다.
; @param nMineralLevel 8이면 미네랄을 Max까지 올려준다.
;		1 ~ 7이면 100ms 기다리는 시간을 갖고 지정한 횟수만큼 미네랄을 클릭한다.
;		0 이면 아무런 동작을 하지 않는다.
UpgradeMineral( nMineralLevel )
{
	Global g_hwndAppPlayer
	
	If ( nMineralLevel >= 8 )
	{
		Loop, 300 ; 최대 10초간 대기
		{
			PixelGetColor, clrOutputColor, 1355, 875, RGB
			If (clrOutputColor = 0xD69251)
			{
				Sleep 5000 ; 미네랄 업그레이한 만큼 잠깐동안 미네랄이 찰 때까지 기다리기
				break
			}
			Sleep 34 ; 34ms 대기 1 frame 변화시간?
			SendClickAbsolute( g_hwndAppPlayer, 1350, 850 ) ;
		}
	}
	Else If ( nMineralLevel > 0 )
	{
		nLoop := nMineralLevel
		while (nLoop)
		{
			Sleep 100
			SendClickAbsolute( g_hwndAppPlayer, 1350, 850 ) ;
			nLoop --
		}
		nLoop := nMineralLevel * 500
		;ToolTip, hwndAppPlayer = %hwndAppPlayer%  nLoop = %nLoop%, 250, 5
		Sleep nLoop  ; 미네랄 업그레이드 한 만큼 잠깐동안 미네랄이 찰 때까지 기다리기
	}
}


; @brief 전투가 종료된 후에, 결과가 나올 때까지 대기
; @param nWaitingSeconds 컬러 조합이 일치되는 화면이 나타날 때까지 기다릴 시간
; @return 지정된 시간동안(기본 60초) 기다려도 입력한 컬러 조합이 나타나지 않으면 0을 반환하고,
;			해당 색의 조합이 감지되면 1을 반환한다.
WaitColorSet( arrWaitingColorSet, nWaitingSeconds := 60 )
{
	; RETRY 창에 대한 색조합
	g_arrColorSetIsRetry	:= [ [350, 306, 0x00DD44], [428, 312, 0xFFFFFF], [398, 324, 0xFFFFFF], [533, 130, 0xFFFFEE] ]

	nLoopCount := 1
	nLoopTotal := nWaitingSeconds * 10

	While ( nLoopCount < nLoopTotal )
	{
;		If ( IsSameColorSet(arrWaitingColorSet) )
		If ( IsSimilarColorSet(arrWaitingColorSet, 10) )
			break

;		If ( IsSameColorSet(g_arrColorSetIsRetry) )
		If ( IsSimilarColorSet(g_arrColorSetIsRetry, 10) )
		{
			ClickClientPoint( 400, 320 )
			Sleep 1500
		}

		; TODO: 네트워크 등의 문제로 Retry 되는 경우에 대한 처리가 필요함
			
		nLoopCount := nLoopCount + 1
		Sleep 100
	}
	
	return ( nLoopCount < nLoopTotal )
}


; @brief	화면을 축소합니다.
; @param	nX	클라이언트 영역의 X 좌표
; @param	nY	클라이언트 영역의 Y 좌표
ZoomOut( nX, nY )
{
	global g_hwndAppPlayer, g_hwndAppPlayerClient

	; WM_MOUSEMOVE = 0x200, MK_LBUTTON = 0x01, MK_CONTROL = Ox08
	; WM_MOUSEWHEEL = 0x20A, MK_LBUTTON = 0x01, MK_CONTROL = Ox08

	PostMessage, 0x100, 0x0011, 0x001D0001, , ahk_id %g_hwndAppPlayerClient% ; CTRL KEY Down
	lParam := nX | nY << 16
	PostMessage, 0x200, 0, %lParam% , , ahk_id %g_hwndAppPlayerClient%
	Loop 7
	{
		PostMessage, 0x20A, 0xFF880008, %lParam% , , ahk_id %g_hwndAppPlayerClient%
		;Sleep 50
	}
	PostMessage, 0x101, 0x0011, 0xC01D0001, , ahk_id %g_hwndAppPlayerClient% ; CTRL KEY Up
}