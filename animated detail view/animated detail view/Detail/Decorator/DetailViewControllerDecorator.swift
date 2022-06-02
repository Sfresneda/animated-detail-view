//
//  DetailViewControllerDecorator.swift
//  animated detail view
//
//  Created by likeadeveloper on 2/6/22.
//

import UIKit

struct DetailViewControllerDecorator: DetailDecoratorProtocol {
    fileprivate static let initialHeight: CGFloat = 250
    fileprivate static let topOffset: CGFloat = 100

    private var customInitialHeightForTopContainer: CGFloat?
    private var _infoViewController: InfoViewController = {
        InfoViewController(initialHeight: DetailViewControllerDecorator.initialHeight,
                           topOffset: DetailViewControllerDecorator.topOffset)
    }()

    var initialHeightForTopContainer: CGFloat {
        get {
            customInitialHeightForTopContainer
            ?? DetailViewControllerDecorator.initialHeight
        }
        set {
            customInitialHeightForTopContainer = newValue
            _infoViewController.initialHeight = newValue
        }
    }
    var isTopContainerDraggable: Bool {
        true
    }
    var infoViewController: InfoViewControllerProtocol {
        _infoViewController
    }
    var shouldShowOverlay: Bool {
        true
    }

    func setupNavigationBar(_ bar: UINavigationBar) {
        bar.tintColor = .black
        bar.barTintColor = .clear
        bar.isTranslucent = true
        bar.shadowImage = UIImage()
    }
}
