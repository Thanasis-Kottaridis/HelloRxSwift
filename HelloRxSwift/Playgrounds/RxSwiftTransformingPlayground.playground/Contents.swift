import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

func toArrayOperator() {
    Observable.of(1,2,3,4,5)
        .toArray()
        .subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
}

func toArrayOperator2() {
    
    Observable<Int>.create({ observer in
        observer.onNext(1)
        observer.onNext(1)
        observer.onNext(1)
        observer.onCompleted()
        return Disposables.create()
    })
        .toArray()
        .subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
}

func mapOperator() {
    Observable.of(1,2,3,4,5)
        .map { return $0 * 2}
        .subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
}


struct Student {
    var score: BehaviorRelay<Int>
}

func flatMapOperator() {
    let john = Student(score: BehaviorRelay(value: 75))
    let mary = Student(score: BehaviorRelay(value: 95))
    
    let student = PublishSubject<Student>()
    
    student.asObservable()
        .flatMap({ student in
            student.score.asObservable()
        })
        .subscribe (onNext: {print($0)})
        .disposed(by: disposeBag)
    
    student.onNext(john)
    john.score.accept(100)
    student.onNext(mary)
    mary.score.accept(45)
    john.score.accept(62)
}

func flatMapLatestOperator() {
    let john = Student(score: BehaviorRelay(value: 75))
    let mary = Student(score: BehaviorRelay(value: 95))
    
    let student = PublishSubject<Student>()
    
    student.asObservable()
        .flatMapLatest({ student in
            student.score.asObservable()
        })
        .subscribe (onNext: {print($0)})
        .disposed(by: disposeBag)
    
    student.onNext(john)
    john.score.accept(100)
    student.onNext(mary)
    mary.score.accept(45)
    mary.score.accept(45)
    mary.score.accept(45)
    mary.score.accept(45)
    john.score.accept(62) // den to kanei obsearve gt exoume kanei flatMap to latest kai latest subscriber was mary
}

func flatMapLatestOperatorWithScan() {
    let john = Student(score: BehaviorRelay(value: 75))
    let mary = Student(score: BehaviorRelay(value: 95))
    
    let student = PublishSubject<Student>()
    
    student.asObservable()
        .flatMapLatest({ student in
            student.score.asObservable()
        })
        .distinctUntilChanged()
        .subscribe (onNext: {print($0)})
        .disposed(by: disposeBag)
    
    student.onNext(john)
    john.score.accept(100)
    student.onNext(mary)
    mary.score.accept(45)
    mary.score.accept(45)
    mary.score.accept(45)
    mary.score.accept(45)
    mary.score.accept(55)
    john.score.accept(62) // den to kanei obsearve gt exoume kanei flatMap to latest kai latest subscriber was mary
}

flatMapLatestOperatorWithScan()
