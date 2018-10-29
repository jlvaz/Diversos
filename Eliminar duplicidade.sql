DELETE FROM
   t_aluno_curso_moodle_unifeso A
WHERE
  a.rowid >
   ANY (
     SELECT
        B.rowid
     FROM
        t_aluno_curso_moodle_unifeso B
     WHERE
        A.endereco_fisico = B.endereco_fisico
        ); 
