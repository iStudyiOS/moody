//
//  ImagePicker.swift
//  moody
//
//  Created by 김두리 on 2021/06/18.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(parent: self)
    }
    
    
    @Binding var picker: Bool
    @Binding var imageData: Data
	let passImage: ((UIImage) -> Void)?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let picker = PHPickerViewController(configuration: PHPickerConfiguration())
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context){
         
    }
    
    
    class Coordinator : NSObject, PHPickerViewControllerDelegate {
        
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
		}
		
		func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
			// checking image is selected or cacelled
			
			if !results.isEmpty {
				// checking image can be loaded
				if results.first!.itemProvider.canLoadObject(ofClass: UIImage.self){
					results.first!.itemProvider.loadObject(ofClass: UIImage.self) { [self]
						(image, error) in
						if error == nil,
						   let uiImage = image as? UIImage {
							parent.passImage?(uiImage)
						}
						DispatchQueue.main.async {
							self.parent.imageData = (image as! UIImage).pngData()!
							self.parent.picker.toggle()
						}
					}
				}
			}else {
				self.parent.picker.toggle()
			}
        }
    }
	
	init(picker: Binding<Bool>, imageData: Binding<Data>, passImage: ((UIImage) -> Void)? = nil ) {
		self._picker = picker
		self._imageData = imageData
		self.passImage = passImage
	}
}

