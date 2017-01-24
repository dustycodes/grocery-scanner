import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var delegate: AddItemFromScannerDelegate?
    private var _section: Section = Section()
    
    var section: Section {
        get {
            return _section
        }
        set {
            _section = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blackColor()
        captureSession = AVCaptureSession()
        
        let label = UILabel(frame: CGRect(x: 0, y: 40, width: view.bounds.width, height: 50))
        label.textAlignment = .Center
        label.textColor = UIColor.blackColor()
        label.text = "Scanning for section: \(_section.name)"
        
        let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        view.addSubview(label)
        
        captureSession.startRunning();
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.running == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.running == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(readableObject.stringValue);
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func foundCode(code: String) {
        print(code)
        
        requestUPCJSON(code)
    }
    
    func requestUPCJSON(code: String) {
        let requestURL: String = "http://www.searchupc.com/handlers/upcsearch.ashx?request_type=3&access_token=D335515C-5597-402A-8409-904F35F5D5C8&upc=\(code)"
        let url: NSURL = NSURL(string: requestURL)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler: {(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in NSOperationQueue.mainQueue().addOperationWithBlock(
            {
                if data == nil {
                    return
                }
                guard let httpResponse = response as? NSHTTPURLResponse else {
                    return
                }
                if(httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
                    return
                }
                
                let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                print(json)
                let name = json["0"]!!["productname"] as! String
                let imageURL = json["0"]!!["imageurl"] as! String
                //TODO price
                
                //check if there is even an imageURL
                if(imageURL == "N/A" || imageURL == "") {
                    dispatch_async(dispatch_get_main_queue()) {
                        let item = Item(name: name, description: "", image: UIImage())
                        self.delegate!.addItemFromScanner(item, section: self._section)
                    }
                }
                
                
                let url: NSURL = NSURL(string: imageURL)!
                let request: NSURLRequest = NSURLRequest(URL: url)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler: {(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in NSOperationQueue.mainQueue().addOperationWithBlock(
                    {
                        if data == nil {
                            return
                        }
                        guard let httpResponse = response as? NSHTTPURLResponse else {
                            return
                        }
                        if(httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
                            return
                        }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            let image = UIImage(data: data!)
                            let item = Item(name: name, description: "", image: image!)
                            self.delegate!.addItemFromScanner(item, section: self._section)
                        }
                    })
                })
        })
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    //Delegate
}