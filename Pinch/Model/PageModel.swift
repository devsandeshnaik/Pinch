//
//  PageModel.swift
//  Pinch
//
//  Created by Sandesh Naik on 19/06/23.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailName: String {
        "thumb-" + imageName
    }
}
