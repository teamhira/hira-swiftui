//
//  PageCurlView.swift
//  Hira
//
//  Created by Ryuk on 08/04/26.
//

import SwiftUI
import UIKit

/// A SwiftUI wrapper for UIPageViewController that provides the native page curl transition.
public struct PageCurlView<T: Identifiable, Content: View>: UIViewControllerRepresentable {
    public let items: [T]
    @Binding public var currentItem: T
    public let content: (T) -> Content

    public init(items: [T], currentItem: Binding<T>, @ViewBuilder content: @escaping (T) -> Content) {
        self.items = items
        self._currentItem = currentItem
        self.content = content
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIViewController(context: Context) -> UIPageViewController {
        let pvc = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pvc.dataSource = context.coordinator
        pvc.delegate = context.coordinator
        
        // We use LTR internally but swap the logic to make Swipe Right = Next
        pvc.view.semanticContentAttribute = .forceLeftToRight
        pvc.view.backgroundColor = .systemBackground
        
        if let initialVC = context.coordinator.viewController(for: currentItem) {
            pvc.setViewControllers([initialVC], direction: .forward, animated: false)
        }
        return pvc
    }

    public func updateUIViewController(_ pvc: UIPageViewController, context: Context) {
        context.coordinator.parent = self
        
        let targetIndex = items.firstIndex(where: { $0.id == currentItem.id }) ?? 0
        
        // Always update the current VC's rootView to ensure environment/state changes propagate
        if let currentVC = pvc.viewControllers?.first as? UIHostingController<Content> {
            currentVC.rootView = content(currentItem)
        }
        
        let currentIndex = pvc.viewControllers?.first?.view.tag ?? -1
        if currentIndex != targetIndex {
            let direction: UIPageViewController.NavigationDirection = targetIndex > currentIndex ? .reverse : .forward
            if let targetVC = context.coordinator.viewController(for: items[targetIndex]) {
                pvc.setViewControllers([targetVC], direction: direction, animated: true)
            }
        }
    }

    public class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageCurlView
        
        init(_ parent: PageCurlView) {
            self.parent = parent
        }
        
        func viewController(for item: T) -> UIViewController? {
            let vc = UIHostingController(rootView: parent.content(item))
            vc.view.tag = parent.items.firstIndex(where: { $0.id == item.id }) ?? 0
            vc.view.backgroundColor = .systemBackground
            return vc
        }
        
        // SWAPPED: viewControllerBefore now handles Swipe Right (L -> R)
        // User wants L -> R to go to NEXT surah.
        public func pageViewController(_ pvc: UIPageViewController, viewControllerBefore vc: UIViewController) -> UIViewController? {
            let index = vc.view.tag
            // Go FORWARD to next surah
            guard index < parent.items.count - 1 else { return nil }
            return viewController(for: parent.items[index + 1])
        }
        
        // SWAPPED: viewControllerAfter now handles Swipe Left (R -> L)
        // User wants R -> L to go to PREVIOUS surah.
        public func pageViewController(_ pvc: UIPageViewController, viewControllerAfter vc: UIViewController) -> UIViewController? {
            let index = vc.view.tag
            // Go BACKWARD to prev surah
            guard index > 0 else { return nil }
            return viewController(for: parent.items[index - 1])
        }
        
        public func pageViewController(_ pvc: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed, let vc = pvc.viewControllers?.first {
                let index = vc.view.tag
                DispatchQueue.main.async {
                    self.parent.currentItem = self.parent.items[index]
                }
            }
        }
    }
}
