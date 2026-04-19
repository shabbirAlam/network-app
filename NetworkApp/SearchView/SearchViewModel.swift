//
//  SearchViewModel.swift
//  NetworkApp
//
//  Created by Md Shabbir Alam on 18/02/26.
//

import Combine
import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var data: [Todo] = []
    @Published var searchedText = ""
    @Published var errorMessage: String?
    
    let service: SearchService
    
    init(networking: NetworkService) {
        service = SearchService(networking: networking)
    }
    
    func fetchTodos() async {
        do {
            let query = searchedText.lowercased()
            let data = try await service.fetchTodos()
            self.data = data.filter({ $0.title.lowercased().contains(query)})
            errorMessage = nil
        } catch {
            self.data = []
            errorMessage = error.localizedDescription
        }
    }
}
