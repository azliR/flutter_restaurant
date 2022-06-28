import 'package:flutter/material.dart';

enum DiscountType {
  fixed,
  percentage;

  factory DiscountType.fromString(String value) {
    switch (value) {
      case 'fixed':
        return DiscountType.fixed;
      case 'percentage':
        return DiscountType.percentage;
      default:
        throw FormatException('Invalid discount type: $value');
    }
  }
}

enum OrderStatus {
  pending,
  preparing,
  ready,
  complete,
  cancelled;

  factory OrderStatus.fromString(String value) {
    switch (value) {
      case 'pending':
        return OrderStatus.pending;
      case 'preparing':
        return OrderStatus.preparing;
      case 'ready':
        return OrderStatus.ready;
      case 'complete':
        return OrderStatus.complete;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        throw FormatException('Invalid order status: $value');
    }
  }

  String toReadableString(BuildContext context) {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.complete:
        return 'Complete';
      case OrderStatus.cancelled:
        return 'Cancelled';
      default:
        throw FormatException('Invalid order status: $this');
    }
  }
}

enum OrderType {
  now,
  scheduled;

  factory OrderType.fromString(String name) {
    switch (name) {
      case 'scheduled':
        return OrderType.scheduled;
      case 'now':
        return OrderType.now;
      default:
        throw FormatException('Invalid order type: $name');
    }
  }

  Color get color {
    switch (this) {
      case OrderType.now:
        return Colors.red;
      case OrderType.scheduled:
        return Colors.blue;
    }
  }

  Icon get icon {
    switch (this) {
      case OrderType.now:
        return const Icon(
          Icons.fast_forward_rounded,
          color: Colors.white,
        );
      case OrderType.scheduled:
        return const Icon(
          Icons.schedule,
          color: Colors.white,
        );
    }
  }

  String toReadableStringTitle(BuildContext context) {
    switch (this) {
      case OrderType.now:
        return 'Now';
      case OrderType.scheduled:
        return 'Scheduled';
    }
  }

  String toReadableStringDesc(BuildContext context, {int? minutes}) {
    switch (this) {
      case OrderType.now:
        return 'Your order will be processed immediately.';
      case OrderType.scheduled:
        if (minutes == null) {
          return 'Your order will be processed at the scheduled time.';
        } else {
          return 'Your order will be processed in $minutes minutes.';
        }
    }
  }
}

enum PickupType {
  pickup,
  dineIn;

  factory PickupType.fromString(String name) {
    switch (name) {
      case 'pickup':
        return PickupType.pickup;
      case 'dine-in':
        return PickupType.dineIn;
      default:
        throw FormatException('Invalid pickup type: $name');
    }
  }

  String get name {
    switch (this) {
      case PickupType.pickup:
        return 'pickup';
      case PickupType.dineIn:
        return 'dine-in';
    }
  }

  Color get color {
    switch (this) {
      case PickupType.pickup:
        return Colors.deepOrange;
      case PickupType.dineIn:
        return Colors.green;
    }
  }

  Icon get icon {
    switch (this) {
      case PickupType.pickup:
        return const Icon(
          Icons.directions_car_rounded,
          color: Colors.white,
        );
      case PickupType.dineIn:
        return const Icon(
          Icons.restaurant,
          color: Colors.white,
        );
    }
  }

  String toReadableStringTitle(BuildContext context) {
    switch (this) {
      case PickupType.pickup:
        return 'Pickup';
      case PickupType.dineIn:
        return 'Dine In';
    }
  }

  String toReadableStringDesc(BuildContext context) {
    switch (this) {
      case PickupType.pickup:
        return 'Pickup your order at the restaurant.';
      case PickupType.dineIn:
        return 'Dine in at the restaurant.';
    }
  }
}

enum StoreRole {
  admin,
  staff;

  factory StoreRole.fromString(String value) {
    switch (value) {
      case 'admin':
        return StoreRole.admin;
      case 'staff':
        return StoreRole.staff;
      default:
        throw FormatException('Invalid store role: $value');
    }
  }
}
