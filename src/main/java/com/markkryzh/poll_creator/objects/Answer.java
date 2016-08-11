package com.markkryzh.poll_creator.objects;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotEmpty;

public class Answer {

	private int idAnswer;
	private int idQuestion;
	@NotNull
	@NotEmpty
	private String answer;
	private int votes;
	private boolean isOther = false;
	private String image;

	public Answer() {
		// TODO Auto-generated constructor stub
	}

	public Answer(String answer, boolean isOther, String image) {
		super();
		this.answer = answer;
		this.isOther = isOther;
		this.image = image;
	}

	public Answer(String answer, String image) {
		super();
		this.answer = answer;
		this.image = image;
	}

	public String getAnswer() {
		return answer;
	}

	public int getIdAnswer() {
		return idAnswer;
	}

	public int getIdQuestion() {
		return idQuestion;
	}

	public String getImage() {
		return image;
	}

	public int getVotes() {
		return votes;
	}

	public boolean isOther() {
		return isOther;
	}

	public void setAnswer(String answer) {
		this.answer = answer;
	}

	public void setIdAnswer(int idAnswer) {
		this.idAnswer = idAnswer;
	}

	public void setIdQuestion(int idQuestion) {
		this.idQuestion = idQuestion;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public void setOther(boolean isOther) {
		this.isOther = isOther;
	}

	public void setVotes(int votes) {
		this.votes = votes;
	}
}
