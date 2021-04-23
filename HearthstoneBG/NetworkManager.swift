//
//  NetworkManager.swift
//  HearthstoneBG
//
//  Created by Ivan on 17.04.2021.
//

import Foundation
import UIKit

protocol CardManagerDelegate {
    func didUpdateCards(_ cardsData: [Card])
    func didFailWithError(_ error: Error)
}

protocol ImageManagerDelegate {
    func didUpdateImage(_ cardImage: UIImage)
}

struct NetworkManager {
    
    private var url = "https://us.api.blizzard.com/hearthstone/cards?"
    
    private var locale = "ru_RU"
    
    private let gameMode = "battlegrounds"
    
    private let access_token = "USyl6yCx35O88WkNOhRDaq0lGZc8nqZ1f0"
    
    var delegate: CardManagerDelegate?
    var imageDelegate: ImageManagerDelegate?
    
    private mutating func createURL() -> String {
        return "locale=\(locale)&gameMode=\(gameMode)&access_token=\(access_token)"
    }
    
    mutating func fetchCards(tier: String) {
        self.performRequest(urlString: url+createURL()+"&tier=\(tier)")
    }
    
    private func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            print(url)
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(cardData: safeData)
                }
            }
            task.resume()
        }
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            if let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.imageDelegate?.didUpdateImage(image)
                }
            }
        }
    }
    
    private func parseJSON(cardData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CardData.self, from: cardData)
            self.delegate?.didUpdateCards(decodedData.cards)
        } catch {
            self.delegate?.didFailWithError(error)
        }
    }
    
}
