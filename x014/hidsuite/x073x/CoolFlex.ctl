VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Begin VB.UserControl CoolFlex 
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   3600
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   PropertyPages   =   "CoolFlex.ctx":0000
   ScaleHeight     =   3600
   ScaleWidth      =   4800
   Begin VB.ComboBox Combo1 
      Height          =   315
      Index           =   0
      Left            =   1680
      TabIndex        =   7
      Text            =   "Combo1"
      Top             =   1575
      Visible         =   0   'False
      Width           =   390
   End
   Begin VB.TextBox Text1 
      Height          =   195
      Left            =   945
      TabIndex        =   5
      Top             =   1785
      Visible         =   0   'False
      Width           =   375
   End
   Begin VB.PictureBox Picture1 
      BorderStyle     =   0  'None
      Height          =   825
      Left            =   2190
      ScaleHeight     =   825
      ScaleWidth      =   2295
      TabIndex        =   1
      Top             =   60
      Visible         =   0   'False
      Width           =   2295
      Begin VB.Frame Frame1 
         Height          =   795
         Left            =   90
         TabIndex        =   2
         Top             =   0
         Width           =   2115
         Begin VB.Label Label2 
            AutoSize        =   -1  'True
            Height          =   195
            Left            =   540
            TabIndex        =   4
            Top             =   450
            Width           =   45
         End
         Begin VB.Label Label1 
            AutoSize        =   -1  'True
            Caption         =   "Please Wait ... "
            Height          =   195
            Left            =   525
            TabIndex        =   3
            Top             =   315
            Width           =   1080
         End
      End
   End
   Begin MSFlexGridLib.MSFlexGrid MSFlexGrid1 
      Height          =   2325
      Left            =   510
      TabIndex        =   0
      Top             =   840
      Width           =   3555
      _ExtentX        =   6271
      _ExtentY        =   4101
      _Version        =   393216
      BackColor       =   16777215
      ForeColor       =   -2147483642
      BackColorFixed  =   14737632
      BackColorSel    =   -2147483639
      BackColorBkg    =   12632256
      WordWrap        =   -1  'True
      AllowBigSelection=   0   'False
      AllowUserResizing=   1
      BorderStyle     =   0
   End
   Begin VB.Image imgNone 
      Height          =   330
      Left            =   105
      Top             =   105
      Width           =   330
   End
   Begin VB.Image imgUnchecked 
      Height          =   270
      Left            =   105
      Picture         =   "CoolFlex.ctx":0014
      Top             =   2205
      Width           =   285
   End
   Begin VB.Image imgChecked 
      Height          =   285
      Left            =   105
      Picture         =   "CoolFlex.ctx":048E
      Top             =   1785
      Width           =   270
   End
   Begin VB.Label DummyLabel 
      AutoSize        =   -1  'True
      Height          =   195
      Left            =   300
      TabIndex        =   6
      Top             =   210
      Width           =   45
   End
End
Attribute VB_Name = "CoolFlex"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "PropPageWizardRun" ,"Yes"
'----------------------------------------------------------------------------------------
'Program Title:CoolFlex OCX
'Date : 27 July 2001
'Author: John
'Requirement:Microsoft DAO library
'select Microsoft DAO .... in Project->Reference first
'Note:
'This is based off the EasyFlex control submitted by Joe (Email: Joha_Good@hotmail.com)
'Many properties and methods were added
'16 Aug 2001 - added several more properties and methods to the control
'----------------------------------------------------------------------------------------

Option Explicit
Private MyDataName As Database
Private MyRecord As Long       'var for total record
Private MyRecordPos As Long    'var for record pos
Private AutoFix As Boolean       'var for automatic fixed
Private ModifyWidth As Long
Private MyAlignment As AlignmentSettings   'var for alignment setting
Private MyEdit As Boolean                          'var for edit flexgrid
Private LoadRecord As Boolean            'var for specify wheter record is loading or not
Private ColumnType() As CoolFlexColType
Private SetColumnTypeArray As Boolean
Private LastCol As Long
Private ComboBoxCount As Integer
Private mLaunchForm As String
Private SortOnHeader As Boolean
Private SortOnHeaderValue As CoolFlexSort

'component activity
Public Event Click()
Public Event EnterCell(Rowsel As Long, Colsel As Long, Value As String)
Public Event DblClick()
Public Event LeaveCell()
Public Event RowColChange()
Public Event CellComboBoxClick(ColIndex As Long, Value As String)
Public Event CellComboBoxChange(ColIndex As Long)
Public Event CellCheckBoxClick(ColIndex As Long, Value As Integer)

Public Enum CoolFlexGridLines
    GridFlat = 1
    GridInset = 2
    GridNone = 0
    GridRaised = 3
End Enum

Public Enum CoolFlexScrollBar
    ScrollBarBoth = 3
    ScrollBarHorizontal = 1
    ScrollBarNone = 0
    ScrollBarVertical = 2
End Enum

Public Enum CoolFlexSort
    SortNone = 0
    SortGenericAscending = 1
    SortGenericDescending = 2
    SortNumericAscending = 3
    SortNumericDescending = 4
    SortStringNoCaseAsending = 5
    SortNoCaseDescending = 6
    SortStringAscending = 7
    SortStringDescending = 8
