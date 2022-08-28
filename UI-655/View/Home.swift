//
//  Home.swift
//  UI-655
//
//  Created by nyannyan0328 on 2022/08/28.
//

import SwiftUI

struct Home: View {
    @State var activeGlassMorphism : Bool = false
    @State var blurView : UIVisualEffectView = .init()
    @State var defalutBlurRadius : CGFloat = 0
    @State var defaultStaurationAmount : CGFloat = 0
    
    var body: some View {
        ZStack{
            
            Color("BG").ignoresSafeArea()
            
            
            
            Image("TopCircle")
                .offset(x:180,y:-150)
            
            
            Image("CenterCircle")
                .offset(x:0,y:-80)
            
            Image("BottomCircle")
                .offset(x:-200,y:80)
            
           Toggle("Active Glass Morphism", isOn: $activeGlassMorphism)
                .font(.title3.weight(.bold))
                .onChange(of: activeGlassMorphism, perform: { newValue in
                    
                    
                    blurView.gaussianBlurRadius = (activeGlassMorphism ? 10 : defalutBlurRadius)
                    
                    blurView.staturationAmount = (activeGlassMorphism ? 1.8 : defaultStaurationAmount)
                    
                    
                })
                .padding(.horizontal)
                .foregroundColor(.gray.opacity(0.8))
                .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .bottom)
            
            
            
            
            GlassMorphicsCard()
            
            
            
        }
    }
    @ViewBuilder
    func GlassMorphicsCard()->some View{
        
        ZStack{
            
            CustomBlurView(effect: .systemThickMaterialDark) { view in
                
                blurView = view
                if defalutBlurRadius == 0{defalutBlurRadius = view.gaussianBlurRadius}
                
                if defaultStaurationAmount == 0{
                    
                    defaultStaurationAmount = view.staturationAmount
                }
                
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
            
            RoundedRectangle(cornerRadius: 25,style: .continuous)
                .fill(
                
                    LinearGradient(colors: [
                        .white.opacity(0.25),
                        .white.opacity(0.05)
                    
                    
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                
                )
                .blur(radius: 5)
            
            
            RoundedRectangle(cornerRadius: 10,style: .continuous)
            
                .stroke(
                
                    LinearGradient(colors: [
                        .white.opacity(0.6),
                        .clear,
                        .purple.opacity(0.2),
                        .purple.opacity(0.5)
                    
                    
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .shadow(color:.black.opacity(0.15), radius: 5,x: 15,y: 15)
                .shadow(color:.black.opacity(0.15), radius: 5,x: 15,y: -15)
                .overlay {
                    
                    CardContent()
                        .opacity(activeGlassMorphism ? 1 : 0)
                        .animation(.easeIn(duration:(1)), value: activeGlassMorphism)
                    
                }
            
            
           
        }
        .padding(.horizontal,25)
        .frame(height:220)
        
    }
    @ViewBuilder
    func CardContent()->some View{
        
        VStack(alignment:.leading,spacing: 10){
            
         
            HStack{
                Text("Membership".uppercased())
                    .modifier(CustomModifier(font: .subheadline, weight: .semibold))
                
                   Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                 .frame(width: 50,height: 50)
                 .clipShape(Circle())
            }
            
            Spacer()
            
              Text("King Of Animal")
                .modifier(CustomModifier(font: .body, weight: .light))
            
            Text("Lion")
                .modifier(CustomModifier(font: .footnote, weight: .bold))
            
        }
        .padding(15)
        .padding(.vertical,10)
        .blendMode(.screen)
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
        
        
    }
}

extension UIView{
    
    func subViews(forclass : AnyClass?) -> UIView?{
        
        return subviews.first { view in
            type(of: view) == forclass
        }
    }
}
extension NSObject{
    
    var values : [String : Any]?{
        
        get{
            
            return value(forKeyPath: "requestedValues") as? [String : Any]
            
        }
        set{
            
        setValue(newValue, forKey: "requestedValues")
            
        }
    }
    func value(key : String,filter : String)->NSObject?{
        
        (value(forKey: key) as? [NSObject])?.first(where: { obj in
            
            return obj.value(forKey: "filterType") as? String == filter
        })
    }
}
extension UIVisualEffectView{
    
    var backDrop : UIView?{
        
        return subViews(forclass: NSClassFromString("_UIVisualEffectBackdropView"))
    }
    
    var gaussianBlur : NSObject?{
        
        return backDrop?.value(key: "filters", filter: "gaussianBlur")
    }
    var satulation : NSObject?{
        
        return backDrop?.value(key: "filters", filter: "colorSaturate")
    }
    
    var gaussianBlurRadius : CGFloat{
        
        get{
            return gaussianBlur?.values?["inputRadius"] as? CGFloat ?? 0
            
        }
        set{
            
            gaussianBlur?.values?["inputRadius"] = newValue
            
            applyNewEffects()
            
        }
        
       
            
            
        }
    
    func applyNewEffects(){
        UIVisualEffectView.animate(withDuration: 1){
            
            self.backDrop?.perform(Selector(("applyRequestedFilterEffects")))
            
        }
    }
    var staturationAmount : CGFloat{
        
        get{
            
            return satulation?.values?["inputAmount"] as? CGFloat ?? 0
            
        }
        set{
            
            satulation?.values?["inputAmount"] = newValue
            applyNewEffects()
            
            
        }
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomBlurView : UIViewRepresentable{
    
    var effect : UIBlurEffect.Style
    var onChange : (UIVisualEffectView) ->()
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: effect))
        return view
        
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
        DispatchQueue.main.async {
         
            onChange(uiView)
        }
        
    }
}

struct CustomModifier : ViewModifier{
    
    var font : Font
    var weight : Font.Weight
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .fontWeight(weight)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity,alignment: .leading)
            .kerning(1.2)
            .shadow(radius: 15)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
}
