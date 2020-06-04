;===============================================================================
; @file SpecialStage.ahk
; @author hbesthee@naver.com
; @date 2015-06-09
;
; @description SPECIAL STAGE�� ���� ���� ��ũ��Ʈ
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

g_nStartingMinute := Mod(A_Min, 10)
g_nStartCombat := 0
g_nDelayForNextCombat := 0 ; ���� ������ �����ϱ� ���� ����� �ð�(���� : ��)
g_nUseTornado := 0 ; ������ ������ ��, ������ �ð� ��(����:��)�� ����̵�(Tornado)�� �����. 0�̸� ������
g_nUseIceShot := 0 ; ������ ������ ��, ������ �ð� ��(����:��)�� ���̽���(Ice Shot)�� �����. 0�̸� ������
g_nUseUseMeteor := 0 ; ������ ������ ��, ������ �ð� ��(����:��)�� ���׿�(Meteor)�� �����. 0�̸� ������


CheckAppPlayer( g_nInstance )
CreateLogWindow()

AppendLogWindow( "Start SpecialStage Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )

strStageName := "SPECIAL_STAGE_ND"

nSpecialStage := 0

g_ptEnter		:= [400, 420]

LoadGlobalVriable( strStageName )

IniRead, g_nDelayForNextCombat, LineRangers.ini,% strStageName, DelayForNextCombat, 0
IniRead, g_nUseTornado, LineRangers.ini,% strStageName, UseTornado, 0
IniRead, g_nUseIceShot, LineRangers.ini,% strStageName, UseIceShot, 0
IniRead, g_nUseUseMeteor, LineRangers.ini,% strStageName, UseUseMeteor, 0


SPECIAL_STAGE:

; Line Rangers GEAR ȭ������ Ȯ���� ���� �÷� ����
g_arrColorSetIsSpecialStage				:= [ [291, 405, 0xEB1B00], [394, 427, 0xCF0F00], [504, 448, 0xB41000] ]

bTimeout := WaitColorSet(g_arrColorSetIsSpecialStage)
;bTimeout := WaitSpecialStage()
If ( bTimeout = 0 )
{
	AppendLogWindow( " AppPlayer%g_nInstance% SPECIAL stage(%strStageName%) ȭ�鿡�� �����Ͽ� �ֽñ� �ٶ��ϴ�..." )
	Run, RepeatLab.ahk
	ExitApp, 0
}

CloseTeamviewer()

; SPECIAL STAGE >> ENTER Ŭ��
AppendLogWindow( "SPECIAL STAGE >> ENTER Ŭ��" )
ClickClientPoint( g_ptEnter[1], g_ptEnter[2], 500 )

Sleep 500

; OK ��ư ������ ; ������ ���� Ƚ���� ��� ����ߴ��� Ȯ���ϱ�
g_arrColorSetOkButton			:= [ [ 350, 307, 0x00DD44 ], [404, 317, 0xFFFFFF], [447, 337, 0x009922] ]
if ( IsSameColorSet(g_arrColorSetOkButton) )
{
	AppendLogWindow( "SpecialStage > ������ ���� Ƚ���� ��� �������")
	ClickClientPoint( 404, 317, 1000 )
	Run, RepeatLab.ahk
	ExitApp, 0
}


; ���� ���Դܰ� �ڵ� ó��
nResult := HandlerNextButton()
If (nResult = -1)
{
	AppendLogWindow( "SpecialStage > Item ���� ȭ������ ���� ����")
	MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)�� Item ���� ȭ������ ���� ����...
	ExitApp, 0
}
Else If (nResult = -2)
{
	AppendLogWindow( "SpecialStage > ģ�� ���� ȭ������ ���� ����")
	MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)�� ģ�� ���� ȭ������ ���� ����...
	ExitApp, 0
}


AppendLogWindow( "  SPECIAL STAGE >> ���� ���� �õ�..." )
ClickClientPoint( g_ptEnter[1], g_ptEnter[2], 500 )


nResult := WaitStartingCombat()
If ( nResult = 0 )
{
	AppendLogWindow( "  SPECIAL STAGE >> ���� ���� ����..." )
	MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)�� ������ �������� ���Ͽ����ϴ�...
	ExitApp, 0
}
else if ( bTimeout = -1 )
{
	AppendLogWindow( "  SPECIAL STAGE >> ���� ������ ���� ���� ����..." )
	ExitApp, 0 ; ������ �� �̻� ����
}

AppendLogWindow( "  SPECIAL STAGE >> ���� ����..." )


; Auto combat X2
ClickClientPoint( 767, 110 )
ClickClientPoint( 767, 110, 500 )


;ZoomOut( g_isInGameZoom ) ; ���� ��ü ����

Sleep 2200 ; �ڵ� �������� ���� ����� ��� ����ϱ�

If (g_isUseUnbeatable == 1)
	SelectUnbeatable( g_isUseUnbeatable, g_isUseFriend )
If ( g_isUseFriend )
{ ; ģ�� �θ���
	ClickClientPoint( 100, 55 )
	Sleep 10
}
g_nStartCombat := A_TickCount
isUseTornado := 0
isUseUseIceShot := 0

COMBAT_ITEM_START_X		:= 100
COMBAT_ITEM_Y			:= 55
COMBAT_ITEM_GAP			:= 56

