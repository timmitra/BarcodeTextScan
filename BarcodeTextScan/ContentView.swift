//
//  ContentView.swift
//  BarcodeTextScan
//
//  Created by Tim Mitra on 2024-03-13.
//

import SwiftUI
import VisionKit

struct ContentView: View {
  
  @EnvironmentObject var vm: AppViewModel
  
  private let textContentType: [(title: String, textContentType: DataScannerViewController.TextContentType?)] = [
    ("All", .none),
    ("URL", .URL),
    ("Phone", .telephoneNumber),
    ("Email", .emailAddress),
    ("Address", .fullStreetAddress)
  ]
  
    var body: some View {
      switch vm.dataScannerAccessStatus {
      case .notDetermined:
        Text("Requesting camera access.")
      case .cameraAccessNotGranted:
        Text("Please provide camera access.")
      case .cameraNotAvailable:
        Text("Your device doesn't have a camera we can use.")
      case .scannerAvailable:
        mainView
      case .scannerNotAvailable:
        Text("Your device doesn't support this scanner.")
      }
    }
  
  private var mainView: some View {
    
      DataScannerView(recognizedItems: $vm.recognizedItems,
                      recognizedDataType: vm.recognizedDataType,
                      recognizesMultipleItems: vm.recognizesMultipleItems)
      .background { Color.gray.opacity(0.3) }
      .id(vm.dataScannerViewId)
      .ignoresSafeArea()
      .sheet(isPresented: .constant(true), content: {
        bottomContainerView
          .background(.ultraThinMaterial)
          .presentationDetents([.medium, .fraction(0.25)])
          .presentationDragIndicator(.visible)
          .interactiveDismissDisabled()
          .onAppear {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let controller = windowScene.windows.first?.rootViewController?.presentedViewController else { return }
            controller.view.backgroundColor = .clear
          }
      })

      .onChange(of: vm.scanType) { _, _ in
        vm.recognizedItems = []
      }
      .onChange(of: vm.textContentType) { _, _ in
        vm.recognizedItems = []
      }
      .onChange(of: vm.recognizesMultipleItems) { _, _ in
        vm.recognizedItems = []
      }
  }
  
  private var headerView: some View {
    VStack {
      HStack {
        Picker("Scan Type", selection: $vm.scanType) {
          Text("Barcode").tag(ScanType.barcode)
          Text("Text").tag(ScanType.text)
        }
        .pickerStyle(.segmented)
        
        Toggle("Scan multiple", isOn: $vm.recognizesMultipleItems)
      }
      .padding(.top)
      
      if vm.scanType == .text {
        Picker("Text content type", selection: $vm.textContentType) {
          ForEach(textContentType, id: \.self.textContentType) { option in
            Text(option.title).tag(option.textContentType)
          }
        }
        .pickerStyle(.segmented)
      }
      
      Text(vm.headerText).padding(.top)
    }
    .padding(.horizontal)
  }
  
  private var bottomContainerView: some View {
    VStack {
      headerView
      ScrollView {
        LazyVStack(alignment: .leading, spacing: 16) {
          ForEach(vm.recognizedItems) { item in
            switch item {
            case .barcode(let barcode):
              Text(barcode.payloadStringValue ?? "unknown barcode")
            case .text(let text):
              Text(text.transcript)
            @unknown default:
              Text("unknown")
            }
          }
        }
        .padding()
      }
    }
  }
}

#Preview {
    ContentView()
}
