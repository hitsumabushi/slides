class: center,middle

# golang 並行処理の説明用スライド

---

## 並行処理の確認

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

![](slides/golang-concurrency/channel.svg)

---

## atomic に操作をする

* 同一のリソースへアクセスする場合に、複数のgoroutineからアクセスすると齟齬がでる場合がある
* ロックを取って全体としてatomicに見えるような操作を行うか、atomicな操作を行うか
* [ダメな例 - sync.Mutex](https://play.golang.org/p/3PbZjNn2Eo), [ダメな例 - sync/atomic](https://play.golang.org/p/tEdpP2SWHm)
* [良い例 - sync.Mutex](https://play.golang.org/p/aFsY4xVBVB), [良い例2 - sync/atomic](https://play.golang.org/p/WR-LKqGjwz)

---


## 練習: Singleton

* [この例ではSingletonパターンを実装したいと考えている](https://play.golang.org/p/RpJDe5AS0_)。実装のだめなところを見つけ、競合するように修正してみよう
* sync.Once を使って、Singleton パターンを実装してみよう

<https://play.golang.org/p/KEkH3pYcJX>

---

## 自習: Context

context パッケージを調べ、使ってみよう
