#!/data/data/com.termux/files/usr/bin/bash

# --- CONFIG ---
TOPIC="cachyos_connect"

# Функция для тихой установки пакетов
install_pkg() {
    if ! command -v $1 &> /dev/null; then
        echo "[+] Установка $1..."
        pkg install $1 -y -q
    else
        echo "[✓] $1 уже на месте."
    fi
}

echo "--- STARTING CONNECT SYSTEM ---"

# 1. Проверка базы
install_pkg "openssh"
install_pkg "curl"
install_pkg "termux-api"
install_pkg "iproute2"

# 2. Запуск SSH (если спит)
if ! pgrep -x "sshd" > /dev/null; then
    sshd
    echo "[!] SSH сервер поднят (порт 8022)."
else
    echo "[✓] SSH сервер активен."
fi

# 3. Умный сбор данных
model=$(getprop ro.product.model)

# Сбор заряда (с проверкой на ошибку API)
if command -v termux-battery-status &> /dev/null; then
    battery=$(termux-battery-status | grep percentage | awk '{print $2}' | tr -d ',%')
else
    battery="0"
fi

# Универсальный поиск IP (пропускаем 127.0.0.1)
ip=$(ip -4 addr show | grep -v '127.0.0.1' | grep 'inet ' | awk '{print $2}' | cut -d/ -f1 | head -n 1)
[ -z "$ip" ] && ip="Offline"

# 4. Формирование отчета
# Формат: Модель | Заряд | IP
sys_info="Dev: $model | Bat: $battery% | IP: $ip"

# 5. Шифрование и тихая отправка в ntfy
encoded=$(echo -n "$sys_info" | base64)
curl -s -d "$encoded" "ntfy.sh/$TOPIC" > /dev/null

echo "--------------------------------"
echo "[+] СТАТУС: ОТПРАВЛЕНО"
echo "[i] Данные: $sys_info"
echo "[!] Используй этот IP в center.py на CachyOS"
