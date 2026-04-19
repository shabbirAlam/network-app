//
//  MockNetworking.swift
//  NetworkApp
//
//  Created by Md Shabbir Alam on 14/03/26.
//

import Foundation

final class MockNetworking: NetworkService, Sendable {
    private var mockData: Data?
    private var mockError: Error?
    
    func request<T>(_ url: URL) async throws -> T where T : Decodable {
        if let mockError {
            throw mockError
        }
        
        if let mockData {
            let data = try JSONDecoder().decode(T.self, from: mockData)
            return data
        }
        throw URLError(.unknown)
    }
    
    func setData<T: Encodable>(_ data: T) {
        mockData = try? JSONEncoder().encode(data)
    }
    
    func setError(_ error: Error) {
        mockError = error
    }
}
