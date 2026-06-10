import os
import sys

def count_files(folder):
    total = 0
    for _, _, files in os.walk(folder):
        total += len(files)
    return total

def process_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            lines = f.readlines()
    except (UnicodeDecodeError, PermissionError):
        return 0

    filtered = [line for line in lines if not line.startswith(':MODIFY-VERSION')]
    removed = len(lines) - len(filtered)

    if removed > 0:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.writelines(filtered)

    return removed

def process_folder(folder):
    print("Comptage des fichiers...")
    total_files_count = count_files(folder)
    print(f"{total_files_count} fichiers trouvés.\n")

    processed = 0
    modified_files = 0
    total_lines_removed = 0
    bar_width = 40

    for root, _, files in os.walk(folder):
        for filename in files:
            filepath = os.path.join(root, filename)
            removed = process_file(filepath)
            processed += 1

            if removed > 0:
                modified_files += 1
                total_lines_removed += removed

            pct = processed / total_files_count
            filled = int(bar_width * pct)
            bar = '█' * filled + '░' * (bar_width - filled)
            short_path = filepath if len(filepath) <= 50 else '...' + filepath[-47:]
            print(f"\r[{bar}] {processed}/{total_files_count}  {short_path:<50}", end='', flush=True)

    print(f"\n\nTerminé : {total_lines_removed} ligne(s) supprimée(s) dans {modified_files} fichier(s) modifié(s).")

if __name__ == '__main__':
    folder = sys.argv[1] if len(sys.argv) > 1 else '.'
    if not os.path.isdir(folder):
        print(f"Erreur : '{folder}' n'est pas un dossier valide.")
        sys.exit(1)
    print(f"Traitement de : {os.path.abspath(folder)}\n")
    process_folder(folder)