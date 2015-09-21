import Foundation

let addr = "127.0.0.1"
let port = 3000
var inp: NSInputStream?
var out: NSOutputStream?


NSStream.getStreamsToHostWithName(addr, port: port, inputStream: &inp, outputStream: &out)
    let inputStream = inp!
    let outputStream = out!
    inputStream.open()
    outputStream.open()
while true {
    if inputStream.hasBytesAvailable {
        let bufferSize = 1024
        var inputBuffer = Array<UInt8>(count:bufferSize, repeatedValue: 0)
        let bytesRead = inputStream.read(&inputBuffer, maxLength: bufferSize)
        let str = String(bytesRead, NSUTF8StringEncoding)
        
    }
}

    //encode as string and print
