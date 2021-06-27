//
//  ImageEditor.swift
//  moody
//
//  Created by bart Shin on 21/06/2021.
//

import CoreImage
import SwiftUI
import PencilKit

class ImageEditor: NSObject, ObservableObject {
	
	static var forPreview: ImageEditor {
		let editor = ImageEditor()
		editor.setNewImage(UIImage(named: "selfie_dummy")!)
		return editor
	}
	
	private(set) var originalImage: CGImage?
	private var imageOrientation: UIImage.Orientation?
	var imageForDisplay: UIImage?
	var blurMask: PKCanvasView
	var blurIntensity: Double
	@Published var blurMarkerWidth: CGFloat
	
	var colorControl: [ImageColorControl: Double] {
		didSet {
			setImageForDisplay()
		}
	}
	
	var delegate: EditorDelegation?
	private lazy var ciContext = CIContext(options: nil)
	
	func setNewImage(_ image: UIImage) {
		originalImage = image.cgImage
		imageOrientation = image.imageOrientation
		setImageForDisplay()
	}
	
	func applyColorFilter() -> CIImage? {
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
	
	func applyBlurByMask() {
		let sourceImage = CIImage(cgImage: originalImage!)
		guard let mask = CIImage(image: blurMask.drawing.image(from: sourceImage.extent, scale: 1)) else {
			assertionFailure("Fail to create mask image")
			return
		}
		let blurFilter = CIFilter(name: "CIMaskedVariableBlur")!
		blurFilter.setValue(mask, forKey: "inputMask")
		blurFilter.setValue(sourceImage, forKey: kCIInputImageKey)
		blurFilter.setValue(blurIntensity, forKey: kCIInputRadiusKey)
		if let outputImage = blurFilter.outputImage,
		   let cgImage = ciContext.createCGImage(outputImage, from: sourceImage.extent) {
			originalImage = cgImage
			setImageForDisplay()
		}else {
			print("Fail to apply blur")
		}
	}
	
	func saveImage() {
		guard imageForDisplay != nil else {
			savingCompletion(UIImage(),
							 didFinishSavingWithError: ProcessError.convertingError, contextInfo: nil)
			return
		}
		UIImageWriteToSavedPhotosAlbum(imageForDisplay!, self,
									   #selector(savingCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
	}
	
	@objc fileprivate func savingCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer?) {
		delegate?.savingCompletion(error: error)
	}
	
	private func setImageForDisplay() {
		if let ciImage = applyColorFilter(),
			  let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent),
			  imageOrientation != nil{
			imageForDisplay = UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation!)
		}
		publishOnMainThread()
	}
	
	private func publishOnMainThread() {
		if Thread.isMainThread {
			objectWillChange.send()
		}else {
			DispatchQueue.main.async {
				self.objectWillChange.send()
			}
		}
	}
	
	enum ProcessError: Error {
		case convertingError
	}
	
	override init() {
		colorControl = ImageColorControl.defaults
		blurMask = PKCanvasView()
		blurIntensity = 10
		blurMarkerWidth = 30
		super.init()
		blurMask.delegate = self
	}
}

extension ImageEditor: PKCanvasViewDelegate {
	func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
		guard !canvasView.drawing.strokes.isEmpty else {
			return
		}
		DispatchQueue.global(qos: .userInitiated).async {
			self.applyBlurByMask()
		}
	}
}

protocol EditorDelegation {
	func savingCompletion(error: Error?) -> Void
}
