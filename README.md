# Sample of Powershell Access Rest API

## GET Access REST API with Bearer Token 
```
$uri = * Put your URL here *
$token = "Bearertoken**"
$headers = @{'Accept' = 'application/json'; 'x-int-role' = 'retrieve'; 'Authorization' = $token }
try {
    $response = Invoke-RestMethod -Uri "$uri" -headers $headers -Method Get
    $response | Write-Output | Out-Host
}
catch {
    $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
    $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
    $streamReader.Close()
    Write-Output $ErrResp | Out-Host

}

```

## POST Access REST API with Bearer Token
```
$uri = * Put your URL here *
$token = "Bearertoken**"

$bodyObj = @{
        property1 = "$value1"
        property2         = "$value2"
        property3     = $value3
        property4 = $value4
        startDate         = Get-Date -Format "yyyy-MM-dd'T'HH:mm:ss.fff'Z'"
        endDate           = Get-Date -Format "yyyy-MM-dd'T'HH:mm:ss.fff'Z'" -Year 2099
    }
$body = ConvertTo-Json -InputObject $bodyObj

$headers = @{'Accept' = 'application/json'; 'x-int-role' = 'create'; 'Authorization' = $token }
try {
    $response = Invoke-RestMethod -Uri "$uri" -headers $headers -Method POST -ContentType 'application/json' -Body $body
    $response | Write-Output | Out-Host
}
catch {
    $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
    $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
    $streamReader.Close()
    Write-Output $ErrResp | Out-Host

}
```

## POST Access REST API with upload file
```
Write-Host "Plese prepare whitelist csv file with template"

$token = "Bearertoken**"

$filePath = Read-Host "Please input the file path"

$fileName = Split-Path -Path $filePath -Leaf

$boundary = [guid]::NewGuid().ToString()

#$fileBin = [System.IO.File]::ReadAllBytes($filePath)
#$enc = [System.Text.Encoding]::GetEncoding("iso-8859-1")
#$fileEnc = $enc.GetString($fileBin)

#Use Get-Content has better performance than stream input
$fileEnc = Get-Content -Path $filePath -Raw -Encoding UTF8

$LF = "`r`n"


# please update the name of Content-Disposition if multipart content name are different in server 

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
    $Result = Invoke-RestMethod -Uri "$uri" -Headers $headers -ContentType "multipart/form-data; boundary=$boundary" -Method Post -Body $bodyLines
    $Result | Write-Output | Out-Host
}
catch {
    $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
    $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
    $streamReader.Close()
    Write-Output $ErrResp | Out-Host
    
}

Read-Host -Prompt "Press any key to continue or CTRL+C to quit"
```

## Format table
```
$response | Format-Table -Property property1, property2, property3, property4, property5, property6, property7, property8 -AutoSize | Write-Output | out-host
```

## Convert Json to Csv
```
$folderName = "Output"
$date = Get-Date -Format "yyyy-MM-dd"
$file = "{0}_{1}.csv" -f $folderName, $date

#$response | ConvertTo-Json -depth 100 | Out-File $file
$response | ConvertTo-Csv -NoTypeInformation | Set-Content ".\$folderName\$file"
```