//
//  CollectionViewCell.swift
//  HearthstoneBG
//
//  Created by Ivan on 18.04.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomCell"
    
    var myImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        //imageView.backgroundColor = .blue
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //contentView.backgroundColor = .systemYellow
        contentView.addSubview(myImageView)
        contentView.clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        myImageView.frame = CGRect(x: 25, y: 25, width: contentView.frame.size.width-50, height: contentView.frame.size.height-50)
    }
    
}

// MARK: - Download Image
extension CollectionViewCell {
    func dowloadImage(imageURL: String) {
        guard let image = URL(string: imageURL) else { return }
        let task = URLSession.shared.dataTask(with: image) { (data, response, error) in
            guard let data = data, error == nil else {return}
            let downloadedImage = UIImage(data: data)
            DispatchQueue.main.async {
                self.myImageView.image = downloadedImage
            }
        }
        task.resume()
    }
    
    
}
