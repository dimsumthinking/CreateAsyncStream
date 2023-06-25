import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import CreateAsyncStreamMacros

let testMacros: [String: Macro.Type] = [
    "createAsyncStream": CreateAsyncStreamMacro.self,
]

final class CreateAsyncStreamTests: XCTestCase {
    func testMacro() {
        assertMacroExpansion(
            """
            @CreateAsyncStream(of: Int, named: "numbers")
            """,
            expandedSource: """
            public var numbers: AsyncStream<Int> { _numbers }
            private let (_numbers, _numbersContinuation)
               = AsyncStream.makeStream(of: Int.self)
            """,
            macros: testMacros
        )
    }


}
