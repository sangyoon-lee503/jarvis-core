#!/bin/bash

# .jarvis/bin/jarvis.sh
# JARVIS-Core 오케스트레이션 메인 실행 파일

# 설정 경로
CONFIG_DIR="$(dirname "$0")/../config"
PROMPTS_DIR="$(dirname "$0")/../prompts"
MODELS_FILE="$CONFIG_DIR/models.json"

# JSON에서 모델 정보 로드 (이식성을 위해 grep/sed 사용, jq 권장)
PLANNER_MODEL=$(grep -o '"planner":[^}]*' "$MODELS_FILE" | grep -o '"model": *"[^"]*"' | cut -d'"' -f4)
DEV_MODEL=$(grep -o '"developer":[^}]*' "$MODELS_FILE" | grep -o '"model": *"[^"]*"' | cut -d'"' -f4)
QA_MODEL=$(grep -o '"qa":[^}]*' "$MODELS_FILE" | grep -o '"model": *"[^"]*"' | cut -d'"' -f4)

# 기본값 설정
PLANNER_MODEL=${PLANNER_MODEL:-"gemini-2.0-flash-thinking-exp-1219"}
DEV_MODEL=${DEV_MODEL:-"claude-3-5-sonnet-v2"}
QA_MODEL=${QA_MODEL:-"moonshot-v1-8k"}

show_logo() {
  echo "       _    _    ____  __     __ ___  ____  "
  echo "      | |  / \  |  _ \ \ \   / /|_ _|| ___| "
  echo "   _  | | / _ \ | |_) | \ \ / /  | | |___ \ "
  echo "  | |_| |/ ___ \|  _ <   \ V /   | |  ___) |"
  echo "   \___//_/   \_\_| \_\   \_/   |___||____/ "
  echo "                                            "
  echo "          JARVIS System Online              "
  echo "--------------------------------------------"
}

# Logic 에이전트(개발자) 호출 함수
ask_jarvis_logic() {
  local prompt="$1"
  echo "[JARVIS-Core] JARVIS-Logic ($DEV_MODEL)에게 위임 중..."
  opencode --model "$DEV_MODEL" --input "$prompt"
}

# Sentry 에이전트(QA) 호출 함수
ask_jarvis_sentry() {
  local prompt="$1"
  echo "[JARVIS-Core] JARVIS-Sentry ($QA_MODEL)에게 QA 요청 중..."
  opencode --model "$QA_MODEL" --input "$prompt"
}

# 자가 치유(Self-Healing) 함수
self_healing() {
  echo "[JARVIS-Sentry] ⚠️ 치명적인 오류 감지됨."
  echo "[JARVIS-Sentry] 자가 치유 프로토콜을 시작합니다..."
  
  # 커밋되지 않은 변경사항 확인 또는 롤백
  if [[ -n $(git status -s) ]]; then
      echo "[JARVIS-Sentry] 커밋되지 않은 변경사항을 폐기합니다..."
      git reset --hard
  else
      echo "[JARVIS-Sentry] 마지막 커밋을 되돌립니다..."
      git reset --hard HEAD~1
  fi
  
  echo "[JARVIS-Sentry] 시스템이 안정 상태로 복구되었습니다."
}

# 초기화 및 정보 출력
init() {
  show_logo
  echo "[JARVIS-Core] 기획자 모델: $PLANNER_MODEL"
  echo "[JARVIS-Core] 개발자 모델: $DEV_MODEL"
  echo "[JARVIS-Core] QA 모델:    $QA_MODEL"
  echo ""
}

# 명령어 처리
case "$1" in
  "logic")
    ask_jarvis_logic "$2"
    ;;
  "sentry")
    ask_jarvis_sentry "$2"
    ;;
  "heal")
    self_healing
    ;;
  *)
    init
    echo "사용법: $0 {logic|sentry|heal} [프롬프트]"
    ;;
esac
