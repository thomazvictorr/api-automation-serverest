*** Settings ***
Library     RequestsLibrary
Library     String
Library     OperatingSystem
Library     Collections

*** Variables ***

*** Keywords ***

Cadastrar Carrinho
    [Arguments]    ${token}    ${idp}
    ${body}        Get File    path=${EXECDIR}/Json/carrinho.json
    ${body}        Replace String Using Regexp    ${body}    _id    ${idp}

    ${header}      Create Dictionary    Content-Type=application/json
    ...            Authorization=${token}

    ${response}    POST On Session    alias=api    url=/carrinhos
    ...            headers=${header}
    ...            data=${body}
    ...            expected_status=201
    ${idc}         Set Variable    ${response.json()['_id']}
    Should Be Equal As Strings    ${response.json()['message']}    Cadastro realizado com sucesso
    RETURN    ${idc}

Consultar Carrinho Lista
    ${header}      Create Dictionary    Content-Type=application/json

    ${response}    GET On Session    alias=api    url=/carrinhos
    ...            headers=${header}
    ...            expected_status=200

Consultar Carrinho ID
    [Arguments]    ${idc}
    ${header}      Create Dictionary    Content-Type=application/json

    ${response}    GET On Session    alias=api    url=/carrinhos/${idc}
    ...            headers=${header}
    ...            expected_status=200

Deletar Carrinho Concluir Compra
    [Arguments]    ${token}
    ${header}      Create Dictionary    Content-Type=application/json
    ...            Authorization=${token}

    ${response}    DELETE On Session    alias=api    url=/carrinhos/concluir-compra
    ...            headers=${header}
    ...            expected_status=200
    Should Be Equal As Strings    ${response.json()['message']}    Registro excluído com sucesso

Deletar Carrinho Cancelar Compra
    [Arguments]    ${token}
    ${header}      Create Dictionary    Content-Type=application/json
    ...            Authorization=${token}

    ${response}    DELETE On Session    alias=api    url=/carrinhos/cancelar-compra
    ...            headers=${header}
    ...            expected_status=200
    Should Be Equal As Strings    ${response.json()['message']}    Registro excluído com sucesso. Estoque dos produtos reabastecido
