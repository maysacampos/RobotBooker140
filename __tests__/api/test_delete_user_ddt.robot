*** Settings ***
Library    RequestsLibrary 
Library    DataDriver    ../fixtures/csv/user.csv    dialect=excel    
Test Template    DELETE User DDT

*** Variables ***
${url}    https://petstore.swagger.io/v2/user

*** Test Cases ***
TC002-USER-DELETE   ${id}    ${username}    ${firstName}    ${lastName}    ${email}    ${password}    ${phone}    ${userStatus}

*** Keywords ***

DELETE User DDT
    [Arguments]    ${id}    ${username}    ${firstName}    ${lastName}    ${email}    ${password}    ${phone}    ${userStatus}   
    ${id}    Convert To Integer    ${id}
    ${userStatus}    Convert To Integer    ${userStatus}
    ${body}    Create Dictionary    id=${id}    username=${username}    firstName=${firstName}    lastName=${lastName}    
    ...    email=${email}    password=${password}    phone=${phone}    userStatus=${userStatus} 
    
    ${response}    DELETE    ${{$url + "/" + $username}}    json=${body}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[code]    ${{(200)}}
    Should Be Equal    ${response_body}[type]    unknown