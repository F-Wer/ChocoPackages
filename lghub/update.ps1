$url32 = 'https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe'
$exeFile = Join-Path $env:TEMP "lghub_installer.exe"
function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*[$]url32\s*=\s*)(.*)" = "`$1""$($Latest.url32)"""
            # "(?i)(^\s*[$]checksum32\s*=\s*)(.*)" = "`$1""$($Latest.checksum32)"""
        }
    }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge -NoSuffix }


function global:au_GetLatest {
    (New-Object Net.WebClient).DownloadFile($url32, $exeFile)
    $version = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($exeFile).FileVersion
    return @{ Version = $version; url32 = $url32 }
}

update -ChecksumFor none