import Foundation

final class InsightsViewModel {
    let service:InsightsServices
    var insight: InsightModel?

    init(service: InsightsServices) {
        self.service = service
    }

    func callInsightRequest()async {
       do {
        let model = try await service.requestInsights()
        self.insight = model
       } catch {
            print("Gerou erro ao mostrar insight")
       }

    }

    
}