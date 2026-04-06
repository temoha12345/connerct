#!/data/data/com.termux/files/usr/bin/bash

# 1. Обновление и установка нужного софта
pkg update && pkg upgrade -y
pkg install openssh curl -y

# 2. Настройка SSH (в Termux порт 8022)
sshd
echo "[!] SSH запущен. Задай пароль командой 'passwd', если еще не сделал."

# 3. Сбор данных (Аналог Функции 6 для Android)
# Собираем инфу о модели, батарее и IP
model=$(getprop ro.product.model)
battery=$(termux-battery-status | grep percentage | awk '{print $2}')
ip=$(ifconfig wlan0 | grep 'inet ' | awk '{print $2}')
sys_info="Device: $model | Battery: $battery | IP: $ip"

# 4. Шифрование в Base64
encoded=$(echo -e "$sys_info" | base64)

# 5. Отправка в твой ntfy
curl -d "$encoded" ntfy.sh/cachyos_connect

echo "[+] Готово! Телефон в сети."
