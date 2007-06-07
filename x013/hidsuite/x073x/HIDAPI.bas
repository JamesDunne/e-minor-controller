Attribute VB_Name = "HIDAPI"

Public SelectedDev As Integer

Public Function GetDataString _
    (Address As Long, _
    Bytes As Long) _
    As String
    'Retrieves a string of length Bytes from memory, beginning at Address.
    'Adapted from Dan Appleman's "Win32 API Puzzle Book"
    
    Dim Offset As Integer
    Dim Result$
    Dim ThisByte As Byte
    
    For Offset = 0 To Bytes - 1
        Call RtlMoveMemory(ByVal VarPtr(ThisByte), ByVal Address + Offset, 1)
        If (ThisByte And &HF0) = 0 Then
            Result$ = Result$ & "0"
        End If
        Result$ = Result$ & Hex$(ThisByte) & " "
    Next Offset
    
    GetDataString = Result$
End Function


'******************************************************************************
'ReadFile
'Returns: the report in ReadBuffer.
'Requires: a device handle returned by CreateFile
'(for overlapped I/O, CreateFile must be called with FILE_FLAG_OVERLAPPED),
'the Input report length in bytes returned by HidP_GetCaps,
'and an overlapped structure whose hEvent member is set to an event object.
'******************************************************************************
Function ReadInputReport(ByRef ReadBuffer() As Byte, ByVal ReadHandle As Long, _
    ByRef HIDOverlapped As OVERLAPPED, _
    ByVal nBytesToRead As Integer)      'Read data from the device.
    
    Dim Count
    Dim NumberOfBytesRead As Long
    Dim UBoundReadBuffer As Integer
    Dim ByteValue As String
    Dim Result As Long

    'ReDim ReadBuffer(3)
    
    'Do an overlapped ReadFile.
    'The function returns immediately, even if the data hasn't been received yet.
    Result = ReadFile _
        (ReadHandle, _
        ReadBuffer(0), _
        CLng(nBytesToRead), _
        NumberOfBytesRead, _
        HIDOverlapped)
    
    'Call DisplayResultOfAPICall("ReadFile")
    
    '******************************************************************************
    'WaitForSingleObject
    'Used with overlapped ReadFile.
    'Returns when ReadFile has received the requested amount of data or on timeout.
    'Requires an event object created with CreateEvent
    'and a timeout value in milliseconds.
    '******************************************************************************
    Result = WaitForSingleObject(HIDOverlapped.hEvent, 1000)
    
    'Find out if ReadFile completed or timeout.
    
    Select Case Result
        Case WAIT_OBJECT_0          'ReadFile has completed
            'lstResults.AddItem "ReadFile completed successfully."
            ReadInputReport = True
        Case WAIT_TIMEOUT           'Timeout
            'lstResults.AddItem "Readfile timeout"
            'Cancel the operation because it has timed out.
            Result = CancelIo(ReadHandle)   'Cancels the ReadFile
            'The timeout may have been because the device was removed,
            'so close any open handles and
            'set MyDeviceDetected=False to cause the application to
            'look for the device on the next attempt.
            
            'diag .. do not close port:
            'CloseHandle (HIDHandle)
            'CloseHandle (ReadHandle)
            'MyDeviceDetected = False
            ReadInputReport = False
        Case Else
            'lstResults.AddItem "Readfile undefined error"
            ReadInputReport = True
    End Select
        
    '******************************************************************************
    'ResetEvent
    'Sets the event object in the overlapped structure to non-signaled.
    'Requires a handle to the event object.
    Call ResetEvent(EventObject)
End Function



