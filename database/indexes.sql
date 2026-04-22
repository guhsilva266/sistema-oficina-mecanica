-- ================================================
-- ÍNDICES ADICIONAIS PARA PERFORMANCE
-- ================================================

CREATE INDEX idx_cliente_nome ON CLIENTE(nome);
CREATE INDEX idx_veiculo_placa ON VEICULO(placa);
CREATE INDEX idx_veiculo_cliente ON VEICULO(id_cliente);
CREATE INDEX idx_mecanico_especialidade ON MECANICO(especialidade);
CREATE INDEX idx_mecanico_nome ON MECANICO(nome);
CREATE INDEX idx_os_status ON ORDEM_SERVICO(status);
CREATE INDEX idx_os_data_emissao ON ORDEM_SERVICO(data_emissao);
CREATE INDEX idx_os_veiculo ON ORDEM_SERVICO(id_veiculo);
CREATE INDEX idx_os_equipe ON ORDEM_SERVICO(id_equipe);
CREATE INDEX idx_os_autorizado ON ORDEM_SERVICO(autorizado_cliente);
CREATE INDEX idx_os_data_conclusao ON ORDEM_SERVICO(data_conclusao);
CREATE INDEX idx_servico_os ON SERVICO(numero_os);
CREATE INDEX idx_servico_mao_obra ON SERVICO(id_mao_obra);
CREATE INDEX idx_peca_descricao ON PECA(descricao);
CREATE INDEX idx_peca_ativo ON PECA(ativo);
CREATE INDEX idx_peca_valor ON PECA(valor_unitario);
CREATE INDEX idx_tabela_mao_obra_ativo ON TABELA_MAO_OBRA(ativo);
CREATE INDEX idx_mao_obra_descricao ON TABELA_MAO_OBRA(descricao_servico);
CREATE INDEX idx_equipe_nome ON EQUIPE(nome_equipe);
CREATE INDEX idx_equipe_mecanico_ativo ON EQUIPE_MECANICO(ativo);