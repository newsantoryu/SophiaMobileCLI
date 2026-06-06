# SophiaMobileCLI
# SophiaMobileCLI

Uma interface de linha de comando (CLI) assíncrona desenvolvida em **Swift 6 Core** rodando nativamente no **Linux**. O projeto atua como um agregador de telemetria em tempo real, consumindo microsserviços de IA em Python e gerenciando estados de navegação complexos direto no terminal.

---

## 🛠️ Arquitetura e Decisões Técnicas

Para viabilizar uma experiência de usuário fluida em ambiente de terminal sem o uso de bibliotecas pesadas de terceiros, o projeto foi estruturado sobre os seguintes pilares:

### 1. Entrada de Teclado Não-Bloqueante (Non-blocking I/O)
Loops tradicionais baseados em `readLine()` suspendem a execução da Thread principal até que o caractere `\n` (Enter) seja capturado. 
* **Solução:** Implementamos uma camada de baixo nível utilizando a API POSIX (`termios` e `poll`). O terminal é colocado temporariamente em modo *Raw*, permitindo escanear o buffer de entrada instantaneamente a cada ciclo do loop de renderização. **A alternância de telas ocorre imediatamente ao pressionar as teclas `1` ou `2`, sem necessidade de Enter.**

### 2. Gerenciamento de Estado e Navegação (Coordinator Pattern)
A navegação imita o comportamento de uma `NavigationStack` do SwiftUI, centralizada pelo enum `Screen`. O desacoplamento garante que o fluxo de telas permaneça previsível e isolado da lógica de consumo de dados.

### 3. Isolamento de Concorrência com Actors (`AudioAPIService`)
A comunicação HTTP com o backend Python utiliza o modelo de concorrência estruturada do Swift (`async/await`). O serviço foi isolado dentro de um `actor` para garantir a segurança de acesso aos dados (*Data Race Safety*), operando de forma assíncrona enquanto o loop principal gerencia a taxa de atualização da UI.

---

## 🚀 Como Executar o Ecossistema

### 1. Subir o Backend (Python)
Certifique-se de que o seu servidor Python está ativo na porta padrão do ecossistema:
```bash
cd ~/sophia-backend
# Ativa o ambiente virtual se necessário (source .venv/bin/activate)
uvicorn app.main:app --reload --port 8000
```

### 2. Executar o Client (Swift)
Em outro terminal, compile e inicialize a aplicação de telemetria:
```bash
cd ~/swift-lab
swift run
```

---

## ⚙️ Variáveis de Ambiente e Redes no Linux
O motor de rede nativo do Linux (`FoundationNetworking`) exige caminhos absolutos e estritos para o roteamento local. A URL configurada aponta explicitamente para o endereço de loopback com caractere de barra final (*Trailing Slash*):
```swift
private let apiURL = URL(string: "http://127.0.0")!
```
*Caso mude a porta do Uvicorn para `3000` ou `3030`, atualize a propriedade `apiURL` no arquivo `main.swift` antes de buildar.*

---

## 🗂️ Estrutura Principal do Projeto

* `Sources/SophiaMobileCLI/App/main.swift`: Orquestrador do loop assíncrono, captura POSIX de teclado e injeção de dependências.
* `Sources/SophiaMobileCLI/UI/Screens/HistoryView.swift`: Motor de renderização tabular para histórico em memória em formato de texto puro.
* `Sources/SophiaMobileCLI/Core/AppCoordinator.swift`: Enumerações de tela e pilha de transição de estado.