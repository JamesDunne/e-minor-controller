Attribute VB_Name = "ApiDeclarations"
'******************************************************************************
'API constants, listed alphabetically
'******************************************************************************

'HID error codes:
Public Const HIDP_STATUS_SUCCESS = 1114112
Public Const HIDP_STATUS_NULL = -2146369535
Public Const HIDP_STATUS_INVALID_PREPARSED_DATA = -1072627711
Public Const HIDP_STATUS_INVALID_REPORT_TYPE = -1072627710
Public Const HIDP_STATUS_INVALID_REPORT_LENGTH = -1072627709
Public Const HIDP_STATUS_USAGE_NOT_FOUND = -1072627708
Public Const HIDP_STATUS_VALUE_OUT_OF_RANGE = -1072627707
Public Const HIDP_STATUS_BAD_LOG_PHY_VALUES = -1072627706
Public Const HIDP_STATUS_BUFFER_TOO_SMALL = -1072627705
Public Const HIDP_STATUS_INTERNAL_ERROR = -1072627704
Public Const HIDP_STATUS_I8042_TRANS_UNKNOWN = -1072627703
Public Const HIDP_STATUS_INCOMPATIBLE_REPORT_ID = -1072627702
Public Const HIDP_STATUS_NOT_VALUE_ARRAY = -1072627701
Public Const HIDP_STATUS_IS_VALUE_ARRAY = -1072627700
Public Const HIDP_STATUS_DATA_INDEX_NOT_FOUND = -1072627699
Public Const HIDP_STATUS_DATA_INDEX_OUT_OF_RANGE = -1072627698
Public Const HIDP_STATUS_BUTTON_NOT_PRESSED = -1072627697
Public Const HIDP_STATUS_REPORT_DOES_NOT_EXIST = -1072627696
Public Const HIDP_STATUS_NOT_IMPLEMENTED = -1072627680
Public Const HIDP_STATUS_I8242_TRANS_UNKNOWN = -1072627703



'from setupapi.h
Public Const DIGCF_PRESENT = &H2
Public Const DIGCF_DEVICEINTERFACE = &H10
Public Const FILE_FLAG_OVERLAPPED = &H40000000
Public Const FILE_SHARE_READ = &H1
Public Const FILE_SHARE_WRITE = &H2
Public Const FORMAT_MESSAGE_FROM_SYSTEM = &H1000
Public Const GENERIC_READ = &H80000000
Public Const GENERIC_WRITE = &H40000000

'Typedef enum defines a set of integer constants for HidP_Report_Type
'Remember to declare these as integers (16 bits)
Public Const HidP_Input = 0
Public Const HidP_Output = 1
Public Const HidP_Feature = 2

Public Const OPEN_EXISTING = 3
Public Const WAIT_TIMEOUT = &H102&
Public Const WAIT_OBJECT_0 = 0

'******************************************************************************
'User-defined types for API calls, listed alphabetically
'******************************************************************************

Public Type GUID
    Data1 As Long
    Data2 As Integer
    Data3 As Integer
    Data4(7) As Byte
End Type

Public Type HIDD_ATTRIBUTES
    Size As Long
    VendorID As Integer
    ProductID As Integer
    VersionNumber As Integer
End Type

'Windows 98 DDK documentation is incomplete.
'Use the structure defined in hidpi.h
Public Type HIDP_CAPS
    Usage As Integer
    UsagePage As Integer
    InputReportByteLength As Integer
    OutputReportByteLength As Integer
    FeatureReportByteLength As Integer
    Reserved(16) As Integer
    NumberLinkCollectionNodes As Integer
    NumberInputButtonCaps As Integer
    NumberInputValueCaps As Integer
    NumberInputDataIndices As Integer
    NumberOutputButtonCaps As Integer
    NumberOutputValueCaps As Integer
    NumberOutputDataIndices As Integer
    NumberFeatureButtonCaps As Integer
    NumberFeatureValueCaps As Integer
    NumberFeatureDataIndices As Integer
End Type

'Something is not quite right here... I commented out Reserved3 and Reserved4
'because the data wasn't lining up properly...
Public Type HIDP_VALUE_CAPS
    UsagePage As Integer
    ReportID As Byte
    IsAlias As Byte
    BitField As Integer
    LinkCollection  As Integer
    LinkUsage  As Integer
    LinkUsagePage  As Integer
    IsRange  As Byte
    IsStringRange  As Byte
    IsDesignatorRange  As Byte
    IsAbsolute  As Byte
    HasNull  As Byte
    Reserved  As Byte
    BitSize   As Integer
    ReportCount   As Integer
    Reserved_Next(5)   As Integer
    UnitsExp As Long
    Units As Long
    LogicalMax As Long
    LogicalMin As Long
    PhysicalMax As Integer
    PhysicalMin As Integer
  'only support NotRange:
    Usage As Integer
    Reserved1 As Integer
    StringIndex As Integer
    Reserved2  As Integer
    DesignatorIndex As Integer
    Reserved3 As Integer
    DataIndex As Integer
    Reserved4 As Integer
