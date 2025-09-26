#include <WiFi.h>
#include <HTTPClient.h>
#include "secrets.h.ino" // Wi-Fi 정보가 담긴 파일
#include <time.h>        // 날짜 및 시간 라이브러리 추가

const int dustLED = 14;     
const int dustSensor = 34; 
// ESP32 GPIO 34는 ADC1 채널 6입니다.

// GP2Y10 측정 관련 상수 (데이터 시트 권장)
const int GP2Y10_SAMPLING_TIME = 280; // μs: LED 켜고 대기 시간
const int GP2Y10_MEASURE_TIME = 40;   // μs: 측정 후 대기 시간 (총 320μs 펄스)
const int GP2Y10_SLEEP_TIME = 9680;  // μs: 다음 측정까지 LED 끄고 대기 시간 (총 10ms 주기)

// secrets.h 파일에서 Wi-Fi 정보를 가져옴
const char* ssid = SECRET_SSID;     
const char* password = SECRET_PASSWORD;

// NTP 서버 및 시간대 설정
const char* ntpServer = "pool.ntp.org";
const long  gmtOffset_sec = 9 * 3600; 
const int   daylightOffset_sec = 0;

void setup() {
  Serial.begin(115200);
  Serial.println("GP2Y10 미세먼지 센서 테스트");
  
  pinMode(dustLED, OUTPUT);
  digitalWrite(dustLED, HIGH); // 초기에는 LED 끄기 (Active HIGH)
  delay(50);

  // 와이파이 연결 시작
  WiFi.begin(ssid, password);
  Serial.println("와이파이 연결 중...");
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }
  Serial.println("\n와이파이 연결 성공!");
  Serial.print("IP 주소: ");
  Serial.println(WiFi.localIP());

  // NTP 서버를 통해 시간 동기화
  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);
  Serial.println("NTP 서버와 시간 동기화 완료.");
}

/**
 * GP2Y10 센서의 LED 펄스 타이밍을 정확히 구현하여 전압을 측정합니다.
 * @return 측정된 전압 값 (float)
 */
float readDustSensorAndReturnVoltage() {
  // 1. LED 펄스 시퀀스 시작 (Active LOW)
  digitalWrite(dustLED, LOW); 
  delayMicroseconds(GP2Y10_SAMPLING_TIME); // LED 켜고 280μs 대기 (안정화)

  // 2. ADC 값 읽기 (12-bit, 0~4095)
  int raw = analogRead(dustSensor); 

  delayMicroseconds(GP2Y10_MEASURE_TIME); // 측정 후 40μs 대기
  
  // 3. LED 끄기 (Active HIGH)
  digitalWrite(dustLED, HIGH); 
  delayMicroseconds(GP2Y10_SLEEP_TIME); // 9680μs 대기 (총 10ms 주기)

  // 4. RAW -> Voltage 변환 (ESP32: 3.3V, 4095)
  float voltage = raw * (3.3 / 4095.0);

  Serial.print("먼지 센서 전압: ");
  Serial.print(voltage, 3);
  Serial.println(" V");

  return voltage;
}


void loop() {
  // 1. 먼지 센서 전압 측정 (안정화된 LED 펄스 로직 포함)
  float measuredVoltage = readDustSensorAndReturnVoltage(); // 전압 값 저장

  // 2. 현재 날짜 및 시간 가져오기 (시리얼 출력용)
  struct tm timeinfo;
  if (getLocalTime(&timeinfo)) {
    char timeString[20];
    strftime(timeString, sizeof(timeString), "%Y-%m-%d %H:%M:%S", &timeinfo);
    Serial.print("현재 시간: ");
    Serial.println(timeString);
  } else {
    Serial.println("시간을 가져오는 데 실패했습니다.");
  }


  // 3. 와이파이가 연결되었을 때만 데이터 전송
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    // TODO: 백엔드 API 엔드포인트 URL로 변경해야 합니다.
    http.begin("http://your_backend_server_address/api/dust"); 
    http.addHeader("Content-Type", "application/json");

    // JSON 페이로드: dust_voltage를 float(소수점 3자리)로 전송하여 데이터 손실 방지
    String jsonPayload = "{\"device_type\":\"Dust sensor\",\"dust_voltage\":" + String(measuredVoltage, 3) + ",\"status\":\"fire\"}";
    
    // HTTP POST 요청 보내기
    int httpCode = http.POST(jsonPayload);
    
    if (httpCode > 0) {
      String response = http.getString();
      Serial.printf("[HTTP] POST 요청 성공, 응답 코드: %d\n", httpCode);
      Serial.println(response);
    } else {
      // httpCode가 음수이면 연결 오류, -11이면 연결 시간 초과 등 상세 에러 메시지 출력
      Serial.printf("[HTTP] POST 요청 실패, 응답 코드: %d, 에러: %s\n", httpCode, http.errorToString(httpCode).c_str());
    }
    http.end(); 
  } else {
    Serial.println("와이파이 연결이 끊어졌습니다. 재연결을 시도합니다.");
    WiFi.reconnect();
  }

  // 4. 다음 측정까지 대기
  delay(2000); 
}