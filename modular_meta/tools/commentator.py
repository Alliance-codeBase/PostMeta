import os
import re
import sys
from git import Repo

EXCLUDED_FOLDERS = ["modular_meta"]
MODPACK_NAME = ""
if len(sys.argv) > 1:
    arg_val = sys.argv[1].strip()
    if arg_val.lower() != "none" and arg_val != "":
        MODPACK_NAME = arg_val

def get_begin_string():
    if MODPACK_NAME:
        return f"//MASSMETA EDIT BEGIN ({MODPACK_NAME})"
    return "//MASSMETA EDIT BEGIN"


def is_excluded(file_path):
    normalized_path = file_path.replace(os.sep, "/")
    parts = normalized_path.split("/")
    for folder in EXCLUDED_FOLDERS:
        if folder in parts:
            return True
    return False


def process_diff():
    try:
        script_dir = os.path.dirname(os.path.abspath(__file__))
        repo = Repo(script_dir, search_parent_directories=True)
        repo_root = repo.working_tree_dir
        print(f"Git Repo File path: {repo_root}")
    except Exception as e:
        print(f"Unable to find Git Repo File path: {e}")
        return

    print("Analyzes uncommitted changes...")

    changed_files = set()
    for item in repo.index.diff(None):
        if item.b_path and item.b_path.endswith(".dm"):
            changed_files.add(item.b_path)
    for item in repo.index.diff("HEAD"):
        if item.b_path and item.b_path.endswith(".dm"):
            changed_files.add(item.b_path)
    for untracked_file in repo.untracked_files:
        if untracked_file.endswith(".dm"):
            changed_files.add(untracked_file)

    filtered_files = [f for f in changed_files if not is_excluded(f)]

    if not filtered_files:
        print("No committed changes.")
        return

    for target_path in filtered_files:
        file_path = os.path.join(repo_root, target_path)
        if not os.path.exists(file_path):
            continue

        print(f"Processed: {target_path}")

        try:
            diff_text = repo.git.diff(file_path)
            if not diff_text:
                diff_text = repo.git.diff("--cached", file_path)
        except Exception:
            continue

        if not diff_text:
            continue

        apply_comments_to_file(file_path, diff_text)


def apply_comments_to_file(file_path, diff_text):
    with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
        file_content = f.read()

    file_content = re.sub(r"\n\s*//MASSMETA EDIT BEGIN.*?\n", "\n", file_content)
    file_content = re.sub(r"\n\s*//MASSMETA EDIT END.*?\n", "\n", file_content)

    chunks = diff_text.split("@@")
    if len(chunks) < 3:
        return

    hunk_bodies = chunks[2::2]
    begin = get_begin_string()
    end = "//MASSMETA EDIT END"

    blocks_to_wrap = []
    for body in hunk_bodies:
        added_lines = []
        for line in body.splitlines():
            if "MASSMETA EDIT" in line:
                continue
            if line.startswith("+"):
                added_lines.append(line[1:])
        if added_lines:
            blocks_to_wrap.append(added_lines)

    for block in blocks_to_wrap:
        block_text = "\n".join(block)

        if block_text in file_content:
            first_line = block[0]
            indent = first_line[:len(first_line) - len(first_line.lstrip())]
            wrapped_text = f"{indent}{begin}\n{block_text}\n{indent}{end}"

            file_content = file_content.replace(block_text, wrapped_text, 1)

    with open(file_path, "w", encoding="utf-8") as f:
        f.write(file_content)
    print(f"  > File Saved.")


if __name__ == "__main__":
    print(f"Set Modpack to [{MODPACK_NAME or 'no, im fine'}]")
    process_diff()
