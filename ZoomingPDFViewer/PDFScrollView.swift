//
//  PDFScrollView.swift
//  ZoomingPDFViewer
//
//  Created by Fabio A. Camichel on 01.01.16.
//  Copyright © 2016 Fabio A. Camichel. All rights reserved.
//

import UIKit

class PDFScrollView: UIScrollView, UIScrollViewDelegate {
    var pageRect = CGRect()
    var backgroundImageView: UIView!
    var tiledPDFView: TiledPDFView!
    var oldTiledPDFView: TiledPDFView!
    var PDFScale = CGFloat()
    var PDFPage: CGPDFPage!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        //pretty_function()
        decelerationRate = UIScrollViewDecelerationRateFast
        delegate = self
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 5
        minimumZoomScale = 0.25
        maximumZoomScale = 5
        backgroundImageView = UIView(frame: frame)
        oldTiledPDFView = TiledPDFView(frame:pageRect, scale: PDFScale)
    }
    
    func changePDFPage(_ PDFPage: CGPDFPage?) {
        self.PDFPage = PDFPage
        
        // PDFPage is nil if we're requested to draw a padded blank page by the parent UIPageViewController
        if (PDFPage == nil) {
            pageRect = bounds
        }
        else {
            pageRect = self.PDFPage.getBoxRect(CGPDFBox.mediaBox)
            
            PDFScale = frame.size.width / pageRect.size.width
            pageRect = CGRect(x: pageRect.origin.x, y: pageRect.origin.y, width: pageRect.size.width * PDFScale, height: pageRect.size.height * PDFScale)
        }
        // Create the TiledPDFView based on the size of the PDF page and scale it to fit the view.
        replaceTiledPDFViewWithFrame(pageRect)
    }
    
    // Use layoutSubviews to center the PDF page in the view.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Center the image as it becomes smaller than the size of the screen.
        
        let boundsSize = bounds.size
        var frameToCenter:CGRect = tiledPDFView.frame
        
        // Center horizontally.
        
        if (frameToCenter.size.width < boundsSize.width) {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        }
        else {
            frameToCenter.origin.x = 0
        }
        
        // Center vertically.
        
        if (frameToCenter.size.height < boundsSize.height) {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        }
        else {
            frameToCenter.origin.y = 0
        }
        
        tiledPDFView.frame = frameToCenter
        backgroundImageView.frame = frameToCenter
        
        /*
        To handle the interaction between CATiledLayer and high resolution screens, set the tiling view's contentScaleFactor to 1.0.
        If this step were omitted, the content scale factor would be 2.0 on high resolution screens, which would cause the CATiledLayer to ask for tiles of the wrong scale.
        */
        
        tiledPDFView.contentScaleFactor = 1.0
        
    }
    
    /*
    A UIScrollView delegate callback, called when the user starts zooming.
    Return the current TiledPDFView.
    */
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return tiledPDFView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        //print(pretty_function_string() + " scrollview.zoomScale = \(zoomScale)")
        // Remove back tiled view.
        oldTiledPDFView.removeFromSuperview()
        
        // Set the current TiledPDFView to be the old view.
        oldTiledPDFView = tiledPDFView
    }
    
    /*
    A UIScrollView delegate callback, called when the user begins zooming.
    When the user begins zooming, remove the old TiledPDFView and set the current TiledPDFView to be the old view so we can create a new TiledPDFView when the zooming ends.
    */
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        //print(pretty_function_string() + "BEFORE " + " PDFScale = \(PDFScale)")
        
        // Set the new scale factor for the TiledPDFView.
        PDFScale *= scale
        //print(pretty_function_string() + "AFTER " + " PDFScale = \(PDFScale)" + "newFrame = \(oldTiledPDFView.frame)")
        // Create a new tiled PDF View at the new scale
        replaceTiledPDFViewWithFrame(oldTiledPDFView.frame)
    }
    
    func replaceTiledPDFViewWithFrame(_ frame: CGRect) {
        // Create a new tiled PDF View at the new scale
        let t = TiledPDFView(frame: frame, scale: PDFScale)
        t.pdfPage = PDFPage
        // Add the new TiledPDFView to the PDFScrollView.
        addSubview(t)
        tiledPDFView = t
    }
}

