//
//  AppViewModel.swift
//  BarcodeTextScan
//
//  Created by Tim Mitra on 2024-03-13.
//
 
import SwiftUI
import AVKit
import VisionKit

enum DataScannerAccessStatusType {
  case notDetermined
  case cameraAccessNotGranted
  case cameraNotAvailable
  case scannerAvailable
  case scannerNotAvailable
}

@MainActor
final class AppViewModel: ObservableObject {
  
  @Published var dataScannerAccessStatus: DataScannerAccessStatusType = .notDetermined
  
  private var isScannerAvailable: Bool {
    DataScannerViewController.isAvailable && DataScannerViewController.isSupported
  }
  
  func requestDataScannerAccessStatus() async {
    guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
      dataScannerAccessStatus = .cameraNotAvailable
      return
    }
    
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized: // A12 or higher
      dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
    case .restricted, .denied:
      dataScannerAccessStatus = .notDetermined
    case .notDetermined:
      // ask for permission
      let granted = await AVCaptureDevice.requestAccess(for: .video)
      if granted {
        dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
      } else {
        dataScannerAccessStatus = .cameraAccessNotGranted
      }
    default:
      break
    }
  }
  
}
