*** Settings ***
Library    RequestsLibrary
Library    DataDriver    ../../fixtures/csv/bookings.csv    dialect=excel       # instalar pip install robotframework-datadriver
Resource    ../../resources/common.resource                                     # instalar pip install --upgrade robotframework-datadriver[XLS]  
Variables    ../../resources/variables.py                                       # C:\ITERASYS\RobotBooker140\fixtures\csv\bookings.csv
Test Setup    Create Token    ${url}
Test Template    Create Booking DDT


*** Test Cases ***
TC001    ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}
TC002    ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}

*** Keywords ***
Create Booking DDT
    [Arguments]    ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}    ${checkin}    ${checkout}    ${additionalneeds}
    ${headers}    Create Dictionary    Content-Type=${content_type}
    ${totalprice}    Convert To Integer    ${totalprice}                                  # nº - fazer tratamento
    ${depositpaid}    Convert To Boolean    ${depositpaid}                                # fazer tratamento
    &{bookingdates}    Create Dictionary    checkin=${checkin}    checkout=${checkout}    # fazer tratamento & -  juntar os campos
    ${body}    Create Dictionary    firstname=${firstname}    lastname=${lastname}        # colocar todas as variaveis 
    ...    totalprice=${totalprice}    depositpaid=${depositpaid}
    ...    bookingdates=${bookingdates}    additionalneeds=${additionalneeds}
        
    ${response}    POST    url=${url}/booking    headers=${headers}    
    ...    json=${body}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[booking][firstname]    ${firstname}            # colocar dentro do booking
    Should Be Equal    ${response_body}[booking][lastname]    ${lastname}
    Should Be Equal    ${response_body}[booking][totalprice]    ${totalprice}
    Should Be Equal    ${response_body}[booking][depositpaid]    ${depositpaid}
    Should Be Equal    ${response_body}[booking][bookingdates][checkin]     ${checkin}        # nível olhar na documentação
    Should Be Equal    ${response_body}[booking][bookingdates][checkout]    ${checkout}
    Should Be Equal    ${response_body}[booking][additionalneeds]           ${additionalneeds}


      