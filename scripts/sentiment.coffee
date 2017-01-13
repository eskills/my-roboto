

module.exports = (robot) ->

    robot.hear /sentiment (.*)/i, (msg) ->
        sentence = msg.match[1]
        data = JSON.parse(JSON.stringify("{ \"document\" : \"#{sentence}\" }"))
        robot.http("https://api.algorithmia.com/v1/algo/nlp/SentimentAnalysis/1.0.2")
            .headers(Authorization: "You Key Here", 'Content-Type': 'application/json')
            .post(data) (err, res, body) -> 
                reply = JSON.parse(body)
                if reply.error
                    msg.send reply.error.message
                else
                    msg.send  "#{reply.result[0].document} (#{reply.result[0].sentiment})"
