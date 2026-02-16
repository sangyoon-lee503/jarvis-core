#!/bin/bash

# install_jarvis.sh
# JARVIS-Core를 현재 폴더 또는 대상 폴더에 설치합니다.
# 이 스크립트는 로컬 실행 및 원격 curl 실행을 모두 지원하도록 설계되었습니다.

# 1. 설정
GITHUB_REPO="https://raw.githubusercontent.com/sangyoon-lee503/jarvis-core/main"
TARGET_DIR="${1:-.}"
IS_REMOTE=false

# 현재 폴더에 .jarvis가 없으면 원격 모드로 간주
if [ ! -d ".jarvis" ]; then
    IS_REMOTE=true
    echo "[JARVIS-Install] 원격 저장소에서 소스를 가져옵니다..."
fi

mkdir -p "$TARGET_DIR/.jarvis/bin" "$TARGET_DIR/.jarvis/config" "$TARGET_DIR/.jarvis/prompts" "$TARGET_DIR/.vscode"

copy_file() {
    local src_path=$1
    local dest_path=$2
    
    if [ "$IS_REMOTE" = true ]; then
        curl -fsSL "$GITHUB_REPO/$src_path" -o "$TARGET_DIR/$dest_path"
    else
        cp "$src_path" "$TARGET_DIR/$dest_path"
    fi
}

echo "[JARVIS-Install] JARVIS-Core 설치 시작 (대상: $TARGET_DIR)..."

# 파일 목록 복사
FILES=(
    ".jarvis/bin/jarvis.sh"
    ".jarvis/config/config.json"
    ".jarvis/config/models.json"
    ".jarvis/prompts/system_prompt.md"
    "setup-orch.sh"
    "AGENTS.md"
    ".vscode/tasks.json"
)

for file in "${FILES[@]}"; do
    echo "  > $file 복사 중..."
    copy_file "$file" "$file"
done

# 실행 권한 설정
chmod +x "$TARGET_DIR/.jarvis/bin/jarvis.sh"
chmod +x "$TARGET_DIR/setup-orch.sh"

echo "[JARVIS-Install] 설치가 완료되었습니다."
echo "[JARVIS-Install] GitHub에 올린 후 [YOUR_USERNAME]을 실제 계정명으로 변경하는 것을 잊지 마세요."
echo "[JARVIS-Install] 완료 후 './setup-orch.sh'를 실행하여 환경을 점검하세요."
