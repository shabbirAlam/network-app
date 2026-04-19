//
//  SearchService.swift
//  NetworkApp
//
//  Created by Md Shabbir Alam on 28/02/26.
//

import Foundation

final class SearchService {
    private let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func fetchTodos() async throws -> [Todo] {
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
            try Task.checkCancellation()
            return try await networking.request(URL(string: "https://jsonplaceholder.typicode.com/todos")!)
        } catch is CancellationError {
            return []
        } catch {
            throw error
        }
    }
}
