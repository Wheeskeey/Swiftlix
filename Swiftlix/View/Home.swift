//
//  Home.swift
//  Swiftlix
//
//  Created by Michał Sadurski on 29/10/2021.
//

import SwiftUI
import FirebaseAuth

struct Home: View {
    enum HomeTabs {
        case gallery
        case myMovies
    }
    
    @ObservedObject private var viewModel = MoviesVM()
    
    @State var newMovieSheetPresenting: Bool = false
    
    @State var movieSelected: Movie?
    
    @State var activeTab: HomeTabs = .myMovies
    
    @State private var galleryHover: Bool = false
    @State private var myMoviesHover: Bool = false
    
    @State private var refreshHover: Bool = false
    @State private var newMovieHover: Bool = false
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                HStack(spacing: 30) {
                    VStack {
                        if galleryHover || (activeTab == .gallery) {
                            Text("HOME_GALLERY")
                                .foregroundColor(Color.primary)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        } else {
                            Text("HOME_GALLERY")
                                .foregroundColor(Color.systemGray2)
                                .font(.largeTitle)
                                .fontWeight(.bold)

                        }
                    }
                    .onHover { state in
                        withAnimation(.easeOut(duration: 0.2)) {
                            galleryHover = state
                        }
                    }
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.25)) {
                            activeTab = .gallery
                        }
                    }

                    VStack {
                        if myMoviesHover || (activeTab == .myMovies) {
                            Text("HOME_MY-MOVIES")
                                .foregroundColor(Color.primary)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        } else {
                            Text("HOME_MY-MOVIES")
                                .foregroundColor(Color.systemGray2)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                    }
                    .onHover { state in
                        withAnimation(.easeOut(duration: 0.2)) {
                            myMoviesHover = state
                        }
                    }
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.25)) {
                            activeTab = .myMovies
                        }
                    }
                }

                Spacer()
                
                VStack {
                    if refreshHover {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.title)
                            .foregroundStyle(Color.primary)
                    } else {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.title)
                            .foregroundStyle(Color.systemGray2)
                    }
                }
                .onTapGesture {
                    viewModel.fetchGalleryData()
                }
                .onHover { state in
                    withAnimation(.easeOut(duration: 0.2)) {
                        refreshHover = state
                    }
                }

                VStack {
                    if newMovieHover {
                        Image(systemName: "plus.app.fill")
                            .font(.title)
                            .foregroundStyle(Color.primary)
                    } else {
                        Image(systemName: "plus.app.fill")
                            .font(.title)
                            .foregroundStyle(Color.systemGray2)
                    }
                }
                .onTapGesture {
                    newMovieSheetPresenting = true
                }
                .sheet(isPresented: $newMovieSheetPresenting) {
                    MovieSheet(isPresented: $newMovieSheetPresenting, movie: $movieSelected, mode: .add)
                        .frame(minWidth: 400)
                }
                .onHover { state in
                    withAnimation(.easeOut(duration: 0.2)) {
                        newMovieHover = state
                    }
                }
            }

            
            switch activeTab {
            case .gallery:
                ScrollView {
                    VStack {
                        Divider()
                            .background(Color.primary)

//                        LazyVGrid(columns: columns, spacing: 20) {
//                            ForEach(viewModel.movies) { movie in
//                                MovieField(movie: movie, movieSelected: movie)
//                            }
//                        }
                        
                        ForEach(viewModel.movies) { movie in
                            MovieField(movie: movie, movieSelected: movie)
                            
                            Divider()
                                .background(Color.primary)
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchGalleryData()
                }
                
            case .myMovies:
                ScrollView {
                    VStack {
                        Divider()
                            .background(Color.primary)
                        
                        ForEach(viewModel.ownedMovies) { movie in
                            MovieField(movie: movie, movieSelected: movie)
                            
                            Divider()
                                .background(Color.primary)
                        }
                    }
                }
                .onAppear {
                    if let currentUser = Auth.auth().currentUser {
                        viewModel.fetchGalleryData()
                        viewModel.ownedMovies = []
                        
                        viewModel.fetchOwnedMovies(userID: currentUser.uid) { ownedMovies in
                            for movie in viewModel.movies {
                                for ownedMovie in ownedMovies {
                                    if movie.id == ownedMovie {
                                        viewModel.ownedMovies.append(movie)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
