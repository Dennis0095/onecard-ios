//
//  AppDelegate.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var countTimer: Timer?
    var appRouter: Router?
    var window: UIWindow?
    var count: Int = 0
    private let endTime: Int = 300
    private let questionTime: Int = 260

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let logoutRepository = LogoutDataRepository()
        let logoutUseCase = LogoutUseCase(repository: logoutRepository)
        appRouter = AppRouter(window: window!, logoutUseCase: logoutUseCase)
        appRouter?.start()
        
        return true
    }


    func applicationDidEnterBackground(_ application: UIApplication) {
        backgroundTask = application.beginBackgroundTask { [weak self] in
            // Clean up the background task and timer when it expires
            self?.endBackgroundTask()
            self?.invalidateTimer()
        }
        
        guard let _ = UserSessionManager.shared.getUser() else {
            return
        }
        
        resumeTimer()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        endBackgroundTask()
        invalidateTimer()
        
        guard let _ = UserSessionManager.shared.getUser() else {
            return
        }
        
        resumeTimer()
    }
    
    func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    func resetTimer() {
        count = 0
        invalidateTimer()

        guard let _ = UserSessionManager.shared.getUser() else {
            return
        }
        
        countTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            count += 1
            if self.count == questionTime {
                appRouter?.confirmInactivity(closeSession: {
                    self.invalidateTimer()
                    self.appRouter?.logout(isManual: true)
                }, accept: {
                    self.resetTimer()
                })
            } else if self.count == endTime {
                self.invalidateTimer()
                appRouter?.logout(isManual: false)
            }
        }
    }
    
    func invalidateTimer() {
        countTimer?.invalidate()
    }
    
    func resumeTimer() {
        invalidateTimer()
        if count < endTime {
            countTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                count += 1
                if self.count == questionTime {
                    appRouter?.confirmInactivity(closeSession: {
                        self.invalidateTimer()
                        self.appRouter?.logout(isManual: true)
                    }, accept: {
                        self.resetTimer()
                    })
                } else if self.count == endTime {
                    self.invalidateTimer()
                    appRouter?.logout(isManual: false)
                }
            }
        } else {
            self.invalidateTimer()
            appRouter?.logout(isManual: false)
        }
    }
}

