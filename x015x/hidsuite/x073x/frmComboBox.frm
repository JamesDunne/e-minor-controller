VERSION 5.00
Begin VB.Form frmComboBox 
   Caption         =   "Select ram location to read"
   ClientHeight    =   840
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   3945
   LinkTopic       =   "Form1"
   ScaleHeight     =   840
   ScaleWidth      =   3945
   StartUpPosition =   3  'Windows Default
   Begin VB.ComboBox Combo1 
      Height          =   315
      Left            =   120
      TabIndex        =   1
      Text            =   "Combo1"
      Top             =   240
      Width           =   2535
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Ok"
      Height          =   375
      Left            =   2880
      TabIndex        =   0
      Top             =   240
      Width           =   975
   End
End
Attribute VB_Name = "frmComboBox"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
    Me.Hide
End Sub
