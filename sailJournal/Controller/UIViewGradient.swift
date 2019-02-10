//
//  UIBorderedLabel.swift
//  standToMake
//
//  Created by Karl Oscar Weber on 9/13/14.
//  Copyright (c) 2014 Karl Oscar Weber. All rights reserved.
//
//  Thanks to: http://userflex.wordpress.com/2012/04/05/uilabel-custom-insets/
import UIKit

class UIViewGradient: UIView  {

    
    override func draw(_ rect: CGRect)
    {

        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()

        //// Color Declarations
        //let gradientColor = UIColor(red: 1.000, green: 0.559, blue: 0.000, alpha: 1.000)
        //let gradientColor = UIColor(red: 0.483, green: 0.461, blue: 0.461, alpha: 1.000)
       // let gradientColor = UIColor(red: 77, green: 163, blue: 250, alpha: 1.000)
        //let gradientColor2 = UIColor(red: 1.000, green: 0.308, blue: 0.133, alpha: 1.000)
        //let gradientColor2 = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        //let gradientColor2 = UIColor(red: 1, green: 27, blue: 62, alpha: 1.000)
        
        
        //голубой
        let gradientColor2 = UIColor(red: 0.000, green: 0.111, blue: 0.257, alpha: 1.000)
        let gradientColor = UIColor(red: 0.030, green: 0.642, blue: 1.000, alpha: 1.000)
        
        //морская волна
        //let gradientColor2 = UIColor(red: 0.360, green: 0.787, blue: 0.511, alpha: 1.000)
        //let gradientColor = UIColor(red: 0.854, green: 0.643, blue: 0.524, alpha: 1.000)
        
        
        //// Color Declarations
        //let gradientColor = UIColor(red: 0.293, green: 0.738, blue: 0.450, alpha: 1.000)
        //let gradientColor2 = UIColor(red: 0.030, green: 0.642, blue: 1.000, alpha: 1.000)
        
        
        
        //// Gradient Declarations
        let gradient = CGGradient(colorsSpace: nil, colors: [gradientColor.cgColor, gradientColor2.cgColor] as CFArray, locations: [0, 1])!
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 768, height: 1050))
        context.saveGState()
        rectanglePath.addClip()
        context.drawLinearGradient(gradient, start: CGPoint(x: 384, y: -0), end: CGPoint(x: 384, y: 1050), options: [])
        context.restoreGState()
        
        context.restoreGState()
    
}
}
