//
//  Publish.swift
//  moody
//
//  Created by bart Shin on 26/06/2021.

//
//import Foundation
//import Combine
//
//extension ObservableObject where Self.ObjectWillChangePublisher == ObservableObjectPublisher {
//	func publishOnMainThread() {
//		if Thread.isMainThread {
//			objectWillChange.send()
//		}else {
//			DispatchQueue.main.async {
//				self.objectWillChange.send()
//			}
//		}
//	}
//}
