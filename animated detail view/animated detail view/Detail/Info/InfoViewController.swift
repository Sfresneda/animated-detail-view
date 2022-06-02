//
//  InfoViewController.swift
//  animated detail view
//
//  Created by likeadeveloper on 2/6/22.
//

import UIKit

protocol InfoViewControllerProtocol: UIViewController {
    var contentContainer: UIView { get }
    var initialHeight: CGFloat { get set }
    var topOffset: CGFloat { get }
}

final class InfoViewController: UIViewController {
    private var _initialHeight: CGFloat
    private var _topOffset: CGFloat

    init(initialHeight: CGFloat, topOffset: CGFloat) {
        _initialHeight = initialHeight
        _topOffset = topOffset
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    required init?(coder: NSCoder) {
        _initialHeight = .zero
        _topOffset = .zero
        super.init(coder: coder)
        setupView()
    }
}

private extension InfoViewController {
    func setupView() {
        view.backgroundColor = .white
    }
}

extension InfoViewController: InfoViewControllerProtocol {
    var contentContainer: UIView {
        view
    }
    var initialHeight: CGFloat {
        get {
            _initialHeight
        }
        set {
            _initialHeight = newValue
        }
    }
    var topOffset: CGFloat {
        _topOffset
    }
}
