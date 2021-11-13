//
//  CollectionViewLayout.swift
//  recordOrnamentsApp
//
//  Created by IwasakIYuta on 2021/09/24.
//

import Foundation
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
            heightDimension: .absolute(collectionView.bounds.width / 2)))
        
        item.contentInsets = .init(top: 2, leading: 5, bottom: 10, trailing: 5)
        
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(1000)),                     subitems: [item])
        
        //group.contentInsets = .init(top: 2, leading: 5, bottom: 0, trailing: 2)
        
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems =
            [
                .init(layoutSize: .init(
                        widthDimension: .fractionalWidth(0.95),
                        heightDimension: .absolute(45)),
                      elementKind: "header" ,
                      alignment: .top)
                
            ]
        
        return section
        
    }
    // Description
    
    func  accountCollectionViewLayout(_ collectionView: UICollectionView ) -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { [ weak self ] (index ,env) in
            if index == 0 {
                
                return  self?.descriptionCategories(collectionView.bounds.height / 7)
            } else if index == 2 {
                
                return  self?.descriptionCategories(collectionView.bounds.height / 10)
            }
            
            return  self?.descriptionCategories(collectionView.bounds.height / 9)
        }
        
        
        return layout
    }
    private func descriptionCategories(_ height: CGFloat) -> NSCollectionLayoutSection {
        //3 アイテムを作成
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1), //グループの100%
            heightDimension: .absolute(height)))//絶対値150の高さ
        // 4推定値1000（高さ）と幅が100%のグループが作成されるため　contentInsetsを使って間を開けてアイテムをちゃんと表示させるようにする
        item.contentInsets = .init(top: 0, leading: 5, bottom: 10, trailing: 5)
        
        //2 グループ作成
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1),//幅100%
            heightDimension: .estimated(1000)), //推定値1000の高さのグループ
                                                       subitems: [item])
       // group.contentInsets = .init(top: 0, leading: 5, bottom: 1, trailing: 5)
        //1 sectionを作成
        let section = NSCollectionLayoutSection(group: group)
        
        //header
        return section
        
    }
    
    
}
