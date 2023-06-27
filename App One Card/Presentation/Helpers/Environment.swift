//
//  Environment.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import Foundation

public enum PlistKey: String {
    case baseUrl
    
    func value() -> String {
        switch self {
        case .baseUrl:
            return "base_url"
        }
    }
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
        if let str = infoDict[key.value()] as? String {
            return str
        } else {
            return ""
        }
    }
}

