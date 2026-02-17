# Instruções de Implementação - Sistema de Lanches EasyPedidos

Este guia descreve as alterações realizadas no sistema para permitir a configuração e customização de lanches.

## 1. API RESTful (Node.js + Express)
A API foi criada no diretório `EasyPedidos_API`.
- **Endpoints:**
  - `GET /api/lanches`: Lista todos os lanches.
  - `POST /api/lanches`: Cria um novo lanche.
  - `PUT /api/lanches/:id`: Atualiza um lanche.
  - `DELETE /api/lanches/:id`: Remove um lanche.
- **Como rodar:**
  ```bash
  cd EasyPedidos_API
  npm install
  node server.js
  ```

## 2. Configurador Web (Painel Administrativo)
Localizado em `EasyPedidos_Configurator`.
- Interface responsiva em HTML/CSS/JS.
- Permite o CRUD completo dos lanches integrando com a API.
- Para usar, basta abrir o `index.html` no navegador (com a API rodando).

## 3. Modificações no App Flutter
As seguintes alterações foram feitas no diretório `EasyPedidos_Flutter`:

### 3.1 Modelos (`lib/models/`)
- **`produto_model.dart`**: Adicionados campos `ingredientes` e `ingredientesDisponiveis`. Adicionado suporte a `fromJson` para integração com a API.
- **`item_pedido_model.dart`**: Adicionado campo `ingredientes` para armazenar a escolha do cliente.

### 3.2 Serviço de Produtos (`lib/services/`)
- **`produto_service.dart`**: Atualizado para buscar os lanches da API em `http://localhost:3000/api/lanches` usando o pacote `http`.

### 3.3 ViewModel (`lib/viewmodels/`)
- **`pedido_viewmodel.dart`**: Método `adicionarItem` atualizado para receber e armazenar os ingredientes customizados.
- **`finalizar_pedido_viewmodel.dart`**: Removida a lógica de impressão que foi descontinuada.

### 3.4 Interface do Usuário (`lib/views/`)
- **`pedido_page.dart`**:
  - Implementado modal de customização que abre ao selecionar um lanche.
  - Exibe checkboxes para remoção/manutenção de ingredientes.
- **`finalizar_pedido_page.dart`**: Removida a opção "Imprimir via do cliente".
- **`detalhes_pedido_page.dart`**: Removido o botão "Imprimir" da tela de detalhes do pedido faturado.

---
**Nota:** Para testes em dispositivos físicos ou emuladores Android, lembre-se de alterar o IP `localhost` no `ProdutoService` para o IP da sua máquina ou `10.0.2.2`.
