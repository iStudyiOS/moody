//
//  TuningPanel.swift
//  moody
//
//  Created by bart Shin on 21/06/2021.
//

import SwiftUI

struct TuningPanel: View {
	
	@EnvironmentObject var editor: ImageEditor
	@Binding var currentControl: String

	var body: some View {
		
		VStack {
			HStack {
				ForEach(ImageColorControl.allCases, id: \.rawValue) {
					drawButton(for: $0)
				}
				blurButton
			}
			controlLabel
			if let colorControl = ImageColorControl(rawValue: currentControl) {
				drawSlider(for: colorControl)
			}else {
				blurControlSlider
			}
		}
		.padding(.horizontal, Constant.horizontalPadding)
		.padding(.vertical, Constant.verticalPadding)
	}
	
	private var controlLabel: some View {
		Text(currentControl)
			.foregroundColor(.blue)
	}
	
	private var blurButton: some View {
		Button(action: {
			withAnimation {
				currentControl = ImageBlurControl.mask.rawValue
			}
		}) {
			Image(systemName: "lasso")
		}
		.buttonStyle(BottomNavigation())
		.foregroundColor(currentControl == ImageBlurControl.mask.rawValue ? .yellow: .white)
		.scaleEffect(currentControl == ImageBlurControl.mask.rawValue ? 1.3: 1)
	}
	
	private var blurControlSlider: some View {
		VStack {
			HStack {
				Text("강도")
				Slider(value: $editor.blurIntensity, in: 0...20, step: 1)
			}
			HStack {
				Text("범위")
				Slider(value: $editor.blurMarkerWidth, in: 10...60, step: 5)
			}
		}
		.padding()
	}
	
	private func drawButton(for colorControl: ImageColorControl) -> some View {
		Button(action: {
			withAnimation{
				currentControl = colorControl.rawValue
			}
		}) {
			colorControl.label
		}
		.buttonStyle(BottomNavigation())
		.foregroundColor(colorControl.rawValue == currentControl ? .yellow: .white)
		.scaleEffect(colorControl.rawValue == currentControl ? 1.3: 1)
		.padding(.horizontal)
	}
		
	private func drawSlider(for colorControl: ImageColorControl) -> some View {
		Slider(value: createBinding(to: colorControl), in: -0.5...0.5,
			   step: 0.05) {
			// For accessbility
			controlLabel
		}
	}
	
	private func createBinding(to colorControl: ImageColorControl) -> Binding<Double> {
		Binding<Double> {
			editor.colorControl[colorControl]! - colorControl.defaultValue
		} set: {
			editor.colorControl[colorControl] = $0 + colorControl.defaultValue
		}
	}

	
	struct Constant {
		static let horizontalPadding: CGFloat = 50
		static let verticalPadding: CGFloat = 30
	}
	
}

struct ImageTuningPanel_Previews: PreviewProvider {
    static var previews: some View {
		TuningPanel(currentControl: Binding<String>.constant(ImageColorControl.brightness.rawValue))
    }
}
