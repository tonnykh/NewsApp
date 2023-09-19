//
//  ArticleVC.swift
//  NewsApp
//
//  Created by Khumbongmayum Tonny on 07/09/23.
//

import AVFoundation
import QuartzCore
import Kingfisher
import SafariServices
import UIKit


class ArticleVC: UIViewController {
    
    // MARK: - Variables
    var imageURL: String?
    var articleDescriptionText: String?
    var articleTitleText: String?
    var articleURL: String?
    
    var firstHiddenArticle: Article?
    var articles = [Article]()
    var relatedArticles = [Article]()
    
    // Audio
    let synth = AVSpeechSynthesizer()
    
    // Track whether firstHiddenArticle has been appended
    var isFirstHiddenArticleAppended = false
    
    
    // MARK: - UI components
    @IBOutlet weak var articleDescriptionLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var suggestedCollectionView: UICollectionView!
    @IBOutlet weak var listenArticleButton: UIButton!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.updateRelatedArticles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.view.window != nil {
            // The view is visible
            print("viewController is visible")
            relatedArticles.append(firstHiddenArticle!)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        synth.stopSpeaking(at: .immediate)
    }
    
    
    // MARK: - Update Articles for Related Articles
    private func updateRelatedArticles() {
        for index in articles.indices {
            if articles[index].toShow == true {
                relatedArticles.append(articles[index])
            } else {
                firstHiddenArticle = articles[index]
            }
        }
    }
    
    
    // MARK: - Setup UI
    private func setupUI() {
        setupListenArticleButton()
        setupCollectionView()
        setupNavigationBar()
        loadImage()
        
        articleDescriptionLabel.text = articleDescriptionText
        articleTitleLabel.text = articleTitleText
    }
    
    private func setupListenArticleButton() {
        self.synth.delegate = self
        listenArticleButton.addShadow()
    }
    
    private func setupCollectionView() {
        self.suggestedCollectionView.dataSource = self
        self.suggestedCollectionView.delegate = self
        
        registerCollectionViewCell()
    }
    
    private func registerCollectionViewCell() {
        self.suggestedCollectionView.register(UINib(nibName: "SuggestedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SuggestedCollectionViewCell")
    }
    
    private func setupNavigationBar() {
        self.navigationItem.largeTitleDisplayMode = .never
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareBarButtonAction))
        self.navigationItem.rightBarButtonItem = shareButton
    }
    
    private func loadImage() {
        articleImage.loadImage(from: imageURL!, placeholderImage: UIImage(named: "placeholder"))
        articleImage.layer.cornerRadius = 10.0
        articleImage.clipsToBounds = true
        let url = URL(string: imageURL!)
        articleImage.kf.setImage(with: url)
    }
    
    
    // MARK: - Action
    @IBAction func openFromWeb(_ sender: Any) {
        if let url = articleURL {
            navigateToSafariVC(with: url)
        } else {
            navigateToSafariVC(with: "https://developer.apple.com/")
        }
    }
    
    
    @IBAction func playPauseArticleAction(_ sender: Any) {
        let speechUtterance = AVSpeechUtterance(string: articleDescriptionText!)
        if let voice = AVSpeechSynthesisVoice(language: "en-US") {
            speechUtterance.voice = voice
            speechUtterance.rate = 0.5
        } else {
            print("Failed to get voice.")
        }
        
        if !synth.isSpeaking {
            synth.speak(speechUtterance)
            listenArticleButton.setTitle("⏸️ Listen To The Article", for: .normal)
        } else if synth.isPaused {
            synth.continueSpeaking()
            listenArticleButton.setTitle("⏸️ Listen To The Article", for: .normal)
        } else if synth.isSpeaking {
            synth.pauseSpeaking(at: AVSpeechBoundary.immediate)
            listenArticleButton.setTitle("▶️ Listen To The Article", for: .normal)
        }
    }
    
    
    @objc func shareBarButtonAction() {
        let url = [URL(string: articleURL!)]
        
        let ac = UIActivityViewController(activityItems: url as [Any], applicationActivities: nil)
        present(ac, animated: true)
    }
    
}


// MARK: - Extension
extension ArticleVC: SFSafariViewControllerDelegate {
    
    func navigateToSafariVC(with url: String) {
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true, completion: nil)
        vc.delegate = self
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ArticleVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = suggestedCollectionView.dequeueReusableCell(withReuseIdentifier: "SuggestedCollectionViewCell", for: indexPath) as? SuggestedCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let article = relatedArticles[indexPath.row]
        cell.load(article: article)
        
        return cell
    }
    
}

extension ArticleVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 250, height: 120)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Update the Bigger Card UI with the selected article
        let selectedArticle = relatedArticles[indexPath.row]
        imageURL = selectedArticle.urlToImage
        articleURL = selectedArticle.url
        articleDescriptionText = selectedArticle.articleDescription
        articleTitleText = selectedArticle.titleDisplay
        setupUI()
        
        print("All TRUE Article no: ")
        print("")
        print("")
        print(relatedArticles.count)
        print("")
        print("")
        
        // Hide the selected article
        relatedArticles[indexPath.row].toShow = false
        
        // Find and get the hidden article
        var hiddenArticle: Article?
        for index in relatedArticles.indices {
            if relatedArticles[index].toShow == false {
                var hideArticle = relatedArticles[index]
                hideArticle.toShow = true
                hiddenArticle = hideArticle
                print(hiddenArticle!)
            }
        }
        
        
        // Filter only non hidden article
        relatedArticles = relatedArticles.filter { article in
            return article.toShow == true
        }
        
        print(relatedArticles.count)
        
        // Reload the Collection view data
        suggestedCollectionView.reloadData()
        
        // Update the First Hidden article not to hide
        firstHiddenArticle?.toShow = true
        
        // Append the Hidden article to related articles []
        relatedArticles.append(hiddenArticle!)
        print("")
        print("Append hidden article")
        print(relatedArticles.count)
        
    }
    
}

extension ArticleVC: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        return listenArticleButton.setTitle("▶️ Listen To The Article", for: .normal)
    }
}
