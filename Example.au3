#AutoIt3Wrapper_UseX64=y
#include "JsonC.au3"

_JsonC_Startup("json-c.dll")

$Json = _JsonC_TokenerParse('{"name":"Alice","age":30,"friends":["Paula", "Cindy", "Dorothy"]}')
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

