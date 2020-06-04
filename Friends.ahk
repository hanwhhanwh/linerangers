;===============================================================================
; @file Friends.ahk
; @author hbesthee@naver.com
; @date 2015-06-11
;
; @description 친구들에게 우정포인트 받기 자동화
;
;===============================================================================

#include Global.ahk
#include Utils_inc.ahk
#include Wait_inc.ahk

if ( !InitializeLineRangers() )
{
	MsgBox LineRangers 스크립트 초기화 실패!!!
	ExitApp, 0
}

LoadGlobalVriable( "FRIENDS Send Help" )

CloseTeamviewer() ; 팀뷰 창 닫기
CheckAppPlayer( g_nInstance ) ; 실행 인스턴스를 활성화
CreateLogWindow()

AppendLogWIndow( "Start [FRIENDS] Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )


nSkipCount := 0


g_arrColorSetIsFriends			:= [ [147, 43, 0x00AAFF], [353, 109, 0xFFEE44], [482, 99, 0xFFFFFF] ]

if ( !IsSameColorSet( g_arrColorSetIsFriends ) )
{
	MsgBox, Friends 에서 스크립트를 실행하여 주시기 바랍니다.
	ExitApp, 0
}

FRIENDS_LOOP:



Sleep 500
nMousePosX := 70
nMousePosY := 339
While ( nMousePosX < 800 )
{
	PixelGetColor clrOutputColor1, g_nClientX + nMousePosX, g_nClientY + nMousePosY, RGB ; 0x00BB33
	;AppendLogWIndow( "버튼 검사 : nMousePosX = " . nMousePosX . " , nMousePosX = " . nMousePosY . " , clrOutputColor1 = " . clrOutputColor1 )
	if ( clrOutputColor1 = 0x00BB33 )
	{
		nSkipCount := 0
		; AppendLogWIndow( "Help 보낼지 붇는 확인창 호출...")
		ClickClientPoint( nMousePosX, nMousePosY )
		Sleep 500
		If ( IsOkButton(402, 334) )
		{
			ClickClientPoint( 460, 356, 500 ) ; HELP 보내기 OK
			AppendLogWIndow( "Help 보냈음. OK 버튼 대기하기...")
 			nWaitResult := WaitOkButton( 339, 295 )
			If ( nWaitResult > 0 )
				ClickClientPoint( 400, 320, 500 ) ; OK 클릭
			Sleep 500
		}
		Else If ( IsOkButton( 339, 295 ) )
		{ ; Exceed 50
			ExitApp, 0
		}
	}
	else
		nSkipCount := nSkipCount + 1
		
	If (nSkipCount > 700)
	{
		ExitApp, 0
	}
	nMousePosX := nMousePosX + 30 ; 다음 친구 위치로 이동
}

DragMouse(797, 285, 3, 285, 200, 100)
Sleep 1000


Goto, FRIENDS_LOOP


#B::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
