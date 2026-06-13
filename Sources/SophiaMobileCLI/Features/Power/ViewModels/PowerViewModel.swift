import Foundation

@MainActor
final class PowerViewModel {
    private let powerService: PowerService
    var powerDomain: PowerModel?
    
    init(powerService: PowerService) {
        self.powerService = powerService
    }
    
    func callPowerData() async  {
        do {
            let powerDomain = try await powerService.getPowerDomain()
            print("Power Domain: \(powerDomain)")
            self.powerDomain = powerDomain  
        } catch {
            print("Error fetching power domain: \(error)")
        }
    }
}