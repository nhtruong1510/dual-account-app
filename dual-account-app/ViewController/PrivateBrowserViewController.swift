//
//  PrivateBrowserViewController.swift
//  dual-account-app
//
//  Created by Huu Truong Nguyen on 11/17/21.
//

import UIKit
import WebKit

struct FavoriteWeb {
    let name: String
    let url: String
    let image: String
}
class PrivateBrowserViewController: UIViewController {

    // Do any additional setup after loading the view.
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var ctrHeightSeachView: NSLayoutConstraint!
    @IBOutlet weak var viewLoading: UIActivityIndicatorView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var viewFavorites: UIView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(nibWithCellClass: FavoritesWebCell.self)
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Properties
    var favoritesData = [
        FavoriteWeb(name: "Facebook", url: "https://fb.com", image: "https://is5-ssl.mzstatic.com/image/thumb/Purple115/v4/4c/7f/5f/4c7f5f07-b946-1b68-78c4-f996cc5a4506/source/100x100bb.jpg"),
        FavoriteWeb(name: "Instagram", url: "http://instagram.com/", image: "https://is4-ssl.mzstatic.com/image/thumb/Purple115/v4/5f/4f/64/5f4f645a-98af-6da4-2600-9a9b2569400b/source/100x100bb.jpg"),
        FavoriteWeb(name: "Twitter", url: "https://twitter.com/login", image: "https://is2-ssl.mzstatic.com/image/thumb/Purple125/v4/aa/b7/a4/aab7a42e-4905-4977-2143-399732cedb86/source/100x100bb.jpg"),
        FavoriteWeb(name: "Youtube", url: "https://www.youtube.com", image: "https://is4-ssl.mzstatic.com/image/thumb/Purple125/v4/2f/43/16/2f43168a-99be-99cd-83f2-b3086b15d40c/source/100x100bb.jpg"),
        FavoriteWeb(name: "Google", url: "https:google.com", image: "https://is5-ssl.mzstatic.com/image/thumb/Purple115/v4/d2/55/4b/d2554bcb-56a9-2d3e-550b-3458df026897/source/100x100bb.jpg")]
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ctrHeightSeachView.constant = isIPad ? 60 : 45
        tfSearch.font = tfSearch.font?.autoResize()
        webView.navigationDelegate = self
        tfSearch.delegate = self
        stopLoading()
        var cellWidth = 0
        if UIDevice.current.userInterfaceIdiom == .pad {
            cellWidth = Int(UIScreen.main.bounds.width) / 5 - 10
        } else {
            cellWidth = Int(UIScreen.main.bounds.width) / 3 - 10
        }
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: cellWidth, height: (cellWidth * 120) / 90)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.minimumInteritemSpacing = 0.0
        collectionView.collectionViewLayout = flowLayout
    }
    
    @IBAction func actionBack(_ sender: Any) {
        if viewFavorites.isHidden {
            webView.goBack()
        }
    }
    @IBAction func actionNext(_ sender: Any) {
        if viewFavorites.isHidden {
            webView.goForward()
        }
    }
    
    @IBAction func actionHome(_ sender: Any) {
        viewFavorites.isHidden = false
        tfSearch.endEditing(true)
        tfSearch.text = ""
        stopLoading()
    }
    
    @IBAction func backAction(){
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PrivateBrowserViewController {
    func seachURL(_ url: String?) {
        if let url = url {
            var myURL = URL(string: "https://google.com/search?q=\(url.encode())")
            if let myURLs = URL(string: url), url.contains("http") {
                myURL = myURLs
            }
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
    }

    func startLoading() {
        viewLoading.isHidden = false
        viewLoading.startAnimating()
    }

    func stopLoading() {
        viewLoading.isHidden = true
        viewLoading.stopAnimating()
    }
}

extension PrivateBrowserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        seachURL(textField.text)
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let url = stringByEvaluatingJavaScript(from: "document.URL")
        if url != "about:blank" && viewFavorites.isHidden {
            textField.text = url
        }
    }
}

extension PrivateBrowserViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        tfSearch.text = "Loading..."
        startLoading()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        tfSearch.text = "This site can’t be reached"
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewFavorites.isHidden = true
        let title = stringByEvaluatingJavaScript(from: "document.title")
        stopLoading()
        tfSearch.text = title
    }

    func stringByEvaluatingJavaScript(from script: String) -> String? {
        var resultString: String? = nil
        var finished = false

        webView.evaluateJavaScript(script, completionHandler: { result, error in
            if error == nil {
                if result != nil {
                    if let result = result {
                        resultString = "\(result)"
                    }
                }
            } else {
                print("evaluateJavaScript error : \(error?.localizedDescription ?? "")")
            }
            finished = true
        })

        while !finished {
            RunLoop.current.run(mode: .default, before: Date.distantFuture)
        }

        return resultString
    }
}

extension PrivateBrowserViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withClass: FavoritesWebCell.self, for: indexPath)
        item.config(data: favoritesData[indexPath.item])
        return item
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth = (collectionView.frame.width / (isIPad ? 6 : 4)) - 10
        return CGSize(width: maxWidth, height: maxWidth + 30)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        seachURL(favoritesData[indexPath.item].url)
    }
}

extension String {
    func encode()-> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    }
}

