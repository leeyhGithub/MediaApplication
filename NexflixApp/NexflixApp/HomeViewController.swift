//
//  HomeViewController.swift
//  NexflixApp
//
//  Created by 이영현 on 2021/09/06.
//

import UIKit
import SwiftUI

class HomeViewController: UICollectionViewController{
    
    var contents: [Content] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //네비게이션 설정
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "netflix_icon"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: nil, action: nil)
       
       
        //CollectionView Item(Cell) 설정
        collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: "ContentCollectionViewCell")
        collectionView.register(ContentCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ContentCollectionViewHeader")
        collectionView.register(ContentCollectionViewRankCell.self, forCellWithReuseIdentifier: "ContentCollectionViewRankCell")
        collectionView.collectionViewLayout = layout()
        
        //Data 설정, 가져오기
        contents = getContent()
    }
    
    func getContent() -> [Content] {
        guard let path = Bundle.main.path(forResource: "Content", ofType: "plist"),
              let data = FileManager.default.contents(atPath: path),
              let list = try? PropertyListDecoder().decode([Content].self, from: data) else { return []}
        return list
    }
    
    
    //각각의 섹션 타입에 대한 UICollectionViewLayout 생성
    private func layout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {[weak self] sectionNumber, environment -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            switch self.contents[sectionNumber].sectionType {
            case .basic:
                return self.createBasicTypeSection()
            case .large:
                return self.createLargeTypeSection()
            case .rank:
                return self.createRankTypeSection()
            default :
                return nil
            }
        }
    }
    
    // 기본 section layout 설정
    private func createBasicTypeSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        //secion
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems  = [sectionHeader]
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        return section
    }
    
    //큰 화면 section layout 설정
    private func createLargeTypeSection() -> NSCollectionLayoutSection{
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(400))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        return section
        
    }
    
    //순위 표시 Section Layout 설정
    private func createRankTypeSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.9))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        return section
    }
    
    //Section Header layout 설정
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        //Section Header 사이즈
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
        
        //section header layout
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }
}

//UICollectionView DataSource, Delegate
extension HomeViewController {
    //섹션당 보여질 셀의 개수
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if contents[section].sectionType == .basic || contents[section].sectionType == .large || contents[section].sectionType == .rank{
            switch section {
            case 0:
                return 1
            default:
                return contents[section].contentItem.count
            }
        }
        else {
            return 0
        }
    }
    
    //콜렉션뷰 셀 설정
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch contents[indexPath.section].sectionType {
        case .basic, .large:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as? ContentCollectionViewCell else {return UICollectionViewCell()}
            cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
            return cell
        case .rank:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewRankCell", for: indexPath) as? ContentCollectionViewRankCell else { return UICollectionViewCell() }
            cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
            cell.rankLabel.text = String(describing: indexPath.row + 1)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    //헤더뷰 설정
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ContentCollectionViewHeader", for: indexPath) as? ContentCollectionViewHeader else { fatalError("Could not dequeue Header")}
            
            headerView.sectionNameLabel.text = contents[indexPath.section].sectionName
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
    //섹션 개수 설정
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contents.count
    }
    
    //셀 선택
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionName = contents[indexPath.section].sectionName
        print("TEST: \(sectionName)섹션의 \(indexPath.row + 1)번째 컨텐츠")
    }
}

struct HomeViewController_Preview: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let layout = UICollectionViewLayout()
            let homeViewController = HomeViewController(collectionViewLayout: layout)
            return UINavigationController(rootViewController: homeViewController)
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
        
        typealias UIViewControllerType = UIViewController
    }
}
