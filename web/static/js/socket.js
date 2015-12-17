// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "deps/phoenix/web/static/js/phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("rooms:lobby", {})
let question = $("#question")
let question_title = $("#question-title")
let answers_index = []

channel.on("answercheck", payload => {
  console.log("answercheck", payload)
  $.each([0,1,2,3], function(index) {
    var line = $("li#line-answer-"+index)
    line.addClass("disabled")
    line.removeClass("light-green")
    line.removeClass("orange")
  })
  $.each(payload.answers, function(i, answer) {
    var counter = $("#answer-count-"+i)
    counter.empty()
    counter.append(answer.count)
  })
})

channel.on("answeropen", payload => {
  console.log("answeropen", payload)
  $.each([0,1,2,3], function(index) {
    var line = $("li#line-answer-"+index)
    line.removeClass("light-green")
    line.removeClass("orange")
  })
  $.each(answers_index, function() {
    var line = $("li#line-answer-"+this)
    line.addClass('orange')
  })
})

channel.on("proposed", payload => {
  answers_index = []
  $.each([0,1,2,3], function(index) {
    var solution_anchor = $("#answer-"+index)
    solution_anchor.empty()
    var counter = $("#answer-count-"+index)
    counter.empty()
    var line = $("li#line-answer-"+index)
    line.removeClass("disabled")
    line.removeClass("light-green")
    line.removeClass("orange")
  })
  question_title.empty()
  question_title.append(payload.question_title)
  question.empty()
  question.append(payload.question_body)
  $.each(payload.solutions, function(i, solution){
    var solution_anchor = $("#answer-"+i)
    solution_anchor.empty()
    solution_anchor.append(solution.body)
    var line = $("li#line-answer-"+i)
    line.on("click", function(event) {
      var name = $("#username").val()
      if ($('.disabled').length) {
        return false
      }
      console.log("push answer ", solution.id, " by " + name)
      channel.push("answer", {name: name, solution_id: solution.id})
      $(this).addClass('light-green')
      $.each([0,1,2,3], function(index) {
        $("li#line-answer-"+index).addClass("disabled")
      })
    })
    if (solution.correct === true) {
      answers_index.push(i)
    }
  })
})

channel.join()
  .receive("ok", resp => {
    answers_index = []
    question.empty()
    question_title.empty()
    question.append(resp.question_body)
    question_title.append(resp.question_title)
    if (resp.status === 'dead') {
      console.log("Joined successfully, but waiting", resp)
      question.empty()
      question_title.empty()
      question_title.append("次の問題から参加できます")
    } else {
      $.each(resp.solutions, function(i, solution){
        var solution_anchor = $("#answer-"+i)
        solution_anchor.empty()
        solution_anchor.append(solution.body)
        var line = $("li#line-answer-"+i)
        line.on("click", function(event) {
          var name = $("#username").val()
          if ($('.disabled').length) {
            return false
          }
          console.log("push answer ", solution.id, " by " + name)
          channel.push("answer", {name: name, solution_id: solution.id})
          $(this).addClass('light-green')
          $.each([0,1,2,3], function(index) {
            $("li#line-answer-"+i).addClass("disabled")
          })
        })
        if (solution.correct === true) {
          answers_index.push(i)
        }
      })
      console.log("Joined successfully", resp)
    }
  })
  .receive("error", resp => { console.log("Unable to join", resp) })


export default socket
