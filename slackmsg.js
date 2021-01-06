const axios = require('axios');

const slackToken = 'xoxp-1602532747590-1615473686708-1602552413590-67f6a64df4d05d65005905c97b33c2df';

run().catch(err => console.log(err));

async function run() {
  const url = 'https://slack.com/api/chat.postMessage';
  const res = await axios.post(url, {
    channel: '#notifications',
    username: 'alerts',
    icon_emoji: ':+1:',
    text: 'Hello, World! - auto msg from nodejs'
  }, { headers: { authorization: `Bearer ${slackToken}` } });

  console.log('Done', res.data);
}

