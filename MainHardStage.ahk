;===============================================================================
; @file MainHardStage.ahk
; @author hbesthee@naver.com
; @date 2021-01-16
;
; @description Main Hard Stage ����� ��ũ��Ʈ
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
g_nAutoMode := 1 ; Auto ��� ���� : 0=��� ������, 1=1���, 2=2���
g_nDelayForNextCombat := 0 ; ���� ������ �����ϱ� ���� ����� �ð�(���� : ��)
g_nUseTornado := 0 ; ������ ������ ��, ������ �ð� ��(����:��)�� ����̵�(Tornado)�� �����. 0�̸� ������
g_nUseIceShot := 0 ; ������ ������ ��, ������ �ð� ��(����:��)�� ���̽���(Ice Shot)�� �����. 0�̸� ������
g_nUseUseMeteor := 0 ; ������ ������ ��, ������ �ð� ��(����:��)�� ���׿�(Meteor)�� �����. 0�̸� ������
g_isUseUnbeatable := 1 ; ���� ���
g_isChangingTeam := 1 ; �� ��ü


CheckAppPlayer( g_nInstance )
CreateLogWindow()

AppendLogWIndow( "Start [MainhardStage Hard] Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )


CloseTeamviewer()


; Main-Hard Stage�� 5 stage�� �߾ӿ� ���̵��� �̵��ϱ�
ClickClientPoint( 222, 430, 1500 )
AppendLogWIndow( "click : Main-stage Hard")
ClickClientPoint( 125, 357, 5000 )
AppendLogWIndow( "click : Hard 6 stage")
ClickClientPoint( 30, 40, 5000 )
AppendLogWIndow( "click : Back")

Sleep 3500

; �����Ͽ� ó���� �ܰ迡 ���� ���� ; [ [x, y, stage_num], ... ]
g_arr4Stages	:= [ [349, 363, 4], [457, 251, 3], [507, 256, 2], [495, 286, 1]  ]
g_arr5Stages	:= [ [665, 350, 1], [567, 300, 2], [457, 283, 3], [349, 273, 4] ]
g_arrStages		:= [ [300, 206, 2], [300, 206, 3], [300, 206, 4] ]
g_ptEnter		:= [400, 420]
nClearStage		:= 1

g_arrWaitColor	:= [[121, 427, 0x912ACE], [80, 412, 0x0B0D17], [764, 434, 0xE0D79D]]


MAIN_HARD_STAGES:


nX := g_arr4Stages[nClearStage][1]
nY := g_arr4Stages[nClearStage][2]
nStage := g_arr4Stages[nClearStage][3]

ClickClientPoint( nX, nY, 5000 )
AppendLogWIndow( "click : Hard " . nStage . " stage")

Sleep 2000


; Stage�� �´� ȯ�漳�� ������ �ٽ� �о��
strStageName := "MAIN_HARD_STAGE" . nStage


AppendLogWIndow( "  �� ��� ȣ�� : " )
ClickClientPoint( 400, 160, 1000 )

AppendLogWIndow( "  �� 5 ����" )
ClickClientPoint( 400, 360, 1000 )

AppendLogWindow( "  ģ�� ���� ����..." )
ClickClientPoint( g_ptEnter[1], g_ptEnter[2], 1500 )

AppendLogWindow( "  ���� ���� �õ�..." )
ClickClientPoint( g_ptEnter[1], g_ptEnter[2], 1500 )

nResult := WaitStartingCombat()
If ( nResult = 0 )
{
	AppendLogWindow( "  ���� ���� ����..." )
	MsgBox, AppPlayer%g_nInstance% Main hard stage(%strStageName%)�� ������ �������� ���Ͽ����ϴ�...
	ExitApp, 0
}
else if ( bTimeout = -1 )
{
	AppendLogWindow( "  ���� ������ ���� ���� ����..." )
	ExitApp, 0 ; ������ �� �̻� ����
}

AppendLogWIndow( "  ������..." )

; ���� ���۰� �Բ� ������ ��ȯ
ProduceRanger(400)
ProduceRanger(320)
ProduceRanger(235)
ProduceRanger(485)
ProduceRanger(570)

Sleep 700

If (g_isUseUnbeatable = 1)
	SelectUnbeatable( g_isUseUnbeatable, g_isUseFriend )

nNextTeamChangeTick := A_TickCount + 5500
; �� �����ϸ� ������ ����� ������ ���
While ( IsFinishCombat() = 0 )
{
	ProduceRanger(400)

	ProduceRanger(320)

	If ( IsFinishCombat() )
		Break

	ProduceRanger(235)

	ProduceRanger(485)

	If ( IsFinishCombat() )
		Break

	ProduceRanger(570)

	if ( g_isChangingTeam = 1 )
	{
		if (nNextTeamChangeTick < A_TickCount)
		{
			nNextTeamChangeTick := A_TickCount + 5500
			ClickClientPoint( 42, 50 )
		}
	}
}
AppendLogWIndow( "  ���� ����..." )


bTimeout := WaitStartingRoulette()
If ( bTimeout = 0 )
{
	MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)�� ���� ��� ���� �귿�� �����ϴ� ���� ���������� ���Ͽ����ϴ�...
	ExitApp, 0
}


AppendLogWIndow( "  ���� �����ϱ�" )
AcceptClearBonus( g_arrWaitColor ) ; ���� ����

Sleep 2000


nClearStage		:= nClearStage + 1

Goto, MAIN_HARD_STAGES


#b::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
