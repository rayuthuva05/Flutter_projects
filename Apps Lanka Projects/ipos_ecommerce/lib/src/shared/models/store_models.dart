import 'package:equatable/equatable.dart';

class StoreHomeData extends Equatable {
  const StoreHomeData({
    required this.storeName,
    required this.logoUrl,
    required this.currencySymbol,
    required this.showProductImages,
    required this.themeKey,
    required this.primaryColorHex,
    required this.accentColorHex,
    required this.sliders,
    required this.featuredCategories,
    required this.featuredBrands,
    required this.featuredProducts,
    required this.newArrivals,
    required this.stats,
  });

  factory StoreHomeData.fromJson(Map<String, dynamic> json) {
    final config =
        (json['config'] as Map<String, dynamic>? ?? <String, dynamic>{});
    final currency =
        (config['currency'] as Map<String, dynamic>? ?? <String, dynamic>{});
    final features =
        (config['features'] as Map<String, dynamic>? ?? <String, dynamic>{});

    return StoreHomeData(
      storeName: (config['name'] as String?) ?? 'Store',
      logoUrl: config['logo_url'] as String?,
      currencySymbol: (currency['symbol'] as String?) ?? '\$',
      showProductImages: features['image'] as bool? ?? true,
      themeKey: (config['theme'] as String?) ?? 'foodwin',
      primaryColorHex: config['primary_color'] as String?,
      accentColorHex: config['accent_color'] as String?,
      sliders: ((json['sliders'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(StoreSlider.fromJson)
          .toList(),
      featuredCategories: ((json['featured_categories'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(StoreCategory.fromJson)
          .toList(),
      featuredBrands: ((json['featured_brands'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(StoreBrand.fromJson)
          .toList(),
      featuredProducts: ((json['featured_products'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(StoreProduct.fromJson)
          .toList(),
      newArrivals: ((json['new_arrivals'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(StoreProduct.fromJson)
          .toList(),
      stats: StoreHomeStats.fromJson(
        json['stats'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      ),
    );
  }

  final String storeName;
  final String? logoUrl;
  final String currencySymbol;
  final bool showProductImages;
  final String themeKey;
  final String? primaryColorHex;
  final String? accentColorHex;
  final List<StoreSlider> sliders;
  final List<StoreCategory> featuredCategories;
  final List<StoreBrand> featuredBrands;
  final List<StoreProduct> featuredProducts;
  final List<StoreProduct> newArrivals;
  final StoreHomeStats stats;

  @override
  List<Object?> get props => [
    storeName,
    logoUrl,
    currencySymbol,
    showProductImages,
    themeKey,
    primaryColorHex,
    accentColorHex,
    sliders,
    featuredCategories,
    featuredBrands,
    featuredProducts,
    newArrivals,
    stats,
  ];
}

class StoreSlider extends Equatable {
  const StoreSlider({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.link,
    required this.imageUrl,
    required this.imageUrls,
    required this.imageSmUrl,
    required this.imageSmUrls,
  });

  factory StoreSlider.fromJson(Map<String, dynamic> json) {
    return StoreSlider(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      link: json['link'] as String?,
      imageUrl: json['image_url'] as String?,
      imageUrls: ((json['image_urls'] as List?) ?? const [])
          .whereType<String>()
          .toList(),
      imageSmUrl: json['image_sm_url'] as String?,
      imageSmUrls: ((json['image_sm_urls'] as List?) ?? const [])
          .whereType<String>()
          .toList(),
    );
  }

  final int id;
  final String? title;
  final String? subtitle;
  final String? link;
  final String? imageUrl;
  final List<String> imageUrls;
  final String? imageSmUrl;
  final List<String> imageSmUrls;

  String? get preferredImageUrl {
    final candidates = <String?>[
      imageSmUrl,
      imageUrl,
      if (imageSmUrls.isNotEmpty) imageSmUrls.first,
      if (imageUrls.isNotEmpty) imageUrls.first,
    ];

    for (final candidate in candidates) {
      if (candidate != null && candidate.isNotEmpty) {
        return candidate;
      }
    }

    return null;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    link,
    imageUrl,
    imageUrls,
    imageSmUrl,
    imageSmUrls,
  ];
}

class StoreHomeStats extends Equatable {
  const StoreHomeStats({
    required this.productsCount,
    required this.customersCount,
  });

  factory StoreHomeStats.fromJson(Map<String, dynamic> json) {
    return StoreHomeStats(
      productsCount: json['products_count'] as int? ?? 0,
      customersCount: json['customers_count'] as int? ?? 0,
    );
  }

  final int productsCount;
  final int customersCount;

  @override
  List<Object?> get props => [productsCount, customersCount];
}

class StoreCategory extends Equatable {
  const StoreCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.color,
    required this.productsCount,
    required this.imageUrl,
    required this.imageSmUrl,
    required this.children,
  });

  factory StoreCategory.fromJson(Map<String, dynamic> json) {
    return StoreCategory(
      id: json['id'] as int? ?? 0,
      name: (json['name'] as String?) ?? '',
      slug: (json['slug'] as String?) ?? '',
      color: json['color'] as String?,
      productsCount: json['products_count'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
      imageSmUrl: json['image_sm_url'] as String?,
      children: ((json['children'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(StoreCategory.fromJson)
          .toList(),
    );
  }

  final int id;
  final String name;
  final String slug;
  final String? color;
  final int productsCount;
  final String? imageUrl;
  final String? imageSmUrl;
  final List<StoreCategory> children;

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    color,
    productsCount,
    imageUrl,
    imageSmUrl,
    children,
  ];
}

class StoreBrand extends Equatable {
  const StoreBrand({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
    required this.bannerUrl,
  });

  factory StoreBrand.fromJson(Map<String, dynamic> json) {
    return StoreBrand(
      id: json['id'] as int? ?? 0,
      name: (json['name'] as String?) ?? '',
      slug: json['slug'] as String?,
      imageUrl: json['image_url'] as String?,
      bannerUrl: json['banner_url'] as String?,
    );
  }

  final int id;
  final String name;
  final String? slug;
  final String? imageUrl;
  final String? bannerUrl;

  @override
  List<Object?> get props => [id, name, slug, imageUrl, bannerUrl];
}

class StoreDeal extends Equatable {
  const StoreDeal({
    required this.id,
    required this.price,
    required this.maxQty,
    required this.expiresAt,
  });

  factory StoreDeal.fromJson(Map<String, dynamic> json) {
    return StoreDeal(
      id: (json['id'] as String?) ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      maxQty: (json['max_qty'] as num?)?.toInt() ?? 0,
      expiresAt: json['expires_at'] as String?,
    );
  }

  final String id;
  final double price;
  final int maxQty;
  final String? expiresAt;

  @override
  List<Object?> get props => [id, price, maxQty, expiresAt];
}

class StoreProduct extends Equatable {
  const StoreProduct({
    required this.id,
    required this.slug,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.imageUrl,
    required this.imageUrls,
    required this.price,
    required this.effectivePrice,
    required this.comparePrice,
    required this.hasActiveOffer,
    required this.offerExpiresAt,
    required this.deal,
    required this.stock,
    required this.isInStock,
    required this.maxOrderQty,
    required this.brandName,
    required this.categoryName,
    required this.note,
  });

  factory StoreProduct.fromJson(Map<String, dynamic> json) {
    final brand = json['brand'] as Map<String, dynamic>?;
    final category = json['category'] as Map<String, dynamic>?;

    return StoreProduct(
      id: json['id'] as int? ?? 0,
      slug: (json['slug'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      subTitle: json['sub_title'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      imageUrls: ((json['image_urls'] as List?) ?? const [])
          .whereType<String>()
          .toList(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      effectivePrice: (json['effective_price'] as num?)?.toDouble() ?? 0,
      comparePrice: (json['compare_price'] as num?)?.toDouble(),
      hasActiveOffer: json['has_active_offer'] as bool? ?? false,
      offerExpiresAt: json['offer_expires_at'] as String?,
      deal: json['deal'] is Map<String, dynamic>
          ? StoreDeal.fromJson(json['deal'] as Map<String, dynamic>)
          : null,
      stock: (json['stock'] as num?)?.toDouble() ?? 0,
      isInStock: json['is_in_stock'] as bool? ?? true,
      maxOrderQty: (json['max_order_qty'] as num?)?.toInt() ?? 99,
      brandName: brand?['name'] as String?,
      categoryName: category?['name'] as String?,
      note: json['note'] as String?,
    );
  }

  final int id;
  final String slug;
  final String title;
  final String? subTitle;
  final String? description;
  final String? imageUrl;
  final List<String> imageUrls;
  final double price;
  final double effectivePrice;
  final double? comparePrice;
  final bool hasActiveOffer;
  final String? offerExpiresAt;
  final StoreDeal? deal;
  final double stock;
  final bool isInStock;
  final int maxOrderQty;
  final String? brandName;
  final String? categoryName;
  final String? note;

  bool get hasDiscount =>
      comparePrice != null && comparePrice! > effectivePrice;

  String? get countdownEndsAt => offerExpiresAt ?? deal?.expiresAt;

  @override
  List<Object?> get props => [
    id,
    slug,
    title,
    subTitle,
    description,
    imageUrl,
    imageUrls,
    price,
    effectivePrice,
    comparePrice,
    hasActiveOffer,
    offerExpiresAt,
    deal,
    stock,
    isInStock,
    maxOrderQty,
    brandName,
    categoryName,
    note,
  ];
}

class PaginatedProducts extends Equatable {
  const PaginatedProducts({
    required this.items,
    required this.currentPage,
    required this.lastPage,
  });

  factory PaginatedProducts.fromJson(Map<String, dynamic> json) {
    final meta = (json['meta'] as Map<String, dynamic>? ?? <String, dynamic>{});

    return PaginatedProducts(
      items: ((json['data'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(StoreProduct.fromJson)
          .toList(),
      currentPage: meta['current_page'] as int? ?? 1,
      lastPage: meta['last_page'] as int? ?? 1,
    );
  }

  final List<StoreProduct> items;
  final int currentPage;
  final int lastPage;

  @override
  List<Object?> get props => [items, currentPage, lastPage];
}

class CartSummary extends Equatable {
  const CartSummary({
    required this.items,
    required this.totals,
    required this.cartCount,
    required this.hasStockIssues,
    required this.message,
  });

  factory CartSummary.fromJson(Map<String, dynamic> json, {String? message}) {
    final data = (json['data'] as Map<String, dynamic>? ?? <String, dynamic>{});

    return CartSummary(
      items: ((data['items'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(CartItem.fromJson)
          .toList(),
      totals: PriceSummary.fromJson(
        data['totals'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      cartCount: data['cart_count'] as int? ?? 0,
      hasStockIssues: data['has_stock_issues'] as bool? ?? false,
      message: message ?? json['message'] as String?,
    );
  }

  final List<CartItem> items;
  final PriceSummary totals;
  final int cartCount;
  final bool hasStockIssues;
  final String? message;

  @override
  List<Object?> get props => [
    items,
    totals,
    cartCount,
    hasStockIssues,
    message,
  ];
}

class CartItem extends Equatable {
  const CartItem({
    required this.id,
    required this.qty,
    required this.lineTotal,
    required this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: (json['id'] as String?) ?? '',
      qty: json['qty'] as int? ?? 0,
      lineTotal: (json['line_total'] as num?)?.toDouble() ?? 0,
      product: StoreProduct.fromJson(
        json['variant'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }

  final String id;
  final int qty;
  final double lineTotal;
  final StoreProduct product;

  @override
  List<Object?> get props => [id, qty, lineTotal, product];
}

class PriceSummary extends Equatable {
  const PriceSummary({
    required this.subtotal,
    required this.shipping,
    required this.vat,
    required this.total,
  });

  factory PriceSummary.fromJson(Map<String, dynamic> json) {
    return PriceSummary(
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      shipping: (json['shipping'] as num?)?.toDouble() ?? 0,
      vat: (json['vat'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
    );
  }

  final double subtotal;
  final double shipping;
  final double vat;
  final double total;

  @override
  List<Object?> get props => [subtotal, shipping, vat, total];
}

class UserSession extends Equatable {
  const UserSession({required this.token, required this.user});

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      token: (json['token'] as String?) ?? '',
      user: StoreUser.fromJson(
        json['user'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      ),
    );
  }

  final String token;
  final StoreUser user;

  @override
  List<Object?> get props => [token, user];
}

class StoreUser extends Equatable {
  const StoreUser({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory StoreUser.fromJson(Map<String, dynamic> json) {
    return StoreUser(
      id: json['id'] as int? ?? 0,
      name: (json['name'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      mobile: json['mobile'] as String?,
    );
  }

  final int id;
  final String name;
  final String email;
  final String? mobile;

  @override
  List<Object?> get props => [id, name, email, mobile];
}

class StoreAddress extends Equatable {
  const StoreAddress({
    required this.id,
    required this.name,
    required this.mobile,
    required this.address,
    required this.addressLine1,
    required this.zip,
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
    required this.note,
  });

  factory StoreAddress.fromJson(Map<String, dynamic> json) {
    return StoreAddress(
      id: json['id'] as int? ?? 0,
      name: (json['name'] as String?) ?? '',
      mobile: (json['mobile'] as String?) ?? '',
      address: (json['address'] as String?) ?? '',
      addressLine1: json['address_line_1'] as String?,
      zip: json['zip'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      formattedAddress: (json['formatted_address'] as String?) ?? '',
      note: json['note'] as String?,
    );
  }

  final int id;
  final String name;
  final String mobile;
  final String address;
  final String? addressLine1;
  final String? zip;
  final double? latitude;
  final double? longitude;
  final String formattedAddress;
  final String? note;

  @override
  List<Object?> get props => [
    id,
    name,
    mobile,
    address,
    addressLine1,
    zip,
    latitude,
    longitude,
    formattedAddress,
    note,
  ];
}

class AddressSuggestion extends Equatable {
  const AddressSuggestion({
    required this.placeId,
    required this.description,
    required this.primaryText,
    required this.secondaryText,
  });

  factory AddressSuggestion.fromJson(Map<String, dynamic> json) {
    final formatting =
        json['structured_formatting'] as Map<String, dynamic>? ??
        const <String, dynamic>{};

    return AddressSuggestion(
      placeId: (json['place_id'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      primaryText: (formatting['main_text'] as String?) ?? '',
      secondaryText: (formatting['secondary_text'] as String?) ?? '',
    );
  }

  final String placeId;
  final String description;
  final String primaryText;
  final String secondaryText;

  @override
  List<Object?> get props => [placeId, description, primaryText, secondaryText];
}

class AddressPlaceDetails extends Equatable {
  const AddressPlaceDetails({
    required this.placeId,
    required this.name,
    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
  });

  factory AddressPlaceDetails.fromJson(
    String placeId,
    Map<String, dynamic> json,
  ) {
    final geometry =
        json['geometry'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    final location =
        geometry['location'] as Map<String, dynamic>? ??
        const <String, dynamic>{};

    return AddressPlaceDetails(
      placeId: placeId,
      name: (json['name'] as String?) ?? '',
      formattedAddress: (json['formatted_address'] as String?) ?? '',
      latitude: (location['lat'] as num?)?.toDouble() ?? 0,
      longitude: (location['lng'] as num?)?.toDouble() ?? 0,
    );
  }

  final String placeId;
  final String name;
  final String formattedAddress;
  final double latitude;
  final double longitude;

  AddressPlaceDetails copyWith({
    String? placeId,
    String? name,
    String? formattedAddress,
    double? latitude,
    double? longitude,
  }) {
    return AddressPlaceDetails(
      placeId: placeId ?? this.placeId,
      name: name ?? this.name,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [
    placeId,
    name,
    formattedAddress,
    latitude,
    longitude,
  ];
}

class PaymentMethodOption extends Equatable {
  const PaymentMethodOption({
    required this.code,
    required this.name,
    required this.enabled,
    required this.publishableKey,
  });

  factory PaymentMethodOption.fromJson(Map<String, dynamic> json) {
    return PaymentMethodOption(
      code: (json['code'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      enabled: json['enabled'] as bool? ?? false,
      publishableKey: json['publishable_key'] as String?,
    );
  }

  final String code;
  final String name;
  final bool enabled;
  final String? publishableKey;

  @override
  List<Object?> get props => [code, name, enabled, publishableKey];
}

class CheckoutSummary extends Equatable {
  const CheckoutSummary({
    required this.items,
    required this.addresses,
    required this.totals,
    required this.paymentMethods,
    required this.currencySymbol,
    required this.hasStockIssues,
  });

  factory CheckoutSummary.fromJson(Map<String, dynamic> json) {
    final data =
        json['data'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    final currency =
        data['currency'] as Map<String, dynamic>? ?? const <String, dynamic>{};

    return CheckoutSummary(
      items: ((data['items'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(CartItem.fromJson)
          .toList(),
      addresses: ((data['addresses'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(StoreAddress.fromJson)
          .toList(),
      totals: PriceSummary.fromJson(
        data['totals'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      ),
      paymentMethods: ((data['payment_methods'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(PaymentMethodOption.fromJson)
          .toList(),
      currencySymbol: (currency['symbol'] as String?) ?? '\$',
      hasStockIssues: data['has_stock_issues'] as bool? ?? false,
    );
  }

  final List<CartItem> items;
  final List<StoreAddress> addresses;
  final PriceSummary totals;
  final List<PaymentMethodOption> paymentMethods;
  final String currencySymbol;
  final bool hasStockIssues;

  @override
  List<Object?> get props => [
    items,
    addresses,
    totals,
    paymentMethods,
    currencySymbol,
    hasStockIssues,
  ];
}

class StripePaymentIntentData extends Equatable {
  const StripePaymentIntentData({
    required this.paymentIntentId,
    required this.clientSecret,
    required this.publishableKey,
    required this.amount,
    required this.currency,
  });

  factory StripePaymentIntentData.fromJson(Map<String, dynamic> json) {
    final data =
        json['data'] as Map<String, dynamic>? ?? const <String, dynamic>{};

    return StripePaymentIntentData(
      paymentIntentId: (data['payment_intent_id'] as String?) ?? '',
      clientSecret: (data['client_secret'] as String?) ?? '',
      publishableKey: (data['publishable_key'] as String?) ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0,
      currency: (data['currency'] as String?) ?? '',
    );
  }

  final String paymentIntentId;
  final String clientSecret;
  final String publishableKey;
  final double amount;
  final String currency;

  @override
  List<Object?> get props => [
    paymentIntentId,
    clientSecret,
    publishableKey,
    amount,
    currency,
  ];
}

class StoreOrder extends Equatable {
  const StoreOrder({
    required this.id,
    required this.reference,
    required this.subtotal,
    required this.discount,
    required this.shippingRate,
    required this.vat,
    required this.handlingFee,
    required this.total,
    required this.paid,
    required this.note,
    required this.statusName,
    required this.statusColor,
    required this.paymentTypeName,
    required this.items,
    required this.address,
    required this.orderAt,
    required this.createdAt,
  });

  factory StoreOrder.fromJson(Map<String, dynamic> json) {
    final status = json['status'] as Map<String, dynamic>?;
    final paymentType = json['payment_type'] as Map<String, dynamic>?;

    return StoreOrder(
      id: (json['id'] as String?) ?? '',
      reference: (json['reference'] as String?) ?? '',
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      shippingRate: (json['shipping_rate'] as num?)?.toDouble() ?? 0,
      vat: (json['vat'] as num?)?.toDouble() ?? 0,
      handlingFee: (json['handling_fee'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      paid: (json['paid'] as num?)?.toDouble() ?? 0,
      note: json['note'] as String?,
      statusName: status?['name'] as String?,
      statusColor: status?['color'] as String?,
      paymentTypeName: paymentType?['name'] as String?,
      items: ((json['items'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(StoreOrderItem.fromJson)
          .toList(),
      address: json['address'] is Map<String, dynamic>
          ? StoreAddress.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      orderAt: json['order_at'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  final String id;
  final String reference;
  final double subtotal;
  final double discount;
  final double shippingRate;
  final double vat;
  final double handlingFee;
  final double total;
  final double paid;
  final String? note;
  final String? statusName;
  final String? statusColor;
  final String? paymentTypeName;
  final List<StoreOrderItem> items;
  final StoreAddress? address;
  final String? orderAt;
  final String? createdAt;

  @override
  List<Object?> get props => [
    id,
    reference,
    subtotal,
    discount,
    shippingRate,
    vat,
    handlingFee,
    total,
    paid,
    note,
    statusName,
    statusColor,
    paymentTypeName,
    items,
    address,
    orderAt,
    createdAt,
  ];
}

class StoreOrderItem extends Equatable {
  const StoreOrderItem({
    required this.id,
    required this.qty,
    required this.price,
    required this.total,
    required this.product,
  });

  factory StoreOrderItem.fromJson(Map<String, dynamic> json) {
    return StoreOrderItem(
      id: (json['id'] as String?) ?? '',
      qty: (json['qty'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      product: StoreProduct.fromJson(
        json['variant'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      ),
    );
  }

  final String id;
  final int qty;
  final double price;
  final double total;
  final StoreProduct product;

  @override
  List<Object?> get props => [id, qty, price, total, product];
}
