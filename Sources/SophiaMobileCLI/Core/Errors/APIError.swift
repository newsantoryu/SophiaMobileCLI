import Foundation

enum APIError: Error, CustomStringConvertible {
    case invalidResponse
    case networkError(String)
    case decodingError(String)

    var description: String {
        switch self {
        case .invalidResponse:
            return "Resposta inválida da API."
        case .networkError(let message):
            return "Erro de rede: \(message)"
        case .decodingError(let message):
            return "Erro de decodificação: \(message)"
        }
    }
}