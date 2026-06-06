import Foundation
import FoundationNetworking // OBRIGATÓRIO no Linux para usar o URLSession.shared

// 1. CONTRATO
struct AudioMonitorContrato: Codable, Sendable {
    let domain: String
    let status: String
    let noiseFloor: Int
    let currentLevel: Int
    let classification: String
    let confidence: Double
    let timestamp: String

    enum CodingKeys: String, CodingKey {
        case domain, status, classification, confidence, timestamp
        case noiseFloor = "noise_floor"
        case currentLevel = "current_level"
    }
}

// 2. SERVIÇO (ASYNC ACTOR)
actor AudioAPIService {
   private let apiURL = URL(string:"http://127.0.0.1:8000/cognition/audio/")!

    func buscarTelemetriaEmTempoReal() async -> AudioMonitorContrato {
        do {
            let (data, response) = try await URLSession.shared.data(from: apiURL)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Resposta inválida da API: \(response)")
                return gerarDadosDeFallback(erro: "Resposta inválida (status code não 200)")
            }
            let decoder = JSONDecoder()
            let contract = try decoder.decode(AudioMonitorContrato.self, from: data)
            return contract
        } catch {
            print("Erro ao buscar dados da API: \(error)")
            return gerarDadosDeFallback(erro: error.localizedDescription)
        }
    }

    private func gerarDadosDeFallback(erro: String) -> AudioMonitorContrato {
        let dataString = ISO8601DateFormatter().string(from: Date())
        return AudioMonitorContrato(
            domain: "audio",
            status: "ERRO DE CONEXÃO",
            noiseFloor: 0,
            currentLevel: 0,
            classification: "Desconectado (\(erro))",
            confidence: 0.0,
            timestamp: dataString
        )
    }
}

// 3. MÓDULO AUXILIAR DE ENTRADA NÃO-BLOQUEANTE
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

// 4. LOOP DE ORQUESTRAÇÃO ASSÍNCRONA
let api = AudioAPIService()
var listaHistorico: [AudioMonitorContrato] = []
var telaAtualAtiva: Screen = .liveMonitor // Usa o tipo original definido em AppCoordinator.swift

print("Iniciando conexão com a API de telemetria...")

while true {
    let novosDados = await api.buscarTelemetriaEmTempoReal()
    
    listaHistorico.append(novosDados)
    if listaHistorico.count > 10 {
        listaHistorico.removeFirst()
    }
    
    if let tecla = lerEntradaDoTeclado() {
        if tecla == "2" {
            telaAtualAtiva = .history
        } else if tecla == "1" {
            telaAtualAtiva = .liveMonitor
        }
    }
    
    switch telaAtualAtiva {
    case .liveMonitor:
        let telaMonitor = AudioMonitorView(dados: novosDados)
        Preview.show(telaMonitor)
        print("\n[Pressione '2' (sem ENTER) para ir para o Histórico]")
        
    case .history:
        let telaHistorico = HistoryVuew(historyList: listaHistorico)
        Preview.show(telaHistorico)
        print("\n[Pressione '1' (sem ENTER) para voltar ao Monitoramento]")
    }
    
    try? await Task.sleep(nanoseconds: 1_000_000_000)
}
