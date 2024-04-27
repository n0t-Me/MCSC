const app = require('express')();
const { expressjwt } = require('express-jwt');
const jwt = require('jsonwebtoken');
const PORT = 3000;

const FLAG = "INSEC{Br3333333h_why_3m0jis_1n_k33y}";

const KEY = "So Secret! 🔥🌵"; // I liked the key xD

const INIT_TOKEN = jwt.sign({ role: 'guest' }, KEY);

app.use(expressjwt({
	secret: KEY,
	algorithms: ["HS256"],
	credentialsRequired:false
}));

app.use( (err, req, res, next) => {
	if (err.name == "UnauthorizedError") {
		console.log("[LOG JWT ERR]", req.ip);
		res.status(401).send("WTF r u trying to do???")
	} else {
		next(err);
	}
});

app.get('/', (req, res) => {
	if (!req.auth) {
		res.set('Authorization', "Bearer " + INIT_TOKEN);
		res.redirect('/');
	} else {
		const role = req.auth.role;
		if (role == 'guest') {
			res.send("Begone, unauthenticated peasant >:(");
		} else if (role == 'admin') {
			console.log("[LOG JWT FLAG]", req.ip);
			res.send(`Hello admin here is your flag :D ${FLAG}`);
		} else {
			console.log("[LOG JWT 418]", req.ip, req.auth);
			res.status(418);
			res.send("Don't hack me plz");
		}
	}
});

app.listen(PORT, () => {
	console.log(`App listening on port ${PORT}`);
	console.log(`INIT_TOKEN: ${INIT_TOKEN}`);
});
