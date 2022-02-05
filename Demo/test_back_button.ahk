
#Include Global.ahk
#Include Utils_inc.ahk


if ( !InitializeLineRangers() )
{
	MsgBox LineRangers 스크립트 초기화 실패!!!
	ExitApp, 0
}

CheckAppPlayer( g_nInstance )

SendBackButton()

ExitApp, 0