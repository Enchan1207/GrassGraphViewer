//
//  ViewController.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/01.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var flowLayout: NSCollectionViewFlowLayout!
    
    var contributions: [Int] = []
    var currentMaxContribution = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collectionView設定
        let xib = NSNib(nibNamed: "CustomItem", bundle: nil)
        collectionView.register(xib, forItemWithIdentifier: .init("item"))
        collectionView.delegate = self
        collectionView.dataSource = self

        flowLayout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumLineSpacing = 2
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.scrollDirection = .horizontal
        
        // ダミーデータを突っ込む ここクソ実装
        for _ in 0..<365{
            // 一定確率で穴を開けてそれっぽくする
            let data: Int
            if(Int.random(in: 0..<3) == 0){
                data = 0
            }else{
                data = Int.random(in: 0..<5)
            }
            
            contributions.append(data)
        }
        currentMaxContribution = contributions.max() ?? 0
        
        collectionView.reloadData()
    }
    
    override func viewDidLayout() {
        updateCellSize()
    }
    
    // セルサイズ更新
    func updateCellSize(){
        // 親ビューのフレームを取得
        let collectionViewFrame = self.view.frame
        
        // collectionviewのマージンを取得
        let collectionViewInsets = (collectionView.collectionViewLayout as? NSCollectionViewFlowLayout)?.sectionInset
        
        // 横軸、縦軸に置きたいアイテム数を設定
        let numberOfItemsInColumn: CGFloat = 5
        let numberOfItemsInRow: CGFloat = 7
        
        // アイテム幅を計算
        let widthSpacings = flowLayout.minimumLineSpacing * (numberOfItemsInColumn - 1)
        let heightSpacings = flowLayout.minimumInteritemSpacing * (numberOfItemsInRow - 1)
        let verticalInsets = (collectionViewInsets?.top ?? 0) + (collectionViewInsets?.bottom ?? 0)
        let horizontalInsets = (collectionViewInsets?.left ?? 0) + (collectionViewInsets?.right ?? 0)
        
        let itemWidth = (collectionViewFrame.width - widthSpacings - horizontalInsets) / numberOfItemsInColumn
        let itemHeight = (collectionViewFrame.height - heightSpacings - verticalInsets) / numberOfItemsInRow
        
        flowLayout.itemSize = NSSize(width: itemHeight, height: itemHeight)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension ViewController: NSCollectionViewDelegate {
    
}

extension ViewController: NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        let columns = 53
        return columns * 7
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: .init("item"), for: indexPath) as! CustomItem
        
        // 生える草の色を設定
        if(indexPath[1] < self.contributions.count && self.contributions[indexPath[1]] > 0){
            // 0.0~1.0 コミットするほど0に近づく
            let contributionRate = 1.0 - Double(self.contributions[indexPath[1]]) / Double(self.currentMaxContribution)
            
            // 0.3~0.7に変換
            let brightness = contributionRate * 0.4 + 0.3
            
            item.color = .init(hue: 0.33, saturation: 0.8, brightness: CGFloat(brightness), alpha: 1)
        }else{
            item.color = .lightGray
        }
        return item
    }
    
    
}

