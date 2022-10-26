//
//  EditView.swift
//  BucketList
//
//  Created by Николай Никитин on 26.10.2022.
//

import SwiftUI

struct EditView: View {

  //MARK: - View Properties
  @Environment(\.dismiss) var dismiss
  var location: Location
  var onSave: (Location) -> Void
  @State private var name: String
  @State private var description: String

  //MARK: - Init
  init(location: Location, onSave: @escaping (Location) -> Void) {
    self.location = location
    self.onSave = onSave
    _name = State(initialValue: location.name)
    _description = State(initialValue: location.description)
  }

  //MARK: - View Body
  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Place name:", text: $name)
          TextField("Description:", text: $description)
        }
      }
      .navigationTitle("Place details")
      .toolbar {
        Button("Save") {
          var newLocation = location
          newLocation.id = UUID()
          newLocation.name = name
          newLocation.description = description
          onSave(newLocation)
          dismiss()
        }
      }
    }
  }
}

struct EditView_Previews: PreviewProvider {
  static var previews: some View {
    EditView(location: Location.example) { _ in }
  }
}
