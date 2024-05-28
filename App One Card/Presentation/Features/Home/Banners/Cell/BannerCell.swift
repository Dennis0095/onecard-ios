//
//  BannerCell.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 6/03/24.
//

import UIKit

class BannerCell: UICollectionViewCell {

    @IBOutlet weak var ivwBanner: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        ivwBanner.layer.masksToBounds = true
        ivwBanner.layer.cornerRadius = 4
    }

    func setData(banner: BannerResponse) {
        ivwBanner.base64ToImage(base64String: banner.bannerImage ?? "")
    }
    
}
