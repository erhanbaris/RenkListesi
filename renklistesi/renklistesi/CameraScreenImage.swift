//
//  CameraScreenView.swift
//  renklistesi
//
//  Created by Erhan BARIŞ on 09/06/15.
//  Copyright (c) 2015 Erhan Baris. All rights reserved.
//

import Foundation
import GPUImage

public class CameraScreenImage : UIImage
{
    
    /*
    var context = UIGraphicsGetCurrentContext();
    
    UIColor.lightGrayColor().set();
    var drawingRect = CGRectMake(0, 0, 320, 60);
    CGContextFillRect(context, drawingRect);
    UIColor.whiteColor().set();
    
    var ellipseRect = CGRectMake(60.0, 150.0, 200.0, 200.0);
    CGContextFillEllipseInRect(context, ellipseRect);
    
    
    */
    
     public init?(named : String)
    {
        super.init(named: named);
    }

     public required init(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    
    public override func drawInRect(rect: CGRect) {
    var context = UIGraphicsGetCurrentContext();
        drawRectangleAtTopOfScreen(context);
    }
    
    
    func drawRectangleAtTopOfScreen(context : CGContextRef)
    {
        UIColor.lightGrayColor().set();
        var drawingRect = CGRectMake(0, 0, 320, 60);
        CGContextFillRect(context, drawingRect);
        UIColor.redColor().set();
        
        var ellipseRect = CGRectMake(60.0, 150.0, 200.0, 200.0);
        CGContextFillEllipseInRect(context, ellipseRect);
    }
}