import Foundation

struct Environment {
    let baseUrl: URL

    static let current = Environment(baseUrl: URL(string: "http://127.0.0.1:8001")!)

}