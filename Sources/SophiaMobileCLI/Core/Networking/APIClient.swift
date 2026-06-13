import Foundation
import FoundationNetworking // OBRIGATÓRIO no Linux para usar o URLSession.shared

final class APIClient: APIClientProtocol {

    private let enviroment: Environment

    init(enviroment: Environment = .current) {
        self.enviroment = enviroment
    }

    func request<Response: Decodable>(endpoint: String, type: Response.Type) async throws -> Response {
        guard let url = URL(string: endpoint, relativeTo: enviroment.baseUrl ) else {
            throw APIError.invalidResponse
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        // Verificar se a resposta HTTP gerou o erro para ser tratado e modelado para view de acordo com seu problema
        if  !(200...299).contains(httpResponse.statusCode){
            if let errorModel = try? JSONDecoder().decode(FastApiError.self, from: data) {
                throw APIError.networkError(errorModel.detail)
            } else {
                throw APIError.networkError("Erro no Servidor: \(httpResponse.statusCode)")
            }
        }
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }

}