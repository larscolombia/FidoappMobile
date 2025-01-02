//import 'package:pusher_client/pusher_client.dart';
/** 
class PusherService {
  // Singleton instance
  static final PusherService _instance = PusherService._internal();

  late PusherClient pusher;
  late Channel channel;

  // Factory constructor
  factory PusherService() {
    return _instance;
  }

  // Internal constructor
  PusherService._internal() {
    // Configuración de Pusher
    pusher = PusherClient(
      "6355b6b280949db284c4", // Tu App Key
      PusherOptions(
        cluster: "us2", // Tu Cluster
        encrypted: true,
        host: "127.0.0.1", // Configura tu host
        wsPort: 6001, // Puerto de Laravel WebSockets
        //useTLS: false, // Cambia a true si usas SSL
      ),
      enableLogging: true,
    );

    // Conectar a Pusher
    pusher.connect();
    _bindPusherEvents();
  }

  void _bindPusherEvents() {
    // Escuchar eventos de conexión
    pusher.onConnectionStateChange((state) {
      print("Estado de conexión: ${state?.currentState}");
    });

    // Manejar errores de conexión
    pusher.onConnectionError((error) {
      print("Error de conexión: ${error?.message}");
    });
  }

  void subscribeToChannel(String channelName) {
    // Suscribirse al canal
    channel = pusher.subscribe(channelName);
    print("Canal suscrito: $channelName");
    // Escuchar eventos
    channel.bind("my-event", (PusherEvent? event) {
      if (event != null) {
        print("Evento recibido: ${event.data}");
        // Manejar datos del evento aquí
      }
    });
  }

  void unsubscribeFromChannel(String channelName) {
    // Cancelar la suscripción al canal
    pusher.unsubscribe(channelName);
  }

  void disconnect() {
    // Desconectar de Pusher
    pusher.disconnect();
  }
}
*/