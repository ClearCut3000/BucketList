//
//  ContentView.swift
//  BucketList
//
//  Created by Николай Никитин on 25.10.2022.
//

import MapKit
import SwiftUI

struct ContentView: View {

  //MARK: - View Properties
  @StateObject private var viewModel = ViewModel()

  //MARK: - View Body
  var body: some View {
    ZStack {
      Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
        MapAnnotation(coordinate: location.coordinates) {
          VStack {
            Image(systemName: "star.circle")
              .resizable()
              .foregroundColor(.red)
              .frame(width: 44, height: 44)
              .background(.white)
              .clipShape(Circle())
            Text(location.name)
              .fixedSize() 
          }
          .onTapGesture {
            viewModel.selectedPlace = location
          }
        }
      }
        .ignoresSafeArea()
      Circle()
        .fill(.blue)
        .opacity(0.25)
        .frame(width: 44, height: 44)

      VStack {
        Spacer()
        HStack {
          Spacer()
          Button {
            viewModel.addLocation()
          } label: {
            Image(systemName: "plus")
          }
          .padding()
          .background(.black.opacity(0.75))
          .foregroundColor(.white)
          .font(.title)
          .clipShape(Circle())
          .padding(.trailing)
        }
      }
    }
    .sheet(item: $viewModel.selectedPlace) { place in
      EditView(location: place) { newLocation in
        viewModel.update(location: newLocation)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
