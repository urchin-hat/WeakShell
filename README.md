# WeakShell

誇り高き「弱さ」を追求する、Zig製のシェル。

## コンセプト
完全な趣味と学習のためのシェル実装です。
高度な機能よりも、シンプルであること、そして実装を通じてZigを学ぶことを目的としています。

## 構成
- `src/main.zig`: REPLループ
- `src/shell.zig`: コアロジック
- `src/builtin.zig`: 組み込みコマンド (cd, exit等)

## 使い方
```bash
zig build run
```

## ライセンス
MIT License
