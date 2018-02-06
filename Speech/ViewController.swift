//
// Copyright 2016 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import UIKit
import AVFoundation
import googleapis

let SAMPLE_RATE = 16000

class ViewController : UIViewController, AudioControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var bestResult:SpeechRecognitionAlternative?
    var orderArray = Array<[String: AnyObject]>()
    var audioData: NSMutableData!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioController.sharedInstance.delegate = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.recordButton.backgroundColor = UIColor(red: 46.0/255.0, green: 204.0/255.0, blue: 113.0/255.0, alpha: 1.0)
    }
    
    @IBAction func recordAudio(_ sender: NSObject) {
        print("start Audio")
        self.recordButton.backgroundColor = UIColor(red: 240.0/255.0, green: 52.0/255.0, blue: 52.0/255.0, alpha: 1.0)
//        self.sendResultToAPI(inputString: "fünf bier und eine Cola")
        self.orderArray = Array()
        self.bestResult = nil
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
        } catch {

        }
        audioData = NSMutableData()
        _ = AudioController.sharedInstance.prepare(specifiedSampleRate: SAMPLE_RATE)
        SpeechRecognitionService.sharedInstance.sampleRate = SAMPLE_RATE
        _ = AudioController.sharedInstance.start()
    }
    
    @IBAction func stopAudio(_ sender: NSObject) {
        print("stop Audio")
        _ = AudioController.sharedInstance.stop()
        SpeechRecognitionService.sharedInstance.stopStreaming()
        self.recordButton.backgroundColor = UIColor(red: 46.0/255.0, green: 204.0/255.0, blue: 113.0/255.0, alpha: 1.0)
    }
    
    func processSampleData(_ data: Data) -> Void {
        audioData.append(data)
        
        // We recommend sending samples in 100ms chunks
        let chunkSize : Int /* bytes/chunk */ = Int(0.1 /* seconds/chunk */
            * Double(SAMPLE_RATE) /* samples/second */
            * 2 /* bytes/sample */);
        
        if (audioData.length > chunkSize) {
            SpeechRecognitionService.sharedInstance.streamAudioData(audioData,
                                                                    completion:
                { [weak self] (response, error) in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let response = response {
                        var finished = false
                        var finalResult:StreamingRecognitionResult?
                        for result in response.resultsArray! {
                            if let result = result as? StreamingRecognitionResult {
                                if result.isFinal {
                                    finalResult = result
                                    finished = true
                                }
                            }
                        }
                        if finished {
                            var resultArray = Array<SpeechRecognitionAlternative>()
                            print("#############################")
                            if(finalResult != nil && finalResult?.alternativesArray != nil) {
                                for alternative in (finalResult!.alternativesArray) {
                                    if let alternative = alternative as? SpeechRecognitionAlternative {
                                        resultArray.append(alternative)
                                        print("\(alternative.confidence) - \(alternative.transcript!)")
                                    }
                                }
                            }
                            strongSelf.stopAudio(strongSelf)
                            resultArray.sort(by: { $1.confidence < $0.confidence })
                            if resultArray.capacity != 0 {
                                strongSelf.bestResult = resultArray.first
                                if(strongSelf.bestResult?.transcript != nil) {
                                    strongSelf.sendResultToAPI(inputString: strongSelf.bestResult!.transcript!)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                strongSelf.tableView.reloadData()
                            }
                        }
                    }
            })
            self.audioData = NSMutableData()
        }
    }
    
    func sendResultToAPI(inputString:String) {
        let headers = [
            "Content-Type": "application/json"
        ]
        let parameters = ["order": inputString] as [String : Any]
        var postData:Data? = nil
        do {
            postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://138.68.71.39:3000/apporder")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        if postData != nil {
            request.httpBody = postData as! Data
        }
        
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode == 200 {
                    do {
                        self.orderArray = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: AnyObject]>
                        DispatchQueue.main.async {
                            print(self.orderArray)
                            if(self.orderArray.count > 0) {
                                self.tableView.reloadData()
                            }
                            else {
                                let alert = UIAlertController(title: "Tut uns leid", message: "Es wurde leider kein Getränk gefunden", preferredStyle: .alert)
                                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                                alert.addAction(action)
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                }
                else {
                    print(httpResponse)
                }
            }
        })
        dataTask.resume()
    }
    
    //MARK: - TableView Methoden
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if self.bestResult != nil {
            count = self.orderArray.count + 1
        }
        print(count)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as! ResultTableViewCell
            if(self.bestResult != nil) {
                cell.setData(confidence: self.bestResult!.confidence, text: bestResult!.transcript)
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemTableViewCell", for: indexPath) as! OrderItemTableViewCell
            let orderObject:[String: AnyObject] = self.orderArray[indexPath.row - 1]
//            if(orderObject["size"] != nil) {
//                cell.orderSizeLabel.text = "\(orderObject["size"]!)"
//            }
//            else {
                cell.orderSizeLabel.text = ""
//            }
            if(orderObject["name"] != nil) {
                cell.orderNameLabel.text = "\(orderObject["name"]!)"
            }
            if(orderObject["nb"] != nil) {
                cell.orderCountLabel.text = "\(orderObject["nb"]!)"
            }
            
            return cell
        }
        
    }
    
}
