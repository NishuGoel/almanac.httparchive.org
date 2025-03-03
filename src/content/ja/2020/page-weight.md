---
#See https://github.com/HTTPArchive/almanac.httparchive.org/wiki/Authors'-Guide#metadata-to-add-at-the-top-of-your-chapters
title: ページの重さ
description: 2020年のWeb Almanacの「ページの重さ」の章では、ページの重さが重要な理由、帯域幅、複雑なページ、時間経過によるページの重さ、ページのリクエスト、ファイル形式について説明しています。
authors: [henrihelvetica]
reviewers: [paulcalvano]
analysts: [paulcalvano]
editors: [tunetheweb]
translators: [ksakae]
henrihelvetica_bio: Henriはフリーランスの開発者であり、興味をパフォーマンスエンジニアリングとユーザーエクスペリエンスを組み合わせたポプリに変えています。日々の研究ドキュメントやケーススタディの洪水を読んだり、開発ツールのサイトを無差別に監査したりしていないときは、コミュニティに貢献したり、<a href="https://twitter.com/towebperf">Toronto Web Performance Group</a>を含む共同プログラミングのミートアップに参加したり、様々なブートキャンプでランチをしたり学んだりするために自分の時間をボランティアで提供したりしています。それ以外の時は、音楽制作ソフトを使ってツーリングをしたり、ほぼ確実にトレーニングをして、可能な限り最速で5kmを走ることに集中しています。
discuss: 2054
results: https://docs.google.com/spreadsheets/d/1wG4u0LV5PT9aN-XB1hixSFtI8KIDARTOCX0sp7ZT3h0/
featured_quote: ウェブの旅は、平凡で教育的なプラットフォームに近いものから、革新的で複雑で高度にインタラクティブなアプリになり、初歩的なページ重量のメトリックは、より大きなストーリー＆コロンを隠していました;リソースのラタトゥイユ、それぞれが現代のメトリックに影響を与え、順番にユーザー体験に影響を与えます。
featured_stat_1: 1,915
featured_stat_label_1: モバイルページのバイト数の中央値
featured_stat_2: 916
featured_stat_label_2: モバイルページの画像バイト数の中央値
featured_stat_3: 70
featured_stat_label_3: モバイルページのリクエスト数の中央値
---

## 序章

ページの重さは、利用可能な最も単純な測定基準の1つです。あなたの個人的な体重の感覚を得るため人間の体重計にのるように（まあ実際には質量ですが、あなたはそれを得ることができます）、ページをロードすると収集され要求されたリソースの数とサイズの感覚を提供します。しかしウェブとウェブページが成熟し成長してきたように、ページの重さのような関連するメトリクスも増えてきました。それは、個人の体重（質量）が同じことをできるのと同じように、ページのパフォーマンスに影響を与えることができます。この章では、ウェブページの層を深く掘り下げて、エンドユーザー（あなた、私、私たち）の不利益になる可能性のあるページの重量を構成するものが何であるかを見ていきます。

<!-- markdownlint-disable MD018 -->
### #PageWeightStillMatters

#PageWeightStillMattersは、それが重要ではなかった、あるいは今までに重要ではなかったということをほぼ暗示しています。テキストベースのCraigslistが登場したときには問題にならなかったかもしれません。しかし、それが設立された25年前、Mosaic1.0も同じ年に発売され、TLCのWaterfallsがトップヒットしました。ウェブはリソースと同様に成熟していきました。ちょうど数年前のことですが、twitterの世界では、ウェブページの平均サイズが今では [オリジナルの運命] (https://www.wired.com/2016/04/average-webpage-now-size-original-doom/) のサイズに匹敵するかどうかが議論されていました。私たちの多くは、<a hreflang="en" href="https://speedcurve.com/blog/web-performance-page-bloat/">私たち自身のTammy Everts</a>を含めて、ページのサイズが時間の経過とともにどのようなものになるかについて考えていましたが、現実は驚くべきものでした。ページのサイズは、デスクトップ/モバイルでそれぞれ75パーセンタイルで、~4MBと3.7MB、90パーセンタイルでは7.4MBと6.7MBという衝撃的なサイズになっています。このような重いページを持つことには、信頼性の低いネットワークによるユーザー体験の低下の可能性など、様々な意味合いがあります。今日では、<a hreflang="en" href="https://blog.chriszacharias.com/page-weight-matters">10年前に学んだ教訓</a> にもかかわらず、同じ課題のバリエーションを経験しています：わずかに優れたネットワークを持っているにもかかわらず、はるかに大きなリソースを使って作業しています。
<!-- markdownlint-enable MD018 -->

