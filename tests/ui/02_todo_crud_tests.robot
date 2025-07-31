*** Settings ***
Documentation     CRUD tests for todos
Resource          ../resources/keywords.robot

*** Test Cases ***
Todo List Should Display Correctly
    [Documentation]    Verify the display of the todo list
    [Tags]    ui    todos    smoke
    Setup Browser 
    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Wait Until Location Contains    /todos    30s
    Ensure On Todos Page
    Page Should Contain Element    css:[data-testid="todos-list"]
    Page Should Contain Element    css:[data-testid="add-todo-form"]
    Page Should Contain Element    css:[data-testid="new-todo-input"]
    Page Should Contain Element    css:[data-testid="add-todo-button"]
    Page Should Contain    My Todos
    Teardown Browser

Add New Todo Should Work
    [Documentation]    Add a new todo
    [Tags]    ui    todos    create    positive
    Setup Browser 
    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Wait Until Location Contains    /todos    30s
    Ensure On Todos Page
    ${todo_title}=    Generate Random Todo Title
    Add New Todo    ${todo_title}
    Verify Todo Exists    ${todo_title}
    # Verify that the input field is cleared after adding
    ${input_value}=    Get Value    css:[data-testid="new-todo-input"]
    Should Be Empty    ${input_value}
    Teardown Browser

Add Empty Todo Should Not Work
    [Documentation]    Do not allow adding an empty todo
    [Tags]    ui    todos    create    negative
    Setup Browser 
    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Wait Until Location Contains    /todos    30s 
    ${todos_before}=    Get Element Count    css:[data-testid="todo-item"]  
    # Try to add an empty todo
    Click Button    css:[data-testid="add-todo-button"]
    Sleep    1s
    
    # Verify that no todo was added
    ${todos_after}=    Get Element Count    css:[data-testid="todo-item"]
    Should Be Equal As Numbers    ${todos_before}    ${todos_after}
    Teardown Browser

Toggle Todo Completion Should Work
    [Documentation]    Mark/unmark a todo as completed
    [Tags]    ui    todos    update
    Setup Browser 
    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Wait Until Location Contains    /todos    30s 
    ${todo_title}=    Generate Random Todo Title
    Add New Todo    ${todo_title}
    ${checkbox}=    Get WebElement    xpath://div[contains(@data-testid, 'todo-item') and contains(., '${todo_title}')]//input[@type='checkbox']
    ${is_checked_before}=    Execute Javascript    return arguments[0].checked    ARGUMENTS    ${checkbox}
    
    Click Element    ${checkbox}
    Sleep    1s   
    
    ${is_checked_after}=    Execute Javascript    return arguments[0].checked    ARGUMENTS    ${checkbox}
    Should Not Be Equal    ${is_checked_before}    ${is_checked_after}
    Teardown Browser

Edit Todo Should Work
    [Documentation]    Edit the title of a todo
    [Tags]    ui    todos    update    positive
    ${original_title}=    Generate Random Todo Title
    ${new_title}=    Generate Random Todo Title
    
    Setup Browser 
    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Wait Until Location Contains    /todos    30s     
    Add New Todo    ${original_title}
    Edit Todo By Title    ${original_title}    ${new_title}
    
    Verify Todo Exists    ${new_title}
    Teardown Browser

Cancel Edit Should Work
    [Documentation]    Cancel the editing of a todo
    [Tags]    ui    todos    update
    ${todo_title}=    Generate Random Todo Title
    
    Setup Browser 
    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Wait Until Location Contains    /todos    30s  
    Add New Todo    ${todo_title}
    Cancel Edit Todo By Title    ${todo_title}    Modified Title
    Verify Todo Exists    ${todo_title}
    Teardown Browser

Delete Todo Should Work
    [Documentation]    Delete a todo
    [Tags]    ui    todos    delete    positive
    ${todo_title}=    Generate Random Todo Title
    Setup Browser 
    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Wait Until Location Contains    /todos    30s 
    Add New Todo    ${todo_title}
    
    Delete Todo By Title    ${todo_title}

    Verify Todo Does Not Exist    ${todo_title}
    Teardown Browser

Cancel Delete Should Work
    [Documentation]    Cancel the deletion of a todo
    [Tags]    ui    todos    delete
    ${todo_title}=    Generate Random Todo Title
    Setup Browser 
    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Wait Until Location Contains    /todos    30s 
    Add New Todo    ${todo_title}
 
    ${delete_button}=    Get WebElement    xpath://div[contains(@data-testid, 'todo-item') and contains(., '${todo_title}')]//button[contains(@data-testid, 'delete-todo-')]
    Click Element    ${delete_button}
    
    Handle Alert    DISMISS

    Verify Todo Exists    ${todo_title}
    Teardown Browser
