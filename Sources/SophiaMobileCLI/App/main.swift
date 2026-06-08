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

     print("""
        ╔══════════════════════════════╗
        ║      SOPHIA MOBILE CLI       ║
        ║          v0.1.0              ║
        ╚══════════════════════════════╝
        """)

//  LOOP DE ORQUESTRAÇÃO ASSÍNCRONA
let viewModel = AudioViewModel(audioService: AudioService(apiClient: APIClient()))
let powerViewModel = PowerViewModel(powerService: PowerService(apiClient: APIClient()))
var listaHistorico: [AudioMonitorModel] = []
var telaAtualAtiva: Screen = .liveMonitor // Usa o tipo original definido em AppCoordinator.swift

print("Iniciando conexão com a API de telemetria...")

while true {
    await viewModel.callAudioEndpoint()
    await powerViewModel.callPowerData()
    let audioDomainData = viewModel.audioDomain
    guard let audioDomainData = audioDomainData else {
        continue
    }
    guard let powerDomainData = powerViewModel.powerDomain else {
        continue
    }

    listaHistorico.append(audioDomainData)
    if listaHistorico.count > 10 {
        listaHistorico.removeFirst()
    }
    
    if let tecla = lerEntradaDoTeclado() {
        if tecla == "2" {
            telaAtualAtiva = .history
        } else if tecla == "1" {
            telaAtualAtiva = .liveMonitor
        } else if tecla == "3" {
            telaAtualAtiva = .power
        }
    }
    
    switch telaAtualAtiva {
    case .liveMonitor:
        let telaMonitor = AudioMonitorView(dados: audioDomainData)
        Preview.show(telaMonitor)
        print("\n[Pressione '2' (sem ENTER) para ir para o Histórico]")     
    case .history:
        let telaHistorico = HistoryVuew(historyList: listaHistorico)
        Preview.show(telaHistorico)
        print("\n[Pressione '1' (sem ENTER) para voltar ao Monitoramento]")
    case .power:
    let screenPower = PowerView(powerData: powerDomainData)
        Preview.show(screenPower)
        print("\n[Pressione '3' (sem ENTER) para ir ao POWER]")
    }
        
    try? await Task.sleep(nanoseconds: 1_000_000_000)
}
