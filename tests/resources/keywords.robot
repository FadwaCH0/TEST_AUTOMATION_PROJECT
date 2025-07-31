*** Settings ***
Library           SeleniumLibrary
Library           RequestsLibrary
Library           Collections
Library           String
Library           DateTime
Library    Process
Resource          variables.robot

*** Keywords ***
# Setup et Teardown
Setup Browser
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    ${MEDIUM_TIMEOUT}
    Set Selenium Implicit Wait    ${SHORT_TIMEOUT}

Teardown Browser
    Close All Browsers

Setup API Session
    Create Session    api    ${API_BASE_URL}
    Create Session    backend    ${BACKEND_URL}

Login With Credentials
    [Arguments]    ${username}    ${password}
    Go To    ${LOGIN_URL}
    Wait Until Page Contains Element    css:[data-testid="username-input"]    timeout=${MEDIUM_TIMEOUT}
    Input Text    css:[data-testid="username-input"]    ${username}
    Input Text    css:[data-testid="password-input"]    ${password}
    Click Button    css:[data-testid="login-button"]


Logout User
    Wait Until Page Contains Element    css:[data-testid="logout-button"]    timeout=${MEDIUM_TIMEOUT}
    Click Button    css:[data-testid="logout-button"]
    Wait Until Location Contains    /login    timeout=${MEDIUM_TIMEOUT}

Add New Todo
    [Arguments]    ${todo_title}
    Wait Until Page Contains Element    css:[data-testid="new-todo-input"]    timeout=${MEDIUM_TIMEOUT}
    Input Text    css:[data-testid="new-todo-input"]    ${todo_title}
    Click Button    css:[data-testid="add-todo-button"]
    Wait Until Page Contains    ${todo_title}    timeout=${MEDIUM_TIMEOUT}

Edit Todo By Title
    [Arguments]    ${original_title}    ${new_title}
    # Find the todo by its title and click on edit
    ${todo_element}=    Get WebElement    xpath://div[contains(@data-testid, 'todo-item') and contains(., '${original_title}')]
    ${edit_button}=    Get WebElement    xpath://div[contains(@data-testid, 'todo-item') and contains(., '${original_title}')]//button[contains(@data-testid, 'edit-todo-')]
    Click Element    ${edit_button}
    
    # Find the edit field and make changes
    ${edit_input}=    Get WebElement    xpath://div[contains(@data-testid, 'todo-item')]//input[contains(@data-testid, 'edit-todo-input-')]
    Clear Element Text    ${edit_input}
    Input Text    ${edit_input}    ${new_title}
    
    # Save
    ${save_button}=    Get WebElement    xpath://div[contains(@data-testid, 'todo-item')]//button[contains(@data-testid, 'save-todo-')]
    Click Element    ${save_button}
    
    # Wait until the change is visible
    Wait Until Page Contains    ${new_title}    timeout=${MEDIUM_TIMEOUT}

Cancel Edit Todo By Title
    [Arguments]    ${todo_title}    ${temp_title}
    ${edit_button}=    Get WebElement    xpath://div[contains(@data-testid, 'todo-item') and contains(., '${todo_title}')]//button[contains(@data-testid, 'edit-todo-')]
    Click Element    ${edit_button}
    
    ${edit_input}=    Get WebElement    xpath://div[contains(@data-testid, 'todo-item')]//input[contains(@data-testid, 'edit-todo-input-')]
    Clear Element Text    ${edit_input}
    Input Text    ${edit_input}    ${temp_title}
    
    ${cancel_button}=    Get WebElement    xpath://div[contains(@data-testid, 'todo-item')]//button[contains(@data-testid, 'cancel-edit-')]
    Click Element    ${cancel_button}

Delete Todo By Title
    [Arguments]    ${todo_title}
    ${delete_button}=    Get WebElement    xpath://div[contains(@data-testid, 'todo-item') and contains(., '${todo_title}')]//button[contains(@data-testid, 'delete-todo-')]
    Click Element    ${delete_button}
    Handle Alert    ACCEPT
    Wait Until Page Does Not Contain    ${todo_title}    timeout=${MEDIUM_TIMEOUT}

Toggle Todo Completion By Title
    [Arguments]    ${todo_title}
    ${checkbox}=    Get WebElement    xpath://div[contains(@data-testid, 'todo-item') and contains(., '${todo_title}')]//input[@type='checkbox']
    Click Element    ${checkbox}

Verify Todo Exists
    [Arguments]    ${todo_title}
    Wait Until Page Contains    ${todo_title}    timeout=${MEDIUM_TIMEOUT}

Verify Todo Does Not Exist
    [Arguments]    ${todo_title}
    Page Should Not Contain    ${todo_title}

Get Auth Token
    ${login_data}=    Create Dictionary    username=${VALID_USERNAME}    password=${VALID_PASSWORD}
    ${response}=    POST On Session    api    /auth/login    json=${login_data}
    Should Be Equal As Numbers    ${response.status_code}    200
    ${token}=    Get From Dictionary    ${response.json()}    token
    RETURN    ${token}

Create Todo Via API
    [Arguments]    ${title}    ${token}
    &{headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${todo_data}=    Create Dictionary    title=${title}
    ${response}=    POST On Session    api    /todos    json=${todo_data}    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    201
    RETURN    ${response.json()}

Get Todos Via API
    [Arguments]    ${token}
    &{headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    GET On Session    api    /todos    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    200
    RETURN    ${response.json()}

Generate Random Todo Title
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S%f
    ${random_title}=    Set Variable    Test Todo ${timestamp}
    RETURN    ${random_title}

Wait For Page Load
    Wait Until Page Contains Element    css:body    timeout=${MEDIUM_TIMEOUT}
    Sleep    1s   

Verify Error Message
    [Arguments]    ${expected_message}
    Wait Until Page Contains Element    css:[data-testid="error-message"]    timeout=${MEDIUM_TIMEOUT}
    Element Should Contain    css:[data-testid="error-message"]    ${expected_message}


Ensure On Login Page
    ${current_url}=    Get Location
    Run Keyword If    '/login' not in '${current_url}'    Go To    ${LOGIN_URL}
    Wait Until Page Contains Element    css:[data-testid="login-form"]    timeout=${MEDIUM_TIMEOUT}

Ensure On Todos Page
    ${current_url}=    Get Location
    Run Keyword If    '/todos' not in '${current_url}'    Go To    ${TODOS_URL}
    Wait Until Page Contains Element    css:[data-testid="todos-list"]    timeout=${MEDIUM_TIMEOUT}

Wait For Navigation
    [Arguments]    ${expected_path}    ${timeout}=${MEDIUM_TIMEOUT}
    Wait Until Location Contains    ${expected_path}    timeout=${timeout}

Clear All Alerts
    ${alert_present}=    Run Keyword And Return Status    Alert Should Be Present
    Run Keyword If    ${alert_present}    Handle Alert    DISMISS
