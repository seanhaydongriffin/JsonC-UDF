#AutoIt3Wrapper_UseX64=y
;#AutoIt3Wrapper_Run_Au3Stripper=y
#include <Constants.au3>
#include <WinAPIDiag.au3>
#include "JsonC.au3"


_JsonC_Startup("json-c2.dll")

$fred = _JsonC_TokenerParse('{"name":"Alice","age":30,"friends":["Paula", "Cindy", "Dorothy"]}')
$tom = _JsonC_ObjectToJsonString($fred)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $tom = ' & $tom & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

$tmp = _JsonC_ObjectIsType($fred, $JSONC_TYPE_OBJECT)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $tmp = ' & $tmp & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

_JsonC_Shutdown()

Exit

#cs

struct json_object
{
	enum json_type o_type;
	uint32_t _ref_count;
	json_object_to_json_string_fn *_to_json_string;
	struct printbuf *_pb;
	json_object_delete_fn *_user_delete;
	void *_userdata;
	// Actually longer, always malloc'd as some more-specific type.
	// The rest of a struct json_object_${o_type} follows
};

#ce

Local $oMyError = ObjEvent("AutoIt.Error", "ErrFunc")

Local $json_str = '{"name":"Alice","age":30,"friends":["Paula", "Cindy", "Dorothy"]}'

;Global $gtag_json_object = _
;           "struct;"              		& _
;           "int   o_type;"        		& _
;           "uint  _ref_count;"    		& _
;           "ptr   _to_json_string;"  	& _
;           "ptr   _pb;"        			& _
;           "ptr   _user_delete;" 		& _
;           "ptr   _userdata;"      		& _
;           "endstruct;"

Global $gtag_json_object = _
           "struct;"              		& _
           "int   o_type;"        		& _
           "uint  _ref_count;"    		& _
           "ptr   _to_json_string;"  	& _
           "ptr   _pb;"        			& _
           "ptr   _user_delete;" 		& _
           "ptr   _userdata;"      		& _
           "endstruct;"

;Local $hDLL = DllOpen ( @ScriptDir & "\json-c.dll" )
;ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : @error = ' & @error & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

;Local $hWnd
;Local $aResult = DllCall(@ScriptDir & "\json-c.dll", "struct", "json_tokener_parse", "ptr", $json_str)

Local $json_error
;Local $aResult = DllCall(@ScriptDir & "\json-c2.dll", "struct", "json_tokener_parse", "str", $json_str)
Local $aResult = DllCall(@ScriptDir & "\json-c2.dll", "ptr", "json_tokener_parse", "str", $json_str)
;Local $aResult = DllCall(@ScriptDir & "\json-c2.dll", "ptr", "json_tokener_parse_verbose", "str", $json_str, "int*", $json_error)

;Local $aResult = DllCall(@ScriptDir & "\json-c3.dll", "struct", "json_tokener_parse", "ptr", $json_str)
;Local $aResult = DllCall(@ScriptDir & "\json-c.dll", "struct", "json_util_get_last_err")
;Local $aResult = DllCall(@ScriptDir & "\json-c2.dll", "struct", "json_util_get_last_err")
;Local $aResult = DllCall(@ScriptDir & "\json-c3.dll", "struct", "json_util_get_last_err")

ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : @error = ' & @error & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aResult = ' & $aResult & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console


Local $t_json_object=DllStructCreate($gtag_json_object,$aResult[0])
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : @error = ' & @error & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t_json_object = ' & $t_json_object & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

;ConsoleWrite(DLLStructAnalyze($t_json_object) & @LF)

local $o_type = DllStructGetData($t_json_object,"o_type")
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $o_type = ' & $o_type & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
local $_ref_count = DllStructGetData($t_json_object,"_ref_count")
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $_ref_count = ' & $_ref_count & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
local $_to_json_string = DllStructGetData($t_json_object,"_to_json_string")
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $_to_json_string = ' & $_to_json_string & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
local $_to_json_string_ptr = DllStructGetPtr($t_json_object,"_to_json_string")
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $_to_json_string_ptr = ' & $_to_json_string_ptr & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

