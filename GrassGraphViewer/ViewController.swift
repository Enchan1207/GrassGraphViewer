//
//  ViewController.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/01.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var backgroundView: NSView!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var flowLayout: NSCollectionViewFlowLayout!
    
    var contributions: [UInt] = []
    var currentMaxContribution: UInt = 0
    
    let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collectionView設定
        let xib = NSNib(nibNamed: "CustomItem", bundle: nil)
        collectionView.register(xib, forItemWithIdentifier: .init("item"))
        collectionView.dataSource = self

        collectionView.backgroundColors = [.clear]
        collectionView.enclosingScrollView?.drawsBackground = false
        collectionView.enclosingScrollView?.hasVerticalScroller = false
        collectionView.enclosingScrollView?.hasHorizontalScroller = false
        
        flowLayout.minimumLineSpacing = 2
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = NSSize(width: 11, height: 11)
        
        // backgroundView設定
        backgroundView.wantsLayer = true
        backgroundView.layer?.backgroundColor = .init(gray: 0, alpha: 0.3)
        
        // XMLから読み込んだデータを反映
        let parser = ContributionXMLParser(userName: "Enchan1207")
        do {
            try parser?.fetchContributions(completion: { (contributions) in
                let sortedContributions = contributions.sorted()
                for contribution in sortedContributions{
                    self.contributions.append(contribution.contributionCount)
                }
                self.currentMaxContribution = sortedContributions.max(by: { (lhs, rhs) -> Bool in
                    return lhs.contributionCount < rhs.contributionCount
                })!.contributionCount
            })
            collectionView.reloadData()
        } catch {
            print(error.localizedDescription)
            self.contributions = .init(repeating: 0, count: 365)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferenceDidChange(_:)), name: .kPreferenceUpdatedNotification, object: nil)
    }
    
    @objc func preferenceDidChange(_ sender: Any?){
        // 送られてきたオブジェクトをキャストして
        guard let notification = sender as? NSNotification else {return}
        
        // 値を当てる
        let windowLevelInt = notification.object as! Int32
        guard let windowLevelKey = CGWindowLevelKey(rawValue: windowLevelInt) else{return}
        
        self.view.window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(windowLevelKey)))
        
    }
    
    override func viewWillAppear() {
        // ウィンドウ初期化
        if let window = self.view.window{
            setWindowAppearance(window: window, hiddenMode: false)
        }else{
            assertionFailure("Window object is nil!")
        }
    }
    
    override func viewDidAppear() {
        let contentWidth = flowLayout.collectionViewContentSize.width
        collectionView.scroll(NSPoint(x: contentWidth, y: 0))
    }
}

extension ViewController: NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contributions.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let contribution = self.contributions[indexPath[1]]
        
        // セル作って
        let item = collectionView.makeItem(withIdentifier: .init("item"), for: indexPath) as! CustomItem
        
        item.contributionCount = contribution
        
        // 色指定
        if #available(OSX 10.13, *) {
            item.borderColor = NSColor(named: "GrassColor/Border")
        } else {
            item.borderColor = .systemGray
        }
        
        // 最大コミット数に占めるコミット数の割合を計算
        let contributionRate = Double(contribution) / Double(self.currentMaxContribution)
        
        // 5段階に分けて色設定
        let itemColorName: String
        switch contributionRate {
        case let n where n > 0 && n < 0.2:
            itemColorName = "GrassColor/Level1"
        case 0.2..<0.4:
            itemColorName = "GrassColor/Level2"
        case 0.4..<0.8:
            itemColorName = "GrassColor/Level3"
        case 0.8..<1.0:
            itemColorName = "GrassColor/Level4"
        default:
            itemColorName = "GrassColor/Background"
        }
        if #available(OSX 10.13, *) {
            item.backgroundColor = NSColor(named: itemColorName)
        } else {
            // TODO: 対応してなければHSBでそれっぽいのを作る
            item.backgroundColor = .green
        }
        
        return item
    }
    
    
}
