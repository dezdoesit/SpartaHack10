import os
import requests
from uagents import Agent, Context, Model

agent = Agent(name="QuestionFetcher")

print(agent.address)

INTERVIEW_QUESTIONS_URL = "https://little-resonance-af2f.noshirt23penguin.workers.dev/"

AGENT_2_ADDRESS = "agent1qwqpl4m8kzc7mskuax8xstwcw9xdskxgpd5fzhw67zcxefdhax5kvycjnz8"

class QuestionRequest(Model):
    questions: str

def get_interview_questions():
    response = requests.get(INTERVIEW_QUESTIONS_URL)
    
    if response.status_code == 200:
        try:
            data = response.json()
            if isinstance(data, list) and "response" in data[0]:
                return data[0]["response"]
            return "No valid questions found in response."
        except Exception as e:
            return f"Error parsing JSON: {e}"
    return "Failed to retrieve interview questions."

@agent.on_interval(period=60)
async def fetch_and_send(ctx: Context):
    questions = get_interview_questions()

    if AGENT_2_ADDRESS:
        await ctx.send(AGENT_2_ADDRESS, QuestionRequest(questions=questions))
    else:
        ctx.logger.info("❌ Please set 'AGENT_2_ADDRESS' to a valid agent address.")

if __name__ == "__main__":
    agent.run()