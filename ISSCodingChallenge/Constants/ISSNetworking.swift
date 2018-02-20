//
//  ISSNetworking.swift
//  ISSCodingChallenge
//
//  Created by Ryan Sander on 2/20/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

/** Constants struct for networking */
struct ISSNetworking {
    /* We don't have environments in this example, but this is where those constants would live. */
    private struct Domain {
        private static let dev = "api.open-notify.org"
        private static let qa = "api.open-notify.org"
        private static let uat = "api.open-notify.org"
        private static let prod = "api.open-notify.org"
        
        /* Hardcoding this for now, but this value would be accessed from the scheme the app is built with. */
        static func currentEnvironment() -> String {
            return dev
        }
    }
    
    /* Everything for this API does not have a route like "/api" or "/v2/api". In a production app, this is where environment specific or different routes for the API would live. */
    private struct Route {
        static let api = "" // example could be "/api"
    }
    
    private static let baseURL = Domain.currentEnvironment() + Route.api
    
    /** URL to get ISS passes. */
    static func passesURL(lat: Double, long: Double) -> URL {
        var urlComponents = URLComponents()
        /* Would normally make this variable based off environment, because production environment should not use http */
        urlComponents.scheme = "http"
        urlComponents.host = Domain.currentEnvironment()
        urlComponents.path = "/iss-pass.json"
        
        let latQueryParam = URLQueryItem(name: "lat", value: String(lat))
        let longQueryParam = URLQueryItem(name: "lon", value: String(long))
        
        urlComponents.queryItems = [latQueryParam, longQueryParam]
        
        guard let url = urlComponents.url else {
            /* Should crash if this can't construct so it is clear where this happens since the app relies on this to function. */
            fatalError("Could not construct URL for passes endpoint.")
        }
        
        return url
    }
    
    static var astronautsURL: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = Domain.currentEnvironment()
        urlComponents.path = "/astros.json"
        
        guard let url = urlComponents.url else {
            /* Should crash if this can't construct so it is clear where this happens since the app relies on this to function. */
            fatalError("Could not construct URL for astros endpoint.")
        }
        
        return url
    }
}
