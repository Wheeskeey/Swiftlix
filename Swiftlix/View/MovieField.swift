//
//  MovieField.swift
//  Swiftlix
//
//  Created by Michał Sadurski on 05/11/2021.
//

import SwiftUI

struct MovieField: View {
    @ObservedObject private var viewModel = MoviesVM()
    
    var movie: Movie
    @State var movieSelected: Movie?
    @State var moviePoster: URL?
    
    @State var deleteMovieAlertPresenting: Bool = false
    @State var movieAlertPresenting: Bool = false
    
    @State private var overInfo: Bool = false
    @State private var overRent: Bool = false
    @State private var overBuy: Bool = false
    @State private var overEdit: Bool = false
    @State private var overRemove: Bool = false
    
    var body: some View {
        HStack {
            VStack {
                AsyncImage(url: moviePoster) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 75)
                        .cornerRadius(5)
                        .transition(AnyTransition.opacity.animation(.linear))
                } placeholder: {
                    Image(systemName: "photo.fill")
                        .foregroundColor(Color.primary)
                        .frame(width: 50.68, height: 75)
                }
            }
            .onAppear {
                viewModel.fetchMoviePoster(movieID: movie.id) { url in
                    moviePoster = url
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                Text(movie.title)
                    .foregroundColor(Color.primary)
                    .font(.title2)
                    .fontWeight(.bold)

                Text("\(movie.directedBy) · \(movie.genre) · \(movie.year)")
                    .foregroundColor(Color.primary)
                    .font(.title3)
            }

            Spacer()

            HStack(alignment: .center, spacing: 10) {
                VStack {
                    Image(systemName: "eye.square.fill")
                        .font(.title)
                        .foregroundColor(Color.primary)

                    if (overInfo) {
                        Text("MOVIE-FIELD_INFO")
                            .font(.subheadline)
                            .foregroundColor(Color.primary)
                    }
                }
                .onTapGesture {
                    movieAlertPresenting = true
                }
                .onHover { state in
                    withAnimation(.interactiveSpring()) {
                        overInfo = state
                    }
                }
                .sheet(isPresented: $movieAlertPresenting) {
                    MovieSheet(isPresented: $movieAlertPresenting, movie: $movieSelected, mode: .info)
                        .frame(minWidth: 200, maxWidth: 600, minHeight: 400)
                }

                VStack {
                    Image(systemName: "tag.square.fill")
                        .font(.title)
                        .foregroundColor(Color.primary)

                    if (overRent) {
                        Text("MOVIE-FIELD_RENT")
                            .font(.subheadline)
                            .foregroundColor(Color.primary)
                    }
                }
                .onTapGesture {

                }
                .onHover { state in
                    withAnimation(.interactiveSpring()) {
                        overRent = state
                    }
                }

                VStack {
                    Image(systemName: "dollarsign.square.fill")
                        .font(.title)
                        .foregroundColor(Color.primary)

                    if (overBuy) {
                        Text("MOVIE-FIELD_BUY")
                            .font(.subheadline)
                            .foregroundColor(Color.primary)
                    }
                }
                .onTapGesture {

                }
                .onHover { state in
                    withAnimation(.interactiveSpring()) {
                        overBuy = state
                    }
                }
            }

//            Circle()
//                .foregroundColor(Color.primary)
//                .frame(width: 5, height: 5)
//                .padding(.horizontal, 5)

            Text("|")
                .foregroundColor(Color.primary)
                .font(.title2)
                .padding(.horizontal, 10)

            HStack(alignment: .center, spacing: 10) {
                VStack {
                    Image(systemName: "square.and.pencil")
                        .font(.title2)
                        .foregroundColor(Color.primary)

                    if (overEdit) {
                        Text("MOVIE-FIELD_EDIT")
                            .font(.subheadline)
                            .foregroundColor(Color.primary)
                    }
                }
                .onTapGesture {

                }
                .onHover { state in
                    withAnimation(.interactiveSpring()) {
                        overEdit = state
                    }
                }

                VStack {
                    Image(systemName: "delete.backward.fill")
                        .font(.title2)
                        .foregroundColor(Color.red)

                    if (overRemove) {
                        Text("MOVIE-FIELD_REMOVE")
                            .font(.subheadline)
                            .foregroundColor(Color.red)
                    }
                }
                .onTapGesture {
                    movieSelected = movie
                    deleteMovieAlertPresenting = true
                }
                .onHover { state in
                    withAnimation(.interactiveSpring()) {
                        overRemove = state
                    }
                }
            }
        }
        .padding(.trailing)
        .transition(AnyTransition.opacity.animation(.linear))
        .alert("\(movieSelected?.title ?? "undefined") (\(movieSelected?.year ?? "-1")) MOVIE-FIELD-ALERT_REMOVE-CONFIRMATION", isPresented: $deleteMovieAlertPresenting) {
            Button("BTN_REMOVE", role: .destructive) { viewModel.removeMovieFromDB(docID: movieSelected?.id) }
            Button("BTN_CANCEL", role: .cancel) {}
        }
    }
}
    
//    var body: some View {
//        VStack {
//            Spacer()
//
//            HStack {
//                Spacer()
//
//                VStack {
//                    AsyncImage(url: moviePoster) { image in
//                        image
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 75)
//                            .cornerRadius(5)
//                            .transition(AnyTransition.opacity.animation(.linear))
//                    } placeholder: {
//                        Image(systemName: "photo.fill")
//                            .foregroundColor(Color.primary)
//                            .frame(width: 50, height: 75)
//                    }
//                    .onAppear {
//                        viewModel.fetchMoviePoster(movieID: movie.id) { url in
//                            moviePoster = url
//                        }
//                    }
//
//                    Text(movie.title)
//                        .foregroundColor(Color.primary)
//                        .font(.title2)
//                        .multilineTextAlignment(.center)
//                }
//
//                Spacer()
//            }
//
//            Spacer()
//        }
//        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 10)
//                .foregroundColor(Color.systemGray5)
//        )
//        .shadow(radius: 5)
//    }
//}
