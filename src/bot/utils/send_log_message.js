const { log_channel } = require('../constants');

const send_log_message = async (client, content) => {
    try {
        const channel = await client.channels.fetch(log_channel);
        if (channel && channel.isTextBased()) {
            await channel.send(content);
        }
    } catch (error) {
        console.error('Error sending log message:', error);
    }
};

module.exports = { send_log_message };
