//
//  NetworkRequest.swift
//  ISSCodingChallenge
//
//  Created by Ryan Sander on 2/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

/** Model to parse network request object sent back with a Pass request. */
struct PassNetworkRequest: Codable {
    var altitude: Int
    var datetime: Int
    var latitude: Float
    var longitude: Float
    var passes: Int
}
