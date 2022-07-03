//
//  ReviewsVM.swift
//  Shopify
//
//  Created by Nader Said on 03/07/2022.
//

import Foundation

class ReviewsVM
{
    init()
    {
        getReviews()
    }
    
    //MARK: - Var(s)
    private(set) var reviewList = Observable<[Review]>([])
    
    
    //MARK: - Helper Funcs
    func getReviews()
    {
        reviewList.value =
        [
            Review(reviewDate: "11/02/2022", reviewer: "Nader", rate: 3.5, reviewBody: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley"),
            Review(reviewDate: "10/02/2022", reviewer: "Moatz", rate: 4.5, reviewBody: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. "),
            Review(reviewDate: "14/02/2022", reviewer: "Mohamed", rate: 4, reviewBody: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. "),
            Review(reviewDate: "18/02/2022", reviewer: "Ahmed", rate: 2, reviewBody: "he standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from \"de Finibus Bonorum et Malorum\" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham."),
            Review(reviewDate: "10/03/2022", reviewer: "Ali", rate: 2.5, reviewBody: " All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."),
            Review(reviewDate: "17/02/2022", reviewer: "abdo", rate: 1, reviewBody: " All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."),
        ]
    }
}
