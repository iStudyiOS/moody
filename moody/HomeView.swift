//
//  Home.swift
//  moody
//
//  Created by 김두리 on 2021/06/18.
//

import SwiftUI

struct HomeView: View {
	
	@State private var navigationDestination: String?
	
    var body: some View {
		VStack {
			Text("Camera")
				.foregroundColor(.primary)
				.frame(width: UIScreen.main.bounds.width,
					   height: UIScreen.main.bounds.width)
			
			BottomNavigationBar(navigationTag: $navigationDestination)
				.padding(.top, Constant.verticalMargin)
		}
		.padding(.vertical, Constant.verticalMargin)
		.navigationBarTitle("Home")
    }
	
	
	struct Constant {
		static let verticalMargin: CGFloat = 50
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
			.preferredColorScheme(.dark)
	}
}
