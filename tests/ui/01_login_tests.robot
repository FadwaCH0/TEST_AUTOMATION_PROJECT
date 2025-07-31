*** Settings ***
Documentation     Authentication tests for the Todo application
Resource          ../resources/keywords.robot


*** Test Cases ***
Login Page Should Display Correctly
    [Documentation]    Verify that the login page displays correctly
    [Tags]    ui    login    smoke
    Setup Browser
    Ensure On Login Page
    Page Should Contain Element    css:[data-testid="login-form"]
    Page Should Contain Element    css:[data-testid="username-input"]
    Page Should Contain Element    css:[data-testid="password-input"]
    Page Should Contain Element    css:[data-testid="login-button"]
    Page Should Contain    Todo App Login
    Teardown Browser

Login With Valid Credentials Should Succeed
    [Documentation]    Login with valid credentials
    [Tags]    ui    login    positive
    Setup Browser
    Ensure On Login Page
    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Wait Until Location Contains    /todos    30s
    Page Should Contain    Welcome, ${VALID_USERNAME}
    Page Should Contain Element    css:[data-testid="logout-button"]
    Teardown Browser

Login With Invalid Username Should Fail
    [Documentation]    Login with an invalid username
    [Tags]    ui    login    negative
    Setup Browser
    Ensure On Login Page
    Login With Credentials    ${INVALID_USERNAME}    ${VALID_PASSWORD}
    Sleep    2s
    Wait Until Location Contains    /login    30s
    Verify Error Message    Invalid credentials
    Teardown Browser


Login With Invalid Password Should Fail
    [Documentation]    Login with an invalid password
    [Tags]    ui    login    negative
    Setup Browser
    Ensure On Login Page
    Login With Credentials    ${VALID_USERNAME}    ${INVALID_PASSWORD}
    # Wait a little for the error to appear
    Sleep    2s
    Location Should Contain    /login
    Verify Error Message    Invalid credentials
    Teardown Browser


Login With Empty Credentials Should Fail
    [Documentation]    Login with empty fields
    [Tags]    ui    login    negative
    Setup Browser
    Ensure On Login Page   
    Click Button    css:[data-testid="login-button"]
    ${username_validity}=    Execute Javascript    return document.querySelector('[data-testid="username-input"]').checkValidity()
    Should Be Equal    ${username_validity}    ${False}
    Teardown Browser

Logout Should Work Correctly
    [Documentation]    Logout from the application
    [Tags]    ui    login    logout
    Setup Browser
    Ensure On Login Page  
    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Logout User
    Location Should Contain    /login
    Page Should Contain Element    css:[data-testid="login-form"]
    Teardown Browser

Authenticated User Should Redirect From Login Page
    [Documentation]    A logged-in user should be redirected away from the login page
    [Tags]    ui    navigation
    Setup Browser
    Ensure On Login Page
    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Wait Until Location Contains    /todos    30s
    Go To    ${LOGIN_URL}
    Wait Until Location Contains    /todos    30s
    Location Should Contain    /todos
    Teardown Browser
