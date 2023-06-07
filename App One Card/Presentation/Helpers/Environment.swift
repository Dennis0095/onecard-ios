//
//  Environment.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import Foundation

public enum PlistKey: String {
    case BaseUrl = "base_url"

//    func value() -> String {
//        switch self {
//        case .InkafarmaURL:
//            return "inkafarma_url"
//        }
//    }
}

public class Environment {
    
    lazy var infoDict: [String: Any]  = {
        if let dict = Bundle.main.infoDictionary {
            return dict
        } else {
            fatalError("Plist file not found")
        }
    }()
  
    public func configuration(_ key: PlistKey) -> String {
        if let str = infoDict[key.rawValue] as? String {
            return str
        } else {
            return ""
        }
    }
    
//    func googleServiceInfo(key: String) -> Any? {
//        let plistURL = Bundle.main.url(forResource: "GoogleService-Info", withExtension: "plist")!
//        let dictionary = NSDictionary(contentsOf: plistURL)
//        return dictionary?[key]
//    }
}