'Set PID, VID to match the values in the device's firmware and INF file.
'Makes a series of API calls to locate the desired HID-class device.
'Returns True if the device is detected, False if not detected.
'FindTheHid: Parses through all the devices to find DevicePathName which allows
'a handle to the device to be opened.  Using that handle, the PID and VID are
'checked to determine if we've found the device we're looking for.
'If we have a success, DevicePathName can be used by CreateFile to obtain a handle
'for reading/writing input or feature reports.
Function FindTheHid(ByRef MyVendorID As Integer, ByRef MyProductID As Integer, _
    ByVal ShowHIDList As Boolean, ByRef DevicePathName As String, ByRef Security As SECURITY_ATTRIBUTES) As Boolean
    
    Dim LastDevice As Boolean
    Dim MyDeviceDetected As Boolean
    Dim Count As Integer
    Dim GUIDString As String
    Dim HidGuid As GUID
    Dim MemberIndex As Long
    Dim DataString As String
    Dim DetailData As Long
    Dim DetailDataBuffer() As Byte
    Dim DeviceAttributes As HIDD_ATTRIBUTES
    Dim DeviceInfoSet As Long
    Dim MyDeviceInfoData As SP_DEVINFO_DATA
    Dim MyDeviceInterfaceDetailData As SP_DEVICE_INTERFACE_DETAIL_DATA
    Dim MyDeviceInterfaceData As SP_DEVICE_INTERFACE_DATA
    Dim Needed As Long
    Dim HIDHandle As Long
    Dim ReadHandle As Long
    Dim Result As Long
    Dim tempstring As String
    Dim StringBuffer(255) As Byte

    LastDevice = False
    MyDeviceDetected = False
    
    'Values for SECURITY_ATTRIBUTES structure:
    Security.lpSecurityDescriptor = 0
    Security.bInheritHandle = True
    Security.nLength = Len(Security)
    
    '******************************************************************************
    'HidD_GetHidGuid
    'Get the GUID for all system HIDs.
    'Returns: the GUID in HidGuid.
    'The routine doesn't return a value in Result
    'but the routine is declared as a function for consistency with the other API calls.
    '******************************************************************************
    
    Result = HidD_GetHidGuid(HidGuid)
    
    'Store the GUID as a string... for no particular reason...
    GUIDString = _
        Hex$(HidGuid.Data1) & "-" & _
        Hex$(HidGuid.Data2) & "-" & _
        Hex$(HidGuid.Data3) & "-"
    
    '******************************************************************************
    'SetupDiGetClassDevs
    'Returns: a handle to a device information set for all installed devices.
    'Requires: the HidGuid returned in GetHidGuid.
    '******************************************************************************
    
    DeviceInfoSet = SetupDiGetClassDevs _
        (HidGuid, _
        vbNullString, _
        0, _
        (DIGCF_PRESENT Or DIGCF_DEVICEINTERFACE))
        
    DataString = GetDataString(DeviceInfoSet, 32)
    
    '******************************************************************************
    'SetupDiEnumDeviceInterfaces
    'On return, MyDeviceInterfaceData contains the handle to a
    'SP_DEVICE_INTERFACE_DATA structure for a detected device.
    'Requires:
    'the DeviceInfoSet returned in SetupDiGetClassDevs.
    'the HidGuid returned in GetHidGuid.
    'An index to specify a device.
    '******************************************************************************
    
    'Begin with 0 and increment until no more devices are detected.
    MemberIndex = 0

'    frmMain.lstResults.AddItem "All HID devices found:"

