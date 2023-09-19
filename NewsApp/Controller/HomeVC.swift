//
//  HomeVC.swift
//  NewsApp
//
//  Created by Khumbongmayum Tonny on 05/09/23.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - Variables
    var articles = [Article]()
    var isAppear = false
    var selectedIndexFromHome: Int?
    
    
    // MARK: - UI components
    @IBOutlet var tableView: UITableView!  
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        self.setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if isAppear == false {
            isAppear.toggle()
            return
        }
        articles[selectedIndexFromHome!].toShow = true
    }
    
    
    // MARK: - Fetch Data
    private func getData() {
        Task {
            let client = HTTPClient.shared
            let apiKey = "9b629bcedd984434bd4ca246eb557278"
            let source = "techcrunch"
            let articlesResource = Articles.resourceForAllArticles(apiKey: apiKey, source: source)
            
            do {
                let response = try await client.load(articlesResource)
                print(response.articles)
                UserDefaultsArticleStore.shared.saveArticles(response.articles)
                self.articles = response.articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch {
                print(error.localizedDescription)
                if let data = UserDefaultsArticleStore.shared.loadArticles() {
                    self.articles = data
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    
    // MARK: - Setup UI
    
    private func setupUI() {
        self.title = "TechCrunch"
        configureNavigationBar()
        registerTableCells()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
    }
    
    func configureNavigationBar() {
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [
            .foregroundColor : UIColor.tintColor
        ]
        appearance.titleTextAttributes = [
            .foregroundColor : UIColor.tintColor
        ]
        appearance.shadowColor = .clear
//        appearance.backgroundColor = .systemGray6
        
        navigationBar?.standardAppearance = appearance
        navigationBar?.scrollEdgeAppearance = appearance
    }
    
    func registerTableCells() {
        self.tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        
        self.tableView.register(UINib(nibName: "HeaderHomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderHomeTableViewCell")
    }
    
    
}


// MARK: - Table DataSource

extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = articles[indexPath.row]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderHomeTableViewCell", for: indexPath) as! HeaderHomeTableViewCell
            cell.parentViewController = self
            cell.load(article: article)
            cell.articleImage.layer.cornerRadius = 10
            cell.articleImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.parentViewController = self
        cell.load(article: article)
        return cell
    }
}


// MARK: - Table Delegate

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 380.0 : 140.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        articles[indexPath.row].toShow = false
        selectedIndexFromHome = indexPath.row
        let article = articles[indexPath.row]
        navigateToArticleVC(article: article, selectedRowIndex: selectedIndexFromHome!)
    }
}


// MARK: - Navigation to ArticleVC

extension HomeVC {
    private func navigateToArticleVC(article: Article, selectedRowIndex: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ArticleViewController") as? ArticleVC {
            vc.imageURL = article.urlToImage
            vc.articleURL = article.url
            vc.articleDescriptionText = article.articleDescription
            vc.articleTitleText = article.titleDisplay
            vc.articles = articles
         
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


// MARK: - UIImageView extension

extension UIImageView {
    func loadImage(from urlString: String, placeholderImage: UIImage? = nil) {
        guard let url = URL(string: urlString) else {
            self.image = placeholderImage
            return
        }
        
        self.image = placeholderImage
        
        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    if self.image == placeholderImage {
                        self.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
