import { abilityAccessCtrl, bundleManager, common, Permissions, PermissionRequestResult } from '@kit.AbilityKit';

class PermissionsUtil {
  async ensurePermissions(ctx: common.UIAbilityContext, list: Permissions[]): Promise<boolean> {
    const atManager = abilityAccessCtrl.createAtManager();

    let tokenId = 0;
    try {
      const info = await bundleManager.getBundleInfoForSelf(
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION
      );
      tokenId = info.appInfo.accessTokenId;
    } catch {
    }

    const need: Permissions[] = [];
    for (const p of list) {
      try {
        const st = await atManager.checkAccessToken(tokenId, p);
        if (st !== abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
          need.push(p);
        }
      } catch {
        need.push(p);
      }
    }
    if (need.length === 0) {
      return true;
    }

    try {
      const res: PermissionRequestResult = await atManager.requestPermissionsFromUser(ctx, need);
      return !!res.authResults.length && res.authResults.every(r => r === 0);
    } catch {
      return false;
    }
  }
}

export default new PermissionsUtil();
