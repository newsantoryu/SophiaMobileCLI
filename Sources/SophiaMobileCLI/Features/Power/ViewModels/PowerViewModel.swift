import Foundation

@MainActor
final class PowerViewModel {
    private let powerService: PowerService
    var powerDomain: PowerModel?
    var errorDescription:String?
    
    init(powerService: PowerService) {
        self.powerService = powerService
    }
    
    func callPowerData() async  {
        do {
            let powerDomain = try await powerService.getPowerDomain()
            self.powerDomain = powerDomain  
        } catch {
            switch error {
                case .invalidResponse:
                    self.errorDescription = "Resposta invalida"
                case .networkError(let message): 
                    self.errorDescription = message
                case .decodingError(let message):
                    self.errorDescription = message
            }
        }
    }
}