CloseTeamviewer()
; �� �����ϸ� ���
While ( IsFinishCombat() = 0 )
{
	Loop, 30 ; = Sleep 3600
	{
		nCurrentTick := A_TickCount
		If ( (g_nUseTornado > 0) And (isUseTornado == 0) And ( (nCurrentTick - g_nStartCombat) > (g_nUseTornado * 1000) ) )
		{ ; Tornado ������ ����ϱ�
			isUseTornado := 1
			nItemStartX := COMBAT_ITEM_START_X + COMBAT_ITEM_GAP * 2
			If ( g_isUseFriend )
				nItemStartX += COMBAT_ITEM_GAP
			ClickClientPoint( nItemStartX, COMBAT_ITEM_Y, 100 )
			ClickClientPoint( nItemStartX, COMBAT_ITEM_Y, 100 )
			strMsg = "g_nUseTornado = %g_nUseTornado%,  nItemStartX = %nItemStartX%  COMBAT_ITEM_Y = %COMBAT_ITEM_Y%"
			AppendLogWindow( strMsg )
		}

		If ( (g_nUseIceShot > 0) And (isUseUseIceShot == 0) And ( (nCurrentTick - g_nStartCombat) > (g_nUseIceShot * 1000) ) )
		{ ; IceShot ������ ����ϱ�
			isUseUseIceShot := 1
			nItemStartX := COMBAT_ITEM_START_X + COMBAT_ITEM_GAP * 1
			If ( g_isUseFriend )
				nItemStartX += COMBAT_ITEM_GAP
			ClickClientPoint( nItemStartX, COMBAT_ITEM_Y, 100 )
			ClickClientPoint( nItemStartX, COMBAT_ITEM_Y, 100 )
			strMsg = "g_nUseIceShot = %g_nUseIceShot%,  nItemStartX = %nItemStartX%  COMBAT_ITEM_Y = %COMBAT_ITEM_Y%"
			AppendLogWindow( strMsg )
		}

		Sleep, 100 ; 3�� ���
		If ( IsFinishCombat() )
			Break
	}
	If ( IsFinishCombat() )
		Break

	if ( g_isChangingTeam )
		ClickClientPoint( 42, 50 )
}
AppendLogWindow( "���� ����..." )

CloseTeamviewer()

bTimeout := WaitStartingRoulette()
If ( bTimeout = 0 )
{
	MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)�� ���� ��� ���� �귿�� �����ϴ� ���� ���������� ���Ͽ����ϴ�...
	ExitApp, 0
}


AppendLogWindow( "���� �����ϱ�" )
AcceptClearBonus( g_arrColorSetIsSpecialStage ) ; ���� ����

Sleep 1000

nSpecialStage := nSpecialStage + 1

if ( nSpecialStage = 20 )
{
	Run, RepeatLab.ahk
	ExitApp, 0
}

Sleep 1000
If ( g_nDelayForNextCombat > 0 )
{
	Sleep 3000
	Send {HOME} ; Click 1300, 690 ; AppPlayer HOME ( == HOME )
	strMsg = SPECIAL stage(%strStageName%) S_Minute = %g_nStartingMinute% Delay = %g_nDelayForNextCombat%
	DEBUG_STR( g_nInstance, strMsg )
	nTotal := g_nDelayForNextCombat / 10
	nLoop := 0
	While (nLoop < nTotal)
	{
		Sleep 420000 ; 7�� ���� ���
		While ( g_nStartingMinute != Mod(A_Min, 10) )
		{
			CloseTeamviewer()
			Sleep 2000
		}
		CheckAppPlayer( g_nInstance )
		Sleep 2000
		Click 600, 290 ; LineRangers ����
		Sleep 4000

		SendClickAbsolute( g_hwndAppPlayer, 645, 685 )  ;Click 810, 845
		bTimeout := WaitNextButtonOnItemSelection()
		If ( bTimeout = 0 )
		{
			MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)�� ������ ���� ȭ�������� �̵� ����
			ExitApp, 0
		}
		else if ( bTimeout = -1 )
		{
			ExitApp, 0
		}

		Sleep 2000
		SendClickAbsolute( g_hwndAppPlayer, 51, 73 ) ;Click 60, 90
		bTimeout := WaitSpecialStage()
		If ( bTimeout = 0 )
		{
			MsgBox, AppPlayer%g_nInstance% Delay SPECIAL stage(%strStageName%) ȭ�������� �̵� ����
			ExitApp, 0
		}

		nLoop := nLoop + 1
		strMsg = SPECIAL stage(%strStageName%) S_Minute = %g_nStartingMinute% nLoop = %nLoop%
		DEBUG_STR( g_nInstance, strMsg )
		Sleep 2000
		If ( nLoop < nTotal )
			Send {HOME} ; Click 1300, 690 ; AppPlayer HOME ( == HOME )
	}
}
CloseTeamviewer()
strMsg = ���� ������ : SPECIAL stage(%strStageName%) S_Minute = %g_nStartingMinute%
AppendLogWindow( strMsg )

Goto, SPECIAL_STAGE

Return


#b::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	;MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)�� ���� ��ũ��Ʈ�� ������ �����մϴ�.
	ExitApp, 0  ; Assign a hotkey to terminate this script.
