//
//  Location.swift
//  BucketList
//
//  Created by Николай Никитин on 26.10.2022.
//

import Foundation
import CoreLocation

struct Location: Identifiable, Codable, Equatable {
  var id: UUID
  var name: String
  var description: String
  var latitude: Double
  var longitude: Double

  var coordinates: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude,
                           longitude: longitude)
  }

  static let example = Location(id: UUID(),
                                name: "Some Exanple location",
                                description: "Example location has no description",
                                latitude: 77,
                                longitude: 77)

  static func ==(lhs: Location, rhs: Location) -> Bool {
    lhs.id == rhs.id
  }
}
