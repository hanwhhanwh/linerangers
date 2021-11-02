;===============================================================================
; @file		Wait_inc.ahk
; @author	hbesthee@naver.com
; @date		2015-06-11
;
; @description	각종 화면상에서 나타나야할 컴포넌트 대기 함수들 모음
;
;===============================================================================

#include Global.ahk
#include Utils_inc.ahk




; 각종 전투 진입단계에서 "NEXT" 버튼을 자동으로 눌러줌(아이템 선택, 친구 선택 등)
HandlerNextButton()
{
	Global	g_nInstance
	g_ptEnter		:= [400, 420] ; Next 버튼 클릭 위치

	isOk := WaitNextButtonOnItemSelection()
	If ( not isOk )
	{ ; 아이템 선택으로 이동하지 못함
		return -1
	}

	; 아이템 선택에서 Next 클릭
	AppendLogWindow( "아이템 선택에서 Next 클릭" )
	ClickClientPoint( g_ptEnter[1], g_ptEnter[2], 500 )

	isOk := WaitNextButtonOnFriendSelection()
	If ( not isOk )
	{ ; 친구 선택으로 이동하지 못함
		return -2
	}



	bTimeout := WaitColorSet(g_arrColorSetStartButton)
	;bTimeout := WaitNextButtonOnFriendSelection()
	If ( bTimeout = 0 )
	{
		MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)의 친구 선택으로 이동하지 못하였습니다...
		ExitApp, 0
	}

	SelectFriend( g_isUseFriend ) ; 친구 선택 처리

	; 친구 선택에서 Start 클릭
	AppendLogWindow( "친구 선택에서 Start 클릭" )
	ClickClientPoint( g_ptEnter[1], g_ptEnter[2], 500 )
}


; @brief ENDLESS 모드의 오른쪽 하단의 붉은색 START 버튼이 나타날 때까지 대기함
; @param nWaitingSeconds 붉은색 START 버튼이 감지될 때까지 기다릴 시간
; @return 지정된 시간동안(기본 60초) 기다려도 붉은색 START 버튼이 나타나지 않으면 0을 반환하고,
;			붉은색 START 버튼이 감지되면 1을 반환한다.
WaitEndlessStartButton( nWaitingSeconds := 60 )
{
	Global g_nClientX, g_nClientY

	nLoopCount := 1
	nLoopTotal := nWaitingSeconds * 10
	While ( nLoopCount < nLoopTotal )
	{
		PixelGetColor, clrOutputColor1, g_nClientX + 1100, g_nClientY + 750, RGB ; 0xCF0F00
		PixelGetColor, clrOutputColor2, g_nClientX + 1240, g_nClientY + 750, RGB ; 0xFFFFFF
		PixelGetColor, clrOutputColor3, g_nClientX + 1240, g_nClientY + 810, RGB ; 0xB41000
		; ToolTip, %clrOutputColor1%  %clrOutputColor2%

		If ( clrOutputColor1 = 0xCF0F00 ) and ( clrOutputColor2 = 0xFFFFFF ) and ( clrOutputColor3 = 0xB41000 )
			break

		nLoopCount := nLoopCount + 1
		Sleep 100
	}
	
	If ( nLoopCount >= nLoopTotal )
		return 0
	else
		return 1
}



; @brief 전투가 끝나고 보상이 나올 때까지 대기하기
; @param nWaitingSeconds 감지될 때까지 기다릴 시간
; @return 지정된 시간동안(기본 180초) 기다려도 전투가 끝났음이 감지되지 않으면 0을 반환하고,
;			전투가 끝났음이 감지되면 1을 반환한다.
WaitFinishingCombat( nWaitingSeconds := 180 )
{
	Global g_nClientX, g_nClientY

	nLoopCount := 1
	nLoopTotal := nWaitingSeconds * 5
	While ( nLoopCount < nLoopTotal )
	{
		PixelGetColor, clrOutputColor1, g_nClientX + 633,  g_nClientY + 274, Slow RGB ; 0xFFEE21
		PixelGetColor, clrOutputColor2, g_nClientX + 1260, g_nClientY + 740, Slow RGB ; 0x101104 ; 0x291B06
		PixelGetColor, clrOutputColor3, g_nClientX + 20,   g_nClientY + 740, Slow RGB ; 0x291B06

		If ( clrOutputColor1 = 0xFFEE21 ) and ( clrOutputColor2 = 0x101104 or clrOutputColor2 = 0x291B06 ) and 
				( clrOutputColor3 = 0x101104 or clrOutputColor3 = 0x291B06 )
			break

		Sleep 200
		nLoopCount := nLoopCount + 1
	}

	If ( nLoopCount >= nLoopTotal )
		return 0
	else
		return 1
}



