#!/bin/bash

# JARVIS Engine v1.0 (Free Tier)
BASE_DIR="$(dirname "$0")/.."
CONFIG_FILE="$BASE_DIR/config/models.json"

# 모델 ID 로드 (jq 없이 grep 파싱)
DEV_SENIOR=$(grep -o '"developer_senior": *"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
DEV_JUNIOR=$(grep -o '"developer_junior": *"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
QA_ENGINEER=$(grep -o '"qa_engineer": *"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)

echo "-----------------------------------------"
echo "   J.A.R.V.I.S  -  System Online"
echo "   [Models Loaded]: $DEV_SENIOR, $DEV_JUNIOR, $QA_ENGINEER"
echo "-----------------------------------------"

execute_build() {
    local max_retries=3
    local attempt=1
    
    # 안전장치: 백업
    git stash push -m "JARVIS-Backup-$(date +%s)"

    while [ $attempt -le $max_retries ]; do
        echo "🚀 [Cycle $attempt] Building & Testing..."
        
        # (A) 개발 단계
        echo ">> [JARVIS-Logic] Coding with $DEV_SENIOR..."
        opencode run "task.json의 'Logic' 단계를 수행해. (Strict Code Only)" --model="$DEV_SENIOR"
        
        echo ">> [JARVIS-UI] Styling with $DEV_JUNIOR..."
        opencode run "task.json의 'UI' 단계를 수행해. (Frontend Focus)" --model="$DEV_JUNIOR"

        # (B) QA 단계
        echo ">> [JARVIS-Sentry] Verifying with $QA_ENGINEER..."
        RESULT=$(opencode run "코드를 리뷰하고 문제 없으면 PASS, 아니면 FAIL을 출력해." --model="$QA_ENGINEER")
        
        if [[ "$RESULT" == *"PASS"* ]]; then
            echo "✅ QA Passed. Deploying sequence ready."
            return 0
        else
            echo "❌ QA Failed. Rolling back..."
            git checkout . 
            ((attempt++))
        fi
    done
    
    echo "🚨 System Failure: Manual intervention required."
    return 1
}

if [ "$1" == "start-build" ]; then
    execute_build
else
    echo "Usage: $0 start-build"
fi
