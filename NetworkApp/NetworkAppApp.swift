//
//  NetworkAppApp.swift
//  NetworkApp
//
//  Created by Md Shabbir Alam on 18/02/26.
//

import SwiftUI

@main
struct NetworkAppApp: App {
    @StateObject var authModel = AuthModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
//                MDSampleView()
                if authModel.isLoggedIn {
                    HomeView()
                } else {
                    LoginView()
                }
            }
            .environmentObject(authModel)
        }
    }
}
