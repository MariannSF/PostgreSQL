

--drop view part_anc_patientlist_byName
 CREATE OR REPLACE VIEW part_anc_patientlist_byName AS 
 
Select 
'FH'::varchar as facility,
get_linked_mrn(lda_mrn, 1) as mrn,
get_linked_mrn(lda_mrn, 1) as active_mrn,
lda_mrn as old_mrn,
 get_linked_name(mp.name) as list_of_mrns,--here should be the list of mrns
--lda_active_mrn as mrn,
mp.name as pname,
mfunitnumber,
lda_last_name,
lda_first_name,
case when lda_middle_name is null then '' else lda_middle_name end as lda_middle_name,
case when mp.birthdate is null then '' else to_date(mp.birthdate, 'YYYYMMDD')::varchar end as birthdate, 
upper(mp.sex)as sex,
(date_trunc('year',age( mp.birthdate::timestamp)))::varchar as age,
case when mp.maidenothername is null then '' else mp.maidenothername end as maidenothername ,
md.medicalrecord_subscript1,
patstreet,
case when patstreet2 is null then '' else patstreet2 end as patstreet2,
patcity,
patstate,
patzip,
pathomephone,
case when patotherphone is null then '' else patotherphone end as patotherphone ,
maritalstatus_mismarstatus,
religion,
guarname,
guarstreet,
case when guarstreet2 is null then '' else guarstreet2 end as guarstreet2,
guarcity,
guarstate,
guarzip,
guarhomephone,
guarsocsecnumber,
case when confidential is null then '' else confidential end as confidential,

(select x.cdresponse 
	from mri_08082016.mri_drc_customer_defined_queries x 
	where cdquery_subscript2 ilike 'Ethnicity' and  x.medicalrecord_subscript1 = mp.medicalrecord_subscript_1)||'   '::varchar ||
	(
		SELECT elementresponse
		FROM mis_07052016.mis_group_resp_group_elements
		WHERE elementmnemonic_subscript_2 = (
				select x.cdresponse 
				from mri_08082016.mri_drc_customer_defined_queries x 
				where cdquery_subscript2 ilike 'Ethnicity' 
					and  x.medicalrecord_subscript1 = mp.medicalrecord_subscript_1
				
				)
		) as ethnicity,

(select x.cdresponse 
	from mri_08082016.mri_drc_customer_defined_queries x 
	where cdquery_subscript2 ilike 'Race1' and  x.medicalrecord_subscript1 = mp.medicalrecord_subscript_1)||'   '::varchar||
	(
		SELECT elementresponse
		FROM mis_07052016.mis_group_resp_group_elements
		WHERE elementmnemonic_subscript_2 = (
				select x.cdresponse 
				from mri_08082016.mri_drc_customer_defined_queries x 
				where cdquery_subscript2 ilike 'Race1' 
					and  x.medicalrecord_subscript1 = mp.medicalrecord_subscript_1
				
				)
		) as race,	
	
(select x.cdresponse 
	from mri_08082016.mri_drc_customer_defined_queries x 
	where cdquery_subscript2 ilike 'ctry%codes' and  x.medicalrecord_subscript1 = mp.medicalrecord_subscript_1)||'   '::varchar|| 
	(
		SELECT elementresponse
		FROM mis_07052016.mis_group_resp_group_elements
		WHERE elementmnemonic_subscript_2 = (
				SELECT x.cdresponse
				FROM mri_08082016.mri_drc_customer_defined_queries x
				WHERE cdquery_subscript2 ilike 'ctry%codes'
					AND x.medicalrecord_subscript1 = mp.medicalrecord_subscript_1
				)
		)as Country_code,
		
(select x.cdresponse 
	from mri_08082016.mri_drc_customer_defined_queries x 
	where cdquery_subscript2 ilike 'admpl' and  x.medicalrecord_subscript1 = mp.medicalrecord_subscript_1)||'   '::varchar||
	 (
		SELECT elementresponse
		FROM mis_07052016.mis_group_resp_group_elements
		WHERE elementmnemonic_subscript_2 = (
				select x.cdresponse 
				from mri_08082016.mri_drc_customer_defined_queries x 
				where cdquery_subscript2 ilike 'admpl' 
					and  x.medicalrecord_subscript1 = mp.medicalrecord_subscript_1
				
				)and mnemonic_subscript_1 ilike 'ADMPL%'
		)
	 as  priary_language,
	
(select x.cdresponse 
	from mri_08082016.mri_drc_customer_defined_queries x 
	where cdquery_subscript2 ilike 'admvet' and  x.medicalrecord_subscript1 = mp.medicalrecord_subscript_1) as veteran	

FROM mri_final.mri_pat_main mp
LEFT JOIN mri_08082016.mri_drc_main md ON mp.medicalrecord_subscript_1 = md.medicalrecord_subscript1

	where mfunitnumber IS NOT NULL;

   ALTER TABLE part_anc_patientlist_byName
  OWNER TO appuser_phcs_02_38;
