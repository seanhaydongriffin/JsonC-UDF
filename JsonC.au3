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
Global Enum _
		$JSONC_TYPE_NULL, _
		$JSONC_TYPE_BOOLEAN, _
		$JSONC_TYPE_DOUBLE, _
		$JSONC_TYPE_INT, _
		$JSONC_TYPE_OBJECT, _
		$JSONC_TYPE_ARRAY, _
		$JSONC_TYPE_STRING

Global Const $tagJSONC_OBJECT = _
	"struct;"              		& _
    "int   o_type;"        		& _
	"uint  _ref_count;"    		& _
	"ptr   _to_json_string;"  	& _
	"ptr   _pb;"        		& _
	"ptr   _user_delete;" 		& _
	"ptr   _userdata;"      	& _
	"endstruct;"
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _JsonC_Startup
; _JsonC_Shutdown
; _JsonC_TokenerParse
; _JsonC_ObjectToJsonString
; _JsonC_ObjectIsType
; _JsonC_ObjectGetType
; _JsonC_ObjectGetBoolean
; _JsonC_ObjectGetDouble
; _JsonC_ObjectGetInteger
; _JsonC_ObjectGetObject
; _JsonC_ObjectGetArray
; _JsonC_ObjectGetString
; _JsonC_ObjectGetValue
; _JsonC_ObjectObjectGet
; _JsonC_ObjectArrayLength
; _JsonC_ObjectArrayGetIndex
; _JsonC_ObjectArrayGetObjects
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
	Local $tJsonObject = DllStructCreate($tagJSONC_OBJECT, $avRval[0])
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
; Name ..........: _JsonC_ObjectGetType
; Description ...: Checks if the json object is of a given type
; Syntax ........: _JsonC_ObjectGetType($tObject)
; Parameters ....: $tObject      - Get the type of the json object.
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
Func _JsonC_ObjectGetType($tObject)
	Local $avRval = DllCall($__g_hDll_JsonC, "int", "json_object_get_type", "ptr", DllStructGetPtr($tObject))
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
; Name ..........: _JsonC_TypeToName
; Description ...: Checks if the json object is of a given type
; Syntax ........: _JsonC_TypeToName($iType)
; Parameters ....: $tObject      - Get the type of the json object.
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
Func _JsonC_TypeToName($iType)
	Local $avRval = DllCall($__g_hDll_JsonC, "str", "json_type_to_name", "int", $iType)
	If @error Then Return SetError(1, @error, 0) ; DllCall error
	Return $avRval[0]
EndFunc


; #FUNCTION# ======================================================================================
; Name ..........: _JsonC_ObjectObjectGet
; Description ...: Checks if the json object is of a given type
; Syntax ........: _JsonC_ObjectObjectGet($tObject, $sKey)
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
Func _JsonC_ObjectObjectGet($tObject, $sKey)
	Local $avRval = DllCall($__g_hDll_JsonC, "ptr", "json_object_object_get", "ptr", DllStructGetPtr($tObject), "str", $sKey)
	If @error Then Return SetError(1, @error, 0) ; DllCall error
	Local $tJsonObject = DllStructCreate($tagJSONC_OBJECT, $avRval[0])
	If @error Then Return SetError(1, @error, 0) ; DllCall error
	Return $tJsonObject
EndFunc

; #FUNCTION# ======================================================================================
; Name ..........: _JsonC_ObjectGetBoolean
; Description ...: Get the json bool value of a json object
; Syntax ........: _JsonC_ObjectGetBoolean($tObject)
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
Func _JsonC_ObjectGetBoolean($tObject)
	Local $avRval = DllCall($__g_hDll_JsonC, "boolean", "json_object_get_boolean", "ptr", DllStructGetPtr($tObject))
	If @error Then Return SetError(1, @error, 0) ; DllCall error
	Return $avRval[0]
EndFunc

; #FUNCTION# ======================================================================================
; Name ..........: _JsonC_ObjectGetDouble
; Description ...: Get the double floating point value of a json object
; Syntax ........: _JsonC_ObjectGetDouble($tObject)
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
Func _JsonC_ObjectGetDouble($tObject)
	Local $avRval = DllCall($__g_hDll_JsonC, "double", "json_object_get_double", "ptr", DllStructGetPtr($tObject))
	If @error Then Return SetError(1, @error, 0) ; DllCall error
	Return $avRval[0]
EndFunc

; #FUNCTION# ======================================================================================
; Name ..........: _JsonC_ObjectGetInt
; Description ...: Checks if the json object is of a given type
; Syntax ........: _JsonC_ObjectGetInt($tObject)
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
Func _JsonC_ObjectGetInteger($tObject)
	Local $avRval = DllCall($__g_hDll_JsonC, "int", "json_object_get_int", "ptr", DllStructGetPtr($tObject))
	If @error Then Return SetError(1, @error, 0) ; DllCall error
	Return $avRval[0]
EndFunc

; #FUNCTION# ======================================================================================
; Name ..........: _JsonC_ObjectGetObject
; Description ...: Get the hashtable of a json object of type json type object
; Syntax ........: _JsonC_ObjectGetObject($tObject)
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
Func _JsonC_ObjectGetObject($tObject)
	Local $avRval = DllCall($__g_hDll_JsonC, "ptr", "json_object_get_object", "ptr", DllStructGetPtr($tObject))
	If @error Then Return SetError(1, @error, 0) ; DllCall error
	Return $avRval[0]
