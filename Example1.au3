#AutoIt3Wrapper_UseX64=y
#include "JsonC.au3"

_JsonC_Startup("json-c.dll")

$jobj = _JsonC_ObjectNewObject()
_JsonC_ObjectObjectAdd($jobj, "name", _JsonC_ObjectNewString("Alice"))
_JsonC_ObjectObjectAdd($jobj, "age", _JsonC_ObjectNewInt(30))
_JsonC_ObjectObjectAdd($jobj, "height", _JsonC_ObjectNewDouble(175.8))
_JsonC_ObjectObjectAdd($jobj, "isEmployed", _JsonC_ObjectNewBoolean(True))
$jarr = _JsonC_ObjectNewArray()
_JsonC_ObjectArrayAdd($jarr, _JsonC_ObjectNewString("Paula"))
_JsonC_ObjectArrayAdd($jarr, _JsonC_ObjectNewString("Cindy"))
_JsonC_ObjectArrayAdd($jarr, _JsonC_ObjectNewString("Dorothy"))
_JsonC_ObjectObjectAdd($jobj, "friends", $jarr)
$str = _JsonC_ObjectToJsonString($jobj)
ConsoleWrite("String: " & $str & @CRLF)

$jobj = _JsonC_TokenerParse($str)
ConsoleWrite("JSON type: " & _JsonC_TypeToName(_JsonC_ObjectGetType($jobj)) & ", string: " & _JsonC_ObjectToJsonString($jobj) & @CRLF)

$name = _JsonC_ObjectObjectGet($jobj, "name")
ConsoleWrite("Name type: " & _JsonC_TypeToName(_JsonC_ObjectGetType($name)) & ", value (using GetString): " & _JsonC_ObjectGetString($name) & ", value (using GetValue): " & _JsonC_ObjectGetValue($name) & @CRLF)

$age = _JsonC_ObjectObjectGet($jobj, "age")
ConsoleWrite("Age type: " & _JsonC_TypeToName(_JsonC_ObjectGetType($age)) & ", value (using GetInt): " & _JsonC_ObjectGetInt($age) & ", value (using GetValue): " & _JsonC_ObjectGetValue($age) & @CRLF)

$height = _JsonC_ObjectObjectGet($jobj, "height")
ConsoleWrite("Height type: " & _JsonC_TypeToName(_JsonC_ObjectGetType($height)) & ", value (using GetDouble): " & _JsonC_ObjectGetDouble($height) & ", value (using GetValue): " & _JsonC_ObjectGetValue($height) & @CRLF)

$is_employed = _JsonC_ObjectObjectGet($jobj, "isEmployed")
ConsoleWrite("IsEmployed type: " & _JsonC_TypeToName(_JsonC_ObjectGetType($is_employed)) & ", value (using GetBoolean): " & _JsonC_ObjectGetBoolean($is_employed) & ", value (using GetValue): " & _JsonC_ObjectGetValue($is_employed) & @CRLF)

$friends = _JsonC_ObjectObjectGet($jobj, "friends")
$friends_array_list = _JsonC_ObjectGetArray($friends)
ConsoleWrite("Number of friends (from array list): " & _JsonC_ArrayListLength($friends_array_list) & ", 2nd friend (from array list): " & _JsonC_ObjectGetValue(_JsonC_ArrayListGetIndex($friends_array_list, 1)) & @CRLF)


ConsoleWrite("Number of friends (from array object): " & _JsonC_ObjectArrayLength($friends) & ", 2nd friend (from array object): " & _JsonC_ObjectGetValue(_JsonC_ObjectArrayGetIndex($friends, 1)) & @CRLF)

$friends_array = _JsonC_ObjectArrayGetObjects($friends)
For $friend in $friends_array
	ConsoleWrite("Friend type: " & _JsonC_TypeToName(_JsonC_ObjectGetType($friend)) & ", value: " & _JsonC_ObjectGetValue($friend) & @CRLF)
Next

ConsoleWrite("Is age a type of string: " & _JsonC_ObjectIsType($age, $JSONC_TYPE_STRING) & @CRLF)
ConsoleWrite("Is age a type of int: " & _JsonC_ObjectIsType($age, $JSONC_TYPE_INT) & @CRLF)

_JsonC_ObjectObjectDel($jobj, "age")
ConsoleWrite("JSON string without age: " & _JsonC_ObjectToJsonString($jobj) & @CRLF)

_JsonC_Shutdown()

