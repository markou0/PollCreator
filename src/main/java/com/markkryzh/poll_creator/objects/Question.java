package com.markkryzh.poll_creator.objects;

import java.util.Date;
import java.util.List;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotEmpty;

public class Question {

	private int id;
	@NotNull
	@NotEmpty(message = "Question may not be empty")
	private String question;
	private String userName;
	private int totalVotes = 0;
	private boolean isPublic = true;
	private boolean isAnonimius = false;
	private List<Answer> answers;
	private Date created;
	private String image;

	public Question() {
		super();
	}

	public Question(String question, String userName, boolean isPublic,
			boolean isAnonimius, List<Answer> answers, String image) {
		super();
		this.question = question;
		this.userName = userName;
		this.isPublic = isPublic;
		this.isAnonimius = isAnonimius;
		this.answers = answers;
		this.image = image;
	}

	public Question(String question, String userName, List<Answer> answers,
			String image) {
		super();
		this.question = question;
		this.userName = userName;
		this.answers = answers;
		this.image = image;
	}

	public List<Answer> getAnswers() {
		return answers;
	}

	public Date getCreated() {
		return created;
	}

	public int getId() {
		return id;
	}

	public String getImage() {
		return image;
	}

	public String getQuestion() {
		return question;
	}

	public int getTotalVotes() {
		return totalVotes;
	}

	public void setTotalVotes(int answerVotes) {
		this.totalVotes = answerVotes;
	}

	public void incrementVotes(int answerVotes) {
		this.totalVotes += answerVotes;
	}

	public String getUserName() {
		return userName;
	}

	public boolean getIsAnonimius() {
		return isAnonimius;
	}

	public void setIsAnonimius(boolean isAnonimius) {
		this.isAnonimius = isAnonimius;
	}

	public boolean getIsPublic() {
		return isPublic;
	}

	public void setIsPublic(boolean isPublic) {
		this.isPublic = isPublic;
	}

	public void setAnswers(List<Answer> answers) {
		this.answers = answers;
	}

	public void setCreated(Date created) {
		this.created = created;
	}

	public void setId(int id) {
		this.id = id;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public void setQuestion(String question) {
		this.question = question;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
}
