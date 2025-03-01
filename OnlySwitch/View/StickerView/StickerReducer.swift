//
//  StickerReducer.swift
//  OnlySwitch
//
//  Created by Jacklandrin on 2023/10/28.
//

import Foundation
import ComposableArchitecture

struct StickerReducer: Reducer {
    struct State: Equatable {
        var stickerContent = ""
        var isColorSelectorPresented = false
        var isHovering = false
        var stickerColor: StickerColor = .yellow
        var canTranslucent: Bool = false
    }

    enum Action: Equatable {
        case loadContent
        case editContent(String)
        case saveContent
        case showColorSelector
        case changeColor(StickerColor)
        case closeSticker
        case hover(Bool)
        case toggleTranslucent
    }

    @Dependency(\.stickerService) var stickerService

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .loadContent:
                    let sticker = stickerService.loadSticker()
                    state.stickerContent = sticker.content
                    state.stickerColor = sticker.color
                    state.canTranslucent = sticker.translucent
                    return .none
                    
                case .editContent(let content):
                    state.stickerContent = content
                    return .none
                    
                case .saveContent:
                    stickerService.saveSticker(state.stickerContent, state.stickerColor, state.canTranslucent)
                    return .none

                case .showColorSelector:
                    state.isColorSelectorPresented = true
                    return .none

                case .changeColor(let color):
                    state.stickerColor = color
                    state.isColorSelectorPresented = false
                    stickerService.saveSticker(state.stickerContent, state.stickerColor, state.canTranslucent)
                    return .none

                case .closeSticker:
                    return .run { @MainActor send in
                        try? await TopStickerSwitch.shared.operateSwitch(isOn: false)
                        NotificationCenter.default.post(name: .refreshSingleSwitchStatus, object: SwitchType.topSticker)
                    }

                case .hover(let isHovering):
                    state.isHovering = isHovering
                    return .none

                case .toggleTranslucent:
                    state.canTranslucent.toggle()
                    return .none
            }
        }
    }
}
