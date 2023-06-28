import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import CreateAsyncStreamMacros

let testMacros: [String: Macro.Type] = [
  "CreateAsyncStream": CreateAsyncStreamMacro.self,
]

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
      macros: testMacros
    )
  }

  func testWithStruct() {
    assertMacroExpansion(
      """
      @CreateAsyncStream(of: Int.self, named: "numbers")
      struct MyStruct {
      }
      """,
      expandedSource: """
      struct MyStruct {
      }
      """,
      diagnostics: [
        DiagnosticSpec(message: "Macro can only be applied to a class", line: 1, column: 1)
      ],
      macros: testMacros
    )
  }

  func testWithNonLiteralStringArgument() {
    assertMacroExpansion(
      """
      @CreateAsyncStream(of: Int.self, named: "num" + "bers")
      class MyStruct {
      }
      """,
      expandedSource: """
      class MyStruct {
      }
      """,
      diagnostics: [
        DiagnosticSpec(message: "Argument 'named' must be a string literal", line: 1, column: 1)
      ],
      macros: testMacros
    )
  }

  func testWithNonLiteralTypeArgument() {
    assertMacroExpansion(
      """
      let int = Int.self
      @CreateAsyncStream(of: int, named: "numbers")
      class MyStruct {
      }
      """,
      expandedSource: """
      let int = Int.self
      class MyStruct {
      }
      """,
      diagnostics: [
        DiagnosticSpec(message: "Cannot parse argument 'of'. Must be a type, ending in '.self'", line: 2, column: 1)
      ],
      macros: testMacros
    )
  }

}