EndFunc

; #FUNCTION# ======================================================================================
; Name ..........: _JsonC_ObjectGetArray
; Description ...: Get the arraylist of a json object of type json type array
; Syntax ........: _JsonC_ObjectGetArray($tObject)
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
Func _JsonC_ObjectGetArray($tObject)
	Local $avRval = DllCall($__g_hDll_JsonC, "ptr", "json_object_get_array", "ptr", DllStructGetPtr($tObject))
	If @error Then Return SetError(1, @error, 0) ; DllCall error
	Return $avRval[0]
EndFunc

; #FUNCTION# ======================================================================================
; Name ..........: _JsonC_ObjectGetString
; Description ...: Checks if the json object is of a given type
; Syntax ........: _JsonC_ObjectGetString($tObject)
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
Func _JsonC_ObjectGetString($tObject)
	Local $avRval = DllCall($__g_hDll_JsonC, "str", "json_object_get_string", "ptr", DllStructGetPtr($tObject))
	If @error Then Return SetError(1, @error, 0) ; DllCall error
	Return $avRval[0]
EndFunc

; #FUNCTION# ======================================================================================
; Name ..........: _JsonC_ObjectGetValue
; Description ...: Get the value of a json object of any type
; Syntax ........: _JsonC_ObjectGetValue($tObject)
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
Func _JsonC_ObjectGetValue($tObject)
	Switch _JsonC_ObjectGetType($tObject)
		Case $JSONC_TYPE_NULL
			Return ""
		Case $JSONC_TYPE_BOOLEAN
			Return _JsonC_ObjectGetBoolean($tObject)
		Case $JSONC_TYPE_DOUBLE
			Return _JsonC_ObjectGetDouble($tObject)
		Case $JSONC_TYPE_INT
			Return _JsonC_ObjectGetInteger($tObject)
		Case $JSONC_TYPE_OBJECT
			Return _JsonC_ObjectGetObject($tObject)
		Case $JSONC_TYPE_ARRAY
			Return _JsonC_ObjectGetArray($tObject)
		Case $JSONC_TYPE_STRING
			Return _JsonC_ObjectGetString($tObject)
	EndSwitch
	Return SetError(1, @error, 0)
EndFunc

; #FUNCTION# ======================================================================================
; Name ..........: _JsonC_ObjectArrayLength
; Description ...: Get the length of a json object of type json_type_array
; Syntax ........: _JsonC_ObjectArrayLength($tObject)
; Parameters ....: $tObject      - the json object instance
; Return values .: Success - return a non-NULL json_object if a valid JSON value is found
;                       @extended = next string offset
;                  Failure - Return a "" (NULL) and set @error to:
;                       @error = 1 - part is not json-syntax
;                              = 2 - key name in object part is not json-syntax
;                              = 3 - value in object is not correct json
;                              = 4 - delimiter or object end expected but not gained
; Author ........: SeanGriffin
; =================================================================================================
Func _JsonC_ObjectArrayLength($tObject)
	Local $avRval = DllCall($__g_hDll_JsonC, "int64", "json_object_array_length", "ptr", DllStructGetPtr($tObject))
	If @error Then Return SetError(1, @error, 0) ; DllCall error
	Return $avRval[0]
EndFunc

; #FUNCTION# ======================================================================================
; Name ..........: _JsonC_ObjectArrayGetIndex
; Description ...: Get the element at specificed index of the array
; Syntax ........: _JsonC_ObjectArrayGetIndex($tObject, $iIndex)
; Parameters ....: $tObject      - a json object of type json_type_array
;				   $iIndex
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
Func _JsonC_ObjectArrayGetIndex($tObject, $iIndex)
	Local $avRval = DllCall($__g_hDll_JsonC, "ptr", "json_object_array_get_idx", "ptr", DllStructGetPtr($tObject), "int", $iIndex)
	If @error Then Return SetError(1, @error, 0) ; DllCall error
	Local $tJsonObject = DllStructCreate($tagJSONC_OBJECT, $avRval[0])
	If @error Then Return SetError(1, @error, 0) ; DllCall error
	Return $tJsonObject
EndFunc

; #FUNCTION# ======================================================================================
; Name ..........: _JsonC_ObjectArrayGetObjects
; Description ...: Get all the json objects from an array
; Syntax ........: _JsonC_ObjectArrayGetObjects($tObject, $iIndex)
; Parameters ....: $tObject      - an AutoIt array of json objects
; Return values .: Success - return a non-NULL json_object if a valid JSON value is found
;                       @extended = next string offset
;                  Failure - Return a "" (NULL) and set @error to:
;                       @error = 1 - part is not json-syntax
;                              = 2 - key name in object part is not json-syntax
;                              = 3 - value in object is not correct json
;                              = 4 - delimiter or object end expected but not gained
; Author ........: SeanGriffin
; =================================================================================================
Func _JsonC_ObjectArrayGetObjects($tObject)

	$ArrayLength = _JsonC_ObjectArrayLength($tObject)
	Dim $avRval[$ArrayLength]

	for $i = 0 to _JsonC_ObjectArrayLength($tObject) - 1
		$avRval[$i] = _JsonC_ObjectArrayGetIndex($tObject, $i)
	Next

	Return $avRval
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
