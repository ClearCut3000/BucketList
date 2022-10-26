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
  @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 55,
                                                                                   longitude: 12),
                                                    span: MKCoordinateSpan(latitudeDelta: 25,
                                                                           longitudeDelta: 25))
  @State private var locations = [Location]()
  @State private var selectedPlace: Location?

  //MARK: - View Body
  var body: some View {
    ZStack {
      Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
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
            selectedPlace = location
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
            let newLocation = Location(id: UUID(),
                                       name: "New Location",
                                       description: "",
                                       latitude: mapRegion.center.latitude,
                                       longitude: mapRegion.center.longitude)
            locations.append(newLocation)
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
    .sheet(item: $selectedPlace) { place in
      EditView(location: place) { newLocation in
        if let index = locations.firstIndex(of: place) {
          locations[index] = newLocation
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
