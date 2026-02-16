#!/bin/bash

# setup-orch.sh
# 사전 점검 및 오케스트레이션 설정 스크립트

echo "[JARVIS-Setup] 사전 점검(Pre-flight Checks)을 시작합니다..."

# 1. OS 감지
OS="$(uname -s)"
case "$OS" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGW;;
    *)          MACHINE="UNKNOWN:$OS"
esac
echo "[JARVIS-Setup] 감지된 OS: $MACHINE"

# 2. opencode CLI 확인
if ! command -v opencode &> /dev/null; then
    echo "[JARVIS-Setup] ❌ opencode CLI를 찾을 수 없습니다."
    echo "[JARVIS-Setup] 계속하려면 설치가 필요합니다."
    exit 1
else
    echo "[JARVIS-Setup] ✅ opencode CLI 확인됨."
fi

# 3. 환경 변수 확인
MISSING_VARS=0

if [ -z "$SUPABASE_URL" ]; then
    echo "[JARVIS-Setup] ⚠️  SUPABASE_URL이 설정되지 않았습니다."
    MISSING_VARS=1
else
    echo "[JARVIS-Setup] ✅ SUPABASE_URL 감지됨."
fi

if [ -z "$VERCEL_TOKEN" ]; then
    echo "[JARVIS-Setup] ⚠️  VERCEL_TOKEN이 설정되지 않았습니다."
    MISSING_VARS=1
else
    echo "[JARVIS-Setup] ✅ VERCEL_TOKEN 감지됨."
fi

if [ $MISSING_VARS -eq 1 ]; then
    echo "[JARVIS-Setup] 경고: 일부 환경 변수가 누락되었습니다."
    echo "[JARVIS-Setup] JARVIS 기능이 제한될 수 있습니다."
else
    echo "[JARVIS-Setup] ✅ 모든 환경 점검 통과."
fi

echo "[JARVIS-Setup] 설정 완료. 실행 준비가 되었습니다."
exit 0
