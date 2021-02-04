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
    
    @IBOutlet weak var lastContributionCountLabel: NSTextField!
    @IBOutlet weak var lastContributionDateLabel: NSTextField!
    
    var contributionCounts: [UInt] = []
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
        
        // XMLから読み込んだデータを反映
        let parser = ContributionXMLParser(userName: "Enchan1207")
        do {
            try parser?.fetchContributions(completion: { (contributions) in
                // 草を生やして
                let sortedContributions = contributions.sorted()
                for contribution in sortedContributions{
                    self.contributionCounts.append(contribution.contributionCount)
                }
                self.currentMaxContribution = sortedContributions.max(by: { (lhs, rhs) -> Bool in
                    return lhs.contributionCount < rhs.contributionCount
                })!.contributionCount
                
                // ラベルに反映
                if let lastContribution = contributions.last{
                    self.lastContributionCountLabel.stringValue = "\( lastContribution.contributionCount)"
                    let formatter = DateFormatter()
                    formatter.dateFormat = "y/M/d"
                    self.lastContributionDateLabel.stringValue = "At: \(formatter.string(from: lastContribution.date))"
                }
                
            })
            collectionView.reloadData()
        } catch {
            print(error.localizedDescription)
            self.contributionCounts = .init(repeating: 0, count: 365)
        }
        
        // 通知センターから設定変更通知を受け取る
        NotificationCenter.default.addObserver(self, selector: #selector(onUserInteractionModeChanged(_:)), name: .kUserInteractionEnabledNotification, object: nil)
    }
    
    // UserIntearctionEnabledの値が変わったとき
    @objc func onUserInteractionModeChanged(_ sender: Any?){
        // 送られてきたオブジェクトをキャストして
        guard let notification = sender as? NSNotification else {return}
        
        // 表示
        guard let interactionEnabledFlag = notification.object as? Bool else {return}
        
        // ウィンドウ初期化
        setWindowAppearance(window: self.view.window, hiddenMode: !interactionEnabledFlag)
    }
    
    override func viewWillAppear() {
        // ウィンドウの外観を初期化
        setWindowAppearance(window: self.view.window, hiddenMode: false)
    }
    
    override func viewDidAppear() {
        // 自動で端までスクロールさせる
        let contentWidth = flowLayout.collectionViewContentSize.width
        collectionView.scroll(NSPoint(x: contentWidth, y: 0))
    }
}

extension ViewController: NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contributionCounts.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let contribution = self.contributionCounts[indexPath[1]]
        
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
