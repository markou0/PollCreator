package com.markkryzh.poll_creator.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Component;

import com.markkryzh.poll_creator.objects.Answer;
import com.markkryzh.poll_creator.objects.Question;
import com.markkryzh.poll_creator.objects.User;

@Component
public class PostgreSqlDAOImpl implements PostgreSqlDAO {

	private static final class AnswerRowMapper implements RowMapper<Answer> {

		@Override
		public Answer mapRow(ResultSet rs, int rowNum) throws SQLException {
			Answer answer = new Answer();
			answer.setIdAnswer(rs.getInt("id_answer"));
			answer.setAnswer(rs.getString("answer"));
			answer.setIdQuestion(rs.getInt("id_question"));
			answer.setImage(rs.getString("image"));
			answer.setOther(rs.getBoolean("is_other"));
			answer.setVotes(rs.getInt("votes"));
			return answer;
		}

	}

	private final class QuestionRowMapper implements RowMapper<Question> {

		@Override
		public Question mapRow(ResultSet rs, int rowNum) throws SQLException {
			Question question = new Question();
			question.setQuestion(rs.getString("question"));
			question.setId(rs.getInt("id_question"));
			boolean isAnomius = rs.getBoolean("is_anonimius");
			question.setIsAnonimius(isAnomius);
			if (isAnomius) {
				question.setUserName("Anonym");
			} else
				question.setUserName(rs.getString("username"));
			if (question.getUserName().isEmpty())
				question.setUserName("User Deleted");
			question.setIsPublic(rs.getBoolean("is_public"));
			question.setCreated(rs.getDate("created"));
			question.setImage(rs.getString("image"));
			List<Answer> answers = getAnswers(question.getId());
			question.setAnswers(answers);
			for (Answer answer : answers) {
				question.incrementVotes(answer.getVotes());
			}
			return question;
		}

	}

	private final class UserRowMapper implements RowMapper<User> {

		@Override
		public User mapRow(ResultSet rs, int rowNum) throws SQLException {
			User user = new User();
			user.setUsername(rs.getString("username"));
			user.setPassword(rs.getString("password"));
			user.setEnabled(rs.getInt("enabled"));
			user.setRole(rs.getString("role"));
			user.setAvatar(rs.getString("avatar"));
			user.setPickedQuestions(getPickedQuestions(user.getUsername()));
			return user;
		}

	}

	private NamedParameterJdbcTemplate JdbcTemplate;
	private int questionsOnMainPageLimit = 20;

	public int getQuestionsOnMainPageLimit() {
		return questionsOnMainPageLimit;
	}

	public void setQuestionsOnMainPageLimit(int questionsOnMainPageLimit) {
		this.questionsOnMainPageLimit = questionsOnMainPageLimit;
	}

	@Override
	public void deleteAnswer(int answerId) {
		String sql = "DELETE FROM answers WHERE id_answer = :id_answer ";

		MapSqlParameterSource params = new MapSqlParameterSource();
		params.addValue("id_answer", answerId);

		JdbcTemplate.update(sql, params);

	}

	@Override
	public void deleteQuestion(int questionId) {
		String sql = "DELETE FROM questions WHERE id_question = :id_question ";

		MapSqlParameterSource params = new MapSqlParameterSource();
		params.addValue("id_question", questionId);

		JdbcTemplate.update(sql, params);
	}

	@Override
	public void deleteUser(String username) {
		String sql = "DELETE FROM users WHERE username = :username";

		MapSqlParameterSource params = new MapSqlParameterSource();
		params.addValue("username", username);

		JdbcTemplate.update(sql, params);
	}

	@Override
	public List<Answer> getAnswers(int questionId) {
		String sql = "SELECT * FROM answers WHERE id_question = :id_question ORDER BY id_answer";

		MapSqlParameterSource params = new MapSqlParameterSource();
		params.addValue("id_question", questionId);

		return JdbcTemplate.query(sql, params, new AnswerRowMapper());
	}

	@Override
	public Question getQuestion(int questionId) {
		if (!containsQuestion(questionId))
			return null;

		String sql = "select * from questions where id_question = :id_question";

		MapSqlParameterSource params = new MapSqlParameterSource();
		params.addValue("id_question", questionId);

		return JdbcTemplate.queryForObject(sql, params, new QuestionRowMapper());
	}

