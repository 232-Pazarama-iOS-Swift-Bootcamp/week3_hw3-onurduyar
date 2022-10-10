//
//  EbookResponse.swift
//  iTunes Client App
//
//  Created by Onur Duyar on 10.10.2022.
//

import Foundation

struct EbookResponse: Decodable {
    let resultCount: Int?
    let results: [EBook]?
}
