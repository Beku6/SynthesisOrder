param(
    [int]$BrandingCanvasWidth = 800,
    [int]$BrandingCanvasHeight = 480,
    [int]$BrandingVisibleWidth = 440,
    [string]$BrandingBackground = "#FAFAFA"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$sourceBranding = Join-Path $repoRoot "assets\images\branding\bekoo_wordmark_dark.png"
$nativeBranding = Join-Path $repoRoot "assets\images\branding\native_bekoo_branding_dark.png"
$lightV31Styles = Join-Path $repoRoot "android\app\src\main\res\values-v31\styles.xml"
$darkV31Styles = Join-Path $repoRoot "android\app\src\main\res\values-night-v31\styles.xml"

Add-Type -AssemblyName System.Drawing

$image = [System.Drawing.Image]::FromFile($sourceBranding)
try {
    $canvas = New-Object System.Drawing.Bitmap $BrandingCanvasWidth, $BrandingCanvasHeight
    try {
        $graphics = [System.Drawing.Graphics]::FromImage($canvas)
        try {
            $backgroundColor = [System.Drawing.ColorTranslator]::FromHtml($BrandingBackground)
            $graphics.Clear($backgroundColor)
            $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
            $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
            $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

            $targetWidth = $BrandingVisibleWidth
            $targetHeight = [int][Math]::Round($image.Height * ($targetWidth / $image.Width))
            $x = [int](($BrandingCanvasWidth - $targetWidth) / 2)
            $y = [int](($BrandingCanvasHeight - $targetHeight) / 2)

            $graphics.DrawImage($image, $x, $y, $targetWidth, $targetHeight)
            $canvas.Save($nativeBranding, [System.Drawing.Imaging.ImageFormat]::Png)
        }
        finally {
            $graphics.Dispose()
        }
    }
    finally {
        $canvas.Dispose()
    }
}
finally {
    $image.Dispose()
}

Push-Location $repoRoot
try {
    dart run flutter_native_splash:create | Out-Host
}
finally {
    Pop-Location
}

$brandingLine = '        <item name="android:windowSplashScreenBrandingImage">@drawable/branding</item>'

foreach ($stylesPath in @($lightV31Styles, $darkV31Styles)) {
    $content = Get-Content -Raw $stylesPath
    if ($content -notmatch 'windowSplashScreenBrandingImage') {
        $content = $content -replace '(<item name="android:windowSplashScreenAnimatedIcon">@drawable/android12splash</item>)', "`$1`r`n$brandingLine"
        Set-Content -Path $stylesPath -Value $content -NoNewline
    }
}

Write-Host "Native splash branding regenerated and Android 12 branding restored."
