\# ⭐ 5 Melhorias Implementadas



\## 1. Tabela de Referência de Mão-de-Obra



\*\*O que é:\*\*

Tabela TABELA\_MAO\_OBRA com valores padrão de serviços.



\*\*Por que:\*\*

Rastreamento de preços históricos e auditoria completa.



\*\*Como funciona:\*\*

SERVICO tem campo id\_mao\_obra que aponta para TABELA\_MAO\_OBRA.id



\---



\## 2. Autorização do Cliente



\*\*O que é:\*\*

Campo autorizado\_cliente TINYINT em ORDEM\_SERVICO



\*\*Por que:\*\*

Não começar trabalho sem cliente autorizar.



\*\*Como funciona:\*\*

0 = Não autorizado

1 = Autorizado



\---



\## 3. Auditoria de Mudanças



\*\*O que é:\*\*

Campo data\_atualizacao TIMESTAMP em ORDEM\_SERVICO



\*\*Por que:\*\*

Saber quando OS foi modificada pela última vez.



\*\*Como funciona:\*\*

Atualiza automaticamente a cada mudança na OS.



\---



\## 4. Telefone e Email do Mecânico



\*\*O que é:\*\*

Campos telefone e email em MECANICO



\*\*Por que:\*\*

Contactar mecânico rapidamente.



\*\*Como funciona:\*\*

telefone VARCHAR(11)

email VARCHAR(100)



\---



\## 5. Nome Descritivo do Estoque



\*\*O que é:\*\*

Campo quantidade\_estoque em PECA



\*\*Por que:\*\*

Deixa claro que é quantidade EM ESTOQUE, não utilizada.



\*\*Como funciona:\*\*

Renomeado de "quantidade" para "quantidade\_estoque"

