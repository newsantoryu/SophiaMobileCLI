import Foundation

protocol AudioServicing: Sendable {
    func getAudioDomain()async throws(APIError) -> AudioMonitorModel 
}