//
//  MockGraphQLNetworkServiceImpl.swift
//  NetworkApp
//
//  Created by Md Shabbir Alam on 19/04/26.
//

import Foundation

final class MockGraphQLNetworkServiceImpl: GraphQLNetworkService, Sendable {
    private var mockData: Data?
    private var mockError: Error?
    
    func fetch<T: Decodable>(query: String, variables: [String: AnyEncodable]? = nil) async throws -> T {
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
