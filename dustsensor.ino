#include <WiFi.h>
#include <HTTPClient.h>
#include "secrets.h" 
#include <time.h>        

const int dustLED = 14;     
const int dustSensor = 34; 

// GP2Y10 측정 관련 상수 
const int GP2Y10_SAMPLING_TIME = 280; 
const int GP2Y10_MEASURE_TIME = 40;   
const int GP2Y10_SLEEP_TIME = 9680;   

// NTP 서버 및 시간대 설정
const char* ntpServer = "pool.ntp.org";
const long  gmtOffset_sec = 9 * 3600; 
const int   daylightOffset_sec = 0;

void setup() {
  Serial.begin(115200);
  Serial.println("GP2Y10 미세먼지 센서 테스트");
  
  pinMode(dustLED, OUTPUT);
  digitalWrite(dustLED, LOW); 
  delay(50);

  // 와이파이 연결 시작
  WiFi.begin(SECRET_SSID, SECRET_PASSWORD);
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
  // 1. LED 펄스 시퀀스 시작 (액티브 하이로 변경)
  digitalWrite(dustLED, HIGH); 
  delayMicroseconds(GP2Y10_SAMPLING_TIME); 

  // 2. ADC 값 읽기 (12-bit, 0~4095)
  int raw = analogRead(dustSensor); 

  delayMicroseconds(GP2Y10_MEASURE_TIME); 
  
  // 3. LED 끄기 (액티브 로우로 변경)
  digitalWrite(dustLED, LOW); 
  delayMicroseconds(GP2Y10_SLEEP_TIME); 

  // 4. RAW -> Voltage 변환 (ESP32: 3.3V, 4095)
  float voltage = raw * (3.3 / 4095.0);

  Serial.print("먼지 센서 전압: ");
  Serial.print(voltage, 3);
  Serial.println(" V");

  return voltage;
}

void loop() {
  // 1. 먼지 센서 전압 측정 (안정화된 LED 펄스 로직 포함)
  float measuredVoltage = readDustSensorAndReturnVoltage(); 

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

  // 3. 와이파이 연결 상태 확인 및 데이터 전송
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    // URL을 직접 여기에 입력합니다.
    http.begin("http://여기에_백엔드_서버_IP_주소_및_경로를_입력하세요/api/dust"); 
    http.addHeader("Content-Type", "application/json");

    // JSON 페이로드
    String jsonPayload = "{\"device_type\":\"Dust sensor\",\"dust_voltage\":" + String(measuredVoltage, 3) + ",\"status\":\"fire\"}";
    
    // HTTP POST 요청 보내기
    int httpCode = http.POST(jsonPayload);
    
    if (httpCode > 0) {
      String response = http.getString();
      Serial.printf("[HTTP] POST 요청 성공, 응답 코드: %d\n", httpCode);
      Serial.println(response);
    } else {
      // httpCode가 음수이면 연결 오류 등 상세 에러 메시지 출력
      Serial.printf("[HTTP] POST 요청 실패, 응답 코드: %d, 에러: %s\n", httpCode, http.errorToString(httpCode).c_str());
    }
    http.end(); 
  } else {
    Serial.println("와이파이 연결이 끊어졌습니다. 재연결을 시도합니다.");
    WiFi.reconnect();
  }

  delay(2000); 
}
