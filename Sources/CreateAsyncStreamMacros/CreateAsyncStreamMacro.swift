import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

import Foundation


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
///
public struct CreateAsyncStreamMacro: MemberMacro {
  public static func expansion(of node: AttributeSyntax,
                               providingMembersOf declaration: some DeclGroupSyntax,
                               in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    guard let arguments = Syntax(node.argument)?.children(viewMode: .sourceAccurate),
          let typeArgument = arguments.first,
          let nameArgument = arguments.dropFirst().first
    else {
      fatalError("who knows what happened")
    }
    let type = typeArgument.description
      .replacingOccurrences(of: "of: ", with: "")
      .replacingOccurrences(of: ", ", with: "")
    let name = nameArgument.description
      .replacingOccurrences(of: "named:", with: "")
      .replacingOccurrences(of: "\"", with: "")
      .trimmingCharacters(in: .whitespacesAndNewlines)

    return [
      "public var \(raw: name): AsyncStream<\(raw: type)> { _\(raw: name)}",
      "private let (_\(raw: name), _\(raw: name)Continuation) = AsyncStream.makeStream(of: \(raw: type).self)"
    ]
  }
  
  

}


@main
struct CreateAsyncStreamPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        CreateAsyncStreamMacro.self,
    ]
}


