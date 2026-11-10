SELECT user.name, user.surname, etaireia.name, job.id, job.salary, COUNT(*) AS app_no 
FROM user, etaireia, job, applies, recruiter 
WHERE user.username=job.recruiter AND recruiter.username=user.username AND recruiter.firm = etaireia.AFM AND job.salary > 1900 AND job.id=applies.job_id 
GROUP BY applies.job_id 
 
 
SELECT candidate.username, candidate.certificates, COUNT(has_degree.grade) AS degrees_no, AVG(has_degree.grade) AS grade_avg 
FROM candidate, has_degree 
WHERE candidate.username=has_degree.cand_usrname 
GROUP BY has_degree.cand_usrname 
HAVING COUNT(has_degree.grade)>1
 
 
SELECT applies.cand_usrname, COUNT(applies.job_id) AS appl_no, AVG(job.salary) AS salaray_avg 
FROM applies, job 
WHERE applies.job_id=job.id 
GROUP BY applies.cand_usrname 
HAVING AVG(job.salary)>1800 
 
 
 SELECT etaireia.name, job.edra,job.position, requires.antikeim_title 
 FROM etaireia, job,requires, recruiter
 WHERE job.id=requires.job_id AND job.edra='Patra, Greece' AND job.position LIKE '%Program%' AND job.recruiter=recruiter.username AND recruiter.firm=etaireia.AFM
 
 
 SELECT job.recruiter, COUNT(job.recruiter) AS jobs_no, AVG(job.salary) AS salary_avg, COUNT(interviews.recruiter_username) AS interviews_no 
 FROM job LEFT JOIN interviews
 ON interviews.recruiter_username=job.recruiter
 GROUP BY job.recruiter, interviews.recruiter_username
 HAVING COUNT(job.recruiter)>=2
 ORDER BY AVG(job.salary) DESC
 
 
DELIMITER ;;
CREATE PROCEDURE a
(IN id INT(4))
BEGIN
  SELECT interviews.cand_username, COUNT(cand_username), SUM(interviews.personality)+SUM(interviews.education)+SUM(interviews.experience) AS total,SUM(interviews.personality),SUM(interviews.education),SUM(interviews.experience)
  FROM interviews, applies
  WHERE applies.job_id=id AND applies.cand_usrname=interviews.cand_username AND interviews.personality>0 AND interviews.education>0 AND interviews.experience>0 AND interviews.hmeromhnia > NOW()
  GROUP BY interviews.cand_username
  ORDER BY total;

  SELECT interviews.cand_username, CONCAT_WS("-",IF(interviews.personality=0,"failed the interview",""),IF(interviews.education=0,"inadequate education",""),IF(interviews.experience=0,"no prior experience","")) AS reason
  FROM interviews, applies
  WHERE applies.job_id=id AND applies.cand_usrname=interviews.cand_username AND (interviews.personality=0 OR interviews.education=0 OR interviews.experience=0  ) ;

END;;

DELIMITER ;;
CREATE TRIGGER i_candidate AFTER INSERT ON candidate
FOR EACH ROW
BEGIN
  INSERT INTO history(username,hmeromhnia,success,table_name,action)
  VALUES(SUSER_SNAME(), NOW(), 1, 'candidate', 'insert');
END;;

DELIMITER ;;
CREATE TRIGGER u_candidate AFTER UPDATE ON candidate
FOR EACH ROW
BEGIN
  INSERT INTO history(username,hmeromhnia,success,table_name,action)
  VALUES(SUSER_SNAME(), NOW(), 1, 'candidate', 'update');
END;;

DELIMITER ;;
CREATE TRIGGER d_candidate AFTER DELETE ON candidate
FOR EACH ROW
BEGIN
  INSERT INTO history(username,hmeromhnia,success,table_name,action)
  VALUES(SUSER_SNAME(), NOW(), 1, 'candidate', 'delete');
END;;
	
DELIMITER ;;	
CREATE TRIGGER i_recruiter AFTER INSERT ON recruiter
FOR EACH ROW
BEGIN
  INSERT INTO history(username,hmeromhnia,success,table_name,action)
  VALUES(SUSER_SNAME(), NOW(), 1, 'recruiter', 'insert');
END;;

