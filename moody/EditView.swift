//
//  EditView.swift
//  moody
//
//  Created by bart Shin on 21/06/2021.
//

import SwiftUI
import Combine

struct EditView: View {
	
	@EnvironmentObject var editor: ImageEditor
	@State private var tuneAdjustment = ImageTuneFactor.defaults
	@State private var isShowingPicker = false
	
    var body: some View {
		VStack {
			if editor.currentImage != nil {
				ScrollView([.vertical, .horizontal],
						   showsIndicators: false) {
					editingImage
						.applyTuning(tuneAdjustment)
				}
			}
			Spacer()
			TuningPanel(tuneAdjustment: $tuneAdjustment)
				.onChange(of: isShowingPicker, perform: resetTunner(_:))
		}
		.toolbar{
			ToolbarItem(placement: .navigationBarTrailing,
						content: drawPickerButton)
		}
		.sheet(isPresented: $isShowingPicker) {
			imagePicker
		}
		.navigationTitle("Edit")
    }
	
	private func resetTunner(_ pickerPresenting: Bool) {
		guard !pickerPresenting,
				 editor.currentImage != nil else {
			return
		}
		withAnimation {
			tuneAdjustment = ImageTuneFactor.defaults
		}
	}
	
	private func drawPickerButton() -> some View {
		Button(action: {
				isShowingPicker.toggle()
		}) {
			Image(systemName: "photo")
				.font(.title2)
		}
		.onAppear {
			if editor.currentImage == nil {
				DispatchQueue.main.async {
					isShowingPicker = true
				}
			}
		}
	}
	
	private var imagePicker: ImagePicker {
		ImagePicker(
		picker: $isShowingPicker,
		imageData: Binding<Data>.constant(Data()),
		passImage: editor.pickNewImage)
	}
	
	private var editingImage: some View {
		Image(uiImage: editor.currentImage!)
			.resizable()
			.aspectRatio(contentMode: .fit)
			.frame(width: UIScreen.main.bounds.width)
	}
	
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
