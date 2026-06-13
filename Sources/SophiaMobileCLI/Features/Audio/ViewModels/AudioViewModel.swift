import Foundation

@MainActor
final class AudioViewModel {
    private let audioService: AudioService
    public var audioDomain: AudioMonitorModel?
    
    init(audioService: AudioService) {
        self.audioService = audioService
    }

    func callAudioEndpoint() async {
        do {
            let audioDomain = try await audioService.getAudioDomain()
            print("Audio Domain: \(audioDomain)")
            self.audioDomain = audioDomain  
        } catch {
            print("Error fetching audio domain: \(error)")
        }
    }

}