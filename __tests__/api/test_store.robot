*** Settings ***
Library    RequestsLibrary 

*** Variables ***
${url}    https://petstore.swagger.io/v2/store/order

${orderId}    1
${petId}    123456701 
${quantity}    1
${shipDate}    2024-10-27T15:15:41.952Z
${status}    placed
${complete}    true 

*** Test Cases ***

Post Order
    ${body}    Create Dictionary    id=${orderId}    petId=${petId}    quantity=${quantity}    shipDate=${shipDate}    
    ...    status=${status}    complete=${complete}    
     
    ${response}    POST    ${url}    json=${body}
    
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response.json()}    

    Status Should Be    200
    Should Be Equal    ${response_body}[id]    ${{int($orderId)}}   
    Should Be Equal    ${response_body}[petId]    ${{int($petId)}}    
    Should Be Equal    ${response_body}[quantity]    ${{int($quantity)}}   
    Should Be Equal    ${response_body}[status]    ${status}  


Get Order
    ${response}    GET    ${{$url + "/" + $orderId}}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[id]    ${{int($orderId)}}   
    Should Be Equal    ${response_body}[petId]    ${{int($petId)}}    
    Should Be Equal    ${response_body}[quantity]    ${{int($quantity)}}   
    Should Be Equal    ${response_body}[status]    ${status} 


Delete User    
    ${response}    DELETE    ${{$url + "/" + $orderId}}  

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[code]    ${{(200)}}
    Should Be Equal    ${response_body}[type]    unknown
    Should Be Equal    ${response_body}[message]    ${orderId} 
    
*** Keywords ***