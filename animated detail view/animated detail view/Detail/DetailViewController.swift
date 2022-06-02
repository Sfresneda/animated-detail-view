//
//  DetailViewController.swift
//  animated detail view
//
//  Created by likeadeveloper on 2/6/22.
//

import UIKit

final class DetailViewController: UIViewController {
    // MARK: UI
    private lazy var overlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.isHidden = true
        return view
    }()

    // MARK: Vars
    var decorator: DetailDecoratorProtocol!
    var coordinator: TransitionDetailCoordinator!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

// MARK: - Public
extension DetailViewController {

}

// MARK: - Private
private extension DetailViewController {
    // MARK: Setup
    func setupView() {
        view.backgroundColor = .systemGray5

        decorator.initialHeightForTopContainer = view.bounds.height * 0.3
        addUIElements()
        addUIConstraints()
        setupCoordinator()
    }
    func setupNavigationBar() {
        guard let navBar = navigationController?
            .navigationBar else {
            return
        }

        decorator.setupNavigationBar(navBar)
    }
    func addUIElements() {
        add(SliderViewController())

        if decorator.shouldShowOverlay {
            view.addSubview(overlay)
        }

        add(decorator.infoViewController)
    }
    func addUIConstraints() {
        let guide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            guide.trailingAnchor.constraint(equalTo: overlay.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: overlay.bottomAnchor)
        ])
    }
    func setupCoordinator() {
        decorator
            .infoViewController
            .additionalSafeAreaInsets = UIEdgeInsets(top: 0,
                                                     left: 0,
                                                     bottom: decorator.initialHeightForTopContainer,
                                                     right: 0)
        coordinator = TransitionDetailCoordinator(infoViewController: decorator.infoViewController,
                                            overlay: decorator.shouldShowOverlay ? overlay : nil)
        coordinator.isClosed = { [unowned navigationController] in
            navigationController?
                .navigationBar
                .isUserInteractionEnabled = true
        }
        coordinator.isOpened = { [unowned navigationController] in
            navigationController?
                .navigationBar
                .isUserInteractionEnabled = false
        }
    }
}
