;===============================================================================
; @file Worker_inc.ahk
; @author hbesthee@naver.com
; @date 2015-07-04
;
; @description 각종 작업 처리하는 함수들 모음
;
;===============================================================================

#include Global.ahk
#include Utils_inc.ahk
#include Wait_inc.ahk


; @brief 우정 포인트를 수령한다.
AcceptFriendshipPoint()
{
	Global g_nInstance
	Global g_hwndAppPlayer

	DEBUG_STR(g_nInstance, "Accept Friendship Point...")
	
	nNoAcceptLoopCount := 0

	;SendClickAbsolute( g_hwndAppPlayer, 1085, 600 ) ; Close Level window
	;Sleep 200
	; Click gift-box
	SendClickAbsolute( g_hwndAppPlayer, 1280, 815 ) ;Click 1500, 200
	Sleep 1500
	
	If ( WaitGiftBox() )
	{
		Loop, 100
		{
			nPosY := 250, nLastPosY := 0, nAcceptCount = 0
			while ( nPosY <= 780 )
			{
				PixelGetColor clrOutputColor1, 330, nPosY, RGB ; 0x0033FF
				PixelGetColor clrOutputColor2, 347, nPosY, RGB ; 0xFFEE44
				PixelGetColor clrOutputColor3, 377, nPosY, RGB ; 0x0033FF

				;ToolTip, nPosY = %nPosY% clrOutputColor1 = %clrOutputColor1%   clrOutputColor2 = %clrOutputColor2%   clrOutputColor3 = %clrOutputColor3%, 150, 5
				;Sleep 1000

				If ( ( clrOutputColor1 = 0x0033FF ) And ( clrOutputColor2 = 0xFFEE44 ) And ( clrOutputColor3 = 0x0033FF ) )
				{
					nLastPosY := nPosY
				}
				else If ( nLastPosY > 0 )
				{
					PixelGetColor clrOutputColor1, 1280, nLastPosY, RGB ; 0x00BB33
					If ( clrOutputColor1 = 0x00BB33 )
					{ ; identified Accept button
						nLastPosY := 0
						SendClickAbsolute( g_hwndAppPlayer, 1280, nPosY )
						nWaitResult := WaitOkButton( 683, 581 )
						If ( nWaitResult > 0 )
						{ ; accept success
							nAcceptCount ++
							SendClickAbsolute( g_hwndAppPlayer, 800, 625 )
							Sleep 500
							If ( IsOkButton( 808, 581 ) )
							{ ; send friendship point
								SendClickAbsolute( g_hwndAppPlayer, 925, 625 )
								nWaitResult := WaitOkButton( 683, 581 )
								If ( nWaitResult > 0 )
								{ ; friendship point send success
									SendClickAbsolute( g_hwndAppPlayer, 800, 625 )
									Sleep 500
								}
							}
						}
					}
				}
				
				nPosY := nPosY + 10
			}
			
			nNoAcceptLoopCount += (nAcceptCount) ? 0 : 1
			
			If ( nNoAcceptLoopCount >= 2 )
			{
				Sleep 500
				SendClickAbsolute( g_hwndAppPlayer, 1356, 126 )
				Sleep 1000
				Return
			}

			SendTouchDrag( 800, 770, 800, 260, 50 )
			Sleep 10
		} ; Loop, 100
	}
	Else
	{
		ToolTip, ReceiveFriendsPoint() : Wait Gift-box fail..., 150, 5
	}
}


; @brief 지정된 인스턴스의 AppPlayer를 실행한다.
RunWindroye( nInstance )
{
	IfWinNotExist AppPlayer Manager
	{ ; AppPlayer Manager 확인후, 없으면 실행
		Run "C:\Program Files (x86)\Windroye\AppPlayer Manager.exe"
		WinWait, AppPlayer Manager
	}

	WinActivate, AppPlayer Manager
	WinMove, 0, 0
	Sleep 100

	If ( nInstance == 1 )
		nPosY := 186
	Else
		nPosY := 557

	Click 100, nPosY ; 해당 인스턴스 선택
	Sleep 500
	Click 150, 80 ; Start 클릭
	Sleep 1000
}


; @brief HOME 화면에서 깃털이 추가될 때까지 기다리도록 한다.
;		기다리는 동안은 CPU 부하를 줄이기 위하여 공지사항 창을 열어 놓고,
;		약 5분에 1번씩 Gift box를 열어서 우정포인트를 받아둔다.
; @param nDelayMin HOME 화면에서 기다리는 시간(단위 ; 분)
StandByHome( nDelayMin := 15 )
{
	Global g_nInstance
	Global g_hwndAppPlayer

	DEBUG_STR(g_nInstance, "Stand by home...")

	nTotal := nDelayMin / 5
	nLoop := 0
	While (nLoop < nTotal)
	{
		CloseTeamviewer()

		; 설정창 클릭-CPU 자원 휴면 상태로 만들기
		Sleep 2000
		SendClickAbsolute( g_hwndAppPlayer, 80, 700 ) ;Click 80, 700
		Sleep 2000
		SendClickAbsolute( g_hwndAppPlayer, 400, 380 ) ;Click 480, 380
	
		Sleep 280000

		CloseTeamviewer()
		Sleep 2000
		
		; 설정창 닫기
		SendClickAbsolute( g_hwndAppPlayer, 1540, 120 ) ;Click 1540, 120
		Sleep 2000
		SendClickAbsolute( g_hwndAppPlayer, 1385, 125 ) ;Click 1385, 125
		Sleep 2000
		
		AcceptFriendshipPoint()
		Sleep 2000

		nLoop := nLoop + 1
	}
}
