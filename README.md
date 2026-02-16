# JARVIS-Core (AI 오케스트레이션 프레임워크)

JARVIS-Core는 모든 프로젝트(Grounds, TeamOn 등)에 공통적으로 적용될 수 있는 **모듈화된 AI 오케스트레이션 시스템**입니다. 
프로젝트 루트를 오염시키지 않고 `.jarvis/` 폴더 내에 로직을 격리하여 관리합니다.

## 🚀 다른 프로젝트에서 설치하기 (Quick Install)

새로운 프로젝트 디렉토리에서 아래 명령어를 실행하면 JARVIS-Core가 자동으로 설치됩니다.

```bash
# GitHub에 소스코드를 올린 후 [YOUR_USERNAME] 부분을 실제 계정명으로 변경하세요.
curl -fsSL https://raw.githubusercontent.com/sangyoon-lee503/jarvis-core/main/install_jarvis.sh | bash
```

## 📂 주요 구조

- `.jarvis/`: 핵심 로직 및 설정 격리
- `AGENTS.md`: 기획(Gemini), 개발(Claude), QA(Kimi) 에이전트 페르소나 정의
- `setup-orch.sh`: 환경 변수 및 도구(opencode) 사전 점검
- `.vscode/tasks.json`: 폴더를 열 때 JARVIS를 자동으로 깨우는 설정

## 🛠️ 주요 명령어

설치 후 해당 프로젝트에서 다음 명령어를 사용할 수 있습니다.

```bash
# 1. 환경 및 도구 점검
./setup-orch.sh

# 2. 개발 에이전트(Logic)에게 작업 지시
./.jarvis/bin/jarvis.sh logic "새로운 기능 구현해줘"

# 3. QA 및 자가 치유 (실패 시 롤백)
./.jarvis/bin/jarvis.sh heal
```

## ⚙️ 설정 변경
- `.jarvis/config/models.json`: 각 역할별로 사용할 AI 모델 정의
- `.jarvis/prompts/system_prompt.md`: 유니버설 오케스트레이터의 행동 지침
