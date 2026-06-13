import Foundation

struct AlertView: View {
    let message: String
    func render() -> String { VStack([Text(message).bold().foregroundColor(.red)]).render() }
}