Local $aResult3 = DllCall(@ScriptDir & "\json-c2.dll", "int", "json_object_is_type", "ptr", DllStructGetPtr($t_json_object), "int", 4)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : @error = ' & @error & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aResult3[0] = ' & $aResult3[0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console


$rr = _WinAPI_StringLenA($_to_json_string_ptr)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $rr = ' & $rr & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

Local $str = _PointerToStringW($_to_json_string_ptr)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $str = ' & $str & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : DllStructGetPtr($t_json_object) = ' & DllStructGetPtr($t_json_object) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

Local $aResult2 = DllCall(@ScriptDir & "\json-c2.dll", "str", "json_object_to_json_string", "ptr", DllStructGetPtr($t_json_object))
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : @error = ' & @error & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aResult2[0] = ' & $aResult2[0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

;Local $aResult2 = DllCall(@ScriptDir & "\json-c2.dll", "ptr", "json_object_object_get_ex", "str", $json_str)

Exit

$tJsonObject = DllStructCreate($gtag_json_object)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : @error = ' & @error & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console






Exit





#cs
    typedef struct {
        espeak_EVENT_TYPE type; //ENUM
        unsigned int unique_identifier; // message identifier (or 0 for key or character)
        int text_position;    // the number of characters from the start of the text
        int length;           // word length, in characters (for espeakEVENT_WORD)
        int audio_position;   // the time in mS within the generated speech output data
        int sample;           // sample id (internal use)
        void* user_data;      // pointer supplied by the calling program
        union {
            int number;        // used for WORD and SENTENCE events.
            const char *name;  // used for MARK and PLAY events.  UTF8 string
            char string[8];    // used for phoneme names (UTF8). Terminated by a zero byte unless the name needs the full 8 bytes.
        } id;
    } espeak_EVENT;
#ce

;ESPEAK EVENT BASE STRUCT
Global $gtag_ESPEAK_EVENT = _
           "struct;"              & _
           "int   type;"          & _
           "uint  uid;"           & _
           "int   textPosition;"  & _
           "int   length;"        & _
           "int   audioPosition;" & _
           "int   sample;"        & _
           "ptr   userData;"      & _
           "endstruct;"

;ESPEAK ID UNION STRUCTs
Global $gtag_ESPEAK_EVENT_UNION_ID_INT = _
           "struct;"              & _
           "int   id;"            & _
           "endstruct;"
Global $gtag_ESPEAK_EVENT_UNION_ID_PTR = _
           "struct;"              & _
           "ptr   id;"            & _
           "endstruct;"
Global $gtag_ESPEAK_EVENT_UNION_ID_CHAR = _
           "struct;"              & _
           "char   id[8];"        & _
           "endstruct;"

;ESPEAK EVENT STRUCTs with Unions
Global $gtag_ESPEAK_EVENT_WORD_SENTENCE = _
           $gtag_ESPEAK_EVENT         & _
           $gtag_ESPEAK_EVENT_UNION_ID_INT
Global $gtag_ESPEAK_EVENT_MARK_PLAY = _
           $gtag_ESPEAK_EVENT          & _
           $gtag_ESPEAK_EVENT_UNION_ID_PTR
Global $gtag_ESPEAK_EVENT_NAME = _
           $gtag_ESPEAK_EVENT         & _
           $gtag_ESPEAK_EVENT_UNION_ID_CHAR


example()

Func example()
    Local $tEspeakEvent

    $tEspeakEvent = DllStructCreate($gtag_ESPEAK_EVENT)
    If @error Then Exit MsgBox($MB_ICONERROR + $MB_TOPMOST, "ERROR", "Error creating $gtag_ESPEAK_EVENT - @error = " & @error)
    _WinAPI_DisplayStruct($tEspeakEvent,$gtag_ESPEAK_EVENT, "ESPEAK_EVENT_" & (@AutoItX64 ? " 64bit" : " 32bit"))

    $tEspeakEvent = DllStructCreate($gtag_ESPEAK_EVENT_WORD_SENTENCE)
    If @error Then Exit MsgBox($MB_ICONERROR + $MB_TOPMOST, "ERROR", "Error creating $gtag_ESPEAK_EVENT_WORD_SENTENCE - @error = " & @error)
    _WinAPI_DisplayStruct($tEspeakEvent,$gtag_ESPEAK_EVENT_WORD_SENTENCE, "ESPEAK_EVENT_WORD_SENTENCE" & (@AutoItX64 ? " 64bit" : " 32bit"))

    $tEspeakEvent = DllStructCreate($gtag_ESPEAK_EVENT_MARK_PLAY)
    If @error Then Exit MsgBox($MB_ICONERROR + $MB_TOPMOST, "ERROR", "Error creating $gtag_ESPEAK_EVENT_MARK_PLAY - @error = " & @error)
    _WinAPI_DisplayStruct($tEspeakEvent,$gtag_ESPEAK_EVENT_MARK_PLAY, "ESPEAK_EVENT_MARK_PLAY" & (@AutoItX64 ? " 64bit" : " 32bit"))

    $tEspeakEvent = DllStructCreate($gtag_ESPEAK_EVENT_NAME)
    If @error Then Exit MsgBox($MB_ICONERROR + $MB_TOPMOST, "ERROR", "Error creating $gtag_ESPEAK_EVENT_NAME - @error = " & @error)
    _WinAPI_DisplayStruct($tEspeakEvent,$gtag_ESPEAK_EVENT_NAME, "ESPEAK_EVENT_NAME" & (@AutoItX64 ? " 64bit" : " 32bit"))
EndFunc

; This is a custom error handler
Func ErrFunc($oError)
    ConsoleWrite(@CRLF & @CRLF & "We intercepted a COM Error ! " & _
                 " Number: 0x " & Hex($oError.number, 8) & @CRLF & _
                 "Description: " & $oError.windescription & _
                 "At line: " & $oError.scriptline & @CRLF & @CRLF)
EndFunc   ;==>ErrFunc

Func _PointerToStringW($ptr)
    Return DllStructGetData(DllStructCreate("wchar[" & _WinAPI_StringLenW($ptr) & "]", $ptr), 1)
EndFunc







Func DLLStructAnalyze(ByRef $DLLStruct)
    Local $Dict = __DLLStructAnalyzeHook(True)
    $Dict.Add($DLLStruct)
    __DLLStructAnalyzeHook(False)
    Return __DLLStructAnalyzeCallback(0)
EndFunc

Func __DLLStructAnalyzeCallback($Ptr)
    Static $Array[0], $Echo = ConsoleWrite

    If $Ptr = 0 Then
        Local $Ret = ''
        For $i = 0 To UBound($Array) - 1
            Local $Item = $Array[$i]
            $Ret &= ($i ? ";" : "") & $Item[0]
        Next
        Return $Ret
    EndIf

    ReDim $Array[0]
    Local $Buffer = DllStructCreate("ptr", $Ptr)
    $Ptr = DllStructGetData($Buffer, 1)

    Local $Variant = DllStructCreate("word vt;word[3];ptr data;ptr record", $Ptr)
    Local $Type = DllStructGetData($Variant, "vt")
    If $Type = 36 Then
        Local $Record = DllStructGetData($Variant, "record")
        Local $RecordType = DllStructCreate("ptr;uint;uint type;ptr struct", $Record)

        If DllStructGetData($RecordType, "type") = 12 Then
            Local $Struct = DllStructCreate("uint count;ptr define;ptr base;uint size", DllStructGetData($RecordType, "struct"))
            Local $Count = DllStructGetData($Struct, "count")

            Local $Align = 8, $LastEnd = 0, $DefineSize = 0
            For $i = 0 To $Count - 1
                Local $Define = DllStructCreate("uint start;uint size;uint flag;ptr name;ptr;ptr;ptr;uint end", DllStructGetData($Struct, "define") + $i * $DefineSize)
                Local $DefineSize = DllStructGetSize($Define)

                Local $Start = DllStructGetData($Define, "start")
                Local $Size = DllStructGetData($Define, "size")
                Local $Flag = DllStructGetData($Define, "flag")
                Local $End = DllStructGetData($Define, "end")

                Local $Name = DllStructGetData($Define, "name")
                Local $Ret = DllCall("kernel32.dll", "int", "lstrlenW", "ptr", $Name)
                $Name = $Ret[0] ? " " & DllStructGetData(DllStructCreate("wchar[" & $Ret[0] & "]", $Name), 1) : ""

                $Echo("start: " & $Start & @TAB)
                $Echo("size: " & $Size & @TAB)
                $Echo("end: " & $End & @TAB)

                Local $NextAlign = 0
                If $i > 0 Then
                    $Pad = $Start - $LastEnd
                    If Not ((Mod($Start, $Align) = 0 Or Mod($Start, $Size) = 0) And $Pad < $Align) Then
                        $NextAlign = 1
                        $Echo("(pad" & $Pad & ") align 1")

                        If Mod($Start, 2) = 0 And $Pad < 2 Then
                            $Echo(" 2")
                            $NextAlign = 2
                        EndIf
                        If Mod($Start, 4) = 0 And $Pad < 4 Then
                            $Echo(" 4")
                            $NextAlign = 4
                        EndIf
                        If Mod($Start, 8) = 0 And $Pad < 8 Then
                            $Echo(" 8")
                            $NextAlign = 8
                        EndIf
                        $Echo("; ")

                        If $NextAlign <> $Align Then
                            $Align = $NextAlign
                            Local $ItemAlign[] = ["align " & $Align, 0]
                            ArrayAdd($Array, $ItemAlign)
                        EndIf

                    ElseIf $Pad <> 0 And $Pad >= $Size Then
                        $Echo("(pad" & $Pad & ") endstruct; ")

                        Local $ItemStruct[] = ["struct", 0]
                        For $j = UBound($Array) - 1 To 0 Step -1
                            Local $Item = $Array[$j]
                            If $Item[1] > $Pad Then
                                ArrayInsert($Array, $j, $ItemStruct)
                                ExitLoop
                            EndIf
                        Next

                        Local $ItemEndStruct[] = ["endstruct", 0]
                        ArrayAdd($Array, $ItemEndStruct)
                    EndIf
                EndIf
                $LastEnd = $End

                Local $Type = "unknow" & $Name
                Select
                    Case $Size = 1 And $Flag = 18
                        $Type = "byte" & $Name
                    Case $Size = 1 And $Flag = 1
                        $Type = "char" & $Name
                    Case $Size = 2 And $Flag = 32
                        $Type = "wchar" & $Name
                    Case $Size = 2 And $Flag = 0
                        $Type = "short" & $Name
                    Case $Size = 2 And $Flag = 2
                        $Type = "ushort" & $Name
                    Case $Size = 4 And $Flag = 0
                        $Type = "int" & $Name
                    Case $Size = 4 And $Flag = 2
                        $Type = "uint" & $Name
                    Case $Size = 8 And $Flag = 0
                        $Type = "int64" & $Name
                    Case $Size = 8 And $Flag = 2
                        $Type = "uint64" & $Name
                    Case $Size = 4 And $Flag = 64 And Not @AutoItX64
                        $Type = "ptr" & $Name
                    Case $Size = 8 And $Flag = 64 And @AutoItX64
                        $Type = "ptr" & $Name
                    Case $Size = 4 And $Flag = 8
                        $Type = "float" & $Name
                    Case $Size = 8 And $Flag = 8
                        $Type = "double" & $Name
                    Case $Size = 1 And $Flag = 22
                        $Type = "byte" & $Name
                        If $End - $Start = $Size Then $Type &= "[1]"
                    Case $Size = 1 And $Flag = 5
                        $Type = "char" & $Name
                        If $End - $Start = $Size Then $Type &= "[1]"
                    Case $Size = 2 And $Flag = 36
                        $Type = "wchar" & $Name
                        If $End - $Start = $Size Then $Type &= "[1]"
                EndSelect

                If $End - $Start <> $Size Then $Type &= "[" & Int(($End - $Start) / $Size) & "]"
                $Echo($Type & @LF)
                Local $Item[] = [$Type, $Size]
                ArrayAdd($Array, $Item)
            Next
        EndIf
    EndIf
EndFunc

Func __DLLStructAnalyzeHook($IsHook)
    Static $Callback, $CallbackPtr, $VTable, $InvokePtr, $CodeBuffer, $Hook = 0
    Local $Dict = ObjCreate("Scripting.Dictionary")

    If Not $Hook Then
        $Callback = DllCallbackRegister(__DLLStructAnalyzeCallback, "none", "ptr")
        $CallbackPtr = DllCallbackGetPtr($Callback)

        Local $VTablePtr = DllStructCreate("ptr", Ptr($Dict))
        $VTablePtr = DllStructGetData($VTablePtr, 1)

        $VTable = DllStructCreate("ptr[7]", $VTablePtr)
        $InvokePtr = DllStructGetData($VTable, 1, 7)

        Local $Code, $CallPtr, $JmpPtr
        If @AutoItX64 Then
            $Code = '0x41554154555756534883EC38488BB424980000008B9C24900000004889CF8954242C4C8944242044894C2428488BAC24A00000004889F14C8BA424A80000004C8BAC24B000000048B8FFFFFFFFFFFFFFFFFFD0448B4C24284C8B4424200FB7DB8B54242C4889F94C89AC24B00000004C89A424A80000004889AC24A00000004889B42498000000899C24900000004883C4385B5E5F5D415C415D48B8FFFFFFFFFFFFFFFFFFE0'
            $CallPtr = (StringInStr($Code, '48B8FFFFFFFFFFFFFFFFFFD0', 2) + 1) / 2
            $JmpPtr = (StringInStr($Code, '48B8FFFFFFFFFFFFFFFFFFE0', 2) + 1) / 2
        Else
            $Code = '0x5589E557565383EC3C8B45088B5D1C8B55248B4D288B75108B7D148945E48B450C891C248955D4894DD88945E08B45188945DC8B45208945D0B8FFFFFFFFFFD0508B45D08B4DD88B55D4895D1C897D148945200FB745DC897510894D288955248945188B45E089450C8B45E48945088D65F45B5E5F5DB8FFFFFFFFFFE0'
            $CallPtr = (StringInStr($Code, 'B8FFFFFFFFFFD0', 2) - 1) / 2
            $JmpPtr = (StringInStr($Code, 'B8FFFFFFFFFFE0', 2) - 1) / 2
        EndIf

        $Code = Binary($Code)
        $CodeBuffer = DllStructCreate("byte[" & BinaryLen($Code) & "]")
        $Hook = DllStructGetPtr($CodeBuffer)
        DllStructSetData($CodeBuffer, 1, $Code)
        DllCall("kernel32.dll", "bool", "VirtualProtect", "ptr", $Hook, "dword_ptr", BinaryLen($Code), "dword", 64, "dword*", 0)

        DllStructSetData(DllStructCreate("ptr", $Hook + $CallPtr), 1, $CallbackPtr)
        DllStructSetData(DllStructCreate("ptr", $Hook + $JmpPtr), 1, $InvokePtr)
        DllCall("kernel32.dll", "bool", "VirtualProtect", "ptr", $VTablePtr, "dword_ptr", @AutoItX64 ? 56 : 28, "dword", 4, "dword*", 0)
    EndIf

    If $IsHook Then
        DllStructSetData($VTable, 1, $Hook, 7)
        Return $Dict
    Else
        DllStructSetData($VTable, 1, $InvokePtr, 7)
    EndIf
EndFunc

Func ArrayAdd(ByRef $avArray, $vValue)
    If Not IsArray($avArray) Then Return SetError(1, 0, -1)
    If UBound($avArray, 0) <> 1 Then Return SetError(2, 0, -1)

    Local $iUBound = UBound($avArray)
    ReDim $avArray[$iUBound + 1]
    $avArray[$iUBound] = $vValue
    Return $iUBound
EndFunc

Func ArrayInsert(ByRef $avArray, $iElement, $vValue = "")
    If Not IsArray($avArray) Then Return SetError(1, 0, 0)
    If UBound($avArray, 0) <> 1 Then Return SetError(2, 0, 0)

    ; Check element in array bounds + 1
    If $iElement > UBound($avArray) Then Return SetError(3, 0, 0)

    ; Add 1 to the array
    Local $iUBound = UBound($avArray) + 1
    ReDim $avArray[$iUBound]

    ; Move all entries over til the specified element
    For $i = $iUBound - 1 To $iElement + 1 Step -1
        $avArray[$i] = $avArray[$i - 1]
    Next

    ; Add the value in the specified element
    $avArray[$iElement] = $vValue
    Return $iUBound
EndFunc