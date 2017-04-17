$ErrorActionPreference = 'Stop';

$packageName = 'equalizerapo'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)";
$installerType = 'EXE'
$url = 'http://sourceforge.net/projects/equalizerapo/files/1.1.2/EqualizerAPO32-1.1.2.exe/download';
$url64 = 'http://sourceforge.net/projects/equalizerapo/files/1.1.2/EqualizerAPO64-1.1.2.exe/download';

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = $installerType
  url           = $url
  url64bit      = $url64
  silentArgs    = '/S'
  validExitCodes= @(0)
  softwareName  = 'equalizerapo*'
  checksum      = '42E0C5AF84FFFBEF39C299BBF9A7F7C5306038D47A973A5F840BC5D60A3F680D'
  checksumType  = 'sha256'
  checksum64      = '04602BEEAFDE280F37FF56D3958470EB5C888AE0E6858465576AED32617EBC04'
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