//
//  ViewController.swift
//  RealmSeminar
//
//  Created by jigeonho on 2017. 10. 25..
//  Copyright © 2017년 jigeonho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension UIViewController{
    
    func debugPrint(debug: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        #if DEBUG
            var filename: NSString = file as NSString
            filename = filename.lastPathComponent as NSString
            Swift.print("파일: \(filename), 라인: \(line), 함수: \(function) \n\(debug)")
        #endif
    }
}
