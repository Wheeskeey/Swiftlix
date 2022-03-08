//
//  MoviesVM.swift
//  Swiftlix
//
//  Created by Michał Sadurski on 30/10/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

struct Movie: Identifiable {
    var id: String
    var description: String
    var directedBy: String
    var genre: String
    var imdbLink: String
    var length: Int
    var title: String
    var writtenBy: String
    var year: String
}

class MoviesVM: ObservableObject {
    @Published var movies = [Movie]()
    @Published var ownedMovies = [Movie]()
    
    private var db = Firestore.firestore()
    
    func fetchGalleryData() {
        db.collection("movies").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents received!")
                return
            }
            
            self.movies = documents.map { (queryDocumentSnapshot) -> Movie in
                let data = queryDocumentSnapshot.data()
                let docID = queryDocumentSnapshot.documentID
                
                let description = data["description"] as? String ?? ""
                let directedBy = data["directedBy"] as? String ?? ""
                let genreRaw = data["genre"] as? String ?? ""
                var genreComps = genreRaw.uppercased().components(separatedBy: "/")
                
                if (genreComps[1].contains(" ")) {
                    genreComps[1] = genreComps[1].replacingOccurrences(of: " ", with: "-")
                }
                
                let genre = LocalizedStringKey("GENRE_" + genreComps[0]).stringValue() + "/" + LocalizedStringKey("GENRE_" + genreComps[1]).stringValue()
                let imdbLink = data["imdbLink"] as? String ?? ""
                let length = data["length"] as? Int ?? -1
                let title = data["title"] as? String ?? ""
                let writtenBy = data["writtenBy"] as? String ?? ""
                let year = data["year"] as? String ?? ""
                
                return Movie(id: docID, description: description, directedBy: directedBy, genre: genre, imdbLink: imdbLink, length: length, title: title, writtenBy: writtenBy, year: year)
            }
        }
    }
    
    func fetchOwnedMovies(userID: String, completion: @escaping ([String]) -> Void) {
        db.collection("users").document(userID).getDocument { docSnapshot, error in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }
            
            guard let data = docSnapshot?.data() else { return }
            
            let ownedMovies = data["ownedMovies"] as? [String] ?? []
            completion(ownedMovies)
        }
    }
    
    func fetchMovieGenres(completion: @escaping ([String]) -> Void) {
        db.collection("movieProperties").document("genres").getDocument { docSnapshot, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }
            
            guard let data = docSnapshot?.data() else { return }
            
            let genres = data["genre"] as? [String]
            completion(genres?.sorted(by: <) ?? [])
        }
    }
    
    func fetchMoviePoster(movieID: String, completion: @escaping (URL) -> Void) {
        let imageRef = Storage.storage().reference(forURL: "gs://swiftlix-3e682.appspot.com/moviePosters/\(movieID).png")
        
        imageRef.downloadURL { url, error in
            if let url = url {
                completion(url)
            }
        }
    }
    
    func uploadMoviePoster(movieID: String, filePath: URL) {
        let uploadRef = Storage.storage().reference(forURL: "gs://swiftlix-3e682.appspot.com/moviePosters/\(movieID).png")
        
        uploadRef.putFile(from: filePath, metadata: nil) { _, error in
            if let error = error {
                print("An error occured while uploading an image: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func addMovieToDB(title: String, genre: String, genre2: String, directedBy: String, writtenBy: String, releaseDate: String, imdbLink: String, length: String, description: String, completion: @escaping (_ documentID: String) -> Void) {
        var genreToAdd: String {
            if genre2 != "(optional)" {
                return "\(genre)/\(genre2)"
            } else {
                return genre
            }
        }
        
        var ref: DocumentReference? = nil
        
        ref = db.collection("movies").addDocument(data: [
            "title" : title,
            "genre" : genreToAdd,
            "directedBy" : directedBy,
            "writtenBy" : writtenBy,
            "year" : releaseDate,
            "length" : Int(length) ?? -1,
            "imdbLink" : imdbLink,
            "description" : description
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                completion(ref!.documentID)
            }
        }
    }
    
    func removeMovieFromDB(docID: String?) {
        guard let docID = docID else {
            return
        }
        
        db.collection("movies").document(docID).delete()
    }
}
