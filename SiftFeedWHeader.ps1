param (
    [Parameter(Mandatory = $true)]
    [string]$xmlUrl
)

# 🌐 Download XML
try {
    Write-Host "🌐 Downloading feed from: $xmlUrl"
    $response = Invoke-WebRequest -Uri $xmlUrl -UseBasicParsing
    [xml]$xml = $response.Content
}
catch {
    Write-Error "❌ Failed to download or parse XML from $xmlUrl"
    exit 1
}

# 📋 Define the structure
$feedStructure = @{
    rootPath = "//item"
    nestedRepeats = @{
        selling_prices = @("currency", "base_price", "discount_price")
    }
    flatFields = @("ean", "availability", "availability_count")
}

$outputPath = "output.csv"

# 🪄 Generate header from both flat and nested fields
$header = @($feedStructure.flatFields)
foreach ($key in $feedStructure.nestedRepeats.Keys) {
    $header += $feedStructure.nestedRepeats[$key]
}
Set-Content -Path $outputPath -Value ($header -join ",") -Encoding UTF8

# 🧱 Parse XML structure
foreach ($item in $xml.SelectNodes($feedStructure.rootPath)) {
    $flatData = @{}
    foreach ($field in $feedStructure.flatFields) {
        $flatData[$field] = $item.SelectSingleNode($field)?.InnerText
    }

    foreach ($nestedPath in $feedStructure.nestedRepeats.Keys) {
        $subnodes = $item.SelectNodes($nestedPath)
        foreach ($subnode in $subnodes) {
            $line = @()
            foreach ($field in $feedStructure.flatFields) {
                $line += $flatData[$field]
            }
            foreach ($nestedField in $feedStructure.nestedRepeats[$nestedPath]) {
                $line += $subnode.SelectSingleNode($nestedField)?.InnerText
            }
            Add-Content -Path $outputPath -Value ($line -join ",") -Encoding UTF8
        }
    }
}

Write-Host "✅ Export complete! CSV saved to: $outputPath"
