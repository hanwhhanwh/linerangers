;===============================================================================
; @file Guild.ahk
; @author hbesthee@naver.com
; @date 2017-06-20
;
; @description GUILD �⼮ �ڵ�ȭ
;
;===============================================================================

#include Global.ahk
#include Wait_inc.ahk
#include Utils_inc.ahk


if ( !InitializeLineRangers() )
{
	MsgBox LineRangers ��ũ��Ʈ �ʱ�ȭ ����!!!
	ExitApp, 0
}


CloseTeamviewer() ; ���� â �ݱ�
CheckAppPlayer( g_nInstance, false ) ; ���� �ν��Ͻ��� Ȱ��ȭ
CreateLogWindow()

AppendLogWIndow( "Start GUILD Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )


; LoadGlobalVriable( "GUILD" ) ; GUILD�� ���� ���� ���� �ε�


g_arrColorSetIsGuild				:= [ [561, 296, 0xFFE466], [625, 300, 0xFFD618], [680, 135, 0x21961E] ]
if ( !IsSameColorSet(g_arrColorSetIsGuild) )
{ ; GUILD ȭ������ �̵� ó��
	AppendLogWIndow( " need to move GUILD " )
	g_arrColorSetCanShortMove		:= [ [19, 30, 0xFFFFDD], [22, 37, 0x0], [34, 44, 0xFFEE44] ]
	if ( IsSameColorSet(g_arrColorSetCanShortMove) )
	{
		AppendLogWIndow( " short move to GUILD " )
		ClickClientPoint( 770, 40, 500 )
		ClickClientPoint( 675, 338, 1000 ) ; GUILD �� �̵�
	}
}


AppendLogWIndow( " waiting for GUILD " )
bTimeout := WaitColorSet(g_arrColorSetIsGuild)
if ( bTimeout = 0 )
{
	MsgBox, AppPlayer%g_nInstance% GUILD ȭ�鿡�� �����Ͽ� �ֽñ� �ٶ��ϴ�...
	ExitApp, 0
}


AppendLogWIndow( " Can GUILD attend?" )
g_arrColorSetCanAttend		:= [ [164, 361, 0x50D470], [273, 354, 0xD8000F], [255, 390, 0x009B20] ]
if ( IsSameColorSet( g_arrColorSetCanAttend ) )
{ ; �⼮ ������ ������
	AppendLogWindow( " Guild Attended : " . A_TickCount)
	ClickClientPoint( 220, 370, 500 )
	Sleep 2500
	g_arrColorSetCanAccept		:= [ [533, 149, 0xFFE466], [603, 157, 0xFFD618], [578, 173, 0xE5B22E] ]
	if ( IsSameColorSet( g_arrColorSetCanAccept ) )
	{ ; �⼮ ������ ������
		ClickClientPoint( 573, 156, 1000 ) ; Accept ��ư Ŭ�� ; �⼮ ����
		if ( WaitOkButton( 339, 295 ) == 1 )
		{
			ClickClientPoint( 400, 320, 800 ) ; OK ��ư Ŭ��
			ClickClientPoint( 695, 58, 1500 ) ; �⼮ ����â �ݱ�
		}
		else
		{
			AppendLogWindow( " �⼮ ���� ���� ����. " . A_TickCount)
			MsgBox, AppPlayer%g_nInstance% �⼮ ���� ���� ����.
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
		{ ; GUILD ȸ������ SUPPORT ������
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

	AppendLogWIndow( " #" . A_Index . " �������� �巡�� " )
	DragMouse( 460, 409, 460, 155, 200, 100 )
	
	if ( !blnSendSupport )
		break ; ���̻� Support�� ������ ���ϸ� ����
}
AppendLogWIndow( " GUILD ó�� �Ϸ�." )
ExitApp, 0

#b::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	ExitApp, 0
