//
//  UserObserver.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/07/23.
//

import Combine
import Foundation

protocol UserObserverProtocol {
    var userSessionPublisher: Published<User?>.Publisher { get }
    var listenChanges: ((_ user: User) -> Void)? { get }
    
    func update(user: User?)
    func bindPublishers()
}

class UserObserver: UserObserverProtocol {
        
    static let shared = UserObserver()
    
    @Published private var userSession: User?
    private var cancellables: Set<AnyCancellable> = []
    
    var userSessionPublisher: Published<User?>.Publisher { $userSession }
    var listenChanges: ((_ user: User) -> Void)?
    
    private init() {
        bindPublishers()
    }
    
    func update(user: User?) {
        userSession = user
    }
    
    func getUser() -> User? {
        return self.userSession
    }
    
    func bindPublishers() {
        userSessionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                if let u = user {
                    if let action = self?.listenChanges {
                        action(u)
                    }
                }
            }
            .store(in: &cancellables)
    }
}
