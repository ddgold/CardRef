import Foundation
import SwiftUI

struct CardImage: View {
    var card: Card
    
    @State private var image: CGImage = Datatank.image("cardBack")
    
    var body: some View {
        Image(image, scale: 2, label: Text(card.name))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 336, height: 468, alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .onAppear{ self.loadCardImage() }
    }
    
    private func loadCardImage() {
        Datatank.image(self.card, type: .large, resultHandler: { (downloadImage) in
            self.image = downloadImage
        }, errorHandler:  { (resultError) in
            fatalError(resultError.details)
        })
    }
}
