import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

/**
    O startWith operator mas epitrepei na prothesoume ena element
    stin proti thesi enos observable sequence
    
    e.g:
    an  exw ena sequence 2,3,4 kai kanw statsWith ena
    tha exw 1,2,3,4
 */
func startsWithOperator() {
    let numbers = Observable.of(2,3,4)
    numbers.startWith(1)
        .subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
}


/**
    Kanei to klasiko concat to opoio vazei ta stixeia tou defterou sequence meta apo tou protou
    kai ta epeisrefei se ena koino sequence
 
     An left  timeline =  1 -------------- 2 ----3
     kai right timeline = ------4---5------6-----
 
    To apotelesma tou concat(left,right) tha einai  1,2,3,4,5,6
 
 */
func concatOperator() {
    let left = Observable.of(1,2,3)
    let right = Observable.of(4,5,6)
    
    // isodinama
    // let source = Observable.concat([left, right])
    let source = Observable.of(left,right)
    source.concat()
        .subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)

}


/**
    O Merge operator mas parexei tin dinatotita na kanoume subscribe se 2 subjects tautoxrona
    kai na dexomaste events me tin sira pou ginonte apply se kathe subject
 
    *diladi*
     An left  timeline =  1 -------------- 2 ----3
     kai right timeline = ------4---5------6-----
 
     To apotelesma tou merge(left,right) tha einai 1,4,5,2,6,3
 */
func mergeOperator() {
    let left = PublishSubject<Int>()
    let right = PublishSubject<Int>()
    
    let source = Observable.of(left.asObservable(), right.asObservable())

    let mergeObservable = source.merge()
    mergeObservable.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    left.onNext(1)
    right.onNext(4)
    right.onNext(5)
    left.onNext(2)
    right.onNext(6)
    left.onNext(3)
}

/**
    O combine lates operator enonei tis latest values kai apo ta 2 sequences
 
    e.g:
    An left  timeline =  1 -------------- 2 ----3
    kai right timeline = ------4---5------6-----

    To apotelesma tou merge(left,right) tha einai (1,4),(1,5),(2,5),(2,6),(3,6)
 */
func combineLatestOperator() {
    let left = PublishSubject<Int>()
    let right = PublishSubject<Int>()
    
    let source = Observable.combineLatest(left, right) { lastLeft, lastRight in
        "(\(lastLeft), \(lastRight))"
    }
    
    source.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    left.onNext(1)
    right.onNext(4)
    right.onNext(5)
    left.onNext(2)
    right.onNext(6)
    left.onNext(3)
}

/**
    se kathe event tou 1ou subject kanei obsearve to latest value pou eixe to deutero subject
 */
func withinLatestOperator() {
    let button = PublishSubject<Void>()
    let textField = PublishSubject<String>()
    
    let observable = button.withLatestFrom(textField)
    observable.subscribe(onNext: {
        print($0)
    })
    
    textField.onNext("Sw")
    textField.onNext("Swi")
    textField.onNext("Swift")
    button.onNext(())

    textField.onNext("Swift Rocks!")
    button.onNext(())
}

/**
    Kanei reduce ola ta element tou sequence se 1
 
    e.g
    estw oti exw to sequence: 1,2,3
    tote to reduce einai 6 (1+2+3)
 */
func reduceOperator(){
    let source = Observable.of(1,2,3)
    // sets the initial value and the function that reduces the result
    // the function is called accumulator
    source.reduce(0) { summary, newVal in
        return summary + newVal
    }.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
}

/**
    Litourgei paromia me to reduce mono pou epistrefei to apotelesma pou proekipse apo ton accumulator
 */
func scanOperator() {
    let source = Observable.of(1,2,3)
    source.scan(0) { summary, newVal in
        return summary + newVal
    }.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
}

scanOperator()

