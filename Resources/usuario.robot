*** Settings ***
Library     RequestsLibrary
Library     String
Library     OperatingSystem
Library     Collections

*** Variables ***

*** Keywords ***

Criar Sessão
    [Arguments]    ${url}
    Create Session    alias=api    url=${url}

Encerrar Sessão
    Delete All Sessions

Cadastrar Usuario
    [Arguments]    ${email}    ${password}
    ${header}      Create Dictionary    Content-Type=application/json
    ${body}        Set Variable    {"nome":"Usuário Teste","email":"${email}","password":"${password}","administrador":"true"}

    ${response}    POST On Session    alias=api    url=/usuarios
    ...            headers=${header}
    ...            data=${body}
    ...            expected_status=201
    ${id}          Set Variable    ${response.json()['_id']}
    Should Be Equal As Strings    ${response.json()['message']}    Cadastro realizado com sucesso
    RETURN    ${id}

Consultar Usuario Lista
    ${header}      Create Dictionary    Content-Type=application/json

    ${response}    GET On Session    alias=api    url=/usuarios
    ...            headers=${header}
    ...            expected_status=200

Consultar Usuario ID
    [Arguments]    ${id}
    ${header}      Create Dictionary    Content-Type=application/json

    ${response}    GET On Session    alias=api    url=/usuarios/${id}
    ...            headers=${header}
    ...            expected_status=200

Atualizar Usuario
    [Arguments]    ${id}
    ${body}        Get File    path=${EXECDIR}/Json/atlz_usuario.json
    ${header}      Create Dictionary    Content-Type=application/json

    ${response}    PUT On Session    alias=api    url=/usuarios/${id}
    ...            headers=${header}
    ...            data=${body}
    ...            expected_status=200
    Should Be Equal As Strings    ${response.json()['message']}    Registro alterado com sucesso

Deletar Usuario
    [Arguments]    ${id}
    ${header}      Create Dictionary    Content-Type=application/json

    ${response}    DELETE On Session    alias=api    url=/usuarios/${id}
    ...            headers=${header}
    ...            expected_status=200
    Should Be Equal As Strings    ${response.json()['message']}    Registro excluído com sucesso

Login do Usuario
    [Arguments]    ${email}    ${password}
    ${header}      Create Dictionary    Content-Type=application/json

    ${response}    POST On Session    alias=api    url=/login
    ...            headers=${header}
    ...            data={"email":"${email}","password":"${password}"}
    ...            expected_status=200
    ${token}       Set Variable    ${response.json()['authorization']}
    Should Be Equal As Strings    ${response.json()['message']}    Login realizado com sucesso
    RETURN    ${token}

ERRO - Cadastrar Usuario Duplicado
    [Arguments]    ${email}    ${password}
    ${header}      Create Dictionary    Content-Type=application/json
    ${body}        Set Variable    {"nome":"Usuário Teste","email":"${email}","password":"${password}","administrador":"true"}

    ${response}    POST On Session    alias=api    url=/usuarios
    ...            headers=${header}
    ...            data=${body}
    ...            expected_status=400
    Should Be Equal As Strings    ${response.json()['message']}    Este email já está sendo usado

ERRO - Login com Senha Invalida
    [Arguments]    ${email}
    ${header}      Create Dictionary    Content-Type=application/json

    ${response}    POST On Session    alias=api    url=/login
    ...            headers=${header}
    ...            data={"email":"${email}","password":"senha_errada"}
    ...            expected_status=401
    Should Be Equal As Strings    ${response.json()['message']}    Email e/ou senha inválidos

ERRO - Consultar Usuario Inexistente
    ${header}      Create Dictionary    Content-Type=application/json

    ${response}    GET On Session    alias=api    url=/usuarios/id_invalido_000
    ...            headers=${header}
    ...            expected_status=400
    Should Not Be Empty    ${response.json()}
