//
//  ViewController.swift
//  MeetInEvent
//
//  Created by Gloria Cai on 12/8/20.
//  Copyright © 2020 Gloria Cai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var filterCV: UICollectionView!
    let padding: CGFloat = 8
    let filterReuseIdentifier = "filterReuseIdentifier"
    var filter1 = FilterType(filtertype: "Popularity", isSelected: false)
    var filter2 = FilterType(filtertype: "Latest", isSelected: false)
    var filter3 = FilterType(filtertype: "Friends Only", isSelected: false)
    var filter4 = FilterType(filtertype: "Topic", isSelected: false)
        
    var filters: [FilterType] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filterLayout = UICollectionViewFlowLayout()
        filterLayout.scrollDirection = .horizontal
        filterLayout.minimumInteritemSpacing = padding
        filterLayout.minimumLineSpacing = 0
      
        filterCV = UICollectionView(frame: .zero, collectionViewLayout: filterLayout)
        filterCV.backgroundColor = .white
        filterCV.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: filterReuseIdentifier)
        filterCV.dataSource = self
        filterCV.delegate = self
        filterCV.translatesAutoresizingMaskIntoConstraints = false
        
        filters = [filter1, filter2, filter3, filter4]
        view.addSubview(filterCV)
        
        
        setupConstraints()
        
    }

    func setupConstraints(){
        NSLayoutConstraint.activate([
          filterCV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
           filterCV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
           filterCV.heightAnchor.constraint(equalToConstant: 50),
          filterCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ]);
       
    }

}

    

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filterCV.dequeueReusableCell(withReuseIdentifier: filterReuseIdentifier, for: indexPath) as! FilterCollectionViewCell
                             cell.configure(filter: filters[indexPath.item])
                             return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return filters.count
        
    }
}
   
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let size = (filterCV.frame.width - 2 * padding)/4.0
            return CGSize(width: size, height: 40)

        }
    }

//extension ViewController: UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if(collectionView == filterCV){
//        let f = filters[indexPath.item]
//        if(f.isSelected){
//            filters[indexPath.item].isSelected = false
//        }
//        else{
//            filters[indexPath.item].isSelected = true
//        }
//         var   falseCount = 0
//            restaurants.removeAll()
//             for filter in filters{
//                       if (filter.isSelected == false)
//                       {falseCount+=1}
//
//                   }
//                   if(falseCount == filters.count){
//                       for r in allRestaurants{
//                           restaurants.append(r)
//                       }}
//                   else{
//                   for r in allRestaurants{
//                       if(r.type.isSelected){
//                           restaurants.append(r)
//                    }
//                           }}
//        filterCV.reloadData()
//        restaurantCV.reloadData()
//        }
    


