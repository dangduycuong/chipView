//
//  PDFViewController.swift
//  chipView
//
//  Created by cuongdd on 10/03/2022.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    
    var fileName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        viewPDF(fileName: fileName)
    }
    
    
    private func viewPDF(fileName: String) {
        let pdfView = PDFView()

        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)

        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        var filePath = ""
        // Fine documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appendingFormat("/" + fileName)
            print("Local path = \(filePath)")
            
            guard let path = Bundle.main.url(forResource: "example", withExtension: "pdf") else { return }

            if let url = URL(string: filePath), let document = PDFDocument(url: url) {
                pdfView.document = document
            }
            
        } else {
            print("Could not find local directory to store file")
            return
        }
    }
}
