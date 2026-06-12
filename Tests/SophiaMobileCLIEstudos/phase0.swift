import Testing
@testable import SophiaMobileCLI

func callRequest()async throws  -> String {

    print("6 - iniciando call request")

    try? await Task.sleep(for: .seconds(2))

    print("7 - finalizado")
    return "Sophia"
}

@Test func firstTestBuild() async throws {
    
    print("1 - Iniciando o audio hahahah")

    try? await Task.sleep(for: .seconds(2))

    print("2 - Audio finalizado")
    
    #expect(true)
}

@Test func main() async throws {
    print("3 - ANTES - fake main")

    let result = try await firstTestBuild()
    
    print("4 - Resultado: ", result)

    print("5 - DEPOIS, fim do main")
    let nameResult = try await callRequest()
    print(nameResult)
    #expect(true)
}
