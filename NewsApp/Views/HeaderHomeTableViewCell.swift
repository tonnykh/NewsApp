//
//  HeaderHomeTableViewCell.swift
//  NewsApp
//
//  Created by Khumbongmayum Tonny on 07/09/23.
//

import QuartzCore
import UIKit

class HeaderHomeTableViewCell: UITableViewCell {
    
    var parentViewController: UIViewController?
     
    
    // MARK: - Variables
    var articleUrl: String?
    
    
    // MARK: - UI components
    @IBOutlet var articleImage: UIImageView!
    @IBOutlet var articleTitleLabel: UILabel!
    @IBOutlet weak var shareIconTap: UIImageView!
    @IBOutlet weak var articlePostedOnLabel: UILabel!
    @IBOutlet weak var viewCell: UIView!
    
    func loadImage(from url: URL, placeholderImage: UIImage?) {
        articleImage.kf.setImage(with: url, placeholder: placeholderImage)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    
    func configUI() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(shareTapAction(tapGestureRecognizer:)))
  
        self.shareIconTap.isUserInteractionEnabled = true
        self.shareIconTap.addGestureRecognizer(tapGestureRecognizer)
    
        self.viewCell.layer.cornerRadius = 10.0
        self.viewCell.addShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // MARK: - Share Icon Tap
    @objc func shareTapAction(tapGestureRecognizer: UITapGestureRecognizer) {
        print("TAPPED _-_____")
        
        let urlToShare = URL(string: articleUrl ?? "https://developer.apple.com/")!
        
        if let parentVC = parentViewController {
            let items = [urlToShare]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            parentVC.present(ac, animated: true)
        }
    }
    
    
    func load(article: Article) {
        articleTitleLabel.text = article.titleDisplay
        articleUrl = article.url
        articlePostedOnLabel.text = article.convertTimeStampToDate()
        
        if let imageURL = URL(string: article.urlToImage!) {
            loadImage(from: imageURL, placeholderImage: UIImage(named: "placeholder"))
        }
    }
    
}