End Enum

Public Enum CoolFlexColType
    eTextbox
    eCheckbox
    eCombobox
End Enum

Private Sub Combo1_Change(Index As Integer)
    RaiseEvent CellComboBoxChange(MSFlexGrid1.Col)
End Sub

Private Sub Combo1_Click(Index As Integer)
    If Combo1(LastCol).Visible = True Then
       MSFlexGrid1.Text = Combo1(LastCol).Text
       Combo1(LastCol).Text = ""
       Combo1(LastCol).Visible = False
    End If
    RaiseEvent CellComboBoxClick(MSFlexGrid1.Col, MSFlexGrid1.Text)
End Sub

Private Sub Combo1_LostFocus(Index As Integer)
    MSFlexGrid1_LeaveCell
End Sub

Private Sub Text1_LostFocus()
    MSFlexGrid1_LeaveCell
End Sub

Private Sub MSFlexGrid1_RowColChange()
    'RaiseEvent RowColChange
    Dim Rowsel As Long
    Dim Colsel As Long
    Dim Value As String
    LastCol = MSFlexGrid1.Colsel
    Rowsel = MSFlexGrid1.Rowsel
    Colsel = MSFlexGrid1.Colsel
    Value = MSFlexGrid1.TextMatrix(MSFlexGrid1.Rowsel, MSFlexGrid1.Colsel)

    If MSFlexGrid1.Row = 0 And SortOnHeader = True Then
        MSFlexGrid1.Sort = SortOnHeaderValue
    End If

    If MyEdit = True And LoadRecord = False Then
        Select Case ColumnType(Colsel)
            Case eTextbox 'default
                If MSFlexGrid1.Col >= MSFlexGrid1.FixedCols And MSFlexGrid1.Row >= MSFlexGrid1.FixedRows Then
                    Text1.BackColor = MSFlexGrid1.BackColor
                    Text1.ForeColor = MSFlexGrid1.ForeColor
                    Set Text1.Font = MSFlexGrid1.Font
                    Text1.Width = MSFlexGrid1.CellWidth
                    Text1.Height = MSFlexGrid1.CellHeight
                    Text1.Left = MSFlexGrid1.CellLeft + MSFlexGrid1.Left
                    Text1.Top = MSFlexGrid1.CellTop + MSFlexGrid1.Top
                    Text1.Text = Value
                    Text1.Visible = True
                    Text1.SetFocus
                    Text1.SelStart = 0
                    Text1.SelLength = Len(Text1.Text)
                End If
                RaiseEvent Click
'            Case eCheckbox
'                If MSFlexGrid1.Col >= MSFlexGrid1.FixedCols And MSFlexGrid1.Row >= MSFlexGrid1.FixedRows Then
'                    MSFlexGrid1.CellPictureAlignment = 4 'center x center
'                    If MSFlexGrid1.Text = "C" Then
'                        Set MSFlexGrid1.CellPicture = imgUnchecked.Picture  'LoadPicture(App.Path & "\Checked.bmp")
'                        MSFlexGrid1.Text = "U"
'                        RaiseEvent CellCheckBoxClick(MSFlexGrid1.Col, 0)
'                    Else
'                        Set MSFlexGrid1.CellPicture = imgChecked.Picture  'LoadPicture(App.Path & "\Checked.bmp")
'                        MSFlexGrid1.Text = "C"
'                        RaiseEvent CellCheckBoxClick(MSFlexGrid1.Col, 1)
'                    End If
'                Else
'                    RaiseEvent Click
'                End If
            Case eCombobox
                If MSFlexGrid1.Col >= MSFlexGrid1.FixedCols And MSFlexGrid1.Row >= MSFlexGrid1.FixedRows Then
                    Combo1(Colsel).BackColor = MSFlexGrid1.BackColor
                    Combo1(Colsel).ForeColor = MSFlexGrid1.ForeColor
                    Set Combo1(Colsel).Font = MSFlexGrid1.Font
                    Combo1(Colsel).Width = MSFlexGrid1.CellWidth
                    Combo1(Colsel).Left = MSFlexGrid1.CellLeft + MSFlexGrid1.Left
                    Combo1(Colsel).Top = MSFlexGrid1.CellTop + MSFlexGrid1.Top
                    Combo1(Colsel).Text = Value
                    Combo1(Colsel).Visible = True
                    Combo1(Colsel).ZOrder
                    Combo1(Colsel).SetFocus
                    Combo1(Colsel).SelStart = 0
                    Combo1(Colsel).SelLength = Len(Combo1(Colsel).Text)
                End If
                'RaiseEvent Click
        End Select
    Else
        'RaiseEvent Click
    End If
End Sub

