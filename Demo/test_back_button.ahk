
#Include Global.ahk
#Include Utils_inc.ahk


if ( !InitializeLineRangers() )
{
	MsgBox LineRangers ��ũ��Ʈ �ʱ�ȭ ����!!!
	ExitApp, 0
}

CheckAppPlayer( g_nInstance )

SendBackButton()

ExitApp, 0