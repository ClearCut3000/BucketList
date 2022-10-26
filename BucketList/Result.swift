//
//  Result.swift
//  BucketList
//
//  Created by Николай Никитин on 26.10.2022.
//

import Foundation

struct Result: Codable {
  let query: Query
}
struct Query: Codable {
  let pages: [Int: Page]
}
struct Page: Codable {
  let pageid: Int
  let title: String
  let terms: [String: [String]]?
}
