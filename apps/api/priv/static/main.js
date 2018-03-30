$(function () {

  hideAllPages();
  //render("/#/");
  render("/#/questions/new");
  function render(url) {
    var temp = url.split("/#/");
    temp = temp[1];

    var map = {

      '': function() {
              hideAllPages();
              renderQuestionListPage();
          },

      'questions/new': function() {
              hideAllPages();
              renderCreateNewQuestionPage();
          }

    };

    if(map[temp]){
      map[temp]();
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

  function renderQuestionVotingPage(data) {
    var page = $('#question-voting-page');
    page.css("display", "block");
  }

  function renderQuestionResultsPage(data) {
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

  function getAllQuestions() {
    $.ajax({
      url: '/api/questions',
      type: 'GET',
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


});
