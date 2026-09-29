-- =====================================================================
-- Recálculo automático de ORDEM_SERVICO.valor_total
-- valor_total = mão de obra (TABELA_MAO_OBRA.valor_referencia dos serviços)
--             + peças (quantidade_utilizada x PECA.valor_unitario)
-- Execute DEPOIS do 01_schema.sql e ANTES do 03_dados.sql
-- =====================================================================
USE oficina_mecanica;

DROP PROCEDURE IF EXISTS sp_recalcular_valor_os;
DROP TRIGGER IF EXISTS trg_servico_ai;
DROP TRIGGER IF EXISTS trg_servico_au;
DROP TRIGGER IF EXISTS trg_servico_ad;
DROP TRIGGER IF EXISTS trg_servico_peca_ai;
DROP TRIGGER IF EXISTS trg_servico_peca_au;
DROP TRIGGER IF EXISTS trg_servico_peca_ad;

DELIMITER $$

CREATE PROCEDURE sp_recalcular_valor_os(IN p_numero_os INT)
BEGIN
    UPDATE ORDEM_SERVICO
    SET valor_total =
          COALESCE((SELECT SUM(t.valor_referencia)
                    FROM SERVICO s
                    JOIN TABELA_MAO_OBRA t ON t.id = s.id_mao_obra
                    WHERE s.numero_os = p_numero_os), 0)
        + COALESCE((SELECT SUM(sp.quantidade_utilizada * p.valor_unitario)
                    FROM SERVICO s
                    JOIN SERVICO_PECA sp ON sp.id_servico = s.id
                    JOIN PECA p          ON p.id = sp.id_peca
                    WHERE s.numero_os = p_numero_os), 0)
    WHERE numero = p_numero_os;
END$$

-- Mudanças em SERVICO ------------------------------------------------
CREATE TRIGGER trg_servico_ai AFTER INSERT ON SERVICO
FOR EACH ROW
BEGIN
    CALL sp_recalcular_valor_os(NEW.numero_os);
END$$

CREATE TRIGGER trg_servico_au AFTER UPDATE ON SERVICO
FOR EACH ROW
BEGIN
    CALL sp_recalcular_valor_os(NEW.numero_os);
    IF OLD.numero_os <> NEW.numero_os THEN
        CALL sp_recalcular_valor_os(OLD.numero_os);
    END IF;
END$$

CREATE TRIGGER trg_servico_ad AFTER DELETE ON SERVICO
FOR EACH ROW
BEGIN
    CALL sp_recalcular_valor_os(OLD.numero_os);
END$$

-- Mudanças em SERVICO_PECA -------------------------------------------
CREATE TRIGGER trg_servico_peca_ai AFTER INSERT ON SERVICO_PECA
FOR EACH ROW
BEGIN
    DECLARE v_os INT;
    SELECT numero_os INTO v_os FROM SERVICO WHERE id = NEW.id_servico;
    CALL sp_recalcular_valor_os(v_os);
END$$

CREATE TRIGGER trg_servico_peca_au AFTER UPDATE ON SERVICO_PECA
FOR EACH ROW
BEGIN
    DECLARE v_os INT;
    SELECT numero_os INTO v_os FROM SERVICO WHERE id = NEW.id_servico;
    CALL sp_recalcular_valor_os(v_os);
END$$

CREATE TRIGGER trg_servico_peca_ad AFTER DELETE ON SERVICO_PECA
FOR EACH ROW
BEGIN
    DECLARE v_os INT;
    SELECT numero_os INTO v_os FROM SERVICO WHERE id = OLD.id_servico;
    IF v_os IS NOT NULL THEN
        CALL sp_recalcular_valor_os(v_os);
    END IF;
END$$

DELIMITER ;
