;===============================================================================
; @file ChallengeNormal.ahk
; @author hbesthee@naver.com
; @date 2015-06-09
;
; @description NORMAL STAGE ���� ���� �ڵ�ȭ
;
;===============================================================================

#include Global.ahk
#include Utils_inc.ahk
#include Wait_inc.ahk
#include Worker_inc.ahk


if ( !InitializeLineRangers() )
{
	MsgBox LineRangers ��ũ��Ʈ �ʱ�ȭ ����!!!
	ExitApp, 0
}

LoadGlobalVriable( "CHALLENGE_STAGE" )

CheckAppPlayer( g_nInstance )

bTimeout := WaitNextButtonOnItemSelection()
If ( bTimeout = 0 )
{
	MsgBox, Normal mode�� ������ �������� �̵����� ���Ͽ����ϴ�...
	ExitApp, 0
}

; ������ ���ÿ��� Next Ŭ��
Sleep 500
SendClickAbsolute( g_hwndAppPlayer, 800, 800 ) ;Click 800, 800
Sleep 500


bTimeout := WaitNextButtonOnFriendSelection()
If ( bTimeout = 0 )
{
	MsgBox, Normal mode�� ģ�� �������� �̵����� ���Ͽ����ϴ�...
	ExitApp, 0
}

SelectFriend( g_isUseFriend )

; ģ�� ���ÿ��� Next Ŭ��
Sleep 500
SendClickAbsolute( g_hwndAppPlayer, 800, 800 ) ;Click 800, 800
Sleep 500


bTimeout := WaitStartingCombat()
If ( bTimeout = 0 )
{
	MsgBox, NORMAL stage�� ������ �������� ���Ͽ����ϴ�...
	ExitApp, 0
}
else if ( bTimeout = -1 )
	ExitApp, 0 ; ������ �� �̻� ����

SendClickAbsolute( g_hwndAppPlayer, 200, 460 ) ;Click 200, 460

UpgradeMineral( g_nUpgradeMineral )

ZoomOut( g_isInGameZoom ) ; ���� ��ü ����

SelectUnbeatable( g_isUseUnbeatable, g_isUseFriend )
If ( g_isUseFriend )
{ ; ģ�� �θ���
	;SendClickAbsolute( g_hwndAppPlayer, 205, 95 ) ;Click 205, 95
	Sleep 10
}

ProduceRangers( g_hwndAppPlayer, g_isChangingTeam, g_nPeriodOfChangingTeam, 95 )


bTimeout := WaitFinishingCombat( 120 )
If ( bTimeout = 0 )
{
	MsgBox, NORMAL stage�� ������ ������ ���� �������� ���Ͽ����ϴ�...
	ExitApp, 0
}

Sleep 500
SendClickAbsolute( g_hwndAppPlayer, 200, 450 ) ;Click 200, 450


ClickLevelUp()


bTimeout := WaitStartingRoulette()
If ( bTimeout = 0 )
{
	MsgBox, NORMAL stage�� ������ ���� ��, ���� �귿�� �����ϴ� ���� ���������� ���Ͽ����ϴ�...
	ExitApp, 0
}
Sleep 1000
SendClickAbsolute( g_hwndAppPlayer, 800, 780 ) ;Click 800, 780 ; �귿 ���߱�


AcceptClearBonus() ; ���� ����


nSpecialStage := nSpecialStage + 1

if ( nSpecialStage = 3 )
{
	ExitApp, 0
}

CloseTeamviewer(  )



#x::
	MsgBox, NORMAL stage�� ���� ��ũ��Ʈ�� ������ �����մϴ�.
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
