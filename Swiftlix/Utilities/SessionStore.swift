//
//  SessionStore.swift
//  Swiftlix
//
//  Created by Michał Sadurski on 29/10/2021.
//

import Foundation
import Firebase
import FirebaseAuth

struct User {
    var uid: String
    var email: String
}

class SessionStore: ObservableObject {
    @Published var isAnon: Bool = true
    @Published var session: User?
    
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen() {
        handle = Auth.auth().addStateDidChangeListener({ auth, user in
            if let user = user {
                self.isAnon = false
                self.session = User(uid: user.uid, email: user.email!)
            } else {
                self.isAnon = true
                self.session = nil
            }
        })
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Successfully logged in as \(email)")
                self.isAnon = false
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.isAnon = true
            self.session = nil
            return
        } catch {
            return
        }
    }
}
