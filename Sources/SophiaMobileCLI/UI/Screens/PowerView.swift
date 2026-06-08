import Foundation

struct PowerView: View {
    let powerData: PowerModel

    init(powerData: PowerModel) {
        self.powerData = powerData
    }

    func render() -> String {
        VStack([
            Text("Power").bold().foregroundColor(.green),
            Divider(),
            Text("Status: \(powerData.status)"),
            Divider(),
            Text("Domain: \(powerData.domain)"),
            Divider(),
            Text("PC Online: \(powerData.pc_online ? "Sim" : "Não")"),
            Text("Power State: \(powerData.power_state)"),
            Text("Smart Plug Connected: \(powerData.smart_plug_connected ? "Sim" : "Não")"),
            Text("Automation Enabled: \(powerData.automation_enabled ? "Sim" : "Não")"),
            Text("Confidence: \(powerData.confidence)"),

        ]).render()
    }
}