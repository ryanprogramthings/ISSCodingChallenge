//
//  AstronautNetworkResponse.swift
//  ISSCodingChallenge
//
//  Created by Ryan Sander on 2/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

/* After seeing the passes endpoint, I anticipated the services to have the same response structure. This endpoint does not come back the same, so I created this object for the response. */
struct AstronautNetworkResponse: Codable {
    var number: Int
    var people: [Astronaut]
    var message: String
}