### 帯域幅

2016年、私が話をしたオーストラリアの観光客が英国のインターネットに満足している理由を説明するように求められたとき、GoogleのIlya Grigorikには[2つの言葉がありました]（https://youtu.be/x4S38hpgxuM?t=89）：物理学はそれを酷評しました！（おっと、それは3つです）。

要点は単純でした。帯域幅を増やすことでメリットが得られるかもしれませんが、それでも物理法則が優先されます。 オーストラリア人は遅延の法則から逃れることができません。 最良のシナリオでは、シドニーの自宅で、このオーストラリア人はインターネットが応答しないと認識されるほどの遅延を経験していました。

さて同じオーストラリア人が、75パーセンタイルで、彼のページが約108リクエストを行っていることを知っていると想像してみてください（これについては後で詳しく説明します）。最新のリクエストの寿命についての詳細は[HTTP/2](./http)と[圧縮](./compression)の章を参照してください。

### 資産

現代のブラウジングの25年間で、資産とリソースは量意外ほとんど変わっていません。 HTTP archiveの手口は「Webがどのように構築されたか」であり、それは主にHTML、CSS、JavaScript、そして最後に画像で行われました。

1995年以前は、ウェブのページの重さはほとんど予測可能で管理可能でした。しかしHTML2.0を導入した<a hreflang="en" href="https://tools.ietf.org/html/rfc1866">RFC 1866</a>では、`<img>`要素を介してインライン画像を導入することで、ページの重さは劇的に増加します、すべてはウェブ開発のためになるでしょう（画像の追加はポジティブな実験とみなされていました）。

ほとんどの場合、画像がページの重さの大部分を占めるというのが経験則でした。確かに、インライン画像がウェブに追加された当時はそうでしたし、現在もそうです。別のシナリオでは、画像データがページ重量の最大のソースとなるため、ページ重量の節約の最大のソースにもなります（これについては後述します）。これは、画像を適切なサイズにするだけでなく、画像が最適化のスイートスポットにあることを確認することで達成されます - 品質とファイルサイズの最適なバランスを見つけることです。

JavaScriptは平均的にページ上で2番目に豊富なリソースですが、バンドル、圧縮、ミニ化などのファイルタイプを扱う機会が多くなりがちです。

### 複雑で対話的

平凡で教育に近いプラットフォームから、標準となった革新的で複雑で高度に対話的なアプリへのWebの旅は、より大きなストーリーを隠しました。リソースのラタトゥイユは、それぞれが最新のメトリックに影響を与え、次にユーザー体験にも影響を与えます。

私たちが対話性について話すとき、私たちはほとんどもっぱらJavaScriptについて話しています。ここでは対話性について深く議論するわけではありませんが、JavaScriptのコンテンツと実行に焦点を当て、依存するメトリクスがあることは知っています。ですから、JavaScriptが重くなればなるほど、対話性のメトリクス（対話までの時間、総ブロッキング時間）に大きな影響を与える可能性が高くなります。私たちは、[JavaScriptの章](./javascript)でもう少し掘り下げています。

## 分析

統計結果を投稿して解析しているため、データは転送サイズに基づいていることが多いです。しかし、今回の分析では可能な限り解凍したサイズを採用しています。

