const int RTS_PIN = 6;
const int CTS_PIN = 7;
unsigned long lastActivity = 0;
bool handshakeActivo = false;

void setup() {
  Serial.begin(9600);      // USB
  Serial1.begin(9600);     // UART fpga

  pinMode(RTS_PIN, OUTPUT);
  pinMode(CTS_PIN, INPUT);

  Serial.println("Byte binario: ");
}

void loop() {
  if (Serial.available()) {
    String entrada = Serial.readStringUntil('\n');
    byte dato = (byte) strtol(entrada.c_str(), nullptr, 2);

    iniciarHandshake();
    Serial1.write(dato);

    Serial.print("Enviado a FPGA: ");
    Serial.println(dato, BIN);
    lastActivity = millis();
  }

  // Si llega una respuesta desde la FPGA
  if (Serial1.available()) {
    byte recibido = Serial1.read();
    Serial.print("Recibido de FPGA: ");
    Serial.println(recibido, BIN);
    lastActivity = millis();
  }

  // Si pasó el tiempo sin comunicación, cerrar handshake
  if (handshakeActivo && millis() - lastActivity > 3000) {
    digitalWrite(RTS_PIN, LOW);
    Serial.println("Sin respuesta. Handshake cerrado.");
    handshakeActivo = false;
  }

  delay(100);
}

void iniciarHandshake() {
  digitalWrite(RTS_PIN, HIGH);
  Serial.println("Iniciando handshake...");

  while (!digitalRead(CTS_PIN)) {
    // Espera hasta que la FPGA indique disponibilidad
  }

  Serial.println("Handshake completado.");
  handshakeActivo = true;
}
