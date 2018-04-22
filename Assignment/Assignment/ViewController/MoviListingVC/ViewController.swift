//
//  ViewController.swift
//  Assignment
//
//  Created by Test on 4/21/18.
//  Copyright © 2018 hungama. All rights reserved.
//

let kLoaderViewTag = 12121
let kLoaderViewHeight: CGFloat = 50


import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var collectionViewBottomMarginConstraint: NSLayoutConstraint!
    let model = MoviesListViewModel()
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movies List"
        self.loadMoviesList()
        configureRefreshControl(on: self.collectionView)
        
    }
    
    func configureRefreshControl(on collectionView: UICollectionView) {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refershMovieList), for: .valueChanged)
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.collectionView.refreshControl = refreshControl
        
    }
    
    @objc func refershMovieList() {
        
        model.isUserRefreshingList = true
        refreshControl?.beginRefreshing()
        loadMoviesList()
        
    }
    
    func loadMoviesList()  {
        
        if model.isLoadingResultsFirstTime() {
            self.activityIndicator.startAnimating()
        }
        
        model.getMoviesList { [weak self] (moviesListReponse, error) in
            
            DispatchQueue.main.async {
            self?.activityIndicator.stopAnimating()
            self?.refreshControl?.endRefreshing()
            self?.isLoadingNextPageResults(false)

            if let _ = moviesListReponse {
                self?.collectionView.reloadData()

            }else{
                let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
        }
    }
    
    func loadNextPageResults() {
        loadMoviesList()
    }
    
    //MARK: Lazy loading functionality
    func isLoadingNextPageResults(_ isLoading: Bool) {
        
        model.isLoadingNextPageResults = isLoading
        
        if isLoading {
            collectionViewBottomMarginConstraint.constant = kLoaderViewHeight
            addLoaderViewForNextResults()
            
        }
        else {

            self.collectionViewBottomMarginConstraint.constant = 0

            let view = self.view.viewWithTag(kLoaderViewTag)
            view?.removeFromSuperview()
        }
        
        self.view.layoutIfNeeded()
    }
    func addLoaderViewForNextResults() {
        let view = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height , width: self.view.frame.size.width, height: kLoaderViewHeight))
        view.backgroundColor = UIColor.gray
        view.tag = kLoaderViewTag
        
        let indicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicatorView.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        indicatorView.startAnimating()
        indicatorView.color = UIColor.darkGray
        indicatorView.isHidden = false
        view.addSubview(indicatorView)
        
        self.view.addSubview(view)
        UIView.animate(withDuration: 0.3) {
            view.frame = CGRect(x: 0, y: self.view.frame.size.height - kLoaderViewHeight, width: self.view.frame.size.width, height: kLoaderViewHeight)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailsController = segue.destination as? MovieDetailsViewController, let cell = sender as? MovieCollectionViewCell  {
            
            guard let indexPath = collectionView.indexPath(for: cell) else {return}
            
            let movieModel = self.model.movieApiReponse.movies[indexPath.row]
            
            
            if let moviewId = movieModel.id {
                
                detailsController.loadMovieDtails(movieId: moviewId)
            }
            

        }
    }
    
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.movieApiReponse.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        cell.configureCell(with: model.getMovieCellModel(for: indexPath))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width-36)/3 , height: UIScreen.main.bounds.width/3)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard model.canLoadNextPage() else {
            return
        }
        
        let margin: CGFloat = 30
        let heightToLoadNextPage: CGFloat = scrollView.contentSize.height + margin
        let currentPosition: CGFloat = scrollView.contentOffset.y + scrollView.frame.size.height
        
        if (currentPosition >= heightToLoadNextPage) {
            isLoadingNextPageResults(true)
            loadNextPageResults()
        }
        
    }
    
}