	/*
	 * public List<Question> getQuestions(Integer[] questionIds) { if
	 * (questionIds.length == 0) return new ArrayList<Question>(); String sql =
	 * "select * from questions where id_question in (:questionIds)";
	 * 
	 * System.out.println("before wraped in hash set" +
	 * Arrays.toString(questionIds)); // Set<Integer> questionIdsSet = new //
	 * HashSet<>(Arrays.asList(questionIds)); List<Integer> questionIdsList =
	 * Arrays.asList(questionIds); System.out.println("questionIdsSet" +
	 * questionIdsList); MapSqlParameterSource params = new
	 * MapSqlParameterSource(); params.addValue("questionIds", questionIdsList);
	 * 
	 * return JdbcTemplate.query(sql, params, new QuestionRowMapper()); }
	 */

	@Override
	public User getUser(String username) {

		if (!containsUser(username))
			return null;

		String sql = "select * from users join user_roles using(username) where username = :username";

		MapSqlParameterSource params = new MapSqlParameterSource();
		params.addValue("username", username);

		return JdbcTemplate.queryForObject(sql, params, new UserRowMapper());
	}

	@Override
	public List<Question> getUserQuestions(String username) {
		List<Question> questions = null;
		String sql = "SELECT * FROM questions WHERE username = :username";

		MapSqlParameterSource params = new MapSqlParameterSource();
		params.addValue("username", username);
		questions = JdbcTemplate.query(sql, params, new QuestionRowMapper());
		if (questions != null && !questions.isEmpty()) {

			Collections.sort(questions, new Comparator<Question>() {
				@Override
				public int compare(Question a, Question b) {
					return b.getCreated().compareTo(a.getCreated());
				}
			});
		}

		return questions;
	}

	@Override
	public int insertAnswer(Answer answer, int questionId) {
		String sqlInsertAnswer = "insert into answers VALUES ( default, :question_id, :answer, :is_other, default, :image)";

		MapSqlParameterSource params = new MapSqlParameterSource();

		params = new MapSqlParameterSource();

		params.addValue("question_id", questionId);
		params.addValue("answer", answer.getAnswer());
		params.addValue("is_other", answer.isOther());
		params.addValue("image", answer.getImage());

		KeyHolder keyHolder = new GeneratedKeyHolder();

		JdbcTemplate.update(sqlInsertAnswer, params, keyHolder);
		int answerId = (Integer) keyHolder.getKeys().get("id_answer");
		answer.setIdAnswer(answerId);
		return answerId;
	}

	@Override
	public void insertAnswers(List<Answer> answers, int questionId) {
		for (Answer answer : answers) {
			insertAnswer(answer, questionId);
		}
	}

	@Override
	public int insertQuestion(Question question) {
		String sqlInsertQuestion = "insert into questions VALUES ( default, :question, :username, :is_public, :is_anonimius, default, :image)";

		MapSqlParameterSource params = new MapSqlParameterSource();

		params = new MapSqlParameterSource();

		params.addValue("question", question.getQuestion());
		params.addValue("username", question.getUserName());
		params.addValue("is_public", question.getIsPublic());
		params.addValue("is_anonimius", question.getIsAnonimius());
		params.addValue("image", question.getImage());

		KeyHolder keyHolder = new GeneratedKeyHolder();
		int questionId;
		JdbcTemplate.update(sqlInsertQuestion, params, keyHolder);
		questionId = (Integer) keyHolder.getKeys().get("id_question");
		question.setId(questionId);
		question.setCreated((Date) keyHolder.getKeys().get("created"));
		insertAnswers(question.getAnswers(), questionId);
		return questionId;
	}

