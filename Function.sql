
-- Function: get_linked_MRI_PAT(character varying, integer)

-- DROP FUNCTION get_linked_MRI_PAT(character varying, integer);

CREATE OR REPLACE FUNCTION get_linked_mrn(character varying,integer)
  RETURNS character varying AS
$BODY$

declare MRI_PAT varchar;
   Uinput ALIAS FOR $1;
   OUTPUT varchar;
   flag alias for $2;
   
begin
--1
	if(flag = 1) then
		begin
			SELECT mergedto_mripat, lda_mrn into MRI_PAT, OUTPUT
			from mri_final.mri_pat_main
			where lda_mrn = Uinput;
		end;
	else
		begin
			SELECT mergedto_mripat, lda_mrn into MRI_PAT, OUTPUT
			from mri_final.mri_pat_main
			where medicalrecord_subscript_1 = Uinput; --after the FIRST run, Uinput will hold mergedto_mripat. it's the same as saying OUTPUT = mergedto_mripat
		end;	
	end if;

	if(MRI_PAT IS NOT NULL) then
	BEGIN
		select * into OUTPUT from get_linked_mrn(MRI_PAT,2); --recursively calls the 'get_linked_mrn' function until the MRI_PAT is not null
	END;
	END IF;
	
return OUTPUT; -- when MRI_PAT is null returns output

end;
$BODY$ LANGUAGE plpgsql;


select get_linked_mrn('000000470194',1)

