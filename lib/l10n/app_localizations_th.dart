// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appName => 'CatalogX';

  @override
  String get pullToRefresh => 'เลื่อนลงเพื่อรีเฟรช';

  @override
  String get retry => 'ลองใหม่อีกครั้ง';

  @override
  String get undo => 'เลิกทำ';

  @override
  String get clearAll => 'ล้างทั้งหมด';

  @override
  String get loading => 'กำลังโหลด...';

  @override
  String get save => 'บันทึก';

  @override
  String get close => 'ปิด';

  @override
  String get navCatalog => 'แคตตาล็อก';

  @override
  String get navCategories => 'หมวดหมู่';

  @override
  String get navWishlist => 'รายการโปรด';

  @override
  String get navProfile => 'โปรไฟล์';

  @override
  String get navCart => 'ตะกร้า';

  @override
  String get searchHint => 'ค้นหาสินค้า เช่น iPhone, Perfume...';

  @override
  String get searchVoiceStarting => 'กำลังเปิดระบบค้นหาด้วยเสียง...';

  @override
  String get allCategory => 'ทั้งหมด';

  @override
  String showingCountOfTotal(int loaded, int total) {
    return 'แสดง $loaded จาก $total รายการ';
  }

  @override
  String get clearSearchAndFilters => 'ล้างคำค้นหาและตัวกรอง';

  @override
  String get sortBy => 'จัดเรียงตาม';

  @override
  String get sortPopular => 'ยอดนิยม';

  @override
  String get sortRatingDesc => 'คะแนนสูงสุด';

  @override
  String get sortPriceAsc => 'ราคาต่ำ - สูง';

  @override
  String get sortPriceDesc => 'ราคาสูง - ต่ำ';

  @override
  String get sortTitleAsc => 'ชื่อ A - Z';

  @override
  String get filterTooltip => 'ตัวกรอง';

  @override
  String pageOfTotal(int current, int total) {
    return 'หน้า $current จาก $total';
  }

  @override
  String loadedOfTotal(int loaded, int total) {
    return 'โหลดแล้ว $loaded จาก $total รายการ';
  }

  @override
  String get loadingMore => 'กำลังดึงข้อมูลหน้าถัดไป...';

  @override
  String get loadMoreButton => 'โหลดสินค้าเพิ่มเติม...';

  @override
  String get retryLoadMore => 'ลองใหม่';

  @override
  String get allLoaded => 'แสดงสินค้าครบทุกรายการแล้ว';

  @override
  String discountBadge(int percent) {
    return 'ลด $percent%';
  }

  @override
  String get outOfStock => '• สินค้าหมด';

  @override
  String get outOfStockBadge => 'สินค้าหมด';

  @override
  String maxStockReached(int stock) {
    return '• สูงสุดในสต็อก ($stock ชิ้น)';
  }

  @override
  String maxStockReachedShort(int stock) {
    return '• สูงสุดในสต็อก ($stock)';
  }

  @override
  String onlyStockLeft(int stock) {
    return '• เหลือเพียง $stock ชิ้น!';
  }

  @override
  String inStockCount(int stock) {
    return '• มีสินค้าในสต็อก ($stock ชิ้น)';
  }

  @override
  String inStockCountShort(int stock) {
    return '• มีสินค้า ($stock)';
  }

  @override
  String get addToCartTooltip => 'เพิ่มลงในตะกร้า';

  @override
  String get reduceQuantityTooltip => 'ลดจำนวน';

  @override
  String get increaseQuantityTooltip => 'เพิ่มจำนวน';

  @override
  String get maxStockTooltip => 'ถึงจำนวนสูงสุดในสต็อกแล้ว';

  @override
  String addedToCartSnackbar(String title) {
    return 'เพิ่ม \"$title\" ลงในตะกร้าแล้ว';
  }

  @override
  String cartTitle(int count) {
    return 'ตะกร้าสินค้า ($count)';
  }

  @override
  String get emptyCartTitle => 'ไม่มีสินค้าในตะกร้า';

  @override
  String get emptyCartSubtitle =>
      'เลือกซื้อสินค้าที่คุณชอบแล้วกดเพิ่มลงในตะกร้าได้เลย';

  @override
  String get browseProducts => 'เลือกดูสินค้า';

  @override
  String get removeCartItemTooltip => 'ลบรายการนี้';

  @override
  String removedFromCartSnackbar(String title) {
    return 'นำ \"$title\" ออกจากตะกร้าแล้ว';
  }

  @override
  String lineTotalPrefix(String amount) {
    return 'รวม $amount';
  }

  @override
  String get cartSubtotalLabel => 'ยอดรวมทั้งหมด';

  @override
  String get checkoutButton => 'ดำเนินการสั่งซื้อ';

  @override
  String checkoutSnackbar(String amount) {
    return 'กำลังนำคุณไปยังขั้นตอนชำระเงิน ยอดรวม $amount';
  }

  @override
  String wishlistTitle(int count) {
    return 'รายการโปรด ($count)';
  }

  @override
  String get emptyWishlistTitle => 'ยังไม่มีสินค้าในรายการโปรด';

  @override
  String get emptyWishlistSubtitle =>
      'กดที่ไอคอนรูปหัวใจบนการ์ดสินค้าเพื่อเพิ่มลงในรายการโปรด';

  @override
  String get categoriesTitle => 'หมวดหมู่สินค้า';

  @override
  String get allCategoriesSubtitle => 'ดูสินค้าทุกหมวดหมู่';

  @override
  String get productDetailsTitle => 'รายละเอียดสินค้า';

  @override
  String get shareSuccessSnackbar => 'แชร์ลิงก์สินค้านี้เรียบร้อยแล้ว';

  @override
  String get shareTooltip => 'แชร์สินค้า';

  @override
  String reviewsCount(String rating, int count) {
    return '$rating ($count รีวิว)';
  }

  @override
  String saveAmount(String amount) {
    return 'ประหยัด $amount';
  }

  @override
  String get temporarilyOutOfStock => 'สินค้าหมดชั่วคราว';

  @override
  String readyToShipWithStatus(String status) {
    return 'พร้อมส่ง ($status)';
  }

  @override
  String get colorOrOption => 'เฉดสี / ตัวเลือก';

  @override
  String get quantityLabel => 'จำนวน';

  @override
  String inCartIndicator(int count) {
    return 'ในตะกร้า ($count)';
  }

  @override
  String get maxStockReachedBanner => 'สูงสุดในสต็อกแล้ว';

  @override
  String stockLimitExceededSnackbar(String title, int stock) {
    return 'สินค้า \"$title\" มีเพียง $stock ชิ้นในสต็อก';
  }

  @override
  String get contactSupportTooltip => 'ติดต่อเจ้าหน้าที่';

  @override
  String get contactSupportSnackbar =>
      'กำลังเชื่อมต่อกับเจ้าหน้าที่ฝ่ายบริการลูกค้า...';

  @override
  String get addToCartButton => 'ใส่ตะกร้า';

  @override
  String viewCartButton(int count) {
    return 'ดูตะกร้า ($count)';
  }

  @override
  String get buyNowButton => 'ซื้อเลย';

  @override
  String buyNowCheckoutSnackbar(String title) {
    return 'กำลังนำคุณไปยังขั้นตอนชำระเงินสำหรับ $title';
  }

  @override
  String addedItemsToCartSnackbar(int count) {
    return 'เพิ่ม $count ชิ้นลงในตะกร้าแล้ว';
  }

  @override
  String get tabDescription => 'รายละเอียด';

  @override
  String get tabShippingAndReturns => 'การจัดส่ง & คืนสินค้า';

  @override
  String get specDimensionsAndWeight => 'ขนาด & น้ำหนัก';

  @override
  String get specSku => 'รหัสสินค้า (SKU)';

  @override
  String reviewsHeader(int count) {
    return 'รีวิวจากผู้ซื้อจริง ($count)';
  }

  @override
  String get infoShipping => 'ข้อมูลการจัดส่ง';

  @override
  String get infoShippingDefault => 'จัดส่งมาตรฐานภายใน 2-3 วันทำการ';

  @override
  String get infoReturnPolicy => 'นโยบายการคืนสินค้า';

  @override
  String get infoReturnPolicyDefault => 'สามารถคืนสินค้าได้ตามเงื่อนไขที่กำหนด';

  @override
  String get infoWarranty => 'การรับประกันสินค้า';

  @override
  String get infoWarrantyDefault => 'รับประกันศูนย์อย่างเป็นทางการ';

  @override
  String get infoMinOrder => 'จำนวนสั่งซื้อขั้นต่ำ';

  @override
  String infoMinOrderValue(int count) {
    return '$count ชิ้น';
  }

  @override
  String get badgeAuthentic => 'ของแท้ 100%';

  @override
  String get badgeInstallment => 'ผ่อน 0%';

  @override
  String get badgeInstallmentSub => 'สูงสุด 10 เดือน';

  @override
  String get badgeEasyReturn => 'เปลี่ยนง่าย';

  @override
  String get badgeEasyReturnSub => 'ภายใน 30 วัน';

  @override
  String get profileTitle => 'โปรไฟล์ผู้ใช้';

  @override
  String get memberStatus => 'Gold Member';

  @override
  String get savedItemsStat => 'สินค้าที่บันทึก';

  @override
  String get inCartStat => 'ในตะกร้า';

  @override
  String get orderHistoryTitle => 'ประวัติคำสั่งซื้อ';

  @override
  String get orderHistorySubtitle => 'ตรวจสอบสถานะคำสั่งซื้อและการจัดส่ง';

  @override
  String get orderHistorySnackbar => 'กำลังเปิดดูประวัติคำสั่งซื้อ...';

  @override
  String get shippingAddressTitle => 'ที่อยู่ในการจัดส่ง';

  @override
  String get shippingAddressSubtitle =>
      'จัดการที่อยู่จัดส่งและที่อยู่ออกใบเสร็จ';

  @override
  String get paymentMethodsTitle => 'วิธีการชำระเงิน';

  @override
  String get paymentMethodsSubtitle => 'บัตรเครดิต/เดบิต และพร้อมเพย์';

  @override
  String get languageTitle => 'ภาษา (Language)';

  @override
  String languageSubtitle(String language) {
    return 'ปัจจุบัน: $language';
  }

  @override
  String get appLanguageName => 'ไทย';

  @override
  String get currencyNameThb => 'บาทไทย';

  @override
  String get currencyNameUsd => 'ดอลลาร์สหรัฐ';

  @override
  String get currencyTitle => 'สกุลเงิน (Currency)';

  @override
  String currencySubtitle(String currency) {
    return 'ปัจจุบัน: $currency';
  }

  @override
  String currencyExchangeRateNotice(String rate) {
    return 'อัตราแลกเปลี่ยน: 1 USD = $rate บาท';
  }

  @override
  String get helpCenterTitle => 'ศูนย์ช่วยเหลือ';

  @override
  String get helpCenterSubtitle => 'คำถามที่พบบ่อยและติดต่อเจ้าหน้าที่';

  @override
  String get aboutAppTitle => 'เกี่ยวกับแอปพลิเคชัน';

  @override
  String get aboutAppSubtitle => 'เวอร์ชัน 0.1.0 (Build 1)';

  @override
  String get signOutTitle => 'ออกจากระบบ';

  @override
  String get filterTitle => 'ตัวกรองสินค้า';

  @override
  String get filterClearAll => 'ล้างค่าทั้งหมด';

  @override
  String get filterResetSnackbar => 'ล้างตัวกรองสินค้าทั้งหมดแล้ว';

  @override
  String get priceRangeTitle => 'ช่วงราคา';

  @override
  String get minRatingTitle => 'เรตติ้งขั้นต่ำ';

  @override
  String get ratingAny => 'ทั้งหมด';

  @override
  String ratingAndAbove(String rating) {
    return '$rating ★ ขึ้นไป';
  }

  @override
  String get inStockOnlyTitle => 'แสดงเฉพาะสินค้าพร้อมส่ง';

  @override
  String get applyFiltersButton => 'ใช้ตัวกรอง';

  @override
  String get loadErrorTitle => 'ไม่สามารถโหลดข้อมูลได้';

  @override
  String get emptyProductsTitle => 'ไม่พบรายการสินค้า';

  @override
  String get emptyProductsDefaultMessage => 'ไม่พบสินค้าที่คุณกำลังค้นหา';

  @override
  String noProductsMatchingQuery(String query) {
    return 'ไม่พบสินค้าที่ตรงกับ \"$query\"';
  }

  @override
  String get noProductsMatchingFilters => 'ไม่มีสินค้าที่ตรงกับเงื่อนไขตัวกรอง';

  @override
  String get switchLanguageTooltip => 'เปลี่ยนภาษา';

  @override
  String get categoriesFilterTitle => 'หมวดหมู่สินค้า';

  @override
  String get clearCategorySelection => 'ล้างการเลือก';

  @override
  String get clearFiltersChip => 'ล้างตัวกรอง';

  @override
  String get unitCm => 'ซม.';

  @override
  String weightGrams(int weight) {
    return '$weight กรัม';
  }

  @override
  String get dailyExchangeRateBadge => 'อัตราแลกเปลี่ยนประจำวัน';

  @override
  String get fallbackExchangeRateBadge => 'ออฟไลน์ (อัตราเริ่มต้น)';

  @override
  String exchangeRateAsOfDate(String date) {
    return 'ข้อมูล ณ วันที่ $date';
  }

  @override
  String get refreshExchangeRateTooltip => 'อัปเดตอัตราแลกเปลี่ยนล่าสุด';

  @override
  String exchangeRateUpdatedSnackbar(String rate) {
    return 'อัปเดตอัตราแลกเปลี่ยนแล้ว: 1 USD = $rate บาท';
  }
}
