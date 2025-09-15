import { router } from "@kit.ArkUI";

interface WinParams {
  score?: number;
}

@Entry
@Component
export struct WinPage {
  private readonly params: WinParams = router.getParams() as WinParams;
  @State score: number = this.params.score ?? 100;

  build() {
    Column({ space: 14 }) {
      Text('Congratulations!')
        .fontSize(22)
        .fontWeight(FontWeight.Bolder)
        .textAlign(TextAlign.Center)

      Text(`Score: ${this.score}`)
        .fontSize(16)
        .textAlign(TextAlign.Center)

      Button('Play Again')
        .height(44).width('80%')
        .onClick(() => router.replaceUrl({ url: 'pages/GamePage' }))
    }
    .width('100%').height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#0C1426')
    .foregroundColor(Color.White)
  }
}