### ページ重量

デスクトップとモバイルの両方で、従来のページの重さを見てみましょう。デルタのほとんどはモバイルで転送されるリソースが少なくなったこと、メディア管理のピンチによるものですが、中央値では、2つのクライアント間の差はそれほど大きくないことがわかります。

{{ figure_markup(
  image="bytes-distribution.png",
  caption="1ページあたりの総バイト数の分布。",
  description="ページあたりの総バイト数の分布を示す棒グラフ。デスクトップページの方が全体的にバイト数が多い傾向にあります。モバイルページの10、25、50、75および90パーセンタイルの割合は以下の通りです。1ページあたり369、900、1,915、3,710、および6,772KByteです。",
  chart_url="https://docs.google.com/spreadsheets/d/e/2PACX-1vQlN4Clqeb8aPc63h0J58WfBxoJluSFT6kXn45JGPghw1LGU28hzabMYAATXNY5st9TtjKrr2HnbfGd/pubchart?oid=248363224&format=interactive",
  sheets_gid="378779486",
  sql_file="bytes_per_type_2020.sql"
) }}

しかし、このことから次のことが推測できます：モバイルでは7MB、デスクトップでは7.5MBのページ重量が90パーセンタイルに近づいています。このデータは昔からのトレンドを踏襲しています：ページ重量の伸びは前年に比べて再び上昇傾向にあります。

{{ figure_markup(
  image="bytes-distribution-content-type.png",
  caption="コンテンツの種類別の1ページあたりのバイト数の中央値。",
  description="画像、JavaScript、CSS、HTMLの1ページあたりのバイト数の中央値を示す棒グラフ。デスクトップページの中央値は、より多くのバイト数を持つ傾向にあります。モバイルページの中央値は、画像が916KB、JSが411KB、CSSが62KB、HTMLが25KBです。",
  chart_url="https://docs.google.com/spreadsheets/d/e/2PACX-1vQlN4Clqeb8aPc63h0J58WfBxoJluSFT6kXn45JGPghw1LGU28hzabMYAATXNY5st9TtjKrr2HnbfGd/pubchart?oid=1147150650&format=interactive",
  sheets_gid="378779486",
  sql_file="bytes_per_type_2020.sql"
) }}

ボンネットを開けると、各リソースの中央値と平均値がどのように見えるかがわかります。 ここでも1つ残っています。画像が主要なリソースであり、JavaScriptが2番目に多いですが、はるかに2番目に多いです。

### リクエスト

我々は古い格言を持っています：最も迅速な要求は、決して行われないものである。あえて言うならば、最小のリソースは一度もリクエストされないものであるということです。リクエストレベルでは、多くのことが同じです。最も重みのあるリソースが最も多くのリクエストをしています。

{{ figure_markup(
  image="requests-distribution.png",
  caption="1ページあたりのリクエストの分布。",
  description="ページあたりのリクエストの分布を示す棒グラフ。デスクトップページは、より多くのリクエストを読み込む傾向があります。モバイルページの10、25、50、75、90 パーセンタイルは以下の通りです。ページあたりのリクエスト数は23、42、70、114、174です。",
  chart_url="https://docs.google.com/spreadsheets/d/e/2PACX-1vQlN4Clqeb8aPc63h0J58WfBxoJluSFT6kXn45JGPghw1LGU28hzabMYAATXNY5st9TtjKrr2HnbfGd/pubchart?oid=971564375&format=interactive",
  sheets_gid="457486298",
  sql_file="request_type_distribution_2020.sql"
) }}