Private Sub MSFlexGrid1_Click()
    Dim Rowsel As Long
    Dim Colsel As Long
    Dim Value As String
    LastCol = MSFlexGrid1.Colsel
    Rowsel = MSFlexGrid1.Rowsel
    Colsel = MSFlexGrid1.Colsel
    Value = MSFlexGrid1.TextMatrix(MSFlexGrid1.Rowsel, MSFlexGrid1.Colsel)

    If MSFlexGrid1.MouseRow = 0 And SortOnHeader = True Then
        MSFlexGrid1.Sort = SortOnHeaderValue
    End If

    If MyEdit = True And LoadRecord = False Then
        Select Case ColumnType(Colsel)
            Case eTextbox 'default
                If MSFlexGrid1.MouseCol >= MSFlexGrid1.FixedCols And MSFlexGrid1.MouseRow >= MSFlexGrid1.FixedRows Then
                    Text1.BackColor = MSFlexGrid1.BackColor
                    Text1.ForeColor = MSFlexGrid1.ForeColor
                    Set Text1.Font = MSFlexGrid1.Font
                    Text1.Width = MSFlexGrid1.CellWidth
                    Text1.Height = MSFlexGrid1.CellHeight
                    Text1.Left = MSFlexGrid1.CellLeft + MSFlexGrid1.Left
                    Text1.Top = MSFlexGrid1.CellTop + MSFlexGrid1.Top
                    Text1.Text = Value
                    Text1.Visible = True
                    Text1.SetFocus
                    Text1.SelStart = 0
                    Text1.SelLength = Len(Text1.Text)
                End If
                RaiseEvent Click
            Case eCheckbox
                If MSFlexGrid1.MouseCol > 0 And MSFlexGrid1.MouseRow > 0 Then
                    MSFlexGrid1.CellPictureAlignment = 4 'center x center
                    If MSFlexGrid1.Text = "C" Then
                        Set MSFlexGrid1.CellPicture = imgUnchecked.Picture  'LoadPicture(App.Path & "\Checked.bmp")
                        MSFlexGrid1.Text = "U"
                        RaiseEvent CellCheckBoxClick(MSFlexGrid1.Col, 0)
                    Else
                        Set MSFlexGrid1.CellPicture = imgChecked.Picture  'LoadPicture(App.Path & "\Checked.bmp")
                        MSFlexGrid1.Text = "C"
                        RaiseEvent CellCheckBoxClick(MSFlexGrid1.Col, 1)
                    End If
                Else
                    RaiseEvent Click
                End If
            Case eCombobox
                If MSFlexGrid1.MouseCol > 0 And MSFlexGrid1.MouseRow > 0 Then
                    Combo1(Colsel).BackColor = MSFlexGrid1.BackColor
                    Combo1(Colsel).ForeColor = MSFlexGrid1.ForeColor
                    Set Combo1(Colsel).Font = MSFlexGrid1.Font
                    Combo1(Colsel).Width = MSFlexGrid1.CellWidth
                    Combo1(Colsel).Left = MSFlexGrid1.CellLeft + MSFlexGrid1.Left
                    Combo1(Colsel).Top = MSFlexGrid1.CellTop + MSFlexGrid1.Top
                    Combo1(Colsel).Text = Value
                    Combo1(Colsel).Visible = True
                    Combo1(Colsel).ZOrder
                    Combo1(Colsel).SetFocus
                    Combo1(Colsel).SelStart = 0
                    Combo1(Colsel).SelLength = Len(Combo1(Colsel).Text)
                End If
                RaiseEvent Click
        End Select
    Else
        RaiseEvent Click
    End If
End Sub

Private Sub MSFlexGrid1_DblClick()
    RaiseEvent DblClick
End Sub

'end of component activity

'component methods
Public Sub Clear()
    Dim x As Long
    MSFlexGrid1.Clear
    
    Text1.Text = ""
    Text1.Visible = False
    
    For x = 0 To Combo1.UBound
        Combo1(x).Text = ""
        Combo1(x).Visible = False
    Next
    
    SetCheckBoxes
End Sub

Public Sub UpdateCheckbox(Row As Integer, Col As Integer)
    Dim TempRow As Long
    Dim TempCol As Long
    
    TempRow = MSFlexGrid1.Row
    TempCol = MSFlexGrid1.Col
    
    MSFlexGrid1.Row = Row
    MSFlexGrid1.Col = Col

    MSFlexGrid1.CellPictureAlignment = 4 'center x center
    MSFlexGrid1.CellForeColor = vbWhite
    
    If MSFlexGrid1.TextMatrix(Row, Col) = "C" Then
        Set MSFlexGrid1.CellPicture = imgChecked.Picture  'LoadPicture(App.Path & "\Checked.bmp")
    Else
        Set MSFlexGrid1.CellPicture = imgUnchecked.Picture  'LoadPicture(App.Path & "\Checked.bmp")
    End If
    
    MSFlexGrid1.Row = TempRow
    MSFlexGrid1.Col = TempCol
End Sub


Public Sub RemoveItem(ByVal Index As Long)
    MSFlexGrid1.RemoveItem Index
    Text1.Text = ""
    Text1.Visible = False
    Combo1(LastCol).Visible = False
    Combo1(LastCol).Text = ""
End Sub

Public Sub ColType(ByVal ColNumber As Long, ByVal eType As CoolFlexColType)
    ColumnType(ColNumber) = eType
    Select Case eType
        Case eTextbox 'default

        Case eCheckbox
            SetCheckBoxes
        Case eCombobox
            
    End Select
End Sub

Public Sub ComboBoxAddItem(ByVal Col As Long, ByVal Item As String)
    Combo1(Col).AddItem Item
End Sub

Public Sub ComboBoxClear(ByVal Col As Long)
    Combo1(Col).Clear
End Sub

