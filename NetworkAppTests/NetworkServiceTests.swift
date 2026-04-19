//
//  NetworkServiceTests.swift
//  NetworkApp
//
//  Created by Md Shabbir Alam on 01/03/26.
//

import Foundation
import Testing
@testable import NetworkApp

private func makeMockSession() -> URLSession {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: config)
}

@MainActor
struct NetworkServiceTests {
    @Test
    func requestSuccess() async throws {
        
        let url = URL(string: "https://test1.com")!
        
        let mockUser = Todo(userID: 1, id: 1, title: "John", completed: true)
        let data = try JSONEncoder().encode(mockUser)
        
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        await MockURLProtocol.mockStore.set(data: data, response: response, for: url)
        
        let service = NetworkService(session: makeMockSession())
        
        let result: Todo = try await service.request(url)
        
        #expect(await result.userID == 1)
        #expect(await result.title == "John")
        
        await MockURLProtocol.mockStore.reset(for: url)
    }
    
    @Test
    func requestBadStatus() async {
        
        let url = URL(string: "https://test2.com")!
        
        let response = HTTPURLResponse(
            url: url,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil
        )!
        
        await MockURLProtocol.mockStore.set(
            data: Data(),
            response: response,
            for: url
        )
        
        let service = NetworkService(session: makeMockSession())
        
        do {
            let _: Todo = try await service.request(url)
            Issue.record("Expected failure, but succeeded")
        } catch let error as NetworkError {
            switch error {
                case .badStatusCode(let code):
                    #expect(code == 400)
                default:
                    Issue.record("Unexpected error type: \(error)")
            }
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
        
        await MockURLProtocol.mockStore.reset(for: url)
    }
    
    @Test
    func requestInvalidResponse() async {
        
        let url = URL(string: "https://test3.com")!
        
        let fakeResponse = URLResponse(
            url: url,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        
        await MockURLProtocol.mockStore.set(
            data: Data(),
            response: fakeResponse,
            for: url
        )
        
        let service = NetworkService(session: makeMockSession())
        
        do {
            let _: Todo = try await service.request(url)
            Issue.record("Expected failure, but succeeded")
        } catch let error as NetworkError {
            switch error {
                case .invalidResponse:
                    #expect(true)
                default:
                    Issue.record("Unexpected error type: \(error)")
            }
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
        await MockURLProtocol.mockStore.reset(for: url)
    }
}
