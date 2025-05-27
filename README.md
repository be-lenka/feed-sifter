# 🗂️ feed-sifter

**feed-sifter** is a lightweight, cross-platform `PowerShell` script that converts structured `XML` product feeds into flat `CSV` files.  
It’s ideal for B2B/B2C product data processing, price list extraction, or automated data transformation tasks.

---

## 🚀 Features

- ✅ Reads XML feeds from a remote **URL**
- ✅ Extracts **nested fields** (like `selling_prices`) and **root fields**
- ✅ Centralized configuration for feed structure
- ✅ Outputs clean `UTF-8` encoded `CSV`
- ✅ Runs on **Windows**, **macOS**, and **Linux** (via `PowerShell Core`)

---

## 📦 Requirements

On Windows, `PowerShell` should be installed by default. 

- Windows 
  - On Windows: Download from https://github.com/PowerShell/PowerShell

- PowerShell Core (`pwsh`)
  - On macOS/Linux: `brew install --cask powershell`

---

## 🔧 Usage
### 🪟 Windows 
```powershell
.\FeedSift.ps1 -xmlUrl "https://example.com/path/to/feed.xml"
```
###  MacOS
```bash
pwsh ./FeedToCSV.ps1 -xmlUrl "https://example.com/path/to/feed.xml"
```

### Parameters

| Parameter | Description |
|----------|-------------|
| `-xmlUrl` | **(Required)** URL of the remote XML feed you want to process |

---

## 🧠 Feed Structure Configuration

Inside the script, you can easily configure the feed structure:

```powershell
$feedStructure = @{
    rootPath = "//item"     # XML path to repeating items
    nestedRepeats = @{
        selling_prices = @("currency", "base_price", "discount_price")          # nested arrays
    }
    flatFields = @("ean", "availability", "availability_count")         # root-level fields
}
```

Just modify the `flatFields` or `nestedRepeats` arrays to match your `XML` feed layout.

---

## 📁 Output

The resulting `output.csv` file will be written to the script's current working directory.  
It contains headers and all mapped values from the `XML` feed.

Example output:

```csv
ean,availability,availability_count,currency,base_price,discount_price
20000000025,in stock,14,CZK,2500,1999
...
```

---

## 💡 Tips

- Works with `HTTPS` feeds and requires no authentication.
- To change output file name or encoding, modify the `$outputPath` and `Set-Content`/`Add-Content` lines.
- You can redirect output to a timestamped file for batch jobs.

---

## 🔐 Execution Policy Troubleshooting

If you're running the script and see an error like:

```text
File cannot be loaded because running scripts is disabled on this system.
```

This means PowerShell's **execution policy** is blocking script execution.

### ✅ Temporary Fix (Safe for Local Use)

Run this in your current terminal session **before executing the script**:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

---

## 📜 License

MIT — free to use, modify, and distribute.  
Feel free to fork and contribute!

---

## ✨ Credits

Built with 💙 by [BeLenka X Barebarics](https://github.com/be-lenka)

<!-- 🛒 Visit our stores [BeLenka](https://www.belenka.com)
and [Barebarics](https://www.barebarics.com). -->

Inspired by real-world XML product feed challenges.
