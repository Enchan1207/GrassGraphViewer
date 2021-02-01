//
//  ViewController.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/01.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // コントリビューションの状態を取得
        let dataURLString = "https://github.com/users/Enchan1207/contributions"
        guard let contributionData = try? Data(contentsOf: URL(string: dataURLString)!) else {
            fatalError("Fetch failed!")
        }
        guard let contributionString = String(data: contributionData, encoding: .utf8) else{return}
        
        // XMLパーサにそのままかけると途中で止まる(XMLのルールに反する記述があるため)ので、
        // <svg>~</svg>を切り出す ここクソ実装
        guard let regex = try? NSRegularExpression(pattern: "<svg .+? class=\"js-calendar-graph-svg\">.+?</svg>", options: [.dotMatchesLineSeparators]) else {
            fatalError("Compile failed!")
        }
        guard let matchedResult = regex.firstMatch(in: contributionString, options: [], range: NSRange(0..<contributionString.count)) else {
            fatalError("Couldn't find SVG data!")
        }
        
        let start = contributionString.index(contributionString.startIndex, offsetBy: matchedResult.range.location)
        let end = contributionString.index(start, offsetBy: matchedResult.range.length)
        let SVGDataString = String(contributionString[start..<end])
        
        let parser = XMLParser(data: SVGDataString.data(using: .utf8)!)
        parser.delegate = self
        parser.parse()
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

extension ViewController: XMLParserDelegate {
    
    // start to parse
    func parserDidStartDocument(_ parser: XMLParser) {
        print("Parse started.")
    }
    
    // detect start of element
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if let dataCount = attributeDict["data-count"], let dataDate = attributeDict["data-date"]{
            print("at \(dataDate) :\(dataCount) contributions")
        }
        
    }
    
    // detect end of element
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
    
    // detect characters
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Parse finished.")
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        fatalError("Parse Error!!!: \(parseError)")
    }
}

