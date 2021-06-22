//
//  TuningPanel.swift
//  moody
//
//  Created by bart Shin on 21/06/2021.
//

import SwiftUI

struct TuningPanel: View {
	
	@State private var currentTuneFactor = ImageTuneFactor.brightness
	@Binding var tuneAdjustment: [ImageTuneFactor: Double]
	
	private var bindingToCurrentFactor:  Binding<Double> {
		 Binding<Double> {
			tuneAdjustment[currentTuneFactor] ?? 0.5
		} set: {
			tuneAdjustment[currentTuneFactor] = $0
		}
	}
	
	var body: some View {
		
		VStack {
			HStack {
				ForEach(ImageTuneFactor.allCases, id: \.rawValue) {
					drawButton(for: $0)
				}
			}
			sliderLabel
			Slider(value: bindingToCurrentFactor, in: 0...1) {
				// For accessbility
				sliderLabel
			}
		}
		.padding(.horizontal, Constant.horizontalPadding)
		.padding(.vertical, Constant.verticalPadding)
	}
	
	private func drawButton(for tuneFactor: ImageTuneFactor) -> some View {
		Button(action: {
			withAnimation{
				currentTuneFactor = tuneFactor
			}
		}) {
			tuneFactor.label
		}
		.buttonStyle(BottomNavigation())
		.foregroundColor(tuneFactor == currentTuneFactor ? .yellow: .white)
		.scaleEffect(tuneFactor == currentTuneFactor ? 1.3: 1)
		.padding(.horizontal)
	}
	
	private var sliderLabel: some View {
		Text(currentTuneFactor.rawValue)
			.foregroundColor(.blue)
	}
	
	struct Constant {
		static let horizontalPadding: CGFloat = 50
		static let verticalPadding: CGFloat = 100
	}
}

struct ImageTuningPanel_Previews: PreviewProvider {
    static var previews: some View {
		TuningPanel(tuneAdjustment: Binding.constant(ImageTuneFactor.defaults))
    }
}
