import Foundation

final class AudioService:Sendable {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getAudioDomain()async throws -> AudioMonitorModel {
        try await apiClient.request(endpoint: "/cognition/audio", type: AudioMonitorModel.self)
    }
}