Public Sub ComboBoxRemoveItem(ByVal Col As Long, ByVal Index As Integer)
    Combo1(Col).RemoveItem Index
End Sub

Public Sub SortOnHeaderClick(ByVal SortOn As Boolean, ByVal NewValue As CoolFlexSort)
    SortOnHeader = SortOn
    SortOnHeaderValue = NewValue
End Sub

'end component methods

Private Sub MSFlexGrid1_EnterCell()
    Dim Rowsel As Long
    Dim Colsel As Long
    Dim Value As String
    LastCol = MSFlexGrid1.Colsel
    Rowsel = MSFlexGrid1.Rowsel
    Colsel = MSFlexGrid1.Colsel
    RaiseEvent EnterCell(Rowsel, Colsel, Value)
End Sub

Private Sub MSFlexGrid1_LeaveCell()
    If Text1.Visible = True Then
       MSFlexGrid1.Text = Text1.Text
       Text1.Text = ""
       Text1.Visible = False
    End If
    
    If Combo1(LastCol).Visible = True Then
       MSFlexGrid1.Text = Combo1(LastCol).Text
       Combo1(LastCol).Text = ""
       Combo1(LastCol).Visible = False
    End If

    'RaiseEvent LeaveCell
End Sub

Private Sub MSFlexGrid1_Scroll()
    Text1.Visible = False
    Combo1(LastCol).Visible = False
End Sub

Private Sub Combo1_KeyDown(Index As Integer, KeyCode As Integer, Shift As Integer)
    Select Case KeyCode
        Case vbKeyEscape        'user press escape key
           Combo1(Index).Visible = False
        
        Case vbKeyReturn
           MSFlexGrid1.SetFocus
           DoEvents
           If MSFlexGrid1.Row < MSFlexGrid1.Rows - 1 Then
              MSFlexGrid1.Row = MSFlexGrid1.Row + 1
           End If
        
        Case vbKeyDown          'user press arrow down key
           MSFlexGrid1.SetFocus
           DoEvents
'           If MSFlexGrid1.Row < MSFlexGrid1.Rows - 1 Then
'              MSFlexGrid1.Row = MSFlexGrid1.Row + 1
'           End If
            
        Case vbKeyUp            'user press arrow up key
           MSFlexGrid1.SetFocus
           DoEvents
'            If MSFlexGrid1.Row > MSFlexGrid1.FixedRows Then
'                MSFlexGrid1.Row = MSFlexGrid1.Row - 1
'            End If
    
        Case vbKeyLeft
           MSFlexGrid1.SetFocus
           DoEvents
'            If Combo1(index).SelStart = 0 And Len(Combo1(index).SelText) = 0 Then
'                If MSFlexGrid1.Col > MSFlexGrid1.FixedCols Then
'                   MSFlexGrid1.Col = MSFlexGrid1.Col - 1
'                End If
'            ElseIf Combo1(index).SelStart = 0 And Len(Combo1(index).SelText) = Len(Combo1(index).Text) Then
'                Combo1(index).SelStart = 0
'            End If
           
        Case vbKeyRight
           MSFlexGrid1.SetFocus
           DoEvents
'            If Combo1(index).SelStart = Len(Combo1(index).Text) Then
'                If MSFlexGrid1.Col < MSFlexGrid1.Cols - 1 Then
'                    MSFlexGrid1.Col = MSFlexGrid1.Col + 1
'                End If
'            ElseIf Combo1(index).SelStart = 0 And Len(Combo1(index).SelText) = Len(Combo1(index).Text) Then
'                Combo1(index).SelStart = Len(Combo1(index).Text)
'            End If

    End Select
End Sub

Private Sub Text1_KeyDown(KeyCode As Integer, Shift As Integer)
    Select Case KeyCode
        Case vbKeyEscape        'user press escape key
           Text1.Visible = False
        
        Case vbKeyReturn
           MSFlexGrid1.SetFocus
           DoEvents
           If MSFlexGrid1.Row < MSFlexGrid1.Rows - 1 Then
              MSFlexGrid1.Row = MSFlexGrid1.Row + 1
           End If
        
        Case vbKeyDown          'user press arrow down key
           MSFlexGrid1.SetFocus
           DoEvents
           If MSFlexGrid1.Row < MSFlexGrid1.Rows - 1 Then
              MSFlexGrid1.Row = MSFlexGrid1.Row + 1
           End If
        
        Case vbKeyUp            'user press arrow up key
           MSFlexGrid1.SetFocus
           DoEvents
           If MSFlexGrid1.Row > MSFlexGrid1.FixedRows Then
              MSFlexGrid1.Row = MSFlexGrid1.Row - 1
            End If
    
        Case vbKeyLeft
'            If Text1.SelStart = 0 And Len(Text1.SelText) = 0 Then
'                If MSFlexGrid1.Col > MSFlexGrid1.FixedCols Then
'                   MSFlexGrid1.Col = MSFlexGrid1.Col - 1
'                End If
'            ElseIf Text1.SelStart = 0 And Len(Text1.SelText) = Len(Text1.Text) Then
'                Text1.SelStart = 0
'            End If
            
            If MSFlexGrid1.Col > MSFlexGrid1.FixedCols Then
               MSFlexGrid1.Col = MSFlexGrid1.Col - 1
            End If
            
        Case vbKeyRight
