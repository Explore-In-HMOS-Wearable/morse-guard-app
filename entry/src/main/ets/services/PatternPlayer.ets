import { HapticService } from './HapticService';

export class PatternPlayer {
  private readonly DOT = 120;
  private readonly DASH = 360;
  private readonly INTRA_GAP = 120;
  private readonly LETTER_GAP = 360;
  private h: HapticService;

  constructor(h: HapticService) {
    this.h = h;
  }


  async play(pattern: string): Promise<void> {
    if (!pattern) return;
    const parts = pattern.split('');
    for (let i = 0; i < parts.length; i++) {
      const p = parts[i];
      if (p === '.') await this.h.vibrate(this.DOT);
      else if (p === '-') await this.h.vibrate(this.DASH);
      if (i < parts.length - 1) await this.h.gap(this.INTRA_GAP);
    }
    await this.h.gap(this.LETTER_GAP);
  }
}