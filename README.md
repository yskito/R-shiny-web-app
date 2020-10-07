### このリポジトリは何？
このリポジトリには、webアプリを開発するためのRファイルがあります。   
R shinyパッケージを用いています。
日本語バージョンです。

---

### どうやってソースコードをダウンロードするの？
ご希望のフォルダを、zipファイルとして丸ごとダウンロードされてください。  
  
ちなみに、おすすめのダウンロード方法は、以下の通りです。  
手順１：　ブラウザchromeでこのページを開く。[R_shiny_web_app_japanese](https://github.com/yskito/R_shiny_web_app_japanese)  
手順２：　chrome拡張機能の1つ「GitZip for github」を追加する。まだ追加されていない方はこちらから。[GitZip for github](https://gitzip.org/)  
　　　　　参照：　[GitZip for githubの使い方](https://baba-s.hatenablog.com/entry/2019/09/09/070800)  
手順３：　GitZip for githubを用いて、取得する。  

※githubに普段から慣れていらっしゃる方は、通常通りgitを介してソースコードを取得されてください。

---

### 注意事項
通常shinyパッケージを用いたRファイルは、ui.Rとserver.Rで構成されます。  
しかし、分量が多くなると非常に可読性が低下し理解しにくくなります。  
私もui.Rとserver.Rに分離してこれまで試みましたが、分量が多くなるとわかりにくいと感じました。  
  
そのため、このリポジトリにあるRファイルは両方の内容を含み、その他のRファイルから構成されます。  
この点にはご留意いただければ幸いです。
なお、shinyApp(ui,server)とすれば実装できます。

---
