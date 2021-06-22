//
//  ImageEditor.swift
//  moody
//
//  Created by bart Shin on 21/06/2021.
//

import CoreImage
import UIKit

class ImageEditor: ObservableObject {
	private(set) var currentImage: UIImage?
	
	func pickNewImage(_ image: UIImage) {
		currentImage = image
		if Thread.isMainThread {
			objectWillChange.send()
		}else {
			DispatchQueue.main.async {
				self.objectWillChange.send()
			}
		}
	}
}
