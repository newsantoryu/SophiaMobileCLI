import Foundation

final class AudioService:AudioServicing {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getAudioDomain()async throws(APIError) -> AudioMonitorModel {
        do {
            let audio = try await apiClient.request(endpoint: "/cognition/audio", type: AudioMonitorModel.self)
            return audio
        } catch let error as APIError {
            throw error
        } catch let errorDecoding as DecodingError {
            throw APIError.decodingError("User error: \(APIError.decodingError(String()))  - Swift Error: \(errorDecoding.localizedDescription)")
        } catch  {
            throw APIError.networkError(error.localizedDescription)
        }
    }
}

