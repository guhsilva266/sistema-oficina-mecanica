# 🔧 Sistema de Oficina Mecânica

> Sistema de controle e gerenciamento de execução de ordens de serviço em oficina mecânica, desenvolvido com MySQL e arquitetura profissional de banco de dados.

## 📋 Visão Geral

Este projeto implementa um **banco de dados completo** para uma oficina mecânica, permitindo:

- ✅ Gerenciamento de clientes e seus veículos
- ✅ Criação e acompanhamento de ordens de serviço
- ✅ Controle de mecânicos e equipes de trabalho
- ✅ Gestão de peças e serviços prestados
- ✅ Cálculo automático de valores totais
- ✅ Auditoria de mudanças (data_atualizacao)
- ✅ Autorização de cliente antes de executar serviços

---

## 🎯 Características Principais

### 📊 Banco de Dados Robusto
- **10 tabelas** bem estruturadas
- **Relacionamentos** corretamente implementados (1:N, N:M)
- **5 triggers automáticos** para cálculos
- **15+ índices** para performance otimizada
- **Constraints** de integridade referencial

### ⭐ Destaques Técnicos

1. **Tabela de Referência de Mão-de-Obra**
   - SERVICO ligado a TABELA_MAO_OBRA
   - Rastreamento de valores históricos
   - Auditoria completa

2. **Autorização de Cliente**
   - Campo `autorizado_cliente` em ORDEM_SERVICO
   - Controle de fluxo de aprovação
   - Status seguro do trabalho

3. **Auditoria de Mudanças**
   - Campo `data_atualizacao` em ORDEM_SERVICO
   - Rastreamento de todas as alterações
   - Histórico completo de operações

4. **Cálculos Automáticos**
   - 5 Triggers para recalcular valor total
   - Mão-de-obra + peças = valor final
   - Sempre consistente e atualizado

---

## 📁 Estrutura do Projeto

```
sistema-oficina-mecanica/
│
├── README.md                          # Este arquivo
├── DIAGRAMA_ER.png                    # Diagrama entidade-relacionamento
├── database/
│   ├── schema.sql                     # Script de criação (DDL)
│   ├── triggers.sql                   # Triggers automáticos
│   ├── indexes.sql                    # Índices para performance
│   └── sample_data.sql                # Dados de teste
│
├── docs/
│   ├── DOCUMENTACAO.md                # Documentação completa
│   ├── MELHORIAS_IMPLEMENTADAS.md     # 5 melhorias principais
│   └── GUIA_USO.md                    # Guia de uso
│
└── LICENSE                            # Licença do projeto
```

---

## 🗄️ Estrutura do Banco de Dados

### Tabelas Principais

#### 1. **CLIENTE**
Armazena informações dos clientes da oficina.
- id (PK)
- nome, telefone, email, endereco
- data_cadastro

#### 2. **VEICULO**
Cadastro dos veículos para manutenção.
- id (PK)
- placa (UNIQUE), marca_modelo, ano, cor
- id_cliente (FK) → CLIENTE

#### 3. **TABELA_MAO_OBRA** ⭐
Tabela de referência de valores de mão-de-obra.
- id (PK)
- descricao_servico
- valor_referencia
- ativo

#### 4. **ORDEM_SERVICO** ⭐
Ordens de serviço emitidas para veículos.
- numero (PK)
- data_emissao, data_entrega, data_conclusao
- valor_total (calculado automaticamente)
- status (Aberta, Em Execução, Concluída, Cancelada)
- autorizado_cliente (TINYINT) ⭐
- data_atualizacao (TIMESTAMP) ⭐
- id_veiculo (FK), id_equipe (FK)

#### 5. **SERVICO** ⭐
Serviços a executar em cada ordem de serviço.
- id (PK)
- descricao, valor_mao_obra
- id_mao_obra (FK) → TABELA_MAO_OBRA ⭐
- numero_os (FK) → ORDEM_SERVICO

#### 6. **PECA**
Catálogo de peças disponíveis.
- id (PK)
- descricao
- valor_unitario
- quantidade_estoque ⭐
- ativo

#### 7. **SERVICO_PECA** (Associativa N:M)
Relação entre serviços e peças utilizadas.
- id (PK)
- id_servico (FK), id_peca (FK)
- quantidade_utilizada

#### 8. **MECANICO**
Informações dos mecânicos da oficina.
- codigo (PK)
- nome, endereco, especialidade
- telefone ⭐, email ⭐
- data_cadastro

