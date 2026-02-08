# 職務経歴書 / Curriculum Vitae 👋

[![build pdf](https://github.com/bwkw/curriculum-vitae/actions/workflows/build-pdf.yml/badge.svg)](https://github.com/bwkw/curriculum-vitae/actions/workflows/build-pdf.yml)
[![lint text](https://github.com/bwkw/curriculum-vitae/actions/workflows/lint-text.yml/badge.svg)](https://github.com/bwkw/curriculum-vitae/actions/workflows/lint-text.yml)
[![check links](https://github.com/bwkw/curriculum-vitae/actions/workflows/check-links.yml/badge.svg)](https://github.com/bwkw/curriculum-vitae/actions/workflows/check-links.yml)

Markdown 形式で管理する職務経歴書です。GitHub Pages で Web 公開し、PDF としても出力できます。

## 📄 閲覧

- **Web 版**: [GitHub Pages](https://bwkw.github.io/curriculum-vitae/)
- **Markdown**: [docs/README.md](https://github.com/bwkw/curriculum-vitae/blob/master/docs/README.md)
- **PDF**: [Releases](https://github.com/bwkw/curriculum-vitae/releases)からダウンロード

## 🚀 セットアップ

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

## 📝 使い方

### 職務経歴書の編集

`docs/README.md` を編集してください。

### テキスト校正

```bash
# 校正チェック
pnpm run lint

# 自動修正
pnpm run lint-fix
```

### PDF 生成

```bash
# PDFを生成（docs/README.pdf に出力）
pnpm run build:pdf
```

## 🔧 機能

### 自動化されたワークフロー

- **テキスト校正**: プッシュ・PR 時に自動で textlint を実行
- **リンクチェック**: 毎週日曜日に自動でリンク切れをチェック
- **PDF 生成とリリース**: `v*` タグをプッシュすると自動で PDF を生成してリリースに添付
- **定期リマインダー**: 3 ヶ月ごとに職務経歴書の更新を促す Issue を自動作成

### 手動トリガー

GitHub Actions の「Actions」タブから以下を手動実行できます：

- PDF 生成（workflow_dispatch）
- リンクチェック

### Git Hooks

コミット前に自動で textlint が実行されます（Husky 使用）。

## 🛠️ 技術スタック

- **Markdown**: 職務経歴書の記述
- **textlint**: 日本語文章の校正
- **md-to-pdf**: Markdown→PDF 変換
- **GitHub Actions**: CI/CD
- **GitHub Pages**: 静的サイトホスティング
- **Husky**: Git Hooks 管理

## 📋 textlint ルール

以下のルールセットを使用して、高品質な日本語文章を維持しています：

- `preset-ja-technical-writing`: 技術文書向けルール
- `preset-jtf-style`: JTF 日本語標準スタイルガイド
- `preset-ja-spacing`: 日本語のスペーシングルール
- その他、多数の日本語校正ルール

詳細は `.textlintrc` を参照してください。

## 📦 PDF 設定

PDF 出力のスタイルは以下で設定できます：

- `pdf-configs/config.js`: ページサイズ、マージンなど
- `pdf-configs/style.css`: フォント、色、レイアウトなど
