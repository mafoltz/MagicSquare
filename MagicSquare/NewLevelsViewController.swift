//
//  NewLevelsViewController.swift
//  MagicSquare
//
//  Created by Athos Lagemann on 20/10/23.
//  Copyright © 2023 Marcelo Andrighetto Foltz. All rights reserved.
//

import UIKit

class NewLevelsViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView?.dataSource = self
    }
}

extension NewLevelsViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }

    func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return ["Section 1", "Section 2"]
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        let identifierLabel = UILabel()
        identifierLabel.text = "\(indexPath.section)-\(indexPath.row)"

        cell.contentView.addSubview(identifierLabel)
        cell.contentView.backgroundColor = [UIColor.systemMint, .systemCyan, .systemPink, .systemTeal].randomElement()
        return cell
    }
}

