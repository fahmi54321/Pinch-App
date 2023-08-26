//
//  PageModel.swift
//  Pinch App
//
//  Created by Fahmi Aziz on 26/08/23.
//

import Foundation

struct Page: Identifiable{
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
