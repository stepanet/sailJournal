//
//  DateNow.swift
//  sailJournal
//
//  Created by Jack Sp@rroW on 08.01.2018.
//  Copyright © 2018 Dmitry Pyatin. All rights reserved.
//

import Foundation
//import UIKit

public class FrameworkKitClass {

    class func datenow() -> String {    
        let date : Date = Date()
       // print("date======\(date)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let todaysDate = dateFormatter.string(from: date)
        return todaysDate
    }
    
    
    //MARK: переводим лонгитют и латитюд в широту и долготу, oneString - > где 1 - кординаты в одну строку
    class func coordinateString(latitude:Double, longitude:Double , oneString: Int) -> String {
        var latSeconds = Int(latitude * 3600)
        let latDegrees = latSeconds / 3600
        latSeconds = abs(latSeconds % 3600)
        let latMinutes = latSeconds / 60
        latSeconds %= 60
        var longSeconds = Int(longitude * 3600)
        let longDegrees = longSeconds / 3600
        longSeconds = abs(longSeconds % 3600)
        let longMinutes = longSeconds / 60
        longSeconds %= 60
        
        if oneString == 1 {
            
            return String(format:"%d°%d'%d\"%@ %d°%d'%d\"%@",
                          abs(latDegrees),
                          latMinutes,
                          latSeconds,
                          {return latDegrees >= 0 ? "N" : "S"}(),
                          abs(longDegrees),
                          longMinutes,
                          longSeconds,
                          {return longDegrees >= 0 ? "E" : "W"}() )
        } else {
            return String(format:"%d°%d'%d\"%@ \n %d°%d'%d\"%@",
                          abs(latDegrees),
                          latMinutes,
                          latSeconds,
                          {return latDegrees >= 0 ? "N" : "S"}(),
                          abs(longDegrees),
                          longMinutes,
                          longSeconds,
                          {return longDegrees >= 0 ? "E" : "W"}() )
  
        }

    }
  
}
