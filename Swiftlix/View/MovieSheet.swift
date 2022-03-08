//
//  MovieSheet.swift
//  Swiftlix
//
//  Created by Michał Sadurski on 30/10/2021.
//

import SwiftUI

struct MovieSheet: View {
    @ObservedObject private var moviesVM = MoviesVM()
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var isPresented: Bool
    @Binding var movie: Movie?
    @State var moviePoster: URL?
    
    @State var filePickerPresented: Bool = false
    @State var filePath: URL?
    
    @State var movieGenres: [String] = []
    @State var movieGenres2: [String] = []
    @State var releaseDates: [String] = Array(1888...Calendar.current.component(.year, from: .now)).map{ String($0) }.sorted(by: >)
    
    @State var title: String = ""
    @State var genre: String = "FANTASY"
    @State var genre2: String = "(optional)"
    @State var directedBy: String = ""
    @State var writtenBy: String = ""
    @State var releaseDate: String = "2010"
    @State var length: String = ""
    @State var imdbLink: String = ""
    @State var description: String = ""
        
    enum MovieSheetMode {
        case add
        case edit
        case info
    }
    
    let mode: MovieSheetMode
        
    var body: some View {
        switch mode {
        case .add:
            VStack {
                VStack(spacing: 15) {
                    if let filePath = filePath {
                        AsyncImage(url: filePath)
                    } else {
                        Image(systemName: "plus.square.dashed")
                            .foregroundColor(Color.accentColor)
                            .font(.title)
                        
                        Text("150px x 222px .png")
                            .foregroundColor(Color.primary)
                            .font(.headline)
                    }
                }
                .frame(width: 150, height: 222)
                .onTapGesture {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = false
                    if panel.runModal() == .OK {
                        if let url = panel.urls.first {
                            self.filePath = url
                        }
                    }
                }
                
                HStack(spacing: 15) {
                    Text("MOVIE-SHEET_TITLE")
                        .foregroundColor(Color.primary)
                    
                    TextField("", text: $title)
                        .foregroundColor(Color.primary)
                        .placeholder(when: title.isEmpty) {
                            Text("Alice in Wonderland")
                                .foregroundColor(Color.gray)
                                .padding(.horizontal, 5)
                        }
                }
                
                HStack(spacing: 15) {
                    Text("MOVIE-SHEET_GENRE")
                        .foregroundColor(Color.primary)
                    
                    HStack(spacing: 5) {
                        Picker("", selection: $genre) {
                            ForEach(movieGenres, id: \.self) {
                                Text(LocalizedStringKey("GENRE_" + $0))
                                    .foregroundColor(Color.primary)
                            }
                        }
                        
                        Picker("", selection: $genre2) {
                            ForEach(movieGenres2, id: \.self) {
                                if ($0 == "(optional)") {
                                    Text(LocalizedStringKey("GENRE_OPTIONAL"))
                                        .foregroundColor(Color.primary)
                                } else {
                                    Text(LocalizedStringKey("GENRE_" + $0))
                                        .foregroundColor(Color.primary)
                                }
                            }
                        }
                    }
                }
                
                HStack(spacing: 15) {
                    Text("MOVIE-SHEET_DIRECTED-BY")
                        .foregroundColor(Color.primary)
                    
                    TextField("", text: $directedBy)
                        .foregroundColor(Color.primary)
                        .placeholder(when: directedBy.isEmpty) {
                            Text("Tim Burton")
                                .foregroundColor(Color.gray)
                                .padding(.horizontal, 5)
                        }
                }
                
                HStack(spacing: 15) {
                    Text("MOVIE-SHEET_WRITTEN-BY")
                        .foregroundColor(Color.primary)
                    
                    TextField("", text: $writtenBy)
                        .foregroundColor(Color.primary)
                        .placeholder(when: writtenBy.isEmpty) {
                            Text("Linda Woolverton")
                                .foregroundColor(Color.gray)
                                .padding(.horizontal, 5)
                        }
                }
                
                HStack(spacing: 15) {
                    Text("MOVIE-SHEET_RELEASE-DATE")
                        .foregroundColor(Color.primary)
                    
                    Picker("", selection: $releaseDate) {
                        ForEach(releaseDates, id: \.self) {
                            Text($0)
                                .foregroundColor(Color.primary)
                        }
                    }
                }
                
                HStack(spacing: 15) {
                    Text("MOVIE-SHEET_LENGTH")
                        .foregroundColor(Color.primary)
                    
                    TextField("", text: $length)
                        .foregroundColor(Color.primary)
                        .placeholder(when: length.isEmpty) {
                            Text("108")
                                .foregroundColor(Color.gray)
                                .padding(.horizontal, 5)
                        }
                }
                
                HStack {
                    Text("MOVIE-SHEET_IMDB-LINK")
                        .foregroundColor(Color.primary)
                    
                    TextField("", text: $imdbLink)
                        .foregroundColor(Color.primary)
                        .placeholder(when: imdbLink.isEmpty) {
                            Text(verbatim: "https://www.imdb.com/title/tt1014759/")
                                .foregroundColor(Color.gray)
                                .padding(.horizontal, 5)
                        }
                }
                
                HStack {
                    Text("MOVIE-SHEET_DESCRIPTION")
                        .foregroundColor(Color.primary)
                    
                    TextEditor(text: $description)
                        .padding(.vertical, 5)
                        .foregroundColor(Color.primary)
                        .font(.body)
                        .textFieldStyle(PlainTextFieldStyle())
                        .background(Color.systemBG)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(Color.primary.opacity(0.5))
                        )
                }
                
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("BTN_CANCEL")
                            .foregroundColor(Color.primary)
                    }
                    
                    Button {
                        moviesVM.addMovieToDB(title: title, genre: genre, genre2: genre2, directedBy: directedBy, writtenBy: writtenBy, releaseDate: releaseDate, imdbLink: imdbLink, length: length, description: description) { documentID in
                            if let filePath = filePath {
                                moviesVM.uploadMoviePoster(movieID: documentID, filePath: filePath)
                            }
                        }
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("BTN_ADD")
                            .foregroundColor(Color.primary)
                    }
                }
            }
            .padding()
            .background(Color.systemBG)
            .onAppear {
                moviesVM.fetchMovieGenres { result in
                    movieGenres.append(contentsOf: result)
                    movieGenres2.append("(optional)")
                    movieGenres2.append(contentsOf: result)                    
                }
            }
        case .edit:
            VStack {
                
            }
            .padding()
            .background(Color.systemBG)
        case .info:
            VStack {
                Text("\(movie?.title ?? "undefined") (\(movie?.year ?? "0"))")
                    .foregroundColor(Color.primary)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(movie?.genre ?? "undefined")
                    .foregroundColor(Color.primary)
                    .font(.headline)
                
                Text(Date.minutesToHoursAndMinutes(movie?.length ?? 0))
                    .foregroundColor(Color.primary)
                    .font(.subheadline)
                
                HStack(spacing: 15) {
                    VStack {
                        AsyncImage(url: moviePoster)
                            .frame(width: 150, height: 222)
                            .scaledToFill()
                            .cornerRadius(5)
                    }
                    .onAppear {
                        moviesVM.fetchMoviePoster(movieID: movie?.id ?? "placeholder") { url in
                            moviePoster = url
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(spacing: 5) {
                            Text("Directed by:")
                                .foregroundColor(Color.primary)
                                .font(.title2)
                            
                            Text(movie?.directedBy ?? "undefined")
                                .foregroundColor(Color.primary)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        HStack(spacing: 5) {
                            Text("Written by:")
                                .foregroundColor(Color.primary)
                                .font(.title2)
                            
                            Text(movie?.writtenBy ?? "undefined")
                                .foregroundColor(Color.primary)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        Text(movie?.description ?? "undefined")
                            .foregroundColor(Color.primary)
                        
                        HStack {
                            Spacer()
                            
                            Link(destination: URL(string: movie?.imdbLink ?? "")!) {
                                Image("imdb")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(10)
                            }
                            .onHover { state in
                                if state {
                                    NSCursor.pointingHand.push()
                                } else {
                                    NSCursor.pop()
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Done")
                        .foregroundColor(Color.primary)
                }
            }
            .padding()
            .background(Color.systemBG)
        }
    }
}

//struct MovieSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieSheet()
//    }
//}
