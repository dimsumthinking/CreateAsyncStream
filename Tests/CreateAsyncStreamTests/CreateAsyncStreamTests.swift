import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import CreateAsyncStreamMacros

final class CreateAsyncStreamTests: XCTestCase {
  func testMacro() {
    assertMacroExpansion(
            """
            @CreateAsyncStream(of: Int.self, named: "numbers")
            class MyClass {
            }
            """,
            expandedSource: """
            class MyClass {
                public var numbers: AsyncStream<Int> {
                    _numbers
                }
                private let (_numbers, numbersContinuation) = AsyncStream.makeStream(of: Int.self)
            }
            """,
            macros: ["CreateAsyncStream": CreateAsyncStreamMacro.self]
    )
  }
}
