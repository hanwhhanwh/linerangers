;===============================================================================
; @file GuildRaid.ahk
; @author hbesthee@naver.com
; @date 2015-11-25
;
; @description GUILD RAID 모드 자동화
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


CheckAppPlayer( g_nInstance )
CreateLogWindow()

AppendLogWIndow( "Start [GUILD RAID] Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )

LoadGlobalVriable( "GUILD_RAID" )


nGuildRaidCount := 0


AppendLogWIndow("GUID RAID 화면인지 확인")
Sleep 1000
g_arrColorSetIsHelp := [ [400, 85, 0xF9F9F9], [600, 85, 0xF9F9F9], [700, 85, 0xF9F9F9] ]
if ( IsSameColorSet( g_arrColorSetIsHelp ) )
{
	AppendLogWIndow(" 도움말 창 닫기")
	ClickClientPoint( 770, 40, 500 )
	Sleep 1500
}
	
g_arrColorSetIsGuildRaid := [ [38, 412, 0xFFFFFF], [141, 398, 0xFFFFFF], [776, 433, 0xFFEE44] ]
if ( !IsSameColorSet( g_arrColorSetIsGuildRaid ) )
{
	AppendLogWIndow("GUID RAID 화면으로 이동...")
	ClickClientPoint( 770, 40, 500 )
	ClickClientPoint( 600, 260, 1000 )

	if ( !WaitColorSet( g_arrColorSetIsGuildRaid, 60 ) )
	{
		strMsg := "GUID RAID 화면을 기다렸지만, 나타나지 않는 문제 발생"
		AppendLogWIndow( strMsg )
		MsgBox, % strMsg, 0x40
		ExitApp, 0
	}
}

g_arrDungeonCoord := [ [680, 110, 4, 610], [406, 97, 5, 400], [545, 230, 3, 400], [330, 290, 2, 400], [130, 310, 1, 260] ]
nDungeonCount := g_arrDungeonCoord.Length()
Loop, % nDungeonCount
{
	nDungeonIndex := A_Index
	LOOP, 2
	{ 
		Sleep 500
		AppendLogWIndow("줌 아웃하기 : 전체 보기...")
		Sleep 1000
		ZoomOut( 545, 240 ) 

		Sleep 1500
		AppendLogWIndow("제일 아래 레벨로 이동...")
		DragMouse( 545, 440, 545, 120 )
		Sleep 1000
		DragMouse( 545, 440, 545, 220 )


		AppendLogWIndow( "던전 입장... #" . g_arrDungeonCoord[nDungeonIndex][3] )
		ClickClientPoint( g_arrDungeonCoord[nDungeonIndex][1], g_arrDungeonCoord[nDungeonIndex][2], 500 )
		
		g_arrColorSetDungeon := [ [403, 140, 0x4F2E10], [403, 270, 0x4F2E10], [403, 350, 0x4F2E10] ]
		if ( !WaitColorSet( g_arrColorSetDungeon, 60 ) )
		{
			strMsg := "GUID RAID - Dungeon 화면을 기다렸지만, 나타나지 않는 문제 발생"
			AppendLogWIndow( strMsg )
			MsgBox, % strMsg, 0x40
			ExitApp, 0
		}

		AppendLogWIndow("던전의 수호자와 자동 전투")
		nAB_Gap := 219
		if ( A_Index = 1)
			g_arrColorSetCanRaidGuardian := [ [472, 338, 0xECBA6E], [496, 338, 0xECBA6E], [534, 338, 0xECBA6E] ]
		else
			g_arrColorSetCanRaidGuardian := [ [253, 338, 0xECBA6E], [277, 338, 0xECBA6E], [315, 338, 0xECBA6E] ]

		AppendLogWIndow( " 수호자가 남아 있는지 확인하기 #" . A_Index )
		if ( IsSameColorSet(g_arrColorSetCanRaidGuardian) )
		{
			ClickClientPoint( g_arrColorSetCanRaidGuardian[2][1], g_arrColorSetCanRaidGuardian[2][2], 500 )

			g_arrColorSetAttackGuardian := [ [95, 410, 0x6A7E96], [110, 422, 0xFFD43D], [150, 423, 0xFFFFFF] ]
			if ( !WaitColorSet( g_arrColorSetAttackGuardian, 60 ) )
			{
				strMsg := " ATTACK을 위한 화면을 기다렸지만, 나타나지 않는 문제 발생"
				AppendLogWIndow( strMsg )
				MsgBox, % strMsg, 0x40
				ExitApp, 0
			}

			ClickClientPoint( 400, 425, 1000 )

			ProduceRangers4GuildRaid( g_hwndAppPlayer, g_isChangingTeam, g_nPeriodOfChangingTeam )

			ClickClientPoint( 25, 40, 5000 )
			ClickClientPoint( 25, 40, 1500 )
						if ( !WaitColorSet( g_arrColorSetIsGuildRaid, 60 ) )
			{
				strMsg := " GUID RAID[106] 화면을 기다렸지만, 나타나지 않는 문제 발생"
				AppendLogWIndow( strMsg )
				MsgBox, % strMsg, 0x40
				ExitApp, 0
			}
			nGuildRaidCount := nGuildRaidCount + 1
			
			if ( nGuildRaidCount >= 3 )
				break
		}
		else
		{
			AppendLogWIndow( "수호자가 부활하는 중임 : #" . A_Index )
			ClickClientPoint( 626, 73, 500 )
			Sleep 500
		}
	}


}
ExitApp, 0



#B::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	strMsg := "GUILD RAID 에 대한 스크립트를 강제로 종료합니다."
	AppendLogWIndow( strMsg )
	ExitApp, 0
return
