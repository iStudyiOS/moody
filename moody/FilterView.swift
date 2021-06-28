//
//  FilterView.swift
//  moody
//
//  Created by bart Shin on 21/06/2021.
//

import SwiftUI

struct FilterView: View {
	
	@StateObject private var homeData = HomeViewModel()
	
    var body: some View {
		VStack {
			if !homeData.allImages.isEmpty && homeData.mainView != nil{
				
				Image(uiImage: homeData.mainView.image)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: UIScreen.main.bounds.width)
				
				ScrollView(.horizontal, showsIndicators: false) {
					HStack(spacing: 20) {
						ForEach(homeData.allImages){
							filtered in
							Image(uiImage: filtered.image)
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: 150, height: 150)
								.onTapGesture {
									homeData.mainView = filtered
								}
						}
					}
				}
				.padding()
			}
			else if homeData.imageData.count == 0 {
				Text("Pick An Image To Progress")
			}
			else {
				ProgressView()
			}
		}
		.navigationTitle("Filter")
		.onChange(of: homeData.imageData, perform: { (_) in
			// When Ever image is changed Firing loadImage
			homeData.allImages.removeAll()
			homeData.loadFilter()
		})
		.toolbar {
			// image button
			ToolbarItem(placement: .navigationBarTrailing) {
				Button(action: {homeData.imagePicker.toggle()}) {
					Image(systemName: "photo")
						.font(.title2)
				}
			}
		}
		.sheet(isPresented: $homeData.imagePicker) {
			ImagePicker(picker: $homeData.imagePicker, imageData: $homeData.imageData)
		}
	}
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
		FilterView()
    }
}