End Type

Public Type HIDP_BUTTON_CAPS
    UsagePage As Integer
    ReportID As Byte
    IsAlias As Byte
    BitField As Integer
    LinkCollection  As Integer
    LinkUsage  As Integer
    LinkUsagePage  As Integer
    IsRange  As Byte
    IsStringRange  As Byte
    IsDesignatorRange  As Byte
    IsAbsolute  As Byte
    HasNull  As Byte                'unused
    Reserved  As Byte               'unused
    BitSize   As Integer            'unused
    ReportCount   As Integer        'unused
    Reserved_Next(5)   As Integer
    UnitsExp As Long                'unused
    Units As Long                   'unused
    LogicalMin As Long              'wrong size?
    LogicalMax As Long              'wrong size?
    PhysicalMin As Integer
    PhysicalMax As Integer
  'only support NotRange:
    Usage As Integer
    Reserved1 As Integer
    StringIndex As Integer
    Reserved2  As Integer
    DesignatorIndex As Integer
    Reserved3 As Integer
    DataIndex As Integer
    Reserved4 As Integer
End Type


Public Type OVERLAPPED
    Internal As Long
    InternalHigh As Long
    Offset As Long
    OffsetHigh As Long
    hEvent As Long
End Type

Public Type SECURITY_ATTRIBUTES
    nLength As Long
    lpSecurityDescriptor As Long
    bInheritHandle As Long
End Type

Public Type SP_DEVICE_INTERFACE_DATA
   cbSize As Long
   InterfaceClassGuid As GUID
   Flags As Long
   Reserved As Long
End Type

Public Type SP_DEVICE_INTERFACE_DETAIL_DATA
    cbSize As Long
    DevicePath As Byte
End Type

Public Type SP_DEVINFO_DATA
    cbSize As Long
    ClassGuid As GUID
    DevInst As Long
    Reserved As Long
End Type

'******************************************************************************
'API functions, listed alphabetically
'******************************************************************************

Public Declare Function CancelIo _
    Lib "kernel32" _
    (ByVal hFile As Long) _
As Long

Public Declare Function CloseHandle _
    Lib "kernel32" _
    (ByVal hObject As Long) _
As Long

Public Declare Function CreateEvent _
    Lib "kernel32" _
    Alias "CreateEventA" _
    (ByRef lpSecurityAttributes As SECURITY_ATTRIBUTES, _
    ByVal bManualReset As Long, _
    ByVal bInitialState As Long, _
    ByVal lpName As String) _
As Long

Public Declare Function CreateFile _
    Lib "kernel32" _
    Alias "CreateFileA" _
    (ByVal lpFileName As String, _
    ByVal dwDesiredAccess As Long, _
    ByVal dwShareMode As Long, _
    ByRef lpSecurityAttributes As SECURITY_ATTRIBUTES, _
    ByVal dwCreationDisposition As Long, _
    ByVal dwFlagsAndAttributes As Long, _
    ByVal hTemplateFile As Long) _
As Long

Public Declare Function FormatMessage _
    Lib "kernel32" _
    Alias "FormatMessageA" _
    (ByVal dwFlags As Long, _
    ByRef lpSource As Any, _
    ByVal dwMessageId As Long, _
    ByVal dwLanguageZId As Long, _
    ByVal lpBuffer As String, _
    ByVal nSize As Long, _
    ByVal Arguments As Long) _
As Long

Public Declare Function HidD_FreePreparsedData _
    Lib "hid.dll" _
    (ByRef PreparsedData As Long) _
As Long

Public Declare Function HidD_GetAttributes _
    Lib "hid.dll" _
    (ByVal HidDeviceObject As Long, _
    ByRef Attributes As HIDD_ATTRIBUTES) _
As Long

'Declared as a function for consistency,
'but returns nothing. (Ignore the returned value.)
Public Declare Function HidD_GetHidGuid _
    Lib "hid.dll" _
    (ByRef HidGuid As GUID) _
As Long

