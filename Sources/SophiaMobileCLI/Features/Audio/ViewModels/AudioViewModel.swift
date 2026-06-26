import Foundation

@MainActor
final class AudioViewModel {
    private let service: AudioServicing
    public var audioDomain: AudioMonitorModel?
    var errorDescription:String?
    
    init(service: AudioServicing) {
        self.service = service
    }

    func callAudioEndpoint() async {
        self.audioDomain = nil
        self.errorDescription = nil
        do {
            let audioDomain = try await service.getAudioDomain()
            self.audioDomain = audioDomain  
        } catch {
            switch error {
                case .decodingError(let message):
                    self.errorDescription = message
                case .networkError(let message):
                    self.errorDescription = message
                case .invalidResponse:
                    self.errorDescription = "REsposta invalida"
            }
        }
    }

}