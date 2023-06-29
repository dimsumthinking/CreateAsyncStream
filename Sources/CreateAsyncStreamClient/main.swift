import CreateAsyncStream

@CreateAsyncStream(of: Int.self, named: "numbers")
class Example {
  func something() {
    numbersContinuation.yield(6)
  }
}
