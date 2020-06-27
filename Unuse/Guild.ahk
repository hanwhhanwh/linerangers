;===============================================================================
; @file Guild.ahk
; @author hbesthee@naver.com
; @date 2017-06-20
;
; @description GUILD 출석 자동화
;
;===============================================================================

#include Global.ahk
#include Wait_inc.ahk
#include Utils_inc.ahk


if ( !InitializeLineRangers() )
{
	MsgBox LineRangers 스크립트 초기화 실패!!!
	ExitApp, 0
}


CloseTeamviewer() ; 팀뷰 창 닫기
CheckAppPlayer( g_nInstance, false ) ; 실행 인스턴스를 활성화
CreateLogWindow()

AppendLogWIndow( "Start GUILD Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )


; LoadGlobalVriable( "GUILD" ) ; GUILD에 대한 설정 정보 로딩


g_arrColorSetIsGuild				:= [ [561, 296, 0xFFE466], [625, 300, 0xFFD618], [680, 135, 0x21961E] ]
if ( !IsSameColorSet(g_arrColorSetIsGuild) )
{ ; GUILD 화면으로 이동 처리
	AppendLogWIndow( " need to move GUILD " )
	g_arrColorSetCanShortMove		:= [ [19, 30, 0xFFFFDD], [22, 37, 0x0], [34, 44, 0xFFEE44] ]
	if ( IsSameColorSet(g_arrColorSetCanShortMove) )
	{
		AppendLogWIndow( " short move to GUILD " )
		ClickClientPoint( 770, 40, 500 )
		ClickClientPoint( 675, 338, 1000 ) ; GUILD 로 이동
	}
}


AppendLogWIndow( " waiting for GUILD " )
bTimeout := WaitColorSet(g_arrColorSetIsGuild)
if ( bTimeout = 0 )
{
	MsgBox, AppPlayer%g_nInstance% GUILD 화면에서 시작하여 주시기 바랍니다...
	ExitApp, 0
}


AppendLogWIndow( " Can GUILD attend?" )
g_arrColorSetCanAttend		:= [ [164, 361, 0x50D470], [273, 354, 0xD8000F], [255, 390, 0x009B20] ]
if ( IsSameColorSet( g_arrColorSetCanAttend ) )
{ ; 출석 가능한 상태임
	AppendLogWindow( " Guild Attended : " . A_TickCount)
	ClickClientPoint( 220, 370, 500 )
	Sleep 2500
	g_arrColorSetCanAccept		:= [ [533, 149, 0xFFE466], [603, 157, 0xFFD618], [578, 173, 0xE5B22E] ]
	if ( IsSameColorSet( g_arrColorSetCanAccept ) )
	{ ; 출석 가능한 상태임
		ClickClientPoint( 573, 156, 1000 ) ; Accept 버튼 클릭 ; 출석 보상
		if ( WaitOkButton( 339, 295 ) == 1 )
		{
			ClickClientPoint( 400, 320, 800 ) ; OK 버튼 클릭
			ClickClientPoint( 695, 58, 1500 ) ; 출석 보상창 닫기
		}
		else
		{
			AppendLogWindow( " 출석 보상 수령 실패. " . A_TickCount)
			MsgBox, AppPlayer%g_nInstance% 출석 보상 수령 실패.
			ExitApp, 0
		}
	}
}


ClickClientPoint( 536, 126, 1500 )
AppendLogWIndow( " GUILD Support... " )
Sleep 1500

nX := 540

Loop, 10
{
	blnSendSupport := false
	Sleep 500
	nY := 153
	while ( nY < 420 )
	{
		PixelGetColor, clrOutputColor, nX + g_nClientX, nY + g_nClientY, RGB
		if ( clrOutputColor == 0xFFD618 )
		{ ; GUILD 회원에게 SUPPORT 보내기
			AppendLogWIndow( " Send Support... " )
			ClickClientPoint( nX, nY, 500 )
			Sleep 1500
			if ( IsOkButton( 402, 334 ) )
				ClickClientPoint( 460, 350 )
			Sleep 1000
			blnSendSupport := true
		}

		nY := nY + 25
	}

	AppendLogWIndow( " #" . A_Index . " 다음으로 드래그 " )
	DragMouse( 460, 409, 460, 155, 200, 100 )
	
	if ( !blnSendSupport )
		break ; 더이상 Support를 보내지 못하면 종료
}
AppendLogWIndow( " GUILD 처리 완료." )
ExitApp, 0

#b::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	ExitApp, 0
