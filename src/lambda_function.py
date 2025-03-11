import os
import json
import urllib.request
import boto3
from datetime import datetime

def game_format(game):
    status = game.get("Status", "Unknown")
    away_team = game.get("AwayTeam", "Unknown")
    home_team = game.get("HomeTeam", "Unknown")
    final_score = f"{game.get('AwayTeamScore', 'N/A')}-{game.get('HomeTeamScore', 'N/A')}"
    start_time = game.get("DateTime", "Unknown")
    channel = game.get("Channel", "Unknown")
    quarters= game.get("Quarter",[])
    if(quarters):
        quarter_scores = ', '.join([f"Q{q['Number']}: {q.get('AwayScore', 'N/A')}-{q.get('HomeScore', 'N/A')}" for q in quarters])

    if status=="Final":
        return (f"game status:{status}\n"
                f"teams: {away_team} vs {home_team}\n"
                f"Score:{final_score}\n"
                f"Start time:{start_time}\n"
                f"Channels:{channel}\n"
                f"quarters :{quarter_scores}")

    elif status=="InProgress":
        return(
                f"game status:{status}\n"
                f"teams: {away_team} vs {home_team}\n"
                f"Current Score:{final_score}\n"
                f"Start time:{start_time}\n"
                f"Channels:{channel}\n")
        
    elif status=="Scheduled":
        last_plays=game.get("LastPlay")
        return(
                f"game status:{status}\n"
                f"teams: {away_team} vs {home_team}\n"
                f"Start time:{start_time}\n"
                f"last play :{last_plays}"
                f"Channels:{channel}\n")
    else:
        return(
                f"game status:{status}\n"
                f"teams: {away_team} vs {home_team}\n"
                f"more details soon !!"
                )
# get the env variable form the aws system manager
def get_env_var():
    ssm_client=boto3.client("ssm",region_name="us-east-1")
    response=ssm_client.get_parameter(Name="nba-api-key",WithDecryption=True)
    print(f"{response['Parameter']['Value']}")
    return response['Parameter']['Value']

def lambda_handler(event, context):
    #Environment variables 
    API_KEY=get_env_var()
    sns_client=boto3.client("sns")
    sns_topic=os.getenv("SNS_TOPIC_ARN")

    
    date = datetime.now().strftime("%Y-%m-%d")

    print(f"fetching games for date : {date}")

    
    api_url=f"https://api.sportsdata.io/v3/nba/scores/json/GamesByDate/{date}?key={API_KEY}"

    try:
        with  urllib.request.urlopen(api_url) as response:
            data=json.loads(response.read().decode())
            print(json.dumps(data, indent = 4 ))
    except Exception as e :
        print(f"error reading data : {e} ")
        return {"statuscode":"500","body":"Error fetching data"}

    games_messages = [game_format(game) for game in data]
    main_message = "\n****\n".join(games_messages)
    print(f"{main_message}")
  
#publish the main message in the sns service 
    try:
        sns_client.publish(
            TopicArn=sns_topic,
            Message=main_message,
            Subject="Nba notfication today's games"
        )
        print("notification sent to sns successfully")
    except Exception as e:
        print(f"cannot send the notification:{e}")
        return {"statusCode": 500, "body": "Error publishing to SNS"}
    
    return {"statusCode": 200, "body": "Data processed and sent to SNS"}   
     
if __name__=="__main__":
    lambda_handler() 
