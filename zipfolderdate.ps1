#Choose a folder to compress into a .ZIP. If you want it to be the root without zipping the directory, leave off the end '\'. 
$ZipPath = 'C:\Archive'

#For this instance, we wanted to zip a folders contents and name it to include the date from yesterday. 
$Date = (get-date).AddDays(-1).ToString("yyyMMdd")

#Try and fail statement chain. 
try {
  Compress-Archive C:\Temp\* -DestinationPath ($ZipPath + $Date + '.zip')
$PSEmailServer = 'e-mailserver.com'
Send-MailMessage -From 'person@website.com' -To 'person@website.com' -Subject 'ZIPIT PS Successful' -port '25'
}
catch [System.Net.WebException],[System.IO.IOException] {
    Send-MailMessage -From 'person@website.com' -To 'person@website.com' -Subject 'ZIPIT PS Fail' -port '25'
}
catch {
    Send-MailMessage -From 'person@website.com' -To 'person@website.com' -Subject 'ZIPIT PS Fail' -port '25'
}

#1. For the SFTP portion, you'll need WINSCP installed. 
#2. Login using the GUI to collect your SFTP login information. https://winscp.net/eng/docs/guide_automation #Generating Script section
#3. Update the fields with your connection settings. 
#4. Put command will grab any file in the directory which should just be one for a daily, ignore timestamps, filter by zip file, delete once completed so the next days just has the single file. 
"C:\Program Files (x86)\WinSCP\WinSCP.com" ^
  /log="C:\scripts\WinSCP.log" /ini=nul ^
  /command ^
    "open sftp://user:PW@host/ -hostkey=""ssh-ed25519 255 key""" ^
    "lcd C:\Archive" ^
    "cd /home/user/test" ^
	"put * -delete -nopermissions -nopreservetime -resumesupport=off -filemask=*.zip" ^
    "exit"

set WINSCP_RESULT=%ERRORLEVEL%
if %WINSCP_RESULT% equ 0 (
  echo Success
) else (
  echo Error
)

exit /b %WINSCP_RESULT%
