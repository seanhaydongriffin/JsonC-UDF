#AutoIt3Wrapper_UseX64=y
#include-once

; #INDEX# =======================================================================================================================
; Title .........: JsonC
; AutoIt Version : 3.3.16.0
; Language ......: English
; Description ...: Functions for constructing JSON objects using JSON-C (https://github.com/json-c/json-c).
; Author(s) .....: Sean Griffin
; Dll ...........: json-c.dll
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_hDll_JsonC = 0
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $JSONC_TYPE_NULL = 0
Global Const $JSONC_TYPE_BOOLEAN = 1
Global Const $JSONC_TYPE_DOUBLE = 2
Global Const $JSONC_TYPE_INT = 3
Global Const $JSONC_TYPE_OBJECT = 4
Global Const $JSONC_TYPE_ARRAY = 5
Global Const $JSONC_TYPE_STRING = 6
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _JsonC_Startup
; _JsonC_Shutdown
; _JsonC_TokenerParse
; _JsonC_ObjectToJsonString
; _JsonC_LibVersion
; _JsonC_LastInsertRowID
; _JsonC_GetTable2D
; _JsonC_Changes
; _JsonC_TotalChanges
; _JsonC_ErrCode
; _JsonC_ErrMsg
; _JsonC_Display2DResult
; _JsonC_FetchData
; _JsonC_Query
; _JsonC_SetTimeout
; _JsonC_SafeMode
; _JsonC_QueryFinalize
; _JsonC_QueryReset
; _JsonC_FetchNames
; _JsonC_QuerySingleRow
; _JsonC_JsonCExe
; _JsonC_Encode
; _JsonC_Escape
; _JsonC_FastEncode
; _JsonC_FastEscape
; _JsonC_GetTableData2D
; ===============================================================================================================================


; #FUNCTION# ======================================================================================
; Name ..........: _JsonC_Startup
; Description ...: Loads json-c.dll
; Syntax ........: _JsonC_Startup($sDll_Filename = "")
; Parameters ....: $s_String      - a string formatted as JSON
;                  [$i_Os]        - search position where to start (normally don't touch!)
; Return values .: Success - Return a nested structure of AutoIt-datatypes
;                       @extended = next string offset
;                  Failure - Return "" and set @error to:
;                       @error = 1 - part is not json-syntax
;                              = 2 - key name in object part is not json-syntax
;                              = 3 - value in object is not correct json
;                              = 4 - delimiter or object end expected but not gained
; Author ........: AspirinJunkie
; =================================================================================================
Func _JsonC_Startup($sDll_Filename = "") ;, $bUTF8ErrorMsg = False, $iForceLocal = 0, $hPrintCallback = $__g_hPrintCallback_SQLite, $bAutoItTypeConversion = False)
	If $sDll_Filename = Default Or $sDll_Filename = -1 Then $sDll_Filename = ""

	; The $hPrintCallback parameter may look strange to assign it to $__g_hPrintCallback_SQLite as
	; a default.  This is done so that $__g_hPrintCallback_SQLite can be pre-initialized with the internal
	; callback in a single place in case that callback changes.  If the user overrides it then
	; that value becomes the new default.  An empty string will suppress any display.
	;If $hPrintCallback = Default Then $hPrintCallback = __SQLite_ConsoleWrite
	;$__g_hPrintCallback_SQLite = $hPrintCallback

	;If $bUTF8ErrorMsg = Default Then $bUTF8ErrorMsg = False
	;$__g_bUTF8ErrorMsg_SQLite = $bUTF8ErrorMsg

	If $sDll_Filename = "" Then $sDll_Filename = "json-c.dll"

	Local $iExtended = 0
	;If Int($iForceLocal) < 1 Then
	;	$sDll_Filename = __SQLite_GetDownloadedPath($sDll_Filename) & $sDll_Filename
	;	$iExtended = @extended
	;EndIf

	Local $hDll = DllOpen($sDll_Filename)
	If $hDll = -1 Then
		$__g_hDll_JsonC = 0
		Return SetError(1, $iExtended, "")
	Else
		$__g_hDll_JsonC = $hDll
		Return SetExtended($iExtended, $sDll_Filename)
	EndIf

	;$__g_bAutoItType_SQLite = $bAutoItTypeConversion
EndFunc   ;==>_SQLite_Startup




; #FUNCTION# ======================================================================================
; Name ..........: _JsonC_Tokener_Parse
; Description ...: Parse a string and return a json_object
; Syntax ........: _JsonC_Tokener_Parse(ByRef $sString)
; Parameters ....: $sString      - a string formatted as JSON
;                  [$i_Os]        - search position where to start (normally don't touch!)
; Return values .: Success - return a non-NULL json_object if a valid JSON value is found
;                       @extended = next string offset
;                  Failure - Return a "" (NULL) and set @error to:
;                       @error = 1 - part is not json-syntax
;                              = 2 - key name in object part is not json-syntax
;                              = 3 - value in object is not correct json
;                              = 4 - delimiter or object end expected but not gained
; Author ........: SeanGriffin
; =================================================================================================
Func _JsonC_TokenerParse($sString)
	Local $avRval = DllCall($__g_hDll_JsonC, "ptr", "json_tokener_parse", "str", $sString)
	If @error Then Return SetError(1, @error, 0) ; DllCall error
	If $avRval[0] = "" Then
		;__SQLite_ReportError($avRval[2], "_SQLite_Open")
		Return SetError(-1, $avRval[0], 0)
	EndIf

	Local $gtag_json_object = _
           "struct;"              		& _
           "int   o_type;"        		& _
           "uint  _ref_count;"    		& _
           "ptr   _to_json_string;"  	& _
           "ptr   _pb;"        			& _
           "ptr   _user_delete;" 		& _
           "ptr   _userdata;"      		& _
           "endstruct;"


	Local $tJsonObject = DllStructCreate($gtag_json_object,$avRval[0])
	If @error Then Return SetError(1, @error, 0) ; DllCall error

	Return $tJsonObject
EndFunc


; #FUNCTION# ======================================================================================
; Name ..........: _JsonC_ObjectToJsonString
; Description ...: Stringify object to json format.
; Syntax ........: _JsonC_ObjectToJsonString($tObject)
; Parameters ....: $tObject      - the json_object instance
;                  [$i_Os]        - search position where to start (normally don't touch!)
; Return values .: Success - return a non-NULL json_object if a valid JSON value is found
;                       @extended = next string offset
;                  Failure - Return a "" (NULL) and set @error to:
;                       @error = 1 - part is not json-syntax
;                              = 2 - key name in object part is not json-syntax
;                              = 3 - value in object is not correct json
;                              = 4 - delimiter or object end expected but not gained
; Author ........: SeanGriffin
; =================================================================================================
Func _JsonC_ObjectToJsonString($tObject)
	Local $avRval = DllCall($__g_hDll_JsonC, "str", "json_object_to_json_string", "ptr", DllStructGetPtr($tObject))
	If @error Then Return SetError(1, @error, 0) ; DllCall error
	Return $avRval[0]
EndFunc


; #FUNCTION# ======================================================================================
; Name ..........: _JsonC_ObjectIsType
; Description ...: Checks if the json object is of a given type
; Syntax ........: _JsonC_ObjectIsType($tObject)
; Parameters ....: $tObject      - the json object instance
;
;                  [$i_Os]        - search position where to start (normally don't touch!)
; Return values .: Success - return a non-NULL json_object if a valid JSON value is found
;                       @extended = next string offset
;                  Failure - Return a "" (NULL) and set @error to:
;                       @error = 1 - part is not json-syntax
;                              = 2 - key name in object part is not json-syntax
;                              = 3 - value in object is not correct json
;                              = 4 - delimiter or object end expected but not gained
; Author ........: SeanGriffin
; =================================================================================================
Func _JsonC_ObjectIsType($tObject, $iType)
	Local $avRval = DllCall($__g_hDll_JsonC, "int", "json_object_is_type", "ptr", DllStructGetPtr($tObject), "int", $iType)
	If @error Then Return SetError(1, @error, 0) ; DllCall error
	Return $avRval[0]
EndFunc


; #FUNCTION# ======================================================================================
; Name ..........: _JsonC_Shutdown
; Description ...: Unloads json-c.dll
; Syntax ........: _JsonC_Shutdown()
; Parameters ....: $s_String      - a string formatted as JSON
;                  [$i_Os]        - search position where to start (normally don't touch!)
; Return values .: Success - Return a nested structure of AutoIt-datatypes
;                       @extended = next string offset
;                  Failure - Return "" and set @error to:
;                       @error = 1 - part is not json-syntax
;                              = 2 - key name in object part is not json-syntax
;                              = 3 - value in object is not correct json
;                              = 4 - delimiter or object end expected but not gained
; Author ........: AspirinJunkie
; =================================================================================================
Func _JsonC_Shutdown()
	If $__g_hDll_JsonC > 0 Then DllClose($__g_hDll_JsonC)
	$__g_hDll_JsonC = 0
EndFunc
