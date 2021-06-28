//
//  BottomNavigationButton.swift
//  moody
//
//  Created by bart Shin on 21/06/2021.
//

import SwiftUI

struct BottomNavigation: ButtonStyle {
	
	let size: CGFloat = 50
	
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.clipShape(Circle())
			.frame(width: size, height: size)
			.scaleEffect(configuration.isPressed ? 1.2: 1)
			.animation(.easeInOut, value: configuration.isPressed)
	}
}


