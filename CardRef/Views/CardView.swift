//
//  CardView.swift
//  CardRef
//
//  Created by Doug Goldstein on 3/26/20.
//  Copyright © 2020 Doug Goldstein. All rights reserved.
//

import SwiftUI

struct CardView: View {
    let card: Card
    
    var body: some View {
        VStack {
            Text(card.name)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static let cards = Datatank.cards("DebugCards")
    
    static var previews: some View {
        CardView(card: cards[0])
    }
}