#### 9. **EQUIPE**
Grupos de mecânicos que trabalham juntos.
- id (PK)
- nome_equipe
- data_criacao, ativo

#### 10. **EQUIPE_MECANICO** (Associativa N:M)
Relação entre equipes e mecânicos.
- id (PK)
- id_equipe (FK), codigo_mecanico (FK)
- data_associacao, data_remocao, ativo

---

## 🚀 Como Usar

### Pré-requisitos

- MySQL 8.0 ou superior
- MySQL Workbench (recomendado) ou phpMyAdmin

### Instalação

1. **Clone o repositório**
```bash
git clone https://github.com/seu-usuario/sistema-oficina-mecanica.git
cd sistema-oficina-mecanica
```

2. **Abra MySQL Workbench ou phpMyAdmin**

3. **Execute o script de criação do banco**
```sql
-- Copie e execute todo o conteúdo de database/schema.sql
```

4. **Insira dados de teste (opcional)**
```sql
-- Execute database/sample_data.sql para popular com dados
```

### Verificação

```sql
-- Ver todas as tabelas
SHOW TABLES;

-- Ver estrutura da tabela ORDEM_SERVICO
DESCRIBE ORDEM_SERVICO;

-- Ver todos os triggers
SHOW TRIGGERS;
```

---

## 📊 Diagrama ER

O diagrama entidade-relacionamento completo está disponível em `DIAGRAMA_ER.png`.

**Relacionamentos:**
- CLIENTE (1) → VEICULO (N)
- VEICULO (1) → ORDEM_SERVICO (N)
- ORDEM_SERVICO (1) → SERVICO (N)
- TABELA_MAO_OBRA (1) → SERVICO (N) ⭐
- SERVICO (1) → SERVICO_PECA (N)
- PECA (1) → SERVICO_PECA (N)
- EQUIPE (1) → ORDEM_SERVICO (N)
- EQUIPE (1) → EQUIPE_MECANICO (N)
- MECANICO (1) → EQUIPE_MECANICO (N)

---

## ⭐ 5 Melhorias Implementadas

### 1. Tabela de Referência de Mão-de-Obra
- Criação da tabela TABELA_MAO_OBRA
- SERVICO ligado via id_mao_obra (FK)
- Rastreamento de valores históricos

### 2. Autorização do Cliente
- Campo `autorizado_cliente TINYINT` em ORDEM_SERVICO
- Controle de fluxo de aprovação
- Previne execução sem autorização

### 3. Auditoria de Mudanças
- Campo `data_atualizacao TIMESTAMP` em ORDEM_SERVICO
- Auto-atualização a cada modificação
- Histórico completo de operações

### 4. Dados de Contato do Mecânico
- Campos `telefone` e `email` em MECANICO
- Comunicação direta com equipe
- Contato de emergência

### 5. Nome Descritivo para Estoque
- Campo `quantidade_estoque` em PECA
- Clareza e distinção do uso
- Melhor documentação

---

## 🔧 Triggers Automáticos

O sistema possui **5 triggers** que recalculam automaticamente o `valor_total` em ORDEM_SERVICO:

1. **atualizar_valor_os_insert_servico**
   - Acionado ao inserir um novo serviço
   - Recalcula valor_total

2. **atualizar_valor_os_delete_servico**
   - Acionado ao deletar um serviço
   - Recalcula valor_total

3. **atualizar_valor_os_insert_peca**
   - Acionado ao associar uma peça a um serviço
   - Recalcula valor_total

4. **atualizar_valor_os_delete_peca**
   - Acionado ao remover uma peça de um serviço
   - Recalcula valor_total

5. **atualizar_valor_os_update_servico**
   - Acionado ao atualizar valor_mao_obra
   - Recalcula valor_total

**Fórmula:** `valor_total = SUM(valor_mao_obra) + SUM(quantidade_utilizada × valor_unitario_peca)`

---

## 📈 Índices para Performance

Total de **15+ índices** criados para otimizar consultas:

