from firebase_admin import firestore
import firebase_admin
from datetime import datetime
from google.cloud.firestore_v1.base_query import FieldFilter

def save_user_profile(uid, name, role, assigned_area):
    """
    회원가입 후 사용자의 추가 정보를 Firestore에 저장하는 함수
    """
    try:
        db = firestore.client()
        user_ref = db.collection('users').document(uid)
        user_ref.set({
            'name': name,
            'role': role,
            'assigned_area': assigned_area,
            'timestamp': firestore.SERVER_TIMESTAMP
        })
        print(f"사용자 프로필 저장 성공: {uid}")
    except Exception as e:
        print(f"사용자 프로필 저장 실패: {e}")

def save_fire_incident(location, is_fire, timestamp):
    """
    화재 감지 데이터를 기록합니다.
    """
    try:
        db = firestore.client()
        doc_ref = db.collection('fire_incidents').document()
        doc_ref.set({
            'location': location,
            'is_fire': is_fire,
            'timestamp': timestamp
        })
        print(f"화재 감지 데이터 저장 성공: {location}")
        return True
    except Exception as e:
        print(f"화재 감지 데이터 저장 실패: {e}")
        return False

def save_ai_detection(location, detection_type, confidence_score, timestamp):
    """
    AI가 감지한 화재/연기 데이터를 Firestore에 저장하는 함수
    """
    try:
        db = firestore.client()
        doc_ref = db.collection('ai_detections').document()
        doc_ref.set({
            'location': location,
            'detection_type': detection_type,
            'confidence_score': confidence_score,
            'timestamp': timestamp
        })
        print(f"AI 감지 데이터 저장 성공: {location}에서 {detection_type} 감지")
        return True
    except Exception as e:
        print(f"AI 감지 데이터 저장 실패: {e}")
        return False

def get_fire_incidents_by_date(date_str):
    """
    특정 날짜의 모든 화재 감지 데이터를 조회하는 함수
    """
    try:
        db = firestore.client()
        start_date = datetime.strptime(date_str, '%Y-%m-%d')
        end_date = start_date.replace(hour=23, minute=59, second=59)

        docs = db.collection('fire_incidents').where(
            filter=FieldFilter('timestamp', '>=', start_date)
        ).where(
            filter=FieldFilter('timestamp', '<=', end_date)
        ).stream()

        incidents = []
        for doc in docs:
            incident = doc.to_dict()
            incidents.append(incident)
        
        print(f"조회 성공: {date_str}에 {len(incidents)}건의 화재 데이터가 발견되었습니다.")
        return incidents

    except Exception as e:
        print(f"조회 실패: {e}")
        return None