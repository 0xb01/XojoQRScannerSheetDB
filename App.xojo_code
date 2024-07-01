#tag Class
Protected Class App
Inherits MobileApplication
	#tag Event
		Sub Opening()
		  // Scanner by Nisk, 2024
		  // =====
		  // Set a pastebin link in Initialize method and build.
		  // Let the pastebin link do the work!
		  
		  Initialize
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Initialize()
		  Var conn As New URLConnection
		  conn.AllowCertificateValidation = False
		  
		  // Hello World:
		  // This is where we put our pastebin link... forever.
		  // After we build this, we don't have to change anything else,
		  // the app can do the rest.
		  // Format:
		  // column1,column2,column3,etc..., sheetdb.io api,key,HasTimestamp[True/False]
		  // Sample:
		  // Name,School,Year,https://sheetdb.io/api/v1/asdfgh123,alksdfaksdjlasdjkasdl5,HasTimestamp[False]
		  // Note:
		  // Setting "HasTimestamp" to True will generate a timestamp in the last column.
		  // Add as many columns as you want.
		  Var response As String = conn.SendSync("GET", "https://pastebin.com/raw/", 5)
		  
		  If conn.HTTPStatusCode = 400 Then
		    MessageBox("Failed to initialize, re-open app and try again!")
		    Exit
		  End If
		  
		  Var data() As String = response.Split(",")
		  
		  Var info() As String
		  For i As Integer = data.LastIndex - 2 To data.LastIndex
		    info.Add(data(i).Trim)
		  Next
		  
		  For i As Integer = 1 To 3
		    data.RemoveAt(data.LastIndex)
		  Next
		  
		  api = info(0)
		  token = info(1)
		  timestamp = info(2)
		  
		  timestamp = timestamp.ReplaceAll("HasTimestamp[", "")
		  timestamp = timestamp.ReplaceAll("]", "")
		  
		  If timestamp.Lowercase = "false" Then
		    timestamp = "0x0"
		  End If
		  
		  endpoints = data
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		api As String
	#tag EndProperty

	#tag Property, Flags = &h0
		endpoints() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		timestamp As String
	#tag EndProperty

	#tag Property, Flags = &h0
		token As String
	#tag EndProperty


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
			Name="BugVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MajorVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinorVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NonReleaseVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Version"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ThemeColorName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ThemeDarkColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ThemeLightColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ThemeMediumColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="api"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="token"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="timestamp"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
