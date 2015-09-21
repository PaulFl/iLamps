//
//  TodayViewController.swift
//  iLamps Widget
//
//  Created by Paul Fleury on 21/09/15.
//  Copyright © 2015 Paul Fleury. All rights reserved.
//

import UIKit
import NotificationCenter

struct Actions {
    static let onDesktop = 1
    static let offDesktop = 2
    static let onBed = 3
    static let offBed = 4
}

let serverAddress: CFString = "78.227.97.91"
let serverPort: UInt32 = 1024

var inputStream: NSInputStream!
var outputStream: NSOutputStream!
var readStream:  Unmanaged<CFReadStream>?
var writeStream: Unmanaged<CFWriteStream>?

class TodayViewController: UIViewController, NCWidgetProviding {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.NewData)
    }
    @IBAction func onDesktop(sender: AnyObject) {
        connectToServer()
        sendData(Actions.onDesktop)
    }
    
    func connectToServer() {
        CFStreamCreatePairWithSocketToHost(nil, serverAddress, serverPort, &readStream, &writeStream)
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        inputStream.open()
        outputStream.open()
    }
    
    func sendData(action: Int) {
        let signal = String(action)
        let data = signal.dataUsingEncoding(NSUTF8StringEncoding)
        if outputStream.write(UnsafePointer<UInt8>(data!.bytes), maxLength: data!.length) == -1 {
            let error = outputStream.streamError?.description
            let errorPopup: UIAlertController = UIAlertController(title: "Error", message: "An error as occured \(error)", preferredStyle: .Alert)
            let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in }
            errorPopup.addAction(okAction)
            presentViewController(errorPopup, animated: true, completion: nil)
        }
    }
    
}