'find out how many HID devices there are:
    Do
        MyDeviceInterfaceData.cbSize = LenB(MyDeviceInterfaceData)
        Result = SetupDiEnumDeviceInterfaces _
            (DeviceInfoSet, _
            0, _
            HidGuid, _
            MemberIndex, _
            MyDeviceInterfaceData)
            If Result = 0 Then
                LastDevice = True
            Else
                MyDeviceInfoData.cbSize = Len(MyDeviceInfoData)
                Result = SetupDiGetDeviceInterfaceDetail _
                   (DeviceInfoSet, _
                   MyDeviceInterfaceData, _
                   0, _
                   0, _
                   Needed, _
                   0)
                
                DetailData = Needed
                'Store the structure's size.
                MyDeviceInterfaceDetailData.cbSize = Len(MyDeviceInterfaceDetailData)
                ReDim DetailDataBuffer(Needed)
                Call RtlMoveMemory _
                    (DetailDataBuffer(0), _
                    MyDeviceInterfaceDetailData, _
                    4)
                Result = SetupDiGetDeviceInterfaceDetail _
                   (DeviceInfoSet, _
                   MyDeviceInterfaceData, _
                   VarPtr(DetailDataBuffer(0)), _
                   DetailData, _
                   Needed, _
                   0)
                DevicePathName = CStr(DetailDataBuffer())
                DevicePathName = StrConv(DevicePathName, vbUnicode)
                DevicePathName = Right$(DevicePathName, Len(DevicePathName) - 4)
                HIDHandle = CreateFile _
                    (DevicePathName, _
                    GENERIC_READ Or GENERIC_WRITE, _
                    (FILE_SHARE_READ Or FILE_SHARE_WRITE), _
                    Security, _
                    OPEN_EXISTING, _
                    0&, _
                    0)
                DeviceAttributes.Size = LenB(DeviceAttributes)
                Result = HidD_GetAttributes(HIDHandle, DeviceAttributes)
                If HidD_GetProductString(HIDHandle, StringBuffer(0), 128) = 1 Then
                    tempstring = StringBuffer
                End If
                
'                Dim frmList As Form
'                Set frmList = Forms.Add("frmListBox")
'                frmListBox.Controls.Add "vb.ListBox", "list1"
                frmListBox.List1.AddItem " VID=" & Hex$(DeviceAttributes.VendorID) & _
                    " PID=" & Hex$(DeviceAttributes.ProductID) & " USBID=" & tempstring

