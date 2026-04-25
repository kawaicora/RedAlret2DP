Write-Host "work path: $PSScriptRoot"
$DebugPath = Join-Path -Path $PSScriptRoot -ChildPath "debug"

$DPLogsPath = Join-Path -Path $PSScriptRoot -ChildPath "DynamicPatcher\Logs"
# 方法1：先判断再删除
if (Test-Path -Path $DebugPath) {
    Remove-Item -Path $DebugPath -Recurse -Force
    Write-Host "文件夹已删除: $DebugPath" -ForegroundColor Green
} else {
    Write-Host "文件夹不存在: $DebugPath" -ForegroundColor Yellow
}


if (Test-Path -Path $DPLogsPath) {
    Remove-Item -Path $DPLogsPath -Recurse -Force
    Write-Host "文件夹已删除: $DPLogsPath" -ForegroundColor Green
} else {
    Write-Host "文件夹不存在: $DPLogsPath" -ForegroundColor Yellow
}
