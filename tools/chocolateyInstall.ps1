$packageName = 'equalizerapo';
$installerType = 'exe';
$url = 'http://sourceforge.net/projects/equalizerapo/files/1.1.1/EqualizerAPO32-1.1.1.exe/download';
$url64 = 'http://sourceforge.net/projects/equalizerapo/files/1.1.1/EqualizerAPO64-1.1.1.exe/download';
$silentArgs = '/S';
$validExitCodes = @(0);
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
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64" -validExitCodes $validExitCodes;
#Cleanup the Job
Remove-Job -Name "Kill Configurator.exe" -Force | Out-Null;