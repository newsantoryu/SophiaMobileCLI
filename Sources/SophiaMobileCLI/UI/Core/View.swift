import Foundation

protocol View: Sendable {
    func render() -> String
}

struct Preview {
    static func show(_ view: View) {
        print("\u{001B}[2J\u{001B}[;H") 
        print(view.render())
        print("\n[Pressione Ctrl+C para encerrar o monitoramento]")
    }
}
