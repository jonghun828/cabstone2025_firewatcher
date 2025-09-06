# main.py
# 목적: 애플리케이션 메인 진입점 및 기능 테스트 실행
# 이 파일은 각 서비스 모듈을 통합하여 실행합니다.

import firebase_admin
from firebase_admin import credentials
from auth_service import create_user_with_email, login_with_email
from database_service import save_user_profile, save_fire_incident, get_fire_incidents_by_date, save_ai_detection
from datetime import datetime
import os

# 1. Firebase 애플리케이션 초기화
# 서버 시작 시 한 번만 실행되는 부분입니다.
try:
    cred = credentials.Certificate('wgwfefwff-firebase-adminsdk-fbsvc-894136897f.json')
    firebase_admin.initialize_app(cred, {
        'projectId': 'wgwfefwff'
    })
except Exception as e:
    print(f"[MAIN] Firebase 연결 중 오류 발생: {e}")
    exit()

# 2. 애플리케이션 메인 실행
if __name__ == "__main__":
    print("--------------------------------------------------")
    print("애플리케이션 기능 테스트 시작")

    # [테스트 1: 사용자 인증 및 프로필 저장]
    # 새로운 사용자 생성 및 프로필 데이터 저장 시도
    print("\n[테스트 1] 회원가입 및 프로필 저장 기능")
    test_email = "final_test_run@example.com"
    test_password = "password123!"

    user_uid = create_user_with_email(test_email, test_password)
    
    if user_uid:
        save_user_profile(user_uid, "통합관리자", "총괄관리", "전체 구역")
    
    # [테스트 2: 화재 감지 데이터 저장]
    # 화재 감지 데이터를 데이터베이스에 기록
    print("\n[테스트 2] 화재 감지 데이터 저장")
    save_fire_incident("구역 A", True, firebase_admin.firestore.SERVER_TIMESTAMP)

    # [테스트 3: AI 감지 데이터 저장]
    # AI가 연기를 감지했다고 가정하고 함수를 호출합니다.
    print("\n[테스트 3] AI 감지 데이터 저장")
    save_ai_detection("구역 C", "smoke", 0.95, firebase_admin.firestore.SERVER_TIMESTAMP)

    # [테스트 4: 데이터 조회]
    # 오늘 날짜의 화재 데이터를 조회
    print("\n[테스트 4] 화재 데이터 조회")
    today_date = datetime.now().strftime('%Y-%m-%d')
    incidents = get_fire_incidents_by_date(today_date)
    
    if incidents:
        print("    - 조회된 데이터 목록:")
        for incident in incidents:
            print(f"      - {incident}")

    print("\n--------------------------------------------------")
    print("[MAIN] 모든 기능 테스트 완료")
    print("--------------------------------------------------")