//
//  ViewController.swift
//  animated detail view
//
//  Created by likeadeveloper on 2/6/22.
//

import UIKit

final class ViewController: UIViewController {
    // MARK: UI
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: decorator.collectionViewLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        view.register(ViewControllerCell.self,
                      forCellWithReuseIdentifier: ViewControllerCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        return view
    }()

    // MARK: Var
    var decorator: VCDecoratorProtocol!

    private var dataSource: [Int] = []

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = Array<Int>(repeating: Int.random(in: 0...3),
                                count: Int.random(in: 20...80))
        setupView()
    }
}

// MARK: - Private
private extension ViewController {
    // MARK: Setup
    func setupView() {
        view.backgroundColor = .systemGray6

        addUIElements()
        addUIConstraints()
    }
    func addUIElements() {
        view.addSubview(collectionView)
    }
    func addUIConstraints() {
        NSLayoutConstraint.activate([
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),

            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }

    // MARK: Actions

    // MARK: Helper

}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewControllerCell.reuseIdentifier,
                                                      for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let decorator = DetailViewControllerDecorator()
        let destination = DetailViewBuilder
            .build(concreteDecorator: decorator)
        destination.modalPresentationStyle = .fullScreen
//        present(destination, animated: true)
        navigationController?.pushViewController(destination, animated: true)
    }
}

