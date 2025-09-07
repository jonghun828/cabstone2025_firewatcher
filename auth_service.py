# auth_service.py
# 목적: 사용자 계정 인증 및 관리 기능 제공
# 이 파일은 Firebase Authentication 서비스와 직접 통신합니다.

from firebase_admin import auth

def create_user_with_email(email, password):
    """새로운 사용자 계정을 생성합니다."""
    try:
        user = auth.create_user(
            email=email,
            password=password
        )
        print(f"[AUTH] 사용자 생성 성공: {user.uid}")
        return user.uid
    except Exception as e:
        print(f"[AUTH] 사용자 생성 실패: {e}")
        return None

def login_with_email(email, password):
    """입력된 이메일과 비밀번호로 사용자 로그인을 처리합니다."""
    try:
        user = auth.get_user_by_email(email)
        print(f"[AUTH] 로그인 성공: {user.uid}")
        return user
    except Exception as e:
        print(f"[AUTH] 로그인 실패: {e}")
        return None