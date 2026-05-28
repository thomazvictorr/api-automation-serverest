# 🤖 Automação de Testes de API — ServeRest

![Tests](https://github.com/thomazvictorr/api-automation-serverest/actionst/workflows/ci.yml/badge.svg)

Projeto de automação de testes para a API [ServeRest](https://serverest.dev), desenvolvido com **Robot Framework** e integrado ao **GitHub Actions** com publicação automática de relatório.

---

## 🧪 Cobertura de Testes

| Módulo | Cenários Positivos | Cenários Negativos |
|--------|-------------------|-------------------|
| Usuários | CRUD completo, Login | Email duplicado, senha inválida, ID inexistente |
| Produtos | CRUD completo | Sem token de autorização, ID inexistente |
| Carrinhos | Concluir compra, Cancelar compra | — |

**Total: 9 casos de teste** com tags para execução seletiva (`crud`, `negativo`, `regressao`)

---

## 🏗️ Estrutura do Projeto

```
├── Tests/
│   └── API_Serverrest.robot     # Casos de teste
├── Resources/
│   ├── usuario.robot            # Keywords de usuário
│   ├── produto.robot            # Keywords de produto
│   └── carrinho.robot           # Keywords de carrinho
├── Json/
│   ├── usuario.json             # Massa de dados - criação
│   ├── atlz_usuario.json        # Massa de dados - atualização
│   ├── produto.json
│   ├── atlz_produto.json
│   └── carrinho.json
├── .github/
│   └── workflows/
│       └── ci.yml               # Pipeline GitHub Actions
└── requirements.txt
```

---

## 🚀 Como executar localmente

**Pré-requisitos:** Python 3.8+

```bash
# Instalar dependências
pip install -r requirements.txt

# Executar todos os testes
robot --outputdir results Tests/API_Serverrest.robot

# Executar por tag
robot --outputdir results --include regressao Tests/API_Serverrest.robot
robot --outputdir results --include negativo Tests/API_Serverrest.robot
```

O relatório HTML será gerado em `results/report.html`.

---

## ⚙️ CI/CD com GitHub Actions

Os testes são executados automaticamente:
- A cada **push** na branch `main`
- A cada **pull request**
- Todo **dia útil às 8h** (agendamento automático)

O relatório é publicado automaticamente via **GitHub Pages** após cada execução.

📄 **[Ver último relatório](https://SEU_USUARIO.github.io/SEU_REPOSITORIO/report/report.html)**

---

## 🛠️ Tecnologias

- [Robot Framework](https://robotframework.org/) — framework de automação
- [RequestsLibrary](https://github.com/MarketSquare/robotframework-requests) — testes de API HTTP
- [ServeRest](https://serverest.dev) — API alvo dos testes
- [GitHub Actions](https://github.com/features/actions) — CI/CD

---

## 👨‍💻 Autor

**Thomáz Victor** — [LinkedIn](https://www.linkedin.com/in/thomazvictorr/) | [GitHub](https://github.com/SEU_USUARIO)
