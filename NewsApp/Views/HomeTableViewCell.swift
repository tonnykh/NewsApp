//
//  HomeTableViewCell.swift
//  NewsApp
//
//  Created by Khumbongmayum Tonny on 07/09/23.
//

import QuartzCore
import Kingfisher
import UIKit

class HomeTableViewCell: UITableViewCell {
    
    var parentViewController: UIViewController?
    
    
    // MARK: - Variables
    var articleUrl: String?
    
    
    // MARK: - UI components
    @IBOutlet var articleTitleLabel: UILabel!
    @IBOutlet var articleImage: UIImageView!
    @IBOutlet weak var shareIconTap: UIImageView!
    @IBOutlet weak var articlePostedOnLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    
    func loadImage(from url: URL, placeholderImage: UIImage?) {
        articleImage.kf.setImage(with: url, placeholder: placeholderImage)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    
    func configUI() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(shareTapAction(tapGestureRecognizer:)))
        shareIconTap.isUserInteractionEnabled = true
        shareIconTap.addGestureRecognizer(tapGestureRecognizer)
        
        articleImage.layer.cornerRadius = 10.0
        articleImage.clipsToBounds = true
        
        cellView.layer.cornerRadius = 10.0
        cellView.addShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // MARK: - Share Icon Tap
    @objc func shareTapAction(tapGestureRecognizer: UITapGestureRecognizer) {
        print("Tapped")
        
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
