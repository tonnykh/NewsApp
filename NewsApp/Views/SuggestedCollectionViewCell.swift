//
//  SuggestedCollectionViewCell.swift
//  NewsApp
//
//  Created by Khumbongmayum Tonny on 11/09/23.
//su

import UIKit

class SuggestedCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    
    func loadImage(from url: URL, placeholderImage: UIImage?) {
        articleImage.kf.setImage(with: url, placeholder: placeholderImage)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 10.0
        self.articleImage.layer.cornerRadius = 10.0
    }
    
    func load(article: Article) {
        articleTitleLabel.text = article.titleDisplay
//        articleUrl = article.url
//        articlePostedOnLabel.text = article.convertTimeStampToDate()
        
        if let imageURL = URL(string: article.urlToImage!) {
            loadImage(from: imageURL, placeholderImage: UIImage(named: "placeholder"))
        }
    }

}


