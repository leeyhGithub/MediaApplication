//
//  ContentCollectionViewHeader.swift
//  NexflixApp
//
//  Created by 이영현 on 2021/09/06.
//

import UIKit

class ContentCollectionViewHeader : UICollectionReusableView {  //header, footer가 될 수 있음
    let sectionNameLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sectionNameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        sectionNameLabel.textColor = .white
        sectionNameLabel.sizeToFit()
        
        addSubview(sectionNameLabel)
        
        sectionNameLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.top.bottom.leading.equalToSuperview().offset(10)
        }
    }
}
