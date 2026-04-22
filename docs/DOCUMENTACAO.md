\# DOCUMENTAÇÃO - SISTEMA DE OFICINA MECÂNICA



\## 1. VISÃO GERAL



Sistema de controle e gerenciamento de execução de ordens de serviço em oficina mecânica, permitindo rastrear clientes, veículos, serviços realizados e peças utilizadas.



\---



\## 2. DESCRIÇÃO DAS TABELAS



\### CLIENTE

Armazena informações dos clientes que levam seus veículos à oficina.



| Campo | Tipo | Descrição |

|-------|------|-----------|

| id | INT (PK) | Identificador único do cliente |

| nome | VARCHAR(100) | Nome do cliente |

| telefone | VARCHAR(11) | Telefone de contato |

| email | VARCHAR(100) | Email para notificações |

| endereco | VARCHAR(150) | Endereço residencial |

| data\_cadastro | TIMESTAMP | Data de cadastro (automática) |



\*\*Relacionamentos:\*\*

\- 1:N com VEICULO (um cliente pode ter vários veículos)



\---



\### VEICULO

Cadastro dos veículos dos clientes que vão à oficina.



| Campo | Tipo | Descrição |

|-------|------|-----------|

| id | INT (PK) | Identificador único do veículo |

| placa | VARCHAR(10) | Placa do veículo (UNIQUE) |

| marca\_modelo | VARCHAR(100) | Marca e modelo do veículo |

| ano | INT | Ano de fabricação |

| cor | VARCHAR(30) | Cor do veículo |

| id\_cliente | INT (FK) | Referência ao cliente proprietário |

| data\_cadastro | TIMESTAMP | Data de cadastro |



\*\*Relacionamentos:\*\*

\- N:1 com CLIENTE

\- 1:N com ORDEM\_SERVICO



\---



\### MECANICO

Informações dos mecânicos que trabalham na oficina.



| Campo | Tipo | Descrição |

|-------|------|-----------|

| codigo | INT (PK) | Código único do mecânico |

| nome | VARCHAR(100) | Nome completo |

| endereco | VARCHAR(150) | Endereço |

| especialidade | VARCHAR(100) | Área de especialidade (motor, freios, suspensão, etc.) |

| telefone | VARCHAR(11) | Telefone de contato |

| email | VARCHAR(100) | Email corporativo |

| data\_cadastro | TIMESTAMP | Data de cadastro |



\*\*Relacionamentos:\*\*

\- N:M com EQUIPE (através de EQUIPE\_MECANICO)



\---



\### EQUIPE

Grupos de mecânicos que trabalham juntos na execução de serviços.



| Campo | Tipo | Descrição |

|-------|------|-----------|

| id | INT (PK) | Identificador único da equipe |

| nome\_equipe | VARCHAR(100) | Nome da equipe |

| data\_criacao | TIMESTAMP | Data de criação |



\*\*Relacionamentos:\*\*

\- N:M com MECANICO (através de EQUIPE\_MECANICO)

\- 1:N com ORDEM\_SERVICO



\---



\### EQUIPE\_MECANICO (Tabela Associativa)

Relaciona os mecânicos às equipes (cada mecânico pode estar em uma ou mais equipes).



| Campo | Tipo | Descrição |

|-------|------|-----------|

| id | INT (PK) | Identificador da associação |

| id\_equipe | INT (FK) | Referência à equipe |

| codigo\_mecanico | INT (FK) | Referência ao mecânico |

| data\_associacao | TIMESTAMP | Data da associação |



\*\*Constraints:\*\*

\- UNIQUE: não pode haver duplicação de (equipe, mecânico)



\---



\### ORDEM\_SERVICO

Registro das ordens de serviço emitidas para cada veículo.



| Campo | Tipo | Descrição |

|-------|------|-----------|

| numero | INT (PK) | Número único da OS (auto-increment) |

| data\_emissao | DATE | Data de emissão da OS |

| data\_conclusao | DATE | Data de conclusão prevista/realizada |

| valor\_total | DECIMAL(10,2) | Valor total da OS (calculado automaticamente) |

| status | VARCHAR(30) | Status: 'Aberta', 'Em Execução', 'Concluída', 'Cancelada' |

| id\_veiculo | INT (FK) | Referência ao veículo |

| id\_equipe | INT (FK) | Referência à equipe designada |

| data\_criacao | TIMESTAMP | Data de criação |



\*\*Relacionamentos:\*\*

\- N:1 com VEICULO

\- N:1 com EQUIPE

\- 1:N com SERVICO



\---



\### SERVICO

Lista os serviços a executar em cada ordem de serviço.



| Campo | Tipo | Descrição |

|-------|------|-----------|

| id | INT (PK) | Identificador único do serviço |

| descricao | VARCHAR(200) | Descrição do serviço (conserto, revisão, etc.) |

| valor\_mao\_obra | DECIMAL(10,2) | Valor da mão-de-obra consulta na tabela de referência |

