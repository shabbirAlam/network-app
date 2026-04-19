//
//  SearchViewModelTest.swift
//  NetworkAppTests
//
//  Created by Md Shabbir Alam on 28/02/26.
//

import Testing
@testable import NetworkApp
import Foundation

@MainActor
struct SearchViewModelTest {
    @Test func searchViewModelData() async {
        let mock = MockNetworking()
        let mockData = [Todo(userID: 1, id: 1, title: "John", completed: true)]
        mock.setData(mockData)
        let vm = SearchViewModel(networking: mock)
        
        vm.searchedText = "j"
        await vm.fetchTodos()
        #expect(!vm.data.isEmpty)
        #expect(vm.data[0].title == "John")
        #expect(vm.errorMessage == nil)
        
        vm.searchedText = ""
        await vm.fetchTodos()
        #expect(vm.data.isEmpty)
        #expect(vm.errorMessage == nil)
    }
    
    @Test func searchViewModelError() async {
        let mock = MockNetworking()
        mock.setError(NetworkError.invalidResponse)
        let vm = SearchViewModel(networking: mock)
        
        vm.searchedText = "j"
        await vm.fetchTodos()
        #expect(vm.data.isEmpty)
        #expect(vm.errorMessage != nil)
        
        vm.searchedText = ""
        await vm.fetchTodos()
        #expect(vm.data.isEmpty)
        #expect(vm.errorMessage != nil)
    }

    @Test func searchCancelsPreviousRequest() async {
        let mock = MockNetworking()
        mock.setData([
            Todo(userID: 1, id: 1, title: "john", completed: true)
        ])
        
        let vm = SearchViewModel(networking: mock)
        
        let firstTask = Task {
            vm.searchedText = "j"
            await vm.fetchTodos()
        }
        
        firstTask.cancel()
        
        let secondTask = Task {
            vm.searchedText = "jo"
            await vm.fetchTodos()
        }
        
        await secondTask.value
        
        #expect(vm.data.count == 1)
    }
}
