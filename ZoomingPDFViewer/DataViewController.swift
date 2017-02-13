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
        
        page = pdf.page(at: pageNumber)
        //        let pageExists = (page == nil)
        print("page == nil? " + ((page == nil) ? "true" : "false"))
        scrollView.changePDFPage(page)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Disable zooming if our pages are currently shown in landscape
        if (UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown) {
            scrollView.isUserInteractionEnabled = true
        }
        else {
            scrollView.isUserInteractionEnabled = false
        }
        
        //print("scrollView.zoomScale = \(scrollView.zoomScale) " + pretty_function_string())
    }
    
    override func viewDidLayoutSubviews() {
        //pretty_function()
        restoreScale()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        //pretty_function()
        if (fromInterfaceOrientation == UIInterfaceOrientation.portrait) || (fromInterfaceOrientation == UIInterfaceOrientation.portraitUpsideDown) {
            scrollView.isUserInteractionEnabled = false
        }
        else {
            scrollView.isUserInteractionEnabled = true
        }
    }
    func restoreScale() {
        // Called on orientation change.
        // We need to zoom out and basically reset the scrollview to look right in two-page spline view.
        let pageRect = page.getBoxRect(CGPDFBox.mediaBox)
        let yScale = view.frame.size.height / pageRect.size.height
        let xScale = view.frame.size.width / pageRect.size.width
        
        myScale = min(xScale, yScale)
        //print("myScale = \(myScale) "  + pretty_function_string())
        scrollView.bounds = view.bounds
        scrollView.zoomScale = 1.0
        scrollView.PDFScale = myScale
        scrollView.tiledPDFView.bounds = view.bounds
        scrollView.tiledPDFView.myScale = myScale
        scrollView.tiledPDFView.layer.setNeedsDisplay()
    }
}

