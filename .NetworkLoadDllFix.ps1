# 指定目标目录路径
$targetPath = ".\DynamicPatcher\Libraries"

# 递归解除锁定
Get-ChildItem -LiteralPath $targetPath -Filter *.dll -Recurse | ForEach-Object {
    try {
        # 解除文件锁定
        Unblock-File -LiteralPath $_.FullName -ErrorAction Stop
        Write-Host "[解锁成功] $($_.FullName)"
    }
    catch {
        Write-Warning "[解锁失败] $($_.FullName) - 原因: $_"
    }
}