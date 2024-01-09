-- Задание 3
-- Вывести списки групп по заданному направлению с указание номера группы в формате ФИО, бюджет/внебюджет. Студентов выводить в алфавитном порядке.

SELECT `Student`.`FIO` as `Full name`, 
		`Groups`.`group_name` as `Group name`, 
		if (`Student`.`budjet` = 1, "Бюджет", "Внебюджет") as `budjet`
FROM `Student`
JOIN `Groups` ON `Groups`.`id` = `Student`.`group_id`
ORDER BY `Student`.`FIO`;
 
-- Вывести студентов с фамилией, начинающейся с первой буквы вашей фамилии, с указанием ФИО, номера группы и направления обучения.

SELECT `Student`.`FIO` as `Full name`,
		`Groups`.`group_name` as `Group name`,
        `directions_of_study`.`direction_name` as `direction name`
FROM `Student`
JOIN `Groups` ON `Groups`.`id` = `Student`.`group_id`
JOIN `directions_of_study` ON `directions_of_study`.`id` = `Groups`.`direction_id`
WHERE `Student`.`FIO` LIKE "К%";

-- Вывести список студентов для поздравления по месяцам в формате Фамилия И.О., день и название месяца рождения, номером группы и направлением обучения.

SELECT 
CONCAT(LEFT(`FIO`, LOCATE(' ', `FIO`)),
       CONCAT(LEFT(RIGHT(`FIO`, CHAR_LENGTH(`FIO`) - LOCATE(' ', `FIO`)), 1), '. '),
      CONCAT(LEFT(RIGHT(`FIO`, CHAR_LENGTH(`FIO`) - LOCATE(' ', `FIO`, (LOCATE(' ', `FIO`) + 1))), 1), '.')) 
as `Name`,
DAYOFMONTH(`Student`.`date_of_birth`) as `Day`,
CASE
	WHEN MONTHNAME(`Student`.`date_of_birth`) = "January" 
    	THEN "Январь"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "February" 
    	THEN "Февраль"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "March" 
    	THEN "Март"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "April" 
    	THEN "Апрель"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "May" 
    	THEN "Май"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "June" 
    	THEN "Июнь"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "July" 
    	THEN "Июль"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "August" 
    	THEN "Август"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "September" 
    	THEN "Сентябрь"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "October" 
    	THEN "Октябрь"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "November" 
    	THEN "Ноябрь"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "December" 
    	THEN "Декабрь"
 END AS 'Month',
`Groups`.`group_name` as `Group name`,
`directions_of_study`.`direction_name` as `direction name`
FROM `Student`
JOIN `Groups` ON `Groups`.`id` = `Student`.`group_id`
JOIN `directions_of_study` ON `directions_of_study`.`id` = `Groups`.`direction_id`
ORDER BY MONTH(`Student`.`date_of_birth`); 

-- Вывести студентов с указанием возраста в годах.

SELECT FIO, (YEAR(CURRENT_DATE()) - YEAR(date_of_birth)) as Age
FROM Student;

-- Вывести студентов, у которых день рождения в текущем месяце.

SELECT `FIO` as `Name`, `date_of_birth` as `Birthday`
FROM `Student`
WHERE MONTH(`Student`.`date_of_birth`) = MONTH(CURRENT_DATE());

-- Вывести количество студентов по каждому направлению.

SELECT COUNT(`Student`.`id`) as `Students number`, `directions_of_study`.`direction_name` as `direction name`
FROM `Student`
JOIN `Groups` ON `Groups`.`id` = `Student`.`group_id`
JOIN `directions_of_study` ON `directions_of_study`.`id` = `Groups`.`direction_id`
GROUP BY `directions_of_study`.`direction_name`;

-- Вывести количество бюджетных и внебюджетных мест по группам. Для каждой группы вывести номер и название направления.

SELECT 
	Groups.group_name, 
    directions_of_study.direction_name, 
	COUNT(CASE WHEN budjet = true THEN 1 ELSE 0 END) as number_of_buget 
FROM Student
	JOIN Groups ON Groups.id = Student.group_id
    JOIN directions_of_study ON directions_of_study.id = Groups.direction_id
GROUP BY Groups.id


-- Задание 5
-- Вывести списки групп по каждому предмету с указанием преподавателя.

SELECT `course`.`name`, `Groups`.`group_name`,`Teachers`.`name`
FROM `course`
JOIN `directioncourseTeacher` ON `directioncourseTeacher`.`course_id` = `course`.`id`
JOIN `directions_of_study` ON `directions_of_study`.`id` = `directioncourseTeacher`.`direction_id`
JOIN `Groups` ON `Groups`.`direction_id` = `directions_of_study`.`id`
JOIN `Teachers` ON `Teachers`.`id` = `directioncourseTeacher`.`teacher_id`

-- Определить, какую дисциплину изучает максимальное количество студентов.

SELECT `course`.`name` as `disc_name`, COUNT(`Student`.`FIO`) as `s_num`
FROM `course`
JOIN `directioncourseTeacher` ON `directioncourseTeacher`.`course_id` = `course`.`id`
JOIN `Marks` ON `Marks`.`sub_cour_teach_id` = `directioncourseTeacher`.`id`
JOIN `Student` ON `Marks`.`student_id` = `Student`.`id`
GROUP BY `course`.`name`
ORDER BY COUNT(`Student`.`FIO`) DESC 
LIMIT 1

-- Определить сколько студентов обучатся у каждого их преподавателей.

