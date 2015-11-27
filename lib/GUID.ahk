; Format
; 1. Curly brackets and dashes		{ff4d3390-3649-4fe4-8b7d-f1a2785c4356}
; 2. No Curly brackets				a123cf05-b8d3-436f-9d40-57f6362f2b0d
; 3. Only alpha-numeric characters	dee2675f35434c4c8a4ee95b00601d86

GUID(format = 1)
{
	TypeLib := ComObjCreate("Scriptlet.TypeLib")
	newGuid := TypeLib.Guid
	StringLower, newGuid, newGuid

	;; Normal GUID
	if (format = 1)
	{
		newGuid := RegExReplace(newGuid, "[\{](?=[\w])", "{{}")
		newGuid := RegExReplace(newGuid, "(?<=[\w])[\}]", "{}}")
	}
	if (format = 2)
		newGuid := RegExReplace(newGuid, "[\{\}]", "")
	if (format = 3)
		newGuid := RegExReplace(newGuid, "[\{\}-]", "")

	return newGuid
}
