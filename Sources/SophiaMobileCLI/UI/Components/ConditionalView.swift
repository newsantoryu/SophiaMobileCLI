import Foundation

struct ConditionalView: View {
    private let child: any View
    init(child: any View) { self.child = child }
    func render() -> String { child.render() }
}
