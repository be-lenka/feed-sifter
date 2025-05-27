param (
    [Parameter(Mandatory = $true)]
    [string]$xmlUrl
)

try {
    Write-Host "🌐 Downloading feed from: $xmlUrl"
    $response = Invoke-WebRequest -Uri $xmlUrl -UseBasicParsing
    [xml]$xml = $response.Content
}
catch {
    Write-Error "❌ Failed to download or parse XML from $xmlUrl"
    exit 1
}

Write-Host "✍🏽 Writing to CSV file"
$outputPath = "output.csv"
$headers = "ean,availability,availability_count,currency,base_price,discount_price"
Set-Content -Path $outputPath -Value $headers -Encoding UTF8

foreach ($item in $xml.SelectNodes("//item")) {
    $ean = $item.ean -as [string]
    $availability = $item.availability -as [string]
    $availability_count = $item.availability_count -as [string]

    foreach ($sp in $item.SelectNodes("selling_prices")) {
        $currency = $sp.currency -as [string]
        $base_price = $sp.base_price -as [string]
        # $discount_price = $sp.discount_price -as [string]
        $discount_price = $sp.discount_price?.InnerText

        $line = "$ean,$availability,$availability_count,$currency,$base_price,$discount_price"
        Add-Content -Path $outputPath -Value $line -Encoding UTF8
    }
}

Write-Host "✅ Export complete! CSV saved to: $outputPath"
