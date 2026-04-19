//
//  NetworkService.swift
//  NetworkApp
//
//  Created by Md Shabbir Alam on 18/02/26.
//

import Foundation

protocol NetworkService: Sendable {
    func request<T: Decodable>(_ url: URL) async throws -> T
}

enum NetworkError: Error {
    case invalidResponse
    case badStatusCode(Int)
}

final class NetworkServiceImpl: NetworkService, Sendable {
    
    private let session: URLSession
    private static let decoder = JSONDecoder()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ url: URL) async throws -> T {
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.badStatusCode(httpResponse.statusCode)
        }
        #if DEBUG
        print(String(data: data, encoding: .utf8)!)
        #endif
        return try Self.decoder.decode(T.self, from: data)
    }
    
    let url = URL(string: "https://countries.trevorblades.com/")!
    
    func fetch<T: Decodable>(
        query: String,
        variables: [String: AnyEncodable]? = nil
    ) async throws -> T {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = GraphQLRequest(query: query, variables: variables)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(GraphQLResponse<T>.self, from: data).data
    }
}
