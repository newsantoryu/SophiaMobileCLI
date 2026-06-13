import Foundation 

struct ErrorView: View {
    let errorDescription: String
    let screenName: String
    func render() -> String { 
        return "Screen \(screenName) Error: \(errorDescription)"
    }
}