SELECT `Teachers`.`name`, COUNT(`Student`.`id`) as `s_num`
FROM `Teachers`
JOIN `directioncourseTeacher` ON `directioncourseTeacher`.`teacher_id` = `Teachers`.`id`
JOIn `Marks` ON `Marks`.`sub_cour_teach_id` = `directioncourseTeacher`.`id`
JOIN `Student` ON `Student`.`id` = `Marks`.`student_id`
GROUP BY `Teachers`.`name`

-- Определить долю сдавших студентов по каждой дисциплине (не оценки или 2 считать не сдавшими).

SELECT `course`.`name` as `disc_name`, COUNT(IF(`Marks`.`mark` > 2, 1, NULL)) as `s_num`
FROM `course`
JOIN `directioncourseTeacher` ON `directioncourseTeacher`.`course_id` = `course`.`id`
JOIN `Marks` ON `Marks`.`sub_cour_teach_id` = `directioncourseTeacher`.`id`
JOIN `Student` ON `Marks`.`student_id` = `Student`.`id`
GROUP BY `course`.`name`
ORDER BY COUNT(`Student`.`FIO`) DESC

-- Определить среднюю оценку по предметам (для сдавших студентов)

SELECT `course`.`name` as `disc_name`, AVG(IF(`Marks`.`mark` > 2, `Marks`.`mark`, NULL)) as `s_avg`
FROM `course`
JOIN `directioncourseTeacher` ON `directioncourseTeacher`.`course_id` = `course`.`id`
JOIN `Marks` ON `Marks`.`sub_cour_teach_id` = `directioncourseTeacher`.`id`
JOIN `Student` ON `Marks`.`student_id` = `Student`.`id`
GROUP BY `course`.`name`
ORDER BY COUNT(`Student`.`FIO`) DESC

-- Определить группу с максимальной средней оценкой (включая не сдавших)

SELECT `Groups`.`group_name`, AVG(`Marks`.`mark`) as `average_mark`
FROM `Groups`
JOIN `directions_of_study` ON `directions_of_study`.`id` = `Groups`.`direction_id`
JOIN `directioncourseTeacher` ON `directioncourseTeacher`.`direction_id` = `directions_of_study`.`id`
JOIN `Marks` ON `Marks`.`sub_cour_teach_id` = `directioncourseTeacher`.`id`
GROUP BY `Groups`.`group_name`
LIMIT 1

-- Вывести студентов со всем оценками отлично и не имеющих несданный экзамен

SELECT Student.FIO, AVG(Marks.mark)
FROM Student
JOIN Marks ON Marks.student_id = Student.id
GROUP BY Student.FIO
HAVING AVG(Marks.mark) = 5.0;

-- Вывести кандидатов на отчисление (не сдан не менее двух предметов)

SELECT Student.FIO
FROM Student
JOIN Marks ON Marks.student_id = Student.id
WHERE Marks.mark = 2
GROUP BY Student.FIO
HAVING COUNT(*)>1



-- Задание 7
-- Вывести по заданному предмету количество посещенных занятий.

SELECT COUNT(visiting.id) as num_presense 
FROM course
JOIN directioncourseTeacher ON directioncourseTeacher.course_id = course.id
JOIN Lessons_timing ON Lessons_timing.sub_cour_teach_id = directioncourseTeacher.id
JOIN visiting ON visiting.tiiming_id = Lessons_timing.id
WHERE course.name = "Анализ данных" AND visiting.presense = true
GROUP BY visiting.presense;

-- Вывести по заданному предмету количество пропущенных занятий.

SELECT COUNT(visiting.id) as num_presense 
FROM course
JOIN directioncourseTeacher ON directioncourseTeacher.course_id = course.id
JOIN Lessons_timing ON Lessons_timing.sub_cour_teach_id = directioncourseTeacher.id
JOIN visiting ON visiting.tiiming_id = Lessons_timing.id
WHERE course.name = "Анализ данных" AND visiting.presense = false
GROUP BY visiting.presense;

-- • Вывести по заданному преподавателю количество студентов на каждом занятии.

SELECT COUNT(visiting.id) as num_presense, directioncourseTeacher.id
FROM Teachers
JOIN directioncourseTeacher ON directioncourseTeacher.teacher_id = Teachers.id
JOIN Lessons_timing ON Lessons_timing.sub_cour_teach_id = directioncourseTeacher.id
JOIN visiting ON visiting.tiiming_id = Lessons_timing.id
WHERE Teachers.name = "Ковригин Алексей Викторович" AND visiting.presense = true
GROUP BY Lessons_timing.sub_cour_teach_id;

-- • Для каждого студента вывести общее время, потраченное на изучение каждого предмета.

SELECT
Student.id AS student_id, Student.FIO AS student_name, directions_of_study.direction_name AS direction_name, course.name AS course_name, 
SUM(TIME_TO_SEC(Time_to_Pair.time_end) - TIME_TO_SEC(Time_to_Pair.time_start)) AS total_study_time
FROM Student
JOIN Groups ON Student.group_id = Groups.id
JOIN directions_of_study ON Groups.direction_id = directions_of_study.id
JOIN directioncourseTeacher ON directions_of_study.id = directioncourseTeacher.direction_id
JOIN course ON directioncourseTeacher.course_id = course.id
JOIN Lessons_timing ON directioncourseTeacher.id = Lessons_timing.sub_cour_teach_id
JOIN Time_to_Pair ON Lessons_timing.time_id = Time_to_Pair.id
JOIN visiting ON Lessons_timing.id = visiting.tiiming_id AND Student.id = visiting.student_id AND visiting.presense = true
GROUP BY Student.id, directions_of_study.id, course.id;

