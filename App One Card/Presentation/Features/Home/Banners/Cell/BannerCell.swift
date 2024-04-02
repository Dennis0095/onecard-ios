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
    }

    func setData(banner: BannerResponse) {
        ivwBanner.base64ToImage(base64String: banner.bannerImage ?? "")
    }
    
}
