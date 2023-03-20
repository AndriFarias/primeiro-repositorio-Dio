package one.digitalinnovation.gof.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import one.digitalinnovation.gof.model.Aluno;
import one.digitalinnovation.gof.service.AlunoService;


@RestController
@RequestMapping("alunos")
public class AlunoRestController {

	@Autowired
	private AlunoService alunoService;

	@GetMapping
	public ResponseEntity<Iterable<Aluno>> buscarTodos() {
		return ResponseEntity.ok(alunoService.buscarTodos());
	}

	@GetMapping("/{id}")
	public ResponseEntity<Aluno> buscarPorId(@PathVariable Long id) {
		return ResponseEntity.ok(alunoService.buscarPorId(id));
	}

	@PostMapping
	public ResponseEntity<Aluno> inserir(@RequestBody Aluno aluno) {
		alunoService.inserir(aluno);
		return ResponseEntity.ok(aluno);
	}

	@PutMapping("/{id}")
	public ResponseEntity<Aluno> atualizar(@PathVariable Long id, @RequestBody Aluno aluno) {
		alunoService.atualizar(id, aluno);
		return ResponseEntity.ok(aluno);
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> deletar(@PathVariable Long id) {
		alunoService.deletar(id);
		return ResponseEntity.ok().build();
	}
}
