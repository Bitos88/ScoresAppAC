//
//  FavoritesCollectionViewController.swift
//  ScoresAPP
//
//  Created by Alberto Alegre Bravo on 25/6/22.
//

import UIKit

class FavoritesCollectionViewController: UICollectionViewController {
    
    let modelLogic = ModelLogic.shared

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return modelLogic.favorites.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CoverItemViewCell else {
            return UICollectionViewCell()
        }
        let score = modelLogic.getFavorite(id: indexPath.row)
        cell.cover.image = UIImage(named: "\(score.cover)")
        return cell
    }
}
