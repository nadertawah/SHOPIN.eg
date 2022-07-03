//
//  ReviewsVC.swift
//  Shopify
//
//  Created by Nader Said on 22/06/2022.
//

import UIKit

class ReviewsVC: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        setUI()
    }

    //MARK: - IBOutlet(s)
    @IBOutlet weak var reviewsTableView: UITableView!
    
    //MARK: - Var(s)
    var VM = ReviewsVM()
    let reviewCellIdentfier = "ReviewsTableViewCell"
        
    //MARK: - Helper Funcs
    func setUI()
    {
        //set title
        title = "Reviews"
        
        //set delegates
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        
        //register cell
        reviewsTableView.register(UINib(nibName: reviewCellIdentfier, bundle: nil), forCellReuseIdentifier: reviewCellIdentfier)
        
        //bind VM
        VM.reviewList.bind
        {
            [weak self] _ in
            DispatchQueue.main.async
            {
                self?.reviewsTableView.reloadData()
            }
            
        }
    }
}

extension ReviewsVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return VM.reviewList.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = reviewsTableView.dequeueReusableCell(withIdentifier: reviewCellIdentfier) as? ReviewsTableViewCell
        , let review = VM.reviewList.value?[indexPath.row]
        else {return UITableViewCell()}
        
        cell.dateLabel.text = review.reviewDate
        cell.reviewerNameLabel.text = review.reviewer
        cell.rateView.maximumValue = 5
        cell.rateView.minimumValue = 0
        cell.rateView.value = CGFloat(review.rate)
        cell.reviewBodyLabel.text = review.reviewBody
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 3
    }
}
