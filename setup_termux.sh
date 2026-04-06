#!/data/data/com.termux/files/usr/bin/bash

# 1. Проверка только нужных пакетов
for pkg in openssh curl; do
    if ! command -v $pkg &> /dev/null; then
        pkg install $pkg -y -q
    fi
done

# 2. Тихий запуск SSH
pgrep -x "sshd" > /dev/null || sshd

# 3. Поиск IP (пробуем несколько методов, чтобы не было Offline)
ip=$(getprop dhcp.wlan0.ipaddress)
[ -z "$ip" ] && ip=$(ifconfig wlan0 2>/dev/null | grep 'inet ' | awk '{print $2}')
[ -z "$ip" ] && ip=$(ifconfig 2>/dev/null | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | head -n 1)

# 4. Если IP найден — шифруем только его
if [ ! -z "$ip" ] && [ "$ip" != "Offline" ]; then
    encoded=$(echo -n "$ip" | base64)
    # Отправка в ntfy
    curl -s -d "$encoded" ntfy.sh/cachyos_connect > /dev/null
    echo "[+] IP отправлен: $encoded"
else
    echo "[!] Ошибка: IP не найден."
fi