```sql
idx_cliente_nome              -- Busca por nome
idx_veiculo_placa             -- Busca por placa
idx_veiculo_cliente           -- Listar veículos por cliente
idx_mecanico_especialidade    -- Filtrar por especialidade
idx_mecanico_nome             -- Busca por nome
idx_os_status                 -- Filtrar por status
idx_os_data_emissao           -- Buscar por período
idx_os_veiculo                -- Listar OSs de um veículo
idx_os_equipe                 -- Listar OSs de uma equipe
idx_os_autorizado             -- Filtrar por autorização
idx_os_data_conclusao         -- Buscar por data
idx_servico_os                -- Listar serviços de uma OS
idx_servico_mao_obra          -- Buscar pela referência
idx_peca_descricao            -- Busca por descrição
idx_peca_ativo                -- Filtrar peças disponíveis
idx_tabela_mao_obra_ativo     -- Filtrar referências ativas
```

---

## 📝 Exemplos de Consultas Úteis

### Listar todas as OSs abertas
```sql
SELECT numero, data_emissao, valor_total, c.nome, v.placa, e.nome_equipe
FROM ORDEM_SERVICO os
JOIN VEICULO v ON os.id_veiculo = v.id
JOIN CLIENTE c ON v.id_cliente = c.id
JOIN EQUIPE e ON os.id_equipe = e.id
WHERE os.status = 'Aberta'
ORDER BY os.data_emissao;
```

### OSs aguardando autorização do cliente
```sql
SELECT os.numero, os.data_emissao, c.nome, v.placa, os.valor_total
FROM ORDEM_SERVICO os
JOIN VEICULO v ON os.id_veiculo = v.id
JOIN CLIENTE c ON v.id_cliente = c.id
WHERE os.status = 'Aberta' AND os.autorizado_cliente = 0;
```

### Serviços e peças de uma OS
```sql
SELECT s.descricao, s.valor_mao_obra, p.descricao as peca, 
       sp.quantidade_utilizada, p.valor_unitario,
       (sp.quantidade_utilizada * p.valor_unitario) as valor_peca
FROM SERVICO s
LEFT JOIN SERVICO_PECA sp ON s.id = sp.id_servico
LEFT JOIN PECA p ON sp.id_peca = p.id
WHERE s.numero_os = ?;
```

### Estoque de peças baixo
```sql
SELECT id, descricao, quantidade_estoque, valor_unitario
FROM PECA
WHERE quantidade_estoque < 10 AND ativo = 1
ORDER BY quantidade_estoque ASC;
```

### Receita por equipe
```sql
SELECT e.nome_equipe, COUNT(os.numero) as total_os, 
       SUM(os.valor_total) as receita_total, AVG(os.valor_total) as ticket_medio
FROM EQUIPE e
LEFT JOIN ORDEM_SERVICO os ON e.id = os.id_equipe
WHERE os.status = 'Concluída'
GROUP BY e.id, e.nome_equipe
ORDER BY receita_total DESC;
```

---

## 📚 Documentação

Veja a documentação completa em:
- [DOCUMENTACAO.md](docs/DOCUMENTACAO.md) - Descrição detalhada de cada tabela
- [MELHORIAS_IMPLEMENTADAS.md](docs/MELHORIAS_IMPLEMENTADAS.md) - Explicação das 5 melhorias
- [GUIA_USO.md](docs/GUIA_USO.md) - Guia prático de uso

---

## 🛠️ Tecnologias Utilizadas

- **MySQL 8.0+** - Banco de dados relacional
- **SQL** - Linguagem de consulta estruturada
- **Triggers** - Automação de cálculos
- **Índices** - Otimização de performance
- **ER Diagram** - Modelagem visual

---

## 📄 Status do Projeto

✅ **Banco de dados criado**  
✅ **Todas as 10 tabelas implementadas**  
✅ **5 triggers automáticos configurados**  
✅ **15+ índices para performance**  
✅ **5 melhorias implementadas**  
✅ **Diagrama ER completo**  
✅ **Documentação profissional**  
✅ **Pronto para produção**

---

## 📞 Contato & Suporte

Se tiver dúvidas ou sugestões:
- Abra uma [Issue](https://github.com/guhsilva266/sistema-oficina-mecanica/issues)
- Faça um [Pull Request](https://github.com/guhsilva266/sistema-oficina-mecanica/pulls)

---

## 📜 Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

## 👏 Créditos

Desenvolvido como um projeto de banco de dados educacional e profissional para sistema de oficina mecânica.

**Versão:** 3.0 Final  
**Data:** Abril 2026  
**Status:** ✅ Completo e Pronto para Uso

---

**⭐ Se este projeto foi útil, deixe uma estrela!** ⭐
