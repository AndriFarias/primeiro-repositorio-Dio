package one.digitalinnovation.gof.service.impl;

import java.util.Optional;

import one.digitalinnovation.gof.model.Aluno;

import one.digitalinnovation.gof.model.AlunoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import one.digitalinnovation.gof.model.Endereco;
import one.digitalinnovation.gof.model.EnderecoRepository;
import one.digitalinnovation.gof.service.AlunoService;
import one.digitalinnovation.gof.service.ViaCepService;


@Service
public class AlunoServiceImpl implements AlunoService {


	@Autowired
	private AlunoRepository alunoRepository;
	@Autowired
	private EnderecoRepository enderecoRepository;
	@Autowired
	private ViaCepService viaCepService;
	


	@Override
	public Iterable<Aluno> buscarTodos() {

		return AlunoRepository.findAll();
	}

	@Override
	public Aluno buscarPorId(Long id) {

		Optional<Aluno> aluno = alunoRepository.findById(id);
		return aluno.get();
	}

	@Override
	public void inserir(Aluno aluno) {
		salvarAlunoComCep(aluno);
	}

	@Override
	public void atualizar(Long id, Aluno aluno) {

		Optional<Aluno> alunoBd = alunoRepository.findById(id);
		if (alunoBd.isPresent()) {
			salvarAlunoComCep(aluno);
		}
	}

	@Override
	public void deletar(Long id) {

		alunoRepository.deleteById(id);
	}

	private void salvarAlunoComCep(Aluno aluno) {

		String cep = aluno.getEndereco().getCep();
		Endereco endereco = enderecoRepository.findById(cep).orElseGet(() -> {

			Endereco novoEndereco = viaCepService.consultarCep(cep);
			enderecoRepository.save(novoEndereco);
			return novoEndereco;
		});
		aluno.setEndereco(endereco);

		alunoRepository.save(aluno);
	}

}
