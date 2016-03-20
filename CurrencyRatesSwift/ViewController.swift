//
//  ViewController.swift
//  CurrencyRatesSwift
//
//  Created by Evgeny Zakharov on 3/14/16.
//  Copyright © 2016 Evgeny Zakharov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let url = "http://www.banki.ru/products/currency/cash/yaroslavl~/"
    var bankNames: [String] = []
    var usdBuyValues: [Float] = []
    var usdSellValues: [Float] = []
    
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var alert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // load html from url
    func getHtmlFromUrl(url: String, callback: (data: NSData?) -> Void) {
        if let url = NSURL(string: url) {
            NSURLSession.sharedSession().dataTaskWithURL(url) {
                (data, response, error) in
                dispatch_async(dispatch_get_main_queue(), {
                    callback(data: data)
                })
            }.resume()
        }
    }
    
    
    // make float value from string
    internal func prepareFloatValue(str: String) -> Float {
        if !str.isEmpty {
            var str = str.stringByReplacingOccurrencesOfString("\t", withString: "")
            str = str.stringByReplacingOccurrencesOfString("\n", withString: "")
            str = str.stringByReplacingOccurrencesOfString(",", withString: ".")
            let result = Float(str)
            return result!
        }
        return 0
    }
    
    // press load
    @IBAction func loadButtonPressed(sender: AnyObject) {

        //let html = try NSString(contentsOfURL: url!, usedEncoding: nil)
        
        alert = UIAlertController(title: "Loading data",
            message: "Please wait...",
            preferredStyle: .Alert)
        self.presentViewController(alert, animated: true, completion:nil)
        
        getHtmlFromUrl(url, callback: parseHtmlData)

    }
    
    // parse data and show it in table view 
    func parseHtmlData(data: NSData?) {
        
        let doc = TFHpple(HTMLData: data)
        
        var elements = doc.searchWithXPathQuery("//a[@class='font-bold']")
        for element in elements {
            //NSLog(element.content)
            bankNames += [element.content]
        }
        
        elements = doc.searchWithXPathQuery("//td[@data-currencies-code='usd' and @data-currencies-rate-buy]")
        for element in elements {
            let usdValue: String = String(element.content)
            let val = self.prepareFloatValue(usdValue)
            
            if val > 0 {
                usdBuyValues.append(val)
                //NSLog(String(val))
            }
        }
        
        elements = doc.searchWithXPathQuery("//td[@data-currencies-code='usd' and @data-currencies-rate-sell]")
        for element in elements {
            let usdValue: String = String(element.content)
            let val = self.prepareFloatValue(usdValue)
            
            if val > 0 {
                usdSellValues.append(val)
                //NSLog(String(val))
            }
        }
        
        for var i = 0; i < bankNames.count; i++ {
            NSLog("\(bankNames[i]) buy: \(usdBuyValues[i]) sell: \(usdSellValues[i])")
        }
        
        alert.dismissViewControllerAnimated(true, completion: nil)

    }

}

