#===============================
# setting
#===============================
home_box_width = 28;

#===============================
# part
#===============================
# sample = fluidRow( tags$head(includeHTML("sample.html")) )

overview = box(
   #title = 'Overview',
   title = 'このアプリは何？',
   h5('このアプリは、用量反応曲線からIC50とmを推定するためのアプリです。',br(),
      '主に実験科学者が対象ですが、手っ取り早く&プログラミングスキルがなくともIC50とmを推定することが可能です。'),
   status="danger", collapsible = TRUE, collapsed = TRUE, width = home_box_width
);

why = box(
   title = 'なぜこのアプリが必要か',
   h5('以下のような悩みや課題はございますか？:',br(),
      '・実験がとにかく忙しい。。。',br(),
      '・とにかく手っ取り早く、IC50とmを知りたい！',br(),
      '・プログラミングは嫌だな...'),
   status="primary", collapsible = TRUE,collapsed = TRUE, width = home_box_width
);

whom = box(
   title = '誰を対象としている?',
   h5('・実験科学者', br(),
      '・今すぐIC50とmを知りたい方', br(),
      '・IC50だけでなくIC90や99も知りたい', br(),
      '・無料で使いたい', br(),
      '・プログラミングは嫌だ', br(),
      '・時短のために、PCだけでなくスマホやiPadでも分析したい'),
   status="success", collapsible = TRUE,collapsed = TRUE, width = home_box_width #
);

#how_to = h4('STEP1: Push ≡ to move on to Import file',br(),'STEP2: Push Browse to choose your data',br(),'STEP3: Push ≡ to go to visualization data');
how_to = box(
   title = 'どうやって使用するの？',
   h5('開発中です。更新をお待ちください。'),
   status="warning", collapsible = TRUE, collapsed = TRUE, width = home_box_width
)

render = box(
   title = '完成イメージ図',
   #div(shiny::img(src="iris.png", height = "100%", width = "100%"), align="left"),
   h5('開発中です。更新をお待ちください。'),
   collapsible = TRUE, collapsed = TRUE, width = home_box_width
)

security = box(
   title = 'セキュリティについて',
   h5('本ウェブサイトはSSL通信ですが、どなたでもアクセスできるようになっております。そのため本webアプリでは、下記の2つのユースケースを想定しております。'),
   h4(br(),'ユースケース１：web上で、サンプルデータなどを用いてお楽しみください'),
   h5('機密性の高いデータを用いた利用をお薦めしておりません。サンプルデータで本サービスをお楽しみ下さることを強く推奨いたします。',br(),'もし本サービスご利用後、今後も使ってみたいなとなりましたら、ユースケース２をご覧ください。'),
   h4('ユースケース２：ご自身のPCなどで、本サービスをご利用ください'),
   h5('ご自身のPCなどでご利用いただけるように、今後githubにて無料でソースコードをご提供する予定です。',br(),'将来的には、ご自身のPCなどで本サービスをご活用いただけることを検討しておいます。'),
   collapsible = TRUE, collapsed = TRUE, width = home_box_width
)

mind = box(
   title = '製作者の思い',
   h5('いつでも・どこでも・どなたでもお気軽にデータ分析をしてほしいという思いで、本webアプリを1人で無償で提供しております。'),
   h5('至らぬ点も多くあるかと存じますが、ご指摘いただけると幸いです。もしご指摘をいただける場合は、こいつわかってないなぁと寛大なお気持ちでご指摘をお願いできればと考えております。誹謗中傷は1人の人間として悲しみます。'),
   h5('最後になりましたが、本webアプリや製作者の意図にご共感いただける方は、ぜひ一緒に運用・開発して頂けないでしょうか？ご一報いただければ嬉しいです。'),
   collapsible = TRUE, collapsed = TRUE, width = home_box_width
)


#memo   = h6('You can get a such data visualization! Make use of it!', br(), 'This is a sample iris data.'); 

update = h5( 'version 3.0', br(), 'updated: 27th September, 2020', br(), '© 2020 Yusuke Ito' );

#===============================
# whole
#===============================
home = tabPanel("home",
                overview,
                why,
                whom,
                #titlePanel("How to use this app"),
                fluidRow( column(width = 12, how_to) ),
                render,
                security,
                mind,
                #titlePanel("Rendering"),
                #fluidRow( column(width = 12, render, memo ) ),
                fluidRow( column(width = 12, update ) )
)





