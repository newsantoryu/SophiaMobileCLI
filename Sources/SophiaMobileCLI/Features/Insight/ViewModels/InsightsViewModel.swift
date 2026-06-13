import Foundation

@MainActor
final class InsightsViewModel {
    let service:InsightsServices
    var insight: InsightModel?
    var errorDescription: String?

    init(service: InsightsServices) {
        self.service = service
    }

    func callInsightRequest()async {
        errorDescription = nil
        insight = nil
       do {
            let model = try await service.requestInsights()
            self.insight = model
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