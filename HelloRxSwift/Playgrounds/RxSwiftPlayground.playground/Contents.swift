import UIKit
import RxSwift
import RxCocoa
import RxRelay

func firstExamples() {
    
    // ftiaxnei ena observable me ena element (int 1)
    let observable = Observable.just(1)

    // auto to observable douleuei me auta ta 3 values Observable<Int>
    /// DILADI SIMENEI OTI AUTO TO OBSERVABLE THA PERIEXEI ENA APO AUTA TA ITEMS
    let observable2 = Observable.of(1,2,3)

    // auto to obseravable douleuei me to array apo in pou tous exoume perasei  Observable<[Int]>
    /// DILADI SIMENEI OTI AUTO TO OBSERVABLE THA PERIEXEI OLOKLIRO TO ARRAY
    let observable3 = Observable.of([1,2,3])

    // to from einai diaforetiko apo to of pernei ena array apo values kai to observable xrisimopoieite se kathe element autou tou arrey Observable<Int>
    // DILADI SIMENEI OTI AUTO TO OBSERVABLE THA PERIEXEI ITEMS APO AUTO TO ARRAY
    let observable4 = Observable.from([1,2,3,4,5])

    /**
     Kanoume subscribe sto obsearvable4
     Auto to observable tha parei oles tis times apo ta elements tou array [1,2,3,4,5]
     to print event emfanizei to eksis:
         next(1)
         next(2)
         next(3)
         next(4)
         next(5)
         completed
     
     auto simenei oti:
     - erxete to event next kai mas dixnei to next element stin lista
     - otan teliosoun ta elements ginete fire to complete event
     */
    observable4.subscribe { event in
        print(event)
    }


    // Dokimazoume na paroume to value tou element gia kathe event
    observable4.subscribe { event in
        if let element = event.element {
            print(element)
        }
    }
    
    observable3.subscribe { event in
        if let element = event.element {
            print(element)
        }
    }
    
    let subscription4 = observable4.subscribe(onNext: { element in
        print(element)
    })
    
    // Desposing a subscription
    // to kanoume dispose xirokinita
    subscription4.dispose()
}

func secondExample() {
    // create a DesposeBag an object responsible for disposing subscribers
    let disposeBag = DisposeBag()
    
    // create an observable sequence
    Observable.of("A","B","C")
        .subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
}

func createObservable() {
    Observable<String>.create { observer in
        observer.onNext("A")
        observer.onCompleted()
        observer.onNext("?")
        return Disposables.create()
    }.subscribe { next in
        print(next)
    } onError: { error in
        print(error)
    } onCompleted: {
        print("Completed")
    } onDisposed: {
        print("dispose")
    }

}

/**
    ## PublishSubject
 
    - Den xriazonte inital values.
    - Otan kaneis subscribe den perneis oute to trexon oute ta proigoumena values pou eixe to subject
 */
func createPublishSubject() {
    let disposeBag = DisposeBag()
    
    let subject = PublishSubject<String>()

    subject.onNext("Issue 1") /// den ginete observe gt den exoume kanei akoma subscribe
    
    subject.subscribe { event in
        print(event)
    }
    
    subject.onNext("Issue 2") /// ginete observe
    subject.onNext("Issue 3") /// ginete observe

    /// an kanw dispose to subject pavei na  uparxei ara den ginonte subscribes meta
//        subject.dispose()
    
    /// an kalesw to onComplete to subject agnoei ola ta epomena events
    subject.onCompleted()
    
    subject.onNext("Issue 4")
    
    subject.dispose()
}

/**
    ## BehaviourSubject
 
    - Xriazonte inital values.
    - Giati Otan kaneis subscribe perneis to trexon value pou eixe to subject
 */
func createBehaviourSubject() {
    let disposeBag = DisposeBag()
    
    let subject = BehaviorSubject<String>(value: "Initial Value")
    
    subject.onNext("Last Value")
    
    subject.subscribe { event in
        print(event)
    }
    
    subject.onNext("Issue 1")
    
    subject.dispose()

}

/**
    ## ReplaySubject
 
    - Den Xriazonte inital values.
    - Xriazete ena buffer size pou tou leei posa events values tha kratisei prin ginei to subscribe
    - molis ginei to subscribe. O subscriber lavanei ta events pou iparxoun ston buffer
 */
func createReplaySubject() {
    let disposeBag = DisposeBag()

    let subject = ReplaySubject<String>.create(bufferSize: 2)
    
    subject.onNext("Issue 1")
    subject.onNext("Issue 2")
    subject.onNext("Issue 3")

    subject.subscribe { event in
        print(event)
    }
    
    
    subject.onNext("Issue 4")
    subject.onNext("Issue 5")
    subject.onNext("Issue 6")

    print("Subscription 2")
    subject.subscribe { event in
        print("sub 2 \(event)")
    }
    
    subject.onNext("Issue 7")
    subject.onNext("Issue 8")

    subject.dispose()

    subject.onNext("Issue 9")
}


/**
    ## Create BehaviorRelay
 
    - Auto to subject type einai i kenouria morfi tou Variable subject type
    - Ta variables itan Wrappers twn BehaviourSubjects kai kanan store to value tou se ena state
    - Ara afou kanoun store BehaviourSubjects eprepe na kanoume set me initial values
 
    - Gia na kanoume subscribe ena variable eprepe na to kanoume .asObservable kai na kaname use to subscribe funbction
    - Epita kathe fora pou alazoume to value to variable o subscriber ginete fire.
 
    ### SOS
    To behaviourRelay einai meros to RxCoco Framework.
    
    Ola ta parapanw isxioun kai gia to BehaviorRelay.
    I moni diafora einai oti den mporoume na kanoume kateuthian update to value tou gt einai immutable
    gia ton logo auto prepei na xrisimopoioume ti methodo accept()  < relay.accept() >

 */
func createBehaviorRelay() {
    let relay = BehaviorRelay(value: ["Initial Value"])
    
    relay.asObservable().subscribe { event in
        print(event)
    }
    
    // gia na kanoume update to value prepei na to kratisoume se mia local metavliti kai na to kanoume relay.accept afou teliosoume to update
    
    var value = relay.value
    value.append("Item 1")
    value.append("Item 2")
    value.append("Item 3")

    relay.accept(value)
}


createBehaviorRelay()




