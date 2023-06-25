import CreateAsyncStream

@CreateAsyncStream(of: Int, named: "number")
class Example {
  init() {}
  func something() {
    _numberContinuation.yield(6)
  }
}
