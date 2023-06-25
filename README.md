# CreateAsyncStream

This is a macro (which can definitely be improved) where the usage is:
```
@CreateAsyncStream(of: Int, named: "numbers")
class MyClass {
}
```

yields:

```
class MyClass {
  public var numbers: AsyncStream<Int> {
    _numbers
  }

  private let (_numbers, _numbersContinuation) = AsyncStream.makeStream(of: Int.self)
}
```
I'd love suggestions on how to make this better
