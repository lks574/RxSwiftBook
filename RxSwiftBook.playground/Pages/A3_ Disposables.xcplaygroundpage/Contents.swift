//: [Previous](@previous)

import RxSwift


/*
 error, Completed 된다면 Observable은 해제 된다.
 onDisposed는 종료 되었을떄 호출된다.
 
 Disposed는 Observable이 호출하지 않는다.
 onDisposed를 호출되는 이유는 클로저형태로 그시기에 해주는 것 뿐
 */
Observable.from([1, 2, 3])
    .subscribe(onNext: { elem in
        print("Next", elem)
    }, onError: { error in
        print("Error", error)
    }, onCompleted: {
        print("Completed")
    }, onDisposed: {
        print("onDisposed")
    })

// 단일 클로저로 사용하면 disposed가 호출되지 않는다.
Observable.from([1, 2, 3])
    .subscribe {
        print($0)
    }


// 공식문서에서 추천하는 방식
// ARC와 동일하게 해제 될때 같이 Dispose가 된다.
var disposeBag = DisposeBag()

Observable.from([1, 2, 3])
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

disposeBag = DisposeBag()   // 초기화 해주고 싶은 경우 사용


let subscription = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .subscribe(onNext: { elem in
        print("Next", elem)
    }, onError: { error in
        print("Error", error)
    }, onCompleted: {
        print("Completed")
    }, onDisposed: {
        print("onDisposed")
    })

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    subscription.dispose()
}

// 2까지 방출하고 해제된다. (completed도 호출 되지 않는다.)
// Dispose를 직접호출하는 것은 위험하다.
// 특정 시기에 해제하려면 take, until 같은 연산자를 사용하면 된다.


//: [Next](@next)
