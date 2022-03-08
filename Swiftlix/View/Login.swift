//
//  Login.swift
//  Swiftlix
//
//  Created by Michał Sadurski on 29/10/2021.
//

import SwiftUI

struct Login: View {
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.openURL) var openURL
    
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                TextField("", text: $email)
                    .foregroundColor(Color.primary)
                    .placeholder(when: email.isEmpty) {
                        Text("LOGIN_EMAIL").foregroundColor(Color.gray)
                    }
                    .frame(maxWidth: 150)
                
                SecureField("", text: $password)
                    .foregroundColor(Color.primary)
                    .placeholder(when: password.isEmpty) {
                        Text("LOGIN_PASSWORD").foregroundColor(Color.gray)
                    }
                    .frame(maxWidth: 150)
                
                Button {
                    sessionStore.signIn(email: email, password: password)
                } label: {
                    Text("LOGIN_LOG-IN")
                        .foregroundColor(Color.primary)
                }
                
                VStack {
                    Text("LOGIN_TROUBLE-LOGGING-IN")
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                    
                    Button {
                        openURL(URL(string: "https://am.szczecin.pl")!)
                    } label: {
                        Text("LOGIN_CONTACT-US")
                            .foregroundColor(Color.primary)
                    }
                    
                    Button {
                        openURL(URL(string: "https://am.szczecin.pl")!)
                    } label: {
                        Text("LOGIN_CREATE-AN-ACCOUNT")
                            .foregroundColor(Color.primary)
                    }
                }
                .padding(.vertical)
            }
            
            VStack {
                Spacer()
                
                Text("Swiftlix")
                    .font(.headline)
                    .foregroundColor(Color.primary)
                
                if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    Text("v.\(appVersion)")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                }
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
