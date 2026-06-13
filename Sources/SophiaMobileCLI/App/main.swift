import Foundation
import FoundationNetworking // OBRIGATÓRIO no Linux para usar o URLSession.shared

// MÓDULO AUXILIAR DE ENTRADA NÃO-BLOQUEANTE
func lerEntradaDoTeclado() -> String? {
    var raw = termios()
    tcgetattr(STDIN_FILENO, &raw)
    var current = raw
    current.c_lflag &= ~tcflag_t(ECHO | ICANON)
    tcsetattr(STDIN_FILENO, TCSANOW, &current)
    
    var fds = [pollfd(fd: STDIN_FILENO, events: Int16(POLLIN), revents: 0)]
    let ret = poll(&fds, 1, 0)
    
    var caractere: String? = nil
    if ret > 0 && (fds[0].revents & Int16(POLLIN)) != 0 {
        var buf = [UInt8](repeating: 0, count: 1)
        if read(STDIN_FILENO, &buf, 1) > 0 {
            caractere = String(bytes: buf, encoding: .utf8)
        }
    }
    
    tcsetattr(STDIN_FILENO, TCSANOW, &raw)
    return caractere
}
let apiClient = APIClient()
     print("""
        ╔══════════════════════════════╗
        ║      SOPHIA MOBILE CLI       ║
        ║          v0.1.0              ║
        ╚══════════════════════════════╝
        """)

//  LOOP DE ORQUESTRAÇÃO ASSÍNCRONA
let viewModel = AudioViewModel(audioService: AudioService(apiClient: apiClient))
let powerViewModel = PowerViewModel(powerService: PowerService(apiClient: apiClient))
let domainsViewModel = DomainsViewModel(domainsService: DomainsService(apiClient: apiClient))
let insightsViewModel: InsightsViewModel = InsightsViewModel(service: InsightsServices(apiClient: apiClient))
var listaHistorico: [AudioMonitorModel] = []
var telaAtualAtiva: Screen = .liveMonitor // Usa o tipo original definido em AppCoordinator.swift

print("Iniciando conexão com a API de telemetria...")

while true {
    async let audio =  viewModel.callAudioEndpoint()
    async let power = powerViewModel.callPowerData()
    async let domain =  domainsViewModel.callDomainsEndpoint()
    async let insight = insightsViewModel.callInsightRequest()

   _ = await (audio, power, domain, insight)

    if let audioDomainData = viewModel.audioDomain {
        listaHistorico.append(audioDomainData)
          if listaHistorico.count > 10 {
             listaHistorico.removeFirst()
       }
    }
    
    
    if let tecla = lerEntradaDoTeclado() {
        if tecla == "2" {
            telaAtualAtiva = .history
        } else if tecla == "1" {
            telaAtualAtiva = .liveMonitor
        } else if tecla == "3" {
            telaAtualAtiva = .power
        } else if tecla == "4" {
            telaAtualAtiva = .domains
        } else if tecla == "q" {
            telaAtualAtiva = .insights
        }
    }
    
    switch telaAtualAtiva {
    case .liveMonitor:
    if let audioDomainData = viewModel.audioDomain {
        let telaMonitor = AudioMonitorView(dados: audioDomainData)
        Preview.show(telaMonitor)
        print("\n[Pressione '2' (sem ENTER) para ir para o Histórico]")
    }   
    case .history:
    let telaHistorico = HistoryVuew(historyList: listaHistorico)
        Preview.show(telaHistorico)
        print("\n[Pressione '1' (sem ENTER) para voltar ao Monitoramento]")
    case .power:
    if let powerDomainData = powerViewModel.powerDomain {
        let screenPower = PowerView(powerData: powerDomainData)
        Preview.show(screenPower)
        print("\n[Pressione '3' (sem ENTER) para ir ao POWER]")
    }
    case .domains:
    if let domainsData = domainsViewModel.domainsData {
        let screenDomains = DomainsView(domainsData: domainsData)
        Preview.show(screenDomains)
        print("\n[Pressione '4' (sem ENTER) para ir ao Domains]")
    }
    case .insights:
    if let insightData = insightsViewModel.insight {
        let screenInsights: InsightsView = InsightsView(insightData: insightData)
        Preview.show(screenInsights)
        print("\n[Pressione 'q' (sem ENTER) para ir ao Insights]")
    }
    }
        
    try? await Task.sleep(nanoseconds: 3_000_000_000)
}
