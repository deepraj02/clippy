// enum Flavor {
//   dev,
//   prod,
// }

// Flavor _env = Flavor.dev;

// class Env {
//   static init() async {
//     late final String envPath;
//     switch (_env) {
//       case Flavor.dev:
//         envPath = 'assets/env/dev-secrets.env';
//         break;
//       case Flavor.prod:
//         envPath = 'assets/env/prod-secrets.env';
//         break;
//     }

//     getValue();
//   }

//   static dynamic getValue() {}
// }
