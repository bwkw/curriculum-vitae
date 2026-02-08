---
description: 現在のブランチの PR タイトルと description をレビューしやすい形式で更新
---

# update-pr-description

現在のブランチに紐づく PR のタイトルと description を、レビューしやすい形式で生成・更新する。

## 手順

1. `gh pr view --json number,title,baseRefName,headRefName` で現在の PR 情報を取得
2. `git diff $(gh pr view --json baseRefName -q .baseRefName)...HEAD` で差分を取得
3. `git log --oneline $(gh pr view --json baseRefName -q .baseRefName)..HEAD` でコミット履歴を取得
4. 上記情報を基に、タイトルとテンプレートに沿った description を生成
5. `gh pr edit --title "..." --body "..."` で更新（確認不要）

## 生成する description のテンプレート

```markdown
## 概要

<!-- 1-2文で何をしたか -->

## 主な変更点

<!-- 箇条書きで主要な変更（具体的なファイル/機能を列挙） -->

## 変更理由

<!-- なぜこの変更が必要か（ビジネス/技術的背景） -->

## 破壊的変更

<!-- ファイル削除/名前変更など。なければ「なし」 -->

## テスト

<!-- 実施したテスト/テスト方法 -->

## レビュー観点

<!-- レビュアーに特に見てほしいポイント -->
```

## タイトルの生成要件

- 日本語で簡潔に概要を記載（50文字以内目安）
- prefix（feat: など）は不要
- 例:
  - `GitHub Actions を最新化し pnpm に移行`
  - `職務経歴書の textlint エラーを修正`
  - `依存パッケージを最新版に更新`

## description の生成要件

- 概要は簡潔に（1-2文）
- 変更理由はビジネス/技術的背景を含める
- 主な変更点は具体的なファイル/機能を列挙
- 破壊的変更（ファイル削除/名前変更）があれば明記、なければ「なし」
- レビュー観点は「ここを重点的に見てほしい」を明確に

## エラーハンドリング

- PR が存在しない場合: 「現在のブランチに PR が見つかりません。先に PR を作成してください。」と表示
- gh コマンドが使えない場合: 「gh CLI がインストールされていません。」と表示

## 注意事項

- このリポジトリは職務経歴書管理リポジトリ（Markdown + GitHub Actions + textlint + pnpm）
