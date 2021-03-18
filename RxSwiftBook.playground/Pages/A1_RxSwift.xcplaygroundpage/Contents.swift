
/*
 명령형 코드와 RxSwift로 작성한 반응형 코드 비교
 
 복잡하지만 아래 있는 코드를 해석 할수 있기 위해 천천히 공부해 나갈 것.
 
 */
import UIKit
import RxSwift

// 명형형 코딩 (현재까지 사용하는 코딩 방식)
var a = 1
var b = 2

a + b
a = 12


// Reactive 반응형 코딩

let disposeBag = DisposeBag()

let r1 = BehaviorSubject(value: 1)
let r2 = BehaviorSubject(value: 2)

Observable.combineLatest(r1, r2) { $0 + $1 }
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)

r1.onNext(12)   // r1을 12로 바꾸자 값이 14로 변경됨
