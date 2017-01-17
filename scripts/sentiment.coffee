

module.exports = (robot) ->

    robot.hear /sentiment (.*)/i, (msg) ->
        sentiment = msg.match[1]
        data = JSON.parse(JSON.stringify("{ \"document\" : \"#{sentiment}\" }"))
        robot.http("https://api.algorithmia.com/v1/algo/nlp/SentimentAnalysis/1.0.2")
            .headers(Authorization: "Your Key Here", 'Content-Type': 'application/json')
            .post(data) (err, res, body) -> 
                reply = JSON.parse(body)
                result = reply.result[0]
                count = 0
                sentiment = 0
                sentiment_type = ''
                sentiment_count = ''
                sentiment_value = ''
                if (result.sentiment > 0) 
                    sentiment_count = 'positive_count'
                    sentiment_value = 'positive_sentiment'    
                    sentiment_type = 'Positive'
                else
                    sentiment_count = 'negative_count'
                    sentiment_value = 'negative_sentiment'
                    sentiment_type = 'Negative'

                count = (robot.brain.get(sentiment_count) * 1) + 1 or 0
                sentiment = (robot.brain.get(sentiment_value) * 1) + result.sentiment or 0
                robot.brain.set(sentiment_count, count)
                robot.brain.set(sentiment_value, sentiment)

                msg.send  "Avg Sentiment #{sentiment_type} #{sentiment / count} with count of #{count}" 

    robot.hear /sentiments about absa/i, (msg) ->
        sentiments = [{"document": "I have lost all faith in Absa Bank. I submitted my personal documents 6 days ago for a FICA verification and my account is still blocked. How pathetic"},{"document": "Two months ago I went to ABSA Bluff, to open a bank account for some money. I consultant with the name Rajiv Ramjiwan help me on the day. He saw a ring on my finger and asked if I was engaged and I was. He then advised me to join ABSA law because of a ANC contact, which they will then draw up ANC contract free of charge. And also advised me to take the highest one so I would not have any problems is the future. Then when I called ABSA law they told me they are unable to draw up my ANC contract as I was engaged before I signed the contract. I then phoned Rajiv Ramjiwan back to asked why he sold me the contract if he knew I was engaged before I signed the contract. He listen to my story and said sorry if that is there rules there is nothing he can do. I then told him that surly if you are marketing something you should no all the aspects and rules? He then said sorry he has a client with him and will phone me back later.... It has been 3 days now and I am still waiting for his phone call. ANC contract\"s are not cheap and have now not made provision for these extra cost."},{"document": "Had a great day until absa phoned me. 3 month back I got a loan by absa (great service there) but was told I need to open a chq account to get the loan. so I open one at the lowest monthly service rate because my salary get paid in to my netbank account. the bad bad service started when my first instalment had to go off it had to go of on my netbank account were my salary gets paid in no they try to take it from the absa chq account were there is no money in cost me to go in to the branch change it and pay it in manually what a story. now here comes the big bang. got a call after 2 month of forgetting that I have the absa chq account and I need to put in some money for the monthly service fee, telling me my account is a minus of R262 and I ask why so much no there is a penalty fee of R57. WHAT!!!! I ask why no one told me that,they said they only call after 2 month. O yes let make some f#*(! money out of this guy. BAD BAD BAD service atleast sms, email, letter telling the customer about the penalty fee and firstly tel them that when they open the account and not wait 2 to 3 month later after sitting back and making sum money for doing f%^@*ng no work. SO thanks for nothing."},{"document": "Is it really possible for a card to take 10 ten working days before it get delivered to the bank? this is crazy and very amazing. SHOCKED."}, {"document": "My fiancee is using Absa , the company RCCS BOS JHB just accessed money from a personal account, can ABSA please explain this kind of behaviour please. whether is the bank or its a scam doing this.. im so flippin angryyy"}]

        data = JSON.stringify(sentiments)
        
        robot.http("https://api.algorithmia.com/v1/algo/nlp/SentimentAnalysis/1.0.2")
            .headers(Authorization: "Your Key Here", 'Content-Type': 'application/json')
            .post(data) (err, res, body) -> 
                reply = JSON.parse(body)
                positive = 0
                positive_count = 0
                negative = 0
                negative_count = 0
                for key, val of reply.result
                    if (val.sentiment > 0) 
                        positive_count = positive_count + 1
                        positive = positive + val.sentiment
                    else
                        negative_count = negative_count + 1
                        negative = negative + val.sentiment
    
                msg.send "Average Sentiments Good(#{positive_count}) #{positive / positive_count} Bad(#{negative_count}) #{negative / negative_count} "
