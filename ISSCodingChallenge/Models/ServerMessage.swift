//
//  ServerMessage.swift
//  ISSCodingChallenge
//
//  Created by Ryan Sander on 2/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

/** Model for server messages for errors. Could have used NetworkResponse, but I thought this was cleaner from the implementation side. */
struct ServerMessage: Codable {
    var message: String
    var reason: String
}
