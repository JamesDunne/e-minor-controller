VERSION 5.00
Begin VB.Form frmListBox 
   Caption         =   "Select HID device"
   ClientHeight    =   1410
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4410
   LinkTopic       =   "Form1"
   ScaleHeight     =   1410
   ScaleWidth      =   4410
   StartUpPosition =   2  'CenterScreen
   Begin VB.ListBox List1 
      Height          =   1230
      Left            =   0
      TabIndex        =   0
      Top             =   120
      Width           =   4335
   End
End
Attribute VB_Name = "frmListBox"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub List1_Click()
    Dim i As Integer
    For i = 0 To List1.ListCount - 1
        If List1.Selected(i) Then
            'MsgBox "selected=" & List1.List(i)
            SelectedDev = i
        End If
    Next

    Unload Me
End Sub
