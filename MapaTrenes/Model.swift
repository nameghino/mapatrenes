//
//  Model.swift
//  MapaTrenes
//
//  Created by Nicolas Ameghino on 1/22/16.
//  Copyright © 2016 Nicolas Ameghino. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

typealias JSONDictionary = [String : AnyObject]

func extract(key: String, fromDictionary: JSONDictionary) -> CLLocationDegrees? {
    if let r = fromDictionary[key] as? CLLocationDegrees {
        return r
    }
    if let r = fromDictionary[key] as? String {
        return CLLocationDegrees(r)
    }
    return nil
}

protocol WebserviceInitializable {
    init?(dictionary: JSONDictionary)
}

class TrainLocation: NSObject {
    let coordinate: CLLocationCoordinate2D
    let id: String
    let line: Int
    
    let rawData: JSONDictionary!
    
    init(coordinate: CLLocationCoordinate2D, id: String, line: Int) {
        self.coordinate = coordinate
        self.id = id
        self.line = line
        rawData = nil
    }
    
    init?(dictionary: JSONDictionary) {
        guard let
            latitude = extract("latitud", fromDictionary: dictionary),
            longitude = extract("longitud", fromDictionary: dictionary),
            id = dictionary["formacion_id"] as? Int,
            line = dictionary["ramal"] as? Int
            else {
                NSLog("couldn't find something")
                self.id = ""
                self.coordinate = kCLLocationCoordinate2DInvalid
                self.line = -1
                rawData = nil
                super.init()
                return nil
        }
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.id = "\(id)"
        self.line = line
        rawData = dictionary
        super.init()
    }
}

extension TrainLocation: MKAnnotation {
    var title: String? { return "ramal \(line)" }
}
