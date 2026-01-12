import { sensor } from '@kit.SensorServiceKit';

export type ShakeCallback = (power: number) => void;

interface AccelData {
  x: number;
  y: number;
  z: number
}

export class SensorService {
  private accelOn: boolean = false;
  private accelHandler?: (d: AccelData) => void;
  private static readonly G: number = 9.81;
  private static readonly INTERVAL_NS: number = 100_000_000; // 100ms

  private readonly threshold: number;

  constructor(threshold: number) {
    this.threshold = threshold;
  }

  start(cb: ShakeCallback): void {
    if (this.accelOn) {
      return;
    }

    this.accelHandler = (d: AccelData): void => {
      const mag: number = Math.sqrt(d.x * d.x + d.y * d.y + d.z * d.z);
      const delta: number = Math.abs(mag - SensorService.G);
      if (delta > this.threshold) {
        cb(delta);
      }
    };

    sensor.on(sensor.SensorId.ACCELEROMETER, this.accelHandler, { interval: SensorService.INTERVAL_NS });
    this.accelOn = true;
  }

  stop(): void {
    if (!this.accelOn) {
      return;
    }
    if (this.accelHandler) {
      try {
        sensor.off(sensor.SensorId.ACCELEROMETER, this.accelHandler);
      } catch {
      }
      this.accelHandler = undefined;
    }
    this.accelOn = false;
  }
}
