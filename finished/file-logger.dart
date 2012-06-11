#library('file-logger');
#import('dart:isolate');
#import('dart:io');
#import('utils.dart');

startLogging() {
  print('started logger');
  File logFile;
  OutputStream out;
  port.receive((msg, replyTo) {
    print('received $msg');
    if (logFile == null) {
      logFile = new File(msg);
      out = logFile.openOutputStream(FileMode.APPEND);
    } else {
      time('writeString', () {
        out.writeString("${new Date.now()} : $msg\n");
      });
    }
  });
}

SendPort _loggingPort;

void log(String message) {
  _loggingPort.send(message);
}

void initLogging(String logFileName) {
  _loggingPort = spawnFunction(startLogging);
  _loggingPort.send(logFileName);
}