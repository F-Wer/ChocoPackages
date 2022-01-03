import-module au

$releases = 'https://github.com/httptoolkit/httptoolkit-desktop/releases/latest'

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
    }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge -NoSuffix }


function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    
    $regex = '.exe$'
    $url = $download_page.links | ? href -match $regex | select -First 1 -expand href | % { 'https://github.com' + $_ }

    $version = $url -split '/' | select -Last 1 -Skip 1
    
    @{
        URL64        = $url
        Version      = $version.Replace('v', '')
        ReleaseNotes = "https://github.com/httptoolkit/httptoolkit-desktop/releases/tag/${version}"
    }
}

update -ChecksumFor 64