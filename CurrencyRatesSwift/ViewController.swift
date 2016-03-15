//
//  ViewController.swift
//  CurrencyRatesSwift
//
//  Created by Evgeny Zakharov on 3/14/16.
//  Copyright © 2016 Evgeny Zakharov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let url = NSURL(string: "http://www.banki.ru/products/currency/cash/yaroslavl~/")
    var bankNames: [String] = []
    var usdBuyValues: [Float] = []
    var usdSellValues: [Float] = []
    
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var resultTableView: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    internal func prepareFloatValue(str: String) -> Float {
        if !str.isEmpty {
            //var str2: String
            var str = str.stringByReplacingOccurrencesOfString("\t", withString: "")
            str = str.stringByReplacingOccurrencesOfString("\n", withString: "")
            str = str.stringByReplacingOccurrencesOfString(",", withString: ".")
            //NSLog("String value: \(str)")
            let result = Float(str)
            //NSLog("Float value: \(result)")
            return result!
        }
        return 0
    }
    
    @IBAction func loadButtonPressed(sender: AnyObject) {

        //let html = try NSString(contentsOfURL: url!, usedEncoding: nil)
        
        let data = NSData(contentsOfURL: url!)
        let doc = TFHpple(HTMLData: data!)
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
        
        
        NSLog("end");
    }

}

