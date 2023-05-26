//
//  VideoPreview.swift
//  YouTube-Clone
//
//  Created by s.Moscicki on 26/05/2023.
//

import Foundation
import Alamofire


class VideoPreview: ObservableObject {
    
    @Published var thumbailData = Data()
    @Published var title: String
    @Published var date: String
    
    var video: Video
    
    init(video: Video){
        
        // Set the video and title
        self.video = video
        self.title = video.title
        
        //Set the data
        let df = DateFormatter()
        df.dateFormat = "EEEE, MMM d, yyyy"
        self.date = df.string(from: video.published)
        
        //Download the image data
        guard video.thumbnail != "" else { return }
        
        //Check cache before dowloading data
        if let cachedData = CacheManager.getVideoCache(video.thumbnail) {
            // Set the thumbnail data
            thumbailData = cachedData
            return
            
        }
        
        
        
        // Get a url from the thumbnail
        guard let url = URL(string: video.thumbnail) else { return }
        
        // Create the request
        AF.request(url).validate().responseData { response in
            
            if let data = response.data {
                
                //Save the data in the cache
                CacheManager.setVideoCache(video.thumbnail, data)
                
                // Set the image
                DispatchQueue.main.async {
                    self.thumbailData = data
                }
                
                
            }
            
            
            
        }
        
    }
    
    
    
}
