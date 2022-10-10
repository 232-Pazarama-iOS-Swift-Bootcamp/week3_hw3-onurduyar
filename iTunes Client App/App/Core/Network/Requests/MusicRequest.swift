//
//  MusicRequest.swift
//  iTunes Client App
//
//  Created by Onur Duyar on 10.10.2022.
//

import Foundation

struct MusicRequest: DataRequest {
    
    var searchText: String
    
    var baseURL: String {
        "https://itunes.apple.com"
    }
    
    var url: String {
        "/search"
    }
    
    var queryItems: [String : String] {
        ["term": searchText,
         "media" : "music"]
    }
    
    var method: HTTPMethod {
        .get
    }
    
    init(searchText: String = "Music") {
        self.searchText = searchText
    }
    
    func decode(_ data: Data) throws -> MusicResponse {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(MusicResponse.self, from: data)
        return response
    }
}

