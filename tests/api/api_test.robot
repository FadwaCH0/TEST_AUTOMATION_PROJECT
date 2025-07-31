*** Settings ***
Documentation     Tests API pour l'application Todo
Library           RequestsLibrary
Library           Collections
Resource          ../resources/keywords.robot
Suite Setup       Setup API Session
Suite Teardown    Delete All Sessions

*** Variables ***
${API_ENDPOINT}    ${API_BASE_URL}

*** Test Cases ***
Health Check Should Return OK
    [Documentation]    Check that the health endpoint is working.
    [Tags]    api    health    smoke
    ${response}=    GET On Session    api    ../health    expected_status=200
    Should Be Equal As Numbers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    status
    Should Be Equal As Strings    ${response.json()}[status]    OK

Login With Valid Credentials Should Return Token
    [Documentation]    API connection with valid credentials
    [Tags]    api    auth    positive
    ${login_data}=    Create Dictionary    username=${VALID_USERNAME}    password=${VALID_PASSWORD}
    ${response}=    POST On Session    api    /auth/login    json=${login_data}
    Should Be Equal As Numbers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    token
    Dictionary Should Contain Key    ${response.json()}    user
    Should Be Equal As Strings    ${response.json()}[message]    Login successful

Login With Invalid Credentials Should Fail
    [Documentation]    API connection with invalid credentials
    [Tags]    api    auth    negative
    ${login_data}=    Create Dictionary    username=${INVALID_USERNAME}    password=${INVALID_PASSWORD}
    ${response}=    POST On Session    api    /auth/login    json=${login_data}    expected_status=401
    Should Be Equal As Numbers    ${response.status_code}    401
    Should Be Equal As Strings    ${response.json()}[error]    Invalid credentials

Get Todos Without Auth Should Fail
    [Documentation]    Access to todos without authentication
    [Tags]    api    todos    security    negative
    ${response}=    GET On Session    api    /todos    expected_status=401
    Should Be Equal As Numbers    ${response.status_code}    401
    Should Be Equal As Strings    ${response.json()}[error]    Access token required

Get Todos With Valid Auth Should Succeed
    [Documentation]    Fetch the todo list with authentication
    [Tags]    api    todos    positive
    ${token}=    Get Auth Token
    ${todos}=    Get Todos Via API    ${token}
    Should Be True    isinstance($todos, list)

Create Todo Should Work
    [Documentation]   Create a new to-do via API
    [Tags]    api    todos    create    positive
    ${token}=    Get Auth Token
    ${todo_title}=    Generate Random Todo Title
    ${todo}=    Create Todo Via API    ${todo_title}    ${token}
    
    Dictionary Should Contain Key    ${todo}    id
    Dictionary Should Contain Key    ${todo}    title
    Dictionary Should Contain Key    ${todo}    completed
    Should Be Equal As Strings    ${todo}[title]    ${todo_title}
    Should Be Equal    ${todo}[completed]    ${False}

Create Todo Without Title Should Fail
    [Documentation]    Creating a to-do without a title should fail.
    [Tags]    api    todos    create    negative
    ${token}=    Get Auth Token
    &{headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${todo_data}=    Create Dictionary
    ${response}=    POST On Session    api    /todos    json=${todo_data}    headers=${headers}    expected_status=400
    Should Be Equal As Numbers    ${response.status_code}    400

Update Todo Should Work
    [Documentation]    Edit an existing todo
    [Tags]    api    todos    update    positive
    ${token}=    Get Auth Token
    ${original_title}=    Generate Random Todo Title
    ${todo}=    Create Todo Via API    ${original_title}    ${token}
    ${todo_id}=    Get From Dictionary    ${todo}    id
    
    # Edit todo
    &{headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${update_data}=    Create Dictionary    title=Updated Title    completed=${True}
    ${response}=    PUT On Session    api    /todos/${todo_id}    json=${update_data}    headers=${headers}
    
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal As Strings    ${response.json()}[title]    Updated Title
    Should Be Equal    ${response.json()}[completed]    ${True}

Update Non-Existent Todo Should Fail
    [Documentation]    Modifying a non-existent todo should fail.
    [Tags]    api    todos    update    negative
    ${token}=    Get Auth Token
    &{headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${update_data}=    Create Dictionary    title=Updated Title
    ${response}=    PUT On Session    api    /todos/999    json=${update_data}    headers=${headers}    expected_status=404
    Should Be Equal As Numbers    ${response.status_code}    404

Delete Todo Should Work
    [Documentation]    Delete an existing to-do
    [Tags]    api    todos    delete    positive
    ${token}=    Get Auth Token
    ${todo_title}=    Generate Random Todo Title
    ${todo}=    Create Todo Via API    ${todo_title}    ${token}
    ${todo_id}=    Get From Dictionary    ${todo}    id
    
    # Delete todo
    &{headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    DELETE On Session    api    /todos/${todo_id}    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    204
    
    ${response}=    GET On Session    api    /todos/${todo_id}    headers=${headers}    expected_status=404
    Should Be Equal As Numbers    ${response.status_code}    404

Delete Non-Existent Todo Should Fail
    [Documentation]   Deleting a non-existent todo should fail
    [Tags]    api    todos    delete    negative
    ${token}=    Get Auth Token
    &{headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    DELETE On Session    api    /todos/999    headers=${headers}    expected_status=404
    Should Be Equal As Numbers    ${response.status_code}    404