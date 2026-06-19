import Testing

@testable import SophiaMobileCLI

/*
AudioService
    ↓
chama APIClient
    ↓
recebe AudioMonitorModel
    ↓
retorna corretamente
*/
@Test func returnsAudioModelWhenApiRespondsSuccessfully() async throws
 {
    
    //ARRANGE
        let expected = AudioMonitorModel(
        domain: "Audio Domain", 
        status: "live", 
        noiseFloor: 2, 
        currentLevel: 1, 
        classification: "light", 
        confidence: 6.5, 
        timestamp: "12:22:312312"
        )

        let apiClientMock = ApiClientMock(result: .success(expected))
        let sut = AudioService(apiClient: apiClientMock)

    //ACT
    let result = try await sut.getAudioDomain()
    
    //ASSERT
    #expect(result == expected)
}

@Test func throwsNetworkErrorWhenApiFails() async throws {
    
    //ARRANGE
    let errorMock = APIError.networkError("TEM ALGUM PROBLEMA COM A CONEXÃO DE INTERNET") 
    let apiClientMock = ApiClientMock(result: .failure(errorMock))
    let sut = AudioService(apiClient: apiClientMock)

    //ACT
    do {
        _ = try await sut.getAudioDomain()
        Issue.record("Expected APIError.networkError to be thrown")

    //ASSERT
    } catch let error  {
        #expect(error == errorMock)
    }
}

@Test func throwsInvalidResponseWhenApiReturnsInvalidResponse() async throws {
    
    //ARRANGE
    let errorMock = APIError.invalidResponse
    let apiClientMock = ApiClientMock(result: .failure(errorMock))
    let sut = AudioService(apiClient: apiClientMock)

    //ACT
    do {
       _ = try await sut.getAudioDomain()
       Issue.record(
            "Esperava APIError.invalidResponse mas nenhum erro foi lançado"
        )
    //ASSERT   
    } catch let error {
        #expect(error == errorMock)
    }
}

    @Test func translatesDecodingErrorToAPIError() async throws {
        
        //ARRANGE
        let decodingError = DecodingError.typeMismatch(String.self, .init(codingPath: [], debugDescription: "Erro de decodificação: \n Os dados recebidos do servidor estão incompletos ou incompatíveis"))
        let apiClientMock = ApiClientMock(result: .failure(decodingError))
        let sut = AudioService(apiClient: apiClientMock)

        //ACT
        do {
            _ = try await sut.getAudioDomain()
            Issue.record(
                "Esperava APIError.invalidResponse mas nenhum erro foi lançado"
            )
        } catch let error     {
            switch error {
                case .decodingError(let message):
                    #expect(message.contains(ErrorMessages.decodingError))
                default:
                    Issue.record(
                        "Esperava APIError.decoding mas nenhum erro foi lançado"
                    )
            }
        }
    }