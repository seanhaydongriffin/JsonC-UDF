#AutoIt3Wrapper_UseX64=y
#include "JsonCEx.au3"

_AutoItObject_Startup()
_JsonC_Startup("json-c.dll")

$jObject = JsonC_Object().add("demographic", "young adults")

$jArrOfValues = _JsonC_Array().add("Paula").add("Cindy").add("Dorothy")

$jArrOfObjects = _JsonC_Array()
$jArrOfObjects.add(JsonC_Object().add("name", "Alice").add("age", 20).add("height", 175.8).add("isEmployed", True))
$jArrOfObjects.add(JsonC_Object().add("name", "Roger").add("age", 22).add("height", 165.3).add("isEmployed", False))

$jAllObjects = JsonC_Object().add("general", $jObject).add("person", $jArrOfValues).add("personDetails", $jArrOfObjects)

$jstr = $jAllObjects.toString()

ConsoleWrite(@CRLF & "JSON data to string: " & @CRLF & "  > " & $jstr & @CRLF)

ConsoleWrite(@CRLF & "Iterate over the JSON array as a standalone object: " & @CRLF)

For $oObject In $jArrOfObjects
    ConsoleWrite("  > name: value = " & $oObject.name.value() & ", type = " & $oObject.name.type() & ", age: value = " & $oObject.age.value() & ", type = " & $oObject.age.type() & ", height: value = " & $oObject.height.value() & ", type = " & $oObject.height.type() & ", isEmployed: value = " & $oObject.isEmployed.value() & ", type = " & $oObject.name.type() & @CRLF)
Next

ConsoleWrite(@CRLF & "Iterate over the JSON array as a object from the complete JSON: " & @CRLF)

For $oObject In $jAllObjects.personDetails
    ConsoleWrite("  > person name = " & $oObject.name.value() & @CRLF)
Next

ConsoleWrite(@CRLF & "Extract the value of a child object: " & @CRLF)

$oGeneralDemographic = $jAllObjects.general.demographic.value()
ConsoleWrite("  > general.demographic.value() = " & $oGeneralDemographic & @CRLF)

ConsoleWrite(@CRLF & "Extract the value of a item from an array: " & @CRLF)

$oFirstPersonsName = $jAllObjects.personDetails.at(0).name.value()
ConsoleWrite("  > personDetails.at(0).name.value() = " & $oFirstPersonsName & @CRLF)

_JsonC_Shutdown()
