*** Settings ***
Resource        ../Resources/usuario.robot
Resource        ../Resources/produto.robot
Resource        ../Resources/carrinho.robot
Suite Setup     Criar Sessão    https://serverest.dev
Suite Teardown  Encerrar Sessão

*** Variables ***
${EMAIL}        user_123456@test.com
${PASSWORD}     123456

*** Test Cases ***

### USUARIOS ###

CT-001 CRUD Usuario - Fluxo Completo
    [Tags]    usuario    crud    regressao
    ${id}      Cadastrar Usuario
    ${token}   Login do Usuario       ${EMAIL}    ${PASSWORD}
    Consultar Usuario Lista
    Consultar Usuario ID               ${id}
    Atualizar Usuario                  ${id}
    Deletar Usuario                    ${id}

CT-002 Erro - Cadastrar Usuario com Email Duplicado
    [Tags]    usuario    negativo
    Cadastrar Usuario
    ERRO - Cadastrar Usuario Duplicado

CT-003 Erro - Login com Senha Invalida
    [Tags]    usuario    negativo
    ERRO - Login com Senha Invalida    ${EMAIL}

CT-004 Erro - Consultar Usuario Inexistente
    [Tags]    usuario    negativo
    ERRO - Consultar Usuario Inexistente

### PRODUTOS ###

CT-005 CRUD Produto - Fluxo Completo
    [Tags]    produto    crud    regressao
    ${token}   Login do Usuario       ${EMAIL}    ${PASSWORD}
    ${idp}     Cadastrar Produto      ${token}
    Consultar Produto Lista
    Consultar Produto ID               ${idp}
    Atualizar Produto                  ${idp}     ${token}
    Deletar Produto                    ${idp}     ${token}

CT-006 Erro - Cadastrar Produto Sem Token
    [Tags]    produto    negativo
    ERRO - Cadastrar Produto Sem Autorizacao

CT-007 Erro - Consultar Produto Inexistente
    [Tags]    produto    negativo
    ERRO - Consultar Produto Inexistente

### CARRINHOS ###

CT-008 Carrinho - Concluir Compra com Sucesso
    [Tags]    carrinho    crud    regressao
    ${token}   Login do Usuario           ${EMAIL}    ${PASSWORD}
    ${idp}     Cadastrar Produto          ${token}
    ${idc}     Cadastrar Carrinho         ${token}    ${idp}
    Consultar Carrinho Lista
    Consultar Carrinho ID                 ${idc}
    Deletar Carrinho Concluir Compra      ${token}

CT-009 Carrinho - Cancelar Compra
    [Tags]    carrinho    regressao
    ${token}   Login do Usuario           ${EMAIL}    ${PASSWORD}
    ${idp}     Cadastrar Produto          ${token}
    ${idc}     Cadastrar Carrinho         ${token}    ${idp}
    Consultar Carrinho Lista
    Consultar Carrinho ID                 ${idc}
    Deletar Carrinho Cancelar Compra      ${token}
