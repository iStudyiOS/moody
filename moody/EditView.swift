//
//  EditView.swift
//  moody
//
//  Created by bart Shin on 21/06/2021.
//

import SwiftUI

struct EditView: View, EditorDelegation {
	
	@EnvironmentObject var editor: ImageEditor
	@State private var isShowingPicker = false
	@State private var feedBackImage: Image?
	@State private var currentControl: String = ImageColorControl.brightness.rawValue
	
    var body: some View {
		ZStack {
			VStack(spacing: 0) {
				EditingImage(currentControl: $currentControl) 
					.contentShape(Rectangle())
				TuningPanel(currentControl: $currentControl)
					.onChange(of: isShowingPicker, perform: resetTunner(_:))
					.disabled(editor.imageForDisplay == nil)
			}
			FeedBackView(feedBackImage: $feedBackImage)
		}
		.toolbar{
			ToolbarItem(placement: .navigationBarLeading, content: drawSaveButton)
			ToolbarItem(placement: .navigationBarTrailing,
						content: drawPickerButton)
		}
		.sheet(isPresented: $isShowingPicker, content: createImagePicker)
		.onAppear (perform: showPickerIfNeeded)
		.navigationTitle("Edit")
    }
	
	private func drawSaveButton() -> some View {
		Button(action: {
			editor.saveImage()
		}) {
			Text("SAVE")
				.font(.title)
		}
	}
	
	private func drawPickerButton() -> some View {
		Button(action: {
			isShowingPicker = true
		}) {
			Image(systemName: "photo")
				.font(.title2)
		}
	}
	
	private func createImagePicker () -> ImagePicker {
		ImagePicker(
			picker: $isShowingPicker,
			imageData: Binding<Data>.constant(Data()),
			passImage: editor.setNewImage)
	}
	
	private func resetTunner(_ pickerPresenting: Bool) {
		guard !isShowingPicker else { return }
		withAnimation {
			editor.colorControl = ImageColorControl.defaults
		}
	}
	
	private func showPickerIfNeeded() {
		guard editor.delegate == nil else {
			return 
		}
		editor.delegate = self
		if editor.imageForDisplay == nil {
			DispatchQueue.main.async {
				isShowingPicker = true
			}
		}
	}
	
	// Editor delegation
	func savingCompletion(error: Error?) {
		if error == nil {
			withAnimation{
				feedBackImage = Image(systemName: "checkmark")
			}
		}else {
			print("Fail to save image: \(error!.localizedDescription)")
		}
	}
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
			.environmentObject(ImageEditor.forPreview)
    }
}