'            If Text1.SelStart = Len(Text1.Text) Then
'                If MSFlexGrid1.Col < MSFlexGrid1.Cols - 1 Then
'                    MSFlexGrid1.Col = MSFlexGrid1.Col + 1
'                End If
'            ElseIf Text1.SelStart = 0 And Len(Text1.SelText) = Len(Text1.Text) Then
'                Text1.SelStart = Len(Text1.Text)
'            End If
            If MSFlexGrid1.Col < MSFlexGrid1.Cols - 1 Then
                MSFlexGrid1.Col = MSFlexGrid1.Col + 1
            End If
    End Select
End Sub

Private Sub UserControl_Initialize()
    'initialize control in design time
    MSFlexGrid1.Top = 0
    MSFlexGrid1.Left = 0
    MSFlexGrid1.Width = UserControl.Width - 60
    MSFlexGrid1.Height = UserControl.Height - 60
    'coordinate progress
    Picture1.Left = (UserControl.Width / 2) - (Picture1.Width / 2)
    Picture1.Top = (UserControl.Height / 2) - (Picture1.Height / 2)
End Sub

Private Sub UserControl_Resize()
    MSFlexGrid1.Top = 0
    MSFlexGrid1.Left = 0
    MSFlexGrid1.Width = UserControl.Width - 60
    MSFlexGrid1.Height = UserControl.Height - 60
    Picture1.Left = (UserControl.Width / 2) - (Picture1.Width / 2)
    Picture1.Top = (UserControl.Height / 2) - (Picture1.Height / 2)
End Sub

Public Sub Show_Record(ByVal SQLCommand As String)
    'On Error GoTo errorhandler
    LoadRecord = True
    Dim Maindb As Database
    Dim theset As Object
    Dim c As Long, No As Long
    Dim DynamicCol() As Long
    Dim TotalColoumn As Long
    Dim MyData As String
    Dim DataWidth As Long
    
    'open recordset
    Set theset = MyDataName.OpenRecordset(SQLCommand)
    
    If theset.EOF Then Exit Sub  'if no record exist
    'calculate total field
    TotalColoumn = theset.Fields.Count
    
    Set_Grid (TotalColoumn)
    'recreate array in run time
    
    For c = 1 To theset.Fields.Count
       MSFlexGrid1.TextMatrix(0, c) = theset.Fields(c - 1).Name
    Next c
    
    theset.MoveLast
    MyRecord = theset.AbsolutePosition + 1
    theset.MoveFirst
    
    If AutoFixCol = False Then
    Do While Not theset.EOF
       DoEvents
       No = No + 1
       MyRecordPos = theset.AbsolutePosition + 1
       Label2.Caption = Format(MyRecordPos / MyRecord * 100, "##") & "  % Completed"
       MSFlexGrid1.Rows = MSFlexGrid1.Rows + 1
       MSFlexGrid1.TextMatrix(No, 0) = Str(No)
       For c = 1 To theset.Fields.Count
          MSFlexGrid1.Col = c
          MSFlexGrid1.Row = No
          MSFlexGrid1.CellAlignment = MyAlignment
          MSFlexGrid1.TextMatrix(No, c) = theset.Fields(c - 1).Value & ""
       Next c
       theset.MoveNext
    Loop
    'when select autofixcol=true
    Else
    ReDim DynamicCol(TotalColoumn)
       Do While Not theset.EOF
          DoEvents
          No = No + 1
          MyRecordPos = theset.AbsolutePosition + 1
          Label2.Caption = Format(MyRecordPos / MyRecord * 100, "##") & "  % Completed"
          MSFlexGrid1.Rows = MSFlexGrid1.Rows + 1
          MSFlexGrid1.TextMatrix(No, 0) = Str(No)
          For c = 1 To theset.Fields.Count
          MSFlexGrid1.Col = c
          MSFlexGrid1.Row = No
          MSFlexGrid1.CellAlignment = MyAlignment
             MyData = Trim(theset.Fields(c - 1).Value) & ""
             MSFlexGrid1.TextMatrix(No, c) = MyData
             'get the width value
             DummyLabel.Caption = MyData
             DataWidth = DummyLabel.Width
             If DynamicCol(c) < DataWidth + ModifyWidth + 100 Then
                DynamicCol(c) = DataWidth + ModifyWidth + 100
             End If
          
          MSFlexGrid1.ColWidth(c) = DynamicCol(c)
          Next c
          theset.MoveNext
       Loop
    End If
    
    Set theset = Nothing
    LoadRecord = False
    Exit Sub
errorhandler:
    
    MsgBox Err.Number & "  " & Err.Description
    
End Sub
Private Sub Set_Grid(ByVal mycol As Long)
    'setting msflexgrid control
    MSFlexGrid1.Clear
    MSFlexGrid1.Cols = mycol + 1
    MSFlexGrid1.Rows = 1
    MSFlexGrid1.TextMatrix(0, 0) = "No."
    MSFlexGrid1.ColWidth(0) = 500
End Sub

Public Sub AboutBox()
Attribute AboutBox.VB_UserMemId = -552
    MsgBox "Thank You for using CoolFlex, based on EasyFlex 1.0 found at FreeVBCode.com"
