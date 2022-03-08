//
//  ContentView.swift
//  Swiftlix
//
//  Created by Michał Sadurski on 29/10/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionStore: SessionStore
    
    var body: some View {
        VStack {
            if (sessionStore.isAnon) {
                Login()
            } else {
                Home()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
