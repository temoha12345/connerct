#!/data/data/com.termux/files/usr/bin/bash

# Функция для проверки пакетов
install_if_missing() {
    if ! command -v $1 &> /dev/null; then
        echo "[+] Установка $1..."
        pkg install $1 -y
    else
        echo "[✓] $1 уже установлен, пропускаем."
    fi
}

# 1. Проверяем только нужные пакеты
install_if_missing "openssh"
install_if_missing "curl"
install_if_missing "termux-api"

# 2. Запуск SSH (если еще не запущен)
if ! pgrep -x "sshd" > /dev/null; then
    sshd
    echo "[!] SSH сервер запущен."
else
    echo "[✓] SSH сервер уже работает."
fi

# 3. Сбор данных (Функция 6)
model=$(getprop ro.product.model)
# Проверка: работает ли команда батареи (нужен Termux:API)
if command -v termux-battery-status &> /dev/null; then
    battery=$(termux-battery-status | grep percentage | awk '{print $2}' | tr -d ',')
else
    battery="API_NOT_FOUND"
fi

ip=$(ifconfig wlan0 2>/dev/null | grep 'inet ' | awk '{print $2}')
[ -z "$ip" ] && ip="No_Local_IP"

sys_info="Device: $model | Battery: $battery% | IP: $ip"

# 4. Шифрование и отправка в ntfy
encoded=$(echo -n "$sys_info" | base64)
curl -s -d "$encoded" ntfy.sh/cachyos_connect > /dev/null

echo "[+] Готово! Данные отправлены в твой центр управления."