リクエスト分布を見ると、デスクトップとモバイルの差はそれほど大きくなく、デスクトップがリードしていることがわかります。注目すべき点は、この時点でのデスクトップのリクエストの中央値は同じ[昨年と同じ](../2019/page-weight#page-requests)(74)ですが、ページの重さは上昇しています(+122kb)。単純な観察ですが、長年にわたって見てきた軌跡を裏付けるものです。

{{ figure_markup(
  image="requests-content-type.png",
  caption="コンテンツタイプ別のモバイルページあたりのリクエスト数の中央値",
  description="コンテンツの種類別にモバイルページあたりのリクエスト数の中央値を示す棒グラフ。ページあたりの画像リクエスト数の中央値は27件、JSが19件、CSSが7件、HTMLが3件となっています。デスクトップとモバイルは同じ傾向にありますが、デスクトップページのロード量は画像とJSリクエストのロード量がわずかに多いことを除いては、同じ傾向にあります。",
  chart_url="https://docs.google.com/spreadsheets/d/e/2PACX-1vQlN4Clqeb8aPc63h0J58WfBxoJluSFT6kXn45JGPghw1LGU28hzabMYAATXNY5st9TtjKrr2HnbfGd/pubchart?oid=101271976&format=interactive",
  sheets_gid="457486298",
  sql_file="request_type_distribution_2020.sql"
) }}

画像はまたしてもリクエスト数が一番多いです。JavaScriptは、去年の間にわずかにその差は縮まってきています。

### ファイル形式

{{ figure_markup(
  image="response-distribution-format.png",
  caption="フォーマット別の画像サイズの分布。",
  description="gif、ico、jpg、png、svg、webpのフォーマット別の画像サイズの分布をボックスプロットしたものです。Jpgが最も高い分布をしていて、90パーセンタイルで1枚あたり150KBを超えています。Pngは90パーセンタイルで約100KBと2番目に高いです。WebPの90パーセンタイルはpngよりも小さいですが、75パーセンタイルは高くなっています。 gif、ico、svgはいずれも0KBに近い比較的小さな分布です。.",
  chart_url="https://docs.google.com/spreadsheets/d/e/2PACX-1vQlN4Clqeb8aPc63h0J58WfBxoJluSFT6kXn45JGPghw1LGU28hzabMYAATXNY5st9TtjKrr2HnbfGd/pubchart?oid=211653520&format=interactive",
  sheets_gid="142855724",
  sql_file="requests_format_distribution.sql"
) }}

画像がページの重さの大きな情報源であることを知っています。上の図は、画像の重さのトップソースと重さの分布を示しています。トップ3。JPG、PNG、WebP。つまり、JPGは最も人気のある画像フォーマットであるだけでなく、サイズ的にも最も大きい傾向があります。しかし、私たちが[昨年指摘したように](../2019/page-weight#file-size-by-image-format-for-images--1024-bytes)、それはPNGの主な使用例であるアイコンやロゴに関係しています。

### 画像バイト数

{{ figure_markup(
  image="response-distribution-images.png",
  caption="1ページあたりの画像レスポンスサイズの分布。",
  description="ページあたりの画像バイト数の分布を示す棒グラフ。デスクトップページは、分布全体を通してページあたりの画像バイト数が多い傾向にあります。モバイルページの 10、25、50、75、90パーセンタイルは以下の通りです。ページあたりの画像のバイト数は、67、284、928、2,365、4,975KBです。",
  chart_url="https://docs.google.com/spreadsheets/d/e/2PACX-1vQlN4Clqeb8aPc63h0J58WfBxoJluSFT6kXn45JGPghw1LGU28hzabMYAATXNY5st9TtjKrr2HnbfGd/pubchart?oid=2019686506&format=interactive",
  sheets_gid="730277265",
  sql_file="request_type_distribution_2020.sql"
) }}

総画像バイト数を見てみると、ページ全体の重量で前述したように、同じように上向きの傾向が見られます。

## コロナウィルス

2020年はインターネットの歴史の中で最も需要の高い年となった。これは、世界中の<a hreflang="en" href="https://www2.telegeography.com/network-impact">通信会社</a>による自己申告に基づいています。YouTube、Netflix、ゲーム機メーカー、その他多くの企業が、コロナウィルスの予測される帯域幅需要と自宅待機命令のために、<a hreflang="en" href="https://www.bloomberg.com/news/articles/2020-03-19/netflix-to-cut-streaming-traffic-in-europe-to-relieve-networks">自分たちのネットワークのスロットル</a>を要求されました。今では、ネットワークに需要を生み出す新たな容疑者が出てきています。この危機の中でいくつかの政府機関は、サイトのすべての側面を最適化し、再設計または更新するために前進しています。<a hreflang="en" href="https://ca.gov">ca.gov</a> (<a hreflang="en" href="https://news.alpha.ca.gov/prioritizing-users-in-a-crisis-building-covid19-ca-gov/">link</a>)と<a hreflang="en" href="https://gov.uk">gov.uk</a>がその例です。これらの時代では、コロナウィルスはインターネットが不可欠なサービスとして認定されており、重要な命を救う情報にアクセスすることができるようにデータの規律配信を介して管理可能なページの重量が含まれている可能な限り摩擦がないようにする必要があります。

インターネットに嫁いできた私たちは、コロナウィルスによって、誓いを新たにせざるを得なくなりました。インターネット上でできる限り効率的にコンテンツを配信するためには、常にページの重さを最優先にしなければなりません。

## そう遠くない未来

私たちは25年間、ページの重量が着実に成長するのを見てきました。それは最大の株式投資の一つであったかもしれません - それが一つであったならば。しかし、これはウェブであり、我々はデータ、リクエスト、ファイルサイズ、そして最終的にはページの重量を管理しようとしています。

画像が最大の重みの源であることがわかるように、データをまとめたところです。 これは、それが私たちの最大の節約の源でもあることを意味します。 2020年は極めて重要な年であり、WebデータのHTTP Archive追跡の変曲点となる可能性があります。 2020年は、最新の形式のWebPがついにSafariに採用され、この形式が最終的にすべてのブラウザーでサポートされるようになった年でした。 これは、このフォーマットがフォールバックをほとんどまたはまったく伴わずに快適に使用できることを意味します。 最も重要なポイントは？　ページの大幅な軽量化の可能性はそこにあります。30％可能なです。

さらに興味深いのは、より現代的なフォーマットであるavifのアイデアです。このフォーマットは、今日ではブラウザの市場シェアの約70%に十分対応しており、WebPよりもさらに小さな画像ファイルサイズのシナリオを生み出しています。そして最後に、おそらく最も遠い存在であると思われるメディアクエリレベル5、`prefers-reduced-data`です。非常に初期の草案ではありますが、このメディア機能はデータに敏感な状況でユーザーがバリアントリソースを好むかどうかを検出するために使用され、すでに<a hreflang="en" href="https://caniuse.com/mdn-css_at-rules_media_prefers-reduced-data">ブラウザで利用可能になり始めています</a>。

水晶の玉を見てみると、Web Almanacの第3弾とページの重さの章は、2021年にはかなり違った姿になっているかもしれません。イメージへの大きな技術的・工学的投資は、最終的に私たちが探し求めていた減少するリターンを提供してくれるかもしれません。

## 結論

Webページが一般的に成長し続けているのは当然のことです。私たちはより豊かな体験、より魅力的なインタラクティブ性、よりパワフルな画像による魅力的なビジュアルを実現するためにより多くのリソースを投入してきました。私たちは、データの超過やユーザーエクスペリエンスを犠牲にして、これらのアプリケーションを作成してきました。しかし私たちが前進し、予想もしていなかった場所にウェブを押し進めていく中で、先に述べたように私たちはエンジニアリングにおいてもさらなる進歩を遂げています。最新のラスター画像フォーマットがより多く採用されるようになり、JavaScriptの管理がより効率的になり、ユーザーが求める規律を持ってデータを配信できるようになると早ければ来年にはページの重さの低下が見られるようになるかもしれません。
