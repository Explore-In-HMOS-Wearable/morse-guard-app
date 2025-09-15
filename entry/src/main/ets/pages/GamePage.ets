import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { HapticService } from '../services/HapticService';
import { MorseEngine } from '../services/MorseEngine';
import { PatternPlayer } from '../services/PatternPlayer';

@Entry
@Component
export struct GamePage {
  private eng: MorseEngine = new MorseEngine();
  private haptic: HapticService = new HapticService();
  private player: PatternPlayer = new PatternPlayer(this.haptic);

  @State targetLetter: string = '';
  @State targetPattern: string = '';
  @State options: string[] = []; // two choices
  @State score: number = 0;
  @State round: number = 1;
  @State isPlaying: boolean = false;

  aboutToAppear(): void {
    this.startRound();
  }

  private startRound(): void {
    this.isPlaying = true;
    this.targetLetter = this.eng.randomLetter();
    this.targetPattern = this.eng.toMorse(this.targetLetter);
    const distractor: string = this.eng.makeDistractor(this.targetLetter);
    this.options = this.shuffle([this.targetLetter, distractor]);
    this.player.play(this.targetPattern).finally(() => (this.isPlaying = false));
  }

  private resetGame(): void {
    this.isPlaying = false;
    this.score = 0;
    this.round = 1;
    this.targetLetter = '';
    this.targetPattern = '';
    this.options = [];
    this.startRound();
  }

  private shuffle<T>(arr: T[]): T[] {
    for (let i = arr.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      const tmp = arr[i];
      arr[i] = arr[j];
      arr[j] = tmp;
    }
    return arr;
  }

  private choose(letter: string): void {
    if (this.isPlaying) return;

    const ok = letter === this.targetLetter;
    if (ok) {
      this.score += 10;
      this.haptic.ok();

      if (this.score >= 100) {
        router.pushUrl({ url: 'pages/WinPage', params: { score: this.score } });
        return;
      }
      this.round += 1;
      this.startRound();
    } else {
      this.score = Math.max(0, this.score - 2);
      this.haptic.nok();
      promptAction.showToast({ message: `Wrong! Correct letter: ${this.targetLetter}` });

      this.round += 1;
      this.startRound();
    }
  }

  build(): void {
    Column({ space: 10 }) {
      // Top-left Back
      Row() {
        Button({ type: ButtonType.Normal }) {
          Image($r('app.media.back_button'))
            .width(20)
            .height(20)
            .fillColor(Color.White)
        }
        .backgroundColor(Color.Transparent)
        .onClick(() => router.replaceUrl({ url: 'pages/HomePage' }))
      }
      .justifyContent(FlexAlign.Start)
      .padding({ left: 6, top: 10 })

      // Centered Restart (resets score & round)
      Row() {
        Blank()
        Button('Restart')
          .width(115)
          .backgroundColor(Color.Green)
          .height(20)
          .fontSize(12)
          .onClick(() => this.resetGame())
        Blank()
      }
      .width('100%')

      // Optional small Replay under Restart
      Row() {
        Blank()
        Button('Replay Pattern')
          .width(115)
          .height(20)
          .fontSize(12)
          .enabled(!this.isPlaying)
          .onClick(() => {
            this.isPlaying = true;
            this.player.play(this.targetPattern).finally(() => (this.isPlaying = false));
          })
        Blank()
      }
      .width('100%')

      // Title
      Text('Morse Guess')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .padding({ bottom: 4 })

      // Round & score line
      Row({ space: 10 }) {
        Text(`Round ${this.round}`)
          .fontSize(12)
          .opacity(0.8)
        Blank()
        Text(`Score: ${this.score}`)
          .fontSize(12)
          .opacity(0.8)
      }
      .width('100%')
      .padding({ left: 35, right: 35 })

      // Two choice buttons
      Row({ space: 20 }) {
        ForEach(this.options, (opt: string) => {
          Button(` ${opt} `)
            .width(80)
            .height(25)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .onClick(() => this.choose(opt))
        }, (opt: string) => opt)
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .width('100%')

      Text('Tip: Use Replay Pattern \n to feel the vibration again.')
        .fontSize(8)
        .opacity(0.7)
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0C1426')
    .foregroundColor(Color.White)
  }
}
