//: [Previous](@previous)

//: # Subject
/*:
 ** Subject **
 
 Observable  ------->   Observer
 
 Observable은 다른 Observable을 구독할수 없고
 Observer는 다른 Observer를 이벤트 전달 할수 없다.
 
 Subject는 위 기능을 모두 가능하다. 즉 Observable이면서 Observer이다.
 
 - PublishSubject
 - BehaviorSubject
 - ReplaySubject
 - AsyncSubject
 
 
 ** Relays **
 
 subject를 래핑하고 있는 두가지 Relay를 제공한다.
 Next이벤트만을 제공하며
 주로 종료없이 계속 전달되는 이벤트 시퀀스에 사용한다.
 
 - PublishRelay
 - BehaviorRelay
 */


//: ## PublishSubject - 구독하기 이전에 들어온 이벤트는 반영되지 않음.
/*:
 초기값이 없어 생성되면 이벤트가 비워있다.
 
 초기에 구독하면 아무것도 이벤트가 전달되지 않는다.
 */

import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

enum MyError: Error {
    case error
}

// PublishSubject - 구독하기 이전에 들어온 Next는 반영되지 않음.
let ps = PublishSubject<String>()
ps.onNext("Hello")

let o1 = ps.subscribe { print(">> 1", $0) }
o1.disposed(by: disposeBag)

ps.onNext("RxSwift")


let o2 = ps.subscribe { print(">> 2", $0) }
o2.disposed(by: disposeBag)

ps.onNext("Subject")
ps.onError(MyError.error)

ps.onCompleted()

// Completed, Error 이후에 구독하면 Next는 전달되지 않으며, 바로 종료 된다.
let o3 = ps.subscribe { print(">> 3", $0) }
o2.disposed(by: disposeBag)


//: ## BehaviorSubject - 생성시 초기화하며, 제일 최신의 이벤트를 가지고 있는다.
/*:
 초기값을 넣어  생성하며  이벤트가 들어있다.
 
 초기에 구독하면 초기값을 이벤트를 방출한다.
 */

let ps2 = PublishSubject<Int>()
ps2.subscribe { print("PublishSubject >>", $0) }
    .disposed(by: disposeBag)

let bs = BehaviorSubject<Int>(value: 0)
bs.subscribe { print("BehaviorSubject >>", $0) }
    .disposed(by: disposeBag)
bs.onNext(1)

bs.subscribe { print("BehaviorSubject2 >>", $0) }
    .disposed(by: disposeBag)

bs.onCompleted()

bs.subscribe { print("BehaviorSubject3 >>", $0) }
    .disposed(by: disposeBag)


//: ### ReplaySubject - 두개 이상을 저장했다가 전달하고 싶은 경우 (지정된 수만큼 이벤트를 저장할 수 있다)
/*:
 버퍼만큼 저장할 수 있으며, 구독시 차례대로 전달한다.
 */

let rs = ReplaySubject<Int>.create(bufferSize: 3)

(1...10).forEach { rs.onNext($0) }

rs.subscribe { print("ReplaySubject1 >>", $0) }
    .disposed(by: disposeBag)

// 다른 서비스와 동일하게 기존 구독자한테 바로 전달
// 기존의 버퍼의 마지막 (8)을 제외하고 11을 저장한다.
rs.onNext(11)

rs.subscribe { print("ReplaySubject2 >>", $0) }
    .disposed(by: disposeBag)

rs.onCompleted()

// 버퍼의 이벤트가 전부 전달된 후에 Completed가 된다.
rs.subscribe { print("ReplaySubject3 >>", $0) }
    .disposed(by: disposeBag)


//: ## AsyncSubject - completed 이벤트가 전달되는 시점에 가장 최근 Next 이벤트를 구독자로 전달
/*:
 이벤트를 전달하는 시점이 기존 subject와 다르다.
 
 이벤트가 전달되는 즉시 구독자에서 전달하는 것이 아닌 Completed가 될 때 최근 이벤트를 전달함
 */

let subject = AsyncSubject<Int>()

subject.subscribe { print("AsyncSubject >>", $0) }
    .disposed(by: disposeBag)

subject.onNext(1)
subject.onNext(2)
subject.onNext(3)
subject.onNext(4)

// Completed시점에 하나만 전달함.
//subject.onCompleted()

// 에러라면 아무 이벤트를 전달하지 않고 error만 전달
subject.onError(MyError.error)


//: # Relay
/*:
 - PublishRelay     -----   PublishSubject
 - BehaviorRelay   ----    BehaviorSubject
 
 ### Next만이 전달되며, 종료되지 않는다. (구독자가 disposed가 되지 않는다면)
 
 주로 UI관련 로직에 많이 사용한다.
 
 RxCocoa에 있음
 */

let pr = PublishRelay<Int>()

pr.subscribe { print("PublishRelay >>", $0) }
    .disposed(by: disposeBag)

pr.accept(1)


let br = BehaviorRelay<Int>(value: 0)
br.accept(2)

br.subscribe { print("BehaviorRelay >>", $0) }
    .disposed(by: disposeBag)

// BehaviorRelay는 value를 지원하며, 읽기 전용이며 바꾸려면 accept로 넘겨줘야한다.
print(br.value)
//: [Next](@next)
