import { cryptoFramework } from '@kit.CryptoArchitectureKit';

export class MorseEngine {
  private readonly map: Record<string, string> = {
    'A': '.-',
    'B': '-...',
    'C': '-.-.',
    'D': '-..',
    'E': '.',
    'F': '..-.',
    'G': '--.',
    'H': '....',
    'I': '..',
    'J': '.---',
    'K': '-.-',
    'L': '.-..',
    'M': '--',
    'N': '-.',
    'O': '---',
    'P': '.--.',
    'Q': '--.-',
    'R': '.-.',
    'S': '...',
    'T': '-',
    'U': '..-',
    'V': '...-',
    'W': '.--',
    'X': '-..-',
    'Y': '-.--',
    'Z': '--..'
  };
  private pool: string[] = Object.keys(this.map);

  toMorse(letter: string): string {
    return this.map[(letter || '').toUpperCase()] ?? '';
  }

  randomLetter(): string {
    return this.pool[Math.floor(this.randomNumber() * this.pool.length)];
  }

  randomNumber(): number {
    let rand = cryptoFramework.createRandom();
    let randOutput = rand.generateRandomSync(1);
    let mappedRandom = randOutput.data[0] / 255
    return mappedRandom
  }

  makeDistractor(correct: string): string {
    const target = this.toMorse(correct);
    const len = target.length;
    const candidates = this.pool.filter(l => l !== correct && this.toMorse(l).length === len);
    if (candidates.length === 0) {
      return this.pool.find(l => l !== correct) as string;
    }
    return candidates[Math.floor(this.randomNumber() * candidates.length)];
  }
}