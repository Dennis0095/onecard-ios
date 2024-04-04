//
//  Loading.swift
//  App One Card
//
//  Created by Paolo Arambulo on 13/06/23.
//

import UIKit
import Lottie

class Loading: UIView {

    private var animationView: LottieAnimationView = {
        if let animationPath = Bundle.main.path(forResource: "loading", ofType: "json") {
            let view = LottieAnimationView(filePath: animationPath)
            view.backgroundColor = .clear
            view.loopMode = .loop
            view.animationSpeed = 1.5
            view.backgroundBehavior = .pauseAndRestore
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        } else {
            let view = LottieAnimationView()
            view.backgroundColor = .clear
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6021205357)
        self.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalToConstant: 120),
            animationView.widthAnchor.constraint(equalToConstant: 120),
            animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        animationView.play()
    }

    func dismiss(completion: VoidActionHandler? = nil) {
        animationView.stop()
        removeFromSuperview()
    }
    
}
