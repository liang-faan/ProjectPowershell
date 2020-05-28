$str = Read-Host "Input the string to secure: "

ConvertTo-SecureString -String $str -AsPlainText -force | ConvertFrom-SecureString | Out-File secure.dat