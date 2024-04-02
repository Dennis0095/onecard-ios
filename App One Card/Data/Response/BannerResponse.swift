//
//  BannerResponse.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 6/03/24.
//

import Foundation

struct BannerResponse: Codable {
    let bannerCode: String?
    let bannerImage: String?
    let link: String?
    
    enum CodingKeys: String, CodingKey {
        case bannerCode = "CODIGO_BANNER"
        case bannerImage = "IMAGEN_BANNER"
        case link = "ENLACE"
    }
}
