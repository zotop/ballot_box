$(function () {

  hideAllPages();
  render("/#/");
  function render(url) {
    var temp = url.split("/#/")[1];
    var path = temp.split('/');

    console.log("temp2", temp);
    console.log("path", path);
    var map = {

      '': function() {
              hideAllPages();
              renderQuestionListPage();
          },

      'questions': function() {
              hideAllPages();
              if (path[1] == "new") {
                  renderCreateNewQuestionPage();
              } else if (path[2] == "results") {
                  renderQuestionResultsPage(path[1]);
              } else {
                  renderQuestionVotingPage(path[1]);
              }
          }

    };

    if(map[path[0]]){
      map[path[0]]();
    }
  }

  function renderQuestionListPage(data) {
    getAllQuestions();
    var page = $('#question-list-page');
    page.css("display", "block");
  }

  function renderCreateNewQuestionPage(data) {
    var page = $('#create-new-question-page');
    page.css("display", "block");
    var createQuestionButton = page.find(".create-question-button");
    createQuestionButton.click(function(e) {
      e.preventDefault();
      question = page.find(".question-input").val();
      answers = collectAnswers(page);
      createQuestion(question, answers);
    });
  }

  function renderQuestionVotingPage(question_id) {
    var page = $('#question-voting-page');
    page.css("display", "block");
    var templateScript = $("#question-template").html();
    var template = Handlebars.compile (templateScript);
    getQuestion(question_id).then(function(question){
        page.append(template(JSON.parse(question)));
        page.find(".vote-button").click(function() {
          var checkedAnswer = page.find("input[type='radio']:checked");
          voteForAnswer(checkedAnswer.val()).then(function() {
            render("/#/questions/" + question_id + "/results");
          });
        });
    });

  }

  function renderQuestionResultsPage() {
    var page = $('#question-results-page');
    page.css("display", "block");
  }

  function hideAllPages() {
    $('#question-list-page').css("display", "none");
    $('#create-new-question-page').css("display", "none");
    $('#question-voting-page').css("display", "none");
    $('#question-results-page').css("display", "none");
  }

  function collectAnswers(page) {
    return page.find(".answer-input-text").map(function() {
      return $( this ).val();
    }).get();
  }

  function generateQuestionList(questions) {
    var questionsList = $('.questions-list');
    var templateScript = $("#questions-list-template").html();
    var template = Handlebars.compile (templateScript);
    questionsList.append(template(JSON.parse(questions)));
    questionsList.find("a[question_id]").click(function() {
      question_id = $(this).attr("question_id");
      render("/#/questions/" + question_id);
    });
  }

  function getAllQuestions() {
    $.ajax({
      url: '/api/questions',
      type: 'GET',
      success: function(response){
        console.log(response);
        alert('Success!');
        generateQuestionList(response);
      },
      error: function(error){
        console.log(error);
        alert("Failure!");
      }
    });
  }

  function createQuestion(question, answers) {
    $.ajax({
      url: '/api/questions',
      type: 'POST',
      data: JSON.stringify({ question: question, answers: answers }),
      contentType: "application/json; charset=utf-8",
      success: function(response){
        console.log(response);
        alert('Success!');
      },
      error: function(error){
        console.log(error);
        alert("Failure!");
      }
    });
  }

  function getQuestion(question_id) {
    return $.ajax({
      url: '/api/questions/' + question_id,
      type: 'GET'
    });
  }

  function voteForAnswer(answer_id) {
    return $.ajax({
      url: '/api/questions/vote',
      type: 'POST',
      data: JSON.stringify({ answer_id: answer_id }),
      contentType: "application/json; charset=utf-8"
    });
  }

});
