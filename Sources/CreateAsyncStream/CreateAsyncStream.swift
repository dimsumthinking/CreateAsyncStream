// The Swift Programming Language
// https://docs.swift.org/swift-book

/// This macro adds a public async stream of a given type and a private continuation
///  to a class
///
///     `@CreateAsyncStream(of: Int, named: "numbers")`
///
/// adds the following members to the class:
/// `public var numbers: AsyncStream<Int> { _numbers }
/// `private let (_numbers, _numbersContinuation)`
/// `   = AsyncStream.makeStream(of: Int.self)`
/// 
@attached(member, names: arbitrary)
public macro CreateAsyncStream<T>(of: T, named: String)
       -> (AsyncStream<T>, AsyncStream<T>.Continuation)
= #externalMacro(module: "CreateAsyncStreamMacros",
                 type: "CreateAsyncStreamMacro")
