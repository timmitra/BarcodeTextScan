//
//  BarcodeTextScanApp.swift
//  BarcodeTextScan
//
//  Created by Tim Mitra on 2024-03-13.
//

import SwiftUI

@main
struct BarcodeTextScanApp: App {
  
  @StateObject private var vm = AppViewModel()
  
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(vm)
            .task {
              await vm.requestDataScannerAccessStatus()
            }
        }
    }
}
