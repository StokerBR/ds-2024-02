# Arcabouço Geral da Solução: Habitracker

## 1. Definição de Requisitos

- O aplicativo deve permitir que os usuários registrem hábitos e metas.
- Acompanhar o progresso dos hábitos.
- Exibir e armazenar o histórico dos hábitos.
- Enviar notificações configuráveis por meta.
- Interface intuitiva e fácil de navegar.

## 2. Identificação dos Componentes

### 2.1 Interface de Usuário (UI Layer)

- **Responsabilidade**: Exibir as telas e widgets para o usuário.
- **Telas Principais**:
  - **Home**: Exibe o histórico dos hábitos em um calendário e as metas mais próximas de serem concluídas.
  - **Tela de Hábitos**: Lista todos os hábitos cadastrados.
    - **Tela de Cadastro/Edição de Hábitos**: Permite criar e editar hábitos.
  - **Tela de Metas**: Exibe as metas cadastradas e o progresso de cada uma.
    - **Tela de Cadastro/Edição de Metas**: Permite criar e editar metas, além de configurar notificações para cada meta.

### 2.2 Gerenciamento de Hábitos (Habit Manager)

- **Responsabilidade**: Lógica de negócios para gerenciar hábitos e metas.
- **Componentes**:
  - Cadastro de novos hábitos e metas.
  - Acompanhamento de progresso de metas.

### 2.3 Persistência de Dados (Habit Repository)

- **Responsabilidade**: Armazenar e recuperar dados localmente.
- **Componentes**:
  - Banco de Dados Local (SQLite).
  - Serviço de persistência de dados (CRUD de hábitos e metas).

### 2.4 Notificações Locais (Notification Service)

- **Responsabilidade**: Gerenciar e enviar notificações para metas.
- **Configuração**: As notificações serão configuradas diretamente na tela de cadastro/edição de metas.

## 3. Critérios de Divisão

- **Baixo Acoplamento**: Componentes independentes com interfaces claras.
- **Alta Coesão**: Cada componente tem uma responsabilidade única.
