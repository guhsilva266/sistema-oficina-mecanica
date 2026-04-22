\# 🔧 Sistema de Oficina Mecânica



> Sistema de controle e gerenciamento de execução de ordens de serviço em oficina mecânica.



\## 📊 O que tem aqui?



\- ✅ 10 tabelas bem estruturadas

\- ✅ 5 triggers automáticos

\- ✅ 15+ índices para performance

\- ✅ 5 melhorias implementadas

\- ✅ Diagrama ER completo

\- ✅ Documentação profissional



\## 🚀 Como usar?



1\. Abra MySQL Workbench

2\. Execute o arquivo `database/schema.sql`

3\. Pronto! Seu banco está criado



\## 📁 Estrutura



sistema-oficina-mecanica/

├── README.md (este arquivo)

├── LICENSE (licença MIT)

├── DIAGRAMA\_ER.png (imagem do diagrama)

├── database/

│   ├── schema.sql (criação das tabelas)

│   ├── triggers.sql (triggers automáticos)

│   ├── indexes.sql (índices)

│   └── sample\_data.sql (dados de teste)

└── docs/

├── DOCUMENTACAO.md

├── MELHORIAS\_IMPLEMENTADAS.md

└── GUIA\_USO.md



\## 📋 Tabelas Criadas



1\. CLIENTE

2\. VEICULO

3\. TABELA\_MAO\_OBRA

4\. MECANICO

5\. EQUIPE

6\. EQUIPE\_MECANICO

7\. ORDEM\_SERVICO

8\. SERVICO

9\. PECA

10\. SERVICO\_PECA



\## ⭐ 5 Melhorias Implementadas



1\. \*\*Tabela de Referência de Mão-de-Obra\*\* - SERVICO ligado a TABELA\_MAO\_OBRA

2\. \*\*Autorização do Cliente\*\* - Campo autorizado\_cliente em ORDEM\_SERVICO

3\. \*\*Auditoria de Mudanças\*\* - Campo data\_atualizacao em ORDEM\_SERVICO

4\. \*\*Dados de Contato\*\* - Telefone e email em MECANICO

5\. \*\*Estoque Descritivo\*\* - quantidade\_estoque em PECA



\## 📄 Licença



MIT License - Veja LICENSE para detalhes



\---



\*\*Versão:\*\* 3.0  

\*\*Status:\*\* ✅ Completo e Pronto para Uso

