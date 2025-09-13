# app.py
# 목적: 애플리케이션의 웹 서버 및 API 엔드포인트 제공
# 이 파일은 Flask를 사용하여 클라이언트(앱)와 통신합니다.

from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import credentials
import os
from auth_service import create_user_with_email, login_with_email
from database_service import save_user_profile, save_fire_incident, get_fire_incidents_by_date, save_ai_detection
from datetime import datetime
from google.cloud.firestore_v1.base_query import FieldFilter

# Firebase 초기화
try:
    cred = credentials.Certificate('wgwfefwff-firebase-adminsdk-fbsvc-894136897f.json')
    firebase_admin.initialize_app(cred, {
        'projectId': 'wgwfefwff'
    })
except Exception as e:
    print(f"[MAIN] Firebase 연결 중 오류 발생: {e}")
    exit()

# Flask 애플리케이션 생성
app = Flask(__name__)

# --- API 엔드포인트 정의 ---
@app.route('/', methods=['GET'])
def home():
    """기본 홈 페이지"""
    return "Hello, Wildfire Watcher API!"

@app.route('/register', methods=['POST'])
def register():
    """회원가입 API: 사용자를 생성하고 프로필을 저장합니다."""
    data = request.json
    email = data.get('email')
    password = data.get('password')
    name = data.get('name')
    role = data.get('role')
    assigned_area = data.get('assigned_area')
    
    if not all([email, password, name, role, assigned_area]):
        return jsonify({"success": False, "message": "Missing user information"}), 400

    user_uid = create_user_with_email(email, password)
    
    if user_uid:
        save_user_profile(user_uid, name, role, assigned_area)
        return jsonify({"success": True, "message": "User registered successfully"}), 201
    else:
        return jsonify({"success": False, "message": "User registration failed"}), 400

@app.route('/login', methods=['POST'])
def login():
    """로그인 API: 사용자 로그인을 처리합니다."""
    data = request.json
    email = data.get('email')
    password = data.get('password')

    if not all([email, password]):
        return jsonify({"success": False, "message": "Missing email or password"}), 400

    user = login_with_email(email, password)
    
    if user:
        return jsonify({"success": True, "message": "Login successful", "user_id": user.uid}), 200
    else:
        return jsonify({"success": False, "message": "Invalid email or password"}), 401

@app.route('/incidents/save', methods=['POST'])
def save_incident():
    """AI 감지 데이터를 저장하는 API"""
    data = request.json
    location = data.get('location')
    is_fire = data.get('is_fire')
    
    if not all([location, is_fire is not None]):
        return jsonify({"success": False, "message": "Missing incident data"}), 400

    success = save_fire_incident(location, is_fire, firebase_admin.firestore.SERVER_TIMESTAMP)

    if success:
        return jsonify({"success": True, "message": "Incident saved successfully"}), 201
    else:
        return jsonify({"success": False, "message": "Failed to save incident"}), 500

@app.route('/incidents/today', methods=['GET'])
def get_today_incidents():
    """오늘 날짜의 화재 감지 데이터를 조회하는 API"""
    today_date = datetime.now().strftime('%Y-%m-%d')
    incidents = get_fire_incidents_by_date(today_date)
    
    if incidents:
        for incident in incidents:
            if 'timestamp' in incident:
                incident['timestamp'] = incident['timestamp'].isoformat()
        return jsonify({"success": True, "incidents": incidents}), 200
    else:
        return jsonify({"success": False, "message": "No incidents found for today"}), 404
    
# --- 애플리케이션 실행 ---
if __name__ == '__main__':
    app.run(debug=True)