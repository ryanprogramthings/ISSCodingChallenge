//
//  NetworkResponse.swift
//  ISSCodingChallenge
//
//  Created by Ryan Sander on 2/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

/** Model to parse API network response for a supplied Request and Response Codable type. */
struct NetworkResponse<T: Codable, U: Codable>: Codable {
    var message: String
    /** Optional value for when server error returns. */
    var reason: String?
    var request: T
    var response: U
}
