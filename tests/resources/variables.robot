*** Variables ***
# URLs
${BASE_URL}           http://localhost:5173
${API_BASE_URL}       http://localhost:5000/api
${BACKEND_URL}        http://localhost:5000
${LOGIN_URL}          ${BASE_URL}/login
${TODOS_URL}          ${BASE_URL}/todos

# Test Data
${VALID_USERNAME}     testuser
${VALID_PASSWORD}     password
${INVALID_USERNAME}   wronguser
${INVALID_PASSWORD}   wrongpassword

# Timeouts
${SHORT_TIMEOUT}      5s
${MEDIUM_TIMEOUT}     10s
${LONG_TIMEOUT}       30s

# Browser Settings
${BROWSER}            Chrome
${HEADLESS}           False