; @brief TEAM BATTLE 전투가 끝나고 보상이 나올 때까지 대기하기
; @param nWaitingSeconds 감지될 때까지 기다릴 시간
; @return 지정된 시간동안(기본 60초) 기다려도 전투가 끝났음이 감지되지 않으면 0을 반환하고,
;			전투가 끝났음이 감지되면 1을 반환한다.
WaitFinishingTeamBattle(nWaitingSeconds := 60 )
{
	Global g_nClientX, g_nClientY

	nLoopCount := 1
	nLoopTotal := nWaitingSeconds * 10
	While ( nLoopCount < nLoopTotal )
	{
		PixelGetColor, clrOutputColor1, g_nClientX + 113, g_nClientY + 17, RGB ; 0x720000 / 0x671A49
		PixelGetColor, clrOutputColor2, g_nClientX + 196, g_nClientY + 17, RGB ; 0x720000 / 0x671A49
		PixelGetColor, clrOutputColor3, g_nClientX + 387, g_nClientY + 79, RGB ; 0xFFE63D

		If ( (clrOutputColor1 = 0x720000)  or (clrOutputColor1 = 0x5C1843) )
				and ( (clrOutputColor2 = 0x720000)  or (clrOutputColor2 = 0x5C1843) )
				and ( (clrOutputColor3 = 0xFFE63D) )
			break

		Sleep 100 ; 100ms 대기
		nLoopCount := nLoopCount + 1
	}

	If ( nLoopCount >= nLoopTotal )
		return 0
	else
		return 1
}


; @brief Wait Gift box
; @param nWaitingSeconds Gift box 화면이 감지될 때까지 기다릴 시간
; @return 지정된 시간동안(기본 120초) 기다려도 Gift box 화면이 나타나지 않으면 0을 반환하고,
;			Gift box 화면이 감지되면 1을 반환한다.
WaitGiftBox( nWaitingSeconds := 300 )
{
	Global g_nClientX, g_nClientY

	nLoopCount := 1
	nLoopTotal := nWaitingSeconds * 10

	While ( nLoopCount < nLoopTotal )
	{
		PixelGetColor, clrOutputColor1, g_nClientX + 315,  g_nClientY + 170, RGB ; 0xFFEE44
		PixelGetColor, clrOutputColor2, g_nClientX + 507,  g_nClientY + 155, RGB ; 0xFFEE44
		PixelGetColor, clrOutputColor3, g_nClientX + 1357, g_nClientY + 126, RGB ; 0x000000

		If ( clrOutputColor1 = 0xFFEE44 ) and ( clrOutputColor2 = 0xFFEE44 ) and ( clrOutputColor3 = 0x000000 )
			break

		nLoopCount := nLoopCount + 1
		Sleep 100
	}
	
	If ( nLoopCount >= nLoopTotal )
		return 0
	else
		return 1
}


