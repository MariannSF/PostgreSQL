 SELECT 'MED'::character varying AS facility,
    t.post_to_date AS date_key,
    t.post_to_period_mis AS post_to_period,
    bc.cr_acct_subscript_3 AS acctnum,
    t.journal_mis_gl AS journal,
    t.date_1 AS date,
    ''::character varying AS debits,
    bc.cr_amount AS credits,
    bt.txn_description AS description
  
   FROM gl_batch_transactions bt
     LEFT JOIN gl_batch_credits bc ON bc.urn_subscript_1::text = bt.urn_subscript_1::text AND bt.txn_number::text = bc.lda_txn_number::text
     LEFT JOIN gl_batch_top t ON t.urn_subscript_1::text = bc.urn_subscript_1::text AND t.urn_subscript_1::text = bt.urn_subscript_1::text

          where 
          t.post_to_date ilike '01/31/2008' and 
		  cr_acct_subscript_3 ilike '%02.1020.1001%'

 
UNION ALL

 SELECT 'MED'::character varying AS facility,
    t.post_to_date AS date_key,
    ''::character varying AS post_to_period,
    bd.dr_acct_subscript_3 AS acctnum,
    t.journal_mis_gl AS journal,
    t.date_1 AS date,
    bd.dr_amount AS debits,
    ''::character varying AS credits,
    case when bt.txn_expand_desc is null then bt.txn_description else (bt.txn_description::text || ', '::text) || bt.txn_expand_desc::text  end AS description
	
   FROM gl_batch_transactions bt
     LEFT JOIN gl_batch_debits bd ON bd.urn_subscript_1::text = bt.urn_subscript_1::text AND bt.txn_number::text = bd.lda_txn_number::text
     LEFT JOIN gl_batch_top t ON t.urn_subscript_1::text = bd.urn_subscript_1::text AND t.urn_subscript_1::text = bt.urn_subscript_1::text

          where 
           t.post_to_date ilike '01/31/2008' and 
		   dr_acct_subscript_3 ilike '%02.1020.1001%'
 
UNION ALL

 SELECT 'MED'::character varying AS facility,
    t.post_to_date AS date_key,
    ''::character varying AS post_to_period,
    bc.cr_acct_subscript_3 AS acctnum,
    ''::character varying AS journal,
    ''::character varying AS date,
    ''::character varying AS debits,
    sum(bc.cr_amount::numeric)::character varying AS credits,
    bt.txn_description AS description
	
   FROM gl_batch_transactions bt
     LEFT JOIN gl_batch_credits bc ON bc.urn_subscript_1::text = bt.urn_subscript_1::text AND bt.txn_number::text = bc.lda_txn_number::text
     LEFT JOIN gl_batch_top t ON t.urn_subscript_1::text = bc.urn_subscript_1::text AND t.urn_subscript_1::text = bt.urn_subscript_1::text
 
       where 
        t.post_to_date ilike '01/31/2008' and 
		cr_acct_subscript_3 ilike '%02.1020.1001%'

  GROUP BY t.post_to_date, bc.cr_acct_subscript_3,bt.txn_description
 
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
    bt.txn_description AS description
	
   FROM gl_batch_transactions bt
     LEFT JOIN gl_batch_debits bd ON bd.urn_subscript_1::text = bt.urn_subscript_1::text AND bt.txn_number::text = bd.lda_txn_number::text
     LEFT JOIN gl_batch_top t ON t.urn_subscript_1::text = bd.urn_subscript_1::text AND t.urn_subscript_1::text = bt.urn_subscript_1::text

          where 
           t.post_to_date ilike '01/31/2008' and 
		   dr_acct_subscript_3 ilike '%02.1020.1001%'
 
  GROUP BY t.post_to_date, bd.dr_acct_subscript_3,bt.txn_description;