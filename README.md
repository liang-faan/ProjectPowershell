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