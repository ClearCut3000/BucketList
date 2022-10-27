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
  @StateObject private var viewModel: ViewModel
  var onSave: (Location) -> Void

  //MARK: - Init
  init(location: Location, onSave: @escaping (Location) -> Void) {
    self.onSave = onSave
   _viewModel = StateObject(wrappedValue: ViewModel(location: location))
  }

  //MARK: - View Body
  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Place name:", text: $viewModel.name)
          TextField("Description:", text: $viewModel.description)
        }
        Section("Nearby...") {
          switch viewModel.loadingState {
          case .loading:
            Text("Loading...")
          case .loaded:
            ForEach(viewModel.pages, id: \.pageid) { page in
              Text(page.title)
                .font(.headline)
              + Text(": ")
              + Text(page.description)
                .italic()
            }
          case .failed:
            Text("Please try again later!")
          }
        }
      }
      .navigationTitle("Place details")
      .toolbar {
        Button("Save") {
          let newLocation = viewModel.createNewLocation()
          onSave(newLocation)
          dismiss()
        }
      }
      .task {
        await viewModel.fetchNearbyPlaces()
      }
    }
  }
}

struct EditView_Previews: PreviewProvider {
  static var previews: some View {
    EditView(location: Location.example) { _ in }
  }
}
