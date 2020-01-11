$ErrorActionPreference = 'Stop';

$packageName = 'equalizerapo'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)";
$installerType = 'EXE'
$url = 'https://sourceforge.net/projects/equalizerapo/files/1.2.1/EqualizerAPO32-1.2.1.exe/download';
$url64 = 'https://sourceforge.net/projects/equalizerapo/files/1.2.1/EqualizerAPO64-1.2.1.exe/download';

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = $installerType
  url           = $url
  url64bit      = $url64
  silentArgs    = '/S'
  validExitCodes= @(0)
  softwareName  = 'equalizerapo*'
  checksum      = 'F0BD8BF2D5C133989C48FD6C0D3503A98599C0955E4EF2317C099A6D4BCFDB20'
  checksumType  = 'sha256'
  checksum64      = 'BD0AC49633D02A387F906B5D4F47F9235D229470742D3433018245136756F583'
  checksumType64  = 'sha256'
};

#Create monitor for "Configurator" ahead of actually installing the software
$ScriptBlock = {
    #Wait for Configurator.exe to start running
	$configurator_open = $false;
	while (!$configurator_open) {
		Sleep -Seconds 5;
		$configurator_open = (Get-Process 'configurator' -ErrorAction:SilentlyContinue).count -eq 1;
	} #loop ends when we find the process running
    Get-Process 'configurator' | Stop-Process;
}

Start-Job -Name "Kill Configurator.exe" -ScriptBlock $ScriptBlock | Out-Null;
#Install the package
Install-ChocolateyPackage @packageArgs;
#Cleanup the Job
Remove-Job -Name "Kill Configurator.exe" -Force | Out-Null;
