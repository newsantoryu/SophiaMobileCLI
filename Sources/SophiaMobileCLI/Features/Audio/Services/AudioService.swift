import Foundation

final class AudioService {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getAudioDomain()async throws -> AudioMonitorContrato {
        try await apiClient.request(endpoint: "/cognition/audio", type: AudioMonitorContrato.self)
    }
}

