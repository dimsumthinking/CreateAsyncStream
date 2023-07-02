public enum CreateAsyncStreamError: Error {
  case mustBeAppliedToClassStructOrActor
  case mustHaveTwoArguments(numberOfArguments: Int)
  case incorrectFirstArgument
  case incorrectSecondArgument
}

extension CreateAsyncStreamError: CustomStringConvertible {
  public var description: String {
    switch self {
    case .mustBeAppliedToClassStructOrActor:
      "@CreateAsyncStream is a member macro that must be applied to a class, struct, or actor"
    case .mustHaveTwoArguments(let args):
      "@CreateAsyncMacro requires two arguments not \(args)"
    case .incorrectFirstArgument:
      "@CreateAsyncStream's first argument must be a Type with label 'of:'"
    case .incorrectSecondArgument:
      "@CreateAsyncStream's second argument must be a String with label 'named:'"
    }
  }
}
