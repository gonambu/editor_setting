# Gradleコンポジットビルド対応の回避策

## 現在の設定で解決しない場合の追加オプション

### 1. シンボリックリンクを使用
```bash
# メインプロジェクトのsrcディレクトリに他プロジェクトへのリンクを作成
ln -s ../other-project/src/main/kotlin src/main/kotlin-other
```

### 2. 環境変数でクラスパスを指定
```vim
" init.luaに追加
lspconfig.kotlin_lsp.setup {
  cmd = { 
    'env', 
    'KOTLIN_LSP_CLASSPATH=/path/to/other-project/build/classes/kotlin/main',
    'kotlin-lsp', 
    '--stdio' 
  },
}
```

### 3. 別々のNeovimインスタンスを使用
- 各プロジェクトごとに別のNeovimウィンドウを開く
- それぞれが独自のLSPインスタンスを持つ

### 4. fwcd版への切り替え
fwcd/kotlin-language-serverの方が成熟しており、コンポジットビルドのサポートが良い可能性があります：

```vim
-- init.luaで以下をコメントアウト
-- JetBrains Kotlin LSPの設定部分全体

-- Mason-lspconfigのensure_installedに追加
"kotlin_language_server"
```

### 5. プロジェクト構造の調整
可能であれば、コンポジットビルドではなくマルチモジュールプロジェクトに変更することを検討してください。

## デバッグ方法

1. LSPログを確認: `:LspLog`
2. ワークスペースフォルダを確認: `:lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))`
3. LSPクライアントの設定を確認: `:lua print(vim.inspect(vim.lsp.get_active_clients()[1].config))`