import Foundation

//Definição de Telas de Navegação
enum Screen: Sendable {
    case liveMonitor
    case history
}

//O Coordinator atua com o seu NavigationStack, (Trhead-safe via Actor) 
actor AppCoordinator {
    //Array  que simula a Pilha de Telas da NavigationStack
    private var navigationStack: [Screen] = [.liveMonitor] //Tela Inicial

    //Retorna a tela que está no topo da pilha para ser desenhada
    func currentScreen() -> Screen {
        return navigationStack.last ?? .liveMonitor
    }

    //Equivalente ao NavigationLink (Avança na pilha)
    func push(_ screen: Screen) {
        navigationStack.append(screen)
    }

    //Equivalente ao botão voltar nativo  da NavigationStack
    func pop() {
        if navigationStack.count > 1 {
            navigationStack.removeLast()
        }
    }

    //Limpa tudo e volta para a estaca zero
    func popToRoot() {
        navigationStack = [.liveMonitor]
    }


}