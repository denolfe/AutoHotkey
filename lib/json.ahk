UnJson(string)
{
    return % RegExReplace(string, "\\/", "/")
}

json(ByRef js, s, v = "") {
    j = %js%
    Loop, Parse, s, .
    {
        p = 2
        RegExMatch(A_LoopField, "([+\-]?)([^[]+)((?:\[\d+\])*)", q)
        Loop {
            If (!p := RegExMatch(j, "(?<!\\)(""|')([^\1]+?)(?<!\\)(?-1)\s*:\s*((\{(?:[^{}]++|(?-1))*\})|(\[(?:[^[\]]++|(?-1))*\])|"
                . "(?<!\\)(""|')[^\7]*?(?<!\\)(?-1)|[+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:,|$|\})", x, p))
                Return
            Else If (x2 == q2 or q2 == "*") {
                j = %x3%
                z += p + StrLen(x2) - 2
                If (q3 != "" and InStr(j, "[") == 1) {
                    StringTrimRight, q3, q3, 1
                    Loop, Parse, q3, ], [
                    {
                        z += 1 + RegExMatch(SubStr(j, 2, -1), "^(?:\s*((\[(?:[^[\]]++|(?-1))*\])|(\{(?:[^{\}]++|(?-1))*\})|[^,]*?)\s*(?:,|$)){" . SubStr(A_LoopField, 1) + 1 . "}", x)
                        j = %x1%
                    }
                }
                Break
            }
            Else p += StrLen(x)
        }
    }
    If v !=
    {
        vs = "
        If (RegExMatch(v, "^\s*(?:""|')*\s*([+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:""|')*\s*$", vx)
            and (vx1 + 0 or vx1 == 0 or vx1 == "true" or vx1 == "false" or vx1 == "null" or vx1 == "nul"))
            vs := "", v := vx1
        StringReplace, v, v, ", \", All
        js := SubStr(js, 1, z := RegExMatch(js, ":\s*", zx, z) + StrLen(zx) - 1) . vs . v . vs . SubStr(js, z + StrLen(x3) + 1)
    }
    Return, j == "false" ? 0 : j == "true" ? 1 : j == "null" or j == "nul"
        ? "" : SubStr(j, 1, 1) == """" ? SubStr(j, 2, -1) : j
}

/*
    Function: DateParse
        Converts almost any date format to a YYYYMMDDHH24MISS value.

    Parameters:
        str - a date/time stamp as a string

    Returns:
        A valid YYYYMMDDHH24MISS value which can be used by FormatTime, EnvAdd and other time commands.

    Example:
> time := DateParse("2:35 PM, 27 November, 2007")

    License:
        - Version 1.05 <http://www.autohotkey.net/~polyethene/#dateparse>
        - Dedicated to the public domain (CC0 1.0) <http://creativecommons.org/publicdomain/zero/1.0/>
*/
DateParse(str) {
    static e2 = "i)(?:(\d{1,2}+)[\s\.\-\/,]+)?(\d{1,2}|(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\w*)[\s\.\-\/,]+(\d{2,4})"
    str := RegExReplace(str, "((?:" . SubStr(e2, 42, 47) . ")\w*)(\s*)(\d{1,2})\b", "$3$2$1", "", 1)
    If RegExMatch(str, "i)^\s*(?:(\d{4})([\s\-:\/])(\d{1,2})\2(\d{1,2}))?"
        . "(?:\s*[T\s](\d{1,2})([\s\-:\/])(\d{1,2})(?:\6(\d{1,2})\s*(?:(Z)|(\+|\-)?"
        . "(\d{1,2})\6(\d{1,2})(?:\6(\d{1,2}))?)?)?)?\s*$", i)
        d3 := i1, d2 := i3, d1 := i4, t1 := i5, t2 := i7, t3 := i8
    Else If !RegExMatch(str, "^\W*(\d{1,2}+)(\d{2})\W*$", t)
        RegExMatch(str, "i)(\d{1,2})\s*:\s*(\d{1,2})(?:\s*(\d{1,2}))?(?:\s*([ap]m))?", t)
            , RegExMatch(str, e2, d)
    f = %A_FormatFloat%
    SetFormat, Float, 02.0
    d := (d3 ? (StrLen(d3) = 2 ? 20 : "") . d3 : A_YYYY)
        . ((d2 := d2 + 0 ? d2 : (InStr(e2, SubStr(d2, 1, 3)) - 40) // 4 + 1.0) > 0
            ? d2 + 0.0 : A_MM) . ((d1 += 0.0) ? d1 : A_DD) . t1
            + (t1 = 12 ? t4 = "am" ? -12.0 : 0.0 : t4 = "am" ? 0.0 : 12.0) . t2 + 0.0 . t3 + 0.0
    SetFormat, Float, %f%
    Return, d
}