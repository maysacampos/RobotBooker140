# *** Variables *** ---> resources/variables.py
# *** Settings ***  ---> resources/common.resource
# *** Test Cases *** ---> Continuam no arquivo .robot
# *** Keywords ***  ---> resources/common.resource

# Casos de Teste
*** Settings ***
Library        RequestsLibrary
Resource       ../../resources/common.resource
Variables      ../../resources/variables.py
Suite Setup    Create Token    ${url}

*** Test Cases ***
Create Booking
    # Header é opcional neste caso
    ${headers}    Create Dictionary    Content-Type=${content_type}
    ${body}    Evaluate    json.loads(open('./fixtures/json/booking1.json').read())

    ${response}    POST    url=${url}/booking    json=${body} 
    ...    headers=${headers}
    
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[booking][firstname]          ${firstname}
    Should Be Equal    ${response_body}[booking][lastname]           ${lastname}
    Should Be Equal    ${response_body}[booking][totalprice]         ${totalprice}
    Should Be Equal    ${response_body}[booking][depositpaid]        ${depositpaid}
    Should Be Equal    ${response_body}[booking][bookingdates][checkin]     
    ...                                       ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[booking][bookingdates][checkout]     
    ...                                       ${bookingdates}[checkout]
    Should Be Equal    ${response_body}[booking][additionalneeds]    ${additionalneeds}

