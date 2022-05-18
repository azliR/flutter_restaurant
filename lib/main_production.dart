// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_restaurant/bootstrap.dart';
import 'package:flutter_restaurant/views/core/app.dart';
import 'package:injectable/injectable.dart';

void main() {
  bootstrap(() => App(), Environment.prod);
}