Public Declare Function HidD_GetPreparsedData _
    Lib "hid.dll" _
    (ByVal HidDeviceObject As Long, _
    ByRef PreparsedData As Long) _
As Long

Public Declare Function HidP_GetCaps _
    Lib "hid.dll" _
    (ByVal PreparsedData As Long, _
    ByRef Capabilities As HIDP_CAPS) _
As Long

Public Declare Function HidP_GetValueCaps _
    Lib "hid.dll" _
    (ByVal ReportType As Integer, _
    ByRef ValueCaps As HIDP_VALUE_CAPS, _
    ByRef ValueCapsLength As Integer, _
    ByVal PreparsedData As Long) _
As Long
       

'This is using VALUE_CAPS instead of BUTTON_CAPS
Public Declare Function HidP_GetButtonCaps _
    Lib "hid.dll" _
    (ByVal ReportType As Integer, _
    ByRef ButtonCaps As HIDP_VALUE_CAPS, _
    ByRef ButtonCapsLength As Integer, _
    ByVal PreparsedData As Long) _
As Long

Public Declare Function lstrcpy _
    Lib "kernel32" _
    Alias "lstrcpyA" _
    (ByVal dest As String, _
    ByVal source As Long) _
As String

Public Declare Function lstrlen _
    Lib "kernel32" _
    Alias "lstrlenA" _
    (ByVal source As Long) _
As Long

Public Declare Function ReadFile _
    Lib "kernel32" _
    (ByVal hFile As Long, _
    ByRef lpBuffer As Byte, _
    ByVal nNumberOfBytesToRead As Long, _
    ByRef lpNumberOfBytesRead As Long, _
    ByRef lpOverlapped As OVERLAPPED) _
As Long

Public Declare Function ResetEvent _
    Lib "kernel32" _
    (ByVal hEvent As Long) _
As Long

Public Declare Function RtlMoveMemory _
    Lib "kernel32" _
    (dest As Any, _
    src As Any, _
    ByVal Count As Long) _
As Long

Public Declare Function SetupDiCreateDeviceInfoList _
    Lib "setupapi.dll" _
    (ByRef ClassGuid As GUID, _
    ByVal hwndParent As Long) _
As Long

Public Declare Function SetupDiDestroyDeviceInfoList _
    Lib "setupapi.dll" _
    (ByVal DeviceInfoSet As Long) _
As Long

Public Declare Function SetupDiEnumDeviceInterfaces _
    Lib "setupapi.dll" _
    (ByVal DeviceInfoSet As Long, _
    ByVal DeviceInfoData As Long, _
    ByRef InterfaceClassGuid As GUID, _
    ByVal MemberIndex As Long, _
    ByRef DeviceInterfaceData As SP_DEVICE_INTERFACE_DATA) _
As Long

Public Declare Function SetupDiGetClassDevs _
    Lib "setupapi.dll" _
    Alias "SetupDiGetClassDevsA" _
    (ByRef ClassGuid As GUID, _
    ByVal Enumerator As String, _
    ByVal hwndParent As Long, _
    ByVal Flags As Long) _
As Long

Public Declare Function SetupDiGetDeviceInterfaceDetail _
   Lib "setupapi.dll" _
   Alias "SetupDiGetDeviceInterfaceDetailA" _
   (ByVal DeviceInfoSet As Long, _
   ByRef DeviceInterfaceData As SP_DEVICE_INTERFACE_DATA, _
   ByVal DeviceInterfaceDetailData As Long, _
   ByVal DeviceInterfaceDetailDataSize As Long, _
   ByRef RequiredSize As Long, _
   ByVal DeviceInfoData As Long) _
As Long
    
Public Declare Function WaitForSingleObject _
    Lib "kernel32" _
    (ByVal hHandle As Long, _
    ByVal dwMilliseconds As Long) _
As Long
    
Public Declare Function WriteFile _
    Lib "kernel32" _
    (ByVal hFile As Long, _
    ByRef lpBuffer As Byte, _
    ByVal nNumberOfBytesToWrite As Long, _
    ByRef lpNumberOfBytesWritten As Long, _
    ByVal lpOverlapped As Long) _
As Long

'------------------------------------------------------------------------------
'3/19/06 JDunne - Added the following functions

Public Declare Function HidD_GetFeature _
    Lib "hid.dll" _
    (ByVal HidDeviceObject As Long, _
    ByRef ReportBuffer As Byte, _
    ByVal ReportBufferLength As Long) _
As Long

    'Result = HidD_GetFeature(HIDHandle, ReportBuffer(0), ReportBufferLength)
    'success = HidD_GetInputReport(HIDHandle, inputReportBuffer(0), UBound(inputReportBuffer) + 1)