; @brief HOME 화면으로 이동 대기
; @param nWaitingSeconds HOME 화면이 감지될 때까지 기다릴 시간
; @return 지정된 시간동안(기본 120초) 기다려도 HOME 화면이 나타나지 않으면 0을 반환하고,
;			HOME 화면이 감지되면 1을 반환한다.
WaitHome( nWaitingSeconds := 300 )
{
	Global g_nInstance
	Global g_hwndAppPlayer

	nLoopCount := 1
	nLoopTotal := nWaitingSeconds * 10

	While ( nLoopCount < nLoopTotal )
	{
		If ( IsHome() )
			break

		If ( IsCloseButton( 891, 815) )
		{ ; Event window ; Close button
			SendClickAbsolute( g_hwndAppPlayer, 1010, 860 )
			Sleep 500
		}

		If ( IsOkButton( 981, 695 ) )
		{ ; Reword Notification window
			SendClickAbsolute( g_hwndAppPlayer, 1100, 740 )
			Sleep 500
		}

		If ( IsOkButton( 683, 702 ) )
		{ ; Received reword window
			SendClickAbsolute( g_hwndAppPlayer, 800, 745 )
			Sleep 500
		}

		If ( IsOkButton( 1141, 815 ) )
		{
			If ( IsRewordOfTeamBattle() )
				SendClickAbsolute( g_hwndAppPlayer, 168, 940 ) ; capture screenshot - reword of team battle
			Sleep 2000 ; Battle
			SendClickAbsolute( g_hwndAppPlayer, 1260, 860 )
			Sleep 500
		}

		nLoopCount := nLoopCount + 1
		Sleep 100
	}
	
	If ( nLoopCount >= nLoopTotal )
		return 0
	else
		return 1
}



; @brief MAIN Stage 화면으로 이동 대기
; @param nWaitingSeconds MAIN Stage 화면이 감지될 때까지 기다릴 시간
; @return 지정된 시간동안(기본 120초) 기다려도 MAIN Stage 화면이 나타나지 않으면 0을 반환하고,
;			MAIN Stage 화면이 감지되면 1을 반환한다.
WaitMainStage( nWaitingSeconds := 120 )
{
	Global g_nClientX, g_nClientY

	nLoopCount := 1
	nLoopTotal := nWaitingSeconds * 2

	While ( nLoopCount < nLoopTotal )
	{
		PixelGetColor, clrOutputColor1, g_nClientX + 1175, g_nClientY + 64, RGB ; 0xFFEE44
		PixelGetColor, clrOutputColor2, g_nClientX + 139,  g_nClientY + 60, RGB ; 0x00AAFF
		PixelGetColor, clrOutputColor3, g_nClientX + 307,  g_nClientY + 60, RGB ; 0xDBEDFF

		If ( clrOutputColor1 = 0xFFEE44 ) and ( clrOutputColor2 = 0x00AAFF ) and ( clrOutputColor3 = 0xDBEDFF )
			break

		nLoopCount := nLoopCount + 1
		Sleep 500
		;SendClickAbsolute( g_hwndAppPlayer, 12, 914) ; 243, 384 )
	}
	
	If ( nLoopCount >= nLoopTotal )
		return 0
	else
		return 1
}



; @brief 깃털이 새로 추가될 때까지 기다린다.
; @return 
WaitNextFeather()
{
}



; @brief 친구 선택창에서 녹색 NEXT 버튼이 나타날 때까지 대기함
; @param nWaitingSeconds 녹색 NEXT 버튼이 감지될 때까지 기다릴 시간
; @return 지정된 시간동안(기본 30초) 기다려도 녹색 NEXT 버튼이 나타나지 않으면 0을 반환하고,
;			녹색 NEXT 버튼이 감지되면 1을 반환한다.
WaitNextButtonOnFriendSelection( nWaitingSeconds := 30 )
{
	Global g_arrColorSetIsRetry, g_ptRetryButton

	; 친구 선택 화면에서의 Start 버튼의 색조합
	g_arrColorSetStartButton := [ [ 293, 397, 0x07DA46 ], [478, 404, 0xFFFFFF], [508, 439, 0x009B20] ]

	nLoopCount := 1
	nLoopTotal := nWaitingSeconds * 5
	While ( nLoopCount < nLoopTotal )
	{
;		If ( IsSameColorSet(g_arrColorSetStartButton) )
		If ( IsSimilarColorSet(g_arrColorSetStartButton, 10) )
			break

;		If ( IsSameColorSet(g_arrColorSetIsRetry) )
		If ( IsSimilarColorSet(g_arrColorSetIsRetry, 10) )
		{
			ClickClientPoint( g_ptRetryButton[0], g_ptRetryButton[1] )
			Sleep 1500
		}

		nLoopCount := nLoopCount + 1
		Sleep 200
	}

	return ( nLoopCount < nLoopTotal )
}



