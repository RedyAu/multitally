import 'dart:convert';
import 'dart:io';
import 'dart:async';

class FConnection {
  InternetAddress address;
  int port;
  RawDatagramSocket? socket;
  int sequenceNumber = 0;
  bool connected = false;

  FConnection(this.address, this.port);

  Future<void> connect() async {
    socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

    // send a connect command and verify that the data fields are the same as sent
    var resp = (await get(FMessage(sequenceNumber++, FCommand.connect.c,
        FCommand.connect.sub['connect']!, '00', '00', '00')))[0];
    if (!(resp is FMessage)) {
      throw Exception('Invalid response');
    }
    if (resp.sequenceNumber != sequenceNumber - 1) {
      throw Exception('Invalid sequence number');
    }
    print('Connected: ${resp.m}');
    return;
  }

  Future<List<int>> getRawState() async {
    List<int> resp = (await get(
        FMessage(sequenceNumber++, FCommand.status.c,
            FCommand.status.sub['selected']!, '01', '00', '00'),
        2))[1];
    return [resp[0], resp[2]];
  }

  Future<List> get(FMessage message, [int amount = 1]) async {
    if (socket == null) {
      socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    }
    List messages = [];
    var completer = Completer<List>();

    socket!.listen((event) {
      if (event == RawSocketEvent.read) {
        Datagram? dg = socket!.receive();
        try {
          messages.add(FMessage.from(dg?.data ?? []));
        } catch (e) {
          messages.add(dg?.data);
        }
        if (messages.length == amount) {
          completer.complete(messages);
          socket!.close();
          socket = null;
        }
      }
    });
    socket!.send(ascii.encode(message.m), address, port);

    Future.delayed(Duration(seconds: 3), () {
      if (!completer.isCompleted) {
        socket!.close();
        socket = null;
        completer.completeError(Exception('Connection timed out in 3 seconds'));
      }
    });

    return completer.future;
  }
}

class FMessage {
  bool transmit = true;
  bool read;
  int address = 0;
  int sequenceNumber;
  late int command;
  late int dat1;
  late int dat2;
  late int dat3;
  late int dat4;

  FMessage(this.sequenceNumber, String command, String dat1, String dat2,
      String dat3, String dat4,
      {this.read = false}) {
    this.command = int.parse(command, radix: 16);
    this.dat1 = int.parse(dat1, radix: 16);
    this.dat2 = int.parse(dat2, radix: 16);
    this.dat3 = int.parse(dat3, radix: 16);
    this.dat4 = int.parse(dat4, radix: 16);
  }
  String p(int i) {
    String s = (i & 0xff).toRadixString(16);
    if (s.length == 1) {
      return '0$s';
    }
    return s;
  }

  int get sum => address + sequenceNumber + command + dat1 + dat2 + dat3 + dat4;

  String get m {
    if (read) {
      dat1 |= 1;
    }

    return '<${transmit ? 'T' : 'F'}${p(address)}${p(sequenceNumber)}${p(command)}${p(dat1)}${p(dat2)}${p(dat3)}${p(dat4)}${p(sum)}>';
  }

  factory FMessage.from(List<int> raw) {
    String message = ascii.decode(raw);
    if (!(message.startsWith('<') &&
        message.endsWith('>') &&
        message.length == 19)) {
      throw Exception('Invalid message format');
    }
    var transmit = false;
    if (message.startsWith('<T')) {
      transmit = true;
    }
    return FMessage(
        int.parse(message.substring(3, 5), radix: 16),
        message.substring(5, 7),
        message.substring(7, 9),
        message.substring(9, 11),
        message.substring(11, 13),
        message.substring(13, 15))
      ..transmit = transmit;
  }
}

enum FCommand {
  connect('68', {
    'connect': '66',
  }),
  video('75', {
    'source': '02',
    'pip': '1E',
  }),
  switching('78', {
    'tbar': '12',
    'transition': '06',
  }),
  status('F1', {
    'selected': '40',
  });

  const FCommand(this.c, this.sub);
  final String c;
  final Map<String, String> sub;
}