End Sub

'property
'text matrix property
Public Property Get TextMatrix(ByVal Row As Long, ByVal Col As Long) As String
    TextMatrix = MSFlexGrid1.TextMatrix(Row, Col)
End Property
Public Property Let TextMatrix(ByVal Row As Long, ByVal Col As Long, ByVal NewText As String)
    MSFlexGrid1.TextMatrix(Row, Col) = NewText
End Property

'Set Col & Row
Public Property Let Cols(ByVal NewCols As Long)
    Dim x As Integer
    MSFlexGrid1.Cols = NewCols
    ReDim ColumnType(NewCols - 1)
    SetColumnTypeArray = True
    
    For x = 1 To NewCols - 1
        Load Combo1(x)
    Next
    
    PropertyChanged "Cols"
End Property
Public Property Get Cols() As Long
    Cols = MSFlexGrid1.Cols
End Property

Public Property Let Col(ByVal NewCol As Long)
    MSFlexGrid1.Col = NewCol
End Property
Public Property Get Col() As Long
    Col = MSFlexGrid1.Col
End Property

Public Property Let Rows(ByVal NewRows As Long)
    MSFlexGrid1.Rows = NewRows
    PropertyChanged "Rows"
    'SetCheckBoxes
End Property
Public Property Get Rows() As Long
    Rows = MSFlexGrid1.Rows
End Property

Public Property Let Row(ByVal NewRow As Long)
    MSFlexGrid1.Row = NewRow
End Property
Public Property Get Row() As Long
    Row = MSFlexGrid1.Row
End Property

Private Sub SetCheckBoxes(Optional ByVal iCol As Integer, Optional ByVal iRow As Integer)
    Dim x As Long
    Dim y As Long
    Dim TempRow As Long
    Dim TempCol As Long
            
    If SetColumnTypeArray = False Then
        Exit Sub
    End If
    
    TempCol = MSFlexGrid1.Colsel
    TempRow = MSFlexGrid1.Rowsel
    
    For x = 1 To MSFlexGrid1.Rows - 1
        For y = 0 To MSFlexGrid1.Cols - 1
            If ColumnType(y) = eCheckbox Then
                If Len(MSFlexGrid1.TextMatrix(x, y)) = 0 Then
                    MSFlexGrid1.Col = y
                    MSFlexGrid1.Row = x
                    MSFlexGrid1.CellPictureAlignment = 4 'center x center
                    Set MSFlexGrid1.CellPicture = imgUnchecked.Picture
                    MSFlexGrid1.Text = "U"
                    MSFlexGrid1.CellForeColor = vbWhite
                End If
            End If
        Next y
    Next x
    MSFlexGrid1.Colsel = TempCol
    MSFlexGrid1.Rowsel = TempRow
End Sub

Public Property Let ColWidth(ByVal Col As Long, ByVal NewWidth As Long)
    MSFlexGrid1.ColWidth(Col) = NewWidth
End Property

Public Property Get Rowsel() As Long
Attribute Rowsel.VB_MemberFlags = "400"
    Rowsel = MSFlexGrid1.Rowsel
End Property
Public Property Let Rowsel(ByVal NewRowSel As Long)
    MSFlexGrid1.Rowsel = NewRowSel
End Property

Public Property Get Colsel() As Long
Attribute Colsel.VB_MemberFlags = "400"
    Colsel = MSFlexGrid1.Colsel
End Property
Public Property Let Colsel(ByVal NewColSel As Long)
    MSFlexGrid1.Colsel = NewColSel
End Property

'number of recordset
Public Property Get TotalRecord() As Long
    TotalRecord = MyRecord
End Property

'set view progress
Public Property Get ViewProgress() As Boolean
Attribute ViewProgress.VB_MemberFlags = "400"
    ViewProgress = Picture1.Visible
End Property
Public Property Let ViewProgress(ByVal NewViewProgress As Boolean)
    Picture1.Visible = NewViewProgress
    PropertyChanged "ViewProgress"
End Property

'set redraw
Public Property Get Redraw() As Boolean
    Redraw = MSFlexGrid1.Redraw
End Property
Public Property Let Redraw(ByVal NewRedraw As Boolean)
    MSFlexGrid1.Redraw = NewRedraw
    PropertyChanged "Redraw"
End Property

'set color property
Public Property Let BackColor(ByVal NewColor As OLE_COLOR)
    MSFlexGrid1.BackColor = NewColor
    PropertyChanged "BackColor"
End Property
Public Property Get BackColor() As OLE_COLOR
    BackColor = MSFlexGrid1.BackColor
End Property

Public Property Let BackColorBkg(ByVal NewColor As OLE_COLOR)
    MSFlexGrid1.BackColorBkg = NewColor
    PropertyChanged "BackColorBkg"
End Property
Public Property Get BackColorBkg() As OLE_COLOR
    BackColorBkg = MSFlexGrid1.BackColorBkg
End Property

Public Property Let BackColorFixed(ByVal NewColor As OLE_COLOR)
    MSFlexGrid1.BackColorFixed = NewColor
    PropertyChanged "BackColorFixed"
End Property

Public Property Get BackColorFixed() As OLE_COLOR
    BackColorFixed = MSFlexGrid1.BackColorFixed
End Property

