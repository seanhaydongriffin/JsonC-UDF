#AutoIt3Wrapper_UseX64=y
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPISysWin.au3>
#include <WinAPIGdi.au3>
#include <FontConstants.au3>

#include <GuiTreeView.au3>
#include "JsonC.au3"


Global $hConsolasFont = _WinAPI_CreateFont(14, 0, 0, 0, $FW_NORMAL, False, False, False, $DEFAULT_CHARSET, $OUT_OUTLINE_PRECIS, $CLIP_DEFAULT_PRECIS, $PROOF_QUALITY, $DEFAULT_PITCH, 'Consolas')

_JsonC_Startup("json-c.dll")

;$str = FileRead("pokeapi.co.json")
;$Json = _JsonC_TokenerParse($str)
;ConsoleWrite("JSON type: " & _JsonC_TypeToName(_JsonC_ObjectGetType($Json)) & ", string: " & _JsonC_ObjectToJsonString($Json) & @CRLF)

Local $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES)

Global $hGUI = GUICreate("Example2", 640, 800, -1, -1, -1, $WS_EX_TOPMOST)
Global $entity_treeview = _GUICtrlTreeView_Create($hGUI, 20, 70, 560, 260, $iStyle, $WS_EX_CLIENTEDGE)
_WinAPI_SetFont($entity_treeview, $hConsolasFont)

GUISetState(@SW_SHOW, $hGUI)

#cs
$str = FileRead("meta.json")

Local $hTimer = TimerInit()
$Json = _JsonC_TokenerParse($str)
$actions = _JsonC_ObjectArrayGetObjects(_JsonC_ObjectObjectGet($Json, "actions"))
_GUICtrlTreeView_BeginUpdate($entity_treeview)
For $action in $actions
	$type = _JsonC_TypeToName(_JsonC_ObjectGetType($action))
	$value = _JsonC_ObjectGetValue($action)
	;ConsoleWrite("action type: " & $type & ", value: " & $value & @CRLF)
	_GUICtrlTreeView_AddChild($entity_treeview, 0, $value)
Next
_GUICtrlTreeView_EndUpdate($entity_treeview)
Local $fDiff = TimerDiff($hTimer)

ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $fDiff = ' & $fDiff & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
#ce






$str = FileRead("aes.json")

Local $hTimer = TimerInit()
$Json = _JsonC_TokenerParse($str)
$Data = _JsonC_ObjectObjectGet($Json, "data")
$EntitiesInfo = _JsonC_ObjectArrayGetObjects(_JsonC_ObjectObjectGet($Data, "entitiesInfo"))
_GUICtrlTreeView_BeginUpdate($entity_treeview)
For $EntityInfo in $EntitiesInfo
	$Infos = _JsonC_ObjectArrayGetObjects($EntityInfo)
	For $Info in $Infos
		$key = _JsonC_ObjectGetFieldValue($Info, "key")
		if $key == "Name" Then
			$value = _JsonC_ObjectGetFieldValue($Info, "value")
			_GUICtrlTreeView_AddChild($entity_treeview, 0, $value)
		EndIf
	Next
Next
_GUICtrlTreeView_EndUpdate($entity_treeview)
Local $fDiff = TimerDiff($hTimer)

ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $fDiff = ' & $fDiff & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console






;Exit



		;if $child_entity_type_index = 0 Then
		;	_GUICtrlTreeView_DeleteAll($entity_treeview)
		;	$entity_metadata.RemoveAll
		;EndIf





Local $iMsg = 0
While 1
	$iMsg = GUIGetMsg(1)
	Switch $iMsg[0]

		Case $GUI_EVENT_CLOSE
			;If $iMsg[1] = $element_details_gui Then GUISetState(@SW_HIDE, $element_details_gui)
			If $iMsg[1] = $hGUI Then ExitLoop
	EndSwitch
WEnd


Exit

$jobj = _JsonC_ObjectNewObject()
_JsonC_ObjectObjectAdd($jobj, "name", _JsonC_ObjectNewString("Alice"))
_JsonC_ObjectObjectAdd($jobj, "age", _JsonC_ObjectNewInt(30))
$jarr = _JsonC_ObjectNewArray()
_JsonC_ObjectArrayAdd($jarr, _JsonC_ObjectNewString("Paula"))
_JsonC_ObjectArrayAdd($jarr, _JsonC_ObjectNewString("Cindy"))
_JsonC_ObjectArrayAdd($jarr, _JsonC_ObjectNewString("Dorothy"))
_JsonC_ObjectObjectAdd($jobj, "friends", $jarr)
$str = _JsonC_ObjectToJsonString($jobj)
ConsoleWrite("String: " & $str & @CRLF)

$Json = _JsonC_TokenerParse($str)
ConsoleWrite("JSON type: " & _JsonC_TypeToName(_JsonC_ObjectGetType($Json)) & ", string: " & _JsonC_ObjectToJsonString($Json) & @CRLF)

$Name = _JsonC_ObjectObjectGet($Json, "name")
ConsoleWrite("Name type: " & _JsonC_TypeToName(_JsonC_ObjectGetType($Name)) & ", value: " & _JsonC_ObjectGetValue($Name) & @CRLF)

$Age = _JsonC_ObjectObjectGet($Json, "age")
ConsoleWrite("Age type: " & _JsonC_TypeToName(_JsonC_ObjectGetType($Age)) & ", value: " & _JsonC_ObjectGetValue($Age) & @CRLF)

$Friends = _JsonC_ObjectArrayGetObjects(_JsonC_ObjectObjectGet($Json, "friends"))
For $Friend in $Friends
	ConsoleWrite("Friend type: " & _JsonC_TypeToName(_JsonC_ObjectGetType($Friend)) & ", value: " & _JsonC_ObjectGetValue($Friend) & @CRLF)
Next

_JsonC_Shutdown()

