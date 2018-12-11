//
//  ViewController.swift
//  webProject
//
//  Created by Roberto Evangelista da Silva Filho on 10/12/2018.
//  Copyright © 2018 Roberto Evangelista da Silva Filho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var myData = [Dados]() {
        didSet{
            myTableView.reloadData()
        }
    }

    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        doGetRequest()
//        doPostRequest()
//        doDeleteRequest()
//        doPutRequest()
    }
    
    func doGetRequest() {
        let url = URL(string: "https://ios-twitter.herokuapp.com/api/v1/message")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data, error == nil else {
                print("Error")
                return
            }
            do {
                let decode = try JSONDecoder().decode([Dados].self, from: dataResponse)
                DispatchQueue.main.async {
                    self.myData = decode
                }
            } catch let parsinError {
                print("Error", parsinError)
            }
        }
        task.resume()
    }
    
    func doPostRequest() {
        let postURL = URL(string: "https://ios-twitter.herokuapp.com/api/v1/message")!
        var postRequest = URLRequest(url: postURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        postRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let parameters: [String: Any] = ["text": "Fade to Black"]
        do {
            let JSONParams = try JSONSerialization.data(withJSONObject: parameters, options: [])
            postRequest.httpBody = JSONParams
        } catch { print("Error: unable to add parameters to POST request in \(postRequest)") }
        let postTask = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            if error != nil { print("POST Request in \(postRequest) Error: \(error!)") }
            if data == nil {
                DispatchQueue.main.async {
                    print("Received empty response.")
                }
            } else {
                do {
                    let resultObject = try JSONSerialization.jsonObject(with: data!, options: [])
                    DispatchQueue.main.async {
                        print("Results from POST \(postRequest) :\n \(resultObject)")
                    }
                } catch { DispatchQueue.main.async { print("Unable to parse JSON response") } }
            }
        }
        DispatchQueue.global().async { postTask.resume() }
    }
    
    func doDeleteRequest(delete: String) {
        let id = delete
        let url = "https://ios-twitter.herokuapp.com/api/v1/message/"
        let deleteURL = URL(string: "\(url)\(id)")!
        var deleteRequest = URLRequest(url: deleteURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        deleteRequest.httpMethod = "DELETE"
        
        let deleteTask = URLSession.shared.dataTask(with: deleteRequest) { (data, response, error) in
            if error != nil {print("DELETE Request in \(deleteRequest) Error: \(error!)")}
            if data == nil {
                DispatchQueue.main.async {
                    print("Received empty response.")
                }
            
            } else {
                do {
                    let resultObject = try JSONSerialization.jsonObject(with: data!, options: [])
                    DispatchQueue.main.async {
                        print("Results from DELETE \(deleteRequest) :\n \(resultObject)")
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Unable to parse JSON response")
                    }
                }
            }
        }
        DispatchQueue.global().async { deleteTask.resume() }
    }
    
    func doPutRequest() {
        let id = "5c0ecee333db140004a44ca6"
        let url = "https://ios-twitter.herokuapp.com/api/v1/message/"
        let putURL = URL(string: url + id)!
        
        var putRequest = URLRequest(url: putURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        putRequest.httpMethod = "PUT"
        putRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        putRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let parameters: [String: Any] = ["text": "Master of Puppets"]
        
        do {
            let JSONParams = try JSONSerialization.data(withJSONObject: parameters, options: [])
            putRequest.httpBody = JSONParams
        } catch  {
            print("Error: unable to add parameters to PUT request in \(putRequest)")
        }
        
        let putTask = URLSession.shared.dataTask(with: putRequest) { (data, response, error) in
            if error != nil { print("PUT Request in \(putRequest) Error: \(error!)") }
            else if data == nil {
                DispatchQueue.main.async { print("Received empty response") }
            } else {
                do {
                    let resultObject = try JSONSerialization.jsonObject(with: data!, options: [])
                    DispatchQueue.main.async {
                        print("Results from PUT \(putRequest) :\n \(resultObject)")
                    }
                } catch { DispatchQueue.main.async { print("Unable to parse JSON response") } }
            }
        }
        DispatchQueue.global().async {
            putTask.resume()
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")
        cell?.textLabel?.text = myData[indexPath.row].text
        cell?.detailTextLabel?.text = myData[indexPath.row].updatedAt
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        doDeleteRequest(delete: myData[indexPath.row].id)
        myData.remove(at: indexPath.row)
        print("\(myData[indexPath.row]) was deleted")
    }
    
}
