//
//  ContentView.swift
//  State Management
//
//  Created by 김수빈 on 2019/10/09.
//  Copyright © 2019 김수빈. All rights reserved.
//

import SwiftUI
import Combine

/*
 SwiftUI State Management
 1. @State
 2. @ObservedObject
 3. @EnvironmentObject : 딕셔너리..!(백그라운드에서 동작하는 key-value 저장소라고 생각하면 좋다!)
    - User를 Environment에 만들어주고 어떤 곳에서든 environment Object로 선언된 User 타입 변수를 호출할 때 자동으로 값을 동기화해준다
 // 4. @Published
 
 swift의 string, int, tuple 등 모두 struct. 원할 때 변경 불가
 Swift UI에서 뷰들은 모두 struct -> 아무때나 변경이 불가능!, 여러가지 프로퍼티 래퍼를 통해 struct안에서 변경이 가능하도록 해줌...!
 */

class User : ObservableObject, Identifiable {
    
    // 어떤 프로퍼티 하나라도 변경이 되면 변경되었음을 class에 알림
    // 업데이트를 할 때 어떠한 에러도 띄우지 않을 것이므로 <Void, Never> 형으로 선언한다고 함.(?)
    // didChagne -> willChange -> objectWillChange
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    var userName = "ksb" { willSet { objectWillChange.send() } }
    var password = "1234"{ willSet { objectWillChange.send() } }
    var emailAddress = "ksoobean@naver.com" { willSet { objectWillChange.send() } }
    
}

struct ContentView: View {
    // @State는 변수의 값이 변경될 것임을 알려줌.
    // struct 외부 SwiftUI 메모리에 의해 관리됨
    // + 값이 변경되면 자동으로 같은 변수를 사용하는 뷰를 동기화(반영)
    
//    @State private var userName = "ksb"
//    var body: some View {
//        VStack {
//
//                    Text("User : \(userName)")
//
//                    TextField("Name :", text: $userName).foregroundColor(Color.green).multilineTextAlignment(.center)
//                    // two-way binding!
//                }
//    }
    
    //@State var user = User()
    
    // ObservedObject로 선언해서 ObservableObject 프로토콜을 따르는 class의 프로퍼티에 변경한 값을 알림
    // -> class 인스턴스에 모두 동기화!
    @ObservedObject var user = User()
    @EnvironmentObject var environmentUser : User
    
    
    var body: some View {
        
        NavigationView {
            
            VStack {

                Text("User : \(user.userName)")

                TextField("Name :", text: $user.userName).foregroundColor(Color.green).multilineTextAlignment(.center)
                // two-way binding!

                Text("Password : \(user.password)")

                TextField("Password :", text: $user.password).foregroundColor(Color.green).multilineTextAlignment(.center)
                // two-way binding!

                Text("EmailAddress : \(user.emailAddress)")

                TextField("EmailAddress :", text: $user.emailAddress).foregroundColor(Color.green).multilineTextAlignment(.center)
                // two-way binding!
                
                
                Text("Environment User : \(environmentUser.userName)")

                TextField("Name :", text: $environmentUser.userName).foregroundColor(Color.green).multilineTextAlignment(.center)
                
                
                NavigationLink(destination: SecondView()) {
                    Text("Move SecondView")
                        .foregroundColor(Color.blue)
                        .padding(12)
                }.background(Color.yellow)
                    .navigationBarTitle("First View")
            }
            
        }

    }
}

struct SecondView : View{
    
    @ObservedObject var observedUser = User()
    
    // 뷰 안에서 custom initializer 사용하지 않고 정의만 해줌
    // 이 상태에서는 빌드는 되지만 에러 발생! -> 초기화된 변수가 아니기 때문
    // -> Scene delegate에서 변수 정의해주고 SwiftUI에서 항상 확인할 수 있도록 해주어야 함!
    @EnvironmentObject var environmentUser : User
    
    var body : some View {
        NavigationView {
            VStack {

                Text("ObservedUser : \(observedUser.userName)")
                
                TextField("Change name to :", text: $observedUser.userName).multilineTextAlignment(.center)
                
                Text("EnvironmentUser : \(environmentUser.userName)")
                
                TextField("Change name to :", text: $environmentUser.userName).multilineTextAlignment(.center)
            }

        }
        .navigationBarTitle("Second View")
    }
}

#if DEBUG

/*
 EnvironmnetObject로 선언한 변수의 변화를
 preview에서 확인하기 위해서 아래와 같이 변경이 필요함
 #if DEBUG, #endif : 디버깅할 때만 프리뷰를 사용해 테스트한다는 의미이므로 추가를 해주는 것이 좋고, 이 안에서 선언하고 확인하는 프리뷰 변수들도 디버깅할 때만 쓰임 -> 테스트할 때 유용하게 쓰일 수 있다!
 */
let userData = User()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(userData)
    }
}
#endif
