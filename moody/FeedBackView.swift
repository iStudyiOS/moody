//
//  FeedBackView.swift
//  moody
//
//  Created by bart Shin on 24/06/2021.
//

import SwiftUI

struct FeedBackView: View {
	@Binding var feedBackImage: Image?
	
	private var size: CGFloat {
		min(UIScreen.main.bounds.width * 0.5, UIScreen.main.bounds.height * 0.5)
	}
	
	var body: some View {
		
		if feedBackImage != nil {
			feedBackImage!
				.resizable()
				.scaledToFit()
				.frame(width: size, height: size)
				.padding(size * 0.3)
				.overlay(Circle()
							.stroke(lineWidth: 5))
				.foregroundColor(.white)
				.onAppear(perform: hideFeedback)
		}
	}
	
	private func hideFeedback() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			withAnimation {
				feedBackImage = nil
			}
		}
	}
}

