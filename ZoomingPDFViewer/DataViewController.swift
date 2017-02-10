//
//  DataViewController.swift
//  ZoomingPDFViewer
//
//  Created by Fabio A. Camichel on 01.01.16.
//  Copyright © 2016 Fabio A. Camichel. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {
    @IBOutlet weak var scrollView: PDFScrollView!
    
    var pdf: CGPDFDocument!
    var page: CGPDFPage!
    var pageNumber: Int = 0
    var myScale: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.page = self.pdf.page(at: self.pageNumber)
        //        let pageExists = (self.page == nil)
        print("self.page == nil? " + ((self.page == nil) ? "true" : "false"))
        self.scrollView.changePDFPage(self.page)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Disable zooming if our pages are currently shown in landscape
        if (UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown) {
            self.scrollView.isUserInteractionEnabled = true
        }
        else {
            self.scrollView.isUserInteractionEnabled = false
        }
        
        //print("scrollView.zoomScale = \(self.scrollView.zoomScale) " + pretty_function_string())
    }
    
    override func viewDidLayoutSubviews() {
        //pretty_function()
        self.restoreScale()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        //pretty_function()
        if (fromInterfaceOrientation == UIInterfaceOrientation.portrait) || (fromInterfaceOrientation == UIInterfaceOrientation.portraitUpsideDown) {
            self.scrollView.isUserInteractionEnabled = false
        }
        else {
            self.scrollView.isUserInteractionEnabled = true
        }
    }
    func restoreScale() {
        // Called on orientation change.
        // We need to zoom out and basically reset the scrollview to look right in two-page spline view.
        let pageRect = self.page.getBoxRect(CGPDFBox.mediaBox)
        let yScale = self.view.frame.size.height / pageRect.size.height
        let xScale = self.view.frame.size.width / pageRect.size.width
        
        myScale = min(xScale, yScale)
        //print("self.myScale = \(self.myScale) "  + pretty_function_string())
        self.scrollView.bounds = self.view.bounds
        self.scrollView.zoomScale = 1.0
        self.scrollView.PDFScale = self.myScale
        self.scrollView.tiledPDFView.bounds = self.view.bounds
        self.scrollView.tiledPDFView.myScale = self.myScale
        self.scrollView.tiledPDFView.layer.setNeedsDisplay()
    }
}

