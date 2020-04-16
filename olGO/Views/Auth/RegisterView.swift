import SwiftUI
import SwiftUIKit
import Combine

// change view title to whatever name is actually going to bes
struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    
    @State private var bag = CancelBag()
    @State private var isRequesting: Bool = false
    
    var body: some View {
        let cornerRadius: CGFloat = 10
        
        return VStack {
            HStack {
                // Image calls on asset logo, may need to rename if asset name changes
                Image("oneleifgoodlogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(cornerRadius)
                Text("Sign Up for OneLeif!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(.top, 10)
            
            HStack {
                Text("Email:       ")
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                TextField(" \"John\" ", text: $email)
                    .background(Color.white)
                    .clipShape( Capsule() )
            }
            .padding(.trailing, 10)
            
            HStack {
                Text("Password:")
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                SecureField(" Check note below", text: $password)
                    .background(Color.white)
                    .clipShape( Capsule() )
            }
            .padding(.trailing, 10)
            
            HStack {
                Text("Confirm:   ")
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                SecureField(" Re-type Here", text: $confirmPassword)
                    .background(Color.white)
                    .clipShape( Capsule() )
            }
            .padding(.trailing, 10)
            .padding(.bottom, 20)
            
            Text("Password must have at least 7 characters   ")
                .padding(.top, 50)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("At least 1 uppercase")
                    Text("At least 1 number")
                }
                .padding(.trailing, 20)
                VStack(alignment: .leading){
                    Text("At least 1 special")
                    Text("At least 1 lowercase")
                }
            }
            .padding(.bottom, 50)
            
            Button("Submit") {
               self.submit()
            }
                .disabled(email.isEmpty || passwordProtocol())
                .padding(.horizontal, 50)
                .padding(.vertical)
                .font(.headline)
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape( Capsule() )
        }
        .frame(
            minWidth: 350,
            idealWidth: 400,
            maxWidth: 450,
            minHeight: 500,
            idealHeight: 600,
            maxHeight: 700,
            alignment: .center)
            .background( Color.init( white: 0.45))
            .cornerRadius(cornerRadius)
            .padding(.horizontal, 10)
            .padding(.bottom, 100)
    }
    
    private func submit() {
    guard !self.isRequesting else {
            return
        }
        self.isRequesting = true
        
        API.instance.login(user: User(email: self.email,
                                      password: self.password))
            .sink(receiveCompletion: { (result) in
                
                self.isRequesting = false
                if case .failure(let error) = result {
                    print(error.localizedDescription)
                }
                
            }, receiveValue: { (response) in
                print(response)
                
                DispatchQueue.main.async {
                    Navigate.shared.go(UIViewController {
                        UIView(backgroundColor: .white) {
                            Label("You are logged in")
                        }
                    }, style: .modal)
                }
            })
            .canceled(by: &bag)
    }
    
    private func passwordProtocol() -> Bool {
        var upper = false
        var lower = false
        var numb = false
        var symbol = false
        
        var passwordCheck = false
        
        for char in password {
            if char.isUppercase {
                upper = true
            } else if char.isLowercase {
                lower = true
            } else if char.isNumber {
                numb = true
            } else if char.isPunctuation || char.isSymbol {
                symbol = true
            }
            if upper && lower && numb && symbol {
                passwordCheck = true
                break
            }
        }
        if passwordCheck && password == confirmPassword {
            return true
        }
        return false
    }
    
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
