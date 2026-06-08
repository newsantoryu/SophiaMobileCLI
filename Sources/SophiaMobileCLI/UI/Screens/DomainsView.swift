import Foundation

struct DomainsView: View {
    let domainsData: [DomainsModel]?

    func render() -> String {
        
        guard let domainsData = domainsData else {
            return "Carregando dados dos domínios..."
        }
        
        var output = "=== Domínios ===\n"
        for domain in domainsData {
            output += "ID: \(domain.id)\n"
            output += "Nome: \(domain.name)\n"
            output += "Status: \(domain.status)\n"
            output += "Versão: \(domain.version)\n"
            output += "-------------------\n"
        }
        return output
    }
}