'                frmMain.lstResults.AddItem " VID=" & Hex$(DeviceAttributes.VendorID) & _
'                    " PID=" & Hex$(DeviceAttributes.ProductID) & " USBID=" & tempstring

            End If
            Result = CloseHandle(HIDHandle)
            DoEvents
            MemberIndex = MemberIndex + 1
    Loop Until LastDevice = True

    If MemberIndex > 2 And ShowHIDList Then
        frmListBox.Show vbModal, frmMain
    End If
    DoEvents

    Unload frmListBox

    Dim NItems As Integer
    NItems = MemberIndex - 1

    'Begin with 0 and increment until no more devices are detected.
    MemberIndex = 0
    LastDevice = False

    Do
        'The cbSize element of the MyDeviceInterfaceData structure must be set to
        'the structure's size in bytes. The size is 28 bytes.
        MyDeviceInterfaceData.cbSize = LenB(MyDeviceInterfaceData)
        Result = SetupDiEnumDeviceInterfaces _
            (DeviceInfoSet, _
            0, _
            HidGuid, _
            MemberIndex, _
            MyDeviceInterfaceData)
        
        If Result = 0 Then LastDevice = True

        If Result <> 0 Then     'If a device exists, check the information returned.
            '******************************************************************************
            'SetupDiGetDeviceInterfaceDetail
            'Returns: an SP_DEVICE_INTERFACE_DETAIL_DATA structure
            'containing information about a device.
            'To retrieve the information, call this function twice.
            'The first time returns the size of the structure in Needed.
            'The second time returns a pointer to the data in DeviceInfoSet.
            'Requires:
            'A DeviceInfoSet returned by SetupDiGetClassDevs and
            'an SP_DEVICE_INTERFACE_DATA structure returned by SetupDiEnumDeviceInterfaces.
            '*******************************************************************************
            
            MyDeviceInfoData.cbSize = Len(MyDeviceInfoData)
            Result = SetupDiGetDeviceInterfaceDetail _
               (DeviceInfoSet, _
               MyDeviceInterfaceData, _
               0, _
               0, _
               Needed, _
               0)
            
            DetailData = Needed
                
            'Store the structure's size.
            MyDeviceInterfaceDetailData.cbSize = Len(MyDeviceInterfaceDetailData)
            
            'Use a byte array to allocate memory for the MyDeviceInterfaceDetailData structure
            ReDim DetailDataBuffer(Needed)
            
            'Store cbSize in the first four bytes of the array.
            Call RtlMoveMemory _
                (DetailDataBuffer(0), _
                MyDeviceInterfaceDetailData, _
                4)
            
            'Call SetupDiGetDeviceInterfaceDetail again.
            'This time, pass the address of the first element of DetailDataBuffer
            'and the returned required buffer size in DetailData.
            
            Result = SetupDiGetDeviceInterfaceDetail _
               (DeviceInfoSet, _
               MyDeviceInterfaceData, _
               VarPtr(DetailDataBuffer(0)), _
               DetailData, _
               Needed, _
               0)
            
            'Convert the byte array to a string.
            DevicePathName = CStr(DetailDataBuffer())
            
            'Convert to Unicode.
            DevicePathName = StrConv(DevicePathName, vbUnicode)
            
            'Strip cbSize (4 bytes) from the beginning.
            DevicePathName = Right$(DevicePathName, Len(DevicePathName) - 4)
            'Device pathname: DevicePathName
            
            '******************************************************************************
            'CreateFile
            'Returns: a handle that enables reading and writing to the device.
            'Requires:
            'The DevicePathName returned by SetupDiGetDeviceInterfaceDetail.
            '******************************************************************************
            HIDHandle = CreateFile _
                (DevicePathName, _
                GENERIC_READ Or GENERIC_WRITE, _
                (FILE_SHARE_READ Or FILE_SHARE_WRITE), _
                Security, _
                OPEN_EXISTING, _
                0&, _
                0)
                
            'Now we can find out if it's the device we're looking for.
            
            '******************************************************************************
            'HidD_GetAttributes
            'Requests information from the device.
            'Requires: The handle returned by CreateFile.
            'Returns: an HIDD_ATTRIBUTES structure containing
            'the Vendor ID, Product ID, and Product Version Number.
            'Use this information to determine if the detected device
            'is the one we're looking for.
            '******************************************************************************
            
            'Set the Size property to the number of bytes in the structure.
            
            Dim VenID As String
            Dim ProdID As String
            Dim USBID As String
            Dim SerNum As String
            
            DeviceAttributes.Size = LenB(DeviceAttributes)
            Result = HidD_GetAttributes(HIDHandle, DeviceAttributes)
                
            If Result <> 0 Then
                'lstResults.AddItem "  HIDD_ATTRIBUTES structure filled without error."
            Else
                'lstResults.AddItem "  Error in filling HIDD_ATTRIBUTES structure."
            End If
        
            'lstResults.AddItem "  Structure size: " & DeviceAttributes.Size
            'lstResults.AddItem "  Vendor ID: " & Hex$(DeviceAttributes.VendorID)
            'lstResults.AddItem "  Product ID: " & Hex$(DeviceAttributes.ProductID)
            'lstResults.AddItem "  Version Number: " & Hex$(DeviceAttributes.VersionNumber)
            
            'Find out if the device matches the one we're looking for.
            
            If NItems > 1 Then
                If SelectedDev = MemberIndex Then
                    MyDeviceDetected = True
                End If
            Else
                MyDeviceDetected = True
            End If
            
            
