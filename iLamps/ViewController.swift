//
//  ViewController.swift
//  iLamps
//
//  Created by PAPAV Fleury on 10/06/2015.
//  Copyright © 2015 Paul Fleury. All rights reserved.
//

import UIKit

struct Actions {
    static let onDesktop = 1
    static let offDesktop = 2
    static let onBed = 3
    static let offBed = 4
}

let serverAddress: CFString = "paulf.tk"
let serverPort: UInt32 = 1024

var inputStream: NSInputStream!
var outputStream: NSOutputStream!
var readStream:  Unmanaged<CFReadStream>?
var writeStream: Unmanaged<CFWriteStream>?

class ViewController: UIViewController {
    
    @IBAction func onDesktop(sender: AnyObject) {
        sendData(Actions.onDesktop)
    }
    
    @IBAction func offDesktop(sender: AnyObject) {
        sendData(Actions.offDesktop)
    }
    
    @IBAction func onBed(sender: AnyObject) {
        sendData(Actions.onBed)
    }
    
    @IBAction func offBed(sender: AnyObject) {
        sendData(Actions.offBed)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CFStreamCreatePairWithSocketToHost(nil, serverAddress, serverPort, &readStream, &writeStream)
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        inputStream.open()
        outputStream.open()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendData(action: Int) {
        let signal = String(action)
        let data = signal.dataUsingEncoding(NSUTF8StringEncoding)
        if outputStream.write(UnsafePointer<UInt8>(data!.bytes), maxLength: data!.length) == -1 {
            let error = outputStream.streamError?.description
            if #available(iOS 8.0, *) {
                let errorPopup: UIAlertController = UIAlertController(title: "Error", message: "An error as occured \(error)", preferredStyle: .Alert)
                let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in }
                errorPopup.addAction(okAction)
                presentViewController(errorPopup, animated: true, completion: nil)
            }
        }
    }
    
    
}

