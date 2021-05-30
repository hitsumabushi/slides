class: center,middle

# golang 並行処理の説明用スライド

---

## 並行性と並列性

定義はいろいろあるようだけど、[Rob Pikeに従う](https://talks.golang.org/2012/waza.slide#1)ことにする。
(このスライドはgopherがかわいいので、一読の価値がある)

* 並行性(Concurrency)
    * `Programming as the composition of independently executing processes.`
    * `Concurrency is about dealing with lots of things at once.`
* 並列性(Parallelism)
    * `Programming as the simultaneous execution of (possibly related) computations.`
    * `Parallelism is about doing lots of things at once.`

---

## プロセス、スレッド

詳しいことは、[詳解 Linuxカーネル の第3章](https://www.oreilly.co.jp/books/9784873113135/)を読むか、ソースを読むかしてほしい。
とりあえず、以下のように理解しておけば良いことにする。

* プロセス
    * プログラムの実行単位で、カーネルがリソースを管理する単位
    * カーネルはそれぞれのプロセスに対して、CPU, メモリ, etc...を割り当てる
    * プロセスを生成するとき、forkされる
* (ネイティブ)スレッド
    * ここでは、とりあえず、軽量プロセスのこととしておく。
    * 2つの軽量プロセスの間では、メモリの大部分などを共有できる

--

* 複数の処理を行う場合、プロセス→プロセスで切り替えるよりも、スレッド→スレッドの方が早い
* 参考: http://d.hatena.ne.jp/naoya/20071010/1192040413

---

## 大量のスレッドを生成する場合の問題点

スレッドの切り替えが軽い、とは言ってもネイティブスレッドの生成には、そこそこのリソースを使う。
たとえば、[Man page of PTHREA\_CREATE](https://linuxjm.osdn.jp/html/LDP_man-pages/man3/pthread_create.3.html) を見ると、スタックサイズのデフォルトは2MBになっている。

つまり、C10K問題にあるような、同時に10000スレッドを生成しようと思うと、20GB程度使うことになる。

---

## Golang での並行処理の実装の特徴

* CSP ベースの実装
    * Channel経由で処理間の通信を行う、message passingで頑張る
    * [This is the Go model and (like Erlang and others) it's based on CSP](https://talks.golang.org/2012/waza.slide#10)
* Goroutine と呼ばれる、ユーザースペースに実装されたユーザースレッド。
    * 1 goroutineあたり、数KBで生成できると説明されている。
    * [Goroutines are multiplexed onto OS threads as required](https://talks.golang.org/2012/waza.slide#32)
    * [Why goroutines instead of threads?](https://golang.org/doc/faq#goroutines)

---

## golangで並行処理を考えるのに便利なもの

1. goroutine      : 軽量スレッドで非同期に処理を行う方法
2. channel        : 非同期処理間で値をやり取りする方法
3. sync           : ロックを取る方法
4. 安心な context : 便利データストア

---

## goroutine

`go` をつけると別スレッドで実行されるようになる。

https://play.golang.org/p/GD2p7avjVH

注意としては、元のスレッドが終了すると、goroutineも終わってしまう。
このとき、deferも呼ばれないので、想定と異なる挙動になる。
こういう問題を防ぐには、sync.WaitGroupを使うか、後述のchannelを使う。

https://play.golang.org/p/wFlQQJHyBi

---

## channel

大きく以下の2つの目的で利用する。
* goroutine間で、同期を取る
* goroutine間で、情報をやり取りする

https://play.golang.org/p/4Egh1sURy-

---

## channel

![](slides/remark/golang-concurrency/channel.svg)

---

## 複数のchannelとやりとりをする

`select`を利用する。

https://play.golang.org/p/m8r2gIpYo3

---

## atomic に操作をする

* 同一のリソースへアクセスする場合に、複数のgoroutineからアクセスすると齟齬がでる場合がある
    * これを防ぐには、ある処理を行う場合、他の処理から見たときに、中間状態が見えないようにするという手法が考えられる
* ロックを取って全体としてatomicに見えるような操作を行う
    * [ダメな例 - sync.Mutex](https://play.golang.org/p/3PbZjNn2Eo), [良い例 - sync.Mutex](https://play.golang.org/p/aFsY4xVBVB)
* atomicな操作だけを行うか
    * [ダメな例 - sync/atomic](https://play.golang.org/p/tEdpP2SWHm), [良い例 - sync/atomic](https://play.golang.org/p/WR-LKqGjwz)
* go コマンドに競合を見つけてくれるオプション `-race` がある
    * [Data Race Detector](https://golang.org/doc/articles/race_detector.html)
    * e.g.) `$ go test -race mypkg`

---


## 練習: Singleton

* [この例ではSingletonパターンを実装したいと考えている](https://play.golang.org/p/RpJDe5AS0_)。実装のだめなところを見つけ、競合するように修正してみよう
    * まずは、`go run -race ...`してみる
    * [回答例](https://play.golang.org/p/KEkH3pYcJX)
* sync.Once を使って、Singleton パターンを実装してみよう

---

## 自習: Context

context パッケージを調べ、使ってみよう
