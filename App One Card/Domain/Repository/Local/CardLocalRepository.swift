//
//  CardLocalRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/07/23.
//

import Combine

protocol CardLocalRepository {
    func saveStatus(status: String?)
    func getStatus() -> String?
}
