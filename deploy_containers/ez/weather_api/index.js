const app = require('express')();
const PORT = 3001;

app.set('view engine', 'ejs');

app.get('/api/weather/:city', (req, res) => {
	if (req.params.city == 'ma') {
		res.render('index');
	} else {
		res.send('<html><body>Unsupported city :(</body></html>');
	}
});

module.exports = {
	app,
	PORT,
}