'    success = HidD_GetFeature _
'       (HIDHandle, _
'       inFeatureReportBuffer(0), _
'       UBound(inFeatureReportBuffer) + 1)

Public Declare Function HidD_SetFeature _
    Lib "hid.dll" _
    (ByVal HidDeviceObject As Long, _
    ByRef ReportBuffer As Byte, _
    ByVal ReportBufferLength As Long) _
As Long


Public Declare Function HidP_GetUsages _
    Lib "hid.dll" _
    (ByVal ReportType As Integer, _
    ByVal UsagePage As Integer, _
    ByVal LinkCollection As Integer, _
    ByRef UsageList As Integer, _
    ByRef UsageLength As Long, _
    ByVal PreparsedData As Long, _
    ByRef Report As Byte, _
    ByVal ReportLength As Long) _
    As Long


'specify usage page:usage to get data this way..
Public Declare Function HidP_GetUsageValue _
    Lib "hid.dll" _
    (ByVal ReportType As Integer, _
    ByVal UsagePage As Integer, _
    ByVal LinkCollection As Integer, _
    ByVal Usage As Integer, _
    ByRef UsageValue As Long, _
    ByVal PreparsedData As Long, _
    ByRef Report As Byte, _
    ByVal ReportLength As Long) _
    As Long

Public Declare Function HidP_GetScaledUsageValue _
    Lib "hid.dll" _
    (ByVal ReportType As Integer, _
    ByVal UsagePage As Integer, _
    ByVal LinkCollection As Integer, _
    ByVal Usage As Integer, _
    ByRef UsageValue As Long, _
    ByVal PreparsedData As Long, _
    ByRef Report As Byte, _
    ByVal ReportLength As Long) _
    As Long
    
Public Declare Function HidP_SetUsageValue _
    Lib "hid.dll" _
    (ByVal ReportType As Integer, _
    ByVal UsagePage As Integer, _
    ByVal LinkCollection As Integer, _
    ByVal Usage As Integer, _
    ByVal UsageValue As Long, _
    ByVal PreparsedData As Long, _
    ByRef Report As Byte, _
    ByVal ReportLength As Long) _
    As Long
    
    
Public Declare Function HidP_SetScaledUsageValue _
    Lib "hid.dll" _
    (ByVal ReportType As Integer, _
    ByVal UsagePage As Integer, _
    ByVal LinkCollection As Integer, _
    ByVal Usage As Integer, _
    ByVal UsageValue As Long, _
    ByVal PreparsedData As Long, _
    ByRef Report As Byte, _
    ByVal ReportLength As Long) _
    As Long
    
Public Declare Function HidD_GetInputReport _
    Lib "hid.dll" _
    (ByVal HidDeviceObject As Long, _
    ByRef ReportBuffer As Byte, _
    ByVal ReportBufferLength As Long) _
    As Long
    
    
Public Declare Function HidD_GetIndexedString _
    Lib "hid.dll" _
    (ByVal HidDeviceObject As Long, _
    ByVal StringIndex As Long, _
    ByRef Buffer As Byte, _
    ByVal BufferLength As Long) _
    As Long
    
Public Declare Function HidD_GetProductString _
    Lib "hid.dll" _
    (ByVal HidDeviceObject As Long, _
    ByRef Buffer As Byte, _
    ByVal BufferLength As Long) _
As Long

Public Declare Function HidD_GetManufacturerString _
    Lib "hid.dll" _
    (ByVal HidDeviceObject As Long, _
    ByRef Buffer As Byte, _
    ByVal BufferLength As Long) _
As Long

Public Declare Function HidD_GetSerialNumberString _
    Lib "hid.dll" _
    (ByVal HidDeviceObject As Long, _
    ByRef Buffer As Byte, _
    ByVal BufferLength As Long) _
As Long

'HidDeviceObject
'    Specifies an open handle to a top-level collection.
'ReportBuffer
'    Pointer to a caller-allocated feature report buffer that the caller uses to specify a HID report ID.
    
'The feature report — excluding its report ID, if report IDs are used — is located at ((PUCHAR)ReportBuffer + 1).
'ReportBufferLength
 '   Specifies the size, in bytes, of the report buffer. The report buffer must be large enough to hold the feature report — excluding its report ID, if report IDs are used — plus one additional byte that specifies a nonzero report ID or zero.
'Return Value
'    If HidD_SetFeature succeeds, it returns TRUE; otherwise, it returns FALSE.

