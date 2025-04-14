#AutoIt3Wrapper_UseX64=y
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPISysWin.au3>
#include <WinAPIGdi.au3>
#include <FontConstants.au3>
#include <GuiTreeView.au3>
#include "JsonC.au3"

_JsonC_Startup("json-c.dll")

Global $hGUI = GUICreate("Example2 - Performance tests", 640, 460, -1, -1, -1, $WS_EX_TOPMOST)
Local $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES)
Global $entity_treeview = _GUICtrlTreeView_Create($hGUI, 20, 70, 560, 260, $iStyle, $WS_EX_CLIENTEDGE)
Global $hConsolasFont = _WinAPI_CreateFont(14, 0, 0, 0, $FW_NORMAL, False, False, False, $DEFAULT_CHARSET, $OUT_OUTLINE_PRECIS, $CLIP_DEFAULT_PRECIS, $PROOF_QUALITY, $DEFAULT_PITCH, 'Consolas')
_WinAPI_SetFont($entity_treeview, $hConsolasFont)
Global $message_label = GUICtrlCreateLabel("", 20, 360, 600, 20)
Global $next_test_button = GUICtrlCreateButton("Next Test", 20, 400, 100, 20)
GUISetState(@SW_SHOW, $hGUI)

Test1()

Local $iMsg = 0
While 1
	$iMsg = GUIGetMsg(1)
	Switch $iMsg[0]
		Case $next_test_button
			_GUICtrlTreeView_DeleteAll($entity_treeview)
			GUICtrlSetData($message_label, "")
			Test2()
			GUICtrlSetState($next_test_button, $GUI_HIDE)
		Case $GUI_EVENT_CLOSE
			If $iMsg[1] = $hGUI Then ExitLoop
	EndSwitch
WEnd

_JsonC_Shutdown()

Func Test1()
	$str = FileRead("meta.json")

	Local $hTimer = TimerInit()
	$Json = _JsonC_TokenerParse($str)
	$actions = _JsonC_ObjectArrayGetObjects(_JsonC_ObjectObjectGet($Json, "actions"))
	_GUICtrlTreeView_BeginUpdate($entity_treeview)
	For $action in $actions
		;$type = _JsonC_TypeToName(_JsonC_ObjectGetType($action))
		$value = _JsonC_ObjectGetValue($action)
		_GUICtrlTreeView_AddChild($entity_treeview, 0, $value)
	Next
	_GUICtrlTreeView_EndUpdate($entity_treeview)
	Local $fDiff = TimerDiff($hTimer)

	GUICtrlSetData($message_label, "Took " & $fDiff & " ms to parse meta.json, extract the actions array, and add each action to the tree.")
EndFunc

Func Test2()
	$str = FileRead("pokeapi.co.json")

	Local $hTimer = TimerInit()
	$Json = _JsonC_TokenerParse($str)
	$Moves = _JsonC_ObjectArrayGetObjects(_JsonC_ObjectObjectGet($Json, "moves"))
	_GUICtrlTreeView_BeginUpdate($entity_treeview)
	For $Move in $Moves
		$MoveDetails = _JsonC_ObjectObjectGet($Move, "move")
		$name = _JsonC_ObjectGetFieldValue($MoveDetails, "name")
		_GUICtrlTreeView_AddChild($entity_treeview, 0, $name)
	Next
	_GUICtrlTreeView_EndUpdate($entity_treeview)
	Local $fDiff = TimerDiff($hTimer)

	GUICtrlSetData($message_label, "Took " & $fDiff & " ms to parse pokeapi.co.json, extract the moves array, and add each move to the tree.")
EndFunc
