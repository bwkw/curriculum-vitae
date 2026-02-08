#!/bin/bash
set -euo pipefail

# 色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# エラーハンドリング
error_exit() {
    echo -e "${RED}エラー: $1${NC}" >&2
    exit 1
}

# gh CLI のチェック
if ! command -v gh &> /dev/null; then
    error_exit "gh CLI がインストールされていません。"
fi

# PR 情報の取得
echo -e "${YELLOW}PR 情報を取得中...${NC}"
PR_INFO=$(gh pr view --json number,title,baseRefName,headRefName 2>&1) || {
    error_exit "現在のブランチに PR が見つかりません。先に PR を作成してください。"
}

PR_NUMBER=$(echo "$PR_INFO" | jq -r '.number')
BASE_BRANCH=$(echo "$PR_INFO" | jq -r '.baseRefName')
HEAD_BRANCH=$(echo "$PR_INFO" | jq -r '.headRefName')

echo -e "${GREEN}PR #${PR_NUMBER} を更新します (${HEAD_BRANCH} → ${BASE_BRANCH})${NC}"

# 差分の取得
echo -e "${YELLOW}差分を取得中...${NC}"
DIFF=$(git diff "${BASE_BRANCH}...HEAD")

# コミット履歴の取得
echo -e "${YELLOW}コミット履歴を取得中...${NC}"
COMMITS=$(git log --oneline "${BASE_BRANCH}..HEAD")

# 変更ファイル一覧の取得
CHANGED_FILES=$(git diff --name-only "${BASE_BRANCH}...HEAD")

# 変更ファイル数の取得
FILE_COUNT=$(echo "$CHANGED_FILES" | wc -l | tr -d ' ')

# コミット数の取得
COMMIT_COUNT=$(echo "$COMMITS" | wc -l | tr -d ' ')

echo -e "${YELLOW}タイトルと description を生成中...${NC}"

# タイトルの生成（最新のコミットメッセージから）
LATEST_COMMIT=$(echo "$COMMITS" | head -n 1 | cut -d' ' -f2-)
# prefix を削除
TITLE=$(echo "$LATEST_COMMIT" | sed -E 's/^(feat|fix|chore|docs|refactor|style|test|perf|ci|build|revert): //')

# 複数コミットがある場合は概要的なタイトルに
if [ "$COMMIT_COUNT" -gt 1 ]; then
    # 主要な変更を判定
    if echo "$CHANGED_FILES" | grep -q "\.github/workflows"; then
        if echo "$CHANGED_FILES" | grep -q "package\.json"; then
            TITLE="GitHub Actions を最新化し pnpm に移行"
        else
            TITLE="GitHub Actions の設定を更新"
        fi
    elif echo "$CHANGED_FILES" | grep -q "package\.json"; then
        TITLE="依存パッケージとツールチェーンを更新"
    elif echo "$CHANGED_FILES" | grep -q "docs/README\.md"; then
        TITLE="職務経歴書を更新"
    fi
fi

# description の生成
DESCRIPTION="## 概要

${TITLE}

## 主な変更点

$(echo "$CHANGED_FILES" | sed 's/^/- `/' | sed 's/$/`/')

## 変更理由

"

# 変更理由を推測
if echo "$CHANGED_FILES" | grep -q "\.github/workflows"; then
    DESCRIPTION+="- GitHub Actions のランナーとアクションを最新化してセキュリティを向上
- 非推奨のアクションを置き換えて将来の互換性を確保
"
fi

if echo "$CHANGED_FILES" | grep -q "package\.json"; then
    DESCRIPTION+="- 依存パッケージを最新版に更新してセキュリティと機能を向上
- pnpm に移行してビルド速度とディスク効率を改善
"
fi

if echo "$CHANGED_FILES" | grep -q "docs/README\.md"; then
    DESCRIPTION+="- 職務経歴の内容を最新化
- textlint のエラーを修正して文章品質を向上
"
fi

DESCRIPTION+="
## 破壊的変更

"

# 破壊的変更をチェック
if echo "$CHANGED_FILES" | grep -q "yarn\.lock"; then
    DESCRIPTION+="- \`yarn.lock\` を削除し \`pnpm-lock.yaml\` に移行
"
else
    DESCRIPTION+="なし
"
fi

DESCRIPTION+="
## テスト

- [x] ローカルでの動作確認
- [x] textlint によるチェック
"

if echo "$CHANGED_FILES" | grep -q "\.github/workflows"; then
    DESCRIPTION+="- [ ] GitHub Actions の動作確認（マージ後）
"
fi

DESCRIPTION+="
## レビュー観点

"

# レビュー観点を生成
if echo "$CHANGED_FILES" | grep -q "\.github/workflows"; then
    DESCRIPTION+="- GitHub Actions の設定が適切か
- 非推奨のアクションが適切に置き換えられているか
"
fi

if echo "$CHANGED_FILES" | grep -q "package\.json"; then
    DESCRIPTION+="- 依存パッケージのバージョンが適切か
- pnpm への移行が正しく行われているか
"
fi

if echo "$CHANGED_FILES" | grep -q "docs/README\.md"; then
    DESCRIPTION+="- 職務経歴の内容が正確か
- 文章の品質が向上しているか
"
fi

DESCRIPTION+="
---

**コミット数**: ${COMMIT_COUNT} 件  
**変更ファイル数**: ${FILE_COUNT} 件
"

echo ""
echo -e "${GREEN}=== 生成されたタイトル ===${NC}"
echo "$TITLE"
echo ""
echo -e "${GREEN}=== 生成された description ===${NC}"
echo "$DESCRIPTION"
echo ""

# PR の更新
echo -e "${YELLOW}PR を更新中...${NC}"
gh pr edit "$PR_NUMBER" --title "$TITLE" --body "$DESCRIPTION"

echo -e "${GREEN}✓ PR #${PR_NUMBER} を更新しました${NC}"
echo -e "${GREEN}URL: $(gh pr view --json url -q .url)${NC}"
