import Foundation

@MainActor
final class AudioViewModel {
    private let audioService: AudioService
    public var audioDomain: AudioMonitorModel?
    var errorDescription:String?
    
    init(audioService: AudioService) {
        self.audioService = audioService
    }

    func callAudioEndpoint() async {
        self.audioDomain = nil
        self.errorDescription = nil
        do {
            let audioDomain = try await audioService.getAudioDomain()
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