Public Property Let BackColorSel(ByVal NewColor As OLE_COLOR)
    MSFlexGrid1.BackColorSel = NewColor
    PropertyChanged "BackColorSel"
End Property
Public Property Get BackColorSel() As OLE_COLOR
    BackColorSel = MSFlexGrid1.BackColorSel
End Property

Public Property Let ForeColor(ByVal NewColor As OLE_COLOR)
    MSFlexGrid1.ForeColor = NewColor
    PropertyChanged "ForeColor"
End Property
Public Property Get ForeColor() As OLE_COLOR
    ForeColor = MSFlexGrid1.ForeColor
End Property

Public Property Let ForeColorFixed(ByVal NewColor As OLE_COLOR)
    MSFlexGrid1.ForeColorFixed = NewColor
    PropertyChanged "ForeColorFixed"
End Property
Public Property Get ForeColorFixed() As OLE_COLOR
    ForeColorFixed = MSFlexGrid1.ForeColorFixed
End Property

Public Property Let ForeColorSel(ByVal NewColor As OLE_COLOR)
    MSFlexGrid1.ForeColorSel = NewColor
    PropertyChanged "ForeColorSel"
End Property
Public Property Get ForeColorSel() As OLE_COLOR
    ForeColorSel = MSFlexGrid1.ForeColorSel
End Property

Public Property Let GridColor(ByVal NewColor As OLE_COLOR)
    MSFlexGrid1.GridColor = NewColor
    PropertyChanged "GridColor"
End Property
Public Property Get GridColor() As OLE_COLOR
    GridColor = MSFlexGrid1.GridColor
End Property

Public Property Let GridColorFixed(ByVal NewColor As OLE_COLOR)
    MSFlexGrid1.GridColorFixed = NewColor
    PropertyChanged "GridColorFixed"
End Property

Public Property Get GridColorFixed() As OLE_COLOR
    GridColorFixed = MSFlexGrid1.GridColorFixed
End Property
'end of set color property
'set font
Public Property Get Font() As IFontDisp
Attribute Font.VB_ProcData.VB_Invoke_Property = ";Font"
   Set Font = MSFlexGrid1.Font
End Property

Public Property Set Font(ByVal New_Font As IFontDisp)
    Set MSFlexGrid1.Font = New_Font
    PropertyChanged "Font"
End Property
'end of set font

'set mousepointer
Public Property Get MousePointer() As MousePointerConstants
    MousePointer = UserControl.MousePointer
End Property

Public Property Let MousePointer(ByVal New_MousePointer As MousePointerConstants)
    ' Validation is supplied by UserControl.
    Let UserControl.MousePointer() = New_MousePointer
    PropertyChanged "MousePointer"
End Property
'end of set mousepointer

'set mouseicon
Public Property Get MouseIcon() As Picture
    Set MouseIcon = UserControl.MouseIcon
End Property

Public Property Set MouseIcon(ByVal New_MouseIcon As Picture)
    Set UserControl.MouseIcon = New_MouseIcon
    PropertyChanged "MouseIcon"
End Property
'end of set mouseicon

'set record alignment for all record display in msflexgrid
Public Property Get RecordAlignment() As AlignmentSettings
   RecordAlignment = MyAlignment
   
End Property
Public Property Let RecordAlignment(ByVal NewAlignment As AlignmentSettings)
   MyAlignment = NewAlignment
   PropertyChanged "RecordAlignment"
End Property
'end of set record

'set database name
Public Property Let DataName(ByVal NewValue As Database)
    Set MyDataName = NewValue
End Property
Public Property Get DataName() As Database
    Set MyDataName = DataName
End Property
'end of database setting

'set samadaa boleh edit atau tidak
Public Property Get EditEnable() As Boolean
   EditEnable = MyEdit
End Property
Public Property Let EditEnable(ByVal NewEditEnable As Boolean)
   MyEdit = NewEditEnable
   'popertyChanged "EditEnable"
End Property
'end of edit enable

Public Property Get EditTextLenght() As Long
    EditTextLenght = Text1.MaxLength
End Property
Public Property Let EditTextLenght(ByVal NewEditLenght As Long)
    Text1.MaxLength = NewEditLenght
    PropertyChanged "EditTextLenght"
End Property

'property autofix
Public Property Get AutoFixCol() As Boolean
   AutoFixCol = AutoFix
End Property
Public Property Let AutoFixCol(ByVal NewAutoFixCol As Boolean)
   AutoFix = NewAutoFixCol
   PropertyChanged "AutoFixCol"
End Property

Public Property Get AddWidth() As Long
   AddWidth = ModifyWidth
End Property
Public Property Let AddWidth(ByVal NewModifyValue As Long)
   ModifyWidth = NewModifyValue
   PropertyChanged "AddWidth"
End Property

Public Property Get GridEnabled() As Boolean
   GridEnabled = MSFlexGrid1.Enabled
End Property
Public Property Let GridEnabled(ByVal NewValue As Boolean)
   MSFlexGrid1.Enabled = NewValue
   Text1.Text = ""
   If NewValue = False Then
     Text1.Visible = NewValue
     Combo1(LastCol).Visible = NewValue
   End If
End Property

