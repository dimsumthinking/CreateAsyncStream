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
    guard declaration.is(ClassDeclSyntax.self) else {
      throw Error.canOnlyBeAppliedToClass
    }
    guard case .argumentList(let argumentList) = node.argument else {
      fatalError("Macro attribute has no arguments. Macro declaration must be wrong.")
    }
    guard let typeArgument = argumentList.first(where: { $0.label?.text == "of" }),
          let nameArgument = argumentList.first(where: { $0.label?.text == "named" })
    else {
      fatalError("Macro attribute doesn't have expected arguments. Macro declaration must be wrong.")
    }
    let type = typeArgument.expression
    guard let typeWithSelf = type.as(MemberAccessExprSyntax.self),
          typeWithSelf.name.text == "self",
          let t = typeWithSelf.base
    else {
      throw Error.typeDoesntEndWithDotSelf
    }
    guard let nameLiteral = nameArgument.expression.as(StringLiteralExprSyntax.self),
          let name = nameLiteral.representedLiteralValue
    else {
      throw Error.nameMustBeALiteral
    }

    return [
      "public var \(raw: name): AsyncStream<\(raw: t)> { _\(raw: name)}",
      "private let (_\(raw: name), \(raw: name)Continuation) = AsyncStream.makeStream(of: \(raw: type))"
    ]
  }
}

enum Error: Swift.Error, CustomStringConvertible {
  case canOnlyBeAppliedToClass
  case typeDoesntEndWithDotSelf
  case nameMustBeALiteral

  var description: String {
    switch self {
    case .canOnlyBeAppliedToClass: "Macro can only be applied to a class"
    case .typeDoesntEndWithDotSelf: "Cannot parse argument 'of'. Must be a type, ending in '.self'"
    case .nameMustBeALiteral: "Argument 'named' must be a string literal"
    }
  }
}

@main
struct CreateAsyncStreamPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        CreateAsyncStreamMacro.self,
    ]
}


