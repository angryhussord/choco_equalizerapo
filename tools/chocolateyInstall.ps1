$packageName = 'equalizerapo';
$installerType = 'exe';
$url = 'http://sourceforge.net/projects/equalizerapo/files/1.0/EqualizerAPO32-1.0.exe/download';
$url64 = 'http://sourceforge.net/projects/equalizerapo/files/1.0/EqualizerAPO64-1.0.exe/download';
$silentArgs = '/S';
$validExitCodes = @(0);
#Create monitor for "Configurator" ahead of actually installing the software
$ScriptBlock = {
	$setup_running = $true;
	while ($setup_running) {
		Sleep -Seconds 1;
		$setup_running = (Get-Process 'EqualizerAPO*-0.9.2' -ErrorAction:SilentlyContinue).count -eq 1;
	}
	$configurator_running = $true;
	while ($configurator_running) {
		Sleep -Seconds 1;
		Get-Process 'configurator' | Stop-Process;
		$configurator_running = (Get-Process 'configurator' -ErrorAction:SilentlyContinue).count -eq 1;
	}
}
Start-Job -Name "Kill Configurator.exe" -ScriptBlock $ScriptBlock | Out-Null;
#Install the package
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64" -validExitCodes $validExitCodes;
#Cleanup the Job
Remove-Job -Name "Kill Configurator.exe" -Force | Out-Null;