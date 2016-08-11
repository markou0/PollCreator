package com.markkryzh.poll_creator.dao;

import java.util.List;

import com.markkryzh.poll_creator.objects.Answer;
import com.markkryzh.poll_creator.objects.Question;
import com.markkryzh.poll_creator.objects.User;

public interface PostgreSqlDAO {

	public void deleteAnswer(int answerId);

	public void deleteQuestion(int questionId);

	public void deleteUser(String username);

	public List<Answer> getAnswers(int questionId);

	public Question getQuestion(int questionId);

	public User getUser(String userName);

	public List<Question> getUserQuestions(String username);

	public int insertAnswer(Answer answer, int questionId);

	public void insertAnswers(List<Answer> answers, int questionId);

	public int insertQuestion(Question question);

	public void insertUser(User user);

	public List<Question> getPickedQuestions(String username);

	public void updateUser(User user);

	public boolean incrementQuestionVotes(String username, int id_answer);

	public boolean hasUserVoted(String username, int id_question);

	public List<Question> getPopularQuestions();

	public List<Question> getNewestQuestions();

	public boolean containsUser(String username);

	public boolean containsQuestion(int questionId);

	public boolean containsAnswer(int AnswerId);

}