; @brief 아이템 선택창에서 하늘색 NEXT 버튼이 나타날 때까지 대기함
; @param nWaitingSeconds 하늘색 NEXT 버튼이 감지될 때까지 기다릴 시간
; @return 지정된 시간동안(기본 30초) 기다려도 하늘색 NEXT 버튼이 나타나지 않으면 0을 반환하고,
;			하늘색 NEXT 버튼이 감지되면 1을 반환한다.
;			입장 횟수 등의 문제로 중앙에 OK 창이 나타나 있으면, -1을 반환한다.
WaitNextButtonOnItemSelection( nWaitingSeconds := 30 )
{
	Global g_arrColorSetIsRetry, g_ptRetryButton, g_ptRetryButton

	; 아이템 선택 화면에서의 Next 버튼의 색조합
	g_arrColorSetNextButton	:= [ [ 294, 396, 0x19BBD6 ], [424, 419, 0xFFFFFF], [506, 439, 0x057188] ]

	g_arrColorSetCloseButton := [ [677, 98, 0xFFFFDD], [686, 116, 0xFFEE44], [689, 123, 0xFFBB11] ]

	nLoopCount := 1
	nLoopTotal := nWaitingSeconds * 5
	While ( nLoopCount < nLoopTotal )
	{
;		If ( IsSameColorSet(g_arrColorSetNextButton) )
		If ( IsSimilarColorSet(g_arrColorSetNextButton, 10) )
			break

;		If ( IsSameColorSet(g_arrColorSetCloseButton) )
		If ( IsSimilarColorSet(g_arrColorSetCloseButton, 10) )
		{
			AppendLogWindow( "    파워업 레인저창 닫기")
			ClickClientPoint( g_arrColorSetCloseButton[1][1], g_arrColorSetCloseButton[1][2] )
			;ActivateClick( g_arrColorSetCloseButton[0][0], g_arrColorSetCloseButton[0][1] )
		}

;		If ( IsSameColorSet(g_arrColorSetIsRetry) )
		If ( IsSimilarColorSet(g_arrColorSetIsRetry, 10) )
		{
			ClickClientPoint( g_ptRetryButton[0], g_ptRetryButton[1] )
			Sleep 1500
		}

		nLoopCount := nLoopCount + 1
		Sleep 200
	}

	return ( nLoopCount < nLoopTotal )
}


; @brief Wait for show OK button
; @param nLeft OK button X axis of Left
; @param nTop OK button Y axis of Top
; @param nWaitingSeconds waiting time
; @return If show OK button then 1, otherwise 0
WaitOkButton( nLeft, nTop, nWaitingSeconds := 60 )
{
	nLoopCount := 1
	nLoopTotal := nWaitingSeconds * 5
	While ( nLoopCount < nLoopTotal )
	{
		If ( IsOkButton(nLeft, nTop) )
			break

		nLoopCount := nLoopCount + 1
		Sleep 200
	}

	If ( nLoopCount >= nLoopTotal )
		return 0
	else
		return 1
}



