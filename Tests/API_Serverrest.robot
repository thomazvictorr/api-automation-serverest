*** Settings ***
Resource        ../Resources/usuario.robot
Resource        ../Resources/produto.robot
Resource        ../Resources/carrinho.robot
Library         String
Suite Setup     Criar Sessão    https://serverest.dev
Suite Teardown  Encerrar Sessão

*** Variables ***
${PASSWORD}     123456

*** Keywords ***

Gerar Email
    [Arguments]    ${prefixo}
    ${ts}=         Evaluate    __import__('time').time_ns()
    ${email}=      Set Variable    ${prefixo}_${ts}@test.com
    RETURN         ${email}

*** Test Cases ***

### USUARIOS ###

CT-001 CRUD Usuario - Fluxo Completo
    [Tags]    usuario    crud    regressao
    ${email}   Gerar Email    ct001
    ${id}      Cadastrar Usuario          ${email}    ${PASSWORD}
    ${token}   Login do Usuario           ${email}    ${PASSWORD}
    Consultar Usuario Lista
    Consultar Usuario ID                  ${id}
    Atualizar Usuario                     ${id}
    Deletar Usuario                       ${id}

CT-002 Erro - Cadastrar Usuario com Email Duplicado
    [Tags]    usuario    negativo
    ${email}   Gerar Email    ct002
    ${id}      Cadastrar Usuario              ${email}    ${PASSWORD}
    ERRO - Cadastrar Usuario Duplicado        ${email}    ${PASSWORD}
    Deletar Usuario                           ${id}

CT-003 Erro - Login com Senha Invalida
    [Tags]    usuario    negativo
    ${email}   Gerar Email    ct003
    ERRO - Login com Senha Invalida    ${email}

CT-004 Erro - Consultar Usuario Inexistente
    [Tags]    usuario    negativo
    ERRO - Consultar Usuario Inexistente

### PRODUTOS ###

CT-005 CRUD Produto - Fluxo Completo
    [Tags]    produto    crud    regressao
    ${email}   Gerar Email    ct005
    ${id}      Cadastrar Usuario          ${email}    ${PASSWORD}
    ${token}   Login do Usuario           ${email}    ${PASSWORD}
    ${idp}     Cadastrar Produto          ${token}
    Consultar Produto Lista
    Consultar Produto ID                  ${idp}
    Atualizar Produto                     ${idp}      ${token}
    Deletar Produto                       ${idp}      ${token}
    Deletar Usuario                       ${id}

CT-006 Erro - Cadastrar Produto Sem Token
    [Tags]    produto    negativo
    ERRO - Cadastrar Produto Sem Autorizacao

CT-007 Erro - Consultar Produto Inexistente
    [Tags]    produto    negativo
    ERRO - Consultar Produto Inexistente

### CARRINHOS ###

CT-008 Carrinho - Concluir Compra com Sucesso
    [Tags]    carrinho    crud    regressao
    ${email}   Gerar Email    ct008
    ${id}      Cadastrar Usuario              ${email}    ${PASSWORD}
    ${token}   Login do Usuario               ${email}    ${PASSWORD}
    ${idp}     Cadastrar Produto              ${token}
    ${idc}     Cadastrar Carrinho             ${token}    ${idp}
    Consultar Carrinho Lista
    Consultar Carrinho ID                     ${idc}
    Deletar Carrinho Concluir Compra          ${token}
    Deletar Produto                           ${idp}      ${token}
    Deletar Usuario                           ${id}

CT-009 Carrinho - Cancelar Compra
    [Tags]    carrinho    regressao
    ${email}   Gerar Email    ct009
    ${id}      Cadastrar Usuario              ${email}    ${PASSWORD}
    ${token}   Login do Usuario               ${email}    ${PASSWORD}
    ${idp}     Cadastrar Produto              ${token}
    ${idc}     Cadastrar Carrinho             ${token}    ${idp}
    Consultar Carrinho Lista
    Consultar Carrinho ID                     ${idc}
    Deletar Carrinho Cancelar Compra          ${token}
    Deletar Produto                           ${idp}      ${token}
    Deletar Usuario                           ${id}
