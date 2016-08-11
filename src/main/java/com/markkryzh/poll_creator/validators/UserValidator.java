package com.markkryzh.poll_creator.validators;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.markkryzh.poll_creator.dao.PostgreSqlDAO;
import com.markkryzh.poll_creator.objects.User;

@Component
public class UserValidator implements Validator {

	@Autowired
	private PostgreSqlDAO postgreSQLDAO;

	public boolean supports(Class<?> clazz) {
		return User.class.isAssignableFrom(clazz);
	}

	public void validate(Object target, Errors errors) {
		User user = (User) target;
		String password = user.getPassword();
		String confPassword = user.getConfPassword();

		if (!password.equals(confPassword)) {
			errors.rejectValue("password", "user.password.missMatch");
		}

		if (postgreSQLDAO.containsUser(user.getUsername())) {
			errors.rejectValue("username", "user.username.NonUnique");
		}
		;

	}

}
