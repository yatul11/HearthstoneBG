//
//  ViewController.swift
//  HearthstoneBG
//
//  Created by Ivan on 15.04.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var networkManager = NetworkManager()
    private var collectionView: UICollectionView?
    let newViewController = CardsViewController()
    let tiers = ["tier1", "tier2", "tier3", "tier4", "tier5", "tier6"]
    
    
    var cardsArray = [Card]()  {
        didSet {
            newViewController.cards = cardsArray
            newViewController.cardsCount = cardsArray.count
        }
    }
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        networkManager.delegate = self
        
        setupUI()
       

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

// MARK: - UI Setup
extension ViewController {
    
    func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (view.frame.size.width/2) - 4, height: (view.frame.size.width/2) - 4)
        
        
        collectionView = UICollectionView(frame: .zero  , collectionViewLayout: layout)
        
        
        guard let collectionView = collectionView else { return }
        
        
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.backgroundView = backgroundImageView
    }
}

// MARK: - UICollectionViewDelegate & Data Source
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tiers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        
        cell.myImageView.image = UIImage(named: tiers[indexPath.row])
        cell.myImageView.isHighlighted = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        networkManager.fetchCards(tier: String(indexPath.row+1))
        self.navigationController?.pushViewController(newViewController, animated: true)
        //newViewController.cards = cardsArray
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                cell.myImageView.transform = .init(scaleX: 0.95, y: 0.95)
                
                cell.contentView.alpha = 0.4
                
            }
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                
                cell.contentView.alpha = 1
            }
        }
    }
    
}


//MARK: - CardManagerDelegate
extension ViewController: CardManagerDelegate {
    func didUpdateCards(_ cardsData: [Card]) {
        cardsArray = cardsData
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
}
