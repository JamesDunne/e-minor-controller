VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form frmMain 
   Caption         =   "HID Suite"
   ClientHeight    =   7440
   ClientLeft      =   255
   ClientTop       =   330
   ClientWidth     =   9270
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   7440
   ScaleWidth      =   9270
   Begin MSCommLib.MSComm MSComm1 
      Left            =   3000
      Top             =   0
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      DTREnable       =   -1  'True
   End
   Begin VB.Frame Frame9 
      Caption         =   "Protocol"
      Height          =   855
      Left            =   8040
      TabIndex        =   98
      Top             =   1440
      Width           =   1215
      Begin VB.OptionButton HIDRadioOpt 
         Caption         =   "HID"
         Height          =   255
         Left            =   120
         TabIndex        =   100
         Top             =   240
         Value           =   -1  'True
         Width           =   735
      End
      Begin VB.OptionButton CypressRadioOpt 
         Caption         =   "Cypress"
         Height          =   255
         Left            =   120
         TabIndex        =   99
         Top             =   480
         Width           =   855
      End
   End
   Begin VB.CommandButton EditSCPFileButton 
      Caption         =   "Edit SCP File"
      Height          =   615
      Left            =   8280
      TabIndex        =   88
      Top             =   720
      Width           =   855
   End
   Begin VB.CheckBox LogToFile 
      Caption         =   "Log To File"
      Height          =   255
      Left            =   8040
      TabIndex        =   80
      Top             =   4560
      Width           =   1215
   End
   Begin VB.CommandButton OpenSCPFile 
      Caption         =   "Open SCP File"
      Height          =   375
      Left            =   7920
      TabIndex        =   76
      Top             =   120
      Width           =   1215
   End
   Begin VB.Timer DataLoggingTimer 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   8040
      Top             =   5040
   End
   Begin VB.Timer AutoUpdateStatusTimer 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   8520
      Top             =   5040
   End
   Begin VB.Timer DelayTimer 
      Enabled         =   0   'False
      Interval        =   40
      Left            =   8880
      Top             =   5040
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   8760
      Top             =   2520
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin TabDlg.SSTab SSTab1 
      Height          =   4455
      Left            =   120
      TabIndex        =   5
      Top             =   600
      Width           =   7845
      _ExtentX        =   13838
      _ExtentY        =   7858
      _Version        =   393216
      Tabs            =   6
      Tab             =   1
      TabsPerRow      =   6
      TabHeight       =   838
      BackColor       =   -2147483644
      TabCaption(0)   =   "UsagePage: Usage"
      TabPicture(0)   =   "frmMain.frx":1DAE
      Tab(0).ControlEnabled=   0   'False
      Tab(0).Control(0)=   "Frame2"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "Frame10"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).ControlCount=   2
      TabCaption(1)   =   "ReportID"
      TabPicture(1)   =   "frmMain.frx":1DCA
      Tab(1).ControlEnabled=   -1  'True
      Tab(1).Control(0)=   "fraBytesToSend"
      Tab(1).Control(0).Enabled=   0   'False
      Tab(1).ControlCount=   1
      TabCaption(2)   =   "Ram Access"
      TabPicture(2)   =   "frmMain.frx":1DE6
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "Frame3"
      Tab(2).ControlCount=   1
      TabCaption(3)   =   "NVR import/export"
      TabPicture(3)   =   "frmMain.frx":1E02
      Tab(3).ControlEnabled=   0   'False
      Tab(3).Control(0)=   "CoolFlex1"
      Tab(3).Control(1)=   "CpyNVRToClip"
      Tab(3).Control(2)=   "Frame8"
      Tab(3).Control(3)=   "Frame7"
      Tab(3).Control(4)=   "ClearNVRBuffer"
      Tab(3).Control(5)=   "ImportNVRButton"
      Tab(3).Control(6)=   "ExportNVRButton"
      Tab(3).Control(7)=   "Label11"
      Tab(3).ControlCount=   8
      TabCaption(4)   =   "Scripting"
      TabPicture(4)   =   "frmMain.frx":1E1E
      Tab(4).ControlEnabled=   0   'False
      Tab(4).Control(0)=   "Label17"
      Tab(4).Control(1)=   "UpdateUPSStatusButton"
      Tab(4).Control(2)=   "AutoUpdateUPSStatusButton"
      Tab(4).Control(3)=   "ScriptsComboBox"
      Tab(4).Control(4)=   "RunScriptButton"
      Tab(4).Control(5)=   "StatusPollingRateTextBox"
      Tab(4).Control(6)=   "LogToResultsCheckBox"
      Tab(4).Control(7)=   "RunAllScripts"
      Tab(4).Control(8)=   "UPSStatusListBox"
      Tab(4).Control(9)=   "AbortScriptButton"
      Tab(4).ControlCount=   10
      TabCaption(5)   =   "Logging"
      TabPicture(5)   =   "frmMain.frx":1E3A
      Tab(5).ControlEnabled=   0   'False
      Tab(5).Control(0)=   "SelectRamLogItem(4)"
      Tab(5).Control(1)=   "SelectRamLogItem(3)"
      Tab(5).Control(2)=   "SelectRamLogItem(2)"
      Tab(5).Control(3)=   "SelectRamLogItem(1)"
      Tab(5).Control(4)=   "SelectRamLogItem(0)"
      Tab(5).Control(5)=   "LogFileNotesField"
      Tab(5).Control(6)=   "MeterLogEnableCheckbox(2)"
      Tab(5).Control(7)=   "MeterLogEnableCheckbox(1)"
      Tab(5).Control(8)=   "MeterLogComPort(2)"
      Tab(5).Control(9)=   "MeterLogComPort(1)"
      Tab(5).Control(10)=   "ItemNamesTextBox(7)"
      Tab(5).Control(11)=   "MeterLogEnableCheckbox(0)"
      Tab(5).Control(12)=   "MeterLogComPort(0)"
      Tab(5).Control(13)=   "ItemNamesTextBox(6)"
      Tab(5).Control(14)=   "ItemNamesTextBox(5)"
      Tab(5).Control(15)=   "ItemsTextBox(4)"
      Tab(5).Control(16)=   "ItemsTextBox(3)"
      Tab(5).Control(17)=   "ItemsTextBox(2)"
      Tab(5).Control(18)=   "ItemsTextBox(1)"
      Tab(5).Control(19)=   "LogIntervalTextBox"
      Tab(5).Control(20)=   "ItemNamesTextBox(4)"
      Tab(5).Control(21)=   "ItemNamesTextBox(3)"
      Tab(5).Control(22)=   "ItemNamesTextBox(2)"
      Tab(5).Control(23)=   "ItemNamesTextBox(1)"
      Tab(5).Control(24)=   "ItemNamesTextBox(0)"
      Tab(5).Control(25)=   "StartLoggingButton"
      Tab(5).Control(26)=   "ItemsTextBox(0)"
      Tab(5).Control(27)=   "Label24"
      Tab(5).Control(28)=   "Label23"
      Tab(5).Control(29)=   "Label22"
      Tab(5).Control(30)=   "Label21"
      Tab(5).Control(31)=   "Label20"
      Tab(5).Control(32)=   "Label14"
      Tab(5).Control(33)=   "Label13"
      Tab(5).Control(34)=   "Label12"
      Tab(5).ControlCount=   35
      Begin VB.CommandButton AbortScriptButton 
         Caption         =   "Abort Script"
         Height          =   255
         Left            =   -69480
         TabIndex        =   136
         ToolTipText     =   "Requires script to check AbortScript and exit if it is true."
         Top             =   720
         Width           =   1335
      End
      Begin HID_SUITE.CoolFlex CoolFlex1 
         Height          =   3615
         Left            =   -70920
         TabIndex        =   134
         Top             =   720
         Width           =   3615
         _ExtentX        =   6376
         _ExtentY        =   6376
      End
      Begin VB.ListBox UPSStatusListBox 
         Height          =   2400
         ItemData        =   "frmMain.frx":1E56
         Left            =   -74880
         List            =   "frmMain.frx":1E58
         TabIndex        =   133
         Top             =   1080
         Width           =   7575
      End
      Begin VB.CommandButton SelectRamLogItem 
         Height          =   255
         Index           =   4
         Left            =   -67440
         TabIndex        =   132
         ToolTipText     =   "Select Ram location to read"
         Top             =   2280
         Width           =   135
      End
      Begin VB.CommandButton SelectRamLogItem 
         Height          =   255
         Index           =   3
         Left            =   -67440
         TabIndex        =   131
         ToolTipText     =   "Select Ram location to read"
         Top             =   1920
         Width           =   135
      End
      Begin VB.CommandButton SelectRamLogItem 
         Height          =   255
         Index           =   2
         Left            =   -67440
         TabIndex        =   130
         ToolTipText     =   "Select Ram location to read"
         Top             =   1560
         Width           =   135
      End
      Begin VB.CommandButton SelectRamLogItem 
         Height          =   255
         Index           =   1
         Left            =   -67440
         TabIndex        =   129
         ToolTipText     =   "Select Ram location to read"
         Top             =   1200
         Width           =   135
      End
      Begin VB.CommandButton SelectRamLogItem 
         Height          =   255
         Index           =   0
         Left            =   -67440
         TabIndex        =   128
         ToolTipText     =   "Select Ram location to read"
         Top             =   840
         Width           =   135
      End
      Begin VB.TextBox LogFileNotesField 
         Height          =   2175
         Left            =   -74880
         MultiLine       =   -1  'True
         TabIndex        =   125
         Top             =   1680
         Width           =   1575
      End
      Begin VB.CheckBox MeterLogEnableCheckbox 
         Caption         =   "Enable"
         Height          =   255
         Index           =   2
         Left            =   -70320
         TabIndex        =   117
         Top             =   3600
         Width           =   975
      End
      Begin VB.CheckBox MeterLogEnableCheckbox 
         Caption         =   "Enable"
         Height          =   255
         Index           =   1
         Left            =   -70320
         TabIndex        =   116
         Top             =   3240
         Width           =   975
      End
      Begin VB.TextBox MeterLogComPort 
         Height          =   285
         Index           =   2
         Left            =   -71040
         TabIndex        =   115
         Text            =   "3"
         Top             =   3600
         Width           =   495
      End
      Begin VB.TextBox MeterLogComPort 
         Height          =   285
         Index           =   1
         Left            =   -71040
         TabIndex        =   114
         Text            =   "2"
         Top             =   3240
         Width           =   495
      End
      Begin VB.TextBox ItemNamesTextBox 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   7
         Left            =   -73080
         TabIndex        =   112
         Text            =   "Current"
         Top             =   3600
         Width           =   975
      End
      Begin VB.CheckBox MeterLogEnableCheckbox 
         Caption         =   "Enable"
         Height          =   255
         Index           =   0
         Left            =   -70320
         TabIndex        =   111
         Top             =   2880
         Width           =   975
      End
      Begin VB.TextBox MeterLogComPort 
         Height          =   285
         Index           =   0
         Left            =   -71040
         TabIndex        =   108
         Text            =   "1"
         Top             =   2880
         Width           =   495
      End
      Begin VB.TextBox ItemNamesTextBox 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   6
         Left            =   -73080
         TabIndex        =   106
         Text            =   "VAC"
         Top             =   3240
         Width           =   975
      End
      Begin VB.TextBox ItemNamesTextBox 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   5
         Left            =   -73080
         TabIndex        =   105
         Text            =   "Vbatt"
         Top             =   2880
         Width           =   975
      End
      Begin VB.CommandButton CpyNVRToClip 
         Caption         =   "Copy Table to Clipboard (Hex)"
         Height          =   615
         Left            =   -72360
         TabIndex        =   97
         Top             =   1320
         Width           =   1335
      End
      Begin VB.Frame Frame10 
         Caption         =   "Cypress based communications (old usb)"
         Height          =   1215
         Left            =   -74880
         TabIndex        =   90
         Top             =   3120
         Width           =   7575
         Begin VB.CheckBox AutoAddChksumCheckBox 
            Caption         =   "Automatically add checksum and [CR]"
            Height          =   375
            Left            =   4800
            TabIndex        =   96
            Top             =   720
            Width           =   2175
         End
         Begin VB.CheckBox CypressCmdInAscii 
            Caption         =   "Issue command in Ascii (like UPSTester)"
            Height          =   375
            Left            =   4800
            TabIndex        =   95
            Top             =   240
            Value           =   1  'Checked
            Width           =   2055
         End
         Begin VB.CommandButton SendOldCommand 
            Caption         =   "Send Command"
            Height          =   495
            Left            =   2880
            TabIndex        =   94
            Top             =   600
            Width           =   975
         End
         Begin VB.CommandButton GetInputButton 
            Caption         =   "Get Input"
            Height          =   495
            Left            =   3960
            TabIndex        =   93
            Top             =   600
            Width           =   735
         End
         Begin VB.Frame CypressCmdFrame 
            Caption         =   "Command (Ascii)"
            Height          =   735
            Left            =   120
            TabIndex        =   91
            Top             =   360
            Width           =   2535
            Begin VB.TextBox OldCommandTextBox 
               Height          =   375
               Left            =   120
               TabIndex        =   92
               Top             =   240
               Width           =   2295
            End
         End
      End
      Begin VB.CommandButton RunAllScripts 
         Caption         =   "Run All Scripts"
         Height          =   495
         Left            =   -68160
         TabIndex        =   89
         Top             =   3720
         Width           =   855
      End
      Begin VB.CheckBox LogToResultsCheckBox 
         Caption         =   "Log to Results List"
         Height          =   255
         Left            =   -70080
         TabIndex        =   83
         Top             =   3840
         Width           =   1695
      End
      Begin VB.TextBox StatusPollingRateTextBox 
         Height          =   285
         Left            =   -71160
         TabIndex        =   81
         Text            =   "1"
         Top             =   3840
         Width           =   735
      End
      Begin VB.Frame Frame8 
         Height          =   615
         Left            =   -72600
         TabIndex        =   73
         Top             =   600
         Width           =   1215
         Begin VB.OptionButton NVRRadioOpt 
            Caption         =   "NVR"
            Height          =   195
            Left            =   120
            TabIndex        =   75
            Top             =   120
            Value           =   -1  'True
            Width           =   975
         End
         Begin VB.OptionButton RAMRadioOpt 
            Caption         =   "RAM"
            Height          =   195
            Left            =   120
            TabIndex        =   74
            Top             =   360
            Width           =   975
         End
      End
      Begin VB.TextBox ItemsTextBox 
         Height          =   285
         Index           =   4
         Left            =   -72000
         TabIndex        =   72
         Top             =   2280
         Width           =   4455
      End
      Begin VB.TextBox ItemsTextBox 
         Height          =   285
         Index           =   3
         Left            =   -72000
         TabIndex        =   71
         Top             =   1920
         Width           =   4455
      End
      Begin VB.TextBox ItemsTextBox 
         Height          =   285
         Index           =   2
         Left            =   -72000
         TabIndex        =   70
         Top             =   1560
         Width           =   4455
      End
      Begin VB.TextBox ItemsTextBox 
         Height          =   285
         Index           =   1
         Left            =   -72000
         TabIndex        =   69
         Top             =   1200
         Width           =   4455
      End
      Begin VB.TextBox LogIntervalTextBox 
         Height          =   285
         Left            =   -73320
         TabIndex        =   66
         Text            =   "1"
         Top             =   4080
         Width           =   855
      End
      Begin VB.TextBox ItemNamesTextBox 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   4
         Left            =   -73080
         TabIndex        =   63
         Text            =   "Item5"
         Top             =   2280
         Width           =   975
      End
      Begin VB.TextBox ItemNamesTextBox 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   3
         Left            =   -73080
         TabIndex        =   62
         Text            =   "Item4"
         Top             =   1920
         Width           =   975
      End
      Begin VB.TextBox ItemNamesTextBox 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   2
         Left            =   -73080
         TabIndex        =   61
         Text            =   "Item3"
         Top             =   1560
         Width           =   975
      End
      Begin VB.TextBox ItemNamesTextBox 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   1
         Left            =   -73080
         TabIndex        =   60
         Text            =   "Item2"
         Top             =   1200
         Width           =   975
      End
      Begin VB.TextBox ItemNamesTextBox 
         BackColor       =   &H80000004&
         Height          =   285
         Index           =   0
         Left            =   -73080
         TabIndex        =   59
         Text            =   "Item1"
         Top             =   840
         Width           =   975
      End
      Begin VB.CommandButton StartLoggingButton 
         Caption         =   "Start Logging"
         Height          =   495
         Left            =   -74880
         TabIndex        =   58
         Top             =   720
         Width           =   1455
      End
      Begin VB.TextBox ItemsTextBox 
         Height          =   285
         Index           =   0
         Left            =   -72000
         TabIndex        =   68
         Top             =   840
         Width           =   4455
      End
      Begin VB.CommandButton RunScriptButton 
         Caption         =   "Run Script"
         Height          =   255
         Left            =   -71520
         TabIndex        =   57
         Top             =   720
         Width           =   1095
      End
      Begin VB.ComboBox ScriptsComboBox 
         Height          =   315
         Left            =   -74880
         TabIndex        =   56
         Top             =   720
         Width           =   3255
      End
      Begin VB.CommandButton AutoUpdateUPSStatusButton 
         Caption         =   "Continuous Status"
         Height          =   495
         Left            =   -73800
         TabIndex        =   55
         Top             =   3720
         Width           =   975
      End
      Begin VB.CommandButton UpdateUPSStatusButton 
         Caption         =   "Get Status"
         Height          =   495
         Left            =   -74880
         TabIndex        =   53
         Top             =   3720
         Width           =   975
      End
      Begin VB.Frame Frame7 
         Caption         =   "Read/Write NVR or RAM"
         Height          =   1695
         Left            =   -74880
         TabIndex        =   46
         Top             =   2040
         Width           =   3375
         Begin VB.CommandButton AbortButton 
            Caption         =   "Abort"
            Height          =   255
            Left            =   2400
            TabIndex        =   101
            Top             =   1320
            Width           =   855
         End
         Begin VB.TextBox StartNVRAddressTextBox 
            Height          =   375
            Left            =   120
            TabIndex        =   47
            Text            =   "0"
            Top             =   480
            Width           =   1335
         End
         Begin VB.TextBox EndNVRAddressTextBox 
            Height          =   375
            Left            =   120
            TabIndex        =   49
            Text            =   "FF"
            Top             =   1200
            Width           =   1335
         End
         Begin VB.CommandButton ReadRangeNVRButton 
            Caption         =   "Read NVR/RAM"
            Height          =   375
            Left            =   1800
            TabIndex        =   51
            Top             =   480
            Width           =   1455
         End
         Begin VB.CommandButton WriteRangeNVRButton 
            Caption         =   "Write NVR/RAM"
            Height          =   375
            Left            =   1800
            TabIndex        =   52
            Top             =   840
            Width           =   1455
         End
         Begin VB.Label Label9 
            Caption         =   "Start Address (Hex)"
            Height          =   255
            Left            =   120
            TabIndex        =   50
            Top             =   240
            Width           =   1575
         End
         Begin VB.Label Label10 
            Caption         =   "End Address (Hex)"
            Height          =   255
            Left            =   120
            TabIndex        =   48
            Top             =   960
            Width           =   1575
         End
      End
      Begin VB.CommandButton ClearNVRBuffer 
         Caption         =   "Clear NVR/RAM Buffer"
         Height          =   375
         Left            =   -74880
         TabIndex        =   45
         Top             =   1500
         Width           =   2175
      End
      Begin VB.CommandButton ImportNVRButton 
         Caption         =   "Import NVR/RAM from File"
         Height          =   375
         Left            =   -74880
         TabIndex        =   43
         Top             =   540
         Width           =   2175
      End
      Begin VB.CommandButton ExportNVRButton 
         Caption         =   "Export NVR/RAM to File"
         Height          =   375
         Left            =   -74880
         TabIndex        =   42
         Top             =   1020
         Width           =   2175
      End
      Begin VB.Frame Frame3 
         Caption         =   "Production Test"
         Height          =   3735
         Left            =   -74880
         TabIndex        =   33
         Top             =   600
         Width           =   7455
         Begin HID_SUITE.CoolFlex CoolFlex2 
            Height          =   1815
            Left            =   120
            TabIndex        =   135
            Top             =   1800
            Width           =   4935
            _ExtentX        =   8705
            _ExtentY        =   3201
         End
         Begin VB.CommandButton RemoveCheckedSymbols 
            Caption         =   "Remove Checked"
            Height          =   255
            Left            =   5280
            TabIndex        =   124
            Top             =   2040
            Width           =   2055
         End
         Begin VB.CommandButton WriteAllRamButton 
            Caption         =   "Write checked locations"
            Height          =   375
            Left            =   5280
            TabIndex        =   123
            Top             =   2520
            Width           =   2055
         End
         Begin VB.CommandButton AddSymbolButton 
            Caption         =   "Add Item"
            Height          =   255
            Left            =   6120
            TabIndex        =   121
            Top             =   1680
            Width           =   1215
         End
         Begin VB.CommandButton LoadMapFile 
            Caption         =   "Load Map File"
            Height          =   255
            Left            =   6000
            TabIndex        =   120
            Top             =   480
            Width           =   1215
         End
         Begin VB.ComboBox SymbolListComboBox 
            Height          =   315
            Left            =   4800
            TabIndex        =   118
            Text            =   "Combo1"
            Top             =   1320
            Width           =   2535
         End
         Begin VB.CommandButton ReadAllRamButton 
            Caption         =   "Read all ram locations"
            Height          =   375
            Left            =   5280
            TabIndex        =   103
            Top             =   3120
            Width           =   2055
         End
         Begin VB.CheckBox PageRamCheckBox 
            Caption         =   "Use Page RAM Read/Write"
            Height          =   255
            Left            =   120
            TabIndex        =   41
            Top             =   1560
            Width           =   3135
         End
         Begin VB.CommandButton WriteRamButton 
            Caption         =   "Write Value"
            Height          =   375
            Left            =   3360
            TabIndex        =   38
            Top             =   600
            Width           =   1215
         End
         Begin VB.CommandButton ReadRamButton 
            Caption         =   "Read Value"
            Height          =   375
            Left            =   3360
            TabIndex        =   37
            Top             =   1080
            Width           =   1215
         End
         Begin VB.TextBox RAMDataTextBox 
            Height          =   375
            Left            =   1680
            TabIndex        =   36
            Top             =   1080
            Width           =   1455
         End
         Begin VB.CommandButton WritePasswordButton 
            Caption         =   "Write Password"
            Height          =   375
            Left            =   120
            TabIndex        =   34
            Top             =   360
            Width           =   1575
         End
         Begin VB.TextBox RAMAddressTextBox 
            Height          =   375
            Left            =   120
            TabIndex        =   35
            Top             =   1080
            Width           =   1455
         End
         Begin VB.Label MapFileNameLabel 
            Caption         =   "Map File Name"
            BeginProperty Font 
               Name            =   "Small Fonts"
               Size            =   6.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   495
            Left            =   4800
            TabIndex        =   119
            Top             =   840
            Width           =   2535
         End
         Begin VB.Label Label8 
            Caption         =   "Ram Data"
            Height          =   255
            Left            =   1680
            TabIndex        =   40
            Top             =   840
            Width           =   1455
         End
         Begin VB.Label Label5 
            Caption         =   "Ram Address"
            Height          =   255
            Left            =   120
            TabIndex        =   39
            Top             =   840
            Width           =   1455
         End
      End
      Begin VB.Frame Frame2 
         Caption         =   "Usage Page:Usage method"
         Height          =   2475
         Left            =   -74880
         TabIndex        =   21
         Top             =   600
         Width           =   7575
         Begin VB.CommandButton GetEnumInfoButton 
            Caption         =   "Get EnumInfo"
            Height          =   255
            Left            =   1920
            TabIndex        =   139
            Top             =   1560
            Width           =   1215
         End
         Begin VB.CommandButton ShowAllEnumInfoButton 
            Caption         =   "Get All Enum Info"
            Height          =   495
            Left            =   1920
            TabIndex        =   138
            Top             =   1920
            Width           =   975
         End
         Begin VB.CommandButton GetAllUsages 
            Caption         =   "Get All Usages"
            Height          =   495
            Left            =   1080
            TabIndex        =   127
            Top             =   1920
            Width           =   735
         End
         Begin VB.CommandButton ShowAllUsages 
            Caption         =   "Show All Usages"
            Height          =   495
            Left            =   120
            TabIndex        =   104
            Top             =   1920
            Width           =   855
         End
         Begin VB.TextBox ReportIDUsageTextBox 
            Height          =   285
            Left            =   5520
            TabIndex        =   79
            Text            =   "0"
            Top             =   1200
            Width           =   615
         End
         Begin VB.CommandButton GetLinkCollections 
            Caption         =   "Get LinkCollections"
            Height          =   255
            Left            =   120
            TabIndex        =   54
            Top             =   1560
            Width           =   1575
         End
         Begin VB.CommandButton GetFeatureUIDButton 
            Caption         =   "Read"
            Height          =   375
            Left            =   4560
            TabIndex        =   30
            Top             =   720
            Width           =   1575
         End
         Begin VB.Frame Frame4 
            Caption         =   "Usage"
            Height          =   735
            Left            =   1560
            TabIndex        =   26
            Top             =   240
            Width           =   1215
            Begin VB.TextBox UsageTextBox 
               Height          =   375
               Left            =   120
               TabIndex        =   25
               Text            =   "d6"
               Top             =   240
               Width           =   975
            End
         End
         Begin VB.Frame Frame5 
            Caption         =   "UsagePage"
            Height          =   735
            Left            =   120
            TabIndex        =   23
            Top             =   240
            Width           =   1335
            Begin VB.TextBox UsagePageTextBox 
               Height          =   375
               Left            =   120
               TabIndex        =   24
               Text            =   "ffff"
               Top             =   240
               Width           =   1095
            End
         End
         Begin VB.Frame Frame6 
            Caption         =   "Value (Hex)"
            Height          =   735
            Left            =   2880
            TabIndex        =   22
            Top             =   240
            Width           =   1575
            Begin VB.TextBox SetValueTextBox 
               Height          =   375
               Left            =   120
               TabIndex        =   27
               Top             =   240
               Width           =   1335
            End
         End
         Begin VB.TextBox LinkCollectionTextBox 
            Height          =   285
            Left            =   5520
            TabIndex        =   32
            Text            =   "0"
            Top             =   1560
            Width           =   615
         End
         Begin VB.CommandButton SetFeatureUIDButton 
            Caption         =   "Write"
            Height          =   375
            Left            =   4560
            TabIndex        =   28
            Top             =   240
            Width           =   1575
         End
         Begin VB.CheckBox UseScaledCheckBox 
            Caption         =   "Use Scaled Read/Write"
            Height          =   255
            Left            =   120
            TabIndex        =   31
            Top             =   1200
            Width           =   2895
         End
         Begin VB.Label Label16 
            Caption         =   "ReportID"
            Height          =   255
            Left            =   4320
            TabIndex        =   78
            Top             =   1200
            Width           =   1095
         End
         Begin VB.Label Label15 
            Caption         =   "(0 means unspecified value for ReportID and LinkCollection)"
            Height          =   495
            Left            =   4320
            TabIndex        =   77
            Top             =   1920
            Width           =   2295
         End
         Begin VB.Label Label6 
            Caption         =   "LinkCollection"
            Height          =   255
            Left            =   4320
            TabIndex        =   29
            Top             =   1560
            Width           =   1095
         End
      End
      Begin VB.Frame fraBytesToSend 
         Caption         =   "HID Queries (Report ID method)"
         Height          =   3375
         Left            =   120
         TabIndex        =   6
         Top             =   600
         Width           =   7455
         Begin VB.CommandButton ShowAllInputs 
            Caption         =   "Show All Inputs"
            Height          =   255
            Left            =   5400
            TabIndex        =   137
            Top             =   960
            Width           =   1455
         End
         Begin VB.CommandButton GetInputReportButton 
            Caption         =   "Get Input Report (sequential)"
            Height          =   495
            Left            =   4800
            TabIndex        =   102
            Top             =   1920
            Width           =   1815
         End
         Begin VB.CommandButton GetStringReportButton 
            Caption         =   "Get String Report"
            Height          =   375
            Left            =   1680
            TabIndex        =   86
            Top             =   2640
            Width           =   1575
         End
         Begin VB.TextBox GetStringReportID 
            Height          =   375
            Left            =   120
            TabIndex        =   84
            Text            =   "40"
            Top             =   2640
            Width           =   1335
         End
         Begin VB.CommandButton GetIndexedStringButton 
            Caption         =   "Get Indexed String"
            Height          =   375
            Left            =   1680
            TabIndex        =   14
            Top             =   1920
            Width           =   1575
         End
         Begin VB.TextBox StringIndexTextBox 
            Height          =   375
            Left            =   120
            TabIndex        =   12
            Text            =   "1"
            Top             =   1920
            Width           =   1335
         End
         Begin VB.TextBox ReportIDInputTextBox 
            Height          =   405
            Left            =   4440
            TabIndex        =   16
            Text            =   "50"
            Top             =   480
            Width           =   735
         End
         Begin VB.TextBox SetData 
            Height          =   375
            Left            =   1560
            TabIndex        =   10
            Top             =   1200
            Width           =   1455
         End
         Begin VB.TextBox ReportIDSet 
            Height          =   375
            Left            =   120
            TabIndex        =   9
            Text            =   "153"
            Top             =   1200
            Width           =   1335
         End
         Begin VB.TextBox ReportIDGet 
            Height          =   375
            Left            =   120
            TabIndex        =   7
            Text            =   "155"
            Top             =   480
            Width           =   1335
         End
         Begin VB.CommandButton SetFeatureButton 
            Caption         =   "SetFeature"
            Height          =   375
            Left            =   3120
            TabIndex        =   11
            Top             =   1200
            Width           =   1695
         End
         Begin VB.CommandButton GetFButton 
            Caption         =   "GetFeature"
            Height          =   375
            Left            =   1560
            TabIndex        =   8
            Top             =   480
            Width           =   1575
         End
         Begin VB.CommandButton GetInputRptButton 
            Caption         =   "GetInput Report"
            Height          =   375
            Left            =   5400
            TabIndex        =   18
            Top             =   480
            Width           =   1455
         End
         Begin VB.Label Label19 
            Caption         =   "(This just gets the value of the reportID, then does a GetIndexedString of that value)"
            Height          =   495
            Left            =   3360
            TabIndex        =   87
            Top             =   2640
            Width           =   3255
         End
         Begin VB.Label Label18 
            Caption         =   "ReportID"
            Height          =   255
            Left            =   120
            TabIndex        =   85
            Top             =   2400
            Width           =   1215
         End
         Begin VB.Label Label4 
            Caption         =   "StringIndex"
            Height          =   255
            Left            =   120
            TabIndex        =   20
            Top             =   1680
            Width           =   1335
         End
         Begin VB.Label Label7 
            Caption         =   "ReportID"
            Height          =   255
            Left            =   4440
            TabIndex        =   19
            Top             =   240
            Width           =   1215
         End
         Begin VB.Label Label3 
            Caption         =   "Data (Hex)"
            Height          =   255
            Left            =   1560
            TabIndex        =   17
            Top             =   960
            Width           =   1095
         End
         Begin VB.Label Label2 
            Caption         =   "Report ID"
            Height          =   255
            Left            =   120
            TabIndex        =   15
            Top             =   960
            Width           =   1095
         End
         Begin VB.Label Label1 
            Caption         =   "Report ID"
            Height          =   255
            Left            =   120
            TabIndex        =   13
            Top             =   240
            Width           =   1335
         End
      End
      Begin VB.Label Label24 
         Caption         =   "Log Notes:"
         Height          =   255
         Left            =   -74880
         TabIndex        =   126
         Top             =   1440
         Width           =   1455
      End
      Begin VB.Label Label23 
         Caption         =   "Comm Port"
         Height          =   255
         Left            =   -72000
         TabIndex        =   113
         Top             =   3600
         Width           =   855
      End
      Begin VB.Label Label22 
         Caption         =   "Comm Port"
         Height          =   255
         Left            =   -72000
         TabIndex        =   110
         Top             =   3240
         Width           =   855
      End
      Begin VB.Label Label21 
         Caption         =   "Comm Port"
         Height          =   255
         Left            =   -72000
         TabIndex        =   109
         Top             =   2880
         Width           =   855
      End
      Begin VB.Label Label20 
         Caption         =   "Data from meters:"
         Height          =   255
         Left            =   -73080
         TabIndex        =   107
         Top             =   2640
         Width           =   3735
      End
      Begin VB.Label Label17 
         Caption         =   "Update Interval (S)"
         Height          =   375
         Left            =   -72720
         TabIndex        =   82
         Top             =   3840
         Width           =   1455
      End
      Begin VB.Label Label14 
         Caption         =   "Log Interval (S)"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   -74880
         TabIndex        =   67
         Top             =   4080
         Width           =   1455
      End
      Begin VB.Label Label13 
         Caption         =   "Formulas"
         Height          =   255
         Left            =   -72000
         TabIndex        =   65
         Top             =   600
         Width           =   1695
      End
      Begin VB.Label Label12 
         Caption         =   "Item Names"
         Height          =   255
         Left            =   -73080
         TabIndex        =   64
         Top             =   600
         Width           =   975
      End
      Begin VB.Label Label11 
         Caption         =   "NVR / RAM Values (Hex)"
         Height          =   255
         Left            =   -70920
         TabIndex        =   44
         Top             =   540
         Width           =   2295
      End
   End
   Begin VB.CommandButton ClearResultsButton 
      Caption         =   "Clear Results"
      Height          =   375
      Left            =   8040
      TabIndex        =   2
      Top             =   3120
      Width           =   1215
   End
   Begin VB.CommandButton ResToClipboardButton 
      Caption         =   "Copy Results to Clipboard"
      Height          =   495
      Left            =   8040
      TabIndex        =   3
      Top             =   3720
      Width           =   1215
   End
   Begin VB.CommandButton ClosePort 
      Caption         =   "Close"
      Height          =   375
      Left            =   1680
      TabIndex        =   1
      Top             =   120
      Width           =   1215
   End
   Begin VB.CommandButton Open 
      Caption         =   "Open"
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
   Begin VB.Timer ScrollDownTimer 
      Enabled         =   0   'False
      Interval        =   50
      Left            =   8280
      Top             =   5040
   End
   Begin VB.Timer tmrDelay 
      Enabled         =   0   'False
      Left            =   120
      Top             =   11400
   End
   Begin VB.ListBox lstResults 
      Height          =   2205
      Left            =   120
      TabIndex        =   4
      Top             =   5160
      Width           =   9015
   End
   Begin VB.Label SCPFileNameLabel 
      Caption         =   "SCP FileName"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   3840
      TabIndex        =   122
      Top             =   120
      Width           =   3975
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Option Base 0

