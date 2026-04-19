//
//  HomeView.swift
//  NetworkApp
//
//  Created by Md Shabbir Alam on 27/02/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authModel: AuthModel
    
    var body: some View {
        ZStack {
            Color.cyan
                .ignoresSafeArea(.all)
            
            getPages()
        }
        .navigationTitle("Home")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Settings") {
                        // settings page
                    }
                    
                    Button(role: .destructive) {
                        authModel.isLoggedIn = false
                    } label: {
                        Text("Logout")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                }
            }
        }
    }
    
    @ViewBuilder
    private func getPages() -> some View {
        List {
            Group{
                NavigationLink {
                    SearchView()
                } label: {
                    Text("Todo")
                }
                
                NavigationLink {
                    CountryView()
                } label: {
                    Text("Country")
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .leading)
        .secure()
    }
}

#Preview {
    HomeView()
}
