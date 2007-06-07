Attribute VB_Name = "ScriptMod"
Option Explicit

Public Sub RunScript(FileName As String, FuncToRun As String)
    'FileSystemObject must reference Microsoft Scripting Engine:
    Dim InFile As Object
    Dim fs As New FileSystemObject
    Dim FileLine As String
    Dim sc As New ScriptControl

    frmMain.AbortScript = False
    If FileName = "" Then
        Exit Sub
    End If
    
    Set InFile = fs.OpenTextFile(FileName, 1, False, 0)
    
    sc.Language = "vbscript"
    'Add the Form1 object so we can call any function defined in this form
    sc.AddObject "frmMain", frmMain, True
    sc.AddObject "QueryForm", QueryForm, True

'    Dim FuncNames(255) As String
'    GetFuncNames SCPFileName, FuncNames      'returns function names to FuncNames()
    
    Dim ScriptCode As String
    Dim i As Integer
    ScriptCode = ""
    'find all function names:
    Do While InFile.AtEndOfStream <> True
        If ScriptCode <> "" Then GoTo DONESCRIPT

        FileLine = InFile.ReadLine
        If Mid(FileLine, 1, 12 + Len(FuncToRun)) = "BEGINSCRIPT " & FuncToRun Then
            'we found the script:
            Do While InFile.AtEndOfStream <> True
                FileLine = InFile.ReadLine
                If InFile.AtEndOfStream = True Or Mid(FileLine, 1, 9) = "ENDSCRIPT" Then
                    Exit Do
                End If
                If FileLine <> "" Then
                    ScriptCode = ScriptCode + vbCr + FileLine
                End If
            Loop
        End If
    Loop
DONESCRIPT:

    If ScriptCode = "" Then
        frmMain.LogResults "script:" & FuncToRun & "not found"
        Exit Sub
    End If
    
    On Error Resume Next
    sc.ExecuteStatement ScriptCode
   
    Dim charnum As Long
    Dim nextch As Long
    
    charnum = 1
    If Err Then
        With sc.ERROR
            frmMain.LogResults "Script Runtime Error : " & .Number & ": " & .Description & " at line " & .Line - 1 & " Column:" & .Column & " in the script. (Note that blank lines are ignored)"
            
            charnum = 0
            For i = 1 To .Line - 1
                charnum = InStr(charnum + 1, ScriptCode, vbCr)
            Next i
            nextch = InStr(charnum + 1, ScriptCode, vbCr)
            If nextch = 0 Then: nextch = Len(ScriptCode) + 1
            frmMain.LogResults "line= " & Mid(ScriptCode, charnum + 1, nextch - charnum - 1)
        End With
    End If
    
    Unload QueryForm
    
    InFile.Close
End Sub

Public Sub GetFuncNames(FileName As String, FuncNames() As String)
    'FileSystemObject must reference Microsoft Scripting Engine:
    Dim InFile As Object
    Dim fs As New FileSystemObject
    
    On Error GoTo errorhandler
    
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set InFile = fs.OpenTextFile(FileName, 1, False, 0)

    Dim funcnumber As Integer
    Dim charnum As Integer
    Dim FileLine As String

    funcnumber = 1
    'find all function names:
    Do While InFile.AtEndOfStream <> True
        FileLine = InFile.ReadLine
        If Mid(FileLine, 1, 11) = "BEGINSCRIPT" Then
            charnum = InStr(13, FileLine, " ")      'find any spaces
            If charnum = 0 Then
                charnum = Len(FileLine) - 12
            Else
                charnum = charnum - 13
            End If
            FuncNames(funcnumber) = Mid(FileLine, 13, charnum)
            funcnumber = funcnumber + 1
        End If
    Loop
    
    Exit Sub
errorhandler:
    frmMain.lstResults.AddItem "SCP files not found, check path in hidsuite.ini file"
    Exit Sub
End Sub

