import Foundation

struct HistoryVuew: View {
    let historyList: [AudioMonitorModel]
    
    func render() -> String {
        var output = ""
        output += "=== Lista de Telemetrias Capturadas ===\n"
        output += "---------------------------------------\n"
        
        if historyList.isEmpty {
            output += "Nenhum evento capturado ainda.\n"
        } else {
            for monitor in historyList {
                let confidencePercent = Int(monitor.confidence * 100)
                output += "Evento às \(monitor.timestamp): \(monitor.classification.uppercased()) com confiança de \(confidencePercent)%\n"
                output += "---------------------------------------\n"
            }
        }
        
        return output
    }
}