Const DebugMode As Boolean = False

    'Private Const DLAY_BETWEEN_CMDS = 100
    Private Const DLAY_BETWEEN_CMDS = 30

'About overlapped I/O
'
'Reading HID Input reports is done with the API function ReadFile.
'Non-overlapped ReadFile is a blocking call. If the device doesn't return the
'expected amount of data, the application hangs and waits endlessly.
'
'With overlapped I/O, the call to ReadFile returns immediately. The application uses
'WaitForSingleObject to be notified either that the data has arrived or that a timeout
'has occurred.
'WaitForSingleObject blocks the application thread but specifies a timeout value so the
'application's thread isn't blocked forever.
'
'This application has been tested on Windows 98 SE, Windows 2000, and Windows XP.

Private Type HIDIOTYPE
    Security As SECURITY_ATTRIBUTES
    Capabilities As HIDP_CAPS
    TotalNumberOfFeatureCaps As Integer
    FeatureCaps(255) As HIDP_VALUE_CAPS     'A feasible limit..
    InputCaps(255) As HIDP_VALUE_CAPS
    EventObject As Long
    HIDHandle As Long
    ReadHandle As Long
    PreparsedDataPtr As Long
    HIDOverlapped As OVERLAPPED         'for reading overlapped input reports.
End Type

Public MinDelayBetweenCmds As Integer
Dim Hidio As HIDIOTYPE
Public SCPFileName As String
Dim AutoUpdateUPSStatus As Boolean
Dim LogFile As Object
Dim LogFileOpen As Boolean
Dim SCPEditor As String
Dim SCPPath As String
Dim SymbolFile As String
Public WrittenData As String
Dim LogResultsEnabled As Boolean
Dim AbortFunction As Boolean
Dim QuietMode As Boolean
Public AbortScript As Boolean

Private Sub AbortButton_Click()
    AbortFunction = True
End Sub

Private Sub AbortScriptButton_Click()
    'Err.Raise 1
'    sc1.State = Connected
'    sc1.ERROR = 5
'    sc1.Timeout = 1
'    sc1.Reset
'    sc1.ExecuteStatement "QuitScript"

    AbortScript = True
End Sub

Private Sub AddSymbolButton_Click()
    Dim Row As Integer
    Dim i As Integer
    Dim symbolentered As String
    
    If DebugMode <> True Then: On Error GoTo errorhandler:
    
    symbolentered = LCase(SymbolListComboBox.Text)
'sort through the combobox to find the closest match
    For Row = 0 To SymbolListComboBox.ListCount - 1
        SymbolListComboBox.ListIndex = Row
        i = InStr(1, LCase(SymbolListComboBox.Text), symbolentered)
        If i = 1 Then
            GoTo FoundSymbol
        End If
    Next
    
FoundSymbol:
    If i = 0 Then
        Exit Sub
    End If

    'find first blank cell and fill it in
    Row = 1
    Do
        'Check for no character at beginning of line:
        If CoolFlex2.TextMatrix(Row, 0) = "" And CoolFlex2.TextMatrix(Row, 1) = "" Then
            CoolFlex2.TextMatrix(Row, 0) = SymbolListComboBox.Text
            CoolFlex2.TextMatrix(Row, 1) = D2H(SymbolListComboBox.ItemData(SymbolListComboBox.ListIndex))
            GoTo ENDSSUB
        End If
        Row = Row + 1
    Loop

ENDSSUB:
    Exit Sub
    
errorhandler:
    LogResults "Error: there is something wrong with what you entered"
End Sub

Public Function GetSymbolAddress(Symbol As String) As String
    Dim symbolentered As String
    Dim i As Integer
    Dim Row As Integer
    Dim previousText As String
    Dim previousindex As String
    
    previousindex = SymbolListComboBox.ListIndex
    previousText = SymbolListComboBox.Text
    
    symbolentered = LCase(Symbol)
'sort through the combobox to find the closest match
    For Row = 0 To SymbolListComboBox.ListCount - 1
        SymbolListComboBox.ListIndex = Row
        i = InStr(1, LCase(SymbolListComboBox.Text), symbolentered)
        If i = 1 Then
            GoTo FoundSymbol
        End If
    Next

FoundSymbol:
    If i = 0 Then
        GetSymbolAddress = "-1"
        Exit Function
    End If

    GetSymbolAddress = D2H(SymbolListComboBox.ItemData(SymbolListComboBox.ListIndex))

    SymbolListComboBox.ListIndex = previousindex
    SymbolListComboBox.Text = previousText
End Function


Private Sub AutoUpdateStatusTimer_Timer()
    If AutoUpdateUPSStatus Then
        UpdateUPSStatusButton_Click
    End If
End Sub

Private Sub AutoUpdateUPSStatusButton_Click()
    If AutoUpdateUPSStatus Then
        AutoUpdateUPSStatus = False
        AutoUpdateStatusTimer.Enabled = False
        AutoUpdateUPSStatusButton.Caption = "Auto Update"
    Else
        AutoUpdateUPSStatus = True
        AutoUpdateStatusTimer.Enabled = True
        AutoUpdateStatusTimer.Interval = StatusPollingRateTextBox.Text * 1000
        AutoUpdateUPSStatusButton.Caption = "Stop"
        LogResults "Auto Running Script: STATUS with a polling rate of " & StatusPollingRateTextBox.Text
    End If
End Sub


Private Sub ClearNVRBuffer_Click()
    CoolFlex1.Clear
    CoolFlex1.TextMatrix(0, 0) = "Addr (Hex)"
    CoolFlex1.TextMatrix(0, 1) = "Data (Hex)"
