import Foundation

enum TerminalColor: String, Sendable {
    case green = "\u{001B}[32m"
    case red = "\u{001B}[31m"
    case gray = "\u{001B}[90m"
    case cyan = "\u{001B}[36m"
}

struct Text: View {
    private let content: String
    private var isBold: Bool = false
    private var colorCode: String = ""

    init(_ content: String) { self.content = content }

    func bold() -> Text {
        var copy = self
        copy.isBold = true
        return copy
    }

    func foregroundColor(_ color: TerminalColor) -> Text {
        var copy = self
        copy.colorCode = color.rawValue
        return copy
    }

    func render() -> String {
        let textBold = isBold ? "\u{001B}[1m\(content)\u{001B}[22m" : content
        if !colorCode.isEmpty {
            return "\(colorCode)\(textBold)\u{001B}[0m"
        }
        return textBold
    }
}
