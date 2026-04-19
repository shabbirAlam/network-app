//
//  CountryView.swift
//  NetworkApp
//
//  Created by Md Shabbir Alam on 19/04/26.
//

import SwiftUI

struct CountryView: View {
    @StateObject var vm = CountryViewModel(networking: GraphQLNetworkServiceImpl())
    
    var body: some View {
        VStack(spacing: 0) {
            TextField("Country...", text: $vm.searchedText)
                .padding(.horizontal, 16)
                .frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.horizontal)
                .onChange(of: vm.searchedText) { _ in
                    vm.filterCountries()
                }
            
            if let error = vm.errorMessage {
                Text(error)
                    .padding()
            } else if vm.countries.isEmpty {
                Text("No data found")
                    .padding()
            } else {
                List(vm.countries, id: \.self) { country in
                    VStack {
                        Text(country.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("capital: \(country.capital ?? "")")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("code: \(country.code)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    .onTapGesture {
                        Task {
                            await vm.fetchCountry(country)
                        }
                    }
                    
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
        .task {
            await vm.fetchCountries()
        }
        .navigationTitle("Countries")
    }
}

#Preview {
    let mock = MockGraphQLNetworkServiceImpl()
    mock.setData([Country(code: "IN", name: "India", capital: "Delhi")])
    return CountryView(vm: CountryViewModel(networking: mock))
}
