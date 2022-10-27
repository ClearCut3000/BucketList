//
//  Extension+ContentView-ViewModel.swift
//  BucketList
//
//  Created by Николай Никитин on 26.10.2022.
//

import Foundation
import MapKit
import LocalAuthentication

extension ContentView {
  @MainActor class ViewModel: ObservableObject {

    //MARK: - ViewModel Properties
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 55,
                                                                                 longitude: 12),
                                                  span: MKCoordinateSpan(latitudeDelta: 25,
                                                                         longitudeDelta: 25))
    @Published private(set) var locations: [Location]
    @Published var selectedPlace: Location?
    @Published var isUnlocked = false
    @Published var authentificationError = "Unknown error"
    @Published var isShowingAuthentificationError = false
    let savePath = FileManager.documentsDirectory.appending(component: "SavedPlaces")

    //MARK: - ViewModel Init
    init() {
      do {
        let data = try Data(contentsOf: savePath)
        locations = try JSONDecoder().decode([Location].self, from: data)
      } catch {
        locations = []
      }
    }

    //MARK: - ViewModel methods
    func save() {
      do {
        let data = try JSONEncoder().encode(locations)
        try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
      } catch {
        print("Unable to save data.")
      }
    }

    func addLocation() {
      let newLocation = Location(id: UUID(),
                                 name: "New Location",
                                 description: "",
                                 latitude: mapRegion.center.latitude,
                                 longitude: mapRegion.center.longitude)
      locations.append(newLocation)
      save()
    }

    func update(location: Location) {
      guard let selectedPlace else { return }
      if let index = locations.firstIndex(of: selectedPlace) {
        locations[index] = location
        save()
      }
    }

    func authenticate() {
      let context = LAContext()
      var error: NSError?

      if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        let reason = "Please authenticate yourself to unlock your places."
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
          Task { @MainActor in
            if success {
              self.isUnlocked = true
            } else {
              //error
              self.authentificationError = "Biometric authentification evalueted with error: \(String(describing: authError?.localizedDescription))"
              self.isShowingAuthentificationError = true
            }
          }
        }
      } else {
        // no biometrics
        authentificationError = "Sorry, your device doesn't support biometric authentification"
        isShowingAuthentificationError = true
      }
    }
  }
}
