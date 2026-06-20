class RealtimeClient {
  const RealtimeClient();

  Stream<String> watchDemoEvents() async* {
    yield 'realtime-not-configured';
  }
}

