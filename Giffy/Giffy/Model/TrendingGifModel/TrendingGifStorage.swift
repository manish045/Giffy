//
//  TrendingGifStorage.swift
//  Giffy
//
//  Created by Manish Tamta on 17/06/2022.
//

import Foundation
import RealmSwift

extension TrendingGIFModel: Entity {

    private var storableResponseModel: StorableTrendingGIFModel {
        let realmTrendingGIF = StorableTrendingGIFModel()
        realmTrendingGIF.id = id
        realmTrendingGIF.source = source
        realmTrendingGIF.title = title
        realmTrendingGIF.rating = rating
        realmTrendingGIF.images = images?.toStorable()
        realmTrendingGIF.username = username
        return realmTrendingGIF
    }
    
    func toStorable() -> StorableTrendingGIFModel {
        return storableResponseModel
    }
}

class StorableTrendingGIFModel: Object, Storable {
    
    @Persisted var id: String
    @Persisted var source : String?
    @Persisted var title: String?
    @Persisted var rating : String?
    @Persisted var images : StorableImages?
    @Persisted var username: String?
    @Persisted var uuid: String = ""
    
    var model: TrendingGIFModel {
        get {
            return TrendingGIFModel(id: id,
                                    source: source,
                                    title: title,
                                    rating: rating,
                                    images: images?.model,
                                    username: username)
        }
    }
}

extension Images: Entity {
    private var storableImageDetails: StorableImages {
        let realmImageDetails = StorableImages()
        realmImageDetails.downsized = downsized?.toStorable()
        return realmImageDetails
    }
    
    func toStorable() -> StorableImages {
        return storableImageDetails
    }
}

class StorableImages: EmbeddedObject, Storable {
    
    @Persisted var downsized: StorableDownsized?
    @Persisted var uuid: String = ""

    var model: Images {
        get {
            return Images(downsized: downsized?.model)
        }
    }
}

extension Downsized: Entity {
    private var storableDownsized: StorableDownsized {
        let realmDownsizedDetails = StorableDownsized()
        realmDownsizedDetails.width = width
        realmDownsizedDetails.height = height
        realmDownsizedDetails.url = url
        return realmDownsizedDetails
    }
    
    func toStorable() -> StorableDownsized {
        return storableDownsized
    }
}

class StorableDownsized: EmbeddedObject, Storable {
    
    @Persisted var width: String?
    @Persisted var height: String?
    @Persisted var url: String?
    @Persisted var uuid: String = ""

    var model: Downsized {
        get {
            return Downsized(width: width,
                             height: height,
                             url: url)
        }
    }
}


public protocol Entity {
    associatedtype StoreType: Storable
    
    func toStorable() -> StoreType
}

public protocol Storable {
    associatedtype EntityObject: Entity
    
    var model: EntityObject { get }
    var uuid: String { get }
}
