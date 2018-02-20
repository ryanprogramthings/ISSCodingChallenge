//
//  URLHeader.swift
//  ISSCodingChallenge
//
//  Created by Ryan Sander on 2/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

/** Struct for URL header constants. */
struct URLHeader {
    /* For now I'm namespacing these by Key and Value. I'm not sure if I like it, but it's a good starting point. */
    struct Key {
        static let contentType = "Content-Type"
    }
    
    struct Value {
        static let json = "Application/json"
    }
}
