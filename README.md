---

### このリポジトリは何？
このリポジトリには、webアプリを開発するためのRファイルがあります。   
R shinyパッケージを用いています。
日本語バージョンです。

---

### どうやってソースコードをダウンロードするの？
ご希望のフォルダを、zipファイルとして丸ごとダウンロードされてください。  
  
ちなみに、おすすめのダウンロード方法は、以下の通りです。  
手順１：　ブラウザchromeでこのページを開く。[R_shiny_web_app_japanese](https://github.com/yskito/R_shiny_web_app_japanese)  
手順２：　chrome拡張機能の1つ「GitZip for github」(注釈１,２)を追加する。  
手順３：　GitZip for githubを用いて、ご希望のwebアプリのソースコードが入ったフォルダを丸ごと取得する。  

注釈１：　まだGitZip for githubを追加されていない方は、こちらからchromeに追加してください。[GitZip for github](https://gitzip.org/)  
注釈２：　GitZip for githubの使い方がわからない方はこちらから。[GitZip for githubの使い方](https://baba-s.hatenablog.com/entry/2019/09/09/070800)  

※githubに普段から慣れていらっしゃる方は、通常通りソースコードを取得されてください。

---

### ソースコード取得後はどうすればwebアプリと同じような操作ができるの？
手順１：　取得したzipファイルを開いてください。  
手順２：　ui_server.Rファイルを、ソフトウェアRstudio（注釈１）で開く。  
手順３：　▶︎ Run Appを押す(真ん中上部にあると思います)。  
たった3つのステップで、皆様のPC画面でwebアプリと同様の操作ができます。  
  
注釈１：　Rstudioをお持ちでない方は、こちら↓から。無料です。  
[Rstudioのダウンロード](https://rstudio.com/products/rstudio/download/)。

---

### 普段からshinyパッケージを用いてwebアプリを開発されている方々へのご留意点
通常shinyパッケージを用いたRファイルは、ui.Rとserver.Rで構成されます。  
しかし、分量が多くなると非常に可読性が低下し理解しにくくなります。  
私もui.Rとserver.Rに分離してこれまで試みましたが、分量が多くなるとわかりにくいと感じました。  
  
そのため、このリポジトリにあるRファイルは両方の内容を含み、その他のRファイルから構成されます。  
この点にはご留意いただければ幸いです。
なお、shinyApp(ui,server)とすれば実装できます。