	@Override
	public void insertUser(User user) {

		String sqlInsertUser = "insert into users VALUES (:username, :password, :enabled, :avatar)";
		String sqlInserUserRole = "insert into user_roles VALUES ( default, :username, :role)";

		MapSqlParameterSource params = new MapSqlParameterSource();

		params = new MapSqlParameterSource();
		params.addValue("username", user.getUsername());
		params.addValue("password", user.getPassword());
		params.addValue("enabled", user.getEnabled());
		params.addValue("avatar", user.getAvatar());
		params.addValue("role", user.getRole());

		JdbcTemplate.update(sqlInsertUser, params);
		JdbcTemplate.update(sqlInserUserRole, params);
	}

	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.JdbcTemplate = new NamedParameterJdbcTemplate(dataSource);
	}

	/*
	 * public void updatePickedQuestions(User user) { List<Question>
	 * pickedQuestions = user.getPickedQuestions(); if (pickedQuestions == null)
	 * return; for (int i = 0; pickedQuestions.size() > 10; i++) {
	 * pickedQuestions.remove(pickedQuestions.size() - 1); } final String
	 * ARRAY_DATATYPE = "int4"; final String SQL_UPDATE =
	 * "UPDATE users SET picked_questions = ? WHERE username = ?"; final
	 * Integer[] questionIds = new Integer[pickedQuestions.size()]; { int i = 0;
	 * for (Question question : pickedQuestions) { questionIds[i++] =
	 * question.getId(); } } JdbcTemplate.getJdbcOperations().update(new
	 * PreparedStatementCreator() {
	 * 
	 * @Override public PreparedStatement createPreparedStatement( final
	 * Connection con) throws SQLException { final PreparedStatement ret =
	 * con.prepareStatement(SQL_UPDATE); ret.setArray(1,
	 * con.createArrayOf(ARRAY_DATATYPE, questionIds)); ret.setString(2,
	 * user.getUsername()); return ret; } }); }
	 */

	@Override
	public void updateUser(User user) {
		String sql = "UPDATE users SET password = :password, enabled = :enabled, avatar = :avatar WHERE username = :username";

		MapSqlParameterSource params = new MapSqlParameterSource();

		params = new MapSqlParameterSource();
		params.addValue("username", user.getUsername());
		params.addValue("password", user.getPassword());
		params.addValue("enabled", user.getEnabled());
		params.addValue("avatar", user.getAvatar());

		JdbcTemplate.update(sql, params);
	}

	@Override
	public boolean incrementQuestionVotes(String username, int id_answer) {
		String sql = "SELECT votes_increment( ?, ?)";
		return JdbcTemplate.getJdbcOperations().queryForObject(sql, Boolean.class, username, id_answer);
	}

	@Override
	public List<Question> getPopularQuestions() {
		List<Question> questions = null;
		String sql = "SELECT * FROM questions WHERE is_public AND id_question IN (SELECT id_question FROM answers GROUP BY id_question ORDER BY sum(votes) DESC LIMIT :limit)";
		MapSqlParameterSource params = new MapSqlParameterSource();
		params.addValue("limit", questionsOnMainPageLimit);
		questions = JdbcTemplate.query(sql, params, new QuestionRowMapper());
		if (questions != null && !questions.isEmpty()) {

			Collections.sort(questions, new Comparator<Question>() {
				@Override
				public int compare(Question a, Question b) {
					return Integer.compare(b.getTotalVotes(), a.getTotalVotes());
				}
			});
		}
		return questions;
	}

	@Override
	public List<Question> getNewestQuestions() {
		List<Question> questions = null;
		String sql = "SELECT * FROM questions WHERE is_public AND id_question IN (SELECT id_question FROM answers GROUP BY id_question ORDER BY sum(votes) DESC LIMIT :limit)";
		MapSqlParameterSource params = new MapSqlParameterSource();
		params.addValue("limit", questionsOnMainPageLimit);
		questions = JdbcTemplate.query(sql, params, new QuestionRowMapper());
		if (questions != null && !questions.isEmpty()) {

			Collections.sort(questions, new Comparator<Question>() {
				@Override
				public int compare(Question a, Question b) {
					return b.getCreated().compareTo(a.getCreated());
				}
			});
		}

		return questions;
	}

	@Override
	public boolean containsUser(String username) {
		String sql = "SELECT EXISTS(SELECT * FROM users where username = ?)";
		return JdbcTemplate.getJdbcOperations().queryForObject(sql, Boolean.class, username);
	}

	@Override
	public boolean containsQuestion(int questionId) {
		String sql = "SELECT EXISTS(SELECT * FROM questions where id_question = ?)";
		return JdbcTemplate.getJdbcOperations().queryForObject(sql, Boolean.class, questionId);
	}

	@Override
	public boolean containsAnswer(int answerId) {
		String sql = "SELECT EXISTS(SELECT * FROM answers where id_answer = ?)";
		return JdbcTemplate.getJdbcOperations().queryForObject(sql, Boolean.class, answerId);
	}

	@Override
	public boolean hasUserVoted(String username, int id_question) {
		String sql = "SELECT EXISTS (SELECT * FROM picked_polls WHERE username LIKE ? AND id_question = ?)";
		return JdbcTemplate.getJdbcOperations().queryForObject(sql, Boolean.class, username, id_question);
	}

	@Override
	public List<Question> getPickedQuestions(String username) {
		String sql = "SELECT q.id_question, q.question, q.username, q.is_public, q.is_anonimius, q.created, q.image, id_picked_poll FROM questions q FULL JOIN picked_polls p ON q.id_question = p.id_question WHERE p.username LIKE :username ORDER BY id_picked_poll DESC";
		MapSqlParameterSource params = new MapSqlParameterSource();
		params.addValue("username", username);
		return JdbcTemplate.query(sql, params, new QuestionRowMapper());
	}

}
