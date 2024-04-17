//
//  MessagesExample.swift
//

import Foundation
import Algorithms

struct Selection {
    var indexPathsForSelectedRows: [IndexPath] = []
}

enum Attachment {
    case photo(String)
    case video(String)
}

protocol TranscriptItem {
    var date: Date { get }
    var content: String { get }
}

struct TextItem: TranscriptItem {
    var date: Date
    var content: String
}

struct PhotoItem: TranscriptItem {
    var date: Date
    var photo: String
    var content: String { "PHOTO: \(photo)" }
}

struct VideoItem: TranscriptItem {
    var date: Date
    var video: String
    var content: String { "VIDEO: \(video)" }
}

struct DateItem: TranscriptItem {
    var date: Date
    var content: String { date.formatted() }
}

struct Message {
    var sender: Bool = true
    var date: Date
    var attachment: Attachment?
    var text: String = ""
    
    func makeMessageParts() -> [TranscriptItem] {
        var parts = [TranscriptItem]()
        if !text.isEmpty {
            parts.append(TextItem(date: date, content: text))
        }
        switch attachment {
        case .photo(let string):
            parts.append(PhotoItem(date: date, photo: string))
        case .video(let string):
            parts.append(VideoItem(date: date, video: string))
        case nil:
            break
        }
        return parts
    }
}

func makeMessageContent() -> [Message] {
    // Sample data
    let photoURL = "https://example.com/photo.jpg"
    let videoURL = "https://example.com/video.mp4"
    let currentDate = Date(timeIntervalSince1970: 1712492028)

    // Array of 30 hardcoded messages
    let messages: [Message] = [
        // Text messages
        Message(date: currentDate, attachment: nil, text: "Hello, how are you?"),
        Message(date: currentDate.addingTimeInterval(60), attachment: nil, text: "I'm fine, thank you!"),
        Message(date: currentDate.addingTimeInterval(120), attachment: nil, text: "What are you up to today?"),
        Message(date: currentDate.addingTimeInterval(180), attachment: nil, text: "Just relaxing at home."),
        Message(date: currentDate.addingTimeInterval(240), attachment: nil, text: "Sounds nice."),
        
        // Photo messages
        Message(date: currentDate.addingTimeInterval(300), attachment: .photo(photoURL), text: ""),
        Message(date: currentDate.addingTimeInterval(360), attachment: .photo(photoURL), text: ""),
        Message(date: currentDate.addingTimeInterval(420), attachment: .photo(photoURL), text: ""),
        
        // Video messages
        Message(date: currentDate.addingTimeInterval(480), attachment: .video(videoURL), text: ""),
        Message(date: currentDate.addingTimeInterval(540), attachment: .video(videoURL), text: ""),
        Message(date: currentDate.addingTimeInterval(600), attachment: .video(videoURL), text: ""),
        
        // Mix of text and attachments
        Message(date: currentDate.addingTimeInterval(660), attachment: .photo(photoURL), text: "Check out this photo!"),
        Message(date: currentDate.addingTimeInterval(720), attachment: nil, text: "Have you seen the latest episode of the show?"),
        Message(date: currentDate.addingTimeInterval(780), attachment: .video(videoURL), text: "No, not yet."),
        
        // More text messages
        Message(date: currentDate.addingTimeInterval(840), attachment: nil, text: "You should definitely watch it."),
        Message(date: currentDate.addingTimeInterval(900), attachment: nil, text: "I'll try to find some time for it."),
        Message(date: currentDate.addingTimeInterval(960), attachment: nil, text: "Let me know what you think!"),
        
        // More photo messages
        Message(date: currentDate.addingTimeInterval(6020), attachment: .photo(photoURL), text: ""),
        Message(date: currentDate.addingTimeInterval(6080), attachment: .photo(photoURL), text: ""),
        Message(date: currentDate.addingTimeInterval(6140), attachment: .photo(photoURL), text: ""),
        
        // More video messages
        Message(date: currentDate.addingTimeInterval(6200), attachment: .video(videoURL), text: ""),
        Message(date: currentDate.addingTimeInterval(6260), attachment: .video(videoURL), text: ""),
        Message(date: currentDate.addingTimeInterval(6320), attachment: .video(videoURL), text: ""),
        
        // Final text messages
        Message(date: currentDate.addingTimeInterval(11380), attachment: nil, text: "I will!"),
        Message(date: currentDate.addingTimeInterval(11440), attachment: nil, text: "Talk to you later."),
        Message(date: currentDate.addingTimeInterval(11500), attachment: nil, text: "Bye!"),
    ]
    return messages
}

/// This creates and runs a
///
/// Meet the Swift Algorithms and Collections packages
/// https://developer.apple.com/wwdc21/10256
func runMessagesExample() {
    let messages: [Message] = makeMessageContent()
    let transcript = messages
        .lazy
        .flatMap { $0.makeMessageParts() }
    
    // get the 6 most recent images
    let photos = transcript
        .compactMap { $0 as? PhotoItem }
        .suffix(6)
        .reversed()
        .toArray()
    print(photos)
    
    // interject a date item between items which have a space of over an hour
    transcript
            .chunked { $1.date.timeIntervalSince($0.date) < (60 * 60) }
            .joined { DateItem(date: $1.first!.date) }
            .forEach { print($0) }
        
}
