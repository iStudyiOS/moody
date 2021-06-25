//
//  TuningPanel.swift
//  moody
//
//  Created by bart Shin on 21/06/2021.
//

import SwiftUI

struct TuningPanel: View {
	
	@EnvironmentObject var editor: ImageEditor
	@State private var currentColorControl = ImageColorControl.brightness
	
	private var bindingToCurrentControl:  Binding<Double> {
		 Binding<Double> {
			editor.colorControl[currentColorControl]!
		} set: {
			editor.colorControl[currentColorControl] = $0
		}
	}
	
	var body: some View {
		
		VStack {
			HStack {
				ForEach(ImageColorControl.allCases, id: \.rawValue) {
					drawButton(for: $0)
				}
			}
			sliderLabel
			Slider(value: bindingToCurrentControl, in: 0...1) {
				// For accessbility
				sliderLabel
			}
		}
		.padding(.horizontal, Constant.horizontalPadding)
		.padding(.vertical, Constant.verticalPadding)
	}
	
	private func drawButton(for tuneFactor: ImageColorControl) -> some View {
		Button(action: {
			withAnimation{
				currentColorControl = tuneFactor
			}
		}) {
			tuneFactor.label
		}
		.buttonStyle(BottomNavigation())
		.foregroundColor(tuneFactor == currentColorControl ? .yellow: .white)
		.scaleEffect(tuneFactor == currentColorControl ? 1.3: 1)
		.padding(.horizontal)
	}
	
	private var sliderLabel: some View {
		Text(currentColorControl.rawValue)
			.foregroundColor(.blue)
	}
	
	struct Constant {
		static let horizontalPadding: CGFloat = 50
		static let verticalPadding: CGFloat = 30
	}
}

struct ImageTuningPanel_Previews: PreviewProvider {
    static var previews: some View {
		TuningPanel()
    }
}