; @brief 게임에 들어왔을 때까지 대기하기
; @param nWaitingSeconds 감지될 때까지 기다릴 시간
; @return 지정된 시간동안(기본 30초) 기다려도 녹색 NEXT 버튼이 나타나지 않으면 0을 반환하고,
;			녹색 NEXT 버튼이 감지되면 1을 반환한다.
WaitStartingCombat( nWaitingSeconds := 30 )
{
	Global g_arrColorSetIsRetry, g_ptRetryButton

	; 전투 시작 확인 여부 색조합
	g_arrColorSetStartingCombat := [ [ 125, 400, 0xFFFFFF ], [144, 442, 0xDD9955], [98, 440, 0xDD9955] ]

	nLoopCount := 1
	nLoopTotal := nWaitingSeconds * 5
	arrColorSetOkButton := [ [138, 445, 0xDD9955], [761, 77, 0x030201], [761, 29, 0x030201] ]
	While ( nLoopCount < nLoopTotal )
	{
		; 깃털이 부족한지 확인함
;		if ( IsSameColorSet (arrColorSetOkButton) )
		if ( IsSimilarColorSet (arrColorSetOkButton, 10) )
		{
			AppendLogWIndow( "    깃털이 부족하여 대기 종료!!!")
			MsgBox, 전투로 진입하기 위한 깃털이 부족하여 종료합니다...
			return -1
		}

;		If ( IsSameColorSet(g_arrColorSetStartingCombat) )
		If ( IsSimilarColorSet(g_arrColorSetStartingCombat, 10) )
			break

;		If ( IsSameColorSet(g_arrColorSetIsRetry) )
		If ( IsSimilarColorSet(g_arrColorSetIsRetry, 10) )
		{
			ClickClientPoint( g_ptRetryButton[0], g_ptRetryButton[1] )
			Sleep 1500
		}

		nLoopCount := nLoopCount + 1
		Sleep 200
	}

	If ( nLoopCount < nLoopTotal )
		return 1
	Else
		return 0
}



; @brief Team Battle의 전투에 들어왔을 때까지 대기하기
; @param nWaitingSeconds 감지될 때까지 기다릴 시간
; @return 지정된 시간동안(기본 60초) 기다려도 녹색 NEXT 버튼이 나타나지 않으면 0을 반환하고,
;			녹색 NEXT 버튼이 감지되면 1을 반환한다.
WaitStartingTeamBattleCombat( nWaitingSeconds := 60 )
{
	Global g_nClientX, g_nClientY

	nLoopCount := 1
	nLoopTotal := nWaitingSeconds * 5
	arrColorSetOkButton := [ [518, 316, 0x00BB33], [466, 317, 0xFFFFFF], [414, 306, 0x00DD44] ]
	While ( nLoopCount < nLoopTotal )
	{
		;SendClickAbsolute( g_hwndAppPlayer, 200, 600 ) ;Click 200, 600

		; 깃털이 부족한지 확인함
		if ( IsSameColorSet (arrColorSetOkButton) )
		{
			AppendLogWIndow( "TEAM BATTLE>> 깃털이 부족하여 대기 종료!!!")
			;MsgBox, TEAM BATTLE의 전투로 진입하기 위한 깃털이 부족하여 종료합니다...
			;return -1
		}

		PixelGetColor, clrOutputColor1, g_nClientX + 763, g_nClientY + 112, Slow RGB ; 0x030201 ; 0x240C03
		PixelGetColor, clrOutputColor2, g_nClientX + 104, g_nClientY + 441, Slow RGB ; 0xDD9955
		;ToolTip, clrOutputColor1 = %clrOutputColor1%  clrOutputColor2 = %clrOutputColor2%
		If ( (clrOutputColor1 = 0x030201) or (clrOutputColor1 = 0x763A19) )
					and ( (clrOutputColor2 = 0xD7C7AE) or (clrOutputColor2 = 0xDD9955) )
			break

		nLoopCount := nLoopCount + 1
		Sleep 200 ; 100ms 대기
	}

	If ( nLoopCount >= nLoopTotal )
		return 0
	else
		return 1
}