'            If SpecVID And SpecPID Then
'                If (DeviceAttributes.VendorID = MyVendorID And _
'                    DeviceAttributes.ProductID = MyProductID) Then
'                    'It's the desired device.
'                    MyDeviceDetected = True
'                End If
'            ElseIf SpecVID And DeviceAttributes.VendorID = MyVendorID Then
'                    MyDeviceDetected = True
'            ElseIf SpecPID And DeviceAttributes.ProductID = MyProductID Then
'                    MyDeviceDetected = True
'            ElseIf Not SpecVID And Not SpecPID Then
'                'Check standard VIDs if specVID isn't checked..
'                If (DeviceAttributes.VendorID = "&H09AE" Or _
'                    DeviceAttributes.VendorID = "&H03F0") Then
'                    'It's the desired device.
'                    MyDeviceDetected = True
'                End If
'            End If
        
        End If
        
        If Not MyDeviceDetected Then
            MyDeviceDetected = False
            'If it's not the one we want, close its handle.
            Result = CloseHandle(HIDHandle)
        End If
        
        'Keep looking until we find the device or there are no more left to examine.
        MemberIndex = MemberIndex + 1
    Loop Until (LastDevice = True) Or (MyDeviceDetected = True)
    
    'Free the memory reserved for the DeviceInfoSet returned by SetupDiGetClassDevs.
    Result = SetupDiDestroyDeviceInfoList(DeviceInfoSet)
    
    '------------------------------------------------------------------
    'start code
    
    If MyDeviceDetected = True Then
        FindTheHid = True
     
        'Diag this is for the gui application only, remove when using this as a library:
        frmMain.LogResults "Found the device"
        frmMain.LogResults "  Vendor ID: " & Hex$(DeviceAttributes.VendorID)
        frmMain.LogResults "  Product ID: " & Hex$(DeviceAttributes.ProductID)
        
        If HidD_GetManufacturerString(HIDHandle, StringBuffer(0), 128) = 1 Then
            tempstring = StringBuffer
            frmMain.LogResults "  Manufacturer String: " & tempstring
        End If
        
        If HidD_GetProductString(HIDHandle, StringBuffer(0), 128) = 1 Then
            tempstring = StringBuffer
            frmMain.LogResults "  Product String: " & tempstring
        End If
     
        If HidD_GetSerialNumberString(HIDHandle, StringBuffer(0), 128) = 1 Then
            tempstring = StringBuffer
            frmMain.LogResults "  SerialNumber String: " & tempstring
        End If
     
        MyVendorID = DeviceAttributes.VendorID
        MyProductID = DeviceAttributes.ProductID
     
        Result = CloseHandle(HIDHandle)     'close the handle.. allow user code to open a new handle.
        
        'Get another handle for the overlapped ReadFiles.
'        ReadHandle = CreateFile _
'                (DevicePathName, _
'                (GENERIC_READ Or GENERIC_WRITE), _
'                (FILE_SHARE_READ Or FILE_SHARE_WRITE), _
'                Security, _
'                OPEN_EXISTING, _
'                FILE_FLAG_OVERLAPPED, _
'                0)
'
'        Call PrepareForOverlappedTransfer
    Else
        'lstResults.AddItem " Device not found."
    End If
End Function



Public Sub PrepareForOverlappedTransfer(ByRef HIDOverlapped As OVERLAPPED, _
    ByRef Security As SECURITY_ATTRIBUTES)
    
    '******************************************************************************
    'CreateEvent
    'Creates an event object for the overlapped structure used with ReadFile.
    'Requires a security attributes structure or null,
    'Manual Reset = True (ResetEvent resets the manual reset object to nonsignaled),
    'Initial state = True (signaled),
    'and event object name (optional)
    'Returns a handle to the event object.
    '******************************************************************************
    
    If HIDOverlapped.hEvent = 0 Then
        HIDOverlapped.hEvent = CreateEvent _
            (Security, _
            True, _
            True, _
            "")
    End If
        
    'Set the members of the overlapped structure.
    
    HIDOverlapped.Offset = 0
    HIDOverlapped.OffsetHigh = 0
    'HIDOverlapped.hEvent = EventObject
End Sub

    '******************************************************************************
    'HidD_GetPreparsedData
    'Returns: a pointer to a buffer containing information about the device's capabilities.
    'Requires: A handle returned by CreateFile.
    'There's no need to access the buffer directly,
    'but HidP_GetCaps and other API functions require a pointer to the buffer.
    '******************************************************************************
