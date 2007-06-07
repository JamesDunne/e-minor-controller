Attribute VB_Name = "Useless"
Public Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Public Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
Public Declare Function GetTickCount Lib "kernel32" () As Long

    
    Option Explicit
    
    Private Const OFFSET_4 = 4294967296#
    Private Const MAXINT_4 = 2147483647
    Private Const OFFSET_2 = 65536
    Private Const MAXINT_2 = 32767
    
    Public DelayOver As Boolean


Public Function GetSetting(INISection As String, INIKey As String) As String
    Dim MyString As String
    Dim RetStat As Integer
    Dim i As Integer
    
    MyString = ""
    For i = 1 To 255
        MyString = MyString & " "
    Next i
    RetStat = GetPrivateProfileString(INISection, INIKey, "", MyString, 255, VB.App.Path & "\" & VB.App.EXEName & ".INI") '   "\P1618QP.INI")
    GetSetting = Mid(MyString, 1, InStr(1, MyString, Chr(0), vbBinaryCompare) - 1)
End Function


Public Function SetSetting(MySetting As String, INISection As String, INIKey As String) As Long
    SetSetting = WritePrivateProfileString(INISection, INIKey, MySetting, VB.App.Path & "\" & VB.App.EXEName & ".INI") ' "\P1618QP.INI")
End Function


Public Function GetUsageName(UsagePage As Integer, Usage As Integer) As String
    Dim UsageNamesFile As String
    Dim i As Integer
    
    UsageNamesFile = GetSetting("SUITESETTINGS", "UsageNames")
    
    'FileSystemObject must reference Microsoft Scripting Engine:
    Dim fs As New FileSystemObject
    Dim InFile As Object
    Dim FileLine As String
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set InFile = fs.OpenTextFile(VB.App.Path & "\" & UsageNamesFile, 1, False, 0)
    
    GetUsageName = ""
    Do While InFile.AtEndOfStream <> True
        FileLine = InFile.ReadLine
        
        i = InStr(1, FileLine, Right(frmMain.D2H(UsagePage), 4) & ":" & Right(frmMain.D2H(Usage), 4))
        If i <> 0 Then
            i = InStr(1, FileLine, vbTab)
            GetUsageName = Right(FileLine, Len(FileLine) - i)
        End If
    Loop
    
End Function


Public Sub WaitMIN_DELAY()
    DelayOver = False
    
    If frmMain.MinDelayBetweenCmds = 0 Then
        Exit Sub
    End If
    
    frmMain.DelayTimer.Interval = frmMain.MinDelayBetweenCmds
    frmMain.DelayTimer.Enabled = True
    Do
        If DelayOver = True Then
            frmMain.DelayTimer.Enabled = False
            Exit Sub
        End If
        DoEvents
    Loop
    
End Sub

Function Dec2Hex(MyInteger As Variant, MyWidth As Variant) As String
    Dim TempWork As String
    Dim TempWidth As Long
    Dim TempInt As Long
    
    TempWidth = CLng(MyWidth)
    TempInt = CLng(MyInteger)
    
    TempWork = Hex(TempInt)
    
    If Len(TempWork) > TempWidth Then
        Dec2Hex = Mid(TempWork, Len(TempWork) - TempWidth, TempWidth)
        Exit Function
    End If
    
    Do Until Len(TempWork) = TempWidth
        TempWork = "0" & TempWork
    Loop
    
    Dec2Hex = TempWork
End Function
    
    
    
    Function UnsignedToLong(ByVal Value As Double) As Long
      If Value < 0 Or Value >= OFFSET_4 Then Error 6 ' Overflow
      If Value <= MAXINT_4 Then
        UnsignedToLong = Value
      Else
        UnsignedToLong = Value - OFFSET_4
      End If
    End Function
    
    Function LongToUnsigned(ByVal Value As Long) As Double
      If Value < 0 Then
        LongToUnsigned = Value + OFFSET_4
      Else
        LongToUnsigned = Value
      End If
    End Function
    
    Function UnsignedToInteger(ByVal Value As Long) As Integer
      If Value < 0 Or Value >= OFFSET_2 Then Error 6 ' Overflow
      If Value <= MAXINT_2 Then
        UnsignedToInteger = Value
      Else
        UnsignedToInteger = Value - OFFSET_2
      End If
    End Function
    
    Function IntegerToUnsigned(ByVal Value As Integer) As Long
      If Value < 0 Then
        IntegerToUnsigned = Value + OFFSET_2
      Else
        IntegerToUnsigned = Value
      End If
    End Function
              
Public Function GetErrorString _
    (ByVal LastError As Long) _
    As String

    'Returns the error message for the last error.
    'Adapted from Dan Appleman's "Win32 API Puzzle Book"
    
    Dim Bytes As Long
    Dim ErrorString As String
    ErrorString = String$(129, 0)
    Bytes = FormatMessage _
        (FORMAT_MESSAGE_FROM_SYSTEM, _
        0&, _
        LastError, _
        0, _
        ErrorString$, _
        128, _
        0)
        
    'Subtract two characters from the message to strip the CR and LF.
    
    If Bytes > 2 Then
        GetErrorString = Left$(ErrorString, Bytes - 2)
    End If
End Function


Public Sub DisplayResultOfAPICall(FunctionName As String)

'Display the results of an API call.

Dim ErrorString As String

frmMain.LogResults ""
ErrorString = GetErrorString(Err.LastDllError)
frmMain.LogResults FunctionName
frmMain.LogResults "  Result = " & ErrorString

'Scroll to the bottom of the list box.

frmMain.lstResults.ListIndex = frmMain.lstResults.ListCount - 1

End Sub


'Scroll to the bottom of the list box.
Public Sub ScrollDown()
    Dim Count As Integer
    
    frmMain.lstResults.ListIndex = frmMain.lstResults.ListCount - 1
    
    'If the list box has more than 300 items, trim the contents.
    
    If frmMain.lstResults.ListCount > 300 Then
        For Count = 1 To 100
            frmMain.lstResults.RemoveItem (Count)
        Next Count
    End If
End Sub

Public Sub ScrollUPSStatsDown()
    Dim Count As Integer
    
    frmMain.UPSStatusListBox.ListIndex = frmMain.UPSStatusListBox.ListCount - 1
    
    'If the list box has more than 300 items, trim the contents.
    
    If frmMain.UPSStatusListBox.ListCount > 300 Then
        For Count = 1 To 100
            frmMain.UPSStatusListBox.RemoveItem (Count)
        Next Count
    End If
End Sub
'
'Function Dec2Hex(ByVal DecimalIn As Variant) As String
'    Dim X As Integer
'    Dim BinaryString As String
'    Const BinValues = "*0000*0001*0010*0011" & _
'    "*0100*0101*0110*0111" & _
'    "*1000*1001*1010*1011" & _
'    "*1100*1101*1110*1111*"
'    Const HexValues = "0123456789ABCDEF"
'    Const MaxNumOfBits As Long = 96
'    BinaryString = ""
'    DecimalIn = Int(CDec(DecimalIn))
'    Do While DecimalIn <> 0
'    BinaryString = Trim$(Str$(DecimalIn - 2 * _
'    Int(DecimalIn / 2))) & BinaryString
'    DecimalIn = Int(DecimalIn / 2)
'    Loop
'    BinaryString = String$((4 - Len(BinaryString) _
'    Mod 4) Mod 4, "0") & BinaryString
'    For X = 1 To Len(BinaryString) - 3 Step 4
'    Dec2Hex = Dec2Hex & Mid$(HexValues, _
'    (4 + InStr(BinValues, "*" & _
'    Mid$(BinaryString, X, 4) & "*")) \ 5, 1)
'    Next
'End Function
'
'Function Hex2Dec(ByVal HexString As String) As Variant
'    Dim X As Integer
'    Dim BinStr As String
'    Const TwoToThe49thPower As String = "562949953421312"
'    If Left$(HexString, 2) Like "&[hH]" Then
'    HexString = Mid$(HexString, 3)
'    End If
'    If Len(HexString) <= 23 Then
'    Const BinValues = "0000000100100011" & _
'    "0100010101100111" & _
'    "1000100110101011" & _
'    "1100110111101111"
'    For X = 1 To Len(HexString)
'    BinStr = BinStr & Mid$(BinValues, _
'    4 * Val("&h" & Mid$(HexString, X, 1)) + 1, 4)
'    Next
'    Hex2Dec = CDec(0)
'    For X = 0 To Len(BinStr) - 1
'    If X < 50 Then
'    Hex2Dec = Hex2Dec + Val(Mid(BinStr, _
'    Len(BinStr) - X, 1)) * 2 ^ X
'    Else
'    Hex2Dec = Hex2Dec + CDec(TwoToThe49thPower) * _
'    Val(Mid(BinStr, Len(BinStr) - X, 1)) * 2 ^ (X - 49)
'    End If
'    Next
'    Else
'    ' Number is too big, handle error here
'    End If
'End Function
