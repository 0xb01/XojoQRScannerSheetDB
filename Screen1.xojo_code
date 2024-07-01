#tag MobileScreen
Begin MobileScreen Screen1
   Compatibility   =   ""
   HasBackButton   =   False
   HasNavigationBar=   False
   Modal           =   False
   Orientation     =   1
   Title           =   "Scanner"
   Begin MobileButton Button1
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Caption         =   "Scan QR"
      CaptionColor    =   &cFFFFFF00
      Enabled         =   True
      Height          =   44
      Left            =   240
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      Scope           =   0
      Top             =   682
      Visible         =   True
      Width           =   100
   End
   Begin Barcode Barcode1
      Left            =   0
      LockedInPosition=   False
      PanelIndex      =   -1
      Parent          =   ""
      Scope           =   0
      Top             =   0
   End
   Begin AndroidMobileTable Table1
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Enabled         =   True
      HasHeader       =   False
      Header          =   ""
      Height          =   587
      InitialValue    =   ""
      LastAddedRowIndex=   0
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RowCount        =   0
      Scope           =   0
      ScrollPosition  =   0
      SelectedRowIndex=   0
      SelectedRowText =   ""
      SeparatorColor  =   &c00000000
      SeparatorThickness=   0
      Top             =   49
      Visible         =   True
      Width           =   360
   End
   Begin MobileLabel Label1
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   1
      Enabled         =   True
      Height          =   30
      Left            =   0
      LineBreakMode   =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      MaximumCharactersAllowed=   0
      Scope           =   0
      Text            =   "Waiting for QR code to scan..."
      TextColor       =   &c00000000
      Top             =   11
      Visible         =   True
      Width           =   360
   End
   Begin MobileButton Button2
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Caption         =   "About"
      CaptionColor    =   &cFFFFFF00
      Enabled         =   True
      Height          =   44
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      Top             =   682
      Visible         =   True
      Width           =   100
   End
   Begin MobileLabel Label2
      AccessibilityHint=   ""
      AccessibilityLabel=   ""
      Alignment       =   1
      Enabled         =   True
      Height          =   30
      Left            =   0
      LineBreakMode   =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      MaximumCharactersAllowed=   0
      Scope           =   0
      Text            =   ""
      TextColor       =   &c00000000
      Top             =   644
      Visible         =   True
      Width           =   360
   End
End
#tag EndMobileScreen

#tag ScreenCode
	#tag Event
		Sub Opening()
		  Var host As String = App.api
		  host = host.ReplaceAll("https://sheetdb.io/api/v1/", "https://..../")
		  host = host.ReplaceAll("https://sheetdb.io/api/v2/", "https://..../")
		  host = host.ReplaceAll("https://sheetdb.io/api/v3/", "https://..../")
		  
		  Var a As MobileLabel = Label2
		  a.Text = "Scanner, hosted @ " + host
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub ClearScreen()
		  Var txt As MobileLabel = Label1
		  txt.Text = "Waiting for QR code to scan..."
		  
		  Var reg As MobileButton = Button2
		  reg.Caption = "About"
		  
		  Var table As AndroidMobileTable = Table1
		  table.RemoveAllRows
		  
		  scannedTxt = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Register()
		  Var data() As String = scannedTxt.Split(",")
		  
		  Var d As New JSONItem
		  For i As Integer = 0 To App.endpoints.Count - 1
		    d.Value(App.endpoints(i)) = data(i).Trim
		  Next
		  
		  If App.timestamp.Lowercase <> "false" Then
		    Var dt As DateTime = DateTime.Now
		    d.Value(App.timestamp) = dt.ToString(Datetime.FormatStyles.Medium, Datetime.FormatStyles.Medium)
		  End If
		  
		  Var conn As New URLConnection
		  conn.AllowCertificateValidation = False
		  conn.SetRequestContent(d.ToString, "application/json")
		  conn.RequestHeader("Authorization") = "Bearer " + App.token
		  
		  Var response As JSONItem = New JSONItem(conn.SendSync("POST", App.api, 5))
		  
		  If conn.HTTPStatusCode = 201 Then
		    MessageBox("Successfully registered!" + Chr(13) + "[" + scannedTxt + "]")
		  Else
		    MessageBox("Error: " + conn.HTTPStatusCode.ToString + ", try again later!")
		  End If
		  
		  ClearScreen
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		scannedTxt As String
	#tag EndProperty


#tag EndScreenCode

#tag Events Button1
	#tag Event
		Sub Pressed()
		  ClearScreen
		  
		  Var scanner As Barcode = Barcode1
		  scanner.StartScan
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Barcode1
	#tag Event
		Sub ScanCompleted(value As String)
		  If value.IsEmpty Then
		    Return
		  End If
		  
		  scannedTxt = value
		  
		  Var data() As String = value.Split(",")
		  
		  If data.Count <> App.endpoints.Count Then
		    Return
		  End If
		  
		  Var table As AndroidMobileTable = Table1
		  For i As Integer = 0 To App.endpoints.Count - 1
		    table.AddRow(data(i), App.endpoints(i))
		    table.RowBoldAt(table.LastAddedRowIndex) = True
		  Next
		  
		  If App.timestamp.Lowercase <> "0x0" Then
		    Var dt As DateTime = DateTime.Now
		    table.AddRow(dt.ToString(Datetime.FormatStyles.Medium, Datetime.FormatStyles.Medium), "Date/time of QR scan")
		    table.RowBoldAt(table.LastAddedRowIndex) = True
		  End If
		  
		  Var txt As MobileLabel = Label1
		  txt.Text = "Please confirm if data is correct before registering."
		  
		  Var reg As MobileButton = Button2
		  reg.Caption = "Register"
		End Sub
	#tag EndEvent
	#tag Event
		Sub ScanCancelled()
		  ClearScreen
		End Sub
	#tag EndEvent
	#tag Event
		Sub ScanFailed()
		  ClearScreen
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Button2
	#tag Event
		Sub Pressed()
		  Select Case Me.Caption
		  Case "Register"
		    If Not scannedTxt.IsEmpty Then
		      Register
		    End If
		  Case "About"
		    MessageBox("Developed by Nisk, 2024")
		  End Select
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Index"
		Visible=true
		Group="ID"
		InitialValue="-2147483648"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Left"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Top"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ControlCount"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Behavior"
		InitialValue="Untitled"
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasNavigationBar"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Modal"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="NavigationBarHeight"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackButton"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="scannedTxt"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
#tag EndViewBehavior