| numero\_os | INT (FK) | Referência à ordem de serviço |

| data\_criacao | TIMESTAMP | Data de criação |



\*\*Relacionamentos:\*\*

\- N:1 com ORDEM\_SERVICO

\- N:M com PECA (através de SERVICO\_PECA)



\*\*Observação:\*\* O valor é consultado da tabela de referência de mão-de-obra (pode ser armazenado diretamente ou em outra tabela).



\---



\### PECA

Catálogo de peças disponíveis na oficina.



| Campo | Tipo | Descrição |

|-------|------|-----------|

| id | INT (PK) | Identificador único |

| descricao | VARCHAR(200) | Descrição da peça (filtro de ar, óleo, corrente, etc.) |

| valor\_unitario | DECIMAL(10,2) | Valor unitário da peça |

| quantidade | INT | Quantidade em estoque |

| data\_cadastro | TIMESTAMP | Data de cadastro |



\*\*Relacionamentos:\*\*

\- N:M com SERVICO (através de SERVICO\_PECA)



\---



\### SERVICO\_PECA (Tabela Associativa)

Relaciona as peças aos serviços (permite usar múltiplas peças em um serviço).



| Campo | Tipo | Descrição |

|-------|------|-----------|

| id | INT (PK) | Identificador da associação |

| id\_servico | INT (FK) | Referência ao serviço |

| id\_peca | INT (FK) | Referência à peça |

| quantidade\_utilizada | INT | Quantidade de peças utilizadas neste serviço |

| data\_associacao | TIMESTAMP | Data da associação |



\*\*Constraints:\*\*

\- UNIQUE: não pode haver duplicação de (serviço, peça)



\---



\## 3. FLUXO DO SISTEMA



1\. \*\*Cliente chega com veículo\*\* → Registra-se em CLIENTE e VEICULO

2\. \*\*Equipe avalia o veículo\*\* → Cria ORDEM\_SERVICO e designa EQUIPE

3\. \*\*Identifica serviços necessários\*\* → Insere registros em SERVICO

4\. \*\*Identifica peças necessárias\*\* → Associa em SERVICO\_PECA

5\. \*\*Calcula valor total\*\* → Mão-de-obra + (peças × quantidade) → ORDEM\_SERVICO.valor\_total (automático via TRIGGER)

6\. \*\*Cliente autoriza\*\* → Status da OS muda para "Em Execução"

7\. \*\*Equipe executa\*\* → Realiza os serviços listados

8\. \*\*Conclui trabalho\*\* → Status muda para "Concluída" e registra data\_conclusao



\---



\## 4. RELACIONAMENTOS (Cardinalidade)



| Relacionamento | Tipo | Descrição |

|---|---|---|

| CLIENTE ↔ VEICULO | 1:N | Um cliente pode ter vários veículos |

| VEICULO ↔ ORDEM\_SERVICO | 1:N | Um veículo pode ter várias OSs |

| ORDEM\_SERVICO ↔ SERVICO | 1:N | Uma OS pode listar vários serviços |

| ORDEM\_SERVICO ↔ EQUIPE | N:1 | Várias OSs podem ser atribuídas à mesma equipe |

| EQUIPE ↔ MECANICO | N:M | Uma equipe pode ter vários mecânicos; um mecânico pode estar em várias equipes |

| SERVICO ↔ PECA | N:M | Um serviço pode usar várias peças; uma peça pode ser usada em vários serviços |



\---



\## 5. INTEGRIDADE DE DADOS



\### Constraints Aplicados

\- \*\*Primary Keys (PK):\*\* Identificadores únicos em cada tabela

\- \*\*Foreign Keys (FK):\*\* Relacionamentos entre tabelas com ON DELETE RESTRICT/CASCADE e ON UPDATE CASCADE

\- \*\*UNIQUE:\*\* Placa do veículo e combinações em tabelas associativas

\- \*\*CHECK:\*\* Status da OS limitado a valores válidos

\- \*\*DEFAULT:\*\* Timestamps automáticos e status inicial



\### Triggers (Cálculos Automáticos)

\- \*\*atualizar\_valor\_os\_insert\_servico:\*\* Recalcula valor\_total ao inserir serviço

\- \*\*atualizar\_valor\_os\_delete\_servico:\*\* Recalcula valor\_total ao deletar serviço

\- \*\*atualizar\_valor\_os\_insert\_peca:\*\* Recalcula valor\_total ao associar peça a um serviço



\---



\## 6. ÍNDICES PARA PERFORMANCE



| Índice | Tabela | Campo | Uso |

|--------|--------|-------|-----|

| idx\_cliente\_nome | CLIENTE | nome | Busca rápida por nome |

| idx\_veiculo\_placa | VEICULO | placa | Busca por placa (UNIQUE) |

| idx\_veiculo\_cliente | VEICULO | id\_cliente | Listar veículos por cliente |

| idx\_mecanico\_especialidade | MECANICO | especialidade | Filtrar por especialidade |

