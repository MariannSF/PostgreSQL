

select ga.date_subscript_1, 
	ga.account_subscript_2 ,
	(select gl.balance 
		from gl_amount_main gl
		where gl.account_subscript_2 = ga.account_subscript_2 
		and date_trunc ('month',gl.date_subscript_1::timestamp) = date_trunc('month',(ga.date_subscript_1::timestamp - '1 month'::interval))) ,
	ga.debit,
	ga.credit ,
	ga.balance ,
		(select date_trunc ('month',gl.date_subscript_1::timestamp)
				from gl_amount_main gl
				where gl.account_subscript_2 = ga.account_subscript_2 
				and date_trunc ('month',gl.date_subscript_1::timestamp) = date_trunc('month',(ga.date_subscript_1::timestamp - '1 month'::interval)))

from gl_amount_main ga
where account_subscript_2 ilike '%02.1010.1002%' and  date_subscript_1::timestamp between '2008-01-01' and '2008-03-31'





