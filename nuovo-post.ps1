#Requires -Version 5.1
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$scriptDir  = Split-Path -Parent $MyInvocation.MyCommand.Path
$postsDir   = Join-Path $scriptDir "src\data\blog"
$inboxDir   = Join-Path $scriptDir "Inbox"
$imgPostDir = Join-Path $scriptDir "public\images\post"
$audioDir   = Join-Path $scriptDir "public\audio"
$videoDir   = Join-Path $scriptDir "public\video"

if (-not (Test-Path $inboxDir)) {
    New-Item -ItemType Directory -Path $inboxDir | Out-Null
}

function ConvertTo-Slug($text) {
    $t = $text.ToLower()
    $t = $t -replace '[àáâäã]', 'a'
    $t = $t -replace '[èéêë]',  'e'
    $t = $t -replace '[ìíîï]',  'i'
    $t = $t -replace '[òóôöõ]', 'o'
    $t = $t -replace '[ùúûü]',  'u'
    $t = $t -replace 'ñ', 'n'
    $t = $t -replace 'ç', 'c'
    $t = $t -replace 'ß', 'ss'
    $t = $t -replace '[^a-z0-9\s-]', ''
    $t = $t -replace '\s+', '-'
    $t = $t.Trim('-')
    return $t
}

# --- Form principale ---
$form = New-Object System.Windows.Forms.Form
$form.Text            = "Nuovo Post - Blog Odnikud"
$form.Size            = New-Object System.Drawing.Size(480, 310)
$form.StartPosition   = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox     = $false
$form.MinimizeBox     = $false
$form.Font            = New-Object System.Drawing.Font("Segoe UI", 10)
$form.BackColor       = [System.Drawing.Color]::FromArgb(245, 245, 245)

# Gruppo data
$grpDate          = New-Object System.Windows.Forms.GroupBox
$grpDate.Text     = "Data del post"
$grpDate.Location = New-Object System.Drawing.Point(16, 12)
$grpDate.Size     = New-Object System.Drawing.Size(435, 90)

$rbToday          = New-Object System.Windows.Forms.RadioButton
$rbToday.Text     = "Data odierna  ($((Get-Date).ToString('dd/MM/yyyy')))"
$rbToday.Location = New-Object System.Drawing.Point(12, 22)
$rbToday.AutoSize = $true
$rbToday.Checked  = $true

$rbCustom          = New-Object System.Windows.Forms.RadioButton
$rbCustom.Text     = "Data personalizzata:"
$rbCustom.Location = New-Object System.Drawing.Point(12, 52)
$rbCustom.AutoSize = $true

$dtPicker              = New-Object System.Windows.Forms.DateTimePicker
$dtPicker.Location     = New-Object System.Drawing.Point(200, 48)
$dtPicker.Size         = New-Object System.Drawing.Size(220, 26)
$dtPicker.Format       = [System.Windows.Forms.DateTimePickerFormat]::Custom
$dtPicker.CustomFormat = "dd/MM/yyyy"
$dtPicker.Enabled      = $false

$rbToday.Add_CheckedChanged({  $dtPicker.Enabled = $rbCustom.Checked })
$rbCustom.Add_CheckedChanged({ $dtPicker.Enabled = $rbCustom.Checked })

$grpDate.Controls.AddRange(@($rbToday, $rbCustom, $dtPicker))

# Titolo
$lblTitle          = New-Object System.Windows.Forms.Label
$lblTitle.Text     = "Titolo del post:"
$lblTitle.Location = New-Object System.Drawing.Point(16, 118)
$lblTitle.AutoSize = $true

$txtTitle          = New-Object System.Windows.Forms.TextBox
$txtTitle.Location = New-Object System.Drawing.Point(16, 140)
$txtTitle.Size     = New-Object System.Drawing.Size(435, 26)

# Anteprima nome file
$lblPreview           = New-Object System.Windows.Forms.Label
$lblPreview.Location  = New-Object System.Drawing.Point(16, 172)
$lblPreview.Size      = New-Object System.Drawing.Size(435, 18)
$lblPreview.ForeColor = [System.Drawing.Color]::Gray
$lblPreview.Font      = New-Object System.Drawing.Font("Segoe UI", 8)
$lblPreview.Text      = "Nome file: (scrivi il titolo)"

$updatePreview = {
    $d = if ($rbToday.Checked) { Get-Date } else { $dtPicker.Value }
    $s = ConvertTo-Slug $txtTitle.Text
    if ($s -eq '') { $lblPreview.Text = "Nome file: (scrivi il titolo)" }
    else           { $lblPreview.Text = "Nome file: $($d.ToString('yyyy-MM-dd'))-$s.md" }
}
$txtTitle.Add_TextChanged($updatePreview)
$rbToday.Add_CheckedChanged($updatePreview)
$rbCustom.Add_CheckedChanged($updatePreview)
$dtPicker.Add_ValueChanged($updatePreview)

# Pulsanti
$btnOK               = New-Object System.Windows.Forms.Button
$btnOK.Text          = "Crea post"
$btnOK.Location      = New-Object System.Drawing.Point(255, 200)
$btnOK.Size          = New-Object System.Drawing.Size(95, 32)
$btnOK.BackColor     = [System.Drawing.Color]::FromArgb(0, 120, 215)
$btnOK.ForeColor     = [System.Drawing.Color]::White
$btnOK.FlatStyle     = "Flat"
$btnOK.DialogResult  = "OK"

