//
//  GeneralSessionManager.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 9/05/24.
//

import Foundation

protocol GeneralSessionManagerProtocol {
    func saveLink(link: String?, key: String)
    func getLink(key: String) -> String
}

class GeneralSessionManager: GeneralSessionManagerProtocol {
    
    static let shared = GeneralSessionManager()
    
    private init() {}

    func saveLink(link: String?, key: String) {
        if let link = link {
            UserDefaults.standard.set(link, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getLink(key: String) -> String {
        return UserDefaults.standard.string(forKey: key) ?? ""
    }
}
