//
//  CardsViewController.swift
//  HearthstoneBG
//
//  Created by Ivan on 19.04.2021.
//

import UIKit

class CardsViewController: UIViewController {
    
    private var collectionView: UICollectionView?

    let cardView = UIView()
    let cardImage = UIImageView()
    var networkManager = NetworkManager()
    let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    let fadeView: UIView = UIView()
    
    var cardsCount = 0
    var cards = [Card]()  {
        didSet {
            DispatchQueue.main.async { [weak self] in
                
                
                if (self?.cardsCount == self?.cards.count) {
                    self?.collectionView?.reloadData()
                    self?.myActivityIndicator.stopAnimating()
                    self?.fadeView.removeFromSuperview()
                    self?.collectionView?.isHidden = false
                    
                }
            }
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
        
        self.navigationItem.title = "Select Card"
        cardView.isHidden = true
        
        self.collectionView?.reloadData()
        
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fadeView.frame = self.view.frame
        fadeView.backgroundColor = UIColor.white
        fadeView.alpha = 0.4
        
        cardView.frame = self.view.frame
        cardView.backgroundColor = .clear
        
        //cardView.alpha = 0.4
        
        
        cardView.addSubview(cardImage)
        
        cardImage.center = cardView.center
        cardImage.frame = cardView.frame
        cardImage.contentMode = .scaleAspectFit
        
        self.view.addSubview(cardView)
        self.view.addSubview(fadeView)
        
        self.view.addSubview(myActivityIndicator)
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.center = self.view.center
        
        myActivityIndicator.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.collectionView?.isHidden = true
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        cards = []
        collectionView?.reloadData()
    }
    
}

//MARK: - Setup UI
extension CardsViewController {
    
    func setupUI() {
        
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (view.frame.size.width/2) - 4, height: 250)
        
        collectionView = UICollectionView(frame: .zero  , collectionViewLayout: layout)
        
        
        guard let collectionView = self.collectionView else { return }
        
        
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.backgroundView = backgroundImageView
        
    }
}

//MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension CardsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        
        cell.dowloadImage(imageURL: cards[indexPath.row].battlegrounds.image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                cell.myImageView.transform = .init(scaleX: 0.95, y: 0.95)
                
                cell.contentView.alpha = 0.4
                
                self.collectionView?.alpha = 0.5
                
                self.cardView.isHidden = false
                
                self.cardImage.image = cell.myImageView.image
                
                
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                cell.contentView.alpha = 1
                self.collectionView?.alpha = 1
                
                self.cardView.isHidden = true
            }
        }
    }
    
}


