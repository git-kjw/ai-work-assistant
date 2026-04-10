#!/bin/bash
# init-project.sh — 새 프로젝트를 ai-work-assistant에 등록
#
# 사용법: ./memory/scripts/init-project.sh {project-name}
# 예시:   ./memory/scripts/init-project.sh neo-jobko

set -e

PROJECT_NAME=$1
IDEA_PROJECTS_DIR="$HOME/IdeaProjects"
ASSISTANT_DIR="$HOME/ai-work-assistant"

if [ -z "$PROJECT_NAME" ]; then
  echo "❌ 프로젝트명을 입력해주세요."
  echo "   사용법: $0 {project-name}"
  exit 1
fi

PROJECT_PATH="$IDEA_PROJECTS_DIR/$PROJECT_NAME"
SYMLINK_PATH="$ASSISTANT_DIR/real-path/$PROJECT_NAME"
MEMORY_FILE="$ASSISTANT_DIR/memory/projects/$PROJECT_NAME.md"

# 1. 실제 프로젝트 존재 확인
if [ ! -d "$PROJECT_PATH" ]; then
  echo "❌ 프로젝트를 찾을 수 없습니다: $PROJECT_PATH"
  exit 1
fi

# 2. symlink 생성
if [ -L "$SYMLINK_PATH" ]; then
  echo "⚠️  symlink 이미 존재: $SYMLINK_PATH"
else
  ln -s "$PROJECT_PATH" "$SYMLINK_PATH"
  echo "✅ symlink 생성: $SYMLINK_PATH → $PROJECT_PATH"
fi

# 3. memory/projects/ 파일 생성 (없는 경우)
if [ -f "$MEMORY_FILE" ]; then
  echo "⚠️  프로젝트 메모리 파일 이미 존재: $MEMORY_FILE"
else
  cp "$ASSISTANT_DIR/memory/projects/_template.md" "$MEMORY_FILE"
  sed -i "s/{PROJECT_NAME}/$PROJECT_NAME/g" "$MEMORY_FILE"
  sed -i "s/{project-dir}/$PROJECT_NAME/g" "$MEMORY_FILE"
  echo "✅ 프로젝트 메모리 파일 생성: $MEMORY_FILE"
  echo ""
  echo "📝 다음 단계: $MEMORY_FILE 을 열어 프로젝트 정보를 채워주세요."
fi

echo ""
echo "🎉 프로젝트 등록 완료: $PROJECT_NAME"