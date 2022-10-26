//
//  Location.swift
//  BucketList
//
//  Created by Николай Никитин on 26.10.2022.
//

import Foundation

struct Location: Identifiable, Codable, Equatable {
  let id: UUID
  var name: String
  var description: String
  var latitude: Double
  var longitude: Double

  
}
