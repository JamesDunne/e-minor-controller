VERSION 5.00
Begin VB.Form QueryForm 
   Caption         =   "Set Parameters"
   ClientHeight    =   3405
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4650
   LinkTopic       =   "Form2"
   ScaleHeight     =   3405
   ScaleWidth      =   4650
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton OkButton 
      Caption         =   "Ok"
      Height          =   495
      Left            =   1440
      TabIndex        =   10
      Top             =   2640
      Width           =   1695
   End
   Begin VB.TextBox TextBoxes 
      Height          =   375
      Index           =   4
      Left            =   1800
      TabIndex        =   9
      Text            =   "Text1"
      Top             =   2040
      Width           =   1935
   End
   Begin VB.TextBox TextBoxes 
      Height          =   375
      Index           =   3
      Left            =   1800
      TabIndex        =   8
      Text            =   "Text1"
      Top             =   1560
      Width           =   1935
   End
   Begin VB.TextBox TextBoxes 
      Height          =   375
      Index           =   2
      Left            =   1800
      TabIndex        =   7
      Text            =   "Text1"
      Top             =   1080
      Width           =   1935
   End
   Begin VB.TextBox TextBoxes 
      Height          =   375
      Index           =   1
      Left            =   1800
      TabIndex        =   6
      Text            =   "Text1"
      Top             =   600
      Width           =   1935
   End
   Begin VB.TextBox TextBoxes 
      Height          =   375
      Index           =   0
      Left            =   1800
      TabIndex        =   1
      Text            =   "Text1"
      Top             =   120
      Width           =   1935
   End
   Begin VB.Label Labels 
      Caption         =   "Label1"
      Height          =   255
      Index           =   4
      Left            =   120
      TabIndex        =   5
      Top             =   2040
      Width           =   1455
   End
   Begin VB.Label Labels 
      Caption         =   "Label1"
      Height          =   255
      Index           =   3
      Left            =   120
      TabIndex        =   4
      Top             =   1560
      Width           =   1455
   End
   Begin VB.Label Labels 
      Caption         =   "Label1"
      Height          =   255
      Index           =   2
      Left            =   120
      TabIndex        =   3
      Top             =   1080
      Width           =   1455
   End
   Begin VB.Label Labels 
      Caption         =   "Label1"
      Height          =   255
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   600
      Width           =   1455
   End
   Begin VB.Label Labels 
      Caption         =   "Label1"
      Height          =   255
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1455
   End
End
Attribute VB_Name = "QueryForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public OkButtonPressed As Boolean

Private Sub Form_Load()
    Dim i As Integer
    
    OkButtonPressed = False
    TextBoxes(0).Text = ""
    
    For i = 1 To 4
        Labels(i).Visible = False
        TextBoxes(i).Visible = False
        TextBoxes(i).Text = ""
    Next i
End Sub

Private Sub OkButton_Click()
    OkButtonPressed = True
    Me.Hide
End Sub

'for some reason, a .Show cannot be done from a script
Public Sub ShowQForm()
    QueryForm.Show vbModal, frmMain
End Sub
