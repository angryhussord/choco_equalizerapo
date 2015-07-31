$packageName = 'equalizerapo';
$installerType = 'exe';
$url = 'http://sourceforge.net/projects/equalizerapo/files/latest/download';
$silentArgs = '/S';
$validExitCodes = @(0);
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes $validExitCodes;