Public Sub GetDeviceCapabilities(ByRef Capabilities As HIDP_CAPS, _
    ByRef FeatureCaps() As HIDP_VALUE_CAPS, ByRef InputCaps() As HIDP_VALUE_CAPS, ByVal HIDHandle As Long, ByRef PreparsedData As Long)

    'Dim PreparsedData As Long
    'Dim ppData(29) As Byte
    'Dim ppDataString As Variant
    Dim Result As Long
    
    'PreparsedData is a pointer to a routine-allocated buffer.
    Result = HidD_GetPreparsedData _
        (HIDHandle, _
        PreparsedData)
    
    If Result <> 0 Then
    
        'This stuff makes no sense.. no reason to do this:
'        'Copy the data at PreparsedData into a byte array.
'        Result = RtlMoveMemory _
'            (ppData(0), _
'            PreparsedData, _
'            30)
'
'        ppDataString = ppData()
'        'Convert the data to Unicode.
'        ppDataString = StrConv(ppDataString, vbUnicode)
        
        
        '******************************************************************************
        'HidP_GetCaps
        'Find out the device's capabilities.
        'For standard devices such as joysticks, you can find out the specific
        'capabilities of the device.
        'For a custom device, the software will probably know what the device is capable of,
        'so this call only verifies the information.
        'Requires: The pointer to a buffer containing the information.
        'The pointer is returned by HidD_GetPreparsedData.
        'Returns: a Capabilites structure containing the information.
        '******************************************************************************
        
        Result = HidP_GetCaps(PreparsedData, Capabilities)
        
        'This is a guess. The byte array holds the structures.
        'Dim ValueCaps(10000) As Byte
        
        'ReDim FeatureCapsTemp(Capabilities.NumberFeatureValueCaps) As HIDP_VALUE_CAPS
        
        Result = HidP_GetValueCaps _
            (HidP_Feature, _
            FeatureCaps(Index), _
            Capabilities.NumberFeatureValueCaps, _
            PreparsedData)
        
        Result = HidP_GetValueCaps _
            (HidP_Input, _
            InputCaps(0), _
            Capabilities.NumberInputValueCaps, _
            PreparsedData)
        
        Result = HidP_GetButtonCaps _
            (HidP_Feature, _
            FeatureCaps(Capabilities.NumberFeatureValueCaps), _
            Capabilities.NumberFeatureButtonCaps, _
            PreparsedData)
        
'        Result = HidP_GetButtonCaps _
'            (HidP_Input, _
'            FeatureCaps(Capabilities.NumberFeatureValueCaps + Capabilities.NumberInputValueCaps + Capabilities.NumberFeatureButtonCaps), _
'            Capabilities.NumberInputButtonCaps, _
'            PreparsedData)
        
'        Dim i As Integer
'        For i = 1 To Capabilities.NumberFeatureValueCaps
'            FeatureCaps(i).ReportID = ValueCaps((i - 1) * 72 + 2)
'            FeatureCaps(i).BitSize = ValueCaps((i - 1) * 72 + 18)
'        Next i
'
        'Free the buffer reserved by HidD_GetPreparsedData
        'Save this data until shutdown:
        'Result = HidD_FreePreparsedData(PreparsedData)
    Else
        'Call DisplayResultOfAPICall("HidD_GetPreparsedData")
    End If
End Sub


Function GetFeatureLength(ByVal ReportID As Long, ByRef FeatureCaps() As HIDP_VALUE_CAPS, ByVal NumberOfReports As Long) As Long
    Dim i As Integer
    
    GetFeatureLength = -1
    
    For i = 0 To NumberOfReports
        If FeatureCaps(i).ReportID = ReportID Then
            GetFeatureLength = FeatureCaps(i).BitSize
        End If
    Next i
End Function
