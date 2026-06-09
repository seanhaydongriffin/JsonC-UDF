#AutoIt3Wrapper_UseX64=y
#include "JsonCEx.au3"

_AutoItObject_Startup()
_JsonC_Startup()
$sVersion = _JsonC_Version()
ConsoleWrite("json-c version: " & $sVersion & @CRLF)

; starting with JSON string
$jStr = '{ "general": { "demographic": "young adults" }, "person": [ "Paula", "Cindy", "Dorothy" ], "personDetails": [ { "name": "Alice", "age": 20, "height": 175.80000000000001, "isEmployed": true }, { "name": "Roger", "age": 22, "height": 165.30000000000001, "isEmployed": false } ] }'
$jAllObjects = _JsonC_Object($jStr)

$jstr = $jAllObjects.toString()
ConsoleWrite(@CRLF & "JSON data to string: " & @CRLF & "  > " & $jstr & @CRLF)

ConsoleWrite(@CRLF & "Iterating over the JSON array: " & @CRLF)
$personalDetails = $jAllObjects.get("personDetails")
For $i = 0 to $personalDetails.count() - 1
    $eachObj = $personalDetails.at($i)
    ConsoleWrite("  > name: value = " & $eachObj.get("name").value() & ", type = " & $eachObj.get("name").type() & ", age: value = " & $eachObj.get("age").value() & ", type = " & $eachObj.get("age").type() & ", height: value = " & $eachObj.get("height").value() & ", type = " & $eachObj.get("height").type() & ", isEmployed: value = " & $eachObj.get("isEmployed").value() & ", type = " & $eachObj.get("isEmployed").type() & @CRLF)
Next

ConsoleWrite(@CRLF & "Extracting the value of a child object: " & @CRLF)
$oGeneralDemographic = $jAllObjects.get("general").get("demographic").value()
ConsoleWrite("  > general.demographic.value() = " & $oGeneralDemographic & @CRLF)

ConsoleWrite(@CRLF & "Extracting the value of a item from an array: " & @CRLF)
$oFirstPersonsName = $jAllObjects.get("personDetails").at(0).get("name").value()
ConsoleWrite("  > personDetails.at(0).name.value() = " & $oFirstPersonsName & @CRLF)

_JsonC_Shutdown()
