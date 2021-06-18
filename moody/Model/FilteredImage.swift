//
//  FilteredImage.swift
//  moody
//
//  Created by 김두리 on 2021/06/18.
//

import SwiftUI
import CoreImage

struct FilteredImage: Identifiable {
    var id = UUID().uuidString
    var image: UIImage
    var filter: CIFilter
}

