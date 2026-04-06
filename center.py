import os, base64, requests

def decode_log(data):
    try:
        # Пытаемся расшифровать данные из ntfy
        return base64.b64decode(data).decode('utf-8')
    except:
        return data

def main():
    while True:
        os.system('cls' if os.name == 'nt' else 'clear')
        print("="*50 + "\n   🛰️  CACHYOS CONNECT CENTER v2.0\n" + "="*50)
        print("1. [🔗] Подключиться по SSH (Windows/Termux)")
        print("2. [📥] Прочитать логи (Расшифровка Функции 6)")
        print("0. [❌] Выход")
        
        choice = input("\nВыбор: ")
        if choice == '1':
            ip = input("IP цели: "); user = input("User: ")
            os.system(f"ssh {user}@{ip}")
        elif choice == '2':
            print("\n--- ПОСЛЕДНИЕ ДАННЫЕ ИЗ ОБЛАКА ---")
            r = requests.get("https://ntfy.sh/cachyos_connect/raw")
            print(decode_log(r.text))
            input("\nНажми Enter для возврата...")
        elif choice == '0': break

if __name__ == "__main__": main()
