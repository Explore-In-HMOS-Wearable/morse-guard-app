import { router } from '@kit.ArkUI';

interface WinParams {
  score?: number;
}

@Entry
@Component
export struct WinPage {
  private readonly params: WinParams = this.getUIContext().getRouter().getParams() as WinParams;
  private score: number = this.params.score ?? 100;
  @Consume('pages') pages: NavPathStack;

  build() {
    NavDestination() {
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
          .onClick(() =>
            this.pages.pushPathByName('GamePage',0))
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor('#0C1426')
      .foregroundColor(Color.White)
    }
    .onReady(cxt => {
      this.score = cxt.pathInfo.param as number
    })
  }
}
