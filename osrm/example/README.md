# Examples
for simple use:
```dart
import 'package:osrm/osrm.dart';

void main() async {
  final osrm = Osrm();

  final options =  RouteRequest(
    coordinates: [
      (2.829099,36.479960),
      (2.825987,36.473662),
    ],
  );

  final route = await osrm.route(options);
  
  print(route);
}
```

### here you can find another example with dart:
[example.dart](https://github.com/physia/kflutter/blob/main/osrm/example/osrm_dart_example/osrm_dart_example.dart)

### here you can find another example with flutter:
[flutter map example](https://github.com/physia/kflutter/tree/main/osrm/example/osrm_flutter_map_example)
<p align="center">
  <img width="1026" alt="image" src="https://github.com/edumeet/edumeet-ansible/assets/22839194/9b092913-ddb3-4ded-b35e-ffdf51bba5ea">
</p>
