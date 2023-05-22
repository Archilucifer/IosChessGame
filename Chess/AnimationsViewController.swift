//
//  AnimationsViewController.swift
//  Chess iOS
//
//  Created by Алина Дзюба on 22.05.2023.
//

import UIKit
import RiveRuntime

class AnimationViewController: UIViewController {
    var viewModel = RiveViewModel(
          fileName: "skills",
          stateMachineName: "Designer's Test"
      )
      
      override public func loadView() {
          super.loadView()
          
          guard let stateMachineView = view as? StateMachineView else {
              fatalError("Could not find StateMachineView")
          }
          
          viewModel.setView(stateMachineView.riveView)
      }
}
