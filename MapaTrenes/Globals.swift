//
//  Globals.swift
//  MapaTrenes
//
//  Created by Nicolas Ameghino on 1/22/16.
//  Copyright © 2016 Nicolas Ameghino. All rights reserved.
//

import Foundation

func createError(code: Int, message: String) -> ErrorType {
    return NSError(domain: "TrainMapErrorDomain", code: code, userInfo: [NSLocalizedDescriptionKey: message])
}
