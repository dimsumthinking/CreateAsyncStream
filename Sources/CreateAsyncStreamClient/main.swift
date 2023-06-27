import CreateAsyncStream

@CreateAsyncStream(of: Int.self, named: "number")
class Example {
  init() {}
  func something() {
    numberContinuation.yield(6)
  }
}
