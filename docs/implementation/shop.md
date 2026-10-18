# Shop polish (packet 01)

The owner approved the packet prices on 2026-10-18: streak-shield 250,
frame-cyan-orbit 200, frame-violet-scholar 400, badge-atom 300,
badge-streak 350, theme-aurora 600 and theme-ember 750 Norie Credits.
Catalog IDs, previously owned items and historical receipt amounts remain intact.

The Shop browses categories and owned cosmetics, previews the learner's current
appearance without saving a draft, and persists equip/unequip through existing
progression slots. Profile renders those slots through the same appearance
preview. Cosmetics remain offline code-native decorations; avatar/pose art and
rank-earned appearance choices are preserved.

Purchases require confirmation showing the current balance before and after.
A wallet change during the dialog requires another review. Purchases reuse the
existing economy store, device reservation, duplicate guard and receipt ledger.
Pending account purchases cannot be bought again or equipped before ownership.

The status card separates device save state from account sync state. Retry uses
the existing save and cloud sync APIs. Historical purchase requests are labeled
as submissions rather than inferred server confirmations. Account sync is not
configured for the current deployment, and this change does not configure it.

Targeted checks: `flutter test test/norie_shop_test.dart
test/norie_shop_screen_test.dart`. The integration owner runs analysis, the full
suite and platform builds serially. Widget coverage includes categories,
insufficient/exact balances, cancellation, a changing wallet, temporary preview,
owned equip/unequip and 320px layout with 160% text.

The revised client prices are not yet deployed to the authoritative server
catalog. `NorieShopCatalog.accountPricingReady` remains false: account-backed
purchases are blocked in both the UI and progression API, including an activated
ledger while signed out. Guest purchases use the approved prices offline.
Enable account pricing only after the reviewed server migration is applied and
verified; existing ownership and equipment remain usable.
