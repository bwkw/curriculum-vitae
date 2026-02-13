# 職務経歴書 / Curriculum Vitae

[![lint text](https://github.com/bwkw/curriculum-vitae/actions/workflows/lint-text.yml/badge.svg)](https://github.com/bwkw/curriculum-vitae/actions/workflows/lint-text.yml)
[![check links](https://github.com/bwkw/curriculum-vitae/actions/workflows/check-links.yml/badge.svg)](https://github.com/bwkw/curriculum-vitae/actions/workflows/check-links.yml)

Markdown 形式で管理する職務経歴書です。GitHub Pages で Web 公開しています。

## 閲覧

- **Web 版**: [GitHub Pages](https://bwkw.github.io/curriculum-vitae/)
- **Markdown**: [docs/index.md](https://github.com/bwkw/curriculum-vitae/blob/main/docs/index.md)

## セットアップ

### 必要な環境

- Node.js 20 以上
- pnpm 9 以上

### インストール

```bash
# リポジトリをクローン
git clone https://github.com/bwkw/curriculum-vitae.git
cd curriculum-vitae

# pnpmがインストールされていない場合
npm install -g pnpm

# 依存パッケージをインストール
pnpm install
```

## 使い方

### 職務経歴書の編集

`docs/index.md` を編集してください。

### テキスト校正

```bash
# 校正チェック
pnpm run lint

# 自動修正
pnpm run lint-fix
```

### フォーマット

```bash
# コードをフォーマット
pnpm run format

# フォーマットチェック（CI用）
pnpm run format:check
```

### すべてのチェックを実行

```bash
# format チェックと lint を実行
pnpm test
```

## 機能

### 自動化されたワークフロー

- **テキスト校正**: プッシュ・PR 時に自動で textlint を実行
- **リンクチェック**: 毎週日曜日に自動でリンク切れをチェック
- **定期リマインダー**: 3 ヶ月ごとに職務経歴書の更新を促す Issue を自動作成

### 手動トリガー

GitHub Actions の「Actions」タブから以下を手動実行できます：

- **リンクチェック**: 「check links」を実行

### Git Hooks

コミット前に自動で textlint が実行されます（Husky 使用）。

## 技術スタック

- **Markdown**: 職務経歴書の記述
- **textlint**: 日本語文章の校正
- **GitHub Actions**: CI/CD
- **GitHub Pages**: 静的サイトホスティング（just-the-docs テーマ）
- **Husky**: Git Hooks 管理

## textlint ルール

以下のルールセットを使用して、高品質な日本語文章を維持しています：

- `preset-ja-technical-writing`: 技術文書向けルール
- `preset-jtf-style`: JTF 日本語標準スタイルガイド
- `preset-ja-spacing`: 日本語のスペーシングルール
- その他、多数の日本語校正ルール

詳細は `.textlintrc` を参照してください。