End Sub

Private Sub ClearResultsButton_Click()
    lstResults.Clear
End Sub

Private Sub ClosePort_Click()
    Dim Result As Long
    Result = CloseHandle(Hidio.HIDHandle)
    Result = CloseHandle(Hidio.ReadHandle)
    LogResults "Closed port"
End Sub

Private Sub CpyNVRToClip_Click()
    Dim cliptemp As String
    Dim Row As Integer
    Dim Address As String
    Dim OutData As String
    
    cliptemp = ""
    
    For Row = 0 To 255
        DoEvents
        If CoolFlex1.TextMatrix(Row + 1, 0) = "" Then
            Exit For                                    'exit for blank address field
        End If
        Address = FXD(CoolFlex1.TextMatrix(Row + 1, 0), 2)
        OutData = FXD(CoolFlex1.TextMatrix(Row + 1, 1), 2)
        cliptemp = cliptemp & Address & vbTab & OutData & vbCrLf
    Next Row

    Clipboard.Clear
    Clipboard.SetText cliptemp
End Sub

Private Sub CypressCmdInAscii_Click()
    If CypressCmdInAscii.Value = 1 Then
        CypressCmdFrame.Caption = "Command (Ascii)"
    Else
        CypressCmdFrame.Caption = "Command (Hex)"
    End If
End Sub

Private Sub DelayTimer_Timer()
    DelayOver = True
End Sub

