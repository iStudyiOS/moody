//
//  ContentView.swift
//  moody
//
//  Created by 김두리 on 2021/06/18.
//

import SwiftUI
import CoreData

import SwiftUI

struct ContentView: View {
	let editor = ImageEditor()
	
    var body: some View {
        NavigationView{
            HomeView()
                .preferredColorScheme(.dark)
        }
		.environmentObject(editor)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
			.environmentObject(ImageEditor())
    }
}
