//
//  LoginView.swift
//  NetworkApp
//
//  Created by Md Shabbir Alam on 28/02/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authModel: AuthModel
    
    var body: some View {
        ZStack {
            Color.cyan
                .ignoresSafeArea(.all)
            
            Button {
                authModel.isLoggedIn = true
            } label: {
                Text("Login")
            }
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthModel())
}
