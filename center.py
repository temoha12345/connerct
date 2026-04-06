import requests
import base64
import os

# --- Настройки ---
TOPIC = "cachyos_connect"
NTFY_URL = f"https://ntfy.sh/{TOPIC}/json?poll=1&limit=1"

def get_latest_ip():
    try:
        # Получаем последнее сообщение из ntfy
        response = requests.get(NTFY_URL, timeout=5)
        data = response.json()
        
        if not data:
            return None
        
        # Берем текст сообщения (наш Base64)
        encoded_data = data[0]['message']
        
        # Декодируем из Base64
        decoded_ip = base64.b64decode(encoded_data).decode('utf-8')
        return decoded_ip
    except Exception as e:
        print(f"Ошибка получения данных: {e}")
        return None

def main_menu():
    while True:
        os.system('clear')
        print(f"--- CACHYOS CONNECT CENTER ---")
        print(f"Топик: {TOPIC}")
        print("-" * 30)
        
        ip = get_latest_ip()
        
        if ip:
            print(f"[*] Последний IP устройства: {ip}")
        else:
            print("[!] Устройства не в сети или данных нет.")
            
        print("-" * 30)
        print("[1] Подключиться к Vivo (SSH)")
        print("[2] Проверить статус Windows")
        print("[0] Выход")
        
        choice = input("\nВыбери пункт: ")
        
        if choice == "1":
            if ip:
                print(f"\n[+] Подключаюсь к {ip}...")
                # Предполагаем порт 8022 и стандартного пользователя Termux
                os.system(f"ssh {ip} -p 8022")
            else:
                print("[!] Сначала получи IP от устройства!")
                input("Нажми Enter...")
        
        elif choice == "2":
            print("\n[*] Запрос статуса Windows через ntfy...")
            # Тут можно добавить логику для Windows, когда допишем install.ps1
            input("Нажми Enter...")
            
        elif choice == "0":
            break

if __name__ == "__main__":
    main_menu()
