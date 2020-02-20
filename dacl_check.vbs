Wscript.Echo "Searching for weak DACLs on all installed services..."
Dim re,tmp1,tmp2, currService, matches, vulnerable
Set re = new regexp
Set re2 = new regexp
Set objShell = CreateObject("WScript.Shell")
Set objScriptExec = objShell.Exec("sc query type= service state= all")
matches = 0
re.Pattern = "^SERVICE_NAME"
do while Not objScriptExec.StdOut.AtEndOfStream
tmp1 = objScriptExec.StdOut.ReadLine
If re.Test(tmp1) Then
 currService = Right(tmp1,Len(tmp1)-14)
 Set objScriptExec2 = objshell.Exec("sc sdshow """ & currService & """")
 re2.Pattern = "\(A;[A-Z;]*(WD|WO|DC)[A-Z;]*;(WD|BU|BG|AU)\)"
 tmp2 = objScriptExec2.StdOut.ReadAll
 If re2.Test(tmp2) or Len(tmp2) < 7 Then
  Wscript.Echo "Service " & currService & " appears to be vulnerable!"& tmp2
  matches = matches + 1
  vulnerable = vulnerable & vbcrlf & currService
 End If
End If
loop
Wscript.Echo "Found " & matches & " potentially vulnerable services:"
Wscript.Echo vulnerable