| idx\_os\_veiculo | ORDEM\_SERVICO | id\_veiculo | Buscar OSs de um veículo |

| idx\_os\_equipe | ORDEM\_SERVICO | id\_equipe | Listar OSs de uma equipe |

| idx\_os\_status | ORDEM\_SERVICO | status | Filtrar por status |

| idx\_os\_data\_emissao | ORDEM\_SERVICO | data\_emissao | Buscar por período |

| idx\_servico\_os | SERVICO | numero\_os | Listar serviços de uma OS |

| idx\_peca\_descricao | PECA | descricao | Busca por descrição |



\---



\## 7. EXEMPLOS DE CONSULTAS ÚTEIS



\### Listar todas as OSs abertas

```sql

SELECT numero, data\_emissao, valor\_total, v.placa, e.nome\_equipe

FROM ORDEM\_SERVICO os

JOIN VEICULO v ON os.id\_veiculo = v.id

JOIN EQUIPE e ON os.id\_equipe = e.id

WHERE os.status = 'Aberta'

ORDER BY os.data\_emissao;

```



\### Ver serviços e peças de uma OS

```sql

SELECT s.id, s.descricao, s.valor\_mao\_obra, p.descricao as peca, sp.quantidade\_utilizada, p.valor\_unitario

FROM SERVICO s

LEFT JOIN SERVICO\_PECA sp ON s.id = sp.id\_servico

LEFT JOIN PECA p ON sp.id\_peca = p.id

WHERE s.numero\_os = 1;

```



\### Listar mecânicos de uma equipe

```sql

SELECT m.codigo, m.nome, m.especialidade, m.telefone

FROM MECANICO m

JOIN EQUIPE\_MECANICO em ON m.codigo = em.codigo\_mecanico

WHERE em.id\_equipe = 1;

```



\### Total de serviços realizados por cliente

```sql

SELECT c.nome, COUNT(os.numero) as total\_os, SUM(os.valor\_total) as valor\_total

FROM CLIENTE c

LEFT JOIN VEICULO v ON c.id = v.id\_cliente

LEFT JOIN ORDEM\_SERVICO os ON v.id = os.id\_veiculo

WHERE os.status = 'Concluída'

GROUP BY c.id, c.nome

ORDER BY valor\_total DESC;

```



\---



\## 8. NOTAS IMPORTANTES



\- \*\*Valor Total da OS:\*\* É calculado automaticamente via triggers. Sempre que um serviço ou peça é adicionado/removido, o total é recalculado.

\- \*\*Status da OS:\*\* Controle o fluxo de trabalho alterando este campo conforme os estágios de execução.

\- \*\*Data de Conclusão:\*\* Preenchida quando a OS é realmente concluída (não é automática).

\- \*\*Tabela de Referência de Mão-de-Obra:\*\* Atualmente o valor é inserido diretamente em SERVICO.valor\_mao\_obra. Se precisar de uma tabela separada com códigos de serviço, essa pode ser criada e referenciada.

\- \*\*Controle de Estoque:\*\* A tabela PECA armazena quantidade, mas o sistema não decrementa automaticamente. Isso pode ser feito via aplicação ou adicionar um trigger específico.



\---



\## 9. ESTRUTURA VISUAL



```

┌────────────┐

│  CLIENTE   │────┐

└────────────┘    │

&#x20;                 │ 1:N

&#x20;             ┌───┴─────────┐

&#x20;             │   VEICULO   │────┐

&#x20;             └─────────────┘    │

&#x20;                                │ 1:N

&#x20;                            ┌───┴──────────────────┐

&#x20;                            │ ORDEM\_SERVICO        │

&#x20;                            │ (número, valor, etc) │

&#x20;                            └───┬──────────────────┘

&#x20;                                │ 1:N

&#x20;                            ┌───┴──────────┐

&#x20;                            │   SERVICO    │

&#x20;                            │ (mão-de-obra)│

&#x20;                            └───┬──────────┘

&#x20;                                │ N:M

&#x20;                            ┌───┴──────────┐

&#x20;                            │ SERVICO\_PECA │

&#x20;                            └───┬──────────┘

&#x20;                                │

&#x20;                            ┌───┴──────────┐

&#x20;                            │     PECA     │

&#x20;                            │  (valor unit)│

&#x20;                            └──────────────┘



&#x20;    ┌──────────┐

&#x20;    │  EQUIPE  │────┐

&#x20;    └────┬─────┘    │

&#x20;         │ N:M      │ 1:N

&#x20;     ┌───┴──────────────────┐

&#x20;     │ EQUIPE\_MECANICO      │

&#x20;     └────┬──────────────────┘

&#x20;          │

&#x20;     ┌────┴─────────┐

&#x20;     │   MECANICO   │

&#x20;     │ (especialidade)

&#x20;     └──────────────┘

```



\---



\*\*Última atualização:\*\* 2026  

\*\*Versão:\*\* 1.0

