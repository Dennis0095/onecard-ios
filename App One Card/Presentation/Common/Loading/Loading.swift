//
//  Loading.swift
//  App One Card
//
//  Created by Paolo Arambulo on 13/06/23.
//

import UIKit
import Lottie

class Loading: UIViewController {
    
    static let shared = Loading()
    
    @IBOutlet weak var animationView: UIView!
    private var lottieAnimationView: LottieAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        if let animationPath = Bundle.main.path(forResource: "loading", ofType: "json") {
            let animationURL = URL(fileURLWithPath: animationPath)
            lottieAnimationView = LottieAnimationView(url: animationURL) { _ in }
            
            if let animationView = self.lottieAnimationView {
                animationView.loopMode = .loop
                animationView.animationSpeed = 1.5
                animationView.backgroundBehavior = .pauseAndRestore
                
                self.animationView.addSubview(animationView)
                
                animationView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    animationView.topAnchor.constraint(equalTo: self.animationView.topAnchor),
                    animationView.leadingAnchor.constraint(equalTo: self.animationView.leadingAnchor),
                    animationView.trailingAnchor.constraint(equalTo: self.animationView.trailingAnchor),
                    animationView.bottomAnchor.constraint(equalTo: self.animationView.bottomAnchor)
                ])
            }
        }
    }
    
    func show() {
        guard let keyWindow = UIWindow.key else {
            return
        }
        
        self.modalPresentationStyle = .overFullScreen
        keyWindow.rootViewController?.present(self, animated: false) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.lottieAnimationView?.play()
            }
        }
    }
    
    func hide(completion: VoidActionHandler? = nil) {
        lottieAnimationView?.stop()
        DispatchQueue.main.async {
            self.dismiss(animated: false) {
                completion?()
            }
        }
    }
}
