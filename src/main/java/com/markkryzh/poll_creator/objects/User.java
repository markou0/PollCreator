package com.markkryzh.poll_creator.objects;

import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

public class User {
	final String ROLE_USER = "ROLE_USER";
	final String ROLE_ADMIN = "USER_ADMIN";
	private int id;
	@NotNull
	@Size(min = 3, max = 45, message = "username length must be between 3 and 45 symbols")
	private String username;
	@NotNull
	@Size(min = 6, max = 60, message = "password length must be between 6 and 60 symbols")
	private String password;
	private String confPassword;
	private int enabled = 1;
	private String avatar;
	private String role = ROLE_USER;
	private List<Question> pickedQuestions = new ArrayList<>();

	public User() {
		super();
	}

	public User(String userName, String password, String avatar) {
		super();
		this.username = userName;
		this.password = password;
		this.avatar = avatar;
	}

	public User(String userName, String password, String avatar, String role) {
		super();
		this.username = userName;
		this.password = password;
		this.avatar = avatar;
		this.role = role;
	}

	public String getAvatar() {
		return avatar;
	}

	public int getEnabled() {
		return enabled;
	}

	public int getId() {
		return id;
	}

	public String getPassword() {
		return password;
	}

	public List<Question> getPickedQuestions() {
		return pickedQuestions;
	}

	public String getRole() {
		return role;
	}

	public String getUsername() {
		return username;
	}

	public void setAvatar(String avatar) {
		this.avatar = avatar;
	}

	public void setEnabled(int enabled) {
		this.enabled = enabled;
	}

	public void setId(int id) {
		this.id = id;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public void setPickedQuestions(List<Question> pickedQuestions) {
		this.pickedQuestions = pickedQuestions;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public void setUsername(String name) {
		this.username = name;
	}

	public String getConfPassword() {
		return confPassword;
	}

	public void setConfPassword(String confPassword) {
		this.confPassword = confPassword;
	}
}
