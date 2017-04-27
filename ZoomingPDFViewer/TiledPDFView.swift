//
//  TiledPDFView.swift
//  ZoomingPDFViewer
//
//  Created by Fabio A. Camichel on 01.01.16.
//  Copyright © 2016 Fabio A. Camichel. All rights reserved.
//

import UIKit

class TiledPDFView: UIView {
    var pdfPage: CGPDFPage?
    var myScale: CGFloat!
    
    // Create a new TiledPDFView with the desired frame and scale.
    init(frame: CGRect, scale: CGFloat) {
        super.init(frame: frame)
        let tiledLayer = CATiledLayer(layer: self)
        /*
        levelsOfDetail and levelsOfDetailBias determine how the layer is rendered at different zoom levels. This only matters while the view is zooming, because once the the view is done zooming a new TiledPDFView is created at the correct size and scale.
        */
        tiledLayer.levelsOfDetail = 4
        tiledLayer.levelsOfDetailBias = 3
        tiledLayer.tileSize = CGSize(width: 512.0, height: 512.0)
        
        myScale = scale
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // needs to be called even empty in order to call drawLayer func while zooming
    }
    
    // Draw the CGPDFPageRef into the layer at the correct scale.
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        //print(pretty_function_string() + "myScale: \(myScale)")
        
        // Fill the background with white.
        ctx.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ctx.fill(bounds)
        
        // Print a blank page and return if our page is nil.
        if (pdfPage == nil) {
            return
        }
        
        ctx.saveGState()
        // Flip the context so that the PDF page is rendered right side up.
        ctx.translateBy(x: 0.0, y: bounds.size.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        
        // Scale the context so that the PDF page is rendered at the correct size for the zoom level.
        ctx.scaleBy(x: myScale, y: myScale)
        ctx.drawPDFPage(pdfPage!)
        ctx.restoreGState()
    }
}

