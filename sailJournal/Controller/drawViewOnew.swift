//
//  drawViewOnew.swift
//  drawFigure
//
//  Created by Jack Sp@rroW on 03.02.2018.
//  Copyright © 2018 Jack Sp@rroW. All rights reserved.
//

import UIKit

class Gradient :UIView 
{
    override func draw(_ rect: CGRect)
    {

        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        
        //// Gradient Declarations
        let gradient = CGGradient(colorsSpace: nil, colors: [UIColor.red.cgColor, UIColor.blue.cgColor] as CFArray, locations: [0, 1])!
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 240, height: 240))
        context.saveGState()
        rectanglePath.addClip()
        context.drawLinearGradient(gradient, start: CGPoint(x: 247, y: 47), end: CGPoint(x: 247, y: 287), options: [])
        context.restoreGState()
        context.drawLinearGradient(gradient, start: CGPoint(x: 384, y: 0), end: CGPoint(x: 384, y: 100), options: [])
        
        
}
}
