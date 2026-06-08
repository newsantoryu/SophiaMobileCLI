import Foundation

struct AudioMonitorView: View {
    let dados: AudioMonitorModel
    
    init(dados: AudioMonitorModel) {
        self.dados = dados
    }
    
    private var barraDeVolume: String {
        let totalBarras = 12
        let normalizado = max(0, min(totalBarras, (dados.currentLevel + 60) / 5))
        return "[" + String(repeating: "◼", count: normalizado) + String(repeating: "◻", count: totalBarras - normalizado) + "]"
    }

    func render() -> String {
        VStack([
            Text("🎙️ MONITOR DE SINAL DE ÁUDIO (LIVE)").bold().foregroundColor(.cyan),
            Divider(),
            HStack([
                Text("Status do Sistema: "),
                dados.status == "active" ? 
                    Text("ATIVO").bold().foregroundColor(.green) : 
                    Text("INATIVO").bold().foregroundColor(.red)
            ]),
            HStack([
                Text("Domínio de Captura: "),
                Text(dados.domain.uppercased()).foregroundColor(.gray)
            ]),
            Divider(),
            VStack([
                HStack([
                    Text("Nível de Entrada:  "),
                    Text("\(dados.currentLevel) dB ").bold(),
                    Text(barraDeVolume).foregroundColor(dados.currentLevel > -15 ? .red : .green)
                ]),
                HStack([
                    Text("Ruído de Fundo:   "),
                    Text("\(dados.noiseFloor) dB").foregroundColor(.gray)
                ])
            ]),
            Divider(),
            HStack([
                Text("Classificação:    "),
                Text(dados.classification.uppercased()).bold()
            ]),
            HStack([
                Text("Confiança do IA:  "),
                Text("\(Int(dados.confidence * 100))%").foregroundColor(.cyan)
            ]),
            Divider(),
            Text("Horário do Evento: \(dados.timestamp)").foregroundColor(.gray)
        ]).render()
    }
}
