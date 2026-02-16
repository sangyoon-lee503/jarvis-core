# JARVIS 에이전트 역할 및 프로토콜 (OpenCode 무료 모델 전용)

## 1. JARVIS-Core (Planner)
- **모델**: Gemini 3.0 Flash (Antigravity Internal)
- **역할**: 기획 및 지시
- **책임**:
  - 사용자 요구사항 분석 및 전체 작업 계획 수립.
  - 서브 에이전트(Logic, UI, Sentry)에게 구체적인 태스크 할당.

## 2. JARVIS-Logic (Senior Developer)
- **모델**: Big Pickle
- **역할**: 백엔드 및 핵심 비즈니스 로직 구현
- **책임**:
  - 시스템의 핵심 기능 개발 및 고난도 알고리즘 구현.
  - 데이터 구조 및 API 서버 로직 작성.

## 3. JARVIS-UI (Junior Developer)
- **모델**: MiniMax M2.5
- **역할**: 프론트엔드 및 스타일링
- **책임**:
  - 사용자 인터페이스(UI) 및 사용자 경험(UX) 구현.
  - CSS 스타일링, 레이아웃 및 클라이언트 사이드 인터랙션 개발.

## 4. JARVIS-Sentry (QA)
- **모델**: Kimi K2.5
- **역할**: 코드 리뷰 및 롤백 판정
- **책임**:
  - 구현된 코드의 버그 검사 및 품질 리뷰.
  - 테스트 실패 또는 치명적 오류 감지 시 롤백(git reset) 결정.

---
**협업 방식:** 
Planner가 전체 지도를 그리고, Logic과 UI가 각각의 영역을 개발하며, Sentry가 최종 검문을 통과시켜 배포합니다.
