$Sectoare = "38","39","40","41","42","43","15749","15388","15710","14071","15739","15734","5937","15717"
foreach($sector in $Sectoare) {
    
    $url = "https://www.catena.ro/cauta-in-farmacii/produs/57095?nume_produs=Vaccin+antigripal+Fluenz+Tetra+x+1+pulverizator+(sticla)+x+0%2C2+ml+susp.+nazala+spray+&judet=33&localitate=$sector"
    $Disponibilitate = Invoke-WebRequest -Uri $url  -Method Get
    if($Disponibilitate.Content -match "este disponibil in urmatoarele farmacii Catena") {
        & PushOver.ps1 -UserKey "xxx" -ApiKey "xxxx" -Message "Gasit Vaccin" -Url $url
    }
    else {Write-Host "nu am gasit in $sector"}
    sleep 5
}
