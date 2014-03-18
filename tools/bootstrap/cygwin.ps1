#
# Execute a logout message.
#
# Authors:
#   Larry Gordon
#
# Execution Order
#   https://github.com/psyrendust/alf/templates/home
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

function Install-Cygwin {
   param ( $TempCygDir="C:\Cygwin\cygwinsetup.exe" )
   if(!(Test-Path -Path $TempCygDir -PathType Container))
    {
       $null = New-Item -Type Directory -Path $TempCygDir -Force
    }
   $client = new-object System.Net.WebClient
   $client.DownloadFile("http://cygwin.com/setup.exe", "$TempCygDir\setup.exe" )
   Start-Process -wait -FilePath "$TempCygDir\setup.exe" -ArgumentList "-q -n -l $TempCygDir -s http://mirror.nyi.net/cygwin/ -R c:\Cygwin"
   Start-Process -wait -FilePath "$TempCygDir\setup.exe" -ArgumentList "-q -n -l $TempCygDir -s http://mirror.nyi.net/cygwin/ -R c:\Cygwin -P openssh"
}
