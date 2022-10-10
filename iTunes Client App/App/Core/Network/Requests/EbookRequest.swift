//
//  EbookRequest.swift
//  iTunes Client App
//
//  Created by Onur Duyar on 10.10.2022.
//

import Foundation

struct EbookRequest: DataRequest {
    
    var searchText: String
    
    var baseURL: String {
        "https://itunes.apple.com"
    }
    
    var url: String {
        "/search"
    }
    
    var queryItems: [String : String] {
        ["term": searchText,
         "media" : "ebook"]
    }
    
    var method: HTTPMethod {
        .get
    }
    
    init(searchText: String = "E-book") {
        self.searchText = searchText
    }
    
    func decode(_ data: Data) throws -> EbookResponse {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(EbookResponse.self, from: data)
        return response
    }
}

