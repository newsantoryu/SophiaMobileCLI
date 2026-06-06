import Foundation

struct VStack: View {
    private let children: [View]
    init(_ children: [View]) { self.children = children }
    
    func render() -> String {
        children.map { $0.render() }.joined(separator: "\n")
    }
}

struct HStack: View {
    private let children: [View]
    init(_ children: [View]) { self.children = children }
    
    func render() -> String {
        children.map { $0.render() }.joined(separator: "")
    }
}

struct Divider: View {
    init() {}
    func render() -> String { String(repeating: "─", count: 45) }
}
