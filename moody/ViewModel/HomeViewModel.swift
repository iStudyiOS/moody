//
//  HomeViewModel.swift
//  moody
//
//  Created by 김두리 on 2021/06/18.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

class HomeViewModel: ObservableObject {
    @Published var imagePicker = false
    @Published var imageData = Data(count: 0)
    
    @Published var allImages: [FilteredImage] = []
    

    // main editing image
    @Published var mainView : FilteredImage!

    
    // loading filterOption WhenEver Image is Selected
    let filters: [CIFilter] = [
        CIFilter.sepiaTone(), CIFilter.comicEffect(), CIFilter.colorInvert(), CIFilter.photoEffectFade(), CIFilter.colorMonochrome(),
        CIFilter.photoEffectChrome(), CIFilter.gaussianBlur(),CIFilter.bloom()
    ]
    
    func loadFilter() {
        
        let context = CIContext()
        
        filters.forEach { (filter) in
            DispatchQueue.global(qos: .userInteractive).async {
                // loading iamge into filter
                let CiImage = CIImage(data: self.imageData)
                
                filter.setValue(CiImage!, forKey: kCIInputImageKey)
                //retreving image
                
                
                guard let newImage = filter.outputImage else {
                    return
                }
                
                let cgimage = context.createCGImage(newImage, from: newImage.extent)
                let filteredData = FilteredImage(image: UIImage(cgImage: cgimage!), filter: filter)
                
                DispatchQueue.main.async {
                    self.allImages.append(filteredData)
                    
                    // default Image
                    if self.mainView == nil {
                        self.mainView = self.allImages.first
                    }
                }
            }
        }
    }
}

