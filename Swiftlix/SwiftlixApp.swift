//
//  SwiftlixApp.swift
//  Swiftlix
//
//  Created by Michał Sadurski on 29/10/2021.
//

import SwiftUI
import Firebase

@main
struct SwiftlixApp: App {
    @StateObject var sessionStore = SessionStore()
    
    @AppStorage("darkMode") var darkMode: Bool = false
    
    @State var colorSchemeAlertPresenting: Bool = false
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1000, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
                .background(Color.systemGray6)
                .onChange(of: darkMode) { _ in
                    colorSchemeAlertPresenting = true
                }
                .onChange(of: colorSchemeAlertPresenting) { newValue in
                    if (newValue == false) {
                        NSApplication.shared.keyWindow?.close()
                    }
                }
                .alert(isPresented: $colorSchemeAlertPresenting) {
                    Alert(title: Text("Color scheme changed"), message: Text("Application will now reload"), dismissButton: .default(Text("Ok")))
                }
                .onAppear {
                    sessionStore.listen()
                }
                .environmentObject(sessionStore)
        }
        
        Settings {
            VStack {
                Text("Some settings here")
                    .foregroundColor(Color.primary)
                
                Spacer()
                
                if (sessionStore.session != nil) {
                    Button {
                        sessionStore.logOut()
                        NSApplication.shared.keyWindow?.close()
                    } label: {
                        Text("Log out")
                            .foregroundColor(Color.primary)
                    }
                    .padding(.vertical)
                }
                
                Image(systemName: darkMode ? "moon.fill" : "moon")
                    .foregroundColor(Color.primary)
                    .onTapGesture {
                        darkMode.toggle()
                        NSApplication.shared.keyWindow?.close()
                    }
            }
            .padding()
            .frame(minWidth: 400, minHeight: 600)
            .background(Color.systemGray6)
        }
    }
}
