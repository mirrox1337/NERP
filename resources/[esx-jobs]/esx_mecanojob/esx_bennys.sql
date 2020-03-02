USE `essentialmode`;

INSERT INTO `addon_account` (name, label, shared) VALUES
  ('society_mecano','mecano',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  ('society_mecano','mecano',1)
;

INSERT INTO `jobs` (name, label) VALUES
  ('mecano','mecano')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('mecano',0,'recrue','Recrue',12,'{}','{}'),
  ('mecano',1,'novice','Novice',24,'{}','{}'),
  ('mecano',2,'experimente','Experimente',36,'{}','{}'),
  ('mecano',3,'chief','Chef d\'équipe',48,'{}','{}'),
  ('mecano',4,'boss','Patron',0,'{}','{}')
;