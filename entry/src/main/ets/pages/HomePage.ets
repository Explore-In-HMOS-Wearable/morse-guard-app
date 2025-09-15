import router from '@ohos.router';

@Entry
@Component
export struct HomePage {
  build() {
    Column({ space: 10 }) {
      Text('Welcome to \n Morse Guess Game')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .padding({ bottom: 20 })

      Button('Start Game')
        .width(140)
        .height(40)
        .fontSize(16)
        .onClick(() => {
          router.pushUrl({ url: 'pages/GamePage' })
        })

      Button('Exit')
        .width(140)
        .height(40)
        .fontSize(16)
        .onClick(() => {
          router.clear()
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#0C1426')
    .foregroundColor(Color.White)
  }
}
