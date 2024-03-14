//
//  ContentView.swift
//  BarcodeTextScan
//
//  Created by Tim Mitra on 2024-03-13.
//

import SwiftUI

struct ContentView: View {
  
  @EnvironmentObject var vm: AppViewModel
  
    var body: some View {
      switch vm.dataScannerAccessStatus {
      case .notDetermined:
        Text("Requesting camera access.")
      case .cameraAccessNotGranted:
        Text("Please provide camera access.")
      case .cameraNotAvailable:
        Text("Your device doesn't have a camera we can use.")
      case .scannerAvailable:
        Text("Scanner available")
      case .scannerNotAvailable:
        Text("Your device doesn't support this scanner.")
      }
    }
}

#Preview {
    ContentView()
}
