package com.markkryzh.poll_creator.controllers;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.markkryzh.poll_creator.dao.PostgreSqlDAO;
import com.markkryzh.poll_creator.objects.Answer;
import com.markkryzh.poll_creator.objects.Question;

@Controller
public class MainController {

	@Autowired
	private PostgreSqlDAO postgreSQLDAO;

	@RequestMapping(value = "/create_poll", method = RequestMethod.GET)
	public String newPoll(Model model, Principal principal) {
		Question question = new Question();
		model.addAttribute("question", question);
		return "create_poll";
	}

	@RequestMapping(value = "/create_poll", method = RequestMethod.POST)
	public ModelAndView createPoll(@Valid @ModelAttribute Question question,
			BindingResult bindingResult, HttpServletRequest request,
			Principal principal) {
		ModelAndView modelAndView = new ModelAndView("redirect:/poll/{pollId}");
		if (bindingResult.hasErrors()) {
			modelAndView.setViewName("/create_poll");
		}
		List<Answer> answers = new ArrayList<Answer>();
		for (int i = 1;; i++) {
			String answer = request.getParameter("answer_" + i);
			String image = request.getParameter("answer_image_" + i);
			if (answer == null)
				break;
			else if (!answer.isEmpty())
				answers.add(new Answer(answer, image));
		}
		question.setAnswers(answers);
		question.setUserName(principal.getName());
		modelAndView
				.addObject("pollId", postgreSQLDAO.insertQuestion(question));
		return modelAndView;
	}

	@RequestMapping(value = "/poll/{pollId}", method = RequestMethod.GET)
	public String getPoll(@PathVariable("pollId") int pollId,
			HttpServletRequest request, Model model, Principal principal) {
		String username = null;
		boolean voteDenied = false;
		if (principal != null)
			username = principal.getName();
		if (username == null || postgreSQLDAO.hasUserVoted(username, pollId)) {
			voteDenied = true;
		}
		;
		if (postgreSQLDAO.containsQuestion(pollId)) {

			Question question;
			Answer answer = new Answer();
			question = postgreSQLDAO.getQuestion(pollId);
			answer.setOther(true);
			model.addAttribute("question", question);
			model.addAttribute("answer", answer);

		}
		model.addAttribute("voteDenied", voteDenied);
		return "/poll";
	}

	@RequestMapping(value = "/poll/{pollId}/submit_poll", method = RequestMethod.POST)
	public ModelAndView submitVote(@PathVariable int pollId,
			@ModelAttribute Answer answer, Model model, Principal pricipal) {
		ModelAndView modelAndView = new ModelAndView(
				"redirect:/poll/{pollId}/poll_results");
		int answerId = answer.getIdAnswer();
		String username = pricipal.getName();
		if (!postgreSQLDAO.incrementQuestionVotes(username,
				answerId == -1 ? postgreSQLDAO.insertAnswer(answer, pollId)
						: answerId))
			modelAndView.setViewName("redirect:/poll/{pollId}");
		return modelAndView;
	}

	@RequestMapping(value = "/poll/{pollId}/poll_results", method = RequestMethod.GET)
	public ModelAndView pollResults(@PathVariable int pollId) {
		ModelAndView modelAndView = new ModelAndView("poll_results");
		Question question = postgreSQLDAO.getQuestion(pollId);
		List<Answer> answers = question.getAnswers();
		Collections.sort(answers, new Comparator<Answer>() {
			@Override
			public int compare(Answer a, Answer b) {
				return Boolean.compare(a.isOther(), b.isOther());
			}
		});
		modelAndView.addObject("question", question);
		return modelAndView;
	}

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView showMainPage() {
		ModelAndView modelAndView = new ModelAndView("main");
		modelAndView.addObject("popularQuestions",
				postgreSQLDAO.getPopularQuestions());
		modelAndView.addObject("newestQuestions",
				postgreSQLDAO.getNewestQuestions());
		return modelAndView;
	}

	@RequestMapping(value = "/personal_cabinet", method = RequestMethod.GET)
	public ModelAndView showPersonalCabinet(Principal principal) {
		ModelAndView modelAndView = new ModelAndView("personal_cabinet");
		String username = principal.getName();
		modelAndView.addObject("userQuestions",
				postgreSQLDAO.getUserQuestions(username));
		modelAndView.addObject("pickedQuestions",
				postgreSQLDAO.getUser(username).getPickedQuestions());
		return modelAndView;
	}
}
