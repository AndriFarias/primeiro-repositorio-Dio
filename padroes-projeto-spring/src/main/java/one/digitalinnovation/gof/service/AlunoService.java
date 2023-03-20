package one.digitalinnovation.gof.service;

import one.digitalinnovation.gof.model.Aluno;


public interface AlunoService {

	Iterable<Aluno> buscarTodos();

	Aluno buscarPorId(Long id);

	void inserir(Aluno aluno);

	void atualizar(Long id, Aluno aluno);

	void deletar(Long id);

}
