//: [Previous](@previous)

import RxSwift

let disposeBag = DisposeBag()
enum MyError: Error {
    case error
}

/*: ##  ignoreElements
 
 next이벤트를 필터링 하는  연산자
 
 주로 작업의 성공, 실패를 체크하고 싶은 경우
 */

let strArr = ["a", "b", "c", "d"]
Observable.from(strArr)
    .ignoreElements()
    .subscribe { print($0) }
    .disposed(by: disposeBag)


/*: ## elementAt
 
 특정 인덱스에 위치한 요소를 제한적으로 방출
 */

Observable.from(strArr)
    .element(at: 2)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*: ## filter
 
특정 조건에 맞는 항목만 필터링
 */

let numArr = [1,2,3,4,5,6,7,8,9,10]
Observable.from(numArr)
    .filter { $0.isMultiple(of: 2) }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*: ## skip
 
특정 요소를 무시
 */

// skip (count만큼 제외한다. 처음 3개)
Observable.from(numArr)
    .skip(3)
    .subscribe { print($0) }
    .disposed(by: disposeBag)


// skip(while 클로저 안에 false이 들어오면 그뒤로는 계속 전달
Observable.from(numArr)
    .skip(while: { !$0.isMultiple(of: 2) })
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// skip(until - observable을 받아서 그 함수가 들어올때까지 기다렸다 호출됨. 트리거 이전꺼는 버려짐

let ps = PublishSubject<Int>()
let trigger = PublishSubject<Int>()

ps.skip(until: trigger)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

ps.onNext(1)
trigger.onNext(0)
ps.onNext(2)


/*: ## take
 
요소의 방출조건을 다양하게 만든다.
 */
print("-----take-----")
// take - 전달하는 갯수 (처음 5개만 호출되고 나머지는 버려진다.)
Observable.from(numArr)
    .take(5)
    .subscribe { print($0) }
    .disposed(by: disposeBag)


// takewhile - false이라면 더이상 방출하지 않는다.
Observable.from(numArr)
    .take(while: { !$0.isMultiple(of: 2) })
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// take(until - trigger 가 방출하기 전까지 계속 호출
ps.take(until: trigger)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// takeLast - 버퍼에 저장되며 completed가 호출되면 같이 전달한다.
let ps2 = PublishSubject<Int>()
ps2.takeLast(2)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

numArr.forEach { ps2.onNext($0) }
ps2.onNext(11)
ps2.onCompleted()


/*: ## Single
 
하나의 요소가 방출되는 것을 보장, 2개 이상이면 에러
 */

print("-----Single-----")
Observable.just(1)
    .single()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

Observable.from(numArr)
    .single()
    .subscribe { print($0) }
    .disposed(by: disposeBag)   // 하나 호출하고 에러

Observable.from(numArr)
    .single { $0 == 3 }
    .subscribe { print($0) }
    .disposed(by: disposeBag)


/*: ## distinctUntilChanged
 
동일한 요소가 연속적으로 방출하는 것을 막아준다.
 */
print("-----distinctUntilChanged-----")
let numArr2 = [1,1,2,3,4,5,5,5,6,2]
Observable.from(numArr2)
    .distinctUntilChanged()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*: ## debounce, throttle
 
짧은 시간 반복적으로 전달되는 이벤트를 효율적으로 처리
 */

print("-----debounce, throttle-----")

let buttonTap = Observable<String>.create { observer in
    DispatchQueue.global().async {
        for i in 1...10 {
            observer.onNext("Tap \(i)")
            Thread.sleep(forTimeInterval: 0.3)
        }
        
        Thread.sleep(forTimeInterval: 1)
        
        for i in 11...20 {
            observer.onNext("Tap \(i)")
            Thread.sleep(forTimeInterval: 0.5)
        }
        
        observer.onCompleted()
    }
    return Disposables.create()
}

// debounce - 이벤트가 들어오면 타이머를 돌리며, 그 안에 이벤트가 들어오면 타이머를 초기화 한다. 타이머 안에 이벤트가 들어오지 않는다면 마지막 값을 방출한다.
// ex) 검색창에 연달아 쓰는 텍스트를 받아올때 지정된 시간만큼 기다렸다가 네트워크 통신
buttonTap
    .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// throttle - 타이머 이후 들어오는 이벤트를 전달된다.
// 버튼 클릭, 현재 위치
buttonTap
    .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: disposeBag)


//: [Next](@next)
