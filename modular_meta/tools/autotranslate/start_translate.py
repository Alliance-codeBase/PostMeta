import os
import sys
import subprocess
import shutil

# 1. Определяем пути
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
VENV_DIR = os.path.join(BASE_DIR, "venv")

LT_EXE = os.path.join(VENV_DIR, "Scripts", "libretranslate.exe")
ARGOS_EXE = os.path.join(VENV_DIR, "Scripts", "argostranslate.exe")
MODEL_DIR = os.path.join(BASE_DIR, "translate-en_ru-1_9.argosmodel")
ARGOS_PACKAGES_DIR = os.path.join(BASE_DIR, "argos-translate", "packages")

env = os.environ.copy()
env["LT_HOST"] = "127.0.0.1"
env["LT_PORT"] = "5000"
env["LT_LOAD_ONLY"] = "en,ru"
env["LT_DISABLE_WEB_UI"] = "true"
env["LT_UPDATE_MODELS"] = "false"
env["LT_THREADS"] = "1"
env["XDG_DATA_HOME"] = BASE_DIR

def ensure_models_exist():
    ru_en_dir = os.path.join(ARGOS_PACKAGES_DIR, "ru-en")
    en_ru_dir = os.path.join(ARGOS_PACKAGES_DIR, "en-ru")

    if os.path.exists(ru_en_dir) and os.path.exists(en_ru_dir):
        print("[OK] Models 'ru-en' and 'en-ru' are already in place. Skipping setup.")
        return True

    print("[!] Models not found in the expected location.")

    if os.path.exists(MODEL_DIR):
        print(f"[*] Found existing model folder: {MODEL_DIR}")
        print("[*] Preparing models for argos-translate...")
        os.makedirs(ARGOS_PACKAGES_DIR, exist_ok=True)

        try:
            # Проверяем, есть ли внутри нужные подпапки
            src_ru_en = os.path.join(MODEL_DIR, "ru-en")
            src_en_ru = os.path.join(MODEL_DIR, "en-ru")

            if os.path.exists(src_ru_en) and os.path.exists(src_en_ru):
                # Копируем их в нужную структуру (это надежнее, чем symlink на Windows)
                shutil.copytree(src_ru_en, ru_en_dir, dirs_exist_ok=True)
                shutil.copytree(src_en_ru, en_ru_dir, dirs_exist_ok=True)
                print("[OK] Models successfully prepared from existing folder.")
                return True
            else:
                print(f"[WARN] The folder '{MODEL_DIR}' does not contain 'ru-en' and 'en-ru' subfolders.")
                print("       Please ensure the models are extracted correctly.")
        except Exception as e:
            print(f"[ERROR] Failed to prepare models: {e}")

    # 3. Если папки нет или она пустая, пытаемся скачать
    print("[!] Attempting to download models automatically...")
    if not os.path.exists(ARGOS_EXE):
        print(f"[ERROR] argostranslate.exe not found at: {ARGOS_EXE}")
        print("Please ensure the 'venv' folder is in the same directory as this script,")
        print("or update the VENV_DIR variable at the top of this script.")
        return False

    try:
        os.makedirs(ARGOS_PACKAGES_DIR, exist_ok=True)
        print("   > Updating package index...")
        subprocess.run([ARGOS_EXE, "update"], env=env, check=True, capture_output=True, text=True)

        print("   > Downloading ru-en model...")
        subprocess.run([ARGOS_EXE, "install", "--from-code", "ru_en"], env=env, check=True, text=True)

        print("   > Downloading en-ru model...")
        subprocess.run([ARGOS_EXE, "install", "--from-code", "en_ru"], env=env, check=True, text=True)

        print("[OK] Models downloaded and installed successfully!")
        return True

    except subprocess.CalledProcessError as e:
        print(f"[ERROR] Failed to download models. Exit code: {e.returncode}")
        if e.stderr:
            print(f"Details: {e.stderr}")
        print("Please check your internet connection.")
        return False
    except Exception as e:
        print(f"[ERROR] An unexpected error occurred: {e}")
        return False

if not ensure_models_exist():
    print("\nAborting startup due to missing models or executable.")
    input("Press Enter to exit...")
    sys.exit(1)

print(f"\nStarting LibreTranslate on http://{env['LT_HOST']}:{env['LT_PORT']}")
print("Press Ctrl+C to stop.")

try:
    if os.path.exists(LT_EXE):
        subprocess.run([LT_EXE], env=env, check=True)
    else:
        print(f"[ERROR] libretranslate.exe not found at: {LT_EXE}")
        print("Please ensure the 'venv' folder is in the same directory as this script.")
        input("Press Enter to exit...")
except KeyboardInterrupt:
    print("\nServer stopped by user.")
except Exception as e:
    print(f"[ERROR] Error starting server: {e}")
    input("Press Enter to exit...")
