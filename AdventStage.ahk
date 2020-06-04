;===============================================================================
; @file AdventStage.ahk
; @author hbesthee@naver.com
; @date 2017-10-07
;
; @description ADVENT STAGE 모드 자동화
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

nAdventStage := 0
strIniSctionName := "ADVENT STAGE"

CheckAppPlayer( g_nInstance )
CreateLogWindow()
LoadGlobalVriable( strIniSctionName )

IniRead, nRoomIndex, LineRangers.ini, %strIniSctionName%, RoomIndex, 2
IniRead, nDifficult, LineRangers.ini, %strIniSctionName%, Difficult, 1
IniRead, isAutoCombat, LineRangers.ini, %strIniSctionName%, AutoCombat, 0
IniRead, isProduceRanger0, LineRangers.ini, %strIniSctionName%, ProduceRanger0, 1
IniRead, isProduceRanger1, LineRangers.ini, %strIniSctionName%, ProduceRanger1, 1
IniRead, isProduceRanger2, LineRangers.ini, %strIniSctionName%, ProduceRanger2, 1
IniRead, isProduceRanger3, LineRangers.ini, %strIniSctionName%, ProduceRanger3, 1
IniRead, isProduceRanger4, LineRangers.ini, %strIniSctionName%, ProduceRanger4, 1

if (nRoomIndex < 0)
	nRoomIndex := 0
if (nRoomIndex > 2)
	nRoomIndex := 2
if (nDifficult < 0)
	nDifficult := 0
if (nDifficult > 4)
	nDifficult := 4

AppendLogWIndow( "Start [ADVENT STAGE] Script : Room #" . nRoomIndex . " Difficult = " . nDifficult )
AppendLogWIndow( "    ADVENT STAGE 확인" )
g_arrColorSetIsAdventStage := [ [118, 330, 0xFFF72B], [336, 330, 0xFFF72B], [553, 330, 0xFFF72B] ]
bTimeout := WaitColorSet(g_arrColorSetIsAdventStage)
If ( bTimeout = 0 )
{
	MsgBox, AppPlayer%g_nInstance% Advent stage 화면에서 시작하여 주시기 바랍니다...
	AppendLogWIndow( "    ADVENT STAGE >> Advent stage 화면확인 실패. : " . A_TickCount)
	ExitApp, 0
}


LOOP_ADVENT:


nMouseX := 183 + nRoomIndex * 220
AppendLogWIndow( "    Enter enemy room #" . nRoomIndex )
ClickClientPoint( nMouseX, 340, 1000 )


nMouseX := 203 + nDifficult * 100
AppendLogWIndow( "    Select difficult : " . nDifficult )
ClickClientPoint( nMouseX, 273, 1000 )

AppendLogWIndow( "    Waiting ranger room..." )
arrColorSetAdventRangerRoom := [ [102, 350, 0], [292, 400, 0x07D1DE], [500, 410, 0x0ABCCB] ]
if ( WaitColorSet( arrColorSetAdventRangerRoom, 30 ) = 0 )
{
	MsgBox, [ADVENT STAGE] Script : Waiting ranger room error
	ExitApp, 0
}

ClickClientPoint( 400, 412, 1000 )


AppendLogWIndow( "    Waiting friend selection..." )
arrColorSetFriendSelection := [ [292, 400, 0x07DA46], [480, 405, 0xFFFFFF], [500, 410, 0x05C232] ]
if ( WaitColorSet( arrColorSetFriendSelection, 30 ) = 0 )
{
	MsgBox, [ADVENT STAGE] Script : Waiting ranger room error
	ExitApp, 0
}

ClickClientPoint( 400, 412, 1000 )


AppendLogWIndow( "    Waiting advent combat..." )
arrColorSetAdventCombat := [ [90, 429, 0x4A1908], [130, 440, 0xDD9955], [760, 77, 0x030201] ]
if ( WaitColorSet( arrColorSetAdventCombat, 30 ) = 0 )
{
	MsgBox, [ADVENT STAGE] Script : Waiting advent combat error
	ExitApp, 0
}


; 초기 레인저 생산
if (isProduceRanger0)
	ProduceRander( 235 )

if (isProduceRanger1)
	ProduceRander( 320 )

if (isProduceRanger2)
	ProduceRander( 400 )

if (isProduceRanger3)
	ProduceRander( 480 )

if (isProduceRanger4)
	ProduceRander( 570 )

	
if (isAutoCombat)
{
	ClickClientPoint( 765, 110 )
	ClickClientPoint( 765, 110, 1000 )
}


nPrevChangingTeamTick := A_TickCount, nPrevMissileTick := A_TickCount

Loop ; 무한정 레인져 뽑기
{
	If ( IsFinishCombat() )
		break ; Clear 시 빠져 나오기

	If ( isChangingTeam And ( nPeriodOfChangingTerm > 2500 ) )
	{
		nCurrentChangingTeamTick := A_TickCount
		If ( Abs(nCurrentChangingTeamTick - nPrevChangingTeamTick) > nPeriodOfChangingTerm )
		{ ; 팀 바꾸기
			ClickClientPoint( 42, 50 )
			ClickClientPoint( 42, 50, 100 )
			nPrevChangingTeamTick := A_TickCount
		}
	}

	if ( !isAutoCombat )
	{
		if (isProduceRanger0)
			ProduceRander( 235 )

		if (isProduceRanger1)
			ProduceRander( 320 )

		if (isProduceRanger2)
			ProduceRander( 400 )

		if (isProduceRanger3)
			ProduceRander( 480 )

		if (isProduceRanger4)
			ProduceRander( 570 )

		nCurrentMissileTick := A_TickCount
		if ( Abs(nCurrentMissileTick - nPrevMissileTick) > 100 )
		{
			ClickClientPoint( 125, 410 )
			nPrevMissileTick := A_TickCount
			Producemineral( 675 )
		}
	}
}
AppendLogWIndow("    Advent combat finished!!!")

Sleep, 2000

bTimeout := WaitStartingRoulette()
If ( bTimeout = 0 )
{
	MsgBox, AppPlayer%g_nInstance% Normal stage의 전투 결과 보상 룰렛이 동작하는 것을 감지입하지 못하였습니다...
	ExitApp, 0
}


AppendLogWIndow( "    ADVENT STAGE : 보상 수령하기" )
AcceptClearBonus() ; 보상 수령


nAdventStage := nAdventStage + 1


AppendLogWIndow( "    ADVENT STAGE : Loop 마지막 #" . nAdventStage )
bTimeout := WaitColorSet(g_arrColorSetIsAdventStage)
If ( bTimeout = 0 )
{
	MsgBox, AppPlayer%g_nInstance% Advent stage 화면에서 시작하여 주시기 바랍니다...
	AppendLogWIndow( "    ADVENT STAGE >> Advent stage 화면으로 이동하지 못하여 종료. : " . A_TickCount)
	ExitApp, 0
}


goto, LOOP_ADVENT

ExitApp, 0



#B::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	strMsg := "ADVENT STAGE 에 대한 스크립트를 강제로 종료합니다."
	AppendLogWIndow( strMsg )
	ExitApp, 0
return
