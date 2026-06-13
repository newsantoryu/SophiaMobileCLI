import Foundation

@MainActor
final class DomainsViewModel{
    let domainsService: DomainsService
    var domainsData: [DomainsModel]?

    init(domainsService: DomainsService) {
        self.domainsService = domainsService        

    }

    func callDomainsEndpoint() async {
        do {
            let data = try await domainsService.requestDomainsData()
            self.domainsData = data
        } catch {
            print("Erro ao buscar dados dos domínios: \(error)")
        }
    }


}