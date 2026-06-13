# Gerenciador de Atendimentos

Aplicativo mobile desenvolvido em Flutter para gerenciamento de atendimentos/serviços, com persistência local em SQLite, integração com a API ViaCEP e suporte a geolocalização via GPS.

---

## Funcionalidades

- **Cadastro de atendimentos** com descrição, data, hora, valor e localização
- **Edição e exclusão** de atendimentos com confirmação
- **Filtro por data** para buscar atendimentos de um dia específico
- **Busca de endereço por CEP** com preenchimento automático via API ViaCEP
- **Obtenção de localização por GPS** com coordenadas geográficas
- **Formatação automática** de campos: data (dd/mm/aaaa), hora (hh:mm), CEP (00000-000) e valor (R$)
- **Persistência local** com banco de dados SQLite

---

## Tecnologias e Pacotes

| Pacote | Versão | Finalidade |
|--------|--------|-----------|
| [sqflite](https://pub.dev/packages/sqflite) | ^2.4.2 | Banco de dados SQLite local |
| [geolocator](https://pub.dev/packages/geolocator) | ^13.0.0 | Acesso ao GPS do dispositivo |
| [http](https://pub.dev/packages/http) | ^1.6.0 | Requisições HTTP (API ViaCEP) |
| [intl](https://pub.dev/packages/intl) | ^0.20.2 | Internacionalização e formatação |
| [currency_text_input_formatter](https://pub.dev/packages/currency_text_input_formatter) | ^2.1.5 | Formatação de valores monetários |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | ^2.5.4 | Preferências locais |
| [cupertino_icons](https://pub.dev/packages/cupertino_icons) | ^1.0.8 | Ícones estilo iOS |

---

## Estrutura do Projeto

```
lib/
├── main.dart                                     # Ponto de entrada do app
├── model/
│   ├── atendimento.dart                          # Modelo de dados do atendimento
│   └── cep.dart                                  # Modelo da resposta da API ViaCEP
├── pages/
│   └── lista_atendimentos_page.dart              # Tela principal com listagem e filtro
├── widgets/
│   └── conteudo_form_atendimento_dialog.dart     # Formulário de cadastro/edição
├── dao/
│   └── atendimento_dao.dart                      # Operações CRUD no banco de dados
├── dataBase/
│   └── database_provider.dart                    # Configuração e inicialização do SQLite
├── services/
│   └── cep_service.dart                          # Integração com a API ViaCEP
└── utils/
    └── input_formatters.dart                     # Formatadores customizados de input
```

---

## Modelo de Dados

### Atendimento

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | `int?` | Identificador único (auto-incremento) |
| `descricao` | `String` | Descrição do serviço ou atendimento |
| `data` | `String` | Data no formato `dd/mm/aaaa` |
| `hora` | `String` | Hora no formato `hh:mm` |
| `valor` | `double` | Valor em reais (R$) |
| `localizacao` | `String` | Endereço (via CEP ou GPS) |

---

## Como Funciona

### Fluxo Principal

1. O app abre exibindo a lista de todos os atendimentos cadastrados
2. O botão **+** (FAB) abre um formulário em modal para criar um novo atendimento
3. Tocar em um atendimento existente abre o mesmo formulário com os dados para edição
4. O ícone de lixeira exclui o atendimento após confirmação em diálogo

### Localização

- **Por CEP**: digite o CEP no campo correspondente e toque no botão de busca. O endereço é preenchido automaticamente via [ViaCEP](https://viacep.com.br)
- **Por GPS**: toque em "Obter localização" para capturar as coordenadas geográficas do dispositivo

### Filtro por Data

Na tela principal, utilize o campo de filtro para exibir apenas os atendimentos de uma data específica no formato `dd/mm/aaaa`. Deixe o campo vazio para exibir todos.

---

## Configuração e Execução

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart ^3.11.0)
- Android Studio ou VS Code com extensão Flutter
- Dispositivo Android ou emulador

### Passos

```bash
# Clone o repositório
git clone https://github.com/tainamariott/gerenciador_de_atendimentos.git

# Entre na pasta do projeto
cd gerenciador_de_atendimentos

# Instale as dependências
flutter pub get

# Execute o app
flutter run
```

### Permissões Necessárias (Android)

O app solicita as seguintes permissões em tempo de execução:

- **Localização** (`ACCESS_FINE_LOCATION` / `ACCESS_COARSE_LOCATION`) — necessária para obter coordenadas GPS
- **Internet** — necessária para consultar a API ViaCEP

---

## API Utilizada

### ViaCEP

- **Endpoint**: `https://viacep.com.br/ws/{cep}/json/`
- **Método**: GET
- **Resposta**: JSON com logradouro, bairro, cidade e estado
- **Documentação**: [viacep.com.br](https://viacep.com.br)

---

## Desenvolvido com

- [Flutter](https://flutter.dev/) — framework de desenvolvimento mobile multiplataforma
- [Dart](https://dart.dev/) — linguagem de programação
- [Material Design 3](https://m3.material.io/) — sistema de design visual