; @brief SPECIAL Stage 화면으로 이동 대기
; @param nWaitingSeconds SPECIAL Stage 화면이 감지될 때까지 기다릴 시간
; @return 지정된 시간동안(기본 60초) 기다려도 SPECIAL Stage 화면이 나타나지 않으면 0을 반환하고,
;			SPECIAL Stage 화면이 감지되면 1을 반환한다.
WaitSpecialStage( nWaitingSeconds := 60 )
{
	Global g_nInstance
	Global g_hwndAppPlayer, g_hwndAppPlayerClient, g_nClientX, g_nClientY

	nLoopCount := 1
	nLoopTotal := nWaitingSeconds * 10

	While ( nLoopCount < nLoopTotal )
	{
		PixelGetColor, clrOutputColor1, g_nClientX + 291, g_nClientY + 405, RGB ; 0xEB1B00
		PixelGetColor, clrOutputColor2, g_nClientX + 394, g_nClientY + 427, RGB ; 0xCF0F00
		PixelGetColor, clrOutputColor3, g_nClientX + 504, g_nClientY + 448, RGB ; 0xB41000

		;DEBUG_STR(g_nInstance, clrOutputColor1 = %clrOutputColor1%)
		If ( clrOutputColor1 = 0xEB1B00 ) and ( clrOutputColor2 = 0xCF0F00 ) and ( clrOutputColor3 = 0xB41000 )
			break

		nLoopCount := nLoopCount + 1
		Sleep 100
	}
	
	If ( nLoopCount >= nLoopTotal )
		return 0
	else
		return 1
}



; @brief CLEAR BONUS 룰렛이 돌기 시작할 때까지 대기하기
; @param nWaitingSeconds 감지될 때까지 기다릴 시간
; @return 지정된 시간동안(기본 60초) 기다려도 녹색 NEXT 버튼이 나타나지 않으면 0을 반환하고,
;			녹색 NEXT 버튼이 감지되면 1을 반환한다.
WaitStartingRoulette( nWaitingSeconds := 60 )
{
	; 룰렛이 돌아가고 있음을 확인하는 색조합
	g_arrColorSetStartingRoulette			:= [ [ 275, 122, 0xFFEE33 ]
			, [400, 424, 0x009B20], [522, 117, 0xFFEE33] ]

	nLoopCount := 1
	nLoopTotal := nWaitingSeconds * 10
	While ( nLoopCount < nLoopTotal )
	{
;		If ( IsSameColorSet( g_arrColorSetStartingRoulette ) )
		If ( IsSimilarColorSet( g_arrColorSetStartingRoulette, 10 ) )
			break

		;ClickClientPoint( 370, 372, 500 )
		ClickClientPoint( 470, 400, 500 ) ; 보상 수령 위치로 클릭
		Sleep 1500 ; 1500ms 대기
		nLoopCount := nLoopCount + 1
	}

	If ( nLoopCount >= nLoopTotal )
		return 0
	else
		return 1
}



; @brief TEAM BATTLE 모드의 오른쪽 하단의 붉은색 START 버튼이 나타날 때까지 대기함
; @param nWaitingSeconds 붉은색 BATTLE 버튼이 감지될 때까지 기다릴 시간
; @return 지정된 시간동안(기본 60초) 기다려도 붉은색 BATTLE 버튼이 나타나지 않으면 0을 반환하고,
;			붉은색 BATTLE 버튼이 감지되면 1을 반환한다.
WaitTeamBattleStartButton( nWaitingSeconds := 60 )
{
	Global g_nClientX, g_nClientY

	nLoopCount := 1
	nLoopTotal := nWaitingSeconds * 10
	While ( nLoopCount < nLoopTotal )
	{
		PixelGetColor, clrOutputColor1, g_nClientX + 530, g_nClientY + 380, RGB ; 0xCF0F00 0xD10E06
		PixelGetColor, clrOutputColor2, g_nClientX + 609, g_nClientY + 373, RGB ; 0xFFFFFF
		PixelGetColor, clrOutputColor3, g_nClientX + 680, g_nClientY + 407, RGB ; 0xB60901 0xB41000
		; ToolTip, %clrOutputColor1%  %clrOutputColor2%

		If ( clrOutputColor1 == 0xD10E06 or clrOutputColor1 == 0xCF0F00 )
				and ( clrOutputColor2 == 0xFFFFFF )
				and ( clrOutputColor3 == 0xB60901 or clrOutputColor3 == 0xB41000 )
			break

		nLoopCount := nLoopCount + 1
		Sleep 100
	}
	
	If ( nLoopCount >= nLoopTotal )
		return 0
	else
		return 1
}
