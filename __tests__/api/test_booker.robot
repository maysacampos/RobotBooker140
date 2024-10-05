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
    Should Be Equal    ${response_body}[booking][firstname]                 ${firstname}
    Should Be Equal    ${response_body}[booking][lastname]                  ${lastname}
    Should Be Equal    ${response_body}[booking][totalprice]                ${totalprice}
    Should Be Equal    ${response_body}[booking][depositpaid]               ${depositpaid}
    Should Be Equal    ${response_body}[booking][bookingdates][checkin]     ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[booking][bookingdates][checkout]    ${bookingdates}[checkout]
    Should Be Equal    ${response_body}[booking][additionalneeds]           ${additionalneeds}


Get Booking

    Get Booking Id    ${url}    ${firstname}    ${lastname}

    ${response}    GET    url=${url}/booking/${booking_id}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Should Be Equal    ${response_body}[firstname]                 ${firstname}
    Should Be Equal    ${response_body}[lastname]                  ${lastname}
    Should Be Equal    ${response_body}[totalprice]                ${totalprice}
    Should Be Equal    ${response_body}[depositpaid]               ${depositpaid}
    Should Be Equal    ${response_body}[bookingdates][checkin]     ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[bookingdates][checkout]    ${bookingdates}[checkout]
    Should Be Equal    ${response_body}[additionalneeds]           ${additionalneeds}

Update Booking
    Get Booking Id    ${url}    ${firstname}    ${lastname}
    ${headers}    Create Dictionary    Content-Type=${content_type} 
    ...           Cookie=token=${token}                            # adicionar o cookie para permissão do token
    ${body}    Create Dictionary    firstname=${firstname} 
    ...    lastname=${lastname}    totalprice=90    
    ...    depositpaid=True    bookingdates=${bookingdates} 
    ...    additionalneeds=${additionalneeds}   
    
    ${response}    PUT    url=${url}/booking/${booking_id}
    ...                   json=${body}    headers=${headers}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}    

    Status Should Be    200
                             
    Should Be Equal    ${response_body}[firstname]          ${firstname}         # sem o booking do Create Booking
    Should Be Equal    ${response_body}[lastname]           ${lastname}
    Should Be Equal    ${response_body}[totalprice]         ${{int(90)}}         # quando for número precisa converter
    Should Be Equal    ${response_body}[depositpaid]        ${{bool(True)}}      # também precisa converter
    Should Be Equal    ${response_body}[bookingdates][checkin]     
    ...                                       ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[bookingdates][checkout]     
    ...                                       ${bookingdates}[checkout]
    Should Be Equal    ${response_body}[additionalneeds]    ${additionalneeds}


Partial Update Booking
    Get Booking Id    ${url}    ${firstname}    ${lastname}             # cabeçalho / conteúdo 
    ${headers}    Create Dictionary    Cookie=token=${token}            # token
    ...                         Content-Type=${content_type}            # continuação da linha
    ${body}    Create Dictionary    additionalneeds=Dinner              # mudar de café da manha para jantar

    ${response}    PATCH    url=${url}/booking/${booking_id}            # executa   
    ...    headers=${headers}    json=${body} 

    ${response_body}    Set Variable    ${response.json()}              # valida
    Log To Console    ${response_body}

    Status Should Be    200

    Should Be Equal    ${response_body}[firstname]          ${firstname}
    Should Be Equal    ${response_body}[lastname]           ${lastname}
    Should Be Equal    ${response_body}[totalprice]         ${{int(90)}}
    Should Be Equal    ${response_body}[depositpaid]        ${{bool(True)}}
    Should Be Equal    ${response_body}[bookingdates][checkin]     
    ...                                       ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[bookingdates][checkout]     
    ...                                       ${bookingdates}[checkout]
    Should Be Equal    ${response_body}[additionalneeds]    Dinner


Delete Booking
    Get Booking Id    ${url}    ${firstname}    ${lastname}        # nº do agendamento
    ${headers}    Create Dictionary    Cookie=token=${token}    Content-Type=${content_type}    
    ...                         
   
    ${response}    DELETE    url=${url}/booking/${booking_id}    headers=${headers}   # pega a referencia no site (nao tem body)
   
    Status Should Be    201    # atenção com o código