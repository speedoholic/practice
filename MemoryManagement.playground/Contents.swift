class User {
  var name: String
  private(set) var phones: [Phone] = []
  func add(phone: Phone) {
    phones.append(phone)
    phone.owner = self
  }
  
  var subscriptions: [CarrierSubscription] = []
  
  init(name: String) {
    self.name = name
    print("User \(name) is initialized")
  }
  
  deinit {
    print("User \(name) is being deallocated")
  }
}

class Phone {
  let model: String
  weak var owner: User?
  var carrierSubscription: CarrierSubscription?
  
  func provision(carrierSubscription: CarrierSubscription) {
    self.carrierSubscription = carrierSubscription
  }
  
  func decommission() {
    self.carrierSubscription = nil
  }
  
  init(model: String) {
    self.model = model
    print("Phone \(model) is initialized")
  }
  
  deinit {
    print("Phone \(model) is being deallocated")
  }
}

class CarrierSubscription {
  lazy var completePhoneNumber: () -> String = { [unowned self] in
    self.countryCode + " " + self.number
  }
  let name: String
  let countryCode: String
  let number: String
  unowned let user: User
  
  init(name: String, countryCode: String, number: String, user: User) {
    self.name = name
    self.countryCode = countryCode
    self.number = number
    self.user = user
    
    user.subscriptions.append(self)
    
    print("CarrierSubscription \(name) is initialized")
  }
  
  deinit {
    print("CarrierSubscription \(name) is being deallocated")
  }
}

do {
  let john = User(name: "John")
  let iPhone = Phone(model: "iPhone 6s Plus")
  john.add(phone: iPhone)
  
  let subscription1 = CarrierSubscription(name: "TelBel", countryCode: "0032", number: "31415926", user: john)
  iPhone.provision(carrierSubscription: subscription1)
  print(subscription1.completePhoneNumber())
}

var x = 5
var y = 5

let someClosure = { [x] in
  print("\(x), \(y)")
}

x = 6
y = 6

someClosure()        // Prints 5, 6
print("\(x), \(y)")  // Prints 6, 6


// A class that generates WWDC Hello greetings.  See http://wwdcwall.com
class WWDCGreeting {
  let who: String
  
  init(who: String) {
    self.who = who
  }
  
  lazy var greetingMaker: () -> String = {
    [weak self] in
    guard let strongSelf = self else {
      return "No greeting available."
    }
    return "Hello \(strongSelf.who)."
  }
}

let greetingMaker: () -> String

do {
  let mermaid = WWDCGreeting(who: "caffinated mermaid")
  greetingMaker = mermaid.greetingMaker
}

greetingMaker()

class Node {
  var payload = 0
  var next: Node? = nil
}

class Unowned<T: AnyObject> {
  unowned var value: T
  init (_ value: T) {
    self.value = value
  }
}

class Person {
  var name: String
  var friends: [Unowned<Person>] = []
  init(name: String) {
    self.name = name
    print("New person instance: \(name)")
  }
  
  deinit {
    print("Person instance \(name) is being deallocated")
  }
}

do {
  let ernie = Person(name: "Ernie")
  let bert = Person(name: "Bert")
  
  ernie.friends.append(Unowned(bert))
  bert.friends.append(Unowned(ernie))
}
