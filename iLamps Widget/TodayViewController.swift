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

var inputStream: InputStream!
var outputStream: NSOutputStream!
var readStream:  Unmanaged<CFReadStream>?
var writeStream: Unmanaged<CFWriteStream>?

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var onDesktopButton: UIButton!
    @IBOutlet weak var offDesktopButton: UIButton!
    @IBOutlet weak var onBedButton: UIButton!
    @IBOutlet weak var offBedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onDesktopButton.layer.cornerRadius = 3
        offDesktopButton.layer.cornerRadius = 3
        onBedButton.layer.cornerRadius = 3
        offBedButton.layer.cornerRadius = 3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let superview = view.superview {
            var frame = superview.frame
            frame = CGRect(x: 0, y: frame.minY, width: frame.width + frame.minX, height: frame.height)
            superview.frame = frame
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    @IBAction func onDesktop(_ sender: AnyObject) {
        connectToServer()
        sendData(Actions.onDesktop)
    }
    
    @IBAction func offDesktop(_ sender: AnyObject) {
        connectToServer()
        sendData(Actions.offDesktop)
    }
    
    @IBAction func onBed(_ sender: AnyObject) {
        connectToServer()
        sendData(Actions.onBed)
    }
    
    @IBAction func offBed(_ sender: AnyObject) {
        connectToServer()
        sendData(Actions.offBed)
    }
    
    func connectToServer() {
        CFStreamCreatePairWithSocketToHost(nil, serverAddress, serverPort, &readStream, &writeStream)
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.schedule(in: RunLoop.current(), forMode: RunLoopMode.defaultRunLoopMode)
        outputStream.schedule(in: RunLoop.current(), forMode: RunLoopMode.defaultRunLoopMode)
        
        inputStream.open()
        outputStream.open()
    }
    
    func sendData(_ action: Int) {
        let signal = String(action)
        let data = signal.data(using: String.Encoding.utf8)
        if outputStream.write(UnsafePointer<UInt8>((data! as NSData).bytes), maxLength: data!.count) == -1 {
            let error = outputStream.streamError?.description
            let errorPopup: UIAlertController = UIAlertController(title: "Error", message: "An error as occured \(error)", preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in }
            errorPopup.addAction(okAction)
            present(errorPopup, animated: true, completion: nil)
        }
    }
    
}
