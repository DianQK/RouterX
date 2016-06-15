import Foundation

public struct RoutingPatternScanner {
    private static let stopWordsSet: Set<Character> = ["(", ")", "/"]

    public let expression: String

    private(set) var position: String.Index

    public init(expression: String) {
        self.expression = expression
        self.position = self.expression.startIndex
    }

    public var isEOF: Bool {
        return self.position == self.expression.endIndex
    }

    private var unScannedFragment: String {
        return expression.substring(from: position)
    }

    public mutating func nextToken() -> RoutingPatternToken? {
        if self.isEOF {
            return nil
        }

        let firstChar = self.unScannedFragment.characters.first!

        self.position = self.unScannedFragment.index(after: self.position)//self.position.advancedBy(n: 1)

        switch firstChar {
        case "/":
            return .Slash
        case ".":
            return .Dot
        case "(":
            return .LParen
        case ")":
            return .RParen
        default:
            break
        }

        var fragment = ""
        var stepPosition = 0
        for char in self.unScannedFragment.characters {
            if RoutingPatternScanner.stopWordsSet.contains(char) {
                break
            }

            fragment.append(char)
            stepPosition += 1
        }

        self.position = self.unScannedFragment.index(self.position, offsetBy: stepPosition)//self.position.advancedBy(n: stepPosition)

        switch firstChar {
        case ":":
            return .Symbol(fragment)
        case "*":
            return .Star(fragment)
        default:
            return .Literal("\(firstChar)\(fragment)")
        }
    }

    public static func tokenize(expression: String) -> [RoutingPatternToken] {
        var scanner = RoutingPatternScanner(expression: expression)

        var tokens: [RoutingPatternToken] = []
        while let token = scanner.nextToken() {
            tokens.append(token)
        }

        return tokens
    }
}
