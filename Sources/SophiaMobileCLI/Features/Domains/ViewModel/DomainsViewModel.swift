import Foundation

@MainActor
final class DomainsViewModel: Sendable {
    let domainsService: DomainsService
    var domainsData: [DomainsModel]?
    var errorDescription: String?

    init(domainsService: DomainsService) {
        self.domainsService = domainsService        

    }

    func callDomainsEndpoint() async {
        errorDescription = nil
        domainsData = nil
        do {
            let data = try await domainsService.requestDomainsData()
            self.domainsData = data
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