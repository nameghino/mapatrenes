//
//  TrainMapAPI.swift
//  MapaTrenes
//
//  Created by Nicolas Ameghino on 1/22/16.
//  Copyright © 2016 Nicolas Ameghino. All rights reserved.
//

import Foundation
import RxSwift

class TrainMapAPI {
    enum Errors: ErrorType, CustomStringConvertible {
        case JSONParsingError(NSURL)
        
        var code: Int {
            switch self {
            case .JSONParsingError: return -1000
            }
        }
        
        var description: String {
            switch self {
            case .JSONParsingError (let url): return "Error parsing JSON at URL: \(url.absoluteString)"
            }
        }
    }
    
    static let instance = TrainMapAPI()
    static let key = "v%23v%23QTUtWp%23MpWRy80Q0knTE10I30kj%23FNyZ"
    static let endpoint: NSURL = {
        let s = "http://trenes.mininterior.gov.ar/v2_pg/mapas/ajax_posiciones.php"
        guard let url = NSURL(string: s) else { fatalError("could not create URL") }
        return url
    }()
    
    private var randomString: String {
        func randomString(length: Int) -> String {
            let source = NSString(string: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz")
            return Array(0..<length).map {
                _ -> String in
                let r = Int(arc4random_uniform(UInt32(source.length)))
                let c = Character(UnicodeScalar(source.characterAtIndex(r)))
                return "\(c)"
                }.reduce("", combine: +)
        }
        return randomString(16)
    }
    
    func trainLocationsForLine(line: Int, updateInterval: NSTimeInterval) -> Observable<[TrainLocation]> {
        let targetURL: NSURL = {
            let components = NSURLComponents(URL: TrainMapAPI.endpoint, resolvingAgainstBaseURL: false)
            
            components?.queryItems = [
                NSURLQueryItem(name: "ramal", value: "\(line)"),
                NSURLQueryItem(name: "rnd", value: randomString),
                NSURLQueryItem(name: "key", value: TrainMapAPI.key),
                
            ]
            
            return components!.URL!
        }()
        
        let request: NSURLRequest = {
            let r = NSMutableURLRequest(URL: targetURL)
            r.setValue("http://trenes.mininterior.gov.ar/", forHTTPHeaderField: "Referer")
            return r
        }()
        
        
        NSLog("target: \(request.URL!.absoluteString)")
        
        return NSURLSession.sharedSession().rx_JSON(request).map {
            o in
            guard let dicts = o as? [JSONDictionary] else {
                fatalError()
            }
            return dicts.flatMap { TrainLocation(dictionary: $0) }
        }        
    }
}