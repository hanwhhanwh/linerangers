;===============================================================================
; @file Arena.ahk
; @author hbesthee@naver.com
; @date 2016-08-28
;
; @description ARENA 모드 자동화 ; 시작전에 팀은 미리 구성을 해두어야만 함
;
;===============================================================================

#include Global.ahk
#include Wait_inc.ahk
#include Utils_inc.ahk
#include ColorSet_inc.ahk

if ( !InitializeLineRangers() )
{
	MsgBox LineRangers 스크립트 초기화 실패!!!
	ExitApp, 0
}

;;; ARENA 관련 색조합


; ARENA 모드 상수 정의 부분
ARENA_BUTTON_X_GAP := 104
ARENA_BUTTON_Y_GAP := 115
ARENA_BUTTON_X_WIDTH := 131
ARENA_BUTTON_Y_WIDTH := 132

ARENA_BASE_X := 197
ARENA_BASE_Y := 155
ARENA_CLEARED_STAGE_COLOR := 0xBC6223

; 318, 272 ; 0xBC6223 ; 트로피(이미 완료한 단계)
; 가로 : 246 411
; 세로 : 196 384 = 188 / 516-384 = 132


CheckAppPlayer( g_nInstance )
CreateLogWindow()

AppendLogWIndow( "Start [ARENA MODE] Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )


ARENA_LOOP:


CloseTeamviewer()
LoadGlobalVriable( "ARENA" )
InitializeClientPosition()


Sleep 1000
nStep := 0 ; GetArenaStep()

Sleep 1000
; 트로피 > 이미 완료한 Arena Stage 여부
g_arrColorSetIsClearStageTrophyBase	:= [ [195, 139, 0xB8B8B7], [197, 139, 0xB8B8B7], [199, 139, 0xB8B8B7] ]
g_arrColorSetIsClearStageTrophy		:= [ [197, 139, 0xB8B8B7], [200, 139, 0xB8B8B7], [193, 139, 0xB8B8B7] ]
Loop, 10
{
	g_arrColorSetIsClearStageTrophy[1][1] := g_arrColorSetIsClearStageTrophyBase[1][1] + Mod( (A_Index - 1), 5 ) * ARENA_BUTTON_X_GAP
	g_arrColorSetIsClearStageTrophy[2][1] := g_arrColorSetIsClearStageTrophyBase[2][1] + Mod( (A_Index - 1), 5 ) * ARENA_BUTTON_X_GAP
	g_arrColorSetIsClearStageTrophy[3][1] := g_arrColorSetIsClearStageTrophyBase[3][1] + Mod( (A_Index - 1), 5 ) * ARENA_BUTTON_X_GAP
	g_arrColorSetIsClearStageTrophy[1][2] := g_arrColorSetIsClearStageTrophyBase[1][2] + ((A_Index - 1) // 5) * ARENA_BUTTON_Y_GAP
	g_arrColorSetIsClearStageTrophy[2][2] := g_arrColorSetIsClearStageTrophyBase[2][2] + ((A_Index - 1) // 5) * ARENA_BUTTON_Y_GAP
	g_arrColorSetIsClearStageTrophy[3][2] := g_arrColorSetIsClearStageTrophyBase[3][2] + ((A_Index - 1) // 5) * ARENA_BUTTON_Y_GAP

	if ( IsSimilarColorSet(g_arrColorSetIsClearStageTrophy, 30) == 0 )
	{
		nStep := A_Index
		break
	}
}
if (nStep == 0)
{
	ExitApp, 0
}
AppendLogWIndow( "#" . nStep . Format(" g_arrColorSetIsClearStageTrophy : 1,1 = {1:d} / 1,2 = {2:d} / 1,3 = {3:06X}", g_arrColorSetIsClearStageTrophy[1]* ) . Format(" 2,1 = {1:d} / 2,2 = {2:d} / 2,3 = {3:06X}", g_arrColorSetIsClearStageTrophy[2]* ) . Format(" 3,1 = {1:d} / 3,2 = {2:d} / 3,3 = {3:06X}", g_arrColorSetIsClearStageTrophy[3]* ) )

nArenaX := ARENA_BASE_X + ARENA_BUTTON_X_GAP * ( mod((nStep - 1), 5) )
nArenaY := ARENA_BASE_Y + ARENA_BUTTON_X_GAP * ( (nStep - 1) // 5 )

; ARENA >> Stage 클릭
AppendLogWIndow( "ARENA >> Stage 클릭" )
ClickClientPoint( nArenaX, nArenaY, 500 )
ClickClientPoint( nArenaX, nArenaY, 500 )

; BATTLE OPPONENT 창 확인 색조합
g_arrColorSetIsBattleOpponent		:= [ [560, 109, 0x88C6D4], [636, 79, 0xFFEE44], [588, 133, 0x5AA5A6] ]
if ( WaitColorSet( g_arrColorSetIsBattleOpponent, 60 ) == 0 )
{
	AppendLogWIndow("Arena_98 BATTLE OPPONENT 창을 기다렸지만, 나타나지 않는 문제 발생")
	ExitApp, 0
}

ClickClientPoint( 400, 420, 500 )
ClickClientPoint( 400, 420, 500 )

AppendLogWIndow( "Waiting BATTLE OPPONENT" )
; ARENA 팀 설정을 하는 창 확인 색조합
g_arrColorSetIsArenaTeamSetting		:= [ [475, 249, 0x1C4E59], [607, 252, 0xFFFFFF], [720, 250, 0x1C4E59] ]
if ( WaitColorSet( g_arrColorSetIsArenaTeamSetting, 60 ) == 0 )
{
	AppendLogWIndow("Arena_109 BATTLE OPPONENT 창을 기다렸지만, 나타나지 않는 문제 발생")
	ExitApp, 0
}

AppendLogWIndow( "Click! : TEAM SETTING")
ClickClientPoint( 400, 420, 500 )
ClickClientPoint( 400, 420, 500 )

; 친구 선택 대기 화면 확인 색조합
g_arrColorSetIsSelectFriend			:= [ [294, 396, 0x07DA46], [412, 416, 0xFFFFFF], [510, 425, 0x05C232] ]
if ( WaitColorSet( g_arrColorSetIsSelectFriend, 60 ) == 0 )
{
	AppendLogWIndow("Arena_117 ARENA 친구 선택 대기 화면을 기다렸지만, 진입 실패")
	ExitApp, 0
}

SelectFriend( 0 ) ; 친구선택 취소

AppendLogWIndow( "Click! : Start ARENA'S COMBAT..")
ClickClientPoint( 400, 420, 500 )
ClickClientPoint( 400, 420, 500 )

; 전투 시작 확인용 색조합
g_arrColorSetIsArenaCombatStarted	:= [ [124, 393, 0xD8010E], [254, 393, 0xD8010E], [642, 393, 0xD8010E] ]
if ( WaitColorSet( g_arrColorSetIsArenaCombatStarted, 60 ) == 0 )
{
	AppendLogWIndow("Arena_134 전투 시작을 기다렸지만, 시작점을 찾지 못함")
	ExitApp, 0
}
;Sleep 6000

; 친구 클릭
AppendLogWIndow( "Click! : Friend...")
ClickClientPoint( 42, 87 )
ClickClientPoint( 42, 87, 500 )
ClickClientPoint( 42, 87, 500 )

AppendLogWIndow( "Combat Win. : Get treasure..")
; 보물상자 획득 확인용 색조합
g_arrColorSetIsTreasureOpened		:= [ [217, 108, 0x47008F], [533, 102, 0xFFE63D], [567, 98, 0x7F00FF] ]
Loop
{
	if ( IsSameColorSet( g_arrColorSetIsTreasureOpened ) )
		break

	; 보물상자 선택 (무조건 가운데 보물상자)
	ClickClientPoint( 400, 310, 1500 )
}
AppendLogWIndow( "Click OK : Go to ARENA main.")
ClickClientPoint( 400, 400, 1800 )
ClickClientPoint( 400, 400, 1800 )
ClickClientPoint( 400, 400, 1800 )


AppendLogWIndow( "Wait : ARENA Main")
g_arrColorSetIsArena := [ [132, 432, 0xFFEE44], [680, 391, 0xFFD43D], [225, 40, 0xFFEE44] ]
if ( WaitColorSet( g_arrColorSetIsArena, 60 ) == 0 )
{
	AppendLogWIndow("Arena_163 ARENA 전투 완료 처리 후, ARENA Main 대기")
	ExitApp, 0
}


Goto, ARENA_LOOP


#B::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
