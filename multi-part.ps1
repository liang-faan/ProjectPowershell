Write-Host "Plese prepare whitelist csv file with template"

$token = "Bearertoken**"

$filePath = Read-Host "Please input the file path"

$fileName = Split-Path -Path $filePath -Leaf

$boundary = [guid]::NewGuid().ToString()

#$fileBin = [System.IO.File]::ReadAllBytes($filePath)
#$enc = [System.Text.Encoding]::GetEncoding("iso-8859-1")
#$fileEnc = $enc.GetString($fileBin)

$fileEnc = Get-Content -Path $filePath -Raw -Encoding UTF8

$LF = "`r`n"

$bodyLines = @(

    "--$boundary",
    "Content-Type: application/octet-stream$LF name=$filename",
    "Content-Transfer-Encoding: binary"
    "Content-Disposition: form-data; name=`"file`"; filename=`"$filename`"$LF",
    $fileEnc,
    "--$boundary--$LF"
        
) -join $LF

Write-Host $bodyLines

#Read-Host "Press 'Y' to continue"

$headers = @{'Accept' = 'application/json'; 'x-int-role' = 'create'; 'Authorization' = $token }
try {
    $Result = Invoke-RestMethod -Uri "http://localhost:8101/upload" -Headers $headers -ContentType "multipart/form-data; boundary=$boundary" -Method Post -Body $bodyLines
    $Result | Write-Output | Out-Host
}
catch {
    $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
    $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
    $streamReader.Close()
    Write-Output $ErrResp | Out-Host
    
}
#-ContentType "multipart/form-data; boundary=$boundary"


Read-Host -Prompt "Press any key to continue or CTRL+C to quit"
