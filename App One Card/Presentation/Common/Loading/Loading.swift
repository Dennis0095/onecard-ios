//
//  Loading.swift
//  App One Card
//
//  Created by Paolo Arambulo on 13/06/23.
//

import UIKit
import Lottie

class LoadingView: UIView {

    private lazy var animationView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var lottieAnimationView: LottieAnimationView?

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
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.lottieAnimationView?.play()
//        }
        self.lottieAnimationView?.play()
    }

    func dismiss(completion: VoidActionHandler? = nil) {
        lottieAnimationView?.stop()
        removeFromSuperview()
    }
    
}
