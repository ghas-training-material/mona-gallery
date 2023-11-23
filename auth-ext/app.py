import base64
import os

from flask import Flask, g, redirect, request, abort, session, url_for
from flask_cors import CORS

import requests
import jwt
from datetime import datetime, timedelta, timezone


from dotenv import load_dotenv
load_dotenv()

app = Flask(__name__)
CORS(app)

CLIENT_ID = os.getenv("OIDC_CLIENT_ID")
CLIENT_SECRET = os.getenv("OIDC_CLIENT_SECRET")
OIDC_ISSUER = os.getenv("OIDC_ISSUER")

def get_access_token(code):
    app.logger.debug('Requesting access token')
    credentials = base64.standard_b64encode(
        f'{CLIENT_ID}:{CLIENT_SECRET}'.encode('ascii')
    ).decode('ascii')
    r = requests.post(f'{OIDC_ISSUER}oauth/token', data={
        'code': code,
        'grant_type': 'authorization_code',
        'redirect_uri': 'http://localhost:5173/login/callback', #change back to 8080
    }, headers={
        'Authorization': f'Basic {credentials}',
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
    })

    app.logger.debug('Received response %s with status %d', r.json(), r.status_code)
    data = r.json()

    if 'error' in data:
        return (None, data['error_description'])

    # return ({'access_token': data['access_token'], 'scope': data['scope'], 'token_type': data['token_type']}, None)
    return (data, None)

def get_user_profile(access_token):
    app.logger.debug('Request user profile')
    r = requests.get(f'{OIDC_ISSUER}userinfo', headers={
        'Authorization': f'Bearer {access_token}'
    })

    app.logger.debug('Received response %s with status %d', r.json(), r.status_code)
    data = r.json()

    if 'error' in data:
        return (None, data['error_description'])
    
    return (data, None)

@app.route("/authenticate/<code>")
def authenticate(code):
    app.logger.debug("Received authentication request with code: %s", code)
    access_info, error = get_access_token(code)

    if error:
        return {'error': error}

    profile, error = get_user_profile(access_info['access_token'])
    if error:
        return {'error': error}
    
    claimset = {
        'iss': "OctoGallery",
        'iat': int(datetime.now(timezone.utc).timestamp()),
        'exp': int((datetime.now(timezone.utc) + timedelta(days=1)).timestamp()),
        'profile': {k:v for k, v in profile.items() if k in ['login', 'name', 'email']}
    }
    app.logger.debug("Created claimset: %s", claimset)

    token = jwt.encode(claimset, 'secretsecret1234secretsecret1234', algorithm='HS256')

    return {'token': token.decode()}

if __name__ == "__main__":
    app.run(
        host=os.environ.get("BACKEND_HOST", "127.0.0.1"),
        port=5000,
        debug=True
    )