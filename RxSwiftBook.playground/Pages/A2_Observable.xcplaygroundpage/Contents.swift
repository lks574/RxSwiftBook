//: [Previous](@previous)

/*
 
 Observable && Observer  (RxSwift의 핵심)
 
 Observable -  관찰자
 Observer   -   구독자
 
 Observable  -------Event-------> Observer
            <-----Subscribe-----
            
 
 이벤트 종류
 
 ---- 일어나지 않을수도 있고 여러번 일어날수도 있다.----
 - Next (Emission - 방출로 표현)
 
 ------- 가장 마지막에 전달 (Notification이라고 부름) ------
 - error
 - onComplete
 
 참고 사이트
 RxMable (https://rxmarbles.com/)
 RxJS로 표시 되어 있지만 같은 기능을 함. (앱 스토어에 올라와 있음)
 
 */


// Observable 구현
import UIKit
import RxSwift


// #1 create 연산자를 통해 (추후 정리할 예정)
Observable<Int>.create { (observer) -> Disposable in
    observer.on(.next(0))
    observer.onNext(1)
    observer.onCompleted()      // Observable이 종료되며 이후 이벤트 전달 할 수 없다.
    return Disposables.create()
}

// #2 이미 정해진 연산자를 이용 (위와 동일한 상태)
Observable.from([0,1])



// ----- !!위 상태만 되었다면 이벤트가 전달 되지 않는다. observer가 observable을 구독하는 시점 이벤트가 전달 된다. ----

// 하나의 클로저로 모든 이벤트를 처리할 때
let o1 = Observable.from([0,1])
o1.subscribe {
    print($0)
    
    if let elem = $0.element {
        print(elem)
    }
}

print("-----------------------")

o1.subscribe(onNext: { elem in
    print(elem)
})

// !!중요한 규칙
// 옵저버블은 여러 이벤트를 동시에 방출하지 않는다.

// Start가 두번 호출하는 경우는 없음. 한번 끝나고 다음것을 방출한다.
o1.subscribe {
    print("== Strat ==")
    print($0)
    
    if let elem = $0.element {
        print(elem)
    }
    print("== End ==")
}

//: [Next](@next)
