//: [Previous](@previous)

//: # Operator (연산자)

import RxSwift

let disposeBag = DisposeBag()
enum MyError: Error {
    case error
}

/*: 
 ## just, of, from
 */

Observable.just([1, 2, 3])
    .subscribe { print($0) }
    .disposed(by: disposeBag)   // next([1, 2, 3])

Observable.of([1, 2, 3])
    .subscribe { print($0) }
    .disposed(by: disposeBag)   // next([1, 2, 3])

Observable.of(1, 2, 3)
    .subscribe { print($0) }
    .disposed(by: disposeBag)   // next(1) / next(2) / next(3)

Observable.from([1, 2, 3])
    .subscribe { print($0) }
    .disposed(by: disposeBag)   // next(1) / next(2) / next(3)

/*:
 ## range, generate
 */


// 1부터 1씩 증가하는 이벤트를 10개 생성 (무조건 1씩 증가)
Observable.range(start: 1, count: 10)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// 조건을 만들어서 구성 가능 (정수가 아니여도 상관없다.)
Observable.generate(initialState: 0, condition: { $0 <= 10 }, iterate: { $0 + 2 })
    .subscribe { print($0) }
    .disposed(by: disposeBag)


/*:
 ## repeatElement
    
 동일한 요소를 반복적으로 방출하는  옵저버블을 생성
 */

// take가 없다면 계속 방출한다.
Observable.repeatElement("1")
    .take(7)
    .subscribe { print($0) }
    .disposed(by: disposeBag)


/*:
 ## deferred
    
 특정 조건에 따라 옵저버블을 생성
 */

let numberArr = [10,11,12,13,14,15]
let strArr = ["a", "b", "c", "d", "e"]

var flag = true

let factory: Observable<String> = Observable.deferred {
    flag.toggle()
    
    if flag {
        return Observable.from(numberArr)
            .map { "\($0)" }
    } else {
        return Observable.from(strArr)
    }
}

factory
    .subscribe { print($0) }
    .disposed(by: disposeBag)

factory
    .subscribe { print($0) }
    .disposed(by: disposeBag)


/*:
 ## create
    
 Observable의 동작을 기본 사이클이 아닌 직접 구현하고 싶을 때 사용
 */

Observable<String>.create { (observer) -> Disposable in
    guard let url = URL(string: "https://www.apple.com") else {
        observer.onError(MyError.error)
        return Disposables.create()
    }
    
    guard let html = try? String(contentsOf: url, encoding: .utf8) else {
        observer.onError(MyError.error)
        return Disposables.create()
    }
    
    observer.onNext(html)
    observer.onCompleted()
    
    return Disposables.create()
}
.subscribe { print($0) }
.disposed(by: disposeBag)


/*:
 ## empty, error
    
 Next를 방출하지 않는다.
 */

Observable<Void>.empty()
    .subscribe { print($0) }
    .disposed(by: disposeBag)       // 옵저버블이 아무 구현없이 종료 되고 싶을 때 사용


Observable<Void>.error(MyError.error)
    .subscribe { print($0) }
    .disposed(by: disposeBag)       // 어떤 상황이든 에러를 주고 싶을 때

//: [Next](@next)