$btnCancel              = New-Object System.Windows.Forms.Button
$btnCancel.Text         = "Annulla"
$btnCancel.Location     = New-Object System.Drawing.Point(356, 200)
$btnCancel.Size         = New-Object System.Drawing.Size(95, 32)
$btnCancel.FlatStyle    = "Flat"
$btnCancel.DialogResult = "Cancel"

$form.Controls.AddRange(@($grpDate, $lblTitle, $txtTitle, $lblPreview, $btnOK, $btnCancel))
$form.AcceptButton = $btnOK
$form.CancelButton = $btnCancel

$result = $form.ShowDialog()

if ($result -ne [System.Windows.Forms.DialogResult]::OK) { exit }

# --- Validazione ---
$title = $txtTitle.Text.Trim()
if ($title -eq '') {
    [System.Windows.Forms.MessageBox]::Show(
        "Inserisci un titolo per il post.", "Titolo mancante",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Warning)
    exit
}

$date    = if ($rbToday.Checked) { Get-Date } else { $dtPicker.Value }
$dateStr = $date.ToString("yyyy-MM-dd")
$year    = $date.ToString("yyyy")
$slug    = ConvertTo-Slug $title
$fname   = "$dateStr-$slug.md"
$fpath   = Join-Path $postsDir $fname

if (Test-Path $fpath) {
    $over = [System.Windows.Forms.MessageBox]::Show(
        "Il file '$fname' esiste gia'. Sovrascrivere?", "File esistente",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question)
    if ($over -ne [System.Windows.Forms.DialogResult]::Yes) { exit }
}

# --- Scansione Inbox ---
$imgExts   = @('.jpg','.jpeg','.png','.gif','.webp','.svg','.avif')
$audioExts = @('.mp3','.wav','.ogg','.m4a','.flac','.aac')
$videoExts = @('.mp4','.webm','.mov','.avi','.mkv')

$imageLinks = [System.Collections.Generic.List[string]]::new()
$audioLinks = [System.Collections.Generic.List[string]]::new()
$videoLinks = [System.Collections.Generic.List[string]]::new()

if (Test-Path $inboxDir) {
    foreach ($f in (Get-ChildItem $inboxDir -File)) {
        $ext = $f.Extension.ToLower()
        if ($ext -in $imgExts) {
            $dest = Join-Path $imgPostDir $year
            if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest -Force | Out-Null }
            Move-Item $f.FullName (Join-Path $dest $f.Name) -Force
            $imageLinks.Add("/images/post/$year/$($f.Name)")
        }
        elseif ($ext -in $audioExts) {
            if (-not (Test-Path $audioDir)) { New-Item -ItemType Directory -Path $audioDir -Force | Out-Null }
            Move-Item $f.FullName (Join-Path $audioDir $f.Name) -Force
            $audioLinks.Add("/audio/$($f.Name)")
        }
        elseif ($ext -in $videoExts) {
            if (-not (Test-Path $videoDir)) { New-Item -ItemType Directory -Path $videoDir -Force | Out-Null }
            Move-Item $f.FullName (Join-Path $videoDir $f.Name) -Force
            $videoLinks.Add("/video/$($f.Name)")
        }
    }
}

# --- Frontmatter ---
$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine("---")
[void]$sb.AppendLine("title: `"$title`"")
[void]$sb.AppendLine("author: Antonio Vigilante")
[void]$sb.AppendLine("pubDatetime: $dateStr")
[void]$sb.AppendLine("tags:")
[void]$sb.AppendLine("  - ")
[void]$sb.AppendLine("description: >")
[void]$sb.AppendLine("   ")
[void]$sb.AppendLine("---")
[void]$sb.AppendLine("")

foreach ($img in $imageLinks) {
    [void]$sb.AppendLine("![]($img)")
    [void]$sb.AppendLine("")
}
foreach ($au in $audioLinks) {
    [void]$sb.AppendLine("<audio controls src=`"$au`"></audio>")
    [void]$sb.AppendLine("")
}
foreach ($vid in $videoLinks) {
    [void]$sb.AppendLine("<video controls src=`"$vid`" style=`"max-width:100%`"></video>")
    [void]$sb.AppendLine("")
}

[System.IO.File]::WriteAllText($fpath, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))

# --- Conferma ---
$msg = "Post creato!`n`nFile: $fname`nCartella: src\data\blog\"
if ($imageLinks.Count -gt 0) { $msg += "`n`nImmagini collegate ($($imageLinks.Count)):`n" + ($imageLinks -join "`n") }
if ($audioLinks.Count  -gt 0) { $msg += "`n`nAudio collegati ($($audioLinks.Count)):`n"   + ($audioLinks -join "`n") }
if ($videoLinks.Count  -gt 0) { $msg += "`n`nVideo collegati ($($videoLinks.Count)):`n"   + ($videoLinks -join "`n") }

[System.Windows.Forms.MessageBox]::Show(
    $msg, "Post creato!",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information)

Start-Process $fpath
