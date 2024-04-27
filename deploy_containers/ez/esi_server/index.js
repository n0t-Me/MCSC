const app = require('express')();
const esiMiddleware = require('nodesi').middleware;
const process = require('process');
const PORT = 3000;

app.use(esiMiddleware({
	allowedHosts: [/^http:\/\/localhost(:\d{1,5})?(\/.*)?$/],
	onError: (src, err) => console.log(err),
}));

app.get('/', (req, res) => {
	if (!req.query.city) {
		res.redirect('/?city=ma');
	} else {
		let src = req.query.city;
		let debug = req.query.debug == 1 ? 1 : 0;

		if (src != 'ma') {
			// We do some logging :P
			console.log("[ESI LOG SRC]", req.ip, src);
		}

		if (debug != 0) {
			console.log("[ESI LOG DBG]", req.ip, debug);
		}

		req.esiOptions = {
			baseUrl: "http://localhost:3001/api/weather/",
		};

		if (debug == 1) {
			res.send(`<html><body><p>I got u this weather data :D (debug mode)</p>${src}</body></html>`);
		} else {
			if (!src.includes("http")) {
				res.send(`<html><body><p>I got u this weather data :D</p><esi:include src="${src}" /></body></html>`);
			} else {
				res.send(`<html><body><p> I got u this weather data :D</p><html><body>Invalid city??</body></html></body></html>`); // blocking http only is a clue to make it easier
			}
	}
	}

});

module.exports = {
	app,
	PORT,
}
