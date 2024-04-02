//
//  ImageViewExtension.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 14/03/24.
//

import UIKit

extension UIImageView {
    func base64ToImage(base64String: String) {
        if let imageData = Data(base64Encoded: base64String) {
            // Create an UIImage from the Data
            if let image = UIImage(data: imageData) {
                // Now you have your image
                // You can display it, save it, or use it as needed
                self.image = image
            } else {
                print("Error creating UIImage from Data")
            }
        }
    }
}
