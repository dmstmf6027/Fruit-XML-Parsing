//  XCode 8.3.3
// ViewController.swift
//  Fruit_parsing
//
//  Created by 김종현 on 2017. 10. 21..
//  Copyright © 2017년 김종현. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var myTableView: UITableView!
    
    var strXMLData: String = ""
    var item:[String:String] = [:]
    var elements:[[String:String]] = []
    var currentElement = ""
    //var weAreInItem = false    // Item tag 내에 있을때 true
    //var weAreInElement = false // Element tag 내에 있을떄 true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
                 let strURL = "http://api.androidhive.info/pizza/?format=xml"
        
                 if NSURL(string: strURL) != nil {
                    if let parser = XMLParser(contentsOf: URL(string: strURL)!) {
                        parser.delegate = self

                        if parser.parse() {
                            print("parsing success")
                            print(elements)
                        } else {
                            print("parsing fail")
                        }
                        
                    }
                 }
        
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    
        
//
//        if let path = Bundle.main.url(forResource: "Fruit", withExtension: "xml") {
//
//            if let parser = XMLParser(contentsOf: path) {
//                parser.delegate = self
//                //print(path)
//
//                if parser.parse() {
//                    print("parsing success!")
//
//                } else {
//                    print("parsing failed!!")
//                }
//            }
//        } else {
//            print("xml file not found!!")
//        }
//
//    }
    
    
    
    // Tableview D
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = myTableView.dequeueReusableCell(withIdentifier: "RE", for: indexPath)
        let myIndex = indexPath.row
        myCell.textLabel?.text = elements[myIndex]["name"]
        myCell.detailTextLabel?.text = elements[myIndex]["cost"]
        return myCell
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        print("********elementName = \(elementName)")
        
        currentElement = elementName
        
        if elementName == "item" {
            //weAreInItem = true
            item = [:]
        } else if elementName == "elements" {
            //weAreInItem = true
            elements = []
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        print("data =  \(data)")
        if !data.isEmpty {
            item[currentElement] = data
            //print("currentElement = \(currentElement)")
            strXMLData = strXMLData + "\n\n" + item[currentElement]!
            print(strXMLData)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            elements.append(item)
            //print("item = \(item)")
            //print("elements = \(elements)")
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
}

