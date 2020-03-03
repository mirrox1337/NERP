INSERT INTO `jobs` (name, label) VALUES
  ('offpolice','Ej i tjänst'),
  ('offambulance','Ej i tjänst')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('offpolice',0,'recruit','Aspirant',12,'{}','{}'),
  ('offpolice',1,'officer','Assistant',24,'{}','{}'),
  ('offpolice',2,'sergeant','Inspektör',36,'{}','{}'),
  ('offpolice',3,'lieutenant','Kommissarie',48,'{}','{}'),
  ('offpolice',4,'boss','Polismästare',55,'{}','{}'),
  ('offambulance',0,'ambulance','AT-Läkare',12,'{}','{}'),
  ('offambulance',1,'doctor','ST-läkare',24,'{}','{}'),
  ('offambulance',2,'chief_doctor','Överläkare',36,'{}','{}'),
  ('offambulance',3,'boss','Sjukhusdirektör',48,'{}','{}')
;