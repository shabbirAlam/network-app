//
//  SearchView.swift
//  NetworkApp
//
//  Created by Md Shabbir Alam on 18/02/26.
//

import SwiftUI

struct SearchView: View {
    @StateObject var vm = SearchViewModel(networking: NetworkService())
    
    var body: some View {
        VStack(spacing: 0) {
            TextField("Search...", text: $vm.searchedText)
                .padding(.horizontal, 16)
                .frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.horizontal)
            
            if let error = vm.errorMessage {
                Text(error)
                    .padding()
            } else if vm.data.isEmpty {
                Text("No data found")
                    .padding()
            } else {
                List(vm.data, id: \.id) { todo in
                    Text(todo.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                    
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .listRowSpacing(8)
                .padding(.top, 8)
            }
            
            Spacer()
        }
        .cornerRadius(16)
        .background(Color.cyan)
        .task(id: vm.searchedText) {
            await vm.fetchTodos()
        }
        .navigationTitle("Search")
    }
}

#Preview {
    let mock = MockNetworking()
    mock.setData([Todo(userID: 1, id: 1, title: "John", completed: true)])
    return SearchView(vm: SearchViewModel(networking: mock))
}
struct ContentView: View, Equatable {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Width: \(geometry.size.width)")
                Text("Height: \(geometry.size.height)")
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: geometry.size.width * 0.7, height: 100)
                // Other views that can adapt based on parent's size
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
    }
}
#Preview {
    ContentView()
        .equatable()
}