DELIMITER ;;
CREATE TRIGGER u_recruiter AFTER UPDATE ON recruiter
FOR EACH ROW
BEGIN
  INSERT INTO history(username,hmeromhnia,success,table_name,action)
  VALUES(SUSER_SNAME(), NOW(), 1, 'recruiter', 'update');
END;;

DELIMITER ;;
CREATE TRIGGER d_recruiter AFTER DELETE ON recruiter
FOR EACH ROW
BEGIN
  INSERT INTO history(username,hmeromhnia,success,table_name,action)
  VALUES(SUSER_SNAME(), NOW(), 1, 'recruiter', 'delete');
END;;

DELIMITER ;;
CREATE TRIGGER i_user AFTER INSERT ON `user`
FOR EACH ROW
BEGIN
  INSERT INTO history(username,hmeromhnia,success,table_name,action)
  VALUES(SUSER_SNAME(), NOW(), 1, 'user', 'insert');
END;;

DELIMITER ;;
CREATE TRIGGER u_user AFTER UPDATE ON `user`
FOR EACH ROW
BEGIN
  INSERT INTO history(username,hmeromhnia,success,table_name,action)
  VALUES(SUSER_SNAME(), NOW(), 1, 'user', 'update');
END;;

DELIMITER ;;
CREATE TRIGGER d_user AFTER DELETE ON `user`
FOR EACH user
BEGIN
  INSERT INTO history(username,hmeromhnia,success,table_name,action)
  VALUES(SUSER_SNAME(), NOW(), 1, 'user', 'delete');
END;;

DELIMITER ;;
CREATE TRIGGER i_etaireia AFTER INSERT ON `etaireia`
FOR EACH ROW
BEGIN
  INSERT INTO history(username,hmeromhnia,success,table_name,action)
  VALUES(SUSER_SNAME(), NOW(), 1, 'etaireia', 'insert');
END;;

DELIMITER ;;
CREATE TRIGGER u_etaireia AFTER UPDATE ON `etaireia`
FOR EACH ROW
BEGIN
  INSERT INTO history(username,hmeromhnia,success,table_name,action)
  VALUES(SUSER_SNAME(), NOW(), 1, 'etaireia', 'update');
END;;

DELIMITER ;;
CREATE TRIGGER u_etaireia2 BEFORE UPDATE ON `etaireia`
FOR EACH ROW
BEGIN
  SET NEW.AFM = OLD.AFM;
  SET NEW.DOY = OLD.DOY;
  SET NEW.name = OLD.name;
END;;

DELIMITER ;;
CREATE TRIGGER d_etaireia AFTER DELETE ON `etaireia`
FOR EACH user
BEGIN
  INSERT INTO history(username,hmeromhnia,success,table_name,action)
  VALUES(SUSER_SNAME(), NOW(), 1, 'etaireia', 'delete');
END;;

DELIMITER ;;
CREATE TRIGGER i_job AFTER INSERT ON `job`
FOR EACH ROW
BEGIN
  INSERT INTO history(username,hmeromhnia,success,table_name,action)
  VALUES(SUSER_SNAME(), NOW(), 1, 'job', 'insert');
END;;

DELIMITER ;;
CREATE TRIGGER u_job AFTER UPDATE ON `job`
FOR EACH ROW
BEGIN
  INSERT INTO history(username,hmeromhnia,success,table_name,action)
  VALUES(SUSER_SNAME(), NOW(), 1, 'job', 'update');
END;;

DELIMITER ;;
CREATE TRIGGER d_job AFTER DELETE ON `job`
FOR EACH user
BEGIN
  INSERT INTO history(username,hmeromhnia,success,table_name,action)
  VALUES(SUSER_SNAME(), NOW(), 1, 'job', 'delete');
END;;

DELIMITER ;;
CREATE TRIGGER PreventAppliesDeletion
BEFORE DELETE ON applies
FOR EACH ROW
BEGIN
  IF old.job_id IN (SELECT id FROM jobs WHERE submission_date<NOW()) THEN -- abort deletion
    SIGNAL SQLSTATE '45000' -- "unhandled user-defined exception"
      -- custom error message that will be returned by MySQL
      SET MESSAGE_TEXT = 'You are not allowed to remove this record!!';
  END IF;
END;;
