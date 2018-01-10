

-- DROP VIEW med_trial_balance;

CREATE OR REPLACE VIEW med_trial_balance AS 
 
 SELECT 'MED'::character varying AS facility,
    t.post_to_date AS date_key,
    t.post_to_period_mis AS post_to_period,
    bc.cr_acct_subscript_3 AS acctnum,
    t.journal_mis_gl AS journal,
    t.date_1 AS date,
    ''::character varying AS debits,
    bc.cr_amount AS credits,
    'V# VENDOR I# 00000, Remit to: GENERAL'::VARCHAR AS description
   
   FROM gl_batch_transactions bt
     LEFT JOIN gl_batch_credits bc ON bc.urn_subscript_1::text = bt.urn_subscript_1::text AND bt.txn_number::text = bc.lda_txn_number::text
     LEFT JOIN gl_batch_top t ON t.urn_subscript_1::text = bc.urn_subscript_1::text AND t.urn_subscript_1::text = bt.urn_subscript_1::text
	 
UNION ALL

 SELECT 'MED'::character varying AS facility,
    t.post_to_date AS date_key,
    ''::character varying AS post_to_period,
    bd.dr_acct_subscript_3 AS acctnum,
    t.journal_mis_gl AS journal,
    t.date_1 AS date,
    bd.dr_amount AS debits,
    ''::character varying AS credits,
        'V# VENDOR I# 00000, Remit to: GENERAL'::VARCHAR AS description

   FROM gl_batch_transactions bt
     LEFT JOIN gl_batch_debits bd ON bd.urn_subscript_1::text = bt.urn_subscript_1::text AND bt.txn_number::text = bd.lda_txn_number::text
     LEFT JOIN gl_batch_top t ON t.urn_subscript_1::text = bd.urn_subscript_1::text AND t.urn_subscript_1::text = bt.urn_subscript_1::text

UNION ALL

 SELECT 'MED'::character varying AS facility,
    t.post_to_date AS date_key,
    ''::character varying AS post_to_period,
    bc.cr_acct_subscript_3 AS acctnum,
    ''::character varying AS journal,
    ''::character varying AS date,
    ''::character varying AS debits,
    sum(bc.cr_amount::numeric)::character varying AS credits,
    ''::character varying AS description
	
   FROM gl_batch_transactions bt
     LEFT JOIN gl_batch_credits bc ON bc.urn_subscript_1::text = bt.urn_subscript_1::text AND bt.txn_number::text = bc.lda_txn_number::text
     LEFT JOIN gl_batch_top t ON t.urn_subscript_1::text = bc.urn_subscript_1::text AND t.urn_subscript_1::text = bt.urn_subscript_1::text
  
  GROUP BY t.post_to_date, bc.cr_acct_subscript_3
  
UNION ALL

 SELECT 'MED'::character varying AS facility,
    t.post_to_date AS date_key,
    ''::character varying AS post_to_period,
    bd.dr_acct_subscript_3 AS acctnum,
    ''::character varying AS journal,
    ''::character varying AS date,
        CASE
            WHEN sum(bd.dr_amount::numeric)::character varying IS NULL THEN ''::character varying
            ELSE sum(bd.dr_amount::numeric)::character varying
        END AS debits,
    ''::character varying AS credits,
    ''::character varying AS description
	
   FROM gl_batch_transactions bt
     LEFT JOIN gl_batch_debits bd ON bd.urn_subscript_1::text = bt.urn_subscript_1::text AND bt.txn_number::text = bd.lda_txn_number::text
     LEFT JOIN gl_batch_top t ON t.urn_subscript_1::text = bd.urn_subscript_1::text AND t.urn_subscript_1::text = bt.urn_subscript_1::text
	 
  GROUP BY t.post_to_date, bd.dr_acct_subscript_3;

ALTER TABLE med_trial_balance
  OWNER TO devusers;


