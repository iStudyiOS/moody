//
//  EditingImage.swift
//  moody
//
//  Created by bart Shin on 24/06/2021.
//

import SwiftUI

struct EditingImage: View {
	
	@EnvironmentObject var editor: ImageEditor
	private var image: UIImage {
		UIImage(cgImage: editor.currentImage!)
	}
	
	var body: some View {
		if editor.currentImage != nil {
			GeometryReader { geometry in
				editingImage
					.position(x: geometry.size.width / 2 + panningOffset.width,
							  y: geometry.size.height / 2 + panningOffset.height)
					.gesture(panGesture(in: geometry.size)
								.simultaneously(with: zoomGesture(in: geometry.size))
								.simultaneously(with: doubleTapToFit(in: geometry.size)))
					.onAppear {
						fixedZoomScale = getScaleToFit(in: geometry.size)
					}
					.onChange(of: editor.currentImage) {
						if $0 != nil {
							fixedZoomScale = getScaleToFit(in: geometry.size)
							fixedPanOffset = .zero
						}
					}
					.clipped()
			}
		}
	}
	
	private var editingImage: some View {
		Image(uiImage: image)
			.aspectRatio(contentMode: .fill)
			.scaleEffect(zoomScale)
	}
	
	//MARK:- Zooming
	
	@State private var fixedZoomScale: CGFloat = 1
	@GestureState private var gestureZoomScale: CGFloat = 1
	
	private var zoomScale: CGFloat {
		fixedZoomScale * gestureZoomScale
	}
	
	private func zoomGesture(in size: CGSize) -> some Gesture {
		MagnificationGesture()
			.updating($gestureZoomScale) { lastScale, gestureZoomScale, _ in
				gestureZoomScale = lastScale
			}
			.onEnded { scale in
				let defaultScale = getScaleToFit(in: size)
				fixedZoomScale *= scale
				if defaultScale > fixedZoomScale * scale {
					withAnimation {
						fixedZoomScale = defaultScale
						fixedPanOffset = .zero
					}
				}
			}
	}
	
	private func doubleTapToFit(in size: CGSize) -> some Gesture {
		TapGesture(count: 2)
			.onEnded {
				withAnimation {
					fixedPanOffset = .zero
					fixedZoomScale = getScaleToFit(in: size)
				}
			}
	}
	
	private func getScaleToFit(in size: CGSize) -> CGFloat {
		let horizontal = size.width / image.size.width
		let vertical = size.height / image.size.height
		return min(horizontal, vertical)
	}
	
	
	//MARK:- Panning
	
	@State private var fixedPanOffset: CGSize = CGSize.zero
	@GestureState private var gesturePanOffset: CGSize = CGSize.zero
	
	private var panningOffset: CGSize {
		CGSize(width: (fixedPanOffset.width + gesturePanOffset.width) * zoomScale,
			   height: (fixedPanOffset.height + gesturePanOffset.height) * zoomScale)
	}
	
	private func panGesture(in size: CGSize) -> some Gesture {
		DragGesture()
			.updating($gesturePanOffset) { lastestDragGestureValue, gesturePanOffset, _ in
				guard calcPanableSpace(in: size) != nil else {
					return
				}
				gesturePanOffset = CGSize(
					width: lastestDragGestureValue.translation.width / zoomScale,
					height: lastestDragGestureValue.translation.height / zoomScale)
			}
			.onEnded { endValue in
				guard let panableSpace = calcPanableSpace(in: size) else {
					return
				}
				fixedPanOffset = CGSize(
					width: fixedPanOffset.width + endValue.translation.width / zoomScale,
					height: fixedPanOffset.height + endValue.translation.height / zoomScale)
				
				if checkExceedEdge(in: panableSpace) {
					withAnimation {
						fixedPanOffset = calcMaxiumOffset(in: panableSpace)
					}
				}
			}
	}
	
	private func checkExceedEdge(in panableSpace: CGSize) -> Bool {
		abs(panningOffset.width) > panableSpace.width ||
			abs(panningOffset.height) > panableSpace .height
	}
	
	private func calcMaxiumOffset(in panableSpace: CGSize) -> CGSize {
		let currentOffset = panningOffset
		let horizontal: CGFloat
		let vertical: CGFloat
		if abs(currentOffset.width) > panableSpace.width {
			horizontal = panableSpace.width * (currentOffset.width < 0 ? -1: 1)
		}else {
			horizontal = currentOffset.width
		}
		if abs(panningOffset.height) > panableSpace.height {
			vertical = panableSpace.height * (currentOffset.height < 0 ? -1: 1)
		}else {
			vertical = currentOffset.height
		}
		return CGSize(width: horizontal / zoomScale, height: vertical / zoomScale)
	}
	private func calcPanableSpace(in viewSize: CGSize) -> CGSize? {
		let defaultZoomScale = getScaleToFit(in: viewSize)
		guard zoomScale >  defaultZoomScale else {
			return nil
		}
		return CGSize(
			width: image.size.width * (zoomScale - defaultZoomScale) / 2,
			height: image.size.height * (zoomScale - defaultZoomScale) / 2)
	}
}
