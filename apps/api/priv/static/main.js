$(function () {

  var votingResultsChart = null;

  hideAllPages();
  render("/#/");

  $(window).on('hashchange', function(){
    uri = decodeURI(window.location.hash);
    if (uri == '') {
      uri = '#/';
    }
    render(uri);
  });

  function render(url) {
    var temp = url.split("#/")[1];
    var path = temp.split('/');
    var map = {

      '': function() {
              renderQuestionListPage();
          },

      'questions': function() {
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
      hideAllPages();
      map[path[0]]();
    }
  }

  function renderQuestionListPage() {
    var page = $('#question-list-page');
    page.css("display", "block");
    page.find(".new-question-button").click(function(e) {
      e.preventDefault();
      window.location.hash = "/questions/new";
    });
    getAllQuestions().then(function(questions) {
      generateQuestionList(questions);
    });
  }

  function renderCreateNewQuestionPage(data) {
    var page = $('#create-new-question-page');
    page.css("display", "block");
    var createQuestionButton = page.find(".create-question-button");
    createQuestionButton.unbind( "click" );
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
    var templateArea = page.find('.template-area');
    getQuestion(question_id).then(function(question){
        templateArea.empty();
        templateArea.append(template(JSON.parse(question)));
        templateArea.find(".vote-button").click(function() {
          var checkedAnswer = page.find("input[type='radio']:checked");
          voteForAnswer(checkedAnswer.val()).then(function() {
            window.location.hash = "/questions/" + question_id + "/results";
          });
        });
    });

  }

  function renderQuestionResultsPage(question_id) {
    var page = $('#question-results-page');
    page.css("display", "block");
    var context = page.find('#question-voting-results')[0].getContext('2d');
    getQuestion(question_id).then(function(question){
      question = JSON.parse(question);
      page.find(".question-title").text(question.question);
      if(votingResultsChart != null) {
        votingResultsChart.destroy();
      }
      votingResultsChart = new Chart(context, barChartData(question.answers));
    });
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
    var templateScript = $("#questions-list-template").html();
    var template = Handlebars.compile (templateScript);
    var questionsList = $('.questions-list');
    questionsList.html(template(JSON.parse(questions)));
    questionsList.find("a[question_id]").click(function() {
      question_id = $(this).attr("question_id");
      window.location.hash = "/questions/" + question_id;
    });
  }

  ////// API CALLS /////////

  function getAllQuestions() {
    return $.ajax({
      url: '/api/questions',
      type: 'GET'
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


  function barChartData(answers) {
    var labels = answers.map(function(answer) {return answer.answer;});
    var votes = answers.map(function(answer) {return answer.votes;});
    var data = {
      type: 'horizontalBar',
      data: {
        labels: labels,
        datasets: [{data: votes}]
      },
      options: {
         responsive: true,
         maintainAspectRatio: false,
         legend: {
            display: false
         },
         scales: {
            xAxes: [{
                ticks: {
                    beginAtZero: true
                }
            }]
        }
      }
    }
    return data;
  }

});
