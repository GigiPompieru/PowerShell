function convert-PDFtoText {
	param(
		[Parameter(Mandatory=$true)][string]$file
	)
    Add-Type -Path "itextsharp.dll"
    #from http://allthesystems.com/2020/10/read-text-from-a-pdf-with-powershell/
	$pdf = New-Object iTextSharp.text.pdf.pdfreader -ArgumentList $file
	for ($page = 1; $page -le $pdf.NumberOfPages; $page++){
		$text=[iTextSharp.text.pdf.parser.PdfTextExtractor]::GetTextFromPage($pdf,$page)
		Write-Output $text
	}	
	$pdf.Close()
}
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Set-Location $dir

$n = 0
do {
    $luni = (Get-Date -Hour 0 -Minute 0 -Second 0).AddDays(-$n)
    $n++
}
Until ( $luni.DayOfWeek -eq "Monday" )
$duminica = $luni.AddDays(6)
$l = Get-date $luni -Format "dd.MM.yyyy"
$d = Get-date $duminica -Format "dd.MM.yyyy"
$file = "https://www.e-distributie.com/content/dam/e-distributie/outages/pdf/Muntenia/2021/Intreruperi%20programate%20in%20zona%20Muntenia%20$l%20-%20$d.pdf"

$text = convert-PDFtoText $file
$text | Out-File "output.txt"
$outages = Get-Content "output.txt"

foreach($line in $outages) {
    if(($line -match "Bragadiru") -or ($line -match "Olteni") -or ($line -match "Domnesti")) {
       & PushOver.ps1 -UserKey "xxx" -ApiKey "xxx" -Message "Intrerupere Enel" -Url $file

    }
}
