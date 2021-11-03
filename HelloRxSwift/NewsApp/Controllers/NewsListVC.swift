//
//  NewsListVC.swift
//  HelloRxSwift
//
//  Created by thanos kottaridis on 31/8/21.
//

import UIKit
import RxSwift
import RxCocoa

/**
 # News Api Credentials
 
 firstname: Athanasios
 email: thanasiskottaridis@yahoo.gr
 pass: Test1234!
 
 myKey: e869b3ed191140c2aea8fafb12eba72e
 */

class NewsListVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    private let BASE_URL = "https://newsapi.org/v2/top-headlines?country=gr&apiKey=e869b3ed191140c2aea8fafb12eba72e"
    private var articles = [Article]()
    // MARK: - RxSwift properties
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setUpTableViewNeeds()
        populateNews()
    }
    
    private func setUpTableViewNeeds() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
    }
    
    private func populateNews() {
        guard let url = URL(string: BASE_URL) else { return }
        
        Observable.just(url) // epidi exei mono ena element
            .flatMap { url -> Observable<Data> in
                /**
                    - To kanoume flatMap diladi gia kathe url (1) kanoume ena URLRequest
                    - me tin voithia tou Rx framwork auto mas episrefei ena observable me Data xrisimopoiontas to url
                 */
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map { data -> [Article]? in
                /**
                 - Sti sunexeia kanoume map ta data (pou peirame apo to response)
                 - kai kai ta kanoume decode se ArticleList apo ta opoia kratame ta [Articles]
                 */
                return try? JSONDecoder().decode(ArticlesList.self, from: data).articles
            }.subscribe(onNext: { [weak self] articles in
                guard let articles = articles else { return }
                self?.articles = articles
                print(articles)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
    }
}

extension NewsListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        cell.setUpCell(article: articles[indexPath.row])
        
        return cell
    }
    
}
