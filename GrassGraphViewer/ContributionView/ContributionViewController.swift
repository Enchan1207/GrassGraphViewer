//
//  ContributionViewController.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/01.
//

import Cocoa

class ContributionViewController: NSViewController {

    // UI部品
    @IBOutlet weak var backgroundView: NSView!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var flowLayout: NSCollectionViewFlowLayout!
    @IBOutlet weak var usernameLabel: NSTextField!
    @IBOutlet weak var lastContributionCountLabel: NSTextField!
    @IBOutlet weak var lastContributionDateLabel: NSTextField!
    
    // properties
    private let notificationCenter = NotificationCenter.default
    private let manager: WindowManager = WindowManager()
    
    public var config: ContributionConfig?
    private var windowIdentifier: String?
    
    //* VC lifecycle *//
    
    override func viewDidLoad() {
        // UI初期設定
        setupContributionUI()
        
        // config変更通知を受け取る
        notificationCenter.addObserver(self, selector: #selector(onModifyConfig(_:)), name: .kConfigModifiedNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(onModifyVisibility(_:)), name: .kWindowVisibilityModifiedNotification, object: nil)
    }
    
    override func viewWillAppear() {
        // UI更新
        updateContributionUI()
        
        // ウィンドウIDを設定
        if let window = self.view.window as? ContributionWindow{
            self.windowIdentifier = window.windowIdentifier
        }
        
    }
    
    override func viewDidAppear() {
        // 自動で端までスクロール
        let contentWidth = flowLayout.collectionViewContentSize.width
        collectionView.scroll(NSPoint(x: contentWidth, y: 0))
    }
    
    deinit {
        notificationCenter.removeObserver(self, name: .kConfigModifiedNotification, object: nil)
        notificationCenter.removeObserver(self, name: .kWindowVisibilityModifiedNotification, object: nil)
    }
    
    // UI初期設定
    func setupContributionUI(){
        // collectionView設定
        let xib = NSNib(nibNamed: "GrassCell", bundle: nil)
        collectionView.register(xib, forItemWithIdentifier: .init("grass"))
        collectionView.dataSource = self

        collectionView.backgroundColors = [.clear]
        collectionView.enclosingScrollView?.drawsBackground = false
        collectionView.enclosingScrollView?.hasVerticalScroller = false
        collectionView.enclosingScrollView?.hasHorizontalScroller = false
        
        flowLayout.minimumLineSpacing = 2
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = NSSize(width: 11, height: 11)
    }
    
    // configをもとにUI更新
    func updateContributionUI(){
        guard let config = self.config else{return}
        usernameLabel.stringValue = config.userName
        if let lastContribution = config.contributions.last{
            lastContributionDateLabel.stringValue = DateFormatter.localizedString(from: lastContribution.date, dateStyle: .short, timeStyle: .none)
            lastContributionCountLabel.stringValue = String(lastContribution.contributionCount)
        }
        let userName = config.userName
        self.view.window?.title = "\(userName)'s Contribution Graph"
        collectionView.reloadData()
    }
    
    // ContributionGraph更新
    func updateContributionGraph(){
        // パーサを作って
        guard let userName = config?.userName else {return}
        guard let parser = ContributionXMLParser(userName: userName) else {return}
        
        // フェッチ
        do {
            try parser.fetchContributions { (contributions) in
                self.config?.contributions = contributions
                
                // 成功したらUI更新
                self.updateContributionUI()
            }
        } catch {
            print(error)
        }
    }
    
}

// Notification
extension ContributionViewController {
    // config変更通知を受け取ったとき
    @objc func onModifyConfig(_ notification: Notification){
        // notificationからobjectを受け取って変換し
        guard let (targetWindowID, newConfig) = notification.object as? (String, ContributionConfig) else {return}
        
        // 自分宛に送信されたものなら
        if(targetWindowID == self.windowIdentifier){
            // configを割り当てて更新
            self.config = newConfig
            self.updateContributionUI()
        }
    }
    
    // visibility変更通知を受け取ったとき
    @objc func onModifyVisibility(_ notification: Notification){
        // notificationからobjectを受け取って変換し
        guard let visibility = notification.object as? Bool else {return}
        
        // ウィンドウ表示設定に回す
        (self.view.window as? ContributionWindow)?.setDisplayMode(visibility ? .Foreground : .Background)
        updateContributionUI()
    }
}

// CollectionViewDataSource
extension ContributionViewController: NSCollectionViewDataSource{
    // セル数
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.config?.contributions.count) ?? 0
    }
    
    // 各セルに表示する内容
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .init("grass"), for: indexPath) as! GrassCell
        
        if let contribution = self.config?.contributions[indexPath[1]]{
            // 色指定
            if #available(OSX 10.13, *) {
                let itemColorName = "GrassColor/Level\(contribution.level)"
                item.backgroundColor = NSColor(named: itemColorName)
                item.borderColor = NSColor(named: "GrassColor/Border")
            } else {
                let defaultColorCodes = ["EBEDF0", "9BE9A8", "40C463", "30A14E", "216E39"]
                item.backgroundColor = NSColor(hexCode: defaultColorCodes[Int(contribution.level)]) ?? .green
                item.borderColor = .systemGray
            }
        }
        
        return item
    }
}
