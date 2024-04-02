//
//  ConsultBannersResponse.swift
//  App One Card
//
//  Created by Paolo Arámbulo on 6/03/24.
//

import Foundation

struct ConsultBannersResponse: Codable {
    let rc: String?
    let rcDesc: String?
    let quantityBanners: String?
    let banners: [BannerResponse]?
    let title: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case rc = "RC"
        case rcDesc = "RC_DESC"
        case quantityBanners = "CANTIDAD_BANNERS_APP"
        case banners = "BANNERS"
        case title = "TITULO"
        case message = "MENSAJE"
    }
}
