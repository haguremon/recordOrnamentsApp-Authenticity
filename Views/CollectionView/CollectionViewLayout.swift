//
//  CollectionViewLayout.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/24.
//

import UIKit

final class  CollectionViewLayout {
    
    
    func  ornamentCollectionViewLayout(collectionView: UICollectionView) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [ weak self ] (index ,env) in
            self?.ornamentCategories(collectionView)
        }
        return layout
    }
   
    
    private func ornamentCategories(_ collectionView: UICollectionView ) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .absolute(collectionView.bounds.width / 1.7)))
        
        item.contentInsets = .init(top: 2, leading: 5, bottom: 10, trailing: 5)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(1000)),                     subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems =
            [
                .init(layoutSize: .init(
                        widthDimension: .fractionalWidth(0.95),
                        heightDimension: .absolute(collectionView.bounds.width / 5.8)),
                      elementKind: "header" ,
                      alignment: .top)
                
            ]
        
        return section
        
    }
    
    
    func  accountCollectionViewLayout(_ cgFloat: CGFloat) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [ weak self ] (index ,env) in
            
            if index == 0 {
                return  self?.descriptionCategories(cgFloat / 1.5)
            } else if index == 2 {
                return  self?.descriptionCategories(cgFloat / 2.6)
            }
            return  self?.descriptionCategories(cgFloat / 2)
        }
        return layout
    }
    
    
    private func descriptionCategories(_ height: CGFloat) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(height)))
   
        item.contentInsets = .init(top: 0, leading: 5, bottom: 10, trailing: 5)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(1000)),
            subitems: [item])
    
        let section = NSCollectionLayoutSection(group: group)
        
        return section
        
    }
    
    
}
