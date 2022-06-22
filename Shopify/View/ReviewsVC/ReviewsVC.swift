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
        
    }
}

extension ReviewsVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = reviewsTableView.dequeueReusableCell(withIdentifier: reviewCellIdentfier) as? ReviewsTableViewCell else {return UITableViewCell()}
        
        switch indexPath.row
        {
            case 0 :
                cell.dateLabel.text = "10/02/2022"
                cell.reviewerNameLabel.text = "Nader"
                cell.rateView.maximumValue = 5
                cell.rateView.minimumValue = 0
                cell.rateView.value = 3.5
                cell.reviewBodyLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley"
                break
                
            case 1 :
                cell.dateLabel.text = "10/02/2022"
                cell.reviewerNameLabel.text = "Moataz"
                cell.rateView.maximumValue = 5
                cell.rateView.minimumValue = 0
                cell.rateView.value = 4
                cell.reviewBodyLabel.text = "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. "
                break
                
            case 2 :
                cell.dateLabel.text = "10/02/2022"
                cell.reviewerNameLabel.text = "Mohamed"
                cell.rateView.maximumValue = 5
                cell.rateView.minimumValue = 0
                cell.rateView.value = 2
                cell.reviewBodyLabel.text = "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. "
                break
                
            case 3 :
                cell.dateLabel.text = "10/02/2022"
                cell.reviewerNameLabel.text = "Ahmed"
                cell.rateView.maximumValue = 5
                cell.rateView.minimumValue = 0
                cell.rateView.value = 2.5
                cell.reviewBodyLabel.text = "he standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from \"de Finibus Bonorum et Malorum\" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham."
                break
                
            case 4 :
                cell.dateLabel.text = "10/02/2022"
                cell.reviewerNameLabel.text = "Ali"
                cell.rateView.maximumValue = 5
                cell.rateView.minimumValue = 0
                cell.rateView.value = 5
                cell.reviewBodyLabel.text = " All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
                break
                
            case 5 :
                cell.dateLabel.text = "10/02/2022"
                cell.reviewerNameLabel.text = "Mazen"
                cell.rateView.maximumValue = 5
                cell.rateView.minimumValue = 0
                cell.rateView.value = 1
                cell.reviewBodyLabel.text = " All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
                break
            
            default:
                break
                
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 3
    }
}
