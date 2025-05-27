param (
    [Parameter(Mandatory = $true)]
    [string]$xmlUrl
)

# 🌐 Download XML
try {
    Write-Host "🌐 Downloading feed from: $xmlUrl"
    $response = Invoke-WebRequest -Uri $xmlUrl -UseBasicParsing
    [xml]$originalXml = $response.Content
}
catch {
    Write-Error "❌ Failed to download or parse XML from $xmlUrl"
    exit 1
}

# 🧠 Structure definition
$feedStructure = @{
    rootPath = "//item"
    nestedRepeats = @{
        selling_prices = @("currency", "base_price", "discount_price")
    }
    flatFields = @("ean", "availability", "availability_count")
}

# 🏗️ Create a new XML document to hold the stripped version
$strippedXml = New-Object System.Xml.XmlDocument
$itemsNode = $strippedXml.CreateElement("items")
$strippedXml.AppendChild($itemsNode) | Out-Null

# 🧹 Process each item
foreach ($item in $originalXml.SelectNodes($feedStructure.rootPath)) {
    $newItem = $strippedXml.CreateElement("item")

    # Copy flat fields
    foreach ($field in $feedStructure.flatFields) {
        $node = $item.SelectSingleNode($field)
        if ($node -ne $null -and $node.InnerText -ne "") {
            $element = $strippedXml.CreateElement($field)
            $element.InnerText = $node.InnerText
            $newItem.AppendChild($element) | Out-Null
        }
    }

    # Copy nested repeat fields
    foreach ($nestedPath in $feedStructure.nestedRepeats.Keys) {
        $subnodes = $item.SelectNodes($nestedPath)
        foreach ($subnode in $subnodes) {
            $subElement = $strippedXml.CreateElement($nestedPath)
            foreach ($nestedField in $feedStructure.nestedRepeats[$nestedPath]) {
                $nestedNode = $subnode.SelectSingleNode($nestedField)
                if ($nestedNode -ne $null -and $nestedNode.InnerText -ne "") {
                    $fieldElement = $strippedXml.CreateElement($nestedField)
                    $fieldElement.InnerText = $nestedNode.InnerText
                    $subElement.AppendChild($fieldElement) | Out-Null
                }
            }
            $newItem.AppendChild($subElement) | Out-Null
        }
    }

    $itemsNode.AppendChild($newItem) | Out-Null
}

# 💾 Save the stripped XML
$outputXmlPath = "stripped-output.xml"
$strippedXml.Save($outputXmlPath)

Write-Host "✅ Stripped XML saved to: $outputXmlPath"
