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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collectionView設定
        let xib = NSNib(nibNamed: "CustomItem", bundle: nil)
        collectionView.register(xib, forItemWithIdentifier: .init("item"))
        collectionView.delegate = self
        collectionView.dataSource = self

        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        
        collectionView.reloadData()
        
    }
    
    override func viewDidAppear() {
        
    }
    
    override func viewDidLayout() {
        // collectionViewのフレームを取得
        let collectionViewFrame = collectionView.frame
        print(collectionViewFrame)
        
        // TODO: なんかここカクつく collectionView.frameから計算してるせいでなんかおかしい説ある
        // アイテム幅を計算
        let numberOfItemsInColumn: CGFloat = 5
        let numberOfItemsInRow: CGFloat = 3
        let itemWidth = (collectionViewFrame.width - flowLayout.minimumLineSpacing * (numberOfItemsInColumn - 1)) / numberOfItemsInColumn
        let itemHeight = (collectionViewFrame.height - flowLayout.minimumInteritemSpacing * (numberOfItemsInRow - 1)) / numberOfItemsInRow
        
        flowLayout.itemSize = NSSize(width: itemWidth, height: itemHeight)
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
        return 19
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .init("item"), for: indexPath) as! CustomItem
        return item
    }
    
    
}

