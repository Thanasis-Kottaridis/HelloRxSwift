import UIKit
import RxSwift
import RxCocoa
import PlaygroundSupport

func IgnoreOperator() {
    let strikes = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    strikes.ignoreElements()
        .subscribe { _ in
            print("Subscribe Called")
        }.disposed(by: disposeBag)
    
    
    strikes.onNext("A")
    strikes.onNext("B")
    strikes.onNext("C")

    strikes.onCompleted() // mono to on complete event ginete fire apo apo ton subscriber
}

func elementAtOperator() {
    let strikes = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    strikes.element(at: 2).subscribe { element in
        print("Subscribe Called")
    }.disposed(by: disposeBag)
    
    
    strikes.onNext("A")
    strikes.onNext("B") // mexri edo to suvscriber den kaleite kan
    strikes.onNext("C") // mono auto to element tha ginei observed
}

func filterOperator() {
    let disposeBag = DisposeBag()

    Observable.of(1,2,3,4,5,6,7,8,9)
        .filter{$0 % 2 == 0} // krata mono ta ziga noumera
        .subscribe { element in
            print(element)
        }.disposed(by: disposeBag)
}

/**
    O skip operator tou leme posa elements tou sequence theloume na parakampsei
    kai meta parakolouthei ola ta ipolipa elements tou sequence
 */
func skipOperator() {
    let disposeBag = DisposeBag()

    Observable.of(1,2,3,4,5,6,7,8,9)
        .skip(3) // kane skip ta 3 prwra elements
        .subscribe { element in
            print(element)
        }.disposed(by: disposeBag)
}

/**
    O SkipWhile operator kanei skip ola ta stixeia mexri na ikanopoieithei i sinthiki gia proti fora
    kai apo ekei kai meta emfanizei ola ta ipolipa stixeia tou sequence
 */
func skipWhileOperator() {
    let disposeBag = DisposeBag()
    
    Observable.of(1,2,3,4,5,6,7,8,9)
        .skip { element in
            return element != 7
        }.subscribe { element in
            print(element)
        }.disposed(by: disposeBag)
}


/**
    O SkipUntil Operator prospernaei ola ta onNextEvents sto main subject
    mexri na dextei kapoio onNext event sto trigger subject:
 */
func skipUntilOperator() {
    let disposeBag = DisposeBag()
    
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<String>()
    
    subject.skip(until: trigger)
        .subscribe { element in
            print(element)
        }.disposed(by: disposeBag)
    
    subject.onNext("A")
    subject.onNext("B")
    subject.onNext("C") // ola auta ta agnoei
    
    // mexri pou ginete triggered
    trigger.onNext("Triggered")
    // kai apo edw kai meta arxizei na ta katagrafei
    subject.onNext("D")
}

func takeOperator() {
    let disposeBag = DisposeBag()

    Observable.of(1,2,3,4,5,6,7,8,9)
        .take(4)
        .subscribe { element in
            print(element)
        }.disposed(by: disposeBag)
}

/**
    - Pernei ola ta stixia mexri to element na ikanopoiithei i sinthiki
    - ta upolipa ta agnoei
    - einai to antitheto tou SkipWhile
 */
func takeWhileOperator() {
    let disposeBag = DisposeBag()

    Observable.of(2,4,6,7,8,10)
        .take(while: { element in
            return element != 7
        }).subscribe { element in
            print(element)
        }.disposed(by: disposeBag)
}

/**
    O take Until operator kanei to antitheto tou skip until operator
    - kanei observe ta onNext events mexri na ginei trigger to triggerSubject.
 */
func takeUntilOperator() {
    let disposeBag = DisposeBag()
    
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<String>()
    
    subject.take(until: trigger)
        .subscribe { element in
            print(element)
        }.disposed(by: disposeBag)
    
    subject.onNext("A")
    subject.onNext("B")
    subject.onNext("C") // ola auta ta agnoei
    
    // mexri pou ginete triggered
    trigger.onNext("Triggered")
    // kai apo edw kai meta arxizei na ta katagrafei
    subject.onNext("D")
}

takeUntilOperator()
