//
//  ContributionViewController.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/01.
//

import Cocoa

class ContributionViewController: NSViewController {

    @IBOutlet weak var backgroundView: NSView!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var flowLayout: NSCollectionViewFlowLayout!
    
    @IBOutlet weak var usernameLabel: NSTextField!
    @IBOutlet weak var lastContributionCountLabel: NSTextField!
    @IBOutlet weak var lastContributionDateLabel: NSTextField!
    
    var config: ContributionViewConfiguration?
    
    private var contributions: [ContributionInfo] = []
    private var currentMaxContribution: ContributionInfo?
    
    private let userdefaults = UserDefaults.standard
    
    var currentUserName: String?
    var currentUIEnabled: Bool?
    
    var updateTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        // UDから設定値を読み込んで
        currentUserName = userdefaults.string(forKey: .UserName)
        currentUIEnabled = userdefaults.bool(forKey: .UIEnabled)

        // 通知センターから設定変更通知を受け取る
        NotificationCenter.default.addObserver(self, selector: #selector(onUserInteractionModeChanged(_:)), name: .kUserInteractionEnabledNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onUserNameChanged(_:)), name: .kUserNameChangedNotification, object: nil)
        
        // 定期更新を開始
        // TODO: 更新間隔
        self.updateTimer = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(onTimerUpdated), userInfo: nil, repeats: true)
    }
    
    // 定期更新時の処理
    @objc func onTimerUpdated(){
        // contributionを更新して
        print("Timer updated!")
        updateContribution()
        
        // 自動で端までスクロールし
        let contentWidth = flowLayout.collectionViewContentSize.width
        collectionView.scroll(NSPoint(x: contentWidth, y: 0))
        
        // UDに反映
        let formatter = DateFormatter()
        formatter.dateFormat = "y/M/d HH:mm:ss"
        userdefaults.setValue(formatter.string(from: Date()), forKey: .LastFetched)
    }
    
    // Usernameの値が変わったとき
    @objc func onUserNameChanged(_ sender: Any?){
        // 送られてきたオブジェクトをキャストしてcontribution更新
        guard let notification = sender as? NSNotification else {return}
        currentUserName = notification.object as? String
     
        updateContribution()
    }
    
    // UserIntearctionEnabledの値が変わったとき
    @objc func onUserInteractionModeChanged(_ sender: Any?){
        // 送られてきたオブジェクトをキャストしてウィンドウ更新
        guard let notification = sender as? NSNotification else {return}
        currentUIEnabled = notification.object as? Bool
        
        updateWindowAppearance()
    }
    
    override func viewWillAppear() {
        updateContribution()
        updateWindowAppearance()
    }
    
    // contributionを更新
    func updateContribution(){
        // パーサでデータを取得
        if let currentUserName = currentUserName{
            let parser = ContributionXMLParser(userName: currentUserName)
            do {
                try parser?.fetchContributions(completion: { (contributions) in
                    // 草を生やして
                    let sortedContributions = contributions.sorted()
                    self.contributions = sortedContributions
                    self.currentMaxContribution = sortedContributions.max(by: { (lhs, rhs) -> Bool in
                        return lhs.contributionCount < rhs.contributionCount
                    })!
                    
                    // ラベルに反映
                    if let lastContribution = contributions.last{
                        self.lastContributionCountLabel.stringValue = "\( lastContribution.contributionCount)"
                        let formatter = DateFormatter()
                        formatter.dateFormat = "y/M/d"
                        self.lastContributionDateLabel.stringValue = "(At: \(formatter.string(from: lastContribution.date)))"
                        self.usernameLabel.stringValue = currentUserName
                    }

                    self.collectionView.reloadData()
                })
            } catch {
                print(error.localizedDescription)
                self.contributions = .init(repeating: ContributionInfo(date: Date(), contributionCount: 0, level: 0), count: 365)
                self.collectionView.reloadData()
            }
        }
    }
    
    // ウィンドウの表示モードを更新
    func updateWindowAppearance(){
        setWindowAppearance(window: self.view.window, hiddenMode: !(currentUIEnabled ?? false))
    }
    
    override func viewDidAppear() {
        // 自動で端までスクロールさせる
        let contentWidth = flowLayout.collectionViewContentSize.width
        collectionView.scroll(NSPoint(x: contentWidth, y: 0))
    }
    
    override func viewDidDisappear() {
        // TODO: ここでinvalidateするとウィンドウレベル変えた時にタイマ止まっちゃいます
        self.updateTimer?.invalidate()
    }
}

extension ContributionViewController: NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contributions.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let contribution = self.contributions[indexPath[1]]
        let formatter = DateFormatter()
        formatter.dateFormat = "y/M/d"
        
        let item = collectionView.makeItem(withIdentifier: .init("grass"), for: indexPath) as! GrassCell
        item.contribution = contribution
        return item
    }
}
