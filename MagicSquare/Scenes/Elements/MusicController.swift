//
//  MusicController.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 25/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import AVFoundation

public class MusicController {
    
    public var music: AVAudioPlayer?
    public var sound: AVAudioPlayer?
    var currentMusic: String!
    
    static let sharedInstance: MusicController = {
        let instance = MusicController()
        return instance
    }()
    
    private init(){}
    
    func play(music: String, type: String){
        if (currentMusic == nil || currentMusic != music) {
            do {
                let path = Bundle.main.path(forResource: music, ofType:type)!
                let url = URL(fileURLWithPath: path)
                
                let music = try AVAudioPlayer(contentsOf: url)
                self.music = music
                music.numberOfLoops = -1
                music.prepareToPlay()
                music.play()
            } catch {
                print("couldn't load file")
            }

            currentMusic = music
        }
    }
    
    func play(sound: String, type: String){
        do {
            let path = Bundle.main.path(forResource: sound, ofType:type)!
            let url = URL(fileURLWithPath: path)
            
            let sound = try AVAudioPlayer(contentsOf: url)
            self.sound = sound
            sound.numberOfLoops = 0
            sound.prepareToPlay()
            sound.play()
        } catch {
            print("couldn't load file")
        }
    }
    
    func stop() {
        music?.stop()
        sound?.stop()
        currentMusic = ""
    }
}
