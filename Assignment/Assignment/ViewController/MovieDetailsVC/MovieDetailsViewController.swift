//
//  MovieDetailsViewController.swift
//  Assignment
//
//  Created by Test on 4/22/18.
//  Copyright © 2018 hungama. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    let model = MovieDetailsViewModel()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }

    func loadMovieDtails(movieId: Int) {
        
        model.loadMovieDetails(movieId) { [weak self] (movieDetailsModel, error) in
            
            if movieDetailsModel != nil {
                DispatchQueue.main.sync {
                    self?.tableView.reloadData()
                    self?.activityIndicator.stopAnimating()
                    
                }
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension MovieDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = model.cellTypes[indexPath.row]
        
        switch cellType {
        case .imageAndDescription:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageAndDescriptionCell") as! ImageAndDescriptionCell
            cell.configureCell(with: model.getImageAndNameCellModel())
            return cell
        
        case .endDummyCell:
            return tableView.dequeueReusableCell(withIdentifier: "dummyCell") as! DummyTableViewCell
        
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell") as! DescriptionTableViewCell
            cell.configureCell(with: model.getModelFor(cellType: cellType))
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        model.shouldExpend = !model.shouldExpend
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        
    }
}