Private Sub EditSCPFileButton_Click()
    Dim test As Integer
    test = Shell(VB.App.Path & "\" & SCPEditor & " " & SCPFileName, vbNormalFocus)
End Sub



Private Sub Form_Load()
    Dim i As Integer
    
    On Error Resume Next
    
    If DebugMode <> True Then: On Error GoTo errorhandler:

    'automatically select tab0 regardless of what is selected in the editor.
    SSTab1.Tab = 0

    LogResultsEnabled = True
    frmMain.Show
    tmrDelay.Enabled = False
    
    Caption = "HIDSuite" & " V" & VB.App.Major & "." & VB.App.Minor & "." & VB.App.Revision
    
    MinDelayBetweenCmds = DLAY_BETWEEN_CMDS
    
    CoolFlex1.EditEnable = True
    CoolFlex1.FixedCols = 0
    CoolFlex1.FixedRows = 1
    CoolFlex1.Rows = 257
    CoolFlex1.Cols = 2
    
    CoolFlex1.ColWidth(0) = (CoolFlex1.Width - 500) / 2
    CoolFlex1.ColWidth(1) = (CoolFlex1.Width - 500) / 2
    
    CoolFlex1.TextMatrix(0, 0) = "Addr (Hex)"
    CoolFlex1.TextMatrix(0, 1) = "Data (Hex)"
    
    
    'CoolFlex2.CellAlignment = 4     'flexAlignCenterCenter
    CoolFlex2.RecordAlignment = 4      'flexAlignCenterCenter
    
    CoolFlex2.EditEnable = True
    CoolFlex2.FixedCols = 0
    CoolFlex2.FixedRows = 1
    CoolFlex2.Rows = 257
    CoolFlex2.Cols = 4
    
    CoolFlex2.ColWidth(0) = (CoolFlex2.Width - 380) * 3 / 5
    CoolFlex2.ColWidth(1) = (CoolFlex2.Width - 380) / 5
    CoolFlex2.ColWidth(2) = (CoolFlex2.Width - 380) / 5
    
    CoolFlex2.ColWidth(0) = (CoolFlex2.Width - 370) * 6 / 10
    CoolFlex2.ColWidth(1) = (CoolFlex2.Width - 370) * (4 / 10) / 3
    CoolFlex2.ColWidth(2) = (CoolFlex2.Width - 370) * (4 / 10) / 3
    CoolFlex2.ColWidth(3) = (CoolFlex2.Width - 370) * (4 / 10) / 3
    
    CoolFlex2.TextMatrix(0, 0) = "Name"
    CoolFlex2.TextMatrix(0, 1) = "Addr (Hex)"
    CoolFlex2.TextMatrix(0, 2) = "Data (Hex)"
    CoolFlex2.TextMatrix(0, 3) = "Write?"
    
    'set column 3 to type Checkbox
    CoolFlex2.ColType 3, eCheckbox
    
    For i = 1 To 256
        CoolFlex2.TextMatrix(i, 3) = "U"
    Next i

    CoolFlex2.UpdateCheckbox 2, 3   'should update the check picture in the box
    
    SymbolFile = GetSetting("SUITESETTINGS", "SymbolFile")
    
    SymbolFile = VB.App.Path & "\" & SymbolFile
    
    GetSymbolsFromSymbolFile
    
    SCPEditor = GetSetting("SUITESETTINGS", "editor")
    SCPPath = GetSetting("SUITESETTINGS", "SCPPath")
    If SCPPath = "." Then
        SCPPath = VB.App.Path       'specify default path if . is specified
    End If
    
    SCPFileName = SCPPath & "\" & "status_3012.scp"
    
    Dim tempname As String
    tempname = Mid(SCPFileName, InStrRev(SCPFileName, "\") + 1, Len(SCPFileName) - InStrRev(SCPFileName, "\"))
    
    SCPFileNameLabel.Caption = "SCP File: " & tempname
    
    Dim FuncNames(255) As String
    
    GetFuncNames SCPFileName, FuncNames
    
    ScriptsComboBox.Clear
    
    For i = 1 To 255
        If FuncNames(i) = "" Then
            Exit For
        End If
        ScriptsComboBox.AddItem FuncNames(i)
    Next i
    
    ScriptsComboBox.ListIndex = 0
    
    ShowLogFormulas
    
    QuietMode = True
    
    Exit Sub
    
errorhandler:
    lstResults.AddItem "Error at startup"
    Exit Sub
    
    'ScriptsComboBox.Text
    
    'CoolFlex1.RecordAlignment = flexAlignCenterCenter
End Sub

Private Sub Form_Resize()
    If frmMain.Width > 9390 Then
        lstResults.Width = frmMain.Width - 375
    End If
    If frmMain.Height > 7845 Then
        lstResults.Height = frmMain.Height - 5640
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim Result As Long
    
    frmMain.DelayTimer.Enabled = False
    AutoUpdateUPSStatus = False
    AutoUpdateStatusTimer.Enabled = False
    Result = HidD_FreePreparsedData(Hidio.PreparsedDataPtr)
    Call ResetEvent(Hidio.EventObject)
    If LogFileOpen = True Then
        LogFile.Close
        LogFileOpen = False
    End If
    Result = CloseHandle(Hidio.HIDHandle)
    Result = CloseHandle(Hidio.ReadHandle)
End Sub

Private Sub GetEnumInfoButton_Click()
    Dim PreparsedData As Long
    Dim HidP_Feature As Integer
    Dim Result As Long
    Dim DataReturned As Long
    Dim RptLength As Long
    Dim UsagePage As Integer
    Dim Usage As Integer
    Dim ReportID As Integer
    Dim LinkCollection As Integer
    Dim ReportBufferLength As Integer
    Dim ReportBuffer(8) As Byte
    Dim i As Integer
    Dim LinkCollectionMatches As Boolean
    Dim ReportIDMatches As Boolean
    Dim TypeIsButton As Boolean

    Dim UName As String
    
    'On Error Resume Next

    'If DebugMode <> True Then: On Error GoTo errorhandler:
    
    If UsagePageTextBox.Text = "" Or UsageTextBox.Text = "" Then
        LogResults "Get usage id failed: Usage invalid"
        Exit Sub
    End If
    UsagePage = "&H" + UsagePageTextBox.Text
    Usage = "&H" + UsageTextBox.Text
    LinkCollection = Val(LinkCollectionTextBox.Text)

    If ReportIDUsageTextBox.Text = "" Then
        ReportID = 0
    Else
        ReportID = ReportIDUsageTextBox.Text
    End If

    For i = 0 To Hidio.TotalNumberOfFeatureCaps
        LinkCollectionMatches = False
        ReportIDMatches = False
        
        If Hidio.FeatureCaps(i).UsagePage = UsagePage Then
            If Hidio.FeatureCaps(i).Usage = Usage Then
                If LinkCollection = 0 Or Hidio.FeatureCaps(i).LinkCollection = LinkCollection Then
                    LinkCollectionMatches = True
                End If
                If ReportID = 0 Or ReportID = Hidio.FeatureCaps(i).ReportID Then
                    ReportIDMatches = True
                End If
                If ReportIDMatches And LinkCollectionMatches Then
                    ReportID = Hidio.FeatureCaps(i).ReportID
                    LinkCollection = Hidio.FeatureCaps(i).LinkCollection
                    
                    If (i < Hidio.Capabilities.NumberFeatureValueCaps) Then
                        TypeIsButton = False
                    Else
                        TypeIsButton = True
                    End If
                    
                    LogResults "All usage values"
                    UName = GetUsageName(Hidio.FeatureCaps(i).UsagePage, Hidio.FeatureCaps(i).Usage)
                    LogResults " Report ID:" & FXD(Hidio.FeatureCaps(i).ReportID, 3) & _
                    "  LinkCollection: " & Hidio.FeatureCaps(i).LinkCollection & vbTab & _
                    "0x" & Right(D2H(Hidio.FeatureCaps(i).UsagePage), 4) & _
                    ":0x" & Right(D2H(Hidio.FeatureCaps(i).Usage), 4) & _
                    "  " & UName
                    LogResults "ReportCount: " & Hidio.FeatureCaps(i).ReportCount
                    LogResults "BitSize: " & Hidio.FeatureCaps(i).BitSize
                    LogResults "BitField: " & Hidio.FeatureCaps(i).BitField
                    LogResults "LogicalMin: " & Hidio.FeatureCaps(i).LogicalMin
                    LogResults "LogicalMax: " & Hidio.FeatureCaps(i).LogicalMax
                    LogResults "PhysicalMin: " & Hidio.FeatureCaps(i).PhysicalMin
                    LogResults "PhysicalMax: " & Hidio.FeatureCaps(i).PhysicalMax
                    LogResults "Units: " & Hidio.FeatureCaps(i).Units
                    LogResults "UnitsExp: " & Hidio.FeatureCaps(i).UnitsExp
                    LogResults "IsRange: " & Hidio.FeatureCaps(i).IsRange
                    LogResults "IsStringRange: " & Hidio.FeatureCaps(i).IsStringRange
                    LogResults "IsAbsolute: " & Hidio.FeatureCaps(i).IsAbsolute
                    LogResults "StringIndex: " & Hidio.FeatureCaps(i).StringIndex
                    LogResults "ButtonType? " & TypeIsButton
                    Exit For
                End If
            End If
        End If
    Next i



End Sub

Public Sub GetIndexedStringButton_Click()
    Dim StringIndex As Long
    Dim StringBuffer(255) As Byte
    Dim tempstring As String
    Dim retval As Long

    StringIndex = StringIndexTextBox.Text
    retval = HidD_GetIndexedString(Hidio.HIDHandle, StringIndex, StringBuffer(0), 100)
    
    LogResults "GetIndexedString: " & StringIndexTextBox.Text
    tempstring = StringBuffer
    LogResults tempstring
    ScrollDown
End Sub

Public Sub ShowLogFormulas()
    'FileSystemObject must reference Microsoft Scripting Engine:
    Dim InFile As Object
    Dim fs As New FileSystemObject
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set InFile = fs.OpenTextFile(SCPFileName, 1, False, 0)

    Dim ScriptCode As String
    Dim itemnumber As Integer
    Dim charnum As Integer
    Dim FileLine As String

    itemnumber = 0
    Do While InFile.AtEndOfStream <> True
        FileLine = InFile.ReadLine
        If Mid(FileLine, 1, 12) = "BEGINLOGITEM" Then
            charnum = InStr(14, FileLine, " ")      'find any spaces
            If charnum = 0 Then
                charnum = Len(FileLine) - 12
            Else
                charnum = charnum - 13
            End If
            ItemNamesTextBox.Item(itemnumber).Text = Mid(FileLine, 14, charnum)
            
            ScriptCode = ""
            'we found an item:
            Do While InFile.AtEndOfStream <> True
                FileLine = InFile.ReadLine
                If InFile.AtEndOfStream = True Or Mid(FileLine, 1, 7) = "ENDITEM" Then
                    Exit Do
                End If
                If FileLine <> "" Then
                    ScriptCode = ScriptCode + FileLine + " :"
                End If
                ItemsTextBox.Item(itemnumber).Text = ScriptCode
            Loop
            itemnumber = itemnumber + 1
        End If
    Loop
    
    If itemnumber = 1 Then
        'MsgBox ("script not found")
        Exit Sub
    End If
End Sub

Private Sub DataLoggingTimer_Timer()
    GetLogItems
End Sub


Public Sub GetLogItems()
    Dim sc As New ScriptControl

'    sc.ExecuteStatement ScriptCode
    Dim DataLine As String
    Dim i As Integer
    
    DataLine = ""
    
    For i = 0 To 4
        On Error Resume Next
        sc.Reset
        sc.Language = "vbscript"
        sc.AddObject "frmMain", frmMain, True
        sc.AddObject "QueryForm", QueryForm, True
        
        'sc.ExecuteStatement ""
        sc.ExecuteStatement (ItemsTextBox.Item(i).Text)
        DataLine = DataLine & sc.Eval("Item") & vbTab
        
        WaitMIN_DELAY
        
'        If Err Then
'            With sc.Error
'                frmMain.lstResults.AddItem "Script Runtime Error : " & .Number & ": " & .Description & " at line " & .Line & " Column:" & .Column & " in the script."
'            End With
'        End If
    Next i
    
    Unload sc
    
    Dim Buffer As String
    Dim j As Integer


    For i = 0 To 2
        If MeterLogEnableCheckbox(i) = 1 Then
            DelayOver = False
            frmMain.DelayTimer.Interval = 1000
            frmMain.DelayTimer.Enabled = True
        
            MSComm1.CommPort = MeterLogComPort(i)    ' Set the port number
            MSComm1.Settings = "9600,N,8,1"          ' Set UART parameters
            On Error GoTo errorhandler
            MSComm1.PortOpen = True                  ' Required, might lock port
            MSComm1.InputLen = 0
            MSComm1.Output = "MEAS1?" & vbCr    ' Send data
            
            Buffer = ""
            Do
                DoEvents
                Buffer$ = Buffer$ & MSComm1.Input
            Loop Until InStr(Buffer$, vbCrLf) Or DelayOver = True
            
            If DelayOver = True Then GoTo errorhandler
            
            j = InStr(1, Buffer, vbCr)
            Buffer = Left(Buffer, j - 1)
            
            DataLine = DataLine & "  " & Buffer$ & vbTab
            
            If MSComm1.PortOpen = True Then
                MSComm1.PortOpen = False           ' Required, might lock port
            End If
        End If
    Next i
        
'    If LogToResults.Value = True Then
'        lstResults.AddItem Time & vbTab & DataLine
'    Else
'        LogFile.WriteLine Time & vbTab & DataLine
'    End If

    LogResults DataLine
    Exit Sub
    
errorhandler:
    LogResults "Error communicating with Fluke45."
    LogResults DataLine
    If MSComm1.PortOpen = True Then
        MSComm1.PortOpen = False           ' Required, might lock port
    End If
    Exit Sub
    
End Sub

Public Function ReadRamSymbol(Symbol As String) As String
    ReadRamSymbol = ReadRamLocation(H2D(GetSymbolAddress(Symbol)))
End Function

Public Function ReadRamLocation(Address As Variant) As String
    Dim Response As String
    If CypressRadioOpt = False Then
        SetUsage "&HFFFF", "&HC3", 153, "&H" & D2H(getval(Address))
        ReadRamLocation = GetUsage("&HFFFF", "&HC2", 152)
    Else
        Response = ColonCmd("&H2A", "&H" & D2H(getval(Address)) & "0058", 4, True):
        ReadRamLocation = Mid(Response, 7, 2)
    End If
End Function

Public Function WriteRamSymbol(Symbol As String, Data As String) As String
    WriteRamSymbol = WriteRamLocation(H2D(GetSymbolAddress(Symbol)), Data)
End Function

Public Function WriteRamLocation(Address As Variant, Data As String) As String
    Dim Response As String
    If CypressRadioOpt = False Then
        SetUsage "&HFFFF", "&HC3", 153, "&H" & D2H(getval(Address))
        
        Response = GetUsage("&HFFFF", "&HC3", 153)
        If Response = getval(Address) Then
            WriteRamLocation = SetUsageValue("&HFFFF", "&HC2", 0, False, getval(Data), 152, False)
        Else
            WriteRamLocation = "-1"
        End If
    Else
        Response = ColonCmd("&H2A", "&H" & FXD(D2H(getval(Address)), 4) & "0058", 4, True):
        Response = ColonCmd(Val("&H2B"), "&H" & FXD(D2H(getval(Address)), 4) & FXD(D2H(getval(Data)), 2) & "58", 4, True)
        WriteRamLocation = Mid(Response, 7, 2)
    End If
End Function

Public Function GetMeterReading(ComPort As Integer) As String
    Dim Buffer As String
    Dim j As Integer
    
    DelayOver = False
    frmMain.DelayTimer.Interval = 1000
    frmMain.DelayTimer.Enabled = True

    MSComm1.CommPort = ComPort          ' Set the port number
    MSComm1.Settings = "9600,N,8,1"     ' Set UART parameters
    On Error GoTo errorhandler
    MSComm1.PortOpen = True             ' Required, might lock port
    MSComm1.InputLen = 0
    MSComm1.Output = "MEAS1?" & vbCr    ' Send data
    
    Buffer = ""
    Do
        DoEvents
        Buffer$ = Buffer$ & MSComm1.Input
    Loop Until InStr(Buffer$, vbCrLf) Or DelayOver = True
    
    If DelayOver = True Then GoTo errorhandler
    
    j = InStr(1, Buffer, vbCr)
    Buffer = Left(Buffer, j - 1)
    
    GetMeterReading = Val(Buffer$)          'display value normally
    
    If MSComm1.PortOpen = True Then
        MSComm1.PortOpen = False           ' Required, might lock port
    End If

    Exit Function
    
errorhandler:
    GetMeterReading = "Error"
    If MSComm1.PortOpen = True Then
        MSComm1.PortOpen = False           ' Required, might lock port
    End If
    Exit Function
    
End Function


Public Function SendGetRs232(ComPort As Integer, BaudRate As String, DataToSend As String) As String
    Dim Buffer As String
    Dim j As Integer
    
    DelayOver = False
    frmMain.DelayTimer.Interval = 300
    frmMain.DelayTimer.Enabled = True

    MSComm1.CommPort = ComPort          ' Set the port number
    MSComm1.Settings = BaudRate & ",N,8,1"     ' Set UART parameters
    On Error GoTo errorhandler
    MSComm1.PortOpen = True             ' Required, might lock port
    MSComm1.InputLen = 0
    MSComm1.Output = DataToSend         ' Send data
    
    Buffer = ""
    Do
        DoEvents
        Buffer$ = Buffer$ & MSComm1.Input
    Loop Until InStr(Buffer$, vbCrLf) Or DelayOver = True
    
    If DelayOver = True Then GoTo errorhandler
    
    j = InStr(1, Buffer, vbCr)
    Buffer = Left(Buffer, j - 1)
    
    SendGetRs232 = Val(Buffer$)          'display value normally
    
    If MSComm1.PortOpen = True Then
        MSComm1.PortOpen = False           ' Required, might lock port
    End If

    Exit Function
    
errorhandler:
    SendGetRs232 = "Error"
    If MSComm1.PortOpen = True Then
        MSComm1.PortOpen = False           ' Required, might lock port
    End If
    Exit Function
    
End Function


Private Sub GetInputButton_Click()
    Dim Result As Long
    Dim ReportOut As String
    Dim nBytesInResponse As Integer
    
    ReDim ReadBuffer(Hidio.Capabilities.InputReportByteLength) As Byte
    Dim i As Long
    
    Result = ReadInputReport(ReadBuffer(), Hidio.ReadHandle, Hidio.HIDOverlapped, Hidio.Capabilities.InputReportByteLength)
        
'clear out trailing 0's
    For nBytesInResponse = Hidio.Capabilities.InputReportByteLength - 1 To 0 Step -1
        If ReadBuffer(nBytesInResponse) <> 0 Then
            GoTo NBytesFound2
        End If
    Next nBytesInResponse
NBytesFound2:


    ReportOut = "Cypress Received=   "
    
    For i = 1 To nBytesInResponse
        If ReadBuffer(i) >= Val("&H30") And ReadBuffer(i) <= Val("&H7A") Then
            ReportOut = ReportOut & Chr(ReadBuffer(i))
        Else
            ReportOut = ReportOut & "{" & FXD(D2H(ReadBuffer(i)), 2) & "}"
        End If
    Next i
    
    ReportOut = ReportOut & "   Hex= "
       
    For i = 1 To nBytesInResponse
        ReportOut = ReportOut & FXD(D2H(ReadBuffer(i)), 2) & " "
    Next i
        
    LogResults ReportOut
    
    ScrollDown
End Sub

Private Sub GetInputReportButton_Click()
    Dim NumberOfBytesRead As Long
    Dim nBytesToRead As Long
    Dim Result As Long
    Dim i As Integer
    
    Call PrepareForOverlappedTransfer(Hidio.HIDOverlapped, Hidio.Security)
    
    'ReDim ReadBuffer(Hidio.Capabilities.InputReportByteLength) As Byte

    Dim ReadBuffer(4) As Byte

    'clear out the buffer just in case
    For i = 0 To Hidio.Capabilities.InputReportByteLength - 1
        ReadBuffer(i) = 0
    Next i

    'ReadBuffer(0) = 0

    nBytesToRead = 2
    
    Result = ReadFile _
    (Hidio.ReadHandle, _
    ReadBuffer(0), _
    nBytesToRead, _
    NumberOfBytesRead, _
    Hidio.HIDOverlapped)

    Result = WaitForSingleObject(Hidio.HIDOverlapped.hEvent, 1000)
    
    If Result = 0 Then
        LogResults "got data"
    Else
        LogResults "didnt get any data " & Result
    End If
    
End Sub

Private Sub GetLinkCollections_Click()
    Dim PreparsedData As Long
    Dim HidP_Feature As Integer
    Dim Result As Long
    Dim DataReturned As Long
    Dim RptLength As Long
    Dim UsagePage As Integer
    Dim Usage As Integer
    Dim ReportID As Integer
    Dim LinkCollection As Integer
    Dim ReportBufferLength As Integer
    Dim ReportBuffer(8) As Byte
    Dim i As Integer
    
    If UsagePageTextBox.Text = "" Or UsageTextBox.Text = "" Then
        LogResults "Get usage id failed: Usage invalid"
        Exit Sub
    End If
    UsagePage = "&H" + UsagePageTextBox.Text
    Usage = "&H" + UsageTextBox.Text
    LinkCollection = LinkCollectionTextBox.Text

    ReportID = -1

    LogResults "All possible link collections for Usage page:0x" & UsagePageTextBox.Text & " Usage:0x" & UsageTextBox.Text & ":"
    For i = 0 To Hidio.TotalNumberOfFeatureCaps
        If Hidio.FeatureCaps(i).UsagePage = UsagePage Then
            If Hidio.FeatureCaps(i).Usage = Usage Then
                LogResults "Report ID:" & Hidio.FeatureCaps(i).ReportID & " LinkCollection: " & Hidio.FeatureCaps(i).LinkCollection
            End If
        End If
    Next i
End Sub

Private Sub GetStringIndex_Click()
    Dim PreparsedData As Long
    Dim HidP_Feature As Integer
    Dim Result As Long
    Dim DataReturned As Long
    Dim RptLength As Long
    Dim UsagePage As Integer
    Dim Usage As Integer
    Dim ReportID As Integer
    Dim LinkCollection As Integer
    Dim ReportBufferLength As Integer
    Dim ReportBuffer(8) As Byte
    Dim i As Integer
    
    If UsagePageTextBox.Text = "" Or UsageTextBox.Text = "" Then
        LogResults "Get usage id failed: Usage invalid"
        Exit Sub
    End If
    UsagePage = "&H" + UsagePageTextBox.Text
    Usage = "&H" + UsageTextBox.Text
    LinkCollection = LinkCollectionTextBox.Text

    ReportID = -1

    For i = 0 To Hidio.TotalNumberOfFeatureCaps
        If Hidio.FeatureCaps(i).UsagePage = UsagePage Then
            If Hidio.FeatureCaps(i).Usage = Usage Then
            LogResults "Get String Index Report ID:" & Hidio.FeatureCaps(i).ReportID & "   Collection:" & _
                Hidio.FeatureCaps(i).LinkCollection & "   UsagePage:" & Hex$(UsagePage) & _
                "   UsageID:" & Hex$(Usage) & "   StringIndex = " & Hidio.FeatureCaps(i).StringIndex
            End If
        End If
    Next i
    
End Sub

Private Sub GetStringReportButton_Click()
    Dim tempstring As String
    
    Dim StringIndex As Integer
    Dim ReportBufferLength As Integer
    Dim ReportBuffer(64) As Byte        'max length = 64 limited by HID.
    Dim Result As Long

    ReportBuffer(0) = GetStringReportID.Text
    ReportBufferLength = GetFeatureLength(GetStringReportID.Text, Hidio.FeatureCaps(), Hidio.TotalNumberOfFeatureCaps) / 8
    
    'diag for overloading the report buffer length:
    'ReportBufferLength = 64
    
    Result = HidD_GetFeature(Hidio.HIDHandle, ReportBuffer(0), ReportBufferLength + 1)

    Dim i As Integer
    Dim ReportData As String
    ReportData = ""
    
    'msgbox "String Index = " & str(ReportBuffer(1))
    
    StringIndex = ReportBuffer(1)
    
    tempstring = GetStringReport(GetStringReportID.Text)

    LogResults "GetStringReport Report ID: " & GetStringReportID & " String Index: " & StringIndex & "   " & tempstring
End Sub

Private Sub ImportNVRButton_Click()
    Dim NVRFileName As String
    Dim linenumber As Integer
    Dim FileLine As String
    Dim InData(256) As Byte
    ReDim Packet(10) As Byte
    Dim RetStat As Integer
    Dim curarray As Integer
    Dim highaddr As Integer
    Dim lowaddr As Integer
    Dim Data As Byte
    Dim Stringval As String
    Dim EndOfFile As Boolean
    Dim Address As Long
    Dim i As Integer
           
    With CommonDialog1
        .DialogTitle = "Open NVR File"
        .CancelError = False
        'ToDo: set the flags and attributes of the common dialog control
        .Flags = cdlOFNHideReadOnly
        .Filter = "NVR Files (*.NVR,*.TXT)|*.NVR;*.TXT|All Files (*.*)|*.*"
        .ShowOpen
        If Len(.FileName) = 0 Then
            Exit Sub
        End If
    '    if .Action
        
        NVRFileName = .FileName
        .FileName = ""
    End With
           
'import the NVR file:
    CoolFlex1.Clear
    CoolFlex1.TextMatrix(0, 0) = "Addr (Hex)"
    CoolFlex1.TextMatrix(0, 1) = "Data (Hex)"
    
    'FileSystemObject must reference Microsoft Scripting Engine:
    Dim fs As New FileSystemObject
    Dim InFile As Object
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set InFile = fs.OpenTextFile(NVRFileName, 1, False, 0)
    
    'the first line should read: "NVRAddrHi(dec),NVRAddrLo(dec), NVRData(dec)"
    FileLine = InFile.ReadLine
    
    If Not (Mid(FileLine, 1, 1) = "N" Or Mid(FileLine, 1, 1) = "A") Then
        'WriteNVRFile = -2
        Exit Sub
    End If
    
    EndOfFile = False
    linenumber = 0
        
    Do While InFile.AtEndOfStream <> True
        FileLine = InFile.ReadLine

        Stringval = ""
        i = 1
        
        'Get high address: Store 1 character at a time until a vbTab is reached:
        Do
            'Check for no character at beginning of line:
            If (Mid(FileLine, 1, 1) = "") Then
                EndOfFile = True
                Exit Do
            End If
            If (Mid(FileLine, i, 1) <> vbTab) Then
                Stringval = Stringval & Mid(FileLine, i, 1)
                i = i + 1
            Else
                Exit Do
            End If
        Loop
        If (EndOfFile = True) Then Exit Do
        'Record highaddr:
        highaddr = Stringval
        
        Stringval = ""
        i = i + 1
        'Get low address: Store 1 character at a time until a vbTab is reached:
        Do
            If (Mid(FileLine, i, 1) <> vbTab) Then
                Stringval = Stringval & Mid(FileLine, i, 1)
                i = i + 1
            Else
                Exit Do
            End If
        Loop
        'Record lowaddr:
        lowaddr = Stringval
            
        Stringval = ""
        i = i + 1
        'Get data value: Store 1 character at a time until end of line is reached:
        Do
            If (Mid(FileLine, i, 1) <> "") Then
                Stringval = Stringval & Mid(FileLine, i, 1)
                i = i + 1
            Else
                Exit Do
            End If
        Loop
        Data = Stringval
        
        Address = highaddr * 256 + lowaddr
        
        DoEvents

        CoolFlex1.TextMatrix(linenumber + 1, 0) = Hex$(Address)
        CoolFlex1.TextMatrix(linenumber + 1, 1) = Hex$(Data)
        
        linenumber = linenumber + 1
'        'Write the byte:
'        RetStat = WriteNVRByte(Address, Data, 5)
'        If RetStat < 0 Then
'            WriteNVRFile = RetStat
'            Exit Function
'        End If
'
'        StringVal = ""
    Loop
    
'success:
    'WriteNVRFile = 1
    InFile.Close
End Sub


Private Sub ExportNVRButton_Click()
    Dim NVRFileName As String
    Dim OutFileLine As String
    Dim Address As Long
    Dim BootAddr As Long
    Dim OutData As Byte
        
    With CommonDialog1
        .DialogTitle = "Save NVR File"
        .CancelError = False
        'ToDo: set the flags and attributes of the common dialog control
        .Flags = cdlOFNHideReadOnly
        .Filter = "NVR Files (*.NVR)|*.NVR|Text files (*.TXT)|*.TXT|All Files (*.*)|*.*"
        .ShowSave
        If Len(.FileName) = 0 Then
            Exit Sub
        End If
    '    if .Action
        
        NVRFileName = .FileName
        .FileName = ""
    End With
    
'open the NVR file:
    Dim fs As New FileSystemObject
    Dim OutFile As Object
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set OutFile = fs.CreateTextFile(NVRFileName, True)
    
    'the first line should read: "NVRAddrHi(dec),NVRAddrLo(dec), NVRData(dec)"
    OutFile.WriteLine ("NVRAddrHi(dec),NVRAddrLo(dec), NVRData(dec)")
    
    Dim Row As Integer
    For Row = 0 To 255
        DoEvents
        If CoolFlex1.TextMatrix(Row + 1, 0) = "" Then
            Exit For                                    'exit for blank address field
        End If
        Address = Val("&H" + CoolFlex1.TextMatrix(Row + 1, 0))
        OutData = Val("&H" + CoolFlex1.TextMatrix(Row + 1, 1))
        OutFile.WriteLine (Address \ 256 & vbTab & Address Mod 256 & vbTab & OutData)
    Next Row
    
'success:
    'ExportNVRFile = 1
    OutFile.Close
End Sub

Public Sub LoadMapFile_Click()
    Dim MapFileName As String
    Dim temppath As String
    
    temppath = Left(MapFileNameLabel.Caption, InStrRev(MapFileNameLabel.Caption, "\"))
    
    With CommonDialog1
        .DialogTitle = "Open map File"
        .CancelError = False
        'ToDo: set the flags and attributes of the common dialog control
        .Flags = cdlOFNHideReadOnly
        .Filter = "map Files (*.map,*.TXT)|*.map;*.TXT|All Files (*.*)|*.*"
        .InitDir = temppath
        .ShowOpen
        If Len(.FileName) = 0 Then
            Exit Sub
        End If
    '    if .Action
        
        MapFileName = .FileName
        .FileName = ""
    End With
    
    
    Shell """" & VB.App.Path & "\GetSymbolsFromMapfile.exe" & """" & " " & MapFileName, vbNormalFocus

    GetSymbolsFromSymbolFile
    
    DoEvents
    
    LogResults "Loaded Map file: " & MapFileNameLabel.Caption
End Sub

Private Sub GetSymbolsFromSymbolFile()
    Dim FileLine As String
    Dim Label As String
    'FileSystemObject must reference Microsoft Scripting Engine:
    Dim fs As New FileSystemObject
    Dim InFile As Object
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set InFile = fs.OpenTextFile(SymbolFile, 1, False, 0)
    
    If InFile.AtEndOfStream <> True Then
        FileLine = InFile.ReadLine
        MapFileNameLabel.Caption = FileLine
    End If

    SymbolListComboBox.Clear
    
    Dim i As Integer
    Dim j As Integer
    Dim Address As String
    Dim SymbolName As String
    
    i = 0
    Do While InFile.AtEndOfStream <> True
        FileLine = InFile.ReadLine

        Label = InStr(FileLine, " ")
        If Label <> 0 Then
            SymbolName = Left(FileLine, Label - 1)
            
            'SymbolListComboBox.Index
            
            'SymbolListComboBox.ListIndex = i
            'SymbolListComboBox.Text
            Address = Right(FileLine, 7)
            
            Label = InStr(Address, ":")
            If Label = 0 Then
            Else
                SymbolName = SymbolName & " (bit " & Right(Address, 1) & ")"
                Address = "00" & Left(Address, Label - 1)
            End If
            
            SymbolListComboBox.AddItem SymbolName
            
            SymbolListComboBox.ItemData(i) = Val(uH2D(Address))
            i = i + 1
        End If

    Loop
    
    SymbolListComboBox.ListIndex = 0
End Sub



Private Sub LogToFile_Click()
    Dim LogFileName As String
    Dim fs As New FileSystemObject
    
    If LogFileOpen = True Then
        LogFile.Close
        LogFileOpen = False
        LogToFile.Value = 0
'        LogToFile.Value = False
        Exit Sub
    End If
    
'    LogToFile.Value = True
    
    Set fs = CreateObject("Scripting.FileSystemObject")
    With CommonDialog1
        .DialogTitle = "Save as Log File"
        .CancelError = False
        'ToDo: set the flags and attributes of the common dialog control
        .Flags = cdlOFNHideReadOnly
        .Filter = "LOG Files (*.LOG)|*.LOG|Text files (*.TXT)|*.TXT|All Files (*.*)|*.*"
        .InitDir = VB.App.Path
        .ShowOpen
        If Len(.FileName) = 0 Then
            LogToFile.Value = 0
            Exit Sub
        End If
    '    if .Action
        
        LogFileName = .FileName
        .FileName = ""
    End With

    LogFileOpen = True
    Set LogFile = fs.CreateTextFile(LogFileName, True)
    lstResults.AddItem "Logging data to file: " & LogFileName & "..."
End Sub

Private Sub Open_Click()
    OpenConnection True
End Sub

Public Sub OpenConnection(ByVal ShowHIDList As Boolean)
    Dim DevicePath As String
    Dim Count As Integer
    'Dim DeviceAttributes As HIDD_ATTRIBUTES
    Dim Result As Integer
    
    Dim PID As Integer
    Dim VID As Integer
    
    If DebugMode <> True Then: On Error GoTo errorhandler:
    
'    PID = Val("&H" & PIDData.Text)
'    VID = Val("&H" & VIDData.Text)
    
    If FindTheHid(VID, PID, ShowHIDList, DevicePath, Hidio.Security) Then
        
        'If good, open the handle..
        Hidio.HIDHandle = CreateFile _
        (DevicePath, _
        GENERIC_READ Or GENERIC_WRITE, _
        (FILE_SHARE_READ Or FILE_SHARE_WRITE), _
        Hidio.Security, _
        OPEN_EXISTING, _
        0&, _
        0)

        LogResults "Handle: " & Hidio.HIDHandle

        Call GetDeviceCapabilities(Hidio.Capabilities, Hidio.FeatureCaps(), Hidio.InputCaps(), Hidio.HIDHandle, Hidio.PreparsedDataPtr)       'return the device capabilities
        
        'Get another handle for the overlapped ReadFiles.
        Hidio.ReadHandle = CreateFile _
                (DevicePath, _
                (GENERIC_READ Or GENERIC_WRITE), _
                (FILE_SHARE_READ Or FILE_SHARE_WRITE), _
                Hidio.Security, _
                OPEN_EXISTING, _
                FILE_FLAG_OVERLAPPED, _
                0)

        
        Call PrepareForOverlappedTransfer(Hidio.HIDOverlapped, Hidio.Security)
        
        Hidio.TotalNumberOfFeatureCaps = Hidio.Capabilities.NumberFeatureButtonCaps + Hidio.Capabilities.NumberFeatureValueCaps - 1
        
        'Result = HidD_GetAttributes(Hidio.HIDHandle, DeviceAttributes)
        If PID = 1 And VID = 2478 Then
            'automatically select the appropriate box based on PID.
            HIDRadioOpt = False
            CypressRadioOpt = True
        Else
            HIDRadioOpt = True
            CypressRadioOpt = False
        End If
        
        ScrollDown
    Else
        'bad.. fail
        LogResults "Device not found"
    End If
    Exit Sub
    
errorhandler:
    LogResults "Overflow while trying to read info."
    Resume Next
    'Exit Sub
End Sub

Private Sub GetFButton_Click()
    Dim ReportBufferLength As Integer
    Dim ReportBuffer(64) As Byte        'max length = 64 limited by HID.
    Dim Result As Long

    'ReportBufferLength = 8
    ReportBuffer(0) = ReportIDGet.Text
    'ReportBuffer(0) = 155
    
    'bug?
    'ReportBufferLength = GetFeatureLength(ReportIDGet.Text, Hidio.FeatureCaps(), Hidio.Capabilities.NumberFeatureValueCaps) / 8
    ReportBufferLength = Hidio.Capabilities.FeatureReportByteLength
    
    'diag for overloading the report buffer length:
    'ReportBufferLength = 64
    
    Result = HidD_GetFeature(Hidio.HIDHandle, ReportBuffer(0), ReportBufferLength + 1)

    Dim i As Integer
    Dim ReportData As String
    ReportData = ""
    
    If Result = 1 Then
        For i = 1 To ReportBufferLength
            ReportData = ReportData + Dec2Hex(ReportBuffer(ReportBufferLength + 1 - i), 2) + " "
        Next i
        LogResults "GetFeature: Report ID " & ReportBuffer(0) & "  " & "Data:   " & ReportData
    Else
        LogResults "GetFeature: Report ID " & ReportBuffer(0) & "   Failed"
    End If
 
    ScrollDown

End Sub


Private Sub RAMRadioOpt_Click()
    MsgBox "Be careful when accessing RAM using this function"
End Sub

Private Sub ReadAllRamButton_Click()
    Dim retval As Long
    Dim Data As Long
    Dim UsagePage As Integer
    Dim Usage As Integer
    Dim LinkCollection As Integer
    Dim ReportID As Integer
    Dim Address As Integer
    Dim Row As Integer
    Dim DataString As String
    
    Address = 0
    AbortFunction = False
    WritePasswordButton_Click
    
    WaitMIN_DELAY

'replace this with something else..
'    CoolFlex2.Clear
'    CoolFlex2.TextMatrix(0, 0) = "Addr (Hex)"
'    CoolFlex2.TextMatrix(0, 1) = "Data (Hex)"
    
    Row = 0
    For Row = 0 To 255
BeginLoop:
    
        If AbortFunction = True Then
            Exit Sub
        End If
    
         If Row = 256 Then
            LogResults "Read all locations"
            Exit Sub
        End If
        
'        'address out of range
'        If Val("&H" + CoolFlex1.TextMatrix(Row + 1, 0)) < Val("&H" + StartNVRAddressTextBox.Text) Then
'            Row = Row + 1
'            GoTo BeginLoop      'continue
'        End If
        
        If CoolFlex2.TextMatrix(Row + 1, 1) = "" Then
            'If address field is blank for the current row, then do not do the read
            Row = Row + 1
            GoTo BeginLoop      'continue
        End If
        
        lstResults.List(lstResults.ListIndex) = "Reading RAM: " + CoolFlex2.TextMatrix(Row + 1, 1)
        
        Address = Val("&H" + CoolFlex2.TextMatrix(Row + 1, 1))
        Data = Val("&H" + CoolFlex2.TextMatrix(Row + 1, 2))
        
        If CypressRadioOpt.Value = True Then
            'ram read
            DataString = ColonCmd(Val("&H2A"), "&H" & FXD(D2H(Address), 4) & "0058", 4, True)
            
            If H2D(Mid(DataString, 3, 4)) <> Address Or DataString = "-1" Then
                retval = 0
            Else
                retval = 1
                Data = H2D(Mid(DataString, 7, 2))
            End If
        Else
            UsagePage = "&HFFFF"
            Usage = "&HC3"
                   
            LinkCollection = 0
            ReportID = 0
            Data = Val("&H" + CoolFlex2.TextMatrix(Row + 1, 1))
            retval = 0
            retval = SetUsageValue(UsagePage, Usage, LinkCollection, 0, Data, ReportID, False)
            
            WaitMIN_DELAY
            
            If retval <> 1 Then
                LogResults "Failed to write address"
                Exit Sub
            End If
            
            'Read RAM value
            Usage = "&HC2"
            LinkCollection = 0
            ReportID = 0
            Data = -1
            retval = GetUsageValue(UsagePage, Usage, LinkCollection, 0, Data, ReportID, False)
            
            WaitMIN_DELAY
        End If
        
        If retval = 1 Then
            CoolFlex2.TextMatrix(Row + 1, 2) = D2H(Data)
        Else
            LogResults "Failed to read RAM"
            Exit Sub
        End If
        DoEvents
    Next Row
    
    LogResults "Read configured RAM table."
    ScrollDown
End Sub

Private Sub RemoveCheckedSymbols_Click()
    Dim Row As Integer
    Dim i As Integer
    
    On Error Resume Next
    
    For Row = 1 To 255
        If CoolFlex2.TextMatrix(Row, 3) = "C" Then
            For i = Row To 255
                CoolFlex2.TextMatrix(i, 0) = CoolFlex2.TextMatrix(i + 1, 0)
                CoolFlex2.TextMatrix(i, 1) = CoolFlex2.TextMatrix(i + 1, 1)
                CoolFlex2.TextMatrix(i, 2) = CoolFlex2.TextMatrix(i + 1, 2)
                CoolFlex2.TextMatrix(i, 3) = CoolFlex2.TextMatrix(i + 1, 3)
            Next
        End If
        
        CoolFlex2.UpdateCheckbox Row, 3   'should update the check picture in the box
        If CoolFlex2.TextMatrix(Row, 3) = "C" Then Row = Row - 1
    Next
    
ENDSUB:
    Exit Sub
End Sub

Private Sub ResToClipboardButton_Click()
    Dim cliptemp As String
    Dim i As Integer
    
    cliptemp = ""
    For i = 0 To lstResults.ListCount - 1
        lstResults.ListIndex = i
        cliptemp = cliptemp + lstResults.Text + vbCrLf
    Next i

    Clipboard.Clear
    CoolFlex1.TextMatrix(0, 0) = "Addr (Hex)"
    CoolFlex1.TextMatrix(0, 1) = "Data (Hex)"
    Clipboard.SetText cliptemp
End Sub


Private Sub RunAllScripts_Click()
    Dim test As Integer
    Dim i As Integer
        
    If MsgBox("This could take a while, are you sure you want to execute " _
    & "all scripts?", vbYesNo) = vbYes Then
        For i = 0 To ScriptsComboBox.ListCount - 1
            ScriptsComboBox.ListIndex = i
            UPSStatusListBox.Clear
            RunScript SCPFileName, ScriptsComboBox.Text
            ScrollUPSStatsDown
            ScrollDown
            WAIT_1_SEC
            DoEvents
        Next
    End If
End Sub

Private Sub RunScriptButton_Click()
    UPSStatusListBox.Clear
    LogResults "Running Script: " & ScriptsComboBox.Text
    RunScript SCPFileName, ScriptsComboBox.Text
    ScrollUPSStatsDown
End Sub

Private Sub ScrollDownTimer_Timer()
'    ScrollDown
End Sub

Private Sub SelectRamLogItem_Click(Index As Integer)
    Dim Row As Integer
    
    For Row = 0 To SymbolListComboBox.ListCount - 1
        frmComboBox.Combo1.AddItem SymbolListComboBox.List(Row)
        frmComboBox.Combo1.ItemData(Row) = SymbolListComboBox.ItemData(Row)
    Next
    
    frmComboBox.Combo1.ListIndex = 0
    
    frmComboBox.Show vbModal, frmMain
    
    ItemsTextBox(Index).Text = "Item = ReadRamSymbol(""" & frmComboBox.Combo1.Text & """)"
    ItemNamesTextBox(Index).Text = frmComboBox.Combo1.Text
    Unload frmComboBox
End Sub

Private Sub SendOldCommand_Click()
    Dim ReportBuffer(8) As Byte
    Dim Result As Long
    Dim WriteValue As Long
    Dim TempReturn As String
    Dim i As Long
    
    Dim NumberOfBytesWritten As Long

    If OldCommandTextBox.Text = "" Then
        Exit Sub
    End If

    TempReturn = OldCommandTextBox.Text
    
    Dim TempInput As String
    Dim j As Integer
    
    TempInput = TempReturn
    
    'strip spaces:
    Do
        i = InStr(1, TempInput, " ")
        If i = 0 Then GoTo DONESPACESSTRIP
        TempInput = Mid(TempInput, 1, i - 1) & Mid(TempInput, i + 1, Len(TempInput) - i)
    Loop
DONESPACESSTRIP:
    
    If CypressCmdInAscii.Value = 1 Then
        TempReturn = ""
        TempInput = "{00}" & TempInput
'perform ascii conversion..
        Do
            If Left(TempInput, 1) = "{" Then
                'hex character..
                j = InStr(1, TempInput, "}")
                If j - 1 > 3 Or j = 0 Then
                    LogResults "Error in data to send"
                    GoTo ERROR
                End If
                TempReturn = TempReturn & FXD(Mid(TempInput, 2, j - 2), 2)
                TempInput = Right(TempInput, Len(TempInput) - j)
            ElseIf Left(TempInput, 1) = "[" Then
                'hex character..
                j = InStr(1, TempInput, "]")
                If j - 1 <> 3 Or j = 0 Then
                    LogResults "Error in data to send"
                    GoTo ERROR
                End If
                If UCase(Mid(TempInput, 2, j - 2)) = "CR" Then
                    TempReturn = TempReturn & "0D"
                End If
                If UCase(Mid(TempInput, 2, j - 2)) = "LF" Then
                    TempReturn = TempReturn & "0A"
                End If
                TempInput = Right(TempInput, Len(TempInput) - j)
            Else
                'ascii character..
                TempReturn = TempReturn & FXD(D2H(Asc(Left(TempInput, 1))), 2)
                TempInput = Mid(TempInput, 2, Len(TempInput))
            End If
            
            If TempInput = "" Then GoTo DONECONVERSION
        Loop
    Else
        TempReturn = "00" & TempInput
    End If
     
DONECONVERSION:
'TempReturn is a Hex string at this point.
     
    For i = 0 To Hidio.Capabilities.OutputReportByteLength - 1
        ReportBuffer(i) = Val("&H" + Mid(TempReturn, i * 2 + 1, 2))
    Next i
    
    Dim nBytesToWrite As Integer
    Dim ChkSum As Integer
    nBytesToWrite = (Len(TempReturn) / 2)
    
    If nBytesToWrite > 8 Then
        MsgBox "Overflow.  Too much data"
        Exit Sub
    End If
    
    If (AutoAddChksumCheckBox.Value = Checked) Then
        ChkSum = 0
        For i = 1 To (Len(TempReturn) / 2)
            ChkSum = ChkSum + ReportBuffer(i)
        Next i
        ChkSum = ChkSum And 255     'get low byte
        
        ChkSum = 255 - ChkSum
        ChkSum = ChkSum + ReportBuffer(1)          'subtract off the leading character
        ReportBuffer(Len(TempReturn) / 2) = ChkSum      '2nd to last byte is checksum
        ReportBuffer((Len(TempReturn) / 2) + 1) = Val("&H0d")  '2nd to last byte is checksum
        nBytesToWrite = nBytesToWrite + 2
    End If

    Dim WriteDataAscii As String
    Dim WriteDataHex As String

'Convert write data to hex for reporting later:
    WriteDataHex = ""
    For i = 1 To nBytesToWrite - 1
        WriteDataHex = WriteDataHex + FXD(D2H(ReportBuffer(i)), 2) + " "
    Next i

'Convert write data to ascii for reporting later:
    WriteDataAscii = ""
    For i = 1 To nBytesToWrite - 1
        If ReportBuffer(i) >= Val("&H30") And ReportBuffer(i) <= Val("&H7A") Then
            WriteDataAscii = WriteDataAscii & Chr(ReportBuffer(i))
        Else
            WriteDataAscii = WriteDataAscii & "{" & FXD(D2H(ReportBuffer(i)), 2) & "}"
        End If
    Next i


NumberOfBytesWritten = 0

Result = WriteFile _
    (Hidio.HIDHandle, _
    ReportBuffer(0), _
    CLng(Hidio.Capabilities.OutputReportByteLength), _
    NumberOfBytesWritten, _
    0)
'Call DisplayResultOfAPICall("WriteFile")

'lstResults.AddItem " OutputReportByteLength = " & Capabilities.OutputReportByteLength
'lstResults.AddItem " NumberOfBytesWritten = " & NumberOfBytesWritten
'lstResults.AddItem " Report ID: " & SendBuffer(0)
'lstResults.AddItem " Report Data:"
'

    TempReturn = Mid(TempReturn, 3, Len(TempReturn) - 2)

    For i = 2 To Len(TempReturn) + 2 Step 3
        TempReturn = Left(TempReturn, i) & " " & Mid(TempReturn, i + 1, Len(TempReturn) - i)
    Next i
    
    If Result = 1 Then
        LogResults "Cypress Sent=            " & WriteDataAscii & "        Hex=  " & WriteDataHex
    Else
        LogResults "Cypress Sent=            " & WriteDataAscii & "        Hex=  " & WriteDataHex & "    Failed"
    End If
   
'Wait for response to be valid, and display it:
    Dim ReportOut As String
    Dim nBytesInResponse As Integer
    
    ReDim ReadBuffer(Hidio.Capabilities.InputReportByteLength) As Byte
    
    Dim tempvar As Long
    
    For i = 1 To 80     '2 second timeout
        WAIT_mSECS 25   'polling rate
        Result = ReadInputReport(ReadBuffer(), Hidio.ReadHandle, Hidio.HIDOverlapped, Hidio.Capabilities.InputReportByteLength)
        If Result = False Then
            'timeout occurred..
            i = i + 40
        End If
        If ReadBuffer(1) = H2D(Mid(TempReturn, 4, 2)) Then GoTo CMD_DONE
    Next i

    If i = 81 Then          'response doesn't match request
        LogResults "Timeout"
    End If
CMD_DONE:
 
 
 'Read response:
 
   
'clear out trailing 0's
    For nBytesInResponse = Hidio.Capabilities.InputReportByteLength - 1 To 0 Step -1
        If ReadBuffer(nBytesInResponse) <> 0 Then
            GoTo NBytesFound2
        End If
    Next nBytesInResponse
NBytesFound2:


    ReportOut = "Cypress Received=   "
    
    For i = 1 To nBytesInResponse
        If ReadBuffer(i) >= Val("&H30") And ReadBuffer(i) <= Val("&H7A") Then
            ReportOut = ReportOut & Chr(ReadBuffer(i))
        Else
            ReportOut = ReportOut & "{" & FXD(D2H(ReadBuffer(i)), 2) & "}"
        End If
    Next i
    
    ReportOut = ReportOut & "   Hex= "
       
    For i = 1 To nBytesInResponse
        ReportOut = ReportOut & FXD(D2H(ReadBuffer(i)), 2) & " "
    Next i
        
    LogResults ReportOut
 
    ScrollDown
    Exit Sub

ERROR:
End Sub

Private Sub SetFeatureButton_Click()
    Dim ReportBufferLength As Integer
    Dim ReportBuffer(128) As Byte
    Dim Result As Long
    Dim WriteValue As Long
    Dim TempReturn As String
    Dim i As Integer


    'ReportBufferLength = 8
    ReportBufferLength = Hidio.Capabilities.FeatureReportByteLength


    ReportBuffer(0) = ReportIDSet.Text
'    ReportBuffer(1) = Val("&H" & Right(SetData.Text, 2))
'    ReportBuffer(2) = Val("&H" & Left(SetData.Text, 2))
    
    WriteValue = Val("&H" + SetData.Text)
    TempReturn = Dec2Hex(WriteValue, 2 * ReportBufferLength)
      
    For i = 1 To ReportBufferLength
        'ReportBuffer(i + 1) = Val("&H" + Mid(TempReturn, i * 2 + 1, 2))
        ReportBuffer(i) = Val("&H" + Mid(TempReturn, ReportBufferLength * 2 - i * 2 + 1, 2))
    Next i
    
    Result = HidD_SetFeature(Hidio.HIDHandle, ReportBuffer(0), ReportBufferLength + 1)

'    lstResults.AddItem "Report ID" & ReportIDSet.Text
'    lstResults.AddItem Hex$(ReportBuffer(1))
    
    Dim ReportData As String
    ReportData = ""
    
    If Result = 1 Then
        For i = 1 To ReportBufferLength
            ReportData = ReportData + Dec2Hex(ReportBuffer(ReportBufferLength + 1 - i), 2) + " "
        Next i
        LogResults "SetFeature: Report ID " & ReportBuffer(0) & "  " & "Data:   " & ReportData
    Else
        LogResults "SetFeature: Report ID " & ReportBuffer(0) & "   Failed"
    End If
    
    ScrollDown
End Sub

Private Sub GetInputRptButton_Click()
    Dim Result As Long
        
    If DebugMode <> True Then: On Error GoTo ENDSUB:
    
    ReDim ReadBuffer(Hidio.Capabilities.InputReportByteLength) As Byte
    'Dim ReadBuffer(64) As Byte
    Dim i As Long
    
    
    Dim nBytesToRead As Long
    nBytesToRead = Hidio.Capabilities.InputReportByteLength
    
    ReadBuffer(0) = ReportIDInputTextBox.Text
    Result = HidD_GetInputReport(Hidio.HIDHandle, ReadBuffer(0), nBytesToRead)
    
    
'    Result = ReadInputReport(ReadBuffer(), Hidio.ReadHandle, Hidio.HIDOverlapped, Hidio.Capabilities.InputReportByteLength - 1)
    
'    Call PrepareForOverlappedTransfer(Hidio.HIDOverlapped, Hidio.Security)
'
'    Dim NumberOfBytesRead As Long
'    Dim nBytesToRead As Long
'
'    nBytesToRead = 1
'
'    Result = ReadFile _
'    (Hidio.ReadHandle, _
'    ReadBuffer(0), _
'    CLng(nBytesToRead), _
'    NumberOfBytesRead, _
'    Hidio.HIDOverlapped)
'
'    Result = WaitForSingleObject(Hidio.HIDOverlapped.hEvent, 1000)
    Dim nBytesInResponse As Integer

'clear out trailing 0's
    For nBytesInResponse = Hidio.Capabilities.InputReportByteLength - 1 To 0 Step -1
        If ReadBuffer(nBytesInResponse) <> 0 Then
            GoTo NBytesFound2
        End If
    Next nBytesInResponse
NBytesFound2:

    If Result = 1 Then
        LogResults "Report ID " & ReadBuffer(0)
        For i = 1 To nBytesInResponse
            LogResults Hex$(ReadBuffer(i))
        Next i
    Else
        LogResults "Get Input Report: Report ID " & ReadBuffer(0) & "   Failed"
    End If
    
    ScrollDown
    
    Exit Sub
ENDSUB:
    LogResults "Error: This function might not be supported on your OS"
End Sub

Private Sub GetFeatureUIDButton_Click()
    Dim PreparsedData As Long
    Dim HidP_Feature As Integer
    Dim Result As Long
    Dim DataReturned As Long
    Dim RptLength As Long
    Dim UsagePage As Integer
    Dim Usage As Integer
    Dim ReportID As Integer
    Dim LinkCollection As Integer
    Dim ReportBufferLength As Integer
    Dim ReportBuffer(8) As Byte
    Dim i As Integer
    Dim LinkCollectionMatches As Boolean
    Dim ReportIDMatches As Boolean
    Dim FoundUsage As Boolean
    Dim TypeIsButton As Boolean
    Dim UsageList(255) As Integer
    Dim UsageLength As Long
    
    If DebugMode <> True Then: On Error GoTo errorhandler:
    
    If UsagePageTextBox.Text = "" Or UsageTextBox.Text = "" Then
        LogResults "Get usage id failed: Usage invalid"
        Exit Sub
    End If
    UsagePage = "&H" + UsagePageTextBox.Text
    Usage = "&H" + UsageTextBox.Text
    LinkCollection = Val(LinkCollectionTextBox.Text)

    If ReportIDUsageTextBox.Text = "" Then
        ReportID = 0
    Else
        ReportID = ReportIDUsageTextBox.Text
    End If

    For i = 0 To Hidio.TotalNumberOfFeatureCaps
        LinkCollectionMatches = False
        ReportIDMatches = False
        
        If Hidio.FeatureCaps(i).UsagePage = UsagePage Then
            If Hidio.FeatureCaps(i).Usage = Usage Then
                If LinkCollection = 0 Or Hidio.FeatureCaps(i).LinkCollection = LinkCollection Then
                    LinkCollectionMatches = True
                End If
                If ReportID = 0 Or ReportID = Hidio.FeatureCaps(i).ReportID Then
                    ReportIDMatches = True
                End If
                If ReportIDMatches And LinkCollectionMatches Then
                    ReportID = Hidio.FeatureCaps(i).ReportID
                    LinkCollection = Hidio.FeatureCaps(i).LinkCollection
                    
                    If (i < Hidio.Capabilities.NumberFeatureValueCaps) Then
                        TypeIsButton = False
                    Else
                        TypeIsButton = True
                    End If
                    
                    FoundUsage = True
                    Exit For
                End If
            End If
        End If
    Next i

    If FoundUsage = False Then
        'MsgBox ("Usage id not found")
        LogResults "Get usage id failed: Usage id not found"
        Exit Sub
    End If
    
    ReportBufferLength = Hidio.Capabilities.FeatureReportByteLength
    ReportBuffer(0) = ReportID
    Result = HidD_GetFeature(Hidio.HIDHandle, ReportBuffer(0), ReportBufferLength + 1)
        
    If Result = 0 Then
        LogResults "Get usage id failed: Failed to read report id"
        Exit Sub
    End If
    
    If UseScaledCheckBox.Value = True Then
        Result = HidP_GetScaledUsageValue(2, UsagePage, LinkCollection, _
            Usage, DataReturned, Hidio.PreparsedDataPtr, ReportBuffer(0), _
            Hidio.Capabilities.FeatureReportByteLength)
        If Result = HIDP_STATUS_VALUE_OUT_OF_RANGE Then
            'MsgBox ("Value out of range")
            LogResults "Get usage id failed: Value out of range"
            Exit Sub
        End If
    Else
        If TypeIsButton = False Then
            Result = HidP_GetUsageValue(2, UsagePage, LinkCollection, _
                Usage, DataReturned, Hidio.PreparsedDataPtr, ReportBuffer(0), _
                Hidio.Capabilities.FeatureReportByteLength)
        Else
            UsageLength = 255
            UsageList(0) = 0
            Result = HidP_GetUsages(2, UsagePage, LinkCollection, _
                UsageList(0), UsageLength, Hidio.PreparsedDataPtr, ReportBuffer(0), _
                Hidio.Capabilities.FeatureReportByteLength)
                
            DataReturned = 0
            For i = 0 To 254
                If UsageList(i) = Usage Then
                    DataReturned = 1
                End If
            Next i
        
        End If
    End If

    If Result = HIDP_STATUS_SUCCESS Then
        'SetValueTextBox.Text = DataReturned
        
        LogResults "Read Report ID:" & ReportBuffer(0) & "   Collection:" & _
            LinkCollection & "   UsagePage:" & Hex$(UsagePage) & "   UsageID:" & Hex$(Usage) & _
            "   Value = " & Hex$(DataReturned) & "     " & GetUsageName(UsagePage, Usage)
    Else
        LogResults "Failed to extract usage data from report"
    End If
    
    ScrollDown
    
    Exit Sub

errorhandler:
    LogResults "Core error"
    Exit Sub
End Sub


Private Sub SetFeatureUIDButton_Click()
    Dim PreparsedData As Long
    Dim HidP_Feature As Integer
    Dim Result As Long
    Dim DataToSend As Long
    Dim RptLength As Long
    Dim UsagePage As Integer
    Dim Usage As Integer
    Dim ReportID As Integer
    Dim LinkCollection As Integer
    Dim ReportBufferLength As Integer
    Dim ReportBuffer(8) As Byte
    Dim LinkCollectionMatches As Boolean
    Dim ReportIDMatches As Boolean
    Dim FoundUsage As Boolean
    Dim i As Integer
    
    UsagePage = "&H" + UsagePageTextBox.Text
    Usage = "&H" + UsageTextBox
    LinkCollection = LinkCollectionTextBox.Text

    ReportID = ReportIDUsageTextBox.Text

    For i = 0 To Hidio.TotalNumberOfFeatureCaps
        LinkCollectionMatches = False
        ReportIDMatches = False
        
        If Hidio.FeatureCaps(i).UsagePage = UsagePage Then
            If Hidio.FeatureCaps(i).Usage = Usage Then
                If LinkCollection = 0 Or Hidio.FeatureCaps(i).LinkCollection = LinkCollection Then
                    LinkCollectionMatches = True
                End If
                If ReportID = 0 Or ReportID = Hidio.FeatureCaps(i).ReportID Then
                    ReportIDMatches = True
                End If
                If ReportIDMatches And LinkCollectionMatches Then
                    ReportID = Hidio.FeatureCaps(i).ReportID
                    LinkCollection = Hidio.FeatureCaps(i).LinkCollection
                    FoundUsage = True
                    Exit For
                End If
            End If
        End If
    Next i
    
    If FoundUsage = False Then
        'MsgBox ("Usage id not found")
        LogResults "Get usage id failed: Usage id not found"
        Exit Sub
    End If
    
    ReportBufferLength = Hidio.Capabilities.FeatureReportByteLength
    DataToSend = Val("&H" + SetValueTextBox.Text)
    
    If UseScaledCheckBox.Value = True Then
        Result = HidP_SetScaledUsageValue(2, UsagePage, LinkCollection, _
            Usage, DataToSend, Hidio.PreparsedDataPtr, ReportBuffer(0), _
            Hidio.Capabilities.FeatureReportByteLength)
    Else
        Result = HidP_SetUsageValue(2, UsagePage, LinkCollection, _
            Usage, DataToSend, Hidio.PreparsedDataPtr, ReportBuffer(0), _
            Hidio.Capabilities.FeatureReportByteLength)
    End If
    
    If Result = HIDP_STATUS_VALUE_OUT_OF_RANGE Then
        MsgBox ("Value out of range")
        Exit Sub
    End If
    
    If Result <> HIDP_STATUS_SUCCESS Then
        MsgBox ("Set value failed")
        Exit Sub
    End If
    
    Result = HidD_SetFeature(Hidio.HIDHandle, ReportBuffer(0), ReportBufferLength)

    If Result = 1 Then
        'SetValueTextBox.Text = DataReturned
'        Dim TempVar As Long
'        Dim DataSent As Long
'        TempVar = ReportBuffer(1) + ReportBuffer(2) * 256 + ReportBuffer(3) * 65536 + ReportBuffer(4) * 16777216
'        DataSent = LongToUnsigned(TempVar)
        
        LogResults "Write Report ID:" & ReportBuffer(0) & "   Collection:" & _
            LinkCollection & "   UsagePage:" & Hex$(UsagePage) & "   UsageID:" & Hex$(Usage) & _
            "   Value = " & SetValueTextBox.Text & "     " & GetUsageName(UsagePage, Usage)
    End If
    ScrollDown

End Sub


Public Function GetUsageValue(ByRef UsagePage As Integer, ByRef Usage As Integer, ByRef LinkCollection As Integer, ByVal UseScaled As Boolean, ByRef DataOut As Long, ByRef ReportID As Integer, QuietModeLocal As Boolean)
    Dim PreparsedData As Long
    Dim HidP_Feature As Integer
    Dim Result As Long
    Dim DataReturned As Long
    Dim RptLength As Long
'    Dim UsagePage As Integer
'    Dim Usage As Integer
'    Dim ReportID As Integer
'    Dim LinkCollection As Integer
    Dim ReportBufferLength As Integer
    Dim ReportBuffer(8) As Byte
    Dim i As Integer
    Dim FoundUsage As Boolean
    Dim TypeIsButton As Boolean
    Dim LinkCollectionMatches As Boolean
    Dim ReportIDMatches As Boolean
    Dim UsageList(255) As Integer
    Dim UsageLength As Long
    
    FoundUsage = False

    For i = 0 To Hidio.TotalNumberOfFeatureCaps
        LinkCollectionMatches = False
        ReportIDMatches = False
        
        If Hidio.FeatureCaps(i).UsagePage = UsagePage Then
            If Hidio.FeatureCaps(i).Usage = Usage Then
                If LinkCollection = 0 Or Hidio.FeatureCaps(i).LinkCollection = LinkCollection Then
                    LinkCollectionMatches = True
                End If
                If ReportID = 0 Or ReportID = Hidio.FeatureCaps(i).ReportID Then
                    ReportIDMatches = True
                End If
                If ReportIDMatches And LinkCollectionMatches Then
                    ReportID = Hidio.FeatureCaps(i).ReportID
                    LinkCollection = Hidio.FeatureCaps(i).LinkCollection
                    If (i < Hidio.Capabilities.NumberFeatureValueCaps) Then
                        TypeIsButton = False
                    Else
                        TypeIsButton = True
                    End If
                    
                    FoundUsage = True
                    Exit For
                End If
            End If
        End If
    Next i

    If FoundUsage = False Then
        'MsgBox ("Usage id not found")
        
        If Not QuietModeLocal Then
            LogResults "Get usage id failed: Usage id not found"
        End If
        GetUsageValue = -1
        Exit Function
    End If
    
    ReportBufferLength = Hidio.Capabilities.FeatureReportByteLength
    ReportBuffer(0) = ReportID
    Result = HidD_GetFeature(Hidio.HIDHandle, ReportBuffer(0), ReportBufferLength + 1)
        
    If Result = 0 Then
        If Not QuietModeLocal Then
            LogResults "Get usage id failed: Failed to read report id"
        End If
        GetUsageValue = -1
        Exit Function
    End If
        
    If UseScaled = True Then
        Result = HidP_GetScaledUsageValue(2, UsagePage, LinkCollection, _
            Usage, DataReturned, Hidio.PreparsedDataPtr, ReportBuffer(0), _
            Hidio.Capabilities.FeatureReportByteLength)
        If Result = HIDP_STATUS_VALUE_OUT_OF_RANGE Then
            'MsgBox ("Value out of range")
            If Not QuietModeLocal Then
                LogResults "Get usage id failed: Value out of range"
            End If
            Exit Function
        End If
    Else
        If TypeIsButton = False Then
            Result = HidP_GetUsageValue(2, UsagePage, LinkCollection, _
                Usage, DataReturned, Hidio.PreparsedDataPtr, ReportBuffer(0), _
                Hidio.Capabilities.FeatureReportByteLength)
        Else
            UsageLength = 255
            UsageList(0) = 0
            Result = HidP_GetUsages(2, UsagePage, LinkCollection, _
                UsageList(0), UsageLength, Hidio.PreparsedDataPtr, ReportBuffer(0), _
                Hidio.Capabilities.FeatureReportByteLength)
                
            DataReturned = 0
            For i = 0 To 254
                If UsageList(i) = Usage Then
                    DataReturned = 1
                End If
            Next i

        End If
    End If

    DataOut = DataReturned
    ReportID = ReportBuffer(0)

    If Result = HIDP_STATUS_SUCCESS Then
        'SetValueTextBox.Text = DataReturned
        GetUsageValue = 1
'        LogResults "Read Report ID:" & ReportBuffer(0) & "   Collection:" & _
'            LinkCollection & "   UsagePage:" & Hex$(UsagePage) & "   UsageID:" & Hex$(usage) & _
'            "   Value = " & Hex$(DataReturned)
    End If
    
    ScrollDown

End Function

Public Function SetUsageValue(ByRef UsagePage As Integer, ByRef Usage As Integer, ByRef LinkCollection As Integer, ByVal UseScaled As Boolean, ByRef DataIn As Long, ByRef ReportID As Integer, QuietModeLocal As Boolean)
    Dim PreparsedData As Long
    Dim HidP_Feature As Integer
    Dim Result As Long
    Dim DataToSend As Long
    Dim RptLength As Long
'    Dim UsagePage As Integer
'    Dim Usage As Integer
'   Dim ReportID As Integer
'    Dim LinkCollection As Integer
    Dim ReportBufferLength As Integer
    Dim ReportBuffer(8) As Byte
    Dim i As Integer
    
    Dim FoundUsage As Boolean
    Dim LinkCollectionMatches As Boolean
    Dim ReportIDMatches As Boolean
    
    FoundUsage = False

    For i = 0 To Hidio.TotalNumberOfFeatureCaps
        LinkCollectionMatches = False
        ReportIDMatches = False
        
        If Hidio.FeatureCaps(i).UsagePage = UsagePage Then
            If Hidio.FeatureCaps(i).Usage = Usage Then
                If LinkCollection = 0 Or Hidio.FeatureCaps(i).LinkCollection = LinkCollection Then
                    LinkCollectionMatches = True
                End If
                If ReportID = 0 Or ReportID = Hidio.FeatureCaps(i).ReportID Then
                    ReportIDMatches = True
                End If
                If ReportIDMatches And LinkCollectionMatches Then
                    ReportID = Hidio.FeatureCaps(i).ReportID
                    LinkCollection = Hidio.FeatureCaps(i).LinkCollection
                    FoundUsage = True
                    Exit For
                End If
            End If
        End If
    Next i

    If FoundUsage = False Then
        'MsgBox ("Usage id not found")
        If Not QuietModeLocal Then
            LogResults "Set usage id failed: Usage id not found"
        End If
        SetUsageValue = -1
        Exit Function
    End If
    
    ReportBufferLength = Hidio.Capabilities.FeatureReportByteLength
    DataToSend = DataIn
    
    If UseScaled = True Then
        Result = HidP_SetScaledUsageValue(2, UsagePage, LinkCollection, _
            Usage, DataToSend, Hidio.PreparsedDataPtr, ReportBuffer(0), _
            Hidio.Capabilities.FeatureReportByteLength)
    Else
        Result = HidP_SetUsageValue(2, UsagePage, LinkCollection, _
            Usage, DataToSend, Hidio.PreparsedDataPtr, ReportBuffer(0), _
            Hidio.Capabilities.FeatureReportByteLength)
    End If
    
    If Result = HIDP_STATUS_VALUE_OUT_OF_RANGE Then
        'MsgBox ("Value out of range")
        If Not QuietModeLocal Then
            LogResults "Get usage id failed: Value out of range"
        End If
        SetUsageValue = -1
        Exit Function
    End If
    
    If Result <> HIDP_STATUS_SUCCESS Then
        'MsgBox ("Set value failed")
        If Not QuietModeLocal Then
            LogResults "Get usage id failed."
        End If
        SetUsageValue = -1
        Exit Function
    End If
    
    Result = HidD_SetFeature(Hidio.HIDHandle, ReportBuffer(0), ReportBufferLength)

    ReportID = ReportBuffer(0)

    If Result = 1 Then
        'SetValueTextBox.Text = DataReturned
        SetUsageValue = 1
'        LogResults "Write Report ID:" & ReportBuffer(0) & "   Collection:" & _
'            LinkCollection & "   UsagePage:" & Hex$(UsagePage) & "   UsageID:" & Hex$(usage) & _
'            "   Value = " & SetValueTextBox.Text
    End If
    ScrollDown
End Function



Private Sub tmrContinuousDataCollect_Timer()
    ScrollDown
End Sub

Private Sub OpenSCPFile_Click()

    On Error Resume Next

    With CommonDialog1
        .DialogTitle = "Open SCP File"
        .CancelError = False
        'ToDo: set the flags and attributes of the common dialog control
        .Flags = cdlOFNHideReadOnly
        .Filter = "SCP Files (*.SCP)|*.SCP|All Files (*.*)|*.*"
        .InitDir = SCPPath
        .ShowOpen
        If Len(.FileName) = 0 Then
            Exit Sub
        End If
    '    if .Action
        SCPFileName = .FileName
        .FileName = ""
    End With
    
    Dim tempname As String
    tempname = Mid(SCPFileName, InStrRev(SCPFileName, "\") + 1, Len(SCPFileName) - InStrRev(SCPFileName, "\"))
    
    SCPFileNameLabel.Caption = "SCP File: " & tempname
    
    SCPFileNameLabel.Caption = Left(SCPFileNameLabel.Caption, 41)
    
    Dim FuncNames(255) As String
    
    GetFuncNames SCPFileName, FuncNames
    ScriptsComboBox.Clear
   
    Dim i As Integer
    For i = 1 To 255
        If FuncNames(i) = "" Then
            Exit For
        End If
        ScriptsComboBox.AddItem FuncNames(i)
    Next i
    
    ScriptsComboBox.ListIndex = 0
    
    ShowLogFormulas
End Sub


Private Sub ShowAllEnumInfoButton_Click()
    Dim PreparsedData As Long
    Dim HidP_Feature As Integer
    Dim Result As Long
    Dim DataReturned As Long
    Dim RptLength As Long
    Dim UsagePage As Integer
    Dim Usage As Integer
    Dim Data As Long
    Dim ReportID As Integer
    Dim LinkCollection As Integer
    Dim ReportBufferLength As Integer
    Dim ReportBuffer(8) As Byte
    Dim i As Integer
    
    Dim UName As String
    
    'On Error Resume Next

    ReportID = -1

'    LogResults "All usage values"
'    For i = 0 To Hidio.TotalNumberOfFeatureCaps
'        UName = GetUsageName(Hidio.FeatureCaps(i).UsagePage, Hidio.FeatureCaps(i).Usage)
'        LogResults " Report ID:" & FXD(Hidio.FeatureCaps(i).ReportID, 3) & _
'        "  LinkCollection: " & Hidio.FeatureCaps(i).LinkCollection & vbTab & _
'        "0x" & Right(D2H(Hidio.FeatureCaps(i).UsagePage), 4) & _
'        ":0x" & Right(D2H(Hidio.FeatureCaps(i).Usage), 4) & _
'        "  " & UName
'
'        LogResults "ReportCount: " & Hidio.FeatureCaps(i).ReportCount
'        LogResults "BitSize: " & Hidio.FeatureCaps(i).BitSize
'        LogResults "BitField: " & Hidio.FeatureCaps(i).BitField
'        LogResults "LogicalMin: " & Hidio.FeatureCaps(i).LogicalMin
'        LogResults "LogicalMax: " & Hidio.FeatureCaps(i).LogicalMax
'        LogResults "PhysicalMin: " & Hidio.FeatureCaps(i).PhysicalMin
'        LogResults "PhysicalMax: " & Hidio.FeatureCaps(i).PhysicalMax
'        LogResults "Units: " & Hidio.FeatureCaps(i).Units
'        LogResults "UnitsExp: " & Hidio.FeatureCaps(i).UnitsExp
'        LogResults "IsRange: " & Hidio.FeatureCaps(i).IsRange
'        LogResults "IsStringRange: " & Hidio.FeatureCaps(i).IsStringRange
'        LogResults "IsAbsolute: " & Hidio.FeatureCaps(i).IsAbsolute
'        LogResults "StringIndex: " & Hidio.FeatureCaps(i).StringIndex
'    Next i
    
    Dim header As String
    Dim results As String
    
    'tabbed format:
    LogResults "All usage values"
    For i = 0 To Hidio.TotalNumberOfFeatureCaps
        UName = GetUsageName(Hidio.FeatureCaps(i).UsagePage, Hidio.FeatureCaps(i).Usage)
                
        header = header & "ReportID" & vbTab
        results = FXD(Hidio.FeatureCaps(i).ReportID, 3) & vbTab
        
        header = header & "LinkCollection" & vbTab
        results = results & Hidio.FeatureCaps(i).LinkCollection & vbTab
        
        header = header & "UsagePage" & vbTab
        results = results & "0x" & Right(D2H(Hidio.FeatureCaps(i).UsagePage), 4) & vbTab
        
        header = header & "Usage" & vbTab
        results = results & "0x" & Right(D2H(Hidio.FeatureCaps(i).Usage), 4) & vbTab
        
        header = header & "UName" & vbTab
        results = results & UName & vbTab
        
        ReportID = Hidio.FeatureCaps(i).ReportID
        Result = GetUsageValue(Hidio.FeatureCaps(i).UsagePage, Hidio.FeatureCaps(i).Usage, Hidio.FeatureCaps(i).LinkCollection, 0, Data, ReportID, False)
        WaitMIN_DELAY
        If Result = 1 Then
            header = header & "CurrentValue" & vbTab
            results = results & Hex$(Data) & vbTab
        End If
        
        header = header & "ReportCount: " & vbTab
        results = results & Hidio.FeatureCaps(i).ReportCount & vbTab
        
        header = header & "BitSize: " & vbTab
        results = results & Hidio.FeatureCaps(i).BitSize & vbTab
        
        header = header & "BitField: " & vbTab
        results = results & Hidio.FeatureCaps(i).BitField & vbTab
        
        header = header & "LogicalMin: " & vbTab
        results = results & Hidio.FeatureCaps(i).LogicalMin & vbTab
        
        header = header & "LogicalMax: " & vbTab
        results = results & Hidio.FeatureCaps(i).LogicalMax & vbTab
        
        header = header & "PhysicalMin: " & vbTab
        results = results & Hidio.FeatureCaps(i).PhysicalMin & vbTab
        
        header = header & "PhysicalMax: " & vbTab
        results = results & Hidio.FeatureCaps(i).PhysicalMax & vbTab
        
        header = header & "Units: " & vbTab
        results = results & Hidio.FeatureCaps(i).Units & vbTab
        
        header = header & "UnitsExp: " & vbTab
        results = results & Hidio.FeatureCaps(i).UnitsExp & vbTab
        
        header = header & "IsRange: " & vbTab
        results = results & Hidio.FeatureCaps(i).IsRange & vbTab
        
        header = header & "IsStringRange: " & vbTab
        results = results & Hidio.FeatureCaps(i).IsStringRange & vbTab
        
        header = header & "IsAbsolute: " & vbTab
        results = results & Hidio.FeatureCaps(i).IsAbsolute & vbTab
        
        header = header & "StringIndex: " & vbTab
        results = results & Hidio.FeatureCaps(i).StringIndex & vbTab
        
        header = header & "ButtonType? " & vbTab
        If (i < Hidio.Capabilities.NumberFeatureValueCaps) Then
            results = results & "False" & vbTab
        Else
            results = results & "True" & vbTab
        End If
       
        If i = 0 Then: LogResults header
        LogResults results
    Next i
End Sub

Private Sub ShowAllInputs_Click()
    Dim PreparsedData As Long
    Dim HidP_Feature As Integer
    Dim Result As Long
    Dim DataReturned As Long
    Dim RptLength As Long
    Dim UsagePage As Integer
    Dim Usage As Integer
    Dim ReportID As Integer
    Dim LinkCollection As Integer
    Dim ReportBufferLength As Integer
    Dim ReportBuffer(8) As Byte
    Dim i As Integer
    
    Dim UName As String
    
    'On Error Resume Next

    ReportID = -1

    LogResults "All usage values"
    For i = 0 To Hidio.Capabilities.NumberInputValueCaps - 1
        UName = GetUsageName(Hidio.InputCaps(i).UsagePage, Hidio.InputCaps(i).Usage)
        LogResults " Report ID:" & FXD(Hidio.InputCaps(i).ReportID, 3) & "  LinkCollection: " & Hidio.InputCaps(i).LinkCollection & vbTab & "0x" & Right(D2H(Hidio.InputCaps(i).UsagePage), 4) & ":0x" & Right(D2H(Hidio.InputCaps(i).Usage), 4) & "  " & UName & vbTab
    Next i
End Sub

Private Sub ShowAllUsages_Click()
    Dim PreparsedData As Long
    Dim HidP_Feature As Integer
    Dim Result As Long
    Dim DataReturned As Long
    Dim RptLength As Long
    Dim UsagePage As Integer
    Dim Usage As Integer
    Dim ReportID As Integer
    Dim LinkCollection As Integer
    Dim ReportBufferLength As Integer
    Dim ReportBuffer(8) As Byte
    Dim i As Integer
    
    Dim UName As String
    
    'On Error Resume Next

    ReportID = -1

    LogResults "All usage values"
    For i = 0 To Hidio.TotalNumberOfFeatureCaps
        UName = GetUsageName(Hidio.FeatureCaps(i).UsagePage, Hidio.FeatureCaps(i).Usage)
        LogResults " Report ID:" & FXD(Hidio.FeatureCaps(i).ReportID, 3) & "  LinkCollection: " & Hidio.FeatureCaps(i).LinkCollection & vbTab & "0x" & Right(D2H(Hidio.FeatureCaps(i).UsagePage), 4) & ":0x" & Right(D2H(Hidio.FeatureCaps(i).Usage), 4) & "  " & UName & vbTab
    Next i
End Sub

Private Sub GetAllUsages_Click()
    Dim PreparsedData As Long
    Dim HidP_Feature As Integer
    Dim Result As Long
    Dim Data As Long
    Dim DataReturned As Long
    Dim RptLength As Long
    Dim UsagePage As Integer
    Dim Usage As Integer
    Dim ReportID As Integer
    Dim LinkCollection As Integer
    Dim i As Integer
    
    Dim UName As String
    
    'On Error Resume Next

    ReportID = -1

    LogResults "All usage values"
    For i = 0 To Hidio.TotalNumberOfFeatureCaps
        UName = GetUsageName(Hidio.FeatureCaps(i).UsagePage, Hidio.FeatureCaps(i).Usage)
        'LogResults " Report ID:" & FXD(Hidio.FeatureCaps(i).ReportID, 3) & "  LinkCollection: " & Hidio.FeatureCaps(i).LinkCollection & vbTab & "0x" & Right(D2H(Hidio.FeatureCaps(i).UsagePage), 4) & ":0x" & Right(D2H(Hidio.FeatureCaps(i).Usage), 4) & "  " & UName & vbTab

        ReportID = Hidio.FeatureCaps(i).ReportID
        Result = GetUsageValue(Hidio.FeatureCaps(i).UsagePage, Hidio.FeatureCaps(i).Usage, Hidio.FeatureCaps(i).LinkCollection, 0, Data, ReportID, False)
    
        WaitMIN_DELAY
        If Result = 1 Then
            LogResults "Read Report ID:" & ReportID & "   Collection:" & _
                Hidio.FeatureCaps(i).LinkCollection & "   UsagePage:" & Hex$(Hidio.FeatureCaps(i).UsagePage) & "   UsageID:" & Hex$(Hidio.FeatureCaps(i).Usage) & _
                "   Value = " & Hex$(Data) & "     " & GetUsageName(Hidio.FeatureCaps(i).UsagePage, Hidio.FeatureCaps(i).Usage)
        Else
            LogResults "Failed to read Report ID: " & ReportID
        End If
    Next i
End Sub

Private Sub StartLoggingButton_Click()
    If StartLoggingButton.Caption = "Stop" Then
        
        DataLoggingTimer.Enabled = False
        StartLoggingButton.Caption = "Start Logging"
        Exit Sub
    End If
        
    DataLoggingTimer.Interval = LogIntervalTextBox.Text * 1000
    
    Dim DataLog As String
    Dim i As Integer
    
    DataLog = ""
    
    For i = 0 To 4
        DataLog = DataLog & ItemNamesTextBox.Item(i).Text & vbTab
    Next i
    
    For i = 5 To 7
        If MeterLogEnableCheckbox(i - 5) = 1 Then
            DataLog = DataLog & ItemNamesTextBox.Item(i).Text & vbTab
        End If
    Next i
    
    RunScript SCPFileName, "LOGSETUP"
    
    LogResults "Selected Map file: " & MapFileNameLabel.Caption
    
    LogResults LogFileNotesField.Text
    LogResults DataLog
    
    DataLoggingTimer.Enabled = True
    StartLoggingButton.Caption = "Stop"
    
'    If LogToResults.Value = True Then
'        lstResults.AddItem Time & vbTab & DataLog
'    Else
'        LogFile.WriteLine Time & vbTab & DataLog
'        lstResults.AddItem Time & vbTab & DataLog
'    End If
End Sub

Private Sub EndNVRAddressTextBox_GotFocus()
    With EndNVRAddressTextBox
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub

Private Sub StartNVRAddressTextBox_GotFocus()
    With StartNVRAddressTextBox
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub

Private Sub UpdateUPSStatusButton_Click()
    UPSStatusListBox.Clear
    RunScript SCPFileName, "STATUS"
    ScrollUPSStatsDown
End Sub

Private Sub UsagePageTextBox_GotFocus()
    With UsagePageTextBox
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub

Private Sub UsageTextBox_GotFocus()
    With UsageTextBox
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub

Private Sub SetValueTextBox_GotFocus()
    With SetValueTextBox
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub

Private Sub WriteAllRamButton_Click()
    Dim retval As Long
    Dim Data As Long
    Dim UsagePage As Integer
    Dim Usage As Integer
    Dim LinkCollection As Integer
    Dim ReportID As Integer
    Dim Address As Integer
    Dim Row As Integer
    Dim DataString As String
    
    Address = 0
    AbortFunction = False
    WritePasswordButton_Click
    
    WaitMIN_DELAY

'replace this with something else..
'    CoolFlex2.Clear
'    CoolFlex2.TextMatrix(0, 0) = "Addr (Hex)"
'    CoolFlex2.TextMatrix(0, 1) = "Data (Hex)"
    
    Row = 0
    For Row = 0 To 255
BeginLoop:
    
        If AbortFunction = True Then
            Exit Sub
        End If
    
         If Row = 256 Then
            LogResults "Wrote all checked ram locations"
            Exit Sub
        End If
        
'        'address out of range
'        If Val("&H" + CoolFlex1.TextMatrix(Row + 1, 0)) < Val("&H" + StartNVRAddressTextBox.Text) Then
'            Row = Row + 1
'            GoTo BeginLoop      'continue
'        End If
        
        If CoolFlex2.TextMatrix(Row + 1, 1) = "" Then
            'If address field is blank for the current row, then do not do the read
            Row = Row + 1
            GoTo BeginLoop      'continue
        End If
        
        If CoolFlex2.TextMatrix(Row + 1, 3) <> "C" Then
            'If address field is blank for the current row, then do not do the read
            Row = Row + 1
            GoTo BeginLoop      'continue
        End If
        
        'row is checked, so write it:
        
        lstResults.List(lstResults.ListIndex) = "Writing RAM: " + CoolFlex2.TextMatrix(Row + 1, 1)
        
        If CypressRadioOpt.Value = True Then
            Address = Val("&H" + CoolFlex2.TextMatrix(Row + 1, 1))
            Data = Val("&H" + CoolFlex2.TextMatrix(Row + 1, 2))
            
            'ram write
            DataString = ColonCmd(Val("&H2B"), "&H" & FXD(D2H(Address), 4) & FXD(D2H(Data), 2) & "58", 4, True)
            
            If H2D(Mid(DataString, 3, 4)) <> Address Or DataString = "-1" Then
                retval = 0
            Else
                retval = 1
                Data = H2D(Mid(DataString, 7, 2))
            End If
        Else
            UsagePage = "&HFFFF"
            Usage = "&HC3"
                   
            LinkCollection = 0
            ReportID = 153
            Data = Val("&H" + CoolFlex2.TextMatrix(Row + 1, 1))
            retval = 0
            retval = SetUsageValue(UsagePage, Usage, LinkCollection, 0, Data, ReportID, False)
            
            If retval <> 1 Then
                LogResults "Failed to write address"
                Exit Sub
            End If
            
            WaitMIN_DELAY
        
            'Write RAM value
            Usage = "&HC2"
            LinkCollection = 0
            ReportID = 152
            Data = Val("&H" + CoolFlex2.TextMatrix(Row + 1, 2))
            retval = SetUsageValue(UsagePage, Usage, LinkCollection, 0, Data, ReportID, False)
            
            WaitMIN_DELAY
        End If
        
        If retval = 1 Then
            LogResults "Wrote Ram Location 0x" & CoolFlex2.TextMatrix(Row + 1, 1) & " value=" & CoolFlex2.TextMatrix(Row + 1, 2)
        Else
            LogResults "Failed to write RAM"
            Exit Sub
        End If
    Next Row
    
    LogResults "Read configured RAM table."
    ScrollDown
End Sub

Public Sub WritePasswordButton_Click()
    Dim retval As Long
    Dim Data As Long
    Dim UsagePage As Integer
    Dim Usage As Integer
    Dim LinkCollection As Integer
    Dim ReportID As Integer
    Dim DataString As String
    
    If CypressRadioOpt.Value = True Then
        DataString = ColonCmd(Val("&H2E"), "&H866E1942", 4, True)
        If DataString <> "-1" Then
            retval = 1
        Else
            retval = 0
        End If
    Else
        UsagePage = "&HFFFF"
        Usage = "&HC4"
        LinkCollection = 0
        ReportID = 0
        Data = "&H866E1942"
        retval = SetUsageValue(UsagePage, Usage, LinkCollection, 0, Data, ReportID, False)
    End If
    If retval = 1 Then
        LogResults "Production test Password written and accepted"
    Else
        LogResults "Production test Password written and failed"
    End If
End Sub

Private Sub ReadRamButton_Click()
    Dim retval As Long
    Dim Data As Long
    Dim UsagePage As Integer
    Dim Usage As Integer
    Dim LinkCollection As Integer
    Dim ReportID As Integer
    Dim Address As Integer
    Dim DataString As String
    
    Address = Val("&H" + RAMAddressTextBox.Text)
    If CypressRadioOpt.Value = True Then
        
        If PageRamCheckBox.Value = 1 Then
            LogResults "Page ram access not supported for cypress parts"
            DataString = "-1"
        Else
            DataString = ColonCmd(Val("&H2A"), "&H" & FXD(D2H(Address), 4) & "0058", 4, True)
        End If
        
        If H2D(Mid(DataString, 3, 4)) <> Address Or DataString = "-1" Then
            retval = 0
        Else
            retval = 1
            Data = H2D(Mid(DataString, 7, 2))
        End If
    Else
        WritePasswordButton_Click
        
        WaitMIN_DELAY
        
        UsagePage = "&HFFFF"
        Usage = "&HC3"
        LinkCollection = 0
        ReportID = 0
        Data = Val("&H" + RAMAddressTextBox.Text)
        retval = 0
        retval = SetUsageValue(UsagePage, Usage, LinkCollection, 0, Data, ReportID, False)
        
        If retval <> 1 Then
            LogResults "Failed to write address"
            Exit Sub
        End If
        
        WaitMIN_DELAY
        
        If PageRamCheckBox.Value = 1 Then
            Usage = "&HD3"
        Else
            Usage = "&HC2"
        End If
        LinkCollection = 0
        ReportID = 0
        Data = -1
        retval = GetUsageValue(UsagePage, Usage, LinkCollection, 0, Data, ReportID, False)
    End If
    
    Dim tempstring As String
    If PageRamCheckBox.Value = 1 Then
        tempstring = "Page "
    Else
        tempstring = ""
    End If
    
    If retval = 1 Then
        LogResults tempstring + "Read Ram: Address = " + RAMAddressTextBox.Text + " Data = " + Hex$(Data)
    Else
        LogResults "Failed to read ram"
    End If
    ScrollDown
End Sub

Private Sub WriteRamButton_Click()
    Dim retval As Long
    Dim Data As Long
    Dim UsagePage As Integer
    Dim Usage As Integer
    Dim LinkCollection As Integer
    Dim ReportID As Integer
    Dim Address As Integer
    Dim DataString As String
    
    Address = Val("&H" + RAMAddressTextBox.Text)
    Data = Val("&H" + RAMDataTextBox.Text)
    If CypressRadioOpt.Value = True Then
        If PageRamCheckBox.Value = 1 Then
            LogResults "Page ram access not supported for cypress parts"
            DataString = "-1"
        Else
            DataString = ColonCmd(Val("&H2B"), "&H" & FXD(D2H(Address), 4) & FXD(D2H(Data), 2) & "58", 4, True)
        End If
        
        If H2D(Mid(DataString, 3, 4)) <> Address Or DataString = "-1" Then
            retval = 0
        Else
            retval = 1
            Data = H2D(Mid(DataString, 7, 2))
        End If
    Else
        WritePasswordButton_Click
        
        WaitMIN_DELAY
        
        UsagePage = "&HFFFF"
        Usage = "&HC3"
        LinkCollection = 0
        ReportID = 0
        Data = Val("&H" + RAMAddressTextBox.Text)
        retval = 0
        retval = SetUsageValue(UsagePage, Usage, LinkCollection, 0, Data, ReportID, False)
        
        If retval <> 1 Then
            LogResults "Failed to write address"
            Exit Sub
        End If
        
        WaitMIN_DELAY
    
        If PageRamCheckBox.Value = 1 Then
            Usage = "&HD3"
        Else
            Usage = "&HC2"
        End If
        LinkCollection = 0
        ReportID = 0
        Data = Val("&H" + RAMDataTextBox.Text)
        retval = SetUsageValue(UsagePage, Usage, LinkCollection, 0, Data, ReportID, False)
    End If
    
    Dim tempstring As String
    
    If PageRamCheckBox.Value = 1 Then
        tempstring = "Page "
    Else
        tempstring = ""
    End If
    
    If retval = 1 Then
        LogResults tempstring + "Write Ram: Address = " + RAMAddressTextBox.Text + " Data = " + Hex$(Data)
    Else
        LogResults "Failed to write ram"
    End If
    ScrollDown
End Sub

Private Sub ReadRangeNVRButton_Click()
    Dim retval As Long
    Dim Data As Long
    Dim UsagePage As Integer
    Dim Usage As Integer
    Dim LinkCollection As Integer
    Dim ReportID As Integer
    Dim Address As Integer
    Dim Row As Integer
    Dim DataString As String
    
    Address = 0
    AbortFunction = False
    WritePasswordButton_Click
    
    WaitMIN_DELAY

    ReadRangeNVRButton.Enabled = False
   
    CoolFlex1.Clear
    CoolFlex1.TextMatrix(0, 0) = "Addr (Hex)"
    CoolFlex1.TextMatrix(0, 1) = "Data (Hex)"
    
    Row = 0
    For Address = Val("&H" + StartNVRAddressTextBox.Text) To Val("&H" + EndNVRAddressTextBox.Text)
        lstResults.List(lstResults.ListIndex) = "Reading NVR: " + Hex$(Address)
        DoEvents
        
        If AbortFunction = True Then
            WriteRangeNVRButton.Enabled = True
            ReadRangeNVRButton.Enabled = True
            Exit Sub
        End If
        
        If CypressRadioOpt.Value = True Then
            'read NVR value:
            If NVRRadioOpt.Value = True Then
                'nvr read
                DataString = ColonCmd(Val("&H2C"), "&H" & FXD(D2H(Address), 4) & "0058", 4, True)
            Else
                'ram read
                DataString = ColonCmd(Val("&H2A"), "&H" & FXD(D2H(Address), 4) & "0058", 4, True)
            End If
            If H2D(Mid(DataString, 3, 4)) <> Address Or DataString = "-1" Then
                retval = 0
            Else
                Data = H2D(Mid(DataString, 7, 2))
                retval = 1
            End If
        Else
            UsagePage = "&HFFFF"
            If NVRRadioOpt.Value = True Then
                Usage = "&HC1"
            Else
                Usage = "&HC3"
            End If
            LinkCollection = 0
            ReportID = 0
            Data = Address
            retval = 0
            retval = SetUsageValue(UsagePage, Usage, LinkCollection, 0, Data, ReportID, False)
            If retval <> 1 Then
                LogResults "Failed to write address"
                ReadRangeNVRButton.Enabled = True
                Exit Sub
            End If
            
            WaitMIN_DELAY
            
            If NVRRadioOpt.Value = True Then
                Usage = "&HC0"
            Else
                Usage = "&HC2"
            End If
            LinkCollection = 0
            ReportID = 0
            Data = -1
            retval = GetUsageValue(UsagePage, Usage, LinkCollection, 0, Data, ReportID, False)
        
            WaitMIN_DELAY
        
        End If
    
        If retval = 1 Then
            'LogResults TempString + "Read Ram: Address = " + RAMAddressTextBox.Text + " Data = " + Hex$(Data)
            CoolFlex1.TextMatrix(Row + 1, 0) = Hex$(Address)
            CoolFlex1.TextMatrix(Row + 1, 1) = Hex$(Data)
            Row = Row + 1
        Else
            LogResults "Failed to read NVR/RAM"
            ReadRangeNVRButton.Enabled = True
            Exit Sub
        End If
    
    Next Address
    
    If NVRRadioOpt.Value = True Then
        LogResults "Read NVR range from: " + StartNVRAddressTextBox.Text + " to " + EndNVRAddressTextBox.Text
    Else
        LogResults "Read RAM range from: " + StartNVRAddressTextBox.Text + " to " + EndNVRAddressTextBox.Text
    End If
    ReadRangeNVRButton.Enabled = True
    ScrollDown
End Sub


Private Sub WriteRangeNVRButton_Click()
    Dim retval As Long
    Dim Data As Long
    Dim UsagePage As Integer
    Dim Usage As Integer
    Dim LinkCollection As Integer
    Dim ReportID As Integer
    Dim Row As Integer
    Dim Address As Integer
    Dim DataString As String
    
    AbortFunction = False
    WritePasswordButton_Click
    
    WaitMIN_DELAY
    
    WriteRangeNVRButton.Enabled = False
    
    Row = 0
    For Row = 0 To 255
BeginLoop:
    
        If AbortFunction = True Then
            WriteRangeNVRButton.Enabled = True
            ReadRangeNVRButton.Enabled = True
            Exit Sub
        End If
    
         If Row = 256 Then
            LogResults "Wrote NVR/RAM range"
            WriteRangeNVRButton.Enabled = True
            Exit Sub
        End If
        
        'address out of range
        If Val("&H" + CoolFlex1.TextMatrix(Row + 1, 0)) < Val("&H" + StartNVRAddressTextBox.Text) Then
            Row = Row + 1
            GoTo BeginLoop      'continue
        End If
        
        If CoolFlex1.TextMatrix(Row + 1, 0) = "" Or Val("&H" + CoolFlex1.TextMatrix(Row + 1, 0)) > Val("&H" + EndNVRAddressTextBox.Text) Then
            'If address field is blank for the current row, then do not do the write
            LogResults "Wrote NVR range"
            WriteRangeNVRButton.Enabled = True
            Exit Sub
        End If
        
        If NVRRadioOpt.Value = True Then
            lstResults.List(lstResults.ListIndex) = "Writing NVR: " + CoolFlex1.TextMatrix(Row + 1, 0)
        Else
            lstResults.List(lstResults.ListIndex) = "Writing RAM: " + CoolFlex1.TextMatrix(Row + 1, 0)
        End If
        
        Address = Val("&H" + CoolFlex1.TextMatrix(Row + 1, 0))
        Data = Val("&H" + CoolFlex1.TextMatrix(Row + 1, 1))
        
        If CypressRadioOpt.Value = True Then
            'read NVR value:
            If NVRRadioOpt.Value = True Then
                'nvr write
                DataString = ColonCmd(Val("&H2D"), "&H" & FXD(D2H(Address), 4) & FXD(D2H(Data), 2) & "58", 4, True)
                If DataString <> "-1" Then
                    DataString = ColonCmd(Val("&H2C"), "&H" & FXD(D2H(Address), 4) & "0058", 4, True)
                    Data = Val(DataString)
                End If
            Else
                'ram write
                DataString = ColonCmd(Val("&H2B"), "&H" & FXD(D2H(Address), 4) & FXD(D2H(Data), 2) & "58", 4, True)
                If DataString <> "-1" Then
                    DataString = ColonCmd(Val("&H2A"), "&H" & FXD(D2H(Address), 4) & "0058", 4, True)
                    Data = Val(DataString)
                End If
            End If
            If H2D(Mid(DataString, 3, 4)) <> Address Or DataString = "-1" Then
                retval = 0
            Else
                Data = H2D(Mid(DataString, 7, 2))
                retval = 1
            End If
        Else
            UsagePage = "&HFFFF"
            If NVRRadioOpt.Value = True Then
                Usage = "&HC1"
            Else
                Usage = "&HC3"
            End If
                   
            LinkCollection = 0
            ReportID = 0
            Data = Val("&H" + CoolFlex1.TextMatrix(Row + 1, 0))
            retval = 0
            retval = SetUsageValue(UsagePage, Usage, LinkCollection, 0, Data, ReportID, False)
            
            WaitMIN_DELAY
            
            If retval <> 1 Then
                LogResults "Failed to write address"
                WriteRangeNVRButton.Enabled = True
                Exit Sub
            End If
            
            'Write NVR value
            If NVRRadioOpt.Value = True Then
                Usage = "&HC0"
            Else
                Usage = "&HC2"
            End If
            LinkCollection = 0
            ReportID = 0
            Data = Val("&H" + CoolFlex1.TextMatrix(Row + 1, 1))
            retval = SetUsageValue(UsagePage, Usage, LinkCollection, 0, Data, ReportID, False)
            
            WaitMIN_DELAY
            
            'Check that the value was written properly
            If NVRRadioOpt.Value = True Then
                Usage = "&HC0"
            Else
                Usage = "&HC2"
            End If
            LinkCollection = 0
            ReportID = 0
            Data = -1
            retval = GetUsageValue(UsagePage, Usage, LinkCollection, 0, Data, ReportID, False)
    
            WaitMIN_DELAY
        End If
        
        If NVRRadioOpt.Value = True Then
            If Data <> Val("&H" + CoolFlex1.TextMatrix(Row + 1, 1)) Then
                LogResults "Failed to write NVR: Data didn't match"
                WriteRangeNVRButton.Enabled = True
                Exit Sub
            End If
        Else
            If Data <> Val("&H" + CoolFlex1.TextMatrix(Row + 1, 1)) Then
                'Data didnt match on RAM write, ignore..
                LogResults "Either failed to write, or data changed immediately after the RAM write"
            End If
        End If
        
        If retval = 1 Then
            'LogResults TempString + "Write Ram: Address = " + RAMAddressTextBox.Text + " Data = " + Hex$(Data)
        Else
            LogResults "Failed to write NVR/RAM"
            WriteRangeNVRButton.Enabled = True
            Exit Sub
        End If
    Next Row
    
    If NVRRadioOpt.Value = True Then
        LogResults "Wrote NVR range"
    Else
        LogResults "Wrote RAM range"
    End If
    WriteRangeNVRButton.Enabled = True
    ScrollDown
End Sub

Public Function ColonCmd(Cmd As Byte, Data As String, nDataBytes As Integer, DisplayInHex As Boolean) As String
    Dim i As Integer
    Dim j As Integer
    Dim DataIn As String
    
    'strip leading &H
    i = InStr(1, Data, "&H")
    If i <> 0 Then
        DataIn = Mid(Data, 3, Len(Data) - 2)
    End If
    
    Dim TempInput As String
    Dim TempReturn As String
    
    WriteCypressCmd Cmd, DataIn, nDataBytes, True
    For i = 1 To 40     '1 second timeout
        WAIT_mSECS 25   'polling rate
        ColonCmd = ReadCypressCmd(DisplayInHex, True)
        If ColonCmd = "-1" Then
            i = i + 20      'give it 2 chances..  (2 seconds)
        End If
        If DisplayInHex Then
            If Left(ColonCmd, 2) = FXD(D2H(Cmd), 2) Then GoTo CMD_DONE
        Else
            If ColonCmd = "" Then GoTo INVALIDRESPONSE
            TempReturn = ""
            TempInput = ColonCmd
            'perform ascii to hex conversion..
            Do
                If Left(TempInput, 1) = "{" Then
                    'hex character..
                    j = InStr(1, TempInput, "}")
                    If j - 1 > 3 Or j = 0 Then
                        LogResults "Error in data to send"
                        'GoTo ERROR
                    End If
                    TempReturn = TempReturn & FXD(Mid(TempInput, 2, j - 2), 2)
                    TempInput = Right(TempInput, Len(TempInput) - j)
                ElseIf Left(TempInput, 1) = "[" Then
                    'hex character..
                    j = InStr(1, TempInput, "]")
                    If j - 1 <> 3 Or j = 0 Then
                        LogResults "Error in data to send"
                        'GoTo ERROR
                    End If
                    If UCase(Mid(TempInput, 2, j - 2)) = "CR" Then
                        TempReturn = TempReturn & "0D"
                    End If
                    If UCase(Mid(TempInput, 2, j - 2)) = "LF" Then
                        TempReturn = TempReturn & "0A"
                    End If
                    TempInput = Right(TempInput, Len(TempInput) - j)
                Else
                    'ascii character..
                    TempReturn = TempReturn & FXD(D2H(Asc(Left(TempInput, 1))), 2)
                    TempInput = Mid(TempInput, 2, Len(TempInput))
                End If
                
                If TempInput = "" Then GoTo DONECONVERSION
            Loop
DONECONVERSION:
    'TempReturn is a Hex string at this point.
            If H2D(Left(TempReturn, 2)) = Cmd Then GoTo CMD_DONE
        End If
INVALIDRESPONSE:
    Next i

CMD_DONE:
    If i >= 40 Then          'response doesn't match request
        ColonCmd = "-1"
    ElseIf i < 3 Then
        WAIT_mSECS 250      'Force a delay between the commands..
    End If
End Function

Public Function WriteCypressCmd(Cmd As Byte, Data As String, nDataBytes As Integer, QuietMode As Boolean) As Boolean
    Dim TempPacket As String
    Dim TempData As String
    ReDim ReportBuffer(80) As Byte
    Dim i As Integer
    Dim ChkSum As Integer
    Dim Result As Long
    Dim TempReturn As String
    Dim NumberOfBytesWritten As Long

    TempData = FXD(Data, nDataBytes * 2)
    
    'all characters are in hex
    TempPacket = "003A" & FXD(D2H(Cmd), 2) & TempData

    For i = 0 To Hidio.Capabilities.OutputReportByteLength
        ReportBuffer(i) = 0
    Next i
    
    'load packet into bytes:
    For i = 0 To Len(TempPacket) / 2
        ReportBuffer(i) = Val("&H" + Mid(TempPacket, i * 2 + 1, 2))
    Next i
    
    'Add Checksum:
    ChkSum = 0
    For i = 2 To Len(TempPacket) / 2        'The : is not included in the checksum
        ChkSum = ChkSum + ReportBuffer(i)
    Next i
    ChkSum = ChkSum And 255         'get low byte
    ChkSum = 255 - ChkSum           'ones complement checksum
    ReportBuffer(Len(TempPacket) / 2) = ChkSum             'last byte is checksum
    ReportBuffer((Len(TempPacket) / 2) + 1) = Val("&H0D")      'Very last byte is [CR]
    
    Dim nBytesToWrite As Integer
    nBytesToWrite = Len(TempPacket) / 2
    nBytesToWrite = nBytesToWrite + 2       '+2 for checksum and [CR]
    
    TempReturn = ""
    For i = 0 To nBytesToWrite - 1
        TempReturn = TempReturn & FXD(D2H(ReportBuffer(i)), 2) + " "
    Next i
    
NumberOfBytesWritten = 0

Result = WriteFile _
    (Hidio.HIDHandle, _
    ReportBuffer(0), _
    CLng(Hidio.Capabilities.OutputReportByteLength), _
    NumberOfBytesWritten, _
    0)

    Dim DataSent As String
    Dim nBytesSent As Integer
    
'clear out trailing 0's
    For nBytesSent = Hidio.Capabilities.InputReportByteLength - 1 To 0 Step -1
        If ReportBuffer(nBytesSent) <> 0 Then
            GoTo NBytesFound
        End If
    Next nBytesSent
NBytesFound:
    
    For i = 1 To nBytesSent
        If ReportBuffer(i) >= Val("&H30") And ReportBuffer(i) <= Val("&H7A") Then
            DataSent = DataSent & Chr(ReportBuffer(i))
        Else
            DataSent = DataSent & "{" & FXD(D2H(ReportBuffer(i)), 2) & "}"
        End If
    Next i
    
    WrittenData = DataSent
    
    DataSent = "Data Sent ASCII:" & DataSent
    
    DataSent = DataSent & "   HEX:"
    
    For i = 1 To nBytesSent
        DataSent = DataSent & FXD(D2H(ReportBuffer(i)), 2) & " "
    Next i
   
'display result, pass or fail..
    If Result = 1 Then
        If Not QuietMode Then LogResults DataSent
        WriteCypressCmd = True
    Else
        If Not QuietMode Then LogResults DataSent & "   Failed"
        WriteCypressCmd = False
    End If
    ScrollDown
End Function

Public Function ReadCypressCmd(DisplayInHex As Boolean, QuietMode As Boolean) As String
    Dim ReportOut As String
    Dim Result As Integer
    Dim i As Integer
    Dim nBytesInResponse As Integer
    
    ReDim ReadBuffer(Hidio.Capabilities.InputReportByteLength) As Byte
    
    Result = ReadInputReport(ReadBuffer(), Hidio.ReadHandle, Hidio.HIDOverlapped, Hidio.Capabilities.InputReportByteLength)
    If Result = False Then
        ReadCypressCmd = "-1"
        Exit Function
    End If
'clear out trailing 0's
    For nBytesInResponse = Hidio.Capabilities.InputReportByteLength - 1 To 0 Step -1
        If ReadBuffer(nBytesInResponse) <> 0 Then
            GoTo NBytesFound2
        End If
    Next nBytesInResponse
NBytesFound2:

    For i = 1 To nBytesInResponse
        If ReadBuffer(i) >= Val("&H30") And ReadBuffer(i) <= Val("&H7A") Then
            ReportOut = ReportOut & Chr(ReadBuffer(i))
        Else
            ReportOut = ReportOut & "{" & FXD(D2H(ReadBuffer(i)), 2) & "}"
        End If
    Next i
    
    If DisplayInHex = False Then
        ReadCypressCmd = ReportOut
    Else
        ReadCypressCmd = ""
    End If
    
    'prepend Data Received ASCII:
    ReportOut = "Data Received ASCII:  " & ReportOut
    
    ReportOut = ReportOut & "   HEX: "
       
    For i = 1 To nBytesInResponse
        ReportOut = ReportOut & FXD(D2H(ReadBuffer(i)), 2) & " "
        If DisplayInHex = True Then
            ReadCypressCmd = ReadCypressCmd & FXD(D2H(ReadBuffer(i)), 2)
        End If
    Next i
        
    If Not QuietMode Then LogResults ReportOut
    
    ScrollDown
End Function


Public Sub Display(ByVal Stringval As Variant)
    Dim tempstring As String
    
    tempstring = Stringval
    If LogToResultsCheckBox.Value = 1 Then
        LogResults tempstring
    End If
    UPSStatusListBox.AddItem Stringval
End Sub

Public Function GetStringReport(ReportID As Integer)
    Dim StringBuffer(100) As Byte
    Dim StringOut As String
    Dim StringIndex As Integer
    Dim retval As Integer
    Dim ReportBufferLength As Integer
    Dim ReportBuffer(64) As Byte        'max length = 64 limited by HID.
    Dim Result As Long

    ReportBuffer(0) = ReportID
    ReportBufferLength = GetFeatureLength(ReportID, Hidio.FeatureCaps(), Hidio.TotalNumberOfFeatureCaps) / 8
    
    'diag for overloading the report buffer length:
    'ReportBufferLength = 64
    
    Result = HidD_GetFeature(Hidio.HIDHandle, ReportBuffer(0), ReportBufferLength + 1)

    Dim i As Integer
    Dim ReportData As String
    ReportData = ""
    
    'msgbox "String Index = " & str(ReportBuffer(1))
    
    StringIndex = ReportBuffer(1)
    retval = HidD_GetIndexedString(Hidio.HIDHandle, StringIndex, StringBuffer(0), 100)
    
    If retval = 0 Then
        'fail.. ignore the failure..
    End If
    
    StringOut = StringBuffer
    'UPSStatusListBox.AddItem "String Index:" & StringIndex & "  " & DisplayString & "   " & StringOut
    GetStringReport = StringOut
    
    WaitMIN_DELAY
End Function

Public Function GetString(StringIndex As Integer)
    Dim StringBuffer(100) As Byte
    Dim StringOut As String
    Dim retval As Integer
    
    retval = HidD_GetIndexedString(Hidio.HIDHandle, StringIndex, StringBuffer(0), 100)
    
    If retval = 0 Then
        'fail.. ignore the failure..
    End If
    
    StringOut = StringBuffer
    'UPSStatusListBox.AddItem "String Index:" & StringIndex & "  " & DisplayString & "   " & StringOut
    GetString = StringOut
    
    WaitMIN_DELAY
End Function

Public Function SetUsage(UsagePage As Integer, Usage As Integer, ReportID As Integer, ByVal Data As String) As Variant
    Dim LinkCollection As Integer
    Dim retval As Integer
    Dim DataIn As Long

    DataIn = Val(Data)
    LinkCollection = 0
    retval = SetUsageValue(UsagePage, Usage, LinkCollection, 0, DataIn, ReportID, QuietMode)
    If retval = 0 Or retval = -1 Then
        'fail.. ignore the failure..
        SetUsage = -1
        WaitMIN_DELAY
        Exit Function
    End If
    
    SetUsage = Data
    
    WaitMIN_DELAY
End Function

Public Function GetUsage(UsagePage As Integer, Usage As Integer, ReportID As Integer) As Variant
    Dim LinkCollection As Integer
    Dim retval As Integer
    Dim Data As Long

    LinkCollection = 0
    
    retval = GetUsageValue(UsagePage, Usage, LinkCollection, 0, Data, ReportID, QuietMode)
    If retval = 0 Or retval = -1 Then
        'fail.. ignore the failure..
        GetUsage = -1
        WaitMIN_DELAY
        Exit Function
    End If
    
    GetUsage = Data
    
    WaitMIN_DELAY
End Function

Public Function H2D(ByVal HexVal As Variant) As Variant
    H2D = Val("&H" + HexVal)
End Function

Public Function uH2D(ByVal HexString As String) As Variant
    Dim x As Integer
    Dim BinStr As String
    Const TwoToThe49thPower As String = "562949953421312"
    If Left$(HexString, 2) Like "&[hH]" Then
    HexString = Mid$(HexString, 3)
    End If
    If Len(HexString) <= 23 Then
    Const BinValues = "0000000100100011" & _
    "0100010101100111" & _
    "1000100110101011" & _
    "1100110111101111"
    For x = 1 To Len(HexString)
    BinStr = BinStr & Mid$(BinValues, _
    4 * Val("&h" & Mid$(HexString, x, 1)) + 1, 4)
    Next
    uH2D = CDec(0)
    For x = 0 To Len(BinStr) - 1
    If x < 50 Then
    uH2D = uH2D + Val(Mid(BinStr, _
    Len(BinStr) - x, 1)) * 2 ^ x
    Else
    uH2D = uH2D + CDec(TwoToThe49thPower) * _
    Val(Mid(BinStr, Len(BinStr) - x, 1)) * 2 ^ (x - 49)
    End If
    Next
    Else
    ' Number is too big, handle error here
    End If
End Function


Public Function D2H(ByVal DecVal As Long) As String
    D2H = Hex$(DecVal)
End Function


Public Sub DelayTime()
    Dim dtStart As Long
    Dim dtEnd As Long
    Dim Result As Long
    Dim i As Integer


    dtStart = GetTickCount
    
    For i = 0 To 10000
        DoEvents
    Next
        
    dtEnd = GetTickCount
    
    
    Result = dtEnd - dtStart
    
    MsgBox "Duration is " & Result & " milliseconds."
    
End Sub




Public Sub WAIT_mSECS(Delay As Long)
'    Dim i As Long
'    Dim dtStart As Long
'    Dim dtEnd As Long
    DelayOver = False
    frmMain.DelayTimer.Interval = Delay
    frmMain.DelayTimer.Enabled = True
    Do
        If DelayOver = True Then
            frmMain.DelayTimer.Enabled = False
            Exit Sub
        End If
        DoEvents
    Loop

'    dtStart = GetTickCount
'    Do
''        For i = 0 To 10
'            DoEvents
''        Next
'        dtEnd = GetTickCount
'        If dtEnd - dtStart >= Delay Then
'            Exit Sub
'        End If
'    Loop

End Sub


Public Sub WAIT_1_SEC()
    DelayOver = False
    frmMain.DelayTimer.Interval = 1000
    frmMain.DelayTimer.Enabled = True
    Do
        If DelayOver = True Then
            frmMain.DelayTimer.Enabled = False
            Exit Sub
        End If
        DoEvents
    Loop
End Sub

Public Sub LogResults(InString As String)
    Dim tempstring2 As String
    Dim tempstring As String
    Dim i As Integer
    
    On Error Resume Next
    
    If LogResultsEnabled = True Then
        If LogFileOpen = True Then
            tempstring = Time & vbTab & InString
            'filter out unprintable characters:
            tempstring2 = ""
            For i = 1 To Len(tempstring)
                If (Asc(Mid(tempstring, i, 1)) < 128) Then
                    tempstring2 = tempstring2 & Mid(tempstring, i, 1)
                End If
            Next i
            LogFile.WriteLine tempstring2
        End If
        lstResults.AddItem Time & vbTab & InString
        If (lstResults.ListCount > 250) Then
            lstResults.RemoveItem 1
        End If
        ScrollDown
    End If
End Sub

Public Function FXD(LongVar As Variant, Width As Variant) As Variant
    Dim TempWork As String
    Dim TempWidth As Long
    
    TempWidth = CLng(Width)
    TempWork = LongVar
    
    If Len(TempWork) > TempWidth Then
        'FXD = Mid(TempWork, Len(TempWork) - TempWidth, TempWidth)
        FXD = Right(TempWork, TempWidth)
        Exit Function
    End If
    
    Do Until Len(TempWork) = TempWidth
        TempWork = "0" & TempWork
    Loop
    
    FXD = TempWork
End Function

Public Function chkbit(variable As Variant, bit As Variant) As Variant
    Dim tempvar As Long
    Dim var As Long
    Dim bitloc As Integer
    
    var = variable
    bitloc = bit
    
    tempvar = var And (2 ^ bitloc)
    
    If tempvar <> 0 Then
        chkbit = True
    Else
        chkbit = False
    End If
End Function
Public Function setbit(variable As Variant, bit As Variant) As Variant
    Dim var As Long
    Dim bitloc As Integer
    
    var = variable
    bitloc = bit
    setbit = var Or (2 ^ bitloc)
End Function
Public Function clrbit(variable As Variant, bit As Variant) As Variant
    Dim var As Long
    Dim bitloc As Integer
    
    var = variable
    bitloc = bit
    clrbit = var And (Not (2 ^ bitloc))
End Function

Public Function tglbit(variable As Variant, bit As Variant) As Variant
    Dim var As Long
    Dim bitloc As Integer
    
    var = variable
    bitloc = bit
    tglbit = var Xor (2 ^ bitloc)
End Function

'This is effectively a val() function for vbscript.
Public Function getval(variable As Variant) As Variant
    Dim var As Double
    
    var = Val(variable)
    getval = var
End Function
