*** Settings ***
Library     RequestsLibrary
Library     String
Library     OperatingSystem
Library     Collections

*** Variables ***

*** Keywords ***

Cadastrar Produto
    [Arguments]    ${token}
    ${ts}=         Evaluate    __import__('time').time_ns()
    ${body}=       Set Variable    {"nome":"Curso RobotFramework ${ts}","preco":500,"descricao":"Robot","quantidade":200}

    ${header}      Create Dictionary    Content-Type=application/json
    ...            Authorization=${token}

    ${response}    POST On Session    alias=api    url=/produtos
    ...            headers=${header}
    ...            data=${body}
    ...            expected_status=201
    ${idp}         Set Variable    ${response.json()['_id']}
    Should Be Equal As Strings    ${response.json()['message']}    Cadastro realizado com sucesso
    RETURN    ${idp}

Consultar Produto Lista
    ${header}      Create Dictionary    Content-Type=application/json

    ${response}    GET On Session    alias=api    url=/produtos
    ...            headers=${header}
    ...            expected_status=200

Consultar Produto ID
    [Arguments]    ${idp}
    ${header}      Create Dictionary    Content-Type=application/json

    ${response}    GET On Session    alias=api    url=/produtos/${idp}
    ...            headers=${header}
    ...            expected_status=200

Atualizar Produto
    [Arguments]    ${idp}    ${token}
    ${body}        Get File    path=${EXECDIR}/Json/atlz_produto.json

    ${header}      Create Dictionary    Content-Type=application/json
    ...            Authorization=${token}

    ${response}    PUT On Session    alias=api    url=/produtos/${idp}
    ...            headers=${header}
    ...            data=${body}
    ...            expected_status=200
    Should Be Equal As Strings    ${response.json()['message']}    Registro alterado com sucesso

Deletar Produto
    [Arguments]    ${idp}    ${token}
    ${header}      Create Dictionary    Content-Type=application/json
    ...            Authorization=${token}

    ${response}    DELETE On Session    alias=api    url=/produtos/${idp}
    ...            headers=${header}
    ...            expected_status=200
    Should Be Equal As Strings    ${response.json()['message']}    Registro excluído com sucesso

ERRO - Cadastrar Produto Sem Autorizacao
    ${body}        Get File    path=${EXECDIR}/Json/produto.json

    ${header}      Create Dictionary    Content-Type=application/json

    ${response}    POST On Session    alias=api    url=/produtos
    ...            headers=${header}
    ...            data=${body}
    ...            expected_status=401
    Should Be Equal As Strings    ${response.json()['message']}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

ERRO - Consultar Produto Inexistente
    ${header}      Create Dictionary    Content-Type=application/json

    ${response}    GET On Session    alias=api    url=/produtos/id_invalido_000
    ...            headers=${header}
    ...            expected_status=400
    Should Not Be Empty    ${response.json()}
