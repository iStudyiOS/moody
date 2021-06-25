//
//  ImageEditor.swift
//  moody
//
//  Created by bart Shin on 21/06/2021.
//

import CoreImage
import SwiftUI

class ImageEditor: NSObject, ObservableObject {
	
	private var originalImage: CGImage?
	private var editingImage: CIImage? {
		didSet {
			if Thread.isMainThread {
				objectWillChange.send()
			}else {
				DispatchQueue.main.async {
					self.objectWillChange.send()
				}
			}
		}
	}
	var currentImage: CGImage? {
		if editingImage != nil {
			return ciContext.createCGImage(editingImage!, from: editingImage!.extent)
		}else {
			return nil
		}
	}
	var colorControl = ImageColorControl.defaults {
		didSet {
			DispatchQueue.global(qos: .userInitiated).async { [self] in
				editingImage = captureImage()
			}
		}
	}
	
	var delegate: EditorDelegation?
	private lazy var ciContext = CIContext(options: nil)
	
	func setNewImage(_ image: UIImage) {
		originalImage = image.cgImage
		editingImage = CIImage(image: image)
	}
	
	func captureImage() -> CIImage? {
		guard originalImage != nil else {
			assertionFailure("Try to save image not exist")
			return nil
		}
		let colorControlFilter = createColorControlFilter()
		colorControlFilter.setValue(CIImage(cgImage: originalImage!),
									forKey: "inputImage")
		return colorControlFilter.outputImage
	}
		
	fileprivate func createColorControlFilter() -> CIFilter {
		let filter = CIFilter(name: "CIColorControls")!
		filter.setValue(colorControl[.brightness], forKey: kCIInputBrightnessKey)
		filter.setValue(colorControl[.contrast], forKey: kCIInputContrastKey)
		filter.setValue(colorControl[.saturation], forKey: kCIInputSaturationKey)
		return filter
	}
	
	func saveImage() {
		guard currentImage != nil ,
			  let image = ciContext.createCGImage(editingImage!, from: editingImage!.extent) else {
			savingCompletion(UIImage(),
							 didFinishSavingWithError: ProcessError.convertingError, contextInfo: nil)
			return
		}
		UIImageWriteToSavedPhotosAlbum(UIImage(cgImage: image), self,
									   #selector(savingCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
	}
	
	@objc fileprivate func savingCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer?) {
		delegate?.savingCompletion(error: error)
	}
	
	enum ProcessError: Error {
		case convertingError
	}
}

protocol EditorDelegation {
	func savingCompletion(error: Error?) -> Void
}
