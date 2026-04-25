Write-Host "work path: $PSScriptRoot"

# 第一步：创建输出目录
$outputRoot = Join-Path -Path $PSScriptRoot -ChildPath "__AABuildOut"
$outputDP = Join-Path -Path $outputRoot -ChildPath "DynamicPatcher"


# 方法1：先判断再删除
if (Test-Path -Path $outputRoot) {
    Remove-Item -Path $outputRoot -Recurse -Force
    Write-Host "文件夹已删除: $outputRoot" -ForegroundColor Green
} else {
    Write-Host "文件夹不存在: $outputRoot" -ForegroundColor Yellow
}



Write-Host "创建输出目录..."
New-Item -Path $outputRoot -ItemType Directory -Force | Out-Null
New-Item -Path $outputDP -ItemType Directory -Force | Out-Null
Write-Host "输出目录创建完成: $outputDP"

# 第二步：复制文件
Write-Host "开始复制文件..."

# 复制 packedlist
$sourcePackedList = Join-Path -Path $PSScriptRoot -ChildPath "DynamicPatcher\Packages\packedlist"
$destPackedList = Join-Path -Path $outputDP -ChildPath "Packages\packedlist"
if (Test-Path $sourcePackedList) {
    New-Item -Path (Split-Path $destPackedList -Parent) -ItemType Directory -Force | Out-Null
    Copy-Item -Path $sourcePackedList -Destination $destPackedList -Force
    Write-Host "已复制: $sourcePackedList -> $destPackedList"
} else {
    Write-Warning "找不到源文件: $sourcePackedList"
}

# 复制 Build 文件夹
$sourceBuild = Join-Path -Path $PSScriptRoot -ChildPath "DynamicPatcher\Packages\Build"
$destBuild = Join-Path -Path $outputDP -ChildPath "Build"
if (Test-Path $sourceBuild) {
    Copy-Item -Path $sourceBuild -Destination $destBuild -Recurse -Force
    Write-Host "已复制: $sourceBuild -> $destBuild"
} else {
    Write-Warning "找不到源文件夹: $sourceBuild"
}

# 复制 Libraries 文件夹
$sourceLibraries = Join-Path -Path $PSScriptRoot -ChildPath "DynamicPatcher\Libraries"
$destLibraries = Join-Path -Path $outputDP -ChildPath "Libraries"
if (Test-Path $sourceLibraries) {
    Copy-Item -Path $sourceLibraries -Destination $destLibraries -Recurse -Force
    Write-Host "已复制: $sourceLibraries -> $destLibraries"
} else {
    Write-Warning "找不到源文件夹: $sourceLibraries"
}

# 复制所有的 .json 文件
$sourceJsonFiles = Join-Path -Path $PSScriptRoot -ChildPath "DynamicPatcher\*.json"
Get-ChildItem -Path $sourceJsonFiles | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $outputDP -Force
    Write-Host "已复制: $($_.Name)"
}




$sourceFilePath = Join-Path -Path $PSScriptRoot -ChildPath "DynamicPatcher_RELEASE.dll"
$destFilePath = Join-Path -Path $outputRoot -ChildPath "DynamicPatcher.dll"

if (Test-Path $sourceFilePath) {
Copy-Item -Path $sourceFilePath -Destination $destFilePath -Force
Write-Host "已复制: $sourceFilePath -> $destFilePath"
} else {
    Write-Warning "找不到源文件夹: $sourceFilePath"
}

$sourceFilePath = Join-Path -Path $PSScriptRoot -ChildPath "PatcherLoader.dll"
$destFilePath = Join-Path -Path $outputRoot -ChildPath "PatcherLoader.dll"

if (Test-Path $sourceFilePath) {
Copy-Item -Path $sourceFilePath -Destination $destFilePath -Force
Write-Host "已复制: $sourceFilePath -> $destFilePath"
} else {
    Write-Warning "找不到源文件夹: $sourceFilePath"
}

$sourceFilePath = Join-Path -Path $PSScriptRoot -ChildPath "PatcherLauncher.exe"
$destFilePath = Join-Path -Path $outputRoot -ChildPath "PatcherLauncher.exe"

if (Test-Path $sourceFilePath) {
Copy-Item -Path $sourceFilePath -Destination $destFilePath -Force
Write-Host "已复制: $sourceFilePath -> $destFilePath"
} else {
    Write-Warning "找不到源文件夹: $sourceFilePath"
}



Write-Host "文件复制完成"

# 第三步：处理 packedlist 文件
Write-Host "开始处理 packedlist 文件..."
if (Test-Path $destPackedList) {
    $content = Get-Content -Path $destPackedList -Raw
    # 替换路径前缀
    $newContent = $content -replace [regex]::Escape($PSScriptRoot), "."
    Set-Content -Path $destPackedList -Value $newContent -NoNewline
    Write-Host "packedlist 文件已处理完成"
    
    # 显示处理结果示例
    $sampleLines = (Get-Content -Path $destPackedList | Select-Object -First 3)
    Write-Host "处理后的示例:"
    $sampleLines | ForEach-Object { Write-Host "  $_" }
} else {
    Write-Warning "找不到 packedlist 文件: $destPackedList"
}

Write-Host "脚本执行完成！输出目录: $outputRoot"