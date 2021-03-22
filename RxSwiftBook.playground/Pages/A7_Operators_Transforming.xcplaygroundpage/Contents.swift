//: [Previous](@previous)

import RxSwift

let disposeBag = DisposeBag()
enum MyError: Error {
    case error
}

/*: ## toArray
옵저버블이 방출하는 모드 요소를 배열로 방출하는 연산자
 */

let subject = PublishSubject<Int>()

subject
    .toArray()
    .subscribe { print("\($0)") }
    .disposed(by: disposeBag)

subject.onNext(1)
subject.onNext(2)

// 완료 / 에러 되기 전까지 방출하지 않는다.
subject.onCompleted()

/*: ## map
 원본 옵저버블이 방출하는 요소로 함수를 실행하여 새로운 옵저버블을 방출 (원하는 타입으로 변경 가능)
 */
print("-----map-----")
let skills = ["Swift", "SwiftUI", "RxSwift"]

Observable.from(skills)
    .map { "Hello, \($0)" }
    .map { $0.count }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*: ## flatMap
 원본 옵저버블을 새로운 옵저버블을  생성하여,  하나의 옵저버블로 합침 (네트워크 구현시 많이 사용)
 */
print("-----flatMap-----")
let bs1 = BehaviorSubject(value: 1)
let bs2 = BehaviorSubject(value: 2)

let ps = PublishSubject<BehaviorSubject<Int>>()

ps.flatMap { $0 }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

ps.onNext(bs1)
ps.onNext(bs2)

bs1.onNext(11)
bs2.onNext(22)


/*: ## flatMapFirst, flatMapLatest
 flatMap 파생된 연산자 , flatMapFirst-처음 방출된 값만  / flatMapLatest-최근 옵저버블의 방출 값만 방출
 */
print("-----flatMapFirst-----")
let ps1 = PublishSubject<BehaviorSubject<Int>>()
ps1.flatMapFirst { $0 }
    .subscribe { print("flatMapFirst >> \($0)") }
    .disposed(by: disposeBag)

ps1.onNext(bs1)
ps1.onNext(bs2)

bs2.onNext(3333)
bs2.onNext(4444)
bs2.onNext(5555)
bs1.onNext(123123123)


/*: ## scan
 accumulator function을 활용하는 scan 연산자, 마지막 값만 필요하다면 reduce를 사용
 */

print("-----scan-----")
Observable.range(start: 1, count: 10)
    .scan(0, accumulator: +)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*: ## buffer
 특정 주기동안 옵저버블이 방출하는 값을 수집하여 하나으 옵저버블로 방출
 */

//print("-----buffer-----")
//Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//    .buffer(timeSpan: .seconds(5), count: 3, scheduler: MainScheduler.instance)
//    .take(5)
//    .subscribe { print($0) }
//    .disposed(by: disposeBag)


/*: ## window
 버퍼와 기능은 비슷 옵저벌을 방출하는 옵저버블을 방출한다. (innser Obaservabeele)
 */
//print("-----window-----")
//Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//    .window(timeSpan: .seconds(5), count: 3, scheduler: MainScheduler.instance)
//    .take(5)
//    .subscribe {
//        print($0)
//
//        if let observable = $0.element  {
//            observable.subscribe { print(" inner: ", $0)}
//        }
//    }
//    .disposed(by: disposeBag)

/*: ## groupBy
 옵저버블을 원하는데로 그룹핑하는 연산자
 */
print("-----groupBy-----")

let words = ["Apple", "Banana", "Orange", "Book", "City", "Axe"]

Observable.from(words)
//    .groupBy { $0.count }
//    .subscribe(onNext: { groupOb in
//        print("== \(groupOb.key)")
//        groupOb.subscribe { print($0) }
//    })
    
//    .groupBy { $0.count }
//    .flatMap { $0.toArray() }
//    .subscribe { print($0) }
//    .disposed(by: disposeBag)

    .groupBy { $0.first ?? Character(" ") }
    .flatMap { $0.toArray() }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

//: [Next](@next)
