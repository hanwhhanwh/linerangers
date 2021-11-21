;===============================================================================
; @file EventStage.ahk
; @author hbesthee@naver.com
; @date 2020-06-12
; @encode EUC-KR
;
; @description Event Stage ó�� �ڵ�ȭ ��ũ��Ʈ.
;		"Event Stage" ȭ�鿡�� ��ũ��Ʈ�� ���۽��Ѿ� ��.
;		���� ���� EventTeam�� �����Ǿ� �־�߸� ��.
;		LineRangers.ini ������ "[EVENT_STAGE]" ���ǿ��� �ΰ����� ������ �� �� ����
;===============================================================================

#include Global.ahk
#include Wait_inc.ahk
#include Utils_inc.ahk
#include ColorSet_inc.ahk

if ( !InitializeLineRangers() )
{
	MsgBox LineRangers Not found AppPlayer!!!
	ExitApp, 0
}

;;; Definition ColorSet ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Event Stage ȭ������ Ȯ���� ���� ������
g_arrColorSetEventStage		:= [ [150, 355, 0xD61408], [530, 230, 0xEF8A00], [430, 350, 0xD62894] ]
; Event Stage �� ���� ȭ������ Ȯ���� ���� ������
g_arrColorEventTeam			:= [ [400, 415, 0x05C232], [457, 155, 0xAA7744], [250, 40, 0xFFEE44] ]
; ���������� Ȯ���ϴ� ������
g_arrColorBattle			:= [ [237, 268, 0x17110B], [238, 382, 0x3A1B00], [239, 381, 0x50320F] ]
; ������ ����Ǿ����� Ȯ���ϴ� ������
g_arrColorEventStageResult	:= [ [519, 156, 0xFF0000], [447, 164, 0xFFE63D], [255, 155, 0x8F0000] ]

g_arrColorHeal		:= [ [170, 55, 0x979797] ]
g_arrColorSpeedUp	:= [ [220, 41, 0x979797] ]
g_arrColorShield	:= [ [270, 65, 0x979797] ]



CheckAppPlayer( g_nInstance, false ) ; ���� �ν��Ͻ��� Ȱ��ȭ
CreateLogWindow()
AppendLogWindow( "Start EVENT_STAGE Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )


if ( !IsSimilarColorSet( g_arrColorSetEventStage ) )
{
	MsgBox Run with 'EVENT STAGE'.
	ExitApp, 0
}

g_nBattleCount := 0

EVENT_STAGE_LOOP:

;;; Load EventStage Settings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IniRead, g_nDifficulty, LineRangers.ini, EVENT_STAGE, Difficulty, 0
IniRead, g_nDelayUsingShield, LineRangers.ini, EVENT_STAGE, DelayUsingShield, 7000


ClickClientPoint( 150, 355, 500 ) ; "BATTLE" click
; SELECT Level of Difficulty
if (g_nDifficulty == 0) ; EASY level
	ClickClientPoint( 300, 290, 500 )
else if (g_nDifficulty == 1) ; NORMAL level
	ClickClientPoint( 400, 290, 500 )
else ; HARD level
	ClickClientPoint( 500, 290, 500 )

if ( WaitColorSet( g_arrColorEventTeam, 30 ) = 0 )
{
	AppendLogWindow( "[EVENT_STAGE] Move error : move fail select event team." )
	MsgBox, [EVENT_STAGE] Move error : move fail select event team.
	ExitApp, 0
}

ClickClientPoint( 400, 415, 500 ) ; Click "START"

;;; In battle : Produce Rangers / Use Items
g_nBattleCount := g_nBattleCount + 1
AppendLogWindow( "[EVENT_STAGE] in battle. Difficulty = " + g_nDifficulty )
While ( !IsSimilarColorSet( g_arrColorEventStageResult ) )
{
	if ( hasShield and ( (A_TickCount - tickGetShield) > g_nDelayUsingShield) )
	{
		ClickClientPoint( 270, 65, 0 ) ; Use shield
		hasShield := false
	}

	ProduceRanger( 225 )
	ProduceRanger( 310 )
	ProduceRanger( 390 )
	ProduceRanger( 475 )
	ProduceRanger( 560 )
	Sleep 100

	if ( !IsSimilarColorSet(g_arrColorHeal) )
		ClickClientPoint( 170, 55, 100 ) ; Use heal
	if ( !IsSimilarColorSet(g_arrColorSpeedUp) )
		ClickClientPoint( 220, 41, 100 ) ; Use speed up
	if ( !hasShield and !IsSimilarColorSet(g_arrColorShield) )
	{
		hasShield := true
		tickGetShield := A_TickCount
	}
}
AppendLogWindow( "[EVENT_STAGE] finish battle. : " + g_nBattleCount )

Sleep 1000
ClickClientPoint( 400, 415, 500 )

if ( WaitColorSet( g_arrColorSetEventStage, 30 ) = 0 )
{
	AppendLogWindow( "[EVENT_STAGE] Move error : move fail EVENT_STAGE main" )
	MsgBox, [EVENT_STAGE] Move error : move fail EVENT_STAGE main
	ExitApp, 0
}

Goto, EVENT_STAGE_LOOP



#b::
GUI_EXIT:
GUI_Close:
GUI_Escape:

ExitApp, 0
