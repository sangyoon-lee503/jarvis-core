#!/bin/bash

# install_jarvis.sh
# 다른 프로젝트에 JARVIS-Core를 복제/설치하는 스크립트.

TARGET_DIR="${1:-.}"

if [ ! -d "$TARGET_DIR" ]; then
    echo "대상 디렉토리 $TARGET_DIR 가 존재하지 않습니다."
    exit 1
fi

echo "JARVIS-Core를 $TARGET_DIR 에 설치하는 중..."

# 숨김 폴더 구조 복사
cp -r .jarvis "$TARGET_DIR/"

# 설정 스크립트 복사
cp setup-orch.sh "$TARGET_DIR/"

# 에이전트 가이드라인 복사
cp AGENTS.md "$TARGET_DIR/"

# 스크립트 실행 권한 부여
chmod +x "$TARGET_DIR/.jarvis/bin/jarvis.sh"
chmod +x "$TARGET_DIR/setup-orch.sh"

echo "JARVIS-Core가 $TARGET_DIR 에 성공적으로 설치되었습니다."
echo "'./setup-orch.sh'를 실행하여 초기화하세요."
