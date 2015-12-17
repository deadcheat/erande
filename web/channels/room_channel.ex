defmodule Zohyothanksgiving.RoomChannel do
  use Zohyothanksgiving.Web, :channel

  alias Zohyothanksgiving.Solution
  alias Zohyothanksgiving.Answer

  def join("rooms:lobby", payload, socket) do
    if authorized?(payload) do
      proposed_questions = Repo.all Zohyothanksgiving.ProposedQuestion
      IO.inspect proposed_questions, pretty: true
      if length(proposed_questions) == 0 do
        {:ok, %{question_id: 0, question_title: "", question_body: "出題待ち", solutions: []}, socket}
      else
        [proposed_question] = Repo.preload proposed_questions, :question
        question = Repo.preload proposed_question.question, solutions: from(s in Solution, order_by: s.id)
        solutions = Repo.preload question.solutions, :collectanswer
        rs_solutions = Enum.map(solutions, fn(solution) -> %{id: solution.id, body: solution.body, correct: !is_nil(solution.collectanswer)} end)
        IO.inspect rs_solutions, pretty: true

        {:ok, %{question_id: question.id, question_title: question.title, question_body: question.body, solutions: rs_solutions}, socket}
      end
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("answer", %{"name" => name, "solution_id" => solution_id}, socket) do
    check = Repo.all(from(a in Answer, where: a.respondent == ^name and a.solution_id == ^solution_id))

    if length(check) == 0 do
      Repo.insert!(
        %Answer{
          solution_id: solution_id,
          respondent: name
        }
      )
    end

    {:noreply, socket}
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
