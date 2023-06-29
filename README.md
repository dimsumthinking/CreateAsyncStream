# CreateAsyncStream

This is a macro where the usage is:
```
@CreateAsyncStream(of: Int.self, named: "numbers")
class MyClass {
}
```

yields:

```
class MyClass {
  public var numbers: AsyncStream<Int> {
    _numbers
  }

  private let (_numbers, numbersContinuation) = AsyncStream.makeStream(of: Int.self)
}
```
I'd love suggestions on how to make this better - based on suggestions from @Ole and @GeekAndDad I've replaced the string parsing with SwiftSyntax based calls. 
