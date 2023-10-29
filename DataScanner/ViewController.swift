//
//  ViewController.swift
//  DataScanner
//
//  Created by Vidyarani Balakrishna on 27/10/2023.
//

import UIKit
import VisionKit

class ViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    private let dataScannerViewController = DataScannerViewController(recognizedDataTypes: [.text(), .barcode(symbologies: [.qr])],
                                                                      qualityLevel: .balanced,
                                                                      recognizesMultipleItems: false,
                                                                      isHighFrameRateTrackingEnabled: true,
                                                                      isPinchToZoomEnabled: true,
                                                                      isGuidanceEnabled: true,
                                                                      isHighlightingEnabled: true)
    
    private var scannerAvailable: Bool { DataScannerViewController.isSupported && DataScannerViewController.isAvailable }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataScannerViewController.delegate = self
    }

    @IBAction func startScan(_ sender: Any) {
        if scannerAvailable {
            present(dataScannerViewController, animated: true)
            try? dataScannerViewController.startScanning()
        }
    }
    
}

extension ViewController: DataScannerViewControllerDelegate {
    func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
        print("The scanner became unavailable")
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        guard let item = allItems.first else {
            infoLabel.text = "Not able to scan"
            dataScannerViewController.dismiss(animated: true)
            return
        }
        switch item {
            case .text(let text):
                print(text.observation)
                print(text.transcript)
                infoLabel.text = text.transcript
            case .barcode(let code):
                let output = code.payloadStringValue ?? "barcode not found"
                print(output)
                infoLabel.text = output
            default:
                break
        }
        dataScannerViewController.dismiss(animated: true)
    }
}
