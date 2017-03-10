//
//  ViewController.swift
//  musicPlayer
//
//  Created by Kazama Ryusei on 2017/03/09.
//  Copyright © 2017年 Malfoy. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, MPMediaPickerControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    
    var player = MPMusicPlayerController()
    
    @IBAction func pickButton(_ sender: Any) {
        // MPMediaPickerControllerのインスタンスを作成
        let picker = MPMediaPickerController()
        // ピッカーのデリゲートを設定
        picker.delegate = self
        // 複数選択にする
        picker.allowsPickingMultipleItems = true
        // ピッカーを表示する
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func playButton(_ sender: Any) {
        player.play()
    }
    
    @IBAction func pauseButton(_ sender: Any) {
        player.pause()
    }
    
    @IBAction func stopButton(_ sender: Any) {
        player.stop()
    }
    
    @IBAction func returnButton(_ sender: Any) {
        player.skipToPreviousItem()
    }
    
    @IBAction func skipButton(_ sender: Any) {
        player.skipToNextItem()
    }
    
    
    // メディアアイテムピッカーでアイテムを選択完了したときに呼び出される
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        // プレイヤーを止める
        player.stop()
        
        // 選択した曲情報がmediaItemCollectionに入ってるので、これをプレイやーにセット
        player.setQueue(with: mediaItemCollection)
        
        // 選択した曲から最初の曲情報を表示
        if let mediaItem = mediaItemCollection.items.first {
            updateSongInfometionUI(mediaItem: mediaItem)
        }
        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
    }
    
    // 選択がキャンセルされた場合に呼ばれる
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
    }
    
    func nowPlayingItemChanged(notification: Notification) {
        // 通知
        if let mediaItem = player.nowPlayingItem {
            updateSongInfometionUI(mediaItem: mediaItem)
        }
    }
    
    func updateSongInfometionUI(mediaItem: MPMediaItem) {
        // 曲情報表示
        artistLabel.text = mediaItem.artist ?? "不明なアーティスト"
        albumLabel.text = mediaItem.albumTitle ?? "不明なアルバム"
        songLabel.text = mediaItem.title ?? "不明な曲"
        
        // アートワーク表示
        if let artwork = mediaItem.artwork {
            let image = artwork.image(at: imageView.bounds.size)
            imageView.image = image
        } else {
            // アートワークがないとき
            imageView.image = nil
            imageView.backgroundColor = UIColor.gray
        }
    }
    
    deinit {
        // 再生中アイテム変更に対する監視をはずす
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        // ミュージックプレーヤー通知の無効化
        player.endGeneratingPlaybackNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        player = MPMusicPlayerController.applicationMusicPlayer()
        // player = MPMusicPlayerController.systemMusicPlayer()にするとミュージックアプリの再生状況を反映する
        
        // 再生中のitemが変わった時に通知を受け取る
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(ViewController.nowPlayingItemChanged(notification:)), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        // 通知を有効化
        player.beginGeneratingPlaybackNotifications()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

