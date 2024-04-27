const app = require('express')();
const PORT = 80;

app.get('/', (req, res) => {
	console.log("[FLAG LOG]", req.ip);
	res.send("you did great :D 4d4353437b7333727633725f733164655f316e636c7573696f6e5f31735f7233344c5f737434795f73346665203a507d");
});

module.exports = {
	app,
	PORT,
}
