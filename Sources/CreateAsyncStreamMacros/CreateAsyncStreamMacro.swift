import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

import Foundation


/// This macro adds a public async stream of a given type and a private continuation
///  to a class
///
///     `@CreateAsyncStream(of: Int.self, named: "numbers")`
///
/// adds the following members to the class:
/// `public var numbers: AsyncStream<Int> { _numbers }
/// `private let (_numbers, numbersContinuation)`
/// `   = AsyncStream.makeStream(of: Int.self)`
///
///
public struct CreateAsyncStreamMacro: MemberMacro {
  public static func expansion(of node: AttributeSyntax,
                               providingMembersOf declaration: some DeclGroupSyntax,
                               in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    let arguments = try Self.arguments(from: node)
    let type = try Self.type(from: arguments[0])
    let name = try Self.name(from: arguments[1])
    return [
      "public var \(raw: name): AsyncStream<\(raw: type)> { _\(raw: name) }",
      "private let (_\(raw: name), \(raw: name)Continuation) = AsyncStream.makeStream(of: \(raw: type).self)"
    ]
  }
}

extension CreateAsyncStreamMacro {
  static private func arguments(from node: AttributeSyntax) throws -> [TupleExprElementSyntax] {
    guard let arguments = Syntax(node.argument)?
      .children(viewMode: .sourceAccurate)
      .compactMap({$0.as(TupleExprElementSyntax.self)}),
    arguments.count == 2 else {
      fatalError("The macro should take two arguments")
    }
    return arguments
  }
}

extension CreateAsyncStreamMacro {
  static private func type(from attribute: TupleExprElementSyntax) throws -> ExprSyntax {
    guard let type = attribute
      .expression
      .as(MemberAccessExprSyntax.self)?
      .base else {
      fatalError("The first argument should be a type")
    }
    return type
  }
}

extension CreateAsyncStreamMacro {
  static private func name(from attribute: TupleExprElementSyntax) throws -> String {
    guard let name = attribute
      .expression
      .as(StringLiteralExprSyntax.self)?
      .representedLiteralValue else {
      fatalError("The second argument should be a String")
    }
    return name
  }
}

@main
struct CreateAsyncStreamPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        CreateAsyncStreamMacro.self,
    ]
}