Public Property Get HideCol(ByVal Col As Long) As Boolean
    If MSFlexGrid1.ColWidth(Col) = 0 Then
        HideCol = True
    Else
        HideCol = False
    End If
End Property
Public Property Let HideCol(ByVal Col As Long, ByVal NewValue As Boolean)
    Dim x As Long
    If NewValue = True Then
        If ColumnType(Col) = eCheckbox Then
            With MSFlexGrid1
                .Col = Col
                For x = 1 To .Rows - 1
                    .Row = x
                    Set .CellPicture = Nothing
                Next x
            End With
        End If
        MSFlexGrid1.ColWidth(Col) = 0
    Else
        If ColumnType(Col) = eCheckbox Then
            With MSFlexGrid1
                .Col = Col
                For x = 1 To .Rows - 1
                    .Row = x
                    If .Text = "U" Then
                        Set .CellPicture = imgUnchecked.Picture
                    ElseIf .Text = "C" Then
                        Set .CellPicture = imgChecked.Picture
                    End If
                Next x
            End With
        End If
        MSFlexGrid1.ColWidth(Col) = MSFlexGrid1.ColWidth(Col - 1)
    End If
End Property

Public Property Get HideRow(ByVal Row As Long) As Boolean
    If MSFlexGrid1.RowHeight(Row) = 0 Then
        HideRow = True
    Else
        HideRow = False
    End If
End Property
Public Property Let HideRow(ByVal Row As Long, ByVal NewValue As Boolean)
    Dim x As Long
    With MSFlexGrid1
        If NewValue = True Then
            .Row = Row
            For x = 1 To .Cols - 1
                If ColumnType(x) = eCheckbox Then
                    .Col = x
                    Set .CellPicture = Nothing
                End If
            Next x
            MSFlexGrid1.RowHeight(Row) = 0
        Else
            .Row = Row
            For x = 1 To .Cols - 1
                If ColumnType(x) = eCheckbox Then
                    .Col = x
                    If .Text = "U" Then
                        Set .CellPicture = imgUnchecked.Picture
                    ElseIf .Text = "C" Then
                        Set .CellPicture = imgChecked.Picture
                    End If
                End If
            Next x
            MSFlexGrid1.RowHeight(Row) = MSFlexGrid1.RowHeight(Row - 1)
        End If
    End With
End Property

Public Property Get GridLines() As CoolFlexGridLines
   GridLines = MSFlexGrid1.GridLines
End Property
Public Property Let GridLines(ByVal NewValue As CoolFlexGridLines)
   MSFlexGrid1.GridLines = NewValue
End Property

Public Property Get MouseCol() As Integer
   MouseCol = MSFlexGrid1.MouseCol
End Property

Public Property Get MouseRow() As Integer
   MouseRow = MSFlexGrid1.MouseRow
End Property

Public Property Get ScrollBars() As CoolFlexScrollBar
   ScrollBars = MSFlexGrid1.ScrollBars
End Property
Public Property Let ScrollBars(ByVal NewValue As CoolFlexScrollBar)
   MSFlexGrid1.ScrollBars = NewValue
End Property

Public Property Let Sort(ByVal NewValue As CoolFlexSort)
   Text1.Text = ""
   Text1.Visible = False
   Combo1(LastCol).Text = ""
   Combo1(LastCol).Visible = False
   MSFlexGrid1.Sort = NewValue
End Property

Public Property Get Tag() As String
   Tag = MSFlexGrid1.Tag
End Property
Public Property Let Tag(ByVal NewValue As String)
   MSFlexGrid1.Tag = NewValue
End Property

Public Property Get Text() As String
   Text = MSFlexGrid1.Text
End Property
Public Property Let Text(ByVal NewValue As String)
   MSFlexGrid1.Text = NewValue
End Property

Public Property Get WordWrap() As Boolean
   WordWrap = MSFlexGrid1.WordWrap
End Property
Public Property Let WordWrap(ByVal NewValue As Boolean)
   MSFlexGrid1.WordWrap = NewValue
End Property

Public Property Get ComboBoxListCount(ByVal Col As Long) As Long
   ComboBoxListCount = Combo1(Col).ListCount
End Property

Public Property Get ComboBoxListIndex(ByVal Col As Long) As Long
   ComboBoxListIndex = Combo1(Col).ListIndex
End Property
Public Property Let ComboBoxListIndex(ByVal Col As Long, ByVal NewValue As Long)
   Combo1(Col).ListIndex = NewValue
End Property

Public Property Get ComboBoxItemData(ByVal Col As Long, ByVal Index As Integer) As Long
   ComboBoxItemData = Combo1(Col).ItemData(Index)
End Property
Public Property Let ComboBoxItemData(ByVal Col As Long, ByVal Index As Integer, ByVal NewValue As Long)
   Combo1(Col).ItemData(Index) = NewValue
End Property

Public Property Get FixedCols() As Long
   FixedCols = MSFlexGrid1.FixedCols
End Property
Public Property Let FixedCols(ByVal NewValue As Long)
   MSFlexGrid1.FixedCols = NewValue
End Property

Public Property Get FixedRows() As Long
   FixedRows = MSFlexGrid1.FixedRows
End Property
Public Property Let FixedRows(ByVal NewValue As Long)
   MSFlexGrid1.FixedRows = NewValue
End Property
