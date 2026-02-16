#!/bin/bash

# .jarvis/bin/jarvis.sh
# JARVIS-Core 오케스트레이션 메인 실행 파일 (무료 모델 최적화 버전)

# 설정 경로
CONFIG_DIR="$(dirname "$0")/../config"
PROMPTS_DIR="$(dirname "$0")/../prompts"
MODELS_FILE="$CONFIG_DIR/models.json"

# JSON에서 모델 정보 로드 (구조 변경에 따른 매핑 수정)
PLANNER_MODEL=$(grep -o '"planner":[^}]*' "$MODELS_FILE" | grep -A 2 '"planner"' | grep -o '"model": *"[^"]*"' | cut -d'"' -f4)
DEV_SENIOR_MODEL=$(grep -o '"developer_senior":[^}]*' "$MODELS_FILE" | grep -A 2 '"developer_senior"' | grep -o '"model": *"[^"]*"' | cut -d'"' -f4)
DEV_JUNIOR_MODEL=$(grep -o '"developer_junior":[^}]*' "$MODELS_FILE" | grep -A 2 '"developer_junior"' | grep -o '"model": *"[^"]*"' | cut -d'"' -f4)
QA_MODEL=$(grep -o '"qa_engineer":[^}]*' "$MODELS_FILE" | grep -A 2 '"qa_engineer"' | grep -o '"model": *"[^"]*"' | cut -d'"' -f4)

# 기본값 설정
PLANNER_MODEL=${PLANNER_MODEL:-"Gemini-3-Flash"}
DEV_SENIOR_MODEL=${DEV_SENIOR_MODEL:-"Big Pickle"}
DEV_JUNIOR_MODEL=${DEV_JUNIOR_MODEL:-"MiniMax M2.5"}
QA_MODEL=${QA_MODEL:-"Kimi K2.5"}

show_logo() {
  echo "       _    _    ____  __     __ ___  ____  "
  echo "      | |  / \  |  _ \ \ \   / /|_ _|| ___| "
  echo "   _  | | / _ \ | |_) | \ \ / /  | | |___ \ "
  echo "  | |_| |/ ___ \|  _ <   \ V /   | |  ___) |"
  echo "   \___//_/   \_\_| \_\   \_/   |___||____/ "
  echo "                                            "
  echo "          JARVIS System Online (Free)       "
  echo "--------------------------------------------"
}

ask_jarvis_logic() {
  local prompt="$1"
  echo "[JARVIS-Core] JARVIS-Logic (Senior: $DEV_SENIOR_MODEL)에게 위임 중..."
  opencode --model "$DEV_SENIOR_MODEL" --input "$prompt"
}

ask_jarvis_ui() {
  local prompt="$1"
  echo "[JARVIS-Core] JARVIS-UI (Junior: $DEV_JUNIOR_MODEL)에게 위임 중..."
  opencode --model "$DEV_JUNIOR_MODEL" --input "$prompt"
}

ask_jarvis_sentry() {
  local prompt="$1"
  echo "[JARVIS-Core] JARVIS-Sentry (QA: $QA_MODEL)에게 QA 요청 중..."
  opencode --model "$QA_MODEL" --input "$prompt"
}

self_healing() {
  echo "[JARVIS-Sentry] ⚠️ 치명적인 오류 감지됨."
  echo "[JARVIS-Sentry] 자가 치유 프로토콜을 시작합니다..."
  if [[ -n $(git status -s) ]]; then
      echo "[JARVIS-Sentry] 커밋되지 않은 변경사항을 폐기합니다..."
      git reset --hard
  else
      echo "[JARVIS-Sentry] 마지막 커밋을 되돌립니다..."
      git reset --hard HEAD~1
  fi
  echo "[JARVIS-Sentry] 시스템이 안정 상태로 복구되었습니다."
}

init() {
  show_logo
  echo "[JARVIS-Core] 기획자 모델: $PLANNER_MODEL"
  echo "[JARVIS-Core] 선임 개발:   $DEV_SENIOR_MODEL"
  echo "[JARVIS-Core] 후임 UI:     $DEV_JUNIOR_MODEL"
  echo "[JARVIS-Core] 검증 에이전트: $QA_MODEL"
  echo ""
}

case "$1" in
  "logic")
    ask_jarvis_logic "$2"
    ;;
  "ui")
    ask_jarvis_ui "$2"
    ;;
  "sentry")
    ask_jarvis_sentry "$2"
    ;;
  "heal")
    self_healing
    ;;
  *)
    init
    echo "사용법: $0 {logic|ui|sentry|heal} [프롬프트]"
    ;;
esac
