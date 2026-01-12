@Component
export struct DotDashPad {
  @Prop onDot!: () => void;
  @Prop onDash!: () => void;
  @Prop longPressMs: number = 320;
  private pressStart: number = 0;

  build(): void {
    Column({ space: 6 }) {
      Rect()
        .width('100%')
        .height(140)
        .fill('#162240')
        .border({ width: 1, color: Color.White, radius: 10 })
        .onTouch((e: TouchEvent) => {
          if (e.type === TouchType.Down) {
            this.pressStart = Date.now();
          } else if (e.type === TouchType.Up) {
            const elapsed: number = Date.now() - this.pressStart;
            if (elapsed < this.longPressMs) {
              this.onDot()
            } else {
              this.onDash();
            }
          }
        })
      Text('Press short = •    Press long = —')
        .fontSize(12)
        .opacity(0.8)
        .textAlign(TextAlign.Center)
    }
    .width('100%')
  }
}
