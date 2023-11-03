# Vaporについて
Vapor は、Swift で書かれたオープンソースの Web フレームワークです。Apple の SwiftNIO ライブラリの上に構築されており、強力な非同期フレームワークを提供します。Vapor を使用すると、iOS アプリ、フロントエンド Web サイト、スタンドアロン サーバー アプリケーション用のバックエンド アプリケーションを構築できます。

# インストール
## VaporをmacOS にインストールする
#### `brew install vapor`
注: Vapor は Homebrew Core の一部になりました。Vapor の Homebrew タップを使用して古いバージョンのツールボックスがインストールされている場合は、次のようにして最新バージョンに更新できます。
    ``` sh
    brew uninstall vapor && brew untap vapor/tap && brew install vapor
    ```

## Linux へのインストール
- Linux に Swift をインストール https://www.swift.org/download/
- インストール後の確認　
    ```
    swift --version
    ```
- Vaporのインストール
    ```
    # Clone the toolbox from GitHub.
    git clone https://github.com/vapor/toolbox.git
    
    # Navigate into the toolbox directory that you cloned.
    cd toolbox
    
    # Check out version 18.0.0. You can find the latest
    # release of the toolbox on the releases page on 
    # GitHub at https://github.com/vapor/toolbox/releases.
    git checkout 18.0.0
    
    # Build the toolbox in release mode.
    # --disable-sandbox allows the toolbox to execute other processes.
    swift build -c release --disable-sandbox
    
    # Move the toolbox into your local path
    # so you can call it from anywhere.
    mv .build/release/vapor /usr/local/bin
    ```

## Vaporプロジェクトを作成
``` sh
vapor new HelloVapor
```

アプリをビルドして起動するには、次を実行
``` sh
cd HelloVapor
swift run
```

ブラウザを開いてhttp://localhost:8080/helloにアクセスし、応答を確認

Mac: Package.swiftを開くとXcodeでプロジェクトを開く

```
📦App
 ┣ 📂Controllers
 ┃ ┣ 📜CategoriesController.swift
 ┃ ┣ 📜UsersController.swift
 ┃ ┗ 📜WordsController.swift
 ┣ 📂Migrations
 ┃ ┣ 📜CreateAdminUser.swift
 ┃ ┣ 📜CreateCategory.swift
 ┃ ┣ 📜CreateToken.swift
 ┃ ┣ 📜CreateUser.swift
 ┃ ┣ 📜CreateWord.swift
 ┃ ┗ 📜CreateWordCategoryPivot.swift
 ┣ 📂Models
 ┃ ┣ 📜Category.swift
 ┃ ┣ 📜Token.swift
 ┃ ┣ 📜User.swift
 ┃ ┣ 📜Word.swift
 ┃ ┗ 📜WordCategoryPivot.swift
 ┣ 📜configure.swift
 ┣ 📜entrypoint.swift
 ┗ 📜routes.swift
```

- **App:** これはアプリケーションのメインフォルダです。Vaporアプリケーションの主要なソースコードやファイルがこのディレクトリ内に格納されます。
- **Controllers:** MVC (Model-View-Controller) パターンに基づいて、このフォルダには各種コントローラーが含まれます。コントローラーは、特定のモデルに関連するルートのリクエストとレスポンスを処理します。
WordsController.swift: 単語に関するリクエストを処理するためのコントローラー。
- **Migrations:** このフォルダにはデータベースのマイグレーションスクリプトが含まれています。これにより、データベースのテーブルやスキーマの変更を継続的に追跡できます。
- **Models:** このフォルダにはアプリケーションの主要なモデルが含まれています。モデルはデータベースのテーブルやその他のデータ構造を表現します。
- **configure.swift:** アプリケーションの設定や初期化に関連するコードを含むファイル。
- **entrypoint.swift:** アプリケーションのエントリーポイント。アプリケーションの実行がここから始まります。
- **routes.swift:** アプリケーションのルーティングを設定するファイル。リクエストと特定のコントローラーアクションのマッピングがここで行われます。

# Vaporのトラブルシューティング
### プロジェクトでエラーが発生する場合、問題をトラブルシューティングするには、いくつかの手順を実行する必要があります。

### 依存関係を更新する

    遭遇する可能性のある別のシナリオは、Vapor または使用する別の依存関係でバグが発生することです。依存関係の最新のパッケージ バージョンを使用していることを確認し、アップデートで問題が解決されるかどうかを確認してください。Xcode で、[ファイル] ▸ [Swift パッケージ] ▸ [最新のパッケージ バージョンに更新]を選択します。ターミナルまたは Linux でアプリを実行している場合は、次のように入力します。

    swift package update

    この SwiftPM コマンドは、依存関係の更新をプルダウンし、 Package.swiftでサポートされている最新リリースを使用します。パッケージはベータ版またはリリース候補段階にありますが、更新の間に重大な変更が発生する可能性があることに注意してください。

### クリーンアップして再構築する

    最後に、まだ問題が解決しない場合は、「電源をオフにして再度オンにする」に相当するソフトウェアを使用できます。Xcode で、Command-Option-Shift-Kを使用してビルド フォルダーをクリーンアップします。

    Xcode プロジェクトやワークスペース自体の派生データもクリアする必要がある場合があります。「核」オプションには以下が含まれます。

- .buildディレクトリを削除して、コマンド ラインからビルド アーティファクトを削除します。
- .swiftpmディレクトリを削除して、Xcode ワークスペースと構成ミスを削除します。
- 次回ビルドするときに最新の依存関係を確実に取得できるように、Package.resolved を削除します。
- DerivedDataを削除して、余​​分な Xcode ビルド アーティファクトをクリアします。
