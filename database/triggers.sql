-- ================================================
-- TRIGGERS - CÁLCULO AUTOMÁTICO DE VALOR TOTAL
-- ================================================

DELIMITER $$

-- Trigger 1: Inserir serviço
CREATE TRIGGER atualizar_valor_os_insert_servico
AFTER INSERT ON SERVICO
FOR EACH ROW
BEGIN
    UPDATE ORDEM_SERVICO
    SET valor_total = (
        SELECT COALESCE(SUM(s.valor_mao_obra), 0) +
               COALESCE((
                   SELECT SUM(sp.quantidade_utilizada * p.valor_unitario)
                   FROM SERVICO_PECA sp
                   JOIN PECA p ON sp.id_peca = p.id
                   WHERE sp.id_servico IN (SELECT id FROM SERVICO WHERE numero_os = NEW.numero_os)
               ), 0)
        FROM SERVICO s
        WHERE s.numero_os = NEW.numero_os
    ),
    data_atualizacao = CURRENT_TIMESTAMP
    WHERE numero = NEW.numero_os;
END$$

-- Trigger 2: Deletar serviço
CREATE TRIGGER atualizar_valor_os_delete_servico
AFTER DELETE ON SERVICO
FOR EACH ROW
BEGIN
    UPDATE ORDEM_SERVICO
    SET valor_total = (
        SELECT COALESCE(SUM(s.valor_mao_obra), 0) +
               COALESCE((
                   SELECT SUM(sp.quantidade_utilizada * p.valor_unitario)
                   FROM SERVICO_PECA sp
                   JOIN PECA p ON sp.id_peca = p.id
                   WHERE sp.id_servico IN (SELECT id FROM SERVICO WHERE numero_os = OLD.numero_os)
               ), 0)
        FROM SERVICO s
        WHERE s.numero_os = OLD.numero_os
    ),
    data_atualizacao = CURRENT_TIMESTAMP
    WHERE numero = OLD.numero_os;
END$$

-- Trigger 3: Inserir peça em serviço
CREATE TRIGGER atualizar_valor_os_insert_peca
AFTER INSERT ON SERVICO_PECA
FOR EACH ROW
BEGIN
    UPDATE ORDEM_SERVICO
    SET valor_total = (
        SELECT COALESCE(SUM(s.valor_mao_obra), 0) +
               COALESCE((
                   SELECT SUM(sp.quantidade_utilizada * p.valor_unitario)
                   FROM SERVICO_PECA sp
                   JOIN PECA p ON sp.id_peca = p.id
                   WHERE sp.id_servico IN (SELECT id FROM SERVICO WHERE numero_os = s.numero_os)
               ), 0)
        FROM SERVICO s
        WHERE s.numero_os = (SELECT numero_os FROM SERVICO WHERE id = NEW.id_servico)
    ),
    data_atualizacao = CURRENT_TIMESTAMP
    WHERE numero = (SELECT numero_os FROM SERVICO WHERE id = NEW.id_servico);
END$$

-- Trigger 4: Deletar peça de serviço
CREATE TRIGGER atualizar_valor_os_delete_peca
AFTER DELETE ON SERVICO_PECA
FOR EACH ROW
BEGIN
    UPDATE ORDEM_SERVICO
    SET valor_total = (
        SELECT COALESCE(SUM(s.valor_mao_obra), 0) +
               COALESCE((
                   SELECT SUM(sp.quantidade_utilizada * p.valor_unitario)
                   FROM SERVICO_PECA sp
                   JOIN PECA p ON sp.id_peca = p.id
                   WHERE sp.id_servico IN (SELECT id FROM SERVICO WHERE numero_os = s.numero_os)
               ), 0)
        FROM SERVICO s
        WHERE s.numero_os = (SELECT numero_os FROM SERVICO WHERE id = OLD.id_servico)
    ),
    data_atualizacao = CURRENT_TIMESTAMP
    WHERE numero = (SELECT numero_os FROM SERVICO WHERE id = OLD.id_servico);
END$$

-- Trigger 5: Atualizar valor de serviço
CREATE TRIGGER atualizar_valor_os_update_servico
AFTER UPDATE ON SERVICO
FOR EACH ROW
BEGIN
    UPDATE ORDEM_SERVICO
    SET valor_total = (
        SELECT COALESCE(SUM(s.valor_mao_obra), 0) +
               COALESCE((
                   SELECT SUM(sp.quantidade_utilizada * p.valor_unitario)
                   FROM SERVICO_PECA sp
                   JOIN PECA p ON sp.id_peca = p.id
                   WHERE sp.id_servico IN (SELECT id FROM SERVICO WHERE numero_os = NEW.numero_os)
               ), 0)
        FROM SERVICO s
        WHERE s.numero_os = NEW.numero_os
    ),
    data_atualizacao = CURRENT_TIMESTAMP
    WHERE numero = NEW.numero_os;
END$$

DELIMITER ;