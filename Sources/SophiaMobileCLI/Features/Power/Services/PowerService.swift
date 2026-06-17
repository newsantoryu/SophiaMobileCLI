import Foundation

final class PowerService:PowerServicing {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getPowerDomain() async throws(APIError) -> PowerModel {
        do {
            let powerData = try await apiClient.request(endpoint: "/cognition/power", method: .get, type: PowerModel.self)
            return powerData
        } catch let error as APIError {
            throw error
        } catch let errorDecode as DecodingError {
            throw APIError.decodingError("User Error: \(APIError.decodingError(String())) - Swift Error: \(errorDecode.localizedDescription)")
        } catch {
            throw APIError.networkError(error.localizedDescription)
        }

    }

}